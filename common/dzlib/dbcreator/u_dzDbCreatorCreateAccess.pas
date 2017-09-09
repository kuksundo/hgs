///<summary> implements IdzDbCreator to create an access database as defined in
///          the given dbdescription </summary>
unit u_dzDbCreatorCreateAccess;

interface

uses
  SysUtils,
  Classes,
  Variants,
  ADOX_TLB,
  DAO_TLB,
  u_dzDbCreatorBase,
  u_dzDbCreatorDescription;

type
  TAdoxCatalog = ADOX_TLB._Catalog;
  TAdoxView = ADOX_TLB.View;
  TAdoxTable = ADOX_TLB._Table;
  TAdoxColumn = ADOX_TLB._Column;
  TAdoxIndex = ADOX_TLB._Index;
  TAdoxKey = ADOX_TLB._Key;

type
  TInterfaceContainer = class
    fInterface: IDispatch;
    constructor Create(_Interface: IDispatch);
    destructor Destroy; override;
  end;

const
  DbLevelAccess97 = 4;
  DbLevelAccess2000 = 5;

type
  TAccessDbCreator = class(TInterfacedObject, IdzDbCreator)
  private
    procedure AdjustTableName(var _TableName: string);
    procedure AdjustTableNames(var _Statement: string);
  protected
    FFilename: string;
    FLevel: integer;
    FPrefix: string;
    FSqlStatements: TStringList;
    FDbPassword: string;
    FAutoAdddzSystemTable: boolean;
    procedure CreateColumn(const _Catalog: TAdoxCatalog; const _Table: TAdoxTable; const _Column: IdzDbColumnDescription);
    function CreateTable(const _Catalog: TAdoxCatalog; const _Table: IdzDbTableDescription): TInterfaceContainer;
    procedure CreateTableIndices(const _Catalog: TAdoxCatalog; const _ComTable: TAdoxTable;
      const _Table: IdzDbTableDescription);
    procedure CreateTableKeys(const _Catalog: TAdoxCatalog; const _ComTable: TAdoxTable;
      const _Table: IdzDbTableDescription);
    procedure InsertTableData(const _DbDescription: IdzDbDescription; const _Table: IdzDbTableDescription);
    procedure ExecSqlStatements;
    procedure AddDbDesc(const _DbDescription: IdzDbDescription);
  protected // implements IdzDbCreator
    procedure WriteDbDesc(const _DbDescription: IdzDbDescription; const _Version: IdzDbVersionNTypeAncestor; _CreateOnlyNewObjectTables: Boolean);
  public
     ///<summary> Level: 4 = Access 97, 5 = Access 2000 </summary>
    constructor Create(const _Filename: string; _Level: integer;
      const _DbPassword: string = ''; _AutoAdddzSystemTable: boolean = false);
    destructor Destroy; override;
    class procedure CompressDatabase(const _Filename, _Password: string);
  end;

implementation

uses
  Windows,
  Dialogs,
  Messages,
  StrUtils,
  AdoDb,
  u_dzFileUtils,
  u_dzStringUtils,
  u_dzMiscUtils;

type
  TSortOrderMapping = array[TSortOrder] of integer;
  TDataTypeMapping = array[TFieldDataType] of integer;

const
  DATA_TYPE_MAPPING: TDataTypeMapping = (
    adInteger, adDouble, adVarWChar, adLongVarWChar, adDate, adGUID);
  SORT_ORDER_MAPPING: TSortOrderMapping = (adSortAscending, adSortDescending);

const
  DATA_SOURCE_SDS = 'Provider=Microsoft.Jet.OLEDB.4.0;'
    + 'Data Source=%s;'
    + 'Jet OLEDB:Engine Type=%d;'
    + 'Jet OLEDB:Database Password="%s"';
  DATA_DSN_SS = 'Provider=Microsoft.Jet.OLEDB.4.0;'
    + 'Data Source=%s;'
    + 'Mode=Share Deny None;'
    + 'Jet OLEDB:Database Password="%s"';
  DAO_PASSWD_S = ';pwd="%s"';

  { TAccessDbCreator }

constructor TAccessDbCreator.Create(const _Filename: string; _Level: integer;
  const _DbPassword: string = ''; _AutoAdddzSystemTable: boolean = false);
begin
  inherited Create;
  FFilename := _Filename;
  FLevel := _Level;
  FSqlStatements := TStringList.Create;
  FDbPassword := _DbPassword;
  FAutoAdddzSystemTable := _AutoAdddzSystemTable;
end;

destructor TAccessDbCreator.Destroy;
begin
  FSqlStatements.Free;
  inherited;
end;

procedure TAccessDbCreator.CreateColumn(const _Catalog: TAdoxCatalog;
  const _Table: TAdoxTable; const _Column: IdzDbColumnDescription);
var
  ComColumn: TAdoxColumn;
begin
  ComColumn := CoColumn.Create;
  ComColumn.ParentCatalog := _Catalog;
  ComColumn.Name := Format('%s%s', [FPrefix, _Column.Name]);
  ComColumn.Type_ := DATA_TYPE_MAPPING[_Column.DataType];
  if _Column.DataType in [dtMemo, dtText] then
    ComColumn.DefinedSize := _Column.Size;
  ComColumn.Properties['Nullable'].Value := (_Column.AllowNull = naNull);
  ComColumn.Properties['Description'].Value := _Column.Comment;
  { TODO -otwm -cbug : This apparently doesn't work, at least not for text and integer fields. }
  if not VarIsNull(_Column.DefaultValue) then
    ComColumn.Properties['Default'].Value := _Column.DefaultValue;
  ComColumn.Properties['AutoIncrement'].Value := _Column.AutoInc;
  // this is a very odd property, I think it makes sense to allow it only if null is also allowed
  ComColumn.Properties['Jet OLEDB:Allow Zero Length'].Value := (_Column.AllowNull = naNull);

  _Table.Columns.Append(ComColumn, Unassigned, Unassigned);
end;

function TAccessDbCreator.CreateTable(const _Catalog: TAdoxCatalog; const _Table: IdzDbTableDescription): TInterfaceContainer;
var
  ci: integer;
  Column: IdzDbColumnDescription;
  ComTable: TAdoxTable;
begin
  ComTable := CoTable.Create;
  ComTable.Name := Format('%s%s', [FPrefix, _Table.Name]);
  ComTable.ParentCatalog := _Catalog;
  for ci := 0 to _Table.ColumnCount - 1 do begin
    Column := _Table.Columns[ci];
    CreateColumn(_Catalog, ComTable, Column);
  end;
  _Catalog.Tables.Append(ComTable);
  Result := TInterfaceContainer.Create(ComTable);
end;

procedure TAccessDbCreator.CreateTableIndices(const _Catalog: TAdoxCatalog;
  const _ComTable: TAdoxTable; const _Table: IdzDbTableDescription);
var
  ii, ci: integer;
  Index: IdzDbIndexDescription;
  Column: IdzDbColumnDescription;
  ComIndex: TAdoxIndex;
  IdxName, ColName: string;
  ComColumn: TAdoxColumn;
begin
  for ii := 0 to _Table.IndiceCount - 1 do begin
    Index := _Table.Indices[ii];

    IdxName := Format('IX_%s%s', [FPrefix, Index.Name]);

    ComIndex := ADOX_TLB.CoIndex.Create;
    ComIndex.Name := IdxName;
    ComIndex.Unique := Index.IsUniq;
    ComIndex.PrimaryKey := Index.IsPrimaryKey;
    ComIndex.IndexNulls := adIndexNullsDisallow;
    for ci := 0 to Index.GetColumnCount - 1 do begin
      Column := Index.Column[ci];
      ColName := Format('%s%s', [FPrefix, Column.Name]);
      ComIndex.Columns.Append(ColName, DATA_TYPE_MAPPING[Column.DataType], Column.Size);
      ComColumn := ComIndex.Columns[ColName];
      ComColumn.ParentCatalog := _Catalog;
      ComColumn.SortOrder := SORT_ORDER_MAPPING[Index.ColumnSortorder[ci]];
    end;
    _ComTable.Indexes.Append(ComIndex, EmptyParam);
  end;
  // Columns which are null will not have an index entry.
  // adIndexNullsDisallow is the default.
  //IndexNulls := adIndexNullsDisallow;
  // Specify whether the index is clustered.  The default is false.
  // Access does not support clustering, but SQL Server does.
  //Clustered := false;
end;

procedure dzAssert(_Condition: boolean; _Message: string = '');
begin
  if not _Condition then begin
    if _Message = '' then
      _Message := 'Assertion failed.';
    raise Exception.Create(_Message);
  end;
end;

procedure TAccessDbCreator.CreateTableKeys(const _Catalog: TAdoxCatalog;
  const _ComTable: TAdoxTable; const _Table: IdzDbTableDescription);
var
  ci: integer; // column index
  Column: IdzDbColumnDescription;
  ComKey: TAdoxKey;
  KeyName: string;
  ColName: string;
  TabName: string;
  ForTabName: string;
  ForColName: string;
  ForTable: IdzDbTableDescription;
begin
  TabName := Format('%s%s', [FPrefix, _Table.Name]);
  for ci := 0 to _Table.ColumnCount - 1 do begin
    Column := _Table.Columns[ci];
    if Column.IsForeignKey then begin
      ComKey := CoKey.Create;
      ColName := Format('%s%s', [FPrefix, Column.Name]);
      ForTable := Column.ForeignKeyTable;
      dzAssert(Assigned(ForTable.PrimaryKey), Format('Foreign keys on tables without a primary key are not supported (refTable: %s)', [ForTable.Name]));
      dzAssert(ForTable.PrimaryKey.ColumnCount = 1, 'Foreign keys on tables with a multi field primary key are not supported');
      ForTabName := Format('%s%s', [FPrefix, ForTable.Name]);
      ForColName := Format('%s%s', [FPrefix, ForTable.PrimaryKey.Column[0].Name]);
      dzAssert(Column.ForeignKeyColumn.DataType = Column.DataType, 'data type of foreign key and primary key of referenced table do not match');
      KeyName := Format('%s%s_%s_%s', [FPrefix, _Table.Name, Column.Name, ForColName]);
      if Length(KeyName) > 50 - 4 then
        KeyName := TailStr(KeyName, 50 - 4);
      KeyName := 'FK_' + KeyName;

      ComKey.Name := KeyName;
      ComKey.Type_ := adKeyForeign;
      ComKey.RelatedTable := ForTabName;

      ComKey.Columns.Append(ColName, DATA_TYPE_MAPPING[Column.DataType], Column.Size);
      ComKey.Columns[ColName].RelatedColumn := ForColName;
      ComKey.DeleteRule := adRICascade;
      ComKey.UpdateRule := adRICascade;

      _ComTable.Keys.Append(ComKey, Unassigned, EmptyParam, Unassigned, Unassigned);
    end;
  end;
end;

procedure TAccessDbCreator.AddDbDesc(const _DbDescription: IdzDbDescription);
var
  i: integer;
  Table: IdzDbTableDescription;
  AdoxCatalog: TAdoxCatalog;
  DataSource: string;
begin
  FPrefix := _DbDescription.Prefix;
  exit; // ***** exit!! ****

  // Level: 4 = Access 97, 5 = Access 2000
  DataSource := Format(DATA_SOURCE_SDS, [FFilename, FLevel, FDbPassword]);
  AdoxCatalog := CoCatalog.Create;
  AdoxCatalog.Create(DataSource);

  Table := _DbDescription.CreateTable(Format('%sdzSystem', [FPrefix]), 'dz system table');
  Table.AppendColumn('name', dtText, 255, 'Name of entry', naNotNull);
  Table.AppendColumn('value', dtText, 255, 'Value of netry', naNull);
  CreateTable(AdoxCatalog, Table);

  { TODO -otwm : Automatically Add values to that table, e.g. ProgIdentifier, ProgName etc. }

  for i := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.Tables[i];
      // save COM Object
    Table.Data := CreateTable(AdoxCatalog, Table);
  end;

  AdoxCatalog.Tables.Refresh;

  for i := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.Tables[i];
    CreateTableIndices(AdoxCatalog, TInterfaceContainer(Table.Data).fInterface as TAdoxTable, Table);
  end;

  for i := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.Tables[i];
    CreateTableKeys(AdoxCatalog, TInterfaceContainer(Table.Data).fInterface as TAdoxTable, Table);
      // free COM Object
    TInterfaceContainer(Table.Data).Free;
    Table.Data := nil;
  end;
  AdoxCatalog := nil;

  FSqlStatements.Assign(_DbDescription.SqlStatements);
end;

class procedure TAccessDbCreator.CompressDatabase(const _Filename, _Password: string);
const
  DB_LANG_GENERAL = ';LANGID=0x0809;CP=1252;COUNTRY=0';
var
  DBEngine: TDBEngine;
  TmpFile: string;
  s: string;
begin
  { TODO -otwm -cbug : This does not work!! }
  s := DB_LANG_GENERAL + Format(DAO_PASSWD_S, [_Password]);
  TmpFile := TFileSystem.GetTempFileName;
  DBEngine := TDBEngine.Create(nil);
  try
    DbEngine.CompactDatabase(_Filename, TmpFile, s, dbEncrypt);
    CopyFile(PChar(TmpFile), PChar(_Filename), true);
  finally
    DBEngine.Free;
  end;
end;

procedure TAccessDbCreator.AdjustTableName(var _TableName: string);
begin
  _TableName := Format('[%s]', [_Tablename]);
end;

procedure TAccessDbCreator.AdjustTableNames(var _Statement: string);
var
  Start: integer;
  Ende: integer;
  TableName: string;
begin
  Start := Pos('$(', _Statement);
  while Start > 0 do begin
    Ende := Start + 2;
    while (Ende <= Length(_Statement)) and (_Statement[Ende] <> ')') do
      Inc(Ende);
    if Ende > Length(_Statement) then
      exit;
    TableName := Copy(_Statement, Start + 2, Ende - Start - 2);
    AdjustTableName(TableName);
    _Statement := LeftStr(_Statement, Start - 1) + TableName + TailStr(_Statement, Ende + 1);
    Start := Pos('$(', _Statement);
  end;
end;

procedure TAccessDbCreator.ExecSqlStatements;
var
  Connection: TAdoConnection;
  qry: TAdoQuery;
  i: integer;
  s: string;
begin
  if FSqlStatements.Count = 0 then
    exit;

  Connection := TAdoConnection.Create(nil);
  try
    Connection.ConnectionString := Format(DATA_DSN_SS, [FFilename, FDbPassword]);
    Connection.LoginPrompt := false;
    qry := TAdoQuery.Create(nil);
    try
      qry.Connection := Connection;
      for i := 0 to FSqlStatements.Count - 1 do begin
        s := FSqlStatements[i];
        AdjustTableNames(s);
        qry.SQL.Text := s;
        qry.ExecSQL;
      end;
    finally
      qry.Free;
    end;
  finally
    Connection.Free;
  end;
end;

procedure TAccessDbCreator.InsertTableData(const _DbDescription: IdzDbDescription;
  const _Table: IdzDbTableDescription);
var
  Connection: TAdoConnection;
  tbl: TAdoTable;
  RowIdx: integer;
  FieldIdx: integer;
  Row: IdzDbTableRow;
  s: string;
begin
  if _Table.RowCount = 0 then
    exit;

  Connection := TAdoConnection.Create(nil);
  try
    Connection.ConnectionString := Format(DATA_DSN_SS, [FFilename, FDbPassword]);
    Connection.LoginPrompt := false;
    tbl := TADOTable.Create(nil);
    try
      tbl.Connection := Connection;
      tbl.TableDirect := true;
      tbl.TableName := _DbDescription.Prefix + _Table.Name;
      tbl.Open;
      try
        for RowIdx := 0 to _Table.RowCount - 1 do begin
          tbl.Insert;
          try
            Row := _Table.Rows[RowIdx];
            for FieldIdx := 0 to Row.Count - 1 do begin
              if Row.IsNull(FieldIdx) then
                // in theory it should be possible to set the field to NULL, but apparently
                // Access distinguishes between NULL and not assigned
//                tbl.Fields[FieldIdx].Value := null
              else if not _Table.Columns[FieldIdx].AutoInc then
                tbl.Fields[FieldIdx].Value := Row.Value[FieldIdx];
            end;
            tbl.Post;
          except
            on e: Exception do begin
              tbl.Cancel;
              s := '';
              for FieldIdx := 0 to Row.Count - 1 do begin
                if s <> '' then
                  s := s + ';';
                if row.IsNull(FieldIdx) then
                  s := s + '*NULL*'
                else
                  s := s + Row.Value[FieldIdx];
              end;
              raise Exception.CreateFmt('Error "%s" (%s) while trying to insert'#13#10
                + '%s'#13#10
                + 'into table %s', [e.Message, e.ClassName, s, tbl.TableName]);
            end;
          end;
        end;
      finally
        tbl.Close;
      end;
    finally
      tbl.Free;
    end;
  finally
    Connection.Free;
  end;
end;

procedure TAccessDbCreator.WriteDbDesc(
  const _DbDescription: IdzDbDescription;
  const _Version: IdzDbVersionNTypeAncestor; _CreateOnlyNewObjectTables: Boolean);
var
  i: integer;
  Table: IdzDbTableDescription;
  AdoxCatalog: TAdoxCatalog;
  DataSource: string;
  IntContainer: TInterfaceContainer;
begin
  FPrefix := _DbDescription.Prefix;
  // Level: 4 = Access 97, 5 = Access 2000
  DataSource := Format(DATA_SOURCE_SDS, [FFilename, FLevel, FDbPassword]);
  AdoxCatalog := CoCatalog.Create;
  try
    AdoxCatalog.Create(DataSource);

    if FAutoAdddzSystemTable then begin
      Table := _DbDescription.CreateTable('dzSystem', 'dz system table');
      Table.AppendColumn('name', dtText, 255, 'Name of entry', naNotNull);
      Table.AppendColumn('value', dtText, 255, 'Value of netry', naNull);
      IntContainer := CreateTable(AdoxCatalog, Table);
      { TODO -otwm : Automatically Add values to that table, e.g. ProgIdentifier, ProgName etc. }
      IntContainer.Free;
    end;

    for i := 0 to _DbDescription.TableCount - 1 do begin
      Table := _DbDescription.Tables[i];
        // save COM Object
      Table.Data := CreateTable(AdoxCatalog, Table);
    end;

    AdoxCatalog.Tables.Refresh;

    for i := 0 to _DbDescription.TableCount - 1 do begin
      Table := _DbDescription.Tables[i];
      CreateTableIndices(AdoxCatalog, TInterfaceContainer(Table.Data).fInterface as TAdoxTable, Table);
    end;

    for i := 0 to _DbDescription.TableCount - 1 do begin
      Table := _DbDescription.Tables[i];
      CreateTableKeys(AdoxCatalog, TInterfaceContainer(Table.Data).fInterface as TAdoxTable, Table);
    end;

  finally
    for i := 0 to _DbDescription.TableCount - 1 do begin
      Table := _DbDescription.Tables[i];
      // free COM Object
      TInterfaceContainer(Table.Data).Free;
      Table.Data := nil;
    end;
    AdoxCatalog := nil;
  end;

  // This is a workaround for the problem that ADO doesn't seem to know
  // about the tables immediately after creation: "The Microsoft JET Database engine
  // cannot find the table Xyz..."
  // Waiting for 1 Second apparently is enough for it to finish creating it
  Sleep(1000);

  for i := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.TopologicalSortedTables[i];
    InsertTableData(_DbDescription, Table);
  end;

  FSqlStatements.Assign(_DbDescription.SqlStatements);
  ExecSqlStatements;
end;

{ TInterfaceContainer }

constructor TInterfaceContainer.Create(_Interface: IDispatch);
begin
  inherited Create;
  fInterface := _Interface;
end;

destructor TInterfaceContainer.Destroy;
begin
  fInterface := nil;
  inherited;
end;

end.


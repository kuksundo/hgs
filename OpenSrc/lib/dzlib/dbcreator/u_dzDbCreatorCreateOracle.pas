unit u_dzDbCreatorCreateOracle;

interface

///<summary> Creates a script for creating an oracle database
/// the following Database Installer variables are required:
/// DBI_SCHEMA_NAME
/// DBI_SCHEMA_SUFFIX </summary>

uses
  SysUtils,
  Classes,
  Variants,
  u_dzDbCreatorBase,
  u_dzDbCreatorDescription;

type
  ECreateOracleDb = class(Exception);
  ENameTooLong = class(ECreateOracleDb);
  EOnlyOneLong = class(ECreateOracleDb);

type
  TOracleDbCreator = class
  public
    class function DatabaseTypeName: string;

    class function Create(const _Statements: TStringList): IdzDbCreator; overload;
    class function Create(const _Statements, _IncludeSl, _ModuleSl: TStringList): IdzDbCreator; overload;
  end;

implementation

uses
  u_dzFileStreams,
  u_dzClassUtils,
  u_dzMiscUtils,
  u_dzStringUtils,
  u_dzSqlScriptWriter,
  u_dzScriptPositionList;

const
  DATA_TYPE_MAPPING: TDataTypeMapping = (
    'INT', {dtLongInt}
    'FLOAT', {dtDouble}
    'VARCHAR2', {dtText}
    'LONG', {dtMemo}
    'DATE', {dtDate}
    'GUID'); {dtGuid} { TODO -otwm -ccheck : does Oracle actually support this type?? }

  NULL_ALLOWED_MAPPING: TNullAllowedMapping = (
    'NOT NULL', 'NULL');
  DATA_TYPES_WITH_SIZE = [dtText];

type
  TOracleIncludeWriter = class
  protected
    FIncludeSl: TStringList;
    FModuleSl: TStringList;
    FLines: TStringList;
    procedure Write(_Sl: TStringList; const _S: string);
    procedure WriteLine(const _TableName: string = ''; const _SequenceName: string = '');
    procedure WriteIncludeLine(const _Line: string);
    procedure WriteModuleLine(const _Line: string);
    procedure WriteModuleHeader();
    procedure WriteModuleFooter();
  public
    constructor Create(const _IncludeSl, _ModuleSl: TStringList);
    destructor Destroy; override;
  end;

type
  TRealOracleDbCreator = class(TdzSqlDbCreator, IdzDbCreator)
  private
    procedure CheckDbDescription(const _DbDescription: IdzDbDescription);
    function AddSchemaPrefix(const _Name: string): string;
    function AddSchemaAndPrefix(const _DbDescription: IdzDbDescription; const _TableName: string): string;
    function AddSchema(const _Name: string): string;
    function AddPrefix(const _DbDescription: IdzDbDescription; const _Name: string): string;
    function AddPrefixAndShemaPrefix(
      const _DbDescription: IdzDbDescription; const _Name: string): string;
  protected
    FIncludeWriter: TOracleIncludeWriter;
    FIncludeSl: TStringList;
    FModuleSl: TStringList;

    procedure WriteCreateTables(const _DbDescription: IdzDbDescription); override;

    function MaxIdentifierLength: integer; override;
    function MakeSequenceName(const _Table, _Column: string): string;
    procedure WriteSqlDataStatements(const _DbDescription: IdzDbDescription; _ScriptWriter: ISqlScriptWriter); override;
    procedure WriteDbDesc(const _DbDescription: IdzDbDescription; const _Version: IdzDbVersionNTypeAncestor);
  public
    constructor Create(const _Statements: TStringList); overload;
    constructor Create(const _Statements, _IncludeSl, _ModuleSl: TStringList); overload;
    destructor Destroy; override;
    procedure GetIncludeFileContent(_st: TStrings);
  end;

{ TRealOracleDbCreator }

function TRealOracleDbCreator.MakeSequenceName(const _Table, _Column: string): string;
begin
  Result := MakeName('Seq', _Table, _Column);
end;

procedure TRealOracleDbCreator.WriteCreateTables(const _DbDescription: IdzDbDescription);

  procedure AddSequence(const _DbDescription: IdzDbDescription; const _TableName: string; const _ColName: string;
    _StartIdx: integer);
  var
    SequenceName: string;
  begin
    SequenceName := MakeSequenceName(_TableName, _ColName);
    FIncludeWriter.WriteLine(AddPrefix(_DbDescription, _TableName), SequenceName);
    FScriptWriter.WriteTermLine(spCreateSequences, Format('CREATE SEQUENCE %s INCREMENT BY 1 START WITH %d', [AddSchema(SequenceName), _StartIdx]));

    FScriptWriter.WriteTermLine(spDropSequences, Format('DROP SEQUENCE %s', [AddSchema(SequenceName)]));
  end;

var
  ti: integer;
  ci: integer;
  ii: integer;
  TableName: string;
  IndexName: string;
  LastIdx: integer;
  ColName: string;
  ColTyp: string;
  ColSize: string;
  ColNull: string;
  ColUnique: string;
  ColDefaultVal: string;
  Line: string;
  s: string;
  Index: IdzDbIndexDescription;
  Table: IdzDbTableDescription;
  Column: IdzDbColumnDescription;
  ColList, RefTableName, RefList: string;
begin
  for ti := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.Tables[ti];
    TableName := AddSchemaAndPrefix(_DbDescription, Table.Name);

    FScriptWriter.WriteLine(spCreateTables, Format('CREATE TABLE %s (', [TableName]));

    LastIdx := Table.ColumnCount - 1;
    for ci := 0 to LastIdx do begin
      Column := Table.Columns[ci];

      ColName := Format('%s ', [AddPrefix(_DbDescription, Column.Name)]);

      if Column.AutoInc then
        AddSequence(_DbDescription, Table.Name, Column.Name, Column.GetStartIdx);

      ColTyp := Format('%s', [DATA_TYPE_MAPPING[Column.DataType]]);
      if Column.DataType in DATA_TYPES_WITH_SIZE then
        ColSize := Format('(%d) ', [Column.Size])
      else
        ColSize := ' ';

      ColNull := Format('%s ', [NULL_ALLOWED_MAPPING[Column.AllowNull]]);

      if Column.GetDefaultString(s) then begin
        ColDefaultVal := Format('DEFAULT ''%s'' ', [s]);
      end else
        ColDefaultVal := '';

      Line := Format('  %s%s%s%s%s%s', [ColName, ColTyp, ColSize, ColDefaultVal, ColNull, ColUnique]);

      if ci <> LastIdx then
        Line := Line + ',';

      FScriptWriter.WriteLine(spCreateTables, Line);
    end;

    for ii := 0 to Table.IndiceCount - 1 do begin
      Index := Table.Indices[ii];

      if Index.ColumnCount > 0 then begin
        ColList := Format('%s', [AddPrefix(_DbDescription, Index.Column[0].Name)]);
        for ci := 1 to Index.ColumnCount - 1 do begin
          ColList := ColList + Format(', %s', [AddPrefix(_DbDescription, Index.Column[ci].Name)]);
        end;
      end else
        continue;

      if Index.IsPrimaryKey then begin
        IndexName := AddPrefixAndShemaPrefix(_DbDescription, MakePkName(Table.Name, Index.Name));

        FScriptWriter.WriteTermLine(spCreateIndices, Format('CREATE UNIQUE INDEX %s ON %s (%s)', [IndexName, TableName, ColList]));

        FScriptWriter.WriteLine(spCreatePrimaryKeys, Format('ALTER TABLE %s ADD', [AddSchemaAndPrefix(_DbDescription, Table.Name)]));
        FScriptWriter.WriteTermLine(spCreatePrimaryKeys, Format('  CONSTRAINT %s PRIMARY KEY (%s)', [IndexName, AddPrefix(_DbDescription, ColList)]));

        FScriptWriter.WriteLine(spDropPrimaryKeys, Format('ALTER TABLE %s DROP', [AddSchemaAndPrefix(_DbDescription, Table.Name)]));
        FScriptWriter.WriteTermLine(spDropPrimaryKeys, Format('  CONSTRAINT %s', [IndexName]));

      end else if Index.IsForeignKey then begin
        IndexName := AddPrefixAndShemaPrefix(_DbDescription, MakeFkName(Table.Name, Index.Name));
        RefTableName := AddSchemaAndPrefix(_DbDescription, Index.Column[0].ForeignKeyTable.Name);

        RefList := Format('%s', [AddPrefix(_DbDescription, Index.Column[0].ForeignKeyColumn.Name)]);
        for ci := 1 to Index.ColumnCount - 1 do begin
          RefList := RefList + Format(', %s', [AddPrefix(_DbDescription, Index.Column[ci].ForeignKeyColumn.Name)]);
        end;

        FScriptWriter.WriteLine(spCreateReferences, Format('ALTER TABLE %s ADD', [TableName]));
        FScriptWriter.WriteLine(spCreateReferences, Format('  CONSTRAINT %s FOREIGN KEY', [IndexName]));
        FScriptWriter.WriteLine(spCreateReferences, Format('   (%s)', [ColList]));
        FScriptWriter.WriteLine(spCreateReferences, Format('  REFERENCES %s (%s)', [RefTableName, RefList]));
        FScriptWriter.WriteTermLine(spCreateReferences, {****} '  ON DELETE CASCADE');

        FScriptWriter.WriteLine(spDropReferences, Format('ALTER TABLE %s DROP', [TableName]));
        FScriptWriter.WriteTermLine(spDropReferences, Format('  CONSTRAINT %s', [IndexName]));
      end else if Index.IsUniq then begin
        IndexName := AddPrefixAndShemaPrefix(_DbDescription, MakeIndexName(Table.Name, Index.Name));

        FScriptWriter.WriteTermLine(spCreateIndices, Format('CREATE UNIQUE INDEX %s ON %s (%s)', [IndexName, TableName, ColList]));

        FScriptWriter.WriteTermLine(spDropIndices, Format('DROP INDEX %s', [IndexName]));
      end else begin
        IndexName := AddPrefixAndShemaPrefix(_DbDescription, MakeIndexName(Table.Name, Index.Name));

        FScriptWriter.WriteTermLine(spCreateIndices, Format('CREATE INDEX %s ON %s (%s)', [IndexName, TableName, ColList]));

        FScriptWriter.WriteTermLine(spDropIndices, Format('DROP INDEX %s', [IndexName]));
      end;
    end;

    // terminate the CREATE TABLE statement
    FScriptWriter.WriteTermLine(spCreateTables, {*****} ')');

    FScriptWriter.WriteTermLine(spDropTables, Format('DROP TABLE %s', [Tablename]));
  end;
end;

function TRealOracleDbCreator.AddSchema(const _Name: string): string;
begin
  Result := Format('$(DBI_SCHEMA_NAME)$(DBI_SCHEMA_SUFFIX).%s', [_Name]);
end;

function TRealOracleDbCreator.AddSchemaPrefix(const _Name: string): string;
begin
  Result := Format('$(DBI_SCHEMA_NAME)$(DBI_SCHEMA_SUFFIX)_%s', [_Name]);
end;

function TRealOracleDbCreator.AddSchemaAndPrefix(const _DbDescription: IdzDbDescription; const _TableName: string): string;
begin
  Result := AddSchema(AddPrefix(_DbDescription, _TableName));
end;

function TRealOracleDbCreator.AddPrefix(const _DbDescription: IdzDbDescription; const _Name: string): string;
begin
  Result := _DbDescription.Prefix + _Name;
  if Length(Result) > 30 then // maximum length of a name in Oracle is 32 characters
    raise ENameTooLong.CreateFmt('Name %s too long for Oracle (max = 30)', [Result]);
end;

function TRealOracleDbCreator.AddPrefixAndShemaPrefix(const _DbDescription: IdzDbDescription; const _Name: string): string;
begin
  Result := AddSchemaPrefix(AddPrefix(_DbDescription, _Name));
end;

procedure TRealOracleDbCreator.CheckDbDescription(const _DbDescription: IdzDbDescription);
var
  TableIdx: integer;
  Table: IdzDbTableDescription;
  ColIdx: integer;
  HasMemo: boolean;
  Column: IdzDbColumnDescription;
begin
  for TableIdx := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.Tables[TableIdx];
    HasMemo := false;
    for ColIdx := 0 to Table.ColumnCount - 1 do begin
      Column := Table.Columns[ColIdx];
      if Column.DataType = dtMemo then begin
        if HasMemo then
          raise EOnlyOneLong.CreateFmt('Table "%s" has more than one column of type LONG. Oracle only supports one of these per table.', [Table.Name]);
        HasMemo := true;
      end;
    end;
  end;
end;

destructor TRealOracleDbCreator.Destroy;
begin
  FIncludeWriter.Free;
  inherited;
end;

procedure TRealOracleDbCreator.WriteSqlDataStatements(
  const _DbDescription: IdzDbDescription; _ScriptWriter: ISqlScriptWriter);
var
  TableIdx, ColIdx, RowIdx: integer;
  field, value, statement: string;
  Table: IdzDbTableDescription;
  Row: IdzDbTableRow;
  Column: IdzDbColumnDescription;
  printit: boolean;
  tempStr: string;
begin
  for TableIdx := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.TopologicalSortedTables[TableIdx];
    Field := '';
    Statement := '';

    for RowIdx := 0 to Table.RowCount - 1 do begin
      Row := Table.Rows[RowIdx];
      printit := false;
      for ColIdx := 0 to Table.ColumnCount - 1 do begin
        if not Row.IsNull(ColIdx) then begin
          Column := Table.Columns[ColIdx];
          tempStr := Row[ColIdx];
          case Column.DataType of
            dtDate:
              tempStr := 'TO_DATE(''' + tempStr + ''', ''YYYY-MM-DD HH24:MI:SS'')';
            dtText, dtMemo:
              tempStr := '''' + tempStr + '''';
          end;
          if printit then begin
            Field := Field + ', ' + AddPrefix(_DbDescription, Column.Name);
            Value := Value + ', ' + tempStr;
          end else begin
            printit := true;
            Field := AddPrefix(_DbDescription, Column.Name);
            Value := tempStr;
          end;
        end;
      end;
      if printit then begin
        Statement := 'INSERT INTO '
          + AddSchemaAndPrefix(_DbDescription, Table.Name)
          + ' ('
          + Field
          + ')';
              // AdjustTableNames(_DbDescription, Statement);

        statement := statement + ' VALUES (' + Value + ')';

        _ScriptWriter.WriteTermLine(spInsertData, statement);
      end;
    end;
  end;
end;

function TRealOracleDbCreator.MaxIdentifierLength: integer;
begin
  Result := 30;
end;

procedure TRealOracleDbCreator.GetIncludeFileContent(_st: TStrings);
begin
  _st.Assign(FIncludeWriter.FLines)
end;

procedure TRealOracleDbCreator.WriteDbDesc(
  const _DbDescription: IdzDbDescription;
  const _Version: IdzDbVersionNTypeAncestor);
begin
  CheckDbDescription(_DbDescription);
  inherited;
end;

constructor TRealOracleDbCreator.Create(const _Statements, _IncludeSl, _ModuleSl: TStringList);
begin
  inherited Create(_Statements);
  FIncludeWriter := TOracleIncludeWriter.Create(_IncludeSl, _ModuleSl);
end;

constructor TRealOracleDbCreator.Create(const _Statements: TStringList);
begin
  inherited;
  FIncludeWriter := TOracleIncludeWriter.Create(nil, nil);
end;

{ TOracleDbCreator }

class function TOracleDbCreator.Create(const _Statements: TStringList): IdzDbCreator;
begin
  Result := TRealOracleDbCreator.Create(_Statements);
end;

class function TOracleDbCreator.Create(const _Statements, _IncludeSl, _ModuleSl: TStringList): IdzDbCreator;
begin
  Result := TRealOracleDbCreator.Create(_Statements, _IncludeSl, _ModuleSl);
end;

class function TOracleDbCreator.DatabaseTypeName: string;
begin
  Result := 'oracle';
end;

{ TOracleIncludeWriter }

constructor TOracleIncludeWriter.Create(const _IncludeSl, _ModuleSl: TStringList);
begin
  inherited Create;

  FIncludeSl := _IncludeSl;
  FModuleSl := _ModuleSl;
  FLines := TStringList.Create;

  WriteModuleHeader();
end;

destructor TOracleIncludeWriter.Destroy;
begin
  WriteModuleFooter();
  FLines.Free;
  inherited;
end;

procedure TOracleIncludeWriter.Write(_Sl: TStringList; const _S: string);
begin
  if assigned(_Sl) then
    _Sl.Add(_S);
end;

procedure TOracleIncludeWriter.WriteLine(const _TableName, _SequenceName: string);
var
  Line: string;
begin
  Line := Format('SEQUENCE_NAMES.Add(''%s=%s'');', [_TableName, _SequenceName]);
  WriteIncludeLine(Line + #13#10);

  Line := Format('glbSEQUENCE_NAMES.Add "%s", "%s"', [_SequenceName, _TableName]);
  WriteModuleLine(Line + #13#10);

  FLines.Add(Line);
end;

procedure TOracleIncludeWriter.WriteIncludeLine(const _Line: string);
begin
  Write(FIncludeSl, _Line + #13#10);
  FLines.Add(_Line);
end;

procedure TOracleIncludeWriter.WriteModuleLine(const _Line: string);
begin
  Write(FModuleSl, _Line + #13#10);
  FLines.Add(_Line);
end;

procedure TOracleIncludeWriter.WriteModuleHeader();
begin
  WriteModuleLine('Option Explicit' + #13#10);
  WriteModuleLine('Public glbSEQUENCE_NAMES as New Collection' + #13#10);
  WriteModuleLine('Public Sub SEQUENCE_NAMES_init()' + #13#10);
  WriteModuleLine('On Error goto Errorhandler' + #13#10);
end;

procedure TOracleIncludeWriter.WriteModuleFooter();
begin
  WriteModuleLine('Exit Sub' + #13#10);
  WriteModuleLine('Errorhandler:' + #13#10);
  WriteModuleLine('MsgBox "Beim Initialiseren der SEQUENCE_Names'
    + ' Collection trat ein Fehler auf: " & err.description, vbcritical' + #13#10);
  WriteModuleLine('End Sub' + #13#10);
  WriteModuleLine('Public Function GetSequenceName(ByVal tablename As String) As String' + #13#10);
  WriteModuleLine('GetSequenceName = glbSEQUENCE_NAMES.Item(tablename)' + #13#10);
  WriteModuleLine('End Function' + #13#10);
end;

end.


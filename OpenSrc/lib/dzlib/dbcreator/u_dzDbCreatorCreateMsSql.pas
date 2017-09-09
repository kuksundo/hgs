unit u_dzDbCreatorCreateMsSql;

interface

///<summary> generates an SQL script for creating an MSSQL database </summary>

uses
  SysUtils,
  Classes,
  u_dzDbCreatorBase,
  u_dzDbCreatorDescription;

type
  TMsSqlDbCreator = class
  public
    class function DatabaseTypeName: string;
    class function Create(const _Statements: TStringList): IdzDbCreator;
  end;

implementation

uses
  TypInfo,
  u_dzMiscUtils,
  u_dzSqlScriptWriter,
  u_dzScriptPositionList,
  StrUtils;

const
  DATA_TYPE_MAPPING: TDataTypeMapping = (
    'int', 'float', 'nvarchar', 'ntext', 'datetime', 'uniqueidentifier');
  NULL_ALLOWED_MAPPING: TNullAllowedMapping = (
    'NOT NULL', 'NULL');
  DATA_TYPES_WITH_SIZE = [dtText];

type
  TRealMsSqlDbCreator = class(TdzSqlDbCreator, IdzDbCreator)
  protected
    procedure WriteCreateTables(const _DbDescription: IdzDbDescription); override;
    procedure AdjustTableName(const _DbDescription: IdzDbDescription; var _TableName: string); override;
    procedure WriteSqlStatements(const _DbDescription: IdzDbDescription); override;
    procedure WriteSqlDataStatements(const _DbDescription: IdzDbDescription; _ScriptWriter: ISqlScriptWriter); override;

    function MaxIdentifierLength: integer; override;
  public
  end;

procedure TRealMsSqlDbCreator.WriteCreateTables(const _DbDescription: IdzDbDescription);
var
  Table: IdzDbTableDescription;
  Column: IdzDbColumnDescription;
  ti: integer;
  ci: integer;
  ii: integer;
  LastIdx: integer;
  HasMemo: boolean;
  ColName: string;
  ColTyp: string;
  ColSize: string;
  ColDefault: string;
  ColNull: string;
  ColAutoInc: string;
  Line: string;
  s: string;
  Index: IdzDbIndexDescription;
  ColList, RefCols: string;
begin
  for ti := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.Tables[ti];
    FScriptWriter.WriteLine(spCreateTables, Format('CREATE TABLE [%s%s].[dbo].[%s%s] (', [Prefix, DatabaseName, Prefix, Table.Name]));

    LastIdx := Table.ColumnCount - 1;
    HasMemo := false;
    for ci := 0 to LastIdx do begin
      Line := '';
      Column := Table.Columns[ci];

      HasMemo := HasMemo or (dtMemo = Column.DataType);

      ColName := Format('[%s%s] ', [Prefix, Column.Name]);
      ColTyp := Format('[%s]', [DATA_TYPE_MAPPING[Column.DataType]]);
      if Column.DataType in DATA_TYPES_WITH_SIZE then
        ColSize := Format('(%d) ', [Column.Size])
      else
        ColSize := ' ';
      if Column.AutoInc then
        ColAutoInc := Format('IDENTITY(%d, 1) ', [Column.GetStartIdx])
      else
        ColAutoInc := '';
      ColNull := Format('%s ', [NULL_ALLOWED_MAPPING[Column.AllowNull]]);

      if Column.GetDefaultString(s) then
        ColDefault := Format('DEFAULT ''%s'' ', [s])
      else
        ColDefault := '';

      Line := Line + Format('  %s%s%s%s%s%s', [ColName, ColTyp, ColSize, ColDefault, ColAutoInc, ColNull]);
      if ci <> LastIdx then
        Line := Line + ',';
      FScriptWriter.WriteLine(spCreateTables, Line);
    end;

    for ii := 0 to Table.IndiceCount - 1 do begin
      Index := Table.Indices[ii];
      if Index.ColumnCount > 0 then begin
        ColList := Format('[%s%s]', [Prefix, Index.Column[0].Name]);
        for ci := 1 to Index.ColumnCount - 1 do begin
          ColList := ColList + Format(', [%s%s]', [Prefix, Index.Column[ci].Name]);
        end;
      end else
        continue;

      if Index.IsPrimaryKey then begin
        FScriptWriter.WriteLine(spCreatePrimaryKeys, Format('ALTER TABLE [%s%s].[dbo].[%s%s] WITH NOCHECK ADD', [Prefix, DatabaseName, Prefix, Table.Name]));
        FScriptWriter.WriteLine(spCreatePrimaryKeys, Format('  CONSTRAINT [%s] PRIMARY KEY NONCLUSTERED', [MakePkName(Table.Name, Index.Name)]));
        FScriptWriter.WriteLine(spCreatePrimaryKeys, {*****} '  (');
        FScriptWriter.WriteLine(spCreatePrimaryKeys, Format('    %s', [ColList]));
        FScriptWriter.WriteTermLine(spCreatePrimaryKeys, {*****} '  )');
      end else if Index.IsForeignKey then begin
        RefCols := Format('[%s%s]', [Prefix, Index.Column[0].ForeignKeyColumn.Name]);
        for ci := 1 to Index.ColumnCount - 1 do begin
          RefCols := RefCols + Format(', [%s%s]', [Prefix, Index.Column[ci].ForeignKeyColumn.Name]);
        end;

        FScriptWriter.WriteLine(spCreateReferences, Format('ALTER TABLE [%s%s].[dbo].[%s%s] ADD', [Prefix, DatabaseName, Prefix, Table.Name]));
        FScriptWriter.WriteLine(spCreateReferences, Format('  CONSTRAINT [%s] FOREIGN KEY', [MakeFkName(Table.Name, Index.Name)]));
        FScriptWriter.WriteLine(spCreateReferences, {*****} '  (');
        FScriptWriter.WriteLine(spCreateReferences, Format('    %s', [ColList]));
        FScriptWriter.WriteLine(spCreateReferences, Format('  ) REFERENCES [%s%s].[dbo].[%s%s] (', [Prefix, DatabaseName, Prefix, Index.Column[0].ForeignKeyTable.Name]));
        FScriptWriter.WriteLine(spCreateReferences, Format('    %s', [RefCols]));
        FScriptWriter.WriteTermLine(spCreateReferences, {*****} '  )');
      end else if Index.IsUniq then begin
        FScriptWriter.WriteLine(spCreateIndices, Format('ALTER TABLE [%s%s].[dbo].[%s%s] with NOCHECK ADD', [Prefix, DatabaseName, Prefix, Table.Name]));
        FScriptWriter.WriteLine(spCreateIndices, Format('  CONSTRAINT [%s] UNIQUE NONCLUSTERED', [MakeIndexName(Table.Name, Index.Name)]));
        FScriptWriter.WriteLine(spCreateIndices, {*****} '  (');
        FScriptWriter.WriteLine(spCreateIndices, Format('    %s', [ColList]));
        FScriptWriter.WriteTermLine(spCreateIndices, {*****} '  )');
      end else begin
        FScriptWriter.WriteLine(spCreateIndices, Format('CREATE INDEX [%s] ON [%s%s].[dbo].[%s%s]', [MakeIndexName(Table.Name, Index.Name), Prefix, DatabaseName, Prefix, Table.Name]));
        FScriptWriter.WriteLine(spCreateIndices, {*****} '  (');
        FScriptWriter.WriteLine(spCreateIndices, Format('    %s', [ColList]));
        FScriptWriter.WriteTermLine(spCreateIndices, {*****} '  )');
      end;
    end;

      // terminate the CREATE TABLE statement
    FScriptWriter.WriteLine(spCreateTables, {*****} ') ON [PRIMARY]');
    if HasMemo then
      FScriptWriter.WriteTermLine(spCreateTables, ' TEXTIMAGE_ON [PRIMARY]')
    else
      FScriptWriter.WriteTermLine(spCreateTables);

  end;
end;

procedure TRealMsSqlDbCreator.WriteSqlStatements(const _DbDescription: IdzDbDescription);
var
  i: integer;
  s: string;
  Statements: TStrings;
begin
  Statements := _DbDescription.SqlStatements;
  for i := 0 to Statements.Count - 1 do begin
    s := Statements[i];
    AdjustTableNames(_DbDescription, s);
    FScriptWriter.WriteTermLine(spInsertData, s);
  end;
end;

procedure TRealMsSqlDbCreator.AdjustTableName(const _DbDescription: IdzDbDescription;
  var _TableName: string);
begin
  _TableName := Format('[%s%s].[dbo].[%s%s]', [Prefix, DatabaseName, Prefix, _Tablename]);
end;

procedure TRealMsSqlDbCreator.WriteSqlDataStatements(
  const _DbDescription: IdzDbDescription; _ScriptWriter: ISqlScriptWriter);
var
  Table: IdzDbTableDescription;

  procedure SetIdentityInsert(_OnOff: boolean);
  var
    s: string;
  begin
    s := Format('SET IDENTITY_INSERT $(%s) %s', [Table.Name, IfThen(_OnOff, 'ON', 'OFF')]);
    AdjustTableNames(_DbDescription, s);
    _ScriptWriter.WriteTermLine(spInsertData, s);
  end;

var
  TableIdx, ColIdx, RowIdx: integer;
  Field, Value, Statement: string;
  Row: IdzDbTableRow;
  Column: IdzDbColumnDescription;
  printit: boolean;
  tempStr: string;
  HasIdentity: boolean;
begin
  for TableIdx := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.TopologicalSortedTables[TableIdx];
    Field := '';
    Statement := '';

    if Table.RowCount = 0 then
      Continue;

    HasIdentity := false;
    for ColIdx := 0 to Table.ColumnCount - 1 do
      if Table.Columns[ColIdx].AutoInc then begin
        HasIdentity := true;
        Break;
      end;
    if HasIdentity then
      SetIdentityInsert(true);

    for RowIdx := 0 to Table.RowCount - 1 do begin
      Row := Table.Rows[RowIdx];
      printit := false;
      for ColIdx := 0 to Table.ColumnCount - 1 do begin
        if not Row.IsNull(ColIdx) then begin
          Column := Table.Columns[ColIdx];
          tempStr := Row[ColIdx];
          case Column.DataType of
            dtDate:
              tempStr := 'CONVERT(datetime, ''' + tempStr + ''', 20)';
            dtText:
              tempStr := '''' + tempStr + '''';
          end;
          if printit then begin
            Field := Field + ', ' + _DbDescription.Prefix + Column.Name;
            Value := Value + ', ' + tempStr;
          end else begin
            printit := true;
            Field := _DbDescription.Prefix + Column.Name;
            Value := tempStr;
          end;
        end;
      end;
      if printit then begin
        Statement := 'INSERT INTO $('
          + Table.Name
          + ') ('
          + Field
          + ')';
        AdjustTableNames(_DbDescription, Statement);

        statement := statement + ' VALUES (' + Value + ')';

        _ScriptWriter.WriteTermLine(spInsertData, statement);
      end;
    end;

    if HasIdentity then
      SetIdentityInsert(false);
  end;
end;

function TRealMsSqlDbCreator.MaxIdentifierLength: integer;
begin
  Result := 100;
end;

{ TMsSqlDbCreator }

class function TMsSqlDbCreator.Create(const _Statements: TStringList): IdzDbCreator;
begin
  Result := TRealMsSqlDbCreator.Create(_Statements);
end;

class function TMsSqlDbCreator.DatabaseTypeName: string;
begin
  Result := 'mssql';
end;

end.


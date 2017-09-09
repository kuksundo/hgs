{.GXFormatter.config=twm}
unit u_dzDbCreatorCreateXml;

///<summary> Creates an xml file representing the database description passed to it </summary>

interface

uses
  Sysutils,
  Classes,
  Variants,
  u_dzDbCreatorBase,
  u_dzDbCreatorDescription,
  u_dzVariableDescList,
  u_dzXmlWriter;

type
  TXmlDbCreator = class(TInterfacedObject, IdzDbCreator)
  private
    procedure WriteDb(const _DbDescription: IdzDbDescription);
    procedure WriteTable(const _TblDesc: IdzDbTableDescription);
    procedure WriteColumn(const _ColDesc: IdzDbColumnDescription);
    procedure WriteIndex(const _IndexDes: IdzDbIndexDescription);
    procedure WriteHeader(const _DbDescription: IdzDbDescription);
    procedure WriteConfig(const _DbDescription: IdzDbDescription);
    procedure WriteDatabaseTypes(const _DbDescription: IdzDbDescription);
    procedure WriteDatabaseType(const _DbTypeDescription: IdzDbTypeDescription);
    procedure WriteVariables(const _DbTypeDescription: IdzDbVersionNTypeAncestor);
    procedure WriteVariable(const _DbVariableDescription: IdzDbVariableDescription;
      const _DbDefaultTypeDescription: IdzDbDefaultTypeDescription);
    procedure WriteDefaults(const _DbTypeDescription: IdzDbVersionNTypeAncestor);
    procedure WriteDefault(const _DbDefaultTypeDescription: IdzDbDefaultTypeDescription);
    procedure WriteScriptParts(const _DbTypeDescription: IdzDbVersionNTypeAncestor);
    procedure WriteScriptPart(const _DbScriptDescription: IdzDbScriptDescription);
    procedure WriteVariableDefault(
      const _DbVariableDefaultDescription: IdzDbVariableDefaultDescription);
    procedure WriteVersions(const _DbTypeDescription: IdzDbTypeDescription);
    procedure WriteVersion(const _DbVersionDescription: IdzDbVersionDescription);
  protected
    FWriter: TdzXmlWriter;
    FFilename: string;
  private // implements IdzDbCreator
    procedure WriteDbDesc(const _DbDescription: IdzDbDescription; const _Version: IdzDbVersionNTypeAncestor);
  public
    constructor Create(const _Filename: string);
  end;

implementation

uses
  u_dzFileStreams;

{ TXmlDbCreator }

constructor TXmlDbCreator.Create(const _Filename: string);
begin
  inherited Create;
  FFilename := _Filename;
end;

procedure TXmlDbCreator.WriteDb(const _DbDescription: IdzDbDescription);
var
  i: integer;
  TblDesc: IdzDbTableDescription;
begin
  FWriter.StartEntity('database', ['name', _DbDescription.Name]);
  for i := 0 to _DbDescription.TableCount - 1 do begin
    TblDesc := _DbDescription.Tables[i];
    WriteTable(TblDesc);
  end;
  FWriter.EndEntity('database');
end;

procedure TXmlDbCreator.WriteTable(const _TblDesc: IdzDbTableDescription);
var
  RowIdx: integer;
  ColIdx: integer;
  ii: integer;
  ColDesc: IdzDbColumnDescription;
  Row: IdzDbTableRow;
begin
  FWriter.StartEntity('table', ['name', _TblDesc.Name]);

  for ColIdx := 0 to _TblDesc.ColumnCount - 1 do begin
    ColDesc := _TblDesc.Columns[ColIdx];
    WriteColumn(ColDesc);
  end;

  for ii := 0 to _TblDesc.IndiceCount - 1 do begin
    WriteIndex(_TblDesc.Indices[ii]);
  end;

  if _TblDesc.RowCount > 0 then begin
    FWriter.StartEntity('data', []);
    try
      for RowIdx := 0 to _TblDesc.RowCount - 1 do begin
        FWriter.StartEntity('row', []);
        try
          Row := _TblDesc.Rows[RowIdx];
          for ColIdx := 0 to _TblDesc.ColumnCount - 1 do begin
            if not Row.isNull(ColIdx) then
              FWriter.WriteEntity('coldata',
                ['name', _TblDesc.Columns[ColIdx].Name,
                'value', Row[ColIdx]]);
          end;
        finally
          FWriter.EndEntity('row');
        end;
      end;
    finally
      FWriter.EndEntity('data');
    end;
  end;
  FWriter.EndEntity('table');
end;

procedure TXmlDbCreator.WriteColumn(const _ColDesc: IdzDbColumnDescription);
var
  sl: TStringList;
  s: string;

  procedure AddAttrib(const _Name, _Value: string);
  begin
    sl.Add(_Name);
    sl.Add(_Value);
  end;

begin
  sl := TStringList.Create;
  try
    sl.Values['name'] := _ColDesc.Name;
    sl.Values['type'] := DataTypeToString(_ColDesc.DataType);
    sl.Values['size'] := IntToStr(_ColDesc.Size);
    sl.Values['comment'] := _ColDesc.Comment;
    sl.Values['null'] := NullAllowedToYesNo(_ColDesc.AllowNull);
    if _ColDesc.GetDefaultString(s) then
      sl.Values['default'] := s;
    if _ColDesc.AutoInc then
      sl.Values['autoinc'] := 'yes';

    if Assigned(_ColDesc.ForeignKeyTable) and Assigned(_ColDesc.ForeignKeyColumn) then begin
      sl.Values['reftable'] := _ColDesc.ForeignKeyTable.Name;
      sl.Values['refcolumn'] := _ColDesc.ForeignKeyColumn.Name;
    end;
    FWriter.WriteEntity2('column', sl);
  finally
    sl.Free;
  end;
end;

procedure TXmlDbCreator.WriteIndex(const _IndexDes: IdzDbIndexDescription);
var
  sl: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  try

    sl.Values['name'] := _IndexDes.Name;

    if _IndexDes.GetIsPrimaryKey then
      sl.Values['primarykey'] := BoolToString(true);

    if _IndexDes.GetIsForeignKey then begin
      sl.Values['foreignkey'] := BoolToString(true);
      sl.Values['referencetable'] := _IndexDes.RefTable;
    end;

    if _IndexDes.GetIsUniq then
      sl.Values['unique'] := BoolToString(true);

    FWriter.StartEntity2('index', sl);

    for i := 0 to _IndexDes.ColumnCount - 1 do begin
      sl.Clear;
      sl.Values['name'] := _IndexDes.Column[i].Name;

      if _IndexDes.ColumnSortorder[i] = soDescending then
        sl.Values['sortorder'] := SortOrderToString(soDescending);

      FWriter.WriteEntity2('column', sl);
    end;

    FWriter.EndEntity('index');
  finally
    sl.Free;
  end;

end;

procedure TXmlDbCreator.WriteDbDesc(const _DbDescription: IdzDbDescription;
  const _Version: IdzDbVersionNTypeAncestor);
var
  DbDescription: IdzDbDescription;
  Stream: TdzFile;
begin
  DbDescription := _DbDescription;

  Stream := TdzFile.Create(FFilename);
  try
    Stream.AccessMode := faReadWrite;
    Stream.ShareMode := fsNoSharing;
    Stream.CreateDisposition := fcCreateFailIfExists;
    Stream.Open;
    try
      FWriter := TdzXmlWriter.Create(Stream, 2, false, xeWindows);
      try
        FWriter.WriteHeader;
        FWriter.StartEntity('dzxmldb', []);
        if assigned(DbDescription) then begin
          WriteHeader(DbDescription);
          WriteConfig(DbDescription);
          WriteDatabaseTypes(DbDescription);
          WriteDb(DbDescription);
        end;
        FWriter.EndEntity('dzxmldb');
      finally
        FWriter.Free;
      end;
    finally
      Stream.Close;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TXmlDbCreator.WriteConfig(const _DbDescription: IdzDbDescription);
begin
  FWriter.WriteEntity('config', []);
end;

procedure TXmlDbCreator.WriteHeader(const _DbDescription: IdzDbDescription);
begin
  FWriter.StartEntity('header', []);
  FWriter.WriteEntity('program', ['identifier', _DbDescription.ProgName, 'name',
    _DbDescription.ProgIdentifier]);
  FWriter.EndEntity('header');
end;

procedure TXmlDbCreator.WriteDatabaseTypes(
  const _DbDescription: IdzDbDescription);
var
  idx: integer;
begin
  FWriter.StartEntity('databasetypes', []);
  for idx := 0 to _DbDescription.DbTypesCount - 1 do
    WriteDatabaseType(_DbDescription.DbTypes[idx]);
  FWriter.EndEntity('databasetypes');
end;

procedure TXmlDbCreator.WriteDatabaseType(
  const _DbTypeDescription: IdzDbTypeDescription);
begin
  FWriter.StartEntity('databasetype', ['name', _DbTypeDescription.Name]);

  WriteVariables(_DbTypeDescription);
  WriteDefaults(_DbTypeDescription);
  WriteScriptParts(_DbTypeDescription);
  WriteVersions(_DbTypeDescription);

  FWriter.EndEntity('databasetype');
end;

procedure TXmlDbCreator.WriteVariables(
  const _DbTypeDescription: IdzDbVersionNTypeAncestor);
var
  idx: integer;
begin
  FWriter.StartEntity('variables', []);
  for idx := 0 to _DbTypeDescription.VariablesCount - 1 do
    // default[0]  stores the initial settings
    WriteVariable(_DbTypeDescription.Variables[idx], _DbTypeDescription.Defaults[0]);
  FWriter.EndEntity('variables');
end;

procedure TXmlDbCreator.WriteVariable(
  const _DbVariableDescription: IdzDbVariableDescription;
  const _DbDefaultTypeDescription: IdzDbDefaultTypeDescription);
begin
  FWriter.WriteEntity('variable', [
    'name', _DbVariableDescription.Name,
      'default', _DbDefaultTypeDescription.VariableDefaultByName(_DbVariableDescription.Name).Value,
      'deutsch', _DbVariableDescription.English,
      'english', _DbVariableDescription.Deutsch,
      'tag', _DbVariableDescription.Tag,
      'type', _DbVariableDescription.ValType,
      'editable', BoolToString(_DbVariableDescription.Editable),
      'advanced', BoolToString(_DbVariableDescription.Advanced)
      ]);
end;

procedure TXmlDbCreator.WriteDefaults(
  const _DbTypeDescription: IdzDbVersionNTypeAncestor);
var
  idx: integer;
begin
  FWriter.StartEntity('defaults', []);
  // default[0]  stores the initial settings
  for idx := 1 to _DbTypeDescription.DefaultsCount - 1 do
    WriteDefault(_DbTypeDescription.Defaults[idx]);
  FWriter.EndEntity('defaults');
end;

procedure TXmlDbCreator.WriteDefault(
  const _DbDefaultTypeDescription: IdzDbDefaultTypeDescription);
var
  idx: integer;
begin
  FWriter.StartEntity('default', ['name', _DbDefaultTypeDescription.Name]);
  for idx := 0 to _DbDefaultTypeDescription.VariableDefaultsCount - 1 do
    WriteVariableDefault(_DbDefaultTypeDescription.VariableDefaults[idx]);
  FWriter.EndEntity('default');
end;

procedure TXmlDbCreator.WriteVariableDefault(
  const _DbVariableDefaultDescription: IdzDbVariableDefaultDescription);
begin
  FWriter.WriteEntity('defaultvalue', [
    'name', _DbVariableDefaultDescription.Name,
      'value', _DbVariableDefaultDescription.Value
      ]);
end;

procedure TXmlDbCreator.WriteScriptParts(
  const _DbTypeDescription: IdzDbVersionNTypeAncestor);
var
  idx: integer;
begin
  FWriter.StartEntity('scripts', []);
  for idx := 0 to _DbTypeDescription.ScriptsCount - 1 do
    WriteScriptPart(_DbTypeDescription.Scripts[idx]);
  FWriter.EndEntity('scripts');
end;

procedure TXmlDbCreator.WriteScriptPart(
  const _DbScriptDescription: IdzDbScriptDescription);
var
  statements: TStringList;
  idx: integer;
begin
  statements := TStringList.create;
  try
    FWriter.StartEntity('script', [
      'name', _DbScriptDescription.Name,
        'deutsch', _DbScriptDescription.Deutsch,
        'english', _DbScriptDescription.English,
        'mandatory', BoolToString(_DbScriptDescription.Mandatory),
        'default', BoolToString(_DbScriptDescription.Active)
        ]);
    FWriter.StartCdata;

    _DbScriptDescription.GetStatements(statements);
    for idx := 0 to statements.Count - 1 do begin
      FWriter.WriteCdataLine(statements[idx]);
      FWriter.WriteCdataLine('');
    end;
    FWriter.EndCdata;
    FWriter.EndEntity('script');
  finally
    statements.Free;
  end;
end;

procedure TXmlDbCreator.WriteVersions(
  const _DbTypeDescription: IdzDbTypeDescription);
var
  idx: integer;
begin
  FWriter.StartEntity('versions', []);
  for idx := 0 to _DbTypeDescription.VersionsCount - 1 do
    WriteVersion(_DbTypeDescription.Versions[idx]);
  FWriter.EndEntity('versions');
end;

procedure TXmlDbCreator.WriteVersion(const _DbVersionDescription: IdzDbVersionDescription);
begin

  FWriter.StartEntity('version', ['name', _DbVersionDescription.VersionName]);

  WriteVariables(_DbVersionDescription);
  WriteDefaults(_DbVersionDescription);
  WriteScriptParts(_DbVersionDescription);

  FWriter.EndEntity('version');
end;

end.


unit u_dzDbCreatorCreateHtml;

///<summary> generates an HTML file with a description of the database </summary>

interface

uses
  Sysutils,
  Classes,
  Variants,
  u_dzDbCreatorBase,
  u_dzDbCreatorDescription;

type
  ///<summary> generates an HTML file with a description of the database
  ///           DOES NOT WORK YET! </summary>
  THtmlDbCreator = class(TInterfacedObject, IdzDbCreator)
  private
    procedure WriteDb(const _DbDescription: IdzDbDescription);
    procedure WriteTable(const _TblDesc: IdzDbTableDescription);
    procedure WriteColumn(const _ColDesc: IdzDbColumnDescription);
    procedure WriteIndex(const _IndexDes: IdzDbIndexDescription);
    procedure WriteHeader(const _DbDescription: IdzDbDescription);
    procedure WriteConfig(const _DbDescription: IdzDbDescription);
    procedure WriteDatabaseTypes(const _DbDescription: IdzDbDescription);
//    procedure WriteDatabaseType(const _DbTypeDescription: IdzDbTypeDescription);
//    procedure WriteVariables(const _DbTypeDescription: IdzDbVersionNTypeAncestor);
//    procedure WriteVariable(const _DbVariableDescription: IdzDbVariableDescription;
//      const _DbDefaultTypeDescription: IdzDbDefaultTypeDescription);
//    procedure WriteDefaults(const _DbTypeDescription: IdzDbVersionNTypeAncestor);
//    procedure WriteDefault(const _DbDefaultTypeDescription: IdzDbDefaultTypeDescription);
//    procedure WriteScriptParts(const _DbTypeDescription: IdzDbVersionNTypeAncestor);
//    procedure WriteScriptPart(const _DbScriptDescription: IdzDbScriptDescription);
//    procedure WriteVariableDefault(
//      const _DbVariableDefaultDescription: IdzDbVariableDefaultDescription);
//    procedure WriteVersions(const _DbTypeDescription: IdzDbTypeDescription);
//    procedure WriteVersion(const _DbVersionDescription: IdzDbVersionDescription);
  protected
    FOutput: TStringList;
    FFilename: string;
    FHeadingStartLevel: integer;
    // implements IdzDbCreator
    procedure WriteDbDesc(const _DbDescription: IdzDbDescription; const _Version: IdzDbVersionNTypeAncestor);
  public
    constructor Create(const _Filename: string; _HeadingStartLevel: integer);
  end;

implementation

uses
  u_dzFileStreams;

{ THtmlDbCreator }

constructor THtmlDbCreator.Create(const _Filename: string; _HeadingStartLevel: integer);
begin
  inherited Create;
  FFilename := _Filename;
  FHeadingStartLevel := _HeadingStartLevel;
end;

procedure THtmlDbCreator.WriteDb(const _DbDescription: IdzDbDescription);
var
  i: integer;
  TblDesc: IdzDbTableDescription;
begin
  FOutput.Add(Format('<h%d>Database %s</h%d>',
    [FHeadingStartLevel, _DbDescription.Name, FHeadingStartLevel]));
  for i := 0 to _DbDescription.TableCount - 1 do begin
    TblDesc := _DbDescription.Tables[i];
    WriteTable(TblDesc);
  end;
end;

procedure THtmlDbCreator.WriteTable(const _TblDesc: IdzDbTableDescription);
var
//  RowIdx: integer;
  ColIdx: integer;
  ii: integer;
  ColDesc: IdzDbColumnDescription;
//  Row: IdzDbTableRow;

  procedure AddColumnHeader(const _Caption: string);
  begin
    FOutput.Add(Format('<th>%s</th>', [_Caption]));
  end;

begin
  FOutput.Add(Format('<h%d>Table %s</h%d>',
    [FHeadingStartLevel + 1, _TblDesc.Name, FHeadingStartLevel + 1]));

  FOutput.Add(Format('<h%d>Columns</h%d>',
    [FHeadingStartLevel + 2, FHeadingStartLevel + 2]));

  FOutput.Add('<table width="100%" border="1">');
  FOutput.Add('<tr>');
  AddColumnHeader('Column');
  AddColumnHeader('Type');
  AddColumnHeader('Size');
  AddColumnHeader('Null');
  AddColumnHeader('Default');
  AddColumnHeader('Autoinc');
  AddColumnHeader('Ref-Table');
  AddColumnHeader('Ref-Column');
  AddColumnHeader('Comment');
  FOutput.Add('</tr>');

  for ColIdx := 0 to _TblDesc.ColumnCount - 1 do begin
    ColDesc := _TblDesc.Columns[ColIdx];
    WriteColumn(ColDesc);
  end;
  FOutput.Add('</table>');

  if _TblDesc.IndiceCount > 0 then begin
    FOutput.Add(Format('<h%d>Indices</h%d>',
      [FHeadingStartLevel + 2, FHeadingStartLevel + 2]));
    FOutput.Add('<table width="100%" border="1">');
    FOutput.Add('<tr>');
    AddColumnHeader('Name');
    AddColumnHeader('Primary Key');
    AddColumnHeader('Foreign Key');
    AddColumnHeader('Reference Table');
    AddColumnHeader('Unique');
    AddColumnHeader('Columns');
    FOutput.Add('</tr>');

    for ii := 0 to _TblDesc.IndiceCount - 1 do begin
      WriteIndex(_TblDesc.Indices[ii]);
    end;
    FOutput.Add('</table>');
  end;

  //  if _TblDesc.RowCount > 0 then
  //    begin
  //      FWriter.StartEntity('data', []);
  //      try
  //        for RowIdx := 0 to _TblDesc.RowCount - 1 do
  //          begin
  //            FWriter.StartEntity('row', []);
  //            try
  //              Row := _TblDesc.Rows[RowIdx];
  //              for ColIdx := 0 to _TblDesc.ColumnCount - 1 do
  //                begin
  //                  if not Row.isNull(ColIdx) then
  //                    FWriter.WriteEntity('coldata',
  //                      ['name', _TblDesc.Columns[ColIdx].Name,
  //                      'value', Row[ColIdx]]);
  //                end;
  //            finally
  //              FWriter.EndEntity('row');
  //            end;
  //          end;
  //      finally
  //        FWriter.EndEntity('data');
  //      end;
  //    end;

end;

procedure THtmlDbCreator.WriteColumn(const _ColDesc: IdzDbColumnDescription);
var
  s: string;

  procedure AddAttrib(const _Name: string; _Value: string);
  begin
    if _Value = '' then
      _Value := '&nbsp;';
    FOutput.Add(Format('<td class="column_%s">%s</td>', [_Name, _Value]));
  end;

begin
  FOutput.Add('<tr>');
  AddAttrib('name', _ColDesc.Name);
  AddAttrib('type', DataTypeToString(_ColDesc.DataType));
  AddAttrib('size', IntToStr(_ColDesc.Size));
  AddAttrib('null', NullAllowedToYesNo(_ColDesc.AllowNull));
  if _ColDesc.GetDefaultString(s) then
    AddAttrib('default', s)
  else
    FOutput.Add('<td>&nbsp;</td>');
  if _ColDesc.AutoInc then
    AddAttrib('autoinc', 'yes')
  else
    FOutput.Add('<td>&nbsp;</td>');

  if Assigned(_ColDesc.ForeignKeyTable) and Assigned(_ColDesc.ForeignKeyColumn) then begin
    AddAttrib('reftable', _ColDesc.ForeignKeyTable.Name);
    AddAttrib('refcolumn', _ColDesc.ForeignKeyColumn.Name);
  end else begin
    FOutput.Add('<td>&nbsp;</td>');
    FOutput.Add('<td>&nbsp;</td>');
  end;
  AddAttrib('comment', _ColDesc.Comment);
  FOutput.Add('</tr>');
end;

procedure THtmlDbCreator.WriteIndex(const _IndexDes: IdzDbIndexDescription);

  procedure AddAttrib(const _Name, _Value: string);
  begin
    FOutput.Add(Format('<td class="index_%s">%s</td>', [_Name, _Value]));
  end;

var
  i: integer;
begin
  FOutput.Add('<tr>');

  AddAttrib('name', _IndexDes.Name);

  if _IndexDes.GetIsPrimaryKey then
    AddAttrib('primarykey', BoolToString(true))
  else
    FOutput.Add('<td>&nbsp;</td>');

  if _IndexDes.GetIsForeignKey then begin
    AddAttrib('foreignkey', BoolToString(true));
    AddAttrib('referencetable', _IndexDes.RefTable);
  end else begin
    FOutput.Add('<td>&nbsp;</td>');
    FOutput.Add('<td>&nbsp;</td>');
  end;

  if _IndexDes.GetIsUniq then
    AddAttrib('unique', BoolToString(true))
  else
    FOutput.Add('<td>&nbsp;</td>');

  FOutput.Add('<td>');
  for i := 0 to _IndexDes.ColumnCount - 1 do begin
    FOutput.Add(_IndexDes.Column[i].Name + ' ');

    if _IndexDes.ColumnSortorder[i] = soDescending then
      FOutput.Add(SortOrderToString(soDescending) + ' ');
  end;
  FOutput.Add('</td>');

  FOutput.Add('</tr>');
end;

procedure THtmlDbCreator.WriteDbDesc(const _DbDescription: IdzDbDescription;
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
      FOutput := TStringList.Create;
      try
        FOutput.Add('<html><head></head><body>');
        if assigned(DbDescription) then begin
          WriteHeader(DbDescription);
          WriteConfig(DbDescription);
          WriteDatabaseTypes(DbDescription);
          WriteDb(DbDescription);
        end;
        FOutput.Add('</body></html>');
        FOutput.SaveToStream(Stream);
      finally
        FOutput.Free;
      end;
    finally
      Stream.Close;
    end;
  finally
    Stream.Free;
  end;
end;

procedure THtmlDbCreator.WriteConfig(const _DbDescription: IdzDbDescription);
begin
  //FWriter.WriteEntity('config', []);
end;

procedure THtmlDbCreator.WriteHeader(const _DbDescription: IdzDbDescription);
begin
  //  FWriter.StartEntity('header', []);
  //  FWriter.WriteEntity('program', ['identifier', _DbDescription.ProgName, 'name',
  //    _DbDescription.ProgIdentifier]);
  //  FWriter.EndEntity('header');
end;

procedure THtmlDbCreator.WriteDatabaseTypes(const _DbDescription: IdzDbDescription);
//var
//  idx: integer;
begin
  //  FWriter.StartEntity('databasetypes', []);
  //  for idx := 0 to _DbDescription.DbTypesCount - 1 do
  //    WriteDatabaseType(_DbDescription.DbTypes[idx]);
  //  FWriter.EndEntity('databasetypes');
end;

//procedure THtmlDbCreator.WriteDatabaseType(const _DbTypeDescription: IdzDbTypeDescription);
//begin
  //  FWriter.StartEntity('databasetype', ['name', _DbTypeDescription.Name]);
  //
  //  WriteVariables(_DbTypeDescription);
  //  WriteDefaults(_DbTypeDescription);
  //  WriteScriptParts(_DbTypeDescription);
  //  WriteVersions(_DbTypeDescription);
  //
  //  FWriter.EndEntity('databasetype');
//end;

//procedure THtmlDbCreator.WriteVariables(const _DbTypeDescription: IdzDbVersionNTypeAncestor);
//var
//  idx: integer;
//begin
  //  FWriter.StartEntity('variables', []);
  //  for idx := 0 to _DbTypeDescription.VariablesCount - 1 do
  //    // default[0]  stores the initial settings
  //    WriteVariable(_DbTypeDescription.Variables[idx], _DbTypeDescription.Defaults[0]);
  //  FWriter.EndEntity('variables');
//end;

//procedure THtmlDbCreator.WriteVariable(
//  const _DbVariableDescription: IdzDbVariableDescription;
//  const _DbDefaultTypeDescription: IdzDbDefaultTypeDescription);
//begin
  //  FWriter.WriteEntity('variable', [
  //    'name', _DbVariableDescription.Name,
  //      'default', _DbDefaultTypeDescription.VariableDefaultByName(_DbVariableDescription.Name).Value,
  //      'deutsch', _DbVariableDescription.English,
  //      'english', _DbVariableDescription.Deutsch,
  //      'tag', _DbVariableDescription.Tag,
  //      'type', _DbVariableDescription.ValType,
  //      'editable', BoolToString(_DbVariableDescription.Editable),
  //      'advanced', BoolToString(_DbVariableDescription.Advanced)
  //      ]);
//end;

//procedure THtmlDbCreator.WriteDefaults(const _DbTypeDescription: IdzDbVersionNTypeAncestor);
//var
//  idx: integer;
//begin
  //  FWriter.StartEntity('defaults', []);
  //  // default[0]  stores the initial settings
  //  for idx := 1 to _DbTypeDescription.DefaultsCount - 1 do
  //    WriteDefault(_DbTypeDescription.Defaults[idx]);
  //  FWriter.EndEntity('defaults');
//end;

//procedure THtmlDbCreator.WriteDefault(
//  const _DbDefaultTypeDescription: IdzDbDefaultTypeDescription);
//var
//  idx: integer;
//begin
  //  FWriter.StartEntity('default', ['name', _DbDefaultTypeDescription.Name]);
  //  for idx := 0 to _DbDefaultTypeDescription.VariableDefaultsCount - 1 do
  //    WriteVariableDefault(_DbDefaultTypeDescription.VariableDefaults[idx]);
  //  FWriter.EndEntity('default');
//end;

//procedure THtmlDbCreator.WriteVariableDefault(
//  const _DbVariableDefaultDescription: IdzDbVariableDefaultDescription);
//begin
  //  FWriter.WriteEntity('defaultvalue', [
  //    'name', _DbVariableDefaultDescription.Name,
  //      'value', _DbVariableDefaultDescription.Value
  //      ]);
//end;

//procedure THtmlDbCreator.WriteScriptParts(
//  const _DbTypeDescription: IdzDbVersionNTypeAncestor);
//var
//  idx: integer;
//begin
  //  FWriter.StartEntity('scripts', []);
  //  for idx := 0 to _DbTypeDescription.ScriptsCount - 1 do
  //    WriteScriptPart(_DbTypeDescription.Scripts[idx]);
  //  FWriter.EndEntity('scripts');
//end;

//procedure THtmlDbCreator.WriteScriptPart(
//  const _DbScriptDescription: IdzDbScriptDescription);
//var
//  statements: TStringList;
//  idx: integer;
//begin
  //  statements := TStringList.create;
  //  try
  //    FWriter.StartEntity('script', [
  //      'name', _DbScriptDescription.Name,
  //        'deutsch', _DbScriptDescription.Deutsch,
  //        'english', _DbScriptDescription.English,
  //        'mandatory', BoolToString(_DbScriptDescription.Mandatory),
  //        'default', BoolToString(_DbScriptDescription.Active)
  //        ]);
  //    FWriter.StartCdata;
  //
  //    _DbScriptDescription.GetStatements(statements);
  //    for idx := 0 to statements.Count - 1 do
  //      begin
  //        FWriter.WriteCdataLine(statements[idx]);
  //        FWriter.WriteCdataLine('');
  //      end;
  //    FWriter.EndCdata;
  //    FWriter.EndEntity('script');
  //  finally
  //    statements.Free;
  //  end;
//end;

//procedure THtmlDbCreator.WriteVersions(
//  const _DbTypeDescription: IdzDbTypeDescription);
//var
//  idx: integer;
//begin
  //  FWriter.StartEntity('versions', []);
  //  for idx := 0 to _DbTypeDescription.VersionsCount - 1 do
  //    WriteVersion(_DbTypeDescription.Versions[idx]);
  //  FWriter.EndEntity('versions');
//end;

//procedure THtmlDbCreator.WriteVersion(
//  const _DbVersionDescription: IdzDbVersionDescription);
//begin
  //  FWriter.StartEntity('version', ['name', _DbVersionDescription.VersionName]);
  //
  //  WriteVariables(_DbVersionDescription);
  //  WriteDefaults(_DbVersionDescription);
  //  WriteScriptParts(_DbVersionDescription);
  //
  //  FWriter.EndEntity('version');
//end;

end.


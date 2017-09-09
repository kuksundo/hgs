unit w_dbCreatorWizard;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  w_dzWizard,
  StdCtrls,
  ExtCtrls,
  w_SourceFile,
  w_Options,
  w_AddUser,
  w_ExportFormat,
  w_DestFile,
  u_dzLogConsole,
  u_dzDbCreatorDescription,
  JvComponentBase,
  JvAppStorage,
  JvAppRegistryStorage;

type
  ECreateDelphiCode = class(Exception);

type
  Tf_dbCreatorWizard = class(Tf_dzWizard)
    chk_Console: TCheckBox;
    TheAppRegistryStorage: TJvAppRegistryStorage;
    procedure chk_ConsoleClick(Sender: TObject);
  private
    FSourceFile: Tf_SourceFile;
    FSourceFileId: integer;
    FOptions: Tf_Options;
    FOptionsId: integer;
    FAddUser: Tf_AddUser;
    FAddUserId: integer;
    FExportFormat: Tf_ExportFormat;
    FExportFormatId: integer;
    FDbDescription: IdzDbDescription;
    FSourceFileName: string;
    FLogConsole: TdzLogConsole;
    function ReadSourceFile(const _SourceFile, _Password: string; _IncludeData, _MakeAutoInc, _ConsolidateIndices: boolean): boolean;
    procedure ReadXml(const _SrcFile: string; _IncludeData: boolean);
    procedure ReadAccess(const _SrcFile, _DbPassword: string; _IncludeData, _MakeAutoInc, _ConsolidateIndices: boolean);
    procedure AddChecksumField;
    procedure WriteExportFile(_ExportFormat: TExportFormat; const _Outfile: string);
    procedure GenerateDelphi(const _DestFile: string);
    procedure WriteExportFiles;
    procedure RemoveChecksumField;
  protected
    ///<summary> called before the new page is displayed
    ///          @param Direction gives the direction of the page change
    ///          @param OldPageId is the ID of the page we are about to leave
    ///          @param NewPageId is the ID of the page we are about to enter
    ///          @param OldPageData is the Data parameter of the page we are about to leave
    ///          @param NewPageData is the Data parameter of the page we are about to enter
    ///          @returns true if the page change is allowed
    ///          Note: This is also called on the last page when the user presses the
    ///          Finish button. </summary>
    function DoBeforePageChange(_Direction: TPrevNext;
      _OldPageId: integer; var _NewPageId: integer;
      _OldPageData, _NewPageData: pointer): boolean; override;
    ///<summary> called after DoBeforePageChanged when the user presses the finish button
    ///          @returns true, if the dialog is done </summary>
    function DoOnFinished: boolean; override;
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;
  end;

var
  f_dbCreatorWizard: Tf_dbCreatorWizard;

implementation

{$R *.DFM}

uses
  StrUtils,
  u_dzLogging,
  u_dzFileUtils,
  u_dzStringUtils,
  u_dzMiscUtils,
  u_dzDbCreatorBase,
  u_dzDbCreatorCreateOracle,
  u_dzDbCreatorCreateMsSql,
  u_dzDbCreatorCreateAccess,
  u_dzDbCreatorCreateXml,
  u_dzDbCreatorReadXml,
  u_dzDbCreatorReadAccessDb,
  u_dzDbCreatorCreateGraphViz,
  u_dzDbCreatorCreateHtml,
  u_dzFileStreams;

{ Tf_AccessExportWizard }

constructor Tf_dbCreatorWizard.Create(_Owner: TComponent);
begin
  inherited;
  FLogConsole := TdzLogConsole.Create(Self);
  SetGlobalLogger(TEventLogger.Create(FLogConsole.LogCallback));
//  LogProgramVersion(LL_INFO);
  FSourceFile := Tf_SourceFile.Create(self);
  FSourceFile.TheFormStorage.AppStorage := TheAppRegistryStorage;
  FSourceFileId := Pages.AddPage(FSourceFile, 'Source file can be either an Access Database or an XML-Description of the database.', FSourceFile);
  FOptions := Tf_Options.Create(Self);
  FOptions.TheFormStorage.AppStorage := TheAppRegistryStorage;
  FOptionsId := Pages.AddPage(FOptions, 'Select options', FOptions);
  FExportFormat := Tf_ExportFormat.Create(Self);
  FExportFormatId := Pages.AddPage(FExportFormat, 'Please select the export format to create.', FExportFormat);
  FAddUser := Tf_AddUser.Create(Self);
  FAddUserId := Pages.AddPage(FAddUser, 'If you are creating an Oracle or MS SQL Server script, you must enter a user name and password of the database''s owner here.', FAddUser);
end;

destructor Tf_dbCreatorWizard.Destroy;
begin
  SetGlobalLogger(nil);
  inherited;
end;

function Tf_dbCreatorWizard.DoBeforePageChange(_Direction: TPrevNext;
  _OldPageId: integer; var _NewPageId: integer; _OldPageData,
  _NewPageData: pointer): boolean;
begin
  if _Direction = pnPrevious then begin
    Result := true;
    exit;
  end;

  result := false;
  if _OldPageId = FSourceFileId then begin
    FExportFormat.SetBaseFilename(FSourceFile.fe_SourceFile.Filename);
    Result := ReadSourceFile(FSourceFile.fe_SourceFile.Filename,
      FSourceFile.ed_DbPassword.Text,
      FSourceFile.chk_IncludeData.Checked,
      FSourceFile.chk_MakeAutoInc.Checked,
      FSourceFile.chk_ConsolidateIndices.Checked);
  end else if _OldPageId = FOptionsId then begin
    FDbDescription.Prefix := FOptions.ed_Prefix.Text;
    Result := true;
  end else if _OldPageId = FExportFormatId then begin
    Result := true;
  end else if _OldPageId = FAddUserId then begin
    if FExportFormat.GetFormat * [efOracle, efMsSql] <> [] then begin
      Result := (FAddUser.ed_Username.Text <> '') and (FAddUser.ed_DatabaseName.Text <> '');
      if Result then
        FDbDescription.Name := FAddUser.ed_DatabaseName.Text;
    end else
      Result := true;
  end;

  if _NewPageId = FAddUserId then begin
    if FExportFormat.GetFormat * [efOracle, efMsSql] <> [] then begin
      FAddUser.chk_AddUser.Checked := true;
      FAddUser.chk_AddUser.Enabled := false;
    end else
      FAddUser.chk_AddUser.Enabled := true;
    FAddUser.ed_DatabaseName.Text := FDbDescription.Name;
  end;
end;

procedure Tf_dbCreatorWizard.chk_ConsoleClick(Sender: TObject);
begin
  FLogConsole.Visible := chk_Console.Checked;
end;

function Tf_dbCreatorWizard.ReadSourceFile(const _SourceFile, _Password: string;
  _IncludeData, _MakeAutoInc, _ConsolidateIndices: boolean): boolean;
var
  s: string;
begin
  if _SourceFile = FSourceFileName then begin
    if MessageDlg('You have already loaded this file, load it again?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
      Result := true;
      exit;
    end;
  end;
  Screen.Cursor := crHourglass;
  try
    Result := false;
    try
      if _SourceFile = '' then
        exit;

      FDbDescription := TdzDbDescription.Create('ToBeOverwritten', ''); // no prefix yet

      s := ExtractFileExt(_SourceFile);
      if AnsiSameText(s, '.xml') then
        ReadXml(_SourceFile, _IncludeData)
      else if AnsiSameText(s, '.mdb') then
        ReadAccess(_SourceFile, _Password, _IncludeData, _MakeAutoInc, _ConsolidateIndices)
      else
        raise exception.CreateFmt('Unknown source format %s.', [s]);
      FSourceFileName := _SourceFile;
      Result := true;
    except
      on e: exception do begin
        LogError(Format('%s: %s', [e.ClassName, e.Message]));
        Application.ShowException(e);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;

end;

procedure Tf_dbCreatorWizard.ReadAccess(const _SrcFile, _DbPassword: string;
  _IncludeData, _MakeAutoInc, _ConsolidateIndices: boolean);
begin
  LogInfo('Source format is Access database.');
  FDbDescription.Name := ChangeFileExt(ExtractFileName(_SrcFile), '');
  TAccessDbReader.ReadAccess(_SrcFile, _DbPassword, FDbDescription, _IncludeData, _MakeAutoInc, _ConsolidateIndices);
end;

procedure Tf_dbCreatorWizard.ReadXml(const _SrcFile: string; _IncludeData: boolean);
var
  Stream: TdzFile;
  s: string;
begin
  LogInfo('Source format is XML description of database.');
  Stream := TdzFile.Create(_SrcFile);
  try
    Stream.AccessMode := [faRead];
    Stream.ShareMode := [fsRead];
    Stream.CreateDisposition := fcOpenFailIfNotExists;
    Stream.Open;
    SetLength(s, Stream.Size);
    Stream.Read(s[1], Length(s));
  finally
    Stream.Free;
  end;
  TXmlDbReader.ParseXml(s, FDbDescription, _IncludeData);
end;

procedure Tf_dbCreatorWizard.WriteExportFiles;
var
  ef: TExportFormat;
  ExportFormats: TExportFormatSet;
  Filename: string;
begin
  ExportFormats := FExportFormat.GetFormat;
  for ef := low(TExportFormat) to high(TExportFormat) do begin
    if ef in ExportFormats then begin
      Filename := FExportFormat.GetFilename(ef);
      if Filename <> '' then
        WriteExportFile(ef, Filename);
    end;
  end;
end;

function Tf_dbCreatorWizard.DoOnFinished: boolean;
begin
  try
    if FOptions.chk_AddChecksum.Checked then
      AddChecksumField;
    if FOptions.chk_RemoveChksum.Checked then
      RemoveChecksumField;

    if FAddUser.chk_AddUser.Checked then begin
        { TODO -otwm : AppendUser wieder einbauen }
        //fDbDescription.AppendUser(fAddUser.ed_Username.Text, fAddUser.ed_Password.Text);
    end;

    WriteExportFiles;

    //    if fOptions.chk_GenerateDelphi.Checked then
    //      GenerateDelphi(fDestFile.fe_OutFile.Filename);

    LogInfo('Done');
    MessageDlg('Done', mtInformation, [mbOK], 0);
    Result := true;
//    fSourceFile.fe_SourceFile.AddToHistory(fSourceFile.fe_SourceFile.Filename);
    //    fDestFile.fe_OutFile.AddToHistory(fDestFile.fe_OutFile.Filename);
  except
    on e: exception do begin
      LogError(Format('%s: %s', [e.ClassName, e.Message]));
      Application.ShowException(e);
      Result := false;
    end;
  end;
end;

procedure Tf_dbCreatorWizard.AddChecksumField;
var
  tbl: integer;
  TableDescription: IdzDbTableDescription;
  ColumnDescription: IdzDbColumnDescription;
begin
  for tbl := 0 to FDbDescription.TableCount - 1 do begin
    TableDescription := FDbDescription.Tables[tbl];
    ColumnDescription := TableDescription.ColumnByName(CHKSUM_FIELD);
    if not assigned(ColumnDescription) then begin
      LogInfo(Format('Adding column %s to table %s.', [CHKSUM_FIELD, TableDescription.Name]));
      ColumnDescription := TableDescription.AppendColumn(CHKSUM_FIELD, dtLongInt, 0, 'Pruefsumme', naNotNull);
    end;
  end;
end;

procedure Tf_dbCreatorWizard.RemoveChecksumField;
var
  tbl: integer;
  TableDescription: IdzDbTableDescription;
  Idx: integer;
begin
  for tbl := 0 to FDbDescription.TableCount - 1 do begin
    TableDescription := FDbDescription.Tables[tbl];
    Idx := TableDescription.ColumnIndex(CHKSUM_FIELD);
    if Idx <> -1 then begin
      LogInfo(Format('Removing column %s from table %s.', [CHKSUM_FIELD, TableDescription.Name]));
      TableDescription.DeleteColumn(Idx);
    end;
  end;
end;

procedure Tf_dbCreatorWizard.WriteExportFile(_ExportFormat: TExportFormat; const _Outfile: string);
var
  DbCreator: IdzDbCreator;
  outpt, incl, modu: TStringList;
  incfile, modfile: string;
begin
  incfile := ChangeFileExt(_OutFile, '.inc');
  modfile := ChangeFileExt(_OutFile, '.bas');

  LogInfo(Format('generating new database %s', [_Outfile]));
  if FileExists(_OutFile) then
    if IDYes = MessageDlg(Format('File "%s" exists.'#13#10 + 'Overwrite?', [_OutFile]), mtWarning, [mbYes, mbNo], 0) then
      DeleteFile(_OutFile)
    else
      exit;

  Screen.Cursor := crHourGlass;
  outpt := TStringList.Create;
  incl := TStringList.Create;
  modu := TStringList.Create;
  try
    case _ExportFormat of
      efOracle:
        DbCreator := TOracleDbCreator.Create(outpt, incl, modu);
      efMsSql:
        DbCreator := TMsSqlDbCreator.Create(outpt);
      efAccess:
        DbCreator := TAccessDbCreator.Create(_OutFile, FOptions.AccessVersion);
      efXml:
        DbCreator := TXmlDbCreator.Create(_OutFile);
      efGraphViz:
        DbCreator := TGraphVizDbCreator.Create(_OutFile,
          FOptions.chk_ReferencedTablesOnly.Checked,
          FOptions.chk_ReferencedColumnsOnly.Checked);
      efHtml:
        DbCreator := THtmlDbCreator.Create(_Outfile,
          FOptions.sed_HeadingStartLevel.AsInteger);
    end;
    if Assigned(DbCreator) then
      DbCreator.WriteDbDesc(FDbDescription, FDbDescription.DbTypeByName('oracle'));
    case _ExportFormat of
      efOracle: begin
          outpt.SaveToFile(_OutFile);
          incl.SaveToFile(incfile);
          modu.SaveToFile(modfile);
        end;
      efMsSql:
        outpt.SaveToFile(_OutFile);
      efAccess,
        efXml:
        ; // nothing to do
      efDelphi:
        GenerateDelphi(_Outfile);
    end;
  finally
    DbCreator := nil;
    outpt.Free;
    incl.Free;
    modu.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure Tf_dbCreatorWizard.GenerateDelphi(const _DestFile: string);
const
  ROUTINE_ID = '[Tf_AccessExport.GenerateDelphi]';
var
  Prefix: string;
  InterfaceSection: TStringList;
  ImplementationSection: TStringList;
  DbCreateMethod: TStringList;
  DbDestroyMethod: TStringList;
  DbProtectedDeclaration: TStringList;
  DbPublicDeclaration: TStringList;
  DbChecksumMethod: TStringList;
  AppendParams: string;
  ReadParams: string;
  IdParam: string;
  KeyParam: string;
  KeyType: TFieldDataType;
  AppendLen: integer;
  ReadLen: integer;
  TblName: string;
  TableDesc: IdzDbTableDescription;
  ColNames: TStringList;
  ValidChars: array[char] of char;
  HasChksumField: boolean;

  procedure InitValidChars;
  var
    c: char;
  begin
    for c := low(char) to high(char) do
      if c in ['a'..'z', 'A'..'Z', '0'..'9'] then
        ValidChars[c] := c
      else
        ValidChars[c] := '_';
  end;

  function FilterSpecialChars(const _s: string): string;
  var
    i: integer;
  begin
    SetLength(Result, Length(_s));
    for i := 1 to Length(Result) do
      Result[i] := ValidChars[_s[i]];
  end;

  function DbTypeToDelphiType(_DataType: TFieldDataType): string;
  const
    ROUTINE_ID = '[TForm1.GenerateDelphi|DbTypeToDelphiType]';
  begin
    case _DataType of
      dtLongInt: Result := 'integer';
      dtDouble: Result := 'double';
      dtText: Result := 'string';
      dtMemo: Result := 'string';
      dtDate: Result := 'TDateTime';
    else
      raise exception.CreateFmt('%s: unknown database field type', [ROUTINE_ID]);
    end;
  end;

  function DbTypeToFormatString(_DataType: TFieldDataType): string;
  const
    ROUTINE_ID = '[TForm1.GenerateDelphi|DbTypeToDelphiType]';
  begin
    case _DataType of
      dtLongInt: Result := '%d';
      dtDouble: Result := '%g';
      dtText: Result := '%s';
      dtMemo: Result := '%s';
    else
      raise exception.CreateFmt('%s: unsupported database field type', [ROUTINE_ID]);
    end;
  end;

  procedure AddFunctionParam(const _ColName: string; _ColDesc: IdzDbColumnDescription;
    _TableDesc: IdzDbTableDescription);
  var
    DataType: TFieldDataType;
    s: string;
    ii: integer;
    found: boolean;
  begin
    DataType := _ColDesc.DataType;

    if _ColDesc.AutoInc then begin
      Assert(_ColDesc.DataType = dtLongint);
      IdParam := _ColDesc.Name;
      KeyParam := IdParam;
      KeyType := DataType;
      Exit;
    end;

    //TODO -ouwe: implementierung ist hingehuddelt, funktioniert nur fuer einspaltige PrimaryKeys
    //begin huddel
    found := false;
    for ii := 0 to _TableDesc.IndiceCount - 1 do
      if _TableDesc.Indices[ii].IsPrimaryKey and
        (_TableDesc.Indices[ii].ColumnCount = 1) and
        (_TableDesc.Indices[ii].Column[0].Name = _ColDesc.Name) then begin
        found := true;
        break;
      end;

    if found then
    {//end huddel}begin
      KeyParam := _ColDesc.Name;
      KeyType := DataType;
    end else begin
      if ReadParams <> '' then begin
        ReadParams := ReadParams + '; ';
        Inc(ReadLen, 2);
      end;
      s := Format('out _%s: %s', [_ColName, DbTypeToDelphiType(DataType)]);
      if ReadLen + Length(s) > 80 then begin
        ReadParams := ReadParams + #13#10'      ';
        ReadLen := 6;
      end;
      ReadParams := ReadParams + s;
      Inc(ReadLen, Length(s));
    end;

    if AppendParams <> '' then begin
      AppendParams := AppendParams + '; ';
      Inc(AppendLen, 2);
    end;
    s := Format('const _%s: %s', [_ColName, DbTypeToDelphiType(DataType)]);
    if AppendLen + Length(s) > 80 then begin
      AppendParams := AppendParams + #13#10'      ';
      AppendLen := 6;
    end;
    AppendParams := AppendParams + s;
    Inc(AppendLen, Length(s));
  end;

  procedure InsertClassDeclaration;
  begin
    InterfaceSection.Add('type');
    InterfaceSection.Add(Format('  T%sTableAuto = class(TTableAuto)', [TblName]));
    InterfaceSection.Add({*****}'  public');
    InterfaceSection.Add({*****}'    constructor Create(_tbl: TDataset; const _Prefix: string = '''');');
    ImplementationSection.Add(Format('constructor T%sTableAuto.Create(_tbl: TDataset; const _Prefix: string = '''');', [TblName]));
    ImplementationSection.Add({*****}'const');
    ImplementationSection.Add(Format('  ROUTINE_ID = ''[T%sTableAuto.Create]'';', [TblName]));
    ImplementationSection.Add({*****}'begin');
    ImplementationSection.Add({*****}'  LogLineFmt(LL_DEBUG, ''%s:'', [ROUTINE_ID]);');
    ImplementationSection.Add(Format('  inherited Create(_Tbl, %s, _Prefix);', [IfThen(HasChksumField, 'true', 'false')]));
    ImplementationSection.Add({*****}'end;');
    ImplementationSection.Add({*****}'');
  end;

  procedure InsertClassEnd;
  begin
    InterfaceSection.Add('  end;');
    InterfaceSection.Add('');
  end;

  procedure InsertChecksumFunction;
  var
    s: string;
    col: integer;
    ColDesc: IdzDbColumnDescription;
    ColName: string;
  begin
    InterfaceSection.Add('    function CalcChecksum: integer; virtual;');
    ImplementationSection.Add(Format('function T%sTableAuto.CalcChecksum: integer;', [TblName]));
    ImplementationSection.Add({*****}'const');
    ImplementationSection.Add(Format('  ROUTINE_ID = ''[T%sTableAuto.CalcChecksum]'';', [TblName]));
    ImplementationSection.Add({*****}'var');
    ImplementationSection.Add({*****}'  s: string;');
    ImplementationSection.Add({*****}'begin');
    ImplementationSection.Add({*****}'  LogLineFmt(LL_DEBUG, ''%s:'', [ROUTINE_ID]);');
    ImplementationSection.Add({*****}'  s := '''';');
    for col := 0 to ColNames.Count - 1 do begin
      ColDesc := TableDesc.ColumnByName(ColNames[col]);
      Assert(Assigned(ColDesc));
      ColName := ColDesc.Name;
      if ColDesc.AutoInc then begin
        ImplementationSection.Add(Format('  s := s + IntToStr(Var2IntEx(fTbl[Prefix + ''%1:s''], ''%0:s.%1:s''));', [TblName, ColName]));
      end else if ColDesc.AllowNull = naNotNull then begin
        case ColDesc.DataType of
          dtLongInt: s := 'IntToStr(Var2IntEx(fTbl[Prefix + ''%s''], ''%s.%s''));';
          dtDouble: s := 'Float2Str(Var2DblEx(fTbl[Prefix + ''%s''], ''%s.%s''));';
          dtText,
            dtMemo: s := 'Var2StrEx(fTbl[Prefix + ''%s''], ''%s.%s'');';
          dtDate: s := 'FormatDateTime(''yyyy-mm-dd hh:nn:ss'', Var2DateTimeEx(fTbl[Prefix + ''%s''], ''%s.%s''));';
        end;
        ImplementationSection.Add('  s := s + ' + Format(s, [ColName, TblName, ColName]));
      end else begin
        case ColDesc.DataType of
          dtLongInt: s := 'Var2IntStr(fTbl[Prefix + ''%s'']);';
          dtDouble: s := 'Var2DblStr(fTbl[Prefix + ''%s'']);';
          dtText,
            dtMemo: s := 'Var2Str(fTbl[Prefix + ''%s''], ''*NULL*'');';
          dtDate: s := 'Var2DateTimeStr(fTbl[Prefix + ''%s'']);';
        end;
        ImplementationSection.Add('  s := s + ' + Format(s, [ColName]));
      end;
    end;

    ImplementationSection.Add('  Result := TV2kUtils.Crc32l(Trim(s));');
    ImplementationSection.Add('end;');
    ImplementationSection.Add('');
  end;

  procedure InsertSetCheckumsFunction;
  begin
    InterfaceSection.Add('    function SetChecksums: integer; virtual;');
    ImplementationSection.Add(Format('function T%sTableAuto.SetChecksums: integer;', [TblName]));
    ImplementationSection.Add({*****}'const');
    ImplementationSection.Add(Format('  ROUTINE_ID = ''[T%sTableAuto.CalcChecksum]'';', [TblName]));
    ImplementationSection.Add({*****}'var');
    ImplementationSection.Add({*****}'  chk: Longint;');
    ImplementationSection.Add({*****}'  Id: integer;');
    ImplementationSection.Add({*****}'begin');
    ImplementationSection.Add({*****}'  LogLineFmt(LL_DEBUG, ''%s:'', [ROUTINE_ID]);');
    ImplementationSection.Add({*****}'  Result := 0;');
    ImplementationSection.Add({*****}'  fTbl.Active := true;');
    ImplementationSection.Add({*****}'  fTbl.First;');
    ImplementationSection.Add({*****}'  while not fTbl.Eof do');
    ImplementationSection.Add({*****}'    begin');
    ImplementationSection.Add({*****}'      chk := CalcChecksum;');
    ImplementationSection.Add(Format('      if fTbl[Prefix + ''%s''] <> chk then', [CHKSUM_FIELD]));
    ImplementationSection.Add({*****}'        begin');
    ImplementationSection.Add({*****}'          Id := fTbl[Prefix + ''Id''];');
    ImplementationSection.Add({*****}'          LogLineFmt(LL_DUMP, ''set chksum for ID %d '', [Id]);');
    ImplementationSection.Add({*****}'          fTbl.Edit;');
    ImplementationSection.Add({*****}'          try');
    ImplementationSection.Add(Format('            fTbl[Prefix + ''%s''] := chk;', [CHKSUM_FIELD]));
    ImplementationSection.Add({*****}'            fTbl.Post;');
    ImplementationSection.Add({*****}'            Inc(Result);');
    ImplementationSection.Add({*****}'          except');
    ImplementationSection.Add({*****}'            fTbl.Cancel;');
    ImplementationSection.Add({*****}'            raise;');
    ImplementationSection.Add({*****}'          end;');
    ImplementationSection.Add({*****}'        end;');
    ImplementationSection.Add({*****}'      fTbl.Next;');
    ImplementationSection.Add({*****}'    end;');
    ImplementationSection.Add({*****}'  LogLineFmt(LL_DEBUG, ''done, %d checksums adjusted'', [Result]);');
    ImplementationSection.Add({*****}'end;');
    ImplementationSection.Add({*****}'');
  end;

  procedure InsertAppendFunction;
  var
    CrLf: string;
    FmtChar, Params: string;
    col: integer;
    ColDesc: IdzDbColumnDescription;
    ColName: string;
  begin
    //    if KeyParam = '' then
    //      begin
    //        InterfaceSection.Add('    // table has no primary key, no Append function generated');
    //        exit;
    //      end;

    // if it is the ID field, generate a function, otherwise a procedure
    if IdParam = '' then begin
      InterfaceSection.Add(Format('    procedure Append(%s); virtual;', [AppendParams]));
      ImplementationSection.Add(Format('procedure T%sTableAuto.Append(%s);', [TblName, AppendParams]));
    end else begin
      InterfaceSection.Add(Format('    function Append(%s): integer; virtual;', [AppendParams]));
      ImplementationSection.Add(Format('function T%sTableAuto.Append(%s): integer;', [TblName, AppendParams]));
    end;
    ImplementationSection.Add({*****}'const');
    ImplementationSection.Add(Format('  ROUTINE_ID = ''[T%sTableAuto.Append]'';', [TblName]));
    ImplementationSection.Add({*****}'var');
    ImplementationSection.Add({*****}'  Values: string;');
    ImplementationSection.Add({*****}'begin');
    ImplementationSection.Add({*****}'  LogLineFmt(LL_DEBUG, ''%s:'', [ROUTINE_ID]);');
    ImplementationSection.Add({*****}'  Values := '''';');

    for col := 0 to ColNames.Count - 1 do begin
      ColDesc := TableDesc.ColumnByName(ColNames[col]);
      Assert(Assigned(ColDesc));
      ColName := ColDesc.Name;
      if ColDesc.AutoInc then
        ImplementationSection.Add(Format('  // %s is AutoInc field', [ColName]))
      else begin
        Params := '_%s';
        case ColDesc.DataType of
          dtLongInt: FmtChar := 'd';
          dtDouble: FmtChar := 'g';
          dtText: FmtChar := 's';
          dtMemo: FmtChar := 's';
          dtDate: begin
              FmtChar := 's';
              Params := 'DateTime2Iso(_%s)';
            end;
        else
          raise exception.Create('unknown data type');
        end;
        Params := Format(Params, [ColName]);
        ImplementationSection.Add(Format('  LogLineFmt(LL_DUMP, ''%s: %%%s'', [%s]);', [ColName, FmtChar, Params]));
        if Col <> ColNames.Count - 1 then
          CrLf := ' + #13#10'
        else
          CrLf := '';
        ImplementationSection.Add(Format('  Values := Values + Format(''%s: %%%s'', [%s])%s;', [ColName, FmtChar, Params, CrLf]));
      end;
    end;
    ImplementationSection.Add({*****}'  fTbl.Append;');
    ImplementationSection.Add({*****}'  try');
    for col := 0 to ColNames.Count - 1 do begin
      ColDesc := TableDesc.ColumnByName(ColNames[col]);
      Assert(Assigned(ColDesc));
      ColName := ColDesc.Name;
      if ColDesc.AutoInc then
        ImplementationSection.Add(Format('    // %s is AutoInc field, ignored', [ColName]))
      else if (ColDesc.DataType in [dtText, dtMemo]) and (ColDesc.AllowNull = naNull) then begin
        ImplementationSection.Add(Format('    if _%s <> '''' then', [ColName]));
        ImplementationSection.Add(Format('      fTbl[Prefix + ''%s''] := _%s;', [ColName, ColName]));
      end else
        ImplementationSection.Add(Format('    fTbl[Prefix + ''%s''] := _%s;', [ColName, ColName]));
    end;
    if HasChksumField then
      ImplementationSection.Add(Format('    fTbl[Prefix + ''%s''] := -1;', [CHKSUM_FIELD]));
    ImplementationSection.Add({*****}'    fTbl.Post;');
    if IdParam <> '' then
      ImplementationSection.Add(Format('    Result := fTbl[Prefix + ''%s''];', [IdParam]));
    if HasChksumField then begin
      ImplementationSection.Add({*****}'    fTbl.Edit;');
      ImplementationSection.Add(Format('    fTbl[Prefix + ''%s''] := CalcChecksum;', [CHKSUM_FIELD]));
      ImplementationSection.Add({*****}'    fTbl.Post;');
    end;
    ImplementationSection.Add({*****}'  except');
    ImplementationSection.Add({*****}'    on e: exception do');
    ImplementationSection.Add({*****}'      begin');
    ImplementationSection.Add({*****}'        fTbl.Cancel;');
    ImplementationSection.Add({*****}'        LogError(Format( ''%s: %s: %s'', [ROUTINE_ID, e.ClassName, e.Message]));');
    ImplementationSection.Add({*****}'        raise EDbInsertError.Create(ROUTINE_ID, e, Values, true);');
    ImplementationSection.Add({*****}'      end;');
    ImplementationSection.Add({*****}'  end;');
    ImplementationSection.Add({*****}'end;');
    ImplementationSection.Add({*****}'');
  end;

  procedure InsertReadFunction;
  var
    s: string;
    col: integer;
    ColDesc: IdzDbColumnDescription;
    ColName: string;
    ii: integer;
    found: boolean;
  begin
    if KeyParam = '' then begin
      InterfaceSection.Add('    // table has no primary key or a multi column primary key, so no Read function is generated');
      exit;
    end;
    s := '// Note: This function works only if there are no null columns in the record!';
    InterfaceSection.Add('    ' + s);
    InterfaceSection.Add(Format('    function Read(const _%s: %s; %s): boolean; virtual;', [KeyParam, DbTypeToDelphiType(KeyType), ReadParams]));
    ImplementationSection.Add(s);
    ImplementationSection.Add(Format('function T%sTableAuto.Read(const _%s: %s; %s): boolean;', [TblName, KeyParam, DbTypeToDelphiType(KeyType), ReadParams]));
    ImplementationSection.Add('const');
    ImplementationSection.Add(Format('  ROUTINE_ID = ''T%sTableAuto.Read'';', [TblName]));
    if HasChksumField then begin
      ImplementationSection.Add('var');
      ImplementationSection.Add('  ChkSum: integer;');
    end;
    //    ImplementationSection.Add('  s: string;');
    ImplementationSection.Add('begin');
    ImplementationSection.Add('  LogLineProc(LL_DEBUG, ROUTINE_ID, ''enter'');');
    ImplementationSection.Add(Format('  Result := fTbl.Locate(Prefix + ''%s'', _%s, []);', [KeyParam, KeyParam]));
    ImplementationSection.Add('  if not Result then');
    ImplementationSection.Add('    Exit;');
    ImplementationSection.Add('  try');
    if HasChksumField then begin
      ImplementationSection.Add('    ChkSum := CalcChecksum;');
      ImplementationSection.Add(Format('    if ChkSum <> Var2IntEx(fTbl[Prefix + ''%s''], ''%s.%s'') then', [CHKSUM_FIELD, TblName, CHKSUM_FIELD]));
      ImplementationSection.Add(Format('      raise EWrongChecksum.CreateProcFmt(ROUTINE_ID, ''Invalid checksum for record with %s %s'', [_%s], true);', [KeyParam, DbTypeToFormatString(KeyType), KeyParam]));
    end;
    for col := 0 to ColNames.Count - 1 do begin
      ColDesc := TableDesc.ColumnByName(ColNames[col]);
      Assert(Assigned(ColDesc));
      ColName := ColDesc.Name;

        //TODO -ouwe: implementierung ist hingehuddelt, funktioniert nur fuer einspaltige PrimaryKeys
        //begin huddel
      found := false;
      for ii := 0 to TableDesc.IndiceCount - 1 do
        if TableDesc.Indices[ii].IsPrimaryKey and
          (TableDesc.Indices[ii].ColumnCount = 1) and
          (TableDesc.Indices[ii].Column[0].Name = ColDesc.Name) then begin
          found := true;
          break;
        end;

      if found then
          //end huddel
        ImplementationSection.Add(Format('    // %s is primary key field, ignored', [ColName]))
      else begin
        case ColDesc.DataType of
          dtLongInt: s := 'Var2IntEx(fTbl[Prefix + ''%s''], ''%s.%s'');';
          dtDouble: s := 'Var2DblEx(fTbl[Prefix + ''%s''], ''%s.%s'');';
          dtText,
            dtMemo:
            if ColDesc.AllowNull = naNotNull then
              s := 'Var2StrEx(fTbl[Prefix + ''%s''], ''%s.%s'');'
            else
              s := 'Var2Str(fTbl[Prefix + ''%s''], '''');';
          dtDate: s := 'Var2DateTimeEx(fTbl[Prefix + ''%s''], ''%s.%s'');';
        end;
        ImplementationSection.Add(Format('    _%s := ' + s, [ColName, ColName, TblName, ColName]));
      end;
    end;
    ImplementationSection.Add({*****}'  except');
    ImplementationSection.Add({*****}'    on EWrongChecksum do');
    ImplementationSection.Add({*****}'      raise;');
    ImplementationSection.Add({*****}'    on e: exception do');
    ImplementationSection.Add({*****}'      raise EHkExceptionWrapper.CreateProc(ROUTINE_ID, e, e.Message, true);');
    ImplementationSection.Add({*****}'  end;');
    ImplementationSection.Add({*****}'end;');
    ImplementationSection.Add({*****}'');
  end;

  procedure InsertDatabaseObject;
  var
    i: integer;
    DbBasename: string;
  begin
    DbBasename := FilterSpecialChars(FDbDescription.Name);
    InterfaceSection.Add({*****}'type');
    InterfaceSection.Add(Format('  T%sDbAuto = class(TDatabaseAuto)', [DbBasename]));
    InterfaceSection.Add({*****}'  protected');
    for i := 0 to DbProtectedDeclaration.Count - 1 do
      InterfaceSection.Add(DbProtectedDeclaration[i]);
    InterfaceSection.Add({*****}'  public');
    InterfaceSection.Add({*****}'    constructor Create(_Connection: TAdoConnection; const _Prefix: string = '''');');
    InterfaceSection.Add({*****}'    destructor Destroy; override;');
    InterfaceSection.Add({*****}'    function SetChecksums: integer;');
    for i := 0 to DbPublicDeclaration.Count - 1 do
      InterfaceSection.Add(DbPublicDeclaration[i]);
    InterfaceSection.Add({*****}'  end;');

    ImplementationSection.Add(Format('constructor T%sDbAuto.Create(_Connection: TAdoConnection; const _Prefix: string = '''');', [DbBasename]));
    ImplementationSection.Add({*****}'begin');
    ImplementationSection.Add({*****}'  inherited Create(_Connection, _Prefix);');
    for i := 0 to DbCreateMethod.Count - 1 do
      ImplementationSection.Add(DbCreateMethod[i]);
    ImplementationSection.Add({*****}'end;');
    ImplementationSection.Add({*****}'');
    ImplementationSection.Add(Format('destructor T%sDbAuto.Destroy;', [DbBasename]));
    ImplementationSection.Add({*****}'begin');
    for i := 0 to DbDestroyMethod.Count - 1 do
      ImplementationSection.Add(DbDestroyMethod[i]);
    ImplementationSection.Add({*****}'  inherited;');
    ImplementationSection.Add({*****}'end;');
    ImplementationSection.Add({*****}'');
    ImplementationSection.Add(Format('function T%sDbAuto.SetChecksums: integer;', [DbBasename]));
    ImplementationSection.Add({*****}'begin');
    ImplementationSection.Add({*****}'  Result := 0;');
    for i := 0 to DbChecksumMethod.Count - 1 do
      ImplementationSection.Add(DbChecksumMethod[i]);
    ImplementationSection.Add({*****}'end;');
  end;

  procedure InsertTableIntoDatabase;
  begin
    DbProtectedDeclaration.Add(Format('    f%sTbl: TAdoTable;', [TblName]));
    DbProtectedDeclaration.Add(Format('    f%0:sTable: T%0:sTableAuto;', [TblName]));
    DbPublicDeclaration.Add(Format('    property %0:sTable: T%0:sTableAuto read f%0:sTable;', [TblName]));
    DbCreateMethod.Add(Format('  f%0:sTbl := CreateTable(Prefix + ''%0:s'');', [TblName]));
    DbCreateMethod.Add(Format('  f%0:sTable := T%0:sTableAuto.Create(f%0:sTbl, Prefix);', [TblName]));
    DbDestroyMethod.Add(Format('  f%0:sTable.Free;', [TblName]));
    if HasChksumField then
      DbChecksumMethod.Add(Format('  Result := Result + f%0:sTable.SetChecksums;', [TblName]));
  end;

var
  tbl: integer;
  col: integer;
  ColName: string;
  ColDesc: IdzDbColumnDescription;
  s: string;
  Stream: TdzFile;
  Unitname: string;
begin
  InitValidChars;
  Unitname := FilterSpecialChars(ChangeFileExt(ExtractFilename(_DestFile), ''));
  if not AnsiSameText(RightStr(Unitname, 5), '_Code') then
    Unitname := Unitname + '_Code';
  s := ExtractFilePath(_DestFile);
  Stream := TdzFile.Create(s + UnitName + '.pas');
  try
    Stream.AccessMode := faReadWrite;
    Stream.ShareMode := fsNoSharing;
    Stream.CreateDisposition := fcCreateTruncateIfExists;
    Stream.Open;

    InterfaceSection := TStringList.Create;
    ImplementationSection := TStringList.Create;
    DbCreateMethod := TStringList.Create;
    DbDestroyMethod := TStringList.Create;
    DbProtectedDeclaration := TStringList.Create;
    DbPublicDeclaration := TStringList.Create;
    DbChecksumMethod := TStringList.Create;
    try
      Prefix := FDbDescription.Prefix;
      InterfaceSection.Add(Format('unit %s;', [Unitname]));
      InterfaceSection.Add('');
      InterfaceSection.Add('{$i globaldef.inc}');
      InterfaceSection.Add('');
      InterfaceSection.Add(Format('// checksum append and read functions for database %s', [FDbDescription.Name]));
      InterfaceSection.Add('// automatically generated by AccessExport, do not edit!');
      InterfaceSection.Add('');
      InterfaceSection.Add('interface');
      InterfaceSection.Add('');
      InterfaceSection.Add('uses');
      InterfaceSection.Add('  SysUtils,');
      InterfaceSection.Add('  Classes,');
      InterfaceSection.Add('  contnrs,');
      InterfaceSection.Add('  db,');
      InterfaceSection.Add('  AdoDb,');
      InterfaceSection.Add('  eu.icd.logging.api,');
      InterfaceSection.Add('  eu.icd.errorhandling.exception,');
      InterfaceSection.Add('  eu.icd.utils.misc,');
      InterfaceSection.Add('  eu.icd.classes.dbauto,');
      InterfaceSection.Add('  eu.icd.crypto.v2kutils;');
      InterfaceSection.Add('');
      ImplementationSection.Add('implementation');
      ImplementationSection.Add('');
      ColNames := TStringList.Create;
      try
        ColNames.Sorted := true;
        for tbl := 0 to FDbDescription.TableCount - 1 do begin
          TableDesc := FDbDescription.Tables[tbl];
          TblName := TableDesc.Name;
          ColNames.Clear;
          AppendLen := 0;
          ReadLen := 0;
          AppendParams := '';
          ReadParams := '';
          IdParam := '';
          KeyParam := '';
          HasChksumField := false;
          for col := 0 to TableDesc.ColumnCount - 1 do begin
            ColDesc := TableDesc.Columns[col];
            ColName := ColDesc.Name;
            if AnsiSameText(ColName, CHKSUM_FIELD) then
              HasChksumField := true
            else begin
              ColNames.Add(AnsiLowerCase(ColName));
              AddFunctionParam(ColName, ColDesc, TableDesc);
            end;
          end;
          InsertClassDeclaration;
          InsertAppendFunction;
          InsertReadFunction;
          if HasChksumField then begin
            InsertChecksumFunction;
            InsertSetCheckumsFunction;
          end;
          InsertClassEnd;
          InsertTableIntoDatabase;
        end;
      finally
        ColNames.Free;
      end;
      InsertDatabaseObject;
      ImplementationSection.Add('');
      ImplementationSection.Add('end.');
      InterfaceSection.SaveToStream(Stream);
      ImplementationSection.SaveToStream(Stream);
    finally
      DbChecksumMethod.Free;
      DbProtectedDeclaration.Free;
      DbPublicDeclaration.Free;
      DbCreateMethod.Free;
      DbDestroyMethod.Free;
      InterfaceSection.Free;
      ImplementationSection.Free;
    end;
  finally
    Stream.Free;
  end;
end;

end.


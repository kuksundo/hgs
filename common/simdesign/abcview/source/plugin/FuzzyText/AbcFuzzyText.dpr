library AbcFuzzyText;
{ ABC-View Plugin DLL

  Name: Fuzzy Text Match

  This plugin will try to detect text-documents that are closely identical
  but differ in just a few places

  Author: Nils Haeck

}

uses
  SysUtils,
  Controls,
  Classes,
  Dialogs,
  Forms,
  PluginConsts in '..\pluginconsts.pas',
  FuzzyTexts in 'FuzzyTexts.pas',
  FuzzyTextSetupDlg in 'FuzzyTextSetupDlg.pas' {frmFuzzyText},
  Aligrid in '..\..\Third\AliGrid\Aligrid.pas',
  ah_tool in '..\..\Third\AliGrid\ah_tool.pas',
  HardwRegs in '..\HardwRegs.pas' {frmAuthorise},
  DiskInfo in '..\..\Third\DiskInfo.pas';

{$R *.RES}

const

  cPluginName    = 'Fuzzy Text Match';
  cPluginVersion = 'v1.0';

function DoAuthorise(var AMessage: PChar): word; stdcall;
// A call to DoAuthorise expects this DLL to ask the user for authorisation key
// and should return cpcAuthSuccess if authorisation was successful. It can also be used
// to allow evaluation period, in that case return cpcAuthEval. In other cases
// return cpcAuthFail. Set AMessage to the registration message that must be displayed
// in the plugin dialog
begin
  Result := cpcModeNotAuth;
  AMessage := 'Authorise this plugin first!';

  // authorisation dialog
{  if not AcceptRegKey(cFuzzyTextMagic, FRegName, FRegKey) then
    DoAuthDialog(cFuzzyTextMagic, FRegName, FRegKey);
  // did it succeed
  if AcceptRegKey(cFuzzyTextMagic, FRegName, FRegKey) then begin}
    Result := cpcModeOK;
    AMessage := 'This plugin is authorised.';
    FAuthorised := True;
    SaveToIni(FDllFolder + 'fuzzytext.ini');
{  end;}
end;

procedure DoInit(AppPath, DllPath: PChar); stdcall;
// This is the initialization of the library. This routine should return
// the capability flags of the dll
begin
  // the application's and dll's folder
  FAppFolder := AppPath;
  FDllFolder := DllPath;

  FIniFile := FDllFolder + 'fuzzytext.ini';
  LoadFromINI(FIniFile);

  // Some other init work
  CreateXRefTable;
end;

function DoSetup(ASetup: pointer): word; stdcall;
// This routine is called when the dll must show the setup dialog box where the
// user can adjust the settings for the functionality. retrieving/storing of
// settings is the responsibility of the dll
begin
  Result := 0;
  // create the dialog box
  Application.CreateForm(TfrmFuzzyText, frmFuzzyText);
  Application.CreateForm(TfrmAuthorise, frmAuthorise);
  try
    // Populate it
    with frmFuzzyText do begin
      SettingsToForm(FIniFile);
      if ShowModal = mrOK then begin
        FormToSettings(FIniFile);
        SaveToIni(FIniFile);
      end;
    end;
  finally
    frmFuzzyText.Release;
  end;
end;

function FuzzyCompare(Data1: pointer; Size1: integer; Data2: pointer; Size2, Limit: integer): integer; stdcall;
// This is the core routine for the fuzzy text compare
begin
  Result := BlueprintCompare(Data1, Size1, Data2, Size2, Limit);
end;

function FuzzyAuxCompare(Name1, Name2: PChar): boolean; stdcall;
// Although the blueprints may be identical, there may be auxiliary properties
// that make the two items not a close match. This is evaluated here.
function GetFileSize(AName: string): int64;
var
  S: TSearchRec;
begin
  Result := 0;
  if FindFirst(AName, faAnyFile, S) = 0 then
    Result := S.Size;
  FindClose(S);
end;
begin
  case FFileDiffMethod of
  cftDiffNone:
    // No diff method, so always return true
    Result := True;
  cftDiffAsLimit:
    // We check if the file size difference is not more than the tolerance # bytes
    Result := abs(GetFileSize(Name1) - GetFileSize(Name2)) <= FTolLimits[FTolerance];
  cftDiffSelect:
    // We check if the file size difference is not more than the selected limit
    Result := abs(GetFileSize(Name1) - GetFileSize(Name2)) <= FDiffLimit;
  end;
end;

function FuzzyPreAccept(AName: PChar): boolean; stdcall;
begin
  Result := AcceptFiletype(ExtractFileExt(AName));
end;

function GetCapabilities: word; stdcall
// Return the capabilities (implemented functionality) in this plugin
begin
  // The capability flags we set for this plugin
  Result := cpcMustAuthorise +
            cpcAddFilter;
  // Indexing in background
  if FIndexMethod = cftIndexBackgr then
    Result := Result + cpcIndexFiles;
end;

function GetFilterName: PChar; stdcall
begin
  Result := 'Fuzzy text match filter';
end;

function GetFilterType: integer; stdcall
begin
  Result := cpcFilterFuzzy;
end;

function GetFuzzyLimit(ATolerance: integer): integer; stdcall;
begin
  Result := FTolLimits[ATolerance];
  // Store ATolerance for use in FuzzyAuxCompare, since this
  // one is called from the main app when determining Limit
  FTolerance := ATolerance;
end;

function GetFuzzyLimitStr(ATolerance: integer): PChar; stdcall;
begin
  Result := PChar(Format('%d characters', [GetFuzzyLimit(ATolerance)]));
end;

function GetPluginName: PChar; stdcall;
// Here we return the name of this plugin, this will appear in ABC-View in
// the plugins list
begin
  Result := PChar(cPluginName);
end;

function GetPluginVersion: PChar; stdcall;
// Here we return the version of this plugin, this will appear in ABC-View in
// the plugins list
begin
  Result := PChar(cPluginVersion);
end;

function GetPropertyID: word; stdcall;
begin
  // All numbers between $1000 and $2000 are reserved for plugins
  Result := $1000;
end;

procedure IndexByName(AName: PChar; M: TStream); stdcall;
// Here we do an indexing based on the filename AName
var
  S: TStream;
begin
  if not FAuthorised then exit;
  // Do we process this one
  if AcceptFiletype(ExtractFileExt(AName)) then begin
    // Yes so create a file stream and process
    S := TFileStream.Create(AName, fmOpenRead or fmShareDenyNone);
    try
      CreateBlueprint(S, M);
    finally
      S.Free;
    end;
  end;
end;

procedure IndexByStream(AName: PChar; S, M: TStream); stdcall;
// Index the stream S and put the result into M
begin
  if not FAuthorised then exit;
  // Do we process this one
  if AcceptFiletype(ExtractFileExt(AName)) then
    CreateBlueprint(S, M);
end;

function IsAuthorised(var AMessage: PChar): word; stdcall;
begin
  Result := cpcModeNotAuth;
  AMessage := 'Authorise this plugin first!';
  // test
  if AcceptRegKey(cFuzzyTextMagic, FRegName, FRegKey) then begin
    Result := cpcModeOK;
    FAuthorised := True;
    AMessage := 'This plugin is authorised.';
  end;
end;

procedure ShowInfo; stdcall;
begin
  ShowMessage(
    'Fuzzy Text Match Plugin'#13 +
    'Copyright(c) 2002 Nils Haeck M.Sc.'
  );
end;

exports

  DoAuthorise,
  DoInit,
  DoSetup,
  FuzzyAuxCompare,
  FuzzyCompare,
  FuzzyPreAccept,
  GetCapabilities,
  GetFilterName,
  GetFilterType,
  GetFuzzyLimit,
  GetFuzzyLimitStr,
  GetPluginName,
  GetPluginVersion,
  GetPropertyID,
  IndexByName,
  IndexByStream,
  IsAuthorised,
  ShowInfo;

end.

program BandS;

uses
  FastMM4,
  IdThreadSafe,
  IdGlobal,
  Forms,
  Windows,
  Dialogs,
  SysUtils,
  System.UITypes,
  BackupU in 'BackupU.pas',
  BackupProfileU in 'BackupProfileU.pas',
  KeywordEmailU in 'KeywordEmailU.pas',
  LogU in 'LogU.pas',
  frmAboutU in 'frmAboutU.pas' {frmAbout} ,
  frmActiveApplicationsU
    in 'frmActiveApplicationsU.pas' {frmActiveApplications} ,
  frmAddProgramU in 'frmAddProgramU.pas' {frmAddProgram} ,
  frmAutoUpdateU in 'frmAutoUpdateU.pas' {frmAutoUpdate} ,
  frmBackupAlertU in 'frmBackupAlertU.pas' {frmBackupAlert} ,
  frmBackupProfilesU in 'frmBackupProfilesU.pas' {frmBackupProfiles} ,
  frmBackupProgressU in 'frmBackupProgressU.pas' {frmBackupProgress} ,
  frmBandSU in 'frmBandSU.pas' {frmBandS} ,
  frmCustomBackupU in 'frmCustomBackupU.pas' {frmCustomBackup} ,
  frmEmailDetailsU in 'frmEmailDetailsU.pas' {frmEmailDetails} ,
  frmExceptionU in 'frmExceptionU.pas' {frmException} ,
  frmFailedBackupU in 'frmFailedBackupU.pas' {frmFailedBackup} ,
  frmFolderSelectU in 'frmFolderSelectU.pas' {frmFolderSelect} ,
  frmOptionsU in 'frmOptionsU.pas' {frmOptions} ,
  frmPasswordU in 'frmPasswordU.pas' {frmPassword} ,
  dlgUpdateInformationU in 'dlgUpdateInformationU.pas' {dlgUpdateInformation} ,
  ExitWindowsU in 'ExitWindowsU.pas',
  frmExitConfimU in 'frmExitConfimU.pas' {frmExitConfirm} ,
  frmSMTPDetailsU in 'frmSMTPDetailsU.pas' {frmSMTPDetails} ,
  dlgProgressU in 'dlgProgressU.pas' {dlgProgress} ,
  frmBackupProfileWizardU
    in 'frmBackupProfileWizardU.pas' {frmBackupProfileWizard} ,
  SystemApplicationDetailsU in 'SystemApplicationDetailsU.pas',
  PluginsU in 'PluginsU.pas',
  ProgramSettingsU in 'ProgramSettingsU.pas',
  AutoUpdateU in 'AutoUpdateU.pas',
  CommonU in '..\..\common\CommonU.pas',
  FileVersionInformationU in '..\..\common\FileVersionInformationU.pas',
  ProcessTimerU in '..\..\common\ProcessTimerU.pas',
  SystemDetailsU in '..\..\common\SystemDetailsU.pas';

{$R *.res}

var
  FWinhandle: HWND;

procedure DisableProcessWindowsGhosting;
var
  DisableProcessWindowsGhostingProc: procedure;
begin
  DisableProcessWindowsGhostingProc :=
    GetProcAddress(GetModuleHandle('user32.dll'),
    'DisableProcessWindowsGhosting');
  if Assigned(DisableProcessWindowsGhostingProc) then
    DisableProcessWindowsGhostingProc;
end;

begin

  // Warning if application is running Debug build and not from within Delphi
{$IFDEF DEBUG}
  if not IsDelphiRunning then
  begin
    MessageDlg('This is a debug build, do not distribute.', mtInformation,
      [mbOK], 0);
  end;
{$ENDIF}
  // Set locale settings, to try and stop date issue in Windows 7
  SetThreadLocale(LOCALE_USER_DEFAULT);
  GetFormatSettings;

  { Attempt to create a named mutex }
  CreateMutex(nil, False, 'Backup and Shutdown');
  { if it failed then there is another instance }
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    FWinhandle := FindWindow(nil, 'Backup and Shutdown');
    SendMessage(FWinhandle, WM_APPMESSAGES, AM_INSTANCESHOW, 0);
    Halt(0);
  end;

//  if not IsSystemX64 then
//  begin
//    if not FileExists(GetApplicationDir + '7zxa.dll') then
//    begin
//      MessageDlg('7zxa.dll is missing, please re-install application.', mtError,
//        [mbOK], 0);
//      Halt(0);
//    end;
//  end;

//  if not FileExists(GetApplicationDir + '7za.dll') then
//  begin
//    MessageDlg('7za.dll is missing, please re-install application.', mtError,
//      [mbOK], 0);
//    Halt(0);
//  end;
//  if not FileExists(GetApplicationDir + 'DelZip190.dll') then
//  begin
//    MessageDlg('DelZip190.dll is missing, please re-install application.',
//      mtError, [mbOK], 0);
//    Halt(0);
//  end;

  Application.Initialize;
  Application.MainFormOnTaskBar := True;
  DisableProcessWindowsGhosting;
  Application.Title := 'Backup and Shutdown';
  Application.CreateForm(TfrmBandS, frmBandS);
  Application.CreateForm(TfrmActiveApplications, frmActiveApplications);
  Application.CreateForm(TfrmAddProgram, frmAddProgram);
  Application.CreateForm(TfrmBackupAlert, frmBackupAlert);
  Application.CreateForm(TfrmBackupProfiles, frmBackupProfiles);
  Application.CreateForm(TfrmBackupProgress, frmBackupProgress);
  Application.CreateForm(TfrmBandS, frmBandS);
  Application.CreateForm(TfrmCustomBackup, frmCustomBackup);
  Application.CreateForm(TfrmEmailDetails, frmEmailDetails);
  Application.CreateForm(TfrmFailedBackup, frmFailedBackup);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmExitConfirm, frmExitConfirm);
  Application.CreateForm(TfrmSMTPDetails, frmSMTPDetails);
  Application.CreateForm(TfrmBackupProfileWizard, frmBackupProfileWizard);
  Application.CreateForm(TfrmPassword, frmPassword);
  Application.Run;

end.

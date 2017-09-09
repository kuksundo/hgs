{ -----------------------------------------------------------------------------
  Unit Name: frmBandSU
  Author: Tristan Marlow
  Purpose: Backup and Shutdown main form.

  ----------------------------------------------------------------------------
  License
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU Library General Public License as
  published by the Free Software Foundation; either version 2 of
  the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Library General Public License for more details.
  ----------------------------------------------------------------------------

  History: 04/05/2007 - First Release.

  ----------------------------------------------------------------------------- }

unit frmBandSU;

interface

uses
  CommonU, BackupProfileU, LogU, ExitWindowsU, ProgramSettingsU, AutoUpdateU,
  FileVersionInformationU,
  frmAutoUpdateU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  JvTrayIcon, CheckLst, ImgList,
  JvCtrls, Menus, JvSystemPopup, JvBaseDlg, JvExStdCtrls, JvButton,
  ActnList, JvComponentBase, AppEvnts, System.Actions,
  System.UITypes;

const
  APPLICATION_ATB_ID = 'BANDS';
  APPLICATION_RELEASE_NOTES = 'Backup and Shutdown - Release Notes.rtf';
  APPLICATION_SUPPORT_INFORMATION = 'Backup and Shutdown - Support Details.rtf';
  APPLICATION_LICENSE_INFORMATION = 'Backup and Shutdown - License.rtf';
  APPLICATION_REGISTRY_STORAGE = '\Software\Little Earth Solutions\BandS';
  APPLICATION_INI_STORAGE = 'Profiles\';
  APPLICATION_SETTINGS = 'settings.ini';
  APPLICATION_SETTINGS_DEFAULT = 'defaults.ini';

  // Windows Message Definitions
  WM_APPMESSAGES = WM_USER + 1;
  AM_INSTANCESHOW = 1;
  AM_INSTANCEHIDE = 2;
  AM_TERMINATE = 3;
  AM_OPTIONS = 4;

type
  TfrmBandS = class(TForm)
    pnlMain: TPanel;
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    bntOptions: TJvImgBtn;
    Panel1: TPanel;
    lblShutdown: TLabel;
    Bevel1: TBevel;
    Image1: TImage;
    ComboBoxSelectBackup: TComboBox;
    pnlTop: TPanel;
    imgLogo: TImage;
    TrayIcon: TJvTrayIcon;
    ImageListCommon: TImageList;
    PopupMenuTrayIcon: TPopupMenu;
    mnuExit: TMenuItem;
    N1: TMenuItem;
    mnuOptions: TMenuItem;
    N2: TMenuItem;
    mnuOpen: TMenuItem;
    mnuBackup: TMenuItem;
    mnuAbout: TMenuItem;
    ImageListTrayIcon: TImageList;
    ActionListMain: TActionList;
    ActionOptions: TAction;
    ActionHide: TAction;
    ActionExit: TAction;
    ActionAbout: TAction;
    ActionShow: TAction;
    ActionCustomBackup: TAction;
    About1: TMenuItem;
    ActionOk: TAction;
    ActionCheckBackupAlerts: TAction;
    TimerCheckAlerts: TTimer;
    ApplicationEvents: TApplicationEvents;
    procedure imgLogoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure btnCancelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QuickBackupClick(Sender: TObject);
    procedure PopupMenuTrayIconPopup(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ActionOptionsExecute(Sender: TObject);
    procedure ActionHideExecute(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure ActionAboutExecute(Sender: TObject);
    procedure ActionShowExecute(Sender: TObject);
    procedure ActionCustomBackupExecute(Sender: TObject);
    procedure ActionOkExecute(Sender: TObject);
    procedure ActionOptionsUpdate(Sender: TObject);
    procedure ActionExitUpdate(Sender: TObject);
    procedure ActionCustomBackupUpdate(Sender: TObject);
    procedure ActionOkUpdate(Sender: TObject);
    procedure ActionCheckBackupAlertsExecute(Sender: TObject);
    procedure TimerCheckAlertsTimer(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure TrayIconBalloonClick(Sender: TObject);
    function ApplicationEventsHelp(Command: Word; Data: NativeInt;
      var CallHelp: boolean): boolean;
  private
    FApplicationCanClose: boolean;
    FApplicationActive: boolean;
    FProgramSettings: TProgramSettings;
    FLog: TLog;
    FExitWindows: TExitWindows;
    FLastAlertCheck: TDateTime;
    FfrmAutoUpdate: TfrmAutoUpdate;
    FBackupProfileManager: TBackupProfileManager;
    // function HookEndSession(var Message: TMessage): boolean;
    procedure InternalOnBackupProgress(ASender: TObject; AMessage: string;
      AProgress: integer);
    procedure InternalOnProfileProgress(ASender: TObject; AMessage: string;
      AProgress: integer);
    procedure InternalOnTotalProgress(ASender: TObject; AMessage: string;
      AProgress: integer);
    procedure InternalOnRemainingTime(ASender: TObject;
      ATotalAmount, ACurrentAmount: integer;
      AElapsedTime, AEstimatedTime: TDateTime);
    procedure InternalOnCancelConfirm(ASender: TObject; var ACancel: boolean);
    procedure InternalOnCancelQueueRequest(ASender: TObject;
      var ACancelAll: boolean);
    procedure InternalOnCloseActiveApplications(ASender: TObject;
      AActiveApplications: TStrings; ACloseGraceFully: boolean;
      var AContinue: boolean);
    procedure InternalOnBackupAlerts(ASender: TObject; ACount: integer);
    procedure InternalOnBackupAlertsBallonClick(ASender: TObject);
    procedure InternalOnBackupHide(ASender: TObject);
    procedure InternalOnBackupCancel(ASender: TObject);
    procedure InternalOnStartBackup(ASender: TObject;
      ABackupProfile: TBackupProfile);
    procedure InternalOnFinishBackup(ASender: TObject;
      ABackupProfile: TBackupProfile);
    procedure InternalOnExitRequest(ASender: TObject;
      AExitParameter: TExitParameter; var Allow: boolean);
    procedure InternalOnInsufficientPrivileges(ASender: TObject);
    procedure InternalOnNTBackupStart(ASender: TObject);
    procedure InternalOnNTBackupFinished(ASender: TObject);
    procedure InternalOnPluginsFileListStart(ASender: TObject);
    procedure InternalOnPluginsFileListFinished(ASender: TObject);
    procedure WMAppMessage(var Msg: TMessage); message WM_APPMESSAGES;
    procedure WMEndSession(var Msg: TWMEndSession); message WM_ENDSESSION;
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession);
      message WM_QUERYENDSESSION;
    procedure CheckParameters;
    procedure LoadSettings;
    procedure SaveSettings(ADefaults: boolean = False);
    procedure StartLog;
    procedure StopLog;
    procedure LoadBackupProfileManager;
    procedure SaveBackupProfileManager;
    procedure Options;
    function GetExitParameterFromomboBoxSelectBackup: TExitParameter;
    procedure Backup;
    procedure ExitWindows(AExitParameter: TExitParameter);
    procedure SetTrayIconBallonHint(AMsg: string; ABallonType: TBalloonType;
      AEvent: TNotifyEvent = nil; ADelay: integer = 5000);
    procedure SetTrayIcon(AIconIndex: integer = -1; AHint: string = '');
  public
    procedure Log(ASender: TObject; AMessage: string);
    procedure Debug(ASender: TObject; AProcedure, AMessage: string);
  end;

var
  frmBandS: TfrmBandS;

implementation

uses frmExceptionU, frmBackupProgressU, frmOptionsU, frmAboutU,
  frmPasswordU, frmBackupAlertU, DateUtils, frmCustomBackupU,
  dlgUpdateInformationU,
  frmFailedBackupU, frmExitConfimU, frmActiveApplicationsU;

{$R *.dfm}

procedure TfrmBandS.WMAppMessage(var Msg: TMessage);
begin
  case Msg.WParam of
    AM_INSTANCESHOW:
      ActionShow.Execute;
    AM_INSTANCEHIDE:
      ActionHide.Execute;
    AM_TERMINATE:
      ActionExit.Execute;
    AM_OPTIONS:
      ActionOptions.Execute;
  end;
end;

procedure TfrmBandS.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
  FApplicationCanClose := True;
  Msg.Result := integer(Self.CloseQuery);
end;

procedure TfrmBandS.WMEndSession(var Msg: TWMEndSession);
begin
  FApplicationCanClose := True;
  Self.Close;
  Msg.Result := integer(True);
end;

procedure TfrmBandS.FormCreate(Sender: TObject);
begin
  FApplicationActive := False;
  FApplicationCanClose := False;
  FLastAlertCheck := 0;
  FProgramSettings := TProgramSettings.Create(Self);
  with FProgramSettings do
  begin
    DefaultSettingsStore := ssINIFile;
    SettingsStore := ssRegistry;
    SettingsKey := APPLICATION_REGISTRY_STORAGE;
    INIFileName := GetUserAppDataDir + APPLICATION_SETTINGS;
    DefaultINIFileName := GetApplicationDir + APPLICATION_SETTINGS_DEFAULT;
  end;
  FfrmAutoUpdate := TfrmAutoUpdate.Create(Self);
  with FfrmAutoUpdate do
  begin
    OnUpdateMessage := Log;
    ProgramSettings := FProgramSettings;
  end;
  FLog := TLog.Create(Self);
  if not CheckDirectoryExists(GetUserAppDataDir, True) then
  begin
    MessageDlg(Format('Failed to locate "%s"', [GetUserAppDataDir]), mtError,
      [mbOK], 0);
  end;
  FBackupProfileManager := TBackupProfileManager.Create;
  FExitWindows := TExitWindows.Create;
  with FExitWindows do
  begin
    OnInsufficientPrivileges := InternalOnInsufficientPrivileges;
    OnExitRequest := InternalOnExitRequest;
  end;
  with ComboBoxSelectBackup.Items do
  begin
    Clear;
    Add('Backup and Shutdown');
    Add('Backup and Restart');
    Add('Backup and Log Off');
    Add('Backup and Lock Workstation');
    Add('Backup');
    Add('Shutdown');
    Add('Restart');
    Add('Log Off');
    Add('Lock Workstation');
    Add('Custom Backup');
  end;
end;

procedure TfrmBandS.FormDestroy(Sender: TObject);
begin
  with FLog do
  begin
    Active := False;
  end;
  FreeAndNil(FBackupProfileManager);
  FreeAndNil(FProgramSettings);
  FreeAndNil(FLog);
  FreeAndNil(FfrmAutoUpdate);
  FreeAndNil(FExitWindows);
end;

procedure TfrmBandS.Debug(ASender: TObject; AProcedure, AMessage: string);
begin
  if Assigned(FProgramSettings) then
  begin
    if FProgramSettings.ValueByName['Debug'] then
    begin
      Log(Self, 'Debug: (' + AProcedure + '): ' + AMessage);
    end;
  end;
end;

procedure TfrmBandS.Log(ASender: TObject; AMessage: string);
begin
  if Assigned(FLog) then
  begin
    if FLog.Active then
    begin
      FLog.Add(AMessage);
    end;
  end;
end;

procedure TfrmBandS.InternalOnBackupProgress(ASender: TObject; AMessage: string;
  AProgress: integer);
begin
  frmBackupProgress.SetBackupProgress(AProgress, AMessage);
end;

procedure TfrmBandS.InternalOnProfileProgress(ASender: TObject;
  AMessage: string; AProgress: integer);
begin
  frmBackupProgress.SetProfileProgress(AProgress, AMessage);
end;

procedure TfrmBandS.InternalOnTotalProgress(ASender: TObject; AMessage: string;
  AProgress: integer);
var
  IconIndex: integer;
begin
  frmBackupProgress.SetTotalProgress(AProgress, AMessage);
  IconIndex := 0;
  if AProgress <= 10 then
  begin
    IconIndex := 1;
  end;
  if AProgress > 10 then
  begin
    IconIndex := 2;
  end;
  if AProgress > 20 then
  begin
    IconIndex := 3;
  end;
  if AProgress > 30 then
  begin
    IconIndex := 4;
  end;
  if AProgress > 40 then
  begin
    IconIndex := 5;
  end;
  if AProgress > 50 then
  begin
    IconIndex := 6;
  end;
  if AProgress > 60 then
  begin
    IconIndex := 7;
  end;
  if AProgress > 70 then
  begin
    IconIndex := 8;
  end;
  if AProgress > 80 then
  begin
    IconIndex := 9;
  end;
  if AProgress > 90 then
  begin
    IconIndex := 10;
  end;
  SetTrayIcon(IconIndex, Application.Title + ' - Progress: ' +
    IntToStr(AProgress) + '%');
end;

procedure TfrmBandS.InternalOnRemainingTime(ASender: TObject;
  ATotalAmount, ACurrentAmount: integer;
  AElapsedTime, AEstimatedTime: TDateTime);
var
  EstimatedTime: string;
  ElapsedTime: string;
begin
  if AEstimatedTime <> 0 then
  begin
    EstimatedTime := 'Estimated: ';
    if HourOf(AEstimatedTime) > 0 then
    begin
      if HourOf(AEstimatedTime) = 1 then
      begin
        EstimatedTime := EstimatedTime + FormatDateTime('h "hour "',
          AEstimatedTime);
      end
      else
      begin
        EstimatedTime := EstimatedTime + FormatDateTime('h "hours "',
          AEstimatedTime);
      end;
    end;
    if MinuteOf(AEstimatedTime) > 0 then
    begin
      if MinuteOf(AEstimatedTime) = 1 then
      begin
        EstimatedTime := EstimatedTime + FormatDateTime('n "minute "',
          AEstimatedTime);
      end
      else
      begin
        EstimatedTime := EstimatedTime + FormatDateTime('n "minutes "',
          AEstimatedTime);
      end;
    end;
    if (MinuteOf(AEstimatedTime) = 0) and (HourOf(AEstimatedTime) = 0) then
    begin
      EstimatedTime := 'Less than a minute...';
      // EstimatedTime := EstimatedTime + FormatDateTime('s "seconds "',AEstimatedTime);
    end;
  end
  else
  begin
    EstimatedTime := 'Calculating...';
  end;
  ElapsedTime := 'Elapsed: ';
  if HourOf(AElapsedTime) > 0 then
  begin
    ElapsedTime := ElapsedTime + FormatDateTime('h "hour(s) "', AElapsedTime);
  end;
  if MinuteOf(AElapsedTime) > 0 then
  begin
    ElapsedTime := ElapsedTime + FormatDateTime('n "minute(s) "', AElapsedTime);
  end;
  ElapsedTime := ElapsedTime + FormatDateTime('s "seconds "', AElapsedTime);
  frmBackupProgress.SetTimeRemaining(EstimatedTime);
  frmBackupProgress.SetTimeElapsed(ElapsedTime);
end;

procedure TfrmBandS.InternalOnCancelQueueRequest(ASender: TObject;
  var ACancelAll: boolean);
begin
  SetTrayIcon(11);
  ACancelAll := MessageDlg
    ('You have cancelled the current backup; do you wish to continue with remaining profiles?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo;
end;

procedure TfrmBandS.InternalOnCancelConfirm(ASender: TObject;
  var ACancel: boolean);
begin
  ACancel := MessageDlg('Are you sure you want to cancel the current backup?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TfrmBandS.InternalOnCloseActiveApplications(ASender: TObject;
  AActiveApplications: TStrings; ACloseGraceFully: boolean;
  var AContinue: boolean);
begin
  AContinue := frmActiveApplications.Execute(AActiveApplications,
    ACloseGraceFully);
end;

procedure TfrmBandS.StartLog;
var
  LogFolder: string;
begin
  Log(Self, 'Starting log...');
  with FLog do
  begin
    LogFolder := IncludeTrailingPathDelimiter(GetUserAppDataDir + 'Logs');
    if CheckDirectoryExists(LogFolder, True) then
    begin
      FileName := LogFolder + FormatDateTime('ddmmyyhhnnss', Now) + '.log';
      Active := True;
    end
    else
    begin
      raise Exception.CreateFmt('Failed to create log file folder "%s"',
        [LogFolder]);
    end;
  end;
end;

procedure TfrmBandS.StopLog;
begin
  Log(Self, 'Stopping log...');
  with FLog do
  begin
    Active := False;
    if FileExists(FileName) then
      DeleteFile(FileName);
  end;
end;

procedure TfrmBandS.LoadBackupProfileManager;
begin
  Log(Self, 'Loading Backup Profile Manager...');
  with FBackupProfileManager do
  begin
    StorageType := TBackupProfileStorageType
      (integer(FProgramSettings.ValueByName['StorageType']));
    RootKey := HKEY_CURRENT_USER;
    RegistryKey := APPLICATION_REGISTRY_STORAGE;
    RootFolder := IncludeTrailingPathDelimiter(GetApplicationDir +
      APPLICATION_INI_STORAGE);
    LogFolder := IncludeTrailingPathDelimiter(GetUserAppDataDir + 'Logs');
    DLLFolder := GetApplicationDir;
    OnDebug := Self.Debug;
    OnLog := Self.Log;
    OnBackupProgress := InternalOnBackupProgress;
    OnProfileProgress := InternalOnProfileProgress;
    OnTotalProgress := InternalOnTotalProgress;
    OnRemainingTime := InternalOnRemainingTime;
    OnCancelConfirm := InternalOnCancelConfirm;
    OnCancelQueueRequest := InternalOnCancelQueueRequest;
    OnBackupAlerts := InternalOnBackupAlerts;
    OnStartBackup := InternalOnStartBackup;
    OnFinishBackup := InternalOnFinishBackup;
    OnCloseActiveApplications := InternalOnCloseActiveApplications;
    OnNTBackupStart := InternalOnNTBackupStart;
    OnNTBackupFinished := InternalOnNTBackupFinished;
    OnPluginsFileListStart := InternalOnPluginsFileListStart;
    OnPluginsFileListFinished := InternalOnPluginsFileListFinished;
    LoadProfiles;
  end;
end;

procedure TfrmBandS.SaveBackupProfileManager;
begin
  Log(Self, 'Saving Backup Profile Manager...');
  with FBackupProfileManager do
  begin
    // Storage Type has changed, do one last save as old Storage Type.
    if StorageType <> TBackupProfileStorageType
      (integer(FProgramSettings.ValueByName['StorageType'])) then
    begin
      SaveProfiles;
    end;
    StorageType := TBackupProfileStorageType
      (integer(FProgramSettings.ValueByName['StorageType']));
    RootKey := HKEY_CURRENT_USER;
    RegistryKey := APPLICATION_REGISTRY_STORAGE;
    RootFolder := IncludeTrailingPathDelimiter(GetApplicationDir +
      APPLICATION_INI_STORAGE);
    SaveProfiles;
  end;
end;

procedure TfrmBandS.CheckParameters;
var
  Idx: integer;
begin
  for Idx := 1 to ParamCount do
  begin
    if UpperCase(ParamStr(Idx)) = '/HIDE' then
    begin
      ActionHide.Execute;
    end;
    if UpperCase(ParamStr(Idx)) = '/ABOUT' then
      ActionAbout.Execute;
    if UpperCase(ParamStr(Idx)) = '/OPTIONS' then
      ActionOptions.Execute;
    if UpperCase(ParamStr(Idx)) = '/BACKUP' then
      ActionCustomBackup.Execute;
  end;
end;

procedure TfrmBandS.LoadSettings;
var
  VersionInfo: TApplicationVersionInfo;
  dlgUpdateInformation: TdlgUpdateInformation;
begin
  VersionInfo := TApplicationVersionInfo.Create;
  try
    with FProgramSettings do
    begin
      Clear;
      CreateAutoUpdateProgramSettings(FProgramSettings);
      Add('Password', vtPassword, '');
      Add('Debug', vtBoolean, False);
      Add('RememberLastSelection', vtBoolean, True);
      Add('LastSelectionID', vtInteger, 0);
      Add('CheckLastBackup', vtBoolean, True);
      Add('CheckActivePrograms', vtBoolean, True);
      Add('StorageType', vtInteger, integer(stRegistry));
      Add('Version', vtString, '0.0.0.0');
      Add('HTTPProxy', vtBoolean, False);
      Add('HTTPHost', vtString, '');
      Add('HTTPPort', vtInteger, 8080);
      Add('HTTPAuthentication', vtBoolean, False);
      Add('HTTPUsername', vtString, '');
      Add('HTTPPassword', vtPassword, '');
      Add('SOCKSProxy', vtBoolean, False);
      Add('SOCKSHost', vtString, '');
      Add('SOCKSPort', vtInteger, 1080);
      Add('SOCKSAuthentication', vtBoolean, False);
      Add('SOCKSUsername', vtString, '');
      Add('SOCKSPassword', vtPassword, '');
      Add('SOCKSVersion', vtInteger, 0);
      Add('SMTPHost', vtString, '');
      Add('SMTPPort', vtInteger, 25);
      Add('SMTPAuthentication', vtBoolean, False);
      Add('SMTPSecure', vtBoolean, False);
      Add('SMTPUsername', vtString, '');
      Add('SMTPPassword', vtPassword, '');
      LoadDefaults;
      LoadSettings;
      try
        if ValueByName['Version'] <> VersionInfo.FileVersion then
        begin
          ValueByName['Version'] := VersionInfo.FileVersion;
          dlgUpdateInformation := TdlgUpdateInformation.Create(Self);
          try
            dlgUpdateInformation.Execute(GetApplicationDir +
              APPLICATION_RELEASE_NOTES, GetApplicationDir +
              APPLICATION_LICENSE_INFORMATION, GetApplicationDir +
              APPLICATION_SUPPORT_INFORMATION);
          finally
            FreeAndNil(dlgUpdateInformation);
          end;
        end;
      except
        MessageDlg('Failed to check application version details.', mtError,
          [mbOK], 0);
      end;
      // Apply Settings
      with FBackupProfileManager do
      begin
        DebugBackup := ValueByName['Debug'];
        SMTPSettings.SMTPHostname := ValueByName['SMTPHost'];
        SMTPSettings.SMTPPort := ValueByName['SMTPPort'];
        SMTPSettings.SMTPAuthentication := ValueByName['SMTPAuthentication'];
        SMTPSettings.SMTPSecure := ValueByName['SMTPSecure'];
        SMTPSettings.Username := ValueByName['SMTPUsername'];
        SMTPSettings.Password := ValueByName['SMTPPassword'];
      end;
      ComboBoxSelectBackup.ItemIndex := FProgramSettings.ValueByName
        ['LastSelectionID'];
      if ComboBoxSelectBackup.ItemIndex = -1 then
        ComboBoxSelectBackup.ItemIndex := 0;
      SaveSettings;
    end;
  finally
    FreeAndNil(VersionInfo);
  end;
end;

procedure TfrmBandS.SaveSettings(ADefaults: boolean = False);
begin
  with FProgramSettings do
  begin
    SaveSettings;
    if ADefaults then
      SaveDefaults;
  end;
  // Activate any changes to application
  LoadSettings;
end;

procedure TfrmBandS.Options;
var
  PasswordValid: boolean;
begin
  if not frmOptions.Visible then
  begin
    TrayIcon.ShowApplication;
    if Trim(FProgramSettings.ValueByName['Password']) = '' then
    begin
      PasswordValid := True;
    end
    else
    begin
      if not frmPassword.Visible then
      begin
        PasswordValid := frmPassword.Execute('Please enter your password',
          FProgramSettings.ValueByName['Password'], 3);
      end
      else
      begin
        PasswordValid := False;
        frmPassword.BringToFront;
      end;
    end;
    if PasswordValid then
    begin
      try
        FfrmAutoUpdate.AutoUpdateEnabled := False;
        if frmOptions.Execute(FProgramSettings, FBackupProfileManager, FLog) = mrOk
        then
        begin
          SaveSettings;
        end;
        FfrmAutoUpdate.AutoUpdateEnabled := True;
      finally
      end;
    end;
  end
  else
  begin
    Application.BringToFront;
  end;
end;

procedure TfrmBandS.imgLogoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
const
  SC_DRAGMOVE = $F012;
begin
  if Button = mbleft then
  begin
    ReleaseCapture;
    Self.Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmBandS.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := FApplicationCanClose;
end;

procedure TfrmBandS.btnCancelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if (Shift = [ssShift]) then
  begin
    ActionExit.Execute;
  end;
end;

procedure TfrmBandS.FormActivate(Sender: TObject);
begin
  if not FApplicationActive then
  begin
    FApplicationActive := True;
    LoadSettings;
    StartLog;
    LoadBackupProfileManager;
    TrayIcon.Active := True;
    SetTrayIcon(0, Application.Title);
    FfrmAutoUpdate.AutoUpdateEnabled := True;
    TimerCheckAlerts.Enabled := True;
    TimerCheckAlertsTimer(Sender);
    CheckParameters;
  end;
end;

procedure TfrmBandS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerCheckAlerts.Enabled := False;
  FfrmAutoUpdate.AutoUpdateEnabled := False;
  SaveSettings;
  SaveBackupProfileManager;
  StopLog;
  TrayIcon.Active := False;
end;

procedure TfrmBandS.QuickBackupClick(Sender: TObject);
var
  Str: string;
begin
  with Sender as TMenuItem do
  begin
    Str := Caption;
    while Pos('&', Str) > 0 do
    begin
      System.Delete(Str, Pos('&', Str), 1);
    end;
  end;
  if not FBackupProfileManager.IsBackupActive then
  begin
    if MessageDlg(Format('Are you sure you want to launch backup "%s"?', [Str]),
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      ActionShow.Execute;
      FBackupProfileManager.ClearQueue;
      FBackupProfileManager.QueueAdd(Str);
      Backup;
      ActionHide.Execute;
    end;
  end
  else
  begin
    MessageDlg('Backup already active.', mtError, [mbOK], 0);
  end;
end;

procedure TfrmBandS.PopupMenuTrayIconPopup(Sender: TObject);
var
  MenuItem: TMenuItem;
  BackupProfile: TBackupProfile;
  Idx: integer;
begin
  mnuOpen.Enabled := True;
  with mnuBackup do
  begin
    Clear;
    MenuItem := TMenuItem.Create(mnuBackup);
    MenuItem.Action := ActionCustomBackup;
    Add(MenuItem);
    for Idx := 0 to Pred(FBackupProfileManager.ProfileCount) do
    begin
      BackupProfile := FBackupProfileManager.Profile[Idx];
      MenuItem := TMenuItem.Create(mnuBackup);
      MenuItem.Caption := BackupProfile.ProfileName;
      MenuItem.OnClick := QuickBackupClick;
      MenuItem.ImageIndex := mnuBackup.ImageIndex;
      MenuItem.Enabled := not FBackupProfileManager.IsBackupActive;
      Add(MenuItem);
    end;
  end;
end;

procedure TfrmBandS.SetTrayIcon(AIconIndex: integer = -1; AHint: string = '');
begin
  if AIconIndex <> -1 then
    TrayIcon.IconIndex := AIconIndex;
  if AHint <> '' then
    TrayIcon.Hint := AHint;
end;

procedure TfrmBandS.SetTrayIconBallonHint(AMsg: string;
  ABallonType: TBalloonType; AEvent: TNotifyEvent = nil;
  ADelay: integer = 5000);
begin
  TrayIcon.BalloonHint('Backup and Shutdown', AMsg, ABallonType, ADelay);
  TrayIcon.OnBalloonClick := AEvent;
end;

procedure TfrmBandS.TimerCheckAlertsTimer(Sender: TObject);
begin
  if Assigned(FBackupProfileManager) then
  begin
    if (not FBackupProfileManager.IsBackupActive) and
      (HoursBetween(Now, FLastAlertCheck) > 12) then
    begin
      FBackupProfileManager.CheckBackupAlerts;
      FLastAlertCheck := Now;
    end;
  end;
end;

procedure TfrmBandS.TrayIconBalloonClick(Sender: TObject);
begin
  ActionShow.Execute;
end;

procedure TfrmBandS.TrayIconDblClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  ActionShow.Execute;
end;

procedure TfrmBandS.ActionOkExecute(Sender: TObject);
begin
  { 0 Add('Backup and Shutdown');
    1 Add('Backup and Restart');
    2 Add('Backup and Log Off');
    3 Add('Backup and Lock Workstation');
    4 Add('Backup');
    5 Add('Shutdown');
    6 Add('Restart');
    7 Add('Log Off');
    8 Add('Lock Workstation');
    9 Add('Custom Backup'); }
  case ComboBoxSelectBackup.ItemIndex of
    0, 1, 2, 3, 4:
      begin
        FBackupProfileManager.ClearQueue;
        FBackupProfileManager.QueueAllEnabled;
        Backup;
        ExitWindows(GetExitParameterFromomboBoxSelectBackup);
      end;
    5, 6, 7, 8:
      begin
        ExitWindows(GetExitParameterFromomboBoxSelectBackup);
      end;
    9:
      begin
        ActionCustomBackup.Execute;
      end;
  end;
  FProgramSettings.ValueByName['LastSelectionID'] :=
    ComboBoxSelectBackup.ItemIndex;
  ActionHide.Execute;
end;

procedure TfrmBandS.ActionOkUpdate(Sender: TObject);
var
  AllowExecute: boolean;
begin
  AllowExecute := True;
  if AllowExecute then
    AllowExecute := not FBackupProfileManager.IsBackupActive;
  ActionOk.Enabled := AllowExecute;
end;

procedure TfrmBandS.ActionOptionsExecute(Sender: TObject);
begin
  Options;
end;

procedure TfrmBandS.ActionOptionsUpdate(Sender: TObject);
var
  AllowExecute: boolean;
begin
  AllowExecute := True;
  if AllowExecute then
    AllowExecute := not FBackupProfileManager.IsBackupActive;
  ActionOptions.Enabled := AllowExecute;
end;

procedure TfrmBandS.ActionHideExecute(Sender: TObject);
begin
  // SetTrayIconBallonHint('Backup and Shutdown is still running in the system tray, you can restore it by clicking this icon.',btInfo);
  TrayIcon.HideApplication;
end;

function TfrmBandS.GetExitParameterFromomboBoxSelectBackup: TExitParameter;
begin
  { 0 Add('Backup and Shutdown');
    1 Add('Backup and Restart');
    2 Add('Backup and Log Off');
    3 Add('Backup and Lock Workstation');
    4 Add('Backup');
    5 Add('Shutdown');
    6 Add('Restart');
    7 Add('Log Off');
    8 Add('Lock Workstation');
    9 Add('Custom Backup'); }
  case ComboBoxSelectBackup.ItemIndex of
    0, 5:
      Result := xpShutdown;
    1, 6:
      Result := xpReboot;
    2, 7:
      Result := xpLogoff;
    3, 8:
      Result := xpLockWorkstation;
  else
    Result := xpNone;
  end;
end;

procedure TfrmBandS.InternalOnBackupHide(ASender: TObject);
begin
  frmBackupProgress.Hide;
end;

procedure TfrmBandS.InternalOnBackupAlerts(ASender: TObject; ACount: integer);
begin
  if FProgramSettings.ValueByName['CheckLastBackup'] then
  begin
    SetTrayIcon(12, Application.Title + ' - Backup Alerts: ' +
      IntToStr(ACount));
    SetTrayIconBallonHint
      (Format('You have %d Backup Alerts pending, click here for more details.',
      [ACount]), btWarning, InternalOnBackupAlertsBallonClick, 30000);
  end;
end;

procedure TfrmBandS.InternalOnBackupAlertsBallonClick(ASender: TObject);
begin
  ActionShow.Execute;
  if Self.Active then
  begin
    if frmBackupAlert.Execute(FBackupProfileManager) then
    begin
      Backup;
    end;
  end
  else
  begin
    MessageDlg
      ('A dialog box is open in Backup and Shutdown. Close the dialog box and try again.',
      mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmBandS.InternalOnBackupCancel(ASender: TObject);
begin
  FBackupProfileManager.CancelBackup;
end;

procedure TfrmBandS.InternalOnStartBackup(ASender: TObject;
  ABackupProfile: TBackupProfile);
begin
  frmBackupProgress.SetBackupProfile(Format('Backup: %s',
    [ABackupProfile.ProfileName]));
end;

procedure TfrmBandS.InternalOnFinishBackup(ASender: TObject;
  ABackupProfile: TBackupProfile);
begin
  frmBackupProgress.SetBackupProfile(Format('Backup Complete: %s',
    [ABackupProfile.ProfileName]));
end;

procedure TfrmBandS.InternalOnExitRequest(ASender: TObject;
  AExitParameter: TExitParameter; var Allow: boolean);
begin
  Allow := frmExitConfirm.Execute(AExitParameter);
end;

procedure TfrmBandS.InternalOnInsufficientPrivileges(ASender: TObject);
begin
  MessageDlg('You do not have sufficient privileges to exit windows.', mtError,
    [mbOK], 0);
end;

procedure TfrmBandS.InternalOnNTBackupStart(ASender: TObject);
begin
  frmBackupProgress.Hide;
end;

procedure TfrmBandS.InternalOnNTBackupFinished(ASender: TObject);
begin
  frmBackupProgress.Show;
end;

procedure TfrmBandS.InternalOnPluginsFileListStart(ASender: TObject);
begin
  frmBackupProgress.Hide;
  Application.ProcessMessages;
end;

procedure TfrmBandS.InternalOnPluginsFileListFinished(ASender: TObject);
begin
  frmBackupProgress.Show;
  Application.ProcessMessages;
end;

procedure TfrmBandS.Backup;
begin
  try
    SetTrayIcon(1);
    SetTrayIconBallonHint('Backup in progress...', btInfo);
    Self.Hide;
    with frmBackupProgress do
    begin
      OnCancel := InternalOnBackupCancel;
      OnHide := InternalOnBackupHide;
      Show;
    end;
    if not FBackupProfileManager.Backup then
    begin
      SetTrayIconBallonHint('Backup Failed.', btError);
      frmFailedBackup.Execute(FBackupProfileManager);
    end
    else
    begin
      SetTrayIconBallonHint('Backup Complete.', btInfo);
    end;
  finally
    SetTrayIcon(0, Application.Title);
    frmBackupProgress.Hide;
    Self.Show;
  end;
end;

procedure TfrmBandS.ExitWindows(AExitParameter: TExitParameter);
begin
  if not FExitWindows.ExitWindows(AExitParameter) then
  begin
    SetTrayIconBallonHint
      ('Unable to exit windows, you may not have permission.', btError);
  end;
end;

procedure TfrmBandS.ActionExitExecute(Sender: TObject);
begin
  if FBackupProfileManager.IsBackupActive then
  begin
    ActionShow.Execute;
    FBackupProfileManager.CancelBackup;
  end
  else
  begin
    FApplicationCanClose := True;
    Self.Close;
  end;
end;

procedure TfrmBandS.ActionExitUpdate(Sender: TObject);
var
  AllowExecute: boolean;
begin
  AllowExecute := True;
  ActionExit.Enabled := AllowExecute;
end;

procedure TfrmBandS.ActionAboutExecute(Sender: TObject);
begin
  frmAbout.Execute(GetApplicationDir + APPLICATION_RELEASE_NOTES,
    GetApplicationDir + APPLICATION_LICENSE_INFORMATION,
    GetApplicationDir + APPLICATION_SUPPORT_INFORMATION);
end;

procedure TfrmBandS.ActionShowExecute(Sender: TObject);
begin
  if FBackupProfileManager.IsBackupActive then
  begin
    frmBackupProgress.Show;
    frmBackupProgress.BringToFront;
  end
  else
  begin
    TrayIcon.ShowApplication;
    if Self.Active then
      ComboBoxSelectBackup.SetFocus;
  end;
  Application.BringToFront;
end;

procedure TfrmBandS.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  with TfrmException.Create(Self) do
  begin
    Execute(Self, E);
  end;
end;

function TfrmBandS.ApplicationEventsHelp(Command: Word; Data: NativeInt;
  var CallHelp: boolean): boolean;
begin
  CallHelp := False;
  Result := True;
end;

procedure TfrmBandS.ActionCheckBackupAlertsExecute(Sender: TObject);
begin
  FBackupProfileManager.QueueOverdue;
  if FBackupProfileManager.Queue.Count > 0 then
  begin
    if frmBackupAlert.Execute(FBackupProfileManager) then
    begin
      Backup;
    end;
  end;
end;

procedure TfrmBandS.ActionCustomBackupExecute(Sender: TObject);
var
  ExitParameter: TExitParameter;
begin
  ExitParameter := xpNone;
  if frmCustomBackup.Execute(FBackupProfileManager, ExitParameter) then
  begin
    Backup;
    ExitWindows(ExitParameter);
  end;
end;

procedure TfrmBandS.ActionCustomBackupUpdate(Sender: TObject);
var
  AllowExecute: boolean;
begin
  AllowExecute := True;
  if AllowExecute then
    AllowExecute := not FBackupProfileManager.IsBackupActive;
  ActionCustomBackup.Enabled := AllowExecute;
end;

end.

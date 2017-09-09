{ -----------------------------------------------------------------------------
  Unit Name: frmOptionsU
  Author: Tristan Marlow
  Purpose: Backup and Shutdown Options.

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
unit frmOptionsU;

interface

uses
  CommonU, BackupProfileU, LogU, ProgramSettingsU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CheckLst, ComCtrls, ToolWin, StdCtrls, Buttons, ExtCtrls,
  JvBaseDlg, ImgList, JvExComCtrls, JvListView, ActnList,
  Spin, System.Actions, System.UITypes;

type
  TfrmOptions = class(TForm)
    pnlBottom: TPanel;
    PageControlMain: TPageControl;
    tabGeneral: TTabSheet;
    tabBackupProfiles: TTabSheet;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBoxBackupProfile: TGroupBox;
    GroupBoxGeneral: TGroupBox;
    cbAutoRun: TCheckBox;
    editPassword: TEdit;
    GroupBoxWarnings: TGroupBox;
    cbLastBackupWarning: TCheckBox;
    cbRememberLastSelection: TCheckBox;
    ComboBoxLastSelection: TComboBox;
    cbCheckActivePrograms: TCheckBox;
    ImageListBackupProfiles: TImageList;
    tabConnectivity: TTabSheet;
    GroupBoxAutoUpdate: TGroupBox;
    PageControlProxy: TPageControl;
    tabHTTPProxy: TTabSheet;
    tabSOCKSProxy: TTabSheet;
    Bevel1: TBevel;
    cbHTTPProxy: TCheckBox;
    cbSocksProxy: TCheckBox;
    GroupBoxHTTPProxy: TGroupBox;
    GroupBoxSocksProxy: TGroupBox;
    Host: TLabel;
    editHTTPHost: TEdit;
    editHTTPPort: TEdit;
    Label2: TLabel;
    cbBasicHTTPAuthentication: TCheckBox;
    editHTTPUsername: TEdit;
    editHTTPPassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Bevel2: TBevel;
    Label5: TLabel;
    editSocksHost: TEdit;
    editSocksPort: TEdit;
    Label6: TLabel;
    cbSocksAuthentication: TCheckBox;
    Label7: TLabel;
    editSocksUsername: TEdit;
    Label8: TLabel;
    editSocksPassword: TEdit;
    Label9: TLabel;
    comboSocksVersion: TComboBox;
    Bevel3: TBevel;
    Label10: TLabel;
    tabLog: TTabSheet;
    GroupBox1: TGroupBox;
    ActionListOptions: TActionList;
    pnlBackupProfiles: TPanel;
    ToolBar1: TToolBar;
    btnAddProfile: TToolButton;
    btnRemoveProfile: TToolButton;
    btnEditProfile: TToolButton;
    ToolButton5: TToolButton;
    btnRemoveAllProfiles: TToolButton;
    tabAdvanced: TTabSheet;
    pnlLog: TPanel;
    ToolBarLog: TToolBar;
    ToolButton1: TToolButton;
    memoLog: TMemo;
    GroupBox2: TGroupBox;
    pnlAdvanced: TPanel;
    Label1: TLabel;
    ListViewBackupProfiles: TListView;
    ActionRefreshLog: TAction;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ActionOpenLogInExplorer: TAction;
    PageControlAdvanced: TPageControl;
    tabAdvancedGeneral: TTabSheet;
    cbDebug: TCheckBox;
    TabSheetAdvancedAutoupdate: TTabSheet;
    editAutoUpdateURL: TEdit;
    lblAutoupdateURLWarning: TLabel;
    tabSMTP: TTabSheet;
    GroupBox3: TGroupBox;
    editSMTPServer: TLabeledEdit;
    editSMTPPort: TSpinEdit;
    Label11: TLabel;
    cbSMTPAuthentication: TCheckBox;
    editSMTPUsername: TLabeledEdit;
    editSMTPPassword: TLabeledEdit;
    cbAutoUpdateAutomatically: TCheckBox;
    editAutoUpdateInterval: TSpinEdit;
    Label12: TLabel;
    editAutoUpdateApplication: TLabeledEdit;
    cbAutoupdateEnabled: TCheckBox;
    cbSMTPSecure: TCheckBox;
    ToolButton4: TToolButton;
    ActionBackupProfileWizard: TAction;
    ToolButton6: TToolButton;
    procedure FormShow(Sender: TObject);
    procedure btnAddProfileClick(Sender: TObject);
    procedure btnEditProfileClick(Sender: TObject);
    procedure btnRemoveProfileClick(Sender: TObject);
    procedure btnRemoveAllProfilesClick(Sender: TObject);
    procedure CheckListBoxProfilesClickCheck(Sender: TObject);
    procedure ActionRefreshLogExecute(Sender: TObject);
    procedure PageControlMainChange(Sender: TObject);
    procedure ActionOpenLogInExplorerExecute(Sender: TObject);
    procedure ListViewBackupProfilesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewBackupProfilesMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure ActionBackupProfileWizardExecute(Sender: TObject);
    procedure PageControlProxyChange(Sender: TObject);
  private
    FLog: TLog;
    FProgramSettings: TProgramSettings;
    FBackupProfileManager: TBackupProfileManager;
    procedure UpdateProfileList;
    procedure GetFormValues;
    procedure SetFormValues;
  public
    function Execute(var AProgramSettings: TProgramSettings;
      ABackupProfileManager: TBackupProfileManager; ALog: TLog): integer;
  end;

var
  frmOptions: TfrmOptions;

implementation

uses frmBackupProfilesU, frmBackupProfileWizardU;

{$R *.dfm}

procedure TfrmOptions.GetFormValues;
begin
  with FProgramSettings do
  begin
    ValueByName['Debug'] := cbDebug.Checked;
    ValueByName['Password'] := editPassword.Text;
    ValueByName['RememberLastSelection'] := cbRememberLastSelection.Checked;
    ValueByName['LastSelectionID'] := ComboBoxLastSelection.ItemIndex;
    ValueByName['CheckLastBackup'] := cbLastBackupWarning.Checked;
    ValueByName['CheckActivePrograms'] := cbCheckActivePrograms.Checked;
    // Auto Update
    ValueByName['AutomaticUpdateEnabled'] := cbAutoupdateEnabled.Checked;
    ValueByName['AutomaticUpdateAutomatic'] :=
      cbAutoUpdateAutomatically.Checked;
    ValueByName['AutomaticUpdateURL'] := editAutoUpdateURL.Text;
    ValueByName['AutomaticUpdateInterval'] := editAutoUpdateInterval.Value;
    // ValueByName['AutoUpdateApplication'] := editAutoUpdateApplication.Text;
    // Proxy
    ValueByName['HTTPProxy'] := cbHTTPProxy.Checked;
    ValueByName['HTTPHost'] := editHTTPHost.Text;
    ValueByName['HTTPPort'] := StrToIntDef(editHTTPPort.Text, 8080);
    ValueByName['HTTPAuthentication'] := cbBasicHTTPAuthentication.Checked;
    ValueByName['HTTPUserName'] := editHTTPUsername.Text;
    ValueByName['HTTPPassword'] := editHTTPPassword.Text;
    ValueByName['SOCKSProxy'] := cbSocksProxy.Checked;
    ValueByName['SOCKSHost'] := editSocksHost.Text;
    ValueByName['SOCKSPort'] := StrToIntDef(editSocksPort.Text, 1080);
    ValueByName['SOCKSVersion'] := comboSocksVersion.ItemIndex;
    ValueByName['SOCKSAuthentication'] := cbSocksAuthentication.Checked;
    ValueByName['SOCKSUserName'] := editSocksUsername.Text;
    ValueByName['SOCKSPassword'] := editSocksPassword.Text;
    // SMTP
    ValueByName['SMTPHost'] := editSMTPServer.Text;
    ValueByName['SMTPPort'] := editSMTPPort.Value;
    ValueByName['SMTPAuthentication'] := cbSMTPAuthentication.Checked;
    ValueByName['SMTPSecure'] := cbSMTPSecure.Checked;
    ValueByName['SMTPUsername'] := editSMTPUsername.Text;
    ValueByName['SMTPPassword'] := editSMTPPassword.Text;
  end;
end;

procedure TfrmOptions.SetFormValues;
begin
  with FProgramSettings do
  begin
    cbDebug.Checked := ValueByName['Debug'];
    editPassword.Text := ValueByName['Password'];
    cbRememberLastSelection.Checked := ValueByName['RememberLastSelection'];
    ComboBoxLastSelection.ItemIndex := ValueByName['LastSelectionID'];
    cbLastBackupWarning.Checked := ValueByName['CheckLastBackup'];
    // Auto Update
    cbAutoupdateEnabled.Checked := ValueByName['AutomaticUpdateEnabled'];
    cbCheckActivePrograms.Checked := ValueByName['CheckActivePrograms'];
    cbAutoUpdateAutomatically.Checked :=
      ValueByName['AutomaticUpdateAutomatic'];
    editAutoUpdateURL.Text := ValueByName['AutomaticUpdateURL'];
    editAutoUpdateInterval.Value := ValueByName['AutomaticUpdateInterval'];
    editAutoUpdateApplication.Text := ValueByName['AutomaticUpdateApplication'];
    // Proxy
    cbHTTPProxy.Checked := ValueByName['HTTPProxy'];
    editHTTPHost.Text := ValueByName['HTTPHost'];
    editHTTPPort.Text := IntToStr(ValueByName['HTTPPort']);
    cbBasicHTTPAuthentication.Checked := ValueByName['HTTPAuthentication'];
    editHTTPUsername.Text := ValueByName['HTTPUserName'];
    editHTTPPassword.Text := ValueByName['HTTPPassword'];
    cbSocksProxy.Checked := ValueByName['SOCKSProxy'];
    editSocksHost.Text := ValueByName['SOCKSHost'];
    editSocksPort.Text := IntToStr(ValueByName['SOCKSPort']);
    comboSocksVersion.ItemIndex := ValueByName['SOCKSVersion'];
    cbSocksAuthentication.Checked := ValueByName['SOCKSAuthentication'];
    editSocksUsername.Text := ValueByName['SOCKSUserName'];
    editSocksPassword.Text := ValueByName['SOCKSPassword'];
    // SMTP
    editSMTPServer.Text := ValueByName['SMTPHost'];
    editSMTPPort.Value := ValueByName['SMTPPort'];
    cbSMTPAuthentication.Checked := ValueByName['SMTPAuthentication'];
    cbSMTPSecure.Checked := ValueByName['SMTPSecure'];
    editSMTPUsername.Text := ValueByName['SMTPUsername'];
    editSMTPPassword.Text := ValueByName['SMTPPassword'];
  end;
end;

procedure TfrmOptions.UpdateProfileList;
var
  Idx: integer;
  ListItem: TListItem;
begin
  ListViewBackupProfiles.Items.Clear;
  with FBackupProfileManager do
  begin
    for Idx := 0 to Pred(ProfileCount) do
    begin
      with Profile[Idx] do
      begin
        ListItem := ListViewBackupProfiles.Items.Add;
        with ListItem do
        begin
          Caption := Profile[Idx].ProfileName;
          Checked := Profile[Idx].Enabled;
          SubItems.Add(DateTimeToStr(Profile[Idx].LastBackup));
          SubItems.Add(ExtractFileName(Profile[Idx].ZipFile));
        end;
      end;
    end;
  end;
end;

function TfrmOptions.Execute(var AProgramSettings: TProgramSettings;
  ABackupProfileManager: TBackupProfileManager; ALog: TLog): integer;
begin
  FProgramSettings := AProgramSettings;
  FBackupProfileManager := ABackupProfileManager;
  FLog := ALog;
  SetFormValues;
  UpdateProfileList;
  cbAutoRun.Checked := FProgramSettings.GetAutoRun;
  Result := Self.ShowModal;
  if Result = mrOk then
  begin
    GetFormValues;
    FProgramSettings.SetAutoRun('/HIDE', cbAutoRun.Checked);
    AProgramSettings := FProgramSettings;
  end;
end;

procedure TfrmOptions.ActionBackupProfileWizardExecute(Sender: TObject);
var
  BackupProfile: TBackupProfile;
begin
  BackupProfile := FBackupProfileManager.NewProfile('Backup Profile');
  if frmBackupProfileWizard.Execute(BackupProfile) then
  begin
    BackupProfile.SaveProfile;
  end
  else
  begin
    FBackupProfileManager.DeleteProfile(BackupProfile.ProfileName);
  end;
  BackupProfile := nil;
  UpdateProfileList;
end;

procedure TfrmOptions.ActionOpenLogInExplorerExecute(Sender: TObject);
begin
  if Assigned(FLog) then
  begin
    ExecuteFile('open', 'explorer.exe', '/e, /select,"' + FLog.FileName + '"',
      ExtractFilePath(FLog.FileName), SW_SHOWNORMAL);
  end
  else
  begin
    MessageDlg('No log available.', mtError, [mbOK], 0);
  end;
end;

procedure TfrmOptions.ActionRefreshLogExecute(Sender: TObject);
begin
  if Assigned(FLog) then
  begin
    memoLog.Lines.Assign(FLog.LogCache);
  end
  else
  begin
    memoLog.Lines.Clear;
  end;
end;

procedure TfrmOptions.btnAddProfileClick(Sender: TObject);
var
  BackupProfile: TBackupProfile;
begin
  BackupProfile := FBackupProfileManager.NewProfile('Backup Profile');
  if frmBackupProfiles.Execute(BackupProfile) = mrOk then
  begin
    BackupProfile.SaveProfile;
  end
  else
  begin
    FBackupProfileManager.DeleteProfile(BackupProfile.ProfileName);
  end;
  BackupProfile := nil;
  UpdateProfileList;
end;

procedure TfrmOptions.btnEditProfileClick(Sender: TObject);
var
  BackupProfile: TBackupProfile;
  OldName: string;
begin
  if ListViewBackupProfiles.ItemIndex <> -1 then
  begin
    BackupProfile := FBackupProfileManager.ProfileByName
      (ListViewBackupProfiles.Items[ListViewBackupProfiles.ItemIndex].Caption);
    OldName := BackupProfile.ProfileName;
    if frmBackupProfiles.Execute(BackupProfile) = mrOk then
    begin
      BackupProfile.SaveProfile;
      if BackupProfile.ProfileName <> OldName then
      begin
        FBackupProfileManager.DeleteProfile(OldName);
      end;
    end;
    BackupProfile := nil;
  end
  else
  begin
    MessageDlg('Please select a profile.', mtError, [mbOK], 0);
  end;
  UpdateProfileList;
end;

procedure TfrmOptions.btnRemoveProfileClick(Sender: TObject);
begin
  if ListViewBackupProfiles.ItemIndex <> -1 then
  begin
    if MessageDlg(Format('Are you sure you want to remove "%s"',
      [ListViewBackupProfiles.Items[ListViewBackupProfiles.ItemIndex].Caption]),
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FBackupProfileManager.DeleteProfile(ListViewBackupProfiles.Items
        [ListViewBackupProfiles.ItemIndex].Caption);
    end;
  end
  else
  begin
    MessageDlg('Please select a profile.', mtError, [mbOK], 0);
  end;
  UpdateProfileList;
end;

procedure TfrmOptions.btnRemoveAllProfilesClick(Sender: TObject);
var
  Idx: integer;
begin
  if MessageDlg('Are you sure you want to remove all profiles?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    for Idx := 0 to Pred(ListViewBackupProfiles.Items.Count) do
    begin
      FBackupProfileManager.DeleteProfile(ListViewBackupProfiles.Items
        [Idx].Caption);
    end;
  end;
  UpdateProfileList;
end;

procedure TfrmOptions.CheckListBoxProfilesClickCheck(Sender: TObject);
var
  BackupProfile: TBackupProfile;
begin
  if ListViewBackupProfiles.ItemIndex <> -1 then
  begin
    BackupProfile := FBackupProfileManager.ProfileByName
      (ListViewBackupProfiles.Items[ListViewBackupProfiles.ItemIndex].Caption);
    with BackupProfile do
    begin
      Enabled := not Enabled;
      SaveProfile;
    end;
  end;
  UpdateProfileList;
end;

procedure TfrmOptions.ListViewBackupProfilesDblClick(Sender: TObject);
begin
  btnEditProfileClick(Sender);
end;

procedure TfrmOptions.ListViewBackupProfilesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  Item: TListItem;
  HitTest: THitTests;
  BackupProfile: TBackupProfile;
begin
  if (Sender is TListView) then
  begin
    Item := (Sender as TListView).GetItemAt(X, Y);
    HitTest := (Sender as TListView).GetHitTestInfoAt(X, Y);
    if (Item <> nil) and (HitTest = [htOnStateIcon]) then
    begin
      BackupProfile := FBackupProfileManager.ProfileByName(Item.Caption);
      if Item.Checked <> BackupProfile.Enabled then
      begin
        BackupProfile.Enabled := Item.Checked;
        BackupProfile.SaveProfile;
      end;
    end;
  end;
end;

procedure TfrmOptions.PageControlMainChange(Sender: TObject);
begin
  if PageControlMain.ActivePage = tabLog then
  begin
    ActionRefreshLog.Execute;
  end;
end;

procedure TfrmOptions.PageControlProxyChange(Sender: TObject);
begin
  if PageControlProxy.ActivePage = tabSOCKSProxy then
  begin
    with comboSocksVersion.Items do
    begin
      Clear;
      Add('None');
      Add('Socks 4');
      Add('Socks 5');
    end;
  end;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  with ComboBoxLastSelection.Items do
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

procedure TfrmOptions.FormShow(Sender: TObject);
begin
  PageControlMain.ActivePageIndex := 0;
  PageControlProxy.ActivePageIndex := 0;
  PageControlAdvanced.ActivePageIndex := 0;
  ActionRefreshLog.Execute;
end;

end.

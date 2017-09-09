{ -----------------------------------------------------------------------------
  Unit Name: frmBackupProfilesU
  Author: Tristan Marlow
  Purpose: Backup and Shutdown Backup profile editor.

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
  05/05/2007 - Compression Level Support
  07/03/2009 - NT Backup Support

  ----------------------------------------------------------------------------- }
unit frmBackupProfilesU;

interface

uses
  BackupProfileU, PluginsU, BackupU, SystemDetailsU, CommonU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvMonthCalendar, StdCtrls, Buttons, ExtCtrls,
  Mask, JvToolEdit, ToolWin, JvBaseDlg,
  JvBrowseFolder, JvExMask, JvExComCtrls, JvDialogs, Menus, Spin,
  ActnList, System.UITypes, System.Actions;

type
  TfrmBackupProfiles = class(TForm)
    pnlbottom: TPanel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    PageControlMain: TPageControl;
    tabGeneral: TTabSheet;
    tabFilesandFolders: TTabSheet;
    GroupBoxDetails: TGroupBox;
    Label1: TLabel;
    editProfileName: TEdit;
    cbProfileEnabled: TCheckBox;
    Label2: TLabel;
    memoDescription: TMemo;
    GroupBox1: TGroupBox;
    pblLastBackup: TPanel;
    tabLogging: TTabSheet;
    tabActivePrograms: TTabSheet;
    cbBackupAlertEnabled: TCheckBox;
    GroupBox4: TGroupBox;
    lblBackupAlertDays: TLabel;
    TrackBarBackupAlertDays: TTrackBar;
    cbBackupAlertEmail: TCheckBox;
    btnBackupAlertEmail: TBitBtn;
    GroupBox5: TGroupBox;
    ToolBar1: TToolBar;
    btnAddActiveProgram: TToolButton;
    btnRemoveActivePrograms: TToolButton;
    btnRemoveAllActivePrograms: TToolButton;
    ToolButton10: TToolButton;
    Bevel1: TBevel;
    cbGracefullyCloseActivePrograms: TCheckBox;
    GroupBox6: TGroupBox;
    cbLogEmailEnabled: TCheckBox;
    Bevel2: TBevel;
    btnLogEmailDetails: TBitBtn;
    GroupBox7: TGroupBox;
    memoLogFile: TMemo;
    OpenDialog: TJvOpenDialog;
    btnTestActivePrograms: TBitBtn;
    ListViewActivePrograms: TListView;
    btnEditActiveProgram: TToolButton;
    ToolButton3: TToolButton;
    Panel1: TPanel;
    CalendarBackupAlert: TJvMonthCalendar;
    lblDaysOverDue: TLabel;
    cbSaveAsDefaults: TCheckBox;
    btnLoadDefaults: TBitBtn;
    tabPlugins: TTabSheet;
    GroupBox8: TGroupBox;
    ListViewPlugins: TListView;
    ToolBar2: TToolBar;
    btnPluginsRefresh: TToolButton;
    ToolButton7: TToolButton;
    btnPluginConfig: TToolButton;
    PageControlFilesAndFolders: TPageControl;
    tabSourceFiles: TTabSheet;
    tabExclusionFiles: TTabSheet;
    tabDestination: TTabSheet;
    GroupBox9: TGroupBox;
    ToolBar3: TToolBar;
    ToolButton4: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ListViewFileFolders: TListView;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    editZIPFileName: TJvFilenameEdit;
    editPassword: TEdit;
    editSpanning: TSpinEdit;
    GroupBox2: TGroupBox;
    ToolBar: TToolBar;
    btnAddFile: TToolButton;
    btnAddFolder: TToolButton;
    ToolButton5: TToolButton;
    btnRemoveFileFolder: TToolButton;
    ToolButton6: TToolButton;
    btnRemoteAllFileFolder: TToolButton;
    ListViewExclusionFileFolders: TListView;
    ActionListBackupProfiles: TActionList;
    ActionAddFileSourceItem: TAction;
    ActionAddFolderSourceItem: TAction;
    ActionRemoveSourceItem: TAction;
    ActionRemoveAllSourceItems: TAction;
    ActionLoadDefaults: TAction;
    ActionAlertEmailDetails: TAction;
    ActionAddActiveProgram: TAction;
    ActionEditActiveProgram: TAction;
    ActionRemoveActiveProgram: TAction;
    ActionRemoveAllActivePrograms: TAction;
    ActionTestActivePrograms: TAction;
    ActionLogEmailDetails: TAction;
    ActionPluginsRefresh: TAction;
    ActionPluginConfig: TAction;
    ActionAddFileExclusionItem: TAction;
    ActionAddFolderExclusionItem: TAction;
    ActionRemoveExclusionItem: TAction;
    ActionRemoveAllExclusionItems: TAction;
    editConfirmPassword: TEdit;
    Label6: TLabel;
    TrackBarCompressionLevel: TTrackBar;
    lblCompressionLevel: TLabel;
    cbCustomSMTPSettings: TCheckBox;
    BitBtn1: TBitBtn;
    ActionCustomSMTPDetails: TAction;
    comboZipType: TComboBox;
    Label7: TLabel;
    cbSystemState: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure TrackBarBackupAlertDaysChange(Sender: TObject);
    procedure editZIPFileNameBeforeDialog(Sender: TObject; var Name: string;
      var Action: boolean);
    procedure btnOkClick(Sender: TObject);
    procedure editLogFileNameAfterDialog(Sender: TObject; var Name: string;
      var Action: boolean);
    procedure PageControlMainChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionAddFileSourceItemExecute(Sender: TObject);
    procedure ActionAddFolderSourceItemExecute(Sender: TObject);
    procedure ActionRemoveSourceItemExecute(Sender: TObject);
    procedure ActionRemoveAllSourceItemsExecute(Sender: TObject);
    procedure ActionLoadDefaultsExecute(Sender: TObject);
    procedure ActionAlertEmailDetailsExecute(Sender: TObject);
    procedure ActionAddActiveProgramExecute(Sender: TObject);
    procedure ActionEditActiveProgramExecute(Sender: TObject);
    procedure ActionRemoveActiveProgramExecute(Sender: TObject);
    procedure ActionRemoveAllActiveProgramsExecute(Sender: TObject);
    procedure ActionTestActiveProgramsExecute(Sender: TObject);
    procedure ActionLogEmailDetailsExecute(Sender: TObject);
    procedure ActionPluginsRefreshExecute(Sender: TObject);
    procedure ActionPluginConfigExecute(Sender: TObject);
    procedure ActionAddFileExclusionItemExecute(Sender: TObject);
    procedure ActionAddFolderExclusionItemExecute(Sender: TObject);
    procedure ActionRemoveExclusionItemExecute(Sender: TObject);
    procedure ActionRemoveAllExclusionItemsExecute(Sender: TObject);
    procedure TrackBarCompressionLevelChange(Sender: TObject);
    procedure PageControlFilesAndFoldersChange(Sender: TObject);
    procedure ActionCustomSMTPDetailsExecute(Sender: TObject);
    procedure ActionCustomSMTPDetailsUpdate(Sender: TObject);
    procedure comboZipTypeChange(Sender: TObject);
    procedure ListViewPluginsDblClick(Sender: TObject);
  private
    FBackupProfile: TBackupProfile;
    FPlugins: TPlugins;
    procedure GetFormValues;
    procedure SetFormValues;
    procedure UpdateFileList;
    procedure UpdateFileExclusionList;
    procedure UpdateProgramList;
    procedure UpdatePluginList;
  public
    function Execute(var ABackupProfile: TBackupProfile): integer;
  end;

var
  frmBackupProfiles: TfrmBackupProfiles;

implementation

uses DateUtils, frmFolderSelectU, frmActiveApplicationsU, frmAddProgramU,
  frmEmailDetailsU, frmSMTPDetailsU;

{$R *.dfm}

procedure TfrmBackupProfiles.UpdateFileList;
var
  Idx: integer;
  ListItem: TListItem;
begin
  ListViewFileFolders.Items.Clear;
  for Idx := 0 to Pred(FBackupProfile.Files.Count) do
  begin
    ListItem := ListViewFileFolders.Items.Add;
    with ListItem do
    begin
      Caption := FBackupProfile.Files.Item[Idx].Folder;
      SubItems.Add(FBackupProfile.Files.Item[Idx].FileMask);
      SubItems.Add(BoolToStr(FBackupProfile.Files.Item[Idx].Recursive, True));
    end;
  end;
end;

procedure TfrmBackupProfiles.UpdateFileExclusionList;
var
  Idx: integer;
  ListItem: TListItem;
begin
  ListViewExclusionFileFolders.Items.Clear;
  for Idx := 0 to Pred(FBackupProfile.FileExclusions.Count) do
  begin
    ListItem := ListViewExclusionFileFolders.Items.Add;
    with ListItem do
    begin
      Caption := FBackupProfile.FileExclusions.Item[Idx].Folder;
      SubItems.Add(FBackupProfile.FileExclusions.Item[Idx].FileMask);
      SubItems.Add(BoolToStr(FBackupProfile.FileExclusions.Item[Idx]
        .Recursive, True));
    end;
  end;
end;

procedure TfrmBackupProfiles.UpdateProgramList;
var
  Idx: integer;
  ListItem: TListItem;
begin
  ListViewActivePrograms.Items.Clear;
  for Idx := 0 to Pred(FBackupProfile.ActivePrograms.Count) do
  begin
    ListItem := ListViewActivePrograms.Items.Add;
    with ListItem do
    begin
      Caption := FBackupProfile.ActivePrograms.Names[Idx];
      SubItems.Add(FBackupProfile.ActivePrograms.ValueFromIndex[Idx]);
    end;
  end;
end;

procedure TfrmBackupProfiles.UpdatePluginList;
var
  Idx: integer;
  ListItem: TListItem;
begin
  ListViewPlugins.Items.Clear;
  for Idx := 0 to Pred(FPlugins.Count) do
  begin
    ListItem := ListViewPlugins.Items.Add;
    with ListItem do
    begin
      Caption := FPlugins.Item[Idx].PluginName;
      SubItems.Add(FPlugins.Item[Idx].PluginVersion);
      SubItems.Add(FPlugins.Item[Idx].PluginDeveloper);
    end;
  end;
end;

procedure TfrmBackupProfiles.GetFormValues;
begin
  with FBackupProfile do
  begin
    Enabled := cbProfileEnabled.Checked;
    ZipType := TZipType(comboZipType.ItemIndex);
    SystemState := cbSystemState.Checked;
    ProfileName := editProfileName.Text;
    Password := editPassword.Text;
    Description := memoDescription.Lines.Text;
    ZipFile := editZIPFileName.Text;
    CloseGracefully := cbGracefullyCloseActivePrograms.Checked;
    ShowAlerts := cbBackupAlertEnabled.Checked;
    AlertDays := TrackBarBackupAlertDays.Position;
    AlertEmailEnabled := cbBackupAlertEmail.Checked;
    LogEmailEnabled := cbLogEmailEnabled.Checked;
    SpanningSize := editSpanning.Value * 1048576;
    CompressionLevel := TCompressionLevel
      (integer(TrackBarCompressionLevel.Position));
    CustomSMTPSettings := cbCustomSMTPSettings.Checked;
  end;
end;

procedure TfrmBackupProfiles.ListViewPluginsDblClick(Sender: TObject);
begin
  ActionPluginConfig.Execute;
end;

procedure TfrmBackupProfiles.SetFormValues;
begin
  with FBackupProfile do
  begin
    cbProfileEnabled.Checked := Enabled;
    comboZipType.ItemIndex := integer(ZipType);
    cbSystemState.Checked := SystemState;
    editProfileName.Text := ProfileName;
    editPassword.Text := Password;
    editConfirmPassword.Text := Password;
    memoDescription.Lines.Text := Description;
    editZIPFileName.Text := ZipFile;
    CalendarBackupAlert.Date := LastBackup;
    if LastBackup <> 0 then
    begin
      lblDaysOverDue.Caption := Format('%d day(s) since last backup.' + #13#10 +
        'Last backup: %s' + #13#10 + 'Next backup: %s',
        [DaysBetween(Date, LastBackup), DateToStr(LastBackup),
        DateToStr(IncDay(LastBackup, AlertDays))]);
    end
    else
    begin
      lblDaysOverDue.Caption := 'No previous backup details.';
    end;
    memoLogFile.Lines.Clear;
    if FileExists(LogFile) then
      memoLogFile.Lines.LoadFromFile(LogFile);
    cbGracefullyCloseActivePrograms.Checked := CloseGracefully;
    cbBackupAlertEnabled.Checked := ShowAlerts;
    TrackBarBackupAlertDays.Position := AlertDays;
    cbBackupAlertEmail.Checked := AlertEmailEnabled;
    cbLogEmailEnabled.Checked := LogEmailEnabled;
    editSpanning.Value := SpanningSize div 1048576;
    TrackBarCompressionLevel.Position := integer(CompressionLevel);
    cbCustomSMTPSettings.Checked := CustomSMTPSettings;
    comboZipTypeChange(nil);
  end;
end;

function TfrmBackupProfiles.Execute(var ABackupProfile: TBackupProfile)
  : integer;
begin
  FBackupProfile := ABackupProfile;
  SetFormValues;
  UpdateFileList;
  UpdateFileExclusionList;
  UpdateProgramList;
  Result := Self.ShowModal;
  if Result = mrOk then
  begin
    GetFormValues;
    ABackupProfile := FBackupProfile;
    if cbSaveAsDefaults.Checked then
      ABackupProfile.SaveAsDefaults;
  end;
end;

procedure TfrmBackupProfiles.FormShow(Sender: TObject);
begin
  PageControlMain.ActivePageIndex := 0;
  PageControlFilesAndFolders.ActivePageIndex := 0;
  cbSaveAsDefaults.Checked := False;
  editProfileName.SetFocus;
end;

procedure TfrmBackupProfiles.TrackBarBackupAlertDaysChange(Sender: TObject);
begin
  lblBackupAlertDays.Caption :=
    Format('Alert if backup has not been performed in the last %d day(s)',
    [TrackBarBackupAlertDays.Position]);
end;

procedure TfrmBackupProfiles.TrackBarCompressionLevelChange(Sender: TObject);
var
  CompressionLevel: string;
begin
  case TrackBarCompressionLevel.Position of
    0:
      CompressionLevel := 'None';
    1:
      CompressionLevel := 'Low';
    2:
      CompressionLevel := 'Normal';
    3:
      CompressionLevel := 'High';
    4:
      CompressionLevel := 'Maximum (recommended)';
  else
    CompressionLevel := 'Unknown';
  end;
  lblCompressionLevel.Caption := Format('Compression Level: %s',
    [CompressionLevel]);
end;

procedure TfrmBackupProfiles.editZIPFileNameBeforeDialog(Sender: TObject;
  var Name: string; var Action: boolean);
begin
  case comboZipType.ItemIndex of
    0:
      editZIPFileName.DefaultExt := '.zip';
    1:
      editZIPFileName.DefaultExt := '.7z';
    2:
      editZIPFileName.DefaultExt := '.bkf';
  end;
  if editProfileName.Text <> '' then
  begin
    if Name = '' then
      Name := ChangeFileExt(editProfileName.Text, editZIPFileName.DefaultExt);
  end;
end;

procedure TfrmBackupProfiles.btnOkClick(Sender: TObject);
var
  FormValid: boolean;
begin
  FormValid := True;
  if editProfileName.Text = '' then
  begin
    PageControlMain.ActivePage := tabGeneral;
    MessageDlg('Please specify a profile name.', mtWarning, [mbOK], 0);
    FormValid := False;
  end;
  if not IsValidFileName(editZIPFileName.Text) then
  begin
    PageControlMain.ActivePage := tabFilesandFolders;
    PageControlFilesAndFolders.ActivePage := tabDestination;
    FormValid := MessageDlg
      (Format('"%s" does not appear to be a valid filename, do you want to continue?',
      [editZIPFileName.Text]), mtWarning, [mbYes, mbNo], 0) = mrYes;
  end;
  if editPassword.Text <> editConfirmPassword.Text then
  begin
    PageControlMain.ActivePage := tabFilesandFolders;
    PageControlFilesAndFolders.ActivePage := tabDestination;
    MessageDlg('Password''s do not match', mtWarning, [mbOK], 0);
    FormValid := False;
  end;
  if GetWindowsVersion = osWinVista then
  begin
    if (cbSystemState.Checked) or (comboZipType.ItemIndex = 2) then
    begin
      MessageDlg('NT Backup is not available for Windows Vista', mtError,
        [mbOK], 0);
      PageControlMain.ActivePage := tabFilesandFolders;
      PageControlFilesAndFolders.ActivePage := tabDestination;
      FormValid := False;
      cbSystemState.Checked := False;
    end;
  end;
  if FormValid then
  begin
    ModalResult := mrOk;
  end;
end;

procedure TfrmBackupProfiles.comboZipTypeChange(Sender: TObject);
begin
  cbSystemState.Enabled := True;
  editPassword.Enabled := True;
  editConfirmPassword.Enabled := True;
  TrackBarCompressionLevel.Enabled := True;
  editSpanning.Enabled := True;
  case comboZipType.ItemIndex of
    0:
      begin
        editSpanning.Enabled := False;
        editZIPFileName.Text := ChangeFileExt(editZIPFileName.Text, '.zip');
      end;
    1:
      begin
        editSpanning.Enabled := True;
        editZIPFileName.Text := ChangeFileExt(editZIPFileName.Text, '.7z');
      end;
    2:
      begin

        if GetWindowsVersion in [osWinVista, osWinSeven] then
        begin
          MessageDlg('NT Backup is not support on Windows Vista / 7.', mtError,
            [mbOK], 0);
        end;
        // cbSystemState.Enabled := True;
        editPassword.Enabled := False;
        editConfirmPassword.Enabled := False;
        TrackBarCompressionLevel.Enabled := False;
        editSpanning.Enabled := False;
        editZIPFileName.Text := ChangeFileExt(editZIPFileName.Text, '.bkf');
      end;
  end;
end;

procedure TfrmBackupProfiles.ActionAddActiveProgramExecute(Sender: TObject);
begin
  if frmAddProgram.Execute then
  begin
    FBackupProfile.ActivePrograms.Add(frmAddProgram.WindowName + '=' +
      frmAddProgram.WindowClass);
  end;
  UpdateProgramList;
end;

procedure TfrmBackupProfiles.ActionAddFileExclusionItemExecute(Sender: TObject);
var
  Idx: integer;
begin
  if OpenDialog.Execute then
  begin
    for Idx := 0 to Pred(OpenDialog.Files.Count) do
    begin
      FBackupProfile.FileExclusions.Add(ExtractFileDir(OpenDialog.Files[Idx]),
        ExtractFileName(OpenDialog.Files[Idx]), False);
    end;
  end;
  UpdateFileExclusionList;
end;

procedure TfrmBackupProfiles.ActionAddFileSourceItemExecute(Sender: TObject);
var
  Idx: integer;
begin
  if OpenDialog.Execute then
  begin
    for Idx := 0 to Pred(OpenDialog.Files.Count) do
    begin
      FBackupProfile.Files.Add(ExtractFileDir(OpenDialog.Files[Idx]),
        ExtractFileName(OpenDialog.Files[Idx]), False);
    end;
  end;
  UpdateFileList;
end;

procedure TfrmBackupProfiles.ActionAddFolderExclusionItemExecute
  (Sender: TObject);
var
  frmFolderSelect: TfrmFolderSelect;
begin
  frmFolderSelect := TfrmFolderSelect.Create(Self);
  try
    with frmFolderSelect do
    begin
      Wildcards := '*.*';
      Recurse := True;
      ShowHidden := True;
      if Execute then
      begin
        FBackupProfile.FileExclusions.Add(frmFolderSelect.Folder,
          frmFolderSelect.Wildcards, frmFolderSelect.Recurse);
      end;
    end;
  finally
    FreeAndNil(frmFolderSelect);
  end;
  UpdateFileExclusionList;
end;

procedure TfrmBackupProfiles.ActionAddFolderSourceItemExecute(Sender: TObject);
var
  frmFolderSelect: TfrmFolderSelect;
begin
  frmFolderSelect := TfrmFolderSelect.Create(Self);
  try
    with frmFolderSelect do
    begin
      Wildcards := '*.*';
      Recurse := True;
      ShowHidden := True;
      if Execute then
      begin
        FBackupProfile.Files.Add(frmFolderSelect.Folder,
          frmFolderSelect.Wildcards, frmFolderSelect.Recurse);
      end;
    end;
  finally
    FreeAndNil(frmFolderSelect);
  end;
  UpdateFileList;
end;

procedure TfrmBackupProfiles.ActionAlertEmailDetailsExecute(Sender: TObject);
begin
  if not frmEmailDetails.Execute(FBackupProfile.AlertEmailDetails) then
  begin
  end;
end;

procedure TfrmBackupProfiles.ActionCustomSMTPDetailsExecute(Sender: TObject);
begin
  frmSMTPDetails.Execute(FBackupProfile.SMTPSettings);
end;

procedure TfrmBackupProfiles.ActionCustomSMTPDetailsUpdate(Sender: TObject);
var
  AllowExecute: boolean;
begin
  AllowExecute := True;
  if AllowExecute then
    AllowExecute := cbCustomSMTPSettings.Checked;
  ActionCustomSMTPDetails.Enabled := AllowExecute;
end;

procedure TfrmBackupProfiles.ActionEditActiveProgramExecute(Sender: TObject);
var
  Idx: integer;
begin
  if ListViewActivePrograms.ItemIndex <> -1 then
  begin
    with FBackupProfile.ActivePrograms do
    begin
      Idx := FBackupProfile.ActivePrograms.IndexOfName
        (ListViewActivePrograms.Items[ListViewActivePrograms.ItemIndex]
        .Caption);
      frmAddProgram.WindowName := Names[Idx];
      frmAddProgram.WindowClass := ValueFromIndex[Idx];
      if frmAddProgram.Execute then
      begin
        FBackupProfile.ActivePrograms[Idx] := frmAddProgram.WindowName + '=' +
          frmAddProgram.WindowClass;
      end;
    end;
  end;
  UpdateProgramList;
end;

procedure TfrmBackupProfiles.ActionLoadDefaultsExecute(Sender: TObject);
var
  ProfileName: string;
begin
  if MessageDlg('Are you sure you want to load profile defaults?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ProfileName := editProfileName.Text;
    FBackupProfile.LoadDefaults;
    FBackupProfile.ProfileName := ProfileName;
    SetFormValues;
  end;
end;

procedure TfrmBackupProfiles.ActionLogEmailDetailsExecute(Sender: TObject);
begin
  if not frmEmailDetails.Execute(FBackupProfile.LogEmailDetails) then
  begin
  end;
end;

procedure TfrmBackupProfiles.ActionPluginConfigExecute(Sender: TObject);
begin
  if ListViewPlugins.ItemIndex <> -1 then
  begin
    FPlugins.Config(ListViewPlugins.Items[ListViewPlugins.ItemIndex].Caption,
      editProfileName.Text);
  end;
end;

procedure TfrmBackupProfiles.ActionPluginsRefreshExecute(Sender: TObject);
begin
  FPlugins.Refresh;
  UpdatePluginList;
end;

procedure TfrmBackupProfiles.ActionRemoveActiveProgramExecute(Sender: TObject);
var
  Idx: integer;
begin
  if ListViewActivePrograms.ItemIndex <> -1 then
  begin
    Idx := FBackupProfile.ActivePrograms.IndexOfName
      (ListViewActivePrograms.Items[ListViewActivePrograms.ItemIndex].Caption);
    if Idx <> -1 then
    begin
      if MessageDlg(Format('Are you sure you want to remove "%s"',
        [FBackupProfile.ActivePrograms.Names[Idx]]), mtConfirmation,
        [mbYes, mbNo], 0) = mrYes then
      begin
        FBackupProfile.ActivePrograms.Delete(Idx);
      end;
    end;
  end;
  UpdateProgramList;
end;

procedure TfrmBackupProfiles.ActionRemoveAllActiveProgramsExecute
  (Sender: TObject);
begin
  if MessageDlg('Are you sure you want to clear active program list?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FBackupProfile.ActivePrograms.Clear;
  end;
  UpdateProgramList;
end;

procedure TfrmBackupProfiles.ActionRemoveAllExclusionItemsExecute
  (Sender: TObject);
begin
  if MessageDlg('Are you sure you want to remove all entries?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    FBackupProfile.FileExclusions.Clear;
  end;
  UpdateFileExclusionList;
end;

procedure TfrmBackupProfiles.ActionRemoveAllSourceItemsExecute(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to remove all entries?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    FBackupProfile.Files.Clear;
  end;
  UpdateFileList;
end;

procedure TfrmBackupProfiles.ActionRemoveExclusionItemExecute(Sender: TObject);
var
  FolderName, FileMask: string;
  FileID: integer;
begin
  if ListViewFileFolders.ItemIndex <> -1 then
  begin
    FolderName := ListViewFileFolders.Items
      [ListViewFileFolders.ItemIndex].Caption;
    FileMask := ListViewFileFolders.Items[ListViewFileFolders.ItemIndex]
      .SubItems[0];
    FileID := FBackupProfile.FileExclusions.IndexByName(FolderName, FileMask);
    if FileID <> -1 then
    begin
      if MessageDlg(Format('Are you sure you want to remove entry "%s - %s"',
        [FolderName, FileMask]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        FBackupProfile.FileExclusions.Delete(FileID);
      end;
    end
    else
    begin
      MessageDlg(Format('Failed to locate item "%s - %s"',
        [FolderName, FileMask]), mtError, [mbOK], 0);
    end;
  end;
  UpdateFileExclusionList;
end;

procedure TfrmBackupProfiles.ActionRemoveSourceItemExecute(Sender: TObject);
var
  FolderName, FileMask: string;
  FileID: integer;
begin
  if ListViewFileFolders.ItemIndex <> -1 then
  begin
    FolderName := ListViewFileFolders.Items
      [ListViewFileFolders.ItemIndex].Caption;
    FileMask := ListViewFileFolders.Items[ListViewFileFolders.ItemIndex]
      .SubItems[0];
    FileID := FBackupProfile.Files.IndexByName(FolderName, FileMask);
    if FileID <> -1 then
    begin
      if MessageDlg(Format('Are you sure you want to remove entry "%s - %s"',
        [FolderName, FileMask]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        FBackupProfile.Files.Delete(FileID);
      end;
    end
    else
    begin
      MessageDlg(Format('Failed to locate item "%s - %s"',
        [FolderName, FileMask]), mtError, [mbOK], 0);
    end;
  end;
  UpdateFileList;
end;

procedure TfrmBackupProfiles.ActionTestActiveProgramsExecute(Sender: TObject);
begin
  if MessageDlg
    ('This test will attempt to close active applications, please ensure you have saved your work. Are you sure you want to continue?',
    mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    if frmActiveApplications.Execute(FBackupProfile.ActivePrograms,
      cbGracefullyCloseActivePrograms.Checked) then
    begin
      MessageDlg('All applications have been terminated.', mtInformation,
        [mbOK], 0);
    end
    else
    begin
      MessageDlg('Failed to close all applications.', mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmBackupProfiles.editLogFileNameAfterDialog(Sender: TObject;
  var Name: string; var Action: boolean);
begin
  Name := ExtractShortPathName(Name);
end;

procedure TfrmBackupProfiles.PageControlFilesAndFoldersChange(Sender: TObject);
begin
  if PageControlFilesAndFolders.ActivePage = tabDestination then
  begin
    TrackBarCompressionLevelChange(Sender);
  end;
end;

procedure TfrmBackupProfiles.PageControlMainChange(Sender: TObject);
begin
  if PageControlMain.ActivePage = tabPlugins then
  begin
    FPlugins.Active := True;
    UpdatePluginList;
  end
  else
  begin
    FPlugins.Active := False;
  end;
end;

procedure TfrmBackupProfiles.FormCreate(Sender: TObject);
begin
  FPlugins := TPlugins.Create;
  with FPlugins do
  begin
    PluginFolder := GetApplicationDir + 'plugins\';
  end;
end;

procedure TfrmBackupProfiles.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPlugins);
end;

end.

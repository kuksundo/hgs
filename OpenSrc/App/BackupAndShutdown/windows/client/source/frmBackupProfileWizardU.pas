unit frmBackupProfileWizardU;

interface

uses
  CommonU,
  BackupProfileU, SystemApplicationDetailsU, SystemDetailsU, BackupU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvWizard, JvExControls, StdCtrls, ComCtrls, Buttons, Spin,
  Mask, JvExMask, JvToolEdit, ExtCtrls, ActnList, System.UITypes,
  System.Actions;

type
  TfrmBackupProfileWizard = class(TForm)
    BackupProfileWizard: TJvWizard;
    PageWelcome: TJvWizardWelcomePage;
    PageProfileDetails: TJvWizardInteriorPage;
    PageApplicationDetails: TJvWizardInteriorPage;
    Label1: TLabel;
    cbProfileEnabled: TCheckBox;
    Label2: TLabel;
    editProfileName: TEdit;
    Label3: TLabel;
    memoDescription: TMemo;
    GroupBoxEmailApplications: TGroupBox;
    cbMicrosoftOutlook: TCheckBox;
    cbOutlookExpress: TCheckBox;
    cbWindowsMail: TCheckBox;
    GroupBox1: TGroupBox;
    cbInternetExplorer: TCheckBox;
    cbFirefox: TCheckBox;
    cbAdvanced: TCheckBox;
    GroupBox2: TGroupBox;
    cbMyDocuments: TCheckBox;
    cbDesktop: TCheckBox;
    PageIncludedFilesFolders: TJvWizardInteriorPage;
    ListViewFileFolders: TListView;
    comboFireFoxProfiles: TComboBox;
    Label4: TLabel;
    PageExcludedFilesFolders: TJvWizardInteriorPage;
    cbMyPictures: TCheckBox;
    PageBackupDestination: TJvWizardInteriorPage;
    Label5: TLabel;
    editZIPFileName: TJvFilenameEdit;
    editPassword: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    editConfirmPassword: TEdit;
    editSpanning: TSpinEdit;
    Label8: TLabel;
    TrackBarCompressionLevel: TTrackBar;
    lblCompressionLevel: TLabel;
    PageBackupAlerts: TJvWizardInteriorPage;
    ListViewExclusionFileFolders: TListView;
    GroupBox4: TGroupBox;
    lblBackupAlertDays: TLabel;
    TrackBarBackupAlertDays: TTrackBar;
    cbBackupAlertEmail: TCheckBox;
    btnBackupAlertEmail: TBitBtn;
    cbBackupAlertEnabled: TCheckBox;
    PageAdvanced: TJvWizardInteriorPage;
    cbCustomSMTPSettings: TCheckBox;
    BitBtn1: TBitBtn;
    cbLogEmailEnabled: TCheckBox;
    btnLogEmailDetails: TBitBtn;
    PageComplete: TJvWizardInteriorPage;
    Label9: TLabel;
    Image1: TImage;
    ActionListBackupProfiles: TActionList;
    ActionAddFileSourceItem: TAction;
    ActionAddFolderSourceItem: TAction;
    ActionRemoveSourceItem: TAction;
    ActionRemoveAllSourceItems: TAction;
    ActionLoadDefaults: TAction;
    ActionAlertEmailDetails: TAction;
    ActionLogEmailDetails: TAction;
    ActionAddFileExclusionItem: TAction;
    ActionAddFolderExclusionItem: TAction;
    ActionRemoveExclusionItem: TAction;
    ActionRemoveAllExclusionItems: TAction;
    ActionCustomSMTPDetails: TAction;
    Label10: TLabel;
    Label11: TLabel;
    comboZipType: TComboBox;
    cbSystemState: TCheckBox;
    cbChrome: TCheckBox;
    cbSafari: TCheckBox;
    cbMyMusic: TCheckBox;
    cbMyVideo: TCheckBox;
    cbOpera: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure PageApplicationDetailsEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageIncludedFilesFoldersEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure BackupProfileWizardFinishButtonClick(Sender: TObject);
    procedure PageProfileDetailsNextButtonClick(Sender: TObject;
      var Stop: boolean);
    procedure PageIncludedFilesFoldersBackButtonClick(Sender: TObject;
      var Stop: boolean);
    procedure editZIPFileNameBeforeDialog(Sender: TObject; var AName: string;
      var AAction: boolean);
    procedure TrackBarCompressionLevelChange(Sender: TObject);
    procedure PageWelcomeNextButtonClick(Sender: TObject; var Stop: boolean);
    procedure TrackBarBackupAlertDaysChange(Sender: TObject);
    procedure PageBackupAlertsEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure PageBackupDestinationNextButtonClick(Sender: TObject;
      var Stop: boolean);
    procedure cbFirefoxClick(Sender: TObject);
    procedure ActionLogEmailDetailsExecute(Sender: TObject);
    procedure ActionAlertEmailDetailsExecute(Sender: TObject);
    procedure ActionCustomSMTPDetailsExecute(Sender: TObject);
    procedure comboZipTypeChange(Sender: TObject);
    procedure PageBackupDestinationEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
  private
    FEmailApplication: TEmailApplicationDetails;
    FBrowserApplications: TBrowserApplicationDetails;
    FBackupProfile: TBackupProfile;
    procedure GatherSystemInformation;
    procedure ResetSystemInformation;
    procedure UpdateFileList;
    procedure GetFormValues;
    procedure SetFormValues;
  public
    function Execute(ABackupProfile: TBackupProfile): boolean;
  end;

var
  frmBackupProfileWizard: TfrmBackupProfileWizard;

implementation

uses
  dlgProgressU, frmEmailDetailsU, frmSMTPDetailsU;

{$R *.dfm}

procedure TfrmBackupProfileWizard.GetFormValues;
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

procedure TfrmBackupProfileWizard.PageBackupAlertsEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
  TrackBarBackupAlertDaysChange(Sender);
end;

procedure TfrmBackupProfileWizard.PageBackupDestinationEnterPage
  (Sender: TObject; const FromPage: TJvWizardCustomPage);
begin
  comboZipTypeChange(Sender);
end;

procedure TfrmBackupProfileWizard.PageBackupDestinationNextButtonClick
  (Sender: TObject; var Stop: boolean);
begin
  Stop := False;
  if not IsValidFileName(editZIPFileName.Text) then
  begin
    Stop := MessageDlg
      (Format('"%s" does not appear to be a valid filename, do you want to continue?',
      [editZIPFileName.Text]), mtWarning, [mbYes, mbNo], 0) = mrNo;
  end;
  if editPassword.Text <> editConfirmPassword.Text then
  begin
    MessageDlg('Password''s do not match', mtWarning, [mbOK], 0);
    Stop := True;
  end;
  if GetWindowsVersion = osWinVista then
  begin
    if (cbSystemState.Checked) or (comboZipType.ItemIndex = 2) then
    begin
      MessageDlg('NT Backup is not available for Windows Vista', mtError,
        [mbOK], 0);
      cbSystemState.Checked := False;
      Stop := True;
    end;
  end;
end;

procedure TfrmBackupProfileWizard.SetFormValues;
begin
  with FBackupProfile do
  begin
    cbProfileEnabled.Checked := Enabled;
    comboZipType.ItemIndex := integer(ZipType);
    cbSystemState.Checked := SystemState;
    editProfileName.Text := ProfileName;
    editPassword.Text := Password;
    memoDescription.Lines.Text := Description;
    editZIPFileName.Text := ZipFile;
    cbBackupAlertEnabled.Checked := ShowAlerts;
    TrackBarBackupAlertDays.Position := AlertDays;
    cbBackupAlertEmail.Checked := AlertEmailEnabled;
    cbLogEmailEnabled.Checked := LogEmailEnabled;
    editSpanning.Value := SpanningSize div 1048576;
    TrackBarCompressionLevel.Position := integer(CompressionLevel);
    cbCustomSMTPSettings.Checked := CustomSMTPSettings;
  end;
end;

procedure TfrmBackupProfileWizard.TrackBarBackupAlertDaysChange
  (Sender: TObject);
begin
  lblBackupAlertDays.Caption :=
    Format('Alert if backup has not been performed in the last %d day(s)',
    [TrackBarBackupAlertDays.Position]);
end;

procedure TfrmBackupProfileWizard.TrackBarCompressionLevelChange
  (Sender: TObject);
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

procedure TfrmBackupProfileWizard.ActionAlertEmailDetailsExecute
  (Sender: TObject);
begin
  if not frmEmailDetails.Execute(FBackupProfile.AlertEmailDetails) then
  begin
  end;
end;

procedure TfrmBackupProfileWizard.ActionCustomSMTPDetailsExecute
  (Sender: TObject);
begin
  frmSMTPDetails.Execute(FBackupProfile.SMTPSettings);
end;

procedure TfrmBackupProfileWizard.ActionLogEmailDetailsExecute(Sender: TObject);
begin
  if not frmEmailDetails.Execute(FBackupProfile.LogEmailDetails) then
  begin
  end;
end;

procedure TfrmBackupProfileWizard.BackupProfileWizardFinishButtonClick
  (Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

procedure TfrmBackupProfileWizard.cbFirefoxClick(Sender: TObject);
begin
  comboFireFoxProfiles.Enabled := cbFirefox.Checked;
end;

procedure TfrmBackupProfileWizard.comboZipTypeChange(Sender: TObject);
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

procedure TfrmBackupProfileWizard.editZIPFileNameBeforeDialog(Sender: TObject;
  var AName: string; var AAction: boolean);
begin
  if editProfileName.Text <> '' then
  begin
    if Name = '' then
      Name := editProfileName.Text + editZIPFileName.DefaultExt;
  end;
end;

function TfrmBackupProfileWizard.Execute(ABackupProfile
  : TBackupProfile): boolean;
begin
  Result := False;
  FBackupProfile := ABackupProfile;
  SetFormValues;
  if Self.ShowModal = mrOk then
  begin
    GetFormValues;
    Result := True;
  end;
end;

procedure TfrmBackupProfileWizard.FormCreate(Sender: TObject);
begin
  FEmailApplication := TEmailApplicationDetails.Create;
  FBrowserApplications := TBrowserApplicationDetails.Create;
end;

procedure TfrmBackupProfileWizard.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEmailApplication);
  FreeAndNil(FBrowserApplications);
end;

procedure TfrmBackupProfileWizard.FormShow(Sender: TObject);
begin
  BackupProfileWizard.SelectFirstPage;
end;

procedure TfrmBackupProfileWizard.ResetSystemInformation;
begin
  // Mail Clients
  cbOutlookExpress.Enabled := False;
  cbMicrosoftOutlook.Enabled := False;
  cbWindowsMail.Enabled := False;
  cbOutlookExpress.Checked := False;
  cbMicrosoftOutlook.Checked := False;
  cbWindowsMail.Checked := False;

  // Web Browsers
  cbInternetExplorer.Enabled := False;
  cbFirefox.Enabled := False;
  cbInternetExplorer.Checked := False;
  cbFirefox.Checked := False;
  comboFireFoxProfiles.Enabled := cbFirefox.Checked;
  cbChrome.Enabled := False;
  cbChrome.Checked := False;
  cbSafari.Enabled := False;
  cbSafari.Checked := False;
  cbOpera.Enabled := False;
  cbOpera.Checked := False;

  // Folders
  cbMyDocuments.Checked := True;
  cbMyPictures.Checked := True;
  cbMyMusic.Checked := True;
  cbMyVideo.Checked := True;
  cbDesktop.Checked := True;
end;

procedure TfrmBackupProfileWizard.GatherSystemInformation;
var
  dlgProgress: TdlgProgress;
begin
  dlgProgress := TdlgProgress.Create(Self);
  try
    ResetSystemInformation;
    dlgProgress.ShowEstimatedTime := True;
    dlgProgress.Show('Gathering System Information...', psWaiting);
    // Mail Clients
    if eaOutlook in FEmailApplication.InstalledMailApplications then
      cbMicrosoftOutlook.Enabled := True;
    if eaOutlookExpress in FEmailApplication.InstalledMailApplications then
      cbOutlookExpress.Enabled := True;
    if eaWindowsMail in FEmailApplication.InstalledMailApplications then
      cbWindowsMail.Enabled := True;
    dlgProgress.Update;
    case FEmailApplication.DefaultMailApplication of
      eaOutlookExpress:
        cbOutlookExpress.Checked := True;
      eaOutlook:
        cbMicrosoftOutlook.Checked := True;
      eaWindowsMail:
        cbWindowsMail.Checked := True;
    end;
    dlgProgress.Update;
    // Web Browsers
    if baIE in FBrowserApplications.InstalledBrowserApplications then
      cbInternetExplorer.Enabled := True;
    if baFirefox in FBrowserApplications.InstalledBrowserApplications then
      cbFirefox.Enabled := True;
    if baChrome in FBrowserApplications.InstalledBrowserApplications then
      cbChrome.Enabled := True;
    if baSafari in FBrowserApplications.InstalledBrowserApplications then
      cbSafari.Enabled := True;
    if baOpera in FBrowserApplications.InstalledBrowserApplications then
      cbOpera.Enabled := True;
    dlgProgress.Update;
    cbInternetExplorer.Checked := cbInternetExplorer.Enabled;
    cbInternetExplorer.Hint := FBrowserApplications.GetIEFavoritesFolder;
    cbFirefox.Checked := cbFirefox.Enabled;
    comboFireFoxProfiles.Enabled := cbFirefox.Checked;
    cbChrome.Checked := cbChrome.Enabled;
    cbChrome.Hint := FBrowserApplications.GetChromeBookmarksFileName;
    cbSafari.Checked := cbSafari.Enabled;
    cbSafari.Hint := FBrowserApplications.GetSafariBookmarksFileName;
    cbOpera.Checked := cbOpera.Enabled;
    cbOpera.Hint := FBrowserApplications.GetOperaBookmarksFileName;
    FBrowserApplications.GetFirefoxProfiles(comboFireFoxProfiles.Items);
    comboFireFoxProfiles.Items.Add('All');
    comboFireFoxProfiles.ItemIndex := Pred(comboFireFoxProfiles.Items.Count);
    dlgProgress.Update;
    dlgProgress.Hide;
  finally
    FreeAndNil(dlgProgress);
  end;
end;

procedure TfrmBackupProfileWizard.PageIncludedFilesFoldersBackButtonClick
  (Sender: TObject; var Stop: boolean);
begin
  Stop := MessageDlg
    ('This will refresh the selected files and folder and you will loose any custom files and folders you have included. Are you sure you want to continue?',
    mtWarning, [mbYes, mbNo], 0) = mrNo;
end;

procedure TfrmBackupProfileWizard.PageIncludedFilesFoldersEnterPage
  (Sender: TObject; const FromPage: TJvWizardCustomPage);
var
  Idx: integer;
  TempFileName: TFileName;
  FileList: TStringList;
  dlgProgress: TdlgProgress;
begin
  FBackupProfile.Files.Clear;
  FBackupProfile.FileExclusions.Clear;
  dlgProgress := TdlgProgress.Create(Self);
  FileList := TStringList.Create;
  try
    dlgProgress.ShowEstimatedTime := True;
    dlgProgress.Show('Generating File List...', psNormal);
    dlgProgress.Progress(0);
    if cbMicrosoftOutlook.Checked then
    begin
      FEmailApplication.GetOutlookDataFiles(FileList);
      for Idx := 0 to Pred(FileList.Count) do
      begin
        dlgProgress.Progress(5);
        TempFileName := FileList[Idx];
        FBackupProfile.Files.Add(ExtractFilePath(TempFileName),
          ExtractFileName(TempFileName), False);
      end;
    end;
    dlgProgress.Progress(10);
    if cbWindowsMail.Checked then
    begin
      FBackupProfile.Files.Add(FEmailApplication.GetWindowsMailDataFolder,
        '*.*', True);
    end;
    dlgProgress.Progress(20);
    if cbInternetExplorer.Checked then
    begin
      FBackupProfile.Files.Add(FBrowserApplications.GetIEFavoritesFolder,
        '*.*', True);
    end;
    dlgProgress.Progress(30);
    if cbFirefox.Checked then
    begin
      if comboFireFoxProfiles.ItemIndex = Pred(comboFireFoxProfiles.Items.Count)
      then
      begin
        // Include all profiles.
        for Idx := 0 to Pred(comboFireFoxProfiles.Items.Count - 1) do
        begin
          dlgProgress.Progress(35);
          TempFileName := FBrowserApplications.GetFirefoxBookmarksFileName
            (comboFireFoxProfiles.Items[Idx]);
          FBackupProfile.Files.Add(ExtractFilePath(TempFileName),
            ExtractFileName(TempFileName), False);
        end;
      end
      else
      begin
        TempFileName := FBrowserApplications.GetFirefoxBookmarksFileName
          (comboFireFoxProfiles.Items[comboFireFoxProfiles.ItemIndex]);
        FBackupProfile.Files.Add(ExtractFilePath(TempFileName),
          ExtractFileName(TempFileName), False);
      end;

    end;
    dlgProgress.Progress(40);
    if cbChrome.Checked then
    begin
      TempFileName := FBrowserApplications.GetChromeBookmarksFileName;
      FBackupProfile.Files.Add(ExtractFilePath(TempFileName),
        ExtractFileName(TempFileName), False);
    end;
    dlgProgress.Progress(50);
    if cbSafari.Checked then
    begin
      TempFileName := FBrowserApplications.GetSafariBookmarksFileName;
      FBackupProfile.Files.Add(ExtractFilePath(TempFileName),
        ExtractFileName(TempFileName), False);
    end;
    dlgProgress.Progress(60);
    if cbOpera.Checked then
    begin
      TempFileName := FBrowserApplications.GetOperaBookmarksFileName;
      FBackupProfile.Files.Add(ExtractFilePath(TempFileName),
        ExtractFileName(TempFileName), False);
    end;
    dlgProgress.Progress(70);
    if cbMyDocuments.Checked then
    begin
      FBackupProfile.Files.Add(FEmailApplication.GetMyDocumentsFolder,
        '*.*', True);
    end;
    if cbMyMusic.Checked then
    begin
      FBackupProfile.Files.Add(FEmailApplication.GetMyMusicFolder, '*.*', True);
    end;
    dlgProgress.Progress(80);
    if cbMyVideo.Checked then
    begin
      FBackupProfile.Files.Add(FEmailApplication.GetMyVideoFolder, '*.*', True);
    end;
    if cbMyPictures.Checked then
    begin
      FBackupProfile.Files.Add(FEmailApplication.GetMyPicturesFolder,
        '*.*', True);
    end;
    dlgProgress.Progress(90);
    if cbDesktop.Checked then
    begin
      FBackupProfile.Files.Add(FEmailApplication.GetDesktopFolder, '*.*', True);
    end;
    dlgProgress.Progress(100);
  finally
    FreeAndNil(FileList);
    FreeAndNil(dlgProgress);
    UpdateFileList;
  end;

end;

procedure TfrmBackupProfileWizard.UpdateFileList;
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

procedure TfrmBackupProfileWizard.PageApplicationDetailsEnterPage
  (Sender: TObject; const FromPage: TJvWizardCustomPage);
begin
  GatherSystemInformation;
end;

procedure TfrmBackupProfileWizard.PageProfileDetailsNextButtonClick
  (Sender: TObject; var Stop: boolean);
begin
  if not Stop then
  begin
    if Length(editProfileName.Text) = 0 then
    begin
      MessageDlg('Please specify a valid profile name.', mtError, [mbOK], 0);
      editProfileName.SetFocus;
      Stop := True;
    end;
  end;
end;

procedure TfrmBackupProfileWizard.PageWelcomeNextButtonClick(Sender: TObject;
  var Stop: boolean);
begin
  PageAdvanced.Enabled := cbAdvanced.Checked;
end;

end.

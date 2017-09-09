unit uAccountsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  PngBitBtn, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.PlatformDefaultStyleActnCtrls, System.Actions, Vcl.ActnList,
  uAccounts, uProtocol, Vcl.Grids, Vcl.ValEdit, System.Types, System.UITypes;

const
  UseDefaultSound = '[Use Default Sound]';
  UseDefaultProgram = '[Use Default Program]';

type
  TAccountsForm = class(TForm)
    panAccounts: TPanel;
    tabAccounts: TTabControl;
    ScrollBox2: TScrollBox;
    lblServer: TLabel;
    lblUsername: TLabel;
    lblPw: TLabel;
    lblName: TLabel;
    lblAccountSound: TLabel;
    lblColor: TLabel;
    btnEdSound: TSpeedButton;
    btnAccountSoundTest: TSpeedButton;
    lblEmailApp: TLabel;
    btnEdAccountProgram: TSpeedButton;
    btnAccountProgramTest: TSpeedButton;
    lblProt: TLabel;
    lblPort: TLabel;
    edUsername: TEdit;
    edPassword: TEdit;
    edName: TEdit;
    chkAccEnabled: TCheckBox;
    colAccount: TColorBox;
    panIntervalAccount: TPanel;
    btnNeverAccount: TSpeedButton;
    lblCheckMins: TLabel;
    lblCheckEvery: TLabel;
    edIntervalAccount: TEdit;
    UpDownAccount: TUpDown;
    edSound: TEdit;
    edAccountProgram: TEdit;
    edServer: TEdit;
    cmbProtocol: TComboBox;
    edPort: TEdit;
    chkSSL: TCheckBox;
    lblAuthMode: TLabel;
    lblSslVer: TLabel;
    cmbAuthType: TComboBox;
    cmbSslVer: TComboBox;
    chkStartTLS: TCheckBox;
    panNoCheckHours: TPanel;
    lblAnd: TLabel;
    chkDontCheckTimes: TCheckBox;
    dtStart: TDateTimePicker;
    dtEnd: TDateTimePicker;
    panAccountsButtons: TPanel;
    btnSave: TBitBtn;
    btnCancelAccount: TBitBtn;
    btnHelpAccounts: TPngBitBtn;
    AccountsToolbar: TActionToolBar;
    AccountsActionManager: TActionManager;
    actTestAccount: TAction;
    actAddAccount: TAction;
    actDeleteAccount: TAction;
    panelGrp1: TCategoryPanelGroup;
    catBasicAccount: TCategoryPanel;
    catPopTrayAccountPrefs: TCategoryPanel;
    catAccName: TCategoryPanel;
    catAdvAcc: TCategoryPanel;
    lblUseSsl: TLabel;
    lblStartls: TLabel;
    lblEnableAccount: TLabel;
    lblTest: TLabel;
    catImap: TCategoryPanel;
    chkGmailExt: TCheckBox;
    chkMoveSpam: TCheckBox;
    lblSpamFolder: TLabel;
    edSpamFolder: TEdit;
    chkMoveTrash: TCheckBox;
    edTrashFolder: TEdit;
    lblTrashFolder: TLabel;
    btnSpamFolder: TSpeedButton;
    btnTrashFolder: TSpeedButton;
    lblArchiveFolder: TLabel;
    edArchiveFolder: TEdit;
    btnArchiveFolder: TSpeedButton;
    actExport: TAction;
    actImport: TAction;
    procedure btnNeverAccountClick(Sender: TObject);
    procedure cmbProtocolChange(Sender: TObject);
    procedure chkSSLClick(Sender: TObject);
    procedure edSoundEnter(Sender: TObject);
    procedure edSoundExit(Sender: TObject);
    procedure btnEdAccountProgramClick(Sender: TObject);
    procedure btnAccountProgramTestClick(Sender: TObject);
    procedure edAccountProgramEnter(Sender: TObject);
    procedure edAccountProgramExit(Sender: TObject);
    procedure btnAccountSoundTestClick(Sender: TObject);
    procedure chkDontCheckTimesClick(Sender: TObject);
    procedure edAccChange(Sender: TObject);
    procedure tabAccountsChange(Sender: TObject);
    procedure tabAccountsChanging(Sender: TObject; var AllowChange: Boolean);
    procedure tabAccountsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tabDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DragMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnHelpAccountsClick(Sender: TObject);
    procedure btnSaveAccountClick(Sender: TObject);
    procedure btnCancelAccountClick(Sender: TObject);
    procedure actAddAccountExecute(Sender: TObject);
    procedure actDeleteAccountExecute(Sender: TObject);
    procedure actTestAccountExecute(Sender: TObject);
    procedure btnEdSoundClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure ValueListEditor2StringsChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure colAccountGetColors(Sender: TCustomColorBox; Items: TStrings);
    procedure FormShow(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure btnPickFolderClick(Sender: TObject);
    procedure chkMoveSpamClick(Sender: TObject);
    procedure chkMoveTrashClick(Sender: TObject);

  private
    { Private declarations }
    FNewAccount : boolean;
    FAccChanged : Boolean;
    function GetAuthTypeFromComboValue(comboBox : TComboBox) : TAuthType;
    procedure SaveAccountEdits(account : TAccount);
    function AccountChanged(tab : integer) : boolean;
    procedure EnableFields(EnableIt: Boolean);
    procedure DeleteAccount(num: integer);
    procedure setPortOnAccountTab();

    procedure WMDropFiles(var msg: TWMDROPFILES); message WM_DROPFILES;
    function GetAccountForTab(tabNumber : integer) : TAccount;
    procedure showHideImapOptions;
    procedure EnableSSLOptions(enable : boolean);
    function ShowSaveAccountDlg(dlgTitle : string) : integer;
    procedure RevertAccountChanges();
  public
    { Public declarations }
    procedure RefreshProtocols();
    procedure ShowDefaultAccount();
    procedure Initialize();
    procedure PageControlChanging(Sender: TObject; var AllowChange: Boolean);
    procedure UpdateFonts();
    procedure OnSetLanguage();
    procedure ShowAccount(account : TAccount);
  end;

var
  frmAccounts: TAccountsForm;

implementation

uses uTranslate, uRCUtils, uMailItems, uMain, uRulesForm, uGlobal, uDM,
  uIniSettings, uRulesManager, IdStack, IdGlobalProtocols, ShellAPI, Math,
  uPositioning, System.IniFiles, ExportAcctDlg, uImportAccountDlg,
  uImapFolderSelect, System.TypInfo, SynTaskDialog;
//todo umailitems = suspect!

{$R *.dfm}

// This method should be called after the accounts are loaded into the
// Accounts object, but before this form is displayed on application startup.
procedure TAccountsForm.Initialize();
begin
  if Accounts.NumAccounts > 0 then
    EnableFields(True)
  else
    EnableFields(False);
end;

procedure TAccountsForm.CreateWnd;
begin
  inherited;
  DragAcceptFiles(Handle, True);
end;

procedure TAccountsForm.DestroyWnd;
begin
  DragAcceptFiles(Handle, False);
  inherited;
end;

procedure TAccountsForm.SaveAccountEdits(account : TAccount);
////////////////////////////////////////////////////////////////////////////////
// Save Account info from the edit account screen into the account object
// provided in the parameter.
begin
  // store account info in array
  account.Name := edName.Text;
  account.Server := edServer.Text;
  account.Port := StrToIntDef(edPort.Text,-1);
  account.Protocol := cmbProtocol.Text;
  account.UseSSLorTLS := chkSSL.Checked;
  account.SslVersion := TsslVer(cmbSslVer.ItemIndex);
  account.AuthType := GetAuthTypeFromComboValue(cmbAuthType);
  account.StartTLS := chkStartTLS.Checked;
  account.Login := edUsername.Text;
  account.Password := edPassword.Text;
  if edAccountProgram.Text = Translate(UseDefaultProgram) then
    account.MailProgram := ''
  else
    account.MailProgram := edAccountProgram.Text;
  if edSound.Text = Translate(UseDefaultSound) then
    account.Sound := ''
  else
    account.Sound := edSound.Text;
  account.Color := ColorToString2(colAccount.Selected);
  account.Enabled := chkAccEnabled.Checked;
  account.Interval := StrToFloatDef(edIntervalAccount.Text,5); //UpDownAccount.Position;
  account.DontCheckTimes := chkDontCheckTimes.Checked;
  account.DontCheckStart := dtStart.Time;
  account.DontCheckEnd := dtEnd.Time;
  account.Error := False;
  account.UIDLSupported := True;
  account.UseGmailExtensions := chkGmailExt.Checked;
  account.MoveSpamOnDelete := chkMoveSpam.Checked;
  account.MoveTrashOnDelete := chkMoveTrash.Checked;
  account.SpamFolderName := edSpamFolder.Text;
  account.TrashFolderName := edTrashFolder.Text;
  account.ArchiveFolderName := edArchiveFolder.Text;
  // objects
  if not Assigned(account.ViewedMsgIDs) then
    account.ViewedMsgIDs := TStringList.Create;
  if not Assigned(account.Mail) then
    account.Mail := TMailItems.Create;
  account.SetProtocol();
  // global
    FNewAccount := false;
  frmPopUMain.SwitchTimer;
end;

// called by uMain on startup/iniread to show the first account
procedure TAccountsForm.ShowDefaultAccount();
begin
  if (accounts.NumAccounts > 0) then
    ShowAccount(accounts[0]);
end;


procedure TAccountsForm.ShowAccount(account : TAccount);
////////////////////////////////////////////////////////////////////////////////
// Show the account info in the edit boxes
var
  idxAuto, idxPw, idxApop, idxSasl: integer;
begin
  if (account = nil) then begin
    EnableFields(false);
    Exit;
  end;

  // main params
  edName.Text := account.Name;
  edServer.Text := account.Server;
  edPort.Text := IntToStr(account.Port);
  cmbProtocol.ItemIndex := cmbProtocol.Items.IndexOf(account.Protocol);


  chkSSL.Checked := account.UseSSLorTLS;
  cmbSslVer.ItemIndex := Integer(account.SslVersion);
  chkStartTLS.Checked := account.StartTLS;

  // If the plugin does not support SSL, do not allow user to click on
  // options that require SSL encryption.
  if (account.Prot = nil) or (account.Prot.SupportsSSL = false)    //needs compiler setting {$B+} short cicuiting or will fail
  then begin
    EnableSSLOptions(false); //disable UI features for selecting SSL
  end
  else if (account.UseSSLorTLS = false) then
  begin
    cmbSslVer.Enabled := false;
    lblSslVer.Enabled := false;
  end;

  // reset items in auth types box per what the protocol supports
  cmbAuthType.Items.Clear;
  idxAuto := cmbAuthType.Items.AddObject(Translate('Auto'),TObject(autoAuth));
  idxPw := cmbAuthType.Items.AddObject(Translate('Password'),TObject(password));
  if (account.Prot <> nil) and (account.Prot.SupportsAPOP) then
    idxApop := cmbAuthType.Items.AddObject(Translate('APOP'),TObject(apop))
  else
    idxApop := -1;
  if (account.Prot <> nil) and (account.Prot.SupportsSSL and account.Prot.SupportsSASL) then
    idxSasl := cmbAuthType.Items.AddObject(Translate('SASL'),TObject(sasl))
  else
    idxSasl := -1;

  case account.AuthType of
    autoAuth: cmbAuthType.ItemIndex := idxAuto;
    password: cmbAuthType.ItemIndex := idxPw;
    apop:     if idxApop > -1 then cmbAuthType.ItemIndex := idxApop
              else cmbAuthType.ItemIndex := idxAuto;
    sasl:     if idxSasl > -1 then cmbAuthType.ItemIndex := idxSasl
              else cmbAuthType.ItemIndex := idxAuto;
    else      cmbAuthType.ItemIndex := idxAuto;
  end;

  edUsername.Text := account.Login;
  edPassword.Text := account.Password;
  // mail program
  if account.MailProgram <> '' then
  begin
    edAccountProgram.Text := account.MailProgram;
    edAccountProgram.Font.Color := clWindowText;
    GetBitmapFromFileIcon(edAccountProgram.Text,btnAccountProgramTest.Glyph,True);
  end
  else begin
    edAccountProgram.Text := Translate(UseDefaultProgram);
    edAccountProgram.Font.Color := clGrayText;
    btnAccountProgramTest.Glyph.Assign(frmPopUMain.btnStartProgram.Glyph);
  end;
  // sound
  if account.Sound <> '' then
  begin
    edSound.Text := account.Sound;
    edSound.Font.Color := clWindowText;
  end
  else begin
    edSound.Text := Translate(UseDefaultSound);
    edSound.Font.Color := clGrayText;
  end;
  colAccount.Selected := StringToColorDef(account.Color,clGray);
  chkAccEnabled.Checked := account.Enabled;
  edIntervalAccount.Text := FloatToStr(account.Interval);
  //  UpDownAccount.Position := round(account.Interval);
  chkDontCheckTimes.Checked := account.DontCheckTimes;
  dtStart.Time := account.DontCheckStart;
  dtEnd.Time := account.DontCheckEnd;
  // server/port disable
  if account.Port < 0 then
  begin
    edPort.Text := '';
    EnableControl(edPort,false);
    edServer.Text := '';
    EnableControl(edServer,false);
  end
  else begin
    EnableControl(edPort,true);
    EnableControl(edServer,true);
  end;

  edSpamFolder.Text := account.SpamFolderName;
  edTrashFolder.Text := account.TrashFolderName;
  edArchiveFolder.Text := account.ArchiveFolderName;
  chkMoveSpam.Checked := account.MoveSpamOnDelete;
  chkMoveTrash.Checked := account.MoveTrashOnDelete;
  chkGmailExt.Checked := account.UseGmailExtensions;
  ShowHideImapOptions();

  // buttons
  FAccChanged := False;
  btnSave.Enabled := False;
  btnCancelAccount.Enabled := False;



  btnAccountSoundTest.Glyph := nil;
  if (Options.ToolbarColorScheme = Integer(schemeTwilight)) then
    dm.imlLtDk16.GetBitmap(1, btnAccountSoundTest.Glyph)
  else
    dm.imlLtDk16.GetBitmap(0, btnAccountSoundTest.Glyph);

end;

procedure TAccountsForm.ShowHideImapOptions;
begin
  if (cmbProtocol.ItemIndex = 1 ) then   //0 = POP3, 1 = IMAP in dropdown
    catImap.Visible := true
  else
    catImap.Visible := false;
end;

function TAccountsForm.AccountChanged(tab: integer): boolean;
////////////////////////////////////////////////////////////////////////////////
// Check if any of the fields have changed since last save
var
  sound,mailprogram : string;
begin
  if edSound.Text = Translate(UseDefaultSound) then
    sound := ''
  else
    sound := edSound.Text;
  if edAccountProgram.Text = Translate(UseDefaultProgram) then
    mailprogram := ''
  else
    mailprogram := edAccountProgram.Text;
  if tab < 0 then
    Result := False
  else
    Result := (Accounts[tab].Name <> edName.Text) or
              (Accounts[tab].Server <> edServer.Text) or
              (Accounts[tab].Port <> StrToIntDef(edPort.Text,110)) or
              (Accounts[tab].Protocol <> cmbProtocol.Text) or
              (Accounts[tab].Login <> edUsername.Text) or
              (Accounts[tab].Password <> edPassword.Text) or
              (Accounts[tab].UseSSLorTLS <> chkSSL.Checked) or
              (Accounts[tab].AuthType <> GetAuthTypeFromComboValue(cmbAuthType)) or
              (Accounts[tab].SslVersion <> TsslVer(cmbSslVer.ItemIndex)) or
              (Accounts[tab].StartTLS <> chkStartTLS.Checked) or
              (Accounts[tab].Color <> ColorToString2(colAccount.Selected)) or
              (Accounts[tab].Enabled <> chkAccEnabled.Checked) or
              (Accounts[tab].Sound <> sound) or
              (Accounts[tab].MailProgram <> mailprogram) or
              (Accounts[tab].Interval <> StrToFloatDef(edIntervalAccount.Text,5)) or
              (Accounts[tab].DontCheckTimes <> chkDontCheckTimes.Checked) or
              (Accounts[tab].DontCheckStart <> dtStart.Time) or
              (Accounts[tab].DontCheckEnd <> dtEnd.Time) or
              (Accounts[tab].SpamFolderName <> edSpamFolder.Text) or
              (Accounts[tab].TrashFolderName <> edTrashFolder.Text) or
              (Accounts[tab].ArchiveFolderName <> edArchiveFolder.Text) or
              (Accounts[tab].MoveSpamOnDelete <> chkMoveSpam.Checked) or
              (Accounts[tab].MoveTrashOnDelete <> chkMoveTrash.Checked) or
              (Accounts[tab].UseGmailExtensions <> chkGmailExt.Checked);
end;

function TAccountsForm.GetAccountForTab(tabNumber : integer) : TAccount;
begin
  if (tabNumber<0) or (tabNumber>=Accounts.NumAccounts) then
    Result := nil
  else
    Result := accounts[tabNumber];

end;

procedure TAccountsForm.DeleteAccount(num: integer);
var
  i, dlgResult : integer;
  accountToDelete : TAccount;
  accountName: String;
  exportDlg : TExportAccountsDlg;
  Task : TSynTaskDialog;
begin
  if num > Accounts.Count then begin
    // if all is programmed well, this shouldn't happen
    assert(false);
    exit;
  end;
  accountToDelete := Accounts[num-1];
  accountName := accountToDelete.Name;
  if accountName = '' then accountName := Translate('<unnamed account>');

  Task.Caption := APPTITLE + ' - ' + Translate('Delete Account');
  Task.Title := SysUtils.Format(Translate('Backup "%s" Before Deleting?'), [accountName]);

  Task.AddButton( Translate('Backup and Delete'), //message result = 100
                  Translate('Backup file can be imported to undo'));

  Task.AddButton( Translate('Delete without Backup'), //message result = 101
                  Translate('Delete cannot be undone'));

  dlgResult := Task.Execute([cbCancel],mrCancel,[tdfUseCommandLinks],tiQuestion);

  if dlgResult = 100 then dlgResult := mrYes else if dlgResult = 101 then dlgResult := mrNo else dlgResult := mrCancel;


//  msgBox := CreateMessageDialog(SysUtils.Format(uTranslate.Translate('You have selected to delete account %s.'), [accountName]) +#13+#10+
//                                uTranslate.Translate('Would you like to backup this account before deleting?'),
//                                mtConfirmation, mbYesNoCancel);
//
//  with msgBox do
//  try
//    Caption := uTranslate.Translate('Delete Account:') + ' ' + accountName;
//    TButton(FindComponent('Yes')).Caption := uTranslate.Translate('Yes');
//    TButton(FindComponent('No')).Caption := uTranslate.Translate('No');
//    TButton(FindComponent('Cancel')).Caption := uTranslate.Translate('Cancel');
//    dlgResult := msgBox.ShowModal;
//  finally
//    msgBox.Free
//  end;

  if dlgResult = mrCancel then Exit;

  // if user selected to create a backup before deleting account, create the backup.
  if dlgResult = mrYes then
  begin
    exportDlg := TExportAccountsDlg.Create(self);
    try
      dlgResult := exportDlg.ExportSingleAccount(accountToDelete);
      if dlgResult = mrCancel then begin
           Task.Caption := APPTITLE + ' - ' + Translate('Delete Account');
  Task.Title := Translate('Account Backup Canceled');
  Task.Text := SysUtils.Format(Translate('%s will not be backed up before deleting'), [accountName]);
  Task.Buttons := Translate('Delete without Backup')+'\n'+ //message result = 101
                  Translate('Delete cannot be undone')
                  +sLineBreak+
                  Translate('Cancel')+'\n'+ //message result = 101
                  Translate('Keep this account');
  dlgResult := Task.Execute([cbCancel],mrCancel,[tdfUseCommandLinks],tiQuestion);
  if (dlgResult = mrCancel) or (dlgResult = 101) then Exit;





//        dlgTitle := uTranslate.Translate('Delete Account:') + ' ' + accountName;
//        dlgResult := ShowTranslatedDlg(Translate('Account backup canceled.')+#13#10+
//          Translate('Do you want to delete this account anyway?'), mtConfirmation,
//          [mbYes, mbNo], 0, dlgTitle);
//        if dlgResult = mrNo then Exit;
      end;
    finally
      exportDlg.Free;
    end;
  end;



  // stop timer

  if Assigned(accountToDelete) then
     FreeAndNil(accountToDelete.Timer);
  // remove from array
  Accounts.Delete(num-1);
  //Dec(NumAccounts);
  // tab
  frmPopUMain.tabMail.Tabs.Delete(num-1);
  tabAccounts.Tabs.Delete(num-1);
  // remove from INI
  for i := 1 to Accounts.NumAccounts do
    SaveAccountINI(i);

  // remap rules to not include the deleted account
  RulesManager.RemoveAccount(num);

  // show mail
  if Accounts.NumAccounts>0 then
  begin
    //frmPopUMain.tabMail.TabIndex := 0;
    //tabAccounts.TabIndex := 0;
    if (num) >= (Accounts.numAccounts) then begin
      frmPopUMain.tabMail.TabIndex := num-2;
      tabAccounts.TabIndex := num-2;
    end else begin
      frmPopUMain.tabMail.TabIndex := num-1;
      tabAccounts.TabIndex := num-1;
    end;
    ShowAccount(GetAccountForTab(tabAccounts.TabIndex));
    frmPopUMain.ShowMail(Accounts[frmPopUMain.tabMail.TabIndex],True);
  end
  else begin
    // we now have no accounts left.
    EnableFields(false);

    // this is a workaround, before it wasn't fixing the size of these
    // items if there's no accounts yet.
    AutoSizeCheckBox(chkDontCheckTimes);
    dtStart.Left := chkDontCheckTimes.Left + chkDontCheckTimes.Width + 4;
    lblAnd.Left := dtStart.Left + dtStart.Width + 6;
    dtEnd.Left := lblAnd.Left + lblAnd.Width + 8;
  end;
end;


// When using standard port numbers, this method will make sure the port numbers
// toggle to the right choices based on the protocol and use ssl state selected.
procedure TAccountsForm.setPortOnAccountTab();
begin
  if (chkSSL.Checked) then
  begin
    // STARTTLS encryption mode should use the "insecure" port numbers to start
    // the connection. Otherwise, use the secure port numbers.
    if (edPort.Text = '110') and (chkStartTLS.Checked = false) then //POP3
      edPort.Text := '995'
    else if (edPort.Text = '143') and (chkStartTLS.Checked = false) then //IMAP
      edPort.Text := '993'
    else if (edPort.Text = '995') and (chkStartTLS.Checked = true)  then //POP3 starttls
      edPort.Text := '110'
    else if (edPort.Text = '993') and (chkStartTLS.Checked = true) then //IMAP starttls
      edPort.Text := '143';
  end
  else begin
    // Use SSL/TLS not checked, use insecure port numbers, do not use STARTTLS
    if (edPort.Text = '995') then
      edPort.Text := '110' //Pop3 not SSL
    else if (edPort.Text = '993') then
      edPort.Text := '143'; //IMAP not SSL
  end;
end;


function TAccountsForm.GetAuthTypeFromComboValue(comboBox : TComboBox) : TAuthType;
begin
  if (comboBox.ItemIndex >= 0) then
    Result := TAuthType(comboBox.Items.Objects[comboBox.ItemIndex])
  else
    Result := autoAuth;

end;


procedure TAccountsForm.btnNeverAccountClick(Sender: TObject);
begin
  UpDownAccount.Position := 0;
end;


{ OnClick handler for SSL/TLS enabled checkbox on Accounts setup tab }
procedure TAccountsForm.chkSSLClick(Sender: TObject);
begin
  // Swap the port numbers (if using standard port numbers)
  setPortOnAccountTab();

  if (chkSSL.Checked) then
  begin
    // enable advanced options on GUI that only apply to SSL connections
    lblSslVer.Enabled := true;
    cmbSslVer.Enabled := true;
    chkStartTLS.Enabled := true;
  end
  else begin
    // Uncheck use STARTTLS if it was previously selected
    chkStartTLS.Checked := false;

    // disable advanced options on GUI that only apply to SSL connections
    lblSslVer.Enabled := false;
    cmbSslVer.Enabled := false;
    chkStartTLS.Enabled := false;
  end;


  // Update GUI to enable save button
  FAccChanged := AccountChanged(tabAccounts.TabIndex) or FNewAccount;
  btnSave.Enabled := FAccChanged;
  btnCancelAccount.Enabled := FAccChanged;
end;

procedure TAccountsForm.EnableSSLOptions(enable : boolean);
begin
    chkSSL.Enabled := enable;
    cmbSslVer.Enabled := enable;
    lblSslVer.Enabled := enable;
    //cmbAuthType.Items.Delete(Integer(sasl)); // no option to disable, so hide
    chkStartTLS.Enabled := enable;
end;

procedure TAccountsForm.cmbProtocolChange(Sender: TObject);
begin
  if length(Protocols)-1 < cmbProtocol.ItemIndex then Exit;
  // port
  if Protocols[cmbProtocol.ItemIndex].Port < 0 then
  begin
    edPort.Text := '';
    EnableControl(edPort,false);
    edServer.Text := '';
    EnableControl(edServer,false);
  end
  else begin
    EnableControl(edPort,true);
    EnableControl(edServer,true);
    edPort.Text := IntToStr(Protocols[cmbProtocol.ItemIndex].Port);
    Accounts[tabAccounts.TabIndex].Protocol := Protocols[cmbProtocol.ItemIndex].Name;
    Accounts[tabAccounts.TabIndex].SetProtocol;

    if (Accounts[tabAccounts.TabIndex].Prot <> nil) and (Accounts[tabAccounts.TabIndex].Prot.SupportsSSL = true) then begin
      EnableSSLOptions(true);
    end else begin
      EnableSSLOptions(false);
    end;
  end;

  // To make sure the port number reflects whether "Use SSL" is checked or not
  // (needs to be after the Protocols[i].Port calls above)
  setPortOnAccountTab();

  showHideImapOptions();

  // buttons
  FAccChanged := AccountChanged(tabAccounts.TabIndex) or FNewAccount;
  btnSave.Enabled := FAccChanged;
  btnCancelAccount.Enabled := FAccChanged;
end;

procedure TAccountsForm.colAccountGetColors(Sender: TCustomColorBox;
  Items: TStrings);
var
  i: integer;
begin
  for i := 0 to Items.Count - 1 do begin
    Items.Strings[i] := Translate(Items.Strings[i]);
  end;
end;

procedure TAccountsForm.DragMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (Screen.Cursor <> crHourGlass) and
    (GetKeyState(VK_LBUTTON) < 0) then
  begin
    //listRules.ItemIndex := listRules.ItemAtPos(Point(X,Y),True);
    (Sender as TControl).BeginDrag(False,12);
  end;
end;

procedure TAccountsForm.edAccountProgramEnter(Sender: TObject);
begin
  if edAccountProgram.Text = Translate(UseDefaultProgram) then
  begin
    edAccountProgram.Text := '';
    edAccountProgram.Font.Color := clWindowText;
  end;
end;



procedure TAccountsForm.edAccountProgramExit(Sender: TObject);
begin
  if edAccountProgram.Text = '' then
  begin
    edAccountProgram.Text := Translate(UseDefaultProgram);
    edAccountProgram.Font.Color := clGrayText;
  end;
end;

procedure TAccountsForm.edSoundEnter(Sender: TObject);
begin
  if edSound.Text = Translate(UseDefaultSound) then
  begin
    edSound.Text := '';
    edSound.Font.Color := clWindowText;
  end;
end;

procedure TAccountsForm.edSoundExit(Sender: TObject);
begin
  if edSound.Text = '' then
  begin
    edSound.Text := Translate(UseDefaultSound);
    edSound.Font.Color := clGrayText;
  end;
end;


procedure TAccountsForm.edAccChange(Sender: TObject);
begin
  FAccChanged := AccountChanged(tabAccounts.TabIndex) or FNewAccount;
  btnSave.Enabled := FAccChanged;
  btnCancelAccount.Enabled := FAccChanged;
end;

// Deletes/reverts the account if it's new.
// @return - whether the account was reverted
procedure TAccountsForm.RevertAccountChanges();
begin
  FAccChanged := False;
  if FNewAccount then begin
    Accounts.Delete(tabAccounts.TabIndex);
    frmPopUMain.tabMail.Tabs.Delete(tabAccounts.TabIndex);
    tabAccounts.Tabs.Delete(tabAccounts.TabIndex);
    FNewAccount := False;

    // Change tab to select the previous account (if any)
    tabAccounts.TabIndex := tabAccounts.Tabs.Count-1; // When count is 0, TabIndex=-1 is valid and means "no selected tab"
  end;

  btnSave.Enabled := False;
  btnCancelAccount.Enabled := False;

  if Accounts.NumAccounts=0 then
    EnableFields(False);
end;

procedure TAccountsForm.btnCancelAccountClick(Sender: TObject);
var
  reloadAccount : boolean;
begin
  reloadAccount := NOT FNewAccount;
  RevertAccountChanges();
  if reloadAccount then
    LoadAccountINI(tabAccounts.TabIndex+1);
  ShowAccount(GetAccountForTab(tabAccounts.TabIndex));
end;


procedure TAccountsForm.chkDontCheckTimesClick(Sender: TObject);
begin
  dtStart.Enabled := chkDontCheckTimes.Checked;
  dtEnd.Enabled := chkDontCheckTimes.Checked;
  lblAnd.Enabled := chkDontCheckTimes.Checked;

  edAccChange(Sender);
end;


procedure TAccountsForm.chkMoveSpamClick(Sender: TObject);
begin
  lblSpamFolder.Enabled := chkMoveSpam.Checked;
  edSpamFolder.Enabled := chkMoveSpam.Checked;
  btnSpamFolder.Enabled := chkMoveSpam.Checked;

  edAccChange(Sender);
end;

procedure TAccountsForm.chkMoveTrashClick(Sender: TObject);
begin
  lblTrashFolder.Enabled := chkMoveTrash.Checked;
  edTrashFolder.Enabled := chkMoveTrash.Checked;
  btnTrashFolder.Enabled := chkMoveTrash.Checked;

  edAccChange(Sender);
end;

procedure TAccountsForm.btnEdAccountProgramClick(Sender: TObject);
var
  dlgOpen : TOpenDialog;
begin
  dlgOpen := TOpenDialog.Create(nil);
  try
    dlgOpen.InitialDir := ExtractFileDir(edAccountProgram.Text);
    dlgOpen.Filter := Translate('EXE files')+' (*.exe)|*.EXE|' +
                      Translate('All files')+' (*.*)|*.*';
    if dlgOpen.Execute then
    begin
      edAccountProgram.Text := dlgOpen.FileName;
      GetBitmapFromFileIcon(edAccountProgram.Text,btnAccountProgramTest.Glyph,True);
    end;
  finally
    dlgOpen.Free;
  end;
end;

procedure TAccountsForm.btnHelpAccountsClick(Sender: TObject);
begin
  HtmlHelp(0, HelpFileName+'::/accounts.htm', HH_DISPLAY_TOPIC, 0);
end;

procedure TAccountsForm.btnAccountProgramTestClick(Sender: TObject);
begin
  frmPopUMain.ExecuteProgram(Accounts.Items[tabAccounts.TabIndex]);//TODO: tabToAccount
end;


procedure TAccountsForm.btnAccountSoundTestClick(Sender: TObject);
begin
  if (edSound.Text = Translate(UseDefaultSound)) or (edSound.Text = '') then
    PlayWav(Options.DefSound)
  else
    PlayWav(edSound.Text);
end;


procedure TAccountsForm.tabAccountsChange(Sender: TObject);
begin
  ShowAccount(GetAccountForTab(tabAccounts.TabIndex));
  actDeleteAccount.Enabled := True;
end;

// Prompts the user whether they'd like to save unsaved changes to the current
// account.
// @return - mrYes, mrNo, mrCancel
function TAccountsForm.ShowSaveAccountDlg(dlgTitle : string) : integer;
var
  msgBox : TForm;
begin
  msgBox := CreateMessageDialog(uTranslate.Translate('You have unsaved changes to this account.')+#13+#10+
                                uTranslate.Translate('Would you like to save now?'),
                                mtConfirmation, mbYesNoCancel);
  with msgBox do
  try
    Caption := dlgTitle;
    TButton(FindComponent('Yes')).Caption := uTranslate.Translate('Save');
    TButton(FindComponent('No')).Caption := uTranslate.Translate('Revert');
    TButton(FindComponent('Cancel')).Caption := uTranslate.Translate('Cancel');
    Result := msgBox.ShowModal;
  finally
    msgBox.Free
  end;
end;

procedure TAccountsForm.tabAccountsChanging(Sender: TObject; var AllowChange: Boolean);
begin
  if FAccChanged or FNewAccount then begin
    case ShowSaveAccountDlg(uTranslate.Translate('Select Account')) of
      mrYes: begin
        btnSave.Click;
        AllowChange := True;
      end;
      mrNo: begin
        RevertAccountChanges();
        AllowChange := True;
      end;
      mrCancel: begin
        AllowChange := False;
      end;
    end;
  end;
end;

procedure TAccountsForm.tabAccountsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Sender = Source);
end;

procedure TAccountsForm.tabDragDrop(Sender, Source: TObject; X,  Y: Integer);
begin
  frmPopUMain.tabDragDrop(Sender, Source, X, Y);
end;

procedure TAccountsForm.ValueListEditor2StringsChange(Sender: TObject);
begin

end;

//TOdo: some of these are not needed??
// TODO: only fill dropdown if acct is new or name changed
procedure TAccountsForm.btnSaveAccountClick(Sender: TObject);
begin

  SaveAccountEdits(Accounts[tabAccounts.TabIndex]);
  SaveAccountINI(tabAccounts.TabIndex+1);
  frmPopUMain.RulesForm.AccountsChanged();
  frmPopUMain.ShowIcon(Accounts[frmPopUMain.tabMail.TabIndex],itNormal);
  frmPopUMain.ShowIcon(Accounts[tabAccounts.TabIndex],itNormal);
  FAccChanged := False;
  btnSave.Enabled := False;
  btnCancelAccount.Enabled := False;
end;

// for the three pick folder ... buttons.
procedure TAccountsForm.btnPickFolderClick(Sender: TObject);
var
  num : integer;
  account : TAccount;
  pickFolderDlg : TImapFolderSelectDlg;
  pickedFolder : string;
begin
  try
    num := tabAccounts.TabIndex+1;
    if num <= 0 then Exit;

    account := Accounts[num-1];
    if (account = nil) or (account.IsImap = false) then Exit;

    SaveAccountEdits(Accounts[num-1]);

    pickFolderDlg := TImapFolderSelectDlg.Create(self);
    try
      pickedFolder := pickFolderDlg.ShowSelectImapFolder(account);
      if (pickedFolder <> '') then begin
        if (Sender = btnSpamFolder) then
          edSpamFolder.Text := pickedFolder
        else if (Sender = btnTrashFolder) then
          edTrashFolder.Text := pickedFolder
        else if (Sender = btnArchiveFolder) then
          edArchiveFolder.Text := pickedFolder;

        FAccChanged := true;
        btnSave.Enabled := true;
        btnCancelAccount.Enabled := true;
      end;
    finally
      pickFolderDlg.Free;
    end;


  finally
    //Screen.Cursor := crDefault;
    //actTestAccount.Enabled := true;
  end;
end;

procedure TAccountsForm.actAddAccountExecute(Sender: TObject);
var
  DefaultAccountName : string;
begin
  // check if saved
  if (FAccChanged or FNewAccount) and (Accounts.Count > 0) then
  begin
    case ShowSaveAccountDlg(uTranslate.Translate('Add Account')) of
      mrYes    : btnSave.Click;
      mrNo     : ;// nothing
      mrCancel : Exit;
    end;
  end;
  // add account
  Accounts.Add;
  //Inc(NumAccounts);
  FNewAccount := True;
  btnSave.Enabled := True;
  btnCancelAccount.Enabled := True;
  // add tab
  DefaultAccountName := Translate('Account')+' '+IntToStr(Accounts.Count);
  tabAccounts.Tabs.Add(DefaultAccountName);
  tabAccounts.TabIndex := Accounts.NumAccounts-1;
  frmPopUMain.tabMail.Tabs.Add(DefaultAccountName);
  dm.AddBitmap(dm.imlTabs, dm.imlPopTrueColor,popClosed);
  // enable fields
  EnableFields(True);
  chkAccEnabled.Checked := True;
  // clear the fields
  edName.Text := DefaultAccountName;
  edServer.Text := '';
  cmbProtocol.ItemIndex := 0;
  edPort.Text := '110';
  chkSSL.Checked := false;
  edUsername.Text := '';
  edPassword.Text := '';
  edAccountProgram.Text := Translate(UseDefaultProgram);
  edAccountProgram.Font.Color := clGrayText;
  edSound.Text := Translate(UseDefaultSound);
  edSound.Font.Color := clGrayText;
  colAccount.Selected := clRed;
  dtStart.Time := TAccount.GetDefaultDontCheckStartTime();
  dtEnd.Time := TAccount.GetDefaultDontCheckEndTime();
  edName.SetFocus;
  // clear mail
  frmPopUMain.lvMail.Items.Clear;
end;

procedure TAccountsForm.actDeleteAccountExecute(Sender: TObject);
var
  accountName : String;
 // dlgTitle : String;
  dlgResult : integer;
begin
  if FNewAccount then
  begin
    if edName.Text = '' then accountName := Translate('<unnamed account>')
    else accountName := edName.Text;

    //dlgTitle := SysUtils.Format(Translate('Delete Account: %s'), [accountName]);
    dlgResult := ShowVistaConfirmDialog(Translate('Delete Account'),
      SysUtils.Format(Translate('Delete "%s"'), [accountName]),
      SysUtils.Format(Translate('Are you sure you want to delete this account?'), [accountName]),
      Translate('Delete Account'),Translate('Keep Account'));
//    dlgResult := ShowCustomOkCancelDialog(dlgTitle,
//      SysUtils.Format(Translate('Are you sure you want to delete account "%s"?'), [accountName]), mtConfirmation,
//      0, Translate('Delete'),Translate('Keep Account'));
    if dlgResult = mrYes then begin
      RevertAccountChanges();
      ShowAccount(GetAccountForTab(tabAccounts.TabIndex));
    end;
  end
  else if tabAccounts.TabIndex >= 0 then //TODO: TabToAccount
    DeleteAccount(tabAccounts.TabIndex+1);
end;


procedure TAccountsForm.actExportExecute(Sender: TObject);
var
  exportDlg : TExportAccountsDlg;
begin
  if FAccChanged or FNewAccount then begin
    if ShowSaveAccountDlg('Backup/Export Accounts') = mrCancel then
      Exit;
  end;

  exportDlg := TExportAccountsDlg.Create(self);
  try
    exportDlg.ShowModal;
  finally
    exportDlg.Free;
  end;
end;

procedure TAccountsForm.actImportExecute(Sender: TObject);
var
  importDlg : TImportAcctDlg;
  numAddedAccts : integer;
  i : integer;
  accName : string;
  accNum : integer;
begin
  if FAccChanged or FNewAccount then begin
    if ShowSaveAccountDlg('Import/Restore Accounts') = mrCancel then
      Exit;
  end;

  importDlg := TImportAcctDlg.Create(self);
  try
    numAddedAccts := importDlg.ImportAccounts(Accounts);
    if (numAddedAccts > 0) then
    begin
        //FNewAccount := True;   --this will screw up deleting accounts later
        FAccChanged := True;
        btnSave.Enabled := True;
        btnCancelAccount.Enabled := True;

        for i := 0 to numAddedAccts - 1 do
        begin
          accNum := Accounts.NumAccounts - numAddedAccts + i; //zero based
          accName := Accounts[accNum].Name;
          tabAccounts.Tabs.Add(accName);
          frmPopUMain.tabMail.Tabs.Add(accName);
          dm.AddBitmap(dm.imlTabs, dm.imlPopTrueColor,popClosed); //adds to end of list
          SaveAccountINI(accNum + 1);  //one based
        end;

        // set current tab
        tabAccounts.TabIndex := Accounts.NumAccounts-numAddedAccts;
//        EnableFields(True);
//        chkAccEnabled.Checked := True;
        frmPopUMain.lvMail.Items.Clear; //clear mail list
        ShowAccount( Accounts[Accounts.NumAccounts - numAddedAccts] );

        //FNewAccount := True;
        //btnSave.Enabled := True;
        //btnCancelAccount.Enabled := True;


        //frmPopUMain.RulesForm.AccountsChanged();
        //frmPopUMain.ShowIcon(Accounts[Accounts.NumAccounts - numAddedAccts],itNormal);
        //frmPopUMain.ShowIcon(Accounts[Accounts.NumAccounts - numAddedAccts],itNormal);
        FAccChanged := False;
        btnSave.Enabled := False;
        btnCancelAccount.Enabled := False;
    end;
  finally
    importDlg.Free;
  end;
end;

procedure TAccountsForm.actTestAccountExecute(Sender: TObject);
var
  num : integer;
begin
  actTestAccount.Enabled := false; // disable test account button until account test is done.
  Screen.Cursor := crAppStart; //Pointer with background hourglass
  try
    num := tabAccounts.TabIndex+1;
    if num<=0 then Exit;
    SaveAccountEdits(Accounts[num-1]);
    Accounts[num-1].TestAccount();
  finally
    Screen.Cursor := crDefault;
    actTestAccount.Enabled := true;
  end;
end;


procedure TAccountsForm.RefreshProtocols;
begin
  cmbProtocol.Items.Text := Translate('POP3');
  cmbProtocol.Items.Add(Translate('IMAP4'));
end;


// Enable / Disable the fields. Fields shouldd be disabled when there are no
// accounts and enabled otherwise.
procedure TAccountsForm.EnableFields(EnableIt: Boolean);
var
  i,j : integer;
  surface: TCategoryPanelSurface;
  panel : TCategoryPanel;
begin

  for i := 0 to panelGrp1.Panels.Count - 1 do begin
    panel := panelGrp1.Panels[i];
    surface := (panel.Controls[0] as TCategoryPanelSurface);
    for j := 0 to surface.ControlCount - 1 do begin
      (surface.Controls[j]).Enabled := EnableIt;

      // set background color on Edit boxes (gray for disabled, white for enabled)
      if (surface.Controls[j] is TEdit) or
         (surface.Controls[j] is TColorBox) or
         (surface.Controls[j] is TComboBox) or
         (surface.Controls[j] is TDateTimePicker) then
      begin
        if surface.Controls[j].Enabled then
          SetPropValue(surface.Controls[j],'Color',clWindow)
        else
          SetPropValue(surface.Controls[j],'Color',clBtnFace);
      end;
    end;
  end;


  edSpamFolder.Enabled := EnableIt AND chkMoveSpam.Checked;
  btnSpamFolder.Enabled := EnableIt AND chkMoveSpam.Checked;

  edTrashFolder.Enabled := EnableIt AND chkMoveSpam.Checked;
  btnTrashFolder.Enabled := EnableIt AND chkMoveTrash.Checked;

  //edArchiveFolder.Enabled := EnableIt;
  //btnArchiveFolder.Enabled := EnableIt;

  lblSpamFolder.Enabled := EnableIt AND chkMoveSpam.Checked;
  edSpamFolder.Enabled := EnableIt AND chkMoveSpam.Checked;
  btnSpamFolder.Enabled := EnableIt AND chkMoveSpam.Checked;

  lblAnd.Enabled := dtStart.Enabled;

  actDeleteAccount.Enabled := EnableIt;
  actTestAccount.Enabled := EnableIt;
  actExport.Enabled := EnableIt;
end;

procedure TAccountsForm.FormCreate(Sender: TObject);
begin
  Inherited;

  // accept files to drop on me
  DragAcceptFiles(Self.Handle, True);  // TODO: what does this enable us to do? is it for tab drag/drop?

  cmbProtocol.Items.Text := Translate('POP3');
  cmbProtocol.Items.Add(Translate('IMAP4'));

  dtStart.DateTime := 0;
  dtEnd.DateTime := 0;
end;

procedure TAccountsForm.OnSetLanguage();
begin
  FormResize(self);
end;


procedure TAccountsForm.UpdateFonts();
var
 oldColor : TColor;
begin
  AccountsToolbar.Font := Options.GlobalFont;
  panelGrp1.HeaderFont.Assign(Options.GlobalFont);
  panelGrp1.HeaderFont.Style := panelGrp1.HeaderFont.Style + [fsBold];
  panelGrp1.HeaderFont.Size := Options.GlobalFont.Size;

  oldColor := edAccountProgram.Font.Color;
  edAccountProgram.Font.Assign(Options.GlobalFont);
  edAccountProgram.Font.Color := oldColor;

  oldColor := edSound.Font.Color;
  edSound.Font.Assign(Options.GlobalFont);
  edSound.Font.Color := oldColor;

  FormResize(self);
end;


procedure TAccountsForm.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Self.Handle, False);

  Inherited;
end;


procedure TAccountsForm.FormResize(Sender: TObject);
var
  textBoxesLeft : integer;
  textBoxesRight : integer;
begin

  // -- PopTrayU prefs panel --

  textBoxesLeft := lblAccountSound.Left + Math.Max(lblAccountSound.Width, lblEmailApp.Width) + edSound.Margins.Left + edSound.Margins.Right;

  edSound.Width := (edSound.Left + edSound.Width) - textBoxesLeft; // new width = right pos - new left
  edSound.Left := textBoxesLeft;
  edAccountProgram.Left := textBoxesLeft;
  edAccountProgram.Width := edSound.Width;
  btnAccountProgramTest.Height := edSound.Height;
  btnEdAccountProgram.Height := edSound.Height;

  edSound.Top := calcPosBelow(edAccountProgram);
  edSound.Height := edAccountProgram.Height;
  lblAccountSound.Top := edSound.Top + 3;
  btnAccountSoundTest.Top := edSound.Top;
  btnAccountSoundTest.Height := edSound.Height;
  btnEdSound.Top := edSound.Top;
  btnEdSound.Height := edSound.Height;

  panIntervalAccount.Top := edSound.Top + edSound.Height + 3;
  edIntervalAccount.Left := CalcPosToRightOf(lblCheckEvery);
  UpDownAccount.Left := edIntervalAccount.Left + edIntervalAccount.Width; //no margin between
  UpDownAccount.Height := edIntervalAccount.Height;
  lblCheckMins.Left := CalcPosToRightOf(UpDownAccount);
  btnNeverAccount.Left := CalcPosToRightOf(lblCheckMins);
  btnNeverAccount.Height := edSound.Height;
  lblTest.Caption := btnNeverAccount.Caption;
  btnNeverAccount.ClientWidth := lblTest.Width + 20;
  panIntervalAccount.Height := edIntervalAccount.Height + 4;

  if (panIntervalAccount.Visible) then
    panNoCheckHours.Top := panIntervalAccount.Top + panIntervalAccount.Height + 3
  else
    panNoCheckHours.Top := edSound.Top + edSound.Height + 3;
  AutoSizeCheckBox(chkDontCheckTimes);
  chkDontCheckTimes.Height := lblAnd.Height;
  dtStart.Left := chkDontCheckTimes.Left + chkDontCheckTimes.Width + 4;
  dtStart.ClientWidth := self.Canvas.TextWidth('28:88am')+30;
  lblAnd.Left := dtStart.Left + dtStart.Width + 6;
  dtEnd.Left := lblAnd.Left + lblAnd.Width + 8;
  dtEnd.ClientWidth := self.Canvas.TextWidth('28:88am')+30;
  panNoCheckHours.Height := dtStart.Top + dtStart.Height + 3;

  catPopTrayAccountPrefs.ClientHeight := panNoCheckHours.Top + panNoCheckHours.Height + 3;

  // -- Advanced Account Settings Panel --

  AutosizeCombobox( cmbAuthType );
  AutosizeCombobox( cmbSslVer );

  // left column
  textBoxesLeft := 8 + Math.Max(lblAuthMode.Width, lblStartls.Width) + 3;
  lblAuthMode.Left := textBoxesLeft - lblAuthMode.Width - 3;
  lblStartls.Left := textBoxesLeft - lblStartls.Width - 3;
  lblStartls.Top := calcPosBelow(cmbAuthType) + 3;

  cmbAuthType.Left := textBoxesLeft;
  chkStartTLS.Left := textBoxesLeft;
  chkStartTLS.Top := calcPosBelow(cmbAuthType);
  chkStartTLS.Height := cmbAuthType.Height;

  lblTest.Caption := cmbAuthType.Items[0]; //todo this should be widest of all of them
  //cmbAuthType.ClientWidth := lblTest.Width + 10;

  lblTest.Caption := cmbSslVer.Items[0]; //todo this should be widest of all of them
  //cmbSslVer.ClientWidth := lblTest.Width + 10;

  // right column
  lblSslVer.Left := CalcPosToRightOf(cmbAuthType) + 8;
  cmbSslVer.Left := CalcPosToRightOf(lblSslVer);

  catAdvAcc.ClientHeight := chkStartTLS.Top + chkStartTLS.Height + 3;
  catAdvAcc.Realign;

  // -- Basic Account Settings Panel --

  textBoxesLeft := 8 + Math.Max(lblServer.Width, Math.Max(lblUsername.Width, lblPw.Width)) + 3;

  // right aligned to 3px to the left of textBoxesLeft - labels for left column
  lblServer.Left := textBoxesLeft - lblServer.Width - 3;
  lblUsername.Left := textBoxesLeft - lblUsername.Width - 3;
  lblPw.Left := textBoxesLeft - lblPw.Width - 3;

  //left aligned to textBoxesLeft - edit boxes for left column
  edServer.Left := textBoxesLeft;
  edUsername.Left := textBoxesLeft;
  edPassword.Left := textBoxesLeft;

  // Text lablels 3px below top of edit boxes to account for edit box trim
  // height of rows based on height of edit box
  lblServer.Top := edServer.Top + 3;
  edUsername.Top := calcPosBelow(edServer);
  lblUsername.Top := edUsername.Top + 3;
  edPassword.Top := calcPosBelow(edUsername);
  lblPw.Top := edPassword.Top + 3;

  // right column
  cmbProtocol.Top := edServer.Top;
  chkSSL.Left := cmbProtocol.Left;
  edPort.Left := cmbProtocol.Left;
  edPort.Top := edPassword.Top;
  chkSSL.Top := edUsername.Top;
  chkSSL.Height := edUsername.Height;

  // labels for right column
  lblProt.Top := lblServer.Top;
  lblProt.Left := cmbProtocol.Left - lblProt.Width - 3;
  lblUseSsl.Top := lblUsername.Top;
  lblUseSsl.Left :=  cmbProtocol.Left - lblUseSsl.Width - 3;
  lblPort.Top := lblPw.Top;
  lblPort.Left :=  cmbProtocol.Left - lblPort.Width - 3;

  // make left column text boxes "fill" available space
  textBoxesRight := cmbProtocol.Left - 8 - Math.Max(lblProt.Width, Math.Max(lblUseSsl.Width, lblProt.Width)) - 8;
  edServer.Width := textBoxesRight - edServer.Left;
  edUsername.Width := edServer.Width;
  edPassword.Width := edUsername.Width;

  // height of panel
  catBasicAccount.ClientHeight := edPassword.Top + edPassword.Height + 9;

  // TODO: later: make this more robust by swtiching to a one column layout
  // if the width of edit boxes is negative or window width below some min

  // -- Display Options Panel --
  catAccName.Realign;

  lblName.Left := 8;
  edName.Left := CalcPosToRightOf(lblName);
  lblColor.Left := CalcPosToRightOf(edName) + 8;
  colAccount.Left := CalcPosToRightOf(lblColor);
  colAccount.Height := edName.Height;
  colAccount.ClientHeight := edName.Height;

  //colAccount.ScaleBy(edName.Height,colAccount.Height);

  catAccName.ClientHeight := edName.Top + edName.Height + 4;
  catAccName.Realign;
  //chkAccEnabled.Realign;
  chkAccEnabled.Top := edName.Top;
  chkAccEnabled.Height := edName.Height;
  chkAccEnabled.Left := catAccName.Width - 26;

  lblEnableAccount.Alignment := taRightJustify;
  lblEnableAccount.Top := lblName.Top;
  lblEnableAccount.Left := catAccName.Width - lblEnableAccount.Width - 26;//chkAccEnabled.Left - lblEnableAccount.Width - 4; //this shouldn't even be needed

  // ------
  catImap.Realign;

  chkMoveSpam.Height := lblSpamFolder.Height;
  chkMoveTrash.Height := lblSpamFolder.Height;
  chkGmailExt.Height := lblSpamFolder.Height;

  chkMoveSpam.Top := calcPosBelow(chkGmailExt);
  edSpamFolder.Top := calcPosBelow(chkMoveSpam);
  lblSpamFolder.Top := edSpamFolder.Top+3;
  btnSpamFolder.Top := edSpamFolder.Top;
  chkMoveTrash.Top := calcPosBelow(edSpamFolder);
  edTrashFolder.Top := calcPosBelow(chkMoveTrash);
  lblTrashFolder.Top := edTrashFolder.Top + 3;
  btnTrashFolder.Top := edTrashFolder.Top;
  edArchiveFolder.Top := calcPosBelow(edTrashFolder);
  lblArchiveFolder.Top := edArchiveFolder.Top + 3;
  btnArchiveFolder.Top := edArchiveFolder.Top;

  catImap.ClientHeight := lblArchiveFolder.Top + lblArchiveFolder.Height + 4;

  edSpamFolder.Left := CalcPosToRightOf(lblSpamFolder);
  edTrashFolder.Left := CalcPosToRightOf(lblTrashFolder);
  edArchiveFolder.Left := CalcPosToRightOf(lblArchiveFolder);
  btnSpamFolder.Left := CalcPosToRightOf(edSpamFolder);
  btnTrashFolder.Left := CalcPosToRightOf(edTrashFolder);
  btnArchiveFolder.Left := CalcPosToRightOf(edArchiveFolder);

  btnTrashFolder.Height := edTrashFolder.Height;
  btnSpamFolder.Height := edSpamFolder.Height;
  btnArchiveFolder.Height := edArchiveFolder.Height;

  // basic account settings panel
  catPopTrayAccountPrefs.Realign;
  catBasicAccount.Realign;

  lblTest.Caption := btnCancelAccount.Caption;

  btnCancelAccount.ClientWidth := Math.Max(lblTest.Width, 90) + 10 + 16;
  btnCancelAccount.Left := panAccountsButtons.Width - btnCancelAccount.Width - 6;
  btnCancelAccount.ClientHeight := Math.Max(lblTest.Height, 25);

  lblTest.Caption := btnSave.Caption;
  btnSave.ClientWidth := Math.Max(lblTest.Width, 120) + 10 + 16;
  btnSave.Left := btnCancelAccount.Left - btnSave.Width - 10;
  btnSave.ClientHeight := btnCancelAccount.ClientHeight;

  btnHelpAccounts.ClientHeight := btnCancelAccount.ClientHeight;
  lblTest.Caption := btnHelpAccounts.Caption;
  btnHelpAccounts.ClientWidth := Math.Max(lblTest.Width, 70) + 10 + 16;

  panAccountsButtons.Height := btnCancelAccount.Height + 3;

end;

procedure TAccountsForm.FormShow(Sender: TObject);
begin
  // the below lines will force an update of the colorbox so we can rename the fonts
  colAccount.Style := colAccount.Style - [cbCustomColors];
  colAccount.Style := colAccount.Style + [cbCustomColors];

  AutosizeCombobox( cmbAuthType );
  AutosizeCombobox( cmbSslVer );
end;

procedure TAccountsForm.btnEdSoundClick(Sender: TObject);
var
  dlgOpen : TOpenDialog;
begin
  dlgOpen := TOpenDialog.Create(nil);
  try
    dlgOpen.InitialDir := ExtractFileDir(edSound.Text);
    if dlgOpen.InitialDir='' then
       dlgOpen.InitialDir := ExtractFilePath(Application.ExeName)+'Sounds';
    dlgOpen.Filter := Translate('WAV files')+' (*.wav)|*.WAV';
    if dlgOpen.Execute then
    begin
      edSound.Text := dlgOpen.FileName;
      edSound.Font.Color := clWindowText;
    end;
  finally
    dlgOpen.Free;
  end;
end;

procedure TAccountsForm.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if FAccChanged or FNewAccount then
  begin
    case ShowSaveAccountDlg('Leave Accounts Tab') of
      mrYes: begin
        btnSave.Click();
        AllowChange := True;
      end;
      mrNo: begin
        RevertAccountChanges();
        AllowChange := True;
      end;
      mrCancel : AllowChange := False;
    end;
  end;
end;

procedure TAccountsForm.WMDropFiles(var msg: TWMDROPFILES);
begin
  DragFinish(msg.Drop);
end;

end.


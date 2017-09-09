unit frmConfigU;

interface

uses
  PluginSettingsU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList, Mask, JvExMask,
  JvSpin, JvToolEdit, System.UITypes, System.Actions, Vcl.ComCtrls, Vcl.ToolWin,
  System.ImageList, Vcl.ImgList;

type
  TfrmConfig = class(TForm)
    pnlBottom: TPanel;
    GroupBoxGeneral: TGroupBox;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    lblProfileName: TLabel;
    cbEnabled: TCheckBox;
    GroupBox1: TGroupBox;
    ActionListConfig: TActionList;
    editMySQLUserName: TLabeledEdit;
    editMySQLPassword: TLabeledEdit;
    editMySQLHostname: TLabeledEdit;
    editMySQLPort: TLabeledEdit;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    ListBoxExcludedDatabases: TListBox;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ActionAddDatabase: TAction;
    ActionRemoveDatabase: TAction;
    ActionClearAllDatabases: TAction;
    ImageList: TImageList;
    ActionOk: TAction;
    ActionCancel: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure ActionClearAllDatabasesExecute(Sender: TObject);
    procedure ActionRemoveDatabaseExecute(Sender: TObject);
    procedure ActionAddDatabaseExecute(Sender: TObject);
    procedure ActionCancelExecute(Sender: TObject);
  private
    FBackupProfile: string;
    FPluginSettings: TPluginSettings;
    procedure SetFormValues;
    procedure GetFormValues;
    procedure LoadSettings;
    procedure SaveSettings;
  public
    procedure Execute(ABackupProfile: string);
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

uses
  dlgAddDatabaseU;

procedure TfrmConfig.LoadSettings;
begin
  with FPluginSettings do
  begin
    ProfileName := FBackupProfile;
    LoadSettings;
  end;
end;

procedure TfrmConfig.SaveSettings;
begin
  with FPluginSettings do
  begin
    ProfileName := FBackupProfile;
    SaveSettings;
  end;
end;

procedure TfrmConfig.SetFormValues;
begin
  lblProfileName.Caption := FBackupProfile;
  cbEnabled.Checked := FPluginSettings.Enabled;
  editMySQLUserName.Text := FPluginSettings.MySQLUserName;
  editMySQLPassword.Text := FPluginSettings.MySQLPassword;
  editMySQLHostname.Text := FPluginSettings.MySQLHostname;
  editMySQLPort.Text := IntToStr(FPluginSettings.MySQLPort);
  ListBoxExcludedDatabases.Items.Assign(FPluginSettings.ExcludedDatabase);
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  FPluginSettings := TPluginSettings.Create;
  with FPluginSettings do
  begin
    RootKey := HKEY_CURRENT_USER;
    SettingsKey := APPLICATION_REGISTRY_STORAGE;
  end;
end;

procedure TfrmConfig.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPluginSettings);
end;

procedure TfrmConfig.GetFormValues;
begin
  FPluginSettings.Enabled := cbEnabled.Checked;
  FPluginSettings.MySQLUserName := editMySQLUserName.Text;
  FPluginSettings.MySQLPassword := editMySQLPassword.Text;
  FPluginSettings.MySQLHostname := editMySQLHostname.Text;
  FPluginSettings.MySQLPort := StrToInt64Def(editMySQLPort.Text, 0);
  FPluginSettings.ExcludedDatabase.Assign(ListBoxExcludedDatabases.Items);
end;

procedure TfrmConfig.ActionAddDatabaseExecute(Sender: TObject);
var
  dlgAddDatabase: TdlgAddDatabase;
  Database: string;
begin
  dlgAddDatabase := TdlgAddDatabase.Create(Self);
  try
    if dlgAddDatabase.Execute(editMySQLHostname.Text,
      StrToIntDef(editMySQLPort.Text, 0), editMySQLUserName.Text,
      editMySQLPassword.Text, Database) then
    begin
      ListBoxExcludedDatabases.Items.Add(Database);
    end;
  finally
    FreeAndNil(dlgAddDatabase);
  end;
end;

procedure TfrmConfig.ActionCancelExecute(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmConfig.ActionClearAllDatabasesExecute(Sender: TObject);
begin
  if (MessageDlg('Empty excluded database list?', mtConfirmation, [mbYes], 0)
    = mrYes) then
  begin
    ListBoxExcludedDatabases.Items.Clear;
  end;
end;

procedure TfrmConfig.ActionRemoveDatabaseExecute(Sender: TObject);
begin
  if (MessageDlg('Remove selected?', mtConfirmation, [mbYes, mbOK], 0) = mrYes)
  then
  begin
    ListBoxExcludedDatabases.DeleteSelected;
  end;
end;

procedure TfrmConfig.btnOkClick(Sender: TObject);
var
  Continue: boolean;
begin
  Continue := True;
  if cbEnabled.Checked then
  begin
    if Continue then
      Continue := Trim(editMySQLUserName.Text) <> '';
    if Continue then
      Continue := Trim(editMySQLPassword.Text) <> '';
    if Continue then
      Continue := Trim(editMySQLHostname.Text) <> '';
    if Continue then
      Continue := Trim(editMySQLPort.Text) <> '';
  end;

  if not Continue then
  begin
    MessageDlg('Please ensure all options are configured.', mtError, [mbOK], 0);
  end
  else
  begin
    Self.ModalResult := mrOk;
  end;

end;

procedure TfrmConfig.Execute(ABackupProfile: string);
begin
  FBackupProfile := ABackupProfile;
  LoadSettings;
  SetFormValues;
  if Self.ShowModal = mrOk then
  begin
    GetFormValues;
    SaveSettings;
  end;
end;

end.

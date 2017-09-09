unit frmConfigU;

interface

uses
  PluginSettingsU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList, Registry, Mask, JvExMask,
  JvSpin, System.Actions;

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
    editFTPServer: TLabeledEdit;
    editFTPPort: TJvSpinEdit;
    editFTPRemotePath: TLabeledEdit;
    Label1: TLabel;
    editFTPUserName: TLabeledEdit;
    editFTPPassword: TLabeledEdit;
    cbPassive: TCheckBox;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FBackupProfile : String;
    FPluginSettings : TPluginSettings;
    procedure SetFormValues;
    procedure GetFormValues;
    procedure LoadSettings;
    procedure SaveSettings;
  public
    procedure Execute(ABackupProfile : String);
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}


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
  editFTPServer.Text := FPluginSettings.FTPServer;
  editFTPPort.AsInteger := FPluginSettings.FTPPort;
  editFTPRemotePath.Text := FPluginSettings.FTPRemotePath;
  editFTPUserName.Text := FPluginSettings.FTPUsername;
  editFTPPassword.Text := FPluginSettings.FTPPassword;
  cbPassive.Checked := FPluginSettings.FTPPassive;
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
  FPluginSettings.FTPServer := editFTPServer.Text;
  FPluginSettings.FTPPort := editFTPPort.AsInteger;
  FPluginSettings.FTPRemotePath := editFTPRemotePath.Text;
  FPluginSettings.FTPUsername := editFTPUserName.Text;
  FPluginSettings.FTPPassword := editFTPPassword.Text;
  FPluginSettings.FTPPassive := cbPassive.Checked;

end;

procedure TfrmConfig.Execute(ABackupProfile : String);
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

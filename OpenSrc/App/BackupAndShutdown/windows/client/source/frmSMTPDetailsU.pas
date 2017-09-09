unit frmSMTPDetailsU;

interface

uses
  BackupProfileU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, Spin, ExtCtrls, JvXPCore,
  JvXPButtons, Buttons, System.Actions;

type
  TfrmSMTPDetails = class(TForm)
    pnlBottom: TPanel;
    pnlDetails: TPanel;
    GroupBoxSMTPDetails: TGroupBox;
    editSMTPServer: TLabeledEdit;
    editSMTPPort: TSpinEdit;
    Label11: TLabel;
    editSMTPPassword: TLabeledEdit;
    editSMTPUsername: TLabeledEdit;
    cbSMTPSecure: TCheckBox;
    cbSMTPAuthentication: TCheckBox;
    ActionListSMTPDetails: TActionList;
    ActionOk: TAction;
    ActionCancel: TAction;
    JvXPButton1: TBitBtn;
    JvXPButton2: TBitBtn;
    procedure ActionOkExecute(Sender: TObject);
    procedure ActionCancelExecute(Sender: TObject);
  private
    FSMTPDetails : TBackupProfileSMTPSettings;
    procedure GetFormValues;
    procedure SetFormValues;
  public
    function Execute(ASMTPDetails : TBackupProfileSMTPSettings) : Boolean;
  end;

var
  frmSMTPDetails: TfrmSMTPDetails;

implementation

{$R *.dfm}

procedure TfrmSMTPDetails.GetFormValues;
begin
  with FSMTPDetails do
    begin
      SMTPHostname := editSMTPServer.Text;
      SMTPPort := editSMTPPort.Value;
      SMTPAuthentication := cbSMTPAuthentication.Checked;
      SMTPSecure := cbSMTPSecure.Checked;
      Username := editSMTPUsername.Text;
      Password := editSMTPPassword.Text;
    end;
end;

procedure TfrmSMTPDetails.SetFormValues;
begin
  with FSMTPDetails do
    begin
      editSMTPServer.Text := SMTPHostname;
      editSMTPPort.Value := SMTPPort;
      cbSMTPAuthentication.Checked := SMTPAuthentication;
      cbSMTPSecure.Checked := SMTPSecure;
      editSMTPUsername.Text := Username;
      editSMTPPassword.Text := Password;
    end;
end;

function TfrmSMTPDetails.Execute(ASMTPDetails : TBackupProfileSMTPSettings) : Boolean;
begin
  Result := False;
  FSMTPDetails := ASMTPDetails;
  SetFormValues;
  if Self.ShowModal = mrOk then
    begin
      GetFormValues;
      Result := True;
    end;
end;

procedure TfrmSMTPDetails.ActionCancelExecute(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmSMTPDetails.ActionOkExecute(Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

end.

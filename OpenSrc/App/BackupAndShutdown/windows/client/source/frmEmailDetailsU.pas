{-----------------------------------------------------------------------------
 Unit Name: frmEmailDetailsU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Backup Profile Email Details.

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

-----------------------------------------------------------------------------}
unit frmEmailDetailsU;

interface

uses
  BackupProfileU, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActnList, StdCtrls, Buttons, Menus,
  JvArrowButton, System.UITypes, System.Actions;

type
  TfrmEmailDetails = class(TForm)
    pnlBottom: TPanel;
    pnlMain: TPanel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    ActionList1: TActionList;
    pnlTop: TPanel;
    imgHeader: TImage;
    imgBackground: TImage;
    lblHeader: TLabel;
    ActionTest: TAction;
    ActionOk: TAction;
    ActionCancel: TAction;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    editSenderName: TEdit;
    editSenderAddress: TEdit;
    Label4: TLabel;
    Bevel1: TBevel;
    Label5: TLabel;
    editRecipients: TEdit;
    Label6: TLabel;
    editSubject: TEdit;
    Label7: TLabel;
    memoBody: TMemo;
    Label8: TLabel;
    BitBtn1: TBitBtn;
    ActionShowKeywords: TAction;
    procedure ActionCancelExecute(Sender: TObject);
    procedure ActionOkExecute(Sender: TObject);
    procedure ActionTestExecute(Sender: TObject);
    procedure ActionShowKeywordsExecute(Sender: TObject);
  private
    FQuickEmail : TBackupProfileEmailDetails;
    procedure SetFormValues;
    procedure GetFormValues;
  public
    function Execute(AQuickEmail : TBackupProfileEmailDetails) : Boolean;
  end;

var
  frmEmailDetails: TfrmEmailDetails;

implementation



{$R *.dfm}

procedure TfrmEmailDetails.SetFormValues;
begin
  with FQuickEmail do
    begin
      editSenderName.Text := SenderName;
      editSenderAddress.Text := SenderAddress;
      editRecipients.Text := Recipients;
      editSubject.Text := Subject;
      memoBody.Lines.Text := Body;
    end;
end;

procedure TfrmEmailDetails.GetFormValues;
begin
  with FQuickEmail do
    begin
      SenderName := editSenderName.Text;
      SenderAddress := editSenderAddress.Text;
      Recipients := editRecipients.Text;
      Subject := editSubject.Text;
      Body := memoBody.Lines.Text;
    end;
end;

function TfrmEmailDetails.Execute(AQuickEmail : TBackupProfileEmailDetails) : Boolean;
begin
  Result := False;
  FQuickEmail := AQuickEmail;
  SetFormValues;
  if Self.ShowModal = mrOk then
    begin
      GetFormValues;
      AQuickEmail := FQuickEmail;
      Result := True;
    end;
end;

procedure TfrmEmailDetails.ActionCancelExecute(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmEmailDetails.ActionOkExecute(Sender: TObject);
var
  FormValid : Boolean;
begin
  FormValid := True;
  if editSenderAddress.Text = '' then
    begin
      MessageDlg('You must specify a Sender Address. eg (your@yourcompany.com.au)', mtError, [mbOK], 0);
      editSenderAddress.SetFocus;
      FormValid := False;
    end;
  if FormValid then Self.ModalResult := mrOk;
end;

procedure TfrmEmailDetails.ActionShowKeywordsExecute(Sender: TObject);
begin
  MessageDlg('%computername% - Computer name.'+#13+#10+'%username% - Currently logged in user.'+#13+#10+'%ipaddress% - Computer IP address.'+#13+#10+'%profilename% - Backup profile name.'+#13+#10+'%lastbackup% - Backup profile last backup.'+#13+#10+'%daysoverdue% - Backup profile days overdue.'+#13+#10+'%zipfile% - Backup profile zip file name.'+#13+#10+'%logfile% - Backup profile log file name.'+#13+#10+'%description% - Backup profile description.'+#13+#10+'%log% - Backup profile log file contents', mtInformation, [mbOK], 0);
end;

procedure TfrmEmailDetails.ActionTestExecute(Sender: TObject);
begin
  GetFormValues;
  MessageDlg('Not Implemented.', mtError, [mbOK], 0);
end;



end.

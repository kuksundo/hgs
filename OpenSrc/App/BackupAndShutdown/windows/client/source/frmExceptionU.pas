{-----------------------------------------------------------------------------
 Unit Name: frmExceptionU
 Author: Tristan Marlow
 Purpose: Exception display form

 ----------------------------------------------------------------------------
 Copyright (c) 2006 Tristan David Marlow
 Copyright (c) 2006 Little Earth Solutions
 All Rights Reserved

 This product is protected by copyright and distributed under
 licenses restricting copying, distribution and decompilation

 ----------------------------------------------------------------------------

 History: 01/01/2006 - First Release.

-----------------------------------------------------------------------------}
unit frmExceptionU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, JvLinkLabel,
  JvExControls, JvLabel, JvComponentBase, JvBaseDlg,
  JvProgressDialog, System.UITypes;

type
  TfrmException = class(TForm)
    pnlBottom:   TPanel;
    pnlMain:     TPanel;
    btnContinue: TBitBtn;
    btnSend:     TBitBtn;
    imgError:    TImage;
    memoException: TRichEdit;
    JvLabel1:    TJvLabel;
    memoInformation: TRichEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSendClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute(ASender: TObject; E: Exception): boolean; reintroduce;
  end;


implementation


{$R *.dfm}

function TfrmException.Execute(ASender: TObject; E: Exception): boolean;
begin
  with memoException.Lines do
  begin
    Clear;
    Add(E.Message);
    Add('');
    Add('Sender Class: ' + ASender.ClassType.ClassName);
    Add('Class: ' + E.ClassType.ClassName);
  end;
  with memoInformation.Lines do
  begin
    Clear;
    Add('We apologize for this inconvenience, press continue to attempt');
    Add('recovery from the error or press terminate to exit the application.');
  end;
  Result := Self.ShowModal = mrOk;
end;

procedure TfrmException.FormShow(Sender: TObject);
begin
  memoException.SetFocus;
end;

procedure TfrmException.btnContinueClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmException.btnSendClick(Sender: TObject);
begin
  if (MessageDlg(Format(
    'Terminating %s will loose any unsaved changes, are you sure you want to continue?',
    [Application.Title]), mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    Application.Terminate;
  end;
end;

procedure TfrmException.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.


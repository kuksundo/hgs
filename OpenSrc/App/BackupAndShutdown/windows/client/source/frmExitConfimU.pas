{-----------------------------------------------------------------------------
 Unit Name: frmExitConfimU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Exit Windows Confirmation.

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
unit frmExitConfimU;

interface

uses
  ExitWindowsU, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, JvXPCore, JvXPButtons,
  Buttons;

type
  TfrmExitConfirm = class(TForm)
    pnlButtons: TPanel;
    pnlMain: TPanel;
    TimerConfirm: TTimer;
    memoAlert: TMemo;
    imgShutdown: TImage;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    procedure TimerConfirmTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FTimeOut : Integer;
    function GetExitParameterString(AExitParameter : TExitParameter) : String;
  public
    function Execute(AExitParameter : TExitParameter; ATimeOut : Integer = 30) : Boolean;
  end;

var
  frmExitConfirm: TfrmExitConfirm;

implementation

{$R *.dfm}

function TfrmExitConfirm.GetExitParameterString(AExitParameter : TExitParameter) : String;
begin
  case AExitParameter of
    xpLogoff: Result := 'Log Off';
    xpReboot: Result := 'Restart';
    xpShutdown: Result := 'Shut Down';
    else Result := '';
  end;
end;

function TfrmExitConfirm.Execute(AExitParameter : TExitParameter; ATimeOut : Integer= 30) : Boolean;
begin
  TimerConfirm.Enabled := False;
  FTimeOut := ATimeOut;
  with memoAlert.Lines do
    begin
      Clear;
      Add('WARNING');
      Add('');
      Add(Format('Windows will %s in %d second(s)...',[GetExitParameterString(AExitParameter),FTimeOut]));
    end;
  Result := Self.ShowModal = mrOk;
  TimerConfirm.Enabled := False;
end;

procedure TfrmExitConfirm.FormShow(Sender: TObject);
begin
  TimerConfirm.Enabled := True;
end;

procedure TfrmExitConfirm.TimerConfirmTimer(Sender: TObject);
begin
  if FTimeOut > 0 then
    begin
      Dec(FTimeOut);
      btnOk.Caption := Format('Ok (%d)',[FTimeOut]);
      Self.BringToFront;
    end else
    begin
      Self.ModalResult := mrOk;
    end;
end;

end.

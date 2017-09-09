{-----------------------------------------------------------------------------
 Unit Name: frmPasswordU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Password Dialog.

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
unit frmPasswordU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrmPassword = class(TForm)
    pnlBottom: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    pnlMain: TPanel;
    lblPasswordCaption: TLabel;
    editPassword: TEdit;
    imgLock: TImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute(AMessage, ARequiredPassword : String; ARetries : Integer) : Boolean;
  end;

var
  frmPassword: TfrmPassword;

implementation

{$R *.dfm}

function TfrmPassword.Execute(AMessage, ARequiredPassword : String; ARetries : Integer) : Boolean;
var
  i : Integer;
begin
  lblPasswordCaption.Caption := AMessage;
  i := 1;
  Result := False;
  if ARetries <= 0 then ARetries := 3;
  While (i <= ARetries) and (not Result) do
    begin
      if Self.ShowModal = mrOk then
        begin
          if AnsiSameText(editPassword.Text, ARequiredPassword) then
            begin
              Result := True;
            end;
        end else
        begin
          i := ARetries;
        end;
      inc(i);
    end;
end;

procedure TfrmPassword.FormShow(Sender: TObject);
begin
  editPassword.Text := '';
  editPassword.SetFocus;
end;

end.

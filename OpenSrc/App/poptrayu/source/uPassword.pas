unit uPassword;

{-------------------------------------------------------------------------------
POPTRAY
Copyright (C) 2001-2005  Renier Crause
All Rights Reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

The GNU GPL can be found at:
  http://www.gnu.org/copyleft/gpl.html
-------------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrmPassword = class(TForm)
    Image1: TImage;
    lblEnterPw: TLabel;
    edPass: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure AlignLabels();
  public
    { Public declarations }
  end;

var
  frmPassword: TfrmPassword;

implementation

uses uMain, uGlobal, Math;

{$R *.dfm}

procedure TfrmPassword.FormShow(Sender: TObject);
begin
  self.Font := Options.GlobalFont;
  AlignLabels();
  SetForegroundWindow(Handle);
  frmPopUMain.HideForm;
end;

procedure TfrmPassword.AlignLabels();
begin
  edPass.Top := Max(36, lblEnterPw.Top + lblEnterPw.Height + 6);
  btnOk.Top := edPass.Top;
  btnCancel.Top := edPass.Top;

  btnOk.Height := edPass.Height;
  btnCancel.Height := edPass.Height;
  self.ClientHeight := edPass.Top + edPass.Height + 10;

  canvas.Font := self.Font;
  btnOk.Left := edPass.Left + edPass.Width + 10;
  btnOk.ClientWidth := Max(Canvas.TextWidth(btnOK.Caption) + 35, btnOk.ClientWidth);

  btnCancel.Left := btnOk.Left + btnOk.Width + 10;
  btnCancel.ClientWidth := Max(Canvas.TextWidth(btnCancel.Caption) + 35, btnCancel.ClientWidth);

  self.Width := Max(lblEnterPw.Left + lblEnterPw.Width, btnCancel.Left + btnCancel.Width) + 15;

end;

end.

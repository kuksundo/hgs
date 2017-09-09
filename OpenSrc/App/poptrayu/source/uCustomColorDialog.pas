{-------------------------------------------------------------------------------
Custom Color Selection Dialog
Copyright © 2015 Jessica Brown
All Rights Reserved.

 * This FILE is dual licensed; you can use it under the terms of
 * either the GPL, or the BSD license, at your option.
 *
 * I. GPL:
 *
 * This file is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * The GNU GPL can be found at:
 *   http://www.gnu.org/copyleft/gpl.html
 *
 * Alternatively,
 *
 * II. BSD license:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
-------------------------------------------------------------------------------}

unit uCustomColorDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, OKCANCL2, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TCustomColorDialog = class(TOKRightDlg)
    listboxFgColorBox: TColorBox;
    listboxBgColorBox: TColorBox;
    lblFg: TLabel;
    lblBg: TLabel;
    imgFg: TImage;
    imgBg: TImage;
    chkUseDefaults: TCheckBox;
    Memo1: TMemo;
    procedure listboxFgColorBoxChange(Sender: TObject);
    procedure listboxBgColorBoxChange(Sender: TObject);
    procedure chkUseDefaultsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AnyColorBoxGetColors(Sender: TCustomColorBox;
      Items: TStrings);
  private
    { Private declarations }
    fFg : TColor;
    fBg : TColor;
    fDefFg : TColor;
    fDefBg : TColor;
    procedure UpdatePreview;
    procedure SetPreviewFont(font : TFont);
    procedure SetPreviewCaption(previewCaption : String);
  public
    { Public declarations }
    Property ForeColor : TColor read fFg write fFg;
    Property BackColor : TColor read fBg write fBg;
    Property DefaultForeColor : TColor read fDefFg write fDefFg;
    Property DefaultBackColor : TColor read fDefBg write fDefBg;
    Property PreviewFont : TFont write SetPreviewFont;
    Property PreviewCaption : String write SetPreviewCaption;
  end;

var
  CustomColorDialog: TCustomColorDialog;

implementation
uses Math, uTranslate;

{$R *.dfm}

procedure TCustomColorDialog.SetPreviewCaption(previewCaption : String);
begin
  Memo1.Text := previewCaption;
end;

procedure TCustomColorDialog.SetPreviewFont(font : TFont);
begin
  Memo1.Font.Assign(font);
end;

procedure TCustomColorDialog.chkUseDefaultsClick(Sender: TObject);
begin
  inherited;
  if (chkUseDefaults.Checked) then begin
    fFg := fDefFg;
    fBg := fDefBg;
    UpdatePreview();
  end;
end;

procedure TCustomColorDialog.FormCreate(Sender: TObject);
begin
  inherited;
  fDefFg := clWindowText;
  fDefBg := clWindow;
  fFg := clWindowText;
  fBg := clWindow;
end;

procedure TCustomColorDialog.FormResize(Sender: TObject);
const
  MIN_BTN_WIDTH = 75;
var
  buttonWidth, buttonHeight : integer;
begin
  listboxFgColorBox.Top := lblFg.Top + lblFg.Height + 3;
  lblBg.Top := listboxFgColorBox.Top + listboxFgColorBox.Height + 3 + 8;
  listboxBgColorBox.Top := lblBg.Top + lblBg.Height + 3;
  imgBg.Top := lblBg.Top;
  chkUseDefaults.Height := lblBg.Height;
  chkUseDefaults.Top := listboxBgColorBox.Top + listboxBgColorBox.Height + 3;
  Bevel1.Height := (chkUseDefaults.Top + chkUseDefaults.Height) - (Bevel1.Top);
  Memo1.Top := Bevel1.Top + Bevel1.Height + 8;
  self.ClientHeight := memo1.Top + memo1.Height + 8;

  // buttons
  OKBtn.Left := Bevel1.Left + Bevel1.Width + 8;
  CancelBtn.Left := OKBtn.Left;
  buttonWidth := Max(self.Canvas.TextWidth(OKBtn.Caption), self.Canvas.TextWidth(CancelBtn.Caption)) + 16;
  if buttonWidth > OKBtn.ClientWidth then begin
    OKBtn.ClientWidth := buttonWidth + 16;
    CancelBtn.ClientWidth := buttonWidth + 16;
    self.ClientWidth := OKBtn.Left + OKBtn.Width + 8;
  end;
  buttonHeight := Max(self.Canvas.TextHeight(OkBtn.Caption), self.Canvas.TextHeight(CancelBtn.Caption));
  if buttonHeight > OKBtn.ClientHeight then begin
    OkBtn.ClientHeight := buttonHeight + 4;
    CancelBtn.ClientHeight := buttonHeight + 4;
    CancelBtn.Top := OKBtn.Top + OKBtn.Height + 8;
  end;

  inherited;
end;

procedure TCustomColorDialog.FormShow(Sender: TObject);
begin
  inherited;
  UpdatePreview();
  FormResize(Sender);

  // the below lines will force an update of the colorbox so we can rename the fonts
  listboxFgColorBox.Style := listboxFgColorBox.Style - [cbCustomColors];
  listboxFgColorBox.Style := listboxFgColorBox.Style + [cbCustomColors];
  listboxBgColorBox.Style := listboxBgColorBox.Style - [cbCustomColors];
  listboxBgColorBox.Style := listboxBgColorBox.Style + [cbCustomColors];
end;

procedure TCustomColorDialog.listboxBgColorBoxChange(Sender: TObject);
begin
  inherited;
  fBg := listboxBgColorBox.Selected;
  UpdatePreview();
end;

procedure TCustomColorDialog.listboxFgColorBoxChange(Sender: TObject);
begin
  inherited;
  fFg := listboxFgColorBox.Selected;
  UpdatePreview();
end;

procedure TCustomColorDialog.AnyColorBoxGetColors(Sender: TCustomColorBox;
  Items: TStrings);
var
  i : integer;
begin
  inherited;
  for i := 0 to Items.Count - 1 do begin
    Items.Strings[i] := Translate(Items.Strings[i]);
  end;
end;

procedure TCustomColorDialog.UpdatePreview();
begin
  listboxFgColorBox.Selected := fFg;
  listboxBgColorBox.Selected := fBg;

  Memo1.Font.Color := fFg;
  Memo1.Color := fBg;


  if (fFg = fDefFg) and (fBg = fDefBg) then
    chkUseDefaults.Checked := true
  else
    chkUseDefaults.Checked := false;
end;

end.

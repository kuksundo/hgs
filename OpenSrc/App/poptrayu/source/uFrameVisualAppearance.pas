{-------------------------------------------------------------------------------
Visual Appearance Frame
Copyright © 2012 Jessica Brown
All Rights Reserved.

 * This file is dual licensed; you can use it under the terms of
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

unit uFrameVisualAppearance;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ImgList, PngSpeedButton,
  Vcl.Imaging.pngimage, PngBitBtn;

type
  TEnableSaveOptionsFunction = procedure of object;


type

  { TframeVisualAppearance }

  TframeVisualAppearance = class(TFrame)
    Label1: TLabel;
    btnFontChange: TSpeedButton;
    btnGlobalFont: TSpeedButton;
    btnVerticalTabFont: TSpeedButton;
    lblFontListbox: TLabel;
    lblFontVertical: TLabel;
    lblFontGlobal: TLabel;
    imgLtDk: TImageList;
    resetListboxBtn: TPngSpeedButton;
    cmbVclStyle: TComboBox;
    lblTheme: TLabel;
    btnLoadTheme: TPngBitBtn;
    chkInvertColors: TCheckBox;
    CategoryPanelGroup1: TCategoryPanelGroup;
    catTheme: TCategoryPanel;
    CategoryPanel2: TCategoryPanel;
    Label2: TLabel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    Label7: TLabel;
    Label8: TLabel;
    SpeedButton2: TSpeedButton;
    btnMsgListColors: TPngSpeedButton;
    panSamplePlainText: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    lblFontPreview: TLabel;
    btnPreviewFont: TSpeedButton;
    panSampleGlobalFont: TPanel;
    panSampleVerticalFont: TPanel;
    panSampleListboxFont: TPanel;
    BtnPreviewColors: TPngSpeedButton;
    procedure btnFontChangeClick(Sender: TObject);
    procedure OptionsChange(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure resetListboxBtn1Click(Sender: TObject);
    procedure cmbVclStyleChange(Sender: TObject);
    procedure btnLoadThemeClick(Sender: TObject);
    procedure btnMsgListColorsClick(Sender: TObject);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure AlignLabels();
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
    procedure SetColors();
  end;

  procedure LoadVisualStyleFromDisk(const FileName: string);


implementation

uses uMain, uGlobal, StrUtils, uRCUtils, uFontUtils, uTranslate, uDM,
  Vcl.Themes, DateTimePickers, Math, uPositioning, uCustomColorDialog,
  uConstants, System.UITypes;

{$R *.dfm}
  //TToolbarScheme = (schemeNormal = 0, schemeTwilight = 1);

constructor TframeVisualAppearance.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
var
  i: integer;
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;

  // Options to screen

  // Global Font
  Self.Font.Assign(Options.GlobalFont);

  CategoryPanelGroup1.HeaderFont.Assign(Options.GlobalFont);
  CategoryPanelGroup1.HeaderFont.Style := CategoryPanelGroup1.HeaderFont.Style + [fsBold];
  CategoryPanelGroup1.HeaderFont.Size := Options.GlobalFont.Size;

  panSampleGlobalFont.Font.Assign(Options.GlobalFont);
  panSampleGlobalFont.Caption := panSampleGlobalFont.Font.Name;
  
  btnFontChange.Font.Assign(Options.GlobalFont);
  btnGlobalFont.Font.Assign(Options.GlobalFont);
  btnVerticalTabFont.Font.Assign(Options.GlobalFont);
  resetListboxBtn.Font.Assign(Options.GlobalFont);

  // Vertical Font
  panSampleVerticalFont.Font.Assign(Options.VerticalFont);
  panSampleVerticalFont.Caption := panSampleVerticalFont.Font.Name;

  // Listbox Fonts/Colors
  panSampleListboxFont.Font.Assign(Options.ListboxFont);
  panSampleListboxFont.Caption := panSampleListboxFont.Font.Name;
  panSampleListboxFont.Color := Options.ListboxBg;

  // Preview Font
  panSamplePlainText.Font.Assign(Options.PreviewFont);
  panSamplePlainText.Caption := panSamplePlainText.Font.Name;
  panSamplePlainText.Color := Options.PreviewBgColor;

  chkInvertColors.Checked := Options.ToolbarColorScheme = schemeDark;

  SetColors();

  i := cmbVclStyle.Items.IndexOf(Options.VisualStyleFilename);
  if i > -1 then begin
    cmbVclStyle.ItemIndex := i;
  end else begin
    i := cmbVclStyle.Items.Add(Options.VisualStyleFilename);
    cmbVclStyle.ItemIndex := i;
  end;

  TranslateComponentFromEnglish(self);
  AlignLabels();

  Refresh;

end;

procedure TframeVisualAppearance.AlignLabels();
var
  labelHeight : integer;
  widest, right : integer;
begin
  labelHeight := lblTheme.Height;

  cmbVclStyle.Left := CalcPosToRightOf(lblTheme);
  cmbVclStyle.Width := btnLoadTheme.Left - cmbVclStyle.Left - 10;
  btnLoadTheme.Height := cmbVclStyle.Height;
  chkInvertColors.Height := labelHeight;
  chkInvertColors.Top := calcPosBelow(cmbVclStyle);
  catTheme.ClientHeight := calcPosBelow(chkInvertColors);

  widest := lblFontGlobal.Width;
  if lblFontVertical.Width > widest then widest := lblFontVertical.Width;
  if lblFontListbox.Width > widest then widest := lblFontListbox.Width;
  if lblFontPreview.Width > widest then widest := lblFontPreview.Width;
  right := btnGlobalFont.Left - 6;

  panSampleGlobalFont.Left    := lblFontGlobal.Left + widest + 4;
  panSampleVerticalFont.Left  := lblFontGlobal.Left + widest + 4;
  panSampleListboxFont.Left   := lblFontGlobal.Left + widest + 4;
  panSamplePlainText.Left     := lblFontGlobal.Left + widest + 4;

  panSampleGlobalFont.Width       := right - panSampleGlobalFont.Left;
  panSampleVerticalFont.Width := right - panSampleVerticalFont.Left;
  panSampleListboxFont.Width  := right - panSampleListboxFont.Left - btnMsgListColors.Width - 6;
  panSamplePlainText.Width    := right - panSamplePlainText.Left - btnPreviewFont.Width - 6;


end;

procedure TframeVisualAppearance.SetColors();
begin
  btnGlobalFont.Glyph := Nil;
  btnFontChange.Glyph := Nil;
  btnVerticalTabFont.Glyph := Nil;

  //toolbar color scheme = 0 or 1
  imgLtDk.GetBitmap(Options.ToolbarColorScheme, btnGlobalFont.Glyph);
  imgLtDk.GetBitmap(Options.ToolbarColorScheme, btnFontChange.Glyph);
  imgLtDk.GetBitmap(Options.ToolbarColorScheme, btnVerticalTabFont.Glyph);

  frmPopUMain.LoadSkin();
  Self.Repaint;
end;

procedure TframeVisualAppearance.OptionsChange(Sender: TObject);
begin
  if not Options.Busy then
  begin
    // screen to options
    Options.ListboxFont.Assign(panSampleListboxFont.Font);
    Options.ListboxBg := panSampleListboxFont.Color;

    frmPopUMain.lvMail.Font.Assign(panSampleListboxFont.Font);
    frmPopUMain.lvMail.Color := panSampleListboxFont.Color;

    Options.GlobalFont.Assign(panSampleGlobalFont.Font);
    Options.VerticalFont.Assign(panSampleVerticalFont.Font);
    Options.PreviewFont.Assign(panSamplePlainText.Font);
    Options.PreviewBgColor := panSamplePlainText.Color;

    Options.ToolbarColorScheme := IfThen(chkInvertColors.Checked, schemeDark, schemeLight);

    frmPopUMain.UpdateFonts();
    SetColors();

    // enable save button
    funcEnableSaveBtn();
  end;
end;

procedure TframeVisualAppearance.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

procedure TframeVisualAppearance.btnFontChangeClick(Sender: TObject);
var
  fntDlg : TFontDialog;
begin
  fntDlg := TFontDialog.Create(nil);
  try
    fntDlg.Options := [];//not fdEffects

    if      sender = btnFontChange      then fntDlg.Font := Options.ListboxFont
    else if sender = btnGlobalFont      then fntDlg.Font := Options.GlobalFont
    else if sender = btnVerticalTabFont then fntDlg.Font := Options.VerticalFont;

    if fntDlg.Execute then
    begin
      if sender = btnFontChange then
      begin
        panSampleListboxFont.Font := fntDlg.Font;

      end
      else if sender = btnGlobalFont then
      begin
        panSampleGlobalFont.Font := fntDlg.Font;
        panSampleGlobalFont.Caption := fntDlg.Font.Name;
      end
      else if sender = btnVerticalTabFont then
      begin
        panSampleVerticalFont.Font := fntDlg.Font;
        panSampleVerticalFont.Caption := fntDlg.Font.Name;
      end
      else if sender = btnPreviewFont then
      begin
        panSamplePlainText.Font := fntDlg.Font;
        panSamplePlainText.Caption := fntDlg.Font.Name;
      end;

      OptionsChange(Sender);
    end;
  finally
    fntDlg.Free;
  end;
end;

procedure TframeVisualAppearance.resetListboxBtn1Click(Sender: TObject);
var
  defaultFont : string;
  font : TFont;
begin
  panSampleListboxFont.Color := Graphics.clWindow;
  panSampleListboxFont.Font.Color := Graphics.clWindowText;
  defaultFont := IfThen(IsWinVista(), DEFAULT_FONT_VISTA, DEFAULT_FONT_XP);

  font := StringToFont(defaultFont);
  panSampleListboxFont.Font.Assign(font);
  panSampleListboxFont.Caption := panSampleListboxFont.Font.Name;
  //FreeAndNil(font);

  //font := StringToFont(defaultFont);
  panSampleGlobalFont.Font.Assign(font);
  panSampleGlobalFont.Caption := panSampleGlobalFont.Font.Name;
  FreeAndNil(font);

  font := StringToFont(DEFAULT_FONT_VERTICAL);
  panSampleVerticalFont.Font.Assign(font);
  panSampleVerticalFont.Caption := panSampleVerticalFont.Font.Name;
  FreeAndNil(font);

  font := StringToFont(DEFAULT_FONT_PREVIEW);
  panSamplePlainText.Font.Assign(font);
  panSamplePlainText.Caption := panSamplePlainText.Font.Name;
  FreeAndNil(font);

  OptionsChange(resetListboxBtn);
end;

procedure LoadVisualStyleFromDisk(const FileName: string);
var
  styleInfo : TStyleInfo;
begin
    if (FileName <> '') and (FileExists(FileName)) then
    begin
      if TStyleManager.IsValidStyle(FileName, styleInfo) then
      begin
        try
          TStyleManager.LoadFromFile(FileName);
        except
          on E: EDuplicateStyleException do ; //ignore
        end;
        TStyleManager.TrySetStyle(styleInfo.Name, False);
      end
      else
      begin
        TStyleManager.TrySetStyle('Windows', False);
      end;
    end else begin
      // Style is either a built-in style, or a file that is missing/removed.
      // Try setting as a built-in style
      TStyleManager.TrySetStyle(FileName, False);
    end;
end;

procedure TframeVisualAppearance.btnLoadThemeClick(Sender: TObject);
var
  openDialog : TOpenDialog;
  i : integer;
begin
  openDialog := TOpenDialog.Create(self);
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter := 'VCL Visual Style|*.vsf';

  // Show Open Dialog
  if openDialog.Execute then
  begin
    // user pressed ok
    LoadVisualStyleFromDisk(openDialog.FileName);

    Options.VisualStyleFilename := openDialog.FileName;

    // add new style to combo-box if not already in it
    i := cmbVclStyle.Items.IndexOf(Options.VisualStyleFilename);
    if i < 0 then
      i := cmbVclStyle.Items.Add(Options.VisualStyleFilename);
    cmbVclStyle.ItemIndex := i;

    OptionsChange(btnLoadTheme);

  end; //else user pressed cancel on open dialog...do nothing

  openDialog.Free;
end;


procedure TframeVisualAppearance.btnMsgListColorsClick(Sender: TObject);
var
  dlg : TCustomColorDialog;
  previewPanel : TPanel;
begin
  dlg := TCustomColorDialog.Create(self);

  if (Sender = btnMsgListColors) then
    previewPanel := panSampleListboxFont
  else if (Sender = BtnPreviewColors) then
    previewPanel := panSamplePlainText
  else begin
    // unexpected for any other sender to call this method.
    Assert(false);
    Exit;
  end;

  dlg.DefaultForeColor := clWindowText;
  dlg.DefaultBackColor := clWindow;

  dlg.ForeColor := previewPanel.Font.Color;
  dlg.BackColor := previewPanel.Color;

  TranslateComponentFromEnglish(dlg);
  dlg.PreviewCaption := Translate('Preview');
  dlg.Font := Options.GlobalFont;
  dlg.PreviewFont := previewPanel.Font;
  //dlg.FormResize(self);

  dlg.ShowModal;
  if dlg.ModalResult = mrOk then begin
    previewPanel.Font.Color := dlg.ForeColor;
    previewPanel.Color := dlg.BackColor;

    OptionsChange(Sender);
  end;
  dlg.Free;
end;

procedure TframeVisualAppearance.cmbVclStyleChange(Sender: TObject);
begin
  try
    TStyleManager.SetStyle(cmbVclStyle.Text);
  except on e: ECustomStyleException do
    LoadVisualStyleFromDisk(cmbVclStyle.Text);
  end;
    Options.VisualStyleFilename := cmbVclStyle.Text;
    OptionsChange(btnLoadTheme);
end;

end.


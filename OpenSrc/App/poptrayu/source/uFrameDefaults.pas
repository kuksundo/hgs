unit uFrameDefaults;

{-------------------------------------------------------------------------------
POPTRAY
Copyright (C) 2003-2005  Renier Crause
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
  Dialogs, StdCtrls, Buttons, PngSpeedButton, Vcl.ExtCtrls;

type
  TEnableSaveOptionsFunction = procedure of object;

type
  TframeDefaults = class(TFrame)
    lblProgram: TLabel;
    btnEdProgram: TSpeedButton;
    btnTestEmailClient: TSpeedButton;
    lblSound: TLabel;
    btnEdDefSound: TSpeedButton;
    btnSndTest: TSpeedButton;
    lblLang: TLabel;
    edProgram: TEdit;
    edDefSound: TEdit;
    cmbLanguage: TComboBox;
    lblIni: TLabel;
    edIniFolder: TEdit;
    btnStorageLoc: TSpeedButton;
    btnLanguageRefresh: TPngSpeedButton;
    panProg: TPanel;
    panLang: TPanel;
    panSnd: TPanel;
    panlIniFolder: TPanel;
    lblTester: TLabel;
    lblTimeFormat: TLabel;
    cmbTimeFormat: TComboBox;
    procedure btnEdProgramClick(Sender: TObject);
    procedure btnEdDefSoundClick(Sender: TObject);
    procedure cmbLanguageChange(Sender: TObject);
    procedure btnLanguageRefresh2Click(Sender: TObject);
    procedure btnTestEmailClientClick(Sender: TObject);
    procedure btnSndTestClick(Sender: TObject);
    procedure OptionsChange(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer);
    procedure FrameResize(Sender: TObject);
    procedure btnStorageLocClick(Sender: TObject);
    procedure cmbTimeFormatChange(Sender: TObject);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure AlignLabels();
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
    procedure ShowLanguages;
  end;

implementation

uses uMain, uRCUtils, uGlobal, uTranslate, uDM, uIniSettings, Math, ShellAPI;

{$R *.dfm}

procedure TframeDefaults.cmbTimeFormatChange(Sender: TObject);
begin
  if not Options.Busy then
  begin
    // screen to options
    Options.Use24HrTime := (cmbTimeFormat.ItemIndex = 1); //second item = 24 hr time

    // enable save button
    funcEnableSaveBtn();
  end;
end;

constructor TframeDefaults.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;
  Options.Busy := True;

  // options to screen
  edProgram.Text := Options.MailProgram;
  edDefSound.Text := Options.DefSound;
  edIniFolder.Text := uIniSettings.GetSettingsFolder();
  btnTestEmailClient.Glyph.Assign(frmPopUMain.btnStartProgram.Glyph);
  ShowLanguages;
  Options.Busy := False;

  // Change images that change per scheme
  btnSndTest.Glyph := nil;
  if (Options.ToolbarColorScheme = Integer(schemeTwilight)) then
    dm.imlLtDk16.GetBitmap(1, btnSndTest.Glyph)
  else
    dm.imlLtDk16.GetBitmap(0, btnSndTest.Glyph);

  Self.Font.Assign(Options.GlobalFont);

  TranslateComponentFromEnglish(self);
  AlignLabels();
end;

procedure TframeDefaults.ShowLanguages;
var
  i : integer;
  langs : TStringList;
  currentLangName: String;
begin
  langs := TStringList.Create;
  try
    // copy languages from options to stringlist
    for i := Low(Options.Languages)+1 to High(Options.Languages) do //exclude english when adding here
      langs.Add(Options.Languages[i]);
    langs.Sort;
    langs.Insert(0,Options.Languages[0]); // now add english to make it always first

    currentLangName := Options.Languages[Options.Language];

    // copy from stringlist to combo-box
    cmbLanguage.Items.Assign(langs);
    cmbLanguage.ItemIndex := cmbLanguage.Items.IndexOf(currentLangName);
  finally
    langs.Free;
  end;
end;

procedure TframeDefaults.OptionsChange(Sender: TObject);
begin
  if not Options.Busy then
  begin
    // screen to options
    Options.MailProgram := edProgram.Text;
    Options.DefSound := edDefSound.Text;

    // enable save button
    funcEnableSaveBtn();
  end;
end;

procedure TframeDefaults.btnEdProgramClick(Sender: TObject);
var
  dlgOpen : TOpenDialog;
begin
  dlgOpen := TOpenDialog.Create(nil);
  try
    dlgOpen.InitialDir := ExtractFileDir(edProgram.Text);
    dlgOpen.Filter := Translate('EXE files')+' (*.exe)|*.exe|'+
                      Translate('All Files')+' (*.*)|*.*';
    if dlgOpen.Execute then
    begin
      edProgram.Text := dlgOpen.FileName;
      GetBitmapFromFileIcon(edProgram.Text,btnTestEmailClient.Glyph,True);
    end;
  finally
    dlgOpen.Free;
  end;
end;

procedure TframeDefaults.btnEdDefSoundClick(Sender: TObject);
var
  dlgOpen : TOpenDialog;
begin
  dlgOpen := TOpenDialog.Create(nil);
  try
    dlgOpen.InitialDir := ExtractFileDir(edDefSound.Text);
    if dlgOpen.InitialDir='' then
       dlgOpen.InitialDir := ExtractFilePath(Application.ExeName)+'Sounds';  
    dlgOpen.Filter := Translate('WAV files')+' (*.wav)|*.WAV';
    if dlgOpen.Execute then
    begin
      edDefSound.Text := dlgOpen.FileName;
    end;
  finally
    dlgOpen.Free;
  end;
end;

procedure TframeDefaults.cmbLanguageChange(Sender: TObject);
var
  i : integer;
  langEnglish, langTranslated : string;
begin
  // screen to options

  langTranslated := cmbLanguage.Text ;
  langEnglish := TranslateToEnglish(cmbLanguage.Text);

  //bugfix...if English somehow got translated, and english is selected, force it back into english
  if TranslateToEnglish(langTranslated) = 'English' then begin
    Options.Language := 0;
  end
  else
    for i := Low(Options.Languages) to High(Options.Languages) do
      if Options.Languages[i] = langEnglish then
      begin
        Options.Language := i;
        Break;
      end;

  // enable save button
  funcEnableSaveBtn();
end;

procedure TframeDefaults.btnLanguageRefresh2Click(Sender: TObject);
begin
  RefreshLanguages;
  ShowLanguages;
  //FrmPopUMain.
end;

procedure TframeDefaults.btnTestEmailClientClick(Sender: TObject);
begin
  frmPopUMain.ExecuteProgram;
end;

procedure TframeDefaults.btnSndTestClick(Sender: TObject);
begin
  PlayWav(Options.DefSound);
end;


procedure TframeDefaults.btnStorageLocClick(Sender: TObject);
var
  iniPathAsStr : string;
begin
  iniPathAsStr := IniPath;
  ShellExecute(Application.Handle, nil, 'explorer.exe', PChar(iniPathAsStr), nil, SW_NORMAL);
end;

procedure TframeDefaults.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

procedure TframeDefaults.AlignLabels();
const
  BTN_IMG_OFFSET = 30;
  BTN_REFRESH_MIN_WIDTH = 99;
  BTN_DOT_MIN_WIDTH = 19;
  BTN_TEST_MIN_WIDTH = 74;
  BTN_SPACING = 8;
var
  testButtonsWidth : integer;
  rightPos : integer;
begin
  // Buttons need to be at least as big as their captions
  lblTester.Caption := btnLanguageRefresh.Caption;
  btnLanguageRefresh.ClientWidth := lblTester.Width + BTN_IMG_OFFSET;

  lblTester.Caption := btnTestEmailClient.Caption;
  btnTestEmailClient.ClientWidth := lblTester.Width + BTN_IMG_OFFSET;

  lblTester.Caption := btnSndTest.Caption;
  btnSndTest.ClientWidth := lblTester.Width + BTN_IMG_OFFSET;

  lblTester.Caption := '...';
  btnEdProgram.ClientWidth  := Max(lblTester.Width + 4, BTN_DOT_MIN_WIDTH);
  btnEdDefSound.ClientWidth := Max(lblTester.Width + 4, BTN_DOT_MIN_WIDTH);

  testButtonsWidth := Max(btnTestEmailClient.Width, btnSndTest.Width);
  if (testButtonsWidth + btnEdProgram.Width + BTN_SPACING) > btnLanguageRefresh.Width then
  begin
    //width determined by test buttons width
    btnTestEmailClient.Width  := Max(testButtonsWidth, BTN_TEST_MIN_WIDTH);
    btnSndTest.Width := btnTestEmailClient.Width;
    btnLanguageRefresh.Width := btnTestEmailClient.Width + btnEdProgram.Width + BTN_SPACING;
  end else begin
    // width determined by language refresh button width
    btnLanguageRefresh.Width := Max(btnLanguageRefresh.Width, BTN_REFRESH_MIN_WIDTH);
    btnTestEmailClient.Width := btnLanguageRefresh.Width - btnEdProgram.Width - BTN_SPACING;
    btnSndTest.Width := btnTestEmailClient.Width;
  end;

  btnLanguageRefresh.Left := self.ClientWidth - btnLanguageRefresh.width;
  btnTestEmailClient.Left := self.ClientWidth - btnTestEmailClient.Width;
  btnSndTest.Left := self.ClientWidth - btnSndTest.Width;
  btnEdProgram.Left := btnTestEmailClient.left - BTN_SPACING - btnEdProgram.width;
  btnEdDefSound.Left := btnSndTest.Left - BTN_SPACING - btnEdDefSound.Width;


  edProgram.width   := Self.ClientWidth - btnLanguageRefresh.Width - BTN_SPACING;
  edDefSound.width  := Self.ClientWidth - btnLanguageRefresh.Width - BTN_SPACING;



  cmbLanguage.Width := Self.ClientWidth - btnLanguageRefresh.Width - BTN_SPACING;
  edIniFolder.Width := Self.ClientWidth - btnStorageLoc.Width - BTN_SPACING;

  cmbLanguage.Top := lblLang.Height + lblLang.Margins.Bottom;
  btnLanguageRefresh.Height := cmbLanguage.Height;
  btnLanguageRefresh.Top := cmbLanguage.Top;
  panLang.Height := cmbLanguage.Top + cmbLanguage.Height + cmbLanguage.Margins.Bottom + 6;

  edProgram.Top := lblProgram.Height + lblProgram.Margins.Bottom;
  btnEdProgram.Top := edProgram.Top;
  btnEdProgram.Height := cmbLanguage.Height;
  btnTestEmailClient.Top := btnEdProgram.Top;
  btnTestEmailClient.Height := btnEdProgram.Height;
  panProg.Height := btnEdProgram.Top + btnEdProgram.Height + btnEdProgram.Margins.Bottom + 6;

  edDefSound.Top := lblSound.Top + lblSound.Height + lblSound.Margins.Bottom;
  btnEdDefSound.Top := edDefSound.Top;
  btnEdDefSound.Height := edDefSound.Height;
  btnSndTest.Top := btnEdDefSound.Top;
  btnSndTest.Height := btnEdDefSound.Height;
  panSnd.Height := edDefSound.Top + edDefSound.Height + edDefSound.Margins.Bottom + 6;

  edIniFolder.Top := lblIni.Top + lblIni.Height + lblIni.Margins.Bottom;
  btnStorageLoc.Top := edIniFolder.Top;
  btnStorageLoc.Height := edIniFolder.Height;
  panlIniFolder.Height := edIniFolder.Top + edIniFolder.Height + edIniFolder.Margins.Bottom + 6;

  lblTimeFormat.Top := panlIniFolder.Top + panlIniFolder.Height + lblIni.Margins.Bottom;
  rightPos := cmbTimeFormat.Left + cmbTimeFormat.Width;
  cmbTimeFormat.Left := lblTimeFormat.Left + lblTimeFormat.Width + BTN_SPACING;
  cmbTimeFormat.Width := rightPos - cmbTimeFormat.Left;
  cmbTimeFormat.Top := lblTimeFormat.Top - 3;

end;

procedure TframeDefaults.FrameResize(Sender : TObject);
begin
  AlignLabels();
end;

end.



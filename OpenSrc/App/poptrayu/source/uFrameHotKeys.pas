unit uFrameHotKeys;

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
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ImgList, Vcl.Imaging.pngimage;

type
  TEnableSaveOptionsFunction = procedure of object;

type
  TframeHotKeys = class(TFrame)
    lblAction: TLabel;
    lblHotkey: TLabel;
    cmbAction1: TComboBox;
    cmbAction2: TComboBox;
    cmbAction3: TComboBox;
    cmbAction4: TComboBox;
    hkHotKey1: THotKey;
    hkHotKey2: THotKey;
    hkHotKey3: THotKey;
    hkHotKey4: THotKey;
    imgInfo: TImage;
    labelHotKeyInfo: TLabel;
    InfoPanel: TPanel;
    procedure OptionsChange(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure AlignLabels;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
  end;

implementation

uses uMain, uGlobal, uTranslate;

{$R *.dfm}

{ TframeHotKeys }

constructor TframeHotKeys.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
var
  i : integer;
  st : string;
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;

  // fill action dropdowns
  for i := Low(Actions) to High(Actions) do
  begin
    st := Actions[i];
    cmbAction1.Items.Add(st);
    cmbAction2.Items.Add(st);
    cmbAction3.Items.Add(st);
    cmbAction4.Items.Add(st);
  end;
  // options to screen
  Options.Busy := True;
  cmbAction1.ItemIndex := Options.Action1;
  cmbAction2.ItemIndex := Options.Action2;
  cmbAction3.ItemIndex := Options.Action3;
  cmbAction4.ItemIndex := Options.Action4;
  hkHotKey1.HotKey := Options.HotKey1;
  hkHotKey2.HotKey := Options.HotKey2;
  hkHotKey3.HotKey := Options.HotKey3;
  hkHotKey4.HotKey := Options.HotKey4;
  Options.Busy := False;

  Self.Font.Assign(Options.GlobalFont);

  TranslateComponentFromEnglish(Self);
  AlignLabels();
  //TODO: autosize info panel... InfoPanel.Height := labelHotKeyInfo.Height + 4;
end;

procedure TframeHotKeys.FrameResize(Sender: TObject);
begin
  InfoPanel.Height := labelHotKeyInfo.Top + labelHotKeyInfo.Height + 5;
  self.Height := InfoPanel.Top + InfoPanel.Height + 10;

  if (lblHotkey.Width > hkHotKey1.Width) then begin
    // outside edge align columns
    lblAction.Left := cmbAction1.Left;
    lblHotkey.Left := hkHotKey1.Left + hkHotKey1.Width - lblHotkey.Width;
  end else begin
    // center align columns
    lblAction.Left := cmbAction1.Left + ((cmbAction1.Width - lblAction.Width) div 2);
    lblHotkey.Left := hkHotKey1.Left + ((hkHotKey1.Width - lblHotkey.Width) div 2);
  end;

end;

procedure TframeHotKeys.OptionsChange(Sender: TObject);
begin
  if not Options.Busy then
  begin
    // screen to options
    Options.Action1 := cmbAction1.ItemIndex;
    Options.Action2 := cmbAction2.ItemIndex;
    Options.Action3 := cmbAction3.ItemIndex;
    Options.Action4 := cmbAction4.ItemIndex;
    Options.HotKey1 := hkHotKey1.HotKey;
    Options.HotKey2 := hkHotKey2.HotKey;
    Options.HotKey3 := hkHotKey3.HotKey;
    Options.HotKey4 := hkHotKey4.HotKey;

    // enable save button
    funcEnableSaveBtn();
  end;
end;

procedure TframeHotKeys.AlignLabels();
const
  vMargin = 4;
begin

  cmbAction1.Top := lblAction.Top + lblAction.Height + vMargin;
  cmbAction2.Top := cmbAction1.Top + cmbAction1.Height + vMargin;
  cmbAction3.Top := cmbAction2.Top + cmbAction2.Height + vMargin;
  cmbAction4.Top := cmbAction3.Top + cmbAction3.Height + vMargin;

  hkHotKey1.Top := cmbAction1.Top;
  hkHotKey2.Top := cmbAction2.Top;
  hkHotKey3.Top := cmbAction3.Top;
  hkHotKey4.Top := cmbAction4.Top;

  hkHotKey1.Height := cmbAction1.Height;
  hkHotKey2.Height := cmbAction2.Height;
  hkHotKey3.Height := cmbAction3.Height;
  hkHotKey4.Height := cmbAction4.Height;

  InfoPanel.Top := cmbAction4.Top + cmbAction4.Height + vMargin;
  InfoPanel.Height := labelHotKeyInfo.Top + labelHotKeyInfo.Height + 5;
  self.Height := InfoPanel.Top + InfoPanel.Height + 10;

end;

procedure TframeHotKeys.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

end.

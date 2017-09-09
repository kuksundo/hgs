unit uFrameGeneralOptions;

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
  Dialogs, StdCtrls, ExtCtrls, System.UITypes, Vcl.Grids, Vcl.ValEdit;

type
  TEnableSaveOptionsFunction = procedure of object;

type
  TframeGeneralOptions = class(TFrame)
    chkMinimized: TCheckBox;
    chkAnimated: TCheckBox;
    chkResetTray: TCheckBox;
    chkStartUp: TCheckBox;
    chkShowForm: TCheckBox;
    chkRotateIcon: TCheckBox;
    chkBalloon: TCheckBox;
    lblFirstWait: TLabel;
    edFirstWait: TEdit;
    lblSeconds: TLabel;
    cmbCheckingIcon: TComboBox;
    lblTrayIcon: TLabel;
    lblAdvInfoDelay: TLabel;
    chkDeluxeBalloon: TCheckBox;
    edAdvInfoDelay: TEdit;
    lblAdvInfoShowFor: TLabel;
    CategoryPanelGroup1: TCategoryPanelGroup;
    catStartup: TCategoryPanel;
    catTrayIcon: TCategoryPanel;
    catNotification: TCategoryPanel;
    procedure OptionsChange(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure ShowFirstWait;
    procedure AlignLabels;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
  end;

implementation

uses uMain, uGlobal, uRCUtils, uTranslate, uPositioning;

{$R *.dfm}

{ TframeGeneralOptions }

constructor TframeGeneralOptions.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;

  Options.Busy := True;
  // options to screen
  chkStartUp.Checked := Options.StartUp;
  edFirstWait.Text := IntToStr(Options.FirstWait);
  chkMinimized.Checked := Options.Minimized;
  chkAnimated.Checked := Options.Animated;
  chkResetTray.Checked := Options.ResetTray;
  chkRotateIcon.Checked := Options.RotateIcon;
  cmbCheckingIcon.ItemIndex := Options.CheckingIcon;
  chkShowForm.Checked := Options.ShowForm;
  chkBalloon.Checked := Options.Balloon;
  chkDeluxeBalloon.Checked := Options.AdvInfo;
  edAdvInfoDelay.Text := IntToStr(Options.AdvInfoDelay);
  Options.Busy := False;


  // Fix fonts
  self.Font.Assign(Options.GlobalFont);

  CategoryPanelGroup1.HeaderFont.Assign(Options.GlobalFont);
  CategoryPanelGroup1.HeaderFont.Style := CategoryPanelGroup1.HeaderFont.Style + [fsBold];
  CategoryPanelGroup1.HeaderFont.Size := Options.GlobalFont.Size;

  TranslateComponentFromEnglish(self);
  AlignLabels();


  ShowFirstWait;

end;

procedure TframeGeneralOptions.FrameResize(Sender: TObject);
begin
  AlignLabels();
end;

procedure TframeGeneralOptions.AlignLabels;
const
  vMargin = 3;
  hMargin = 10;
  gutter = 4;
  indentSubItemsAmount = 30;
var
  labelHeight : Integer;
  //flowDirection : TFlowStyle;
begin
  AutoSizeCheckBox(chkDeluxeBalloon); // b/c this one has a label to it's right
  AutosizeCombobox(cmbCheckingIcon, 110);

  labelHeight := lblFirstWait.Height;

  chkStartUp.Height := labelHeight;              // Row 1
  chkMinimized.Height := labelHeight;            // Row 3

  chkRotateIcon.Height := labelHeight;
  chkResetTray.Height := labelHeight;

  chkAnimated.Height := labelHeight;
  chkShowForm.Height := labelHeight;
  chkBalloon.Height := labelHeight;
  chkDeluxeBalloon.Height := labelHeight;

  // Startup section Labels

  //chkStartUp.Top := (default)                  // Row 1
    edFirstWait.Top := calcPosBelow(chkStartUp); // Row 2
    lblFirstWait.Top := edFirstWait.Top + 3;
    lblSeconds.Top := edFirstWait.Top + 3;
  chkMinimized.Top := calcPosBelow(edFirstWait); // Row 3
  catStartup.ClientHeight := calcPosBelow(chkMinimized);

  // Tray Icon section labels
  //chkRotateIcon.Top := (default)
  chkResetTray.Top := calcPosBelow(chkRotateIcon);
  cmbCheckingIcon.Top := calcPosBelow(chkResetTray);
  cmbCheckingIcon.Left := CalcPosToRightOf(lblTrayIcon);
  lblTrayIcon.Top := cmbCheckingIcon.Top + 3;
  catTrayIcon.ClientHeight := calcPosBelow(cmbCheckingIcon) + 3; //extra margin to look more even with other components

  // new message notification section labels
  //chkAnimated.Top := (default)
  chkShowForm.Top := calcPosBelow(chkAnimated);
  chkBalloon.Top := calcPosBelow(chkShowForm);
  chkDeluxeBalloon.Top := calcPosBelow(chkBalloon);
    edAdvInfoDelay.Top := chkDeluxeBalloon.Top - 3;
    lblAdvInfoDelay.Top := chkDeluxeBalloon.Top;
    lblAdvInfoShowFor.Top := chkDeluxeBalloon.Top;
  catNotification.ClientHeight := calcPosBelow(edAdvInfoDelay);

  // Left-right positioning
  if (Application.BiDiMode = bdLeftToRight) then begin
    // left align - Western languages
    //lblStartup.Left := gutter;
    //chkStartUp.Left := gutter;
    //chkMinimized.Left := gutter;

    cmbCheckingIcon.Left := lblTrayIcon.Left + lblTrayIcon.Width + hMargin;

    lblAdvInfoShowFor.Left := chkDeluxeBalloon.Left + chkDeluxeBalloon.Width + hMargin + hMargin;

    edFirstWait.Left := lblFirstWait.Left + lblFirstWait.Width + 3;
    lblSeconds.Left := edFirstWait.Left + edFirstWait.Width + 3;
    cmbCheckingIcon.Left := lblTrayIcon.Left + lblTrayIcon.Width + 3;

    lblAdvInfoShowFor.Left := chkDeluxeBalloon.Left + chkDeluxeBalloon.Width + 3;
    edAdvInfoDelay.Left := lblAdvInfoShowFor.Left + lblAdvInfoShowFor.Width + 3;
    lblAdvInfoDelay.Left := edAdvInfoDelay.Left + edAdvInfoDelay.Width + 3;

  end else begin
    // Right align - RTL languages (Hebrew, Arabic)

    chkStartUp.Left      := Self.Width - chkStartUp.Width - gutter;
      lblFirstWait.Left    := Self.Width - lblFirstWait.Width - gutter - indentSubItemsAmount;
      edFirstWait.Left   := lblFirstWait.Left - edFirstWait.Width - vMargin;
      lblSeconds.Left    := edFirstWait.Left - lblSeconds.Width - vMargin;
    chkMinimized.Left    := Self.Width - chkMinimized.Width - gutter;

    chkRotateIcon.Left   := Self.Width - chkRotateIcon.Width - gutter;
    chkResetTray.Left    := Self.Width - chkResetTray.Width - gutter;
      lblTrayIcon.Left     := Self.Width - lblTrayIcon.Width - gutter - indentSubItemsAmount; //indent
      cmbCheckingIcon.Left := lblTrayIcon.Left - cmbCheckingIcon.Width - hMargin; //to left of lblTrayIcon

    chkAnimated.Left         := Self.Width - chkAnimated.Width - gutter;
    chkShowForm.Left         := Self.Width - chkShowForm.Width - gutter;
    chkDeluxeBalloon.Left    := Self.Width - chkDeluxeBalloon.Width - gutter - indentSubItemsAmount;
      lblAdvInfoShowFor.Left := chkDeluxeBalloon.Left - lblAdvInfoShowFor.Width - 10;
      edAdvInfoDelay.Left    := lblAdvInfoShowFor.Left - edAdvInfoDelay.Width - 3;
      lblAdvInfoDelay.Left := edAdvInfoDelay.Left - lblAdvInfoDelay.Width - 3;

  end;

end;

procedure TframeGeneralOptions.ShowFirstWait;
begin
  // firstwait
  edFirstWait.Enabled := Options.StartUp;
  if edFirstWait.Enabled then
  begin
    edFirstWait.Color := clWindow;
    if edFirstWait.Text = '' then edFirstWait.Text := '0';
  end
  else begin
    edFirstWait.Color := clBtnFace;
    edFirstWait.Text := '';
  end;
  // labels
  lblFirstWait.Enabled := Options.StartUp;
  lblSeconds.Enabled := Options.StartUp;
end;

procedure TframeGeneralOptions.OptionsChange(Sender: TObject);
begin
  // Enable/disable controls
  EnableControl(chkDeluxeBalloon, chkBalloon.Checked);
  EnableControl(edAdvInfoDelay,chkDeluxeBalloon.Checked AND chkBalloon.Checked);
  lblAdvInfoShowFor.Enabled := chkDeluxeBalloon.Checked AND chkBalloon.Checked;
  lblAdvInfoDelay.Enabled := chkDeluxeBalloon.Checked AND chkBalloon.Checked;

  if not Options.Busy then
  begin
    // screen to options
    Options.StartUp := chkStartUp.Checked;
    Options.FirstWait := StrToIntDef(edFirstWait.Text,0);
    Options.Minimized := chkMinimized.Checked;
    Options.Animated := chkAnimated.Checked;
    Options.ResetTray := chkResetTray.Checked;
    Options.RotateIcon := chkRotateIcon.Checked;
    Options.CheckingIcon := cmbCheckingIcon.ItemIndex;
    Options.ShowForm := chkShowForm.Checked;
    Options.Balloon := chkBalloon.Checked;
    Options.AdvInfo := chkDeluxeBalloon.Checked;
    Options.AdvInfoDelay := StrToIntDef(edAdvInfoDelay.Text,0);
    ShowFirstWait;

    // enable save button
    funcEnableSaveBtn();
  end;
end;

procedure TframeGeneralOptions.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

end.

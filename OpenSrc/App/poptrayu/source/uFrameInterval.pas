unit uFrameInterval;

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
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, System.UITypes;

type
  TEnableSaveOptionsFunction = procedure of object;

const
  DELETE_IMMEDIATELY = 0;
  DELETE_NEXT_CHECK = 1;

type
  TframeInterval = class(TFrame)
    lblMinutes: TLabel;
    edTime: TEdit;
    UpDown: TUpDown;
    lblAnd: TLabel;
    chkDontCheckTimes: TCheckBox;
    dtStart: TDateTimePicker;
    dtEnd: TDateTimePicker;
    radioCheckEvery: TRadioButton;
    radioNever: TRadioButton;
    radioTimerAccount: TRadioButton;
    chkOnline: TCheckBox;
    chkCheckWhileMinimized: TCheckBox;
    CategoryPanelGroup1: TCategoryPanelGroup;
    catMailCheckFreq: TCategoryPanel;
    catIntervalConditions: TCategoryPanel;
    catCheckActions: TCategoryPanel;
    cmbDeleteNextCheck: TComboBox;
    lblDeleteNextCheck: TLabel;
    chkDeleteConfirm: TCheckBox;
    procedure OptionsChange(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure chkDontCheckTimesClick(Sender: TObject);
    procedure radioNeverClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure AlignLabels();
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
  end;

implementation

uses uMain, uGlobal, uRCUtils, uTranslate, uPositioning;

{$R *.dfm}

//-----------------------------------------------------------------[ public ]---

constructor TframeInterval.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;

  Options.Busy := True;
  edTime.Tag := 1;
  // options to screen
  if (Options.Interval > 0) then begin
    edTime.Text := FloatToStr(Options.Interval);
  end;
  radioTimerAccount.Checked := Options.TimerAccount;
  if NOT radioTimerAccount.Checked then
  begin
    radioCheckEvery.Checked := Options.Interval > 0;
    radioNever.Checked := Options.Interval <= 0;
  end;
  edTime.Enabled := radioCheckEvery.Checked;
  UpDown.Enabled := radioCheckEvery.Checked;

  if radioNever.Checked then
  begin
    // set DISABLED timer interval to default value
    edTime.Text := '5';
    UpDown.Position := 5;
  end;

  chkOnline.Checked := Options.Online;

  chkCheckWhileMinimized.Checked := Options.CheckWhileMinimized;

  chkDontCheckTimes.Checked := Options.DontCheckTimes;
  dtStart.Time := Options.DontCheckStart;
  dtEnd.Time := Options.DontCheckEnd;

  if (Options.DeleteNextCheck) then
    cmbDeleteNextCheck.ItemIndex := DELETE_NEXT_CHECK
  else
    cmbDeleteNextCheck.ItemIndex := DELETE_IMMEDIATELY;

  chkDeleteConfirm.Checked := Options.DeleteConfirm;


  Options.Busy := False;

  self.Font.Assign(Options.GlobalFont);

  CategoryPanelGroup1.HeaderFont.Assign(Options.GlobalFont);
  CategoryPanelGroup1.HeaderFont.Style := CategoryPanelGroup1.HeaderFont.Style + [fsBold];
  CategoryPanelGroup1.HeaderFont.Size := Options.GlobalFont.Size;

  TranslateComponentFromEnglish(self);

  AlignLabels();
end;


//-----------------------------------------------------------------[ events ]---

procedure TframeInterval.OptionsChange(Sender: TObject);
begin
  if not Options.Busy then
  begin
    // screen to options

    //here Options.Inteveral = previous interval before we update it below
    if (Options.Interval > 0) and (radioNever.Checked) then
    begin
      // turning off auto-checking
      frmPopUMain.actAutoCheck.Enabled := false;
      frmPopUMain.actAutoCheck.Checked := false;
      frmPopUMain.actAutoCheck.Caption := Translate('A&utoCheck Disabled');
    end else if (Options.Interval = 0) and (not radioNever.Checked) then
    begin
      // turning on auto-checking
      frmPopUMain.actAutoCheck.Enabled := true;
      frmPopUMain.actAutoCheck.Checked := true;
      frmPopUMain.actAutoCheck.Caption := Translate('A&utoCheck Enabled');
    end;

    // now update Options.Interval
    if (radioNever.Checked) then begin
      Options.Interval := 0
    end else
      Options.Interval := StrToFloatDef(edTime.Text,5); //UpDown.Position;

    Options.TimerAccount := radioTimerAccount.Checked;

    Options.Online := chkOnline.Checked;
    Options.CheckWhileMinimized := chkCheckWhileMinimized.Checked;
    Options.DontCheckTimes := chkDontCheckTimes.Checked;
    Options.DontCheckStart := dtStart.Time;
    Options.DontCheckEnd := dtEnd.Time;

    Options.DeleteNextCheck := cmbDeleteNextCheck.ItemIndex = DELETE_NEXT_CHECK;
    Options.DeleteConfirm := chkDeleteConfirm.Checked;

    // buttons
    if (Sender = edTime) and (edTime.Tag = 1) then
      edTime.Tag := 0
    else
    begin
      // enable save button
      funcEnableSaveBtn();
    end;
  end;

  frmPopUMain.AccountsForm.panIntervalAccount.Visible := Options.TimerAccount;

  edTime.Enabled := radioCheckEvery.Checked;
  UpDown.Enabled := radioCheckEvery.Checked;

end;

procedure TframeInterval.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

procedure TframeInterval.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  UpDown.Position := round(Options.Interval);
  UpDown.Associate := edTime;
  OptionsChange(UpDown);
end;

procedure TframeInterval.chkDontCheckTimesClick(Sender: TObject);
begin
  dtStart.Enabled := chkDontCheckTimes.Checked;
  dtEnd.Enabled := chkDontCheckTimes.Checked;
  OptionsChange(chkDontCheckTimes);
end;


procedure TframeInterval.radioNeverClick(Sender: TObject);
begin
  OptionsChange(UpDown);
end;

procedure TframeInterval.AlignLabels();
var
  labelHeight : integer;
begin
  labelHeight := lblAnd.Height;

  // Mail Check Category
  AutoSizeCheckBox(radioCheckEvery);
  edTime.Top := radioCheckEvery.Top;
  edTime.Height := labelHeight;
  edTime.Left := radioCheckEvery.Left + radioCheckEvery.Width + 4;
  UpDown.Height := edTime.Height;
  UpDown.Top := edTime.Top;
  UpDown.Left := edTime.Left + edTime.Width;
  lblMinutes.Top := radioCheckEvery.Top;
  lblMinutes.Left := CalcPosToRightOf(UpDown);
  radioNever.Height := labelHeight;
  radioNever.Top := calcPosBelow(radioCheckEvery);
  radioTimerAccount.Height := labelHeight;
  radioTimerAccount.Top := calcPosBelow(radioNever);
  catMailCheckFreq.ClientHeight := calcPosBelow(radioTimerAccount);

  // Automatic Check Conditions Cateory
  chkOnline.Height := labelHeight;
  chkCheckWhileMinimized.Top := calcPosBelow(chkOnline);
  chkCheckWhileMinimized.Height := labelHeight;
  AutoSizeCheckBox(chkDontCheckTimes);
  chkDontCheckTimes.Top := calcPosBelow(chkCheckWhileMinimized);
  chkDontCheckTimes.Height := labelHeight;
  dtStart.Top := chkDontCheckTimes.Top;
  dtStart.Left := chkDontCheckTimes.Left + chkDontCheckTimes.Width + 2;
  dtStart.Height := labelHeight;
  lblAnd.Top := chkDontCheckTimes.Top;
  lblAnd.Left := dtStart.Left + dtStart.Width + 4;
  dtEnd.Top := chkDontCheckTimes.Top;
  dtEnd.Height := labelHeight;
  dtEnd.Left := lblAnd.Left + lblAnd.Width + 4;
  catIntervalConditions.ClientHeight := calcPosBelow(dtStart);

  // Check Actions Category
  AutosizeCombobox(cmbDeleteNextCheck);
  if (lblDeleteNextCheck.Width + cmbDeleteNextCheck.Width + 6 < self.Width) then begin
    lblDeleteNextCheck.Top := 9;
    cmbDeleteNextCheck.Top := 6;
    cmbDeleteNextCheck.Left := CalcPosToRightOf(lblDeleteNextCheck);
  end else begin
    // wrap
    lblDeleteNextCheck.Top := 6;
    cmbDeleteNextCheck.Left := lblDeleteNextCheck.Left;
    cmbDeleteNextCheck.Top := calcPosBelow(lblDeleteNextCheck);
  end;
  chkDeleteConfirm.Height := labelHeight;
  chkDeleteConfirm.Top := calcPosBelow(cmbDeleteNextCheck);
  catCheckActions.ClientHeight := calcPosBelow(chkDeleteConfirm) + 3;


end;

procedure TframeInterval.FrameResize(Sender: TObject);
begin
  inherited;
  AlignLabels();
end;

end.

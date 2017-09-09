unit uFrameMainWindowOptions;

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
  Dialogs, StdCtrls, ExtCtrls;

type
  TEnableSaveOptionsFunction = procedure of object;

const
  SHOW_ERR_IN_BALOONS = 0;
  SHOW_ERR_IN_DLG = 1;
  SHOW_ERR_IN_STATUSBAR = 2;

type
  TframeMainWindowOptions = class(TFrame)
    chkOnTop: TCheckBox;
    chkDoubleClickDelay: TCheckBox;
    chkPasswordProtect: TCheckBox;
    edPassword: TEdit;
    chkShowViewed: TCheckBox;
    chkMultilineAccounts: TCheckBox;
    chkHideViewed: TCheckBox;
    chkShowWhileChecking: TCheckBox;
    chkRememberViewed: TCheckBox;
    lblDefaultSpamAct: TLabel;
    cmbSpamAct: TComboBox;
    chkDateFormat: TCheckBox;
    edDateFormat: TEdit;
    lblDateExample: TLabel;
    chkLimitInboxSize: TCheckBox;
    cmbInboxSize: TComboBox;
    lblNumMsgs: TLabel;
    lblErrorDisp: TLabel;
    cmbErrorDisplay: TComboBox;
    CategoryPanelGroup1: TCategoryPanelGroup;
    catMsgList: TCategoryPanel;
    catBehaviors: TCategoryPanel;
    catMinimize: TCategoryPanel;
    chkCloseMinimize: TCheckBox;
    chkMinimizeTray: TCheckBox;
    chkAutoClosePreviewWindows: TCheckBox;
    procedure OptionsChange(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FrameResize(Sender: TObject);
    procedure cmbInboxSizeExit(Sender: TObject);
    procedure cmbInboxSizeChange(Sender: TObject);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    mInboxSizeValid : boolean;
    procedure AlignLabels;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
  end;

implementation

uses uMain, uGlobal, uRCUtils, uTranslate, System.UITypes, uPositioning;

{$R *.dfm}

// OnChange handler
procedure TframeMainWindowOptions.cmbInboxSizeChange(Sender: TObject);
var
  numMsgs : Integer;
begin
  try
    numMsgs := StrToInt(cmbInboxSize.Text);

    if numMsgs <= 0 then begin
      MessageDlg(String('''' + lblNumMsgs.Caption + ''' ' + uTranslate.Translate('must be more than zero.')), mtError, [mbOK], 0);
      mInboxSizeValid := false;
    end else begin
      mInboxSizeValid := true
    end;
  except
  on Exception : EConvertError do
    begin
      MessageDlg(String('''' + lblNumMsgs.Caption + ''' ' + uTranslate.Translate('must be numeric.')), mtError, [mbOK], 0);
      mInboxSizeValid := false;
    end;
  end;
  if mInboxSizeValid then
    OptionsChange(Sender);
end;

procedure TframeMainWindowOptions.cmbInboxSizeExit(Sender: TObject);
begin
  if mInboxSizeValid then
    OptionsChange(Sender);
end;


constructor TframeMainWindowOptions.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
var
  i: integer;
  s: string;
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;


  Options.Busy := True;

  for i := 0 to cmbSpamAct.Items.Count-1 do
    cmbSpamAct.Items[i] := Translate(cmbSpamAct.Items[i]);

  // options to screen
  chkShowViewed.Checked := Options.ShowViewed;
  chkRememberViewed.Checked := Options.RememberViewed;
  chkCloseMinimize.Checked := Options.CloseMinimize;
  chkDoubleClickDelay.Checked := Options.DoubleClickDelay;
  chkMinimizeTray.Checked := Options.MinimizeTray;
  chkMultilineAccounts.Checked := Options.MultilineAccounts;
  chkPasswordProtect.Checked := Options.PasswordProtect;
  edPassword.Text := Options.Password;
  chkOnTop.Checked := Options.OnTop;
  chkHideViewed.Checked := Options.HideViewed;
  chkShowWhileChecking.Checked := Options.ShowWhileChecking;
  cmbSpamAct.ItemIndex := Options.ToolbarSpamAction;
  edDateFormat.Text := Options.CustomDateFormatString;
  chkDateFormat.Checked := Options.UseCustomDateFormat;
  chkAutoClosePreviewWindows.Checked := Options.AutoClosePreviewWindows;
  chkLimitInboxSize.Checked := Options.ShowNewestMessagesOnly;
  cmbInboxSize.Text := IntToStr(Options.NumNewestMsgToShow);

  //chkShowErrorsInBalloons.Checked := Options.ShowErrorsInBalloons;
  if (Options.NoError) then
    cmbErrorDisplay.ItemIndex := SHOW_ERR_IN_STATUSBAR
  else if (Options.ShowErrorsInBalloons) then
    cmbErrorDisplay.ItemIndex := SHOW_ERR_IN_BALOONS
  else
    cmbErrorDisplay.ItemIndex := SHOW_ERR_IN_DLG;

  Options.Busy := False;

  self.Font.Assign(Options.GlobalFont);
  CategoryPanelGroup1.HeaderFont.Assign(Options.GlobalFont);
  CategoryPanelGroup1.HeaderFont.Style := CategoryPanelGroup1.HeaderFont.Style + [fsBold];
  CategoryPanelGroup1.HeaderFont.Size := Options.GlobalFont.Size;

  DateTimeToString(s, edDateFormat.Text, Now );
  lblDateExample.Caption := s;

  TranslateComponentFromEnglish(self);

  AlignLabels();

  lblNumMsgs.Enabled := chkLimitInboxSize.Checked;
  cmbInboxSize.Enabled := chkLimitInboxSize.Checked;

  cmbSpamAct.Left := lblDefaultSpamAct.Left + lblDefaultSpamAct.Width + 4;

end;

procedure TframeMainWindowOptions.AlignLabels;
const
  vMargin = 3;
var
  labelHeight : Integer;
begin
  labelHeight := lblNumMsgs.Height;

  // autosize checkboxes that are not on their own line
  AutoSizeCheckBox(chkDateFormat);
  AutoSizeCheckBox(chkPasswordProtect);
  AutosizeCombobox(cmbErrorDisplay);

  cmbInboxSize.Left := lblNumMsgs.Left + lblNumMsgs.Width + 4;
  edPassword.Left := chkPasswordProtect.Left + chkPasswordProtect.Width + 4;
  edDateFormat.Left := chkDateFormat.Left + chkDateFormat.Width + 4;
  lblDateExample.Left := edDateFormat.Left + edDateFormat.Width + 4;
  cmbErrorDisplay.Left := lblErrorDisp.Left + lblErrorDisp.Width + 4;

  // Message List Category
  chkShowViewed.Height := labelHeight;
  chkRememberViewed.Height := labelHeight;
  chkRememberViewed.Top := calcPosBelow(chkShowViewed);
  chkHideViewed.Height := labelHeight;
  chkHideViewed.Top := calcPosBelow(chkRememberViewed);
  chkShowWhileChecking.Height := labelHeight;
  chkShowWhileChecking.Top := calcPosBelow(chkHideViewed);
  chkDateFormat.Height := labelHeight;
  chkDateFormat.Top := calcPosBelow(chkShowWhileChecking);
  edDateFormat.Top := chkDateFormat.Top - 3;
  lblDateExample.Top := chkDateFormat.Top;
  chkLimitInboxSize.Height := labelHeight;
  chkLimitInboxSize.Top := calcPosBelow(chkDateFormat);
  lblNumMsgs.Top := calcPosBelow(chkLimitInboxSize);
  cmbInboxSize.Top := lblNumMsgs.Top - 3;
  catMsgList.ClientHeight := calcPosBelow(cmbInboxSize) + 3;


  // Behaviors Category
  chkOnTop.Height := labelHeight;
  chkMultilineAccounts.Height := labelHeight;
  chkMultilineAccounts.Top := calcPosBelow(chkOnTop);
  chkDoubleClickDelay.Height := labelHeight;
  chkDoubleClickDelay.Top := calcPosBelow(chkOnTop);
  chkPasswordProtect.Height := labelHeight;
  chkPasswordProtect.Top := calcPosBelow(chkDoubleClickDelay);
  edPassword.Top := chkPasswordProtect.Top - 3;
  cmbErrorDisplay.Top := calcPosBelow(edPassword);
  lblErrorDisp.Top := cmbErrorDisplay.Top + 3;
  cmbSpamAct.Top := calcPosBelow(cmbErrorDisplay);
  lblDefaultSpamAct.Top :=  cmbSpamAct.Top + 3;
  catBehaviors.ClientHeight := calcPosBelow(cmbSpamAct) + 3;

  //minimize window category
  chkCloseMinimize.Height := labelHeight;

  chkMinimizeTray.Height := labelHeight;
  chkMinimizeTray.Top := calcPosBelow(chkCloseMinimize);

  chkAutoClosePreviewWindows.Height := labelHeight;
  chkAutoClosePreviewWindows.Top := calcPosBelow(chkMinimizeTray);

  catMinimize.ClientHeight := calcPosBelow(chkAutoClosePreviewWindows);

end;

procedure TframeMainWindowOptions.OptionsChange(Sender: TObject);
var
  s: string;
begin
  // show password box
  EnableControl(edPassword,chkPasswordProtect.Checked);

  DateTimeToString(s, edDateFormat.Text, Now );
  lblDateExample.Caption := s;

  lblDateExample.Enabled := chkDateFormat.Checked;
  edDateFormat.Enabled := chkDateFormat.Checked;

  lblNumMsgs.Enabled := chkLimitInboxSize.Checked;
  cmbInboxSize.Enabled := chkLimitInboxSize.Checked;

  if not Options.Busy then
  begin
    // screen to options
    Options.ShowViewed := chkShowViewed.Checked;
    Options.RememberViewed := chkRememberViewed.Checked;
    Options.CloseMinimize := chkCloseMinimize.Checked;
    Options.DoubleClickDelay := chkDoubleClickDelay.Checked;
    Options.MinimizeTray := chkMinimizeTray.Checked;
    Options.MultilineAccounts := chkMultilineAccounts.Checked;
    Options.PasswordProtect := chkPasswordProtect.Checked;
    Options.Password := edPassword.Text;
    Options.OnTop := chkOnTop.Checked;
    Options.HideViewed := chkHideViewed.Checked;
    Options.ShowWhileChecking := chkShowWhileChecking.Checked;
    Options.ToolbarSpamAction := cmbSpamAct.ItemIndex;
    Options.CustomDateFormatString := edDateFormat.Text;
    Options.UseCustomDateFormat := chkDateFormat.Checked;
    Options.AutoClosePreviewWindows := chkAutoClosePreviewWindows.Checked;
    Options.ShowNewestMessagesOnly := chkLimitInboxSize.Checked;
    try
      Options.NumNewestMsgToShow := StrToInt(cmbInboxSize.Text);
    except
    on Exception : EConvertError do
      MessageDlg(String('''' + lblNumMsgs.Caption + ''' ' + uTranslate.Translate('must be numeric.')), mtError, [mbOK], 0);
    end;
    Options.ShowErrorsInBalloons := cmbErrorDisplay.ItemIndex = SHOW_ERR_IN_BALOONS;
    Options.NoError := cmbErrorDisplay.ItemIndex = SHOW_ERR_IN_STATUSBAR;

    // enable save button
    funcEnableSaveBtn();

    // focus password
    if (Sender = chkPasswordProtect) and edPassword.Enabled and Self.Visible then
      edPassword.SetFocus;

    frmPopUMain.SetDefaultSpamAction(Options.ToolbarSpamAction);
  end;


end;

procedure TframeMainWindowOptions.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

procedure TframeMainWindowOptions.FrameResize(Sender: TObject);
begin
    //Self.Refresh; //refresh to make labels not disappear in Vista
end;

//AlignLabels
  //chkShowErrorsInBalloons.Height := labelHeight;
  //chkShowErrorsInBalloons.Top := calcPosBelow(chkIgnoreRetrieveErrors);


end.

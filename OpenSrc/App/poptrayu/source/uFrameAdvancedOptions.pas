unit uFrameAdvancedOptions;

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
  Dialogs, StdCtrls, ExtCtrls, uTranslate;

type
  TEnableSaveOptionsFunction = procedure of object;

type
  TframeAdvancedOptions = class(TFrame)
    lblTimeOut: TLabel;
    lblSeconds: TLabel;
    chkIgnoreRetrieveErrors: TCheckBox;
    edTimeOut: TEdit;
    chkQuickCheck: TCheckBox;
    chkNoError: TCheckBox;
    chkSafeDelete: TCheckBox;
    CategoryPanelGroup1: TCategoryPanelGroup;
    catAdvProt: TCategoryPanel;
    catErrHandling: TCategoryPanel;
    catMailClient: TCategoryPanel;
    chkUseMAPI: TCheckBox;
    procedure OptionsChange(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure AlignLabels;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
  end;

implementation

uses uMain, uGlobal, uRCUtils, System.UITypes, uPositioning;

{$R *.dfm}

{ TframeAdvancedConnection }

constructor TframeAdvancedOptions.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;

  Options.Busy := True;
  // options to screen
  edTimeOut.Text := IntToStr(Options.TimeOut);
  chkQuickCheck.Checked := Options.QuickCheck;
  chkSafeDelete.Checked := Options.SafeDelete;

  chkNoError.Checked := Options.NoError;
  chkIgnoreRetrieveErrors.Checked := Options.IgnoreRetrieveErrors;

  chkUseMAPI.Checked := Options.UseMAPI;

  // autosize
  Options.Busy := False;

  self.Font.Assign(Options.GlobalFont);

  CategoryPanelGroup1.HeaderFont.Assign(Options.GlobalFont);
  CategoryPanelGroup1.HeaderFont.Style := CategoryPanelGroup1.HeaderFont.Style + [fsBold];
  CategoryPanelGroup1.HeaderFont.Size := Options.GlobalFont.Size;

  TranslateComponentFromEnglish(self);

  AlignLabels();
end;

procedure TframeAdvancedOptions.AlignLabels;
var
  labelHeight : Integer;
begin
  //AutoSizeAllCheckBox(Self);
  edTimeOut.Left := lblTimeOut.Left + lblTimeOut.Width + 4;
  lblSeconds.Left := edTimeOut.Left + edTimeOut.Width + 4;


  labelHeight := lblSeconds.Height; // height of checkboxes should be set to height of an autosized label
  chkNoError.Height := labelHeight;

  chkIgnoreRetrieveErrors.Height := labelHeight;
  chkIgnoreRetrieveErrors.Top := calcPosBelow(chkNoError);
  catErrHandling.ClientHeight := calcPosBelow(chkIgnoreRetrieveErrors);


  chkQuickCheck.Height := labelHeight;
  chkSafeDelete.Height := labelHeight;

  chkQuickCheck.Top := calcPosBelow(edTimeOut);
  chkSafeDelete.Top := calcPosBelow(chkQuickCheck);
  catAdvProt.ClientHeight := calcPosBelow(chkSafeDelete);

  chkUseMAPI.Height := labelHeight;
  catMailClient.ClientHeight := calcPosBelow(chkUseMAPI);

  CategoryPanelGroup1.Height := self.Height;

end;

procedure TframeAdvancedOptions.OptionsChange(Sender: TObject);
begin

  // other options
  if not Options.Busy then
  begin
    // screen to options
    Options.TimeOut := StrToIntDef(edTimeOut.Text,120);
    Options.QuickCheck := chkQuickCheck.Checked;
    Options.SafeDelete := chkSafeDelete.Checked;

    Options.UseMAPI := chkUseMAPI.Checked;

    Options.NoError := chkNoError.Checked;
    Options.IgnoreRetrieveErrors := chkIgnoreRetrieveErrors.Checked;

    // enable save button
    funcEnableSaveBtn();
  end;
end;

procedure TframeAdvancedOptions.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

end.

unit uFrameWhiteBlack;

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
  Dialogs, StdCtrls, ExtCtrls, uConstants;

type
  TEnableSaveOptionsFunction = procedure of object;

type
  TframeWhiteBlack = class(TFrame)
    spltWhiteBlack: TSplitter;
    memWhiteList: TMemo;
    lblWhiteList: TLabel;
    lblBlackList: TLabel;
    memBlackList: TMemo;
    procedure FrameResize(Sender: TObject);
    procedure memListChange(Sender: TObject);
    procedure HelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure memWhiteListExit(Sender: TObject);
    procedure memBlackListExit(Sender: TObject);
  private
    { Private declarations }
    funcEnableSaveBtn : TEnableSaveOptionsFunction;
    procedure OnWhiteListUpdated(var Msg: TMessage); message UM_RELOAD_WHITELIST;
    procedure OnBlackListUpdated(var Msg: TMessage); message UM_RELOAD_BLACKLIST;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction); reintroduce;
  end;

implementation

uses uGlobal, uTranslate, System.UITypes, uMain;

{$R *.dfm}

constructor TframeWhiteBlack.Create(AOwner: TComponent; SaveButtonProc : TEnableSaveOptionsFunction);
begin
  inherited Create(AOwner);
  funcEnableSaveBtn := SaveButtonProc;


  Options.Busy := True;
  memWhiteList.Lines.Text := Options.WhiteList.Text;
  memBlackList.Lines.Text := Options.BlackList.Text;
  Options.Busy := False;

  lblWhiteList.Font.Assign(Options.GlobalFont);
  with lblWhiteList.Font do Style := Style + [fsBold];

  lblBlackList.Font := lblWhiteList.Font;

  TranslateComponentFromEnglish(self);


end;

procedure TframeWhiteBlack.OnWhiteListUpdated(var Msg: TMessage);
begin
  memWhiteList.Lines.Text := Options.WhiteList.Text;
end;

procedure TframeWhiteBlack.OnBlackListUpdated(var Msg: TMessage);
begin
  memBlackList.Lines.Text := Options.BlackList.Text;
end;

procedure TframeWhiteBlack.FrameResize(Sender: TObject);
begin
  memWhiteList.Height := (Self.Height - lblWhiteList.Height - lblBlackList.Height - spltWhiteBlack.Height) div 2;
  Self.Refresh; //refresh to make labels not disappear in Vista
end;

procedure TframeWhiteBlack.memListChange(Sender: TObject);
begin
  if not Options.Busy then
  begin
    // enable save button
    funcEnableSaveBtn();
  end;
end;

procedure TframeWhiteBlack.HelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPopUMain.QuickHelp(Sender, Button, Shift, X, Y);
end;

procedure TframeWhiteBlack.memWhiteListExit(Sender: TObject);
begin
  Options.WhiteList.Assign(memWhiteList.Lines)
end;

procedure TframeWhiteBlack.memBlackListExit(Sender: TObject);
begin
  Options.BlackList.Assign(memBlackList.Lines);
end;

end.

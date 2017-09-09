unit uInfo;

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
  Dialogs, ExtCtrls, StdCtrls, SimpleTimer, ComCtrls, Buttons, ToolWin,
  ActnMan, ActnCtrls;

type
  TfrmInfo = class(TForm)
    panInfoBorder: TPanel;
    pgInfo: TPageControl;
    tsNewMail: TTabSheet;
    lvInfoNew: TListView;
    tsSummary: TTabSheet;
    lvInfoSummary: TListView;
    panCloseX: TPanel;
    imgCloseX: TImage;
    panInfoToolbar: TPanel;
    btnMarkAsViewed: TSpeedButton;
    btnMailProgram: TSpeedButton;
    btnShowMessages: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure pgInfoChange(Sender: TObject);
  protected
    procedure CreateParams(Var Params: TCreateParams); override;
  private
    { Private declarations }
    procedure TimerCallback(Sender : TObject);
  public
    { Public declarations }
    Timer : TSimpleTimer;
  end;

var
  frmInfo: TfrmInfo;

implementation

uses uGlobal, uRCUtils, uMain, uDM, Types;

{$R *.dfm}

procedure TfrmInfo.TimerCallback(Sender: TObject);
begin
  frmInfo.Close;
end;

//----------------------------------------------------------------- Events -----

procedure TfrmInfo.FormCreate(Sender: TObject);
begin
  Timer := TSimpleTimer.Create;
  Timer.OnTimer := TimerCallback;
  pgInfo.ActivePageIndex := Options.InfoTab;
  btnMailProgram.Glyph.Assign(frmPopUMain.btnStartProgram.Glyph);
  // column widths
  lvInfoNew.Column[0].Width := Options.InfoCol1;
  lvInfoNew.Column[1].Width := Options.InfoCol2;
  lvInfoNew.Column[2].Width := Options.InfoCol3;
  lvInfoNew.Column[3].Width := Options.InfoCol4;

  self.Font := Options.GlobalFont;
end;

procedure TfrmInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer.Free;
  frmPopUMain.FShowingInfo := False;
  Options.InfoCol1 := lvInfoNew.Column[0].Width;
  Options.InfoCol2 := lvInfoNew.Column[1].Width;
  Options.InfoCol3 := lvInfoNew.Column[2].Width;
  Options.InfoCol4 := lvInfoNew.Column[3].Width;
  Action := caFree;
end;

procedure TfrmInfo.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmInfo.FormActivate(Sender: TObject);
begin
  if Options.AdvInfoDelay > 0 then
  begin
    Timer.Interval := Options.AdvInfoDelay * 1000;
    Timer.Enabled := True;
  end;
end;

procedure TfrmInfo.FormDeactivate(Sender: TObject);
begin
  if Self.Visible then
    Close;
end;

procedure TfrmInfo.pgInfoChange(Sender: TObject);
begin
  Timer.Enabled := False;
  Options.InfoTab := pgInfo.ActivePageIndex;
end;

procedure TfrmInfo.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;
begin
  inherited;
  Params.Style := Params.Style and not WS_CAPTION or WS_POPUP;
  Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE;
  If (IsWinXP) Then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

end.

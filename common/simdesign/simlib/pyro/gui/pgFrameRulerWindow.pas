{ Project: Pyro

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgFrameRulerWindow;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dtpRsRuler, pgScrollBoxView, Pyro, ExtCtrls;

type

  TMousePositionEvent = procedure (Sender: TObject; const X, Y: double; Units: TRulerUnit;
    const Scale: double; IsInside: boolean) of object;

  TfrRulerWindow = class(TFrame)
    pnlTop: TPanel;
    pnlLeft: TPanel;
    pnlCenter: TPanel;
    procedure rsCornerClick(Sender: TObject);
  private
    FScrollBox: TpgScrollBoxView;
    FOnMousePosition: TMousePositionEvent;
    FrsCorner: TdtpRsRulerCorner;
    FrsTop: TdtpRsRuler;
    FrsLeft: TdtpRsRuler;
    function GetUnits: TRulerUnit;
    procedure SetUnits(const Value: TRulerUnit);
    procedure ScrollBoxMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ScrollBoxVirtualWindowChanged(Sender: TObject);
    function GetRulersVisible: boolean;
    procedure SetRulersVisible(const Value: boolean);
  protected
    function SetHairlinePos(X, Y: integer): boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property Units: TRulerUnit read GetUnits write SetUnits;
    property ScrollBox: TpgScrollBoxView read FScrollBox;
    property RulersVisible: boolean read GetRulersVisible write SetRulersVisible;
    property OnMousePosition: TMousePositionEvent read FOnMousePosition write FOnMousePosition;
  end;

implementation

{$R *.dfm}

{ TfrRulerWindow }

constructor TfrRulerWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Create rulers
  FrsCorner := TdtpRsRulerCorner.Create(Self);
  FrsCorner.Hint := 'pixel';
  FrsCorner.Units := ruPixel;
  FrsCorner.Flat := False;
  FrsCorner.ScaleColor := clWindow;
  FrsCorner.TickColor := clWindowText;
  FrsCorner.Align := alLeft;
  FrsCorner.Position := cpLeftTop;
  FrsCorner.OnClick := rsCornerClick;
  FrsCorner.Parent := pnlTop;
  FrsTop := TdtpRsRuler.Create(Self);
  FrsTop.Units := ruPixel;
  FrsTop.Flat := False;
  FrsTop.ScaleColor := clWindow;
  FrsTop.TickColor := clWindowText;
  FrsTop.Direction := rdTop;
  FrsTop.HairLine := True;
  FrsTop.HairLinePos := -1;
  FrsTop.HairLineStyle := hlsLine;
  FrsTop.ShowMinus := True;
  FrsTop.ScreenDpm := 1.0;
  FrsTop.Align := alClient;
  FrsTop.Parent := pnlTop;
  FrsLeft := TdtpRsRuler.Create(Self);
  FrsLeft.Units := ruPixel;
  FrsLeft.Flat := False;
  FrsLeft.ScaleColor := clWindow;
  FrsLeft.TickColor := clWindowText;
  FrsLeft.Direction := rdLeft;
  FrsLeft.HairLine := True;
  FrsLeft.HairLinePos := -1;
  FrsLeft.HairLineStyle := hlsLine;
  FrsLeft.ShowMinus := True;
  FrsLeft.ScreenDpm := 1.0;
  FrsLeft.Align := alClient;
  FrsLeft.Parent := pnlLeft;

  // Create scrollbox
  FScrollBox := TpgScrollBoxView.Create(Self);
  FScrollBox.Align := alClient;
  FScrollBox.Parent := pnlCenter;
  FScrollBox.OnMouseMove := ScrollBoxMouseMove;
  FScrollBox.OnVirtualWindowChanged := ScrollBoxVirtualWindowChanged;
end;

function TfrRulerWindow.GetUnits: TRulerUnit;
begin
  Result := FrsCorner.Units;
end;

procedure TfrRulerWindow.ScrollBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  IsInside: boolean;
  Scale: double;
begin
  IsInside := SetHairlinePos(X, Y);
  Scale := sqrt(FrsTop.Scale * FrsLeft.Scale);
  // Tell app where we are
  if assigned(FOnMousePosition) then
    FOnMousePosition(Self,
      (X + FrsTop.Offset ) / (FrsTop.PixPerUnit ),
      (Y + FrsLeft.Offset) / (FrsLeft.PixPerUnit),
      Units, Scale, IsInside);
end;

function TfrRulerWindow.SetHairlinePos(X, Y: integer): boolean;
begin
  FrsTop.HairLinePos := X;
  FrsLeft.HairLinePos := Y;
  Result := pgPtInRect(FScrollBox.VirtualRect, pgiPoint(X, Y));
  FrsLeft.HairLine := Result;
  FrsTop.HairLine := Result;
end;

procedure TfrRulerWindow.SetUnits(const Value: TRulerUnit);
begin
  if GetUnits <> Value then
  begin
    FrsCorner.Units := Value;
    FrsTop.Units := Value;
    FrsLeft.Units := Value;
  end;
end;

procedure TfrRulerWindow.rsCornerClick(Sender: TObject);
begin
  // Change units ciruclarly
  case Units of
  ruMilli: Units := ruCenti;
  ruCenti: Units := ruInch;
  ruInch: Units := ruPixel;
  ruPixel, ruNone: Units := ruMilli;
  end;
end;

procedure TfrRulerWindow.ScrollBoxVirtualWindowChanged(Sender: TObject);
begin
  FrsTop.ScreenDpm := FScrollBox.Provider.DeviceInfo.DPI.X / 25.4;
  FrsTop.Scale := FScrollBox.ScaleX;
  FrsLeft.ScreenDpm := FScrollBox.Provider.DeviceInfo.DPI.X / 25.4;
  FrsLeft.Scale := FScrollBox.ScaleY;
  FrsTop.Offset := -FScrollBox.VirtualLeft;
  FrsLeft.Offset := -FScrollBox.VirtualTop;
end;

function TfrRulerWindow.GetRulersVisible: boolean;
begin
  Result := pnlTop.Visible;
end;

procedure TfrRulerWindow.SetRulersVisible(const Value: boolean);
begin
  if GetRulersVisible <> Value then
  begin
    pnlTop.Visible := Value;
    pnlLeft.Visible := Value;
  end;
end;

end.

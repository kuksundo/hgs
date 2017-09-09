{ <b>Project</b>: Pyro<p>

  <b>Author</b>: Nils Haeck (n.haeck@simdesign.nl)<p>
  Copyright (c) 2006 SimDesign BV
}
unit pgBackgroundFill;

interface

uses
  Graphics, SysUtils, Classes, pgTransform, pgSurface,
  pgColor, pgCanvas, pgWinGDI, Math, Pyro;

const

  cDefaultBackgroundColor = clWhite;

  cDefaultPatternColor1 = clWhite;
  cDefaultPatternColor2 = clLtGray;

  cDefaultGridColor       = $00FFFFC0;
  cDefaultGridSizeX       = 10;
  cDefaultGridSizeY       = 10;
  cDefaultGridStrokeWidth = 1;

type

  TpgFillType = (
    ftNone,
    ftSingleColor,
    ftCheckerPattern,
    ftGrid
  );

  TColorObj = class(TPersistent)
  private
    FAlpha: byte;
    FColor: TColor;
    FOnChanged: TNotifyEvent;
    procedure SetAlpha(const Value: byte);
    procedure SetColor(const Value: TColor);
  public
    constructor Create;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  published
    property Color: TColor read FColor write SetColor;
    property Alpha: byte read FAlpha write SetAlpha default 255;
  end;

  TPointObj = class(TPersistent)
  private
    FY: double;
    FX: double;
    FOnChanged: TNotifyEvent;
    procedure SetX(const Value: double);
    procedure SetY(const Value: double);
  public
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  published
    property X: double read FX write SetX;
    property Y: double read FY write SetY;
  end;

  TGridObj = class(TPersistent)
  private
    FColor: TColorObj;
    FOnChanged: TNotifyEvent;
    FSize: TPointObj;
    FOrigin: TPointObj;
    FStrokeWidth: double;
    procedure DoChanged(Sender: TObject);
    procedure SetStrokeWidth(const Value: double);
  public
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    constructor Create;
    destructor Destroy; override;
    procedure Render(ACanvas: TpgCanvas; ATransform: TpgTransform); virtual;
  published
    property Color: TColorObj read FColor;
    property Origin: TPointObj read FOrigin;
    property Size: TPointObj read FSize;
    property StrokeWidth: double read FStrokeWidth write SetStrokeWidth;
  end;

  TPatternObj = class(TPersistent)
  private
    FSize: integer;
    FColor1: TColor;
    FColor2: TColor;
    FOnChanged: TNotifyEvent;
    procedure SetColor1(const Value: TColor);
    procedure SetColor2(const Value: TColor);
    procedure SetSize(const Value: integer);
  public
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    procedure Render(ACanvas: TpgCanvas; ATransform: TpgTransform); virtual;
  published
    property Size: integer read FSize write SetSize;
    property Color1: TColor read FColor1 write SetColor1;
    property Color2: TColor read FColor2 write SetColor2;
  end;

  // class that provides drawing capabilities for backgrounds
  TpgBackgroundFill = class(TPersistent)
  private
    FFill: TColorObj;
    FGrid: TGridObj;
    FOnChanged: TNotifyEvent;
    FPattern: TPatternObj;
    FFillType: TpgFillType;
    procedure SetFillType(const Value: TpgFillType);
    procedure DoChanged(Sender: TObject);
  protected
    procedure FillRect(ACanvas: TpgCanvas; X, Y, W, H: integer; Color: TpgColor32);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Render(ACanvas: TpgCanvas; ATransform: TpgTransform); virtual;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  published
    property FillType: TpgFillType read FFillType write SetFillType;
    property Fill: TColorObj read FFill;
    property Grid: TGridObj read FGrid;
    property Pattern: TPatternObj read FPattern;
  end;

implementation

{ TColorObj }

constructor TColorObj.Create;
begin
  inherited Create;
  FAlpha := 255;
end;

procedure TColorObj.SetAlpha(const Value: byte);
begin
  if FAlpha <> Value then begin
    FAlpha := Value;
    if assigned(FOnChanged) then FOnChanged(Self);
  end;
end;

procedure TColorObj.SetColor(const Value: TColor);
begin
  if FColor <> Value then begin
    FColor := Value;
    if assigned(FOnChanged) then FOnChanged(Self);
  end;
end;

{ TPointObj }

procedure TPointObj.SetX(const Value: double);
begin
  if FX <> Value then begin
    FX := Value;
    if assigned(FOnChanged) then FOnChanged(Self);
  end;
end;

procedure TPointObj.SetY(const Value: double);
begin
  if FY <> Value then begin
    FY := Value;
    if assigned(FOnChanged) then FOnChanged(Self);
  end;
end;

{ TGridObj }

constructor TGridObj.Create;
begin
  inherited;
  FColor := TColorObj.Create;
  FColor.OnChanged := DoChanged;
  FSize := TPointObj.Create;
  FSize.OnChanged := DoChanged;
  FOrigin := TPointObj.Create;
  FOrigin.OnChanged := DoChanged;
  // defaults
  FColor.Color := cDefaultGridColor;
  FColor.Alpha := $FF;
  FStrokeWidth := cDefaultGridStrokeWidth;
  FSize.X := cDefaultGridSizeX;
  FSize.Y := cDefaultGridSizeY;
end;

destructor TGridObj.Destroy;
begin
  FreeAndNil(FColor);
  FreeAndNil(FSize);
  FreeAndNil(FOrigin);
  inherited;
end;

procedure TGridObj.DoChanged(Sender: TObject);
begin
  if assigned(FOnChanged) then FOnChanged(Sender);
end;

procedure TGridObj.Render(ACanvas: TpgCanvas; ATransform: TpgTransform);
var
  S: TpgState;
  P0, P1: TpgPoint;
  Dx, Dy, X, Y: double;
  xi, yi, Xs, Xe, Ys, Ye: integer;
  R: TpgRect;
  Stroke: TpgStroke;
begin
  // do not render if strokewidth is too small (won't be visible)
  if FStrokeWidth < 0.1 then exit;
  P0 := ATransform.Transform(pgPoint(Origin.X, Origin.Y));
  P1 := ATransform.Transform(pgPoint(Origin.X + Size.X, Origin.Y + Size.Y));
  Dx := P1.X - P0.X;
  Dy := P1.Y - P0.Y;
  // decimate while Dx,Dy so small that covered almost completely by stroke
  while (Dx <= FStrokeWidth * 4) or (Dy <= FStrokeWidth * 4) do begin
    Dx := Dx * 10;
    Dy := Dy * 10;
  end;
  R := ACanvas.DeviceRect;
  Xs := floor((R.Left - P0.X) / Dx);
  Xe := ceil ((R.Right - P0.X) / Dx);
  Ys := floor((R.Top - P0.Y) / Dy);
  Ye := ceil ((R.Bottom - P0.Y) / Dy);
  S := ACanvas.Push;
  try
    Stroke := ACanvas.NewStroke;
    Stroke.Color := GDIToColor32(Color.Color, Color.Alpha);
    Stroke.Width := FStrokeWidth;
    for xi := Xs to Xe do begin
      X := P0.X + xi * Dx;
      ACanvas.PaintLine(X, R.Top, X, R.Bottom, Stroke);
    end;
    for yi := Ys to Ye do begin
      Y := P0.Y + yi * Dy;
      ACanvas.PaintLine(R.Left, Y, R.Right, Y, Stroke);
    end;
  finally
    ACanvas.Pop(S);
  end;
end;

procedure TGridObj.SetStrokeWidth(const Value: double);
begin
  if FStrokeWidth <> Value then begin
    FStrokeWidth := Value;
    DoChanged(Self);
  end;
end;

{ TPatternObj }

procedure TPatternObj.Render(ACanvas: TpgCanvas; ATransform: TpgTransform);
var
  ColPat: array[0..1] of TpgColor32;
  R: TpgRect;
  x, y, Xs, Xc, Ys, Yc: integer;
  L, T: integer;
begin
  // Draw checker pattern here
  R := ACanvas.DeviceRect;
  ColPat[0] := GDIToColor32(Color1, $FF);
  ColPat[1] := GDIToColor32(Color2, $FF);
  Xs := R.Left div Size;
  Xc := R.Right div Size + 1;
  Ys := R.Top div Size;
  Yc := R.Bottom div Size + 1;
  for y := Ys to Yc - 1 do
  begin
    T := y * Size;
    for x := Xs to Xc - 1 do
    begin
      L := x * Size;
      ACanvas.FillDeviceRect(pgRect(L, T, L + Size, T + Size),
        ColPat[(x + y) mod 2]);
    end;
  end;
end;

procedure TPatternObj.SetColor1(const Value: TColor);
begin
  if FColor1 <> Value then begin
    FColor1 := Value;
    if assigned(FOnChanged) then FOnChanged(Self);
  end;
end;

procedure TPatternObj.SetColor2(const Value: TColor);
begin
  if FColor2 <> Value then begin
    FColor2 := Value;
    if assigned(FOnChanged) then FOnChanged(Self);
  end;
end;

procedure TPatternObj.SetSize(const Value: integer);
begin
  if FSize <> Value then begin
    FSize := Value;
    if assigned(FOnChanged) then FOnChanged(Self);
  end;
end;

{ TpgBackgroundFill }

constructor TpgBackgroundFill.Create;
begin
  inherited;
  FFill := TColorObj.Create;
  FFill.OnChanged := DoChanged;
  FGrid := TGridObj.Create;
  FGrid.OnChanged := DoChanged;
  FPattern := TPatternObj.Create;
  FPattern.Size := 10;
  FPattern.Color1 := cDefaultPatternColor1;
  FPattern.Color2 := cDefaultPatternColor2;
  FPattern.OnChanged := DoChanged;
  // Default: single color white
  FFillType := ftSingleColor;
  FFill.FColor := cDefaultBackgroundColor;
end;

destructor TpgBackgroundFill.Destroy;
begin
  FreeAndNil(FFill);
  FreeAndNil(FGrid);
  FreeAndNil(FPattern);
  inherited;
end;

procedure TpgBackgroundFill.DoChanged(Sender: TObject);
begin
  if assigned(FOnChanged) then FOnChanged(Sender);
end;

procedure TpgBackgroundFill.FillRect(ACanvas: TpgCanvas; X, Y, W, H: integer; Color: TpgColor32);
begin
  ACanvas.FillDeviceRect(pgRect(X, Y, X + W, Y + H), Color);
end;

procedure TpgBackgroundFill.Render(ACanvas: TpgCanvas; ATransform: TpgTransform);
var
  S: TpgState;
  R: TpgRect;
begin
  S := ACanvas.Push;
  try
    case FFillType of
    ftSingleColor, ftGrid:
      begin
        R := ACanvas.DeviceRect;
        FillRect(ACanvas, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top,
          GDIToColor32(FFill.Color, FFill.Alpha));
        if FFillType = ftGrid then
          FGrid.Render(ACanvas, ATransform);
      end;
    ftCheckerPattern:
      FPattern.Render(ACanvas, ATransform);
    end;
  finally
    ACanvas.Pop(S);
  end;
end;

procedure TpgBackgroundFill.SetFillType(const Value: TpgFillType);
begin
  if FFillType <> Value then begin
    FFillType := Value;
    DoChanged(Self);
  end;
end;

end.

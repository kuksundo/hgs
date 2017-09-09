{ Project: Pyro

  Description
  Inpainting project

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgInPainting;

interface

uses
  Classes, SysUtils, Contnrs,
  pgBitmap, pgPath, Pyro, pgCover, pgPolygonRasterizer, pgColor, pgPolygon;

type

  TpgPaintKnot = class(TPersistent)
  private
    FX: integer;
    FY: integer;
    FMid: integer;
    FWidth: integer;
    FColors: array of array of TpgColor32;
  protected
    procedure BuildFrom(ABitmap: TpgBitmap; AWidth: integer; const ACenter: TpgPoint);
  public
    function ColorAt(x, y: integer): TpgColor32;
    property X: integer read FX;
    property Y: integer read FY;
  end;

  TpgPaintKnotList = class(TObjectList)
  private
    function GetItems(Index: integer): TpgPaintKnot;
  public
    property Items[Index: integer]: TpgPaintKnot read GetItems; default;
  end;

  TpgInPainter = class(TPersistent)
  private
    FKnotWidth: integer;
    FKnots: TpgPaintKnotList;
    FKnotWeights: array of double;
    FBitmap: TpgBitmap;
    FPath: TpgPath;
  protected
    procedure BuildPaintKnots;
    procedure BuildCover(ACover: TpgCover);
    function CalculatePixelValue(x, y: integer): TpgColor32;
    property Knots: TpgPaintKnotList read FKnots;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure FillBitmap(ABitmap: TpgBitmap; APath: TpgPath);
    // The width in pixels of the paint knots
    property KnotWidth: integer read FKnotWidth write FKnotWidth;
  end;

const

  cDefaultKnotWidth = 6;

implementation

{ TpgPaintKnot }

procedure TpgPaintKnot.BuildFrom(ABitmap: TpgBitmap; AWidth: integer;
  const ACenter: TpgPoint);
var
  xs, ys, xi, yi, xp, yp, i: integer;
begin
  // The center of the knot
  FX := trunc(ACenter.X);
  FY := trunc(ACenter.Y);

  // Start x, y
  FMid := AWidth div 2;
  FWidth := AWidth;
  xs := FX - FMid;
  ys := FY - FMid;

  // Color array
  SetLength(FColors, FWidth);
  for i := 0 to FWidth - 1 do
    SetLength(FColors[i], AWidth);

  // Copy the colors from the bitmap
  for yi := 0 to FWidth - 1 do
  begin
    yp := yi + ys;
    if yp < 0 then yp := 0;
    if yp >= ABitmap.Height then
      yp := ABitmap.Height - 1;
    for xi := 0 to FWidth - 1 do
    begin
      xp := xi + xs;
      if xp < 0 then
        xp := 0;
      if xp >= ABitmap.Width then
        xp := ABitmap.Width - 1;
      FColors[yi, xi] := ABitmap.Pixels[xp, yp];
    end;
  end;
end;

function TpgPaintKnot.ColorAt(x, y: integer): TpgColor32;
var
  PosX, PosY: integer;
  MirrorX, MirrorY: boolean;
begin
  PosX := x - FX + FMid;
  PosY := y - FY + FMid;
  MirrorX := False;
  MirrorY := False;
  while PosX < 0 do
  begin
    inc(PosX, FWidth);
    MirrorX := not MirrorX;
  end;
  while PosX >= FWidth do
  begin
    dec(PosX, FWidth);
    MirrorX := not MirrorX;
  end;
  while PosY < 0 do
  begin
    inc(PosY, FWidth);
    MirrorY := not MirrorY;
  end;
  while PosY >= FWidth do
  begin
    dec(PosY, FWidth);
    MirrorY := not MirrorY;
  end;
  if MirrorX then PosX := FWidth - PosX - 1;
  if MirrorY then PosY := FWidth - PosY - 1;
  Result := FColors[PosX, PosY];
end;

{ TpgPaintKnotList }

function TpgPaintKnotList.GetItems(Index: integer): TpgPaintKnot;
begin
  Result := Get(Index);
end;

{ TpgInPainter }

procedure TpgInPainter.BuildCover(ACover: TpgCover);
var
  Rasterizer: TpgRasterizer;
begin
  Rasterizer := TpgRasterizer.Create;
  try
    // Set the size of the cover, this also clears it
    ACover.SetSize(FBitmap.Width, FBitmap.Height);

    // Rasterize the polygon
    Rasterizer.Cover := ACover;
    Rasterizer.RasterizePolyPolygon(FPath.AsPolyPolygon, nil);
  finally
    Rasterizer.Free;
  end;
end;

procedure TpgInPainter.BuildPaintKnots;
var
  i: integer;
  Knot: TpgPaintKnot;
  PP: TpgPolyPolygon;
begin
  FKnots.Clear;
  PP := FPath.AsPolyPolygon;
  if PP.Count <> 1 then
    raise Exception.Create('Only one polygon allowed');
  for i := 0 to PP[0].PointCount - 1 do
  begin
    Knot := TpgPaintKnot.Create;
    Knot.BuildFrom(FBitmap, FKnotWidth, PP[0].Points[i]^);
    FKnots.Add(Knot);
  end;
  SetLength(FKnotWeights, FKnots.Count);
end;

function TpgInPainter.CalculatePixelValue(x, y: integer): TpgColor32;
var
  i, j: integer;
  Knot: TpgPaintKnot;
  RSqr, TotalWeight, LimitWeight, LargestWeight, Weight: double;
  Colors: array[0..3] of double;
  KnotColor: TpgColor32;
begin
  // Calculate initial knot weights
  TotalWeight := 0;
  LargestWeight := 0;
  for i := 0 to FKnots.Count - 1 do
  begin
    Knot := FKnots[i];
    RSqr := sqr(Knot.X - x) + sqr(Knot.Y - y);
    FKnotWeights[i] := 1 / (sqr(RSqr) + 1);

    // Sum initial weights
    TotalWeight := TotalWeight + FKnotWeights[i];

    // Largest weight
    if FKnotWeights[i] > LargestWeight then
      LargestWeight := FKnotWeights[i];
  end;

  // Discard weights smaller than 1%, and do a new summation
  LimitWeight := LargestWeight * 0.01;
  TotalWeight := 0;
  for i := 0 to FKnots.Count - 1 do
  begin
    if FKnotWeights[i] < LimitWeight then
      FKnotWeights[i] := 0;
    TotalWeight := TotalWeight + FKnotWeights[i];
  end;

  // Calculate color interpolation
  for j := 0 to 3 do Colors[j] := 0;
  for i := 0 to FKnots.Count - 1 do
  begin
    Weight := FKnotWeights[i];
    if Weight = 0 then continue;
    KnotColor := FKnots[i].ColorAt(x, y);
    for j := 0 to 3 do
    begin
      Colors[j] := Colors[j] + (KnotColor and $FF) * Weight;
      KnotColor := KnotColor shr 8;
    end;
  end;

  // Final color
  Result := 0;
  for i := 3 downto 0 do
  begin
    Result := Result shl 8;
    Result := Result or round(Colors[i] / TotalWeight);
  end;
end;

constructor TpgInPainter.Create;
begin
  inherited Create;
  FKnots := TpgPaintKnotList.Create(True);
  // defaults
  FKnotWidth := cDefaultKnotWidth;
end;

destructor TpgInPainter.Destroy;
begin
  FreeAndNil(FKnots);
  inherited;
end;

procedure TpgInPainter.FillBitmap(ABitmap: TpgBitmap; APath: TpgPath);
var
  i, j, x, y: integer;
  Cover: TpgCover;
  Span: PpgSpan;
begin
  FBitmap := ABitmap;
  FPath := APath;

  // Step 1: start by creating the paint knots
  BuildPaintKnots;

  // Step 2: create a cover array from the polygon
  Cover := TpgCover.Create;
  try
    BuildCover(Cover);

    // Step 3: calculate the pixel colors for each of the span positions in the cover
    Span := Cover.Spans;
    for i := 0 to Cover.SpanCount - 1 do
    begin
      y := Span.YPos;
      for j := 0 to Span.Count - 1 do
      begin
        x := Span.XPos + j;
        // calculate the pixel value at position x,y
        FBitmap.Pixels[x, y] := CalculatePixelValue(x, y);
      end;
      inc(Span);
    end;
  finally
    Cover.Free;
  end;
end;

end.

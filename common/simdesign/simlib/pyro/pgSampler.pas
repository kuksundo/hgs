{ Project: Pyro
  Module: Pyro Render

  Description:
  Sampling of maps, returning data from a map through a transformation

  Samplers are classes that provide color information sampled from a source to
  the calling methods.

  To do:
  - Add filters (nearest, linear, spline, lanczos, etc)

  Creation Date:
  01Jun2005

  Modifications:
  13Oct2005: added oversampling

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2005 - 2011 SimDesign BV
}
unit pgSampler;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils,
  // pyro
  pgTransform, Pyro, pgColor, pgBitmap, pgGeometry;

type

  TpgMapBufferFunc = procedure (X, Y, Count: integer) of object;

  // Basic sampler class, serves as a basis for other samplers
  TpgSampler = class(TPersistent)
  private
    FInvertedTransform: TpgTransformList;
    FIsLinear: boolean;
  protected
    property InvertedTransform: TpgTransformList read FInvertedTransform;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure InvertFromTransformList(AList: TpgTransformList);
    procedure GetColorInfo(var Info: TpgColorInfo); virtual; abstract;
    function ElementSize: integer; virtual; abstract;
    function GetColorSpan(X, Y, Count: integer): pointer; virtual; abstract;
    procedure PrepareSpanWidth(AWidth: integer); virtual;
  end;

  // The TpgMapSampler can be used to sample values from the color map Map.
  // Usage is found in image maps and pattern maps.
  TpgMapSampler = class(TpgSampler)
  private
    FMap: TpgColorMap;
    FBuffer: array of byte;
    FWorkBuf: array of byte;
    FMapBufferFunc: TpgMapBufferFunc;
    FElementSize: integer;
    FXSpans, FYSpans: array of integer;
    FSamplingPoints: array of TpgPoint;
    FSamplingCount: integer;
    FOverSampling: integer;
    FInterpolationMethod: TpgInterpolationMethod;
    procedure SetOverSampling(const Value: integer);
    procedure SetInterpolationMethod(const Value: TpgInterpolationMethod);
  protected
    procedure MapBufferNearest1x1(X, Y, Count: integer);
    procedure MapBufferNearestNxN(X, Y, Count: integer);
    procedure MapBufferLinear1x1(X, Y, Count: integer);
    procedure MapBufferLinearNxN(X, Y, Count: integer);
    procedure UpdateFunctions;
    procedure IntegrateBuffer(ACount: integer);
  public
    constructor Create; override;
    function ElementSize: integer; override;
    procedure GetColorInfo(var Info: TpgColorInfo); override;
    function GetColorSpan(X, Y, Count: integer): pointer; override;
    procedure PrepareSpanWidth(AWidth: integer); override;
    property Map: TpgColorMap read FMap write FMap;
    // Oversampling (1..N) defines how many (NxN) samples are taken per destination
    // pixel. Note that high values of OverSampling require lots of pixel lookups
    // and thus slow down a lot
    property OverSampling: integer read FOverSampling write SetOverSampling;
    // Interpolation method to obtain pixel values from the map. imNearest will
    // use no interpolation, just takes the nearest (closest) pixel value. imLinear
    // will do a linear interpolation between pixels.
    property InterpolationMethod: TpgInterpolationMethod read FInterpolationMethod write SetInterpolationMethod;
  end;

// Create Den parts from Num, with positions in Positions (zerobased)
procedure CreateDivision(Num, Den: integer; var Positions: array of integer);

implementation

type
  TMapAccess = class(TpgColorMap);

procedure CreateDivision(Num, Den: integer; var Positions: array of integer);
// Create Den parts from Num, with positions in Positions (zerobased)
var
  i, Run, RunInc, Left, Width: integer;
  IsNeg: boolean;
begin
  // special case: just all zeros?
  if Num = 0 then
  begin
    FillChar(Positions[0], SizeOf(integer) * (Den + 1), 0);
    exit;
  end;

  // Always work with positive values
  if Num < 0 then
  begin
    IsNeg := True;
    Num := -Num;
  end else
    IsNeg := False;

  Run := 0;
  Left := 0;
  Width := Num div Den;
  RunInc := Num - Width * Den;
  for i := 0 to Den - 1 do
  begin
    Positions[i] := Left;
    inc(Left, Width);
    inc(Run, RunInc);
    if Run >= Den then
    begin
      inc(Left);
      dec(Run, Den);
    end;
  end;
  Positions[Den] := Num;

  if IsNeg then
    for i := 0 to Den do
      Positions[i] := -Positions[i];
end;

{ TpgSampler }

constructor TpgSampler.Create;
begin
  inherited Create;
end;

destructor TpgSampler.Destroy;
begin
  FreeAndNil(FInvertedTransform);
  inherited;
end;

procedure TpgSampler.InvertFromTransformList(AList: TpgTransformList);
begin
  FreeAndNil(FInvertedTransform);
  FInvertedTransform := AList.CreateOptimizedList;
  FInvertedTransform.Invert;
end;

procedure TpgSampler.PrepareSpanWidth(AWidth: integer);
begin
  FIsLinear := FInvertedTransform.IsLinear and (AWidth > 0);
end;

{ TpgMapSampler }

constructor TpgMapSampler.Create;
begin
  inherited;
  // Default map buffer function
  FOverSampling := 1;
  FInterpolationMethod := imNearest;
  UpdateFunctions;
end;

function TpgMapSampler.ElementSize: integer;
begin
  Result := FMap.ElementSize;
end;

procedure TpgMapSampler.GetColorInfo(var Info: TpgColorInfo);
begin
  Info := FMap.ColorInfo;
end;

function TpgMapSampler.GetColorSpan(X, Y, Count: integer): pointer;
var
  BufSize: integer;
begin
  FElementSize := FMap.ElementSize;
  BufSize := Count * FElementSize;
  if BufSize > length(FBuffer) then
    SetLength(FBuffer, BufSize);
  FMapBufferFunc(X, Y, Count);
  Result := @FBuffer[0];
end;

procedure TpgMapSampler.IntegrateBuffer(ACount: integer);
var
  i, j, k: integer;
  P, Q: PByte;
  Totals: array[0..7] of integer;
begin
  if FMap.ColorInfo.BitsPerChannel = bpc8bits then
  begin
    P := @FBuffer[0];
    Q := @FWorkBuf[0];
    for i := 0 to ACount - 1 do
    begin
      FillChar(Totals[0], FElementSize * SizeOf(integer), 0);
      for j := 0 to FSamplingCount - 1 do
      begin
        for k := 0 to FElementSize - 1 do
        begin
          inc(Totals[k], Q^);
          inc(Q);
        end;
      end;
      for k := 0 to FElementSize - 1 do
      begin
        P^ := Totals[k] div FSamplingCount;
        inc(P);
      end;
    end;
  end else
    raise Exception.Create(sUnsupportedBitsPerChannel);
end;

procedure TpgMapSampler.MapBufferLinear1x1(X, Y, Count: integer);
var
  i: integer;
  Xf, Yf: double;
  Pt: TpgPoint;
  P: PByte;
  XStart, YStart: integer;
begin
  // Center on pixel
  Xf := X + 0.5;
  Yf := Y + 0.5;
  P := @FBuffer[0];
  if FIsLinear then
  begin
    Pt := FInvertedTransform.Transform(pgPoint(Xf, Yf));

    // Start point
    XStart := pgFloor(Pt.X * 256);
    YStart := pgFloor(Pt.Y * 256);

    // Get results for transformed points
    for i := 0 to Count - 1 do
    begin
      TMapAccess(FMap).GetElementLinear256(XStart + FXSpans[i], YStart + FYSpans[i], P);
      inc(P, FElementSize);
    end;

  end else
  begin

    // Transform each point, and get result
    for i := 0 to Count - 1 do
    begin
      Pt := FInvertedTransform.Transform(pgPoint(Xf + i, Yf));
      TMapAccess(FMap).GetElementLinear256(pgFloor(Pt.X * 256), pgFloor(Pt.Y * 256), P);
      inc(P, FElementSize);
    end;

  end;
end;

procedure TpgMapSampler.MapBufferLinearNxN(X, Y, Count: integer);
var
  i, j: integer;
  XStart, YStart: integer;
  Xf, Yf: double;
  WorkSize, WorkBufSize: integer;
  Pb, Pt: TpgPoint;
  P, Q: PByte;
begin
  // Center on pixel
  Xf := X + 0.5;
  Yf := Y + 0.5;

  WorkSize := FSamplingCount * FElementSize;
  WorkBufSize := WorkSize * Count;
  if WorkBufSize > length(FWorkBuf) then
    SetLength(FWorkBuf, WorkBufSize);

  if FIsLinear then
  begin
    // For each sample get the values
    P := @FWorkBuf[0];
    Pb := pgPoint(Xf, Yf);
    for i := 0 to FSamplingCount - 1 do
    begin
      Q := P;
      Pt := FInvertedTransform.Transform(pgAddPoint(FSamplingPoints[i], Pb));
      XStart := pgFloor(Pt.X * 256);
      YStart := pgFloor(Pt.Y * 256);
      // Get results for transformed points
      for j := 0 to Count - 1 do
      begin
        TMapAccess(FMap).GetElementLinear256(XStart + FXSpans[j], YStart + FYSpans[j], Q);
        inc(Q, WorkSize);
      end;
      inc(P, FElementSize);
    end;

  end else
  begin

    // For each sample get the values
    P := @FWorkBuf[0];
    for i := 0 to FSamplingCount - 1 do
    begin
      Q := P;
      // Get results for transformed points
      for j := 0 to Count - 1 do
      begin
        Pt := FInvertedTransform.Transform(
          pgAddPoint(FSamplingPoints[i], pgPoint(Xf + j, Yf)));
        TMapAccess(FMap).GetElementLinear256(pgFloor(Pt.X * 256), pgFloor(Pt.Y * 256), Q);
        inc(Q, WorkSize);
      end;
      inc(P, FElementSize);
    end;

  end;

  // Integrate buffer
  IntegrateBuffer(Count);
end;

procedure TpgMapSampler.MapBufferNearest1x1(X, Y, Count: integer);
var
  i: integer;
  Xf, Yf: double;
  Pt: TpgPoint;
  P: PByte;
  XStart, YStart: integer;
begin
  // Center on pixel
  Xf := X + 0.5;
  Yf := Y + 0.5;
  P := @FBuffer[0];
  if FIsLinear then
  begin

    Pt := FInvertedTransform.Transform(pgPoint(Xf, Yf));
    XStart := pgFloor(Pt.X * 256);
    YStart := pgFloor(Pt.Y * 256);

    // Get results for transformed points
    for i := 0 to Count - 1 do
    begin
      TMapAccess(FMap).GetElement(pgSAR8(XStart + FXSpans[i]), pgSAR8(YStart + FYSpans[i]), P);
      inc(P, FElementSize);
    end;

  end else
  begin

    // Transform each point, and get result
    for i := 0 to Count - 1 do
    begin
      Pt := FInvertedTransform.Transform(pgPoint(Xf + i, Yf));
      TMapAccess(FMap).GetElement(pgFloor(Pt.X), pgFloor(Pt.Y), P);
      inc(P, FElementSize);
    end;

  end;
end;

procedure TpgMapSampler.MapBufferNearestNxN(X, Y, Count: integer);
var
  i, j: integer;
  XStart, YStart: integer;
  Xf, Yf: double;
  WorkSize, WorkBufSize: integer;
  Pb, Pt: TpgPoint;
  P, Q: PByte;
begin
  // Center on pixel
  Xf := X + 0.5;
  Yf := Y + 0.5;

  WorkSize := FSamplingCount * FElementSize;
  WorkBufSize := WorkSize * Count;
  if WorkBufSize > length(FWorkBuf) then
    SetLength(FWorkBuf, WorkBufSize);

  if FIsLinear then
  begin
    // For each sample get the values
    P := @FWorkBuf[0];
    Pb := pgPoint(Xf, Yf);
    for i := 0 to FSamplingCount - 1 do
    begin
      Q := P;
      Pt := FInvertedTransform.Transform(pgAddPoint(FSamplingPoints[i], Pb));
      XStart := pgFloor(Pt.X * 256);
      YStart := pgFloor(Pt.Y * 256);
      // Get results for transformed points
      for j := 0 to Count - 1 do
      begin
        TMapAccess(FMap).GetElement(pgSAR8(XStart + FXSpans[j]), pgSAR8(YStart + FYSpans[j]), Q);
        inc(Q, WorkSize);
      end;
      inc(P, FElementSize);
    end;

  end else
  begin

    // For each sample get the values
    P := @FWorkBuf[0];
    for i := 0 to FSamplingCount - 1 do
    begin
      Q := P;
      // Get results for transformed points
      for j := 0 to Count - 1 do
      begin
        Pt := FInvertedTransform.Transform(
          pgAddPoint(FSamplingPoints[i], pgPoint(Xf + j, Yf)));
        TMapAccess(FMap).GetElement(pgFloor(Pt.X), pgFloor(Pt.Y), Q);
        inc(Q, WorkSize);
      end;
      inc(P, FElementSize);
    end;

  end;

  // Integrate buffer
  IntegrateBuffer(Count);
end;

procedure TpgMapSampler.PrepareSpanWidth(AWidth: integer);
var
  P1, P2: TpgPoint;
begin
  inherited;
  if FIsLinear then
  begin
    // X and Y spans length
    SetLength(FXSpans, AWidth + 1);
    SetLength(FYSpans, AWidth + 1);

    // Build the "bresenham" divisions
    P1 := FInvertedTransform.Transform(pgPoint(0, 0));
    P2 := FInvertedTransform.Transform(pgPoint(AWidth, 0));
    CreateDivision(round((P2.X - P1.X) * 256), AWidth, FXSpans);
    CreateDivision(round((P2.Y - P1.Y) * 256), AWidth, FYSpans);

  end;
end;

procedure TpgMapSampler.SetInterpolationMethod(const Value: TpgInterpolationMethod);
begin
  if FInterpolationMethod <> Value then
  begin
    FInterpolationMethod := Value;
    UpdateFunctions;
  end;
end;

procedure TpgMapSampler.SetOverSampling(const Value: integer);
begin
  if FOverSampling <> Value then
  begin
    FOverSampling := pgLimit(Value, 1, cMaxOverSampling);
    UpdateFunctions;
  end;
end;

procedure TpgMapSampler.UpdateFunctions;
var
  i, j: integer;
begin
  FSamplingCount := sqr(FOverSampling);
  if FSamplingCount = 1 then
    case FInterpolationMethod of
    imNearest: FMapBufferFunc := MapBufferNearest1x1;
    imLinear:  FMapBufferFunc := MapBufferLinear1x1;
    end
  else
    case FInterpolationMethod of
    imNearest: FMapBufferFunc := MapBufferNearestNxN;
    imLinear:  FMapBufferFunc := MapBufferLinearNxN;
    end;
  // sampling positions
  if FSamplingCount > 1 then
  begin
    SetLength(FSamplingPoints, FSamplingCount);
    for i := 0 to FOverSampling - 1 do
      for j := 0 to FOverSampling - 1 do
        FSamplingPoints[i * FOverSampling + j] :=
          pgPoint((i + 0.5) / FOverSampling - 0.5, (j + 0.5) / FOverSampling - 0.5);
  end;
end;

end.

{ unit dtpSampler

  TdtpMapSampler is a class that implements color sampling from a map, using any
  arbitrary transform.

  If the transform is linear, only the edge points are transformed, and inter-
  mediate values are interpolated in fixed 24.8 space.

  Copyright (c) 2005 by Nils Haeck, SimDesign B.V.

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpSampler;

{$i simdesign.inc}

interface

uses
  Classes, Windows, SysUtils, dtpTransform, dtpGraphics, Math;

type

  TdtpMapBufferFunc = procedure (X, Y, Count: integer) of object;

  TdtpSampler = class(TPersistent)
  private
    FTransform: TdtpGenericTransform; // referenced
    FTransInv: TdtpGenericTransform;  // owned
    FDest: TdtpBitmap;
    FDestRect: TdtpRect;
    procedure SetTransform(const Value: TdtpGenericTransform);
    procedure SetDest(const Value: TdtpBitmap);
    procedure SetDestRect(const Value: TdtpRect);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function SampleSpan(X, Y, Count: integer): pointer; virtual; abstract;
    procedure SampleRect(ARect: TdtpRect); virtual; abstract;
    property Transform: TdtpGenericTransform read FTransform write SetTransform;
    property Dest: TdtpBitmap read FDest write SetDest;
    property DestRect: TdtpRect read FDestRect write SetDestRect;
  end;

  TdtpMapSampler = class(TdtpSampler)
  private
    FMap: TdtpBitmap;
    FBuffer: array of byte;
    FWorkBuf: array of byte;
    FMapBufferFunc: TdtpMapBufferFunc;
    FElementSize: integer;
    FXSpans, FYSpans: array of integer;
    FSamplingCount: integer;
    FSamplingPoints: array of TdtpPoint;
    procedure SetMap(const Value: TdtpBitmap);
  protected
    procedure MapBufferLin1x1(X, Y, Count: integer);
    procedure MapBufferLinNxN(X, Y, Count: integer);
  public
    constructor Create; override;
    function SampleSpan(X, Y, Count: integer): pointer; override;
    procedure SetOverSampling(const Value: integer);
    procedure SampleRect(ARect: TdtpRect); override;
    property Map: TdtpBitmap read FMap write SetMap;
  end;

const
  // Max oversampling size (nxn)
  cMaxOversampling = 6;

resourcestring
  sIllegalOverSamplingValue  = 'Illegal oversampling value';

implementation

type
  TMapAccessor = class(TdtpBitmap);

procedure CreateDivision(Num, Den: integer; var Positions: array of integer);
// Create Den parts from Num, with positions in Positions (zerobased)
var
  i, Run, RunInc, Left, Width, Size: integer;
begin
  Run := 0;
  Left := 0;
  Width := Num div Den;
  RunInc := Num - Width * Den;
  for i := 0 to Den - 1 do
  begin
    Positions[i] := Left;
    Size := Width;
    inc(Run, RunInc);
    if Run >= Den then
    begin
      inc(Size);
      dec(Run, Den);
    end;
    inc(Left, Size);
  end;
  Positions[Den] := Num;
end;

{ TdtpSampler }

constructor TdtpSampler.Create;
begin
  inherited;
end;

destructor TdtpSampler.Destroy;
begin
  FreeAndNil(FTransInv);
  inherited;
end;

procedure TdtpSampler.SetDest(const Value: TdtpBitmap);
begin
  FDest := Value;
end;

procedure TdtpSampler.SetDestRect(const Value: TdtpRect);
begin
  FDestRect := Value;
end;

procedure TdtpSampler.SetTransform(const Value: TdtpGenericTransform);
begin
  FTransform := Value;
  FreeAndNil(FTransInv);
  FTransInv := TdtpTransformClass(FTransform.ClassType).Create;
  FTransInv.Assign(FTransform);
  FTransInv.Invert;
end;

{ TdtpMapSampler }

constructor TdtpMapSampler.Create;
begin
  inherited;
  FElementSize := SizeOf(TdtpColor);
  SetOversampling(2);
end;

procedure TdtpMapSampler.MapBufferLin1x1(X, Y, Count: integer);
var
  i: integer;
  Xf, Yf: double;
  P1, P2: TdtpPoint;
  P: PByte;
  XStart, YStart: integer;
begin
  // Center on pixel
  Xf := X + 0.5;
  Yf := Y + 0.5;
  P := @FBuffer[0];
  if FTransInv.IsLinear and (Count > 1) then
  begin
    P1 := FTransInv.XFormP(dtpPoint(Xf, Yf));
    P2 := FTransInv.XFormP(dtpPoint(Xf + Count - 1, Yf));

    // Create X and Y spans
    SetLength(FXSpans, Max(Count, length(FXSpans)));
    SetLength(FYSpans, Max(Count, length(FYSpans)));
    CreateDivision(round((P2.X - P1.X) * 256), Count - 1, FXSpans);
    CreateDivision(round((P2.Y - P1.Y) * 256), Count - 1, FYSpans);
    XStart := round(P1.X * 256);
    YStart := round(P1.Y * 256);

    // Get results for transformed points
    for i := 0 to Count - 1 do
    begin
      PdtpColor(P)^ := TMapAccessor(FMap).Get_TS256(XStart + FXSpans[i], YStart + FYSpans[i]);
      inc(P, FElementSize);
    end;

  end else
  begin

    // Transform each point, and get result
    for i := 0 to Count - 1 do
    begin
      P1 := FTransInv.XFormP(dtpPoint(Xf + i, Yf));
      PdtpColor(P)^ := TMapAccessor(FMap).Get_TS256(round(P1.X * 256), round(P1.Y * 256));
      inc(P, FElementSize);
    end;

  end;
end;

procedure TdtpMapSampler.MapBufferLinNxN(X, Y, Count: integer);
var
  i, j, k: integer;
  XStart, YStart: integer;
  Xf, Yf: double;
  Totals: array of integer;
  WorkSize: integer;
  P1, P2, PS: TdtpPoint;
  P, Q: PByte;
begin
  // Center on pixel
  Xf := X + 0.5;
  Yf := Y + 0.5;
  WorkSize := FSamplingCount * FElementSize;
  SetLength(FWorkBuf, Max(WorkSize * Count, length(FWorkBuf)));
  if FTransInv.IsLinear and (Count > 1) then
  begin
    P1 := FTransInv.XFormP(dtpPoint(Xf, Yf));
    P2 := FTransInv.XFormP(dtpPoint(Xf + Count - 1, Yf));

    // Create X and Y spans
    SetLength(FXSpans, Max(Count, length(FXSpans)));
    SetLength(FYSpans, Max(Count, length(FYSpans)));
    CreateDivision(round((P2.X - P1.X) * 256), Count - 1, FXSpans);
    CreateDivision(round((P2.Y - P1.Y) * 256), Count - 1, FYSpans);

    // For each sample get the values
    P := @FWorkBuf[0];
    P1 := dtpPoint(Xf, Yf);
    for i := 0 to FSamplingCount - 1 do
    begin
      Q := P;
      PS.X := FSamplingPoints[i].X + P1.X;
      PS.Y := FSamplingPoints[i].Y + P1.Y;
      P2 := FTransInv.XFormP(PS);
      XStart := round(P2.X * 256);
      YStart := round(P2.Y * 256);
      // Get results for transformed points
      for j := 0 to Count - 1 do
      begin
        PdtpColor(Q)^ := TMapAccessor(FMap).Get_TS256(XStart + FXSpans[j], YStart + FYSpans[j]);
        inc(Q, WorkSize);
      end;
      Emms;
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
        PS.X := FSamplingPoints[i].X + Xf + j;
        PS.Y := FSamplingPoints[i].Y + Yf;
        P1 := FTransInv.XFormP(PS);
        PdtpColor(Q)^ := TMapAccessor(FMap).Get_TS256(round(P1.X * 256), round(P1.Y * 256));
        Emms;
        inc(Q, WorkSize);
      end;
      inc(P, FElementSize);
    end;

  end;

  // Integrate buffer
  P := @FBuffer[0];
  Q := @FWorkBuf[0];
  SetLength(Totals, FElementSize);
  for i := 0 to Count - 1 do
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
end;

procedure TdtpMapSampler.SampleRect(ARect: TdtpRect);
var
  i, y: integer;
  P: array[0..3] of TdtpPoint;
  XMinF, XMaxF, YMinF, YMaxF: double;
  XMin, XMax, YMin, YMax, SpanWidth: integer;
  PBuf: PdtpColor;
begin
  // Transform ARect's edges
  P[0] := dtpPoint(ARect.Left, ARect.Top);
  P[1] := dtpPoint(ARect.Right, ARect.Top);
  P[2] := dtpPoint(ARect.Right, ARect.Bottom);
  P[3] := dtpPoint(ARect.Left, ARect.Bottom);
  FTransform.XFormPoints(@P[0], 4);
  // Find Min/Max X, Min/Max Y
  XMinF := P[0].X;
  XMaxF := P[0].X;
  YMinF := P[0].Y;
  YMaxF := P[0].Y;
  for i := 1 to 3 do
  begin
    if P[i].X < XMinF then XMinF := P[i].X;
    if P[i].X > XMaxF then XMaxF := P[i].X;
    if P[i].Y < YMinF then YMinF := P[i].Y;
    if P[i].Y > YMaxF then YMaxF := P[i].Y;
  end;
  XMin := Max(floor(XMinF), 0);
  XMax := Min(ceil(XMaxF),  Dest.Width - 1);
  YMin := Max(floor(YMinF), 0);
  YMax := Min(ceil(YMaxF),  Dest.Height - 1);
  if YMax - YMin + 1 <= 0 then
    exit;
  SpanWidth := XMax - XMin + 1;
  if SpanWidth <= 0 then
    exit;

  // Sample spans
  for y := YMin to YMax do
  begin
    // Sample the span
    PBuf := SampleSpan(XMin, y, SpanWidth);
    // Merge it with the Dib
    if Map.MasterAlpha = $FF then
      MergeLine(PBuf, PdtpColor(FDest.PixelPtr[XMin, y]), SpanWidth)
    else
      MergeLineEx(PBuf, PdtpColor(FDest.PixelPtr[XMin, y]), SpanWidth, Map.MasterAlpha);
    Emms;
  end;
end;

function TdtpMapSampler.SampleSpan(X, Y, Count: integer): pointer;
begin
  SetLength(FBuffer, Max(Count * FElementSize, length(FBuffer)));
  FMapBufferFunc(X, Y, Count);
  Result := @FBuffer[0];
end;

procedure TdtpMapSampler.SetMap(const Value: TdtpBitmap);
begin
  FMap := Value;
end;

procedure TdtpMapSampler.SetOverSampling(const Value: integer);
var
  i, j: integer;
begin
  if FSamplingCount <> sqr(Value) then
  begin
    if (Value < 1) or (Value > cMaxOversampling) then
      raise Exception.Create(sIllegalOverSamplingValue);
    FSamplingCount := sqr(Value);
    if FSamplingCount = 1 then
      FMapBufferFunc := MapBufferLin1x1
    else
    begin
      FMapBufferFunc := MapBufferLinNxN;

      // sampling positions
      SetLength(FSamplingPoints, FSamplingCount);
      for i := 0 to Value - 1 do
        for j := 0 to Value - 1 do
          FSamplingPoints[i * Value + j] :=
            dtpPoint((i + 0.5) / Value - 0.5, (j + 0.5) / Value - 0.5);

    end;
    // sampling weights: to do
  end;
end;

end.

unit sdIntMap;

interface

uses
  Classes, SysUtils, Gr32_OrdinalMaps, Math;

type

  PIntegerArray = ^TIntegerArray;
  TIntegerArray = array[0..0] of integer;

  TsdIntMap = class(TPersistent)
  private
    FPixels: PIntegerArray;
    FHeight: integer;
    FWidth: integer;
    function GetPixels(X, Y: integer): integer;
    procedure SetPixels(X, Y: integer; const Value: integer);
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure BlurRecursive(Radius: single);
    procedure SetSize(AWidth, AHeight: integer);
    procedure Clear(Value: integer = 0);
    property Pixels[X, Y: integer]: integer read GetPixels write SetPixels; default;
    property Height: integer read FHeight;
    property Width: integer read FWidth;
    property Ints: PIntegerArray read FPixels;
  end;

implementation

type
  PInteger = ^integer;

procedure TransposeIntmap(Src, Dst: TsdIntMap; Width, Height: integer);
// Do nothing else than put the transposed bits from Src into Dst. So we do NOT
// set the bitmap sizes, nor is any error checking done.
var
  r, c: integer;
  P, Q: PInteger;
begin
  P := @Src.Ints[0];
  for r := 0 to Height - 1 do
  begin
    Q := @Dst.Ints[r];
    for c := 0 to Width - 1 do
    begin
      Q^ := P^;
      inc(Q, Height);
      inc(P);
    end;
  end;
end;

procedure RecursiveFilterHor(Src, Dst: TsdIntMap; Half, Length: integer);
// Do a recursive Rectangular Filter over a width of Length pixels, with the
// result value taken at Half. This filter assumes that the edge areas are empty
// so that all data can be processed in one long row.
var
  i: integer;
  P, Q, QEnd, R: PInteger;
  Total: integer;
  ASize: integer;
begin
  ASize := Src.Width * Src.Height;
  if ASize <> Dst.Width * Dst.Height then exit;
  if ASize < Length then exit;
  // Initialization of Total over Half pixels
  Total := 0;
  Q := @Src.Ints[0];
  for i := 0 to Half - 1 do
  begin
    inc(Total, Q^);
    inc(Q);
  end;
  // Start setting values
  R := @Dst.Ints[0];
  for i := Half to Length - 1 do
  begin
    inc(Total, Q^);
    R^ := Total div Length;
    inc(Q);
    inc(R);
  end;
  // Now run through all the bits
  P := @Src.Ints[0];
  QEnd := @Src.Ints[ASize];
  while integer(Q) < integer(QEnd) do
  begin
    inc(Total, integer(Q^) - integer(P^));
    R^ := Total div Length;
    inc(P);
    inc(Q);
    inc(R);
  end;
  // And do the last itty bitty
  while integer(R) < integer(@Dst.Ints[ASize]) do
  begin
    inc(Total, -integer(P^));
    R^ := Total div Length;
    inc(P);
    inc(R);
  end;
end;

{ TsdIntMap }

procedure TsdIntMap.Assign(Source: TPersistent);
var
  i: integer;
begin
  if Source is TByteMap then
  begin
    SetSize(TByteMap(Source).Width, TByteMap(Source).Height);
    for i := 0 to Width * Height - 1 do
      // Multiply by 256, in order to get more precision
      FPixels[i] := TByteMap(Source).Bits[i] shl 8;
  end else
    inherited;
end;

procedure TsdIntMap.BlurRecursive(Radius: single);
// This is a novice (not seen before) blurring algorithm that uses recursive
// filters to accomplish a closely matching gaussian blur.
// Copyright (c) by Nils Haeck
var
  i: integer;
  ATmp: TsdIntmap;
  AHalf1, AHalf2, ALength: integer;
begin
  // Determine recursive filter length
  ALength := round(Radius);
  if ALength < 2 then
    exit;
  if ALength = 2 then
    ALength := 3;
  AHalf1 := ALength div 2;
  AHalf2 := AHalf1;
  if not odd(ALength) then
    AHalf2 := Max(1, AHalf2 - 1);
  // Create intermediate bitmap to hold blur temp results
  ATmp := TsdIntmap.Create;
  try
    ATmp.SetSize(Width, Height);
    ATmp.Clear(0);
    // Repeat N times. After some internal debate and extensive testing, it
    // turns out that a value of N=2 is quite adequate. N=3 would also work
    // but since it is slower, it makes no sense. Going to higer values of N
    // will yield too much blur for small blur lengths. Theory states that
    // repeating this infinite times yields the gaussian.. (Rectangle ->
    // Triangle -> Hat-shape). Actually, N=2 means 4x horiz, 4x vertical
    for i := 1 to 2 do
    begin
      RecursiveFilterHor(Self, ATmp, AHalf1, ALength);
      RecursiveFilterHor(ATmp, Self, AHalf2, ALength);
    end;
    // Transpose the bits, so that the horizontal recursive filter works on
    // vertical columns
    TransposeIntmap(Self, ATmp, Width, Height);
    for i := 1 to 2 do
    begin
      RecursiveFilterHor(ATmp, Self, AHalf2, ALength);
      RecursiveFilterHor(Self, ATmp, AHalf1, ALength);
    end;
    // Transpose back
    TransposeIntmap(ATmp, Self, ATmp.Height, ATmp.Width);
    // Now we have the result back in DIB
  finally
    ATmp.Free;
  end;
end;

procedure TsdIntMap.Clear(Value: integer);
begin
  if assigned(FPixels) then
    FillChar(FPixels^, 0, FWidth * FHeight * SizeOf(integer));
end;

destructor TsdIntMap.Destroy;
begin
  if assigned(FPixels) then
    FreeMem(FPixels);
  FPixels := nil;
  inherited;
end;

function TsdIntMap.GetPixels(X, Y: integer): integer;
begin
  Result := 0;
  if (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
    Result := FPixels[X + Y * Width];
end;

procedure TsdIntMap.SetPixels(X, Y: integer; const Value: integer);
begin
  if (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
    FPixels[X + Y * Width] := Value;
end;

procedure TsdIntMap.SetSize(AWidth, AHeight: integer);
begin
  FWidth  := AWidth;
  FHeight := AHeight;
  if FPixels = nil then
    FPixels := AllocMem(FWidth * FHeight * SizeOf(integer))
  else
    ReallocMem(FPixels, FWidth * FHeight * SizeOf(integer));
end;

end.

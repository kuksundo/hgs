{  unit sdBitmapResize

  Author: Nils Haeck M.Sc.
  Creation Date: 27Oct2002

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.

  Version: 1.0

  Please visit http://www.simdesign.nl for more information.

  Copyright (c) 2002 - 2011 Simdesign B.V.
}
unit sdBitmapResize;

{$ifdef fpc}{$mode delphi}{$endif fpc}

interface

uses
  {$ifdef fpc}IntfGraphics,{$endif}
  Classes, Graphics, SysUtils, Math, sdBitmapConversionWin;

type
  PIntArray = ^TIntArray;
  TIntArray = array[0..MaxInt div SizeOf(integer) - 1] of integer;

// Create Den parts from Num, with startpoints in Start (zerobased) and Sizes in Size
procedure CreateDivision(Num, Den: integer; var Start, Size: array of integer);

// Downscale the Source bitmap to the size of the Dest bitmap, by using a smart
// averaging. The bitmaps must have pixelformat pf8bit, pf24bit or pf32bit, and
// these should be equal for Source and Dest.
procedure DownscaleBitmapWin(Source, Dest: TBitmap);

// for compatibility with older versions, there is the '24' version.
procedure DownscaleBitmap24(Source, Dest: TBitmap);

procedure UpscaleBitmap24(Source, Dest: TBitmap);

// Clear the Bitmap with value in Color
procedure ClearBitmap24(Bitmap: TBitmap; Color: TColor);

// Add bitmap A and B, add Bias and put in Result (Result = A + B + Bias)
procedure AddBitmap24(A, B, Result: TBitmap; Bias: integer);

// Substract bitmap B from bitmap A, add Bias, and put in Result (Result = A - B + Bias)
procedure SubstractBitmap24(A, B, Result: TBitmap; Bias: integer);

// Get the differences between bitmap A and B, put the result in Diff.
procedure GetDifferencesBitmap(A, B, Diff: TBitmap);

// Add the difference bitmap in Diff to A.
procedure PutDifferencesBitmap(A, Diff: TBitmap);

implementation

var
  ForwardDiffTable: array[-255..255] of byte;
  BackwardDiffTable: array[0..255] of integer;

procedure CreateDivision(Num, Den: integer; var Start, Size: array of integer);
// Create Den parts from Num, with startpoints in Start (zerobased) and Sizes in Size
var
  i, Run, Left, Width: integer;
begin
  Run := 0;
  Left := 0;
  Width := Num div Den;
  for i := 0 to Den - 1 do
  begin
    Start[i] := Left;
    Size[i] := Width;
    Run := Run + Num - Width * Den;
    if Run >= Den then
    begin
      inc(Size[i]);
      Run := Run - Den;
    end;
    inc(Left, Size[i]);
  end;
end;

procedure DownscaleBitmapWin(Source, Dest: TBitmap);
// Windows TBitmap version
// Downscale the Source bitmap to the size of the Dest bitmap, by using a smart
// averaging.
var
  ChannelCount: integer;
  r, br, c, bc, ch, Idx: integer;
  XStart, XSize: PIntArray;
  YStart, YSize: PIntArray;
  Target: PIntArray;
  Scan: PByte;
  SrcWidth, SrcHeight, DstWidth, DstHeight, Area: integer;
begin
  // assertions
  if not assigned(Source) or not assigned(Dest) then
    exit;

  if Source.PixelFormat <> Dest.PixelFormat then
    exit;

  case Source.PixelFormat of
  pf8bit:  ChannelCount := 1;
  pf24bit: ChannelCount := 3;
  pf32bit: ChannelCount := 4;
  else
    exit;
  end;

  SrcWidth  := Source.Width;
  SrcHeight := Source.Height;
  DstWidth  := Dest.Width;
  DstHeight := Dest.Height;

  // Use only for *down* sizing
  if (SrcWidth * SrcHeight = 0) or (DstWidth * DstHeight = 0) or
    (SrcWidth < DstWidth) or (SrcHeight < DstHeight) then exit;

  GetMem(XStart, DstWidth  * SizeOf(Integer));
  GetMem(XSize , DstWidth  * SizeOf(Integer));
  GetMem(YStart, DstHeight * SizeOf(Integer));
  GetMem(YSize , DstHeight * SizeOf(Integer));
  GetMem(Target, DstWidth  * SizeOf(Integer) * ChannelCount);
  try

    // Create divisions
    CreateDivision(SrcWidth, DstWidth , XStart^, XSize^);
    CreateDivision(SrcHeight, DstHeight, YStart^, YSize^);

    // Rows
    for r := 0 to DstHeight - 1 do
    begin
      // Clear temp target row
      FillChar(Target^, DstWidth * SizeOf(Integer) * ChannelCount, 0);
      for br := YStart[r] to YStart[r] + YSize[r] - 1 do
      begin
        // Scan is a pointer to the first byte of the row in the source rect
        Scan := GetBitmapScanline(Source, br);
        for c := 0 to DstWidth - 1 do
        begin
          for bc := 1 to XSize[c] do
          begin
            Idx := c * ChannelCount;
            for ch := 1 to ChannelCount do
            begin
              Inc(Target^[Idx], Scan^);
              inc(Scan);
              Inc(Idx);
            end;
          end;
        end;
      end;

      // averages
      Scan := GetBitmapScanline(Dest, r);
      Idx := 0;
      for c := 0 to DstWidth - 1 do
      begin
        Area := YSize[r] * XSize[c];
        for ch := 1 to ChannelCount do
        begin
          Scan^ := Target^[Idx] div Area;
          inc(Scan);
          inc(Idx);
        end;
      end;
    end;

  finally
    FreeMem(XStart);
    FreeMem(XSize);
    FreeMem(YStart);
    FreeMem(YSize);
    FreeMem(Target);
  end;

end;

procedure DownscaleBitmap24(Source, Dest: TBitmap);
begin
  // assertions
  if not assigned(Source) or not assigned(Dest) then
    exit;
  if Source.PixelFormat <> pf24bit then
    exit;
  DownscaleBitmapWin(Source, Dest);
end;

procedure UpscaleBitmap24(Source, Dest: TBitmap);
var
  XStart, XSize: PIntArray;
  YStart, YSize: PIntArray;
  S, D, D0: PByte;
  x, y, xi, yi, R, G, B: integer;
  SrcWidth, SrcHeight, DstWidth, DstHeight: integer;
begin
  // assertions
  if not assigned(Source) or not assigned(Dest) then
    exit;
  if (Source.PixelFormat <> pf24bit) or (Dest.PixelFormat <> pf24Bit) then
    exit;

  SrcWidth  := Source.Width;
  SrcHeight := Source.Height;
  DstWidth  := Dest.Width;
  DstHeight := Dest.Height;

  if (SrcWidth * SrcHeight = 0) or (DstWidth * DstHeight = 0) or
    (SrcWidth > DstWidth) or (SrcHeight > DstHeight) then
    exit;

  GetMem(XStart, SrcWidth  * SizeOf(Integer));
  GetMem(XSize , SrcWidth  * SizeOf(Integer));
  GetMem(YStart, SrcHeight * SizeOf(Integer));
  GetMem(YSize , SrcHeight * SizeOf(Integer));
  try

    // Create divisions
    CreateDivision(DstWidth, SrcWidth , XStart^, XSize^);
    CreateDivision(DstHeight, SrcHeight, YStart^, YSize^);

    for y := 0 to SrcHeight - 1 do
    begin
      S := GetBitmapScanline(Source, y);
      D := GetBitmapScanline(Dest, YStart[y]);
      D0 := D;
      for x := 0 to SrcWidth - 1 do
      begin
        B := S^; inc(S);
        G := S^; inc(S);
        R := S^; inc(S);
        for xi := 0 to XSize[x] - 1 do
        begin
          D^ := B; inc(D);
          D^ := G; inc(D);
          D^ := R; inc(D);
        end;
      end;

      // Copy scanlines
      for yi := 1 to Ysize[y] - 1 do
        Move(D0^, GetBitmapScanline(Dest, YStart[y] + yi)^, DstWidth * 3);
    end;

  finally
    FreeMem(XStart);
    FreeMem(XSize);
    FreeMem(YStart);
    FreeMem(YSize);
  end;
end;

procedure ClearBitmap24(Bitmap: TBitmap; Color: TColor);
begin
  Bitmap.Canvas.Brush.Style := bsSolid;
  Bitmap.Canvas.Brush.Color := Color;
  Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));
end;

procedure AddBitmap24(A, B, Result: TBitmap; Bias: integer);
var
  x, y: integer;
  P, Q, R: PByte;
begin
  // Checks
  if not assigned(A) or not assigned(B) or not assigned(Result) then
    exit;
  if (A.Width <> B.Width) or (A.Height <> B.Height) then
    exit;
  if (A.PixelFormat <> pf24bit) or( B.PixelFormat <> pf24bit) then
    exit;

  // Set Result size
  if (Result <> A) and (Result <> B) then
  begin
    Result.PixelFormat := pf24bit;
    Result.Width := A.Width;
    Result.Height := A.Height;
  end;

  for y := 0 to A.Height - 1 do
  begin
    P := GetBitmapScanline(A, y);
    Q := GetBitmapScanline(B, y);
    R := GetBitmapScanline(Result, y);
    for x := 0 to A.Width * 3 - 1 do
    begin
      R^ := Min(255, Max(0, P^ + Q^ + Bias));
      inc(P);
      inc(Q);
      inc(R);
    end;
  end;
end;

procedure SubstractBitmap24(A, B, Result: TBitmap; Bias: integer);
var
  x, y: integer;
  P, Q, R: PByte;
begin
  // Checks
  if not assigned(A) or not assigned(B) or not assigned(Result) then
    exit;
  if (A.Width <> B.Width) or (A.Height <> B.Height) then
    exit;
  if (A.PixelFormat <> pf24bit) or (B.PixelFormat <> pf24bit) then
    exit;

  // Set Result size
  if (Result <> A) and (Result <> B) then
  begin
    Result.PixelFormat := pf24bit;
    Result.Width := A.Width;
    Result.Height := A.Height;
  end;

  for y := 0 to A.Height - 1 do
  begin
    P := GetBitmapScanline(A, y);
    Q := GetBitmapScanline(B, y);
    R := GetBitmapScanline(Result, y);
    for x := 0 to A.Width * 3 - 1 do
    begin
      R^ := Min(255, Max(0, P^ - Q^ + Bias));
      inc(P);
      inc(Q);
      inc(R);
    end;
  end;
end;

procedure CreateDiffTables;
var
  i: integer;
begin
  for i := -255 to 255 do
  begin
    if i < -40 then
    begin
      ForwardDiffTable[i] := round((i + 255) / (255 - 41) * 87);
    end else
      if i > 40 then
      begin
        ForwardDiffTable[i] := round((i - 41) / (255 - 41) * 86 + 169);
      end else
        // i between -40 and 40
        ForwardDiffTable[i] := i + 128;
    BackwardDiffTable[ForwardDiffTable[i]] := i;
  end;
end;

procedure GetDifferencesBitmap(A, B, Diff: TBitmap);
var
  x, y: integer;
  P, Q, R: PByte;
begin
  // Checks
  if not assigned(A) or not assigned(B) or not assigned(Diff) then
    exit;
  if (A.Width <> B.Width) or (A.Height <> B.Height) then
    exit;
  if (A.PixelFormat <> pf24bit) or( B.PixelFormat <> pf24bit) then
    exit;

  // Set Result size
  Diff.PixelFormat := pf24bit;
  Diff.Width := A.Width;
  Diff.Height := A.Height;

  for y := 0 to A.Height - 1 do
  begin
    P := GetBitmapScanline(A, y);
    Q := GetBitmapScanline(B, y);
    R := GetBitmapScanline(Diff, y);
    for x := 0 to A.Width * 3 - 1 do
    begin
      R^ := ForwardDiffTable[Q^ - P^];
      inc(P);
      inc(Q);
      inc(R);
    end;
  end;
end;

procedure PutDifferencesBitmap(A, Diff: TBitmap);
var
  x, y: integer;
  P, Q: PByte;
begin
  // Checks
  if not assigned(A) or not assigned(Diff) then
    exit;
  if (A.Width <> Diff.Width) or (A.Height <> Diff.Height) then
    exit;
  if (A.PixelFormat <> pf24bit) or( Diff.PixelFormat <> pf24bit) then
    exit;

  for y := 0 to A.Height - 1 do
  begin
    P := GetBitmapScanline(A, y);
    Q := GetBitmapScanline(Diff, y);
    for x := 0 to A.Width * 3 - 1 do
    begin
      P^ := Min(255, Max(0, P^ + BackwardDiffTable[Q^]));
      inc(P);
      inc(Q);
    end;
  end;
end;

initialization
  CreateDiffTables;

end.

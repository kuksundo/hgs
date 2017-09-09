{  unit sdBitmapConversionWin

  Conversion routines for windows bitmaps (TBitmap class). This unit also contains
  methods to generate palettes for 8bit TBitmap objects.

  Author: Nils Haeck M.Sc.
  Copyright (c) 2007 - 2011 Simdesign B.V.

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.

  Please visit http://www.simdesign.nl for more information.
}
unit sdBitmapConversionWin;

{$ifdef fpc}{$mode delphi}{$endif fpc}

interface

uses
  {$ifdef FPC}IntfGraphics, Lindows,{$else}Windows,{$endif} //requires windows hpalette
  SysUtils, Controls, Graphics, sdMapIterator;

type

  TsdGrayscaleConversion  = (
    gcUniform,   // Convert bits to grayscale as (R+G+B) / 3
    gcWeighted,  // Use weighted formula fitting with eye sensitivity
    gcRed,       // Use the red color of the bits
    gcGreen,     // Use the green color of the bits
    gcBlue       // Use the blue color of the bits
  );

  T32bitPaletteEntry = packed record
    case integer of
    0: (R, G, B, A: byte);
    1: (Color: longint);
  end;
  T8bitPaletteArray = array[0..255] of T32bitPaletteEntry;

// Windows TBitmap pixelformat based on byte count per cell
function WinPixelFormatFromByteCount(AByteCount: integer): TPixelFormat;

// construct a TsdMapIterator object with the info from ABitmap.
procedure GetBitmapIterator(ABitmap: TBitmap; {var }AIterator: TsdMapIterator);

// create a TBitmap based on the information in AIterator
function SetBitmapFromIterator(const AIterator: TsdMapIterator): TBitmap;

// convert a pf24bit color bitmap to pf8bit grayscale bitmap
procedure BitmapToGrayScale24To8(Source: TBitmap; Dest: TBitmap; AMethod: TsdGrayscaleConversion);

// Perform the operation in AOperation on Src, with the result in Dst. Both
// Src and Dst must be assigned!
procedure BitmapOperation(Src, Dst: TBitmap; AOperation: TsdMapOperation);

procedure FillBitmap8bit(AMap: TsdMapIterator; AValue: byte);

procedure SetBitmap8bitPalette(const Palette: T8bitPaletteArray; Bitmap: TBitmap; NumColors: integer);

// Set the palette of a pf8bit bitmap to a grayscale palette, starting at [0, 0, 0] for
// index 0 and ending at [255, 255, 255] for index 255.
procedure SetBitmap8bitGrayscale(Bitmap: TBitmap);

// Set the palette of a pf8bit bitmap to a grayscale palette, starting at [255, 255, 255] for
// index 0 and ending at [0, 0, 0] for index 255.
procedure SetBitmap8bitInverseGrayscale(Bitmap: TBitmap);

// A rainbow palette for imaging tasks requiring some nice colour transitions
procedure SetBitmap8bitRainbow(Bitmap: TBitmap);

// A bi-colour (black/white) palette, Bitmap.PixelFormat will be set to pf8bit though
procedure SetBitmap8bitBlackWhite(Bitmap: TBitmap);

// Interpolate colors Col1 and Col2 using a fraction in range [0..1]
function InterpolateColor(Col1, Col2: longint; Frac: single): longint;

// cross-platform scanline getter for TBitmap
function GetBitmapScanline(ABitmap: TBitmap; Y: integer): pointer;

resourcestring

  sInvalidPixelFormat = 'Invalid pixelformat';
  sIncompatiblePixelFormats = 'incompatible pixel formats';

implementation

function GetBitmapScanline(ABitmap: TBitmap; Y: integer): pointer;
begin
  Result := ABitmap.ScanLine[Y];
end;

function WinPixelFormatFromByteCount(AByteCount: integer): TPixelFormat;
begin
  case AByteCount of
  1: Result := pf8bit;
  2: Result := pf16bit;
  3: Result := pf24bit;
  4: Result := pf32bit;
  else
    raise Exception.Create(sInvalidPixelFormat);
  end;
end;

function WinPixelFormatToBitCount(APixelFormat: TPixelFormat): integer;
begin
  case APixelFormat of
  pf1bit: Result := 1;
  pf4bit: Result := 4;
  pf8bit: Result := 8;
  pf15bit: Result := 15;
  pf16bit: Result := 16;
  pf24bit: Result := 24;
  pf32bit: Result := 32;
  else
    // we do not know pfDevice and pfCustom
    Result := 0;
  end;
end;

function WinPixelFormatToByteCount(APixelFormat: TPixelFormat): integer;
begin
  case APixelFormat of
  pf8bit:  Result := 1;
  pf15bit, pf16bit: Result := 2;
  pf24bit: Result := 3;
  pf32bit: Result := 4;
  else
    // iteration not possible with pf4bit, pf2bit and pf1bit
    //raise Exception.Create(sInvalidPixelFormat);
    Result := 0;
  end;
end;

procedure GetBitmapIterator(ABitmap: TBitmap; AIterator: TsdMapIterator);
begin
  AIterator.Width := ABitmap.Width;
  AIterator.Height := ABitmap.Height;
  if ABitmap.Width * ABitmap.Height = 0 then
    exit;
  AIterator.Map := GetBitmapScanline(ABitmap, 0);
  if AIterator.Height > 1 then
    AIterator.ScanStride := integer(GetBitmapScanline(ABitmap, 1)) - integer(GetBitmapScanline(ABitmap, 0))
  else
    AIterator.ScanStride := 0;

  AIterator.CellStride := WinPixelFormatToByteCount(ABitmap.PixelFormat);
  AIterator.BitCount := WinPixelFormatToBitCount(ABitmap.PixelFormat);
end;

function SetBitmapFromIterator(const AIterator: TsdMapIterator): TBitmap;
begin
  Result := TBitmap.Create;
  Result.Width := AIterator.Width;
  Result.Height := AIterator.Height;
  Result.PixelFormat := WinPixelFormatFromByteCount(AIterator.CellStride);
end;

procedure ToGrayscale3ChTo1Ch(SIter, DIter: TsdMapIterator; AMethod: TsdGrayscaleConversion);
var
  S, D: pbyte;
  Val: integer;
begin
  if (SIter.CellStride < 3) or (DIter.CellStride < 1) then
    raise Exception.Create('Invalid cellstride');

  // RGB are layed out in memory as BGR
  case AMethod of
  gcRed:   SIter.IncrementMap(2);
  gcGreen: SIter.IncrementMap(1);
  gcBlue:  SIter.IncrementMap(0);
  end;//case
  S := SIter.First;
  D := DIter.First;
  case AMethod of

  gcUniform:
    while assigned(S) do
    begin
      Val := S^;
      inc(S);
      inc(Val, S^);
      inc(S);
      inc(Val, S^);
      D^ := Val div 3;
      S := SIter.Next;
      D := DIter.Next;
    end;

  gcWeighted:
    // (R * 61 + G * 174 + B * 21) / 256
    while assigned(S) do
    begin
      Val := S^ * 21;
      inc(S);
      inc(Val, S^ * 174);
      inc(S);
      inc(Val, S^ * 61);
      D^ := Val shr 8;
      S := SIter.Next;
      D := DIter.Next;
    end;

  gcRed, gcGreen, gcBlue:
    while assigned(S) do
    begin
      D^ := S^;
      S := SIter.Next;
      D := DIter.Next;
    end;
  end;
end;

procedure FillBitmap8bit(AMap: TsdMapIterator; AValue: byte);
var
  P: Pbyte;
begin
  P := AMap.First;
  while assigned(P) do
  begin
    P^ := AValue;
    P := AMap.Next;
  end;
end;

procedure BitmapToGrayScale24To8(Source: TBitmap; Dest: TBitmap; AMethod: TsdGrayscaleConversion);
var
  SIter, DIter: TsdMapIterator;
begin
  SIter := TsdMapIterator.Create;
  DIter := TsdMapIterator.Create;
  try
    GetBitmapIterator(Source, SIter);
    GetBitmapIterator(Dest, DIter);
    ToGrayScale3ChTo1Ch(SIter, DIter, AMethod);
  finally
    SIter.Free;
    DIter.Free;
  end;
end;

procedure BitmapOperation(Src, Dst: TBitmap; AOperation: TsdMapOperation);
var
  SI: TsdMapIterator;
  DI: TsdMapIterator;
begin
  case AOperation of
  moRotate90, moRotate270, moTranspose:
    begin
      Dst.Width := Src.Height;
      Dst.Height := Src.Width;
    end;
  moRotate180, moMirror, moFlip:
    begin
      Dst.Width := Src.Width;
      Dst.Height := Src.Height;
    end;
  end;

  // Create bitmap iterators
  SI := TsdMapIterator.Create;
  DI := TsdMapIterator.Create;
  try
    GetBitmapIterator(Src, SI);
    GetBitmapIterator(Dst, DI);
    // Check if cellstrides are equal
    if SI.CellStride <> DI.CellStride then
      raise Exception.Create(sIncompatiblePixelFormats);
    // Do the operation
    PerformMapOperation(SI, DI, AOperation);
  finally
    SI.Free;
    DI.Free;
  end;
end;

procedure SetBitmap8bitPalette(const Palette: T8bitPaletteArray; Bitmap: TBitmap; NumColors: integer);
// Add a N-color palette to a bitmap
var
  i, y: integer;
  pal, pentry: pbyte;
  hpal: HPALETTE;
begin
  if not assigned(Bitmap) then
    exit;

  // 8 bits per pixel
  Bitmap.PixelFormat := pf8bit;

  // Create a Win32 palette
  GetMem(pal, sizeof(TLogPalette) + sizeof(TPaletteEntry) * NumColors);
  try
    PLogPalette(pal).palVersion := $300;
    PLogPalette(pal).palNumEntries := NumColors;
    pentry := pal;
    inc(pentry, SizeOf(TLogPalette) - SizeOf(TPaletteEntry));
    for i := 0 to NumColors - 1 do
    begin
      PPaletteEntry(pentry).peRed   := Palette[i].R;
      PPaletteEntry(pentry).peGreen := Palette[i].G;
      PPaletteEntry(pentry).peBlue  := Palette[i].B;
      inc(pentry, SizeOf(TPaletteEntry));
    end;
    hpal := CreatePalette(PLogPalette(pal)^);
    if hpal <> 0 then
      Bitmap.Palette := hpal;
  finally
    FreeMem(pal);
  end;

  // Fill bitmap with background color
  for y := 0 to Bitmap.Height - 1 do
    FillChar(GetBitmapScanline(Bitmap, y)^, Bitmap.Width, 0);
end;

procedure SetBitmap8bitGrayscale(Bitmap: TBitmap);
var
  i: integer;
  APal: T8bitPaletteArray;
begin
  // Create grayscale palette
  for i := 0 to 255 do
  begin
    APal[i].R := i;
    APal[i].G := i;
    APal[i].B := i;
  end;
  // Set it for the bitmap
  SetBitmap8bitPalette(APal, Bitmap, 256);
end;

procedure SetBitmap8bitInverseGrayscale(Bitmap: TBitmap);
var
  i: integer;
  APal: T8bitPaletteArray;
begin
  // Create grayscale palette
  for i := 0 to 255 do
  begin
    APal[i].R := 255 - i;
    APal[i].G := 255 - i;
    APal[i].B := 255 - i;
  end;
  // Set it for the bitmap
  SetBitmap8bitPalette(APal, Bitmap, 256);
end;

function InterpolateColor(Col1, Col2: longint; Frac: single): longint;
begin
  Result :=
    Round((Col1 shr 16 and $FF) * (1 - Frac) + (Col2 shr 16 and $FF) * Frac) shl 16 +
    Round((Col1 shr  8 and $FF) * (1 - Frac) + (Col2 shr  8 and $FF) * Frac) shl  8 +
    Round((Col1        and $FF) * (1 - Frac) + (Col2        and $FF) * Frac);
end;

procedure SetBitmap8bitRainbow(Bitmap: TBitmap);
// A rainbow palette for imaging tasks requiring some nice colour transitions
var
  i: integer;
  Col0, Col1, Col2, Col3, Col4, Col5: integer;
  APal: T8bitPaletteArray;
begin
  Col0 := $00000000; // Black
  Col1 := $00FF00FF; // Magenta
  Col2 := $00FF0000; // Blue
  Col3 := $0000FF00; // Green
  Col4 := $0000FFFF; // Yellow
  Col5 := $000000FF; // Red
  //
  for i := 0 to 50 do
  begin
    APal[i      ].Color := InterpolateColor(Col0, Col1, i / 51);
    APal[i +  51].Color := InterpolateColor(Col1, Col2, i / 51);
    APal[i + 102].Color := InterpolateColor(Col2, Col3, i / 51);
    APal[i + 153].Color := InterpolateColor(Col3, Col4, i / 51);
    APal[i + 204].Color := InterpolateColor(Col4, Col5, i / 51);
  end;
  APal[255].Color := Col5;
  // Set it for the bitmap
  SetBitmap8bitPalette(APal, Bitmap, 256);
end;

procedure SetBitmap8bitBlackWhite(Bitmap: TBitmap);
// Add a 2-color palette to a bitmap
var
  APal: T8bitPaletteArray;
begin
  if not assigned(Bitmap) then
    exit;
  // 8 bits per pixel
  Bitmap.PixelFormat := pf8bit;

  // Create a 2-color palette with black and white
  APal[0].R := 0;
  APal[0].G := 0;
  APal[0].B := 0;
  APal[1].R := $FF;
  APal[1].G := $FF;
  APal[1].B := $FF;

  SetBitmap8bitPalette(APal, Bitmap, 2);
end;

end.

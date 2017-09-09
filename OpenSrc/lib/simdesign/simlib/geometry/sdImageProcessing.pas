unit sdImageProcessing;

interface

uses
  Windows, Graphics;

type

  TDeinterlaceMethod = (
    dmDeleteScans  // Simply delete scans and replace with interpolated result
  );

  TDeinterlaceScanChoice = (
    dsEven,  // delete even scanlines
    dsOdd    // delete odd scanlines
  );

  TGrayscaleConvertMethod = (
    gcAverage,        // Average R, G and B channels
    gcWeighted,       // weight channels R, G and B with formula for eye sensibility
    gcPreserveRed,    // Preserve red channel
    gcPreserveGreen,  // Preserve green channel
    gcPreserveBlue    // Preserve blue channel
  );

// Deinterlace the bitmap with Method, and use ScanChoice (scOdd/scEven) scanlines
procedure DeinterlaceBitmap(Source, Dest: TBitmap; Method: TDeinterlaceMethod;
  ScanChoice: TDeinterlaceScanChoice);

procedure GrayscaleConvertBitmap(Source, Dest: TBitmap; Method: TGrayscaleConvertMethod);

procedure InvertBitmap(Source, Dest: TBitmap);

procedure LocalMinimumBitmap(Source, Dest: TBitmap; RegionWidth, RegionHeight: integer);
procedure LocalMaximumBitmap(Source, Dest: TBitmap; RegionWidth, RegionHeight: integer);

procedure AdaptiveEqualizeBitmap(Source, Dest: TBitmap; MinRegionX, MinRegionY, MaxRegionX, MaxRegionY: integer);

procedure ThresholdBitmap(Source, Dest: TBitmap; Threshold: integer);

// Set the palette of a pf8bit bitmap to a grayscale palette, starting at [0, 0, 0] for
// index 0 and ending at [255, 255, 255] for index 255.
procedure GrayScalePalette(Bitmap: TBitmap);

implementation

uses
  sdBytemap;

procedure DeinterlaceBitmap(Source, Dest: TBitmap; Method: TDeinterlaceMethod;
  ScanChoice: TDeinterlaceScanChoice);
var
  y: integer;
  ScanWidth: integer;
// local
procedure CopyScanline(SourceRow, DestRow: integer);
var
  SourceScan, DestScan: pointer;
begin
  SourceScan := Source.ScanLine[SourceRow];
  DestScan := Dest.ScanLine[DestRow];
  Move(SourceScan^, DestScan^, ScanWidth);
end;
// local
procedure InterpolateScanline(BelowRow, AboveRow, DestRow: integer);
var
  S1, S2, D: PByte;
  x: integer;
begin
  S1 := Source.ScanLine[BelowRow];
  S2 := Source.ScanLine[AboveRow];
  D := Dest.ScanLine[DestRow];
  for x := 0 to ScanWidth - 1 do begin
    D^ := (S1^ + S2^) shr 1;
    inc(S1); inc(S2); inc(D);
  end;
end;
// main
begin
  // Checks
  if not assigned(Source) or not assigned(Dest) then exit;
  if not (Source.PixelFormat in [pf8bit, pf24bit]) then exit;

  if Source <> Dest then
    Dest.Assign(Source);
  if Source.Height < 2 then exit;

  // Scanwidth
  case Source.PixelFormat of
  pf8bit:  ScanWidth := Source.Width;
  pf24bit: ScanWidth := Source.Width * 3;
  end;//case

  case Method of
  dmDeleteScans:
    begin
      // Loop through rows
      for y := 0 to Source.Height - 1 do begin
        // Process either even or odd lines
        if Odd(y) xor (ScanChoice = dsEven) then begin
          if y = 0 then
            CopyScanline(1, y)
          else
            if y = Source.Height - 1 then
              CopyScanline(Source.Height - 2, y)
          else
            InterpolateScanline(y - 1, y + 1, y);
        end;
      end;
    end;
  end;//case
end;

procedure GrayscaleConvertBitmap(Source, Dest: TBitmap; Method: TGrayscaleConvertMethod);
var
  x, y: integer;
  R, G, B, D: PByte;
begin
  // Checks
  if not assigned(Source) or not assigned(Dest) then exit;
  if Dest = Source then exit;
  if Source.PixelFormat <> pf24bit then exit;

  Dest.Pixelformat := pf8bit;
  Dest.Width := Source.Width;
  Dest.Height := Source.Height;

  // Loop through rows
  for y := 0 to Source.Height - 1 do begin

    // Pointers to colors
    B := Source.ScanLine[y];
    G := B; inc(G);
    R := G; inc(R);
    // pointer to destination
    D := Dest.ScanLine[y];

    // Loop through pixels
    for x := 0 to Source.Width - 1 do begin
      case Method of
      gcAverage:
        begin
          D^ := (R^ + G^ + B^) div 3;
          inc(R, 3); inc(G, 3); inc(B, 3);
        end;
      gcWeighted:
        // Intensity = (R * 61 + G * 174 + B * 21) / 256
        begin
          D^ := (R^ * 61 + G^ * 174 + B^ * 21) shr 8;
          inc(R, 3); inc(G, 3); inc(B, 3);
        end;
      gcPreserveRed:
        begin
          D^ := R^;
          inc(R, 3);
        end;
      gcPreserveGreen:
        begin
          D^ := G^;
          inc(G, 3);
        end;
      gcPreserveBlue:
        begin
          D^ := B^;
          inc(B, 3);
        end;
      end;//case
      inc(D);
    end;
  end;
end;

procedure InvertBitmap(Source, Dest: TBitmap);
var
  x, y: integer;
  S, D: PByte;
  ScanWidth: integer;
begin
  // Checks
  if not assigned(Source) or not assigned(Dest) then exit;
  if not (Source.PixelFormat in [pf8bit, pf24bit]) then exit;

  Dest.PixelFormat := Source.PixelFormat;
  Dest.Width := Source.Width;
  Dest.Height := Source.Height;

  // Scanwidth
  case Source.PixelFormat of
  pf8bit:  ScanWidth := Source.Width;
  pf24bit: ScanWidth := Source.Width * 3;
  else
    ScanWidth := 0;
  end;//case

  // Loop through rows
  for y := 0 to Source.Height - 1 do begin
    S := Source.ScanLine[y];
    D := Dest.ScanLine[y];
    for x := 0 to ScanWidth - 1 do begin
      D^ := 255 - S^;
      inc(S); inc(D);
    end;
  end;
end;

procedure LocalMinimumBitmap(Source, Dest: TBitmap; RegionWidth, RegionHeight: integer);
var
  SrcMap, MinMap: TsdByteMap;
begin
  // Checks
  if not assigned(Source) or not assigned(Dest) then exit;
  if Source.PixelFormat <> pf8bit then exit;
  Dest.PixelFormat := pf8bit;

  // Create bytemaps first
  SrcMap := TsdByteMap.Create;
  MinMap := TsdBytemap.Create;
  try
    SrcMap.Assign(Source);
    LocalMinimumMap(SrcMap, MinMap, RegionWidth, RegionHeight);
    MinMap.BlurExt(RegionWidth, RegionHeight, 1);
    // Assign to dest
    Dest.Assign(MinMap);
  finally
    SrcMap.Free;
    MinMap.Free;
  end;
end;

procedure LocalMaximumBitmap(Source, Dest: TBitmap; RegionWidth, RegionHeight: integer);
var
  SrcMap, MaxMap: TsdByteMap;
begin
  // Checks
  if not assigned(Source) or not assigned(Dest) then exit;
  if Source.PixelFormat <> pf8bit then exit;
  Dest.PixelFormat := pf8bit;

  // Create bytemaps first
  SrcMap := TsdByteMap.Create;
  MaxMap := TsdBytemap.Create;
  try
    SrcMap.Assign(Source);
    LocalMaximumMap(SrcMap, MaxMap, RegionWidth, RegionHeight);
    MaxMap.BlurExt(RegionWidth, RegionHeight, 1);
    // Assign to dest
    Dest.Assign(MaxMap);
  finally
    SrcMap.Free;
    MaxMap.Free;
  end;
end;

procedure AdaptiveEqualizeBitmap(Source, Dest: TBitmap; MinRegionX, MinRegionY, MaxRegionX, MaxRegionY: integer);
var
  SrcMap, MinMap, MaxMap: TsdByteMap;
begin
  // Checks
  if not assigned(Source) or not assigned(Dest) then exit;
  if Source.PixelFormat <> pf8bit then exit;
  Dest.PixelFormat := pf8bit;

  // Create bytemaps first
  SrcMap := TsdByteMap.Create;
  MinMap := TsdBytemap.Create;
  MaxMap := TsdByteMap.Create;
  try
    SrcMap.Assign(Source);
    LocalMinimumMap(SrcMap, MinMap, MinRegionX, MinRegionY);
    MinMap.BlurExt(MinRegionX, MinRegionY, 1);
    LocalMaximumMap(SrcMap, MaxMap, MaxRegionX, MaxRegionY);
    MaxMap.BlurExt(MaxRegionX, MaxRegionY, 1);
    EqualizeMap(SrcMap, MinMap, MaxMap, SrcMap, 50);
    // Assign to dest
    Dest.Assign(SrcMap);
  finally
    SrcMap.Free;
    MinMap.Free;
    MaxMap.Free;
  end;
end;

procedure ThresholdBitmap(Source, Dest: TBitmap; Threshold: integer);
var
  x, y: integer;
  S, D: PByte;
  ScanWidth: integer;
begin
  // Checks
  if not assigned(Source) or not assigned(Dest) then exit;
  if not (Source.PixelFormat in [pf8bit, pf24bit]) then exit;

  Dest.PixelFormat := Source.PixelFormat;
  Dest.Width := Source.Width;
  Dest.Height := Source.Height;

  // Scanwidth
  case Source.PixelFormat of
  pf8bit:  ScanWidth := Source.Width;
  pf24bit: ScanWidth := Source.Width * 3;
  else
    ScanWidth := 0;
  end;//case

  // Loop through rows
  for y := 0 to Source.Height - 1 do begin
    S := Source.ScanLine[y];
    D := Dest.ScanLine[y];
    for x := 0 to ScanWidth - 1 do begin
      if S^ >= Threshold then D^ := 255 else D^ := 0;
      inc(S); inc(D);
    end;
  end;
end;

procedure GrayScalePalette(Bitmap: TBitmap);
// Add a 256-color palette to a bitmap
var
  i: integer;
  pal: PLogPalette;
  hpal: HPALETTE;
begin
  if not assigned(Bitmap) then exit;
  // 8 bits per pixel?
  if not (Bitmap.PixelFormat = pf8bit) then exit;

  // Create a gradient palette between foreground and background color
  GetMem(pal, sizeof(TLogPalette) + sizeof(TPaletteEntry) * 256);
  try
    pal.palVersion := $300;
    pal.palNumEntries := 256;
    for i := 0 to 255 do begin
      pal.palPalEntry[i].peRed   := i;
      pal.palPalEntry[i].peGreen := i;
      pal.palPalEntry[i].peBlue  := i;
    end;
    hpal := CreatePalette(pal^);
    if hpal <> 0 then
      Bitmap.Palette := hpal;
  finally
    FreeMem(pal);
  end;

end;

end.

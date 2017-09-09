{
  Unit dtpUtil

  Graphical and other utility procedures and functions, used by the dtpXXXX
  components.

  Project: DTP-Engine

  Creation Date: 02-11-2002 (NH)

  Modifications:
  21-08-2003: Added BlurRecursive, a pseudo-Gaussian blur routine.

  Version: 1.0

  Copyright (c) 2002 - 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpUtil;

{$i simdesign.inc}

interface

uses

  Types, Windows, Classes, SysUtils, dtpGraphics, Math;

type
  // A record approach to TColor32 .. for instance cast TARGB(MyColor).Red
  TARGB = packed record
    Blue, Green, Red, Alpha: byte;
  end;

// NearLine calculates the square of the minimum distance of a point to a line.
// P is the point, the line is between points A and B.
function NearLine(P: TPoint; A, B: TPoint): double;

// BitmapBlendTo will blend ASource to ADest, at location ALeft, ATop, using a
// factor of Alpha ($00 = nothing appears, $FF = ASource completely overwrites)
procedure BitmapBlendTo(ASource, ADest: TdtpBitmap; ALeft, ATop: integer; Alpha: integer);

// Rotating and flipping
procedure DIBRotate90(Bitmap: TdtpBitmap);
procedure DIBRotate180(Bitmap: TdtpBitmap);
procedure DIBRotate270(Bitmap: TdtpBitmap);
procedure DIBMirror(Bitmap: TdtpBitmap);
procedure DIBFlip(Bitmap: TdtpBitmap);

procedure BlueChannelToAlphaAndColor(Dst, Src: TdtpBitmap; Color: TdtpColor; BkColor: TdtpColor = clWhite32);

// Alpha processing @ 16 bit integer precision
procedure AlphaShr16Intensity(DIB: TdtpBitmap; Intensity: single);
procedure AlphaShl16Color(DIB: TdtpBitmap; AColor: TdtpColor);

// Recursive blurring algorithm, mimicks pure gaussian blur, much faster
procedure BlurRecursive(DIB: TdtpBitmap; Radius: single);

// Feather the bitmap DIB by Radius
procedure Feather(DIB: TdtpBitmap; Radius: single);

// Merge two layers, preserving Alpha correctly
procedure MergeLayers(Fg, Bg: TdtpBitmap; MasterAlpha: byte = $FF);

// Roll a bitmap over Dx, Dy. This procedure *LOOSES* the information that slid out
procedure Roll(DIB: TdtpBitmap; Dx, Dy: integer);

// Puts the transposed bits from Src into Dst. This procedure does not change
// Width / Height of the bitmaps; this must/can be done by the caller. The
// procedure *assumes* that Src has Width and Height dimensions. No error checking!
procedure TransposeBits(Src, Dst: TdtpBitmap; Width, Height: integer);

// Invert the data in the Alpha channel
procedure InvertAlpha(ADib: TdtpBitmap);

// Blending colors but keeping intact the target Alpha
function Merge(F, B, FM: TdtpColor): TdtpColor;

// Blend colors, keep intact the target Alpha, for whole scanline
procedure MergeLine(Src, Dst: PdtpColor; Count: Integer; Alpha: TdtpColor);

// Blend the (semi)transparent parts of ADib with BkColor, thus creating a TBitmap32
// with an alpha channel that is $FF everywhere
procedure FillTransparentParts(ADib: TdtpBitmap; BkColor: TdtpColor);

// Create a colormap with type AConversion, then assign it back to ADib
procedure FilterColorChannel(ADib: TdtpBitmap; AConversion: TdtpConversionType);

// Check if the bitmap ADib is completely filled with color AColor, if so, return True
function IsBitmapSingleColor(ADib: TdtpBitmap; const AColor: TdtpColor): boolean;

// Create a list of available fonts on the system and put them in stringlist AList.
// AList must be initialized and will be cleared before strings are added.
procedure FontnamesList(const AList: TStrings);

implementation

function PointToPointDist2(A, B: TPoint): integer;
begin
  Result := sqr(B.X - A.X) + sqr(B.Y - A.Y);
end;

function NearLine(P: TPoint; A, B: TPoint): double;
var
  q: double;
begin
  if (A.X = B.X) and (A.Y = B.Y) then
  begin

    // Point to point
    Result := PointToPointDist2(P, A);

  end else
  begin

    // Minimum
    q := ((P.X - A.X) * (B.X - A.X) + (P.Y - A.Y) * (B.Y - A.Y)) /
          (sqr(B.X - A.X) + sqr(B.Y - A.Y));

    // Limit q to 0 <= q <= 1
    if q < 0 then
      q := 0;
    if q > 1 then
      q := 1;

    // Distance
    Result := PointToPointDist2(P, Point(dtpPoint((1 - q) * A.X + q * B.X, (1 - q) * A.Y + q * B.Y)));

  end;
end;

procedure BitmapBlendTo(ASource, ADest: TdtpBitmap; ALeft, ATop: integer; Alpha: integer);
// Blend ASource to ADest, make sure that ADests' alpha channel remains valid
var
  SWidth, SHeight, DWidth, DHeight: integer;
  r, c, SPos, DRow, DCol, DPos: integer;
begin
  SWidth  := ASource.Width;
  SHeight := ASource.Height;
  DWidth  := ADest.Width;
  DHeight := ADest.Height;

  for r := 0 to SHeight - 1 do
  begin
    SPos := r * SWidth;
    DRow := r + ATop;
    if (DRow < 0) or (DRow >= DHeight) then
      continue;
    DRow := DRow * DWidth;

    for c := 0 to SWidth - 1 do
    begin
      DCol := c + ALeft;
      if (DCol >= 0) and (DCol < DWidth) then
      begin
        DPos := DRow + DCol;
        ADest.Bits[DPos] := Merge(ASource.Bits[SPos], ADest.Bits[DPos], Alpha);
      end;
      inc(SPos);
    end;

  end;
  EMMS;
end;

procedure DIBRotate90(Bitmap: TdtpBitmap);
// Rotate Bitmap over 90 deg ccw
var
  DIB: TdtpBitmap;
  r, c: integer;
begin
  DIB := TdtpBitmap.Create;
  try
    DIB.SetSize(Bitmap.Height, Bitmap.Width);
    for r := 0 to Bitmap.Height - 1 do
      for c := 0 to Bitmap.Width - 1 do
        DIB.Pixel[r, Bitmap.Width - 1 - c] := Bitmap.Pixel[c, r];
    Bitmap.Assign(DIB);
  finally
    DIB.Free;
  end;
end;

procedure DIBRotate180(Bitmap: TdtpBitmap);
// Rotate Bitmap over 270 deg ccw
begin
  // This is the same as a flip and a mirror
  DIBMirror(Bitmap);
  DIBFlip(Bitmap);
end;

procedure DIBRotate270(Bitmap: TdtpBitmap);
// Rotate Bitmap over 270 deg ccw
var
  DIB: TdtpBitmap;
  r, c: integer;
begin
  DIB := TdtpBitmap.Create;
  try
    DIB.SetSize(Bitmap.Height, Bitmap.Width);
    for r := 0 to Bitmap.Height - 1 do
      for c := 0 to Bitmap.Width - 1 do
        DIB.Pixel[Bitmap.Height - 1 - r, c] := Bitmap.Pixel[c, r];
    Bitmap.Assign(DIB);
  finally
    DIB.Free;
  end;
end;

procedure DIBMirror(Bitmap: TdtpBitmap);
// Mirror the bitmap horizontally
var
  ALine: integer;
  r, c, rc: integer;
  ACol: TdtpColor;
begin
  with Bitmap do
    for r := 0 to Height - 1 do
    begin
      ALine := r * Width;
      for c := 0 to (Width div 2) - 1 do
      begin
        rc := Width - 1 - c;
        ACol := Bits[ALine + c];
        Bits[ALine +  c] := Bits[ALine + rc];
        Bits[ALine + rc] := ACol;
      end;
    end;
end;

procedure DIBFlip(Bitmap: TdtpBitmap);
// Flip the bitmap (mirror vertically)
var
  TmpLine: pointer;
  r, lr, ur: integer;
begin
  GetMem(TmpLine, Bitmap.Width * 4);
  try
    with Bitmap do
      for r := 0 to (Height div 2) - 1 do
      begin
        lr := r * Width;
        ur := (Height - 1 - r) * Width;
        Move(Bits[lr], TmpLine^, Width * 4);
        Move(Bits[ur], Bits[lr], Width * 4);
        Move(TmpLine^, Bits[ur], Width * 4);
      end;
  finally
    FreeMem(TmpLine);
  end;
end;

procedure BlueChannelToAlphaAndColor(Dst, Src: TdtpBitmap; Color: TdtpColor; BkColor: TdtpColor = clWhite32);
// Convert blue channel to alpha channel (inverted), and then create an antialiased color where alpha > 0.
var
  i: integer;
  Alpha: byte;
  D, S: PdtpColor;
begin
  if not assigned(Src) or not assigned(Dst) then
    exit;
  Dst.SetSize(Src.Width, Src.Height);
  D := @Dst.Bits[0];
  S := @Src.Bits[0];
  for i := 0 to Src.Width * Src.Height - 1 do
  begin
    // Alpha channel
    Alpha := 255 - BlueComponent(S^);
    D^ := SetAlpha(dtpBlendRegEx(BkColor, Color, Alpha), Alpha);
    inc(S); inc(D);
  end;
  EMMS; // Switch off MMX mode
end;

procedure AlphaShr16Intensity(DIB: TdtpBitmap; Intensity: single);
// Shift Alpha channel to the right over 16 bits, and multiply it by an intensity
// value. This way a 16-bit Alpha value is used for subsequent integer precision
// Alpha-channel calculations. Intensity should be 1.0 by default.
var
  P, PEnd: PdtpColor;
begin
  if not assigned(DIB) then
    exit;
  P    := @DIB.Bits[0];
  PEnd := @DIB.Bits[DIB.Width * DIB.Height];
  while integer(P) < integer(PEnd) do
  begin
    P^ := round(P^ and $FF000000 shr 16 * Intensity);
    inc(P);
  end;
end;

procedure AlphaShl16Color(DIB: TdtpBitmap; AColor: TdtpColor);
// Shift Alpha to the left over 16 bits,
var
  P, PEnd: PdtpColor;
begin
  if not assigned(DIB) then
    exit;
  AColor := AColor AND $00FFFFFF;
  P    := @DIB.Bits[0];
  PEnd := @DIB.Bits[DIB.Width * DIB.Height];
  while integer(P) < integer(PEnd) do
  begin
    if (P^ and $FFFFFF00) > 0 then
      P^ := Min(P^, $FF00) shl 16 and $FF000000 or AColor;
    inc(P);
  end;
end;

procedure RecursiveFilterHor(Src, Dst: TdtpBitmap; Half, Length: integer);
// Do a recursive Rectangular Filter over a width of Length pixels, with the
// result value taken at Half. This filter assumes that the edge areas are empty
// so that all data can be processed in one long row.
var
  i: integer;
  P, Q, QEnd, R: PdtpColor;
  Total: integer;
  ASize: integer;
begin
  ASize := Src.Width * Src.Height;
  if ASize <> Dst.Width * Dst.Height then
    exit;
  if ASize < Length then
    exit;
  // Init of Total over Half pixels
  Total := 0;
  Q := @Src.Bits[0];
  for i := 0 to Half - 1 do
  begin
    inc(Total, Q^);
    inc(Q);
  end;
  // Start setting values
  R := @Dst.Bits[0];
  for i := Half to Length - 1 do
  begin
    inc(Total, Q^);
    R^ := Total div Length;
    inc(Q);
    inc(R);
  end;
  // Now run through all the bits
  P := @Src.Bits[0];
  QEnd := @Src.Bits[ASize];
  while integer(Q) < integer(QEnd) do
  begin
    inc(Total, integer(Q^) - integer(P^));
    R^ := Total div Length;
    inc(P);
    inc(Q);
    inc(R);
  end;
  // And do the last itty bitty
  while integer(R) < integer(@Dst.Bits[ASize]) do
  begin
    inc(Total, -integer(P^));
    R^ := Total div Length;
    inc(P);
    inc(R);
  end;
end;

procedure BlurRecursive(DIB: TdtpBitmap; Radius: single);
// This is a novice (not seen before) blurring algorithm that uses recursive
// filters to accomplish a closely matching gaussian blur.
// Copyright (c) by Nils Haeck
var
  i: integer;
  ATmp: TdtpBitmap;
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
  ATmp := TdtpBitmap.Create;
  try
    ATmp.SetSize(DIB.Width, DIB.Height);
    ATmp.Clear($00000000);
    // Repeat N times. After some internal debate and extensive testing, it
    // turns out that a value of N=2 is quite adequate. N=3 would also work
    // but since it is slower, it makes no sense. Going to higer values of N
    // will yield too much blur for small blur lengths. Theory states that
    // repeating this infinite times yields the gaussian.. (Rectangle ->
    // Triangle -> Hat-shape). Actually, N=2 means 4x horiz, 4x vertical
    for i := 1 to 2 do
    begin
      RecursiveFilterHor(DIB, ATmp, AHalf1, ALength);
      RecursiveFilterHor(ATmp, DIB, AHalf2, ALength);
    end;
    // Transpose the bits, so that the horizontal recursive filter works on
    // vertical columns
    TransposeBits(DIB, ATmp, DIB.Width, DIB.Height);
    for i := 1 to 2 do
    begin
      RecursiveFilterHor(ATmp, DIB, AHalf2, ALength);
      RecursiveFilterHor(DIB, ATmp, AHalf1, ALength);
    end;
    // Transpose back
    TransposeBits(ATmp, DIB, ATmp.Height, ATmp.Width);
    // Now we have the result back in DIB
  finally
    ATmp.Free;
  end;
end;

procedure Feather(DIB: TdtpBitmap; Radius: single);
var
  ATmp: TdtpBitmap;
  AHalf, ALength: integer;
begin
  // Determine recursive filter length
  ALength := round(Radius);
  if ALength < 2 then
    exit;
  if not odd(ALength) then
    inc(ALength);
  AHalf := ALength div 2;
  // Create intermediate bitmap to hold blur temp results
  ATmp := TdtpBitmap.Create;
  try
    ATmp.SetSize(DIB.Width, DIB.Height);
    ATmp.Clear($00000000);
    RecursiveFilterHor(DIB, ATmp, AHalf, ALength);
    // Transpose the bits, so that the horizontal recursive filter works on
    // vertical columns
    TransposeBits(ATmp, DIB, ATmp.Width, ATmp.Height);
    RecursiveFilterHor(DIB, ATmp, AHalf, ALength);
    // Transpose back
    TransposeBits(ATmp, DIB, ATmp.Height, ATmp.Width);
    // Now we have the result back in DIB
  finally
    ATmp.Free;
  end;
end;

procedure MergeLayers(Fg, Bg: TdtpBitmap; MasterAlpha: byte);
// Merge Fg and Bg together, result in Fg (preserves Alpha). MasterAlpha is the
// master alpha of Fg (defaults to $FF)
var
  ASize: integer;
  P, Q, PEnd: PdtpColor;
begin
  ASize := Fg.Width * Fg.Height;
  if ASize <> Bg.Width * Bg.Height then
    exit;
  P := @Fg.Bits[0];
  Q := @Bg.Bits[0];
  PEnd := @Fg.Bits[ASize];
  while integer(P) < integer(PEnd) do
  begin
    P^ := Merge(P^, Q^, MasterAlpha);
    inc(P);
    inc(Q);
  end;
end;

procedure Roll(DIB: TdtpBitmap; Dx, Dy: integer);
// Roll a TBitmap over Dx and Dy, looses bits that are slid out. New bits are filled
// with zeroes.
var
  AGap, ASize, ALength: integer;
begin
  AGap := Dx + Dy * DIB.Width;
  ASize:= DIB.Width * DIB.Height;
  ALength := (ASize - abs(AGap)) shl 2;
  if (AGap = 0) or (ALength < 0) then
    exit;
  if AGap > 0 then
  begin
    Move(DIB.Bits[0], DIB.Bits[AGap], ALength);
    FillChar(DIB.Bits[0], AGap shl 2, 0);
  end else
  begin
    AGap := abs(AGap);
    Move(DIB.Bits[AGap], DIB.Bits[0], ALength);
    FillChar(DIB.Bits[ASize - AGap], AGap shl 2, 0);
  end;
end;

procedure TransposeBits(Src, Dst: TdtpBitmap; Width, Height: integer);
// Do nothing else than put the transposed bits from Src into Dst. So we do NOT
// set the bitmap sizes, nor is any error checking done.
var
  r, c: integer;
  P, Q: PdtpColor;
begin
  P := @Src.Bits[0];
  for r := 0 to Height - 1 do
  begin
    Q := @Dst.Bits[r];
    for c := 0 to Width - 1 do
    begin
      Q^ := P^;
      inc(Q, Height);
      inc(P);
    end;
  end;
end;

procedure InvertAlpha(ADib: TdtpBitmap);
// Invert the data in the Alpha channel
var
  i: integer;
  P: PdtpColor;
begin
  if not assigned(ADib) then
    exit;
  P := @ADib.Bits[0];
  for i := 0 to ADib.Width * ADib.Height - 1 do
  begin
    P^ := P^ XOR $FF000000;
    inc(P);
  end;

end;

function Merge(F, B, FM: TdtpColor): TdtpColor;
// Merge two layers' pixels according to this formula for layer merging:
// Ra := Fa + Ba - Fa * Ba;
// Rrgb := (Fa (Frgb - Brgb * Ba) + Brgb * Ba) / Ra;
var
  A: Byte;
  Fa, Fr, Fg, Fb: Byte;
  Ba, Br, Bg, Bb: Byte;
  Ra, Rr, Rg, Rb: Byte;
  InvRa: Integer;
begin

  // Extreme cases (most often)
  A := F shr 24;
  if A = 255 then
  begin
    if FM = 255 then
    begin
      Result := F;
      exit;
    end;
    if FM = 0 then
    begin
      Result := B;
      exit;
    end;
  end;
  if A = 0 then
  begin
    Result := B;
    exit;
  end;

  Fa := (A * FM) div 255;
  // Create F, but now with correct Alpha
  F := F and $00FFFFFF or Fa shl 24;
  if Fa = $FF then
  begin
    Result := F;
    exit;
  end;
  Ba := B shr 24;
  if Ba = 0 then
  begin
    Result := F;
    exit;
  end;

  // Blended pixels
  Fr := F shr 16;
  Fg := F shr 8;
  Fb := F;
  Br := B shr 16;
  Bg := B shr 8;
  Bb := B;
  Ra := Fa + Ba - (Fa * Ba) div 255;
  InvRa := (256 * 256) div Ra;
  Br := Br * Ba shr 8;
  Rr := (Fa * (Fr - Br) shr 8 + Br) * InvRa shr 8;
  Bg := Bg * Ba shr 8;
  Rg := (Fa * (Fg - Bg) shr 8 + Bg) * InvRa shr 8;
  Bb := Bb * Ba shr 8;
  Rb := (Fa * (Fb - Bb) shr 8 + Bb) * InvRa shr 8;
  Result := Ra shl 24 + Rr shl 16 + Rg shl 8 + Rb;
end;

// Blend colors, keep intact the target Alpha, for whole scanline
procedure MergeLine(Src, Dst: PdtpColor; Count: Integer; Alpha: TdtpColor);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    Dst^ := Merge(Src^, Dst^, Alpha);
    inc(Dst);
    inc(Src);
  end;
end;

procedure FillTransparentParts(ADib: TdtpBitmap; BkColor: TdtpColor);
// Blend the (semi)transparent parts of ADib with BkColor, thus creating a TBitmap32
// with an alpha channel that is $FF everywhere
var
  i: integer;
begin
  with ADib do
    for i := 0 to Width * Height - 1 do
      if Bits[i] and $FF000000 < $FF000000 then
        dtpBlendReg(Bits[i], BkColor);
  EMMS;
end;

procedure FilterColorChannel(ADib: TdtpBitmap; AConversion: TdtpConversionType);
// Create colormap with type AConversion, then assign it back to ADib
var
  AMap: TdtpBytemap;
begin
  AMap := TdtpBytemap.Create;
  try
    dtpReadFromMap(AMap, ADib, AConversion);
    ADib.Assign(AMap);
  finally
    AMap.Free;
  end;
end;

function IsBitmapSingleColor(ADib: TdtpBitmap; const AColor: TdtpColor): boolean;
var
  i, YPos, YInc, Width: integer;
  Sign: boolean;
  P: PdtpColor;
begin
  Result := True;
  if not assigned(ADib) then
    exit;
  Width := ADib.Width;
  if Width = 0 then
    exit;
  // We use an alternating scheme where we check Y=0, then Y=Height - 1, then
  // Y=1 etc. This helps, because often info is either at the top or at the
  // bottom, so we can quickly exit in that case.
  YPos := 0;
  YInc := ADib.Height - 1;
  Sign := True;
  while YInc >= 0 do
  begin
    // Check line at YPos
    P := PdtpColor(ADib.ScanLine[YPos]);
    for i := 0 to Width - 1 do
    begin
      if P^ <> AColor then
      begin
        Result := False;
        exit;
      end;
      inc(P);
    end;
    // Next line
    if Sign then
      inc(YPos, YInc)
    else
      dec(YPos, YInc);
    Sign := not Sign;
    Dec(YInc);
  end;
end;

function EnumFontFamProc(lpelf: PENUMLOGFONT; lpntm: PNEWTEXTMETRIC;
  FontType: integer; lParam: lParam): integer; stdcall;
begin
  Result := -1; // Must be non-zero
  if TObject(lParam) is TStrings then
    TStringList(lParam).Add(lpelf^.elfFullName);
end;

procedure FontnamesList(const AList: TStrings);
// Create a list of available fonts on the system and put them in stringlist AList.
// AList must be initialized and will be cleared before strings are added
var
  DC: HDC;
begin
  if not assigned(AList) then
    exit;
  AList.Clear;
  if (AList is TStringList) then
    TStringList(AList).Sorted := True;
  DC := CreateCompatibleDC(0);
  try
    EnumFontFamilies(DC, nil, @EnumFontFamProc,	integer(AList));
  finally
    DeleteDC(DC);
  end;
end;

end.

{ Project: Pyro
  Module: Pyro Core

  Description:
  Color types within the Pyrographics library.

  Some notes on color management:

  The Pyrographics library can internally work with 3 different color spaces
  and 2 different bits-per-channel:
  Color spaces supported
  - StandardGray
  - StandardRGB
  - StandardRGBA

  Bits-per-channel supported:
  - 8 bits/channel
  - 16 bits/channel (not implemented yet)

  Whenever other color spaces are encountered, they will be converted asap
  to any of the internal color spaces.

  When another color space is required for output, the final resulting
  bitmap format can be converted to that color space using external functions.

  Creation Date:
  13Sep2005

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2005 - 2011 SimDesign BV
}
unit pgColor;

{$i simdesign.inc}

interface

uses
  SysUtils, Pyro;

// Convert R, G, B, A 8bpc to TpgColorARGB
function pgColorARGB(R, G, B: byte; A: byte = $FF): TpgColorARGB;

// Generic conversion of colorspaces for Count colors
procedure pgConvertColorArray(const SrcInfo, DstInfo: TpgColorInfo; SrcColor, DstColor: pointer; Count: integer);

// Convert a source TpgColor to another TpgColor. The colorspace for source is
// SrcInfo and destination is DstInfo.
function pgConvertColor(const SrcInfo, DstInfo: TpgColorInfo; SrcColor: pointer): TpgColor;

// Convert a source TpgColor to a destination TpgColor32. The colorspace for
// source is SrcInfo and destination is DstInfo.
function pgColorTo4Ch8b(const SrcInfo, DstInfo: TpgColorInfo; SrcColor: pointer): TpgColor32;

// Convert an array of colours from SrcInfo space to DstInfo space, getting values from SrcColor and
// putting them in DstColor. Dst colorspace must be 4ch 8bpc
procedure pgColorArrayTo4Ch8b(const SrcInfo, DstInfo: TpgColorInfo; SrcColors: pointer; DstColors: PpgColor32; Count: integer);

// Convert an array of colours from SrcInfo space to DstInfo space, getting values from SrcColor and
// putting them in DstColor. Dst colorspace must be 3ch 8bpc
procedure pgColorArrayTo3Ch8b(const SrcInfo, DstInfo: TpgColorInfo; SrcColors, DstColors: pointer; Count: integer);

procedure pgConvertCMYKtoRGB8bit(Source, Dest: pointer; Count: integer);

// Compare color info A and B, return True if equal
function pgCompareColorInfo(const InfoA, InfoB: TpgColorInfo): boolean;

// Interpolate between Col1 and Col2, using Frac. Frac should be in interval [0..1]
// for interpolation, but may also be outside to extrapolate
function InterpolateColor(const Col1, Col2: TpgColor32; const Frac: double): TpgColor32;

implementation

function pgColorARGB(R, G, B: byte; A: byte = $FF): TpgColorARGB;
begin
  Result.A := A;
  Result.R := R;
  Result.G := G;
  Result.B := B;
end;

function pgColorTo4Ch8b(const SrcInfo, DstInfo: TpgColorInfo; SrcColor: pointer): TpgColor32;
begin
  pgColorArrayTo4Ch8b(SrcInfo, DstInfo, SrcColor, @Result, 1);
end;

procedure pgConvertColorArray(const SrcInfo, DstInfo: TpgColorInfo; SrcColor, DstColor: pointer; Count: integer);
begin
  // This is rather weak, so "todo"! Must add a true conversion here
  case  DstInfo.BitsPerChannel of
  bpc8bits:
    case DstInfo.Channels of
    3: pgColorArrayTo3Ch8b(SrcInfo, DstInfo, SrcColor, DstColor, Count);
    4: pgColorArrayTo4Ch8b(SrcInfo, DstInfo, SrcColor, DstColor, Count);
    else
      raise Exception.Create(sUnsupportedColorConversion);
    end;
  else
    raise Exception.Create(sUnsupportedColorConversion);
  end;
end;

function pgConvertColor(const SrcInfo, DstInfo: TpgColorInfo; SrcColor: pointer): TpgColor;
begin
  pgConvertColorArray(SrcInfo, DstInfo, SrcColor, @Result, 1);
end;

procedure pgColorArrayTo4Ch8b(const SrcInfo, DstInfo: TpgColorInfo; SrcColors: pointer; DstColors: PpgColor32; Count: integer);
var
  i: integer;
  S, D: pbyte;
  Dc: Pcardinal;
  Y, A: byte;
  InvA: integer;
begin
  // make Src into 4Ch first
  S := SrcColors;
  D := pbyte(DstColors);
  case SrcInfo.BitsPerChannel of
  bpc8bits:
    case SrcInfo.Channels of
    1: // Y
      for i := 0 to Count - 1 do
      begin
        Y := S^; inc(S);
        D^ := Y; inc(D);
        D^ := Y; inc(D);
        D^ := Y; inc(D);
        D^ := $FF; inc(D);
      end;
    2: // AY
      for i := 0 to Count - 1 do
      begin
        A := S^; inc(S);
        Y := S^; inc(S);
        D^ := Y; inc(D);
        D^ := Y; inc(D);
        D^ := Y; inc(D);
        D^ := A; inc(D);
      end;
    3: // XYZ
      for i := 0 to Count - 1 do
      begin
        D^ := S^; inc(D); inc(S);
        D^ := S^; inc(D); inc(S);
        D^ := S^; inc(D); inc(S);
        D^ := $FF; inc(D);
      end;
    4: // AXYZ - to do: special case of CMYK
      begin
        // Just a copy
        Move(SrcColors^, DstColors^, Count * SizeOf(TpgColor32));
      end;
    end;
  bpc16bits:
    // to do
    raise Exception.Create(sUnsupportedBitsPerChannel);
  end;

  // Check color model (additive/substractive)
  if SrcInfo.ColorModel <> DstInfo.ColorModel then
  begin
    // Flip channels (CMY <> RGB)
    Dc := Pcardinal(DstColors);
    for i := 0 to Count - 1 do
    begin
      Dc^ := Dc^ xor $00FFFFFF;
      inc(Dc);
    end;
  end;

  // Check premultiplication
  if (SrcInfo.Channels in [2, 4]) and (SrcInfo.AlphaMode <> DstInfo.AlphaMode) then
  begin
    case SrcInfo.AlphaMode of
    amOriginal:
      begin
        // Src is Original so we must premultiply
        D := Pbyte(DstColors);
        for i := 0 to Count - 1 do
        begin
          inc(D, 3);
          A := D^;
          if A = $FF then
          begin
            inc(D);
            continue;
          end;
          dec(D, 3);
          // premultiply dest colors
          D^ := pgIntMul(D^, A); inc(D);
          D^ := pgIntMul(D^, A); inc(D);
          D^ := pgIntMul(D^, A); inc(D);
          inc(D); // skip dest alpha
        end;
      end;
    amPremultiplied:
      begin
        // Src is premultiplied so we must divide back
        D := Pbyte(DstColors);
        for i := 0 to Count - 1 do
        begin
          inc(D, 3);
          A := D^;
          if (A = $FF) or (A = $00) then
          begin
            inc(D);
            continue;
          end;
          dec(D, 3);
          InvA := (255 * 256) div A;
          D^ := D^ * InvA shr 8; inc(D);
          D^ := D^ * InvA shr 8; inc(D);
          D^ := D^ * InvA shr 8; inc(D);
          inc(D); // skip dest alpha
        end;
      end;
    else
      raise Exception.Create(sUnsupportedAlphaMode);
    end;
  end;
end;

procedure pgColorArrayTo3Ch8b(const SrcInfo, DstInfo: TpgColorInfo; SrcColors, DstColors: pointer; Count: integer);
var
  i: integer;
  S, D: pbyte;
  Y: byte;
begin
  // make Src into 3Ch first
  S := SrcColors;
  D := DstColors;
{  // Do we have to unmultiply (not handled yet)
  Unmultiply := (SrcInfo.Channels in [cs2Ch, cs4ch]) and
    (SrcInfo.AlphaMode = amPremultiplied);}
  case SrcInfo.BitsPerChannel of
  bpc8bits:
    case SrcInfo.Channels of
    1: // Y
      for i := 0 to Count - 1 do
      begin
        Y := S^; inc(S);
        D^ := Y; inc(D);
        D^ := Y; inc(D);
        D^ := Y; inc(D);
      end;
    2: // AY
      for i := 0 to Count - 1 do
      begin
        inc(S);
        Y := S^; inc(S);
        D^ := Y; inc(D);
        D^ := Y; inc(D);
        D^ := Y; inc(D);
        // loose alpha
      end;
    3: // XYZ
      // Just a copy
      Move(SrcColors^, DstColors^, Count * 3);
    4: // AXYZ - to do: special case of CMYK
      for i := 0 to Count - 1 do
      begin
        D^ := S^; inc(D); inc(S);
        D^ := S^; inc(D); inc(S);
        D^ := S^; inc(D); inc(S);
        inc(S); //loose alpha
      end;
    end;
  bpc16bits:
    // to do
    raise Exception.Create(sUnsupportedBitsPerChannel);
  end;

  // Check color model (additive/substractive)
  if SrcInfo.ColorModel <> DstInfo.ColorModel then
  begin
    // Flip channels (CMY <> RGB)
    D := DstColors;
    for i := 0 to Count - 1 do
    begin
      D^ := D^ xor $FF; inc(D);
      D^ := D^ xor $FF; inc(D);
      D^ := D^ xor $FF; inc(D);
    end;
  end;
end;

procedure pgConvertCMYKtoRGB8bit(Source, Dest: pointer; Count: integer);
var
  i, AK: integer;
  C, M, Y, K: PByte;
  R, G, B: PByte;
begin
  R := Dest;
  G := R; inc(G);
  B := G; inc(B);
  C := Source;
  M := C; inc(M);
  Y := M; inc(Y);
  K := Y; inc(K);
  for i := 0 to Count - 1 do
  begin
    // Conversion formula for 8bit
    AK :=  C^ + K^;
    if AK > $FF then AK := $FF;
    R^ := $FF - AK;
    AK :=  M^ + K^;
    if AK > $FF then AK := $FF;
    G^ := $FF - AK;
    AK :=  Y^ + K^;
    if AK > $FF then AK := $FF;
    B^ := $FF - AK;

    inc(R, 3); inc(G, 3); inc(B, 3);
    inc(C, 4); inc(M, 4); inc(Y, 4); inc(K, 4);
  end;

end;

function pgCompareColorInfo(const InfoA, InfoB: TpgColorInfo): boolean;
begin
  Result :=
    (InfoA.Channels = InfoB.Channels) and
    (InfoA.BitsPerChannel = InfoB.BitsPerChannel) and
    (InfoA.AlphaMode = InfoB.AlphaMode) and
    (InfoA.ColorModel = InfoB.ColorModel) and
    (InfoA.ColorSpaceInfo = InfoB.ColorSpaceInfo); 
end;

function InterpolateColor(const Col1, Col2: TpgColor32; const Frac: double): TpgColor32;
var
  IFrac, IInv: integer;
begin
  IFrac := round(Frac * $1000);
  IInv := $1000 - IFrac;
  TpgColorARGB(Result).B := pgLimit(TpgColorARGB(Col1).B * IInv + TpgColorARGB(Col2).B * IFrac, 0, $FF000) shr 12;
  TpgColorARGB(Result).G := pgLimit(TpgColorARGB(Col1).G * IInv + TpgColorARGB(Col2).G * IFrac, 0, $FF000) shr 12;
  TpgColorARGB(Result).R := pgLimit(TpgColorARGB(Col1).R * IInv + TpgColorARGB(Col2).R * IFrac, 0, $FF000) shr 12;
  TpgColorARGB(Result).A := pgLimit(TpgColorARGB(Col1).A * IInv + TpgColorARGB(Col2).A * IFrac, 0, $FF000) shr 12;
end;

end.

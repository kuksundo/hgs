{ Project: Pyro
  Module: Pyro Render

  Description:
  Low-level blending functions

  Creation Date:
  25Sep2005

  pgBlend is called from pgCanvas and pgCanvasUsingPyro

  Function prefixes:

  for a name like 1_2_3_4_5_6_function

  1 = Pas: Pascal native implementation
      Asm: Assembler
      Mmx: MMX/SSE optimized

  2 = Org: Original color values
      Pre: Premultiplied color values: the colors are already premultiplied with alpha

  3 = 1Ch = 1-channel (Y, where Y could be e.g. gray)
      2Ch = 2-channel (AY where A means alpha, Y could be e.g. gray)
      3Ch = 3-channel (XYZ, where XYZ can be e.g. RGB or any other model)
      4Ch = 4-channel (AXYZ where A means alpha, XYZ can be e.g. RGB or any other model)

  4 = Add: additive color model (like RGB)
      Sub: substractive color model (like CMY)

  5 = Std: standard edge model
      Tch: touching edge model (uses dest cover)

  6 = 8b:  8 bits per channel
      16b: 16 bits per channel.

  function templates

  TpgBlendInfo = record
    PColSrc: pointer;    // pointer to source color
    PColDst: pointer;    // pointer to destination color
    ColCount: integer;   // number of colors to process in a row
    IncSrc: integer;     // increment of source pointer (so if IncSrc = 0 then same source)
    PCvrSrc: pbyte;      // pointer to source cover array, or nil if no cover
    PCvrDst: pbyte;      // pointer to destination cover array, or nil if not used
    IncCvr: integer;     // if 0, same cover used
    ColorOp: TpgColorOp; // additional color operation.. or nil if "over"
    Buffer: pointer;     // in case the algo needs a blending buffer this should point to it
  end;

  TpgBlend = procedure (var Info: TpgBlendInfo);
    Blends Src to Dest color

  TpgAdjustAlpha = procedure (PColSrc, PColDest: pointer; Mul: integer);
    Adjusts alphas in Src with factor Mul and puts result in Dst

  TpgColorOp = procedure (PColA, PColB, PColDst: pointer);
    Performs some color operation on A and B, puts result in Dst

  In all cases, Dest and Src must already contain valid colors, alphas and covers

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2005 - 2011 SimDesign BV
}
unit pgBlend;

{$i simdesign.inc}

interface

uses
  SysUtils, Pyro;

type

  TpgColorOp = (
    coOver,          // Default over: A
    coAdd,           // A + B
    coSub,           // A - B
    coDiv,           // A / B
    coModulate,      // A * B
    coMax,           // max(A, B)
    coMin,           // min(A, B)
    coDifference,    // abs(A - B)
    coExclusion,     // A + (1 - A) * B
    coAverage        // (A + B) / 2
  );

  // Performs some color operation on A and B, puts result in Dst
  TpgColorOpFunc = procedure (PColA, PColB, PColDst: pointer);

  // A record to be passed to the blending function with information
  TpgBlendInfo = record
    PColSrc: pointer;    // pointer to source color or color array
    PColDst: pointer;    // pointer to destination color or color array
    Count: integer;      // number of colors to process in a row
    IncSrc: integer;     // increment of source pointer (so if IncSrc = 0 then same source)
    PCvrSrc: pbyte;      // pointer to source cover array, or nil if no cover
    PCvrDst: pbyte;      // pointer to destination cover array, or nil if not used
    IncCvr: integer;     // if 0, same cover used, otherwise 1
    Buffer: pointer;     // in case the algo needs a blending buffer this should point to it
    ColorOp: TpgColorOpFunc; // additional color operation.. or nil if "over"
    BlendFunc: pointer;  // Pointer to a selected blending function (TpgBlendFunc)
  end;

  // Blends Src to Dest color, or color operation
  TpgBlendFunc = procedure (var Info: TpgBlendInfo);

  // Adjusts alphas in Src with factor Mul and puts result in Dst
  TpgAdjustAlphaFunc = procedure (PColSrc, PColDst: pointer; Mul: integer);

  TpgFillLongwordFunc = procedure(var X; Count: Integer; Value: Longword);

// Select blend
function SelectBlendFunc(const AInfo: TpgColorInfo; AEdgeMode: TpgEdgeMode;
  var BlendInfo: TpgBlendInfo; AColorOp: TpgColorOp = coOver): TpgBlendFunc;

// adjust alpha

procedure Pas_Org_4Ch_x_x_8b_AdjustAlpha(PColSrc, PColDst: pointer; Mul: integer);
procedure Pas_Pre_4Ch_x_x_8b_AdjustAlpha(PColSrc, PColDst: pointer; Mul: integer);

// blending

// These should have a buffer of length Count (x32bits) in case a cover array is defined

procedure Pas_Org_4Ch_Add_Std_8b_Blend(var Info: TpgBlendInfo);
procedure Pas_Pre_4Ch_Add_Std_8b_Blend(var Info: TpgBlendInfo);

// blend with color operation

// These should have a buffer of length Count (x32bits) without cover, and 2 * Count
// with cover.

procedure Pas_x_4Ch_Add_x_8b_ColorOp(var Info: TpgBlendInfo);

// Color operations

procedure Pas_x_4Ch_Add_x_8b_ColorOpOver(PColA, PColB, PColDst: pointer);
procedure Pas_x_4Ch_Add_x_8b_ColorOpAdd(PColA, PColB, PColDst: pointer);
procedure Pas_x_4Ch_Add_x_8b_ColorOpSub(PColA, PColB, PColDst: pointer);
procedure Pas_x_4Ch_Add_x_8b_ColorOpDiv(PColA, PColB, PColDst: pointer);
procedure Pas_x_4Ch_Add_x_8b_ColorOpModulate(PColA, PColB, PColDst: pointer);
procedure Pas_x_4Ch_Add_x_8b_ColorOpMax(PColA, PColB, PColDst: pointer);
procedure Pas_x_4Ch_Add_x_8b_ColorOpMin(PColA, PColB, PColDst: pointer);
procedure Pas_x_4Ch_Add_x_8b_ColorOpDifference(PColA, PColB, PColDst: pointer);
procedure Pas_x_4Ch_Add_x_8b_ColorOpExclusion(PColA, PColB, PColDst: pointer);
procedure Pas_x_4Ch_Add_x_8b_ColorOpAverage(PColA, PColB, PColDst: pointer);

// MMX blending

procedure Mmx_Org_4Ch_Add_Std_8b_Blend(var Info: TpgBlendInfo);
procedure Mmx_Pre_4Ch_Add_Std_8b_Blend(var Info: TpgBlendInfo);

procedure AlphaBlendBlock(
  Dst: pointer;
  DstScanStride: integer;
  DstX, DstY, DstWidth, DstHeight: integer;
  Src: pointer;
  SrcScanStride: integer;
  SrcX, SrcY: integer;
  SrcAlpha: byte;
  const ColorInfo: TpgColorInfo;
  ColorOp: TpgColorOp);

implementation

function SelectBlendFunc(const AInfo: TpgColorInfo; AEdgeMode: TpgEdgeMode;
  var BlendInfo: TpgBlendInfo; AColorOp: TpgColorOp): TpgBlendFunc;
begin
  // Try to select the best matching blender, raise an exception if a blender doesn't exist
  // and no "suitable" substitute can be found
  Result := nil;
  FillChar(BlendInfo, SizeOf(BlendInfo), 0);

  // Checks
  // right now skip edgemode info

  // Color model
  case AInfo.ColorModel of
  cmAdditive:
    // Bits per channel
    case AInfo.BitsPerChannel of
    bpc8bits:
      case AInfo.Channels of
      1: raise Exception.Create(sChannelsOpNotImplemented);
      2: raise Exception.Create(sChannelsOpNotImplemented);
      3: raise Exception.Create(sChannelsOpNotImplemented);
      4:
        begin
          case AInfo.AlphaMode of
          amOriginal:
            if glMmxActive then
              Result := Mmx_Org_4Ch_Add_Std_8b_Blend
            else
              Result := Pas_Org_4Ch_Add_Std_8b_Blend;
          amPremultiplied:
            if glMmxActive then
              Result := Mmx_Pre_4Ch_Add_Std_8b_Blend
            else
              Result := Pas_Pre_4Ch_Add_Std_8b_Blend;
          amDropAlpha:
            raise Exception.Create(sAlphaModeOpNotImplemented);
          else
            raise Exception.Create(sAlphaModeOpNotImplemented);
          end;

          // Color operation
          if AColorOp <> coOver then
          begin
            // The colorop routine will have a reference to the original blend function
            BlendInfo.BlendFunc := pointer(Result);
            Result := Pas_x_4Ch_Add_x_8b_ColorOp;
            case AColorOp of
            coAdd       : BlendInfo.ColorOp := Pas_x_4Ch_Add_x_8b_ColorOpAdd;
            coSub       : BlendInfo.ColorOp := Pas_x_4Ch_Add_x_8b_ColorOpSub;
            coDiv       : BlendInfo.ColorOp := Pas_x_4Ch_Add_x_8b_ColorOpDiv;
            coModulate  : BlendInfo.ColorOp := Pas_x_4Ch_Add_x_8b_ColorOpModulate;
            coMax       : BlendInfo.ColorOp := Pas_x_4Ch_Add_x_8b_ColorOpMax;
            coMin       : BlendInfo.ColorOp := Pas_x_4Ch_Add_x_8b_ColorOpMin;
            coDifference: BlendInfo.ColorOp := Pas_x_4Ch_Add_x_8b_ColorOpDifference;
            coExclusion : BlendInfo.ColorOp := Pas_x_4Ch_Add_x_8b_ColorOpExclusion;
            coAverage   : BlendInfo.ColorOp := Pas_x_4Ch_Add_x_8b_ColorOpAverage;
            else
              // Unknown mode as of yet
              raise Exception.Create(sColorOpNotImplemented);
            end;
          end;
        end;
      else
        raise Exception.Create(sChannelsOpNotImplemented);
      end;
    bpc16bits:
      raise Exception.Create(sBitsPerChannelOpNotImplemented);
    else
      raise Exception.Create(sBitsPerChannelOpNotImplemented);
    end;
  cmSubstractive:
    raise Exception.Create(sSubstractiveOpNotImplemented);
  end;
  if not assigned(Result) then
    raise Exception.Create(sUnknownRenderMode);
end;

procedure AlphaBlendBlock(
  Dst: pointer;
  DstScanStride: integer;
  DstX, DstY, DstWidth, DstHeight: integer;
  Src: pointer;
  SrcScanStride: integer;
  SrcX, SrcY: integer;
  SrcAlpha: byte;
  const ColorInfo: TpgColorInfo;
  ColorOp: TpgColorOp);
var
  y: integer;
  BlendFunc: TpgBlendFunc;
  BlendInfo: TpgBlendInfo;
  S, D: Pbyte;
  CellStride: integer;
  Buffer: array of byte;
begin
  // Checks
  if (SrcAlpha = 0) or (DstWidth <= 0) or (DstHeight <= 0) then
    exit;

  // Setup blend function
  BlendFunc := SelectBlendFunc(ColorInfo, emStandard, BlendInfo, ColorOp);

  // Setup blend info
  BlendInfo.IncCvr := 0;
  BlendInfo.IncSrc := 1;
  BlendInfo.Count := DstWidth;
  if SrcAlpha < $FF then
    BlendInfo.PCvrSrc := @SrcAlpha
  else
    BlendInfo.PCvrSrc := nil;
  CellStride := pgColorElementSize(ColorInfo);
  SetLength(Buffer, CellStride * 2 * DstWidth);
  BlendInfo.Buffer := @Buffer[0];

  // Move to start of source
  S := Src;
  inc(S, SrcY * SrcScanStride + SrcX * CellStride);
  // Move to start of dest
  D := Dst;
  Inc(D, DstY * DstScanStride + DstX * CellStride);

  for y := 0 to DstHeight - 1 do
  begin
    BlendInfo.PColSrc := S;
    BlendInfo.PColDst := D;
    BlendFunc(BlendInfo);
    inc(S, SrcScanStride);
    inc(D, DstScanStride);
  end;
end;

{ non-MMX functions }

// Adjust alpha

procedure Pas_Org_4Ch_x_x_8b_AdjustAlpha(PColSrc, PColDst: pointer; Mul: integer);
var
  A: byte;
begin
  PpgColorARGB(PColDst)^ := PpgColorARGB(PColSrc)^;
  A := PpgColorARGB(PColSrc).A;
  if A = $FF then
    PpgColorARGB(PColDst).A := Mul
  else
    PpgColorARGB(PColDst).A := pgIntMul(Mul, A);
end;

procedure Pas_Pre_4Ch_x_x_8b_AdjustAlpha(PColSrc, PColDst: pointer; Mul: integer);
var
  i: integer;
  Ps, Pd: pbyte;
begin
  if (Mul = $FF) then
  begin
    PpgColorARGB(PColDst)^ := PpgColorARGB(PColSrc)^;
    exit;
  end;
  Ps := pbyte(PColSrc);
  Pd := pbyte(PColDst);
  for i := 0 to 3 do
  begin
    Pd^ := pgIntMul(Mul, Ps^);
    inc(Pd); inc(Ps);
  end;
end;

// Blending

procedure Pas_Org_4Ch_Add_Std_8b_Blend(var Info: TpgBlendInfo);
var
  i, Count: integer;
  PSrc, PDst, PBuf: PpgColorARGB;
  PCvr: PByte;
  Sa, Da, Ra, InvRa, RaD, IncSrc: integer;
  Dc, Sc: Pbyte;
  t1, t2: integer;
begin
  Count := Info.Count;
  PSrc := Info.PColSrc;
  PDst := Info.PColDst;

  // Adjust for cover
  IncSrc := Info.IncSrc;
  if Info.PCvrSrc <> nil then
  begin
    // Put src into buf
    PBuf := Info.Buffer;
    PCvr := Info.PCvrSrc;
    if (Info.IncSrc = 0) and (Info.IncCvr = 0) then
      Count := 1
    else
      IncSrc := 1;
    while Count > 0 do
    begin
      Pas_Org_4Ch_x_x_8b_AdjustAlpha(PSrc, PBuf, PCvr^);
      inc(PSrc, Info.IncSrc);
      inc(PBuf);
      inc(PCvr, Info.IncCvr);
      dec(Count);
    end;
    // Readjust some values
    PSrc := Info.Buffer;
    Count := Info.Count;
  end;

  while Count > 0 do
  begin
    // source alpha
    Sa := PSrc.A;
    if Sa = $FF then
    begin
      // Full cover: dest = source
      PDst^ := PSrc^;
    end else
    begin
      // If Sa = $00 we just keep dest
      if Sa > $00 then
      begin
        // Dest alpha
        Da := PDst.A;
        if Da = $00 then
        begin
          // nothing to cover: dest = source
          PDst^ := PSrc^;
        end else
        begin
          if Da = $FF then
          begin
            // We can shortcut for Da = $FF because resulting alpha is always $FF

            // Pointers to source and dest color, set dest colors
            Sc := pbyte(PSrc); Dc := pbyte(PDst);
            for i := 0 to 2 do
            begin

              t1 := Sa * Sc^ + $80;
              t2 := ($FF - Sa) * Dc^ + $80;
              Dc^ := (t1 shr 8 + t1) shr 8 + (t2 shr 8 + t2) shr 8;

              inc(Sc); inc(Dc);
            end;
            // Set dest alpha
            Dc^ := $FF;

          end else
          begin
            // Resulting alpha Ra = Sa + Da - Sa * Da
            Ra := Sa + Da - pgIntMul(Sa, Da);
            InvRa := (255 * 256) div Ra; // shl 8

            // Pointers to source and dest color, set dest colors
            Sc := pbyte(PSrc); Dc := pbyte(PDst);
            for i := 0 to 2 do
            begin

              // blending formula for original, non-premultiplied colors:
              // R' = Sa * (S - (Ra * D)) + (Ra * D)
              // R = R' / Ra
              RaD := pgIntMul(Da, Dc^);
              Dc^ := (Sa * (Sc^ - RaD) div 255 + RaD) * InvRa shr 8;

              inc(Sc); inc(Dc);
            end;
            // Set dest alpha
            Dc^ := Ra;
          end;
        end;
      end;
    end;
    inc(PDst);
    inc(PSrc, IncSrc);
    dec(Count);
  end;
end;

procedure Pas_Pre_4Ch_Add_Std_8b_Blend(var Info: TpgBlendInfo);
var
  t, Count: integer;
  PSrc, PDst, PBuf: PpgColorARGB;
  PCvr: PByte;
  Sa, Da, IncSrc: integer;
  Dc, Sc: Pbyte;
begin
  Count := Info.Count;
  PSrc := Info.PColSrc;
  PDst := Info.PColDst;

  // Adjust for cover
  IncSrc := Info.IncSrc;
  if Info.PCvrSrc <> nil then
  begin
    // Put src into buf
    PBuf := Info.Buffer;
    PCvr := Info.PCvrSrc;
    if (Info.IncSrc = 0) and (Info.IncCvr = 0) then
      Count := 1
    else
      IncSrc := 1;
    while Count > 0 do
    begin
      Pas_Pre_4Ch_x_x_8b_AdjustAlpha(PSrc, PBuf, PCvr^);
      inc(PSrc, Info.IncSrc);
      inc(PBuf);
      inc(PCvr, Info.IncCvr);
      dec(Count);
    end;
    // Re-adjust some values
    PSrc := Info.Buffer;
    Count := Info.Count;
  end;

  while Count > 0 do
  begin
    // source alpha
    Sa := PSrc.A;
    if Sa = $FF then
    begin
      // Full cover: dest = source
      PDst^ := PSrc^;
    end else
    begin
      // If Sa = $00 we just keep dest
      if Sa > $00 then
      begin
        // Dest alpha
        Da := PDst.A;
        if Da = $00 then
        begin
          // nothing to cover: dest = source
          PDst^ := PSrc^;
        end else begin
          // Resulting color: R = S + D - Sa * D
          Sc := pbyte(PSrc); Dc := pbyte(PDst);
{         for i := 0 to 3 do begin
            Dc^ := Sc^ + Dc^ - IntMul(Sa, Dc^);
            inc(Sc); inc(Dc);
          end;}
          // optimized (unrolled) version:
          t := Sa * Dc^ + $80;
          Dc^ := Sc^ + Dc^ - (t shr 8 + t) shr 8;
          inc(Sc); inc(Dc);
          t := Sa * Dc^ + $80;
          Dc^ := Sc^ + Dc^ - (t shr 8 + t) shr 8;
          inc(Sc); inc(Dc);
          t := Sa * Dc^ + $80;
          Dc^ := Sc^ + Dc^ - (t shr 8 + t) shr 8;
          inc(Sc); inc(Dc);
          t := Sa * Dc^ + $80;
          Dc^ := Sc^ + Dc^ - (t shr 8 + t) shr 8;
        end;
      end;
    end;
    inc(PDst);
    inc(PSrc, IncSrc);
    dec(Count);
  end;
end;

// Blend with color operation

procedure Pas_x_4Ch_Add_x_8b_ColorOp(var Info: TpgBlendInfo);
var
  Count: integer;
  PSrc, PDst, PBuf: PpgColorARGB;
  InfoOut: TpgBlendInfo;
begin
  // Create a list of source colors based on the operation
  Count := Info.Count;
  PSrc := Info.PColSrc;
  PDst := Info.PColDst;
  PBuf := Info.Buffer;

  if (Info.IncSrc = 0) then Count := 1;
  while Count > 0 do
  begin
    Info.ColorOp(PSrc, PDst, PBuf);
    inc(PSrc, Info.IncSrc);
    inc(PDst);
    inc(PBuf);
    dec(Count);
  end;

  // Readjust some values
  InfoOut := Info;
  InfoOut.PColSrc := Info.Buffer;
  InfoOut.Buffer := PBuf;

  // Call normal blend
  TpgBlendFunc(Info.BlendFunc)(InfoOut);
end;

// Color operations

procedure Pas_x_4Ch_Add_x_8b_ColorOpOver(PColA, PColB, PColDst: pointer);
// For reference only: OpOver is standard, so not used
begin
  PpgColorARGB(PColDst)^ := PpgColorARGB(PColA)^;
end;

procedure Pas_x_4Ch_Add_x_8b_ColorOpAdd(PColA, PColB, PColDst: pointer);
var
  i: integer;
  Pa, Pb, Pd: pbyte;
  D: integer;
begin
  Pa := PColA;
  Pb := PColB;
  Pd := PColDst;
  for i := 0 to 3 do
  begin
    D := Pa^ + Pb^;
    if D > $FF then
      Pd^ := $FF
    else
      Pd^ := D;
    inc(Pa); inc(Pb); inc(Pd);
  end;
end;

procedure Pas_x_4Ch_Add_x_8b_ColorOpSub(PColA, PColB, PColDst: pointer);
var
  i: integer;
  Pa, Pb, Pd: pbyte;
  D: integer;
begin
  Pa := PColA;
  Pb := PColB;
  Pd := PColDst;
  for i := 0 to 3 do
  begin
    D := Pa^ - Pb^;
    if D < 0 then
      Pd^ := 0
    else
      Pd^ := D;
    inc(Pa); inc(Pb); inc(Pd);
  end;
end;

procedure Pas_x_4Ch_Add_x_8b_ColorOpDiv(PColA, PColB, PColDst: pointer);
// to do
var
  i: integer;
  Pa, Pb, Pd: pbyte;
  D: integer;
begin
  Pa := PColA;
  Pb := PColB;
  Pd := PColDst;
  for i := 0 to 3 do
  begin
    D := Pa^ + Pb^;
    if D > $FF then
      Pd^ := $FF
    else
      Pd^ := D;
    inc(Pa); inc(Pb); inc(Pd);
  end;
end;

procedure Pas_x_4Ch_Add_x_8b_ColorOpModulate(PColA, PColB, PColDst: pointer);
var
  i: integer;
  Pa, Pb, Pd: pbyte;
begin
  Pa := PColA;
  Pb := PColB;
  Pd := PColDst;
  for i := 0 to 3 do
  begin
    Pd^ := pgIntMul(Pa^, Pb^);
    inc(Pa); inc(Pb); inc(Pd);
  end;
end;

procedure Pas_x_4Ch_Add_x_8b_ColorOpMax(PColA, PColB, PColDst: pointer);
// to do
var
  i: integer;
  Pa, Pb, Pd: pbyte;
  D: integer;
begin
  Pa := PColA;
  Pb := PColB;
  Pd := PColDst;
  for i := 0 to 3 do
  begin
    D := Pa^ + Pb^;
    if D > $FF then
      Pd^ := $FF
    else
      Pd^ := D;
    inc(Pa); inc(Pb); inc(Pd);
  end;
end;

procedure Pas_x_4Ch_Add_x_8b_ColorOpMin(PColA, PColB, PColDst: pointer);
// to do
var
  i: integer;
  Pa, Pb, Pd: pbyte;
  D: integer;
begin
  Pa := PColA;
  Pb := PColB;
  Pd := PColDst;
  for i := 0 to 3 do
  begin
    D := Pa^ + Pb^;
    if D > $FF then
      Pd^ := $FF
    else
      Pd^ := D;
    inc(Pa); inc(Pb); inc(Pd);
  end;
end;

procedure Pas_x_4Ch_Add_x_8b_ColorOpDifference(PColA, PColB, PColDst: pointer);
// to do
var
  i: integer;
  Pa, Pb, Pd: pbyte;
  D: integer;
begin
  Pa := PColA;
  Pb := PColB;
  Pd := PColDst;
  for i := 0 to 3 do
  begin
    D := Pa^ + Pb^;
    if D > $FF then
      Pd^ := $FF
    else
      Pd^ := D;
    inc(Pa); inc(Pb); inc(Pd);
  end;
end;

procedure Pas_x_4Ch_Add_x_8b_ColorOpExclusion(PColA, PColB, PColDst: pointer);
// to do
var
  i: integer;
  Pa, Pb, Pd: pbyte;
  D: integer;
begin
  Pa := PColA;
  Pb := PColB;
  Pd := PColDst;
  for i := 0 to 3 do
  begin
    D := Pa^ + Pb^;
    if D > $FF then
      Pd^ := $FF
    else
      Pd^ := D;
    inc(Pa); inc(Pb); inc(Pd);
  end;
end;

procedure Pas_x_4Ch_Add_x_8b_ColorOpAverage(PColA, PColB, PColDst: pointer);
// to do
var
  i: integer;
  Pa, Pb, Pd: pbyte;
  D: integer;
begin
  Pa := PColA;
  Pb := PColB;
  Pd := PColDst;
  for i := 0 to 3 do
  begin
    D := Pa^ + Pb^;
    if D > $FF then
      Pd^ := $FF
    else
      Pd^ := D;
    inc(Pa); inc(Pb); inc(Pd);
  end;
end;

{ MMX functions }

function Mmx_Org_Blend(F, B: TpgColor32): TpgColor32;
asm
  { This is an implementation of the merge formula, as described
    in a paper by Bruce Wallace in 1981. Merging is associative,
    that is, A over (B over C) = (A over B) over C. The formula is,

      Ra = Fa + Ba - Fa * Ba
      Rc = (Fa (Fc - Bc * Ba) + Bc * Ba) / Ra

    where

      Rc is the resultant color,  Ra is the resultant alpha,
      Fc is the foreground color, Fa is the foreground alpha,
      Bc is the background color, Ba is the background alpha.
  }

        TEST      EAX,$FF000000  // foreground completely transparent =>
        JZ        @1             // result = background
        TEST      EDX,$FF000000  // background completely transparent =>
        JZ        @2             // result = foreground
        CMP       EAX,$FF000000  // foreground completely opaque =>
        JNC       @2             // result = foreground

        PXOR      MM3,MM3
        PUSH      ESI
        MOVD      MM0,EAX        // MM0  <-  Fa Fr Fg Fb
        PUNPCKLBW MM0,MM3        // MM0  <-  00 Fa 00 Fr 00 Fg 00 Fb
        MOVD      MM1,EDX        // MM1  <-  Ba Br Bg Bb
        PUNPCKLBW MM1,MM3        // MM1  <-  00 Ba 00 Br 00 Bg 00 Bb
        SHR       EAX,24         // EAX  <-  00 00 00 Fa
        MOVQ      MM4,MM0        // MM4  <-  00 Fa 00 Fr 00 Fg 00 Fb
        SHR       EDX,24         // EDX  <-  00 00 00 Ba
        MOVQ      MM5,MM1        // MM5  <-  00 Ba 00 Br 00 Bg 00 Bb
        MOV       ECX,EAX        // ECX  <-  00 00 00 Fa
        PUNPCKHWD MM4,MM4        // MM4  <-  00 Fa 00 Fa 00 Fg 00 Fg
        ADD       ECX,EDX        // ECX  <-  00 00 Sa Sa
        PUNPCKHDQ MM4,MM4        // MM4  <-  00 Fa 00 Fa 00 Fa 00 Fa
        MUL       EDX            // EAX  <-  00 00 Pa **
        PUNPCKHWD MM5,MM5        // MM5  <-  00 Ba 00 Ba 00 Bg 00 Bg
        MOV       ESI,$FF        // ESI  <-  00 00 00 00 FF
        PUNPCKHDQ MM5,MM5        // MM5  <-  00 Ba 00 Ba 00 Ba 00 Ba
        DIV       ESI
        SUB       ECX,EAX        // ECX  <-  00 00 00 Ra
        MOV       EAX,$ffff
        CDQ
        PMULLW    MM1,MM5        // MM1  <-  B * Ba
        PSRLW     MM1,8
        DIV       ECX
        PMULLW    MM0,MM4        // MM0  <-  F * Fa
        PSRLW     MM0,8
        PMULLW    MM4,MM1        // MM4  <-  B * Ba * Fa
        PSRLW     MM4,8
        SHL       ECX,24
        PADDUSW   MM1,MM0        // MM1  <-  B * Ba + F * Fa
        PSUBUSW   MM1,MM4        // MM1  <-  B * Ba + F * Fa - B * Ba * Fa
        MOVD      MM2,EAX        // MM2  <-  Qa = 1 / Ra
        PUNPCKLWD MM2,MM2        // MM2  <-  00 00 00 00 00 Qa 00 Qa
        PUNPCKLWD MM2,MM2        // MM2  <-  00 Qa 00 Qa 00 Qa 00 Qa
        PMULLW    MM1,MM2
        PSRLW     MM1,8
        PACKUSWB  MM1,MM3        // MM1  <-  00 00 00 00 xx Rr Rg Rb
        MOVD      EAX,MM1        // EAX  <-  xx Rr Rg Rb
        AND       EAX,$00FFFFFF  // EAX  <-  00 Rr Rg Rb
        OR        EAX,ECX        // EAX  <-  Ra Rr Rg Rb
        POP ESI
        RET
@1:     MOV       EAX,EDX
@2:
end;

procedure Mmx_Org_4Ch_Add_Std_8b_Blend(var Info: TpgBlendInfo);
var
  Count: integer;
  PSrc, PDst, PBuf: PpgColor32;
  PCvr: PByte;
  IncSrc: integer;
begin
  Count := Info.Count;
  PSrc := Info.PColSrc;
  PDst := Info.PColDst;

  // Adjust for cover
  IncSrc := Info.IncSrc;
  if Info.PCvrSrc <> nil then
  begin
    // Put src into buf
    PBuf := Info.Buffer;
    PCvr := Info.PCvrSrc;
    if (Info.IncSrc = 0) and (Info.IncCvr = 0) then
      Count := 1
    else
      IncSrc := 1;
    while Count > 0 do
    begin
      Pas_Org_4Ch_x_x_8b_AdjustAlpha(PSrc, PBuf, PCvr^);
      inc(PSrc, Info.IncSrc);
      inc(PBuf);
      inc(PCvr, Info.IncCvr);
      dec(Count);
    end;
    // Readjust some values
    PSrc := Info.Buffer;
    Count := Info.Count;
  end;

  while Count > 0 do
  begin
    PDst^ := Mmx_Org_Blend(PSrc^, PDst^);
    inc(PDst);
    inc(PSrc, IncSrc);
    dec(Count);
  end;
  EMMS;
end;

function Mmx_Pre_Blend(F, B: TpgColor32): TpgColor32;
asm
  // blend premultiplied colors
  // EAX <- F
  // EDX <- B
  // Rc = Fc + Bc - (Fa * Bc)

        CMP       EAX,$FF000000  // foreground completely opaque =>
        JNC       @2             // result = foreground
        TEST      EAX,$FF000000  // foreground completely transparent =>
        JZ        @1             // result = background
        TEST      EDX,$FF000000  // background completely transparent =>
        JZ        @2             // result = foreground

        PXOR      MM3,MM3       // MM3 <- 00 00 00 00  00 00 00 00
        MOVD      MM0,EAX       // MM0 <- 00 00 00 00  Fa Fr Fg Fb
        PUNPCKLBW MM0,MM3       // MM0 <- 00 Fa 00 Fr  00 Fg 00 Fb  Fc
        MOVQ      MM1,MM0       // MM1 <- 00 Fa 00 Fr  00 Fg 00 Fb  Fc
        PUNPCKHWD MM1,MM1       // MM1 <- 00 Fa 00 Fa  00 Fr 00 Fr
        MOVD      MM2,EDX       // MM2 <- 00 00 00 00  Ba Br Bg Bb
        PUNPCKHDQ MM1,MM1       // MM1 <- 00 Fa 00 Fa  00 Fa 00 Fa  Fa
        MOV       EAX,$80808080
        PUNPCKLBW MM2,MM3       // MM2 <- 00 Ba 00 Br  00 Bg 00 Bb  Bc
        MOVD      MM4,EAX       // MM4 <- 00 00 00 00  80 80 80 80
        PMULLW    MM1,MM2       // MM1 <- Pa ** Pr **  Pg ** Pb **  Fa * Bc
        PUNPCKLBW MM4,MM3       // MM4 <- 00 80 00 80  00 80 00 80  $80
        PADDW     MM1,MM4       // MM1 <- Ta ** Tr **  Tg ** Tb **  t = Fa * Bc + $80
        MOVQ      MM4,MM1       // MM4 <- Ta ** Tr **  Tg ** Tb **  t
        PSRLW     MM1,8         // MM1 <- 00 Ta 00 Tr  00 Tg 00 Tb  t shr 8
        PADDW     MM4,MM1       // MM4 <- Ta ** Tr **  Tg ** Tb **  t shr 8 + t
        PSRLW     MM4,8         // MM4 <- 00 Ta 00 Tr  00 Tg 00 Tb  (t shr 8 + t) shr 8
        PADDW     MM0,MM2       // MM0 <- Ra ** Rr **  Rg ** Rb **  R = Fc + Bc
        PSUBW     MM0,MM4       // MM0 <- Ra ** Rr **  Rg ** Rb **  R = Fc + Bc - t term
        PACKUSWB  MM0,MM3       // MM0 <- 00 00 00 00  Ra Rr Rg Rb
        MOVD      EAX,MM0
        RET
@1:     MOV       EAX,EDX
@2:
end;

procedure Mmx_Pre_4Ch_Add_Std_8b_Blend(var Info: TpgBlendInfo);
var
  Count, IncSrc: integer;
  PSrc, PDst, PBuf: PpgColor32;
  PCvr: PByte;
begin
  Count := Info.Count;
  PSrc := Info.PColSrc;
  PDst := Info.PColDst;

  // Adjust for cover
  IncSrc := Info.IncSrc;
  if Info.PCvrSrc <> nil then
  begin
    // Put src into buf
    PBuf := Info.Buffer;
    PCvr := Info.PCvrSrc;
    if (Info.IncSrc = 0) and (Info.IncCvr = 0) then
      Count := 1
    else
      IncSrc := 1;
    while Count > 0 do
    begin
      Pas_Pre_4Ch_x_x_8b_AdjustAlpha(PSrc, PBuf, PCvr^);
      inc(PSrc, Info.IncSrc);
      inc(PBuf);
      inc(PCvr, Info.IncCvr);
      dec(Count);
    end;
    // Re-adjust some values
    PSrc := Info.Buffer;
    Count := Info.Count;
  end;

  while Count > 0 do
  begin
    PDst^ := Mmx_Pre_Blend(PSrc^, PDst^);
    inc(PDst);
    inc(PSrc, IncSrc);
    dec(Count);
  end;
  EMMS;
end;


end.

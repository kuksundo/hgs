{
  Abstraction of graphics back-ends is added in this unit dtpGraphics.pas
  so that the rest of the DtpDocuments library does not need to deal with
  many different back-ends.

  Possible back-ends:
  - Graphics32 1.9.0 (directive UseGR32)
  - Simdesigns Pyro  (directive UsePyro) - TODO - but in the works!

  Creation Date: 06Jun2010 (NH)

  Copyright (c) 2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

}
unit dtpGraphics;

{$i simdesign.inc}

// switches for the use of gr32 or pyro
{$define usegr32}
{.$define usepyro}

interface

uses
  {$ifdef UseGR32}
  GR32, GR32_Resamplers, GR32_LowLevel, GR32_Layers, GR32_Image, GR32_OrdinalMaps,
  GR32_Blend, GR32_Polygons, GR32_Backends, sdVirtualScrollbox,
  {$endif}

  {$ifdef UsePyro}
  Pyro, pgCPUInfo, pgMap, pgBitmap, pgSampler, pgPolyPolygon, Windows,
  {$endif}

  Graphics, Classes, SysUtils;

// general
type

  TdtpDrawMode = (dtpdmOpaque, dtpdmBlend, dtpdmCustom, dtpdmTransparent);
  TdtpDragState = integer;

// Graphics32 backend
{$ifdef UseGR32}

type

  PdtpColor = ^TdtpColor;
  TdtpColor = TColor32;
  TArrayOfdtpColor = array of TdtpColor;

  PdtpPoint = ^TdtpPoint;
  TdtpPoint = TFloatPoint;
  TdtpRect = TFloatRect;

  TdtpArrayOfArrayOfFixedPoint = TArrayOfArrayOfFixedPoint;
  TdtpArrayOfFixedPoint = TArrayOfFixedPoint;
  TdtpFixedPoint = TFixedPoint;
  PFixed = ^TFixed;
  TFixed = type Integer;

  TdtpBitmap = TBitmap32;
  TdtpPolygon = TPolygon32;
  TdtpByteMap = TByteMap;

  TdtpStretchFilter = (dtpsfNearest, dtpsfDraft, dtpsfLinear, dtpsfCosine, dtpsfSpline, dtpsfLanczos, dtpsfMitchell);
  TdtpCombineMode = (dtpcmBlend, dtpcmMerge);
  TdtpConversionType = (dtpctRed, dtpctGreen, dtpctBlue, dtpctAlpha, dtpctUniformRGB, dtpctWeightedRGB);
  TdtpPolyFillMode = (dtppfAlternate, dtppfWinding);

  TdtpRubberbandLayer = TRubberbandLayer;
  TdtpImgView = TImgView32;
  TdtpPositionedLayer = TPositionedLayer;

  TdtpVirtualScrollbox = TsdVirtualScrollbox;

  TdtpPixelCombineEvent = procedure(F: TdtpColor; var B: TdtpColor; M: TdtpColor) of object;
  TdtpFillLineEvent = procedure(Dst: PdtpColor; DstX, DstY, Length: Integer; AlphaValues: PdtpColor) of object;
  TdtpResizingEvent = procedure(Sender: TObject; const OldLocation: TdtpRect;
    var NewLocation: TdtpRect; DragState: integer; Shift: TShiftState) of object;


// construction and conversion of point types
function Fixed(I: Integer): TFixed; overload;
function Fixed(S: Single): TFixed; overload;
procedure OffsetRect(var R: TRect; Dx, Dy: Integer); overload;
procedure OffsetRect(var FR: TdtpRect; Dx, Dy: TFloat); overload;
procedure InflateRect(var R: TRect; Dx, Dy: Integer); overload;
procedure InflateRect(var FR: TFloatRect; Dx, Dy: TFloat); overload;
function IntersectRect(out Dst: TRect; const R1, R2: TRect): Boolean; overload;
function IntersectRect(out Dst: TdtpRect; const FR1, FR2: TdtpRect): Boolean; overload;

// colors
function dtpColor(WinColor: TColor): TdtpColor; overload;
function dtpColor(R, G, B: Byte; A: Byte = $FF): TdtpColor; overload;
function WinColor(Color32: TdtpColor): TColor;
procedure RGBtoHSL(RGB: TdtpColor; out H, S, L : Single); overload;
function HSLtoRGB(H, S, L: Single): TdtpColor; overload;

// bitmap
procedure SetStretchFilter(Dib: TdtpBitmap; AStretchFilter: TdtpStretchFilter);
procedure SetDrawMode(Dib: TdtpBitmap; ADrawMode: TdtpDrawMode);
procedure SetCombineMode(Dib: TdtpBitmap; ACombineMode: TdtpCombineMode);

procedure SetResizingEvent(ABand: TdtpRubberbandLayer; OnResizing: TdtpResizingEvent);

procedure StretchTransfer(Dst: TdtpBitmap; const DstRect: TRect; DstClip: TRect;
  Src: TdtpBitmap; const SrcRect: TRect; Resampler: TCustomResampler;
  CombineOp: TdtpDrawMode; CombineCallBack: TdtpPixelCombineEvent);

function GetPixelPtr(ABitmap: TdtpBitmap; X, Y: integer): PdtpColor;

procedure MergeLine(Src, Dst: PdtpColor; Count: Integer);
procedure MergeLineEx(Src, Dst: PdtpColor; Count: Integer; M: TdtpColor);

procedure dtpReadFromMap(AMap: TdtpByteMap; ADib: TdtpBitmap; AConv: TdtpConversionType);
procedure dtpWriteToMap(AMap: TdtpByteMap; ADib: TdtpBitmap; AConv: TdtpConversionType);

procedure dtpDrawFill(APoly: TdtpPolygon; ADib: TdtpBitmap; AFill: TdtpFillLineEvent);

procedure dtpSetPolyFillMode(APoly: TdtpPolygon; AMode: TdtpPolyFillMode);

function dtpBlendReg(F, B: TdtpColor): TdtpColor;
function dtpBlendRegEx(F, B, M: TdtpColor): TdtpColor;
function dtpCombineReg(X, Y, W: TdtpColor): TdtpColor;
function dtpIntensity(const C: TdtpColor): integer;
procedure EMMS;

{$endif}//UseGR32

// Pyro backend
{$ifdef UsePyro}

type
  TFixed = TpgFixed;
  PdtpColor = ^TdtpColor;
  TdtpColor = TpgColor32;
  TdtpBitmap = TpgBitmap32;
  TdtpByteMap = TpgByteMap;

  TdtpPolygon = TpgPolyPolygonF;
  TdtpFixedPoint = TpgPointF;
  TdtpArrayOfFixedPoint = TpgArrayOfPointF;
  TdtpArrayOfArrayOfFixedPoint = TpgArrayOfArrayOfPointF;

  TdtpStretchFilter = (dtpsfNearest, dtpsfLinear);
  TdtpPixelCombineEvent = procedure(F: TdtpColor; var B: TdtpColor; M: TdtpColor) of object;
  TCustomResampler = class(TObject); //todo
  TdtpConversionType = (ctRed, ctGreen, ctBlue, ctAlpha, ctUniformRGB, ctWeightedRGB);
  PdtpPoint = ^TdtpPoint;
  TdtpPoint = TpgPoint;
  TdtpRect = TpgBox;
  TFloat = single;
  TFixedPoint = record
    x, y: TFixed
  end;


// bitmap
procedure SetStretchFilter(Dib: TdtpBitmap; AStretchFilter: TdtpStretchFilter);
procedure StretchTransfer(Dst: TdtpBitmap; const DstRect: TRect; DstClip: TRect;
  Src: TdtpBitmap; const SrcRect: TRect; Resampler: TCustomResampler;
  CombineOp: TdtpDrawMode; CombineCallBack: TdtpPixelCombineEvent);
function dtpBlendReg(F, B: TdtpColor): TdtpColor;
function dtpBlendRegEx(F, B, M: TdtpColor): TdtpColor;
procedure EMMS;
procedure dtpReadFromMap(AMap: TdtpByteMap; ADib: TdtpBitmap; AConv: TdtpConversionType);
procedure dtpWriteToMap(AMap: TdtpByteMap; ADib: TdtpBitmap; AConv: TdtpConversionType);
procedure MergeLine(Src, Dst: PdtpColor; Count: Integer);
procedure MergeLineEx(Src, Dst: PdtpColor; Count: Integer; M: TdtpColor);

{$endif}//usepyro

//general


function Point(X, Y: Integer): TPoint; overload;
function Point(const FP: TdtpPoint): TPoint; overload;
function dtpFixedPoint(X, Y: Single): TFixedPoint; overload;
function dtpFixedPoint(const FP: TdtpPoint): TFixedPoint; overload;
function dtpRect(const L, T, R, B: TFloat): TdtpRect; overload;
function dtpRect(const ARect: TRect): TdtpRect; overload;

function dtpPoint(X, Y: Single): TdtpPoint; overload;
function dtpPoint(const P: TPoint): TdtpPoint; overload;
procedure MoveLongword(const Source; var Dest; Count: Integer);
function FixedMul(A, B: TFixed): TFixed;
function FixedDiv(A, B: TFixed): TFixed;
function AlphaComponent(Color32: TdtpColor): Integer;
function BlueComponent(Color32: TdtpColor): Integer;
function SetAlpha(Color32: TdtpColor; NewAlpha: Integer): TdtpColor;

const
  // Some predefined constants
  clBlack32               = TdtpColor($FF000000);

  clLightGray32           = TdtpColor($FFBFBFBF);   // changed by J.F. Feb 2011
  clWhite32               = TdtpColor($FFFFFFFF);   // for completeness
  clMaroon32              = TdtpColor($FF7F0000);   // and to set PageShdow Color etc.
  clGreen32               = TdtpColor($FF007F00);
  clOlive32               = TdtpColor($FF7F7F00);
  clNavy32                = TdtpColor($FF00007F);
  clPurple32              = TdtpColor($FF7F007F);
  clTeal32                = TdtpColor($FF007F7F);
  clRed32                 = TdtpColor($FFFF0000);
  clLime32                = TdtpColor($FF00FF00);
  clYellow32              = TdtpColor($FFFFFF00);
  clBlue32                = TdtpColor($FF0000FF);
  clFuchsia32             = TdtpColor($FFFF00FF);
  clAqua32                = TdtpColor($FF00FFFF);

  // Some semi-transparent color constants
  clTrWhite32             = TdtpColor($7FFFFFFF);
  clTrBlack32             = TdtpColor($7F000000);
  clTrRed32               = TdtpColor($7FFF0000);
  clTrGreen32             = TdtpColor($7F00FF00);
  clTrBlue32              = TdtpColor($7F0000FF);


  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

implementation

uses
  Math;

// Graphics32 backend
{$ifdef UseGR32}

function Fixed(I: Integer): TFixed;
begin
  Result := I shl 16;
end;

function Fixed(S: Single): TFixed;
begin
  Result := Round(S * 65536);
end;

procedure OffsetRect(var R: TRect; Dx, Dy: Integer);
begin
  Inc(R.Left, Dx); Inc(R.Top, Dy);
  Inc(R.Right, Dx); Inc(R.Bottom, Dy);
end;

procedure OffsetRect(var FR: TdtpRect; Dx, Dy: TFloat);
begin
  with FR do
  begin
    Left := Left + Dx; Top := Top + Dy;
    Right := Right + Dx; Bottom := Bottom + Dy;
  end;
end;

procedure InflateRect(var R: TRect; Dx, Dy: Integer);
begin
  Dec(R.Left, Dx); Dec(R.Top, Dy);
  Inc(R.Right, Dx); Inc(R.Bottom, Dy);
end;

procedure InflateRect(var FR: TFloatRect; Dx, Dy: TFloat);
begin
  with FR do
  begin
    Left := Left - Dx; Top := Top - Dy;
    Right := Right + Dx; Bottom := Bottom + Dy;
  end;
end;

function IntersectRect(out Dst: TRect; const R1, R2: TRect): Boolean;
begin
  if R1.Left >= R2.Left then Dst.Left := R1.Left else Dst.Left := R2.Left;
  if R1.Right <= R2.Right then Dst.Right := R1.Right else Dst.Right := R2.Right;
  if R1.Top >= R2.Top then Dst.Top := R1.Top else Dst.Top := R2.Top;
  if R1.Bottom <= R2.Bottom then Dst.Bottom := R1.Bottom else Dst.Bottom := R2.Bottom;
  Result := (Dst.Right >= Dst.Left) and (Dst.Bottom >= Dst.Top);
  if not Result then Dst := ZERO_RECT;
end;

function IntersectRect(out Dst: TdtpRect; const FR1, FR2: TdtpRect): Boolean;
begin
  Dst.Left   := Max(FR1.Left,   FR2.Left);
  Dst.Right  := Min(FR1.Right,  FR2.Right);
  Dst.Top    := Max(FR1.Top,    FR2.Top);
  Dst.Bottom := Min(FR1.Bottom, FR2.Bottom);
  Result := (Dst.Right >= Dst.Left) and (Dst.Bottom >= Dst.Top);
  if not Result then FillLongword(Dst, 4, 0);
end;

function dtpColor(WinColor: TColor): TdtpColor;
begin
  Result := Color32(WinColor);
end;

function dtpColor(R, G, B: Byte; A: Byte = $FF): TdtpColor; overload;
begin
  Result := Color32(R, G, B, A);
end;

function WinColor(Color32: TColor32): TColor;
begin
  Result := GR32.WinColor(Color32)
end;

procedure RGBtoHSL(RGB: TdtpColor; out H, S, L : Single); overload;
begin
  GR32.RGBtoHSL(RGB, H, S, L);
end;

function HSLtoRGB(H, S, L: Single): TdtpColor; overload;
begin
  Result := GR32.HSLtoRGB(H, S, L);
end;

procedure SetStretchFilter(Dib: TdtpBitmap; AStretchFilter: TdtpStretchFilter);
begin
  Dib.StretchFilter := TStretchFilter(AStretchFilter);
end;

procedure SetDrawMode(Dib: TdtpBitmap; ADrawMode: TdtpDrawMode);
begin
  Dib.DrawMode := TDrawMode(ADrawMode);
end;

procedure SetCombineMode(Dib: TdtpBitmap; ACombineMode: TdtpCombineMode);
begin
  Dib.CombineMode := TCombineMode(ACombineMode);
end;

procedure SetResizingEvent(ABand: TdtpRubberbandLayer; OnResizing: TdtpResizingEvent);
begin
  ABand.OnResizing := TRBResizingEvent(OnResizing);
end;

procedure StretchTransfer(
  Dst: TdtpBitmap; const DstRect: TRect; DstClip: TRect;
  Src: TdtpBitmap; const SrcRect: TRect;
  Resampler: TCustomResampler;
  CombineOp: TdtpDrawMode; CombineCallBack: TdtpPixelCombineEvent);
begin
  GR32_Resamplers.StretchTransfer(Dst, DstRect, DstClip, Src, SrcRect, Resampler,
    TDrawMode(CombineOp), CombineCallback);
end;

function GetPixelPtr(ABitmap: TdtpBitmap; X, Y: integer): PdtpColor;
begin
  Result := PdtpColor(ABitmap.PixelPtr[X, Y]);
end;

procedure MergeLine(Src, Dst: PdtpColor; Count: Integer);
begin
  GR32_Blend.MergeLine(PColor32(Src), PColor32(Dst), Count);
end;

procedure MergeLineEx(Src, Dst: PdtpColor; Count: Integer; M: TdtpColor);
begin
  GR32_Blend.MergeLineEx(PColor32(Src), PColor32(Dst), Count, M);
end;

procedure dtpReadFromMap(AMap: TdtpByteMap; ADib: TdtpBitmap; AConv: TdtpConversionType);
begin
  AMap.ReadFrom(ADib, TConversionType(AConv));
end;

procedure dtpWriteToMap(AMap: TdtpByteMap; ADib: TdtpBitmap; AConv: TdtpConversionType);
begin
  AMap.WriteTo(ADib, TConversionType(AConv));
end;

procedure dtpDrawFill(APoly: TdtpPolygon; ADib: TdtpBitmap; AFill: TdtpFillLineEvent);
begin
  APoly.DrawFill(ADib, TFillLineEvent(AFill));
end;

procedure dtpSetPolyFillMode(APoly: TdtpPolygon; AMode: TdtpPolyFillMode);
begin
  APoly.FillMode := TPolyFillMode(AMode);
end;

function dtpBlendReg(F, B: TdtpColor): TdtpColor;
begin
  Result := BlendReg(F, B);
end;

function dtpBlendRegEx(F, B, M: TColor32): TColor32;
begin
  Result := BlendRegEx(F, B, M);
end;

function dtpCombineReg(X, Y, W: TdtpColor): TdtpColor;
begin
  Result := CombineReg(X, Y, W);
end;

function dtpIntensity(const C: TdtpColor): integer;
begin
  Result := Intensity(C);
end;


procedure EMMS;
begin
  if MMX_ACTIVE then
  asm
    db $0F,$77  /// EMMS
  end;
end;

{$endif}//gr32 backend

// pyro backend
{$ifdef UsePyro}

procedure SetStretchFilter(Dib: TdtpBitmap; AStretchFilter: TdtpStretchFilter);
begin
// todo
end;

procedure StretchTransfer(
  Dst: TdtpBitmap; const DstRect: TRect; DstClip: TRect;
  Src: TdtpBitmap; const SrcRect: TRect;
  Resampler: TCustomResampler;
  CombineOp: TdtpDrawMode; CombineCallBack: TdtpPixelCombineEvent);
begin
// todo
end;

procedure EMMS;
begin
//todo
end;

function dtpBlendReg(F, B: TdtpColor): TdtpColor;
begin
// todo
  Result := 0;
end;

function dtpBlendRegEx(F, B, M: TdtpColor): TdtpColor;
begin
// todo
  Result := 0;
end;

procedure dtpReadFromMap(AMap: TdtpByteMap; ADib: TdtpBitmap; AConv: TdtpConversionType);
begin
// todo
end;

procedure dtpWriteToMap(AMap: TdtpByteMap; ADib: TdtpBitmap; AConv: TdtpConversionType);
begin
// todo
end;

procedure MergeLine(Src, Dst: PdtpColor; Count: Integer);
begin
// todo
end;

procedure MergeLineEx(Src, Dst: PdtpColor; Count: Integer; M: TdtpColor);
begin
// todo
end;

{$endif}//usepyro

// general functions

function Point(X, Y: Integer): TPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

function Point(const FP: TdtpPoint): TPoint;
begin
  Result.X := Round(FP.X);
  Result.Y := Round(FP.Y);
end;

function dtpPoint(X, Y: Single): TdtpPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

function dtpPoint(const P: TPoint): TdtpPoint;
begin
  Result.X := P.X;
  Result.Y := P.Y;
end;

function dtpFixedPoint(X, Y: Single): TFixedPoint; overload;
begin
  Result.X := Round(X * 65536);
  Result.Y := Round(Y * 65536);
end;

function dtpFixedPoint(const FP: TdtpPoint): TFixedPoint; overload;
begin
  Result.X := Round(FP.X * 65536);
  Result.Y := Round(FP.Y * 65536);
end;

function dtpRect(const L, T, R, B: TFloat): TdtpRect;
begin
  with Result do
  begin
    Left := L;
    Top := T;
    Right := R;
    Bottom := B;
  end;
end;

function dtpRect(const ARect: TRect): TdtpRect;
begin
  with Result do
  begin
    Left := ARect.Left;
    Top := ARect.Top;
    Right := ARect.Right;
    Bottom := ARect.Bottom;
  end;
end;

procedure MoveLongword(const Source; var Dest; Count: Integer);
begin
  Move(Source, Dest, Count shl 2);
end;

function FixedMul(A, B: TFixed): TFixed;
asm
        IMUL    EDX
        SHRD    EAX, EDX, 16
end;

function FixedDiv(A, B: TFixed): TFixed;
asm
        MOV     ECX, B
        CDQ
        SHLD    EDX, EAX, 16
        SHL     EAX, 16
        IDIV    ECX
end;

function SetAlpha(Color32: TdtpColor; NewAlpha: Integer): TdtpColor;
begin
  if NewAlpha < 0 then
    NewAlpha := 0
  else if NewAlpha > 255 then
    NewAlpha := 255;
  Result := (Color32 and $00FFFFFF) or (TdtpColor(NewAlpha) shl 24);
end;

function AlphaComponent(Color32: TdtpColor): Integer;
begin
  Result := Color32 shr 24;
end;

function BlueComponent(Color32: TdtpColor): Integer;
begin
  Result := Color32 and $000000FF;
end;

end.

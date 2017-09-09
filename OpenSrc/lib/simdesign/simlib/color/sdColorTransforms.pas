{ unit sdColorTransforms

  Author: Nils Haeck M.Sc.
  Copyright (c) 2007 SimDesign B.V.
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  sdColorTransforms implements color transformations independent of
  the TBitmap rasters, however, the transforms always implement the
  colors in row-form: e.g. XYZXYZ for 2 pixels with 3 channels.

  Color spaces that are implemented:
  - JFIF YCbCr
  - YCCK (using JFIF YCbCr)
  - YCCK for Adobe (using JFIF YCbCr, experimental)
  - Generic CIE L*a*b*
  - ITU CIE L*a*b* (canned parameters)
  - RGB
  - RGBA (RGB + Alpha)
  - CMYK
  - CMYK for Adobe
  - Gray
  - Gray + Alpha
  - YUV (Non-JFIF)

  Bitdepths that are implemented:
  - 8 bits per channel

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.

  Modifications:
  14jul2011: added TColorTransform functions SrcCellStride / DstCellStride
}
unit sdColorTransforms;

interface

uses
  Classes, NativeXml, sdDebug;

type

  // Abstract color transform
  TsdColorTransform = class(TsdDebugPersistent)
  public
    constructor Create; virtual;
    // Transform Count colors from Source to Dest
    procedure Transform(Source, Dest: pointer; Count: integer); virtual; abstract;
    // Source cellstride (#bytes per cell)
    function SrcCellStride: integer; virtual; abstract;
    // Dest cellstride (#bytes per cell)
    function DstCellStride: integer; virtual; abstract;
  end;

  // Transform class
  TsdColorTransformClass = class of TsdColorTransform;

  // Null transform: 8bit/pixel direct copy.
  TsdNullTransform8bit = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
  end;

  // Null transform: 16bit/pixel direct copy.
  TsdNullTransform16bit = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // Null transform: 24bit/pixel direct copy.
  TsdNullTransform24bit = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // Null transform: 32bit/pixel direct copy.
  TsdNullTransform32bit = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // Invert gray values from 0->255 and 255->0
  TsdTransformInverseGray8bit = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // Inversion transform: invert colour triplets RGB->BGR, can be used for any
  // 24bit triplet of colours that needs to be inverted in order.
  TsdTransformInvertTriplet24bit = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // Abstract JFIF transform (transforms used by JPEG's JFIF spec)
  TsdJfifTransform = class(TsdColorTransform)
  private
    FColorConvScale: integer;
    function RangeLimitDescale(A: integer): integer;
  public
    constructor Create; override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // Abstract JFIF forward transform (YCbCr to RGB space)
  TsdJfifFwdTransform = class(TsdJfifTransform)
  private
    F__toR: integer;
    F__toG: integer;
    F__toB: integer;
    FY_toRT: array[0..255] of integer;
    FCrtoRT: array[0..255] of integer;
    FCbtoGT: array[0..255] of integer;
    FCrtoGT: array[0..255] of integer;
    FCbtoBT: array[0..255] of integer;
    procedure InitYCbCrTables;
  public
    constructor Create; override;
  end;

  // Abstract JFIF inverse transform (RGB to YCbCr space)
  TsdJfifInvTransform = class(TsdJfifTransform)
  private
    F__toCb: integer;
    F__toCr: integer;
    FRtoY_: array[0..255] of integer;
    FGtoY_: array[0..255] of integer;
    FBtoY_: array[0..255] of integer;
    FRtoCb: array[0..255] of integer;
    FGtoCb: array[0..255] of integer;
    FBtoCb: array[0..255] of integer;
    FRtoCr: array[0..255] of integer;
    FGtoCr: array[0..255] of integer;
    FBtoCr: array[0..255] of integer;
    procedure InitRGBToYCbCrTables;
  public
    constructor Create; override;
  end;

  // Y-Cb-Cr (24bit) to BGR (24bit) colour transform. It assumes that
  // RGB is layed out in memory as BGR (as windows TBitmap does).
  TsdTransformYCbCrToBGR = class(TsdJfifFwdTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
  end;

  // Y-Cb-Cr (24bit) to BGRA (32bit) colour transform. It assumes that
  // RGB is layed out in memory as BGR (as windows TBitmap does). The alpha
  // channel A is set to $FF.
  TsdTransformYCbCrToBGRA = class(TsdJfifFwdTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function DstCellStride: integer; override;
  end;

  // Y-Cb-Cr (24bit) to gray (8it) colour transform. The Y channel is used
  // as grayscale directly, Cb and Cr channels are not used.
  TsdTransformYCbCrToGray = class(TsdJfifFwdTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function DstCellStride: integer; override;
  end;

  // Y-Cb-Cr-A (32bit) to BGR (24bit) colour transform. It assumes that
  // RGB is layed out in memory as BGR (as windows TBitmap does). The input
  // alpha (A) channel is ignored.
  TsdTransformYCbCrAToBGR = class(TsdJfifFwdTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
  end;

  // YCbCrK to BGR. YCbCr is first converted to CMY, then CMYK is converted to RGB
  TsdTransformYCbCrKToBGR = class(TsdJfifFwdTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
  end;

  // Y-Cb-Cr-A (32bit) to BGRA (32bit) colour transform. It assumes that
  // RGB is layed out in memory as BGR (as windows TBitmap does). The alpha
  // channels are copied.
  TsdTransformYCbCrAToBGRA = class(TsdJfifFwdTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // CMYK (32bit) to BGR (24bit) colour transform.
  TsdTransformCMYKToBGR = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // CMYK (32bit) to BGR (24bit) colour transform, Adobe specific.
  TsdTransformCMYKToBGR_Adobe = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // YCCK (32bit) to BGR (24bit) colour transform. The CMY channels are coded as
  // Y-Cb-Cr, thus first unencoded to CMY, then combined with K to do CMYK to RGB.
  TsdTransformYCCKToBGR = class(TsdJfifFwdTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
  end;

  // YCCK to BGR color transform, as Adobe does it. Experimental status!
  TsdTransformYCCKToBGR_Adobe = class(TsdJfifFwdTransform)
  private
    F0_65: integer;
    F44_8: integer;
    procedure InitConst;
  public
    constructor Create; override;
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
  end;

  // Gray (8bit) to BGR (24bit) transform. The R, G and B channels are all set
  // to the gray value.
  TsdTransformGrayToBGR = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // Gray + Alpha (16bit) to BGR (24bit) transform. The R, G and B channels are all set
  // to the gray value. The Alpha channel is ignored.
  TsdTransformGrayAToBGR = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // Gray + Alpha (16bit) to BGRA (32bit) transform. The R, G and B channels are all set
  // to the gray value. The Alpha channels are copied.
  TsdTransformGrayAToBGRA = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // RGB (24bit) to BGRA (32bit) transform. The output alpha (A) channel is
  // set to $FF.
  TsdTransformRGBToBGRA = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // RGBA (32bit) to BGR (24bit) transform. The input alpha (A) channel is ignored.
  TsdTransformRGBAToBGR = class(TsdColorTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // BGRA (32bit) to BGR (24bit) transform. This transform uses a parameter,
  // BkColor (TColor) that is used to fill the background, while the colors are
  // blended using the "over" operator. The background color by default is clWhite.
  // This routine assumes alpha pre-multiplied colors.
  TsdTransformBGRAToBGR = class(TsdColorTransform)
  private
    FBkColor: cardinal;
    procedure SetBkColor(const Value: cardinal);
    function GetBkColor: cardinal;
  public
    constructor Create; override;
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    property BkColor: cardinal read GetBkColor write SetBkColor;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // RGB (24bit) to Y-Cb-Cr (24bit) colour transform. It assumes that
  // RGB is layed out in memory as BGR (as windows TBitmap does).
  TsdTransformBGRToYCbCr = class(TsdJfifInvTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
  end;

  // RGB (24bit) to Gray (8bit) colour transform. It assumes that
  // RGB is layed out in memory as BGR (as windows TBitmap does). It uses
  // the same formula to find Gray as in RGB->YCbCr
  TsdTransformBGRToGray = class(TsdJfifInvTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function DstCellStride: integer; override;
  end;

  // RGBA (32bit) to Y-Cb-Cr-A (32bit) colour transform. It assumes that
  // RGB is layed out in memory as BGR (as windows TBitmap does). The alpha
  // channels are copied.
  TsdTransformBGRAToYCbCrA = class(TsdJfifInvTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // RGBA (32bit) to Y-Cb-Cr (24bit) colour transform. It assumes that
  // RGB is layed out in memory as BGR (as windows TBitmap does). The alpha
  // channel is ignored.
  TsdTransformBGRAToYCbCr = class(TsdJfifInvTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function SrcCellStride: integer; override;
  end;

  // CIE L*a*b* (24bit) to BGR (24bit), using parameters
  // - based on 24bit (3*8 bit) nulltransform
  TsdTransformCIELabToBGR = class(TsdNullTransform24bit)
  private
    FXw: double;
    FYw: double;
    FZw: double;
    FAmin: double;
    FAmax: double;
    FBmin: double;
    FBmax: double;
    FAofs: integer;
    FBofs: integer;
  public
    constructor Create; override;
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    // White point
    property Xw: double read FXw write FXw;
    property Yw: double read FYw write FYw;
    property Zw: double read FZw write FZw;
    // Range
    property Amin: double read FAmin write FAmin;
    property Amax: double read FAmax write FAmax;
    property Bmin: double read FBmin write FBmin;
    property Bmax: double read FBmax write FBmax;
    // Offset
    property Aofs: integer read FAofs write FAofs;
    property Bofs: integer read FBofs write FBofs;
  end;

  // ITU CIE L*a*b* (24bit) to BGR (24bit), with canned parameters, which are
  // set in the constructor
  TsdTransformITUCIELabToBGR = class(TsdTransformCIELabToBGR)
  public
    constructor Create; override;
  end;

  // Abstract YUV transform
  TsdYuvTransform = class(TsdColorTransform)
  private
    FPrecision: integer;
    FScaleFact: integer;
    FBias: integer;
    FMaxValue: integer;
    procedure InitScaleFact;
    function Clip(AValue: integer): integer;
  public
    constructor Create; override;
    function SrcCellStride: integer; override;
    function DstCellStride: integer; override;
  end;

  // Abstract YUV forward transform
  TsdYuvFwdTransform = class(TsdYuvTransform)
  private
    FYtoR: array[0..255] of  integer;
    FYtoG: array[0..255] of  integer;
    FYtoB: array[0..255] of  integer;
    FUtoG: array[0..255] of  integer;
    FUtoB: array[0..255] of  integer;
    FVtoR: array[0..255] of  integer;
    FVtoG: array[0..255] of  integer;
    procedure InitTables;
  public
    constructor Create; override;
  end;

  TsdTransformYUVToRGB = class(TsdYuvFwdTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
  end;

  TsdTransformYUVToCMYK = class(TsdYuvFwdTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
    function DstCellStride: integer; override;
  end;

  // Abstract YUV inverse transform
  TsdYuvInvTransform = class(TsdYuvTransform)
  private
    FYfromR: array[0..255] of  integer;
    FUfromR: array[0..255] of  integer;
    FVfromR: array[0..255] of  integer;
    FYfromG: array[0..255] of  integer;
    FUfromG: array[0..255] of  integer;
    FVfromG: array[0..255] of  integer;
    FYfromB: array[0..255] of  integer;
    FUfromB: array[0..255] of  integer;
    FVfromB: array[0..255] of  integer;
    procedure InitTables;
  public
    constructor Create; override;
  end;

  TsdTransformRGBToYUV = class(TsdYuvInvTransform)
  public
    procedure Transform(Source, Dest: pointer; Count: integer); override;
  end;

  // to do
  TsdTransformRGBAToGray = class(TsdColorTransform);
  TsdTransformRGBToCMYK = class(TsdColorTransform);
  TsdTransformRGBToYCCK = class(TsdColorTransform);
  TsdTransformCMYKToYCCK = class(TsdColorTransform);

implementation

uses
  Math;

{ TsdColorTransform }

constructor TsdColorTransform.Create;
// We need a virtual constructor so it can be overridden
begin
  inherited Create;
end;

{ TsdNullTransform8bit }

procedure TsdNullTransform8bit.Transform(Source, Dest: pointer; Count: integer);
begin
  Move(Source^, Dest^, Count);
end;

{ TsdNullTransform16bit }

function TsdNullTransform16bit.DstCellStride: integer;
begin
  Result := 2;
end;

function TsdNullTransform16bit.SrcCellStride: integer;
begin
  Result := 2;
end;

procedure TsdNullTransform16bit.Transform(Source, Dest: pointer; Count: integer);
begin
  Move(Source^, Dest^, Count * 2);
end;

{ TsdNullTransform24bit }

function TsdNullTransform24bit.DstCellStride: integer;
begin
  Result := 3;
end;

function TsdNullTransform24bit.SrcCellStride: integer;
begin
  Result := 3;
end;

procedure TsdNullTransform24bit.Transform(Source, Dest: pointer; Count: integer);
begin
  Move(Source^, Dest^, Count * 3);
end;

{ TsdNullTransform32bit }

function TsdNullTransform32bit.DstCellStride: integer;
begin
  Result := 4;
end;

function TsdNullTransform32bit.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdNullTransform32bit.Transform(Source, Dest: pointer; Count: integer);
begin
  Move(Source^, Dest^, Count * 4);
end;

{ TsdTransformInverseGray8bit }

function TsdTransformInverseGray8bit.DstCellStride: integer;
begin
  Result := 1;
end;

function TsdTransformInverseGray8bit.SrcCellStride: integer;
begin
  Result := 1;
end;

procedure TsdTransformInverseGray8bit.Transform(Source, Dest: pointer; Count: integer);
var
  G, IG: PByte;
begin
  G := Source;
  IG := Dest;
  while Count > 0 do
  begin
    IG^ := G^ xor $FF;
    inc(G);
    inc(IG);
    dec(Count);
  end;
end;

{ TsdTransformInvertTriplet24bit }

function TsdTransformInvertTriplet24bit.DstCellStride: integer;
begin
  Result := 3;
end;

function TsdTransformInvertTriplet24bit.SrcCellStride: integer;
begin
  Result := 3;
end;

procedure TsdTransformInvertTriplet24bit.Transform(Source, Dest: pointer; Count: integer);
var
  T: byte;
  X1S, X2S, X3S: PByte;
  X1D, X2D, X3D: PByte;
begin
  // Source pointers straightforward
  X1S := Source;
  X2S := Source; inc(X2S);
  X3S := Source; inc(X3S, 2);
  // Dest pointers layed out inverted
  X3D := Dest;
  X2D := Dest; inc(X2D);
  X1D := Dest; inc(X1D, 2);

  // Check if Src = Dst
  if Source = Dest then
  begin

    // Repeat Count times
    while Count > 0 do
    begin
      T    := X1S^;
      X1S^ := X3S^;
      X3S^ := T;

      inc(X1S, 3); inc(X3S, 3);
      dec(Count);
    end;

  end else
  begin

    // Repeat Count times
    while Count > 0 do
    begin
      X1D^ := X1S^;
      X2D^ := X2S^;
      X3D^ := X3S^;
      inc(X1S, 3); inc(X2S, 3); inc(X3S, 3);
      inc(X1D, 3); inc(X2D, 3); inc(X3D, 3);
      dec(Count);
    end;

  end;
end;

{ TsdJfifTransform }

function TsdJfifTransform.RangeLimitDescale(A: integer): integer;
begin
  Result := A div FColorConvScale;
  if Result < 0 then
    Result := 0
  else
    if Result > 255 then
      Result := 255;
end;

constructor TsdJfifTransform.Create;
begin
  inherited Create;
  FColorConvScale := 1 shl 10;
end;

function TsdJfifTransform.DstCellStride: integer;
begin
  // these are defaults, can be overridden
  Result := 3;
end;

function TsdJfifTransform.SrcCellStride: integer;
begin
  // these are defaults, can be overridden
  Result := 3;
end;

{ TsdJfifFwdTransform }

procedure TsdJfifFwdTransform.InitYCbCrTables;
{ YCbCr to RGB conversion: These constants come from JFIF spec

  R = Y                      + 1.402 (Cr-128)
  G = Y - 0.34414 (Cb-128) - 0.71414 (Cr-128)
  B = Y + 1.772 (Cb-128)

  or

  R = Y                + 1.402 Cr - 179.456
  G = Y - 0.34414 Cb - 0.71414 Cr + 135.53664
  B = Y +   1.772 Cb              - 226.816
}
var
  i: integer;
begin
  F__toR := Round(-179.456   * FColorConvScale);
  F__toG := Round( 135.53664 * FColorConvScale);
  F__toB := Round(-226.816   * FColorConvScale);
  for i := 0 to 255 do
  begin
    FY_toRT[i] := Round(  1       * FColorConvScale * i);
    FCrtoRT[i] := Round(  1.402   * FColorConvScale * i);
    FCbtoGT[i] := Round( -0.34414 * FColorConvScale * i);
    FCrtoGT[i] := Round( -0.71414 * FColorConvScale * i);
    FCbtoBT[i] := Round(  1.772   * FColorConvScale * i);
  end;
end;

constructor TsdJfifFwdTransform.Create;
begin
  inherited Create;
  InitYCbCrTables;
end;

{ TsdTransformYCbCrToRGB }

procedure TsdTransformYCbCrToBGR.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, Y, Cb, Cr: PByte;
  Yi, Ri, Gi, Bi: integer;
begin
  Y  := Source;
  Cb := Source; inc(Cb);
  Cr := Source; inc(Cr, 2);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Yi := FY_toRT[Y^];
    Ri := Yi +                FCrtoRT[Cr^] + F__toR;
    Gi := Yi + FCbToGT[Cb^] + FCrtoGT[Cr^] + F__toG;
    Bi := Yi + FCbtoBT[Cb^]                + F__toB;
    R^ := RangeLimitDescale(Ri);
    G^ := RangeLimitDescale(Gi);
    B^ := RangeLimitDescale(Bi);
    // Advance pointers
    inc(Y, 3); inc(Cb, 3); inc(Cr, 3);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

{ TsdTransformYCbCrToRGBA }

function TsdTransformYCbCrToBGRA.DstCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformYCbCrToBGRA.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, A, Y, Cb, Cr: PByte;
  Yi, Ri, Gi, Bi: integer;
begin
  Y  := Source;
  Cb := Source; inc(Cb);
  Cr := Source; inc(Cr, 2);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);
  A := Dest; inc(A, 3);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Yi := FY_toRT[Y^];
    Ri := Yi +                FCrtoRT[Cr^] + F__toR;
    Gi := Yi + FCbToGT[Cb^] + FCrtoGT[Cr^] + F__toG;
    Bi := Yi + FCbtoBT[Cb^]                + F__toB;
    R^ := RangeLimitDescale(Ri);
    G^ := RangeLimitDescale(Gi);
    B^ := RangeLimitDescale(Bi);
    A^ := $FF;
    // Advance pointers
    inc(Y, 3); inc(Cb, 3); inc(Cr, 3);
    inc(R, 4); inc(G, 4); inc(B, 4); inc(A, 4);
    dec(Count);
  end;
end;

{ TsdTransformYCbCrToGray }

function TsdTransformYCbCrToGray.DstCellStride: integer;
begin
  Result := 1;
end;

procedure TsdTransformYCbCrToGray.Transform(Source, Dest: pointer; Count: integer);
var
  G, Y: PByte;
begin
  Y  := Source;
  G := Dest;
  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    G^ := Y^;
    // Advance pointers
    inc(Y, 3);
    inc(G);
    dec(Count);
  end;
end;

{ TsdTransformYCbCrAToRGB }

function TsdTransformYCbCrAToBGR.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformYCbCrAToBGR.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, Y, Cb, Cr: PByte;
  Yi, Ri, Gi, Bi: integer;
begin
  Y  := Source;
  Cb := Source; inc(Cb);
  Cr := Source; inc(Cr, 2);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Yi := FY_toRT[Y^];
    Ri := Yi +                FCrtoRT[Cr^] + F__toR;
    Gi := Yi + FCbToGT[Cb^] + FCrtoGT[Cr^] + F__toG;
    Bi := Yi + FCbtoBT[Cb^]                + F__toB;
    R^ := RangeLimitDescale(Ri);
    G^ := RangeLimitDescale(Gi);
    B^ := RangeLimitDescale(Bi);
    // Advance pointers
    inc(Y, 4); inc(Cb, 4); inc(Cr, 4);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

{ TsdTransformYCbCrAToRGBA }

function TsdTransformYCbCrAToBGRA.DstCellStride: integer;
begin
  Result := 4;
end;

function TsdTransformYCbCrAToBGRA.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformYCbCrAToBGRA.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, A, Y, Cb, Cr, YA: PByte;
  Yi, Ri, Gi, Bi: integer;
begin
  Y  := Source;
  Cb := Source; inc(Cb);
  Cr := Source; inc(Cr, 2);
  YA := Source; inc(YA, 3);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);
  A := Dest; inc(A, 3);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Yi := FY_toRT[Y^];
    Ri := Yi +                FCrtoRT[Cr^] + F__toR;
    Gi := Yi + FCbToGT[Cb^] + FCrtoGT[Cr^] + F__toG;
    Bi := Yi + FCbtoBT[Cb^]                + F__toB;
    R^ := RangeLimitDescale(Ri);
    G^ := RangeLimitDescale(Gi);
    B^ := RangeLimitDescale(Bi);
    A^ := YA^;
    // Advance pointers
    inc(Y, 4); inc(Cb, 4); inc(Cr, 4); inc(YA, 4);
    inc(R, 4); inc(G, 4); inc(B, 4); inc(A, 4);
    dec(Count);
  end;
end;

{ TsdTransformYCbCrKToRGB }

function TsdTransformYCbCrKToBGR.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformYCbCrKToBGR.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, Y, Cb, Cr, K: PByte;
  Ci, Mi, Yi, Ki, Ii, Ri, Gi, Bi: integer;
begin
  Y  := Source;
  Cb := Source; inc(Cb);
  Cr := Source; inc(Cr, 2);
  K  := Source; inc(K, 3);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Ii := FY_toRT[Y^];

    Ci := Ii +                FCrtoRT[Cr^] + F__toR;// cyan
    Mi := Ii + FCbToGT[Cb^] + FCrtoGT[Cr^] + F__toG;// magenta
    Yi := Ii + FCbtoBT[Cb^]                + F__toB;// yellow
    Ki := 255 * FColorConvScale - FY_toRT[K^];      // black

    // In YCbCrK, the CMYK values must be converted to produce RGB
    // Do the conversion in int
    Ri := 255 * FColorConvScale - Ci - Ki;
    Gi := 255 * FColorConvScale - Mi - Ki;
    Bi := 255 * FColorConvScale - Yi - Ki;

    R^ := RangeLimitDescale(Ri);
    G^ := RangeLimitDescale(Gi);
    B^ := RangeLimitDescale(Bi);

    // Advance pointers
    inc(Y, 4); inc(Cb, 4); inc(Cr, 4); inc(K, 4);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

{ TsdTransformCMYKToRGB }

function TsdTransformCMYKToBGR.DstCellStride: integer;
begin
  Result := 3;
end;

function TsdTransformCMYKToBGR.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformCMYKToBGR.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, C, M, Y, K: PByte;
  Ri, Gi, Bi: integer;
  function RangeLimit(A: integer): integer;
  begin
    Result := A;
    if Result < 0 then
      Result := 0
    else
      if Result > 255 then
        Result := 255;
  end;
begin
  C := Source;
  M := Source; inc(M);
  Y := Source; inc(Y, 2);
  K := Source; inc(K, 3);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Ri := 255 - C^ - K^;
    Gi := 255 - M^ - K^;
    Bi := 255 - Y^ - K^;
    R^ := RangeLimit(Ri);
    G^ := RangeLimit(Gi);
    B^ := RangeLimit(Bi);
    // Advance pointers
    inc(C, 4); inc(M, 4); inc(Y, 4); inc(K, 4);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

{ TsdTransformCMYKToBGR_Adobe }

function TsdTransformCMYKToBGR_Adobe.DstCellStride: integer;
begin
  Result := 3;
end;

function TsdTransformCMYKToBGR_Adobe.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformCMYKToBGR_Adobe.Transform(Source, Dest: pointer; Count: integer);
// When all in range [0..1]
//    CMY -> CMYK                         | CMYK -> CMY
//    Black=minimum(Cyan,Magenta,Yellow)  | Cyan=minimum(1,Cyan*(1-Black)+Black)
//    Cyan=(Cyan-Black)/(1-Black)         | Magenta=minimum(1,Magenta*(1-Black)+Black)
//    Magenta=(Magenta-Black)/(1-Black)   | Yellow=minimum(1,Yellow*(1-Black)+Black)
//    Yellow=(Yellow-Black)/(1-Black)     |
//    RGB -> CMYK                         | CMYK -> RGB
//    Black=minimum(1-Red,1-Green,1-Blue) | Red=1-minimum(1,Cyan*(1-Black)+Black)
//    Cyan=(1-Red-Black)/(1-Black)        | Green=1-minimum(1,Magenta*(1-Black)+Black)
//    Magenta=(1-Green-Black)/(1-Black)   | Blue=1-minimum(1,Yellow*(1-Black)+Black)
//    Yellow=(1-Blue-Black)/(1-Black)     |
var
  R, G, B, C, M, Y, K: PByte;
  Ck, Mk, Yk, Cu, Mu, Yu, Ku: integer;
  Ri, Gi, Bi: integer;
  function RangeLimit(A: integer): integer;
  begin
    Result := A;
    if Result < 0 then
      Result := 0
    else
      if Result > 255 then
        Result := 255;
  end;
begin
  // CMYK layout
  C := Source;
  M := Source; inc(M);
  Y := Source; inc(Y, 2);
  K := Source; inc(K, 3);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Original colour channels are inverted: uninvert them here
    Ku := 255 - K^;
    Cu := 255 - C^;
    Mu := 255 - M^;
    Yu := 255 - Y^;

    // CMYK -> CMY
    Ck := (Cu * K^) div 255;
    Mk := (Mu * K^) div 255;
    Yk := (Yu * K^) div 255;

    //CMY -> RGB
    Ri := 255 - (Ck + Ku);
    Gi := 255 - (Mk + Ku);
    Bi := 255 - (Yk + Ku);

    // Range limit
    R^ := RangeLimit(Ri);
    G^ := RangeLimit(Gi);
    B^ := RangeLimit(Bi);

    // Advance pointers
    inc(C, 4); inc(M, 4); inc(Y, 4); inc(K, 4);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

{ TsdTransformYCCKToBGR }

function TsdTransformYCCKToBGR.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformYCCKToBGR.Transform(Source, Dest: pointer; Count: integer);
// YCCK is a colorspace where the CMY part of CMYK is first converted to RGB, then
// transformed to YCbCr as usual. The K part is appended without any changes.
// To transform back, we do the YCbCr -> RGB transform, then add K
var
  R, G, B, Y, Cb, Cr, K: PByte;
  Yi, Cu, Mu, Yu, Ko, Kk: integer;
  function RangeLimit(V: integer): byte;
  begin
    if V < 0 then
      Result := 0
    else
      if V > 255 then
        Result := 255
      else
        Result := V;
  end;
begin
  Y  := Source;
  Cb := Source; inc(Cb);
  Cr := Source; inc(Cr, 2);
  K  := Source; inc(K, 3);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Yi := FY_toRT[Y^];
    Ko := K^; // Inverse of K (K seems to be inverted in the file)
    Kk := (255 - Ko) * FColorConvScale; // Real K, with fixed precision

    // YCbCr converted back to CMY part of CMYK
    Cu := (Yi                + FCrtoRT[Cr^] + F__toR); //=original C of CMYK
    Mu := (Yi + FCbToGT[Cb^] + FCrtoGT[Cr^] + F__toG); //=original M of CMYK
    Yu := (Yi + FCbtoBT[Cb^]                + F__toB); //=original Y of CMYK

    // CMYK->RGB
    R^ := RangeLimitDescale(255 * FColorConvScale - (Cu * Ko) div 255 - Kk);
    G^ := RangeLimitDescale(255 * FColorConvScale - (Mu * Ko) div 255 - Kk);
    B^ := RangeLimitDescale(255 * FColorConvScale - (Yu * Ko) div 255 - Kk);

    // Advance pointers
    inc(Y, 4); inc(Cb, 4); inc(Cr, 4); inc(K, 4);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

{ TsdTransformYCCKToBGR_Adobe }

procedure TsdTransformYCCKToBGR_Adobe.InitConst;
begin
// YCCK to RGB for Adobe images is different. First, the Y, Cr and Cb are inverted,
// and k* = 220 - K. The normal YCbCr to RGB is then applied. As a last step,
// the values are scaled by 0.65 around 128
{float k = 220 - K[i], y = 255 - Y[i], cb = 255 - Cb[i], cr = 255 - Cr[i];

double val = y + 1.402 * (cr - 128) - k;
val = (val - 128) * .65f + 128;
R = val < 0.0 ? (byte) 0 : val > 255.0 ? (byte) 0xff : (byte) (val + 0.5);

val = y - 0.34414 * (cb - 128) - 0.71414 * (cr - 128) - k;
val = (val - 128) * .65f + 128;
G = val < 0.0 ? (byte) 0 : val > 255.0 ? (byte) 0xff : (byte) (val + 0.5);

val = y + 1.772 * (cb - 128) - k;
val = (val - 128) * .65f + 128;
B = val < 0.0 ? (byte) 0 : val > 255.0 ? (byte) 0xff : (byte) (val + 0.5);

X* = (X - 128) * 0.65 + 128 <=>
X* = X * 0.65 + 128 - 128 * 0.65 <=>
X* = X * 0.65 + 44.8
}
  F0_65 := round(0.65 * FColorConvScale);
  F44_8 := round(44.8 * FColorConvScale);// 128 - 0.65 * 128
end;

constructor TsdTransformYCCKToBGR_Adobe.Create;
begin
  inherited Create;
  InitConst;
end;

procedure TsdTransformYCCKToBGR_Adobe.Transform(Source, Dest: pointer;
  Count: integer);
var
  R, G, B, Y, Cb, Cr, K: PByte;
  Yi, Ki, Ri, Gi, Bi, Cbi, Cri: integer;
  function ScaleAndRangeLimit(A: integer): integer;
  begin
    // First the scaling
    A := (A * F0_65) div FColorConvScale + F44_8;
    // Undo fixed precision and range limit
    Result := A div FColorConvScale;
    if Result < 0 then
      Result := 0
    else
      if Result > 255 then
        Result := 255;
  end;
begin
  Y  := Source;
  Cb := Source; inc(Cb);
  Cr := Source; inc(Cr, 2);
  K  := Source; inc(K, 3);
  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);
  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Yi := FY_toRT[255 - Y^];
    Cbi := 255 - Cb^;
    Cri := 255 - Cr^;
    Ki := (220 - K^) * FColorConvScale;
    Ri := Yi                + FCrtoRT[Cri] + F__toR - Ki;
    Gi := Yi + FCbToGT[Cbi] + FCrtoGT[Cri] + F__toG - Ki;
    Bi := Yi + FCbtoBT[Cbi]                + F__toB - Ki;
    R^ := ScaleAndRangeLimit(Ri);
    G^ := ScaleAndRangeLimit(Gi);
    B^ := ScaleAndRangeLimit(Bi);
    // Advance pointers
    inc(Y, 4); inc(Cb, 4); inc(Cr, 4); inc(K, 4);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

function TsdTransformYCCKToBGR_Adobe.SrcCellStride: integer;
begin
  Result := 4;
end;

{ TsdTransformGrayToBGR }

function TsdTransformGrayToBGR.DstCellStride: integer;
begin
  Result := 3;
end;

function TsdTransformGrayToBGR.SrcCellStride: integer;
begin
  Result := 1;
end;

procedure TsdTransformGrayToBGR.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, Y: PByte;
begin
  Y := Source;

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    R^ := Y^;
    G^ := Y^;
    B^ := Y^;
    // Advance pointers
    inc(Y, 1);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

{ TsdTransformGrayAToBGR }

function TsdTransformGrayAToBGR.DstCellStride: integer;
begin
  Result := 3;
end;

function TsdTransformGrayAToBGR.SrcCellStride: integer;
begin
  Result := 2;
end;

procedure TsdTransformGrayAToBGR.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, Y: PByte;
begin
  Y := Source;

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    R^ := Y^;
    G^ := Y^;
    B^ := Y^;
    // Advance pointers
    inc(Y, 2);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

{ TsdTransformGrayAToBGRA }

function TsdTransformGrayAToBGRA.DstCellStride: integer;
begin
  Result := 4;
end;

function TsdTransformGrayAToBGRA.SrcCellStride: integer;
begin
  Result := 2;
end;

procedure TsdTransformGrayAToBGRA.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, A, Y, YA: PByte;
begin
  Y := Source;
  YA := Source; inc(YA);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);
  A := Dest; inc(A, 3);

  // Repeat Count times..
  while Count > 0 do
  begin
    R^ := Y^;
    G^ := Y^;
    B^ := Y^;
    A^ := YA^;
    // Advance pointers
    inc(Y, 2); inc(Ya, 2);
    inc(R, 4); inc(G, 4); inc(B, 4); inc(A, 4);
    dec(Count);
  end;
end;

{ TsdTransformRGBToBGRA }

function TsdTransformRGBToBGRA.DstCellStride: integer;
begin
  Result := 4;
end;

function TsdTransformRGBToBGRA.SrcCellStride: integer;
begin
  Result := 3;
end;

procedure TsdTransformRGBToBGRA.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, A, Rs, Gs, Bs: PByte;
begin
  Rs := Source;
  Gs := Source; inc(Gs);
  Bs := Source; inc(Bs, 2);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);
  A := Dest; inc(A, 3);

  // Repeat Count times..
  while Count > 0 do
  begin
    R^ := Rs^;
    G^ := Gs^;
    B^ := Bs^;
    A^ := $FF;
    // Advance pointers
    inc(Rs, 3); inc(Gs, 3); inc(Bs, 3);
    inc(R, 4); inc(G, 4); inc(B, 4); inc(A, 4);
    dec(Count);
  end;
end;

{ TsdTransformRGBAToBGR }

function TsdTransformRGBAToBGR.DstCellStride: integer;
begin
  Result := 3;
end;

function TsdTransformRGBAToBGR.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformRGBAToBGR.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, Rs, Gs, Bs: PByte;
begin
  Rs := Source;
  Gs := Source; inc(Gs);
  Bs := Source; inc(Bs, 2);

  // RGB is layed out in memory as BGR
  B := Dest;
  G := Dest; inc(G);
  R := Dest; inc(R, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    R^ := Rs^;
    G^ := Gs^;
    B^ := Bs^;
    // Advance pointers
    inc(Rs, 4); inc(Gs, 4); inc(Bs, 4);
    inc(R, 3); inc(G, 3); inc(B, 3);
    dec(Count);
  end;
end;

constructor TsdTransformBGRAToBGR.Create;
begin
  inherited;
  FBkColor := $FFFFFFFF;
end;

function TsdTransformBGRAToBGR.GetBkColor: cardinal;
begin
  Result := FBkColor and $00FFFFFF;
end;

procedure TsdTransformBGRAToBGR.SetBkColor(const Value: cardinal);
begin
  FBkColor := Value or $FF000000;
end;

procedure TsdTransformBGRAToBGR.Transform(Source, Dest: pointer; Count: integer);
var
  t: integer;
  R, G, B, A, Rd, Gd, Bd: PByte;
  Rb, Gb, Bb: byte;
begin
  // ARGB source is layed out in memory as BGRA
  B := Source;
  G := Source; inc(G);
  R := Source; inc(R, 2);
  A := Source; inc(A, 3);

  // RGB dest is layed out in memory as BGR
  Bd := Dest;
  Gd := Dest; inc(Gd);
  Rd := Dest; inc(Rd, 2);

  // Background colors
  Rb :=  FBkColor and $000000FF;
  Gb := (FBkColor and $0000FF00) shr 8;
  Bb := (FBkColor and $00FF0000) shr 16;

  // Repeat Count times..
  while Count > 0 do
  begin
    if A^ = 0 then
    begin

      // Fully transparent: background color
      Rd^ := Rb;
      Gd^ := Gb;
      Bd^ := Bb;

    end else
    begin
      if A^ = 255 then
      begin

        // Fully opaque: foreground color
        Rd^ := R^;
        Gd^ := G^;
        Bd^ := B^;

      end else
      begin

        // Semi-transparent: "Src over Dst" operator (Porter-Duff),
        // for pre-multiplied colors, unrolled for speed

        t := A^ * Rb + $80;
        Rd^ := R^ + Rb - (t shr 8 + t) shr 8;

        t := A^ * Gb + $80;
        Gd^ := G^ + Gb - (t shr 8 + t) shr 8;

        t := A^ * Bb + $80;
        Bd^ := B^ + Bb - (t shr 8 + t) shr 8;

      end;
    end;

    // Advance pointers
    inc(R, 4); inc(G, 4); inc(B, 4); inc(A, 4);
    inc(Rd, 3); inc(Gd, 3); inc(Bd, 3);
    dec(Count);
  end;
end;


function TsdTransformBGRAToBGR.DstCellStride: integer;
begin
  Result := 3;
end;

function TsdTransformBGRAToBGR.SrcCellStride: integer;
begin
  Result := 4;
end;

{ TsdJfifInvTransform }

procedure TsdJfifInvTransform.InitRGBToYCbCrTables;
{  RGB to YCbCr conversion: These constants come from JFIF spec

  Y =    0.299  R + 0.587  G + 0.114  B
  Cb = - 0.1687 R - 0.3313 G + 0.5    B + 128
  Cr =   0.5    R - 0.4187 G - 0.0813 B + 128
}
var
  i: integer;
begin
  F__toCb := Round(128 * FColorConvScale);
  F__toCr := Round(128 * FColorConvScale);
  for i := 0 to 255 do
  begin
    FRtoY_[i] := Round( 0.299  * FColorConvScale * i);
    FGtoY_[i] := Round( 0.587  * FColorConvScale * i);
    FBtoY_[i] := Round( 0.114  * FColorConvScale * i);
    FRtoCb[i] := Round(-0.1687 * FColorConvScale * i);
    FGtoCb[i] := Round(-0.3313 * FColorConvScale * i);
    FBtoCb[i] := Round( 0.5    * FColorConvScale * i);
    FRtoCr[i] := Round( 0.5    * FColorConvScale * i);
    FGtoCr[i] := Round(-0.4187 * FColorConvScale * i);
    FBtoCr[i] := Round(-0.0813 * FColorConvScale * i);
  end;
end;

constructor TsdJfifInvTransform.Create;
begin
  inherited Create;
  InitRGBToYCbCrTables;
end;

{ TsdTransformBGRToYCbCr }

procedure TsdTransformBGRToYCbCr.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, Y, Cb, Cr: PByte;
  Ri, Gi, Bi: integer;
begin
  //DoDebugOut(Self, wsInfo, Format('source=%d, count=%d, nulling...(test)', [integer(Source), Count]));
  // RGB is layed out in memory as BGR
  B := Source;
  G := Source; inc(G);
  R := Source; inc(R, 2);

  Y  := Dest;
  Cb := Dest; inc(Cb);
  Cr := Dest; inc(Cr, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Ri := R^;
    Gi := G^;
    Bi := B^;
    Y^  := RangeLimitDescale(FRtoY_[Ri] + FGtoY_[Gi] + FBtoY_[Bi]          );
    Cb^ := RangeLimitDescale(FRtoCb[Ri] + FGtoCb[Gi] + FBtoCb[Bi] + F__toCb);
    Cr^ := RangeLimitDescale(FRtoCr[Ri] + FGtoCr[Gi] + FBtoCr[Bi] + F__toCr);
    // Advance pointers
    inc(R, 3); inc(G, 3); inc(B, 3);
    inc(Y, 3); inc(Cb, 3); inc(Cr, 3);
    dec(Count);
  end;
end;

{ TsdTransformBGRToGray }

function TsdTransformBGRToGray.DstCellStride: integer;
begin
  Result := 1;
end;

procedure TsdTransformBGRToGray.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, Y: PByte;
begin
  // RGB is layed out in memory as BGR
  B := Source;
  G := Source; inc(G);
  R := Source; inc(R, 2);

  Y  := Dest;
  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Y^  := RangeLimitDescale(FRtoY_[R^] + FGtoY_[G^] + FBtoY_[B^]);
    // Advance pointers
    inc(R, 3); inc(G, 3); inc(B, 3);
    inc(Y, 1);
    dec(Count);
  end;
end;

{ TsdTransformBGRAToYCbCrA }

function TsdTransformBGRAToYCbCrA.DstCellStride: integer;
begin
  Result := 4;
end;

function TsdTransformBGRAToYCbCrA.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformBGRAToYCbCrA.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, A, Y, Cb, Cr, Ay: PByte;
  Ri, Gi, Bi: integer;
begin
  // RGB is layed out in memory as BGR
  B := Source;
  G := Source; inc(G);
  R := Source; inc(R, 2);
  A := Source; inc(A, 3);

  Y  := Dest;
  Cb := Dest; inc(Cb);
  Cr := Dest; inc(Cr, 2);
  Ay := Dest; inc(Ay, 3);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Ri := R^;
    Gi := G^;
    Bi := B^;
    Y^  := RangeLimitDescale(FRtoY_[Ri] + FGtoY_[Gi] + FBtoY_[Bi]          );
    Cb^ := RangeLimitDescale(FRtoCb[Ri] + FGtoCb[Gi] + FBtoCb[Bi] + F__toCb);
    Cr^ := RangeLimitDescale(FRtoCr[Ri] + FGtoCr[Gi] + FBtoCr[Bi] + F__toCr);
    Ay^ := A^;
    // Advance pointers
    inc(R, 4); inc(G, 4); inc(B, 4); inc(A, 4);
    inc(Y, 4); inc(Cb, 4); inc(Cr, 4); inc(Ay, 4);
    dec(Count);
  end;
end;

{ TsdTransformBGRAToYCbCr }

function TsdTransformBGRAToYCbCr.SrcCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformBGRAToYCbCr.Transform(Source, Dest: pointer; Count: integer);
var
  R, G, B, Y, Cb, Cr: PByte;
  Ri, Gi, Bi: integer;
begin
  // RGB is layed out in memory as BGR
  B := Source;
  G := Source; inc(G);
  R := Source; inc(R, 2);

  Y  := Dest;
  Cb := Dest; inc(Cb);
  Cr := Dest; inc(Cr, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    // Do the conversion in int
    Ri := R^;
    Gi := G^;
    Bi := B^;
    Y^  := RangeLimitDescale(FRtoY_[Ri] + FGtoY_[Gi] + FBtoY_[Bi]          );
    Cb^ := RangeLimitDescale(FRtoCb[Ri] + FGtoCb[Gi] + FBtoCb[Bi] + F__toCb);
    Cr^ := RangeLimitDescale(FRtoCr[Ri] + FGtoCr[Gi] + FBtoCr[Bi] + F__toCr);
    // Advance pointers
    inc(R, 4); inc(G, 4); inc(B, 4);
    inc(Y, 3); inc(Cb, 3); inc(Cr, 3);
    dec(Count);
  end;
end;

{ TsdTransformCIELabToBGR }

constructor TsdTransformCIELabToBGR.Create;
begin
  inherited;
  // White point: Defaults to D65 (as recommended by CCIR XA/11)
  FXw := 0.9505;
  FYw := 1.0;
  FZw := 1.0890;
  // Range
  FAmin := -100;
  FAmax :=  100;
  FBmin := -100;
  FBmax :=  100;
  // Offset
  FAofs := 128;
  FBofs := 128;
end;

procedure TsdTransformCIELabToBGR.Transform(Source, Dest: pointer;
  Count: integer);
var
  Lb, Ab, Bb: PByte;
  Ld, Ad, Bd, L, M, N, X, Y, Z, R, G, B: double;
  Rf, Gf, Bf: PByte;
  // Limit to interval [0..1]
  function Limit(X: double): double;
  begin
    Result := X;
    if Result < 0 then
      Result := 0
    else if Result > 1 then
      Result := 1;
  end;
  function RangeLimitDescale(X: double): integer;
  begin
    Result := round(X * 255);
    if Result < 0 then
      Result := 0
    else if Result > 255 then
      Result := 255;
  end;
  function GFunc(X: double): double;
  // See PDF spec, section 4.5
  begin
    if X >= 6/29 then
      Result := X * X * X
    else
      Result := (108/841) * (X - (4/29));
  end;
  // sRGB gamma function
  function Gamma(X: double): double;
  begin
    if X < 0.0031308 then
      Result := 12.92 * X
    else
      Result := 1.055 * Power(X, 1.0/2.4) - 0.055;
  end;
begin
  // CIE Lab
  Lb := Source;
  Ab := Source; inc(Ab);
  Bb := Source; inc(Bb, 2);

  // RGB is layed out in memory as BGR
  Bf := Dest;
  Gf := Dest; inc(Gf);
  Rf := Dest; inc(Rf, 2);

  // Repeat Count times..
  while Count > 0 do
  begin
    // First stage: adjust range
    Ld := Lb^ * (100/255);

    Ad := Ab^ - FAofs;
{    if Ad < FAmin then
      Ad := FAmin
    else
      if Ad > FAmax then
        Ad := FAmax;}

    Bd := Bb^ - FBofs;
{    if Bd < FBmin then
      Bd := FBmin
    else
      if Bd > FBmax then
        Bd := FBmax;}

    // Second stage: calculate LMN
    L := (Ld + 16) / 116 + Ad / 500;
    M := (Ld + 16) / 116;
    N := (Ld + 16) / 116 - Bd / 200;

    // Third stage: calculate XYZ
    X := FXw * GFunc(L);
    Y := FYw * GFunc(M);
    Z := FZw * GFunc(N);
{   X := Limit(X);
    Y := Limit(Y);
    Z := Limit(Z);}

    // Fourth stage: calculate sRGB:
    // XYZ to RGB matrix for sRGB, D65.. see
    // http://www.brucelindbloom.com/index.html?ColorCalculator.html

    R :=  3.24071   * X +  -1.53726  * Y + -0.498571  * Z;
    G := -0.969258  * X +   1.87599  * Y +  0.0415557 * Z;
    B :=  0.0556352 * X +  -0.203996 * Y +  1.05707   * Z;

    // Correct to sRGB
    R := Gamma(R);
    G := Gamma(G);
    B := Gamma(B);

    // Final stage: convert to RGB and limit
    Rf^ := RangeLimitDescale(R);
    Gf^ := RangeLimitDescale(G);
    Bf^ := RangeLimitDescale(B);

    // Advance pointers
    inc(Lb, 3); inc(Ab, 3); inc(Bb, 3);
    inc(Rf, 3); inc(Gf, 3); inc(Bf, 3);
    dec(Count);
  end;
end;

{ TsdTransformITUCIELabToBGR }

constructor TsdTransformITUCIELabToBGR.Create;
begin
  inherited;
  // Range
{  FAmin := -21760/255;
  FAmax :=  21590/255;
  FBmin := -19200/255;
  FBmax :=  31800/255;}
  // Offset
  FAofs := 128;
  FBofs :=  96;
end;

{ TsdYuvTransform }

function TsdYuvTransform.Clip(AValue: integer): integer;
// Clip the value to the allowed range
begin
  if AValue < 0 then
    Result := 0
  else
    if AValue >= FMaxValue then
      Result := FMaxValue
    else
      Result := AValue;
end;

constructor TsdYuvTransform.Create;
begin
  inherited;
  InitScaleFact;
end;

function TsdYuvTransform.DstCellStride: integer;
begin
  Result := 3;
end;

procedure TsdYuvTransform.InitScaleFact;
begin
  FPrecision := 10;
  FScaleFact := 1 shl FPrecision;
  FBias := (FPrecision - 1);
  FMaxValue := $FF * FScaleFact;
end;

function TsdYuvTransform.SrcCellStride: integer;
begin
  Result := 3;
end;

{ TsdYuvFwdTransform }

constructor TsdYuvFwdTransform.Create;
begin
  inherited;
  InitTables;
end;

procedure TsdYuvFwdTransform.InitTables;
{ Formulae:

  Y =  0.257R + 0.504G + 0.098B + 16
  U = -0.148R - 0.291G + 0.439B + 128
  V =  0.439R - 0.368G - 0.071B + 128

  G = 1.164(Y-16) - 0.391(U-128) -0.813(V-128)
  R = 1.164(Y-16) +               1.596(V-128)
  B = 1.164(Y-16) + 2.018(U-128)

  or

  R = 1.164Y           + 1.596Cr - 222.912
  G = 1.164Y - 0.391Cb - 0.813Cr + 135.488
  B = 1.164Y + 2.018Cb           - 276.928

  R, G and B range from 0 to 255.
  Y ranges from 16 to 235.
  Cb and Cr range from 16 to 240.

  These values are NOT the ones of the JFIF spec
}
var
  i: integer;
begin
  // Conversion tables
  for i := 0 to 255 do
  begin
    // YUV to RGB
    FYtoR[i] := round(( 1.164 * i - 222.912) * FScaleFact);
    FYtoG[i] := round(( 1.164 * i + 135.488) * FScaleFact);
    FYtoB[i] := round(( 1.164 * i - 276.928) * FScaleFact);
    FUtoG[i] := round( -0.391 * i * FScaleFact);
    FUtoB[i] := round(  2.018 * i * FScaleFact);
    FVtoR[i] := round(  1.596 * i * FScaleFact);
    FVtoG[i] := round( -0.813 * i * FScaleFact);
  end;
end;

{ TsdYuvInvTransform }

constructor TsdYuvInvTransform.Create;
begin
  inherited;
  initTables;
end;

procedure TsdYuvInvTransform.InitTables;
var
  i: integer;
begin
  for i := 0 to 255 do
  begin
    // RGB to YUV
    FYfromR[i] := round(( 0.257 * i + 16 ) * FScaleFact);
    FUfromR[i] := round((-0.148 * i + 128) * FScaleFact);
    FVfromR[i] := round(( 0.439 * i + 128) * FScaleFact);
    FYfromG[i] := round(  0.504 * i * FScaleFact);
    FUfromG[i] := round( -0.291 * i * FScaleFact);
    FVfromG[i] := round( -0.368 * i * FScaleFact);
    FYfromB[i] := round(  0.098 * i * FScaleFact);
    FUfromB[i] := round(  0.439 * i * FScaleFact);
    FVfromB[i] := round( -0.071 * i * FScaleFact);
  end;
end;

{ TsdTransformYUVToRGB }

procedure TsdTransformYUVToRGB.Transform(Source, Dest: pointer;
  Count: integer);
// Convert a list of count colors in 8bpc from YUV to RGB
var
  i: integer;
  Ri, Gi, Bi: integer;
  R, G, B, Y, U, V: PByte;
begin
  // Setup pointers
  Y := Source;
  U := Y; inc(U);
  V := U; inc(V);
  R := Dest;
  G := R; inc(G);
  B := G; inc(B);
  // Loop through list
  for i := 0 to Count - 1 do
  begin
    Ri := Clip(FYtoR[Y^]             + FVtoR[V^] + FBias);
    Gi := Clip(FYtoG[Y^] + FUtoG[U^] + FVtoG[V^] + FBias);
    Bi := Clip(FYtoB[Y^] + FUtoB[U^]             + FBias);
    R^ := Ri shr FPrecision;
    G^ := Gi shr FPrecision;
    B^ := Bi shr FPrecision;
    inc(Y, 3); inc(U, 3); inc(V, 3);
    inc(R, 3); inc(G, 3); inc(B, 3);
  end;
end;

{ TsdTransformYUVToCMYK }

function TsdTransformYUVToCMYK.DstCellStride: integer;
begin
  Result := 4;
end;

procedure TsdTransformYUVToCMYK.Transform(Source, Dest: pointer;
  Count: integer);
var
  i: integer;
  Ri, Gi, Bi: integer;
  C, M, L, Y, U, V: PByte;
begin
  // Setup pointers
  Y := Source;
  U := Y; inc(U);
  V := U; inc(V);
  C := Dest;
  M := C; inc(M);
  L := M; inc(L);
  // Loop through list
  for i := 0 to Count - 1 do
  begin
    Ri := Clip(FYtoR[Y^]             + FVtoR[V^] + FBias);
    Gi := Clip(FYtoG[Y^] + FUtoG[U^] + FVtoG[V^] + FBias);
    Bi := Clip(FYtoB[Y^] + FUtoB[U^]             + FBias);
    C^ := Ri shr FPrecision xor $FF; // Cyan    = 255 - Red
    M^ := Gi shr FPrecision xor $FF; // Magenta = 255 - Green
    L^ := Bi shr FPrecision xor $FF; // Yellow  = 255 - Blue
    // We leave the K channel untouched
    inc(Y, 4); inc(U, 4); inc(V, 4);
    inc(C, 4); inc(M, 4); inc(L, 4);
  end;
end;

{ TsdTransformRGBToYUV }

procedure TsdTransformRGBToYUV.Transform(Source, Dest: pointer;
  Count: integer);
// Convert a list of count colors in 8bpc from RGB to YUV
var
  i: integer;
  Yi, Ui, Vi: integer;
  R, G, B, Y, U, V: PByte;
begin
  // Setup pointers
  R := Source;
  G := R; inc(G);
  B := G; inc(B);
  Y := Dest;
  U := Y; inc(U);
  V := U; inc(V);
  // loop through list
  for i := 0 to Count - 1 do
  begin
    Yi := Clip(FYfromR[R^] + FYfromG[G^] + FYfromB[B^] + FBias);
    Ui := Clip(FUfromR[R^] + FUfromG[G^] + FUfromB[B^] + FBias);
    Vi := Clip(FVfromR[R^] + FVfromG[G^] + FVfromB[B^] + FBias);
    Y^ := Yi shr FPrecision;
    U^ := Ui shr FPrecision;
    V^ := Vi shr FPrecision;
    inc(R, 3); inc(G, 3); inc(B, 3);
    inc(Y, 3); inc(U, 3); inc(V, 3);
  end;
end;

initialization

end.

{
  Unit dtpColorEffects

  Implements a number of color conversion effects.. 

  Brightness and Contrast

  These are calculated using this formula:
  new = ( (old - half) * Contrast + half ) + Brightness

  Hue/Saturation/Lightness adjust

  These are converted back/forth with the formula from dtpGraphics.
  Project: DTP-Engine

  Creation Date: 22-08-2003 (NH)

  Modifications:
  08Oct2005: Added TdtpSepiaEffect

  Copyright (c) 2003-2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpColorEffects;

{$i simdesign.inc}

interface

uses
  ExtCtrls, StdCtrls, ComCtrls, dtpShape, dtpEffectShape, dtpDefaults,
  dtpGraphics, Math, NativeXmlOld;

type
  TLut8 = array[0..255] of byte;
  THistogram = array[0..255] of integer;

  // TdtpColorLUTEffect implements a color "LUT" = Look Up Table conversion
  // effect. It can be used as basis for Brightness/Contrast, Gamma correction,
  // and "Levels" diagrams. R, G and B channels can be LUT'ed separately
  TdtpColorLUTEffect = class(TdtpEffect)
  private
    FRLut: TLut8;
    FGLut: TLut8;
    FBLut: TLut8;
  protected
    procedure PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext); override;
  public
    constructor Create; override;
  end;

  // TdtpBrightContrEffect implements Brightness/Contrast correction
  TdtpBrightContrEffect = class(TdtpColorLUTEffect)
  private
    FBrightness: single;
    FContrast: single;
    procedure SetBrightness(const Value: single);
    procedure SetContrast(const Value: single);
  protected
    procedure Update; override;
  public
    constructor Create; override;
    class function EffectName: string; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property Brightness: single read FBrightness write SetBrightness;
    property Contrast: single read FContrast write SetContrast;
  end;

  // To do: create gamma correction
  TdtpGammaCorrectEffect = class(TdtpColorLUTEffect)
  private
    FGamma: single;
  public
    property Gamma: single read FGamma write FGamma;
  end;

  // TdtpColorFunctionEffect serves as ancestor for effects that want to process
  // individual pixel colors. Example: Hue/Saturation/Lightness adjust.
  TdtpColorFunctionEffect = class(TdtpEffect)
  protected
    procedure Transform(var C: TdtpColor); virtual;
    procedure PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext); override;
  end;

  // TdtpHSLAdjustEffect implements adjustment of the Hue, Saturation and Lightness
  // of the colors in the shape.
  TdtpHSLAdjustEffect = class(TdtpColorFunctionEffect)
  private
    FHue: single;
    FLightness: single;
    FSaturation: single;
    procedure SetHue(const Value: single);
    procedure SetLightness(const Value: single);
    procedure SetSaturation(const Value: single);
  protected
    procedure Transform(var C: TdtpColor); override;
  public
    class function EffectName: string; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property Hue: single read FHue write SetHue;
    property Saturation: single read FSaturation write SetSaturation;
    property Lightness: single read FLightness write SetLightness;
  end;

  TdtpSepiaEffect = class(TdtpColorFunctionEffect)
  private
    FDepth: integer;
    procedure SetDepth(const Value: integer);
  protected
    procedure Transform(var C: TdtpColor); override;
  public
    constructor Create; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property Depth: integer read FDepth write SetDepth;
  end;

// Call AutoLevelShape to add or replace the brightness/contrast effect of the shape
// with one that is calculated based on AutoLevels: the histogram of the shape is
// analysed, and an ideal brightness and gamma value is calculated to stretch the
// histogram optimally.
procedure AutoLevelShape(AShape: TdtpEffectShape);

procedure CalculateAutoLevelsFromHistogram(const Histogram: THistogram;
  var Brightness, Contrast: single);

var
  FIdentityLut: TLut8;

implementation

procedure CalcIdentityLut;
var
  i: integer;
begin
  for i := 0 to 255 do
    FIdentityLut[i] := i;
end;

type
  PByte = ^Byte;

procedure GetPreservingGrayscaleHistogram(Bitmap: TdtpBitmap; var Histo: THistogram);
// Get a grayscale histogram of the bitmap. It is called a preserving histogram
// because it doesn't first calculate grayscale and then fills the histogram, but
// it directly adds each RGB component with weighting in the bins. This ensures
// that some high/low value component colors are present, even though the grayscale
// of these RGB colors could be closer to the center of the histogram.
var
  i: integer;
  P: PByte;
begin
  // Check
  if not assigned(Bitmap) then
    exit;
  // initialize
  P := @Bitmap.Bits[0];
  FillChar(Histo,  SizeOf(THistogram), 0);

  // count colors
  // (R * 61 + G * 174 + B * 21) / 256
  for i := 0 to Bitmap.Width * Bitmap.Height - 1 do
  begin
    Inc(Histo[P^],  21); inc(P);
    inc(Histo[P^], 174); inc(P);
    inc(Histo[P^],  61); inc(P);
    inc(P); // skip alpha
  end;
  for i := 0 to 255 do
    Histo[i] := Histo[i] shr 8;
end;

procedure AutoLevelShape(AShape: TdtpEffectShape);
var
  Effect: TdtpBrightContrEffect;
  Bitmap: TdtpBitmap;
  Histo: THistogram;
  Brightness, Contrast: single;
begin
  if not assigned(AShape) then
    exit;

  // Start by removing all brightness/contrast effects
  repeat
    Effect := TdtpBrightContrEffect(AShape.EffectByClass(TdtpBrightContrEffect));
    if assigned(Effect) then
      AShape.EffectRemove(Effect)
    else
      break;
  until False;

  // Create a bitmap of the shape for analysis
  Bitmap := TdtpBitmap.Create;
  try
    Bitmap := AShape.ExportToBitmap(round(AShape.DocWidth * 2), round(AShape.DocHeight * 2));
    GetPreservingGrayscaleHistogram(Bitmap, Histo);
  finally
    Bitmap.Free;
  end;

  // Now that we have the histogram, calculate optimum brightness/contrast
  CalculateAutoLevelsFromHistogram(Histo, Brightness, Contrast);

  // And add a new effect to the shape
  Effect := TdtpBrightContrEffect.Create;
  Effect.Brightness := Brightness;
  Effect.Contrast := Contrast;
  AShape.EffectInsert(0, Effect);

end;

procedure CalculateAutoLevelsFromHistogram(const Histogram: THistogram;
  var Brightness, Contrast: single);
var
  i, iLow: integer;
  Total, Prev: int64;
  LLim, HLim, LPos, HPos: double;
  LPercent, HPercent, LIdeal, HIdeal: double;
begin
  LPercent := 0.02;
  HPercent := 0.98;
  LIdeal := 0.02;
  HIdeal := 0.98;
  LPos := 0;
  HPos := 255;

  // Count values in histogram
  Total := 0;
  for i := 0 to 255 do inc(Total, Histogram[i]);

  // Low/High limit
  LLim := Total * LPercent;
  HLim := Total * HPercent;

  // Determine low and high percentiles
  Total := 0; Prev := 0;
  iLow := 0;
  for i := 0 to 255 do
  begin
    inc(Total, Histogram[i]);
    if (Total >= LLim) and (Prev <= LLim) and not (Total = Prev) then
      LPos := iLow + (i - iLow) * (LLim - Prev)/(Total - Prev);
    if (Total >= HLim) and (Prev <= HLim) and not (Total = Prev) then
      HPos := iLow + (i - iLow) * (HLim - Prev)/(Total - Prev);
    if Prev < Total then
    begin
      iLow := i;
      Prev := Total;
    end;
  end;

  // Don't overreact, just 85% shift instead of 100%
  HIdeal := HIdeal + 0.15 * (HPos/255 - HIdeal);
  LIdeal := LIdeal + 0.15 * (LPos/255 - LIdeal);

  // Contrast
  Contrast := (HIdeal - LIdeal) * 255 / (HPos - LPos);
  // Brightness
  Brightness := HIdeal * 255 - (127 + (HPos - 127) * Contrast);
end;

{ TdtpColorEffect }

constructor TdtpColorLUTEffect.Create;
begin
  inherited;
  FRLut := FIdentityLut;
  FGLut := FIdentityLut;
  FBLut := FIdentityLut;
end;

procedure TdtpColorLUTEffect.PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext);
var
  i: integer;
  P: PdtpColor;
  R, G, B: TdtpColor;
begin
  P := @DIB.Bits[0];
  for i := 0 to DIB.Width * DIB.Height - 1 do
  begin
    // Loop through all pixels
    if P^ and $FF000000 > 0 then
    begin
      // Do color LUT only for Alpha > 0
      R := P^ and $00FF0000;
      G := P^ and $0000FF00;
      R := R shr 16;
      B := P^ and $000000FF;
      G := G shr 8;
      R := FRLut[R];
      G := FGLut[G];
      B := FBLut[B];
      P^ := P^ and $FF000000 or R shl 16 or G shl 8 or B;
    end;
    inc(P);
  end;
end;

{ TdtpBrightContrEffect }

constructor TdtpBrightContrEffect.Create;
begin
  inherited;
  FBrightness := 0.0;
  FContrast   := 1.0;
end;

class function TdtpBrightContrEffect.EffectName: string;
begin
  Result := 'Brightness/Contrast';
end;

procedure TdtpBrightContrEffect.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FBrightness := ANode.ReadFloat('Brightness');
  FContrast   := ANode.ReadFloat('Contrast');
end;

procedure TdtpBrightContrEffect.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteFloat('Brightness', FBrightness);
  ANode.WriteFloat('Contrast',   FContrast);
end;

procedure TdtpBrightContrEffect.SetBrightness(const Value: single);
begin
  if FBrightness <> Value then
  begin
    FBrightness := Value;
    Changed;
  end;
end;

procedure TdtpBrightContrEffect.SetContrast(const Value: single);
begin
  if FContrast <> Value then begin
    FContrast := Value;
    Changed;
  end;
end;

procedure TdtpBrightContrEffect.Update;
// Here we calculate the new LUT based on brightness and contrast settings
var
  i: integer;
begin
  for i := 0 to 255 do
    // Formula for Brightness/Contrast
    FRLut[i] := Max(0, Min(255,
      round((i - 127) * FContrast + 127 + FBrightness)));
  // Copy to G and B
  FGLut := FRLut;
  FBLut := FRLut;
end;

{ TdtpColorFunctionEffect }

procedure TdtpColorFunctionEffect.Transform(var C: TdtpColor);
begin
// Default does nothing
end;

procedure TdtpColorFunctionEffect.PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext);
var
  i: integer;
  P: PdtpColor;
begin
  P := @DIB.Bits[0];
  for i := 0 to DIB.Width * DIB.Height - 1 do
  begin
    // Loop through all pixels
    if P^ and $FF000000 > 0 then
      // Do color transform only for Alpha > 0
      Transform(P^);
    inc(P);
  end;
end;

{ TdtpHSLAdjustEffect }

class function TdtpHSLAdjustEffect.EffectName: string;
begin
  Result := 'HSL Adjustment';
end;

procedure TdtpHSLAdjustEffect.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FHue        := ANode.ReadFloat('Hue');
  FSaturation := ANode.ReadFloat('Saturation');
  FLightness  := ANode.ReadFloat('Lightness');
end;

procedure TdtpHSLAdjustEffect.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteFloat('Hue',        FHue);
  ANode.WriteFloat('Saturation', FSaturation);
  ANode.WriteFloat('Lightness',  FLightness);
end;

procedure TdtpHSLAdjustEffect.SetHue(const Value: single);
begin
  if FHue <> Value then
  begin
    FHue := Value;
    Changed;
  end;
end;

procedure TdtpHSLAdjustEffect.SetLightness(const Value: single);
begin
  if FLightness <> Value then
  begin
    FLightness := Value;
    Changed;
  end;
end;

procedure TdtpHSLAdjustEffect.SetSaturation(const Value: single);
begin
  if FSaturation <> Value then
  begin
    FSaturation := Value;
    Changed;
  end;
end;

procedure TdtpHSLAdjustEffect.Transform(var C: TdtpColor);
var
  H, S, L: single;
begin
  // Convert to HSL
  RGBToHSL(C, H, S, L);
  // Adjust hue
  H := H + FHue;
  // Limit hue to [0, 1], but do a wrap-around
  while H > 1 do
    H := H - 1;
  while H < 0 do
    H := H + 1;
  // Adjust and limit saturation and lightness, also [0, 1]
  S := Min(1, Max(0, S + FSaturation));
  L := Min(1, Max(0, L + FLightness));
  // Convert back, preserve Alpha
  C := (C and $FF000000) or (HSLToRGB(H, S, L) and $00FFFFFF);
end;

{ TdtpSepiaEffect }

constructor TdtpSepiaEffect.Create;
begin
  inherited;
  FDepth := cDefaultSepiaEffectDepth;
end;

procedure TdtpSepiaEffect.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FDepth := ANode.ReadInteger('Depth');
end;

procedure TdtpSepiaEffect.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteInteger('Depth', FDepth);
end;

procedure TdtpSepiaEffect.SetDepth(const Value: integer);
begin
  if FDepth <> Value then
  begin
    FDepth := Value;
    Changed;
  end;
end;

procedure TdtpSepiaEffect.Transform(var C: TdtpColor);
var
  Gray, R, G: byte;
begin
  // Determine intensity
  Gray := (
    (C and $00FF0000) shr 16 * 61 +
    (C and $0000FF00) shr 8 * 174 +
    (C and $000000FF) * 21
    ) shr 8;

  // Convert to sepia teint
  R := Min($FF, Gray + FDepth * 2);
  G := Min($FF, Gray + FDepth);
  C := (C and $FF000000) + R shl 16 + G shl 8 + Gray;
end;

initialization

  CalcIdentityLut;
  RegisterEffectClass(TdtpBrightContrEffect);
  RegisterEffectClass(TdtpHSLAdjustEffect);
  RegisterEffectClass(TdtpSepiaEffect);

end.

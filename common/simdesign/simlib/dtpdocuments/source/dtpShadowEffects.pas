{  Unit dtpShadowEffects

  Implements the shadow effect.

  Project: DTP-Engine

  Creation Date: 22-Aug-2003

  Modifications:

  Copyright (c) 2003-2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpShadowEffects;

{$i simdesign.inc}

interface

uses
  SysUtils, dtpShape, dtpEffectShape, Graphics, dtpGraphics, Math, dtpUtil,
  NativeXmlOld, dtpDefaults;

type

  // TdtpShadowEffect is an effect that adds a shadow to the image in the cache.
  // This is done by taking the alpha channel of the image and then blurring it
  // and giving it an offset, followed by putting the alpha channel back to the
  // visible shadow color and merging original and shadow image.
  TdtpShadowEffect = class(TdtpEffect)
  private
    FDeltaX: single;
    FDeltaY: single;
    FIntensity: single;
    FBlur: single;
    FColor: TColor;
    procedure SetBlur(const Value: single);
    procedure SetColor(const Value: TColor);
    procedure SetDeltaX(const Value: single);
    procedure SetDeltaY(const Value: single);
    procedure SetIntensity(const Value: single);
  protected
    procedure PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext); override;
    procedure SetPropertyByName(const AName, AValue: string); override;
    procedure ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single); override;
  public
    constructor Create; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    // DeltaX is the horizontal displacement of the shadow relative to the object
    // in mm.
    property DeltaX: single read FDeltaX write SetDeltaX;
    // DeltaY is the vertical displacement of the shadow relative to the object
    // in mm.
    property DeltaY: single read FDeltaY write SetDeltaY;
    // Blur indicates how blurred the shadow will look. It corresponds to the sigma
    // value of the gaussian blur, and is given in mm.
    property Blur: single read FBlur write SetBlur;
    // Color indicates the color of the shadow and defaults to clBlack.
    property Color: TColor read FColor write SetColor;
    // Intensity is the shadows intensity, given as a fraction of the main alpha
    // channel, the default value is 0.7 (70%).
    property Intensity: single read FIntensity write SetIntensity;
  end;

// Paint a shadow onto the 32bit bitmap Dest. Dest must be already assigned and contain
// an image in the RGB channel and transparency information in the A channel.
// - Note that there must be a free border around any objects in the bitmap, so that the
// shadow can be drawn completely. This border must be the shadow Delta distance (if in
// that direction) plus a value of 1.5 * Blur. Example: You move the shadow out 5 pixels
// to the right, 3 pixels downwards and use Blur = 4. In that case you must add
// 5 + 1.5 * 4 = 11 pixels at the right border, and just so 3 + 1.5 * 4 = 9 pixels.
// The left side yields -5 + 1.5 * 4 = 1 pixel extra and the top -3 + 1.5 * 4 = 3 pixels
// extra. If you do not add this extra room, shadows may be cut off, or worse, appear
// as a "ghost" on the other side of the image (due to the blurring algorithm).
// - Intensity is the shadow's intensity, a default value of 0.7 is good.
// - DeltaX, DeltaY is the horizontal and vertical displacement of the shadow relative
// to the objects in pixels.
// - Blur indicates how blurred the shadow will look. It corresponds to the sigma value
// of the gaussian blur, a good start value would be 4 pixels.
// - Color indicates the color of the shadow.. usually clBlack.
procedure PaintShadow(Dest: TdtpBitmap; Intensity, Blur, DeltaX, DeltaY: single;
  Color: TColor);

implementation

procedure PaintShadow(Dest: TdtpBitmap; Intensity, Blur, DeltaX, DeltaY: single;
  Color: TColor);
var
  AShadow: TdtpBitmap;
begin
  // Create a shadow bitmap
  AShadow := TdtpBitmap.Create;
  try
    // copy from cache DIB
    AShadow.Assign(Dest);

    // Preserve alpha with 8bits extra precision, multiplied by intensity
    AlphaShr16Intensity(AShadow, Intensity);

    // Roll bitmap
    Roll(AShadow, round(DeltaX), round(DeltaY));

    // Blur with radius.. use special recursive (FAST) method
    BlurRecursive(AShadow, Blur);

    // Add color, shift back Alpha
    AlphaShl16Color(AShadow, dtpColor(Color));

    // And mix with original cache
    MergeLayers(Dest, AShadow);

  finally
    AShadow.Free;
  end;
end;

{ TdtpShadowEffect }

constructor TdtpShadowEffect.Create;
begin
  inherited;
  // Defaults
  FDeltaX    := cDefaultShadowDeltaX;
  FDeltaY    := cDefaultShadowDeltaY;
  FBlur      := cDefaultShadowBlur;
  FColor     := cDefaultShadowColor;
  FIntensity := cDefaultShadowIntensity;
end;

procedure TdtpShadowEffect.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FDeltaX    := ANode.ReadFloat('DeltaX');
  FDeltaY    := ANode.ReadFloat('DeltaY');
  FIntensity := ANode.ReadFloat('Intensity');
  FBlur      := ANode.ReadFloat('Blur');
  FColor     := ANode.ReadColor('Color');
end;

procedure TdtpShadowEffect.PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext);
// Alter the DIB so it displays a shadow
var
  AShadow: TdtpBitmap;
begin
  // Create a shadow bitmap
  AShadow := TdtpBitmap.Create;
  try
    // copy from cache DIB
    AShadow.Assign(DIB);

    // Preserve alpha with 8bits extra precision, multiplied by intensity
    AlphaShr16Intensity(AShadow, Intensity);

    // Roll bitmap
    Roll(AShadow, round(DeltaX * Device.ActualDpm), round(DeltaY * Device.ActualDpm));

    // Blur with radius.. use special recursive (FAST) method
    BlurRecursive(AShadow, FBlur * Device.ActualDpm);

    // Add color, shift back Alpha
    AlphaShl16Color(AShadow, dtpColor(FColor));

    // And mix with original cache
    MergeLayers(DIB, AShadow);

  finally
    AShadow.Free;
  end;
end;

procedure TdtpShadowEffect.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteFloat('DeltaX',    FDeltaX);
  ANode.WriteFloat('DeltaY',    FDeltaY);
  ANode.WriteFloat('Intensity', FIntensity);
  ANode.WriteFloat('Blur',      FBlur);
  ANode.WriteColor('Color',     FColor);
end;

procedure TdtpShadowEffect.SetBlur(const Value: single);
begin
  if FBlur <> Value then
  begin
    Invalidate;
    AddCmdToUndo('Blur', FloatToStr(FBlur));
    FBlur := Value;
    Changed;
  end;
end;

procedure TdtpShadowEffect.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    AddCmdToUndo('Color', IntToStr(FColor));
    FColor := Value;
    Changed;
  end;
end;

procedure TdtpShadowEffect.SetDeltaX(const Value: single);
begin
  if FDeltaX <> Value then
  begin
    Invalidate;
    AddCmdToUndo('DeltaX', FloatToStr(FDeltaX));
    FDeltaX := Value;
    Changed;
  end;
end;

procedure TdtpShadowEffect.SetDeltaY(const Value: single);
begin
  if FDeltaY <> Value then
  begin
    Invalidate;
    AddCmdToUndo('DeltaY', FloatToStr(FDeltaY));
    FDeltaY := Value;
    Changed;
  end;
end;

procedure TdtpShadowEffect.SetIntensity(const Value: single);
begin
  if FIntensity <> Value then
  begin
    AddCmdToUndo('Intensity', FloatToStr(FIntensity));
    FIntensity := Value;
    Changed;
  end;
end;

procedure TdtpShadowEffect.SetPropertyByName(const AName, AValue: string);
begin
  if AName = 'DeltaX' then
    DeltaX := StrToFloat(AValue)
  else if AName = 'DeltaY' then
    DeltaY := StrToFloat(AValue)
  else if AName = 'Intensity' then
    Intensity := StrToFloat(AValue)
  else if AName = 'Blur' then
    Blur := StrToFloat(AValue)
  else if AName = 'Color'then
    Color := StrToInt(AValue)
  else
    inherited;
end;

procedure TdtpShadowEffect.ValidateCurbSizes(var CurbLeft, CurbTop,
  CurbRight, CurbBottom: single);
// For a shadow we need more room. All sizes in [mm]
const
  // This value is empirically determined.. and is just big enough so that
  // the shadow bits are always contained inside
  cBlurExpand = 1.5;
begin
  CurbLeft   := CurbLeft   + Max(-DeltaX + Blur * cBlurExpand, 0);
  CurbRight  := CurbRight  + Max(+DeltaX + Blur * cBlurExpand, 0);
  CurbTop    := CurbTop    + Max(-DeltaY + Blur * cBlurExpand, 0);
  CurbBottom := CurbBottom + Max(+DeltaY + Blur * cBlurExpand, 0);
end;

initialization

  RegisterEffectClass(TdtpShadowEffect);

end.

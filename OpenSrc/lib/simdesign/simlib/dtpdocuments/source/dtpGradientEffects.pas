{
  Unit dtpGradientEffects

  Implements the gradient effect. It uses one of the primary channels and replaces
  any occurance of this primary color with the gradient effect.

  Project: DTP-Engine

  Creation Date: 24-01-2004 (NH)

  Modifications:
  08Nov2006: Preset palettes added with help of G. Prefontaine

  Copyright (c) 2004-2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpGradientEffects;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, Contnrs, dtpShape, dtpEffectShape, Graphics, Math,
  NativeXmlOld, dtpUtil, dtpGraphics, dtpStretch, dtpDefaults;

type

  TdtpReplaceType = (
    rtReplaceRed,      // Replace the red color component
    rtReplaceGreen,    // Replace the green color component
    rtReplaceBlue,     // Replace the blue color component
    rtReplaceAlpha,    // Replace any pixel with its Alpha value
    rtReplaceAny);     // Replace any color component, except $00000000

  TdtpPaletteMethodType = (
    pmTwoColors,
    pmPreset,
    pmColorStops,
    pmCustom);

  // This palette is initialized with 256 steps of gradient colors
  TdtpGradientPalette = array[0..cDefaultGradientPaletteSize - 1] of TdtpColor;

const

  // Gradient direction
  cgrDirectionCount = 9;
  cgrDirectionStrings: array[0..cgrDirectionCount - 1] of string =
    ('Horizontal',
     'Vertical',
     'DiagonalUp',
     'DiagonalDown',
     'FromLeftTop',
     'FromRightTop',
     'FromLeftBottom',
     'FromRightBottom',
     'FromCenter');
  cgdHorizontal   = 0;
  cgdVertical     = 1;
  cgdDiagonalUp   = 2;
  cgdDiagonalDown = 3;
  cgdFromLTCorner = 4;
  cgdFromRTCorner = 5;
  cgdFromLBCorner = 6;
  cgdFromRBCorner = 7;
  cgdFromCenter   = 8;

  // Gradient fill method
  cgrFillMethodCount = 4;
  cgrFillMethodStrings: array[0..cgrFillMethodCount - 1] of string =
    ('Col1 to Col2', 'Col2 to Col1', 'Col1-Col2-Col1', 'Col2-Col1-Col2');
  cfmCol1ToCol2   = 0;
  cfmCol2ToCol1   = 1;
  cfmCol1Col2Col1 = 2;
  cfmCol2Col1Col2 = 3;

  // Gradient presets
  cgrPresetCount = 24;
  cgrPresetStrings: array[0..cgrPresetCount - 1] of string =
    ('EarlySunset', 'LateSunset', 'Nightfall', 'Daybreak',
     'Horizon', 'Desert', 'Ocean', 'CalmWater',
     'Fire', 'Fog', 'Moss','Peacock',
     'Wheat', 'Parchment', 'Mahogany', 'Rainbow',
     'RainbowII', 'Gold', 'Gold2', 'Brass',
     'Chrome', 'ChromeII', 'Silver', 'Sapphire');

type

  // TdtpReplacementEffect is a common ancestor for all effects that replace
  // any of the primary colors red, green, blue by something special, like
  // a bitmap texture, pattern or gradient color. The amount of primary color
  // present in a pixel is the amount of alpha that the new fill will get.
  TdtpReplacementEffect = class(TdtpEffect)
  private
    FReplace: TdtpReplaceType;
    procedure SetReplace(const Value: TdtpReplaceType);
  protected
    function GetSourceDIB(DirectDIB: TdtpBitmap): TdtpBitmap;
    function ParentIsReplacementEffect: boolean;
    procedure ReplacementAlphaAndCover(const ABits: TdtpColor; var Alpha, Cover: integer);
  public
    constructor Create; override;
    // Replace specifies which of the primary colors to replace.
    property Replace: TdtpReplaceType read FReplace write SetReplace;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
  end;

  TdtpColorStop = class(TPersistent)
  private
    FPosition: double;
    FColor: TdtpColor;
  published
    // Color of this stop
    property Color: TdtpColor read FColor write FColor;
    // Position of this stop, should be between 0.0 and 1.0
    property Position: double read FPosition write FPosition;
  end;

  TdtpColorStopList = class(TObjectList)
  private
    function GetItems(Index: integer): TdtpColorStop;
  public
    procedure AddStop(const AColor: TdtpColor; const APosition: double);
    procedure LoadFromXml(ANode: TXmlNodeOld);
    procedure SaveToXml(ANode: TXmlNodeOld);
    property Items[Index: integer]: TdtpColorStop read GetItems; default;
  end;

  // TdtpGradientEffect will paint a gradient wherever it finds the primary
  // color to replace. Gradients can be drawn in many different forms, see
  // Direction and FillMethod. Color palettes used can be interpolations between
  // two colors or preset palettes.
  TdtpGradientEffect = class(TdtpReplacementEffect)
  private
    FColor1: TdtpColor;
    FColor2: TdtpColor;
    FDirection: integer;
    FFillMethod: integer;
    FHasPalette: boolean;
    FPalette: TdtpGradientPalette;
    FPaletteMethod: TdtpPaletteMethodType;
    FPreset: integer;
    FStops: TdtpColorStopList;
    procedure SetPaletteMethod(const Value: TdtpPaletteMethodType);
    procedure SetColor1(const Value: TdtpColor);
    procedure SetColor2(const Value: TdtpColor);
    procedure SetPreset(const Value: integer);
    procedure SetDirection(const Value: integer);
    procedure SetFillMethod(const Value: integer);
    procedure BuildPalette;
  protected
    procedure PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext); override;
    procedure Update; override;
    property Stops: TdtpColorStopList read FStops;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property PaletteMethod: TdtpPaletteMethodType read FPaletteMethod write SetPaletteMethod;
    property Color1: TdtpColor read FColor1 write SetColor1;
    property Color2: TdtpColor read FColor2 write SetColor2;
    property Preset: integer read FPreset write SetPreset;
    property Direction: integer read FDirection write SetDirection;
    property FillMethod: integer read FFillMethod write SetFillMethod;
  end;

  // An effect that can be used as diagnostic method to see the alpha map of
  // any normal 32-bit image. Places where Alpha = 255 will show up as FgColor,
  // while places where Alpha = 0 will show up as BgColor. For Alpha values
  // inbetween, the colors FgColor and BgColor will be mixed.
  TdtpAlphaToColorEffect = class(TdtpEffect)
  private
    FFgColor: TdtpColor;
    FBgColor: TdtpColor;
  protected
    procedure PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext); override;
  public
    constructor Create; override;
    property FgColor: TdtpColor read FFgColor write FFgColor;
    property BgColor: TdtpColor read FBgColor write FBgColor;
  end;

function InterpolateColor32(const Col1, Col2: TdtpColor; Frac: single): TdtpColor;

// Save a gradient palette to an XML node
procedure SavePaletteToXml(ANode: TXmlNodeOld; const FPalette: TdtpGradientPalette);

// Load a gradient palette from an XML node
procedure LoadPaletteFromXml(ANode: TXmlNodeOld; var FPalette: TdtpGradientPalette);

procedure BuildPaletteFromStops(Stops: TdtpColorStopList; var Palette: TdtpGradientPalette);

implementation

type
  THackShape = class(TdtpEffectShape);

function InterpolateColor32(const Col1, Col2: TdtpColor; Frac: single): TdtpColor;
begin
  Result :=
    Round((Col1 shr 24 and $FF) * (1 - Frac) + (Col2 shr 24 and $FF) * Frac) shl 24 +
    Round((Col1 shr 16 and $FF) * (1 - Frac) + (Col2 shr 16 and $FF) * Frac) shl 16 +
    Round((Col1 shr  8 and $FF) * (1 - Frac) + (Col2 shr  8 and $FF) * Frac) shl  8 +
    Round((Col1        and $FF) * (1 - Frac) + (Col2        and $FF) * Frac);
end;

procedure SavePaletteToXml(ANode: TXmlNodeOld; const FPalette: TdtpGradientPalette);
// Save a gradient palette to an XML node
var
  i: integer;
begin
  for i := 0 to cDefaultGradientPaletteSize - 1 do
    ANode.NodeNew('C').ValueAsString := UTF8String('$' + IntToHex(FPalette[i], 8));
end;

procedure LoadPaletteFromXml(ANode: TXmlNodeOld; var FPalette: TdtpGradientPalette);
// Load a gradient palette from an XML node
var
  i: integer;
  Nodes: TList;
begin
  if not assigned(ANode) then
    exit;
  Nodes := TList.Create;
  try
    ANode.NodesByName('C', Nodes);
    for i := 0 to Nodes.Count - 1 do
      //todo FPalette[i] := StrToIntDef(string(TXmlNodeOld(Nodes[i]).Value), 0);
  finally
    Nodes.Free;
  end;
end;

procedure BuildPaletteFromStops(Stops: TdtpColorStopList; var Palette: TdtpGradientPalette);
var
  i, Idx: integer;
  Multi, Divisor, Frac, Position, Position1, Position2: single;
  AColor1, AColor2: TdtpColor;
begin
  if Stops.Count >= 2 then
  begin
    // Build palette from the stops
    AColor1 := Stops[0].Color;
    Position1 := Stops[0].Position;
    AColor2 := Stops[1].Color;
    Position2 := Stops[1].Position;
    Idx := 2;
    Multi := 1 / (cDefaultGradientPaletteSize - 1);
    Divisor := Position2 - Position1;
    if Divisor <= 0 then
      Divisor := 1
    else
      Divisor := 1 / Divisor;

    for i := 0 to cDefaultGradientPaletteSize - 1 do
    begin
      Position := i * Multi;
      while (Position > Position2) and (Idx < Stops.Count) do
      begin
        AColor1 := AColor2;
        Position1 := Position2;
        AColor2 := Stops[Idx].Color;
        Position2 := Stops[Idx].Position;
        Divisor := Position2 - Position1;
        if Divisor <= 0 then
          Divisor := 1
        else
          Divisor := 1 / Divisor;
        inc(Idx);
      end;
      Frac := (Position - Position1) * Divisor;
      if Frac < 0 then
        Frac := 0
      else
        if Frac > 1 then
          Frac := 1;
      Palette[i] := InterpolateColor32(AColor1, AColor2, Frac);
    end;
  end;
end;

// Adapted from www.isc.tamu.edu/~astro/color.html
procedure WavelengthToRGB(const Wavelength:  double; var R,G,B: byte);
const
  Gamma        = 0.80;
  IntensityMax = 255;
var
  Blue  :  DOUBLE;
  Factor:  DOUBLE;
  Green :  DOUBLE;
  Red   :  DOUBLE;
// local
function Adjust(const Color, Factor: double): integer;
begin
  if Color = 0.0 then
    Result := 0     // Don't want 0^x = 1 for x <> 0
  else
    Result := Round(IntensityMax * Power(Color * Factor, Gamma))
end; //Adjust
// main
begin

  case Trunc(Wavelength) of
  380..439:
  begin
    Red   := -(Wavelength - 440) / (440 - 380);
    Green := 0.0;
    Blue  := 1.0
  end;
  440..489:
  begin
    Red   := 0.0;
    Green := (Wavelength - 440) / (490 - 440);
    Blue  := 1.0
  end;
  490..509:
  begin
    Red   := 0.0;
    Green := 1.0;
    Blue  := -(Wavelength - 510) / (510 - 490)
  end;
  510..579:
  begin
    Red   := (Wavelength - 510) / (580 - 510);
    Green := 1.0;
    Blue  := 0.0
  end;
  580..644:
  begin
    Red   := 1.0;
    Green := -(Wavelength - 645) / (645 - 580);
    Blue  := 0.0
  end;
  645..780:
  begin
    Red   := 1.0;
    Green := 0.0;
    Blue  := 0.0
  end;
  else
    Red   := 0.0;
    Green := 0.0;
    Blue  := 0.0
  end;//case

  // Let the intensity fall off near the vision limits
  case Trunc(Wavelength) of
  380..419: Factor := 0.3 + 0.7 * (Wavelength - 380) / (420 - 380);
  420..700: Factor := 1.0;
  701..780: Factor := 0.3 + 0.7 * (780 - Wavelength) / (780 - 700)
  else
    Factor := 0.0
  end;//case

  R := Adjust(Red,   Factor);
  G := Adjust(Green, Factor);
  B := Adjust(Blue,  Factor)
end; //WavelengthToRGB

{ TdtpColorStopList }

procedure TdtpColorStopList.AddStop(const AColor: TdtpColor; const APosition: double);
var
  i: integer;
  AStop: TdtpColorStop;
begin
  AStop := TdtpColorStop.Create;
  AStop.Color := AColor;
  AStop.Position := APosition;
  // Add stops in sorted fashion
  for i := 0 to Count - 1 do
    if Items[i].Position > APosition then
    begin
      Insert(i, AStop);
      exit;
    end;
  // Still here? add at end
  Add(AStop);
end;

function TdtpColorStopList.GetItems(Index: integer): TdtpColorStop;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

procedure TdtpColorStopList.LoadFromXml(ANode: TXmlNodeOld);
// Load a color stop list from an XML node
var
  i: integer;
  Nodes: TXmlNodeList;
  AStop: TdtpColorStop;
begin
  if not assigned(ANode) then
    exit;
  Nodes := TXmlNodeList.Create;//todo (False);
  try
    Clear;
    ANode.NodesByName('Stop', Nodes);
    for i := 0 to Nodes.Count - 1 do
    begin
      AStop := TdtpColorStop.Create;
      AStop.Color    := Nodes[i].ReadAttributeInteger('Color', clBlack);
      AStop.Position := Nodes[i].ReadAttributeFloat('Position', 0);
      Add(AStop);
    end;
  finally
    Nodes.Free;
  end;
end;

procedure TdtpColorStopList.SaveToXml(ANode: TXmlNodeOld);
// Save a color stop list from an XML node
var
  i: integer;
  AChild: TXmlNodeOld;
begin
  if not assigned(ANode) then
    exit;
  for i := 0 to Count - 1 do
  begin
    AChild := ANode.NodeNew('Stop');
    AChild.WriteAttributeInteger('Color', Items[i].Color);
    AChild.WriteAttributeFloat('Position', Items[i].Position);
  end;
end;

{ TdtpGradientEffect }

procedure TdtpGradientEffect.BuildPalette;
var
  i: integer;
  APalette: TdtpGradientPalette;
  R, G, B: byte;
  Multi: single;
begin

  // Create 256-level palette
  case PaletteMethod of
  pmTwoColors:
    begin
      Multi := 1 / (cDefaultGradientPaletteSize - 1);
      for i := 0 to cDefaultGradientPaletteSize - 1 do
        APalette[i] := InterpolateColor32(Color1, Color2, i * Multi);
    end;
  pmPreset:
    begin
      // Clear the color stop list
      FStops.Clear;

      // Presets define the stops
      case Preset of
      0: //early sunset
        begin
          FStops.AddStop(dtpColor(0,     0, 130), 0.00);
          FStops.AddStop(dtpColor(122,   0, 133), 0.34);
          FStops.AddStop(dtpColor(170,   0, 110), 0.60);
          FStops.AddStop(dtpColor(255,   0,   0), 0.87);
          FStops.AddStop(dtpColor(255, 126,   0), 1.00);
        end;
      1: //late sunset
        begin
          FStops.AddStop(dtpColor(  0,   0,   0), 0.00);
          FStops.AddStop(dtpColor( 26,   0,  64), 0.20);
          FStops.AddStop(dtpColor( 42,   0,  64), 0.45);
          FStops.AddStop(dtpColor(118,   0,  64), 0.74);
          FStops.AddStop(dtpColor(190,  55,  34), 0.82);
          FStops.AddStop(dtpColor(255, 191,   0), 1.00);
        end;
      2: //nightfall
        begin
          FStops.AddStop(dtpColor(  0,   0,   0), 0.00);
          FStops.AddStop(dtpColor( 16,  22, 166), 0.50);
          FStops.AddStop(dtpColor( 16,  22, 166), 0.70);
          FStops.AddStop(dtpColor(110,   6, 212), 0.86);
          FStops.AddStop(dtpColor(139,  60, 147), 1.00);
        end;
      3: //Daybreak
        begin
          FStops.AddStop(dtpColor( 94, 158, 255), 0.00);
          FStops.AddStop(dtpColor(152, 200, 249), 0.50);
          FStops.AddStop(dtpColor(255, 235, 250), 1.00);
        end;
      4: //Horizon
        begin
          FStops.AddStop(dtpColor(218, 234, 244), 0.00);
          FStops.AddStop(dtpColor(118, 144, 185), 0.13);
          FStops.AddStop(dtpColor(131, 166, 194), 0.18);
          FStops.AddStop(dtpColor(255, 255, 255), 0.52);
          FStops.AddStop(dtpColor(129,  49,  46), 0.58);
          FStops.AddStop(dtpColor(187,  79,  76), 0.71);
          FStops.AddStop(dtpColor(233, 216, 210), 0.94);
          FStops.AddStop(dtpColor( 88,  42,  32), 1.00);
        end;
      5: //Desert
        begin
          FStops.AddStop(dtpColor(252, 159, 201), 0.00);
          FStops.AddStop(dtpColor(248, 176,  73), 0.13);
          FStops.AddStop(dtpColor(248, 176,  73), 0.19);
          FStops.AddStop(dtpColor(254, 230, 241), 0.63);
          FStops.AddStop(dtpColor(198,  10,  75), 0.69);
          FStops.AddStop(dtpColor(183,  68, 130), 0.81);
          FStops.AddStop(dtpColor(248, 176,  73), 1.00);
        end;
      6: //Ocean
        begin
          FStops.AddStop(dtpColor(  3, 212, 168), 0.00);
          FStops.AddStop(dtpColor( 31, 214, 220), 0.25);
          FStops.AddStop(dtpColor(  0,  92, 191), 1.00);
        end;
      7: //CalmWater
        begin
          FStops.AddStop(dtpColor(204, 204, 255), 0.00);
          FStops.AddStop(dtpColor(154, 204, 255), 0.17);
          FStops.AddStop(dtpColor(153, 102, 255), 0.36);
          FStops.AddStop(dtpColor(203, 154, 255), 0.59);
          FStops.AddStop(dtpColor(164, 204, 255), 0.81);
          FStops.AddStop(dtpColor(204, 204, 255), 1.00);
        end;
      8: //Fire
        begin
          FStops.AddStop(dtpColor(255, 242,   0), 0.00);
          FStops.AddStop(dtpColor(243,   3,   1), 0.72);
          FStops.AddStop(dtpColor( 79,   8,   8), 1.00);
        end;
      9: //Fog
        begin
          FStops.AddStop(dtpColor(132, 136, 196), 0.00);
          FStops.AddStop(dtpColor(212, 222, 255), 0.53);
          FStops.AddStop(dtpColor(212, 222, 255), 0.83);
          FStops.AddStop(dtpColor(150, 171, 148), 1.00);
        end;
      10: //Moss
        begin
          FStops.AddStop(dtpColor(221, 235, 207), 0.00);
          FStops.AddStop(dtpColor(162, 188, 118), 0.50);
          FStops.AddStop(dtpColor( 21, 107,  19), 1.00);
        end;
      11: //Peacock
        begin
          FStops.AddStop(dtpColor( 51, 153, 255), 0.00);
          FStops.AddStop(dtpColor(  0, 204, 204), 0.16);
          FStops.AddStop(dtpColor(150, 154, 254), 0.46);
          FStops.AddStop(dtpColor( 51, 105, 151), 0.59);
          FStops.AddStop(dtpColor( 50,  61, 193), 0.70);
          FStops.AddStop(dtpColor( 17, 112, 254), 0.81);
          FStops.AddStop(dtpColor(  0, 102, 153), 1.00);
        end;
      12: //Wheat
        begin
          FStops.AddStop(dtpColor(251, 234, 199), 0.00);
          FStops.AddStop(dtpColor(254, 231, 241), 0.16);
          FStops.AddStop(dtpColor(250, 199, 125), 0.37);
          FStops.AddStop(dtpColor(251, 171, 127), 0.61);
          FStops.AddStop(dtpColor(251, 213, 163), 0.81);
          FStops.AddStop(dtpColor(254, 230, 239), 1.00);
        end;
      13: //Parchment
        begin
          FStops.AddStop(dtpColor(255, 239, 209), 0.00);
          FStops.AddStop(dtpColor(243, 236, 212), 0.55);
          FStops.AddStop(dtpColor(230, 222, 196), 0.75);
          FStops.AddStop(dtpColor(209, 195, 159), 1.00);
        end;
      14: //Mahogany
        begin
          FStops.AddStop(dtpColor(214, 178, 156), 0.00);
          FStops.AddStop(dtpColor(190, 124,  76), 0.50);
          FStops.AddStop(dtpColor(146,  75,  33), 0.75);
          FStops.AddStop(dtpColor(104,  49,  19), 1.00);
        end;
      15: // Rainbow (mathematically created)
        for i := 0 to 255 do begin
          WavelengthToRGB(380 + i * ((780 - 380) / 255), R,G,B);
          APalette[i] := $FF000000 + R shl 16 + G shl 8 + B;
        end;
      16: //Rainbow2
        begin
          FStops.AddStop(dtpColor(255,  51, 153), 0.00);
          FStops.AddStop(dtpColor(255, 102,  51), 0.23);
          FStops.AddStop(dtpColor(255, 248,   2), 0.48);
          FStops.AddStop(dtpColor(  4, 163, 150), 0.80);
          FStops.AddStop(dtpColor( 51, 102, 255), 1.00);
        end;
      17: //Gold
        begin
          FStops.AddStop(dtpColor(230, 220, 172), 0.00);
          FStops.AddStop(dtpColor(230, 214, 136), 0.12);
          FStops.AddStop(dtpColor(200, 173,  78), 0.30);
          FStops.AddStop(dtpColor(229, 214, 136), 0.45);
          FStops.AddStop(dtpColor(200, 174,  80), 0.77);
          FStops.AddStop(dtpColor(229, 219, 170), 1.00);
        end;
      18: //Gold 2
        begin
          FStops.AddStop(dtpColor(250, 227, 172), 0.00);
          FStops.AddStop(dtpColor(190, 147,  43), 0.13);
          FStops.AddStop(dtpColor(250, 227, 173), 0.63);
          FStops.AddStop(dtpColor(189, 146,  45), 0.67);
          FStops.AddStop(dtpColor(132,  95,  24), 0.69);
          FStops.AddStop(dtpColor(151, 122,  55), 0.79);
          FStops.AddStop(dtpColor(250, 227, 183), 1.00);
        end;
      19: //Brass
        begin
          FStops.AddStop(dtpColor(132,  87, 0), 0.00);
          FStops.AddStop(dtpColor(253, 166, 0), 0.14);
          FStops.AddStop(dtpColor(132,  87, 0), 0.28);
          FStops.AddStop(dtpColor(253, 166, 0), 0.42);
          FStops.AddStop(dtpColor(132,  87, 0), 0.58);
          FStops.AddStop(dtpColor(253, 166, 0), 0.72);
          FStops.AddStop(dtpColor(132,  87, 0), 0.87);
          FStops.AddStop(dtpColor(253, 166, 0), 1.00);
        end;
      20: //Chrome
        begin
          FStops.AddStop(dtpColor(254, 254, 254), 0.00);
          FStops.AddStop(dtpColor( 38,  38,  38), 0.16);
          FStops.AddStop(dtpColor(253, 253, 253), 0.18);
          FStops.AddStop(dtpColor(101, 101, 101), 0.42);
          FStops.AddStop(dtpColor(207, 207, 207), 0.54);
          FStops.AddStop(dtpColor(203, 203, 203), 0.66);
          FStops.AddStop(dtpColor( 37,  37,  37), 0.76);
          FStops.AddStop(dtpColor(253, 253, 253), 0.79);
          FStops.AddStop(dtpColor(129, 129, 129), 1.00);
        end;
      21: //Chrome  2
        begin
          FStops.AddStop(dtpColor(203, 203, 203), 0.00);
          FStops.AddStop(dtpColor( 95,  95,  95), 0.13);
          FStops.AddStop(dtpColor( 95,  95,  95), 0.21);
          FStops.AddStop(dtpColor(255, 255, 255), 0.61);
          FStops.AddStop(dtpColor(239, 239, 239), 0.63);
          FStops.AddStop(dtpColor( 43,  43,  43), 0.69);
          FStops.AddStop(dtpColor(234, 234, 234), 1.00);
        end;
      22: //Silver
        begin
          FStops.AddStop(dtpColor(255, 255, 255), 0.00);
          FStops.AddStop(dtpColor(126, 133, 151), 0.32);
          FStops.AddStop(dtpColor(228, 228, 228), 0.47);
          FStops.AddStop(dtpColor(126, 133, 150), 0.85);
          FStops.AddStop(dtpColor(228, 228, 228), 1.00);
        end;
      23: //sapphire
        begin
          FStops.AddStop(dtpColor(  0,  1, 131), 0.00);
          FStops.AddStop(dtpColor(  0, 70, 254), 0.14);
          FStops.AddStop(dtpColor(  0,  1, 131), 0.28);
          FStops.AddStop(dtpColor(  0, 70, 254), 0.42);
          FStops.AddStop(dtpColor(  0,  1, 131), 0.56);
          FStops.AddStop(dtpColor(  0, 70, 254), 0.70);
          FStops.AddStop(dtpColor(  0,  1, 131), 0.84);
          FStops.AddStop(dtpColor(  0, 70, 254), 1.00);
        end;
      else
        Multi := 1 / (cDefaultGradientPaletteSize - 1);
        // For now.. we must still get all these presets into a bunch of.. presets :)
        for i := 0 to cDefaultGradientPaletteSize - 1 do
          APalette[i] := InterpolateColor32(Color1, Color2, i * Multi);
      end;
      // Build from the stop list
      BuildPaletteFromStops(FStops, APalette);
    end;
  pmColorStops:
    BuildPaletteFromStops(FStops, APalette);
  end;

  // Adapt for other fill methods
  case FillMethod of
  cfmCol2ToCol1:
    for i := 0 to cDefaultGradientPaletteSize - 1 do
      FPalette[i] := APalette[cDefaultGradientPaletteSize - 1 - i];
  cfmCol1Col2Col1:
    for i := 0 to cDefaultGradientPaletteSize - 1 do
      FPalette[i] := APalette[cDefaultGradientPaletteSize - 1 - abs(cDefaultGradientPaletteSize - 1 - i * 2)];
  cfmCol2Col1Col2:
    for i := 0 to cDefaultGradientPaletteSize - 1 do
      FPalette[i] := APalette[abs(cDefaultGradientPaletteSize - 1 - i * 2)];
  else
    FPalette := APalette;
  end;

  FHasPalette := True;
end;

constructor TdtpGradientEffect.Create;
begin
  inherited;
  FStops := TdtpColorStopList.Create;
  // Defaults
  FColor1 := clWhite32;
  FColor2 := clBlack32;
  FDirection := 0;
  FFillMethod := 0;
  FPaletteMethod := pmTwoColors;
  FPreset := 0;
end;

destructor TdtpGradientEffect.Destroy;
begin
  FreeAndNil(FStops);
  inherited;
end;

procedure TdtpGradientEffect.LoadFromXml(ANode: TXmlNodeOld);
var
  i: integer;
  Name: string;
begin
  inherited;
  FColor1 := ANode.ReadInteger('Color1');
  FColor2 := ANode.ReadInteger('Color2');
  Name := string(ANode.ReadString('Direction'));
  for i := 0 to cgrDirectionCount - 1 do
    if cgrDirectionStrings[i] = Name then
    begin
      FDirection := i;
      break;
    end;
  Name := string(ANode.ReadString('FillMethod'));
  for i := 0 to cgrFillMethodCount - 1 do
    if cgrFillMethodStrings[i] = Name then
    begin
      FFillMethod := i;
      break;
    end;
  FPaletteMethod := TdtpPaletteMethodType(ANode.ReadInteger('PaletteMethod'));
  case PaletteMethod of
  pmPreset:
    begin
      Name := string(ANode.ReadString('Preset'));
      for i := 0 to cgrPresetCount - 1 do
        if cgrPresetStrings[i] = Name then
        begin
          FPreset := i;
          break;
        end;
    end;
  pmColorStops:
    FStops.LoadFromXml(ANode.NodeByName('ColorStops'));
  pmCustom:
    LoadPaletteFromXml(ANode.NodeByName('Palette'), FPalette);
  end;
end;

procedure TdtpGradientEffect.PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext);
// Alter the DIB so it displays the gradient
var
  i, x, y, AWidth, AHeight: integer;
  Color: TdtpColor;
  Alpha, Cover: integer;
  Gradient: array of TdtpColor;
  SourceDIB: TdtpBitmap;
  AMax: integer;
  XStart, XSize: array of integer;
  YStart, YSize: array of integer;
  Multi: double;
  P, Q: PdtpColor;
begin
  // Build the palette first
  if not FHasPalette then
    BuildPalette;
  SourceDIB := GetSourceDIB(DIB);
  AWidth := DIB.Width;
  AHeight := DIB.Height;

  if not assigned(SourceDIB) then
    exit;

  // Prepare gradient
  case Direction of
  cgdHorizontal:
    begin
      Multi := (cDefaultGradientPaletteSize - 1) / (AWidth - 1);
      SetLength(Gradient, AWidth);
      for i := 0 to AWidth - 1 do
        Gradient[i] := FPalette[round(i * Multi)];
    end;
  cgdVertical:
    begin
      SetLength(Gradient, AHeight);
      Multi := (cDefaultGradientPaletteSize - 1) / (AHeight - 1);
      for i := 0 to AHeight - 1 do
        Gradient[i] := FPalette[round(i * Multi)];
    end;
  cgdDiagonalUp, cgdDiagonalDown, cgdFromLTCorner..cgdFromRBCorner, cgdFromCenter:
    begin
      AMax := Max(AHeight, AWidth);
      SetLength(XStart, AWidth);
      SetLength(XSize, AWidth);
      SetLength(YStart, AHeight);
      SetLength(YSize, AHeight);
      CreateDivision(AMax, AWidth,  XStart, XSize);
      CreateDivision(AMax, AHeight, YStart, YSize);
      // Set gradient
      case Direction of
      cgdDiagonalUp, cgdDiagonalDown:
        begin
          SetLength(Gradient, 2 * AMax);
          Multi := (cDefaultGradientPaletteSize - 1) / (2 * AMax - 1);
          for i := 0 to 2 * AMax - 1 do
            Gradient[i] := FPalette[round(i * Multi)];
        end;
      cgdFromLTCorner..cgdFromRBCorner:
        begin
          SetLength(Gradient, AMax);
          Multi := (cDefaultGradientPaletteSize - 1) / (AMax - 1);
          for i := 0 to AMax - 1 do
            Gradient[i] := FPalette[round(i * Multi)];
        end;
      cgdFromCenter:
        begin
          SetLength(Gradient, AMax div 2 + 1);
          Multi := (cDefaultGradientPaletteSize - 1) / (AMax  div 2);
          for i := 0 to AMax div 2 do
            Gradient[i] := FPalette[round(i * Multi)];
        end;
      end;//case
    end;
  else
    SetLength(Gradient, 1);
    Gradient[0] := Color1;
  end;//case

  // Replace colors
  P := PdtpColor(DIB.Bits);
  Q := PdtpColor(SourceDIB.Bits);
  for y := 0 to AHeight - 1 do
  begin
    for x := 0 to AWidth - 1 do
    begin

      // Find alpha
      ReplacementAlphaAndCover(Q^, Alpha, Cover);

      // We now find the gradient color
      case Direction of
      cgdHorizontal:
        Color := Gradient[x];
      cgdVertical:
        Color := Gradient[y];
      cgdDiagonalUp:
        Color := Gradient[XStart[x] + YStart[y]];
      cgdDiagonalDown:
        Color := Gradient[XStart[AWidth - x - 1] + YStart[y]];
      cgdFromLTCorner:
        Color := Gradient[Max(XStart[x], YStart[y])];
      cgdFromRTCorner:
        Color := Gradient[Max(XStart[AWidth - x - 1], YStart[y])];
      cgdFromLBCorner:
        Color := Gradient[Max(XStart[x], YStart[AHeight - y - 1])];
      cgdFromRBCorner:
        Color := Gradient[Max(XStart[AWidth - x - 1], YStart[AHeight - y - 1])];
      cgdFromCenter:
        Color := Gradient[Max(
          XStart[abs(x - (AWidth div 2))],
          YStart[abs(y - (AHeight div 2))])];
      else
        Color := Gradient[0];
      end;

      // Set the gradient color
      if (Cover = 0) or (Alpha = 0) then
        // nothing to do
      else if Cover = $FF then
        P^ := SetAlpha(Color, (Alpha * AlphaComponent(Color)) div 255)
      else
        P^ := SetAlpha(Merge(Color, P^, Cover),
         (Alpha * AlphaComponent(Color)) div 255);

      // Next pixel
      inc(P);
      inc(Q);
    end;
  end;
end;

procedure TdtpGradientEffect.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteHex('Color1', FColor1, 8);
  ANode.WriteHex('Color2', FColor2, 8);
  ANode.WriteString('Direction', UTF8String(cgrDirectionStrings[FDirection]));
  ANode.WriteString('FillMethod', UTF8String(cgrFillMethodStrings[FFillMethod]));
  ANode.WriteInteger('PaletteMethod', integer(FPaletteMethod));
  case PaletteMethod of
  pmPreset:
    ANode.WriteString('Preset', UTF8String(cgrPresetStrings[FPreset]));
  pmColorStops:
    FStops.SaveToXml(ANode.NodeNew('ColorStops'));
  pmCustom:
    SavePaletteToXml(ANode.NodeNew('Palette'), FPalette);
  end;
end;

procedure TdtpGradientEffect.SetColor1(const Value: TdtpColor);
begin
  if FColor1 <> Value then
  begin
    FColor1 := Value;
    Changed;
  end;
end;

procedure TdtpGradientEffect.SetColor2(const Value: TdtpColor);
begin
  if FColor2 <> Value then
  begin
    FColor2 := Value;
    Changed;
  end;
end;

procedure TdtpGradientEffect.SetDirection(const Value: integer);
begin
  if FDirection <> Value then
  begin
    FDirection := Value;
    Changed;
  end;
end;

procedure TdtpGradientEffect.SetFillMethod(const Value: integer);
begin
  if FFillMethod <> Value then
  begin
    FFillMethod := Value;
    Changed;
  end;
end;

procedure TdtpGradientEffect.SetPaletteMethod(
  const Value: TdtpPaletteMethodType);
begin
  if FPaletteMethod <> Value then
  begin
    FPaletteMethod := Value;
    Changed;
  end;
end;

procedure TdtpGradientEffect.SetPreset(const Value: integer);
begin
  if FPreset <> Value then
  begin
    FPreset := Value;
    Changed;
  end;
end;

procedure TdtpGradientEffect.Update;
// Here we signal that the palette needs updating
begin
  FHasPalette := False;
end;

{ TdtpReplacementEffect }

constructor TdtpReplacementEffect.Create;
begin
  inherited;
  FReplace := rtReplaceAlpha;
end;

function TdtpReplacementEffect.GetSourceDIB(DirectDIB: TdtpBitmap): TdtpBitmap;
begin
  Result := DirectDIB;
  if Source <> ceoPrevious then
    if Source = ceoOriginal then
      Result := THackShape(Parent).OriginalDIB
    else
      Result := Parent.Effects[Source].ResultDIB;
end;

procedure TdtpReplacementEffect.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FReplace := TdtpReplaceType(ANode.ReadInteger('Replace'));
end;

function TdtpReplacementEffect.ParentIsReplacementEffect: boolean;
var
  AIndex: integer;
begin
  Result := False;
  if assigned(Parent) then
  begin
    AIndex := Parent.EffectIndexOf(Self);
    if Parent.Effects[AIndex - 1] is TdtpReplacementEffect then
      Result := True;
  end;
end;

procedure TdtpReplacementEffect.ReplacementAlphaAndcover(const ABits: TdtpColor; var Alpha, Cover: integer);
begin
  case FReplace of
  rtReplaceRed:
    begin
      // We use any bits that have the color red
      Cover := (ABits and $00FF0000) shr 16;
      Alpha := AlphaComponent(ABits);
    end;
  rtReplaceGreen:
    begin
      // We use any bits that have the color green
      Cover := (ABits and $0000FF00) shr 8;
      Alpha := AlphaComponent(ABits);
    end;
  rtReplaceBlue:
    begin
      // We use any bits that have the color blue
      Cover := ABits and $000000FF;
      Alpha := AlphaComponent(ABits);
    end;
  rtReplaceAlpha:
    begin
      Alpha := AlphaComponent(ABits);
      if Alpha = 0 then
        Cover := 0
      else
        Cover := $FF;
    end;
  rtReplaceAny:
    if AlphaComponent(ABits) = 0 then
    begin
      Cover := 0;
      Alpha := 0;
    end else
    begin
      Cover := $FF;
      Alpha := $FF;
    end;
  end;//case
end;

procedure TdtpReplacementEffect.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteInteger('Replace', integer(FReplace));
end;

procedure TdtpReplacementEffect.SetReplace(const Value: TdtpReplaceType);
begin
  if FReplace <> Value then
  begin
    FReplace := Value;
    Changed;
  end;
end;

{ TdtpAlphaToColorEffect }

constructor TdtpAlphaToColorEffect.Create;
begin
  inherited;
  FFgColor := clBlack32;
  FBgColor := clWhite32;
end;

procedure TdtpAlphaToColorEffect.PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext);
var
  i: integer;
  P: PColor;
begin
  inherited;
  P := @DIB.Bits[0];
  for i := 0 to DIB.Width * DIB.Height - 1 do
  begin
    // Set FgColor if Alpha = 255, or BgColor if Alpha = 0, and everything inbetween
    // is mix
    P^ := dtpCombineReg(FFgColor, FBgColor, (P^ shr 24));
    inc(P);
  end;
  EMMS;
end;

initialization

  RegisterEffectClass(TdtpGradientEffect);
  RegisterEffectClass(TdtpAlphaToColorEffect);

end.

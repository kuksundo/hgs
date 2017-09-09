{ Unit dtpPolygonText

  Project: DTP-Engine

  Creation Date: 24Jul2004 (NH)
  Version: 1.0
  Contributor: JF

  Modifications:
  - 17Feb2006: Adapted TdtpPolygonText with dtpTruetypeFonts unit
  - 23Jun2010: Changed dtpShape hierarchy (JF)
  - feb2011: bug fix (JF)

  Copyright (c) 2004 - 2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpPolygonText;

{$i simdesign.inc}

interface

uses
  Classes, Contnrs, SysUtils, Graphics, Windows, dtpGraphics,
  dtpEffectShape, dtpTextShape, dtpCommand, dtpShape, dtpDefaults, NativeXmlOld,
  dtpTruetypeFonts, sdWidestrings, Math;

type

  TTransformMethod = (
    tmPoints,  // Transform all points
    tmGlyphs   // Transform the glyphs as a whole
  );

  TFixedMatrix = array[0..2, 0..2] of TFixed;

  TFixedTransform = class(TPersistent)
  protected
    FMatrix: TFixedMatrix;
  public
    constructor Create; virtual;
    procedure Clear;
    procedure Translate(Dx, Dy: TFixed);
    procedure Rotate(Cx, Cy: TFixed; Angle: double);
    function TransformPoint(APoint: TdtpFixedPoint): TdtpFixedPoint; virtual;
  end;

  // TdtpPolygonText allows rendering of text by first transforming it to a polygon
  // and then rendering the polygon to the document. Polygon-based text can be
  // transformed freely, by overriding the method PerformTransformationEffect.
  // The base class TdtpPolygonText does not do any transform, see TdtpCurvedText
  // and TdtpWavyText for transformation examples.
  TdtpPolygonText = class(TdtpTextBaseShape)
  private
    procedure GetFont;
    procedure SetRenderProperties(ARenderer: TdtpFontRenderer);virtual;
  protected
    FFont: TdtpFont;
    FPoly: TdtpPolygon;
    function CheckFont: boolean;
    // added by J.F. Feb 2011 important bug fix
    procedure DoDelete; override;
    procedure DoModification; override;
    procedure SetDocument(const Value: TObject); override;
    procedure DoAfterLoad; override;
    function GetLineHeight: single; override;
    procedure GetTextExtent(APos, ALength: integer; var AWidth, AHeight: double); override;
    procedure CalculateCaretPositionsOfSpan(ASpan: TdtpTextSpan; ADpm: single); override;
    procedure PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext); override;
    procedure PrepareTextExtent; override;
    procedure PrepareCaretPositionCalculation(ADpm: single); override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  // abstract transfomable text (for curved / wavy text)
  TdtpTransFormText = class(TdtpPolygonText)
  private
    FTransformMethod: TTransformMethod;
    FBreakupPolygon: boolean;
    FScaleToTransform: boolean;
    FPolyWidth: double;  // in doc coords
    FPolyHeight: double; // in doc coords
    FGlyphs: TdtpGlyphPlacementList;
    procedure SetTransformMethod(const Value: TTransformMethod);
    procedure SetRenderProperties(ARenderer: TdtpFontRenderer);override;
  protected
    procedure BoundPolygon(var AWidth, AHeight: integer);
    procedure CalculateCaretPositionsOfSpan(ASpan: TdtpTextSpan; ADpm: single); override;
    procedure DoAfterLoad; override;
    procedure GetTextExtent(APos, ALength: integer; var AWidth, AHeight: double); override;
    function GetLineHeight: single; override;
    procedure PrepareTextExtent; override;
    procedure PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext); override;
    procedure PerformTransformationEffect(AWidth, AHeight: integer); virtual;
    procedure RegeneratePolygon; virtual;
    procedure SetPropertyByName(const AName, AValue: string); override;
    property Glyphs: TdtpGlyphPlacementList read FGlyphs;
    property BreakupPolygon: boolean read FBreakupPolygon write FBreakupPolygon;
    property ScaleToTransform: boolean read FScaleToTransform write FScaleToTransform;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property TransformMethod: TTransformMethod read FTransformMethod write SetTransformMethod;
  end;


  // Text that can be curved into a circle/ellipse
  TdtpCurvedText = class(TdtpTransFormText)
  private
    FCurveAngle: single;
    FSavedCurveAngle: single; //  added by J.F. July 2011
    procedure SetCurveAngle(const Value: single);
    function GetCurveAngle: single;
  protected
    procedure DoEditClose(Accept: boolean); override; //  added by J.F. July 2011
    procedure PerformTransformationEffect(AWidth, AHeight: integer); override;
    procedure SetPropertyByName(const AName, AValue: string); override;
  public
    constructor Create; override;
    procedure Edit; override; //  added by J.F. July 2011
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    // Set CurveAngle to a value between 0 and 180 to create a curved text around
    // a circle with angles going from -CurveAngle to +CurveAngle. Using a
    // minus sign in front of CurvedAngle will do the curve the other way.
    property CurveAngle: single read GetCurveAngle write SetCurveAngle;
  end;

  TWaveTransform = class(TPersistent)
  private
    FParent: TdtpPolygonText;
    FWaveLength: single;
    FSavedWaveLength: single; //  added by J.F. July 2011
    FWaveShift: single;
    FAmplitude: single;
    function GetWaveLength: single; //  added by J.F. July 2011
    procedure SetAmplitude(const Value: single);
    procedure SetWaveLength(const Value: single);
    procedure SetWaveShift(const Value: single);
  public
    constructor Create(AParent: TdtpPolygonText); virtual;
    procedure LoadFromXml(ANode: TXmlNodeOld); virtual;
    procedure SaveToXml(ANode: TXmlNodeOld); virtual;
    property WaveLength: single read GetWaveLength write SetWaveLength;
    property WaveShift: single read FWaveShift write SetWaveShift;
    property Amplitude: single read FAmplitude write SetAmplitude;
  end;

  // Text that creates a wavy effect as if under water 
  TdtpWavyText = class(TdtpTransFormText)
  private
    FWaveY: TWaveTransform;
    FWaveX: TWaveTransform;
  protected
    procedure DoEditClose(Accept: boolean); override; //  added by J.F. July 2011
    procedure PerformTransformationEffect(AWidth, AHeight: integer); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Edit; override; //  added by J.F. July 2011
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property WaveX: TWaveTransform read FWaveX;
    property WaveY: TWaveTransform read FWaveY;
  end;

// Polygon handling routines

procedure AddPolygonToPolygon(Base: TdtpPolygon; Addition: TdtpPolygon);
function BoundingBox(APolygon: TdtpPolygon; AIndex: integer = 0; ACount: integer = -1): TRect;
procedure ScalePolygon(APolygon: TdtpPolygon; AFactorX, AFactorY: single);

const

  cFontPixelsPerInch = 14400; // Used for internal rendering
  cFontAdjustFactor  = cFontPixelsPerInch / 72;

implementation

uses
  dtpDocument;

type
  // _Fixed Point array used for access to lowlevel windows structure
  TFXPArray = array[0..0] of TPOINTFX;
  PFXPArray = ^TFXPArray;

const

  // Identity 2x2 matrix used in font transforms
  cUnityMat2: TMAT2 = (
    eM11: (fract: 0; Value: 1); eM12: (fract: 0; Value: 0);
    eM21: (fract: 0; Value: 0); eM22: (fract: 0; Value: 1));

  cFixedIdentityMatrix: TFixedMatrix =
    (($10000, 0, 0),
     (0, $10000, 0),
     (0, 0, $10000));

  // Size of glyph buffer
  cGlyphBufSize = 16384; // 16K buffer size

  // Minimum segment size (in pixels, expressed as TFixed)
  cGlyphMinSegmentSize: TFixed = 2 * $10000;

function MultFixed(const M1, M2: TFixedMatrix): TFixedMatrix;
begin
  Result[0, 0] := FixedMul(M1[0, 0], M2[0, 0]) + FixedMul(M1[0, 1], M2[1, 0]) + FixedMul(M1[0, 2], M2[2, 0]);
  Result[0, 1] := FixedMul(M1[0, 0], M2[0, 1]) + FixedMul(M1[0, 1], M2[1, 1]) + FixedMul(M1[0, 2], M2[2, 1]);
  Result[0, 2] := FixedMul(M1[0, 0], M2[0, 2]) + FixedMul(M1[0, 1], M2[1, 2]) + FixedMul(M1[0, 2], M2[2, 2]);
  Result[1, 0] := FixedMul(M1[1, 0], M2[0, 0]) + FixedMul(M1[1, 1], M2[1, 0]) + FixedMul(M1[1, 2], M2[2, 0]);
  Result[1, 1] := FixedMul(M1[1, 0], M2[0, 1]) + FixedMul(M1[1, 1], M2[1, 1]) + FixedMul(M1[1, 2], M2[2, 1]);
  Result[1, 2] := FixedMul(M1[1, 0], M2[0, 2]) + FixedMul(M1[1, 1], M2[1, 2]) + FixedMul(M1[1, 2], M2[2, 2]);
  Result[2, 0] := FixedMul(M1[2, 0], M2[0, 0]) + FixedMul(M1[2, 1], M2[1, 0]) + FixedMul(M1[2, 2], M2[2, 0]);
  Result[2, 1] := FixedMul(M1[2, 0], M2[0, 1]) + FixedMul(M1[2, 1], M2[1, 1]) + FixedMul(M1[2, 2], M2[2, 1]);
  Result[2, 2] := FixedMul(M1[2, 0], M2[0, 2]) + FixedMul(M1[2, 1], M2[1, 2]) + FixedMul(M1[2, 2], M2[2, 2]);
end;

procedure AddPolygonToPolygon(Base: TdtpPolygon; Addition: TdtpPolygon);
var
  i: integer;
begin
  for i := 0 to High(Addition.Points) do
  begin
    Base.NewLine;
    Base.AddPoints(Addition.Points[i][0], Length(Addition.Points[i]));
  end;
end;

function BoundingBox(APolygon: TdtpPolygon; AIndex, ACount: integer): TRect;
var
  i, j: integer;
  IsSet: boolean;
begin
  Result.Left   :=  $7F000000;
  Result.Right  := -$7F000000;
  Result.Top    :=  $7F000000;
  Result.Bottom := -$7F000000;
  if ACount = -1 then
  begin
    AIndex := 0;
    ACount := Length(APolygon.Points);
  end;
  // Find maxima & minima
  IsSet := False;
  for i := AIndex to AIndex + ACount - 1 do
    for j := 0 to High(APolygon.Points[i]) do
    begin
      Result.Left   := Min(Result.Left  , APolygon.Points[i][j].X);
      Result.Right  := Max(Result.Right , APolygon.Points[i][j].X);
      Result.Top    := Min(Result.Top   , APolygon.Points[i][j].Y);
      Result.Bottom := Max(Result.Bottom, APolygon.Points[i][j].Y);
      IsSet := True;
    end;
  // Check if polygon contained any points
  if not IsSet then
  begin
    Result.Left   := 0;
    Result.Right  := 0;
    Result.Top    := 0;
    Result.Bottom := 0;
  end;
end;

procedure ScalePolygon(APolygon: TdtpPolygon; AFactorX, AFactorY: single);
var
  i, j: integer;
  FFactorX, FFactorY: TFixed;
begin
  FFactorX := Fixed(AFactorX);
  FFactorY := Fixed(AFactorY);
  for i := 0 to high(APolygon.Points) do
    for j := 0 to high(APolygon.Points[i]) do
    begin
      APolygon.Points[i][j].X := FixedMul(APolygon.Points[i][j].X, FFactorX);
      APolygon.Points[i][j].Y := FixedMul(APolygon.Points[i][j].Y, FFactorY);
    end;
end;

{ TdtpPolygonText }

procedure TdtpPolygonText.CalculateCaretPositionsOfSpan(
  ASpan: TdtpTextSpan; ADpm: single);
var
  ARenderer: TdtpFontRenderer;
begin
  if not CheckFont then
    exit;

  ARenderer := TdtpFontRenderer.Create(FFont);
  try
    // Renderer properties
    SetRenderProperties(ARenderer);

    ARenderer.GetCharacterPositions(ASpan.Text, @FCaretPositions[ASpan.CharPos - 1]);

  finally
    ARenderer.Free;
  end;
end;

function TdtpPolygonText.CheckFont: boolean;
begin
  // No font? we must get it
  if not assigned(FFont) then
    GetFont;
  // Still no font? we must exit in that case
  Result := assigned(FFont);
end;

constructor TdtpPolygonText.Create;
begin
  inherited;
  // Create owned objects
  FPoly := TdtpPolygon.Create;
  // Defaults
  FPoly.Antialiased := True;
end;

destructor TdtpPolygonText.Destroy;
begin
  FreeAndNil(FPoly);
  inherited;
end;

procedure TdtpPolygonText.DoDelete;
// added by J.F. Feb 2011
begin
  inherited;
  // make sure referencecount is decremented (FontEmbedding Fix)
  if assigned(Document) then
    TdtpDocument(Document).FontManager.RemoveFontReference(FontName, FontStyle);
end;

procedure TdtpPolygonText.DoAfterLoad;
begin
  inherited;
  // In the loader, only FFontName is set, so we must still get the correct font
  GetFont;
end;

procedure TdtpPolygonText.DoModification;
begin
  GetFont;
  inherited;
end;

procedure TdtpPolygonText.GetFont;
begin
  if assigned(Document) then
    FFont := TdtpDocument(Document).FontManager.FontByNameAndStyle(FontName, FontStyle, FFont);
end;

function TdtpPolygonText.GetLineHeight: single; // added by J.F.
begin
  Result := 0;
  if CheckFont then
     Result := FFont.GetLineHeight(FontHeight) * LineHeight;
end;

procedure TdtpPolygonText.GetTextExtent(APos, ALength: integer; var AWidth,
  AHeight: double);
var
  ARenderer: TdtpFontRenderer;
begin
  AWidth := 0;
  AHeight := 0;
  if not CheckFont then
    exit;

  ARenderer := TdtpFontRenderer.Create(FFont);
  try
    // Renderer properties
    SetRenderProperties(ARenderer);

    // Get the text extent device independently

    ARenderer.TextExtent(copyWide(Text, APos, ALength), AWidth, AHeight);

    if (AWidth = 0) and (SpanCount < 2) then // changed by J.F. Apr 2011
      // added by JF: give it an minimal acceptable visual width. "I" is not to big as with "W"
      ARenderer.TextExtent('I', AWidth, AHeight); // changed by J.F. Apr 2011
    
  finally
    ARenderer.Free;
  end;
end;

procedure TdtpPolygonText.SetRenderProperties(ARenderer: TdtpFontRenderer);
begin
  // Renderer properties
  ARenderer.FontHeight := FontHeight;
  ARenderer.CorrectBlackBox := True;
  ARenderer.CharacterSpacing := CharacterSpacing;
  ARenderer.WordSpacing := WordSpacing;
  ARenderer.UseKerning := UseKerning;
end;

procedure TdtpPolygonText.PrepareCaretPositionCalculation(ADpm: single);
begin
// do nothing
end;

procedure TdtpPolygonText.PrepareTextExtent;
begin
// do nothing
end;

procedure TdtpPolygonText.PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext);
var
  i: integer;
  ARenderer: TdtpFontRenderer;
  ASpan: TdtpTextSpan;
  PosD: TdtpPoint;
begin
  if not CheckFont then
    exit;

  ARenderer := TdtpFontRenderer.Create(FFont);
  try

    // Renderer properties
    SetRenderProperties(ARenderer);

    // Loop through spans
    for i := 0 to SpanCount - 1 do
    begin
      ASpan := Spans[i];

      // Position on device DIB
      PosD := ShapeToFloat(dtpPoint(ASpan.Left, ASpan.Top + ARenderer.Ascent));

      // We draw each line as a new polygon
      FPoly.Clear;
      ARenderer.TextToPolygon(
        PosD.X,
        PosD.Y,
        Transform.Matrix.A,
        ASpan.Text,
        FPoly);

      // Now draw the polygon
      dtpSetPolyFillMode(FPoly, dtppfWinding);
      //FPoly.FillMode := pfWinding;
      FPoly.DrawFill(DIB, dtpColor(FontColor));

    end;
  finally
    ARenderer.Free;
  end;
end;

procedure TdtpPolygonText.SetDocument(const Value: TObject);
begin
  inherited;
  // part of bug fix with FontEmbedding = true
  // added by J.F. Feb 2011 - see changes in dtpTruetypefonts also
  if assigned(Document) then
    // We do this to ensure font data is retrieved from Document.FontManager
    DoModification;
end;

{ TdtpTransformText }

constructor TdtpTransformText.Create();
begin
  inherited;
  FGlyphs := TdtpGlyphPlacementList.Create;
end;

destructor TdtpTransformText.Destroy();
begin
  inherited;
  FreeAndNil(FGlyphs);
end;

procedure TdtpTransformText.BoundPolygon(var AWidth, AHeight: integer);
// Make sure the polygon does stay below and to the right of 0,0 and return
// the width and height
var
  ARect: TRect;
begin
  if length(FPoly.Points) = 0 then
    exit;
  ARect := BoundingBox(FPoly);
  AWidth  := ARect.Right - ARect.Left;
  AHeight := ARect.Bottom - ARect.Top;
  if (ARect.Left = 0) and (ARect.Top = 0) then
    exit;
  FPoly.Offset(-ARect.Left, -ARect.Top);
end;

procedure TdtpTransformText.CalculateCaretPositionsOfSpan(
  ASpan: TdtpTextSpan; ADpm: single);
var
  i: integer;
  AText: widestring;
begin
  AText := ASpan.Text;
  if length(AText) = 0 then
    exit;

  // Use the glyph info for caret position
  for i := 0 to ASpan.CharCount - 1 do
    FCaretPositions[ASpan.CharPos + i - 1].X := FGlyphs[ASpan.CharPos + i - 1].Left / $10000;
  FCaretPositions[ASpan.CharPos + ASpan.CharCount - 1].X :=
    FGlyphs[ASpan.CharPos + ASpan.CharCount - 2].Right / $10000;
end;

procedure  TdtpTransformText.DoAfterLoad;
begin
  inherited;
  // Regenerate the polygon
  RegeneratePolygon;
end;

procedure TdtpTransformText.PrepareTextExtent;
begin
  // We call regeneratepolygon to get a new correct polygon
  RegeneratePolygon;
end;

procedure TdtpTransformText.GetTextExtent(APos, ALength: integer; var AWidth, AHeight: double);
begin
  AWidth  := FPolyWidth;
  AHeight := FPolyHeight;
end;

function TdtpTransformText.GetLineHeight: single;
// added by JF
begin
  // make it pretty
  if IsEditing then
    Result:= DocHeight
  else
    Result := Spans[0].Height;
end;

procedure TdtpTransformText.SetPropertyByName(const AName, AValue: string);
begin
  inherited;
  if AnsiCompareText(AName, 'TransformMethod') = 0 then
    TransformMethod := TTransformMethod(StrToInt(AValue));
end;

procedure TdtpTransformText.RegeneratePolygon;
// Regenerate the internal polygon. This procedure does not change any shape
// bounds, this is not allowed in a regeneration. It just updates the polygon
// and does the transformations
// Additions/changes by JF
var
  ARenderer: TdtpFontRenderer;
  AWidth, AHeight: integer;
  ATestWidth: integer; 
  ATestHeight: integer; 
  TestWidth: double; 
  TestHeight: double; 
begin
  if not CheckFont then
    exit;

  // Clear previous polygon
  FPoly.Clear;

  ARenderer := TdtpFontRenderer.Create(FFont);
  try
    // Set Renderer properties
    SetRenderProperties(ARenderer);

    // Let the font create new polygon
    ARenderer.TextToPolygon(0, ARenderer.Ascent, 1.0, Text, FPoly);

    TestWidth := 0;
    TestHeight := 0;
    ARenderer.TextExtent('Www', TestWidth, TestHeight);
    ATestWidth := round(TestWidth * $10000);
    ATestHeight := round(TestHeight * $10000);

    ARenderer.TextExtent(Text, FPolyWidth, FPolyHeight);
    AWidth := round(FPolyWidth * $10000);
    if AWidth < ATestWidth then 
    begin                   
      // give it an minimal acceptable visual width
      AWidth:= ATestWidth;
      FPolyWidth:= TestWidth; 
    end;
    AHeight := round(FPolyHeight * $10000);

    // Do the polygon transformation
    PerformTransformationEffect(AWidth, AHeight);

    // Scale it so it fits neatly and adjust our bounds
    if FScaleToTransform then
    begin
      BoundPolygon(AWidth, AHeight);
      if AWidth > ATestWidth then 
        FPolyWidth := AWidth / $10000;
      if AHeight > ATestHeight then 
        FPolyHeight := AHeight / $10000;
    end;

  finally
    ARenderer.Free;
  end;
end;

procedure TdtpTransformText.PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext);
var
  i, j: integer;
  ADraw: TdtpPolygon;
  ATrans: TFixedTransform;
begin
  // First of all we create a drawing polygon that is constructed from the
  // internal polygon by applying the transform matrix
  ADraw := TdtpPolygon.Create;
  ATrans := TFixedTransform.Create;
  try
    ADraw.Antialiased := True;
    // Setup transformation
    ATrans.FMatrix[0, 0] := round(Transform.Matrix.A * $10000);
    ATrans.FMatrix[1, 0] := round(Transform.Matrix.B * $10000);
    ATrans.FMatrix[0, 1] := round(Transform.Matrix.C * $10000);
    ATrans.FMatrix[1, 1] := round(Transform.Matrix.D * $10000);
    ATrans.FMatrix[0, 2] := round(Transform.Matrix.E * $10000);
    ATrans.FMatrix[1, 2] := round(Transform.Matrix.F * $10000);

    // Transform each point
    for i := 0 to High(FPoly.Points) do
    begin
      SetLength(ADraw.Points[i], length(FPoly.Points[i]));
      for j := 0 to High(FPoly.Points[i]) do
      begin
        ADraw.Points[i, j] := ATrans.TransformPoint(FPoly.Points[i, j]);
      end;
      if i < High(FPoly.Points) then
        ADraw.NewLine;
    end;

    // Draw the polygon
    dtpSetPolyFillMode(ADraw, dtppfWinding);
    ADraw.DrawFill(DIB, dtpColor(FontColor));

  finally
    ADraw.Free;
    ATrans.Free;
  end;
end;

procedure TdtpTransformText.PerformTransformationEffect(AWidth, AHeight: integer);
begin
// Default does nothing
end;

procedure TdtpTransformText.SetTransformMethod(const Value: TTransformMethod);
begin
  if FTransformMethod <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'TransformMethod', integer(FTransformMethod));
    FTransformMethod := Value;
    FBreakupPolygon := FTransformMethod = tmPoints;
    DoModification;
  end;
end;

procedure TdtpTransformText.SetRenderProperties(ARenderer: TdtpFontRenderer);
begin
  inherited;
  ARenderer.GlyphPlacement := FGlyphs;
  if FBreakupPolygon then
    ARenderer.BreakupLength := 1; // 1 pixel
end;

procedure TdtpTransformText.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  TransformMethod := TTransformMethod(ANode.ReadInteger('TransformMethod'));
end;

procedure TdtpTransformText.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteInteger('TransformMethod', integer(FTransformMethod));
end;


{ TdtpCurvedText }

constructor TdtpCurvedText.Create;
begin
  inherited;
  // Defaults
  FTransformMethod := tmGlyphs;
  FScaleToTransform := True;
  FBreakupPolygon := True;
end;

procedure TdtpCurvedText.DoEditClose(Accept: boolean); //  added by J.F. July 2011
begin
  inherited DoEditClose(Accept);
  FCurveAngle:= FSavedCurveAngle;
  DoModification;
end;

procedure TdtpCurvedText.Edit;  //  added by J.F. July 2011
begin
  FSavedCurveAngle:= FCurveAngle;
  inherited;
  FCurveAngle:= 0;
  DoModification;
end;

function TdtpCurvedText.GetCurveAngle: single; //  added by J.F. July 2011
begin
  if IsEditing then
    Result:= FSavedCurveAngle
  else
    Result:= FCurveAngle;
end;

procedure TdtpCurvedText.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  CurveAngle := ANode.ReadFloat('CurveAngle', FCurveAngle);
end;

procedure TdtpCurvedText.PerformTransformationEffect(AWidth, AHeight: integer);
var
  i, j, k: integer;
  Radius, OneDivR, Alpha, R: single;
  WidthS: single;
  ATrans: TFixedTransform;
  OldCenterX, OldCenterY, NewCenterX, NewCenterY: TFixed;
begin
  //if CurveAngle = 0 then
  if FCurveAngle = 0 then  //  changed by J.F. July 2011
    exit;
  if AWidth * AHeight = 0 then
    exit;

  if TransformMethod = tmPoints then
  begin

    // Do a transformation for all points individually
    if CurveAngle > 0 then
    begin
      FPoly.Offset(- AWidth div 2, -AHeight);
      WidthS  := AWidth / $10000;
      Radius  :=  (WidthS * 180) / (2 * CurveAngle * pi);
      OneDivR :=  1 / Radius;
      for i := 0 to high(FPoly.Points) do
        for j := 0 to high(FPoly.Points[i]) do
        begin
          // Find R and Alpha
          R := Radius - FPoly.Points[i, j].Y / $10000;
          Alpha := -OneDivR * FPoly.Points[i, j].X / $10000;
          // Do the transform
          FPoly.Points[i, j].X := -round(sin(Alpha) * R * $10000);
          FPoly.Points[i, j].Y := -round(cos(Alpha) * R * $10000);
        end;
    end else
    begin
      FPoly.Offset(- AWidth div 2, 0);
      WidthS  := AWidth / $10000;
      Radius  :=  -(WidthS * 180) / (2 * CurveAngle * pi);
      OneDivR :=  1 / Radius;
      for i := 0 to high(FPoly.Points) do
        for j := 0 to high(FPoly.Points[i]) do
        begin
          // Find R and Alpha
          R := Radius + FPoly.Points[i, j].Y / $10000;
          Alpha := -OneDivR * FPoly.Points[i, j].X / $10000;
          // Do the transform
          FPoly.Points[i, j].X := -round(sin(Alpha) * R * $10000);
          FPoly.Points[i, j].Y := round(cos(Alpha) * R * $10000);
        end;
    end;

  end else
  begin

    // Do a transformation per glyph
    ATrans := TFixedTransform.Create;
    try
      for i := 0 to Glyphs.Count - 1 do
      begin
        ATrans.Clear;
        WidthS  := AWidth / $10000;
        OldCenterX := (Glyphs[i].Right + Glyphs[i].Left) div 2;
        // Find R and Alpha
        Radius := (WidthS * 180) / (2 * CurveAngle * pi);
        OneDivR :=  1 / Radius;
        Alpha := -OneDivR * (OldCenterX - AWidth div 2) / $10000;
        // Do the transform
        NewCenterX := -round(sin(Alpha) * Radius * $10000);
        NewCenterY := -round(cos(Alpha) * Radius * $10000);
        if CurveAngle > 0 then
          OldCenterY := round(AHeight * 0.7)
        else
          OldCenterY := round(AHeight * 0.3);
        // Setup glyph transform
        ATrans.Rotate(OldCenterX, OldCenterY, Alpha);
        ATrans.Translate(NewCenterX - OldCenterX, NewCenterY - OldCenterY);
        // Transform the points in this glyph
        for j := Glyphs[i].PolygonIndex to Glyphs[i].PolygonIndex + Glyphs[i].PolygonCount - 1 do
          for k := 0 to high(FPoly.Points[j]) do
            FPoly.Points[j, k] := ATrans.TransformPoint(FPoly.Points[j, k]);
      end;
    finally
      ATrans.Free;
    end;

  end;
end;

procedure TdtpCurvedText.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteFloat('CurveAngle', FCurveAngle);
end;

procedure TdtpCurvedText.SetCurveAngle(const Value: single);
begin
  if FCurveAngle <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'CurveAngle', FCurveAngle);
    FCurveAngle := Value;
    DoModification;
  end;
end;

procedure TdtpCurvedText.SetPropertyByName(const AName, AValue: string);
begin
  inherited;
  if AnsiCompareText(AName, 'CurveAngle') = 0 then CurveAngle := FloatFrom(AValue);
end;

{ TFixedTransform }

procedure TFixedTransform.Clear;
begin
  // Set to unity matrix
  FMatrix := cFixedIdentityMatrix;
end;

constructor TFixedTransform.Create;
begin
  inherited Create;
  Clear;
end;

procedure TFixedTransform.Rotate(Cx, Cy: TFixed; Angle: double);
var
  M: TFixedMatrix;
  CosA, SinA: TFixed;
begin
  if (Cx <> 0) or (Cy  <> 0) then
    Translate(-Cx, -Cy);
  CosA := round(cos(Angle) * $10000);
  SinA := round(sin(Angle) * $10000);
  M := cFixedIdentityMatrix;
  M[0, 0] :=  CosA; M[0, 1] := SinA;
  M[1, 0] := -SinA; M[1, 1] := CosA;
  FMatrix := MultFixed(M, FMatrix);
  if (Cx <> 0) or (Cy  <> 0) then
    Translate(Cx, Cy);
end;

function TFixedTransform.TransformPoint(APoint: TdtpFixedPoint): TdtpFixedPoint;
var
  AOrig: TdtpFixedPoint;
begin
  AOrig := APoint;
  Result.X := FixedMul(FMatrix[0, 0], APoint.X) + FixedMul(FMatrix[0, 1], APoint.Y) + FMatrix[0, 2];
  Result.Y := FixedMul(FMatrix[1, 0], APoint.X) + FixedMul(FMatrix[1, 1], APoint.Y) + FMatrix[1, 2];
end;

procedure TFixedTransform.Translate(Dx, Dy: TFixed);
var
  M: TFixedMatrix;
begin
  M := cFixedIdentityMatrix;
  M[0, 2] := Dx;
  M[1, 2] := Dy;
  FMatrix := MultFixed(M, FMatrix);
end;

{ TWaveTransform }

constructor TWaveTransform.Create(AParent: TdtpPolygonText);
begin
  inherited Create;
  FParent := AParent;
end;

function TWaveTransform.GetWaveLength: single;  //  added by J.F. July 2011
begin
  if assigned(FParent) and FParent.IsEditing then
    Result:= FSavedWaveLength
  else
    Result:= FWaveLength;
end;

procedure TWaveTransform.LoadFromXml(ANode: TXmlNodeOld);
begin
  FWaveLength := ANode.ReadFloat('WaveLength');
  FWaveShift  := ANode.ReadFloat('WaveShift');
  FAmplitude  := ANode.ReadFloat('Amplitude');
end;

procedure TWaveTransform.SaveToXml(ANode: TXmlNodeOld);
begin
  ANode.WriteFloat('WaveLength', FWaveLength);
  ANode.WriteFloat('WaveShift', FWaveShift);
  ANode.WriteFloat('Amplitude', FAmplitude);
end;

procedure TWaveTransform.SetAmplitude(const Value: single);
begin
  if FAmplitude <> Value then
  begin
    FAmplitude := Value;
    if assigned(FParent) then
      FParent.DoModification
  end;
end;

procedure TWaveTransform.SetWaveLength(const Value: single);
begin
  if FWaveLength <> Value then
  begin
    FWaveLength := Value;
    if assigned(FParent) then
      FParent.DoModification
  end;
end;

procedure TWaveTransform.SetWaveShift(const Value: single);
begin
  if FWaveShift <> Value then
  begin
    FWaveShift := Value;
    if assigned(FParent) then
      FParent.DoModification
  end;
end;

{ TdtpWavyText }

constructor TdtpWavyText.Create;
begin
  inherited;
  // Owned objects
  FWaveX := TWaveTransform.Create(Self);
  FWaveY := TWaveTransform.Create(Self);
  // We do this because in wavy text it is important that straight lines
  // can become curves
  FBreakupPolygon := True;
  FScaleToTransform := True;
end;

destructor TdtpWavyText.Destroy;
begin
  FreeAndNil(FWaveX);
  FreeAndNil(FWaveY);
  inherited;
end;

procedure TdtpWavyText.DoEditClose(Accept: boolean); //  added by J.F. July 2011
begin
  FWaveX.WaveLength:= FWaveX.FSavedWaveLength;
  FWaveY.WaveLength:= FWaveY.FSavedWaveLength;
  inherited DoEditClose(Accept);
end;

procedure TdtpWavyText.Edit;  //  added by J.F. July 2011
begin
  FWaveX.FSavedWaveLength:= FWaveX.FWaveLength;
  FWaveY.FSavedWaveLength:= FWaveY.FWaveLength;
  FWaveX.FWaveLength:= 0;
  FWaveY.FWaveLength:= 0;
  DoModification;
  inherited;
end;

procedure TdtpWavyText.LoadFromXml(ANode: TXmlNodeOld);
var
  AChild: TXmlNodeOld;
begin
  inherited;
  AChild := ANode.NodeByName('WaveX');
  if assigned(AChild) then
    FWaveX.LoadFromXml(AChild);
  AChild := ANode.NodeByName('WaveY');
  if assigned(AChild) then
    FWaveY.LoadFromXml(AChild);
end;

procedure TdtpWavyText.PerformTransformationEffect(AWidth,
  AHeight: integer);
var
  i, j: integer;
  WaveX, WaveY: boolean;
  Orig: TdtpFixedPoint;
begin
  // Determine which axes to wave
  {WaveX := assigned(FWaveX) and (FWaveX.WaveLength > 0) and (FWaveX.Amplitude <> 0);
  WaveY := assigned(FWaveY) and (FWaveY.WaveLength > 0) and (FWaveY.Amplitude <> 0); }

                  //  changed by J.F. July 2011
  WaveX := assigned(FWaveX) and (FWaveX.FWaveLength > 0) and (FWaveX.Amplitude <> 0);
  WaveY := assigned(FWaveY) and (FWaveY.FWaveLength > 0) and (FWaveY.Amplitude <> 0);
  
  if not (WaveX or WaveY) then exit;
  // Loop through points and wave the axes
  for i := 0 to high(FPoly.Points) do
    for j := 0 to high(FPoly.Points[i]) do
    begin
      Orig := FPoly.Points[i, j];
      // Do the transform
      if WaveX then
        FPoly.Points[i, j].Y := Orig.Y - round(FWaveX.Amplitude *
          sin(2 * pi / FWaveX.WaveLength * (Orig.X / $10000 + FWaveX.WaveShift)) * $10000);
      if WaveY then
        FPoly.Points[i, j].X := Orig.X - round(FWaveY.Amplitude *
          sin(2 * pi / FWaveY.WaveLength * (Orig.Y / $10000 + FWaveY.WaveShift)) * $10000);
    end;

end;

procedure TdtpWavyText.SaveToXml(ANode: TXmlNodeOld);
var
  AChild: TXmlNodeOld;
begin
  inherited;
  AChild := ANode.NodeNew('WaveX');
  FWaveX.SaveToXml(AChild);
  AChild := ANode.NodeNew('WaveY');
  FWaveY.SaveToXml(AChild);
end;

initialization

  RegisterShapeClass(TdtpPolygonText);
  RegisterShapeClass(TdtpCurvedText);
  RegisterShapeClass(TdtpWavyText);

end.

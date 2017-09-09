{ Unit dtpTrueTypeFonts

  dtpTrueTypeFonts implements Truetype font handling using Windows GDI functions to
  extract the polygons of fonts in a device-independent way.

  First, create or add the TdtpFontRenderer component to your form or component,
  then obtain a TdtpFont reference using method FontByNameAndStyle.

  Create a TdtpFontRenderer using this font and use that to measure text, output
  text to a TPolygon32, etc.

  Project: DTP-Engine

  Creation Date: 15Jan2006 (NH)
  Version: 1.0

  Modifications:
  JF feb 2011: ClearFontList

  Copyright (c) 2006 - 2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpTruetypeFonts;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, Contnrs, Graphics, Windows, sdSortedLists, dtpGraphics, 
  dtpDefaults, Math;

type

  TdtpFont = class;

  TdtpWindingDirectionType = (
    wdNotSet,
    wdClockwise,
    wdCounterClockwise
  );

  // TdtpGlyph contains information about one specific glyph in a font
  TdtpGlyph = class(TPersistent)
  private
    FChar: widechar;
    FIncX: integer;
    FIncY: integer;
    FBlackBoxLeft: integer;
    FBlackBoxTop: integer;
    FBlackBoxWidth: integer;
    FBlackBoxHeight: integer;
    FParent: TdtpFont;
    FPolygon: TdtpPolygon;
  protected
    procedure LoadFromStream(S: TStream);
    procedure SaveToStream(S: TStream);
  public
    constructor Create(AParent: TdtpFont); virtual;
    destructor Destroy; override;
    function DetectWindingDirection: TdtpWindingDirectionType;
    property Char: widechar read FChar write FChar;
    property IncX: integer read FIncX write FIncX;
    property IncY: integer read FIncY write FIncY;
    property BlackboxLeft: integer read FBlackboxLeft write FBlackboxLeft;
    property BlackboxTop: integer read FBlackboxTop write FBlackboxTop;
    property BlackboxWidth: integer read FBlackboxWidth write FBlackboxWidth;
    property BlackboxHeight: integer read FBlackboxHeight write FBlackboxHeight;
    property Polygon: TdtpPolygon read FPolygon write FPolygon;
  end;

  TdtpGlyphList = class(TSortedList)
  private
    function CompareGlyph(Item1, Item2: TObject; Info: pointer): integer;
    function GetItems(Index: integer): TdtpGlyph;
  public
    constructor Create; virtual;
    function GlyphByChar(AChar: widechar): TdtpGlyph;
    property Items[Index: integer]: TdtpGlyph read GetItems; default;
  end;

  TdtpFontManager = class;

  // TdtpFont contains information about one specific font/face. The Name specifies
  // the Windows font name and Style specifies the font style (bold, italic, ..).
  // Do not create a TdtpFont object directly but use the FontManager.FontByNameAndStyle
  // method.
  TdtpFont = class(TPersistent)
  private
    FGlyphs: TdtpGlyphList;
    FParent: TdtpFontManager;
    FName: string;
    FStyle: TFontStyles;
    FHandle: HFont;
    FAscent: integer;
    FDescent: integer;
    FReferenceCount: integer;
    procedure ExtractGlyphOutline(Header: PTTPolygonHeader; BufSize: integer;
      Metrics: TGLYPHMETRICS; Poly: TdtpPolygon);
    procedure RegenerateQSpline(const P0, P1, P2: TdtpFixedPoint; Poly: TdtpPolygon);
  protected
    procedure CreateGDIFont;
    procedure GetGlyphPolygon(AGlyph: TdtpGlyph);
    function GlyphByChar(AChar: widechar): TdtpGlyph;
    property Glyphs: TdtpGlyphList read FGlyphs;
    procedure LoadFromStream(S: TStream);
    procedure SaveToStream(S: TStream);
  public
    constructor Create(AParent: TdtpFontManager); virtual;
    destructor Destroy; override;
    function GetLineHeight(FontHeight: double): double;
    property Name: string read FName;
    property Style: TFontStyles read FStyle;
  end;

  TdtpGlyphPlacement = class(TPersistent)
  private
    FLeft: TFixed;
    FRight: TFixed;
    FPolygonIndex: integer;
    FPolygonCount: integer;
  public
    // Position of leftmost point in glyph (fixed coords)
    property Left: TFixed read FLeft write FLeft;
    // Position of rightmost point in glyph (fixed coords)
    property Right: TFixed read FRight write FRight;
    // Index to first polygon of glyph in polypolygon.
    property PolygonIndex: integer read FPolygonIndex write FPolygonIndex;
    // Number of polygons in glyph
    property PolygonCount: integer read FPolygonCount write FPolygonCount;
  end;

  TdtpGlyphPlacementList = class(TObjectList)
  private
    function GetItems(Index: integer): TdtpGlyphPlacement;
  public
    property Items[Index: integer]: TdtpGlyphPlacement read GetItems; default;
  end;

  // Use the TdtpFontRenderer to render text to a TPolygon32. Before using
  // this class make sure to have a valid font reference (TdtpFont).
  TdtpFontRenderer = class(TPersistent)
  private
    FFont: TdtpFont;
    FUseKerning: boolean;
    FCorrectBlackBox: boolean;
    FCharacterSpacing: double;
    FFontHeight: double;
    FBreakupLength: double;
    FGlyphPlacement: TdtpGlyphPlacementList;
    FWordSpacing: double;
    function GetAscent: double;
    function GetLineHeight: double;
  public
    // Create a font renderer with reference AFont to a TdtpFont object.
    constructor Create(AFont: TdtpFont); virtual;
    // Use TextExtent to get the text width and height of AText, taking into
    // account all the properties of the renderer.
    procedure TextExtent(const AText: widestring; var AWidth, AHeight: double);
    // Add polygons in the form of text to a TPolygon32 object, starting on position
    // X,Y, and using a scale factor on the font of RenderScale. AText will be
    // added to the polygon, so multiple texts can be added subsequently. Make
    // sure to first set all the properties correctly. X and Y specify the start
    // of the baseline.
    procedure TextToPolygon(const X, Y, RenderScale: double; const AText: widestring; APoly: TdtpPolygon);
    // Find the character positions of the individual characters in AText. The first
    // position returned is before the first character, and the last position returned
    // is after the last character. So in total Character + 1 positions are returned.
    // FirstPoint is a pointer to the first point in a TFloatPoint array.
    procedure GetCharacterPositions(const AText: widestring; FirstPoint: PdtpPoint);
    // Get the ascent (area above the baseline) for the font
    property Ascent: double read GetAscent;
    // Set BreakupLength to something bigger than 0 to cause the resulting polygons
    // to be broken up in line pieces not longer than BreakupLength.
    property BreakupLength: double read FBreakupLength write FBreakupLength;
    // Set Characterspacing to a percentage (0..1) of the text height to add
    // this percentage as extra whitespace between each character pair.
    property CharacterSpacing: double read FCharacterSpacing write FCharacterSpacing;
    // If CorrectBlackBox is set to True, corrections are made on text width and
    // rendering positions so that characters outside of the standard increment
    // are still shown (e.g. for italic characters at the end of the string)
    property CorrectBlackBox: boolean read FCorrectBlackBox write FCorrectBlackBox;
    // Specify the height of the font
    property FontHeight: double read FFontHeight write FFontHeight;
    // The GlyphPlacement list will get filled with additional info on glyph
    // placement after a call to TextToPolygon. The user must provide a reference
    // to a list owned by another object here. By default, this list is nil and
    // no additional info will be stored.
    property GlyphPlacement: TdtpGlyphPlacementList read FGlyphPlacement write FGlyphPlacement;
    // Get the line height (interline spacing) for the font
    property LineHeight: double read GetLineHeight;
    // Set UseKerning to True to use kerning (currently not implemented)
    property UseKerning: boolean read FUseKerning write FUseKerning;
    // Set WordSpacing to a percentage (0..1) of the text height to add
    // this percentage as extra whitespace between each word pair (currently
    // not implemented)
    property WordSpacing: double read FWordSpacing write FWordSpacing;
  end;

  TdtpFontList = class(TObjectList)
  private
    function GetItems(Index: integer): TdtpFont;
  public
    property Items[Index: integer]: TdtpFont read GetItems; default;
  end;

  // TdtpFontManager is a component that can be added to your form or component,
  // and which is able to create polygonised fonts. Use method FontByNameAndStyle
  // to get a reference to a font object.
  TdtpFontManager = class(TComponent)
  private
    FFonts: TdtpFontList;
    FDc: HDc;
    FDefaultFont: HFont;
    FCurrentFont: HFont;
    procedure SelectFont(AFont: HFont);
  protected
    function AddFont(const AName: string; const AStyle: TFontStyles): TdtpFont;
    procedure CleanupFonts;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ClearFontList;  // added by J.F. Feb 2011

    // Remove any reference to unused Fonts especially with FontEmbedding    added by J.F. Feb 2011  bug fix
    procedure RemoveFontReference(const AName: string; const AStyle: TFontStyles);
    // Select a Windows font name and a font style to obtain a reference to a new
    // font (TdtpFont). If the old font is no longer used by a text shape, pass
    // it in OldFont
    function FontByNameAndStyle(const AName: string; const AStyle: TFontStyles; OldFont: TdtpFont): TdtpFont;
    // Save the fonts in the font manager to a stream. Only the glyphs that are
    // used currently are saved.
    procedure SaveToStream(S: TStream);
    // Load the fonts in the font manager from a stream
    procedure LoadFromStream(S: TStream);
  end;

function Fixed(const Value: _FIXED): TFixed; overload;

function PolygonArea(const Poly: TdtpArrayOfFixedPoint): int64; overload;
function PolygonArea(const Poly: TdtpArrayOfArrayOfFixedPoint): int64; overload;

resourcestring

  sUnableToCreateFont      = 'Unable to create font with name "%s"';
  sFontFileCorrupt         = 'Font file is corrupt or incorrect';
  sFontFileVersionMismatch = 'Font file has unknown version';

implementation

type
  // _Fixed Point array used for access to lowlevel windows structure
  TFXPArray = array[0..0] of TPOINTFX;
  PFXPArray = ^TFXPArray;

const

  // The device height we select for the font
  cFontDeviceHeight = 1000;

  // Identity 2x2 matrix used in font transforms
  cUnityMat2: TMAT2 = (
    eM11: (fract: 0; Value: 1); eM12: (fract: 0; Value: 0);
    eM21: (fract: 0; Value: 0); eM22: (fract: 0; Value: 1));

  // Minimum segment size (in device, expressed as TFixed)
  cGlyphMinSegmentSize: TFixed = 20 * $10000;

function Fixed(const Value: _FIXED): TFixed;
begin
  Result := Value.Value * $10000 + Value.Fract;
end;

function PointsAreEqual(const P1, P2: TdtpFixedPoint): boolean;
begin
  Result := (P1.X = P2.X) and (P1.Y = P2.Y);
end;

function MidPoint(const p1, p2: TdtpFixedPoint): TdtpFixedPoint;
begin
  Result.x := (p1.x + p2.x) div 2;
  Result.y := (p1.y + p2.y) div 2;
end;

function TaxicabLength3Points(const x0, x1, x2 : TdtpFixedPoint): TFixed;
begin
 result := abs(x0.X - x1.x) + abs(x0.Y - x1.Y) +
           abs(x1.X - x2.x) + abs(x1.Y - x2.Y);
end;

function FixedDistance(P1, P2: TdtpFixedPoint): TFixed;
var
  Dx, Dy: TFixed;
  Dxf, Dyf: double;
begin
  Dx := P2.X - P1.X;
  Dy := P2.Y - P1.Y;
  if Dx = 0 then
  begin
    Result := abs(Dy);
    exit;
  end;
  if Dy = 0 then
  begin
    Result := abs(Dx);
    exit;
  end;
  Dxf := Dx;
  Dyf := Dy;
  Result := round(sqrt(sqr(Dxf) + sqr(Dyf)));
end;

function ReadStringFromStream(S: TStream): Utf8String;
var
  ACount: integer;
begin
  Result := '';
  S.Read(ACount, SizeOf(ACount));
  SetLength(Result, ACount * SizeOf(AnsiChar));
  if ACount > 0 then
    S.Read(Result[1], ACount * SizeOf(AnsiChar));
end;

procedure WriteStringToStream(S: TStream; const AString: Utf8String);
var
  ACount: integer;
begin
  ACount := length(AString);
  S.Write(ACount, SizeOf(ACount));
  if ACount > 0 then
    S.Write(AString[1], ACount * SizeOf(AnsiChar));
end;

procedure ReadPolygonFromStream(S: TStream; FPolygon: TdtpPolygon);
var
  i, ACount: integer;
begin
  S.Read(ACount, SizeOf(ACount));
  while length(FPolygon.Points) < ACount do
    FPolygon.NewLine;
  for i := 0 to ACount - 1 do
  begin
    S.Read(ACount, SizeOf(ACount));
    SetLength(FPolygon.Points[i], ACount);
    if ACount > 0 then
      S.Read(FPolygon.Points[i, 0], ACount * SizeOf(TdtpFixedPoint));
  end;
end;

procedure WritePolygonToStream(S: TStream; FPolygon: TdtpPolygon);
var
  i, ACount: integer;
begin
  ACount := length(FPolygon.Points);
  S.Write(ACount, SizeOf(ACount));
  for i := 0 to ACount - 1 do
  begin
    ACount := length(FPolygon.Points[i]);
    S.Write(ACount, SizeOf(ACount));
    if ACount > 0 then
      S.Write(FPolygon.Points[i, 0], ACount * SizeOf(TdtpFixedPoint));
  end;
end;

function PolygonArea(const Poly: TdtpArrayOfFixedPoint): int64;
var
  i, Count: integer;
  function Cross(X1, Y1, X2, Y2: int64): int64;
  begin
    Result := X1 * Y2 - X2 * Y1;
  end;
begin
  Result := 0;
  Count := length(Poly);
  if Count < 3 then exit;
  for i := 0 to Count - 1 do
  begin
    inc(Result, Cross(
      Poly[i].X, Poly[i].Y,
      Poly[(i + 1) mod Count].X - Poly[i].X,
      Poly[(i + 1) mod Count].Y - Poly[i].Y));
  end;
end;

function PolygonArea(const Poly: TdtpArrayOfArrayOfFixedPoint): int64;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to length(Poly) - 1 do
    inc(Result, PolygonArea(Poly[i]));
end;

{ TdtpGlyph }

constructor TdtpGlyph.Create(AParent: TdtpFont);
begin
  inherited Create;
  FParent := AParent;
end;

destructor TdtpGlyph.Destroy;
begin
  FreeAndNil(FPolygon);
  inherited;
end;

function TdtpGlyph.DetectWindingDirection: TdtpWindingDirectionType;
var
  Area: int64;
begin
  Result := wdNotSet;
  if assigned(FPolygon) then
  begin
    Area := PolygonArea(FPolygon.Points);
    if Area > 0 then
      Result := wdClockwise
    else
      if Area < 0 then
        Result := wdCounterClockwise;
  end;
end;

procedure TdtpGlyph.LoadFromStream(S: TStream);
var
  HasPoly: boolean;
begin
  S.Read(FChar, SizeOf(FChar));
  S.Read(FIncX, SizeOf(FIncX));
  S.Read(FIncY, SizeOf(FIncY));
  S.Read(FBlackBoxLeft, SizeOf(FBlackBoxLeft));
  S.Read(FBlackBoxTop, SizeOf(FBlackBoxTop));
  S.Read(FBlackBoxWidth, SizeOf(FBlackBoxWidth));
  S.Read(FBlackBoxHeight, SizeOf(FBlackBoxHeight));
  S.Read(HasPoly, SizeOf(HasPoly));
  if HasPoly then
  begin
    FPolygon := TdtpPolygon.Create;
    ReadPolygonFromStream(S, FPolygon);
  end;
end;

procedure TdtpGlyph.SaveToStream(S: TStream);
var
  HasPoly: boolean;
begin
  S.Write(FChar, SizeOf(FChar));
  S.Write(FIncX, SizeOf(FIncX));
  S.Write(FIncY, SizeOf(FIncY));
  S.Write(FBlackBoxLeft, SizeOf(FBlackBoxLeft));
  S.Write(FBlackBoxTop, SizeOf(FBlackBoxTop));
  S.Write(FBlackBoxWidth, SizeOf(FBlackBoxWidth));
  S.Write(FBlackBoxHeight, SizeOf(FBlackBoxHeight));
  HasPoly := assigned(FPolygon);
  S.Write(HasPoly, SizeOf(HasPoly));
  if HasPoly then
    WritePolygonToStream(S, FPolygon);
end;

{ TdtpGlyphList }

function TdtpGlyphList.CompareGlyph(Item1, Item2: TObject;
  Info: pointer): integer;
var
  C1, C2: word;
begin
  C1 := ord(TdtpGlyph(Item1).Char);
  C2 := ord(TdtpGlyph(Item2).Char);
  if C1 < C2 then
    Result := -1
  else
    if C1 = C2 then
      Result := 0
    else
      Result := 1;
end;

constructor TdtpGlyphList.Create;
begin
  inherited Create;
  OnCompare := CompareGlyph;
end;

function TdtpGlyphList.GetItems(Index: integer): TdtpGlyph;
begin
  Result := Get(Index);
end;

function TdtpGlyphList.GlyphByChar(AChar: widechar): TdtpGlyph;
var
  AGlyph: TdtpGlyph;
  Index: integer;
begin
  // Find the glyph
  Result := nil;
  AGlyph := TdtpGlyph.Create(nil);
  try
    AGlyph.Char := AChar;
    if Find(AGlyph, Index) then
      Result := Get(Index);
  finally
    AGlyph.Free;
  end;
end;

{ TdtpFont }

constructor TdtpFont.Create(AParent: TdtpFontManager);
begin
  inherited Create;
  FParent := AParent;
  FGlyphs := TdtpGlyphList.Create;
end;

//GB Edit:  Replaced CreateGDIFont procedure
procedure TdtpFont.CreateGDIFont;
const
  cBoldValue: array[boolean] of integer = (400, 700);
var
  BufSize, Res: integer;
  Metrics: POutlineTextMetric;
begin
  if FHandle = 0 then
  begin
    // We always create a truetype font of logical height of cFontDeviceHeight,
    // and scale later
    // NH: CreateFont is now wide in Windows (So CreateFontW)
    FHandle := CreateFontW(
      -cFontDeviceHeight,              //int nHeight, // logical height of font
      0,                               //int nWidth, // logical average character width
      0,                               //int nEscapement, // angle of escapement
      0,                               //int nOrientation, // base-line orientation angle
      cBoldValue[fsBold in FStyle],    // fnWeight, // font weight
      cardinal(fsItalic in FStyle),    //DWORD fdwItalic, // italic attribute flag
      cardinal(fsUnderline in FStyle), //DWORD fdwUnderline, // underline attribute flag
      cardinal(fsStrikeOut in FStyle), //DWORD fdwStrikeOut, // strikeout attribute flag
      DEFAULT_CHARSET,                 //DWORD fdwCharSet, // character set identifier
      OUT_TT_ONLY_PRECIS,              //DWORD fdwOutputPrecision, // output precision
      CLIP_DEFAULT_PRECIS,             //DWORD fdwClipPrecision, // clipping precision
      DEFAULT_QUALITY,                 //DWORD fdwQuality, // output quality
      DEFAULT_PITCH,                   //DWORD fdwPitchAndFamily, // pitch and family
      PWideChar(WideString(FName)));   //LPCTSTR lpszFace  // pointer to typeface name string

    if FHandle = 0 then
      raise Exception.CreateFmt(sUnableToCreateFont, [FName]);

    // Select the font into the device context
    FParent.SelectFont(FHandle);

    // Get some font metrics
    BufSize := GetOutlineTextMetrics(FParent.FDc, 0, nil); //@@@ patch SZ (Tiburon)
    if BufSize > 0 then
    begin
      GetMem(Metrics, BufSize);
      try
        // Metrics must be initialized
        FillChar(Metrics^, SizeOf(Metrics^), 0);
        Metrics^.otmSize := SizeOf(Metrics^);
        // needs BufSize, not Handle
        Res := GetOutlineTextMetrics(FParent.FDc, BufSize, Metrics);
        if Res <> 0 then
        begin
          FAscent  := Metrics^.otmTextMetrics.tmAscent;
          FDescent := Metrics^.otmTextMetrics.tmDescent;
        end;
      finally
        FreeMem(Metrics);
      end;
    end;

  end;
  if FHandle <> 0 then
  begin

    // Select the font into the device context
    FParent.SelectFont(FHandle);

  end;
end;

destructor TdtpFont.Destroy;
begin
  if FHandle <> 0 then
    DeleteObject(FHandle);
  FreeAndNil(FGlyphs);
  inherited;
end;

procedure TdtpFont.ExtractGlyphOutline(Header: PTTPolygonHeader;
  BufSize: integer; Metrics: TGLYPHMETRICS; Poly: TdtpPolygon);
// Convert the Windows glyph information into a polygon
var
  i, j: integer;
  AOld, APoint, AStart, PtA, PtB, PtC: TdtpFixedPoint;
  ASize: integer;
  ACurve: PTTPolyCurve;
  AOffset, ACount, ADelta: integer;
  AType: word;
  AList: PFXPArray;
begin
  if not assigned(Poly) then
    exit;

  AOffset := 0;
  repeat
    // Find startpoint of polycurve
    AStart.X := Fixed(Header^.pfxStart.X);
    AStart.Y := Fixed(Header^.pfxStart.Y);
    ASize := Header^.cb - SizeOf(TTTPOLYGONHEADER);
    APoint := AStart;

    // Curve points
    PAnsiChar(ACurve) := PAnsiChar(Header) + SizeOf(TTTPOLYGONHEADER);
    ACount := 0;
    Poly.Add(APoint);
    while ACount < ASize do
    begin

      // Determine line segment type
      AType := ACurve^.wType;
      case AType of
      TT_PRIM_LINE:
        // Normal line
        begin
          AList := @ACurve^.apfx[0];
          // Loop through the list and add points
          for i := 0 to ACurve^.cpfx - 1 do
          begin
            AOld := APoint;
            APoint.X := Fixed(AList^[i].X);
            APoint.Y := Fixed(AList^[i].Y);
            if not PointsAreEqual(AOld, APoint) then
              // Add point
              Poly.Add(APoint);
          end;
        end;
      TT_PRIM_QSPLINE:
        // QSpline
        begin
          AList := @ACurve^.apfx[0];
          PtA := APoint;
          for i := 0 to ACurve^.cpfx - 2 do
          begin
            PtB.X := Fixed(AList^[i].X);
            PtB.Y := Fixed(AList^[i].Y);
            if i < ACurve^.cpfx - 2 then
            begin
              PtC.X := (Fixed(AList^[i + 1].X) + PtB.X) div 2;
              PtC.Y := (Fixed(AList^[i + 1].Y) + PtB.Y) div 2;
            end else
            begin
              PtC.X := Fixed(AList^[i + 1].X);
              PtC.Y := Fixed(AList^[i + 1].Y);
            end;
            // Regenerate this segment with additional polygon points
            RegenerateQSpline(PtA, PtB, PtC, Poly);
            PtA := PtC;
          end;
          APoint := PtC;
        end;
      end;//case

      // Move pointers
      ADelta := SizeOf(TTTPOLYCURVE) + (ACurve^.cpfx - 1) * SizeOf(TPOINTFX);
      inc(ACount, ADelta);
      PAnsiChar(ACurve) := PAnsiChar(ACurve) + ADelta;

    end;// while

    // Add last point
    if not PointsAreEqual(AStart, APoint) then
      Poly.Add(APoint);

    // Do we have more polylines? If not, break out
    inc(AOffset, ASize + SizeOf(TTTPOLYGONHEADER));
    if AOffset >= BufSize - SizeOf(TTTPolygonHeader) then
      break;

    // Jump to next polyline
    Poly.NewLine;
    pointer(Header) := pointer(ACurve);

  until False;

  // In bitmaps the y-coord points down, so we must invert Y
  for j := 0 to High(Poly.Points) do
    for i := 0 to High(Poly.Points[j]) do
      with Poly.Points[j][i] do
        Y := - Y;
end;

procedure TdtpFont.GetGlyphPolygon(AGlyph: TdtpGlyph);
var
  AMetrics: TGLYPHMETRICS;
  ABufSize: integer;
  ABuf: pointer;
  ARes: dword;
begin
  // Get a buffer for the glyph data
  if cDefaultUseUnicode then
    ABufSize := GetGlyphOutlineW(FParent.FDc, ord(AGlyph.Char), GGO_NATIVE, AMetrics,
      0, nil, cUnityMat2)
  else
    ABufSize := GetGlyphOutline(FParent.FDc, ord(AGlyph.Char), GGO_NATIVE, AMetrics,
      0, nil, cUnityMat2);

  AGlyph.IncX  := AMetrics.gmCellIncX;
  AGlyph.IncY  := AMetrics.gmCellIncX;
  AGlyph.BlackboxLeft   := AMetrics.gmptGlyphOrigin.x;
  AGlyph.BlackboxTop    := AMetrics.gmptGlyphOrigin.y;
  AGlyph.BlackboxWidth  := AMetrics.gmBlackBoxX;
  AGlyph.BlackboxHeight := AMetrics.gmBlackBoxY;

  if ABufSize > 0 then
  begin

    GetMem(ABuf, ABufSize);
    try
      // Get the glyph outline
      if cDefaultUseUnicode then
        ARes := GetGlyphOutlineW(FParent.FDc, ord(AGlyph.Char), GGO_NATIVE, AMetrics,
          ABufSize, ABuf, cUnityMat2)
      else
        ARes := GetGlyphOutline(FParent.FDc, ord(AGlyph.Char), GGO_NATIVE, AMetrics,
          ABufSize, ABuf, cUnityMat2);

      // Do we have an error?
      if (ARes = GDI_ERROR) or (PTTPolygonHeader(ABuf)^.dwType <> TT_POLYGON_TYPE) then
        exit;

      // Build glyph polygon
      AGlyph.Polygon := TdtpPolygon.Create;

      // Convert to polygon
      ExtractGlyphOutline(ABuf, ABufSize, AMetrics, AGlyph.Polygon);

    finally
      FreeMem(ABuf, ABufSize);
    end;

  end;

end;

function TdtpFont.GetLineHeight(FontHeight: double): double;
begin
  Result := FontHeight * (FAscent + FDescent) / cFontDeviceHeight;
end;

function TdtpFont.GlyphByChar(AChar: widechar): TdtpGlyph;
begin
  Result := FGlyphs.GlyphByChar(AChar);
  if not assigned(Result) then
  begin
    Result := TdtpGlyph.Create(Self);
    Result.Char := AChar;
    // Make sure we have our font selected
    CreateGDIFont;
    // Get polygon for this glyph
    GetGlyphPolygon(Result);
    // Add glyph in sorted fashion to our list
    FGlyphs.Add(Result);
  end;
end;

procedure TdtpFont.LoadFromStream(S: TStream);
var
  i, ACount: integer;
  AGlyph: TdtpGlyph;
begin
  // Read font properties
  FName := ReadStringFromStream(S);
  S.Read(FStyle, SizeOf(FStyle));
  S.Read(FAscent, SizeOf(FAscent));
  S.Read(FDescent, SizeOf(FDescent));
  // J.F. Feb 2011, left in for backwards compatibility
  // see Tdtpfont.SaveToStream
  S.Read(FReferenceCount, SizeOf(FReferenceCount));
  // Read glyphs
  S.Read(ACount, SizeOf(ACount));
  for i := 0 to ACount - 1 do
  begin
    AGlyph := TdtpGlyph.Create(Self);
    AGlyph.LoadFromStream(S);
    FGlyphs.Add(AGlyph);
  end;
  //  added by J.F. Feb 2011 - bug fix for FontEmbedding - PolygonText
  //  FReferenceCount is inc during PolygonText Load
  FReferenceCount := 0;
end;
procedure TdtpFont.RegenerateQSpline(const P0, P1, P2: TdtpFixedPoint; Poly: TdtpPolygon);
var
  P21, P22, P3: TdtpFixedPoint;
begin
  if PointsAreEqual(P0, P1) or PointsAreEqual(P1, P2) then
  begin
    Poly.Add(P1);
    Poly.Add(P2);
    exit;
  end;

  P21 := MidPoint(P1,  P0 );
  P22 := MidPoint(P2,  P1 );
  P3  := MidPoint(P21, P22);

  // First segment
  if TaxicabLength3Points(P0, P21, P3) > cGlyphMinSegmentSize then
    // Recursive call
    RegenerateQSpline(P0, P21, P3, Poly)
  else
  begin
    Poly.Add(P21);
    Poly.Add(P3);
  end;

  // Second segment
  if TaxicabLength3Points(P3, P22, P2) > cGlyphMinSegmentSize then
    RegenerateQSpline(P3, P22, P2, Poly)
  else
  begin
    Poly.Add(P22);
    Poly.Add(P2);
  end;
end;

procedure TdtpFont.SaveToStream(S: TStream);
var
  i, ACount: integer;
begin
  // Write font properties
  WriteStringToStream(S, FName);
  S.Write(FStyle, SizeOf(FStyle));
  S.Write(FAscent, SizeOf(FAscent));
  S.Write(FDescent, SizeOf(FDescent));
  // J.F. Feb 2011, FReference does not need to
  // be stored for PolygonText, left in for backwards compatibility
  S.Write(FReferenceCount, SizeOf(FReferenceCount));
  // Write glyphs
  ACount := FGlyphs.Count;
  S.Write(ACount, SizeOf(ACount));
  for i := 0 to ACount - 1 do
    FGlyphs[i].SaveToStream(S);
end;

{ TdtpGlyphPlacementList }

function TdtpGlyphPlacementList.GetItems(
  Index: integer): TdtpGlyphPlacement;
begin
  Result := Get(Index);
end;

{ TdtpFontRenderer }

constructor TdtpFontRenderer.Create(AFont: TdtpFont);
begin
  inherited Create;
  FFont := AFont;
end;

function TdtpFontRenderer.GetAscent: double;
begin
  Result := FFont.FAscent * FFontHeight / cFontDeviceHeight;
end;

procedure TdtpFontRenderer.GetCharacterPositions(const AText: widestring; FirstPoint: PdtpPoint);
var
  i: integer;
  AGlyph: TdtpGlyph;
  XPos, Scale, CharSpace: double;
begin
  // Sum up all glyph widths
  Scale := FFontHeight / cFontDeviceHeight;
  CharSpace := FCharacterSpacing * cFontDeviceHeight;
  XPos := 0;
  for i := 1 to length(AText) do
  begin
    AGlyph := FFont.GlyphByChar(AText[i]);
    // Correct for width so that blackboxes always fit?
    if FCorrectBlackBox and (i = 1) and (AGlyph.BlackboxLeft < 0) then
        XPos := XPos - AGlyph.BlackboxLeft * Scale;
    FirstPoint.X := XPos;
    // Go to next point
    inc(FirstPoint);
    XPos := XPos + (AGlyph.IncX + CharSpace) * Scale;
  end;

  // Last point
  FirstPoint.X := XPos;
end;

function TdtpFontRenderer.GetLineHeight: double;
begin
  Result := (FFont.FAscent + FFont.FDescent) * FFontHeight / cFontDeviceHeight;
end;

procedure TdtpFontRenderer.TextExtent(const AText: widestring; var AWidth,
  AHeight: double);
var
  i: integer;
  AGlyph: TdtpGlyph;
begin
  // Height is same as lineheight
  AHeight := LineHeight;

  // Sum up all glyph widths
  AWidth := 0;
  for i := 1 to length(AText) do
  begin
    AGlyph := FFont.GlyphByChar(AText[i]);
    // Correct for width so that blackboxes always fit?
    if FCorrectBlackBox then
    begin
      // Correct left size
      if (i = 1) and (AGlyph.BlackboxLeft < 0) then
        AWidth := AWidth - AGlyph.BlackboxLeft;
      // Correct right size
      if (i = length(AText)) then
        AWidth := AWidth - AGlyph.IncX + AGlyph.BlackboxLeft + AGlyph.BlackboxWidth;
    end;
    AWidth := AWidth + AGlyph.IncX;
  end;

  // Correct for character spacing
  if (FCharacterSpacing <> 0) and (length(AText) > 1) then
    AWidth := AWidth + FCharacterSpacing * cFontDeviceHeight * (length(AText) - 1);

  // Scale the width to the fontheight
  AWidth := AWidth * FFontHeight / cFontDeviceHeight;
end;

procedure TdtpFontRenderer.TextToPolygon(const X, Y, RenderScale: double;
  const AText: widestring; APoly: TdtpPolygon);
var
  i, j, k, l, Line, Count, SegCount, YTop, YBtm: integer;
  AGlyph: TdtpGlyph;
  Scale, AFrac: double;
  XPos, YPos, CharSpace: double;
  MustBreakup: boolean;
  BreakLen: TFixed;
  OldPoint, Point, AInt: TdtpFixedPoint;
  APlacement: TdtpGlyphPlacement;
  WindingDirection: TdtpWindingDirectionType;
  // local
  function Transform(const APoint: TdtpFixedPoint): TdtpFixedPoint;
  begin
    Result.X := round(APoint.X * Scale + XPos);
    Result.Y := round(APoint.Y * Scale + YPos);
  end;
  // local
  procedure AddRectangleToPoly(X1, Y1, X2, Y2: double);
  begin
    APoly.NewLine;
    if WindingDirection = wdClockwise then
    begin
      APoly.Add(Transform(dtpFixedPoint(X1, Y1)));
      APoly.Add(Transform(dtpFixedPoint(X2, Y1)));
      APoly.Add(Transform(dtpFixedPoint(X2, Y2)));
      APoly.Add(Transform(dtpFixedPoint(X1, Y2)));
    end else
    begin
      APoly.Add(Transform(dtpFixedPoint(X1, Y2)));
      APoly.Add(Transform(dtpFixedPoint(X2, Y2)));
      APoly.Add(Transform(dtpFixedPoint(X2, Y1)));
      APoly.Add(Transform(dtpFixedPoint(X1, Y1)));
    end;
  end;
// main
begin
  Scale := RenderScale * FFontHeight / cFontDeviceHeight;
  XPos := X * $10000;
  YPos := Y * $10000;
  CharSpace := FCharacterSpacing * cFontDeviceHeight;
  BreakLen := round(FBreakupLength * RenderScale * $10000);
  MustBreakup := BreakLen > 0;
  if assigned(FGlyphPlacement) then
    FGlyphPlacement.Clear;

  // Correct left if BlackboxLeft < 0
  if FCorrectBlackBox and (length(AText) > 0) then
  begin
    AGlyph := FFont.GlyphByChar(AText[1]);
    if AGlyph.BlackboxLeft < 0 then
      XPos := XPos - AGlyph.BlackboxLeft * Scale * $10000;
  end;

  for i := 1 to length(AText) do
  begin
    AGlyph := FFont.GlyphByChar(AText[i]);

    // Glyph placement
    APlacement := nil;
    if assigned(FGlyphPlacement) then
    begin
      APlacement := TdtpGlyphPlacement.Create;
      APlacement.Left := round(XPos);
      APlacement.Right := round(XPos + AGlyph.BlackboxWidth * Scale * $10000);
      APlacement.PolygonIndex := length(APoly.Points);
      if assigned(AGlyph.Polygon) then
        APlacement.PolygonCount := length(AGlyph.Polygon.Points)
      else
        APlacement.PolygonCount := 0;
      FGlyphPlacement.Add(APlacement);
    end;

    // Add the glyph to the result polygon
    if assigned(AGlyph.Polygon) then
    begin

      // Loop through polylines
      for j := 0 to length(AGlyph.Polygon.Points) - 1 do
      begin

        // Initiate a new contour
        APoly.NewLine;
        Line := High(APoly.Points);

        if MustBreakup then
        begin

          // Breakup polygon
          Count := length(AGlyph.Polygon.Points[j]);
          if Count >= 2 then
          begin
            // Add first point
            OldPoint := Transform(AGlyph.Polygon.Points[j, 0]);
            APoly.Add(OldPoint);
            // Walk through line segments
            for k := 1 to Count do
            begin
              Point := Transform(AGlyph.Polygon.Points[j, k mod Count]);
              SegCount := Max(1, round(FixedDistance(Point, OldPoint) / BreakLen));
              for l := 1 to SegCount - 1 do
              begin
                AFrac := l / SegCount;
                AInt.X := round(AFrac * (Point.X - OldPoint.X) + OldPoint.X);
                AInt.Y := round(AFrac * (Point.Y - OldPoint.Y) + OldPoint.Y);
                APoly.Add(AInt);
              end;
              // Add last point of line segment
              if k < Count then
                APoly.Add(Point);
              OldPoint := Point;
            end;
          end;

        end else
        begin

          // Just a scaled copy
          SetLength(APoly.Points[Line], Length(AGlyph.Polygon.Points[j]));
          for k := 0 to length(APoly.Points[Line]) - 1 do
            APoly.Points[Line, k] := Transform(AGlyph.Polygon.Points[j, k]);

        end;
      end;

    end;

    // Underline
    if fsUnderline in FFont.Style then
    begin
      if WindingDirection = wdNotSet then
        WindingDirection := AGlyph.DetectWindingDirection;
      YTop := FFont.FDescent - 105;
      YBtm := FFont.FDescent - 30;
      AddRectangleToPoly(0, YTop, AGlyph.IncX + CharSpace, YBtm);
      if assigned(APlacement) then
        inc(APlacement.FPolygonCount);
    end;
    // StrikeOut
    if fsStrikeOut in FFont.Style then
    begin
      if WindingDirection = wdNotSet then
        WindingDirection := AGlyph.DetectWindingDirection;
      YTop := -(FFont.FAscent div 2) + 200;
      YBtm := -(FFont.FAscent div 2) + 255;
      AddRectangleToPoly(0, YTop, AGlyph.IncX + CharSpace, YBtm);
      if assigned(APlacement) then
        inc(APlacement.FPolygonCount);
    end;

    // Update X position
    XPos := XPos + (AGlyph.IncX + CharSpace) * $10000 * Scale;
  end;
end;

{ TdtpFontList }

function TdtpFontList.GetItems(Index: integer): TdtpFont;
begin
  Result := Get(Index);
end;

{ TdtpFontManager }

function TdtpFontManager.AddFont(const AName: string; const AStyle: TFontStyles): TdtpFont;
begin
  Result := TdtpFont.Create(Self);
  Result.FName := AName;
  Result.FStyle := AStyle;
  FFonts.Add(Result);
end;

procedure TdtpFontManager.CleanupFonts;
var
  i: integer;
begin
  i := 0;
  while i < FFonts.Count do
  begin
    if FFonts[i].FReferenceCount <= 0 then
      FFonts.Delete(i)
    else
      inc(i);
  end;
end;

constructor TdtpFontManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFonts := TdtpFontList.Create;
  FDc := CreateCompatibleDC(0);
  FDefaultFont := GetStockObject(SYSTEM_FONT);
  SelectObject(FDc, FDefaultFont);
  FCurrentFont := FDefaultFont;
end;

destructor TdtpFontManager.Destroy;
begin
  if FCurrentFont <> FDefaultFont then
    SelectObject(FDc, FDefaultFont);
  FreeAndNil(FFonts);
  DeleteDC(FDc);
  inherited;
end;

procedure TdtpFontManager.ClearFontList;
// added by J.F. Feb 2011 part of FontEmbedding fix
// see TdtpDocument.ClearDoc
begin
  FCurrentFont := FDefaultFont;
  FFonts.Clear;
end;

procedure TdtpFontManager.RemoveFontReference(const AName: string; const AStyle: TFontStyles);
// Remove any reference to unused Fonts    added by J.F. Feb 2011
var
  i: integer;
begin
  for i := 0 to FFonts.Count - 1 do
    if (FFonts[i].Name = AName) and (FFonts[i].Style = AStyle) then
    begin
      dec(FFonts[i].FReferenceCount);
      Break;
    end;
end;

function TdtpFontManager.FontByNameAndStyle(const AName: string;
  const AStyle: TFontStyles; OldFont: TdtpFont): TdtpFont;
var
  i: integer;
begin
  Result := nil;
  if length(AName) = 0 then
    exit;

  // Check first if oldfont is this one
  if assigned(OldFont) then
  begin
    if (OldFont.Name = AName) and (OldFont.Style = AStyle) then
    begin
      Result := OldFont;
      exit;
    end;
    dec(OldFont.FReferenceCount);
  end;

  // Check list of fonts
  for i := 0 to FFonts.Count - 1 do
    if (FFonts[i].Name = AName) and (FFonts[i].Style = AStyle) then
    begin
      Result := FFonts[i];
      inc(Result.FReferenceCount);
      exit;
    end;

  // No font found? Let's create it
  Result := AddFont(AName, AStyle);
  Result.CreateGDIFont; // this ensures we get the font props from GDI
  inc(Result.FReferenceCount);
end;

procedure TdtpFontManager.LoadFromStream(S: TStream);
var
  Header: array[0..2] of AnsiChar;
  Version: word;
  i, ACount: integer;
  AFont: TdtpFont;
begin
  S.Read(Header, 3);
  if Header <> 'FNT' then
    raise Exception.Create(sFontFileCorrupt);
  S.Read(Version, SizeOf(Version));
  if Version <> 1 * 256 + 0 then
    raise Exception.Create(sFontFileVersionMismatch);
  S.Read(ACount, SizeOf(ACount));
  for i := 0 to ACount - 1 do
  begin
    AFont := TdtpFont.Create(Self);
    AFont.LoadFromStream(S);
    FFonts.Add(AFont);
  end;
end;

procedure TdtpFontManager.SaveToStream(S: TStream);
const
  cFontFileTitle = AnsiString('FNT');       // FNT as file identifier
  cVersion: word = 1 * 256 + 0; // Version 1.1
var
  i, ACount: integer;
begin
  // added by J.F. Feb 2011
  CleanUpFonts;
  // Write Header
  S.Write(cFontFileTitle[1], 3);
  S.Write(cVersion, SizeOf(cVersion));
  // Write font count
  ACount := FFonts.Count;
  S.Write(ACount, SizeOf(ACount));
  // Write fonts
  for i := 0 to ACount - 1 do
    FFonts[i].SaveToStream(S);
end;

procedure TdtpFontManager.SelectFont(AFont: HFont);
begin
  if AFont <> FCurrentFont then
  begin
    SelectObject(FDc, AFont);
    FCurrentFont := AFont;
  end;
end;

end.

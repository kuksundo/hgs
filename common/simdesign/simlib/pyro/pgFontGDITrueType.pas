{ Project: Pyro
  Module: Pyro Edit

  Description:
  Support for TrueType font rendering. TrueType fonts are outlined,
  in other words, the glyphs are rendered as pathsets. Pathsets for individual glyphs
  are cached in the glyph class, part of a font and fontcache.

  TrueType fonts can contain lines and quadratic bezier splines (Q-splines), which
  are handled without further difficulty by the pgPathSet class.

  Creation Date:
  12Jan2004

  Modified:
  13jun2011: placed all the M$ code in pgPlatform.pas
  10oct2012: fixed bug - PChar replaced by PAnsiChar

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2004 - 2012 SimDesign BV
}
unit pgFontGDITrueType;

{$i simdesign.inc}

interface

uses
  SysUtils, sdSortedLists, pgFontUsingRender, pgPath, pgPlatform, Pyro;

type

  TpgTTGlyph = class(TpgGlyph)
  private
    FChar: WideChar;
  protected
    function GetChar: WideChar; override;
  public
    property Char: WideChar read GetChar;
  end;

  TpgTrueTypeFont = class(TpgRenderFont)
  private
    FGlyphs: TSortedList;
    FDC: longword{HDC};
    FFont, FOldFont: cardinal{HFont};
    FGlyphMultiplierX: TpgFloat;
    FGlyphMultiplierY: TpgFloat;
    FXMultiplier: TpgFloat;
    FYMultiplier: TpgFloat;
    FStretchFactor: TpgFloat;
  protected
    function GetGlyphs(C: PWideChar): TpgGlyph; override;
    procedure GetGlyphProperties(AGlyph: TpgTTGlyph);
    function GlyphCompare(Item1, Item2: TObject; Info: pointer): integer;
    procedure GlyphToPath(Header: PpgTTPolygonHeader; BufSize: integer;
      const Metrics: TpgGlyphMetrics; Path: TpgPath);
    procedure RealiseFont; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetKerningPair(Char1, Char2: widechar): TpgFloat; override;
    procedure RealiseStockFont(AFont: cardinal{HFont});
    property FontHandle: cardinal{HFont} read FFont;
  end;

implementation

type
  // _Fixed Point array used for access to lowlevel truetype structure
  TFXPArray = array[0..MaxInt div SizeOf(TpgPointFX) - 1] of TpgPointFX;
  PFXPArray = ^TFXPArray;

const
  // Identity 2x2 matrix used in font transforms
  cUnityMat2: TpgMat2 = (
    eM11: (fract: 0; Value: 1); eM12: (fract: 0; Value: 0);
    eM21: (fract: 0; Value: 0); eM22: (fract: 0; Value: 1));

  cFontMultiplier = 1000;

{ TpgTTGlyph }

function TpgTTGlyph.GetChar: WideChar;
begin
  Result := FChar;
end;

{ TpgTrueTypeFont }

constructor TpgTrueTypeFont.Create;
begin
  inherited;

  // We create a DC which will hold the font
  FDC := pgCreateCompatibleDC(0);

  // Glyph list
  FGlyphs := TSortedList.Create;
  FGlyphs.OnCompare := GlyphCompare;
end;

destructor TpgTrueTypeFont.Destroy;
begin
  FreeAndNil(FGlyphs);
  if FFont <> 0 then
  begin
    pgSelectObject(FDC, FOldFont);
    pgDeleteObject(FFont);
  end;
  pgDeleteDC(FDC);
  inherited;
end;

procedure TpgTrueTypeFont.GetGlyphProperties(AGlyph: TpgTTGlyph);
var
  Buf: pointer;
  BufSize: integer;
  Res: cardinal;
  Metrics: TpgGlyphMetrics;
begin
  BufSize := pgGetGlyphOutlineW(FDc, cardinal(AGlyph.FChar), pgGGO_NATIVE, Metrics,
    0, nil, cUnityMat2);
  AGlyph.AdvanceX := Metrics.gmCellIncX * FXMultiplier;
  AGlyph.AdvanceY := Metrics.gmCellIncY * FYMultiplier;
  AGlyph.BlackBox.Lft :=  Metrics.gmptGlyphOrigin.X * FXMultiplier;
  AGlyph.BlackBox.Top := -Metrics.gmptGlyphOrigin.Y * FYMultiplier;
  AGlyph.BlackBox.Rgt := ( Metrics.gmptGlyphOrigin.X + integer(Metrics.gmBlackBoxX)) * FXMultiplier;
  AGlyph.BlackBox.Btm := (-Metrics.gmptGlyphOrigin.Y + integer(Metrics.gmBlackBoxY)) * FYMultiplier;

  if BufSize > 0 then
  begin

    GetMem(Buf, BufSize);
    try
      // Get the glyph outline
      Res := pgGetGlyphOutlineW(FDC, cardinal(AGlyph.FChar), pgGGO_NATIVE, Metrics,
        BufSize, Buf, cUnityMat2);

      // Do we have an error?
      if (Res = pgGDI_ERROR) or (PpgTTPolygonHeader(Buf)^.dwType <> pgTT_POLYGON_TYPE) then
        exit;

      // Convert windows outline to path
      GlyphToPath(Buf, BufSize, TpgGlyphMetrics(Metrics), AGlyph.Path);

    finally
      FreeMem(Buf);
    end;
  end;
end;

function TpgTrueTypeFont.GetGlyphs(C: PWideChar): TpgGlyph;
var
  AGlyph: TpgTTGlyph;
  Index: integer;
begin
  // Find the glyph in the glyphlist, if we already have it we return it otherwise
  // we create a new glyph
  AGlyph := TpgTTGlyph.Create;
  AGlyph.FChar := C^;
  if FGlyphs.Find(AGlyph, Index) then
  begin
    Result := TpgGlyph(FGlyphs[Index]);
    AGlyph.Free;
    exit;
  end;
  FGlyphs.Add(AGlyph);

  // Do the outline
  GetGlyphProperties(AGlyph);
  Result := AGlyph;
end;

function TpgTrueTypeFont.GetKerningPair(Char1, Char2: widechar): TpgFloat;
var
  KerningPair: TpgKerningPair;
begin
  KerningPair.wFirst := word(Char1);
  KerningPair.wSecond := word(Char2);
  if pgGetKerningPairs(FDC, 1, KerningPair) = 1 then
    Result := KerningPair.iKernAmount * FXMultiplier
  else
    Result := 0;
end;

function TpgTrueTypeFont.GlyphCompare(Item1, Item2: TObject; Info: pointer): integer;
begin
  Result := CompareInteger(ord(TpgTTGlyph(Item1).Char), ord(TpgTTGlyph(Item2).Char));
end;

procedure TpgTrueTypeFont.GlyphToPath(Header: PpgTTPolygonHeader; BufSize: integer; const Metrics: TpgGlyphMetrics; Path: TpgPath);

// Convert the Windows glyph information into a path

  // local
  function ToSingleX(Value: TpgFixedR): single;
  begin
    Result := integer(Value) * FGlyphMultiplierX;
  end;

  // local
  function ToSingleY(Value: TpgFixedR): single;
  begin
    Result := - integer(Value) * FGlyphMultiplierY;
  end;

// main
var
  i: integer;
  AOld, APoint, AStart, PtA, PtB, PtC: TpgPoint;
  ASize: integer;
  ACurve: PpgTTPolyCurve;
  AOffset, ACount, ADelta: integer;
  AType: word;
  AList: PFXPArray;
begin
  Path.PixelScale := 1; // font will stay high quality up till 10x
  Path.ExpectedStrokeWidth := 1;
  if RenderMethod = frOutlineBreakup then
    Path.BreakupLength := 0.1;// reciprocal of pixelscale
  AOffset := 0;
  repeat
    // Find startpoint of polycurve
    AStart.X := ToSingleX(Header^.pfxStart.X);
    AStart.Y := ToSingleY(Header^.pfxStart.Y);
    ASize := Header^.cb - SizeOf(TpgTTPolygonHeader);
    APoint := AStart;

    // Curve points
    PAnsiChar(ACurve) := PAnsiChar(Header) + SizeOf(TpgTTPolygonHeader);
    ACount := 0;
    Path.MoveTo(APoint.X, APoint.Y);
    while ACount < ASize do
    begin

      // Determine line segment type
      AType := ACurve^.wType;
      case AType of

      pgTT_PRIM_LINE:
        // Normal line
        begin
          AList := @ACurve^.apfx[0];
          // Loop through the list and add points
          for i := 0 to ACurve^.cpfx - 1 do
          begin
            AOld := APoint;
            APoint.X := ToSingleX(AList^[i].X);
            APoint.Y := ToSingleY(AList^[i].Y);
            if not pgPointsExactlyEqual(AOld, APoint) then
              Path.LineTo(APoint.X, APoint.Y);
          end;
        end;

      pgTT_PRIM_QSPLINE:
        // QSpline
        begin
          AList := @ACurve^.apfx[0];
          PtA := APoint;
          for i := 0 to ACurve^.cpfx - 2 do
          begin
            PtB.X := ToSingleX(AList^[i].X);
            PtB.Y := ToSingleY(AList^[i].Y);
            if i < ACurve^.cpfx - 2 then
            begin
              PtC.X := (ToSingleX(AList^[i + 1].X) + PtB.X) / 2;
              PtC.Y := (ToSingleY(AList^[i + 1].Y) + PtB.Y) / 2;
            end else
            begin
              PtC.X := ToSingleX(AList^[i + 1].X);
              PtC.Y := ToSingleY(AList^[i + 1].Y);
            end;
            // Add Quadratic Bezier
            Path.CurveToQuadratic(PtB.X, PtB.Y, PtC.X, PtC.Y);
            PtA := PtC;
          end;
          APoint := PtC;
        end;
      end;//case

      // Move pointers
      ADelta := SizeOf(TpgTTPolyCurve) + (ACurve^.cpfx - 1) * SizeOf(TpgPointFX);
      inc(ACount, ADelta);
      PAnsiChar(ACurve) := PAnsiChar(ACurve) + ADelta;

    end;// while

    // Close the path
    Path.ClosePath;

    // Do we have more polylines? If not, break out
    inc(AOffset, ASize + SizeOf(TpgTTPolygonHeader));
    if AOffset >= BufSize - SizeOf(TpgTTPolygonHeader) then
      break;

    // Jump to next polyline
    pointer(Header) := pointer(ACurve);

  until False;
end;

procedure TpgTrueTypeFont.RealiseFont;
const
  cFontWeights: array[TpgFontWeight] of integer =
    // Windows GDI:
    // 400 = Normal
    // 700 = Bold
    (400, 700, 500, 500, 100, 200, 300, 400, 500, 600, 700, 800, 900);
  cFontStretches: array[TpgFontStretch] of TpgFloat =
    (1.0, 1.2, 0.8, 0.5, 0.65, 0.8, 0.9, 1.1, 1.3, 1.5, 2.0);
var
  i: integer;
  LogFont: TpgLogFontA;
begin
  // populate a logical font
  FillChar(LogFont, SizeOf(LogFont), 0);
  LogFont.lfHeight := -cFontMultiplier;
  LogFont.lfWeight := cFontWeights[Weight];
  LogFont.lfItalic := byte(Style = fsItalic);
  LogFont.lfOutPrecision := pgOUT_TT_ONLY_PRECIS;
  LogFont.lfQuality := pgANTIALIASED_QUALITY;

  for i := 1 to pgMin(pgLF_FACESIZE - 1, length(Family)) do
    LogFont.lfFaceName[i - 1] := Family[i];

  FFont := pgCreateFontIndirect(LogFont);
  FOldFont := pgSelectObject(FDC, FFont);
  FGlyphMultiplierY := 1 / ($10000 * cFontMultiplier);
  FStretchFactor := cFontStretches[Stretch];
  FXMultiplier := (1 / cFontMultiplier) * FStretchFactor;
  FYMultiplier := (1 / cFontMultiplier);
  FGlyphMultiplierX := FGlyphMultiplierY * FStretchFactor;
end;

procedure TpgTrueTypeFont.RealiseStockFont(AFont: cardinal);
begin
  FFont := AFont;
  FOldFont := pgSelectObject(FDC, FFont);
  FGlyphMultiplierY := 1 / ($10000 * cFontMultiplier);
  FStretchFactor := 1;
  FXMultiplier := (1 / cFontMultiplier) * FStretchFactor;
  FYMultiplier := (1 / cFontMultiplier);
  FGlyphMultiplierX := FGlyphMultiplierY * FStretchFactor;
end;

end.

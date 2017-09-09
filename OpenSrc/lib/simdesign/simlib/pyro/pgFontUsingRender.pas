{ Project: Pyro
  Module: Pyro Render

  Description:
  Support for fonts: this unit is a general approach to a font, for specific
  font implementations see e.g. pgTrueType. A Type1 font rendering unit will
  also be provided in future (PDF).

  Fonts are created as needed and kept in a font cache. Fonts contain glyphs
  that can contain:
  - A precise glyph outline (path),
  - Hinted and AA'ed bitmaps (to do) at required font sizes.

  Note:
  - rastered glyphs will not be supported in Pyro

  Creation Date:
  12Jan2004

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2004 - 2011 SimDesign BV
}
unit pgFontUsingRender;

{$i simdesign.inc}

interface

uses
  Classes, Contnrs, SysUtils, pgPlatform, Pyro, pgPath;


type

  TpgGlyph = class(TPersistent)
  private
    FAdvanceX: TpgFloat;
    FAdvanceY: TpgFloat;
    FBlackBox: TpgBox;
    FPath: TpgPath;
    function GetCharCount: integer;
    function GetBlackBox: PpgBox;
  protected
    function GetChar: widechar; virtual;
    class function PathClass: TpgPathClass; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property AdvanceX: TpgFloat read FAdvanceX write FAdvanceX;
    property AdvanceY: TpgFloat read FAdvanceY write FAdvanceY;
    property BlackBox: PpgBox read GetBlackBox;
    property Char: widechar read GetChar;
    property CharCount: integer read GetCharCount;
    property Path: TpgPath read FPath;
  end;

  TpgRenderFont = class(TPersistent)
  private
    FFamily: Utf8String;
    FStyle: TpgFontStyle;
    FVariant: TpgFontVariant;
    FWeight: TpgFontWeight;
    FStretch: TpgFontStretch;
    FRenderMethod: TpgFontRenderMethod;
  protected
    function GetGlyphs(C: PWideChar): TpgGlyph; virtual;
    procedure RealiseFont; virtual;
  public
    constructor Create; virtual;
    function GetKerningPair(Char1, Char2: widechar): TpgFloat; virtual;
    property Glyphs[C: PWideChar]: TpgGlyph read GetGlyphs;
    property Family: Utf8String read FFamily write FFamily;
    property Style: TpgFontStyle read FStyle write FStyle;
    property Variant: TpgFontVariant read FVariant write FVariant;
    property Weight: TpgFontWeight read FWeight write FWeight;
    property Stretch: TpgFontStretch read FStretch write FStretch;
    property RenderMethod: TpgFontRenderMethod read FRenderMethod write FRenderMethod;
  end;

  TpgRenderFontCache = class(TPersistent)
  private
    FFonts: TObjectList;
    function GetFontCount: integer;
    function GetFonts(Index: integer): TpgRenderFont;
  public
    destructor Destroy; override;
    procedure Clear; virtual;
    function GetFont(AFamily: string; AStyle: TpgFontStyle; AVariant: TpgFontVariant;
      AWeight: TpgFontWeight; AStretch: TpgFontStretch;
      ARenderMethod: TpgFontRenderMethod): TpgRenderFont;
    function GetStockFont(AStock: cardinal): TpgRenderFont;
    procedure FontAdd(AFont: TpgRenderFont);
    property FontCount: integer read GetFontCount;
    property Fonts[Index: integer]: TpgRenderFont read GetFonts;
  end;

implementation

uses
  // must be here otherwise circular unit reference
  pgFontGDITrueType;

{ TpgGlyph }

constructor TpgGlyph.Create;
begin
  inherited Create;
  FPath := PathClass.Create;
end;

destructor TpgGlyph.Destroy;
begin
  FreeAndNil(FPath);
  inherited;
end;

function TpgGlyph.GetBlackBox: PpgBox;
begin
  Result := @FBlackBox;
end;

function TpgGlyph.GetChar: widechar;
begin
  // Default does nothing
  Result := #0;
end;

function TpgGlyph.GetCharCount: integer;
begin
  Result := 1;
end;

class function TpgGlyph.PathClass: TpgPathClass;
begin
  Result := TpgRenderPath;
end;

{ TpgRenderFont }

constructor TpgRenderFont.Create;
begin
  inherited Create;
end;

function TpgRenderFont.GetGlyphs(C: PWideChar): TpgGlyph;
begin
  // Default does nothing
  Result := nil;
end;

function TpgRenderFont.GetKerningPair(Char1, Char2: widechar): TpgFloat;
begin
  // Default does nothing
  Result := 0;
end;

procedure TpgRenderFont.RealiseFont;
begin
// default does nothing
end;

{ TpgRenderFontCache }

procedure TpgRenderFontCache.Clear;
begin
  if assigned(FFonts) then
    FFonts.Clear;
end;

destructor TpgRenderFontCache.Destroy;
begin
  FreeAndNil(FFonts);
  inherited;
end;

procedure TpgRenderFontCache.FontAdd(AFont: TpgRenderFont);
begin
  if not assigned(FFonts) then
    FFonts := TObjectList.Create;
  FFonts.Add(AFont);
end;

function TpgRenderFontCache.GetFont(AFamily: string; AStyle: TpgFontStyle;
  AVariant: TpgFontVariant; AWeight: TpgFontWeight;
  AStretch: TpgFontStretch; ARenderMethod: TpgFontRenderMethod): TpgRenderFont;
var
  i: integer;
  AFont: TpgRenderFont;
begin
  // Loop through the cache and select a font if it matches. If not present, we'll add one
  for i := 0 to FontCount - 1 do
  begin
    AFont := Fonts[i];
    if
      (AnsiCompareText(AFamily, AFont.Family) = 0) and
      (AStyle = AFont.Style) and
      (AVariant = AFont.Variant) and
      (AWeight = AFont.Weight) and
      (AStretch = AFont.Stretch) and
      (ARenderMethod = AFont.RenderMethod) then
    begin
      Result := AFont;
      exit;
    end;
  end;

  // No font was found, so we add a new font to the cache
  Result := TpgTrueTypeFont.Create;
  Result.Family := AFamily;
  Result.Style := AStyle;
  Result.Variant := AVariant;
  Result.Weight := AWeight;
  Result.Stretch := AStretch;
  Result.RenderMethod := ARenderMethod;
  Result.RealiseFont;
  FontAdd(Result);
end;

function TpgRenderFontCache.GetFontCount: integer;
begin
  if assigned(FFonts) then
    Result := FFonts.Count
  else
    Result := 0;
end;

function TpgRenderFontCache.GetFonts(Index: integer): TpgRenderFont;
begin
  if (Index >= 0) and (Index < FontCount) then
    Result := TpgRenderFont(FFonts[Index])
  else
    Result := nil;
end;

function TpgRenderFontCache.GetStockFont(AStock: cardinal): TpgRenderFont;
var
  i: integer;
  Handle: longword{HFont};
begin
  Handle := pgGetStockObject(AStock);

  // Check if we already have this stock font
  for i := 0 to FontCount - 1 do
    if (Fonts[i] is TpgTrueTypeFont) and (TpgTrueTypeFont(Fonts[i]).FontHandle = Handle) then
    begin
      Result := Fonts[i];
      exit;
    end;

  // We don't have it, so create it
  Result := TpgTrueTypeFont.Create;
  TpgTrueTypeFont(Result).RealiseStockFont(Handle);
  FontAdd(Result);
end;

end.

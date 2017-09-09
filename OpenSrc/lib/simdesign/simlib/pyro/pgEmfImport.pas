unit pgEmfImport;
{
  Support for EMF and WMF: Windows (Enhanced) Metafiles

  Import is still in experimental stage
  Export is not implemented

  Creation Date:
  18Jan2005

  Modifications:

  Author: Nils Haeck
  Copyright (c) 2005 by SimDesign B.V.

}

{$R-}
interface

uses
  Classes, SysUtils, Contnrs, Graphics, pgScene, pgImport, pgViewPort, pgGroup,
  pgShape, pgElement, pgPaintable, pgFont, pgTypes, pgColor, pgTransform, Math;

type

  TStatusEvent = procedure (Sender: TObject; const AMessage: string) of object;

  TpgGraphicObject = class(TPersistent)
  private
    FHandle: dword;
  public
    constructor Create(AHandle: dword); virtual;
    property Handle: dword read FHandle write FHandle;
  end;

  TpgBrushObject = class(TpgGraphicObject)
  private
    FStyle: dword;
    FHatch: dword;
    FColor: TpgColor32;
  public
    property Style: dword read FStyle write FStyle;
    property Color: TpgColor32 read FColor write FColor;
    property Hatch: dword read FHatch write FHatch;
  end;

  TpgPenObject = class(TpgGraphicObject)
  private
    FStyle: dword;
    FWidth: TpgFloat;
    FColor: TpgColor32;
  public
    property Style: dword read FStyle write FStyle;
    property Width: TpgFloat read FWidth write FWidth;
    property Color: TpgColor32 read FColor write FColor;
  end;

  TpgFontObject = class(TpgGraphicObject)
  private
    FFont: TpgFont;
  public
    // Pointer to a font in the document's font cache
    property Font: TpgFont read FFont write FFont;
  end;

  TpgPaletteObject = class(TpgGraphicObject)
  private
    FLogPalette: PLogPalette;
  public
    property LogPalette: PLogPalette read FLogPalette write FLogPalette;
  end;

  PpgDeviceContext = ^TpgDeviceContext;
  TpgDeviceContext = record
    Pen: TpgPenObject;
    Brush: TpgBrushObject;
    Palette: TpgPaletteObject;
    Font: TpgFontObject;
    MapMode: dword;   // mapping mode, default is MM_TEXT
    ViewportOrg: TpgPoint;
    ViewportExt: TpgPoint;
    WindowOrg: TpgPoint;
    WindowExt: TpgPoint;
    DrawMode: dword;  // raster operation drawmode
    FillRule: TpgFillRuleType;
    WorldTransform: TpgMatrix;
    CurrentPosition: TpgPoint;
  end;

  TpgEmfImport = class(TpgImport)
  private
    FContexts: array of TpgDeviceContext;
    FObjects: TObjectList;
    FStockObjects: TObjectList;
    FContextCount: integer;
    FGroup: TpgGroup;
    FOldTransform: TpgMatrix;
    // events
    FOnStatus: TStatusEvent;
    procedure DoStatus(const AMessage: string);
    function GetContext: PpgDeviceContext;
    function GetObjectByHandle(Handle: dword): TpgGraphicObject;
    procedure InitContexts;
    procedure ClearContext(Index: integer);
    procedure CreateStockObjects;
  protected
    procedure CreateFillFromBrush(AParent: TpgPaintable);
    procedure CreateEmptyFill(AParent: TpgPaintable);
    procedure CreateStrokeFromPen(AParent: TpgPaintable);
    function CreateBrush(AHandle, AStyle: dword; AColor: TpgColor32; AHatch: dword): TpgBrushObject;
    function CreatePen(AHandle, AStyle: dword; AWidth: TpgFloat; AColor: TpgColor32): TpgPenObject;
    function CreateFont(AHandle: dword; ALogFont: PExtLogFontW): TpgFontObject;
    function Color32FromColorRef(AColorRef: COLORREF): TpgColor32;
    function DrawMetaRecord(DC: HDC; lpHTable: PHANDLETABLE; lpEMFR: PENHMETARECORD; nObj: integer): integer;
    procedure ObjectAdd(AObject: TpgGraphicObject);
    procedure ProcessHeader(const AHeader: TEnhMetaHeader; AViewPort: TpgViewPort);
    procedure SaveContext;
    procedure RestoreContext;
    procedure UpdateTransformation;
    property Context: PpgDeviceContext read GetContext;
    property ObjectByHandle[Handle: dword]: TpgGraphicObject read GetObjectByHandle;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure LoadFromStream(S: TStream); override;
  published
    property OnStatus: TStatusEvent read FOnStatus write FOnStatus;
  end;

resourcestring

  seiInvalidMetafile            = 'Invalid Metafile';
  seiUnrecognisedMetafileRecord = 'Unrecognised Metafile Record %d';
  seiRestoreContextOverflow     = 'RestoreDC called too many times';
  seiGraphicObjectAlreadyExists = 'Graphic Object already exists';
  seiUnknownGraphicsObject      = 'Unknown graphics object';
  seiUnknownColorRef            = 'Unknown Color Reference';
  seiUnrecognisedObject         = 'Unrecognised %s object';

implementation

uses
  pgDocument, pgSizeable, pgGraphic;

const
  cInchToMm = 25.4;

// This function is called from EnumEnhMetaFile
function EnhMetafileProc(DC: HDC; lpHTable: PHANDLETABLE; lpEMFR: PENHMETARECORD;
  nObj: Integer; AImport: TpgEmfImport): Integer; stdcall;
begin
  // Use the aux parameter to call the object's function
  Result := AImport.DrawMetaRecord(DC, lpHTable, lpEMFR, nObj);
end;

{ TpgGraphicObject }

constructor TpgGraphicObject.Create(AHandle: dword);
begin
  inherited Create;
  FHandle := AHandle;
end;

{ TpgEmfImport }

procedure TpgEmfImport.Clear;
begin
  InitContexts;
  FObjects.Clear;
  inherited;
end;

procedure TpgEmfImport.ClearContext(Index: integer);
begin
  FillChar(FContexts[Index], SizeOf(TpgDeviceContext), 0);
  // Defaults
  with FContexts[Index] do begin
    FillRule := frEvenOdd;
    MapMode :=MM_TEXT;
    ViewportExt := pgPoint(1, 1);
    WindowExt := pgPoint(1, 1);
    WorldTransform := cIdentityMatrix;
  end;
end;

function TpgEmfImport.Color32FromColorRef(AColorRef: COLORREF): TpgColor32;
begin
  case (AColorRef shr 24) and $02 of
  00, 02:
    Result :=
      (AColorRef and $00FF0000 shr 16) +
      (AColorRef and $0000FF00) +
      (AColorRef and $000000FF) shl 16 +
      $FF000000;
  01:
    begin
      // to do: palette index lookup
      raise Exception.Create('unimplemented');
    end;
  else
    raise Exception.Create(seiUnknownColorRef);
  end;
end;

constructor TpgEmfImport.Create;
begin
  inherited Create;
  FObjects := TObjectList.Create;
  CreateStockObjects;
  InitContexts;
  FOldTransform := cIdentityMatrix;
end;

function TpgEmfImport.CreateBrush(AHandle, AStyle: dword; AColor: TpgColor32;
  AHatch: dword): TpgBrushObject;
begin
  Result := TpgBrushObject.Create(AHandle);
  Result.Style := AStyle;
  Result.Color := AColor;
  Result.Hatch := AHatch;
end;

procedure TpgEmfImport.CreateEmptyFill(AParent: TpgPaintable);
var
  Fill: TpgPaintProp;
begin
  Fill := TpgPaintProp.Create;
  Fill.PaintType := ptNone;
  AParent.PropByID[catFill] := Fill;
end;

procedure TpgEmfImport.CreateFillFromBrush(AParent: TpgPaintable);
var
  Fill: TpgPaintProp;
begin
  if not assigned(Context.Brush) then exit;
  Fill := TpgPaintProp.Create;
  case Context.Brush.Style of
  BS_DIBPATTERN:;
  BS_DIBPATTERN8X8:;
  BS_DIBPATTERNPT:;
  BS_HATCHED:;
  BS_HOLLOW:
    Fill.PaintType := ptNone;
  BS_PATTERN:;
  BS_PATTERN8X8:;
  BS_SOLID:
    begin
      Fill.PaintType := ptColor;
      Fill.Color := Context.Brush.Color;
    end;
  end;
  AParent.StartEdit;
  try
    AParent.FillRule := Context.FillRule;
    AParent.Fill := Fill;
  finally
    AParent.StopEdit;
  end;
end;

function TpgEmfImport.CreateFont(AHandle: dword;
  ALogFont: PExtLogFontW): TpgFontObject;
var
  AFamily: string;
  AStyle: TpgFontStyle;
  AVariant: TpgFontVariant;
  AWeight: TpgFontWeight;
  AStretch: TpgFontStretch;
  ARenderMethod: TpgFontRenderMethod;
begin
  Result := TpgFontObject.Create(AHandle);
  // FontFamily
  AFamily := ALogFont.elfLogFont.lfFaceName;
  if ALogFont.elfLogFont.lfItalic <> 0 then
    AStyle := fsItalic
  else
    AStyle := fsNormal;
  // to do
  AVariant := fvNormal;
  // to do
  AWeight := fwNormal;
  // to do
  AStretch := fsNoStretch;
  ARenderMethod := frOutline;
  // Get a pointer to cached font from document
  if assigned(Scene.Document) then
    Result.Font := TpgDocument(Scene.Document).FontCache.GetFont(
      AFamily, AStyle, AVariant, AWeight, AStretch, ARenderMethod);

end;

function TpgEmfImport.CreatePen(AHandle, AStyle: dword; AWidth: TpgFloat;
  AColor: TpgColor32): TpgPenObject;
begin
  Result := TpgPenObject.Create(AHandle);
  Result.Style := AStyle;
  Result.Width := Max(1, AWidth);
  Result.Color := AColor;
end;

procedure TpgEmfImport.CreateStockObjects;
// main
begin
  FStockObjects := TObjectList.Create;

  // brushes
  FStockObjects.Add(CreateBrush(GetStockObject(BLACK_BRUSH),  BS_SOLID, clBlack32,     0));
  FStockObjects.Add(CreateBrush(GetStockObject(DKGRAY_BRUSH), BS_SOLID, clDimGray32,   0));
  FStockObjects.Add(CreateBrush(GetStockObject(GRAY_BRUSH),   BS_SOLID, clGray32,      0));
  FStockObjects.Add(CreateBrush(GetStockObject(HOLLOW_BRUSH), BS_NULL,  clBlack32,     0));
  FStockObjects.Add(CreateBrush(GetStockObject(LTGRAY_BRUSH), BS_SOLID, clLightGray32, 0));
  FStockObjects.Add(CreateBrush(GetStockObject(NULL_BRUSH),   BS_NULL,  clBlack32,     0));
  FStockObjects.Add(CreateBrush(GetStockObject(WHITE_BRUSH),  BS_SOLID, clWhite32,     0));

  // fonts: to do
  // ANSI_FIXED_FONT / ANSI_VAR_FONT / DEVICE_DEFAULT_FONT / DEFAULT_GUI_FONT /
  // OEM_FIXED_FONT / SYSTEM_FONT / SYSTEM_FIXED_FONT

  // pens
  FStockObjects.Add(CreatePen(GetStockObject(BLACK_PEN), PS_SOLID, 0, clBlack32));
  FStockObjects.Add(CreatePen(GetStockObject(NULL_PEN),  PS_NULL,  0, clBlack32));
  FStockObjects.Add(CreatePen(GetStockObject(WHITE_PEN), PS_SOLID, 0, clWhite32));

  // system palette
  FStockObjects.Add(TpgPaletteObject.Create(GetStockObject(DEFAULT_PALETTE)));
end;

procedure TpgEmfImport.CreateStrokeFromPen(AParent: TpgPaintable);
var
  AStroke: TpgPaintProp;
begin
  if not assigned(Context.Pen) then exit;
  AStroke := TpgPaintProp.Create;
  if not Context.Pen.Style = PS_NULL then begin
    AStroke.PaintType := ptColor;
    AStroke.Color := Context.Pen.Color;
  end;
  case Context.Pen.Style of
  PS_DASH:;
  PS_DOT:;
  PS_DASHDOT:;
  PS_DASHDOTDOT:;
  PS_NULL:
    AStroke.PaintType := ptNone;
  PS_INSIDEFRAME:;
  end;
  AParent.StartEdit;
  try
    AParent.StrokeWidth.Value := Context.Pen.Width;
    AParent.Stroke := AStroke;
  finally
    AParent.StopEdit;
  end;
end;

destructor TpgEmfImport.Destroy;
begin
  FreeAndNil(FStockObjects);
  FreeAndNil(FObjects);
  inherited;
end;

procedure TpgEmfImport.DoStatus(const AMessage: string);
begin
  if assigned(FOnStatus) then
    FOnStatus(Self, AMessage);
end;

function TpgEmfImport.DrawMetaRecord(DC: HDC; lpHTable: PHANDLETABLE;
  lpEMFR: PENHMETARECORD; nObj: integer): integer;
var
  i: integer;
  AMessage: string;
  Polygon, Polyline: TpgPolyline;
  Path: TpgPath;
  PathStarted: boolean;
  Font: TpgFontObject;
  Palette: TpgPaletteObject;
  AObject: TpgGraphicObject;
  S: string;
  Scale: TpgFloat;
begin
  case lpEMFR.iType of
  EMR_HEADER:
    begin
      ProcessHeader(PEnhMetaHeader(lpEMFR)^, Scene.ViewPort);
      // Add an empty group, which we will fill with GDI commands
      FGroup := TpgGroup.Create(Scene.ViewPort);
    end;
  //EMR_POLYBEZIER:;
  //EMR_POLYGON:;
  //EMR_POLYLINE:;
  //EMR_POLYBEZIERTO:;
  //EMR_POLYLINETO:;
  //EMR_POLYPOLYLINE:;
  //EMR_POLYPOLYGON:;
  EMR_SETWINDOWEXTEX:
    with PEmrSetWindowExtEx(lpEMFR)^ do
      if Context.MapMode in [MM_ANISOTROPIC, MM_ISOTROPIC] then
        Context.WindowExt := pgPoint(szlExtent.cx, szlExtent.cy);
  EMR_SETWINDOWORGEX:
    with PEmrSetWindowOrgEx(lpEMFR)^ do
      Context.WindowOrg := pgPoint(ptlOrigin.X, ptlOrigin.Y);
  EMR_SETVIEWPORTEXTEX:
    with PEmrSetViewportExtEx(lpEMFR)^ do
      if Context.MapMode in [MM_ANISOTROPIC, MM_ISOTROPIC] then
        Context.ViewportExt := pgPoint(szlExtent.cx, szlExtent.cy);
  EMR_SETVIEWPORTORGEX:
    with PEmrSetViewportOrgEx(lpEMFR)^ do
      Context.ViewportOrg := pgPoint(ptlOrigin.X, ptlOrigin.Y);
  //EMR_SETBRUSHORGEX:;
  EMR_EOF:; // End of metafile
  //EMR_SETPIXELV:;
  //EMR_SETMAPPERFLAGS:;
  EMR_SETMAPMODE:
    // We assume that the viewport is always in mm
    with PEmrSetMapMode(lpEMFR)^ do begin
      Context.MapMode := iMode;
      Context.WindowOrg := cNullPoint;
      Context.ViewportOrg := cNullPoint;
      Context.WindowExt := pgPoint(1, 1);
      Scale := 0;
      case iMode of
      MM_ANISOTROPIC, MM_ISOTROPIC, MM_TEXT: Scale := 1;
      MM_HIENGLISH:  Scale := 0.001 * cInchToMm;
      MM_HIMETRIC:   Scale := 0.01;
      MM_LOENGLISH:  Scale := 0.01 * cInchToMm;
      MM_LOMETRIC:   Scale := 0.1;
      MM_TWIPS:      Scale := 1/1440 * cInchToMm;
      end;
      Context.ViewportExt := pgPoint(Scale, Scale);
      if not (iMode in [MM_ANISOTROPIC, MM_ISOTROPIC, MM_TEXT]) then
        Context.ViewportExt.Y := - Context.ViewportExt.Y;
    end;
  EMR_SETBKMODE:
    with PEmrSetBkMode(lpEMFR)^ do begin
      // to do
    end;
  EMR_SETPOLYFILLMODE:
    with PEmrSetPolyFillMode(lpEMFR)^ do
      case iMode of
      ALTERNATE: Context.FillRule := frEvenOdd;
      WINDING:   Context.FillRule := frNonZero;
      end;
  EMR_SETROP2:
    with PEmrSetRop2(lpEMFR)^ do
      // The mix modes are for raster operations, and we work with vector data
      // so they are not used. But we store it just in case
      Context.DrawMode := iMode;
  //EMR_SETSTRETCHBLTMODE:;
  EMR_SETTEXTALIGN:
    with PEmrSetTextAlign(lpEMFR)^ do begin
      // to do
    end;
  //EMR_SETCOLORADJUSTMENT:;
  EMR_SETTEXTCOLOR:
    with PEmrSetTextColor(lpEMFR)^ do begin
      // to do
    end;
  EMR_SETBKCOLOR:
    with PEmrSetBkColor(lpEMFR)^ do begin
      // to do
    end;
  //EMR_OFFSETCLIPRGN:;
  EMR_MOVETOEX:
    with PEmrMoveToEx(lpEMFR)^ do begin
      // to do
    end;
  //EMR_SETMETARGN:;
  //EMR_EXCLUDECLIPRECT:;
  EMR_INTERSECTCLIPRECT:
    with PEmrIntersectClipRect(lpEMFR)^ do begin
      // to do
    end;
  //EMR_SCALEVIEWPORTEXTEX:;
  //EMR_SCALEWINDOWEXTEX:;
  EMR_SAVEDC:
    SaveContext;
  EMR_RESTOREDC:
    with PEmrRestoreDC(lpEMFR)^ do begin
      // to do: check relative parameter
      RestoreContext;
    end;
  //EMR_SETWORLDTRANSFORM:;
  //EMR_MODIFYWORLDTRANSFORM:;
  EMR_SELECTOBJECT:
    with PEmrSelectObject(lpEMFR)^ do begin
      AObject := ObjectByHandle[ihObject];
      if assigned(AObject) then begin
        if AObject is TpgPenObject then
          Context.Pen := TpgPenObject(AObject)
        else if AObject is TpgBrushObject then
          Context.Brush := TpgBrushObject(AObject)
        else if AObject is TpgFontObject then
          Context.Font := TpgFontObject(AObject)
        else if AObject is TpgPaletteObject then
          Context.Palette := TpgPaletteObject(AObject);
      end else begin
        case GetObjectType(ihObject) of
        OBJ_BITMAP:      S := 'Bitmap';
        OBJ_BRUSH:       S := 'Brush';
        OBJ_FONT:        S := 'Font';
        OBJ_PAL:         S := 'Palette';
        OBJ_PEN:         S := 'Pen';
        OBJ_EXTPEN:      S := 'ExtPen';
        OBJ_REGION:      S := 'Region';
        OBJ_DC:          S := 'DC';
        OBJ_MEMDC:       S := 'Mem DC';
        OBJ_METAFILE:    S := 'Metafile';
        OBJ_METADC:      S := 'Meta DC';
        OBJ_ENHMETAFILE: S := 'Enhanced Metafile';
        OBJ_ENHMETADC:   S := 'Enhanced Meta DC';
        else
          S := '';
        end;
        if length(S) > 0 then
          DoStatus(Format(seiUnrecognisedObject, [S]));
      end;
    end;
  EMR_CREATEPEN:
    with PEmrCreatePen(lpEMFR)^ do
      ObjectAdd(CreatePen(ihPen, lopn.lopnStyle, lopn.lopnWidth.X,
        Color32FromColorRef(lopn.lopnColor)));
  EMR_CREATEBRUSHINDIRECT:
    with PEmrCreateBrushIndirect(lpEMFR)^ do
      ObjectAdd(CreateBrush(ihBrush, lb.lbStyle,
        Color32FromColorRef(lb.lbColor), lb.lbHatch));
  EMR_DELETEOBJECT:
    with PEmrDeleteObject(lpEMFR)^ do begin
      AObject := ObjectByHandle[ihObject];
      if not assigned(AObject) then
        raise Exception.Create(seiUnknownGraphicsObject);
      FObjects.Remove(AObject);
    end;
  //EMR_ANGLEARC:;
  //EMR_ELLIPSE:;
  //EMR_RECTANGLE:;
  //EMR_ROUNDRECT:;
  //EMR_ARC:;
  //EMR_CHORD:;
  //EMR_PIE:;
  EMR_SELECTPALETTE:
    with PEmrSelectPalette(lpEMFR)^ do
      Context.Palette := TpgPaletteObject(ObjectByHandle[ihPal]);
  EMR_CREATEPALETTE:
    with PEmrCreatePalette(lpEMFR)^ do begin
      Palette := TpgPaletteObject.Create(ihPal);
      Palette.LogPalette := @lgpl;
      ObjectAdd(Palette);
    end;
  //EMR_SETPALETTEENTRIES:;
  //EMR_RESIZEPALETTE:;
  EMR_REALIZEPALETTE:; // We do not have to realise a palette
  //EMR_EXTFLOODFILL:;
  EMR_LINETO:
    with PEmrLineTo(lpEMFR)^ do begin
      // to do
    end;
  //EMR_ARCTO:;
  EMR_POLYDRAW:
    with PEmrPolyDraw(lpEMFR)^ do begin
      //
    end;
  //EMR_SETARCDIRECTION:;
  //EMR_SETMITERLIMIT:;
  //EMR_BEGINPATH:;
  //EMR_ENDPATH:;
  //EMR_CLOSEFIGURE:;
  //EMR_FILLPATH:;
  //EMR_STROKEANDFILLPATH:;
  //EMR_STROKEPATH:;
  //EMR_FLATTENPATH:;
  //EMR_WIDENPATH:;
  //EMR_SELECTCLIPPATH:;
  //EMR_ABORTPATH:;
  EMR_GDICOMMENT:; // We skip the GDI comment because it is usually senseless info
  //EMR_FILLRGN:;
  //EMR_FRAMERGN:;
  //EMR_INVERTRGN:;
  //EMR_PAINTRGN:;
  EMR_EXTSELECTCLIPRGN:
    with PEmrExtSelectClipRgn(lpEMFR)^ do begin
      // to do
    end;
  //EMR_BITBLT:;
  //EMR_STRETCHBLT:;
  //EMR_MASKBLT:;
  //EMR_PLGBLT:;
  //EMR_SETDIBITSTODEVICE:;
  //EMR_STRETCHDIBITS:;
  EMR_EXTCREATEFONTINDIRECTW:
    with PEmrExtCreateFontIndirect(lpEMFR)^ do
      ObjectAdd(CreateFont(ihFont, @elfw));
  //EMR_EXTTEXTOUTA:;
  //EMR_EXTTEXTOUTW:;
  //EMR_POLYBEZIER16:;
  EMR_POLYGON16:
    with PEmrPolygon16(lpEMFR)^ do
      if Cpts > 0 then begin
        // Add new transformation
        UpdateTransformation;
        // Create polygon
        Polygon := TpgPolygon.Create(FGroup);
        Polygon.StartEdit;
        try
          for i := 0 to cPts - 1 do
            Polygon.Points.PointAdd(pgPoint(aPts[i].x, aPts[i].y));
        finally
          Polygon.StopEdit;
        end;
        // Add to group with correct fill, stroke and fillrule
        CreateFillFromBrush(Polygon);
        CreateStrokeFromPen(Polygon);
      end;
  EMR_POLYLINE16:
    with PEmrPolyline16(lpEMFR)^ do
      if Cpts > 0 then begin
        // Add new transformation
        UpdateTransformation;
        // Create polyline
        Polyline := TpgPolyline.Create(FGroup);
        Polyline.StartEdit;
        try
          for i := 0 to cPts - 1 do
            Polyline.Points.PointAdd(pgPoint(aPts[i].x, aPts[i].y));
        finally
          Polyline.StopEdit;
        end;
        // Add to group with correct fill, stroke and fillrule
        CreateEmptyFill(Polyline);
        CreateStrokeFromPen(Polyline);
      end;
  //EMR_POLYBEZIERTO16:;
  //EMR_POLYLINETO16:;
  //EMR_POLYPOLYLINE16:;
  //EMR_POLYPOLYGON16:;
  EMR_POLYDRAW16:;
{    with PEmrPolydraw16(lpEMFR)^ do begin
      if Cpts > 0 then begin
        // Add new transformation
        UpdateTransformation;
        // Create polyline
        Path := TpgPath.CreateDefaults(Scene);
        Path.StartEdit;
        PathStarted := False;
        try
          for i := 0 to cPts - 1 do begin
            Context.CurrentPosition := pgPoint(aPts[i].x, aPts[i].y);
            case PEmrPolydraw16(lpEMFR)^.abTypes[i] and $06 of
            PT_MOVETO:
              begin
                Path.Path.MoveToAbs(aPts[i].x, aPts[i].y);
                PathStarted := True;
              end;
            PT_LINETO, PT_BEZIERTO:
              begin
                if not PathStarted then begin
                  Path.Path.MoveToAbs(Context.CurrentPosition.X, Context.CurrentPosition.Y);
                  PathStarted := True;
                end;
                Path.Path.LineToAbs(aPts[i].x, aPts[i].y);
              end;
//            PT_BEZIERTO:  Path.Path.LineToAbs(aPts[i].x, aPts[i].y);
            end;
            if ((abTypes[i] and PT_CLOSEFIGURE) > 0) and PathStarted then begin
              Path.Path.ClosePath;
              PathStarted := False;
            end;
          end;
          // Add to group with correct fill, stroke and fillrule
          CreateEmptyFill(Path);
          CreateStrokeFromPen(Path);
          Path.Parent := FGroup;
        finally
          Path.StopEdit;
        end;
      end;
    end;}
  //EMR_CREATEMONOBRUSH:;
  //EMR_CREATEDIBPATTERNBRUSHPT:;
  //EMR_EXTCREATEPEN:;
  //EMR_POLYTEXTOUTA:;
  //EMR_POLYTEXTOUTW:;
  //EMR_SETICMMODE:;
  //EMR_CREATECOLORSPACE:;
  //EMR_SETCOLORSPACE:;
  //EMR_DELETECOLORSPACE:;
  //EMR_GLSRECORD:;
  //EMR_GLSBOUNDEDRECORD:;
  //EMR_PIXELFORMAT:;
  //EMR_DRAWESCAPE:;
  //EMR_EXTESCAPE:;
  //EMR_STARTDOC:;
  //EMR_SMALLTEXTOUT:;
  //EMR_FORCEUFIMAPPING:;
  //EMR_NAMEDESCAPE:;
  //EMR_COLORCORRECTPALETTE:;
  //EMR_SETICMPROFILEA:;
  //EMR_SETICMPROFILEW:;
  //EMR_ALPHABLEND:;
  //EMR_ALPHADIBBLEND:;
  //EMR_TRANSPARENTBLT:;
  //EMR_TRANSPARENTDIB:;
  //EMR_GRADIENTFILL:;
  //EMR_SETLINKEDUFIS:;
  //EMR_SETTEXTJUSTIFICATION:;
  else
    DoStatus(Format(seiUnrecognisedMetafileRecord, [lpEMFR.iType]));
  end;
  // Conclude with non-zero result to continue enumeration
  Result := 1;
end;

function TpgEmfImport.GetContext: PpgDeviceContext;
begin
  Result := @FContexts[FContextCount - 1];
end;

function TpgEmfImport.GetObjectByHandle(Handle: dword): TpgGraphicObject;
var
  i: integer;
begin
  Result := nil;
  // Check initialized objects
  for i := 0 to FObjects.Count - 1 do
    if TpgGraphicObject(FObjects[i]).Handle = Handle then begin
      Result := TpgGraphicObject(FObjects[i]);
      exit;
    end;
  // Check stock objects
  for i := 0 to FStockObjects.Count - 1 do
    if TpgGraphicObject(FStockObjects[i]).Handle = Handle then begin
      Result := TpgGraphicObject(FStockObjects[i]);
      exit;
    end;
end;

procedure TpgEmfImport.InitContexts;
begin
  SetLength(FContexts, 1);
  FContextCount := 1;
  ClearContext(0);
end;

procedure TpgEmfImport.LoadFromStream(S: TStream);
var
  AMeta: TMetaFile;
  AWidth, AHeight: double;
begin
  Clear;
  AMeta := TMetaFile.Create;
  try
    AMeta.LoadFromStream(S);
    // We do not need a device context or rectangle, we want just to enumerate
    // the records and add them in our own format to the scene
    EnumEnhMetafile(0, AMeta.Handle, @EnhMetafileProc, Self, PRect(nil)^);

    // Width/Height
    AWidth := Scene.ViewPort.GetLengthProp(catWidth, 0);
    if AWidth > 0 then Scene.DeviceWidth := AWidth;
    AHeight := Scene.ViewPort.GetLengthProp(catHeight, 0);
    if AHeight > 0 then Scene.DeviceHeight := AHeight;

  finally
    AMeta.Free;
  end;
end;

procedure TpgEmfImport.ObjectAdd(AObject: TpgGraphicObject);
begin
  if assigned(ObjectByHandle[AObject.Handle]) then
    raise Exception(seiGraphicObjectAlreadyExists);
  FObjects.Add(AObject);
end;

procedure TpgEmfImport.ProcessHeader(const AHeader: TEnhMetaHeader;
  AViewPort: TpgViewPort);
var
  ViewBox: TpgViewBoxProp;
begin
  // Check signature
  if AHeader.dSignature <> ENHMETA_SIGNATURE then
    raise Exception.Create(seiInvalidMetafile);
  AViewPort.StartEdit;
  try
    AViewPort.SetBounds(luMm,
       AHeader.rclFrame.Left * 0.01,
       AHeader.rclFrame.Top  * 0.01,
      (AHeader.rclFrame.Right - AHeader.rclBounds.Left) * 0.01,
      (AHeader.rclFrame.Bottom - AHeader.rclBounds.Top) * 0.01);
    ViewBox := TpgViewBoxProp.Create;
    ViewBox.MinX := AHeader.rclBounds.Left;
    ViewBox.MinY := AHeader.rclBounds.Top;
    ViewBox.Width  := AHeader.rclBounds.Right - AHeader.rclBounds.Left;
    ViewBox.Height := AHeader.rclBounds.Bottom - AHeader.rclBounds.Top;
    AViewPort.ViewBox := ViewBox;
    AViewPort.PreserveAspect := paXMidYMid;
  finally
    AViewPort.StopEdit;
  end;
end;

procedure TpgEmfImport.RestoreContext;
begin
  dec(FContextCount);
  if FContextCount < 1 then
    raise Exception.Create(seiRestoreContextOverflow);
end;

procedure TpgEmfImport.SaveContext;
begin
  SetLength(FContexts, FContextCount + 1);
  ClearContext(FContextCount);
  inc(FContextCount);
end;

procedure TpgEmfImport.UpdateTransformation;
var
  Scale: TpgFloat;
  Transform: TpgAffineTransform;
begin
  // Calculate new trasform
  Transform := TpgAffineTransform.Create(nil);
  try
    with Context^ do begin
      if MapMode = MM_ISOTROPIC then begin
        Scale := Min(abs(ViewportExt.X / WindowExt.X), abs(ViewportExt.Y / WindowExt.Y));
        ViewportExt.X := Scale * WindowExt.X;
        ViewportExt.Y := Scale * WindowExt.Y;
      end;
      Transform.Translate(ViewportOrg.X, ViewportOrg.Y);
      Transform.Scale(ViewportExt.X / WindowExt.X, ViewportExt.Y / WindowExt.Y);
      Transform.Translate(-WindowOrg.X, -WindowOrg.Y);
      Transform.MultiplyMatrix(WorldTransform);
    end;

    // Check equality
    if MatrixEqual(Transform.Matrix^, FOldTransform) then exit;

    // Not equal: we must add a new group if old group contains nodes already
    if not assigned(FGroup) or (FGroup.NodeCount > 0) then begin
      FGroup := TpgGroup.CreateDefaults(Scene);
      FGroup.Parent := Scene.ViewPort;
    end;
    if assigned(FGroup) then begin
      if not assigned(FGroup.Transform) then
        FGroup.Transform := TpgAffineTransform.Create(FGroup);
      FGroup.Transform.Assign(Transform);
    end;

    FOldTransform := Transform.Matrix^;
  finally
    Transform.Free;
  end;
end;

end.

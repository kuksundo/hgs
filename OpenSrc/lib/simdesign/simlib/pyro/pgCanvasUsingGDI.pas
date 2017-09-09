{ Project: Pyro
  Module: Pyro Core

  Description:
    GDI canvas is a descendant of TpgCanvas, implementing the drawing commands
    with old-style GDI. It can be used to render to a GDI device context, like
    a printer, without having to resort to bitmaps. Many of the advanced features
    are not available, or have limited quality.

  More specifically:
  * Paths: through GDI Polygon command
  * Bitmaps: through GDI PlgBlt command, this renders parallelograms, so only
      supports affine transforms
  * Clipping regions: through GDI Polygon command and SelectClipPath
  * Blending operations on layers: not supported
  * Push/Pop realised through GDI SaveDC/RestoreDC


  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV

  Modified:
  19may2011: string > Utf8String
}
unit pgCanvasUsingGDI;

interface

uses
  // uses Graphics.pas for FDeviceCanvas (Delphi's TCanvas)
  Classes, SysUtils, Graphics,
  pgCanvas, pgPath, pgPathUsingGDI, pgColor, pgBitmap, pgPolygon, pgPlatform, Pyro;

type

  TpgGDIFont = class(TpgFont)
  private
    FFamily: Utf8String;
    FStyle: TpgFontStyle;
    FWeight: TpgFontWeight;
  public
    property Family: Utf8String read FFamily;
    property Style: TpgFontStyle read FStyle;
    property Weight: TpgFontWeight read FWeight;
  end;

  TpgGDIState = class(TpgState)
  private
    FHDCState: integer;
  end;

  TpgCustomGDICanvas = class(TpgCanvas)
  private
    FDeviceCanvas: TCanvas;
    FClipRect: TpgRect;
    FScratchBitmap: TBitmap;
    FSBuf: array of TpgPoint;
    FIBuf: array of TpgiPoint;
    function ConvertColor(AColor: TpgColor32; const ColorInfo: TpgColorInfo): TColor;
  protected
    function GetDeviceHandle: longword; override;
    procedure SetCanvasStylesFromPaint(ACanvas: TCanvas; AFill: TpgFill; AStroke: TpgStroke);
    procedure BuildGDIPolygon(APath: TpgPath);
    function GetDeviceRect: TpgRect; override;
    procedure SetDeviceRect(const ARect: TpgRect); override;
    // Set DeviceCanvas to the canvas you want to render on. This can be a canvas
    // of a TBitmap, TMetafile or TPrinter.
    property DeviceCanvas: TCanvas read FDeviceCanvas write FDeviceCanvas;
    function CreateState(AOwner: TpgCanvas): TpgState; override;
    procedure WakeLayer(ALayer: TpgLayer); override;
  public
    destructor Destroy; override;
    function NewPath: TpgPath; override;
    function NewFont(AFamily: Utf8String; AStyle: TpgFontStyle; AVariant: TpgFontVariant;
      AWeight: TpgFontWeight; AStretch: TpgFontStretch;
      ARenderMethod: TpgFontRenderMethod): TpgFont; overload; override;
    procedure FillDeviceRect(R: TpgRect; AColor: TpgColor32); override;
    procedure PaintBitmap(ABitmap: TpgColorMap; X, Y, Width, Height: double); override;
    procedure PaintPath(APath: TpgPath; AFill: TpgFill; AStroke: TpgStroke); override;
    procedure PaintText(const X, Y: double; const Text: Utf8String; Font: TpgFont;
      FontSize: double; Fill: TpgFill; Stroke: TpgStroke; Anchor: TpgTextAnchor = taStart); override;
    function MeasureText(const X, Y: double; const Text: Utf8String; Font: TpgFont;
      FontSize: double; Anchor: TpgTextAnchor = taStart): TpgBox; override;
    function IsRectangleVisible(ARect: TpgBox): boolean; override;
    procedure ClipPath(APath: TpgPath); override;
    function Push: TpgState; override;
    procedure Pop(AState: TpgState); override;
  end;

  TpgGDICanvas = class(TpgCustomGDICanvas)
  public
    property DeviceCanvas;
  end;

  // TpgGDIBitmapCanvas is a GDI canvas that implements buffering to a bitmap.
  TpgGDIBitmapCanvas = class(TpgCustomGDICanvas)
  private
    FBitmap: TBitmap;
  protected
    procedure SetDeviceRect(const ARect: TpgRect); override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

resourcestring

  sNotImplemented = 'Not implemented';

implementation

type
  TLayerAccess = class(TpgLayer); // this is always eery, but for now needs to be there

{ TpgCustomGDICanvas }

procedure TpgCustomGDICanvas.BuildGDIPolygon(APath: TpgPath);
var
  i, PointCount: integer;
begin
  PointCount := APath.AsPolyPolygon.PointCount;
  SetLength(FSBuf, PointCount);
  SetLength(FIBuf, PointCount);
  Transforms.TransformPoints(APath.AsPolyPolygon.FirstPoint, @FSBuf[0], PointCount);

  for i := 0 to PointCount - 1 do
  begin
    FIBuf[i].X := round(FSBuf[i].X);
    FIBuf[i].Y := round(FSBuf[i].Y);
  end;
end;

procedure TpgCustomGDICanvas.ClipPath(APath: TpgPath);
var
  i: integer;
  PP: TpgPolyPolygon;
begin
  pgBeginPath(DeviceHandle);

  BuildGDIPolygon(APath);

  PP := APath.AsPolyPolygon;
  for i := 0 to PP.Count - 1 do
    pgPlatform.pgPolygon(FDeviceCanvas.Handle,
      FIBuf[PP[i].PointIndex], PP[i].PointCount);

  pgEndPath(DeviceHandle);
  pgSelectClipPath(DeviceHandle, pgRGN_AND);
end;

function TpgCustomGDICanvas.ConvertColor(AColor: TpgColor32; const ColorInfo: TpgColorInfo): TColor;
var
  C: TpgColor32;
begin
  C := pgColorTo4Ch8b(ColorInfo, cARGB_8b_Org, @AColor);
  Result := (C shr 16) and $FF + (C and $00FF00) + (C and $FF) shl 16;
end;

function TpgCustomGDICanvas.CreateState(AOwner: TpgCanvas): TpgState;
begin
  Result := TpgGDIState.Create(AOwner);
end;

destructor TpgCustomGDICanvas.Destroy;
begin
  FreeAndNil(FScratchBitmap);
  inherited;
end;

procedure TpgCustomGDICanvas.FillDeviceRect(R: TpgRect; AColor: TpgColor32);
var
  X1, X2, Y1, Y2: integer;
begin
  X1 := R.Left;
  Y1 := R.Top;
  X2 := R.Right;
  Y2 := R.Bottom;
  X1 := pgLimit(X1, FClipRect.Left, FClipRect.Right);
  Y1 := pgLimit(Y1, FClipRect.Top, FClipRect.Bottom);
  X2 := pgLimit(X2, FClipRect.Left, FClipRect.Right);
  Y2 := pgLimit(Y2, FClipRect.Top, FClipRect.Bottom);
  if (X1 >= X2) or (Y1 >= Y2) then exit;
  FDeviceCanvas.Brush.Style := bsSolid;
  FDeviceCanvas.Brush.Color := ConvertColor(AColor, ColorInfo^);
  FDeviceCanvas.Pen.Style := psClear;
  FDeviceCanvas.FillRect(Rect(X1, Y1, X2, Y2));
end;

function TpgCustomGDICanvas.GetDeviceHandle: longword;
begin
  Result := FDeviceCanvas.Handle;
end;

function TpgCustomGDICanvas.GetDeviceRect: TpgRect;
begin
  Result := TpgRect(FClipRect);
end;

function TpgCustomGDICanvas.IsRectangleVisible(ARect: TpgBox): boolean;
begin
// todo
  Result := True;
end;

function TpgCustomGDICanvas.MeasureText(const X, Y: double;
  const Text: Utf8String; Font: TpgFont; FontSize: double;
  Anchor: TpgTextAnchor): TpgBox;
// untested
var
  Pc, Pd: TpgPoint;
  DFont: TFont;
  H: double;
  S: TpgSizeR;
begin
  // Find the text insertion point in device coords
  Pc := pgPoint(X, Y);
  Pd := Transforms.Transform(Pc);
  // Setup font
  DFont := FDeviceCanvas.Font;
  DFont.Name := TpgGDIFont(Font).Family;
  H := FontSize * Transforms.GetPixelScale(cdUnknown);
  DFont.Height := -round(H);
  pgSetTextAlign(FDeviceCanvas.Handle, pgTA_BASELINE);
  S := TpgSizeR(FDeviceCanvas.TextExtent(Utf8Decode(Text)));
  Result.Lft := Pd.X;
  Result.Rgt := Pd.X + S.cx;
  Result.Top := Pd.Y - H * 0.7;
  Result.Btm := Pd.Y + H * 0.3;
end;

function TpgCustomGDICanvas.NewFont(AFamily: Utf8String; AStyle: TpgFontStyle;
  AVariant: TpgFontVariant; AWeight: TpgFontWeight;
  AStretch: TpgFontStretch; ARenderMethod: TpgFontRenderMethod): TpgFont;
begin
  Result := TpgGDIFont.Create;
  TpgGDIFont(Result).FFamily := AFamily;
  TpgGDIFont(Result).FStyle := AStyle;
  TpgGDIFont(Result).FWeight := AWeight;
  // we dont care too much about the rest
  Objects.Add(Result);
end;

function TpgCustomGDICanvas.NewPath: TpgPath;
begin
  Result := TpgGDIPath.Create;
  Objects.Add(Result);
end;

procedure TpgCustomGDICanvas.PaintBitmap(ABitmap: TpgColorMap; X, Y, Width,
  Height: double);
var
  W, H: integer;
  L0, L1: pointer;
//  Bmi: TBitmapInfo;
  Pts: array[0..2] of TpgiPoint;
//  Src: HDC;
//  HBmp: HBitmap;
  function TransformPoint(X, Y: single): TpgiPoint;
  var
    D: TpgPoint;
  begin
    D := Transforms.Transform(pgPoint(X, Y));
    Result.X := round(D.X);
    Result.Y := round(D.Y);
  end;
begin
  // Check width/height
  W := ABitmap.Width;
  H := ABitmap.Height;
  if (W = 0) or (H = 0) then
    exit;

  // Do we have the scratch bitmap?
  if not assigned(FScratchBitmap) then
    FScratchBitmap := TBitmap.Create;

  // Setup a top-down 32bit scratch bitmap
  FScratchBitmap.PixelFormat := pf32bit;
  FScratchBitmap.Width := W;
  FScratchBitmap.Height := -H;
  L0 := FScratchBitmap.ScanLine[0];
  if H > 1 then
  begin
    L1 := FScratchBitmap.ScanLine[1];
    if integer(L0) > integer(L1) then
      L0 := FScratchBitmap.ScanLine[H - 1];
  end;

  // Copy our bitmap to this scratch bitmap, make sure colours are correct,
  // and to use the correct scanline pointer
  pgConvertColorArray(ABitmap.ColorInfo, cARGB_8b_Org, ABitmap.Map, L0,
    ABitmap.ElementCount);

  Pts[0] := TransformPoint(0, 0);
  Pts[1] := TransformPoint(W, 0);
  Pts[2] := TransformPoint(0, H);

  // In GDI, the best we can do is a parallelogram..
  pgPlgBlt(DeviceHandle, Pts, FScratchBitmap.Canvas.Handle, 0, 0, round(Width), round(Height), 0, 0, 0);
end;

procedure TpgCustomGDICanvas.PaintPath(APath: TpgPath; AFill: TpgFill; AStroke: TpgStroke);
var
  i: integer;
  PP: TpgPolyPolygon;
begin
  SetCanvasStylesFromPaint(FDeviceCanvas, AFill, AStroke);
  BuildGDIPolygon(APath);

  PP := APath.AsPolyPolygon;
  for i := 0 to PP.Count - 1 do
    pgPlatform.pgPolygon(FDeviceCanvas.Handle,
      FIBuf[PP[i].PointIndex], PP[i].PointCount);
end;

procedure TpgCustomGDICanvas.PaintText(const X, Y: double; const Text: Utf8String;
  Font: TpgFont; FontSize: double; Fill: TpgFill; Stroke: TpgStroke;
  Anchor: TpgTextAnchor);
// We don't support rotated text for GDI canvas yet
var
  Pc, Pd: TpgPoint;
  DFont: TFont;
  H: double;
begin
  // Find the text insertion point in device coords
  Pc := pgPoint(X, Y);
  Pd := Transforms.Transform(Pc);
  // Setup font
  DFont := FDeviceCanvas.Font;
  DFont.Name := TpgGDIFont(Font).Family;
  H := FontSize * Transforms.GetPixelScale(cdUnknown);
  DFont.Height := -round(H);
  if Fill.PaintStyle = psColor then
    DFont.Color := ConvertColor(Fill.Color, ColorInfo^);

  // No unicode..
  pgSetTextAlign(FDeviceCanvas.Handle, pgTA_BASELINE);
  FDeviceCanvas.Brush.Style := bsClear;
  FDeviceCanvas.TextOut(round(Pd.X), round(Pd.Y{ - H}), Utf8Decode(Text));
end;

procedure TpgCustomGDICanvas.Pop(AState: TpgState);
begin
  inherited;
  pgRestoreDC(DeviceHandle, TpgGDIState(AState).FHDCState);
end;

function TpgCustomGDICanvas.Push: TpgState;
begin
  Result := inherited Push;
  TpgGDIState(Result).FHDCState := pgSaveDC(DeviceHandle);
end;

procedure TpgCustomGDICanvas.SetCanvasStylesFromPaint(ACanvas: TCanvas; AFill: TpgFill; AStroke: TpgStroke);
begin
  if assigned(AFill) then
  begin
    case AFill.PaintStyle of
    psNone:
      ACanvas.Brush.Style := bsClear;
    psColor:
      begin
        ACanvas.Brush.Style := bsSolid;
        ACanvas.Brush.Color := ConvertColor(AFill.Color, ColorInfo^);
      end;
    else
      // we cannot do this
      ACanvas.Brush.Style := bsCross;
      ACanvas.Brush.Color := clBlack;
    end;
  end else
    ACanvas.Brush.Style := bsClear;

  if assigned(AStroke) then
  begin
    case AStroke.PaintStyle of
    psNone:
      ACanvas.Pen.Style := psClear;
    psColor:
      begin
        ACanvas.Pen.Style := psSolid;
        ACanvas.Pen.Color := ConvertColor(AStroke.Color, ColorInfo^);
      end;
    else
      // we cannot do this
      ACanvas.Pen.Style := psSolid;
      ACanvas.Pen.Color := clBlack;
    end;
    ACanvas.Pen.Width := round(AStroke.Width * Transforms.GetPixelScale(cdUnknown));
  end else
    ACanvas.Pen.Style := psClear;
end;

procedure TpgCustomGDICanvas.SetDeviceRect(const ARect: TpgRect);
begin
  FClipRect := ARect;
end;

procedure TpgCustomGDICanvas.WakeLayer(ALayer: TpgLayer);
// We make the layer's canvas point to the owner canvas, so all drawing operations
// just go directly through to the one and only GDI canvas. The Custom GDI canvas
// therefore does not support block blending and effects operations
begin
  if not ALayer.IsCached then
  begin
    // Point the layer's canvas to it's owner canvas, and *make sure* it does
    // not own it!
    TLayerAccess(ALayer).FCanvas := TLayerAccess(ALayer).FOwner;
    TLayerAccess(ALayer).FOwnsCanvas := False;
  end;
end;

{ TpgGDIBitmapCanvas }

constructor TpgGDIBitmapCanvas.Create;
begin
  inherited;
  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf32bit;
  FDeviceCanvas := FBitmap.Canvas;
end;

destructor TpgGDIBitmapCanvas.Destroy;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

procedure TpgGDIBitmapCanvas.SetDeviceRect(const ARect: TpgRect);
begin
  inherited;
  FBitmap.Width := ARect.Right - ARect.Left;
  FBitmap.Height := ARect.Bottom - ARect.Top;
  // Do a transform in the canvas
  pgSetWindowOrgEx(FDeviceCanvas.Handle, ARect.Left, ARect.Top, nil);
end;

initialization
  RegisterCanvasClass(ctGDI, TpgGDIBitmapCanvas);

end.

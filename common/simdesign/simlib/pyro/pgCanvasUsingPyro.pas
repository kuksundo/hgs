{ Project: Pyro
  Module: Pyro Render

  Description:
  A TpgPyroCanvas is a descendant of TpgCanvas, providing high-quality rendering
  onto a selected surface.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV

  Modified:
  19may2011: string > Utf8String
}
unit pgCanvasUsingPyro;

{$i simdesign.inc}

interface

uses
  Classes, Graphics, SysUtils,

  // pyro
  pgCanvas, pgPath, pgSurface, pgTransform, pgPolygonRasterizer, pgCover, pgBitmap,
  pgStroker, pgDocument, pgSampler, pgFontUsingRender, pgBlend, pgRegion, pgWinGDI,
  Pyro;

type

  TpgPyroFont = class(TpgFont)
  private
    FRenderFont: TpgRenderFont;
  protected
    property RenderFont: TpgRenderFont read FRenderFont;
  end;

  // TpgPyroCanvas is a TpgCanvas descendant that uses Pyro's rendering engine
  // to produce content.
  TpgPyroCanvas = class(TpgCanvas)
  private
    FStrokePath: TpgRenderPath;
    FStroker: TpgStroker;
    FRasterizer: TpgRasterizer;
    FCover: TpgCover;
    FScratchCover: TpgCover;
    FFontCache: TpgRenderFontCache;
    // Add a new clip cover to the state if not yet done
    procedure InitializeClipCover;
    // Get the clip cover
    function GetClipCover: TpgCover;
  protected
    FSurface: TpgSurface;
    FSurfaceLeft: integer;
    FSurfaceTop: integer;
    FC2S: TpgAffineTransform; // additional transform from canvas to surface
    procedure FillPath(APath: TpgPath; AFill: TpgFill);
    procedure StrokePath(APath: TpgPath; AStroke: TpgStroke);
    function GetDeviceRect: TpgRect; override;
    procedure SetDeviceRect(const ARect: TpgRect); override;
    function GetSurfaceColorInfo: PpgColorInfo;
    procedure BlendTo(ACanvas: TpgCanvas; AShiftX, AShiftY: integer; AAlpha: byte; AColorOp: TpgColorOp); override;
    procedure AssignState(ACanvas: TpgCanvas); override;
  public
    // Create a canvas. After this, the protected field FSurface must be set to
    // a TpgSurface of the correct type. The surface is owned
    // by the canvas, and will be destroyed in Destroy.
    constructor Create; override;
    destructor Destroy; override;
    function NewPath: TpgPath; override;
    function NewFont(AFamily: Utf8String; AStyle: TpgFontStyle; AVariant: TpgFontVariant;
      AWeight: TpgFontWeight; AStretch: TpgFontStretch;
      ARenderMethod: TpgFontRenderMethod): TpgFont; overload; override;
    function NewRegion(ARegionType: TpgRegionType): TpgRegion; override;  
    procedure FillDeviceRect(R: TpgRect; AColor: TpgColor32); override;
    procedure PaintPath(APath: TpgPath; AFill: TpgFill; AStroke: TpgStroke); override;
    procedure PaintBitmap(ABitmap: TpgColorMap; X, Y, Width, Height: double); override;
    procedure PaintText(const X, Y: double; const Text: Utf8String; Font: TpgFont;
      FontSize: double; Fill: TpgFill; Stroke: TpgStroke; Anchor: TpgTextAnchor = taStart); override;
    function MeasureText(const X, Y: double; const Text: Utf8String; Font: TpgFont;
      FontSize: double; Anchor: TpgTextAnchor = taStart): TpgBox; override;
    function IsRectangleVisible(ARect: TpgBox): boolean; override;
    procedure ClipPath(APath: TpgPath); override;
    property SurfaceColorInfo: PpgColorInfo read GetSurfaceColorInfo;
  end;

  // TpbPyroBitmapCanvas is a TpgPyroCanvas descendant that automatically buffers
  // to a pf32bit bitmap
  TpgPyroBitmapCanvas = class(TpgPyroCanvas)
  private
    FBitmap: TBitmap;
  protected
    function GetDeviceHandle: longword; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Bitmap: TBitmap read FBitmap;
  end;

implementation


type
  TStrokeAccess = class(TpgStroke);
  TCanvasAccess = class(TpgCanvas);

{ TpgPyroCanvas }

procedure TpgPyroCanvas.AssignState(ACanvas: TpgCanvas);
begin
  inherited;
  if assigned(TCanvasAccess(ACanvas).CurrentState.ClipRegion) then
  begin
    InitializeClipCover;
    GetClipCover.Assign(TCanvasAccess(ACanvas).CurrentState.ClipRegion);
  end;
end;

procedure TpgPyroCanvas.BlendTo(ACanvas: TpgCanvas; AShiftX, AShiftY: integer; AAlpha: byte; AColorOp: TpgColorOp);
var
  RS, RD, RI: TpgRect;
  S0, D0, S1, D1: Pbyte;
  DC: TpgPyroCanvas;
  W, H: integer;
  SStride, DStride: integer;
begin
  if not (ACanvas is TpgPyroCanvas) then exit;
  DC := TpgPyroCanvas(ACanvas);

  // Rectangles
  RD := ACanvas.DeviceRect;
  RS := DeviceRect;
  pgOffsetRect(RS, AShiftX, AShiftY);
  pgIntersectRect(RI, RS, RD);
  if pgIsRectEmpty(RI) then exit;
  W := RI.Right - RI.Left;
  H := RI.Bottom - RI.Top;
  SStride := 0;
  DStride := 0;
  S0 := nil;
  D0 := nil;

  // Surface pointers - the strides are often negative for GDI bitmaps! This is ok.
  if FSurface is TpgAbstract4Ch8bSurface then
  begin
    S0 := PByte(TpgAbstract4Ch8bSurface(FSurface).MapPointer(0, 0));
    if H > 1 then
    begin
      S1 := PByte(TpgAbstract4Ch8bSurface(FSurface).MapPointer(0, 1));
      SStride := integer(S1) - integer(S0);
    end;
  end;
  if DC.FSurface is TpgAbstract4Ch8bSurface then
  begin
    D0 := PByte(TpgAbstract4Ch8bSurface(DC.FSurface).MapPointer(0, 0));
    if H > 1 then
    begin
      D1 := PByte(TpgAbstract4Ch8bSurface(DC.FSurface).MapPointer(0, 1));
      DStride := integer(D1) - integer(D0);
    end;
  end;
  if (S0 = nil) or (D0 = nil) then exit;

  AlphaBlendBlock(
    D0, DStride, RI.Left - RD.Left, RI.Top - RD.Top, W, H,
    S0, SStride, RI.Left - RS.Left, RI.Top - RS.Top,
    AAlpha, GetSurfaceColorInfo^, AColorOp);
end;

procedure TpgPyroCanvas.ClipPath(APath: TpgPath);
begin
  InitializeClipCover;

  FRasterizer.FillRule := ClipRule;
  FRasterizer.Cover := FCover;
  FRasterizer.RasterizePolyPolygon(APath.AsPolyPolygon, Transforms.ToXForm);

  // Now we update the clip region
  GetClipCover.CombineAND(FCover, FScratchCover);
end;

constructor TpgPyroCanvas.Create;
begin
  inherited Create;
  FC2S := TpgAffineTransform.Create;
  Transforms.Concat(FC2S);

  FStrokePath := TpgRenderPath.Create;
  FStroker := TpgStroker.Create;
  FRasterizer := TpgRasterizer.Create;
  FCover := TpgCover.Create;
  FScratchCover := TpgCover.Create;

  FFontCache := TpgRenderFontCache.Create;
end;

destructor TpgPyroCanvas.Destroy;
begin
  FreeAndNil(FStrokePath);
  FreeAndNil(FStroker);
  FreeAndNil(FRasterizer);
  FreeAndNil(FCover);
  FreeAndNil(FSurface);
  FreeAndNil(FC2S);
  FreeAndNil(FFontCache);
  FreeAndNil(FScratchCover);
  inherited;
end;

procedure TpgPyroCanvas.FillDeviceRect(R: TpgRect; AColor: TpgColor32);
var
  X1, X2, Y1, Y2: integer;
begin
  pgOffsetRect(R, -FSurfaceLeft, -FSurfaceTop);
  X1 := R.Left;
  Y1 := R.Top;
  X2 := R.Right;
  Y2 := R.Bottom;
  X1 := pgLimit(X1, 0, FSurface.Width);
  Y1 := pgLimit(Y1, 0, FSurface.Height);
  X2 := pgLimit(X2, 0, FSurface.Width);
  Y2 := pgLimit(Y2, 0, FSurface.Height);
  if (X1 >= X2) or (Y1 >= Y2) then exit;

  FSurface.FillRectangle(X1, Y1, X2 - X1, Y2 - Y1, @AColor, ColorInfo^);
end;

procedure TpgPyroCanvas.FillPath(APath: TpgPath; AFill: TpgFill);
var
  Col: TpgColor32;
  Bitmap: TpgBitmap;
  Sampler: TpgSampler;
begin
  if not (APath is TpgRenderPath) then
    raise Exception.Create(sPathConversionNotImplemented);

  FRasterizer.FillRule := AFill.FillRule;
  FRasterizer.Cover := FCover;
  FRasterizer.RasterizePolyPolygon(APath.AsPolyPolygon, Transforms.ToXForm);

  // Now we do the clipping, if any
  if GetClipCover <> nil then
    FCover.CombineAND(GetClipCover, FScratchCover);

  // Cover does contain data?
  if FCover.SpanCount = 0 then
    exit;

  if AFill.PaintStyle = psColor then
  begin

    Col := PaintAsColor32(AFill);
    FSurface.PaintCover(FCover, @Col, ColorInfo^);

  end else
  begin

    if AFill.PaintStyle = psBitmap then
    begin
      Sampler := nil;
      if AFill.Reference is TpgBitmap then
      begin
        // Bitmap
        Bitmap := TpgBitmap(AFill.Reference);
        if Bitmap.IsEmpty then exit; 
        Sampler := TpgMapSampler.Create;
        TpgMapSampler(Sampler).OverSampling := OverSampling;
        TpgMapSampler(Sampler).InterpolationMethod := InterpolationMethod;
        TpgMapSampler(Sampler).Map := Bitmap;
      end;
      if assigned(Sampler) then
      begin
        Sampler.InvertFromTransformList(Transforms);
        FSurface.PaintCoverWithSampler(FCover, Sampler, round(AFill.Opacity * 255));
        Sampler.Free;
      end;
    end;

  end;
end;

function TpgPyroCanvas.GetClipCover: TpgCover;
begin
  Result := TpgCover(CurrentState.ClipRegion);
end;

function TpgPyroCanvas.GetDeviceRect: TpgRect;
begin
  Result.Left := FSurfaceLeft;
  Result.Top := FSurfaceTop;
  Result.Right := FSurfaceLeft + FSurface.Width;
  Result.Bottom := FSurfaceTop + FSurface.Height;
end;

function TpgPyroCanvas.GetSurfaceColorInfo: PpgColorInfo;
begin
  Result := FSurface.ColorInfo;
end;

procedure TpgPyroCanvas.InitializeClipCover;
var
  S, P: TpgState;
  PrevClip: TObject;
  i, W, H: integer;
  ClipCover: TpgCover;
begin
  S := CurrentState;
  P := States[States.Count - 2];
  if assigned(P) then
    PrevClip := P.ClipRegion
  else
    PrevClip := nil;

  if S.ClipRegion = PrevClip then
  begin
    // Add a clip region
    ClipCover := TpgCover.Create;
    S.ClipRegion := ClipCover;
    W := FSurface.Width;
    H := FSurface.Height;
    ClipCover.SetSize(W, H);

    // Add solid covers, filling the region
    for i := 0 to H - 1 do
      ClipCover.AddSolidSpan(0, i, W, $FF);
  end;
end;

function TpgPyroCanvas.IsRectangleVisible(ARect: TpgBox): boolean;
var
  R: TpgRect;
begin
  // For now, until we have clipping functionality
  R := pgBoxToRect(ARect);
  Result := pgIntersectRect(R, GetDeviceRect, R);
end;

function TpgPyroCanvas.MeasureText(const X, Y: double; const Text: Utf8String;
  Font: TpgFont; FontSize: double; Anchor: TpgTextAnchor): TpgBox;
var
  i, Count: integer;
  Glyph: TpgGlyph;
  AdvX, AdvY: double;
  BB: TpgBox;
  WText: WideString;
begin
  Result := cEmptyBox;
  WText := Utf8Decode(Text);
  Count := length(WText);
  AdvX := 0; AdvY := 0;

  // Do the characters one at the time
  for i := 1 to Count do
  begin
    Glyph := TpgPyroFont(Font).RenderFont.Glyphs[@WText[i]];
    if i = 1 then
      Result := Glyph.BlackBox^
    else begin
      BB := Glyph.BlackBox^;
      pgMoveBox(BB, AdvX, AdvY);
      Result := pgUnionBox(Result, BB);
    end;
    AdvX := AdvX + Glyph.AdvanceX;
    AdvY := AdvY + Glyph.AdvanceY;
  end;

  pgScaleBox(Result, FontSize, FontSize);
  pgMoveBox(Result, X, Y);
end;

function TpgPyroCanvas.NewFont(AFamily: Utf8String; AStyle: TpgFontStyle;
  AVariant: TpgFontVariant; AWeight: TpgFontWeight;
  AStretch: TpgFontStretch; ARenderMethod: TpgFontRenderMethod): TpgFont;
begin
  Result := TpgPyroFont.Create;
  TpgPyroFont(Result).FRenderFont := FFontCache.GetFont(AFamily, AStyle, AVariant, AWeight, AStretch, ARenderMethod);
  Objects.Add(Result);
end;

function TpgPyroCanvas.NewPath: TpgPath;
begin
  Result := TpgRenderPath.Create;
  // Set defaults
  Result.PixelScale := PixelScale;
  if not IsLinear then
    Result.BreakupLength := 2 / PixelScale;
  Objects.Add(Result);
end;

function TpgPyroCanvas.NewRegion(ARegionType: TpgRegionType): TpgRegion;
begin
  // todo
  Result := inherited NewRegion(ARegionType);
end;

procedure TpgPyroCanvas.PaintBitmap(ABitmap: TpgColorMap; X, Y, Width, Height: double);
var
  Path: TpgPath;
  Fill: TpgFill;
  T: TpgAffineTransform;
begin
  if (ABitmap.Width = 0) or (ABitmap.Height = 0) then
    exit;

  Path := NewPath;
  Fill := NewFill;
  Fill.Reference := ABitmap;

  // Additional viewbox transform?
  T := nil;
  if (ABitmap.Width <> Width) or (ABitmap.Height <> Height) or (X <> 0) or (Y <> 0) then
  begin
    T := BuildViewBoxTransform(X, Y, Width, Height,
      0, 0, ABitmap.Width, ABitmap.Height,
      paNone, msUnknown);
    Transforms.Concat(T);
  end;

  Path.Rectangle(0, 0, ABitmap.Width, ABitmap.Height, 0, 0);
  FillPath(Path, Fill);
  if assigned(T) then begin
    Transforms.Delete(Transforms.Count - 1);
    T.Free;
  end;

  Objects.Remove(Fill);
  Objects.Remove(Path);
end;

procedure TpgPyroCanvas.PaintPath(APath: TpgPath; AFill: TpgFill; AStroke: TpgStroke);
begin
  if assigned(AFill) and (AFill.PaintStyle <> psNone) then
    FillPath(APath, AFill);
  if assigned(AStroke) and (AStroke.PaintStyle <> psNone) then
    Strokepath(APath, AStroke);
end;

procedure TpgPyroCanvas.PaintText(const X, Y: double; const Text: Utf8String;
  Font: TpgFont; FontSize: double; Fill: TpgFill; Stroke: TpgStroke;
  Anchor: TpgTextAnchor);
var
  CS: TpgState;
  i, Count: integer;
  Glyph: TpgGlyph;
  Path: TpgPath;
  WText: WideString;
  T: TpgAffineTransform;
  BlackBoxPath: TpgPath;
  BlackBoxStroke: TpgStroke;
begin
  // Do the characters one at the time
  CS := Push;
  BlackBoxPath := NewPath;
  BlackBoxStroke := NewStroke;
  BlackBoxStroke.Color := clRed32;
  BlackBoxStroke.Width := 0.005;
  WText := Utf8Decode(Text);
  Count := length(WText);
  T := TpgAffineTransform.Create;
  Translate(X, Y);
  Scale(FontSize, FontSize);
  AddTransform(T);
  for i := 1 to Count do
  begin
    Glyph := TpgPyroFont(Font).RenderFont.Glyphs[@WText[i]];
    Path := Glyph.Path;
    PaintPath(Path, Fill, Stroke);
      BlackBoxPath.Clear;
      BlackBoxPath.Rectangle(Glyph.BlackBox.Left, Glyph.BlackBox.Top,
        Glyph.BlackBox.Right - Glyph.BlackBox.Left, Glyph.BlackBox.Bottom - Glyph.BlackBox.Top, 0, 0);
      PaintPath(BlackBoxPath, nil, BlackBoxStroke);
    Translate(Glyph.AdvanceX, Glyph.AdvanceY);
      Transforms.Invalidate;
  end;
  Pop(CS);
end;

procedure TpgPyroCanvas.SetDeviceRect(const ARect: TpgRect);
// Setting the device rect will resize the surface, initialize the cover
// and clipping box, and reset the clipping region
var
  W, H: integer;
begin
  FSurfaceLeft := ARect.Left;
  FSurfaceTop  := ARect.Top;
  FC2S.Identity;
  FC2S.Translate(-ARect.Left, -ARect.Top);
  Transforms.Invalidate;
  W := ARect.Right - ARect.Left;
  H := ARect.Bottom - ARect.Top;
  FSurface.SetSize(W, H);
  FCover.SetSize(W, H);
end;

procedure TpgPyroCanvas.StrokePath(APath: TpgPath; AStroke: TpgStroke);
var
  Col: TpgColor32;
begin
  FStrokePath.Clear;

  FStroker.StrokeWidth := AStroke.Width;
  FStroker.DashArray := TStrokeAccess(AStroke).FDashArray;
  FStroker.DashOffset := AStroke.DashOffset;
  FStroker.Stroke(APath, FStrokePath);

  FRasterizer.FillRule := frNonZero;
  FRasterizer.Cover := FCover;
  FRasterizer.RasterizePolyPolygon(FStrokePath.AsPolyPolygon, Transforms.ToXForm);

  // Now we do the clipping, if any
  if GetClipCover <> nil then
    FCover.CombineAND(GetClipCover, FScratchCover);

  // Cover does contain data?
  if FCover.SpanCount = 0 then
    exit;

  Col := PaintAsColor32(AStroke);
  FSurface.PaintCover(FCover, @Col, ColorInfo^);
end;

{ TpgPyroBitmapCanvas }

constructor TpgPyroBitmapCanvas.Create;
begin
  inherited;
  FSurface := TpgGDIBmp32Surface.Create;
  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf32bit;
  TpgGDIBmp32Surface(FSurface).BorrowBitmap(FBitmap);
end;

destructor TpgPyroBitmapCanvas.Destroy;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

function TpgPyroBitmapCanvas.GetDeviceHandle: longword;
begin
  Result := FBitmap.Canvas.Handle;
end;

initialization
  RegisterCanvasClass(ctPyro, TpgPyroBitmapCanvas);

end.

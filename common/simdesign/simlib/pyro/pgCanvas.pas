{ Project: Pyro
  Module: Pyro Core

  Description:
  Base canvas class from which descendent classes are built.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV

  Modified:
  19may2011: string > Utf8String
}
unit pgCanvas;

{$i simdesign.inc}

interface

uses
  Classes, Contnrs, SysUtils,
  // simdesign
  sdSortedLists,
  // pyro
  pgPath, pgTransform, pgColor, pgBitmap, pgBlend, pgRegion, Pyro;

type

  TpgCanvas = class;
  TpgLayer = class;
  TpgLayerList = class;

  TpgFloatList = class(TPersistent)
  private
    FItems: array of double;
    function GetCount: integer;
    function GetItems(Index: integer): double;
    procedure SetItems(Index: integer; const Value: double);
  public
    procedure Add(AValue: double);
    property Items[Index: integer]: double read GetItems write SetItems; default;
    property Count: integer read GetCount;
  end;

  // Paint definition for use in the canvas. By default, Paint uses the Paintstyle
  // psPaint, but by setting reference to e.g. a bitmap, paintstye psReference
  // will be used (so the paint defines a bitmap, gradient, etc). The FillPath
  // procedure will use this info to use the correct sampler.
  TpgPaint = class(TPersistent)
  private
    FOwner: TpgCanvas;
    FColor: TpgColor;
    FPaintStyle: TpgPaintStyle;
    FOpacity: double;
    FReference: TObject;
    function GetColor: TpgColor32;
    procedure SetColor(const Value: TpgColor32);
    function GetColorInfo: PpgColorInfo;
    procedure SetReference(const Value: TObject);
  public
    constructor Create(AOwner: TpgCanvas); virtual;
    // Set this paint's color from AColor and AInfo (this converts the color
    // to the color space of the paint, which is the color space of the parent
    // canvas).
    procedure SetColorWithInfo(const AColor: TpgColor; AInfo: PpgColorInfo);
    // Set or get the color as TpgColor32 (most often used)
    property Color: TpgColor32 read GetColor write SetColor;
    property PaintStyle: TpgPaintStyle read FPaintStyle write FPaintStyle;
    property Opacity: double read FOpacity write FOpacity;
    property Reference: TObject read FReference write SetReference;
    property ColorInfo: PpgColorInfo read GetColorInfo;
  end;

  // Abstract Fill class
  TpgFill = class(TpgPaint)
  private
    FFillRule: TpgFillRule;
  public
    property FillRule: TpgFillRule read FFillRule write FFillRule;
  end;

  // Abstract Stroke class
  TpgStroke = class(TpgPaint)
  private
    FWidth: double;
    FDashOffset: double;
    function GetDashCount: integer;
    function GetDashes(Index: integer): double;
    procedure SetDashes(Index: integer; const Value: double);
  protected
    FDashArray: TpgFloatList; // will be referenced by stroker
  public
    destructor Destroy; override;
    // Clears the previously defined dash array if any
    procedure ClearDashes;
    // Width of the stroke
    property Width: double read FWidth write FWidth;
    // Put values in Dashes[0]..Dashes[N-1] to get an array of dash lengths
    // to use when drawing dashed lines. If the number of dashes (DashCount) is odd,
    // the dash-array will be doubled up.
    property Dashes[Index: integer]: double read GetDashes write SetDashes;
    // The number of dashes currently in the array
    property DashCount: integer read GetDashCount;
    // DashOffset will add an additional offset to the dash array, in order to
    // start dashing from e.g. halfway down the first dash.
    property DashOffset: double read FDashOffset write FDashOffset;
  end;

  // Abstract Font class, canvas descendants create their own font type through
  // a call to NewFont
  TpgFont = class(TPersistent)
  end;

  TpgGradient = class(TPersistent)
  end;

  // Canvas state, which contains information on objects that are created, layers,
  // and so on. Call Canvas.Push to create a new state, and remove to the old
  // situation with Canvas.Pop
  TpgState = class(TPersistent)
  private
    FOwner: TpgCanvas;
    FTransformIndex: integer;
    FObjectIndex: integer;
    FClipRegion: TPersistent;
  protected
    constructor Create(AOwner: TpgCanvas); virtual;
    property TransformIndex: integer read FTransformIndex;
    property ObjectIndex: integer read FObjectIndex;
  public
    property ClipRegion: TPersistent read FClipRegion write FClipRegion;
    destructor Destroy; override;
  end;

  // List of canvas states
  TpgStateList = class(TObjectList)
  private
    function GetItems(Index: integer): TpgState;
  public
    property Items[Index: integer]: TpgState read GetItems; default;
  end;

  // Generic, abstract canvas object that is used by other objects to paint on.
  // Many of the methods here are abstract and are overridden in descendants.
  // Never instantiate the base TpgCanvas class, always instantiate one of the
  // descendant classes. For GDI drawing, use the TpgGDICanvas, for Pyro drawing
  // use the TpgPyroCanvas, and to create a scene by drawing to a canvas, use the
  // TpgSceneCanvas.
  TpgCanvas = class(TPersistent)
  private
    FObjects: TObjectList;
    FStates: TpgStateList;
    FTransforms: TpgTransformList;
    FColorInfo: TpgColorInfo;
    FDeviceInfo: TpgDeviceInfo;
    FInterpolationMethod: TpgInterpolationMethod;
    FOverSampling: integer;
    FLayers: TpgLayerList;
    FClipRule: TpgFillRule;
    function GetColorInfo: PpgColorInfo;
    function GetDeviceInfo: PpgDeviceInfo;
  protected
    property Objects: TObjectList read FObjects;
    property States: TpgStateList read FStates;
    property Transforms: TpgTransformList read FTransforms;
    function CurrentState: TpgState;
    function GetDeviceHandle: longword; virtual; abstract;
    // Create a state of the correct class
    function CreateState(AOwner: TpgCanvas): TpgState; virtual;
    function PaintAsColor32(APaint: TpgPaint): TpgColor32;
    // Get the device rectangle for the canvas
    function GetDeviceRect: TpgRect; virtual; abstract;
    // Set the device rectangle for the canvas
    procedure SetDeviceRect(const ARect: TpgRect); virtual; abstract;
    // Create layer of correct class (to be overridden by descendants if they
    // need another class than TpgLayer)
    function CreateLayer: TpgLayer; virtual;
    // Wake up this layer: make sure it's canvas is valid, and props like IsCached
    // reflect correct values
    procedure WakeLayer(ALayer: TpgLayer); virtual;
    // Cache this layer: free memory consumption when necessary
    procedure CacheLayer(ALayer: TpgLayer); virtual;
    // abstract function to blend this canvas to another canvas of the same type,
    // should be overridden in descendants.
    procedure BlendTo(ACanvas: TpgCanvas; AShiftX, AShiftY: integer; AAlpha: byte; AColorOp: TpgColorOp); virtual;
    // Make sure this canvas takes on the state of ACanvas. This means having
    // the same transformation and clipping path, and other canvas settings.
    procedure AssignState(ACanvas: TpgCanvas); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // This procedure is for fast filling of underlying device. The coordinates
    // are given in pixels
    procedure FillDeviceRect(R: TpgRect; AColor: TpgColor32); virtual; abstract;
    // Returns a reference to a new TpgPath object, which can be used by the
    // application to construct a path. The object is owned by the canvas and
    // should not be freed by the application.
    function NewPath: TpgPath; virtual; abstract;
    // Returns a reference to a new freely configurable fill object, which can
    // be used by the application to fill a path, shape etc. The object is owned
    // by the canvas and should not be freed by the application.
    function NewFill: TpgFill; virtual;
    // Returns a reference to a new freely configurable stroke object, which can
    // be used by the application to stroke a path, shape etc. The object is owned
    // by the canvas and should not be freed by the application.
    function NewStroke: TpgStroke; virtual;
    // Returns a new bitmap object which can be used to create a raster graphic.
    // In contradiction to some other NewXXXX methods, the generated bitmap object
    // is not owned by the canvas, it must be freed by the application.
    function NewBitmap: TpgBitmap; virtual;
    // Returns reference to a new font object. The object is owned by the canvas
    // and should not be freed by the application. This function call allows
    // specification of every font parameter that influences font creation.
    function NewFont(AFamily: Utf8String; AStyle: TpgFontStyle; AVariant: TpgFontVariant;
      AWeight: TpgFontWeight; AStretch: TpgFontStretch;
      ARenderMethod: TpgFontRenderMethod): TpgFont; overload; virtual; abstract;
    // Returns a reference to a new font object. The object is owned by the canvas
    // and should not be freed by the application. Specify a font family name
    // as UTF8 string. This is a shortcut call, specifying "normal" for the other
    // font parameters (font style, font variant, font weight, font stretch and
    // font render method)
    function NewFont(AFamily: Utf8String): TpgFont; overload; virtual;
    // Returns a reference to a new font object. The object is owned by the canvas
    // and should not be freed by the application. Specify a font family name
    // as UTF8 string, specify a style and a weight. This is a shortcut call,
    // specifying "normal" for the other font parameters (font variant, font
    // stretch and font render method)
    function NewFont(AFamily: Utf8String;  AStyle: TpgFontStyle; AWeight: TpgFontWeight): TpgFont; overload; virtual;
    // Create a new region (can be used for e.g. polygon clipping calculations).
    // In contradiction to some other NewXXXX methods, the generated region object
    // is not owned by the canvas, it must be freed by the application.
    function NewRegion(ARegionType: TpgRegionType): TpgRegion; virtual;
    // Paint the path APath with fill AFill and stroke AStroke. If the path doesn't
    // have a fill or stroke, then set these to nil.
    procedure PaintPath(APath: TpgPath; AFill: TpgFill; AStroke: TpgStroke); virtual; abstract;
    // Paints a line from X1,Y1 to X2,Y2 with current stroke
    procedure PaintLine(const X1, Y1, X2, Y2: double; AStroke: TpgStroke); virtual;
    // Paints a rectangle at X,Y with dimensions Width,Height and rounded corners of
    // length Rx, Ry. If Rx and Ry are 0 no rounded corners are generated.
    procedure PaintRectangle(const X, Y, Width, Height, Rx, Ry: double; AFill: TpgFill; AStroke: TpgStroke); virtual;
    // Paints an ellipse at center Cx, Cy with X-radius Rx and Y-radius Ry.
    procedure PaintEllipse(const Cx, Cy, Rx, Ry: double; AFill: TpgFill; AStroke: TpgStroke); virtual;
    // Paint ABitmap at location X, Y on the canvas with Width, Height
    procedure PaintBitmap(ABitmap: TpgColorMap; X, Y, Width, Height: double); virtual;
    // Paint the Utf8String Text at location X,Y, using Font with a fontsize of
    // FontSize. Use Fill to fill the text, and Stroke to outline the text. Text anchoring can optionally be specified with Anchor.
    procedure PaintText(const X, Y: double; const Text: Utf8String; Font: TpgFont;
      FontSize: double; Fill: TpgFill; Stroke: TpgStroke; Anchor: TpgTextAnchor = taStart); virtual; abstract;
    // Measure the Utf8String text, return it's bounding box
    function MeasureText(const X, Y: double; const Text: Utf8String; Font: TpgFont;
      FontSize: double; Anchor: TpgTextAnchor = taStart): TpgBox; virtual; abstract;
    // Use push to save the current state and all changes (like transforms) go
    // into a new state. The new state is returned as reference. Use a Pop to
    // terminate the current state and return to the previous state.
    function Push: TpgState; virtual;
    // Use pop to return to the previous state. Pass the state that was obtained
    // with Push as a reference, or nil if you're lazy and just want to pop the
    // last state. Push/Pop pairs should always match! Use try..finally..end to
    // achieve this.
    procedure Pop(AState: TpgState); virtual;
    // Create a new layer, which contains a new canvas of same class as this one
    // on which the application can draw. The layer contains a buffer and effects
    // can be applied to it. Pass ALayerGuid = cEmptyGuid to get a temporary layer, which
    // will be destroyed after the call to PopLayer. Pass ALayerID <> cEmptyGuid to get
    // a layer that is cached, and can be retrieved on next draw with the same
    // layer ID. The layer's ID is property LayerID.
    // Check if a layer is still cached by reading the IsCached property. If a
    // layer is still cached, and nothing on the layer changed, it can be directly
    // popped. Otherwise, if still cached, call Clear to clear the layer, and
    // then redraw it. A call to PushLayer must always be accompanied by a call
    // to PopPayer. PopLayer will draw the layer to the background. After the
    // PopLayer, the layer's canvas is no longer valid. The layer however, will
    // remain in existance if created with ALayerID > 0.
    function PushLayer: TpgLayer; overload;
    function PushLayer(ALayerGuid: TGuid {= cEmptyGuid}; CopyBackground: boolean = False): TpgLayer; overload;
    // Pop a previously pushed layer (see PushLayer)
    procedure PopLayer(ALayer: TpgLayer);
    // Add (concat) a transform to the current transform list. The transform
    // passed in ATransform will be owned and freed by the canvas on next Pop,
    // Unless IsPersistent is specified as True (in this case, the transform is
    // just used by the canvas and must be freed by the caller).
    procedure AddTransform(ATransform: TpgTransform; IsPersistent: boolean = False); virtual;
    // Translate the canvas over X,Y
    procedure Translate(const X, Y: double); virtual;
    // Rotate the canvas over Angle degrees, around point Cx, Cy
    procedure Rotate(const Angle, Cx, Cy: double); virtual;
    // Scale the canvas by Sx, Sy
    procedure Scale(const Sx, Sy: double); virtual;
    // returns the number of units covering one pixel (in given direction).
    function PixelScale(ADirection: TpgCartesianDirection = cdUnknown): double; virtual;
    // Returns true if the current transformation list sums up to a linear transformation
    function IsLinear: boolean; virtual;
    // Determine if the rectangle is visible with current clipping region
    function IsRectangleVisible(ARect: TpgBox): boolean; virtual; abstract;
    // Clip the current clipping region with APath
    procedure ClipPath(APath: TpgPath); virtual; abstract;
    // Clip the current clipping region with the rectangle given
    procedure ClipRectangle(const X, Y, Width, Height, Rx, Ry: double); virtual;
    // Clip the current clipping region with the ellipse given
    procedure ClipEllipse(const Cx, Cy, Rx, Ry: double); virtual;
    // Device (clipping) rectangle in integer coordinates. In descendant canvases,
    // this is the rectangle in device coordinates which is bitmapped and can be
    // drawn on
    property DeviceRect: TpgRect read GetDeviceRect write SetDeviceRect;
    // Some canvas descendants have a device handle which can be used by the
    // application to copy etc.
    property DeviceHandle: longword read GetDeviceHandle;
    // Definition of the color space that the application uses. The application
    // can set this to another value if required. The default is RGBA 32bits,
    // original (non-premultiplied) values.
    property ColorInfo: PpgColorInfo read GetColorInfo;
    // Information about the device, like resolution. It is used by the renderer
    // to convert length units to pixels
    property DeviceInfo: PpgDeviceInfo read GetDeviceInfo;
    // Interpolation method used when sampling images
    property InterpolationMethod: TpgInterpolationMethod read FInterpolationMethod write FInterpolationMethod;
    // Oversampling used when sampling images. Default = 1.
    property OverSampling: integer read FOverSampling write FOverSampling;
    // Fill-rule used when rendering clipping paths
    property ClipRule: TpgFillRule read FClipRule write FClipRule;
  end;

  TpgCanvasClass = class of TpgCanvas;

  // Raster effect that can be applied to a layer
  TpgRasterEffect = class(TPersistent)
  private
    FOwner: TpgLayer;
  public
    constructor Create(AOwner: TpgLayer); virtual;
  end;

  // List of raster effects
  TpgRasterEffectList = class(TObjectList)
  private
    function GetItems(Index: integer): TpgRasterEffect;
  public
    property Items[Index: integer]: TpgRasterEffect read GetItems; default;
  end;

  // Abstract canvas layer class
  TpgLayer = class(TPersistent)
  private
    FEffects: TpgRasterEffectList;
    FLayerGuid: TGuid;
    FIsCached: boolean;
    FState: TpgState;
    FCopyBackground: boolean;
    FOpacity: double;
  protected
    FOwner: TpgCanvas;
    FCanvas: TpgCanvas;
    FOwnsCanvas: boolean;
    constructor Create(AOwner: TpgCanvas); virtual;
    procedure Paint; virtual;
    function IsActive: boolean;
  public
    destructor Destroy; override;
    property Effects: TpgRasterEffectList read FEffects;
    property LayerGuid: TGuid read FLayerGuid;
    property Canvas: TpgCanvas read FCanvas;
    property IsCached: boolean read FIsCached;
    property Opacity: double read FOpacity write FOpacity;
  end;

  //  List of canvas layers
  // todo: TUniqueIDList replaced by TGuidList in sdSortedLists.pas
  TpgLayerList = class(TGuidList)
  private
    function GetItems(Index: integer): TpgLayer;
  protected
    function GetGuid(AItem: TObject): TGuid; override;
    //function GetID(AItem: TObject): integer; override;
  public
    function ByGuid(AGuid: TGuid): TpgLayer;
    property Items[Index: integer]: TpgLayer read GetItems; default;
  end;

// Register a canvas class for use with a pyro control. It must be a descendant
// of TpgCanvas.
procedure RegisterCanvasClass(ACanvasType: TpgCanvasType; ACanvasClass: TpgCanvasClass);

// Find a canvas class based on its canvas type enum
function CanvasClassByType(ACanvasType: TpgCanvasType): TpgCanvasClass;

implementation

type
  TpgCanvasClassItem = class
  private
    FCanvasClass: TpgCanvasClass;
    FCanvasType: TpgCanvasType;
  public
    property CanvasType: TpgCanvasType read FCanvasType;
    property CanvasClass: TpgCanvasClass read FCanvasClass;
  end;

var
  glCanvasClassList: TObjectList = nil;

procedure RegisterCanvasClass(ACanvasType: TpgCanvasType; ACanvasClass: TpgCanvasClass);
var
  i: integer;
  Item: TpgCanvasClassItem;
begin
  // find if it exists
  for i := 0 to glCanvasClassList.Count - 1 do
    if TpgCanvasClassItem(glCanvasClassList[i]).CanvasType = ACanvasType then
    begin
      TpgCanvasClassItem(glCanvasClassList[i]).FCanvasClass := ACanvasClass;
      exit;
    end;
  // if not, add new item
  Item := TpgCanvasClassItem.Create;
  Item.FCanvasType := ACanvasType;
  Item.FCanvasClass := ACanvasClass;
  glCanvasClassList.Add(Item);
end;

function CanvasClassByType(ACanvasType: TpgCanvasType): TpgCanvasClass;
var
  i: integer;
begin
  for i := 0 to glCanvasClassList.Count - 1 do
    if TpgCanvasClassItem(glCanvasClassList[i]).CanvasType = ACanvasType then
    begin
      Result := TpgCanvasClassItem(glCanvasClassList[i]).CanvasClass;
      exit;
    end;
  Result := nil;
end;

{ TpgFloatList }

procedure TpgFloatList.Add(AValue: double);
var
  ItemCount: integer;
begin
  ItemCount := length(FItems);
  SetLength(FItems, ItemCount + 1);
  FItems[ItemCount] := AValue;
end;

function TpgFloatList.GetCount: integer;
begin
  Result := length(FItems);
end;

function TpgFloatList.GetItems(Index: integer): double;
begin
  Result := FItems[Index];
end;

procedure TpgFloatList.SetItems(Index: integer; const Value: double);
begin
  FItems[Index] := Value;
end;

{ TpgPaint }

constructor TpgPaint.Create(AOwner: TpgCanvas);
begin
  inherited Create;
  FOwner := AOwner;
  FOpacity := 1.0;
end;

function TpgPaint.GetColor: TpgColor32;
begin
  Result := pgColorTo4Ch8b(GetColorInfo^, cARGB_8b_Org, @FColor);
end;

function TpgPaint.GetColorInfo: PpgColorInfo;
begin
  Result := FOwner.GetColorInfo;
end;

procedure TpgPaint.SetColor(const Value: TpgColor32);
begin
  FColor := pgConvertColor(cARGB_8b_Org, GetColorInfo^, @Value);
  FPaintStyle := psColor;
  FReference := nil;
end;

procedure TpgPaint.SetColorWithInfo(const AColor: TpgColor; AInfo: PpgColorInfo);
begin
  FColor := pgConvertColor(AInfo^, GetColorInfo^, @AColor);
  FPaintStyle := psColor;
end;

procedure TpgPaint.SetReference(const Value: TObject);
begin
  FReference := Value;
  if FReference is TpgBitmap then
    FPaintStyle := psBitmap
  else if FReference is TpgGradient then
    FPaintStyle := psGradient
  else if assigned(FReference) then
    FPaintStyle := psUnknown
  else
    FPaintStyle := psNone;
end;

{ TpgStroke }

procedure TpgStroke.ClearDashes;
begin
  FreeAndNil(FDashArray);
end;

destructor TpgStroke.Destroy;
begin
  FreeAndNil(FDashArray);
  inherited;
end;

function TpgStroke.GetDashCount: integer;
begin
  if assigned(FDashArray) then
    Result := FDashArray.Count
  else
    Result := 0;
end;

function TpgStroke.GetDashes(Index: integer): double;
begin
  if (Index >= 0) and (Index < GetDashCount) then
    Result := FDashArray[Index]
  else
    Result := 0;
end;

procedure TpgStroke.SetDashes(Index: integer; const Value: double);
begin
  if Index < 0 then exit;
  if not assigned(FDashArray) then
    FDashArray := TpgFloatList.Create;
  while FDashArray.Count <= Index do FDashArray.Add(0);
  FDashArray[Index] := Value;
end;

{ TpgState }

constructor TpgState.Create(AOwner: TpgCanvas);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TpgState.Destroy;
var
  PrevState: TpgState;
begin
  // Check pop
  if FOwner.Currentstate <> Self then
    raise Exception.Create(sNonMatchingPop);

  // remove transforms from last state
  while FTransformIndex < FOwner.FTransforms.Count do
    FOwner.FTransforms.Delete(FOwner.FTransforms.Count - 1);

  // remove objects from last state
  while FObjectIndex < FOwner.FObjects.Count do
    FOwner.FObjects.Delete(FOwner.FObjects.Count - 1);

  // Remove clipregion
  PrevState := FOwner.FStates[FOwner.FStates.Count - 2];
  if not assigned(PrevState) or (PrevState.FClipRegion <> FClipRegion) then
    FreeAndNil(FClipRegion);

  // Remove from owner state list
  FOwner.FStates.Delete(FOwner.FStates.Count - 1);
  inherited;
end;

{ TpgStateList }

function TpgStateList.GetItems(Index: integer): TpgState;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

{ TpgCanvas }

procedure TpgCanvas.AddTransform(ATransform: TpgTransform; IsPersistent: boolean);
begin
  FTransforms.Concat(ATransform);
  if not IsPersistent then
    FObjects.Add(ATransform);
end;

procedure TpgCanvas.AssignState(ACanvas: TpgCanvas);
begin
  // By default, take over the transforms list. The descendant canvases should
  // also copy the clipping path, and perhaps other non-default settings
  FTransforms.Assign(ACanvas.FTransforms);
  FClipRule := ACanvas.FClipRule;
  FColorInfo := ACanvas.FColorInfo;
  FDeviceInfo := ACanvas.FDeviceInfo;
  FInterpolationMethod := ACanvas.FInterpolationMethod;
  FOverSampling := ACanvas.FOverSampling;
end;

procedure TpgCanvas.BlendTo(ACanvas: TpgCanvas; AShiftX, AShiftY: integer; AAlpha: byte; AColorOp: TpgColorOp);
begin
// default does nothing
end;

procedure TpgCanvas.CacheLayer(ALayer: TpgLayer);
begin
  // By default, we will simply delete the layers canvas
  if ALayer.FOwnsCanvas then
    FreeAndNil(ALayer.FCanvas);
  ALayer.FIsCached := False;
//  ALayer.FIsCached := True;
end;

procedure TpgCanvas.ClipEllipse(const Cx, Cy, Rx, Ry: double);
var
  Path: TpgPath;
begin
  Path := NewPath;
  Path.Ellipse(Cx, Cy, Rx, Ry);
  ClipPath(Path);
  Objects.Remove(Path);
end;

procedure TpgCanvas.ClipRectangle(const X, Y, Width, Height, Rx, Ry: double);
var
  Path: TpgPath;
begin
  Path := NewPath;
  Path.Rectangle(X, Y, Width, Height, Rx, Ry);
  ClipPath(Path);
  Objects.Remove(Path);
end;

constructor TpgCanvas.Create;
begin
  inherited Create;
  FObjects := TObjectList.Create(True);
  FTransforms := TpgTransformList.Create;
  FStates := TpgStateList.Create(False);
  FLayers := TpgLayerList.Create(True);
  FColorInfo := cARGB_8b_Org;
  FOverSampling := 1;
  FInterpolationMethod := imNearest;
  // Do one default push
  FStates.Add(TpgState.Create(Self));
end;

function TpgCanvas.CreateLayer: TpgLayer;
begin
  Result := TpgLayer.Create(Self);
end;

function TpgCanvas.CreateState(AOwner: TpgCanvas): TpgState;
begin
  Result := TpgState.Create(AOwner);
end;

function TpgCanvas.CurrentState: TpgState;
begin
  if FStates.Count = 0 then
    raise Exception.Create(sNonMatchingPop);
  Result := FStates[FStates.Count - 1];
end;

destructor TpgCanvas.Destroy;
var
  i: integer;
begin
  for i := FStates.Count - 1 downto 0 do
    FStates[i].Free;
  FreeAndNil(FObjects);
  FreeAndNil(FTransforms);
  FreeAndNil(FStates);
  FreeAndNil(FLayers);
  inherited;
end;

function TpgCanvas.GetColorInfo: PpgColorInfo;
begin
  Result := @FColorInfo;
end;

function TpgCanvas.GetDeviceInfo: PpgDeviceInfo;
begin
  Result := @FDeviceInfo;
end;

function TpgCanvas.IsLinear: boolean;
begin
  Result := FTransforms.IsLinear;
end;

function TpgCanvas.NewBitmap: TpgBitmap;
begin
  Result := TpgBitmap.Create;
end;

function TpgCanvas.NewFill: TpgFill;
begin
  Result := TpgFill.Create(Self);
  FObjects.Add(Result);
end;

function TpgCanvas.NewFont(AFamily: Utf8String): TpgFont;
var
  RM: TpgFontRenderMethod;
begin
  RM := frOutline;
  if not IsLinear then
    RM := frOutlineBreakup;
  Result := NewFont(AFamily, fsNormal, fvNormal, fwNormal, fsNoStretch, RM);
end;

function TpgCanvas.NewFont(AFamily: Utf8String; AStyle: TpgFontStyle;
  AWeight: TpgFontWeight): TpgFont;
var
  RM: TpgFontRenderMethod;
begin
  RM := frOutline;
  if not IsLinear then
    RM := frOutlineBreakup;
  Result := NewFont(AFamily, AStyle, fvNormal, AWeight, fsNoStretch, RM);
end;

function TpgCanvas.NewRegion(ARegionType: TpgRegionType): TpgRegion;
begin
  case ARegionType of
  rtEmpty      : Result := TpgRegion.Create;
  rtRectangle  : Result := TpgRectangleRegion.Create;
  rtPolygon    : Result := TpgPolygonRegion.Create;
  rtPolyPolygon: Result := TpgPolyPolygonRegion.Create;
  rtPath       : Result := TpgPathRegion.Create;
  rtBitmap     : Result := TpgBitmapRegion.Create;
  else
    Result := nil;
  end;
end;

function TpgCanvas.NewStroke: TpgStroke;
begin
  Result := TpgStroke.Create(Self);
  FObjects.Add(Result);
end;

function TpgCanvas.PaintAsColor32(APaint: TpgPaint): TpgColor32;
begin
  Result := APaint.Color;
  if APaint.Opacity < 1.0 then
    TpgColorARGB(Result).A := round(TpgColorARGB(Result).A * APaint.Opacity);
  Result := pgColorTo4Ch8b(cARGB_8b_Org, ColorInfo^, @Result);
end;

procedure TpgCanvas.PaintBitmap(ABitmap: TpgColorMap; X, Y, Width, Height: double);
var
  Path: TpgPath;
  Fill: TpgFill;
begin
  // this method must be overridden in descendant canvases. Default just paints
  // a black rectangle
  Fill := NewFill;
  Fill.Color := clBlack32;
  Path := NewPath;
  Path.Rectangle(X, Y, Width, Height, 0, 0);
  PaintPath(Path, Fill, nil);
  Objects.Remove(Path);
  Objects.Remove(Fill);
end;

procedure TpgCanvas.PaintEllipse(const Cx, Cy, Rx, Ry: double;
  AFill: TpgFill; AStroke: TpgStroke);
var
  Path: TpgPath;
begin
  Path := NewPath;
  Path.Ellipse(Cx, Cy, Rx, Ry);
  PaintPath(Path, AFill, AStroke);
  Objects.Remove(Path);
end;

procedure TpgCanvas.PaintLine(const X1, Y1, X2, Y2: double; AStroke: TpgStroke);
var
  Path: TpgPath;
begin
  Path := NewPath;
  Path.MoveTo(X1, Y1);
  Path.LineTo(X2, Y2);
  PaintPath(Path, nil, AStroke);
  Objects.Remove(Path);
end;

procedure TpgCanvas.PaintRectangle(const X, Y, Width, Height, Rx, Ry: double;
  AFill: TpgFill; AStroke: TpgStroke);
var
  Path: TpgPath;
begin
  Path := NewPath;
  Path.Rectangle(X, Y, Width, Height, Rx, Ry);
  PaintPath(Path, AFill, AStroke);
  Objects.Remove(Path);
end;

function TpgCanvas.PixelScale(ADirection: TpgCartesianDirection): double;
begin
  Result := FTransforms.GetPixelScale(ADirection);
end;

procedure TpgCanvas.Pop(AState: TpgState);
begin
  if assigned(AState) then
    // Pop all states until AState
    while (FStates.Count > 1) and (AState <> FStates[FStates.Count - 1]) do
      FStates[FStates.Count - 1].Free;
  if FStates.Count < 1 then
    raise Exception.Create(sNonMatchingPop);
  FStates[FStates.Count - 1].Free;
end;

procedure TpgCanvas.PopLayer(ALayer: TpgLayer);
begin
  if not assigned(ALayer) then
    exit;
  // Paint the layer
  ALayer.Paint;
  // Pop it..
  Pop(ALayer.FState);
  // Temporary layer?
  if IsEmptyGuid(ALayer.LayerGuid) then
    ALayer.Free
  else
  begin
    ALayer.FState := nil;
    CacheLayer(ALayer);
  end;
end;

function TpgCanvas.Push: TpgState;
begin
  Result := CreateState(Self);
  Result.FTransformIndex := FTransforms.Count;
  Result.FObjectIndex := FObjects.Count;
  // States copy reference to their clip region from previous state
  if FStates.Count > 0 then
    Result.FClipRegion := FStates[FStates.Count - 1].FClipRegion;
  FStates.Add(Result);
end;

function TpgCanvas.PushLayer: TpgLayer;
//var
//  S: TpgState;
begin
  Result := PushLayer(cEmptyGuid);
end;

function TpgCanvas.PushLayer(ALayerGuid: TGuid; CopyBackground: boolean): TpgLayer;
var
  S: TpgState;
begin
  S := Push;
  if IsEmptyGuid(ALayerGuid) then
    Result := nil
  else
    Result := FLayers.ByGuid(ALayerGuid);
  if not assigned(Result) then
  begin
    Result := CreateLayer;
    Result.FLayerGuid := ALayerGuid;
    if not IsEmptyGuid(ALayerGuid) then
      FLayers.Add(Result);
  end;
  Result.FState := S;
  Result.FCopyBackground := CopyBackground;
  // Wake up layer
  WakeLayer(Result);
end;

procedure TpgCanvas.Rotate(const Angle, Cx, Cy: double);
var
  T: TpgAffineTransform;
begin
  T := TpgAffineTransform.Create;
  T.Rotate(Angle, Cx, Cy);
  AddTransform(T);
end;

procedure TpgCanvas.Scale(const Sx, Sy: double);
var
  T: TpgAffineTransform;
begin
  T := TpgAffineTransform.Create;
  T.Scale(Sx, Sy);
  AddTransform(T);
end;

procedure TpgCanvas.Translate(const X, Y: double);
var
  T: TpgAffineTransform;
begin
  T := TpgAffineTransform.Create;
  T.Translate(X, Y);
  AddTransform(T);
end;

procedure TpgCanvas.WakeLayer(ALayer: TpgLayer);
begin
  if not ALayer.IsCached then
  begin
    // Create a new canvas of the same class
    ALayer.FCanvas := TpgCanvasClass(Self.ClassType).Create;
    ALayer.FOwnsCanvas := True;
    // Make sure the new canvas has the same state
    ALayer.FCanvas.AssignState(Self);
  end;
  // Set to the same device rect
  ALayer.FCanvas.DeviceRect := DeviceRect;
end;

{ TpgLayerList }

function TpgLayerList.ByGuid(AGuid: TGuid): TpgLayer;
var
  Index: integer;
begin
  if IndexByGuid(AGuid, Index) then
    Result := Items[Index]
  else
    Result := nil;
end;

function TpgLayerList.GetGuid(AItem: TObject): TGuid;
begin
  Result := TpgLayer(AItem).LayerGuid;
end;

function TpgLayerList.GetItems(Index: integer): TpgLayer;
begin
  Result := Get(Index);
end;

{ TpgRasterEffect }

constructor TpgRasterEffect.Create(AOwner: TpgLayer);
begin
  inherited Create;
  FOwner := AOwner;
end;

{ TpgRasterEffectList }

function TpgRasterEffectList.GetItems(Index: integer): TpgRasterEffect;
begin
  Result := Get(Index);
end;

{ TpgLayer }

constructor TpgLayer.Create(AOwner: TpgCanvas);
begin
  inherited Create;
  FOwner := AOwner;
  FEffects := TpgRasterEffectList.Create(True);
  FOpacity := 1.0;
end;

destructor TpgLayer.Destroy;
begin
  if FOwnsCanvas then
    FreeAndNil(FCanvas);
  FreeAndNil(FEffects);
  inherited;
end;

function TpgLayer.IsActive: boolean;
begin
  Result := assigned(FState);
end;

procedure TpgLayer.Paint;
begin
  if not assigned(FCanvas) then
     exit;

  FCanvas.BlendTo(FOwner, 0, 0, pgLimit(round(FOpacity * $FF), $00, $FF), coOver);
end;

initialization

  glCanvasClassList := TObjectList.Create;

finalization

  FreeAndNil(glCanvasClassList);

end.

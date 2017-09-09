
unit pgScene;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, Contnrs, NativeXml, sdDebug,
  pgColor, pgTransform, pgSampler, pgDocument, pgPath, pgGeometry, pgUriReference,
  pgBitmap, pgRaster, Pyro;

type

  TpgLengthProp = class(TpgProp)
  private
    FFloatValue: double;
    FUnits: TpgLengthUnits;
    procedure SetFloatValue(const Value: double);
    procedure SetUnits(const Value: TpgLengthUnits);
  protected
    class function GetDirection: TpgCartesianDirection; virtual;
    function Decode: boolean; override;
    function Encode: boolean; override;
    procedure CopyFrom(ANode: TObject); override;
  public
    property FloatValue: double read FFloatValue write SetFloatValue; 
    property Units: TpgLengthUnits read FUnits write SetUnits;
    property Direction: TpgCartesianDirection read GetDirection;
    // Convert the value + units combination to device units, depending on
    // settings in the device (DPI).
    function ToDevice(const AInfo: TpgDeviceInfo): double;
  end;

  TpgHLengthProp = class(TpgLengthProp)
  protected
    class function GetDirection: TpgCartesianDirection; override;
  end;

  TpgVLengthProp = class(TpgLengthProp)
  protected
    class function GetDirection: TpgCartesianDirection; override;
  end;

  TpgFloatListProp = class;

  TpgFloatItem = class
  private
    FOwner: TpgFloatListProp;
    FValue: double;
    procedure SetValue(const Value: double);
  public
    constructor Create(AOwner: TpgFloatListProp);
    property Value: double read FValue write SetValue;
  end;

  TpgFloatProtectList = class(TObjectList)
  private
    FOwner: TpgFloatListProp;
    function GetItems(Index: integer): TpgFloatItem;
  protected
    procedure AddInternal(Value: double);
    procedure CopyFrom(AList: TpgFLoatProtectList);
  public
    constructor Create(AOwner: TpgFloatListProp);
    property Items[Index: integer]: TpgFloatItem read GetItems; default;
    procedure Add(AItem: TpgFloatItem);
  end;

  TpgFloatListProp = class(TpgProp)
  private
    FValues: TpgFloatProtectList;
    procedure SetValues(const Value: TpgFloatProtectList);
  protected
    function Decode: boolean; override;
    function Encode: boolean; override;
    procedure CopyFrom(ANode: TObject); override;
  public
    constructor Create(AOwner: TNativeXml); override;
    destructor Destroy; override;
    property Values: TpgFloatProtectList read FValues write SetValues;
    procedure Add(Value: double);
  end;

  TpgLengthListProp = class;

  TpgLengthItem = class(TsdDebugPersistent)
  private
    FOwner: TpgLengthListProp;
    FValue: double;
    FUnits: TpgLengthUnits;
    procedure SetUnits(const Value: TpgLengthUnits);
    procedure SetValue(const Value: double);
  public
    constructor Create(AOwner: TpgLengthListProp);
    property Units: TpgLengthUnits read FUnits write SetUnits;
    property Value: double read FValue write SetValue;
    function ToDevice(const AInfo: TpgDeviceInfo): double;
  end;

  TpgLengthProtectList = class(TObjectList)
  private
    FOwner: TpgLengthListProp;
    function GetItems(Index: integer): TpgLengthItem;
  protected
    procedure AddInternal(Value: double; Units: TpgLengthUnits);
    procedure CopyFrom(AList: TpgLengthProtectList);
  public
    constructor Create(AOwner: TpgLengthListProp);
    property Items[Index: integer]: TpgLengthItem read GetItems; default;
    procedure Add(AItem: TpgLengthItem);
  end;

  TpgLengthListProp = class(TpgProp)
  private
    FValues: TpgLengthProtectList;
    procedure SetValues(const Value: TpgLengthProtectList);
  protected
    class function GetDirection: TpgCartesianDirection; virtual;
    function Decode: boolean; override;
    function Encode: boolean; override;
    procedure CopyFrom(ANode: TObject); override;
  public
    constructor Create(AOwner: TNativeXml); override;
    destructor Destroy; override;
    property Direction: TpgCartesianDirection read GetDirection;
    property Values: TpgLengthProtectList read FValues write SetValues;
    procedure Add(Value: double; Units: TpgLengthUnits);
  end;

  TpgHLengthListProp = class(TpgLengthListProp)
  protected
    class function GetDirection: TpgCartesianDirection; override;
  end;

  TpgVLengthListProp = class(TpgLengthListProp)
  protected
    class function GetDirection: TpgCartesianDirection; override;
  end;

  TpgSizeable = class(TpgStyleable)
  protected
    procedure GetViewPortSize(var Width, Height: double; const AInfo: TpgDeviceInfo);
    function GetFontHeight(const AInfo: TpgDeviceInfo): double;
    function ResolveLength(const AValue: double; AUnits: TpgLengthUnits;
      ADirection: TpgCartesianDirection; const AInfo: TpgDeviceInfo): double;
  public
  end;

  TpgFillRuleProp = class(TpgIntProp)
  private
    function GetIntValue: TpgFillRule;
    procedure SetIntValue(const Value: TpgFillRule);
  public
    property IntValue: TpgFillRule read GetIntValue write SetIntValue;
  end;

  // Property specifying paint, which can be none, a solid color, or a reference
  // to a paint server (like gradient or pattern).
  TpgPaintProp = class(TpgRefProp)
  private
    FColor: TpgColor;
    FPaintStyle: TpgPaintStyle;
    function GetAsColor32: TpgColor32;
    procedure SetAsColor32(const Value: TpgColor32);
    procedure SetPaintStyle(const Value: TpgPaintStyle);
  protected
    function GetColorInfo: PpgColorInfo;
    function Decode: boolean; override;
    function Encode: boolean; override;
    procedure CopyFrom(ANode: TObject); override;
  public
    // Color stores the color in general format, with the current colorspace
    // on use in the parent paintable.
    property Color: TpgColor read FColor;
    // Selected paint style (ptNone, ptColor, ptReference)
    property PaintStyle: TpgPaintStyle read FPaintStyle write SetPaintStyle;
    // Get and set the color as an ARGB 4Channel 8bpc non-premultiplied color
    property AsColor32: TpgColor32 read GetAsColor32 write SetAsColor32;
    property ColorInfo: PpgColorInfo read GetColorInfo;
  end;

  TpgPaintable = class(TpgSizeable)
  private
    function GetFill: TpgPaintProp;
    function GetStroke: TpgPaintProp;
    function GetStrokeWidth: TpgLengthProp;
    function GetFillRule: TpgFillRuleProp;
    function GetFontSize: TpgVLengthProp;
    function GetFillOpacity: TpgFloatProp;
    function GetFontFamily: TpgStringProp;
    function GetLetterSpacing: TpgHLengthProp;
    function GetOpacity: TpgFloatProp;
    function GetStrokeDashArray: TpgLengthListProp;
    function GetStrokeDashOffset: TpgLengthProp;
    function GetStrokeMiterLimit: TpgFloatProp;
    function GetStrokeOpacity: TpgFloatProp;
    function GetWordSpacing: TpgHLengthProp;
  protected
    function GetColorInfo: PpgColorInfo; virtual;
  public
    // Play the fill path into the TpgPath object APath
    // note: pgSelector needs this public scope, must test
    procedure PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo); virtual;

    property Fill: TpgPaintProp read GetFill;
    property Stroke: TpgPaintProp read GetStroke;
    property StrokeWidth: TpgLengthProp read GetStrokeWidth;
    property FillRule: TpgFillRuleProp read GetFillRule;
    property FontSize: TpgVLengthProp read GetFontSize;

    property Opacity: TpgFloatProp read GetOpacity;
    property FillOpacity: TpgFloatProp read GetFillOpacity;
    property FontFamily: TpgStringProp read GetFontFamily;
//    property FontStretch: TpgFontStretchProp read GetFontStretch;
//    property FontStyle: TpgFontStyleProp read GetFontStyle;
//    property FontWeight: TpgFontWeightProp read GetFontWeight;
    property LetterSpacing: TpgHLengthProp read GetLetterSpacing;
    property WordSpacing: TpgHLengthProp read GetWordSpacing;
    property StrokeOpacity: TpgFloatProp read GetStrokeOpacity;
//    property StrokeLineCap: TpgLineCapProp read GetStrokeLineCap;
//    property StrokeLineJoin: TpgLineJoinProp read GetStrokeLineJoin;
    property StrokeMiterLimit: TpgFloatProp read GetStrokeMiterLimit;
    property StrokeDashArray: TpgLengthListProp read GetStrokeDashArray;
    property StrokeDashOffset: TpgLengthProp read GetStrokeDashOffset;
//    property TextAnchor: TpgTextAnchorProp read GetTextAnchor;

  end;

  TpgEditorOptionsProp = class(TpgIntProp)
  private
    function GetIntValue: TpgEditorOptions;
    procedure SetIntValue(const Value: TpgEditorOptions);
  public
    property IntValue: TpgEditorOptions read GetIntValue write SetIntValue;
  end;

  TpgTransformProp = class(TpgProp)
  private
    FTransformValue: TpgTransform;
    procedure SetTransformValue(const Value: TpgTransform);
  protected
    function Decode: boolean; override;
    function Encode: boolean; override;
  public
    procedure CopyFrom(ANode: TObject); override;
    destructor Destroy; override;
    property TransformValue: TpgTransform read FTransformValue write SetTransformValue;
  end;

  TpgGraphic = class(TpgPaintable)
  private
    function GetTransform: TpgTransformProp;
    function GetEditorOptions: TpgEditorOptionsProp;
  protected
  public
    property Transform: TpgTransformProp read GetTransform;
    property EditorOptions: TpgEditorOptionsProp read GetEditorOptions;
  end;

  // Group element class. TpgGroup has [efAllowElements] set, so this element can
  // hold a group of subelements.
  TpgGroup = class(TpgGraphic)
  public
    constructor Create(AOwner: TNativeXml); override;
  end;

  TpgViewBoxProp = class(TpgProp)
  private
    FMinX: double;
    FMinY: double;
    FWidth: double;
    FHeight: double;
    procedure SetHeight(const Value: double);
    procedure SetMinX(const Value: double);
    procedure SetMinY(const Value: double);
    procedure SetWidth(const Value: double);
  protected
    function Decode: boolean; override;
    function Encode: boolean; override;
  public
    property MinX: double read FMinX write SetMinX;
    property MinY: double read FMinY write SetMinY;
    property Width: double read FWidth write SetWidth;
    property Height: double read FHeight write SetHeight;
  end;

  TpgPreserveAspectProp = class(TpgIntProp)
  private
    function GetIntValue: TpgPreserveAspect;
    procedure SetIntValue(const Value: TpgPreserveAspect);
  public
    property IntValue: TpgPreserveAspect read GetIntValue write SetIntValue;
  end;

  TpgMeetOrSliceProp = class(TpgIntProp)
  private
    function GetIntValue: TpgMeetOrSlice;
    procedure SetIntValue(const Value: TpgMeetOrSlice);
  published
    property IntValue: TpgMeetOrSlice read GetIntValue write SetIntValue;
  end;

  TpgBaseViewPort = class(TpgGroup)
  private
    function GetViewBox: TpgViewBoxProp;
    function GetMeetOrSlice: TpgMeetOrSliceProp;
    function GetPreserveAspect: TpgPreserveAspectProp;
  protected
    procedure GetViewBoxProps(var AMinX, AMinY, AWidth, AHeight: double); virtual;
  public
    property PreserveAspect: TpgPreserveAspectProp read GetPreserveAspect;
    property MeetOrSlice: TpgMeetOrSliceProp read GetMeetOrSlice;
    property ViewBox: TpgViewBoxProp read GetViewBox;
  end;

  TpgViewPort = class(TpgBaseViewPort)
  private
    function GetHeight: TpgVLengthProp;
    function GetWidth: TpgHLengthProp;
    function GetX: TpgHLengthProp;
    function GetY: TpgVLengthProp;
  public
    function BuildViewBoxTransform(const AInfo: TpgDeviceInfo): TpgTransform; virtual;
    procedure PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo); override;
    property X: TpgHLengthProp read GetX;
    property Y: TpgVLengthProp read GetY;
    property Width: TpgHLengthProp read GetWidth;
    property Height: TpgVLengthProp read GetHeight;
  end;

  TpgProjectiveViewPort = class(TpgViewPort)
  private
    FLocalTransform: TpgProjectiveTransform;
    function GetPoints: TpgFloatListProp;
  protected
    function GetLocalTransform(const AInfo: TpgDeviceInfo): TpgTransform;
  public
    property Points: TpgFloatListProp read GetPoints;
  end;

  TpgShape = class(TpgGraphic)
  public
  end;

  TpgRectangle = class(TpgShape)
  private
    function GetHeight: TpgVLengthProp;
    function GetRx: TpgHLengthProp;
    function GetRy: TpgVLengthProp;
    function GetWidth: TpgHLengthProp;
    function GetX: TpgHLengthProp;
    function GetY: TpgVLengthProp;
  protected
  public
    procedure PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo); override;
  published
    property X: TpgHLengthProp read GetX;
    property Y: TpgVLengthProp read GetY;
    property Width: TpgHLengthProp read GetWidth;
    property Height: TpgVLengthProp read GetHeight;
    property Rx: TpgHLengthProp read GetRx;
    property Ry: TpgVLengthProp read GetRy;
  end;

  TpgCircle = class(TpgShape)
  private
    function GetCx: TpgHLengthProp;
    function GetCy: TpgVLengthProp;
    function GetR: TpgLengthProp;
  protected
  public
    procedure PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo); override;
  published
    property Cx: TpgHLengthProp read GetCx;
    property Cy: TpgVLengthProp read GetCy;
    property R: TpgLengthProp read GetR;
  end;

  TpgEllipse = class(TpgShape)
  private
    function GetCx: TpgHLengthProp;
    function GetCy: TpgVLengthProp;
    function GetRx: TpgHLengthProp;
    function GetRy: TpgVLengthProp;
  protected
  public
    procedure PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo); override;
  published
    property Cx: TpgHLengthProp read GetCx;
    property Cy: TpgVLengthProp read GetCy;
    property Rx: TpgHLengthProp read GetRx;
    property Ry: TpgVLengthProp read GetRy;
  end;

  TpgLine = class(TpgShape)
  private
    function GetX1: TpgHLengthProp;
    function GetX2: TpgHLengthProp;
    function GetY1: TpgVLengthProp;
    function GetY2: TpgVLengthProp;
  protected
  public
    procedure PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo); override;
  published
    property X1: TpgHLengthProp read GetX1;
    property Y1: TpgVLengthProp read GetY1;
    property X2: TpgHLengthProp read GetX2;
    property Y2: TpgVLengthProp read GetY2;
  end;

  TpgPolyLineShape = class(TpgShape)
  private
    function GetPoints: TpgFloatListProp;
  protected
  public
    procedure PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo); override;
  published
    property Points: TpgFloatListProp read GetPoints;
  end;

  TpgPolygonShape = class(TpgPolyLineShape)
  public
    procedure PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo); override;
  end;

  // TpgCommandPath is used for path processing in pgScene
  TpgCommandPath = class(TPersistent)
  private
    FValues: array of double;
    FValueCount: integer;
    FCommands: array of TpgCommandPathItemRec;
    FCommandCount: integer;
  protected
    procedure AddCommand(ACommand: TpgPathCommandStyle);
    procedure AddValues(ACount: integer; AValues: array of double);
    function GetValueCount: integer;
    function GetCommandCount: integer;
  public
    procedure Clear;
    procedure ClosePath;
    procedure MoveToAbs(X, Y: double);
    procedure MoveToRel(X, Y: double);
    procedure LineToAbs(X, Y: double);
    procedure LineToRel(X, Y: double);
    procedure LineToHorAbs(X: double);
    procedure LineToHorRel(X: double);
    procedure LineToVerAbs(Y: double);
    procedure LineToVerRel(Y: double);
    procedure CurveToCubicAbs(C1x, C1y, C2x, C2y, X, Y: double);
    procedure CurveToCubicRel(C1x, C1y, C2x, C2y, X, Y: double);
    procedure CurveToCubicSmoothAbs(C2x, C2y, X, Y: double);
    procedure CurveToCubicSmoothRel(C2x, C2y, X, Y: double);
    procedure CurveToQuadraticAbs(Cx, Cy, X, Y: double);
    procedure CurveToQuadraticRel(Cx, Cy, X, Y: double);
    procedure CurveToQuadraticSmoothAbs(X, Y: double);
    procedure CurveToQuadraticSmoothRel(X, Y: double);
    // Create an arc from current location to X, Y, using an arc that has radius
    // in X of Rx and radius in Y of Ry, and a rotation of Angle (in degrees).
    // Since there are basically 4 solutions for an ellipse through 2 points, the
    // flags indicate which one to take. if LargeArc = True, the largest arclength
    // solution will be chosen. If Sweep = True, the solution which walks in positive
    // arc direction will be chosen.
    procedure ArcToAbs(Rx, Ry, Angle: double; LargeArc, Sweep: boolean; X, Y: double);
    procedure ArcToRel(Rx, Ry, Angle: double; LargeArc, Sweep: boolean; X, Y: double);
    // set values
    procedure SetValues(AFirst: Pdouble; ACount: integer);
    // Sets all command items in one go
    procedure SetCommandItems(AFirst: PpgCommandPathItemRec; ACount: integer);
    function FirstValue: Pdouble;
    function FirstCommand: PpgCommandPathItemRec;
    procedure PlayToPath(APath: TpgPath);
    //
    property ValueCount: integer read GetValueCount;
    property CommandCount: integer read GetCommandCount;
  end;

  TpgPathProp = class(TpgProp)
  private
    FPathValue: TpgCommandPath;
    procedure SetPathValue(const Value: TpgCommandPath);
  protected
    function Decode: boolean; override;
    function Encode: boolean; override;
  public
    destructor Destroy; override;
    property PathValue: TpgCommandPath read FPathValue write SetPathValue;
  end;

  TpgPathShape = class(TpgShape)
  private
    function GetPath: TpgPathProp;
  protected
  public
    procedure PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo); override;
  published
    property Path: TpgPathProp read GetPath;
  end;

  TpgUsageUnitsProp = class(TpgIntProp)
  private
    function GetIntValue: TpgUsageUnits;
    procedure SetIntValue(const Value: TpgUsageUnits);
  public
    property IntValue: TpgUsageUnits read GetIntValue write SetIntValue;
  end;

  // A Paint Server is a general notion of an element responsible to apply paint
  // to a fill or stroke area. It is the basis for gradient and pattern paint
  // servers, and perhaps others in future.
  TpgPaintServer = class(TpgGroup)
  public
    function CreateSampler(ATransformList: TpgTransformList; const BoundingBox: TpgBox): TpgSampler; virtual; abstract;
  end;

  TpgSceneChangeEvent = procedure (Sender: TObject; AItem: TpgItem; APropId: longword;
    AChange: TpgChangeType) of object;

  TpgSceneListener = class(TPersistent)
  private
    FRef: TObject;
    FOnBeforeChange: TpgSceneChangeEvent;
    FOnAfterChange: TpgSceneChangeEvent;
  public
    constructor Create(ARef: TObject);
    property OnBeforeChange: TpgSceneChangeEvent read FOnBeforeChange write FOnBeforeChange;
    property OnAfterChange: TpgSceneChangeEvent read FOnAfterChange write FOnAfterChange;
  end;

  TpgSceneListenerList = class(TObjectList)
  private
    function GetItems(Index: integer): TpgSceneListener;
  public
    function AddRef(ARef: TObject): TpgSceneListener;
    procedure DeleteRef(ARef: TObject);
    property Items[Index: integer]: TpgSceneListener read GetItems; default;
  end;

  TpgScene = class(TpgDocument)
  private
    FListeners: TpgSceneListenerList;
    function GetViewPort: TpgViewPort;
  protected
    procedure DoBeforeChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType); override;
    procedure DoAfterChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType); override;
//todo    function GetRootNodeClass: TsdNodeClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToStream(Stream: TStream); override;
    function ItemByName(const AName: Utf8String): TpgItem;
    property ViewPort: TpgViewPort read GetViewPort;
    property Listeners: TpgSceneListenerList read FListeners;
  end;

  // Specific element class that can contain binary data
  TpgResource = class(TpgRefItem)
  private
    FLoaded: boolean;
    function GetData: TpgBinaryProp;
    function GetUri: TpgStringProp;
    function GetMimeType: TpgStringProp;
  protected
    procedure DoBeforeSave; override;
    function IsChanged: boolean; virtual;
  public
    procedure Load; virtual;
    procedure Save; virtual;
    property URI: TpgStringProp read GetUri;
    property MimeType: TpgStringProp read GetMimeType;
    property Data: TpgBinaryProp read GetData;
    property Loaded: boolean read FLoaded;
  end;

  // Special resource type that loads images
  TpgImageResource = class(TpgResource)
  private
    FBitmap: TpgBitmap;
    function GetBitmap: TpgBitmap;
  protected
    function IsChanged: boolean; override;
  public
    destructor Destroy; override;
    procedure Load; override;
    procedure Save; override;
    // Bitmap will return a reference to the bitmap for raster images
    property Bitmap: TpgBitmap read GetBitmap;
  end;

  // TpgImageProp references a TpgImageResource element, which contains the data
  TpgImageProp = class(TpgRefProp)
  private
    function GetBitmap: TpgBitmap;
  protected
    function CheckReference: TpgImageResource;
  public
    // Load the image from file AFileName. If Embed is set to True, the image
    // is embedded in the pyro document, otherwise it will be just referenced
    // unless the bitmap gets changed. Referenced images must still exist in the
    // file system next time the pyro document is loaded!
    procedure LoadFromFile(const AFileName: string; Embed: boolean);
    procedure LoadFromURI(const AURI: string);
    property Bitmap: TpgBitmap read GetBitmap;
  end;

  // Specialized viewport for images. It overrides the way the viewbox Min/Max
  // are established (uses the underlying bitmap if no viewbox is defined)
  TpgImageView = class(TpgViewPort)
  private
    function GetImage: TpgImageProp;
  protected
    procedure GetViewBoxProps(var AMinX, AMinY, AWidth, AHeight: double); override;
  public
    property Image: TpgImageProp read GetImage;
  end;

  TpgTextSpan = class(TpgGraphic)
  private
    function GetDx: TpgHLengthListProp;
    function GetDy: TpgVLengthListProp;
    function GetX: TpgHLengthListProp;
    function GetY: TpgVLengthListProp;
    function GetText: TpgStringProp;
  public
    property X: TpgHLengthListProp read GetX;
    property Y: TpgVLengthListProp read GetY;
    property Dx: TpgHLengthListProp read GetDx;
    property Dy: TpgVLengthListProp read GetDy;
    property Text: TpgStringProp read GetText;
  end;

  // Text element class
  TpgText = class(TpgTextSpan)
  public
    constructor Create(AOwner: TNativeXml); override;
  end;


implementation

{ TpgLengthProp }

procedure TpgLengthProp.CopyFrom(ANode: TObject);
begin
  inherited;
  FFloatValue := TpgLengthProp(ANode).FFloatValue;
  FUnits := TpgLengthProp(ANode).FUnits;
end;

{function TpgLengthProp.Decode: boolean;
begin
  SetValue(Document.FWriter.pgWriteLength(FUnits, FFloatValue));;
  Result := True;
end;todo}

{function TpgLengthProp.Encode: boolean;
begin
  Result := Document.FParser.pgParseLength(Value, FUnits, FFloatValue);
end;todo}

class function TpgLengthProp.GetDirection: TpgCartesianDirection;
begin
  Result := cdUnknown;
end;

procedure TpgLengthProp.SetFloatValue(const Value: double);
{begin
  // Do we have to write?
  if (FFloatValue <> Value) then
  begin
    DoBeforeChange(Parent);
    FFloatValue := Value;
    DoAfterChange(Parent);
  end;
end;todo}

{procedure TpgLengthProp.SetUnits(const Value: TpgLengthUnits);
begin
  if (FUnits <> Value) then
  begin
    DoBeforeChange(Parent);
    FUnits := Value;
    DoAfterChange(Parent);
  end;
end;todo}

{function TpgLengthProp.ToDevice(const AInfo: TpgDeviceInfo): double;
begin
  Result := 0;
  if not (Parent is TpgSizeable) then
  begin
    DoDebugOut(Self, wsFail, Format('unable to resolve length through parent (classname=%s)',
      [sdClassName(Parent)]));
    exit;
  end;
  Result := TpgSizeable(Parent).ResolveLength(FFloatValue, FUnits, GetDirection, AInfo)
end;todo}

{ TpgHLengthProp }

{class function TpgHLengthProp.GetDirection: TpgCartesianDirection;
begin
  Result := cdHorizontal;
end;todo}

{ TpgVLengthProp }

{class function TpgVLengthProp.GetDirection: TpgCartesianDirection;
begin
  Result := cdVertical;
end;todo}

{ TpgFloatItem }

{todo constructor TpgFloatItem.Create(AOwner: TpgFloatListProp);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TpgFloatItem.SetValue(const Value: double);
var
  Parent: TpgItem;
begin
  if FValue <> Value then
  begin
    Parent := FOwner.Parent;
    FOwner.DoBeforeChange(Parent);
    FValue := Value;
    FOwner.DoAfterChange(Parent);
  end;
end;}

{ TpgFloatProtectList }

{procedure TpgFloatProtectList.Add(AItem: TpgFloatItem);
begin
  raise Exception.Create(sIllegalUseDirectAdd);
end;

procedure TpgFloatProtectList.AddInternal(Value: double);
var
  Item: TpgFloatItem;
begin
  Item := TpgFloatItem.Create(FOwner);
  Item.FValue := Value;
  inherited Add(Item);
end;

procedure TpgFloatProtectList.CopyFrom(AList: TpgFLoatProtectList);
var
  i: integer;
begin
  Clear;
  for i := 0 to AList.Count - 1 do
    AddInternal(AList[i].Value);
end;

constructor TpgFloatProtectList.Create(AOwner: TpgFloatListProp);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TpgFloatProtectList.GetItems(Index: integer): TpgFloatItem;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;}

{ TpgFloatListProp }

{procedure TpgFloatListProp.Add(Value: double);
//  Prop: TpgFloatListProp;
begin
  DoBeforeChange(Parent);
  FValues.AddInternal(Value);
  DoAfterChange(Parent);
end;

procedure TpgFloatListProp.CopyFrom(ANode: TObject);
begin
  inherited;
  FValues.CopyFrom(TpgFloatListProp(ANode).FValues);
end;

constructor TpgFloatListProp.Create(AOwner: TComponent);
begin
  inherited;
  FValues := TpgFloatProtectList.Create(Self);
end;

function TpgFloatListProp.Decode: boolean;
begin
//todo
  Result := False;
end;

function TpgFloatListProp.Encode: boolean;
begin
//todo
  Result := False;
end;

destructor TpgFloatListProp.Destroy;
begin
  FreeAndNil(FValues);
  inherited;
end;

{procedure TpgFloatListProp.Read(AStorage: TpgStorage);
var
  i, Count: integer;
begin
  inherited;
  Count := AStorage.ReadInt;
  for i := 0 to Count - 1 do
    FValues.AddInternal(AStorage.ReadFloat);
end;

procedure TpgFloatListProp.Write(AStorage: TpgStorage);
var
  i: integer;
begin
  inherited;
  AStorage.WriteInt(FValues.Count);
  for i := 0 to FValues.Count - 1 do
    AStorage.WriteFloat(FValues[i].Value);
end;}

{procedure TpgFloatListProp.SetValues(const Value: TpgFloatProtectList);
begin
  if (FValues <> Value) then
  begin
    DoBeforeChange(Parent);
    FValues := Value;
    DoAfterChange(Parent);
  end;
end;}

{ TpgLengthItem }

{constructor TpgLengthItem.Create(AOwner: TpgLengthListProp);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TpgLengthItem.SetUnits(const Value: TpgLengthUnits);
begin
  if FUnits <> Value then
  begin
    FOwner.DoBeforeChange(FOwner.Parent);
    FUnits := Value;
    FOwner.DoAfterChange(FOwner.Parent);
  end;
end;

procedure TpgLengthItem.SetValue(const Value: double);
begin
  if FValue <> Value then
  begin
    FOwner.DoBeforeChange(FOwner.Parent);
    FValue := Value;
    FOwner.DoAfterChange(FOwner.Parent);
  end;
end;

function TpgLengthItem.ToDevice(const AInfo: TpgDeviceInfo): double;
begin
  Result := 0;
  if not(FOwner.Parent is TpgSizeable) then
  begin
    DoDebugOut(Self, wsFail, 'unable to resolve length through parent');
    exit;
  end;
  Result := TpgSizeable(FOwner.Parent).ResolveLength(FValue, FUnits, FOwner.GetDirection, AInfo)
end;}

{ TpgLengthProtectList }

{procedure TpgLengthProtectList.Add(AItem: TpgLengthItem);
begin
  raise Exception.Create(sIllegalUseDirectAdd);
end;

procedure TpgLengthProtectList.AddInternal(Value: double; Units: TpgLengthUnits);
var
  Item: TpgLengthItem;
begin
  Item := TpgLengthItem.Create(FOwner);
  Item.FValue := Value;
  Item.FUnits := Units;
  inherited Add(Item);
end;

procedure TpgLengthProtectList.CopyFrom(AList: TpgLengthProtectList);
var
  i: integer;
begin
  Clear;
  for i := 0 to AList.Count - 1 do
    AddInternal(AList[i].Value, AList[i].Units);
end;

constructor TpgLengthProtectList.Create(AOwner: TpgLengthListProp);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TpgLengthProtectList.GetItems(Index: integer): TpgLengthItem;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;}

{ TpgLengthListProp }

{procedure TpgLengthListProp.Add(Value: double; Units: TpgLengthUnits);
begin
  DoBeforeChange(Parent);
  Values.AddInternal(Value, Units);
  DoAfterChange(Parent);
end;

procedure TpgLengthListProp.CopyFrom(ANode: TObject);
begin
  inherited;
  FValues.CopyFrom(TpgLengthListProp(ANode).FValues);
end;

constructor TpgLengthListProp.Create(AOwner: TComponent);
begin
  inherited;
  FValues := TpgLengthProtectList.Create(Self);
end;

function TpgLengthListProp.Decode: boolean;
begin
//todo
  Result := False;
end;

function TpgLengthListProp.Encode: boolean;
begin
//todo
  Result := False;
end;

destructor TpgLengthListProp.Destroy;
begin
  FreeAndNil(FValues);
  inherited;
end;

class function TpgLengthListProp.GetDirection: TpgCartesianDirection;
begin
  Result := cdUnknown;
end;

{procedure TpgLengthListProp.Read(AStorage: TpgStorage);
var
  i, Count: integer;
begin
  inherited;
  Count := AStorage.ReadInt;
  for i := 0 to Count - 1 do
    FValues.AddInternal(
      AStorage.ReadFloat,
      TpgLengthUnits(AStorage.ReadInt));
end;

procedure TpgLengthListProp.Write(AStorage: TpgStorage);
var
  i: integer;
begin
  inherited;
  AStorage.WriteInt(FValues.Count);
  for i := 0 to FValues.Count - 1 do
  begin
    AStorage.WriteFloat(FValues[i].Value);
    AStorage.WriteInt(integer(FValues[i].Units));
  end;
end;}

{procedure TpgLengthListProp.SetValues(const Value: TpgLengthProtectList);
begin
  if (FValues <> Value) then
  begin
    DoBeforeChange(Parent);
    FValues := Value;
    DoAfterChange(Parent);
  end;
end;}

{ TpgHLengthListProp }

{class function TpgHLengthListProp.GetDirection: TpgCartesianDirection;
begin
  Result := cdHorizontal;
end;}

{ TpgVLengthListProp }

{class function TpgVLengthListProp.GetDirection: TpgCartesianDirection;
begin
  Result := cdVertical;
end;}

{ TpgSizeable }

function TpgSizeable.GetFontHeight(const AInfo: TpgDeviceInfo): double;
begin
  Result := TpgVLengthProp(PropById(piFontSize)).ToDevice(AInfo);
end;

procedure TpgSizeable.GetViewPortSize(var Width, Height: double; const AInfo: TpgDeviceInfo);
var
  P: TpgItem;
  VB: TpgViewBoxProp;
begin
  // In case *we* are the viewport.. we start the chain up here
  P := Self;
  repeat
    if P is TpgViewPort then
      break;
    P := P.Parent;
  until not assigned(P);

  if not assigned(P) then
    raise Exception.Create(sCannotResolveViewPortUnits);

  if ExistsLocal(TpgViewPort(P).ViewBox) then
  //if TpgViewPort(P).ViewBox.ExistsLocal then
  begin
    VB := TpgViewPort(P).ViewBox;
    Width := VB.Width;
    Height := VB.Height;
  end else
  begin
    Width := TpgViewPort(P).Width.ToDevice(AInfo);
    Height := TpgViewPort(P).Height.ToDevice(AInfo);
  end;
end;

function TpgSizeable.ResolveLength(const AValue: double; AUnits: TpgLengthUnits;
  ADirection: TpgCartesianDirection; const AInfo: TpgDeviceInfo): double;
var
  Width, Height: double;
  // local
  function GetDPI: double;
  begin
    Result := 0;
    case ADirection of
    cdUnknown,
    cdHorizontal: Result := AInfo.DPI.X;
    cdVertical:   Result := AInfo.DPI.Y;
    end;
  end;
// main
begin
  case AUnits of
  luNone: Result := AValue;
  luPerc:
    begin
      GetViewPortSize(Width, Height, AInfo);
      case ADirection of
      cdHorizontal: Result := AValue * 0.01 * Width;
      cdVertical: Result := AValue * 0.01 * Height;
      cdUnknown: Result := AValue * 0.01 * sqrt(Width * Height);
      else
        raise Exception.Create(sInvalidUnitSpec);
      end;
    end;
  luEms: Result := AValue * GetFontHeight(AInfo);//GetFontEmHeight?;
  luExs: Result := AValue * GetFontHeight(AInfo);//GetFontExHeight?;
  luCm: Result := AValue * GetDPI / 2.54;
  luMm: Result := AValue * GetDPI / 25.4;
  luIn: Result := AValue * GetDPI;
  luPt: Result := AValue * GetDPI / 72;
  luPc: Result := AValue * GetDPI / 6;
  else
    raise Exception.Create(sInvalidUnitSpec);
  end;
end;

{ TpgFillRuleProp }

function TpgFillRuleProp.GetIntValue: TpgFillRule;
begin
  Result := TpgFillRule(inherited IntValue);
end;

procedure TpgFillRuleProp.SetIntValue(const Value: TpgFillRule);
begin
  inherited SetIntValue(integer(IntValue));
end;

{ TpgPaintProp }

procedure TpgPaintProp.CopyFrom(ANode: TObject);
begin
  inherited;
  FColor := TpgPaintProp(ANode).FColor;
  FPaintStyle := TpgPaintProp(ANode).FPaintStyle;
end;

function TpgPaintProp.Decode: boolean;
begin
  Result := True;
  case FPaintStyle of
  psNone: Value := 'none';
  psColor:
    Value := Document.FWriter.pgWriteRGB(AsColor32);
  //psBitmap: todo;
  //psGradient: todo;
  //psUnknown: todo;
  else
    Value := '';
    Result := False;
  end;
end;

function TpgPaintProp.Encode: boolean;
begin
//todo
  Result := False;
end;

function TpgPaintProp.GetAsColor32: TpgColor32;
begin
  Result := pgColorTo4Ch8b(GetColorInfo^, cARGB_8b_Org, @FColor);
end;

function TpgPaintProp.GetColorInfo: PpgColorInfo;
begin
  if Parent is TpgPaintable then
  begin
    Result := TpgPaintable(Parent).GetColorInfo;
  end else
    // If no info, we use ARGB 8bpc Org
    Result := @cARGB_8b_Org;
end;

{procedure TpgPaintProp.Read(AStorage: TpgStorage);
var
  i: integer;
begin
  inherited;
  for i := 0 to 7 do
    FColor[i] := AStorage.ReadInt;
  FPaintStyle := TpgPaintStyle(AStorage.ReadInt);
end;}

procedure TpgPaintProp.SetAsColor32(const Value: TpgColor32);
begin
  if (GetAsColor32 <> Value) or (FPaintStyle <> psColor) then
  begin
    DoBeforeChange(Parent);
    FColor :=
      pgConvertColor(cARGB_8b_Org, GetColorInfo^, @Value);
    FPaintStyle := psColor;
    RefItem := nil;
    DoAfterChange(Parent);
  end;
end;

procedure TpgPaintProp.SetPaintStyle(const Value: TpgPaintStyle);
begin
  if (FPaintStyle <> Value) then
  begin
    DoBeforeChange(Parent);
    FPaintStyle := Value;
    DoAfterChange(Parent);
  end;
end;

{procedure TpgPaintProp.Write(AStorage: TpgStorage);
var
  i: integer;
begin
  inherited;
  // should be changed to binary writing
  for i := 0 to 7 do
    AStorage.WriteInt(FColor[i]);
  AStorage.WriteInt(integer(FPaintStyle));
end;}

{ TpgPaintable }

function TpgPaintable.GetColorInfo: PpgColorInfo;
begin
  // For now we return this until there is a colorspace property
  Result :=  @cARGB_8b_Org;
end;

function TpgPaintable.GetFill: TpgPaintProp;
begin
  Result := TpgPaintProp(PropById(piFill));
end;

function TpgPaintable.GetFillOpacity: TpgFloatProp;
begin
  Result := TpgFloatProp(PropById(piFillOpacity));
end;

function TpgPaintable.GetFillRule: TpgFillRuleProp;
begin
  Result := TpgFillRuleProp(PropById(piFillRule));
end;

function TpgPaintable.GetFontFamily: TpgStringProp;
begin
  Result := TpgStringProp(PropById(piFontFamily));
end;

function TpgPaintable.GetFontSize: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piFontSize));
end;

function TpgPaintable.GetLetterSpacing: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piLetterSpacing));
end;

function TpgPaintable.GetOpacity: TpgFloatProp;
begin
  Result := TpgFloatProp(PropById(piOpacity));
end;

function TpgPaintable.GetStroke: TpgPaintProp;
begin
  Result := TpgPaintProp(PropById(piStroke));
end;

function TpgPaintable.GetStrokeDashArray: TpgLengthListProp;
begin
  Result := TpgLengthListProp(PropById(piStrokeDashArray));
end;

function TpgPaintable.GetStrokeDashOffset: TpgLengthProp;
begin
  Result := TpgLengthProp(PropById(piStrokeDashOffset));
end;

function TpgPaintable.GetStrokeMiterLimit: TpgFloatProp;
begin
  Result := TpgFloatProp(PropById(piStrokeMiterLimit));
end;

function TpgPaintable.GetStrokeOpacity: TpgFloatProp;
begin
  Result := TpgFloatProp(PropById(piStrokeOpacity));
end;

function TpgPaintable.GetStrokeWidth: TpgLengthProp;
begin
  Result := TpgLengthProp(PropById(piStrokeWidth));
end;

function TpgPaintable.GetWordSpacing: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piWordSpacing));
end;

procedure TpgPaintable.PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo);
begin
// default does nothing
end;

{ TpgEditorOptionsProp }

function TpgEditorOptionsProp.GetIntValue: TpgEditorOptions;
var
  ISet: TIntegerSet;
  e: TpgEditorOption;
begin
  Result := [];
  ISet := TIntegerSet(inherited IntValue);
  for e := low(TpgEditorOption) to High(TpgEditorOption) do
    if integer(e) in ISet then
      Include(Result, e);
end;

procedure TpgEditorOptionsProp.SetIntValue(const Value: TpgEditorOptions);
var
  ISet: TIntegerSet;
  e: TpgEditorOption;
begin
  ISet := [];
  for e := low(TpgEditorOption) to High(TpgEditorOption) do
    if e in Value then
      Include(ISet, integer(e));
  inherited SetIntValue(integer(ISet));
end;

{ TpgTransformProp }

procedure TpgTransformProp.CopyFrom(ANode: TObject);
begin
  inherited;
  //this is necessary since the transform can have descendants
  FreeAndNil(FTransformValue);
  if assigned(TpgTransformProp(ANode).TransformValue) then
  begin
    FTransformValue := TpgTransformClass(TpgTransformProp(ANode).TransformValue.ClassType).Create;
    FTransformValue.Assign(TpgTransformProp(ANode).TransformValue);
  end;
end;

function TpgTransformProp.Decode: boolean;
begin
//todo
  Result := False;
end;

function TpgTransformProp.Encode: boolean;
begin
//todo
  Result := False;
end;

destructor TpgTransformProp.Destroy;
begin
  FreeAndNil(FTransformValue);
  inherited;
end;

{procedure TpgTransformProp.Read(AStorage: TpgStorage);
var
  Id: longword;
  Info: TpgTransformInfo;
begin
  inherited;
  FreeAndNil(FTransformValue);
  // Read type
  Id := AStorage.ReadInt;
  Info := GetTransformInfoById(Id);
  if not assigned(Info) then exit;
  FTransformValue := Info.TransformClass.Create;
  FTransformValue.Read(AStorage);
end;}

procedure TpgTransformProp.SetTransformValue(const Value: TpgTransform);
begin
  if (FTransformValue <> Value) then
  begin
    DoBeforeChange(Parent);
    FTransformValue := Value;
    DoAfterChange(Parent);
  end;
end;

{procedure TpgTransformProp.Write(AStorage: TpgStorage);
// more types to follow
var
  Info: TpgTransformInfo;
begin
  inherited;
  if not assigned(FTransformValue) then
  begin
    AStorage.WriteInt(0);
    exit;
  end;
  Info := GetTransformInfoByClass(TpgTransformClass(FTransformValue.ClassType));
  if not assigned(Info) then
    raise Exception.Create(sUnregisteredTransform);
  // Write id
  AStorage.WriteInt(Info.Id);
  // Let transform write itself
  FTransformValue.Write(AStorage);
end;}

{ TpgGraphic }

function TpgGraphic.GetEditorOptions: TpgEditorOptionsProp;
begin
  Result := TpgEditorOptionsProp(PropById(piEditorOptions));
end;

function TpgGraphic.GetTransform: TpgTransformProp;
begin
  Result := TpgTransformProp(PropById(piTransform));
end;

{ TpgGroup }

constructor TpgGroup.Create(AOwner: TComponent);
begin
  inherited;
  Flags := Flags + [efAllowElements];
end;

{ TpgBaseViewPort}

function TpgBaseViewPort.GetMeetOrSlice: TpgMeetOrSliceProp;
begin
  Result := TpgMeetOrSliceProp(PropById(piMeetOrSlice));
end;

function TpgBaseViewPort.GetPreserveAspect: TpgPreserveAspectProp;
begin
  Result := TpgPreserveAspectProp(PropById(piPreserveAspect));
end;

function TpgBaseViewPort.GetViewBox: TpgViewBoxProp;
begin
  Result := TpgViewBoxProp(PropById(piViewBox));
end;

procedure TpgBaseViewPort.GetViewBoxProps(var AMinX, AMinY, AWidth, AHeight: double);
begin
  if ExistsLocal(ViewBox) then
//  if ViewBox.ExistsLocal then
  begin
    AMinX := ViewBox.MinX;
    AMinY := ViewBox.MinY;
    AWidth := ViewBox.Width;
    AHeight := ViewBox.Height;
  end else
  begin
    AMinX := 0;
    AMinY := 0;
    AWidth := 0;
    AHeight := 0;
  end;
end;

{ TpgViewPort }

function TpgViewPort.GetHeight: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piVPHeight));
end;

function TpgViewPort.BuildViewBoxTransform(const AInfo: TpgDeviceInfo): TpgTransform;
var
  PA: TpgPreserveAspect;
  VBMinX, VBMinY, VBWidth, VBHeight: double;
begin
  // Make sure to use PreserveAspect = XMidYMid if no value available
  if ExistsLocal(PreserveAspect) then
    PA := PreserveAspect.IntValue
  else
    PA := paXMidYMid;

  // Viewbox props
  GetViewBoxProps(VBMinX, VBMinY, VBWidth, VBHeight);

  // Build viewbox transform
  Result := pgTransform.BuildViewBoxTransform(
    X.ToDevice(AInfo), Y.ToDevice(AInfo),
    Width.ToDevice(AInfo), Height.ToDevice(AInfo),
    VBMinX, VBMinY, VBWidth, VBHeight,
    PA,
    MeetOrSlice.IntValue);
end;

function TpgViewPort.GetWidth: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piVPWidth));
end;

function TpgViewPort.GetX: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piVPX));
end;

function TpgViewPort.GetY: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piVPY));
end;

procedure TpgViewPort.PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo);
var
  VBMinX, VBMinY, VBWidth, VBHeight: double;
begin
  GetViewBoxProps(VBMinX, VBMinY, VBWidth, VBHeight);
  if (VBWidth > 0) and (VBHeight > 0) then
    APath.Rectangle(-VBMinX, -VBMinY, VBWidth, VBHeight, 0, 0)
  else
    APath.Rectangle(0, 0, Width.ToDevice(AInfo), Height.ToDevice(AInfo), 0, 0);
end;

{ TpgProjectiveViewPort }

function TpgProjectiveViewPort.GetLocalTransform(const AInfo: TpgDeviceInfo): TpgTransform;
var
  i: integer;
//  PA: TpgPreserveAspect;
  VBMinX, VBMinY, VBWidth, VBHeight: double;
  List: TpgFloatProtectList;
begin
  Result := nil;
  if not assigned(FLocalTransform) or not FLocalTransform.IsValid then
  begin
    // Create it
    FreeAndNil(FLocalTransform);
    FLocalTransform := TpgProjectiveTransform.Create;
    // Make sure to use PreserveAspect = XMidYMid if no value available
{    if ExistsLocal(PreserveAspect) then
      PA := PreserveAspect.IntValue
    else
      PA := paXMidYMid;}

    // Set viewbox of projective transform
    GetViewBoxProps(VBMinX, VBMinY, VBWidth, VBHeight);
    FLocalTransform.MinX := VBMinX;
    FLocalTransform.MinY := VBMinY;
    FLocalTransform.Width := VBWidth;
    FLocalTransform.Height := VBHeight;

    // Now setup the points
    List := Points.Values;
    if not assigned(List) or (List.Count <> 8) then
    begin
      DoDebugOut(Self, wsFail, sPointListIncorrect);
      exit;
    end;
    for i := 0 to 3 do begin
      FLocalTransform.Points[i].X := List[i * 2    ].Value;
      FLocalTransform.Points[i].Y := List[i * 2 + 1].Value;
    end;
  end;
  Result := FLocalTransform;
end;

function TpgProjectiveViewPort.GetPoints: TpgFloatListProp;
begin
  Result := TpgFloatListProp(PropById(piPVPPoints));
end;


{ TpgRectangle }

function TpgRectangle.GetHeight: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piRectHeight));
end;

function TpgRectangle.GetRx: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piRectRx));
end;

function TpgRectangle.GetRy: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piRectRy));
end;

function TpgRectangle.GetWidth: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piRectWidth));
end;

function TpgRectangle.GetX: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piRectX));
end;

function TpgRectangle.GetY: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piRectY));
end;

procedure TpgRectangle.PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo);
var
  Res: boolean;
begin
  Res := APath.Rectangle(
    X.ToDevice(AInfo), Y.ToDevice(AInfo),
    Width.ToDevice(AInfo), Height.ToDevice(AInfo),
    Rx.ToDevice(AInfo), Ry.ToDevice(AInfo));
  if not Res then
    raise Exception.Create(sIllegalPropertyValue);
end;

{ TpgCircle }

function TpgCircle.GetCx: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piCircleCx));
end;

function TpgCircle.GetCy: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piCircleCy));
end;

function TpgCircle.GetR: TpgLengthProp;
begin
  Result := TpgLengthProp(PropById(piCircleR));
end;

procedure TpgCircle.PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo);
var
  Res: boolean;
  Rad: double;
begin
  Rad := R.ToDevice(AInfo);
  Res := APath.Ellipse(
    Cx.ToDevice(AInfo), Cy.ToDevice(AInfo),
    Rad, Rad);
  if not Res then
    raise Exception.Create(sIllegalPropertyValue);
end;

{ TpgEllipse }

function TpgEllipse.GetCx: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piEllipseCx));
end;

function TpgEllipse.GetCy: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piEllipseCy));
end;

function TpgEllipse.GetRx: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piEllipseRx));
end;

function TpgEllipse.GetRy: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piEllipseRy));
end;

procedure TpgEllipse.PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo);
var
  Res: boolean;
begin
  Res := APath.Ellipse(
    Cx.ToDevice(AInfo), Cy.ToDevice(AInfo),
    Rx.ToDevice(AInfo), Ry.ToDevice(AInfo));
  if not Res then
    raise Exception.Create(sIllegalPropertyValue);
end;

{ TpgLine }

function TpgLine.GetX1: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piLineX1));
end;

function TpgLine.GetX2: TpgHLengthProp;
begin
  Result := TpgHLengthProp(PropById(piLineX2));
end;

function TpgLine.GetY1: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piLineY1));
end;

function TpgLine.GetY2: TpgVLengthProp;
begin
  Result := TpgVLengthProp(PropById(piLineY2));
end;

procedure TpgLine.PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo);
begin
  APath.MoveTo(X1.ToDevice(AInfo), Y1.ToDevice(AInfo));
  APath.LineTo(X2.ToDevice(AInfo), Y2.ToDevice(AInfo));
end;

{ TpgCommandPath }

procedure TpgCommandPath.AddCommand(ACommand: TpgPathCommandStyle);
begin
  if length(FCommands) <= FCommandCount then
  begin
    // Increase capacity
    SetLength(FCommands, (FCommandCount * 3) div 2 + 4);
  end;

  FCommands[FCommandCount].Command := ACommand;
  FCommands[FCommandCount].Index := FValueCount;

  inc(FCommandCount);
end;

procedure TpgCommandPath.AddValues(ACount: integer; AValues: array of double);
begin
  if ACount <= 0 then exit;
  if length(FValues) < FValueCount + ACount then
  begin
    // Increase capacity
    SetLength(FValues, ((FValueCount + ACount)* 3) div 2 + 4);
  end;
  Move(AValues[0], FValues[FValueCount], ACount * SizeOf(double));
  inc(FValueCount, ACount);
end;

procedure TpgCommandPath.ArcToAbs(Rx, Ry, Angle: double; LargeArc,
  Sweep: boolean; X, Y: double);
begin
  AddCommand(pcArcToAbs);
  AddValues(7, [Rx, Ry, Angle, pgBoolToInt(LargeArc), pgBoolToInt(Sweep), X, Y]);
end;

procedure TpgCommandPath.ArcToRel(Rx, Ry, Angle: double; LargeArc,
  Sweep: boolean; X, Y: double);
begin
  AddCommand(pcArcToRel);
  AddValues(7, [Rx, Ry, Angle, pgBoolToInt(LargeArc), pgBoolToInt(Sweep), X, Y]);
end;

procedure TpgCommandPath.Clear;
begin
  FValueCount := 0;
  FCommandCount := 0;
end;

procedure TpgCommandPath.ClosePath;
begin
  AddCommand(pcClosePath);
end;

procedure TpgCommandPath.CurveToCubicAbs(C1x, C1y, C2x, C2y, X, Y: double);
begin
  AddCommand(pcCurveToCubicAbs);
  AddValues(6, [C1x, C1y, C2x, C2y, X, Y]);
end;

procedure TpgCommandPath.CurveToCubicRel(C1x, C1y, C2x, C2y, X, Y: double);
begin
  AddCommand(pcCurveToCubicRel);
  AddValues(6, [C1x, C1y, C2x, C2y, X, Y]);
end;

procedure TpgCommandPath.CurveToCubicSmoothAbs(C2x, C2y, X, Y: double);
begin
  AddCommand(pcCurveToCubicSmoothAbs);
  AddValues(4, [C2x, C2y, X, Y]);
end;

procedure TpgCommandPath.CurveToCubicSmoothRel(C2x, C2y, X, Y: double);
begin
  AddCommand(pcCurveToCubicSmoothRel);
  AddValues(4, [C2x, C2y, X, Y]);
end;

procedure TpgCommandPath.CurveToQuadraticAbs(Cx, Cy, X, Y: double);
begin
  AddCommand(pcCurveToQuadraticAbs);
  AddValues(4, [Cx, Cy, X, Y]);
end;

procedure TpgCommandPath.CurveToQuadraticRel(Cx, Cy, X, Y: double);
begin
  AddCommand(pcCurveToQuadraticRel);
  AddValues(4, [Cx, Cy, X, Y]);
end;

procedure TpgCommandPath.CurveToQuadraticSmoothAbs(X, Y: double);
begin
  AddCommand(pcCurveToQuadraticSmoothAbs);
  AddValues(2, [X, Y]);
end;

procedure TpgCommandPath.CurveToQuadraticSmoothRel(X, Y: double);
begin
  AddCommand(pcCurveToQuadraticSmoothRel);
  AddValues(2, [X, Y]);
end;

function TpgCommandPath.FirstCommand: PpgCommandPathItemRec;
begin
  if FCommandCount > 0 then
    Result := @FCommands[0]
  else
    Result := nil;
end;

function TpgCommandPath.FirstValue: Pdouble;
begin
  if FValueCount > 0 then
    Result := @FValues[0]
  else
    Result := nil;
end;

function TpgCommandPath.GetCommandCount: integer;
begin
  Result := FCommandCount;
end;

function TpgCommandPath.GetValueCount: integer;
begin
  Result := FValueCount;
end;

procedure TpgCommandPath.LineToAbs(X, Y: double);
begin
  AddCommand(pcLineToAbs);
  AddValues(2, [X, Y]);
end;

procedure TpgCommandPath.LineToHorAbs(X: double);
begin
  AddCommand(pcLineToHorAbs);
  AddValues(1, [X]);
end;

procedure TpgCommandPath.LineToHorRel(X: double);
begin
  AddCommand(pcLineToHorRel);
  AddValues(1, [X]);
end;

procedure TpgCommandPath.LineToRel(X, Y: double);
begin
  AddCommand(pcLineToRel);
  AddValues(2, [X, Y]);
end;

procedure TpgCommandPath.LineToVerAbs(Y: double);
begin
  AddCommand(pcLineToVerAbs);
  AddValues(1, [Y]);
end;

procedure TpgCommandPath.LineToVerRel(Y: double);
begin
  AddCommand(pcLineToVerRel);
  AddValues(1, [Y]);
end;

procedure TpgCommandPath.MoveToAbs(X, Y: double);
begin
  AddCommand(pcMoveToAbs);
  AddValues(2, [X, Y]);
end;

procedure TpgCommandPath.MoveToRel(X, Y: double);
begin
  AddCommand(pcMoveToRel);
  AddValues(2, [X, Y]);
end;

procedure TpgCommandPath.PlayToPath(APath: TpgPath);
var
  i: integer;
  FInitialPoint: TpgPoint;
  FCurrentPoint: TpgPoint;
  FPreviousPoint: TpgPoint;
  ValueList: PDoubleArray;
  // local
  procedure DoClosePath;
  begin
    APath.ClosePath;
    FCurrentPoint := FInitialPoint;
  end;
  function ConvertToAbs(const APoint: TpgPoint): TpgPoint;
  begin
    Result.X := APoint.X + FCurrentPoint.X;
    Result.Y := APoint.Y + FCurrentPoint.Y;
  end;
  procedure DoMoveTo(const APoint: TpgPoint);
  begin
    APath.MoveTo(APoint.X, APoint.Y);
    FInitialPoint := APoint;
    FCurrentPoint := APoint;
  end;
  procedure DoLineTo(const APoint: TpgPoint);
  begin
    APath.LineTo(APoint.X, APoint.Y);
    FPreviousPoint := FCurrentPoint;
    FCurrentPoint := APoint;
  end;
  procedure DoCurveToCubic(const C1, C2, P: TpgPoint);
  begin
    APath.CurveToCubic(C1.X, C1.Y, C2.X, C2.Y, P.X, P.Y);
    FPreviousPoint := C2;
    FCurrentPoint := P;
  end;
  procedure DoCurveToQuadratic(const C, P: TpgPoint);
  begin
    APath.CurveToQuadratic(C.X, C.Y, P.X, P.Y);
    FPreviousPoint := C;
    FCurrentPoint := P;
  end;
  procedure DoArcTo(const Rx, Ry, Angle: double; LargeArc, Sweep: boolean; P: TpgPoint);
  begin
    APath.ArcTo(Rx, Ry, Angle, LargeArc, Sweep, P.X, P.Y);
    FPreviousPoint := FCurrentPoint;
    FCurrentPoint := P;
  end;
// main
begin
  // Play the command list to the pathset
  APath.Clear;
  for i := 0 to FCommandCount - 1 do
  begin
    {$R-}
    ValueList := @FValues[FCommands[i].Index];
    {$R+}
    case FCommands[i].Command of
    pcClosePath:
      DoClosePath;
    pcMoveToAbs:
      DoMoveTo(pgPoint(ValueList[0], ValueList[1]));
    pcMoveToRel:
      DoMoveTo(ConvertToAbs(pgPoint(ValueList[0], ValueList[1])));
    pcLineToAbs:
      DoLineTo(pgPoint(ValueList[0], ValueList[1]));
    pcLineToRel:
      DoLineTo(ConvertToAbs(pgPoint(ValueList[0], ValueList[1])));
    pcLineToHorAbs:
      DoLineTo(pgPoint(ValueList[0], FCurrentPoint.Y));
    pcLineToHorRel:
      DoLineTo(ConvertToAbs(pgPoint(ValueList[0], 0)));
    pcLineToVerAbs:
      DoLineTo(pgPoint(FCurrentPoint.X, ValueList[0]));
    pcLineToVerRel:
      DoLineTo(ConvertToAbs(pgPoint(0, ValueList[0])));
    pcCurveToCubicAbs:
      DoCurveToCubic(
        pgPoint(ValueList[0], ValueList[1]),
        pgPoint(ValueList[2], ValueList[3]),
        pgPoint(ValueList[4], ValueList[5]));
    pcCurveToCubicRel:
      DoCurveToCubic(
        ConvertToAbs(pgPoint(ValueList[0], ValueList[1])),
        ConvertToAbs(pgPoint(ValueList[2], ValueList[3])),
        ConvertToAbs(pgPoint(ValueList[4], ValueList[5])));
    pcCurveToCubicSmoothAbs:
      DoCurveToCubic(
        pgReflectPoint(FPreviousPoint, FCurrentPoint),
        pgPoint(ValueList[0], ValueList[1]),
        pgPoint(ValueList[2], ValueList[3]));
    pcCurveToCubicSmoothRel:
      DoCurveToCubic(
        pgReflectPoint(FPreviousPoint, FCurrentPoint),
        ConvertToAbs(pgPoint(ValueList[0], ValueList[1])),
        ConvertToAbs(pgPoint(ValueList[2], ValueList[3])));
    pcCurveToQuadraticAbs:
      DoCurveToQuadratic(
        pgPoint(ValueList[0], ValueList[1]),
        pgPoint(ValueList[2], ValueList[3]));
    pcCurveToQuadraticRel:
      DoCurveToQuadratic(
        ConvertToAbs(pgPoint(ValueList[0], ValueList[1])),
        ConvertToAbs(pgPoint(ValueList[2], ValueList[3])));
    pcCurveToQuadraticSmoothAbs:
      DoCurveToQuadratic(
        pgReflectPoint(FPreviousPoint, FCurrentPoint),
        pgPoint(ValueList[0], ValueList[1]));
    pcCurveToQuadraticSmoothRel:
      DoCurveToQuadratic(
        pgReflectPoint(FPreviousPoint, FCurrentPoint),
        ConvertToAbs(pgPoint(ValueList[0], ValueList[1])));
    pcArcToAbs:
      DoArcTo(
        ValueList[0], ValueList[1], ValueList[2],
        round(ValueList[3]) = 1, round(ValueList[4]) = 1,
        pgPoint(ValueList[5], ValueList[6]));
    pcArcToRel:
      DoArcTo(
        ValueList[0], ValueList[1], ValueList[2],
        round(ValueList[3]) = 1, round(ValueList[4]) = 1,
        ConvertToAbs(pgPoint(ValueList[5], ValueList[6])));
    end;//case
  end;
end;

procedure TpgCommandPath.SetCommandItems(AFirst: PpgCommandPathItemRec; ACount: integer);
begin
  SetLength(FCommands, ACount);
  FCommandCount := ACount;
  if ACount = 0 then
    exit;
  Move(AFirst^, FCommands[0], ACount * SizeOf(TpgCommandPathItemRec));
end;

procedure TpgCommandPath.SetValues(AFirst: Pdouble; ACount: integer);
begin
  SetLength(FValues, ACount);
  FValueCount := ACount;
  if ACount = 0 then
    exit;
  Move(AFirst^, FValues[0], ACount * SizeOf(double));
end;

{ TpgPathProp }

function TpgPathProp.Decode: boolean;
begin
//todo
  Result := False;
end;

function TpgPathProp.Encode: boolean;
begin
//todo
  Result := False;
end;

destructor TpgPathProp.Destroy;
begin
  FreeAndNil(FPathValue);
  inherited;
end;

{procedure TpgPathProp.Read(AStorage: TpgStorage);
var
  i, Count: integer;
  ValueBuf: array of double;
  CommandBuf: array of TpgCommandPathItemR;
begin
  if not assigned(FPathValue) then
    FPathValue := TpgCommandPath.Create;
  FPathValue.Clear;
  Count := AStorage.ReadInt;
  if Count > 0 then
  begin
    SetLength(ValueBuf, Count);
    for i := 0 to Count - 1 do
      ValueBuf[i] := AStorage.ReadFloat;
    FPathValue.SetValues(@ValueBuf[0], Count);
  end;
  Count := AStorage.ReadInt;
  if Count > 0 then
  begin
    SetLength(CommandBuf, Count);
    for i := 0 to Count - 1 do begin
      CommandBuf[i].Command := TpgPathCommandStyle(AStorage.ReadInt);
      CommandBuf[i].Index := AStorage.ReadInt;
    end;
    FPathValue.SetCommandItems(@CommandBuf[0], Count);
  end;
end;}

procedure TpgPathProp.SetPathValue(const Value: TpgCommandPath);
begin
  if (FPathValue <> Value) then
  begin
    DoBeforeChange(Parent);
    FPathValue := Value;
    DoAfterChange(Parent);
  end;
end;

{procedure TpgPathProp.Write(AStorage: TpgStorage);
var
  i, Count: integer;
  FirstValue: Pdouble;
  FirstCommand: PpgCommandPathItemR;
begin
  Count := FPathValue.ValueCount;
  AStorage.WriteInt(Count);
  FirstValue := FPathValue.FirstValue;
  for i := 0 to Count - 1 do
  begin
    AStorage.WriteFloat(FirstValue^);
    inc(FirstValue);
  end;
  Count := FPathValue.CommandCount;
  AStorage.WriteInt(Count);
  FirstCommand := FPathValue.FirstCommand;
  for i := 0 to Count - 1 do
  begin
    AStorage.WriteInt(integer(FirstCommand.Command));
    AStorage.WriteInt(FirstCommand.Index);
    inc(FirstCommand);
  end;
end;}

{ TpgPolyLineShape }

function TpgPolyLineShape.GetPoints: TpgFloatListProp;
begin
  Result := TpgFloatListProp(PropById(piPoints));
end;

procedure TpgPolyLineShape.PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo);
var
  i: integer;
  List: TpgFloatProtectList;
begin
  inherited;
  if not ExistsLocal(Points) then
    exit;
  List := Points.Values;
  if List.Count < 2 then
    exit;
  APath.MoveTo(List[0].Value, List[1].Value);
  for i := 1 to List.Count div 2 - 1 do
    APath.LineTo(List[i * 2].Value, List[i * 2 + 1].Value);
end;

{ TpgPolygonShape }

procedure TpgPolygonShape.PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo);
begin
  inherited;
  // at least two points for close to make sense
  if Points.Values.Count >= 4 then
    APath.ClosePath;
end;

{ TpgPathShape }

function TpgPathShape.GetPath: TpgPathProp;
begin
  Result := TpgPathProp(PropById(piPath));
end;

procedure TpgPathShape.PlayFillPath(APath: TpgPath; const AInfo: TpgDeviceInfo);
var
  CommandPath: TpgCommandPath;
begin
  CommandPath := GetPath.PathValue;
  if assigned(CommandPath) then
    CommandPath.PlayToPath(APath);
end;


{ TpgViewBoxProp }

{procedure TpgViewBoxProp.Read(AStorage: TpgStorage);
begin
  inherited;
  FMinX := AStorage.ReadFloat;
  FMinY := AStorage.ReadFloat;
  FWidth := AStorage.ReadFloat;
  FHeight := AStorage.ReadFloat;
end;}

function TpgViewBoxProp.Decode: boolean;
begin
//todo
  Result := False;
end;

function TpgViewBoxProp.Encode: boolean;
begin
//todo
  Result := False;
end;

procedure TpgViewBoxProp.SetHeight(const Value: double);
begin
  if (FHeight <> Value) then
  begin
    DoBeforeChange(Parent);
    FHeight := Value;
    DoAfterChange(Parent);
  end;
end;

procedure TpgViewBoxProp.SetMinX(const Value: double);
begin
  if (FMinX <> Value) then
  begin
    DoBeforeChange(Parent);
    FMinX := Value;
    DoAfterChange(Parent);
  end;
end;

procedure TpgViewBoxProp.SetMinY(const Value: double);
begin
  if (FMinY <> Value) then
  begin
    DoBeforeChange(Parent);
    FMinY := Value;
    DoAfterChange(Parent);
  end;
end;

procedure TpgViewBoxProp.SetWidth(const Value: double);
begin
  if (FWidth <> Value) then
  begin
    DoBeforeChange(Parent);
    FWidth := Value;
    DoAfterChange(Parent);
  end;
end;

{procedure TpgViewBoxProp.Write(AStorage: TpgStorage);
begin
  inherited;
  AStorage.WriteFloat(FMinX);
  AStorage.WriteFloat(FMinY);
  AStorage.WriteFloat(FWidth);
  AStorage.WriteFloat(FHeight);
end;}

{ TpgPreserveAspectProp }

function TpgPreserveAspectProp.GetIntValue: TpgPreserveAspect;
begin
  Result := TpgPreserveAspect(inherited IntValue);
end;

procedure TpgPreserveAspectProp.SetIntValue(const Value: TpgPreserveAspect);
begin
  inherited SetIntValue(integer(Value));
end;

{ TpgMeetOrSliceProp }

function TpgMeetOrSliceProp.GetIntValue: TpgMeetOrSlice;
begin
  Result := TpgMeetOrSlice(inherited IntValue);
end;

procedure TpgMeetOrSliceProp.SetIntValue(const Value: TpgMeetOrSlice);
begin
  inherited SetIntValue(integer(Value));
end;

{ TpgUsageUnitsProp }

function TpgUsageUnitsProp.GetIntValue: TpgUsageUnits;
begin
  Result := TpgUsageUnits(inherited IntValue);
end;

procedure TpgUsageUnitsProp.SetIntValue(const Value: TpgUsageUnits);
begin
  inherited SetIntValue(integer(Value));
end;

{ TpgSceneListener }

constructor TpgSceneListener.Create(ARef: TObject);
begin
  inherited Create;
  FRef := ARef;
end;

{ TpgSceneListenerList }

function TpgSceneListenerList.AddRef(ARef: TObject): TpgSceneListener;
begin
  Result := TpgSceneListener.Create(ARef);
  Add(Result);
end;

procedure TpgSceneListenerList.DeleteRef(ARef: TObject);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].FRef = Aref then
    begin
      Delete(i);
      exit;
    end;
end;

function TpgSceneListenerList.GetItems(Index: integer): TpgSceneListener;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

{ TpgScene }

constructor TpgScene.Create(AOwner: TComponent);
begin
  inherited;
  FListeners := TpgSceneListenerList.Create;
end;

destructor TpgScene.Destroy;
begin
  FreeAndNil(FListeners);
  inherited;
end;

procedure TpgScene.DoAfterChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType);
var
  i: integer;
begin
  if FUpdateCount > 0 then
    exit;
  for i := 0 to FListeners.Count - 1 do
    if assigned(FListeners[i].FOnAfterChange) then
      FListeners[i].FOnAfterChange(Self, AItem, APropId, AChange);
end;

procedure TpgScene.DoBeforeChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType);
var
  i: integer;
begin
  if FUpdateCount > 0 then
    exit;
  for i := 0 to FListeners.Count - 1 do
    if assigned(FListeners[i].FOnBeforeChange) then
      FListeners[i].FOnBeforeChange(Self, AItem, APropId, AChange);
end;

function TpgScene.ItemByName(const AName: Utf8String): TpgItem;
var
  i: integer;
  AItem: TpgItem;
begin
  // might have to iterate thru all nodes? see FindFirst/FindNext in NativeXml.pas
  Result := nil;

  for i := 0 to RootNodeCount - 1 do
  begin
    AItem := TpgItem(RootNodes[i]);
    if (AItem is TpgStyleable) and (TpgStyleable(AItem).StyleName.StringValue = AName) then
    begin
      Result := AItem;
      exit;
    end;
  end;
end;

function TpgScene.GetRootNodeClass: TsdNodeClass;
begin
  Result := TpgViewPort;
end;

function TpgScene.GetViewPort: TpgViewPort;
begin
  Result := TpgViewPort(Root);
end;

procedure TpgScene.SaveToStream(Stream: TStream);
begin
  // doctype information
  DocTypeDeclaration.ExternalId.Value := 'PUBLIC';
  DocTypeDeclaration.SystemLiteral.Value := '-//W3C//DTD SVG 1.1//EN';
  DocTypeDeclaration.PubIDLiteral.Value := 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd';

  // svg root xmlns, xmlns:xlink and height (test!)
  Root.AttributeAdd('xmlns', 'http://www.w3.org/2000/svg');
  Root.AttributeAdd('xmlns:xlink', 'http://www.w3.org/1999/xlink');
  Root.AttributeAdd('height', '800');

  // call inherited
  inherited;
end;

{ TpgResource }

procedure TpgResource.DoBeforeSave;
// Here we make sure that changes to the resource are saved, and if the
// resource isn't located locally then we can remove the raw data
begin
  if IsChanged then
    Save;
  if (URI.Value <> 'data') then
  begin
    // Remove raw data
    PropById(piData).Delete;
    FLoaded := False;
  end;
end;

function TpgResource.GetData: TpgBinaryProp;
begin
  Result := TpgBinaryProp(PropById(piData));
end;

function TpgResource.GetMimeType: TpgStringProp;
begin
  Result := TpgStringProp(PropById(piMimeType));
end;

function TpgResource.GetUri: TpgStringProp;
begin
  Result := TpgStringProp(PropById(piURI));
end;

function TpgResource.IsChanged: boolean;
begin
  Result := False;
end;

procedure TpgResource.Load;
var
  URIRef: TpgURIReference;
  URIValue: Utf8String;
  M: TMemoryStream;
  MType: Utf8String;
begin
  URIRef := TpgURIReference.Create;
  M := TMemoryStream.Create;
  try
    URIValue := URI.Value;
    if URIValue <> 'data' then
    begin
      URIRef.Parse(URIValue, '');
      URIRef.LoadResource(M, MType);
      MimeType.Value := MType;
      Data.SetBinary(M.Memory, M.Size);
    end;
    FLoaded := True;
  finally
    URIRef.Free;
    M.Free;
  end;
end;

procedure TpgResource.Save;
begin
// default does nothing
end;

{ TpgImageResource }

destructor TpgImageResource.Destroy;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

function TpgImageResource.GetBitmap: TpgBitmap;
begin
  if not Loaded and (URI.Value <> '') then
    Load;
  if not assigned(FBitmap) then
    FBitmap := TpgBitmap.Create;
  Result := FBitmap;
end;

function TpgImageResource.IsChanged: boolean;
begin
  Result := False;
  if assigned(FBitmap) then
    Result := FBitmap.Changed;
end;

procedure TpgImageResource.Load;
var
  SS: TStringStream;
  RasterClass: TpgRasterClass;
begin
  // this loads the uri into raw data
  inherited;

  // See if we can load the image as bitmap
  RasterClass := FindRasterClassByMimeType(MimeType.Value);
  if not assigned(RasterClass) then
  begin
    DoDebugOut(Self, wsFail, sUnknownRasterImageType);
    exit;
  end;

  // Make sure we have a bitmap
  if not assigned(FBitmap) then
    FBitmap := TpgBitmap.Create;

  // Load the bitmap
  SS := TStringStream.Create(Data.Value);
  try
    LoadImageFromStream(SS, FBitmap, RasterClass);
  finally
    SS.Free;
  end;
  FBitmap.Changed := False;
end;

procedure TpgImageResource.Save;
var
  M: TMemoryStream;
begin
  if not assigned(FBitmap) then
    exit;
  URI.Value := 'data';
  // Save the bitmap as png
  MimeType.Value := 'image/png';
  M := TMemoryStream.Create;
  try
    SaveImageToStream(M, FBitmap, 'image/png');
    Data.SetBinary(M.Memory, M.Size);
  finally
    M.Free;
  end;
end;

{ TpgImageProp }

function TpgImageProp.CheckReference: TpgImageResource;
var
  Document: TpgDocument;
begin
  Result := TpgImageResource(RefItem);
  if not assigned(Result) then
  begin
    Document := GetDocument;
    if assigned(Document) then
      // Create in the owning document
      Result := TpgImageResource.CreateParent(Document, Document.Root)
    else
      // Create in the wild
      Result := TpgImageResource.Create(nil);
    RefItem := Result;
  end;
end;

function TpgImageProp.GetBitmap: TpgBitmap;
var
  Ref: TpgImageResource;
begin
  Result := nil;
  Ref := CheckReference;
  if assigned(Ref) then
    Result := Ref.Bitmap;
end;

procedure TpgImageProp.LoadFromFile(const AFileName: string; Embed: boolean);
var
  Ref: TpgImageResource;
  M: TMemoryStream;
begin
  if Embed then
  begin
    Ref := CheckReference;
    Ref.URI.Value := 'data';
    Ref.MimeType.Value := TpgURIReference.ExtensionToMimeType(ExtractFileExt(AFileName));
    // Copy the file's content to the data
    M := TMemoryStream.Create;
    try
      M.LoadFromFile(AFileName);
      Ref.Data.SetBinary(M.Memory, M.Size);
    finally
      M.Free;
    end;
    // Load the image resource (this fills the bitmap)
    Ref.Load;
  end else
    LoadFromURI('file://' + UriEncode(AFileName));
end;

procedure TpgImageProp.LoadFromURI(const AURI: string);
var
  Ref: TpgImageResource;
begin
  // Check if we have a TpgResource reference
  Ref := CheckReference;
  Ref.URI.Value := AURI;
  Ref.Load;
end;

{ TpgImageView }

function TpgImageView.GetImage: TpgImageProp;
begin
  Result := TpgImageProp(PropById(piImage));
end;

procedure TpgImageView.GetViewBoxProps(var AMinX, AMinY, AWidth,
  AHeight: double);
begin
  // if we have explicitly defined viewbox, we use that, otherwise use the
  // bitmap's dimensions
  inherited;
  if ExistsLocal(ViewBox) then
    exit;

  if assigned(Image.Bitmap) then
  begin
    // Use implicitly defined values
    AWidth := Image.Bitmap.Width;
    AHeight := Image.Bitmap.Height;
  end;
end;

{ TpgTextSpan }

function TpgTextSpan.GetDx: TpgHLengthListProp;
begin
  Result := TpgHLengthListProp(PropById(piTxtDx));
end;

function TpgTextSpan.GetDy: TpgVLengthListProp;
begin
  Result := TpgVLengthListProp(PropById(piTxtDy));
end;

function TpgTextSpan.GetText: TpgStringProp;
begin
  Result := TpgStringProp(PropById(piText));
end;

function TpgTextSpan.GetX: TpgHLengthListProp;
begin
  Result := TpgHLengthListProp(PropById(piTxtX));
end;

function TpgTextSpan.GetY: TpgVLengthListProp;
begin
  Result := TpgVLengthListProp(PropById(piTxtY));
end;

{ TpgText }

constructor TpgText.Create(AOwner: TComponent);
begin
  inherited;
  FFlags := FFlags + [efAllowElements];
end;

initialization

  // paintable
  RegisterProp(piFill, TpgPaintProp, 'fill', TpgPaintable, [pfStored, pfInherit]);
  RegisterProp(piFillRule, TpgFillRuleProp, 'fill-rule', TpgPaintable, [pfStored, pfInherit]);
  RegisterProp(piStroke, TpgPaintProp, 'stroke', TpgPaintable, [pfStored, pfInherit]);
  RegisterProp(piStrokeWidth, TpgLengthProp, 'stroke-width', TpgPaintable, [pfStored, pfInherit]);
  RegisterProp(piFontSize, TpgVLengthProp, 'font-size', TpgPaintable, [pfStored, pfInherit]);
  RegisterProp(piOpacity, TpgFloatProp, 'opacity', TpgPaintable, [pfStored, pfInherit], FloatToStr(1.0));
  RegisterProp(piFillOpacity, TpgFloatProp, 'fill-opacity', TpgPaintable, [pfStored, pfInherit], FloatToStr(1.0));
  RegisterProp(piFontFamily, TpgStringProp, 'font-family', TpgPaintable, [pfStored, pfInherit]);
//    property FontStretch: TpgFontStretchProp read GetFontStretch;
//    property FontStyle: TpgFontStyleProp read GetFontStyle;
//    property FontWeight: TpgFontWeightProp read GetFontWeight;
  RegisterProp(piLetterSpacing, TpgHLengthProp, 'letter-spacing', TpgPaintable, [pfStored, pfInherit]);
  RegisterProp(piWordSpacing, TpgHLengthProp, 'word-spacing', TpgPaintable, [pfStored, pfInherit]);
  RegisterProp(piStrokeOpacity, TpgFloatProp, 'stroke-opacity', TpgPaintable, [pfStored, pfInherit], FloatToStr(1.0));
//    property StrokeLineCap: TpgLineCapProp read GetStrokeLineCap;
//    property StrokeLineJoin: TpgLineJoinProp read GetStrokeLineJoin;
  RegisterProp(piStrokeMiterLimit, TpgFloatProp, 'stroke-miterlimit', TpgPaintable, [pfStored, pfInherit]);
  RegisterProp(piStrokeDashArray, TpgLengthListProp, 'stroke-dasharray', TpgPaintable, [pfStored, pfInherit]);
  RegisterProp(piStrokeDashOffset, TpgLengthProp, 'stroke-dashoffset', TpgPaintable, [pfStored, pfInherit]);
//    property TextAnchor: TpgTextAnchorProp read GetTextAnchor;

  // group
  RegisterProp(piTransform, TpgTransformProp, 'transform', TpgGraphic, [pfStored]);
  RegisterProp(piEditorOptions, TpgEditorOptionsProp, 'editor-options', TpgGraphic, [pfStored]);
  RegisterItem(TpgGroup, 'group');

  // viewport
  RegisterItem(TpgViewPort, 'svg');
  RegisterProp(piPreserveAspect, TpgPreserveAspectProp, 'preserveAspectRatio', TpgBaseViewPort, [pfStored]);
  RegisterProp(piMeetOrSlice, TpgMeetOrSliceProp, 'meetOrSlice', TpgBaseViewPort, [pfStored]);
  RegisterProp(piVPX, TpgHLengthProp, 'x', TpgViewPort, [pfStored]);
  RegisterProp(piVPY, TpgVLengthProp, 'y', TpgViewPort, [pfStored]);
  RegisterProp(piVPWidth, TpgHLengthProp, 'width', TpgViewPort, [pfStored]);
  RegisterProp(piVPHeight, TpgVLengthProp, 'height', TpgViewPort, [pfStored]);
  RegisterProp(piViewBox, TpgViewBoxProp, 'viewBox', TpgBaseViewPort, [pfStored]);

  RegisterItem(TpgProjectiveViewPort, 'projectiveViewPort');
  RegisterProp(piPVPPoints, TpgFloatListProp, 'points', TpgProjectiveViewPort, [pfStored]);

  // shapes

  // Rectangle
  RegisterItem(TpgRectangle, 'rect');
  RegisterProp(piRectX, TpgHLengthProp, 'x', TpgRectangle, [pfStored]);
  RegisterProp(piRectY, TpgVLengthProp, 'y', TpgRectangle, [pfStored]);
  RegisterProp(piRectWidth, TpgHLengthProp, 'width', TpgRectangle, [pfStored]);
  RegisterProp(piRectHeight, TpgVLengthProp, 'height', TpgRectangle, [pfStored]);
  RegisterProp(piRectRx, TpgHLengthProp, 'rx', TpgRectangle, [pfStored]);
  RegisterProp(piRectRy, TpgVLengthProp, 'ry', TpgRectangle, [pfStored]);

  // Circle
  RegisterItem(TpgCircle, 'circle');
  RegisterProp(piCircleCx, TpgHLengthProp, 'cx', TpgCircle, [pfStored]);
  RegisterProp(piCircleCy, TpgVLengthProp, 'cy', TpgCircle, [pfStored]);
  RegisterProp(piCircleR, TpgLengthProp, 'r', TpgCircle, [pfStored]);

  // Ellipse
  RegisterItem(TpgEllipse, 'ellipse');
  RegisterProp(piEllipseCx, TpgHLengthProp, 'cx', TpgEllipse, [pfStored]);
  RegisterProp(piEllipseCy, TpgVLengthProp, 'cy', TpgEllipse, [pfStored]);
  RegisterProp(piEllipseRx, TpgHLengthProp, 'rx', TpgEllipse, [pfStored]);
  RegisterProp(piEllipseRy, TpgVLengthProp, 'ry', TpgEllipse, [pfStored]);

  // Line
  RegisterItem(TpgLine, 'line');
  RegisterProp(piLineX1, TpgHLengthProp, 'x1', TpgLine, [pfStored]);
  RegisterProp(piLineY1, TpgVLengthProp, 'y1', TpgLine, [pfStored]);
  RegisterProp(piLineX2, TpgHLengthProp, 'x2', TpgLine, [pfStored]);
  RegisterProp(piLineY2, TpgVLengthProp, 'y2', TpgLine, [pfStored]);

  // PolyLine, polygon
  RegisterItem(TpgPolyLineShape, 'polyline');
  RegisterItem(TpgPolygonShape, 'polygon');
  RegisterProp(piPoints, TpgFloatListProp, 'points', TpgPolyLineShape, [pfStored]);

  // PathShape
  RegisterItem(TpgPathShape, 'path');
  RegisterProp(piPath, TpgPathProp, 'd', TpgPathShape, [pfStored]);


  // resource
  RegisterItem(TpgResource, 'resource');
  RegisterProp(piData, TpgBinaryProp, 'data', TpgResource, [pfStored]);
  RegisterProp(piURI, TpgStringProp, 'xlink:href', TpgResource, [pfStored]);
  RegisterProp(piMimeType, TpgStringProp, 'mime-type', TpgResource, [pfStored]);

  // imageview
  RegisterItem(TpgImageResource, 'imageResource');
  RegisterItem(TpgImageView, 'imageView');
  RegisterProp(piImage, TpgImageProp, 'image', TpgImageView, [pfStored]);

  // text
  RegisterItem(TpgText, 'text');
  RegisterItem(TpgTextSpan, 'tspan');

  RegisterProp(piTxtX, TpgHLengthListProp, 'x', TpgTextSpan, [pfStored]);
  RegisterProp(piTxtY, TpgVLengthListProp, 'y', TpgTextSpan, [pfStored]);
  RegisterProp(piTxtDx, TpgHLengthListProp, 'dx', TpgTextSpan, [pfStored]);
  RegisterProp(piTxtDy, TpgVLengthListProp, 'dy', TpgTextSpan, [pfStored]);
  RegisterProp(piText, TpgStringProp, 'chardata', TpgTextSpan, [pfStored]);

end.

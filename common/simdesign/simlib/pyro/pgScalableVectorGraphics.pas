{ Project: Pyro
  Module: Pyro SVG

  Description:

  - Import of SVG (Scalable Vector Graphics) into the Pyro document object model.
    Pyro's scene definition and object model is already SVG oriented.

  - SVG named colors.

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Creation Date: 09dec2006

  Modified:
  14apr2011: placed private FParser in class TpgSvgImport
  19may2011: string > Utf8String

  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgScalableVectorGraphics;

interface

uses
  Classes, SysUtils,

  // NativeXml component
  NativeXml,

  // Simdesign general units
  sdSortedLists, 

  // Pyro component
  pgDocument, pgScene, pgParser,
  pgPath, Pyro, pgColor, pgTransform;


type

  TSvgAttributeType = (
    atEnum,
    atLength,
    atLengthList,
    atFloatList,
    atString,
    atViewBox,
    atAspect,
    atTransform,
    atPaint,
    atPath,
    atImage,
    atFloat,
    atStyle
  );

  TSvgTransformCommand = (
    tcNone,
    tcMatrix,
    tcTranslate,
    tcScale,
    tcRotate,
    tcSkewX,
    tcSkewY
  );

  TSvgNamedItem = class
  private
    FData: pointer;
    FName: Utf8String;
  public
    property Name: Utf8String read FName write FName;
    property Data: pointer read FData write FData;
  end;

  TSvgNamedList = class(TSortedList)
  private
    function GetItems(Index: integer): TSvgNamedItem;
  public
    property Items[Index: integer]: TSvgNamedItem read GetItems; default;
  end;

  // TpgSvgImport class: use method ImportScene to import an SVG graphic from
  // AStream into the AScene parameter
  TpgSvgImport = class(TsdDebugComponent)
  private
    FParser: TpgParser;
    FElementTypes: TSvgNamedList;
    FAttributeTypes: TSvgNamedList;
    function ElementCompare(Item1, Item2: TObject; Info: pointer): integer;
    function AttributeCompare(Item1, Item2: TObject; Info: pointer): integer;
  protected
    procedure PrepareLists;
    function ParseAttribute(const AName: Utf8String; ASrcPos: int64; AItem: TpgItem;
      var AttributeType: TSvgAttributeType): TpgPropInfo;
    procedure ParseItem(AScene: TpgScene; AItem: TpgItem; ANode: TXmlNode);
    procedure ParseProp(AScene: TpgScene; AItem: TpgItem; AttrType: TSvgAttributeType; APropInfo: TpgPropInfo; const AValue: Utf8String);
    procedure ParsePropLength(AProp: TpgLengthProp; const AValue: Utf8String);
    procedure ParsePropLengthList(AProp: TpgLengthListProp; const AValue: Utf8String);
    procedure ParsePropPointList(AProp: TpgFloatListProp; const AValue: Utf8String);
    procedure ParsePropTransform(AProp: TpgTransformProp; const AValue: Utf8String);
    procedure ParsePropTransformParams(const ACommand, AParams: Utf8String;
      var ACommandId: TSvgTransformCommand; var ANumbers: array of double);
    procedure ParsePropViewBox(AProp: TpgViewBoxProp; const AValue: Utf8String);
    procedure ParsePropPaint(AScene: TpgScene; AProp: TpgPaintProp; const AValue: Utf8String);
    procedure ParsePropPath(AProp: TpgPathProp; const AValue: Utf8String);
    procedure ParsePropImage(AProp: TpgImageProp; const AValue: Utf8String);
    procedure ParseAspect(AItem: TpgItem; AValue: Utf8String);
    procedure ParseStyle(AScene: TpgScene; AItem: TpgItem; AValue: Utf8String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImportScene(AScene: TpgScene; AStream: TStream);

    // Parse an SVG style length specifier, return true if successful. Result is put
    // in Units and Size.
    function pgSvgParseLength(const Value: Utf8String; var Units: TpgLengthUnits; var Size: double): boolean;

    // Parse an SVG style path description
    function pgSvgParseCommandPath(const Value: Utf8String; CommandPath: TpgCommandPath): boolean;

    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
  end;

type

  TNamedColor = record
    Name:  string;
    Color: TpgColor32;
  end;

const

  // These are color names that can be used inside SVG
  // see http://www.w3.org/TR/SVG11/types.html#ColorKeywords
  cNamedColorCount = 147;
  cNamedColors: array [0..cNamedColorCount - 1] of TNamedColor =
   ((Name: 'aliceblue';            Color: $FFF0F8FF),
    (Name: 'antiquewhite';         Color: $FFFAEBD7),
    (Name: 'aqua';                 Color: $FF00FFFF),
    (Name: 'aquamarine';           Color: $FF7FFFD4),
    (Name: 'azure';                Color: $FFF0FFFF),
    (Name: 'beige';                Color: $FFF5F5DC),
    (Name: 'bisque';               Color: $FFFFE4C4),
    (Name: 'black';                Color: $FF000000),
    (Name: 'blanchedalmond';       Color: $FFFFEBCD),
    (Name: 'blue';                 Color: $FF0000FF),
    (Name: 'blueviolet';           Color: $FF8A2BE2),
    (Name: 'brown';                Color: $FFA52A2A),
    (Name: 'burlywood';            Color: $FFDEB887),
    (Name: 'cadetblue';            Color: $FF5F9EA0),
    (Name: 'chartreuse';           Color: $FF7FFF00),
    (Name: 'chocolate';            Color: $FFD2691E),
    (Name: 'coral';                Color: $FFFF7F50),
    (Name: 'cornflowerblue';       Color: $FF6495ED),
    (Name: 'cornsilk';             Color: $FFFFF8DC),
    (Name: 'crimson';              Color: $FFDC143C),
    (Name: 'cyan';                 Color: $FF00FFFF),
    (Name: 'darkblue';             Color: $FF00008B),
    (Name: 'darkcyan';             Color: $FF008B8B),
    (Name: 'darkgoldenrod';        Color: $FFB8860B),
    (Name: 'darkgray';             Color: $FFA9A9A9),
    (Name: 'darkgreen';            Color: $FF006400),
    (Name: 'darkgrey';             Color: $FFA9A9A9),
    (Name: 'darkkhaki';            Color: $FFBDB76B),
    (Name: 'darkmagenta';          Color: $FF8B008B),
    (Name: 'darkolivegreen';       Color: $FF556B2F),
    (Name: 'darkorange';           Color: $FFFF8C00),
    (Name: 'darkorchid';           Color: $FF9932CC),
    (Name: 'darkred';              Color: $FF8B0000),
    (Name: 'darksalmon';           Color: $FFE9967A),
    (Name: 'darkseagreen';         Color: $FF8FBC8F),
    (Name: 'darkslateblue';        Color: $FF483D8B),
    (Name: 'darkslategray';        Color: $FF2F4F4F),
    (Name: 'darkslategrey';        Color: $FF2F4F4F),
    (Name: 'darkturquoise';        Color: $FF00CED1),
    (Name: 'darkviolet';           Color: $FF9400D3),
    (Name: 'deeppink';             Color: $FFFF1493),
    (Name: 'deepskyblue';          Color: $FF00BFFF),
    (Name: 'dimgray';              Color: $FF696969),
    (Name: 'dimgrey';              Color: $FF696969),
    (Name: 'dodgerblue';           Color: $FF1E90FF),
    (Name: 'firebrick';            Color: $FFB22222),
    (Name: 'floralwhite';          Color: $FFFFFAF0),
    (Name: 'forestgreen';          Color: $FF228B22),
    (Name: 'fuchsia';              Color: $FFFF00FF),
    (Name: 'gainsboro';            Color: $FFDCDCDC),
    (Name: 'ghostwhite';           Color: $FFF8F8FF),
    (Name: 'gold';                 Color: $FFFFD700),
    (Name: 'goldenrod';            Color: $FFDAA520),
    (Name: 'gray';                 Color: $FF808080),
    (Name: 'green';                Color: $FF008000),
    (Name: 'greenyellow';          Color: $FFADFF2F),
    (Name: 'grey';                 Color: $FF808080),
    (Name: 'honeydew';             Color: $FFF0FFF0),
    (Name: 'hotpink';              Color: $FFFF69B4),
    (Name: 'indianred';            Color: $FFCD5C5C),
    (Name: 'indigo';               Color: $FF4B0082),
    (Name: 'ivory';                Color: $FFFFFFF0),
    (Name: 'khaki';                Color: $FFF0E68C),
    (Name: 'lavender';             Color: $FFE6E6FA),
    (Name: 'lavenderblush';        Color: $FFFFF0F5),
    (Name: 'lawngreen';            Color: $FF7CFC00),
    (Name: 'lemonchiffon';         Color: $FFFFFACD),
    (Name: 'lightblue';            Color: $FFADD8E6),
    (Name: 'lightcoral';           Color: $FFF08080),
    (Name: 'lightcyan';            Color: $FFE0FFFF),
    (Name: 'lightgoldenrodyellow'; Color: $FFFAFAD2),
    (Name: 'lightgray';            Color: $FFD3D3D3),
    (Name: 'lightgreen';           Color: $FF90EE90),
    (Name: 'lightgrey';            Color: $FFD3D3D3),
    (Name: 'lightpink';            Color: $FFFFB6C1),
    (Name: 'lightsalmon';          Color: $FFFFA07A),
    (Name: 'lightseagreen';        Color: $FF20B2AA),
    (Name: 'lightskyblue';         Color: $FF87CEFA),
    (Name: 'lightslategray';       Color: $FF778899),
    (Name: 'lightslategrey';       Color: $FF778899),
    (Name: 'lightsteelblue';       Color: $FFB0C4DE),
    (Name: 'lightyellow';          Color: $FFFFFFE0),
    (Name: 'lime';                 Color: $FF00FF00),
    (Name: 'limegreen';            Color: $FF32CD32),
    (Name: 'linen';                Color: $FFFAF0E6),
    (Name: 'magenta';              Color: $FFFF00FF),
    (Name: 'maroon';               Color: $FF800000),
    (Name: 'mediumaquamarine';     Color: $FF66CDAA),
    (Name: 'mediumblue';           Color: $FF0000CD),
    (Name: 'mediumorchid';         Color: $FFBA55D3),
    (Name: 'mediumpurple';         Color: $FF9370DB),
    (Name: 'mediumseagreen';       Color: $FF3CB371),
    (Name: 'mediumslateblue';      Color: $FF7B68EE),
    (Name: 'mediumspringgreen';    Color: $FF00FA9A),
    (Name: 'mediumturquoise';      Color: $FF48D1CC),
    (Name: 'mediumvioletred';      Color: $FFC71585),
    (Name: 'midnightblue';         Color: $FF191970),
    (Name: 'mintcream';            Color: $FFF5FFFA),
    (Name: 'mistyrose';            Color: $FFFFE4E1),
    (Name: 'moccasin';             Color: $FFFFE4B5),
    (Name: 'navajowhite';          Color: $FFFFDEAD),
    (Name: 'navy';                 Color: $FF000080),
    (Name: 'oldlace';              Color: $FFFDF5E6),
    (Name: 'olive';                Color: $FF808000),
    (Name: 'olivedrab';            Color: $FF6B8E23),
    (Name: 'orange';               Color: $FFFFA500),
    (Name: 'orangered';            Color: $FFFF4500),
    (Name: 'orchid';               Color: $FFDA70D6),
    (Name: 'palegoldenrod';        Color: $FFEEE8AA),
    (Name: 'palegreen';            Color: $FF98FB98),
    (Name: 'paleturquoise';        Color: $FFAFEEEE),
    (Name: 'palevioletred';        Color: $FFDB7093),
    (Name: 'papayawhip';           Color: $FFFFEFD5),
    (Name: 'peachpuff';            Color: $FFFFDAB9),
    (Name: 'peru';                 Color: $FFCD853F),
    (Name: 'pink';                 Color: $FFFFC0CB),
    (Name: 'plum';                 Color: $FFDDA0DD),
    (Name: 'powderblue';           Color: $FFB0E0E6),
    (Name: 'purple';               Color: $FF800080),
    (Name: 'red';                  Color: $FFFF0000),
    (Name: 'rosybrown';            Color: $FFBC8F8F),
    (Name: 'royalblue';            Color: $FF4169E1),
    (Name: 'saddlebrown';          Color: $FF8B4513),
    (Name: 'salmon';               Color: $FFFA8072),
    (Name: 'sandybrown';           Color: $FFF4A460),
    (Name: 'seagreen';             Color: $FF2E8B57),
    (Name: 'seashell';             Color: $FFFFF5EE),
    (Name: 'sienna';               Color: $FFA0522D),
    (Name: 'silver';               Color: $FFC0C0C0),
    (Name: 'skyblue';              Color: $FF87CEEB),
    (Name: 'slateblue';            Color: $FF6A5ACD),
    (Name: 'slategray';            Color: $FF708090),
    (Name: 'slategrey';            Color: $FF708090),
    (Name: 'snow';                 Color: $FFFFFAFA),
    (Name: 'springgreen';          Color: $FF00FF7F),
    (Name: 'steelblue';            Color: $FF4682B4),
    (Name: 'tan';                  Color: $FFD2B48C),
    (Name: 'teal';                 Color: $FF008080),
    (Name: 'thistle';              Color: $FFD8BFD8),
    (Name: 'tomato';               Color: $FFFF6347),
    (Name: 'turquoise';            Color: $FF40E0D0),
    (Name: 'violet';               Color: $FFEE82EE),
    (Name: 'wheat';                Color: $FFF5DEB3),
    (Name: 'white';                Color: $FFFFFFFF),
    (Name: 'whitesmoke';           Color: $FFF5F5F5),
    (Name: 'yellow';               Color: $FFFFFF00),
    (Name: 'yellowgreen';          Color: $FF9ACD32));

// Find the RGBA value from a named color value (named colors are defined in
// the table cNamedColors). When the color is found, the function returns True.
function pgSvgFromNamedColor32(const AName: string; var AColor: TpgColor32): boolean;

// Find the named color from the RGBA color value (named colors are defined in
// the table cNamedColors). When the color is found, the function returns True.
function pgSvgToNamedColor32(const AColor: TpgColor32; var AName: string): boolean;

implementation

type

  TCommandPathAccess = class(TpgCommandPath);
  TItemAccess = class(TpgItem);

  TSvgElementRec = record
    Name: Utf8String;
    ItemClass: TpgItemClass;
  end;
  PSvgElementRec = ^TSvgElementRec;

  TSvgAttributeRec = record
    Name: Utf8String;            // Name of the attribute
    PropId: integer;         // Pyro property Id
    AType: TSvgAttributeType;
  end;
  PSvgAttributeRec = ^TSvgAttributeRec;

const

  // Table with element names in SVG and matching element classes in Pyro
  cSvgElementTypeCount = 12;
  cSvgElementTypes: array[0..cSvgElementTypeCount - 1] of TSvgElementRec =
    (
      (Name: 'svg';      ItemClass: TpgViewPort),
      (Name: 'g';        ItemClass: TpgGroup),
      (Name: 'rect';     ItemClass: TpgRectangle),
      (Name: 'circle';   ItemClass: TpgCircle),
      (Name: 'ellipse';  ItemClass: TpgEllipse),
      (Name: 'line';     ItemClass: TpgLine),
      (Name: 'polyline'; ItemClass: TpgPolyLineShape),
      (Name: 'polygon';  ItemClass: TpgPolygonShape),
      (Name: 'path';     ItemClass: TpgPathShape),
      (Name: 'text';     ItemClass: TpgText),
      (Name: 'tspan';    ItemClass: TpgTextSpan),
      (Name: 'image';    ItemClass: TpgImageView)
    );

  cSvgAttributeTypeCount = 48;
  cSvgAttributeTypes: array[0..cSvgAttributeTypeCount - 1] of TSvgAttributeRec =
    (
      // styleable
     (Name: 'id';                  PropId: piName;             AType: atString),
     (Name: 'style';               PropId: piStyle;            AType: atStyle),

      // group
     (Name: 'transform';           PropId: piTransform;        AType: atTransform),

      // viewport
     (Name: 'x';                   PropId: piVPX;              AType: atLength),
     (Name: 'y';                   PropId: piVPY;              AType: atLength),
     (Name: 'width';               PropId: piVPWidth;          AType: atLength),
     (Name: 'height';              PropId: piVPHeight;         AType: atLength),
     (Name: 'viewBox';             PropId: piViewBox;          AType: atViewBox),
     (Name: 'preserveAspectRatio'; PropId: piPreserveAspect;   AType: atAspect),

      // paintable
     (Name: 'fill';                PropId: piFill;             AType: atPaint),
     (Name: 'fill-rule';           PropId: piFillRule;         AType: atEnum),
     (Name: 'fill-opacity';        PropId: piFillOpacity;      AType: atFloat),
     (Name: 'stroke';              PropId: piStroke;           AType: atPaint),
     (Name: 'stroke-width';        PropId: piStrokeWidth;      AType: atLength),
     (Name: 'stroke-opacity';      PropId: piStrokeOpacity;    AType: atFloat),
     (Name: 'stroke-miterlimit';   PropId: piStrokeMiterLimit; AType: atFloat),
     (Name: 'stroke-dasharray';    PropId: piStrokeDashArray;  AType: atLengthList),
     (Name: 'stroke-dashoffset';   PropId: piStrokeDashOffset; AType: atLength),
     (Name: 'opacity';             PropId: piOpacity;          AType: atFloat),
     (Name: 'font-size';           PropId: piFontSize;         AType: atLength),
     (Name: 'font-family';         PropId: piFontFamily;       AType: atString),
     (Name: 'letter-spacing';      PropId: piLetterSpacing;    AType: atLengthList),
     (Name: 'word-spacing';        PropId: piWordSpacing;      AType: atLengthList),

      // rect
     (Name: 'x';                   PropId: piRectX;            AType: atLength),
     (Name: 'y';                   PropId: piRectY;            AType: atLength),
     (Name: 'rx';                  PropId: piRectRx;           AType: atLength),
     (Name: 'ry';                  PropId: piRectRy;           AType: atLength),
     (Name: 'width';               PropId: piRectWidth;        AType: atLength),
     (Name: 'height';              PropId: piRectHeight;       AType: atLength),

     // circle
     (Name: 'cx';                  PropId: piCircleCx;         AType: atLength),
     (Name: 'cy';                  PropId: piCircleCy;         AType: atLength),
     (Name: 'r';                   PropId: piCircleR;          AType: atLength),

     // ellipse
     (Name: 'cx';                  PropId: piEllipseCx;        AType: atLength),
     (Name: 'cy';                  PropId: piEllipseCy;        AType: atLength),
     (Name: 'rx';                  PropId: piEllipseRx;        AType: atLength),
     (Name: 'ry';                  PropId: piEllipseRy;        AType: atLength),

     // line
     (Name: 'x1';                  PropId: piLineX1;           AType: atLength),
     (Name: 'y1';                  PropId: piLineY1;           AType: atLength),
     (Name: 'x2';                  PropId: piLineX2;           AType: atLength),
     (Name: 'y2';                  PropId: piLineY2;           AType: atLength),

     // polyline, polygon
     (Name: 'points';              PropId: piPoints;            AType: atFloatList),

     // path
     (Name: 'd';                   PropId: piPath;              AType: atPath),

     // text
     (Name: 'x';                   PropId: piTxtX;              AType: atLengthList),
     (Name: 'y';                   PropId: piTxtY;              AType: atLengthList),
     (Name: 'dx';                  PropId: piTxtDx;             AType: atLengthList),
     (Name: 'dy';                  PropId: piTxtDy;             AType: atLengthList),
     (Name: 'chardata';            PropId: piText;              AType: atString),

     // image
     (Name: 'xlink:href';          PropId: piImage;             AType: atImage)
    );
{//    property FontStretch: TpgFontStretchProp read GetFontStretch;
//    property FontStyle: TpgFontStyleProp read GetFontStyle;
//    property FontWeight: TpgFontWeightProp read GetFontWeight;
//    property StrokeLineCap: TpgLineCapProp read GetStrokeLineCap;
//    property StrokeLineJoin: TpgLineJoinProp read GetStrokeLineJoin;}

type

  TTransformInfo = record
    Name: Utf8String;
    Cmd: TSvgTransformCommand;
  end;

const

  cSvgTransformInfoCount = 6;
  cSvgTransformInfo: array[0..cSvgTransformInfoCount - 1] of TTransformInfo =
   ((Name: 'matrix'; Cmd: tcMatrix),
    (Name: 'translate'; Cmd: tcTranslate),
    (Name: 'scale'; Cmd: tcScale),
    (Name: 'rotate'; Cmd: tcRotate),
    (Name: 'skewX'; Cmd: tcSkewX),
    (Name: 'skewY'; Cmd: tcSkewY));

type

  TAspectInfo = record
    Name: Utf8String;
    Value: TpgPreserveAspect;
  end;

const

  cSvgAspectInfoCount = 10;
  cSvgAspectInfo: array[0..cSvgAspectInfoCount - 1] of TAspectInfo =
   ( (Name: 'none'; Value: paNone),
     (Name: 'xMinYMin'; Value: paXMinYMin),
     (Name: 'xMinYMid'; Value: paXMinYMid),
     (Name: 'xMinYMax'; Value: paXMinYMax),
     (Name: 'xMidYMin'; Value: paXMidYMin),
     (Name: 'xMidYMid'; Value: paXMidYMid),
     (Name: 'xMidYMax'; Value: paXMidYMax),
     (Name: 'xMaxYMin'; Value: paXMaxYMin),
     (Name: 'xMaxYMid'; Value: paXMaxYMid),
     (Name: 'xMaxYMax'; Value: paXMaxYMax));

const

  cCommandChar: array[TpgPathCommandStyle] of char =
    (' ', 'Z', 'M', 'm', 'L', 'l', 'H', 'h', 'V', 'v', 'C', 'c', 'S', 's',
     'Q', 'q', 'T', 't', 'A', 'a');

  cCommandCount: array[TpgPathCommandStyle] of word =
    (0, 0, 2, 2, 2, 2, 1, 1, 1, 1, 6, 6, 4, 4,
     4, 4, 2, 2, 7, 7);

function TpgSvgImport.pgSvgParseLength(const Value: Utf8String; var Units: TpgLengthUnits; var Size: double): boolean;
begin
  Result := FParser.pgParseLength(Value, Units, Size);
end;

function pgSvgGetUriFragment(ARef: Utf8String): Utf8String;
begin
 Result := '';
 if length(ARef) = 0 then
   exit;
 if ARef[1] = '#' then
   Result := copy(ARef, 2, length(ARef));
end;

function TpgSvgImport.pgSvgParseCommandPath(const Value: Utf8String; CommandPath: TpgCommandPath): boolean;
var
  Pos, Count: integer;
  Command: TpgPathCommandStyle;
  Numbers: array[0..6] of double;

  // local
  procedure PerformCommand;
  begin
    TCommandPathAccess(CommandPath).AddCommand(Command);
    TCommandPathAccess(CommandPath).AddValues(Count, Numbers);
    Count := 0;
  end;

// main
begin
  Result := True;
  CommandPath.Clear;
  Pos := 1;
  Count := 0;
  Command := pcUnknown;
  while Pos <= length(Value) do
  begin
    case Value[Pos] of
    'Z',
    'z': Command := pcClosePath;
    'M': Command := pcMoveToAbs;
    'm': Command := pcMoveToRel;
    'L': Command := pcLineToAbs;
    'l': Command := pcLineToRel;
    'H': Command := pcLineToHorAbs;
    'h': Command := pcLineToHorRel;
    'V': Command := pcLineToVerAbs;
    'v': Command := pcLineToVerRel;
    'C': Command := pcCurveToCubicAbs;
    'c': Command := pcCurveToCubicRel;
    'S': Command := pcCurveToCubicSmoothAbs;
    's': Command := pcCurveToCubicSmoothRel;
    'Q': Command := pcCurveToQuadraticAbs;
    'q': Command := pcCurveToQuadraticRel;
    'T': Command := pcCurveToQuadraticSmoothAbs;
    't': Command := pcCurveToQuadraticSmoothRel;
    'A': Command := pcArcToAbs;
    'a': Command := pcArcToRel;
    '0'..'9', '+', '-', '.':
      begin
        if cCommandCount[Command] = 0 then
        begin
          Result := False;
          exit;
        end;
        if cCommandCount[Command] = Count then
          PerformCommand;
        Numbers[Count] := FParser.pgParseFloat(Value, Pos);
        dec(Pos);
        inc(Count);
        if cCommandCount[Command] = Count then
          PerformCommand;
      end;
    ' ', ',', #9, #10, #13:; // do nothing
    else
      Result := False;
      exit;
    end;//case
    
    if (Command <> pcUnknown) and (cCommandCount[Command] = Count) then
    begin
      PerformCommand;
      Command := pcUnknown;
    end;
    inc(Pos);
  end;
end;

{ TSvgNamedList }

function TSvgNamedList.GetItems(Index: integer): TSvgNamedItem;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

{ TpgSvgImport }

function TpgSvgImport.AttributeCompare(Item1, Item2: TObject; Info: pointer): integer;
begin
  Result := AnsiCompareText(TSvgNamedItem(Item1).Name, TSvgNamedItem(Item2).Name);
end;

constructor TpgSvgImport.Create;
begin
  inherited Create(AOwner);
  FParser := TpgParser.CreateDebug(Self);
end;

destructor TpgSvgImport.Destroy;
begin
  FreeAndNil(FParser);
  FreeAndNil(FElementTypes);
  FreeAndNil(FAttributeTypes);
  inherited;
end;

function TpgSvgImport.ElementCompare(Item1, Item2: TObject; Info: pointer): integer;
begin
  Result := AnsiCompareText(TSvgNamedItem(Item1).Name, TSvgNamedItem(Item2).Name);
end;

procedure TpgSvgImport.ImportScene(AScene: TpgScene; AStream: TStream);
var
  Xml: TNativeXml;
  Res: integer;
begin
  AScene.Clear;
  AScene.BeginUpdate;
  if not assigned(FElementTypes) then
    PrepareLists;

  Xml := TNativeXml.Create(Self);
  try
    // load from stream
    Xml.LoadFromStream(AStream);

    // canonicalize
    Res := Xml.Canonicalize;
    DoDebugOut(Self, wsInfo, format('%d entities expanded', [Res]));

    {// test canonicalization
    Xml.XmlFormat := xfReadable;
    Xml.SaveToFile('C:\temp\canonical.xml');}

    if not assigned(Xml.Root) or (Xml.Root.Name <> 'svg') then
    begin
      DoDebugOut(Self, wsFail, sSVGRootExpected);
      exit;
    end;

    // SVG defaults
    AScene.ViewPort.Fill.AsColor32 := clBlack32;
    AScene.ViewPort.StrokeWidth.FloatValue := 1;
    AScene.ViewPort.FontSize.FloatValue := 12;

    // temporary defaults.. will be updated if found in the xml
    AScene.ViewPort.Width.FloatValue := 800;
    AScene.ViewPort.Height.FloatValue := 600;

    ParseItem(AScene, AScene.ViewPort, Xml.Root);

  finally
    Xml.Free;
  end;
  AScene.EndUpdate;
end;

procedure TpgSvgImport.ParseAspect(AItem: TpgItem; AValue: Utf8String);
var
  i: integer;
  Aspect, MeetOrSlice: Utf8String;
begin
  if not (AItem is TpgViewPort) then
    exit;
  Aspect := BreakString(AValue, ' ', MeetOrSlice, True, False);
  for i := 0 to cSvgAspectInfoCount - 1 do
    if cSvgAspectInfo[i].Name = ASpect then
    begin
      TpgViewPort(AItem).PreserveAspect.IntValue := cSvgAspectInfo[i].Value;
      break;
    end;
  if length(MeetOrSlice) = 0 then
    MeetOrSlice := Aspect;

  if MeetOrSlice = 'meet' then
    TpgViewPort(AItem).MeetOrSlice.IntValue := msMeet
  else if MeetOrSlice = 'slice' then
    TpgViewPort(AItem).MeetOrSlice.IntValue := msSlice;
end;

function TpgSvgImport.ParseAttribute(const AName: Utf8String; ASrcPos: int64; AItem: TpgItem;
  var AttributeType: TSvgAttributeType): TpgPropInfo;
var
  i, Index, Count: integer;
  NamedItem: TSvgNamedItem;
  Attr: PSvgAttributeRec;
  Found: boolean;
  ItemName: Utf8String;
begin
  NamedItem := TSvgNamedItem.Create;
  NamedItem.Name := AName;
  FAttributeTypes.FindMultiple(NamedItem, Index, Count);
  NamedItem.Free;
  // Use the attribute that our element descends from
  Found := False;
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    Attr := FAttributeTypes[i + Index].Data;
    AttributeType := Attr.AType;
    Result := GetPropInfo(Attr.PropId);
    if not assigned(Result) then
      continue;
    if AItem is Result.MinItemClass then
    begin
      Found := True;
      DoDebugOut(Self, wsInfo, Format('found property "%s" for class %s at %d', [AName, AItem.ClassName, ASrcPos]));
      break;
    end;
  end;
  if not Found then
  begin
    Result := nil;
    if AItem is TpgItem then
      ItemName := AItem.ClassName
    else
      ItemName := 'null';
    DoDebugOut(Self, wsWarn, Format('Unknown property "%s" for class %s at %d', [AName, ItemName, ASrcPos]))
  end;
end;

procedure TpgSvgImport.ParseItem(AScene: TpgScene; AItem: TpgItem; ANode: TXmlNode);
var
  i, Index: integer;
  SvgNamedItem: TSvgNamedItem;
  ElementRec: PSvgElementRec;
  PropInfo: TpgPropInfo;
  SubItem: TpgItem;
  AttType: TSvgAttributeType;
  Found: boolean;
  CharData: Utf8String;
begin
  // Parse properties
  for i := 0 to ANode.AttributeCount - 1 do
  begin
    PropInfo := ParseAttribute(ANode.AttributeName[i], ANode.Attributes[i].SourcePos,
      AItem, AttType);
    if assigned(PropInfo) then
      ParseProp(AScene, AItem, AttType, PropInfo, ANode.AttributeValue[i])
  end;

  // Parse chardata
  CharData := trim(ANode.Value);
  if length(CharData) > 0 then
  begin
    PropInfo := ParseAttribute('chardata', ANode.SourcePos, AItem, AttType);
    if assigned(PropInfo) then
      ParseProp(AScene, AItem, AttType, PropInfo, CharData);
  end;

  // Parse sub-elements
  for i := 0 to ANode.NodeCount - 1 do
  begin
    if ANode.Nodes[i].ElementType <> xeElement then
      continue;

    SvgNamedItem := TSvgNamedItem.Create;
    try
      SvgNamedItem.Name := ANode.Nodes[i].Name;
      Found := FElementTypes.Find(SvgNamedItem, Index);

      if Found then
      begin
        ElementRec := FElementTypes[Index].Data;

        // Create sub item
        SubItem := AScene.NewItem(ElementRec.ItemClass, AItem);

        // Parse sub item
        DoDebugOut(Self, wsInfo, Format('parsing class "%s"', [SubItem.ClassName]));
        ParseItem(AScene, SubItem, ANode.Nodes[i]);
      end else
      begin
        DoDebugOut(Self, wsWarn, Format('unknown element "%s" at pos %d',
          [ANode.Nodes[i].Name, ANode.Nodes[i].SourcePos]));
      end;
    finally
      SvgNamedItem.Free;
    end;
  end;
end;

procedure TpgSvgImport.ParseProp(AScene: TpgScene; AItem: TpgItem; AttrType: TSvgAttributeType;
  APropInfo: TpgPropInfo; const AValue: Utf8String);
var
  Prop: TpgProp;
  MsgValue: Utf8String;
begin
  Prop := TItemAccess(AItem).PropById(APropInfo.Id);
  case AttrType of
  atString:
    TpgStringProp(Prop).StringValue := AValue;
  atFloat:
    TpgFloatProp(Prop).FloatValue := FParser.pgParseFloat(AValue);
  atLength:
    ParsePropLength(TpgLengthProp(Prop), AValue);
  atLengthList:
    ParsePropLengthList(TpgLengthListProp(Prop), AValue);
  atFloatList:
    ParsePropPointList(TpgFloatListProp(Prop), AValue);
  atTransform:
    ParsePropTransform(TpgTransformProp(Prop), AValue);
  atViewBox:
    ParsePropViewBox(TpgViewBoxProp(Prop), AValue);
  atPaint:
    ParsePropPaint(AScene, TpgPaintProp(Prop), AValue);
  atPath:
    ParsePropPath(TpgPathProp(Prop), AValue);
  atImage:
    ParsePropImage(TpgImageProp(Prop), AValue);
  atAspect:
    ParseAspect(AItem, AValue);
  atStyle:
    ParseStyle(AScene, AItem, AValue);
  else
    if length(AValue) < 20 then
      MsgValue := AValue
    else
      MsgValue := copy(AValue, 1, 20) + '...';
    DoDebugOut(Self, wsWarn, Format('Error unknown attribute type %d (%s)', [integer(AttrType), MsgValue]));
  end;
end;

procedure TpgSvgImport.ParsePropImage(AProp: TpgImageProp; const AValue: Utf8String);
begin
  AProp.LoadFromURI(AValue);
end;

procedure TpgSvgImport.ParsePropLength(AProp: TpgLengthProp; const AValue: Utf8String);
var
  Units: TpgLengthUnits;
  Size: double;
begin
  Units := luNone;
  Size := 0;
  if pgSvgParseLength(AValue, Units, Size) then
  begin
    AProp.Units := Units;
    AProp.FloatValue := Size;
  end else
  begin
    DoDebugOut(Self, wsWarn, Format('Error parsing length attribute string "%s"', [AValue]));
  end;
end;

procedure TpgSvgImport.ParsePropLengthList(AProp: TpgLengthListProp; const AValue: Utf8String);
var
  Next, Chunk: Utf8String;
  Units: TpgLengthUnits;
  Value: double;
begin
  Next := pgConditionListString(AValue);
  while length(Next) > 0 do
  begin
    Chunk := BreakString(Next, ' ', Next, True, False);
    if length(Chunk) = 0 then
      break;
    if pgSvgParseLength(Chunk, Units, Value) then
      AProp.Add(Value, Units)
    else
      DoDebugOut(Self, wsWarn, Format('error parsing length attribute string "%s"', [Chunk]));
  end;
end;

procedure TpgSvgImport.ParsePropPaint(AScene: TpgScene; AProp: TpgPaintProp; const AValue: Utf8String);
var
  Count: integer;
  Color: TpgColorARGB;
  RGB: array[0..2] of double;
  Name, S, URI: Utf8String;
  Ref: TpgItem;
begin
  FillChar(Color, SizeOf(Color), 0);
  if length(AValue) = 0 then
    exit;
  if AValue = 'none' then
  begin
    // no paint
    AProp.PaintStyle := psNone;
    exit;
  end;
  if AValue[1] = '#' then
  begin
    AProp.PaintStyle := psColor;
    S := copy(AValue, 2, length(AValue));
    if length(S) = 3 then
    begin
      Color.R := StrToInt('$' + S[1] + S[1]);
      Color.G := StrToInt('$' + S[2] + S[2]);
      Color.B := StrToInt('$' + S[3] + S[3]);
      Color.A := 255;
    end else if length(S) = 6 then
    begin
      Color.R := StrToInt('$' + copy(S, 1, 2));
      Color.G := StrToInt('$' + copy(S, 3, 2));
      Color.B := StrToInt('$' + copy(S, 5, 2));
      Color.A := 255;
    end else
      DoDebugOut(Self, wsWarn, Format('Invalid color value in paint prop (%s)', [S]));

    AProp.AsColor32 := TpgColor32(Color);
    exit;
  end;
  if pos('rgb(', AValue) = 1 then
  begin
    Count := 3;
    FParser.pgParseFloatArray(copy(AValue, 5, length(AValue) - 5), RGB, Count);
    Color.R := pgLimit(round(RGB[0]), 0, 255);
    Color.G := pgLimit(round(RGB[1]), 0, 255);
    Color.B := pgLimit(round(RGB[2]), 0, 255);
    Color.A := 255;
    AProp.PaintStyle := psColor;
    AProp.AsColor32 := TpgColor32(Color);
    exit;
  end;
  if pos('url(', AValue) = 1 then
  begin
    // Find URI string
    URI := BreakString(copy(AValue, 5, length(AValue)), ')', S, True, True);
    AProp.PaintStyle := psUnknown;
    Name := pgSvgGetUriFragment(URI);
    Ref := AScene.ItemByName(Name);
    if Ref is TpgPaintServer then
      AProp.RefItem := Ref
    else
      AProp.RefItem := nil;
    if not assigned(AProp.RefItem) then
    begin
      if length(S) > 0 then
        ParsePropPaint(AScene, AProp, S)
      else
        DoDebugOut(Self, wsWarn, Format('Invalid reference in paint prop (%s)', [S]));
    end;
    exit;
  end;
  if AValue = 'currentColor' then
  begin
    // to do: reference to current color
    exit;
  end;
  // named color?
  if pgSvgFromNamedColor32(AValue, TpgColor32(Color)) then
  begin
    AProp.PaintStyle := psColor;
    AProp.AsColor32 := TpgColor32(Color);
    exit;
  end;
  // still here?
  DoDebugOut(Self, wsWarn, Format('Error parsing paint attribute string "%s"', [AValue]));
end;

procedure TpgSvgImport.ParsePropPath(AProp: TpgPathProp; const AValue: Utf8String);
var
  P: TpgCommandPath;
begin
  P := TpgCommandPath.Create;
  if pgSvgParseCommandPath(AValue, P) then
    AProp.PathValue := P
  else
  begin
    DoDebugOut(Self, wsWarn, 'Error in path parser');
    P.Free;
  end;
end;

procedure TpgSvgImport.ParsePropPointList(AProp: TpgFloatListProp; const AValue: Utf8String);
var
  Next, Chunk: Utf8String;
  Value: double;
begin
  Next := pgConditionListString(AValue);
  while length(Next) > 0 do
  begin
    Chunk := BreakString(Next, ' ', Next, True, False);
    if length(Chunk) = 0 then
      break;
    Value := FParser.pgParseFloat(Chunk);
    AProp.Add(Value);
  end;
end;

procedure TpgSvgImport.ParsePropTransform(AProp: TpgTransformProp; const AValue: Utf8String);
var
  Transform, Params, Next: Utf8String;
  Numbers: array[0..5] of double;
  Command: TSvgTransformCommand;
  T: TpgAffineTransform;
begin
  Next := AValue;
  T := TpgAffineTransform.Create;
  // Parse the list of transforms
  repeat
    // get transform type
    Transform := BreakString(Next, '(', Next, True, True);
    // do we have anything?
    if length(Transform) = 0 then
      break;
    // get parameters
    Params := BreakString(Next, ')', Next, True, True);

    // parse command and parameters
    ParsePropTransformParams(Transform, Params, Command, Numbers);

    // remove comma
    Next := Trim(Next);
    if (length(Next) > 0) and (Next[1] = ',') then
      Next := trim(copy(Next, 2, length(Next)));

    case Command of
    tcMatrix:
      T.MultiplyMatrix(
        Numbers[0], Numbers[1], Numbers[2],
        Numbers[3], Numbers[4], Numbers[5]);
    tcTranslate:
      T.Translate(Numbers[0], Numbers[1]);
    tcScale:
      T.Scale(Numbers[0], Numbers[1]);
    tcRotate:
      T.Rotate(Numbers[0], Numbers[1], Numbers[2]);
    tcSkewX:
      T.SkewX(Numbers[0]);
    tcSkewY:
      T.SkewY(Numbers[0]);
    else
      DoDebugOut(Self, wsWarn, Format('Unrecognised transform %s(%s)', [Transform, Params]));
      T.Free;
      exit;
    end;//case

  until False;
  // The property becomes owner, we don't have to free T
  AProp.TransformValue := T;
end;

procedure TpgSvgImport.ParsePropTransformParams(const ACommand, AParams: Utf8String;
  var ACommandId: TSvgTransformCommand; var ANumbers: array of double);
var
  i, Count: integer;
begin
  Count := 6;
  ACommandId := tcNone;
  FParser.pgParseFloatArray(AParams, ANumbers, Count);
  if ACommand = 'matrix' then
  begin
    ACommandId := tcMatrix;
    if Count <> 6 then
      DoDebugOut(Self, wsWarn, 'Illegal number of arguments in matrix');
    exit;
  end;
  ACommandId := tcNone;
  for i := 0 to cSvgTransformInfoCount - 1 do
    if cSvgTransformInfo[i].Name = ACommand then
    begin
      ACommandId := cSvgTransformInfo[i].Cmd;
      break;
    end;

  // additional checks
  case ACommandId of
  tcMatrix:
    if Count <> 6 then
      DoDebugOut(Self, wsWarn, 'Illegal number of arguments in matrix');
  tcScale:
    if Count = 1 then
      ANumbers[1] := ANumbers[0];
  end;
end;

procedure TpgSvgImport.ParsePropViewBox(AProp: TpgViewBoxProp; const AValue: Utf8String);
var
  Pos: integer;
begin
  Pos := 1;
  AProp.MinX := FParser.pgParseFloat(AValue, Pos);
  SkipCommaWS(AValue, Pos);
  AProp.MinY := FParser.pgParseFloat(AValue, Pos);
  SkipCommaWS(AValue, Pos);
  AProp.Width := FParser.pgParseFloat(AValue, Pos);
  SkipCommaWS(AValue, Pos);
  AProp.Height := FParser.pgParseFloat(AValue, Pos);
end;

procedure TpgSvgImport.ParseStyle(AScene: TpgScene; AItem: TpgItem; AValue: Utf8String);
var
  NameValue: Utf8String;
  AttName, AttValue: Utf8String;
  PropInfo: TpgPropInfo;
  AttType: TSvgAttributeType;
begin
  repeat
    NameValue := BreakString(AValue, ';', AValue, True, False);
    if length(NameValue) > 0 then
    begin
      // Split the attribute element
      AttName := BreakString(NameValue, ':', AttValue, True, True);
      if (length(AttName) > 0) and (length(AttValue) > 0) then
      begin
        PropInfo := ParseAttribute(AttName, 0 {todo: where?}, AItem, AttType);
        if assigned(PropInfo) then
          ParseProp(AScene, AItem, AttType, PropInfo, AttValue)
      end;
    end;
  until length(AValue) = 0;
end;

procedure TpgSvgImport.PrepareLists;
var
  i: integer;
  Item: TSvgNamedItem;
begin
  // Prepare element type list
  FElementTypes := TSvgNamedList.Create;
  FElementTypes.OnCompare := ElementCompare;
  for i := 0 to cSvgElementTypeCount - 1 do
  begin
    Item := TSvgNamedItem.Create;
    Item.Name := cSvgElementTypes[i].Name;
    Item.Data := @cSvgElementTypes[i];
    FElementTypes.Add(Item);
  end;
  // Prepare attribute type list
  FAttributeTypes := TSvgNamedList.Create;
  FAttributeTypes.OnCompare := AttributeCompare;
  for i := 0 to cSvgAttributeTypeCount - 1 do
  begin
    Item := TSvgNamedItem.Create;
    Item.Name := cSvgAttributeTypes[i].Name;
    Item.Data := @cSvgAttributeTypes[i];
    FAttributeTypes.Add(Item);
  end;
end;

function pgSvgFromNamedColor32(const AName: string; var AColor: TpgColor32): boolean;
var
  i: integer;
begin
  // Scan through list. To do: we can optimize this by using binary search
  Result := False;
  for i := 0 to cNamedColorCount - 1 do
    if AnsiCompareText(cNamedColors[i].Name, AName) = 0 then begin
      Result := True;
      AColor := cNamedColors[i].Color;
      break;
    end;
end;

function pgSvgToNamedColor32(const AColor: TpgColor32; var AName: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to cNamedColorCount - 1 do
    if cNamedColors[i].Color = AColor then begin
      Result := True;
      AName := cNamedColors[i].Name;
      break;
    end;
end;

end.

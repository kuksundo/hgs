{ Project: Pyro
  Module: Pyro Core

  Description:

  Collection of types, constants, global functions and global variables that do
  not need other units/classes used in pyro engine.

  This unit only depends on unit SysUtils (Delphi, FPC) and the
  lowlevel unit sdDebug (for debugging and compatibility for lower versions of
  Delphi, eg D5).

  This unit has an initialization section:
    // MMX Detection
    glMMXActive := HasMMX;
    // Default to AA precision 4 (256 levels)
    pgSetAntiAliasing(4);

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit Pyro;

{$i simdesign.inc}

interface

uses
  NativeXml, SysUtils, sdDebug;

const

  // Version number changes with updates. See "versions.txt" for a list of
  // updated features.
  cPyroVersion = '1.11';

type

  TpgMessageEvent = procedure(Sender: TObject; const AMessage: Utf8String) of object;
  
  TDynIntArray = array of integer;
  TDynFloatArray = array of double;

  // compatibility to platforms
  TpgRect = packed record
    Left, Top, Right, Bottom: Integer
  end;
  PpgRect = ^TpgRect;

{ general }

  // Generic 8bpc, 4chan color
  TpgColor32 = longword;

  // ARGB 8bpc color, layed out in mem as BGRA
  TpgColorARGB = packed record
    B, G, R, A: byte;
  end;
  PpgColor32 = ^TpgColor32;
  PpgColorARGB = ^TpgColorARGB;
  TpgColor32Array = array[0..0] of TpgColor32;
  PpgColor32Array = ^TpgColor32Array;

  TpgColorChannels = (
    cs1Ch,  // e.g. Y
    cs2Ch,  // e.g. AY
    cs3Ch,  // e.g. RGB, CMY
    cs4Ch   // e.g. ARGB, ACMY, CMYK
  );

  TpgBitsPerChannel = (
    bpc8bits,         // 8 bits (1 byte) per channel
    bpc16bits         // 16 bits (2 bytes) per channel
  );

  TpgAlphaMode = (
    amOriginal,       // Color channels contain original color
    amDropAlpha,      // Do not preserve alpha
    amPremultiplied   // Color channels contain color premultiplied with alpha
  );

  TpgEdgeMode = (
    emStandard,       // Standard alpha-blending
    emTouching        // Using cover array to verify coverage near touching edges
  );

  TpgColorModel = (
    cmAdditive,       // Additive model (e.g. RGB)
    cmSubstractive    // Substractive model (e.g. CMY)
  );

  TpgPaintStyle = (
    psNone,         // No fill (overrides inherited)
    psColor,        // The color as in Color, as RGBA
    psBitmap,       // Reference to a bitmap to use as paint
    psGradient,     // Reference to a gradient to use as paint
    psUnknown       // Unknown reference to another element specifying paint
  );

  TpgFloat = single; // single-precision floating-point number
  PpgFloat = ^TpgFloat;
  TpgPoint = packed record
    X, Y: TpgFloat;
  end;
  PpgPoint = ^TpgPoint;
  TpgSize = TpgPoint;

  TpgPointArray = array[0..MaxInt div SizeOf(TpgPoint) - 1] of TpgPoint;
  PpgPointArray = ^TpgPointArray;

  TpgBox = packed record
    case integer of
    0: (Lft, Top, Rgt, Btm: TpgFloat);
    1: (Left, _Top, Right, Bottom: TpgFloat);
  end;
  PpgBox = ^TpgBox;

  TpgFixed = integer;

  // fixed point
  TpgPointF = packed record
    X, Y: TpgFixed;
  end;
  PpgPointF = ^TpgPointF;

  TpgPointFArray = array[0..MaxInt div SizeOf(TpgPointF) - 1] of TpgPointF;
  PpgPointFArray = ^TpgPointFArray;

  TpgArrayOfPointF = array of TpgPointF;
  TpgArrayOfArrayOfPointF = array of TpgArrayOfPointF;

  // integer point
  TpgiPoint = packed record
    X: integer;
    Y: integer;
  end;
  PpgiPoint = ^TpgiPoint;

  TpgBoxF = packed record
    Lft, Top, Rgt, Btm: TpgFixed;
  end;

{ for pgGeometry }

  // Cubic bezier
  TpgCubicBezierR = packed record
    case Integer of
    0: (P1, C1, C2, P2: TpgPoint);
    1: (P: array[0..3] of TpgPoint);
  end;

  // Quadratic bezier
  TpgQuadBezierR = packed record
    case Integer of
    0: (P1, Q, P2: TpgPoint);
    1: (P: array[0..2] of TpgPoint);
  end;

  // Ellipse
  TpgEllipseR = packed record
    C: TpgPoint;           // center point
    Ra, Rb: double;        // length of a and b axes (radii)
    CosT, SinT: double;    // Rotation of ellipse around Theta (expressed as cos/sin)
  end;

{ for pgVirtualScrollbox }

  TpgBoxPlacement = (
    bpCenter,
    bpLeftTop
  );

{ for pgContentProvider }

  // Zoom type used in Zoom command sent to the associate
  TpgZoomType = (
    ztZoomWidth,
    ztZoomHeight,
    ztZoomExtent
  );

  TpgMouseInfo = record
    Left,
    Middle,
    Right,
    Shift,
    Ctrl,
    Alt: boolean;
    X,
    Y: integer;
  end;

  TpgScrollByEvent = procedure (var DeltaX, DeltaY: integer) of object;
  TpgSetVirtualBoundsEvent = procedure (ALeft, ATop, AWidth, AHeight: integer) of object;
  TpgZoomEvent = procedure (ZoomType: TpgZoomType) of object;

{ for pgViewer }

  TpgToolMode = (
    tmNone,
    tmDrag,
    tmSelect,
    tmTextSelect,
    tmInsert,
    tmUser
  );

  TpgZoomMode = (
    zmNone,       // No mouse zooming going on
    zmZoomIn,     // Mouseclick = zoom in
    zmZoomOut,    // Mouseclick = zoom out
    zmZoomWindow, // Mouse click+drag = zoom window
    zmZoomDrag    // Drag the view with the mouse (hand)
  );

  TpgDragOp = (
    doNone,
    doZoomWindow,
    doInsert
  );

  TpgDragInfo = record
    DragOp: TpgDragOp;
    DragStart: TpgPoint;
    DragClose: TpgPoint;
  end;
  PpgDragInfo = ^TpgDragInfo;

  TpgMouseEvent = procedure (Sender: TObject; const Mouse: TpgMouseInfo) of object;


{
  Affine matrix transformations

  TpgMatrix is defined as:

  | A C E |
  | B D F |
  | 0 0 1 |

}
  TpgMatrix = packed record
    case integer of
    0: (A, B, C, D, E, F: double);
    1: (Elements: array[0..5] of double);
  end;
  PpgMatrix = ^TpgMatrix;

  TpgMatrix3x3 = array[0..2, 0..2] of double;
  PpgMatrix3x3 = ^TpgMatrix3x3;

const

  cIdentityMatrix: TpgMatrix =
    (A: 1; B: 0; C: 0; D: 1; E: 0; F: 0);

  // TpgMatrix3x3 identity matrix
  cIdentityMatrix3x3: TpgMatrix3x3 = (
    (1, 0, 0),
    (0, 1, 0),
    (0, 0, 1));

{ for pgPath / pgPathUsingCommand / pgPathUsingRender }

const

  cDefaultCuspLimit = 0;
  cCurveRecursionLimit = 30;
  cCurveCollinearityEps = 1e-30;

type

  TpgPathPosition = record
    PathIndex: integer;  // index into the current path
    PointIndex: integer; // index into the current point
    Fraction: double;    // fraction of the length on current segment (0..1)
  end;

  TpgPathCommandStyle = (
    pcUnknown,
    pcClosePath,
    pcMoveToAbs,
    pcMoveToRel,
    pcLineToAbs,
    pcLineToRel,
    pcLineToHorAbs,
    pcLineToHorRel,
    pcLineToVerAbs,
    pcLineToVerRel,
    pcCurveToCubicAbs,
    pcCurveToCubicRel,
    pcCurveToCubicSmoothAbs,
    pcCurveToCubicSmoothRel,
    pcCurveToQuadraticAbs,
    pcCurveToQuadraticRel,
    pcCurveToQuadraticSmoothAbs,
    pcCurveToQuadraticSmoothRel,
    pcArcToAbs,
    pcArcToRel
  );

  TpgCommandPathItemRec = packed record
    Command: TpgPathCommandStyle;
    Index: word;
  end;
  PpgCommandPathItemRec = ^TpgCommandPathItemRec;

type

  TDoubleArray = array[0..MaxInt div SizeOf(double) - 1] of double;
  PDoubleArray = ^TDoubleArray;

function pgBoolToInt(ABool: boolean): integer;

{ for pgColor }

const

  // Some predefined color constants
  clBlack32               = TpgColor32($FF000000);
  clDimGray32             = TpgColor32($FF3F3F3F);
  clGray32                = TpgColor32($FF7F7F7F);
  clLightGray32           = TpgColor32($FFBFBFBF);
  clWhite32               = TpgColor32($FFFFFFFF);
  clMaroon32              = TpgColor32($FF7F0000);
  clGreen32               = TpgColor32($FF007F00);
  clOlive32               = TpgColor32($FF7F7F00);
  clNavy32                = TpgColor32($FF00007F);
  clPurple32              = TpgColor32($FF7F007F);
  clTeal32                = TpgColor32($FF007F7F);
  clRed32                 = TpgColor32($FFFF0000);
  clLime32                = TpgColor32($FF00FF00);
  clYellow32              = TpgColor32($FFFFFF00);
  clBlue32                = TpgColor32($FF0000FF);
  clFuchsia32             = TpgColor32($FFFF00FF);
  clAqua32                = TpgColor32($FF00FFFF);

  // Some semi-transparent color constants
  clTrWhite32             = TpgColor32($7F7F7F7F);
  clTrBlack32             = TpgColor32($7F000000);
  clTrRed32               = TpgColor32($7F7F0000);
  clTrGreen32             = TpgColor32($7F007F00);
  clTrBlue32              = TpgColor32($7F00007F);

type

  // General color definition
  TpgColor = array[0..7] of byte;
  PpgColor = ^TpgColor;

  // Colorspace and format information
  TpgColorInfo = record
    Channels: integer;                 // number of channels
    BitsPerChannel: TpgBitsPerChannel; // Number of bits per channel
    AlphaMode: TpgAlphaMode;           // Original colors/drop alpha/premultiplied
    ColorModel: TpgColorModel;         // additive/substractive
    ColorSpaceInfo: pointer;           // Pointer to exotic color space info, unused for the moment
  end;
  PpgColorInfo = ^TpgColorInfo;

const

  // some standard color spaces
  cARGB_8b_Pre: TpgColorInfo =
    (Channels: 4;
     BitsPerChannel: bpc8bits;
     AlphaMode: amPremultiplied;
     ColorModel: cmAdditive;
     ColorSpaceInfo: nil
    );

  cARGB_8b_Org: TpgColorInfo =
    (Channels: 4;
     BitsPerChannel: bpc8bits;
     AlphaMode: amOriginal;
     ColorModel: cmAdditive;
     ColorSpaceInfo: nil
    );

  cRGB_8b: TpgColorInfo =
    (Channels: 3;
     BitsPerChannel: bpc8bits;
     AlphaMode: amOriginal;
     ColorModel: cmAdditive;
     ColorSpaceInfo: nil
   );

   cY_8b: TpgColorInfo =
     (Channels: 1;
      BitsPerChannel: bpc8bits;
      AlphaMode: amOriginal;
      ColorModel: cmAdditive;
      ColorSpaceInfo: nil
    );

resourcestring

  sUnsupportedBitsPerChannel  = 'Unsupported bits per channel';
  sUnsupportedAlphaMode       = 'Unsuppored alpha mode';
  sUnsupportedColorConversion = 'Unsupported color conversion';

{ for pgMap }

resourcestring

  smpIncompatibleMapTypes = 'Incompatible map types';

{ for pgSampler }

const
  // Max oversampling size (nxn)
  cMaxOversampling = 6;

resourcestring
  sIllegalOverSamplingValue  = 'Illegal oversampling value';
  sNotImplemented            = 'This mode is not implemented';

{ for Document }

type

  // Type of change in OnBeforeChange/OnAfterChange
  TpgChangeType = (
    ctListClear,      // Complete element list was cleared
    ctListUpdate,     // Complete element list update
    ctElementAdd,     // Element with ElementId is/was added
    ctElementRemove,  // Element with ElementId is/was removed
    ctElementListAdd,    // sub element added
    ctElementListRemove, // sub element removed
    ctPropAdd,        // Prop with PropId is/was added to Element
    ctPropRemove,     // Prop with PropId is/was removed from Element
    ctPropUpdate      // Prop with PropId is/was updated in Element
  );

  TpgCartesianDirection = (
    cdUnknown,
    cdHorizontal,
    cdVertical
  );

  TpgFillRule = (
    frNonZero,
    frEvenOdd
  );

  TpgLineCap = (
    lcButt,
    lcRound,
    lcSquare
  );

  TpgLineJoin = (
    ljMiter,
    ljRound,
    ljBevel
  );

  TpgLengthUnits = (
    luNone, // No units -> pixels
    luPerc, // Percentage
    luEms,  // Relative to Em of font
    luExs,  // Relative to Ex of font
    luCm,   // Centimeters
    luMm,   // Millimeters
    luIn,   // Inches
    luPt,   // Points
    luPc    // Pc
  );

  TpgLengthUnitsInfo = record
    Name: Utf8String;
    Units: TpgLengthUnits;
  end;

const

  // observe the order and count!
  cpgLengthUnitsInfo: array[TpgLengthUnits] of TpgLengthUnitsInfo =
    ((Name: ''; Units: luNone),
     (Name: '%'; Units: luPerc),
     (Name: 'em'; Units: luEms),
     (Name: 'ex'; Units: luExs),
     (Name: 'cm'; Units: luCm),
     (Name: 'mm'; Units: luMm),
     (Name: 'in'; Units: luIn),
     (Name: 'pt'; Units: luPt),
     (Name: 'pc'; Units: luPc));
     //(Name: 'px'; Units: luNone) - not used, but checked in pgParser

type

  TpgPreserveAspect = (
    paNone, paXMidYMid, paXMinYMin, paXMidYMin, paXMaxYMin, paXMinYMid,
    paXMaxYMid, paXMinYMax, paXMidYMax, paXMaxYMax);

  TpgMeetOrSlice = (
    msUnknown,
    msMeet,
    msSlice);

  TpgStrokeJoin = (
    jtUndetermined,
    jtMiter,
    jtRound,
    jtBevel
  );

  TpgTextAnchor = (
    taStart,
    taMiddle,
    taEnd
  );

  TpgFontStyle = (
    fsNormal,
    fsItalic,
    fsOblique
  );

  TpgFontVariant = (
    fvNormal,
    fvSmallCaps
  );

  TpgFontWeight = (
    fwNormal,
    fwBold,
    fwBolder,
    fwLighter,
    fw100,
    fw200,
    fw300,
    fw400,
    fw500,
    fw600,
    fw700,
    fw800,
    fw900
  );

  TpgFontStretch = (
    fsNoStretch,
    fsWider,
    fsNarrower,
    fsUltraCondensed,
    fsExtraCondensed,
    fsCondensed,
    fsSemiCondensed,
    fsSemiExpanded,
    fsExpanded,
    fsExtraExpanded,
    fsUltraExpanded
  );

  TpgFontRenderMethod = (
    frNativeNoAA,         // windows native non-antialiased bitmap font
    frNativeAA,           // windows native antialiased bitmap font (8bit)
    frOutline,            // Outlined font (Truetype only)
    frOutlineBreakup      // Outlined font, broken up in smaller line segments (Truetype only)
  );

  TpgUsageUnits = (
    uuObjectBoundingBox,
    uuUserSpaceOnUse
  );

  // Specifies information for a device (eg. DPI.X and DPI.Y specify the resolution
  // in dots per inch)
  TpgDeviceInfo = record
    DPI: TpgSize;
  end;
  PpgDeviceInfo = ^TpgDeviceInfo;

  TpgInterpolationMethod = (
    imNearest,
    imLinear
  );

  TpgClipResult = (
    cClipLft,
    cClipRgt,
    cClipTop,
    cClipBtm
  );
  TpgClipResults = set of TpgClipResult;

  TpgRegionType = (
    rtEmpty,
    rtRectangle,
    rtPolygon,
    rtPolyPolygon,
    rtPath,
    rtBitmap
  );

  TpgRegionCombineOp = (
    rcAND,
    rcCOPY,
    rcDIFF,
    rcOR,
    rcXOR
  );

  TpgCanvasType = (
    ctPyro,  // Use Pyro lib
    ctGDI,   // Use GDI
    ctOpenGL // Use OpenGL (not implemented yet)
  );

{ from pgElement.pas }

  TpgItemFlag = (
    efStored,        // The element will be stored in storage
    efAllowElements, // The element allows sub elements to be added
    efTemporary      // The element is only temporarily part of the container
  );
  TpgItemFlags = set of TpgItemFlag;

  TpgPropInfoFlag = (
    pfInherit, // Element can inherit this property from parent
    pfStyle,   // Property can be part of a style element
    pfStored   // Property is stored
  );
  TpgPropInfoFlags = set of TpgPropInfoFlag;

{ from pgStorage.pas }

  TpgStorageMarker = (
    smFileVersion,
    smElementStart,
    smElementClose,
    smPropStart,
    smPropClose,
    smIntValue,
    smFloatValue,
    smStringValue,
    smIntListValue,
    smFloatListValue,
    smEndOfFile
  );

  TpgStorageDigits = (
    sdValueIsZero,
    sdValueIsOne,
    sdPositive8bits,
    sdPositive16bits,
    sdPositive32bits,
    sdNegative8bits,
    sdNegative16bits,
    sdNegative32bits,
    sdSingle,
    sdDouble
  );

resourcestring

  sUnregisteredElement = 'Warning: unregistered element class "%s" encountered, skipped.';
  sUnregisteredProp    = 'Warning: unregistered property class "%s" encountered, skipped.';
  sUnknownProp         = 'Warning: unknown property with class "%s" id %d encountered, skipped.';
  sUnexpectedMarker    = 'Warning: unexpected marker "%s" at %s';
  sUnknownElement      = 'Warning: unknown element with class "%s" id %d encountered, skipped.';
  sFatalReadError      = 'Fatal read error';
  sUnexpectedEndOfFile = 'Error: unexpected end of file';
  sUnexpectedStructErr = 'unexpected structural error';
  sParentIsRequired    = 'parent is required for new element';

  sUpdateBeginEndMismatch = 'Update begin/end mismatch error';


const
  cMarkerNames: array[TpgStorageMarker] of Utf8String =
   ('FileVersion',
    'ElementStart',
    'ElementClose',
    'PropStart',
    'PropClose',
    'IntValue',
    'FloatValue',
    'StringValue',
    'IntListValue',
    'FloatListValue',
    'EndOfFile'
   );

{ from pgElement.pas }

resourcestring

  sDuplicateElementRegistered  = 'Duplicate element with class %s registered';
  sDuplicatePropertyRegistered = 'Duplicate property with id %d registered';
  sUknownPropertyType          = 'Unknown property type with id %d';
  sNoSuchPropertyForClass      = 'No such property for class %s';
  sDuplicateElementAdded       = 'Element with duplicate Id added';
  sInternalThreadException     = 'Internal thread exception';
  sWrongClassForCopyOperation  = 'Wrong class for copy operation';
  sSubElementsNotAllowed       = 'Sub-elements not allowed in this element';
  sIllegalElementIndex         = 'Illegal element index';

{ from pgSizeable.pas }

resourcestring
  sInvalidUnitSpec            = 'Invalid unit specification';
  sCannotResolveViewPortUnits = 'Cannot resolve viewport units';
  sIllegalUseDirectAdd        = 'Illegal use, use direct Add';

{ from pgGraphic.pas, pgShape.pas, pgImage,.pas }

resourcestring

  sUnregisteredTransform  = 'Unregistered transform when writing';
  sIllegalPropertyValue   = 'Illegal property value';
  sUnknownRasterImageType = 'Unknown raster image type';
  sPointListIncorrect     = 'Pointlist incorrect in transform';

{ from pgScalableVectorGraphics }

resourcestring

  sSVGRootExpected = 'SVG root node expected';

{ from pgTransform.pas }

resourcestring

  sCannotConcatTransform = 'Cannot concat transform';
  sCannotInvertTransform = 'Cannot invert transform';
  sDuplicateTransformRegistered = 'Duplicate transform registered';

{ from pgCanvas.pas }

resourcestring

  sNonMatchingPop = 'Non-matching pop in canvas';

type

  TpgEditorOption = (
    eoDenySelect,     // Do not allow selection in editor
    eoDenyEdit,       // Do not allow editing in editor (e.g. change text)
    eoDenyMove,       // Do not allow moving in editor
    eoDenyResize,     // Do not allow resizing in editor
    eoDenyTransform,  // Do not allow transforming in editor
    eoPreserveAspect  // Should preserve aspect ratio when resizing
  );
  TpgEditorOptions = set of TpgEditorOption;

{ from pgScene.pas }

const

  cChangeTypeNames: array[TpgChangeType] of Utf8String =
    ('ListClear',
     'ListUpdate',
     'ElementAdd',
     'ElementRemove',
     'ElementListAdd',
     'ElementListRemove',
     'PropAdd',
     'PropRemove',
     'PropUpdate');

{ constants }

const

  // Property id constants, must be unique and > 0
  piElementList       =   1; // ElementList property
  piClone             =   2; // Clone property (Ref)
  piStyle             =   3; // Style property (Ref)
  piName              =   4; // Name property (String)
  piID                =   5; // ID property (String)

  // positioning properties
  piRectX             =  10;
  piRectY             =  11;
  piRectWidth         =  12;
  piRectHeight        =  13;
  piRectRx            =  14;
  piRectRy            =  15;
  piCircleCx          =  16;
  piCircleCy          =  17;
  piCircleR           =  18;
  piEllipseCx         =  19;
  piEllipseCy         =  20;
  piEllipseRx         =  21;
  piEllipseRy         =  22;
  piLineX1            =  23;
  piLineY1            =  24;
  piLineX2            =  25;
  piLineY2            =  26;

  piTransform         =  30;

  piViewBox           =  40;
  piVPX               =  41;
  piVPY               =  42;
  piVPWidth           =  43;
  piVPHeight          =  44;
  piPreserveAspect    =  45;
  piMeetOrSlice       =  46;

  // paintable properties
  piFill              =  60;
  piFillOpacity       =  61;
  piFillRule          =  62;
  piStroke            =  63;
  piStrokeWidth       =  64;
  piStrokeDashArray   =  65;
  piStrokeDashOffset  =  66;
  piStrokeMiterLimit  =  67;
  piStrokeOpacity     =  68;
  piOpacity           =  70;

  piFontSize          =  80;
  piFontFamily        =  81;
  piLetterSpacing     =  85;
  piWordSpacing       =  86;

  piPoints            =  90; // polyline, polygon
  piPath              =  91; // path shape

  piImage             =  95;

  piURI               = 100;
  piMimeType          = 101;
  piData              = 102;

  piText              = 110;
  piTxtX              = 111;
  piTxtY              = 112;
  piTxtDx             = 113;
  piTxtDy             = 114;

  piPVPPoints         = 120;

  piEditorOptions     = 150;

  // transform types
  tiAffine            = 01;
  tiProjective        = 02;
  tiCurved            = 03;

const

  cNullPoint: TpgPoint = (X: 0; Y: 0);

  cEmptyBox:  TpgBox  = (Lft: 0; Top: 0; Rgt:  0; Btm:  0);
  cEmptyBoxF: TpgBoxF = (Lft: 0; Top: 0; Rgt: -1; Btm: -1);

  cDefaultEps = 1E-10;
  cMaxSingle  = 1E30;
  cMaxInteger = 2147483647;

  cFirstLayerGuid: TGUID = (D1: 1; D2: 0; D3: 0; D4: (0, 0, 0, 0, 0, 0, 0, 0));

{ from former pgDefaults.pas }

const

  cDefaultAffineCurb = 7;


{ global functions }

function pgDebugMessageToString(AWarnStyle: TsdWarnStyle; ASrcPos: int64; const AMessage: Utf8String): Utf8String;

{ from former unit pgAntiAliasing}

{ AntiAliasing functions for the Pyro renderer.

  The anti-aliasing depends on cFixedBits, the number of bits for fixed-precision
  numbers used in the rasterizer.

  Set the AA level with function pgSetAntiAliasing (passing number of bits).

  Note on AA > 256: For very high end apps it makes sense to choose AFixedBits
  higher than 4. With AFixedBits = 4, only lines that are 1/16 of a pixel wide
  are actually detected. So if you would try to render a line that is just less
  than 1/16 pixel, it won't show, while the area on a pixel would still amount
  to just smaller than 16/255.

  To be very precise, put cFixedBits on 8. This way, lines up to 1/256 of a pixel
  will get detected and rendered.

  Author: Nils Haeck (n.haeck@simdesign.nl)<p>
  Copyright (c) 2006 - 2011 SimDesign BV
}

{ Set the AntiAliasing level.
   AFixedBits = 0:   No Anti-Aliasing (1 level)
   AFixedBits = 1:    4 Anti-Aliasing levels
   AFixedBits = 2:   16 Anti-Aliasing levels
   AFixedBits = 3:   64 Anti-Aliasing levels
   AFixedBits = 4:  256 Anti-Aliasing levels
   AFixedBits = 5: 1024 Anti-Aliasing levels
   AFixedBits = 6: 4096 Anti-Aliasing levels
}
procedure pgSetAntiAliasing(AFixedBits: integer);

resourcestring
  styInvalidAntiAliasingLevel = 'Invalid Anti-Aliasing Level';

{ from pgBlend }

resourcestring

  sBitsPerChannelOpNotImplemented = 'Operation not implemented for selected bits per channel';
  sChannelsOpNotImplemented       = 'Operation not implemented for this number of channels';
  sSubstractiveOpNotImplemented   = 'Operation not implemented for substractive color model';
  sAlphaModeOpNotImplemented      = 'Operation not implemented for this alpha mode';
  sUnknownRenderMode              = 'Unknown render mode: no operation available';
  sColorOpNotImplemented          = 'Color operation not implemented';

{ from pgPath }

resourcestring

  sCannotMoveToInsidePath       = 'MoveTo command not allowed inside path';
  sExpectMoveToFirst            = 'Expect MoveTo command first';
  sCannotClosePath              = 'Cannot close path (not enough points)';
  sIncrementCannotBeNegative    = 'Increment cannot be negative';
  sPathConversionNotImplemented = 'Path conversion not implemented';
  //sNotImplemented               = 'Not Implemented';

{ from pgPolygon }

resourcestring

  sNoCurrentPathDefined = 'No current path defined';

{ functions to allow aviodance of Windows }

function pgOffsetRect(var R: TpgRect; Dx, Dy: integer): integer;
function pgIntersectRect(var Dst: TpgRect; const Src1, Src2: TpgRect): boolean;
function pgIsRectEmpty(const R: TpgRect): boolean;
function pgRect(Left, Top, Right, Bottom: Integer): TpgRect;

function pgBoxToRect(const ABox: TpgBox): TpgRect;
function pgEqualRect(const Src1, Src2: TpgRect): boolean;

{ from pgHelper:

  Collection of helper routines.
}

function pgMin(const V1, V2: integer): integer; overload;
function pgMin(const V1, V2: single): single; overload;
function pgMin(const V1, V2: double): double; overload;
function pgMin(const V1, V2: int64): int64; overload;
function pgMax(const V1, V2: integer): integer; overload;
function pgMax(const V1, V2: single): single; overload;
function pgMax(const V1, V2: double): double; overload;
function pgMax(const V1, V2: int64): int64; overload;

function pgLimit(const V, Lower, Upper: integer): integer;
function pgLimitS(const V, Lower, Upper: single): single;
function pgLimitD(const V, Lower, Upper: double): double;

function pgSign(const V: single): integer; overload;

procedure pgSwapDouble(var V1, V2: double);

function pgIntPower(const Base: Extended; const Exponent: Integer): Extended;

{ Point and box methods (single-precision) }

// Construct a point from X and Y coordinates
function pgPoint(const X, Y: single): TpgPoint;

// Construct an integer point from X and Y coordinates
function pgiPoint(const X, Y: integer): TpgiPoint;

procedure pgMovePoint(var P: TpgPoint; const Dx, Dy: single);

// Construct a bounding box from Left, Top, Right, Bottom coordinates
function pgBox(const Lft, Top, Rgt, Btm: single): TpgBox; overload;

// Construct a bounding box from two points
function pgBox(const P1, P2: TpgPoint): TpgBox; overload;

// Construct a bounding box from N points
function pgBox(P: PpgPoint; Count: integer): TpgBox; overload;

// Return the width of box B (Right - Left)
function pgWidth(const B: TpgBox): single;
// Return the height of box B (Bottom - Top)
function pgHeight(const B: TpgBox): single;

// Checks if two boxes B1 and B2 are exactly equal
function pgBoxEqual(const B1, B2: TpgBox): boolean;

// Check if two boxes B1 and B2 intersect. If they share edges, they are considered
// not to intersect.
function pgBoxIntersects(const B1, B2: TpgBox): boolean;

// Check if the box is empty (left smaller or equal to right, bottom smaller
// or equal to top)
function pgIsEmptyBox(const B: TpgBox): boolean;

// Grow the box by factor Delta, and also adjust if Right < Left etc
function pgGrowBox(const B: TpgBox; Delta: single): TpgBox;

// Returns true if the point P is inside of box B. If P is exactly on the
// border, the function returns false.
function pgPointInBox(const B: TpgBox; const P: TpgPoint): boolean;

// Update the box coordinates to encompass point APoint. Before the first check,
// set IsFirst to True.
procedure pgUpdateBox(var B: TpgBox; const APoint: TpgPoint; var IsFirst: boolean);

// Find the union (encompassing rectangle) of box B1 and B2
function pgUnionBox(const B1, B2: TpgBox): TpgBox;

// Find intersection of box B1 and B2. If B1 or B2 is empty to start with,
// an empty result will be returned
function pgIntersectBox(const B1, B2: TpgBox): TpgBox;

// Move box B by DeltaX, DeltaY
procedure pgMoveBox(var B: TpgBox; DeltaX, DeltaY: single);

// Scale box B by ScaleX, ScaleY
procedure pgScaleBox(var B: TpgBox; ScaleX, ScaleY: single);

// Copies the box coordinates (left/top, left/btm, rgt/btm, rgt/top) to
// the array pointed by with First.
procedure pgBoxToPoints(const B: TpgBox; First: PpgPoint);

// Check if two float values are equal within Eps
function pgFloatEqual(const F1, F2, Eps: double): boolean;

// Check if two points are equal within Eps
function pgPointsEqual(const P1, P2: TpgPoint; const Eps: double = cDefaultEps): boolean;

// check if two points are exactly equal
function pgPointsExactlyEqual(const P1, P2: TpgPoint): boolean;

{ Point and box methods - fixed-precision }

// Check if the box is empty
function pgBoxFIsEmpty(const B: TpgBoxF): boolean;

// Construct a bounding box from Left, Top, Right, Bottom coordinates
function pgBoxF(const Lft, Top, Rgt, Btm: TpgFixed): TpgBoxF;

// Update the box coordinates to encompass point APoint. Before the first check,
// set IsFirst to True.
procedure pgUpdateBoxF(var B: TpgBoxF; const APoint: TpgPointF; var IsFirst: boolean);

// Find intersection of two boxes B1 and B2
function pgIntersectBoxF(const B1, B2: TpgBoxF): TpgBoxF;

// Check if two fixed points are equal
function pgPointsFEqual(const P1, P2: TpgPointF): boolean;

// Convert a float point to a fixed point
function pgFixed(const F: double): TpgFixed;

// Convert a normal point to a fixed point
function pgPointF(const APoint: TpgPoint): TpgPointF; overload

// Construct a fixed point from X and Y coordinates
function pgPointF(const X, Y: TpgFixed): TpgPointF; overload;

// Convert fixed value to float value
function pgFixedToFloat(const F: TpgFixed): double;

// Fast implementation of (A * B) div $FF
function pgIntMul(A, B: integer): integer;

function pgFloor(const X: Extended): Integer;
function pgCeil(const X: Extended): Integer;

// Shift arithmetic right by 8 (which is the same as shr 8, but also works for
// negative integers)
function pgSAR8(AValue: integer): integer;

// calculate Sin and Cos of angle Theta in one call
procedure pgSinCos(const Theta: Extended; var Sin, Cos: Extended);

// arcsin
function pgArcSin(const X: Extended): Extended;

// calculate ArcTan from 2 coordinates
function pgArcTan2(const Y, X: Extended): Extended;

// calculate Tan of angle X
function pgTan(const X: Extended): Extended;

// function pgPtInRect function determines whether the specified point lies within
// the specified rectangle. A point is within a rectangle if it lies on the left or
// top side or is within all four sides. A point on the right or bottom side is
// considered outside the rectangle.
function pgPtInRect(const R: TpgRect; P: TpgiPoint): boolean;

{ from pgImageProcessing }

// taxicab distance between 2 PpgColor32 colors
function pgColorDistTaxi32(Col1, Col2: PpgColor32): integer;

// Mix col2 into col1, where Mix is given as 0..255. If Mix = 0, keep Col1, if
// mix is 255 use Col2, otherwise a linear interpolation in all channels
function pgColorBlend32(Col1, Col2: PpgColor32; Mix: byte): TpgColor32;

{ from pgColor }

// Element size in bytes for a color with AInfo
function pgColorElementSize(const AInfo: TpgColorInfo): integer;

{ lowlevel func from pgBlend }

procedure pgFillLongword(var X; Count: Integer; Value: Longword);

{ from pgCPUInfo }

function HasMMX: Boolean;

procedure EMMS;

{ global variables }

var

  // When pgSetAntiAliasing(AFixedBits) is selected from 0..4, lookup tables
  // are used.
  // When selecting a higher setting, multiplication is used per output value.
  // 0 results in NO antialiasing, and 1, 2, 3, 4 in increasing
  // levels. Level 4 is 256 anti-aliasing steps (default).
  cFixedBits: integer = 0; // = 4;

  cFixedScale: integer = 0; // = 1 shl cFixedPrecision;
  cFixedMask: integer = 0; // = cFixedBase - 1;
  cFixedBias: integer = 0; // = cFixedBase div 2 - 1;
  cAALevels: integer = 0; // = cFixedScale * cFixedScale
  cLevelsToCover: double = 0;

  // glBufferToValueTable is used in AA to find the cover for each value
  glBufferToValueTable: array of byte;

  // is MMX active?
  glMMXActive: boolean = False;

implementation

function pgDebugMessageToString(AWarnStyle: TsdWarnStyle; ASrcPos: int64; const AMessage: Utf8String): Utf8String;
begin
  Result := Format('[%s] pos %d: %s', [cWarnStyleNames[AWarnStyle], ASrcPos, AMessage]);
end;

procedure InitBufferToValueTable;
var
  i: integer;
begin
  cLevelsToCover := 255 / cAALevels;
  if cFixedBits > 4 then
  begin
    SetLength(glBufferToValueTable, 0);
    exit;
  end else
    SetLength(glBufferToValueTable, cAALevels + 1);
  for i := 0 to cAALevels do
    glBufferToValueTable[i] := round(i * cLevelsToCover);
end;

procedure pgSetAntiAliasing(AFixedBits: integer);
begin
  if (AFixedBits < 0) or (AFixedBits > 10) then
    raise Exception.Create(styInvalidAntiAliasingLevel);
  cFixedBits := AFixedBits;
  cFixedScale := 1 shl cFixedBits;
  cFixedMask := cFixedScale - 1;
  cFixedBias := cFixedScale shr 1 - 1;
  cAALevels := cFixedScale * cFixedScale;
  InitBufferToValueTable;
end;

{ win avoidance functions }

function pgOffsetRect(var R: TpgRect; Dx, Dy: integer): integer;
begin
  inc(R.Left, Dx);
  inc(R.Right, Dx);
  inc(R.Top, Dy);
  inc(R.Bottom, Dy);

  Result := -1;
end;

function pgIntersectRect(var Dst: TpgRect; const Src1, Src2: TpgRect): boolean;
begin
  Dst.Left := pgMax(Src1.Left, Src2.Left);
  Dst.Top := pgMax(Src1.Top, Src2.Top);
  Dst.Right := pgMin(Src1.Right, Src2.Right);
  Dst.Bottom := pgMin(Src1.Bottom, Src2.Bottom);

  Result := not pgIsRectEmpty(Dst);
end;

function pgIsRectEmpty(const R: TpgRect): boolean;
begin
  Result := (R.Right <= R.Left) or (R.Bottom <= R.Top);
end;

function pgRect(Left, Top, Right, Bottom: Integer): TpgRect;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

function pgBoxToRect(const ABox: TpgBox): TpgRect;
begin
  Result.Left := round(ABox.Lft - 0.5);
  Result.Top := round(ABox.Top - 0.5);
  Result.Right := round(ABox.Rgt + 0.5);
  Result.Bottom := round(ABox.Btm + 0.5);
end;

function pgEqualRect(const Src1, Src2: TpgRect): boolean;
begin
  Result :=
    (Src1.Left = Src2.Left) and
    (Src1.Top = Src2.Top) and
    (Src1.Right = Src2.Right) and
    (Src1.Bottom = Src2.Bottom);
end;

{ from pgHelper }

function pgFloor(const X: Extended): Integer;
begin
  Result := Integer(Trunc(X));
  if Frac(X) < 0 then
    Dec(Result);
end;

function pgBoolToInt(ABool: boolean): integer;
begin
  if ABool then
    Result := 1
  else
    Result := 0;
end;

function pgCeil(const X: Extended): Integer;
begin
  Result := Integer(Trunc(X));
  if Frac(X) > 0 then
    Inc(Result);
end;

function pgMin(const V1, V2: integer): integer;
begin
  if V1 < V2 then Result := V1 else Result := V2;
end;

function pgMin(const V1, V2: single): single;
begin
  if V1 < V2 then Result := V1 else Result := V2;
end;

function pgMin(const V1, V2: double): double;
begin
  if V1 < V2 then Result := V1 else Result := V2;
end;

function pgMin(const V1, V2: int64): int64;
begin
  if V1 < V2 then Result := V1 else Result := V2;
end;

function pgMax(const V1, V2: integer): integer;
begin
  if V1 > V2 then Result := V1 else Result := V2;
end;

function pgMax(const V1, V2: single): single;
begin
  if V1 > V2 then Result := V1 else Result := V2;
end;

function pgMax(const V1, V2: double): double;
begin
  if V1 > V2 then Result := V1 else Result := V2;
end;

function pgMax(const V1, V2: int64): int64;
begin
  if V1 > V2 then Result := V1 else Result := V2;
end;

function pgLimit(const V, Lower, Upper: integer): integer;
begin
  if V < Lower then Result := Lower
    else if V > Upper then Result := Upper
      else Result := V;
end;

function pgLimitS(const V, Lower, Upper: single): single;
begin
  if V < Lower then Result := Lower
    else if V > Upper then Result := Upper
      else Result := V;
end;

function pgLimitD(const V, Lower, Upper: double): double;
begin
  if V < Lower then Result := Lower
    else if V > Upper then Result := Upper
      else Result := V;
end;

function pgSign(const V: single): integer;
begin
  if V < 0 then Result := -1 else
    if V > 0 then Result := 1 else
      Result := 0;
end;

procedure pgSwapDouble(var V1, V2: double);
var
  T: double;
begin
  T := V1;
  V1 := V2;
  V2 := T;
end;

function pgPoint(const X, Y: single): TpgPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

procedure pgMovePoint(var P: TpgPoint; const Dx, Dy: single);
begin
  P.X := P.X + Dx;
  P.Y := P.Y + Dy;
end;

function pgBox(const Lft, Top, Rgt, Btm: single): TpgBox;
begin
  Result.Lft := Lft;
  Result.Top := Top;
  Result.Rgt := Rgt;
  Result.Btm := Btm;
end;

function pgBox(const P1, P2: TpgPoint): TpgBox;
begin
  Result.Lft := pgMin(P1.X, P2.X);
  Result.Top := pgMin(P1.Y, P2.Y);
  Result.Rgt := pgMax(P1.X, P2.X);
  Result.Btm := pgMax(P1.Y, P2.Y);
end;

function pgBox(P: PpgPoint; Count: integer): TpgBox; overload;
var
  i: integer;
begin
  if Count > 0 then
  begin
    Result.Lft := P.X;
    Result.Top := P.Y;
    Result.Rgt := P.X;
    Result.Btm := P.Y;
    for i := 1 to Count - 1 do
    begin
      inc(P);
      Result.Lft := pgMin(Result.Lft, P.X);
      Result.Top := pgMin(Result.Top, P.Y);
      Result.Rgt := pgMax(Result.Rgt, P.X);
      Result.Btm := pgMax(Result.Btm, P.Y);
    end;
  end else
    Result := cEmptyBox;
end;

function pgWidth(const B: TpgBox): single;
begin
  Result := B.Rgt - B.Lft;
end;

function pgHeight(const B: TpgBox): single;
begin
  Result := B.Btm - B.Top;
end;

function pgBoxEqual(const B1, B2: TpgBox): boolean;
begin
  Result := CompareMem(@B1, @B2, SizeOf(TpgBox));
end;

function pgBoxIntersects(const B1, B2: TpgBox): boolean;
begin
  Result := False;
  if pgIsEmptyBox(B1) or pgIsEmptyBox(B2) then
    exit;

  if (B1.Rgt <= B2.Lft) or (B1.Lft >= B2.Rgt) or
     (B1.Btm <= B2.Top) or (B1.Top >= B2.Btm) then
    Result := False
  else
    Result := True;
end;

function pgIsEmptyBox(const B: TpgBox): boolean;
begin
  Result := (B.Rgt <= B.Lft) or (B.Btm <= B.Top);
end;

procedure pgUpdateBox(var B: TpgBox; const APoint: TpgPoint; var IsFirst: boolean);
begin
  if IsFirst then
  begin
    B.Lft := APoint.X;
    B.Rgt := APoint.X;
    B.Top := APoint.Y;
    B.Btm := APoint.Y;
    IsFirst := False;
  end else
  begin
    if APoint.X < B.Lft then
      B.Lft := APoint.X
    else
      if APoint.X > B.Rgt then
        B.Rgt := APoint.X;
    if APoint.Y < B.Top then
      B.Top := APoint.Y
    else
      if APoint.Y > B.Btm then
        B.Btm := APoint.Y;
  end;
end;

function pgUnionBox(const B1, B2: TpgBox): TpgBox;
begin
  if pgIsEmptyBox(B1) then
    Result := B2
  else if pgIsEmptyBox(B2) then
    Result := B1
  else
  begin
    Result.Lft := pgMin(B1.Lft, B2.Lft);
    Result.Top := pgMin(B1.Top, B2.Top);
    Result.Rgt := pgMax(B1.Rgt, B2.Rgt);
    Result.Btm := pgMax(B1.Btm, B2.Btm);
    if pgIsEmptyBox(Result) then
      Result := cEmptyBox;
  end;
end;

function pgIntersectBox(const B1, B2: TpgBox): TpgBox;
begin
  if pgIsEmptyBox(B1) or pgIsEmptyBox(B2) then
  begin
    Result := cEmptyBox;
    exit;
  end;
  Result.Lft := pgMax(B1.Lft, B2.Lft);
  Result.Top := pgMax(B1.Top, B2.Top);
  Result.Rgt := pgMin(B1.Rgt, B2.Rgt);
  Result.Btm := pgMin(B1.Btm, B2.Btm);
  if pgIsEmptyBox(Result) then
    Result := cEmptyBox;
end;

procedure pgMoveBox(var B: TpgBox; DeltaX, DeltaY: single);
begin
  B.Lft := B.Lft + DeltaX;
  B.Rgt := B.Rgt + DeltaX;
  B.Top := B.Top + DeltaY;
  B.Btm := B.Btm + DeltaY;
end;

procedure pgScaleBox(var B: TpgBox; ScaleX, ScaleY: single);
begin
  B.Lft := B.Lft * ScaleX;
  B.Rgt := B.Rgt * ScaleX;
  B.Top := B.Top * ScaleY;
  B.Btm := B.Btm * ScaleY;
end;

function pgGrowBox(const B: TpgBox; Delta: single): TpgBox;
var
  X1, X2, Y1, Y2: single;
begin
  X1 := pgMin(B.Lft, B.Rgt);
  X2 := pgMax(B.Lft, B.Rgt);
  Y1 := pgMin(B.Top, B.Btm);
  Y2 := pgMax(B.Top, B.Btm);
  Result := pgBox(X1 - Delta, Y1 - Delta, X2 + Delta, Y2 + Delta);
end;

function pgPointInBox(const B: TpgBox; const P: TpgPoint): boolean;
begin
  Result :=
    (P.X > B.Lft) and (P.X < B.Rgt) and
    (P.Y > B.Top) and (P.Y < B.Btm);
end;

procedure pgBoxToPoints(const B: TpgBox; First: PpgPoint);
begin
  First.X := B.Lft; First.Y := B.Top; inc(First);
  First.X := B.Lft; First.Y := B.Btm; inc(First);
  First.X := B.Rgt; First.Y := B.Btm; inc(First);
  First.X := B.Rgt; First.Y := B.Top;
end;

function pgBoxF(const Lft, Top, Rgt, Btm: TpgFixed): TpgBoxF;
begin
  Result.Lft := Lft;
  Result.Top := Top;
  Result.Rgt := Rgt;
  Result.Btm := Btm;
end;

function pgIntersectBoxF(const B1, B2: TpgBoxF): TpgBoxF;
begin
  Result.Lft := pgMax(B1.Lft, B2.Lft);
  Result.Top := pgMax(B1.Top, B2.Top);
  Result.Rgt := pgMin(B1.Rgt, B2.Rgt);
  Result.Btm := pgMin(B1.Btm, B2.Btm);
end;

function pgBoxFIsEmpty(const B: TpgBoxF): boolean;
begin
  Result := (B.Rgt <= B.Lft) or (B.Btm <= B.Top)
end;

procedure pgUpdateBoxF(var B: TpgBoxF; const APoint: TpgPointF; var IsFirst: boolean);
begin
  if IsFirst then
  begin
    B.Lft := APoint.X;
    B.Rgt := APoint.X;
    B.Top := APoint.Y;
    B.Btm := APoint.Y;
    IsFirst := False;
  end else
  begin
    // In fixed coords we make sure the box extends 1 to the right
    if APoint.X <  B.Lft then B.Lft := APoint.X;
    if APoint.X >= B.Rgt then B.Rgt := APoint.X + 1;
    if APoint.Y <  B.Top then B.Top := APoint.Y;
    if APoint.Y >= B.Btm then B.Btm := APoint.Y + 1;
  end;
end;

function pgFloatEqual(const F1, F2, Eps: double): boolean;
begin
  Result := Abs(F2 - F1) < Eps;
end;

function pgPointsEqual(const P1, P2: TpgPoint; const Eps: double = cDefaultEps): boolean;
begin
  Result := pgFloatEqual(P1.X, P2.X, Eps) and pgFloatEqual(P1.Y, P2.Y, Eps);
end;

function pgPointsExactlyEqual(const P1, P2: TpgPoint): boolean;
begin
  Result := CompareMem(@P1, @P2, SizeOf(TpgPoint));
end;

function pgFixed(const F: double): TpgFixed;
begin
  Result := pgFloor(F * cFixedScale);
end;

function pgPointF(const APoint: TpgPoint): TpgPointF; overload;
var
  X, Y: single;
begin
  X := pgLimitS(APoint.X, -30000, 30000);
  Y := pgLimitS(APoint.Y, -30000, 30000);
  Result.X := pgFixed(X);
  Result.Y := pgFixed(Y);
end;

function pgPointF(const X, Y: TpgFixed): TpgPointF; overload;
begin
  Result.X := X;
  Result.Y := Y;
end;

function pgiPoint(const X, Y: integer): TpgiPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

function pgPointsFEqual(const P1, P2: TpgPointF): boolean;
begin
  Result := (P1.X = P2.X) and (P1.Y = P2.Y);
end;

function pgFixedToFloat(const F: TpgFixed): double;
begin
  Result := (F + cFixedBias + 0.5) / cFixedScale;
end;

function pgIntMul(A, B: integer): integer;
var
  t: integer;
begin
  t := A * B + $80;
  Result := (t shr 8 + t) shr 8;
end;

function pgPtInRect(const R: TpgRect; P: TpgiPoint): boolean;
begin
  Result :=
    (P.X >= R.Left) and (P.Y >= R.Top) and (P.X < R.Right) and (P.Y < R.Bottom);
end;

function pgColorDistTaxi32(Col1, Col2: PpgColor32): integer;
var
  i: integer;
  P1, P2: pbyte;
begin
  P1 := pbyte(Col1);
  P2 := pbyte(Col2);
  Result := 0;
  for i := 0 to 3 do
  begin
    inc(Result, abs(P1^ - P2^));
    inc(P1); inc(P2);
  end;
end;

function pgColorBlend32(Col1, Col2: PpgColor32; Mix: byte): TpgColor32;
var
  i: integer;
  P1, P2, D: pbyte;
begin
  if Mix = 0 then
  begin
    Result := Col1^;
    exit;
  end;
  if Mix = 255 then
  begin
    Result := Col2^;
    exit;
  end;
  P1 := pbyte(Col1);
  P2 := pbyte(Col2);
  D := pbyte(@Result);
  for i := 0 to 3 do
  begin
    D^ := (P1^ * (Mix xor $FF) + P2^ * Mix) div 255;
    inc(P1);
    inc(P2);
    inc(D);
  end;
end;

function pgArcSin(const X: Extended): Extended;
begin
  Result := pgArcTan2(X, Sqrt(1 - X * X))
end;

{ lowlevel funcs from pgBlend }

procedure Mmx_FillLongword(var X; Count: Integer; Value: Longword);
asm
// EAX = X
// EDX = Count
// ECX = Value
        CMP        EDX, 0
        JBE        @Exit

        PUSH       EDI
        PUSH       EBX
        MOV        EBX, EDX
        MOV        EDI, EDX

        SHR        EDI, 1
        SHL        EDI, 1
        SUB        EBX, EDI
        JE         @QLoopIni

        MOV        [EAX], ECX
        ADD        EAX, 4
        DEC        EDX
        JZ         @ExitPOP
   @QLoopIni:
        MOVD       MM1, ECX
        PUNPCKLDQ  MM1, MM1
        SHR        EDX, 1
    @QLoop:
        MOVQ       [EAX], MM1
        ADD        EAX, 8
        DEC        EDX
        JNZ        @QLoop
        EMMS
    @ExitPOP:
        POP        EBX
        POP        EDI
    @Exit:
end;

procedure Asm_FillLongword(var X; Count: Integer; Value: Longword);
asm
// EAX = X
// EDX = Count
// ECX = Value
        PUSH    EDI

        MOV     EDI,EAX  // Point EDI to destination
        MOV     EAX,ECX
        MOV     ECX,EDX
        TEST    ECX,ECX
        JS      @exit

        REP     STOSD    // Fill count dwords
@exit:
        POP     EDI
end;

function pgColorElementSize(const AInfo: TpgColorInfo): integer;
const
  cByteCount: array[TpgBitsPerChannel] of integer = (1, 2);
begin
  Result := cByteCount[AInfo.BitsPerChannel] * AInfo.Channels;
end;

procedure pgFillLongword(var X; Count: Integer; Value: Longword);
begin
  if glMMXActive then
    Mmx_FillLongword(X, Count, Value)
  else
    Asm_FillLongword(X, Count, Value);
end;

{ from pgCPUInfo }

type
  TCPUInstructionSet = (ciMMX, ciSSE, ciSSE2, ci3DNow, ci3DNowExt);

const

  CPUISChecks: Array[TCPUInstructionSet] of Cardinal =
    (  $800000, // ciMMX
      $2000000, // ciSSE
      $4000000, // ciSSE2
     $80000000, // ci3DNow
     $40000000  // c3DNowExt
     );

function CPUID_Available: Boolean;
asm
        MOV       EDX,False
        PUSHFD
        POP       EAX
        MOV       ECX,EAX
        XOR       EAX,$00200000
        PUSH      EAX
        POPFD
        PUSHFD
        POP       EAX
        XOR       ECX,EAX
        JZ        @1
        MOV       EDX,True
@1:     PUSH      EAX
        POPFD
        MOV       EAX,EDX
end;

function CPU_Signature: Integer;
asm
        PUSH    EBX
        MOV     EAX,1
        DW      $A20F   // CPUID
        POP     EBX
end;

function CPU_Features: Integer;
asm
        PUSH    EBX
        MOV     EAX,1
        DW      $A20F   // CPUID
        POP     EBX
        MOV     EAX,EDX
end;

function CPU_AMDExtensionsAvailable: Boolean;
asm
        PUSH    EBX
        MOV     @Result, True
        MOV     EAX, $80000000
        DW      $A20F   // CPUID
        CMP     EAX, $80000000
        JBE     @NOEXTENSION
        JMP     @EXIT
      @NOEXTENSION:
        MOV     @Result, False
      @EXIT:
        POP     EBX
end;

function CPU_AMDExtFeatures: Integer;
asm
        PUSH    EBX
        MOV     EAX, $80000001
        DW      $A20F   // CPUID
        POP     EBX
        MOV     EAX,EDX
end;

function HasInstructionSet(const InstructionSet: TCPUInstructionSet): Boolean;
begin
  Result := False;
  if not CPUID_Available then
    // no CPUID available
    exit;

  if CPU_Signature shr 8 and $0F < 5 then
    // not a Pentium class
    exit;

  if (InstructionSet = ci3DNow) or (InstructionSet = ci3DNowExt) then
  begin
    if not CPU_AMDExtensionsAvailable or (CPU_AMDExtFeatures and CPUISChecks[InstructionSet] = 0) then
      exit;
  end
  else
    if CPU_Features and CPUISChecks[InstructionSet] = 0 then
      // no MMX
      exit;

  Result := True;
end;

function HasMMX: Boolean;
begin
  Result := HasInstructionSet(ciMMX);
end;

{ a few ASM functions... }

function pgIntPower(const Base: Extended; const Exponent: Integer): Extended;
asm
        mov     ecx, eax
        cdq
        fld1                      { Result := 1 }
        xor     eax, edx
        sub     eax, edx          { eax := Abs(Exponent) }
        jz      @@3
        fld     Base
        jmp     @@2
@@1:    fmul    ST, ST            { X := Base * Base }
@@2:    shr     eax,1
        jnc     @@1
        fmul    ST(1),ST          { Result := Result * X }
        jnz     @@1
        fstp    st                { pop X from FPU stack }
        cmp     ecx, 0
        jge     @@3
        fld1
        fdivrp                    { Result := 1 / Result }
@@3:
        fwait
end;

procedure EMMS;
begin
  if glMmxActive then
  asm
    EMMS
  end;
end;
{procedure EMMS;
begin
  if glMMXActive then
  asm
    db $0F,$77               /// EMMS
  end;
end;}

function pgSAR8(AValue: integer): integer;
asm
        SAR EAX,8
end;

procedure pgSinCos(const Theta: Extended; var Sin, Cos: Extended);
asm
        FLD     Theta
        FSINCOS
        FSTP    tbyte ptr [edx]    // Cos
        FSTP    tbyte ptr [eax]    // Sin
        FWAIT
end;

function pgArcTan2(const Y, X: Extended): Extended;
asm
        FLD     Y
        FLD     X
        FPATAN
        FWAIT
end;

function pgTan(const X: Extended): Extended;
asm
        FLD    X
        FPTAN
        FSTP   ST(0)      { FPTAN pushes 1.0 after result }
        FWAIT
end;

initialization

  // MMX Detection
  glMMXActive := HasMMX;

  // Default to AA precision 4 (256 levels)
  pgSetAntiAliasing(4);

end.


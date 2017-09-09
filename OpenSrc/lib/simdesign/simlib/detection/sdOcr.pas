{ unit sdOcr

  This unit implements an OCR module that can be used to recognise texts
  in bitmap images. Fields of application are recognition of printed
  texts, license plate recognition etc.

  Default will find black characters on a white background. The bitmap that
  is provided must be adjusted for this in other cases. The provided (color)
  bitmap will be converted to grayscale, with value = 0 for complete black to
  value = 255 for complete white, and all shades inbetween.
  
  - used for license plate recognition

  (c) Copyright 2003 by Nils Haeck (SimDesign B.V.)
  for more info please visit www.simdesign.nl

}
unit sdOcr;

interface

uses
  Contnrs, Classes, Windows, Graphics, SysUtils, Math, Gr32, Gr32_OrdinalMaps,
  sdIntMap, Gr32_Polygons, sdSimplifyPolylineDouglasPeucker, sdMatrices,
  NativeXml, sdSortedLists;

type

  EOcrError = class(Exception);
  TOcrMessageEvent = procedure(Sender: TObject; AMessage: string) of object;
  TOcrDrawCharEvent = procedure(Sender: TObject; X, Y: single; FontName: string;
    Character: widechar; FontSize: integer) of object;
  TOcrDrawDotEvent  = procedure(Sender: TObject; X, Y: single; Color: TColor) of object;
  TOcrDrawLineEvent  = procedure(Sender: TObject; StartX, StartY, CloseX, CloseY: single;
    Color: TColor) of object;
  TOcrDrawMapEvent  = procedure(Sender: TObject; StartX, StartY: integer; Map: TByteMap) of object;

  TsdOcrModule = class;

  TsdOcrBar = class(TPersistent)
  private
    FLo: integer;
    FHi: integer;
    FIsHorizontal: boolean;
    FLine: integer;
  public
    constructor Create(AIsHorizontal: boolean); virtual;
    procedure CalculateCenter(Map: TByteMap; var Center: TFloatPoint); virtual;
    procedure CalculateEdges(Map: TByteMap; Treshold: byte; var P1, P2: TFloatPoint); virtual;
    property IsHorizontal: boolean read FIsHorizontal write FIsHorizontal;
    property Lo: integer read FLo write FLo;
    property Hi: integer read FHi write FHi;
    property Line: integer read FLine write FLine;
  end;

  TsdOcrBarList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdOcrBar;
  public
    property Items[Index: integer]: TsdOcrBar read GetItems; default;
  end;

  TsdOcrSegment = class(TPersistent)
  private
    FBounds: TFloatRect; // Bounds (including tolerance)
    FVisited: single;    // Indicates if the segment was visited 0 = no, 1 = fully
    FTol2: single;       // Square of the tolerance
    FLength2: single;    // Square of the length
    FLength: single;     // Length of the segment
  public
    Start: TFloatPoint;
    Close: TFloatPoint;
    procedure SetTolerance(Tol: single);
    function NearPoint(const APoint: TFloatPoint): single;
    property Bounds: TFloatRect read FBounds;
    property Length: single read FLength write FLength;
    property Visited: single read FVisited write FVisited;
  end;

  TsdOcrTrainer = class(TPersistent)
  private
    FOwner: TsdOcrModule;
    FFontName: string;
    FFontStyle: TFontStyles;
    FCharacter: widechar;
    FPoly: TPolygon32;
    FSegments: TObjectList;
    FMap: TByteMap;
    FAspectRatio: single;
    function GetSegments(Index: integer): TsdOcrSegment;
    function GetSegmentCount: integer;
    function GetVertexCount: integer;
    procedure GlyphToPolygon(Header: PTTPolygonHeader; BufSize: integer;
      Metrics: TGLYPHMETRICS; Poly: TPolygon32);
    procedure RegenerateQSpline(const P0, P1, P2: TFixedPoint; Poly: TPolygon32);
  protected
    procedure BitmapPolygon;
    procedure CreateGlyphOutline;
    procedure NormalizePolygon;
  public
    constructor Create(AOwner: TsdOcrModule); virtual;
    destructor Destroy; override;
    procedure BuildCharacter; virtual;
    function IsBodyPoint(APoint: TFloatPoint): single;
    procedure Reset;
    function SegmentAdd(ASegment: TsdOcrSegment): integer;
    procedure SetTolerance(Tol: single);
    procedure SaveToXml(ANode: TXmlNode);
    procedure LoadFromXml(ANode: TXmlNode);
    property AspectRatio: single read FAspectRatio write FAspectRatio;
    property Character: widechar read FCharacter write FCharacter;
    property FontName: string read FFontName write FFontName;
    property FontStyle: TFontStyles read FFontStyle write FFontStyle;
    property Map: TByteMap read FMap write FMap;
    property Poly: TPolygon32 read FPoly write FPoly;
    property SegmentCount: integer read GetSegmentCount;
    property Segments[Index: integer]: TsdOcrSegment read GetSegments;
    property VertexCount: integer read GetVertexCount;
  end;

  TsdOcrTrainerList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TsdOcrTrainer;
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    property Items[Index: integer]: TsdOcrTrainer read GetItems; default;
  end;

  // One of the candidates that is recognised for a glyph
  TsdOcrCandidate = class(TPersistent)
  private
    FScore: single;
    FTrainer: TsdOcrTrainer;
    function GetCharacter: widechar;
  public
    property Score: single read FScore write FScore;
    property Character: widechar read GetCharacter;
    property Trainer: TsdOcrTrainer read FTrainer write FTrainer;
  end;

  TsdOcrCandidateList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdOcrCandidate;
  public
    property Items[Index: integer]: TsdOcrCandidate read GetItems; default;
  end;

  // A piece of the input bitmap that might be a character to recognise
  TsdOcrGlyph = class(TPersistent)
  private
    FOwner: TsdOcrModule;
    FCandidates: TsdOcrCandidateList; // Reference list to trainers, with alternatives
    FAspectBias: single;     // A correction factor applied to the aspect calculation (default = 0)
    FAspectDiff: single;     // Calculated aspect difference with optimum trainer
    FBars: TList;            // List of references to TsdOcrBar tresholded bars
    FEdges: TList;           // List of integers referring to point numbers that are on the edge
    FPoints: array of TFloatPoint; // Owned list of points
    FScaled: array of TFloatPoint; // Owned list of corrected, scaled points
    FBounds: TFloatRect;     // Rectangle that encompasses the glyph points
    FRef: integer;           // Reference used in bar grouping
    FScore: single;          // Confidence score (0.0 = bad, 1.0 = perfect)
    FTrainer: TsdOcrTrainer; // Recognised (optimum) trainer
    FSkewY: single;          // Amount of skew detected in Y
    FSkewYFound: boolean;
    FSkewX: single;          // Amount of skew detected in X
    FGroupId: integer;       // Group number (only valid after first creation of groups), or -1 for "no group"
    function GetPoints(Index: integer): TFloatPoint;
    function GetPointCount: integer;
    function GetBars(Index: integer): TsdOcrBar;
    function GetBarCount: integer;
    function GetHeight: single;
    function GetWidth: single;
    function GetFillPercent: single;
    function GetCharacter: widechar;
    function GetScaledPoints(Index: integer): TFloatPoint;
    function GetBottomCenter: TFloatPoint;
    function GetTopCenter: TFloatPoint;
    function GetEdgeCount: integer;
    function GetEdges(Index: integer): TFloatPoint;
  protected
    function BarAdd(ABar: TsdOcrBar): integer;
    procedure CalculatePoints(Map: TByteMap; Treshold: byte);
    procedure FindSkewY;
    procedure PointAdd(APoint: TFloatPoint); virtual;
    procedure RecogniseSkewYRange(MinSkewY, MaxSkewY: single; Steps: integer);
    procedure RecogniseBitmap;
    procedure RecognisePolygon;
    property BarCount: integer read GetBarCount;
    property Bars[Index: integer]: TsdOcrBar read GetBars;
    property EdgeCount: integer read GetEdgeCount;
    property Edges[Index: integer]: TFloatPoint read GetEdges;
    property GroupId: integer read FGroupId write FGroupId;
    property Ref: integer read FRef write FRef;
    property SkewYFound: boolean read FSkewYFound write FSkewYFound;
  public
    constructor Create(AOwner: TsdOcrModule); virtual;
    destructor Destroy; override;
    procedure Recognise;
    property Candidates: TsdOcrCandidateList read FCandidates;
    property AspectBias: single read FAspectBias write FAspectBias;
    property AspectDiff: single read FAspectDiff write FAspectDiff;
    property BottomCenter: TFloatPoint read GetBottomCenter;
    property TopCenter: TFloatPoint read GetTopCenter;
    property Bounds: TFloatRect read FBounds write FBounds;
    property Character: widechar read GetCharacter;
    property Height: single read GetHeight;
    property FillPercent: single read GetFillPercent;
    property PointCount: integer read GetPointCount;
    property Points[Index: integer]: TFloatPoint read GetPoints;
    property ScaledPoints[Index: integer]: TFloatPoint read GetScaledPoints;
    property SkewX: single read FSkewX write FSkewX;
    property SkewY: single read FSkewY write FSkewY;
    property Score: single read FScore write FScore;
    property Trainer: TsdOcrTrainer read FTrainer write FTrainer;
    property Width: single read GetWidth;
  end;

  TsdOcrGlyphList = class(TLuidList)
  private
    function GetItems(Index: integer): TsdOcrGlyph;
  protected
    function GetLuid(AItem: TObject): integer; override;
  public
    function ByRef(ARef: integer): TsdOcrGlyph; 
    property Items[Index: integer]: TsdOcrGlyph read GetItems; default;
  end;

  TsdOcrGroup = class(TPersistent)
  private
    FOwner: TsdOcrModule;
    FGlyphs: TsdOcrGlyphList;// References to glyphs
    FUseBruteSkewY: boolean;
    function GetSkewX: single;
  protected
    procedure CorrectAspect; virtual;
    procedure CorrectSkewY; virtual;
    procedure PredictSkewYForMissed;
    procedure RecogniseSkewYRange(MinSkewY, MaxSkewY: single; Steps: integer);
    procedure SortGlyphsByDirection(ADirection: single);
    property SkewX: single read GetSkewX;
  public
    constructor Create(AOwner: TsdOcrModule); virtual;
    destructor Destroy; override;
    property Glyphs: TsdOcrGlyphList read FGlyphs;
    property UseBruteSkewY: boolean read FUseBruteSkewY write FUseBruteSkewY;
  end;

  TsdOcrGroupList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdOcrGroup;
  public
    property Items[Index: integer]: TsdOcrGroup read GetItems; default;
  end;

  TsdOcrLine = class(TPersistent)
  private
    FText: widestring;
  public
    property Text: widestring read FText write FText;
  end;

  TsdOcrLineList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdOcrLine;
  public
    property Items[Index: integer]: TsdOcrLine read GetItems; default;
  end;

  TsdOcrTresholdType = (
    cttSingle,  // OCR uses the single treshold Module.Treshold
    cttDual     // OCR uses the dual tresholds Module.TresholdLo/Module.Treshold
  );

  TRecognitionMethodType = (
    crmPolygon, // Use a polygon matching algorithm
    crmBitmap   // Use a bitmap matching algorithm
  );

  TsdOcrModule = class(TPersistent)
  private
    FGlyphs: TsdOcrGlyphList;  // Collections of points forming potential characters
    FGroups: TsdOcrGroupList;  // Collection of groups that reference a number of glyphs
    FBars: TsdOcrBarList;      // Lowlevel treshold transition bars
    FTrainers: TsdOcrTrainerList; // List of trainer forms
    FLines: TsdOcrLineList;    // Collection of lines with recognised characters
    FAdaptiveTreshold: boolean;// Set to True to adaptively treshold the image
    FAbsoluteThresholding: boolean;
    FAllowSlowSearch: boolean;// If true, bruteforce search methods are used in some cases (Default = false)
    FAutoAspectCorrect: boolean; // Correct aspect ratio with a bias (default = false)
    FDib: TBitmap32;          // Device independend bitmap that holds original image
    FGroupwiseDeskew: boolean;// If true, deskew in Y for complete group instead individually
    FIncludeSpaces: boolean;  // Include spaces in the final lines of text (if characters are spaced)
    FMap: TByteMap;           // Bytemap that contains processed, relevant part of image FDib
    FMapConversion: TConversionType;
    FMapLeft: integer;        // Left position of relevant part in image FDib
    FMapTop: integer;         // Top position of relevant part in image FDib
    FMinConfidence: single;   // Minimum confidence in order to include a glyph as character (default 0.70)
    FMinGlyphHeight: single;  // Minimum glyph height in pixels
    FMaxGlyphHeight: single;  // Maximum glyph height in pixels
    FMinGlyphWidth: single;   // Minimum glyph width in pixels
    FMaxGlyphWidth: single;   // Maximum glyph width in pixels
    FMinGlyphPointCount: integer; // Minimum number of points in order to qualify as glyph
    FMinGroupLength: integer; // Minimum number of glyphs per group
    FMaxTextRotation: single; // Maximum rotation in [deg] of text (both directions), default = 20 deg
    FDeskewStepCount: integer;// Number of steps for skew detection. Min. 3, odd number, default 15
    FRecognitionMethod: TRecognitionMethodType;
    FTextDirection: single;   // Default direction of text (in degrees from horizon, + upward, - downward, valid within ca -45, +45)
    FTrainerTolerance: single; // Tolerance when comparing edges of trainers (as fraction of height, default 0.04)
    FTresholdType: TsdOcrTresholdType; // The type of treshold to use
    FTreshold: integer;       // Normal (or hi) treshold value for grayscale images; above treshold considered part of glyph
    FTresholdLo: integer;     // Low treshold for dual treshold type
    FOnTextChanged: TNotifyEvent;
    FOnDebugMessage: TOcrMessageEvent;
    FOnDrawDot: TOcrDrawDotEvent;
    FOnDrawLine: TOcrDrawLineEvent;
    FOnDrawChar: TOcrDrawCharEvent;
    FOnDrawMap: TOcrDrawMapEvent;
    procedure DoDebugMessage(AMessage: string);
    procedure DoTextChanged;
    function GetText: widestring;
    function GetGroupedGlyphCount: integer;
  protected
    function BarAdd(ABar: TsdOcrBar): integer;
    procedure BuildGlyphs(Points: TList; Map: TByteMap); virtual;
    procedure BuildIntensityMap(ARect: TRect); virtual;
    procedure ClearGlyphsAndTexts; virtual;
    procedure ExtractGlyphs; virtual;
    procedure FilterGlyphsOnSizeAndBarcount; virtual;
    procedure FilterPointlist(ALow, AHigh: integer; Filter: TList); virtual;
    procedure GroupGlyphs; virtual;
    procedure PlotGlyphs(Color: TColor);
    procedure ResetTrainers;
    function SkewFromAngle(Angle: single): single;
    procedure TresholdMapDual; virtual;
    procedure TresholdMapSingle; virtual;
    procedure SaveSettingsToXml(ANode: TXmlNode);
    procedure LoadSettingsFromXml(ANode: TXmlNode);
    property Glyphs: TsdOcrGlyphList read FGlyphs;
    property Bars: TsdOcrBarList read FBars;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddTrainerCharacters(const FontName: string;
      const Characters: widestring; FontStyle: TFontStyles = []);
    procedure AddTrainer(ATrainer: TsdOcrTrainer);  
    procedure AssignBitmap(ABitmap: TBitmap);
    function LineAdd(ALine: TsdOcrLine): integer;
    procedure RecogniseRect(ARect: TRect);
    procedure Recognise;
    procedure SetTrainerTolerance(ATol: single);
    procedure LoadFromXml(ANode: TXmlNode);
    procedure SaveToXml(ANode: TXmlNode);
    procedure LoadFromFile(const AFilename: string);
    procedure LoadFromStream(S: TStream);
    procedure SaveToFile(const AFilename: string);
    procedure SaveToStream(S: TStream);
    property AdaptiveTreshold: boolean read FAdaptiveTreshold write FAdaptiveTreshold;
    property AllowSlowSearch: boolean read FAllowSlowSearch write FAllowSlowSearch;
    property AutoAspectCorrect: boolean read FAutoAspectCorrect write FAutoAspectCorrect;
    property DeskewStepCount: integer read FDeskewStepCount write FDeskewStepCount;
    property GroupedGlyphCount: integer read GetGroupedGlyphCount;
    property Groups: TsdOcrGroupList read FGroups;
    property GroupwiseDeskew: boolean read FGroupwiseDeskew write FGroupwiseDeskew;
    property IncludeSpaces: boolean read FIncludeSpaces write FIncludeSpaces;
    property Lines: TsdOcrLineList read FLines;
    property MapConversion: TConversionType read FMapConversion write FMapConversion;
    property MinConfidence: single read FMinConfidence write FMinConfidence;
    property MinGlyphHeight: single read FMinGlyphHeight write FMinGlyphHeight;
    property MaxGlyphHeight: single read FMaxGlyphHeight write FMaxGlyphHeight;
    property MinGlyphWidth: single read FMinGlyphWidth write FMinGlyphWidth;
    property MaxGlyphWidth: single read FMaxGlyphWidth write FMaxGlyphWidth;
    property MinGlyphPointCount: integer read FMinGlyphPointCount write FMinGlyphPointCount;
    property MinGroupLength: integer read FMinGroupLength write FMinGroupLength;
    property MaxTextRotation: single read FMaxTextRotation write FMaxTextRotation;
    property RecognitionMethod: TRecognitionMethodType read FRecognitionMethod write FRecognitionMethod;
    property Text: widestring read GetText;
    property TextDirection: single read FTextDirection write FTextDirection;
    property Trainers: TsdOcrTrainerList read FTrainers;
    property TrainerTolerance: single read FTrainerTolerance write SetTrainerTolerance;
    property TresholdType: TsdOcrTresholdType read FTresholdType write FTresholdType;
    property Treshold: integer read FTreshold write FTreshold;
    property TresholdLo: integer read FTresholdLo write FTresholdLo;
    property OnDrawChar: TOcrDrawCharEvent read FOnDrawChar write FOnDrawChar;
    property OnDrawDot: TOcrDrawDotEvent read FOnDrawDot write FOnDrawDot;
    property OnDrawLine: TOcrDrawLineEvent read FOnDrawLine write FOnDrawLine;
    property OnDrawMap: TOcrDrawMapEvent read FOnDrawMap write FOnDrawMap;
    property OnTextChanged: TNotifyEvent read FOnTextChanged write FOnTextChanged;
    property OnDebugMessage: TOcrMessageEvent read FOnDebugMessage write FOnDebugMessage;
  end;

resourcestring

  sBitmapMustBeAssigned = 'Bitmap must be assigned';

implementation

const
  // Size of glyph buffer
  cGlyphBufSize = 16384; // 16K buffer size
  // Minimum segment size (in pixels, expressed as TFixed)
  cGlyphMinSegmentSize: TFixed = 2 * $10000;
  // Number of pixels in Y for trainer map
  cDefaultTrainerPixelsY = 50;
  // Number of pixels in X for trainer map
  cDefaultTrainerPixelsX = 25;

  // Store alternatives within Limit% of best
  cAlternativeLimit = 0.05;


type

  TSortFunction = function(Item1, Item2, Info: pointer): integer;

function FixedFromW(const Value: _FIXED): TFixed;
begin
  Result := Value.Value * $10000 + Value.Fract;
end;

function PointsAreEqual(const P1, P2: TFixedPoint): boolean;
begin
  Result := (P1.X = P2.X) and (P1.Y = P2.Y);
end;

function MiddleLine(const p1, p2: TFixedPoint): TFixedPoint;
begin
  Result.x := (p1.x + p2.x) div 2;
  Result.y := (p1.y + p2.y) div 2;
end;

function SegmentConditionalLengthQ2N1Sup(const x0, x1, x2 : TFixedPoint): TFixed;
begin
 // result := norm1(x0, x1)  + norm1(x1, x2);
 result := abs(x0.X - x1.x) + abs(x0.Y - x1.Y) +
           abs(x1.X - x2.x) + abs(x1.Y - x2.Y);
end;

procedure SortList(List: TList; SortFunction: TSortFunction; Info: pointer);
//local
procedure QuickSort(iLo, iHi: Integer);
var
  Lo, Hi, Mid: longint;
begin
  Lo := iLo;
  Hi := iHi;
  Mid:= (Lo + Hi) div 2;
  repeat
    while SortFunction(List[Lo], List[Mid], Info) < 0 do
      Inc(Lo);
    while SortFunction(List[Hi], List[Mid], Info) > 0 do
      Dec(Hi);
    if Lo <= Hi then
    begin
      // Swap pointers;
      List.Exchange(Lo, Hi);
      if Mid = Lo then
        Mid := Hi
      else
        if Mid = Hi then
          Mid := Lo;
      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;
  if Hi > iLo then QuickSort(iLo, Hi);
  if Lo < iHi then QuickSort(Lo, iHi);
end;
// main
begin
  if List.Count > 1 then
    QuickSort(0, List.Count - 1);
end;

// Sort glyphs by top
function SortGlyphsByTop(Item1, Item2, Info: pointer): integer;
var
  Top1, Top2: single;
begin
  Top1 := TsdOcrGlyph(Item1).Bounds.Top;
  Top2 := TsdOcrGlyph(Item2).Bounds.Top;
  if Top1 < Top2 then Result := -1
    else if Top1 > Top2 then Result := 1
      else Result := 0;
end;

function SortEdgesByY(Item1, Item2, Info: pointer): integer;
var
  Y1, Y2: single;
begin
  Y1 := TsdOcrGlyph(Info).ScaledPoints[integer(Item1)].Y;
  Y2 := TsdOcrGlyph(Info).ScaledPoints[integer(Item2)].Y;
  if Y1 < Y2 then
    Result := -1
  else
    if Y1 > Y2 then
      Result := 1
    else
      Result := 0;
end;

function SortCandidateByScore(Item1, Item2, Info: pointer): integer;
var
  S1, S2: single;
begin
  S1 := TsdOcrCandidate(Item1).Score;
  S2 := TsdOcrCandidate(Item2).Score;
  if S1 < S2 then
    Result := 1
  else
    if S1 > S2 then
      Result := -1
    else
      Result := 0;
end;

procedure Skew(SkewX, SkewY: single; var Points: array of TFloatPoint;
  Count: integer);
var
  i: integer;
  APoint: TFloatPoint;
begin
  for i := 0 to Count - 1 do
  begin
    APoint := Points[i];
    Points[i].X := APoint.X + APoint.Y * SkewY;
    Points[i].Y := APoint.Y + APoint.X * SkewX;
  end;
end;

procedure Normalize(var Points: array of TFloatPoint; Count: integer; var Aspect: single);
var
  i: integer;
  MinX, MinY, MaxX, MaxY: single;
  ScaleX, ScaleY: single;
begin
  MinX := 0; MinY := 0; MaxX := 0; MaxY := 0;
  // Determine min/max
  for i := 0 to Count - 1 do
    if i = 0 then
    begin
      MinX := Points[0].X; MaxX := Points[0].X;
      MinY := Points[0].Y; MaxY := Points[0].Y;
    end else
    begin
      MinX := Min(MinX, Points[i].X);
      MinY := Min(MinY, Points[i].Y);
      MaxX := Max(MaxX, Points[i].X);
      MaxY := Max(MaxY, Points[i].Y);
    end;
  if MaxY = MinY then
    exit;
  // The scale factor to normalize in Y
  ScaleX := 0.5 / (MaxX - MinX);
  ScaleY := 1   / (MaxY - MinY);
  Aspect := ScaleX / ScaleY;
  for i := 0 to Count - 1 do
  begin
    Points[i].X := (Points[i].X - MinX) * ScaleX;
    Points[i].Y := (Points[i].Y - MinY) * ScaleY;
  end;
end;

function FloatLength(V: TFloatPoint): single;
begin
  Result := sqrt(sqr(V.X) + sqr(V.Y));
end;

{ Statistical }

procedure MeanAndStDev(const List: array of single; Count: integer; var Mean, StDev: single);
var
  i: integer;
begin
  Mean  := 0;
  StDev := 0;
  if Count <= 0 then
    exit;
  for i := 0 to Count - 1 do
    Mean := Mean + List[i];
  Mean := Mean / Count;
  if Count < 2 then
    exit;
  for i := 0 to Count - 1 do
    StDev := StDev + sqr(List[i] - Mean);
  StDev := Sqrt(StDev / (Count - 1))
end;

function MeanOfPercentile(var List: array of single; Count: integer; Percent: single): single;
var
  i, j, Lo, Hi: integer;
  Temp: single;
  Que: single;
begin
  Result := 0;
  if Count < 1 then
    exit;
  // Sort
  if Count > 1 then
    for i := 0 to Count - 2 do
      for j := i + 1 to Count - 1 do
        if List[j] < List[i] then
        begin
          Temp := List[i];
          List[i] := List[j];
          List[j] := Temp;
        end;

  Que := (1 - Percent) / 2;
  Lo := round(Que * Count);
  Hi := round((Que + Percent) * Count) - 1;
  Lo := Max(0, Min(Lo, Count - 1));
  if Hi < Lo then
    Hi := Lo;

  // Mean
  for i := Lo to Hi do
    Result := Result + List[i];
  Result := Result / (Hi - Lo + 1);
end;

{ Line stroking }

procedure StrokeLine(const Points: array of TFloatPoint; Count: integer; var A, B: single);
// Stroke a line through the points in Points and return Y = A * x + B as an equation
var
  r: integer;
  vecB, vecY: TsdVector;
  matA, matAInv: TsdMatrix;
begin
  // checks
  A := 0;
  B := 0;
  if Count < 1 then
    exit;
  B := Points[0].Y;
  if Count < 2 then
    exit;
  // init
  matA := TsdMatrix.CreateSize(Count, 2);
  matAInv := TsdMatrix.CreateSize(2, Count);
  vecB := TsdVector.CreateCount(Count);
  vecY := TsdVector.CreateCount(2);
  try
    for r := 0 to Count - 1 do
    begin
      // Add data to matA matrix
      matA[r, 0] := Points[r].X;
      matA[r, 1] := 1.0;
      // Add data to vecB vector
      vecB[r] := Points[r].Y;
    end;
    // Calculate MP inverse
    MatInverseMP(matA, matAInv);
    // Find A and B
    MatMultiply(matAInv, vecB, vecY);
    A := vecY[0];
    B := vecY[1];
  finally
    matA.Free;
    matAInv.Free;
    vecB.Free;
    vecY.Free;
  end;
end;

{ TsdOcrModule }

procedure TsdOcrModule.AddTrainer(ATrainer: TsdOcrTrainer);
var
  Index: integer;
begin
  if Trainers.Find(ATrainer, Index) then
    // duplicate
    ATrainer.Free
  else
  begin
    Trainers.Insert(Index, ATrainer);
    ATrainer.BuildCharacter;
    ATrainer.SetTolerance(FTrainerTolerance);
  end;
end;

procedure TsdOcrModule.AddTrainerCharacters(const FontName: string; const Characters: widestring; FontStyle: TFontStyles = []);
// Add a list of training characters to the OCR component
var
  i: integer;
  Trainer: TsdOcrTrainer;
begin
  for i := 1 to Length(Characters) do
  begin
    Trainer := TsdOcrTrainer.Create(Self);
    Trainer.FontName  := FontName;
    Trainer.FontStyle := FontStyle;
    Trainer.Character := Characters[i];
    AddTrainer(Trainer);
  end;
end;

procedure TsdOcrModule.AssignBitmap(ABitmap: TBitmap);
// Assign a new bitmap
begin
  ClearGlyphsAndTexts;
  FDib.Assign(ABitmap);
end;

function TsdOcrModule.BarAdd(ABar: TsdOcrBar): integer;
begin
  Result := -1;
  if assigned(FBars) and assigned(ABar) then
    Result := FBars.Add(ABar);
end;

procedure TsdOcrModule.BuildGlyphs(Points: TList; Map: TByteMap);
var
  i, j, k, b: integer;
  SegMap: TsdIntMap;
  Touch: array of integer;
  Glyph: TsdOcrGlyph;
  Bar, BarB: TsdOcrBar;
// local
procedure AddToTouch(Value: integer);
var
  i, L, Temp: integer;
begin
  // Zero means no glyph present
  if Value = 0 then
    exit;
  // The current length
  L := Length(Touch);
  // Does neighbour already exist?
  for i := 0 to L - 1 do
    if Touch[i] = Value then
      exit;
  // Neighbour does not exist, so add it to the touch list
  SetLength(Touch, L + 1);
  Touch[L] := Value;
  // Make sure that Touch[0] is smallest
  for i := 1 to L do
    if Touch[0] > Touch[i] then
    begin
      Temp := Touch[0];
      Touch[0] := Touch[i];
      Touch[i] := Temp;
    end;
end;
// local
procedure SetGlyphFromTo(Old, New: integer);
// Add all bars from the glyph with ref Old to the glyph with ref New
var
  i: integer;
  GlyphOld, GlyphNew: TsdOcrGlyph;
begin
  GlyphOld := Glyphs.ByRef(Old);
  GlyphNew := Glyphs.ByRef(New);
  if assigned(GlyphOld) and assigned(GlyphNew) then
  begin
    for i := 0 to GlyphOld.BarCount - 1 do
      GlyphNew.BarAdd(GlyphOld.Bars[i]);
    FGlyphs.Remove(GlyphOld);
  end;
end;
// main
begin
  // Create segment map
  SegMap := TsdIntMap.Create;
  try
    SegMap.SetSize(Map.Width, Map.Height);
    SegMap.Clear;
    FGlyphs.Clear;

    // Loop through all bars
    for i := 0 to Points.Count - 1 do
    begin
      Bar := TsdOcrBar(Points[i]);
      // Examines which bars it touches
      SetLength(Touch, 0);
      for j := Bar.Lo to Bar.Hi do
        for k := -1 to 1 do
          if Bar.IsHorizontal then
          begin
            if SegMap[j, Bar.Line + k] > 0 then
              AddToTouch(SegMap[j, Bar.Line + k]);
          end else
          begin
            if SegMap[Bar.Line + k, j] > 0 then
              AddToTouch(SegMap[Bar.Line + k, j]);
          end;

      // Did the bar touch at all?
      if Length(Touch) = 0 then
      begin

        // No bars are touched, so this is a new glyph
        Glyph := TsdOcrGlyph.Create(Self);
        Glyph.Ref := Glyphs.NextLuid;
        FGlyphs.Add(Glyph);

      end else
      begin

        // Join the additional glyphs
        if Length(Touch) > 1 then
          for j := 1 to Length(Touch) - 1 do
            SetGlyphFromTo(Touch[j], Touch[0]);

        // Yes they touched, reference the first glyph
        Glyph := Glyphs.ByRef(Touch[0]);

      end;

      if assigned(Glyph) then
      begin
        // Add bar to glyph
        Glyph.BarAdd(Points[i]);

        // Draw the Glyphs Ref into the segment map
        for b := 0 to Bars.Count - 1 do
        begin
          BarB := Bars[b];
          for j := BarB.Lo to BarB.Hi do
            if BarB.IsHorizontal then
              SegMap[j, BarB.Line] := Glyph.Ref
            else
              SegMap[BarB.Line, j] := Glyph.Ref;
        end;
      end;
    end;

  finally
    SegMap.Free;
  end;
end;

procedure TsdOcrModule.BuildIntensityMap(ARect: TRect);
type
  TBgra32 = packed record
    Red, Green, Blue, Alpha: byte;
  end;
// Currently, this simply inverts the grayscale map. In future, smarter methods
// may be applied like high-frequency filtering. The result must be a map that
// holds 0 in places with bgr, and 255 in places with glyphs
var
  i, x, y: integer;
  AIntMap: TsdIntMap;
  AMin, AMax: integer;
  Mult: single;
begin
  // Convert RGB to intensity, copy partial bitmap
  FMapLeft := ARect.Left;
  FMapTop  := ARect.Top;
  FMap.SetSize(ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  DoDebugMessage('--Extracting map data from image');
  for y := 0 to FMap.Height - 1 do
    for x := 0 to FMap.Width - 1 do
    begin
      case FMapConversion of
      ctRed:
        FMap[x, y] := TBgra32(FDib[x + ARect.Left, y + ARect.Top]).Red;
      ctGreen:
        FMap[x, y] := TBgra32(FDib[x + ARect.Left, y + ARect.Top]).Green;
      ctBlue:
        FMap[x, y] := TBgra32(FDib[x + ARect.Left, y + ARect.Top]).Blue;
      ctAlpha:
        FMap[x, y] := TBgra32(FDib[x + ARect.Left, y + ARect.Top]).Alpha;
      ctUniformRGB:
        with TBgra32(FDib[x + ARect.Left, y + ARect.Top]) do
          FMap[x, y] := (Red + Green + Blue) div 3;
      ctWeightedRGB:
        FMap[x, y] := Intensity(FDib[x + ARect.Left, y + ARect.Top]);
      end;//case
    end;

  // Invert Map
  for i := 0 to FMap.Width * FMap.Height - 1 do
    FMap.Bits[i] := 255 - FMap.Bits[i];

  // Adaptive tresholding
  if AdaptiveTreshold then
  begin
    DoDebugMessage('--Creating adaptive map');
    AIntMap := TsdIntMap.Create;
    try
      AIntMap.Assign(FMap);
      // Average the map, with a radius of 5 pixels
      AIntMap.BlurRecursive(10);
      AMin := 0; AMax := 0;
      for i := 0 to FMap.Width * FMap.Height - 1 do
      begin
        // Negate the average, and add the map, take the absolute value
        if FAbsoluteThresholding then
          AIntmap.Ints[i] := abs(round(- AIntmap.Ints[i] + FMap.Bits[i] shl 8))
        else
          AIntmap.Ints[i] := Max(0, round(-0.8 * AIntmap.Ints[i] + FMap.Bits[i] shl 8));
        // Find maximum
        if i = 0 then
        begin
          AMin := AIntmap.Ints[0];
          AMax := AIntmap.Ints[0];
        end else
        begin
          AMin := Min(AMin, AIntmap.Ints[i]);
          AMax := Max(AMax, AIntmap.Ints[i]);
        end;
      end;
      // Scale map
      if AMax > AMin then
      begin
        Mult := 255 / (AMax - AMin);
        for i := 0 to FMap.Width * FMap.Height - 1 do
          FMap.Bits[i] := round((AIntMap.Ints[i] - AMin) * Mult);
      end;
    finally
      AIntMap.Free;
    end;
  end;
  if assigned(FOnDrawMap) then
    FOnDrawMap(Self, FMapLeft, FMapTop, FMap);
end;

procedure TsdOcrModule.ClearGlyphsAndTexts;
begin
  FGlyphs.Clear;
  FLines.Clear;
  FBars.Clear;
  DoTextChanged;
end;

constructor TsdOcrModule.Create;
begin
  FDib := TBitmap32.Create;
  FGlyphs := TsdOcrGlyphList.Create(True);// own em
  FGroups := TsdOcrGroupList.Create(True);
  FBars := TsdOcrBarList.Create(True);
  FTrainers := TsdOcrTrainerList.Create(True);
  FLines := TsdOcrLineList.Create(True);
  FMap := TByteMap.Create;
  // Defaults
  FAdaptiveTreshold   := False;
  FAllowSlowSearch    := False;
  FAutoAspectCorrect  := False;
  FIncludeSpaces      := False;
  FMapConversion      := ctWeightedRGB;
  FMinConfidence      := 0.35; //0.65
  FMaxGlyphHeight     := 40.0;
  FMaxGlyphWidth      := 30.0;
  FMinGlyphHeight     := 12;
  FMinGlyphWidth      := 7;
  FMinGlyphPointCount := 30;
  FMinGroupLength     := 2;
  FMaxTextRotation    := 20.0;
  FDeskewStepCount    := 15;
  FTrainerTolerance   := 0.04;
  FTresholdType       := cttDual;
  FTreshold           := 155;
  FTresholdLo         := 135;
//  FRecognitionMethod  := crmBitmap;
  FRecognitionMethod  := crmPolygon;
 // FAbsoluteThresholding := True;
end;

destructor TsdOcrModule.Destroy;
begin
  FDib.Free;
  FGlyphs.Free;
  FGroups.Free;
  FLines.Free;
  FBars.Free;
  FTrainers.Free;
  FMap.Free;
  inherited;
end;

procedure TsdOcrModule.DoDebugMessage(AMessage: string);
begin
  if assigned(FOnDebugMessage) then
    FOnDebugMessage(Self, AMessage);
end;

procedure TsdOcrModule.DoTextChanged;
begin
  if assigned(FOnTextChanged) then
    FOnTextChanged(Self);
end;

procedure TsdOcrModule.ExtractGlyphs;
// Analyse the image and extract all possible lineclouds as glyphs
var
  AFilter: TList;
  i: integer;
  Bar: TsdOcrBar;
begin
  // Treshold the map into OcrPoints
  AFilter := TList.Create;
  try
    // Treshold the map
    case TresholdType of
    cttSingle:
      begin
        TresholdMapSingle;
        DoDebugMessage(Format('--Found %d points above treshold %d', [Bars.Count, Treshold]));
      end;
    cttDual:
      begin
        TresholdMapDual;
        DoDebugMessage(Format('--Found %d points with treshold %d/%d', [Bars.Count, TresholdLo, Treshold]));
      end;
    end;

    // Filter pointlist, add points with range [2, 20] to the filter list
    // FilterPointlist(2, 20, AFilter);
    FilterPointlist(2, 50, AFilter);
    DoDebugMessage(Format('--Filtered downto %d points in interval [%d, %d]',
      [AFilter.Count, 2, 20]));
    // Draw these
    if assigned(FOnDrawLine) then
      for i := 0 to AFilter.Count - 1 do
      begin
        Bar := TsdOcrBar(AFilter[i]);
        if Bar.IsHorizontal then
          FOnDrawLine(Self, Bar.Lo, Bar.Line, Bar.Hi, Bar.Line, clLtGray)
        else
          FOnDrawLine(Self, Bar.Line, Bar.Lo, Bar.Line, Bar.Hi, clLtGray);
      end;

    // Give each of the interconnecting clusters of transition points found a
    // Glyph number
    BuildGlyphs(AFilter, FMap);

    // Calculate the extremes of each bar and the bounding box of the glyphs
    for i := 0 to Glyphs.Count - 1 do
      Glyphs[i].CalculatePoints(FMap, Treshold);
    DoDebugMessage('--Calculated glyph points');

    // Filter glyphs that are outside of spec
    FilterGlyphsOnSizeAndBarcount;
    DoDebugMessage(Format('--Filtered downto %d glyphs', [Glyphs.Count]));

    // Sort them by Bounds.top
    SortList(FGlyphs, @SortGlyphsByTop, nil);

  finally
    AFilter.Free;
  end;
end;

procedure TsdOcrModule.FilterGlyphsOnSizeAndBarcount;
// Check all glyphs and delete the ones we do not want
var
  i: integer;
begin
  if MaxGlyphHeight > 0 then
    for i := Glyphs.Count - 1 downto 0 do
      if Glyphs[i].Height > MaxGlyphHeight then
        Glyphs.Delete(i);
  if MinGlyphHeight > 0 then
    for i := Glyphs.Count - 1 downto 0 do
      if Glyphs[i].Height < MinGlyphHeight then
        Glyphs.Delete(i);
  if MaxGlyphwidth > 0 then
    for i := Glyphs.Count - 1 downto 0 do
      if Glyphs[i].Width > MaxGlyphWidth then
        Glyphs.Delete(i);
  if MinGlyphwidth > 0 then
    for i := Glyphs.Count - 1 downto 0 do
      if Glyphs[i].Width < MinGlyphWidth then
        Glyphs.Delete(i);
  if MinGlyphPointCount > 0 then
    for i := Glyphs.Count - 1 downto 0 do
      if Glyphs[i].PointCount < MinGlyphPointcount then
        Glyphs.Delete(i);
end;

procedure TsdOcrModule.FilterPointlist(ALow, AHigh: integer; Filter: TList);
// Examine all points and throw away points that have a width smaller than
// ALow, and points that have a width higher than AHigh
var
  i: integer;
  ABar: TsdOcrBar;
  AWidth: integer;
begin
  for i := Bars.Count - 1 downto 0 do
  begin
    ABar := Bars[i];
    AWidth := ABar.Hi - ABar.Lo + 1;
    if (AWidth >= ALow) and (AWidth <= AHigh) then
      Filter.Add(ABar);
  end;
end;

function TsdOcrModule.GetGroupedGlyphCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Groups.Count - 1 do
    inc(Result, Groups[i].Glyphs.Count);
end;

function TsdOcrModule.GetText: widestring;
var
  i: integer;
  CR: widechar;
begin
  Result := '';
  CR := #13;
  for i := 0 to Lines.Count - 1 do
  begin
    Result := Result + Lines[i].Text;
    if i < Lines.Count - 1 then
      Result := Result + CR;
  end;
end;

procedure TsdOcrModule.GroupGlyphs;
// Each glyph gets a group number, glyphs with the same group number are neighbours
// in a viewing "bowtie" of 20deg up/down from text direction for at least one baseline,
// and 3x height in both directions
var
  i, j, k: integer;
  V: TFloatPoint;
  AMin, AMax, ADir: single;
  AGroupId, TempId: integer;
  AGroup: TsdOcrGroup;
begin
  AMax := FTextDirection + 20;
  AMin := FTextDirection - 20;
  AGroupId := 0;

  // Reset
  for i := 0 to Glyphs.Count - 1 do
    Glyphs[i].GroupId := -1;

  // Loop through glyphs, and neighbours
  for i := 0 to Glyphs.Count - 1 do
  begin
    Glyphs[i].GroupId := AGroupId;
    for j := 0 to Glyphs.Count - 1 do
      if i <> j then
      begin
        // Topline
        // Baseline
        V.X := Glyphs[j].BottomCenter.X - Glyphs[i].BottomCenter.X;
        V.Y := Glyphs[j].BottomCenter.Y - Glyphs[i].BottomCenter.Y;
        if V.X = 0 then
          continue;
        ADir := ArcTan(V.Y / V.X) * 180 / pi; // between -0.5pi and +0.5pi
        if ((ADir < AMax) and (ADir > AMin)) then
          // Valid direction, check distance
          if FloatLength(V) < 3 * Max(Glyphs[i].Height, Glyphs[j].Height) then
          begin
            // Within bowtie, so it belongs to the same group...
            // If the glyph j was not yet assigned, its our group
            if Glyphs[j].GroupId = -1 then
              Glyphs[j].GroupId := Glyphs[i].GroupId;
            // If it has a number smaller than ours.. we should be part of that group
            if Glyphs[j].GroupId < Glyphs[i].GroupId then
            begin
              TempId := Glyphs[i].GroupId;
              for k := 0 to Glyphs.Count - 1 do
                if Glyphs[k].GroupId = TempId then
                  Glyphs[k].GroupId := Glyphs[j].GroupId;
            end;
          end;
      end;
    // Next group number
    if Glyphs[i].GroupId = AGroupId then
      inc(AGroupId);
  end;

  // We now have the group numbers - we can now create the groups
  FGroups.Clear;
  for i := 0 to AGroupId - 1 do
  begin
    AGroup := TsdOcrGroup.Create(Self);
    Groups.Add(AGroup);
    for j := 0 to Glyphs.Count - 1 do
      if Glyphs[j].GroupId = i then
        AGroup.Glyphs.Add(Glyphs[j]);
    // Sort them
    AGroup.SortGlyphsByDirection(TextDirection);
  end;
end;

function TsdOcrModule.LineAdd(ALine: TsdOcrLine): integer;
begin
  Result := -1;
  if assigned(FLines) and assigned(ALine) then
    Result := FLines.Add(ALine);
end;

procedure TsdOcrModule.LoadFromFile(const AFilename: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(AFilename, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TsdOcrModule.LoadFromStream(S: TStream);
var
  ADoc: TNativeXml;
begin
  ADoc := TNativeXml.Create;//(nil);
  try
    ADoc.LoadFromStream(S);
    if not assigned(ADoc.Root) or (ADoc.Root.Name <> 'OcrModule') then
      raise Exception.Create('Not a valid trainer file');
    LoadFromXml(ADoc.Root);
  finally
    ADoc.Free;
  end;
end;

procedure TsdOcrModule.LoadFromXml(ANode: TXmlNode);
var
  i: integer;
  AChild: TXmlNode;
  Nodes: TList;
  Trainer: TsdOcrTrainer;
begin
  // Load settings
  AChild := ANode.NodeByName('Settings');
  if assigned(AChild) then
    LoadSettingsFromXml(AChild);
  // Load trainers
  FTrainers.Clear;
  AChild := ANode.NodeByName('Trainers');
  if assigned(AChild) then
  begin
    Nodes := TList.Create;
    try
      AChild.NodesByName('Trainer', Nodes);
      for i := 0 to Nodes.Count - 1 do
      begin
        Trainer := TsdOcrTrainer.Create(Self);
        Trainer.LoadFromXml(Nodes[i]);
        Trainers.Add(Trainer);
      end;
    finally
      Nodes.Free;
    end;
  end;
end;

procedure TsdOcrModule.LoadSettingsFromXml(ANode: TXmlNode);
begin
  FAdaptiveTreshold := ANode.ReadBool('AdaptiveTreshold', FAdaptiveTreshold);
  //  FAllowSlowSearch: boolean;// If true, bruteforce search methods are used in some cases (Default = false)
  //  FAutoAspectCorrect: boolean; // Correct aspect ratio with a bias (default = false)
  //  FGroupwiseDeskew: boolean;// If true, deskew in Y for complete group instead individually
  //  FIncludeSpaces: boolean;  // Include spaces in the final lines of text (if characters are spaced)
  //  FMapConversion: TConversionType;
  FMinConfidence := ANode.ReadFloat('MinConfidence', FMinConfidence);
  FMinGlyphHeight := ANode.ReadFloat('MinGlyphHeight', FMinGlyphHeight);
  FMaxGlyphHeight := ANode.ReadFloat('MaxGlyphHeight',  FMaxGlyphHeight);
  FMinGlyphWidth := ANode.ReadFloat('MinGlyphWidth', FMinGlyphWidth);
  FMaxGlyphWidth := ANode.ReadFloat('MaxGlyphWidth',  FMaxGlyphWidth);
  FMinGlyphPointCount := ANode.ReadInteger('MinGlyphPointCount',  FMinGlyphPointCount);
  FMinGroupLength := ANode.ReadInteger('MinGroupLength',  FMinGroupLength);
  FMaxTextRotation := ANode.ReadFloat('MaxTextRotation', FMaxTextRotation);
  FDeskewStepCount := ANode.ReadInteger('DeskewStepCount',  FDeskewStepCount);
  FRecognitionMethod := TRecognitionMethodType(ANode.ReadInteger('RecognitionMethod',  integer(FRecognitionMethod)));
  FTrainerTolerance := ANode.ReadFloat('TrainerTolerance',  FTrainerTolerance);
  FTresholdType := TsdOcrTresholdType(ANode.ReadInteger('TresholdType',  integer(FTresholdType)));
  FTreshold := ANode.ReadInteger('Treshold',  FTreshold);
  FTresholdLo := ANode.ReadInteger('TresholdLo',  FTresholdLo);
end;

procedure TsdOcrModule.PlotGlyphs(Color: TColor);
var
  i, j: integer;
  Glyph: TsdOcrGlyph;
begin
  if not assigned(FOnDrawDot) then
    exit;
  for i := 0 to Glyphs.Count - 1 do
  begin
    Glyph := Glyphs[i];
    // Draw bounding box
    FOnDrawLine(Self, Glyph.Bounds.Left,  Glyph.Bounds.Top,    Glyph.Bounds.Right, Glyph.Bounds.Top,    Color);
    FOnDrawLine(Self, Glyph.Bounds.Right, Glyph.Bounds.Top,    Glyph.Bounds.Right, Glyph.Bounds.Bottom, Color);
    FOnDrawLine(Self, Glyph.Bounds.Right, Glyph.Bounds.Bottom, Glyph.Bounds.Left,  Glyph.Bounds.Bottom, Color);
    FOnDrawLine(Self, Glyph.Bounds.Left,  Glyph.Bounds.Bottom, Glyph.Bounds.Left,  Glyph.Bounds.Top,    Color);
    // Draw dots
    for j := 0 to Glyph.PointCount - 1 do
      FOnDrawDot(Self, Glyph.Points[j].X, Glyph.Points[j].Y, clRed);
    // Draw character
    if assigned(Glyph.Trainer) and (Glyph.Score > MinConfidence) then
    begin
      FOnDrawChar(Self, Glyph.Bounds.Left, Glyph.Bounds.Top, 'Courier New', Glyph.Trainer.Character, 12);
    end;
  end;
end;

procedure TsdOcrModule.Recognise;
begin
  RecogniseRect(Rect(0, 0, FDib.Width, FDib.Height));
end;

procedure TsdOcrModule.RecogniseRect(ARect: TRect);
var
  i, j: integer;
  ALine: TsdOcrLine;
  AChar: widechar;
  ASkewX: single;
  Tick: dword;
  SkewYSuccess: integer;
  GroupFound: boolean;
  Group: TsdOcrGroup;
begin
  DoDebugMessage('Recognise: starting recognition');
  Tick := GetTickCount;
  // Clear previous results (if any)
  ClearGlyphsAndTexts;

  // Check for limits
  ARect.Left   := Max(0, ARect.Left);
  ARect.Right  := Min(FDib.Width, ARect.Right);
  ARect.Top    := Max(0, ARect.Top);
  ARect.Bottom := Min(FDib.Height, ARect.Bottom);
  if IsRectEmpty(ARect) then exit;

  // Create the byte map with the grayscale image
  DoDebugMessage('Recognise: building map');
  BuildIntensityMap(ARect);

  // Extract the glyphs
  DoDebugMessage('Recognise: extracting glyphs');
  ExtractGlyphs;

  // Make a plot of these glyphs
  PlotGlyphs(clBlue);

  // Group them
  DoDebugMessage('Recognise: grouping glyphs');
  GroupGlyphs;

  // Remove groups with length smaller than MinGroupLength
  DoDebugMessage('Recognise: removing irrelevant groups');
  for i := Groups.Count - 1 downto 0 do
    if Groups[i].Glyphs.Count < MinGroupLength then
    begin
      FGroups.Delete(i);
    end;
  DoDebugMessage(Format('Recognise: filtered down to %d groups with %d glyphs',
    [Groups.Count, GroupedGlyphCount]));

  // Recognise the glyphs
  GroupFound := False;
  for i := 0 to Groups.Count - 1 do
  begin
    Group := Groups[i];
    // Mean skew X
    ASkewX := Group.SkewX;
    for j := 0 to Group.Glyphs.Count - 1 do
      // Set the SkewX for the glyph to -ASkewX to compensate for skew of the group
      Group.Glyphs[j].SkewX := -ASkewX;

    // New method: find skew Y for most glyphs, predict others.. if this does not
    // work then we will do individual skew finding
    SkewYSuccess := 0;
    Group.UseBruteSkewY := True;
    for j := 0 to Group.Glyphs.Count - 1 do
    begin
      Group.Glyphs[j].FindSkewY;
      if Group.Glyphs[j].SkewYFound then
        inc(SkewYSuccess);
    end;
    if SkewYSuccess >= 2 then
    begin

      // Recognise the glyphs for which skew was found
      for j := Group.Glyphs.Count - 1 downto 0 do
      begin
        if Group.Glyphs[j].SkewYFound then
        begin
          Recognise;
          if Group.Glyphs[j].Score < MinConfidence then
            Group.Glyphs[j].SkewYFound := False;;
        end;
      end;

      // Count them again
      SkewYSuccess := 0;
      for j := 0 to Group.Glyphs.Count - 1 do
        if Group.Glyphs[j].SkewYFound then
          inc(SkewYSuccess);

      // If 2 or more, we will use the prediction method
      if SkewYSuccess >= 2 then
      begin
        Group.PredictSkewYForMissed;
        for j := 0 to Group.Glyphs.Count - 1 do
          if not Group.Glyphs[j].SkewYFound then
            Recognise;
        Group.UseBruteSkewY := False;
        GroupFound := True;
      end;

    end;
  end;

  if (not GroupFound) and AllowSlowSearch then
    for i := 0 to Groups.Count - 1 do
    begin
      Group := Groups[i];
      // Do we need to use the brute force method?
      if Group.UseBruteSkewY then
      begin
        // How do we handle SkewY?
        if GroupwiseDeskew then
        begin
          // Recognise for whole group
          Group.RecogniseSkewYRange(SkewFromAngle(-MaxTextRotation), SkewFromAngle(MaxTextRotation), DeskewStepCount);
        end else
        begin
          // We deskew each glyph individually, so recognise a range in skewY
          for j := 0 to Group.Glyphs.Count - 1 do
            // Recognise the best in range for SkewY in [-0.36, 0.36], for StepCount skews
            Group.Glyphs[j].RecogniseSkewYRange(SkewFromAngle(-MaxTextRotation), SkewFromAngle(MaxTextRotation),
              DeskewStepCount);
        end;
      end;
    end;

  // Unrecognised glyphs should be removed from group, probably edges etc.
  for i := Groups.Count - 1 downto 0 do
  begin
    // Remove unrecognised glyphs from groups
    for j := Groups[i].Glyphs.Count - 1 downto 0 do
      if Groups[i].Glyphs[j].Score < MinConfidence then
        Groups[i].Glyphs.Delete(j);
    // remove irrelevant groups once again
    if Groups[i].Glyphs.Count < MinGroupLength then
      FGroups.Delete(i);
  end;

  // Optimize recognition with AspectBias
  if AutoAspectCorrect then
    for i := 0 to Groups.Count - 1 do
    begin
      Group := Groups[i];
      Group.CorrectAspect;
      //CorrectSkewY; // this concept did not prove to be useful
      for j := 0 to Group.Glyphs.Count - 1 do
        Group.Glyphs[j].Recognise;
    end;

  DoDebugMessage(Format('Recognise: recognised %d groups with %d glyphs',
    [Groups.Count, GroupedGlyphCount]));

  // Show texts
  FLines.Clear;
  for i := 0 to Groups.Count - 1 do
  begin
    ALine := TsdOcrLine.Create;
    for j := 0 to Groups[i].Glyphs.Count - 1 do
    begin
      // Include spaces?
      if IncludeSpaces and (j > 0) then
        if (Groups[i].Glyphs[j].BottomCenter.X - Groups[i].Glyphs[j - 1].BottomCenter.X -
          0.5 * (Groups[i].Glyphs[j - 1].Width + Groups[i].Glyphs[j].Width)) > 0.35 * Groups[i].Glyphs[j - 1].Height then
          ALine.Text := ALine.Text + ' ';
      AChar := Groups[i].Glyphs[j].Character;
      if AChar <> #0 then
        ALine.Text := ALine.Text + AChar;
    end;
    LineAdd(ALine);
  end;
  DoDebugMessage(Format('Recognise: recognition took %d msec', [GetTickCount - Tick]));

  // Plot the glyphs on the screen
  PlotGlyphs(clGreen);
end;

procedure TsdOcrModule.ResetTrainers;
var
  i: integer;
begin
  for i := 0 to Trainers.Count - 1 do
    Trainers[i].Reset;
end;

procedure TsdOcrModule.SaveSettingsToXml(ANode: TXmlNode);
begin
  ANode.WriteBool('AdaptiveTreshold', FAdaptiveTreshold);
  //  FAllowSlowSearch: boolean;// If true, bruteforce search methods are used in some cases (Default = false)
  //  FAutoAspectCorrect: boolean; // Correct aspect ratio with a bias (default = false)
  //  FGroupwiseDeskew: boolean;// If true, deskew in Y for complete group instead individually
  //  FIncludeSpaces: boolean;  // Include spaces in the final lines of text (if characters are spaced)
  //  FMapConversion: TConversionType;
  ANode.WriteFloat('MinConfidence', FMinConfidence);
  ANode.WriteFloat('MinGlyphHeight', FMinGlyphHeight);
  ANode.WriteFloat('MaxGlyphHeight',  FMaxGlyphHeight);
  ANode.WriteFloat('MinGlyphWidth', FMinGlyphWidth);
  ANode.WriteFloat('MaxGlyphWidth',  FMaxGlyphWidth);
  ANode.WriteInteger('MinGlyphPointCount',  FMinGlyphPointCount);
  ANode.WriteInteger('MinGroupLength',  FMinGroupLength);
  ANode.WriteFloat('MaxTextRotation', FMaxTextRotation);
  ANode.WriteInteger('DeskewStepCount',  FDeskewStepCount);
  ANode.WriteInteger('RecognitionMethod',  integer(FRecognitionMethod));
  ANode.WriteFloat('TrainerTolerance',  FTrainerTolerance);
  ANode.WriteInteger('TresholdType',  integer(FTresholdType));
  ANode.WriteInteger('Treshold',  FTreshold);
  ANode.WriteInteger('TresholdLo',  FTresholdLo);
end;

procedure TsdOcrModule.SaveToFile(const AFilename: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TsdOcrModule.SaveToStream(S: TStream);
var
  ADoc: TNativeXml;
begin
  ADoc := TNativeXml.CreateName('OcrModule');
  try
    SaveToXml(ADoc.Root);
    ADoc.XmlFormat := xfReadable;
    ADoc.SaveToStream(S);
  finally
    ADoc.Free;
  end;
end;

procedure TsdOcrModule.SaveToXml(ANode: TXmlNode);
var
  i: integer;
  AChild: TXmlNode;
begin
  // Save settings
  SaveSettingsToXml(ANode.NodeNew('Settings'));
  // Save trainers
  AChild := ANode.NodeNew('Trainers');
  for i := 0 to Trainers.Count - 1 do
    Trainers[i].SaveToXml(AChild.NodeNew('Trainer'));
end;

procedure TsdOcrModule.SetTrainerTolerance(ATol: single);
var
  i: integer;
begin
  FTrainerTolerance := ATol;
  for i := 0 to Trainers.Count - 1 do
    Trainers[i].SetTolerance(ATol);
end;

function TsdOcrModule.SkewFromAngle(Angle: single): single;
begin
  Result := tan(Angle / 180 * pi);
end;

procedure TsdOcrModule.TresholdMapDual;
// Add all start/endpoints that come above the high treshold, and stay above the low
// treshold. In both horizontal/vertical directions. This is a kind of adaptive treshold
var
  r, c, r2, c2: integer;
  Inside: boolean;
  ABar: TsdOcrBar;
begin
  ABar := nil;
  // Horizontal points
  for r := 0 to FMap.Height - 1 do
  begin
    c := 0;
    Inside := False;
    while c < FMap.Width do
    begin
      if Inside then
      begin
        if FMap[c, r] < TresholdLo then
        begin
          c2 := c - 1;
          while (c2 > ABar.Lo) and (FMap[c2, r] < Treshold) do
            dec(c2);
          ABar.Hi := c2;
          BarAdd(ABar);
          Inside := False;
        end;
      end else
      begin
        if FMap[c, r] > Treshold then
        begin
          ABar := TsdOcrBar.Create(True);
          ABar.Line := r;
          ABar.Lo := c;
          Inside := True;
        end;
      end;
      inc(c);
    end;
    if Inside then
    begin
      ABar.Hi := FMap.Width - 1;
      BarAdd(ABar);
    end;
  end;
  // Vertical points
  for c := 0 to FMap.Width - 1 do
  begin
    r := 0;
    Inside := False;
    while r < FMap.Height do
    begin
      if Inside then
      begin
        if FMap[c, r] < TresholdLo then
        begin
          r2 := r - 1;
          while (r2 > ABar.Lo) and (FMap[c, r2] < Treshold) do
            dec(r2);
          ABar.Hi := r2;
          BarAdd(ABar);
          Inside := False;
        end;
      end else
      begin
        if FMap[c, r] > Treshold then
        begin
          ABar := TsdOcrBar.Create(False);
          ABar.Line := c;
          ABar.Lo := r;
          Inside := True;
        end;
      end;
      inc(r);
    end;
    if Inside then
    begin
      ABar.Hi := FMap.Height - 1;
      BarAdd(ABar);
    end;
  end;
end;

procedure TsdOcrModule.TresholdMapSingle;
// Add all start/endpoints that are above the treshold, in both horizontal
// as well as vertical directions.
var
  r, c: integer;
  Inside: boolean;
  ABar: TsdOcrBar;
begin
  ABar := nil;
  // Horizontal points
  for r := 0 to FMap.Height - 1 do
  begin
    c := 0;
    Inside := False;
    while c < FMap.Width do
    begin
      if Inside then
      begin
        if FMap[c, r] < Treshold then
        begin
          ABar.Hi := c - 1;
          BarAdd(ABar);
          Inside := False;
        end;
      end else
      begin
        if FMap[c, r] > Treshold then
        begin
          ABar := TsdOcrBar.Create(True);
          ABar.Line := r;
          ABar.Lo := c;
          Inside := True;
        end;
      end;
      inc(c);
    end;
    if Inside then
    begin
      ABar.Hi := FMap.Width - 1;
      BarAdd(ABar);
    end;
  end;
  // Vertical points
  for c := 0 to FMap.Width - 1 do
  begin
    r := 0;
    Inside := False;
    while r < FMap.Height do
    begin
      if Inside then
      begin
        if FMap[c, r] < Treshold then
        begin
          ABar.Hi := r - 1;
          BarAdd(ABar);
          Inside := False;
        end;
      end else
      begin
        if FMap[c, r] > Treshold then
        begin
          ABar := TsdOcrBar.Create(False);
          ABar.Line := c;
          ABar.Lo := r;
          Inside := True;
        end;
      end;
      inc(r);
    end;
    if Inside then
    begin
      ABar.Hi := FMap.Height - 1;
      BarAdd(ABar);
    end;
  end;
end;

{ TsdOcrGlyph }

function TsdOcrGlyph.BarAdd(ABar: TsdOcrBar): integer;
begin
  Result := -1;
  if assigned(FBars) and assigned(ABar) then
    Result := FBars.Add(ABar);
end;

procedure TsdOcrGlyph.CalculatePoints(Map: TByteMap; Treshold: byte);
var
  i: integer;
  P1, P2, C: TFloatPoint;
// Add edges of the bar and centers to the point list
begin
  // Edges
  for i := 0 to BarCount - 1 do
  begin
    Bars[i].CalculateEdges(Map, Treshold, P1, P2);
    PointAdd(P1);
    PointAdd(P2);
  end;
  FEdges.Clear;
  for i := 0 to PointCount - 1 do
    FEdges.Add(pointer(i));
  // Centers
  for i := 0 to BarCount - 1 do
  begin
    Bars[i].CalculateCenter(Map, C);
    PointAdd(C);
  end;
end;

constructor TsdOcrGlyph.Create(AOwner: TsdOcrModule);
begin
  inherited Create;
  FOwner := AOwner;
  FCandidates := TsdOcrCandidateList.Create(False); // dont own
  FBars := TList.Create;
  FEdges := TList.Create;
  // Defaults
  FSkewX := 0.0;
  FSkewY := 0.0;
end;

destructor TsdOcrGlyph.Destroy;
begin
  FreeAndNil(FCandidates);
  FreeAndNil(FBars);
  FreeAndNil(FEdges);
  inherited;
end;

procedure TsdOcrGlyph.FindSkewY;
// Find the SkewY from the glyph points, and return True if successful
const
  cPartCount = 5;
  cStripCount = 3 * cPartCount;
var
  i, ilo, ihi: integer;
  Strips: array[0..cStripCount - 1, 0..1] of single;
  StripCount: array[0..cStripCount - 1] of integer;
  ABase, AMult: single;
  Strip: integer;
  WidthLo, WidthHi, W: single;
  IndexLo, IndexHi: integer;
begin
  SkewYFound := False;
  SkewY := 0;
  if EdgeCount = 0 then
    exit;

  // Prepare
  SetLength(FScaled, PointCount);
  for i := 0 to cStripCount - 1 do
    StripCount[i] := 0;
  // Copy to a scaled version (only edges)
  for i := 0 to EdgeCount - 1 do
    FScaled[i] := FPoints[i];
  // Do SkewX
  Skew(SkewX, 0, FScaled, EdgeCount);
  // Sort edge points on Y using quicksort
  SortList(FEdges, @SortEdgesByY, Self);

  // Histogram and strip data
  ABase   := Edges[0].Y;
  AMult := cStripCount / (Edges[EdgeCount - 1].Y - ABase + 0.001);
  for i := 0 to EdgeCount - 1 do
  begin
    Strip := trunc((Edges[i].Y - ABase) * AMult);
    if StripCount[Strip] = 0 then
    begin
      Strips[Strip][0] := Edges[i].X;
      Strips[Strip][1] := Edges[i].X;
    end else
    begin
      Strips[Strip][0] := Min(Strips[Strip][0], Edges[i].X);
      Strips[Strip][1] := Max(Strips[Strip][1], Edges[i].X);
    end;
    inc(StripCount[Strip]);
  end;

  // the first 1/3 strips will produce WidthLo, the last 1/3 will produce WidthHi
  WidthLo := 0.0;
  WidthHi := 0.0;
  IndexLo := 0;
  IndexHi := 0;
  for ilo := 0 to cPartCount - 1 do
  begin
    ihi := ilo + 2 * cPartCount;
    if StripCount[ilo] >= 2 then
    begin
      W := Strips[ilo][1] - Strips[ilo][0];
      if WidthLo < W then
      begin
        WidthLo := W;
        IndexLo := ilo;
      end;
    end;
    if StripCount[ihi] >= 2 then
    begin
      W := Strips[ihi][1] - Strips[ihi][0];
      if WidthHi < W then
      begin
        WidthHi := W;
        IndexHi := ihi;
      end;
    end;
  end;

  // Allrighto, now compare these - if nearly identical then we're done
  if (WidthLo = 0) or (WidthHi = 0) or
     (Max(WidthLo, WidthHi) / Min(WidthLo, WidthHi) > 1.5) then
       exit;

  // We arrive here, which means we can safely calculate the SkewY
  SkewYFound := True;
  SkewY :=
    ((Strips[IndexLo][1] + Strips[IndexLo][0] - Strips[IndexHi][1] - Strips[IndexHi][0]) * 0.5) / // DeltaX
    ((Edges[EdgeCount - 1].Y - Edges[0].Y) * (IndexHi - IndexLo) / cStripCount); // DeltaY
end;

function TsdOcrGlyph.GetBarCount: integer;
begin
  Result := 0;
  if assigned(FBars) then
    Result := FBars.Count;
end;

function TsdOcrGlyph.GetBars(Index: integer): TsdOcrBar;
begin
  Result := nil;
  if (Index >= 0) and (Index < BarCount) then
    Result := TsdOcrBar(FBars[Index]);
end;

function TsdOcrGlyph.GetBottomCenter: TFloatPoint;
begin
  Result.X := (FBounds.Right + FBounds.Left) / 2;
  Result.Y := FBounds.Bottom;
end;

function TsdOcrGlyph.GetCharacter: widechar;
begin
  Result := #0;
  if assigned(Trainer) then
    Result := Trainer.Character;
end;

function TsdOcrGlyph.GetEdgeCount: integer;
begin
  Result := 0;
  if assigned(FEdges) then Result := FEdges.Count;
end;

function TsdOcrGlyph.GetEdges(Index: integer): TFloatPoint;
begin
  if (Index >= 0) and (Index < EdgeCount) then
    Result := FScaled[integer(FEdges[Index])]
  else
    Result := FloatPoint(0, 0);
end;

function TsdOcrGlyph.GetFillPercent: single;
// Return the % of pixels in the glyph that is above treshold
var
  i, j, Count, Size: integer;
  R: TRect;
  AMap: TByteMap;
begin
  Result := 0;
  // Check
  if BarCount = 0 then
    exit;
  // Integer bounding box
  for i := 0 to BarCount - 1 do
  begin
    if i = 0 then
    begin
      if Bars[i].IsHorizontal then
      begin
        R.Left := Bars[i].Lo;
        R.Right := Bars[i].Hi;
        R.Top := Bars[i].Line;
        R.Bottom := Bars[i].Line;
      end else
      begin
        R.Left := Bars[i].Line;
        R.Right := Bars[i].Line;
        R.Top := Bars[i].Lo;
        R.Bottom := Bars[i].Hi;
      end;
    end else
    begin
      if Bars[i].IsHorizontal then
      begin
        R.Left   := Min(R.Left, Bars[i].Lo);
        R.Right  := Max(R.Right, Bars[i].Hi);
        R.Top    := Min(R.Top, Bars[i].Line);
        R.Bottom := Max(R.Bottom, Bars[i].Line);
      end else
      begin
        R.Left   := Min(R.Left, Bars[i].Line);
        R.Right  := Max(R.Right, Bars[i].Line);
        R.Top    := Min(R.Top, Bars[i].Lo);
        R.Bottom := Max(R.Bottom, Bars[i].Hi);
      end;
    end;
  end;
  // Create bytemap
  AMap := TByteMap.Create;
  try
    AMap.SetSize(R.Right - R.Left + 1, R.Bottom - R.Top + 1);
    // Set values
    for i := 0 to BarCount - 1 do
      if Bars[i].IsHorizontal then
      begin
        for j := Bars[i].Lo to Bars[i].Hi do
          AMap[j - R.Left, Bars[i].Line - R.Top] := 1;
      end else
      begin
        for j := Bars[i].Lo to Bars[i].Hi do
          AMap[Bars[i].Line - R.Left, j - R.Top] := 1;
      end;
    // Count the ones
    Count := 0;
    Size := AMap.Width * AMap.Height;
    for i := 0 to Size - 1 do
      if AMap.Bits[i] > 0 then
        inc(Count);
    // Now we can return the result
    Result := Count / Size;
  finally
    AMap.Free;
  end;
end;

function TsdOcrGlyph.GetHeight: single;
begin
  Result := Bounds.Bottom - Bounds.Top;
end;

function TsdOcrGlyph.GetPointCount: integer;
begin
  Result := Length(FPoints);
end;

function TsdOcrGlyph.GetPoints(Index: integer): TFloatPoint;
begin
  if (Index >= 0) and (Index < Length(FPoints)) then
    Result := FPoints[Index]
  else
    Result := FloatPoint(0, 0);
end;

function TsdOcrGlyph.GetScaledPoints(Index: integer): TFloatPoint;
begin
  if (Index >= 0) and (Index < Length(FScaled)) then
    Result := FScaled[Index]
  else
    Result := FloatPoint(0, 0);
end;

function TsdOcrGlyph.GetTopCenter: TFloatPoint;
begin
  Result.X := (FBounds.Right + FBounds.Left) / 2;
  Result.Y := FBounds.Top;
end;

function TsdOcrGlyph.GetWidth: single;
begin
  Result := Bounds.Right - Bounds.Left;
end;

procedure TsdOcrGlyph.PointAdd(APoint: TFloatPoint);
var
  L: integer;
  PX, PY: single;
begin
  L := PointCount;
  SetLength(FPoints, L + 1);
  FPoints[L] := APoint;
  PX := FPoints[L].X;
  PY := FPoints[L].Y;
  // Determine new bounds
  if L = 0 then
  begin
    FBounds.Left   := PX;
    FBounds.Right  := PX;
    FBounds.Top    := PY;
    FBounds.Bottom := PY;
  end else
  begin
    FBounds.Left   := Min(Bounds.Left,   PX);
    FBounds.Right  := Max(Bounds.Right,  PX);
    FBounds.Top    := Min(Bounds.Top,    PY);
    FBounds.Bottom := Max(Bounds.Bottom, PY);
  end;
end;

procedure TsdOcrGlyph.Recognise;
begin
  case FOwner.RecognitionMethod of
  crmPolygon: RecognisePolygon;
  crmBitmap: RecogniseBitmap;
  end;
end;

procedure TsdOcrGlyph.RecogniseBitmap;
begin
  // Reverse-engineer a bitmap at the same size as the trainer's bmps

end;

procedure TsdOcrGlyph.RecognisePolygon;
// Try to recognise any of the trainers
var
  i, j, k: integer;
  ScoreCount: single;
  TempScore: single;
  BodyPoints: single;
  MaxNear, ANear: single;
  SegId, ASegment: integer;
  Included: TList;
  YVal: single;
  SegmentLength: single;
  VisitedLength: single;
  Aspect: single;
  TempDiff: single;
  RatioScore: single;
  EdgeScore: single;
  CmplScore: single;
  BodyScore: single;
  Candidate: TsdOcrCandidate;
  T: TsdOcrTrainer;
begin
  SetLength(FScaled, PointCount);
  FCandidates.Clear;

  // Copy to a scaled version, clear points used
  for i := 0 to PointCount - 1 do
    FScaled[i] := FPoints[i];

  // Do ScaleX, SkewX and SkewY
  Skew(SkewX, SkewY, FScaled, PointCount);

  // Normalize Y values between [0, 1] and X values between [0, 0.5]
  Normalize(FScaled, PointCount, Aspect);

  // Sort edge points on Y using quicksort
  SortList(FEdges, @SortEdgesByY, Self);

  // First of all, reset the trainers (their "visited" properties)
  FOwner.ResetTrainers;

  Score := 0;
  Trainer := nil;

  // Loop through the points and match them
  for i := 0 to FOwner.Trainers.Count - 1 do
  begin
    T := FOwner.Trainers[i];

    // Check edges
    ScoreCount := 0.0;
    Included := TList.Create;
    SegId := 0;
    try
      for j := 0 to EdgeCount - 1 do
      begin
        // Current Y value
        YVal := Edges[j].Y;

        // Include/exclude segments
        while (SegId < T.SegmentCount) and (T.Segments[SegId].Bounds.Top <= YVal) do
        begin
          Included.Add(pointer(SegId));
          inc(SegId);
        end;
        for k := Included.Count - 1 downto 0 do
        begin
          if T.Segments[integer(Included[k])].Bounds.Bottom < YVal then
            Included.Delete(k);
        end;

        // Test the segments for the closest
        MaxNear := 0;
        ASegment := -1;
        for k := 0 to Included.Count - 1 do
        begin
          ANear := T.Segments[integer(Included[k])].NearPoint(Edges[j]);
          if ANear > MaxNear then
          begin
            ASegment := integer(Included[k]);
            MaxNear := ANear;
          end;
        end;

        // Register score and visited
        if (ASegment = -1) then
        begin
          ScoreCount := ScoreCount + 0.5 * T.IsBodyPoint(FScaled[j]);
        end else begin
          ScoreCount := ScoreCount + MaxNear;
          with T.Segments[ASegment] do
            Visited := Max(Visited, MaxNear);
        end;
      end;

    finally
      Included.Free;
    end;

    // Check body points
    BodyPoints := 0;
    for j := EdgeCount to PointCount - 1 do
      BodyPoints := BodyPoints + T.IsbodyPoint(ScaledPoints[j]);

    // Determine visited and segment length for completion percentage
    SegmentLength := 0;
    VisitedLength := 0;
    if T.SegmentCount = 0 then
      SegmentLength := 1
    else
      for j := 0 to T.SegmentCount - 1 do
      begin
        SegmentLength := SegmentLength + T.Segments[j].Length;
        VisitedLength := VisitedLength + T.Segments[j].Visited * T.Segments[j].Length;
      end;

    // Aspect ratio check, compare the trainer's AspectRatio with our
    // calculated Aspect, they should be as close as possible. We compare
    // the difference of their exponents. If the aspect ratios relate 1:2 or
    // 2:1 then Factor goes to 0. If they relate 1:1 the factor is 1.
    TempDiff := log2(Aspect) - log2(T.AspectRatio) - AspectBias;

    // Scores, all between [0..1] 0 = bad, 1 = good
    RatioScore := Max(0, 1 - sqr(TempDiff));
    EdgeScore := ScoreCount / EdgeCount;                // Edge presence score
    CmplScore := VisitedLength / SegmentLength;         // Completeness score
    BodyScore := BodyPoints / (PointCount - EdgeCount); // Body presence score

    // Eventual score = 1.0 if absolute match, lower for less match.
    // The weights here are very important - was 0.22/0.56/0.22
{      TempScore := RatioScore * (
      0.22 * (ScoreCount / EdgeCount) +
      0.46 * (VisitedLength / SegmentLength) +
      0.32 * (BodyPoints / (PointCount - EdgeCount))
    );}
    // Find the best match by multiplication
    TempScore := RatioScore * EdgeScore * CmplScore * BodyScore;

    // Find highscore and best matching trainer
    if TempScore > Score then
    begin
      Score := TempScore;
      AspectDiff := TempDiff;
      Trainer := FOwner.Trainers[i];
    end;

    // Add to candidates
    if TempScore > Score - cAlternativeLimit then
    begin
      Candidate := TsdOcrCandidate.Create;
      Candidate.Trainer := FOwner.Trainers[i];
      Candidate.Score := TempScore;
      FCandidates.Add(Candidate);
    end;
  end;

  // Sift candidates
  for i := FCandidates.Count - 1 downto 0 do
    if FCandidates[i].Score < Score - cAlternativeLimit then
      FCandidates.Delete(i);
  SortList(FCandidates, SortCandidateByScore, nil);

end;

procedure TsdOcrGlyph.RecogniseSkewYRange(MinSkewY, MaxSkewY: single; Steps: integer);
// Do a total of Steps recognitions and choose best one. The
// Recognitions are done for various values of SkewY between MinSkewY and MaxSkewY
var
  DeltaSkewY: single;
  IdxSkewY: integer;
  BestScore: single;
  BestSkewY: single;
begin
  BestScore := 0.0;
  BestSkewY := 0.0;
  // Delta
  DeltaSkewY  := (MaxSkewY - MinSkewY ) / Steps;
  for IdxSkewY := 1 to Steps do
  begin
    SkewY  := MinSkewY + DeltaSkewY * (IdxSkewY - 0.5);
    Recognise;
    if Score > BestScore then
    begin
      BestScore := Score;
      BestSkewY := SkewY;
    end;
  end;
  // Repeat for the best one (to do: we could optimize this so that it finds
  // the maximum of the parabola through the best and neighbours)
  SkewY  := BestSkewY;
  Recognise;
end;

{ TsdOcrBar }

procedure TsdOcrBar.CalculateCenter(Map: TByteMap; var Center: TFloatPoint);
var
  c, r: integer;
  B: byte;
  Prod, Total: single;
begin
  Prod  := 0;
  Total := 0;
  if IsHorizontal then
  begin
    Center.Y := Line;
    for c := Lo to Hi do
    begin
      B := Map[c, Line];
      Prod  := Prod  + c * B;
      Total := Total + B;
    end;
    // Product divided by total gives center of gravity
    if Total > 0 then
      Center.X := Prod / Total;
  end else
  begin
    Center.X := Line;
    for r := Lo to Hi do
    begin
      B := Map[Line, r];
      Prod  := Prod  + r * B;
      Total := Total + B;
    end;
    // Product divided by total gives center of gravity
    if Total > 0 then
      Center.Y := Prod / Total;
  end;
end;

procedure TsdOcrBar.CalculateEdges(Map: TByteMap; Treshold: byte; var P1, P2: TFloatPoint);
const
  cBias = 1;
var
  A, B: integer;
// local
function MapValue(X, Y: integer): byte;
begin
  Result := 0;
  if (X >= 0) and (X < Map.Width) and (Y >= 0) and (Y < Map.Height) then
    Result := Map[X, Y];
end;
// main
begin
  if IsHorizontal then
  begin
    // Lo side
    A := MapValue(Lo - 1, Line);
    B := MapValue(Lo, Line);
    if A = B then
      P1.X := Lo
    else
      P1.X := Max(0, Min(1, (Treshold - A) / (B - A))) + Lo - 1;
    P1.Y := Line;
    // Hi Side
    A := MapValue(Hi, Line);
    B := MapValue(Hi + 1, Line);
    if A = B then
      P2.X := Hi
    else
      P2.X := Max(0, Min(1, (Treshold - A) / (B - A))) + Hi;
    P2.Y := Line;
  end else
  begin
    // Lo side
    A := MapValue(Line, Lo - 1);
    B := MapValue(Line, Lo);
    if A = B then
      P1.Y := Lo
    else
      P1.Y := Max(0, Min(1, (Treshold - A) / (B - A))) + Lo - 1;
    P1.X := Line;
    // Hi Side
    A := MapValue(Line, Hi);
    B := MapValue(Line, Hi + 1);
    if A = B then
      P2.Y := Hi
    else
      P2.Y := Max(0, Min(1, (Treshold - A) / (B - A))) + Hi;
    P2.X := Line;
  end;
end;

constructor TsdOcrBar.Create(AIsHorizontal: boolean);
begin
  inherited Create;
  FIsHorizontal := AIsHorizontal;
end;

{ TsdOcrTrainer }

procedure TsdOcrTrainer.BitmapPolygon;
// Create a map of the polygon that is used for detection of body points
var
  ADib: TBitmap32;
begin
  ADib := TBitmap32.Create;
  try
    // Draw to a TBitmap32
    ADib.SetSize(cDefaultTrainerPixelsX, cDefaultTrainerPixelsY);
    ADib.Clear(clBlack32);
    FPoly.DrawFill(ADib, clWhite32);
    // Copy this one to the map, use Red channel (could just as well be another)
    if assigned(FMap) then
      FMap.ReadFrom(ADib, ctRed);
  finally
    ADib.Free;
  end;
end;

procedure TsdOcrTrainer.BuildCharacter;
// Call this procedure to build a trainer from the inputted character/font combination
begin
  // Create the glyph outline in FPoly
  CreateGlyphOutline;

  // Normalize the polygon
  NormalizePolygon;

  // Create a map of this polygon
  BitmapPolygon;
end;

constructor TsdOcrTrainer.Create(AOwner: TsdOcrModule);
begin
  inherited Create;
  FOwner := AOwner;
  FPoly := TPolygon32.Create;
  FPoly.Antialiased := True;
  FSegments := TObjectList.Create;
  FMap := TByteMap.Create;
  FMap.SetSize(cDefaultTrainerPixelsX, cDefaultTrainerPixelsY);
  FMap.Clear(0);
  FAspectRatio := 1.0;
end;

procedure TsdOcrTrainer.CreateGlyphOutline;
const
  // Identity 2x2 matrix used in font transforms
  cUnityMat2: TMAT2 = (
    eM11: (fract: 0; Value: 1); eM12: (fract: 0; Value: 0);
    eM21: (fract: 0; Value: 0); eM22: (fract: 0; Value: 1));
var
  AMetrics: TGLYPHMETRICS;
  ABufSize: integer;
  ABuf: array[0..cGlyphBufSize - 1] of char;
  ARes: integer;
  ACanvas: TCanvas;
  AHDC: HDC;
begin
  FPoly.Clear;
  FSegments.Clear;
  ACanvas := TCanvas.Create;
  AHDC := CreateCompatibleDC(0);
  ACanvas.Handle := AHDC;
  ACanvas.Font.Name   := FFontName;
  ACanvas.Font.Style  := FFontStyle;
  ACanvas.Font.Height := 48;
  try
    // Get a buffer for the glyph data
    ABufSize := GetGlyphOutlineW(ACanvas.Handle, ord(FCharacter), GGO_NATIVE, AMetrics,
       0, nil, cUnityMat2);
    if ABufSize > cGlyphBufSize then
      raise Exception.Create('cGlyphBufSize too small. Change in sdOcr');

    if ABufSize > 0 then
    begin

      // Get the glyph outline
      ARes := GetGlyphOutlineW(ACanvas.Handle, ord(FCharacter), GGO_NATIVE, AMetrics,
        cGlyphBufSize, @ABuf, cUnityMat2);

      // Do we have an error?
      if (ARes = integer(GDI_ERROR)) or
         (PTTPolygonHeader(@ABuf)^.dwType <> TT_POLYGON_TYPE) then exit;

      // Convert to polygon
      GlyphToPolygon(@ABuf, ABufSize, AMetrics, FPoly);

    end;
  finally
    ACanvas.Free;
    DeleteDC(AHDC);
  end;
end;

destructor TsdOcrTrainer.Destroy;
begin
  FPoly.Free;
  FSegments.Free;
  FMap.Free;
  inherited;
end;

function TsdOcrTrainer.GetSegmentCount: integer;
begin
  Result := 0;
  if assigned(FSegments) then
    Result := FSegments.Count;
end;

function TsdOcrTrainer.GetSegments(Index: integer): TsdOcrSegment;
begin
  Result := nil;
  if (Index >= 0) and (Index < SegmentCount) then
    Result := TsdOcrSegment(FSegments[Index]);
end;

function TsdOcrTrainer.GetVertexCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to high(FPoly.Points) do
    Result := Result + Length(FPoly.Points[i]);
end;

procedure TsdOcrTrainer.GlyphToPolygon(Header: PTTPolygonHeader; BufSize: integer;
  Metrics: TGLYPHMETRICS; Poly: TPolygon32);
// Convert the Windows glyph information into a polygon
type
  // _Fixed Point array used for access to lowlevel windows structure
  TFXPArray = array[0..0] of TPOINTFX;
  PFXPArray = ^TFXPArray;
var
  i, j: integer;
  AOld, APoint, AStart, PtA, PtB, PtC: TFixedPoint;
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
    AStart.X := FixedFromW(Header^.pfxStart.X);
    AStart.Y := FixedFromW(Header^.pfxStart.Y);
    ASize := Header^.cb - SizeOf(TTTPOLYGONHEADER);
    APoint := AStart;

    // Curve points
    PChar(ACurve) := pChar(Header) + SizeOf(TTTPOLYGONHEADER);
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
          for i := 0 to ACurve^.cpfx - 1 do begin
            AOld := APoint;
            APoint.X := FixedFromW(AList^[i].X);
            APoint.Y := FixedFromW(AList^[i].Y);
            if not PointsAreEqual(AOld, APoint) then
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
            PtB.X := FixedFromW(AList^[i].X);
            PtB.Y := FixedFromW(AList^[i].Y);
            if i < ACurve^.cpfx - 2 then
            begin
              PtC.X := (FixedFromW(AList^[i + 1].X) + PtB.X) div 2;
              PtC.Y := (FixedFromW(AList^[i + 1].Y) + PtB.Y) div 2;
            end else
            begin
              PtC.X := FixedFromW(AList^[i + 1].X);
              PtC.Y := FixedFromW(AList^[i + 1].Y);
            end;
            // Regenerate this segment with additional polygon points
            RegenerateQSpline(ptA, ptB, ptC, Poly);
            PtA := PtC;
          end;
          APoint := PtC;
        end;
      end;//case

      // Move pointers
      ADelta := SizeOf(TTTPOLYCURVE) + (ACurve^.cpfx - 1) * SizeOf(TPOINTFX);
      inc(ACount, ADelta);
      PChar(ACurve) := PChar(ACurve) + ADelta;

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

  // The resulting polygon is upside-down.. fix it now
  for j := 0 to High(Poly.Points) do
    for i := 0 to High(Poly.Points[J]) do
      Poly.Points[J][I].Y := - Poly.Points[J][I].Y;
end;

function TsdOcrTrainer.IsBodyPoint(APoint: TFloatPoint): single;
// Returns 0 if completely out of the body or 1 if completely in
const
  // Biases included..
  MultX = 2 * (cDefaultTrainerPixelsX - 1);
  MultY =     (cDefaultTrainerPixelsY - 1);
var
  X, Y: integer;
begin
  X := round(APoint.X * MultX);
  Y := round(APoint.Y * MultY);
{  if (X < 0) or (X >= FMap.Width) or (Y < 0) or (Y >= FMap.Height) then
    raise Exception.Create('Point value out of range in "IsBodyPoint"');}
  Result := FMap[X, Y] / 255;
end;

procedure TsdOcrTrainer.LoadFromXml(ANode: TXmlNode);
// Load the polyline
var
  i, j: integer;
  APoly: TXmlNode;
  Lines, Points: TList;
  P: TFixedPoint;
begin
  // Load poly
  APoly := ANode.NodeByName('Polyline');
  FPoly.Clear;
  if assigned(APoly) then
  begin
    Lines := TList.Create;
    try
      APoly.NodesByName('Line', Lines);
      for i := 0 to Lines.Count - 1 do
      begin
        Points := TList.Create;
        try
          TXmlNode(Lines[i]).NodesByName('Point', Points);
          for j := 0 to Points.Count - 1 do
          begin
            P.X := TXmlNode(Points[j]).ReadInteger('X');
            P.Y := TXmlNode(Points[j]).ReadInteger('Y');
            FPoly.Add(P);
          end;
        finally
          Points.Free;
        end;
        if i < Lines.Count - 1 then
          FPoly.NewLine;
      end;
    finally
      Lines.Free;
    end;
  end;
  // We must now reconstruct the trainer
  NormalizePolygon;
  BitmapPolygon;
  // Load other props
  Character := WideChar(ANode.ReadString('Character')[1]);
  // We load it here, because if read earlier it would be destroyed (set to 1)
  // in NormalizePolygon
  FAspectRatio := ANode.ReadFloat('AspectRatio');
end;

procedure TsdOcrTrainer.NormalizePolygon;
const
  cHorzScale = cDefaultTrainerPixelsX * $10000; // 25 pixels default
  cVertScale = cDefaultTrainerPixelsY * $10000; // 50 pixels default
var
  i, j, k, OrigCount, SimpleCount: Integer;
  MinX, MinY, MaxX, MaxY: TFixed;
  First: boolean;
  ScaleX, ScaleY: single;
  Orig, Simple: array of TPoint;
  ASegment: TsdOcrSegment;
  ALength: single;
  StartX, StartY, CloseX, CloseY: single;
  P1X, P1Y, P2X, P2Y: single;
  ADiv: integer;
  P: TFixedPoint;
  dX, dY: integer;
begin
  First := True;
  MinX := 0; MinY := 0; MaxX := 0; MaxY := 0;
  ScaleX := 0;
  ScaleY := 0;
  // Find bounding box
  for j := 0 to High(FPoly.Points) do
    for i := 0 to High(FPoly.Points[J]) do
    begin
      P := FPoly.Points[j][i];
      if First then
      begin
        MinX := P.X; MaxX := P.X;
        MinY := P.Y; MaxY := P.Y;
        First := False;
      end else
      begin
        MinX := Min(P.X, MinX);
        MaxX := Max(P.X, MaxX);
        MinY := Min(P.Y, MinY);
        MaxY := Max(P.Y, MaxY);
      end;
    end;
  // Set to a vertical height of cVertScale (pixels)
  if length(FPoly.Points) > 0 then
  begin
    dX := MaxX - MinX;
    dY := MaxY - MinY;
    if dX > 0 then
      ScaleX := cHorzScale / dX
    else
      ScaleX := 1;
    if dY > 0 then
      ScaleY := cVertScale / dY
    else
      ScaleY := 1;
    AspectRatio := ScaleX / ScaleY;
  end;
  for j := 0 to High(FPoly.Points) do
    for i := 0 to High(FPoly.Points[J]) do
    begin
      P := FPoly.Points[j][i];
      P.X := round((P.X - MinX) * ScaleX);
      P.Y := round((P.Y - MinY) * ScaleY);
    end;

  // Also create our comparison line segments. We do this by using
  // Douglas Peucker to simplify the original polylines in order to get
  // less segments
  for j := 0 to High(FPoly.Points) do
  begin
    // Copy one line at a time
    OrigCount := Length(FPoly.Points[j]) + 1;
    SetLength(Orig,   OrigCount);
    SetLength(Simple, OrigCount);
    for i := 0 to High(FPoly.Points[j]) do
    begin
      P := FPoly.Points[j][i];
      Orig[i].X := P.X div (cDefaultTrainerPixelsY * $10); // Now we have a glyph in range 0..$1000 vertical
      Orig[i].Y := P.Y div (cDefaultTrainerPixelsY * $10);
    end;
    // Copy the last point
    Orig[OrigCount - 1].X := Orig[0].X;
    Orig[OrigCount - 1].Y := Orig[0].Y;

    // Simplify this line using Douglas-Peucker
    SimpleCount := PolySimplifyInt2D(50, Orig, Simple);

    // And add the segments to our trainer
    for i := 0 to SimpleCount - 2 do
    begin
      StartX := Simple[i].X / $1000;
      StartY := Simple[i].Y / $1000;
      CloseX := Simple[i + 1].X / $1000;
      CloseY := Simple[i + 1].Y / $1000;
      ALength := Sqrt(Sqr(CloseX - StartX) + Sqr(CloseY - StartY));

      // Split large segments into line pieces, so we can later on use
      // completeness detection
      ADiv := Max(1, ceil(ALength / 0.10));
      for k := 0 to ADiv - 1 do
      begin
        P1X := StartX + k * (CloseX - StartX) / ADiv;
        P1Y := StartY + k * (CloseY - StartY) / ADiv;
        P2X := StartX + (k + 1) * (CloseX - StartX) / ADiv;
        P2Y := StartY + (k + 1) * (CloseY - StartY) / ADiv;
        ASegment := TsdOcrSegment.Create;
        ASegment.Start.X := P1X;
        ASegment.Start.Y := P1Y;
        ASegment.Close.X := P2X;
        ASegment.Close.Y := P2Y;
        SegmentAdd(ASegment);
      end;
    end;
  end;
end;

procedure TsdOcrTrainer.RegenerateQSpline(const P0, P1, P2: TFixedPoint;
  Poly: TPolygon32);
var
  P21, P22, P3: TFixedPoint;
begin
  if PointsAreEqual(P0, P1) or PointsAreEqual(P1, P2) then
  begin
    Poly.Add(P1);
    Poly.Add(p2);
    exit;
  end;

  P21 := MiddleLine(P1,  P0 );
  P22 := MiddleLine(P2,  P1 );
  P3  := MiddleLine(P21, P22);

  // First segment
  if SegmentConditionalLengthQ2N1Sup(p0, p21, p3) > cGlyphMinSegmentSize then
    // Recursive call
    RegenerateQSpline(p0, p21, p3, Poly)
  else
  begin
    Poly.Add(p21);
    Poly.Add(p3);
  end;

  // Second segment
  if SegmentConditionalLengthQ2N1Sup(p3, p22,  p2) > cGlyphMinSegmentSize then
    RegenerateQSpline(p3, p22, p2, Poly)
  else
  begin
    Poly.Add(p22);
    Poly.Add(p2);
  end;
end;

procedure TsdOcrTrainer.Reset;
// Reset all "Visited" flags of the segments
var
  i: integer;
begin
  for i := 0 to SegmentCount - 1 do
    Segments[i].Visited := 0;
end;

procedure TsdOcrTrainer.SaveToXml(ANode: TXmlNode);
// Save the polyline
var
  i, j: integer;
  APoly, ALine, APoint: TXmlNode;
begin
  // Save poly
  APoly := ANode.NodeNew('Polyline');
  for i := 0 to Length(FPoly.Points) - 1 do
  begin
    ALine := APoly.NodeNew('Line');
    for j := 0 to Length(FPoly.Points[i]) - 1 do
    begin
      APoint := ALine.NodeNew('Point');
      APoint.WriteInteger('X', FPoly.Points[i, j].X);
      APoint.WriteInteger('Y', FPoly.Points[i, j].Y);
    end;
  end;
  // Save other props
  ANode.WriteString('Character', FCharacter);
  ANode.WriteFloat('AspectRatio', FAspectRatio);
end;

function TsdOcrTrainer.SegmentAdd(ASegment: TsdOcrSegment): integer;
begin
  Result := -1;
  if assigned(FSegments) and assigned(ASegment) then
    Result := FSegments.Add(ASegment);
end;

procedure TsdOcrTrainer.SetTolerance(Tol: single);
var
  i, j: integer;
begin
  // Set the segment's tolerance
  for i := 0 to SegmentCount - 1 do
    Segments[i].SetTolerance(Tol);

  // Sort the segments on Bounds.Top
  for i := 0 to SegmentCount - 2 do
    for j := i + 1 to SegmentCount - 1 do
      if Segments[j].Bounds.Top < Segments[i].Bounds.Top then
        FSegments.Exchange(i, j);
end;

{ TsdOcrSegment }

function TsdOcrSegment.NearPoint(const APoint: TFloatPoint): single;
// Determine if a point is near the line segment. Make sure to call
// SetTolerance before making calls to this function to ensure that
// FBounds, FLength2 and FLength, and FTol2 are set.
var
  q: single;
// Local
function SquaredDistance(P1X, P1Y, P2X, P2Y: single): single;
begin
  Result := sqr(P1X - P2X) + sqr(P1Y - P2Y);
end;
// Local
function NearResult(ADist: single): single;
begin
  Result := (Max(0, FTol2 - ADist) / FTol2) * 0.4 + 0.6;
end;
// Main
begin
  Result := 0;

  // First check: bounding box
  if (APoint.X < FBounds.Left)  or (APoint.Y < FBounds.Top) or
     (APoint.X > FBounds.Right) or (APoint.Y > FBounds.Bottom) then
     exit;

  // Second check: nearness to line segment
  if Length = 0 then
  begin

    // Point to point
    Result := NearResult(SquaredDistance(APoint.X, APoint.Y, FBounds.Left, FBounds.Top));

  end else
  begin

    // Minimum
    q :=
     ((APoint.X - Start.X) * (Close.X - Start.X) +
      (APoint.Y - Start.Y) * (Close.Y - Start.Y)) / FLength2;

    // Limit q to 0 <= q <= 1
    if q < 0 then
      q := 0;
    if q > 1 then
      q := 1;

    // Distance
    Result := NearResult(SquaredDistance(APoint.X, APoint.Y,
      (1 - q) * Start.X + q * Close.X,
      (1 - q) * Start.Y + q * Close.Y));

  end;
end;

procedure TsdOcrSegment.SetTolerance(Tol: single);
begin
  FBounds.Left   := Min(Start.X, Close.X) - Tol;
  FBounds.Top    := Min(Start.Y, Close.Y) - Tol;
  FBounds.Right  := Max(Start.X, Close.X) + Tol;
  FBounds.Bottom := Max(Start.Y, Close.Y) + Tol;
  FTol2 := sqr(Tol);
  FLength2 := sqr(Close.X - Start.X) + sqr(Close.Y - Start.Y);
  FLength := sqrt(FLength2);
end;

{ TsdOcrGroup }

procedure TsdOcrGroup.CorrectAspect;
var
  i: integer;
  Aspects: array of single;
  Bias: single;
begin
  // Get list of aspect differences
  SetLength(Aspects, Glyphs.Count);
  for i := 0 to Glyphs.Count - 1 do
    Aspects[i] := Glyphs[i].AspectDiff;
  // Find the bias
  Bias := MeanOfPercentile(Aspects, Glyphs.Count, 0.5);
  // And apply
  for i := 0 to Glyphs.Count - 1 do
    Glyphs[i].AspectBias := Bias;
end;

procedure TsdOcrGroup.CorrectSkewY;
var
  i: integer;
  Count: integer;
  Skews: array of TFloatPoint;
  Points: array of TFloatPoint;
  Use: array of boolean;
  A, B: single;
  SkewDiff: single;
begin
  if Glyphs.Count < 4 then
    exit;
  SetLength(Skews, Glyphs.Count);
  SetLength(Points, Glyphs.Count);
  SetLength(Use, Glyphs.Count);

  // Get list of points
  for i := 0 to Glyphs.Count - 1 do
  begin
    Skews[i].X := Glyphs[i].BottomCenter.X;
    Skews[i].Y := Glyphs[i].SkewY;
    Use[i] := True;
  end;

  repeat
    // Determine used points
    Count := 0;
    for i := 0 to Glyphs.Count - 1 do
      if Use[i] then
      begin
        Points[Count] := Skews[i];
        inc(Count);
      end;

    // Determine line through these
    StrokeLine(Points, Count, A, B);
    if Count < 3 then
      break;

    // Get distances from line
    for i := 0 to Glyphs.Count - 1 do
      if Use[i] then
      begin
        SkewDiff := abs(Skews[i].Y - (A * Skews[i].X + B));
        // Any larger than XX must be recalculated
        if SkewDiff > 0.1 then
        begin
          Use[i] := False;
          break;
        end;
      end;
    if i = Glyphs.Count then
      break;
  until False;

  // Correct the skew for the unused points
  for i := 0 to Glyphs.Count - 1 do
    if not Use[i] then
      Glyphs[i].SkewY := A * Skews[i].X + B;
end;

constructor TsdOcrGroup.Create(AOwner: TsdOcrModule);
begin
  inherited Create;
  FOwner := AOwner;
  FGlyphs := TsdOcrGlyphList.Create(False); // not owned
end;

destructor TsdOcrGroup.Destroy;
begin
  FreeAndNil(FGlyphs);
  inherited;
end;

function TsdOcrGroup.GetSkewX: single;
var
  i: integer;
  Skews: array of single;
  Corrs: array of single;
  SkewId: integer;
  DeltaX, DeltaY: single;
  ASkew: single;
  SkewCount: integer;
  CorrCount: integer;
  MaxSkew, MinSkew: single;
begin
  Result := 0;
  if Glyphs.Count < 2 then
    exit;
  SkewCount := 2 * (Glyphs.Count - 1);
  SetLength(Skews, SkewCount);
  SetLength(Corrs, SkewCount);

  // Get a list of skew values
  SkewId := 0;
  for i := 0 to Glyphs.Count - 2 do
  begin
    // Top line
    DeltaX := Glyphs[i + 1].TopCenter.X - Glyphs[i].TopCenter.X;
    DeltaY := Glyphs[i + 1].TopCenter.Y - Glyphs[i].TopCenter.Y;
    if DeltaX <> 0 then
      ASkew := DeltaY / DeltaX
    else
      ASkew := 0;
    Skews[SkewId] := ASkew;
    inc(SkewId);
    // Bottom line
    DeltaX := Glyphs[i + 1].BottomCenter.X - Glyphs[i].BottomCenter.X;
    DeltaY := Glyphs[i + 1].BottomCenter.Y - Glyphs[i].BottomCenter.Y;
    if DeltaX <> 0 then
      ASkew := DeltaY / DeltaX
    else
      ASkew := 0;
    Skews[SkewId] := ASkew;
    inc(SkewId);
  end;

  // Preserves all but the obviously wrong
  CorrCount := 0;
  MaxSkew := FOwner.SkewFromAngle(FOwner.TextDirection + FOwner.MaxTextRotation);
  MinSkew := FOwner.SkewFromAngle(FOwner.TextDirection - FOwner.MaxTextRotation);
  for i := 0 to SkewCount - 1 do
    if (Skews[i] >= MinSkew) and (Skews[i] <= MaxSkew) then
    begin
      Corrs[CorrCount] := Skews[i];
      inc(CorrCount);
    end;
  if CorrCount = 0 then
    exit;

  // And find from these the mean of the 0.5 percentile
  Result := MeanOfPercentile(Corrs, CorrCount, 0.5);
end;

procedure TsdOcrGroup.PredictSkewYForMissed;
var
  i, Index: integer;
  FoundCount: integer;
  Skews: array of TFloatPoint;
  A, B: single;
begin
  FoundCount := 0;
  for i := 0 to Glyphs.Count - 1 do
    if Glyphs[i].SkewYFound then
      inc(FoundCount);
  SetLength(Skews, FoundCount);

  // Set skew points
  Index := 0;
  for i := 0 to Glyphs.Count - 1 do
  begin
    if Glyphs[i].SkewYFound then
    begin
      Skews[Index].X := Glyphs[i].BottomCenter.X;
      Skews[Index].Y := Glyphs[i].SkewY;
      inc(Index);
    end;
  end;

  // Determine line through these
  StrokeLine(Skews, FoundCount, A, B);

  // Predict unknown ones
  for i := 0 to Glyphs.Count - 1 do
    if Glyphs[i].SkewYFound = False then
      Glyphs[i].SkewY := A * Glyphs[i].BottomCenter.X + B;

end;

procedure TsdOcrGroup.RecogniseSkewYRange(MinSkewY, MaxSkewY: single;
  Steps: integer);
// Recognise all glyphs with equal SkewY value, do this for a range
var
  IdxSkewY, j: integer;
  DeltaSkewY: single;
  TempSkewY: single;
  TempScore: single;
  BestScore: single;
  BestSkewY: single;
begin
  BestScore := 0.0;
  BestSkewY := 0.0;
  // Delta
  DeltaSkewY  := (MaxSkewY - MinSkewY ) / Steps;
  for IdxSkewY := 1 to Steps do
  begin
    TempSkewY  := MinSkewY + DeltaSkewY * (IdxSkewY - 0.5);
    TempScore := 0;
    for j := 0 to Glyphs.Count - 1 do
    begin
      Glyphs[j].SkewY := TempSkewY;
      Glyphs[j].Recognise;
      TempScore := TempScore + Glyphs[j].Score;
    end;
    if TempScore > BestScore then
    begin
      BestScore := TempScore;
      BestSkewY := TempSkewY;
    end;
  end;
  // Repeat for the best one
  for j := 0 to Glyphs.Count - 1 do
  begin
    Glyphs[j].SkewY := BestSkewY;
    Glyphs[j].Recognise;
  end;
end;

procedure TsdOcrGroup.SortGlyphsByDirection(ADirection: single);
var
  i, j: integer;
  A, B, V1, V2: single;
begin
  A := cos(ADirection / 180 * pi);
  B := sin(ADirection / 180 * pi);
  for i := 0 to Glyphs.Count - 2 do
    for j := i + 1 to Glyphs.Count - 1 do
    begin
      V1 := A * Glyphs[i].BottomCenter.X + B * Glyphs[i].BottomCenter.Y;
      V2 := A * Glyphs[j].BottomCenter.X + B * Glyphs[j].BottomCenter.Y;
      if V2 < V1 then FGlyphs.Exchange(i, j);
    end;
end;

{ TsdOcrCandidate }

function TsdOcrCandidate.GetCharacter: widechar;
begin
  Result := #0;
  if assigned(Trainer) then
    Result := Trainer.Character;
end;

{ TsdOcrCandidateList }

function TsdOcrCandidateList.GetItems(Index: integer): TsdOcrCandidate;
begin
  Result := Get(Index);
end;

{ TsdOcrGlyphList }

function TsdOcrGlyphList.ByRef(ARef: integer): TsdOcrGlyph;
var
  Index: integer;
begin
  if IndexByLuid(ARef, Index) then
    Result := Get(Index)
  else
    Result := nil;
end;

function TsdOcrGlyphList.GetLuid(AItem: TObject): integer;
begin
  Result := TsdOcrGlyph(AItem).Ref;
end;

function TsdOcrGlyphList.GetItems(Index: integer): TsdOcrGlyph;
begin
  Result := Get(Index);
end;

{ TsdOcrGroupList }

function TsdOcrGroupList.GetItems(Index: integer): TsdOcrGroup;
begin
  Result := Get(Index);
end;

{ TsdOcrBarList }

function TsdOcrBarList.GetItems(Index: integer): TsdOcrBar;
begin
  Result := Get(Index);
end;

{ TsdOcrTrainerList }

function TsdOcrTrainerList.DoCompare(Item1, Item2: TObject): integer;
var
  T1, T2: TsdOcrTrainer;
begin
  T1 := TsdOcrTrainer(Item1);
  T2 := TsdOcrTrainer(Item2);
  Result := AnsiCompareText(T1.FontName, T2.FontName);
  if Result = 0 then
    Result := AnsiCompareText(T1.Character, T2.Character);
end;

function TsdOcrTrainerList.GetItems(Index: integer): TsdOcrTrainer;
begin
  Result := Get(Index);
end;

{ TsdOcrLineList }

function TsdOcrLineList.GetItems(Index: integer): TsdOcrLine;
begin
  Result := Get(Index);
end;

end.

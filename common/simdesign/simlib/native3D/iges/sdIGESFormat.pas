unit sdIGESFormat;
{
  Description:
  Reader and writer for the IGES (*.igs) format.

  IGES is a fixed-length 80 character ASCII file, which contains
  a definition of a list of entities in the directory section, and
  a list of parameters per entity in the parameters section.

  Currently TIgsFormat can only read IGES files.

  Implementation is based on the IGES standard (IGES standard 6.0.PDF)

  Created: 20Feb2006

  Modifications:

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  copyright (c) 2006 SimDesign B.V.
}

interface

uses
  Classes, SysUtils, Contnrs, Math, sdSortedLists;

type

  TIgsFormat = class;
  TIgsTransformationMatrixEntity = class;

  // TIgsLine is used internally by TIgsFormat - do not use directly
  TIgsLine = class(TPersistent)
  private
    FContent: string;
    FSectionCode: char;
    FSequenceNumber: integer;
  public
    property Content: string read FContent write FContent;
    property SectionCode: char read FSectionCode write FSectionCode;
    property SequenceNumber: integer read FSequenceNumber write FSequenceNumber;
  end;

  // TIgsLineList is used internally by TIgsFormat - do not use directly
  TIgsLineList = class(TObjectList)
  private
    function GetItems(Index: integer): TIgsLine;
  public
    function FindSection(ACode: char; ASequenceNumber: integer): integer;
    property Items[Index: integer]: TIgsLine read GetItems; default;
  end;

  // TIgsContentStream is used internally by TIgsFormat - do not use directly
  TIgsContentStream = class(TMemoryStream)
  private
    FParent: TIgsFormat;
    FEOFReached: boolean;
  protected
    property Parent: TIgsFormat read FParent write FParent;
    function ReadField: string;
    function StringToFloat(const S: string): double;
    function ReadHollerith(const S: string; APos: integer): string;
  public
    // Read Hollerith char from content (1Hx)
    function ReadChar(const Default: char = #0): char;
    // Read Hollerith string from content (nHxx)
    function ReadString(const Default: string = ''): string;
    function ReadInt(const Default: integer = 0): integer;
    function ReadFloat(const Default: double = 0.0): double;
    function ReadDate(const Default: TDateTime = 0.0): TDateTime;
    property EOFReached: boolean read FEOFReached;
  end;

  // The TIgsDirectoy record contains information of the directory entry of
  // an entity.
  TIgsDirectory = record
    SequenceNumber:     integer;
    EntityType:         integer;
    ParameterData:      integer;
    Structure:          integer;
    LineFontPattern:    integer;
    Level:              integer;
    View:               integer;
    TransformMatrix:    integer;
    LabelDispAssoc:     integer;
    Status:             integer;
    LineWeight:         integer;
    Color:              integer;
    ParameterLineCount: integer;
    Form:               integer;
    EntityLabel:        string;
    EntitySubscript:    integer;
  end;
  PIgsDirectory = ^TIgsDirectory;

  // TIgsParameter is the base class for entity parameters
  TIgsParameter = class(TPersistent)
  protected
    function GetAsFloat: double; virtual;
    function GetAsInt: integer; virtual;
    function GetAsString: string; virtual;
    procedure SetAsFloat(const Value: double); virtual;
    procedure SetAsInt(const Value: integer); virtual;
    procedure SetAsString(const Value: string); virtual;
  public
    constructor Create; virtual;
    // Set or get the value of the parameter as floating point (double)
    property AsFloat: double read GetAsFloat write SetAsFloat;
    // Set or get the value of the parameter as integer
    property AsInt: integer read GetAsInt write SetAsInt;
    // Set or get the value of the parameter as string
    property AsString: string read GetAsString write SetAsString;
  end;

  // TIgsFloatParameter stores a floating point entity parameter
  TIgsFloatParameter = class(TIgsParameter)
  private
    FValue: double;
  protected
    function GetAsFloat: double; override;
    function GetAsString: string; override;
    procedure SetAsFloat(const Value: double); override;
  end;

  // TIgsIntParameter stores an integer entity parameter
  TIgsIntParameter = class(TIgsParameter)
  private
    FValue: integer;
  protected
    function GetAsFloat: double; override;
    function GetAsInt: integer; override;
    function GetAsString: string; override;
    procedure SetAsInt(const Value: integer); override;
  end;

  // TIgsStringParameter stores a string entity parameter
  TIgsStringParameter = class(TIgsParameter)
  private
    FValue: string;
  protected
    function GetAsString: string; override;
    procedure SetAsString(const Value: string); override;
  end;

  // TIgsParameterList contains an owned list of entity parameters
  TIgsParameterList = class(TObjectList)
  private
    function GetItems(Index: integer): TIgsParameter;
  public
    property Items[Index: integer]: TIgsParameter read GetItems; default;
  end;

  // Definition of a unique level in the IGES document
  TIgsLevel = class(TPersistent)
  private
    FLevelNumber: integer;
    FIsVisible: boolean;
  public
    constructor Create; virtual;
    // LevelNumber corresponding to the entities Directory.Level
    property LevelNumber: integer read FLevelNumber write FLevelNumber;
    // IsVisible can be used by the application to turn visibility of levels
    // on and off. Default is True
    property IsVisible: boolean read FIsVisible write FIsVisible;
  end;

  // List of levels found in the IGES document
  TIgsLevelList = class(TSortedList)
  private
    function GetItems(Index: integer): TIgsLevel;
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    // GetLevelByNumber retrieves the level reference for ANumber. If there is no
    // level with ANumber, it will be created.
    function GetLevelByNumber(ANumber: integer): TIgsLevel;
    property Items[Index: integer]: TIgsLevel read GetItems; default;
  end;

  // TIgsEntity is a base class for entities in the IGES file
  TIgsEntity = class(TPersistent)
  private
    FDirectory: TIgsDirectory;
    FOwner: TIgsFormat;
    FParameters: TIgsParameterList;
    FTag: integer;
    FStructureParent: TIgsEntity;
    function GetSubordEntitySwitch: integer;
    procedure SetSubordEntitySwitch(const Value: integer);
    function GetEntityUseFlag: integer;
    procedure SetEntityUseFlag(const Value: integer);
    function GetHierarchy: integer;
    procedure SetHierarchy(const Value: integer);
    function GetBlankStatus: integer;
    procedure SetBlankStatus(const Value: integer);
    function GetMatrix: TIgsTransformationMatrixEntity;
    function GetDirectory: PIgsDirectory;
    function GetLevelNumber: integer;
    procedure SetLevelNumber(const Value: integer);
  protected
    procedure BuildStructure; virtual;
    procedure ClearStructure; virtual;
    function GetEntityCount: integer; virtual;
    function GetEntities(Index: integer): TIgsEntity; virtual;
    property Owner: TIgsFormat read FOwner;
  public
    constructor Create(AOwner: TIgsFormat); virtual;
    destructor Destroy; override;
    // Name of the parameter at index Index, here Index is one less than in
    // the spec because it starts at 0. The default 0 index with the entitytype
    // is omitted.
    function ParameterDescription(Index: integer): string; virtual;
    // Name of entity type according to the spec
    function EntityTypeName: string; virtual;
    // Name of the color used for this entity
    function ColorName: string; virtual;
    // Pointer to the level (layer) to which this entity belongs.
    function GetLevel: TIgsLevel;
    // Reference to the root of the structure this entity belongs to, or itself
    // if there are no structure parents
    function StructureRoot: TIgsEntity;
    // Pointer to the Directory record of this entity (TIgsDirectory)
    property Directory: PIgsDirectory read GetDirectory;
    // Number of sub-entities in this entity
    property EntityCount: integer read GetEntityCount;
    // List of sub-entities in this entity
    property Entities[Index: integer]: TIgsEntity read GetEntities;
    // List of parameters in this entity. The default parameter with entitytype
    // is omitted
    property Parameters: TIgsParameterList read FParameters;
    // User-definable integer value
    property Tag: integer read FTag write FTag;
    // Reference to the matrix used to transform this entity back to its parent.
    // If this value is nil, no transform is used.
    property Matrix: TIgsTransformationMatrixEntity read GetMatrix;
    // Number of the level to which this entity belongs
    property LevelNumber: integer read GetLevelNumber write SetLevelNumber;
    // Blank status (00 = visible, 01 = invisible)
    property BlankStatus: integer read GetBlankStatus write SetBlankStatus;
    // Subordinate entity switch (00 = independent, 01 = physically dependent,
    // 02 = logically dependent, 03 = physically/logically dependent
    property SubordEntitySwitch: integer read GetSubordEntitySwitch write SetSubordEntitySwitch;
    // Entity Use flag (00 = geometry, 01 = annotation, 02 = definition, 03 = other,
    // 04 = logical/positional, 05 = 2D parametric, 06 = construction geometry
    property EntityUseFlag: integer read GetEntityUseFlag write SetEntityUseFlag;
    // Hierarchy (00 = apply all to children, 01 = apply none to children,
    // 02 = apply individually
    property Hierarchy: integer read GetHierarchy write SetHierarchy;
  end;

  TNotifyEntityEvent = procedure (Sender: TObject; Entity: TIgsEntity) of object;

  // TIgsEntityList contains an owned list of TIgsEntity objects. Use OnEntityAdded
  // and OnEntityDeleted to do special processing when entities are added/deleted.
  TIgsEntityList = class(TObjectList)
  private
    function GetItems(Index: integer): TIgsEntity;
  public
    function BySequenceNumber(ASequenceNumber: integer): TIgsEntity;
    property Items[Index: integer]: TIgsEntity read GetItems; default;
  end;

  // IgsEntity that can contain items
  TIgsContainingEntity = class(TIgsEntity)
  private
    FEntities: TIgsEntityList;
  protected
    procedure AddStructureEntity(ASequenceNumber: integer);
    procedure ClearStructure; override;
    function GetEntityCount: integer; override;
    function GetEntities(Index: integer): TIgsEntity; override;
  public
    constructor Create(AOwner: TIgsFormat); override;
    destructor Destroy; override;
  end;

  // Transformation matrix entity (124)
  TIgsTransformationMatrixEntity = class(TIgsEntity)
  public
    function ParameterDescription(Index: integer): string; override;
  end;

  // The TIgsGlobal record contains global information for use in the IGES format.
  TIgsGlobal = record
    ParamDelim: char;
    RecordDelim: char;
    ProductIDSender: string;
    FileName: string;
    NativeSystemID: string;
    PreprocessorVersion: string;
    NumBitsForInt: integer;
    MaxPowTenSinglePrecision: integer;
    NumSignDigitsSinglePrecision: integer;
    MaxPowTenDoublePrecision: integer;
    NumSignDigitsDoublePrecision: integer;
    ProductIDReceiver: string;
    ModelSpaceScale: double;
    UnitsFlag: integer;
    UnitsName: string;
    NumLineWeightGrad: integer;
    WidthMaxLineWeight: double;
    ExchangeDate: TDateTime;
    MinimumResolution: double;
    MaxCoordinateValue: double;
    AuthorName: string;
    AuthorOrganization: string;
    VersionSpecFlag: integer;
    DraftingStandardFlag: integer;
    ModifiedDate: TDateTime;
    Protocol: string;
  end;
  PIgsGlobal = ^TIgsGlobal;

  // The TIgsFormat component allows loading and saving of IGES files or streams,
  // and provides global information through the Global property, and Entity
  // information through the Entities list. Start section info is stored
  // in the StartSection stringlist.
  // For visualisation with OpenGL see the class TIgsOpenGLRenderer. Point lists
  // can be extracted with the class TIgsPointlistRenderer
  TIgsFormat = class(TComponent)
  private
    FEntities: TIgsEntityList;
    FLines: TIgsLineList;
    FGlobal: TIgsGlobal;
    FStartSection: TStringList;
    FStructure: TIgsEntityList;
    FLevels: TIgsLevelList;
    procedure ReadIgesLines(S: TStream);
    procedure ReadGlobalSection(S: TIgsContentStream);
    procedure ReadDirectorySection(AStartLine: integer);
    procedure ReadParameterSection(AStartLine: integer);
    function GetGlobal: PIgsGlobal;
  protected
    procedure Clear;
    function CreateEntity(AType, AForm: integer): TIgsEntity;
    procedure BuildStructure; virtual;
    procedure BuildLevels; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Returns a pointer to the entity with sequence number ASequenceNumber, or
    // nil if no such entity exists
    function EntityBySequenceNumber(ASequenceNumber: integer): TIgsEntity;
    // Clear the old document and reset the defaults
    procedure New;
    // Load an IGES document from the file with name AFileName
    procedure LoadFromFile(const AFileName: string);
    // Load an IGES document from the stream S
    procedure LoadFromStream(S: TStream);
    // Save an IGES document to the file with name AFileName
    procedure SaveToFile(const AFileName: string);
    // Get the multiplication factor to use to convert internal units to SI units [m]
    function UnitsToSI: double;
    // Access entities through the Entities list. Entities are always of TIgsEntity
    // class or a descendant. Often-used entities have a descendant type that
    // is defined in sdIGESEntities, which implement methods for extraction of
    // points and names of parameters
    property Entities: TIgsEntityList read FEntities;
    // All structural top-level entities
    property Structure: TIgsEntityList read FStructure;
    // Levels in the IGES document
    property Levels: TIgsLevelList read FLevels;
    // Access global information in the IGES document
    property Global: PIgsGlobal read GetGlobal;
    // Information from the start section of the IGES document is stored in
    // the stringlist StartSection. You can add information to it, but make
    // sure to add strings that do not exceed 72 characters (larger strings
    // will be truncated in the file).
    property StartSection: TStringList read FStartSection;
  end;

const

  cIgsBlankStatus: array[0..1] of string = (
   '00 (visible)',
   '01 (invisible)');
  cIgsSubordEntitySwitch: array[0..3] of string = (
   '00 (independent)',
   '01 (physically dependent)',
   '02 (logically dependent)',
   '03 (physically/logically dependent)');
  cIgsEntityUseFlag: array[0..6] of string = (
   '00 (geometry)',
   '01 (annotation)',
   '02 (definition)',
   '03 (other)',
   '04 (logical/positional)',
   '05 (2D parametric)',
   '06 (construction geometry)');
  cIgsHierarchy: array[0..2] of string = (
   '00 (apply all to children)',
   '01 (apply none to children)',
   '02 (apply individually)');

const
  cIgsUnitCount = 11;

  // name of units
  cIgsUnitNames: array[0..cIgsUnitCount - 1] of string =
   ('Inches', 'Millimeters', 'Unknown', 'Feet', 'Miles', 'Meters', 'Kilometers',
    'Mils', 'Microns', 'Centimeters', 'Microinches');

  // The size of one unit in meters
  cIgsUnitConversion: array[0..cIgsUnitCount - 1] of double =
   (0.0254, 0.001, 1, 0.3048, 1609.344, 1, 1000,
    0.0254E-3, 1E-6, 0.01, 0.0254E-6);

resourcestring

  sIgsIllegalSectionCode         = 'Illegal section code in IGES file';
  sIgsCompressedIGSNotSupported  = 'Compressed IGES files are not supported';
  sIgsGlobalSectionMissing       = 'IGES file misses global section';
  sIgsTerminationSectionMissing  = 'IGES file misses termination section';
  sIgsCharExpected               = 'Character expected in content';
  sIgsHollerithStringExpected    = 'Hollerith string expected in content';
  sIgsUnexpectedEndOfFile        = 'Unexpected end of file';
  sIgsSeparatorExpected          = 'Separator expected in file';
  sIgsCannotConvertToFloat       = 'Cannot convert "%s" to float value';
  sIgsDirectory2ndLineMissing    = 'Second line in directory entry missing';
  sIgsParameterDirSequenceError  = 'Error in parameter directory sequence pointer';
  sIgsInvalidParameter           = 'Invalid parameter in parameter list';
  sIgsParametersMissing          = 'Parameters missing in entity';
  sIgsInvalidEntityRef           = 'Invalid entity reference';

implementation

uses
  sdIGESEntities;

{ TIgsLineList }

function TIgsLineList.FindSection(ACode: char;
  ASequenceNumber: integer): integer;
var
  i: integer;
  AItem: TIgsLine;
begin
  Result := -1;
  for i := 0 to Count - 1 do begin
    AItem := Items[i];
    if (AItem.SectionCode = ACode) and (AItem.SequenceNumber = ASequenceNumber) then begin
      Result := i;
      exit;
    end;
  end;
end;

function TIgsLineList.GetItems(Index: integer): TIgsLine;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

{ TIgsContentStream }

function TIgsContentStream.ReadChar(const Default: char): char;
var
  S: string;
begin
  S := ReadString(Default);
  if length(S) <> 1 then
    raise Exception.Create(sIgsCharExpected);
  Result := S[1];
end;

function TIgsContentStream.ReadDate(const Default: TDateTime): TDateTime;
// Dates are always in 15HYYYYMMDD.HHNNSS or 13HYYMMDD.HHNNSS
var
  S: string;
  Year, Month, Day, Hour, Min, Sec: integer;
begin
  S := ReadString;
  if length(S) = 0 then begin
    Result := Default;
    exit;
  end;
  // In case of the short format: add 19 for century
  if length(S) = 13 then S := '19' + S;
  // Extract units
  Year := StrToInt(copy(S, 1, 4));
  if Year < 1950 then inc(Year, 100);
  Month := StrToInt(copy(S, 5, 2));
  Day := StrToInt(copy(S, 7, 2));
  Hour := StrToInt(copy(S, 10, 2));
  Min := StrToInt(copy(S, 12, 2));
  Sec := StrToInt(copy(S, 14, 2));
  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Min, Sec, 0);
end;

function TIgsContentStream.ReadField: string;
var
  Ch, ParamSep, RecordSep: char;
  Len: integer;
begin
  Result := '';
  if FEOFReached then exit;

  ParamSep := FParent.Global.ParamDelim;
  RecordSep := FParent.Global.RecordDelim;
  repeat
    Len := Read(Ch, 1);
    if Len = 0 then begin
      FEOFReached := True;
      break;
    end;
    if (Ch = ParamSep) or (Ch = RecordSep) then break;
    Result := Result + Ch;
    if Ch = 'H' then break; // Hollerith string
  until Len = 0;
  Result := trim(Result);
end;

function TIgsContentStream.ReadFloat(const Default: double): double;
var
  S: string;
begin
  S := ReadField;
  if length(S) = 0 then begin
    Result := Default;
    exit;
  end;
  Result := StringToFloat(S);
end;

function TIgsContentStream.ReadHollerith(const S: string; APos: integer): string;
var
  ALen: integer;
  Ch: char;
begin
  ALen := StrToInt(copy(S, 1, APos - 1));

  // Now we know the length we can read the string
  SetLength(Result, ALen);
  if Read(Result[1], ALen) <> ALen then
    raise Exception.Create(sIgsUnexpectedEndOfFile);

  // Read delimiter
  Read(Ch, 1);
  if (Ch <> FParent.Global.ParamDelim) and (Ch <> FParent.Global.RecordDelim) then
    raise Exception.Create(sIgsSeparatorExpected);
end;

function TIgsContentStream.ReadInt(const Default: integer): integer;
var
  S: string;
begin
  S := ReadField;
  if length(S) = 0 then
    Result := Default
  else
    Result := StrToInt(S);
end;

function TIgsContentStream.ReadString(const Default: string): string;
// Read Hollerith string (e.g. "3HBye")
var
  S: string;
  APos: integer;
begin
  S := ReadField;
  if length(S) = 0 then begin
    Result := Default;
    exit;
  end;

  // find 'H'
  APos := Pos('H', S);
  if APos = 0 then
    raise Exception.Create(sIgsHollerithStringExpected);

  Result := ReadHollerith(S, APos);
end;

function TIgsContentStream.StringToFloat(const S: string): double;
var
  Str: string;
  Code: integer;
begin
  // Replace 'D' by 'E'
  Str := StringReplace(S, 'D', 'E', []);
  // Find value
  val(Str, Result, Code);
  if Code > 0 then
    raise Exception.CreateFmt(sIgsCannotConvertToFloat, [S]);
end;

{ TIgsParameter }

constructor TIgsParameter.Create;
begin
  inherited Create;
end;

function TIgsParameter.GetAsFloat: double;
begin
  Result := 0;
end;

function TIgsParameter.GetAsInt: integer;
begin
  Result := 0;
end;

function TIgsParameter.GetAsString: string;
begin
  Result := '';
end;

procedure TIgsParameter.SetAsFloat(const Value: double);
begin
// default does nothing
end;

procedure TIgsParameter.SetAsInt(const Value: integer);
begin
// default does nothing
end;

procedure TIgsParameter.SetAsString(const Value: string);
begin
// default does nothing
end;

{ TIgsFloatParameter }

function TIgsFloatParameter.GetAsFloat: double;
begin
  Result := FValue;
end;

function TIgsFloatParameter.GetAsString: string;
begin
  Result := FloatToStr(FValue);
  Result := StringReplace(Result, ',', '.', []);
end;

procedure TIgsFloatParameter.SetAsFloat(const Value: double);
begin
  FValue := Value;
end;

{ TIgsIntParameter }

function TIgsIntParameter.GetAsFloat: double;
begin
  Result := FValue;
end;

function TIgsIntParameter.GetAsInt: integer;
begin
  Result := FValue;
end;

function TIgsIntParameter.GetAsString: string;
begin
  Result := IntToStr(FValue);
end;

procedure TIgsIntParameter.SetAsInt(const Value: integer);
begin
  FValue := Value;
end;

{ TIgsStringParameter }

function TIgsStringParameter.GetAsString: string;
begin
  Result := FValue;
end;

procedure TIgsStringParameter.SetAsString(const Value: string);
begin
  FValue := Value;
end;

{ TIgsParameterList }

function TIgsParameterList.GetItems(Index: integer): TIgsParameter;
begin
  Result := Get(Index);
end;

{ TIgsLevel }

constructor TIgsLevel.Create;
begin
  inherited Create;
  FIsVisible := True;
end;

{ TIgsLevelList }

function TIgsLevelList.DoCompare(Item1, Item2: TObject): integer;
begin
  Result := CompareInteger(TIgsLevel(Item1).LevelNumber, TIgsLevel(Item2).LevelNumber);
end;

function TIgsLevelList.GetItems(Index: integer): TIgsLevel;
begin
  Result := Get(Index);
end;

function TIgsLevelList.GetLevelByNumber(ANumber: integer): TIgsLevel;
var
  Index: integer;
  ALevel: TIgsLevel;
begin
  ALevel := TIgsLevel.Create;
  ALevel.LevelNumber := ANumber;
  if Find(ALevel, Index) then begin
    Result := Items[Index];
    ALevel.Free;
  end else
    Result := Items[Add(ALevel)];
end;

{ TIgsEntity }

procedure TIgsEntity.BuildStructure;
begin
// base class does nothing
end;

procedure TIgsEntity.ClearStructure;
begin
  FStructureParent := nil;
end;

function TIgsEntity.ColorName: string;
begin
  case FDirectory.Color of
  0: Result := 'Default';
  1: Result := 'Black';
  2: Result := 'Red';
  3: Result := 'Green';
  4: Result := 'Blue';
  5: Result := 'Yellow';
  6: Result := 'Magenta';
  7: Result := 'Cyan';
  8: Result := 'White';
  else
    Result := 'Unknown';
  end;
end;

constructor TIgsEntity.Create(AOwner: TIgsFormat);
begin
  inherited Create;
  FOwner := AOwner;
  FParameters := TIgsParameterList.Create(True);
end;

destructor TIgsEntity.Destroy;
begin
  FreeAndNil(FParameters);
  inherited;
end;

function TIgsEntity.EntityTypeName: string;
begin
  case FDirectory.EntityType of
    0: Result := 'Null';
  100: Result := 'Circular arc';
  102: Result := 'Composite curve';
  104: Result := 'Conic arc';
  106:
    case FDirectory.Form of
    11..13: Result := 'Linear path';
    20..21: Result := 'Center line';
    40:     Result := 'Witness line';
    63:     Result := 'Simple closed planar curve';
    else
      Result := '?? Copious data';
    end;
  108: Result := 'Plane';
  110: Result := 'Line';
  112: Result := 'Parametric spline curve';
  116: Result := 'Point';
  124: Result := 'Transformation matrix';
  126: Result := 'Rational B-spline curve';
  128: Result := 'Rational B-spline surface';
  132: Result := 'Connect point';
  141: Result := 'Boundary';
  142: Result := 'Curve on a parametric surface';
  143: Result := 'Bounded Surface';
  144: Result := 'Trimmed (parametric) surface';
  158: Result := 'Sphere';
  162: Result := 'Solid of revolution';
  184: Result := 'Solid assembly';
  202: Result := 'Angular dimension';
  206: Result := 'Diameter dimension';
  210: Result := 'General label';
  212: Result := 'General note';
  214: Result := 'Leader (arrow)';
  216: Result := 'Linear dimension';
  218: Result := 'Ordinate dimension';
  222: Result := 'Radius dimension';
  230: Result := 'Sectioned area';
  232: Result := 'Multimedia';
  304: Result := 'Line font definition';
  308: Result := 'Subfigure definition';
  314: Result := 'Color Definition';
  320: Result := 'Network subfigure definition';
  322: Result := 'Attribute table definition';
  402:
    case FDirectory.Form of
     7: Result := 'Group without backpointers associativity';
    15: Result := 'Orderd group, no backpointers associativity';
    else
      Result := 'Associative instance';
    end;
  404: Result := 'Drawing';
  406:
    case FDirectory.Form of
     5: Result := 'Line widening property';
    15: Result := 'Name property';
    16: Result := 'Drawing size property';
    17: Result := 'Drawing units property';
    18: Result := 'Intercharacter spacing property';
    31: Result := 'Basic dimension property';
    34: Result := 'Underscore property';
    35: Result := 'Overscore property';
    else
      Result := '?? Property';
    end;
  408: Result := 'Singular subfigure instance';
  410: Result := 'View';
  412: Result := 'Rectangular array subfigure instance';
  414: Result := 'Circular array subfigure instance';
  420: Result := 'Network subfigure instance';
  422: Result := 'Attribute table instance';
  else
    Result := '?';
  end;
end;

function TIgsEntity.GetBlankStatus: integer;
begin
  Result := (FDirectory.Status div 1000000) mod 100;
end;

function TIgsEntity.GetDirectory: PIgsDirectory;
begin
  Result := @FDirectory;
end;

function TIgsEntity.GetEntities(Index: integer): TIgsEntity;
begin
  Result := nil;
end;

function TIgsEntity.GetEntityCount: integer;
begin
  Result := 0;
end;

function TIgsEntity.GetEntityUseFlag: integer;
begin
  Result := (FDirectory.Status div 100) mod 100;
end;

function TIgsEntity.GetHierarchy: integer;
begin
  Result := FDirectory.Status mod 100;
end;

function TIgsEntity.GetLevel: TIgsLevel;
begin
  Result := nil;
  if assigned(FOwner) then
    Result := FOwner.Levels.GetLevelByNumber(FDirectory.Level);
end;

function TIgsEntity.GetLevelNumber: integer;
begin
  Result := FDirectory.Level;
end;

function TIgsEntity.GetMatrix: TIgsTransformationMatrixEntity;
begin
  Result := nil;
  if FDirectory.TransformMatrix > 0 then
    Result := TIgsTransformationMatrixEntity(
      FOwner.EntityBySequenceNumber(FDirectory.TransformMatrix));
end;

function TIgsEntity.GetSubordEntitySwitch: integer;
begin
  Result := (FDirectory.Status div 10000) mod 100;
end;

function TIgsEntity.ParameterDescription(Index: integer): string;
var
  AParam: TIgsParameter;
begin
  Result := 'Unknown';
  AParam := FParameters[Index];
  if AParam is TIgsIntParameter then
    Result := 'Int'
  else if AParam is TIgsFloatParameter then
    Result := 'Float'
  else if AParam is TIgsStringParameter then
    Result := 'String';
end;

procedure TIgsEntity.SetBlankStatus(const Value: integer);
begin
// to do
end;

procedure TIgsEntity.SetEntityUseFlag(const Value: integer);
begin
// to do
end;

procedure TIgsEntity.SetHierarchy(const Value: integer);
begin
// to do
end;

procedure TIgsEntity.SetLevelNumber(const Value: integer);
begin
  if FDirectory.Level <> Value then begin
    FDirectory.Level := Value;
    // Assure level exists in owner
    GetLevel;
  end;
end;

procedure TIgsEntity.SetSubordEntitySwitch(const Value: integer);
begin
// to do
end;

function TIgsEntity.StructureRoot: TIgsEntity;
begin
  if assigned(FStructureParent) then
    Result := FStructureParent.StructureRoot
  else
    Result := Self;
end;

{ TIgsEntityList }

function TIgsEntityList.BySequenceNumber(ASequenceNumber: integer): TIgsEntity;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].Directory.SequenceNumber = ASequenceNumber then begin
      Result := Items[i];
      exit;
    end;
end;

function TIgsEntityList.GetItems(Index: integer): TIgsEntity;
begin
  Result := Get(Index);
end;

{ TIgsContainingEntity }

procedure TIgsContainingEntity.AddStructureEntity(ASequenceNumber: integer);
var
  AEntity: TIgsEntity;
begin
  AEntity := FOwner.EntityBySequenceNumber(ASequenceNumber);
  if not assigned(AEntity) then
    raise Exception.Create(sIgsInvalidEntityRef);
  AEntity.FStructureParent := Self;
  FEntities.Add(AEntity);
end;

procedure TIgsContainingEntity.ClearStructure;
begin
  inherited;
  FEntities.Clear;
end;

constructor TIgsContainingEntity.Create(AOwner: TIgsFormat);
begin
  inherited Create(AOwner);
  FEntities := TIgsEntityList.Create;
  FEntities.OwnsObjects := False;
end;

destructor TIgsContainingEntity.Destroy;
begin
  FreeAndNil(FEntities);
  inherited;
end;

function TIgsContainingEntity.GetEntities(Index: integer): TIgsEntity;
begin
  Result := FEntities[Index];
end;

function TIgsContainingEntity.GetEntityCount: integer;
begin
  Result := FEntities.Count;
end;

{ TIgsTransformationMatrixEntity }

function TIgsTransformationMatrixEntity.ParameterDescription(
  Index: integer): string;
begin
  case Index of
  0:  Result := 'R11';
  1:  Result := 'R12';
  2:  Result := 'R13';
  3:  Result := 'T1';
  4:  Result := 'R21';
  5:  Result := 'R22';
  6:  Result := 'R23';
  7:  Result := 'T2';
  8:  Result := 'R31';
  9:  Result := 'R32';
  10: Result := 'R33';
  11: Result := 'T3';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

{ TIgsFormat }

procedure TIgsFormat.BuildLevels;
var
  i: integer;
begin
  FLevels.Clear;
  for i := 0 to FEntities.Count - 1 do
    // This will create the levels that do not yet exist
    FEntities[i].GetLevel;
end;

procedure TIgsFormat.BuildStructure;
var
  i: integer;
  E: TIgsEntity;
begin
  FStructure.Clear;
  for i := 0 to FEntities.Count - 1 do
    FEntities[i].ClearStructure;
  for i := 0 to FEntities.Count - 1 do
    FEntities[i].BuildStructure;
  for i := 0 to FEntities.Count - 1 do begin
    E := FEntities[i];
    // Not physically dependent upon another entity, and part of geometry?
    if not assigned(E.FStructureParent) and (E.SubordEntitySwitch <> 01) then
      // ..then add
      FStructure.Add(E);
  end;
end;

procedure TIgsFormat.Clear;
begin
  FEntities.Clear;
  FLines.Clear;
  FStructure.Clear;
  FLevels.Clear;
  FStartSection.Clear;
  // Global section defaults
  with FGlobal do begin
    ParamDelim := ',';
    RecordDelim := ';';
    ProductIDSender := '';
    FileName := '';
    NativeSystemID := '';
    PreprocessorVersion := '';
    NumBitsForInt := 32;
    MaxPowTenSinglePrecision := 38;
    NumSignDigitsSinglePrecision := 6;
    MaxPowTenDoublePrecision := 308;
    NumSignDigitsDoublePrecision := 15;
    ProductIDReceiver := '';
    ModelSpaceScale := 1.0;
    UnitsFlag := 1; // INCH
    UnitsName := 'INCH';
    NumLineWeightGrad := 1;
    WidthMaxLineWeight := 0;
    ExchangeDate := Now;
    MinimumResolution := 0;
    MaxCoordinateValue := 0;
    AuthorName := '';
    AuthorOrganization := '';
    VersionSpecFlag := 3;
    DraftingStandardFlag := 0;
    ModifiedDate :=  Now;
    Protocol := '';
  end;
end;

constructor TIgsFormat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEntities := TIgsEntityList.Create(True);
  FStructure := TIgsEntityList.Create(False);
  FLevels := TIgsLevelList.Create(True);
  FLines := TIgsLineList.Create(True);
  FStartSection := TStringList.Create;
  Clear;
end;

function TIgsFormat.CreateEntity(AType, AForm: integer): TIgsEntity;
begin
  Result := nil;
  case AType of
  100: Result := TIgsEntity100.Create(Self);
  102: Result := TIgsEntity102.Create(Self);
  104: Result := TIgsEntity104.Create(Self);
  106:
    case AForm of
    11..33: Result := TIgsLinearPathEntity.Create(Self);
    63:     Result := TIgsSimpleClosedPlanarCurveEntity.Create(Self);
    end;
  110: Result := TIgsLineEntity.Create(Self);
  124: Result := TIgsTransformationMatrixEntity.Create(Self);
  126: Result := TIgsEntity126.Create(Self);
  128: Result := TIgsEntity128.Create(Self);
  141: Result := TIgsEntity141.Create(Self);
  142: Result := TIgsEntity142.Create(Self);
  143: Result := TIgsEntity143.Create(Self);
  144: Result := TIgsEntity144.Create(Self);
  314: Result := TIgsEntity314.Create(Self);
  end;
  if not assigned(Result) then
    Result := TIgsEntity.Create(Self);
end;

destructor TIgsFormat.Destroy;
begin
  FreeAndNil(FEntities);
  FreeAndNil(FStructure);
  FreeAndNil(FLevels);
  FreeAndNil(FLines);
  FreeAndNil(FStartSection);
  inherited;
end;

function TIgsFormat.EntityBySequenceNumber(
  ASequenceNumber: integer): TIgsEntity;
begin
  Result := FEntities[(ASequenceNumber - 1) div 2];
end;

function TIgsFormat.GetGlobal: PIgsGlobal;
begin
  Result := @FGlobal;
end;

procedure TIgsFormat.LoadFromFile(const AFileName: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TIgsFormat.LoadFromStream(S: TStream);
var
  Global: TIgsContentStream;
  LineNum: integer;
  Line: TIgsLine;
begin
  // Clear previous IGES data
  Clear;

  // Read lines
  ReadIgesLines(S);

  // Read start section
  LineNum := FLines.FindSection('S', 1);
  repeat
    Line := FLines[LineNum];
    if not assigned(Line) or (Line.SectionCode <> 'S') then break;
    FStartSection.Add(Line.Content);
    inc(LineNum);
  until False;

  // Create content stream from global section
  Global := TIgsContentStream.Create;
  try
    Global.Parent := Self;
    LineNum := FLines.FindSection('G', 1);
    if LineNum < 0 then
      raise Exception.Create(sIgsGlobalSectionMissing);

    // Read global content
    while (LineNum < FLines.Count) and (FLines[LineNum].SectionCode = 'G') do begin
      Global.Write(FLines[LineNum].Content[1], 72);
      inc(LineNum);
    end;
    Global.Position := 0;

    // Read global properties from content stream
    ReadGlobalSection(Global);

  finally
    FreeAndNil(Global);
  end;

  // Read directory
  LineNum := FLines.FindSection('D', 1);
  if LineNum < 0 then
    exit;
  ReadDirectorySection(LineNum);

  // Read entity parameters
  LineNum := FLines.FindSection('P', 1);
  if LineNum < 0 then
    exit;
  ReadParameterSection(LineNum);

  // Check if last line is terminator
  Line := FLines[FLines.Count - 1];
  if not assigned(Line) or (Line.SectionCode <> 'T') then
    raise Exception.Create(sIgsTerminationSectionMissing);

  // Now we can safely throw away the lines, all info is stored
  FLines.Clear;

  // Build the geometry structure
  BuildStructure;

  // Build levels
  BuildLevels;
end;

procedure TIgsFormat.New;
begin
  Clear;
end;

procedure TIgsFormat.ReadDirectorySection(AStartLine: integer);
var
  L: TIgsLine;
  E: TIgsEntity;
  D: TIgsDirectory;
  // local
  function IntFromPosition(APos: integer): integer;
  var
    S: string;
  begin
    S := trim(copy(L.Content, APos, 8));
    if length(S) = 0 then
      Result := 0
    else
      Result := StrToInt(S);
  end;
// main
begin
  L := FLines[AStartLine];
  while assigned(L) and (L.SectionCode = 'D') do begin

    // Fill directory record
    FillChar(D, SizeOf(D), 0);

    // First line
    D.SequenceNumber     := L.SequenceNumber;
    D.EntityType         := IntFromPosition(1);
    D.ParameterData      := IntFromPosition(9);
    D.Structure          := IntFromPosition(17);
    D.LineFontPattern    := IntFromPosition(25);
    D.Level              := IntFromPosition(33);
    D.View               := IntFromPosition(41);
    D.TransformMatrix    := IntFromPosition(49);
    D.LabelDispAssoc     := IntFromPosition(57);
    D.Status             := IntFromPosition(65);

    // Second line
    L := FLines[AStartLine + 1];
    if not assigned(L) or (L.SectionCode <> 'D') then
      raise Exception.Create(sIgsDirectory2ndLineMissing);
    D.LineWeight         := IntFromPosition(9);
    D.Color              := IntFromPosition(17);
    D.ParameterLineCount := IntFromPosition(25);
    D.Form               := IntFromPosition(33);
    D.EntityLabel        := trim(Copy(L.Content, 57, 8));
    D.EntitySubscript    := IntFromPosition(65);

    // Create new entity
    E := CreateEntity(D.EntityType, D.Form);
    E.FDirectory := D;
    D.EntityLabel := '';// avoid memory leak

    // Add the entity
    FEntities.Add(E);

    // Go to next directory entry
    inc(AStartLine, 2);
    L := FLines[AStartLine];

  end;
end;

procedure TIgsFormat.ReadGlobalSection(S: TIgsContentStream);
begin
  with FGlobal do begin
    ParamDelim := S.ReadChar(ParamDelim);
    RecordDelim := S.ReadChar(RecordDelim);
    ProductIDSender := S.ReadString;
    FileName := S.ReadString;
    NativeSystemID := S.ReadString;
    PreprocessorVersion := S.ReadString;
    NumBitsForInt := S.ReadInt(32);
    MaxPowTenSinglePrecision := S.ReadInt(38);
    NumSignDigitsSinglePrecision := S.ReadInt(6);
    MaxPowTenDoublePrecision := S.ReadInt(308);
    NumSignDigitsDoublePrecision := S.ReadInt(15);
    ProductIDReceiver := S.ReadString;
    ModelSpaceScale := S.ReadFloat(1.0);
    UnitsFlag := S.ReadInt(1);
    UnitsName := S.ReadString('INCH');
    NumLineWeightGrad := S.ReadInt(1);
    WidthMaxLineWeight := S.ReadFloat;
    ExchangeDate := S.ReadDate;
    MinimumResolution := S.ReadFloat;
    MaxCoordinateValue := S.ReadFloat;
    AuthorName := S.ReadString;
    AuthorOrganization := S.ReadString;
    VersionSpecFlag := S.ReadInt(3);
    DraftingStandardFlag := S.ReadInt;
    ModifiedDate := S.ReadDate;
    Protocol := S.ReadString;
  end;
end;

procedure TIgsFormat.ReadIgesLines(S: TStream);
var
  AContent, ANumString: string;
  Len: integer;
  ACode, AChar: char;
  ALine: TIgsLine;
begin
  // Prepare
  SetLength(AContent, 72);
  SetLength(ANumString, 7);
  repeat

    // Skip control characters
    repeat
      Len := S.Read(AChar, 1);
      if Len = 0 then exit;
    until ord(AChar) > $1F;

    // Read in total 72 content characters
    AContent[1] := AChar;
    Len := S.Read(AContent[2], 71);
    if Len < 71 then exit;

    // Read section code
    Len := S.Read(ACode, 1);
    if Len < 1 then break;
    case ACode of
    'S', 'G', 'D', 'P', 'T':; // these are ok
    'C': // compressed IGES not supported
      raise Exception.Create(sIgsCompressedIGSNotSupported);
    else
      raise Exception.Create(sIgsIllegalSectionCode);
    end;

    // Read sequence number
    Len := S.Read(ANumString[1], 7);
    if Len < 7 then exit;

    // Construct a line and add it
    ALine := TIgsLine.Create;
    ALine.Content := AContent;
    ALine.SectionCode := ACode;
    ALine.SequenceNumber := StrToInt(ANumString);

    // Add to our lines
    FLines.Add(ALine);
  until False;
end;

procedure TIgsFormat.ReadParameterSection(AStartLine: integer);
var
  i, j, DirSequence: integer;
  E: TIgsEntity;
  L: TIgsLine;
  Content: TIgsContentStream;
  S: string;
  CharPos: integer;
  Param: TIgsParameter;
begin
  for i := 0 to FEntities.Count - 1 do begin
    E := FEntities[i];
    if (E.Directory.ParameterLineCount = 0) or
       (E.Directory.ParameterData < 1) then continue;

    // Get parameter content
    Content := TIgsContentStream.Create;
    try
      Content.Parent := Self;
      for j := 1 to E.Directory.ParameterLineCount do begin
        L := FLines[AStartLine + E.Directory.ParameterData + j - 2];
        if not assigned(L) or (L.SectionCode <> 'P') then
          raise Exception.Create(sIgsParameterDirSequenceError);
        // Check if this is a parameter line of our entity
        DirSequence := StrToInt(copy(L.Content, 66, 7));
        if DirSequence <> E.Directory.SequenceNumber then
          raise Exception.Create(sIgsParameterDirSequenceError);
        // Add to content stream
        Content.Write(L.Content[1], 64);
      end;
      Content.Position := 0;

      // Read parameter list from content stream
      while not Content.EOFReached do begin
        S := Content.ReadField;
        if not Content.EOFReached then begin

          // Empty?
          if length(S) = 0 then begin
            Param := TIgsParameter.Create;
            E.Parameters.Add(Param);
            continue;
          end;

          // string?
          CharPos := Pos('H', S);
          if CharPos > 0 then begin
            Param := TIgsStringParameter.Create;
            Param.AsString := Content.ReadHollerith(S, CharPos);
            E.Parameters.Add(Param);
            continue;
          end;

          // float?
          CharPos := Max(Max(Pos('.', S), Pos('E', S)), Pos('D', S));
          if CharPos > 0 then begin
            Param := TIgsFloatParameter.Create;
            Param.AsFloat := Content.StringToFloat(S);
            E.Parameters.Add(Param);
            continue;
          end;

          // must be integer
          Param := TIgsIntParameter.Create;
          Param.AsInt := StrToInt(S);
          E.Parameters.Add(Param);
        end;

      end;
    finally
      Content.Free;
    end;

    // Check first parameter, and remove it (we don't need it)
    if E.Parameters.Count = 0 then
        raise Exception.Create(sIgsParametersMissing);
    if E.Parameters[0].AsInt <> E.Directory.EntityType then
      raise Exception.Create(sIgsInvalidParameter);
    E.Parameters.Delete(0);
  end;
end;

procedure TIgsFormat.SaveToFile(const AFileName: string);
begin
// to do
end;

function TIgsFormat.UnitsToSI: double;
begin
  case FGLobal.UnitsFlag of
  1:  Result := 25.4 / 1000;         // inch
  2:  Result := 1 / 1000;            // mm
  4:  Result := (12 * 25.4) / 1000;  // feet
  5:  Result :=  1609.344;           // miles
  6:  Result := 1;                   // meters
  7:  Result := 1000;                // kilometers
  8:  Result := 25.4;                // 0.001 inch
  9:  Result := 1E-6;                // microns
  10: Result := 0.01;                // cm
  11: Result := 25.4 * 1000;         // micro inch
  else
    Result := 1;
  end;
end;

end.

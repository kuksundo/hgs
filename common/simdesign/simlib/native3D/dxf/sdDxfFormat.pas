unit sdDxfFormat;
{
  Description:
  Reader and writer for the general *.DXF format.

  DXF consists of a list of properties: a number followed by a line of
  ASCII characters which can be strings or numeric values.

  The properties are arranged into a tree structure, with sections,
  tables, blocks and entities. The basic unit that holds properties is
  called the TDxfItem here.

  Note about units
  the $LUNITS contains a value, which hopefully means this:
  0=Unitless; 1=Inches; 2=Feet; 3=Miles; 4=Millmeters

  Currently recognised drawing entities for import of points:
  - LINE
  - ARC
  - POLYLINE
  - LWPOLYLINE

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 1Feb2006

  Modifications:

  copyright (c) 2006 SimDesign B.V.
}


interface

uses
  Classes, SysUtils, Contnrs, sdPoints3D, sdPoints2D, Math;

type

  TDxfLengthUnits = (
    luUnitless,
    luInches,
    luFeet,
    luMiles,
    luMillimeters
  );

  TDxfFormat = class;
  TDxfItemList = class;
  TDxfLayer = class;

  TDxfProperty = class(TPersistent)
  private
    FId: integer;
    FValue: string;
  public
    constructor CreateIdValue(AId: integer; const AValue: string);
    function LoadFromStrings(S: TStrings; var Line: integer): boolean;
    procedure SaveToStream(S: TStream);
    property Id: integer read FId write FId;
    property Value: string read FValue write FValue;
  end;

  TDxfPropertyList = class(TObjectList)
  private
    function GetItems(Index: integer): TDxfProperty;
    procedure SetItems(Index: integer; const Value: TDxfProperty);
  public
    procedure LoadFromStrings(S: TStrings);
    property Items[Index: integer]: TDxfProperty read GetItems write SetItems; default;
  end;

  TDxfItem = class(TPersistent)
  private
    FItems: TDxfItemList;
    FProperties: TDxfPropertyList;
    FTypeName: string;
    FId: integer;
    FParent: TDxfFormat;
    function GetItemCount: integer;
    function GetName: string;
    function GetPropertyAsString(Id: integer): string;
    procedure SetPropertyAsString(Id: integer; const Value: string);
    function GetPropertyAsInt(Id: integer): integer;
    procedure SetPropertyAsInt(Id: integer; const Value: integer);
    function GetPropertyAsLength(Id: integer): double;
    procedure SetPropertyAsLength(Id: integer; const Value: double);
    function GetPropertyAsFloat(Id: integer): double;
    procedure SetPropertyAsFloat(Id: integer; const Value: double);
    function GetPoint3D(Id: integer): TsdPoint3D;
    procedure SetPoint3D(Id: integer; const Value: TsdPoint3D);
    function ConvertToFloat(const S: string): double;
    function GetText: string;
    procedure SetText(const Value: string);
    function GetColorNumber: integer;
    procedure SetColorNumber(const Value: integer);
  public
    constructor Create(AParent: TDxfFormat); virtual;
    constructor CreateType(AParent: TDxfFormat; const ATypeName: string);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function PropertyByID(Id: integer): TDxfProperty;
    procedure AddItem(AItem: TDxfItem);
    function AddStringProperty(AId: integer; const AValue: string): TDxfProperty;
    procedure SaveToStream(S: TStream);
    function HasEntitiesFollowFlag: boolean;
    function ItemByName(const AName: string): TDxfItem;
    function ItemByTypeName(const ATypeName: string): TDxfItem;
    property Properties: TDxfPropertyList read FProperties write FProperties;
    property PropertyAsString[Id: integer]: string read GetPropertyAsString write SetPropertyAsString;
    property PropertyAsInt[Id: integer]: integer read GetPropertyAsInt write SetPropertyAsInt;
    property PropertyAsFloat[Id: integer]: double read GetPropertyAsFloat write SetPropertyAsFloat;
    property Items: TDxfItemList read FItems{ write FEntities};
    property ItemCount: integer read GetItemCount;
    property Id: integer read FId write FId;
    property TypeName: string read FTypeName write FTypeName;
    property Name: string read GetName;
    // Get or set a length value property. Depending on TDxfFormat.LengthUnits, this
    // value will be computed from/to the stored string and is always given here
    // in meters.
    property PropertyAsLength[Id: integer]: double read GetPropertyAsLength write SetPropertyAsLength;
    // Get a TsdPoint3D from 3 properties starting with base Id. e.g. when Id = 10,
    // Point3D will return the 3D point from id's 10, 20 and 30
    property Point3D[Id: integer]: TsdPoint3D read GetPoint3D write SetPoint3D;
    // Get or set the text property (1)
    property Text: string read GetText write SetText;
    // Get or set the color number property (62)
    property ColorNumber: integer read GetColorNumber write SetColorNumber;
  end;

  // Owned list of DXF items
  TDxfItemList = class(TObjectList)
  private
    function GetItems(Index: integer): TDxfItem;
  public
    function ItemByName(const AName: string): TDxfItem;
    function ItemByTypeName(const ATypeName: string): TDxfItem;
    property Items[Index: integer]: TDxfItem read GetItems; default;
  end;

  TDxfHeaderVar = class(TDxfItem)
  public
    constructor Create(AParent: TDxfFormat); override;
  end;

  TDxfEntity = class(TDxfItem)
  private
    function GetLayerName: string;
    function GetLayer: TDxfLayer;
  public
    // Create a list of points from the entity. If BreakupLength > 0, intermediate
    // points may be added if line segments are longer than BreakupLength.
    // The points filled into the pointlist are transformed to units meters.
    procedure ToPolygon(AList: TsdPolygon3D; const BreakupLength: double = 0); virtual;
    // Create the entity from a list of points, and a total of PointCount points.
    // The points in the pointlist should be in units meters.
    procedure FromPointList(Points: PsdPoint3D; PointCount: integer); virtual;
    property LayerName: string read GetLayerName;
    property Layer: TDxfLayer read GetLayer;
  end;

  TDxfEntityList = class(TList)
  private
    function GetItems(Index: integer): TDxfEntity;
  public
    property Items[Index: integer]: TDxfEntity read GetItems; default;
  end;

  TDxfLayer = class(TDxfItem)
  private
    function GetIsInUse: boolean;
  public
    property IsInUse: boolean read GetIsInUse;
  end;

  TDxfLayerList = class(TList)
  private
    function GetItems(Index: integer): TDxfLayer;
  public
    function ByName(const AName: string): TDxfLayer;
    property Items[Index: integer]: TDxfLayer read GetItems; default;
  end;

  TDxfLine = class(TDxfEntity)
  public
    procedure ToPolygon(AList: TsdPolygon3D; const BreakupLength: double = 0); override;
    procedure WriteProps(const AP1, AP2: TsdPoint2D);
  end;

  TDxfArc = class(TDxfEntity)
  public
    procedure ToPolygon(AList: TsdPolygon3D; const BreakupLength: double = 0); override;
    procedure WriteProps(const IsClockWise: boolean; const AP1, AP2, APc: TsdPoint2D);
  end;

  TDxfPolyLine = class(TDxfEntity)
  private
    function GetIsClosed: boolean;
    procedure SetIsClosed(const Value: boolean);
  public
    constructor Create(AParent: TDxfFormat); override;
    procedure FromPointList(Points: PsdPoint3D; PointCount: integer); override;
    procedure ToPolygon(AList: TsdPolygon3D; const BreakupLength: double = 0); override;
    property IsClosed: boolean read GetIsClosed write SetIsClosed;
  end;

  TDxfVertex = class(TDxfEntity)
  public
    constructor Create(AParent: TDxfFormat); override;
  end;

  TDxfLwPolyline = class(TDxfPolyline)
  public
    procedure ToPolygon(AList: TsdPolygon3D; const BreakupLength: double = 0); override;
  end;

  TsdStringEvent = procedure (Sender: TObject; const AMessage: string) of object;

  // DXF format reader (*.dxf files). This is just a reader, does not render
  // the DXF. For the renderer, see unit sdDxfToScene3D
  TDxfFormat = class(TComponent)
  private
    FSections: TDxfItemList;
    FEntities: TDxfEntityList;
    FLayers: TDxfLayerList;
    FLengthUnits: TDxfLengthUnits;
    FNextHandle: integer;
    FDecimalPlaces: integer;
    FInvertedArcs: boolean;
    FOnProgress: TsdStringEvent;
    procedure CreateSubList(Target, Source: TDxfItemList; Start, Close: string;
      MindFlag: boolean = false);
  protected
    function CreateNewDxfItemFromTypeName(const AName: string): TDxfItem;
    procedure Clear;
    procedure UpdateLists;
    procedure UpdateEntityList;
    procedure UpdateLayerList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure New;
    procedure LoadFromStream(S: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure SaveToStream(S: TStream);
    procedure SaveToFile(const FileName: string);
    function AddSection(const AName: string): TDxfItem;
    procedure AddEntity(AEntity: TDxfEntity);
    function AddHeaderVar(const AName: string): TDxfHeaderVar;
    function SectionByName(const AName: string): TDxfItem;
    function TableByName(const AName: string): TDxfItem;
    function GetHeaderVar(const AName: string): TDxfItem;
    function NextHandleAndIncrease: integer;
    property Sections: TDxfItemList read FSections;
    property Entities: TDxfEntityList read FEntities;
    property Layers: TDxfLayerList read FLayers;
    property LengthUnits: TDxfLengthUnits read FLengthUnits write FLengthUnits;
    property NextHandle: integer read FNextHandle write FNextHandle;
    // Number of decimal places to export in ASCII dxf format
    property DecimalPlaces: integer read FDecimalPlaces write FDecimalPlaces;
    // Export arcs in inverted fashion (necessary for some CAD packages)
    property InvertedArcs: boolean read FInvertedArcs write FInvertedArcs;
    property OnProgress: TsdStringEvent read FOnProgress write FOnProgress;
  end;

const

  // Multiply a value in the DXF with this multiplication factor, based on the
  // value of the $LUNITS variable, the result will be in meters:
  // 0=Unitless; 1=Inches; 2=Feet; 3=Miles; 4=Millmeters
  cDxfLengthUnitConvert: array[TDxfLengthUnits] of double =
    (1.0, 0.0254, 0.3048, 1609.344, 0.001);

function IdDescription(AId: integer): string;

resourcestring

 sNoEntitiesSection = 'No ENTITIES section found';
 sIllegalFloatValue = 'Illegal floating point value "%s"';

// Keywords used inside DXF

const
  cSection    = 'SECTION';
  cEndSec     = 'ENDSEC';
  cHeader     = 'HEADER';
  cTables     = 'TABLES';
  cTable      = 'TABLE';
  cEndTab     = 'ENDTAB';
  cBlocks     = 'BLOCKS';
  cBlock      = 'BLOCK';
  cEndblk     = 'ENDBLK';
  cEntities   = 'ENTITIES';
  cLine       = 'LINE';
  cArc        = 'ARC';
  cPolyline   = 'POLYLINE';
  cLwPolyline = 'LWPOLYLINE';
  cInsert     = 'INSERT';
  cVertex     = 'VERTEX';
  cSeqEnd     = 'SEQEND';
  cLayer      = 'LAYER';
  cLUnits     = '$LUNITS';
  cEOF        = 'EOF';
  cCRLF       = #13#10;

implementation

const
  cDefaultComment = 'DXF generation code by SimDesign BV (www.simdesign.nl)';

function IdDescription(AId: integer): string;
begin
  Result := '';
  case AId of
  1: Result := 'Text';
  2: Result := 'Name';
  3,4: Result := 'Other text';
  5: Result := 'Entity Handle';
  6: Result := 'Line Type Name';
  7: Result := 'Text Style Name';
  8: Result := 'Layer Name';
  10..18: Result := Format('X%d', [AId-9]);
  20..28: Result := Format('Y%d', [AId-19]);
  30..37: Result := Format('Z%d', [AId-29]);
  38: Result := 'Elevation';
  39: Result := 'Thickness';
  40..48: Result := 'Float value';
  49: Result := 'Repeated value';
  50..58: Result := 'Angle';
  60: Result := 'Entity visibility';
  62: Result := 'Color number';
  66: Result := 'Entities follow flag';
  67: Result := 'Model/Paper space';
  68: Result := 'Viewport off';
  69: Result := 'Viewport ID';
  70..78: Result := 'Int value';
  90..99: Result := '32-bit int value';
  100: Result := 'Subclass marker';
  102: Result := 'Control string';
  105: Result := 'DIMVAR object handle';
  210: Result := 'X extrusion dir';
  220: Result := 'Y extrusion dir';
  230: Result := 'Z extrusion dir';
  280..289: Result := '8-bit int value';
  300..309: Result := 'Arbitrary text string';
  310..319: Result := 'Arbitrary binary chunk';
  320..329: Result := 'Arbitrary object handle';
  330..339: Result := 'Soft-pointer handle';
  340..349: Result := 'Hard-pointer handle';
  350..359: Result := 'Soft-owner handle';
  360..369: Result := 'Hard-owner handle';
  999: Result := 'Comment';
  1000: Result := 'EED ASCII string';
  1001: Result := 'Regd application name';
  1002: Result := 'EED Control string';
  1003: Result := 'EED Layer name';
  1004: Result := 'EED Chunk bytes';
  1005: Result := 'EED Database handle';
  1010: Result := 'EED X';
  1020: Result := 'EED Y';
  1030: Result := 'EED Z';
  1011: Result := 'EED X 3D WS position';
  1021: Result := 'EED Y 3D WS position';
  1031: Result := 'EED Z 3D WS position';
  1012: Result := 'EED X 3D WS displacement';
  1022: Result := 'EED Y 3D WS displacement';
  1032: Result := 'EED Z 3D WS displacement';
  1013: Result := 'EED X 3D WS direction';
  1023: Result := 'EED Y 3D WS direction';
  1033: Result := 'EED Z 3D WS direction';
  1040: Result := 'EED Float value';
  1041: Result := 'EED distance value';
  1042: Result := 'EED scale factor';
  1070: Result := 'EED 16-bit signed int';
  1071: Result := 'EED 32-bit signed int';
  end;
end;

{ TDxfProperty }

constructor TDxfProperty.CreateIdValue(AId: integer; const AValue: string);
begin
  Create;
  FId := AId;
  FValue := AValue;
end;

function TDxfProperty.LoadFromStrings(S: TStrings; var Line: integer): boolean;
begin
  Result := False;
  // Load ID
  if Line < S.Count - 1 then begin
    try
      FId := StrToInt(S[Line]);
    except
      exit;
    end;
    // Load Value
    inc(Line);
    FValue := S[Line];
    inc(Line);
    Result := True;
  end;
end;

procedure TDxfProperty.SaveToStream(S: TStream);
var
  Line: string;
begin
  Line := Format('%3d%s%s%s', [FId, cCRLF, FValue, cCRLF]);
  S.Write(Line[1], length(Line));
end;

{ TDxfPropertyList }

function TDxfPropertyList.GetItems(Index: integer): TDxfProperty;
begin
  Result := Get(Index);
end;

procedure TDxfPropertyList.LoadFromStrings(S: TStrings);
var
  AProp: TDxfProperty;
  CanLoad: boolean;
  Line: integer;
begin
  Clear;
  Line := 0;
  repeat
    AProp := TDxfProperty.Create;
    CanLoad := AProp.LoadFromStrings(S, Line);
    if CanLoad then
      Add(AProp)
    else
      AProp.Free;
  until not CanLoad;
end;

procedure TDxfPropertyList.SetItems(Index: integer;
  const Value: TDxfProperty);
begin
  Put(Index, Value);
end;

{ TDxfItem }

procedure TDxfItem.AddItem(AItem: TDxfItem);
begin
  if not assigned(FItems) then
    FItems := TDxfItemList.Create;
  FItems.Add(AItem);
end;

function TDxfItem.AddStringProperty(AId: integer;
  const AValue: string): TDxfProperty;
begin
  Result := TDxfProperty.CreateIdValue(AId, AValue);
  FProperties.Add(Result);
end;

procedure TDxfItem.Assign(Source: TPersistent);
begin
  if Source is TDxfProperty then begin
    FId       := TDxfProperty(Source).Id;
    FTypeName := TDxfProperty(Source).Value;
  end else
    inherited;
end;

function TDxfItem.ConvertToFloat(const S: string): double;
var
  Code: integer;
begin
  Result := 0;
  if length(S) > 0 then begin
    val(S, Result, Code);
    if Code > 0 then
      raise Exception.CreateFmt(sIllegalFloatValue, [S]);
  end;
end;

constructor TDxfItem.Create(AParent: TDxfFormat);
begin
  inherited Create;
  FParent := AParent;
  FProperties := TDxfPropertyList.Create;
end;

constructor TDxfItem.CreateType(AParent: TDxfFormat; const ATypeName: string);
begin
  Create(AParent);
  FTypeName := ATypeName;
end;

destructor TDxfItem.Destroy;
begin
  FreeAndNil(FProperties);
  FreeAndNil(FItems);
  inherited;
end;

function TDxfItem.GetColorNumber: integer;
begin
  Result := PropertyAsInt[62];
end;

function TDxfItem.GetItemCount: integer;
begin
  if assigned(FItems) then
    Result := FItems.Count
  else
    Result := 0;
end;

function TDxfItem.GetName: string;
begin
  Result := PropertyAsString[2];
end;

function TDxfItem.GetPoint3D(Id: integer): TsdPoint3D;
begin
  Result.X := GetPropertyAsLength(Id);
  Result.Y := GetPropertyAsLength(Id + 10);
  Result.Z := GetPropertyAsLength(Id + 20);
end;

function TDxfItem.GetPropertyAsFloat(Id: integer): double;
begin
  Result := ConvertToFloat(GetPropertyAsString(Id))
end;

function TDxfItem.GetPropertyAsInt(Id: integer): integer;
begin
  Result := StrToIntDef(GetPropertyAsString(Id), 0);
end;

function TDxfItem.GetPropertyAsLength(Id: integer): double;
begin
  Result := cDxfLengthUnitConvert[FParent.LengthUnits] * GetPropertyAsFloat(Id);
end;

function TDxfItem.GetPropertyAsString(Id: integer): string;
var
  AProp: TDxfProperty;
begin
  AProp := PropertyByID(ID);
  if assigned(AProp) then
    Result := AProp.Value
  else
    Result := '';
end;

function TDxfItem.GetText: string;
begin
  Result := PropertyAsString[1];
end;

function TDxfItem.HasEntitiesFollowFlag: boolean;
begin
  Result := PropertyAsInt[66] = 1;
end;

function TDxfItem.ItemByName(const AName: string): TDxfItem;
begin
  Result := nil;
  if assigned(FItems) then
    Result := FItems.ItemByName(AName);
end;

function TDxfItem.ItemByTypeName(const ATypeName: string): TDxfItem;
begin
  Result := nil;
  if assigned(FItems) then
    Result := FItems.ItemByTypeName(ATypeName);
end;

function TDxfItem.PropertyByID(Id: integer): TDxfProperty;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FProperties.Count - 1 do
    if FProperties[i].Id = Id then begin
      Result := FProperties[i];
      exit;
    end;
end;

procedure TDxfItem.SaveToStream(S: TStream);
var
  i: integer;
  AProp: TDxfProperty;
begin
  // Header
  AProp := TDxfProperty.CreateIdValue(FId, FTypeName);
  try
    AProp.SaveToStream(S);
  finally
    AProp.Free;
  end;

  // Properties
  for i := 0 to FProperties.Count - 1 do
    FProperties[i].SaveToStream(S);

  // Sub-items
  if assigned(FItems) then
    for i := 0 to FItems.Count - 1 do
      FItems[i].SaveToStream(S);

  // Trailer (if any)
  if TypeName = cSection then begin
    AProp := TDxfProperty.CreateIdValue(0, cEndSec);
    try
      AProp.SaveToStream(S);
    finally
      AProp.Free;
    end;
  end else if TypeName = cTable then begin
    AProp := TDxfProperty.CreateIdValue(0, cEndTab);
    try
      AProp.SaveToStream(S);
    finally
      AProp.Free;
    end;
  end else if (TypeName = cPolyline) and HasEntitiesFollowFlag then begin
    AProp := TDxfProperty.CreateIdValue(0, cSeqEnd);
    try
      AProp.SaveToStream(S);
    finally
      AProp.Free;
    end;
  end else if (TypeName = cInsert) and HasEntitiesFollowFlag then begin
    AProp := TDxfProperty.CreateIdValue(0, cSeqEnd);
    try
      AProp.SaveToStream(S);
    finally
      AProp.Free;
    end;
  end;
end;

procedure TDxfItem.SetColorNumber(const Value: integer);
begin
  PropertyAsInt[62] := Value;
end;

procedure TDxfItem.SetPoint3D(Id: integer; const Value: TsdPoint3D);
begin
  SetPropertyAsLength(Id,      Value.X);
  SetPropertyAsLength(Id + 10, Value.Y);
  SetPropertyAsLength(Id + 20, Value.Z);
end;

procedure TDxfItem.SetPropertyAsFloat(Id: integer; const Value: double);
var
  Mask: string;
  S: string;
begin
  Mask := Format('%%%d.%df', [FParent.DecimalPlaces + 3, FParent.DecimalPlaces]);
  S := Format(Mask{'%8.5f'}, [Value]);
  S := StringReplace(S, ',', '.', [rfReplaceAll]);
  SetPropertyAsString(Id, S);
end;

procedure TDxfItem.SetPropertyAsInt(Id: integer; const Value: integer);
begin
  SetPropertyAsString(Id, IntToStr(Value));
end;

procedure TDxfItem.SetPropertyAsLength(Id: integer; const Value: double);
begin
  // Convert float to length
  SetPropertyAsFloat(Id, Value / cDxfLengthUnitConvert[FParent.LengthUnits]);
end;

procedure TDxfItem.SetPropertyAsString(Id: integer; const Value: string);
var
  AProp: TDxfProperty;
begin
  AProp := PropertyById(Id);
  if not assigned(AProp) then
    AddStringProperty(Id, Value)
  else
    AProp.Value := Value;
end;

procedure TDxfItem.SetText(const Value: string);
begin
  PropertyAsString[1] := Value;
end;

{ TDxfItemList }

function TDxfItemList.GetItems(Index: integer): TDxfItem;
begin
  Result := Get(Index);
end;

function TDxfItemList.ItemByName(const AName: string): TDxfItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].Name = AName then begin
      Result := Items[i];
      exit;
    end;
end;

function TDxfItemList.ItemByTypeName(const ATypeName: string): TDxfItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].TypeName = ATypeName then begin
      Result := Items[i];
      exit;
    end;
end;

{ TDxfEntity }

procedure TDxfEntity.FromPointList(Points: PsdPoint3D;
  PointCount: integer);
begin
// default does nothing
end;

function TDxfEntity.GetLayer: TDxfLayer;
begin
  Result := FParent.Layers.ByName(GetLayerName);
end;

function TDxfEntity.GetLayerName: string;
begin
  Result := PropertyAsString[8];
end;

procedure TDxfEntity.ToPolygon(AList: TsdPolygon3D; const BreakupLength: double);
begin
// default does nothing
end;

{ TDxfEntityList }

function TDxfEntityList.GetItems(Index: integer): TDxfEntity;
begin
  Result := Get(Index);
end;

{ TDxfLayer }

function TDxfLayer.GetIsInUse: boolean;
var
  i: integer;
  AName: string;
begin
  Result := False;
  AName := Name;
  for i := 0 to FParent.Entities.Count - 1 do begin
    if FParent.Entities[i].LayerName = AName then begin
      Result := True;
      exit;
    end;
  end;
end;

{ TDxfLayerList }

function TDxfLayerList.ByName(const AName: string): TDxfLayer;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].Name, AName) = 0 then
    begin
      Result := Items[i];
      exit;
    end;
  Result := nil;
end;

function TDxfLayerList.GetItems(Index: integer): TDxfLayer;
begin
  Result := Get(Index);
end;

{ TDxfLine }

procedure TDxfLine.ToPolygon(AList: TsdPolygon3D; const BreakupLength: double);
var
  APoint: TsdPoint3D;
begin
  // Start point
  APoint := Point3D[10];
  AList.Add(APoint);

  // End point
  APoint := Point3D[11];
  AList.AddWithBreakupLength(APoint, BreakupLength, True);
end;

procedure TDxfLine.WriteProps(const AP1, AP2: TsdPoint2D);
var
  P: TsdPoint3D;
begin
  AddStringProperty(100, 'AcDbLine');
  P.X := AP1.X;
  P.Y := AP1.Y;
  P.Z := 0;
  Point3D[10] := P;
  P.X := AP2.X;
  P.Y := AP2.Y;
  P.Z := 0;
  Point3D[11] := P;
end;

{ TDxfArc }

procedure TDxfArc.ToPolygon(AList: TsdPolygon3D; const BreakupLength: double);
var
  i: integer;
  StartAngle, EndAngle, DeltaAngle, Radius: double;
  SegCount: integer;
  Center: TsdPoint3D;
  // local
  procedure AddPointFromAngle(AAngle: double);
  begin
    AList.Add(sdPoints3D.Point3D(
      Center.X + cos(AAngle) * Radius,
      Center.Y + sin(AAngle) * Radius,
      0));
  end;
// main
begin
  // Start angle / End angle
  StartAngle := PropertyAsFloat[50] * pi / 180;
  EndAngle   := PropertyAsFloat[51] * pi / 180;
  if EndAngle < StartAngle then EndAngle := EndAngle + 2 * pi;
  // Radius and midpoint
  Radius := PropertyAsLength[40];
  Center := Point3D[10];
  // Add first point
  AddPointFromAngle(StartAngle);
  // Determine number of segments
  if BreakupLength > 0 then begin
    DeltaAngle := EndAngle - StartAngle;
    SegCount := Max(1, ceil(Radius * (EndAngle - StartAngle) / BreakupLength));
    // Add intermediate points
    for i := 1 to SegCount - 1 do
      AddPointFromAngle(StartAngle + i * DeltaAngle / SegCount);
  end;
  // Add end point
  AddPointFromAngle(EndAngle);
end;

procedure TDxfArc.WriteProps(const IsClockWise: boolean; const AP1, AP2, APc: TsdPoint2D);
var
  D1, D2: TsdPoint2D;
  Cx, Cy, Angle1, Angle2, Radius: double;
begin
  AddStringProperty(100, 'AcDbCircle');
  SubstractPoint2D(AP1, APc, D1);
  SubstractPoint2D(AP2, APc, D2);
  Cx := APc.X;
  Cy := APc.Y;
  if IsClockWise xor FParent.InvertedArcs then
  begin
    // In the new coordinate system (OCS) the X-axis is inverted, Z-axis points
    // down. This causes the arc to be counterclockwise
    D1.X := -D1.X;
    D2.X := -D2.X;
    Cx := -Cx;
  end;
  Angle1 := Arctan2(D1.Y, D1.X) * 180 / PI;
  Angle2 := Arctan2(D2.Y, D2.X) * 180 / PI;
  Radius := Dist2D(AP1, APc);
  PropertyAsLength[10] := Cx;
  PropertyAsLength[20] := Cy;
  PropertyAsLength[30] := 0;
  PropertyAsLength[40] := Radius;
  if IsClockWise xor FParent.InvertedArcs then
  begin
    AddStringProperty(210, '0');
    AddStringProperty(220, '0');
    AddStringProperty(230, '-1');
  end;
  AddstringProperty(100, 'AcDbArc');
  PropertyAsFloat[50] := Angle1;
  PropertyAsFloat[51] := Angle2;
end;

{ TDxfPolyLine }

constructor TDxfPolyLine.Create(AParent: TDxfFormat);
begin
  inherited;
  FTypeName := cPolyLine;
  FItems := TDxfItemList.Create;
end;

procedure TDxfPolyLine.FromPointList(Points: PsdPoint3D;
  PointCount: integer);
var
  i: integer;
  AVertex: TDxfVertex;
begin
  Items.Clear;
  if PointCount > 0 then begin
    // Set entities follow flag to 1
    PropertyAsInt[66] := 1;
    // Add a vertex item for each point
    for i := 0 to PointCount - 1 do begin
      AVertex := TDxfVertex.Create(FParent);
      AVertex.Point3D[10] := Points^;
      Items.Add(AVertex);
      inc(Points);
    end;

  end else begin
    // Set entities follow flag to 0
    PropertyAsInt[66] := 0;
  end;
end;

function TDxfPolyLine.GetIsClosed: boolean;
begin
  Result := (PropertyAsInt[70] and 1) > 0;
end;

procedure TDxfPolyLine.SetIsClosed(const Value: boolean);
begin
  if Value then
    PropertyAsInt[70] := PropertyAsInt[70] or $01
  else
    PropertyAsInt[70] := PropertyAsInt[70] and $FFFE;
end;

procedure TDxfPolyLine.ToPolygon(AList: TsdPolygon3D; const BreakupLength: double);
var
  i: integer;
  AItem: TDxfItem;
  APoint, FirstPoint: TsdPoint3D;
begin
  for i := 0 to ItemCount - 1 do begin
    AItem := Items[i];
    if AItem.TypeName = cVertex then begin
      APoint := AItem.GetPoint3D(10);
      if i = 0 then begin
        AList.Add(APoint);
        FirstPoint := APoint;
        continue;
      end;
      AList.AddWithBreakupLength(APoint, BreakupLength, True);
      if (i = ItemCount - 1) and (BreakupLength > 0) and IsClosed then
        AList.AddWithBreakupLength(FirstPoint, BreakupLength, False);
    end;
  end;
end;

{ TDxfLwPolyline }

procedure TDxfLwPolyline.ToPolygon(AList: TsdPolygon3D; const BreakupLength: double);
var
  i: integer;
  IsFirst: boolean;
  AProp: TDxfProperty;
  APoint, FirstPoint: TsdPoint3D;
  // local
  procedure AddPoint;
  begin
    if IsFirst then begin
      FirstPoint := APoint;
      IsFirst := False;
      AList.Add(APoint);
      exit;
    end;
    AList.AddWithBreakupLength(APoint, BreakupLength, True);
  end;
// main
begin
  IsFirst := True;
  for i := 0 to Properties.Count - 1 do begin
    AProp := Properties[i];
    if AProp.Id = 10 then begin
      // X coordinate
      APoint.X := cDxfLengthUnitConvert[FParent.LengthUnits] * ConvertToFloat(AProp.Value);
      APoint.Y := 0;
      APoint.Z := 0;
      // Y coordinate
      if i + 1 < Properties.Count then begin
        AProp := Properties[i + 1];
        if AProp.Id = 20 then
          APoint.Y := cDxfLengthUnitConvert[FParent.LengthUnits] * ConvertToFloat(AProp.Value);
      end;
      // Z coordinate
      if i + 2 < Properties.Count then begin
        AProp := Properties[i + 2];
        if AProp.Id = 30 then
          APoint.Z := cDxfLengthUnitConvert[FParent.LengthUnits] * ConvertToFloat(AProp.Value);
      end;
      AddPoint;
    end;
  end;
  // Add last line segment
  if IsClosed and (BreakupLength > 0) then
    AList.AddWithBreakupLength(FirstPoint, BreakupLength, False);
end;

{ TDxfFormat }

procedure TDxfFormat.AddEntity(AEntity: TDxfEntity);
var
  ASection: TDxfItem;
begin
  ASection := SectionByName(cEntities);
  if not assigned(ASection) then
    raise Exception.Create(sNoEntitiesSection);
  ASection.AddItem(AEntity);
  UpdateEntityList;
end;

function TDxfFormat.AddHeaderVar(const AName: string): TDxfHeaderVar;
var
  ASection: TDxfItem;
begin
  ASection := SectionByName(cHeader);
  if not assigned(ASection) then begin
    ASection := TDxfItem.CreateType(Self, cSection);
    ASection.AddStringProperty(2, AName);
    FSections.Insert(0, ASection);
  end;
  Result := TDxfHeaderVar(ASection.ItemByTypeName(AName));
  if not assigned(Result) then begin
    Result := TDxfHeaderVar.Create(Self);
    Result.TypeName := AName;
    ASection.AddItem(Result);
  end;
end;

function TDxfFormat.AddSection(const AName: string): TDxfItem;
begin
  Result := TDxfItem.CreateType(Self, cSection);
  FSections.Add(Result);
  Result.AddStringProperty(2, AName);
end;

procedure TDxfFormat.Clear;
begin
  FSections.Clear;
  FNextHandle := 0;
end;

constructor TDxfFormat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSections := TDxfItemList.Create;
  FLayers := TDxfLayerList.Create;
  FEntities := TDxfEntityList.Create;
  FLengthUnits := luMillimeters;
  FDecimalPlaces := 5;
end;

function TDxfFormat.CreateNewDxfItemFromTypeName(const AName: string): TDxfItem;
begin
  if AName = cLayer then
    Result := TDxfLayer.Create(Self)
  else if AName = cLine then
    Result := TDxfLine.Create(Self)
  else if AName = cArc then
    Result := TDxfArc.Create(Self)
  else if AName = cPolyLine then
    Result := TDxfPolyLine.Create(Self)
  else if AName = cLwPolyLine then
    Result := TDxfLwPolyLine.Create(Self)
  else
    Result := TDxfItem.Create(Self);
end;

procedure TDxfFormat.CreateSubList(Target, Source: TDxfItemList; Start,
  Close: string; MindFlag: boolean = false);
var
  StartIdx, CloseIdx: integer;
  AItem, ASub: TDxfItem;
  StartFound: boolean;
begin
  StartIdx := 0;
  if not assigned(Source) then exit;
  while StartIdx < Source.Count do begin

    // Find start value
    StartFound := Source[StartIdx].TypeName = Start;
    if StartFound and MindFlag then
      // Do we mind the "entities follow" flag?
      StartFound := Source[StartIdx].HasEntitiesFollowFlag;

    // Did we find start value?
    if StartFound then begin

      // Find close value
      CloseIdx := StartIdx + 1;
      while CloseIdx < Source.Count do begin
        if Source[CloseIdx].TypeName = Close then begin
          // We found the close value, so now we can do the mutations

          // Step 1 - put the new item in the target list
          AItem := Source[StartIdx];
          if Target <> Source then begin
            Target.Add(Source.Extract(AItem));
            dec(CloseIdx);
          end else
            inc(StartIdx);

          // Step 2 - add all items between start and close to it
          while StartIdx < CloseIdx do begin
            ASub := Source[StartIdx];
            AItem.AddItem(TDxfItem(Source.Extract(ASub)));
            dec(CloseIdx);
          end;

          // Step 3 - delete the close entity
          Source.Delete(CloseIdx);

          break;
        end else
          inc(CloseIdx);
      end;
      StartIdx := CloseIdx;
    end else
      inc(StartIdx);
  end;
end;

destructor TDxfFormat.Destroy;
begin
  FreeAndNil(FEntities);
  FreeAndNil(FLayers);
  FreeAndNil(FSections);
  inherited;
end;

function TDxfFormat.GetHeaderVar(const AName: string): TDxfItem;
var
  ASection: TDxfItem;
begin
  Result := nil;
  ASection := SectionByName(cHeader);
  if not assigned(ASection) then exit;
  Result := ASection.ItemByTypeName(AName);
end;

procedure TDxfFormat.LoadFromFile(const FileName: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TDxfFormat.LoadFromStream(S: TStream);
var
  Properties: TDxfPropertyList;
  AItem: TDxfItem;
  AProperty: TDxfProperty;
  SL: TStringList;
  i: integer;
begin
  // Start by clearing
  Clear;

  // Load a (long) list of properties
  Properties := TDxfPropertyList.Create;
  try
    // Load properties from a stringlist
    SL := TStringList.Create;
    try
      SL.LoadFromStream(S);
      Properties.LoadFromStrings(SL);
    finally
      SL.Free;
    end;

    // Convert to a list of items
    AItem := nil;
    while Properties.Count > 0 do
    begin
      AProperty := TDxfProperty(Properties.Extract(Properties[0]));
      if AProperty.ID in [0, 9] then begin

        // A new entity or header variable
        // Add the old one to the list first
        if assigned(AItem) then
          FSections.Add(AItem);

        // Now create a new item from the property
        AItem := CreateNewDxfItemFromTypeName(AProperty.Value);
        AItem.Assign(AProperty);
        AProperty.Free;

      end else begin

        // A property belonging to the current item
        if assigned(AItem) then
          AItem.Properties.Add(AProperty)
        else
          AProperty.Free;

      end;
    end;

    // Add last item
    if assigned(AItem) then
      FSections.Add(AItem);

    // Find sections
    CreateSubList(FSections, FSections, cSection, cEndsec);

    // Cycle through sections and find other hierarchy
    for i := 0 to FSections.Count - 1 do
    begin
      AItem := FSections[i];
      if AItem.Name = cTABLES then
      begin

        // Table subentities
        CreateSubList(AItem.Items, AItem.Items, cTable, cEndTab);

{      end else if AItem.Name = cBLOCKS then
      begin

        // Block subentities
        CreateSubList(AItem.Items, AItem.Items, cBlock, cEndBlk);}

      end else if AItem.Name = cENTITIES then
      begin

        // Polyline subentities
        CreateSubList(AItem.Items, AItem.Items, cPolyline, cSeqEnd, True);
        // Insert subentities
        CreateSubList(AItem.Items, AItem.Items, cInsert, cSeqEnd, True);

      end;
    end;

  finally
    Properties.Free;
  end;

  // Update all referencing lists
  UpdateLists;
end;

procedure TDxfFormat.New;
var
  ASection: TDxfItem;
  AItem: TDxfItem;
begin
  // Clear document
  Clear;
  // Add default sections
  ASection := AddSection(cHeader);
  ASection.AddStringProperty(999, cDefaultComment);
  AddSection(cTables);
  AddSection(cEntities);
  AItem := TDxfItem.CreateType(Self, cEOF);
  FSections.Add(AItem);
  UpdateLists;
end;

function TDxfFormat.NextHandleAndIncrease: integer;
begin
  Result := FNextHandle;
  inc(FNextHandle);
end;

procedure TDxfFormat.SaveToFile(const FileName: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TDxfFormat.SaveToStream(S: TStream);
var
  i: integer;
begin
  for i := 0 to FSections.Count - 1 do
    FSections[i].SaveToStream(S);
end;

function TDxfFormat.SectionByName(const AName: string): TDxfItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FSections.Count - 1 do
    if FSections[i].PropertyAsString[2] = AName then begin
      Result := FSections[i];
      exit;
    end;
end;

function TDxfFormat.TableByName(const AName: string): TDxfItem;
var
  ASection: TDxfItem;
begin
  Result := nil;
  ASection := SectionByName(cTables);
  if assigned(ASection) then
    Result := ASection.ItemByName(AName);
end;

procedure TDxfFormat.UpdateEntityList;
var
  i: integer;
  ASection: TDxfItem;
begin
  FEntities.Clear;
  ASection := SectionByName(cEntities);
  if assigned(ASection) then begin
    for i := 0 to ASection.ItemCount - 1 do
      if ASection.Items[i] is TDxfEntity then
        FEntities.Add(ASection.Items[i]);
  end;
end;

procedure TDxfFormat.UpdateLayerList;
var
  i: integer;
  ATable: TDxfItem;
begin
  FLayers.Clear;
  ATable := TableByName(cLayer);
  if assigned(ATable) then begin
    for i := 0 to ATable.ItemCount - 1 do
      if ATable.Items[i] is TDxfLayer then
        FLayers.Add(ATable.Items[i]);
  end;
end;

procedure TDxfFormat.UpdateLists;
begin
  UpdateEntityList;
  UpdateLayerList;
end;

{ TDxfHeaderVar }

constructor TDxfHeaderVar.Create(AParent: TDxfFormat);
begin
  inherited Create(AParent);
  FId := 9;
end;

{ TDxfVertex }

constructor TDxfVertex.Create(AParent: TDxfFormat);
begin
  inherited Create(AParent);
  FTypeName := cVertex;
end;

end.

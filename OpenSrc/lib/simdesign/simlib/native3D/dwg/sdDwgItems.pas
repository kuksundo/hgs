{ sdDwgItems

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdDwgItems;

interface

uses
  sdDwgFormat, sdDwgTypesAndConsts, sdDwgBitReader, sdDwgProperties, SysUtils;

type

  TDwgObject = class(TDwgItem)
  protected
    function ItemFamily: TDwgItemFamily; override;
    procedure LoadItemData(R: TDwgBitReader); override;
  end;

  TDwgEntity = class(TDwgItem)
  private
    FLTypeFlags: byte;
    FPlotStyleFlags: byte;
    FNumReactors: integer;
    function GetColor: integer;
    procedure SetColor(const Value: integer);
    function GetLTypeScale: double;
    procedure SetLTypeScale(const Value: double);
  protected
    function ItemFamily: TDwgItemFamily; override;
    procedure LoadItemData(R: TDwgBitReader); override;
    procedure LoadEntityData(R: TDwgBitReader); virtual;
    procedure LoadHandleData(R: TDwgBitReader); override;
  public
    property Color: integer read GetColor write SetColor;
    property LTypeScale: double read GetLTypeScale write SetLTypeScale;
  end;

  TDwgText = class(TDwgEntity)
  private
  protected
    procedure LoadEntityData(R: TDwgBitReader); override;
  end;

  TDwgLine = class(TDwgEntity)
  private
    FStartPoint: Dwg3DPoint;
    FEndPoint: Dwg3DPoint;
  protected
    procedure LoadEntityData(R: TDwgBitReader); override;
  end;

function DwgItemClassFor(AType: integer): TDwgItemClass;

implementation

{ TDwgObject }

function TDwgObject.ItemFamily: TDwgItemFamily;
begin
  Result := ifObject;
end;

procedure TDwgObject.LoadItemData(R: TDwgBitReader);
begin
//  DoStatus(Format('%s: type %3d', [ItemTypeName, ItemType]));
end;

{ TDwgEntity }

function TDwgEntity.GetColor: integer;
var
  AProp: TDwgProperty;
begin
  AProp := PropByGroupId(cPropColor);
  if assigned(AProp) then
    Result := AProp.AsInteger
  else
    Result := 0;
end;

function TDwgEntity.GetLTypeScale: double;
var
  AProp: TDwgProperty;
begin
  AProp := PropByGroupId(cPropLTypeScale);
  if assigned(AProp) then
    Result := AProp.AsFloat
  else
    Result := 0;
end;

function TDwgEntity.ItemFamily: TDwgItemFamily;
begin
  Result := ifEntity;
end;

procedure TDwgEntity.LoadEntityData(R: TDwgBitReader);
begin
// default does nothing
  DoStatus(Format('%s: type %.2x Color %d LTScale %5.3f',
    [ItemTypeName, ItemType, Color, LTypeScale]));
end;

procedure TDwgEntity.LoadHandleData(R: TDwgBitReader);
var
  i: integer;
  //SubEntRefH: TDwgHandle;
  XdicObjH: TDwgHandle;
  Reactors: TDwgHandle;
  //PrevEntity: TDwgHandle;
  //NextEntity: TDwgHandle;
  PlotStyle: TDwgHandle;
begin
  // SubEntRefH := R.H; // code 3 - when?
  for i := 0 to FNumReactors - 1 do
    Reactors := R.H;   // code 4
  XdicObjH := R.H;   // code 3
  if R.IsR1314 then begin
    LoadProp(R, cPropLayer, smH); // code 5
    if FLTypeFlags = 3 then
      LoadProp(R, cPropLType, smH); // code 5
  end;
  // PrevEntity := R.H; // code 4 - when?
  // NextEntity := R.H; // code 4 - when?
  if R.IsR2000 then begin
    LoadProp(R, cPropLayer, smH); // code 5
    if FLTypeFlags = 3 then
      LoadProp(R, cPropLType, smH); // code 5
    if FPlotStyleFlags = 3 then
      PlotStyle := R.H; // code 5
  end;
end;

procedure TDwgEntity.LoadItemData(R: TDwgBitReader);
{var
  EntMode: byte;
  NoLinks: boolean;}
begin
  // General entity data
  {EntMode := }R.BB;
  FNumReactors := R.BS;
  if R.IsR1314 then
    if R.Bit then
      FLTypeFlags := 3
    else
      FLTypeFlags := 0;
  {NoLinks := }R.Bit;
  LoadProp(R, cPropColor, smBS);
  LoadProp(R, cPropLTypeScale, smBD);
  if R.IsR2000 then begin
    FLTypeFlags     := R.BB;
    FPlotStyleFlags := R.BB;
  end;
  LoadProp(R, cPropInvisibility, smBS);
  if R.IsR2000 then
    LoadProp(R, cPropLineWeight, smRC);

  // Specific entity data
  LoadEntityData(R);
end;

procedure TDwgEntity.SetColor(const Value: integer);
var
  AProp: TDwgProperty;
begin
  AProp := PropByGroupId(cPropColor, True);
  AProp.AsInteger := Value;
end;

procedure TDwgEntity.SetLTypeScale(const Value: double);
var
  AProp: TDwgProperty;
begin
  AProp := PropByGroupId(cPropLTypeScale, True);
  AProp.AsFloat := Value;
end;

{ TDwgText }

procedure TDwgText.LoadEntityData(R: TDwgBitReader);
var
  DataFlags: byte;
  FElevation: double;
  FInsertionPt: Dwg2DPoint;
  FAlignment: Dwg2DPoint;
  FExtrusion: Dwg3DPoint;
  //FThickness: double;
  //FObliqueAng: double;
  FRotationAng: double;
  FHeight: double;
  //FWidthFactor: double;
  FText: string;
  //FGeneration: integer;
  //FHorizAlign: integer;
  //FVertAlign: integer;
begin
{R13-14 Only:
	Elevation	BD	---
	Insertion pt	2RD	10
	Alignment pt	2RD	11
	Extrusion	3BD	210
	Thickness	BD	39
	Oblique ang	BD	51
	Rotation ang	BD	50
	Height	BD	40
	Width factor	BD	41
	Text value	T	1
	Generation	BS	71
	Horiz align.	BS	72
	Vert align.	BS	73
R2000 Only:
	DataFlags	RC		Used to determine presence of subsquent data
	Elevation	RD	---	present if !(DataFlags & 0x01)
	Insertion pt	2RD	10
	Alignment pt	2DD	11	present if !(DataFlags & 0x02), use 10 & 20 values for 2 default values.
	Extrusion	BE	210
	Thickness	BT	39
	Oblique ang	RD	51	present if !(DataFlags & 0x04)
	Rotation ang	RD	50	present if !(DataFlags & 0x08)
	Height	RD	40
	Width factor	RD	41	present if !(DataFlags & 0x10)
	Text value	T	1
	Generation	BS	71	present if !(DataFlags & 0x20)
	Horiz align.	BS	72	present if !(DataFlags & 0x40)
	Vert align.	BS	73	present if !(DataFlags & 0x80)}
  if R.IsR1314 then
  begin
    FElevation := R.BD;
    FInsertionPt := R.RD2;
    FAlignment := R.RD2;
    FExtrusion := R.BD3;
    {FThickness := }R.BD;
    {FObliqueAng := }R.BD;
    FRotationAng := R.BD;
    FHeight := R.BD;
    {FWidthFactor := }R.BD;
    FText := R.Text;
    {FGeneration := }R.BS;
    {FHorizAlign := }R.BS;
    {FVertAlign := }R.BS;
  end else
  begin
    DataFlags := R.RC;
    if DataFlags AND $01 = 0 then
      FElevation := R.RD
    else
      FElevation := 0;
    FInsertionPt := R.RD2;
    if DataFlags AND $02 = 0 then FAlignment := R.DD2(FInsertionPt[0], FInsertionPt[1]);
    FExtrusion := R.BE;
    {FThickness := }R.BT;
    if DataFlags AND $04 = 0 then {FObliqueAng := }R.RD;
    if DataFlags AND $08 = 0 then
      FRotationAng := R.RD
    else
      FRotationAng := 0;  
    FHeight := R.RD;
    if DataFlags AND $10 = 0 then {FWidthFactor := }R.RD;
    FText := R.Text;
    if DataFlags AND $20 = 0 then {FGeneration := }R.BS;
    if DataFlags AND $40 = 0 then {FHorizAlign := }R.BS;
    if DataFlags AND $80 = 0 then {FVertAlign := }R.BS;
  end;
  DoStatus(Format('TEXT at (%5.3f,%5.3f,%5.3f) "%s" height %5.3f Rotation %5.3f',
    [FInsertionPt[0],FInsertionPt[1],FElevation,FText,FHeight,FRotationAng]));
end;

{ TDwgLine }

procedure TDwgLine.LoadEntityData(R: TDwgBitReader);
var
  ZAreZero: boolean;
  FThickness: double;
  FExtrusion: Dwg3DPoint;
begin
  if R.IsR1314 then begin
    FStartPoint := R.BD3;
    FEndPoint   := R.BD3;
  end else begin
    // R2000
    ZAreZero := R.Bit;
    FStartPoint[0] := R.RD;
    FEndPoint[0]   := R.DD(FStartPoint[0]);
    FStartPoint[1] := R.RD;
    FEndPoint[1]   := R.DD(FStartPoint[1]);
    if ZAreZero then begin
      FStartPoint[2] := 0;
      FEndPoint[2]   := 0;
    end else begin
      FStartPoint[2] := R.RD;
      FEndPoint[2]   := R.DD(FStartPoint[2]);
    end;
  end;
  FThickness := R.BT;
  FExtrusion := R.BE;
  DoStatus(Format('LINE (%5.3f,%5.3f,%5.3f) to (%5.3f,%5.3f,%5.3f), Th: %5.3f, Extr (%5.3f,%5.3f,%5.3f)',
    [FStartPoint[0],FStartPoint[1],FStartPoint[2],FEndPoint[0],FEndPoint[1],FEndPoint[2],
     FThickness, FExtrusion[0],FExtrusion[1],FExtrusion[2]]));
end;

{ Utility functions }

function DwgItemClassFor(AType: integer): TDwgItemClass;
begin
  case AType of
  cEntText              : Result := TDwgText;
  cEntAttrib            : Result := TDwgEntity;
  cEntAttDef            : Result := TDwgEntity;
  cEntBlock             : Result := TDwgEntity;
  cEntEndBlk            : Result := TDwgEntity;
  cEntSeqEnd            : Result := TDwgEntity;
  cEntInsert            : Result := TDwgEntity;
  cEntMInsert           : Result := TDwgEntity;
  cEntVertex2D          : Result := TDwgEntity;
  cEntVertex3D          : Result := TDwgEntity;
  cEntVertexMesh        : Result := TDwgEntity;
  cEntVertexPFace       : Result := TDwgEntity;
  cEntVertexPFaceFace   : Result := TDwgEntity;
  cEntPolyline2D        : Result := TDwgEntity;
  cEntPolyline3D        : Result := TDwgEntity;
  cEntArc               : Result := TDwgEntity;
  cEntCircle            : Result := TDwgEntity;
  cEntLine              : Result := TDwgLine;
  cEntDimOrdinate       : Result := TDwgEntity;
  cEntDimLinear         : Result := TDwgEntity;
  cEntDimAligned        : Result := TDwgEntity;
  cEntDimAng3Pt         : Result := TDwgEntity;
  cEntDimAng2Ln         : Result := TDwgEntity;
  cEntDimRadius         : Result := TDwgEntity;
  cEntDimDiameter       : Result := TDwgEntity;
  cEntPoint             : Result := TDwgEntity;
  cEnt3DFace            : Result := TDwgEntity;
  cEntPolylinePFace     : Result := TDwgEntity;
  cEntPolylineMesh      : Result := TDwgEntity;
  cEntSolid             : Result := TDwgEntity;
  cEntTrace             : Result := TDwgEntity;
  cEntShape             : Result := TDwgEntity;
  cEntViewport          : Result := TDwgEntity;
  cEntEllipse           : Result := TDwgEntity;
  cEntSpline            : Result := TDwgEntity;
  cEntRegion            : Result := TDwgEntity;
  cEnt3DSolid           : Result := TDwgEntity;
  cEntBody              : Result := TDwgEntity;
  cEntRay               : Result := TDwgEntity;
  cEntXLine             : Result := TDwgEntity;
  cEntDictionary        : Result := TDwgObject;
  cEntMText             : Result := TDwgEntity;
  cEntLeader            : Result := TDwgEntity;
  cEntTolerance         : Result := TDwgEntity;
  cEntMLine             : Result := TDwgEntity;
  cEntBlockControlObj   : Result := TDwgObject;
  cEntBlockHeader       : Result := TDwgObject;
  cEntLayerControlObj   : Result := TDwgObject;
  cEntLayer             : Result := TDwgObject;
  cEntStyleControlObj   : Result := TDwgObject;
  cEntStyle             : Result := TDwgObject;
  cEntLTypeControlObj   : Result := TDwgObject;
  cEntLType             : Result := TDwgObject;
  cEntViewControlObj    : Result := TDwgObject;
  cEntView              : Result := TDwgObject;
  cEntUCSControlObj     : Result := TDwgObject;
  cEntUCS               : Result := TDwgObject;
  cEntVPortControlObj   : Result := TDwgObject;
  cEntVPort             : Result := TDwgObject;
  cEntAppIdControlObj   : Result := TDwgObject;
  cEntAppId             : Result := TDwgObject;
  cEntDimStyleControlObj: Result := TDwgObject;
  cEntDimStyle          : Result := TDwgObject;
  cEntVPEntHdrCtrlObj   : Result := TDwgObject;
  cEntVPEntHdr          : Result := TDwgObject;
  cEntGroup             : Result := TDwgObject;
  cEntMLineStyle        : Result := TDwgObject;
  else
    // Unknown class
    Result := nil;
  end;
end;

end.

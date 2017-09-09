{ sdScene3DBuilder

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdScene3DBuilder;

interface

uses
  Classes, SysUtils, Contnrs, sdScene3D, sdPoints3D;

type

  TsdSelectByType = (
    sbEntity,
    sbLayer
  );

  TsdAbstractSceneBuilder = class;

  TsdImportItem = class
  private
    FBuilder: TsdAbstractSceneBuilder;
    FSelected: boolean;
    FHighlighted: boolean;
    FName: string;
    FSceneItem: TsdScene3DItem;
    procedure SetName(const Value: string);
  protected
    FRef: TObject;
    function GetName: string; virtual;
    property Builder: TsdAbstractSceneBuilder read FBuilder;
  public
    constructor Create(ABuilder: TsdAbstractSceneBuilder); virtual;
    property SceneItem: TsdScene3DItem read FSceneItem write FSceneItem;
    property Highlighted: boolean read FHighlighted write FHighlighted;
    property Selected: boolean read FSelected write FSelected;
    property Name: string read GetName write SetName;
    property Ref: TObject read FRef;
  end;
  TsdImportItemClass = class of TsdImportItem;

  TsdImportItemList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdImportItem;
  public
    function IndexByRef(ARef: TObject): integer;
    property Items[Index: integer]: TsdImportItem read GetItems; default;
  end;

  TStringEvent = procedure(Sender: TObject; const S: string) of object;

  // Abstract scene builder component. Descendants will import cad entities
  // from a cad format into a standardized TsdScene3D.
  TsdAbstractSceneBuilder = class(TComponent)
  private
    FScene: TsdScene3D;
    FItems: TsdImportItemList;
    FSelectBy: TsdSelectByType;
    FOnMessage: TStringEvent;
    function GetBaseTranslation: PsdPoint3D;
  protected
    FBaseTranslation: TsdPoint3D;
    FCenterBoundingBox: boolean;
    FPreserveYSymmetry: boolean;
    FBreakupLength: double;
    // Override this function to provide the CAD file's units in SI units
    function UnitsToSI: double; virtual;
    function ItemClass: TsdImportItemClass; virtual;
    // Add a new item to the list
    function NewItem(ASceneItem: TsdScene3DItem; ARef: TObject): TsdImportItem;
    procedure Clear; virtual;
    procedure SetSelectBy(const Value: TsdSelectByType); virtual;
    procedure SetDefaults; virtual;
    procedure DoMessage(const S: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BuildScene; virtual;
    procedure UpdateVisibility; virtual;
    property Items: TsdImportItemList read FItems;
    // Breakup length in [m]. Breakup length is used in some descendants to determine
    // how to break up curves into polylines and curved surfaces into triangular meshes.
    property BreakupLength: double read FBreakupLength write FBreakupLength;
    // If true, preserve the Y symmetry when doing centering of the bounding box
    property PreserveYSymmetry: boolean read FPreserveYSymmetry write FPreserveYSymmetry;
    // After import, center the bounding box of the complete scene
    property CenterBoundingBox: boolean read FCenterBoundingBox write FCenterBoundingBox;
    property Scene: TsdScene3D read FScene write FScene;
    property BaseTranslation: PsdPoint3D read GetBaseTranslation;
    property SelectBy: TsdSelectByType read FSelectBy write SetSelectBy;
    property OnMessage: TStringEvent read FOnMessage write FOnMessage;
  end;

implementation

{ TsdImportItem }

constructor TsdImportItem.Create(ABuilder: TsdAbstractSceneBuilder);
begin
  inherited Create;
  FBuilder := ABuilder;
end;

function TsdImportItem.GetName: string;
begin
  Result := FName;
end;

procedure TsdImportItem.SetName(const Value: string);
begin
  FName := Value;
end;

{ TsdImportItemList }

function TsdImportItemList.GetItems(Index: integer): TsdImportItem;
begin
  Result := Get(Index);
end;

function TsdImportItemList.IndexByRef(ARef: TObject): integer;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].Ref = ARef then
    begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

{ TsdAbstractSceneBuilder }

procedure TsdAbstractSceneBuilder.BuildScene;
// The default just does the bounding box calculation and updates the scene.
// Override in descendants, and call inherited at the end.
var
  i: integer;
  Res: boolean;
  BB: TsdBox3D;
  T, S: TsdMatrix3x4;
begin
  if FCenterBoundingBox then
  begin
    // Find bounding box and transform points to around origin
    Res := Scene.BoundingBox(BB);
    if Res then
    begin
      // Only tanslate in an axis if it's far off with 0 location
      FBaseTranslation.X := (BB.XMin + BB.XMax) * 0.5;
      FBaseTranslation.Y := (BB.YMin + BB.YMax) * 0.5;
      FBaseTranslation.Z := (BB.ZMin + BB.ZMax) * 0.5;

      // Keep Y symmetric?
      if FPreserveYSymmetry then
        FBaseTranslation.Y := 0;

      T := TranslationMatrix(
        -FBaseTranslation.X,
        -FBaseTranslation.Y,
        -FBaseTranslation.Z);
      // Make our scene in meters
      S := UniformScalingMatrix(UnitsToSI);

      T := MultiplyMatrix3x4(S, T);
      Scene.HardTransform(T);
    end;
  end;

  // Set all imported Items selected to true to indicate they are selected initiallly
  for i := 0 to FItems.Count - 1 do
    FItems[i].Selected := True;

  // Build the GLScene
  Scene.BuildGLScene;
end;

procedure TsdAbstractSceneBuilder.Clear;
begin
  FScene.Clear;
  FItems.Clear;
end;

constructor TsdAbstractSceneBuilder.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TsdImportItemList.Create(True);
  // Defaults
  SetDefaults;
end;

destructor TsdAbstractSceneBuilder.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TsdAbstractSceneBuilder.DoMessage(const S: string);
begin
  if assigned(FOnMessage) then
    FOnMessage(Self, S);
end;

function TsdAbstractSceneBuilder.GetBaseTranslation: PsdPoint3D;
begin
  Result := @FBaseTranslation;
end;

function TsdAbstractSceneBuilder.ItemClass: TsdImportItemClass;
begin
  Result := TsdImportItem;
end;

function TsdAbstractSceneBuilder.NewItem(ASceneItem: TsdScene3DItem;
  ARef: TObject): TsdImportItem;
// Add a new import item if the reference object does not exist. Add the object
// pointer of the import item to the scene item's tag.
var
  Idx: integer;
begin
  Idx := Items.IndexByRef(ARef);
  if Idx < 0 then
  begin
    Result := ItemClass.Create(Self);
    Result.FSceneItem := ASceneItem;
    Result.FRef := ARef;
    FItems.Add(Result);
  end else
    Result := Items[Idx];
  ASceneItem.Tag := integer(Result);
end;

procedure TsdAbstractSceneBuilder.SetDefaults;
begin
  // Defaults
  FCenterBoundingBox := True;
  FPreserveYSymmetry := False;
  FBreakupLength := 0.005; // 5 mm
end;

procedure TsdAbstractSceneBuilder.SetSelectBy(const Value: TsdSelectByType);
begin
  if FSelectBy <> Value then
  begin
    FSelectBy := Value;
    BuildScene;
  end;
end;

function TsdAbstractSceneBuilder.UnitsToSI: double;
begin
  Result := 1.0;
end;

procedure TsdAbstractSceneBuilder.UpdateVisibility;
begin
  Scene.UpdateGlScene;
end;

end.

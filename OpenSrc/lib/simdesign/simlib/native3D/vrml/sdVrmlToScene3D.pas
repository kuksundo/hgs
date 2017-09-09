unit sdVrmlToScene3D;
{
  Import VRML (Virtual Reality Modeling Language into SimDesigns Scene3D class
  structure

  copyright(c) 2008 SimDesign BV
}

interface

uses
  Classes, SysUtils, sdScene3DBuilder, sdScene3D, VectorTypes, sdScene3DMesh, sdVrmlFormat,
  sdVrmlNodeTypes, sdPoints3D, Contnrs;

type

  // VRML state: current transform, material binding, material, coordinates and shapehints
  TsdVrmlState = class(TPersistent)
  private
    FTransform: TsdMatrix3x4;
    FMaterialBinding: TsdVrmlMaterialBinding;
    FMaterial: TsdVrmlMaterial;
    FCoordinate3: TsdVrmlCoordinate3;
    FShapeHints: TsdVrmlShapeHints;
    function GetTransform: PsdMatrix3x4;
  public
    constructor Create; virtual;
    procedure Assign(ASource: TPersistent); override;
    procedure MultiplyTransform(const AMatrix: TsdMatrix3x4);
    property Transform: PsdMatrix3x4 read GetTransform;
    property MaterialBinding: TsdVrmlMaterialBinding read FMaterialBinding write FMaterialBinding;
    property Material: TsdVrmlMaterial read FMaterial write FMaterial;
    property Coordinate3: TsdVrmlCoordinate3 read FCoordinate3 write FCoordinate3;
    property ShapeHints: TsdVrmlShapeHints read FShapeHints write FShapeHints;
  end;

  // List of VRML states
  TsdVrmlStateList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdVrmlState;
  public
    procedure Push;
    procedure Pop;
    property Items[Index: integer]: TsdVrmlState read GetItems; default;
  end;

  // Build a 3D scene based on the VRML file represented in the Vrml property.
  TsdVrmlSceneBuilder = class(TsdAbstractSceneBuilder)
  private
    FVrml: TsdVrmlFormat;
    // State
    FStates: TsdVrmlStateList;
  protected
    procedure Clear; override;
    procedure ImportNode(ANode: TsdVrmlNode; AParentItem: TsdScene3DItem);
    // Build a triangle surface mesh in AItem from the indexed face set in ANode
    procedure BuildMeshFromIndexedFaceSet(ANode: TsdVrmlIndexedFaceSet; AItem: TsdScene3DMesh);
    // Last state (the one that is active at this level)
    function State: TsdVrmlState;
    procedure SetDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BuildScene; override;
    property Vrml: TsdVrmlFormat read FVrml write FVrml;
  end;

implementation

uses
  sdMesh, sdTesselation, sdScene3DShapes, Graphics;

type

  TsdMatrix3x3 = array[0..2] of TsdPoint3D;

{ TsdVrmlState }

procedure TsdVrmlState.Assign(ASource: TPersistent);
var
  Src: TsdVrmlState;
begin
  if ASource is TsdVrmlState then
  begin
    Src := TsdVrmlState(ASource);
    FTransform := Src.FTransform;
    FMaterialBinding := Src.FMaterialBinding;
    FMaterial := Src.FMaterial;
    FCoordinate3 := Src.FCoordinate3;
    FShapeHints := Src.FShapeHints;
  end else
    inherited;
end;

constructor TsdVrmlState.Create;
begin
  inherited;
  FTransform := cIdentityMatrix3x4;
end;

function TsdVrmlState.GetTransform: PsdMatrix3x4;
begin
  Result := @FTransform;
end;

procedure TsdVrmlState.MultiplyTransform(const AMatrix: TsdMatrix3x4);
begin
  FTransform := MultiplyMatrix3x4(FTransform, AMatrix);
end;

{ TsdVrmlStateList }

function TsdVrmlStateList.GetItems(Index: integer): TsdVrmlState;
begin
  Result := Get(Index);
end;

procedure TsdVrmlStateList.Pop;
begin
  Delete(Count - 1);
end;

procedure TsdVrmlStateList.Push;
var
  S: TsdVrmlState;
begin
  S := TsdVrmlState.Create;
  S.Assign(Items[Count -1]);
  Add(S);
end;

{ TsdVrmlSceneBuilder }

procedure TsdVrmlSceneBuilder.BuildMeshFromIndexedFaceSet(ANode: TsdVrmlIndexedFaceSet;
  AItem: TsdScene3DMesh);
var
  i, j, MaxIdx, FaceIdx, Count: integer;
  M: TsdTriangleMesh3D;
  FaceIndices, TriIndices: TsdIntegerList;
  S: TsdVrmlState;

  // local
  function GetMaterialColor(AFaceIdx: integer): TVector4F;
  var
    Diffuse: PsdPoint3D;
  begin
    Diffuse := S.Material.DiffuseColor[AFaceIdx];
    if assigned(Diffuse) then
    begin
      Result[0] := Diffuse.X;
      Result[1] := Diffuse.Y;
      Result[2] := Diffuse.Z;
      Result[3] := 1.0 - S.Material.Transparency[AFAceIdx];
    end;
  end;

// main
begin
  S := State;

  //AItem.AutoSmooth := True;
  AItem.FaceCulling := True;
  if ANode.HasMaterialIndex then
    AItem.ColorMode := cmPerTriangle
  else
  begin
    AItem.ColorMode := cmSingleColor;
    if assigned(S.Material) then
      AItem.Color := GetMaterialColor(0)
    else
      // default to white
      AItem.GDIColor := clWhite;
  end;
  M := AItem.Mesh;
  M.Clear;

  // Find max index
  MaxIdx := 0;
  for i := 0 to length(ANode.CoordIndex) - 1 do
    if ANode.CoordIndex[i] > MaxIdx then
      MaxIdx := ANode.CoordIndex[i];
  if not assigned(S.Coordinate3) or (MaxIdx >= length(S.Coordinate3.Point)) then
    raise Exception.Create('Not enough vertices in Coordinate3 list');

  // Add vertices
  for i := 0 to MaxIdx do
    M.VertexAdd(
      S.Coordinate3.Point[i].X,
      S.Coordinate3.Point[i].Y,
      S.Coordinate3.Point[i].Z, 0, 0, 0);

  // Add triangles
  i := 0;
  FaceIdx := 0;
  Count := length(ANode.CoordIndex);
  FaceIndices := TsdIntegerList.Create;
  TriIndices := TsdIntegerList.Create;
  try

    repeat
      while (i < Count) and (ANode.CoordIndex[i] <> -1) do
      begin
        FaceIndices.Add(ANode.CoordIndex[i]);
        inc(i);
      end;
      if FaceIndices.Count > 0 then
      begin
        if FaceIndices.Count = 3 then
        begin

          // Directly add the triangle
          M.TriangleAdd(FaceIndices[0], FaceIndices[1], FaceIndices[2]);
          if AItem.ColorMode = cmPerTriangle then
            AItem.Colors[M.TriangleCount - 1] := GetMaterialColor(FaceIdx);

        end else
        begin

          // Tesselate the polygon into a number of triangles
          TriIndices.Clear;
          TesselatePolygon(S.Coordinate3.Point, FaceIndices, TriIndices);
          for j := 0 to TriIndices.Count div 3 - 1 do
          begin
            M.TriangleAdd(TriIndices[j * 3], TriIndices[j * 3 + 1], TriIndices[j * 3 + 2]);
            if AItem.ColorMode = cmPerTriangle then
              AItem.Colors[M.TriangleCount - 1] := GetMaterialColor(FaceIdx);
          end;

        end;
        inc(FaceIdx);
        FaceIndices.Clear;
      end;
      inc(i);
    until i >= Count;

  finally
    FaceIndices.Free;
    TriIndices.Free;
  end;

  // test!
  //AItem.Transparency := 0.5;
end;

procedure TsdVrmlSceneBuilder.BuildScene;
var
  i: integer;
begin
  Clear;
  // Import each of the nodes recursively
  for i := 0 to FVrml.Nodes.Count - 1 do
  begin
    // Import the top nodes with nil parent
    ImportNode(FVrml.Nodes[i], nil);
  end;
  inherited;
end;

procedure TsdVrmlSceneBuilder.Clear;
begin
  inherited;
  FStates.Clear;
  FStates.Add(TsdVrmlState.Create);
end;

constructor TsdVrmlSceneBuilder.Create(AOwner: TComponent);
begin
  inherited;
  // State list
  FStates := TsdVrmlStateList.Create(True);
  FStates.Add(TsdVrmlState.Create);
end;

destructor TsdVrmlSceneBuilder.Destroy;
begin
  FreeAndNil(FStates);
  inherited;
end;

procedure TsdVrmlSceneBuilder.ImportNode(ANode: TsdVrmlNode; AParentItem: TsdScene3DItem);
var
  i: integer;
  Item: TsdScene3DItem;
begin
  // Some classes just provide current values for later reference
  if ANode is TsdVrmlMaterialBinding then
  begin
    State.MaterialBinding := TsdVrmlMaterialBinding(ANode);
    exit;
  end;
  if ANode is TsdVrmlMaterial then
  begin
    State.Material := TsdVrmlMaterial(ANode);
    exit;
  end;
  if ANode is TsdVrmlCoordinate3 then
  begin
    State.Coordinate3 := TsdVrmlCoordinate3(ANode);
    exit;
  end;
  if ANode is TsdVrmlShapeHints then
  begin
    State.ShapeHints := TsdVrmlShapeHints(ANode);
    exit;
  end;
  if ANode is TsdVrmlBaseTransform then
  begin
    // Transform node: we must multiply the transform matrix with the current
    // transform of this group
    State.MultiplyTransform(TsdVrmlBaseTransform(ANode).Matrix^);
    exit;
  end;

  // Create a new item of correct type, this also adds it
  if ANode is TsdVrmlIndexedFaceSet then
  begin
    // 3D Surface Mesh
    Item := TsdScene3DMesh.Create(Scene, AParentItem);
    BuildMeshFromIndexedFaceSet(TsdVrmlIndexedFaceSet(ANode), TsdScene3DMesh(Item));
  end else
    if ANode is TsdVrmlSphere then
    begin
      Item := TsdScene3DSphere.Create(Scene, AParentItem);
      TsdScene3DSphere(Item).Radius := TsdVrmlSphere(ANode).Radius;
    end else
      if ANode is TsdVrmlCube then
      begin
        Item := TsdScene3DCube.Create(Scene, AParentItem);
        TsdScene3DCube(Item).Width := TsdVrmlCube(ANode).Width;
        TsdScene3DCube(Item).Height := TsdVrmlCube(ANode).Height;
        TsdScene3DCube(Item).Depth := TsdVrmlCube(ANode).Depth;
      end else
        if ANode is TsdVrmlGroup then
        begin
          // Group node: dummy cube
          Item := TsdScene3DDummy.Create(Scene, AParentItem);
        end else
        begin
          DoMessage(Format('Unrendered item: %s', [ANode.ClassName]));
          Item := TsdScene3DItem.Create(Scene, AParentItem);
        end;

  // Do the sub-nodes
  if ANode is TsdVrmlGroup then
  begin
    FStates.Push;
    for i := 0 to ANode.NodeCount - 1 do
    begin
      ImportNode(TsdVrmlGroup(ANode).Nodes[i], Item);
    end;
    FStates.Pop;
  end;

  // Do we have an item?
  if assigned(Item) then
  begin
    // we must set the correct transform
    Item.Transform^ := State.Transform^;
  end;
end;

procedure TsdVrmlSceneBuilder.SetDefaults;
begin
  inherited;
  FCenterBoundingBox := False;
end;

function TsdVrmlSceneBuilder.State: TsdVrmlState;
begin
  Result := FStates[FStates.Count - 1];
end;

end.

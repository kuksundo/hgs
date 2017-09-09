unit sdScene3DMesh;
{
  3D Surface mesh unit that plugs into the sdScene3D unit
  
  original author: Nils Haeck M.Sc.
  copyright (c) 2008 by SimDesign BV (www.simdesign.nl)
}
interface

uses
  SysUtils, sdScene3D, sdMesh, sdPoints3D, VectorTypes, GLScene;

type

  TsdColorMode = (
    cmSingleColor,
    cmPerTriangle,
    cmPerVertex
  );

  TsdMeshColorEvent = procedure (Sender: TObject; AIndex: integer; var AColor: TVector4f) of object;

  // 3D Surface mesh, displayed in the 3D Scene
  TsdScene3DMesh = class(TsdScene3DItem)
  private
    FMesh: TsdTriangleMesh3D;
    FColors: array of TVector4f;
    FColorMode: TsdColorMode;
    FOnMeshTriColor: TsdMeshColorEvent;
    FOnMeshVtxColor: TsdMeshColorEvent;
    FAutoSmooth: boolean;
    FFaceCulling: boolean;
    procedure SetColorMode(const Value: TsdColorMode);
    procedure SetAutoSmooth(const Value: boolean);
    function GetColors(Index: integer): TVector4f;
    procedure SetColors(Index: integer; const Value: TVector4f);
    procedure SetFaceCulling(const Value: boolean);
  protected
    procedure SetVisible(const Value: boolean); override;
    procedure UpdateGLSceneObject; override;
    procedure BuildGLSceneObject(AGLParent: TGLBaseSceneObject); override;
    procedure CalculateNormals; virtual;
  public
    constructor Create(AOwner: TsdScene3D; AParent: TsdScene3DItem); override;
    destructor Destroy; override;
    procedure Clear; override;
    function BoundingBox(var ABox: TsdBox3D): boolean; override;
    procedure HardTransform(const ATransform: TsdMatrix3x4); override;
    // The 3D mesh that gets visualised
    property Mesh: TsdTriangleMesh3D read FMesh;
    // Select a color mode, either single color for whole mesh, colors per triangle
    // or colors per vertex.
    property ColorMode: TsdColorMode read FColorMode write SetColorMode;
    // When True, vertex normals are calculated, that are interpolated from
    // surrounding triangle normals, giving the smoothed perception
    property AutoSmooth: boolean read FAutoSmooth write SetAutoSmooth;
    // If True, faces will be culled
    property FaceCulling: boolean read FFaceCulling write SetFaceCulling;
    // Statically set the color for vertices or triangles, representing the
    // diffuse color.
    property Colors[Index: integer]: TVector4f read GetColors write SetColors;
    // Connect to this event to interactively set the color of the mesh vertices
    property OnMeshVtxColor: TsdMeshColorEvent read FOnMeshVtxColor write FOnMeshVtxColor;
    // Connect to this event to interactively set the color of the mesh triangles
    property OnMeshTriColor: TsdMeshColorEvent read FOnMeshTriColor write FOnMeshTriColor;
  end;

implementation

uses
  GLMesh, GLMisc, GLTexture;

{ TsdScene3DMesh }

function TsdScene3DMesh.BoundingBox(var ABox: TsdBox3D): boolean;
begin
  Result := FMesh.VertexCount > 0;
  if not Result then
    exit;
  ABox := BoundingBox3D(FMesh.Vertices[0], FMesh.VertexCount);
end;

procedure TsdScene3DMesh.BuildGLSceneObject(AGLParent: TGLBaseSceneObject);
var
  GM: TGLMesh;
begin
  GLObject := TGLMesh.Create(AGLParent);
  AGLParent.AddChild(GLObject);
  GM := TGLMesh(GLObject);
  GM.Mode := mmTriangles;
  GM.VisibilityCulling := vcNone;
  GM.VertexMode := vmVNC;
  if FFaceCulling then
    GM.Material.FaceCulling := fcCull
  else
    GM.Material.FaceCulling := fcNoCull;
  GM.Material.BackProperties.PolygonMode := pmFill;
  GM.Material.FrontProperties.PolygonMode := pmFill; //pmLines;
  if Transparency = 1.0 then
    GM.Material.BlendingMode := bmOpaque
  else
    GM.Material.BlendingMode := bmTransparency;
  SetVisible(Visible);
end;

procedure TsdScene3DMesh.CalculateNormals;
begin
  // Re-calculate normals
  if FAutoSmooth then
    FMesh.CalculateNormals
  else
    FMesh.CalculateTriNormals;
end;

procedure TsdScene3DMesh.Clear;
begin
  FMesh.Clear;
end;

constructor TsdScene3DMesh.Create(AOwner: TsdScene3D; AParent: TsdScene3DItem);
begin
  inherited;
  FMesh := TsdTriangleMesh3D.Create;
end;

destructor TsdScene3DMesh.Destroy;
begin
  FreeAndNil(FMesh);
  inherited;
end;

function TsdScene3DMesh.GetColors(Index: integer): TVector4f;
begin
  if (Index >= 0) and (Index < length(FColors)) then
    Result := FColors[Index]
  else
    FillChar(Result, SizeOf(Result), 0);
end;

procedure TsdScene3DMesh.HardTransform(const ATransform: TsdMatrix3x4);
begin
  // Transform all the vertices in the mesh
  TransformPoints(FMesh.Vertices[0], FMesh.Vertices[0], FMesh.VertexCount, ATransform);
  // Re-calculate normals
  CalculateNormals;
end;

procedure TsdScene3DMesh.SetAutoSmooth(const Value: boolean);
begin
  if FAutoSmooth <> Value then
  begin
    FAutoSmooth := Value;
    Invalidate;
  end;
end;

procedure TsdScene3DMesh.SetColors(Index: integer; const Value: TVector4f);
begin
  // verify size of colors array
  case FColorMode of
  cmPerTriangle: SetLength(FColors, FMesh.TriangleCount);
  cmPerVertex: SetLength(FColors, FMesh.VertexCount);
  end;
  // Now set the color
  if (Index >= 0) and (Index < length(FColors)) then
  begin
    FColors[Index] := Value;
  end;
end;

procedure TsdScene3DMesh.SetColorMode(const Value: TsdColorMode);
begin
  if FColorMode <> Value then
  begin
    FColorMode := Value;
    Invalidate;
  end;
end;

procedure TsdScene3DMesh.SetFaceCulling(const Value: boolean);
begin
  if FFaceCulling <> Value then
  begin
    FFaceCulling := Value;
    Invalidate;
  end;
end;

procedure TsdScene3DMesh.SetVisible(const Value: boolean);
begin
  if GLObject is TGLMesh then
    TGLMesh(GLObject).Visible := Value;
  inherited;
end;

procedure TsdScene3DMesh.UpdateGLSceneObject;
var
  i, j, k: integer;
  GM: TGLMesh;
  Triangle: PsdMeshTriangle;
  Vertex, Normal: PsdPoint3D;
  GLVertex: TVertexData;
  Col: TVector4f;
begin
  CalculateNormals;
  if GLObject is TGLMesh then
  begin
    GM := TGLMesh(GLObject);
    GM.Vertices.Clear;
    Col := Color;
    if FMesh.TriangleCount > 0 then
    begin
      for i := 0 to FMesh.TriangleCount - 1 do
      begin
        Triangle := FMesh.Triangles[i];
        for j := 0 to 2 do
        begin
          Vertex := FMesh.Vertices[Triangle.VertexIdx[j]];
          if FAutoSmooth then
            Normal := FMesh.VtxNormals[Triangle.VertexIdx[j]]
          else
            Normal := FMesh.TriNormals[i];
          for k := 0 to 2 do
          begin
            GLVertex.coord[k] := Vertex.Elem[k];
            GlVertex.normal[k] := Normal.Elem[k];
          end;
          // Static colors
          case FColorMode of
          cmPerTriangle:
            Col := GetColors(i);
          cmPerVertex:
            Col := GetColors(Triangle.VertexIdx[j]);
          end;
          // Dynamic colors
          if assigned(FOnMeshTriColor) then
            FOnMeshTriColor(Self, i, Col);
          if assigned(FOnMeshVtxColor) then
            FOnMeshVtxColor(Self, Triangle.VertexIdx[j], Col);
          GLVertex.Color := Col;
          GM.Vertices.AddVertex(GLVertex);
        end;
      end;
    end;
    GM.StructureChanged;
  end;
end;

end.

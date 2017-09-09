unit sdTriangulateND;

interface

uses
  Classes, SysUtils, Contnrs, sdHelperND;

type

  TsdSegment = class; // forward decl

  // A vertex describes a point in space. In 2D, the vertex has coordinates
  // X and Y, in 3D it has coordinates X, Y, Z; etc.
  // A vertex can belong to a number of segments
  TsdVertex = class(TPersistent)
  private
    FPoint: TsdPoint;
    FSegments: TsdDynObjectArray;
    function GetCoords(Index: integer): double;
    procedure SetCoords(Index: integer; const Value: double);
  public
    constructor CreateDim(N: integer);
    function FirstCoord: PsdCoord;
    function Point: TsdPoint;
    procedure CopyPoint(const APoint: TsdPoint);
    function Segments(Index: integer): TsdSegment;
    function SegmentCount: integer;
    function HasSegment(ASegment: TsdSegment): boolean;
    procedure AddSegment(ASegment: TsdSegment);
    procedure DeleteSegment(ASegment: TsdSegment);
    property Coords[Index: integer]: double read GetCoords write SetCoords;
  end;

  TsdVertexList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdVertex;
  public
    property Items[Index: integer]: TsdVertex read GetItems; default;
  end;

  TsdSimplexFlag = (
    sfHasValidNormals,
    sfHasValidSphere
  );
  TsdSimplexFlags = set of TsdSimplexFlag;

  // A simplex is the minimum volume element in the dimension we work with. In
  // 1D a simplex is a line, in 2D a simplex is a triangle, in 3D it is a
  // tetrahedon, etcetera. The simplex has Dim + 1 vertices, each of Dim. It has
  // Dim + 1 edges, which are simplices in Dim - 1. Edge simplex i contains all
  // vertices of the main simplex, except vertex i. This edge simplex
  // has a normal that is perpendicular to the edge, and pointing away from
  // vertex i.
  // A simplex has a bounding sphere, which has a center, being a point in Dim,
  // and a radius, being a length (1-dimensional). the sphere is created by finding
  // the sphere through Dim + 1 points.
  // Each simplex has a volume. In 1D, this is the length between the two vertices.
  // In 2D this is the area of the triangle, in 3D this is the volume of the
  // tetrahedon, etc
  TsdSimplex = class(TPersistent)
  private
    FFlags: TsdSimplexFlags;
    FVertices: array of TsdVertex;
    FNormals: array of TsdVector;
    FNeighbours: array of TsdSimplex;
    FVolume: TsdFloat;
    FSphereCenter: TsdPoint; // bounding sphere center
    FSphereRadMin: TsdFloat; // bounding min radius
    FSphereRadMax: TsdFloat; // bounding max radius
    function GetVertices(Index: integer): TsdVertex;
    procedure SetVertices(Index: integer; const Value: TsdVertex);
    function GetVolume: double;
  protected
    procedure CalculateNormals;
    procedure CalculateSphere;
    function HasValidNormals: boolean;
    function HasValidSphere: boolean;
  public
    constructor CreateDim(N: integer);
    function Dimension: integer;
    function EdgeCount: integer;
    function Normals(Index: integer): PsdCoord;
    function Center: PsdCoord;
    // AList returns tsdVertex objects making up the edge with Index
    procedure EdgeVertices(Index: integer; var AList: TsdDynObjectArray);
    // AList returns TsdSegment objects belonging to edge with Index
    procedure Segments(Index: integer; var AList: TsdDynObjectArray);
    // Distance of vertex P above the plane through ABase, and with normal ANormal
    class function DistanceAbove(ABase: TsdVertex; const ANormal: TsdVector; P: TsdVertex): double;
    property Vertices[Index: integer]: TsdVertex read GetVertices write SetVertices;
    // Signed volume of this simplex
    property Volume: double read GetVolume;
  end;

  TsdSimplexList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdSimplex;
  public
    property Items[Index: integer]: TsdSimplex read GetItems; default;
  end;

  TsdSegment = class
  end;

  TsdSegmentList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdSegment;
  public
    procedure AddUnique(ASegment: TsdSegment);
    property Items[Index: integer]: TsdSegment read GetItems; default;
  end;

  TsdDelaunayMesh = class(TPersistent)
  end;


resourcestring
  sDimensionsMustAgree = 'Dimensions must agree';

implementation

{ TsdVertex }

procedure TsdVertex.AddSegment(ASegment: TsdSegment);
begin
  AddObject(FSegments, ASegment);
end;

procedure TsdVertex.CopyPoint(const APoint: TsdPoint);
begin
  if length(APoint) <> length(FPoint) then
    raise Exception.Create(sDimensionsMustAgree);
  Move(APoint[0], FPoint[0], length(APoint) * SizeOf(TsdFloat));
end;

constructor TsdVertex.CreateDim(N: integer);
begin
  inherited Create;
  SetLength(FPoint, N);
end;

procedure TsdVertex.DeleteSegment(ASegment: TsdSegment);
begin
  DeleteObject(FSegments, ASegment);
end;

function TsdVertex.FirstCoord: PsdCoord;
begin
  Result := @FPoint[0];
end;

function TsdVertex.GetCoords(Index: integer): double;
begin
  Result := FPoint[Index];
end;

function TsdVertex.HasSegment(ASegment: TsdSegment): boolean;
begin
  Result := IndexOfObject(FSegments, ASegment) >= 0;
end;

function TsdVertex.Point: TsdPoint;
begin
  Result := FPoint;
end;

function TsdVertex.SegmentCount: integer;
begin
  Result := length(FSegments);
end;

function TsdVertex.Segments(Index: integer): TsdSegment;
begin
  Result := TsdSegment(FSegments[Index]);
end;

procedure TsdVertex.SetCoords(Index: integer; const Value: double);
begin
  FPoint[Index] := Value;
end;

{ TsdVertexList }

function TsdVertexList.GetItems(Index: integer): TsdVertex;
begin
  Result := Get(Index);
end;

{ TsdSimplex }

procedure TsdSimplex.CalculateNormals;
var
  i, j: integer;
  Points, Reduced: TsdMatrix;
  Edge: TsdDynObjectArray;
  Dist: double;
  S: TsdSimplex;
begin
  // points in edge array
  SetLength(Points, EdgeCount - 1);

  // Calculate normals for each of the edges
  for i := 0 to EdgeCount - 1 do begin
    // Create points array
    EdgeVertices(i, Edge);
    for j := 0 to length(Edge) - 1 do
      Points[j] := TsdVertex(Edge[j]).Point;
    // Planefit them
    PlaneFit(Points, FNormals[i]);
    // Test sign
    Dist := DistanceAbove(TsdVertex(Edge[0]), FNormals[i], FVertices[i]);
    if Dist > 0 then
      // If the opposite vertex is *above* the plane, we must point the
      // normal the other way
      VectorFlip(FNormals[i]);

    // Calculate volume on i = 0
    if i = 0 then begin
      case Dimension of
      1: FVolume := VectorDistance(FVertices[0].Point, FVertices[1].Point);
      else
        // we create a simplex of lower dimension, and calculate its volume,
        // and use this to calculate our own
        S := TsdSimplex.CreateDim(Dimension - 1);
        try
          // sub simplex built up from Dimension number of vertices
          SetLength(Reduced, Dimension);
          ReduceDimensionality(Points, Reduced, FNormals[i]);
          for j := 0 to Dimension - 1 do begin
            S.Vertices[j] := TsdVertex.CreateDim(Dimension - 1);
            S.Vertices[j].CopyPoint(Reduced[j]);
          end;
          // Now use this sub simplex' volume
          FVolume := abs(Dist) * S.Volume / Dimension;
          for j := 0 to Dimension - 1 do
            S.Vertices[j].Free;
        finally
          S.Free;
        end;
      end;
    end;
  end;
  include(FFlags, sfHasValidNormals);
end;

procedure TsdSimplex.CalculateSphere;
begin
//
end;

function TsdSimplex.Center: PsdCoord;
begin
  if not HasValidSphere then CalculateSphere;
  Result := @FSphereCenter[0];
end;

constructor TsdSimplex.CreateDim(N: integer);
var
  i: integer;
begin
  inherited Create;
  // N + 1 vertices
  SetLength(FVertices, N + 1);
  // N + 1 normals
  SetLength(FNormals, N + 1);
  for i := 0 to N do
    SetLength(FNormals[i], N);
  // N + 1 neighbours
  SetLength(FNeighbours, N + 1);
end;

function TsdSimplex.Dimension: integer;
begin
  Result := length(FVertices) - 1;
end;

class function TsdSimplex.DistanceAbove(ABase: TsdVertex;
  const ANormal: TsdVector; P: TsdVertex): double;
var
  Delta: TsdVector;
begin
  VectorDelta(ABase.Point, P.Point, Delta);
  Result := VectorDot(Delta, ANormal);
end;

function TsdSimplex.EdgeCount: integer;
begin
 Result := length(FVertices);
end;

procedure TsdSimplex.EdgeVertices(Index: integer; var AList: TsdDynObjectArray);
var
  i: integer;
begin
  SetLength(AList, EdgeCount - 1);
  for i := 0 to EdgeCount - 2 do
    AList[i] := Vertices[Index + i + 1];
end;

function TsdSimplex.GetVertices(Index: integer): TsdVertex;
begin
  while Index < 0 do inc(Index, length(FVertices));
  Result := FVertices[Index mod length(FVertices)];
end;

function TsdSimplex.GetVolume: double;
begin
  if not HasValidNormals then CalculateNormals;
  Result := FVolume;
end;

function TsdSimplex.HasValidNormals: boolean;
begin
  Result := sfHasValidNormals in FFlags;
end;

function TsdSimplex.HasValidSphere: boolean;
begin
  Result := sfHasValidSphere in FFlags;
end;

function TsdSimplex.Normals(Index: integer): PsdCoord;
begin
  if not HasValidNormals then CalculateNormals;
  Result := @FNormals[Index, 0];
end;

procedure TsdSimplex.Segments(Index: integer; var AList: TsdDynObjectArray);
// Return the segments for this edge that are shared by all the vertices of this
// edge.
var
  i, j: integer;
  Edge: TsdDynObjectArray;
  V: TsdVertex;
  S: TsdSegment;
  All: boolean;
begin
  SetLength(AList, 0);
  EdgeVertices(Index, Edge);
  V := TsdVertex(Edge[0]);
  for i := 0 to V.SegmentCount - 1 do begin
    S := V.Segments(i);
    All := True;
    for j := 1 to length(Edge) - 1 do
      if not TsdVertex(Edge[j]).HasSegment(S) then begin
        All := False;
        break;
      end;
    if All then AddObject(AList, S);
  end;
end;

procedure TsdSimplex.SetVertices(Index: integer; const Value: TsdVertex);
begin
  FFlags := FFlags - [sfHasValidNormals, sfHasValidSphere];
  while Index < 0 do inc(Index, length(FVertices));
  FVertices[Index mod length(FVertices)] := Value;
end;

{ TsdSimplexList }

function TsdSimplexList.GetItems(Index: integer): TsdSimplex;
begin
  Result := Get(Index);
end;

{ TsdSegmentList }

procedure TsdSegmentList.AddUnique(ASegment: TsdSegment);
begin
  if IndexOf(ASegment) < 0 then
    Add(ASegment);
end;

function TsdSegmentList.GetItems(Index: integer): TsdSegment;
begin
  Result := Get(Index);
end;

end.

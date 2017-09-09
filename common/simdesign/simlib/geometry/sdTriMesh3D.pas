{
  Description:

  2D triangular mesh for use by triangulation routines.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 02Feb2007

  Modifications:

  copyright (c) 2007 SimDesign B.V.
}
unit sdTriMesh3D;

interface

uses
  Classes, SysUtils, Contnrs, Math, sdPoints3D, SortedLists;

type

  TsdTetra3D = class;
  TsdTriMesh3D = class;

  TsdVertex3D = class(TPersistent)
  private
    FPoint: TsdPoint3D;
    FTetra: TsdTetra3D;
    function GetX: double;
    function GetY: double;
    function GetZ: double;
    procedure SetX(const Value: double);
    procedure SetY(const Value: double);
    procedure SetZ(const Value: double);
    function GetPoint: PsdPoint3D;
  public
    constructor Create; virtual;
    constructor CreateWithCoords(const AX, AY, AZ: double);
    procedure Assign(Source: TPersistent); override;
    property X: double read GetX write SetX;
    property Y: double read GetY write SetY;
    property Z: double read GetZ write SetZ;
    property Point: PsdPoint3D read GetPoint;
    // Reference back to the tetrahedon this vertex belongs to. In fact, there can
    // be many tetrahedons this vertex belongs to, but this is one of them (not
    // specified which one). If Tetra = nil, there is no reference yet.
    property Tetra: TsdTetra3D read FTetra write FTetra;
  end;
  TsdVertex3DClass = class of TsdVertex3D;

  TsdVertex3DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdVertex3D;
    procedure SetItems(Index: integer; const Value: TsdVertex3D);
  public
    property Items[Index: integer]: TsdVertex3D read GetItems write SetItems; default;
  end;

  // A segment is a boundary that connects two or more vertices. When a segment is present
  // the tetrahedons bordering it cannot be swapped, thus constraining the triangulation.
  // The segment *must* be convex! All its vertices must lay in one plane.
  TsdSegment3D = class(TPersistent)
  private
    FValidMetrics: boolean;
    FVertices: array of TsdVertex3D;
    FCenter: TsdPoint3D;
    FNormal: TsdPoint3D;
    FSquaredEncroachRadius: double;
    function GetCenter: TsdPoint3D;
    function GetNormal: TsdPoint3D;
    function GetVertexCount: integer;
    procedure SetVertexCount(const Value: integer);
    function GetVertices(Index: integer): TsdVertex3D;
    procedure SetVertices(Index: integer; const Value: TsdVertex3D);
  protected
    procedure CalculateMetrics; virtual;
  public
    procedure Assign(Source: TPersistent); override;
    procedure Invalidate;
    // Replaces references in the segment to OldVertex by a reference to
    // NewVertex.
    procedure ReplaceVertex(OldVertex, NewVertex: TsdVertex3D);
{    // Find the intersection point of us with ASegment, and create and return a vertex
    // if it does, or nil if no intersection.
    function IntersectWith(ASegment: TsdSegment3D): TsdVertex2D;}
{    // Is AVertex lying on this segment? Use the passed precision as tolerance
    // (pass the square of required precision)
    function IsVertexOnSegment(AVertex: TsdVertex2D; APrecisionSqr: double): boolean;
    // Does point P encroach on this segment?
    function PointEncroaches(const P: TsdPoint2D): boolean;
    // Reference to start vertex of this segment
    property Vertex1: TsdVertex2D read FVertex1 write SetVertex1;
    // Reference to end vertex of this segment
    property Vertex2: TsdVertex2D read FVertex2 write SetVertex2;}
    property VertexCount: integer read GetVertexCount write SetVertexCount;
    property Vertices[Index: integer]: TsdVertex3D read GetVertices write SetVertices;
    // Center (midpoint) between the two vertices
    property Center: TsdPoint3D read GetCenter;
    // The normal of this segment. It points outwards from the graph, perpendicular
    // to the segment, and is unit length
    property Normal: TsdPoint3D read GetNormal;
{    // The encroach radius is slightly bigger (10%) than the actual radius of
    // the segment's circle. This way, points encroach on it slightly quicker
    // esp near segment endpoints.
    property SquaredEncroachRadius: double read GetSquaredEncroachRadius;}
  end;
  TsdSegment3DClass = class of TsdSegment3D;

  TsdSegment3DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdSegment3D;
  public
    property Items[Index: integer]: TsdSegment3D read GetItems; default;
  end;

  // hit-test result for hit-testing tetrahedons
  TsdHitTestTetra = (
    httNone,   // Not on the triangle
    httBody,   // On the body of the triangle
    httVtx0,   // On or close to tetra's vertex 0
    httVtx1,   // On or close to tetra's vertex 1
    httVtx2,   // On or close to tetra's vertex 2
    httVtx3,   // On or close to tetra's vertex 3
    httEdge0,  // On the body, and on edge plane 0
    httEdge1,  // On the body, and on edge plane 1
    httEdge2,  // On the body, and on edge plane 2
    httEdge3,  // On the body, and on edge plane 3
    httRib0,   // On the body, and on edge rib 0
    httRib1,   // On the body, and on edge rib 1
    httRib2,   // On the body, and on edge rib 2
    httRib3,   // On the body, and on edge rib 3
    httRib4,   // On the body, and on edge rib 4
    httRib5,   // On the body, and on edge rib 5
    httClose0, // Not on the body but close to edge plane 0
    httClose1, // Not on the body but close to edge plane 1
    httClose2  // Not on the body but close to edge plane 2
  );

  // Basic class for tetrahedons that are present in a triangular 3D volume mesh
  TsdTetra3D = class(TPersistent)
  private
    FVertices: array[0..3] of TsdVertex3D;
    FNormals: array[0..3] of TsdPoint3D;
    FNeighbours: array[0..3] of TsdTetra3D;
    FCenter: TsdPoint3D;
    FRegionIndex: integer;
    function GetVertices(Index: integer): TsdVertex3D;
    procedure SetVertices(Index: integer; const Value: TsdVertex3D);
    function GetNeighbours(Index: integer): TsdTetra3D;
    procedure SetNeighbours(Index: integer; const Value: TsdTetra3D);
    function GetCenter: TsdPoint3D;
  protected
    FValidMetrics: boolean;
    FMesh: TsdTriMesh3D; // pointer back to mesh
    function GetSegments(Index: integer): TsdSegment3D; virtual;
    procedure SetSegments(Index: integer; const Value: TsdSegment3D); virtual;
    // Calcuate metrics for this triangle, may be overridden in descendants to
    // calculate more metrics
    procedure CalculateMetrics; virtual;
    procedure InvalidateSegments;
  public
    constructor Create; virtual;
    procedure Invalidate;
    // Set the vertices a, b, c, d all at the same time
    procedure HookupVertices(VertexA, VertexB, VertexC, VertexD: TsdVertex3D);
    // Set the neighbours a, b, c all at the same time
    procedure HookupNeighbours(TetraA, TetraB, TetraC, TetraD: TsdTetra3D);
    // Replace the neighbour OldNeighbour (if we have it) by NewNeighbour
    procedure ReplaceNeighbour(OldNeighbour, NewNeighbour: TsdTetra3D);
    // Returns index 0, 1, 2, or 3 if ATetra is one of it's neighbours, or -1
    // if ATetra isn't
    function NeighbourIndex(ATetra: TsdTetra3D): integer;
    // Returns index 0, 1, 2 or 3 if AVertex is one of the vertices of this tetra,
    // or -1 if not
    function VertexIndex(AVertex: TsdVertex3D): integer;
    // Returns index 0, 1, 2 or 3 if ASegment is one of the segments of this tetra,
    // or -1 if not
    function SegmentIndex(ASegment: TsdSegment3D): integer;
    // Hit-test the triangle with APoint, and return one of the hittest
    // values.
    function HitTest(const APoint: TsdPoint3D): TsdHitTestTetra;
    // Returns the edge index of the edge that crosses the line when going from
    // the center of this triangle to point APoint (and beyond).
    function EdgeFromCenterTowardsPoint(const APoint: TsdPoint3D): integer;
    // Returns the signed volume of this triangle (result is positive when tetra
    // is defined according to V0V1V2 defining ground plane (counter-clockwise
    // when looking from above), V3 above.
    function Volume: double;
    // Returns the cosine of the smallest angle at vertex Index
    function AngleCosine(Index: integer): double;
    // Returns the cosine of the smallest angle in the tetra
    function SmallestAngleCosine: double;
    // Returns the square of the length of the longest edge rib
    function SquaredLongestEdgeLength: double;
    // References to the vertices of which this triangle consists. The vertices
    // are numbered 0, 1, 2, 3 (also referred to as a, b, c, d).
    // The tetrahedons must always be described according to definition.
    property Vertices[Index: integer]: TsdVertex3D read GetVertices write SetVertices;
    // References to the neighbouring tetras, or nil if there is none at this location
    // Neighbour 0 corresponds to the neighbour at edge plane abc, neighbour 1 to
    // edge plane bcd, neighbour 2 to edge plane cda, and 3 to edge plane dab
    property Neighbours[Index: integer]: TsdTetra3D read GetNeighbours write SetNeighbours;
    // Returns reference to the segment at edge Index. Segments are only actually
    // added in a descendant class, so in the base class TsdTetra3D nil is returned
    property Segments[Index: integer]: TsdSegment3D read GetSegments write SetSegments;
    // Returns center of tetra (4 vertices averaged)
    property Center: TsdPoint3D read GetCenter;
    // Index of the region this triangle belongs to, or -1 if none
    property RegionIndex: integer read FRegionIndex write FRegionIndex;
  end;
  TsdTetra3DClass = class of TsdTetra3D;

  // List of triangles.
  TsdTetra3DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdTetra3D;
  public
    property Items[Index: integer]: TsdTetra3D read GetItems; default;
  end;

  // The object represents general triangle-edge group. Capacity
  // will be increased when needed, but will never be reduced, to avoid memory
  // fragmentation.
  TsdTetraGroup3D = class(TPersistent)
  private
    FTetras: array of TsdTetra3D;
    FEdges: array of integer;
    FCount: integer;
    FCapacity: integer;
    function GetTetras(Index: integer): TsdTetra3D;
  protected
    function GetEdges(Index: integer): integer;
    procedure SetEdges(Index: integer; const Value: integer);
  public
    procedure Clear; virtual;
    // Add a tetra reference and edge index to the end of the list
    procedure AddTetraAndEdge(ATetra: TsdTetra3D; AEdge: integer);
    // Insert a tetra reference and edge index in the list at AIndex
    procedure InsertTetraAndEdge(AIndex: integer; ATetra: TsdTetra3D; AEdge: integer);
    // Delete tetra and edge at AIndex
    procedure Delete(AIndex: integer);
    // Exchange tetra/edge pairs at Index1 and Index2
    procedure Exchange(Index1, Index2: integer);
    // List of triangles in this triangle group
    property Tetras[Index: integer]: TsdTetra3D read GetTetras;
    // Number of triangles in the triangle group
    property Count: integer read FCount;
  end;

  // Represents a cloud of tetras around the center vertex. This class is used in linear
  // searches. All tetras share the center vertex.
  TsdTetraCloud3D = class(TsdTetraGroup3D)
  private
    FCenter: TsdVertex3D;
    procedure SetCenter(const Value: TsdVertex3D);
    function GetVertices(Index: integer): TsdVertex3D;
  protected
    procedure BuildTetraCloud(ABase: TsdTetra3D); virtual;
  public
    procedure Clear; override;
    // Move the triangle fan to another center vertex that lies on the other end
    // of the outgoing edge of triangle at AIndex
    procedure MoveToVertexAt(AIndex, AVtxIndex: integer);
    // Return the index of the tetra that has an intersecting edge plane in direction
    // of APoint
    function TriangleIdxInDirection(const APoint: TsdPoint3D): integer;
    // Return the tetra that has an intersecting edge plane in direction of APoint
    function TriangleInDirection(const APoint: TsdPoint3D): TsdTetra3D;
    // Runs through the Vertices array, and if a vertex matches, it's index is
    // returned. If none matches, -1 is returned.
    function VertexIndex(AVertex: TsdVertex3D): integer;
    // The center vertex of the tetra cloud. Set Center to a vertex in the mesh
    // and the tetra cloud around it will be rebuilt. Center must have a pointer
    // back to a tetra (it cannot be nil)
    property Center: TsdVertex3D read FCenter write SetCenter;
    // List of outward pointing edge plane indices in this triangle fan
    property OutwardEdges[Index: integer]: integer read GetEdges;
{    // Vertices at the other end of the outward pointing edge at Index in the
    // triangle fan
    property Vertices[Index: integer]: TsdVertex3D read GetVertices;}
  end;

  // A group of tetras that all intersect or cover with a segment
  TsdTriangleChain3D = class(TsdTetraCloud3D)
  private
//    FVertex1, FVertex2: TsdVertex3D;
  public
    // Build a triangle chain from Vertex1 to Vertex2. For searching, use ASearchFan
    // if assigned, or use temporary search fan if nil. If a chain was found,
    // the function result is true
    function BuildChain(ASegment: TsdSegment3D; var ASearchFan: TsdTetraCloud3D): boolean;
{    // List of edge indices in this triangle chain.. the edge index points to the
    // edge crossing the line from Vertex1 to Vertex2, except for the last one,
    // where it indicates the index of Vertex2.
    property Edges[Index: integer]: integer read GetEdges write SetEdges;}
  end;

  // A mesh consisting of tetrahedons and vertices, where each tetrahedon contains
  // reference to 4 vertices.
  TsdTriMesh3D = class(TPersistent)
  private
    FPrecision: double;
    FVertices: TsdVertex3DList;
    FTetras: TsdTetra3DList;
    FSegments: TsdSegment3DList;
    FSearchSteps: integer;
    // comparison function to sort tetras by Center.X, smallest values first
    function TetraCompareLeft(Item1, Item2: TObject; Info: pointer): integer;
  protected
    FPrecisionSqr: double;
    procedure SetPrecision(const Value: double); virtual;
    // Create a new vertex of correct class
    function NewVertex: TsdVertex3D;
    class function GetVertexClass: TsdVertex3DClass; virtual;
    // Create a new tetra of correct class
    function NewTetra: TsdTetra3D;
    class function GetTetraClass: TsdTetra3DClass; virtual;
    // Create a new segment of correct class
    function NewSegment: TsdSegment3D;
    class function GetSegmentClass: TsdSegment3DClass; virtual;
    // Initialize info properties
    procedure InitializeInfo; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // Clear the mesh
    procedure Clear; virtual;
    // Create a convex hull around all the vertices in the mesh
    procedure ConvexHull;
    // Optimize the mesh for usage in a finite element method. The tetrahedon list
    // is sorted such that the tetrahedons form a long chain going up and down from
    // left to right, and all vertices used are placed in the AVertices list, which
    // is also sorted by usage in the tetras. Thus, vertices connected to each
    // other usually are also have an index relatively close in the Vertices list,
    // which accomplishes that the finite element matrix is more banded than with
    // a random distribution (and gauss elimination works faster). The AVertices
    // array must be initialized, it will be cleared and then filled with all
    // vertices used by the triangles.
    procedure OptimizeForFEM(AVertices: TsdVertex3DList);
    // Remove all segments that are non-functional (e.g. vertex pointers are nil,
    // or vertex1 and vertex2 point to the same vertex)
    procedure RemoveNonSegments;
    // Get the min and max location of the mesh. Returns false if there are no
    // vertices
    function BoundingBox(var AMin, AMax: TsdPoint3D): boolean;
    // Returns the sum of all tetra's absolute area
    function AbsoluteArea: double;
    // Returns the sum of all tetra's signed area
    function SignedArea: double;
    // Locate the vertex that is closest to APoint. The function returns the closest
    // vertex from the vertex list to APoint. If there are no vertices in the list,
    // nil is returned. The basic algorithm is a linear search but this can
    // be overridden in descendants (to implement e.g. a quadtree approach).
    // A TsdTetraCloud3D object can be passed in ACloud to speed up searching.
    function LocateClosestVertex(const APoint: TsdPoint3D;
      ACloud: TsdTetraCloud3D = nil): TsdVertex3D; virtual;
    // List of vertices used in this mesh
    property Vertices: TsdVertex3DList read FVertices;
    // List of tetrahedons used in this mesh
    property Tetras: TsdTetra3DList read FTetras;
    // List of segments used in this mesh
    property Segments: TsdSegment3DList read FSegments;
    // Precision used when generating mesh. If a point lies within precision
    // from a tetra edge, it is considered to be on it, the edge will be
    // split instead of the body.
    // When a vertex lays within Precision of another vertex, no new triangle
    // will be created, thus the vertex is skipped (not triangulated).
    property Precision: double read FPrecision write SetPrecision;
    // Number of search steps performed in linear search.
    property SearchSteps: integer read FSearchSteps;
  end;
  TsdTriMesh3DClass = class of TsdTriMesh3D;

// Create the normal of a plane through A, B, C, this is the vector perpendicular to
// it, of unit length
function sdNormalFrom3Points(const A, B, C: TsdPoint3D): TsdPoint3D;

// Return the distance of P above the plane with Normal and containing point Base.
// If Dist is negative, P lies below the plane.
function sdAboveBelowDist3D(const Base, Normal, P: TsdPoint3D): double;

function sdBetweenPointsTest2D(const A, B, Point: TsdPoint3D): integer;

const
  // Default precision when triangulating
  cDefaultTriangulationPrecision = 1E-3;

resourcestring

  sInvalidTriangleForSegment = 'Invalid triangle for segment';
  sTriangleVertexHookupError = 'triangle-vertex hookup error';
  sNoTriangleForVertex       = 'No triangle for vertex';

implementation

uses
  sdConvexHull3D;

const
  cOneThird: double = 1/3;

function sdNormalFrom3Points(const A, B, C: TsdPoint3D): TsdPoint3D;
// Create the normal of a plane through A, B, C, this is the vector perpendicular to
// it, of unit length
begin
  CrossProduct3D(Delta3D(A, B), Delta3D(A, C), Result);
  NormalizeVector3D(Result);
end;

function sdAboveBelowDist3D(const Base, Normal, P: TsdPoint3D): double;
// Return the distance of P above the plane with Normal and containing point Base.
// If Dist is negative, P lies below the plane.
begin
  Result := DotProduct3D(Normal, Delta3D(Base, P));
end;

function sdBetweenPointsTest2D(const A, B, Point: TsdPoint3D): integer;
var
  AB, D: TsdPoint3D;
begin
  AB := Delta3D(A, B);
  D := Delta3D(A, Point);
  if DotProduct3D(D, AB) < 0 then begin
    Result := -1;
    exit;
  end;
  D := Delta3D(B, Point);
  if DotProduct3D(D, AB) > 0 then begin
    Result := 1;
    exit;
  end;
  Result := 0;
end;

{ TsdVertex3D }

procedure TsdVertex3D.Assign(Source: TPersistent);
begin
  if Source is TsdVertex3D then begin
    FPoint := TsdVertex3D(Source).FPoint;
    FTetra := TsdVertex3D(Source).FTetra;
  end else
    inherited;
end;

constructor TsdVertex3D.Create;
begin
  inherited;
end;

constructor TsdVertex3D.CreateWithCoords(const AX, AY, AZ: double);
begin
  Create;
  FPoint.X := AX;
  FPoint.Y := AY;
  FPoint.Z := AZ;
end;

function TsdVertex3D.GetPoint: PsdPoint3D;
begin
  Result := @FPoint;
end;

function TsdVertex3D.GetX: double;
begin
  Result := FPoint.X;
end;

function TsdVertex3D.GetY: double;
begin
  Result := FPoint.Y;
end;

procedure TsdVertex3D.SetX(const Value: double);
begin
  FPoint.X := Value;
end;

procedure TsdVertex3D.SetY(const Value: double);
begin
  FPoint.Y := Value;
end;

{ TsdVertex3DList }

function TsdVertex3DList.GetItems(Index: integer): TsdVertex3D;
begin
  Result := Get(Index);
end;

procedure TsdVertex3DList.SetItems(Index: integer;
  const Value: TsdVertex3D);
begin
  Put(Index, Value);
end;

{ TsdSegment3D }

procedure TsdSegment3D.Assign(Source: TPersistent);
var
  i: integer;
begin
  if Source is TsdSegment3D then begin
    SetLength(FVertices, length(TsdSegment3D(Source).FVertices));
    for i := 0 to length(FVertices) - 1 do
      FVertices[i] := TsdSegment3D(Source).FVertices[i];
  end else
    inherited;
end;

procedure TsdSegment3D.CalculateMetrics;
var
  i: integer;
begin
  FCenter := cZero3D;
  if (length(FVertices) < 3) or
     not (assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2])) then
  begin
    FNormal := cZero3D;
    FSquaredEncroachRadius := 0;
  end else begin
    for i := 0 to length(FVertices) - 1 do begin
      AddPoint3D(FCenter, FVertices[i].Point^, FCenter);
    end;
    ScalePoint3D(FCenter, 1 / length(FVertices));

    FSquaredEncroachRadius := 0;
    // Normal
    FNormal := sdNormalFrom3Points(FVertices[0].FPoint, FVertices[1].FPoint, FVertices[2].FPoint);
  end;
  FValidMetrics := True;
end;

function TsdSegment3D.GetCenter: TsdPoint3D;
begin
  if not FValidMetrics then CalculateMetrics;
  Result := FCenter;
end;

function TsdSegment3D.GetNormal: TsdPoint3D;
begin
  if not FValidMetrics then CalculateMetrics;
  Result := FNormal;
end;

{function TsdSegment3D.IntersectWith(ASegment: TsdSegment3D): TsdVertex3D;
var
  R: TsdPoint3D;
  PosP, PosQ: double;
begin
  Result := nil;
  if IntersectLines2D(
    FVertex1.FPoint, FVertex2.FPoint,
    ASegment.Vertex1.FPoint, ASegment.Vertex2.FPoint,
    R, PosP, PosQ) then
  begin
    if (PosP > 0) and (PosP < 1) and (PosQ > 0) and (PosQ < 1) then begin
      // OK we found an intersection, lying within both segments
      Result := TsdVertex3D.CreateWithCoords(R.X, R.Y);
    end;
  end;
end;}

procedure TsdSegment3D.Invalidate;
begin
  FValidMetrics := False;
end;

{function TsdSegment3D.IsVertexOnSegment(AVertex: TsdVertex3D; APrecisionSqr: double): boolean;
begin
  Result := PointToLineDist2DSqr(AVertex.FPoint,
    FVertex1.FPoint, FVertex2.FPoint) <= APrecisionSqr;
end;

function TsdSegment3D.PointEncroaches(const P: TsdPoint3D): boolean;
var
  C: TsdPoint3D;
begin
  C := GetCenter;
  Result := SquaredDist2D(C, P) < FSquaredEncroachRadius;
end;}

procedure TsdSegment3D.ReplaceVertex(OldVertex, NewVertex: TsdVertex3D);
begin
  if FVertex1 = OldVertex then
    SetVertex1(NewVertex);
  if FVertex2 = OldVertex then
    SetVertex2(NewVertex);
end;

procedure TsdSegment3D.SetVertex1(const Value: TsdVertex3D);
begin
  FVertex1 := Value;
  FValidMetrics := False;
end;

procedure TsdSegment3D.SetVertex2(const Value: TsdVertex3D);
begin
  FVertex2 := Value;
  FValidMetrics := False;
end;

{ TsdSegment3DList }

function TsdSegment3DList.GetItems(Index: integer): TsdSegment3D;
begin
  Result := Get(Index);
end;

{ TsdTetra3D }

function TsdTetra3D.AngleCosine(Index: integer): double;
var
  D1, D2: TsdPoint3D;
begin
  Result := 0;
  if not (assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2])) then
    exit;
  D1 := Delta2D(Vertices[Index].FPoint, Vertices[Index + 1].FPoint);
  D2 := Delta2D(Vertices[Index].FPoint, Vertices[Index + 2].FPoint);
  NormalizeVector2D(D1);
  NormalizeVector2D(D2);
  Result := DotProduct2D(D1, D2);
end;

function TsdTetra3D.Area: double;
var
  Pa, Pb, Pc: PsdPoint2D;
begin
  if assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2]) then
  begin
    Pa := FVertices[0].Point;
    Pb := FVertices[1].Point;
    Pc := FVertices[2].Point;
    Result := CrossProduct2D(Delta2D(Pa^, Pb^), Delta2D(Pa^, Pc^)) * 0.5;
  end else
    Result := 0;
end;

procedure TsdTetra3D.CalculateMetrics;
var
  Pa, Pb, Pc: PsdPoint2D;
begin
  if assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2]) then
  begin
    Pa := FVertices[0].Point;
    Pb := FVertices[1].Point;
    Pc := FVertices[2].Point;
    // Center
    FCenter.X := (Pa.X + Pb.X + Pc.X) * cOneThird;
    FCenter.Y := (Pa.Y + Pb.Y + Pc.Y) * cOneThird;
    // Normals
    FNormals[0] := sdNormalFrom2Points(Pa^, Pb^);
    FNormals[1] := sdNormalFrom2Points(Pb^, Pc^);
    FNormals[2] := sdNormalFrom2Points(Pc^, Pa^);
  end;
  // Set flag
  FValidMetrics := True;
end;

constructor TsdTetra3D.Create;
begin
  inherited Create;
  FRegionIndex := -1;
end;

function TsdTetra3D.EdgeFromCenterTowardsPoint(const APoint: TsdPoint3D): integer;
var
  i: integer;
  C, Delta: TsdPoint3D;
  CP1, CP2: double;
begin
  Result := -1;
  if not (assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2])) then
    exit;
  C := GetCenter;
  Delta := Delta2D(C, APoint);
  CP2 := CrossProduct2D(Delta2D(C, Vertices[0].FPoint), Delta);
  for i := 0 to 2 do begin
    CP1 := CP2;
    CP2 := CrossProduct2D(Delta2D(C, Vertices[i + 1].FPoint), Delta);
    if (CP1 >= 0) and (CP2 < 0) then begin
      Result := i;
      exit;
    end;
  end;
end;

function TsdTetra3D.GetCenter: TsdPoint3D;
begin
  if not FValidMetrics then CalculateMetrics;
  Result := FCenter;
end;

function TsdTetra3D.GetNeighbours(Index: integer): TsdTetra3D;
begin
  Result := FNeighbours[Index mod 3];
end;

function TsdTetra3D.GetSegments(Index: integer): TsdSegment3D;
begin
  Result := nil;
end;

function TsdTetra3D.GetVertices(Index: integer): TsdVertex3D;
begin
  Result := FVertices[Index mod 3];
end;

function TsdTetra3D.HitTest(const APoint: TsdPoint3D): TsdHitTestTriangle;
var
  i, Res: integer;
  P: array[0..2] of PsdPoint2D;
  Tol, TolSqr, TolOut, Dist: double;
begin
  Result := httNone;

  if not (assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2])) then
    exit;

  if not FValidMetrics then CalculateMetrics;
  Tol := FMesh.FPrecision;
  TolSqr := FMesh.FPrecisionSqr;
  TolOut := Tol * 1E-3;

  // Sides check to determine insideness
  P[0] := FVertices[0].Point;
  P[1] := FVertices[1].Point;
  P[2] := FVertices[2].Point;

  // Check first side
  for i := 0 to 2 do begin
    Dist := sdAboveBelowDist2D(P[i]^, FNormals[i], APoint);
    // More than TolOut away.. this point is outside this triangle
    if Dist > TolOut then exit;

    if abs(Dist) <= Tol then begin
      // Possibly on this line: check endpoints
      if SquaredDist2D(P[i]^, APoint) < TolSqr then begin
        // Yes on first vertex
        case i of
        0: Result := httVtx0;
        1: Result := httVtx1;
        2: Result := httVtx2;
        end;
        exit;
      end;
      if SquaredDist2D(P[(i + 1) mod 3]^, APoint) < TolSqr then begin
        // Yes on second vertex
        case i of
        0: Result := httVtx1;
        1: Result := httVtx2;
        2: Result := httVtx0;
        end;
        exit;
      end;
      // determine if between two vertices
      Res := sdBetweenPointsTest2D(P[i]^, P[(i + 1) mod 3]^, APoint);
      if Res = 0 then begin
        // Indeed, between the vertices
        if Dist <= 0 then begin
          case i of
          0: Result := httEdge0;
          1: Result := httEdge1;
          2: Result := httEdge2;
          end;
        end else begin
          case i of
          0: Result := httClose0;
          1: Result := httClose1;
          2: Result := httClose2;
          end;
        end;
        exit;
      end;
    end;
  end;

  // Arriving here means inside
  Result := httBody;

end;

procedure TsdTetra3D.HookupNeighbours(TriangleA, TriangleB, TriangleC: TsdTetra3D);
begin
  FNeighbours[0] := TriangleA;
  FNeighbours[1] := TriangleB;
  FNeighbours[2] := TriangleC;
end;

procedure TsdTetra3D.HookupVertices(VertexA, VertexB, VertexC: TsdVertex3D);
begin
  SetVertices(0, VertexA);
  SetVertices(1, VertexB);
  SetVertices(2, VertexC);
end;

procedure TsdTetra3D.Invalidate;
begin
  FValidMetrics := False;
end;

procedure TsdTetra3D.InvalidateSegments;
var
  i: integer;
  S: TsdSegment3D;
begin
  for i := 0 to 2 do begin
    S := Segments[i];
    if assigned(S) then
      S.Invalidate;
  end;
end;

function TsdTetra3D.NeighbourIndex(ATriangle: TsdTetra3D): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to 2 do
    if FNeighbours[i] = ATriangle then begin
      Result := i;
      exit;
    end;
end;

procedure TsdTetra3D.ReplaceNeighbour(OldNeighbour, NewNeighbour: TsdTetra3D);
var
  Idx: integer;
begin
  Idx := NeighbourIndex(OldNeighbour);
  if Idx >= 0 then
    FNeighbours[Idx] := NewNeighbour;
end;

function TsdTetra3D.SegmentIndex(ASegment: TsdSegment3D): integer;
var
  i: integer;
begin
  for i := 0 to 2 do
    if Segments[i] = ASegment then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

procedure TsdTetra3D.SetNeighbours(Index: integer; const Value: TsdTetra3D);
begin
  FNeighbours[Index mod 3] := Value;
end;

procedure TsdTetra3D.SetSegments(Index: integer; const Value: TsdSegment3D);
begin
// Default does nothing
end;

procedure TsdTetra3D.SetVertices(Index: integer; const Value: TsdVertex3D);
var
  Idx: integer;
begin
  Idx := Index mod 3;
  if FVertices[Idx] <> Value then begin
    Value.Triangle := Self;
    FVertices[Idx] := Value;
    FValidMetrics := False;
    InvalidateSegments;
  end;
end;

function TsdTetra3D.SmallestAngleCosine: double;
var
  i: integer;
  D: array[0..2] of TsdPoint3D;
  ACos: double;
begin
  Result := 0;
  if not (assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2])) then
    exit;
  for i := 0 to 2 do begin
    D[i] := Delta2D(Vertices[i].FPoint, Vertices[i + 1].FPoint);
    NormalizeVector2D(D[i]);
  end;
  for i := 0 to 2 do begin
    ACos := abs(DotProduct2D(D[i], D[(i + 1) mod 3]));
    if ACos > Result then
      Result := ACos;
  end;
  if Result > 1 then
    Result := 1;
end;

function TsdTetra3D.SquaredLongestEdgeLength: double;
var
  i: integer;
  L: double;
begin
  Result := 0;
  for i := 0 to 2 do begin
    L := SquaredDist2D(Vertices[i].FPoint, Vertices[i + 1].FPoint);
    if L > Result then
      Result := L;
  end;
end;

function TsdTetra3D.VertexIndex(AVertex: TsdVertex3D): integer;
var
  i: integer;
begin
  for i := 0 to 2 do
    if FVertices[i] = AVertex then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

{ TsdTetra3DList }

function TsdTetra3DList.GetItems(Index: integer): TsdTetra3D;
begin
  Result := Get(Index);
end;

{ TsdTriangleGroup2D }

procedure TsdTriangleGroup2D.AddTriangleAndEdge(ATriangle: TsdTetra3D; AEdge: integer);
begin
  // adjust capacity
  if FCount >= FCapacity then begin
    FCapacity := FCount * 3 div 2 + 4;
    SetLength(FTriangles, FCapacity);
    SetLength(FEdges, FCapacity);
  end;
  FTriangles[FCount] := ATriangle;
  FEdges[FCount] := AEdge mod 3;
  inc(FCount);
end;

procedure TsdTriangleGroup2D.Clear;
begin
  FCount := 0;
end;

procedure TsdTriangleGroup2D.Delete(AIndex: integer);
var
  i: integer;
begin
  if (AIndex < 0) or (AIndex >= FCount) then exit;
  for i := AIndex to FCount - 2 do begin
    FTriangles[i] := FTriangles[i + 1];
    FEdges[i] := FEdges[i + 1];
  end;
  dec(FCount);
end;

procedure TsdTriangleGroup2D.Exchange(Index1, Index2: integer);
var
  T: TsdTetra3D;
  E: integer;
begin
  if (Index1 < 0) or (Index1 >= FCount) or
     (Index2 < 0) or (Index2 >= FCount)then exit;
  T := FTriangles[Index1];
  FTriangles[Index1] := FTriangles[Index2];
  FTriangles[Index2] := T;
  E := FEdges[Index1];
  FEdges[Index1] := FEdges[Index2];
  FEdges[Index2] := E;
end;

function TsdTriangleGroup2D.GetEdges(Index: integer): integer;
begin
  Result := FEdges[Index mod FCount];
end;

function TsdTriangleGroup2D.GetTriangles(Index: integer): TsdTetra3D;
begin
  Result := FTriangles[Index mod FCount];
end;

procedure TsdTriangleGroup2D.InsertTriangleAndEdge(AIndex: integer;
  ATriangle: TsdTetra3D; AEdge: integer);
var
  i: integer;
begin
  // adjust capacity
  if FCount >= FCapacity then begin
    FCapacity := FCount * 3 div 2 + 4;
    SetLength(FTriangles, FCapacity);
    SetLength(FEdges, FCapacity);
  end;
  // Move up above index position
  for i := FCount downto AIndex + 1 do begin
    FTriangles[i] := FTriangles[i - 1];
    FEdges[i] := FEdges[i - 1];
  end;
  // Insert at index position
  FTriangles[AIndex] := ATriangle;
  FEdges[AIndex] := AEdge mod 3;
  inc(FCount);
end;

procedure TsdTriangleGroup2D.SetEdges(Index: integer; const Value: integer);
begin
  FEdges[Index mod FCount] := Value;
end;

{ TsdTriangleFan2D }

procedure TsdTriangleFan2D.BuildTriangleFan(ABase: TsdTetra3D);
var
  Triangle: TsdTetra3D;
  Idx: integer;
begin
  // Reset count
  FCount := 0;
  Triangle := ABase;
  // scan anti-clockwise around center
  repeat
    Idx := Triangle.VertexIndex(FCenter);
    if Idx < 0 then
      raise Exception.Create(sTriangleVertexHookupError);
    // add at end of list.. first one to be inserted is ABase, then any others
    // in anti-clockwise direction around center
    AddTriangleAndEdge(Triangle, Idx);
    // next triangle
    Triangle := Triangle.Neighbours[Idx + 2];
  until (Triangle = ABase) or (Triangle = nil);
  if Triangle = nil then begin
    // in case we hit a border (no neighbours): we also scan clockwise from
    // base, and insert before rest of items. This will usually only happen
    // for meshes with holes or vertices at the borders of the mesh
    Idx := ABase.VertexIndex(FCenter);
    Triangle := ABase.Neighbours[Idx];
    while Triangle <> nil do begin
      Idx := Triangle.VertexIndex(FCenter);
      // insert at first position in list
      InsertTriangleAndEdge(0, Triangle, Idx);
      Triangle := Triangle.Neighbours[Idx];
    end;
  end;
end;

procedure TsdTriangleFan2D.Clear;
begin
  inherited;
  FCenter := nil;
end;

function TsdTriangleFan2D.GetVertices(Index: integer): TsdVertex3D;
var
  Idx: integer;
begin
  Idx := Index mod Count;
  Result := FTriangles[Idx].Vertices[FEdges[Idx] + 1];
end;

procedure TsdTriangleFan2D.MoveToVertexAt(AIndex: integer);
var
  Vertex: TsdVertex3D;
begin
  Vertex := Vertices[AIndex];
  FCenter := Vertex;
  BuildTriangleFan(FTriangles[AIndex]);
end;

procedure TsdTriangleFan2D.SetCenter(const Value: TsdVertex3D);
var
  Base: TsdTetra3D;
begin
  FCenter := Value;
  if not assigned(Value) then exit;
  // to do: build triangle list
  Base := Value.FTriangle;
  if not assigned(Base) then
    raise Exception.Create(sNoTriangleForVertex);
  BuildTriangleFan(Base);
end;

function TsdTriangleFan2D.TriangleIdxInDirection(const APoint: TsdPoint3D): integer;
var
  CP1, CP2: double;
  DeltaVP: TsdPoint3D;
begin
  Result := -1;
  if FCount = 0 then exit;
  Result := 0;
  DeltaVP := Delta2D(FCenter.FPoint, APoint);
  CP2 := CrossProduct2D(
    // Edge at bottom side
    Delta2D(FCenter.FPoint, FTriangles[0].Vertices[FEdges[0] + 1].FPoint),
    // From center to vertex point
    DeltaVP);
  repeat
    CP1 := CP2;
    CP2 := CrossProduct2D(
      // Edge at top side
      Delta2D(FCenter.FPoint, FTriangles[Result].Vertices[FEdges[Result] + 2].FPoint),
      // From center to vertex point
      DeltaVP);

    // For CP1 we use "greater than or equal" and for CP2 "smaller than", this way
    // at least one of them should return the favour, even within machine precision
    if (CP1 >= 0) and (CP2 < 0) then
      // point lies above or on bottom edge, and below top edge, so this is the
      // triangle we are looking for
      exit;
    inc(Result);
  until Result = FCount;
  // arriving here means we didn't find it.. this is possible for borders
  Result := -1;
end;

function TsdTriangleFan2D.TriangleInDirection(const APoint: TsdPoint3D): TsdTetra3D;
var
  Idx: integer;
begin
  Idx := TriangleIdxInDirection(APoint);
  if Idx < 0 then
    Result := nil
  else
    Result := FTriangles[Idx];
end;

function TsdTriangleFan2D.VertexIndex(AVertex: TsdVertex3D): integer;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if GetVertices(i) = AVertex then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

{ TsdTriangleChain2D }

function TsdTriangleChain2D.BuildChain(AVertex1, AVertex2: TsdVertex3D;
  var ASearchFan: TsdTriangleFan2D): boolean;
var
  Idx, Edge: integer;
  Fan: TsdTriangleFan2D;
  Triangle, Previous: TsdTetra3D;
  Vertex: TsdVertex3D;
  Delta12: TsdPoint3D;
begin
  Result := False;
  FVertex1 := AVertex1;
  FVertex2 := AVertex2;
  Clear;
  if not assigned(FVertex1) or not assigned(FVertex2) then exit;
  if FVertex1 = FVertex2 then begin
    Result := True;
    exit;
  end;

  // Searchfan to use
  if assigned(ASearchFan) then
    Fan := ASearchFan
  else
    Fan := TsdTriangleFan2D.Create;
  try

    Fan.Center := FVertex1;
    Idx := Fan.VertexIndex(FVertex2);
    if Idx >= 0 then begin
      // Goody goody, we can stop because we directly found *one* triangle connecting
      // the two vertices
      AddTriangleAndEdge(Fan.Triangles[Idx], Fan.OutwardEdges[Idx] + 1);
      Result := True;
      exit;
    end;

    // No direct one, so we locate the triangle in the direction of Vertex 2
    Idx := Fan.TriangleIdxInDirection(FVertex2.FPoint);

    // If there's none, we're doomed.. we cannot build the chain
    if Idx < 0 then exit;

    Delta12 := Delta2D(FVertex1.FPoint, FVertex2.FPoint);

    // First triangle and edge
    Triangle := Fan.Triangles[Idx];
    Edge := (Fan.OutwardEdges[Idx] + 1) mod 3;
    AddTriangleAndEdge(Triangle, Edge);

    // Now we repeat, and keep adding triangle/edge combi's until we found Vertex 2
    repeat
      // Move up one triangle, taking the neighbour on offending edge
      Previous := Triangle;
      Triangle := Previous.Neighbours[Edge];

      // No triangle neighbour? We're doomed..
      if not assigned(Triangle) then
        exit;

      // The edge on the new triangle that is offending
      Edge := Triangle.NeighbourIndex(Previous);

      // The vertex opposite of this one might be our end vertex
      Vertex := Triangle.Vertices[Edge + 2];
      if Vertex = FVertex2 then begin
        // Yep! We found the end of the chain
        AddTriangleAndEdge(Triangle, Edge + 2);
        Result := True;
        exit;
      end;

      // On which side of the line is this opposite vertex? This way we determine
      // the offending edge
      if CrossProduct2D(Delta12, Delta2D(FVertex1.FPoint, Vertex.FPoint)) < 0 then
      begin
        // On right side, so the next offending edge is two vertices away
        Edge := Edge + 2;
      end else begin
        // On left side, so next offending edge is one vertex away
        Edge := Edge + 1;
      end;

      // Now we add the triangle, and the edge that is offending
      AddTriangleAndEdge(Triangle, Edge);

    until False;

  finally
    // Free searchfan if temporary
    if Fan <> ASearchFan then Fan.Free;
  end;
end;

{ TsdTriMesh2D }

function TsdTriMesh2D.AbsoluteArea: double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Triangles.Count - 1 do
    Result := Result + abs(Triangles[i].Area);
end;

function TsdTriMesh2D.BoundingBox(var AMin, AMax: TsdPoint3D): boolean;
var
  i: integer;
  P: PsdPoint2D;
begin
  if FVertices.Count > 0 then begin
    AMin := FVertices[0].Point^;
    AMax := FVertices[0].Point^;
    for i := 1 to FVertices.Count - 1 do begin
      P := FVertices[i].Point;
      if P.X < AMin.X then AMin.X := P.X;
      if P.X > AMax.X then AMax.X := P.X;
      if P.Y < AMin.Y then AMin.Y := P.Y;
      if P.Y > AMax.Y then AMax.Y := P.Y;
    end;
    Result := True;
  end else begin
    AMin := cZero2D;
    AMax := cZero2D;
    Result := False;
  end;
end;

procedure TsdTriMesh2D.Clear;
begin
  FVertices.Clear;
  FTriangles.Clear;
  FSegments.Clear;
  InitializeInfo;
end;

procedure TsdTriMesh2D.ConvexHull;
begin
  with TsdConvexHull.Create do
    try
      MakeConvexHull(Self);
    finally
      Free;
    end;
end;

constructor TsdTriMesh2D.Create;
begin
  inherited;
  FVertices := TsdVertex3DList.Create(True);
  FTriangles := TsdTetra3DList.Create(True);
  FSegments := TsdSegment3DList.Create(True);
  SetPrecision(cDefaultTriangulationPrecision);
end;

destructor TsdTriMesh2D.Destroy;
begin
  FreeAndNil(FVertices);
  FreeAndNil(FTriangles);
  FreeAndNil(FSegments);
  inherited;
end;

class function TsdTriMesh2D.GetSegmentClass: TsdSegment3DClass;
begin
  Result := TsdSegment3D;
end;

class function TsdTriMesh2D.GetTriangleClass: TsdTetra3DClass;
begin
  Result := TsdTetra3D;
end;

class function TsdTriMesh2D.GetVertexClass: TsdVertex3DClass;
begin
  Result := TsdVertex3D;
end;

procedure TsdTriMesh2D.InitializeInfo;
begin
  FSearchSteps := 0;
end;

function TsdTriMesh2D.LocateClosestVertex(const APoint: TsdPoint3D;
  AFan: TsdTriangleFan2D): TsdVertex3D;
var
  i, BestIndex: integer;
  Fan: TsdTriangleFan2D;
  IsClosest: boolean;
  CenterDist, FanDist, BestDist: double;
begin
  Result := nil;
  BestDist := 0;
  BestIndex := 0;
  if FTriangles.Count = 0 then exit;

  // Initialize triangle fan
  if assigned(AFan) then
    Fan := AFan
  else
    Fan := TsdTriangleFan2D.Create;
  if Fan.Center = nil then
    Fan.Center := FTriangles[0].Vertices[0];

  // Do search.. we use the taxicab distance here, that's faster than squared
  // distance, and more stable numerically
  repeat
    IsClosest := True;
    inc(FSearchSteps);
    CenterDist := TaxicabDist2D(Fan.Center.Point^, APoint);
    for i := 0 to Fan.Count - 1 do begin
      FanDist := TaxicabDist2D(Fan.Vertices[i].Point^, APoint);
      if FanDist < CenterDist then
        IsClosest := False;
      if (i = 0) or (FanDist < BestDist) then begin
        BestDist := FanDist;
        BestIndex := i;
      end;
    end;
    if not IsClosest then
      Fan.MoveToVertexAt(BestIndex);
  until IsClosest;

  // Result
  Result := Fan.Center;

  // Finalize triangle fan
  if Fan <> AFan then
    Fan.Free;
end;

function TsdTriMesh2D.NewSegment: TsdSegment3D;
begin
  Result := GetSegmentClass.Create;
end;

function TsdTriMesh2D.NewTriangle: TsdTetra3D;
begin
  Result := GetTriangleClass.Create;
  Result.FMesh := Self;
end;

function TsdTriMesh2D.NewVertex: TsdVertex3D;
begin
  Result := GetVertexClass.Create;
end;

procedure TsdTriMesh2D.OptimizeForFEM(AVertices: TsdVertex3DList);
var
  i, Idx, IdxSeed, IdxLowest: integer;
  SL: TSortedList;
  Seed, Connected: TsdTetra3D;
  ConnectedIdx: array[0..2] of integer;
  V: TsdVertex3D;
  // local
  procedure MoveForward;
  var
    i: integer;
  begin
    // Move triangle Seed to Idx
    IdxSeed := FTriangles.IndexOf(Seed);
    FTriangles.Exchange(Idx, IdxSeed);
    inc(Idx);
    // Any vertices used and not yet in array are added
    for i := 0 to 2 do begin
      V := Seed.Vertices[i];
      if assigned(V) and (AVertices.IndexOf(V) < 0) then
        AVertices.Add(V);
    end;
  end;
begin
  AVertices.Clear;
  SL := TSortedList.Create(False);
  try
    // Sort the triangles by their left position
    SL.OnCompare := TriangleCompareLeft;
    // Add all triangles to the sortlist
    for i := 0 to FTriangles.Count - 1 do
      SL.Add(FTriangles[i]);
    // Current swap index
    Idx := 0;
    Seed := nil;
    while SL.Count > 0 {Idx < FTriangles.Count - 2} do begin
      // Seed triangle (the one we're working from)
      if not assigned(Seed) then begin
        Seed := TsdTetra3D(SL[0]);
        SL.Delete(0);
        MoveForward;
      end;

      // Find lowest connected triangle index in SL
      IdxLowest := FTriangles.Count;
      for i := 0 to 2 do
        ConnectedIdx[i] := SL.IndexOf(Seed.Neighbours[i]);
      for i := 0 to 2 do
        if (ConnectedIdx[i] >= 0) and (ConnectedIdx[i] < IdxLowest) then
          IdxLowest := ConnectedIdx[i];

      // Did we find a connected triangle still existing in our sl?
      if IdxLowest < FTriangles.Count then
        Connected := TsdTetra3D(SL[IdxLowest])
      else
        Connected := nil;

      // Do we have a connected triangle?
      if assigned(Connected) then begin
        // We have a connection.. do the exchange
        Seed := Connected;
        SL.Delete(IdxLowest);
        MoveForward;
      end else begin
        // No connection.. re-initialize seed
        Seed := nil;
      end;
    end;
  finally
    SL.Free;
  end;
end;

procedure TsdTriMesh2D.RemoveNonSegments;
var
  i: integer;
  S: TsdSegment3D;
begin
  for i := FSegments.Count - 1 downto 0 do begin
    S := FSegments[i];
    if not assigned(S.Vertex1) or not assigned(S.Vertex2) or (S.Vertex1 = S.Vertex2) then
      FSegments.Delete(i);
  end;
end;

procedure TsdTriMesh2D.SetPrecision(const Value: double);
begin
  if FPrecision <> Value then begin
    FPrecision := Value;
    FPrecisionSqr := sqr(FPrecision);
  end;
end;

function TsdTriMesh2D.SignedArea: double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Triangles.Count - 1 do
    Result := Result + Triangles[i].Area;
end;

function TsdTriMesh2D.TriangleCompareLeft(Item1, Item2: TObject; Info: pointer): integer;
// compare two triangles and decide which one is most on the left
var
  T1, T2: TsdTetra3D;
begin
  T1 := TsdTetra3D(Item1);
  T2 := TsdTetra3D(Item2);
  Result := CompareFloat(T1.Center.X, T2.Center.X);
end;

end.

{
  Description:

  2D triangular mesh for use by triangulation routines.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 02Feb2007

  Modifications:

  copyright (c) 2007 SimDesign B.V.
  
  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
  
}
unit sdTriMesh2D;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Contnrs, Math,
  // simdesign units
  sdPoints2D, sdSortedLists;

type

  TsdTriangle2D = class;
  TsdTriMesh2D = class;

  // Basic 2D vertex class, containing an FPoint (TsdPoint2D) field with X and
  // Y coordinate.
  TsdVertex2D = class(TPersistent)
  private
    FPoint: TsdPoint2D;
    function GetX: double;
    function GetY: double;
    procedure SetX(const Value: double);
    procedure SetY(const Value: double);
    function GetPoint: PsdPoint2D;
  protected
    function GetTriangle: TsdTriangle2D; virtual; abstract;
    procedure SetTriangle(const Value: TsdTriangle2D); virtual; abstract;
  public
    constructor Create; virtual;
    constructor CreateWithCoords(const AX, AY: double);
    procedure Assign(Source: TPersistent); override;
    property X: double read GetX write SetX;
    property Y: double read GetY write SetY;
    property Point: PsdPoint2D read GetPoint;
    // Reference back to the triangle this vertex belongs to. In fact, there can
    // be many triangles this vertex belongs to, but this is one of them (not
    // specified which one). If Triangle = nil, there is no reference yet.
    property Triangle: TsdTriangle2D read GetTriangle write SetTriangle;
  end;
  TsdVertex2DClass = class of TsdVertex2D;

  TsdVertex2DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdVertex2D;
    procedure SetItems(Index: integer; const Value: TsdVertex2D);
  public
    property Items[Index: integer]: TsdVertex2D read GetItems write SetItems; default;
  end;

  // 2D vertex class with additional Triangle pointer
  TsdTriVertex2D = class(TsdVertex2D)
  private
    FTriangle: TsdTriangle2D;
  protected
    function GetTriangle: TsdTriangle2D; override;
    procedure SetTriangle(const Value: TsdTriangle2D); override;
  public
    procedure Assign(Source: TPersistent); override;
  end;

  // A boundary connects two vertices. When a boundary is present,
  // the triangles bordering it cannot be swapped, thus constraining the triangulation
  TsdBoundary2D = class(TPersistent)
  private
    FValidMetrics: boolean;
    FVertex1: TsdVertex2D;
    FVertex2: TsdVertex2D;
    FCenter: TsdPoint2D;
    FNormal: TsdPoint2D;
    FSquaredEncroachRadius: double;
    procedure SetVertex1(const Value: TsdVertex2D);
    procedure SetVertex2(const Value: TsdVertex2D);
    function GetCenter: TsdPoint2D;
    function GetSquaredEncroachRadius: double;
    function GetNormal: TsdPoint2D;
  protected
    procedure CalculateMetrics; virtual;
  public
    constructor CreateWithVertices(AVertex1, AVertex2: TsdVertex2D);
    procedure Assign(Source: TPersistent); override;
    procedure Invalidate;
    // Replaces references in the segment to OldVertex by a reference to
    // NewVertex.
    procedure ReplaceVertex(OldVertex, NewVertex: TsdVertex2D);
    // Find the intersection point of us with ASegment, and create and return a vertex
    // if it does, or nil if no intersection.
    function IntersectWith(ABoundary: TsdBoundary2D): TsdVertex2D;
    // Is AVertex lying on this boundary? Use the passed precision as tolerance
    // (pass the square of required precision)
    function IsVertexOnBoundary(AVertex: TsdVertex2D; APrecisionSqr: double): boolean;
    // Does point P encroach on this segment?
    function PointEncroaches(const P: TsdPoint2D): boolean;
    // Reference to start vertex of this segment
    property Vertex1: TsdVertex2D read FVertex1 write SetVertex1;
    // Reference to end vertex of this segment
    property Vertex2: TsdVertex2D read FVertex2 write SetVertex2;
    // Center (midpoint) between the two vertices
    property Center: TsdPoint2D read GetCenter;
    // The normal of this segment. It points outwards from the graph, perpendicular
    // to the segment, and is unit length
    property Normal: TsdPoint2D read GetNormal;
    // The encroach radius is slightly bigger (10%) than the actual radius of
    // the segment's circle. This way, points encroach on it slightly quicker
    // esp near segment endpoints.
    property SquaredEncroachRadius: double read GetSquaredEncroachRadius;
  end;
  TsdBoundary2DClass = class of TsdBoundary2D;

  TsdBoundary2DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdBoundary2D;
  public
    property Items[Index: integer]: TsdBoundary2D read GetItems; default;
  end;

  // hit-test result for hit-testing triangles
  TsdHitTestTriangle = (
    httNone,   // Not on the triangle
    httBody,   // On the body of the triangle
    httVtx0,   // On or close to triangle's vertex 0
    httVtx1,   // On or close to triangle's vertex 1
    httVtx2,   // On or close to triangle's vertex 2
    httEdge0,  // On the body, and on edge 0
    httEdge1,  // On the body, and on edge 1
    httEdge2,  // On the body, and on edge 2
    httClose0, // Not on the body but close to edge 0
    httClose1, // Not on the body but close to edge 1
    httClose2  // Not on the body but close to edge 2
  );

  // Basic class for triangles that are present in a triangular 2D mesh
  // A Boundary Triangle contains references for each edge to a boundary, or nil
  // if there is no graph boundary for this edge.
  TsdTriangle2D = class(TPersistent)
  private
    FVertices: array[0..2] of TsdVertex2D;
    FNormals: array[0..2] of TsdPoint2D;
    FNeighbours: array[0..2] of TsdTriangle2D;
    FBoundaries: array[0..2] of TsdBoundary2D;
    FCenter: TsdPoint2D;
    FRegionIndex: integer;
    function GetVertices(Index: integer): TsdVertex2D;
    procedure SetVertices(Index: integer; const Value: TsdVertex2D);
    function GetNeighbours(Index: integer): TsdTriangle2D;
    procedure SetNeighbours(Index: integer; const Value: TsdTriangle2D);
    function GetBoundaries(Index: integer): TsdBoundary2D; virtual;
    procedure SetBoundaries(Index: integer; const Value: TsdBoundary2D); virtual;
    function GetCenter: TsdPoint2D;
    function GetCircleCenter: TsdPoint2D;
    function GetSquaredRadius: double;
    function GetOffCenter: TsdPoint2D;
    function GetQuality: double; virtual;
  protected
    FSquaredRadius: double;
    FCircleCenter: TsdPoint2D;
    FValidMetrics: boolean;
    FQuality: double;
    FMesh: TsdTriMesh2D; // pointer back to mesh
    // Calcuate metrics for this triangle, may be overridden in descendants to
    // calculate more metrics
    procedure CalculateMetrics; virtual;
    procedure InvalidateBoundarys;
  public
    constructor Create; virtual;
    procedure Invalidate;
    // Set the vertices a, b, c all at the same time
    procedure HookupVertices(VertexA, VertexB, VertexC: TsdVertex2D);
    // Set the neighbours a, b, c all at the same time
    procedure HookupNeighbours(TriangleA, TriangleB, TriangleC: TsdTriangle2D);
    // Replace the neighbour OldNeighbour (if we have it) by NewNeighbour
    procedure ReplaceNeighbour(OldNeighbour, NewNeighbour: TsdTriangle2D);
    // Returns index 0, 1, or 2 if ATriangle is one of it's neighbours, or -1
    // if ATriangle isn't
    function NeighbourIndex(ATriangle: TsdTriangle2D): integer;
    // Returns index 0, 1, or 2 if AVertex is one of the vertices of ATriangle,
    // or -1 if not
    function VertexIndex(AVertex: TsdVertex2D): integer;
    // Returns index 0, 1, or 2 if ABoundary is one of the boundaries of ATriangle,
    // or -1 if not
    function BoundaryIndex(ABoundary: TsdBoundary2D): integer;
    // Hit-test the triangle with APoint, and return one of the hittest
    // values.
    function HitTest(const APoint: TsdPoint2D): TsdHitTestTriangle;
    // Returns the edge index of the edge that crosses the line when going from
    // the center of this triangle to point APoint (and beyond).
    function EdgeFromCenterTowardsPoint(const APoint: TsdPoint2D): integer;
    // Returns the signed area of this triangle (result is positive when triangle
    // is defined counter-clockwise, and negative if clockwise).
    function Area: double;
    // Returns the cosine of the angle at vertex Index
    function AngleCosine(Index: integer): double;
    // Returns the cosine of the smallest angle in the triangle
    function SmallestAngleCosine: double;
    // Returns the square of the length of the longest edge
    function SquaredLongestEdgeLength: double;
    // References to the vertices of which this triangle consists. The vertices
    // are numbered 0, 1, 2 (also referred to as a, b, c).
    // The triangle must always be described in counterclockwise direction.
    property Vertices[Index: integer]: TsdVertex2D read GetVertices write SetVertices;
    // References to the neighbouring triangles, or nil if there is none at this location
    // Neighbour 0 corresponds to the neighbour along edge ab, neighbour 1 to edge bc
    // and neighbour 2 to edge ca.
    property Neighbours[Index: integer]: TsdTriangle2D read GetNeighbours write SetNeighbours;
    // Returns reference to the boundary at edge Index.
    property Boundaries[Index: integer]: TsdBoundary2D read GetBoundaries write SetBoundaries;
    // Returns center of triangle (3 points averaged)
    property Center: TsdPoint2D read GetCenter;
    // Index of the region this triangle belongs to, or -1 if none
    property RegionIndex: integer read FRegionIndex write FRegionIndex;
    // Test whether AVertex lies within the Delaunay circle of this triangle
    function VertexInCircle(AVertex: TsdVertex2D): boolean;
    // Check if this triangle is in fact abiding the delaunay criterium (no neighbouring
    // triangle's opposite points inside the circle going through its 3 vertices)
    function IsDelaunay: boolean;
    // Returns the Delaunay circle center of this triangle
    property CircleCenter: TsdPoint2D read GetCircleCenter;
    // Returns the squared radius of the Delaunay circle of this triangle
    property SquaredRadius: double read GetSquaredRadius;
    // Does this triangle have an encroached boundary?
    function HasEncroachedBoundary: boolean;
    // Return the boundary that is encroached due to APoint, or nil if none
    function EncroachedBoundaryFromPoint(const APoint: TsdPoint2D): TsdBoundary2D;
    // Calculate and return the OffCenter point for this triangle
    property OffCenter: TsdPoint2D read GetOffCenter;
    // Quality is defined as the smallest angle cosine. Larger values mean worse quality
    property Quality: double read GetQuality;
  end;
  TsdTriangle2DClass = class of TsdTriangle2D;

  // List of triangles.
  TsdTriangle2DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdTriangle2D;
  public
    property Items[Index: integer]: TsdTriangle2D read GetItems; default;
  end;

  // The object represents general triangle-edge group. Capacity
  // will be increased when needed, but will never be reduced, to avoid memory
  // fragmentation.
  TsdTriangleGroup2D = class(TPersistent)
  private
    FTriangles: array of TsdTriangle2D;
    FEdges: array of integer;
    FCount: integer;
    FCapacity: integer;
    function GetTriangles(Index: integer): TsdTriangle2D;
  protected
    function GetEdges(Index: integer): integer;
    procedure SetEdges(Index: integer; const Value: integer);
  public
    procedure Clear; virtual;
    // Add a triangle reference and edge index to the end of the list
    procedure AddTriangleAndEdge(ATriangle: TsdTriangle2D; AEdge: integer);
    // Insert a triangle reference and edge index in the list at AIndex
    procedure InsertTriangleAndEdge(AIndex: integer; ATriangle: TsdTriangle2D; AEdge: integer);
    // Delete triangle and edge at AIndex
    procedure Delete(AIndex: integer);
    // Exchange triangle/edge pairs at Index1 and Index2
    procedure Exchange(Index1, Index2: integer);
    // List of triangles in this triangle group
    property Triangles[Index: integer]: TsdTriangle2D read GetTriangles;
    // Number of triangles in the triangle group
    property Count: integer read FCount;
  end;

  // Represents a fan of triangles around the Vertex. This class is used in linear
  // searches.
  TsdTriangleFan2D = class(TsdTriangleGroup2D)
  private
    FCenter: TsdVertex2D;
    procedure SetCenter(const Value: TsdVertex2D);
    function GetVertices(Index: integer): TsdVertex2D;
  protected
    procedure BuildTriangleFan(ABase: TsdTriangle2D); virtual;
  public
    procedure Clear; override;
    // Move the triangle fan to another center vertex that lies on the other end
    // of the outgoing edge of triangle at AIndex
    procedure MoveToVertexAt(AIndex: integer);
    // Return the index of the triangle that might cover the point APoint
    function TriangleIdxInDirection(const APoint: TsdPoint2D): integer;
    // Return the triangle that might cover the vertex AVertex
    function TriangleInDirection(const APoint: TsdPoint2D): TsdTriangle2D;
    // Runs through the Vertices array, and if a vertex matches, it's index is
    // returned. If none matches, -1 is returned.
    function VertexIndex(AVertex: TsdVertex2D): integer;
    // The center vertex of the triangle fan. Set Center to a vertex in the mesh
    // and the triangle fan around it will be rebuilt. Center must have a pointer
    // back to a triangle (it cannot be nil)
    property Center: TsdVertex2D read FCenter write SetCenter;
    // List of outward pointing edge indices in this triangle fan
    property OutwardEdges[Index: integer]: integer read GetEdges;
    // Vertices at the other end of the outward pointing edge at Index in the
    // triangle fan
    property Vertices[Index: integer]: TsdVertex2D read GetVertices;
  end;

  // A triangle chain between vertex1 and vertex2
  TsdTriangleChain2D = class(TsdTriangleGroup2D)
  private
    FVertex1, FVertex2: TsdVertex2D;
  public
    // Build a triangle chain from Vertex1 to Vertex2. For searching, use ASearchFan
    // if assigned, or use temporary search fan if nil. If a chain was found,
    // the function result is true
    function BuildChain(AVertex1, AVertex2: TsdVertex2D;
      var ASearchFan: TsdTriangleFan2D): boolean;
    // List of edge indices in this triangle chain.. the edge index points to the
    // edge crossing the line from Vertex1 to Vertex2, except for the last one,
    // where it indicates the index of Vertex2.
    property Edges[Index: integer]: integer read GetEdges write SetEdges;
  end;

  // A constrained mesh consisting of triangles and vertices, where each triangle contains
  // reference to 3 vertices. The mesh is constrained by boundaries (TsdBoundary2D).
  TsdTriMesh2D = class(TPersistent)
  private
    FPrecision: double;
    FVertices: TsdVertex2DList;
    FTriangles: TsdTriangle2DList;
    FBoundaries: TsdBoundary2DList;
    FSearchSteps: integer;
    // comparison function to sort triagles by Center.X, smallest values first
    function TriangleCompareLeft(Item1, Item2: TObject; Info: pointer): integer;
  protected
    FPrecisionSqr: double;
    // for delauney mesh
    FSwapCount: integer;
    FCircleCalcCount: integer;
    FDelaunayPrecision: double;
    FSquaredBeta: double;

    procedure SetPrecision(const Value: double); virtual;
    // Create a new vertex of correct class
    function NewVertex: TsdVertex2D;
    class function GetVertexClass: TsdVertex2DClass; virtual;
    // Create a new triangle of correct class
    function NewTriangle: TsdTriangle2D;
    class function GetTriangleClass: TsdTriangle2DClass; virtual;
    // Create a new boundary of correct class
    function NewBoundary: TsdBoundary2D;
    class function GetBoundaryClass: TsdBoundary2DClass; virtual;
    // Initialize info properties
    procedure InitializeInfo; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // Clear the mesh
    procedure Clear; virtual;
    // Create a convex hull around all the vertices in the mesh
    procedure ConvexHull;
    // Optimize the mesh for usage in a finite element method. The triangle list
    // is sorted such that the triangles form a long chain going up and down from
    // left to right, and all vertices used are placed in the AVertices list, which
    // is also sorted by usage in the triangles. Thus, vertices connected to each
    // other usually are also have an index relatively close in the Vertices list,
    // which accomplishes that the finite element matrix is more banded than with
    // a random distribution (and gauss elimination works faster). The AVertices
    // array must be initialized, it will be cleared and then filled with all
    // vertices used by the triangles.
    procedure OptimizeForFEM(AVertices: TsdVertex2DList);
    // Remove all boundaries that are non-functional (e.g. vertex pointers are nil,
    // or vertex1 and vertex2 point to the same vertex)
    procedure RemoveNonBoundarys;
    // Get the min and max location of the mesh. Returns false if there are no
    // vertices
    function BoundingBox(var AMin, AMax: TsdPoint2D): boolean;
    // Returns the sum of all triangle's absolute area
    function AbsoluteArea: double;
    // Returns the sum of all triangle's signed area
    function SignedArea: double;
    // Locate the vertex that is closest to APoint. The function returns the closest
    // vertex from the vertex list to APoint. If there are no vertices in the list,
    // nil is returned. The basic algorithm is a linear search but this can
    // be overridden in descendants (to implement e.g. a quadtree approach).
    // A TsdTriangleFan2D object can be passed in Fan to speed up searching.
    function LocateClosestVertex(const APoint: TsdPoint2D;
      AFan: TsdTriangleFan2D = nil): TsdVertex2D; virtual;
    // List of vertices used in this mesh
    property Vertices: TsdVertex2DList read FVertices;
    // List of triangles used in this mesh
    property Triangles: TsdTriangle2DList read FTriangles;
    // List of boundaries used in this mesh
    property Boundaries: TsdBoundary2DList read FBoundaries;
    // Precision used when generating mesh. If a point lies within precision
    // from a triangle edge, it is considered to be on it, the edge will be
    // split instead of the body.
    // When a vertex lays within Precision of another vertex, no new triangle
    // will be created, thus the vertex is skipped (not triangulated).
    property Precision: double read FPrecision write SetPrecision;
    // Number of search steps performed in linear search.
    property SearchSteps: integer read FSearchSteps;
  end;
  TsdTriMesh2DClass = class of TsdTriMesh2D;

// Create the normal of a line from A to B, this is the vector perpendicular to
// it (rotated 90 degrees clockwise), of unit length
function sdNormalFrom2Points(const A, B: TsdPoint2D): TsdPoint2D;

// Return the distance of P above the line through Base with Normal. If Dist is
// negative, P lies below the line.
function sdAboveBelowDist2D(const Base, Normal, P: TsdPoint2D): double;

function sdBetweenPointsTest2D(const A, B, Point: TsdPoint2D): integer;

const
  // Default precision when triangulating
  cDefaultTriangulationPrecision = 1E-3;

resourcestring

  sInvalidTriangleForSegment = 'Invalid triangle for segment';
  sTriangleVertexHookupError = 'triangle-vertex hookup error';
  sNoTriangleForVertex       = 'No triangle for vertex';

implementation

uses
  sdConvexHull2D;

const
  cOneThird: double = 1/3;

function sdNormalFrom2Points(const A, B: TsdPoint2D): TsdPoint2D;
// Create the normal of a line from A to B, this is the vector perpendicular to
// it (rotated 90 degrees clockwise), of unit length
var
  D: TsdPoint2D;
begin
  D := Delta2D(A, B);
  // Turn 90 deg clockwise
  Result.X :=  D.Y;
  Result.Y := -D.X;
  NormalizeVector2D(Result);
end;

// Return the distance of P above the line through Base with Normal. If Dist is
// negative, P lies below the line.
function sdAboveBelowDist2D(const Base, Normal, P: TsdPoint2D): double;
// Return the distance of P above the line through Base with Normal. If Dist is
// negative, P lies below the line.
begin
  Result := DotProduct2D(Normal, Delta2D(Base, P));
end;

function sdBetweenPointsTest2D(const A, B, Point: TsdPoint2D): integer;
var
  AB, D: TsdPoint2D;
begin
  AB := Delta2D(A, B);
  D := Delta2D(A, Point);
  if DotProduct2D(D, AB) < 0 then
  begin
    Result := -1;
    exit;
  end;
  D := Delta2D(B, Point);
  if DotProduct2D(D, AB) > 0 then
  begin
    Result := 1;
    exit;
  end;
  Result := 0;
end;

{ TsdVertex2D }

procedure TsdVertex2D.Assign(Source: TPersistent);
begin
  if Source is TsdVertex2D then
  begin
    FPoint := TsdVertex2D(Source).FPoint;
  end else
    inherited;
end;

constructor TsdVertex2D.Create;
begin
  inherited;
end;

constructor TsdVertex2D.CreateWithCoords(const AX, AY: double);
begin
  Create;
  FPoint.X := AX;
  FPoint.Y := AY;
end;

function TsdVertex2D.GetPoint: PsdPoint2D;
begin
  Result := @FPoint;
end;

function TsdVertex2D.GetX: double;
begin
  Result := FPoint.X;
end;

function TsdVertex2D.GetY: double;
begin
  Result := FPoint.Y;
end;

procedure TsdVertex2D.SetX(const Value: double);
begin
  FPoint.X := Value;
end;

procedure TsdVertex2D.SetY(const Value: double);
begin
  FPoint.Y := Value;
end;

{ TsdTriVertex2D }

procedure TsdTriVertex2D.Assign(Source: TPersistent);
begin
  if Source is TsdTriVertex2D then
    FTriangle := TsdTriVertex2D(Source).FTriangle;
  inherited;
end;

function TsdTriVertex2D.GetTriangle: TsdTriangle2D;
begin
  Result := FTriangle;
end;

procedure TsdTriVertex2D.SetTriangle(const Value: TsdTriangle2D);
begin
  FTriangle := Value;
end;

{ TsdVertex2DList }

function TsdVertex2DList.GetItems(Index: integer): TsdVertex2D;
begin
  Result := Get(Index);
end;

procedure TsdVertex2DList.SetItems(Index: integer;
  const Value: TsdVertex2D);
begin
  Put(Index, Value);
end;

{ TsdBoundary2D }

procedure TsdBoundary2D.Assign(Source: TPersistent);
begin
  if Source is TsdBoundary2D then
  begin
    FVertex1 := TsdBoundary2D(Source).FVertex1;
    FVertex2 := TsdBoundary2D(Source).FVertex2;
  end else
    inherited;
end;

procedure TsdBoundary2D.CalculateMetrics;
var
  R: double;
begin
  if not assigned(FVertex1) or not assigned(FVertex2) then
  begin
    FCenter := cZero2D;
    FNormal := cZero2D;
    FSquaredEncroachRadius := 0;
  end else
  begin
    FCenter := MidPoint2D(FVertex1.FPoint, FVertex2.FPoint);
    R := Dist2D(FVertex1.FPoint, FCenter);
    // Take an encroach radius that is 10% bigger than the actual radius
    FSquaredEncroachRadius := sqr(R * 1.1);
    // Normal
    FNormal := sdNormalFrom2Points(FVertex1.FPoint, FVertex2.FPoint);
  end;
  FValidMetrics := True;
end;

constructor TsdBoundary2D.CreateWithVertices(AVertex1, AVertex2: TsdVertex2D);
begin
  Create;
  FVertex1 := AVertex1;
  FVertex2 := AVertex2;
end;

function TsdBoundary2D.GetCenter: TsdPoint2D;
begin
  if not FValidMetrics then
    CalculateMetrics;
  Result := FCenter;
end;

function TsdBoundary2D.GetNormal: TsdPoint2D;
begin
  if not FValidMetrics then
    CalculateMetrics;
  Result := FNormal;
end;

function TsdBoundary2D.GetSquaredEncroachRadius: double;
begin
  if not FValidMetrics then
    CalculateMetrics;
  Result := FSquaredEncroachRadius;
end;

function TsdBoundary2D.IntersectWith(ABoundary: TsdBoundary2D): TsdVertex2D;
var
  R: TsdPoint2D;
  PosP, PosQ: double;
begin
  Result := nil;
  if IntersectLines2D(
    FVertex1.FPoint, FVertex2.FPoint,
    ABoundary.Vertex1.FPoint, ABoundary.Vertex2.FPoint,
    R, PosP, PosQ) then
  begin
    if (PosP > 0) and (PosP < 1) and (PosQ > 0) and (PosQ < 1) then
    begin
      // OK we found an intersection, lying within both segments
      Result := TsdTriVertex2D.CreateWithCoords(R.X, R.Y);
    end;
  end;
end;

procedure TsdBoundary2D.Invalidate;
begin
  FValidMetrics := False;
end;

function TsdBoundary2D.IsVertexOnBoundary(AVertex: TsdVertex2D; APrecisionSqr: double): boolean;
begin
  Result := PointToLineDist2DSqr(AVertex.FPoint,
    FVertex1.FPoint, FVertex2.FPoint) <= APrecisionSqr;
end;

function TsdBoundary2D.PointEncroaches(const P: TsdPoint2D): boolean;
var
  C: TsdPoint2D;
begin
  C := GetCenter;
  Result := SquaredDist2D(C, P) < FSquaredEncroachRadius;
end;

procedure TsdBoundary2D.ReplaceVertex(OldVertex, NewVertex: TsdVertex2D);
begin
  if FVertex1 = OldVertex then
    SetVertex1(NewVertex);
  if FVertex2 = OldVertex then
    SetVertex2(NewVertex);
end;

procedure TsdBoundary2D.SetVertex1(const Value: TsdVertex2D);
begin
  FVertex1 := Value;
  FValidMetrics := False;
end;

procedure TsdBoundary2D.SetVertex2(const Value: TsdVertex2D);
begin
  FVertex2 := Value;
  FValidMetrics := False;
end;

{ TsdSBoundary2DList }

function TsdBoundary2DList.GetItems(Index: integer): TsdBoundary2D;
begin
  Result := Get(Index);
end;

{ TsdTriangle2D }

function TsdTriangle2D.AngleCosine(Index: integer): double;
var
  D1, D2: TsdPoint2D;
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

function TsdTriangle2D.Area: double;
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

procedure TsdTriangle2D.CalculateMetrics;
var
  Pa, Pb, Pc: PsdPoint2D;
  Den, A1, A2, R: double;
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
    // Calculate circle center and squared radius
    Den := ((Pb.Y - Pc.Y) * (Pb.X - Pa.X) - (Pb.Y - Pa.Y) * (Pb.X - Pc.X)) * 2;
    A1  :=  (Pa.X + Pb.X) * (Pb.X - Pa.X) + (Pb.Y - Pa.Y) * (Pa.Y + Pb.Y);
    A2  :=  (Pb.X + Pc.X) * (Pb.X - Pc.X) + (Pb.Y - Pc.Y) * (Pb.Y + Pc.Y);

    // Make sure we don't divide by zero
    if abs(Den) > 1E-20 then
    begin
      // Calculated circle center of circle through points a, b, c
      FCircleCenter.X := (A1 * (Pb.Y - Pc.Y) - A2 * (Pb.Y - Pa.Y)) / Den;
      FCircleCenter.Y := (A2 * (Pb.X - Pa.X) - A1 * (Pb.X - Pc.X)) / Den;
      // Squared radius of this circle
      // We use a radius that is a fraction smaller than the real radius (by
      // DelaunayPrecision) to allow miniscule infringement of the delaunay property.
      // This will avoid indecisiveness and endless swapping
      R := Dist2D(FCircleCenter, Pa^) - FMesh.FDelaunayPrecision;
      if R < 0 then
        R := 0;
      FSquaredRadius := sqr(R);
    end else
    begin
      FCircleCenter := Center;
      FSquaredRadius := 0;
    end;
    inc(FMesh.FCircleCalcCount);
    FQuality := SmallestAngleCosine;
  end;
  // Set flag
  FValidMetrics := True;
end;

constructor TsdTriangle2D.Create;
begin
  inherited Create;
  FRegionIndex := -1;
end;

function TsdTriangle2D.EdgeFromCenterTowardsPoint(const APoint: TsdPoint2D): integer;
var
  i: integer;
  C, Delta: TsdPoint2D;
  CP1, CP2: double;
begin
  Result := -1;
  if not (assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2])) then
    exit;
  C := GetCenter;
  Delta := Delta2D(C, APoint);
  CP2 := CrossProduct2D(Delta2D(C, Vertices[0].FPoint), Delta);
  for i := 0 to 2 do
  begin
    CP1 := CP2;
    CP2 := CrossProduct2D(Delta2D(C, Vertices[i + 1].FPoint), Delta);
    if (CP1 >= 0) and (CP2 < 0) then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function TsdTriangle2D.GetCenter: TsdPoint2D;
begin
  if not FValidMetrics then
    CalculateMetrics;
  Result := FCenter;
end;

function TsdTriangle2D.GetNeighbours(Index: integer): TsdTriangle2D;
begin
  Result := FNeighbours[Index mod 3];
end;

function TsdTriangle2D.GetBoundaries(Index: integer): TsdBoundary2D;
begin
  Result := FBoundaries[Index mod 3];
end;

function TsdTriangle2D.GetVertices(Index: integer): TsdVertex2D;
begin
  Result := FVertices[Index mod 3];
end;

function TsdTriangle2D.HitTest(const APoint: TsdPoint2D): TsdHitTestTriangle;
var
  i, Res: integer;
  P: array[0..2] of PsdPoint2D;
  Tol, TolSqr, TolOut, Dist: double;
begin
  Result := httNone;

  if not (assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2])) then
    exit;

  if not FValidMetrics then
    CalculateMetrics;
  Tol := FMesh.FPrecision;
  TolSqr := FMesh.FPrecisionSqr;
  TolOut := Tol * 1E-3;

  // Sides check to determine insideness
  P[0] := FVertices[0].Point;
  P[1] := FVertices[1].Point;
  P[2] := FVertices[2].Point;

  // Check first side
  for i := 0 to 2 do
  begin
    Dist := sdAboveBelowDist2D(P[i]^, FNormals[i], APoint);
    // More than TolOut away.. this point is outside this triangle
    if Dist > TolOut then
      exit;

    if abs(Dist) <= Tol then
    begin
      // Possibly on this line: check endpoints
      if SquaredDist2D(P[i]^, APoint) < TolSqr then
      begin
        // Yes on first vertex
        case i of
        0: Result := httVtx0;
        1: Result := httVtx1;
        2: Result := httVtx2;
        end;
        exit;
      end;
      if SquaredDist2D(P[(i + 1) mod 3]^, APoint) < TolSqr then
      begin
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
      if Res = 0 then
      begin
        // Indeed, between the vertices
        if Dist <= 0 then
        begin
          case i of
          0: Result := httEdge0;
          1: Result := httEdge1;
          2: Result := httEdge2;
          end;
        end else
        begin
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

procedure TsdTriangle2D.HookupNeighbours(TriangleA, TriangleB, TriangleC: TsdTriangle2D);
begin
  FNeighbours[0] := TriangleA;
  FNeighbours[1] := TriangleB;
  FNeighbours[2] := TriangleC;
end;

procedure TsdTriangle2D.HookupVertices(VertexA, VertexB, VertexC: TsdVertex2D);
begin
  SetVertices(0, VertexA);
  SetVertices(1, VertexB);
  SetVertices(2, VertexC);
end;

procedure TsdTriangle2D.Invalidate;
begin
  FValidMetrics := False;
end;

procedure TsdTriangle2D.InvalidateBoundarys;
var
  i: integer;
  S: TsdBoundary2D;
begin
  for i := 0 to 2 do
  begin
    S := Boundaries[i];
    if assigned(S) then
      S.Invalidate;
  end;
end;

function TsdTriangle2D.NeighbourIndex(ATriangle: TsdTriangle2D): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to 2 do
    if FNeighbours[i] = ATriangle then
    begin
      Result := i;
      exit;
    end;
end;

procedure TsdTriangle2D.ReplaceNeighbour(OldNeighbour, NewNeighbour: TsdTriangle2D);
var
  Idx: integer;
begin
  Idx := NeighbourIndex(OldNeighbour);
  if Idx >= 0 then
    FNeighbours[Idx] := NewNeighbour;
end;

function TsdTriangle2D.BoundaryIndex(ABoundary: TsdBoundary2D): integer;
var
  i: integer;
begin
  for i := 0 to 2 do
    if Boundaries[i] = ABoundary then
    begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

procedure TsdTriangle2D.SetNeighbours(Index: integer; const Value: TsdTriangle2D);
begin
  FNeighbours[Index mod 3] := Value;
end;

procedure TsdTriangle2D.SetBoundaries(Index: integer; const Value: TsdBoundary2D);
var
  Idx: integer;
begin
  Idx := Index mod 3;
  if FBoundaries[Idx] <> Value then
  begin
    FBoundaries[Idx] := Value;
    // make sure to recalculate, because e.g. delaunay props change
    Invalidate;
  end;
end;

procedure TsdTriangle2D.SetVertices(Index: integer; const Value: TsdVertex2D);
var
  Idx: integer;
begin
  Idx := Index mod 3;
  if FVertices[Idx] <> Value then
  begin
    Value.Triangle := Self;
    FVertices[Idx] := Value;
    FValidMetrics := False;
    InvalidateBoundarys;
  end;
end;

function TsdTriangle2D.SmallestAngleCosine: double;
var
  i: integer;
  D: array[0..2] of TsdPoint2D;
  ACos: double;
begin
  Result := 0;
  if not (assigned(FVertices[0]) and assigned(FVertices[1]) and assigned(FVertices[2])) then
    exit;
  for i := 0 to 2 do
  begin
    D[i] := Delta2D(Vertices[i].FPoint, Vertices[i + 1].FPoint);
    NormalizeVector2D(D[i]);
  end;
  for i := 0 to 2 do
  begin
    ACos := abs(DotProduct2D(D[i], D[(i + 1) mod 3]));
    if ACos > Result then
      Result := ACos;
  end;
  if Result > 1 then
    Result := 1;
end;

function TsdTriangle2D.SquaredLongestEdgeLength: double;
var
  i: integer;
  L: double;
begin
  Result := 0;
  for i := 0 to 2 do
  begin
    L := SquaredDist2D(Vertices[i].FPoint, Vertices[i + 1].FPoint);
    if L > Result then
      Result := L;
  end;
end;

function TsdTriangle2D.VertexIndex(AVertex: TsdVertex2D): integer;
var
  i: integer;
begin
  for i := 0 to 2 do
    if FVertices[i] = AVertex then
    begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

{ delauney triangle methods }

function TsdTriangle2D.GetCircleCenter: TsdPoint2D;
begin
  if not FValidMetrics then
    CalculateMetrics;
  Result := FCircleCenter;
end;

function TsdTriangle2D.GetSquaredRadius: double;
begin
  if not FValidMetrics then
    CalculateMetrics;
  Result := FSquaredRadius;
end;

function TsdTriangle2D.IsDelaunay: boolean;
var
  i, j: integer;
  N: TsdTriangle2D;
  V: TsdVertex2D;
  C: TsdPoint2D;
  RSqr: double;
begin
  Result := False;
  // The center of the circle
  C := GetCircleCenter;
  // The square of the radius
  RSqr := FSquaredRadius;

  // Loop through neighbours
  for i := 0 to 2 do
  begin
    N := Neighbours[i];
    // No neighbour, or a segment on this edge: skip
    if not assigned(N) or assigned(Boundaries[i]) then
      continue;
    for j := 0 to 2 do
    begin
      V := N.Vertices[j];
      // Not one of the shared vertices?
      if (V = Vertices[i]) or (V = Vertices[i + 1]) then
        continue;
      // Determine the distance, and compare
      if SquaredDist2D(V.Point^, C) < RSqr then
        // Indeed, one of the opposite points is in, so we return "false"
        exit;
    end;
  end;
  // Ending up here means this triangle abides Delaunay
  Result := True;
end;

function TsdTriangle2D.VertexInCircle(AVertex: TsdVertex2D): boolean;
var
  C: TsdPoint2D;
begin
  C := GetCircleCenter;
  Result := SquaredDist2D(C, AVertex.Point^) <= FSquaredRadius;
end;

{ quality triangle methods }

function TsdTriangle2D.EncroachedBoundaryFromPoint(const APoint: TsdPoint2D): TsdBoundary2D;
var
  i: integer;
  S: TsdBoundary2D;
  SqrR: double;
begin
  Result := nil;
  SqrR := 0;
  for i := 0 to 2 do
  begin
    S := Boundaries[i];
    if assigned(S) then
    begin
      if S.PointEncroaches(APoint) then
      begin
        if S.SquaredEncroachRadius > SqrR then
        begin
          Result := S;
          SqrR := S.SquaredEncroachRadius;
        end;
      end;
    end;
  end;
end;

function TsdTriangle2D.GetOffCenter: TsdPoint2D;
var
  SquaredBeta, L0Sqr, L1Sqr, L2Sqr, LMinSqr, HSqr, a: double;
  EMin: integer;
  P, Q, Delta, B: TsdPoint2D;
begin
  if not FValidMetrics then
    CalculateMetrics;
  // Squared edge lengths
  L0Sqr := SquaredDist2D(Vertices[0].Point^, Vertices[1].Point^);
  L1Sqr := SquaredDist2D(Vertices[1].Point^, Vertices[2].Point^);
  L2Sqr := SquaredDist2D(Vertices[2].Point^, Vertices[0].Point^);
  // Minimum squared edge length
  LMinSqr := L0Sqr;
  EMin := 0;
  if L1Sqr < LMinSqr then
  begin
    LMinSqr := L1Sqr;
    EMin := 1;
  end;
  if L2Sqr < LMinSqr then
  begin
    LMinSqr := L2Sqr;
    EMin := 2;
  end;
  // Squared beta factor
  SquaredBeta := FSquaredRadius / LMinSqr;
  // Offcenter: when the beta factor is higher than the required one,
  // we calculate the position of the offcenter such that the quality is exactly ok
  if SquaredBeta > FMesh.FSquaredBeta then
  begin
    // Point B between PQ
    P := Vertices[EMin].Point^;
    Q := Vertices[EMin + 1].Point^;
    HSqr := SquaredDist2D(P, Q) * 0.25; // H = half of the distance between PQ
    B := MidPoint2D(P, Q);
    a := sqrt(FSquaredRadius - HSqr);
    Delta := Delta2D(B, FCircleCenter);
    NormalizeVector2D(Delta);
    // Off-center lies on point from B along carrier vector Delta, over distance a
    Result.X := B.X + a * Delta.X;
    Result.Y := B.Y + a * Delta.Y;
  end else
    // Otherwise, we use the circle center for the off-center
    Result := FCircleCenter;
end;

function TsdTriangle2D.GetQuality: double;
begin
  if not FValidMetrics then
    CalculateMetrics;
  Result := FQuality;
end;

function TsdTriangle2D.HasEncroachedBoundary: boolean;
var
  i: integer;
  S: TsdBoundary2D;
begin
  Result := False;
  for i := 0 to 2 do
  begin
    S := Boundaries[i];
    if assigned(S) then
    begin
      Result := S.PointEncroaches(Vertices[i + 2].Point^);
      if Result then
        exit;
    end;
  end;
end;

{ TsdTriangle2DList }

function TsdTriangle2DList.GetItems(Index: integer): TsdTriangle2D;
begin
  Result := Get(Index);
end;

{ TsdTriangleGroup2D }

procedure TsdTriangleGroup2D.AddTriangleAndEdge(ATriangle: TsdTriangle2D; AEdge: integer);
begin
  // adjust capacity
  if FCount >= FCapacity then
  begin
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
  if (AIndex < 0) or (AIndex >= FCount) then
    exit;
  for i := AIndex to FCount - 2 do
  begin
    FTriangles[i] := FTriangles[i + 1];
    FEdges[i] := FEdges[i + 1];
  end;
  dec(FCount);
end;

procedure TsdTriangleGroup2D.Exchange(Index1, Index2: integer);
var
  T: TsdTriangle2D;
  E: integer;
begin
  if (Index1 < 0) or (Index1 >= FCount) or
     (Index2 < 0) or (Index2 >= FCount)then
    exit;
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

function TsdTriangleGroup2D.GetTriangles(Index: integer): TsdTriangle2D;
begin
  Result := FTriangles[Index mod FCount];
end;

procedure TsdTriangleGroup2D.InsertTriangleAndEdge(AIndex: integer;
  ATriangle: TsdTriangle2D; AEdge: integer);
var
  i: integer;
begin
  // adjust capacity
  if FCount >= FCapacity then
  begin
    FCapacity := FCount * 3 div 2 + 4;
    SetLength(FTriangles, FCapacity);
    SetLength(FEdges, FCapacity);
  end;
  // Move up above index position
  for i := FCount downto AIndex + 1 do
  begin
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

procedure TsdTriangleFan2D.BuildTriangleFan(ABase: TsdTriangle2D);
var
  Triangle: TsdTriangle2D;
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
  if Triangle = nil then
  begin
    // in case we hit a border (no neighbours): we also scan clockwise from
    // base, and insert before rest of items. This will usually only happen
    // for meshes with holes or vertices at the borders of the mesh
    Idx := ABase.VertexIndex(FCenter);
    Triangle := ABase.Neighbours[Idx];
    while Triangle <> nil do
    begin
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

function TsdTriangleFan2D.GetVertices(Index: integer): TsdVertex2D;
var
  Idx: integer;
begin
  Idx := Index mod Count;
  Result := FTriangles[Idx].Vertices[FEdges[Idx] + 1];
end;

procedure TsdTriangleFan2D.MoveToVertexAt(AIndex: integer);
var
  Vertex: TsdVertex2D;
begin
  Vertex := Vertices[AIndex];
  FCenter := Vertex;
  BuildTriangleFan(FTriangles[AIndex]);
end;

procedure TsdTriangleFan2D.SetCenter(const Value: TsdVertex2D);
var
  Base: TsdTriangle2D;
begin
  FCenter := Value;
  if not assigned(Value) then
    exit;
  // to do: build triangle list
  Base := Value.Triangle;
  if not assigned(Base) then
    raise Exception.Create(sNoTriangleForVertex);
  BuildTriangleFan(Base);
end;

function TsdTriangleFan2D.TriangleIdxInDirection(const APoint: TsdPoint2D): integer;
var
  CP1, CP2: double;
  DeltaVP: TsdPoint2D;
begin
  Result := -1;
  if FCount = 0 then
    exit;
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

function TsdTriangleFan2D.TriangleInDirection(const APoint: TsdPoint2D): TsdTriangle2D;
var
  Idx: integer;
begin
  Idx := TriangleIdxInDirection(APoint);
  if Idx < 0 then
    Result := nil
  else
    Result := FTriangles[Idx];
end;

function TsdTriangleFan2D.VertexIndex(AVertex: TsdVertex2D): integer;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if GetVertices(i) = AVertex then
    begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

{ TsdTriangleChain2D }

function TsdTriangleChain2D.BuildChain(AVertex1, AVertex2: TsdVertex2D;
  var ASearchFan: TsdTriangleFan2D): boolean;
var
  Idx, Edge: integer;
  Fan: TsdTriangleFan2D;
  Triangle, Previous: TsdTriangle2D;
  Vertex: TsdVertex2D;
  Delta12: TsdPoint2D;
begin
  Result := False;
  FVertex1 := AVertex1;
  FVertex2 := AVertex2;
  Clear;
  if not assigned(FVertex1) or not assigned(FVertex2) then
    exit;
  if FVertex1 = FVertex2 then
  begin
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
    if Idx >= 0 then
    begin
      // Goody goody, we can stop because we directly found *one* triangle connecting
      // the two vertices
      AddTriangleAndEdge(Fan.Triangles[Idx], Fan.OutwardEdges[Idx] + 1);
      Result := True;
      exit;
    end;

    // No direct one, so we locate the triangle in the direction of Vertex 2
    Idx := Fan.TriangleIdxInDirection(FVertex2.FPoint);

    // If there's none, we're doomed.. we cannot build the chain
    if Idx < 0 then
      exit;

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
      if Vertex = FVertex2 then
      begin
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
      end else
      begin
        // On left side, so next offending edge is one vertex away
        Edge := Edge + 1;
      end;

      // Now we add the triangle, and the edge that is offending
      AddTriangleAndEdge(Triangle, Edge);

    until False;

  finally
    // Free searchfan if temporary
    if Fan <> ASearchFan then
      Fan.Free;
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

function TsdTriMesh2D.BoundingBox(var AMin, AMax: TsdPoint2D): boolean;
var
  i: integer;
  P: PsdPoint2D;
begin
  if FVertices.Count > 0 then
  begin
    AMin := FVertices[0].Point^;
    AMax := FVertices[0].Point^;
    for i := 1 to FVertices.Count - 1 do
    begin
      P := FVertices[i].Point;
      if P.X < AMin.X then AMin.X := P.X;
      if P.X > AMax.X then AMax.X := P.X;
      if P.Y < AMin.Y then AMin.Y := P.Y;
      if P.Y > AMax.Y then AMax.Y := P.Y;
    end;
    Result := True;
  end else
  begin
    AMin := cZero2D;
    AMax := cZero2D;
    Result := False;
  end;
end;

procedure TsdTriMesh2D.Clear;
begin
  FVertices.Clear;
  FTriangles.Clear;
  FBoundaries.Clear;
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
  FVertices := TsdVertex2DList.Create(True);
  FTriangles := TsdTriangle2DList.Create(True);
  FBoundaries := TsdBoundary2DList.Create(True);
  SetPrecision(cDefaultTriangulationPrecision);
end;

destructor TsdTriMesh2D.Destroy;
begin
  FreeAndNil(FVertices);
  FreeAndNil(FTriangles);
  FreeAndNil(FBoundaries);
  inherited;
end;

class function TsdTriMesh2D.GetBoundaryClass: TsdBoundary2DClass;
begin
  Result := TsdBoundary2D;
end;

class function TsdTriMesh2D.GetTriangleClass: TsdTriangle2DClass;
begin
  Result := TsdTriangle2D;
end;

class function TsdTriMesh2D.GetVertexClass: TsdVertex2DClass;
begin
  Result := TsdTriVertex2D;
end;

procedure TsdTriMesh2D.InitializeInfo;
begin
  FSearchSteps := 0;
end;

function TsdTriMesh2D.LocateClosestVertex(const APoint: TsdPoint2D; AFan: TsdTriangleFan2D): TsdVertex2D;
var
  i, BestIndex: integer;
  Fan: TsdTriangleFan2D;
  IsClosest: boolean;
  CenterDist, FanDist, BestDist: double;
begin
  Result := nil;
  BestDist := 0;
  BestIndex := 0;
  if FTriangles.Count = 0 then
    exit;

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
    for i := 0 to Fan.Count - 1 do
    begin
      FanDist := TaxicabDist2D(Fan.Vertices[i].Point^, APoint);
      if FanDist < CenterDist then
        IsClosest := False;
      if (i = 0) or (FanDist < BestDist) then
      begin
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

function TsdTriMesh2D.NewBoundary: TsdBoundary2D;
begin
  Result := GetBoundaryClass.Create;
end;

function TsdTriMesh2D.NewTriangle: TsdTriangle2D;
begin
  Result := GetTriangleClass.Create;
  Result.FMesh := Self;
end;

function TsdTriMesh2D.NewVertex: TsdVertex2D;
begin
  Result := GetVertexClass.Create;
end;

procedure TsdTriMesh2D.OptimizeForFEM(AVertices: TsdVertex2DList);
var
  i, Idx, IdxSeed, IdxLowest: integer;
  SL: TSortedList;
  Seed, Connected: TsdTriangle2D;
  ConnectedIdx: array[0..2] of integer;
  V: TsdVertex2D;
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
    for i := 0 to 2 do
    begin
      V := Seed.Vertices[i];
      if assigned(V) and (AVertices.IndexOf(V) < 0) then
        AVertices.Add(V);
    end;
  end;
// main
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
    while SL.Count > 0 {Idx < FTriangles.Count - 2} do
    begin
      // Seed triangle (the one we're working from)
      if not assigned(Seed) then
      begin
        Seed := TsdTriangle2D(SL[0]);
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
        Connected := TsdTriangle2D(SL[IdxLowest])
      else
        Connected := nil;

      // Do we have a connected triangle?
      if assigned(Connected) then
      begin
        // We have a connection.. do the exchange
        Seed := Connected;
        SL.Delete(IdxLowest);
        MoveForward;
      end else
      begin
        // No connection.. re-initialize seed
        Seed := nil;
      end;
    end;
  finally
    SL.Free;
  end;
end;

procedure TsdTriMesh2D.RemoveNonBoundarys;
var
  i: integer;
  S: TsdBoundary2D;
begin
  for i := FBoundaries.Count - 1 downto 0 do
  begin
    S := FBoundaries[i];
    if not assigned(S.Vertex1) or not assigned(S.Vertex2) or (S.Vertex1 = S.Vertex2) then
      FBoundaries.Delete(i);
  end;
end;

procedure TsdTriMesh2D.SetPrecision(const Value: double);
begin
  if FPrecision <> Value then
  begin
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
  T1, T2: TsdTriangle2D;
begin
  T1 := TsdTriangle2D(Item1);
  T2 := TsdTriangle2D(Item2);
  Result := CompareDouble(T1.Center.X, T2.Center.X);
end;

end.

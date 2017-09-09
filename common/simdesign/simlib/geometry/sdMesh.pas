unit sdMesh;
{
  Description:

  Meshing and planification routines. There are 3 types of meshes:
  - Triangle mesh: each facet consists of a triangle
  - Quad mesh: each facet consist of a quad (4 points)
  - Polygon mesh: each facet consists of a polygon (planar)

  This unit contains purely geometric code, so no material props, colors, etc
  are part of the geometry yet.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 23Jul2002

  Modifications:

  copyright (c) 2002 - 2007 SimDesign B.V.
}

interface

uses
  Classes, SysUtils, sdPoints3D, sdMatrices, Math;

type

  TsdMeshTriangle = record
    VertexIdx: array[0..2] of integer;
  end;
  PsdMeshTriangle = ^TsdMeshTriangle;

  // This is the ancestor class for TsdTriangleMesh, TsdQuad and TsdPolygonMesh.
  // it stores all the vertices and normals
  TsdBaseMesh3D = class(TPersistent)
  private
    FVertices: array of TsdPoint3D;
    FVtxNormals: array of TsdPoint3D;
    FVertexCount: integer;
    FStoreNormals: boolean;
    function GetVtxNormals(Index: integer): PsdPoint3D;
  protected
    function GetVertices(Index: integer): PsdPoint3D;
    property StoreNormals: boolean read FStoreNormals write FStoreNormals;
    function GetArea: double; virtual; abstract;
  public
    constructor Create;
    // Assign another mesh to this one. This base class only copies vertices
    // and normals
    procedure Assign(Source: TPersistent); override;
    // Add a vertex with coordinates X,Y,Z and normal NX,NY,NK
    function VertexAdd(const X, Y, Z, NX, NY, NZ: double): integer;
    // Clear the mesh
    procedure Clear; virtual;
    // get the bounding box of all the vertices
    function GetBoundingBox: TsdBox3D;
    // get a reference to a vertex at Index
    property Vertices[Index: integer]: PsdPoint3D read GetVertices;
    // get a reference to the normal of the vertex at Index
    property VtxNormals[Index: integer]: PsdPoint3D read GetVtxNormals;
    // Number of vertices in the mesh
    property VertexCount: integer read FVertexCount;
    // Return the area of all mesh surface elements summed up
    property Area: double read GetArea;
  end;

  // Surface mesh built from triangle elements
  TsdTriangleMesh3D = class(TsdBaseMesh3D)
  private
    FTriangles: array of TsdMeshTriangle;
    FTriNormals: array of TsdPoint3D;
    FTriangleCount: integer;
    function GetTriangles(Index: integer): PsdMeshTriangle;
    function GetTriNormals(Index: integer): PsdPoint3D;
  protected
    function GetArea: double; override;
  public
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
    function GetTriangleArea(Index: integer): double;
    function TriangleAdd(V0, V1, V2: integer): integer;
    // Calculate just the triangle normals
    procedure CalculateTriNormals;
    // Calculate triangle normals, and vertex normals if they're not available,
    // by using the normals of surrounding triangles and average them
    procedure CalculateNormals;
    // Triangle pointers
    property Triangles[Index: integer]: PsdMeshTriangle read GetTriangles;
    // Triangle normals (unit length)
    property TriNormals[Index: integer]: PsdPoint3D read GetTriNormals;
    property TriangleCount: integer read FTriangleCount;
  end;

  // Vertex indices:
  // 0 -- 1
  // |    |
  // 2 -- 3
  TsdMeshQuad = record
    VertexIdx: array[0..3] of integer;
  end;
  PsdMeshQuad = ^TsdMeshQuad;

  // TsdQuad3D is a collction of four-sided surface elements. It is depreciated
  // to use this for surface definition.
  TsdQuad3D = class(TsdBaseMesh3D)
  private
    FQuads: array of TsdMeshQuad;
    FQuadCount: integer;
    FVertices: array of TsdPoint3D;
    FVertexCount: integer;
    function GetQuads(Index: integer): PsdMeshQuad;
  protected
    function GetArea: double; override;
  public
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
    function QuadAdd(V0, V1, V2, V3: integer): integer;
    function GetQuadArea(Index: integer): double;
    property Area: double read GetArea;
    property Quads[Index: integer]: PsdMeshQuad read GetQuads;
    property QuadCount: integer read FQuadCount;
    property Vertices[Index: integer]: PsdPoint3D read GetVertices;
    property VertexCount: integer read FVertexCount;
  end;

  TsdPolygonDef = record
    Index: integer;
    Count: integer;
  end;
  PsdPolygonDef = ^TsdPolygonDef;

  // A mesh consisting of polygonal surface elements. Each polygon building
  // up the 3D surface mesh should be flat.
  TsdPolygonMesh = class(TsdBaseMesh3D)
  private
    //FPolygons: array of TsdPolygonDef;
  end;

// Build a test mesh
procedure BuildTestMesh(XSize, YSize: integer; ZFactor: double; Mesh: TsdTriangleMesh3D);

// plane fitting

// Find the Normal (A, B, C) and value D so that plane equation
// A * x + B * y + C * Z = D is optimized. The returned Normal will be unified,
// and |D| represents the distance of the plane from the origin. This routine
// is suitable for PointCount = 3 or PointCount > 3 (separate algorithms). For
// PointCount = 3, the found plane is exact.
procedure PlaneFit(Points: PsdPoint3D; PointCount: integer; var Normal: TsdPoint3D; var D: double);

// Find a transform that rotates the points around Z until the smallest
// bounding box is found. The transform also ensures that the bounding box is
// biggest in X direction ("landscape").
procedure AlignToSmallestFittingBoundingBoxXY(Points: PsdPoint3D; PointCount: integer; var T: TsdMatrix3x4; var BB: TsdBox3D; const Eps: double = 1E-12);

resourcestring
  sCannotFitPlaneToLessThan3Points = 'Cannot fit plane to less than 3 points';
  sPointsAreColinear               = 'Points are colinear';

implementation

const
  cEps: double = 1E-12;

procedure BuildTestMesh(XSize, YSize: integer; ZFactor: double; Mesh: TsdTriangleMesh3D);
var
  i, x, y: integer;
  XPos, YPos: array of double;
  R: double;
  Normal: TsdPoint3D;
  // local
  function GetVtxIdx(x, y, Idx: integer): integer;
  begin
    case Idx of
    0: Result := (y    ) * (XSize + 1) + (x    );
    1: Result := (y    ) * (XSize + 1) + (x + 1);
    2: Result := (y + 1) * (XSize + 1) + (x    );
    3: Result := (y + 1) * (XSize + 1) + (x + 1);
    else
      Result := 0;//avoid compiler warning
    end;//case
  end;
// main
begin
  Mesh.Clear;
  SetLength(Xpos, XSize + 1);
  SetLength(Ypos, YSize + 1);
  for i := 0 to XSize do
    XPos[i] := -0.5 + 1/XSize * i;
  for i := 0 to YSize do
    YPos[i] := -0.5 + 1/YSize * i;
  // Add vertices
  for y := 0 to YSize do
    for x := 0 to XSize do begin
      R := sqrt(sqr(XPos[x]) +sqr(Ypos[y]));
      if R < 1E-20 then begin
        Normal.X := 0;
        Normal.Y := 0;
        Normal.Z := 1;
      end else begin
        Normal.Y := cos (XPos[x]/R);
        Normal.X := sin (YPos[y]/R);
        Normal.Z := sqrt(1 - sqr(R));
      end;

      // Map onto a circle
      Mesh.VertexAdd(XPos[x], YPos[y], ZFactor * (sqrt(1 - (sqr(XPos[x]) +sqr(Ypos[y]))) -1) , Normal.X, Normal.Y, Normal.Z);
    end;
  // Add triangles
  // 0 -- - -- 1
  // |         |
  // |         |
  // |         |
  // 2 -- - -- 3
  for y := 0 to YSize - 1 do
    for x := 0 to XSize - 1 do begin
      if odd(x + y) then begin
        Mesh.TriangleAdd(GetVtxIdx(x, y, 3), GetVtxIdx(x, y, 2), GetVtxIdx(x, y, 0));
        Mesh.TriangleAdd(GetVtxIdx(x, y, 1), GetVtxIdx(x, y, 3), GetVtxIdx(x, y, 0));
      end else begin
        Mesh.TriangleAdd(GetVtxIdx(x, y, 2), GetVtxIdx(x, y, 0), GetVtxIdx(x, y, 1));
        Mesh.TriangleAdd(GetVtxIdx(x, y, 3), GetVtxIdx(x, y, 2), GetVtxIdx(x, y, 1));
      end;
    end;
  // Build edges
  //Mesh.BuildEdgeList;
end;

procedure PlaneFit(Points: PsdPoint3D; PointCount: integer; var Normal: TsdPoint3D; var D: double);
var
  i: integer;
  Jac, Jinv: TsdMatrix;
  Zero, Abcd: TsdVector;
  P, P1, P2, P3: PsdPoint3D;
  BB: TsdBox3D;
  L, Lx, Ly, Lz: double;
  Maxis: TsdPoint3D;
begin
  // Checks
  if PointCount < 3 then
    raise Exception.Create(sCannotFitPlaneToLessThan3Points);

  if PointCount = 3 then
  begin

    // Calculate normal from crossproduct
    P1 := Points;
    P2 := P1; inc(P2);
    P3 := P2; inc(P3);
    CrossProduct3D(Delta3D(P1^, P2^), Delta3D(P1^, P3^), Normal);

    // Check length and normalize
    L := Length3D(Normal);
    if L < cEps then
      raise Exception.Create(sPointsAreColinear);
    ScalePoint3D(Normal, 1/L);

    // Find parameter D
    D := DotProduct3D(Normal, P1^);

  end else
  begin
    // PointCount > 3

    // Determine major axis alignment
    BB := BoundingBox3D(Points, PointCount);
    Lx := BB.Xmax - BB.Xmin;
    Ly := BB.Ymax - BB.Ymin;
    Lz := BB.Zmax - BB.Zmin;
    if (Lx < Ly) and (Lx < Lz) then
      Maxis := cXaxis3D
    else
      if (Ly < Lx) and (Ly < Lz) then
        Maxis := cYaxis3D
      else
        Maxis := cZaxis3D;

    // calculate the plane fit
    Jac := TsdMatrix.CreateSize(PointCount + 1, 4);
    Jinv := TsdMatrix.Create;
    Zero := TsdVector.CreateCount(PointCount + 1);
    Abcd := TsdVector.CreateCount(4);
    try
      // add all point equations
      P := Points;
      for i := 0 to PointCount - 1 do
      begin
        Jac[i, 0] := P.X;
        Jac[i, 1] := P.Y;
        Jac[i, 2] := P.Z;
        Jac[i, 3] := 1;
        inc(P);
      end;

      // We add an additional equation which puts the major axis to length 1
      Jac[PointCount, 0] := Maxis.X * PointCount;
      Jac[PointCount, 1] := Maxis.Y * PointCount;
      Jac[PointCount, 2] := Maxis.Z * PointCount;
      Zero[PointCount] := PointCount;

      // Calculate inverse
      try
        MatInverseMP(Jac, Jinv);
      except
        raise Exception.Create(sPointsAreColinear);
      end;

      // Normal, non-unified
      MatMultiply(Jinv, Zero, Abcd);
      Normal.X := Abcd[0];
      Normal.Y := Abcd[1];
      Normal.Z := Abcd[2];

      // Make unified normal
      L := length3D(Normal);
      if L < cEps then
        raise Exception.Create(sPointsAreColinear);
      ScalePoint3D(Normal, 1 / L);

      // Calc parameter D
      D := - Abcd[3] / L;

    finally
      Jac.Free;
      Jinv.Free;
      Zero.Free;
      Abcd.Free;
    end;

  end;

  // Flip normal if pointing downwards
  if DotProduct3D(Normal, cZaxis3D) < 0 then
  begin
    FlipVector3D(Normal);
    D := -D;
  end;

end;

procedure AlignToSmallestFittingBoundingBoxXY(Points: PsdPoint3D; PointCount: integer; var T: TsdMatrix3x4; var BB: TsdBox3D; const Eps: double);
const
  cSteps = 10;
var
  Temp: array of TsdPoint3D;
  Angle: double;
  // local
  procedure RecurseFindRotation(const Amin, Amax: double);
  var
    i, Idx: integer;
    Area, Delta, A: double;
    MustAdd90: boolean;
  begin
    Area := 0;
    Delta := (Amax - Amin) / cSteps;
    Idx := 0;
    MustAdd90 := False;
    for i := 0 to cSteps do
    begin
      PoseToTransformMatrix(0, 0, 0, 0, 0, Amin + i * Delta, T);
      TransformPoints(Points, @Temp[0], PointCount, T);
      BB := BoundingBox3D(@Temp[0], PointCount);
      A := (BB.XMax - BB.XMin) * (BB.Ymax - BB.Ymin);
      if (i = 0) or (A < Area) then
      begin
        Area := A;
        Idx := i;
        MustAdd90 := (BB.XMax - BB.XMin) < (BB.Ymax - BB.Ymin);
      end
    end;
    if Delta < Eps then
    begin
      Angle := Amin + Idx * Delta;
      if MustAdd90 then
        Angle := Angle + pi/2;
    end else
      RecurseFindRotation(Amin + (Idx - 1) * Delta, Amin + (Idx + 1) * Delta);
  end;
// main
begin
  SetLength(Temp, PointCount);
  // Go through section of -45 to +45 recursively
  RecurseFindRotation(-pi/4, pi/4);
  // Find pose matrix
  PoseToTransformMatrix(0, 0, 0, 0, 0, Angle, T);
  // Transform points again to find bounding box
  TransformPoints(Points, @Temp[0], PointCount, T);
  BB := BoundingBox3D(@Temp[0], PointCount);
end;

{ TsdBaseMesh3D }

procedure TsdBaseMesh3D.Assign(Source: TPersistent);
begin
  if Source is TsdBaseMesh3D then
  begin
    // copy vertices and normals
    FVertexCount := TsdBaseMesh3D(Source).FVertexCount;
    SetLength(FVertices, FVertexCount);
    SetLength(FVtxNormals, FVertexCount);
    if FVertexCount > 0 then
    begin
      Move(TsdBaseMesh3D(Source).FVertices[0], FVertices[0], FVertexCount * SizeOf(TsdPoint3D));
      Move(TsdBaseMesh3D(Source).FVtxNormals[0], FVtxNormals[0], FVertexCount * SizeOf(TsdPoint3D));
    end;

  end else
    // General persistent methods
    inherited;
end;

procedure TsdBaseMesh3D.Clear;
begin
  SetLength(FVertices, 0);
  SetLength(FVtxNormals, 0);
  FVertexCount := 0;
end;

constructor TsdBaseMesh3D.Create;
begin
  inherited;
  FStoreNormals := True;
end;

function TsdBaseMesh3D.GetBoundingBox: TsdBox3D;
begin
  Result := BoundingBox3D(@FVertices[0], VertexCount)
end;

function TsdBaseMesh3D.GetVertices(Index: integer): PsdPoint3D;
begin
  Result := @FVertices[Index];
end;

function TsdBaseMesh3D.GetVtxNormals(Index: integer): PsdPoint3D;
begin
  Result := @FVtxNormals[Index];
end;

function TsdBaseMesh3D.VertexAdd(const X, Y, Z, NX, NY,
  NZ: double): integer;
begin
  // increase capacity
  if length(FVertices) = FVertexCount then
  begin
    SetLength(FVertices, round(length(FVertices) * 1.5) + 10);
    SetLength(FVtxNormals, length(FVertices));
  end;
  FVertices[FVertexCount] := Point3D(X, Y, Z);
  FVtxNormals[FVertexCount] := Point3D(NX, NY, NZ);
  Result := FVertexCount;
  inc(FVertexCount);
end;

{ TsdTriagleMesh3D }

procedure TsdTriangleMesh3D.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TsdTriangleMesh3D then
  begin
    // copy triangles
    FTriangleCount := TsdTriangleMesh3D(Source).FTriangleCount;
    SetLength(FTriangles, FTriangleCount);
    if FTriangleCount > 0 then
      Move(TsdTriangleMesh3D(Source).FTriangles[0], FTriangles[0], FTriangleCount * SizeOf(TsdMeshTriangle));
  end else
    inherited;
end;

procedure TsdTriangleMesh3D.CalculateNormals;
// We calculate the vertex normals based on triangle normals around. Since currently
// the mesh triangles do not have neighbour pointers, this is not a very optimal
// algorithm!
var
  i, j, k, Count: integer;
  TriangleIdx: array of integer;
  N: TsdPoint3D;
begin
  // Calculate triangle normals
  CalculateTriNormals;

  // Calculate the normal for each vertex
  for i := 0 to VertexCount - 1 do
  begin
    // For each vertex: find the list of triangles connecting to it
    Count := 0;
    for j := 0 to TriangleCount - 1 do
    begin
      for k := 0 to 2 do
      begin
        if Triangles[j].VertexIdx[k] = i then
        begin
          if Count = Length(TriangleIdx) then
            SetLength(TriangleIdx, Length(TRiangleIdx) + 4);
          TriangleIdx[Count] := j;
          inc(Count);
        end;
      end;
    end;

    // Calculate the normal as the average of the triangle normals
    N := cZero3D;
    for j := 0 to Count - 1 do
      AddPoint3D(N, FTriNormals[TriangleIdx[j]], N);
    NormalizeVector3D(N);
    FVtxNormals[i] := N;
  end;
end;

procedure TsdTriangleMesh3D.CalculateTriNormals;
var
  i: integer;
  D1, D2: TsdPoint3D;
begin
  // Create a list of normals for each triangle
  SetLength(FTriNormals, TriangleCount);

  // Calculate triangle normals
  for i := 0 to TriangleCount - 1 do
  begin
    D1 := Delta3D(FVertices[FTriangles[i].VertexIdx[0]], FVertices[FTriangles[i].VertexIdx[1]]);
    D2 := Delta3D(FVertices[FTriangles[i].VertexIdx[0]], FVertices[FTriangles[i].VertexIdx[2]]);
    CrossProduct3D(D1, D2, FTriNormals[i]);
    NormalizeVector3D(FTriNormals[i]);
  end;
end;

procedure TsdTriangleMesh3D.Clear;
begin
  inherited;
  SetLength(FTriangles, 0);
  FTriangleCount := 0;
end;

function TsdTriangleMesh3D.GetArea: double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to FTriangleCount - 1 do
    Result := Result + GetTriangleArea(i);
end;

function TsdTriangleMesh3D.GetTriangleArea(Index: integer): double;
var
  D0, D1, D2: PsdPoint3D;
  CP: TsdPoint3D;
begin
  with FTriangles[Index] do
  begin
    D0 := @FVertices[VertexIdx[0]];
    D1 := @FVertices[VertexIdx[1]];
    D2 := @FVertices[VertexIdx[2]];
  end;
  CrossProduct3D(Delta3D(D0^, D1^), Delta3D(D0^, D2^), CP);
  Result := 0.5 * Length3D(CP);
end;

function TsdTriangleMesh3D.GetTriangles(Index: integer): PsdMeshTriangle;
begin
  Result := @FTriangles[Index];
end;

function TsdTriangleMesh3D.GetTriNormals(Index: integer): PsdPoint3D;
begin
  if (Index >= 0) and (Index < length(FTriNormals)) then
    Result := @FTriNormals[Index]
  else
    Result := nil;
end;

function TsdTriangleMesh3D.TriangleAdd(V0, V1, V2: integer): integer;
begin
  // increase capacity
  if length(FTriangles) = FTriangleCount then
    SetLength(FTriangles, round(length(FTriangles) * 1.5) + 10);
  with FTriangles[FTriangleCount] do
  begin
    VertexIdx[0] := V0;
    VertexIdx[1] := V1;
    VertexIdx[2] := V2;
  end;
  Result := FTriangleCount;
  inc(FTriangleCount);
end;

{ TsdQuad3D }

procedure TsdQuad3D.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TsdQuad3D then
  begin

    // copy quads
    FQuadCount := TsdQuad3D(Source).FQuadCount;
    SetLength(FQuads, FQuadCount);
    if FQuadCount > 0 then
      Move(TsdQuad3D(Source).FQuads[0], FQuads[0], FQuadCount * SizeOf(TsdMeshQuad));
  end else
    inherited;
end;

procedure TsdQuad3D.Clear;
begin
  inherited;
  SetLength(FQuads, 0);
  FQuadCount := 0;
end;

function TsdQuad3D.GetArea: double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to FQuadCount - 1 do
    Result := Result + GetQuadArea(i);
end;

function TsdQuad3D.GetQuadArea(Index: integer): double;
var
  D0, D1, D2, D3: PsdPoint3D;
  CP: TsdPoint3D;
begin
  with FQuads[Index] do
  begin
    D0 := @FVertices[VertexIdx[0]];
    D1 := @FVertices[VertexIdx[1]];
    D2 := @FVertices[VertexIdx[2]];
    D3 := @FVertices[VertexIdx[3]];
  end;
  CrossProduct3D(Delta3D(D0^, D1^), Delta3D(D0^, D2^), CP);
  Result := 0.5 * Length3D(CP);
  CrossProduct3D(Delta3D(D3^, D2^), Delta3D(D3^, D1^), CP);
  Result := Result + 0.5 * Length3D(CP);
end;

function TsdQuad3D.GetQuads(Index: integer): PsdMeshQuad;
begin
  Result := @FQuads[Index];
end;

function TsdQuad3D.QuadAdd(V0, V1, V2, V3: integer): integer;
begin
  // increase capacity
  if length(FQuads) = FQuadCount then
    SetLength(FQuads, round(length(FQuads) * 1.5) + 10);
  with FQuads[FQuadCount] do
  begin
    VertexIdx[0] := V0;
    VertexIdx[1] := V1;
    VertexIdx[2] := V2;
    VertexIdx[3] := V3;
  end;
  Result := FQuadCount;
  inc(FQuadCount);
end;

end.

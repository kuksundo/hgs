{
  Description:
  Triangulation of planar straight line graphs into a triangular mesh.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 01Feb2007

  Modifications:

  projects that use this unit:
    Prodim Unfold
    Triangulator demo

  copyright (c) 2007 SimDesign B.V.
  
  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
  
}
unit sdTriangulate2D;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  {$IFNDEF FPC}
  {$ELSE}
    LCLIntf, LCLType, LMessages,
  {$ENDIF}
  Dialogs, Classes, Contnrs, SysUtils,
  // simdesign units
  sdTriMesh2D, sdPoints2D;

type

  // Class encapsulating 2D Planar Straightline Graphs (PSLG)
  TsdGraph2D = class(TPersistent)
  private
    FVertices: TsdVertex2DList;
    FBoundarys: TsdBoundary2DList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; virtual;
    // Replaces references in the segment list to OldVertex by a reference to
    // NewVertex.
    procedure ReplaceVertex(OldVertex, NewVertex: TsdVertex2D);
    // Load from the string in AData
    procedure ReadFromString(const AData: string);
    // Save to a string in AData
    procedure WriteToString(var AData: string);
    // List of vertices in this graph
    property Vertices: TsdVertex2DList read FVertices;
    // List of boundaries in this graph
    property Boundarys: TsdBoundary2DList read FBoundarys;
  end;

  TsdMeshRegion = class(TPersistent)
  private
    FWindingNumber: integer;
    FIsOuterRegion: boolean;
  public
    // Winding number of this region
    property WindingNumber: integer read FWindingNumber write FWindingNumber;
    // This region is the outer region (only one)
    property IsOuterRegion: boolean read FIsOuterRegion write FIsOuterRegion;
  end;

  TsdMeshRegionList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdMeshRegion;
  public
    property Items[Index: integer]: TsdMeshRegion read GetItems; default;
  end;

  TsdStringEvent = procedure (Sender: TObject; const AMessage: string) of object;

  // Which triangles should be removed after triangulation?
  TsdRemovalStyle = (
    rsNone,     // Remove no triagles
    rsOutside,  // Remove all triangles that are connected to construction vertices
    rsEvenOdd,  // Even-Odd fillrule removal
    rsNonZero,  // Non-Zero fillrule removal
    rsNegative  // Remove all triangles with windingnumber < 0
  );

  // Triangulates a polygon or other Planar Straightline Graphs (PSLG) into
  // a triangular mesh.
  TsdTriangulationMesh2D = class(TsdTriMesh2D)
  private
    FCornerPoints: TsdVertex2DList;
    FRemovals: TsdTriangle2DList;
    FRegions: TsdMeshRegionList;
    FBoundaryChain: TsdTriangleChain2D;
    FSearchFan: TsdTriangleFan2D;
    FTick: dword;
    FVertexSkipCount: integer;
    FSplitEdgeCount: integer;
    FSplitBodyCount: integer;
    FHitTests: integer;
    FAreaInitial: double;
    FCalculationTime: double;
    FOnExecutionStep: TsdStringEvent;
    FOnPhaseComplete: TsdStringEvent;
    FOnStatus: TsdStringEvent;
  protected
    FBBMin, FBBMax: TsdPoint2D;
    FMeshMin, FMeshMax: TsdPoint2D;
    class function GetTriangleClass: TsdTriangle2DClass; override;
    // perform the execution step event
    procedure DoExecutionStep(const AMessage: string);
    // perform phase complete event
    procedure DoPhaseComplete(const AMessage: string);
    // perform status event
    procedure DoStatus(const AMessage: string);
    // Replace OldVertex by NewVertex in all boundaries
    procedure ReplaceVertexInBoundaries(OldVertex, NewVertex: TsdVertex2D);
    // Prepare the mesh so it can triangulate vertices by adding 4 corner points
    // and 2 initial triangles
    procedure PrepareMeshConstruction; virtual;
    // Remove the mesh construction elements that were created initially
    procedure RemoveMeshConstruction(ARemovalStyle: TsdRemovalStyle); virtual;
    // Detect all the regions in the mesh, give each triangle a region index
    procedure DetectRegions; virtual;
    // Add another boundary to the triangulation
    function AddBoundaryToTriangulation(ABoundary: TsdBoundary2D): boolean;
    // Add another vertex to the triangulation, subsequently dividing the mesh.
    // When False is returned, the vertex was not added (it fell on top of another vertex)
    function AddVertexToTriangulation(AVertex: TsdVertex2D; Updates: TsdTriangle2DList): boolean; virtual;
    // Split the triangle into 3 sub-triangles, at point AVertex on the body. The
    // point is guaranteed to lie on the triangle prior before calling this
    // method.
    procedure SplitTriangleBody(ATriangle: TsdTriangle2D; AVertex: TsdVertex2D; Updates: TsdTriangle2DList);
    // Split the triangle into 2 on the edge (with AEdge index) at AVertex, and
    // do the same with the triangle opposing the edge. In some rare cases, this
    // might lead to degenerate triangles at the opposing edge, in this case
    // the triangle's body is split. AVertex is guaranteed to lie in the triangle,
    // or just on the edge.
    procedure SplitTriangleEdge(ATriangle: TsdTriangle2D; AEdge: integer;
      AVertex: TsdVertex2D; Updates: TsdTriangle2DList);
    // Hittest the triangle list to find the triangle under the position where
    // AVertex is located. If a triangle was hit, it is returned in the ATriangle.
    // Result indicates where the triangle was hit. If ATriangle contains a
    // reference upon calling, it will be used as an initial guess. Set UseQuick
    // to true if the ATriangle input is expected to be far away from the hit,
    // or set to False if ATriangle is probably the one hit. If called with
    // UseQuick = false, ATriangle *must* be assigned!
    function HitTestTriangles(const APoint: TsdPoint2D; var ATriangle: TsdTriangle2D; UseQuick: boolean): TsdHitTestTriangle;
    // This routine can be called when separate triangle groups in the mesh may be no longer
    // connected (after removal). Since the normal method relies on connectedness,
    // it can fail. This method is *much* slower, simply verifies each triangle,
    // but guarantees a result is returned in these odd cases.
    function BruteForceHitTestTriangles(const APoint: TsdPoint2D; var ATriangle: TsdTriangle2D): TsdHitTestTriangle;
    // Do post-processing on the mesh.
    procedure PostProcessMesh; virtual;
    // Check triangle after it was inserted, the AEdge indicates the edge number
    // for which neighbours need to be checked.
    procedure CheckTriangleWithEdge(ATriangle: TsdTriangle2D; AEdge: integer;
      Updates: TsdTriangle2DList); virtual;
    // Generate a list of triangles that occur around AVertex. The list AList will
    // be cleared before this is done. AVertex should have a valid pointer to
    // one of the triangles it belongs to. If the result is false, AVertex didn't
    // have a pointer, or it was an invalid pointer.
    function BuildTriangleFan(AList: TsdTriangle2DList; AVertex: TsdVertex2D): boolean;
    // Remove ATriangle from the mesh. This also resets the neighbours so they
    // do not point to the triangle. ATriangle will be disposed of.
    procedure RemoveTriangleFromMesh(ATriangle: TsdTriangle2D);
    // Reduce the chain by swapping triangles. Since this is a delaunay action,
    // we do not implement it here but in descendant.
    procedure ReduceBoundaryChain(AChain: TsdTriangleChain2D; ARemovals: TsdTriangle2DList); virtual;
    // Initialize info properties
    procedure InitializeInfo; override;
    // Finalize info properties
    procedure FinalizeInfo; virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    // Clear all vertices, triangles and segments in the mesh, and initialize
    // all statistics.
    procedure Clear; override;
    // Add the vertices and segments of AGraph to our mesh. This doesn't triangulate
    // them yet, call Triangulate to triangulate all the graphs that have been added.
    procedure AddGraph(AGraph: TsdGraph2D); virtual;
    // Triangulate the graphs that were added with AddGraph, by adding all the
    // vertices and segments in turn to the mesh. Before this is done, the mesh
    // is cleared and 4 corner points are added well outside the polygon's
    // bounding box. Between these 4 points, 2 initial triangles are added.
    // After the triangulation finishes, but before post-processing, the bounding
    // corners + triangles not part of the final mesh will be removed, unless
    // ARemovalStyle = rsNone.
    procedure Triangulate(ARemovalStyle: TsdRemovalStyle = rsOutside);
    // List of mesh regions. Regions have a winding number which indicates
    // visibility according to fill rule
    property Regions: TsdMeshRegionList read FRegions;
    // Number of vertices skipped in triangulation. Skipping happens because sometimes
    // vertices may lay almost on top of other vertices (within Precision), and
    // these vertices will be skipped.
    property VertexSkipCount: integer read FVertexSkipCount;
    // Number of triangle body splits that occurred in triangulation
    property SplitBodyCount: integer read FSplitBodyCount;
    // Number of triangle edge splits that occurred in triangulation
    property SplitEdgeCount: integer read FSplitEdgeCount;
    // The number of triangle hit tests performed.
    property HitTests: integer read FHitTests;
    // Initial area after creating the bounding box
    property AreaInitial: double read FAreaInitial;
    // Total time in seconds for triangulation (including postprocessing)
    property CalculationTime: double read FCalculationTime;
    // Connect an event to this handler to get information on each step in the
    // execution
    property OnExecutionStep: TsdStringEvent read FOnExecutionStep write FOnExecutionStep;
    // Connect an event to this handler to get information on completed phases
    property OnPhaseComplete: TsdStringEvent read FOnPhaseComplete write FOnPhaseComplete;
    // Information for the status line (fast update rate)
    property OnStatus: TsdStringEvent read FOnStatus write FOnStatus;
  end;

resourcestring

  sCrossSegmentIntersectionError = 'CrossSegment-Intersection Error';

implementation

{ TsdGraph2D }

procedure TsdGraph2D.Clear;
begin
  FVertices.Clear;
  FBoundarys.Clear;
end;

constructor TsdGraph2D.Create;
begin
  inherited;
  FVertices := TsdVertex2DList.Create;
  FBoundarys := TsdBoundary2DList.Create;
end;

destructor TsdGraph2D.Destroy;
begin
  FreeAndNil(FBoundarys);
  FreeAndNil(FVertices);
  inherited;
end;

procedure TsdGraph2D.ReadFromString(const AData: string);
var
  i, Count, Idx: integer;
  SL: TStringList;
  A, B: string;
  V: TsdVertex2D;
  S: TsdBoundary2D;
  // local
  procedure Split(const ALine: string; var A, B: string);
  var
    Idx: integer;
  begin
    Idx := Pos(#9, ALine);
    A := copy(ALine, 1, Idx - 1);
    B := copy(ALine, Idx + 1, length(ALine));
  end;
// main
begin
  Clear;
  SL := TStringList.Create;
  SL.Text := AData;
  Idx := 0;
  Count := StrToIntDef(SL[Idx], 0); inc(Idx);
  for i := 0 to Count - 1 do
  begin
    Split(SL[Idx], A, B); inc(Idx);
    V := TsdTriVertex2D.CreateWithCoords(StrToFloatDef(A, 0), StrToFloatDef(B, 0));
    Vertices.Add(V);
  end;
  Count := StrToIntDef(SL[Idx], 0); inc(Idx);
  for i := 0 to Count - 1 do
  begin
    Split(SL[Idx], A, B); inc(Idx);
     S := TsdBoundary2D.CreateWithVertices(
       Vertices[StrToIntDef(A, 0)], Vertices[StrToIntDef(B, 0)]);
     Boundarys.Add(S);
  end;
  SL.Free;
end;

procedure TsdGraph2D.ReplaceVertex(OldVertex, NewVertex: TsdVertex2D);
var
  i: integer;
begin
  for i := 0 to Boundarys.Count - 1 do
    Boundarys[i].ReplaceVertex(OldVertex, NewVertex);
end;

procedure TsdGraph2D.WriteToString(var AData: string);
var
  i: integer;
  SL: TStringList;
  V: TsdVertex2D;
  S: TsdBoundary2D;
begin
  SL := TStringList.Create;
  SL.Add(IntToStr(Vertices.Count));
  for i := 0 to Vertices.Count - 1 do
  begin
    V := Vertices[i];
    SL.Add(Format('%8.2f'#9'%8.2f', [V.X, V.Y]));
  end;
  SL.Add(IntToStr(Boundarys.Count));
  for i := 0 to Boundarys.Count - 1 do
  begin
    S := Boundarys[i];
    SL.Add(Format('%d'#9'%d', [Vertices.IndexOf(S.Vertex1), Vertices.IndexOf(S.Vertex2)]));
  end;
  AData := SL.Text;
  SL.Free;
end;

{ TsdMeshRegionList }

function TsdMeshRegionList.GetItems(Index: integer): TsdMeshRegion;
begin
  Result := Get(Index);
end;

{ TsdTriangulationMesh2D }

procedure TsdTriangulationMesh2D.AddGraph(AGraph: TsdGraph2D);
var
  i, Idx, FirstVtx: integer;
  V: TsdVertex2D;
  S: TsdBoundary2D;
begin
  // Store first element indices
  FirstVtx := Vertices.Count;

  // Add vertices
  for i := 0 to AGraph.Vertices.Count - 1 do
  begin
    V := NewVertex;
    V.Assign(AGraph.Vertices[i]);
    Vertices.Add(V);
  end;

  // Add boundaries
  for i := 0 to AGraph.Boundarys.Count - 1 do
  begin
    S := NewBoundary;
    S.Assign(AGraph.Boundarys[i]);
    // Now figure out which vertices this boundary connects
    Idx := AGraph.Vertices.IndexOf(S.Vertex1);
    S.Vertex1 := Vertices[FirstVtx + Idx];
    Idx := AGraph.Vertices.IndexOf(S.Vertex2);
    S.Vertex2 := Vertices[FirstVtx + Idx];
    Boundaries.Add(S);
  end;
end;

function TsdTriangulationMesh2D.AddBoundaryToTriangulation(ABoundary: TsdBoundary2D): boolean;
var
  i, j, E1, E2: integer;
  Triangle, T1, T2: TsdTriangle2D;
  CrossBoundary: TsdBoundary2D;
  Vertex, V1, V2: TsdVertex2D;
  // local
  procedure SplitAndAddSegment(AVertex: TsdVertex2D);
  var
    NewS: TsdBoundary2D;
  begin
    NewS := TsdBoundary2D.Create;
    NewS.Vertex1 := AVertex;
    NewS.Vertex2 := ABoundary.Vertex2;
    ABoundary.Vertex2 := AVertex;
    Boundaries.Add(NewS);
  end;
// main
begin
  // Build a triangle chain from Vertex1 to Vertex2
  Result := FBoundaryChain.BuildChain(ABoundary.Vertex1, ABoundary.Vertex2, FSearchFan);

  // Do any of the offending edges have a vertex *on* the segment to-be-added?
  for i := 0 to FBoundaryChain.Count - 2 do
  begin
    Triangle := FBoundaryChain.Triangles[i];
    V1 := Triangle.Vertices[FBoundaryChain.Edges[i]];
    V2 := Triangle.Vertices[FBoundaryChain.Edges[i] + 1];
    if ABoundary.IsVertexOnBoundary(V1, FPrecisionSqr) then
    begin
      // Yep, V1 lies on our segment
      SplitAndAddSegment(V1);
      Result := False;
      exit;
    end;
    if ABoundary.IsVertexOnBoundary(V2, FPrecisionSqr) then
    begin
      // Yep, V2 lies on our segment
      SplitAndAddSegment(V2);
      Result := False;
      exit;
    end;
  end;

  // Do any triangles in this chain contain a boundary crossing our boundary to-be-added?
  for i := 0 to FBoundaryChain.Count - 2 do
  begin
    Triangle := FBoundaryChain.Triangles[i];
    CrossBoundary := Triangle.Boundaries[FBoundaryChain.Edges[i]];
    if assigned(CrossBoundary) then
    begin
      // Indeed, we must split this one: find intersection
      Vertex := ABoundary.IntersectWith(CrossBoundary);
      if not assigned(Vertex) then
        // We do have a cross segment but no intersection.. this should not happen
        raise Exception.Create(sCrossSegmentIntersectionError);
      // Add this vertex to our list
      Vertices.Add(Vertex);
      // Insert the vertex into the triangulation, this will force the other
      // segment to split as well
      AddVertexToTriangulation(Vertex, nil);
      // Now split our segment.
      SplitAndAddSegment(Vertex);
      Result := False;
      exit;
    end;
  end;

  // If we have more than one triangle in the chain, we must reduce it by swapping
  // triangle pairs. The triangles removed from the chain are stored in FRemovals
  if FBoundaryChain.Count > 1 then
    ReduceBoundaryChain(FBoundaryChain, FRemovals);

  // After reduction we hopefully have only one segment.. so now we can add
  // this segment
  if FBoundaryChain.Count = 1 then
  begin
    T1 := FBoundaryChain.Triangles[0];
    E1 := FBoundaryChain.Edges[0] + 2;
    T2 := T1.Neighbours[E1];
    E2 := T2.NeighbourIndex(T1);
    T1.Boundaries[E1] := ABoundary;
    T2.Boundaries[E2] := ABoundary;
    DoExecutionStep('Add Boundary');
  end;

  // Now we will re-check the list of removed triangles
  for i := 0 to FRemovals.Count - 1 do
    for j := 0 to 2 do
      CheckTriangleWithEdge(FRemovals[i], j, nil);
  FRemovals.Clear;
end;

function TsdTriangulationMesh2D.AddVertexToTriangulation(AVertex: TsdVertex2D; Updates: TsdTriangle2DList): boolean;
var
  Triangle: TsdTriangle2D;
  OldVertex: TsdVertex2D;
  Status: TsdHitTestTriangle;
begin
  Triangle := nil;
  Result := True;
  Status := HitTestTriangles(AVertex.Point^, Triangle, True);
  // If on the body of the triangle, we will split the triangle into 3 sub-
  // triangles.
  // If on one of the edges, split the triangle into 2, on the edge, as well
  // as the triangle neighbouring it.
  // If on one of the vertices (httVtx0..2), this means that an earlier triangle
  // was formed with one of the vertices very close to this one-to-be-added.
  // We will skip this vertex, return the hit vertex, and we will inform about that.
  case Status of
  httNone:
    begin
      // Deary, we didn't find any triangle! This situation should normally not
      // arise, unless the initial mesh is not large enough, or the mesh is at
      // its limit of numerical precision. We will simply skip the vertex.
      Result := False;
      exit;
    end;
  httBody: SplitTriangleBody(Triangle, AVertex, Updates);
  httVtx0..httVtx2:
    begin
      DoExecutionStep(Format('Vertex %d skipped (too close to another one)', [Vertices.IndexOf(AVertex)]));
      inc(FVertexSkipCount);
      case Status of
      httVtx0: OldVertex := Triangle.Vertices[0];
      httVtx1: OldVertex := Triangle.Vertices[1];
      httVtx2: OldVertex := Triangle.Vertices[2];
      else
        OldVertex := nil;
      end;
      // In case a vertex lies too close to another one, we will not add this
      // vertex, but we must make sure any segments to-be-added do not use this
      // vertex but the new one
      ReplaceVertexInBoundaries(AVertex, OldVertex);
      Result := False;
    end;
  httEdge0: SplitTriangleEdge(Triangle, 0, AVertex, Updates);
  httEdge1: SplitTriangleEdge(Triangle, 1, AVertex, Updates);
  httEdge2: SplitTriangleEdge(Triangle, 2, AVertex, Updates);
  end;
end;

function TsdTriangulationMesh2D.BruteForceHitTestTriangles(
  const APoint: TsdPoint2D; var ATriangle: TsdTriangle2D): TsdHitTestTriangle;
var
  i: integer;
begin
  Result := httNone;
  ATriangle := nil;
  for i := 0 to Triangles.Count - 1 do
  begin
    Result := Triangles[i].HitTest(APoint);
    if not (Result in [httNone, httClose0, httClose1, httClose2]) then
    begin
      ATriangle := Triangles[i];
      exit;
    end;
  end;
end;

function TsdTriangulationMesh2D.BuildTriangleFan(AList: TsdTriangle2DList;
  AVertex: TsdVertex2D): boolean;
  // local
  procedure FindRecursive(ABase: TsdTriangle2D);
  var
    i: integer;
    N: TsdTriangle2D;
  begin
    // loop through neighbours
    for i := 0 to 2 do
    begin
      N := ABase.Neighbours[i];
      if not assigned(N) then
        continue;
      // does neighbour contain AVertex?
      if N.VertexIndex(AVertex) = -1 then
        continue;
      // Obviously.. check if we do not have it already
      if AList.IndexOf(N) >= 0 then
        continue;
      // Ok, new one.. add it
      AList.Add(N);
      FindRecursive(N);
    end;
  end;
// main
var
  i: integer;
  TriBase: TsdTriangle2D;
begin
  AList.Clear;
  Result := false;
  if not assigned(AVertex) then
    exit;
  TriBase := AVertex.Triangle;
  if not assigned(TriBase) or (TriBase.VertexIndex(AVertex) = -1) then
  begin
    TriBase := nil;
    // Hecky-decky: not a correct pointer.. try the brute force method to find
    // one
    for i := 0 to Triangles.Count - 1 do
      if Triangles[i].VertexIndex(AVertex) >= 0 then
      begin
        TriBase := Triangles[i];
        break;
      end;
    if not assigned(TriBase) then
      exit;
  end;
  Result := True;
  AList.Add(TriBase);
  FindRecursive(TriBase);
end;

procedure TsdTriangulationMesh2D.CheckTriangleWithEdge(ATriangle: TsdTriangle2D;
  AEdge: integer; Updates: TsdTriangle2DList);
begin
// default does nothing
end;

procedure TsdTriangulationMesh2D.Clear;
begin
  inherited;
  FCornerPoints.Clear;
  FRemovals.Clear;
  FSearchFan.Clear;
  FBoundaryChain.Clear;
end;

constructor TsdTriangulationMesh2D.Create;
begin
  inherited;
  FCornerPoints := TsdVertex2DList.Create(True);
  FRegions := TsdMeshRegionList.Create(True);
  FRemovals := TsdTriangle2DList.Create(False);
  FSearchFan := TsdTriangleFan2D.Create;
  FBoundaryChain := TsdTriangleChain2D.Create;
end;

destructor TsdTriangulationMesh2D.Destroy;
begin
  FreeAndNil(FCornerPoints);
  FreeAndNil(FRegions);
  FreeAndNil(FRemovals);
  FreeAndNil(FSearchFan);
  FreeAndNil(FBoundaryChain);
  inherited;
end;

procedure TsdTriangulationMesh2D.DetectRegions;
var
  i, RIdx, Idx: integer;
  T, N: TsdTriangle2D;
  S: TsdBoundary2D;
  R: TsdMeshRegion;
  Borders: TsdTriangle2DList;
  // recursive, local
  procedure FloodRegion(ATriangle: TsdTriangle2D; AIndex: integer);
  var
    i: integer;
    N: TsdTriangle2D;
    S: TsdBoundary2D;
  begin
    Borders.Remove(ATriangle);
    ATriangle.RegionIndex := AIndex;
    // Direct neighbours?
    for i := 0 to 2 do
    begin
      N := ATriangle.Neighbours[i];
      S := ATriangle.Boundaries[i];
      if assigned(N) then
      begin
        if N.RegionIndex >= 0 then
          continue;
        if assigned(S) then
        begin
          // There's a segment inbetween, we add this one to the border list
          if Borders.IndexOf(N) < 0 then
            Borders.Add(N);
        end else
        begin
          // A neighbour in the same region
          FloodRegion(N, AIndex);
        end;
      end;
    end;
  end;
// main
begin
  // Clear all regions and indices
  Regions.Clear;
  for i := 0 to Triangles.Count - 1 do
    Triangles[i].RegionIndex := -1;

  // Initial region with winding number 0
  R := TsdMeshRegion.Create;
  Regions.Add(R);
  RIdx := 0;

  // Find a seed triangle, this is any triangle which doesn't have all neighbours set
  T := nil;
  for i := 0 to Triangles.Count - 1 do
  begin
    T := Triangles[i];
    Idx := T.NeighbourIndex(nil);
    if Idx >= 0 then
    begin
      S := T.Boundaries[Idx];
      if assigned(S) then
      begin
        if S.Vertex1 = T.Vertices[i] then
          R.WindingNumber := 1
        else
          R.WindingNumber := -1;
      end else
      begin
        R.WindingNumber := 0;
        R.IsOuterRegion := True;
      end;
      break;
    end;
  end;
  if not assigned(T) then
    exit;

  // Temporary border list
  Borders := TsdTriangle2DList.Create(false);
  try
    // Keep on flooding regions until there are no more bordering triangles
    repeat
      // Flood the mesh region from the triangle with RIdx region index
      FloodRegion(T, RIdx);

      R := nil;
      // Do we have any borders?
      if Borders.Count > 0 then
      begin
        T := Borders[0];
        for i := 0 to 2 do
        begin
          N := T.Neighbours[i];
          S := T.Boundaries[i];
          if assigned(N) and assigned(S) then
          begin
            if N.RegionIndex >= 0 then
            begin
              // OK, found a neighbour with region initialized.. we base our
              // new region on the relation here
              R := TsdMeshRegion.Create;
              if S.Vertex1 = T.Vertices[i] then
                R.WindingNumber := Regions[N.RegionIndex].WindingNumber + 1
              else
                R.WindingNumber := Regions[N.RegionIndex].WindingNumber - 1;
              Regions.Add(R);
              inc(RIdx);
              break;
            end;
          end;
        end;
      end;

    until (Borders.Count = 0) or (R = nil);

  finally
    Borders.Free;
  end;
end;

procedure TsdTriangulationMesh2D.DoExecutionStep(const AMessage: string);
begin
  if assigned(FOnExecutionStep) then
    FOnExecutionStep(Self, AMessage);
end;

procedure TsdTriangulationMesh2D.DoPhaseComplete(const AMessage: string);
begin
  if assigned(FOnPhaseComplete) then
    FOnPhaseComplete(Self, AMessage);
end;

procedure TsdTriangulationMesh2D.DoStatus(const AMessage: string);
begin
  if assigned(FOnStatus) then
    FOnStatus(Self, AMessage);
end;

procedure TsdTriangulationMesh2D.FinalizeInfo;
begin
  // Calculation time
  FCalculationTime := (GetTickCount - FTick) / 1000;
end;

class function TsdTriangulationMesh2D.GetTriangleClass: TsdTriangle2DClass;
begin
  Result := TsdTriangle2D;
end;

function TsdTriangulationMesh2D.HitTestTriangles(const APoint: TsdPoint2D;
  var ATriangle: TsdTriangle2D; UseQuick: boolean): TsdHitTestTriangle;
var
  Neighbour: TsdTriangle2D;
  Closest: TsdVertex2D;
  Edge: integer;
begin
  Result := httNone;
  if UseQuick then
  begin
    // Use a quick-search to find a likely triangle as a basis
    Closest := LocateClosestVertex(APoint, FSearchFan);
    // FSearchFan is a vertex jumper
    ATriangle := FSearchFan.TriangleInDirection(APoint);
    if not assigned(ATriangle) then
      ATriangle := Closest.Triangle;
    if not assigned(ATriangle) and (Triangles.Count > 0) then
      ATriangle := Triangles[0];
  end else
  begin
    // We skip the quicksearch
    if not assigned(ATriangle) then
      raise Exception.Create('triangle must be assigned without quicksearch');
  end;

  // no triangles?
  if not assigned(ATriangle) then
    exit;

  repeat
    // Hit-test the triangle
    Result := ATriangle.HitTest(APoint);
    inc(FHitTests);

    // Deal with close hits
    if Result in [httClose0..httClose2] then
    begin
      // Try neighbour on this side
      Neighbour := nil;
      case Result of
      httClose0: Neighbour := ATriangle.Neighbours[0];
      httClose1: Neighbour := ATriangle.Neighbours[1];
      httClose2: Neighbour := ATriangle.Neighbours[2];
      end;
      if assigned(Neighbour) then
      begin
        ATriangle := Neighbour;
        Result := ATriangle.HitTest(APoint);
        inc(FHitTests);
      end;
      case Result of
      httClose0: Result := httEdge0;
      httClose1: Result := httEdge1;
      httClose2: Result := httEdge2;
      end;
    end;
    if Result <> httNone then
      break;

    // Find neighbouring triangle
    Edge := ATriangle.EdgeFromCenterTowardsPoint(APoint);
    if Edge = -1 then
      raise Exception.Create('Unable to find direction');
    ATriangle := ATriangle.Neighbours[Edge];

    // No neighbour: we have ended up in "da middle of nawheere"
    if not assigned(ATriangle) then
      break;

  until Result <> httNone;
end;

procedure TsdTriangulationMesh2D.InitializeInfo;
begin
  inherited;
  FVertexSkipCount := 0;
  FSplitEdgeCount := 0;
  FSplitBodyCount := 0;
  FHitTests := 0;
  FCalculationTime := 0;
  FTick := GetTickCount;
end;

procedure TsdTriangulationMesh2D.PostProcessMesh;
begin
// default does nothing
end;

procedure TsdTriangulationMesh2D.PrepareMeshConstruction;
const
  cGrowFactor = 0.2;
  cMargin = 20;
var
  Delta: TsdPoint2D;
  Tri1, Tri2: TsdTriangle2D;
begin
  // Calculate bounding box
  if not BoundingBox(FBBMin, FBBMax) then
    exit;

  // MeshMin / MeshMax
  Delta := Delta2D(FBBMin, FBBMax);
  FMeshMin.X := FBBMin.X - Delta.X * cGrowFactor - cMargin;
  FMeshMin.Y := FBBMin.Y - Delta.Y * cGrowFactor - cMargin;
  FMeshMax.X := FBBMax.X + Delta.X * cGrowFactor + cMargin;
  FMeshMax.Y := FBBMax.Y + Delta.Y * cGrowFactor + cMargin;

  // Add 4 vertices and 2 triangles bounding the mesh area
  FCornerPoints.Clear;
  FCornerPoints.Add(GetVertexClass.CreateWithCoords(FMeshMin.X, FMeshMin.Y));
  FCornerPoints.Add(GetVertexClass.CreateWithCoords(FMeshMax.X, FMeshMin.Y));
  FCornerPoints.Add(GetVertexClass.CreateWithCoords(FMeshMax.X, FMeshMax.Y));
  FCornerPoints.Add(GetVertexClass.CreateWithCoords(FMeshMin.X, FMeshMax.Y));
  Tri1 := NewTriangle;
  Tri2 := NewTriangle;
  Tri1.HookupVertices(FCornerPoints[2], FCornerPoints[0], FCornerPoints[1]);
  Tri1.Neighbours[0] := Tri2;
  Tri2.HookupVertices(FCornerPoints[0], FCornerPoints[2], FCornerPoints[3]);
  Tri2.Neighbours[0] := Tri1;
  Triangles.Add(Tri1);
  Triangles.Add(Tri2);
  DoExecutionStep('prepare mesh');
  FAreaInitial := SignedArea;
end;

procedure TsdTriangulationMesh2D.ReduceBoundaryChain(AChain: TsdTriangleChain2D; ARemovals: TsdTriangle2DList);
begin
// default does nothing
end;

procedure TsdTriangulationMesh2D.RemoveMeshConstruction(ARemovalStyle: TsdRemovalStyle);
var
  i: integer;
  T: TsdTriangle2D;
  R: TsdMeshRegion;
  MustRemove: boolean;
begin
  DetectRegions;
  // If we are not going to delete anything.. then leave now
  if ARemovalStyle = rsNone then
    exit;

  for i := Triangles.Count - 1 downto 0 do
  begin
    T := Triangles[i];
    if T.RegionIndex < 0 then
      continue;
    R := Regions[T.RegionIndex];
    case ARemovalStyle of
    rsOutside:  MustRemove := R.IsOuterRegion;
    rsEvenOdd:  MustRemove := not odd(R.WindingNumber);
    rsNonZero:  MustRemove := R.WindingNumber = 0;
    rsNegative: MustRemove := R.WindingNumber < 0;
    else
      MustRemove := False;
    end;//case
    if MustRemove then
      RemoveTriangleFromMesh(T);
  end;

  // Remove the 4 corner points with triangle fans
  FCornerPoints.Clear;
  FSearchFan.Clear;
end;

procedure TsdTriangulationMesh2D.RemoveTriangleFromMesh(ATriangle: TsdTriangle2D);
var
  i, Idx: integer;
  N: TsdTriangle2D;
  V: TsdVertex2D;
begin
  // Remove ATriangle from neighbour pointers
  for i := 0 to 2 do
  begin
    N := ATriangle.Neighbours[i];
    if not assigned(N) then
      continue;
    Idx := N.NeighbourIndex(ATriangle);
    if Idx = -1 then
      continue;
    N.Neighbours[Idx] := nil;
  end;

  // Any vertex pointing at it should have it's pointer reset
  for i := 0 to 2 do
  begin
    V := ATriangle.Vertices[i];
    if assigned(V) and (V.Triangle = ATriangle) then
    begin
      // Point the vertex to one of the neighbours that also shares this triangle
      if assigned(ATriangle.Neighbours[i]) then
      begin
        V.Triangle := ATriangle.Neighbours[i];
        continue;
      end;
      if assigned(ATriangle.Neighbours[i + 2]) then
      begin
        V.Triangle := ATriangle.Neighbours[i + 2];
        continue;
      end;
      // If there are no neighbours, just nil it.. the vertex is orphaned
      V.Triangle := nil;
    end;
  end;
  // Now remove the triangle from the principal list
  Triangles.Remove(ATriangle);
end;

procedure TsdTriangulationMesh2D.ReplaceVertexInBoundaries(OldVertex, NewVertex: TsdVertex2D);
var
  i, Idx: integer;
begin
  // all boundaries containing OldVertex should point to NewVertex
  for i := 0 to Boundaries.Count - 1 do
    Boundaries[i].ReplaceVertex(OldVertex, NewVertex);
  // we also remove OldVertex from our vertices list, by setting its index to nil
  Idx := Vertices.IndexOf(OldVertex);
  if Idx >= 0 then
    Vertices[Idx] := nil;
end;

procedure TsdTriangulationMesh2D.SplitTriangleBody(ATriangle: TsdTriangle2D;
  AVertex: TsdVertex2D; Updates: TsdTriangle2DList);
var
  Tri0, Tri1, Tri2, N0, N1, N2: TsdTriangle2D;
  V0, V1, V2: TsdVertex2D;
begin
  // We already found that APoint lies within ATriangle, now we split ATriangle
  // into 3 subtriangles
  inc(FSplitBodyCount);

  // New triangle 0, 1 & 2
  Tri0 := NewTriangle;
  Tri1 := NewTriangle;
  Tri2 := NewTriangle;
  Triangles.Add(Tri0);
  Triangles.Add(Tri1);
  Triangles.Add(Tri2);

  // Set neighbour's pointers back
  N0 := ATriangle.Neighbours[0];
  N1 := ATriangle.Neighbours[1];
  N2 := ATriangle.Neighbours[2];
  if assigned(N0) then
    N0.ReplaceNeighbour(ATriangle, Tri0);
  if assigned(N1) then
    N1.ReplaceNeighbour(ATriangle, Tri1);
  if assigned(N2) then
    N2.ReplaceNeighbour(ATriangle, Tri2);

  // Setup vertices
  V0 := ATriangle.Vertices[0];
  V1 := ATriangle.Vertices[1];
  V2 := ATriangle.Vertices[2];

  Tri0.HookupVertices(V0, V1, AVertex);
  Tri1.HookupVertices(V1, V2, AVertex);
  Tri2.HookupVertices(V2, V0, AVertex);

  // Setup neighbours
  Tri0.HookupNeighbours(N0, Tri1, Tri2);
  Tri1.HookupNeighbours(N1, Tri2, Tri0);
  Tri2.HookupNeighbours(N2, Tri0, Tri1);

  DoExecutionStep('split body');

  // Check boundaries - todo: is this correct?
  Tri0.Boundaries[0] := ATriangle.Boundaries[0];
  Tri1.Boundaries[0] := ATriangle.Boundaries[1];
  Tri2.Boundaries[0] := ATriangle.Boundaries[2];

  // Add to updates
  if assigned(Updates) then
  begin
    Updates.Add(Tri0);
    Updates.Add(Tri1);
    Updates.Add(Tri2);
  end;

  // Remove the old triangle
  Triangles.Remove(ATriangle);

  // Check these triangles.. in default triangulator this does nothing, but
  // descendants can override
  CheckTriangleWithEdge(Tri0, 0, Updates);
  CheckTriangleWithEdge(Tri1, 0, Updates);
  CheckTriangleWithEdge(Tri2, 0, Updates);
end;

procedure TsdTriangulationMesh2D.SplitTriangleEdge(ATriangle: TsdTriangle2D; AEdge: integer;
  AVertex: TsdVertex2D; Updates: TsdTriangle2DList);
var
  Tri11, Tri12, Tri21, Tri22, N1, N2: TsdTriangle2D;
  E1, E2: integer;
  Pv, Po, Pl, Pr: PsdPoint2D;
  NegTest: boolean;
  S, NewS: TsdBoundary2D;
begin
  // We found that AVertex lies *on* ATriangle's edge with index AEdge. Hence we
  // split ATriangle, and it's neighbour (if any).
  Tri11 := ATriangle;
  E1 := AEdge;
  E2 := -1;
  Tri21 := Tri11.Neighbours[E1];
  if assigned(Tri21) then
  begin

    // Check edge consistency
    E2 := Tri21.NeighbourIndex(Tri11);
    if E2 = -1 then
      // this should not happen.. the integrity is breached
      raise Exception.Create('edges do not match');

    // Since the vertex to insert lays on ATriangle, it doesn't lay on the opposite
    // one. Therefore, we must check if the opposite triangles won't be negative
    // after creation
    Pv := AVertex.Point;
    Po := Tri21.Vertices[E2 + 2].Point;
    Pl := Tri11.Vertices[E1].Point;
    Pr := Tri11.Vertices[E1 + 1].Point;
    NegTest := False;
    if CrossProduct2D(Delta2D(Po^, Pv^), Delta2D(Po^, Pl^)) <= 0 then
      NegTest := True;
    if CrossProduct2D(Delta2D(Po^, Pr^), Delta2D(Po^, Pv^)) <= 0 then
      NegTest := True;
    if NegTest then
    begin
      // Oops! Indeed.. do a triangle body split instead
      SplitTriangleBody(ATriangle, AVertex, Updates);
      exit;
    end;

    inc(FSplitEdgeCount);

    // Split Tri11 and Tri21
    Tri12 := NewTriangle;
    Tri22 := NewTriangle;

    // Set neighbour's pointers back
    N1 := Tri11.Neighbours[E1 + 1];
    if assigned(N1) then
      N1.ReplaceNeighbour(Tri11, Tri12);
    N2 := Tri21.Neighbours[E2 + 1];
    if assigned(N2) then
      N2.ReplaceNeighbour(Tri21, Tri22);

    // Setup neighbours
    Tri11.Neighbours[E1] := Tri22;
    Tri11.Neighbours[E1 + 1] := Tri12;
    Tri12.HookupNeighbours(Tri11, Tri21, N1);
    Tri21.Neighbours[E2] := Tri12;
    Tri21.Neighbours[E2 + 1] := Tri22;
    Tri22.HookupNeighbours(Tri21, Tri11, N2);

    // Setup vertices
    Tri12.HookupVertices(Tri11.Vertices[E1 + 2], AVertex, Tri11.Vertices[E1 + 1]);
    Tri11.Vertices[E1 + 1] := AVertex;
    Tri22.HookupVertices(Tri21.Vertices[E2 + 2], AVertex, Tri21.Vertices[E2 + 1]);
    Tri21.Vertices[E2 + 1] := AVertex;

    Triangles.Add(Tri12);
    Triangles.Add(Tri22);

    // Add to updates list
    if assigned(Updates) then
    begin
      Updates.Add(Tri11);
      Updates.Add(Tri12);
      Updates.Add(Tri21);
      Updates.Add(Tri22);
    end;

  end else
  begin

    // Split just Tri11
    Tri12 := NewTriangle;
    Tri22 := nil;

    // Set neighbour's pointers back
    N1 := Tri11.Neighbours[E1 + 1];
    if assigned(N1) then
      N1.ReplaceNeighbour(Tri11, Tri12);

    // Setup neighbours
    Tri11.Neighbours[E1 + 1] := Tri12;
    Tri12.HookupNeighbours(Tri11, nil, N1);

    // Setup vertices
    Tri12.HookupVertices(Tri11.Vertices[E1 + 2], AVertex, Tri11.Vertices[E1 + 1]);
    Tri11.Vertices[E1 + 1] := AVertex;

    Triangles.Add(Tri12);

    // Add to updates list
    if assigned(Updates) then
    begin
      Updates.Add(Tri11);
      Updates.Add(Tri12);
    end;

  end;

  // Correct boundaries: first the boundary to split up (if any)
  S := Tri11.Boundaries[E1];
  if assigned(S) then
  begin
    // Yeppers, split boundary and add the new one. We also directly assign
    // the new boundary to the triangles, so this new boundary doesnt need to
    // be added explicitly to the mesh with AddBoundary.
    NewS := NewBoundary;
    if S.Vertex1 = Tri11.Vertices[E1] then
    begin
      // Boundary same direction as Tri11 edge:
      NewS.Vertex1 := AVertex;
      NewS.Vertex2 := Tri12.Vertices[2];
      S.Vertex2 := AVertex;
    end else
    begin
      // Boundary opposite direction as Tri11 edge:
      NewS.Vertex1 := Tri12.Vertices[2];
      NewS.Vertex2 := AVertex;
      S.Vertex1 := AVertex;
    end;
    Tri12.Boundaries[1] := NewS;
    if assigned(Tri21) then
    begin
      Tri21.Boundaries[E2] := NewS;
      Tri22.Boundaries[1] := S;
    end;
    // Add the new boundary to our list
    Boundaries.Add(NewS);
  end;

  // Other boundaries: Tri12 takes over from Tri11 on one side
  S := Tri11.Boundaries[E1 + 1];
  Tri11.Boundaries[E1 + 1] := nil;
  Tri12.Boundaries[2] := S;
  if assigned(Tri21) then
  begin
    // Tri22 takes over from Tri21 on one side
    S := Tri21.Boundaries[E2 + 1];
    Tri21.Boundaries[E2 + 1] := nil;
    Tri22.Boundaries[2] := S;
  end;

  DoExecutionStep('split edge');

  // Check triangles
  CheckTriangleWithEdge(Tri11, E1 + 2, Updates);
  CheckTriangleWithEdge(Tri12, 2     , Updates);
  if assigned(Tri21) then
  begin
    CheckTriangleWithEdge(Tri21, E2 + 2, Updates);
    CheckTriangleWithEdge(Tri22, 2     , Updates);
  end;
end;

procedure TsdTriangulationMesh2D.Triangulate(ARemovalStyle: TsdRemovalStyle);
var
  i, j: integer;
  S: TsdBoundary2D;
  T: TsdTriangle2D;
begin
  // Reset info
  InitializeInfo;

  // Prepare mesh area
  PrepareMeshConstruction;
  DoPhaseComplete('Mesh Construction');
  FSearchFan.Clear;

  // Add all vertices to the triangulation. Some vertices might get skipped if
  // they fall on top of another one, in that case the accompanying segment will
  // be updated trough ReplaceVertexInSegments
  for i := 0 to Vertices.Count - 1 do
    AddVertexToTriangulation(Vertices[i], nil);
  DoPhaseComplete('Vertex addition');

  // Since segments might have been updated and not be functional any longer..
  RemoveNonBoundarys;

  // Add all boundaries to the triangulation, thus creating a constrained triangulation.
  // We use a "while" loop because boundaries might be split and boundaries can be
  // inserted on the fly
  i := 0;
  while i < Boundaries.Count do
  begin
    AddBoundaryToTriangulation(Boundaries[i]);
    inc(i);
  end;
  DoPhaseComplete('Boundary addition');

  // Remove the elements we added for construction
  if ARemovalStyle = rsNone then
  begin
    // If construction is left on, we must add segments to all nil neighbours
    // (because only bounded outside edges subdivide well for postprocessing)
    for i := 0 to Triangles.Count - 1 do
    begin
      T := Triangles[i];
      for j := 0 to 2 do
      begin
        if T.Neighbours[j] = nil then
        begin
          S := NewBoundary;
          S.Vertex1 := T.Vertices[j];
          S.Vertex2 := T.Vertices[j + 1];
          Boundaries.Add(S);
          T.Boundaries[j] := S;
        end;
      end;
    end;
  end else
  begin
    RemoveMeshConstruction(rsOutside);
  end;
  DoPhaseComplete('Perform removal');

  // Do post processing (virtual)
  PostProcessMesh;

  if not (ARemovalStyle in [rsNone, rsOutside]) then
  begin
    RemoveMeshConstruction(ARemovalStyle);
    DoPhaseComplete('Remove fill-rule');
  end;

  // finalize info
  FinalizeInfo;
end;

end.
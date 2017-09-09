{
  Description:
  Delaunay triangulation of vertex lists into a triangular mesh, and quality
  mesh refinement.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 01Feb2007

  Modifications:

  copyright (c) 2007 SimDesign B.V.

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit sdDelaunay2D;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Math,
  // simdesign units
  sdTriMesh2D, sdPoints2D, sdTriangulate2D, sdSortedLists;

type

  TsdSortedTriangle2DList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TsdTriangle2D;
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    property Items[Index: integer]: TsdTriangle2D read GetItems; default;
  end;

  TsdEncroachItem = class(TPersistent)
  private
    FBoundary: TsdBoundary2D;
    FEncroacher: TsdTriangle2D;
    FTriangle: TsdTriangle2D;
  public
    // The triangle that encroaches upon the segment
    property Encroacher: TsdTriangle2D read FEncroacher write FEncroacher;
    // The boundary that was encroached
    property Boundary: TsdBoundary2D read FBoundary write FBoundary;
    // The triangle that connects to the encroached segment
    property Triangle: TsdTriangle2D read FTriangle write FTriangle;
  end;

  TsdEncroachItemList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TsdEncroachItem;
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    // Add a new item if not yet present. AEncroacher is the triangle causing
    // the encroach, ATriangle is the triangle having a boundary ABoundary that is
    // encroached
    procedure AddItem(AEncroacher, ATriangle: TsdTriangle2D; ABoundary: TsdBoundary2D);
    // Return the index of an item that has ATriangle as triangle, or -1 if none
    function IndexByTriangle(ATriangle: TsdTriangle2D): integer;
    // Remove all items that have ATriangle as Encroacher or Triangle
    procedure RemoveAllItemsWithTriangle(ATriangle: TsdTriangle2D);
    procedure RemoveAllItemsWithBoundary(ABoundary: TsdBoundary2D);
    property Items[Index: integer]: TsdEncroachItem read GetItems; default;
  end;

  // TsdDelaunayMesh2D implements a delaunay triangulation of a polygon or point
  // cloud.
  TsdDelaunayMesh2D = class(TsdTriangulationMesh2D)
  protected
    procedure SetPrecision(const Value: double); override;
    class function GetTriangleClass: TsdTriangle2DClass; override;
    // Check triangle after it was inserted, the AEdge indicates the edge number
    // for which neighbours need to be checked. See if we need to swap this
    // triangle.
    procedure CheckTriangleWithEdge(ATriangle: TsdTriangle2D; AEdge: integer;
      Updates: TsdTriangle2DList); override;
    // The T1 and T2 triangles should swap their common edge. However, this may not
    // be done under some circumstances. This check should evaluate these. For the
    // standard Delaunay this check ensures the triangles form a convex hull, and
    // that they are not constrained by a segment.
    function AllowSwapTriangles(T1, T2: TsdTriangle2D; E1, E2: integer): boolean; virtual;
    // Reduce the chain by swapping triangle pairs
    procedure ReduceBoundaryChain(AChain: TsdTriangleChain2D; ARemovals: TsdTriangle2DList); override;
    // Do the actual swap of triangle T1 and T2 along edges E1 and E2. This function
    // does *not* check if the swap may be made, see AllowSwapTriangles for the
    // check.
    procedure SwapTriangles(T1, T2: TsdTriangle2D; E1, E2: integer; Updates: TsdTriangle2DList);
    procedure InitializeInfo; override;
  public
    // Count the number of triangles that do not abide Delaunay
    function NonDelaunayTriangleCount: integer;
    // Check whether all triangles abide Delaunay
    function IsDelaunay: boolean;
    // Iterate through the triangles and try to force the non-delaunay ones
    // to adapt. This method can be called after completion of Triangulate. It
    // makes no sense to call this method more than once, unless changes are made
    // to the mesh (the procedure already contains a loop). The return is the new
    // number of non-delaunay triangles.
    function ForceDelaunay: integer;
    // Number of triangle swaps that occurred during triangulation
    property SwapCount: integer read FSwapCount;
    // Number of circle calculations that occurred during triangulation. A
    // circle calculation is used to determine the circle through the 3 points
    // of a triangle.
    property CircleCalcCount: integer read FCircleCalcCount;
  end;

  TsdQualityMesh2D = class(TsdDelaunayMesh2D)
  private
    FBadTriangles: TsdSortedTriangle2DList; // List of bad triangles
    FEncroachedBoundaries: TsdEncroachItemList; // List of encroached boundaries + info
    FUpdates: TsdTriangle2DList;
    FSteinerPoints: TsdVertex2DList;
    FBeta: double;
    FMinimumAngleDeg: double;
    FMinimumAngleCos: double;
    FMinimumSegmentLength: double;
    FMinSegLengthSqr: double;
    FMaximumElementSize: double;
    procedure SetBeta(const Value: double);
    procedure SetMinimumAngle(const Value: double);
    procedure SetMinimumSegmentLength(const Value: double);
  protected
    class function GetTriangleClass: TsdTriangle2DClass; override;
    // Post process the mesh: in this process we subdivide the triangles and
    // add Steiner points.
    procedure PostProcessMesh; override;
    procedure BuildBadTriangleList; virtual;
    procedure ProcessBadTriangleList; virtual;
    procedure UpdateLists; virtual;
    procedure SplitEncroachedBoundary(AItem: TsdEncroachItem); virtual;
    procedure SplitBadTriangle(ATriangle: TsdTriangle2D; TestOnly: boolean); virtual;
    function IsDegenerate(ABoundary: TsdBoundary2D): boolean;
    // Is this a bad triangle? (its smallest angle is smaller than the minimum set)
    function IsBadTriangle(ATriangle: TsdTriangle2D): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    // Refines the mesh locally around X, Y until the element under X,Y is not
    // larger than AMaximumElementSize
    procedure LocalRefine(const X, Y, AMaximumElementSize: double);
    // Returns the minimum angle found in the mesh, in degrees.
    function MinimumAngleInMesh: double;
    // Number of degenerate triangles present in the mesh (due to segment angles
    // being too small)
    function DegenerateTriangleCount: integer;
    // Specify the minimum angle in degrees that may appear within each triangle in the
    // quality triangulation. The practical upper limit for this value is around 33 degrees.
    property MinimumAngle: double read FMinimumAngleDeg write SetMinimumAngle;
    // If segments are to be split, this will not be done if the resulting segments'
    // length is smaller than this value.
    property MinimumSegmentLength: double read FMinimumSegmentLength write SetMinimumSegmentLength;
    // Maximum element size allowed (triangles with larger area will be split).
    // If no maximum size is required, then leave this value on 0 (default)
    property MaximumElementSize: double read FMaximumElementSize write FMaximumElementSize;
    // List of steiner points that were generated
    property SteinerPoints: TsdVertex2DList read FSteinerPoints;
  end;

const
  // Default guaranteed miminum angle for quality mesh generator
  cDefaultMinimumAngle: double = 30;// limited on 41.4 degrees and lower;
  // Default minimum segment length
  cDefaultMinimumSegmentLength: double = 0.5;

implementation

{ TsdSortedTriangle2DList }

function TsdSortedTriangle2DList.DoCompare(Item1, Item2: TObject): integer;
var
  T1, T2: TsdTriangle2D;
begin
  T1 := TsdTriangle2D(Item1);
  T2 := TsdTriangle2D(Item2);
  // We compare quality and want the highest "quality" first (smallest angles),
  // so we invert
  Result := -CompareDouble(T1.Quality, T2.Quality);
end;

function TsdSortedTriangle2DList.GetItems(Index: integer): TsdTriangle2D;
begin
  Result := Get(Index);
end;

{ TsdEncroachItemList }

procedure TsdEncroachItemList.AddItem(AEncroacher, ATriangle: TsdTriangle2D; ABoundary: TsdBoundary2D);
var
  i: integer;
  Item: TsdEncroachItem;
begin
  // Make sure we're unique
  for i := 0 to Count - 1 do
  begin
    Item := Items[i];
    if (Item.Encroacher = AEncroacher) and (Item.Triangle = ATriangle) and
       (Item.Boundary = ABoundary) then
      exit;
  end;
  // If it doesn't exist yet, we create an item
  Item := TsdEncroachItem.Create;
  Item.Encroacher := AEncroacher;
  Item.Triangle := ATriangle;
  Item.Boundary := ABoundary;
  Add(Item);
end;

function TsdEncroachItemList.DoCompare(Item1, Item2: TObject): integer;
var
  E1, E2: TsdEncroachItem;
begin
  E1 := TsdEncroachItem(Item1);
  E2 := TsdEncroachItem(Item2);
  // We want the longest boundary first, so we sort by squared radius, and invert
  Result := -CompareDouble(E1.Boundary.SquaredEncroachRadius, E2.Boundary.SquaredEncroachRadius);
end;

function TsdEncroachItemList.GetItems(Index: integer): TsdEncroachItem;
begin
  Result := Get(Index);
end;

function TsdEncroachItemList.IndexByTriangle(ATriangle: TsdTriangle2D): integer;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].Triangle = ATriangle then
    begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

procedure TsdEncroachItemList.RemoveAllItemsWithBoundary(ABoundary: TsdBoundary2D);
var
  i: integer;
  Item: TsdEncroachItem;
begin
  for i := Count - 1 downto 0 do
  begin
    Item := Items[i];
    if Item.Boundary = ABoundary then
      Delete(i);
  end;
end;

procedure TsdEncroachItemList.RemoveAllItemsWithTriangle(ATriangle: TsdTriangle2D);
var
  i: integer;
  Item: TsdEncroachItem;
begin
  for i := Count - 1 downto 0 do
  begin
    Item := Items[i];
    if (Item.Encroacher = ATriangle) or (Item.Triangle = ATriangle) then
      Delete(i);
  end;
end;

{ TsdDelaunayMesh2D }

function TsdDelaunayMesh2D.AllowSwapTriangles(T1, T2: TsdTriangle2D; E1, E2: integer): boolean;
var
  P10, P12, P20, P22: PsdPoint2D;
begin
  Result := False;

  // We do not allow a swap if there's a boundary on the edge between the triangles
  if assigned(T1.Boundaries[E1]) then
    exit;

  // The corner vertices
  P10 := T1.Vertices[E1].Point;
  P12 := T1.Vertices[E1 + 2].Point;
  P20 := T2.Vertices[E2].Point;
  P22 := T2.Vertices[E2 + 2].Point;

  // Point P20 inside or on border?
  if CrossProduct2D(Delta2D(P22^, P20^), Delta2D(P22^, P12^)) <= 0 then
    exit;
  // Point P10 inside or on border?
  if CrossProduct2D(Delta2D(P12^, P10^), Delta2D(P12^, P22^)) <= 0 then
    exit;

  // Avoid creating triangles with no width
  if PointToLineDist2DSqr(P20^, P22^, P12^) < FPrecisionSqr then
    exit;
  if PointToLineDist2DSqr(P10^, P12^, P22^) < FPrecisionSqr then
    exit;

  // Arriving here means "all ok"
  Result := True;
end;

procedure TsdDelaunayMesh2D.CheckTriangleWithEdge(ATriangle: TsdTriangle2D;
  AEdge: integer; Updates: TsdTriangle2DList);
  // local
  procedure CheckRecursive(ATriangle: TsdTriangle2D; AEdge: integer);
  var
    T1, T2: TsdTriangle2D;
    E1, E2: integer;
  begin
    // Two triangles
    T1 := ATriangle;
    T2 := ATriangle.Neighbours[AEdge];
    if not assigned(T2) then
      exit;
    // Two edge indices
    E1 := AEdge;
    E2 := T2.NeighbourIndex(T1);
    if E2 = -1 then
      // this should not happen.. the integrity is breached
      raise Exception.Create('edges do not match');

    // Check if we need to swap these triangles
    if T1.VertexInCircle(T2.Vertices[E2 + 2]) or
       T2.VertexInCircle(T1.Vertices[E1 + 2]) then
    begin
      if not AllowSwapTriangles(T1, T2, E1, E2) then
        exit;
      // Yes we must swap
      SwapTriangles(T1, T2, E1, E2, Updates);
      // Recursive call
      CheckRecursive(T1, E1);
      CheckRecursive(T2, E2);
      CheckRecursive(T1, (E1 + 2) mod 3);
      CheckRecursive(T2, (E2 + 2) mod 3);
    end;
  end;
// main
begin
  CheckRecursive(ATriangle, AEdge);
end;

function TsdDelaunayMesh2D.ForceDelaunay: integer;
var
  i, j, NewCount: integer;
  T: TsdTriangle2D;
begin
  Result := NonDelaunayTriangleCount;
  if Result = 0 then
    exit;
  repeat
    for i := 0 to Triangles.Count - 1 do
    begin
      T := Triangles[i];
      if not T.IsDelaunay then
      begin
        // try in all directions
        for j := 0 to 2 do
          CheckTriangleWithEdge(T, j, nil);
      end;
    end;
    NewCount := NonDelaunayTriangleCount;
    DoExecutionStep('force delaunay cycle');
    if (NewCount >= Result) or (NewCount = 0) then
      break;
    Result := NewCount;
  until False;
  Result := NewCount;
end;

class function TsdDelaunayMesh2D.GetTriangleClass: TsdTriangle2DClass;
begin
  // This is the class we use
  Result := TsdTriangle2D;
end;

procedure TsdDelaunayMesh2D.InitializeInfo;
begin
  inherited;
  FSwapCount := 0;
  FCircleCalcCount := 0;
end;

function TsdDelaunayMesh2D.IsDelaunay: boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to Triangles.Count - 1 do
  begin
    if not Triangles[i].IsDelaunay then
      exit;
  end;
  Result := True;
end;

function TsdDelaunayMesh2D.NonDelaunayTriangleCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Triangles.Count - 1 do
  begin
    if not Triangles[i].IsDelaunay then
      inc(Result);
  end;
end;

procedure TsdDelaunayMesh2D.ReduceBoundaryChain(AChain: TsdTriangleChain2D; ARemovals: TsdTriangle2DList);
var
  i, Idx, BackupIdx, StartIdx, S1, S2: integer;
  T1, T2: TsdTriangle2D;
  E1, E2: integer;
  V1, V2, P1, P2: TsdVertex2D;
  Delta: TsdPoint2D;
  MustExchange: boolean;
  // local
  procedure GetTrianglesAndEdges(AIndex: integer);
  begin
    // Triangles and edges for the pair
    T1 := AChain.Triangles[AIndex];
    T2 := AChain.Triangles[AIndex + 1];
    E1 := T1.NeighbourIndex(T2);
    E2 := T2.NeighbourIndex(T1);
    if (E1 < 0) or (E2 < 0) then
      raise Exception.Create('Edges do not match');
    // P1 and P2 vertex (left/right) for the pair
    P1 := T1.Vertices[E1 + 2];
    P2 := T2.Vertices[E2 + 2];
    // P1 below, on, or above line?
    if P1 = V1 then
      S1 := 0
    else
      S1 := Sign(CrossProduct2D(Delta, Delta2D(V1.Point^, P1.Point^)));
    // P2 below, on, or above line?
    if P2 = V2 then
      S2 := 0
    else
      S2 := Sign(CrossProduct2D(Delta, Delta2D(V1.Point^, P2.Point^)));
  end;
// main
begin
  if AChain.Count = 0 then
    exit;
  ARemovals.Clear;
  // Start and end vertex
  V1 := AChain.Triangles[0].Vertices[AChain.Edges[0] + 2];
  Idx := AChain.Count - 1;
  V2 := AChain.Triangles[Idx].Vertices[AChain.Edges[Idx]];
  // Delta
  Delta := Delta2D(V1.Point^, V2.Point^);

  StartIdx := 0;
  while AChain.Count > 1 do
  begin
    // Search for a swappable pair
    Idx := -1;
    BackupIdx := -1;
    for i := StartIdx to AChain.Count - 2 do
    begin
      // Triangles and edges for the pair
      GetTrianglesAndEdges(i);

      // Does it make sense to swap?
      if (S1 * S2 < 0) and AllowSwapTriangles(T1, T2, E1, E2) then
      begin
        // No, one point is above one is below, so the swap will not help us.
        // But in some cases, we *must* do this swap, if there are no others
        if BackupIdx < 0 then
          BackupIdx := i;
        continue;
      end;

      if AllowSwapTriangles(T1, T2, E1, E2) then
      begin
        // OK, this pair may be swapped
        Idx := i;
        break;
      end;
    end;

    StartIdx := 0;

    // Swap a pair that cannot be deleted, but might keep the algo going?
    if (Idx < 0) and (BackupIdx >= 0) then
    begin
      Idx := BackupIdx;
      GetTrianglesAndEdges(Idx);
    end;

    // If Idx isn't found, there are no more triangles to swap.. bad news
    if Idx < 0 then
      raise Exception.Create('Cannot reduce triangle chain');

    // We can swap this pair
    SwapTriangles(T1, T2, E1, E2, nil);

    // No deletion if below/above.. instead exchange them if sequence changed
    if S1 * S2 < 0 then
    begin
      if (Idx > 0) then
        MustExchange := T1.NeighbourIndex(AChain.Triangles[Idx - 1]) < 0
      else
        MustExchange := T2.NeighbourIndex(AChain.Triangles[Idx + 2]) < 0;
      if MustExchange then
        AChain.Exchange(Idx, Idx + 1)
      else
        StartIdx := Idx + 1;
      continue;
    end;

    // Determine which one to take out of the list
    if (S1 > 0) or (S2 > 0) then
    begin
      // triangle 2 must go
      AChain.Delete(Idx + 1);
      ARemovals.Add(T2);
    end else
    begin
      // triangle 1 must go (also in case S1 = 0 and S2 = 0, aka the last 2)
      AChain.Delete(Idx);
      ARemovals.Add(T1);
    end;
  end;

  if AChain.Count = 1 then
    AChain.Edges[0] := AChain.Triangles[0].VertexIndex(V2);

end;

procedure TsdDelaunayMesh2D.SetPrecision(const Value: double);
begin
  inherited;
  // We set the delaunay precision as 1% of the precision
  FDelaunayPrecision := Value * 0.01;
end;

procedure TsdDelaunayMesh2D.SwapTriangles(T1, T2: TsdTriangle2D; E1, E2: integer;
  Updates: TsdTriangle2DList);
var
  N: TsdTriangle2D;
begin
  inc(FSwapCount);
  if assigned(Updates) then
  begin
    Updates.Add(T1);
    Updates.Add(T2);
  end;

  // Vertex triangle pointes
  T1.Vertices[E1 + 1].Triangle := T2;
  T2.Vertices[E2 + 1].Triangle := T1;

  // Vertex swap
  T1.Vertices[E1 + 1] := T2.Vertices[E2 + 2];
  T2.Vertices[E2 + 1] := T1.Vertices[E1 + 2];

  // Update neighbours' pointers back
  N := T1.Neighbours[E1 + 1];
  if assigned(N) then
    N.ReplaceNeighbour(T1, T2);
  N := T2.Neighbours[E2 + 1];
  if assigned(N) then
    N.ReplaceNeighbour(T2, T1);

  // Update our neighbour pointers
  T1.Neighbours[E1] := T2.Neighbours[E2 + 1];
  T2.Neighbours[E2] := T1.Neighbours[E1 + 1];
  T1.Neighbours[E1 + 1] := T2;
  T2.Neighbours[E2 + 1] := T1;

  // Update boundaries
  T1.Boundaries[E1] := T2.Boundaries[E2 + 1];
  T2.Boundaries[E2] := T1.Boundaries[E1 + 1];
  T1.Boundaries[E1 + 1] := nil;
  T2.Boundaries[E2 + 1] := nil;

  // Show result to user
  DoExecutionStep('swap triangles');
end;

{ TsdQualityMesh2D }

procedure TsdQualityMesh2D.BuildBadTriangleList;
var
  i: integer;
  T: TsdTriangle2D;
begin
  DoStatus('Building bad triangle list');
  // Build the lists completely (first time)
  FBadTriangles.Clear;
  for i := 0 to Triangles.Count - 1 do
  begin
    T := Triangles[i];
    if IsBadTriangle(T) then
      FBadTriangles.Add(T);
  end;
end;

procedure TsdQualityMesh2D.Clear;
begin
  inherited;
  FBadTriangles.Clear;
  FEncroachedBoundaries.Clear;
  FUpdates.Clear;
  FSteinerPoints.Clear;
end;

constructor TsdQualityMesh2D.Create;
begin
  inherited;
  FBadTriangles := TsdSortedTriangle2DList.Create(False);
  FEncroachedBoundaries := TsdEncroachItemList.Create(True);
  FUpdates := TsdTriangle2DList.Create(False);
  FSteinerPoints := TsdVertex2DList.Create;
  SetMinimumAngle(cDefaultMinimumAngle);
  SetMinimumSegmentLength(cDefaultMinimumSegmentLength);
end;

function TsdQualityMesh2D.DegenerateTriangleCount: integer;
var
  i, j: integer;
  S: TsdBoundary2D;
  T: TsdTriangle2D;
begin
  Result := 0;
  for i := 0 to Triangles.Count - 1 do
  begin
    T := Triangles[i];
    for j := 0 to 2 do
    begin
      S := T.Boundaries[j];
      if not assigned(S) then
        continue;
      if IsDegenerate(S) then
      begin
        inc(Result);
        break;
      end;
    end;
  end;
end;

destructor TsdQualityMesh2D.Destroy;
begin
  FreeAndNil(FBadTriangles);
  FreeAndNil(FEncroachedBoundaries);
  FreeAndNil(FUpdates);
  FreeAndNil(FSteinerPoints);
  inherited;
end;

class function TsdQualityMesh2D.GetTriangleClass: TsdTriangle2DClass;
begin
  Result := TsdTriangle2D;
end;

function TsdQualityMesh2D.IsBadTriangle(ATriangle: TsdTriangle2D): boolean;
begin
  // Minimum angle?
  Result := ATriangle.Quality > FMinimumAngleCos;
  if Result then
    exit;
  // Maximum element size?
  if FMaximumElementSize > 0 then
    Result := ATriangle.Area > FMaximumElementSize;
end;

function TsdQualityMesh2D.IsDegenerate(ABoundary: TsdBoundary2D): boolean;
begin
  // Check: do not split triangles on a segment shorter than our precision
  Result := ABoundary.SquaredEncroachRadius < FMinSegLengthSqr;
end;

procedure TsdQualityMesh2D.LocalRefine(const X, Y, AMaximumElementSize: double);
var
  P: TsdPoint2D;
  T: TsdTriangle2D;
  // local
  function MustRefine(const P: TsdPoint2D): boolean;
  var
    Res: TsdHitTestTriangle;
  begin
    Result := False;
    // Find the triangle under XY
    Res := HitTestTriangles(P, T, True);
    if Res = httNone then
      exit;
    Result := T.Area > AMaximumElementSize;
  end;
// main
begin
  P.X := X; P.Y := Y; T := nil;
  // repeat as long as there's work to do
  while MustRefine(P) do
  begin
    // Add the triangle to the bad list, so it gets split
    FBadTriangles.Add(T);
    // Now process the bad list
    ProcessBadTriangleList;
  end;
end;

function TsdQualityMesh2D.MinimumAngleInMesh: double;
var
  i: integer;
  ACos: double;
  T: TsdTriangle2D;
begin
  Result := 0;
  for i := 0 to Triangles.Count - 1 do
  begin
    T := Triangles[i];

    // Smallest angle cosine in triangle
    ACos := T.SmallestAngleCosine;
    if ACos > Result then
      Result := ACos;
  end;
  // Convert cosine to degrees
  Result := ArcCos(Result) * 180 / pi;
end;

procedure TsdQualityMesh2D.PostProcessMesh;
begin
  // The algorithm is as follows. We first build a list of all bad triangles.
  // We then check this list to see if these bad triangles encroach on any
  // segments.
  BuildBadTriangleList;
  ProcessBadTriangleList;
  DoStatus(Format('Current min. angle: %5.2f', [MinimumAngleInMesh]));
  DoPhaseComplete('Quality generation');
end;

procedure TsdQualityMesh2D.ProcessBadTriangleList;
var
  i: integer;
  T: TsdTriangle2D;
begin
  DoStatus('Processing bad triangle list');

  // Test all bad triangles for encroachment
  for i := FBadTriangles.Count - 1 downto 0 do
  begin
    T := FBadTriangles[i];
    // We call with TestOnly, so no triangles get actually split
    SplitBadTriangle(T, True);
  end;

  repeat

    // Split all encroached boundaries, this has priority.
    while FEncroachedBoundaries.Count > 0 do
    begin
      // Split encroached boundary
      SplitEncroachedBoundary(FEncroachedBoundaries[0]);
      // Deal with possible updates
      UpdateLists;
    end;

    // Next, any bad triangle get split (only the worst one, then recheck encroachment)
    if FBadTriangles.Count > 0 then
    begin
      T := FBadTriangles[0];
      DoStatus(Format('Current min. angle %5.2f in bad triangles (%d)',
        [arccos(T.Quality) * 180 / pi, FBadTriangles.Count]));
      SplitBadTriangle(T, False);
      // Deal with possible updates
      UpdateLists;
    end;

  until (FEncroachedBoundaries.Count = 0) and (FBadTriangles.Count = 0);
end;

procedure TsdQualityMesh2D.SetBeta(const Value: double);
begin
  FBeta := Value;
  FSquaredBeta := sqr(FBeta);
end;

procedure TsdQualityMesh2D.SetMinimumAngle(const Value: double);
var
  MinAngleRad: double;
begin
  if Value > 41.4 then
    raise Exception.Create('Minimum value too high');
  FMinimumAngleDeg := Value;
  MinAngleRad := Value * pi / 180;
  FMinimumAngleCos := cos(MinAngleRad);
  // Calculate related beta factor. We adjust it downwards *just* a bit to
  // avoid detecting inserted quality triangles as having angles too small.
  SetBeta(1 / (2 * sin(0.5 * MinAngleRad)) - 1E-5);
end;

procedure TsdQualityMesh2D.SetMinimumSegmentLength(const Value: double);
begin
  FMinimumSegmentLength := Value;
  FMinSegLengthSqr := sqr(FMinimumSegmentLength);
end;

procedure TsdQualityMesh2D.SplitBadTriangle(ATriangle: TsdTriangle2D; TestOnly: boolean);
var
  i: integer;
  TriFound, N: TsdTriangle2D;
  P: TsdPoint2D;
  S: TsdBoundary2D;
  V: TsdVertex2D;
  Res: boolean;
begin
  // Is the triangle worth splitting?
  if ATriangle.SquaredLongestEdgeLength < FMinSegLengthSqr then
  begin
    FBadTriangles.Remove(ATriangle);
    exit;
  end;

  // Get the off-center of this triangle
  P := ATriangle.OffCenter;

  repeat
    // Find the triangle at this point
    TriFound := ATriangle;
    HitTestTriangles(P, TriFound, False);
    if not assigned(TriFound) then
    begin
      // No triangle found: this means the offcenter is outside the triangulated area.
      // We cannot simply neglect this fact: we will try another point halfway between
      // the center and offcenter
      P := MidPoint2D(P, ATriangle.Center);
    end else
      break;
  until False;

  // We found a triangle. Do we encroach upon it?
  S := TriFound.EncroachedBoundaryFromPoint(P);
  if not assigned(S) then
  begin
    // Also check neighbour triangles
    for i := 0 to 2 do
    begin
      N := TriFound.Neighbours[i];
      if assigned(N) then
      begin
        S := N.EncroachedBoundaryFromPoint(P);
      end;
      if assigned(S) then
      begin
        TriFound := N;
        break;
      end;
    end;
  end;

  // We encroached on boundary S if it exists
  if assigned(S) then
  begin
    if IsDegenerate(S) then
    begin
      // We are only going to get better by splitting a degenerate boundary which
      // we won't do.. so just remove this badboy
      FBadTriangles.Remove(ATriangle);
      exit;
    end else
    begin
      // Deary.. it does encroach on a non-degenerate triangle with boundary. Our
      // triangle still stays bad, but we add the encroached boundary to be split.
      FEncroachedBoundaries.AddItem(ATriangle, TriFound, S);
      exit;
    end;
  end;

  // As long as there are encroached boundaries, we don't add bad triangles
  if TestOnly or (FEncroachedBoundaries.Count > 0) then
    exit;

  // Arriving here means the triangle doesn't encroach on somebody, we can safely
  // split it (by *adding* the vertex, this will correctly split triangles on edges).
  V := GetVertexClass.CreateWithCoords(P.X, P.Y);
  FSteinerPoints.Add(V);
  Res := AddVertexToTriangulation(V, FUpdates);
  if not Res then
  begin
    FSteinerPoints.Delete(FSteinerPoints.Count - 1);
    FBadTriangles.Remove(ATriangle);
  end;
end;

procedure TsdQualityMesh2D.SplitEncroachedBoundary(AItem: TsdEncroachItem);
var
  T: TsdTriangle2D;
  S: TsdBoundary2D;
  V: TsdVertex2D;
  C: TsdPoint2D;
begin
  // get the first encroached boundary (usually there's only one)
  T := AItem.Triangle;
  S := AItem.Boundary;

  // Check: do not split triangles that are degenerate
  if IsDegenerate(S) then
  begin
    FEncroachedBoundaries.RemoveAllItemsWithBoundary(S);
    exit;
  end;

  // Split this boundary: we must make a new vertex and add it to our steiner points
  C := S.Center;
  V := NewVertex;
  V.Point^ := C;
  FSteinerPoints.Add(V);

  // Now split the triangle
  SplitTriangleEdge(T, T.BoundaryIndex(S), V, FUpdates);
  // And remove this boundary from the list of encroached boundaries
  FEncroachedBoundaries.RemoveAllItemsWithBoundary(S);
end;

procedure TsdQualityMesh2D.UpdateLists;
var
  i: integer;
  T: TsdTriangle2D;
begin
  for i := 0 to FUpdates.Count - 1 do
  begin
    T := FUpdates[i];
    if not assigned(T) then
      continue;
    FEncroachedBoundaries.RemoveAllItemsWithTriangle(T);
    if IsBadTriangle(T) then
    begin
      FBadTriangles.Extract(T);
      FBadTriangles.Add(T);
      // Also re-test the bad triangle
      SplitBadTriangle(T, True);
    end else
      FBadTriangles.Remove(T);
  end;
  FUpdates.Clear;
end;

end.

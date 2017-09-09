{
  Description:
  Convex hull generator.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 01Feb2007

  Modifications:

  copyright (c) 2007 SimDesign B.V.

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
  
}
unit sdConvexHull2D;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Math,
  // simdesign units
  sdTriMesh2D, sdPoints2D, sdSortedLists;

type

  TsdRadialVertex2D = class(TsdVertex2D)
  private
    FAngle: double;
    FIsHull: boolean;
  protected
    function GetTriangle: TsdTriangle2D; override;
    procedure SetTriangle(const Value: TsdTriangle2D); override;
  public
    property Angle: double read FAngle write FAngle;
  end;

  // Radially sorted list of vertices
  TsdRadialVertex2DList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TsdRadialVertex2D;
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    property Items[Index: integer]: TsdRadialVertex2D read GetItems; default;
  end;

  TsdConvexHull = class(TPersistent)
  private
    FMesh: TsdTriMesh2D;
    // Add a new segment in the hull, using vertices with Idx1, Idx2
    procedure AddSegment(Idx1, Idx2: integer);
    // Is the vertex AVertex left of line V1-V2? (looking from point V1)
    function IsLeftOfLine(const V1, V2, AVertex: TsdVertex2D): boolean;
    // Does AVertex violate ABoundary (outside of it?)
    function BoundaryViolated(ABoundary: TsdBoundary2D; AVertex: TsdVertex2D): boolean;
    // Add a new vertex to the hull. This updates the hull segments if the
    // vertex falls outside of them
    procedure AddVertexToHull(AVertex: TsdVertex2D);
  public
    procedure MakeConvexHull(AMesh: TsdTriMesh2D);
  end;

  TsdAlphaScan = class(TPersistent)
  private
    FVertices: TsdRadialVertex2DList;
    FHullPts: TsdRadialVertex2DList;
    FRadius: double;
  protected
    // Calculate circle through (0,0), (X1,Y1), (X2,Y2) and produce the squared
    // radius, or 0 if the points lie on a line
    function CalculateCircle(const X1, Y1, X2, Y2: double; var CX, CY: double): double;
    procedure CheckHullInterval(Idx1, Idx2: integer);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    procedure AddVertex(AVertex: TsdRadialVertex2D);
    procedure AddPoint(const X, Y: double);
    procedure AddPoints(Point: PsdPoint2D; Count: integer);
    procedure DoScanOutside;
    property Vertices: TsdRadialVertex2DList read FVertices;
    property Radius: double read FRadius write FRadius;
  end;

implementation

type
  TMeshAccess = class(TsdTriMesh2D);

{ TsdConvexHull }

procedure TsdConvexHull.AddSegment(Idx1, Idx2: integer);
var
  S: TsdBoundary2D;
begin
  S := TMeshAccess(FMesh).NewBoundary;
  S.Vertex1 := FMesh.Vertices[Idx1];
  S.Vertex2 := FMesh.Vertices[Idx2];
  FMesh.Boundaries.Add(S);
end;

procedure TsdConvexHull.AddVertexToHull(AVertex: TsdVertex2D);
var
  i, Idx, Count: integer;
  S, S1, S2: TsdBoundary2D;
  IdxFirst, IdxLast: integer;
  // local
  procedure DeleteBoundaryRange(AStart, ACount: integer);
  begin
    // Deleting a boundary range is a bit tricky, since the range can wrap around in the list
    while ACount > 0 do
    begin
      // We delete boundaries at AStart until that's at the end of the list, else
      // we delete from the 0 position of the list
      if AStart < FMesh.Boundaries.Count then
        FMesh.Boundaries.Delete(AStart)
      else
        FMesh.Boundaries.Delete(0);
      dec(ACount);
    end;
  end;
// main
begin
  // init
  Count := FMesh.Boundaries.Count;
  IdxFirst := -1;
  IdxLast := -1;

  // Loop through all boundaries, and find first and last that are violated
  for i := 0 to Count - 1 do
  begin
    S := FMesh.Boundaries[i];
    if BoundaryViolated(S, AVertex) then
    begin
      // OK, this segment isn't abided..
      IdxFirst := i;
      // Find first one
      if i = 0 then
      begin
        Idx := Count - 1;
        S := FMesh.Boundaries[Idx];
        while BoundaryViolated(S, AVertex) do
        begin
          dec(Idx);
          S := FMesh.Boundaries[Idx];
        end;
        IdxFirst := (Idx + 1) mod Count;
      end;
      // Find last one
      Idx := i + 1;
      S := FMesh.Boundaries[Idx mod Count];
      while BoundaryViolated(S, AVertex) do
      begin
        inc(Idx);
        S := FMesh.Boundaries[Idx mod Count];
      end;
      IdxLast := Idx - 1;
      // Make sure to have a positive delta idx
      if IdxLast < IdxFirst then inc(IdxLast, Count);
      break;
    end;
  end;

  // The vertex fell within all boundaries, so it's already in the hull -> we can stop
  if IdxFirst = -1 then
    exit;

  if IdxFirst = IdxLast then
  begin
    // If first and last indices are equal, we must split up the boundary
    S1 := FMesh.Boundaries[IdxFirst];
    S2 := TMeshAccess(FMesh).NewBoundary;
    S2.Vertex1 := AVertex;
    S2.Vertex2 := S1.Vertex2;
    S1.Vertex2 := AVertex;
    FMesh.Boundaries.Insert(IdxFirst + 1, S2);
  end else
  begin
    // Otherwise we move first boundary's endpoint and last boundary's startpoint
    // to the vertex, and remove intermediate segments
    S1 := FMesh.Boundaries[IdxFirst];
    S2 := FMesh.Boundaries[IdxLast mod Count];
    S1.Vertex2 := AVertex;
    S2.Vertex1 := AVertex;
    Count := IdxLast - IdxFirst - 1;
    if Count > 0 then
      DeleteBoundaryRange(IdxFirst + 1, Count);
  end;
end;

function TsdConvexHull.IsLeftOfLine(const V1, V2, AVertex: TsdVertex2D): boolean;
begin
  Result := CrossProduct2D(Delta2D(V1.Point^, AVertex.Point^), Delta2D(V1.Point^, V2.Point^)) > 0;
end;

procedure TsdConvexHull.MakeConvexHull(AMesh: TsdTriMesh2D);
var
  i: integer;
begin
  if not assigned(AMesh) then
    exit;
  FMesh := AMesh;

  // Start by clearing the boundaries
  FMesh.Boundaries.Clear;

  // We need at least 3 vertices
  if FMesh.Vertices.Count < 3 then
    exit;

  // Build initial 3 segments
  if IsLeftOfLine(FMesh.Vertices[0], FMesh.Vertices[1], FMesh.Vertices[2]) then
  begin
    // vertex 0, 1, 2 counterclockwise
    AddSegment(0, 1);
    AddSegment(1, 2);
    AddSegment(2, 0);
  end else
  begin
    // vertex 0, 1, 2 clockwise, so add 0-2, 2-1 and 1-0
    AddSegment(0, 2);
    AddSegment(2, 1);
    AddSegment(1, 0);
  end;

  // Now add each of the other vertices in turn to the hull
  for i := 3 to FMesh.Vertices.Count - 1 do
    AddVertexToHull(FMesh.Vertices[i]);
end;

function TsdConvexHull.BoundaryViolated(ABoundary: TsdBoundary2D; AVertex: TsdVertex2D): boolean;
begin
  Result := not IsLeftOfLine(ABoundary.Vertex1, ABoundary.Vertex2, AVertex);
end;

{ TsdRadialVertex2DList }

function TsdRadialVertex2DList.DoCompare(Item1, Item2: TObject): integer;
begin
  Result := CompareDouble(TsdRadialVertex2D(Item1).Angle, TsdRadialVertex2D(Item2).Angle);
end;

function TsdRadialVertex2DList.GetItems(Index: integer): TsdRadialVertex2D;
begin
  Result := Get(Index);
end;

{ TsdAlphaScan }

procedure TsdAlphaScan.AddPoint(const X, Y: double);
var
  V: TsdRadialVertex2D;
begin
  V := TsdRadialVertex2D.CreateWithCoords(X, Y);
  AddVertex(V);
end;

procedure TsdAlphaScan.AddPoints(Point: PsdPoint2D; Count: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    AddPoint(Point.X, Point.Y);
    inc(Point);
  end;
end;

procedure TsdAlphaScan.AddVertex(AVertex: TsdRadialVertex2D);
begin
  AVertex.Angle := ArcTan2(AVertex.Y, AVertex.X);
  FVertices.Add(AVertex);
end;

function TsdAlphaScan.CalculateCircle(const X1, Y1, X2, Y2: double; var CX, CY: double): double;
// Calculate circle through (0,0), (X1,Y1), (X2,Y2) and produce the squared
// radius, or 0 if the points lie on a line
var
  Den, A1, A2: double;
begin
  // Calculate circle center and radius (squared)
  Den := ((Y1 - Y2) * X1 - Y1 * (X1 - X2)) * 2;
  A1  :=  X1 * X1 + Y1 * Y1;
  A2  :=  (X1 + X2) * (X1 - X2) + (Y1 - Y2) * (Y1 + Y2);
  // Make sure we don't divide by zero
  if abs(Den) > 1E-20 then
  begin
    // Calculated circle center of circle through points a, b, c
    CX := (A1 * (Y1 - Y2) - A2 * Y1) / Den;
    CY := (A2 * X1 - A1 * (X1 - X2)) / Den;
    // Squared radius of this circle
    Result := CX * CX + CY * CY;
  end else
  begin
    Result := 0;
    CX := 0;
    CY := 0;
  end;
end;

procedure TsdAlphaScan.CheckHullInterval(Idx1, Idx2: integer);
var
  VM, V1, V2: TsdRadialVertex2D;
  i, IdxM: integer;
  A, ABase, AMin, RSqr, Cx, Cy, Dx, Dy: double;
  Res: boolean;
  // local: Determine angle for intermediate point
  function AngleForIdx(AIdx: integer; var Angle: double): boolean;
  var
    V: TsdRadialVertex2D;
    X, Y, Dx, Dy: double;
  begin
    V := FVertices[AIdx mod FVertices.Count];
    X := V.X;
    Y := V.Y;
    // Avoid close to begin/end point
    Dx := X - V2.X; Dy := Y - V2.Y;
    if Dx*Dx + Dy*Dy < 1E-10 then
    begin
      Result := False;
      exit;
    end;
    Dx := X - V1.X; Dy := Y - V1.Y;
    if Dx*Dx + Dy*Dy < 1E-10 then
    begin
      Result := False;
      exit;
    end;
    Result := True;
    Angle := ArcTan2(Dy, Dx) - ABase;
    if Angle < 0 then Angle := Angle + 2 * pi;
  end;
// main
begin
  if Idx2 - Idx1 <= 1 then exit;

  // Two endpoint vertices
  V1 := FVertices[Idx1 mod FVertices.Count];
  V2 := FVertices[Idx2 mod FVertices.Count];
  Dx := V2.X - V1.X;
  Dy := V2.Y - V1.Y;
  if Dx * Dx + Dy * Dy < 1E-10 then
    exit;
  ABase := ArcTan2(Dy, Dx);

  // Find smallest angle on interval
  IdxM := Idx1 + 1;
  AMin := pi + 1;
  for i := Idx1 + 1 to Idx2 - 1 do
  begin
    Res := AngleForIdx(i, A);
    if Res and (A < AMin) then
    begin
      IdxM := i;
      AMin := A;
    end;
  end;
  if AMin > pi then exit;
  VM := FVertices[IdxM mod FVertices.Count];

  // Check this point; it should yield a correct circle
  RSqr := CalculateCircle(VM.X - V1.X, VM.Y - V1.Y, Dx, Dy, Cx, Cy);

  // RSqr should be larger as our limit
  if RSqr < FRadius * FRadius then
    exit;

  // Center should be on outside
  if Cx * Dy - Cy * Dx < 0 then exit;

  // OK, valid new hull point. Call recursively on subsegments
  FVertices[IdxM mod FVertices.Count].FIsHull := True;
  CheckHullInterval(Idx1, IdxM);
  CheckHullInterval(IdxM, Idx2);
end;

procedure TsdAlphaScan.Clear;
begin
  FVertices.Clear;
  FVertices.Sorted := False;
end;

constructor TsdAlphaScan.Create;
begin
  inherited Create;
  FVertices := TsdRadialVertex2DList.Create(True);// we own em
  FVertices.Sorted := False;
  FHullPts := TsdRadialVertex2DList.Create(False);
  FHullPts.Sorted := False;
end;

destructor TsdAlphaScan.Destroy;
begin
  FreeAndNil(FVertices);
  FreeAndNil(FHullPts);
  inherited;
end;

procedure TsdAlphaScan.DoScanOutside;
var
  i, Idx, Idx1, Idx2: integer;
  V, V1, V2: TsdVertex2D;
  X, Y, X1, Y1, X2, Y2, CP: double;
  HasDeletes: boolean;
  // local
  procedure DoDelete;
  begin
    // Arriving here means we must remove the next point. Take special care
    // in case Idx1 < Idx, in that case an item before us was deleted and we
    // must step back.
    FHullPts.Delete(Idx1);
    if Idx1 < Idx then dec(Idx);
    HasDeletes := True;
  end;
// main
begin
  // Radially sort the vertices
  FVertices.Sort;

  // copy to hullpts
  FHullPts.Clear;
  for i := 0 to FVertices.Count - 1 do
    FHullPts.Add(FVertices[i]);

  // Create a vertex hull first
  repeat
    HasDeletes := False;
    Idx := 0;
    while (FHullPts.Count > 3) and (Idx < FHullPts.Count) do
    begin
      Idx1 := (Idx + 1) mod FHullPts.Count;
      Idx2 := (Idx + 2) mod FHullPts.count;
      V := FHullPts[Idx];
      V1 := FHullPts[Idx1];
      V2 := FHullPts[Idx2];

      // X,Y is base point, X1,Y1 is base->vertex1, X2,Y2 is base->vertex2
      X := V.X;
      Y := V.Y;
      X1 := V1.X - X;
      Y1 := V1.Y - Y;
      X2 := V2.X - X;
      Y2 := V2.Y - Y;


      // Cross product X2>X1
      CP := X2 * Y1 - Y2 * X1;
      if CP < 0 then
      begin
        // the next point belongs in the set (part of convex hull from our view)
        inc(Idx);
        continue;
      end else
      begin
        DoDelete;
        continue;
      end;

    end;
  until (not HasDeletes) or (FHullPts.Count <= 3);

  // Now we have our convex hull
  for i := 0 to FHullPts.Count - 1 do
    FHullPts[i].FIsHull := True;

  if not FHullPts.Count >= 3 then
    exit;

  // Run the algo over the vertex list and check the hull intervals. This will
  // add points that are not strictly hull points but abide the scan criterium
  Idx1 := 0;
  while not FVertices[Idx1 mod FVertices.Count].FIsHull do
    inc(Idx1);
  repeat
    Idx2 := Idx1 + 1;
    while not FVertices[Idx2 mod FVertices.Count].FIsHull do
      inc(Idx2);
    CheckHullInterval(Idx1, Idx2);
    Idx1 := Idx2;
  until Idx1 >= FVertices.Count;

  // Delete any that are not "hull" points
  for i := FVertices.Count - 1 downto 0 do
    if not FVertices[i].FIsHull then FVertices.Delete(i);
end;

{ TsdRadialVertex2D }

function TsdRadialVertex2D.GetTriangle: TsdTriangle2D;
begin
  Result := nil;
end;

procedure TsdRadialVertex2D.SetTriangle(const Value: TsdTriangle2D);
begin
  // does nothing
end;

end.

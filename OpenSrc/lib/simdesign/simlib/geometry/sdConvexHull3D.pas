unit sdConvexHull3D;

interface

uses
  Classes, sdTriMesh3D, sdPoints3D;

type

  TsdConvexHull3D = class(TPersistent)
  private
    FMesh: TsdTriMesh3D;
    // Add a new segment in the hull, using vertices with Idx1, Idx2, Idx3
    procedure AddSegment(Idx1, Idx2, Idx3: integer);
    // Is the vertex AVertex above the plane V1-V2-V3?
    function IsAbovePlane(const V1, V2, V3, AVertex: TsdVertex3D): boolean;
    // Does AVertex violate ASegment (outside of it?)
    function SegmentViolated(ASegment: TsdSegment3D; AVertex: TsdVertex3D): boolean;
    // Add a new vertex to the hull. This updates the hull segments if the
    // vertex falls outside of them
    procedure AddVertexToHull(AVertex: TsdVertex3D);
  public
    procedure MakeConvexHull(AMesh: TsdTriMesh3D);
  end;

implementation

type
  TMeshAccess = class(TsdTriMesh3D);

{ TsdConvexHull3D }

procedure TsdConvexHull3D.AddSegment(Idx1, Idx2, Idx3: integer);
var
  S: TsdSegment3D;
begin
  S := TMeshAccess(FMesh).NewSegment;
  S.VertexCount := 3;
  S.Vertices[0] := FMesh.Vertices[Idx1];
  S.Vertices[1] := FMesh.Vertices[Idx2];
  S.Vertices[2] := FMesh.Vertices[Idx3];
  FMesh.Segments.Add(S);
end;

procedure TsdConvexHull3D.AddVertexToHull(AVertex: TsdVertex3D);
var
  i, Idx, Count: integer;
  S, S1, S2: TsdSegment3D;
  IdxFirst, IdxLast: integer;
{  procedure DeleteSegmentRange(AStart, ACount: integer);
  begin
    // Deleting a segment range is a bit tricky, since the range can wrap around in the list
    while ACount > 0 do begin
      // We delete segments at AStart until that's at the end of the list, else
      // we delete from the 0 position of the list
      if AStart < FMesh.Segments.Count then
        FMesh.Segments.Delete(AStart)
      else
        FMesh.Segments.Delete(0);
      dec(ACount);
    end;
  end;}
begin
{  // init
  Count := FMesh.Segments.Count;
  IdxFirst := -1;
  IdxLast := -1;

  // Loop through all segments, and find first and last that are violated
  for i := 0 to Count - 1 do begin
    S := FMesh.Segments[i];
    if SegmentViolated(S, AVertex) then begin
      // OK, this segment isn't abided..
      IdxFirst := i;
      IdxLast := i;
      // Find first one
      if i = 0 then begin
        Idx := Count - 1;
        S := FMesh.Segments[Idx];
        while SegmentViolated(S, AVertex) do begin
          dec(Idx);
          S := FMesh.Segments[Idx];
        end;
        IdxFirst := (Idx + 1) mod Count;
      end;
      // Find last one
      Idx := i + 1;
      S := FMesh.Segments[Idx mod Count];
      while SegmentViolated(S, AVertex) do begin
        inc(Idx);
        S := FMesh.Segments[Idx mod Count];
      end;
      IdxLast := Idx - 1;
      // Make sure to have a positive delta idx
      if IdxLast < IdxFirst then inc(IdxLast, Count);
      break;
    end;
  end;

  // The vertex fell within all segments, so it's already in the hull -> we can stop
  if IdxFirst = -1 then exit;

  if IdxFirst = IdxLast then begin
    // If first and last indices are equal, we must split up the segment
    S1 := FMesh.Segments[IdxFirst];
    S2 := TMeshAccess(FMesh).NewSegment;
    S2.Vertex1 := AVertex;
    S2.Vertex2 := S1.Vertex2;
    S1.Vertex2 := AVertex;
    FMesh.Segments.Insert(IdxFirst + 1, S2);
  end else begin
    // Otherwise we move first segment's endpoint and last segment's startpoint
    // to the vertex, and remove intermediate segments
    S1 := FMesh.Segments[IdxFirst];
    S2 := FMesh.Segments[IdxLast mod Count];
    S1.Vertex2 := AVertex;
    S2.Vertex1 := AVertex;
    Count := IdxLast - IdxFirst - 1;
    if Count > 0 then
      DeleteSegmentRange(IdxFirst + 1, Count);
  end;}
end;

function TsdConvexHull3D.IsAbovePlane(const V1, V2, V3, AVertex: TsdVertex3D): boolean;
begin
{  Result := CrossProduct2D(Delta2D(V1.Point^, AVertex.Point^), Delta2D(V1.Point^, V2.Point^)) > 0;
}
end;

procedure TsdConvexHull3D.MakeConvexHull(AMesh: TsdTriMesh3D);
var
  i: integer;
begin
{  if not assigned(AMesh) then exit;
  FMesh := AMesh;

  // Start by clearing the segments
  FMesh.Segments.Clear;

  // We need at least 3 vertices
  if FMesh.Vertices.Count < 3 then exit;

  // Build initial 3 segments
  if IsLeftOfLine(FMesh.Vertices[0], FMesh.Vertices[1], FMesh.Vertices[2]) then begin
    // vertex 0, 1, 2 counterclockwise
    AddSegment(0, 1);
    AddSegment(1, 2);
    AddSegment(2, 0);
  end else begin
    // vertex 0, 1, 2 clockwise, so add 0-2, 2-1 and 1-0
    AddSegment(0, 2);
    AddSegment(2, 1);
    AddSegment(1, 0);
  end;

  // Now add each of the other vertices in turn to the hull
  for i := 3 to FMesh.Vertices.Count - 1 do
    AddVertexToHull(FMesh.Vertices[i]);}
end;

function TsdConvexHull3D.SegmentViolated(ASegment: TsdSegment3D; AVertex: TsdVertex3D): boolean;
begin
  Result := IsAbovePlane(ASegment.Vertices[0], ASegment.Vertices[1], ASegment.Vertices[2], AVertex);
end;

end.


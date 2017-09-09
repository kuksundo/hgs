unit sdLines3D;
{
  Description:

  Tools for line and contour creation.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 26Feb2003

  Modifications:

  copyright (c) 2002 - 2005 SimDesign B.V.
}

interface

uses
  Classes, sdSortedLists, sdPoints3D, Math;

type

  // simple 3D vertex
  TsdVertex3D = class(TPersistent)
  private
    FX: double;
    FY: double;
    FZ: double;
    function GetAsPoint: TsdPoint3D;
    procedure SetAsPoint(const Value: TsdPoint3D);
  public
    procedure Assign(Source: TPersistent); override;
    property X: double read FX write FX;
    property Y: double read FY write FY;
    property Z: double read FZ write FZ;
    property AsPoint: TsdPoint3D read GetAsPoint write SetAsPoint;
  end;

  TsdVertex3DClass = class of TsdVertex3D;

  // List of TsdVertex3D
  TsdVertex3DList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TsdVertex3D;
  public
    function VertexClass: TsdVertex3DClass; virtual;
    // *copy* the vertex objects, by creating new objects of VertexClass and
    // assigning the ones from AList to them
    procedure CopyFrom(AList: TsdVertex3DList);
    // Retrieve ACount values of the XYZ data, and put the result in the
    // arrays pointed to by XFirst, YFirst and ZFirst. If ACount larger than our count,
    // we only send out our count values. If smaller, we limit to ACount.
    procedure GetXYZData(XFirst, YFirst, ZFirst: PDouble; ACount: integer);
    property Items[Index: integer]: TsdVertex3D read GetItems; default;
  end;

  TBooleanArray = array[0..MaxInt div SizeOf(boolean) - 1] of boolean;
  PBooleanArray = ^TBooleanArray;

  TsdDynArrayOfTsdPoint3D = array of TsdPoint3D;

  // Include function used as callback in routines
  TsdIncludeFunc = function(Index: integer; const Info: pointer): boolean;

// Returns the square of the minimum distance of P to line P1-P2.
function PointToLineDist3DSqr(const P, P1, P2: TsdPoint3D): double;

// Project point P on line P1, P2. If P is beyond the endpoints, it will be
// set to the closest endpoint.
function ProjectPointOnLine3D(const P, P1, P2: TsdPoint3D): TsdPoint3D;

{ PolySimplify3D:
  Approximates the polyline with 3D float vertices in Orig, with a simplified
  version that will be returned in Simple. The maximum deviation from the
  original line is given in Tol.

  Input:  Tol         = approximation tolerance (defaults to 1E-4)
          Source      = pointer to polyline array of vertex points
          SourceCount = number of points in Source
          Closed      = indicates if the polyline should be treated as closed
  Output: Dest        = Pointer to array with simplified polyline vertices. This array must initially
                        have the same length as Source, or can be equal to Source
          DestCount   = number of points in Dest

  This is the 3D version of the famous Douglas-Peucker line simplification algorithm.

}
procedure PolySimplify3D(Source, Dest: PsdPoint3DArray; SourceCount: integer;
  var DestCount: integer; Closed: boolean; const Tol: double = 1E-4);

// Offset a polygon in the direction perpendicular to the line direction and normal
// of each point. The line segments are offsetted over a distance of Offset.
procedure PolyOffset3D(Source, Normals, Dest: PsdPoint3DArray; SourceCount: integer;
  Offset: double; Closed: boolean);

// Find the closest point in an array of points to Center. The function returns
// the index of the closest point. Provide a StartIdx if the list is ordered to
// increase efficiency. Default it will use 0. This is an O(N) search since
// no assumptions are made about the ordering in the array.
// Set IncludeFunc if you want to add additional tests, and pass any info required
// for this function in IncludeInfo. If there's no closest point (this can happen
// if IncludeFunc always returns false, or there are no points) then the result
// of the function will be -1.
function ClosestPointInArray3D(const Center: TsdPoint3D; Points: PsdPoint3DArray;
  PointCount: integer; const StartIdx: integer = 0; IncludeFunc: TsdIncludeFunc = nil;
  const IncludeInfo: pointer = nil): integer;

// Find the closest point on the curve, this function can also return a point which
// is not one of the vertices. The curve is assumed to be closed
function ClosestPointOnCurve3D(const Center: TsdPoint3D; AFirst: PsdPoint3D; ACount: integer): TsdPoint3D;

// PolyAlphaScan3D is an "anti-looping" tool that scans the inward contour around Center of
// the contour in Source. For each point it finds points in the neighbourhood within
// radius Alpha and takes the most innerbound point each time. Whenever there is
// no point available it will take as next point the closest point. Normal is a
// suitable direction that is approximately perpendicular to a plane through the
// points (use PlaneFit in sdMesh to find it).
// Dest will contain the alpha-scanned contour, Destcount will contain the number
// of points in Dest. Make sure to initialize Dest to an array of the same size
// as SourceCount.
//
// PolyAlphaScan3D can be used on data from scanner sources which contain no structure
// and noise. The points in Source should however describe a contour (not a surface)
// on a relatively flat plane.
//
// PolyAlphaScan3D delivers the inner contour of the pointset, in a clockwise
// direction seen along the normal (so anti-clockwise when looking down on it)
procedure PolyAlphaScan3D(Source, Dest: PsdPoint3Darray; SourceCount: integer;
  var DestCount: integer; Alpha: double; const Center, Normal: TsdPoint3D);

// Like PolyAlphaScan3D but delivering outer polyline in clockwise direction along
// normal
procedure OuterAlphaScan3D(Source, Dest: PsdPoint3Darray; SourceCount: integer;
  var DestCount: integer; Alpha: double; const Center, Normal: TsdPoint3D);

procedure IntersectPolyAndPlane(Poly: PsdPoint3DArray; PolyCount: integer;
  const PlaneNormal: TsdPoint3D; const PlaneOffset: double;
  var Intersections: TsdDynArrayOfTsdPoint3D);

implementation

{ TsdVertex3D }

procedure TsdVertex3D.Assign(Source: TPersistent);
begin
  if Source is TsdVertex3D then
  begin
    FX := TsdVertex3D(Source).FX;
    FY := TsdVertex3D(Source).FY;
    FZ := TsdVertex3D(Source).FZ;
  end else
    inherited;
end;

function TsdVertex3D.GetAsPoint: TsdPoint3D;
begin
  Result.X := FX;
  Result.Y := FY;
  Result.Z := FZ;
end;

procedure TsdVertex3D.SetAsPoint(const Value: TsdPoint3D);
begin
  FX := Value.X;
  FY := Value.Y;
  FZ := Value.Z;
end;

{ TsdVertex3DList }

procedure TsdVertex3DList.CopyFrom(AList: TsdVertex3DList);
var
  i: integer;
  V: TsdVertex3D;
begin
  Clear;
  for i := 0 to AList.Count - 1 do
  begin
    V := AList.VertexClass.Create;
    V.Assign(AList[i]);
    Add(V);
  end;
end;

function TsdVertex3DList.GetItems(Index: integer): TsdVertex3D;
begin
  Result := Get(Index);
end;

procedure TsdVertex3DList.GetXYZData(XFirst, YFirst, ZFirst: PDouble; ACount: integer);
var
  i: integer;
  V: TsdVertex3D;
begin
  if ACount > Count then
    ACount := Count;

  for i := 0 to ACount - 1 do
  begin
    V := Items[i];
    XFirst^ := V.X;
    YFirst^ := V.Y;
    ZFirst^ := V.Z;
    inc(XFirst);
    inc(YFirst);
    inc(ZFirst);
  end;
end;

function TsdVertex3DList.VertexClass: TsdVertex3DClass;
begin
  Result := TsdVertex3D;
end;

{ procedures }

function PointToLineDist3DSqr(const P, P1, P2: TsdPoint3D): double;
var
  q: double;
  Pq: TsdPoint3D;
begin
  // Point-Line distance
  if PtsEqual3D(P1, P2) then begin

    // Point to point
    Result := SquaredDist3D(P, P1);
    exit;

  end;

  // Minimum
  q := ((P.X - P1.X) * (P2.X - P1.X) + (P.Y - P1.Y) * (P2.Y - P1.Y) + (P.Z - P1.Z) * (P2.Z - P1.Z)) /
       (sqr(P2.X - P1.X) + sqr(P2.Y - P1.Y) + sqr(P2.Z - P1.Z));

  // Limit q to 0 <= q <= 1
  if q < 0 then q := 0;
  if q > 1 then q := 1;

  // Distance
  Interpolation3D(P1, P2, q, Pq);
  Result := SquaredDist3D(P, Pq);

end;

function ProjectPointOnLine3D(const P, P1, P2: TsdPoint3D): TsdPoint3D;
var
  q: double;
begin
  // Point-Line distance
  if PtsEqual3D(P1, P2) then begin

    // Point to point
    Result := P1;
    exit;

  end;

  // Minimum
  q := ((P.X - P1.X) * (P2.X - P1.X) + (P.Y - P1.Y) * (P2.Y - P1.Y) + (P.Z - P1.Z) * (P2.Z - P1.Z)) /
       (sqr(P2.X - P1.X) + sqr(P2.Y - P1.Y) + sqr(P2.Z - P1.Z));

  // Limit q to 0 <= q <= 1
  if q < 0 then q := 0;
  if q > 1 then q := 1;

  // Distance
  Interpolation3D(P1, P2, q, Result);
end;

procedure PolySimplify3D(Source, Dest: PsdPoint3DArray; SourceCount: integer;
  var DestCount: integer; Closed: boolean; const Tol: double = 1E-4);
var
  i: integer;
  Marker: array of boolean;
  Tol2: double;

  // local recursive procedure
  procedure SimplifySegment3D(j, k: integer);
  // Simplify polyline in Source between j and k. Marker[] will be set to True
  // for each point that must be included
  var
    i, MaxI: integer; // Index at maximum value
    MaxD2: double;    // Maximum value squared
    CU, CW, B: double;
    DV2: double;
    P0, P1, PB, U, W: TsdPoint3D;
  begin
    // Is there anything to simplify?
    if k <= j + 1 then
      exit;

    P0 := Source[j];
    P1 := Source[k mod SourceCount]; // make sure to access first element if k = SourceCount
    SubstractPoint3D(P1, P0, U); // Segment vector
    CU := SquaredLength3D(U); // Segment length squared
    MaxD2 := 0;
    MaxI  := 0;

    // Loop through points and detect the one furthest away
    for i := j + 1 to k - 1 do
    begin
      SubstractPoint3D(Source[i], P0, W);
      CW := DotProduct3D(W, U);

      // Distance of point Source[i] from segment
      if CW <= 0 then
      begin
        // Before segment
        DV2 := SquaredDist3D(Source[i], P0)
      end else
      begin
        if CW > CU then
        begin
          // Past segment
          DV2 := SquaredDist3D(Source[i], P1);
        end else
        begin
          // Fraction of the segment
          if abs(CU) > 1E-12 then
            B := CW / CU
          else
            B := 0; // in case CU = 0

          AddScalePoint3D(P0, PB, U, B);
          DV2 := SquaredDist3D(Source[i], PB);
        end;
      end;

      // test with current max distance squared
      if DV2 > MaxD2 then
      begin
        // Orig[i] is a new max vertex
        MaxI  := i;
        MaxD2 := DV2;
      end;
    end;

    // If the furthest point is outside tolerance we must split
    if MaxD2 > Tol2 then
    begin // error is worse than the tolerance

      // split the polyline at the farthest vertex from S
      Marker[MaxI] := True;  // mark Orig[maxi] for the simplified polyline

      // recursively simplify the two subpolylines at Orig[maxi]
      SimplifySegment3D(j, MaxI); // polyline Orig[j] to Orig[maxi]
      SimplifySegment3D(MaxI, k); // polyline Orig[maxi] to Orig[k]
    end;
  end;

// main
begin
  DestCount := 0;
  if SourceCount < 2 then
  begin
    // Special case length 1: preserve point
    if SourceCount = 1 then
    begin
      Dest^ := Source^;
      DestCount := 1;
    end;
    exit;
  end;
  Tol2 := sqr(Tol);

  // Create a marker array
  SetLength(Marker, SourceCount);

  // Include first point
  Marker[0] := True;

  // Simplify
  if Closed then

    SimplifySegment3D(0, SourceCount)

  else
  begin

    // include last point if not closed
    Marker[SourceCount - 1] := True;
    SimplifySegment3D(0, SourceCount - 1);

  end;

  // Copy to resulting list
  for i := 0 to SourceCount - 1 do
  begin

    if Marker[i] then
    begin
      Dest[DestCount] := Source[i];
      inc(DestCount);
    end;

  end;
end;

procedure PolyOffset3D(Source, Normals, Dest: PsdPoint3DArray; SourceCount: integer;
  Offset: double; Closed: boolean);
var
  i, Start, Close: integer;
  Tangents: array of TsdPoint3D;
  D1, D2, Src: TsdPoint3D;
  F: double;
begin
  // Calculate all tangents
  SetLength(Tangents, SourceCount);
  for i := 0 to SourceCount - 1 do
    NormalizedDelta3D(Source[i], Source[(i + 1) mod SourceCount], Tangents[i]);

  // Process each vertex; if closed we process the endpoints separately
  if Closed then
  begin
    Start := 0;
    Close := SourceCount;
  end else
  begin
    Start := 1;
    Close := SourceCount - 1;
  end;

  for i := Start to Close - 1 do
  begin
    // vector pointing in direction of offset for each edge
    CrossProduct3D(Tangents[(i + SourceCount - 1) mod SourceCount], Normals[i], D1);
    CrossProduct3D(Tangents[i]                                    , Normals[i], D2);
    NormalizeVector3D(D1);
    NormalizeVector3D(D2);

    Src := Source[i];// protect for in-place
    AddPoint3D(D1, D2, Dest[i]);
    // Limit miter to 100
    F := 2 / Max(0.0004, SquaredLength3D(Dest[i]));
    // Determine miter point
    AddScalePoint3D(Src, Dest[i], Dest[i], F * Offset);
  end;

  // Start and close offsets
  if not Closed then
  begin
    // Start
    CrossProduct3D(Tangents[0], Normals[0], D1);
    NormalizeVector3D(D1);
    AddScalePoint3D(Source[0], Dest[0], D1, Offset);
    // Close
    CrossProduct3D(Tangents[SourceCount - 2], Normals[SourceCount - 1], D1);
    NormalizeVector3D(D1);
    AddScalePoint3D(Source[SourceCount - 1], Dest[SourceCount - 1], D1, Offset);
  end;
end;

function ClosestPointInArray3D(const Center: TsdPoint3D; Points: PsdPoint3DArray;
  PointCount: integer; const StartIdx: integer; IncludeFunc: TsdIncludeFunc;
  const IncludeInfo: pointer): integer;
var
  i: integer;
  P: PsdPoint3D;
  DistT, ADistT, DistSq, ADistSq, Dx, Dy, Dz: double;
begin
  // First loop: find smallest taxicab distance
  DistT := 1E100; // start big
  Result := -1;
  for i := StartIdx to StartIdx + PointCount - 1 do
  begin
    P := @Points[i mod PointCount];
    Dx := abs(P.X - Center.X);
    if Dx >= DistT then
      continue;
    Dy := abs(P.Y - Center.Y);
    if Dy >= DistT then
      continue;
    Dz := abs(P.Z - Center.Z);
    if Dz >= DistT then
      continue;
    ADistT := Dx + Dy + Dz;

    if ADistT < DistT then
    begin
      // include function
      if assigned(IncludeFunc) and not IncludeFunc(i mod PointCount, IncludeInfo) then continue;
      DistT := ADistT;
      Result := i mod PointCount;
    end;
  end;

  // Second loop: start off with the distance found, use DistT and DistSq
  if Result < 0 then
    exit;
  DistSq := SquaredDist3D(Points[Result], Center);
  for i := StartIdx to StartIdx + PointCount - 1 do
  begin
    // Taxicab distance test
    P := @Points[i mod PointCount];
    Dx := abs(P.X - Center.X);
    if Dx >= DistT then
      continue;
    Dy := abs(P.Y - Center.Y);
    if Dy >= DistT then
      continue;
    Dz := abs(P.Z - Center.Z);
    if Dz >= DistT then
      continue;
    if Dx + Dy + Dz >= DistT then
      continue;

    // Squared distance test
    ADistSq := Dx * Dx + Dy * Dy + Dz * Dz;
    if ADistSq < DistSq then
    begin
      if assigned(IncludeFunc) and not IncludeFunc(i mod PointCount, IncludeInfo) then continue;
      DistSq := ADistSq;
      Result := i mod PointCount;
    end;
  end;
end;

function ClosestPointOnCurve3D(const Center: TsdPoint3D; AFirst: PsdPoint3D; ACount: integer): TsdPoint3D;
// Find the closest point on the curve, this function can also return a point which
// is not one of the vertices. The curve is assumed to be closed
var
  i: integer;
  P1, P2: PsdPoint3D;
  P: TsdPoint3D;
  DistSqr, D: double;
begin
  P1 := AFirst;
  P2 := AFirst; inc(P2, ACount - 1);
  Result := ProjectPointOnLine3D(Center, P1^, P2^);
  DistSqr := SquaredDist3D(Center, Result);
  for i := ACount - 2 downto 0 do
  begin
    // Next segment
    P1 := P2;
    dec(P2);
    // Find closest point on this segment, and squared distance to it
    P := ProjectPointOnLine3D(Center, P1^, P2^);
    D := SquaredDist3D(Center, P);

    // Closer than before?
    if D < DistSqr then
    begin
      DistSqr := D;
      Result := P;
    end;
  end;
end;

function IsNotInMarker(Index: integer; const Info: pointer): boolean;
begin
  if PBooleanArray(Info)[Index] then
    Result := False
  else
    Result := True;
end;

procedure PolyAlphaScan3D(Source, Dest: PsdPoint3Darray; SourceCount: integer;
  var DestCount: integer; Alpha: double; const Center, Normal: TsdPoint3D);
var
  i, Idx, Iter: integer;
  Marker: array of boolean;
  Search, DirVec, InclVec: TsdPoint3D;
  Enclosed: array of integer;
  EnclosedCount: integer;
  P, S: PsdPoint3D;
  Incl: TsdPoint3D;
  Incline, AIncline, TempAlpha, ConeAngle: double;

  // local
  procedure AddPoint;
  begin
    Marker[Idx] := True;
    S := @Source[Idx];
    Dest[DestCount] := S^;
    inc(DestCount);
  end;

  // local
  procedure PointsWithinDistanceAndCone;
  var
    i: integer;
    CosCone: double;
  begin
    EnclosedCount := 0;
    CosCone := -cos(ConeAngle);
    for i := 0 to SourceCount - 1 do
    begin
      if Marker[i] then
        continue;

      // Check distance
      if CompareDist3D(Source[i], S^, TempAlpha) then
      begin
        // Check cone
        NormalizedDelta3D(S^, Source[i], Incl);
        if DotProduct3D(Search, Incl) >  CosCone then
        begin
          // The point lies within the distance Alpha
          if length(Enclosed) = EnclosedCount then
            SetLength(Enclosed, EnclosedCount + 10);
          Enclosed[EnclosedCount] := i;
          inc(EnclosedCount);
        end;
      end;
    end;
  end;

// main
begin
  // Find suitable start point: this is the closest point
  Idx := ClosestPointInArray3D(Center, Source, SourceCount);
  if Idx < 0 then
    exit;

  // Prepare
  DestCount := 0;
  SetLength(Marker, SourceCount);

  // Add to Dest
  AddPoint;

  // Initial search direction, turning left from Source[Idx], seen from Center
  CrossProduct3D(Normal, Delta3D(Center, S^), Search);
  NormalizeVector3D(Search);
  repeat

    // Progressive Alpha and shrinking cone angle
    TempAlpha := Alpha;
    ConeAngle := pi / 2;
    Iter := 0;
    repeat

      // Find points within distance of current point
      PointsWithinDistanceAndCone;

      // Do we have any enclosed points?
      if EnclosedCount > 0 then
      begin

        // From these, find the one that is most inclined towards the left (center)
        Incline := -2; // a value smaller than reachable
        for i := 0 to EnclosedCount - 1 do
        begin
          P := @Source[Enclosed[i]];
          NormalizedDelta3D(S^, P^, DirVec);
          CrossProduct3D(Search, DirVec, InclVec);
          AIncline := DotProduct3D(Normal, InclVec);
          if AIncline > Incline then
          begin
            Idx := Enclosed[i];
            Incline := AIncline;
            Search := DirVec;
          end;
        end;

        // Add this point
        AddPoint;

        // Throw away all points in Enclosed that are behind this point
        for i := 0 to EnclosedCount - 1 do
        begin
          P := @Source[Enclosed[i]];
          DirVec := Delta3D(S^, P^);
          if DotProduct3D(DirVec, Search) < 0 then
            Marker[Enclosed[i]] := True;
        end;

        // get out of loop
        break;

      end;

      // settings for next loop
      inc(Iter);
      ConeAngle := ConeAngle / 2;
      TempAlpha := TempAlpha * 2;

    until Iter > 3;

    if Iter > 3 then
    begin

      // We have no enclosed points, so do a search for the next closest that
      // abides the criteria.
      Idx := ClosestPointInArray3D(S^, Source, SourceCount, Idx,
        IsNotInMarker, @Marker[0]);
      // No more points? We're done
      if Idx < 0 then
        exit;

      // Sanity check: bridged gap should not exceed 10x tolerance
      if Dist3D(Source[Idx], S^) > 10 * Alpha then
        exit;

      // We found one, we add this point and continue
      NormalizedDelta3D(S^, Source[Idx], Search);
      AddPoint;

    end;

  until False;
end;

procedure OuterAlphaScan3D(Source, Dest: PsdPoint3Darray; SourceCount: integer;
  var DestCount: integer; Alpha: double; const Center, Normal: TsdPoint3D);
var
  i, Idx, Iter: integer;
  Marker: array of boolean;
  Search, DirVec, InclVec: TsdPoint3D;
  Enclosed: array of integer;
  EnclosedCount: integer;
  P, S: PsdPoint3D;
  Incl: TsdPoint3D;
  Incline, AIncline, TempAlpha, ConeAngle, MaxX: double;

  // local
  procedure AddPoint;
  begin
    Marker[Idx] := True;
    S := @Source[Idx];
    Dest[DestCount] := S^;
    inc(DestCount);
  end;

  // local
  procedure PointsWithinDistanceAndCone;
  var
    i: integer;
    CosCone: double;
  begin
    EnclosedCount := 0;
    CosCone := -cos(ConeAngle);
    for i := 0 to SourceCount - 1 do
    begin
      if Marker[i] then
        continue;

      // Check distance
      if CompareDist3D(Source[i], S^, TempAlpha) then
      begin
        // Check cone
        NormalizedDelta3D(S^, Source[i], Incl);
        if DotProduct3D(Search, Incl) >  CosCone then
        begin
          // The point lies within the distance Alpha
          if length(Enclosed) = EnclosedCount then
            SetLength(Enclosed, EnclosedCount + 10);
          Enclosed[EnclosedCount] := i;
          inc(EnclosedCount);
        end;
      end;
    end;
  end;

// main
begin
  // Find suitable start point: this is the point with largest X
  Idx := -1;
  MaxX := -1E100;
  for i := 0 to SourceCount - 1 do
    if Source^[i].X > MaxX then
    begin
      Idx := i;
      MaxX := Source^[i].X;
    end;
  if Idx < 0 then
    exit;

  // Prepare
  DestCount := 0;
  SetLength(Marker, SourceCount);

  // Add to Dest
  AddPoint;

  // Initial search direction, turning left from Source[Idx], seen from Center
  CrossProduct3D(Normal, Delta3D(Center, S^), Search);
  NormalizeVector3D(Search);
  repeat

    // Progressive Alpha and shrinking cone angle
    TempAlpha := Alpha;
    ConeAngle := pi / 2;
    Iter := 0;
    repeat

      // Find points within distance of current point
      PointsWithinDistanceAndCone;

      // Do we have any enclosed points?
      if EnclosedCount > 0 then
      begin

        // From these, find the one that is most inclined towards the right (outward)
        Incline := +2; // a value larger than reachable
        for i := 0 to EnclosedCount - 1 do
        begin
          P := @Source[Enclosed[i]];
          NormalizedDelta3D(S^, P^, DirVec);
          CrossProduct3D(Search, DirVec, InclVec);
          AIncline := DotProduct3D(Normal, InclVec);
          if AIncline < Incline then
          begin
            Idx := Enclosed[i];
            Incline := AIncline;
            Search := DirVec;
          end;
        end;

        // Add this point
        AddPoint;

        // Throw away all points in Enclosed that are behind this point
        for i := 0 to EnclosedCount - 1 do
        begin
          P := @Source[Enclosed[i]];
          DirVec := Delta3D(S^, P^);
          if DotProduct3D(DirVec, Search) < 0 then
            Marker[Enclosed[i]] := True;
        end;

        // get out of loop
        break;

      end;

      // settings for next loop
      inc(Iter);
      ConeAngle := ConeAngle / 2;
      TempAlpha := TempAlpha * 2;

    until Iter > 3;

    if Iter > 3 then
    begin

      // We have no enclosed points, so do a search for the next closest that
      // abides the criteria.
      Idx := ClosestPointInArray3D(S^, Source, SourceCount, Idx,
        IsNotInMarker, @Marker[0]);
      // No more points? We're done
      if Idx < 0 then exit;

      // Sanity check: bridged gap should not exceed 10x tolerance
      if Dist3D(Source[Idx], S^) > 10 * Alpha then
        exit;

      // We found one, we add this point and continue
      NormalizedDelta3D(S^, Source[Idx], Search);
      AddPoint;

    end;

  until False;
end;

procedure IntersectPolyAndPlane(Poly: PsdPoint3DArray; PolyCount: integer;
  const PlaneNormal: TsdPoint3D; const PlaneOffset: double;
  var Intersections: TsdDynArrayOfTsdPoint3D);
var
  i: integer;
  P, Q: PsdPoint3D;
  Cp, Cq: integer;
  Num, Den: double;
  A: double;
  Delta, Inters: TsdPoint3D;
  IntersectionCount: integer;

  // local
  function CompareWithPlane(P: PsdPoint3D): integer;
  var
    Dist: double;
  begin
    Dist := DotProduct3D(P^, PlaneNormal) - PlaneOffset;
    if Dist < 0 then
      Result := -1
    else
      if Dist > 0 then
        Result := 1
      else
        Result := 0;
  end;

// main
begin
  IntersectionCount := 0;

  // Loop through points in the polyline
  for i := 0 to PolyCount - 1 do
  begin

    // Line segment from P to Q
    P := @Poly[i];
    Q := @Poly[(i + 1) mod PolyCount];
    // Points above, equal or below?
    Cp := CompareWithPlane(P);
    Cq := CompareWithPlane(Q);

    // If P above or on, and Q below or P below or on and Q above
    if ((Cp >= 0) and (Cq < 0)) or ((Cp <= 0) and (Cq > 0)) then
    begin

      // we found an intersection, calculate it
      Delta := Delta3D(P^, Q^);
      Num := PlaneOffset - DotProduct3D(PlaneNormal, P^);
      Den := DotProduct3D(PlaneNormal, Delta);

      // avoid parallellism
      if abs(Den) < 1E-12 then
        continue;

      A := Num / Den;
      AddScalePoint3D(P^, Inters, Delta, A);

      // Add the intersection to the list
      // check lenght of list
      if length(Intersections) = IntersectionCount then
        SetLength(Intersections, round(length(Intersections) * 1.5) + 4);
      Intersections[IntersectionCount] := Inters;
      inc(IntersectionCount);
    end;
  end;

  // Adjust length
  SetLength(Intersections, IntersectionCount);
end;

end.

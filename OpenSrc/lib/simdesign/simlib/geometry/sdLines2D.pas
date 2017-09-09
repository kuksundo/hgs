unit sdLines2D;

interface

uses
  Classes, Contnrs, SysUtils, sdPoints2D, Math;

type

  // simple 2D vertex
  TsdVertex2D = class(TPersistent)
  private
    FX: double;
    FY: double;
    function GetAsPoint: TsdPoint2D;
    procedure SetAsPoint(const Value: TsdPoint2D);
  public
    procedure Assign(Source: TPersistent); override;
    property X: double read FX write FX;
    property Y: double read FY write FY;
    property AsPoint: TsdPoint2D read GetAsPoint write SetAsPoint;
  end;

  TsdVertex2DClass = class of TsdVertex2D;

  // List of TsdVertex2D
  TsdVertex2DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdVertex2D;
  public
    function VertexClass: TsdVertex2DClass; virtual;
    // *copy* the vertex objects, by creating new objects of VertexClass and
    // assigning the ones from AList to them
    procedure CopyFrom(AList: TsdVertex2DList);
    // Retrieve ACount values of the XY data, and put the result in the
    // arrays pointed to by XFirst and YFirst. If ACount larger than our count,
    // we only send out our count values. If smaller, we limit to ACount.
    procedure GetXYData(XFirst, YFirst: PDouble; ACount: integer);
    property Items[Index: integer]: TsdVertex2D read GetItems; default;
  end;

  // Polybiezier 2D vertex
  TsdBezierVertex2D = class(TsdVertex2D)
  private
    FIsSmooth: boolean;
  public
    property IsSmooth: boolean read FIsSmooth write FIsSmooth;
  end;

  // List of TsdBezierVertex2D
  TsdBezierVertex2DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdBezierVertex2D;
  public
    property Items[Index: integer]: TsdBezierVertex2D read GetItems; default;
  end;

  // Polybezier segment
  TsdBezierSegment2D = class
  private
    FV1: TsdBezierVertex2D; // reference to V1
    FV2: TsdBezierVertex2D; // reference to V2
    FC1: TsdPoint2D; // controlpoint C1 (owned)
    FC2: TsdPoint2D; // controlpoint C2 (owned)
    FNormal: TsdPoint2D;
  protected
    procedure CalculateNormal;
  public
    // Distance between V1 and V2
    function LineLength: double;
    // Dx/Dy when going from V1 to V2 (not normalized)
    procedure GetSlope(out Dx, Dy: double);
    // Angles A1 and A2 are the angles between V1-C1 and V1-V2 (A1) and
    // V2-C2 and V2-V1 (A2). These angles are given in [deg]
    procedure GetAngles(out A1, A2: double);
    // Get the parameters approximating an arc through this bezier segment,
    // IsArc returns True if the segment should be approximated with an arc,
    // or False if it should be a line. P1 and P2 are begin/end point, Pc is
    // the center point.
    procedure GetArcParams(const AngleTolerance: double; out IsArc, IsClockWise: boolean;
      out P1, P2, Pc: TsdPoint2D);
    property V1: TsdBezierVertex2D read FV1 write FV1;
    property V2: TsdBezierVertex2D read FV2 write FV2;
    property C1: TsdPoint2D read FC1 write FC1;
    property C2: TsdPoint2D read FC2 write FC2;
    // outward normal of line segment
    property Normal: TsdPoint2D read FNormal write FNormal;
  end;

  TsdBezierSegment2DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdBezierSegment2D;
  public
    property Items[Index: integer]: TsdBezierSegment2D read GetItems; default;
  end;

  // Polybezier 2D curve
  TsdPolyBezier2D = class
  private
    FSegments: TsdBezierSegment2DList;
    FVertices: TsdBezierVertex2DList;
    FSmoothingAngle: double;
    FKFactor: double;
  protected
    procedure CalculateNormals;
    // Divide the segment at Index into two parts, and update the lists
    procedure DivideSegment(Index: integer);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    procedure BuildSmoothedBezier(CalculateSmoothing: boolean);
    property Vertices: TsdBezierVertex2DList read FVertices;
    property Segments: TsdBezierSegment2DList read FSegments;
    // Angle limit for which vertices are assumed to be smooth (in degrees)
    property SmoothingAngle: double read FSmoothingAngle write FSmoothingAngle;
    // K-factor which determines where the control points are put. Defaults to
    // 0.25, which means that the control points are at 25% of the line length
    property KFactor: double read FKFactor write FKFactor;
  end;

  // This class will approximate the polybezier with arc and line segments
  TsdPolyArc2D = class(TsdPolyBezier2D)
  private
    FMinimumSegmentLength: double;
    FAngleTolerance: double;
  public
    constructor Create; override;
    // Approximate the bezier curves with arc segments
    procedure Approximate;
    // If segments are shorter than this length they will not be subdivided
    property MinimumSegmentLength: double read FMinimumSegmentLength write FMinimumSegmentLength;
    // If the error due to arc approximation is below AngleTolerance, the segment
    // will be approximated with an arc, otherwise it will be subdivided, or
    // if it is too short, a line will be substituted (specified in degrees).
    property AngleTolerance: double read FAngleTolerance write FAngleTolerance;
  end;

  // Line parameters representing a line with equation Ax + By + C = 0
  TsdLineParams2D = record
    A: double;
    B: double;
    C: double;
  end;

{ procedures }

// Project point P onto the line from P1 to P2. Return the projected point,
// or one of the closest endpoints if the projection is outside the segment
function ProjectPointOnLine2D(const P, P1, P2: TsdPoint2D): TsdPoint2D;

// find the line intersection of lines L1, L2 that are described by
// their line parameters. Intersection point is put in P, and the function
// returns false if the lines are (virtually) parallel.
function LineIntersection2D(const L1, L2: TsdLineParams2D; out P: TsdPoint2D; const Tol: double = 1E-8): boolean;

{ PolySimplify2D:
  Approximates the polyline with 2D float vertices in Orig, with a simplified
  version that will be returned in Simple. The maximum deviation from the
  original line is given in Tol.

  Input:  Tol         = approximation tolerance (defaults to 1E-4)
          Source      = pointer to polyline array of vertex points
          SourceCount = number of points in Source
          Closed      = indicates if the polyline should be treated as closed
  Output: Dest        = Pointer to array with simplified polyline vertices. This array must initially
                        have the same length as Source, or can be equal to Source
          DestCount   = number of points in Dest

  This is the 2D version of the famous Douglas-Peucker line simplification algorithm.

}
procedure PolySimplify2D(Source, Dest: PsdPoint2DArray; SourceCount: integer;
  var DestCount: integer; Closed: boolean; const Tol: double = 1E-4);


{ same as PolySimplify2D, but works on a vertex list. Some differences:
 - No IsClosed parameter, polyline is assumed *not* to be closed
 - YScaleUp: multiplication in Y to make algorithm more sensitive for Y changes
   this parameter defaults to 1.0
}
procedure PolySimplify2DList(AList: TsdVertex2DList; const Tol: double = 1E-4; const YScaleUp: double = 1.0);

implementation

{ TsdVertex2D }

procedure TsdVertex2D.Assign(Source: TPersistent);
begin
  if Source is TsdVertex2D then
  begin
    FX := TsdVertex2D(Source).FX;
    FY := TsdVertex2D(Source).FY;
  end else
    inherited;
end;

function TsdVertex2D.GetAsPoint: TsdPoint2D;
begin
  Result.X := FX;
  Result.Y := FY;
end;

procedure TsdVertex2D.SetAsPoint(const Value: TsdPoint2D);
begin
  FX := Value.X;
  FY := Value.Y;
end;

{ TsdVertex2DList }

procedure TsdVertex2DList.CopyFrom(AList: TsdVertex2DList);
var
  i: integer;
  V: TsdVertex2D;
begin
  Clear;
  for i := 0 to AList.Count - 1 do
  begin
    V := AList.VertexClass.Create;
    V.Assign(AList[i]);
    Add(V);
  end;
end;

function TsdVertex2DList.GetItems(Index: integer): TsdVertex2D;
begin
  Result := Get(Index);
end;

procedure TsdVertex2DList.GetXYData(XFirst, YFirst: PDouble; ACount: integer);
var
  i: integer;
  V: TsdVertex2D;
begin
  if ACount > Count then
    ACount := Count;

  for i := 0 to ACount - 1 do
  begin
    V := Items[i];
    XFirst^ := V.X;
    YFirst^ := V.Y;
    inc(XFirst);
    inc(YFirst);
  end;
end;

function TsdVertex2DList.VertexClass: TsdVertex2DClass;
begin
  Result := TsdVertex2D;
end;

{ TsdBezierVertex2DList }

function TsdBezierVertex2DList.GetItems(Index: integer): TsdBezierVertex2D;
begin
  Result := Get(Index);
end;

{ TsdBezierSegment2D }

procedure TsdBezierSegment2D.CalculateNormal;
var
  Dx, Dy: double;
begin
  if not assigned(V1) or not assigned(V2) then exit;
  Dx := V2.X - V1.X;
  Dy := V2.Y - V1.Y;
  FNormal.X :=  Dy;
  FNormal.Y := -Dx;
  NormalizeVector2D(FNormal);
end;

procedure TsdBezierSegment2D.GetAngles(out A1, A2: double);
var
  P1, P2, D: TsdPoint2D;
  P1C1, C2P2: TsdPoint2D;
begin
  P1.X := V1.X;
  P1.Y := V1.Y;
  P2.X := V2.X;
  P2.Y := V2.Y;
  SubstractPoint2D(P2, P1, D);
  SubstractPoint2D(C1, P1, P1C1);
  SubstractPoint2D(P2, C2, C2P2);
  A1 := AngleBetweenVectors(D, P1C1) * 180 / pi;
  A2 := AngleBetweenVectors(C2P2, D) * 180 / pi;
end;

procedure TsdBezierSegment2D.GetArcParams(const AngleTolerance: double;
  out IsArc, IsClockWise: boolean; out P1, P2, Pc: TsdPoint2D);
var
  A1, A2, Alpha, B: double;
begin
  P1.X := V1.X;
  P1.Y := V1.Y;
  P2.X := V2.X;
  P2.Y := V2.Y;
  Pc.X := 0; // initialize
  Pc.Y := 0;
  GetAngles(A1, A2);
  if abs(A1 - A2) > AngleTolerance then
  begin
    // approximate with line
    IsArc := False;
    exit;
  end;

  // Average angle in [deg]
  Alpha := (A1 + A2) * 0.5;
  if abs(Alpha) < AngleTolerance then
  begin
    IsArc := False;
    exit;
  end;

  // approximate with arc
  IsArc := True;

  IsClockWise := Alpha > 0;

  // We use the midpoint and the normal to construct the center of the
  // arc
  Pc := Midpoint2D(P1, P2);
  B := 0.5 * LineLength / tan(Alpha * (pi/180));
  Pc.X := Pc.X + FNormal.X * B;
  Pc.Y := Pc.Y + FNormal.Y * B;
end;

procedure TsdBezierSegment2D.GetSlope(out Dx, Dy: double);
begin
  if not assigned(V1) or not assigned(V2) then
  begin
    Dx := 0;
    Dy := 0;
  end else
  begin
    Dx := V2.X - V1.X;
    Dy := V2.Y - V1.Y;
  end;
end;

function TsdBezierSegment2D.LineLength: double;
var
  Dx, Dy: double;
begin
  GetSlope(Dx, Dy);
  Result := sqrt(Dx * Dx + Dy * Dy);
end;

{ TsdBezierSegment2DList }

function TsdBezierSegment2DList.GetItems(Index: integer): TsdBezierSegment2D;
begin
  Result := Get(Index);
end;

{ TsdPolyBezier2D }

procedure TsdPolyBezier2D.BuildSmoothedBezier(CalculateSmoothing: boolean);
var
  i, Count: integer;
  Limit, CosVal: double;
  S, S1, S2: TsdBezierSegment2D;
  L, L1, L2: double;
  V: TsdBezierVertex2D;
  Dx, Dy: double;
  Frac: double;
  V1, V2, M: TsdPoint2D;
begin
  // Calculate normals
  CalculateNormals;
  Count := FSegments.Count;
  // Determine smoothed vertices
  if CalculateSmoothing then
  begin
    // Smoothing limit
    Limit := cos(FSmoothingAngle * pi / 180);
    for i := 0 to FVertices.Count - 1 do
    begin
      V := FVertices[i];
      S1 := FSegments[(i + Count - 1) mod Count];
      S2 := FSegments[i mod Count];
      if not assigned(S1) or not assigned(S2) then continue;
      if not ((S1.V2 = V) and (S2.V1 = V)) then continue;
      // normals are already calculated and should be valid
      CosVal := DotProduct2D(S1.FNormal, S2.FNormal);
      // Now determine if the vertex is smooth
      V.IsSmooth := CosVal > Limit;
    end;
  end;
  // First run: all smoothed vertices
  for i := 0 to FVertices.Count - 1 do
  begin
    V := FVertices[i];
    if not V.IsSmooth then continue;
    S1 := FSegments[(i + Count - 1) mod Count];
    S2 := FSegments[i mod Count];
    if not assigned(S1) or not assigned(S2) then continue;
    if not ((S1.V2 = V) and (S2.V1 = V)) then continue;
    if not assigned(S1.V1) or not assigned(S2.V2) then continue;
    // Slope of S1->S2
    Dx := S2.V2.X - S1.V1.X;
    Dy := S2.V2.Y - S1.V1.Y;
    // Length of each segment
    L1 := S1.LineLength;
    L2 := S2.LineLength;
    // Combined length
    L := L1 + L2;
    if L = 0 then continue;
    // Control point S1-C2
    Frac := (L1 / L) * FKFactor;
    S1.FC2.X := V.X - Dx * Frac;
    S1.FC2.Y := V.Y - Dy * Frac;
    // Control point S2-C1
    Frac := (L2 / L) * FKFactor;
    S2.FC1.X := V.X + Dx * Frac;
    S2.FC1.Y := V.Y + Dy * Frac;
  end;
  // Now deal with sharp vertices
  for i := 0 to FSegments.Count - 1 do
  begin
    S := FSegments[i];
    if not assigned(S.V1) or not assigned(S.V2) then continue;

    // Both are smooth? we're already done
    if S.V1.IsSmooth and S.V2.IsSmooth then continue;

    Dx := S.V2.X - S.V1.X;
    Dy := S.V2.Y - S.V1.Y;

    if not S.V1.IsSmooth and not S.V2.IsSmooth then
    begin
      // Both are sharp, so we just put the control points on the line
      S.FC1.X := S.V1.X + Dx * FKFactor;
      S.FC1.Y := S.V1.Y + Dy * FKFactor;
      S.FC2.X := S.V2.X - Dx * FKFactor;
      S.FC2.Y := S.V2.Y - Dy * FKFactor;
      continue;
    end;

    // Midpoint
    V1.X := S.V1.X;
    V1.Y := S.V1.Y;
    V2.X := S.V2.X;
    V2.Y := S.V2.Y;
    M := MidPoint2D(V1, V2);

    if S.V1.IsSmooth and not S.V2.IsSmooth then
      // V1 is smooth, V2 is sharp
      MirrorPointInLine(S.FC1, M, S.Normal, S.FC2);
    if not S.V1.IsSmooth and S.V2.IsSmooth then
      // V1 is sharp, V2 is smooth
      MirrorPointInLine(S.FC2, M, S.Normal, S.FC1);
  end;
end;

procedure TsdPolyBezier2D.CalculateNormals;
var
  i: integer;
begin
  for i := 0 to FSegments.Count - 1 do
    FSegments[i].CalculateNormal;
end;

procedure TsdPolyBezier2D.Clear;
begin
  FVertices.Clear;
  FSegments.Clear;
end;

constructor TsdPolyBezier2D.Create;
begin
  inherited Create;
  FSegments := TsdBezierSegment2DList.Create(True);
  FVertices := TsdBezierVertex2DList.Create(True);
  FSmoothingAngle := 30;
  FKFactor := 0.40;
end;

destructor TsdPolyBezier2D.Destroy;
begin
  FreeAndNil(FSegments);
  FreeAndNil(FVertices);
  inherited;
end;

procedure TsdPolyBezier2D.DivideSegment(Index: integer);
var
  S, SNew: TsdBezierSegment2D;
  VNew: TsdBezierVertex2D;
  V1, V2: TsdPoint2D;
  M1, M2, M3, M11, M12, M22: TsdPoint2D;
begin
  S := Segments[Index];
  if not assigned(S.V1) or not assigned(S.V2) then exit;
  V1.X := S.V1.X;
  V1.Y := S.V1.Y;
  V2.X := S.V2.X;
  V2.Y := S.V2.Y;
  M1 := MidPoint2D(V1, S.C1);
  M2 := MidPoint2D(S.C1, S.C2);
  M3 := MidPoint2D(S.C2, V2);
  M11 := MidPoint2D(M1, M2);
  M22 := MidPoint2D(M2, M3);
  M12 := MidPoint2D(M11, M22);
  SNew := TsdBezierSegment2D.Create;
  VNew := TsdBezierVertex2D.Create;
  // Insert new vertex and segment
  FVertices.Insert(Index + 1, VNew);
  FSegments.Insert(Index + 1, SNew);
  // New vertex
  VNew.X := M12.X;
  VNew.Y := M12.Y;
  VNew.IsSmooth := True;
  // Adapt new and existing segments
  SNew.V1 := VNew;
  SNew.C1 := M22;
  SNew.C2 := M3;
  SNew.V2 := S.V2;
  S.C1 := M1;
  S.C2 := M11;
  S.V2 := VNew;
  // Re-calculate normals
  S.CalculateNormal;
  SNew.CalculateNormal;
end;

{ TsdPolyArc2D }

procedure TsdPolyArc2D.Approximate;
var
  Index: integer;
  S: TsdBezierSegment2D;
  A1, A2: double;
  MustSubdivide: boolean;
begin
  Index := 0;
  while Index < FSegments.Count do
  begin
    S := FSegments[Index];
    // Do we subdivide?
    MustSubdivide := False;
    if S.LineLength > MinimumSegmentLength then
    begin
      S.GetAngles(A1, A2);
      if abs(A1 - A2) > AngleTolerance then
        MustSubdivide := True;
    end;
    if MustSubdivide then
      DivideSegment(Index)
    else
      inc(Index);
  end;
end;

constructor TsdPolyArc2D.Create;
begin
  inherited;
  FMinimumSegmentLength := 0.001; // 1 mm
  FAngleTolerance := 0.9;         // 0.9 deg
end;

procedure PolySimplify2D(Source, Dest: PsdPoint2DArray; SourceCount: integer;
  var DestCount: integer; Closed: boolean; const Tol: double = 1E-4);
var
  i: integer;
  Marker: array of boolean;
  Tol2: double;

  // local recursive procedure
  procedure SimplifySegment2D(j, k: integer);
  // Simplify polyline in Source between j and k. Marker[] will be set to True
  // for each point that must be included
  var
    i, MaxI: integer; // Index at maximum value
    MaxD2: double;    // Maximum value squared
    DV2: double;
    P0, P1: TsdPoint2D;
  begin
    // Is there anything to simplify?
    if k <= j + 1 then
      exit;

    P0 := Source[j];
    P1 := Source[k mod SourceCount]; // make sure to access first element if k = SourceCount
    MaxD2 := 0;
    MaxI  := 0;

    // Loop through points and detect the one furthest away
    for i := j + 1 to k - 1 do
    begin
      // Distance of point i to line
      DV2 := PointToLineDist2DSqr(Source[i], P0, P1);

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
      SimplifySegment2D(j, MaxI); // polyline Orig[j] to Orig[maxi]
      SimplifySegment2D(MaxI, k); // polyline Orig[maxi] to Orig[k]
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

    SimplifySegment2D(0, SourceCount)

  else
  begin

    // include last point if not closed
    Marker[SourceCount - 1] := True;
    SimplifySegment2D(0, SourceCount - 1);

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

{ procedures }

function ProjectPointOnLine2D(const P, P1, P2: TsdPoint2D): TsdPoint2D;
var
  q: double;
begin
  // Point-Line distance
  if PtsEqual2D(P1, P2) then begin

    // Point to point
    Result := P1;
    exit;

  end;

  // Minimum
  q := ((P.X - P1.X) * (P2.X - P1.X) + (P.Y - P1.Y) * (P2.Y - P1.Y)) /
       (sqr(P2.X - P1.X) + sqr(P2.Y - P1.Y));

  // Limit q to 0 <= q <= 1
  if q < 0 then q := 0;
  if q > 1 then q := 1;

  // Distance
  Interpolation2D(P1, P2, q, Result);
end;

function LineIntersection2D(const L1, L2: TsdLineParams2D; out P: TsdPoint2D; const Tol: double = 1E-8): boolean;
var
  Mul, ARes, BRes, CRes: double;
  // local
  function AlmostEqual(A, B: double): boolean;
  begin
    Result := abs(A - B) < Tol;
  end;
// main
begin
  Result := True;
  if not AlmostEqual(L1.A, L2.A) and not AlmostEqual(L1.A, 0) and not AlmostEqual(L2.A, 0) then
  begin
    // solve for Y
    Mul :=  L1.A / L2.A;
    BRes := L1.B - L2.B * Mul;
    CRes := L1.C - L2.C * Mul;
    P.Y := -CRes / BRes;
    P.X := (-L1.B * P.Y - L1.C) / L1.A;
  end else if not AlmostEqual(L1.B, L2.B) and not AlmostEqual(L1.B, 0) and not AlmostEqual(L2.B, 0) then
  begin
    // solve for X
    Mul :=  L1.B / L2.B;
    ARes := L1.A - L2.A * Mul;
    CRes := L1.C - L2.C * Mul;
    P.X := -CRes / ARes;
    P.Y := (-L1.A * P.X - L1.C) / L1.B;
  end else
  begin
    // Lines degenerate or parallel
    Result := False;
    P.X := 0;
    P.Y := 0;
  end;
end;

// same as PolySimplify2D, but works on a vertex list.
procedure PolySimplify2DList(AList: TsdVertex2DList; const Tol: double = 1E-4; const YScaleUp: double = 1.0);
var
  i: integer;
  Marker: array of boolean;
  Tol2: double;

  // local recursive procedure
  procedure SimplifySegment2D(j, k: integer);
  // Simplify polyline in Source between j and k. Marker[] will be set to True
  // for each point that must be included
  var
    i, MaxI: integer; // Index at maximum value
    MaxD2: double;    // Maximum value squared
    DV2: double;
    P0, P1, PIdx: TsdPoint2D;
  begin
    // Is there anything to simplify?
    if k <= j + 1 then
      exit;

    P0 := AList[j].AsPoint;
    P0.Y := P0.Y * YScaleUp;

    // make sure to access first element if k = SourceCount
    P1 := AList[k mod AList.Count].AsPoint;
    P1.Y := P1.Y * YScaleUp;

    MaxD2 := 0;
    MaxI  := 0;

    // Loop through points and detect the one furthest away
    for i := j + 1 to k - 1 do
    begin
      PIdx := AList[i].AsPoint;
      PIdx.Y := PIdx.Y * YScaleUp;

      // Distance of point i to line
      DV2 := PointToLineDist2DSqr(PIdx, P0, P1);

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
    begin
      // error is worse than the tolerance

      // split the polyline at the farthest vertex from S
      Marker[MaxI] := True;  // mark Orig[maxi] for the simplified polyline

      // recursively simplify the two subpolylines at Orig[maxi]
      SimplifySegment2D(j, MaxI); // polyline Orig[j] to Orig[maxi]
      SimplifySegment2D(MaxI, k); // polyline Orig[maxi] to Orig[k]
    end;
  end;

// main
begin
  if AList.Count <= 2 then
    exit;
  Tol2 := sqr(Tol);

  // Create a marker array
  SetLength(Marker, AList.Count);

  // Include first point
  Marker[0] := True;

  // Simplify, include last point if not closed
  Marker[AList.Count - 1] := True;
  SimplifySegment2D(0, AList.Count - 1);

  // Build resulting list
  for i := AList.Count - 1 downto 0 do
  begin

    if not Marker[i] then
      AList.Delete(i);

  end;
end;

end.

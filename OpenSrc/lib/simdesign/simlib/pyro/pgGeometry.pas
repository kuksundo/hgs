{ Project: Pyro
  Module: Pyro Render

  Description:
    This unit provides lowlevel geometrical routines for shapes like beziers/ellipses,
    and provides simplified transforms (xforms) without needing to include the
    document-aware and heavy pgTransform unit.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgGeometry;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, Pyro;

type

  TpgXForm = class
  public
    // transform APoint, the result is the transformed point
    function XForm(const APoint: TpgPoint): TpgPoint; virtual; abstract;
    procedure XFormPoints(ASource, ADest: PpgPoint; ACount: integer); virtual;
  end;

  // simple affine transform (not using the transform lists),
  // this way we avoid the persistent stored transforms in pgTransform
  TpgAffineXForm = class(TpgXForm)
  private
    FMatrix: TpgMatrix;
  public
    constructor Create;
    // invert the matrix
    function Invert: boolean;
    // Rotate the coordinate system over angle Angle (degrees!) around point Cx, Cy
    procedure Rotate(const Angle, Cx, Cy: double);
    // Scale the coordinate system with scale factors Sx and Sy in X and Y
    procedure Scale(const Sx, Sy: double);
    // Translate the coordinate system over Tx and Ty in X and Y
    procedure Translate(const Tx, Ty: double);
    // transform APoint, the result is the transformed point
    function XForm(const APoint: TpgPoint): TpgPoint; override;
  end;

  // projective XForm in analogy of transfrom classes (TODO).
  // See pgProjectiveTransform and pgProjectiveViewPort
  TpgProjectiveXForm = class(TpgXForm)
  end;

{ Point functions }

// Reflect APoint over APivot and return result
function pgReflectPoint(const APoint, APivot: TpgPoint): TpgPoint;

// Offset a point by X,Y
function pgOffsetPoint(const APoint: TpgPoint; X, Y: single): TpgPoint;

// Squared distance between two points
function pgDistanceSqr(const P1, P2: TpgPoint): double;

// Distance between two points
function pgDistance(const P1, P2: TpgPoint): double;

// Length of a vector P
function pgLength(const P: TpgPoint): double;

// Cross product of vector P1 and P2
function pgCrossProduct(const P1, P2: TpgPoint): double;

// Dot product of vector P1 and P2
function pgDotProduct(const P1, P2: TpgPoint): double;

// Calculate Delta from P1 to P2, put result in R
procedure pgDelta(const P1, P2: TpgPoint; var R: TpgPoint); overload;
function pgDelta(const P1, P2: TpgPoint): TpgPoint; overload;

// Unify the vector P
procedure pgUnify(var P: TpgPoint);
function pgUnifyF(const P: TpgPoint): TpgPoint;

// Midpoint between P1 and P2
function pgMidPoint(const P1, P2: TpgPoint): TpgPoint;

// Add points P1 and P2: Result = P1 + P2
function pgAddPoint(const P1, P2: TpgPoint): TpgPoint;

// Interpolate a point between P1 and P2, if Fraction = 0, P1 is returned,
// if Fraction = 1, P2 is returned, and in other cases the fractional position
// inbetween.
function pgInterpolatePoint(const P1, P2: TpgPoint; const Fraction: double): TpgPoint;

// Swap points P1 and P2
procedure pgSwapPoints(var P1, P2: TpgPoint);

// Flip x and y coordinates
function pgFlipVector(const P: TpgPoint): TpgPoint;

// Clip point P with box B, return result as clip result set. If the point is
// on the box, it is considered to intrude as well.
function pgClipPointWithBox(const P: TpgPoint; const B: TpgBox): TpgClipResults;

// Clip point P with box B, return result as clip result set. If the point is
// on the box, it is not considered to intrude.
function pgClipPointWithBoxExclusive(const P: TpgPoint; const B: TpgBox): TpgClipResults;

{ Line functions }

// Find the position on the line from parametrisation R = P + PosP * Delta
procedure pgLineParametricPos(const P, Delta: TpgPoint; const PosP: double; var R: TpgPoint);

// Intersect line P1-P2 with line Q1-Q2, and put the intersection point in R. If
// an intersection is found, the function returns True. If none is found (lines
// are parallel), the function returns False. PosP and PosQ are the parametric
// line positions. See pgLineParametricPos to get the value R from them.
function pgIntersectLines(const P1, P2, Q1, Q2: TpgPoint; var R: TpgPoint; var PosP, PosQ: double): boolean;

// Intersect line that starts in P, slope SlopeP with line that starts in Q, slope
// SlopeQ. Put result in R. If lines are parallel, function returns False.
function pgIntersectSlopeLines(const P, SlopeP, Q, SlopeQ: TpgPoint; var R: TpgPoint): boolean;

// Check if the line from P1 to P2 intersects with box B. If the line intersects,
// the function returns True. If the line just shares point on one border of B,
// the function returns False.
function pgLineAndBoxIntersect(const P1, P2: TpgPoint; const B: TpgBox): boolean;

{ Ellipse functions }

// Build an ellipse from center C, radii Ra and Rb and rotation Theta (degrees)
procedure pgMakeEllipse(const C: TpgPoint; Ra, Rb, Theta: double; var E: TpgEllipseR);

// Construct an ellipse throug P1 and P2, that consists of radii Ra and Rb, and a
// rotation Theta (degrees). LargeArc indicates we take the large arc from P1 to P2.
// If Sweep = True, the path from P1 to P2 is assumed to be in sweep direction (growing
// angles of N). Returned are the start and close angles N1 and N2.
procedure pgEllipseFromTwoPoints(P1, P2: TpgPoint; Theta, Ra, Rb: double;
  LargeArc, Sweep: boolean; var E: TpgEllipseR; var N1, N2: double);

  // Calculate a point on the ellipse E with generalized angle N (zeta, in radians)
function pgEllipsePoint(const E: TpgEllipseR; const N: double): TpgPoint;

// Calculate a point on the ellipse E with precalculated Sin and Cos values for
// generalized angle N
function pgEllipsePointSinCos(const E: TpgEllipseR; const ASin, ACos: double): TpgPoint;

// Calculate a slope on the ellipse E with generalized angle N (zeta, in radians)
function pgEllipseSlope(const E: TpgEllipseR; const N: double): TpgPoint;

{ Cubic bezier functions }

// Return the type of cubic bezier (Convex, Concave, Complex or Simple)
procedure pgMakeCubicBezier(const P1, C1, C2, P2: TpgPoint; var CB: TpgCubicBezierR);
function pgCubicBezierOuterLength(const CB: TpgCubicBezierR): double;
procedure pgSplitCubicBezier(const CB: TpgCubicBezierR; var A, B: TpgCubicBezierR);

{ Quadratic bezier functions }

procedure pgMakeQuadBezier(const P1, Q, P2: TpgPoint; var QB: TpgQuadBezierR);
procedure pgSplitQuadBezier(const QB: TpgQuadBezierR; var A, B: TpgQuadBezierR);
function pgQuadBezierAbsAngle(const QB: TpgQuadBezierR): double;
procedure pgQuadToCubic(const QB: TpgQuadBezierR; var CB: TpgCubicBezierR);

{ Affine Matrix functions }

function pgDeterminant(const M: TpgMatrix): double;
procedure pgInvertMatrix(var M: TpgMatrix);
procedure pgSetMatrix(var M: TpgMatrix; const A, B, C, D, E, F: double);
function pgMatrixMultiply(const M1, M2: TpgMatrix): TpgMatrix;
function pgMatrixMulVector(const M: TpgMatrix; const V: TpgPoint): TpgPoint;

{ helper functions }

function pgFloatEqual(const F1, F2, Eps: double): boolean;
procedure pgSwapDouble(var V1, V2: double);

{ polygon functions }

// Consider a closed polygon, constructed of Count points, does it contain point P? If Result = 0,
// the point is outside. Results of multiple polygons can be added up to form a winding
// number to use in combination with the fillrule.
function pgPointInPolygon(AFirst: PpgPoint; ACount: integer; const P: TpgPoint): integer;

// Check whether point P is on the polygon, with Tolerance on both sides.
function  pgPointOnPolygon(First: PpgPoint; Count: integer; IsClosed: boolean; const P: TpgPoint; Tolerance: single): boolean;

// Create a list of normal vectors in Dest. Dest[0] contains the normal of the
// line from Source[0] to Source[1], and so on.
procedure pgBuildNormals(Source, Dest: PpgPoint; Count: integer);

function MatrixMultiply(const M1, M2: TpgMatrix): TpgMatrix;
function MatrixMulVector(const M: TpgMatrix; const V: TpgPoint): TpgPoint;
procedure SetMatrix(var M: TpgMatrix; const A, B, C, D, E, F: double);
function Determinant(const M: TpgMatrix): double;
procedure InvertMatrix(var M: TpgMatrix);
function MatrixScale(const M: TpgMatrix; ADirection: TpgCartesianDirection): double;

procedure InvertMatrix3x3(var M: TpgMatrix3x3);
function Matrix2x3To3x3(const M: TpgMatrix): TpgMatrix3x3;
function MatrixMultiply3x3(const M1, M2: TpgMatrix3x3): TpgMatrix3x3;

implementation

{ TpgXForm }

procedure TpgXForm.XFormPoints(ASource, ADest: PpgPoint; ACount: integer);
var
  i: integer;
begin
  // by default use the XForm
  for i := 0 to ACount - 1 do
  begin
    ADest^ := XForm(ASource^);
    inc(ASource);
    inc(ADest);
  end;
end;

{ TpgAffineXForm }

constructor TpgAffineXForm.Create;
begin
  inherited Create;
  FMatrix := cIdentityMatrix;
end;

function TpgAffineXForm.Invert: boolean;
begin
  if abs(FMatrix.A * FMatrix.D - FMatrix.B * FMatrix.C) < 1E-15 then
    // Det close to 0
    Result := False
  else
  begin
    pgInvertMatrix(FMatrix);
    Result := True;
  end;
end;

procedure TpgAffineXForm.Rotate(const Angle, Cx, Cy: double);
var
  A: double;
  S, C: extended;
  M: TpgMatrix;
begin
  if not ((Cx = 0) and (Cy = 0)) then
    Translate(Cx, Cy);
  A := Angle * pi / 180;
  pgSinCos(A, S, C);
  pgSetMatrix(M, C, S, -S, C, 0, 0);
  FMatrix := pgMatrixMultiply(FMatrix, M);
  if not ((Cx = 0) and (Cy = 0)) then
    Translate(-Cx, -Cy);
end;

procedure TpgAffineXForm.Scale(const Sx, Sy: double);
var
  M: TpgMatrix;
begin
  M := cIdentityMatrix;
  M.A := Sx;
  M.D := Sy;
  FMatrix := pgMatrixMultiply(FMatrix, M);
end;

function TpgAffineXForm.XForm(const APoint: TpgPoint): TpgPoint;
begin
  Result := pgMatrixMulVector(FMatrix, APoint);
end;

procedure TpgAffineXForm.Translate(const Tx, Ty: double);
var
  M: TpgMatrix;
begin
  M := cIdentityMatrix;
  M.E := Tx;
  M.F := Ty;
  FMatrix := pgMatrixMultiply(FMatrix, M);
end;

{ functions }

function pgFloatEqual(const F1, F2, Eps: double): boolean;
begin
  Result := Abs(F2 - F1) < Eps;
end;

procedure pgSwapDouble(var V1, V2: double);
var
  T: double;
begin
  T := V1;
  V1 := V2;
  V2 := T;
end;

function pgReflectPoint(const APoint, APivot: TpgPoint): TpgPoint;
begin
  Result.X := 2 * APivot.X - APoint.X;
  Result.Y := 2 * APivot.Y - APoint.Y;
end;

function pgOffsetPoint(const APoint: TpgPoint; X, Y: single): TpgPoint;
begin
  Result.X := APoint.X + X;
  Result.Y := APoint.Y + Y;
end;

function pgDistanceSqr(const P1, P2: TpgPoint): double;
begin
  Result := sqr(P1.X - P2.X) + sqr(P1.Y - P2.Y);
end;

function pgDistance(const P1, P2: TpgPoint): double;
begin
  Result := sqrt(sqr(P1.X - P2.X) + sqr(P1.Y - P2.Y));
end;

function pgLength(const P: TpgPoint): double;
begin
  Result := sqrt(P.X * P.X + P.Y * P.Y);
end;

function pgCrossProduct(const P1, P2: TpgPoint): double;
begin
  Result := P1.X * P2.Y - P1.Y * P2.X;
end;

function pgDotProduct(const P1, P2: TpgPoint): double;
begin
  Result := P1.X * P2.X + P1.Y * P2.Y;
end;

procedure pgDelta(const P1, P2: TpgPoint; var R: TpgPoint);
begin
  R.X := P2.X - P1.X;
  R.Y := P2.Y - P1.Y;
end;

function pgDelta(const P1, P2: TpgPoint): TpgPoint;
begin
  Result.X := P2.X - P1.X;
  Result.Y := P2.Y - P1.Y;
end;

procedure pgUnify(var P: TpgPoint);
var
  L: double;
begin
  L := pgLength(P);
  if L > 0 then
  begin
    L := 1 / L;
    P.X := P.X * L;
    P.Y := P.Y * L;
  end else
  begin
    P.X := 1;
    P.Y := 0;
  end;
end;

function pgUnifyF(const P: TpgPoint): TpgPoint;
begin
  Result := P;
  pgUnify(Result);
end;

function pgMidPoint(const P1, P2: TpgPoint): TpgPoint;
// Midpoint between P1 and P2
begin
  Result.X := (P1.X + P2.X) * 0.5;
  Result.Y := (P1.Y + P2.Y) * 0.5;
end;

function pgAddPoint(const P1, P2: TpgPoint): TpgPoint;
begin
  Result.X := P1.X + P2.X;
  Result.Y := P1.Y + P2.Y;
end;

function pgInterpolatePoint(const P1, P2: TpgPoint; const Fraction: double): TpgPoint;
var
  FracI: double;
begin
  FracI := 1 - Fraction;
  Result.X := P1.X * FracI + P2.X * Fraction;
  Result.Y := P1.Y * FracI + P2.Y * Fraction;
end;

procedure pgSwapPoints(var P1, P2: TpgPoint);
var
  T: TpgPoint;
begin
  T := P1;
  P1 := P2;
  P2 := T;
end;

function pgFlipVector(const P: TpgPoint): TpgPoint;
begin
  Result.X := -P.X;
  Result.Y := -P.Y;
end;

function pgClipPointWithBox(const P: TpgPoint; const B: TpgBox): TpgClipResults;
// Clip point P with box B, return result as clip result set.
begin
  Result := [];
  if P.X <= B.Lft then Include(Result, cClipLft);
  if P.X >= B.Rgt then Include(Result, cClipRgt);
  if P.Y <= B.Top then Include(Result, cClipTop);
  if P.Y >= B.Btm then Include(Result, cClipBtm);
end;

function pgClipPointWithBoxExclusive(const P: TpgPoint; const B: TpgBox): TpgClipResults;
begin
  Result := [];
  if P.X < B.Lft then Include(Result, cClipLft);
  if P.X > B.Rgt then Include(Result, cClipRgt);
  if P.Y < B.Top then Include(Result, cClipTop);
  if P.Y > B.Btm then Include(Result, cClipBtm);
end;

procedure pgLineParametricPos(const P, Delta: TpgPoint; const PosP: double; var R: TpgPoint);
begin
  R.X := P.X + PosP * Delta.X;
  R.Y := P.Y + PosP * Delta.Y;
end;

function pgIntersectLines(const P1, P2, Q1, Q2: TpgPoint; var R: TpgPoint; var PosP, PosQ: double): boolean;
var
  DeltaP, DeltaQ: TpgPoint;
  Num, Py, Px, DenP, DenQ: double;
begin
  Result := False;

  // Check numerator
  pgDelta(P1, P2, DeltaP);
  pgDelta(Q1, Q2, DeltaQ);
  Num := DeltaQ.Y * DeltaP.X - DeltaQ.X * DeltaP.Y;
  if pgFloatEqual(Num, 0, cDefaultEps) then
    exit;

  // Denominators
  Result := True;
  Px := P1.X - Q1.X;
  Py := P1.Y - Q1.Y;
  DenP := DeltaQ.X * Py - DeltaQ.Y * Px;
  DenQ := DeltaP.X * Py - DeltaP.Y * Px;
  PosP := DenP/Num;
  PosQ := DenQ/Num;
  pgLineParametricPos(P1, DeltaP, PosP, R);
end;

function pgIntersectSlopeLines(const P, SlopeP, Q, SlopeQ: TpgPoint; var R: TpgPoint): boolean;
var
  Num, Py, Px, DenP, PosP: double;
begin
  Result := False;

  // Check numerator
  Num := SlopeQ.Y * SlopeP.X - SlopeQ.X * SlopeP.Y;
  if pgFloatEqual(Num, 0, cDefaultEps) then
    exit;

  // Denominators
  Result := True;
  Px := P.X - Q.X;
  Py := P.Y - Q.Y;
  DenP := SlopeQ.X * Py - SlopeQ.Y * Px;
  PosP := DenP/Num;
  pgLineParametricPos(P, SlopeP, PosP, R);
end;

function pgLineAndBoxIntersect(const P1, P2: TpgPoint; const B: TpgBox): boolean;
// Check if the line from P1 to P2 intersects with box B
var
  Clip1, Clip2, ClipOr: TpgClipResults;
  Dx, Dy: single;
  P: TpgPoint;
begin
  Result := True;
  Clip1 := pgClipPointWithBox(P1, B);
  if Clip1 = [] then
    exit;
  Clip2 := pgClipPointWithBox(P2, B);
  if Clip2 = [] then
    exit;

  if Clip1 * Clip2 <> [] then
  begin
    // Both points fall somewhere outside at the same side of the box, or
    // they fall both on the same edge of the box, we can assume the line
    // doesn't intersect
    Result := False;
    exit;
  end;

  // Now we must start to calculate clipped positions
  Dx := P2.X - P1.X;
  Dy := P2.Y - P1.Y;

  // Left position
  if (cClipLft in ClipOr) and ((P1.X < B.Lft) or (P2.X < B.Lft)) then
  begin
    P.Y := P1.X + ((B.Lft - P1.X) / Dx) * Dy;
    P.X := B.Lft;
    if P1.X < B.Lft then
      Result := pgLineAndBoxIntersect(P2, P, B)
    else
      Result := pgLineAndBoxIntersect(P1, P, B);
    exit;
  end;

  // Top position
  if (cClipTop in ClipOr) and ((P1.Y < B.Top) or (P2.Y < B.Top)) then
  begin
    P.X := P1.X + ((B.Top - P1.Y) / Dy) * Dx;
    P.Y := B.Top;
    if P1.Y < B.Top then
      Result := pgLineAndBoxIntersect(P2, P, B)
    else
      Result := pgLineAndBoxIntersect(P1, P, B);
    exit;
  end;

  // Right position
  if (cClipRgt in ClipOr) and ((P1.X > B.Rgt) or (P2.X > B.Rgt)) then
  begin
    P.Y := P1.X + ((B.Rgt - P1.X) / Dx) * Dy;
    P.X := B.Rgt;
    if P1.X > B.Rgt then
      Result := pgLineAndBoxIntersect(P2, P, B)
    else
      Result := pgLineAndBoxIntersect(P1, P, B);
    exit;
  end;

  // Bottom position
  if (cClipBtm in ClipOr) and ((P1.Y > B.Btm) or (P2.Y > B.Btm)) then
  begin
    P.X := P1.X + ((B.Btm - P1.Y) / Dy) * Dx;
    P.Y := B.Btm;
    if P1.Y > B.Rgt then
      Result := pgLineAndBoxIntersect(P2, P, B)
    else
      Result := pgLineAndBoxIntersect(P1, P, B);
    exit;
  end;
end;

procedure pgMakeEllipse(const C: TpgPoint; Ra, Rb, Theta: double; var E: TpgEllipseR);
var
  Sn, Cs: extended;
begin
  E.C := C;
  E.Ra := Ra;
  E.Rb := Rb;
  pgSinCos(Theta * (pi / 180), Sn, Cs);
  E.SinT := Sn;
  E.CosT := Cs;
end;

procedure pgEllipseFromTwoPoints(P1, P2: TpgPoint; Theta, Ra, Rb: double;
  LargeArc, Sweep: boolean; var E: TpgEllipseR; var N1, N2: double);
var
  T: TpgAffineXForm;
  P1b, P2b, Mb, Cb, C: TpgPoint;
  L, F, R: double;
  Sign: integer;
begin
  // Transform
  T := TpgAffineXForm.Create;
  try
    T.Scale(1/Ra, 1/Rb);
    if Theta <> 0 then
      T.Rotate(-Theta, 0, 0);

    if not Sweep then
      pgSwapPoints(P1, P2);

    // Points in base coords
    P1b := T.XForm(P1);
    P2b := T.XForm(P2);

    // Center calculation - we assume that P1 -> P2 is the sweep direction.
    // Mb is the middle between P1 and P2 in base coords
    // Cb is the center of the ellise in base coords
    Mb := pgMidPoint(P1b, P2b);
    L := pgDistance(P1b, P2b);
    F := sqrt(pgMax(0, 1 - 0.25 * sqr(L))) / L;
    if LargeArc then
      Sign := -1
    else
      Sign := 1;
    Cb.X := Mb.X - Sign * (P2b.Y - P1b.Y) * F;
    Cb.Y := Mb.Y + Sign * (P2b.X - P1b.X) * F;

    // N1 is start angle (rads)
    // N2 is stop angle (rads)
    N1 := pgArcTan2(P1b.Y - Cb.Y, P1b.X - Cb.X);
    N2 := pgArcTan2(P2b.Y - Cb.Y, P2b.X - Cb.X);
    if N2 < N1 then
      N2 := N2 + 2 * pi;

    if not Sweep then
      pgSwapDouble(N1, N2);

    // Transform center back, and get (possibly updated) Ra and Rb
    T.Invert;
    C := T.XForm(Cb);

    R := pgLength(pgDelta(P1b, Cb));
    Ra := pgDistance(C, T.XForm(pgOffsetPoint(Cb, R, 0)));
    Rb := pgDistance(C, T.XForm(pgOffsetPoint(Cb, 0, R)));

    // Results
    pgMakeEllipse(C, Ra, Rb, Theta, E);
  finally
    T.Free;
  end;
end;

function pgEllipsePoint(const E: TpgEllipseR; const N: double): TpgPoint;
var
  SinN, CosN: extended;
begin
  pgSinCos(N, SinN, CosN);
  Result.X := E.C.X + E.Ra * E.CosT * CosN - E.Rb * E.SinT * SinN;
  Result.Y := E.C.Y + E.Ra * E.SinT * CosN + E.Rb * E.CosT * SinN;
end;

function pgEllipsePointSinCos(const E: TpgEllipseR; const ASin, ACos: double): TpgPoint;
begin
  Result.X := E.C.X + E.Ra * E.CosT * ACos - E.Rb * E.SinT * ASin;
  Result.Y := E.C.Y + E.Ra * E.SinT * ACos + E.Rb * E.CosT * ASin;
end;

function pgEllipseSlope(const E: TpgEllipseR; const N: double): TpgPoint;
var
  SinN, CosN: extended;
begin
  pgSinCos(N, SinN, CosN);
  Result.X := -E.Ra * E.CosT * SinN - E.Rb * E.SinT * CosN;
  Result.Y := -E.Ra * E.SinT * SinN + E.Rb * E.CosT * CosN;
end;

procedure pgMakeCubicBezier(const P1, C1, C2, P2: TpgPoint; var CB: TpgCubicBezierR);
begin
  CB.P1 := P1;
  CB.C1 := C1;
  CB.C2 := C2;
  CB.P2 := P2;
end;

function pgCubicBezierOuterLength(const CB: TpgCubicBezierR): double;
begin
  Result :=
    pgDistance(CB.P1, CB.C1) +
    pgDistance(CB.C1, CB.C2) +
    pgDistance(CB.C2, CB.P2);
end;

procedure pgSplitCubicBezier(const CB: TpgCubicBezierR; var A, B: TpgCubicBezierR);
var
  T: TpgPoint;
begin
  A.P1 := CB.P1;
  A.C1 := pgMidPoint(CB.P1, CB.C1);
  T    := pgMidPoint(CB.C1, CB.C2);
  A.C2 := pgMidPoint(A.C1, T);
  B.P2 := CB.P2;
  B.C2 := pgMidPoint(CB.C2, CB.P2);
  B.C1 := pgMidPoint(T, B.C2);
  A.P2 := pgMidPoint(A.C2, B.C1);
  B.P1 := A.P2;
end;

procedure pgMakeQuadBezier(const P1, Q, P2: TpgPoint; var QB: TpgQuadBezierR);
begin
  QB.P1 := P1;
  QB.Q  := Q;
  QB.P2 := P2;
end;

procedure pgSplitQuadBezier(const QB: TpgQuadBezierR; var A, B: TpgQuadBezierR);
begin
  A.P1 := QB.P1;
  A.Q  := pgMidPoint(QB.P1, QB.Q);
  B.P2 := QB.P2;
  B.Q  := pgMidPoint(QB.Q, QB.P2);
  A.P2 := pgMidPoint(A.Q, B.Q);
  B.P1 := A.P2;
end;

function pgQuadBezierAbsAngle(const QB: TpgQuadBezierR): double;
var
  Delta1, Delta2: TpgPoint;
begin
  pgDelta(QB.Q, QB.P1, Delta1);
  pgDelta(QB.P2, QB.Q, Delta2);
  pgUnify(Delta1);
  pgUnify(Delta2);
  Result := abs(pgArcSin(pgCrossProduct(Delta1, Delta2)));
end;

procedure pgQuadToCubic(const QB: TpgQuadBezierR; var CB: TpgCubicBezierR);
begin
  CB.P1 := QB.P1;
  CB.P2 := QB.P2;
  pgLineParametricPos(QB.P1, pgDelta(QB.P1, QB.Q), 2/3, CB.C1);
  pgLineParametricPos(QB.P2, pgDelta(QB.P2, QB.Q), 2/3, CB.C2);
end;

function pgDeterminant(const M: TpgMatrix): double;
begin
  Result := 1 / (M.A * M.D - M.B * M.C);
end;

procedure pgInvertMatrix(var M: TpgMatrix);
var
  D, Ta, Te: double;
begin
  D := pgDeterminant(M);
  Ta  :=  M.D * D;
  M.D :=  M.A * D;
  M.B := -M.B * D;
  M.C := -M.C * D;
  Te  := -M.E * Ta  - M.F * M.C;
  M.F := -M.E * M.B - M.F * M.D;
  M.A := Ta;
  M.E := Te;
end;

procedure pgSetMatrix(var M: TpgMatrix; const A, B, C, D, E, F: double);
begin
  M.A := A; M.B := B; M.C := C; M.D := D; M.E := E; M.F := F;
end;

function pgMatrixMultiply(const M1, M2: TpgMatrix): TpgMatrix;
begin
  Result.A := M1.A * M2.A + M1.C * M2.B;
  Result.B := M1.B * M2.A + M1.D * M2.B;
  Result.C := M1.A * M2.C + M1.C * M2.D;
  Result.D := M1.B * M2.C + M1.D * M2.D;
  Result.E := M1.A * M2.E + M1.C * M2.F + M1.E;
  Result.F := M1.B * M2.E + M1.D * M2.F + M1.F;
end;

function pgMatrixMulVector(const M: TpgMatrix; const V: TpgPoint): TpgPoint;
begin
  Result.X := M.A * V.X + M.C * V.Y + M.E;
  Result.Y := M.B * V.X + M.D * V.Y + M.F;
end;

{ polygon functions }

function pgPointInPolygon(AFirst: PpgPoint; ACount: integer; const P: TpgPoint): integer;
var
  i: integer;
  P2: PpgPoint;
  X1, Y1, X2, Y2: single;

  // local
  function CaseSign(AValue: single): integer;
  begin
    if AValue < 0 then
      Result := 0
    else
      if AValue > 0 then
        Result := 2
      else
        Result := 1;
  end;

  // local
  function CheckX: integer;
  var
    X: single;
  begin
    Result := 0;
    if (X1 > 0) and (X2 > 0) then
      exit;
    if not ((X1 <= 0) and (X2 <= 0)) then
    begin
      // Calculate X
      X := X1 - Y1 * (X2 - X1) / (Y2 - Y1);
      if X > 0 then
        exit;
    end;
    Result := 1;
  end;

// main
begin
  Result := 0;
  if ACount <= 2 then
    exit;

  P2 := AFirst;
  inc(AFirst, ACount - 1); // go to last
  X1 := AFirst.X - P.X;
  Y1 := AFirst.Y - P.Y;
  for i := 0 to ACount - 1 do
  begin
    X2 := P2.X - P.X;
    Y2 := P2.Y - P.Y;
    case CaseSign(Y1) + CaseSign(Y2) * 3 of
    0:;// Y1 < 0, Y2 < 0
    1:// Y1 = 0, Y2 < 0
      inc(Result, CheckX);
    2:// Y1 > 0, Y2 < 0
      inc(Result, CheckX);
    3:// Y1 < 0, Y2 = 0
      dec(Result, CheckX);
    4:;// Y1 = 0, Y2 = 0
    5:;// Y1 > 0, Y2 = 0
    6:// Y1 < 0, Y2 > 0
      dec(Result, CheckX);
    7:;// Y1 = 0, Y2 > 0
    8:;// Y1 > 0, Y2 > 0
    end;

    // Move to next point
    X1 := X2;
    Y1 := Y2;
    inc(P2);
  end;
end;

function pgPointOnPolygon(First: PpgPoint; Count: integer; IsClosed: boolean; const P: TpgPoint; Tolerance: single): boolean;
var
  i: integer;
  Points: PpgPointArray;
  Last: integer;
  X1, Y1, X2, Y2: single;
  X, Y, XMin, XMax, YMin, YMax: single;
  Tol2: single;
  P2: PpgPoint;

  // local
  function DistSqr(Ax, Ay, Bx, By: single): single;
  begin
    Result := sqr(Ax - Bx) + sqr(Ay - By);
  end;

  // local
  function CheckLineSegment: boolean;
  var
    q: single;
  begin
    Result := False;
    // BB checks
    if (XMax < X1) and (XMax < X2) then exit;
    if (XMin > X1) and (XMin > X2) then exit;
    if (YMax < Y1) and (YMax < Y2) then exit;
    if (YMin > Y1) and (YMin > Y2) then exit;

    // Point-Line distance
    if (X1 = X2) and (Y1 = Y2) then
    begin

      // Point to point
      Result := DistSqr(X, Y, X1, Y1) <= Tol2;
      exit;

    end;

    // Minimum
    q := ((X - X1) * (X2 - X1) + (Y - Y1) * (Y2 - Y1)) / (sqr(X2 - X1) + sqr(Y2 - Y1));

    // Limit q to 0 <= q <= 1
    if q < 0 then q := 0;
    if q > 1 then q := 1;

    // Distance
    Result := DistSqr(X, Y, (1 - q) * X1 + q * X2, (1 - q) * Y1 + q * Y2) <= Tol2;
  end;

// main
begin
  Result := False;
  Points := PpgPointArray(First);
  if IsClosed then
    Last := Count
  else
    Last := Count - 1;

  // Convenience
  X := P.X; Y := P.Y;
  XMin := X - Tolerance;
  XMax := X + Tolerance;
  YMin := Y - Tolerance;
  YMax := Y + Tolerance;
  Tol2 := sqr(Tolerance);

  X1 := First.X;
  Y1 := First.Y;
  for i := 0 to Last - 1 do
  begin
    P2 := @Points[(i + 1) mod Count];
    X2 := P2.X;
    Y2 := P2.Y;
    if CheckLineSegment then
    begin
      Result := True;
      exit;
    end;
    X1 := X2;
    Y1 := Y2;
  end;
end;

procedure pgBuildNormals(Source, Dest: PpgPoint; Count: integer);
var
  i: integer;
  PointA, PointB: PpgPoint;
  Dx, Dy: single;
  R, F: double;
begin
  if Count <= 0 then
    exit;

  PointA := Source;
  for i := 1 to Count do
  begin
    // Get point B, auto-wrap around
    PointB := Source;
    inc(PointB, i mod Count);

    // The normals are rotated +90 deg
    Dx := PointA.Y - PointB.Y;
    Dy := PointB.X - PointA.X;

    // Normalize them
    R := Sqrt(Sqr(Dx) + Sqr(Dy));
    if R > 0 then
    begin
      F := 1 / R;
      Dest.X := Dx * F;
      Dest.Y := Dy * F;
    end else
    begin
      Dest.X := 0;
      Dest.Y := 0;
    end;
    PointA := PointB;
    inc(Dest);
  end;
end;

function MatrixMultiply(const M1, M2: TpgMatrix): TpgMatrix;
begin
  Result.A := M1.A * M2.A + M1.C * M2.B;
  Result.B := M1.B * M2.A + M1.D * M2.B;
  Result.C := M1.A * M2.C + M1.C * M2.D;
  Result.D := M1.B * M2.C + M1.D * M2.D;
  Result.E := M1.A * M2.E + M1.C * M2.F + M1.E;
  Result.F := M1.B * M2.E + M1.D * M2.F + M1.F;
end;

function MatrixMulVector(const M: TpgMatrix; const V: TpgPoint): TpgPoint;
begin
  Result.X := M.A * V.X + M.C * V.Y + M.E;
  Result.Y := M.B * V.X + M.D * V.Y + M.F;
end;

procedure SetMatrix(var M: TpgMatrix; const A, B, C, D, E, F: double);
begin
  M.A := A; M.B := B; M.C := C; M.D := D; M.E := E; M.F := F;
end;

function Determinant(const M: TpgMatrix): double;
begin
  Result := 1 / (M.A * M.D - M.B * M.C);
end;

procedure InvertMatrix(var M: TpgMatrix);
var
  D, Ta, Te: double;
begin
  D := Determinant(M);
  Ta  :=  M.D * D;
  M.D :=  M.A * D;
  M.B := -M.B * D;
  M.C := -M.C * D;
  Te  := -M.E * Ta  - M.F * M.C;
  M.F := -M.E * M.B - M.F * M.D;
  M.A := Ta;
  M.E := Te;
end;

function MatrixScale(const M: TpgMatrix; ADirection: TpgCartesianDirection): double;
var
  X, Y: double;
begin
  X := sqrt(sqr(M.A) + sqr(M.B));
  Y := sqrt(sqr(M.C) + sqr(M.D));

  case ADirection of
  cdHorizontal: Result := X;
  cdVertical:   Result := Y;
  cdUnknown:    Result := sqrt(X * Y);
  else
    Result := 1;
  end;
end;

function Det2x2(a1, a2, b1, b2: double): double; overload;
begin
  Result := a1 * b2 - a2 * b1;
end;

function Det3x3(a1, a2, a3, b1, b2, b3, c1, c2, c3: double): double; overload;
begin
  Result :=
    a1 * (b2 * c3 - b3 * c2) -
    b1 * (a2 * c3 - a3 * c2) +
    c1 * (a2 * b3 - a3 * b2);
end;

procedure Adjoint3x3(var M: TpgMatrix3x3);
var
  a1, a2, a3: double;
  b1, b2, b3: double;
  c1, c2, c3: double;
begin
  a1 := M[0, 0]; a2:= M[1, 0]; a3 := M[2, 0];
  b1 := M[0, 1]; b2:= M[1, 1]; b3 := M[2, 1];
  c1 := M[0, 2]; c2:= M[1, 2]; c3 := M[2, 2];

  M[0, 0] :=   Det2x2(b2, b3, c2, c3);
  M[1, 0] := - Det2x2(a2, a3, c2, c3);
  M[2, 0] :=   Det2x2(a2, a3, b2, b3);

  M[0, 1] := - Det2x2(b1, b3, c1, c3);
  M[1, 1] :=   Det2x2(a1, a3, c1, c3);
  M[2, 1] := - Det2x2(a1, a3, b1, b3);

  M[0, 2] :=   Det2x2(b1, b2, c1, c2);
  M[1, 2] := - Det2x2(a1, a2, c1, c2);
  M[2, 2] :=   Det2x2(a1, a2, b1, b2);
end;

function Determinant3x3(const M: TpgMatrix3x3): double;
begin
  Result := Det3x3(M[0, 0], M[0, 1], M[0, 2],
                   M[1, 0], M[1, 1], M[1, 2],
                   M[2, 0], M[2, 1], M[2, 2]);
end;

procedure Scale3x3(var M: TpgMatrix3x3; Factor: double);
var
  i, j: Integer;
begin
  for i := 0 to 2 do
    for j := 0 to 2 do
      M[i,j] := M[i,j] * Factor;
end;

procedure InvertMatrix3x3(var M: TpgMatrix3x3);
var
  Det: double;
begin
  Det := Determinant3x3(M);
  if Abs(Det) < 1E-5 then M := cIdentityMatrix3x3
  else
  begin
    Adjoint3x3(M);
    Scale3x3(M, 1 / Det);
  end;
end;

function Matrix2x3To3x3(const M: TpgMatrix): TpgMatrix3x3;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result[0, 0] := M.A;
  Result[1, 0] := M.B;
  Result[0, 1] := M.C;
  Result[1, 1] := M.D;
  Result[0, 2] := M.E;
  Result[1, 2] := M.F;
  Result[2, 2] := 1;
end;

function MatrixMultiply3x3(const M1, M2: TpgMatrix3x3): TpgMatrix3x3;
var
  r, c: integer;
begin
  for r := 0 to 2 do
    for c := 0 to 2 do
      Result[r, c] :=
        M1[r, 0] * M2[0, c] +
        M1[r, 1] * M2[1, c] +
        M1[r, 2] * M2[2, c];
end;

end.

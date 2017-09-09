{ Project: Pyro
  Module: Pyro Render

  Description:
    This unit provides geometrical routines for shapes like beziers and ellipses.

    This unit can be used separately from Pyro; it uses
    only a few types/consts from Pyro. See $define usepyro.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit sdGeometry;

{$i simdesign.inc}

interface

{.$define usepyro}

uses
  {$ifdef usepyro}
  Pyro,
  {$endif}
  Classes, SysUtils, Math;

{$ifndef usepyro}
type
  TpgFloat = single;

  TpgBox = packed record
    case integer of
    0: (Lft, Top, Rgt, Btm: TpgFloat);
    1: (Left, _Top, Right, Bottom: TpgFloat);
  end;

  TpgPoint = packed record
    X, Y: TpgFloat;
  end;

  TpgMatrix = packed record
    case integer of
    0: (A, B, C, D, E, F: double);
    1: (Elements: array[0..5] of double);
  end;

  TpgClipResult = (
    cClipLft,
    cClipRgt,
    cClipTop,
    cClipBtm
  );
  TpgClipResults = set of TpgClipResult;

const
  cDefaultEps = 1E-10;

  cIdentityMatrix: TpgMatrix =
    (A: 1; B: 0; C: 0; D: 1; E: 0; F: 0);
{$endif}

type
  // Cubic bezier
  TpgCubicBezierR = packed record
    case Integer of
    0: (P1, C1, C2, P2: TpgPoint);
    1: (P: array[0..3] of TpgPoint);
  end;

  // Quadratic bezier
  TpgQuadBezierR = packed record
    case Integer of
    0: (P1, Q, P2: TpgPoint);
    1: (P: array[0..2] of TpgPoint);
  end;

  // Ellipse
  TpgEllipseR = packed record
    C: TpgPoint;           // center point
    Ra, Rb: double;        // length of a and b axes (radii)
    CosT, SinT: double;    // Rotation of ellipse around Theta (expressed as cos/sin)
  end;

  // simple affine transform (not using the transform lists),
  // this way we avoid the persistent stored transforms in pgTransform
  TpgSimpleAffineTransform = class
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
    function Transform(const APoint: TpgPoint): TpgPoint;
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

// Cubic bezier functions

// Return the type of cubic bezier (Convex, Concave, Complex or Simple)
procedure pgMakeCubicBezier(const P1, C1, C2, P2: TpgPoint; var CB: TpgCubicBezierR);
function pgCubicBezierOuterLength(const CB: TpgCubicBezierR): double;
procedure pgSplitCubicBezier(const CB: TpgCubicBezierR; var A, B: TpgCubicBezierR);

// Quadratic bezier functions

procedure pgMakeQuadBezier(const P1, Q, P2: TpgPoint; var QB: TpgQuadBezierR);
procedure pgSplitQuadBezier(const QB: TpgQuadBezierR; var A, B: TpgQuadBezierR);
function pgQuadBezierAbsAngle(const QB: TpgQuadBezierR): double;
procedure pgQuadToCubic(const QB: TpgQuadBezierR; var CB: TpgCubicBezierR);

// affine matrix functions

function pgDeterminant(const M: TpgMatrix): double;
procedure pgInvertMatrix(var M: TpgMatrix);
procedure pgSetMatrix(var M: TpgMatrix; const A, B, C, D, E, F: double);
function pgMatrixMultiply(const M1, M2: TpgMatrix): TpgMatrix;
function pgMatrixMulVector(const M: TpgMatrix; const V: TpgPoint): TpgPoint;

// helper functions
function pgFloatEqual(const F1, F2, Eps: double): boolean;
procedure pgSwapDouble(var V1, V2: double);

implementation

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
  SinCos(Theta * (pi / 180), Sn, Cs);
  E.SinT := Sn;
  E.CosT := Cs;
end;

procedure pgEllipseFromTwoPoints(P1, P2: TpgPoint; Theta, Ra, Rb: double;
  LargeArc, Sweep: boolean; var E: TpgEllipseR; var N1, N2: double);
var
  T: TpgSimpleAffineTransform;
  P1b, P2b, Mb, Cb, C: TpgPoint;
  L, F, R: double;
  Sign: integer;
begin
  // Transform
  T := TpgSimpleAffineTransform.Create;
  try
    T.Scale(1/Ra, 1/Rb);
    if Theta <> 0 then
      T.Rotate(-Theta, 0, 0);

    if not Sweep then
      pgSwapPoints(P1, P2);

    // Points in base coords
    P1b := T.Transform(P1);
    P2b := T.Transform(P2);

    // Center calculation - we assume that P1 -> P2 is the sweep direction.
    // Mb is the middle between P1 and P2 in base coords
    // Cb is the center of the ellise in base coords
    Mb := pgMidPoint(P1b, P2b);
    L := pgDistance(P1b, P2b);
    F := sqrt(Max(0, 1 - 0.25 * sqr(L))) / L;
    if LargeArc then
      Sign := -1
    else
      Sign := 1;
    Cb.X := Mb.X - Sign * (P2b.Y - P1b.Y) * F;
    Cb.Y := Mb.Y + Sign * (P2b.X - P1b.X) * F;

    // N1 is start angle (rads)
    // N2 is stop angle (rads)
    N1 := ArcTan2(P1b.Y - Cb.Y, P1b.X - Cb.X);
    N2 := ArcTan2(P2b.Y - Cb.Y, P2b.X - Cb.X);
    if N2 < N1 then
      N2 := N2 + 2 * pi;

    if not Sweep then
      pgSwapDouble(N1, N2);

    // Transform center back, and get (possibly updated) Ra and Rb
    T.Invert;
    C := T.Transform(Cb);

    R := pgLength(pgDelta(P1b, Cb));
    Ra := pgDistance(C, T.Transform(pgOffsetPoint(Cb, R, 0)));
    Rb := pgDistance(C, T.Transform(pgOffsetPoint(Cb, 0, R)));

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
  SinCos(N, SinN, CosN);
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
  SinCos(N, SinN, CosN);
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
  Result := abs(arcsin(pgCrossProduct(Delta1, Delta2)));
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

{ TpgSimpleAffineTransform }

constructor TpgSimpleAffineTransform.Create;
begin
  inherited Create;
  FMatrix := cIdentityMatrix;
end;

function TpgSimpleAffineTransform.Invert: boolean;
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

procedure TpgSimpleAffineTransform.Rotate(const Angle, Cx, Cy: double);
var
  A: double;
  S, C: extended;
  M: TpgMatrix;
begin
  if not ((Cx = 0) and (Cy = 0)) then
    Translate(Cx, Cy);
  A := Angle * pi / 180;
  SinCos(A, S, C);
  pgSetMatrix(M, C, S, -S, C, 0, 0);
  FMatrix := pgMatrixMultiply(FMatrix, M);
  if not ((Cx = 0) and (Cy = 0)) then
    Translate(-Cx, -Cy);
end;

procedure TpgSimpleAffineTransform.Scale(const Sx, Sy: double);
var
  M: TpgMatrix;
begin
  M := cIdentityMatrix;
  M.A := Sx;
  M.D := Sy;
  FMatrix := pgMatrixMultiply(FMatrix, M);
end;

function TpgSimpleAffineTransform.Transform(const APoint: TpgPoint): TpgPoint;
begin
  Result := pgMatrixMulVector(FMatrix, APoint);
end;

procedure TpgSimpleAffineTransform.Translate(const Tx, Ty: double);
var
  M: TpgMatrix;
begin
  M := cIdentityMatrix;
  M.E := Tx;
  M.F := Ty;
  FMatrix := pgMatrixMultiply(FMatrix, M);
end;

end.

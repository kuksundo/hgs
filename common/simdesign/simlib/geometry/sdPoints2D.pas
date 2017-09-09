unit sdPoints2D;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{
  Description: Basic routines for working with 2D points and pointlists.
  This unit is heavily used as a basic 2D math unit for many projects.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 13Sep2005

  Modifications:

  copyright (c) 2005 SimDesign B.V.

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}

interface

uses
  SysUtils, Math;

type

  // 2D point
  TsdPoint2D = record
    case byte of
    0: (X, Y: double);
    1: (Elem: array[0..1] of double);
  end;

  PsdPoint2D = ^TsdPoint2D;
  TsdPoint2DArray = array[0.. MaxInt div SizeOf(TsdPoint2D) - 1] of TsdPoint2D;
  PsdPoint2DArray = ^TsdPoint2DArray;

function MakePoint2D(const AX, AY: double): TsdPoint2D;

procedure AddPoint2D(const A, B: TsdPoint2D; var Result: TsdPoint2D);
function Length2D(const APoint: TsdPoint2D): double;
function SquaredLength2D(const APoint: TsdPoint2D): double;

// Compare points A and B and return true if equal
function PtsEqual2D(const A, B: TsdPoint2D; const Eps: double = 1E-12): boolean;

// Euclidian distance between points A and B
function Dist2D(const A, B: TsdPoint2D): double;

// Squared distance between points A and B: sqr(B.X - A.X) + sqr(B.Y - A.Y)
function SquaredDist2D(const A, B: TsdPoint2D): double;

// Distance from A to B how a NY taxi cab would drive (going along hor and vert lines)
function TaxicabDist2D(const A, B: TsdPoint2D): double;

// Crossproduct of Vector1 and Vector 2: V1 x V2
function CrossProduct2D(const Vector1, Vector2: TsdPoint2D): double;

// Dot product of Vector1 and Vector2: V1.X * V2.X + V1.Y * V2.Y
function DotProduct2D(const Vector1, Vector2: TsdPoint2D): double;

// Normalize AVector: divide coefficients by the length of the vector
procedure NormalizeVector2D(var AVector: TsdPoint2D);

// Substract points: Result = A - B
procedure SubstractPoint2D(const A, B: TsdPoint2D; var Result: TsdPoint2D);

// Return delta from A to B (or: B - A)
function Delta2D(const A, B: TsdPoint2D): TsdPoint2D;

// Return midpoint between A and B
function MidPoint2D(const A, B: TsdPoint2D): TsdPoint2D;

// Interpolate between point P1 and P2
procedure Interpolation2D(const P1, P2: TsdPoint2D; const xf: double; var Result: TsdPoint2D);

// Distance of P to the line from P1 to P2. The line does not extend beyond P1 or P2,
// so in these cases, the distance to one of the endpoints is calculated
function PointToLineDist2DSqr(const P, P1, P2: TsdPoint2D): double;

// Intersect line P1-P2 with line Q1-Q2, and put the intersection point in R. If
// an intersection is found, the function returns True. If none is found (lines
// are parallel), the function returns False. PosP and PosQ are the parametric
// line positions. See pgLineParametricPos to get the value R from them.
function IntersectLines2D(const P1, P2, Q1, Q2: TsdPoint2D; var R: TsdPoint2D;
  var PosP, PosQ: double; const Eps: double = 1E-12): boolean;

// Mirror point P into the line with basepoint Base and direction Dir, put
// result in R. Dir *must* be normalized.
procedure MirrorPointInLine(const P, Base, Dir: TsdPoint2D; out R: TsdPoint2D);

// Returns the angle between vector A and B in radians
function AngleBetweenVectors(A, B: TsdPoint2D): double;

// Calculate the circle through 3 points, and return the Center and the Radius.
// If the points are (virtually) co-linear, no circle can be found, and the
// function returns False.
function CircleFrom3Points(const A, B, C: TsdPoint2D; var Center: TsdPoint2D; var Radius: double): boolean;

// same as CircleFrom3Points, but returns the squared radius R2 and so avoids
// a sqrt() instruction. This function also returns the denominator Den, and
// abs(Den) can be used as a weight.
function CircleFrom3PointsR2(const A, B, C: TsdPoint2D; var Center: TsdPoint2D; var R2, Den: double): boolean;

function Point2DToString(const P: TsdPoint2D; const Scale: double; const Fmt: string): string;

// determinant of a 3x3 real matrix [A B C; D E F; G H I]
function Det3x3(const A, B, C, D, E, F, G, H, I: double): double;

const
  cZero2D: TsdPoint2D = (X: 0; Y: 0);

implementation

function MakePoint2D(const AX, AY: double): TsdPoint2D;
begin
  Result.X := AX;
  Result.Y := AY;
end;

procedure AddPoint2D(const A, B: TsdPoint2D; var Result: TsdPoint2D);
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

function Length2D(const APoint: TsdPoint2D): double;
begin
  Result := Sqrt(SquaredLength2D(APoint));
end;

function SquaredLength2D(const APoint: TsdPoint2D): double;
begin
  Result := Sqr(APoint.X) + Sqr(APoint.Y);
end;

function PtsEqual2D(const A, B: TsdPoint2D; const Eps: double = 1E-12): boolean;
begin
  Result := (abs(A.X - B.X) + abs(A.Y - B.Y)) <= Eps;
end;

function Dist2D(const A, B: TsdPoint2D): double;
begin
  Result := sqrt(SquaredDist2D(A, B));
end;

function SquaredDist2D(const A, B: TsdPoint2D): double;
begin
  Result := sqr(A.X - B.X) + sqr(A.Y - B.Y);
end;

function TaxicabDist2D(const A, B: TsdPoint2D): double;
begin
  Result := abs(A.X - B.X) + abs(A.Y - B.Y);
end;

function CrossProduct2D(const Vector1, Vector2: TsdPoint2D): double;
begin
  Result := Vector1.X * Vector2.Y - Vector1.Y * Vector2.X;
end;

function DotProduct2D(const Vector1, Vector2: TsdPoint2D): double;
begin
  Result := Vector1.X * Vector2.X + Vector1.Y * Vector2.Y;
end;

procedure NormalizeVector2D(var AVector: TsdPoint2D);
var
  L: double;
begin
  L := Length2D(AVector);

  if L > 0 then
  begin

    L := 1/L;
    AVector.X := AVector.X * L;
    AVector.Y := AVector.Y * L;

  end else
  begin

    // Avoid division by zero, return unity vec along X
    AVector.X := 1;
    AVector.Y := 0;

  end;
end;

procedure SubstractPoint2D(const A, B: TsdPoint2D; var Result: TsdPoint2D);
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

function Delta2D(const A, B: TsdPoint2D): TsdPoint2D;
begin
  Result.X := B.X - A.X;
  Result.Y := B.Y - A.Y;
end;

function MidPoint2D(const A, B: TsdPoint2D): TsdPoint2D;
begin
  Result.X := (A.X + B.X) * 0.5;
  Result.Y := (A.Y + B.Y) * 0.5;
end;

procedure Interpolation2D(const P1, P2: TsdPoint2D; const xf: double; var Result: TsdPoint2D);
var
  xf1: double;
begin
  xf1 := 1 - xf;
  Result.X := P1.X * xf1 + P2.X * xf;
  Result.Y := P1.Y * xf1 + P2.Y * xf;
end;

function PointToLineDist2DSqr(const P, P1, P2: TsdPoint2D): double;
// Point-Line distance
var
  q: double;
  Pq: TsdPoint2D;
begin
  if PtsEqual2D(P1, P2) then
  begin

    // Point to point
    Result := SquaredDist2D(P, P1);
    exit;

  end;

  // Minimum
  q := ((P.X - P1.X) * (P2.X - P1.X) + (P.Y - P1.Y) * (P2.Y - P1.Y)) /
       (sqr(P2.X - P1.X) + sqr(P2.Y - P1.Y));

  // Limit q to 0 <= q <= 1
  if q < 0 then
    q := 0;

  if q > 1 then
    q := 1;

  // Distance
  Interpolation2D(P1, P2, q, Pq);
  Result := SquaredDist2D(P, Pq);

end;

function IntersectLines2D(const P1, P2, Q1, Q2: TsdPoint2D; var R: TsdPoint2D;
  var PosP, PosQ: double; const Eps: double = 1E-12): boolean;
var
  DeltaP, DeltaQ: TsdPoint2D;
  Num, Py, Px, DenP, DenQ: double;
begin
  Result := False;

  // Check numerator
  DeltaP := Delta2D(P1, P2);
  DeltaQ := Delta2D(Q1, Q2);
  Num := DeltaQ.Y * DeltaP.X - DeltaQ.X * DeltaP.Y;
  if abs(Num) < Eps then
    exit;

  // Denominators
  Result := True;
  Px := P1.X - Q1.X;
  Py := P1.Y - Q1.Y;
  DenP := DeltaQ.X * Py - DeltaQ.Y * Px;
  DenQ := DeltaP.X * Py - DeltaP.Y * Px;
  PosP := DenP/Num;
  PosQ := DenQ/Num;

  // intersection point
  Interpolation2D(P1, P2, PosP, R);
end;

procedure MirrorPointInLine(const P, Base, Dir: TsdPoint2D; out R: TsdPoint2D);
// Mirror point P into the line with basepoint Base and direction Dir, put
// result in R. Dir *must* be normalized.
var
  Pb, Pp: TsdPoint2D;
  Frac: double;
begin
  // P relative to base
  SubstractPoint2D(P, Base, Pb);

  // find projection on line
  Frac := DotProduct2D(Pb, Dir);
  Pp.X := Base.X + Dir.X * Frac;
  Pp.Y := Base.Y + Dir.Y * Frac;

  // Result is reflection of this point
  R.X := Pp.X * 2 - P.X;
  R.Y := Pp.Y * 2 - P.Y;
end;

function AngleBetweenVectors(A, B: TsdPoint2D): double;
// Returns the angle between vector A and B in radians
var
  C, S: double;
begin
  // Normalize A and B
  NormalizeVector2D(A);
  NormalizeVector2D(B);

  // Dotproduct = cosine, crossproduct = sine
  C := DotProduct2D(A, B);
  S := CrossProduct2D(A, B);

  // Sine = Y, Cosine = X, use arctan2 function
  Result := ArcTan2(S, C);
end;

function CircleFrom3Points(const A, B, C: TsdPoint2D; var Center: TsdPoint2D; var Radius: double): boolean;
var
  R2, Den: double;
begin
  Result := CircleFrom3PointsR2(A, B, C, Center, R2, Den);
  if Result then
    Radius := sqrt(R2);
end;

function CircleFrom3PointsR2(const A, B, C: TsdPoint2D; var Center: TsdPoint2D; var R2, Den: double): boolean;
var
  A1, A2: double;
begin
  // Calculate circle center and radius (squared)
  Den := ((B.Y - C.Y) * (B.X - A.X) - (B.Y - A.Y) * (B.X - C.X)) * 2;
  A1  :=  (A.X + B.X) * (B.X - A.X) + (B.Y - A.Y) * (A.Y + B.Y);
  A2  :=  (B.X + C.X) * (B.X - C.X) + (B.Y - C.Y) * (B.Y + C.Y);

  // Make sure we don't divide by zero
  if abs(Den) > 1E-20 then
  begin

    Result := True;

    // Calculated circle center of circle through points a, b, c
    Center.X := (A1 * (B.Y - C.Y) - A2 * (B.Y - A.Y)) / Den;
    Center.Y := (A2 * (B.X - A.X) - A1 * (B.X - C.X)) / Den;

    // Squared radius of this circle
    R2 := SquaredDist2D(Center, A);

  end else
  begin

    // Co-linear, or close to it
    Result := False;

  end;
end;

function Point2DToString(const P: TsdPoint2D; const Scale: double; const Fmt: string): string;
begin
  Result := Format('[%s, %s]',
    [Format(Fmt, [P.X * Scale]), Format(Fmt, [P.Y * Scale])]);
end;

function Det3x3(const A, B, C, D, E, F, G, H, I: double): double;
// determinant of a 3x3 real matrix [A B C; D E F; G H I]
begin
  // rule of Sarrus
  Result := A*E*I + B*F*G + C*D*H - A*F*H - B*D*I - C*E*G;
end;

end.
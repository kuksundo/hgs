unit sdBeziers;
{

  This unit contains code for working with Bezier curves.

  Author: Nils Haeck M.Sc.

  Copyright (c) 2005 - 2007 by Nils Haeck M.Sc. (Simdesign)
  Visit us at http://www.simdesign.nl

  This code is for demonstrational purposes only. You may NOT use it in any
  commercial or freeware project, unless with SPECIFIC permission from the author.

}

interface

uses
  Windows, Math;

type

  TsdPoint = record
    X,
    Y: double;
  end;

  TsdBezier = record
    P: array[0..3] of TsdPoint;
  end;

  TsdRectangle = record
    Left,
    Top,
    Right,
    Bottom: double;
  end;

// Find the closest point on the ABezier curve to point APoint, within tolerance
// Tol, and return the parametric position on the curve in A (A between 0 and 1)
// as well as the closest point in Closest.
procedure ClosestPointOnBezier(const ABezier: TsdBezier; const APoint: TsdPoint;
  Tol: double; var A: double; var Steps: integer; var ADist: double; var Closest: TsdPoint);

// Check if APoint is on or near ABezier, within tolerance Tol.
function IsPointOnBezier(const ABezier: TsdBezier; const APoint: TsdPoint; var Steps: integer; Tol: double): boolean;

// Split ABezier in two bezier curves B1 and B2, at the parametric positon A
// (A between 0 and 1)
procedure SplitBezierWithFactor(const ABezier: TsdBezier; A: double; var B1, B2: TsdBezier);

// Convert the bezier to the windows pointlist format
procedure BezierToWindowsFormat(const ABezier: TsdBezier; var P: array of TPoint);

implementation

procedure GrowRectangle(var ARect: TsdRectangle; Grow: double);
begin
  ARect.Left   := ARect.Left   - Grow;
  ARect.Top    := ARect.Top    - Grow;
  ARect.Right  := ARect.Right  + Grow;
  ARect.Bottom := ARect.Bottom + Grow;
end;

function IsPointInRectangle(const ARect: TsdRectangle; const APoint: TsdPoint): boolean;
begin
  Result :=
        (APoint.X >= ARect.Left)
    and (APoint.Y >= ARect.Top)
    and (APoint.X <= ARect.Right)
    and (APoint.Y <= ARect.Bottom);
end;

procedure MidPoint(const P1, P2: TsdPoint; var Result: TsdPoint);
// Find midpoint between P1 and P2
begin
  Result.X := (P1.X + P2.X) * 0.5;
  Result.Y := (P1.Y + P2.Y) * 0.5;
end;

function DistancePointToPoint2(const P1, P2: TsdPoint): double;
// Return squared distance of P1 to P2
var
  Dx, Dy: double;
begin
  Dx := P2.X - P1.X;
  Dy := P2.Y - P1.Y;
  Result := Dx * Dx + Dy * Dy;
end;

function InProduct3Points(const Base, P1, P2: TsdPoint): double;
// calculate the inproduct of vectors Base->P1 and Base->P2
begin
  Result := (P1.X - Base.X) * (P2.X - Base.X) + (P1.Y - Base.Y) * (P2.Y - Base.Y);
end;

procedure SplitBezierInTwoHalves(const ABezier: TsdBezier; var Bezier1, Bezier2: TsdBezier);
// Split ABezier in two beziers by using the midpoint method
var
  T: TsdPoint;
begin
  Bezier1.P[0] := ABezier.P[0];
  MidPoint(ABezier.P[0], ABezier.P[1], Bezier1.P[1]);
  MidPoint(ABezier.P[1], ABezier.P[2], T);
  MidPoint(T, Bezier1.P[1], Bezier1.P[2]);
  Bezier2.P[3] := ABezier.P[3];
  MidPoint(ABezier.P[3], ABezier.P[2], Bezier2.P[2]);
  MidPoint(T, Bezier2.P[2], Bezier2.P[1]);
  MidPoint(Bezier1.P[2], Bezier2.P[1], Bezier1.P[3]);
  Bezier2.P[0] := Bezier1.P[3];
end;

function InvertBezier(const ABezier: TsdBezier): TsdBezier;
// Invert the bezier control points
var
  i: integer;
begin
  for i := 0 to 3 do
    Result.P[3 - i] := ABezier.P[i];
end;

procedure BezierBoundingBox(const ABezier: TsdBezier; var ABox: TsdRectangle);
begin
  with ABezier do
  begin
    ABox.Left   := Min(P[0].X, Min(P[1].X, Min(P[2].X, P[3].X)));
    ABox.Top    := Min(P[0].Y, Min(P[1].Y, Min(P[2].Y, P[3].Y)));
    ABox.Right  := Max(P[0].X, Max(P[1].X, Max(P[2].X, P[3].X)));
    ABox.Bottom := Max(P[0].Y, Max(P[1].Y, Max(P[2].Y, P[3].Y)));
  end;
end;

procedure CalculateBezierPolynomial(ABezier: TsdBezier; var Factors: array of TsdPoint);
begin
  with ABezier do
  begin
    Factors[0].X :=      P[0].X;
    Factors[1].X := -3 * P[0].X + 3 * P[1].X;
    Factors[2].X :=  3 * P[0].X - 6 * P[1].X + 3 * P[2].X;
    Factors[3].X := -    P[0].X + 3 * P[1].X - 3 * P[2].X + P[3].X;
    Factors[0].Y :=      P[0].Y;
    Factors[1].Y := -3 * P[0].Y + 3 * P[1].Y;
    Factors[2].Y :=  3 * P[0].Y - 6 * P[1].Y + 3 * P[2].Y;
    Factors[3].Y := -    P[0].Y + 3 * P[1].Y - 3 * P[2].Y + P[3].Y;
  end;
end;

function CalculatePointOnBezier(const ABezier: TsdBezier; A: double): TsdPoint;
// Return the point on the bezier curve at location A, where A is the variable
// in the parametrisation, 0 <= A <= 1
var
  X: array[0..3] of TsdPoint;
  A2, A3: double;
begin
  // Polynomial Factors
  CalculateBezierPolynomial(ABezier, X);
  // powers of A
  A2 := A * A;
  A3 := A2 * A;
  // Polynomial Result
  Result.X := X[3].X * A3 + X[2].X * A2 + X[1].X * A + X[0].X;
  Result.Y := X[3].Y * A3 + X[2].Y * A2 + X[1].Y * A + X[0].Y;
end;

procedure ClosestPointOnBezier(const ABezier: TsdBezier; const APoint: TsdPoint;
  Tol: double; var A: double; var Steps: integer; var ADist: double; var Closest: TsdPoint);
var
  Tol2: double;
  // local
  function RecurseClosestBezierPoint(const ABezier: TsdBezier; const APoint: TsdPoint;
    Amin, Amax: double; var Steps: integer; var SqDist: double): double;
  var
    Bezier1, Bezier2: TsdBezier;
    i, ClosestIndex: integer;
    SqD, Furthest: double;
    D0, D3: double;
    Slanting: boolean;
    AHalf, A1, A2, Dist1, Dist2: double;
  begin
    inc(Steps);
    // Find closest of the end points
    D0 := DistancePointToPoint2(APoint, ABezier.P[0]);
    D3 := DistancePointToPoint2(APoint, ABezier.P[3]);
    if D0 < D3 then
    begin
      ClosestIndex := 0;
      SqDist := D0;
      Result := AMin;
    end else
    begin
      ClosestIndex := 3;
      SqDist := D3;
      Result := AMax;
    end;

    // Find furthest distance from this endpoint to the other ones
    Furthest := 0;
    for i := 0 to 3 do
      if i <> ClosestIndex then
      begin
        SqD := DistancePointToPoint2(ABezier.P[i], ABezier.P[ClosestIndex]);
        if SqD > Furthest then Furthest := SqD;
      end;

    // Check if this distance is smaller than tolerance, if so we can quit
    if Furthest < Tol2 then exit;

    // Test if the closest endpoint is slanting towards test point
    Slanting := True;
    for i := 0 to 3 do
      if (i <> ClosestIndex)
         and (InProduct3Points(ABezier.P[ClosestIndex], ABezier.P[i], APoint) > 0) then
      begin
        Slanting := False;
        break;
      end;
    // If it is slanting, we can quit
    if Slanting then exit;

    // Split the bezier now, and repeat for both sides, take smallest
    SplitBezierInTwoHalves(ABezier, Bezier1, Bezier2);
    AHalf := (AMax + AMin) * 0.5;
    A1 := RecurseClosestBezierPoint(Bezier1, APoint, AMin, AHalf, Steps, Dist1);
    A2 := RecurseClosestBezierPoint(Bezier2, APoint, AHalf, AMax, Steps, Dist2);
    if Dist1 < Dist2 then
    begin
      SqDist := Dist1;
      Result := A1;
    end else
    begin
      SqDist := Dist2;
      Result := A2;
    end;
  end;
var
  SqDist: double;
// main
begin
  Tol2 := sqr(Tol);
  Steps := 0;
  A := RecurseClosestBezierPoint(ABezier, APoint, 0, 1, Steps, SqDist);
  ADist := sqrt(SqDist);
  Closest := CalculatePointOnBezier(ABezier, A);
end;

// Check if APoint is on or near ABezier, within tolerance Tol.
function IsPointOnBezier(const ABezier: TsdBezier; const APoint: TsdPoint; var Steps: integer; Tol: double): boolean;
var
  SqTol: double;
  Limit: double;
// Local
function RecurseIsPointOnBezier(const ABezier: TsdBezier; var Steps: integer): boolean;
var
  i, j: integer;
  Box: TsdRectangle;
  D0, D3, Dmax: double;
  Bezier1, Bezier2: TsdBezier;
begin
  Result := False;
  inc(Steps);
  // Check our bounding box
  BezierBoundingBox(ABezier, Box);
  GrowRectangle(Box, Tol);
  if not IsPointInRectangle(Box, APoint) then exit;

  // Check points individually
  D0 := DistancePointToPoint2(ABezier.P[0], APoint);
  D3 := DistancePointToPoint2(ABezier.P[3], APoint);
  if (D0 < SqTol) or (D3 < SqTol) then
  begin
    Result := True;
    exit;
  end;

  // Check internal distances
  Dmax := 0;
  with ABezier do
    for i := 0 to 2 do
      for j := i + 1 to 3 do
        Dmax := Max(Dmax, DistancePointToPoint2(P[i], P[j]));

  // If this distance is smaller than limit, we can quit
  if Dmax < Limit then exit;

  // Now we will split and see if the sub-beziers can give us a result
  SplitBezierInTwoHalves(ABezier, Bezier1, Bezier2);
  Result := RecurseIsPointOnBezier(Bezier1, Steps);
  if Result then exit;
  Result := RecurseIsPointOnBezier(Bezier2, Steps);
end;
// main
begin
  SqTol := sqr(Tol);
  Limit := sqr(Tol * 0.2);
  Steps := 0;
  Result := RecurseIsPointOnBezier(ABezier, Steps);
end;

procedure PartialBezier(const ABezier: TsdBezier; A: double; var Result: TsdBezier);
var
  i: integer;
  X: array[0..3] of TsdPoint;
  F: double;
const
  c13 = 1/3;
  c23 = 2/3;
begin
  CalculateBezierPolynomial(ABezier, X);

  // Modify the polynomial coefficients, X[0] remains unchanged
  F := A;
  for i := 1 to 3 do
  begin
    X[i].X := X[i].X * F;
    X[i].Y := X[i].Y * F;
    F := F * A;
  end;

  // Calculate the new control points from new coefficents
  Result.P[0] := X[0];
  Result.P[1].X := c13 * X[1].X + X[0].X;
  Result.P[1].Y := c13 * X[1].Y + X[0].Y;
  Result.P[2].X := c13 * X[2].X + c23 * X[1].X + X[0].X;
  Result.P[2].Y := c13 * X[2].Y + c23 * X[1].Y + X[0].Y;
  Result.P[3].X := X[3].X + X[2].X + X[1].X + X[0].X;
  Result.P[3].Y := X[3].Y + X[2].Y + X[1].Y + X[0].Y;
end;

procedure SplitBezierWithFactor(const ABezier: TsdBezier; A: double; var B1, B2: TsdBezier);
begin
  // Left side
  PartialBezier(ABezier, A, B1);
  // Right side
  PartialBezier(InvertBezier(ABezier), 1 - A, B2);
  // Make sure they flow same way
  B2 := InvertBezier(B2);
end;

procedure BezierToWindowsFormat(const ABezier: TsdBezier; var P: array of TPoint);
// Convert the bezier to the windows pointlist format
var
  i: integer;
begin
  for i := 0 to 3 do
  begin
    P[i].X := round(ABezier.P[i].X);
    P[i].Y := round(ABezier.P[i].Y);
  end;
end;

end.

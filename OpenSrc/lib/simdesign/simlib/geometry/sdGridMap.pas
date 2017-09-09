unit sdGridMap;
{
  Description:

  Classes that implement NURBS (Non-uniform Rational B-splines).

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 23Jul2002

  Modifications:

  copyright (c) 2002 - 2005 SimDesign B.V.
}

interface

uses
  Windows, Classes, SysUtils, Math, sdPoints3D, sdMatrices, sdMesh,
  sdLines3D, Dialogs;

type

  TsdGridCell = array[0..3, 0..3] of double; // Bezier end and control point Z coords
  PsdGridCell = ^TsdGridCell;

  TsdKnotWeight = array[0..11] of double;

  TsdInterpolationMethod = (
    imLinear,  // Use linear interpolation between the gridpoint
    imCubic    // Use cubic bezier interpolation between the gridpoints
  );

  // A TsdGridMap is a grid of points on an XY plane defining a Z-height, and
  // the surface inbetween is interpolated using any of the interpolation
  // schemes (linear, or cubic using bezier surfaces).
  TsdGridMap = class(TPersistent)
  private
    FGridXPos: array of double;
    FGridYPos: array of double;
    FGridPoints: array of double;
    FGridCells: array of TsdGridCell;
    FGridYSize: integer;
    FGridXSize: integer;
    FXMin, FYMin, FXMax, FYMax: double;
    FUniformGrid: boolean;
    FUniformXSpacing: double;
    FUniformYSpacing: double;
    FIsGridValid: boolean;
    FInterpolationMethod: TsdInterpolationMethod;
    procedure SetGridXSize(const Value: integer);
    procedure SetGridYSize(const Value: integer);
    function GetGridZValue(Xindex, Yindex: integer): double;
    procedure SetGridZValue(Xindex, Yindex: integer; const Value: double);
    procedure SetUniformGrid(const Value: boolean);
    function GetGridXSpacing(Xindex: integer): double;
    function GetGridYSpacing(Yindex: integer): double;
    procedure GetKnotWeights(var K: TsdKnotWeight; Xind, Yind: integer; u, v: double);
    function GetHeight: double;
    function GetWidth: double;
  protected
    procedure GetXIndexAndFraction(const X: double; var Xindex: integer; var Xfrac: double);
    procedure GetYIndexAndFraction(const Y: double; var Yindex: integer; var Yfrac: double);
    procedure ValidateGridCell(const K: TsdKnotWeight; Xind, Yind: integer; var P: TsdGridCell);
    procedure ValidateGrid;
  public
    constructor Create; virtual;
    procedure SetGridSize(XSize, YSize: integer);
    procedure SetArea(const XMin, YMin, XMax, YMax: double);
    // Create gridpoint heights such that the surface matches the points as good as possible.
    // The average error per point is returned in Error.
    procedure MatchToPointlist(Points: PsdPoint3D; PointCount: integer; var Error: double);
    // Get the Z value at location X, Y
    function ZValue(const X, Y: double): double;
    // Get the normal vector and Z value at location X, Y
    procedure NormalAndZ(const X, Y: double; var Normal: TsdPoint3D; var Z:double);
    // Project Point onto the surface, return the SurfacePoint and Normal. Any of these
    // can be nil, if they are not required. Eps defines the distance deviation along
    // a flat plane.
    procedure ProjectPoint(const Point: TsdPoint3D; SurfacePoint, Normal: PsdPoint3D; const Eps: double = 1E-6);
    // Calculate the length along the surface from (X1, Y1) to (X2, Y2), making sure
    // to use no longer segments than ABreakupLength when evaluating points along
    // the surface.
    function LengthAlongSurface(const X1, Y1, X2, Y2: double; ABreakupLength: double): double;
    property GridXSize: integer read FGridXSize write SetGridXSize;
    property GridYSize: integer read FGridYSize write SetGridYSize;
    property GridXSpacing[Xindex: integer]: double read GetGridXSpacing;
    property GridYSpacing[Yindex: integer]: double read GetGridYSpacing;
    property GridZValue[Xindex, Yindex: integer]: double read GetGridZValue write SetGridZValue;
    // Choose imLinear for linear interpolation or imCubic for cubic interpolation using
    // Bezier surfaces.
    property InterpolationMethod: TsdInterpolationMethod read FInterpolationMethod write FInterpolationMethod;
    property Width: double read GetWidth;
    property Height: double read GetHeight;
  end;

  TsdMeshGenerator = class(TPersistent)
  public
    // Generate a regular, triangular mesh from a gridmap surface, with mesh cells of size
    // CellXSize * CellYSize.
    // If a clipping polygon is used, it should be passed in ClipPoly, and it's pointcount
    // in ClipPolyCount. The triangles will exactly follow the clipping polygon's boundary.
    procedure GenerateMesh(AGridMap: TsdGridMap; AMesh: TsdTriangleMesh3D; AClipPoly: PsdPoint3DArray;
      AClipPolyCount: integer; ACellXSize, ACellYSize: double; AExactFit: boolean);
  end;

resourcestring

  sIllegalIndex                        = 'Illegal Index';
  sTooManyIterationsInNormalProjection = 'Too many iterations in normal projection';
  sNoConvergenceInNormalProjection     = 'No convergence in normal projection';

implementation

const
  // fractions
  c16 = 1/6;
  c12 = 1/2;
  c13 = 1/3;
  c23 = 2/3;
  c56 = 5/6;

const
  // Knot positions (12 in total) that are influenced by this cell (btw only in
  // cubic mode it uses all 12)
  cKnotPos: array[0..11, 0..1] of integer =
    (          (0, -1), (1, -1),
      (-1, 0), (0,  0), (1,  0), (2, 0),
      (-1, 1), (0,  1), (1,  1), (2, 1),
               (0,  2), (1,  2));

type

  TMeshConstruct = record
    Num: integer;
    Tri: array[0..2, 0..2] of integer;
  end;

{ TsdGridMap }

constructor TsdGridMap.Create;
begin
  inherited Create;
  FUniformGrid := True;
  FInterpolationMethod := imCubic;
  SetGridSize(2, 2);
end;

function TsdGridMap.GetGridXSpacing(Xindex: integer): double;
begin
  if FUniformGrid then
    Result := FUniformXSpacing
  else
  begin
    if (XIndex < 0) or (XIndex >= FGridXSize) then
      raise Exception.Create(sIllegalIndex)
    else
      Result := FGridXPos[XIndex + 1] - FGridXPos[XIndex];
  end;
end;

function TsdGridMap.GetGridYSpacing(Yindex: integer): double;
begin
  if FUniformGrid then
    Result := FUniformYSpacing
  else
  begin
    if (YIndex < 0) or (YIndex >= FGridYSize) then
      raise Exception.Create(sIllegalIndex)
    else
      Result := FGridYPos[YIndex + 1] - FGridYPos[YIndex];
  end;
end;

function TsdGridMap.GetGridZValue(Xindex, Yindex: integer): double;
begin
  Result := 0;
  if (Xindex < 0) or (Xindex > FGridXSize) or (Yindex < 0) or (Yindex > FGridYSize) then
    exit;
  Result := FGridPoints[Yindex * (FGridXSize + 1) + Xindex]
end;

function TsdGridMap.GetHeight: double;
begin
  Result := FYmax - FYmin;
end;

procedure TsdGridMap.GetKnotWeights(var K: TsdKnotWeight; Xind,
  Yind: integer; u, v: double);
// Find the parametrized knot weights to put into system matrix A. The indices used
// correspond to knot points around the cell, according to this diagram:
//
//      0   1
//      *   *
//   2  3   4   5
//   *  *   *   *
//   6  7   8   9
//   *  *   *   *
//     10  11
//      *   *
//
// Point Z-heights are defined for all the Bezier end and control points per cell
// like this:
//
//   X ----
// Y P00 P10 P20 P30
// | P01 P11 P21 P31
// | P02 P12 P22 P32
//   P03 P13 P23 P33
//

  // local
  procedure AddMul(var K: TsdKnotWeight; const C: double; const M: TsdKnotWeight);
  var
    i: integer;
  begin
    for i := 0 to 11 do
      K[i] := K[i] + C * M[i];
  end;
  // local
  procedure SetCPointEdge(var K: TsdKnotWeight; B, C, D: integer);
  begin
    K[B] :=  c12; K[C] := c23; K[D] := -c16;
  end;
  // local
  procedure SetCPointCont(var K: TsdKnotWeight; A, B, C: integer);
  begin
    K[A] := -c16; K[B] := 1; K[C] := c16;
  end;
  // local
  procedure SetIntermediate(var K: TsdKnotWeight; const P00, P10, P30, P01, P31, P03, P13: TsdKnotWeight);
  begin
    AddMul(K, -1, P00);
    AddMul(K, 1, P01);
    AddMul(K, 1, P10);
  end;

// main
var
  x, y: integer;
  P: array[0..3, 0..3] of TsdKnotWeight;
  ui, vi: double;
  Bx, By: array[0..3] of double;
begin
  Fillchar(P, SizeOf(P), 0);

  // Corners
  P[0, 0, 3] := 1;
  P[3, 0, 4] := 1;
  P[0, 3, 7] := 1;
  P[3, 3, 8] := 1;

  // Horizontal edges
  if FGridXSize = 1 then
  begin
    P[1, 0, 3] := c23; P[1, 0, 4] := c13;
    P[2, 0, 3] := c13; P[2, 0, 4] := c23;
    P[1, 3, 7] := c23; P[1, 3, 8] := c13;
    P[2, 3, 7] := c13; P[2, 3, 8] := c23;
  end else
  begin
    if Xind = 0 then
    begin
      SetCPointEdge(P[1, 0], 3, 4, 5);
      SetCPointEdge(P[1, 3], 7, 8, 9);
    end else
    begin
      SetCPointCont(P[1, 0], 2, 3, 4);
      SetCPointCont(P[1, 3], 6, 7, 8);
    end;
    if Xind = FGridXSize - 1 then
    begin
      SetCPointEdge(P[2, 0], 4, 3, 2);
      SetCPointEdge(P[2, 3], 8, 7, 6);
    end else
    begin
      SetCPointCont(P[2, 0], 5, 4, 3);
      SetCPointCont(P[2, 3], 9, 8, 7);
    end;
  end;

  // Vertical edges
  if FGridYSize = 1 then
  begin
    P[0, 1, 3] := c23; P[0, 1, 7] := c13;
    P[0, 2, 3] := c13; P[0, 2, 7] := c23;
    P[3, 1, 4] := c23; P[3, 1, 8] := c13;
    P[3, 2, 4] := c13; P[3, 2, 8] := c13;
  end else
  begin
    if Yind = 0 then
    begin
      SetCPointEdge(P[0, 1], 3, 7, 10);
      SetCPointEdge(P[3, 1], 4, 8, 11);
    end else
    begin
      SetCPointCont(P[0, 1], 0, 3, 7);
      SetCPointCont(P[3, 1], 1, 4, 8);
    end;
    if Yind = FGridYSize - 1 then
    begin
      SetCPointEdge(P[0, 2], 7, 3, 0);
      SetCPointEdge(P[3, 2], 8, 4, 1);
    end else
    begin
      SetCPointCont(P[0, 2], 10, 7, 3);
      SetCPointCont(P[3, 2], 11, 8, 4);
    end;
  end;

  // Internal points
  SetIntermediate(P[1,1], P[0,0], P[1,0], P[3,0], P[0,1], P[3,1], P[0,3], P[1,3]);
  SetIntermediate(P[2,1], P[3,0], P[2,0], P[0,0], P[3,1], P[0,1], P[3,3], P[2,3]);
  SetIntermediate(P[1,2], P[0,3], P[1,3], P[3,3], P[0,2], P[3,2], P[0,0], P[1,0]);
  SetIntermediate(P[2,2], P[3,3], P[2,3], P[0,3], P[3,2], P[0,2], P[3,0], P[2,0]);

  // Calculate final K
  FillChar(K, SizeOf(K), 0);
  ui := 1 - u;
  vi := 1 - v;
  Bx[0] :=     ui * ui * ui;
  Bx[1] := 3 * u  * ui * ui;
  Bx[2] := 3 * u  * u  * ui;
  Bx[3] :=     u  * u  * u ;
  By[0] :=     vi * vi * vi;
  By[1] := 3 * v  * vi * vi;
  By[2] := 3 * v  * v  * vi;
  By[3] :=     v  * v  * v ;
  for y := 0 to 3 do
    for x := 0 to 3 do
      AddMul(K, Bx[x] * By[y], P[x, y]);
end;

function TsdGridMap.GetWidth: double;
begin
  Result := FXMax - FXMin;
end;

procedure TsdGridMap.GetXIndexAndFraction(const X: double;
  var Xindex: integer; var Xfrac: double);
begin
  if FUniformGrid then
  begin
    Xfrac := (X - FXmin) / FUniformXSpacing;
    Xindex := Min(FGridXSize - 1, Max(0, trunc(XFrac)));
    Xfrac := Xfrac - Xindex;
  end else;
    // to do: binary search in positions
end;

procedure TsdGridMap.GetYIndexAndFraction(const Y: double;
  var Yindex: integer; var Yfrac: double);
begin
  if FUniformGrid then
  begin
    Yfrac := (Y - FYmin) / FUniformYSpacing;
    Yindex := Min(FGridYSize - 1, Max(0, trunc(YFrac)));
    Yfrac := Yfrac - Yindex;
  end else;
    // to do: binary search in positions
end;

function TsdGridMap.LengthAlongSurface(const X1, Y1, X2, Y2: double;
  ABreakupLength: double): double;
var
  i, Count: integer;
  Xnew, Ynew, Znew, Zold, dX, dY, dXYSqr, Length2D: double;
begin
  Length2D := sqrt(sqr(X2 - X1) + Sqr(Y2 - Y1));
  if ABreakupLength = 0 then
    ABreakupLength := 1E-3;
  // Number of segments
  Count := Max(1, ceil(Length2D / ABreakupLength));

  // dX/dY per segment
  dX := (X2 - X1) / Count;
  dY := (Y2 - Y1) / Count;
  dXYSqr := sqr(dX) + sqr(dY);

  // Integrate all segment lengths
  Xnew := X1;
  Ynew := Y1;
  Znew := ZValue(Xnew, Ynew);
  Result := 0;
  for i := 0 to Count - 1 do
  begin
    ZOld := ZNew;
    // calculate new
    Xnew := Xnew + dX;
    Ynew := Ynew + dY;
    Znew := ZValue(Xnew, Ynew);
    // calculate length of segment and add up
    Result := Result + sqrt(dXYSqr + sqr(Znew - Zold));
  end;
end;

procedure TsdGridMap.MatchToPointlist(Points: PsdPoint3D;
  PointCount: integer; var Error: double);

var
  i, j, xi, yi: integer;
  A, Ai: TsdMatrix;
  X, B: TsdVector;
  P: PsdPoint3D;
  Xind, Yind: integer;
  Xf, Yf, Xfi, Yfi: double;
  K: TsdKnotWeight;
  // local
  function GetIdx(X, Y: integer): integer;
  begin
    Result := Y * (FGridXSize + 1) + X;
  end;
// main
begin
  // We create a linear system A * x = b where A is the system matrix, x is a
  // vector with all the control points (Z-heights), and b is the calculated value
  // for each point in the list. We solve this by putting the real values in b,
  // and inversing A with Moore penrose to get x = Ai * b, and hence we have
  // our control points X.

  A := TsdMatrix.CreateSize(PointCount, length(FGridPoints));
  Ai := TsdMatrix.Create;
  X := TsdVector.CreateCount(length(FGridPoints));
  B := TsdVector.CreateCount(PointCount);
  try
    // Create system matrix A and vector B
    P := Points;
    for i := 0 to PointCount - 1 do
    begin
      GetXIndexandFraction(P.X, Xind, Xf);
      GetYIndexandFraction(P.Y, Yind, Yf);
      case FInterpolationMethod of
      imCubic:
        begin
          GetKnotWeights(K, Xind, Yind, Xf, Yf);
          // Fill elements A
          for j := 0 to 11 do
          begin
            xi := Xind + cKnotPos[j, 0];
            yi := Yind + cKnotPos[j, 1];
            if (xi < 0) or (xi > FGridXSize) then
              continue;
            if (yi < 0) or (yi > FGridYSize) then
              continue;
            A[i, yi * (FGridXSize + 1) + xi] := K[j];
          end;
        end;
      imLinear:
        begin
          Xfi := 1 - Xf;
          Yfi := 1 - Yf;
          A[i, GetIdx(Xind    , Yind    )] := Xfi * Yfi;
          A[i, GetIdx(Xind + 1, Yind    )] := Xf  * Yfi;
          A[i, GetIdx(Xind    , Yind + 1)] := Xfi * Yf ;
          A[i, GetIdx(Xind + 1, Yind + 1)] := Xf  * Yf ;
        end;
      end;//case
      // Fill element B
      B[i] := P.Z;
      // Next point
      inc(P);
    end;

    // Calculate solution
    try
      MatInverseMP(A, Ai);
    except
      // Unable to invert matrix.. this means it is degenerate
      ShowMessage('Warning: no match found.. decrease gridsize');
      exit;
    end;
    MatMultiply(Ai, B, X);

    // Put solution in points
    i := 0;
    for yi := 0 to FGridYSize do
      for xi := 0 to FGridXSize do
      begin
        GridZValue[xi, yi] := X[i];
        inc(i);
      end;

    // Calculate error
    Error := 0;
    P := Points;
    for i := 0 to PointCount - 1 do
    begin
      Error := Error + abs(ZValue(P.X, P.Y) - P.Z);
      inc(P);
    end;
    Error := Error / PointCount;


  finally
    A.Free;
    Ai.Free;
    X.Free;
    B.Free;
  end;
end;

procedure TsdGridMap.NormalAndZ(const X, Y: double; var Normal: TsdPoint3D; var Z:double);
var
  xi, yi, Xindex, Yindex: integer;
  Bx, By, dBx, dBy: array[0..3] of double;
  u, v, ui, vi, u2, v2, ui2, vi2, uui, vvi, dFdx, dFdy, Pxy: double;
  P: PsdGridCell;
  // local
  function GetIdx(X, Y: integer): integer;
  begin
    Result := Y * (FGridXSize + 1) + X;
  end;
// main
begin
  // Validate grid if neccesary (calculate control points)
  if not FIsGridValid then
    ValidateGrid;

  // Get indices and fractions
  GetXIndexAndFraction(X, Xindex, u);
  GetYIndexAndFraction(Y, Yindex, v);

  P := @FGridCells[Yindex * FGridXSize + Xindex];
  dFdx := 0;
  dFdy := 0;
  Z := 0;
  case FInterpolationMethod of
  imCubic:
    begin

      // precalculated values
      ui := 1 - u;
      vi := 1 - v;
      u2  := u  * u;
      v2  := v  * v;
      ui2 := ui * ui;
      vi2 := vi * vi;
      uui := u  * ui;
      vvi := v  * vi;

      // cubic functions
      Bx[0] :=     ui * ui2;
      Bx[1] := 3 * u  * ui2;
      Bx[2] := 3 * u2 * ui;
      Bx[3] :=     u2 * u;
      By[0] :=     vi * vi2;
      By[1] := 3 * v  * vi2;
      By[2] := 3 * v2 * vi;
      By[3] :=     v2 * v;

      // cubic partial derivatives
      dBx[0] :=         - 3 * ui2;
      dBx[1] := 3 * ui2 - 6 * uui;
      dBx[2] := 6 * uui - 3 * u2;
      dBx[3] :=           3 * u2;
      dBy[0] :=          -3 * vi2;
      dBy[1] := 3 * vi2 - 6 * vvi;
      dBy[2] := 6 * vvi - 3 * v2;
      dBy[3] :=           3 * v2;

      for yi := 0 to 3 do
        for xi := 0 to 3 do
        begin
          Pxy := P[xi, yi];
          dFdx := dFdx + dBx[xi] *  By[yi] * Pxy;
          dFdy := dFdy +  Bx[xi] * dBy[yi] * Pxy;
          Z    := Z    +  Bx[xi] *  By[yi] * Pxy;
        end;

    end;
  imLinear:
    begin
      // precalculated values
      ui := 1 - u;
      vi := 1 - v;

      // linear functions
      Bx[0] := ui;
      Bx[1] := u;
      By[0] := vi;
      By[1] := v;

      // linear partial derivatives
      dBx[0] := -1;
      dBx[1] := 1;
      dBy[0] := -1;
      dBy[1] := 1;

      for yi := 0 to 1 do
        for xi := 0 to 1 do
        begin
          Pxy := P[xi, yi];
          dFdx := dFdx + dBx[xi] *  By[yi] * Pxy;
          dFdy := dFdy +  Bx[xi] * dBy[yi] * Pxy;
          Z    := Z    +  Bx[xi] *  By[yi] * Pxy;
        end;
    end;
  end;//case

  // Calculate normal
  CrossProduct3D(Point3D(1, 0, dFdx), Point3D(0, 1, dFdy), Normal);
  NormalizeVector3D(Normal);

end;

procedure TsdGridMap.ProjectPoint(const Point: TsdPoint3D;
  SurfacePoint, Normal: PsdPoint3D; const Eps: double);
const
  cMaxIter = 30;
var
  Iter: integer;
  Surf, Norm, StoP, Perp, Tang, NewSurf: TsdPoint3D;
  Z, Err, NewErr: double;
  Damp: double;
begin
  if not assigned(SurfacePoint) then
    SurfacePoint := @Surf;
  if not assigned(Normal) then
    Normal := @Norm;

  // Normal position at point location
  SurfacePoint^ := Point;

  // Iterative process: repeat until the height difference is smaller than Eps
  Iter := 0;
  Damp := 1;

  // Calculate new normal and Z
  NormalAndZ(SurfacePoint.X, SurfacePoint.Y, Normal^, Z);

  // New surface point
  SurfacePoint.Z := Z;

  // For points ON the surface we need not go further
  if abs(Point.Z - Z) < Eps then
    exit;

  // Surface to point vector
  SubstractPoint3D(Point, SurfacePoint^, StoP);

  // error (error represents required distance along plane to go to correct point)
  CrossProduct3D(Normal^, StoP, Perp);
  Err := Length3D(Perp);

  // Tangent
  Crossproduct3D(Perp, Normal^, Tang);

  // Start the loop
  repeat

    // iterations check
    inc(Iter);
    if Iter > cMaxIter then
      raise Exception.Create(sTooManyIterationsInNormalProjection);

    // New surface point and normal
    AddScalePoint3D(SurfacePoint^, NewSurf, Tang, Damp);
    NormalAndZ(NewSurf.X, NewSurf.Y, Normal^, Z);
    NewSurf.Z := Z;

    // Surface to point vector (normalized)
    SubstractPoint3D(Point, NewSurf, StoP);

    // New angular error
    CrossProduct3D(Normal^, StoP, Perp);
    NewErr := Length3D(Perp);

    // Can we stop?
    if NewErr < Eps then
    begin
      SurfacePoint^ := NewSurf;
      exit;
    end;

    // Check the new error
    if NewErr < Err then
    begin

      // It improved, so we keep this point
      SurfacePoint^ := NewSurf;
      Crossproduct3D(Perp, Normal^, Tang);

      // Did new error improve enough? if not, reduce damping
      if NewErr > Err * 0.7 then
        Damp := Damp * 0.7;

      Err := NewErr;

    end else
    begin

      // It didn't improve.. we will reduce the damping and retry
      Damp := Damp * 0.5;

    end;

  until False;
end;

procedure TsdGridMap.SetArea(const XMin, YMin, XMax, YMax: double);
begin
  if (XMin <> FXMin) or (YMin <> FYMin) or (XMax <> FXMax) or (YMin <> FYMax) then
  begin
    FXmin := Min(XMin, XMax);
    FXmax := Max(XMin, XMax);
    FYmin := Min(YMin, YMax);
    FYmax := Max(YMin, YMax);
    SetUniformGrid(True);
  end;
end;

procedure TsdGridMap.SetGridSize(XSize, YSize: integer);
begin
  if (FGridXSize <> XSize) or (FGridYSize <> YSize) then
  begin
    FGridXSize := Max(1, XSize);
    FGridYSize := Max(1, YSize);
    SetLength(FGridPoints, (FGridXSize + 1) * (FGridYSize + 1));
    SetLength(FGridCells, FGridXSize * FGridYSize);
    SetUniformGrid(True);
    FIsGridValid := False;
  end;
end;

procedure TsdGridMap.SetGridXSize(const Value: integer);
begin
  SetGridSize(Value, FGridYSize);
end;

procedure TsdGridMap.SetGridYSize(const Value: integer);
begin
  SetGridSize(FGridXSize, Value);
end;

procedure TsdGridMap.SetGridZValue(Xindex, Yindex: integer;
  const Value: double);
var
  Idx: integer;
begin
  if (Xindex < 0) or (Xindex > FGridXSize) or (Yindex < 0) or (Yindex > FGridYSize) then
    exit;
  Idx := YIndex * (FGridXSize + 1) + Xindex;
  if FGridPoints[Idx] <> Value then
  begin
    FGridPoints[Idx] := Value;
    FIsGridValid := False;
  end;
end;

procedure TsdGridMap.SetUniformGrid(const Value: boolean);
var
  x, y: integer;
begin
  FUniformGrid := Value;
  FUniformXSpacing := (FXMax - FXMin) / FGridXSize;
  FUniformYSpacing := (FYMax - FYMin) / FGridYSize;
  if FUniformGrid then
  begin
    SetLength(FGridXPos, 0);
    SetLength(FGridYPos, 0);
  end else
  begin
    SetLength(FGridXPos, FGridXSize + 1);
    SetLength(FGridYPos, FGridYSize + 1);
    for x := 0 to FGridXSize - 1 do
      FGridXPos[x] := FXMin + x * FUniformXSpacing;
    FGridXPos[FGridXSize] := FXMax;
    for y := 0 to FGridYSize - 1 do
      FGridXPos[y] := FYMin + y * FUniformXSpacing;
    FGridYPos[FGridYSize] := FYMax;
  end;
end;

procedure TsdGridMap.ValidateGrid;
var
  x, y, i: integer;
  K: TsdKnotWeight;
begin
  // walk through all the grid cells and calculate the control point z values
  for y := 0 to FGridYSize - 1 do
    for x := 0 to FGridXSize - 1 do
    begin
      for i := 0 to 11 do
        K[i] := GridZValue[x + cKnotPos[i, 0], y + cKnotPos[i, 1]];
      ValidateGridCell(K, x, y, FGridCells[y * FGridXSize + x]);
    end;

  FIsGridValid := True;
end;

procedure TsdGridMap.ValidateGridCell(const K: TsdKnotWeight; Xind, Yind: integer;
  var P: TsdGridCell);

  // local
  procedure SetCPointEdge(var P: double; B, C, D: integer);
  begin
    P := c12 * K[B] + c23 * K[C] - c16 * K[D];
  end;
  // local
  procedure SetCPointCont(var P: double; A, B, C: integer);
  begin
    P := -c16 * K[A] + K[B] + c16 * K[C];
  end;
  // local
  procedure AddMul(var K: TsdKnotWeight; const C: double; const M: TsdKnotWeight);
  var
    i: integer;
  begin
    for i := 0 to 11 do
      K[i] := K[i] + C * M[i];
  end;
  // local
  procedure SetIntermediate(var P: double; const P00, P10, P01: double);
  begin
    P := -P00 + P01 + P10;
  end;
begin
  Fillchar(P, SizeOf(P), 0);

  case FInterpolationMethod of
  imLinear:
    begin
      // Corners
      P[0, 0] := K[3];
      P[1, 0] := K[4];
      P[0, 1] := K[7];
      P[1, 1] := K[8];
    end;
  imCubic:
    begin
      // Corners
      P[0, 0] := K[3];
      P[3, 0] := K[4];
      P[0, 3] := K[7];
      P[3, 3] := K[8];

      // Horizontal edges
      if FGridXSize = 1 then
      begin
        P[1, 0] := c23 * K[3] + c13 * K[4];
        P[2, 0] := c13 * K[3] + c23 * K[4];
        P[1, 3] := c23 * K[7] + c13 * K[8];
        P[2, 3] := c13 * K[7] + c23 * K[8];
      end else
      begin
        if Xind = 0 then
        begin
          SetCPointEdge(P[1, 0], 3, 4, 5);
          SetCPointEdge(P[1, 3], 7, 8, 9);
        end else
        begin
          SetCPointCont(P[1, 0], 2, 3, 4);
          SetCPointCont(P[1, 3], 6, 7, 8);
        end;
        if Xind = FGridXSize - 1 then
        begin
          SetCPointEdge(P[2, 0], 4, 3, 2);
          SetCPointEdge(P[2, 3], 8, 7, 6);
        end else
        begin
          SetCPointCont(P[2, 0], 5, 4, 3);
          SetCPointCont(P[2, 3], 9, 8, 7);
        end;
      end;

      // Vertical edges
      if FGridYSize = 1 then
      begin
        P[0, 1] := c23 * K[3] + c13 * K[7];
        P[0, 2] := c13 * K[3] + c23 * K[7];
        P[3, 1] := c23 * K[4] + c13 * K[8];
        P[3, 2] := c13 * K[4] + c13 * K[8];
      end else
      begin
        if Yind = 0 then
        begin
          SetCPointEdge(P[0, 1], 3, 7, 10);
          SetCPointEdge(P[3, 1], 4, 8, 11);
        end else
        begin
          SetCPointCont(P[0, 1], 0, 3, 7);
          SetCPointCont(P[3, 1], 1, 4, 8);
        end;
        if Yind = FGridYSize - 1 then
        begin
          SetCPointEdge(P[0, 2], 7, 3, 0);
          SetCPointEdge(P[3, 2], 8, 4, 1);
        end else
        begin
          SetCPointCont(P[0, 2], 10, 7, 3);
          SetCPointCont(P[3, 2], 11, 8, 4);
        end;
      end;

      // Internal points
      SetIntermediate(P[1,1], P[0,0], P[1,0], P[0,1]);
      SetIntermediate(P[2,1], P[3,0], P[2,0], P[3,1]);
      SetIntermediate(P[1,2], P[0,3], P[1,3], P[0,2]);
      SetIntermediate(P[2,2], P[3,3], P[2,3], P[3,2]);
    end;
  end;//case

end;

function TsdGridMap.ZValue(const X, Y: double): double;
var
  xi, yi, Xindex, Yindex: integer;
  u, v, ui, vi, u2, v2, ui2, vi2: double;
  P: PsdGridCell;
  Bx, By: array[0..3] of double;
  // local
  function GetIdx(X, Y: integer): integer;
  begin
    Result := Y * (FGridXSize + 1) + X;
  end;
// main
begin
  // Validate grid if neccesary (calculate control points)
  if not FIsGridValid then
    ValidateGrid;

  // Get indices and fractions
  GetXIndexAndFraction(X, Xindex, u);
  GetYIndexAndFraction(Y, Yindex, v);

  Result := 0;
  P := @FGridCells[Yindex * FGridXSize + Xindex];
  case FInterpolationMethod of
  imCubic:
    begin
      // Precalculated constants
      ui  := 1 - u;
      vi  := 1 - v;
      u2  := u  * u;
      v2  := v  * v;
      ui2 := ui * ui;
      vi2 := vi * vi;

      Bx[0] :=     ui * ui2;
      Bx[1] := 3 * u  * ui2;
      Bx[2] := 3 * u2 * ui;
      Bx[3] :=     u2 * u;
      By[0] :=     vi * vi2;
      By[1] := 3 * v  * vi2;
      By[2] := 3 * v2 * vi;
      By[3] :=     v2 * v;
      for yi := 0 to 3 do
        for xi := 0 to 3 do
          Result := Result + Bx[xi] * By[yi] * P[xi, yi];
    end;
  imLinear:
    begin
      ui := 1 - u;
      vi := 1 - v;
      Result :=
        P[0, 0] * ui * vi +
        P[1, 0] * u  * vi +
        P[0, 1] * ui * v  +
        P[1, 1] * u  * v;
    end;
  end;//case
end;

const
  // Each cell defined as 4 cornerpoints (0, 1, 2, 3) and 4 edge points (4, 5, 6, 7)
  //
  // 0 -- 4 -- 1
  // |         |
  // 5         6
  // |         |
  // 2 -- 7 -- 3
  //
  // cMeshConstruct table lists 16 + 1 pby's for which triangles will be added,
  // the index depends on the inside state of corners 0..3. For instance, if
  // points 0 and 1 are outside and point 2 and 3 inside (0011), two triangles
  // will be added (3->2->5) and (6->3->5).
  cMeshConstruct: array[0..16] of TMeshConstruct =
    ((Num: 0; Tri: ((0, 0, 0), (0, 0, 0), (0, 0, 0))), // 0000
     (Num: 1; Tri: ((6, 3, 7), (0, 0, 0), (0, 0, 0))), // 0001
     (Num: 1; Tri: ((7, 2, 5), (0, 0, 0), (0, 0, 0))), // 0010
     (Num: 2; Tri: ((3, 2, 5), (6, 3, 5), (0, 0, 0))), // 0011
     (Num: 1; Tri: ((4, 1, 6), (0, 0, 0), (0, 0, 0))), // 0100
     (Num: 2; Tri: ((4, 1, 3), (7, 4, 3), (0, 0, 0))), // 0101
     (Num: 2; Tri: ((7, 2, 5), (4, 1, 6), (0, 0, 0))), // 0110
     (Num: 3; Tri: ((3, 2, 5), (1, 3, 5), (4, 1, 5))), // 0111
     (Num: 1; Tri: ((5, 0, 4), (0, 0, 0), (0, 0, 0))), // 1000
     (Num: 2; Tri: ((5, 0, 4), (6, 3, 7), (0, 0, 0))), // 1001
     (Num: 2; Tri: ((2, 0, 4), (7, 2, 4), (0, 0, 0))), // 1010
     (Num: 3; Tri: ((2, 0, 4), (3, 2, 4), (6, 3, 4))), // 1011
     (Num: 2; Tri: ((5, 0, 1), (6, 5, 1), (0, 0, 0))), // 1100
     (Num: 3; Tri: ((5, 0, 1), (3, 5, 1), (7, 5, 3))), // 1101
     (Num: 3; Tri: ((7, 2, 0), (1, 7, 0), (6, 7, 1))), // 1110
     (Num: 2; Tri: ((3, 2, 0), (1, 3, 0), (0, 0, 0))), // 1111
     (Num: 2; Tri: ((2, 0, 1), (3, 2, 1), (0, 0, 0))));// 1111 other sense

{ TsdMeshGenerator }

procedure TsdMeshGenerator.GenerateMesh(AGridMap: TsdGridMap;
  AMesh: TsdTriangleMesh3D; AClipPoly: PsdPoint3DArray; AClipPolyCount: integer;
  ACellXSize, ACellYSize: double; AExactFit: boolean);
type
  // MeshPoints are layed out like this:
  //
  //   0 ... MeshXSize
  //   .
  //   .
  // MeshYSize
  //
  // There are in total (MeshXSize + 1) * (MeshYSize + 1) meshpoints
  // Each meshpoint cell points to the upperleft vertex, the upper horizontal
  // edge vertex and the left vertical edge vertex. If Included is true, the
  // cell is part of the mesh to generate.
  TMeshPointInfo = record
    Included: boolean;
    Vertex: integer;
    HorEdge: integer;
    VerEdge: integer;
  end;
var
  i, j, x, y, xi, yi, Idx, ClipIdx: integer;
  VtxIdx: array[0..2] of integer;
  V: array[0..2] of TsdPoint3D;
  MeshXSize, MeshYSize: integer;
  MeshPoint: array of TMeshPointInfo;
  Clips: TsdDynArrayOfTsdPoint3D;
  XPos, YPos: double;
  Edge, Add: boolean;
  // local
  function MeshPointIndex(x, y: integer): integer;
  begin
    Result := y * (MeshXSize + 1) + x;
  end;
  // local
  function VertexAdd(xf, yf: double): integer;
  var
    Normal: TsdPoint3D;
    Z: double;
  begin
    AGridMap.NormalAndZ(xf, yf, Normal, Z);
    Result := AMesh.VertexAdd(xf, yf, Z, Normal.X, Normal.Y, Normal.Z);
  end;
  // local
  function GetVertexIndex(x, y, vtx: integer): integer;
  begin
    case vtx of
    0: Result := MeshPoint[MeshPointIndex(x    , y    )].Vertex;
    1: Result := MeshPoint[MeshPointIndex(x + 1, y    )].Vertex;
    2: Result := MeshPoint[MeshPointIndex(x    , y + 1)].Vertex;
    3: Result := MeshPoint[MeshPointIndex(x + 1, y + 1)].Vertex;
    4: Result := MeshPoint[MeshPointIndex(x    , y    )].HorEdge;
    5: Result := MeshPoint[MeshPointIndex(x    , y    )].VerEdge;
    6: Result := MeshPoint[MeshPointIndex(x + 1, y    )].VerEdge;
    7: Result := MeshPoint[MeshPointIndex(x    , y + 1)].HorEdge;
    else
      Result := -1;
    end;//case
  end;
// main
begin
  AMesh.Clear;

  // Number of cells in mesh
  MeshXSize := round(AGridMap.GetWidth / ACellXSize);
  MeshYSize := round(AGridMap.GetHeight / ACellYSize);

  // Initialize meshpoint array
  SetLength(MeshPoint, (MeshXSize + 1) * (MeshYSize + 1));
  for i := 0 to length(MeshPoint) - 1 do with Meshpoint[i] do
  begin
    Vertex  := -1;
    HorEdge := -1;
    VerEdge := -1;
  end;

  // Do we have a clipping polygon?
  if assigned(AClipPoly) then
  begin

    // Determine for each mesh point the corner vertices and horizontal edges
    for y := 0 to MeshYSize do
    begin
      YPos := AGridMap.FYMin + y * ACellYSize;

      // find intersections with ClipPoly
      IntersectPolyAndPlane(AClipPoly, AClipPolyCount, cYAxis3D, YPos, Clips);
      if length(Clips) = 0 then
        continue;

      // Sort intersections by X
      SortPoints3D(@Clips[0], length(Clips), cXAxis3D);

      // Count the intersections, and use even-odd rule to determine insideness
      ClipIdx := 0;
      Edge := False;
      for x := 0 to MeshXSize do
      begin
        XPos := AGridMap.FXMin + x * ACellXSize;
        while (ClipIdx < length(Clips)) and (Clips[ClipIdx].X < XPos) do
        begin
          inc(ClipIdx);
          Edge := not Edge;
        end;
        if odd(ClipIdx) then
        begin
          MeshPoint[MeshPointIndex(x, y)].Vertex := VertexAdd(XPos, YPos);
          MeshPoint[MeshPointIndex(x, y)].Included := True;
        end;
        if Edge then
        begin
          if (x > 0) and AExactFit then
            MeshPoint[MeshPointIndex(x - 1, y)].HorEdge := VertexAdd(Clips[ClipIdx - 1].X, YPos);
          Edge := False;
        end;
      end;
    end;

    // Determine for each mesh point the vertical edges
    for x := 0 to MeshXSize do
    begin
      XPos := AGridMap.FXMin + x * ACellXSize;

      // find intersections with ClipPoly
      IntersectPolyAndPlane(AClipPoly, AClipPolyCount, cXAxis3D, XPos, Clips);
      if length(Clips) = 0 then
        continue;

      // Sort intersections by X
      SortPoints3D(@Clips[0], length(Clips), cYAxis3D);

      // Count the intersections, and use even-odd rule to determine insideness
      ClipIdx := 0;
      Edge := False;
      for y := 0 to MeshYSize do
      begin
        YPos := AGridMap.FYMin + y * ACellYSize;
        while (ClipIdx < length(Clips)) and (Clips[ClipIdx].Y < YPos) do
        begin
          inc(ClipIdx);
          Edge := not Edge;
        end;
        if Edge then
        begin
          if (y > 0) and AExactFit then
            MeshPoint[MeshPointIndex(x, y - 1)].VerEdge := VertexAdd(XPos, Clips[ClipIdx - 1].Y);
          Edge := False;
        end;
      end;
    end;
  end else
  begin

    // All inside
    for y := 0 to MeshYSize do
    begin
      YPos := AGridMap.FYMin + y * ACellYSize;
      for x := 0 to MeshXSize do
      begin
        XPos := AGridMap.FXMin + x * ACellXSize;
        MeshPoint[MeshPointIndex(x, y)].Vertex := VertexAdd(XPos, YPos);
      end;
    end;

  end;;

  // add triangles for mesh cells
  for y := 0 to MeshYSize - 1 do
    for x := 0 to MeshXSize - 1 do
    begin

      // Determine index into cMeshConstruct
      Idx := 0;
      if MeshPoint[MeshPointIndex(x    , y    )].Included then
        inc(Idx, 8);
      if MeshPoint[MeshPointIndex(x + 1, y    )].Included then
        inc(Idx, 4);
      if MeshPoint[MeshPointIndex(x    , y + 1)].Included then
        inc(Idx, 2);
      if MeshPoint[MeshPointIndex(x + 1, y + 1)].Included then
        inc(Idx, 1);

      // Not exact: always full cell
      if not AExactFit and (Idx > 0) then
        Idx := 15;

      // Toggle left/right and right/left triangles for full cells
      if (Idx = 15) and odd(x + y) then
        inc(Idx);

      if AExactFit then
      begin

        // Exact fit: we will add triangles along the cut
        with cMeshConstruct[Idx] do
        begin
          for i := 0 to Num - 1 do
          begin
            for j := 0 to 2 do
              VtxIdx[j] := GetVertexIndex(x, y, Tri[i, j]);
            if (VtxIdx[0] >= 0) and (VtxIdx[1] >= 0) and (VtxIdx[2] >= 0) then
            begin
              AMesh.TriangleAdd(VtxIdx[0], VtxIdx[1], VtxIdx[2]);
            end;
          end;
        end;

      end else
      begin

        // Non-exact: we will add whole triangles wherever the polygon covers
        if Idx > 0 then
        begin
          // Add missing points
          for xi := 0 to 1 do
            for yi := 0 to 1 do
              if MeshPoint[MeshPointIndex(x + xi, y + yi)].Vertex < 0 then
                MeshPoint[MeshPointIndex(x + xi, y + yi)].Vertex :=
                  VertexAdd(AGridMap.FXMin + (x + xi) * ACellXSize,
                            AGridMap.FYMin + (y + yi) * ACellYSize);
          // Add two triangles
          with cMeshConstruct[Idx] do
          begin
            for i := 0 to Num - 1 do
            begin
              for j := 0 to 2 do
                VtxIdx[j] := GetVertexIndex(x, y, Tri[i, j]);
              if (VtxIdx[0] >= 0) and (VtxIdx[1] >= 0) and (VtxIdx[2] >= 0) then
              begin
                AMesh.TriangleAdd(VtxIdx[0], VtxIdx[1], VtxIdx[2]);
              end;
            end;
          end;
        end;

      end;
    end;

end;

end.

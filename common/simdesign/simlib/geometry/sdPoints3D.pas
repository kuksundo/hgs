unit sdPoints3D;
{
  Description:
  Basic routines for working with 3D points and pointlists.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 23Jul2002

  Modifications:

  copyright (c) 2002 - 2010 SimDesign B.V.
}

interface

uses
  Classes, SysUtils, Math;

type

  // 3D point
  TsdPoint3D = record
    case byte of
    0: (X, Y, Z: double);
    1: (Elem: array[0..2] of double);
  end;
  PsdPoint3D = ^TsdPoint3D;
  TsdPoint3DArray = array[0.. MaxInt div SizeOf(TsdPoint3D) - 1] of TsdPoint3D;
  PsdPoint3DArray = ^TsdPoint3DArray;
  TsdPoint3DDynArray = array of TsdPoint3D;

  TsdVector4D = record
    case byte of
    0: (X, Y, Z, W: double);
    1: (Elem: array[0..3] of double);
  end;
  PsdVector4D = ^TsdVector4D;

  TsdPoint3DList = record
    Points: PsdPoint3D;
    Count: integer;
  end;
  PsdPoint3DList = ^TsdPoint3DList;

  TsdPose3D = record
    case byte of
    0: (X, Y, Z, A, B, C: double);
    1: (Elem: array[0..5] of double);
  end;
  PsdPose3D = ^TsdPose3D;

  // Matrix with 3 rows and 4 columns used for transformations
  TsdMatrix3x4 = array[0..2, 0..3] of double;
  PsdMatrix3x4 = ^TsdMatrix3x4;

  TsdBox3D = record
    case byte of
    0: (XMin,YMin,ZMin,XMax,YMax,ZMax: double);
    1: (Min: TsdPoint3D; Max: TsdPoint3D);
  end;
  PsdBox3D = ^TsdBox3D;

  TsdAxisSpec3D = (
    caXAxis,
    caYAxis,
    caZAxis
  );

  // Simple class to deal with lists of integers. Integer lists are often used
  // as indices in vertex arrays
  TsdIntegerList = class(TPersistent)
  private
    FCount: integer;
    FValues: array of integer;
    function GetValues(Index: integer): integer;
  public
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    // Add one integer value to the list
    procedure Add(AValue: integer);
    // Add 3 integer values to the list
    procedure Add3(V1, V2, V3: integer);
    // Delete the integer at AIndex
    procedure Delete(AIndex: integer);
    property Count: integer read FCount;
    property Values[Index: integer]: integer read GetValues; default;
  end;

  // Simple class to deal with a list of 3D points (polygon3D)
  TsdPolygon3D = class(TPersistent)
  private
    FCount: integer;
    FPoints: array of TsdPoint3D;
    function GetPoints(Index: integer): PsdPoint3D;
  public
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Add(const APoint: TsdPoint3D);
    procedure AddWithBreakupLength(const APoint: TsdPoint3D;
      const BreakupLength: double; IncludeLast: boolean);
    function First: PsdPoint3D;
    function Last: PsdPoint3D;
    // Delete the point at AIndex
    procedure Delete(AIndex: integer);
    // Delete duplicate consecutive points (if within AEps)
    procedure DeleteDuplicates(const AEps: double);
    property Count: integer read FCount;
    property Points[Index: integer]: PsdPoint3D read GetPoints;
  end;

const

  // Identity matrix
  cIdentityMatrix3x4: TsdMatrix3x4 =
   ((1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0));

  cNullMatrix3x4: TsdMatrix3x4 =
   ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0));

  cXAxis3D: TsdPoint3D = (X: 1; Y: 0; Z: 0);
  cYAxis3D: TsdPoint3D = (X: 0; Y: 1; Z: 0);
  cZAxis3D: TsdPoint3D = (X: 0; Y: 0; Z: 1);

  cZero3D: TsdPoint3D  = (X: 0; Y: 0; Z: 0);

  cNullPose: TsdPose3D = (X: 0; Y: 0; Z: 0; A: 0; B: 0; C: 0);

// Creation functions

function Point3D(const X, Y, Z: double): TsdPoint3D;

// Basic linear algebra

// Calculate the cross product of Vec1 and Vec2, and put in Result:
// Result = Vec1 x Vec2. The procedure is safewarded against inplace overwrite
// (or in other words, Result can be Vec1 or Vec2).
procedure CrossProduct3D(const Vec1, Vec2: TsdPoint3D; var Result: TsdPoint3D);
function Cross3(const Vec1, Vec2: TsdPoint3D): TsdPoint3D;

// Calculate the dot product of Vec1 and Vec2, and put in Result:
// Result = Vec1 * Vec2
function DotProduct3D(const Vec1, Vec2: TsdPoint3D): double;

// Flip the direction of the vector
procedure FlipVector3D(var Vec: TsdPoint3D);

// Normalize the vector, so that it's length becomes 1
procedure NormalizeVector3D(var Vec: TsdPoint3D);
function Normalize3(const Vec: TsdPoint3D): TsdPoint3D;

// Calculate the length: sqrt(X^2 + Y^2 + Z^2) of APoint
function Length3D(const APoint: TsdPoint3D): double;

// Calculate the squared length: X^2 + Y^2 + Z^2 of APoint
function SquaredLength3D(const APoint: TsdPoint3D): double;

// Multiply matrices: Result = A * B
function MultiplyMatrix3x4(const A, B: TsdMatrix3x4): TsdMatrix3x4;

// Compare points A and B and return true if equal
function PtsEqual3D(const A, B: TsdPoint3D; const Eps: double = 1E-12): boolean;

// Distance between point A and B
function Dist3D(const A, B: TsdPoint3D): double;

// Squared distance between point A and B
function SquaredDist3D(const A, B: TsdPoint3D): double;

// Compare the distance between A and B with the Dist parameter. if |A-B| <= Dist the
// function returns True.
function CompareDist3D(const A, B: TsdPoint3D; const Dist: double): boolean;

// Scale the point so that X = Scale * X etc.
procedure ScalePoint3D(var Point: TsdPoint3D; const Scale: double);

// add points: Result = A + B
procedure AddPoint3D(const A, B: TsdPoint3D; var Result: TsdPoint3D);

// Result := A + Normal * Scale
procedure AddScalePoint3D(const A: TsdPoint3D; var Result: TsdPoint3D; const Normal: TsdPoint3D; const Scale: double);

// Substract points: Result = A - B
procedure SubstractPoint3D(const A, B: TsdPoint3D; var Result: TsdPoint3D);

// Substract points Result = A - B in pointlist
procedure SubstractPoints3D(A, B, Result: PsdPoint3D; PointCount: integer);

// Calculate Delta = B - A, put in Result
function Delta3D(const A, B: TsdPoint3D): TsdPoint3D;

// Calculate Result = B - A / |B - A|
procedure NormalizedDelta3D(const A, B: TsdPoint3D; var Result: TsdPoint3D);

// Interpolation between points P0 and P1, using fraction xf, result in Result.
// if xf = 0, Result will be P0, if xf = 1, Result will be P1.
procedure Interpolation3D(const P0, P1: TsdPoint3D; const xf: double; var Result: TsdPoint3D);

// Bilinear interpoation between points P0-P1-P2-P3, using fractions xf and yf.
// First, the intermediate point M0 between P0 and P1 is found using xf, then
// the point M1 between P2 and P3 using xf, then the point Result is found
// between M0 and M1 using yf.
procedure BilinearInterpolation3D(const P0, P1, P2, P3: TsdPoint3D; const xf, yf: double; var Result: TsdPoint3D);

// Area of triangle P0,P1,P2 (absolute value)
function TriangleArea3D(const P0, P1, P2: TsdPoint3D): double;

// Bounding box

// Calculate the bounding box for the points in the list
function BoundingBox3D(Points: PsdPoint3D; PointCount: integer): TsdBox3D;

// Update the bounding box ABox with APoint. If IsFirst, the bounding box min/max
// will be set to the initial point, and IsFirst will be set to false
procedure UpdateBox3D(const APoint: TsdPoint3D; var ABox: TsdBox3D; var IsFirst: boolean);

// Transform the 8 box corner points with ATransform, and create a new bounding box
// around them
function TransformBox3D(const ABox: TsdBox3D; const ATransform: TsdMatrix3x4): TsdBox3D;

// Combine bounding boxes B1 and B2
function CombineBox3D(const B1, B2: TsdBox3D): TsdBox3D;

// Point transformations

// Transform Source point to Dest point using the transform Trans
procedure TransformPoint(const Source: TsdPoint3D; var Dest: TsdPoint3D; const Trans: TsdMatrix3x4);

// Transform Source pose (XYZABC) to Dest pose (XYZABC) using transform Trans
procedure PostTransformPose(const Source: TsdPose3D; var Dest: TsdPose3D; const Trans: TsdMatrix3x4);
procedure PreTransformPose(const Source: TsdPose3D; var Dest: TsdPose3D; const Trans: TsdMatrix3x4);

// Transform source vector direction to dest vector direction using transform Trans
procedure TransformDirection(const Source: TsdPoint3D; var Dest: TsdPoint3D; const Trans: TsdMatrix3x4);

// Transform point list in Source to pointlist in Dest using the transform Trans. There is a check
// to ensure that in-place transforms (Source = Dest) are allowed
procedure TransformPoints(Source, Dest: PsdPoint3D; PointCount: integer; const Trans: TsdMatrix3x4);

// Sort the points in the array along the Axis given, in ascending order
procedure SortPoints3D(Points: PsdPoint3DArray; Count: integer; const Axis: TsdPoint3D);

function AveragePoints3D(Points: PsdPoint3DArray; Count: integer): TsdPoint3D;

// Affine Transformation matrices

// Translate matrix A to At over distance Dist (pre-multiplied)
procedure TranslateMatrix3x4(const A: TsdMatrix3x4; var At: TsdMatrix3x4; Dist: TsdPoint3D);

// Convert Euler pose description to transform matrix.
// X, Y, Z: the translation defined in the pose
// A, B, C: the Euler angles (A= rotation around X, B= rotation around Y, C= rotation around Z)
// The order of rotation is first C, then B, then A.
// Note: A, B and C are defined in radians.
procedure PoseToTransformMatrix(const X, Y, Z, A, B, C: double; var Trans: TsdMatrix3x4); overload;
procedure PoseToTransformMatrix(const Pose: TsdPose3D; var Trans: TsdMatrix3x4); overload;

// Convert an orthogonal transform matrix to a pose, defining translations X, Y, Z
// and Euler angles A, B, C.
procedure TransformMatrixToPose(const Trans: TsdMatrix3x4; var X, Y, Z, A, B, C: double); overload;
procedure TransformMatrixToPose(const Trans: TsdMatrix3x4; var Pose: TsdPose3D); overload;

// Create a transformation to a new frame, based on three orthogonal unit vectors, namely
// Vec1, Vec2, Vec3. Only Vec1 and Vec2 have to be provided. If Vec2 is not orthogonal
// to Vec1 it will be adjusted. Axis1 and Axis2 indices indicate which coordinate
// axes the Vec1 and Vec2 vectors indicate.
// Example: create a transformation to a frame with new up vector (0.1, 0.2, 0.9),
// and the new X-axis aligned with the current X-axis:
// A := TrasformMatrixFromTwoVectors(Point3D(0.1, 0.2, 0.9), cXAxis3D, caZaxis,
// caXaxis).
function TransformMatrixFromTwoVectors(Vec1, Vec2: TsdPoint3D;
  Axis1, Axis2: TsdAxisSpec3D): TsdMatrix3x4;

// Calculate the inverse of the matrix A and put the result in Ai. Matrix A's
// rotational part must be orthonormal.
procedure OrthoMatrix3x4Inverse(const A: TsdMatrix3x4; var Ai: TsdMatrix3x4);

// Calculate the inverse of the matrix A and put the result in Ai. When the
// matrix is singular, an exception will be raised
procedure Matrix3x4Inverse(A: TsdMatrix3x4; var Ai: TsdMatrix3x4);

// Create a translation matrix
function TranslationMatrix(const X, Y, Z: double): TsdMatrix3x4;

// Create a rotation matrix, around axis (i,j,k) with angle Alpha
// Note: i,j,k must be normalized!
function RotationMatrixAxis(const i, j, k, Alpha: double): TsdMatrix3x4;

// Create a scaling matrix with S on the diagonals
function UniformScalingMatrix(const S: double): TsdMatrix3x4;

// Create a scaling matrix with Sx Sy Sz on the diagonals
function ScalingMatrix(const Sx, Sy, Sz: double): TsdMatrix3x4;

function MatricesEqual(const A, B: TsdMatrix3x4): boolean;

// export functions

// Print the matrix as string.
function Matr3x4ToString(const M: TsdMatrix3x4): string;

// Print point to string
function Point3DToString(const P: TsdPoint3D; const Scale: double = 1; const Fmt: string = '%7.4f'): string;

// Print box to string
function Box3DToString(const B: TsdBox3D; const Scale: double): string;


resourcestring

  sAxesCannotBeEqual          = 'Axes cannot be equal';
  sErrInverseMatrixIsSingular = 'Inverse matrix is singular';

implementation

function Point3D(const X, Y, Z: double): TsdPoint3D;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
end;

procedure CrossProduct3D(const Vec1, Vec2: TsdPoint3D; var Result: TsdPoint3D);
var
  Res: TsdPoint3D;
begin
  // Avoid inplace overwrite
  Res.X := Vec1.Y * Vec2.Z - Vec1.Z * Vec2.Y;
  Res.Y := Vec1.Z * Vec2.X - Vec1.X * Vec2.Z;
  Res.Z := Vec1.X * Vec2.Y - Vec1.Y * Vec2.X;
  Result := Res;
end;

function Cross3(const Vec1, Vec2: TsdPoint3D): TsdPoint3D;
begin
  Result.X := Vec1.Y * Vec2.Z - Vec1.Z * Vec2.Y;
  Result.Y := Vec1.Z * Vec2.X - Vec1.X * Vec2.Z;
  Result.Z := Vec1.X * Vec2.Y - Vec1.Y * Vec2.X;
end;

function DotProduct3D(const Vec1, Vec2: TsdPoint3D): double;
begin
  Result := Vec1.X * Vec2.X + Vec1.Y * Vec2.Y + Vec1.Z * Vec2.Z;
end;

procedure FlipVector3D(var Vec: TsdPoint3D);
begin
  Vec.X := -Vec.X;
  Vec.Y := -Vec.Y;
  Vec.Z := -Vec.Z;
end;

procedure NormalizeVector3D(var Vec: TsdPoint3D);
var
  L: double;
begin
  L := Length3D(Vec);
  if L > 0 then
  begin
    L := 1/L;
    Vec.X := Vec.X * L;
    Vec.Y := Vec.Y * L;
    Vec.Z := Vec.Z * L;
  end else
    // Avoid exception in this lowlevel function, just set it to pointing up
    Vec := cZAxis3D;
end;

function Normalize3(const Vec: TsdPoint3D): TsdPoint3D;
var
  L: double;
begin
  L := Length3D(Vec);
  if L > 0 then
  begin
    L := 1/L;
    Result.X := Vec.X * L;
    Result.Y := Vec.Y * L;
    Result.Z := Vec.Z * L;
  end else
    // Avoid exception in this lowlevel function, just set it to pointing up
    Result := cZAxis3D;
end;

function Length3D(const APoint: TsdPoint3D): double;
begin
  Result := Sqrt(SquaredLength3D(APoint));
end;

function SquaredLength3D(const APoint: TsdPoint3D): double;
begin
  Result := Sqr(APoint.X) + Sqr(APoint.Y) + Sqr(APoint.Z);
end;

function CompareDist3D(const A, B: TsdPoint3D; const Dist: double): boolean;
var
  Dx, Dy, Dz: double;
begin
  Result := False;

  // Each of the axes bigger?
  Dx := abs(B.X - A.X);
  if Dx > Dist then exit;
  Dy := abs(B.Y - A.Y);
  if Dy > Dist then exit;
  Dz := abs(B.Z - A.Z);
  if Dz > Dist then exit;

  // "Taxicab" distance
  if Dx + Dy + Dz <= Dist then
  begin
    Result := True;
    exit;
  end;

  // Twilight zone: expensive test
  Result := Dx * Dx + Dy * Dy + Dz * Dz <= Dist * Dist;
end;

function MultiplyMatrix3x4(const A, B: TsdMatrix3x4): TsdMatrix3x4;
begin
  Result[0, 0] := A[0, 0] * B[0, 0] + A[0, 1] * B[1, 0] + A[0, 2] * B[2, 0];
  Result[0, 1] := A[0, 0] * B[0, 1] + A[0, 1] * B[1, 1] + A[0, 2] * B[2, 1];
  Result[0, 2] := A[0, 0] * B[0, 2] + A[0, 1] * B[1, 2] + A[0, 2] * B[2, 2];
  Result[0, 3] := A[0, 0] * B[0, 3] + A[0, 1] * B[1, 3] + A[0, 2] * B[2, 3] + A[0, 3];
  Result[1, 0] := A[1, 0] * B[0, 0] + A[1, 1] * B[1, 0] + A[1, 2] * B[2, 0];
  Result[1, 1] := A[1, 0] * B[0, 1] + A[1, 1] * B[1, 1] + A[1, 2] * B[2, 1];
  Result[1, 2] := A[1, 0] * B[0, 2] + A[1, 1] * B[1, 2] + A[1, 2] * B[2, 2];
  Result[1, 3] := A[1, 0] * B[0, 3] + A[1, 1] * B[1, 3] + A[1, 2] * B[2, 3] + A[1, 3];
  Result[2, 0] := A[2, 0] * B[0, 0] + A[2, 1] * B[1, 0] + A[2, 2] * B[2, 0];
  Result[2, 1] := A[2, 0] * B[0, 1] + A[2, 1] * B[1, 1] + A[2, 2] * B[2, 1];
  Result[2, 2] := A[2, 0] * B[0, 2] + A[2, 1] * B[1, 2] + A[2, 2] * B[2, 2];
  Result[2, 3] := A[2, 0] * B[0, 3] + A[2, 1] * B[1, 3] + A[2, 2] * B[2, 3] + A[2, 3];
end;

function PtsEqual3D(const A, B: TsdPoint3D; const Eps: double = 1E-12): boolean;
begin
  Result := (abs(A.X - B.X) + abs(A.Y - B.Y) + abs(A.Z - B.Z)) <= Eps;
end;

function Dist3D(const A, B: TsdPoint3D): double;
begin
  Result := sqrt(SquaredDist3D(A, B));
end;

function SquaredDist3D(const A, B: TsdPoint3D): double;
begin
  Result := sqr(A.X - B.X) + sqr(A.Y - B.Y) + sqr(A.Z - B.Z);
end;

procedure ScalePoint3D(var Point: TsdPoint3D; const Scale: double);
begin
  Point.X := Scale * Point.X;
  Point.Y := Scale * Point.Y;
  Point.Z := Scale * Point.Z;
end;

procedure AddPoint3D(const A, B: TsdPoint3D; var Result: TsdPoint3D);
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
end;

procedure AddScalePoint3D(const A: TsdPoint3D; var Result: TsdPoint3D; const Normal: TsdPoint3D; const Scale: double);
begin
  Result.X := A.X + Normal.X * Scale;
  Result.Y := A.Y + Normal.Y * Scale;
  Result.Z := A.Z + Normal.Z * Scale;
end;

procedure SubstractPoint3D(const A, B: TsdPoint3D; var Result: TsdPoint3D);
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
end;

procedure SubstractPoints3D(A, B, Result: PsdPoint3D; PointCount: integer);
var
  i: integer;
begin
  for i := 0 to PointCount - 1 do
  begin
    SubstractPoint3D(A^, B^, Result^);
    inc(A);
    inc(B);
    inc(Result);
  end;
end;

function Delta3D(const A, B: TsdPoint3D): TsdPoint3D;
begin
  Result.X := B.X - A.X;
  Result.Y := B.Y - A.Y;
  Result.Z := B.Z - A.Z;
end;

procedure NormalizedDelta3D(const A, B: TsdPoint3D; var Result: TsdPoint3D);
begin
  Result := Delta3D(A, B);
  NormalizeVector3D(Result);
end;

procedure Interpolation3D(const P0, P1: TsdPoint3D; const xf: double; var Result: TsdPoint3D);
var
  xf1: double;
begin
  xf1 := 1 - xf;
  Result.X := P0.X * xf1 + P1.X * xf;
  Result.Y := P0.Y * xf1 + P1.Y * xf;
  Result.Z := P0.Z * xf1 + P1.Z * xf;
end;

procedure BilinearInterpolation3D(const P0, P1, P2, P3: TsdPoint3D; const xf, yf: double; var Result: TsdPoint3D);
// Bilinear interpoation between points P0-P1-P2-P3, using fractions xf and yf.
// P must contain an array of pointers to 4 points. first, the intermediate point M0
// between P0 and P1 is found using xf, then the point M1 between P2 and P3 using xf,
// then the point Result is found between M0 and M1 using yf.
var
  M0, M1: TsdPoint3D;
begin
  Interpolation3D(P0, P1, xf, M0);
  Interpolation3D(P2, P3, xf, M1);
  Interpolation3D(M0, M1, yf, Result);
end;

function TriangleArea3D(const P0, P1, P2: TsdPoint3D): double;
var
  CP: TsdPoint3D;
begin
  CrossProduct3D(Delta3D(P0, P1), Delta3D(P0, P2), CP);
  Result := 0.5 * Length3D(CP);
end;

function BoundingBox3D(Points: PsdPoint3D; PointCount: integer): TsdBox3D;
var
  i: integer;
  IsFirst: boolean;
begin
  FillChar(Result, SizeOf(Result), 0);
  IsFirst := True;
  for i := 0 to PointCount - 1 do
  begin
    UpdateBox3D(Points^, Result, IsFirst);
    inc(Points);
  end;
end;

procedure UpdateBox3D(const APoint: TsdPoint3D; var ABox: TsdBox3D; var IsFirst: boolean);
// Update the bounding box ABox with APoint. If IsFirst, the bounding box min/max
// will be set to the initial point, and IsFirst will be set to false
begin
  if IsFirst then
  begin
    ABox.Min := APoint;
    ABox.Max := APoint;
    IsFirst := False;
  end else
  begin
    ABox.XMin := Min(ABox.XMin, APoint.X);
    ABox.XMax := Max(ABox.XMax, APoint.X);
    ABox.YMin := Min(ABox.YMin, APoint.Y);
    ABox.YMax := Max(ABox.YMax, APoint.Y);
    ABox.ZMin := Min(ABox.ZMin, APoint.Z);
    ABox.ZMax := Max(ABox.ZMax, APoint.Z);
  end;
end;

function TransformBox3D(const ABox: TsdBox3D; const ATransform: TsdMatrix3x4): TsdBox3D;
// Transform the 8 box corner points with ATransform, and create a new bounding box
// around them
var
  P: array[0..7] of TsdPoint3D;
begin
  P[0].X := ABox.XMin; P[0].Y := ABox.YMin; P[0].Z := ABox.ZMin;
  P[1].X := ABox.XMin; P[1].Y := ABox.YMin; P[1].Z := ABox.ZMax;
  P[2].X := ABox.XMin; P[2].Y := ABox.YMax; P[2].Z := ABox.ZMin;
  P[3].X := ABox.XMin; P[3].Y := ABox.YMax; P[3].Z := ABox.ZMax;
  P[4].X := ABox.XMax; P[4].Y := ABox.YMin; P[4].Z := ABox.ZMin;
  P[5].X := ABox.XMax; P[5].Y := ABox.YMin; P[5].Z := ABox.ZMax;
  P[6].X := ABox.XMax; P[6].Y := ABox.YMax; P[6].Z := ABox.ZMin;
  P[7].X := ABox.XMax; P[7].Y := ABox.YMax; P[7].Z := ABox.ZMax;
  TransformPoints(@P[0], @P[0], 8, ATransform);
  Result := BoundingBox3D(@P[0], 8);
end;

function CombineBox3D(const B1, B2: TsdBox3D): TsdBox3D;
// Combine bounding boxes B1 and B2
begin
  Result.XMin := Min(B1.XMin, B2.XMin);
  Result.YMin := Min(B1.YMin, B2.YMin);
  Result.ZMin := Min(B1.ZMin, B2.ZMin);
  Result.XMax := Max(B1.XMax, B2.XMax);
  Result.YMax := Max(B1.YMax, B2.YMax);
  Result.ZMax := Max(B1.ZMax, B2.ZMax);
end;

procedure TransformPoint(const Source: TsdPoint3D; var Dest: TsdPoint3D; const Trans: TsdMatrix3x4);
var
  X, Y, Z: double;
begin
  X := Source.X;
  Y := Source.Y;
  Z := Source.Z;
  Dest.X := Trans[0, 0] * X + Trans[0, 1] * Y + Trans[0, 2] * Z + Trans[0, 3];
  Dest.Y := Trans[1, 0] * X + Trans[1, 1] * Y + Trans[1, 2] * Z + Trans[1, 3];
  Dest.Z := Trans[2, 0] * X + Trans[2, 1] * Y + Trans[2, 2] * Z + Trans[2, 3];
end;

procedure PostTransformPose(const Source: TsdPose3D; var Dest: TsdPose3D; const Trans: TsdMatrix3x4);
var
  SrcM, DstM: TsdMatrix3x4;
begin
  PoseToTransformMatrix(Source, SrcM);
  DstM := MultiplyMatrix3x4(Trans, SrcM);
  TransformMatrixToPose(DstM, Dest);
end;

procedure PreTransformPose(const Source: TsdPose3D; var Dest: TsdPose3D; const Trans: TsdMatrix3x4);
var
  SrcM, DstM: TsdMatrix3x4;
begin
  PoseToTransformMatrix(Source, SrcM);
  DstM := MultiplyMatrix3x4(SrcM, Trans);
  TransformMatrixToPose(DstM, Dest);
end;

procedure TransformDirection(const Source: TsdPoint3D; var Dest: TsdPoint3D; const Trans: TsdMatrix3x4);
var
  X, Y, Z: double;
begin
  X := Source.X;
  Y := Source.Y;
  Z := Source.Z;
  Dest.X := Trans[0, 0] * X + Trans[0, 1] * Y + Trans[0, 2] * Z;
  Dest.Y := Trans[1, 0] * X + Trans[1, 1] * Y + Trans[1, 2] * Z;
  Dest.Z := Trans[2, 0] * X + Trans[2, 1] * Y + Trans[2, 2] * Z;
end;


procedure TransformPoints(Source, Dest: PsdPoint3D; PointCount: integer; const Trans: TsdMatrix3x4);
var
  i: integer;
begin
  // Source can equal Dest, because TransformPoint is safe that way
  for i := 0 to PointCount - 1 do
  begin
    TransformPoint(Source^, Dest^, Trans);
    inc(Source);
    inc(Dest);
  end;
end;

procedure SortPoints3D(Points: PsdPoint3DArray; Count: integer; const Axis: TsdPoint3D);
var
  i, j: integer;
  Temp: TsdPoint3D;
begin
  // this should be a Quicksort but no time now
  for i := 0 to Count - 2 do
    for j := i + 1 to Count - 1 do
      if DotProduct3D(Points[i], Axis) > DotProduct3D(Points[j], Axis) then
      begin
        // Swap 'em
        Temp := Points[i];
        Points[i] := Points[j];
        Points[j] := Temp;
      end;
end;

function AveragePoints3D(Points: PsdPoint3DArray; Count: integer): TsdPoint3D;
var
  i: integer;
begin
  Result := cZero3D;
  for i := 0 to Count - 1 do
    AddPoint3D(Result, Points[i], Result);

  if Count > 1 then
  begin
    Result.X := Result.X / Count;
    Result.Y := Result.Y / Count;
    Result.Z := Result.Z / Count;
  end;
end;

procedure TranslateMatrix3x4(const A: TsdMatrix3x4; var At: TsdMatrix3x4; Dist: TsdPoint3D);
begin
  if @A <> @At then At := A;
  At[0, 3] := At[0, 3] + Dist.X;
  At[1, 3] := At[1, 3] + Dist.Y;
  At[2, 3] := At[2, 3] + Dist.Z;
end;

procedure PoseToTransformMatrix(const Pose: TsdPose3D; var Trans: TsdMatrix3x4);
begin
  PoseToTransformMatrix(Pose.X, Pose.Y, Pose.Z, Pose.A, Pose.B, Pose.C, Trans);
end;

procedure PoseToTransformMatrix(const X, Y, Z, A, B, C: double; var Trans: TsdMatrix3x4);
var
  cC, sC, cB, sB, cA, sA: double;
begin
  cA := cos(A);
  sA := sin(A);
  cB := cos(B);
  sB := sin(B);
  cC := cos(C);
  sC := sin(C);

  // Assign elements
  Trans[0, 0] := cB * cC;
  Trans[0, 1] := sA * sB * cC - cA * sC;
  Trans[0, 2] := cA * sB * cC + sA * sC;

  Trans[1, 0] := cB * sC;
  Trans[1, 1] := sA * sB * sC + cA * cC;
  Trans[1, 2] := cA * sB * sC - sA * cC;

  Trans[2, 0] := -sB;
  Trans[2, 1] := sA * cB;
  Trans[2, 2] := cA * cB;

  Trans[0, 3] := X;
  Trans[1, 3] := Y;
  Trans[2, 3] := Z;
end;

procedure TransformMatrixToPose(const Trans: TsdMatrix3x4; var Pose: TsdPose3D);
begin
  TransformMatrixToPose(Trans, Pose.X, Pose.Y, Pose.Z, Pose.A, Pose.B, Pose.C);
end;

procedure TransformMatrixToPose(const Trans: TsdMatrix3x4; var X, Y, Z, A, B, C: double);
var
  cC, sC, cB, sB, cA, sA: double;
begin
  sB := -Trans[2, 0];
  cB := sqrt(sqr(Trans[0, 0]) + sqr(Trans[1, 0]));
  if abs(cB) > 1E-10 then
  begin
    // use cB
    cC := Trans[0, 0] / cB;
    sC := Trans[1, 0] / cB;
    sA := Trans[2, 1] / cB;
    cA := Trans[2, 2] / cB;
  end else
  begin
    // Close to singularity, assume that A = 0
    sA := 0;
    cA := 1;
    sC := -Trans[0, 1];
    cC :=  Trans[1, 1];
  end;

  // Use quadrant arctangent to get angles
  A := ArcTan2(sA, cA);
  B := ArcTan2(sB, cB);
  C := ArcTan2(sC, cC);

  // Translations
  X := Trans[0, 3];
  Y := Trans[1, 3];
  Z := Trans[2, 3];
end;

function TransformMatrixFromTwoVectors(Vec1, Vec2: TsdPoint3D;
  Axis1, Axis2: TsdAxisSpec3D): TsdMatrix3x4;
var
  i,
  A1, A2, A3: integer;
  Vec3: TsdPoint3D;
  Flip: boolean;
begin
  // Find Vec3
  CrossProduct3D(Vec1, Vec2, Vec3);

  // Find indices
  A1 := integer(Axis1); A2 := integer(Axis2);
  if A1 = A2 then
    raise Exception.Create(sAxesCannotBeEqual);
  if A2 < A1 then inc(A2, 3);
  if A2 - A1 = 1 then
  begin
    Flip := False;
    A3 := A1 + 2;
  end else
  begin
    Flip := True;
    A3 := A1 + 1;
  end;
  A2 := A2 mod 3;
  A3 := A3 mod 3;

  // Normalize
  NormalizeVector3D(Vec1);
  NormalizeVector3D(Vec3);

  // Recalc Vec2
  CrossProduct3D(Vec3, Vec1, Vec2);

  // Make sure to be righthanded
  if Flip then FlipVector3D(Vec3);

  FillChar(Result, SizeOf(Result), 0);
  for i := 0 to 2 do
  begin
    Result[A1, i] := Vec1.Elem[i];
    Result[A2, i] := Vec2.Elem[i];
    Result[A3, i] := Vec3.Elem[i];
  end;

end;

procedure OrthoMatrix3x4Inverse(const A: TsdMatrix3x4; var Ai: TsdMatrix3x4);
var
  c, r: integer;
  Temp: TsdMatrix3x4;
begin
  // we use a temp structure since A may be Ai
  
  // Transpose
  for r := 0 to 2 do
    for c := 0 to 2 do
      Temp[c, r] := A[r, c];

  // Translational part
  for r := 0 to 2 do
    Temp[r, 3] := -A[0, r] * A[0, 3] - A[1, r] * A[1, 3] - A[2, r] * A[2, 3];

  // Copy
  Ai := Temp;
end;

procedure Matrix3x4Inverse(A: TsdMatrix3x4; var Ai: TsdMatrix3x4);
var
  i, ii, j, Rmax: integer;
  VMax, S, Temp: double;
begin
  // Set inverse to identity
  Ai := cIdentityMatrix3x4;

  // loop through the rows
  for i := 0 to 2 do
  begin
    // search the maximum in the column for cells with row >= i, this will be the pivot
    Rmax := -1;
    Vmax := 0;
    for ii := i to 2 do
    begin
      if abs(A[ii, i]) > abs(Vmax) then
      begin
        Rmax := ii;
        Vmax := A[ii, i];
      end;
    end;

    // if we don't find a maximum, all col elements are 0, indicating a singular matrix
    if Rmax = -1 then
      raise Exception.Create(sErrInverseMatrixIsSingular);

    // if maximum not in cell (i,i), swap them (pivoting)
    if i <> Rmax then
    begin
      for j := 0 to 3 do
      begin
        // for A we only need these in future
        if j >= i then
        begin
          Temp := A[i, j];
          A[i, j] := A[Rmax, j];
          A[Rmax, j] := Temp;
        end;
        Temp := Ai[i, j];
        Ai[i, j] := Ai[Rmax, j];
        Ai[Rmax, j] := Temp;
      end;
    end;

    // scale the row to 1/max
    S := 1 / A[i, i];
    for j := 0 to 3 do
    begin
      // for A we only need these in future
      if j > i then
        A [i, j] := A [i, j] * S;
      Ai[i, j] := Ai[i, j] * S;
    end;
    // Substract from other rows
    for ii := 0 to 2 do
      if (i <> ii) and (A[ii, i] <> 0.0) then
      begin
        S := A[ii, i];
        for j := 0 to 3 do
        begin
          // for A we only need these in future
          if j > i then
            A[ii, j] := A[ii, j] - S * A[i, j];
          Ai[ii, j] := Ai[ii, j] - S * Ai[i, j];
        end;
      end;
  end;

  // Last col: set Ai[i, 3] = -A[i, 3];
  for i := 0 to 2 do
    Ai[i, 3] := -A[i, 3];

end;

function TranslationMatrix(const X, Y, Z: double): TsdMatrix3x4;
// Create a translation matrix
begin
  Result := cIdentityMatrix3x4;
  Result[0, 3] := X;
  Result[1, 3] := Y;
  Result[2, 3] := Z;
end;

function RotationMatrixAxis(const i, j, k, Alpha: double): TsdMatrix3x4;
// Create a rotation matrix, around axis (X,Y,Z) with angle Alpha
var
  c, s: double;
begin
  // See Wikipedia
  // http://en.wikipedia.org/wiki/Rotation_matrix
  c := cos(Alpha);
  s := sin(Alpha);
  Result[0, 0] := c + (1 - c) * i * i;
  Result[0, 1] := (1 - c) * i * j - s * k;
  Result[0, 2] := (1 - c) * i * k + s * j;
  Result[0, 3] := 0;
  Result[1, 0] := (1 - c) * j * i + s * k;
  Result[1, 1] := c + (1 - c) * j * j;
  Result[1, 2] := (1 - c) * j * k - s * i;
  Result[1, 3] := 0;
  Result[2, 0] := (1 - c) * k * i - s * j;
  Result[2, 1] := (1 - c) * k * j + s * i;
  Result[2, 2] := c + (1 - c) * k * k;
  Result[2, 3] := 0;
end;

function UniformScalingMatrix(const S: double): TsdMatrix3x4;
// Create a scaling matrix with S on the diagonals
begin
  Result := cIdentityMatrix3x4;
  Result[0, 0] := S;
  Result[1, 1] := S;
  Result[2, 2] := S;
end;

function ScalingMatrix(const Sx, Sy, Sz: double): TsdMatrix3x4;
// Create a scaling matrix with Sx Sy Sz on the diagonals
begin
  Result := cIdentityMatrix3x4;
  Result[0, 0] := Sx;
  Result[1, 1] := Sy;
  Result[2, 2] := Sz;
end;

function MatricesEqual(const A, B: TsdMatrix3x4): boolean;
var
  r, c: integer;
begin
  for r := 0 to 2 do
    for c := 0 to 3 do
      if A[r, c] <> B[r, c] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function Matr3x4ToString(const M: TsdMatrix3x4): string;
var
  r: integer;
begin
  Result := '';
  for r := 0 to 2 do
  begin
    Result := Result + Format('[%7.4f, %7.4f, %7.4f, %7.4f]',
      [M[r, 0], M[r, 1], M[r, 2], M[r, 3]]);
    if r < 2 then Result := Result + #13#10;
  end;
end;

function Point3DToString(const P: TsdPoint3D; const Scale: double; const Fmt: string): string;
begin
  Result := Format('[%s, %s, %s]',
    [Format(Fmt, [P.X * Scale]), Format(Fmt, [P.Y * Scale]), Format(Fmt, [P.Z * Scale])]);
end;

function Box3DToString(const B: TsdBox3D; const Scale: double): string;
begin
  Result := Format('[XMin: %4.1f, XMax: %4.1f, YMin: %4.1f, YMax: %4.1f, ZMin: %4.1f, ZMax: %4.1f]',
    [B.Xmin * Scale, B.Xmax * Scale, B.Ymin * Scale, B.Ymax * Scale, B.Zmin * Scale, B.Zmax * Scale]);
end;

{ TsdIntegerList }

procedure TsdIntegerList.Add(AValue: integer);
begin
  if length(FValues) <= FCount then
    // increase capacity
    SetLength(FValues, length(FValues) * 3 div 2 + 10);
  FValues[FCount] := AValue;
  inc(FCount);
end;

procedure TsdIntegerList.Add3(V1, V2, V3: integer);
begin
  Add(V1);
  Add(V2);
  Add(V3);
end;

procedure TsdIntegerList.Assign(Source: TPersistent);
begin
  if Source is TsdIntegerList then
  begin
    FCount := TsdIntegerList(Source).FCount;
    SetLength(FValues, FCount);
    if FCount > 0 then
      Move(TsdIntegerList(Source).FValues[0], FValues[0], FCount * SizeOf(integer));
  end else
    inherited;
end;

procedure TsdIntegerList.Clear;
begin
  FCount := 0;
end;

procedure TsdIntegerList.Delete(AIndex: integer);
var
  RestCount: integer;
begin
  if (AIndex >= 0) and (AIndex < FCount) then
  begin
    RestCount := FCount - AIndex - 1;
    if RestCount > 0 then
      Move(FValues[AIndex + 1], FValues[AIndex], RestCount * SizeOf(integer));
    dec(FCount);
  end;
end;

function TsdIntegerList.GetValues(Index: integer): integer;
begin
  if (Index >= 0) and (Index < Count) then
    Result := FValues[Index]
  else
    Result := 0;
end;

{ TsdPolygon3D }

procedure TsdPolygon3D.Add(const APoint: TsdPoint3D);
begin
  if length(FPoints) <= FCount then
    // increase capacity
    SetLength(FPoints, length(FPoints) * 3 div 2 + 10);
  FPoints[FCount] := APoint;
  inc(FCount);
end;

procedure TsdPolygon3D.AddWithBreakupLength(const APoint: TsdPoint3D;
  const BreakupLength: double; IncludeLast: boolean);
var
  i, SegCount: integer;
  OldPoint, IntPoint: TsdPoint3D;
  ALength: double;
begin
  if BreakupLength = 0 then
  begin
    if IncludeLast then
      Add(APoint);
    exit;
  end;
  if FCount > 0 then
    OldPoint := FPoints[FCount - 1]
  else
  begin
    // when first point: do not break up, just add it
    if IncludeLast then
      Add(APoint);
    exit;
  end;

  ALength := Dist3D(OldPoint, APoint);
  SegCount := Max(1, ceil(ALength / BreakupLength));
  for i := 1 to SegCount - 1 do
  begin
    Interpolation3D(OldPoint, APoint, i / SegCount, IntPoint);
    Add(IntPoint);
  end;
  if IncludeLast then
    Add(APoint);
end;

procedure TsdPolygon3D.Assign(Source: TPersistent);
var
  L: integer;
begin
  if Source is TsdPolygon3D then
  begin
    FCount := TsdPolygon3D(Source).FCount;
    L := length(TsdPolygon3D(Source).FPoints);
    SetLength(FPoints, L);
    if L > 0 then
      Move(TsdPolygon3D(Source).FPoints[0], FPoints[0], L * SizeOf(TsdPoint3D));
  end else
    inherited;
end;

procedure TsdPolygon3D.Clear;
begin
  FCount := 0;
end;

procedure TsdPolygon3D.Delete(AIndex: integer);
var
  RestCount: integer;
begin
  if (AIndex >= 0) and (AIndex < FCount) then
  begin
    RestCount := FCount - AIndex - 1;
    if RestCount > 0 then
      Move(FPoints[AIndex + 1], FPoints[AIndex], RestCount * SizeOf(TsdPoint3D));
    dec(FCount);
  end;
end;

procedure TsdPolygon3D.DeleteDuplicates(const AEps: double);
var
  Idx: integer;
  ESqr: double;
  P, Q: PsdPoint3D;
begin
  if Count = 0 then exit;
  ESqr := sqr(AEps);
  P := First;
  Idx := 1;
  while Idx <= Count do
  begin
    Q := @FPoints[Idx mod Count];
    if SquaredDist3D(P^, Q^) < ESqr then
      Delete(Idx mod Count)
    else
    begin
      P := Q;
      inc(Idx);
    end;
  end;
end;

function TsdPolygon3D.First: PsdPoint3D;
begin
  if FCount > 0 then
    Result := @FPoints[0]
  else
    Result := nil;
end;

function TsdPolygon3D.GetPoints(Index: integer): PsdPoint3D;
begin
  Result := @FPoints[Index];
end;

function TsdPolygon3D.Last: PsdPoint3D;
begin
  if FCount > 0 then
    Result := @FPoints[Count - 1]
  else
    Result := nil;
end;

end.



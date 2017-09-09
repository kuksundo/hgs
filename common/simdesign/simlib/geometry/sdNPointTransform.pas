unit sdNPointTransform;
{
  Description:
  This unit implements the N-Point transform. An N-Point transform consists of two
  series of points (Original and Transformed) for which the matching transform
  will be found. The points must have the same order, e.g. point 1 in the original
  series must match point 1 in the transformed series, etc.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 23Jul2002

  Modifications:
  25Jan2005: Added Permutations function
  12Jun2008: Improved algorithm: center both pointlists, then find rotations

  copyright (2) 2002 - 2008 SimDesign B.V.
}

interface

uses
  sdPoints3D, sdMatrices, Math, SysUtils;

const

  // test point series

  // Translation DeltaX = 1
  TestPoints1Orig: array[0..2] of TsdPoint3D =
   ((X: 0; Y: 0; Z:0),
    (X: 1; Y: 0; Z:0),
    (X: 0; Y: 1; Z:0));
  TestPoints1Trans: array[0..2] of TsdPoint3D =
   ((X: 1; Y: 0; Z:0),
    (X: 2; Y: 0; Z:0),
    (X: 1; Y: 1; Z:0));

  // Rotation around Z of 90deg
  TestPoints2Orig: array[0..2] of TsdPoint3D =
   ((X: 0; Y: 0; Z:0),
    (X: 1; Y: 0; Z:0),
    (X: 0; Y: 1; Z:0));
  TestPoints2Trans: array[0..2] of TsdPoint3D =
   ((X: 0; Y: 0; Z:0),
    (X: 0; Y: 1; Z:0),
    (X: -1; Y: 0; Z:0));

  // Rotation around Z of 90deg with small error
  TestPoints3Orig: array[0..2] of TsdPoint3D =
   ((X: 0; Y: 0; Z:0),
    (X: 1; Y: 0; Z:0),
    (X: 0; Y: 1; Z:0));
  TestPoints3Trans: array[0..2] of TsdPoint3D =
   ((X: 0; Y: 0; Z:0),
    (X: 0; Y: 0.99; Z:0),
    (X: -1; Y: 0; Z:0));

  // Rotation around Z of 45deg
  TestPoints4Orig: array[0..2] of TsdPoint3D =
   ((X: 0; Y: 0; Z:0),
    (X: 1; Y: 0; Z:0),
    (X: 0; Y: 1; Z:0));
  TestPoints4Trans: array[0..2] of TsdPoint3D =
   ((X: 0; Y: 0; Z:0),
    (X: 0.7071; Y: 0.7071; Z:0),
    (X: -0.7071; Y: 0.7071; Z:0));

  // colinear -> should give error
  TestPoints5Orig: array[0..2] of TsdPoint3D =
   ((X: 0; Y: 0; Z:0),
    (X: 1; Y: 0; Z:0),
    (X: 2; Y: 0; Z:0));
  TestPoints5Trans: array[0..2] of TsdPoint3D =
   ((X: 3; Y: 0; Z:0),
    (X: 4; Y: 0; Z:1),
    (X: 5; Y: 0; Z:0));

type
  // array storing permutations
  TsdPermutation = array of array of integer;

// Call Permutations to get a series of N! permutations in Result. E.g. for N=3:
// 0 1 2, 0 2 1, 1 0 2, 1 2 0, 2 0 1, 2 1 0
procedure Permutations(N: integer; var Result: TsdPermutation);

// Calculate the orthogonal transform to be used to go from the Original to the
// Transformed pointset, and return the transformation matrix in ATransformMatrix.
// The maximum resulting error (euclidian distance) is put in AMaxError. The
// transform matrix does not need to be initialized, it will be internally initialized
// to the identity matrix.
//
// Method used:
//   First of all, both point clouds are centered on zero, then in a loop each
//   time the rotation angles are found to move the points closer together, until
//   there is either no improvement, or the solution is within Eps.
// Possible function results:
//   True: Transformation succeeded
//   False: Matrix inverse cannot be calculated (not enough points, points are colinear, etc)
function NPointTransform(AOriginal, ADestination: PsdPoint3D; APointCount: integer;
  var ATransformMatrix: TsdMatrix3x4; var AMaxError: double; const AEps: double = 1e-12): boolean;

implementation

function Faculty(N: integer): integer;
begin
  if N > 1 then
    Result := N * Faculty(N - 1)
  else
    if N = 1 then
      Result := 1
    else
      Result := 0;
end;

procedure Permutations(N: integer; var Result: TsdPermutation);
var
  i, Count, Level, Index: integer;
  Used: array of boolean;
  Current: array of integer;
begin
  Count := Faculty(N);
  Setlength(Result, Count);
  for i := 0 to Count - 1 do
    SetLength(Result[i], N);
  SetLength(Used, N);
  SetLength(Current, N);
  Level := 0;
  Index := 0;
  repeat
    if Used[Current[Level]] then
    begin
      inc(Current[Level]);
    end else
    begin
      Used[Current[Level]] := True;
      inc(Level);
      if Level = N then
      begin
        // We add a permutation here
        for i := 0 to N - 1 do
          Result[Index][i] := Current[i];
        dec(Level);
        Used[Current[Level]] := False;
        inc(Index);
        inc(Current[Level]);
      end;
    end;
    while Current[Level] = N do
    begin
      Current[Level] := 0;
      dec(Level);
      if Level < 0 then exit;
      Used[Current[Level]] := False;
      inc(Current[Level]);
    end;
  until False;
end;

procedure CalculatePointlistDifference(AList1, AList2: PsdPoint3D; APointCount: integer;
  var ARootMeanSquare, AMaxError: double);
var
  i: integer;
  Dif: TsdPoint3D;
  SqrError: double;
begin
  AMaxError := 0;
  ARootMeanSquare := 0;
  for i := 0 to APointcount - 1 do
  begin
    SubstractPoint3D(AList1^, AList2^, Dif);
    SqrError := SquaredLength3D(Dif);
    AMaxError := Max(AMaxError, SqrError);
    ARootMeanSquare := ARootMeanSquare + SqrError;
    inc(AList1);
    inc(AList2);
  end;
  AMaxError := sqrt(AMaxError);
  ARootMeanSquare := sqrt(ARootMeanSquare / APointCount);
end;

function NPointTransformSingleStep(Original, Transformed: PsdPoint3D; PointCount: integer;
  var TransformMatrix: TsdMatrix3x4): integer;
// This function does the whole transform (translations/rotations) in a single step.
// It works for pointlists with small differences, but not to match pointlists
// where large rotations play a role.   
const
  // Rotation vectors of axes X, Y and Z
  cRotVec: array[0..2] of TsdPoint3D =
    ((X: 1; Y: 0; Z: 0),
     (X: 0; Y: 1; Z: 0),
     (X: 0; Y: 0; Z: 1));
var
  i, j: integer;
  Jac, Jinv: TsdMatrix;
  Pose, Diff: TsdVector;
  P, Q: PsdPoint3D;
  R: TsdPoint3D;
  AngularMag: double;
begin
  Result := 0;
  //MaxError := 1E100;

  // Initialize matrices and temp structures
  Jac := TsdMatrix.CreateSize(PointCount * 3, 6);
  Jinv := TsdMatrix.CreateSize(6, PointCount * 3);
  Pose := TsdVector.CreateCount(6);
  Diff := TsdVector.CreateCount(PointCount * 3);
  //SetLength(TNew, PointCount);
  try

    // Build Diff vector
    P := Original;
    Q := Transformed;
    for i := 0 to PointCount - 1 do
    begin
      Diff[i * 3    ] := Q.X - P.X;
      Diff[i * 3 + 1] := Q.Y - P.Y;
      Diff[i * 3 + 2] := Q.Z - P.Z;
      inc(P);
      inc(Q);
    end;

    // Build Jacobian matrix rows (3 rows per point)
    P := Original;
    for i := 0 to PointCount - 1 do
    begin

      // Column 0, 1 and 2
      Jac[i * 3    , 0] := 1;
      Jac[i * 3 + 1, 1] := 1;
      Jac[i * 3 + 2, 2] := 1;

      // Column 3, 4 and 5
      for j := 0 to 2 do
      begin
        CrossProduct3D(P^, cRotVec[j], R);
        Jac[i * 3 + j, 3] := R.X;
        Jac[i * 3 + j, 4] := R.Y;
        Jac[i * 3 + j, 5] := R.Z;
      end;

      // Next point
      inc(P);
    end;

    try
      // Invert the jacobian using Moore-Penrose
      MatInverseMP(Jac, Jinv);
    except
      // If the inverse does not succeed, points are probably colinear
      Result := 1;
      exit;
    end;

    // Calculate solution for pose
    MatMultiply(Jinv, Diff, Pose);

    AngularMag := abs(Pose[3]) + abs(Pose[4]) + abs(Pose[5]);
    if AngularMag > 20 * pi / 180 then
    begin
      // Big angular correction: only do this one
      Pose[0] := 0;
      Pose[1] := 0;
      Pose[2] := 0;
    end;

    // Transform matrix
    PoseToTransformMatrix(Pose[0], Pose[1], Pose[2], Pose[3], Pose[4], Pose[5], TransformMatrix);

  finally
    Jac.Free;
    Jinv.Free;
    Pose.Free;
    Diff.Free;
  end;

end;

function NPointRotationSingleStep(AOriginal, ATransformed: PsdPoint3D; APointCount: integer;
  var ATransformMatrix: TsdMatrix3x4; const AStepSize: double = 1.0): boolean;
const
  // Rotation vectors of axes X, Y and Z
  cRotVec: array[0..2] of TsdPoint3D =
    ((X: 1; Y: 0; Z: 0), (X: 0; Y: 1; Z: 0), (X: 0; Y: 0; Z: 1));
var
  i, j: integer;
  Jac, Jinv: TsdMatrix;
  Pose, Diff: TsdVector;
  P, Q: PsdPoint3D;
  R: TsdPoint3D;
begin
  Result := True;
  // Initialize matrices and temp structures
  Jac := TsdMatrix.CreateSize(APointCount * 3, 3);
  Jinv := TsdMatrix.CreateSize(3, APointCount * 3);
  Pose := TsdVector.CreateCount(3);
  Diff := TsdVector.CreateCount(APointCount * 3);
  try

    // Build Diff vector
    P := AOriginal;
    Q := ATransformed;
    for i := 0 to APointCount - 1 do
    begin
      Diff[i * 3    ] := Q.X - P.X;
      Diff[i * 3 + 1] := Q.Y - P.Y;
      Diff[i * 3 + 2] := Q.Z - P.Z;
      inc(P);
      inc(Q);
    end;

    // Build Jacobian matrix rows (3 rows per point)
    P := AOriginal;
    for i := 0 to APointCount - 1 do
    begin

      // Rotation Columns: linearized deviations of points if we rotate
      // around X,Y,Z by an angle in Pose (in radians)
      for j := 0 to 2 do
      begin
        CrossProduct3D(P^, cRotVec[j], R);
        Jac[i * 3 + j, 0] := R.X;
        Jac[i * 3 + j, 1] := R.Y;
        Jac[i * 3 + j, 2] := R.Z;
      end;

      // Next point
      inc(P);
    end;

    try
      // Invert the jacobian using Moore-Penrose
      MatInverseMP(Jac, Jinv);
    except
      // If the inverse does not succeed, points are probably colinear
      Result := False;
      exit;
    end;

    // Calculate solution for pose
    MatMultiply(Jinv, Diff, Pose);

    // Transform matrix
    PoseToTransformMatrix(
      0, 0, 0,
      Pose[0] * AStepSize, Pose[1] * AStepSize, Pose[2] * AStepSize,
      ATransformMatrix);

  finally
    Jac.Free;
    Jinv.Free;
    Pose.Free;
    Diff.Free;
  end;

end;

function NPointTransform(AOriginal, ADestination: PsdPoint3D; APointCount: integer;
  var ATransformMatrix: TsdMatrix3x4; var AMaxError: double; const AEps: double): boolean;
const
  cMaxIter = 15;
var
  Error, RMS, MaxRMS: double;
  Estimation: array of TsdPoint3D;
  DestZero: array of TsdPoint3D;
  Trans, TD2Z, TZ2D, TM: TsdMatrix3x4;
  OrigCG, DestCG: TsdPoint3D;
  EstimP, DestZP: PsdPoint3D;
  Iter: integer;
begin
  // Start with identity matrix
  ATransformMatrix := cIdentityMatrix3x4;
  AMaxError := 0;
  Result := False;

  if APointCount <= 0 then
    exit;

  // temporary transformed list
  SetLength(Estimation, APointCount);
  SetLength(DestZero, APointCount);
  EstimP := @Estimation[0];
  DestZP := @DestZero[0];

  // We will start off with averaging the points, and calculating the required
  // translation
  OrigCG := AveragePoints3D(PsdPoint3DArray(AOriginal), APointCount);
  DestCG := AveragePoints3D(PsdPoint3DArray(ADestination), APointCount);

  // Transform to put Original points around zero
  ATransformMatrix := TranslationMatrix(-OrigCG.X, -OrigCG.Y, -OrigCG.Z);
  // Transform to put Destination points around zero
  TD2Z := TranslationMatrix(-DestCG.X, -DestCG.Y, -DestCG.Z);
  TZ2D := TranslationMatrix(DestCG.X, DestCG.Y, DestCG.Z);

  TransformPoints(AOriginal, EstimP, APointCount, ATransformMatrix);
  TransformPoints(ADestination, DestZP, APointCount, TD2Z);

  // Calculate initial error
  CalculatePointlistDifference(EstimP, DestZP, APointCount, MaxRMS, AMaxError);

  // Repeat the process of finding solution iteratively
  Iter := 0;
  repeat
    // Interation
    inc(Iter);

    // Calculate solution
    Result := NPointRotationSingleStep(EstimP, DestZP, APointCount, Trans, 1.0);
    if not Result then
      break;

    TM := MultiplyMatrix3x4(Trans, ATransformMatrix);

    TransformPoints(AOriginal, EstimP, APointCount, TM);
    CalculatePointlistDifference(EstimP, DestZP, APointCount, RMS, Error);

    // Check if we do not exceed maximum iterations and have a better solution
    if (RMS < MaxRMS) and (Iter <= cMaxIter) then
    begin

      // New transformation
      ATransformMatrix := TM;
      // New Max RMS
      MaxRMS := RMS;

    end else
      // we should quit if the error doesn't become smaller
      break;

  // we can quit if the maximum single point error is small enough
  until Error < AEps;

  // Final transform
  ATransformMatrix := MultiplyMatrix3x4(TZ2D, ATransformMatrix);

  // verify
  TransformPoints(AOriginal, EstimP, APointCount, ATransformMatrix);
  CalculatePointlistDifference(EstimP, ADestination, APointCount, RMS, AMaxError);

end;

end.

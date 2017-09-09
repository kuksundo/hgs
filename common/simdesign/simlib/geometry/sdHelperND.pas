unit sdHelperND;

interface

uses
  Math;

type

  TsdFloat = double;
  TsdCoord = TsdFloat;
  PsdCoord = ^TsdCoord;
  TsdPoint = array of TsdCoord;
  TsdVector = TsdPoint;
  TsdMatrix = array of TsdVector;

  TsdDynObjectArray = array of TObject;

function VectorLengthSqr(const AVector: TsdVector): TsdFloat;
function VectorLength(const AVector: TsdVector): TsdFloat;

function VectorDistanceSqr(const A, B: TsdVector): TsdFloat;
function VectorDistance(const A, B: TsdVector): TsdFloat;

// Normalize AVector. If it's length is 0, result will be false, and AVector
// remains untouched
function Normalize(var AVector: TsdVector): boolean;

// Calculate Delta = B - A
procedure VectorDelta(const A, B: TsdPoint; var ADelta: TsdVector);

// Calculate dot product of A * B
function VectorDot(const A, B: TsdVector): double;

// Flip vector A (invert all coordinates)
procedure VectorFlip(var A: TsdVector);

procedure AddObject(var AList: TsdDynObjectArray; AObject: TObject);
procedure DeleteObject(var AList: TsdDynObjectArray; AObject: TObject);
function IndexOfObject(var AList: TsdDynObjectArray; AObject: TObject): integer;

procedure SetMatrixSize(var AMatrix: TsdMatrix; AVectorCount, AVectorSize: integer);

procedure BoundingBox(const APoints: TsdMatrix; var AMin, AMax: TsdPoint);
procedure VectorAverage(const APoints: TsdMatrix; var AAverage: TsdPoint);

function BackSolve(const A: TsdMatrix; var B: TsdVector): boolean;

// The new system A consists of ANormal as "Z" axis (last one), and X1..Xn other
// orthogonal axes. We build these vectors by substracting all the ones we already
// know from an initial set of orthogonal ones, one by one, then normalize them
procedure BuildOrthoNormalSet(const ANormal: TsdVector; var A: TsdMatrix);

// Reduce the dimensionality of the points in Source by one. These points should
// all be in a plane with ANormal. After reduction, the dimension of each point
// will be reduced (written to Dest), and it will be available in a new ortho-
// normal system
procedure ReduceDimensionality(const Source: TsdMatrix; var Dest: TsdMatrix; const ANormal: TsdVector);

// APoints should be a list of N points, of dimension N. These points will be used
// to construct ANormal, of dimension N. If the planefit fails, result will be
// false, and ANormal will be initialized to all zeros
function PlaneFit(const APoints: TsdMatrix; var ANormal: TsdVector): boolean;

implementation

function VectorLengthSqr(const AVector: TsdVector): TsdFloat;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to length(AVector) - 1 do
    Result := Result + sqr(AVector[i]);
end;

function VectorLength(const AVector: TsdVector): TsdFloat;
begin
  Result := Sqrt(VectorLengthSqr(AVector));
end;

function VectorDistanceSqr(const A, B: TsdVector): TsdFloat;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to length(A) - 1 do
    Result := Result + sqr(A[i] - B[i]);
end;

function VectorDistance(const A, B: TsdVector): TsdFloat;
begin
  Result := Sqrt(VectorDistanceSqr(A, B));
end;

function Normalize(var AVector: TsdVector): boolean;
var
  i: integer;
  L: TsdFloat;
begin
  L := VectorLength(AVector);
  if L = 0 then begin
    Result := False;
    exit;
  end;
  L := 1 / L;
  for i := 0 to length(AVector) - 1 do
    AVector[i] := AVector[i] * L;
  Result := True;
end;

procedure VectorDelta(const A, B: TsdPoint; var ADelta: TsdVector);
var
  i, Count: integer;
begin
  Count := length(A);
  SetLength(ADelta, Count);
  for i := 0 to Count - 1 do
    ADelta[i] := B[i] - A[i];
end;

function VectorDot(const A, B: TsdVector): double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to length(A) - 1 do
    Result := Result + A[i] * B[i];
end;

procedure VectorFlip(var A: TsdVector);
var
  i: integer;
begin
  for i := 0 to length(A) - 1 do
    A[i] := -A[i];
end;

procedure AddObject(var AList: TsdDynObjectArray; AObject: TObject);
begin
  if IndexOfObject(AList, AObject) < 0 then begin
    SetLength(AList, length(AList) + 1);
    AList[length(AList) - 1] := AObject;
  end;
end;

procedure DeleteObject(var AList: TsdDynObjectArray; AObject: TObject);
var
  i, Idx: integer;
begin
  Idx := IndexOfObject(AList, AObject);
  if Idx < 0 then exit;
  for i := Idx to length(AList) - 2 do
    AList[Idx] := AList[Idx + 1];
  SetLength(AList, length(AList) - 1);
end;

function IndexOfObject(var AList: TsdDynObjectArray; AObject: TObject): integer;
var
  i: integer;
begin
  for i := 0 to length(AList) - 1 do
    if AList[i] = AObject then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

procedure SetMatrixSize(var AMatrix: TsdMatrix; AVectorCount, AVectorSize: integer);
// A matrix consists of vectorcount vectors
var
  i: integer;
begin
  SetLength(AMatrix, AVectorCount);
  for i := 0 to AVectorCount - 1 do
    SetLength(AMatrix[i], AVectorSize);
end;

procedure BoundingBox(const APoints: TsdMatrix; var AMin, AMax: TsdPoint);
var
  i, j, N, Dim: integer;
begin
  N := length(APoints);
  if N = 0 then exit;
  Dim := length(APoints[0]);
  SetLength(AMin, Dim);
  SetLength(AMax, Dim);
  for i := 0 to N - 1 do
    for j := 0 to Dim - 1 do begin
      if i = 0 then begin
        AMin[j] := APoints[i, j];
        AMax[j] := AMin[j];
      end else begin
        AMin[j] := Min(APoints[i, j], AMin[j]);
        AMax[j] := Max(APoints[i, j], AMax[j]);
      end;
    end;
end;

procedure VectorAverage(const APoints: TsdMatrix; var AAverage: TsdPoint);
var
  i, j, N, Dim: integer;
begin
  N := length(APoints);
  if N = 0 then exit;
  Dim := length(APoints[0]);
  SetLength(AAverage, Dim);
  for i := 0 to Dim - 1 do begin
    AAverage[i] := 0;
    for j := 0 to N - 1 do begin
      AAverage[i] := AAverage[i] + APoints[j, i];
    end;
    AAverage[i] := AAverage[i] / N;
  end;
end;

function BackSolve(const A: TsdMatrix; var B: TsdVector): boolean;
// Backsolve the equation A * X = B, X is given in B as result
var
  VecCount, VecSize: integer;
  Ipvt: array of integer;
  // local
  function MaxItem(Col: integer): integer;
  var
    i: integer;
    M, AMax: double;
  begin
    AMax := 0;
    Result := -1;
    // loop through the Col-th column
    for i := Col to VecSize - 1 do begin
      M := abs(A[Col, Ipvt[i]]);
      if M > AMax then begin
        AMax := M;
        Result := i;
      end;
    end;
  end;
  // local
  procedure RowSwap(R1, R2: integer);
  var
    Temp: integer;
  begin
    Temp := Ipvt[R1];
    Ipvt[R1] := Ipvt[R2];
    Ipvt[R2] := Temp;
  end;
  // local
  procedure RowScale(Rw: integer; const S: double; StartCol: integer);
  var
    i, Row: integer;
  begin
    Row := Ipvt[Rw];
    for i := StartCol to VecCount - 1 do
      A[i, Row] := A[i, Row] * S;
    B[Row] := B[Row] * S;
  end;
  // local
  procedure RowAddScale(Rw, Ad: integer; const S: double; StartCol: integer);
  var
    i, Row, Add: integer;
  begin
    Row := Ipvt[Rw];
    Add := Ipvt[Ad];
    for i := StartCol to VecCount - 1 do
      A[i, Row] := A[i, Row] + S * A[i, Add];
    B[Row] := B[Row] + S * B[Add];
  end;
// main
var
  i, j, Item: integer;
  V: double;
begin
  Result := False;
  // Checks
  VecCount := length(A);
  if VecCount = 0 then exit;
  VecSize := length(A[0]);
  if VecSize <> VecCount then exit;

  // Initialise pivot vector
  SetLength(Ipvt, VecSize);
  for i := 0 to VecSize - 1 do
    Ipvt[i] := i;

  // loop through the colums
  for i := 0 to VecCount - 1 do begin
    // search the maximum in the column for cells with row >= i, this will be the pivot
    Item := MaxItem(i);

    // if we don't find a maximum, all col elements are 0, indicating a singular matrix
    if Item = -1 then
      exit;

    // if maximum not in cell (i,i): swap them (pivoting)
    if i <> Item then RowSwap(i, Item);

    // scale the row to 1/max
    RowScale(i, 1 / A[i, Ipvt[i]], i);
    // Sweep
    for j := 0 to VecSize - 1 do begin
      if j = i then continue;
      V := A[i, Ipvt[j]];
      if V <> 0 then begin
        A[i, Ipvt[j]] := 0;
        RowAddScale(j, i, -V, i + 1);
      end;
    end;

  end;

  // Arriving here means ok result
  Result := True;
end;

function PlaneFit(const APoints: TsdMatrix; var ANormal: TsdVector): boolean;
var
  i, j, Dim: integer;
  A: TsdMatrix;
  B: TsdVector;
  MinBB, MaxBB{, Aver}: TsdVector;
  ShortestAxisIdx: integer;
  L, Shortest: TsdFloat;
begin
  Result := True;
  Dim := length(APoints);
  SetLength(ANormal, Dim);
  if Dim = 0 then exit;
  // Initialize normal
  FillChar(ANormal[0], Dim * sizeof(TsdCoord), 0);
  if Dim = 1 then begin
    ANormal[0] := 1;
    exit;
  end;

  // Bounding box
  BoundingBox(APoints, MinBB, MaxBB);
{  // Average point
  VectorAverage(APoints, Aver);}
  // Shortest axis (this coefficient is max in normal)
  ShortestAxisIdx := 0;
  Shortest := 0;
  for i := 0 to Dim - 1 do begin
    L := MaxBB[i] - MinBB[i];
    if i = 0 then begin
      Shortest := L;
    end else if L < Shortest then begin
      Shortest := L;
      ShortestAxisIdx := i;
    end;
  end;

  // build system matrix
  SetMatrixSize(A, Dim + 1, Dim + 1);

  // Copy points in matrix A, substract average
  for i := 0 to Dim - 1 do
    for j := 0 to Dim - 1 do
      A[j, i] := APoints[i, j]{ - Aver[j]};
  // last column: ones
  for i := 0 to Dim - 1 do
    A[Dim, i] := 1;
  // last row
  A[ShortestAxisIdx, Dim] := 1;

  // Vector B
  SetLength(B, Dim + 1);
  B[Dim] := 1;

  // Solve the system A * x = B, result in B
  Result := BackSolve(A, B);
  if not Result then exit;

  // Build the solution: normal (non-unified) in X
  Move(B[0], ANormal[0], Dim * SizeOf(TsdFloat));

  Result := Normalize(ANormal);

end;

procedure BuildOrthoNormalSet(const ANormal: TsdVector; var A: TsdMatrix);
// The new system consists of ANormal as "Z" axis (last one), and X1..Xn other
// orthogonal axes. We build these vectors by substracting all the ones we already
// know from an initial set of orthogonal ones, one by one, then normalize them
var
  i, j, k, Dim: integer;
  LargestIdx: integer;
  Largest, L: TsdFloat;
begin
  Dim := length(ANormal);
  // Find largest absolute component
  LargestIdx := -1;
  Largest := 0;
  for i := 0 to Dim - 1 do begin
    L := abs(ANormal[i]);
    if L > Largest then begin
      Largest := L;
      LargestIdx := i;
    end;
  end;
  if LargestIdx = -1 then
    exit;

  SetMatrixSize(A, Dim, Dim);
  j := 0;
  for i := 0 to Dim - 2 do begin
    // Build orthogonal set, skipping largest
    if i = LargestIdx then inc(j);
    A[i, j] := 1;
    inc(j);
  end;
  // Copy normal in last column
  Move(ANormal[0], A[Dim - 1, 0], Dim * SizeOf(TsdFloat));

  // Process each new orthonormal axis
  for i := Dim - 2 downto 0 do begin
    for j := Dim - 1 downto i + 1 do begin
      // Substract A[j]'s part from A[i]
      L := VectorDot(A[i], A[j]);
      for k := 0 to Dim - 1 do
        A[i, k] := A[i, k] - L * A[j, k];
    end;
    // Now normalize the new orthonormal axis
    Normalize(A[i]);
  end;
end;

procedure ReduceDimensionality(const Source: TsdMatrix; var Dest: TsdMatrix; const ANormal: TsdVector);
var
  i, j, k: integer;
  Dim: integer;
  A: TsdMatrix;
begin
  Dim := length(ANormal);
  // Build a new orthonormal set in Dim
  BuildOrthoNormalSet(ANormal, A);
  // Transform Source to Dest, but skip last column
  for i := 0 to length(Source) - 1 do begin
    SetLength(Dest[i], Dim - 1);
    for j := 0 to Dim - 2 do begin
      Dest[i, j] := 0;
      for k := 0 to Dim - 1 do
        Dest[i, j] := Dest[i, j] + A[j, k] * Source[i, k];
    end;
  end;
end;

end.

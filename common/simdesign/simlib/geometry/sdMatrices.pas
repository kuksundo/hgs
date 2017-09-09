unit sdMatrices;
{
  Description:

  This unit implements a basic TsdVector and TsdMatrix class, which allow to
  work with vectors and matrices.
  There are vector and matrix functions for addition, multiplication, inverse etc.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 14Feb2002

  Modifications:
  28Aug2005: Updated with some additional functionality
  08Sep2005: Added TsdSparseMatrix class
  08Sep2005: Added MatBackSolve procedure

  copyright (2) 2002 - 2005 SimDesign B.V.
}

interface

uses
  Classes, SysUtils, Math;

const
  // This value is used as limit: abs(V) < cMachEps equals zero
  cMachEps = 1E-100;

type

  PDouble = ^double;

  TProgressFunc = procedure (Progress: double; Info: pointer);

  TsdVector = class;

  // TsdMatrix implements the basic matrix object.
  TsdMatrix = class(TPersistent)
  private
    FColCount: integer;      // Number of columns
    FElem: array of double;  // Dynamic array with element values
    function GetRowCount: integer; virtual;
    procedure SetCount(const Value: integer);
  protected
    function GetCount: integer; virtual;
    function GetElem(ARow, ACol: integer): double; virtual;
    function GetRows(Index: integer): PDouble;
    procedure SetColCount(AColCount: integer);
    procedure SetElem(ARow, ACol: integer; AValue: double); virtual;
    procedure SetRowCount(ARowCount: integer);
  public
    constructor Create; virtual;
    constructor CreateSize(ARowCount: integer; AColCount: integer);
    destructor Destroy; override;
    // Return the maximum of the absolute value of all elements
    function MaxOfAbsValues: double;
    // Add the matrix A at location [AtRow,AtCol]
    procedure AddMatrix(A: TsdMatrix; AtRow: integer = 0; AtCol: integer = 0);
    // Assign the contents of another matrix to this matrix
    procedure Assign(Source: TPersistent); override;
    // Change the size of the matrix to ARowCount rows and AColCount columns.
    // The original data will be preserved if possible
    procedure ChangeSize(ARowCount, AColCount: integer);
    // Clear the contents of the matrix. It will be filled with zeros
    procedure Clear; virtual;
    // Delete one column and move the rest left. ColumnCount will be decreased
    procedure ColDelete(Index: integer);
    // Insert one column of zeros and move the rest right. ColumnCount will be increased
    procedure ColInsert(Index: integer);
    // ElemIdx returns the index into the element array if it is a valid index,
    // or -1 if it is invalid
    function ElemIdx(ARow, ACol: integer): integer;
    // IsVector returns true if either RowCount or ColCount equals 1
    function IsVector: boolean;
    // Negate all elements (multiply by -1)
    procedure Negate;
    // Returns the number of non-zero elements on ARow
    function RowNonZeroesCount(ARow: integer): integer; virtual;
    // Returns the i'th nonzero element of the row, where Index = 0 means the first.
    // The value is returned in AValue and the column in ACol.
    procedure RowNonZeroElement(ARow, Index: integer; var ACol: integer; var AValue: double); virtual;
    // Scale all elements in the row by Scale
    procedure RowScale(ARow: integer; const Scale: double); virtual;
    // Multiply the row ARow with AVec and put the sum of all products in the result
    function RowMultiply(ARow: integer; AVec: TsdVector): double; virtual;
    // First scale all elements in the AddRow, then add them to ARow
    procedure RowAddScale(ARow, AddRow: integer; const Scale: double; const StartCol: integer = 0); virtual;
    // Copy from the matrix From the FromRow to our ARow.
    procedure RowCopy(ARow: integer; From: TsdMatrix; FromRow: integer); virtual;
    // Multiply all elements with Scale
    procedure ScaleBy(const Scale: double);
    // Set the size of the matrix to ARowCount rows and AColCount columns. Note: the
    // matrix will be cleared, even if size doesnt change!
    procedure SetSize(ARowCount, AColCount: integer); virtual;
    // Set this matrix to an identity matrix. Note that RowCount and ColCount must
    // match.
    procedure SetToIdentity;
    // SizeEquals returns True if the size of this matrix corresponds to the size
    // of AMatrix. In case both are vectors, the count property is checked
    function SizeEquals(AMatrix: TsdMatrix): boolean;
    // Write to a string in CSV format
    function WriteToCsv(AFormat: string = '%5.3f'; Separator: string = #9): string; virtual;
    // ColCount holds the number of columns in the matrix. Set Colcount to change
    // the number of columns. The original data will be preserved if possible
    property ColCount: integer read FColCount write SetColCount;
    // Read Elem[ARow, ACol] to get the matrix element at row ARow and at column ACol.
    // Assign a double value to Elem[ARow, ACol] to set this matrix element.
    property Elem[ARow, ACol: integer]: double read GetElem write SetElem; default;
    // Rows returns a pointer to the first value on row Index.
    property Rows[Index: integer]: PDouble read GetRows;
    // RowCount holds the number of rows in the matrix. Set RowCount to change
    // the number of rows. The original data will be preserved if possible
    property RowCount: integer read GetRowCount write SetRowCount;
    // Count represents the number of elements in the matrix (RowCount * ColCount)
    // for full matrices, or the number of elements for sparse matrices.
    property Count: integer read GetCount write SetCount;
  end;

  TsdMatrixClass = class of TsdMatrix;

  TsdSparseIndex = record
    Col: integer;
    Val: integer;
  end;

  TsdSparseMatrix = class(TsdMatrix)
  private
    FRowCount: integer;
    FIndices: array of array of TsdSparseIndex;
    FCounts: array of integer;
    FElemCount: integer;
    FReuse: array of integer;
    FReuseCount: integer;
    function GetColIdx(ARow, ACol: integer): integer;
    function GetRowCount: integer; override;
  protected
    function GetCount: integer; override;
    function GetElem(ARow, ACol: integer): double; override;
    procedure SetElem(ARow, ACol: integer; AValue: double); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function RowNonZeroesCount(ARow: integer): integer; override;
    procedure RowNonZeroElement(ARow, Index: integer; var ACol: integer; var AValue: double); override;
    procedure RowScale(ARow: integer; const Scale: double); override;
    function RowMultiply(ARow: integer; AVec: TsdVector): double; override;
    procedure RowAddScale(ARow, AddRow: integer; const Scale: double; const StartCol: integer = 0); override;
    procedure RowCopy(ARow: integer; From: TsdMatrix; FromRow: integer); override;
    procedure SetSize(ARowCount, AColCount: integer); override;
  end;

  // TsdVector implements a vector of free length
  TsdVector = class(TsdMatrix)
  private
    function GetElemV(Index: integer): double;
    procedure SetElemV(Index: integer; const Value: double);
    function GetLength: double;
  public
    constructor Create; override;
    constructor CreateCount(ACount: integer);
    procedure SetCount(ACount: integer);
    procedure InsertElem(Index: integer; const Value: double);
    // Write to a string in CSV format
    function WriteToCsv(AFormat: string = '%5.3f'; Separator: string = #9): string; override;
    property Elem[Index: integer]: double read GetElemV write SetElemV; default;
    property Length: double read GetLength;
  end;

// Transpose a matrix: Result = A'
procedure Transpose(A: TsdMatrix; var Result: TsdMatrix);

// Multiply two matrices  Result = A * B. If Result = nil, Result will be created.
// The function can be used safely, even if Result = A or Result = B,
procedure MatMultiply(A, B: TsdMatrix; var Result: TsdMatrix); overload;

// Multiply matrix with constant Result := A * C where C is a float constant
procedure MatMultiply(A: TsdMatrix; C: double; var Result: TsdMatrix); overload;

// Multiply matrix with vector, resulting in vector Result Result = A * B. This
// procedure is slightly faster than when working with 3 matrices due to lack
// of inner loop
procedure MatMultiply(A: TsdMatrix; B: TsdVector; var Result: TsdVector); overload;

// Add matrices: Result = A + B. If Result = nil, Result will be created.
procedure MatAdd(A, B: TsdMatrix; var Result: TsdMatrix);

// Substract matrices: Result = A - B. If Result = nil, Result will be created.
procedure MatSubstract(A, B: TsdMatrix; var Result: TsdMatrix);

// Calculate inverse AI of a matrix A by using Gauss elimination
//  A=NxN square matrix
procedure MatInverseGauss(A: TsdMatrix; var AI: TsdMatrix);

// Calculate Moore-Penrose inverse AI of matrix A:
// for R < C:
//      -1    T        T -1
//     J   = J * (J * J )
//      MP
//
// for R > C:
//      -1          T     -1 T
//     J   = (J * (J * J )  )
//      MP
//
// for R = C:
//      -1     -1
//     J   =  J
//      MP
//
// The Moore-Penrose inverse can be used to solve a linear system A*x = B where
// A is a M by N matrix, X is a 1 by N vector and B is a 1 by N vector, so for
// a system with M equations and N unknowns.
// The solution is x = AinvMP * B
procedure MatInverseMP(A: TsdMatrix; var AI: TsdMatrix);

// Backsolve the equation A * X = B so that the vector X is given as a result.
procedure MatBackSolve(A: TsdMatrix; X, B: TsdVector; OnProgress: TProgressFunc = nil; Info: pointer = nil);

// Backsolve the equation A * X = B with A being a symmetrical matrix. Note that only
// elements of A are considered where Col >= Row, the other values (lower triangle
// values) MUST be zero, and are assumed to be such that A[Col, Row] = A[Row, Col].
// Usually this kind of system is found in FEM, and usually a sparse matrix type
// is used.
procedure MatBackSolveSymmetrical(A: TsdMatrix; X, B: TsdVector; OnProgress: TProgressFunc = nil; Info: pointer = nil);

// Multiply vector with constant Result := A * C where C is a float constant
procedure VecMultiply(A: TsdVector; C: double; var Result: TsdVector);

// Substract vectors: Result = A - B. If Result = nil, Result will be created.
procedure VecSubstract(A, B: TsdVector; var Result: TsdVector);

// Calculate the vector dot product of V1 and V2, which is the sum of all the
// products of the elements.
function VecDotProduct(V1, V2: TsdMatrix): double;

resourcestring

  sMatrixMustBeAssigned          = 'Matrix must be assigned';
  sInnerDimensionsMustAgree      = 'Inner matrix dimensions must agree';
  sDimensionsMustAgree           = 'Matrix dimensions must agree';
  sMatrixIsNotSquare             = 'Matrix is not square';
  sRowCountAndColCountDoNotMatch = 'RowCount and ColCount do not match';
  sErrInverseMatrixIsSingular    = 'Error calculating inverse: matrix is singular';
  sIllegalIndex                  = 'Illegal index value';

implementation


{ TsdMatrix }

procedure TsdMatrix.AddMatrix(A: TsdMatrix; AtRow, AtCol: integer);
var
  r, c, Idx: integer;
begin
  if not assigned(A) then
    raise Exception.Create(sMatrixMustBeAssigned);
  for r := 0 to A.RowCount - 1 do
    for c := 0 to A.ColCount - 1 do
    begin
      Idx := ElemIdx(r + AtRow, c + AtCol);
      if Idx >= 0 then
        FElem[Idx] := FElem[Idx] + A[r, c];
    end;
end;

procedure TsdMatrix.Assign(Source: TPersistent);
var
  L: integer;
begin
  if (Source.ClassType = TsdMatrix) or (Source.Classtype = TsdVector) then
  begin
    FColCount := TsdMatrix(Source).FColCount;
    L := length(TsdMatrix(Source).FElem);
    SetLength(FElem, L);
    if L > 0 then
      Move(TsdMatrix(Source).FElem[0], FElem[0], L * sizeOf(double));
    exit;
  end;
  inherited;
end;

procedure TsdMatrix.ChangeSize(ARowCount, AColCount: integer);
var
  OldRowCount: integer;
begin
  OldRowCount := GetRowCount;
  if (ARowCount <> OldRowCount) or (AColCount <> FColCount) then
  begin
    // Shrink rows
    if ARowCount < OldRowCount then SetRowCount(ARowCount);
    // Change columns
    SetColCount(AColCount);
    // Grow rows
    SetRowCount(ARowCount);
  end;
end;

procedure TsdMatrix.Clear;
var
  L: integer;
begin
  // Fill the array with zeros
  L := length(FElem);
  if L > 0 then
    FillChar(FElem[0], L * Sizeof(double), 0);
end;

procedure TsdMatrix.ColDelete(Index: integer);
var
  r, c: integer;
begin
  if ColCount > 0 then
  begin
    for r := 0 to RowCount - 1 do
      for c := Index to ColCount - 2 do
        Elem[r, c] := Elem[r, c + 1];
    ColCount := ColCount - 1;
  end;
end;

procedure TsdMatrix.ColInsert(Index: integer);
var
  r, c: integer;
begin
  if (Index >= 0) and (Index <= ColCount) then
  begin
    ColCount := ColCount + 1;
    for r := 0 to RowCount - 1 do
    begin
      for c := ColCount - 1 downto Index + 1 do
        Elem[r, c] := Elem[r, c - 1];
      Elem[r, Index] := 0;
    end;
  end;
end;

constructor TsdMatrix.Create;
begin
  inherited Create;
end;

constructor TsdMatrix.CreateSize(ARowCount, AColCount: integer);
begin
  Create;
  SetSize(ARowCount, AColCount);
end;

destructor TsdMatrix.Destroy;
begin
  FElem := nil;
  inherited;
end;

function TsdMatrix.ElemIdx(ARow, ACol: integer): integer;
begin
  Result := ARow * FColCount + ACol;
  if (Result < 0) or (Result >= length(FElem)) then
    Result := -1;
end;

function TsdMatrix.GetCount: integer;
begin
  Result := length(FElem);
end;

function TsdMatrix.GetElem(ARow, ACol: integer): double;
var
  Idx: integer;
begin
  Result := 0;
  Idx := ARow * FColCount + ACol;
  if (Idx >=0) and (Idx < length(FElem)) then
    Result := FElem[Idx];
end;

function TsdMatrix.GetRowCount: integer;
begin
  if FColCount = 0 then
    Result := 0
  else
    Result := length(FElem) div FColCount;
end;

function TsdMatrix.GetRows(Index: integer): PDouble;
var
  Idx: integer;
begin
  Result := nil;
  Idx := Index * FColCount;
  if (Idx >= 0) and (Idx < length(FElem)) then
    Result := @FElem[Idx];
end;

function TsdMatrix.IsVector: boolean;
begin
  Result := (RowCount = 1) or (ColCount = 1);
end;

function TsdMatrix.MaxOfAbsValues: double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to length(FElem) - 1 do
    Result := Max(Result, abs(FElem[i]));
end;

procedure TsdMatrix.Negate;
var
  i: integer;
begin
  for i := 0 to length(FElem) - 1 do
    FElem[i] := -FElem[i];
end;

procedure TsdMatrix.RowAddScale(ARow, AddRow: integer;
  const Scale: double; const StartCol: integer);
var
  i: integer;
  R, A: PDouble;
begin
  R := GetRows(ARow);
  A := GetRows(AddRow);
  if not assigned(R) or not assigned(A) then exit;
  inc(R, StartCol);
  for i := StartCol to FColCount - 1 do
  begin
    R^ := R^ + A^ * Scale;
    inc(R);
    inc(A);
  end;
end;

procedure TsdMatrix.RowCopy(ARow: integer; From: TsdMatrix;
  FromRow: integer);
var
  R, F: PDouble;
  ACount: integer;
begin
  if not assigned(From) then exit;
  R := GetRows(ARow);
  F := From.GetRows(FromRow);
  if not assigned(R) or not assigned(F) then exit;
  ACount := Min(FColCount, From.FColCount);
  Move(F^, R^, ACount * SizeOf(double));
end;

function TsdMatrix.RowMultiply(ARow: integer; AVec: TsdVector): double;
var
  i: integer;
  R: PDouble;
begin
  Result := 0;
  if FColCount <> AVec.Count then exit;
  R := GetRows(ARow);
  for i := 0 to FColCount - 1 do
  begin
    Result := Result + R^ * AVec[i];
    inc(R);
  end;
end;

procedure TsdMatrix.RowNonZeroElement(ARow, Index: integer; var ACol: integer; var AValue: double);
var
  i, NonZeroes: integer;
  R: PDouble;
begin
  // This method is very inefficient for the standard matrix class! See
  // TsdSparseMatrix for efficient method
  NonZeroes := 0;
  R := GetRows(ARow);
  for i := 0 to FColCount - 1 do
  begin
    if abs(R^) >= cMachEps then
    begin
      if NonZeroes = Index then
      begin
        AValue := R^;
        ACol := i;
        exit;
      end;
      inc(NonZeroes);
    end;
    inc(R);
  end;
  // if we arrive here we didn't find any value
  raise Exception.Create(sIllegalIndex);
end;

function TsdMatrix.RowNonZeroesCount(ARow: integer): integer;
var
  i: integer;
  R: PDouble;
begin
  Result := 0;
  R := GetRows(ARow);
  if not assigned(R) then exit;
  for i := 0 to FColCount - 1 do
  begin
    if abs(R^) >= cMachEps then inc(Result);
    inc(R);
  end;
end;

procedure TsdMatrix.RowScale(ARow: integer; const Scale: double);
var
  i: integer;
  R: PDouble;
begin
  R := GetRows(ARow);
  if not assigned(R) then exit;
  for i := 0 to FColCount - 1 do
  begin
    R^ := R^ * Scale;
    inc(R);
  end;
end;

procedure TsdMatrix.ScaleBy(const Scale: double);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    FElem[i] := FElem[i] * Scale;
end;

procedure TsdMatrix.SetColCount(AColCount: integer);
var
  r, OldRowCount: integer;
begin
  if AColCount <> FColCount then
  begin

    if AColCount < FColCount then
    begin

      // Shrink the data
      if AColCount > 0 then
        for r := 1 to RowCount - 1 do
          Move(FElem[r * FColCount], FElem[r * AColCount], AColCount * Sizeof(double));

      // Set new size last
      SetLength(FElem, AColCount * GetRowCount * Sizeof(double));

    end else
    begin

      // Set new size first
      OldRowCount := GetRowCount;
      SetLength(FElem, AColCount * OldRowCount * Sizeof(double));

      // Grow the data

      for r := OldRowCount - 1 downto 1 do
      begin
        if FColCount > 0 then
          Move(FElem[r * FColCount], FElem[r * AColCount], FColCount * Sizeof(double));
        // Fill the new part with zeros
        FillChar(FElem[r * AColCount + FColCount], (AColCount - FColCount) * Sizeof(double), 0);
      end;

    end;

    // Set new column count
    FColCount := AColCount;
  end;
end;

procedure TsdMatrix.SetCount(const Value: integer);
begin
  if Value <> length(FElem) then
    SetLength(FElem, Value);
end;

procedure TsdMatrix.SetElem(ARow, ACol: integer; AValue: double);
var
  Idx: integer;
begin
  Idx := ARow * FColCount + ACol;
  if (Idx >= 0) and (Idx < length(FElem)) then
    FElem[Idx] := AValue;
end;

procedure TsdMatrix.SetRowCount(ARowCount: integer);
var
  OldRowCount: integer;
begin
  OldRowCount := GetRowCount;
  if ARowCount <> OldRowCount then
  begin

    // Set new size
    SetLength(FElem, FColCount * ARowCount * Sizeof(double));

    // Fill the new part with zeros
    if ARowCount > OldRowCount then
      FillChar(FElem[OldRowCount * FColCount], (ARowCount - OldRowCount) * FColCount * Sizeof(double), 0);
  end;
end;

procedure TsdMatrix.SetSize(ARowCount, AColCount: integer);
begin
  // Set rows and columns
  FColCount := AColCount;
  SetLength(FElem, ARowCount * AColCount);
  // Data will be cleared
  Clear;
end;

procedure TsdMatrix.SetToIdentity;
var
  i: integer;
begin
  if RowCount <> ColCount then
    raise Exception.Create(sRowCountAndColCountDoNotMatch);
  Clear;
  for i := 0 to ColCount - 1 do
    Elem[i, i] := 1;
end;

function TsdMatrix.SizeEquals(AMatrix: TsdMatrix): boolean;
begin
  Result := False;
  if not assigned(AMatrix) then exit;
  if (ColCount <> AMatrix.ColCount) or (RowCount <> AMatrix.RowCount) then
  begin
    if IsVector and AMatrix.IsVector and (Count = AMatrix.Count) then
    begin
      Result := True;
      exit;
    end;
    Result := False;
    exit;
  end;
  Result := True;
end;

function TsdMatrix.WriteToCsv(AFormat, Separator: string): string;
var
  r, c: integer;
function XValue(AValue: double): string;
begin
  if abs(AValue) = 0 then Result := '.'
  else if abs(AValue) < 1E-20 then Result := '0'
      else Result := 'X';
end;
begin
  Result := '';
  for r := 0 to RowCount - 1 do
  begin
    for c := 0 to ColCount - 1 do
    begin
      if AFormat = 'X' then
        Result := Result + XValue(Elem[r, c])
      else
        Result := Result + Format(AFormat, [Elem[r, c]]);
      if c < ColCount - 1 then
        Result := Result + Separator;
    end;
    Result := Result + #13#10;
  end;
end;

{ TsdSparseMatrix }

procedure TsdSparseMatrix.Clear;
var
 i: integer;
begin
  SetLength(FElem, 0);
  FElemCount := 0;
  for i := 0 to FRowCount - 1 do
  begin
    SetLength(FIndices[i], 0);
    FCounts[i] := 0;
  end;
  SetLength(FReuse, 0);
  FReuseCount := 0;
end;

destructor TsdSparseMatrix.Destroy;
begin
  Clear;
  FIndices := nil;
  FCounts := nil;
  inherited;
end;

function TsdSparseMatrix.GetColIdx(ARow, ACol: integer): integer;
var
  IdxMin, IdxMax, IdxMid: integer;
  ColMin, ColMax, ColMid: integer;
begin
  // no check for row validity!
  Result := -1;
  if FCounts[ARow] = 0 then exit;

  IdxMin := 0;
  IdxMax := FCounts[ARow] - 1;
  if IdxMin <= IdxMax then
  begin

    // Check min and max
    ColMax := FIndices[ARow, IdxMax].Col;
    if ACol > ColMax then exit;
    ColMin := FIndices[ARow, IdxMin].Col;
    if ACol < ColMin then exit;

    // compare
    if ACol = ColMin then
    begin
      Result := IdxMin;
      exit;
    end;
    if ACol = ColMax then
    begin
      Result := IdxMax;
      exit;
    end;

    // binary search
    repeat
      if (IdxMax - IdxMin) <= 1 then exit;
      IdxMid := (IdxMin + IdxMax) shr 1;
      ColMid := FIndices[ARow, IdxMid].Col;
      if ACol < ColMid then
      begin
        IdxMax := IdxMid;
      end else if ACol > ColMid then
      begin
        IdxMin := IdxMid;
      end else
      begin
        Result := IdxMid;
        exit;
      end;
    until False;
  end;
end;

function TsdSparseMatrix.GetCount: integer;
begin
  Result := FElemCount - FReuseCount;
end;

function TsdSparseMatrix.GetElem(ARow, ACol: integer): double;
var
  ColIdx: integer;
begin
  // To do: make into binary search
  Result := 0;
  if (ARow < 0) or (ARow >= FRowCount) or (FCounts[ARow] = 0) then exit;
  ColIdx := GetColIdx(ARow, ACol);
  if ColIdx >= 0 then
    Result := FElem[FIndices[ARow, ColIdx].Val];
end;

function TsdSparseMatrix.GetRowCount: integer;
begin
  Result := FRowCount;
end;

procedure TsdSparseMatrix.RowAddScale(ARow, AddRow: integer;
  const Scale: double; const StartCol: integer);
var
  i: integer;
  SrcIdx, SrcCol, DstColIdx, DstIdx: integer;
  V: double;
  DstHasCol: boolean;
begin
  if (ARow < 0) or (ARow >= FRowCount) or (AddRow < 0) or (AddRow >= FRowCount) then exit;

  // we run this backwards to avoid problems with deleting values
  DstColIdx := FCounts[ARow] - 1;
  for i := FCounts[AddRow] - 1 downto 0 do
  begin
    SrcIdx := FIndices[AddRow, i].Val;
    SrcCol := FIndices[AddRow, i].Col;
    if SrcCol < StartCol then exit;

    // Find Dst ColIndex
    DstHasCol := False;
    while DstColIdx >= 0 do
    begin
      if FIndices[ARow, DstColIdx].Col <= SrcCol then
      begin
        DstHasCol := FIndices[ARow, DstColIdx].Col = SrcCol;
        break;
      end;
      dec(DstColIdx);
    end;

    // Does ARow have this column?
    if DstHasCol then
    begin
      // Calculate new value
      DstIdx := FIndices[ARow, DstColIdx].Val;
      V := FElem[DstIdx] + FElem[SrcIdx] * Scale;
      if abs(V) < cMachEps then
        SetElem(ARow, SrcCol, 0)
      else
        FElem[DstIdx] := V;
      dec(DstColIdx);
    end else
      // Original value is zero
      SetElem(ARow, SrcCol, FElem[SrcIdx] * Scale);
  end;
end;

procedure TsdSparseMatrix.RowCopy(ARow: integer; From: TsdMatrix;
  FromRow: integer);
var
  i: integer;
  ACount, FromCount: integer;
begin
  if not (From is TsdSparseMatrix) then exit;
  if (ARow < 0) or (ARow >= FRowCount) then exit;
  if (FromRow < 0) or (FromRow >= From.RowCount) then exit;
  FromCount := TsdSparseMatrix(From).FCounts[FromRow];
  if FCounts[ARow] < FromCount then
  begin
    // We must add some data
    ACount := FromCount - FCounts[ARow];
    SetLength(FIndices[ARow], FromCount);
    for i := 0 to ACount - 1 do
      FIndices[ARow, FCounts[ARow] + i].Val := FElemCount + i;
    FCounts[ARow] := FromCount;
    // Add the element data too
    inc(FElemCount, ACount);
    if length(FElem) <= FElemCount then
      SetLength(FElem, round(FElemCount * 1.5) + 100);
  end else
    if FCounts[ARow] > FromCount then
    begin
      // We must remove some data
      FCounts[ARow] := FromCount;
      SetLength(FIndices[ARow], FromCount);
    end;

  // Now copy the data
  for i := 0 to FCounts[ARow] - 1 do
  begin
    // column pointers
    FIndices[ARow, i].Col := TsdSparseMatrix(From).FIndices[FromRow, i].Col;
    // element value
    FElem[FIndices[ARow, i].Val] :=
      TsdSparseMatrix(From).FElem[TsdSparseMatrix(From).FIndices[FromRow, i].Val];
  end;
end;

function TsdSparseMatrix.RowMultiply(ARow: integer;
  AVec: TsdVector): double;
var
  i, Idx, Col: integer;
begin
  if FColCount <> AVec.Count then
    raise Exception(sDimensionsMustAgree);
  Result := 0;
  for i := 0 to FCounts[ARow] - 1 do
  begin
    Idx := FIndices[ARow, i].Val;
    Col := FIndices[ARow, i].Col;
    Result := Result + AVec[Col] * FElem[Idx];
  end;
end;

procedure TsdSparseMatrix.RowNonZeroElement(ARow, Index: integer; var ACol: integer; var AValue: double);
begin
  if (Index >= 0) and (Index < FCounts[ARow]) then
  begin
    AValue := FElem[FIndices[ARow, Index].Val];
    ACol := FIndices[ARow, Index].Col;
  end else
    raise Exception.Create(sIllegalIndex);
end;

function TsdSparseMatrix.RowNonZeroesCount(ARow: integer): integer;
begin
  Result := FCounts[ARow];
end;

procedure TsdSparseMatrix.RowScale(ARow: integer; const Scale: double);
var
  i: integer;
  Idx: integer;
begin
  if (ARow < 0) or (ARow >= FRowCount) then exit;
    for i := 0 to FCounts[ARow] - 1 do
    begin
      Idx := FIndices[ARow, i].Val;
      FElem[Idx] := FElem[Idx] * Scale;
    end;
end;

procedure TsdSparseMatrix.SetElem(ARow, ACol: integer; AValue: double);
var
  ColIdx: integer;
begin
  if (ARow < 0) or (ARow >= FRowCount) then exit;
  if (ACol < 0) or (ACol >= FColCount) then exit;

  // Do we set it to 0 or another value?
  if AValue = 0 then
  begin

    // Find element
    ColIdx := GetColIdx(ARow, ACol);
    if ColIdx < 0 then exit;

    // Clear the element and add it to the Reuse list
    if length(FReuse) = FReuseCount then
      SetLength(FReuse, round(FReuseCount * 1.5) + 10);
    FReuse[FReuseCount] := FIndices[ARow, ColIdx].Val;
    inc(FReuseCount);

    // Move the index
    if ColIdx < FCounts[ARow] - 1 then
      Move(FIndices[ARow, ColIdx + 1], FIndices[ARow, ColIdx],
        (FCounts[ARow] - ColIdx - 1) * SizeOf(TsdSparseIndex));
    dec(FCounts[ARow]);
    SetLength(FIndices[ARow], FCounts[ARow]);

  end else
  begin

    // Find element
    ColIdx := GetColIdx(ARow, ACol);
    if ColIdx < 0 then
    begin

      // Add new element, find insert position
      ColIdx := 0;
      while
        (ColIdx < FCounts[ARow]) and
        (FIndices[ARow, ColIdx].Col < ACol) do
        inc(ColIdx);

      // Add data to index
      if FCounts[ARow] = length(FIndices[ARow]) then
        SetLength(FIndices[ARow], FCounts[ARow] + 4);

      // Move index further to make place
      if ColIdx < FCounts[ARow] then
        Move(FIndices[ARow, ColIdx], FIndices[ARow, ColIdx + 1],
          (FCounts[ARow] - ColIdx) * SizeOf(TsdSparseIndex));
      inc(FCounts[ARow]);
      FIndices[ARow, ColIdx].Col := ACol;

      // Can we reuse an element?
      if FReuseCount > 0 then
      begin

        FIndices[ARow, ColIdx].Val := FReuse[FReuseCount - 1];
        dec(FReuseCount);

      end else
      begin

        // Assign new element
        FIndices[ARow, ColIdx].Val := FElemCount;

        // allocate new memory
        if length(FElem) <= FElemCount then
          SetLength(FElem, round(FElemCount * 1.5) + 100);

        // increment to represent the new number of elements
        inc(FElemCount);
      end;
    end;

    // finally set it
    FElem[FIndices[ARow, ColIdx].Val] := AValue;
  end;
end;

procedure TsdSparseMatrix.SetSize(ARowCount, AColCount: integer);
begin
  Clear;
  // Set rows and columns
  FRowCount := ARowCount;
  FColCount := AColCount;
  SetLength(FIndices, FRowCount);
  SetLength(FCounts, FRowCount);
end;

{ TsdVector }

constructor TsdVector.Create;
begin
  inherited;
  FColCount := 1;
end;

constructor TsdVector.CreateCount(ACount: integer);
begin
  Create;
  SetSize(ACount, 1);
end;

function TsdVector.GetElemV(Index: integer): double;
begin
  Result := 0;
  if (Index >= 0) and (Index < system.Length(FElem)) then
    Result := FElem[Index];
end;

function TsdVector.GetLength: double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    Result := Result + Sqr(Elem[i]);
  Result := Sqrt(Result);
end;

procedure TsdVector.InsertElem(Index: integer; const Value: double);
begin
  if (Index < 0) or (Index > Count) then exit;
  // Set new length
  Count := Count + 1;
  // copy old values
  Move(FElem[Index], FElem[Index + 1], Count - Index - 1);
  FElem[Index] := Value;
end;

procedure TsdVector.SetCount(ACount: integer);
begin
  SetSize(ACount, 1);
end;

procedure TsdVector.SetElemV(Index: integer; const Value: double);
begin
  if (Index >= 0) and (Index < system.length(FElem)) then
    FElem[Index] := Value;
end;

function TsdVector.WriteToCsv(AFormat, Separator: string): string;
var
  c: integer;
begin
  Result := '';
  for c := 0 to Count - 1 do
  begin
    Result := Result + Format(AFormat, [Elem[c]]);
    if c < Count - 1 then
       Result := Result + Separator;
  end;
  Result := Result + #13;
end;

{ Matrix procedures }

procedure Transpose(A: TsdMatrix; var Result: TsdMatrix);
// Transpose a matrix: Result = A'
var
  i, j: integer;
  Res: TsdMatrix;
begin
  if not assigned(A) then
    raise Exception.Create(sMatrixMustBeAssigned);

  // Create transposed dimensions
  if not assigned(Result) or (Result = A) then
    Res := TsdMatrix.Create
  else
    Res := Result;
  Res.SetSize(A.ColCount, A.RowCount);

  // Transpose the elements
  for i := 0 to A.RowCount - 1 do
    for j := 0 to A.ColCount - 1 do
      Res[j, i] := A[i, j];

  // Update
  if (Res = Result) or not assigned(Result) then
    Result := Res
  else
  begin
    Result.Assign(Res);
    Res.Free;
  end;
end;

procedure MatMultiply(A, B: TsdMatrix; var Result: TsdMatrix);
// Multiply two matrices  Result = A * B
var
  i,j,k: integer;
  R: double;
  Res: TsdMatrix;
begin
  // Check
  if not assigned(A) or not assigned(B) then
    raise Exception.Create(sMatrixMustBeAssigned);
  if A.ColCount <> B.RowCount then
    raise Exception.Create(sInnerDimensionsMustAgree);

  if not assigned(Result) or (Result = A) or (Result = B) then
    Res := TsdMatrix.Create
  else
    Res := Result;
  Res.SetSize(A.RowCount, B.ColCount);

  // Do the multiplication
  for i := 0 to A.RowCount - 1 do
    for j := 0 to B.ColCount - 1 do
    begin
      R := 0;
      for k := 0 to A.ColCount - 1 do
        R := R + A[i, k] * B[k, j];
      Res[i,j] := R;
    end;

  // Update
  if (Res = Result) or not assigned(Result) then
    Result := Res
  else
  begin
    Result.Assign(Res);
    Res.Free;
  end;
end;

procedure MatMultiply(A: TsdMatrix; C: double; var Result: TsdMatrix);
// Multiply matrix with constant Result := A * C where C is a float constant
begin
  if not assigned(A) then
    raise Exception.create(sMatrixMustBeAssigned);
  if Result = A then
  begin
    A.ScaleBy(C);
    exit;
  end;
  if not assigned(Result) then
    Result.Create;
  Result.Assign(A);
  Result.ScaleBy(C);
end;

procedure MatMultiply(A: TsdMatrix; B: TsdVector; var Result: TsdVector);
var
  r, c: integer;
  Value: double;
  Res: TsdVector;
begin
  if not assigned(A) then exit;
  if A.ColCount <> B.Count then
    raise Exception.Create(sInnerDimensionsMustAgree);

  if not assigned(Result) or (Result = A) then
    Res := TsdVector.Create
  else
    Res := Result;
  Res.Count := A.RowCount;

  // Do multiplication
  for r := 0 to A.RowCount - 1 do
  begin
    Value := 0;
    for c := 0 to A.ColCount - 1 do
      Value := Value + A[r, c] * B[c];
    Res[r] := Value;
  end;

  // Update
  if (Res = Result) or not assigned(Result) then
    Result := Res
  else
  begin
    Result.Assign(Res);
    Res.Free;
  end;
end;

procedure MatAdd(A, B: TsdMatrix; var Result: TsdMatrix);
// Add matrices: Result = A + B. If Result = nil, Result will be created.
var
  i: integer;
begin
  // Check
  if not assigned(A) or not assigned(B) then
    raise Exception.Create(sMatrixMustBeAssigned);
  if not A.SizeEquals(B) then
    raise Exception.Create(sDimensionsMustAgree);

  // Set Result
  if not assigned(Result) then
    Result := TsdMatrixClass(A.ClassType).CreateSize(A.RowCount, A.ColCount)
  else
    Result.SetSize(A.RowCount, A.ColCount);

  // Do addition
  for i := 0 to Result.Count - 1 do
    Result.FElem[i] := A.FElem[i] + B.FElem[i];
end;

procedure MatSubstract(A, B: TsdMatrix; var Result: TsdMatrix);
var
  i: integer;
begin
  // Check
  if not assigned(A) or not assigned(B) then
    raise Exception.Create(sMatrixMustBeAssigned);
  if not A.SizeEquals(B) then
    raise Exception.Create(sDimensionsMustAgree);

  // Set Result
  if not assigned(Result) then
    Result := TsdMatrixClass(A.ClassType).CreateSize(A.RowCount, A.ColCount)
  else
    Result.SetSize(A.RowCount, A.ColCount);

  // Do substraction
  for i := 0 to Result.Count - 1 do
    Result.FElem[i] := A.FElem[i] - B.FElem[i];
end;

procedure MatInverseGauss(A: TsdMatrix; var AI: TsdMatrix);
// Calculate inverse AI of a matrix A by using Gauss elimination
//  A=NxN square matrix
var
  Dims: integer;
  Ipvt: array of integer;
  AInv: TsdMatrix;
  // local
  function MaxItem(Col: integer; var LastNZRow: integer): integer;
  var
    i: integer;
    M, AMax: double;
  begin
    AMax := 0;
    Result := -1;
    // loop through the Col-th column
    for i := Col to Dims - 1 do
    begin
      M := abs(A[Ipvt[i], Col]);
      if M > Amax then
      begin
        AMax := M;
        Result := i;
      end;
      if M > 0 then
        LastNZRow := i;
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
  procedure RowScale(Rw: integer; S: double);
  begin
    A.RowScale(Ipvt[Rw], S);
    AInv.RowScale(Ipvt[Rw], S);
  end;
  // local
  procedure RowAddScale(Rw, Ad: integer; S: double);
  var
    Row, Add: integer;
  begin
    Row := Ipvt[Rw];
    Add := Ipvt[Ad];
    A.RowAddScale(Row, Add, S);
    Ainv.RowAddScale(Row, Add, S);
  end;
// main
var
  i, j, Item, LastNZ: integer;
begin
  // Checks
  if not assigned(A) then exit;
  if A.RowCount <> A.ColCount then
    raise Exception.Create(sMatrixIsNotSquare);

  // Create inverse AInv
  Dims := A.RowCount;
  AInv := TsdMatrixClass(A.ClassType).CreateSize(Dims, Dims);
  // Initialise pivot vector
  SetLength(Ipvt, Dims);
  if assigned(AI) then AI.SetSize(Dims, Dims) else
    AI := TsdMatrixClass(A.ClassType).CreateSize(Dims, Dims);
  try

    // Create pivot vector
    for i := 0 to Dims - 1 do
    begin
      Ipvt[i] := i;
      // Make Ainv the Identity matrix
      AInv[i, i] := 1;
    end;

    // loop through the colums
    for i:=0 to Dims - 1 do
    begin
      // search the maximum in the column for cells with row >= i, this will be the pivot
      Item := MaxItem(i, LastNZ);

      // if we don't find a maximum, all col elements are 0, indicating a singular matrix
      if Item = -1 then
        raise Exception.Create(sErrInverseMatrixIsSingular);

      // if maximum not in cell (i,i), swap them (pivoting)
      if i <> Item then RowSwap(i, Item);

      // scale the row to 1/max
      RowScale(i, 1 / A[Ipvt[i], i]);
      for j := 0 to LastNZ do
        if (i <> j) and (A[Ipvt[j], i] <> 0.0) then
        begin
          RowAddScale(j, i, -A[Ipvt[j], i]);
          A[Ipvt[j], i] := 0;
        end;

    end;

    // now produce the inverse using the pivots
    for i := 0 to Dims - 1 do
      AI.RowCopy(i, AInv, Ipvt[i]);

  finally
    AInv.Free;
    IPvt := nil;
  end;
end;

procedure MatInverseMP(A: TsdMatrix; var AI: TsdMatrix);
var
  AT: TsdMatrix;         // transpose of A: C x R matrix
  T1, T2, T3: TsdMatrix; // temporary matrices
// main
begin
  AT := nil; T1 := nil; T2 := nil; T3 := nil;
  try
    if A.Rowcount < A.ColCount then
    begin

      // Underdetermined problem
      // T1 = A * A', R x R matrix
      Transpose(A, AT);
      MatMultiply(A, AT, T1);

       // T2 = inv(A * A')
      MatInverseGauss(T1, T2);

      // AI = AT x T2
      MatMultiply(AT, T2, AI);

    end else
    begin
      if A.RowCount > A.ColCount then
      begin

        // Overdetermined problem
        // T1 = A'*A, CxC matrix
        Transpose(A, AT);
        MatMultiply(At, A, T1);

        // T2 = inv(A'*A)
        MatInverseGauss(T1, T2);

        // T3 = A * inv(A'*A)
        MatMultiply(A, T2, T3);
        Transpose(T3, AI);

      end else
      begin

        MatInverseGauss(A, AI);

      end;
    end;
  finally
    // Clear our garbage
    FreeAndNil(AT);
    FreeAndNil(T1);
    FreeAndNil(T2);
    FreeAndNil(T3);
  end;
end;

procedure MatBackSolve(A: TsdMatrix; X, B: TsdVector; OnProgress: TProgressFunc; Info: pointer);
// Backsolve the equation A * X = B so that the vector X is given as a result.
var
  Dims: integer;
  Ipvt: array of integer;
  // local
  function MaxItem(Col: integer; var LastNZRow: integer): integer;
  var
    i: integer;
    M, AMax: double;
  begin
    AMax := 0;
    LastNZRow := -1;
    Result := -1;
    // loop through the Col-th column
    for i := Col to Dims - 1 do
    begin
      M := abs(A[Ipvt[i], Col]);
      if M > Amax then
      begin
        AMax := M;
        Result := i;
      end;
      if M > 0 then
        LastNZRow := i;
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
  procedure RowScale(Rw: integer; S: double);
  var
    Row: integer;
  begin
    Row := Ipvt[Rw];
    A.RowScale(Row, S);
    B[Row] := B[Row] * S;
  end;
  // local
  procedure RowAddScale(Rw, Ad: integer; S: double; StartCol: integer);
  var
    Row, Add: integer;
  begin
    Row := Ipvt[Rw];
    Add := Ipvt[Ad];
    A.RowAddScale(Row, Add, S, StartCol);
    B[Row] := B[Row] + S * B[Add];
  end;
// main
var
  i, j, Item, LastNZ: integer;
  V: double;
begin
  // Checks
  if not assigned(A) then exit;
  if A.RowCount <> A.ColCount then
    raise Exception.Create(sMatrixIsNotSquare);

  // Initialise pivot vector
  Dims := A.RowCount;
  if Dims = 0 then exit;
  SetLength(Ipvt, Dims);
  try

    // Create pivot vector
    for i := 0 to Dims - 1 do
      Ipvt[i] := i;

    // loop through the colums
    for i := 0 to Dims - 1 do
    begin
      // search the maximum in the column for cells with row >= i, this will be the pivot
      Item := MaxItem(i, LastNZ);

      // if we don't find a maximum, all col elements are 0, indicating a singular matrix
      if Item = -1 then
        raise Exception.Create(sErrInverseMatrixIsSingular);

      // if maximum not in cell (i,i), swap them (pivoting)
      if i <> Item then RowSwap(i, Item);

      // scale the row to 1/max
      RowScale(i, 1 / A[Ipvt[i], i]);
      // just do the lower triangle
      for j := i + 1 to LastNZ do
      begin
        V := A[Ipvt[j], i];
        if V <> 0.0 then
        begin
          A[Ipvt[j], i] := 0;
          RowAddScale(j, i, -V, i + 1);
        end;
      end;

      // Do a progress event if passed
      if assigned(OnProgress) then
        OnProgress((i + 1)/ (Dims + 1) * 100, Info);

    end;

    // now produce the solution using the pivots
    X.Clear;
    X[Ipvt[Dims - 1]] := B[Ipvt[Dims - 1]];
    for i := Dims - 2 downto 0 do
      X[Ipvt[i]] := B[Ipvt[i]] - A.RowMultiply(Ipvt[i], X);

    if assigned(OnProgress) then OnProgress(100, Info);

  finally
    IPvt := nil;
  end;
end;

procedure MatBackSolveSymmetrical(A: TsdMatrix; X, B: TsdVector; OnProgress: TProgressFunc = nil; Info: pointer = nil);
// Backsolve the equation A * X = B so that the vector X is given as a result. This routine assumes that matrix A is
// symmetrical (A[c,r] = A[r,c]). It also doesn't do row pivoting. Only the top triangle and diagonal have to be
// stored in the matrix A.
var
  Dims: integer;
  i, j, Col: integer;
  R, V, S: double;
begin
  // Checks
  if not assigned(A) then
    exit;
  if A.RowCount <> A.ColCount then
    raise Exception.Create(sMatrixIsNotSquare);

  Dims := A.RowCount;
  if Dims = 0 then
    exit;

  // loop through the colums
  for i := 0 to Dims - 1 do
  begin
    R := A[i, i];
    if abs(R) < cMachEps then
      raise Exception.Create(sErrInverseMatrixIsSingular);

    // Do elimitation
    for j := 1 to A.RowNonZeroesCount(i) - 1 do
    begin
      A.RowNonZeroElement(i, j, Col, V);
      if abs(V) >= cMachEps then
      begin
        S := -V/R;
        A.RowAddScale(Col, i, S, Col);
        B[Col] := B[Col] + S * B[i];
      end;
    end;

    // Do a progress event if passed each 10th row
    if i mod 10 = 0 then
      if assigned(OnProgress) then OnProgress((i + 1)/ (Dims + 1) * 100, Info);
  end;

  // now produce the solution using the pivots
  X.Clear;
  X[Dims - 1] := B[Dims - 1] / A[Dims - 1, Dims - 1];
  for i := Dims - 2 downto 0 do
    X[i] := (B[i] - A.RowMultiply(i, X)) / A[i, i];

  // final onprogress
  if assigned(OnProgress) then OnProgress(100, Info);
end;

procedure VecMultiply(A: TsdVector; C: double; var Result: TsdVector);
begin
  if not assigned(Result) then
    Result := TsdVector.Create;
  MatMultiply(A, C, TsdMatrix(Result));
end;

procedure VecSubstract(A, B: TsdVector; var Result: TsdVector);
begin
  if not assigned(Result) then
    Result := TsdVector.Create;
  MatSubstract(A, B, TsdMatrix(Result));
end;

function VecDotProduct(V1, V2: TsdMatrix): double;
var
  i: integer;
begin
  if not assigned(V1) or not assigned(V2) then
    raise Exception.Create(sMatrixMustBeAssigned);
  if V1.Count <> V2.Count then
    raise Exception.Create(sDimensionsMustAgree);
  Result := 0;
  for i := 0 to V1.Count - 1 do
    Result := Result + V1.FElem[i] * V2.FElem[i];
end;

end.

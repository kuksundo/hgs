unit sdFiniteElement;
{
  Description:

  This unit implements finite element calculation methods for prismatic bar
  systems and plane stress systems.

  Information about the methods can be found in:
  - BW60 "Stijfheid & Sterkte II" Part 1 (bar method)
  - BW60 "Stijfheid & Sterkte II" Part 3, chap 7 (plane Trim3 method)
  These are references from the Delft Univ of Techn.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 08Sep2005

  Modifications:

  copyright (c) 2005 SimDesign B.V.
}

interface

uses
  Classes, Contnrs, SysUtils, sdPoints2D, sdPoints3D, sdMatrices;

type
  TsdStringEvent = procedure (Sender: TObject; const Info: string) of object;

  TsdFemPlaneSystem2D = class;

  // 2D vertex for use in planar FEM systems
  TsdFemVertex2D = class(TPersistent)
  public
    P: TsdPoint2D;                  // Vertex location
    U: TsdPoint2D;                  // Vertex displacement
    F: TsdPoint2D;                  // External force applied in vertex
    Constr: array[0..1] of boolean; // Is this axis constrained?
    EqNo: array[0..1] of integer;   // Internal use: equation number, or -1 if none
  end;
  TsdFemVertexClass = class of TsdFemVertex2D;

  TsdFemVertex2DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdFemVertex2D;
  public
    property Items[Index: integer]: TsdFemVertex2D read GetItems; default;
  end;

  TsdFemMaterial = record
    E: double; // Modulus of Elasticity (steel: E = 200)
    v: double; // Poisson constant      (steel: v = 0.27-0.30)
  end;
  PsdFemMaterial = ^TsdFemMaterial;

  TsdStressInfo = record
    case Integer of
    0: (Sxx, Syy, Sxy: double); // stresses (sigma) in Pa, for xx, yy and xy
    1: (Elem: array[0..2] of double);
  end;
  PsdStressInfo = ^TsdStressInfo;
  TsdStressInfoArray = array[0..MaxInt div SizeOf(TsdStressInfo) - 1] of TsdStressInfo;
  PsdStressInfoArray = ^TsdStressInfoArray;
  TsdStressInfoDynArray = array of TsdStressInfo;

  // General FEM system element type
  TsdFemElement = class(TPersistent)
  private
    FOwner: TsdFemPlaneSystem2D;
    FVertexIdx: array of integer;
    FMaterial: TsdFemMaterial;
    function GetVertexIdx(Index: integer): integer;
    procedure SetVertexIdx(Index: integer; const Value: integer);
    function GetMaterial: PsdFemMaterial;
  protected
    procedure GetStresses(var AStressInfo: TsdStressInfo); virtual; abstract;
  public
    constructor Create(AOwner: TsdFemPlaneSystem2D); virtual;
    class function VertexCount: integer; virtual; abstract;
    procedure CalculateInternalStresses; virtual; abstract;
    procedure GetElementMatrix(h: double; var Kk: array of double;
      var Fk: array of double; var EqNo: array of integer); virtual; abstract;
    property VertexIdx[Index: integer]: integer read GetVertexIdx write SetVertexIdx;
    property Material: PsdFemMaterial read GetMaterial;
  end;
  TsdFemElementClass = class of TsdFemElement;

  TsdFemElementList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdFemElement;
  public
    property Items[Index: integer]: TsdFemElement read GetItems; default;
  end;

  TsdArray3x6d = array[0..2, 0..5] of double;
  TsdArray3x3d = array[0..2, 0..2] of double;

  // FEM system TRIM3 element type, a triangle with 3 vertices connected, officially
  // called 'Triangular membrane element with 3 nodes'
  TsdFemElemTRIM3 = class(TsdFemElement)
  private
    FPreStress: TsdStressInfo; // prestress
    procedure BuildDkAndS(var Dk: TsdArray3x6d; var S: TsdArray3x3d; var A: double);
    function GetPreStress: PsdStressInfo;
  protected  
    procedure GetStresses(var AStressInfo: TsdStressInfo); override;
  public
    procedure CalculateInternalStresses; override;
    procedure GetElementMatrix(h: double; var Kk: array of double;
      var Fk: array of double; var EqNo: array of integer); override;
    class function VertexCount: integer; override;
    property PreStress: PsdStressInfo read GetPreStress;
  end;

  // Finite Element Method system (FEM) for planar stress configurations.
  //
  // The system consists of N vertices Pi and M elements Ej. For each
  // vertex Pi, an equation is set up in directions X, Y, provided the vertex
  // is not constrained in that direction.
  TsdFemPlaneSystem2D = class(TPersistent)
  private
    FElements: TsdFemElementList;
    FVertices: TsdFemVertex2DList;
    FEquationCount: integer;
    FSysMat: TsdMatrix;
    //FThickness: double;
    FProgress: double;
    FOnProgress: TNotifyEvent;
    FOnLogInfo: TsdStringEvent;
    procedure SolveProgress(AProgress: double);
    procedure DoLog(const Info: string);
  protected
    procedure SetupEquationNumbers;
    procedure BuildSystemMatrix(K: TsdMatrix; U, F: TsdVector);
    class function ElementClass: TsdFemElementClass;
    class function VertexClass: TsdFemVertexClass;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // Create a new FEM element of the correct class and add it to the list
    function NewElement: TsdFemElement;
    // Create a new FEM vertex of correct class and add it to the list
    function NewVertex: TsdFemVertex2D;
    procedure Solve;
    property Elements: TsdFemElementList read FElements;
    property Vertices: TsdFemVertex2DList read FVertices;
    property EquationCount: integer read FEquationCount;
    property Progress: double read FProgress;
    property SystemMatrix: TsdMatrix read FSysMat;
    //property Thickness: double read FThickness write FThickness;
    property OnLogInfo: TsdStringEvent read FOnLogInfo write FOnLogInfo;
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
  end;

// Convert Sxx, Syy, Sxy cartesian stresses to S1 and S1 principal stresses (S1 > S2)
procedure CartesianToPrincipalStresses(const S: TsdStressInfo; var S1, S2: double);

resourcestring

  sIllegalVertexIndex = 'Illegal vertex index';

implementation

procedure CartesianToPrincipalStresses(const S: TsdStressInfo; var S1, S2: double);
// Convert Sxx, Syy, Sxy cartesian stresses to S1 and S1 principal stresses (S1 > S2)
var
  R: double;
begin
  // See formula "Gere & Timochenco" (6-13)
  R := sqrt(sqr((S.Sxx - S.Syy) * 0.5) + sqr(S.Sxy));
  S1 := (S.Sxx + S.Sxy) * 0.5 + R;
  S2 := (S.Sxx + S.Sxy) * 0.5 - R;
end;

procedure SolveProgressCallbackPlane2D(Progress: double; Info: pointer);
begin
  TsdFemPlaneSystem2D(Info).SolveProgress(Progress);
end;

{ TsdFemElement }

constructor TsdFemElement.Create(AOwner: TsdFemPlaneSystem2D);
var
  i: integer;
begin
  inherited Create;
  FOwner := AOwner;
  SetLength(FVertexIdx, VertexCount);
  for i := 0 to length(FVertexIdx) - 1 do
    FVertexIdx[i] := -1;
end;

function TsdFemElement.GetMaterial: PsdFemMaterial;
begin
  Result := @FMaterial;
end;

function TsdFemElement.GetVertexIdx(Index: integer): integer;
begin
  if (Index >= 0) and (Index < length(FVertexIdx)) then
    Result := FVertexIdx[Index]
  else
    Result := -1;
end;

procedure TsdFemElement.SetVertexIdx(Index: integer; const Value: integer);
begin
  if (Index >= 0) and (Index < length(FVertexIdx)) then
    FVertexIdx[Index] := Value;
end;

{ TsdFemElemTRIM3 }

procedure TsdFemElemTRIM3.BuildDkAndS(var Dk: TsdArray3x6d;
  var S: TsdArray3x3d; var A: double);
var
  i, j: integer;
  V: array[0..2] of TsdFemVertex2D;
  a1, a2, a3, b1, b2, b3: double;
  M: double;
begin
  // Vertex pointers
  for i := 0 to 2 do
    V[i] := FOwner.Vertices[FVertexIdx[i]];

  // Coordinate differences
  a1 := V[2].P.X - V[1].P.X;
  a2 := V[0].P.X - V[2].P.X;
  a3 := V[1].P.X - V[0].P.X;

  b1 := V[1].P.Y - V[2].P.Y;
  b2 := V[2].P.Y - V[0].P.Y;
  b3 := V[0].P.Y - V[1].P.Y;

  // Dk
  FillChar(Dk, SizeOf(Dk), 0);
  Dk[0, 0] := b1; Dk[0, 1] := b2; Dk[0, 2] := b3;
  Dk[1, 3] := a1; Dk[1, 4] := a2; Dk[1, 5] := a3;
  Dk[2, 0] := a1; Dk[2, 1] := a2; Dk[2, 2] := a3;
  Dk[2, 3] := b1; Dk[2, 4] := b2; Dk[2, 5] := b3;

  // Signed area
  A := 0.5 * (V[1].P.X * V[2].P.Y + V[2].P.X * V[0].P.Y + V[0].P.X * V[1].P.Y
             -V[2].P.X * V[1].P.Y - V[0].P.X * V[2].P.Y - V[1].P.X * V[0].P.Y);

  // Premultiply Dk
  M := 1 / (2 * A);
  for i := 0 to 2 do
    for j := 0 to 5 do
      Dk[i, j] := Dk[i, j] * M;

  // S'
  S[0, 0] := 1;           S[0, 1] := Material.v; S[0, 2] := 0;
  S[1, 0] := Material.v;  S[1, 1] := 1;          S[1, 2] := 0;
  S[2, 0] := 0;           S[2, 1] := 0;          S[2, 2] := (1 - Material.v) / 2;

  // Premultiply S'
  M := Material.E / (1 - sqr(Material.v));
  for i := 0 to 2 do
    for j := 0 to 2 do
      S[i, j] := S[i, j] * M;

end;

procedure TsdFemElemTRIM3.CalculateInternalStresses;
begin
  GetStresses(FPreStress);
end;

procedure TsdFemElemTRIM3.GetElementMatrix(h: double; var Kk: array of double; var Fk: array of double; var EqNo: array of integer);
var
  i, j, k: integer;
  V: array[0..2] of TsdFemVertex2D;
  A, M, R: double;
  Dk, T: TsdArray3x6d;
  Sk: TsdArray3x3d;
begin
  // Vertex pointers
  for i := 0 to 2 do
    V[i] := FOwner.Vertices[FVertexIdx[i]];

  // Fill equation numbers
  for i := 0 to 2 do begin
    EqNo[i    ] := V[i].EqNo[0]; // Equation for X
    EqNo[i + 3] := V[i].EqNo[1]; // Equation for Y
  end;

  // Build Dk and S' matrices, and calculate area
  BuildDkAndS(Dk, Sk, A);

  // Calculate Sk = h * A * S
  M := h * A;
  for i := 0 to 2 do
    for j := 0 to 2 do
      Sk[i, j] := M * Sk[i, j];

  // Create T = Sk * Dk
  for i := 0 to 2 do // rows of T
    for j := 0 to 5 do begin // cols of T
      R := 0;
      for k := 0 to 2 do // rows of Dk
        R := R + Sk[i, k] * Dk[k, j];
      T[i, j] := R;
    end;

  // Create Kk = DkT * T
  for i := 0 to 5 do // rows of Kk
    for j := 0 to 5 do begin // cols of Kk
      R := 0;
      for k := 0 to 2 do
        R := R + Dk[k, i] * T[k, j];
      if abs(R) > 1E-100 then
        Kk[i * 6 + j] := R
      else
        Kk[i * 6 + j] := 0;
    end;

  // Forces due to pre-stresses
  M := h * A;
  for i := 0 to 5 do begin// rows of Fk, rows of DkT
    R := 0;
    for j := 0 to 2 do // cols of DkT, rows of Sig
      R := R + Dk[j, i] * FPreStress.Elem[j];
    Fk[i] := R * M;
  end;
end;

function TsdFemElemTRIM3.GetPreStress: PsdStressInfo;
begin
  Result := @FPreStress;
end;

procedure TsdFemElemTRIM3.GetStresses(var AStressInfo: TsdStressInfo);
var
  i, j: integer;
  V: array[0..2] of TsdFemVertex2D;
  Dk: TsdArray3x6d;
  S: TsdArray3x3d;
  Eps: array[0..2] of double;
  A, R: double;
  U: array[0..5] of double;
begin
  // Vertex pointers
  for i := 0 to 2 do
    V[i] := FOwner.Vertices[FVertexIdx[i]];

  // Uk
  for i := 0 to 2 do begin
    U[i    ] := V[i].U.X;
    U[i + 3] := V[i].U.Y;
  end;

  // Matrices Dk and S
  BuildDkAndS(Dk, S, A);

  // Calculate stresses: Sig = S' Dk Uk
  // Eps = Dk Uk
  for i := 0 to 2 do begin// rows Eps
    R := 0;
    for j := 0 to 5 do // cols Dk, rows Uk
      R := R + Dk[i, j] * U[j];
    Eps[i] := R;
  end;

  // Sig = S' Eps
  for i := 0 to 2 do begin // rows Sig
    R := 0;
    for j := 0 to 2 do // rows S, cols eps
      R := R + S[i, j] * Eps[j];
    // Resulting stresses
    AStressInfo.Elem[i] := R;
  end;
end;

class function TsdFemElemTRIM3.VertexCount: integer;
begin
  Result := 3;
end;

{ TsdFemPlaneSystem2D }

procedure TsdFemPlaneSystem2D.BuildSystemMatrix(K: TsdMatrix; U, F: TsdVector);
var
  i, j, r, c, Idx, ACount: integer;
  AVertex: TsdFemVertex2D;
  Kk, Fk: array of double;
  EqNo: array of integer;
  AElement: TsdFemElement;
begin
  if not assigned(K) or not assigned(U) or not assigned(F) then exit;

  // Equation numbers
  SetupEquationNumbers;

  // Set matrix sizes
  K.SetSize(FEquationCount, FEquationCount); // A should be a TsdSparseMatrix!
  U.SetSize(FEquationCount, 1);
  F.SetSize(FEquationCount, 1);

  // Set external forces in F
  for i := 0 to FVertices.Count - 1 do begin
    AVertex := FVertices[i];
    for j := 0 to 1 do begin
      Idx := AVertex.EqNo[j];
      if Idx < 0 then continue;
      F[Idx] := AVertex.F.Elem[j];
    end;
  end;

  // Build system matrix: loop through all elements
  for i := 0 to FElements.Count - 1 do
  begin

    // Get element matrix of each element
    AElement := FElements[i];
    ACount := AElement.VertexCount * 2; // Each vertex has 2 cartesian directions
    SetLength(Kk, sqr(ACount));
    SetLength(EqNo, ACount);
    SetLength(Fk, ACount); // forces due to pre-stress
    AElement.GetElementMatrix(0.001{FThickness}, Kk, Fk, EqNo);

    // Fill into system matrix
    for r := 0 to ACount - 1 do begin
      if EqNo[r] < 0 then continue;
      for c := 0 to Acount - 1 do begin
        if EqNo[c] < 0 then continue;
        if EqNo[c] >= EqNo[r] then
          K[EqNo[r], EqNo[c]] := K[EqNo[r], EqNo[c]] + Kk[r * ACount + c];
      end;
      F[EqNo[r]] := F[EqNo[r]] + Fk[r];
    end;
  end;
end;

constructor TsdFemPlaneSystem2D.Create;
begin
  inherited Create;
  FElements := TsdFemElementList.Create;
  FVertices := TsdFemVertex2DList.Create;
end;

destructor TsdFemPlaneSystem2D.Destroy;
begin
  FreeAndNil(FElements);
  FreeAndNil(FVertices);
  inherited;
end;

procedure TsdFemPlaneSystem2D.DoLog(const Info: string);
begin
  if assigned(FOnLogInfo) then FOnLogInfo(Self, Info);
end;

class function TsdFemPlaneSystem2D.ElementClass: TsdFemElementClass;
begin
  Result := TsdFemElemTRIM3;
end;

function TsdFemPlaneSystem2D.NewElement: TsdFemElement;
begin
  Result := ElementClass.Create(Self);
  FElements.Add(Result);
end;

function TsdFemPlaneSystem2D.NewVertex: TsdFemVertex2D;
begin
  Result := VertexClass.Create;
  FVertices.Add(Result);
end;

procedure TsdFemPlaneSystem2D.SetupEquationNumbers;
// Count number of equations and set up equation numbers
var
  i, j, Idx: integer;
  AElement: TsdFemElement;
  AVertex: TsdFemVertex2D;
begin
  // Check which vertices are referenced
  for i := 0 to FVertices.Count - 1 do
    FVertices[i].EqNo[0] := -1;
  for i := 0 to FElements.Count - 1 do begin
    AElement := FElements[i];
    for j := 0 to AElement.VertexCount - 1 do begin
      Idx := AElement.VertexIdx[j];
      if Idx < 0 then
        raise Exception.Create(sIllegalVertexIndex);
      FVertices[Idx].EqNo[0] := 0;
    end;
  end;

  // Fill the equation numbers and count
  FEquationCount := 0;
  for i := 0 to FVertices.Count - 1 do begin
    AVertex := FVertices[i];
    if AVertex.EqNo[0] < 0 then begin
      AVertex.EqNo[1] := -1;
      continue;
    end;
    for j := 0 to 1 do
      if AVertex.Constr[j] then begin
        AVertex.EqNo[j] := -1;
      end else begin
        AVertex.EqNo[j] := FEquationCount;
        inc(FEquationCount);
      end;
  end;
end;

procedure TsdFemPlaneSystem2D.Solve;
var
  i, j, Idx: integer;
  U, F: TsdVector;
  AVertex: TsdFemVertex2D;
begin
  // Create a sparse system matrix
  FSysMat := TsdSparseMatrix.Create;
  F := TsdVector.Create;
  U := TsdVector.Create;
  try
    // Build the system matrix
    DoLog('Building system matrix...');
    BuildSystemMatrix(FSysMat, U, F);
    DoLog(Format('System Matrix: %d x %d, %d Elements, sparsity: %3.2f%% fill', [FSysMat.RowCount, FSysMat.ColCount,
      FSysMat.Count, FSysMat.Count / sqr(FSysMat.RowCount) * 100]));
    //DoLog(FSysMat.WriteToCsv('X', ' '));

    // solve
    DoLog('Solving using sparse matrix type...');
    MatBackSolveSymmetrical(FSysMat, U, F, SolveProgressCallbackPlane2D, Self);
    DoLog('Solving finished');

    // Set displacements
    for i := 0 to FVertices.Count - 1 do begin
      AVertex := FVertices[i];
      for j := 0 to 1 do begin
        Idx := AVertex.EqNo[j];
        if Idx < 0 then
          AVertex.U.Elem[j] := 0
        else
          AVertex.U.Elem[j] := U[Idx];
      end;
    end;

  finally
    FreeAndNil(FSysMat);
    F.Free;
    U.Free;
  end;
end;

procedure TsdFemPlaneSystem2D.SolveProgress(AProgress: double);
begin
  FProgress := AProgress;
  if assigned(FOnProgress) then FOnProgress(Self);
end;

class function TsdFemPlaneSystem2D.VertexClass: TsdFemVertexClass;
begin
  Result := TsdFemVertex2D;
end;

{ TsdFemVertex2DList }

function TsdFemVertex2DList.GetItems(Index: integer): TsdFemVertex2D;
begin
  Result := Get(Index);
end;

{ TsdFemElementList }

function TsdFemElementList.GetItems(Index: integer): TsdFemElement;
begin
  Result := Get(Index);
end;

end.

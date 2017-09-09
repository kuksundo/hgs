unit sdFiniteElementBars;

interface

uses
  Classes, Contnrs, SysUtils, sdPoints2D, sdPoints3D, sdMatrices;

type
  TsdStringEvent = procedure (Sender: TObject; const Info: string) of object;

  // 3D vertex for use in spatial FEM systems
  TsdFemVertex3D = record
    P: TsdPoint3D;                  // Original vertex location
    U: TsdPoint3D;                  // Current vertex location
    F: TsdPoint3D;                  // External force applied in vertex
    Constr: array[0..2] of boolean; // Is this axis constrained?
    EqNo: array[0..2] of integer;   // Internal use: equation number, or -1 if none
  end;
  PsdFemVertex3D = ^TsdFemVertex3D;

  TsdFemBar = record
    V0, V1: integer; // Vertex index to Vertex 0 and Vertex 1
    K: double;       // spring constant
    L0: double;      // Initial length
  end;
  PsdFemBar = ^TsdFemBar;

  // Finite Element Method system (FEM) using prismatic bars.
  //
  // The system consists of N vertices Pi and M connecting bars Lj. For each
  // vertex Pi, an equation is set up in directions X, Y, Z, provided the vertex
  // is not constrained in that direction. The forces acting upon Pi are:
  // - The external forces Fi in X, Y, Z
  // - The normal forces (tension = +, compression = -) in the connecting bars.
  // The bars have an initial length of L0, and a spring constant k. k can be
  // obtained from the equation k = EA/L0 where EA is the axial rigidity of the
  // bar.
  //
  // The user must provide positions of the vertices and the initial lengths L0.
  // Each vertex can have constraints (X, Y or Z direction unmovable), and external
  // forces. The user must also provide the bar spring constant k and connecting
  // vertex indices V0 and V1.
  //
  // Internally, the "stiffness" or "displacement" method is used, which creates
  // usually a band-matrix, which is stored as a sparse structure, and backsolved.
  TsdFemBarSystem3D = class(TPersistent)
  private
    FBars: array of TsdFemBar;
    FBarCount: integer;
    FVertices: array of TsdFemVertex3D;
    FVertexCount: integer;
    FEquationCount: integer;
    FSysMat: TsdMatrix;
    FProgress: double;
    FOnLogInfo: TsdStringEvent;
    FOnProgress: TNotifyEvent;
    function GetBars(Index: integer): PsdFemBar;
    function GetVertices(Index: integer): PsdFemVertex3D;
    procedure SetBarCount(const Value: integer);
    procedure SetVertexCount(const Value: integer);
    procedure SolveProgress(AProgress: double);
    procedure DoLog(const Info: string);
  protected
    procedure BuildSystemMatrix(A: TsdMatrix; X, B: TsdVector);
  public
    procedure Solve;
    property Vertices[Index: integer]: PsdFemVertex3D read GetVertices;
    property VertexCount: integer read FVertexCount write SetVertexCount;
    property Bars[Index: integer]: PsdFemBar read GetBars;
    property BarCount: integer read FBarCount write SetBarCount;
    property EquationCount: integer read FEquationCount;
    property Progress: double read FProgress;
    property SystemMatrix: TsdMatrix read FSysMat;
    property OnLogInfo: TsdStringEvent read FOnLogInfo write FOnLogInfo;
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
  end;

implementation

procedure SolveProgressCallbackBar3D(Progress: double; Info: pointer);
begin
  TsdFemBarSystem3D(Info).SolveProgress(Progress);
end;

{ TsdFemBarSystem3D }

procedure TsdFemBarSystem3D.BuildSystemMatrix(A: TsdMatrix; X, B: TsdVector);
var
  i, j, k: integer;
  Idx, Idx0, Idx1, V0, V1: integer;
  Normal: TsdPoint3D;
  Kc, F: double;
  AVertex: PsdFemVertex3D;
  DeltaLIdx: array[0..5] of integer;
  DeltaLVal: array[0..5] of double;
  DeltaLCount: integer;
begin
  if not assigned(A) or not assigned(X) or not assigned(B) then exit;

  // Count number of equations and set up equation numbers
  for i := 0 to FVertexCount - 1 do
    FVertices[i].EqNo[0] := -1;
  for i := 0 to FBarCount - 1 do begin
    FVertices[FBars[i].V0].EqNo[0] := 0;
    FVertices[FBars[i].V1].EqNo[0] := 0;
  end;
  FEquationCount := 0;
  for i := 0 to FVertexCount - 1 do begin
    AVertex := @FVertices[i];
    if AVertex.EqNo[0] < 0 then begin
      AVertex.EqNo[1] := - 1;
      AVertex.EqNo[2] := - 1;
      continue;
    end;
    for j := 0 to 2 do
      if AVertex.Constr[j] then begin
        AVertex.EqNo[j] := -1;
      end else begin
        AVertex.EqNo[j] := FEquationCount;
        inc(FEquationCount);
      end;
  end;

  // Set matrix sizes
  A.SetSize(FEquationCount, FEquationCount); // A should be a TsdSparseMatrix!
  X.SetSize(FEquationCount, 1);
  B.SetSize(FEquationCount, 1);

  // Set external forces in B
  for i := 0 to FVertexCount - 1 do begin
    AVertex := @FVertices[i];
    for j := 0 to 2 do begin
      Idx := AVertex.EqNo[j];
      if Idx < 0 then continue;
      B[Idx] := -AVertex.F.Elem[j];
    end;
  end;

  // Loop through edges and fill A and B
  for i := 0 to FBarCount - 1 do begin

    V0 := FBars[i].V0;
    V1 := FBars[i].V1;

    Normal := Delta3D(FVertices[V0].P, FVertices[V1].P);
    // Spring constant
    Kc := FBars[i].K;
    // Force due to length difference and normal vector of edge
    F := Kc * (Length3D(Normal) - FBars[i].L0);
    NormalizeVector3D(Normal);

    // Calculate DeltaL
    DeltaLCount := 0;
    for j := 0 to 2 do begin
      Idx0 := FVertices[V0].EqNo[j];
      Idx1 := FVertices[V1].EqNo[j];
      if Idx0 >= 0 then begin
        DeltaLIdx[DeltaLCount] := Idx0;
        DeltaLVal[DeltaLCount] := -Normal.Elem[j] * Kc;
        inc(DeltaLCount);
      end;
      if Idx1 >= 0 then begin
        DeltaLIdx[DeltaLCount] := Idx1;
        DeltaLVal[DeltaLCount] := Normal.Elem[j] * Kc;
        inc(DeltaLCount);
      end;
    end;

    // Loop through axes
    for j := 0 to 2 do begin
      Idx0 := FVertices[V0].EqNo[j];
      Idx1 := FVertices[V1].EqNo[j];

      // Add V0
      if Idx0 >= 0 then begin
        for k := 0 to DeltaLCount - 1 do
          A[Idx0, DeltaLIdx[k]] := A[Idx0, DeltaLIdx[k]] + Normal.Elem[j] * DeltaLVal[k];
        B[Idx0] := B[Idx0] - Normal.Elem[j] * F;
      end;

      // Add V1
      if Idx1 >= 0 then begin
        for k := 0 to DeltaLCount - 1 do
          A[Idx1, DeltaLIdx[k]] := A[Idx1, DeltaLIdx[k]] - Normal.Elem[j] * DeltaLVal[k];
        B[Idx1] := B[Idx1] + Normal.Elem[j] * F;
      end;

    end;
  end;
end;

procedure TsdFemBarSystem3D.DoLog(const Info: string);
begin
  if assigned(FOnLogInfo) then FOnLogInfo(Self, Info);
end;

function TsdFemBarSystem3D.GetBars(Index: integer): PsdFemBar;
begin
  Result := @FBars[Index];
end;

function TsdFemBarSystem3D.GetVertices(Index: integer): PsdFemVertex3D;
begin
  Result := @FVertices[Index];
end;

procedure TsdFemBarSystem3D.SetBarCount(const Value: integer);
begin
  FBarCount := Value;
  SetLength(FBars, FBarCount);
end;

procedure TsdFemBarSystem3D.SetVertexCount(const Value: integer);
begin
  FVertexCount := Value;
  SetLength(FVertices, FVertexCount);
end;

procedure TsdFemBarSystem3D.Solve;
var
  i, j, Idx: integer;
  X, B: TsdVector;
  AVertex: PsdFemVertex3D;
begin
  // Create a sparse system matrix
  FSysMat := TsdSparseMatrix.Create;
  B := TsdVector.Create;
  X := TsdVector.Create;
  try
    // Build the system matrix
    DoLog('Building system matrix...');
    BuildSystemMatrix(FSysMat, X, B);
    DoLog(Format('System Matrix: %d x %d, %d Elements, sparsity: %3.2f%% fill', [FSysMat.RowCount, FSysMat.ColCount,
      FSysMat.Count, FSysMat.Count / sqr(FSysMat.RowCount) * 100]));

    // solve
    DoLog('Solving using sparse matrix type...');
    MatBackSolve(FSysMat, X, B, SolveProgressCallbackBar3D, Self);
    DoLog('Solving finished');

    // Set displacements
    for i := 0 to FVertexCount - 1 do begin
      AVertex := @FVertices[i];
      for j := 0 to 2 do begin
        Idx := AVertex.EqNo[j];
        if Idx < 0 then continue;
        AVertex.U.Elem[j] := X[Idx];
      end;
    end;

  finally
    FreeAndNil(FSysMat);
    B.Free;
    X.Free;
  end;
end;

procedure TsdFemBarSystem3D.SolveProgress(AProgress: double);
begin
  FProgress := AProgress;
  if assigned(FOnProgress) then FOnProgress(Self);
end;

end.

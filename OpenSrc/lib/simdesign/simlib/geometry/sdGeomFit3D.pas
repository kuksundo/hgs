{ unit sdGeomFit3D

  TsdShapeFit3D fits 3D shapes (ie cone, cylinder, sphere) to a pointcloud
  of vertices.
    Optimisation strategy:
    Broyden–Fletcher–Goldfarb–Shanno (BFGS) method, approximates Newton's
    method of hillclimbing


  Author: Nils Haeck M.Sc.
  copyright (c) 2006 SimDesign BV (www.simdesign.nl)

}
unit sdGeomFit3D;

interface

uses
  Classes, SysUtils, sdPoints3D, sdMatrices, sdDebug, Math;

type

  TsdAbstractGeomFit3D = class(TComponent)
  private
    FCount: integer;
    FUseWeights: boolean;
  protected
    FWeights: array of double;
    FPoints: array of TsdPoint3D;
    procedure SetCount(const Value: integer);
  public
    // Add the 3D points (XYZ locations)
    procedure SetPoints(AFirst: PsdPoint3D; ACount: integer);
    // Add the Weights (double precision). If no weights are added, uniform
    // weights are used. A weight component of 0 disables this point (it does not
    // play a role in the fitting algorithm)
    procedure SetWeights(AFirst: PDouble; ACount: integer);
    // Clear previous data before adding new
    procedure Clear;
    // Runs the fitting algorithm, to produce the results
    function Solve: boolean; virtual; abstract;
    // Number of points to process, set this before setting the values
    property Count: integer read FCount write SetCount;
    // Determines if fitting code will use weights or not. Default is to *not*
    // use weights; some code might not implement this.
    property UseWeights: boolean read FUseWeights write FUseWeights;
  end;

  // Fits a plane through the points that abides the equation
  // A * X + B * Y + C * Z + D = 0
  TsdPlaneFit3D = class(TsdAbstractGeomFit3D)
  private
    FA, FB, FC, FD: double;
    FJac, FJinv: TsdMatrix;
    FZero, FAbcd: TsdVector;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Runs the fitting algorithm, to produce the results
    function Solve: boolean; override;
    property A: double read FA;
    property B: double read FB;
    property C: double read FC;
    property D: double read FD;
  end;

  // Descendant type for all geometrical parametrizable shapes
  TsdGeomShape = class(TPersistent)
  protected
    class function GetXCount: integer; virtual; abstract;
    procedure InitialPosition(Xparam: TsdVector); virtual; abstract;
    procedure PrecalcShapeParams(Xparam: TsdVector); virtual; abstract;
  public
    property XCount: integer read GetXCount;
    function DistanceToSurface(const P: TsdPoint3D): double; virtual; abstract;
  end;

  TsdSphereInfo = record
    Center: TsdPoint3D;
    Radius: double;
  end;

  // 3D Sphere, where params are defined as:
  // X[0] = X translation of center
  // X[1] = Y translation of center
  // X[2] = Z translation of center
  // X[3] = R radius of sphere
  TsdGeomSphere = class(TsdGeomShape)
  private
    FCenter: TsdPoint3D;
    FRadius: double;
  protected
    class function GetXCount: integer; override;
    procedure InitialPosition(Xparam: TsdVector); override;
    procedure PrecalcShapeParams(Xparam: TsdVector); override;
  public
    function DistanceToSurface(const P: TsdPoint3D): double; override;
    procedure SphereInfoFromShapeParams(Xparam: TsdVector; var SphereInfo: TsdSphereInfo);
  end;

  TsdCylinderInfo = record
    Center: TsdPoint3D;
    Axis: TsdPoint3D;
    Radius: double;
    Height: double;
  end;

  // 3D Cylinder shape, where params are defined as:
  // X[0] = X translation of cylinder center
  // X[1] = Y translation of cylinder center
  // X[2] = Z translation of cylinder center
  // X[3] = rotation around X-axis (second), in rad
  // X[4] = rotation around Y-axis (first), in rad
  // X[5] = cylinder radius
  TsdGeomCylinder = class(TsdGeomShape)
  private
    FTrans: TsdMatrix3x4; // Inverse transform of the cylinder
    FYrot: double;
    FXrot: double;
    FZMin, FZMax: double;
    FRadius: double;
  protected
    class function GetXCount: integer; override;
    procedure InitialPosition(Xparam: TsdVector); override;
    procedure PrecalcShapeParams(Xparam: TsdVector); override;
  public
    function DistanceToSurface(const P: TsdPoint3D): double; override;
    procedure CylinderInfoFromShapeParams(Xparam: TsdVector; var CylinderInfo: TsdCylinderInfo);
    property Xrot: double read FXrot write FXrot;
    property Yrot: double read FYrot write FYrot;
    property Radius: double read FRadius write FRadius;
  end;

  // Definition of a cone
  TsdConeInfo = record
    Tip: TsdPoint3D;
    Axis: TsdPoint3D;
    TopAngle: double;
    Height: double;
  end;

  // 3D Cone shape, where params are defined as:
  // X[0] = X translation of cone tip
  // X[1] = Y translation of cone tip
  // X[2] = Z translation of cone tip
  // X[3] = rotation around X-axis (second), in rad
  // X[4] = rotation around Y-axis (first), in rad
  // X[5] = cone top angle in rad
  TsdGeomCone = class(TsdGeomShape)
  private
    FTrans: TsdMatrix3x4; // Inverse transform of the cone
    FSr, FSz: double;     // Tangent vector along cone
    FZMin, FZMax: double;
    FYrot: double;
    FXrot: double;
    FTopAngle: double;
  protected
    class function GetXCount: integer; override;
    procedure InitialPosition(Xparam: TsdVector); override;
    procedure PrecalcShapeParams(Xparam: TsdVector); override;
  public
    function DistanceToSurface(const P: TsdPoint3D): double; override;
    procedure ConeInfoFromShapeParams(Xparam: TsdVector; var ConeInfo: TsdConeInfo);
    property Xrot: double read FXrot write FXrot;
    property Yrot: double read FYrot write FYrot;
    property TopAngle: double read FTopAngle write FTopAngle;
  end;

  // Geometrical fitting of shapes to 3D pointclouds
  TsdShapeFit3D = class(TDebugComponent)
  private
    FDelta: double;
//    FEpsilon: double;
    FMaxIter: integer;
    FError: double;
    FIter: integer;
  public
    constructor Create(AOwner: TComponent); override;
    // Fit the geometrical shape in Shape to the pointcloud in Points (Pointcount
    // points), put the resulting parametric representation in Xparam. Xparam should
    // be an initialized TsdVector object.
    procedure FitToPointcloud(Points: PsdPoint3DArray; PointCount: integer;
      AShape: TsdGeomShape; Xparam: TsdVector; AllowedError: double);
    property Delta: double read FDelta write FDelta;
//    property Epsilon: double read FEpsilon write FEpsilon;
    property MaxIter: integer read FMaxIter write FMaxIter;
    property Error: double read FError;
    property Iter: integer read FIter;
    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
  end;

const
  cDefaultDelta = 1E-6;
  cDefaultEpsilon = 1E-4;
  cDefaultMaxIter = 20;

implementation

const
  cEps = 1E-12;

{ TsdAbstractGeomFit3D }

procedure TsdAbstractGeomFit3D.Clear;
begin
  SetLength(FPoints, 0);
  SetLength(FWeights, 0);
end;

procedure TsdAbstractGeomFit3D.SetCount(const Value: integer);
begin
  FCount := Value;
  SetLength(FPoints, FCount);
  SetLength(FWeights, FCount);
end;

procedure TsdAbstractGeomFit3D.SetPoints(AFirst: PsdPoint3D; ACount: integer);
begin
  if ACount > FCount then
    ACount := FCount;
  if ACount > 0 then
    Move(AFirst^, FPoints[0], ACount * SizeOf(TsdPoint3D));
end;

procedure TsdAbstractGeomFit3D.SetWeights(AFirst: PDouble; ACount: integer);
begin
  if ACount > FCount then
    ACount := FCount;
  if ACount > 0 then
    Move(AFirst^, FWeights[0], ACount * SizeOf(double));
end;

{ TsdPlaneFit3D }

constructor TsdPlaneFit3D.Create(AOwner: TComponent);
begin
  inherited;
  FJac := TsdMatrix.Create;
  FJInv := TsdMatrix.Create;
  FZero := TsdVector.Create;
  FAbcd := TsdVector.Create;
end;

destructor TsdPlaneFit3D.Destroy;
begin
  FreeAndNil(FJac);
  FreeAndNil(FJInv);
  FreeAndNil(FZero);
  FreeAndNil(FAbcd);
  inherited;
end;

function TsdPlaneFit3D.Solve: boolean;
var
  i, Idx, Cnt: integer;
  L, Total: double;
begin
  // Checks
  Result := False;
  if FCount < 3 then
  begin
    FA := 0;
    FB := 0;
    FC := 0;
    FD := 0;
    exit;
  end;

  // calculate the line fit
  FJac.SetSize(FCount + 1, 4);
  FZero.SetCount(FCount + 1);
  FAbcd.SetCount(4);

  if FUseWeights then
  begin
    Total := 0;
    Cnt := 0;
    Idx := 0;
    for i := 0 to FCount - 1 do
      if FWeights[i] > 0 then
        inc(Cnt);
    if Cnt < 3 then
    begin
      FA := 0;
      FB := 0;
      FC := 0;
      FD := 0;
      exit;
    end;

    // add all point equations
    for i := 0 to FCount - 1 do
    begin
      if FWeights[i] > 0 then
      begin
        FJac[Idx, 0] := FWeights[i] * FPoints[i].X;
        FJac[Idx, 1] := FWeights[i] * FPoints[i].Y;
        FJac[Idx, 2] := FWeights[i] * FPoints[i].Z;
        FJac[Idx, 3] := FWeights[i];
        Total := Total + FWeights[i];
        inc(Idx);
      end;
    end;

  end else
  begin
    // add all point equations
    for i := 0 to FCount - 1 do
    begin
      FJac[i, 0] := FPoints[i].X;
      FJac[i, 1] := FPoints[i].Y;
      FJac[i, 2] := FPoints[i].Z;
      FJac[i, 3] := 1;
    end;
    Total := FCount;
    Cnt := FCount;
  end;

  // We add an additional equation which puts the major axis to length 1
  FJac[FCount, 0] := 0;
  FJac[FCount, 1] := 0;
  FJac[FCount, 2] := 1;
  FZero[Cnt] := Total;

  // Calculate inverse
  try
    MatInverseMP(FJac, FJinv);
  except
    FA := 0;
    FB := 0;
    FC := 0;
    FD := 0;
    exit;
  end;

  // Normal, non-unified
  MatMultiply(FJinv, FZero, FAbcd);
  FA := FAbcd[0];
  FB := FAbcd[1];
  FC := FAbcd[2];
  FD := FAbcd[3];

  // Make unified normal
  L := sqrt(sqr(FA) + sqr(FB) + sqr(FC));
  if L < cEps then
  begin
    FA := 0;
    FB := 0;
    FC := 0;
    FD := 0;
    exit;
  end;
  FA := FA / L;
  FB := FB / L;
  FC := FC / L;
  FD := FD / L;
  Result := True;
end;

{ TsdGeomSphere }

function TsdGeomSphere.DistanceToSurface(const P: TsdPoint3D): double;
begin
  Result := abs(Dist3d(P, FCenter) - FRadius);
end;

class function TsdGeomSphere.GetXCount: integer;
begin
  Result := 4;
end;

procedure TsdGeomSphere.InitialPosition(Xparam: TsdVector);
begin
  Xparam[3] := 1; // start with radius = 1
end;

procedure TsdGeomSphere.PrecalcShapeParams(Xparam: TsdVector);
begin
  FCenter := Point3D(Xparam[0], Xparam[1], Xparam[2]);
  FRadius := abs(Xparam[3]);
end;

procedure TsdGeomSphere.SphereInfoFromShapeParams(Xparam: TsdVector;
  var SphereInfo: TsdSphereInfo);
begin
  PrecalcShapeParams(Xparam);
  SphereInfo.Center := FCenter;
  SphereInfo.Radius := FRadius;
end;

{ TsdGeomCylinder }

procedure TsdGeomCylinder.CylinderInfoFromShapeParams(Xparam: TsdVector;
  var CylinderInfo: TsdCylinderInfo);
var
  InvT: TsdMatrix3x4;
  MustFlip: boolean;
begin
  CylinderInfo.Height := (FZMax - FZMin) * 1.05;
  MustFlip := (FZmax + FZmin) < 0;
  PrecalcShapeParams(Xparam);
  OrthoMatrix3x4Inverse(FTrans, InvT);
  CylinderInfo.Center := Point3D(InvT[0, 3], InvT[1, 3], InvT[2, 3]);
  CylinderInfo.Axis := Point3D(InvT[0, 2], InvT[1, 2], InvT[2, 2]);
  CylinderInfo.Radius := FRadius;
  if MustFlip then
    FlipVector3d(CylinderInfo.Axis);
end;

function TsdGeomCylinder.DistanceToSurface(const P: TsdPoint3D): double;
var
  Pt: TsdPoint3D;
  R: double;
begin
  TransformPoint(P, Pt, FTrans);
  FZmin := Min(Pt.Z, FZMin);
  FZmax := Max(Pt.Z, FZMax);
  R := sqrt(sqr(Pt.X) + sqr(Pt.Y));
  Result := abs(R - FRadius);
end;

class function TsdGeomCylinder.GetXCount: integer;
begin
  Result := 6;
end;

procedure TsdGeomCylinder.InitialPosition(Xparam: TsdVector);
begin
  Xparam[3] := FXrot;
  Xparam[4] := FYrot;
  Xparam[5] := FRadius;
end;

procedure TsdGeomCylinder.PrecalcShapeParams(Xparam: TsdVector);
begin
  // transform
  PoseToTransformMatrix(Xparam[0], Xparam[1], Xparam[2], Xparam[3], Xparam[4], 0,
    FTrans);
  // Xparam[5] contains radius
  FRadius := abs(Xparam[5]);
  FZMin := 0;
  FZMax := 0;
end;

{ TsdGeomCone }

procedure TsdGeomCone.ConeInfoFromShapeParams(Xparam: TsdVector; var ConeInfo: TsdConeInfo);
var
  InvT: TsdMatrix3x4;
  MustFlip: boolean;
begin
  ConeInfo.Height := (FZMax - FZMin) * 1.05;
  MustFlip := (FZmax + FZmin) < 0;
  PrecalcShapeParams(Xparam);
  OrthoMatrix3x4Inverse(FTrans, InvT);
  ConeInfo.Tip := Point3D(InvT[0, 3], InvT[1, 3], InvT[2, 3]);
  ConeInfo.Axis := Point3D(InvT[0, 2], InvT[1, 2], InvT[2, 2]);
  if FSz < 0 then
  begin
    FSz := -FSz;
    FlipVector3d(ConeInfo.Axis);
  end;
  if MustFlip then
    FlipVector3d(ConeInfo.Axis);
  ConeInfo.TopAngle := arccos(FSz);
end;

function TsdGeomCone.DistanceToSurface(const P: TsdPoint3D): double;
var
  Pt: TsdPoint3D;
  R: double;
begin
  TransformPoint(P, Pt, FTrans);
  FZmin := Min(Pt.Z, FZMin);
  FZmax := Max(Pt.Z, FZMax);
  R := sqrt(sqr(Pt.X) + sqr(Pt.Y)) * sign(Pt.Z);
  Result := abs(Pt.Z * FSr - R * FSz);
end;

class function TsdGeomCone.GetXCount: integer;
begin
  Result := 6;
end;

procedure TsdGeomCone.InitialPosition(Xparam: TsdVector);
begin
  Xparam[3] := FXrot;
  Xparam[4] := FYrot;
  Xparam[5] := FTopAngle;
end;

procedure TsdGeomCone.PrecalcShapeParams(Xparam: TsdVector);
begin
  // transform
  PoseToTransformMatrix(Xparam[0], Xparam[1], Xparam[2], Xparam[3], Xparam[4], 0,
    FTrans);
  // vector S, Xparam[5] contains top angle
  FSr := abs(sin(Xparam[5]));
  FSz := cos(Xparam[5]);
  FZMin := 0;
  FZMax := 0;
end;

{ TsdShapeFit3D }

constructor TsdShapeFit3D.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDelta := cDefaultDelta;
//  FEpsilon := cDefaultEpsilon;
  FMaxIter := cDefaultMaxIter;
end;

procedure TsdShapeFit3D.FitToPointcloud(Points: PsdPoint3DArray;
  PointCount: integer; AShape: TsdGeomShape; Xparam: TsdVector;
  AllowedError: double);
var
  i, j, SIter: integer;
  Err1, Err2, OldX, Dist, Mint: double;
  A, Ai: TsdMatrix;
  B, Xdelta, Xnew: TsdVector;
  Step, DStep: double;

  // local
  function SinglePointError(const P: TsdPoint3D): double;
  begin
    // use the distance to surface as error
    Result := AShape.DistanceToSurface(P);
    // use the squared distance to surface as error
    //Result := Sqr(AShape.DistanceToSurface(P));
  end;

  // local
  function FindError(Step: double): double;
  var
    i: integer;
  begin
    // New X position
    for i := 0 to Xnew.Count - 1 do
      Xnew[i] := Xparam[i] + Step * Xdelta[i];

    // New error
    AShape.PrecalcShapeParams(Xnew);
    Result := 0;
    for i := 0 to PointCount - 1 do
      Result := Result + SinglePointError(Points[i]);
  end;

  // local
  procedure DebugXparam;
  var
    i: integer;
  begin
    for i := 0 to Xparam.Count - 1 do
    begin
      DoDebugOut(Self, wsInfo, Format(' x[%d] = %f', [i, Xparam[i]]));
    end;
  end;

// main
begin
  // checks
  if not assigned(Xparam) or not assigned(AShape) or
    not assigned(Points) or (PointCount = 0) then
    exit;

  // Initial vector X
  Xparam.Count := AShape.GetXCount;

  // Vector B and matrix A
  A := TsdMatrix.Create;
  Ai := TsdMatrix.Create;
  B := TsdVector.Create;
  Xdelta := TsdVector.Create;
  Xnew := TsdVector.Create;
  try

    A.SetSize(PointCount, Xparam.Count);
    B.Count := PointCount;
    Xdelta.Count := Xparam.Count;
    Xnew.Count := Xparam.Count;

    for i := 0 to Xparam.Count - 1 do
      Xparam[i] := 0;

    // Get initial position
    AShape.InitialPosition(Xparam);

    DoDebugOut(Self, wsInfo, 'shape initial parameters:');
    DebugXparam;

    // Main loop
    FIter := 0;

    // Fill vector B with distances
    AShape.PrecalcShapeParams(Xparam);
    Err1 := 0;
    for i := 0 to PointCount - 1 do
    begin
      Dist := SinglePointError(Points[i]);
      Err1 := Err1 + Dist;
      B[i] := -Dist;
    end;
    Mint := 1 / (2 * FDelta);

    // main optimization loop
    repeat

      // Finite differences in matrix A
      for i := 0 to Xparam.Count - 1 do
      begin
        // A[j, i] := dDistj/dxi
        OldX := Xparam[i];
        Xparam[i] := OldX + FDelta;
        AShape.PrecalcShapeParams(Xparam);
        for j := 0 to PointCount - 1 do
          A[j, i] := SinglePointError(Points[j]);
        Xparam[i] := OldX - FDelta;
        AShape.PrecalcShapeParams(Xparam);
        for j := 0 to PointCount - 1 do
          A[j, i] := (A[j, i] - SinglePointError(Points[j])) * Mint;
        Xparam[i] := OldX;
      end;

      // Solve
      MatInverseMp(A, Ai);
      MatMultiply(Ai, B, Xdelta);

      // Find optimum stepsize (linesearch)
      Step := 1.0;
      SIter := 0;
      repeat
        Err2 := FindError(Step);
        if Err2 > Err1 then
          Step := Step * 0.5;
      until (Err2 < Err1) or (Step < 0.0001);
      
      Err1 := Err2;
      Dstep := Step;
      repeat
        Dstep := DStep * 0.5;
        Err2 := FindError(Step + Dstep);
        if Err2 < Err1 then
        begin
          Step := Step + Dstep;
          inc(SIter);
          Err1 := Err2;
        end else
        begin
          Err2 := FindError(Step - Dstep);
          if Err2 < Err1 then
          begin
            Step := Step - Dstep;
            inc(SIter);
            Err1 := Err2;
          end;
        end;
      until (SIter = 4) or (Dstep < 0.01);

      // New X position
      for i := 0 to Xnew.Count - 1 do
        Xparam[i] := Xparam[i] + Step * Xdelta[i];

      // New error and B
      AShape.PrecalcShapeParams(Xparam);

      Err1 := 0;
      for i := 0 to PointCount - 1 do
      begin
        Dist := SinglePointError(Points[i]);
        B[i] := -Dist;
        Err1 := Err1 + Dist;
      end;
      FError := Err1 / PointCount;

      inc(FIter);

      // debug info
      DoDebugOut(Self, wsInfo, Format('iter=%d step=%5.3f error=%f', [FIter, Step, FError]));

    until (FError < AllowedError) or (FIter >= FMaxIter);

    DoDebugOut(Self, wsInfo, 'shape final parameters:');
    DebugXparam;

  finally
    B.Free;
    A.Free;
    Ai.Free;
    Xdelta.Free;
    Xnew.Free;
  end;
end;

end.

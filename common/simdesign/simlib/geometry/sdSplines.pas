unit sdSplines;
{
  Description:
  Routines for working with polynomial and rational B-splines and B-spline
  surfaces. Rational B-splines are also called NURBS. The splines can be uniform
  or non-uniform depending on what knot vector is chosen.

  Theory for B-splines has been obtained from the book "Computer Graphics"
  second edition by Hearn and Baker (pp. 334 - 349)

  Example: this example generates a quarter of a circle using 10 segments:

  var
    i: integer;
    Spline: TsdNurbs3D;
    APoint: TsdPoint3D;
    du: double;
  begin
    Spline := TsdNurbs3D.Create;
    try
      Spline.N := 2;
      Spline.Degree := 2;
      Spline.Axis.MakeOpenUniform;
      Spline.ControlPoint[0] := Point3D(0, 1, 0);
      Spline.ControlPoint[1] := Point3D(1, 1, 0);
      Spline.ControlPoint[2] := Point3D(1, 0, 0);
      Spline.Weight[0] := 1;
      Spline.Weight[1] := sqrt(2)/2;
      Spline.Weight[2] := 1;
      Lines.Clear;
      du := (Spline.UMax - Spline.UMin) / 10;
      for i := 0 to 10 do begin
        APoint := Spline.SplinePoint(Spline.UMin + i * du);
        Lines.Add(Format('i=%2d, X=%5.3f, Y=%5.3f', [i, APoint.X, APoint.Y]));
      end;
    finally
      Spline.Free;
    end;
  end;

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 01Mar2006

  Modifications:

  copyright (c) 2006 SimDesign B.V.
}

interface

uses
  Classes, SysUtils, sdPoints3D, Math;

type

  TsdBSplineAxis = class(TPersistent)
  private
    FD: integer;
    FN: integer;
    FIsValid: boolean;
    function GetKnotVector(k: integer): double;
    procedure SetDegree(const Value: integer);
    procedure SetKnotVector(k: integer; const Value: double);
    procedure SetN(const Value: integer);
    function GetDegree: integer;
  protected
    FKnots: array of double;
    function RecursiveBlendValue(k, d: integer; const u: double): double;
    // Verify what is the knot index for u, and adapt u to fall within the
    // legal range (we do not allow interpolation)
    function VerifyKnotIndex(var u: double): integer;
    procedure Validate; virtual;
    property IsValid: boolean read FIsValid;
  public
    // Create an open, uniform spline with current settings
    procedure MakeOpenUniform;
    // Obtain the blend value for k and u
    function BlendValue(k, ui: integer; const u: double): double; virtual;
    // Set or get the k'th value of the knot vector. The knot vector contains
    // N + D + 1 values, ranging from 0 to N + D
    property KnotVector[k: integer]: double read GetKnotVector write SetKnotVector;
    // Set polynomial degree of spline, which is one lower than the D value:
    // Degree = D - 1. Continuity C is C = C^D-2
    property Degree: integer read GetDegree write SetDegree;
    // Set N to create a spline with N + 1 control points
    property N: integer read FN write SetN;
    // Spline with degree D - 1
    property D: integer read FD;
  end;

  // 3D spline curve
  TsdBSpline3D = class(TPersistent)
  private
    FAxis: TsdBSplineAxis;
    FPoints: array of TsdPoint3D;
    function GetControlPoint(k: integer): TsdPoint3D;
    procedure SetControlPoint(k: integer; const Value: TsdPoint3D);
    procedure SetDegree(const Value: integer);
    procedure SetN(const Value: integer);
    function GetDegree: integer;
    function GetN: integer;
    function GetUMax: double;
    function GetUMin: double;
  protected
    procedure SetSize(N: integer); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // Obtain the 3D spline point at parametric position u
    function SplinePoint(u: double): TsdPoint3D; virtual;
    // Spline axis that defines the knot vector
    property Axis: TsdBSplineAxis read FAxis;
    // Set or get the control point k. k ranges from 0 to N
    property ControlPoint[k: integer]: TsdPoint3D read GetControlPoint write SetControlPoint;
    // Set or get the polynomial degree of spline
    property Degree: integer read GetDegree write SetDegree;
    // Number of control points is N + 1
    property N: integer read GetN write SetN;
    // Minimum of parameter u, for given knot vector
    property UMin: double read GetUMin;
    // Maximum of parameter u, for given knot vector
    property UMax: double read GetUMax;
  end;

  TsdNurbsMode = (
    nmRational,
    nmPolynomial
  );

  // Non-uniform rational b-spline curve (NURBS)
  TsdNurbs3D = class(TsdBSpline3D)
  private
    FMode: TsdNurbsMode;
    FWeights: array of double;
    function GetWeight(k: integer): double;
    procedure SetWeight(k: integer; const Value: double);
  protected
    procedure SetSize(N: integer); override;
    function RationalSplinePoint(u: double): TsdPoint3D; virtual;
  public
    function SplinePoint(u: double): TsdPoint3D; override;
    // Weight[k] specifies the weight for control point k.
    property Weight[k: integer]: double read GetWeight write SetWeight;
    // Set mode to nmRational (default) for rational B-splines, and to
    // nmPolynomial for polynomial B-splines. The weights are only taken into
    // account for rational B-splines.
    property Mode: TsdNurbsMode read FMode write FMode;
  end;

  // 3D spline surface
  TsdBSplineSurface = class(TPersistent)
  private
    FAxis1: TsdBSplineAxis;
    FAxis2: TsdBSplineAxis;
    FPoints: array of array of TsdPoint3D;
    function GetControlPoint(k1, k2: integer): TsdPoint3D;
    procedure SetControlPoint(k1, k2: integer; const Value: TsdPoint3D);
    procedure SetDegree1(const Value: integer);
    function GetDegree1: integer;
    function GetN1: integer;
    function GetN2: integer;
    procedure SetN1(const Value: integer);
    procedure SetN2(const Value: integer);
    function GetDegree2: integer;
    procedure SetDegree2(const Value: integer);
    function GetUMax: double;
    function GetUMin: double;
    function GetVMax: double;
    function GetVMin: double;
  protected
    procedure SetSize(N1, N2: integer); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // Obtain the 3D spline point at parametric position (u, v)
    function SplinePoint(u, v: double): TsdPoint3D; virtual;
    function ControlPointsBoundingBox(var ABox: TsdBox3D): boolean;
    property Axis1: TsdBSplineAxis read FAxis1;
    property Axis2: TsdBSplineAxis read FAxis2;
    property ControlPoint[k1, k2: integer]: TsdPoint3D read GetControlPoint write SetControlPoint;
    property Degree1: integer read GetDegree1 write SetDegree1;
    property Degree2: integer read GetDegree2 write SetDegree2;
    property N1: integer read GetN1 write SetN1;
    property N2: integer read GetN2 write SetN2;
    // Minimum of parameter u, for given knot vector
    property UMin: double read GetUMin;
    // Maximum of parameter u, for given knot vector
    property UMax: double read GetUMax;
    // Minimum of parameter v, for given knot vector
    property VMin: double read GetVMin;
    // Maximum of parameter v, for given knot vector
    property VMax: double read GetVMax;
  end;

  // 3D non-uniform rational b-spline surface (NURBS surface)
  TsdNurbsSurface = class(TsdBSplineSurface)
  private
    FWeights: array of array of double;
    FMode: TsdNurbsMode;
    function GetWeight(k1, k2: integer): double;
    procedure SetWeight(k1, k2: integer; const Value: double);
  protected
    procedure SetSize(N1, N2: integer); override;
    function RationalSplinePoint(u, v: double): TsdPoint3D; virtual;
  public
    function SplinePoint(u, v: double): TsdPoint3D; override;
    property Weight[k1, k2: integer]: double read GetWeight write SetWeight;
    // Set mode to nmRational (default) for rational B-splines, and to
    // nmPolynomial for polynomial B-splines. The weights are only taken into
    // account for rational B-splines.
    property Mode: TsdNurbsMode read FMode write FMode;
  end;

resourcestring

  sInvalidKnotValue = 'Invalid knot value';
  sInvalidKnotIndex = 'Invalid knot index';
  sInvalidDegree    = 'Invalid degree (must be D >= 1)';
  sInvalidN         = 'Invalid N value (must be N >= 1)';

implementation

{ TsdBSplineAxis }

function TsdBSplineAxis.BlendValue(k, ui: integer; const u: double): double;
begin
  Validate;
  if (k < 0) or (k > FN) then
    raise Exception.Create(sInvalidKnotIndex);
  Result := Min(1, RecursiveBlendValue(k, FD, u));
end;

function TsdBSplineAxis.GetDegree: integer;
begin
  Result := FD - 1;
end;

function TsdBSplineAxis.GetKnotVector(k: integer): double;
begin
  if (k < 0) or (k >= length(FKnots)) then
    raise Exception.Create(sInvalidKnotIndex);
  Result := FKnots[k];
end;

procedure TsdBSplineAxis.MakeOpenUniform;
var
  i: integer;
begin
  for i := 0 to FN + FD do begin
    if i < FD then
      FKnots[i] := 0
    else if i <= FN then
      FKnots[i] := i - FD + 1
    else
      FKnots[i] := FN - FD + 2;
  end;
end;

function TsdBSplineAxis.RecursiveBlendValue(k, d: integer; const u: double): double;
var
  V, Delta: double;
const
  cEps = 1E-12;
begin
  if d = 1 then begin

    // Degree 0
    if (u >= FKnots[k] - cEps) and (u <= FKnots[k + 1] + cEps) then
      // Inside interval: result = 1
      Result := 1
    else
      // Outside interval: result = 0
      Result := 0;

  end else begin

    // Degree > 0
    Result := 0;
    Delta := FKnots[k + d - 1] - FKnots[k];
    if Delta > cEps then begin
      V := RecursiveBlendValue(k, d - 1, u);
      if V > 0 then
        Result := V * (u - FKnots[k]) / Delta;
    end;
    Delta := Fknots[k + d] - FKnots[k + 1];
    if Delta > cEps then begin
      V := RecursiveBlendValue(k + 1, d - 1, u);
      if V > 0 then
        Result := Result + V * (Fknots[k + d] - u) / Delta;
    end;

  end;
end;

procedure TsdBSplineAxis.SetDegree(const Value: integer);
begin
  if FD <> Value + 1 then begin
    if Value < 1 then
      raise Exception.Create(sInvalidDegree);
    FD := Value + 1;
    SetLength(FKnots, FN + FD + 1);
    FIsValid := False;
  end;
end;

procedure TsdBSplineAxis.SetKnotVector(k: integer; const Value: double);
begin
  if (k < 0) or (k >= length(FKnots)) then
    raise Exception.Create(sInvalidKnotIndex);
  FKnots[k] := Value;
  FIsValid := False;
end;

procedure TsdBSplineAxis.SetN(const Value: integer);
begin
  if FN <> Value then begin
    if Value < 1 then
      raise Exception.Create(sInvalidN);
    FN := Value;
    SetLength(FKnots, FN + FD + 1);
    FIsValid := False;
  end;
end;

procedure TsdBSplineAxis.Validate;
var
  i: integer;
begin
  if not FIsValid then begin
    if FN < 1 then
      raise Exception.Create(sInvalidN);
    if FD < 2 then
      raise Exception.Create(sInvalidDegree);
    // assert that knot vector is monotone increase
    for i := 0 to FN + FD - 1 do
      if FKnots[i + 1] < FKnots[i] then
        raise Exception.Create(sInvalidKnotValue);
    FIsValid := True;
  end;
end;

function TsdBSplineAxis.VerifyKnotIndex(var u: double): integer;
var
  Count: integer;
begin
  Result := 0;
  Count := length(FKnots);
  while (FKnots[Result + 1] <= u) and (Result < Count - 2) do
    inc(Result);
  if u < FKnots[Result] then
    u := FKnots[Result];
  if u > FKnots[Result + 1] then
    u := FKnots[Result + 1];
end;

{ TsdBSpline3D }

constructor TsdBSpline3D.Create;
begin
  inherited Create;
  FAxis := TsdBSplineAxis.Create;
end;

destructor TsdBSpline3D.Destroy;
begin
  FreeAndNil(FAxis);
  inherited;
end;

function TsdBSpline3D.GetControlPoint(k: integer): TsdPoint3D;
begin
  Result := FPoints[k];
end;

function TsdBSpline3D.GetDegree: integer;
begin
  Result := FAxis.GetDegree;
end;

function TsdBSpline3D.GetN: integer;
begin
  Result := FAxis.FN;
end;

function TsdBSpline3D.GetUMax: double;
begin
  with FAxis do
    Result := FKnots[FN + FD];
end;

function TsdBSpline3D.GetUMin: double;
begin
  with FAxis do
    Result := FKnots[0];
end;

procedure TsdBSpline3D.SetControlPoint(k: integer; const Value: TsdPoint3D);
begin
  FPoints[k] := Value;
end;

procedure TsdBSpline3D.SetDegree(const Value: integer);
begin
  FAxis.SetDegree(Value);
end;

procedure TsdBSpline3D.SetN(const Value: integer);
begin
  if FAxis.FN <> Value then begin
    FAxis.SetN(Value);
    SetSize(FAxis.FN);
  end;
end;

procedure TsdBSpline3D.SetSize(N: integer);
begin
  SetLength(FPoints, N + 1);
end;

function TsdBSpline3D.SplinePoint(u: double): TsdPoint3D;
var
  k, ui: integer;
  B, BTot: double;
begin
  Result := cZero3D;
  BTot := 0;
  ui := FAxis.VerifyKnotIndex(u);
  for k := 0 to FAxis.FN do begin
    B := FAxis.BlendValue(k, ui, u);
    BTot := BTot + B;
    if B > 0 then
      with FPoints[k] do begin
        Result.X := Result.X + B * X;
        Result.Y := Result.Y + B * Y;
        Result.Z := Result.Z + B * Z;
      end;
  end;
  Result.X := Result.X / BTot;
  Result.Y := Result.Y / BTot;
  Result.Z := Result.Z / BTot;
{  if abs(BTot - 1) > 0.001 then
    raise Exception.Create('blend value error');}
end;

{ TsdBSplineSurface }

function TsdBSplineSurface.ControlPointsBoundingBox(var ABox: TsdBox3D): boolean;
var
  i, j: integer;
  IsFirst: boolean;
begin
  IsFirst := True;
  for i := 0 to length(FPoints) - 1 do
    for j := 0 to length(FPoints[i]) - 1 do
      UpdateBox3D(FPoints[i, j], ABox, IsFirst);
  Result := not IsFirst;
end;

constructor TsdBSplineSurface.Create;
begin
  inherited Create;
  FAxis1 := TsdBSplineAxis.Create;
  FAxis2 := TsdBSplineAxis.Create;
end;

destructor TsdBSplineSurface.Destroy;
begin
  FreeAndNil(FAxis1);
  FreeAndNil(FAxis2);
  inherited;
end;

function TsdBSplineSurface.GetControlPoint(k1, k2: integer): TsdPoint3D;
begin
  Result := FPoints[k1, k2];
end;

function TsdBSplineSurface.GetDegree1: integer;
begin
  Result := FAxis1.GetDegree;
end;

function TsdBSplineSurface.GetDegree2: integer;
begin
  Result := FAxis2.GetDegree;
end;

function TsdBSplineSurface.GetN1: integer;
begin
  Result := FAxis1.FN;
end;

function TsdBSplineSurface.GetN2: integer;
begin
  Result := FAxis2.FN;
end;

function TsdBSplineSurface.GetUMax: double;
begin
  with FAxis1 do
    Result := FKnots[FN + FD];
end;

function TsdBSplineSurface.GetUMin: double;
begin
  with FAxis1 do
    Result := FKnots[0];
end;

function TsdBSplineSurface.GetVMax: double;
begin
  with FAxis2 do
    Result := FKnots[FN + FD];
end;

function TsdBSplineSurface.GetVMin: double;
begin
  with FAxis2 do
    Result := FKnots[0];
end;

procedure TsdBSplineSurface.SetControlPoint(k1, k2: integer;
  const Value: TsdPoint3D);
begin
  FPoints[k1, k2] := Value;
end;

procedure TsdBSplineSurface.SetDegree1(const Value: integer);
begin
  FAxis1.SetDegree(Value);
end;

procedure TsdBSplineSurface.SetDegree2(const Value: integer);
begin
  FAxis2.SetDegree(Value);
end;

procedure TsdBSplineSurface.SetN1(const Value: integer);
begin
  if FAxis1.FN <> Value then begin
    FAxis1.SetN(Value);
    SetSize(FAxis1.FN, FAxis2.FN);
  end;
end;

procedure TsdBSplineSurface.SetN2(const Value: integer);
begin
  if FAxis2.FN <> Value then begin
    FAxis2.SetN(Value);
    SetSize(FAxis1.FN, FAxis2.FN);
  end;
end;

procedure TsdBSplineSurface.SetSize(N1, N2: integer);
var
  i: integer;
begin
  SetLength(FPoints, N1 + 1);
  for i := 0 to N1 do
    SetLength(FPoints[i], N2 + 1);
end;

function TsdBSplineSurface.SplinePoint(u, v: double): TsdPoint3D;
var
  k1, k2, ui, vi: integer;
  B: double;
  B1, B2: array of double;
begin
  Result := cZero3D;
  SetLength(B1, FAxis1.FN + 1);
  SetLength(B2, FAxis2.FN + 1);
  ui := FAxis1.VerifyKnotIndex(u);
  vi := FAxis2.VerifyKnotIndex(v);

  // Precalculate axis 1 blend values
  for k1 := 0 to FAxis1.FN do
    B1[k1] := FAxis1.BlendValue(k1, ui, u);

  // Precalculate axis 2 blend values
  for k2 := 0 to FAxis2.FN do
    B2[k2] := FAxis2.BlendValue(k2, vi, v);

  // Do double integration
  for k1 := 0 to FAxis1.FN do
    if B1[k1] > 0 then
      for k2 := 0 to FAxis2.FN do begin
        if B2[k2] > 0 then
          with FPoints[k1, k2] do begin
            B := B1[k1] * B2[k2];
            Result.X := Result.X + B * X;
            Result.Y := Result.Y + B * Y;
            Result.Z := Result.Z + B * Z;
          end;
      end;
end;

{ TsdNurbs3D }

function TsdNurbs3D.GetWeight(k: integer): double;
begin
  Result := FWeights[k];
end;

function TsdNurbs3D.RationalSplinePoint(u: double): TsdPoint3D;
var
  k, ui: integer;
  BW: array of double;
  Den: double;
begin
  Result := cZero3D;
  Den := 0;
  SetLength(BW, FAxis.FN + 1);
  ui := FAxis.VerifyKnotIndex(u);

  // precalculate B's
  for k := 0 to FAxis.FN do
    BW[k] := FAxis.BlendValue(k, ui, u) * FWeights[k];

  for k := 0 to FAxis.FN do
    if BW[k] > 0 then begin
      with FPoints[k] do begin
        Result.X := Result.X + BW[k] * X;
        Result.Y := Result.Y + BW[k] * Y;
        Result.Z := Result.Z + BW[k] * Z;
      end;
      Den := Den + BW[k];
    end;
  // Final result
  ScalePoint3D(Result, 1/Den);
end;

procedure TsdNurbs3D.SetSize(N: integer);
begin
  inherited;
  SetLength(FWeights, N + 1);
end;

procedure TsdNurbs3D.SetWeight(k: integer; const Value: double);
begin
  FWeights[k] := Value;
end;

function TsdNurbs3D.SplinePoint(u: double): TsdPoint3D;
begin
  if FMode = nmPolynomial then
    Result := inherited SplinePoint(u)
  else
    Result := RationalSplinePoint(u);
end;

{ TsdNurbsSurface }

function TsdNurbsSurface.GetWeight(k1, k2: integer): double;
begin
  Result := FWeights[k1, k2];
end;

function TsdNurbsSurface.RationalSplinePoint(u, v: double): TsdPoint3D;
var
  k1, k2, ui, vi: integer;
  WB, Den: double;
  B1, B2: array of double;
begin
  Result := cZero3D;
  Den := 0;
  SetLength(B1, FAxis1.FN + 1);
  SetLength(B2, FAxis2.FN + 1);
  ui := FAxis1.VerifyKnotIndex(u);
  vi := FAxis2.VerifyKnotIndex(v);

  // Precalculate axis 1 blend values
  for k1 := 0 to FAxis1.FN do
    B1[k1] := FAxis1.BlendValue(k1, ui, u);

  // Precalculate axis 2 blend values
  for k2 := 0 to FAxis2.FN do
    B2[k2] := FAxis2.BlendValue(k2, vi, v);

  // Do double integration
  for k1 := 0 to FAxis1.FN do
    if B1[k1] > 0 then
      for k2 := 0 to FAxis2.FN do begin
        if B2[k2] > 0 then
          with FPoints[k1, k2] do begin
            WB := B1[k1] * B2[k2] * FWeights[k1, k2];
            Result.X := Result.X + WB * X;
            Result.Y := Result.Y + WB * Y;
            Result.Z := Result.Z + WB * Z;
            Den := Den + WB;
          end;
      end;
  // Divide by Den
  ScalePoint3D(Result, 1/Den);
end;

procedure TsdNurbsSurface.SetSize(N1, N2: integer);
var
  i: integer;
begin
  inherited;
  SetLength(FWeights, N1 + 1);
  for i := 0 to N1 do
    SetLength(FWeights[i], N2 + 1);
end;

procedure TsdNurbsSurface.SetWeight(k1, k2: integer; const Value: double);
begin
  FWeights[k1, k2] := Value;
end;

function TsdNurbsSurface.SplinePoint(u, v: double): TsdPoint3D;
begin
  if FMode = nmPolynomial then
    Result := inherited SplinePoint(u, v)
  else
    Result := RationalSplinePoint(u, v);
end;

end.

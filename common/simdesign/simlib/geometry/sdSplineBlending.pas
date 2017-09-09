// untested & to-do!
// this unit is intended to speed up spline rendering by pre-calcuating the blend
// functions.
unit sdSplineBlending;

interface

uses
  Classes, SysUtils, sdSplines;

type

  TsdBlendCoeff = class
  private
  public
    Coef: array of double;
    constructor Create(ADegree: integer);
    procedure Calculate(d, k: integer; Dk, Dkp1: TsdBlendCoeff; const Knots: array of double);
  end;

  TsdBlendFunc = class
  private
    FDOld: TsdBlendCoeff;
    FDNew: TsdBlendCoeff;
  public
    constructor Create(ADegree: integer);
    destructor Destroy; override;
    procedure Swap;
    function Evaluate(const u: double): double;
    property DOld: TsdBlendCoeff read FDOld;
    property DNew: TsdBlendCoeff read FDNew;
  end;

  TsdBSplinePrecalcAxis = class(TsdBSplineAxis)
  private
    FBlendFuncs: array of array of TsdBlendFunc;
  protected
    procedure Clear;
    procedure SetupBlendFuncs(ASize, ADegree: integer);
    procedure Validate; override;
  public
    destructor Destroy; override;
    function BlendValue(k, ui: integer; const u: double): double; override;
  end;

implementation

{ TsdBlendCoeff }

procedure TsdBlendCoeff.Calculate(d, k: integer; Dk, Dkp1: TsdBlendCoeff;
  const Knots: array of double);
// formula Prentice/Hall, pp. 335
var
  i: integer;
  p, q, Den1, Den2: double;
begin
  Den1 :=  Knots[k + d - 1] - Knots[k];
  if Den1 > 0 then begin
    p := 1 / Den1;
    q := -Knots[k] * p;
    Coef[0] := q * Dk.Coef[0];
    for i := 1 to d do
      Coef[i] := p * Dk.Coef[i - 1] + q * Dk.Coef[i];
  end else
    for i := 0 to d do
      Coef[i] := 0;
  Den2 := Knots[k + d] - Knots[k + 1];
  if Den2 > 0 then begin
    p := - 1 / Den2;
    q := - Knots[k + d] * p;
    Coef[0] := Coef[0] + q * Dkp1.Coef[0];
    for i := 1 to d do
      Coef[i] := Coef[i] + p * Dkp1.Coef[i - 1] + q * Dkp1.Coef[i];
  end;
end;

constructor TsdBlendCoeff.Create(ADegree: integer);
begin
  SetLength(Coef, ADegree);
end;

{ TsdBlendFunc }

constructor TsdBlendFunc.Create(ADegree: integer);
begin
  FDOld := TsdBlendCoeff.Create(ADegree);
  FDNew := TsdBlendCoeff.Create(ADegree);
end;

destructor TsdBlendFunc.Destroy;
begin
  FDOld.Free;
  FDNew.Free;
  inherited;
end;

function TsdBlendFunc.Evaluate(const u: double): double;
var
  i: integer;
  up: double;
begin
  Result := DNew.Coef[0];
  up := u;
  for i := 1 to length(DNew.Coef) - 1 do begin
    Result := Result + DNew.Coef[i] * up;
    up := up * u;
  end;
end;

procedure TsdBlendFunc.Swap;
var
  Temp: TsdBlendCoeff;
begin
  Temp := FDOld;
  FDOld := FDNew;
  FDNew := Temp;
end;

{ TsdBSplinePrecalcAxis }

function TsdBSplinePrecalcAxis.BlendValue(k, ui: integer; const u: double): double;
begin
  Validate;
  if (k < 0) or (k > N) then
    raise Exception.Create(sInvalidKnotIndex);
  Result := FBlendFuncs[k, ui - k].Evaluate(u);
end;

procedure TsdBSplinePrecalcAxis.Clear;
var
  i, j: integer;
begin
  for i := 0 to length(FBlendFuncs) do
    for j := 0 to length(FBlendFuncs[i]) do
      FreeAndNil(FBlendFuncs[i, j]);
end;

destructor TsdBSplinePrecalcAxis.Destroy;
begin
  Clear;
  inherited;
end;

procedure TsdBSplinePrecalcAxis.SetupBlendFuncs(ASize, ADegree: integer);
var
  i, j, d: integer;
begin
  Clear;
  // clear and re-initialize the field
  SetLength(FBlendFuncs, ASize);
  for i := 0 to ASize - 1 do begin
    SetLength(FBlendFuncs[i], ADegree);
    for j := 0 to ADegree - 1 do
      FBlendFuncs[i, j] := TsdBlendFunc.Create(ADegree);
  end;
  // Set 1st degree
  for i := 0 to ASize - 1 do
    FBlendFuncs[i, 0].DNew.Coef[0] := 1;
  // Set subsequent degrees
  for d := 1 to ADegree  - 1 do begin
    // Swap 'em
    for i := 0 to ASize - 1 do
      for j := 0 to d - 1 do
        FBlendFuncs[i, j].Swap;
    // Calculate new
    for i := 0 to ASize - 1 do
      for j := 0 to d do
        FBlendFuncs[i, j].DNew.Calculate(d, i, FBlendFuncs[i, j].DOld, FBlendFuncs[i + 1, j].DOld, FKnots);
  end;
end;

procedure TsdBSplinePrecalcAxis.Validate;
begin
  if not IsValid then begin
    // Do inherited checks
    inherited;
    SetupBlendFuncs(1, 1);//todo: figure out size
  end;
end;

end.

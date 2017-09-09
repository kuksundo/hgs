unit sdGeomFit2D;
{
  Code for geometrically fitting shapes to a set of 2D points.

  - Line fitting
  - Parabola fitting
  - Circle fitting
  - Ellipse fitting

  copyright (c) 2008 by SimDesign BV
}

interface

uses
  Classes, SysUtils, sdMatrices;

type

  TsdAbstractGeomFit2D = class(TComponent)
  private
    FCount: integer;
    FUseWeights: boolean;
  protected
    FWeights: array of double;
    FXValues: array of double;
    FYValues: array of double;
    procedure SetCount(const Value: integer);
  public
    // Add the X locations (double precision)
    procedure SetXValues(AFirst: PDouble; ACount: integer);
    // Add the Y locations (double precision)
    procedure SetYValues(AFirst: PDouble; ACount: integer);
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

  // fits a line through the XY pointlist, that abides the equantion
  // A * X + B * Y + C = 0 
  TsdLineFit2D = class(TsdAbstractGeomFit2D)
  private
    FA, FB, FC: double;
    FJac, FJinv: TsdMatrix;
    FZero, FAbc: TsdVector;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Runs the fitting algorithm, to produce the results
    function Solve: boolean; override;
    property A: double read FA;
    property B: double read FB;
    property C: double read FC;
  end;

  // fits a circle through the XY pointlist, and returns the XY location of
  // the center (XCenter, YCenter) and the Radius.
  TsdCircleFit2D = class(TsdAbstractGeomFit2D)
  private
    FXCenter: double;
    FYCenter: double;
    FRadius: double;
    FJac, FJinv: TsdMatrix;
    FRad, FXYR: TsdVector;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Runs the fitting algorithm, to produce the results
    function Solve: boolean; override;
    procedure CalculateError(var AMaxError, ARMS: double);
    property XCenter: double read FXCenter;
    property YCenter: double read FYCenter;
    property Radius: double read FRadius;
  end;

  TsdParabolaFit2D = class(TsdAbstractGeomFit2D)
  end;

  TsdEllipseFit2D = class(TsdAbstractGeomFit2D)
  end;


implementation

const
  cEps = 1E-12;

{ TsdAbstractGeomFit2D }

procedure TsdAbstractGeomFit2D.Clear;
begin
  SetLength(FXValues, 0);
  SetLength(FYValues, 0);
  SetLength(FWeights, 0);
end;

procedure TsdAbstractGeomFit2D.SetCount(const Value: integer);
begin
  FCount := Value;
  SetLength(FXValues, FCount);
  SetLength(FYValues, FCount);
  SetLength(FWeights, FCount);
end;

procedure TsdAbstractGeomFit2D.SetWeights(AFirst: PDouble; ACount: integer);
begin
  if ACount > FCount then
    ACount := FCount;
  if ACount > 0 then
    Move(AFirst^, FWeights[0], ACount * SizeOf(double));
end;

procedure TsdAbstractGeomFit2D.SetXValues(AFirst: PDouble; ACount: integer);
begin
  if ACount > FCount then
    ACount := FCount;
  if ACount > 0 then
    Move(AFirst^, FXValues[0], ACount * SizeOf(double));
end;

procedure TsdAbstractGeomFit2D.SetYValues(AFirst: PDouble; ACount: integer);
begin
  if ACount > FCount then
    ACount := FCount;
  if ACount > 0 then
    Move(AFirst^, FYValues[0], ACount * SizeOf(double));
end;

{ TsdLineFit2D }

constructor TsdLineFit2D.Create(AOwner: TComponent);
begin
  inherited;
  FJac := TsdMatrix.Create;
  FJInv := TsdMatrix.Create;
  FZero := TsdVector.Create;
  FAbc := TsdVector.Create;
end;

destructor TsdLineFit2D.Destroy;
begin
  FreeAndNil(FJac);
  FreeAndNil(FJInv);
  FreeAndNil(FZero);
  FreeAndNil(FAbc);
  inherited;
end;

function TsdLineFit2D.Solve: boolean;
var
  i, Idx, Cnt: integer;
  L, Total: double;
begin
  // Checks
  Result := False;
  if FCount < 2 then
  begin
    FA := 0;
    FB := 0;
    FC := 0;
    exit;
  end;

  // calculate the line fit
  FJac.SetSize(FCount + 1, 3);
  FZero.SetCount(FCount + 1);
  FAbc.SetCount(3);

  if FUseWeights then
  begin
    Total := 0;
    Cnt := 0;
    Idx := 0;
    for i := 0 to FCount - 1 do
      if FWeights[i] > 0 then
        inc(Cnt);
    if Cnt < 2 then
    begin
      FA := 0;
      FB := 0;
      FC := 0;
      exit;
    end;

    // add all point equations
    for i := 0 to FCount - 1 do
    begin
      if FWeights[i] > 0 then
      begin
        FJac[Idx, 0] := FWeights[i] * FXValues[i];
        FJac[Idx, 1] := FWeights[i] * FYValues[i];
        FJac[Idx, 2] := FWeights[i];
        Total := Total + FWeights[i];
        inc(Idx);
      end;
    end;

  end else
  begin
    // add all point equations
    for i := 0 to FCount - 1 do
    begin
      FJac[i, 0] := FXValues[i];
      FJac[i, 1] := FYValues[i];
      FJac[i, 2] := 1;
    end;
    Total := FCount;
    Cnt := FCount;
  end;

  // We add an additional equation which puts the major axis to length 1
  FJac[FCount, 0] := 0;
  FJac[FCount, 1] := 1;
  FJac[FCount, 2] := 0;
  FZero[Cnt] := Total;

  // Calculate inverse
  try
    MatInverseMP(FJac, FJinv);
  except
    FA := 0;
    FB := 0;
    FC := 0;
    exit;
  end;

  // Normal, non-unified
  MatMultiply(FJinv, FZero, FAbc);
  FA := FAbc[0];
  FB := FAbc[1];
  FC := FAbc[2];

  // Make unified normal
  L := sqrt(sqr(FA) + sqr(FB));
  if L < cEps then
  begin
    FA := 0;
    FB := 0;
    FC := 0;
    exit;
  end;
  FA := FA / L;
  FB := FB / L;
  FC := FC / L;
  Result := True;

end;

{ TsdCircleFit2D }

procedure TsdCircleFit2D.CalculateError(var AMaxError, ARMS: double);
var
  i: integer;
  Ri, Err: double;
begin
  //
  AMaxError := 0;
  ARMS := 0;
  for i := 0 to FCount - 1 do
  begin
    Ri := sqrt(sqr(FXValues[i] - FXCenter) + sqr(FYValues[i] - FYCenter));
    Err := abs(Ri - FRadius);
    if Err > AMaxError then
      AMaxError := Err;
    ARMS := ARMS + Sqr(Err);
  end;
  if FCount > 0 then
    ARMS := sqrt(ARMS / FCount);
end;

constructor TsdCircleFit2D.Create(AOwner: TComponent);
begin
  inherited;
  FJac := TsdMatrix.Create;
  FJInv := TsdMatrix.Create;
  FRad := TsdVector.Create;
  FXYR := TsdVector.Create;
end;

destructor TsdCircleFit2D.Destroy;
begin
  FreeAndNil(FJac);
  FreeAndNil(FJInv);
  FreeAndNil(FRad);
  FreeAndNil(FXYR);
  inherited;
end;

function TsdCircleFit2D.Solve: boolean;
{%
%   [xc yx R] = circfit(x,y)
%
%   fits a circle  in x,y plane in a more accurate
%   (less prone to ill condition )
%  procedure than circfit2 but using more memory
%  x,y are column vector where (x(i),y(i)) is a measured point
%
%  result is center point (yc,xc) and radius R
%  an optional output is the vector of coeficient a
% describing the circle's equation
%
%   x^2+y^2+a(1)*x+a(2)*y+a(3)=0
%
%  By:  Izhak bucher 25/oct /1991,}
var
  i: integer;
begin
  // Init
  FXCenter := 0;
  FYCenter := 0;
  FRadius := 0;
  Result := False;

  // No circle fit with less than 3 points
  if FCount < 3 then
    exit;

  // Build our matrices
  FJac.SetSize(FCount, 3);
  FRad.SetCount(FCount);
  FXYR.SetCount(3);

  // Todo: add weights

  // Fill Jac and Rad matrix
  for i := 0 to FCount - 1 do
  begin
    FJac[i, 0] := FXValues[i];
    FJac[i, 1] := FYValues[i];
    FJac[i, 2] := 1;
    FRad[i] := -(sqr(FXValues[i]) + sqr(FYValues[i]));
  end;

  // Solve
  try
    MatInverseMP(FJac, FJInv);
  except
    exit;
  end;
  Result := True;

  // Calculate solution
  MatMultiply(FJInv, FRad, FXYR);

  // Extract solution
  FXCenter := -0.5 * FXYR[0];
  FYCenter := -0.5 * FXYR[1];
  FRadius := sqrt((sqr(FXYR[0]) + sqr(FXYR[1])) * 0.25 - FXYR[2]);

{  // Calculate average error, using fast approx to avoid sqrt in the loop
  SqErr := 0;
  R2 := sqr(FRadius);
  DSlope := 1 / (2 * FRadius);
  for i := 0 to Count - 1 do
  begin
    P := AProfile[i];
    R2Dif := sqr(P.X - FXCenter) + sqr(P.Y - FYCenter) - R2;
    SqErr := SqErr + sqr(R2Dif * DSlope);
  end;
  FAvgError := sqrt(SqErr / Count);}

end;

end.

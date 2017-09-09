{
  Unit dtpTransform

  Project: DtpDocuments

  Creation Date: 25-10-2002 (NH)
  Version: See "changes.txt"

  Copyright (c) 2002-2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpTransform;

{$i simdesign.inc}

interface

uses
  Classes, dtpGraphics;

type

  // Matrix record
  //  | A C E |
  //  | B D F |
  //  | 0 0 1 | -> this row is omitted
  //
  TdtpMatrix = packed record
    case integer of
    0: (A, B, C, D, E, F: double);
    1: (Elements: array[0..5] of double);
  end;
  PdtpMatrix = ^TdtpMatrix;

  // Generic transform ancestor
  TdtpGenericTransform = class(TPersistent)
  public
    constructor Create; virtual;
    procedure Assign(ASource: TPersistent); override;
    class function IsLinear: boolean; virtual;
    procedure Invert; virtual; abstract;
    // Transform Point P
    function XFormP(const P: TdtpPoint): TdtpPoint; virtual; abstract;
    // Transform multiple points
    procedure XFormPoints(P: PdtpPoint; Count: integer);
  end;

  TdtpTransformClass = class of TdtpGenericTransform;

  // Affine transform
  TdtpTransform = class(TdtpGenericTransform)
  private
    FMatrix: TdtpMatrix;
  public
    constructor Create; override;
    procedure Assign(ASource: TPersistent); override;
    class function IsLinear: boolean; override;
    procedure Invert; override;
    procedure Translate(const Tx, Ty: double);
    // Rotate the coordinate system over angle Angle (degrees!) around point Cx, Cy
    procedure Rotate(const Angle, Cx, Cy: double);
    procedure Scale(const Sx, Sy: double);
    function XFormP(const P: TdtpPoint): TdtpPoint; override;
    function XFormX(X: double): double;
    function XFormY(Y: double): double;
    function VerticalScale(AValue: double): double;
    property Matrix: TdtpMatrix read FMatrix write FMatrix;
  end;

const
  cIdentityMatrix: TdtpMatrix =
    (A: 1; B: 0; C: 0; D: 1; E: 0; F: 0);

// Transform a float point with ATrans
function XFormPoint(ATrans: TdtpTransform; APoint: TdtpPoint): TdtpPoint;

implementation

function MatrixMulVector(const M: TdtpMatrix; const V: TdtpPoint): TdtpPoint;
begin
  Result.X := M.A * V.X + M.C * V.Y + M.E;
  Result.Y := M.B * V.X + M.D * V.Y + M.F;
end;

function MatrixMultiply(const M1, M2: TdtpMatrix): TdtpMatrix;
begin
  Result.A := M1.A * M2.A + M1.C * M2.B;
  Result.B := M1.B * M2.A + M1.D * M2.B;
  Result.C := M1.A * M2.C + M1.C * M2.D;
  Result.D := M1.B * M2.C + M1.D * M2.D;
  Result.E := M1.A * M2.E + M1.C * M2.F + M1.E;
  Result.F := M1.B * M2.E + M1.D * M2.F + M1.F;
end;

function Determinant(const M: TdtpMatrix): double;
begin
  Result := 1 / (M.A * M.D - M.B * M.C);
end;

procedure InvertMatrix(var M: TdtpMatrix);
var
  D, Ta, Te: double;
begin
  D := Determinant(M);
  Ta  :=  M.D * D;
  M.D :=  M.A * D;
  M.B := -M.B * D;
  M.C := -M.C * D;
  Te  := -M.E * Ta  - M.F * M.C;
  M.F := -M.E * M.B - M.F * M.D;
  M.A := Ta;
  M.E := Te;
end;

procedure SetMatrix(var M: TdtpMatrix; const A, B, C, D, E, F: double);
begin
  M.A := A;
  M.B := B;
  M.C := C;
  M.D := D;
  M.E := E;
  M.F := F;
end;

function XFormPoint(ATrans: TdtpTransform; APoint: TdtpPoint): TdtpPoint;
begin
  Result := dtpPoint(0, 0);
  if not assigned(ATrans) then
    exit;

  ATrans.XFormP(APoint);
end;

{ TdtpGenericTransform }

procedure TdtpGenericTransform.Assign(ASource: TPersistent);
begin
  if not (ASource is TdtpGenericTransform) then
    inherited;
end;

constructor TdtpGenericTransform.Create;
begin
  inherited;
end;

class function TdtpGenericTransform.IsLinear: boolean;
begin
  Result := False;
end;

procedure TdtpGenericTransform.XFormPoints(P: PdtpPoint; Count: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    P^ := XFormP(P^);
    inc(P);
  end;
end;

{ TdtpTransform }

procedure TdtpTransform.Assign(ASource: TPersistent);
begin
  inherited;
  if ASource is TdtpTransform then
    FMatrix := TdtpTransform(ASource).FMatrix;
end;

constructor TdtpTransform.Create;
begin
  inherited;
  FMatrix := cIdentityMatrix;
end;

procedure TdtpTransform.Invert;
begin
  InvertMatrix(FMatrix);
end;

class function TdtpTransform.IsLinear: boolean;
begin
  Result := True;
end;

procedure TdtpTransform.Rotate(const Angle, Cx, Cy: double);
var
  A: double;
  M: TdtpMatrix;
begin
  if not ((Cx = 0) and (Cy = 0)) then
    Translate(-Cx, -Cy);
  A := Angle * (pi / 180);
  SetMatrix(M, cos(A), sin(A), -sin(A), cos(A), 0, 0);
  FMatrix := MatrixMultiply(M, FMatrix);
  if not ((Cx = 0) and (Cy = 0)) then
    Translate(Cx, Cy);
end;

procedure TdtpTransform.Scale(const Sx, Sy: double);
var
  M: TdtpMatrix;
begin
  M := cIdentityMatrix;
  M.A := Sx;
  M.D := Sy;
  FMatrix := MatrixMultiply(M, FMatrix);
end;

function TdtpTransform.XFormP(const P: TdtpPoint): TdtpPoint;
begin
  Result := MatrixMulVector(FMatrix, P);
end;

function TdtpTransform.XFormX(X: double): double;
var
  P: TdtpPoint;
begin
  P := XFormP(dtpPoint(X, 0));
  Result := P.X;
end;

function TdtpTransform.XFormY(Y: double): double;
var
  P: TdtpPoint;
begin
  P := XFormP(dtpPoint(0, Y));
  Result := P.Y;
end;

procedure TdtpTransform.Translate(const Tx, Ty: double);
var
  M: TdtpMatrix;
begin
  M := cIdentityMatrix;
  M.E := Tx;
  M.F := Ty;
  FMatrix := MatrixMultiply(M, FMatrix);
end;

function TdtpTransform.VerticalScale(AValue: double): double;
begin
  Result := FMatrix.C * AValue + FMatrix.D * AValue
end;

end.

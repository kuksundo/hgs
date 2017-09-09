{ sdIGESEntities

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdIGESEntities;

interface

uses
  sdIGESFormat, SysUtils, Graphics;

type

  // Circular arc entity (100)
  TIgsEntity100 = class(TIgsEntity)
  public
    function ParameterDescription(Index: integer): string; override;
  end;

  // Composite curve entity (102)
  TIgsEntity102 = class(TIgsContainingEntity)
  protected
    procedure BuildStructure; override;
  public
    function ParameterDescription(Index: integer): string; override;
  end;

  // Conic arc entity (104)
  TIgsEntity104 = class(TIgsEntity)
  public
    function ParameterDescription(Index: integer): string; override;
  end;

  // Line entity (110)
  TIgsLineEntity = class(TIgsEntity)
  public
    function ParameterDescription(Index: integer): string; override;
  end;

  // Linear path entity (110, form 11-13)
  TIgsLinearPathEntity = class(TIgsEntity)
  public
    function ParameterDescription(Index: integer): string; override;
  end;

  // Linear path entity (110, form 63)
  TIgsSimpleClosedPlanarCurveEntity = class(TIgsEntity)
  public
    function ParameterDescription(Index: integer): string; override;
  end;

  // Rational B-Spline Curve (126)
  TIgsEntity126 = class(TIgsEntity)
  public
    function ParameterDescription(Index: integer): string; override;
  end;

  // Rational B-Spline Surface (128)
  TIgsEntity128 = class(TIgsEntity)
  public
    function ParameterDescription(Index: integer): string; override;
    function K1: integer;
    function K2: integer;
    function M1: integer;
    function M2: integer;
    function IsPolynomial: boolean;
  end;

  TIgsEntity141Curve = record
    CRVPT: integer;
    SENSE: integer;
    K: integer;
    PSCPT: array of integer;
  end;

  // Boundary (141)
  TIgsEntity141 = class(TIgsContainingEntity)
  private
    FCurves: array of TIgsEntity141Curve;
  protected
    procedure BuildStructure; override;
  public
    function ParameterDescription(Index: integer): string; override;
    function CurveCount: integer;
    function ModelCurves(Index: integer): TIgsEntity;
    function ParamCurveCount(Index: integer): integer;
    function ParamCurves(IdxC, IdxP: integer): TIgsEntity;
    //function Surface: TIgsEntity; // parametric surface
    //function BCurve: TIgsEntity; // parametric curve
    //function CCurve: TIgsentity; // world curve
  end;

  // Curve on parametric surface (142)
  TIgsEntity142 = class(TIgsContainingEntity)
  protected
    procedure BuildStructure; override;
  public
    function ParameterDescription(Index: integer): string; override;
    function Surface: TIgsEntity; // parametric surface
    function BCurve: TIgsEntity; // parametric curve
    function CCurve: TIgsentity; // world curve
  end;

  // Bounded Surface (143)
  TIgsEntity143 = class(TIgsContainingEntity)
  protected
    procedure BuildStructure; override;
  public
    function ParameterDescription(Index: integer): string; override;
    function Surface: TIgsEntity;
    function BoundaryCount: integer;
    function Boundaries(Index: integer): TIgsEntity;
  end;

  // Trimmed (parametric) surface (144)
  TIgsEntity144 = class(TIgsContainingEntity)
  protected
    procedure BuildStructure; override;
  public
    function ParameterDescription(Index: integer): string; override;
    function Surface: TIgsEntity;
    function OuterBoundary: TIgsEntity;
    function InnerBoundaryCount: integer;
    function InnerBoundaries(Index: integer): TIgsEntity;
  end;

  // Color Definition (314)
  TIgsEntity314 = class(TIgsEntity)
  public
    function ParameterDescription(Index: integer): string; override;
    function ToColor: TColor;
  end;

implementation

{ TIgsEntity100 }

function TIgsEntity100.ParameterDescription(Index: integer): string;
begin
  case Index of
  0: Result := 'ZT';
  1: Result := 'X1';
  2: Result := 'Y1';
  3: Result := 'X2';
  4: Result := 'Y2';
  5: Result := 'X3';
  6: Result := 'Y3';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

{ TIgsEntity102 }

procedure TIgsEntity102.BuildStructure;
var
  i: integer;
begin
  for i := 1 to Parameters[0].AsInt do
    AddStructureEntity(Parameters[i].AsInt);
end;

function TIgsEntity102.ParameterDescription(Index: integer): string;
begin
  if Index = 0 then
    Result := 'N'
  else
    if Index <= Parameters[0].AsInt then
      Result := Format('DE(%d)', [Index])
    else
      Result := inherited ParameterDescription(Index);
end;

{ TIgsEntity104 }

function TIgsEntity104.ParameterDescription(Index: integer): string;
begin
  case Index of
  0:  Result := 'A';
  1:  Result := 'B';
  2:  Result := 'C';
  3:  Result := 'D';
  4:  Result := 'E';
  5:  Result := 'F';
  6:  Result := 'ZT';
  7:  Result := 'X1';
  8:  Result := 'Y1';
  9:  Result := 'X2';
  10: Result := 'Y2';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

{ TIgsLineEntity }

function TIgsLineEntity.ParameterDescription(Index: integer): string;
begin
  case Index of
  0: Result := 'X1';
  1: Result := 'Y1';
  2: Result := 'Z1';
  3: Result := 'X2';
  4: Result := 'Y2';
  5: Result := 'Z2';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

{ TIgsLinearPathEntity }

function TIgsLinearPathEntity.ParameterDescription(Index: integer): string;
begin
  case Index of
  0: Result := 'IP';
  1: Result := 'N';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

{ TIgsSimpleClosedPlanarCurveEntity }

function TIgsSimpleClosedPlanarCurveEntity.ParameterDescription(
  Index: integer): string;
begin
  case Index of
  0: Result := 'IP';
  1: Result := 'N';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

{ TIgsEntity126 }

function TIgsEntity126.ParameterDescription(
  Index: integer): string;
begin
  case Index of
  0:  Result := 'K';
  1:  Result := 'M';
  2:  Result := 'PROP1';
  3:  Result := 'PROP2';
  4:  Result := 'PROP3';
  5:  Result := 'PROP4';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

{ TIgsEntity128 }

function TIgsEntity128.IsPolynomial: boolean;
begin
  Result := Parameters[6].AsInt = 1;
end;

function TIgsEntity128.K1: integer;
begin
  Result := Parameters[0].AsInt;
end;

function TIgsEntity128.K2: integer;
begin
  Result := Parameters[1].AsInt;
end;

function TIgsEntity128.M1: integer;
begin
  Result := Parameters[2].AsInt;
end;

function TIgsEntity128.M2: integer;
begin
  Result := Parameters[3].AsInt;
end;

function TIgsEntity128.ParameterDescription(Index: integer): string;
begin
  case Index of
  0:  Result := 'K1';
  1:  Result := 'M1';
  2:  Result := 'K2';
  3:  Result := 'M2';
  4:  Result := 'PROP1';
  5:  Result := 'PROP2';
  6:  Result := 'PROP3';
  7:  Result := 'PROP4';
  8:  Result := 'PROP5';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

{ TIgsEntity141 }

procedure TIgsEntity141.BuildStructure;
var
  i, j, Idx, Count: integer;
begin
  AddStructureEntity(Parameters[2].AsInt); // SPTR
  Count := CurveCount;
  Idx := 4;
  SetLength(FCurves, Count);
  for i := 0 to Count - 1 do
  begin
    FCurves[i].CRVPT := Parameters[Idx].AsInt; inc(Idx);
    AddStructureEntity(FCurves[i].CRVPT);
    FCurves[i].SENSE := Parameters[Idx].AsInt; inc(Idx);
    FCurves[i].K := Parameters[Idx].AsInt; inc(Idx);
    SetLength(FCurves[i].PSCPT, FCurves[i].K);
    for j := 0 to FCurves[i].K - 1 do
    begin
      FCurves[i].PSCPT[j] := Parameters[Idx].AsInt; inc(Idx);
      AddStructureEntity(FCurves[i].PSCPT[j]);
    end;
  end;
end;

function TIgsEntity141.CurveCount: integer;
begin
  Result := Parameters[3].AsInt;
end;

function TIgsEntity141.ModelCurves(Index: integer): TIgsEntity;
begin
  Result := Owner.EntityBySequenceNumber(FCurves[Index].CRVPT);
end;

function TIgsEntity141.ParamCurveCount(Index: integer): integer;
begin
  Result := FCurves[Index].K;
end;

function TIgsEntity141.ParamCurves(IdxC, IdxP: integer): TIgsEntity;
begin
  Result := Owner.EntityBySequenceNumber(FCurves[IdxC].PSCPT[IdxP]);
end;

function TIgsEntity141.ParameterDescription(Index: integer): string;
begin
  case Index of
  0:  Result := 'TYPE';
  1:  Result := 'PREF';
  2:  Result := 'SPTR';
  3:  Result := 'N';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

{ TIgsEntity142 }

function TIgsEntity142.BCurve: TIgsEntity;
begin
  Result := Owner.EntityBySequenceNumber(Parameters[2].AsInt);
end;

procedure TIgsEntity142.BuildStructure;
begin
  AddStructureEntity(Parameters[1].AsInt);
  AddStructureEntity(Parameters[2].AsInt);
  AddStructureEntity(Parameters[3].AsInt);
end;

function TIgsEntity142.CCurve: TIgsentity;
begin
  Result := Owner.EntityBySequenceNumber(Parameters[3].AsInt);
end;

function TIgsEntity142.ParameterDescription(Index: integer): string;
begin
  case Index of
  0:  Result := 'CRTN';
  1:  Result := 'SPTR';
  2:  Result := 'BPTR';
  3:  Result := 'CPTR';
  4:  Result := 'PREF';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

function TIgsEntity142.Surface: TIgsEntity;
begin
  Result := Owner.EntityBySequenceNumber(Parameters[1].AsInt);
end;

{ TIgsEntity143 }

function TIgsEntity143.Boundaries(Index: integer): TIgsEntity;
begin
  Result := Owner.EntityBySequenceNumber(Parameters[3 + Index].AsInt);
end;

function TIgsEntity143.BoundaryCount: integer;
begin
  Result := Parameters[2].AsInt;
end;

procedure TIgsEntity143.BuildStructure;
var
  i, N: integer;
begin
  AddStructureEntity(Parameters[1].AsInt); // SPTR
  N := BoundaryCount;
  for i := 0 to N - 1 do
    AddStructureEntity(Parameters[3 + i].AsInt);
end;

function TIgsEntity143.ParameterDescription(Index: integer): string;
begin
  case Index of
  0:  Result := 'TYPE';
  1:  Result := 'SPTR';
  2:  Result := 'N';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

function TIgsEntity143.Surface: TIgsEntity;
begin
  Result := Owner.EntityBySequenceNumber(Parameters[1].AsInt);
end;

{ TIgsEntity144 }

procedure TIgsEntity144.BuildStructure;
var
  i, N2: integer;
begin
  AddStructureEntity(Parameters[0].AsInt);
  AddStructureEntity(Parameters[3].AsInt);
  N2 := Parameters[2].AsInt;
  for i := 0 to N2 - 1 do
    AddStructureEntity(Parameters[4 + i].AsInt);
end;

function TIgsEntity144.InnerBoundaries(Index: integer): TIgsEntity;
begin
  if (Index >= 0) and (Index < InnerBoundaryCount) then
    Result := Owner.EntityBySequenceNumber(Parameters[4 + Index].AsInt)
  else
    Result := nil;
end;

function TIgsEntity144.InnerBoundaryCount: integer;
begin
  Result := Parameters[2].AsInt;
end;

function TIgsEntity144.OuterBoundary: TIgsEntity;
begin
  Result := Owner.EntityBySequenceNumber(Parameters[3].AsInt);
end;

function TIgsEntity144.ParameterDescription(Index: integer): string;
begin
  case Index of
  0:  Result := 'PTS';
  1:  Result := 'N1';
  2:  Result := 'N2';
  3:  Result := 'PT0';
  else
    Result := inherited ParameterDescription(Index);
  end;
end;

function TIgsEntity144.Surface: TIgsEntity;
begin
  Result := Owner.EntityBySequenceNumber(Parameters[0].AsInt);
end;

{ TIgsEntity314 }

function TIgsEntity314.ParameterDescription(Index: integer): string;
begin
  case Index of
  0:  Result := 'CC1';
  1:  Result := 'CC2';
  2:  Result := 'CC3';
  3:  Result := 'CNAME';
  else
    Result := inherited ParameterDescription(Index);
  end;

end;

function TIgsEntity314.ToColor: TColor;
var
  R, G, B: byte;
begin
  R := round(Parameters[0].AsFloat * 255 / 100);
  G := round(Parameters[1].AsFloat * 255 / 100);
  B := round(Parameters[2].AsFloat * 255 / 100);
  Result := R shl 16 + G shl 8 + B;
end;

end.

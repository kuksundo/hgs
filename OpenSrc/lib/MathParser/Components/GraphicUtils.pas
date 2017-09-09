{ *********************************************************************** }
{                                                                         }
{ GraphicUtils                                                            }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit GraphicUtils;

{$B-}

interface

uses
  Windows, SysUtils, Graphics, Math, GraphicTypes;

type
  TBlurType = (btPoor, btBelowNormal, btNormal, btAboveNormal, btRich);
  TIntersectionType = (itNone, itOne, itTwo);

  TQuarterType = (qtA, qtB, qtC, qtD);
  TQuarterRange = record
    Min, Max: Extended;
  end;

const
  RichBlur = Ord(High(TBlurType)) + 1;
  HalfPi = Pi / 2;
  DoublePi = Pi * 2;
  TriplePi = Pi * 3;
  Huge = 1E9;
  Tiny = 1 / 1E9;
  Approximation = - 3;
  QuarterRange: array[TQuarterType] of TQuarterRange =
    ((Min: 0; Max: HalfPi), (Min: HalfPi; Max: Pi), (Min: Pi; Max: TriplePi / 2),
    (Min: TriplePi / 2; Max: DoublePi));

function MakePixel(const R, G, B: Byte): TPixel; overload;
function MakePixel(const Color: TColor): TPixel; overload;
function MakePoint(const AX, AY: Extended): TExactPoint; overload;
function MakePoint(const Point: TPoint): TExactPoint; overload;
function MakePoint(const Point: TExactPoint): TPoint; overload;
procedure Exchange(var APoint, BPoint: TPoint); overload;
procedure Exchange(var APoint, BPoint: TExactPoint); overload;
procedure Exchange(var A, B: Extended); overload;

function Approximate(const Value: Extended): Extended;
function Align(const PointArray: array of TExactPoint; const APoint, BPoint: TExactPoint): Boolean;
function Same(const PointArray: array of TExactPoint): Boolean;
function SameX(const PointArray: array of TExactPoint): Boolean;
function SameY(const PointArray: array of TExactPoint): Boolean;
function SmallestX(const Point: TExactPoint; const PointArray: array of TExactPoint): Boolean;
function SmallestY(const Point: TExactPoint; const PointArray: array of TExactPoint): Boolean;
function LargestX(const Point: TExactPoint; const PointArray: array of TExactPoint): Boolean;
function LargestY(const Point: TExactPoint; const PointArray: array of TExactPoint): Boolean;

function GetTransparency(const APixel, BPixel: TPixel; const Factor: Byte): TPixel;
function GetRatio(const APixel, BPixel: TPixel; const Factor: Extended): TPixel;

function GetQuarterType(const Angle: Extended): TQuarterType;
function GetAngleRatio(const Angle, XRatio, YRatio: Extended): Extended;

function GetTangent(const APoint, BPoint: TExactPoint): Extended;
function Distort(const Tangent: Extended): Extended;
function GetAngleFromTangent(const Value: Extended; const Distortion: Extended = 0): Extended;
function GetTangentFromAngle(const Value: Extended): Extended;

function GetRise(const APoint: TExactPoint; const Tangent: Extended): Extended;
function GetDistance(const APoint, BPoint: TExactPoint): Extended;

function GetAngle(const APoint, BPoint: TExactPoint): Extended; overload;
function GetAngle(const A, B, C: Extended): Extended; overload;
function GetAngle(const Center, APoint: TExactPoint; const Radius: Extended): Extended; overload;
function GetAngle(const APoint, BPoint, CPoint: TExactPoint): Extended; overload;
function Simplify(const Angle: Extended): Extended;
function GetPoint(const Point: TExactPoint; const Angle, Distance: Extended;
  const XFactor: Extended = 1; const YFactor: Extended = 1): TExactPoint; overload;
function GetPoint(const APoint, BPoint: TExactPoint; const Distance: Extended;
  const XFactor: Extended = 1; const YFactor: Extended = 1): TExactPoint; overload;
function GetCoordinate(const Center: TExactPoint; const Angle, Distance: Extended;
  const XFactor: Extended = 1; const YFactor: Extended = 1): TExactPoint;

function GetIntersection(const Center: TExactPoint; const ARise, BRise, ATangent, BTangent, Radius: Extended;
  out AValue, BValue: TExactPoint): TIntersectionType; overload;
function GetIntersection(const Center, APoint, BPoint: TExactPoint; const Radius: Extended;
  out AValue, BValue: TExactPoint): TIntersectionType; overload;
function GetIntersection(const Center, APoint, BPoint: TExactPoint; const Radius: Extended): TExactPoint; overload;
function GetIntersection(const ARise, BRise, ATangent, BTangent: Extended): TExactPoint; overload;
function GetIntersection(const APoint, BPoint, CPoint, DPoint: TExactPoint): TExactPoint; overload;
function GetIntersection(const ACenter, BCenter: TExactPoint; const ARadius, BRadius: Extended;
  out AValue, BValue: TExactPoint): TIntersectionType; overload;

function GetIntersectionAngle(const ACenter, BCenter: TExactPoint; const ARadius, BRadius: Extended;
  out AValue, BValue: Extended; APoint: PExactPoint = nil; BPoint: PExactPoint = nil): Boolean;

procedure GetBisectorTouch(var APoint, BPoint, CPoint: TExactPoint;
  out AValue, BValue, CValue: TExactPoint);
function GetTriangleCircleTouch(const APoint, BPoint, Center: TExactPoint): TExactPoint;
function GetTriangleInnerCenter(APoint, BPoint, CPoint: TExactPoint): TExactPoint;
function GetTriangleInnerRadius(const APoint, BPoint, Center: TExactPoint): Extended;

procedure Circle(Bitmap: TBitmap; Center, Offset: TPoint; PixelFrom, PixelTo, BorderPixel: TPixel;
  Radius, HoleRadius, BlurRadius, InnerFeather, OuterFeather, BorderWidth, BorderFeather: Integer;
  BlurType: TBlurType = btPoor; Dash: Boolean = False; AutoDash: Boolean = True; ADashAngle: Extended = 0;
  BDashAngle: Extended = 0; DashSpace: Extended = 0; Transparency: Byte = MaxByte);

implementation

uses
  Classes, NumberConsts, NumberUtils, Types;

function MakePixel(const R, G, B: Byte): TPixel;
begin
  Result[ctBlue] := B;
  Result[ctGreen] := G;
  Result[ctRed] := R;
end;

function MakePixel(const Color: TColor): TPixel;
begin
  Result := MakePixel(GetRValue(Color), GetGValue(Color), GetBValue(Color));
end;

function MakePoint(const AX, AY: Extended): TExactPoint;
begin
  with Result do
  begin
    X := AX;
    Y := AY;
  end;
end;

function MakePoint(const Point: TPoint): TExactPoint;
begin
  with Result do
  begin
    X := Point.X;
    Y := Point.Y;
  end;
end;

function MakePoint(const Point: TExactPoint): TPoint;
begin
  with Result do
  begin
    X := Round(Point.X);
    Y := Round(Point.Y);
  end;
end;

procedure Exchange(var APoint, BPoint: TPoint);
var
  CPoint: TPoint;
begin
  CPoint := APoint;
  APoint := BPoint;
  BPoint := CPoint;
end;

procedure Exchange(var APoint, BPoint: TExactPoint);
var
  CPoint: TExactPoint;
begin
  CPoint := APoint;
  APoint := BPoint;
  BPoint := CPoint;
end;

procedure Exchange(var A, B: Extended);
var
  C: Extended;
begin
  C := A;
  A := B;
  B := C;
end;

function Approximate(const Value: Extended): Extended;
begin
  Result := RoundTo(Value, Approximation);
end;

function Align(const PointArray: array of TExactPoint; const APoint, BPoint: TExactPoint): Boolean;
var
  I: Integer;
  A, Tangent: Extended;
begin
  if Same([APoint, BPoint]) then Result := True
  else begin
    for I := Low(PointArray) to High(PointArray) do
    begin
      Tangent := Distort(GetTangent(APoint, BPoint));
      A := GetRise(APoint, Tangent);
      Result := Equal(PointArray[I].Y, Tangent * PointArray[I].X + A);
      if not Result then Exit;
    end;
    Result := True;
  end;
end;

function Same(const PointArray: array of TExactPoint): Boolean;
var
  I: Integer;
begin
  for I := Low(PointArray) to High(PointArray) do
    if I > Low(PointArray) then
    begin
      Result := Equal(PointArray[I].X, PointArray[I - 1].X) and
        Equal(PointArray[I].Y, PointArray[I - 1].Y);
      if not Result then Exit;
    end;
  Result := True;
end;

function SameX(const PointArray: array of TExactPoint): Boolean;
var
  I: Integer;
begin
  for I := Low(PointArray) to High(PointArray) do
    if I > Low(PointArray) then
    begin
      Result := Equal(PointArray[I].X, PointArray[I - 1].X);
      if not Result then Exit;
    end;
  Result := True;
end;

function SameY(const PointArray: array of TExactPoint): Boolean;
var
  I: Integer;
begin
  for I := Low(PointArray) to High(PointArray) do
    if I > Low(PointArray) then
    begin
      Result := Equal(PointArray[I].Y, PointArray[I - 1].Y);
      if not Result then Exit;
    end;
  Result := True;
end;

function SmallestX(const Point: TExactPoint; const PointArray: array of TExactPoint): Boolean;
var
  I: Integer;
begin
  for I := Low(PointArray) to High(PointArray) do
  begin
    Result := LessOrEqual(Point.X, PointArray[I].X);
    if not Result then Exit;
  end;
  Result := True;
end;

function SmallestY(const Point: TExactPoint; const PointArray: array of TExactPoint): Boolean;
var
  I: Integer;
begin
  for I := Low(PointArray) to High(PointArray) do
  begin
    Result := LessOrEqual(Point.Y, PointArray[I].Y);
    if not Result then Exit;
  end;
  Result := True;
end;

function LargestX(const Point: TExactPoint; const PointArray: array of TExactPoint): Boolean;
var
  I: Integer;
begin
  for I := Low(PointArray) to High(PointArray) do
  begin
    Result := GreaterOrEqual(Point.X, PointArray[I].X);
    if not Result then Exit;
  end;
  Result := True;
end;

function LargestY(const Point: TExactPoint; const PointArray: array of TExactPoint): Boolean;
var
  I: Integer;
begin
  for I := Low(PointArray) to High(PointArray) do
  begin
    Result := GreaterOrEqual(Point.Y, PointArray[I].Y);
    if not Result then Exit;
  end;
  Result := True;
end;

function GetTransparency(const APixel, BPixel: TPixel; const Factor: Byte): TPixel;
var
  AType: TChannelType;
begin
  for AType := Low(TChannelType) to High(TChannelType) do
    Result[AType] := (APixel[AType] * Factor + BPixel[AType] * (MaxByte - Factor)) div MaxByte;
end;

function GetRatio(const APixel, BPixel: TPixel; const Factor: Extended): TPixel;
var
  AType: TChannelType;
begin
  for AType := Low(TChannelType) to High(TChannelType) do
    Result[AType] := EnsureRange(Round(APixel[AType] * Factor + BPixel[AType] * (1 - Factor)), 0, MaxByte);
end;

function GetQuarterType(const Angle: Extended): TQuarterType;
begin
  if GreaterOrEqual(Angle, QuarterRange[qtA].Min) and Less(Angle, QuarterRange[qtA].Max) then
    Result := qtA
  else if GreaterOrEqual(Angle, QuarterRange[qtB].Min) and Less(Angle, QuarterRange[qtB].Max) then
    Result := qtB
  else if GreaterOrEqual(Angle, QuarterRange[qtC].Min) and Less(Angle, QuarterRange[qtC].Max) then
    Result := qtC
  else Result := qtD;
end;

function GetAngleRatio(const Angle, XRatio, YRatio: Extended): Extended;
begin
  Result := Simplify(Angle);
  case GetQuarterType(Result) of
    qtB: Result := (Pi - Result) / HalfPi;
    qtC: Result := (Result - Pi) / HalfPi;
    qtD: Result := (DoublePi - Result) / HalfPi;
  else Result := Result / HalfPi;
  end;
  Result := XRatio * (1 - Result) + YRatio * Result;
end;

function GetTangent(const APoint, BPoint: TExactPoint): Extended;
begin
  if Equal(APoint.X, BPoint.X) then Result := Infinity
  else if Equal(APoint.Y, BPoint.Y) then Result := 0
  else Result := (APoint.Y - BPoint.Y) / (APoint.X - BPoint.X);
end;

function Distort(const Tangent: Extended): Extended;
begin
  if IsInfinite(Tangent) then Result := Huge
  else if Equal(Tangent, 0) then Result := Tiny
  else Result := Tangent;
end;

function GetAngleFromTangent(const Value, Distortion: Extended): Extended;
begin
  if Greater(Distortion, 0) and IsInfinite(Value) or Equal(Value, Distortion) then
    Result := HalfPi
  else Result := ArcTan(Value);
end;

function GetTangentFromAngle(const Value: Extended): Extended;
begin
  if Equal(Frac(Approximate(Value / Pi)), 0) then Result := 0
  else
    if Greater(Value, 0) and Equal(Frac(Approximate(Value) / Approximate(HalfPi)), 0) then
      Result := Infinity
  else Result := Tan(Value);
end;

function GetRise(const APoint: TExactPoint; const Tangent: Extended): Extended;
begin
  Result := APoint.Y - Tangent * APoint.X;
end;

function GetDistance(const APoint, BPoint: TExactPoint): Extended;
begin
  if Equal(APoint.X, BPoint.X) then Result := Abs(APoint.Y - BPoint.Y)
  else if Equal(APoint.Y, BPoint.Y) then Result := Abs(APoint.X - BPoint.X)
  else Result := Sqrt(Sqr(APoint.X - BPoint.X) + Sqr(APoint.Y - BPoint.Y));
end;

function GetAngle(const APoint, BPoint: TExactPoint): Extended;
begin
  Result := GetAngleFromTangent(GetTangent(APoint, BPoint), Huge);
end;

function GetAngle(const A, B, C: Extended): Extended;
begin
  Result := ArcCos((Sqr(A) + Sqr(B) - Sqr(C)) / (A * B * 2));
end;

function GetAngle(const Center, APoint: TExactPoint; const Radius: Extended): Extended;
begin
  Result := GetAngle(MakePoint(Center.X + Radius, Center.Y), Center, APoint);
  if Less(APoint.Y, Center.Y) then Result := DoublePi - Result;
end;

function GetAngle(const APoint, BPoint, CPoint: TExactPoint): Extended;
var
  A, B, C: Extended;
begin
  if Same([APoint, BPoint, CPoint]) then Result := NaN
  else if SameX([APoint, BPoint, CPoint]) then
    if SmallestY(BPoint, [APoint, CPoint]) or LargestY(BPoint, [APoint, CPoint]) then
      Result := 0
    else Result := Pi
  else if Align([APoint], BPoint, CPoint) then
    if SmallestX(BPoint, [APoint, CPoint]) or LargestX(BPoint, [APoint, CPoint]) then
      Result := 0
    else Result := Pi
  else begin
    A := GetDistance(APoint, BPoint);
    B := GetDistance(BPoint, CPoint);
    C := GetDistance(APoint, CPoint);
    Result := GetAngle(A, B, C);
  end;
end;

function Simplify(const Angle: Extended): Extended;
begin
  Result := Angle;
  if Less(Result, 0) then while Less(Result, 0) do Result := Result + DoublePi
  else while GreaterOrEqual(Result, DoublePi) do Result := Result - DoublePi;
end;

function GetPoint(const Point: TExactPoint; const Angle, Distance: Extended;
  const XFactor, YFactor: Extended): TExactPoint;
begin
  Result := MakePoint(Point.X + Distance * XFactor * Cos(Angle),
    Point.Y + Distance * YFactor * Sin(Angle));
end;

function GetPoint(const APoint, BPoint: TExactPoint; const Distance: Extended;
  const XFactor, YFactor: Extended): TExactPoint;
begin
  Result := GetPoint(APoint, GetAngle(APoint, BPoint), Distance, XFactor, YFactor);
end;

function GetCoordinate(const Center: TExactPoint; const Angle, Distance: Extended;
  const XFactor, YFactor: Extended): TExactPoint;
begin
  Result := GetPoint(Center, DoublePi - Angle, Distance, XFactor, YFactor);
end;

function GetIntersection(const Center: TExactPoint; const ARise, BRise, ATangent, BTangent, Radius: Extended;
  out AValue, BValue: TExactPoint): TIntersectionType; overload;
var
  A, B: Extended;
begin
  A := GetAngleFromTangent(ATangent, Huge);
  AValue := GetIntersection(ARise, BRise, ATangent, BTangent);
  B := GetDistance(Center, AValue);
  if Greater(B, Radius) then Result := itNone
  else if Equal(B, Radius) then Result := itOne
  else begin
    B := Sqrt(Sqr(Radius) - Sqr(B));
    BValue := GetPoint(AValue, A, - B);
    AValue := GetPoint(AValue, A, B);
    Result := itTwo;
  end;
end;

function GetIntersection(const Center, APoint, BPoint: TExactPoint; const Radius: Extended;
  out AValue, BValue: TExactPoint): TIntersectionType;
var
  A, B, ATangent, BTangent: Extended;
begin
  ATangent := Distort(GetTangent(APoint, BPoint));
  A := GetAngleFromTangent(ATangent, Huge);
  BTangent := Distort(GetTangentFromAngle(A + HalfPi));
  A := GetRise(APoint, ATangent);
  B := GetRise(Center, BTangent);
  Result := GetIntersection(Center, A, B, ATangent, BTangent, Radius, AValue, BValue);
end;

function GetIntersection(const Center, APoint, BPoint: TExactPoint; const Radius: Extended): TExactPoint;
var
  AValue, BValue: TExactPoint;
begin
  case GetIntersection(Center, APoint, BPoint, Radius, AValue, BValue) of
    itTwo:
      if Equal(APoint.X, BPoint.X) then
        if Less(APoint.Y, BPoint.Y) then
          if Greater(AValue.Y, BValue.Y) then Result := AValue
          else Result := BValue
        else
          if Greater(AValue.Y, BValue.Y) then Result := BValue
          else Result := AValue
      else
        if Less(APoint.X, BPoint.X) then
          if Greater(AValue.X, BValue.X) then Result := AValue
          else Result := BValue
        else
          if Greater(AValue.X, BValue.X) then Result := BValue
          else Result := AValue;
    itOne: Result := AValue;
  end;
end;

function GetIntersection(const ARise, BRise, ATangent, BTangent: Extended): TExactPoint;
begin
  Result.X := (BRise - ARise) / (ATangent - BTangent);
  Result.Y := ATangent * Result.X + ARise;
end;

function GetIntersection(const APoint, BPoint, CPoint, DPoint: TExactPoint): TExactPoint;
var
  A, B, ATangent, BTangent: Extended;
begin
  ATangent := Distort(GetTangent(APoint, BPoint));
  A := GetRise(APoint, ATangent);
  BTangent := Distort(GetTangent(CPoint, DPoint));
  B := GetRise(CPoint, BTangent);
  Result := GetIntersection(A, B, ATangent, BTangent);
end;

function GetIntersection(const ACenter, BCenter: TExactPoint; const ARadius, BRadius: Extended;
  out AValue, BValue: TExactPoint): TIntersectionType;
var
  A, B: Extended;
begin
  if Same([ACenter, BCenter]) then Result := itNone
  else begin
    A := GetDistance(ACenter, BCenter);
    if Equal(A, 0) then Result := itNone
    else begin
      A := (Sqr(ARadius) - Sqr(BRadius) + Sqr(A)) / (A * 2);
      if Greater(Abs(A), ARadius) then Result := itNone
      else begin
        B := GetAngle(ACenter, BCenter, ARadius);
        AValue := GetPoint(ACenter, B, A);
        A := Sqrt(Sqr(ARadius) - Sqr(A));
        if Equal(A, 0) then Result := itOne
        else begin
          B := B + HalfPi;
          BValue := GetPoint(AValue, B, - A);
          AValue := GetPoint(AValue, B, A);
          Result := itTwo;
        end;
      end;
    end;
  end;
end;

function GetIntersectionAngle(const ACenter, BCenter: TExactPoint; const ARadius, BRadius: Extended;
  out AValue, BValue: Extended; APoint, BPoint: PExactPoint): Boolean;
var
  CPoint, DPoint, EPoint: TExactPoint;
  CValue: Extended;
begin
  Result := Assigned(APoint) and Assigned(BPoint);
  if not Result then
  begin
    APoint := @DPoint;
    BPoint := @EPoint;
    Result := GetIntersection(ACenter, BCenter, ARadius, BRadius, APoint^, BPoint^) = itTwo;
  end;
  if Result then
  begin
    AValue := GetAngle(ACenter, APoint^, ARadius);
    BValue := GetAngle(ACenter, BPoint^, ARadius);
    if Greater(AValue, BValue) then Exchange(AValue, BValue);
    CPoint := GetIntersection(ACenter, ACenter, BCenter, ARadius);
    CValue := GetAngle(ACenter, CPoint, ARadius);
    if Less(CValue, AValue) or Greater(CValue, BValue) then
      Exchange(AValue, BValue);
  end;
end;

procedure GetBisectorTouch(var APoint, BPoint, CPoint: TExactPoint;
  out AValue, BValue, CValue: TExactPoint);

  function Get(const APoint, BPoint, CPoint: TExactPoint;
    const A, B, C: Extended): TExactPoint;
  var
    D, E, ATangent, BTangent: Extended;
  begin
    D := GetAngle(BPoint, CPoint);
    E := GetAngle(A, B, C);
    ATangent := Distort(GetTangentFromAngle(D + E / 2));
    D := GetRise(BPoint, ATangent);
    BTangent := Distort(GetTangent(APoint, CPoint));
    E := GetRise(APoint, BTangent);
    Result := GetIntersection(D, E, ATangent, BTangent);
  end;

var
  A, B, C: Extended;
begin
  if Greater(BPoint.Y, APoint.Y) then Exchange(BPoint, APoint);
  if Greater(BPoint.Y, CPoint.Y) then Exchange(BPoint, CPoint);
  if Greater(APoint.X, CPoint.X) then Exchange(APoint, CPoint);
  A := GetDistance(APoint, BPoint);
  B := GetDistance(BPoint, CPoint);
  C := GetDistance(APoint, CPoint);
  AValue := Get(CPoint, APoint, BPoint, C, A, B);
  BValue := Get(APoint, BPoint, CPoint, A, B, C);
  CValue := Get(BPoint, CPoint, APoint, B, C, A);
end;

function GetTriangleCircleTouch(const APoint, BPoint, Center: TExactPoint): TExactPoint;
var
  A, B, ATangent, BTangent: Extended;
begin
  ATangent := Tan(HalfPi + GetAngle(APoint, BPoint));
  A := GetRise(Center, ATangent);
  BTangent := Distort(GetTangent(APoint, BPoint));
  B := GetRise(APoint, BTangent);
  Result := GetIntersection(A, B, ATangent, BTangent);
end;

function GetTriangleInnerCenter(APoint, BPoint, CPoint: TExactPoint): TExactPoint;
var
  AValue, BValue, CValue: TExactPoint;
  A, B, ATangent, BTangent: Extended;
begin
  GetBisectorTouch(APoint, BPoint, CPoint, AValue, BValue, CValue);
  ATangent := Distort(GetTangent(APoint, AValue));
  A := GetRise(APoint, ATangent);
  BTangent := Distort(GetTangent(BPoint, BValue));
  B := GetRise(BPoint, BTangent);
  Result := GetIntersection(A, B, ATangent, BTangent);
end;

function GetTriangleInnerRadius(const APoint, BPoint, Center: TExactPoint): Extended;
var
  A, B, ATangent, BTangent: Extended;
begin
  ATangent := Distort(GetTangent(APoint, BPoint));
  A := GetRise(APoint, ATangent);
  BTangent := Tan(HalfPi + GetAngleFromTangent(ATangent, Huge));
  B := GetRise(Center, BTangent);
  Result := GetDistance(Center, GetIntersection(A, B, ATangent, BTangent));
end;

procedure Circle(Bitmap: TBitmap; Center, Offset: TPoint; PixelFrom, PixelTo, BorderPixel: TPixel;
  Radius, HoleRadius, BlurRadius, InnerFeather, OuterFeather, BorderWidth, BorderFeather: Integer;
  BlurType: TBlurType; Dash, AutoDash: Boolean; ADashAngle, BDashAngle, DashSpace: Extended;
  Transparency: Byte);

  function GetXBound(Center: TPoint; Radius: Integer): TPoint;
  var
    Bound: TPoint;
  begin
    Bound := Point(0, Bitmap.Width - 1);
    Result := Point(IfThen(Center.X - Radius < Bound.X, - Center.X, - Radius),
      IfThen(Center.X + Radius < Bound.Y, Radius, Bound.Y - Center.X));
  end;

  function GetYBound(Center: TPoint; Radius: Integer): TPoint;
  var
    Bound: TPoint;
  begin
    Bound := Point(0, Bitmap.Height - 1);
    Result := Point(IfThen(Center.Y - Radius < Bound.X, - Center.Y, - Radius),
      IfThen(Center.Y + Radius < Bound.Y, Radius, Bound.Y - Center.Y));
  end;

  function Draw(const Subtense: Extended; const X, Y: Integer; out Pixel: TPixel): Boolean;
  var
    Point: TExactPoint;
    A, B, Ratio: Extended;
    APixel: PPixel;
  begin
    Result := LessOrEqual(Subtense, Radius);
    if Result then
    begin
      APixel := PPixel(Integer(Bitmap.ScanLine[Y]) + X * SizeOf(TPixel));
      if Greater(Subtense, HoleRadius) or (HoleRadius = 0) then
      begin
        Point := GetIntersection(MakePoint(Center), MakePoint(Offset), MakePoint(X, Y), Radius);
        A := GetDistance(MakePoint(Offset), MakePoint(X, Y));
        B := GetDistance(MakePoint(Offset), Point);
        Ratio := A / B;
        Pixel := GetRatio(PixelFrom, PixelTo, Ratio);
        if Greater(Subtense, Radius - BorderWidth) then
          if Less(Subtense, Radius - BorderWidth + BorderFeather) then
          begin
            Ratio := (Subtense + BorderWidth - Radius) / BorderFeather;
            Pixel := GetRatio(BorderPixel, Pixel, Ratio);
          end
          else Pixel := BorderPixel;
        Pixel := GetTransparency(Pixel, APixel^, Transparency);
        if Greater(Subtense, Radius - OuterFeather) then
        begin
          Ratio := (Radius - Subtense) / OuterFeather;
          Pixel := GetRatio(Pixel, APixel^, Ratio);
        end;
        if (HoleRadius > 0) and Less(Subtense, HoleRadius + InnerFeather) then
        begin
          Ratio := (Subtense - HoleRadius) / InnerFeather;
          Pixel := GetRatio(Pixel, APixel^, Ratio);
        end;
      end
      else Pixel := APixel^;
    end;
  end;

  function Blur(const Subtense: Extended; const X, Y: Integer; out Pixel: TPixel): Boolean;

    function Accessible(ASubtense: Extended): Boolean;
    begin
      Result := LessOrEqual(ASubtense, Radius - OuterFeather) and
        GreaterOrEqual(ASubtense, HoleRadius + InnerFeather);
    end;

  const
    Quality = 4;
  var
    I, J, Ratio, Index, Count: Integer;
    APixel: THeavyPixel;
    XBound, YBound: TPoint;
    ASubtense: Extended;
    AType: TChannelType;
  begin
    Result := (BlurRadius > 0) and Accessible(Subtense);
    if Result then
    begin
      Index := 0;
      Count := 0;
      FillChar(APixel, SizeOf(THeavyPixel), 0);
      XBound := GetXBound(Center, BlurRadius);
      YBound := GetYBound(Center, BlurRadius);
      I := (XBound.Y - XBound.X) * (YBound.Y - YBound.X) div Quality;
      Ratio := EnsureRange(Round((RichBlur - Ord(BlurType)) / RichBlur * I), 0, I);
      for I := XBound.X to XBound.Y do
        for J := YBound.X to YBound.Y do
        begin
          if Index mod Ratio = 0 then
          begin
            ASubtense := GetDistance(MakePoint(Center), MakePoint(I, J));
            if Accessible(ASubtense) and Draw(ASubtense, I, J, Pixel) then
            begin
              for AType := Low(TChannelType) to High(TChannelType) do
                Inc(APixel[AType], Pixel[AType]);
              Inc(Count);
            end;
          end;
          Inc(Index);
        end;
      Result := Count > 0;
      if Result then
        for AType := Low(TChannelType) to High(TChannelType) do
          Pixel[AType] := APixel[AType] div Count;
    end;
  end;

var
  BitmapBound, CircleBound: TRect;
  A, DashAngle, DashShift, Subtense: Extended;
  Count, HoleCount, I, J: Integer;
  XBound, YBound, Point: TPoint;
  Pixel: TPixel;

  function Accessible(Angle: Extended): Boolean;
  begin
    Result := not Dash;
    if not Result then
    begin
      if Greater(DashShift, 0) then Angle := Simplify(Angle + DashShift);
      Result := Less(Angle, ADashAngle) or Greater(Angle, BDashAngle) or Greater(DashAngle, 0) and
        Odd(Trunc((ADashAngle - Angle) / DashAngle));
    end;
  end;

begin
  BitmapBound := Rect(0, 0, Bitmap.Width - 1, Bitmap.Height - 1);
  CircleBound := Rect(Center.X - Radius, Center.Y - Radius, Center.X + Radius, Center.Y + Radius);
  if IntersectRect(BitmapBound, BitmapBound, CircleBound) then
  begin
    Dash := Dash and Greater(DashSpace, 0);
    if Dash then
    begin
      ADashAngle := Simplify(ADashAngle);
      BDashAngle := Simplify(BDashAngle);
      if Greater(ADashAngle, BDashAngle) then
      begin
        DashShift := DoublePi - ADashAngle;
        ADashAngle := 0;
        BDashAngle := BDashAngle + DashShift;
      end
      else DashShift := 0;
      if AutoDash then
      begin
        A := Abs(ADashAngle - BDashAngle) * Radius;
        I := Trunc(A / DashSpace);
        if Odd(I) then DashSpace := A / I
        else DashSpace := A / (I + 1);
        A := GetAngle(Radius, Radius, 1);
        ADashAngle := ADashAngle + A;
        BDashAngle := BDashAngle - A;
      end;
      DashAngle := GetAngle(Radius, Radius, DashSpace);
    end;
    Inc(Offset.X, Center.X);
    Inc(Offset.Y, Center.Y);
    YBound := GetYBound(Center, Radius);
    Point.Y := YBound.X;
    while Point.Y <= YBound.Y do
    begin
      Count := Round(Sqrt(Sqr(Radius) - Sqr(Point.Y)));
      if (HoleRadius > 0) and (Positive(Point.Y) < HoleRadius) then
        HoleCount := Round(Sqrt(Sqr(HoleRadius) - Sqr(Point.Y)))
      else HoleCount := 0;
      XBound := GetXBound(Center, Count);
      Point.X := XBound.X;
      while Point.X <= XBound.Y do
      begin
        if (HoleRadius > 0) and (Point.X > - HoleCount) and (Point.X < HoleCount) then
          Inc(Point.X, HoleCount + HoleCount);
        I := Center.X + Point.X;
        J := Center.Y + Point.Y;
        A := GetAngle(MakePoint(Center.X + Radius, Center.Y), MakePoint(Center), MakePoint(I, J));
        if Less(J, Center.Y) then A := DoublePi - A;
        Subtense := GetDistance(MakePoint(Center), MakePoint(I, J));
        if Accessible(A) and (Blur(Subtense, I, J, Pixel) or Draw(Subtense, I, J, Pixel)) then
          PPixel(Integer(Bitmap.ScanLine[J]) + I * SizeOf(TPixel))^ := Pixel;
        Inc(Point.X);
      end;
      Inc(Point.Y);
    end;
  end;
end;

initialization
  NumberUtils.Epsilon := Tiny;

end.

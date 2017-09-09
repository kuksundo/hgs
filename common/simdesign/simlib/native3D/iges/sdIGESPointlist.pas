{ sdIGESPointList

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdIGESPointlist;

interface

uses
  Classes, sdIGESFormat, sdPoints3D, sdSplines, Math;

type

  TIgsPoint3DMatrix = array of array of TsdPoint3D;

  TIgsCustomRenderer = class(TComponent)
  private
    FBreakupLength: double;
    FEvaluateSplines: boolean;
    FImportCurves: boolean;
    FImportSurfaces: boolean;
  protected
    // for specific entities
    procedure BuildCircularArc(AEntity: TIgsEntity; AList: TsdPolygon3D);
    procedure BuildConicArc(AEntity: TIgsEntity; AList: TsdPolygon3D);
    procedure BuildLinearPath(AEntity: TIgsEntity; AList: TsdPolygon3D);
    procedure BuildRationalBSplineCurve(AEntity: TIgsEntity; AList: TsdPolygon3D);
    procedure BuildRationalBSplineSurface(AEntity: TIgsEntity; AList: TsdPolygon3D);
    // Set BreakupLength to a value > 0 to ensure that linear and planar entities
    // are broken into linepieces of length < BreakupLength.
    property BreakupLength: double read FBreakupLength write FBreakupLength;
    // If EvaluateSplines is set to true, splines will be evaluated. If false, just
    // the control points will be used.
    property EvaluateSplines: boolean read FEvaluateSplines write FEvaluateSplines default True;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ImportCurves: boolean read FImportCurves write FImportCurves;
    property ImportSurfaces: boolean read FImportSurfaces write FImportSurfaces;
  end;

  TIgsPointlistRenderer = class(TIgsCustomRenderer)
  public
    procedure BuildModel(AIgs: TIgsFormat; AList: TsdPolygon3D);
    procedure RenderEntity(AIgs: TIgsFormat; AEntity: TIgsEntity; AList: TsdPolygon3D);
  published
    property BreakupLength;
  end;

const
  cEps = 1E-12;

implementation

{ TIgsCustomRenderer }

procedure TIgsCustomRenderer.BuildCircularArc(AEntity: TIgsEntity; AList: TsdPolygon3D);
var
  i, Count: integer;
  ZT, X1, Y1, X2, Y2, X3, Y3, A1, A2, A, R: double;
begin
  ZT := AEntity.Parameters[0].AsFloat;
  X1 := AEntity.Parameters[1].AsFloat;
  Y1 := AEntity.Parameters[2].AsFloat;
  X2 := AEntity.Parameters[3].AsFloat;
  Y2 := AEntity.Parameters[4].AsFloat;
  X3 := AEntity.Parameters[5].AsFloat;
  Y3 := AEntity.Parameters[6].AsFloat;
  A1 := Arctan2(Y2 - Y1, X2 - X1);
  A2 := Arctan2(Y3 - Y1, X3 - X1);
  while A2 < A1 + cEps do A2 := A2 + 2 * pi;
  R := Sqrt(Sqr(X2 - X1) + Sqr(Y2 - Y1));

  // Parametrize as 40 segments for full circle
  Count := Max(1, ceil((A2 - A1) * 40 / (2*pi)));
  AList.Add(Point3D(X2, Y2, ZT));
  for i := 1 to Count - 1 do begin
    A := (A2 - A1) / Count * i + A1;
    AList.Add(Point3D(X1 + R * cos(A), Y1 + R * sin(A), ZT));
  end;
  AList.Add(Point3D(X3, Y3, ZT));
end;

procedure TIgsCustomRenderer.BuildConicArc(AEntity: TIgsEntity; AList: TsdPolygon3D);
var
  i, Count: integer;
  A, B, C, D, E, F, ZT, X1, Y1, X2, Y2, Q1, Q2, Q3,
  Ra, Rb, A1, A2, At: double;
  function Det2x2(const A11, A12, A21, A22: double): double;
  begin
    Result := A11 * A22 - A12 * A21;
  end;
  function Det3x3(const A11, A12, A13, A21, A22, A23, A31, A32, A33: double): double;
  begin
    // must check!
    Result := + A11 * Det2x2(A22, A23, A32, A33)
              - A21 * Det2x2(A12, A13, A32, A33)
              + A31 * Det2x2(A12, A13, A22, A23);
  end;
begin
  A  := AEntity.Parameters[0].AsFloat;
  B  := AEntity.Parameters[1].AsFloat;
  C  := AEntity.Parameters[2].AsFloat;
  D  := AEntity.Parameters[3].AsFloat;
  E  := AEntity.Parameters[4].AsFloat;
  F  := AEntity.Parameters[5].AsFloat;
  ZT := AEntity.Parameters[6].AsFloat;
  X1 := AEntity.Parameters[7].AsFloat;
  Y1 := AEntity.Parameters[8].AsFloat;
  X2 := AEntity.Parameters[9].AsFloat;
  Y2 := AEntity.Parameters[10].AsFloat;

  // First point
  AList.Add(Point3D(X1, Y1, ZT));

  // Determine Q1, Q2, Q3
  Q1 := Det3x3(A, B/2, D/2, B/2, C, E/2, D/2, E/2, F);
  Q2 := Det2x2(A, B/2, B/2, C);
  Q3 := A + C;
  if (Q2 > 0) and (Q1 * Q3 < 0) then begin

    // Ellipse
    Ra := sqrt(-F/A);
    Rb := sqrt(-F/C);
    A1 := Arctan2(Y1/Ra, X1/Rb);
    A2 := Arctan2(Y2/Ra, X2/Rb);
    while A2 < A1 + cEps do A2 := A2 + 2 * pi;
    Count := Max(1, ceil((A2 - A1) * 40 / (2*pi)));
    for i := 1 to Count - 1 do begin
      At := (A2 - A1) / Count * i + A1;
      AList.Add(Point3D(Ra * cos(At), Rb * sin(At), ZT));
    end;

  end else if (Q2 < 0) and (abs(Q1) > cEps) then begin

    // Hyperbola: to do

  end else if (abs(Q2) < cEps) and (abs(Q1) > cEps) then begin

    // Parabola: to do

  end;

  // Second point
  AList.Add(Point3D(X2, Y2, ZT));
end;

procedure TIgsCustomRenderer.BuildLinearPath(AEntity: TIgsEntity; AList: TsdPolygon3D);
var
  i, IP, N: integer;
  X, Y, Z: double;
  IncludeLast: boolean;
begin
  IP := AEntity.Parameters[0].AsInt;
  N  := AEntity.Parameters[1].AsInt;
  case IP of
  1:// Common Z, XY pairs
    begin
      Z := AEntity.Parameters[2].AsFloat;
      for i := 0 to N - 1 do begin
        X := AEntity.Parameters[3 + i * 2].AsFloat;
        Y := AEntity.Parameters[4 + i * 2].AsFloat;
        IncludeLast := i = N - 1;
        AList.AddWithBreakupLength(Point3D(X, Y, Z), BreakupLength, IncludeLast);
      end;
    end;
  2: // XYZ pairs
    begin
      for i := 0 to N - 1 do begin
        X := AEntity.Parameters[3 + i * 3].AsFloat;
        Y := AEntity.Parameters[4 + i * 3].AsFloat;
        Z := AEntity.Parameters[5 + i * 3].AsFloat;
        IncludeLast := i = N - 1;
        AList.AddWithBreakupLength(Point3D(X, Y, Z), BreakupLength, IncludeLast);
      end;
    end;
  3: // XYZijk pairs
    begin
      for i := 0 to N - 1 do begin
        X := AEntity.Parameters[3 + i * 6].AsFloat;
        Y := AEntity.Parameters[4 + i * 6].AsFloat;
        Z := AEntity.Parameters[5 + i * 6].AsFloat;
        IncludeLast := i = N - 1;
        AList.AddWithBreakupLength(Point3D(X, Y, Z), BreakupLength, IncludeLast);
      end;
    end;
  end;
end;

procedure TIgsCustomRenderer.BuildRationalBSplineCurve(AEntity: TIgsEntity; AList: TsdPolygon3D);
var
  i, K, M, N, A, {Idx,} PROP3, Base, VCount: integer;
  {X, Y, Z,} V0, V1, v, dv, VL: double;
  Nurbs: TsdNurbs3D;
  APoint: TsdPoint3D;
begin
  K := AEntity.Parameters[0].AsInt;
  M := AEntity.Parameters[1].AsInt;
  N := 1 + K - M;
  PROP3 := AEntity.Parameters[4].AsInt;
  A := N + 2 * M;

  // Create NURBS curve object
  Nurbs := TsdNurbs3D.Create;
  try
    Nurbs.N := K;
    Nurbs.Degree := M;
    if PROP3 = 1 then Nurbs.Mode := nmPolynomial;

    // Knot sequence
    Base := 6;
    for i := 0 to A do
      Nurbs.Axis.KnotVector[i] := AEntity.Parameters[Base + i].AsFloat;

    // Weights
    Base := 7 + A;
    for i := 0 to K do begin
      Nurbs.Weight[i] := AEntity.Parameters[Base].AsFloat;
      inc(Base);
    end;

    // Control points
    Base := 8 + A + K;
    for i := 0 to K do begin
      APoint.X := AEntity.Parameters[Base    ].AsFloat;
      APoint.Y := AEntity.Parameters[Base + 1].AsFloat;
      APoint.Z := AEntity.Parameters[Base + 2].AsFloat;
      Nurbs.ControlPoint[i] := APoint;
      inc(Base, 3);
    end;

    // Start / end of parameter
    Base := 11 + A + 4 * K;
    V0 := AEntity.Parameters[Base    ].AsFloat;
    V1 := AEntity.Parameters[Base + 1].AsFloat;

    // Determine number of segments from length between control points
    VL := 0;
    for i := 0 to K - 1 do
      VL := VL + Dist3D(Nurbs.ControlPoint[i], Nurbs.ControlPoint[i + 1]);
    VCount := Max(1, ceil(VL / BreakupLength));

    dv := (V1 - V0) / VCount;

    // add VCount segments
    for i := 0 to VCount do begin
      v := V0 + i * dv;
      // point
      APoint := Nurbs.SplinePoint(v);
      AList.Add(APoint);
    end;
  finally
    Nurbs.Free;
  end;
{  K := AEntity.Parameters[0].AsInt;
  M := AEntity.Parameters[1].AsInt;
  N := 1 + K - M;
  A := N + 2 * M;
  Idx := 8 + A + K;
  for i := 0 to K do begin
    // control point i
    X := AEntity.Parameters[Idx    ].AsFloat;
    Y := AEntity.Parameters[Idx + 1].AsFloat;
    Z := AEntity.Parameters[Idx + 2].AsFloat;
    // Add just the control points for now
    AList.AddPoint(Point3D(X, Y, Z));
    inc(Idx, 3);
  end;}
end;

procedure TIgsCustomRenderer.BuildRationalBSplineSurface(AEntity: TIgsEntity; AList: TsdPolygon3D);
var
  i, j, {ii, jj,} K1, K2, M1, M2, N1, N2, A, B, C, PROP3, Base{, Stride, Idx}: integer;
  {X, Y, Z,} U0, U1, V0, V1: double;
  Nurbs: TsdNurbsSurface;
  APoint: TsdPoint3D;
  u, v, du, dv: double;
  procedure AddPointToVertex(const APoint: TsdPoint3D);
  begin
    AList.Add(APoint);
  end;
begin
  K1 := AEntity.Parameters[0].AsInt;
  K2 := AEntity.Parameters[1].AsInt;
  M1 := AEntity.Parameters[2].AsInt;
  M2 := AEntity.Parameters[3].AsInt;
  N1 := 1 + K1 - M1;
  N2 := 1 + K2 - M2;
  PROP3 := AEntity.Parameters[6].AsInt;
  A := N1 + 2 * M1;
  B := N2 + 2 * M2;
  C := (1 + K1) * (1 + K2);
  //Base := 11 + A + B + C;
  //Stride := 3 * (K1 + 1);

  // Create NURBS surface object
  Nurbs := TsdNurbsSurface.Create;
  try
    Nurbs.N1 := K1;
    Nurbs.N2 := K2;
    Nurbs.Degree1 := M1;
    Nurbs.Degree2 := M2;
    if PROP3 = 1 then Nurbs.Mode := nmPolynomial;

    // First knot sequence
    Base := 9;
    for i := 0 to A do
      Nurbs.Axis1.KnotVector[i] := AEntity.Parameters[Base + i].AsFloat;

    // Second knot sequence
    Base := 10 + A;
    for i := 0 to B do
      Nurbs.Axis2.KnotVector[i] := AEntity.Parameters[Base + i].AsFloat;

    // Weights
    Base := 11 + A + B;
    for j := 0 to K2 do
      for i := 0 to K1 do begin
        Nurbs.Weight[i, j] := AEntity.Parameters[Base].AsFloat;
        inc(Base);
      end;

    // Control points
    Base := 11 + A + B + C;
    for j := 0 to K2 do
      for i := 0 to K1 do begin
        APoint.X := AEntity.Parameters[Base    ].AsFloat;
        APoint.Y := AEntity.Parameters[Base + 1].AsFloat;
        APoint.Z := AEntity.Parameters[Base + 2].AsFloat;
        Nurbs.ControlPoint[i, j] := APoint;
        inc(Base, 3);
      end;

    // Start / end of parameters
    Base := 11 + A + B + 4 * C;
    U0 := AEntity.Parameters[Base    ].AsFloat;
    U1 := AEntity.Parameters[Base + 1].AsFloat;
    V0 := AEntity.Parameters[Base + 2].AsFloat;
    V1 := AEntity.Parameters[Base + 3].AsFloat;

    du := (U1 - U0) / 10;
    dv := (V1 - V0) / 10;

    // add 10x10 grid as mesh
    for j := 0 to 9 do begin
      v := V0 + j * dv;
      for i := 0 to 9 do begin
        u := U0 + i * du;
        // first point
        APoint := Nurbs.SplinePoint(u, v);
        AddPointToVertex(APoint);
        // second point
        APoint := Nurbs.SplinePoint(u + du, v);
        AddPointToVertex(APoint);
        // third point
        APoint := Nurbs.SplinePoint(u + du, v + dv);
        AddPointToVertex(APoint);
        // fourth point
        APoint := Nurbs.SplinePoint(u, v + dv);
        AddPointToVertex(APoint);
      end;
    end;
  finally
    Nurbs.Free;
  end;

end;

constructor TIgsCustomRenderer.Create(AOwner: TComponent);
begin
  inherited;
  FEvaluateSplines := True;
  FImportCurves := True;
  FImportSurfaces := True;
end;

{ TIgsPointlistRenderer }

procedure TIgsPointlistRenderer.BuildModel(AIgs: TIgsFormat; AList: TsdPolygon3D);
begin
// not implemented for pointlist renderer
end;

procedure TIgsPointlistRenderer.RenderEntity(AIgs: TIgsFormat;
  AEntity: TIgsEntity; AList: TsdPolygon3D);
var
  X, Y, Z: double;
  i: integer;
  AChild: TIgsEntity;
begin
  // Is the entity visible?
  if AEntity.BlankStatus <> 0 then exit;

  // Get the entity type
  case AEntity.Directory.EntityType of
  100: // circular arc
    begin
      // we approximate with line segments
      if FImportCurves then
        BuildCircularArc(AEntity, AList);
    end;
  102: // composite curve
    begin
      // add the sub-entities in the composite curve
      if FImportCurves then
        for i := 0 to AEntity.EntityCount - 1 do
          RenderEntity(AIgs, AEntity.Entities[i], AList);
    end;
  104: // conic arc
    begin
      // we approximate with line segments
      if FImportCurves then
        BuildConicArc(AEntity, AList);
    end;
  106:
    case AEntity.Directory.Form of
    11..13: // Linear path
      begin
        if FImportCurves then
          BuildLinearPath(AEntity, AList);
      end;
    63: // Simple closed planar curve
      begin
        if FImportCurves then
          BuildLinearPath(AEntity, AList);
      end;
    end;
  110: // line
    begin
      if FImportCurves then begin
        // First point
        X := AEntity.Parameters[0].AsFloat;
        Y := AEntity.Parameters[1].AsFloat;
        Z := AEntity.Parameters[2].AsFloat;
        AList.Add(Point3D(X, Y, Z));
        // Second point
        X := AEntity.Parameters[3].AsFloat;
        Y := AEntity.Parameters[4].AsFloat;
        Z := AEntity.Parameters[5].AsFloat;
        AList.Add(Point3D(X, Y, Z));
      end;
    end;
  126: // Rational B-Spline Curve
    begin
      // we approximate with line segments
      if FImportCurves then
        BuildRationalBSplineCurve(AEntity, AList);
    end;
  128: // Rational B-Spline Surface
    begin
      // we approximate with mesh quads
      if FImportSurfaces then
        BuildRationalBSplineSurface(AEntity, AList);
    end;
  142: // Curve on a parametric surface
    begin
      AChild := AEntity.Entities[2]; // CPTR
      if assigned(AChild) {and (AChild.Level = AEntity.Level)} then
        RenderEntity(AIgs, AChild, AList);
    end;
  144: // Trimmed (parametric) surface
    begin
      AChild := AEntity.Entities[0]; // PTS
      if assigned(AChild) {and (AChild.Level = AEntity.Level)} then
        RenderEntity(AIgs, AChild, AList);
      AChild := AEntity.Entities[1]; // PT0
      if assigned(AChild) {and (AChild.Level = AEntity.Level)} then
        RenderEntity(AIgs, AChild, AList);
    end;
  end;
//
end;

end.

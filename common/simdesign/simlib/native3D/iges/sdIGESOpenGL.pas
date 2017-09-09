unit sdIGESOpenGL;
{
  Description:

  Create a visual presentation of an IGES file in GlScene

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 20Feb2006

  Modifications:

  copyright (c) 2006 SimDesign B.V.
}

interface

uses
  Classes, sdIgesFormat, GlScene, GlObjects, GlTexture, VectorTypes, VectorGeometry,
  GlMisc, GlMesh, GlState, GlGeomObjects, Math, sdIGESPointList, sdSplines,
  sdPoints3D;

const
  cEps = 1E-12;

type

  // Use TIgsOpenGlRenderer to build an OpenGL model of the Iges document. See
  // procedure BuildModel.
  TIgsOpenGLRenderer = class(TIgsCustomRenderer)
  protected
    procedure AddEntityTransform(AEntity: TIgsEntity; ABase: TGlBaseSceneObject);
    // for specific entities
    procedure BuildConicArc(AEntity: TIgsEntity; Nodes: TGlNodes);
    procedure BuildCircularArc(AEntity: TIgsEntity; Nodes: TGlNodes);
    procedure BuildLinearPath(AEntity: TIgsEntity; Nodes: TGlNodes);
    procedure BuildRationalBSplineCurve(AEntity: TIgsEntity; Nodes: TGlNodes);
    procedure BuildRationalBSplineSurface(AEntity: TIgsEntity; Vertices: TVertexList);

    procedure BuildGlObject(AEntity: TIgsEntity; ABase: TGlBaseSceneObject);
    function EntityGlColor(AEntity: TIgsEntity): TVector4f;
  public
    // Build an OpenGL model of the IGES document AIgs into ABase. ABase can for
    // instance be a TGlDummyCube. ABase will be cleared first! This routine takes
    // into account the visibility of levels, so a partial build of the model can be
    // made by making levels invisible (Levels[i].IsVisible := False).
    procedure BuildModel(AIgs: TIgsFormat; ABase: TGlBaseSceneObject);
  end;

implementation

{ TIgsOpenGLRenderer }

procedure TIgsOpenGLRenderer.AddEntityTransform(AEntity: TIgsEntity;
  ABase: TGlBaseSceneObject);
var
  AMatrix: TIgsTransformationMatrixEntity;
  Mat: TMatrix;
begin
  AMatrix := AEntity.Matrix;
  if assigned(AMatrix) then begin
    Mat[0, 0] := AMatrix.Parameters[0].AsFloat;
    Mat[1, 0] := AMatrix.Parameters[1].AsFloat;
    Mat[2, 0] := AMatrix.Parameters[2].AsFloat;
    Mat[3, 0] := AMatrix.Parameters[3].AsFloat;
    Mat[0, 1] := AMatrix.Parameters[4].AsFloat;
    Mat[1, 1] := AMatrix.Parameters[5].AsFloat;
    Mat[2, 1] := AMatrix.Parameters[6].AsFloat;
    Mat[3, 1] := AMatrix.Parameters[7].AsFloat;
    Mat[0, 2] := AMatrix.Parameters[8].AsFloat;
    Mat[1, 2] := AMatrix.Parameters[9].AsFloat;
    Mat[2, 2] := AMatrix.Parameters[10].AsFloat;
    Mat[3, 2] := AMatrix.Parameters[11].AsFloat;
    Mat[0, 3] := 0;
    Mat[1, 3] := 0;
    Mat[2, 3] := 0;
    Mat[3, 3] := 1;
    ABase.Matrix := Mat;
  end;
end;

procedure TIgsOpenGLRenderer.BuildCircularArc(AEntity: TIgsEntity; Nodes: TGlNodes);
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
  Nodes.AddNode(X2, Y2, ZT);
  for i := 1 to Count - 1 do begin
    A := (A2 - A1) / Count * i + A1;
    Nodes.AddNode(X1 + R * cos(A), Y1 + R * sin(A), ZT);
  end;
  Nodes.AddNode(X3, Y3, ZT);
end;

procedure TIgsOpenGLRenderer.BuildConicArc(AEntity: TIgsEntity; Nodes: TGlNodes);
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
  Nodes.AddNode(X1, Y1, ZT);

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
      Nodes.AddNode(Ra * cos(At), Rb * sin(At), ZT);
    end;

  end else if (Q2 < 0) and (abs(Q1) > cEps) then begin

    // Hyperbola: to do

  end else if (abs(Q2) < cEps) and (abs(Q1) > cEps) then begin

    // Parabola: to do

  end;

  // Second point
  Nodes.AddNode(X2, Y2, ZT);
end;

procedure TIgsOpenGLRenderer.BuildGlObject(AEntity: TIgsEntity; ABase: TGlBaseSceneObject);
var
  i: integer;
  X, Y, Z: double;
  ALine: TGlLines;
  AMesh: TGlMesh;
  APolygon: TGlPolygon;
  ACube: TGlDummyCube;
  AChild: TIgsEntity;
begin
  // Is the entity visible?
  if AEntity.BlankStatus <> 0 then exit;

  // Get the entity type
  case AEntity.Directory.EntityType of
  100: // circular arc
    begin
      // we approximate with line segments
      ALine := TGlLines.Create(ABase);
      ALine.NodesAspect := lnaInvisible;
      BuildCircularArc(AEntity, ALine.Nodes);
      ALine.LineColor.Color := EntityGlColor(AEntity);
      AddEntityTransform(AEntity, ALine);
      ABase.AddChild(ALine);
    end;
  102: // composite curve
    begin
      // We add another dummy cube and add the sub-entities in the composite
      // curve to this cube.
      ACube := TGlDummyCube.Create(ABase);
      for i := 0 to AEntity.EntityCount - 1 do
        BuildGlObject(AEntity.Entities[i], ACube);
      AddEntityTransform(AEntity, ACube);
      ABase.AddChild(ACube);
    end;
  104: // conic arc
    begin
      // we approximate with line segments
      ALine := TGlLines.Create(ABase);
      ALine.NodesAspect := lnaInvisible;
      BuildConicArc(AEntity, ALine.Nodes);
      ALine.LineColor.Color := EntityGlColor(AEntity);
      AddEntityTransform(AEntity, ALine);
      ABase.AddChild(ALine);
    end;
  106:
    case AEntity.Directory.Form of
    11..13: // Linear path
      begin
        ALine := TGlLines.Create(ABase);
        ALine.NodesAspect := lnaInvisible;
        BuildLinearPath(AEntity, ALine.Nodes);
        AddEntityTransform(AEntity, ALine);
        ABase.AddChild(ALine);
      end;
    63: // Simple closed planar curve
      begin
        APolygon := TGlPolygon.Create(ABase);
        BuildLinearPath(AEntity, APolygon.Nodes);
        AddEntityTransform(AEntity, APolygon);
        ABase.AddChild(APolygon);
      end;
    end;
  110: // line
    begin
      ALine := TGlLines.Create(ABase);
      ALine.NodesAspect := lnaInvisible;
      // First point
      X := AEntity.Parameters[0].AsFloat;
      Y := AEntity.Parameters[1].AsFloat;
      Z := AEntity.Parameters[2].AsFloat;
      ALine.Nodes.AddNode(X, Y, Z);
      // Second point
      X := AEntity.Parameters[3].AsFloat;
      Y := AEntity.Parameters[4].AsFloat;
      Z := AEntity.Parameters[5].AsFloat;
      ALine.Nodes.AddNode(X, Y, Z);
      ALine.LineColor.Color := EntityGlColor(AEntity);
      ABase.AddChild(ALine);
      AddEntityTransform(AEntity, ALine);
    end;
  126: // Rational B-Spline Curve
    begin
      // we approximate with line segments
      ALine := TGlLines.Create(ABase);
      ALine.NodesAspect := lnaInvisible;
      BuildRationalBSplineCurve(AEntity, ALine.Nodes);
      ALine.LineColor.Color := EntityGlColor(AEntity);
      AddEntityTransform(AEntity, ALine);
      ABase.AddChild(ALine);
    end;
  128: // Rational B-Spline Surface
    begin
      // we approximate with mesh quads
      AMesh := TGlMesh.Create(ABase);
      AMesh.Vertices.Clear;
      AMesh.Mode := mmQuads;
      AMesh.VertexMode := vmVN;
//      AMesh.Material.BlendingMode := bmModulate;
      AMesh.Material.FaceCulling := fcNoCull;
//      AMesh.Material.FrontProperties.PolygonMode := pmLines;
//      AMesh.Material.BackProperties.PolygonMode := pmLines;
      AMesh.Material.FrontProperties.Diffuse{Emission}.Color := EntityGlColor(AEntity);
      AMesh.Material.BackProperties.Diffuse{Emission}.Color := EntityGlColor(AEntity);
      BuildRationalBSplineSurface(AEntity, AMesh.Vertices);
      AddEntitytransform(AEntity, AMesh);
      AMesh.CalcNormals(fwClockwise{fwCounterClockWise});
      ABase.AddChild(AMesh);
    end;
  142: // Curve on a parametric surface
    begin
      ACube := TGlDummyCube.Create(ABase);
      AddEntityTransform(AEntity, ACube);
      AChild := AEntity.Entities[2]; // CPTR
      if assigned(AChild) then
        BuildGlObject(AChild, ACube);
      ABase.AddChild(ACube);
    end;
  144: // Trimmed (parametric) surface
    begin
      ACube := TGlDummyCube.Create(ABase);
      AddEntityTransform(AEntity, ACube);
      AChild := AEntity.Entities[0]; // PTS
      if assigned(AChild) then
        BuildGlObject(AChild, ACube);
      AChild := AEntity.Entities[1]; // PT0
      if assigned(AChild) then
        BuildGlObject(AChild, ACube);
      ABase.AddChild(ACube);
    end;
  end;
end;

procedure TIgsOpenGLRenderer.BuildLinearPath(AEntity: TIgsEntity; Nodes: TGlNodes);
var
  i, IP, N: integer;
  X, Y, Z: double;
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
        Nodes.AddNode(X, Y, Z);
      end;
    end;
  2: // XYZ pairs
    begin
      for i := 0 to N - 1 do begin
        X := AEntity.Parameters[3 + i * 3].AsFloat;
        Y := AEntity.Parameters[4 + i * 3].AsFloat;
        Z := AEntity.Parameters[5 + i * 3].AsFloat;
        Nodes.AddNode(X, Y, Z);
      end;
    end;
  3: // XYZijk pairs
    begin
      for i := 0 to N - 1 do begin
        X := AEntity.Parameters[3 + i * 6].AsFloat;
        Y := AEntity.Parameters[4 + i * 6].AsFloat;
        Z := AEntity.Parameters[5 + i * 6].AsFloat;
        Nodes.AddNode(X, Y, Z);
      end;
    end;
  end;
end;

procedure TIgsOpenGLRenderer.BuildModel(AIgs: TIgsFormat; ABase: TGlBaseSceneObject);
var
  i: integer;
begin
  // Delete all scene objects
  ABase.DeleteChildren;

  // Loop through Iges structure
  for i := 0 to AIgs.Structure.Count - 1 do
    if AIgs.Structure[i].GetLevel.IsVisible then
      BuildGlObject(AIgs.Structure[i], ABase);

end;

procedure TIgsOpenGLRenderer.BuildRationalBSplineCurve(AEntity: TIgsEntity;
  Nodes: TGlNodes);
var
  i, K, M, N, A, Idx: integer;
  X, Y, Z: double;
begin
  K := AEntity.Parameters[0].AsInt;
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
    Nodes.AddNode(X, Y, Z);
    inc(Idx, 3);
  end;
end;

procedure TIgsOpenGLRenderer.BuildRationalBSplineSurface(AEntity: TIgsEntity;
  Vertices: TVertexList);
var
  i, j, {ii, jj,} K1, K2, M1, M2, N1, N2, A, B, C, PROP3, Base{, Stride, Idx}: integer;
  {X, Y, Z,} U0, U1, V0, V1: double;
  //AVertex: TVertexData;
  Nurbs: TsdNurbsSurface;
  APoint: TsdPoint3D;
  u, v, du, dv: double;
  procedure AddPointToVertex(const APoint: TsdPoint3D);
  var
    AVertex: TVertexData;
  begin
    AVertex.Coord[0] := APoint.X;
    AVertex.Coord[1] := APoint.Y;
    AVertex.Coord[2] := APoint.Z;
    Vertices.AddVertex(AVertex);
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

{  // Add just the control points for now
  for j := 0 to K2 - 1 do
    for i := 0 to K1 - 1 do begin
      Idx := Base + i * 3 + j * Stride;
      // control point 0,0
      AVertex.coord[0] := AEntity.Parameters[Idx    ].AsFloat;
      AVertex.coord[1] := AEntity.Parameters[Idx + 1].AsFloat;
      AVertex.coord[2] := AEntity.Parameters[Idx + 2].AsFloat;
      Vertices.AddVertex(AVertex);
      // control point 1,0
      AVertex.coord[0] := AEntity.Parameters[Idx + 3].AsFloat;
      AVertex.coord[1] := AEntity.Parameters[Idx + 4].AsFloat;
      AVertex.coord[2] := AEntity.Parameters[Idx + 5].AsFloat;
      Vertices.AddVertex(AVertex);
      // control point 1,1
      AVertex.coord[0] := AEntity.Parameters[Idx + 3 + Stride].AsFloat;
      AVertex.coord[1] := AEntity.Parameters[Idx + 4 + Stride].AsFloat;
      AVertex.coord[2] := AEntity.Parameters[Idx + 5 + Stride].AsFloat;
      Vertices.AddVertex(AVertex);
      // control point 1,0
      AVertex.coord[0] := AEntity.Parameters[Idx     + Stride].AsFloat;
      AVertex.coord[1] := AEntity.Parameters[Idx + 1 + Stride].AsFloat;
      AVertex.coord[2] := AEntity.Parameters[Idx + 2 + Stride].AsFloat;
      Vertices.AddVertex(AVertex);
    end;}
end;

function TIgsOpenGLRenderer.EntityGlColor(AEntity: TIgsEntity): TVector4f;
begin
  case AEntity.Directory.Color of
  1: Result := clrBlack;
  2: Result := clrRed;
  3: Result := clrGreen;
  4: Result := clrBlue;
  5: Result := clrYellow;
  6: Result := clrPurple;
  7: Result := clrLime;
  8: Result := clrWhite;
  else
    Result := clrBlack;
  end;
end;

end.

unit sdIGESToScene3D;
{
  Convert an IGES file read into TIgsFormat into a 3D representation

  original author: Nils Haeck M.Sc.
  copyright (c) 2006 - 2008 by SimDesign BV
}
interface

uses
  Classes, SysUtils, Graphics, sdIGESFormat, sdIGESEntities, sdScene3D, sdPoints3D,
  Math, sdSplines, sdScene3DPointList, sdScene3DMesh, sdMesh, sdTriMesh2D,
  sdTriangulate2D, sdDelaunay2D, sdScene3DBuilder;

type

  TIgsCurveType = (
    ctModel,
    ctParametric
  );

  TIgsCurveGenerator = class(TPersistent)
  private
    FBreakupLength: double;
  protected
    procedure BuildCircularArc(AEntity: TIgsEntity; APoly: TsdPolygon3D);
    procedure BuildConicArc(AEntity: TIgsEntity; APoly: TsdPolygon3D);
    procedure BuildLinearPath(AEntity: TIgsEntity; APoly: TsdPolygon3D);
    procedure BuildRationalBSplineCurve(AEntity: TIgsEntity; APoly: TsdPolygon3D);
  public
    procedure ToPoly(ACurve: TIgsEntity; APoly: TsdPolygon3D; AType: TIgsCurveType);
    property BreakupLength: double read FBreakupLength write FBreakupLength;
  end;

  TIgsSurfaceGenerator = class(TPersistent)
  private
    FCurveGen: TIgsCurveGenerator;
    FPoly: TsdPolygon3D;
    FNurbs: TsdNurbsSurface;
    FBreakupLength: double;
  protected
    procedure BuildMesh(AMesh: TsdTriangleMesh3D);
    procedure ToNurbs(ASurface: TIgsEntity128; ANurbs: TsdNurbsSurface);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure ToMesh(ASurface: TIgsEntity; AMesh: TsdTriangleMesh3D);
    property BreakupLength: double read FBreakupLength write FBreakupLength;
  end;

  TIgsImportItem = class(TsdImportItem)
  protected
    function GetName: string; override;
  end;

  // Build a 3D scene based on the IGES file represented in the Igs property.
  TIgsSceneBuilder = class(TsdAbstractSceneBuilder)
  private
    FIgs: TIgsFormat;
    FCurveGen: TIgsCurveGenerator;
    FPoly: TsdPolygon3D;
    FSurfaceGen: TIgsSurfaceGenerator;
    FMesh: TsdTriangleMesh3D;
  protected
    procedure AddCurve(ACurve: TIgsEntity);
    procedure AddSurface(ASurface: TIgsEntity);
    procedure AddBoundedSurface(AEntity: TIgsEntity143);
    procedure AddTrimmedSurface(AEntity: TIgsEntity144);
    function EntityColor(AEntity: TIgsEntity): TColor;
    function UnitsToSI: double; override;
    function ItemClass: TsdImportItemClass; override;
    procedure SetSelectBy(const Value: TsdSelectByType); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BuildScene; override;
    procedure UpdateVisibility; override;
    property Igs: TIgsFormat read FIgs write FIgs;
  end;

const
  cEps = 1E-12;

implementation

{ TIgsCurveGenerator }

procedure TIgsCurveGenerator.BuildCircularArc(AEntity: TIgsEntity; APoly: TsdPolygon3D);
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
  while A2 < A1 + cEps do
    A2 := A2 + 2 * pi;
  R := Sqrt(Sqr(X2 - X1) + Sqr(Y2 - Y1));

  // Parametrize as 40 segments for full circle
  Count := Max(1, ceil((A2 - A1) * 40 / (2*pi)));
  APoly.Add(Point3D(X2, Y2, ZT));
  for i := 1 to Count - 1 do
  begin
    A := (A2 - A1) / Count * i + A1;
    APoly.Add(Point3D(X1 + R * cos(A), Y1 + R * sin(A), ZT));
  end;
  APoly.Add(Point3D(X3, Y3, ZT));
end;

procedure TIgsCurveGenerator.BuildConicArc(AEntity: TIgsEntity; APoly: TsdPolygon3D);
var
  i, Count: integer;
  A, B, C, D, E, F, ZT, X1, Y1, X2, Y2, Q1, Q2, Q3,
  Ra, Rb, A1, A2, At: double;
  // local
  function Det2x2(const A11, A12, A21, A22: double): double;
  begin
    Result := A11 * A22 - A12 * A21;
  end;
  // local
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
  APoly.Add(Point3D(X1, Y1, ZT));

  // Determine Q1, Q2, Q3
  Q1 := Det3x3(A, B/2, D/2, B/2, C, E/2, D/2, E/2, F);
  Q2 := Det2x2(A, B/2, B/2, C);
  Q3 := A + C;
  if (Q2 > 0) and (Q1 * Q3 < 0) then
  begin

    // Ellipse
    Ra := sqrt(-F/A);
    Rb := sqrt(-F/C);
    A1 := Arctan2(Y1/Ra, X1/Rb);
    A2 := Arctan2(Y2/Ra, X2/Rb);
    while A2 < A1 + cEps do
      A2 := A2 + 2 * pi;
    Count := Max(1, ceil((A2 - A1) * 40 / (2*pi)));
    for i := 1 to Count - 1 do
    begin
      At := (A2 - A1) / Count * i + A1;
      APoly.Add(Point3D(Ra * cos(At), Rb * sin(At), ZT));
    end;

  end else if (Q2 < 0) and (abs(Q1) > cEps) then
  begin

    // Hyperbola: to do

  end else if (abs(Q2) < cEps) and (abs(Q1) > cEps) then
  begin

    // Parabola: to do

  end;
  // Second point
  APoly.Add(Point3D(X2, Y2, ZT));
end;

procedure TIgsCurveGenerator.BuildLinearPath(AEntity: TIgsEntity; APoly: TsdPolygon3D);
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
      for i := 0 to N - 1 do
      begin
        X := AEntity.Parameters[3 + i * 2].AsFloat;
        Y := AEntity.Parameters[4 + i * 2].AsFloat;
        IncludeLast := i = N - 1;
        APoly.AddWithBreakupLength(Point3D(X, Y, Z), FBreakupLength, IncludeLast);
      end;
    end;
  2: // XYZ pairs
    begin
      for i := 0 to N - 1 do
      begin
        X := AEntity.Parameters[3 + i * 3].AsFloat;
        Y := AEntity.Parameters[4 + i * 3].AsFloat;
        Z := AEntity.Parameters[5 + i * 3].AsFloat;
        IncludeLast := i = N - 1;
        APoly.AddWithBreakupLength(Point3D(X, Y, Z), FBreakupLength, IncludeLast);
      end;
    end;
  3: // XYZijk pairs
    begin
      for i := 0 to N - 1 do
      begin
        X := AEntity.Parameters[3 + i * 6].AsFloat;
        Y := AEntity.Parameters[4 + i * 6].AsFloat;
        Z := AEntity.Parameters[5 + i * 6].AsFloat;
        IncludeLast := i = N - 1;
        APoly.AddWithBreakupLength(Point3D(X, Y, Z), FBreakupLength, IncludeLast);
      end;
    end;
  end;
end;

procedure TIgsCurveGenerator.BuildRationalBSplineCurve(AEntity: TIgsEntity; APoly: TsdPolygon3D);
var
  i, K, M, N, A, PROP3, Base, VCount: integer;
  V0, V1, v, dv, VL: double;
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
    if PROP3 = 1 then
      Nurbs.Mode := nmPolynomial;

    // Knot sequence
    Base := 6;
    for i := 0 to A do
      Nurbs.Axis.KnotVector[i] := AEntity.Parameters[Base + i].AsFloat;

    // Weights
    Base := 7 + A;
    for i := 0 to K do
    begin
      Nurbs.Weight[i] := AEntity.Parameters[Base].AsFloat;
      inc(Base);
    end;

    // Control points
    Base := 8 + A + K;
    for i := 0 to K do
    begin
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
    VCount := Max(1, ceil(VL / FBreakupLength));

    dv := (V1 - V0) / VCount;

    // add VCount + 1 segments
    for i := 0 to VCount do
    begin
      v := V0 + i * dv;
      // point
      APoint := Nurbs.SplinePoint(v);
      APoly.Add(APoint);
    end;
  finally
    Nurbs.Free;
  end;
end;

procedure TIgsCurveGenerator.ToPoly(ACurve: TIgsEntity; APoly: TsdPolygon3D;
  AType: TIgsCurveType);
var
  i, j: integer;
  X, Y, Z: double;
  Child: TIgsEntity;
begin
  if not assigned(ACurve) or not assigned(APoly) then
    exit;
  // Get the entity type, and render the entity to a polygon
  case ACurve.Directory.EntityType of
  100: // circular arc
    // we approximate with line segments
    BuildCircularArc(ACurve, APoly);
  102: // composite curve
    // add the sub-entities in the composite curve
    for i := 0 to ACurve.EntityCount - 1 do
      ToPoly(ACurve.Entities[i], APoly, AType);
  104: // conic arc
    // we approximate with line segments
    BuildConicArc(ACurve, APoly);
  106:
    case ACurve.Directory.Form of
    11..13: // Linear path
      BuildLinearPath(ACurve, APoly);
    63: // Simple closed planar curve
      BuildLinearPath(ACurve, APoly);
    end;
  110: // line
    begin
      // First point
      X := ACurve.Parameters[0].AsFloat;
      Y := ACurve.Parameters[1].AsFloat;
      Z := ACurve.Parameters[2].AsFloat;
      APoly.Add(Point3D(X, Y, Z));
      // Second point
      X := ACurve.Parameters[3].AsFloat;
      Y := ACurve.Parameters[4].AsFloat;
      Z := ACurve.Parameters[5].AsFloat;
      APoly.AddWithBreakupLength(Point3D(X, Y, Z), FBreakupLength, True);
    end;
  126: // Rational B-Spline Curve
    // we approximate with line segments
    BuildRationalBSplineCurve(ACurve, APoly);
  141: // Boundary
    begin
      for i := 0 to TIgsEntity141(ACurve).CurveCount - 1 do
      begin
        case AType of
        ctModel:
          ToPoly(TIgsEntity141(ACurve).ModelCurves(i), APoly, AType);
        ctParametric:
          for j := 0 to TIgsEntity141(ACurve).ParamCurveCount(i) - 1 do
            ToPoly(TIgsEntity141(ACurve).ParamCurves(i, j), APoly, AType);
        end;
      end;
    end;
  142: // Curve on a parametric surface
    begin
      case AType of
      ctModel:      Child := TIgsEntity142(ACurve).CCurve; // CPTR
      ctParametric: Child := TIgsEntity142(ACurve).BCurve; // BPTR
      else
        Child := nil;
      end;
      // Render the model or parametric child curve
      if assigned(Child) then
        ToPoly(Child, APoly, AType);
    end;
  end;
end;

{ TIgsSurfaceGenerator }

procedure TIgsSurfaceGenerator.BuildMesh(AMesh: TsdTriangleMesh3D);
var
  i, j: integer;
  Graph: TsdGraph2D;
  Tri: TsdQualityMesh2D;
  VList: TsdVertex2DList;
  VIdx: array[0..2] of integer;
  P: TsdPoint3D;
begin
  Graph := TsdGraph2D.Create;
  Tri := TsdQualityMesh2D.Create;
  VList := TsdVertex2DList.Create(False);
  try
    // Build the graph from the polyline
    FPoly.DeleteDuplicates(1E-6);
    for i := 0 to FPoly.Count - 1 do
      Graph.Vertices.Add(TsdVertex2D.CreateWithCoords(FPoly.Points[i].X, FPoly.Points[i].Y));
    for i := 0 to Graph.Vertices.Count - 1 do
      Graph.Boundaries.Add(TsdBoundary2D.CreateWithVertices(
        Graph.Vertices[i], Graph.Vertices[(i + 1) mod Graph.Vertices.Count]));

    // Generate the triangulation
    Tri.MaximumElementSize := sqr(FCurveGen.BreakupLength * 3);
    Tri.MinimumSegmentLength := FCurveGen.BreakupLength / 2;
    Tri.MinimumAngle := 20;
    Tri.AddGraph(Graph);
    Tri.Triangulate;
    Tri.OptimizeForFEM(VList);

    // Now generate the 3D mesh from this triangulation with help of the nurbs
    AMesh.Clear;
    for i := 0 to VList.Count - 1 do
    begin
      P := FNurbs.SplinePoint(VList[i].X, VList[i].Y);
      AMesh.VertexAdd(P.X, P.Y, P.Z, 0, 0, 0);
    end;
    for i := 0 to Tri.Triangles.Count - 1 do
    begin
      for j := 0 to 2 do
        VIdx[j] := VList.IndexOf(Tri.Triangles[i].Vertices[j]);
      AMesh.TriangleAdd(VIdx[0], VIdx[1], VIdx[2]);
    end;
    // Calculate the vertex normals based on triangle normals
    AMesh.CalculateNormals;

  finally
    Graph.Free;
    Tri.Free;
    VList.Free;
  end;
end;

constructor TIgsSurfaceGenerator.Create;
begin
  inherited Create;
  FCurveGen := TIgsCurveGenerator.Create;
  FPoly := TsdPolygon3D.Create;
  FNurbs := TsdNurbsSurface.Create;
end;

destructor TIgsSurfaceGenerator.Destroy;
begin
  FreeAndNil(FCurveGen);
  FreeAndNil(FPoly);
  FreeAndNil(FNurbs);
  inherited;
end;

procedure TIgsSurfaceGenerator.ToMesh(ASurface: TIgsEntity; AMesh: TsdTriangleMesh3D);
var
  i, Count: integer;
  Child: TIgsEntity;
  BB: TsdBox3D;
  Diag, Span: double;
begin
  FPoly.Clear;
  // Get the entity type, and render the entity to a mesh
  case ASurface.Directory.EntityType of

  143: // bounded surface
    begin
      Child := TIgsEntity143(ASurface).Surface;
      // exit if no surface of type 128
      if not assigned(Child) or (Child.Directory.EntityType <> 128) then
        exit;
      // Find the nurbs representation
      ToNurbs(TIgsEntity128(Child), FNurbs);
      if FNurbs.ControlPointsBoundingBox(BB) then
      begin
        Diag := Dist3D(BB.Min, BB.Max);
        Count := Max(1, ceil(Diag / FBreakupLength));
        Span := max(FNurbs.UMax - FNurbs.UMin, FNurbs.VMax - FNurbs.VMin) * 3;
        FCurveGen.BreakupLength := Span / Count;
      end;

      // Generate boundary
      for i := 0 to TIgsEntity143(ASurface).BoundaryCount - 1 do
      begin
        Child := TIgsEntity143(ASurface).Boundaries(i);
        FCurveGen.ToPoly(Child, FPoly, ctParametric);
      end;
      // Use the polygon and nurbs to create a mesh
      BuildMesh(AMesh);
    end;

  144: // trimmed parametric surface
    begin
      // The parametric surface
      Child := TIgsEntity144(ASurface).Surface;
      // exit if no surface of type 128
      if not assigned(Child) or (Child.Directory.EntityType <> 128) then
        exit;
      // Find the nurbs representation
      ToNurbs(TIgsEntity128(Child), FNurbs);
      if FNurbs.ControlPointsBoundingBox(BB) then
      begin
        Diag := Dist3D(BB.Min, BB.Max);
        Count := Max(1, ceil(Diag / FBreakupLength));
        Span := max(FNurbs.UMax - FNurbs.UMin, FNurbs.VMax - FNurbs.VMin) * 3;
        FCurveGen.BreakupLength := Span / Count;
      end;

      // The outer boundary
      Child := TIgsEntity144(ASurface).OuterBoundary;
      // exit if no outer boundary of type 142
      if not assigned(Child) or (Child.Directory.EntityType <> 142) then
        exit;

      // Generate outer boundary
      FCurveGen.ToPoly(Child, FPoly, ctParametric);

      // Use the polygon and nurbs to create a mesh
      BuildMesh(AMesh);
    end;
  end;
end;

procedure TIgsSurfaceGenerator.ToNurbs(ASurface: TIgsEntity128; ANurbs: TsdNurbsSurface);
var
  i, j, {ii, jj,} K1, K2, M1, M2, N1, N2, A, B, C, Base{, Stride, Idx}: integer;
  APoint: TsdPoint3D;
begin
  K1 := ASurface.K1;
  K2 := ASurface.K2;
  M1 := ASurface.M1;
  M2 := ASurface.M2;
  N1 := 1 + K1 - M1;
  N2 := 1 + K2 - M2;
  A := N1 + 2 * M1;
  B := N2 + 2 * M2;
  C := (1 + K1) * (1 + K2);

  ANurbs.N1 := K1;
  ANurbs.N2 := K2;
  ANurbs.Degree1 := M1;
  ANurbs.Degree2 := M2;
  if ASurface.IsPolynomial then
    ANurbs.Mode := nmPolynomial;

  // First knot sequence
  Base := 9;
  for i := 0 to A do
    ANurbs.Axis1.KnotVector[i] := ASurface.Parameters[Base + i].AsFloat;

  // Second knot sequence
  Base := 10 + A;
  for i := 0 to B do
    ANurbs.Axis2.KnotVector[i] := ASurface.Parameters[Base + i].AsFloat;

  // Weights
  Base := 11 + A + B;
  for j := 0 to K2 do
    for i := 0 to K1 do
    begin
      ANurbs.Weight[i, j] := ASurface.Parameters[Base].AsFloat;
      inc(Base);
    end;

  // Control points
  Base := 11 + A + B + C;
  for j := 0 to K2 do
  begin
    for i := 0 to K1 do
    begin
      APoint.X := ASurface.Parameters[Base    ].AsFloat;
      APoint.Y := ASurface.Parameters[Base + 1].AsFloat;
      APoint.Z := ASurface.Parameters[Base + 2].AsFloat;
      ANurbs.ControlPoint[i, j] := APoint;
      inc(Base, 3);
    end;
  end;
end;

{ TIgsImportItem }

function TIgsImportItem.GetName: string;
var
  E: TIgsEntity;
begin
  E := TIgsEntity(Ref);
  Result :=
    Format('%d (%s)', [E.Directory.SequenceNumber, E.EntityTypeName]);
end;

{ TIgsSceneBuilder }

procedure TIgsSceneBuilder.AddBoundedSurface(AEntity: TIgsEntity143);
var
  i: integer;
  Child: TIgsEntity;
begin
  // Build the curves
  for i := 0 to AEntity.BoundaryCount - 1 do
  begin
    Child := AEntity.Boundaries(i);
    AddCurve(Child);
  end;
  // Build the surface
  AddSurface(AEntity);
end;

procedure TIgsSceneBuilder.AddCurve(ACurve: TIgsEntity);
var
  PL: TsdScene3DPolyLine;
  Root: TIgsEntity;
begin
  FPoly.Clear;
  // We define the breakup length for world coordinates
  FCurveGen.FBreakupLength := BreakupLength / FIgs.UnitsToSI;
  FCurveGen.ToPoly(ACurve, FPoly, ctModel);
  if FPoly.Count = 0 then
    exit;
  PL := TsdScene3DPolyLine.Create(Scene, nil);
  // Is this a closed polygon?
  PL.IsClosed := SquaredDist3D(FPoly.First^, FPoly.Last^) < sqr(cEps);
  FPoly.DeleteDuplicates(cEps);
  PL.AddPoints(FPoly.First, FPoly.Count);
  Root := ACurve.StructureRoot;
  // Use the color defined for the curve's root
  PL.GDIColor := EntityColor(Root);
  // Add to our list of imported entities
  NewItem(PL, Root);
end;

procedure TIgsSceneBuilder.AddSurface(ASurface: TIgsEntity);
var
  M: TsdScene3DMesh;
  Root: TIgsEntity;
begin
  FMesh.Clear;
  try
    FSurfaceGen.ToMesh(ASurface, FMesh);
    if FMesh.TriangleCount = 0 then
      exit;
    M := TsdScene3DMesh.Create(Scene, nil);
    M.Mesh.Assign(FMesh);
    Root := ASurface.StructureRoot;
    // Use the color defined for the curve's root
    M.GDIColor := EntityColor(Root);
    // Add to our list of imported entities
    NewItem(M, Root);
  except
    // do not add the item if the meshing failed
  end;
end;

procedure TIgsSceneBuilder.AddTrimmedSurface(AEntity: TIgsEntity144);
var
  i: integer;
  Child: TIgsEntity;
begin
  // Build the curves
  Child := AEntity.OuterBoundary;
  AddCurve(Child);
  for i := 0 to AEntity.InnerBoundaryCount - 1 do
  begin
    Child := AEntity.InnerBoundaries(i);
    AddCurve(Child);
  end;
  // Build the surface
  AddSurface(AEntity);
end;

procedure TIgsSceneBuilder.BuildScene;
var
  i: integer;
  E: TIgsEntity;
begin
  Clear;

  // Breakup length
  FCurveGen.BreakupLength := BreakupLength / FIgs.UnitsToSI;
  FSurfaceGen.BreakupLength := BreakupLength / FIgs.UnitsToSI;

  // We only add the structural elements to the scene
  for i := 0 to FIgs.Structure.Count - 1 do
  begin
    E := FIgs.Structure[i];

    // Top-level entities to add
    case E.Directory.EntityType of
    126: // Rational bspline curve
      AddCurve(E);
{    128:
      AddSurface(E);}
    143: // Trimmed (parametric) surface
      AddBoundedSurface(TIgsEntity143(E));
    144: // Trimmed (parametric) surface
      AddTrimmedSurface(TIgsEntity144(E));
    end;
  end;

  inherited;
end;

constructor TIgsSceneBuilder.Create;
begin
  inherited;
  FCurveGen := TIgsCurveGenerator.Create;
  FPoly := TsdPolygon3D.Create;
  FSurfaceGen := TIgsSurfaceGenerator.Create;
  FMesh := TsdTriangleMesh3D.Create;
end;

destructor TIgsSceneBuilder.Destroy;
begin
  FreeAndNil(FCurveGen);
  FreeAndNil(FPoly);
  FreeandNil(FSurfaceGen);
  FreeAndNil(FMesh);
  inherited;
end;

function TIgsSceneBuilder.EntityColor(AEntity: TIgsEntity): TColor;
var
  E: TIgsEntity;
begin
  if AEntity.Directory.Color < 0 then
  begin
    E := FIgs.EntityBySequenceNumber(-AEntity.Directory.Color);
    if E is TIgsEntity314 then
    begin
      Result := TIgsEntity314(E).ToColor;
      exit;
    end;
  end;
  case AEntity.Directory.Color of
  1: Result := clBlack;
  2: Result := clRed;
  3: Result := clLime;
  4: Result := clBlue;
  5: Result := clYellow;
  6: Result := clPurple;
  7: Result := clLime;
  8: Result := clWhite;
  else
    Result := clBlack;
  end;
end;

function TIgsSceneBuilder.ItemClass: TsdImportItemClass;
begin
  Result := TIgsImportItem;
end;

procedure TIgsSceneBuilder.SetSelectBy(const Value: TsdSelectByType);
begin
  if Value = sbLayer then
    raise Exception.Create('Cannot select by layer in IGES');
  inherited;
end;

function TIgsSceneBuilder.UnitsToSI: double;
begin
  Result := FIgs.UnitsToSI;
end;

procedure TIgsSceneBuilder.UpdateVisibility;
var
  i: integer;
  SceneItem: TsdScene3DItem;
  ImportItem: TsdImportItem;
begin
  for i := 0 to Scene.Items.Count - 1 do
  begin
    SceneItem := Scene.Items[i];
    ImportItem := TsdImportItem(SceneItem.Tag);
    SceneItem.Visible := ImportItem.Selected or ImportItem.Highlighted;
    if ImportItem.Highlighted then
      SceneItem.GDIColor := clRed
    else
      SceneItem.GDIColor := clGreen;
  end;
  inherited;
end;

end.

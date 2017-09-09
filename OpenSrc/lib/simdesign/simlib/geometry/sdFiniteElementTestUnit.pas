unit sdFiniteElementTestUnit;
{
  Description:

  Some test routines for the sdFiniteElement unit.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 13Sep2005

  Modifications:

  copyright (c) 2005 SimDesign B.V.
}

interface

uses
  SysUtils, sdFiniteElement, sdPoints2D, sdPoints3D, sdMesh, pdFlattenMesh;

type

  TsdFEMTester = class
  private
    FOnLog: TsdStringEvent;
  protected
    procedure DoLogInfo(Sender: TObject; const Info: string);
    procedure DoLog(const Info: string);
  public
    procedure TestBeamBars;
    procedure TestBeamPlane;
    procedure TestPlaneStress;
    procedure TestPlaneInternalStress;
    property OnLog: TsdStringEvent read FOnLog write FOnLog;
  end;

implementation

{ TsdFEMTester }

procedure TsdFEMTester.DoLog(const Info: string);
begin
  if assigned(FOnLog) then FOnLog(Self, Info);
end;

procedure TsdFEMTester.DoLogInfo(Sender: TObject; const Info: string);
begin
  if assigned(FOnLog) then FOnLog(Sender, Info);
end;

procedure TsdFEMTester.TestBeamBars;
// Test of a beam built of prismatic bars (2D)
var
  i, iter, N: integer;
  Fem: TsdFemBarSystem3D;
  EA: double;
const
  cHorSep = 1.0;
begin
  // Test problem
  Fem := TsdFemBarSystem3D.Create;
  N := 3;
  // N-bar system
  // 1-2-3  --etc
  //  \  |\
  //   1 3 5
  //    \|  \
  // 0-0-2-4-4
  //         |
  //        load

  Fem.VertexCount := 3 + N * 2;
  Fem.BarCount    := 2 + N * 4;
  // planar system
  for i := 0 to Fem.VertexCount - 1 do
    Fem.Vertices[i].Constr[2] := True;
  // load
  Fem.Vertices[Fem.VertexCount - 1].F.Y := 5000; // 5000 N
  // constraints
  Fem.Vertices[0].Constr[0] := True; // vertex 0 in X
  Fem.Vertices[0].Constr[1] := True; // vertex 0 in Y
  Fem.Vertices[1].Constr[0] := True; // vertex 1 in X
  Fem.Vertices[1].Constr[1] := True; // vertex 1 in Y
  // vertex positions
  Fem.Vertices[0].P.Y := 1;
  for i := 0 to N do begin
    Fem.Vertices[1 + i * 2].P.X :=  i      * cHorSep;
    Fem.Vertices[2 + i * 2].P.X := (i + 1) * cHorSep;
    Fem.Vertices[2 + i * 2].P.Y := 1;
  end;
  // edges
  Fem.Bars[0].V0 := 0;
  Fem.Bars[0].V1 := 2;
  Fem.Bars[1].V0 := 2;
  Fem.Bars[1].V1 := 1;
  for i := 0 to N - 1 do begin
    Fem.Bars[2 + i * 4].V0 := 1 + i * 2;
    Fem.Bars[2 + i * 4].V1 := 3 + i * 2;
    Fem.Bars[3 + i * 4].V0 := 3 + i * 2;
    Fem.Bars[3 + i * 4].V1 := 2 + i * 2;
    Fem.Bars[4 + i * 4].V0 := 2 + i * 2;
    Fem.Bars[4 + i * 4].V1 := 4 + i * 2;
    Fem.Bars[5 + i * 4].V0 := 4 + i * 2;
    Fem.Bars[5 + i * 4].V1 := 3 + i * 2;
  end;
  // edges - L0
  for i := 0 to Fem.BarCount - 1 do
    Fem.Bars[i].L0 := Dist3D(Fem.Vertices[Fem.Bars[i].V0].P, Fem.Vertices[Fem.Bars[i].V1].P);
  // steel quad 50x50mm, thick 2 mm
  EA := 200 * 1E9 * (0.05 * 4 * 0.002);
  // edges - k
  for i := 0 to Fem.BarCount - 1 do
    Fem.Bars[i].k := EA / Fem.Bars[i].L0;
  iter := 0;
  repeat
    inc(iter);
    DoLog(Format('Iter: %d', [iter]));
    // Progress
    Fem.OnLogInfo := DoLogInfo;
    // solve system
    Fem.Solve;
    DoLog(Format('Equations: %d', [Fem.EquationCount]));
    // Update positions
    for i := 0 to Fem.VertexCount - 1 do
      AddPoint3D(Fem.Vertices[i].P, Fem.Vertices[i].U, Fem.Vertices[i].P);
    // display results
    for i := 2 to Fem.VertexCount - 1 do
      if not odd(i) then
        DoLog(Format('Vertex %d = %s', [i, Point3DToString(Fem.Vertices[i].P, 1000, '%7.8f')]));
  until iter = 1;
  Fem.Free;
end;

procedure TsdFEMTester.TestBeamPlane;
var
  i, j, Iter: integer;
  Fem: TsdFemPlaneSystem2D;
  S: TsdStressInfo;
const
  cXSize = 8;
  cYSize = 3;
  cLength = 16;
  cHeight = 1.5;
begin
  // Test problem
  Fem := TsdFemPlaneSystem2D.Create;

  Fem.VertexCount  := (cXSize + 1) * (cYSize + 1);
  Fem.ElementCount := cXSize * cYSize * 2;
  Fem.Thickness := 0.002; // 2 mm

  // load
  Fem.Vertices[Fem.VertexCount - 1].F.Y := 5000; // 1000 N

  // constraints
  Fem.Vertices[0].Constr[1] := True; // vertex 0 in Y
  for i := 0 to cYSize do begin
    Fem.Vertices[i].Constr[0] := True; // first row of vertices in X
//    Fem.Vertices[i].Constr[1] := True; // first row of vertices in Y
  end;

  // vertex positions
  for i := 0 to cXSize do
    for j := 0 to cYSize do begin
      Fem.Vertices[i * (cYSize + 1) + j].P.X := i * (cLength/cXSize);
      Fem.Vertices[i * (cYSize + 1) + j].P.Y := j * (cHeight/cYSize);
    end;

  // elements
  for i := 0 to cXSize - 1 do
    for j := 0 to cYSize - 1 do begin
      with Fem.Elements[(i * cYSize + j) * 2] do begin
        VertexIdx[0] :=  i      * (cYSize + 1) + j;
        VertexIdx[1] := (i + 1) * (cYSize + 1) + j;
        VertexIdx[2] := (i + 1) * (cYSize + 1) + j + 1;
      end;
      with Fem.Elements[(i * cYSize + j) * 2 + 1] do begin
        VertexIdx[0] :=  i      * (cYSize + 1) + j;
        VertexIdx[1] :=  i      * (cYSize + 1) + j + 1;
        VertexIdx[2] := (i + 1) * (cYSize + 1) + j + 1;
      end;
    end;

  // test: remove some elements
  Fem.ElementDelete(46);
  Fem.ElementDelete(45);
  Fem.ElementDelete(44);
  Fem.ElementDelete(43);
  Fem.ElementDelete(42);
  Fem.ElementDelete(38);
  Fem.ElementDelete(37);
  Fem.ElementDelete(36);
  Fem.ElementDelete(30);

  // display positions
  for i := 0 to Fem.VertexCount - 1 do begin
    if i mod (cYSize + 1) = 0 then DoLog('');
    DoLog(Format('Position of vertex %d  in m = %s', [i + 1, Point2DToString(Fem.Vertices[i].P, 1, '%7.3f')]));
  end;

  // display connections
  for i := 0 to Fem.ElementCount - 1 do
    DoLog(Format('Element %d connected to vertex %d, %d, %d',
      [i + 1, Fem.Elements[i].VertexIdx[0] + 1, Fem.Elements[i].VertexIdx[1] + 1, Fem.Elements[i].VertexIdx[2] + 1]));

  // material
  for i := 0 to Fem.ElementCount - 1 do
    with Fem.Elements[i] do begin
      Material.E := 200 * 1E9;
      Material.v := 0.28;
    end;

  iter := 0;
  repeat
    inc(iter);
    DoLog(Format('Iter: %d', [iter]));
    // Progress
    Fem.OnLogInfo := DoLogInfo;
    // solve system
    Fem.Solve;
    DoLog(Format('Equations: %d', [Fem.EquationCount]));
    // Update positions
    for i := 0 to Fem.VertexCount - 1 do
      AddPoint2D(Fem.Vertices[i].P, Fem.Vertices[i].U, Fem.Vertices[i].P);

    // display displacements
    for i := 0 to Fem.VertexCount - 1 do begin
      if i mod (cYSize + 1) = 0 then DoLog('');
      DoLog(Format('Displacement of vertex %d in mm = %s', [i + 1, Point2DToString(Fem.Vertices[i].U, 1000, '%7.3f')]));
    end;

    // display stresses in elements
    for i := 0 to Fem.ElementCount - 1 do begin
      Fem.ElementStresses(i, S);
      DoLog(Format('Stresses of element %d (SigXX, SigYY, SigXY) in MPa = %7.3f, %7.3f, %7.3f',
        [i + 1, S.Sxx * 1E-6, S.Syy * 1E-6, S.Sxy * 1E-6]));
    end;

  until iter = 1;
  Fem.Free;
end;

procedure TsdFEMTester.TestPlaneInternalStress;
var
  i: integer;
  Quad2, Quad3: TsdQuad3D;
  Flat: TpdFlattener;
begin
  Quad2 := TsdQuad3D.Create;
  Quad3 := TsdQuad3D.Create;
  for i := 0 to 3 do begin
    Quad2.VertexAdd(i, 0, 0);
    Quad2.VertexAdd(i, 1, 0);
  end;
  for i := 0 to 2 do
    Quad2.QuadAdd(i*2, 2 + i*2, 1 + i*2, 3 + i*2);
  Quad3.Assign(Quad2);
  for i := 0 to Quad3.VertexCount - 1 do
    Quad3.Vertices[i].Z := Quad3.Vertices[i].X;
  Flat := TpdFlattener.Create;
  Flat.OnLogInfo := DoLogInfo;
  Flat.Material.T := 1;
  Flat.Material.E := 1;
  Flat.MaxIterations := 5;
  Flat.FlattenQuad(Quad3, Quad2, nil);

  // show results for Quad2.X
  for i := 0 to Quad2.VertexCount - 1 do
    DoLog(Format('Position of vertex %d in m = %s', [i + 1, Point3DToString(Quad2.Vertices[i]^, 1, '%7.3f')]));

  Flat.Free;
  Quad2.Free;
  Quad3.Free;
end;

procedure TsdFEMTester.TestPlaneStress;
var
  Fem: TsdFemPlaneSystem2D;
  S: TsdStressInfo;
  i: integer;
begin
  Fem := TsdFemPlaneSystem2D.Create;
  Fem.VertexCount := 4;//5;
  Fem.ElementCount := 4;//3;
  Fem.Elements[0].VertexIdx[0] := 1;
  Fem.Elements[0].VertexIdx[1] := 2;
  Fem.Elements[0].VertexIdx[2] := 3;
  Fem.Elements[1].VertexIdx[0] := 0;
  Fem.Elements[1].VertexIdx[1] := 1;
  Fem.Elements[1].VertexIdx[2] := 3;
  Fem.Elements[2].VertexIdx[0] := 0;
  Fem.Elements[2].VertexIdx[1] := 1;
  Fem.Elements[2].VertexIdx[2] := 2;
  Fem.Elements[3].VertexIdx[0] := 0;
  Fem.Elements[3].VertexIdx[1] := 3;
  Fem.Elements[3].VertexIdx[2] := 2;
{  Fem.Elements[2].VertexIdx[0] := 3;
  Fem.Elements[2].VertexIdx[1] := 2;
  Fem.Elements[2].VertexIdx[2] := 4;}
  Fem.Elements[0].Material.E := 1;//200 * 1E9;
  Fem.Elements[0].Material.v := 0.28;
  Fem.Elements[1].Material.E := 1;//200 * 1E9;
  Fem.Elements[1].Material.v := 0.28;
  Fem.Elements[2].Material.E := 1;//200 * 1E9;
  Fem.Elements[2].Material.v := 0.28;
  Fem.Elements[3].Material.E := 1;//200 * 1E9;
  Fem.Elements[3].Material.v := 0.28;
{  Fem.Elements[2].Material.E := 200 * 1E9;
  Fem.Elements[2].Material.v := 0.28;}
  Fem.Thickness := 0.5;//0.002;
  Fem.Vertices[0].P.X := 0; Fem.Vertices[0].P.Y := 0;
  Fem.Vertices[1].P.X := 0; Fem.Vertices[1].P.Y := 1;
  Fem.Vertices[2].P.X := 1; Fem.Vertices[2].P.Y := 1;
  Fem.Vertices[3].P.X := 1; Fem.Vertices[3].P.Y := 0;
{  Fem.Vertices[4].P.X := 2; Fem.Vertices[4].P.Y := 1;}
{  Fem.Vertices[2].U.X := 0.001; Fem.Vertices[2].U.Y := 0;
  // calculate stresses
  Fem.ElementStresses(0, Sxx, Syy, Sxy);
  DoLog(Format('Sxx,Syy,Sxy=%7.1f,%7.1f,%7.1f', [Sxx * 1E-6, Syy * 1E-6, Sxy * 1E-6]));}
{  Fem.Vertices[0].Constr[0] := True;
  Fem.Vertices[0].Constr[1] := True;
  Fem.Vertices[1].Constr[0] := True;}
  Fem.Vertices[3].F.Y := 1;
  Fem.OnLogInfo := DoLogInfo;
  Fem.Solve;

  // display positions
  for i := 0 to Fem.VertexCount - 1 do begin
    DoLog(Format('Position of vertex %d in m = %s', [i + 1, Point2DToString(Fem.Vertices[i].P, 1, '%7.3f')]));
  end;

  // display equation numbers
  for i := 0 to Fem.VertexCount - 1 do begin
    DoLog(Format('Vertex %d eq no = %d, %d', [i + 1, Fem.Vertices[i].EqNo[0], Fem.Vertices[i].EqNo[1]]));
  end;

  // display connections
  for i := 0 to Fem.ElementCount - 1 do
    DoLog(Format('Element %d connected to vertex %d, %d, %d',
      [i + 1, Fem.Elements[i].VertexIdx[0] + 1, Fem.Elements[i].VertexIdx[1] + 1, Fem.Elements[i].VertexIdx[2] + 1]));
  // display displacements
  for i := 0 to Fem.VertexCount - 1 do begin
    DoLog(Format('Displacement of vertex %d in mm = %s', [i + 1, Point2DToString(Fem.Vertices[i].U, 1000, '%7.3f')]));
  end;

  // display stresses in elements
  for i := 0 to Fem.ElementCount - 1 do begin
    Fem.ElementStresses(i, S);
    DoLog(Format('Stresses of element %d (SigXX, SigYY, SigXY) in MPa = %7.3f, %7.3f, %7.3f',
      [i + 1, S.Sxx * 1E-6, S.Syy * 1E-6, S.Sxy * 1E-6]));
  end;

  Fem.Free;
end;

end.

{
  Description:
  Triangulation Demo executable.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 01Feb2007

  Modifications:

  copyright (c) 2007 SimDesign B.V.
  
  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
  
}
unit TestTriang2DMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Math, Menus,
  // simdesign units
  sdTriangulate2D, sdTriMesh2D, sdDelaunay2D, sdPoints2D;

type
  TfrmMain = class(TForm)
    pnlLeft: TPanel;
    pnlMain: TPanel;
    pbMain: TPaintBox;
    btnTriangulate: TButton;
    chbCenter: TCheckBox;
    chbDelaunayCircle: TCheckBox;
    chbExecutionSteps: TCheckBox;
    btnNext: TButton;
    sbMain: TStatusBar;
    chbPolygon: TCheckBox;
    mmInfo: TMemo;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuGraphs: TMenuItem;
    mnuRandomPoints: TMenuItem;
    mnuCircle: TMenuItem;
    mnuPlatewithholes: TMenuItem;
    mnuEdit: TMenuItem;
    mnuClearAll: TMenuItem;
    mnuAddPolygon: TMenuItem;
    chbVertices: TCheckBox;
    mnuEllipse: TMenuItem;
    mnuIntersection: TMenuItem;
    chbDelaunayMesh: TCheckBox;
    chbQualityMesh: TCheckBox;
    edMinAngle: TEdit;
    lbBeta: TLabel;
    chbSegments: TCheckBox;
    Label1: TLabel;
    cbbRemoval: TComboBox;
    mnuLoadPSLG: TMenuItem;
    mnuSavePSLG: TMenuItem;
    mnuExit: TMenuItem;
    chbPhaseSteps: TCheckBox;
    mnuBox: TMenuItem;
    btnAuto: TButton;
    tmAuto: TTimer;
    mnuClearMesh: TMenuItem;
    mnuClosePolygon: TMenuItem;
    chbMaxElementSize: TCheckBox;
    edMaxElementSize: TEdit;
    Label2: TLabel;
    mnuMesh: TMenuItem;
    mnuLocalRefine: TMenuItem;
    mnuSimpleBox: TMenuItem;
    mnuOnePoint: TMenuItem;
    procedure pbMainClick(Sender: TObject);
    procedure pbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pbMainPaint(Sender: TObject);
    procedure btnTriangulateClick(Sender: TObject);
    procedure chbCenterClick(Sender: TObject);
    procedure chbExecutionStepsClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure chbDelaunayCircleClick(Sender: TObject);
    procedure chbPolygonClick(Sender: TObject);
    procedure mnuRandomPointsClick(Sender: TObject);
    procedure mnuCircleClick(Sender: TObject);
    procedure mnuClearAllClick(Sender: TObject);
    procedure mnuAddPolygonClick(Sender: TObject);
    procedure chbVerticesClick(Sender: TObject);
    procedure mnuPlatewithholesClick(Sender: TObject);
    procedure mnuEllipseClick(Sender: TObject);
    procedure mnuIntersectionClick(Sender: TObject);
    procedure chbSegmentsClick(Sender: TObject);
    procedure mnuSavePSLGClick(Sender: TObject);
    procedure mnuLoadPSLGClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure chbPhaseStepsClick(Sender: TObject);
    procedure chbDelaunayMeshClick(Sender: TObject);
    procedure chbQualityMeshClick(Sender: TObject);
    procedure edMinAngleExit(Sender: TObject);
    procedure mnuBoxClick(Sender: TObject);
    procedure tmAutoTimer(Sender: TObject);
    procedure btnAutoClick(Sender: TObject);
    procedure mnuClearMeshClick(Sender: TObject);
    procedure mnuClosePolygonClick(Sender: TObject);
    procedure mnuLocalRefineClick(Sender: TObject);
    procedure mnuSimpleBoxClick(Sender: TObject);
    procedure mnuOnePointClick(Sender: TObject);
  private
    FGraph: TsdGraph2D;
    FMesh: TsdTriangulationMesh2D;
    FAddPoly: boolean;
    FLocalRefine: boolean;
    FFirstVertex: TsdVertex2D;
    FPrevVertex: TsdVertex2D;
    FXPos, FYPos: double;
    procedure SetupMesh;
    function AddVertex(X, Y: double): TsdVertex2D;
    procedure AddSegment(V1, V2: TsdVertex2D);
    procedure AddRectangle(X1, Y1, X2, Y2: double);
    procedure AddEllipse(Cx, Cy, Rx, Ry: double; N: integer);
    procedure AddCircle(Cx, Cy, R: double; N: integer);
    procedure MeshExecutionStep(Sender: TObject; const AMessage: string);
    procedure MeshPhaseComplete(Sender: TObject; const AMessage: string);
    procedure MeshStatus(Sender: TObject; const AMessage: string);
    procedure DoRandomPoints(ACount: integer);
    procedure DoCircle(ACount: integer);
    procedure DoEllipse(ACount: integer);
    procedure Clear;
    procedure LoadPSLG(const AFileName: string);
    procedure SavePSLG(const AFileName: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FGraph := TsdGraph2D.Create;
  SetupMesh;
  pnlMain.DoubleBuffered := True;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FGraph);
  FreeAndNil(FMesh);
end;

procedure TfrmMain.SetupMesh;
var
  MC: TsdTriMesh2DClass;
begin
  MC := TsdTriangulationMesh2D;
  if chbDelaunayMesh.Checked then
    MC := TsdDelaunayMesh2D;
  if chbQualityMesh.Checked then
    MC := TsdQualityMesh2D;
  FreeAndNil(FMesh);
  FMesh := TsdTriangulationMesh2D(MC.Create);
  if chbExecutionSteps.Checked then
    FMesh.OnExecutionStep := MeshExecutionStep;
  if chbPhaseSteps.Checked then
    FMesh.OnPhaseComplete := MeshPhaseComplete;
  FMesh.OnStatus := MeshStatus;
  FMesh.Precision := 1E-3;
  pbMain.Invalidate;
end;

procedure TfrmMain.chbDelaunayMeshClick(Sender: TObject);
begin
  SetupMesh;
end;

procedure TfrmMain.chbQualityMeshClick(Sender: TObject);
begin
  SetupMesh;
end;

procedure TfrmMain.edMinAngleExit(Sender: TObject);
begin
  if not (FMesh is TsdQualityMesh2D) then
    ShowMessage('Select quality mesh to set angle');
end;

function TfrmMain.AddVertex(X, Y: double): TsdVertex2D;
begin
  Result := TsdVertex2D.CreateWithCoords(X, Y);
  FGraph.Vertices.Add(Result);
end;

procedure TfrmMain.AddSegment(V1, V2: TsdVertex2D);
begin
  FGraph.Boundaries.Add(TsdBoundary2D.CreateWithVertices(V1, V2))
end;

procedure TfrmMain.AddRectangle(X1, Y1, X2, Y2: double);
var
  P11, P12, P21, P22: TsdVertex2D;
begin
  P11 := AddVertex(X1, Y1);
  P12 := AddVertex(X2, Y1);
  P22 := AddVertex(X2, Y2);
  P21 := AddVertex(X1, Y2);
  AddSegment(P11, P12);
  AddSegment(P12, P22);
  AddSegment(P22, P21);
  AddSegment(P21, P11);
end;

procedure TfrmMain.AddEllipse(Cx, Cy, Rx, Ry: double; N: integer);
var
  i: integer;
  A: double;
  Vertices: array of TsdVertex2D;
begin
  // build vertices
  SetLength(Vertices, N);
  for i := 0 to N - 1 do
  begin
    A := i / N * pi * 2;
    Vertices[i] := AddVertex(Cx + Rx * cos(A), Cy + Ry * sin(A));
  end;
  // build segments
  for i := 0 to N - 1 do
  begin
    AddSegment(Vertices[i], Vertices[(i + 1) mod N]);
  end;
end;

procedure TfrmMain.AddCircle(Cx, Cy, R: double; N: integer);
begin
  AddEllipse(Cx, Cy, R, R, N);
end;

procedure TfrmMain.LoadPSLG(const AFileName: string);
var
  F: TFileStream;
  Data: string;
begin
  Clear;
  F := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  SetLength(Data, F.Size);
  if F.Size > 0 then
  begin
    F.Read(Data[1], F.Size);
    FGraph.ReadFromString(Data);
  end;
  F.Free;
  pbMain.Invalidate;
end;

procedure TfrmMain.SavePSLG(const AFileName: string);
var
  F: TFileStream;
  Data: string;
begin
  FGraph.WriteToString(Data);
  F := TFileStream.Create(AFileName, fmCreate);
  if length(Data) > 0 then
  begin
    F.Write(Data[1], length(Data));
  end;
  F.Free;
end;

procedure TfrmMain.pbMainClick(Sender: TObject);
// locally refine by mouseclick
var
  Vertex: TsdVertex2D;
  QM: TsdQualityMesh2D;
begin
  if FLocalRefine then
  begin
    if not (FMesh is TsdQualityMesh2D) then
      exit;
    QM := TsdQualityMesh2D(FMesh);
    QM.LocalRefine(FXPos, FYPos, StrToFloatDef(edMaxElementSize.Text, 100));
  end;
  if FAddPoly then
  begin
    Vertex := TsdVertex2D.CreateWithCoords(FXPos, FYPos);
    FGraph.Vertices.Add(Vertex);
    if assigned(FPrevVertex) then
      FGraph.Boundaries.Add(TsdBoundary2D.CreateWithVertices(FPrevVertex, Vertex));
    if not assigned(FFirstVertex) then
      FFirstVertex := Vertex;
    FPrevVertex := Vertex;
    mnuClosePolygon.Enabled := True;
  end;
  pbMain.Invalidate;
end;

procedure TfrmMain.pbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    FAddPoly := False;
    mnuAddPolygon.Enabled := True;
    mnuClosePolygon.Enabled := False;
    FPrevVertex := nil;
    FFirstVertex := nil;
  end;
  FXPos := X;
  FYPos := Y;
  pbMain.Invalidate;
end;

procedure TfrmMain.pbMainPaint(Sender: TObject);
var
  i, j: integer;
  P, P1, P2: TsdPoint2D;
  TP: array[0..2] of TsdPoint2D;
  Triangle: TsdTriangle2D;
  C: TsdPoint2D;
  R: double;
  // local
  procedure DrawBlip(X, Y: integer);
  begin
    pbMain.Canvas.MoveTo(X - 1, Y);
    pbMain.Canvas.LineTo(X + 2, Y);
    pbMain.Canvas.MoveTo(X, Y - 1);
    pbMain.Canvas.LineTo(X, Y + 2);
  end;
  // local
  procedure DrawDisk(X, Y: integer);
  begin
    pbMain.Canvas.Ellipse(X - 2, Y - 2, X + 3, Y + 3);
  end;
// main
begin
  pbMain.Canvas.Pen.Color := clBlack;
  pbMain.Canvas.Pen.Style := psSolid;
  pbMain.Canvas.Pen.Width := 2;
  // Paint polygon
  if chbPolygon.Checked then
  begin
    for i := 0 to FGraph.Boundaries.Count - 1 do
    begin
      P1 := FGraph.Boundaries[i].Vertex1.FPoint;
      P2 := FGraph.Boundaries[i].Vertex2.FPoint;
      pbMain.Canvas.MoveTo(round(P1.X), round(P1.Y));
      pbMain.Canvas.LineTo(round(P2.X), round(P2.Y));
    end;
  end;
  // Paint vertices
  pbMain.Canvas.Brush.Color := clBlack;
  pbMain.Canvas.Pen.Style := psClear;
  pbMain.Canvas.Brush.Style := bsSolid;
  if chbVertices.Checked then begin
    for i := 0 to FGraph.Vertices.Count - 1 do
    begin
      P := FGraph.Vertices[i].FPoint;
      DrawDisk(round(P.X), round(P.Y));
    end;
  end;
  // Paint mesh
  pbMain.Canvas.Brush.Style := bsClear;
  pbMain.Canvas.Pen.Style := psSolid;
  pbMain.Canvas.Pen.Width := 1;
  for i := 0 to FMesh.Triangles.Count - 1 do
  begin
    // triangles
    pbMain.Canvas.Pen.Width := 1;
    Triangle := FMesh.Triangles[i];
    TP[0] := Triangle.Vertices[0].FPoint;
    TP[1] := Triangle.Vertices[1].FPoint;
    TP[2] := Triangle.Vertices[2].FPoint;
    for j := 0 to 2 do begin
      if assigned(Triangle.Neighbours[j]) then
        pbMain.Canvas.Pen.Color := clBlack
      else
        pbMain.Canvas.Pen.Color := clLime;
      if assigned(Triangle.Boundaries[j]) and chbSegments.Checked then
        pbMain.Canvas.Pen.Color := clBlue;
      pbMain.Canvas.MoveTo(round(TP[j].X), round(TP[j].Y));
      pbMain.Canvas.LineTo(round(TP[(j + 1) mod 3].X), round(TP[(j + 1) mod 3].Y));
    end;
    // Centers
    if chbCenter.Checked then
    begin
      C := Triangle.Center;
      pbMain.Canvas.Pen.Color := clRed;
      DrawBlip(round(C.X), round(C.Y));
    end;
    // Delaunay circle
    if chbDelaunayCircle.Checked then
    begin
      C := Triangle.CircleCenter;
      R := sqrt(Triangle.SquaredRadius);
      pbMain.Canvas.Pen.Color := clFuchsia;
      pbMain.Canvas.Ellipse(
        round(C.X - R), round(C.Y - R),
        round(C.X + R), round(C.Y + R));
    end;
  end;
end;

procedure TfrmMain.btnTriangulateClick(Sender: TObject);
var
  DM: TsdDelaunayMesh2D;
  QM: TsdQualityMesh2D;
begin
  btnTriangulate.Enabled := False;
  FMesh.Clear;
  try
    FMesh.AddGraph(FGraph);
    // If the mesh has no boundaries, we will add a convex hull
    if FMesh.Boundaries.Count = 0 then
      FMesh.ConvexHull;
    if FMesh is TsdQualityMesh2D then
    begin
      QM := TsdQualityMesh2D(FMesh);
      QM.MinimumAngle := StrToFloatDef(edMinAngle.Text, 20);
      QM.MinimumSegmentLength := 4;
      if chbMaxElementSize.Checked then
        QM.MaximumElementSize := StrToFloatDef(edMaxElementSize.Text, 100)
      else
        QM.MaximumElementSize := 0;
    end;
    FMesh.Triangulate(TsdRemovalStyle(cbbRemoval.ItemIndex));
  except
  end;
  pbMain.Invalidate;
  btnTriangulate.Enabled := True;
  mmInfo.Clear;
  mmInfo.Lines.Add(Format('#vertices : %d', [FMesh.Vertices.Count]));
  mmInfo.Lines.Add(Format('#triangles: %d', [FMesh.Triangles.Count]));
  mmInfo.Lines.Add(Format('precision: %g', [FMesh.Precision]));
  mmInfo.Lines.Add(Format('area(start): %5.1f', [FMesh.AreaInitial]));
  mmInfo.Lines.Add(Format('area(close): %5.1f', [FMesh.SignedArea]));
  mmInfo.Lines.Add(Format('#skipped vtx: %d', [FMesh.VertexSkipCount]));
  mmInfo.Lines.Add(Format('#split body: %d', [FMesh.SplitBodyCount]));
  mmInfo.Lines.Add(Format('#split edge: %d', [FMesh.SplitEdgeCount]));
  mmInfo.Lines.Add(Format('#search steps: %d (%3.1fx)',
    [FMesh.SearchSteps, FMesh.SearchSteps / Max(1, FMesh.Triangles.Count)]));
  mmInfo.Lines.Add(Format('#hit tests: %d (%3.1fx)',
    [FMesh.HitTests, FMesh.HitTests / Max(1, FMesh.Triangles.Count)]));
  if FMesh is TsdDelaunayMesh2D then begin
    DM := TsdDelaunayMesh2D(FMesh);
    mmInfo.Lines.Add(Format('#triangle swaps: %d (%3.1fx)',
      [DM.SwapCount, DM.SwapCount / Max(1, DM.Triangles.Count)]));
    mmInfo.Lines.Add(Format('#circle calcs: %d',
      [DM.CircleCalcCount]));
    mmInfo.Lines.Add(Format('#non-delaunay tr: %d',
      [DM.NonDelaunayTriangleCount]));
  end;
  if FMesh is TsdQualityMesh2D then
  begin
    QM := TsdQualityMesh2D(FMesh);
    mmInfo.Lines.Add(Format('#steiner pts: %d', [QM.SteinerPoints.Count]));
    mmInfo.Lines.Add(Format('#degenerate tr: %d', [QM.DegenerateTriangleCount]));
    mmInfo.Lines.Add(Format('Min angle in mesh: %5.2f', [QM.MinimumAngleInMesh]));
  end;
  mmInfo.Lines.Add(Format('calc time: %5.2fs', [FMesh.CalculationTime]));
end;

procedure TfrmMain.chbExecutionStepsClick(Sender: TObject);
begin
  if chbExecutionSteps.Checked then
    FMesh.OnExecutionStep := MeshExecutionStep
  else
    FMesh.OnExecutionStep := nil;
end;

procedure TfrmMain.chbPhaseStepsClick(Sender: TObject);
begin
  if chbPhaseSteps.Checked then
    FMesh.OnPhaseComplete := MeshPhaseComplete
  else
    FMesh.OnPhaseComplete := nil;
end;

procedure TfrmMain.MeshExecutionStep(Sender: TObject; const AMessage: string);
begin
  sbMain.Panels[0].Text := AMessage;
  btnNext.Enabled := True;
  pbMain.Invalidate;
  repeat
    Application.ProcessMessages;
    Sleep(1);
  until btnNext.Enabled = False;
end;

procedure TfrmMain.MeshPhaseComplete(Sender: TObject; const AMessage: string);
begin
  sbMain.Panels[0].Text := 'Complete: ' + AMessage;
  btnNext.Enabled := True;
  pbMain.Invalidate;
  repeat
    Application.ProcessMessages;
    Sleep(1);
  until btnNext.Enabled = False;
end;

procedure TfrmMain.MeshStatus(Sender: TObject; const AMessage: string);
begin
  sbMain.Panels[1].Text := AMessage;
end;

procedure TfrmMain.btnNextClick(Sender: TObject);
begin
  btnNext.Enabled := False;
end;

procedure TfrmMain.Clear;
begin
  FGraph.Clear;
  FMesh.Clear;
  FAddPoly := False;
  FFirstVertex := nil;
  FPrevVertex := nil;
  mnuAddPolygon.Enabled := True;
  mnuClosePolygon.Enabled := False;
end;

procedure TfrmMain.mnuLoadPSLGClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  begin
    Title := 'Open PSLG';
    Filter := 'text files (*.txt)|*.txt';
    if Execute then
      LoadPSLG(FileName);
    Free;
  end;
end;

procedure TfrmMain.mnuSavePSLGClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
  begin
    Title := 'Save PSLG';
    Filter := 'text files (*.txt)|*.txt';
    if Execute then
      SavePSLG(ChangeFileExt(FileName, '.txt'));
    Free;
  end;
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.chbCenterClick(Sender: TObject);
begin
  pbMain.Invalidate;
end;

procedure TfrmMain.chbDelaunayCircleClick(Sender: TObject);
begin
  pbMain.Invalidate;
end;

procedure TfrmMain.chbPolygonClick(Sender: TObject);
begin
  pbMain.Invalidate;
end;

procedure TfrmMain.chbVerticesClick(Sender: TObject);
begin
  pbMain.Invalidate;
end;

procedure TfrmMain.chbSegmentsClick(Sender: TObject);
begin
  pbMain.Invalidate;
end;

procedure TfrmMain.mnuClearAllClick(Sender: TObject);
begin
  Clear;
  pbMain.Invalidate;
end;

procedure TfrmMain.mnuClearMeshClick(Sender: TObject);
begin
  FMesh.Clear;
  pbMain.Invalidate;
end;

procedure TfrmMain.mnuAddPolygonClick(Sender: TObject);
begin
  FAddPoly := True;
  FLocalRefine := False;
  mnuAddPolygon.Enabled := False;
  mnuClosePolygon.Enabled := True;
end;

procedure TfrmMain.mnuClosePolygonClick(Sender: TObject);
begin
  if FAddPoly and assigned(FFirstVertex) and assigned(FPrevVertex) and
     (FFirstVertex <> FPrevVertex) then
  begin
    FGraph.Boundaries.Add(TsdBoundary2D.CreateWithVertices(FPrevVertex, FFirstVertex));
    FFirstVertex := nil;
    FPrevVertex := nil;
    mnuClosePolygon.Enabled := False;
  end;
  pbMain.Invalidate;
end;

procedure TfrmMain.mnuRandomPointsClick(Sender: TObject);
var
  S: string;
begin
  S := InputBox('Number of points?', 'Number', '100');
  DoRandomPoints(StrToIntDef(S, 100));
end;

procedure TfrmMain.mnuCircleClick(Sender: TObject);
var
  S: string;
begin
  S := InputBox('Number of points?', 'Number', '100');
  DoCircle(StrToIntDef(S, 100));
end;

procedure TfrmMain.mnuEllipseClick(Sender: TObject);
var
  S: string;
begin
  S := InputBox('Number of points?', 'Number', '100');
  DoEllipse(StrToIntDef(S, 100));
end;

procedure TfrmMain.DoRandomPoints(ACount: integer);
var
  i, W, H: integer;
  Vertex: TsdVertex2D;
begin
  Clear;
  W := pbMain.Width div 2;
  H := pbMain.Height div 2;
  // build vertices (we do not use segments)
  for i := 1 to ACount do
  begin
    Vertex := TsdVertex2D.CreateWithCoords(W shr 1 + random * W, H shr 1 + random * H);
    FGraph.Vertices.Add(Vertex);
  end;
  pbMain.Invalidate;
end;

procedure TfrmMain.DoCircle(ACount: integer);
var
  W, H: integer;
begin
  Clear;
  W := pbMain.Width div 2;
  H := pbMain.Height div 2;
  if H > W then H := W else W := H;
  AddCircle(W, H, W * 0.7, ACount);
  pbMain.Invalidate;
end;

procedure TfrmMain.DoEllipse(ACount: integer);
var
  W, H: integer;
begin
  Clear;
  W := pbMain.Width div 2;
  H := pbMain.Height div 2;
  AddEllipse(W, H, W * 0.7, H * 0.7, ACount);
  pbMain.Invalidate;
end;

procedure TfrmMain.mnuBoxClick(Sender: TObject);
var
  S: string;
  W, H: double;
  i, Count, XCount, YCount: integer;
begin
  S := InputBox('Number of points?', 'Number', '100');
  Clear;
  W := pbMain.Width;
  H := pbMain.Height;
  Count := StrToIntDef(S, 100);
  XCount := Count div 4;
  YCount := XCount;
  if XCount > 1 then
    dec(XCount);
  while 2 * XCount + 2 * YCount < Count do
    inc(XCount);
  for i := 0 to XCount do
    AddVertex(W * 0.1 + i / XCount * W * 0.8, H * 0.1);
  for i := 1 to YCount - 1 do
    AddVertex(W * 0.9, H * 0.1 + i / YCount * H * 0.8);
  for i := XCount downto 0 do
    AddVertex(W * 0.1 + i / XCount * W * 0.8, H * 0.9);
  for i := YCount - 1 downto 1 do
    AddVertex(W * 0.1, H * 0.1 + i / YCount * H * 0.8);
  Count := FGraph.Vertices.Count;
  for i := 0 to Count - 1 do
    AddSegment(FGraph.Vertices[i], FGraph.Vertices[(i + 1) mod Count]);
  pbMain.Invalidate;
end;

procedure TfrmMain.mnuSimpleBoxClick(Sender: TObject);
var
  W, H: double;
  i, Count, XCount, YCount: integer;
begin
  Clear;
  W := pbMain.Width;
  H := pbMain.Height;
  Count := 1;
  XCount := Count div 4;
  YCount := XCount;
  if XCount > 1 then
    dec(XCount);
  while 2 * XCount + 2 * YCount < Count do
    inc(XCount);
  for i := 0 to XCount do
    AddVertex(W * 0.1 + i / XCount * W * 0.8, H * 0.1);
  for i := 1 to YCount - 1 do
    AddVertex(W * 0.9, H * 0.1 + i / YCount * H * 0.8);
  for i := XCount downto 0 do
    AddVertex(W * 0.1 + i / XCount * W * 0.8, H * 0.9);
  for i := YCount - 1 downto 1 do
    AddVertex(W * 0.1, H * 0.1 + i / YCount * H * 0.8);
  Count := FGraph.Vertices.Count;
  for i := 0 to Count - 1 do
    AddSegment(FGraph.Vertices[i], FGraph.Vertices[(i + 1) mod Count]);
  pbMain.Invalidate;
end;

procedure TfrmMain.mnuOnePointClick(Sender: TObject);
var
  W, H: integer;
begin
  Clear;
  W := pbMain.Width div 2;
  H := pbMain.Height div 2;
  // build one vertex
  AddVertex(W shr 1, H shr 1);

  // test..
  AddVertex(W shr 1 + 20, H shr 1);
  AddSegment(FGraph.Vertices[0], FGraph.Vertices[1]);

  pbMain.Invalidate;
end;

procedure TfrmMain.mnuPlatewithholesClick(Sender: TObject);
var
  Cx, Cy, W, H, S: double;
begin
  Clear;
  Cx := pbMain.Width / 2;
  Cy := pbMain.Height / 2;
  W := Cx * 0.7;
  H := Cy * 0.7;
  S := Min(W, H);

  // Plate
  AddRectangle(Cx - W, Cy - H, Cx + W, Cy + H);
  // 4 small holes
  AddCircle(Cx - 0.8 * W, Cy - 0.8 * H, 0.1 * S, 10);
  AddCircle(Cx + 0.8 * W, Cy - 0.8 * H, 0.1 * S, 10);
  AddCircle(Cx + 0.8 * W, Cy + 0.8 * H, 0.1 * S, 10);
  AddCircle(Cx - 0.8 * W, Cy + 0.8 * H, 0.1 * S, 10);
  // bigger inner hole
  AddCircle(Cx, Cy, 0.3 * S, 20);
  pbMain.Invalidate;
end;

procedure TfrmMain.mnuIntersectionClick(Sender: TObject);
var
  Cx, Cy, W, H: double;
begin
  Clear;
  Cx := pbMain.Width / 2;
  Cy := pbMain.Height / 2;
  W := Cx * 0.7;
  H := Cy * 0.7;

  // two intersecting rectangles
  AddRectangle(Cx - W, Cy - H, Cx + W/2, Cy + H/3);
  AddRectangle(Cx - W/2, Cy - H/3, Cx + W, Cy + H);
  pbMain.Invalidate;
end;

procedure TfrmMain.tmAutoTimer(Sender: TObject);
begin
  btnNext.Click;
end;

procedure TfrmMain.btnAutoClick(Sender: TObject);
begin
  if tmAuto.Enabled then begin
    btnAuto.Caption := 'Auto >>';
  end else begin
    btnAuto.Caption := 'Stop >>';
  end;
  tmAuto.Enabled := not tmAuto.Enabled;
end;

procedure TfrmMain.mnuLocalRefineClick(Sender: TObject);
begin
  FLocalRefine := True;
  FAddPoly := False;
end;

end.

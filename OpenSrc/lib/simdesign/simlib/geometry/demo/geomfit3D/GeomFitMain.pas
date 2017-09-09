unit GeomFitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, ComCtrls, sdPoints3D, GLScene, GLObjects,
  GLGeomObjects, GLMisc, GLWin32Viewer, ExtCtrls, GlTexture, StdCtrls, Math,
  sdGeomFit3D, sdMatrices, sdP3DFormat, sdCSVFormat, sdDebug;

type
  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    File1: TMenuItem;
    acLoadPointcloud: TAction;
    LoadPointcloud1: TMenuItem;
    acExit: TAction;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Geometry1: TMenuItem;
    mnuFittogeometricalobject: TMenuItem;
    acGeomFitCone: TAction;
    FittoCone1: TMenuItem;
    pnlRight: TPanel;
    Splitter1: TSplitter;
    pnlCenter: TPanel;
    GLScene1: TGLScene;
    GLSceneViewer: TGLSceneViewer;
    GLCamera: TGLCamera;
    dcMain: TGLDummyCube;
    GLPointCloud: TGLPoints;
    GLLightSource1: TGLLightSource;
    GLCone: TGLCone;
    est1: TMenuItem;
    GLSphere: TGLSphere;
    mnuRandomconepoints: TMenuItem;
    mnuRandomspherepoints: TMenuItem;
    acGeomFitSphere: TAction;
    FittoSphere1: TMenuItem;
    mnuClearAll: TMenuItem;
    mnuEvenlydistributedspherepoints: TMenuItem;
    pnlTop: TPanel;
    pnlBtm: TPanel;
    lbZoom: TLabel;
    tbZoom: TTrackBar;
    mmDebug: TMemo;
    procedure acLoadPointcloudExecute(Sender: TObject);
    procedure GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure tbZoomChange(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acGeomFitConeExecute(Sender: TObject);
    procedure mnuRandomconepointsClick(Sender: TObject);
    procedure mnuRandomspherepointsClick(Sender: TObject);
    procedure acGeomFitSphereExecute(Sender: TObject);
    procedure mnuClearAllClick(Sender: TObject);
    procedure mnuEvenlydistributedspherepointsClick(Sender: TObject);
  private
    FMx, FMy: integer;
    FHasCone: boolean;
    FHasSphere: boolean;
    FConeInfo: TsdConeInfo;
    FSphereInfo: TsdSphereInfo;
    procedure UpdateGlObjects;
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
  public
    FPoints: array of TsdPoint3D;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.acLoadPointcloudExecute(Sender: TObject);
var
  Ext: string;
  P3D: TsdP3DFormat;
  CSV: TsdCSVFormat;
  Count: integer;
begin
  with TOpenDialog.Create(nil) do
  try
    Title := 'open pointcloud file';
    Filter := 'CSV files (*.csv)|*.csv|P3D files (*.p3d)|*.p3d';
    if Execute then
    begin
      Ext := LowerCase(ExtractFileExt(FileName));
        
      // P3D format
      if Ext = '.p3d' then
      begin
        P3D := TsdP3DFormat.Create;
        try
          Count := P3D.LoadVerticesFromFile(FileName);
          SetLength(FPoints, Count);
          P3D.CopyVertices(@FPoints[0], Count);
          P3D.Clear;
        finally
          P3D.Free;
        end;
      end;

      // CSV format
      if Ext = '.csv' then
      begin
        CSV := TsdCSVFormat.Create;
        try
          Count := CSV.LoadVerticesFromFile(FileName);
          SetLength(FPoints, Count);
          CSV.CopyVertices(@FPoints[0], Count);
          CSV.Clear;
        finally
          CSV.Free;
        end;
      end;
        
      UpdateGlObjects;
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.UpdateGlObjects;
var
  i: integer;
  P: PsdPoint3D;
  Tip: TsdPoint3D;
begin
  // Pointcloud
  GlPointcloud.Positions.Clear;
  if length(FPoints) > 0 then
  begin
    P := @FPoints[0];
    for i := 0 to length(FPoints) - 1 do
    begin
      GlPointcloud.Positions.Add(P.X, P.Y, P.Z);
      inc(P);
    end;
    GlPointcloud.Colors.Clear;
    GlPointcloud.Colors.Add(clrYellow);
  end;
  GlPointcloud.StructureChanged;

  // Cone
  if FHasCone then
  begin
    GlCone.Height := FConeInfo.Height;
    AddScalePoint3D(FConeInfo.Tip, Tip, FConeInfo.Axis, FConeInfo.Height/2);
    GlCone.Position.SetPoint(Tip.X, Tip.Y, Tip.Z);
    GlCone.BottomRadius := FConeInfo.Height * tan(FConeInfo.TopAngle);
    GlCone.Up.SetVector(-FConeInfo.Axis.X, -FConeInfo.Axis.Y, -FConeInfo.Axis.Z);
    GlCone.Parts := [coSides, coBottom];
//    GLCone.VisibilityCulling := vcNone;
    GlCone.Visible := True;
  end else
    GlCone.Visible := False;

  // Sphere
  if FHasSphere then
  begin
    GlSphere.Radius := FSphereInfo.Radius;
    with FSphereInfo.Center do
      GlSphere.Position.SetPoint(X, Y, Z);
    GlSphere.Visible := True;
  end else
    GlSphere.Visible := False;
end;

procedure TfrmMain.GLSceneViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMx := x;
  FMy := y;
end;

procedure TfrmMain.GLSceneViewerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
  begin
    GLCamera.MoveAroundTarget(FMy - y, FMx - x);
    FMx := x;
    FMy := y;
  end;
end;

procedure TfrmMain.tbZoomChange(Sender: TObject);
begin
  GLCamera.SceneScale :=  Power(10, (tbZoom.Position / 100));
  lbZoom.Caption := Format('Zoom %d%%', [round(GLCamera.SceneScale * 100)]);
end;

procedure TfrmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.acGeomFitConeExecute(Sender: TObject);
var
  Fit: TsdShapeFit3D;
  Shape: TsdGeomCone;
  Xparam: TsdVector;
  First: boolean;
  AllowedError: double;
begin
  Fit := TsdShapeFit3D.Create(Self);
  Fit.OnDebugOut := DoDebugOut;
  Shape := TsdGeomCone.Create;
  Xparam := TsdVector.Create;
  try
    // allowed error
    AllowedError := 0.1;
    DoDebugOut(Self, wsInfo, Format('shape = %s, allowed error = %f',
      [Shape.ClassName, AllowedError]));

    // Repeat until we find a good match
    First := True;
    repeat
      // Random startpoint for X-rotation and Y-rotation
      if First then
      begin
        Shape.TopAngle := -10 * pi/180;
        First := False;
      end else
      begin
        Shape.Xrot := random * pi - pi/2;
        Shape.Yrot := random * pi - pi/2;
        Shape.TopAngle := random * pi - pi/2;
      end;
      Fit.FitToPointcloud(@FPoints[0], length(FPoints), Shape, Xparam, AllowedError);

    until Fit.Error <= AllowedError;

    Shape.ConeInfoFromShapeParams(Xparam, FConeInfo);
    FHasCone := True;
    UpdateGlObjects;
  finally
    Xparam.Free;
    Shape.Free;
    Fit.Free;
  end;
end;

procedure TfrmMain.acGeomFitSphereExecute(Sender: TObject);
var
  Fit: TsdShapeFit3D;
  Shape: TsdGeomSphere;
  Xparam: TsdVector;
begin
  Fit := TsdShapeFit3D.Create(Self);
  Fit.OnDebugOut := DoDebugOut;
  Shape := TsdGeomSphere.Create;
  Xparam := TsdVector.Create;
  try
    Fit.FitToPointcloud(@FPoints[0], length(FPoints), Shape, Xparam, 1E-4);
    Shape.SphereInfoFromShapeParams(Xparam, FSphereInfo);
    FHasSphere := True;
    UpdateGlObjects;
  finally
    Xparam.Free;
    Shape.Free;
    Fit.Free;
  end;
end;

procedure TfrmMain.mnuRandomconepointsClick(Sender: TObject);
var
  i: integer;
  Angle, Dir, Height: double;
  T: TsdMatrix3x4;
begin
  SetLength(FPoints, 10000);

  // choose cone angle
  Angle := (10 + random * 70) * pi / 180; // between 10 and 80 deg
  for i := 0 to length(FPoints) - 1 do
  begin
    Dir := 2 * pi * random;
    Height := -5 * sqrt(random);
    FPoints[i].X := sin(Dir) * Height * tan(Angle) + Random * 0.1;
    FPoints[i].Y := cos(Dir) * Height * tan(Angle) + Random * 0.1;
    FPoints[i].Z := Height + Random * 0.1;
  end;

  // Free rotation and translation
  PoseToTransformMatrix(random * 3, random * 3, random * 3 - 4,
    random * pi - pi/2, random * pi - pi/2, random * pi - pi/2, T);
  TransformPoints(@FPoints[0], @FPoints[0], length(FPoints), T);

  UpdateGlObjects;
end;

procedure TfrmMain.mnuRandomspherepointsClick(Sender: TObject);
var
  i: integer;
  X, Y, Z, R2, M, Radius: double;
  T: TsdMatrix3x4;
begin
  SetLength(FPoints, 10000);

  // choose radius
  Radius := 5 + random(5); // between 5 and 10
  i := 0;
  while i < length(FPoints) do
  begin
    X := -1 + 2 * random;
    Y := -1 + 2 * random;
    Z := -1 + 2 * random;
    R2 := sqr(X) + sqr(Y) + sqr(Z);
    if (R2 > 1) or (R2 = 0) then
      continue;
    M := Radius/sqrt(R2);
    FPoints[i].X := X * M + Random * 0.1;
    FPoints[i].Y := Y * M + Random * 0.1;
    FPoints[i].Z := Z * M + Random * 0.1;
    inc(i);
  end;

  // Free rotation and translation
  PoseToTransformMatrix(random * 8 - 4, random * 8 - 4, random * 8 - 4,
    random * pi - pi/2, random * pi - pi/2, random * pi - pi/2, T);
  TransformPoints(@FPoints[0], @FPoints[0], length(FPoints), T);

  UpdateGlObjects;
end;

procedure TfrmMain.mnuClearAllClick(Sender: TObject);
begin
  SetLength(FPoints, 0);
  FHasCone := False;
  FHasSphere := False;
  UpdateGlObjects;
  mmDebug.Lines.Clear;
end;

procedure TfrmMain.mnuEvenlydistributedspherepointsClick(Sender: TObject);
var
  i, j, N, M: integer;
  Alpha, Beta, X, Y, Z, R, Radius: double;
  Count: integer;
  T: TsdMatrix3x4;
  //local
  procedure AddPoint(X, Y, Z: double);
  begin
    if length(FPoints) <= Count then
      SetLength(FPoints, round(length(FPoints) * 1.5) + 100);
    FPoints[Count].X := X * Radius;
    FPoints[Count].Y := Y * Radius;
    FPoints[Count].Z := Z * Radius;
    inc(Count);
  end;
// main
begin
  Count := 0;
  // choose radius
  Radius := 5 + random(5); // between 5 and 10
  N := StrToIntDef(InputBox('Number of parts (N >= 1)', 'N = ', '1'), 0);
  if N < 1 then
    exit;

  // subdivision angle
  Beta := 0.5 * pi / N;
  // line segment length
  //A := 2 * sin(beta/2);

  // endcap
  AddPoint(0, 0, 1);
  AddPoint(0, 0, -1);

  // rings
  for i := 1 to N do
  begin
    R := sin(i * beta);
    Z := cos(i * beta);
    M := round(R * 2 * pi / Beta);
    for j := 0 to M - 1 do
    begin
      Alpha := j/M * 2 * pi;
      X := cos(Alpha) * R;
      Y := sin(Alpha) * R;
      AddPoint(X, Y, Z);
      if i <> N then
        AddPoint(X, Y, -Z);
    end;
  end;
  SetLength(FPoints, Count);

  // Free rotation and translation
  PoseToTransformMatrix(random * 8 - 4, random * 8 - 4, random * 8 - 4,
    random * pi - pi/2, random * pi - pi/2, random * pi - pi/2, T);
  TransformPoints(@FPoints[0], @FPoints[0], length(FPoints), T);

  UpdateGlObjects;
end;

procedure TfrmMain.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  mmDebug.Lines.Add(Format('[%s] %s: %s',
    [cWarnStyleNames[WarnStyle], Sender.ClassName, AMessage]));
end;

initialization
  randomize;

end.

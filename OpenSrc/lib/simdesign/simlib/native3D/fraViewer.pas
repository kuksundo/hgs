unit fraViewer;
{
   Viewer frame for Scene3D object. It uses GlScene (TGLSceneViewer) underneath
   to display the 3D objects.

   Usage: Drop this frame onto your form, and set the Scene3D property in
   FormCreate to your TsdScene3D object.
   
   original author: Nils Haeck M.Sc.
   Copyright (c) 2007 - 2008 SimDesign BV
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLScene, GLMisc, GLObjects, GLWin32Viewer, sdScene3D, Math,
  GLMesh, sdSpaceballInput;

type

  TfrViewer = class(TFrame)
    GLViewer: TGLSceneViewer;
    GLScene: TGLScene;
    GLDummyCube: TGLDummyCube;
    GLLightSource: TGLLightSource;
    GLCamera: TGLCamera;
    procedure GLViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLViewerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GLViewerInput3D(Sender: TObject; const AInput: TsdTDxInput);
  private
    { Private declarations }
    FScene: TsdScene3D;
    FOldMouseX, FOldMouseY: integer;
    procedure SetScene(const Value: TsdScene3D);
  public
    { Public declarations }
    property Scene: TsdScene3D read FScene write SetScene;
  end;

implementation

{$R *.dfm}

procedure TfrViewer.GLViewerInput3D(Sender: TObject; const AInput: TsdTDxInput);
const
  cLenFactor: double = 1e-5;
  cAngFactor: double = 1e-1;
var
  RxVal, RzVal: double;
  TxVal, TyVal, TzVal: double;
  Scale: double;
begin
{  // move around target
  RxVal := -AInput.Ry * AInput.Angle * cAngFactor;
  RzVal := -AInput.Rz * AInput.Angle * cAngFactor;
  GLCamera.MoveAroundTarget(RxVal, RzVal);
  // dummy cube scale
  TzVal := -AInput.Tz * AInput.Length * cLenFactor;
  Scale := Power(10, TzVal);
  GlDummyCube.Scale.X := GlDummyCube.Scale.X * Scale;
  GlDummyCube.Scale.Y := GlDummyCube.Scale.Y * Scale;
  GlDummyCube.Scale.Z := GlDummyCube.Scale.Z * Scale;}
  //GLCamera.MoveInEyeSpace(forwardDistance, rightDistance, upDistance);
  TxVal := -AInput.Tx * AInput.Length * cLenFactor;
  TyVal := -AInput.Ty * AInput.Length * cLenFactor;
  TzVal := -AInput.Tz * AInput.Length * cLenFactor;
  GLCamera.MoveInEyeSpace(TyVal, TzVal, TxVal);
  Scale := 1.0;
  GlDummyCube.Scale.X := GlDummyCube.Scale.X * Scale;
end;

procedure TfrViewer.GLViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FOldMouseX := X;
  FOldMouseY := Y;
end;

procedure TfrViewer.GLViewerMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Scale: double;
begin
  if ssLeft in Shift then
  begin
    if ssCtrl in Shift then
    begin

    end else
    begin
      GLCamera.MoveAroundTarget(FOldMouseY - Y, FOldMouseX - X);
      FOldMouseX := X;
      FOldMouseY := Y;
    end;
  end else if ssRight in Shift then
  begin
    Scale := Power(10, (FOldMouseY - Y) / 200);
    GlDummyCube.Scale.X := GlDummyCube.Scale.X * Scale;
    GlDummyCube.Scale.Y := GlDummyCube.Scale.Y * Scale;
    GlDummyCube.Scale.Z := GlDummyCube.Scale.Z * Scale;
    FOldMouseX := x;
    FOldMouseY := y;
  end;
end;

procedure TfrViewer.SetScene(const Value: TsdScene3D);
begin
  FScene := Value;
  if assigned(FScene) then
    FScene.GLRoot := GLDummyCube;
end;

end.

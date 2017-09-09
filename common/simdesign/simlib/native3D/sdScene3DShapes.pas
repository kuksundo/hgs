{ sdScene3DShapes

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdScene3DShapes;

interface

uses
  sdScene3D, GLScene;

type

  TsdScene3DSphere = class(TsdScene3DItem)
  private
    FRadius: double;
  protected
    procedure BuildGLSceneObject(AGLParent: TGLBaseSceneObject); override;
  public
    property Radius: double read FRadius write FRadius;
  end;

  TsdScene3DCube = class(TsdScene3DItem)
  private
    FHeight: double;
    FDepth: double;
    FWidth: double;
  protected
    procedure BuildGLSceneObject(AGLParent: TGLBaseSceneObject); override;
  public
    property Width: double read FWidth write FWidth;
    property Height: double read FHeight write FHeight;
    property Depth: double read FDepth write FDepth;
  end;

implementation

uses
  GLObjects;

{ TsdScene3DSphere }

procedure TsdScene3DSphere.BuildGLSceneObject(AGLParent: TGLBaseSceneObject);
var
  GS: TGLSphere;
begin
  GLObject := TGLSphere.Create(AGLParent);
  AGLParent.AddChild(GLObject);
  GS := TGLSphere(GLObject);
  GS.Radius := FRadius;
end;

{ TsdScene3DCube }

procedure TsdScene3DCube.BuildGLSceneObject(AGLParent: TGLBaseSceneObject);
var
  GC: TGLCube;
begin
  GLObject := TGLCube.Create(AGLParent);
  AGLParent.AddChild(GLObject);
  GC := TGLCube(GLObject);
  GC.CubeWidth := FWidth;
  GC.CubeHeight := FHeight;
  GC.CubeDepth := FDepth;
end;

end.

program TestTriang3D;

uses
  Forms,
  TestTriang3DMain in 'TestTriang3DMain.pas' {Form1},
  sdTriMesh3D in '..\sdTriMesh3D.pas',
  sdPoints3D in '..\sdPoints3D.pas',
  sdConvexHull3D in '..\sdConvexHull3D.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

program TestTriang2D;

uses
  Forms,
  TestTriang2DMain in 'TestTriang2DMain.pas' {frmMain},
  sdTriangulate2D in '..\..\sdTriangulate2D.pas',
  sdTriMesh2D in '..\..\sdTriMesh2D.pas',
  sdPoints2D in '..\..\sdPoints2D.pas',
  sdSortedLists in '..\..\..\general\sdSortedLists.pas',
  sdConvexHull2D in '..\..\sdConvexHull2D.pas',
  sdDelaunay2D in '..\..\sdDelaunay2D.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

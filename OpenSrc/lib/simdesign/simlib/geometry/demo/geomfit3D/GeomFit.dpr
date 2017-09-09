program GeomFit;

uses
  Forms,
  GeomFitMain in 'GeomFitMain.pas' {frmMain},
  sdGeomFit3D in '..\..\sdGeomFit3D.pas',
  sdPoints3D in '..\..\sdPoints3D.pas',
  sdMatrices in '..\..\sdMatrices.pas',
  sdP3DFormat in '..\..\..\formats3D\simple\sdP3DFormat.pas',
  sdDebug in '..\..\..\general\sdDebug.pas',
  sdCSVFormat in '..\..\..\formats3D\simple\sdCSVFormat.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

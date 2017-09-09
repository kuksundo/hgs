program LprDemo;

uses
  Forms,
  frmMain in 'frmMain.pas' {fmMain},
  sdOcr in '..\..\..\..\simlib\detection\sdOcr.pas',
  sdMatrices in '..\..\..\..\simlib\geometry\sdMatrices.pas',
  sdSimplifyPolylineDouglasPeucker in '..\..\..\..\simlib\geometry\sdSimplifyPolylineDouglasPeucker.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.

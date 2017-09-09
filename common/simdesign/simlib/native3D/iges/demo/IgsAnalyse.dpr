program IgsAnalyse;

uses
  Forms,
  IgsMain in 'IgsMain.pas' {frmMain},
  fraViewer in '..\..\fraViewer.pas' {frViewer: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

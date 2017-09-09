program LargeTextViewer;

uses
  Forms,
  w_LargeTextViewer in 'w_LargeTextViewer.pas' {f_LargeTextViewer},
  u_TextFileIndexer in 'u_TextFileIndexer.pas',
  u_Int64List in 'u_Int64List.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tf_LargeTextViewer, f_LargeTextViewer);
  Application.Run;
end.

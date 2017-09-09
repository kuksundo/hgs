program TestTriangND;

uses
  FastMM,
  Forms,
  TestTriangNDMain in 'TestTriangNDMain.pas' {Form1},
  sdTriangulateND in '..\sdTriangulateND.pas',
  sdHelperND in '..\sdHelperND.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

program BezierSplit;

uses
  Forms,
  BezierMain in 'BezierMain.pas' {Form1},
  sdBeziers in '..\..\sdBeziers.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

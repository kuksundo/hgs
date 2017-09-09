program DouglasPeucker;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  sdSimplifyPolylineDouglasPeucker in '..\..\sdSimplifyPolylineDouglasPeucker.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

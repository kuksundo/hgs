program ShapeFileReader;

uses
  Forms,
  w_ShapeFileReader in 'w_ShapeFileReader.pas' {f_ShapeFileReader},
  u_dzShapeFileReader in '..\..\..\src\u_dzShapeFileReader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tf_ShapeFileReader, f_ShapeFileReader);
  Application.Run;
end.

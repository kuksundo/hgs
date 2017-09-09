program ShapeFileWriter;

uses
  Forms,
  w_ShapeFileWriter in 'w_ShapeFileWriter.pas' {f_ShapeFileWriter},
  u_dzShapeFileWriter in '..\..\..\src\u_dzShapeFileWriter.pas',
  u_dzShapeFileConsts in '..\..\..\src\u_dzShapeFileConsts.pas',
  u_dzShapeFileReader in '..\..\..\src\u_dzShapeFileReader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tf_ShapeFileWriter, f_ShapeFileWriter);
  Application.Run;
end.

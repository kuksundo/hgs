program DxfAnalyse;

uses
  Forms,
  DxfMain in 'DxfMain.pas' {Form1},
  sdDxfFormat in '..\..\dxf\sdDxfFormat.pas',
  sdPoints3D in '..\..\..\geometry\sdPoints3D.pas',
  sdPoints2D in '..\..\..\geometry\sdPoints2D.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

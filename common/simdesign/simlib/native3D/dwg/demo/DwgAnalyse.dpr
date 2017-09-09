program DwgAnalyse;

uses
  Forms,
  DwgMain in 'DwgMain.pas' {Form1},
  sdDwgFormat in '..\sdDwgFormat.pas',
  sdDwgTypesAndConsts in '..\sdDwgTypesAndConsts.pas',
  sdDwgBitReader in '..\sdDwgBitReader.pas',
  sdDwgHeaderVars in '..\sdDwgHeaderVars.pas',
  sdDwgItems in '..\sdDwgItems.pas',
  sdDwgProperties in '..\sdDwgProperties.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

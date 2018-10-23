program GSFileOpen;

uses
  Vcl.Forms,
  FrmFileOpen in 'FrmFileOpen.pas' {Form7},
  GpCommandLineParser in '..\..\..\common\GpDelphiUnit\src\GpCommandLineParser.pas',
  UnitGSFileOpenConfigOptionClass in 'UnitGSFileOpenConfigOptionClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.

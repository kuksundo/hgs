program TestReg;

uses
  Forms,
  uTestReg in 'uTestReg.pas' {Form1},
  uODDskInfo in '..\Testout\diskinfo\uODDskInfo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

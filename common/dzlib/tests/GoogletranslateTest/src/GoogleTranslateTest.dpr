program GoogleTranslateTest;

uses
  Forms,
  w_GoogleTranslateTest in 'w_GoogleTranslateTest.pas' {Form1},
  u_dzGoogleTranslate in '..\..\..\src\u_dzGoogleTranslate.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

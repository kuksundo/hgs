program dzMultiProgressTest;

uses
  Forms,
  w_dzMultiProgressTest in 'w_dzMultiProgressTest.pas' {f_dzProgressTest},
  w_dzMultiProgress in '..\..\..\forms\w_dzMultiProgress.pas' {f_dzMultiProgress},
  w_dzDialog in '..\..\..\forms\w_dzDialog.pas' {f_dzDialog},
  u_dzWmMessageToString in '..\..\..\src\u_dzWmMessageToString.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tf_dzProgressTest, f_dzProgressTest);
  Application.Run;
end.

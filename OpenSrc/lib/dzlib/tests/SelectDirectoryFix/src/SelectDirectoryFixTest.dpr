program SelectDirectoryFixTest;

uses
  Forms,
  w_SelectDirectoryFixTest in 'w_SelectDirectoryFixTest.pas' {Form1},
  u_dzSelectDirectoryFix in '..\..\..\src\u_dzSelectDirectoryFix.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

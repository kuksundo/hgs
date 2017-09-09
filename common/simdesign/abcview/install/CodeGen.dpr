program CodeGen;

uses
  Forms,
  CodeGenMain in 'CodeGenMain.pas' {Form1},
  RegCodes in 'RegCodes.pas',
  Encrypt in 'encrypt.pas',
  Registrations in 'Registrations.pas' {RegDialog};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TRegDialog, RegDialog);
  Application.Run;
end.

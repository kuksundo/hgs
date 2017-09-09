program MathApp;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form3},
  MathClass in 'MathClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

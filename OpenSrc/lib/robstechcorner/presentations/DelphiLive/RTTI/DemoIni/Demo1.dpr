program Demo1;

uses
  Forms,
  Demo1Form in 'Demo1Form.pas' {Form3},
  INIPersistent in 'INIPersistent.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

program Demo1;

uses
  Forms,
  uDemo1 in 'uDemo1.pas' {Form3},
  DetailedRTTI in 'DetailedRTTI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

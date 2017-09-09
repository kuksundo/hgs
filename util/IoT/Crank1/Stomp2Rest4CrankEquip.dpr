program Stomp2Rest4CrankEquip;

uses
  Vcl.Forms,
  UnitSTOMP2Rest4CrankEquip in 'UnitSTOMP2Rest4CrankEquip.pas' {Form8},
  UnitMQConfig in 'UnitMQConfig.pas' {ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

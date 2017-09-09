program MQTT2Stomp;

uses
  Vcl.Forms,
  UnitMQTT2STOMPTemplate in 'UnitMQTT2STOMPTemplate.pas' {Form8},
  UnitMQConfig in 'UnitMQConfig.pas' {ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

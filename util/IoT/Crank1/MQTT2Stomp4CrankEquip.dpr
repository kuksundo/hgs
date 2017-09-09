program MQTT2Stomp4CrankEquip;

uses
  Vcl.Forms,
  UnitMQTT2STOMPCrankEquip in 'UnitMQTT2STOMPCrankEquip.pas' {Form8},
  UnitEquipStatusClass in 'Common\UnitEquipStatusClass.pas',
  UnitMQTT2STOMPConfig in 'UnitMQTT2STOMPConfig.pas' {ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

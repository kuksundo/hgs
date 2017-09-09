program MQTT4EquipMonitor;

uses
  Vcl.Forms,
  UnitMQTT4EquipMonitor in 'Monitor\UnitMQTT4EquipMonitor.pas' {Form9},
  UnitNotifyScheduleClass in '..\..\..\common\UnitNotifyScheduleClass.pas',
  UnitMQTTClientConfig in '..\..\MQ\Common\UnitMQTTClientConfig.pas' {ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm9, Form9);
  Application.Run;
end.

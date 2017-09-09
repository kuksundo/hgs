program MQTT4EquipMonitor2;

uses
  Vcl.Forms,
  UnitMQTT4EquipMonitor2 in 'Monitor\UnitMQTT4EquipMonitor2.pas' {Form9},
  UnitNotifyScheduleClass in '..\..\..\common\UnitNotifyScheduleClass.pas',
  UnitMQTTClientConfig in '..\..\MQ\Common\UnitMQTTClientConfig.pas' {ConfigF},
  UnitCodeSiteUtil in '..\..\..\common\UnitCodeSiteUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm9, Form9);
  Application.Run;
end.

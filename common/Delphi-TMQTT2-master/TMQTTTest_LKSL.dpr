program TMQTTTest_LKSL;

uses
  Forms,
  uMain_LKSL in 'uMain_LKSL.pas' {fMain},
  MQTT in 'TMQTT\MQTT.pas',
  MQTTHeaders in 'TMQTT\MQTTHeaders.pas',
  MQTTReadThread in 'TMQTT\MQTTReadThread.pas',
  UnitCodeSiteUtil in '..\UnitCodeSiteUtil.pas',
  UnitMQTTMsg.Events in '..\LKSLEventUnits\UnitMQTTMsg.Events.pas',
  UnitMQTTMsg.EventThreads in '..\LKSLEventUnits\UnitMQTTMsg.EventThreads.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.

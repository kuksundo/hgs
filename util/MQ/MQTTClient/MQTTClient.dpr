program MQTTClient;

uses
  Vcl.Forms,
  UnitMainMQTTClient in 'UnitMainMQTTClient.pas' {MQTTClientF},
  UnitStrMsg.Events in '..\..\..\common\UnitStrMsg.Events.pas',
  UnitStrMsg.EventThreads in '..\..\..\common\UnitStrMsg.EventThreads.pas',
  UnitFrameMQTTClient in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameMQTTClient.pas' {FrameMQTTClient: TFrame},
  MQTT in '..\..\..\common\Delphi-TMQTT2-master\TMQTT\MQTT.pas',
  MQTTHeaders in '..\..\..\common\Delphi-TMQTT2-master\TMQTT\MQTTHeaders.pas',
  MQTTReadThread in '..\..\..\common\Delphi-TMQTT2-master\TMQTT\MQTTReadThread.pas',
  IniPersist in '..\..\..\common\robstechcorner\rtti\IniPersist.pas',
  UnitConfigIniClass in '..\..\..\common\UnitConfigIniClass.pas',
  UnitMQTTClientConfig in '..\Common\UnitMQTTClientConfig.pas' {ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMQTTClientF, MQTTClientF);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

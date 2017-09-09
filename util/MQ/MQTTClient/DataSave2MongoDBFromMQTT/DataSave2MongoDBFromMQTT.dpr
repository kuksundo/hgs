program DataSave2MongoDBFromMQTT;

uses
  Vcl.Forms,
  UnitMainDataSave2MongoDBFromMQTT in 'UnitMainDataSave2MongoDBFromMQTT.pas' {MQTTClientF},
  UnitFrameMQTTClient in '..\..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameMQTTClient.pas' {FrameMQTTClient: TFrame},
  MQTT in '..\..\..\..\common\Delphi-TMQTT2-master\TMQTT\MQTT.pas',
  MQTTHeaders in '..\..\..\..\common\Delphi-TMQTT2-master\TMQTT\MQTTHeaders.pas',
  MQTTReadThread in '..\..\..\..\common\Delphi-TMQTT2-master\TMQTT\MQTTReadThread.pas',
  IniPersist in '..\..\..\..\common\robstechcorner\rtti\IniPersist.pas',
  UnitConfigIniClass in '..\..\..\..\common\UnitConfigIniClass.pas',
  UnitMQTTClientConfig in '..\..\Common\UnitMQTTClientConfig.pas' {ConfigF},
  UnitSaveData2MongoDB.EventThreads in '..\..\..\..\common\LKSLEventUnits\UnitSaveData2MongoDB.EventThreads.pas',
  UnitSaveData2MongoDB.Events in '..\..\..\..\common\LKSLEventUnits\UnitSaveData2MongoDB.Events.pas',
  UnitStrMsg.Events in '..\..\..\..\common\LKSLEventUnits\UnitStrMsg.Events.pas',
  UnitStrMsg.EventThreads in '..\..\..\..\common\LKSLEventUnits\UnitStrMsg.EventThreads.pas',
  UnitMQTTClass in '..\..\..\..\common\UnitMQTTClass.pas',
  UnitWorker4OmniMsgQ in '..\..\..\..\common\UnitWorker4OmniMsgQ.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMQTTClientF, MQTTClientF);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

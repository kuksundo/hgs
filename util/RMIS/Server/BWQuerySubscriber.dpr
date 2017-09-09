program BWQuerySubscriber;

uses
  Vcl.Forms,
  UnitMainBWQuerySubscriber in 'UnitMainBWQuerySubscriber.pas' {MainForm},
  BW_Query_Data_Class in '..\Common\BW_Query_Data_Class.pas',
  UnitFrameIPCMonitorRMIS in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameIPCMonitorRMIS.pas' {FrameIPCMonitor4RMIS: TFrame},
  UnitDM in 'UnitDM.pas' {DM1: TDataModule},
  StompClient in '..\..\..\common\delphistompclient-master\StompClient.pas',
  StompTypes in '..\..\..\common\delphistompclient-master\StompTypes.pas',
  UnitSTOMPClass in '..\..\..\common\UnitSTOMPClass.pas',
  UnitWorker4OmniMsgQ in '..\..\..\common\UnitWorker4OmniMsgQ.pas',
  GpCommandLineParser in '..\..\..\common\GpDelphiUnit\GpCommandLineParser.pas',
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  UnitMQTTMsg.Events in '..\..\..\common\LKSLEventUnits\UnitMQTTMsg.Events.pas',
  UnitMQTTMsg.EventThreads in '..\..\..\common\LKSLEventUnits\UnitMQTTMsg.EventThreads.pas',
  UnitSTOMPMsg.Events in '..\..\..\common\LKSLEventUnits\UnitSTOMPMsg.Events.pas',
  UnitSTOMPMsg.EventThreads in '..\..\..\common\LKSLEventUnits\UnitSTOMPMsg.EventThreads.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

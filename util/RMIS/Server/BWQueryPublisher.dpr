program BWQueryPublisher;

uses
  Vcl.Forms,
  UnitMainBWQueryPublisher in 'UnitMainBWQueryPublisher.pas' {BWQueryPublisherF},
  UnitBWQueryInterface in '..\Common\UnitBWQueryInterface.pas',
  Sea_Ocean_News_Class in '..\Common\Sea_Ocean_News_Class.pas',
  RMISConst in '..\Common\RMISConst.pas',
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  BW_Query_Class in '..\Common\BW_Query_Class.pas',
  BaseConfigCollect in '..\..\HiMECS\Application\Source\Common\BaseConfigCollect.pas',
  AsyncCalls in '..\..\..\common\AsyncCalls.pas',
  AsyncCallsHelper in '..\..\..\common\AsyncCallsHelper.pas',
  UnitEncrypt in '..\..\..\common\UnitEncrypt.pas',
  JvgXMLSerializer_Encrypt in '..\..\..\common\JvgXMLSerializer_Encrypt.pas',
  JvgXMLSerializer_pjh in '..\..\..\common\JvgXMLSerializer_pjh.pas',
  UnitCommUserClass in '..\..\..\common\UnitCommUserClass.pas',
  UnitFrameCromisIPCServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCromisIPCServer.pas' {FrameCromisIPCServer: TFrame},
  BW_Query_Data_Class in '..\Common\BW_Query_Data_Class.pas',
  UnitSTOMPClass in '..\..\..\common\UnitSTOMPClass.pas',
  StompClient in '..\..\..\common\delphistompclient-master\StompClient.pas',
  StompTypes in '..\..\..\common\delphistompclient-master\StompTypes.pas',
  UnitWorker4OmniMsgQ in '..\..\..\common\UnitWorker4OmniMsgQ.pas',
  UnitRMISSynLog in '..\Common\UnitRMISSynLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBWQueryPublisherF, BWQueryPublisherF);
  Application.Run;
end.

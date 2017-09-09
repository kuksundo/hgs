program CrankIoTServer;

uses
  Vcl.Forms,
  UnitCraneIoTServerMain in 'UnitCraneIoTServerMain.pas' {AMSServerMainF},
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  UnitCraneIoTConfigInterface in '..\Common\UnitCraneIoTConfigInterface.pas',
  UnitDM in '..\..\HiMECS\Application\Utility\AMS\Common\UnitDM.pas' {DM1: TDataModule},
  CommonUtil in '..\..\HiMECS\Application\Utility\ModbusComm_kumo\common\CommonUtil.pas',
  HHI_WebService in '..\..\DPMS\CommonUtil\HHI_WebService.pas',
  UnitHHIMessage in '..\..\DPMS\CommonUtil\UnitHHIMessage.pas',
  UnitCrankIotSensorInterface in '..\Common\UnitCrankIotSensorInterface.pas',
  UnitAMSessionInterface in '..\..\HiMECS\Application\Utility\AMS\Common\UnitAMSessionInterface.pas',
  sendSMS_Unit in '..\..\HiMECS\Application\Utility\AMS\Server\sendSMS_Unit.pas' {sendSMS_Frm},
  findUser_Unit in '..\..\HiMECS\Application\Utility\AMS\Common\findUser_Unit.pas' {findUser_Frm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TAMSServerMainF, AMSServerMainF);
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TsendSMS_Frm, sendSMS_Frm);
  Application.CreateForm(TfindUser_Frm, findUser_Frm);
  Application.Run;
end.

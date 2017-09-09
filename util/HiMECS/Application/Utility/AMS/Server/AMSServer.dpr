program AMSServer;

uses
  Vcl.Forms,
  UnitAMSServerMain in 'UnitAMSServerMain.pas' {AMSServerMainF},
  UnitFrameCommServer in '..\..\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  UnitAlarmConfigInterface in '..\Common\UnitAlarmConfigInterface.pas',
  UnitDM in '..\Common\UnitDM.pas' {DM1: TDataModule},
  CommonUtil in '..\..\ModbusComm_kumo\common\CommonUtil.pas',
  HHI_WebService in '..\..\..\..\..\DPMS\CommonUtil\HHI_WebService.pas',
  UnitHHIMessage in '..\..\..\..\..\DPMS\CommonUtil\UnitHHIMessage.pas',
  UnitAlarmReportInterface in '..\Common\UnitAlarmReportInterface.pas',
  UnitAMSessionInterface in '..\Common\UnitAMSessionInterface.pas',
  sendSMS_Unit in 'sendSMS_Unit.pas' {sendSMS_Frm},
  UnitAlarmConst in '..\Common\UnitAlarmConst.pas',
  UnitLampInterface in '..\Common\UnitLampInterface.pas',
  UnitAlarmConfigClass in '..\..\..\Source\Common\UnitAlarmConfigClass.pas',
  UnitAMSServerConfig in 'UnitAMSServerConfig.pas' {ConfigF},
  QLite in '..\Common\QLite.pas',
  IPC_EngineParam_Const in '..\..\Watch2\common\IPC_EngineParam_Const.pas',
  UnitfindUser in '..\..\..\Source\Forms\UnitfindUser.pas' {findUser_Frm},
  UnitCommUserClass in '..\..\..\..\..\..\common\UnitCommUserClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TAMSServerMainF, AMSServerMainF);
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TsendSMS_Frm, sendSMS_Frm);
  Application.CreateForm(TConfigF, ConfigF);
  Application.CreateForm(TfindUser_Frm, findUser_Frm);
  Application.Run;
end.

program ModBusComP_Woodward;

uses
  RunOne_ModbusComm_Kumo,
  Forms,
  ModbusCom_multidrop in 'ModbusCom_multidrop.pas' {ModbusComF},
  ModBusTCPWagoThread in 'ModBusTCPWagoThread.pas',
  ModbusComConst in 'ModbusComConst.pas',
  CommonUtil in 'common\CommonUtil.pas',
  ModBusComThread in 'ModBusComThread.pas',
  ModBusTCPThread in 'ModBusTCPThread.pas',
  ModbusConfig in 'ModbusConfig.pas' {ModbusConfigF},
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  IPC_ECS_Woodward_Const in '..\Watch2\common\IPC_ECS_Woodward_Const.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TModbusComF, ModbusComF);
  Application.CreateForm(TModbusConfigF, ModbusConfigF);
  Application.Run;
end.

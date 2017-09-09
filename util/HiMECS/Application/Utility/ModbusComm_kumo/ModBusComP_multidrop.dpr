program ModBusComP_multidrop;

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
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TModbusComF, ModbusComF);
  Application.CreateForm(TModbusConfigF, ModbusConfigF);
  Application.Run;
end.

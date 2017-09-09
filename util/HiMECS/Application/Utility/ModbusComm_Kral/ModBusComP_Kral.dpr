program ModBusComP_Kral;

uses
  RunOne_ModbusComm_Kumo,
  Forms,
  ModbusCom_multidrop in 'ModbusCom_multidrop.pas' {ModbusComF},
  ModBusTCPWagoThread in 'ModBusTCPWagoThread.pas',
  ModbusComConst in 'ModbusComConst.pas',
  ModBusComThread in 'ModBusComThread.pas',
  ModBusTCPThread in 'ModBusTCPThread.pas',
  ModbusConfig in 'ModbusConfig.pas' {ModbusConfigF},
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  MyKernelObject in '..\ModbusComm_kumo\common\MyKernelObject.pas',
  CommonUtil in '..\ModbusComm_kumo\common\CommonUtil.pas',
  CopyData in '..\ModbusComm_kumo\common\CopyData.pas',
  ByteArray in '..\ModbusComm_kumo\common\ByteArray.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TModbusComF, ModbusComF);
  Application.CreateForm(TModbusConfigF, ModbusConfigF);
  Application.Run;
end.

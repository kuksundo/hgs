program ModBusComm_HIC;

uses
  RunOne_ModbusComm_Kumo,
  Forms,
  ModbusCom_main in 'ModbusCom_main.pas' {ModbusComF},
  ModBusTCPWagoThread in 'ModBusTCPWagoThread.pas',
  CommonUtil in 'common\CommonUtil.pas',
  ModBusComThread in 'ModBusComThread.pas',
  ModBusTCPThread in 'ModBusTCPThread.pas',
  ModbusConfig in 'ModbusConfig.pas' {ModbusConfigF},
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  IPCThreadEvent in '..\..\..\..\..\common\IPCThreadEvent.pas',
  IPCThrdClient_Generic in '..\..\..\..\..\common\IPCThrdClient_Generic.pas',
  UnitIPCClientAll in '..\CommonFrame\UnitIPCClientAll.pas',
  IPC_ModbusComm_Const in 'common\IPC_ModbusComm_Const.pas',
  IPCThrdMonitor_Generic in '..\..\..\..\..\common\IPCThrdMonitor_Generic.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TModbusComF, ModbusComF);
  Application.CreateForm(TModbusConfigF, ModbusConfigF);
  Application.Run;
end.

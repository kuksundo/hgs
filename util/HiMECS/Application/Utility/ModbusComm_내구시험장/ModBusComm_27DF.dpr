program ModBusComm_27DF;

uses
  RunOne,
  Forms,
  ModbusCom_main in 'ModbusCom_main.pas' {ModbusComF},
  ModBusTCPWagoThread in 'ModBusTCPWagoThread.pas',
  ModBusComThread in 'ModBusComThread.pas',
  ModBusTCPThread in 'ModBusTCPThread.pas',
  ModbusConfig in 'ModbusConfig.pas' {ModbusConfigF},
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  IPCThreadEvent in '..\..\..\..\..\common\IPCThreadEvent.pas',
  IPCThrdClient_Generic in '..\..\..\..\..\common\IPCThrdClient_Generic.pas',
  UnitIPCClientAll in '..\CommonFrame\UnitIPCClientAll.pas',
  IPC_ModbusComm_Const in 'common\IPC_ModbusComm_Const.pas',
  IPCThrdMonitor_Generic in '..\..\..\..\..\common\IPCThrdMonitor_Generic.pas',
  IPC_Modbus_Standard_Const in '..\Watch2\common\IPC_Modbus_Standard_Const.pas',
  IdModBusSerialClient in 'common\IdModBusSerialClient.pas',
  ModBusSerialTypes in 'common\ModBusSerialTypes.pas',
  ModbusCom_Recv in 'ModbusCom_Recv.pas' {DisplayRecvF},
  UnitSynLog in '..\..\..\..\..\common\UnitSynLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TModbusComF, ModbusComF);
  Application.Run;
end.

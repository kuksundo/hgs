program ModBusComP_avat_XE2;

uses
  RunOne_ModbusComm_Avat,
  Forms,
  ModBusTCPWagoThread in 'ModBusTCPWagoThread.pas',
  ModbusComConst in 'ModbusComConst.pas',
  ModBusComThread in 'ModBusComThread.pas',
  ModbusCom_multidrop in 'ModbusCom_multidrop.pas' {ModbusComF},
  ModBusTCPThread in 'ModBusTCPThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TModbusComF, ModbusComF);
  Application.Run;
end.

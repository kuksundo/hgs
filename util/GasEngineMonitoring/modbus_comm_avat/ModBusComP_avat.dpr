program ModBusComP_avat;

uses
  RunOne_ModbusComm_Avat, Forms,
  ModbusCom_multidrop in 'ModbusCom_multidrop.pas' {ModbusComF},
  ModBusTCPWagoThread in 'ModBusTCPWagoThread.pas',
  ModbusComConst in 'ModbusComConst.pas',
  ModBusComThread in 'ModBusComThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TModbusComF, ModbusComF);
  Application.Run;
end.

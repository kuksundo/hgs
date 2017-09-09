program ModBusComP_multidrop;

uses
  Forms,
  ModbusCom_multidrop in 'ModbusCom_multidrop.pas' {ModbusComF},
  CPort in '..\..\vclbackup\dpk\공개Comm\CPort\CPort.pas',
  CPortSetup in '..\..\vclbackup\dpk\공개Comm\CPort\CPortSetup.pas' {ComSetupFrm},
  CPortCtl in '..\..\vclbackup\dpk\공개Comm\CPort\CPortCtl.pas',
  CPortEsc in '..\..\vclbackup\dpk\공개Comm\CPort\CPortEsc.pas',
  CPortTrmSet in '..\..\vclbackup\dpk\공개Comm\CPort\CPortTrmSet.pas' {ComTrmSetForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TModbusComF, ModbusComF);
  Application.Run;
end.

program GasEngineMonitoring2;

uses
  Forms,
  UnitEngineMonitoring in 'UnitEngineMonitoring.pas' {FrmEngineMonitoring},
  ConfigConst in 'ConfigConst.pas',
  MonitorConfig in 'MonitorConfig.pas' {ModbusConfigF},
  ConfigOptionClass in 'common\ConfigOptionClass.pas',
  StopWatch in 'common\StopWatch.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmEngineMonitoring, FrmEngineMonitoring);
  Application.CreateForm(TModbusConfigF, ModbusConfigF);
  Application.Run;
end.

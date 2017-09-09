program EngineMonitoringp;

uses
  Forms,
  mwFixedRecSort in '..\common\mwFixedRecSort.pas',
  MyKernelObject in '..\common\MyKernelObject.pas',
  janSQL in '..\common\janSQL.pas',
  ConfigConst in 'ConfigConst.pas',
  MonitorConfig in 'MonitorConfig.pas' {ModbusConfigF},
  BaseConfigCollect in '..\common\BaseConfigCollect.pas',
  JvgXMLSerializer_Encrypt in '..\common\JvgXMLSerializer_Encrypt.pas',
  CommonUtil in '..\common\CommonUtil.pas',
  ConfigOptionClass in 'common\ConfigOptionClass.pas',
  StopWatch in 'common\StopWatch.pas',
  DeCAL in '..\..\..\..\..\..\Common\DeCAL\DeCAL.pas',
  ModbusComStruct in '..\..\Watch2\common\ModbusComStruct.pas',
  IPCThrd_ECS_kumo in '..\common\IPCThrd_ECS_kumo.pas',
  UnitEngineMonitorComponents in 'UnitEngineMonitorComponents.pas',
  UnitEngineMonitoring in 'UnitEngineMonitoring.pas' {FrmEngineMonitoring};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmEngineMonitoring, FrmEngineMonitoring);
  Application.Run;
end.

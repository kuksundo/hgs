program AlarmList;

uses
  Forms,
  UnitAlarmList in 'UnitAlarmList.pas' {FormAlarmList},
  UnitAlarmConfigClass in '..\..\Source\Common\UnitAlarmConfigClass.pas',
  UnitAlarmConst in 'UnitAlarmConst.pas',
  EngineParameterClass in '..\..\Source\Common\EngineParameterClass.pas',
  UnitCopyWatchList in '..\Watch2\UnitCopyWatchList.pas' {CopyWatchListF},
  WatchConst2 in '..\Watch2\WatchConst2.pas',
  UnitEngParamConfig in '..\..\Source\Forms\UnitEngParamConfig.pas' {EngParamItemConfigForm},
  UnitAlarmConfig in 'UnitAlarmConfig.pas' {AlarmConfigF},
  UtilUnit in '..\..\..\..\VisualComm\util\UtilUnit.pas',
  UnitFrameIPCMonitorAll in '..\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitor: TFrame},
  UnitFrameWatchGrid in '..\CommonFrame\UnitFrameWatchGrid.pas' {FrameWatchGrid: TFrame},
  UnitConfigIniClass in '..\..\..\..\..\common\UnitConfigIniClass.pas',
  JSONPersist in '..\..\..\..\..\common\JSONPersist.pas',
  UnitConfigJSONClass in '..\..\..\..\..\common\UnitConfigJSONClass.pas',
  UnitDataModule in 'UnitDataModule.pas' {DataModule1: TDataModule},
  UnitSelectUser in '..\..\Source\Forms\UnitSelectUser.pas' {SelectUserF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormAlarmList, FormAlarmList);
  Application.CreateForm(TEngParamItemConfigForm, EngParamItemConfigForm);
  Application.CreateForm(TAlarmConfigF, AlarmConfigF);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TSelectUserF, SelectUserF);
  Application.Run;
end.

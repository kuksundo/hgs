program ScheduleManager_HIMSEN;

uses
  Vcl.Forms,
  UnitTreeGridGanttRecord in 'UnitTreeGridGanttRecord.pas',
  UnitScheGantt in 'UnitScheGantt.pas' {GanttForm},
  ScheduleSampleDataModel in 'ScheduleSampleDataModel.pas',
  ceffilescheme in 'FileScheme\ceffilescheme.pas',
  UnitWorker4OmniMsgQ in '..\..\common\UnitWorker4OmniMsgQ.pas',
  UnitStringUtil in '..\..\common\UnitStringUtil.pas',
  ExcelUtil in '..\..\common\ExcelUtil.pas',
  ProjectBaseClass in '..\HiMECS\Application\Source\Common\ProjectBaseClass.pas',
  UnitScheManageDM in 'UnitScheManageDM.pas' {DM1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TGanttForm, GanttForm);
  Application.Run;
end.

program ReportkWp;

uses
  Vcl.Forms,
  UnitkWReportDM in 'UnitkWReportDM.pas' {DataModule4: TDataModule},
  UnitkwhReport in 'UnitkwhReport.pas' {kwh_reportF},
  HoliDayCollect in '..\HiTEMS_CBY\00.CommonUtils\HoliDayCollect.pas',
  ElecPowerCalcClass in '00.CommonUtils\ElecPowerCalcClass.pas',
  UnitPlannerDateHelper in '..\..\common\UnitPlannerDateHelper.pas',
  CircularArray in '..\HiMECS\Application\Source\Common\CircularArray.pas',
  pjhPlannerDatePicker in '..\..\..\vcl\pjhComponent\pjhPlannerDatePicker.pas',
  UnitMongoDBManager in '..\..\common\UnitMongoDBManager.pas',
  CommonUtil in '..\HiMECS\Application\Utility\ModbusComm_kumo\common\CommonUtil.pas',
  GridViewFrame in '..\HiMECS\Application\Utility\CommonFrame\GridViewFrame.pas' {Frame1: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule4, DM4);
  Application.CreateForm(Tkwh_reportF, kwh_reportF);
  Application.Run;
end.

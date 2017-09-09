program HiTEMS_TMS_K220;

uses
  Vcl.Forms,
  taskMain_Unit in '..\Forms\taskMain_Unit.pas' {taskMain_Frm},
  DataModule_Unit in '..\Forms\DataModule_Unit.pas' {DM1: TDataModule},
  HitemsAddCode_Unit in '..\Forms\CODE_Form\HitemsAddCode_Unit.pas' {HitemsAddCode_Frm},
  HitemsAddGroup_Unit in '..\Forms\CODE_Form\HitemsAddGroup_Unit.pas' {HitemsAddGroup_Frm},
  HitemsCode_Unit in '..\Forms\CODE_Form\HitemsCode_Unit.pas' {HitemsCode_Frm},
  TMS_jobCode_Unit in '..\Forms\CODE_Form\TMS_jobCode_Unit.pas' {jobCode_Frm},
  TMS_newjobCode_Unit in '..\Forms\CODE_Form\TMS_newjobCode_Unit.pas' {newjobCode_Frm},
  TMS_newWorkType_Unit in '..\Forms\CODE_Form\TMS_newWorkType_Unit.pas' {HiTEMS_newWorkType_Frm},
  TMS_workType_Unit in '..\Forms\CODE_Form\TMS_workType_Unit.pas' {TMS_workType_Frm},
  HiTEMS_TMS_COMMON in '..\Forms\Common\HiTEMS_TMS_COMMON.pas',
  HiTEMS_TMS_CONST in '..\Forms\Common\HiTEMS_TMS_CONST.pas',
  CommonUtil_Unit in '..\..\..\..\00.CommonUtils\CommonUtil_Unit.pas',
  schedule_Unit in '..\Forms\Schedule_Form\schedule_Unit.pas' {schedule_Frm},
  newWorkPlan_Unit in '..\Forms\Schedule_Form\newWorkPlan_Unit.pas' {newWorkPlan_Frm},
  newTestPlan_Unit in '..\Forms\Schedule_Form\newTestPlan_Unit.pas' {newTestPlan_Frm},
  newTask_Unit in '..\Forms\Schedule_Form\newTask_Unit.pas' {newTask_Frm},
  findUser_Unit in '..\Forms\Assist_Form\findUser_Unit.pas' {findUser_Frm},
  workLog_Unit in '..\Forms\DailyReport_Form\workLog_Unit.pas' {workLog_Frm},
  bussLog_Unit in '..\Forms\DailyReport_Form\bussLog_Unit.pas' {bussLog_Frm},
  bussInfo_Unit in '..\Forms\Assist_Form\bussInfo_Unit.pas' {bussInfo_Frm},
  nextPlan_Unit in '..\Forms\Assist_Form\nextPlan_Unit.pas' {nextPlan_Frm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TtaskMain_Frm, taskMain_Frm);
  Application.CreateForm(TnextPlan_Frm, nextPlan_Frm);
  Application.Run;
end.

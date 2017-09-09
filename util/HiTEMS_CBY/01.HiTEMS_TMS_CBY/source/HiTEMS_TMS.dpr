program HiTEMS_TMS;





{$R *.dres}

uses
  Vcl.Forms,
  taskMain_Unit in 'Forms\taskMain_Unit.pas' {taskMain_Frm},
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  selectCode_Unit in 'Forms\CODE_Form\selectCode_Unit.pas' {selectCode_Frm},
  HiTEMS_TMS_COMMON in 'Forms\Common\HiTEMS_TMS_COMMON.pas',
  HiTEMS_TMS_CONST in 'Forms\Common\HiTEMS_TMS_CONST.pas',
  workLog_Unit in 'Forms\DailyReport_Form\workLog_Unit.pas' {workLog_Frm},
  bussLog_Unit in 'Forms\DailyReport_Form\bussLog_Unit.pas' {bussLog_Frm},
  selectPlan_Unit in 'Forms\DailyReport_Form\selectPlan_Unit.pas' {selectPlan_Frm},
  setProgress_Unit in 'Forms\Assist_Form\setProgress_Unit.pas' {setProgress_Frm},
  taskHome_Unit in 'Forms\taskHome_Unit.pas' {taskHome_Frm},
  newTask_Unit in 'Forms\TaskManagement_Form\newTask_Unit.pas' {newTask_Frm},
  newTaskPlan_Unit in 'Forms\TaskManagement_Form\newTaskPlan_Unit.pas' {newTaskPlan_Frm},
  taskManagement_Unit in 'Forms\TaskManagement_Form\taskManagement_Unit.pas' {taskManagement_Frm},
  sendSMS_Unit in 'Forms\Assist_Form\sendSMS_Unit.pas' {sendSMS_Frm},
  photorum_Unit in 'Forms\Application_Form\photorum_Unit.pas' {photorum_Frm},
  taskView_Unit in 'Forms\TaskManagement_Form\taskView_Unit.pas' {taskView_Frm},
  logDialog_Unit in 'Forms\DailyReport_Form\logDialog_Unit.pas' {logDialog_Frm},
  findUser_Unit in 'Forms\Assist_Form\findUser_Unit.pas' {findUser_Frm},
  dailyManPower_Unit in 'Forms\DailyReport_Form\dailyManPower_Unit.pas' {dailyManPower_Frm},
  dailyReportView_Unit in 'Forms\Monitoring_Form\dailyReportView_Unit.pas' {dailyReportView_Frm},
  taskStatistics_Unit in 'Forms\Monitoring_Form\taskStatistics_Unit.pas' {taskStatistics_Frm},
  statisticsChart_Unit in 'Forms\Monitoring_Form\statisticsChart_Unit.pas' {statisticsChart_Frm},
  detailOrder_Unit in 'Forms\workOrders_Form\detailOrder_Unit.pas' {detailOrder_Frm},
  makeOrder_Unit in 'Forms\workOrders_Form\makeOrder_Unit.pas' {makeOrder_Frm},
  codeCategory_Unit in 'Forms\CODE_Form\codeCategory_Unit.pas' {codeCategory_Frm},
  resultDialog_Unit in 'Forms\Assist_Form\resultDialog_Unit.pas' {resultDialog_Frm},
  commonCode_Unit in 'Forms\CODE_Form\commonCode_Unit.pas' {commonCode_Frm},
  workerDialog_Unit in 'Forms\workOrders_Form\workerDialog_Unit.pas' {workerDialog_Frm},
  workOrder_Unit in 'Forms\workOrders_Form\workOrder_Unit.pas' {workOrder_Frm},
  lastOrder_Unit in 'Forms\workOrders_Form\lastOrder_Unit.pas' {lastOrder_Frm},
  editOrder_Unit in 'Forms\workOrders_Form\editOrder_Unit.pas' {editOrder_Frm},
  sheetManagement_Unit in 'Forms\workOrders_Form\sheet_Form\sheetManagement_Unit.pas' {sheetManagement_Frm},
  localSheet_Unit in 'Forms\workOrders_Form\sheet_Form\localSheet_Unit.pas' {localSheet_Frm},
  newCategory_Unit in 'Forms\workOrders_Form\newCategory_Unit.pas' {newCategory_Frm},
  workCode_Unit in 'Forms\workOrders_Form\workCode_Unit.pas' {workCode_Frm},
  setEngineDialog_Unit in 'Forms\Assist_Form\setEngineDialog_Unit.pas' {setEngineDialog_Frm},
  overTime_Unit in 'Forms\Assist_Form\overTime_Unit.pas' {overTime_Frm},
  chooseTask_Unit in 'Forms\Assist_Form\chooseTask_Unit.pas' {chooseTask_Frm},
  shimDataSheet_Unit in 'Forms\workOrders_Form\sheet_Form\shimDataSheet_Unit.pas' {shimDataSheet_Frm},
  testStatus_Unit in 'Forms\TestManagement_Form\testStatus_Unit.pas' {testStatus_Frm},
  testReceive_Unit in 'Forms\TestManagement_Form\testReceive_Unit.pas' {testReceive_Frm},
  checkChangePart_Unit in 'Forms\workOrders_Form\sheet_Form\checkChangePart_Unit.pas' {checkChangePart_Frm},
  chooseMS_Unit in 'Forms\TestManagement_Form\chooseMS_Unit.pas' {chooseMS_Frm},
  newPart_Unit in 'Forms\TestManagement_Form\newPart_Unit.pas' {newPart_Frm},
  newPartRequest_Unit in 'Forms\TestManagement_Form\newPartRequest_Unit.pas' {newPartRequest_Frm},
  setPartPosition_Unit in 'Forms\TestManagement_Form\setPartPosition_Unit.pas' {setPartPosition_Frm},
  detailPartInfo_Unit in 'Forms\TestManagement_Form\detailPartInfo_Unit.pas' {detailPartInfo_Frm},
  testResult_Unit in 'Forms\TestManagement_Form\testResult_Unit.pas' {testResult_Frm},
  weeklyProcessPlan_Unit in 'Forms\Monitoring_Form\weeklyProcessPlan_Unit.pas' {weeklyProcessPlanF},
  testRequest_Unit in '..\..\03.HiTEMS_Test_Request_CBY\source\Forms\Request_Form\testRequest_Unit.pas' {testRequest_Frm},
  CommonUtil_Unit in '..\..\00.CommonUtils\CommonUtil_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TtaskMain_Frm, taskMain_Frm);
  Application.Run;
end.

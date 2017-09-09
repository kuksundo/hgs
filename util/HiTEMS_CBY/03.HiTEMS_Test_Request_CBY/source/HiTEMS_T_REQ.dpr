program HiTEMS_T_REQ;



{$R *.dres}

uses
  Vcl.Forms,
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  requestMain_Unit in 'Forms\requestMain_Unit.pas' {requestMain_Frm},
  testRequest_Unit in 'Forms\Request_Form\testRequest_Unit.pas' {testRequest_Frm},
  newPartRequest_Unit in 'Forms\Request_Form\newPartRequest_Unit.pas' {newPartRequest_Frm},
  chooseMS_Unit in 'Forms\Request_Form\chooseMS_Unit.pas' {chooseMS_Frm},
  newPart_Unit in 'Forms\Request_Form\newPart_Unit.pas' {newPart_Frm},
  resultDialog_Unit in 'Forms\Request_Form\resultDialog_Unit.pas' {resultDialog_Frm},
  setPartPosition_Unit in 'Forms\Request_Form\setPartPosition_Unit.pas' {setPartPosition_Frm},
  detailPartInfo_Unit in 'Forms\Request_Form\detailPartInfo_Unit.pas' {detailPartInfo_Frm},
  checkChangePart_Unit in 'Forms\Request_Form\checkChangePart_Unit.pas' {checkChangePart_Frm},
  localSheet_Unit in 'Forms\Request_Form\localSheet_Unit.pas' {localSheet_Frm},
  shimDataSheet_Unit in 'Forms\Request_Form\shimDataSheet_Unit.pas' {shimDataSheet_Frm},
  testResult_Unit in 'Forms\Request_Form\testResult_Unit.pas' {testResult_Frm},
  TestReqCollect in '..\..\00.CommonUtils\TestReqCollect.pas',
  HiTEMS_TMS_COMMON in 'Forms\common\HiTEMS_TMS_COMMON.pas',
  HiTEMS_TMS_CONST in 'Forms\common\HiTEMS_TMS_CONST.pas',
  newTaskPlan_Unit in 'Forms\Request_Form\newTaskPlan_Unit.pas' {newTaskPlan_Frm},
  HoliDayCollect in '..\..\00.CommonUtils\HoliDayCollect.pas',
  pjhPlannerDatePicker in '..\..\..\..\..\vcl\pjhComponent\pjhPlannerDatePicker.pas',
  chooseMSHistory_Unit in 'Forms\Request_Form\chooseMSHistory_Unit.pas' {ChooseMSHistoryF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TrequestMain_Frm, requestMain_Frm);
  Application.Run;
end.

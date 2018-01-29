program InqManageR;

uses
  Vcl.Forms,
  SynSqlite3Static,
  UnitRegistrationUtil,
  FrmInqManage in 'FrmInqManage.pas' {InquiryF},
  UViewMailList in 'UViewMailList.pas' {ViewMailListF},
  UElecDataRecord in 'UElecDataRecord.pas',
  TaskForm in 'TaskForm.pas' {TaskEditF},
  VarRecUtils in '..\..\common\openarr\source\VarRecUtils.pas',
  FrameDisplayTaskInfo in 'FrameDisplayTaskInfo.pas' {DisplayTaskF: TFrame},
  FrmDisplayTaskInfo in 'FrmDisplayTaskInfo.pas' {DisplayTaskInfoF},
  FrmFileSelect in 'FrmFileSelect.pas' {FileSelectF},
  FSMClass_Dic in '..\..\common\FSMClass_Dic.pas',
  FSMState in '..\..\common\FSMState.pas',
  UnitMakeReport in 'UnitMakeReport.pas',
  FrmEditSubCon in 'FrmEditSubCon.pas' {Form2},
  FrmEditEmailInfo in 'FrmEditEmailInfo.pas' {EmailInfoF},
  UnitStringUtil in '..\..\common\UnitStringUtil.pas',
  UnitIPCModule in 'UnitIPCModule.pas',
  UnitTodo_Detail in 'UnitTodo_Detail.pas' {ToDoDetailF},
  UnitTodoList in 'UnitTodoList.pas' {ToDoListF},
  UnitDateUtil in '..\..\common\UnitDateUtil.pas',
  UnitTodoCollect in 'UnitTodoCollect.pas',
  FrmSearchCustomer in 'FrmSearchCustomer.pas' {SearchCustomerF},
  UnitRegistryUtil in '..\..\common\UnitRegistryUtil.pas',
  UnitRegistrationClass in '..\..\common\UnitRegistrationClass.pas',
  UnitRegCodeConst in '..\..\common\UnitRegCodeConst.pas',
  UnitHttpModule in 'UnitHttpModule.pas',
  UnitRegCodeServerInterface in '..\RegCodeManager\Common\UnitRegCodeServerInterface.pas',
  FrmRegistration in '..\..\common\FrmRegistration.pas' {RegistrationF},
  UnitMacroListClass in '..\MacroManagement\UnitMacroListClass.pas',
  thundax.lib.actions in '..\..\OpenSrc\thundax-macro-actions-master\thundax.lib.actions.pas',
  UnitNextGridFrame in '..\..\common\Frames\UnitNextGridFrame.pas' {Frame1: TFrame},
  getIp in '..\..\common\getIp.pas',
  UnitConfigIniClass2 in '..\..\common\UnitConfigIniClass2.pas',
  FrmInqManageConfig in 'FrmInqManageConfig.pas' {ConfigF},
  OLMailWSCallbackInterface in '..\OutLookAddIn\OLMail4InqManage\OLMailWSCallbackInterface.pas',
  FrmEditProduct in '..\RegCodeManager\FrmEditProduct.pas' {ProdEditF};

{$R *.res}

begin
  {$IfDef USE_REGCODE}
    CheckRegistration('{563EBFC1-922F-4605-95C9-7725946BA209}', [crmHTTP]);
  {$EndIf USE_REGCODE}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TInquiryF, InquiryF);
  Application.CreateForm(TProdEditF, ProdEditF);
  Application.Run;
end.

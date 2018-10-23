program FieldServiceR;

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
  UnitHttpModule4RegServer in '..\RegCodeManager\UnitHttpModule4RegServer.pas',
  UnitRegCodeServerInterface in '..\RegCodeManager\Common\UnitRegCodeServerInterface.pas',
  FrmRegistration in '..\..\common\FrmRegistration.pas' {RegistrationF},
  UnitMacroListClass in '..\MacroManagement\UnitMacroListClass.pas',
  thundax.lib.actions in '..\..\OpenSrc\thundax-macro-actions-master\thundax.lib.actions.pas',
  UnitNextGridFrame in '..\..\common\Frames\UnitNextGridFrame.pas' {Frame1: TFrame},
  getIp in '..\..\common\getIp.pas',
  UnitConfigIniClass2 in '..\..\common\UnitConfigIniClass2.pas',
  FrmInqManageConfig in 'FrmInqManageConfig.pas' {ConfigF},
  OLMailWSCallbackInterface in '..\OutLookAddIn\OLMail4InqManage\OLMailWSCallbackInterface.pas',
  FrmFileList in 'InvoiceManage\FrmFileList.pas',
  UnitVesselData in 'VesselList\UnitVesselData.pas',
  UnitEngineMasterData in 'VesselList\UnitEngineMasterData.pas';

const
  IM_ROOT_NAME_4_WS = 'root';
  IM_PORT_NAME_4_WS = '709';

{$R *.res}

begin
  {$IFDEF USE_REGCODE}
    //UnitCryptUtil.EncryptString_Syn('{2D1970CA-90FA-44C0-8120-F847C648AA34}, True')
    CheckRegistration('/Xcpm0JBkEsZASQYyQZsSOXp0oyq63H+hJhNpfiOsYfDfcPJijpNT+EhsaDoHes/Ph9McHk7c1Hx7TeETWNG3g==', [crmHTTP]);
  {$ENDIF USE_REGCODE}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TInquiryF, InquiryF);
  InquiryF.Caption := InquiryF.Caption + ' (For Field Service Team)';
  InquiryF.TDTF.SetNetworkInfo(IM_ROOT_NAME_4_WS,IM_PORT_NAME_4_WS, Application.ExeName);
  Application.Run;
end.

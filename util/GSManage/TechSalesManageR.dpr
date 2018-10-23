program TechSalesManageR;

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
  FrmEditProduct in '..\RegCodeManager\FrmEditProduct.pas' {ProdEditF},
  UnitBase64Util in '..\..\common\UnitBase64Util.pas',
  FrmSelectProductType in 'FrmSelectProductType.pas' {SelectProductTypeF},
  UnitAdvComponentUtil in 'UnitAdvComponentUtil.pas',
  UnitGSTriffData in 'UnitGSTriffData.pas',
  UnitGSTariffRecord in 'UnitGSTariffRecord.pas',
  FrmEditTariff in 'TariffManage\FrmEditTariff.pas' {TariffEditF},
  fFrmEditTariffItem in 'TariffManage\fFrmEditTariffItem.pas' {EditTariffItemF},
  FrmSearchVessel in 'FrmSearchVessel.pas' {SearchVesselF},
  FrmDisplayTariff in 'TariffManage\FrmDisplayTariff.pas' {DisplayTariffF},
  UnitFolderUtil in '..\..\common\UnitFolderUtil.pas',
  FrmFileList in 'InvoiceManage\FrmFileList.pas',
  UnitVesselData in 'VesselList\UnitVesselData.pas',
  UnitEngineMasterData in 'VesselList\UnitEngineMasterData.pas';

{$R *.res}

const
  IM_ROOT_NAME_4_WS = 'root';
  IM_PORT_NAME_4_WS = '710';

begin
  {$IfDef USE_REGCODE}
    //UnitCryptUtil.EncryptString_Syn('{3FA22544-6EA0-4CC6-9DCA-D16FFCBBF75D}', True)
    CheckRegistration('R7cln9Z8xXFT3feBTTlos+NfoWMvWqZ4FuTyRZEZdb7cmrswv40EETwKj9JUA58NYLUKFMRXR4O3bheJ83XHJg==', [crmHTTP]); //를 MD5로 변환한 값임
  {$EndIf USE_REGCODE}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TInquiryF, InquiryF);
  InquiryF.Caption := InquiryF.Caption + ' (For Technical Sales Team)';
  InquiryF.TDTF.SetNetworkInfo(IM_ROOT_NAME_4_WS,IM_PORT_NAME_4_WS, Application.ExeName);
  Application.Run;
end.

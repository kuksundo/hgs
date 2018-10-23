program InqManage;

uses
  Vcl.Forms,
  SynSqlite3Static,
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
  UnitRegCodeServerInterface in '..\RegCodeManager\Common\UnitRegCodeServerInterface.pas',
  FrmRegistration in '..\..\common\FrmRegistration.pas' {RegistrationF},
  getIp in '..\..\common\getIp.pas',
  UnitMAPSMacro in 'UnitMAPSMacro.pas',
  thundax.lib.actions in '..\..\OpenSrc\thundax-macro-actions-master\thundax.lib.actions.pas',
  UnitNextGridFrame in '..\..\common\Frames\UnitNextGridFrame.pas' {Frame1: TFrame},
  UnitDragUtil in '..\..\common\UnitDragUtil.pas',
  UnitVariantJsonUtil in 'UnitVariantJsonUtil.pas',
  UnitConfigIniClass2 in '..\..\common\UnitConfigIniClass2.pas',
  OLMailWSCallbackInterface in '..\OutLookAddIn\OLMail4InqManage\OLMailWSCallbackInterface.pas',
  FrmInqManageConfig in 'FrmInqManageConfig.pas',
  UnitIniConfigSetting in 'UnitIniConfigSetting.pas',
  UnitComboBoxUtil in '..\..\common\UnitComboBoxUtil.pas',
  UnitVesselMasterRecord in 'UnitVesselMasterRecord.pas',
  UnitMakeHgsDB in 'UnitMakeHgsDB.pas',
  UnitMakeHimsenWaringSpareDB in 'QuotationManage\UnitMakeHimsenWaringSpareDB.pas',
  UnitInqManageWSInterface in 'UnitInqManageWSInterface.pas',
  UnitUserDataRecord in 'UnitUserDataRecord.pas',
  FrmSubCompanyEdit in 'FrmSubCompanyEdit.pas' {SubCompanyEditF},
  UnitMakeMasterCustomerDB in 'UnitMakeMasterCustomerDB.pas',
  UnitHttpModule4RegServer in '..\RegCodeManager\UnitHttpModule4RegServer.pas',
  UnitCryptUtil in '..\..\common\UnitCryptUtil.pas',
  UnitMustacheUtil in '..\..\common\UnitMustacheUtil.pas',
  UnitHttpModule4InqManageServer in 'UnitHttpModule4InqManageServer.pas',
  UnitHttpModule in '..\..\common\UnitHttpModule.pas',
  fFrmEditTariffItem in 'TariffManage\fFrmEditTariffItem.pas' {EditTariffItemF},
  FrmDisplayTariff in 'TariffManage\FrmDisplayTariff.pas' {DisplayTariffF},
  FrmEditTariff in 'TariffManage\FrmEditTariff.pas' {TariffEditF},
  FrmEditVesselInfo in 'VesselList\FrmEditVesselInfo.pas' {EditVesselInfoF},
  HtmlParserEx in '..\..\OpenSrc\htmlparser-master\HtmlParserEx.pas',
  FrmHiMAPSelect in 'HiMAPManage\FrmHiMAPSelect.pas' {HiMAPSelectF},
  frmHiMAPDetail in 'HiMAPManage\frmHiMAPDetail.pas' {HiMAPDetailF},
  UnitHiMAPData in 'HiMAPManage\UnitHiMAPData.pas',
  UnitMSBDData in 'VesselList\UnitMSBDData.pas',
  UnitEngineMasterRecord in 'VesselList\UnitEngineMasterRecord.pas',
  FrmFileList in 'InvoiceManage\FrmFileList.pas',
  UnitGeneratorRecord in 'GeneratorManage\UnitGeneratorRecord.pas',
  frmGeneratorDetail in 'GeneratorManage\frmGeneratorDetail.pas' {GeneratorDetailF},
  FrameGSFileList in '..\..\common\Frames\FrameGSFileList.pas' {GSFileListFrame: TFrame},
  UnitVesselData in 'VesselList\UnitVesselData.pas';

{$R *.res}

const
  IM_ROOT_NAME_4_WS = 'root';
  IM_PORT_NAME_4_WS = '708';

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TInquiryF, InquiryF);
  Application.CreateForm(TGeneratorDetailF, GeneratorDetailF);
  InquiryF.TDTF.SetNetworkInfo(IM_ROOT_NAME_4_WS,IM_PORT_NAME_4_WS, Application.ExeName);
  Application.Run;
end.

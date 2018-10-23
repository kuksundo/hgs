program CustomerManage;

uses
  Vcl.Forms,
  FrmSubCompanyEdit in '..\FrmSubCompanyEdit.pas' {SubCompanyEditF},
  UnitVariantJsonUtil in '..\UnitVariantJsonUtil.pas',
  UnitTodoCollect in '..\UnitTodoCollect.pas',
  UnitMakeReport in '..\UnitMakeReport.pas',
  UnitHGSSerialRecord in '..\UnitHGSSerialRecord.pas',
  UnitGSFileRecord in '..\UnitGSFileRecord.pas',
  UnitGSCommonUtil in '..\UnitGSCommonUtil.pas',
  UnitElecServiceData in '..\UnitElecServiceData.pas',
  FrmSelectProductType in '..\FrmSelectProductType.pas' {SelectProductTypeF},
  FrmSearchCustomer in '..\FrmSearchCustomer.pas' {SearchCustomerF},
  FrmFileSelect in '..\FrmFileSelect.pas' {FileSelectF},
  CommonData in '..\CommonData.pas',
  UnitEngineMasterData in '..\VesselList\UnitEngineMasterData.pas',
  UnitVesselData in '..\VesselList\UnitVesselData.pas',
  VarRecUtils in '..\..\..\common\openarr\source\VarRecUtils.pas',
  FrmFileList in '..\InvoiceManage\FrmFileList.pas',
  UnitDM in '..\UnitDM.pas',
  UnitAdvComponentUtil in '..\UnitAdvComponentUtil.pas',
  UElecDataRecord in '..\UElecDataRecord.pas',
  UnitGSTriffData in '..\UnitGSTriffData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSubCompanyEditF, SubCompanyEditF);
  Application.Run;
end.

program CertManageR;

uses
  Vcl.Forms,
  {$IfDef USE_REGCODE}
  UnitRegistrationUtil,
  {$EndIf USE_REGCODE}
  SynSqlite3Static,
  FrmCertManage in 'FrmCertManage.pas' {CertManageF},
  Vcl.Themes,
  Vcl.Styles,
  UnitVesselData in '..\VesselList\UnitVesselData.pas',
  UnitEnumHelper in '..\..\..\common\UnitEnumHelper.pas',
  UnitHGSCertRecord in 'UnitHGSCertRecord.pas',
  UnitHGSCertData in 'UnitHGSCertData.pas',
  VarRecUtils in '..\..\..\common\openarr\source\VarRecUtils.pas',
  FrmCertEdit in 'FrmCertEdit.pas',
  FrameGSFileList in '..\..\..\common\Frames\FrameGSFileList.pas' {GSFileListFrame: TFrame},
  UnitGSFileRecord in '..\UnitGSFileRecord.pas',
  FrmFileSelect in '..\FrmFileSelect.pas',
  UnitStringUtil in '..\..\..\common\UnitStringUtil.pas',
  UnitHGSSerialRecord in '..\UnitHGSSerialRecord.pas',
  UnitQRCodeFrame in '..\..\..\Template\UnitQRCodeFrame.pas' {QRCodeFrame},
  UnitCryptUtil in '..\..\..\common\UnitCryptUtil.pas',
  DelphiZXIngQRCode in '..\..\..\OpenSrc\DelphiZXingQRCodeEx-master\DelphiZXingQRCodeEx-master\Source\DelphiZXIngQRCode.pas',
  QR_URL in '..\..\..\OpenSrc\DelphiZXingQRCodeEx-master\DelphiZXingQRCodeEx-master\Source\QR_URL.pas',
  QR_Win1251 in '..\..\..\OpenSrc\DelphiZXingQRCodeEx-master\DelphiZXingQRCodeEx-master\Source\QR_Win1251.pas',
  QRGraphics in '..\..\..\OpenSrc\DelphiZXingQRCodeEx-master\DelphiZXingQRCodeEx-master\Source\QRGraphics.pas',
  SCrypt in '..\..\..\OpenSrc\scrypt-for-delphi-master\SCrypt.pas',
  UnitGSCommonUtil in '..\UnitGSCommonUtil.pas',
  UnitHGSCurriculumRecord in 'UnitHGSCurriculumRecord.pas',
  UnitMakeXls in 'UnitMakeXls.pas',
  UnitExcelUtil in '..\..\..\common\UnitExcelUtil.pas',
  FrmCourseManage in '..\CourseManageR\FrmCourseManage.pas' {CourseManageF},
  UnitHGSCurriculumData in 'UnitHGSCurriculumData.pas',
  FrmCourseEdit in '..\CourseManageR\FrmCourseEdit.pas',
  UnitMSWordUtil in '..\..\..\common\UnitMSWordUtil.pas',
  FrmSearchCustomer in '..\FrmSearchCustomer.pas',
  CommonData in '..\CommonData.pas',
  UnitEngineMasterData in '..\VesselList\UnitEngineMasterData.pas',
  UnitElecServiceData in '..\UnitElecServiceData.pas',
  FrmSelectProductType in '..\FrmSelectProductType.pas',
  UnitTodoCollect in '..\UnitTodoCollect.pas',
  UnitVariantJsonUtil in '..\UnitVariantJsonUtil.pas',
  UnitMakeReport in '..\UnitMakeReport.pas',
  UnitHGSVDRRecord in '..\VDRManage\UnitHGSVDRRecord.pas',
  UnitHGSVDRData in '..\VDRManage\UnitHGSVDRData.pas',
  FrmCertNoFormat in 'FrmCertNoFormat.pas' {CertNoFormatF},
  FrmSearchVessel in '..\FrmSearchVessel.pas',
  UnitVesselMasterRecord in '..\UnitVesselMasterRecord.pas',
  FrmSearchVDR in 'FrmSearchVDR.pas' {SearchVDRF},
  UnitSimulateParamRecord in '..\..\HiMECS\Application\Utility\SimulateParamServer\UnitSimulateParamRecord.pas',
  BaseConfigCollect in '..\..\HiMECS\Application\Source\Common\BaseConfigCollect.pas',
  uSMBIOS in '..\..\..\common\TSmBios\Common\uSMBIOS.pas',
  UnitHttpModule4RegServer in '..\..\RegCodeManager\UnitHttpModule4RegServer.pas',
  UnitRegCodeServerInterface in '..\..\RegCodeManager\Common\UnitRegCodeServerInterface.pas',
  UnitFormUtil in '..\..\..\common\UnitFormUtil.pas',
  UElecDataRecord in '..\UElecDataRecord.pas',
  UnitGSFileData in '..\UnitGSFileData.pas',
  FrmGSFileList in '..\FrmGSFileList.pas';

{$R *.res}

begin
  {$IfDef USE_REGCODE}
    //UnitCryptUtil.EncryptString_Syn('{AF700786-5B91-4FB5-A506-C12C0BC44339}', True)
    CheckRegistration('kBiNK3KrHlsIo5Fmf/SNI6bqq9WJxBqrIzlYDaHFcbz80+SIckciaTfxG073oNJ9U3idI7kMoM8BSxTpjYXoew==', [crmHTTP]);
  {$EndIf USE_REGCODE}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCertManageF, CertManageF);
  Application.Run;
end.

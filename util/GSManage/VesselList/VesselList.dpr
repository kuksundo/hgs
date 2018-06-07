program VesselList;

uses
  Vcl.Forms,
  SynSqlite3Static,
  frmHiMAPDetail in '..\HiMAPManage\frmHiMAPDetail.pas' {HiMAPDetailF},
  UnitHiMAPData in '..\HiMAPManage\UnitHiMAPData.pas',
  FrmVesselList in 'FrmVesselList.pas' {VesselListF},
  VarRecUtils in '..\..\..\common\openarr\source\VarRecUtils.pas',
  UnitVesselMasterRecord in '..\UnitVesselMasterRecord.pas',
  CommonData in '..\CommonData.pas',
  UnitMakeHgsDB in '..\UnitMakeHgsDB.pas',
  UnitLogUtil in '..\..\..\common\UnitLogUtil.pas',
  UnitHiMAPRecord in '..\UnitHiMAPRecord.pas',
  FrmHiMAPSelect in '..\HiMAPManage\FrmHiMAPSelect.pas' {HiMAPSelectF},
  UnitMSBDData in 'UnitMSBDData.pas',
  UnitStringUtil in '..\..\..\common\UnitStringUtil.pas',
  FrmFileSelect in '..\FrmFileSelect.pas',
  UnitGSFileRecord in '..\UnitGSFileRecord.pas',
  FrmDisplayAnsiDeviceDesc in '..\FrmDisplayAnsiDeviceDesc.pas' {AnsiDeviceDescF},
  UnitAnsiDeviceRecord in '..\UnitAnsiDeviceRecord.pas',
  UnitMakeAnsiDeviceDB in '..\UnitMakeAnsiDeviceDB.pas',
  FrmAnsiDeviceNoList in '..\FrmAnsiDeviceNoList.pas' {AnsiDeviceNoF},
  FrmEditVesselInfo in 'FrmEditVesselInfo.pas' {EditVesselInfoF},
  HtmlParserEx in '..\..\..\OpenSrc\htmlparser-master\HtmlParserEx.pas',
  UnitNationRecord in 'UnitNationRecord.pas',
  UnitNationData in 'UnitNationData.pas',
  FrmViewNationCode in 'FrmViewNationCode.pas' {ViewNationCodeF},
  FrmViewFlag in 'FrmViewFlag.pas' {FlagViewF},
  UnitEngineMasterRecord in 'UnitEngineMasterRecord.pas',
  FrmViewEngineMaster in 'FrmViewEngineMaster.pas' {ViewEngineMasterF},
  FrmVesselAdvancedSearch in 'FrmVesselAdvancedSearch.pas' {VesselAdvancedSearchF},
  UnitElecMasterRecord in 'UnitElecMasterRecord.pas',
  frmGeneratorDetail in '..\GeneratorManage\frmGeneratorDetail.pas' {GeneratorDetailF},
  UnitGeneratorRecord in '..\GeneratorManage\UnitGeneratorRecord.pas',
  UnitVariantFormUtil in '..\..\..\common\UnitVariantFormUtil.pas',
  UnitRttiUtil in '..\..\..\common\UnitRttiUtil.pas',
  frmViewGeneratorMaster in '..\GeneratorManage\frmViewGeneratorMaster.pas' {ViewGenMasterF},
  UnitVesselData in 'UnitVesselData.pas',
  FrameDragDropOutlook in '..\..\..\common\Frames\FrameDragDropOutlook.pas' {DragOutlookFrame: TFrame},
  UnitCBData in 'UnitCBData.pas',
  UnitEnumHelper in '..\..\..\common\UnitEnumHelper.pas',
  FrameGSFileList in '..\..\..\common\Frames\FrameGSFileList.pas',
  UnitSimpleGenericEnum in '..\..\..\common\UnitSimpleGenericEnum.pas',
  UnitCBRecord in 'UnitCBRecord.pas',
  UnitElecServiceData in '..\UnitElecServiceData.pas',
  UnitEngineMasterData in 'UnitEngineMasterData.pas',
  UnitElecMasterData in 'UnitElecMasterData.pas',
  UnitBaseRecord in '..\..\..\common\UnitBaseRecord.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TVesselListF, VesselListF);
  Application.CreateForm(TViewGenMasterF, ViewGenMasterF);
  Application.Run;
end.

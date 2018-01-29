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
  FrmAnsiDeviceNoList in '..\FrmAnsiDeviceNoList.pas' {AnsiDeviceNoF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TVesselListF, VesselListF);
  Application.Run;
end.

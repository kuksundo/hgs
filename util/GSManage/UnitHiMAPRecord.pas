unit UnitHiMAPRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  CommonData,
  UnitVesselMasterRecord, UnitGSFileRecord;

type
  TSQLHiMAPRecord = class(TSQLVesselBase)
  private
    fHimap_Device_Type,
    fDevice_Variant,
    fPower_Supply,
    fPhase_CT,
    fPhase_PT,
    fPhase_CT_Diff,
    fCT_Ground,
    fPT_Ground,
    //for symap
    fCANBUS,
    fPROFIBUS,
    fSERIAL_INTERFACE,
    fIEC_61850,
    fAnalog_Output,
    fShunt1,
    fFront_Design,
    fRecording_Unit,//sympa, himap 공용
    fInstalledPanel,

    //for himap
    fCommunication,
    fExetndedBoard,
    fNorminalFrequency,
    fFrontpanelType
    : integer;

    fSpecialConfig,
    fSerialNo,
    fInstallPosition: RawUTF8;

    fInstallDate: TTimeLog;
  public
    function GetSymapOrderCode: string;
    function GetHiMAPOrderCode: string;
//    fIsUpdate: Boolean;
//    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property Himap_Device_Type: integer read fHimap_Device_Type write fHimap_Device_Type;
    property Device_Variant: integer read fDevice_Variant write fDevice_Variant;
    property Power_Supply: integer read fPower_Supply write fPower_Supply;
    property Phase_CT: integer read fPhase_CT write fPhase_CT;
    property Phase_PT: integer read fPhase_PT write fPhase_PT;
    property Phase_CT_Diff: integer read fPhase_CT_Diff write fPhase_CT_Diff;
    property CT_Ground: integer read fCT_Ground write fCT_Ground;
    property PT_Ground: integer read fPT_Ground write fPT_Ground;

    //for symap
    property CANBUS: integer read fCANBUS write fCANBUS;
    property PROFIBUS: integer read fPROFIBUS write fPROFIBUS;
    property SERIAL_INTERFACE: integer read fSERIAL_INTERFACE write fSERIAL_INTERFACE;
    property IEC_61850: integer read fIEC_61850 write fIEC_61850;
    property Analog_Output: integer read fAnalog_Output write fAnalog_Output;
    property Shunt1: integer read fShunt1 write fShunt1;
    property Front_Design: integer read fFront_Design write fFront_Design;
    property Recording_Unit: integer read fRecording_Unit write fRecording_Unit;

    //for himap
    property Communication: integer read fCommunication write fCommunication;
    property ExetndedBoard: integer read fExetndedBoard write fExetndedBoard;
    property SpecialConfig: RawUTF8 read fSpecialConfig write fSpecialConfig;
    property NorminalFrequency: integer read fNorminalFrequency write fNorminalFrequency;
    property FrontpanelType: integer read fFrontpanelType write fFrontpanelType;

    property SerialNo: RawUTF8 read fSerialNo write fSerialNo;
    property InstallPosition: RawUTF8 read fInstallPosition write fInstallPosition;

    property InstalledPanel: integer read fInstalledPanel write fInstalledPanel;

    property InstallDate: TTimeLog read fInstallDate write fInstallDate;
  end;

function CreateHiMAPModel: TSQLModel;
procedure InitHiMAPClient(AExeName: string);

function GetHiMAPFromHullNo(const AHullNo: string): TSQLHiMAPRecord;
function GetHiMAPFromShipName(const AShipName: string): TSQLHiMAPRecord;
function GetHiMAPFromIMONo(const AIMONo: string): TSQLHiMAPRecord;
function GetHiMAPFromIMONo_InstalledPnl_DeviceType(const AIMONo: string;
  const AInstalledPnl, ADeviceType, ADeviceVariant: integer): TSQLHiMAPRecord;

procedure AddHiMAPFromVariant(ADoc: variant);
procedure LoadHiMAPFromVariant(AHiMAP:TSQLHiMAPRecord; ADoc: variant);
procedure AddOrUpdateHiMAP(AHiMAP:TSQLHiMAPRecord);

procedure DeleteHiMAPFromIMONo_InstalledPnl_DeviceType(const AIMONo: string;
  const AInstalledPnl, ADeviceType, ADeviceVariant: integer);

var
  g_HiMAPDB: TSQLRestClientURI;
  HiMAPModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitHiMAPData,
  UnitMSBDData, UnitFolderUtil;

procedure InitHiMAPClient(AExeName: string);
var
  LStr: string;
begin
//  LStr := ChangeFileExt(Application.ExeName,'.sqlite');
//  LStr := 'HiMapData.sqlite';
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + 'HiMapData.sqlite';
  HiMAPModel:= CreateHiMAPModel;
  g_HiMAPDB:= TSQLRestClientDB.Create(HiMAPModel, CreateHiMAPModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HiMAPDB).Server.CreateMissingTables;

  InitGSFileClient(ExtractFilePath(AExeName)+'HiMapData.exe');
end;

function CreateHiMAPModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHiMAPRecord]);
end;

function GetHiMAPFromHullNo(const AHullNo: string): TSQLHiMAPRecord;
begin
  Result := TSQLHiMAPRecord.CreateAndFillPrepare(g_HiMAPDB,
    'HullNo LIKE ?', ['%'+AHullNo+'%']);
end;

function GetHiMAPFromShipName(const AShipName: string): TSQLHiMAPRecord;
begin
  Result := TSQLHiMAPRecord.CreateAndFillPrepare(g_HiMAPDB,
    'ShipName LIKE ?', ['%'+AShipName+'%']);
end;

function GetHiMAPFromIMONo(const AIMONo: string): TSQLHiMAPRecord;
begin
  Result := TSQLHiMAPRecord.CreateAndFillPrepare(g_HiMAPDB,
    'IMONo LIKE ?', ['%'+AIMONo+'%']);
end;

function GetHiMAPFromIMONo_InstalledPnl_DeviceType(const AIMONo: string;
  const AInstalledPnl, ADeviceType, ADeviceVariant: integer): TSQLHiMAPRecord;
begin
  Result := TSQLHiMAPRecord.CreateAndFillPrepare(g_HiMAPDB,
    'IMONo = ? AND InstalledPanel = ? AND Himap_Device_Type = ? AND Device_Variant = ?', [AIMONo, AInstalledPnl, ADeviceType, ADeviceVariant]);
end;

procedure AddHiMAPFromVariant(ADoc: variant);
var
  LSQLHiMAPRecord: TSQLHiMAPRecord;
begin
  LSQLHiMAPRecord := TSQLHiMAPRecord.Create;
  LSQLHiMAPRecord.IsUpdate := False;

  try
    LoadHiMAPFromVariant(LSQLHiMAPRecord, ADoc);
    AddOrUpdateHiMAP(LSQLHiMAPRecord);
  finally
    FreeAndNil(LSQLHiMAPRecord);
  end;
end;

procedure LoadHiMAPFromVariant(AHiMAP:TSQLHiMAPRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  AHiMAP.HullNo := ADoc.HullNo;
  AHiMAP.ShipName := ADoc.ShipName;
  AHiMAP.IMONo := ADoc.IMONo;

  AHiMAP.SerialNo := ADoc.SerialNo;
  AHiMAP.InstallPosition := ADoc.InstallPosition;
  AHiMAP.Himap_Device_Type := Ord(VCode2HDT(ADoc.Himap_Device_Type));

  //for Symap
  if THiMAP_Device_Type(AHiMAP.Himap_Device_Type) = hdtSymap then
  begin
    AHiMAP.Device_Variant := Ord(VCode2HDV(ADoc.Device_Variant));
    AHiMAP.Power_Supply := Ord(VCode2HPS(ADoc.Power_Supply));
    AHiMAP.Phase_CT := Ord(VCode2HPCT(ADoc.Phase_CT));
    AHiMAP.Phase_PT := Ord(VCode2HPPT(ADoc.Phase_PT));
    AHiMAP.Phase_CT_Diff := Ord(VCode2HPCTD(ADoc.Phase_CT_Diff));
    AHiMAP.CT_Ground := Ord(VCode2HCTG(ADoc.CT_Ground));
    AHiMAP.PT_Ground := Ord(VCode2HPTG(ADoc.PT_Ground));

    AHiMAP.CANBUS := Ord(VCode2HCB(ADoc.CANBUS));
    AHiMAP.PROFIBUS := Ord(VCode2HPB(ADoc.PROFIBUS));
    AHiMAP.SERIAL_INTERFACE := Ord(VCode2HSI(ADoc.SERIAL_INTERFACE));
    AHiMAP.IEC_61850 := Ord(VCode2HIEC61850(ADoc.IEC_61850));
    AHiMAP.Analog_Output := Ord(VCode2HAO(ADoc.Analog_Output));
    AHiMAP.Shunt1 := Ord(VCode2HS1(ADoc.Shunt1));
    AHiMAP.Front_Design := Ord(VCode2HFrontDesign(ADoc.Front_Design));
  end
  else  //for himap
  if THiMAP_Device_Type(AHiMAP.Himap_Device_Type) = hdtHimap then
  begin
    AHiMAP.Device_Variant := Ord(HVCode2HDV(ADoc.Device_Variant));
    AHiMAP.Power_Supply := Ord(HVCode2HPS(ADoc.Power_Supply));
    AHiMAP.Phase_CT := Ord(HVCode2HPCT(ADoc.Phase_CT));
    AHiMAP.Phase_PT := Ord(HVCode2HPPT(ADoc.Phase_PT));
    AHiMAP.Phase_CT_Diff := Ord(HVCode2HPCTD(ADoc.Phase_CT_Diff));
    AHiMAP.CT_Ground := Ord(HVCode2HCTG(ADoc.CT_Ground));
    AHiMAP.PT_Ground := Ord(HVCode2HPTG(ADoc.PT_Ground));

    AHiMAP.Communication := Ord(HVCode2HCommunication(ADoc.Communication));
    AHiMAP.ExetndedBoard := Ord(HVCode2HExtBoard(ADoc.ExetndedBoard));
    AHiMAP.SpecialConfig := ADoc.SpecialConfig;
    AHiMAP.NorminalFrequency := Ord(HVCode2HNormalFreq(ADoc.NorminalFrequency));
    AHiMAP.FrontpanelType := Ord(HVCode2HFrontType(ADoc.FrontpanelType));
  end;

  AHiMAP.Recording_Unit := Ord(VCode2HRecordingUnit(ADoc.Recording_Unit));

  AHiMAP.InstalledPanel := Ord(VCode2MSBDPT(ADoc.InstalledPanel));
  AHiMAP.InstallDate := TimeLogFromDateTime(StrToDate(ADoc.InstallDate));
end;

procedure AddOrUpdateHiMAP(AHiMAP:TSQLHiMAPRecord);
begin
  if AHiMAP.IsUpdate then
  begin
    g_HiMAPDB.Update(AHiMAP);
//    ShowMessage('Task Update 완료');
  end
  else
  begin
    g_HiMAPDB.Add(AHiMAP, true);
//    ShowMessage('Task Add 완료');
  end;
end;

{ TSQLHiMAPRecord }

function TSQLHiMAPRecord.GetHiMAPOrderCode: string;
begin
  Result := HPS2HVCode(THiMAP_Power_Supply(Power_Supply)) + '/' +
    HPCT2HVCode(THiMAP_Phase_CT(Phase_CT)) + '/' +
    HPPT2HVCode(THiMAP_Phase_PT(Phase_PT)) + '/' +
    HPCTD2HVCode(THiMAP_Phase_CT_Diff(Phase_CT_Diff)) + '/' +

    HCTG2HVCode(THiMAP_CT_Ground(CT_Ground)) + '/' +
    HPTG2HVCode(THiMAP_PT_Ground(PT_Ground)) + '/' +
    HRecordingUnit2HVCode(THiMAP_Recording_Unit(Recording_Unit)) + '/' +
    HCommunication2HVCode(THiMAP_COMMUNICATION(Communication)) + '/' +
    HExtBoard2HVCode(THiMAP_EXTENDED_BOARD(ExetndedBoard)) + '/' +
    SpecialConfig + '/' +
    HNormalFreq2HVCode(THiMAP_NORMAL_FREQUENCY(NorminalFrequency)) + '/' +
    HFrontType2HVCode(THiMAP_FRONTPANEL_TYPE(FrontpanelType));
end;

function TSQLHiMAPRecord.GetSymapOrderCode: string;
begin
  Result := HDV2VCode(THiMAP_Device_Variant(Device_Variant)) + ' ' +
    HPS2VCode(THiMAP_Power_Supply(Power_Supply)) +
    HPCT2VCode(THiMAP_Phase_CT(Phase_CT)) +
    HPPT2VCode(THiMAP_Phase_PT(Phase_PT)) +
    HPCTD2VCode(THiMAP_Phase_CT_Diff(Phase_CT_Diff)) + '-' +

    HCTG2VCode(THiMAP_CT_Ground(CT_Ground)) +
    HPTG2VCode(THiMAP_PT_Ground(PT_Ground)) +
    HCB2VCode(THiMAP_CANBUS(CANBUS)) +
    HPB2VCode(THiMAP_PROFIBUS(PROFIBUS)) + '-' +

    HSI2VCode(THiMAP_SERIAL_INTERFACE(SERIAL_INTERFACE)) +
    HIEC618502VCode(THiMAP_IEC_61850(IEC_61850)) +
    HAO2VCode(THiMAP_Analog_Output(Analog_Output)) +
    HS12VCode(THiMAP_Shunt1(Shunt1)) + '-' +

    HFrontDesign2VCode(THiMAP_Front_Design(Front_Design)) +
    HRecordingUnit2VCode(THiMAP_Recording_Unit(Recording_Unit));
end;

procedure DeleteHiMAPFromIMONo_InstalledPnl_DeviceType(const AIMONo: string;
  const AInstalledPnl, ADeviceType, ADeviceVariant: integer);
var
  LSQLHiMAPRecord: TSQLHiMAPRecord;
begin
  LSQLHiMAPRecord := GetHiMAPFromIMONo_InstalledPnl_DeviceType(AIMONo, AInstalledPnl, ADeviceType, ADeviceVariant);
  try
    if LSQLHiMAPRecord.FillOne then
      g_HiMAPDB.Delete(TSQLHiMAPRecord, LSQLHiMAPRecord.ID);
  finally
    FreeAndNil(LSQLHiMAPRecord);
  end;
end;

initialization

finalization
  if Assigned(HiMAPModel) then
    FreeAndNil(HiMAPModel);

  if Assigned(g_HiMAPDB) then
    FreeAndNil(g_HiMAPDB);

end.


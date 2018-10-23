unit UnitHimsenWearingSpareStationaryRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot, CommonData;

Type
  THimsenWearingSpareSRec = record
    fHullNo,
    fEngineType,
    fTCModel,
    fRunningHour,
    fCylCount,
    fRatedRPM,
    fMainBearingMaker
    : RawUtf8;
    fTierStep: integer;
  end;

  TSQLHimsenWearingSpareStationary = class(TSQLRecord)
  private
    fEngineType,
    fMSNo, fMSDesc,
    fPartNo, fPartDesc,
    fSectionNo,
    fPlateNo,
    fDrawingNo,
    fUsedAmount,//기본 사용 수량(n)     -> 최종 수량 계산식: n*cyl + z
    fSpareAmount,//추가 사용 수량(z)
    fPartUnit,
//    fCalcFormula,
    fHRS3000Formula,
    fHRS6000Formula,
    fHRS9000Formula,
    fHRS12000Formula,
    fHRS15000Formula,
    fHRS18000Formula,
    fHRS21000Formula,
    fHRS24000Formula,
    fHRS27000Formula,
    fHRS30000Formula,
    fHRS33000Formula,
    fHRS36000Formula,
    fHRS39000Formula,
    fHRS42000Formula,
    fHRS45000Formula,
    fHRS48000Formula,
    fAdaptedCylCount,  //5,6,7 형식으로 저장 됨
    fTurboChargerModel, // HPR3000;TPS48 형식으로 저장 됨
    fRatedRPM,           //720RPM 또는 900RPM 형식으로 저장 됨
    fMainBearingMaker //Miba 또는 Daido
    : RawUTF8;

    fHRS3000ApplyNo,
    fHRS6000ApplyNo,
    fHRS9000ApplyNo,
    fHRS12000ApplyNo,
    fHRS15000ApplyNo,
    fHRS18000ApplyNo,
    fHRS21000ApplyNo,
    fHRS24000ApplyNo,
    fHRS27000ApplyNo,
    fHRS30000ApplyNo,
    fHRS33000ApplyNo,
    fHRS36000ApplyNo,
    fHRS39000ApplyNo,
    fHRS42000ApplyNo,
    fHRS45000ApplyNo,
    fHRS48000ApplyNo
    : integer;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property EngineType: RawUTF8 read fEngineType write fEngineType;
    property MSNo: RawUTF8 read fMSNo write fMSNo;
    property MSDesc: RawUTF8 read fMSDesc write fMSDesc;
    property PartNo: RawUTF8 read fPartNo write fPartNo;
    property PartDesc: RawUTF8 read fPartDesc write fPartDesc;
    property SectionNo: RawUTF8 read fSectionNo write fSectionNo;
    property PlateNo: RawUTF8 read fPlateNo write fPlateNo;
    property DrawingNo: RawUTF8 read fDrawingNo write fDrawingNo;
    property UsedAmount: RawUTF8 read fUsedAmount write fUsedAmount;
    property SpareAmount: RawUTF8 read fSpareAmount write fSpareAmount;
    property PartUnit: RawUTF8 read fPartUnit write fPartUnit;
//    property CalcFormula: RawUTF8 read fCalcFormula write fCalcFormula;
    property HRS3000Formula: RawUTF8 read fHRS3000Formula write fHRS3000Formula;
    property HRS6000Formula: RawUTF8 read fHRS6000Formula write fHRS6000Formula;
    property HRS9000Formula: RawUTF8 read fHRS9000Formula write fHRS9000Formula;
    property HRS12000Formula: RawUTF8 read fHRS12000Formula write fHRS12000Formula;
    property HRS15000Formula: RawUTF8 read fHRS15000Formula write fHRS15000Formula;
    property HRS18000Formula: RawUTF8 read fHRS18000Formula write fHRS18000Formula;
    property HRS21000Formula: RawUTF8 read fHRS21000Formula write fHRS21000Formula;
    property HRS24000Formula: RawUTF8 read fHRS24000Formula write fHRS24000Formula;
    property HRS27000Formula: RawUTF8 read fHRS27000Formula write fHRS27000Formula;
    property HRS30000Formula: RawUTF8 read fHRS30000Formula write fHRS30000Formula;
    property HRS33000Formula: RawUTF8 read fHRS33000Formula write fHRS33000Formula;
    property HRS36000Formula: RawUTF8 read fHRS36000Formula write fHRS36000Formula;
    property HRS39000Formula: RawUTF8 read fHRS39000Formula write fHRS39000Formula;
    property HRS42000Formula: RawUTF8 read fHRS42000Formula write fHRS42000Formula;
    property HRS45000Formula: RawUTF8 read fHRS45000Formula write fHRS45000Formula;
    property HRS48000Formula: RawUTF8 read fHRS48000Formula write fHRS48000Formula;

    property AdaptedCylCount: RawUTF8 read fAdaptedCylCount write fAdaptedCylCount;
    property TurboChargerModel: RawUTF8 read fTurboChargerModel write fTurboChargerModel;
    property RatedRPM: RawUTF8 read fRatedRPM write fRatedRPM;
    property MainBearingMaker: RawUTF8 read fMainBearingMaker write fMainBearingMaker;

    property HRS3000ApplyNo: integer read fHRS3000ApplyNo write fHRS3000ApplyNo;
    property HRS6000ApplyNo: integer read fHRS6000ApplyNo write fHRS6000ApplyNo;
    property HRS9000ApplyNo: integer read fHRS9000ApplyNo write fHRS9000ApplyNo;
    property HRS12000ApplyNo: integer read fHRS12000ApplyNo write fHRS12000ApplyNo;
    property HRS15000ApplyNo: integer read fHRS15000ApplyNo write fHRS15000ApplyNo;
    property HRS18000ApplyNo: integer read fHRS18000ApplyNo write fHRS18000ApplyNo;
    property HRS21000ApplyNo: integer read fHRS21000ApplyNo write fHRS21000ApplyNo;
    property HRS24000ApplyNo: integer read fHRS24000ApplyNo write fHRS24000ApplyNo;
    property HRS27000ApplyNo: integer read fHRS27000ApplyNo write fHRS27000ApplyNo;
    property HRS30000ApplyNo: integer read fHRS30000ApplyNo write fHRS30000ApplyNo;
    property HRS33000ApplyNo: integer read fHRS33000ApplyNo write fHRS33000ApplyNo;
    property HRS36000ApplyNo: integer read fHRS36000ApplyNo write fHRS36000ApplyNo;
    property HRS39000ApplyNo: integer read fHRS39000ApplyNo write fHRS39000ApplyNo;
    property HRS42000ApplyNo: integer read fHRS42000ApplyNo write fHRS42000ApplyNo;
    property HRS45000ApplyNo: integer read fHRS45000ApplyNo write fHRS45000ApplyNo;
    property HRS48000ApplyNo: integer read fHRS48000ApplyNo write fHRS48000ApplyNo;
  end;

  TSQLHimsenWearingSpareStationaryTierII = class(TSQLHimsenWearingSpareStationary)

  end;

  TSQLHimsenWearingSpareStationaryTierIII = class(TSQLHimsenWearingSpareStationary)

  end;

procedure InitHimsenWearingSpareSClient(AExeName: string);
function CreateHimsenWearingSpareSModel: TSQLModel;

procedure AddHimsenWaringSpareSFromVariant(ADoc: variant; ATierStep: integer);
procedure LoadHimsenWaringSpareSFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareStationary; ADoc: variant);
procedure AddOrUpdateHimsenWaringSpareS(AHimsenWaringSpare: TSQLHimsenWearingSpareStationary;
  ATierStep: integer);

procedure DeleteEngineTypeSFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareSRec);

function GetHimsenWaringSpareSFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareSRec): TSQLHimsenWearingSpareStationary;
function GetVariantFromHimsenWearingSpareS(AHimsenWearingSpare:TSQLHimsenWearingSpareStationary): variant;

procedure GetRunHour2List4S(var AList: TStrings);

var
  g_HimsenWaringSpareSDB: TSQLRestClientURI;
  HimsenWaringSpareSModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils,UnitFolderUtil, UnitRttiUtil;

procedure InitHimsenWearingSpareSClient(AExeName: string);
var
  LStr: string;
begin
//  LStr := ChangeFileExt(AExeName,'_S.sqlite');
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + ChangeFileExt(ExtractFileName(AExeName),'_S.sqlite');
  HimsenWaringSpareSModel := CreateHimsenWearingSpareSModel;
  g_HimsenWaringSpareSDB:= TSQLRestClientDB.Create(HimsenWaringSpareSModel, CreateHimsenWearingSpareSModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HimsenWaringSpareSDB).Server.CreateMissingTables;
end;

function CreateHimsenWearingSpareSModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHimsenWearingSpareStationary,
    TSQLHimsenWearingSpareStationaryTierII,
    TSQLHimsenWearingSpareStationaryTierIII]);
end;

procedure AddHimsenWaringSpareSFromVariant(ADoc: variant; ATierStep: integer);
var
  LSQLHimsenWearingSpare: TSQLHimsenWearingSpareStationary;
begin
  if TTierStep(ATierStep) = tsTierI then
    LSQLHimsenWearingSpare := TSQLHimsenWearingSpareStationary.Create
  else
  if TTierStep(ATierStep) = tsTierII then
    LSQLHimsenWearingSpare := TSQLHimsenWearingSpareStationary(TSQLHimsenWearingSpareStationaryTierII.Create);

  LSQLHimsenWearingSpare.IsUpdate := False;

  try
    LoadHimsenWaringSpareSFromVariant(LSQLHimsenWearingSpare, ADoc);
    AddOrUpdateHimsenWaringSpareS(LSQLHimsenWearingSpare, ATierStep);
  finally
    FreeAndNil(LSQLHimsenWearingSpare);
  end;
end;

procedure LoadHimsenWaringSpareSFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareStationary; ADoc: variant);
begin
  if ADoc = null then
    exit;

  LoadRecordPropertyFromVariant(AHimsenWaringSpare, ADoc);

  //  AHimsenWaringSpare.EngineType := ADoc.EngineType;
//  AHimsenWaringSpare.MSNo := ADoc.MSNo;
//  AHimsenWaringSpare.MSDesc := ADoc.MSDesc;
//  AHimsenWaringSpare.PartNo := ADoc.PartNo;
//  AHimsenWaringSpare.PartDesc := ADoc.PartDesc;
//  AHimsenWaringSpare.SectionNo := ADoc.SectionNo;
//  AHimsenWaringSpare.PlateNo := ADoc.PlateNo;
//  AHimsenWaringSpare.DrawingNo := ADoc.DrawingNo;
//  AHimsenWaringSpare.UsedAmount := ADoc.UsedAmount;
//  AHimsenWaringSpare.SpareAmount := ADoc.SpareAmount;
//  AHimsenWaringSpare.PartUnit := ADoc.PartUnit;
////  AHimsenWaringSpare.CalcFormula := ADoc.CalcFormula;
//  AHimsenWaringSpare.HRS3000Formula := ADoc.HRS3000Formula;
//  AHimsenWaringSpare.HRS6000Formula := ADoc.HRS6000Formula;
//  AHimsenWaringSpare.HRS9000Formula := ADoc.HRS9000Formula;
//  AHimsenWaringSpare.HRS12000Formula := ADoc.HRS12000Formula;
//  AHimsenWaringSpare.HRS15000Formula := ADoc.HRS15000Formula;
//  AHimsenWaringSpare.HRS18000Formula := ADoc.HRS18000Formula;
//  AHimsenWaringSpare.HRS21000Formula := ADoc.HRS21000Formula;
//  AHimsenWaringSpare.HRS24000Formula := ADoc.HRS24000Formula;
//  AHimsenWaringSpare.HRS27000Formula := ADoc.HRS27000Formula;
//  AHimsenWaringSpare.HRS30000Formula := ADoc.HRS30000Formula;
//  AHimsenWaringSpare.HRS33000Formula := ADoc.HRS33000Formula;
//  AHimsenWaringSpare.HRS36000Formula := ADoc.HRS36000Formula;
//  AHimsenWaringSpare.HRS39000Formula := ADoc.HRS39000Formula;
//  AHimsenWaringSpare.HRS42000Formula := ADoc.HRS42000Formula;
//  AHimsenWaringSpare.HRS45000Formula := ADoc.HRS45000Formula;
//  AHimsenWaringSpare.HRS48000Formula := ADoc.HRS48000Formula;
//
//  AHimsenWaringSpare.AdaptedCylCount := ADoc.AdaptedCylCount;
//  AHimsenWaringSpare.TurboChargerModel := ADoc.TurboChargerModel;
//  AHimsenWaringSpare.RatedRPM := ADoc.RatedRPM;
//  AHimsenWaringSpare.MainBearingMaker := ADoc.MainBearingMaker;
//
//  AHimsenWaringSpare.HRS3000ApplyNo := ADoc.HRS3000ApplyNo;
//  AHimsenWaringSpare.HRS6000ApplyNo := ADoc.HRS6000ApplyNo;
//  AHimsenWaringSpare.HRS9000ApplyNo := ADoc.HRS9000ApplyNo;
//  AHimsenWaringSpare.HRS12000ApplyNo := ADoc.HRS12000ApplyNo;
//  AHimsenWaringSpare.HRS15000ApplyNo := ADoc.HRS15000ApplyNo;
//  AHimsenWaringSpare.HRS18000ApplyNo := ADoc.HRS18000ApplyNo;
//  AHimsenWaringSpare.HRS21000ApplyNo := ADoc.HRS21000ApplyNo;
//  AHimsenWaringSpare.HRS24000ApplyNo := ADoc.HRS24000ApplyNo;
//  AHimsenWaringSpare.HRS27000ApplyNo := ADoc.HRS27000ApplyNo;
//  AHimsenWaringSpare.HRS30000ApplyNo := ADoc.HRS30000ApplyNo;
//  AHimsenWaringSpare.HRS33000ApplyNo := ADoc.HRS33000ApplyNo;
//  AHimsenWaringSpare.HRS36000ApplyNo := ADoc.HRS36000ApplyNo;
//  AHimsenWaringSpare.HRS39000ApplyNo := ADoc.HRS39000ApplyNo;
//  AHimsenWaringSpare.HRS42000ApplyNo := ADoc.HRS42000ApplyNo;
//  AHimsenWaringSpare.HRS45000ApplyNo := ADoc.HRS45000ApplyNo;
//  AHimsenWaringSpare.HRS48000ApplyNo := ADoc.HRS48000ApplyNo;
end;

procedure AddOrUpdateHimsenWaringSpareS(AHimsenWaringSpare: TSQLHimsenWearingSpareStationary;
  ATierStep: integer);
begin
  if AHimsenWaringSpare.IsUpdate then
  begin
    if TTierStep(ATierStep) = tsTierI then
      g_HimsenWaringSpareSDB.Update(AHimsenWaringSpare)
    else
    if TTierStep(ATierStep) = tsTierII then
      g_HimsenWaringSpareSDB.Update(TSQLHimsenWearingSpareStationaryTierII(AHimsenWaringSpare));
  end
  else
  begin
    if TTierStep(ATierStep) = tsTierI then
      g_HimsenWaringSpareSDB.Add(AHimsenWaringSpare, true)
    else
    if TTierStep(ATierStep) = tsTierII then
      g_HimsenWaringSpareSDB.Add(TSQLHimsenWearingSpareStationaryTierII(AHimsenWaringSpare), true);
  end;
end;

procedure DeleteEngineTypeSFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareSRec);
var
  LSQL: TSQLHimsenWearingSpareStationary;
begin
  LSQL := GetHimsenWaringSpareSFromSearchRec(AHimsenWearingSpareParamRec);

  if LSQL.IsUpdate then
  begin
    g_HimsenWaringSpareSDB.Delete(TSQLHimsenWearingSpareStationary, 'EngineType = ?', [AHimsenWearingSpareParamRec.fEngineType]);
  end;
end;

function GetHimsenWaringSpareSFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareSRec): TSQLHimsenWearingSpareStationary;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if AHimsenWearingSpareParamRec.fEngineType <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AHimsenWearingSpareParamRec.fEngineType+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'EngineType LIKE ? ';
    end;

    if AHimsenWearingSpareParamRec.fCylCount <> '' then
    begin
      AddConstArray(ConstArray, ['*']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + '(AdaptedCylCount = ? ';

      AddConstArray(ConstArray, ['%'+AHimsenWearingSpareParamRec.fCylCount+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' or ';
      LWhere := LWhere + 'AdaptedCylCount LIKE ?) ';
    end;

    if AHimsenWearingSpareParamRec.fTCModel <> '' then
    begin
      AddConstArray(ConstArray, ['*']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + '(TurboChargerModel = ? ';

      AddConstArray(ConstArray, ['%'+AHimsenWearingSpareParamRec.fTCModel+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' or ';
      LWhere := LWhere + 'TurboChargerModel LIKE ?) ';
    end;

    if AHimsenWearingSpareParamRec.fRatedRPM <> '' then
    begin
      AddConstArray(ConstArray, ['*']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + '(RatedRPM = ? ';

      AddConstArray(ConstArray, ['%'+AHimsenWearingSpareParamRec.fRatedRPM+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' or ';
      LWhere := LWhere + 'RatedRPM LIKE ?) ';
    end;

    if AHimsenWearingSpareParamRec.fRunningHour <> '' then
    begin
//      LRunhour := StrToIntDef(AHimsenWearingSpareParamRec.fRunningHour, 0);
      AddConstArray(ConstArray, [0]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + ' HRS' + AHimsenWearingSpareParamRec.fRunningHour + 'ApplyNo <> ?';// +'RunningHour LIKE ? ';
    end;

    if AHimsenWearingSpareParamRec.fMainBearingMaker <> '' then
    begin
      AddConstArray(ConstArray, ['*']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + '(MainBearingMaker = ? ';

      AddConstArray(ConstArray, ['%'+AHimsenWearingSpareParamRec.fMainBearingMaker+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' or ';
      LWhere := LWhere + 'MainBearingMaker LIKE ?) ';
    end;

//    if AHimsenWearingSpareParamRec.fCylCount <> '' then
//    begin
//      AddConstArray(ConstArray, ['%'+AHimsenWearingSpareParamRec.fCylCount+'%']);
//      if LWhere <> '' then
//        LWhere := LWhere + ' and ';
//      LWhere := LWhere + 'CylCount LIKE ? ';
//    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    case TTierStep(AHimsenWearingSpareParamRec.fTierStep) of
      tsTierI: Result := TSQLHimsenWearingSpareStationary.CreateAndFillPrepare(g_HimsenWaringSpareSDB, Lwhere, ConstArray);
      tsTierII: Result := TSQLHimsenWearingSpareStationary(
        TSQLHimsenWearingSpareStationaryTierII.CreateAndFillPrepare(g_HimsenWaringSpareSDB, Lwhere, ConstArray));
    end;

    Result.IsUpdate := Result.FillOne;
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

function GetVariantFromHimsenWearingSpareS(AHimsenWearingSpare:TSQLHimsenWearingSpareStationary): variant;
begin
  TDocVariant.New(Result);

  LoadRecordPropertyToVariant(AHimsenWearingSpare, Result);

//  Result.EngineType := AHimsenWearingSpare.EngineType;
//  Result.MSNo := AHimsenWearingSpare.MSNo;
//  Result.MSDesc := AHimsenWearingSpare.MSDesc;
//  Result.PartNo := AHimsenWearingSpare.PartNo;
//  Result.PartDesc := AHimsenWearingSpare.PartDesc;
//  Result.SectionNo := AHimsenWearingSpare.SectionNo;
//  Result.PlateNo := AHimsenWearingSpare.PlateNo;
//  Result.DrawingNo := AHimsenWearingSpare.DrawingNo;
//  Result.UsedAmount := AHimsenWearingSpare.UsedAmount;
//  Result.SpareAmount := AHimsenWearingSpare.SpareAmount;
//  Result.PartUnit := AHimsenWearingSpare.PartUnit;
////  Result.CalcFormula := AHimsenWearingSpare.CalcFormula;
//  Result.HRS3000Formula := AHimsenWearingSpare.HRS3000Formula;
//  Result.HRS6000Formula := AHimsenWearingSpare.HRS6000Formula;
//  Result.HRS9000Formula := AHimsenWearingSpare.HRS9000Formula;
//  Result.HRS12000Formula := AHimsenWearingSpare.HRS12000Formula;
//  Result.HRS15000Formula := AHimsenWearingSpare.HRS15000Formula;
//  Result.HRS18000Formula := AHimsenWearingSpare.HRS18000Formula;
//  Result.HRS21000Formula := AHimsenWearingSpare.HRS21000Formula;
//  Result.HRS24000Formula := AHimsenWearingSpare.HRS24000Formula;
//  Result.HRS27000Formula := AHimsenWearingSpare.HRS27000Formula;
//  Result.HRS30000Formula := AHimsenWearingSpare.HRS30000Formula;
//  Result.HRS33000Formula := AHimsenWearingSpare.HRS33000Formula;
//  Result.HRS36000Formula := AHimsenWearingSpare.HRS36000Formula;
//  Result.HRS39000Formula := AHimsenWearingSpare.HRS39000Formula;
//  Result.HRS42000Formula := AHimsenWearingSpare.HRS42000Formula;
//  Result.HRS45000Formula := AHimsenWearingSpare.HRS45000Formula;
//  Result.HRS48000Formula := AHimsenWearingSpare.HRS48000Formula;
//
//  Result.AdaptedCylCount := AHimsenWearingSpare.AdaptedCylCount;
//  Result.TurboChargerModel := AHimsenWearingSpare.TurboChargerModel;
//  Result.RatedRPM := AHimsenWearingSpare.RatedRPM;
//
//  Result.HRS3000ApplyNo := AHimsenWearingSpare.HRS3000ApplyNo;
//  Result.HRS6000ApplyNo := AHimsenWearingSpare.HRS6000ApplyNo;
//  Result.HRS9000ApplyNo := AHimsenWearingSpare.HRS9000ApplyNo;
//  Result.HRS12000ApplyNo := AHimsenWearingSpare.HRS12000ApplyNo;
//  Result.HRS15000ApplyNo := AHimsenWearingSpare.HRS15000ApplyNo;
//  Result.HRS18000ApplyNo := AHimsenWearingSpare.HRS18000ApplyNo;
//  Result.HRS21000ApplyNo := AHimsenWearingSpare.HRS21000ApplyNo;
//  Result.HRS24000ApplyNo := AHimsenWearingSpare.HRS24000ApplyNo;
//  Result.HRS27000ApplyNo := AHimsenWearingSpare.HRS27000ApplyNo;
//  Result.HRS30000ApplyNo := AHimsenWearingSpare.HRS30000ApplyNo;
//  Result.HRS33000ApplyNo := AHimsenWearingSpare.HRS33000ApplyNo;
//  Result.HRS36000ApplyNo := AHimsenWearingSpare.HRS36000ApplyNo;
//  Result.HRS39000ApplyNo := AHimsenWearingSpare.HRS39000ApplyNo;
//  Result.HRS42000ApplyNo := AHimsenWearingSpare.HRS42000ApplyNo;
//  Result.HRS45000ApplyNo := AHimsenWearingSpare.HRS45000ApplyNo;
//  Result.HRS48000ApplyNo := AHimsenWearingSpare.HRS48000ApplyNo;
end;

procedure GetRunHour2List4S(var AList: TStrings);
begin
  AList.Clear;

  AList.Add('3000');
  AList.Add('6000');
  AList.Add('9000');
  AList.Add('12000');
  AList.Add('15000');
  AList.Add('18000');
  AList.Add('21000');
  AList.Add('24000');
  AList.Add('27000');
  AList.Add('30000');
  AList.Add('33000');
  AList.Add('36000');
  AList.Add('39000');
  AList.Add('42000');
  AList.Add('45000');
  AList.Add('48000');
end;

initialization

finalization
  if Assigned(g_HimsenWaringSpareSDB) then
    FreeAndNil(g_HimsenWaringSpareSDB);

end.

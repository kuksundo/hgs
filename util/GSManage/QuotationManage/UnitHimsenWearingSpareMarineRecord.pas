unit UnitHimsenWearingSpareMarineRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot, CommonData, UnitEngineMasterData;

Type
  THimsenWearingSpareMRec = record
    fHullNo,
    fEngineType,
    fTCModel,
    fRunningHour,
    fCylCount,
    fRatedRPM
    : RawUtf8;
    fTierStep: integer;
  end;

  TSQLHimsenWearingSpareMarine = class(TSQLRecord)
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
    fHRS4000Formula,
    fHRS8000Formula,
    fHRS12000Formula,
    fHRS16000Formula,
    fHRS20000Formula,
    fHRS24000Formula,
    fHRS28000Formula,
    fHRS32000Formula,
    fHRS36000Formula,
    fHRS40000Formula,
    fHRS44000Formula,
    fHRS48000Formula,
    fHRS60000Formula,
    fHRS72000Formula,
    fHRS88000Formula,
    fHRS100000Formula,

    fAdaptedCylCount,  //5,6,7 형식으로 저장 됨
    fTurboChargerModel, // HPR3000;TPS48 형식으로 저장 됨
    fRatedRPM           //720RPM 또는 900RPM 형식으로 저장 됨
    : RawUTF8;

    fHRS4000ApplyNo,
    fHRS8000ApplyNo,
    fHRS12000ApplyNo,
    fHRS16000ApplyNo,
    fHRS20000ApplyNo,
    fHRS24000ApplyNo,
    fHRS28000ApplyNo,
    fHRS32000ApplyNo,
    fHRS36000ApplyNo,
    fHRS40000ApplyNo,
    fHRS44000ApplyNo,
    fHRS48000ApplyNo,
    fHRS60000ApplyNo,
    fHRS72000ApplyNo,
    fHRS88000ApplyNo,
    fHRS100000ApplyNo
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
    property HRS4000Formula: RawUTF8 read fHRS4000Formula write fHRS4000Formula;
    property HRS8000Formula: RawUTF8 read fHRS8000Formula write fHRS8000Formula;
    property HRS12000Formula: RawUTF8 read fHRS12000Formula write fHRS12000Formula;
    property HRS16000Formula: RawUTF8 read fHRS16000Formula write fHRS16000Formula;
    property HRS20000Formula: RawUTF8 read fHRS20000Formula write fHRS20000Formula;
    property HRS24000Formula: RawUTF8 read fHRS24000Formula write fHRS24000Formula;
    property HRS28000Formula: RawUTF8 read fHRS28000Formula write fHRS28000Formula;
    property HRS32000Formula: RawUTF8 read fHRS32000Formula write fHRS32000Formula;
    property HRS36000Formula: RawUTF8 read fHRS36000Formula write fHRS36000Formula;
    property HRS40000Formula: RawUTF8 read fHRS40000Formula write fHRS40000Formula;
    property HRS44000Formula: RawUTF8 read fHRS44000Formula write fHRS44000Formula;
    property HRS48000Formula: RawUTF8 read fHRS48000Formula write fHRS48000Formula;
    property HRS60000Formula: RawUTF8 read fHRS60000Formula write fHRS60000Formula;
    property HRS72000Formula: RawUTF8 read fHRS72000Formula write fHRS72000Formula;
    property HRS88000Formula: RawUTF8 read fHRS88000Formula write fHRS88000Formula;
    property HRS100000Formula: RawUTF8 read fHRS100000Formula write fHRS100000Formula;
    property AdaptedCylCount: RawUTF8 read fAdaptedCylCount write fAdaptedCylCount;
    property TurboChargerModel: RawUTF8 read fTurboChargerModel write fTurboChargerModel;
    property RatedRPM: RawUTF8 read fRatedRPM write fRatedRPM;

    property HRS4000ApplyNo: integer read fHRS4000ApplyNo write fHRS4000ApplyNo;
    property HRS8000ApplyNo: integer read fHRS8000ApplyNo write fHRS8000ApplyNo;
    property HRS12000ApplyNo: integer read fHRS12000ApplyNo write fHRS12000ApplyNo;
    property HRS16000ApplyNo: integer read fHRS16000ApplyNo write fHRS16000ApplyNo;
    property HRS20000ApplyNo: integer read fHRS20000ApplyNo write fHRS20000ApplyNo;
    property HRS24000ApplyNo: integer read fHRS24000ApplyNo write fHRS24000ApplyNo;
    property HRS28000ApplyNo: integer read fHRS28000ApplyNo write fHRS28000ApplyNo;
    property HRS32000ApplyNo: integer read fHRS32000ApplyNo write fHRS32000ApplyNo;
    property HRS36000ApplyNo: integer read fHRS36000ApplyNo write fHRS36000ApplyNo;
    property HRS40000ApplyNo: integer read fHRS40000ApplyNo write fHRS40000ApplyNo;
    property HRS44000ApplyNo: integer read fHRS44000ApplyNo write fHRS44000ApplyNo;
    property HRS48000ApplyNo: integer read fHRS48000ApplyNo write fHRS48000ApplyNo;
    property HRS60000ApplyNo: integer read fHRS60000ApplyNo write fHRS60000ApplyNo;
    property HRS72000ApplyNo: integer read fHRS72000ApplyNo write fHRS72000ApplyNo;
    property HRS88000ApplyNo: integer read fHRS88000ApplyNo write fHRS88000ApplyNo;
    property HRS100000ApplyNo: integer read fHRS100000ApplyNo write fHRS100000ApplyNo;
  end;

  TSQLHimsenWearingSpareMarineTierII = class(TSQLHimsenWearingSpareMarine)

  end;

  TSQLHimsenWearingSpareMarineTierIII = class(TSQLHimsenWearingSpareMarine)

  end;

//  TSQLEngineTier = class(TSQLRecord)
//  private
//    fEngineModel: RawUtf8;
//    fEngineType: RawUtf8;
//    fTCModel: RawUtf8;
//    fBore,
//    fTier
//    : integer;
//
//    fUpdatedDate: TTimeLog;
//  public
//    fIsUpdate: Boolean;
//    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
//  published
//    property Tier: integer read fTier write fTier;
//    property EngineModel: RawUTF8 read fEngineModel write fEngineModel;
//    property EngineType: RawUTF8 read fEngineType write fEngineType;
//    property TCModel: RawUTF8 read fTCModel write fTCModel;
//    property Bore: integer read fBore write fBore;
//    property UpdatedDate: TTimeLog read fUpdatedDate write fUpdatedDate;
//  end;

  TSQLHimsenWearingSpareRunHour = class(TSQLRecord)
  private
    fPlateNo
    : RawUTF8;

    fRunningHour,
    fApplyNo
    : integer;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    //ParentID = EntryID + StoreID
    property PlateNo: RawUTF8 read fPlateNo write fPlateNo;
    property RunningHour: integer read fRunningHour write fRunningHour;
    property ApplyNo: integer read fApplyNo write fApplyNo;
  end;

  TSQLWearingSpareMany = class(TSQLRecordMany)
  private
    fSource: TSQLHimsenWearingSpareMarine;
    fDest: TSQLHimsenWearingSpareRunHour;
  published
    property Source: TSQLHimsenWearingSpareMarine read fSource;
    property Dest: TSQLHimsenWearingSpareRunHour read fDest;
  end;

procedure InitHimsenWearingSpareMClient(AExeName: string);
function CreateHimsenWearingSpareMModel: TSQLModel;

procedure AddHimsenWaringSpareMFromVariant(ADoc: variant; ATierStep: integer);
procedure LoadHimsenWaringSpareMFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareMarine;
  ADoc: variant);
procedure AddOrUpdateHimsenWaringSpareM(AHimsenWaringSpare: TSQLHimsenWearingSpareMarine;
  ATierStep: integer);

procedure DeleteEngineTypeMFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareMRec);

function GetHimsenWaringSpareMFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareMRec): TSQLHimsenWearingSpareMarine;
function GetVariantFromHimsenWearingSpareM(AHimsenWearingSpare:TSQLHimsenWearingSpareMarine): variant;

procedure GetRunHour2List4M(var AList: TStrings);

var
  g_HimsenWaringSpareMDB: TSQLRestClientURI;
  HimsenWaringSpareMModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, UnitFolderUtil;

procedure InitHimsenWearingSpareMClient(AExeName: string);
var
  LStr: string;
begin
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + ChangeFileExt(ExtractFileName(AExeName),'_M.sqlite');
  HimsenWaringSpareMModel:= CreateHimsenWearingSpareMModel;
  g_HimsenWaringSpareMDB:= TSQLRestClientDB.Create(HimsenWaringSpareMModel, CreateHimsenWearingSpareMModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HimsenWaringSpareMDB).Server.CreateMissingTables;
end;

function CreateHimsenWearingSpareMModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHimsenWearingSpareMarine,
    TSQLHimsenWearingSpareMarineTierII, TSQLHimsenWearingSpareMarineTierIII]);
end;

procedure AddHimsenWaringSpareMFromVariant(ADoc: variant; ATierStep: integer);
var
  LSQLHimsenWearingSpare: TSQLHimsenWearingSpareMarine;
begin
  if TTierStep(ATierStep) = tsTierI then
    LSQLHimsenWearingSpare := TSQLHimsenWearingSpareMarine.Create
  else
  if TTierStep(ATierStep) = tsTierII then
    LSQLHimsenWearingSpare := TSQLHimsenWearingSpareMarine(TSQLHimsenWearingSpareMarineTierII.Create);

  LSQLHimsenWearingSpare.IsUpdate := False;

  try
    LoadHimsenWaringSpareMFromVariant(LSQLHimsenWearingSpare, ADoc);
    AddOrUpdateHimsenWaringSpareM(LSQLHimsenWearingSpare, ATierStep);
  finally
    FreeAndNil(LSQLHimsenWearingSpare);
  end;
end;

procedure LoadHimsenWaringSpareMFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareMarine;
  ADoc: variant);
begin
  if ADoc = null then
    exit;

  AHimsenWaringSpare.EngineType := ADoc.EngineType;
  AHimsenWaringSpare.MSNo := ADoc.MSNo;
  AHimsenWaringSpare.MSDesc := ADoc.MSDesc;
  AHimsenWaringSpare.PartNo := ADoc.PartNo;
  AHimsenWaringSpare.PartDesc := ADoc.PartDesc;
  AHimsenWaringSpare.SectionNo := ADoc.SectionNo;
  AHimsenWaringSpare.PlateNo := ADoc.PlateNo;
  AHimsenWaringSpare.DrawingNo := ADoc.DrawingNo;
  AHimsenWaringSpare.UsedAmount := ADoc.UsedAmount;
  AHimsenWaringSpare.SpareAmount := ADoc.SpareAmount;
  AHimsenWaringSpare.PartUnit := ADoc.PartUnit;
//  AHimsenWaringSpare.CalcFormula := ADoc.CalcFormula;
  AHimsenWaringSpare.HRS4000Formula := ADoc.HRS4000Formula;
  AHimsenWaringSpare.HRS8000Formula := ADoc.HRS8000Formula;
  AHimsenWaringSpare.HRS12000Formula := ADoc.HRS12000Formula;
  AHimsenWaringSpare.HRS16000Formula := ADoc.HRS16000Formula;
  AHimsenWaringSpare.HRS20000Formula := ADoc.HRS20000Formula;
  AHimsenWaringSpare.HRS24000Formula := ADoc.HRS24000Formula;
  AHimsenWaringSpare.HRS28000Formula := ADoc.HRS28000Formula;
  AHimsenWaringSpare.HRS32000Formula := ADoc.HRS32000Formula;
  AHimsenWaringSpare.HRS36000Formula := ADoc.HRS36000Formula;
  AHimsenWaringSpare.HRS40000Formula := ADoc.HRS40000Formula;
  AHimsenWaringSpare.HRS44000Formula := ADoc.HRS44000Formula;
  AHimsenWaringSpare.HRS48000Formula := ADoc.HRS48000Formula;
  AHimsenWaringSpare.HRS60000Formula := ADoc.HRS60000Formula;
  AHimsenWaringSpare.HRS72000Formula := ADoc.HRS72000Formula;
  AHimsenWaringSpare.HRS88000Formula := ADoc.HRS88000Formula;
  AHimsenWaringSpare.HRS100000Formula := ADoc.HRS100000Formula;

  AHimsenWaringSpare.AdaptedCylCount := ADoc.AdaptedCylCount;
  AHimsenWaringSpare.TurboChargerModel := ADoc.TurboChargerModel;
  AHimsenWaringSpare.RatedRPM := ADoc.RatedRPM;

  AHimsenWaringSpare.HRS4000ApplyNo := ADoc.HRS4000ApplyNo;
  AHimsenWaringSpare.HRS8000ApplyNo := ADoc.HRS8000ApplyNo;
  AHimsenWaringSpare.HRS12000ApplyNo := ADoc.HRS12000ApplyNo;
  AHimsenWaringSpare.HRS16000ApplyNo := ADoc.HRS16000ApplyNo;
  AHimsenWaringSpare.HRS20000ApplyNo := ADoc.HRS20000ApplyNo;
  AHimsenWaringSpare.HRS24000ApplyNo := ADoc.HRS24000ApplyNo;
  AHimsenWaringSpare.HRS28000ApplyNo := ADoc.HRS28000ApplyNo;
  AHimsenWaringSpare.HRS32000ApplyNo := ADoc.HRS32000ApplyNo;
  AHimsenWaringSpare.HRS36000ApplyNo := ADoc.HRS36000ApplyNo;
  AHimsenWaringSpare.HRS40000ApplyNo := ADoc.HRS40000ApplyNo;
  AHimsenWaringSpare.HRS44000ApplyNo := ADoc.HRS44000ApplyNo;
  AHimsenWaringSpare.HRS48000ApplyNo := ADoc.HRS48000ApplyNo;
  AHimsenWaringSpare.HRS60000ApplyNo := ADoc.HRS60000ApplyNo;
  AHimsenWaringSpare.HRS72000ApplyNo := ADoc.HRS72000ApplyNo;
  AHimsenWaringSpare.HRS88000ApplyNo := ADoc.HRS88000ApplyNo;
  AHimsenWaringSpare.HRS100000ApplyNo := ADoc.HRS100000ApplyNo;
end;

procedure AddOrUpdateHimsenWaringSpareM(AHimsenWaringSpare: TSQLHimsenWearingSpareMarine;
  ATierStep: integer);
begin
  if AHimsenWaringSpare.IsUpdate then
  begin
    if TTierStep(ATierStep) = tsTierI then
      g_HimsenWaringSpareMDB.Update(AHimsenWaringSpare)
    else
    if TTierStep(ATierStep) = tsTierII then
      g_HimsenWaringSpareMDB.Update(TSQLHimsenWearingSpareMarineTierII(AHimsenWaringSpare));
//    ShowMessage('Task Update 완료');
  end
  else
  begin
    if TTierStep(ATierStep) = tsTierI then
      g_HimsenWaringSpareMDB.Add(AHimsenWaringSpare, true)
    else
    if TTierStep(ATierStep) = tsTierII then
      g_HimsenWaringSpareMDB.Add(TSQLHimsenWearingSpareMarineTierII(AHimsenWaringSpare), true);
//    ShowMessage('Task Add 완료');
  end;
end;

procedure DeleteEngineTypeMFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareMRec);
var
  LSQL: TSQLHimsenWearingSpareMarine;
begin
  LSQL := GetHimsenWaringSpareMFromSearchRec(AHimsenWearingSpareParamRec);

  if LSQL.IsUpdate then
  begin
    g_HimsenWaringSpareMDB.Delete(TSQLHimsenWearingSpareMarine, 'EngineType = ?', [AHimsenWearingSpareParamRec.fEngineType]);
  end;
end;

function GetHimsenWaringSpareMFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareMRec): TSQLHimsenWearingSpareMarine;
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
      tsTierI: Result := TSQLHimsenWearingSpareMarine.CreateAndFillPrepare(g_HimsenWaringSpareMDB, Lwhere, ConstArray);
      tsTierII: Result := TSQLHimsenWearingSpareMarine(
        TSQLHimsenWearingSpareMarineTierII.CreateAndFillPrepare(g_HimsenWaringSpareMDB, Lwhere, ConstArray));
    end;

    Result.IsUpdate := Result.FillOne;
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

function GetVariantFromHimsenWearingSpareM(AHimsenWearingSpare:TSQLHimsenWearingSpareMarine): variant;
begin
  TDocVariant.New(Result);

  Result.EngineType := AHimsenWearingSpare.EngineType;
  Result.MSNo := AHimsenWearingSpare.MSNo;
  Result.MSDesc := AHimsenWearingSpare.MSDesc;
  Result.PartNo := AHimsenWearingSpare.PartNo;
  Result.PartDesc := AHimsenWearingSpare.PartDesc;
  Result.SectionNo := AHimsenWearingSpare.SectionNo;
  Result.PlateNo := AHimsenWearingSpare.PlateNo;
  Result.DrawingNo := AHimsenWearingSpare.DrawingNo;
  Result.UsedAmount := AHimsenWearingSpare.UsedAmount;
  Result.SpareAmount := AHimsenWearingSpare.SpareAmount;
  Result.PartUnit := AHimsenWearingSpare.PartUnit;
//  Result.CalcFormula := AHimsenWearingSpare.CalcFormula;
  Result.HRS4000Formula := AHimsenWearingSpare.HRS4000Formula;
  Result.HRS8000Formula := AHimsenWearingSpare.HRS8000Formula;
  Result.HRS12000Formula := AHimsenWearingSpare.HRS12000Formula;
  Result.HRS16000Formula := AHimsenWearingSpare.HRS16000Formula;
  Result.HRS20000Formula := AHimsenWearingSpare.HRS20000Formula;
  Result.HRS24000Formula := AHimsenWearingSpare.HRS24000Formula;
  Result.HRS28000Formula := AHimsenWearingSpare.HRS28000Formula;
  Result.HRS32000Formula := AHimsenWearingSpare.HRS32000Formula;
  Result.HRS36000Formula := AHimsenWearingSpare.HRS36000Formula;
  Result.HRS40000Formula := AHimsenWearingSpare.HRS40000Formula;
  Result.HRS44000Formula := AHimsenWearingSpare.HRS44000Formula;
  Result.HRS48000Formula := AHimsenWearingSpare.HRS48000Formula;
  Result.HRS60000Formula := AHimsenWearingSpare.HRS60000Formula;
  Result.HRS72000Formula := AHimsenWearingSpare.HRS72000Formula;
  Result.HRS88000Formula := AHimsenWearingSpare.HRS88000Formula;
  Result.HRS100000Formula := AHimsenWearingSpare.HRS100000Formula;

  Result.AdaptedCylCount := AHimsenWearingSpare.AdaptedCylCount;
  Result.TurboChargerModel := AHimsenWearingSpare.TurboChargerModel;
  Result.RatedRPM := AHimsenWearingSpare.RatedRPM;

  Result.HRS4000ApplyNo := AHimsenWearingSpare.HRS4000ApplyNo;
  Result.HRS8000ApplyNo := AHimsenWearingSpare.HRS8000ApplyNo;
  Result.HRS12000ApplyNo := AHimsenWearingSpare.HRS12000ApplyNo;
  Result.HRS16000ApplyNo := AHimsenWearingSpare.HRS16000ApplyNo;
  Result.HRS20000ApplyNo := AHimsenWearingSpare.HRS20000ApplyNo;
  Result.HRS24000ApplyNo := AHimsenWearingSpare.HRS24000ApplyNo;
  Result.HRS28000ApplyNo := AHimsenWearingSpare.HRS28000ApplyNo;
  Result.HRS32000ApplyNo := AHimsenWearingSpare.HRS32000ApplyNo;
  Result.HRS36000ApplyNo := AHimsenWearingSpare.HRS36000ApplyNo;
  Result.HRS40000ApplyNo := AHimsenWearingSpare.HRS40000ApplyNo;
  Result.HRS44000ApplyNo := AHimsenWearingSpare.HRS44000ApplyNo;
  Result.HRS48000ApplyNo := AHimsenWearingSpare.HRS48000ApplyNo;
  Result.HRS60000ApplyNo := AHimsenWearingSpare.HRS60000ApplyNo;
  Result.HRS72000ApplyNo := AHimsenWearingSpare.HRS72000ApplyNo;
  Result.HRS88000ApplyNo := AHimsenWearingSpare.HRS88000ApplyNo;
  Result.HRS100000ApplyNo := AHimsenWearingSpare.HRS100000ApplyNo;
end;

procedure GetRunHour2List4M(var AList: TStrings);
begin
  AList.Clear;

  AList.Add('4000');
  AList.Add('8000');
  AList.Add('12000');
  AList.Add('16000');
  AList.Add('20000');
  AList.Add('24000');
  AList.Add('28000');
  AList.Add('32000');
  AList.Add('36000');
  AList.Add('40000');
  AList.Add('44000');
  AList.Add('48000');
  AList.Add('60000');
  AList.Add('72000');
  AList.Add('88000');
  AList.Add('100000');
end;

initialization

finalization
  if Assigned(g_HimsenWaringSpareMDB) then
    FreeAndNil(g_HimsenWaringSpareMDB);

end.

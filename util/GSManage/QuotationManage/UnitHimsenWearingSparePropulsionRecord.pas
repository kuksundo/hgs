unit UnitHimsenWearingSparePropulsionRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot, CommonData, UnitEngineMasterData;

Type
  THimsenWearingSparePRec = record
    fHullNo,
    fEngineType,
    fTCModel,
    fRunningHour,
    fCylCount,
    fRatedRPM
    : RawUtf8;
    fTierStep: integer;
  end;

  TSQLHimsenWearingSparePropulsion = class(TSQLRecord)
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
    fHRS4000Formula,
    fAdaptedCylCount,  //5,6,7 형식으로 저장 됨
    fTurboChargerModel, // HPR3000;TPS48 형식으로 저장 됨
    fRatedRPM           //720RPM 또는 900RPM 형식으로 저장 됨
    : RawUTF8;

    fHRS4000ApplyNo,
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
    property HRS4000Formula: RawUTF8 read fHRS4000Formula write fHRS4000Formula;
    property AdaptedCylCount: RawUTF8 read fAdaptedCylCount write fAdaptedCylCount;
    property TurboChargerModel: RawUTF8 read fTurboChargerModel write fTurboChargerModel;
    property RatedRPM: RawUTF8 read fRatedRPM write fRatedRPM;

    property HRS4000ApplyNo: integer read fHRS4000ApplyNo write fHRS4000ApplyNo;
    property HRS100000ApplyNo: integer read fHRS100000ApplyNo write fHRS100000ApplyNo;
  end;

  TSQLHimsenWearingSparePropulsionTierII = class(TSQLHimsenWearingSparePropulsion)

  end;

  TSQLHimsenWearingSparePropulsionTierIII = class(TSQLHimsenWearingSparePropulsion)

  end;

procedure InitHimsenWearingSparePClient(AExeName: string);
function CreateHimsenWearingSparePModel: TSQLModel;

procedure AddHimsenWearingSparePFromVariant(ADoc: variant; ATierStep: integer);
procedure LoadHimsenWearingSparePFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSparePropulsion;
  ADoc: variant);
procedure AddOrUpdateHimsenWearingSpareP(AHimsenWaringSpare: TSQLHimsenWearingSparePropulsion;
  ATierStep: integer);

procedure DeleteEngineTypePFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSparePRec);

function GetHimsenWearingSparePFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSparePRec): TSQLHimsenWearingSparePropulsion;
function GetVariantFromHimsenWearingSpareP(AHimsenWearingSpare:TSQLHimsenWearingSparePropulsion): variant;

procedure GetRunHour2List4M(var AList: TStrings);

var
  g_HimsenWearingSparePDB: TSQLRestClientURI;
  HimsenWearingSparePModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, UnitFolderUtil;

procedure InitHimsenWearingSparePClient(AExeName: string);
var
  LStr: string;
begin
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + ChangeFileExt(ExtractFileName(AExeName),'_P.sqlite');
  HimsenWearingSparePModel:= CreateHimsenWearingSparePModel;
  g_HimsenWearingSparePDB:= TSQLRestClientDB.Create(HimsenWearingSparePModel, CreateHimsenWearingSparePModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HimsenWearingSparePDB).Server.CreateMissingTables;
end;

function CreateHimsenWearingSparePModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHimsenWearingSparePropulsion,
    TSQLHimsenWearingSparePropulsionTierII, TSQLHimsenWearingSparePropulsionTierIII]);
end;

procedure AddHimsenWearingSparePFromVariant(ADoc: variant; ATierStep: integer);
var
  LSQLHimsenWearingSpare: TSQLHimsenWearingSparePropulsion;
begin
  if TTierStep(ATierStep) = tsTierI then
    LSQLHimsenWearingSpare := TSQLHimsenWearingSparePropulsion.Create
  else
  if TTierStep(ATierStep) = tsTierII then
    LSQLHimsenWearingSpare := TSQLHimsenWearingSparePropulsion(TSQLHimsenWearingSparePropulsionTierII.Create);

  LSQLHimsenWearingSpare.IsUpdate := False;

  try
    LoadHimsenWearingSparePFromVariant(LSQLHimsenWearingSpare, ADoc);
    AddOrUpdateHimsenWearingSpareP(LSQLHimsenWearingSpare, ATierStep);
  finally
    FreeAndNil(LSQLHimsenWearingSpare);
  end;
end;

procedure LoadHimsenWearingSparePFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSparePropulsion;
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
  AHimsenWaringSpare.HRS4000Formula := ADoc.HRS4000Formula;

  AHimsenWaringSpare.AdaptedCylCount := ADoc.AdaptedCylCount;
  AHimsenWaringSpare.TurboChargerModel := ADoc.TurboChargerModel;
  AHimsenWaringSpare.RatedRPM := ADoc.RatedRPM;

  AHimsenWaringSpare.HRS4000ApplyNo := ADoc.HRS4000ApplyNo;
  AHimsenWaringSpare.HRS100000ApplyNo := ADoc.HRS100000ApplyNo;
end;

procedure AddOrUpdateHimsenWearingSpareP(AHimsenWaringSpare: TSQLHimsenWearingSparePropulsion;
  ATierStep: integer);
begin
  if AHimsenWaringSpare.IsUpdate then
  begin
    if TTierStep(ATierStep) = tsTierI then
      g_HimsenWearingSparePDB.Update(AHimsenWaringSpare)
    else
    if TTierStep(ATierStep) = tsTierII then
      g_HimsenWearingSparePDB.Update(TSQLHimsenWearingSparePropulsionTierII(AHimsenWaringSpare));
//    ShowMessage('Task Update 완료');
  end
  else
  begin
    if TTierStep(ATierStep) = tsTierI then
      g_HimsenWearingSparePDB.Add(AHimsenWaringSpare, true)
    else
    if TTierStep(ATierStep) = tsTierII then
      g_HimsenWearingSparePDB.Add(TSQLHimsenWearingSparePropulsionTierII(AHimsenWaringSpare), true);
//    ShowMessage('Task Add 완료');
  end;
end;

procedure DeleteEngineTypePFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSparePRec);
var
  LSQL: TSQLHimsenWearingSparePropulsion;
begin
  LSQL := GetHimsenWearingSparePFromSearchRec(AHimsenWearingSpareParamRec);

  if LSQL.IsUpdate then
  begin
    g_HimsenWearingSparePDB.Delete(TSQLHimsenWearingSparePropulsion, 'EngineType = ?', [AHimsenWearingSpareParamRec.fEngineType]);
  end;
end;

function GetHimsenWearingSparePFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSparePRec): TSQLHimsenWearingSparePropulsion;
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
      tsTierI: Result := TSQLHimsenWearingSparePropulsion.CreateAndFillPrepare(g_HimsenWearingSparePDB, Lwhere, ConstArray);
      tsTierII: Result := TSQLHimsenWearingSparePropulsion(
        TSQLHimsenWearingSparePropulsionTierII.CreateAndFillPrepare(g_HimsenWearingSparePDB, Lwhere, ConstArray));
    end;

    Result.IsUpdate := Result.FillOne;
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

function GetVariantFromHimsenWearingSpareP(AHimsenWearingSpare:TSQLHimsenWearingSparePropulsion): variant;
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

  Result.AdaptedCylCount := AHimsenWearingSpare.AdaptedCylCount;
  Result.TurboChargerModel := AHimsenWearingSpare.TurboChargerModel;
  Result.RatedRPM := AHimsenWearingSpare.RatedRPM;

  Result.HRS4000ApplyNo := AHimsenWearingSpare.HRS4000ApplyNo;
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
  if Assigned(g_HimsenWearingSparePDB) then
    FreeAndNil(g_HimsenWearingSparePDB);
end.

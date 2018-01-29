unit UnitHimsenWearingSpareMarineRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot;

Type
  THimsenWearingSpareMRec = record
    fHullNo,
    fEngineType,
    fTCModel,
    fRunningHour,
    fCylCount
    : RawUtf8;
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
    fCalcFormula,
    fAdaptedCylCount,  //5,6,7 형식으로 저장 됨
    fTurboChargerModel // HPR3000;TPS48 형식으로 저장 됨
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
    property CalcFormula: RawUTF8 read fCalcFormula write fCalcFormula;
    property AdaptedCylCount: RawUTF8 read fAdaptedCylCount write fAdaptedCylCount;
    property TurboChargerModel: RawUTF8 read fTurboChargerModel write fTurboChargerModel;

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
  end;

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

procedure AddHimsenWaringSpareMFromVariant(ADoc: variant);
procedure LoadHimsenWaringSpareMFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareMarine; ADoc: variant);
procedure AddOrUpdateHimsenWaringSpareM(AHimsenWaringSpare: TSQLHimsenWearingSpareMarine);

function GetHimsenWaringSpareMFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareMRec): TSQLHimsenWearingSpareMarine;
function GetVariantFromHimsenWearingSpareM(AHimsenWearingSpare:TSQLHimsenWearingSpareMarine): variant;

procedure GetRunHour2List4M(var AList: TStrings);

var
  g_HimsenWaringSpareMDB: TSQLRestClientURI;
  HimsenWaringSpareMModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils;

procedure InitHimsenWearingSpareMClient(AExeName: string);
var
  LStr: string;
begin
  LStr := ChangeFileExt(AExeName,'_M.sqlite');
  HimsenWaringSpareMModel:= CreateHimsenWearingSpareMModel;
  g_HimsenWaringSpareMDB:= TSQLRestClientDB.Create(HimsenWaringSpareMModel, CreateHimsenWearingSpareMModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HimsenWaringSpareMDB).Server.CreateMissingTables;
end;

function CreateHimsenWearingSpareMModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHimsenWearingSpareMarine]);
end;

procedure AddHimsenWaringSpareMFromVariant(ADoc: variant);
var
  LSQLHimsenWearingSpare: TSQLHimsenWearingSpareMarine;
begin
  LSQLHimsenWearingSpare := TSQLHimsenWearingSpareMarine.Create;
  LSQLHimsenWearingSpare.IsUpdate := False;

  try
    LoadHimsenWaringSpareMFromVariant(LSQLHimsenWearingSpare, ADoc);
    AddOrUpdateHimsenWaringSpareM(LSQLHimsenWearingSpare);
  finally
    FreeAndNil(LSQLHimsenWearingSpare);
  end;
end;

procedure LoadHimsenWaringSpareMFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareMarine; ADoc: variant);
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
  AHimsenWaringSpare.CalcFormula := ADoc.CalcFormula;
  AHimsenWaringSpare.AdaptedCylCount := ADoc.AdaptedCylCount;
  AHimsenWaringSpare.TurboChargerModel := ADoc.TurboChargerModel;

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
end;

procedure AddOrUpdateHimsenWaringSpareM(AHimsenWaringSpare: TSQLHimsenWearingSpareMarine);
begin
  if AHimsenWaringSpare.IsUpdate then
  begin
    g_HimsenWaringSpareMDB.Update(AHimsenWaringSpare);
//    ShowMessage('Task Update 완료');
  end
  else
  begin
    g_HimsenWaringSpareMDB.Add(AHimsenWaringSpare, true);
//    ShowMessage('Task Add 완료');
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

//    if AHimsenWearingSpareParamRec.fRunningHour <> '' then
//    begin
//      LRunhour := StrToIntDef(AHimsenWearingSpareParamRec.fRunningHour, 0);
//      AddConstArray(ConstArray, [LRunhour]);
//      if LWhere <> '' then
//        LWhere := LWhere + ' and ';
//      LWhere := LWhere + 'RunningHour LIKE ? ';
//    end;

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

    Result := TSQLHimsenWearingSpareMarine.CreateAndFillPrepare(g_HimsenWaringSpareMDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end
    else
    begin
      Result := TSQLHimsenWearingSpareMarine.Create;
      Result.IsUpdate := False;
    end
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
  Result.CalcFormula := AHimsenWearingSpare.CalcFormula;
  Result.AdaptedCylCount := AHimsenWearingSpare.AdaptedCylCount;
  Result.TurboChargerModel := AHimsenWearingSpare.TurboChargerModel;

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
end;

initialization

finalization
  if Assigned(g_HimsenWaringSpareMDB) then
    FreeAndNil(g_HimsenWaringSpareMDB);

end.

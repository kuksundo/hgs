unit UnitHimsenWearingSpareStationaryRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot;

Type
  THimsenWearingSpareSRec = record
    fHullNo,
    fEngineType,
    fTCModel,
    fRunningHour,
    fCylCount
    : RawUtf8;
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
    fCalcFormula,
    fAdaptedCylCount,  //5,6,7 형식으로 저장 됨
    fTurboChargerModel // HPR3000;TPS48 형식으로 저장 됨
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
    property CalcFormula: RawUTF8 read fCalcFormula write fCalcFormula;
    property AdaptedCylCount: RawUTF8 read fAdaptedCylCount write fAdaptedCylCount;
    property TurboChargerModel: RawUTF8 read fTurboChargerModel write fTurboChargerModel;

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

procedure InitHimsenWearingSpareSClient(AExeName: string);
function CreateHimsenWearingSpareSModel: TSQLModel;

procedure AddHimsenWaringSpareSFromVariant(ADoc: variant);
procedure LoadHimsenWaringSpareSFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareStationary; ADoc: variant);
procedure AddOrUpdateHimsenWaringSpareS(AHimsenWaringSpare: TSQLHimsenWearingSpareStationary);

function GetHimsenWaringSpareSFromSearchRec(AHimsenWearingSpareParamRec: THimsenWearingSpareSRec): TSQLHimsenWearingSpareStationary;
function GetVariantFromHimsenWearingSpareS(AHimsenWearingSpare:TSQLHimsenWearingSpareStationary): variant;

procedure GetRunHour2List4S(var AList: TStrings);

var
  g_HimsenWaringSpareSDB: TSQLRestClientURI;
  HimsenWaringSpareSModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils;

procedure InitHimsenWearingSpareSClient(AExeName: string);
var
  LStr: string;
begin
  LStr := ChangeFileExt(AExeName,'_S.sqlite');
  HimsenWaringSpareSModel := CreateHimsenWearingSpareSModel;
  g_HimsenWaringSpareSDB:= TSQLRestClientDB.Create(HimsenWaringSpareSModel, CreateHimsenWearingSpareSModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HimsenWaringSpareSDB).Server.CreateMissingTables;
end;

function CreateHimsenWearingSpareSModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHimsenWearingSpareStationary]);
end;

procedure AddHimsenWaringSpareSFromVariant(ADoc: variant);
var
  LSQLHimsenWearingSpare: TSQLHimsenWearingSpareStationary;
begin
  LSQLHimsenWearingSpare := TSQLHimsenWearingSpareStationary.Create;
  LSQLHimsenWearingSpare.IsUpdate := False;

  try
    LoadHimsenWaringSpareSFromVariant(LSQLHimsenWearingSpare, ADoc);
    AddOrUpdateHimsenWaringSpareS(LSQLHimsenWearingSpare);
  finally
    FreeAndNil(LSQLHimsenWearingSpare);
  end;
end;

procedure LoadHimsenWaringSpareSFromVariant(AHimsenWaringSpare:TSQLHimsenWearingSpareStationary; ADoc: variant);
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

  AHimsenWaringSpare.HRS3000ApplyNo := ADoc.HRS3000ApplyNo;
  AHimsenWaringSpare.HRS6000ApplyNo := ADoc.HRS6000ApplyNo;
  AHimsenWaringSpare.HRS9000ApplyNo := ADoc.HRS9000ApplyNo;
  AHimsenWaringSpare.HRS12000ApplyNo := ADoc.HRS12000ApplyNo;
  AHimsenWaringSpare.HRS15000ApplyNo := ADoc.HRS15000ApplyNo;
  AHimsenWaringSpare.HRS18000ApplyNo := ADoc.HRS18000ApplyNo;
  AHimsenWaringSpare.HRS21000ApplyNo := ADoc.HRS21000ApplyNo;
  AHimsenWaringSpare.HRS24000ApplyNo := ADoc.HRS24000ApplyNo;
  AHimsenWaringSpare.HRS27000ApplyNo := ADoc.HRS27000ApplyNo;
  AHimsenWaringSpare.HRS30000ApplyNo := ADoc.HRS30000ApplyNo;
  AHimsenWaringSpare.HRS33000ApplyNo := ADoc.HRS33000ApplyNo;
  AHimsenWaringSpare.HRS36000ApplyNo := ADoc.HRS36000ApplyNo;
  AHimsenWaringSpare.HRS39000ApplyNo := ADoc.HRS39000ApplyNo;
  AHimsenWaringSpare.HRS42000ApplyNo := ADoc.HRS42000ApplyNo;
  AHimsenWaringSpare.HRS45000ApplyNo := ADoc.HRS45000ApplyNo;
  AHimsenWaringSpare.HRS48000ApplyNo := ADoc.HRS48000ApplyNo;
end;

procedure AddOrUpdateHimsenWaringSpareS(AHimsenWaringSpare: TSQLHimsenWearingSpareStationary);
begin
  if AHimsenWaringSpare.IsUpdate then
  begin
    g_HimsenWaringSpareSDB.Update(AHimsenWaringSpare);
//    ShowMessage('Task Update 완료');
  end
  else
  begin
    g_HimsenWaringSpareSDB.Add(AHimsenWaringSpare, true);
//    ShowMessage('Task Add 완료');
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

    Result := TSQLHimsenWearingSpareStationary.CreateAndFillPrepare(g_HimsenWaringSpareSDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end
    else
    begin
      Result := TSQLHimsenWearingSpareStationary.Create;
      Result.IsUpdate := False;
    end
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

function GetVariantFromHimsenWearingSpareS(AHimsenWearingSpare:TSQLHimsenWearingSpareStationary): variant;
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

  Result.HRS3000ApplyNo := AHimsenWearingSpare.HRS3000ApplyNo;
  Result.HRS6000ApplyNo := AHimsenWearingSpare.HRS6000ApplyNo;
  Result.HRS9000ApplyNo := AHimsenWearingSpare.HRS9000ApplyNo;
  Result.HRS12000ApplyNo := AHimsenWearingSpare.HRS12000ApplyNo;
  Result.HRS15000ApplyNo := AHimsenWearingSpare.HRS15000ApplyNo;
  Result.HRS18000ApplyNo := AHimsenWearingSpare.HRS18000ApplyNo;
  Result.HRS21000ApplyNo := AHimsenWearingSpare.HRS21000ApplyNo;
  Result.HRS24000ApplyNo := AHimsenWearingSpare.HRS24000ApplyNo;
  Result.HRS27000ApplyNo := AHimsenWearingSpare.HRS27000ApplyNo;
  Result.HRS30000ApplyNo := AHimsenWearingSpare.HRS30000ApplyNo;
  Result.HRS33000ApplyNo := AHimsenWearingSpare.HRS33000ApplyNo;
  Result.HRS36000ApplyNo := AHimsenWearingSpare.HRS36000ApplyNo;
  Result.HRS39000ApplyNo := AHimsenWearingSpare.HRS39000ApplyNo;
  Result.HRS42000ApplyNo := AHimsenWearingSpare.HRS42000ApplyNo;
  Result.HRS45000ApplyNo := AHimsenWearingSpare.HRS45000ApplyNo;
  Result.HRS48000ApplyNo := AHimsenWearingSpare.HRS48000ApplyNo;
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

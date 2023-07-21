unit UnitEngineISORecord;

interface

uses Classes, SynCommons, mORMot, UnitpjhSQLRecord, UnitEngineMasterData;//, HiMECSConst,
  //UnitEngineParamConst;

type
  TISOCorrectionData = record
    FEngineLoad,
    FEngineSpeed,
    FPMax,
    FCAPress,
    FTCSpeed,
    FTCInletTemp,
    FTCOutletTemp,
    FCylOutletTemp,
    FCATemp,
    FTCInletTemp_Air,
    FAmbientTemp,
    FFuelAmount //Gas Duration/FOP Index
    : double;
  end;

  TEngineISOFactorRecord = class(TSQLRecord)
  private
{$I EngineISO.inc}
    //EngineISO.inc 파일에 published 키워드 선언 되어 있음
  end;

function GetEngISOFactorRec(ADB: TpjhSQLRecord = nil): TEngineISOFactorRecord;
function GetEngISOFactorFromEngineModel(AModel: integer; ADB: TpjhSQLRecord = nil): TEngineISOFactorRecord;

implementation

function GetEngISOFactorRec(ADB: TpjhSQLRecord): TEngineISOFactorRecord;
begin
  if not Assigned(ADB) then
    exit;

  Result := TEngineISOFactorRecord(ADB.GetRecordAll);
end;

function GetEngISOFactorFromEngineModel(AModel: integer; ADB: TpjhSQLRecord = nil): TEngineISOFactorRecord;
begin
  if not Assigned(ADB) then
    exit;

  Result := TEngineISOFactorRecord.CreateAndFillPrepare(ADB.FSQLDB,
    'EngineModel = ?', [AModel]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

end.

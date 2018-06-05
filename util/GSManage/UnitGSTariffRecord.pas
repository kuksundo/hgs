unit UnitGSTariffRecord;

interface

uses
  Classes,
  Generics.Collections, Vcl.Dialogs,  SynCommons,
  mORMot,
  UnitGSTriffData, CommonData;

type
  TGSTariffSearchRec = Packed Record
    fCompanyCode,
    fCompanyName: RawUTF8;
    fYear: integer;
    fCurrencyKind: TCurrencyKind;
    fGSWorkType: TGSWorkType;
    fGSEngineerType: TGSEngineerType;
    fGSWorkDayType: TGSWorkDayType;
    fGSWorkHourType: TGSWorkHourType;
    fGSServiceRate: integer;
  end;

  TSQLGSTariff = class(TSQLRecord)
  private
    fCompanyCode,
    fCompanyName: RawUTF8;
    fYear: integer;
    fCurrencyKind: TCurrencyKind;
    fGSWorkType: TGSWorkType;
    fGSEngineerType: TGSEngineerType;
    fGSWorkDayType: TGSWorkDayType;
    fGSWorkHourType: TGSWorkHourType;
    fGSServiceRate: integer;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property CompanyCode: RawUTF8 read fCompanyCode write fCompanyCode;
    property CompanyName: RawUTF8 read fCompanyName write fCompanyName;
    property Year: integer read fYear write fYear;
    property GSWorkType: TGSWorkType read fGSWorkType write fGSWorkType;
    property GSEngineerType: TGSEngineerType read fGSEngineerType write fGSEngineerType;
    property GSWorkDayType: TGSWorkDayType read fGSWorkDayType write fGSWorkDayType;
    property GSWorkHourType: TGSWorkHourType read fGSWorkHourType write fGSWorkHourType;
    property GSServiceRate: integer read fGSServiceRate write fGSServiceRate;
    property CurrencyKind: TCurrencyKind read fCurrencyKind write fCurrencyKind;
  end;

procedure InitClient4GSTariff(AExeName: string);
function CreateGSTariffModel: TSQLModel;
procedure ClearTariffSearchRec(var ATariffSearchRec: TGSTariffSearchRec);

function GetGSTariffFromCompanyCode(const ACompanyCode: RawUTF8): TSQLGSTariff;
function GetGSTariffFromCompanyCodeNYear(const ACompanyCode: RawUTF8; const AYear: integer): TSQLGSTariff;
function GetGSTariffFromSearchRec(const AGSTariffSearchRec: TGSTariffSearchRec): TSQLGSTariff;
function LoadGSTariff2VariantFromCompanyCodeNYear(const ACompanyCode: RawUTF8; const AYear: integer): variant;

procedure AddOrUpdateGSTariff(AGSTariff: TSQLGSTariff);
procedure AddOrUpdateGSTariffFromTariffSearchRec(ATariffSearchRec: TGSTariffSearchRec);
procedure DeleteGSTariffFromCompanyCode(const ACompanyCode: RawUTF8);
procedure DeleteGSTariffItemFromID(const AID: TID);
procedure DeleteGSTariff(AGSTariff: TSQLGSTariff);

var
  g_GSTariffDB: TSQLRestClientURI;
  TariffModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, UnitVariantJsonUtil, UnitFolderUtil;

procedure InitClient4GSTariff(AExeName: string);
var
  LStr: string;
begin
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + 'GSTariff.sqlite';
//  LStr := ExtractFilePath(Application.ExeName) + 'GSTariff.sqlite';
  TariffModel:= CreateGSTariffModel;
  g_GSTariffDB:= TSQLRestClientDB.Create(TariffModel, CreateGSTariffModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_GSTariffDB).Server.CreateMissingTables;
end;

function CreateGSTariffModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLGSTariff]);
end;

procedure ClearTariffSearchRec(var ATariffSearchRec: TGSTariffSearchRec);
begin
//  RecordClear(ATariffSearchRec, TypeInfo(TGSTariffSearchRec));
  ATariffSearchRec.fCompanyCode := '';
  ATariffSearchRec.fCompanyName := '';
  ATariffSearchRec.fYear := 0;
  ATariffSearchRec.fCurrencyKind := TCurrencyKind(0);
  ATariffSearchRec.fGSWorkType := TGSWorkType(0);
  ATariffSearchRec.fGSEngineerType := TGSEngineerType(0);
  ATariffSearchRec.fGSWorkDayType := TGSWorkDayType(0);
  ATariffSearchRec.fGSWorkHourType := TGSWorkHourType(0);
  ATariffSearchRec.fGSServiceRate := 0;
end;

function GetGSTariffFromCompanyCode(const ACompanyCode: RawUTF8): TSQLGSTariff;
begin
  Result := TSQLGSTariff.CreateAndFillPrepare(g_GSTariffDB,
    'CompanyCode = ?', [ACompanyCode]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetGSTariffFromCompanyCodeNYear(const ACompanyCode: RawUTF8; const AYear: integer): TSQLGSTariff;
begin
  Result := TSQLGSTariff.CreateAndFillPrepare(g_GSTariffDB,
    'CompanyCode = ? AND Year = ?', [ACompanyCode, AYear]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function LoadGSTariff2VariantFromCompanyCodeNYear(const ACompanyCode: RawUTF8; const AYear: integer): variant;
var
  LSQLGSTariff: TSQLGSTariff;
begin
  LSQLGSTariff := GetGSTariffFromCompanyCodeNYear(ACompanyCode, AYear);
  try
    if LSQLGSTariff.IsUpdate then
    begin
      Result := LoadRecordList2VariantFromSQlRecord(LSQLGSTariff);
    end;
  finally
    LSQLGSTariff.Free;
  end;
end;

function GetGSTariffFromSearchRec(const AGSTariffSearchRec: TGSTariffSearchRec): TSQLGSTariff;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if AGSTariffSearchRec.fCompanyCode <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AGSTariffSearchRec.fCompanyCode+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'CompanyCode LIKE ? ';
    end;

    if AGSTariffSearchRec.fCompanyName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AGSTariffSearchRec.fCompanyName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'CompanyName LIKE ? ';
    end;

    if AGSTariffSearchRec.fYear <> 0 then
    begin
      AddConstArray(ConstArray, [AGSTariffSearchRec.fYear]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'Year = ? ';
    end;

    if Ord(AGSTariffSearchRec.fGSWorkType) <> 0 then
    begin
      AddConstArray(ConstArray, [Ord(AGSTariffSearchRec.fGSWorkType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'GSWorkType = ? ';
    end;

    if Ord(AGSTariffSearchRec.fGSEngineerType) <> 0 then
    begin
      AddConstArray(ConstArray, [Ord(AGSTariffSearchRec.fGSEngineerType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'GSEngineerType = ? ';
    end;

    if Ord(AGSTariffSearchRec.fGSWorkDayType) <> 0 then
    begin
      AddConstArray(ConstArray, [Ord(AGSTariffSearchRec.fGSWorkDayType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'GSWorkDayType = ? ';
    end;

    if Ord(AGSTariffSearchRec.fGSWorkHourType) <> 0 then
    begin
      AddConstArray(ConstArray, [Ord(AGSTariffSearchRec.fGSWorkHourType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'GSWorkHourType = ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    Result := TSQLGSTariff.CreateAndFillPrepare(g_GSTariffDB, Lwhere, ConstArray);

    if Result.FillOne then
      Result.IsUpdate := True
    else
      Result.IsUpdate := False;
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

procedure AddOrUpdateGSTariff(AGSTariff: TSQLGSTariff);
begin
  if AGSTariff.IsUpdate then
  begin
    g_GSTariffDB.Update(AGSTariff);
    ShowMessage('GSTariff Update 완료');
  end
  else
  begin
    g_GSTariffDB.Add(AGSTariff, true);
    ShowMessage('GSTariff Add 완료');
  end;
end;

procedure AddOrUpdateGSTariffFromTariffSearchRec(ATariffSearchRec: TGSTariffSearchRec);
var
  LSQLGSTariff: TSQLGSTariff;
begin
  LSQLGSTariff := GetGSTariffFromSearchRec(ATariffSearchRec);

  if not LSQLGSTariff.FillOne then
  begin
    LSQLGSTariff.CompanyName :=  ATariffSearchRec.fCompanyName;
    LSQLGSTariff.CompanyCode := ATariffSearchRec.fCompanyCode;
    LSQLGSTariff.Year := ATariffSearchRec.fYear;

    LSQLGSTariff.GSWorkType := ATariffSearchRec.fGSWorkType;
    LSQLGSTariff.GSEngineerType := ATariffSearchRec.fGSEngineerType;
    LSQLGSTariff.GSWorkDayType := ATariffSearchRec.fGSWorkDayType;
    LSQLGSTariff.GSWorkHourType := ATariffSearchRec.fGSWorkHourType;
    LSQLGSTariff.CurrencyKind := ATariffSearchRec.fCurrencyKind;
    LSQLGSTariff.GSServiceRate := ATariffSearchRec.fGSServiceRate;
  end;

  AddOrUpdateGSTariff(LSQLGSTariff);
end;

procedure DeleteGSTariffFromCompanyCode(const ACompanyCode: RawUTF8);
var
  LGSTariff: TSQLGSTariff;
begin
  LGSTariff := GetGSTariffFromCompanyCode(ACompanyCode);
  try
    while LGSTariff.FillOne do
    begin
      DeleteGSTariffItemFromID(LGSTariff.ID);
    end;
  finally
    FreeAndNil(LGSTariff);
  end;
end;

procedure DeleteGSTariffItemFromID(const AID: TID);
begin
  g_GSTariffDB.Delete(TSQLGSTariff, AID);
end;

procedure DeleteGSTariff(AGSTariff: TSQLGSTariff);
begin
  g_GSTariffDB.Delete(TSQLGSTariff, AGSTariff.ID);
end;

initialization
finalization
  if Assigned(g_GSTariffDB) then
    FreeAndNil(g_GSTariffDB);

end.


unit UnitNationRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  CommonData, UnitNationData;

type
  TNationSearchParamRec = record
    NationName_KO: RawUTF8;
    NationName_EN: RawUTF8;
    NationName_EN2: RawUTF8;
    NationNumeric: RawUTF8;
    NationAlpha2: RawUTF8;
    NationAlpha3: RawUTF8;
    Continent: RawUTF8;
  end;

  TSQLNationRecord = class(TSQLRecord)
  private
    fNationName_KO,
    fNationName_EN,
    fNationName_EN2, //Sea Web에서 사용하는 국가명
    fNationNumeric,
    fNationAlpha2,
    fNationAlpha3: RawUTF8;
    fContinent: T7Continent;
    fIndependent: Boolean;
    fFlagIcon: TSQLRawBlob;
    fFlagImage: TSQLRawBlob;

    fUpdateDate: TTimeLog;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property NationName_KO: RawUTF8 read fNationName_KO write fNationName_KO;
    property NationName_EN: RawUTF8 read fNationName_EN write fNationName_EN;
    property NationName_EN2: RawUTF8 read fNationName_EN2 write fNationName_EN2;
    property NationNumeric: RawUTF8 read fNationNumeric write fNationNumeric;
    property NationAlpha2: RawUTF8 read fNationAlpha2 write fNationAlpha2;
    property NationAlpha3: RawUTF8 read fNationAlpha3 write fNationAlpha3;
    property Continent: T7Continent read fContinent write fContinent;
    property Independent: Boolean read fIndependent write fIndependent;
    property FlagIcon: TSQLRawBlob read fFlagIcon write fFlagIcon;
    property FlagImage: TSQLRawBlob read fFlagImage write fFlagImage;

    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
  end;

function CreateNationModel: TSQLModel;
procedure InitNationClient(AExeName: string);

function GetNationFromNationName(const ANationName: string): TSQLNationRecord;
function GetNationFromNationAlpha2(const ANationAlpha2: string): TSQLNationRecord;
function GetNationFromSearchRec(ANationSearchParamRec: TNationSearchParamRec): TSQLNationRecord;
function GetVariantFromNationRecord(ANation:TSQLNationRecord): Variant;

procedure AddNationFromVariant(ADoc: variant);
procedure AddOrUpdateNationNameKOFromVariant(ADoc: variant);
procedure LoadNationFromVariant(ANation:TSQLNationRecord; ADoc: variant);
procedure AddOrUpdateNation(ANation:TSQLNationRecord);
procedure DeleteNationFromNationName(const ANationName: string);

var
  g_NationDB: TSQLRestClientURI;
  NationModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, UnitBase64Util, UnitFolderUtil;

function CreateNationModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLNationRecord]);
end;

procedure InitNationClient(AExeName: string);
var
  LStr: string;
begin
//  LStr := ChangeFileExt(Application.ExeName,'.sqlite');
//  LStr := 'GSNation.sqlite';
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + 'GSNation.sqlite';
  NationModel:= CreateNationModel;
  g_NationDB:= TSQLRestClientDB.Create(NationModel, CreateNationModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_NationDB).Server.CreateMissingTables;
end;

function GetNationFromNationName(const ANationName: string): TSQLNationRecord;
begin
  Result := TSQLNationRecord.CreateAndFillPrepare(g_NationDB,
    'NationName LIKE ?', ['%'+ANationName+'%']);
end;

function GetNationFromNationAlpha2(const ANationAlpha2: string): TSQLNationRecord;
begin
  Result := TSQLNationRecord.CreateAndFillPrepare(g_NationDB,
    'NationAlpha2 LIKE ?', ['%'+ANationAlpha2+'%']);
end;

function GetNationFromSearchRec(ANationSearchParamRec: TNationSearchParamRec): TSQLNationRecord;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
  LFrom, LTo: TTimeLog;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if ANationSearchParamRec.NationName_KO <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ANationSearchParamRec.NationName_KO+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'NationName_KO LIKE ? ';
    end;

    if ANationSearchParamRec.NationName_EN <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ANationSearchParamRec.NationName_EN+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'NationName_EN LIKE ? ';
    end;

    if ANationSearchParamRec.NationNumeric <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ANationSearchParamRec.NationNumeric+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'NationNumeric LIKE ? ';
    end;

    if ANationSearchParamRec.NationAlpha2 <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ANationSearchParamRec.NationAlpha2+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'NationAlpha2 LIKE ? ';
    end;

    if ANationSearchParamRec.NationAlpha3 <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ANationSearchParamRec.NationAlpha3+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'NationAlpha3 LIKE ? ';
    end;

    if ANationSearchParamRec.Continent <> '' then
    begin
      AddConstArray(ConstArray, [ANationSearchParamRec.Continent]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'Continent = ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    Result := TSQLNationRecord.CreateAndFillPrepare(g_NationDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
      Result.IsUpdate := True;
    end
    else
    begin
      Result.IsUpdate := False;
    end
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

function GetVariantFromNationRecord(ANation:TSQLNationRecord): Variant;
var
  LImage: TSQLRawBlob;
begin
  TDocVariant.New(Result);

  Result.NationName_KO := ANation.NationName_KO;
  Result.NationName_EN := ANation.NationName_EN;
  Result.NationNumeric := ANation.NationNumeric;
  Result.NationAlpha2 := ANation.NationAlpha2;
  Result.NationAlpha3 := ANation.NationAlpha3;
  Result.Continent := ANation.Continent;
  g_NationDB.RetrieveBlob(TSQLNationRecord, ANation.ID, 'FlagIcon', LImage);
  Result.FlagIcon := MakeRawByteStringToBin64(LImage, False);
  g_NationDB.RetrieveBlob(TSQLNationRecord, ANation.ID, 'FlagImage', LImage);
  Result.FlagImage := LImage;
  Result.UpdateDate := ANation.UpdateDate;
end;

procedure AddNationFromVariant(ADoc: variant);
var
  LSQLNationRecord: TSQLNationRecord;
begin
  LSQLNationRecord := TSQLNationRecord.Create;
  LSQLNationRecord.IsUpdate := False;

  try
    LoadNationFromVariant(LSQLNationRecord, ADoc);
    AddOrUpdateNation(LSQLNationRecord);
  finally
    FreeAndNil(LSQLNationRecord);
  end;
end;

procedure AddOrUpdateNationNameKOFromVariant(ADoc: variant);
var
  LSQLNationRecord: TSQLNationRecord;
begin
  try
    LSQLNationRecord := GetNationFromNationAlpha2(ADoc.NationAlpha2);
    LSQLNationRecord.IsUpdate := LSQLNationRecord.FillOne;
    LSQLNationRecord.NationName_KO := ADoc.NationName_KO;
    AddOrUpdateNation(LSQLNationRecord);
  finally
    FreeAndNil(LSQLNationRecord);
  end;
end;

procedure LoadNationFromVariant(ANation:TSQLNationRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  ANation.NationName_KO := ADoc.NationName_KO;
  ANation.NationName_EN := ADoc.NationName_EN;
  ANation.NationNumeric := ADoc.NationNumeric;
  ANation.NationAlpha2 := ADoc.NationAlpha2;
  ANation.NationAlpha3 := ADoc.NationAlpha3;
  ANation.Continent := ADoc.Continent;
  ANation.Independent := ADoc.Independent;
//  ANation.FlagIcon := ADoc.FlagIcon;
//  ANation.FlagImage := ADoc.FlagImage;
  ANation.UpdateDate := TimeLogFromDateTime(now);
end;

procedure AddOrUpdateNation(ANation:TSQLNationRecord);
begin
  if ANation.IsUpdate then
  begin
    g_NationDB.Update(ANation);
  end
  else
  begin
    g_NationDB.Add(ANation, true);
  end;
end;

procedure DeleteNationFromNationName(const ANationName: string);
var
  LSQLNationRecord: TSQLNationRecord;
begin
  LSQLNationRecord := GetNationFromNationName(ANationName);
  try
    if LSQLNationRecord.FillOne then
      g_NationDB.Delete(TSQLNationRecord, LSQLNationRecord.ID);
  finally
    FreeAndNil(LSQLNationRecord);
  end;
end;

initialization

finalization
  if Assigned(NationModel) then
    FreeAndNil(NationModel);

  if Assigned(g_NationDB) then
    FreeAndNil(g_NationDB);

end.

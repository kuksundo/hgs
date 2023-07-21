unit UnitHiMECSManualRecord;

interface

uses Classes, SynCommons, mORMot, HiMECSConst, EngineParameterClass,
  UnitEngineParamConst, UnitEngineMasterData;

type
  THiMECSManualRecord = class(TSQLRecord)
{$I HiMECSManual.inc}
  public
    FIsUpdate: Boolean;
  published
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  end;

const
  ENG_PARAM_DB_NAME = 'Avat2Param.sqlite';

procedure InitHiMECSManualClient(AHiMECSManualDBName: string = '');
function InitHiMECSManualClient2(AHiMECSManualDBName: string; var AHiMECSManualModel: TSQLModel):TSQLRestClientURI;
function CreateHiMECSManualModel: TSQLModel;
procedure DestroyHiMECSManualClient;

function GetDefaultDBPath: string;
function GetHiMECSManualFromMSNumber(const AMSNo: string; AHiMECSManualDB: TSQLRestClientURI=nil): THiMECSManualRecord;
function GetHiMECSManualFromSectionNo(const ASectionNo: string; AHiMECSManualDB: TSQLRestClientURI=nil): THiMECSManualRecord;
function GetHiMECSManualFromSection_RveNo(const ASectionNo, ARevNo: string;
  AHiMECSManualDB: TSQLRestClientURI=nil): THiMECSManualRecord;
function GetHiMECSManualFromPageNo(const APageNo: integer; AHiMECSManualDB: TSQLRestClientURI=nil): THiMECSManualRecord;
function GetHiMECSManualFromProductModel(AHiMECSManualDB: TSQLRestClientURI;
  const AProductType: TEngineProductType; AModel: TEngineModel): THiMECSManualRecord;
function GetVariantFromHiMECSManualRecord(AHiMECSManualRecord:THiMECSManualRecord): variant;
function GetHiMECSManualList2JSONArrayFromProductModel(AHiMECSManualDB: TSQLRestClientURI=nil;
  const AProductType: TEngineProductType=vepteNull; AModel: TEngineModel=emNull): RawUtf8;

procedure AddOrUpdatedHiMECSManual(AHiMECSManualRecord: THiMECSManualRecord;
  AHiMECSManualDB: TSQLRestClientURI=nil);
procedure LoadHiMECSManualFromVariant(AHiMECSManualRecord: THiMECSManualRecord; ADoc: variant);
function AddOrUpdateHiMECSManualFromVariant(ADoc: variant;
  AIsOnlyAdd: Boolean = False; AHiMECSManualDB: TSQLRestClientURI=nil): integer;

var
  g_HiMECSManualDB: TSQLRestClientURI;
  HiMECSManualModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil, UnitRttiUtil, RTTI;

procedure InitHiMECSManualClient(AHiMECSManualDBName: string = '');
var
  LStr: string;
begin
  if Assigned(g_HiMECSManualDB) then
    exit;

  if AHiMECSManualDBName = '' then
  begin
    AHiMECSManualDBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(AHiMECSManualDBName);
    AHiMECSManualDBName := ExtractFileName(AHiMECSManualDBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + AHiMECSManualDBName;
  HiMECSManualModel:= CreateHiMECSManualModel;
  g_HiMECSManualDB:= TSQLRestClientDB.Create(HiMECSManualModel, CreateHiMECSManualModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HiMECSManualDB).Server.CreateMissingTables;
end;

function InitHiMECSManualClient2(AHiMECSManualDBName: string; var AHiMECSManualModel: TSQLModel):TSQLRestClientURI;
var
  LStr: string;
begin
  if AHiMECSManualDBName = '' then
  begin
    AHiMECSManualDBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(AHiMECSManualDBName);
    AHiMECSManualDBName := ExtractFileName(AHiMECSManualDBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + AHiMECSManualDBName;
  AHiMECSManualModel:= CreateHiMECSManualModel;
  Result:= TSQLRestClientDB.Create(AHiMECSManualModel, CreateHiMECSManualModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(Result).Server.CreateMissingTables;
end;

function CreateHiMECSManualModel: TSQLModel;
begin
  result := TSQLModel.Create([THiMECSManualRecord]);
end;

procedure DestroyHiMECSManualClient;
begin
  if Assigned(HiMECSManualModel) then
    FreeAndNil(HiMECSManualModel);

  if Assigned(g_HiMECSManualDB) then
    FreeAndNil(g_HiMECSManualDB);
end;

function GetDefaultDBPath: string;
var
  LStr: string;
begin
  LStr := ExtractFilePath(Application.ExeName);
  Result := IncludeTrailingBackSlash(LStr) + 'db\';
end;

function GetHiMECSManualFromMSNumber(const AMSNo: string;
  AHiMECSManualDB: TSQLRestClientURI=nil): THiMECSManualRecord;
begin
  if AMSNo = '' then
  begin
    Result := THiMECSManualRecord.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    if not Assigned(AHiMECSManualDB) then
      AHiMECSManualDB := g_HiMECSManualDB;

    Result := THiMECSManualRecord.CreateAndFillPrepare(AHiMECSManualDB,
      'MSNumber LIKE ?', ['%'+AMSNo+'%']);

    if Result.FillOne then
      Result.IsUpdate := True
    else
      Result.IsUpdate := False;
  end;
end;

function GetHiMECSManualFromSectionNo(const ASectionNo: string;
  AHiMECSManualDB: TSQLRestClientURI=nil): THiMECSManualRecord;
begin
  if ASectionNo = '' then
  begin
    Result := THiMECSManualRecord.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    if not Assigned(AHiMECSManualDB) then
      AHiMECSManualDB := g_HiMECSManualDB;

    Result := THiMECSManualRecord.CreateAndFillPrepare(AHiMECSManualDB,
      'SectionNo LIKE ?', ['%'+ASectionNo+'%']);

    if Result.FillOne then
      Result.IsUpdate := True
    else
      Result.IsUpdate := False;
  end;
end;

function GetHiMECSManualFromSection_RveNo(const ASectionNo, ARevNo: string;
  AHiMECSManualDB: TSQLRestClientURI=nil): THiMECSManualRecord;
begin
  if ASectionNo = '' then
  begin
    Result := THiMECSManualRecord.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    if not Assigned(AHiMECSManualDB) then
      AHiMECSManualDB := g_HiMECSManualDB;

    Result := THiMECSManualRecord.CreateAndFillPrepare(AHiMECSManualDB,
      'SectionNo LIKE ? and RevNo LIKE ?', ['%'+ASectionNo+'%', '%'+ARevNo+'%']);

    if Result.FillOne then
      Result.IsUpdate := True
    else
      Result.IsUpdate := False;
  end;
end;

function GetHiMECSManualFromPageNo(const APageNo: integer;
  AHiMECSManualDB: TSQLRestClientURI=nil): THiMECSManualRecord;
begin
  if not Assigned(AHiMECSManualDB) then
    AHiMECSManualDB := g_HiMECSManualDB;

  Result := THiMECSManualRecord.CreateAndFillPrepare(AHiMECSManualDB,
      'PageNo_B <= ? and PageNo_E >= ?', [APageNo, APageNo]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetHiMECSManualFromProductModel(AHiMECSManualDB: TSQLRestClientURI;
  const AProductType: TEngineProductType; AModel: TEngineModel): THiMECSManualRecord;
begin
  if not Assigned(AHiMECSManualDB) then
    AHiMECSManualDB := g_HiMECSManualDB;

  if (AProductType = vepteNull) and (AModel = emNull) then
    Result := THiMECSManualRecord.CreateAndFillPrepare(AHiMECSManualDB,
      'ID <> ? ', [-1])
  else
    Result := THiMECSManualRecord.CreateAndFillPrepare(AHiMECSManualDB,
      'ProductType = ? and ProductModel = ?', [Ord(AProductType), Ord(AModel)]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVariantFromHiMECSManualRecord(AHiMECSManualRecord:THiMECSManualRecord): variant;
begin
  TDocVariant.New(Result);
  LoadRecordPropertyToVariant(AHiMECSManualRecord, Result);
end;

function GetHiMECSManualList2JSONArrayFromProductModel(AHiMECSManualDB: TSQLRestClientURI;
  const AProductType: TEngineProductType; AModel: TEngineModel): RawUtf8;
var
  LHiMECSManualRecord:THiMECSManualRecord;
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LHiMECSManualRecord := GetHiMECSManualFromProductModel(AHiMECSManualDB, AProductType, AModel);

  try
    LHiMECSManualRecord.FillRewind;

    while LHiMECSManualRecord.FillOne do
    begin
      LUtf8 := LHiMECSManualRecord.GetJSONValues(true, true, soSelect);
      LDynArr.Add(LUtf8);
    end;

    LUtf8 := LDynArr.SaveToJSON;
    Result := LUtf8;
  finally
    FreeAndNil(LHiMECSManualRecord);
  end;
end;

procedure AddOrUpdatedHiMECSManual(AHiMECSManualRecord: THiMECSManualRecord;
  AHiMECSManualDB: TSQLRestClientURI=nil);
begin
  if not Assigned(AHiMECSManualDB) then
    AHiMECSManualDB := g_HiMECSManualDB;

  if AHiMECSManualRecord.IsUpdate then
  begin
    AHiMECSManualDB.Update(AHiMECSManualRecord);
  end
  else
  begin
    AHiMECSManualDB.Add(AHiMECSManualRecord, true);
  end;
end;

procedure LoadHiMECSManualFromVariant(AHiMECSManualRecord: THiMECSManualRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  LoadRecordPropertyFromVariant(AHiMECSManualRecord, ADoc);
end;

function AddOrUpdateHiMECSManualFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False;
  AHiMECSManualDB: TSQLRestClientURI=nil): integer;
var
  LHiMECSManualRecord: THiMECSManualRecord;
  LIsUpdate: Boolean;
begin
  LHiMECSManualRecord := GetHiMECSManualFromSection_RveNo(ADoc.SectionNo, ADoc.RevNo, AHiMECSManualDB);
  LIsUpdate := LHiMECSManualRecord.IsUpdate;
  try
    if AIsOnlyAdd then
    begin
      if not LHiMECSManualRecord.IsUpdate then
      begin
        LoadHiMECSManualFromVariant(LHiMECSManualRecord, ADoc);
        LHiMECSManualRecord.IsUpdate := LIsUpdate;

        AddOrUpdatedHiMECSManual(LHiMECSManualRecord, AHiMECSManualDB);
        Inc(Result);
      end;
    end
    else
    begin
      if LHiMECSManualRecord.IsUpdate then
        Inc(Result);

      LoadHiMECSManualFromVariant(LHiMECSManualRecord, ADoc);
      LHiMECSManualRecord.IsUpdate := LIsUpdate;

      AddOrUpdatedHiMECSManual(LHiMECSManualRecord, AHiMECSManualDB);
    end;
  finally
    FreeAndNil(LHiMECSManualRecord);
  end;
end;

initialization

finalization
  DestroyHiMECSManualClient;

end.

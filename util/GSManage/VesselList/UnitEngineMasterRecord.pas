unit UnitEngineMasterRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  UnitEngineMasterData;

type
  TEngineSearchParamRec = record
    HullNo,
    IMONo,
    Class1,
    ProductType,
    ProductModel,
    ProjectName,
    ProjectNo
    : RawUtf8;
    FFrom, FTo: TDateTime;
    QueryDate: RawUtf8;
  end;

  TSQLEngineMaster = class(TSQLRecord)
  private
    fTaskID: TID;
    fHullNo,
    fIMONo,
    fProjectNo,
    fProjectName,
    fProductModel,
    fMark,
    fClass1,
    fClass2,
    fUsage //용도구분
    : RawUTF8;
    fProductType: TEngineProductType;
    fCylCount,
    fBore,
    fTier,
    fMCR_KW,
    fBHP,
    fRPM,
    fInstalledCount,
    fWarrantyMonth1,//보증기간(출하)
    fWarrantyMonth2 //보증기간(기타)
    : integer;

    fProductDeliveryDate,
    fShipDeliveryDate,
    fWarrantyDueDate,
    fUpdatedDate: TTimeLog;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property HullNo: RawUTF8 read fHullNo write fHullNo;
    property IMONo: RawUTF8 read fIMONo write fIMONo;
    property ProjectNo: RawUTF8 read fProjectNo write fProjectNo;
    property ProjectName: RawUTF8 read fProjectName write fProjectName;
    property ProductModel: RawUTF8 read fProductModel write fProductModel;
    property Mark: RawUTF8 read fMark write fMark;
    property Usage: RawUTF8 read fUsage write fUsage;
    property Class1: RawUTF8 read fClass1 write fClass1;
    property Class2: RawUTF8 read fClass2 write fClass2;

    property ProductType: TEngineProductType read fProductType write fProductType;

    property CylCount: integer read fCylCount write fCylCount;
    property Bore: integer read fBore write fBore;
    property Tier: integer read fTier write fTier;
    property MCR_KW: integer read fMCR_KW write fMCR_KW;
    property BHP: integer read fBHP write fBHP;
    property RPM: integer read fRPM write fRPM;
    property InstalledCount: integer read fInstalledCount write fInstalledCount;
    property WarrantyMonth1: integer read fWarrantyMonth1 write fWarrantyMonth1;
    property WarrantyMonth2: integer read fWarrantyMonth2 write fWarrantyMonth2;

    property ProductDeliveryDate: TTimeLog read fProductDeliveryDate write fProductDeliveryDate;
    property ShipDeliveryDate: TTimeLog read fShipDeliveryDate write fShipDeliveryDate;
    property WarrantyDueDate: TTimeLog read fWarrantyDueDate write fWarrantyDueDate;
    property UpdatedDate: TTimeLog read fUpdatedDate write fUpdatedDate;
  end;

procedure InitEngineMasterClient(AEngineMasterDBName: string = '');
function CreateEngineMasterModel: TSQLModel;

function GetEngineMasterFromHullNo(const AHullNo: string): TSQLEngineMaster;
function GetEngineMasterFromHullNoStrict(const AHullNo: string): TSQLEngineMaster;
function GetEngineMasterFromIMONo(const AIMONo: string): TSQLEngineMaster;
function GetEngineMasterFromProjNo(const AProjNo: string): TSQLEngineMaster;
function GetVariantFromEngineMaster(AEngineMaster:TSQLEngineMaster): Variant;
function GetEngineMasterFromSearchRec(AEngineSearchParamRec: TEngineSearchParamRec): TSQLEngineMaster;
function GetSqlWhereFromEngineMasterQueryDate(AEngineMasterQueryDateType: TEngineMasterQueryDateType): string;

procedure AddOrUpdateEngineMaster(AEngineMaster: TSQLEngineMaster);
function AddOrUpdateEngineMasterFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False): integer;
procedure LoadEngineMasterFromVariant(AEngineMaster: TSQLEngineMaster; ADoc: variant);

var
  g_EngineMasterDB: TSQLRestClientURI;
  EngineMasterModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil;

procedure InitEngineMasterClient(AEngineMasterDBName: string = '');
var
  LStr: string;
begin
  if AEngineMasterDBName = '' then
    AEngineMasterDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite')
  else
    AEngineMasterDBName := AEngineMasterDBName;

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AEngineMasterDBName;
  EngineMasterModel:= CreateEngineMasterModel;
  g_EngineMasterDB:= TSQLRestClientDB.Create(EngineMasterModel, CreateEngineMasterModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_EngineMasterDB).Server.CreateMissingTables;
end;

function CreateEngineMasterModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLEngineMaster]);
end;

function GetEngineMasterFromHullNo(const AHullNo: string): TSQLEngineMaster;
begin
  Result := TSQLEngineMaster.CreateAndFillPrepare(g_EngineMasterDB,
    'HullNo LIKE ?', ['%'+AHullNo+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetEngineMasterFromHullNoStrict(const AHullNo: string): TSQLEngineMaster;
begin
  Result := TSQLEngineMaster.CreateAndFillPrepare(g_EngineMasterDB,
    'HullNo = ?', [AHullNo]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetEngineMasterFromIMONo(const AIMONo: string): TSQLEngineMaster;
begin
  Result := TSQLEngineMaster.CreateAndFillPrepare(g_EngineMasterDB,
    'IMONo LIKE ?', ['%'+AIMONo+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetEngineMasterFromProjNo(const AProjNo: string): TSQLEngineMaster;
begin
  Result := TSQLEngineMaster.CreateAndFillPrepare(g_EngineMasterDB,
    'ProjectNo LIKE ?', ['%'+AProjNo+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVariantFromEngineMaster(AEngineMaster:TSQLEngineMaster): Variant;
begin
  TDocVariant.New(Result);

  Result.HullNo := AEngineMaster.HullNo;
  Result.IMONo := AEngineMaster.IMONo;
  Result.ProjectNo := AEngineMaster.ProjectNo;
  Result.ProjectName := AEngineMaster.ProjectName;
  Result.ProductModel := AEngineMaster.ProductModel;
  Result.ProductType := Ord(AEngineMaster.ProductType);
  Result.Mark := AEngineMaster.Mark;
  Result.Usage := AEngineMaster.Usage;
  Result.Class1 := AEngineMaster.Class1;
  Result.Class2 := AEngineMaster.Class2;

  Result.CylCount := AEngineMaster.CylCount;
  Result.Bore := AEngineMaster.Bore;
  Result.Tier := AEngineMaster.Tier;
  Result.MCR_KW := AEngineMaster.MCR_KW;
  Result.BHP := AEngineMaster.BHP;
  Result.RPM := AEngineMaster.RPM;
  Result.InstalledCount := AEngineMaster.InstalledCount;
  Result.WarrantyMonth1 := AEngineMaster.WarrantyMonth1;
  Result.WarrantyMonth2 := AEngineMaster.WarrantyMonth2;

  Result.ProductDeliveryDate := AEngineMaster.ProductDeliveryDate;
  Result.ShipDeliveryDate := AEngineMaster.ShipDeliveryDate;
  Result.WarrantyDueDate := AEngineMaster.WarrantyDueDate;
  Result.UpdatedDate := AEngineMaster.UpdatedDate;
end;

function GetSqlWhereFromEngineMasterQueryDate(AEngineMasterQueryDateType: TEngineMasterQueryDateType): string;
begin
  case AEngineMasterQueryDateType of
    emdtProductDeliveryDate: Result := 'ProductDeliveryDate >= ? and ProductDeliveryDate <= ? ';
    emdtShipDeliveryDate: Result := 'ShipDeliveryDate >= ? and ShipDeliveryDate <= ? ';
    emdtWarrantyDueDate: Result := 'WarrantyDueDate >= ? and WarrantyDueDate <= ? ';
  end;
end;

function GetEngineMasterFromSearchRec(AEngineSearchParamRec: TEngineSearchParamRec): TSQLEngineMaster;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
  LFrom, LTo: TTimeLog;
  LEngineProductType: TEngineProductType;
  LEngineMasterQueryDateType: TEngineMasterQueryDateType;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if AEngineSearchParamRec.QueryDate <> '' then
    begin
      if AEngineSearchParamRec.FFrom <= AEngineSearchParamRec.FTo then
      begin
        LFrom := TimeLogFromDateTime(AEngineSearchParamRec.FFrom);
        LTo := TimeLogFromDateTime(AEngineSearchParamRec.FTo);

        if AEngineSearchParamRec.QueryDate <> '' then
        begin
          LEngineMasterQueryDateType := g_EngineMasterQueryDateType.ToType(AEngineSearchParamRec.QueryDate);
          LWhere := GetSqlWhereFromEngineMasterQueryDate(LEngineMasterQueryDateType);
          if LWhere <> '' then
            AddConstArray(ConstArray, [LFrom, LTo]);
        end;
      end;
    end;

    if AEngineSearchParamRec.HullNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AEngineSearchParamRec.HullNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'HullNo LIKE ? ';
    end;

    if AEngineSearchParamRec.IMONo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AEngineSearchParamRec.IMONo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'IMONo LIKE ? ';
    end;

    if AEngineSearchParamRec.Class1 <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AEngineSearchParamRec.Class1+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'Class1 LIKE ? ';
    end;

    if AEngineSearchParamRec.ProductModel <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AEngineSearchParamRec.ProductModel+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProductModel LIKE ? ';
    end;

    if AEngineSearchParamRec.ProjectName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AEngineSearchParamRec.ProjectName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProjectName LIKE ? ';
    end;

    if AEngineSearchParamRec.ProjectNo <> '' then
    begin
      AddConstArray(ConstArray, [AEngineSearchParamRec.ProjectNo]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProjectNo = ? ';
    end;

    if AEngineSearchParamRec.ProductType <> '' then
    begin
      LEngineProductType := g_EngineProductType.ToType(AEngineSearchParamRec.ProductType);
      AddConstArray(ConstArray, [Ord(LEngineProductType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProductType = ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    Result := TSQLEngineMaster.CreateAndFillPrepare(g_EngineMasterDB, Lwhere, ConstArray);

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

procedure AddOrUpdateEngineMaster(AEngineMaster: TSQLEngineMaster);
begin
  if AEngineMaster.IsUpdate then
  begin
    g_EngineMasterDB.Update(AEngineMaster);
  end
  else
  begin
    g_EngineMasterDB.Add(AEngineMaster, true);
  end;
end;

procedure LoadEngineMasterFromVariant(AEngineMaster: TSQLEngineMaster; ADoc: variant);
var
  LStr: string;

  function GetDateFromStr(AStr: string): TTimeLog;
  var
    Ly, Lm, Ld: word;
  begin
    Result := 0;

    if (AStr <> '') and (Pos('-', AStr) <> 0)then
    begin
      Ly := StrToIntDef(strToken(AStr, '-'),0);
      if Ly <> 0 then
      begin
        Lm := StrToIntDef(strToken(AStr, '-'),0);
        Ld := StrToIntDef(strToken(AStr, '-'),0);
        Result := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
      end;
    end;
  end;
begin
  if ADoc = null then
    exit;

  AEngineMaster.HullNo := ADoc.HullNo;
  AEngineMaster.IMONo := ADoc.IMONo;
  AEngineMaster.ProjectNo := ADoc.ProjectNo;
  AEngineMaster.ProjectName := ADoc.ProjectName;
  AEngineMaster.ProductModel := ADoc.ProductModel;
  AEngineMaster.ProductType := TEngineProductType(ADoc.ProductType);
  AEngineMaster.Mark := ADoc.Mark;
  AEngineMaster.Usage := ADoc.Usage;
  AEngineMaster.Class1 := ADoc.Class1;
  AEngineMaster.Class2 := ADoc.Class2;

  AEngineMaster.CylCount := ADoc.CylCount;
  AEngineMaster.Bore := ADoc.Bore;
  AEngineMaster.Tier := ADoc.Tier;
  AEngineMaster.MCR_KW := ADoc.MCR_KW;
  AEngineMaster.BHP := ADoc.BHP;
  AEngineMaster.RPM := ADoc.RPM;
  AEngineMaster.InstalledCount := ADoc.InstalledCount;
  AEngineMaster.WarrantyMonth1 := ADoc.WarrantyMonth1;
  AEngineMaster.WarrantyMonth2 := ADoc.WarrantyMonth2;

  LStr := ADoc.ProductDeliveryDate;
  AEngineMaster.ProductDeliveryDate := GetDateFromStr(LStr);
  LStr := ADoc.ShipDeliveryDate;
  AEngineMaster.ShipDeliveryDate := GetDateFromStr(LStr);
  LStr := ADoc.WarrantyDueDate;
  AEngineMaster.WarrantyDueDate := GetDateFromStr(LStr);
  AEngineMaster.UpdatedDate := TimeLogFromDateTime(now);
end;

function AddOrUpdateEngineMasterFromVariant(ADoc: variant; AIsOnlyAdd: Boolean): integer;
var
  LSQLEngineMaster: TSQLEngineMaster;
begin
  LSQLEngineMaster := GetEngineMasterFromProjNo(ADoc.ProjectNo);
  try
    if AIsOnlyAdd then
    begin
      if not LSQLEngineMaster.IsUpdate then
      begin
        LoadEngineMasterFromVariant(LSQLEngineMaster, ADoc);
        AddOrUpdateEngineMaster(LSQLEngineMaster);
        Inc(Result);
      end;
    end
    else
    begin
      if LSQLEngineMaster.IsUpdate then
        Inc(Result);

      LoadEngineMasterFromVariant(LSQLEngineMaster, ADoc);
      AddOrUpdateEngineMaster(LSQLEngineMaster);
    end;
  finally
    FreeAndNil(LSQLEngineMaster);
  end;
end;

initialization

finalization
  if Assigned(EngineMasterModel) then
    FreeAndNil(EngineMasterModel);

  if Assigned(g_EngineMasterDB) then
    FreeAndNil(g_EngineMasterDB);

end.

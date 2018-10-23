unit UnitVesselMasterRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  CommonData, UnitVesselData;

type
  TVesselSearchParamRec = record
    fHullNo,
    fShipName,
    fShipBuilderName,
    fOwnerName,
    fTechManagerName,
    fTechManagerCountry,
    fOperatorName,
    fIMONo,
    fClass,
    fShipType,
    fVesselStatus
    : RawUtf8;
    FFrom, FTo: TDateTime;
    fQueryDate: TVesselQueryDateType;
  end;

  TList4VesselMaster = class
    fTaskID: TID;
    fHullNo,
    fShipName,
    fShipBuilderID,
    fShipBuilderName,
    fIMONo
    : RawUTF8;
  published
    property TaskId: TID read fTaskId write fTaskId;
    property HullNo: RawUTF8 read fHullNo write fHullNo;
    property ShipName: RawUTF8 read fShipName write fShipName;
    property IMONo: RawUTF8 read fIMONo write fIMONo;
    property ShipBuilderID: RawUTF8 read fShipBuilderID write fShipBuilderID;
    property ShipBuilderName: RawUTF8 read fShipBuilderName write fShipBuilderName;
  end;

  TSQLVesselBase = class(TSQLRecord)
  private
    fTaskID: TID;
    fHullNo,
    fShipName,
    fShipBuilderID,
    fShipBuilderName,
    fIMONo
    : RawUTF8;
    fUpdatedDate: TTimeLog;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property HullNo: RawUTF8 read fHullNo write fHullNo;
    property ShipName: RawUTF8 read fShipName write fShipName;
    property IMONo: RawUTF8 read fIMONo write fIMONo;
    property ShipBuilderID: RawUTF8 read fShipBuilderID write fShipBuilderID;
    property ShipBuilderName: RawUTF8 read fShipBuilderName write fShipBuilderName;
    property UpdatedDate: TTimeLog read fUpdatedDate write fUpdatedDate;
  end;

  TSQLVesselMaster = class(TSQLVesselBase)
  private
    fSocietyClass1,
    fSocietyClass2,
    fShipType,
    fShipTypeDesc,
    fOwnerID,
    fOwnerName,
    fOwnerCountry,
    fTechManagerCountry,
    fTechManagerID,
    fTechManagerName,
    fOperatorID,
    fOperatorName,
    fOperatorCountry,
    fBuyingCompanyCountry,
    fBuyingCompanyID,
    fBuyingCompanyName,
    fVesselStatus
    : RawUTF8;

    fInstalledProductTypes: TShipProductTypes;

    fDeliveryDate,
    fLastDryDockDate: TTimeLog;

    fSpecialSurveyDue,
    fDockingSurveyDue,
    fGuaranteePeriod: TTimeLog;
  published
    property SClass1: RawUTF8 read fSocietyClass1 write fSocietyClass1;
    property SClass2: RawUTF8 read fSocietyClass2 write fSocietyClass2;
    property ShipType: RawUTF8 read fShipType write fShipType;
    property ShipTypeDesc: RawUTF8 read fShipTypeDesc write fShipTypeDesc;
    property OwnerID: RawUTF8 read fOwnerID write fOwnerID;
    property OwnerName: RawUTF8 read fOwnerName write fOwnerName;
    property OwnerCountry: RawUTF8 read fOwnerCountry write fOwnerCountry;
    property TechManagerCountry: RawUTF8 read fTechManagerCountry write fTechManagerCountry;
    property TechManagerID: RawUTF8 read fTechManagerID write fTechManagerID;
    property TechManagerName: RawUTF8 read fTechManagerName write fTechManagerName;
    property OperatorID: RawUTF8 read fOperatorID write fOperatorID;
    property OperatorName: RawUTF8 read fOperatorName write fOperatorName;
    property OperatorCountry: RawUTF8 read fOperatorCountry write fOperatorCountry;
    property BuyingCompanyCountry: RawUTF8 read fBuyingCompanyCountry write fBuyingCompanyCountry;
    property BuyingCompanyID: RawUTF8 read fBuyingCompanyID write fBuyingCompanyID;
    property BuyingCompanyName: RawUTF8 read fBuyingCompanyName write fBuyingCompanyName;
    property VesselStatus: RawUTF8 read fVesselStatus write fVesselStatus;
    property InstalledProductTypes: TShipProductTypes read fInstalledProductTypes write fInstalledProductTypes;

    property DeliveryDate: TTimeLog read fDeliveryDate write fDeliveryDate;
    property LastDryDockDate: TTimeLog read fLastDryDockDate write fLastDryDockDate;
    property SpecialSurveyDueDate: TTimeLog read fSpecialSurveyDue write fSpecialSurveyDue;
    property DockingSurveyDueDate: TTimeLog read fDockingSurveyDue write fDockingSurveyDue;
    property GuaranteePeriod: TTimeLog read fGuaranteePeriod write fGuaranteePeriod;
  end;

  TSQLVesselInfo4SeaWeb = class(TSQLVesselBase)
  private
    fShipType,
    fShipTypeDesc,
    fOwnerName,
    fOwnerCountry,
    fOperatorName,
    fOperatorCountry,
    fTechManagerName,
    fTechManagerCountry,
    fVesselStatus
    : RawUTF8;

    fSpecialSurveyDue,
    fDockingSurveyDue: TTimeLog;
  published
    property ShipType: RawUTF8 read fShipType write fShipType;
    property ShipTypeDesc: RawUTF8 read fShipTypeDesc write fShipTypeDesc;
    property OwnerName: RawUTF8 read fOwnerName write fOwnerName;
    property OwnerCountry: RawUTF8 read fOwnerCountry write fOwnerCountry;
    property OperatorName: RawUTF8 read fOperatorName write fOperatorName;
    property OperatorCountry: RawUTF8 read fOperatorCountry write fOperatorCountry;
    property TechManagerName: RawUTF8 read fTechManagerName write fTechManagerName;
    property TechManagerCountry: RawUTF8 read fTechManagerCountry write fTechManagerCountry;
    property VesselStatus: RawUTF8 read fVesselStatus write fVesselStatus;

    property SpecialSurveyDueDate: TTimeLog read fSpecialSurveyDue write fSpecialSurveyDue;
    property DockingSurveyDueDate: TTimeLog read fDockingSurveyDue write fDockingSurveyDue;
  end;

procedure InitVesselMasterClient(AVesselMasterDBName: string = '');
procedure InitVesselInfo4SeaWebClient(AExeName: string);
function CreateVesselMasterModel: TSQLModel;
function CreateVesselInfo4SeaWebModel: TSQLModel;

function GetVesselMasterFromHullNo(const AHullNo: string): TSQLVesselMaster;
function GetVesselMasterFromShipName(const AShipName: string): TSQLVesselMaster;
function GetVesselMasterFromIMONo(const AIMONo: string): TSQLVesselMaster;
function GetVesselMasterFromOwnerName(const AOwnerName: string): TSQLVesselMaster;
function GetVesselMasterFromTechName(const ATechName: string): TSQLVesselMaster;
function GetVesselMasterFromOperatorName(const AOperatorName: string): TSQLVesselMaster;
function GetVesselMasterFromSpecialSurveyDueZero: TSQLVesselMaster;
function GetVesselMasterFromDockingSurveyDueZero: TSQLVesselMaster;
function GetVesselMasterFromUpdatedZero: TSQLVesselMaster;

function GetVesselInfo4SeaWebFromIMONo(const AIMONo: string): TSQLVesselInfo4SeaWeb;

procedure AddVesselMasterFromVariant(ADoc: variant);
procedure AddOrUpdateVesselMasterFromVariant(ADoc: variant);
function GetVariantFromVesselMaster(AVesselMaster:TSQLVesselMaster): variant;
procedure LoadVesselMasterFromVariant(AVesselMaster:TSQLVesselMaster; ADoc: variant);
procedure AddOrUpdateVesselDeliveryDateFromVariant(ADoc: variant);
procedure LoadVesselDeliveryDateFromVariant(AVesselMaster:TSQLVesselMaster; ADoc: variant);
procedure LoadVesselDeliveryDateFromVariant2(AVesselMaster:TSQLVesselMaster; ADoc: variant);
procedure LoadVesselGPNDeliveryDateFromVariant(AVesselMaster:TSQLVesselMaster; ADoc: variant);
procedure AddOrUpdateVesselGPNDeliveryDateFromVariant(ADoc: variant);

procedure AddOrUpdateVesselInfo4SeaWebFromVariant(ADoc: variant);
procedure LoadVesselInfo4SeaWebFromVariant(AVesselInfo4SeaWeb:TSQLVesselInfo4SeaWeb; ADoc: variant);
function GetVesselInfo4SeaWebFromUpdatedNotZero: TSQLVesselInfo4SeaWeb;

function GetVesselMasterFromSearchRec(AVesselSearchParamRec: TVesselSearchParamRec): TSQLVesselMaster;
function GetSqlWhereFromVesselQueryDate(AVesselQueryDateType: TVesselQueryDateType): string;

procedure AddOrUpdateVesselMaster(AVesselMaster: TSQLVesselMaster);
procedure AddOrUpdateVesselInfo4SeaWeb(AVesselInfo4SeaWeb: TSQLVesselInfo4SeaWeb);

function AddVesselInfoFromSeaWebDB: integer;
function UpdateDockSurveyDateFromSeaWebDB: integer;
procedure LoadVesselDockDueDateFromSeaWebDB(ASQLVesselMaster: TSQLVesselMaster;
  ASQLVesselInfo4SeaWeb: TSQLVesselInfo4SeaWeb);
procedure LoadVesselInfoFromSeaWebDB(ASQLVesselMaster: TSQLVesselMaster;
  ASQLVesselInfo4SeaWeb: TSQLVesselInfo4SeaWeb);

var
  g_VesselMasterDB,
  g_VesselInfo4SeaWebDB: TSQLRestClientURI;
  VesselMasterModel,
  VesselInfo4SeaWebModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil;

procedure InitVesselMasterClient(AVesselMasterDBName: string = '');
var
  LStr: string;
begin
  if AVesselMasterDBName = '' then
  begin
    LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
    LStr := LStr + ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
  end
  else
    LStr := AVesselMasterDBName;

  VesselMasterModel:= CreateVesselMasterModel;
  g_VesselMasterDB:= TSQLRestClientDB.Create(VesselMasterModel, CreateVesselMasterModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_VesselMasterDB).Server.CreateMissingTables;
end;

procedure InitVesselInfo4SeaWebClient(AExeName: string);
var
  LStr: string;
begin
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + 'VesselInfo4SeaWeb.sqlite';
  VesselInfo4SeaWebModel:= CreateVesselInfo4SeaWebModel;
  g_VesselInfo4SeaWebDB:= TSQLRestClientDB.Create(VesselInfo4SeaWebModel, CreateVesselInfo4SeaWebModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_VesselInfo4SeaWebDB).Server.CreateMissingTables;

  if not Assigned(g_VesselMasterDB) then
  begin
    LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
    LStr := LStr + 'VesselList.sqlite';
    VesselMasterModel:= CreateVesselMasterModel;
    g_VesselMasterDB:= TSQLRestClientDB.Create(VesselMasterModel, CreateVesselMasterModel,
      LStr, TSQLRestServerDB);
    TSQLRestClientDB(g_VesselMasterDB).Server.CreateMissingTables;
  end;
end;

function CreateVesselMasterModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLVesselMaster]);
end;

function CreateVesselInfo4SeaWebModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLVesselInfo4SeaWeb]);
end;

function GetVesselMasterFromHullNo(const AHullNo: string): TSQLVesselMaster;
begin
  Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB,
    'HullNo LIKE ?', ['%'+AHullNo+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVesselMasterFromShipName(const AShipName: string): TSQLVesselMaster;
begin
  Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB,
    'ShipName LIKE ?', ['%'+AShipName+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVesselMasterFromIMONo(const AIMONo: string): TSQLVesselMaster;
begin
  Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB,
    'IMONo LIKE ?', ['%'+AIMONo+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVesselMasterFromOwnerName(const AOwnerName: string): TSQLVesselMaster;
begin
  Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB,
    'OwnerName LIKE ?', ['%'+AOwnerName+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVesselMasterFromTechName(const ATechName: string): TSQLVesselMaster;
begin
  Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB,
    'TechManagerName LIKE ?', ['%'+ATechName+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVesselMasterFromOperatorName(const AOperatorName: string): TSQLVesselMaster;
begin
  Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB,
    'OperatorName LIKE ?', ['%'+AOperatorName+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVesselMasterFromSpecialSurveyDueZero: TSQLVesselMaster;
begin
  Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB,
    'SpecialSurveyDueDate = ?', [0]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVesselMasterFromDockingSurveyDueZero: TSQLVesselMaster;
begin
  Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB,
    'DockingSurveyDueDate = ?', [0]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVesselMasterFromUpdatedZero: TSQLVesselMaster;
begin
  Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB,
    'UpdatedDate = ?', [0]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVesselInfo4SeaWebFromIMONo(const AIMONo: string): TSQLVesselInfo4SeaWeb;
begin
  Result := TSQLVesselInfo4SeaWeb.CreateAndFillPrepare(g_VesselInfo4SeaWebDB,
    'IMONo LIKE ?', ['%'+AIMONo+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure AddVesselMasterFromVariant(ADoc: variant);
var
  LSQLVesselMaster: TSQLVesselMaster;
begin
  LSQLVesselMaster := TSQLVesselMaster.Create;
  LSQLVesselMaster.IsUpdate := False;

  try
    LoadVesselMasterFromVariant(LSQLVesselMaster, ADoc);
    AddOrUpdateVesselMaster(LSQLVesselMaster);
  finally
    FreeAndNil(LSQLVesselMaster);
  end;
end;

procedure AddOrUpdateVesselMasterFromVariant(ADoc: variant);
var
  LSQLVesselMaster: TSQLVesselMaster;
begin
  LSQLVesselMaster := GetVesselMasterFromIMONo(ADoc.IMONo);
//  LSQLVesselMaster := GetVesselMasterFromHullNo(ADoc.HullNo);
  try
//    if not LSQLVesselMaster.IsUpdate then
//    begin
      LoadVesselMasterFromVariant(LSQLVesselMaster, ADoc);
      AddOrUpdateVesselMaster(LSQLVesselMaster);
//    end;
  finally
    FreeAndNil(LSQLVesselMaster);
  end;
end;

procedure AddOrUpdateVesselDeliveryDateFromVariant(ADoc: variant);
var
  LSQLVesselMaster: TSQLVesselMaster;
begin
  LSQLVesselMaster := GetVesselMasterFromHullNo(ADoc.HullNo);
  try
    if LSQLVesselMaster.IsUpdate then
      LoadVesselDeliveryDateFromVariant(LSQLVesselMaster, ADoc)
    else
      LoadVesselDeliveryDateFromVariant2(LSQLVesselMaster, ADoc);

    AddOrUpdateVesselMaster(LSQLVesselMaster);
  finally
    FreeAndNil(LSQLVesselMaster);
  end;
end;

procedure LoadVesselDeliveryDateFromVariant(AVesselMaster:TSQLVesselMaster; ADoc: variant);
var
  LStr, LYear, LMon, LDay: string;
  Ly, Lm, Ld: word;
begin
  if ADoc = null then
    exit;

  if AVesselMaster.ShipTypeDesc = '' then
    AVesselMaster.ShipTypeDesc := ADoc.ShipTypeDesc;

  LStr := ADoc.DeliveryDate;

  if LStr <> '' then
  begin
    LYear := strToken(LStr,'-');
    LMon := strToken(LStr,'-');
    LDay := strToken(LStr,'-');

    Ly := StrToInt(LYear);
    Lm := StrToInt(LMon);
    Ld := StrToInt(LDay);

    AVesselMaster.DeliveryDate := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
    AVesselMaster.UpdatedDate := TimeLogFromDateTime(now);
  end;

end;

procedure LoadVesselDeliveryDateFromVariant2(AVesselMaster:TSQLVesselMaster; ADoc: variant);
var
  LStr, LYear, LMon, LDay: string;
  Ly, Lm, Ld: word;
begin
  if ADoc = null then
    exit;

  AVesselMaster.HullNo := ADoc.HullNo;
  AVesselMaster.ShipName := ADoc.ShipName;
  AVesselMaster.ShipBuilderName := ADoc.ShipBuilderName;
  AVesselMaster.SClass1 := ADoc.SClass1;
  AVesselMaster.ShipType := ADoc.ShipType;
  AVesselMaster.ShipTypeDesc := ADoc.ShipTypeDesc;
  LStr := ADoc.DeliveryDate;

  if LStr <> '' then
  begin
    LYear := strToken(LStr,'-');
    LMon := strToken(LStr,'-');
    LDay := strToken(LStr,'-');

    Ly := StrToInt(LYear);
    Lm := StrToInt(LMon);
    Ld := StrToInt(LDay);

    AVesselMaster.DeliveryDate := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
  end;

  AVesselMaster.UpdatedDate := TimeLogFromDateTime(now);
end;

procedure LoadVesselGPNDeliveryDateFromVariant(AVesselMaster:TSQLVesselMaster; ADoc: variant);
var
  LStr, LYear, LMon, LDay: string;
  Ly, Lm, Ld: word;
begin
  if ADoc = null then
    exit;

  AVesselMaster.IMONo := ADoc.IMONo;
  LStr := ADoc.DeliveryDate;
  if LStr <> '' then
  begin
    LYear := strToken(LStr,'-');
    LMon := strToken(LStr,'-');
    LDay := strToken(LStr,'-');
    Ly := StrToInt(LYear);
    Lm := StrToInt(LMon);
    Ld := StrToInt(LDay);
    AVesselMaster.DeliveryDate := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
  end;

  LStr := ADoc.GuaranteePeriod;
  if LStr <> '' then
  begin
    LYear := strToken(LStr,'-');
    LMon := strToken(LStr,'-');
    LDay := strToken(LStr,'-');
    Ly := StrToInt(LYear);
    Lm := StrToInt(LMon);
    Ld := StrToInt(LDay);
    AVesselMaster.GuaranteePeriod := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
  end;
end;

procedure AddOrUpdateVesselGPNDeliveryDateFromVariant(ADoc: variant);
var
  LSQLVesselMaster: TSQLVesselMaster;
begin
  LSQLVesselMaster := GetVesselMasterFromIMONo(ADoc.IMONo);
  try
    if LSQLVesselMaster.IsUpdate then
    begin
      LoadVesselGPNDeliveryDateFromVariant(LSQLVesselMaster, ADoc);
      AddOrUpdateVesselMaster(LSQLVesselMaster);
    end;
  finally
    FreeAndNil(LSQLVesselMaster);
  end;
end;

procedure AddOrUpdateVesselInfo4SeaWebFromVariant(ADoc: variant);
var
  LSQLVesselInfo4SeaWeb: TSQLVesselInfo4SeaWeb;
begin
  LSQLVesselInfo4SeaWeb := GetVesselInfo4SeaWebFromIMONo(ADoc.IMONo);
  try
//    if LSQLVesselInfo4SeaWeb.IsUpdate then
//    begin
      LoadVesselInfo4SeaWebFromVariant(LSQLVesselInfo4SeaWeb, ADoc);
      AddOrUpdateVesselInfo4SeaWeb(LSQLVesselInfo4SeaWeb);
//    end;
  finally
    FreeAndNil(LSQLVesselInfo4SeaWeb);
  end;
end;

function GetVesselInfo4SeaWebFromUpdatedNotZero: TSQLVesselInfo4SeaWeb;
begin
  Result := TSQLVesselInfo4SeaWeb.CreateAndFillPrepare(g_VesselInfo4SeaWebDB,
    'UpdatedDate <> ?', [0]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure LoadVesselInfo4SeaWebFromVariant(AVesselInfo4SeaWeb:TSQLVesselInfo4SeaWeb;
  ADoc: variant);
var
  LStr, LYear, LMon, LDay: string;
  Ly, Lm, Ld: word;
begin
  if ADoc = null then
    exit;

  AVesselInfo4SeaWeb.IMONo := ADoc.IMONo;
  AVesselInfo4SeaWeb.ShipBuilderName := ADoc.ShipBuilderName;
  AVesselInfo4SeaWeb.HullNo := ADoc.HullNo;
  AVesselInfo4SeaWeb.ShipName := ADoc.ShipName;
  AVesselInfo4SeaWeb.ShipTypeDesc := ADoc.ShipTypeDesc;
  AVesselInfo4SeaWeb.OwnerName := ADoc.OwnerName;
  AVesselInfo4SeaWeb.OwnerCountry := ADoc.OwnerCountry;
  AVesselInfo4SeaWeb.OperatorName := ADoc.OperatorName;
  AVesselInfo4SeaWeb.OperatorCountry := ADoc.OperatorCountry;
  AVesselInfo4SeaWeb.TechManagerName := ADoc.TechManagerName;
  AVesselInfo4SeaWeb.TechManagerCountry := ADoc.TechManagerCountry;
  AVesselInfo4SeaWeb.VesselStatus := ADoc.VesselStatus;

  LStr := ADoc.SpecialSurveyDueDate;
  if LStr <> '' then
  begin
    LYear := strToken(LStr,'-');
    LMon := strToken(LStr,'-');
    LDay := strToken(LStr,'-');
    Ly := StrToInt(LYear);
    Lm := StrToInt(LMon);
    Ld := StrToInt(LDay);
    AVesselInfo4SeaWeb.SpecialSurveyDueDate := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
  end;

  LStr := ADoc.DockingSurveyDueDate;
  if LStr <> '' then
  begin
    LYear := strToken(LStr,'-');
    LMon := strToken(LStr,'-');
    LDay := strToken(LStr,'-');
    Ly := StrToInt(LYear);
    Lm := StrToInt(LMon);
    Ld := StrToInt(LDay);
    AVesselInfo4SeaWeb.DockingSurveyDueDate := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
  end;

  AVesselInfo4SeaWeb.UpdatedDate := TimeLogFromDateTime(now);
end;

function GetVariantFromVesselMaster(AVesselMaster:TSQLVesselMaster): variant;
begin
  TDocVariant.New(Result);

  Result.TaskID := IntToStr(AVesselMaster.TaskID);
  Result.HullNo := AVesselMaster.HullNo;
  Result.ShipName := AVesselMaster.ShipName;
  Result.IMONo := AVesselMaster.IMONo;
  Result.ShipName := AVesselMaster.ShipName;
  Result.ShipBuilderID := AVesselMaster.ShipBuilderID;
  Result.ShipBuilderName := AVesselMaster.ShipBuilderName;
  Result.SClass1 := AVesselMaster.SClass1;
  Result.SClass2 := AVesselMaster.SClass2;
  Result.ShipType := AVesselMaster.ShipType;
  Result.OwnerID := AVesselMaster.OwnerID;
  Result.OwnerName := AVesselMaster.OwnerName;
  Result.TechManagerCountry := AVesselMaster.TechManagerCountry;
  Result.TechManagerID := AVesselMaster.TechManagerID;
  Result.TechManagerName := AVesselMaster.TechManagerName;
  Result.OperatorID := AVesselMaster.OperatorID;
  Result.OperatorName := AVesselMaster.OperatorName;
  Result.BuyingCompanyCountry := AVesselMaster.BuyingCompanyCountry;
  Result.BuyingCompanyID := AVesselMaster.BuyingCompanyID;
  Result.BuyingCompanyName := AVesselMaster.BuyingCompanyName;
  Result.VesselStatus := AVesselMaster.VesselStatus;
  Result.InstalledProductTypes := TShipProductType_SetToInt(AVesselMaster.InstalledProductTypes);

  Result.ShipTypeDesc := AVesselMaster.ShipTypeDesc;

  Result.DeliveryDate := AVesselMaster.DeliveryDate;
  Result.LastDryDockDate := AVesselMaster.LastDryDockDate;
  Result.SpecialSurveyDueDate := AVesselMaster.SpecialSurveyDueDate;
  Result.DockingSurveyDueDate := AVesselMaster.DockingSurveyDueDate;
  Result.UpdatedDate := AVesselMaster.UpdatedDate;
end;

procedure LoadVesselMasterFromVariant(AVesselMaster:TSQLVesselMaster; ADoc: variant);
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

  AVesselMaster.HullNo := ADoc.HullNo;
  AVesselMaster.ShipName := ADoc.ShipName;
  AVesselMaster.IMONo := ADoc.IMONo;
  AVesselMaster.ShipBuilderID := ADoc.ShipBuilderID;
  AVesselMaster.ShipBuilderName := ADoc.ShipBuilderName;
  AVesselMaster.SClass1 := ADoc.SClass1;
  AVesselMaster.SClass2 := ADoc.SClass2;
  AVesselMaster.ShipType := ADoc.ShipType;
  AVesselMaster.OwnerID := ADoc.OwnerID;
  AVesselMaster.OwnerName := ADoc.OwnerName;
  AVesselMaster.TechManagerCountry := ADoc.TechManagerCountry;
  AVesselMaster.TechManagerID := ADoc.TechManagerID;
  AVesselMaster.TechManagerName := ADoc.TechManagerName;
  AVesselMaster.OperatorID := ADoc.OperatorID;
  AVesselMaster.OperatorName := ADoc.OperatorName;
  AVesselMaster.BuyingCompanyCountry := ADoc.BuyingCompanyCountry;
  AVesselMaster.BuyingCompanyID := ADoc.BuyingCompanyID;
  AVesselMaster.BuyingCompanyName := ADoc.BuyingCompanyName;
  AVesselMaster.VesselStatus := ADoc.VesselStatus;

  AVesselMaster.ShipTypeDesc := ADoc.ShipTypeDesc;
  LStr := ADoc.DeliveryDate;
  AVesselMaster.DeliveryDate := GetDateFromStr(LStr);
  LStr := ADoc.SpecialSurveyDueDate;
  AVesselMaster.LastDryDockDate := GetDateFromStr(LStr);
  LStr := ADoc.SpecialSurveyDueDate;
  AVesselMaster.SpecialSurveyDueDate := GetDateFromStr(LStr);
  LStr := ADoc.DockingSurveyDueDate;
  AVesselMaster.DockingSurveyDueDate := GetDateFromStr(LStr);
//  AVesselMaster.UpdatedDate := GetDateFromStr(LStr);

//  if ADoc.SpecialSurveyDueDate <> null then
//    AVesselMaster.SpecialSurveyDueDate := TimeLogFromDateTime(StrToDate(ADoc.SpecialSurveyDueDate));

//  if ADoc.DockingSurveyDueDate <> null then
//    AVesselMaster.DockingSurveyDueDate := TimeLogFromDateTime(StrToDate(ADoc.DockingSurveyDueDate));
end;

function GetVesselMasterFromSearchRec(AVesselSearchParamRec: TVesselSearchParamRec): TSQLVesselMaster;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
  LFrom, LTo: TTimeLog;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if AVesselSearchParamRec.fQueryDate <> vqdtNull then
    begin
      if AVesselSearchParamRec.FFrom <= AVesselSearchParamRec.FTo then
      begin
        LFrom := TimeLogFromDateTime(AVesselSearchParamRec.FFrom);
        LTo := TimeLogFromDateTime(AVesselSearchParamRec.FTo);

        if AVesselSearchParamRec.FQueryDate <> vqdtNull then
        begin
          LWhere := GetSqlWhereFromVesselQueryDate(AVesselSearchParamRec.FQueryDate);
          if LWhere <> '' then
            AddConstArray(ConstArray, [LFrom, LTo]);
        end;
      end;
    end;

    if AVesselSearchParamRec.fHullNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fHullNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'HullNo LIKE ? ';
    end;

    if AVesselSearchParamRec.fShipName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fShipName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ShipName LIKE ? ';
    end;

    if AVesselSearchParamRec.fShipBuilderName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fShipBuilderName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ShipBuilderName LIKE ? ';
    end;

    if AVesselSearchParamRec.fOwnerName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fOwnerName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'OwnerName LIKE ? ';
    end;

    if AVesselSearchParamRec.fTechManagerName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fTechManagerName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'TechManagerName LIKE ? ';
    end;

    if AVesselSearchParamRec.fTechManagerCountry <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fTechManagerCountry+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'TechManagerCountry LIKE ? ';
    end;

    if AVesselSearchParamRec.fOperatorName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fOperatorName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'OperatorName LIKE ? ';
    end;

    if AVesselSearchParamRec.fIMONo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fIMONo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'IMONo LIKE ? ';
    end;

    if AVesselSearchParamRec.fVesselStatus <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fVesselStatus+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'VesselStatus LIKE ? ';
    end;

    if AVesselSearchParamRec.fShipBuilderName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fShipBuilderName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ShipBuilderName LIKE ? ';
    end;

    if AVesselSearchParamRec.fClass <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fClass+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'SClass1 LIKE ? ';
    end;

    if AVesselSearchParamRec.fShipType <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AVesselSearchParamRec.fShipType+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ShipType LIKE ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    Result := TSQLVesselMaster.CreateAndFillPrepare(g_VesselMasterDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end
    else
    begin
      Result := TSQLVesselMaster.Create;
      Result.IsUpdate := False;
    end
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

function GetSqlWhereFromVesselQueryDate(AVesselQueryDateType: TVesselQueryDateType): string;
begin
  case AVesselQueryDateType of
    vqdtDockingSurveyDate: Result := 'DockingSurveyDueDate >= ? and DockingSurveyDueDate <= ? ';
    vqdtSpecialSurveyDate: Result := 'SpecialSurveyDueDate >= ? and SpecialSurveyDueDate <= ? ';
    vqdtDeliveryDate: Result := 'DeliveryDate >= ? and DeliveryDate <= ? ';
    vqdtGuaranteePeriod: Result := 'GuaranteePeriod >= ? and GuaranteePeriod <= ? ';
  end;
end;

procedure AddOrUpdateVesselMaster(AVesselMaster: TSQLVesselMaster);
begin
  if AVesselMaster.IsUpdate then
  begin
    g_VesselMasterDB.Update(AVesselMaster);
  end
  else
  begin
    g_VesselMasterDB.Add(AVesselMaster, true);
  end;
end;

procedure AddOrUpdateVesselInfo4SeaWeb(AVesselInfo4SeaWeb: TSQLVesselInfo4SeaWeb);
begin
  if AVesselInfo4SeaWeb.IsUpdate then
  begin
    g_VesselInfo4SeaWebDB.Update(AVesselInfo4SeaWeb);
  end
  else
  begin
    g_VesselInfo4SeaWebDB.Add(AVesselInfo4SeaWeb, true);
  end;
end;

function AddVesselInfoFromSeaWebDB: integer;
var
  LSQLVesselMaster: TSQLVesselMaster;
  LSQLVesselInfo4SeaWeb: TSQLVesselInfo4SeaWeb;
begin
  LSQLVesselInfo4SeaWeb := GetVesselInfo4SeaWebFromUpdatedNotZero;
  try
    LSQLVesselInfo4SeaWeb.FillRewind;
    Result := 0;

    while LSQLVesselInfo4SeaWeb.FillOne do
    begin
      if LSQLVesselInfo4SeaWeb.IMONo <> '' then
      begin
        LSQLVesselMaster := GetVesselMasterFromIMONo(LSQLVesselInfo4SeaWeb.IMONo);
        try
          LoadVesselInfoFromSeaWebDB(LSQLVesselMaster, LSQLVesselInfo4SeaWeb);
          AddOrUpdateVesselMaster(LSQLVesselMaster);
          Inc(Result);
        finally
          FreeAndNil(LSQLVesselMaster);
        end;
      end;
    end;
  finally
    FreeAndNil(LSQLVesselInfo4SeaWeb);
  end;
end;

function UpdateDockSurveyDateFromSeaWebDB: integer;
var
  LSQLVesselMaster: TSQLVesselMaster;
  LSQLVesselInfo4SeaWeb: TSQLVesselInfo4SeaWeb;
begin
  LSQLVesselInfo4SeaWeb := GetVesselInfo4SeaWebFromUpdatedNotZero;
  try
    LSQLVesselInfo4SeaWeb.FillRewind;
    Result := 0;

    while LSQLVesselInfo4SeaWeb.FillOne do
    begin
      if LSQLVesselInfo4SeaWeb.IMONo <> '' then
      begin
        LSQLVesselMaster := GetVesselMasterFromIMONo(LSQLVesselInfo4SeaWeb.IMONo);
        try
          if LSQLVesselMaster.IsUpdate then
          begin
            LoadVesselDockDueDateFromSeaWebDB(LSQLVesselMaster, LSQLVesselInfo4SeaWeb);
            AddOrUpdateVesselMaster(LSQLVesselMaster);
            Inc(Result);
          end;
        finally
          FreeAndNil(LSQLVesselMaster);
        end;
      end;
    end;
  finally
    FreeAndNil(LSQLVesselInfo4SeaWeb);
  end;
end;

procedure LoadVesselDockDueDateFromSeaWebDB(ASQLVesselMaster: TSQLVesselMaster;
  ASQLVesselInfo4SeaWeb: TSQLVesselInfo4SeaWeb);
begin
  if ASQLVesselInfo4SeaWeb.SpecialSurveyDueDate > ASQLVesselMaster.SpecialSurveyDueDate then
    ASQLVesselMaster.SpecialSurveyDueDate := ASQLVesselInfo4SeaWeb.SpecialSurveyDueDate;

  if ASQLVesselInfo4SeaWeb.DockingSurveyDueDate > ASQLVesselMaster.DockingSurveyDueDate then
    ASQLVesselMaster.DockingSurveyDueDate := ASQLVesselInfo4SeaWeb.DockingSurveyDueDate;

  if ASQLVesselInfo4SeaWeb.ShipTypeDesc <> '' then
    ASQLVesselMaster.ShipTypeDesc := ASQLVesselInfo4SeaWeb.ShipTypeDesc;

  if ASQLVesselInfo4SeaWeb.OwnerName <> '' then
    ASQLVesselMaster.OwnerName := ASQLVesselInfo4SeaWeb.OwnerName;
  if ASQLVesselInfo4SeaWeb.OwnerCountry <> '' then
    ASQLVesselMaster.OwnerCountry := ASQLVesselInfo4SeaWeb.OwnerCountry;
  if ASQLVesselInfo4SeaWeb.OperatorName <> '' then
    ASQLVesselMaster.OperatorName := ASQLVesselInfo4SeaWeb.OperatorName;
  if ASQLVesselInfo4SeaWeb.OperatorCountry <> '' then
    ASQLVesselMaster.OperatorCountry := ASQLVesselInfo4SeaWeb.OperatorCountry;
  if ASQLVesselInfo4SeaWeb.TechManagerName <> '' then
    ASQLVesselMaster.TechManagerName := ASQLVesselInfo4SeaWeb.TechManagerName;
  if ASQLVesselInfo4SeaWeb.TechManagerCountry <> '' then
    ASQLVesselMaster.TechManagerCountry := ASQLVesselInfo4SeaWeb.TechManagerCountry;

  ASQLVesselMaster.UpdatedDate := TimeLogFromDateTime(now);
end;

procedure LoadVesselInfoFromSeaWebDB(ASQLVesselMaster: TSQLVesselMaster;
  ASQLVesselInfo4SeaWeb: TSQLVesselInfo4SeaWeb);
begin
  if ASQLVesselInfo4SeaWeb.SpecialSurveyDueDate > ASQLVesselMaster.SpecialSurveyDueDate then
    ASQLVesselMaster.SpecialSurveyDueDate := ASQLVesselInfo4SeaWeb.SpecialSurveyDueDate;

  if ASQLVesselInfo4SeaWeb.DockingSurveyDueDate > ASQLVesselMaster.DockingSurveyDueDate then
    ASQLVesselMaster.DockingSurveyDueDate := ASQLVesselInfo4SeaWeb.DockingSurveyDueDate;

  if ASQLVesselInfo4SeaWeb.ShipTypeDesc <> '' then
    ASQLVesselMaster.ShipTypeDesc := ASQLVesselInfo4SeaWeb.ShipTypeDesc;

  if ASQLVesselInfo4SeaWeb.HullNo <> '' then
    ASQLVesselMaster.HullNo := ASQLVesselInfo4SeaWeb.HullNo;
  if ASQLVesselInfo4SeaWeb.ShipName <> '' then
    ASQLVesselMaster.ShipName := ASQLVesselInfo4SeaWeb.ShipName;
  if ASQLVesselInfo4SeaWeb.IMONo <> '' then
    ASQLVesselMaster.IMONo := ASQLVesselInfo4SeaWeb.IMONo;
  if ASQLVesselInfo4SeaWeb.ShipBuilderName <> '' then
    ASQLVesselMaster.ShipBuilderName := ASQLVesselInfo4SeaWeb.ShipBuilderName;
  if ASQLVesselInfo4SeaWeb.OwnerName <> '' then
    ASQLVesselMaster.OwnerName := ASQLVesselInfo4SeaWeb.OwnerName;
  if ASQLVesselInfo4SeaWeb.OwnerCountry <> '' then
    ASQLVesselMaster.OwnerCountry := ASQLVesselInfo4SeaWeb.OwnerCountry;
  if ASQLVesselInfo4SeaWeb.OperatorName <> '' then
    ASQLVesselMaster.OperatorName := ASQLVesselInfo4SeaWeb.OperatorName;
  if ASQLVesselInfo4SeaWeb.OperatorCountry <> '' then
    ASQLVesselMaster.OperatorCountry := ASQLVesselInfo4SeaWeb.OperatorCountry;
  if ASQLVesselInfo4SeaWeb.TechManagerName <> '' then
    ASQLVesselMaster.TechManagerName := ASQLVesselInfo4SeaWeb.TechManagerName;
  if ASQLVesselInfo4SeaWeb.TechManagerCountry <> '' then
    ASQLVesselMaster.TechManagerCountry := ASQLVesselInfo4SeaWeb.TechManagerCountry;
  if ASQLVesselInfo4SeaWeb.VesselStatus <> '' then
    ASQLVesselMaster.VesselStatus := ASQLVesselInfo4SeaWeb.VesselStatus;

  ASQLVesselMaster.UpdatedDate := TimeLogFromDateTime(now);
end;

initialization

finalization
  if Assigned(VesselMasterModel) then
    FreeAndNil(VesselMasterModel);

  if Assigned(g_VesselMasterDB) then
    FreeAndNil(g_VesselMasterDB);

  if Assigned(VesselInfo4SeaWebModel) then
    FreeAndNil(VesselInfo4SeaWebModel);

  if Assigned(g_VesselInfo4SeaWebDB) then
    FreeAndNil(g_VesselInfo4SeaWebDB);

end.

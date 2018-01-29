unit UnitVesselMasterRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  CommonData;

type
  TVesselSearchParamRec = record
    fHullNo,
    fShipName,
    fShipBuilderName,
    fOwnerName,
    fTechManagerName,
    fOperatorName,
    fIMONo
    : RawUtf8;
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
  end;

  TSQLVesselMaster = class(TSQLVesselBase)
  private
    fSocietyClass1,
    fSocietyClass2,
    fShipType,
    fOwnerID,
    fOwnerName,
    fTechManageCountry,
    fTechManagerID,
    fTechManagerName,
    fOperatorID,
    fOperatorName,
    fBuyingCompanyCountry,
    fBuyingCompanyID,
    fBuyingCompanyName,
    fVesselStatus
    : RawUTF8;

//    fSpecialSurveyDue,
//    fDockingSurveyDue: TTimeLog;
  published
    property SClass1: RawUTF8 read fSocietyClass1 write fSocietyClass1;
    property SClass2: RawUTF8 read fSocietyClass2 write fSocietyClass2;
    property ShipType: RawUTF8 read fShipType write fShipType;
    property OwnerID: RawUTF8 read fOwnerID write fOwnerID;
    property OwnerName: RawUTF8 read fOwnerName write fOwnerName;
    property TechManageCountry: RawUTF8 read fTechManageCountry write fTechManageCountry;
    property TechManagerID: RawUTF8 read fTechManagerID write fTechManagerID;
    property TechManagerName: RawUTF8 read fTechManagerName write fTechManagerName;
    property OperatorID: RawUTF8 read fOperatorID write fOperatorID;
    property OperatorName: RawUTF8 read fOperatorName write fOperatorName;
    property BuyingCompanyCountry: RawUTF8 read fBuyingCompanyCountry write fBuyingCompanyCountry;
    property BuyingCompanyID: RawUTF8 read fBuyingCompanyID write fBuyingCompanyID;
    property BuyingCompanyName: RawUTF8 read fBuyingCompanyName write fBuyingCompanyName;
    property VesselStatus: RawUTF8 read fVesselStatus write fVesselStatus;

//    property SpecialSurveyDueDate: TTimeLog read fSpecialSurveyDue write fSpecialSurveyDue;
//    property DockingSurveyDueDate: TTimeLog read fDockingSurveyDue write fDockingSurveyDue;
  end;

procedure InitVesselMasterClient();
function CreateVesselMasterModel: TSQLModel;

function GetVesselMasterFromHullNo(const AHullNo: string): TSQLVesselMaster;
function GetVesselMasterFromShipName(const AShipName: string): TSQLVesselMaster;
function GetVesselMasterFromIMONo(const AIMONo: string): TSQLVesselMaster;
function GetVesselMasterFromOwnerName(const AOwnerName: string): TSQLVesselMaster;
function GetVesselMasterFromTechName(const ATechName: string): TSQLVesselMaster;
function GetVesselMasterFromOperatorName(const AOperatorName: string): TSQLVesselMaster;

procedure AddVesselMasterFromVariant(ADoc: variant);
procedure AddOrUpdateVesselMasterFromVariant(ADoc: variant);
function GetVariantFromVesselMaster(AVesselMaster:TSQLVesselMaster): variant;
procedure LoadVesselMasterFromVariant(AVesselMaster:TSQLVesselMaster; ADoc: variant);

function GetVesselMasterFromSearchRec(AVesselSearchParamRec: TVesselSearchParamRec): TSQLVesselMaster;

procedure AddOrUpdateVesselMaster(AVesselMaster: TSQLVesselMaster);

var
  g_VesselMasterDB: TSQLRestClientURI;
  VesselMasterModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs;

procedure InitVesselMasterClient();
var
  LStr: string;
begin
  LStr := ChangeFileExt(Application.ExeName,'.sqlite');
  VesselMasterModel:= CreateVesselMasterModel;
  g_VesselMasterDB:= TSQLRestClientDB.Create(VesselMasterModel, CreateVesselMasterModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_VesselMasterDB).Server.CreateMissingTables;
end;

function CreateVesselMasterModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLVesselMaster]);
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
  try
    if not LSQLVesselMaster.IsUpdate then
    begin
      LoadVesselMasterFromVariant(LSQLVesselMaster, ADoc);
      AddOrUpdateVesselMaster(LSQLVesselMaster);
    end;
  finally
    FreeAndNil(LSQLVesselMaster);
  end;
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
  Result.TechManageCountry := AVesselMaster.TechManageCountry;
  Result.TechManagerID := AVesselMaster.TechManagerID;
  Result.TechManagerName := AVesselMaster.TechManagerName;
  Result.OperatorID := AVesselMaster.OperatorID;
  Result.OperatorName := AVesselMaster.OperatorName;
  Result.BuyingCompanyCountry := AVesselMaster.BuyingCompanyCountry;
  Result.BuyingCompanyID := AVesselMaster.BuyingCompanyID;
  Result.BuyingCompanyName := AVesselMaster.BuyingCompanyName;
  Result.VesselStatus := AVesselMaster.VesselStatus;

//  Result.SpecialSurveyDueDate := DateTimeToStr(TimeLogToDateTime(AVesselMaster.SpecialSurveyDueDate));
//  Result.DockingSurveyDueDate := DateTimeToStr(TimeLogToDateTime(AVesselMaster.DockingSurveyDueDate));
end;

procedure LoadVesselMasterFromVariant(AVesselMaster:TSQLVesselMaster; ADoc: variant);
begin
  if ADoc = null then
    exit;

  AVesselMaster.HullNo := ADoc.HullNo;
  AVesselMaster.ShipName := ADoc.ShipName;
  AVesselMaster.IMONo := ADoc.IMONo;
  AVesselMaster.ShipName := ADoc.ShipName;
  AVesselMaster.ShipBuilderID := ADoc.ShipBuilderID;
  AVesselMaster.ShipBuilderName := ADoc.ShipBuilderName;
  AVesselMaster.SClass1 := ADoc.SClass1;
  AVesselMaster.SClass2 := ADoc.SClass2;
  AVesselMaster.ShipType := ADoc.ShipType;
  AVesselMaster.OwnerID := ADoc.OwnerID;
  AVesselMaster.OwnerName := ADoc.OwnerName;
  AVesselMaster.TechManageCountry := ADoc.TechManageCountry;
  AVesselMaster.TechManagerID := ADoc.TechManagerID;
  AVesselMaster.TechManagerName := ADoc.TechManagerName;
  AVesselMaster.OperatorID := ADoc.OperatorID;
  AVesselMaster.OperatorName := ADoc.OperatorName;
  AVesselMaster.BuyingCompanyCountry := ADoc.BuyingCompanyCountry;
  AVesselMaster.BuyingCompanyID := ADoc.BuyingCompanyID;
  AVesselMaster.BuyingCompanyName := ADoc.BuyingCompanyName;
  AVesselMaster.VesselStatus := ADoc.VesselStatus;

//  if ADoc.SpecialSurveyDueDate <> null then
//    AVesselMaster.SpecialSurveyDueDate := TimeLogFromDateTime(StrToDate(ADoc.SpecialSurveyDueDate));

//  if ADoc.DockingSurveyDueDate <> null then
//    AVesselMaster.DockingSurveyDueDate := TimeLogFromDateTime(StrToDate(ADoc.DockingSurveyDueDate));
end;

function GetVesselMasterFromSearchRec(AVesselSearchParamRec: TVesselSearchParamRec): TSQLVesselMaster;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
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

procedure AddOrUpdateVesselMaster(AVesselMaster: TSQLVesselMaster);
begin
  if AVesselMaster.IsUpdate then
  begin
    g_VesselMasterDB.Update(AVesselMaster);
    ShowMessage('Task Update 완료');
  end
  else
  begin
    g_VesselMasterDB.Add(AVesselMaster, true);
//    ShowMessage('Task Add 완료');
  end;
end;

initialization

finalization
  if Assigned(VesselMasterModel) then
    FreeAndNil(VesselMasterModel);

  if Assigned(g_VesselMasterDB) then
    FreeAndNil(g_VesselMasterDB);

end.

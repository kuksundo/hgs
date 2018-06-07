unit UnitElecMasterRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  CommonData, UnitElecMasterData;

type
  TElecSearchParamRec = record
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

  TSQLElecMaster = class(TSQLRecord)
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
    fProductType: TElecProductType;
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

    property ProductType: TElecProductType read fProductType write fProductType;

    property InstalledCount: integer read fInstalledCount write fInstalledCount;
    property WarrantyMonth1: integer read fWarrantyMonth1 write fWarrantyMonth1;
    property WarrantyMonth2: integer read fWarrantyMonth2 write fWarrantyMonth2;

    property ProductDeliveryDate: TTimeLog read fProductDeliveryDate write fProductDeliveryDate;
    property ShipDeliveryDate: TTimeLog read fShipDeliveryDate write fShipDeliveryDate;
    property WarrantyDueDate: TTimeLog read fWarrantyDueDate write fWarrantyDueDate;
    property UpdatedDate: TTimeLog read fUpdatedDate write fUpdatedDate;
  end;

procedure InitElecMasterClient(AElecMasterDBName: string = '');
function CreateElecMasterModel: TSQLModel;

function GetElecMasterFromHullNo(const AHullNo: string): TSQLElecMaster;
function GetElecMasterFromHullNoStrict(const AHullNo: string): TSQLElecMaster;
function GetElecMasterFromIMONo(const AIMONo: string): TSQLElecMaster;
function GetVariantFromElecMaster(AElecMaster:TSQLElecMaster): Variant;
function GetElecMasterFromSearchRec(AElecSearchParamRec: TElecSearchParamRec): TSQLElecMaster;
function GetSqlWhereFromElecMasterQueryDate(AElecMasterQueryDateType: TElecMasterQueryDateType): string;

procedure AddOrUpdateElecMaster(AElecMaster: TSQLElecMaster);
procedure AddOrUpdateElecMasterFromVariant(ADoc: variant);
procedure LoadElecMasterFromVariant(AElecMaster: TSQLElecMaster; ADoc: variant);

var
  g_ElecMasterDB: TSQLRestClientURI;
  ElecMasterModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil;

procedure InitElecMasterClient(AElecMasterDBName: string = '');
var
  LStr: string;
begin
  if AElecMasterDBName = '' then
    AElecMasterDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + AElecMasterDBName;
  ElecMasterModel:= CreateElecMasterModel;
  g_ElecMasterDB:= TSQLRestClientDB.Create(ElecMasterModel, CreateElecMasterModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_ElecMasterDB).Server.CreateMissingTables;
end;

function CreateElecMasterModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLElecMaster]);
end;

function GetElecMasterFromHullNo(const AHullNo: string): TSQLElecMaster;
begin
  Result := TSQLElecMaster.CreateAndFillPrepare(g_ElecMasterDB,
    'HullNo LIKE ?', ['%'+AHullNo+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetElecMasterFromHullNoStrict(const AHullNo: string): TSQLElecMaster;
begin
  Result := TSQLElecMaster.CreateAndFillPrepare(g_ElecMasterDB,
    'HullNo = ?', [AHullNo]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetElecMasterFromIMONo(const AIMONo: string): TSQLElecMaster;
begin
  Result := TSQLElecMaster.CreateAndFillPrepare(g_ElecMasterDB,
    'IMONo LIKE ?', ['%'+AIMONo+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetVariantFromElecMaster(AElecMaster:TSQLElecMaster): Variant;
begin
  TDocVariant.New(Result);

  Result.HullNo := AElecMaster.HullNo;
  Result.IMONo := AElecMaster.IMONo;
  Result.ProjectNo := AElecMaster.ProjectNo;
  Result.ProjectName := AElecMaster.ProjectName;
  Result.ProductModel := AElecMaster.ProductModel;
  Result.ProductType := Ord(AElecMaster.ProductType);
  Result.Mark := AElecMaster.Mark;
  Result.Usage := AElecMaster.Usage;
  Result.Class1 := AElecMaster.Class1;
  Result.Class2 := AElecMaster.Class2;

  Result.InstalledCount := AElecMaster.InstalledCount;
  Result.WarrantyMonth1 := AElecMaster.WarrantyMonth1;
  Result.WarrantyMonth2 := AElecMaster.WarrantyMonth2;

  Result.ProductDeliveryDate := AElecMaster.ProductDeliveryDate;
  Result.ShipDeliveryDate := AElecMaster.ShipDeliveryDate;
  Result.WarrantyDueDate := AElecMaster.WarrantyDueDate;
  Result.UpdatedDate := AElecMaster.UpdatedDate;
end;

function GetSqlWhereFromElecMasterQueryDate(AElecMasterQueryDateType: TElecMasterQueryDateType): string;
begin
  case AElecMasterQueryDateType of
    emdtProductDeliveryDate: Result := 'ProductDeliveryDate >= ? and ProductDeliveryDate <= ? ';
    emdtShipDeliveryDate: Result := 'ShipDeliveryDate >= ? and ShipDeliveryDate <= ? ';
    emdtWarrantyDueDate: Result := 'WarrantyDueDate >= ? and WarrantyDueDate <= ? ';
  end;
end;

function GetElecMasterFromSearchRec(AElecSearchParamRec: TElecSearchParamRec): TSQLElecMaster;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
  LFrom, LTo: TTimeLog;
  LElecProductType: TElecProductType;
  LElecMasterQueryDateType: TElecMasterQueryDateType;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if AElecSearchParamRec.QueryDate <> '' then
    begin
      if AElecSearchParamRec.FFrom <= AElecSearchParamRec.FTo then
      begin
        LFrom := TimeLogFromDateTime(AElecSearchParamRec.FFrom);
        LTo := TimeLogFromDateTime(AElecSearchParamRec.FTo);

        if AElecSearchParamRec.QueryDate <> '' then
        begin
          LElecMasterQueryDateType := g_ElecMasterQueryDateType.ToType(AElecSearchParamRec.QueryDate);
          LWhere := GetSqlWhereFromElecMasterQueryDate(LElecMasterQueryDateType);
          if LWhere <> '' then
            AddConstArray(ConstArray, [LFrom, LTo]);
        end;
      end;
    end;

    if AElecSearchParamRec.HullNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AElecSearchParamRec.HullNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'HullNo LIKE ? ';
    end;

    if AElecSearchParamRec.IMONo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AElecSearchParamRec.IMONo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'IMONo LIKE ? ';
    end;

    if AElecSearchParamRec.Class1 <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AElecSearchParamRec.Class1+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'Class1 LIKE ? ';
    end;

    if AElecSearchParamRec.ProductModel <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AElecSearchParamRec.ProductModel+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProductModel LIKE ? ';
    end;

    if AElecSearchParamRec.ProjectName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AElecSearchParamRec.ProjectName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProjectName LIKE ? ';
    end;

    if AElecSearchParamRec.ProjectNo <> '' then
    begin
      AddConstArray(ConstArray, [AElecSearchParamRec.ProjectNo]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProjectNo = ? ';
    end;

    if AElecSearchParamRec.ProductType <> '' then
    begin
      LElecProductType := String2ElecProductType(AElecSearchParamRec.ProductType);
      AddConstArray(ConstArray, [Ord(LElecProductType)]);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'ProductType = ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    Result := TSQLElecMaster.CreateAndFillPrepare(g_ElecMasterDB, Lwhere, ConstArray);

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

procedure AddOrUpdateElecMaster(AElecMaster: TSQLElecMaster);
begin
  if AElecMaster.IsUpdate then
  begin
    g_ElecMasterDB.Update(AElecMaster);
  end
  else
  begin
    g_ElecMasterDB.Add(AElecMaster, true);
  end;
end;

procedure LoadElecMasterFromVariant(AElecMaster: TSQLElecMaster; ADoc: variant);
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

  AElecMaster.HullNo := ADoc.HullNo;
  AElecMaster.IMONo := ADoc.IMONo;
  AElecMaster.ProjectNo := ADoc.ProjectNo;
  AElecMaster.ProjectName := ADoc.ProjectName;
  AElecMaster.ProductModel := ADoc.ProductModel;
  AElecMaster.ProductType := TElecProductType(ADoc.ProductType);
  AElecMaster.Mark := ADoc.Mark;
  AElecMaster.Usage := ADoc.Usage;
  AElecMaster.Class1 := ADoc.Class1;
  AElecMaster.Class2 := ADoc.Class2;

  AElecMaster.InstalledCount := ADoc.InstalledCount;
  AElecMaster.WarrantyMonth1 := ADoc.WarrantyMonth1;
  AElecMaster.WarrantyMonth2 := ADoc.WarrantyMonth2;

  LStr := ADoc.ProductDeliveryDate;
  AElecMaster.ProductDeliveryDate := GetDateFromStr(LStr);
  LStr := ADoc.ShipDeliveryDate;
  AElecMaster.ShipDeliveryDate := GetDateFromStr(LStr);
  LStr := ADoc.WarrantyDueDate;
  AElecMaster.WarrantyDueDate := GetDateFromStr(LStr);
  AElecMaster.UpdatedDate := TimeLogFromDateTime(now);
end;

procedure AddOrUpdateElecMasterFromVariant(ADoc: variant);
var
  LSQLElecMaster: TSQLElecMaster;
begin
  LSQLElecMaster := TSQLElecMaster.Create;// GetElecMasterFromHullNo(ADoc.HullNo);
  try
    LoadElecMasterFromVariant(LSQLElecMaster, ADoc);
    AddOrUpdateElecMaster(LSQLElecMaster);
  finally
    FreeAndNil(LSQLElecMaster);
  end;
end;

initialization

finalization
  if Assigned(ElecMasterModel) then
    FreeAndNil(ElecMasterModel);

  if Assigned(g_ElecMasterDB) then
    FreeAndNil(g_ElecMasterDB);

end.

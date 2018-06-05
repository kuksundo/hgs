unit UnitRegistrationRecord;

interface

uses
  SynCommons, Winapi.Windows,
  mORMot, OnGuard, OgUtil, Registry
  ,UnitRegCodeConst;

type
  TSQLProductManage = class(TSQLRecord)
  private
    fProductCode: RawUTF8;
    fProductName: RawUTF8;
    FAppName: RawUTF8;
    FSrcPath: RawUTF8;
    FExeImage: RawUTF8; //base64
    FLastSerialNo: Longint;
    FFileMajorVersion, FFileMinorVersion,
    FFileRevisionNo, FFileBuildNo,
    FProductMajorVersion, FProductMinorVersion,
    FProductRevisionNo, FProductBuildNo: Word;
    FRegDate : TDateTime;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property ProductCode: RawUTF8 read fProductCode write fProductCode;
    property ProductName: RawUTF8 read fProductName write fProductName;
    property AppName: RawUTF8 read FAppName write FAppName;
    property SrcPath: RawUTF8 read FSrcPath write FSrcPath;
    property ExeImage: RawUTF8 read FExeImage write FExeImage;
    property LastSerialNo: Longint read FLastSerialNo write FLastSerialNo;
    property FileMajorVersion: Word read FFileMajorVersion write FFileMajorVersion;
    property FileMinorVersion: Word read FFileMinorVersion write FFileMinorVersion;
    property FileRevisionNo: Word read FFileRevisionNo write FFileRevisionNo;
    property FileBuildNo: Word read FFileBuildNo write FFileBuildNo;
    property ProductMajorVersion: Word read FProductMajorVersion write FProductMajorVersion;
    property ProductMinorVersion: Word read FProductMinorVersion write FProductMinorVersion;
    property ProductRevisionNo: Word read FProductRevisionNo write FProductRevisionNo;
    property ProductBuildNo: Word  read FProductBuildNo write FProductBuildNo;
    property RegDate: TDateTime read FRegDate write FRegDate;
  end;

  TSQLRegCodeManage = class(TSQLRecord)
  private
    fProductCode: string;
    fProductName: string;
    fTaskID: TID;
    FCustomerCompanyName: string;
    FCustomerUserName: string;
    FCustomerEmail: string;
    FRegFileName: string;
    FAppName: string;
    FAppFullPath: string;
    FRegCode,
    //Demo Version인 경우 FSerialCode가 아닌 FUsageCode(원본은 FRegCode에 보존)를 고객에게 Serial No 로써 제공함
    FSerialCode, //Encode된 Serial No
    //FUsageCode 원본(초기세팅값)은 FRegCode에 저장되고, DecUsageCount 함수에서 FUsageCode는 갱신됨
    FUsageCode: string;
    FSerialNo: Longint;
    FIsUseMachineId,
    FIsTrialVersion,
    FIsUseOgUtil4MachineId: Boolean;
    FMachineID : Int64;
    FRegDate : TDateTime;
    FExpireDate : TDateTime;
    FExpireUsage: integer;
    //Demo versioin을 판단하기 위함(ctDate, ctDays, ctUsage)
    FCodeTypes: TMyCodeTypes;

    FFileMajorVersion, FFileMinorVersion,
    FFileRevisionNo, FFileBuildNo,
    FProductMajorVersion, FProductMinorVersion,
    FProductRevisionNo, FProductBuildNo: Word;

    FRootKey: HKEY;
    FRegKey, FRegKeyName: string;

    //본 프로그램의 만능 암호: UserId는 체크하지 않고 암호만 체크함(한번 설정되면 불변임)
    FMasterPassword,
    //매번 자동 생성되는 암호임(AS 요원이 생성하여 USB 파일로 가져옴(FMasterPassword를 이용하면 임시암호가 생성 가능함)
    FTempMasterPassword: string;
    FIPAddress : string;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property ProductCode: string read fProductCode write fProductCode;
    property ProductName: string read fProductName write fProductName;
    property CustomerCompanyName: string read FCustomerCompanyName write FCustomerCompanyName;
    property CustomerUserName: string read FCustomerUserName write FCustomerUserName;
    property CustomerEmail: string read FCustomerEmail write FCustomerEmail;
    property RegFileName: string read FRegFileName write FRegFileName;
    property AppName: string read FAppName write FAppName;
    property AppFullPath: string read FAppFullPath write FAppFullPath;
    property RegCode: string read FRegCode write FRegCode;
    property SerialCode: string read FSerialCode write FSerialCode;
    property UsageCode: string read FUsageCode write FUsageCode;
    property SerialNo: Longint read FSerialNo write FSerialNo;
    property IsUseMachineId: Boolean  read FIsUseMachineId write FIsUseMachineId;
    property IsTrialVersion: Boolean read FIsTrialVersion write FIsTrialVersion;
    property IsUseOgUtil4MachineId: Boolean read FIsUseOgUtil4MachineId write FIsUseOgUtil4MachineId;
    property MachineID: Int64 read FMachineID write FMachineID;
    property ExpireDate: TDateTime read FExpireDate write FExpireDate;
    property RegDate: TDateTime read FRegDate write FRegDate;
    property ExpireUsage: integer read FExpireUsage write FExpireUsage;
    property CodeTypes: TMyCodeTypes read FCodeTypes write FCodeTypes;

    property FileMajorVersion: Word read FFileMajorVersion write FFileMajorVersion;
    property FileMinorVersion: Word read FFileMinorVersion write FFileMinorVersion;
    property FileRevisionNo: Word read FFileRevisionNo write FFileRevisionNo;
    property FileBuildNo: Word read FFileBuildNo write FFileBuildNo;
    property ProductMajorVersion: Word read FProductMajorVersion write FProductMajorVersion;
    property ProductMinorVersion: Word read FProductMinorVersion write FProductMinorVersion;
    property ProductRevisionNo: Word read FProductRevisionNo write FProductRevisionNo;
    property ProductBuildNo: Word  read FProductBuildNo write FProductBuildNo;

    property RootKey: HKEY  read FRootKey write FRootKey;
    property RegKey: string read FRegKey write FRegKey;
    property RegKeyName: string read FRegKeyName write FRegKeyName;

    property MasterPassword: string read FMasterPassword write FMasterPassword;
    property TempMasterPassword: string  read FTempMasterPassword write FTempMasterPassword;

    property IPAddress : string  read FIPAddress write FIPAddress;
  end;

function CreateRegCodeManageModel: TSQLModel;
function CreateProductManageModel: TSQLModel;

procedure InitClient();
procedure AssignSQLRegCodeManageFromJSON(var ARegCodeManage: TSQLRegCodeManage; AJson: RawUTF8);

function GetTSQLRegCodeManageFromTaskID(AID: TID): TSQLRegCodeManage;
function GetTSQLRegCodeManageFromIPAddr(AIpAddr: string): TSQLRegCodeManage;
function GetTSQLRegCodeManageFromEmail(AEmail: string): TSQLRegCodeManage;
function GetTSQLRegCodeManageFromSerialNo(ASerialNo: Longint): TSQLRegCodeManage;
function GetTSQLRegCodeManageFromProductCode(AProductCode: string): TSQLRegCodeManage;
function GetTSQLRegCodeManageFromProductCodeNSerialNo(AProductCode: string; ASerialNo: Longint): TSQLRegCodeManage;
function GetTSQLRegCodeManageFromProductCodeNIPAddr(AProductCode, AIpAddr: string): TSQLRegCodeManage;

function GetTSQLProductManageFromTaskID(AID: TID): TSQLProductManage;
function GetTSQLProductManageFromProductCode(AProductCode: string): TSQLProductManage;
function GetNextSerialNoFromSQLProductManage(AProductCode: string): integer;
procedure SetSQLProductManageLastSerialNo(AProductCode: string);

var
  RegCodeManageModel,
  ProductManageModel: TSQLModel;
  g_RegCodeManageDB,
  g_ProductManageDB: TSQLRestClientURI;

implementation

uses SysUtils, Forms, mORMotSQLite3, FrmRegistration,
  UnitHttpModule4RegServer, UnitRegistrationClass;

function CreateRegCodeManageModel: TSQLModel;
begin
  Result := TSQLModel.Create([TSQLRegCodeManage]);
end;

function CreateProductManageModel: TSQLModel;
begin
  Result := TSQLModel.Create([TSQLProductManage]);
end;

procedure InitClient();
var
  LStr: string;
begin
  LStr := ChangeFileExt(Application.ExeName,'.db3');
  RegCodeManageModel:= CreateRegCodeManageModel;
  g_RegCodeManageDB:= TSQLRestClientDB.Create(RegCodeManageModel, CreateRegCodeManageModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_RegCodeManageDB).Server.CreateMissingTables;

  LStr := LStr.Replace('.db3', '_Product.db3');
  ProductManageModel:= CreateProductManageModel;
  g_ProductManageDB:= TSQLRestClientDB.Create(ProductManageModel, CreateProductManageModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_ProductManageDB).Server.CreateMissingTables;
end;

procedure AssignSQLRegCodeManageFromJSON(var ARegCodeManage: TSQLRegCodeManage; AJson: RawUTF8);
var
  LDoc: variant;
  LDate: TDateTime;
  i: integer;
begin
  LDoc := _JSON(AJson);

  ARegCodeManage.ProductCode := LDoc.ProductCode;
  ARegCodeManage.ProductName := LDoc.ProductName;
  ARegCodeManage.CustomerCompanyName := LDoc.CustomerCompanyName;
  ARegCodeManage.CustomerUserName := LDoc.CustomerUserName;
  ARegCodeManage.CustomerEmail := LDoc.CustomerEmail;
  ARegCodeManage.RegFileName := LDoc.RegFileName;
  ARegCodeManage.AppName := LDoc.AppName;
  ARegCodeManage.AppFullPath := LDoc.AppFullPath;
  ARegCodeManage.RegCode := LDoc.RegCode;
  ARegCodeManage.SerialCode := LDoc.SerialCode;
  ARegCodeManage.UsageCode := LDoc.UsageCode;
  ARegCodeManage.SerialNo := LDoc.SerialNo;
  ARegCodeManage.IsUseMachineId := LDoc.IsUseMachineId;
  ARegCodeManage.IsTrialVersion := LDoc.IsTrialVersion;
  ARegCodeManage.IsUseOgUtil4MachineId := LDoc.IsUseOgUtil4MachineId;
  ARegCodeManage.MachineID := LDoc.MachineID;
  VariantToDateTime(LDoc.ExpireDate, LDate);
  ARegCodeManage.ExpireDate := LDate;
  VariantToDateTime(LDoc.RegDate, LDate);
  ARegCodeManage.RegDate := LDate;
  ARegCodeManage.ExpireUsage := LDoc.ExpireUsage;
  i := VariantToIntegerDef(LDoc.CodeTypes,0);
  ARegCodeManage.CodeTypes := IntToCodeTypes(i);

  ARegCodeManage.FileMajorVersion := LDoc.FileMajorVersion;
  ARegCodeManage.FileMinorVersion := LDoc.FileMinorVersion;
  ARegCodeManage.FileRevisionNo := LDoc.FileRevisionNo;
  ARegCodeManage.FileBuildNo := LDoc.FileBuildNo;
  ARegCodeManage.ProductMajorVersion := LDoc.ProductMajorVersion;
  ARegCodeManage.ProductMinorVersion := LDoc.ProductMinorVersion;
  ARegCodeManage.ProductRevisionNo := LDoc.ProductRevisionNo;
  ARegCodeManage.ProductBuildNo := LDoc.ProductBuildNo;

//  ARegCodeManage.RootKey := LDoc.RootKey;
//  ARegCodeManage.RegKey := LDoc.RegKey;
//  ARegCodeManage.RegKeyName := LDoc.RegKeyName;

  ARegCodeManage.MasterPassword := LDoc.MasterPassword;
  ARegCodeManage.TempMasterPassword := LDoc.TempMasterPassword;

  ARegCodeManage.IPAddress := LDoc.IPAddress;
end;

function GetTSQLRegCodeManageFromTaskID(AID: TID): TSQLRegCodeManage;
begin
  Result := TSQLRegCodeManage.CreateAndFillPrepare(g_RegCodeManageDB, 'ID = ?', [AID]);

  if Result.FillOne then
  begin
    Result.FIsUpdate := True;
  end;
end;

function GetTSQLRegCodeManageFromIPAddr(AIpAddr: string): TSQLRegCodeManage;
begin
  Result := TSQLRegCodeManage.CreateAndFillPrepare(g_RegCodeManageDB, 'IPAddress = ?', [AIpAddr]);

  if Result.FillOne then
  begin
//    if Result.IPAddress = AIpAddr then
//    begin
      Result.FIsUpdate := True;
//      exit;
//    end;
  end;
end;

function GetTSQLRegCodeManageFromEmail(AEmail: string): TSQLRegCodeManage;
begin
  Result := TSQLRegCodeManage.CreateAndFillPrepare(g_RegCodeManageDB, 'CustomerEmail = ?', [AEmail]);

  if Result.FillOne then
  begin
    Result.FIsUpdate := True;
  end;
end;

function GetTSQLRegCodeManageFromSerialNo(ASerialNo: Longint): TSQLRegCodeManage;
begin
  Result := TSQLRegCodeManage.CreateAndFillPrepare(g_RegCodeManageDB, 'SerialNo = ?', [ASerialNo]);

  if Result.FillOne then
  begin
    Result.FIsUpdate := True;
  end;
end;

function GetTSQLRegCodeManageFromProductCode(AProductCode: string): TSQLRegCodeManage;
begin
  Result := TSQLRegCodeManage.CreateAndFillPrepare(g_RegCodeManageDB, 'ProductCode = ?', [AProductCode]);

  if Result.FillOne then
  begin
    Result.IsUpdate := True;
  end;
end;

function GetTSQLRegCodeManageFromProductCodeNSerialNo(AProductCode: string; ASerialNo: Longint): TSQLRegCodeManage;
begin
  Result := TSQLRegCodeManage.CreateAndFillPrepare(g_RegCodeManageDB, 'ProductCode = ? and SerialNo = ?', [AProductCode, ASerialNo]);

  if Result.FillOne then
  begin
    Result.IsUpdate := True;
  end;
end;

function GetTSQLRegCodeManageFromProductCodeNIPAddr(AProductCode, AIpAddr: string): TSQLRegCodeManage;
begin
  Result := TSQLRegCodeManage.CreateAndFillPrepare(g_RegCodeManageDB, 'ProductCode = ? and IPAddress = ?', [AProductCode, AIpAddr]);

  if Result.FillOne then
  begin
    Result.IsUpdate := True;
  end;
end;

function GetTSQLProductManageFromTaskID(AID: TID): TSQLProductManage;
begin
  Result := TSQLProductManage.CreateAndFillPrepare(g_ProductManageDB, 'ID = ?', [AID]);

  if Result.FillOne then
  begin
    Result.FIsUpdate := True;
  end;
end;

function GetTSQLProductManageFromProductCode(AProductCode: string): TSQLProductManage;
begin
  Result := TSQLProductManage.CreateAndFillPrepare(g_ProductManageDB, 'ProductCode = ?', [AProductCode]);

  if Result.FillOne then
  begin
    Result.FIsUpdate := True;
  end;
end;

function GetNextSerialNoFromSQLProductManage(AProductCode: string): integer;
var
  LSQLProductManage: TSQLProductManage;
  LSeqialNo: Integer;
begin
  LSQLProductManage := TSQLProductManage.CreateAndFillPrepare(g_ProductManageDB, 'ProductCode = ?', [AProductCode]);
  Result := 0;
  try
    while LSQLProductManage.FillOne do
    begin
      LSeqialNo := LSQLProductManage.LastSerialNo;

      if LSeqialNo > Result then
      begin
        Result := LSeqialNo;
      end;
    end;
  finally
    FreeAndNil(LSQLProductManage);
  end;
end;

procedure SetSQLProductManageLastSerialNo(AProductCode: string);
var
  LSQLProductManage: TSQLProductManage;
  LSerialNo: Integer;
begin
  LSQLProductManage := TSQLProductManage.CreateAndFillPrepare(g_ProductManageDB, 'ProductCode = ?', [AProductCode]);
  try
    if LSQLProductManage.FillOne then
    begin
      LSerialNo := LSQLProductManage.LastSerialNo;
      Inc(LSerialNo);
      LSQLProductManage.LastSerialNo := LSerialNo;
      g_ProductManageDB.Update(LSQLProductManage);
    end;
  finally
    FreeAndNil(LSQLProductManage);
  end;
end;

initialization
  g_RegCodeManageDB := nil;
  g_ProductManageDB := nil;

finalization
  if Assigned(g_RegCodeManageDB) then
    FreeAndNil(g_RegCodeManageDB);

  if Assigned(g_ProductManageDB) then
    FreeAndNil(g_ProductManageDB);

end.

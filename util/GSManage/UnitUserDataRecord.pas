unit UnitUserDataRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  CommonData;

type
  TSQLUser = class(TSQLRecord)
  private
    fUserName,
    fSabun,
    fDepartmentName,
    fCompanyName,
    fTeamName,
    fMobileNo,
    fOfficePhoneNo
    : RawUTF8;

    FIsUpdate: Boolean;
  public
    //True : DB Update, False: DB Add
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property UserName: RawUTF8 read fUserName write fUserName;
    property Sabun: RawUTF8 read fSabun write fSabun;
    property CompanyName: RawUTF8 read fCompanyName write fCompanyName;
    property DepartmentName: RawUTF8 read fDepartmentName write fDepartmentName;
    property TeamName: RawUTF8 read fTeamName write fTeamName;
    property MobileNo: RawUTF8 read fMobileNo write fMobileNo;
    property OfficePhoneNo: RawUTF8 read fOfficePhoneNo write fOfficePhoneNo;
  end;

  TSQLUserDetail = class(TSQLUser)
  private
    fBusinessRegions: TBusinessRegions;
    fEmailAddress,
    fPCIPAddress
    : RawUTF8;
  published
    property BusinessRegions: TBusinessRegions read fBusinessRegions write fBusinessRegions;
    property PCIPAddress: RawUTF8 read fPCIPAddress write fPCIPAddress;
    property EmailAddress: RawUTF8 read fEmailAddress write fEmailAddress;
  end;

function CreateUserModel: TSQLModel;
procedure InitUserClient(AExeName: string);

function GetMyNameFromEmailAddress(AEmail: string): string;
function GetMyNameNIPAddressFromEmailAddress(AEmail: string): string;
function GetUserDetails: TSQLUserDetail;

var
  g_UserDB: TSQLRestClientURI;
  UserModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, UnitFolderUtil;

function CreateUserModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLUserDetail]);
end;

procedure InitUserClient(AExeName: string);
var
  LStr: string;
begin
//  LStr := 'GSUser.sqlite';
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + 'GSUser.sqlite';
  UserModel:= CreateUserModel;
  g_UserDB:= TSQLRestClientDB.Create(UserModel, CreateUserModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_UserDB).Server.CreateMissingTables;
end;

function GetMyNameFromEmailAddress(AEmail: string): string;
var
  LSQLUserDetail: TSQLUserDetail;
begin
  LSQLUserDetail := TSQLUserDetail.CreateAndFillPrepare(g_UserDB,
    'EmailAddress LIKE ?', ['%'+AEmail+'%']);
  try
    if LSQLUserDetail.FillOne then
      Result := LSQLUserDetail.UserName;
  finally
    LSQLUserDetail.Free;
  end;
end;

function GetMyNameNIPAddressFromEmailAddress(AEmail: string): string;
var
  LSQLUserDetail: TSQLUserDetail;
begin
  LSQLUserDetail := TSQLUserDetail.CreateAndFillPrepare(g_UserDB,
    'EmailAddress LIKE ?', ['%'+AEmail+'%']);
  try
    if LSQLUserDetail.FillOne then
      Result := LSQLUserDetail.UserName + '=' + LSQLUserDetail.PCIPAddress;
  finally
    LSQLUserDetail.Free;
  end;
end;

function GetUserDetails: TSQLUserDetail;
begin
  Result := TSQLUserDetail.CreateAndFillPrepare(g_UserDB,
    'ID <> ?', [-1]);
end;

initialization

finalization
  if Assigned(UserModel) then
    FreeAndNil(UserModel);

  if Assigned(g_UserDB) then
    FreeAndNil(g_UserDB);

end.

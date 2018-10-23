unit UnitHGSSerialRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot;

type
  TSQLHGSSerialRecord = class(TSQLRecord)
  private
    fIssuedYear,
    fProductType,
    fCategory,
    fLastSerialNo
    : integer;

    fUpdateDate: TTimeLog;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property IssuedYear: integer read fIssuedYear write fIssuedYear;
    property ProductType: integer read fProductType write fProductType;
    property Category: integer read fCategory write fCategory;
    property LastSerialNo: integer read fLastSerialNo write fLastSerialNo;
    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
  end;

procedure InitHGSSerialClient(AHGSCertSerialDBName: string = '');
function CreateHGSSerialModel: TSQLModel;
procedure DestroyHGSSerial;

function GetHGSSerialFromProductType(const AIssuedYear, AProductType: integer; ACategory : integer = 0): TSQLHGSSerialRecord;
function GetNextHGSSerialFromProductType(const AIssuedYear, AProductType: integer; ACategory : integer = 0): integer;
procedure AddOrUpdateHGSSerial(ASQLHGSSerialRecord: TSQLHGSSerialRecord);
procedure AddOrUpdateNextHGSSerial(const AIssuedYear, AProductType, ACategory : integer; ALastSerialNo: integer);

var
  g_HGSSerialDB: TSQLRestClientURI;
  HGSSerialModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil, UnitRttiUtil;

procedure InitHGSSerialClient(AHGSCertSerialDBName: string = '');
var
  LStr: string;
begin
  if AHGSCertSerialDBName = '' then
    AHGSCertSerialDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AHGSCertSerialDBName;
  HGSSerialModel:= CreateHGSSerialModel;
  g_HGSSerialDB:= TSQLRestClientDB.Create(HGSSerialModel, CreateHGSSerialModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_HGSSerialDB).Server.CreateMissingTables;
end;

function CreateHGSSerialModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHGSSerialRecord]);
end;

procedure DestroyHGSSerial;
begin
  if Assigned(HGSSerialModel) then
    FreeAndNil(HGSSerialModel);

  if Assigned(g_HGSSerialDB) then
    FreeAndNil(g_HGSSerialDB);
end;

function GetHGSSerialFromProductType(const AIssuedYear, AProductType: integer;
  ACategory : integer = 0): TSQLHGSSerialRecord;
var
  LSQL: string;
  LIsCategory: Boolean;
begin
  if (AProductType = 0) or (AIssuedYear = 0) then
  begin
    Result := TSQLHGSSerialRecord.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    LIsCategory := False;
    LSQL := 'IssuedYear = ? and ProductType = ?';

    if ACategory <> 0 then
    begin
      LSQL := LSQL + ' and Category = ?';
      LIsCategory := True;
    end;

    if LIsCategory then
      Result := TSQLHGSSerialRecord.CreateAndFillPrepare(g_HGSSerialDB,
        LSQL, [AIssuedYear, AProductType, ACategory])
    else
      Result := TSQLHGSSerialRecord.CreateAndFillPrepare(g_HGSSerialDB,
        LSQL, [AIssuedYear, AProductType]);

    if Result.FillOne then
      Result.IsUpdate := True
    else
      Result.IsUpdate := False;
  end;
end;

function GetNextHGSSerialFromProductType(const AIssuedYear, AProductType: integer; ACategory : integer = 0): integer;
var
  LSQLHGSSerialRecord: TSQLHGSSerialRecord;
begin
  LSQLHGSSerialRecord := GetHGSSerialFromProductType(AIssuedYear, AProductType, ACategory);
  try
    Result := LSQLHGSSerialRecord.LastSerialNo;
    Inc(Result);
  finally
    LSQLHGSSerialRecord.Free;
  end;
end;

procedure AddOrUpdateHGSSerial(ASQLHGSSerialRecord: TSQLHGSSerialRecord);
begin
  if ASQLHGSSerialRecord.IsUpdate then
  begin
    g_HGSSerialDB.Update(ASQLHGSSerialRecord);
  end
  else
  begin
    g_HGSSerialDB.Add(ASQLHGSSerialRecord, true);
  end;
end;

procedure AddOrUpdateNextHGSSerial(const AIssuedYear, AProductType, ACategory : integer;
  ALastSerialNo: integer);
var
  LSQLHGSSerialRecord: TSQLHGSSerialRecord;
begin
  LSQLHGSSerialRecord := GetHGSSerialFromProductType(AIssuedYear, AProductType, ACategory);
  try
    if not LSQLHGSSerialRecord.IsUpdate then
    begin
      LSQLHGSSerialRecord.IssuedYear := AIssuedYear;
      LSQLHGSSerialRecord.ProductType := AProductType;
      LSQLHGSSerialRecord.Category := ACategory;
    end;

    LSQLHGSSerialRecord.LastSerialNo := ALastSerialNo;
    AddOrUpdateHGSSerial(LSQLHGSSerialRecord);
  finally
    LSQLHGSSerialRecord.Free;
  end;
end;

initialization

finalization
  DestroyHGSSerial;

end.

unit UnitAnsiDeviceRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  CommonData,
  UnitVesselMasterRecord, UnitGSFileRecord;

type
  TAnsiDeviceNoSearchRec = record
    fAnsiDeviceNo,
    fDeviceName_Eng,
    fDeviceName_Kor,
    fDeviceDesc_Eng,
    fDeviceDesc_Kor
    : RawUtf8;
  end;

  TSQLAnsiDeviceRecord = class(TSQLRecord)
  private
    fAnsiDeviceNo,
    fAnsiDeviceName_Eng,
    fAnsiDeviceName_Kor,
    fAnsiDeviceDesc_Eng,
    fAnsiDeviceDesc_Kor
    : RawUTF8;

    fUpdateDate: TTimeLog;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property AnsiDeviceNo: RawUTF8 read fAnsiDeviceNo write fAnsiDeviceNo;
    property AnsiDeviceName_Eng: RawUTF8 read fAnsiDeviceName_Eng write fAnsiDeviceName_Eng;
    property AnsiDeviceName_Kor: RawUTF8 read fAnsiDeviceName_Kor write fAnsiDeviceName_Kor;
    property AnsiDeviceDesc_Eng: RawUTF8 read fAnsiDeviceDesc_Eng write fAnsiDeviceDesc_Eng;
    property AnsiDeviceDesc_Kor: RawUTF8 read fAnsiDeviceDesc_Kor write fAnsiDeviceDesc_Kor;

    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
  end;

function CreateAnsiDeviceModel: TSQLModel;
procedure InitAnsiDeviceClient(AExeName: string);

function GetAnsiDeviceFromDeviceNo(const ADeviceNo: string): TSQLAnsiDeviceRecord;
function GetAnsiDeviceFromSearchRec(AAnsiDeviceNoSearchRec: TAnsiDeviceNoSearchRec): TSQLAnsiDeviceRecord;

procedure AddOrUpdateAnsiDevice(AAnsiDevice:TSQLAnsiDeviceRecord);
procedure AddAnsiDeviceFromVariant(ADoc: variant);
procedure LoadAnsiDeviceFromVariant(AAnsiDevice:TSQLAnsiDeviceRecord; ADoc: variant);
function GetVariantFromAnsiDeviceRecord(AAnsiDevice:TSQLAnsiDeviceRecord): variant;

procedure AddOrUpdateAnsiDeviceFromVariant(ADoc: variant);

var
  g_AnsiDeviceDB: TSQLRestClientURI;
  AnsiDeviceModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, VarRecUtils, Vcl.Dialogs, Forms, UnitFolderUtil;

function CreateAnsiDeviceModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLAnsiDeviceRecord]);
end;

procedure InitAnsiDeviceClient(AExeName: string);
var
  LStr: string;
begin
  LStr := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + 'AnsiDeviceData.sqlite';
  AnsiDeviceModel:= CreateAnsiDeviceModel;
  g_AnsiDeviceDB:= TSQLRestClientDB.Create(AnsiDeviceModel, CreateAnsiDeviceModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_AnsiDeviceDB).Server.CreateMissingTables;
end;

function GetAnsiDeviceFromDeviceNo(const ADeviceNo: string): TSQLAnsiDeviceRecord;
begin
  Result := TSQLAnsiDeviceRecord.CreateAndFillPrepare(g_AnsiDeviceDB,
    'AnsiDeviceNo LIKE ?', ['%'+ADeviceNo+'%']);
end;

function GetAnsiDeviceFromSearchRec(AAnsiDeviceNoSearchRec: TAnsiDeviceNoSearchRec): TSQLAnsiDeviceRecord;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if AAnsiDeviceNoSearchRec.fAnsiDeviceNo <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AAnsiDeviceNoSearchRec.fAnsiDeviceNo+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'AnsiDeviceNo LIKE ? ';
    end;

    if AAnsiDeviceNoSearchRec.fDeviceName_Eng <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AAnsiDeviceNoSearchRec.fDeviceName_Eng+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'AnsiDeviceName_Eng LIKE ? ';
    end;

    if AAnsiDeviceNoSearchRec.fDeviceName_Kor <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AAnsiDeviceNoSearchRec.fDeviceName_Kor+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'AnsiDeviceName_Kor LIKE ? ';
    end;

    if AAnsiDeviceNoSearchRec.fDeviceDesc_Eng <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AAnsiDeviceNoSearchRec.fDeviceDesc_Eng+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'AnsiDeviceDesc_Eng LIKE ? ';
    end;

    if AAnsiDeviceNoSearchRec.fDeviceDesc_Kor <> '' then
    begin
      AddConstArray(ConstArray, ['%'+AAnsiDeviceNoSearchRec.fDeviceDesc_Kor+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'AnsiDeviceDesc_Kor LIKE ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    Result := TSQLAnsiDeviceRecord.CreateAndFillPrepare(g_AnsiDeviceDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end
    else
    begin
      Result := TSQLAnsiDeviceRecord.Create;
      Result.IsUpdate := False;
    end
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

procedure AddOrUpdateAnsiDevice(AAnsiDevice:TSQLAnsiDeviceRecord);
begin
  if AAnsiDevice.IsUpdate then
  begin
    g_AnsiDeviceDB.Update(AAnsiDevice);
  end
  else
  begin
    g_AnsiDeviceDB.Add(AAnsiDevice, true);
  end;

end;

procedure AddAnsiDeviceFromVariant(ADoc: variant);
var
  LSQLAnsiDeviceRecord: TSQLAnsiDeviceRecord;
begin
  LSQLAnsiDeviceRecord := TSQLAnsiDeviceRecord.Create;
  LSQLAnsiDeviceRecord.IsUpdate := False;

  try
    LoadAnsiDeviceFromVariant(LSQLAnsiDeviceRecord, ADoc);
    AddOrUpdateAnsiDevice(LSQLAnsiDeviceRecord);
  finally
    FreeAndNil(LSQLAnsiDeviceRecord);
  end;
end;

procedure LoadAnsiDeviceFromVariant(AAnsiDevice:TSQLAnsiDeviceRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  AAnsiDevice.AnsiDeviceNo := ADoc.AnsiDeviceNo;
  AAnsiDevice.AnsiDeviceName_Eng := ADoc.AnsiDeviceName_Eng;
  AAnsiDevice.AnsiDeviceName_Kor := ADoc.AnsiDeviceName_Kor;
  AAnsiDevice.AnsiDeviceDesc_Eng := ADoc.AnsiDeviceDesc_Eng;
  AAnsiDevice.AnsiDeviceDesc_Kor := ADoc.AnsiDeviceDesc_Kor;

  AAnsiDevice.UpdateDate := TimeLogFromDateTime(StrToDate(ADoc.UpdateDate));
end;

function GetVariantFromAnsiDeviceRecord(AAnsiDevice:TSQLAnsiDeviceRecord): variant;
begin
  TDocVariant.New(Result);

  Result.AnsiDeviceNo := AAnsiDevice.AnsiDeviceNo;
  Result.AnsiDeviceName_Eng := AAnsiDevice.AnsiDeviceName_Eng;
  Result.AnsiDeviceName_Kor := AAnsiDevice.AnsiDeviceName_Kor;
  Result.AnsiDeviceDesc_Eng := AAnsiDevice.AnsiDeviceDesc_Eng;
  Result.AnsiDeviceDesc_Kor := AAnsiDevice.AnsiDeviceDesc_Kor;
end;

procedure AddOrUpdateAnsiDeviceFromVariant(ADoc: variant);
var
  LSQLAnsiDeviceRecord: TSQLAnsiDeviceRecord;
begin
  LSQLAnsiDeviceRecord := GetAnsiDeviceFromDeviceNo(ADoc.AnsiDeviceNo);
  try
    LSQLAnsiDeviceRecord.IsUpdate := LSQLAnsiDeviceRecord.FillOne;
    LoadAnsiDeviceFromVariant(LSQLAnsiDeviceRecord, ADoc);
    AddOrUpdateAnsiDevice(LSQLAnsiDeviceRecord);
  finally
    FreeAndNil(LSQLAnsiDeviceRecord);
  end;
end;

initialization

finalization
  if Assigned(AnsiDeviceModel) then
    FreeAndNil(AnsiDeviceModel);

  if Assigned(g_AnsiDeviceDB) then
    FreeAndNil(g_AnsiDeviceDB);

end.

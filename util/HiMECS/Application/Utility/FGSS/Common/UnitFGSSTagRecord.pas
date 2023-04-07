unit UnitFGSSTagRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot;

type
  TSQLFGSSTagRecord = class(TSQLRecord)
  private
    fTaskID: TID;
    fRevNo,
    fRevNote,
    fRevRemark,
    fArea,
    fSupplierTag,
    fSupplierDesc,
    fIAS_SystemNo,
    fIAS_EquipCode,
    fIAS_EquipNo,
    fIAS_FuncCode,
    fIAS_IOTag,
    fIAS_EquipDesc,
    fIAS_SignalDesc,
    fIAS_Length,
    fIAS_IOType,//DataType
    fIAS_SignalType,
    fIAS_Power,
    fIAS_IS,
    fIAS_ExtIsolator,
    fCabinetName,
    fControlRoomName,
    fEng_Low_Range,
    fEng_High_Range,
    fEng_Unit,
    fAlarm_LL,
    fAlarm_L,
    fAlarm_HH,
    fAlarm_H,
    fAlarm_Delay,
    fAlarm_BLK_Grp,
    fAlarm_AC_Grp
    : RawUTF8;

    fIAS_NumOfWire: integer;
    fUsed: Boolean;
    fUpdateDate: TTimeLog;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property RevNo: RawUTF8 read fRevNo write fRevNo;




































procedure InitFGSSTagClient(AFGSSTagDBName: string = '');
function CreateFGSSTagModel: TSQLModel;

function GetFGSSTagFromIOTag(const AIOTag: string): TSQLFGSSTagRecord;

procedure AddOrUpdateFGSSTag(ASQLFGSSTagRecord: TSQLFGSSTagRecord);
function AddOrUpdateFGSSTagFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False): integer;
procedure LoadFGSSTagFromVariant(ASQLFGSSTagRecord: TSQLFGSSTagRecord; ADoc: variant);

var
  g_FGSSTagDB: TSQLRestClientURI;
  FGSSTagModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil, UnitRttiUtil;

procedure InitFGSSTagClient(AFGSSTagDBName: string = '');
var
  LStr: string;
begin
  if AFGSSTagDBName = '' then
    AFGSSTagDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AFGSSTagDBName;
  FGSSTagModel:= CreateFGSSTagModel;
  g_FGSSTagDB:= TSQLRestClientDB.Create(FGSSTagModel, CreateFGSSTagModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FGSSTagDB).Server.CreateMissingTables;
end;

function CreateFGSSTagModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLFGSSTagRecord]);
end;

function GetFGSSTagFromIOTag(const AIOTag: string): TSQLFGSSTagRecord;
begin
  Result := TSQLFGSSTagRecord.CreateAndFillPrepare(g_FGSSTagDB,
    'IAS_IOTag LIKE ?', ['%'+AIOTag+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure LoadFGSSTagFromVariant(ASQLFGSSTagRecord: TSQLFGSSTagRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  LoadRecordPropertyFromVariant(ASQLFGSSTagRecord, ADoc);
end;

procedure AddOrUpdateFGSSTag(ASQLFGSSTagRecord: TSQLFGSSTagRecord);
begin
  if ASQLFGSSTagRecord.IsUpdate then
  begin
    g_FGSSTagDB.Update(ASQLFGSSTagRecord);
  end
  else
  begin
    g_FGSSTagDB.Add(ASQLFGSSTagRecord, true);
  end;
end;

function AddOrUpdateFGSSTagFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False): integer;
var
  LSQLFGSSTagRecord: TSQLFGSSTagRecord;
  LIsUpdate: Boolean;
begin
  LSQLFGSSTagRecord := GetFGSSTagFromIOTag(ADoc.IAS_IOTag);
  LIsUpdate := LSQLFGSSTagRecord.IsUpdate;
  try
    if AIsOnlyAdd then
    begin
      if not LSQLFGSSTagRecord.IsUpdate then
      begin
        LoadFGSSTagFromVariant(LSQLFGSSTagRecord, ADoc);
        LSQLFGSSTagRecord.IsUpdate := LIsUpdate;

        AddOrUpdateFGSSTag(LSQLFGSSTagRecord);
        Inc(Result);
      end;
    end
    else
    begin
      if LSQLFGSSTagRecord.IsUpdate then
        Inc(Result);

      LoadFGSSTagFromVariant(LSQLFGSSTagRecord, ADoc);
      LSQLFGSSTagRecord.IsUpdate := LIsUpdate;

      AddOrUpdateFGSSTag(LSQLFGSSTagRecord);
    end;
  finally
    FreeAndNil(LSQLFGSSTagRecord);
  end;
end;

initialization

finalization
  if Assigned(FGSSTagModel) then
    FreeAndNil(FGSSTagModel);

  if Assigned(g_FGSSTagDB) then
    FreeAndNil(g_FGSSTagDB);
end.
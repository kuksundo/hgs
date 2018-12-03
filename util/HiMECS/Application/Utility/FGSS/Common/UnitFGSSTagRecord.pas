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
    property RevNote: RawUTF8 read fRevNote write fRevNote;
    property RevRemark: RawUTF8 read fRevRemark write fRevRemark;
    property Area: RawUTF8 read fArea write fArea;
    property SupplierTag: RawUTF8 read fSupplierTag write fSupplierTag;
    property SupplierDesc: RawUTF8 read fSupplierDesc write fSupplierDesc;
    property IAS_SystemNo: RawUTF8 read fIAS_SystemNo write fIAS_SystemNo;
    property IAS_EquipCode: RawUTF8 read fIAS_EquipCode write fIAS_EquipCode;
    property IAS_EquipNo: RawUTF8 read fIAS_EquipNo write fIAS_EquipNo;
    property IAS_FuncCode: RawUTF8 read fIAS_FuncCode write fIAS_FuncCode;
    property IAS_IOTag: RawUTF8 read fIAS_IOTag write fIAS_IOTag;
    property IAS_EquipDesc: RawUTF8 read fIAS_EquipDesc write fIAS_EquipDesc;
    property IAS_SignalDesc: RawUTF8 read fIAS_SignalDesc write fIAS_SignalDesc;
    property IAS_Length: RawUTF8 read fIAS_Length write fIAS_Length;
    property IAS_IOType: RawUTF8 read fIAS_IOType write fIAS_IOType;
    property IAS_SignalType: RawUTF8 read fIAS_SignalType write fIAS_SignalType;
    property IAS_Power: RawUTF8 read fIAS_Power write fIAS_Power;
    property IAS_IS: RawUTF8 read fIAS_IS write fIAS_IS;
    property IAS_ExtIsolator: RawUTF8 read fIAS_ExtIsolator write fIAS_ExtIsolator;
    property CabinetName: RawUTF8 read fCabinetName write fCabinetName;
    property ControlRoomName: RawUTF8 read fControlRoomName write fControlRoomName;
    property Eng_Low_Range: RawUTF8 read fEng_Low_Range write fEng_Low_Range;
    property Eng_High_Range: RawUTF8 read fEng_High_Range write fEng_High_Range;
    property Eng_Unit: RawUTF8 read fEng_Unit write fEng_Unit;
    property Alarm_LL: RawUTF8 read fAlarm_LL write fAlarm_LL;
    property Alarm_L: RawUTF8 read fAlarm_L write fAlarm_L;
    property Alarm_HH: RawUTF8 read fAlarm_HH write fAlarm_HH;
    property Alarm_H: RawUTF8 read fAlarm_H write fAlarm_H;
    property Alarm_Delay: RawUTF8 read fAlarm_Delay write fAlarm_Delay;
    property Alarm_BLK_Grp: RawUTF8 read fAlarm_BLK_Grp write fAlarm_BLK_Grp;
    property Alarm_AC_Grp: RawUTF8 read fAlarm_AC_Grp write fAlarm_AC_Grp;

    property IAS_NumOfWire: integer read fIAS_NumOfWire write fIAS_NumOfWire;
    property Used: Boolean read fUsed write fUsed;
    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
  end;

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

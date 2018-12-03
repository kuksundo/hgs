unit UnitFGSSKMTagRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot;

type
  TSQLFGSSKMBase = class(TSQLRecord)
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  end;

  TSQLFGSSKMTag1Record = class(TSQLFGSSKMBase)
  private
    fSystemNo,
    fSystemDesc,
    fCommandGroup
    : RawUTF8;
  published
    property SystemNo: RawUTF8 read fSystemNo write fSystemNo;
    property SystemDesc: RawUTF8 read fSystemDesc write fSystemDesc;
    property CommandGroup: RawUTF8 read fCommandGroup write fCommandGroup;
  end;

  TSQLFGSSKMTag2Record = class(TSQLFGSSKMBase)
  private
    fEquipCode,
    fEquipDesc,
    fModuleType
    : RawUTF8;
    fIsSecondLetter,
    fIsGroupTag: Boolean;
  published
    property EquipCode: RawUTF8 read fEquipCode write fEquipCode;
    property EquipDesc: RawUTF8 read fEquipDesc write fEquipDesc;
    property ModuleType: RawUTF8 read fModuleType write fModuleType;

    property IsSecondLetter: Boolean read fIsSecondLetter write fIsSecondLetter;
    property IsGroupTag: Boolean read fIsGroupTag write fIsGroupTag;
  end;

  TSQLFGSSKMTag4Record = class(TSQLFGSSKMBase)
  private
    fFuncCode,
    fFuncDesc,
    fTerminalNo
    : RawUTF8;
  published
    property FuncCode: RawUTF8 read fFuncCode write fFuncCode;
    property FuncDesc: RawUTF8 read fFuncDesc write fFuncDesc;
    property TerminalNo: RawUTF8 read fTerminalNo write fTerminalNo;
  end;

  TSQLFGSSKMBlockGrpRecord = class(TSQLFGSSKMBase)
  private
    fGroupCode,
    fGroupDesc
    : RawUTF8;
  published
    property GroupCode: RawUTF8 read fGroupCode write fGroupCode;
    property GroupDesc: RawUTF8 read fGroupDesc write fGroupDesc;
  end;

  TSQLFGSSKMTerminalInfoRecord = class(TSQLFGSSKMBase)
  private
    fIAS_IOTag,
    fHWLoopType,
    fPosNo,
    fIOChannel,
    fTerminalBlock,
    fTB_A,
    fTB_B,
    fTB_C,
    fTB_D,
    fNote
    : RawUTF8;
  published
    property IAS_IOTag: RawUTF8 read fIAS_IOTag write fIAS_IOTag;
    property HWLoopType: RawUTF8 read fHWLoopType write fHWLoopType;
    property PosNo: RawUTF8 read fPosNo write fPosNo;
    property IOChannel: RawUTF8 read fIOChannel write fIOChannel;
    property TerminalBlock: RawUTF8 read fTerminalBlock write fTerminalBlock;
    property TB_A: RawUTF8 read fTB_A write fTB_A;
    property TB_B: RawUTF8 read fTB_B write fTB_B;
    property TB_C: RawUTF8 read fTB_C write fTB_C;
    property TB_D: RawUTF8 read fTB_D write fTB_D;
    property Note: RawUTF8 read fNote write fNote;
  end;

procedure InitFGSSKMTag1Record(AFGSSKMTag1DBName: string = '');
function CreateFGSSKMTag1Model: TSQLModel;
procedure InitFGSSKMTag2Record(AFGSSKMTag2DBName: string = '');
function CreateFGSSKMTag2Model: TSQLModel;
procedure InitFGSSKMTag4Record(AFGSSKMTag4DBName: string = '');
function CreateFGSSKMTag4Model: TSQLModel;
procedure InitFGSSKMBlockGrpRecord(AFGSSKMBlockGrpDBName: string = '');
function CreateFGSSKMBlockGrpModel: TSQLModel;

procedure InitFGSSKMTerminalInfo(AFGSSTagDBName: string = '');
function CreateFGSSKMTerminalInfoModel: TSQLModel;
function GetFGSSKMTerminalInfoFromIOTag(const AIOTag: string): TSQLFGSSKMTerminalInfoRecord;
procedure AddOrUpdateFGSSKMTerminalInfo(ASQLFGSSKMTerminalInfoRecord: TSQLFGSSKMTerminalInfoRecord);
function AddOrUpdateFGSSKMTerminalInfoFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False): integer;
procedure LoadFGSSKMTerminalInfoFromVariant(ASQLFGSSKMTerminalInfoRecord: TSQLFGSSKMTerminalInfoRecord; ADoc: variant);

var
  g_FGSSKMTag1DB: TSQLRestClientURI;
  FGSSKMTag1Model: TSQLModel;
  g_FGSSKMTag2DB: TSQLRestClientURI;
  FGSSKMTag2Model: TSQLModel;
  g_FGSSKMTag4DB: TSQLRestClientURI;
  FGSSKMTag4Model: TSQLModel;
  g_FGSSKMBlockGrpDB: TSQLRestClientURI;
  FGSSKMBlockGrpModel: TSQLModel;

  g_FGSSKMTerminalInfoDB: TSQLRestClientURI;
  FGSSKMTerminalInfoModel: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil, UnitRttiUtil, Forms;

procedure InitFGSSKMTag1Record(AFGSSKMTag1DBName: string = '');
var
  LStr: string;
begin
  if AFGSSKMTag1DBName = '' then
    AFGSSKMTag1DBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AFGSSKMTag1DBName;
  FGSSKMTag1Model:= CreateFGSSKMTag1Model;
  g_FGSSKMTag1DB:= TSQLRestClientDB.Create(FGSSKMTag1Model, CreateFGSSKMTag1Model,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FGSSKMTag1DB).Server.CreateMissingTables;
end;

function CreateFGSSKMTag1Model: TSQLModel;
begin
  result := TSQLModel.Create([TSQLFGSSKMTag1Record]);
end;

procedure InitFGSSKMTag2Record(AFGSSKMTag2DBName: string = '');
var
  LStr: string;
begin
  if AFGSSKMTag2DBName = '' then
    AFGSSKMTag2DBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AFGSSKMTag2DBName;
  FGSSKMTag2Model:= CreateFGSSKMTag2Model;
  g_FGSSKMTag2DB:= TSQLRestClientDB.Create(FGSSKMTag2Model, CreateFGSSKMTag2Model,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FGSSKMTag2DB).Server.CreateMissingTables;
end;

function CreateFGSSKMTag2Model: TSQLModel;
begin
  result := TSQLModel.Create([TSQLFGSSKMTag2Record]);
end;

procedure InitFGSSKMTag4Record(AFGSSKMTag4DBName: string = '');
var
  LStr: string;
begin
  if AFGSSKMTag4DBName = '' then
    AFGSSKMTag4DBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AFGSSKMTag4DBName;
  FGSSKMTag4Model:= CreateFGSSKMTag4Model;
  g_FGSSKMTag4DB:= TSQLRestClientDB.Create(FGSSKMTag4Model, CreateFGSSKMTag4Model,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FGSSKMTag4DB).Server.CreateMissingTables;
end;

function CreateFGSSKMTag4Model: TSQLModel;
begin
  result := TSQLModel.Create([TSQLFGSSKMTag4Record]);
end;

procedure InitFGSSKMBlockGrpRecord(AFGSSKMBlockGrpDBName: string = '');
var
  LStr: string;
begin
  if AFGSSKMBlockGrpDBName = '' then
    AFGSSKMBlockGrpDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AFGSSKMBlockGrpDBName;
  FGSSKMBlockGrpModel:= CreateFGSSKMBlockGrpModel;
  g_FGSSKMBlockGrpDB:= TSQLRestClientDB.Create(FGSSKMBlockGrpModel, CreateFGSSKMBlockGrpModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FGSSKMBlockGrpDB).Server.CreateMissingTables;
end;

function CreateFGSSKMBlockGrpModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLFGSSKMBlockGrpRecord]);
end;

procedure InitFGSSKMTerminalInfo(AFGSSTagDBName: string);
var
  LStr: string;
begin
  if AFGSSTagDBName = '' then
    AFGSSTagDBName := ChangeFileExt(ExtractFilePath(Application.ExeName),'.sqlite');

  LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LStr := LStr + AFGSSTagDBName;
  FGSSKMTerminalInfoModel:= CreateFGSSKMTerminalInfoModel;
  g_FGSSKMTerminalInfoDB:= TSQLRestClientDB.Create(FGSSKMTerminalInfoModel, CreateFGSSKMTerminalInfoModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FGSSKMTerminalInfoDB).Server.CreateMissingTables;
end;

function CreateFGSSKMTerminalInfoModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLFGSSKMTerminalInfoRecord]);
end;

function GetFGSSKMTerminalInfoFromIOTag(const AIOTag: string): TSQLFGSSKMTerminalInfoRecord;
begin
  Result := TSQLFGSSKMTerminalInfoRecord.CreateAndFillPrepare(g_FGSSKMTerminalInfoDB,
    'IAS_IOTag LIKE ?', ['%'+AIOTag+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure AddOrUpdateFGSSKMTerminalInfo(ASQLFGSSKMTerminalInfoRecord: TSQLFGSSKMTerminalInfoRecord);
begin
  if ASQLFGSSKMTerminalInfoRecord.IsUpdate then
  begin
    g_FGSSKMTerminalInfoDB.Update(ASQLFGSSKMTerminalInfoRecord);
  end
  else
  begin
    g_FGSSKMTerminalInfoDB.Add(ASQLFGSSKMTerminalInfoRecord, true);
  end;
end;

function AddOrUpdateFGSSKMTerminalInfoFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False): integer;
var
  LSQLFGSSKMTerminalInfoRecord: TSQLFGSSKMTerminalInfoRecord;
  LIsUpdate: Boolean;
begin
  LSQLFGSSKMTerminalInfoRecord := GetFGSSKMTerminalInfoFromIOTag(ADoc.IAS_IOTag);
  LIsUpdate := LSQLFGSSKMTerminalInfoRecord.IsUpdate;
  try
    if AIsOnlyAdd then
    begin
      if not LSQLFGSSKMTerminalInfoRecord.IsUpdate then
      begin
        LoadFGSSKMTerminalInfoFromVariant(LSQLFGSSKMTerminalInfoRecord, ADoc);
        LSQLFGSSKMTerminalInfoRecord.IsUpdate := LIsUpdate;
        AddOrUpdateFGSSKMTerminalInfo(LSQLFGSSKMTerminalInfoRecord);
        Inc(Result);
      end;
    end
    else
    begin
      if LSQLFGSSKMTerminalInfoRecord.IsUpdate then
        Inc(Result);

      LoadFGSSKMTerminalInfoFromVariant(LSQLFGSSKMTerminalInfoRecord, ADoc);
      LSQLFGSSKMTerminalInfoRecord.IsUpdate := LIsUpdate;
      AddOrUpdateFGSSKMTerminalInfo(LSQLFGSSKMTerminalInfoRecord);
    end;
  finally
    FreeAndNil(LSQLFGSSKMTerminalInfoRecord);
  end;
end;

procedure LoadFGSSKMTerminalInfoFromVariant(ASQLFGSSKMTerminalInfoRecord: TSQLFGSSKMTerminalInfoRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  LoadRecordPropertyFromVariant(ASQLFGSSKMTerminalInfoRecord, ADoc);
end;

initialization

finalization
  if Assigned(FGSSKMTag1Model) then
    FreeAndNil(FGSSKMTag1Model);

  if Assigned(g_FGSSKMTag1DB) then
    FreeAndNil(g_FGSSKMTag1DB);

  if Assigned(FGSSKMTag2Model) then
    FreeAndNil(FGSSKMTag2Model);

  if Assigned(g_FGSSKMTag2DB) then
    FreeAndNil(g_FGSSKMTag2DB);

  if Assigned(FGSSKMTag4Model) then
    FreeAndNil(FGSSKMTag4Model);

  if Assigned(g_FGSSKMTag4DB) then
    FreeAndNil(g_FGSSKMTag4DB);

  if Assigned(FGSSKMBlockGrpModel) then
    FreeAndNil(FGSSKMBlockGrpModel);

  if Assigned(g_FGSSKMBlockGrpDB) then
    FreeAndNil(g_FGSSKMBlockGrpDB);

  if Assigned(FGSSKMTerminalInfoModel) then
    FreeAndNil(FGSSKMTerminalInfoModel);

  if Assigned(g_FGSSKMTerminalInfoDB) then
    FreeAndNil(g_FGSSKMTerminalInfoDB);

end.

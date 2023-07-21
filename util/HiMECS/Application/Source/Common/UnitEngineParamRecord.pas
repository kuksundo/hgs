unit UnitEngineParamRecord;

interface

uses Classes, Messages, SynCommons, mORMot,
  HiMECSConst, UnitEngineParamConst, UnitEngineMasterData, UnitMultiStateRecord;

const
  MSG_WORKER_RESULT = WM_USER;
  MSG_COMPARE_PARAM_RESULT = WM_USER+100;

type
  TE2S_PLCInfo = packed record
    Atype: string; //@type의 @를 A로 대체 해야 함
    version: string; //@version의 @를 ''로 대체 해야 함
    dataModelUuid: string;
    firmwareVersion: string;
    plcName: string;
    plcVersion: string;
    plcVersionRemoteUnit: string;
    plcVersionSafetyUnit: string;
    cfSerial: string;
    knockonVesion1: string;
    knockonVesion2: string;
    preconVesion1: string;
    preconVesion2: string;
    cpuSerial: string;
    safetySerial: string;
    remoteSerial: string;
    visualizationModelUuid: string;
    packageName: string;
    packageRemote: string;
    packageSafety: string;
    instanceId: string;
  end;

  TE2S_UITextPool = packed record
    Atype: string; //@type의 @를 A로 대체 해야 함
    version: string; //@version의 @를 ''로 대체 해야 함
    entries_textKey: string;
    entries_defaultText: string;
    entries_locales: string;
    entries_texts: string;
  end;

  TEngineParamRecord = class(TSQLRecord)
{$I EngineParameter.inc}
  end;

  TPLCInfoRec4Avat2 = class(TSQLRecord)
  private
    FE2S_PLCInfo: TE2S_PLCInfo;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property E2S_PLCInfo: TE2S_PLCInfo read FE2S_PLCInfo write FE2S_PLCInfo;
  end;

  TDiscreteValue4Avat2 = class(TSQLRecord)
  private
    FDescriptor: string;
    FDisplayName: string;
    FPossibleValue: integer;
    FKey: integer;
    FDiscreteValue: string;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property Descriptor: string read FDescriptor write FDescriptor;
    property Key: integer read FKey write FKey;
    property DisplayName: string read FDisplayName write FDisplayName;
    property PossibleValue: integer read FPossibleValue write FPossibleValue;
    property DiscreteValue: string read FDiscreteValue write FDiscreteValue;
  end;

  TUITextPoolRec4Avat2 = class(TSQLRecord)
  private
//    FE2S_UITextPool: TE2S_UITextPool;
    FAtype: string; //@type의 @를 A로 대체 해야 함
    Fversion: string; //@version의 @를 ''로 대체 해야 함
    Fentries_textKey: string;
    Fentries_defaultText: string;
    Fentries_locales: string;
    Fentries_texts: string;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
//    property E2S_UITextPool: TE2S_UITextPool read FE2S_UITextPool write FE2S_UITextPool;
    property Atype: string read FAtype write FAtype;
    property version: string read Fversion write Fversion;
    property entries_textKey: string read Fentries_textKey write Fentries_textKey;
    property entries_defaultText: string read Fentries_defaultText write Fentries_defaultText;
    property entries_locales: string read Fentries_locales write Fentries_locales;
    property entries_texts: string read Fentries_texts write Fentries_texts;
  end;

  //Parameter No 와 Descriptor No를 연결 해주는 DB
  TParamNDescriptorRec4Avat2 = class(TSQLRecord)
  private
    Fsubtype: string; //@subtype의 @를 F로 대체 해야 함
    Fdescriptor: string;
    FParamNo: string;
    FdisplayName: string;
    FdisplayText: string;
    FplcName: string;
    FunitId: string;  //unit symbol
    Fgroup: string;
    Ftype: string;
    Fdecimals: integer;
    FDescription: string;
    FDescription_Eng: string;
    FDescription_Kor: string;
    FCategory: string;
    FSubCategory: string;
    FNote: string;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property subtype: string read Fsubtype write Fsubtype;
    property descriptor: string read Fdescriptor write Fdescriptor;
    property ParamNo: string read FParamNo write FParamNo;
    property displayName: string read FdisplayName write FdisplayName;
    property displayText: string read FdisplayText write FdisplayText;
    property plcName: string read FplcName write FplcName;
    property unitId: string read FunitId write FunitId;
    property FFgroup: string read Fgroup write Fgroup;
    property FFtype: string read Ftype write Ftype;
    property decimals: integer read Fdecimals write Fdecimals;
    property Description: string read FDescription write FDescription;
    property Description_Eng: string read FDescription_Eng write FDescription_Eng;
    property Description_Kor: string read FDescription_Kor write FDescription_Kor;
    property Category: string read FCategory write FCategory;
    property SubCategory: string read FSubCategory write FSubCategory;
    property Note: string read FNote write FNote;
  end;

  //AVAT DF A2 parameter description : E2Service에서 Setup Menu에 표시되는 분류표 임
  //Parameter Description.pdf 파일을 참조하여
  //E:\pjh\Doc\HGA\강의자료\Engine\HiMSEN\DF\커미셔닝\DF_AVAT_ParameterDescription_scale2.xlsx 파일에서
  //Import하여 TParamDescBase4AVAT2에 저장함
  TParamDescBase4AVAT2 = class(TSQLRecord)
  private
    FParamNo: string;
    FCategory: string;
    FSubCategory: string;
    FDescription: string;
    FDescription_Eng: string;
    FDescription_Kor: string;
    FunitId: string;  //unit symbol
    FScale: integer;
    FAlarmKind: string;
    FValueKind: string;
    FDefaultValue: string;
    FMinValue: string;
    FMaxValue: string;
    FUsage: string;//육상용, 해상용
    FNote,
    FValue: string;
    FCategoryEnum: TParameterCategory4AVAT2;
    FSubCategoryEnum: TParameterSubCategory4AVAT2;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property ParamNo: string read FParamNo write FParamNo;
    property Value: string read FValue write FValue;
    property Category: string read FCategory write FCategory;
    property CategoryEnum: TParameterCategory4AVAT2 read FCategoryEnum write FCategoryEnum;
    property SubCategory: string read FSubCategory write FSubCategory;
    property SubCategoryEnum: TParameterSubCategory4AVAT2 read FSubCategoryEnum write FSubCategoryEnum;
    property Description: string read FDescription write FDescription;
    property Description_Eng: string read FDescription_Eng write FDescription_Eng;
    property Description_Kor: string read FDescription_Kor write FDescription_Kor;
    property unitId: string read FunitId write FunitId;
    property Scale: integer read FScale write FScale;
    property AlarmKind: string read FAlarmKind write FAlarmKind;
    property ValueKind: string read FValueKind write FValueKind;
    property DefaultValue: string read FDefaultValue write FDefaultValue;
    property MinValue: string read FMinValue write FMinValue;
    property MaxValue: string read FMaxValue write FMaxValue;
    property Usage: string read FUsage write FUsage;
    property Note: string read FNote write FNote;
  end;

  //1.SnapShot Parameter만 저장한 DB(호선별로 파일 이름을 달리하여 저장할 것)
  //2.DB를 만든 후 메뉴 Save To Sqlite -> For ParamDescBase DB From DSD of SS를 실행하여
  //  SnapShot File내에서 Data Structure Documentation으로부터 Description_Eng를 Update함.
  //  기존 Parameter문서(Avat2ParamBase.sqlite)에 없는 Parameter의 Description을 갱신함
  TParameter4AVAT2 = class(TParamDescBase4AVAT2)
  private
    FProjNo,
    FHullNo,
    FEngineNo,
    FEngineType: string;
    FParameterType: TParameterType;
    FSensorType: TSensorType;
    FParameterSource: TParameterSource;

    Fdescriptor,
    FXAxisDescriptor,
    FXAxisDisplayKey,
    FXAxisDisplayName,
    FXAxisUnit,
    FXAxisData: string; //X축 Data: csv로 저장됨
    FXAxisDecimal: integer;
    FYAxisDescriptor,
    FYAxisDisplayKey,
    FYAxisDisplayName,
    FYAxisUnit,
    FYAxisData: string; //Y축 Data: csv로 저장됨
    FYAxisDecimal: integer;
    FMatrixData: string;//배열 Data: '[[csv],[csv]...]' 형식으로 저장됨
  published
    property ProjNo: string read FProjNo write FProjNo;
    property HullNo: string read FHullNo write FHullNo;
    property EngineNo: string read FEngineNo write FEngineNo;
    property EngineType: string read FEngineType write FEngineType;
    property descriptor: string read Fdescriptor write Fdescriptor;
    property ParameterType: TParameterType read FParameterType write FParameterType;
    property SensorType: TSensorType read FSensorType write FSensorType;
    property ParameterSource: TParameterSource read FParameterSource write FParameterSource;
    property XAxisDescriptor: string read FXAxisDescriptor write FXAxisDescriptor;
    property XAxisDisplayKey: string read FXAxisDisplayKey write FXAxisDisplayKey;
    property XAxisDisplayName: string read FXAxisDisplayName write FXAxisDisplayName;
    property XAxisUnit: string read FXAxisUnit write FXAxisUnit;
    property XAxisDecimal: integer read FXAxisDecimal write FXAxisDecimal;
    property XAxisData: string read FXAxisData write FXAxisData; //X축 Data: csv로 저장됨
    property YAxisDescriptor: string read FYAxisDescriptor write FYAxisDescriptor;
    property YAxisDisplayKey: string read FYAxisDisplayKey write FYAxisDisplayKey;
    property YAxisDisplayName: string read FYAxisDisplayName write FYAxisDisplayName;
    property YAxisUnit: string read FYAxisUnit write FYAxisUnit;
    property YAxisDecimal: integer read FYAxisDecimal write FYAxisDecimal;
    property YAxisData: string read FYAxisData write FYAxisData; //Y축 Data: csv로 저장됨
    property MatrixData: string read FMatrixData write FMatrixData; //배열 Data: '[[csv],[csv]...]' 형식으로 저장됨
  end;

  TEngineSensorRecord = class(TSQLRecord)
  private
    FECUVersion,
    FProjectNo,
    FTagName,
    FTBNo,
    FCableKind,
    FCableNo,
    FCableSpec,//Core 개수 및 두께(mm2) 정보
    FWiringCompany,//결선 주체
    FCableGlandNo,
    FNextPanelName,
    FNextTBName,
    FNextTBNo,
    FDrawingNo,
    FDrawPageNo: string;
    FPanelName:TPanelKind4AVAT2;
    FTBName: TTBKind4AVAT2;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property ECUVersion: string read FECUVersion write FECUVersion;
    property ProjectNo: string read FProjectNo write FProjectNo;
    property TagName: string read FTagName write FTagName;
    property PanelName: TPanelKind4AVAT2 read FPanelName write FPanelName;
    property TBName: TTBKind4AVAT2 read FTBName write FTBName;
    property TBNo: string read FTBNo write FTBNo;
    property CableKind: string read FCableKind write FCableKind;
    property CableNo: string read FCableNo write FCableNo;
    property CableSpec: string read FCableSpec write FCableSpec;
    property WiringCompany: string read FWiringCompany write FWiringCompany;
    property CableGlandNo: string read FCableGlandNo write FCableGlandNo;
    property NextPanelName: string read FNextPanelName write FNextPanelName;
    property NextTBName: string read FNextTBName write FNextTBName;
    property NextTBNo: string read FNextTBNo write FNextTBNo;
    property DrawingNo: string read FDrawingNo write FDrawingNo;
    property DrawPageNo: string read FDrawPageNo write FDrawPageNo;
  end;

const
  ENG_PARAM_DB_NAME = 'Avat2Param.sqlite';
  ENG_SENSOR_DB_NAME = 'HiMECS_DF_A2_Sensor.sqlite';
  ENG_PARAM_DEFAULT_DB_NAME = 'HiMECS_DF_A2_Param.sqlite';
  DF_AVAT2_PARAM_BASE_DB_NAME = 'Avat2ParamBase.sqlite';//Excel File로 부터 입력 받은 Param
  DF_AVAT2_PARAM_DEFAULT_DB_NAME = 'DFAvat2Param_Default.sqlite'; //Snapshot의 Value-Info, Value-States에서 관련 정보를 미리 DB에 저장함
  PPARM_ROOT_FOLDER = '.\Applications\doc\';
  PARAM_SLOW_TURNING_FILE_NAME = 'Param_Slow_Turning.txt';
  PARAM_ENGINE_START_FILE_NAME = 'Param_Engine_Start.txt';
  PARAM_ENGINE_STARTBLOCK_FILE_NAME = 'Param_Engine_StartBlock.txt';
  PARAM_MPSYSTEM_BUILDUP_FILE_NAME = 'Param_MPSystem_BuildUp.txt';
  PARAM_MPSYSTEM_OPTIMIZATION_FILE_NAME = 'Param_MPSystem_Optimization.txt';
  PARAM_MPSYSTEM_INJECTION_FILE_NAME = 'Param_MPSystem_Injection.txt';
  PARAM_SPEEDCONTROL_CBOPENED_FILE_NAME = 'Param_Speed_Control_CBOpened.txt';
  PARAM_SPEEDCONTROL_CBCLOSED_FILE_NAME = 'Param_Speed_Control_CBClosed.txt';
  PARAM_DVT_FILE_NAME = 'Param_DVT.txt';
  PARAM_GAS_TRIP_FILE_NAME = 'Param_Gas_Trip.txt';
  PARAM_PILOT_TRIP_FILE_NAME = 'Param_Pilot_Trip.txt';

procedure InitEngineParamClient(AEngineParamDBName: string = '');
function InitEngineParamClient2(AEngineParamDBName: string; var AEngineParamModel: TSQLModel):TSQLRestClientURI;
function CreateEngineParamModel: TSQLModel;
procedure DestroyEngineParamClient(AEngineParamDB: TSQLRestClientURI; AEngineParamModel: TSQLModel); overload;
procedure DestroyEngineParamClient; overload;

procedure InitUITextPoolClient(AUITextPoolDBName: string = '');
function CreateUITextPoolModel: TSQLModel;
procedure DestroyUITextPoolClient; overload;

procedure InitParamNDescriptorClient(AParamNDescriptorDBName: string = '');
function CreateParamNDescriptorModel: TSQLModel;
procedure DestroyParamNDescriptorClient; overload;

procedure InitParamBaseClient(AParamBaseDBName: string = '');
function CreateParamBaseModel: TSQLModel;
procedure DestroyParamBaseClient; overload;

procedure InitParam4AVAT2Client(AParam4AVAT2DBName: string = '');
function CreateParam4AVAT2Model: TSQLModel;
procedure DestroyParam4AVAT2Client; overload;

function GetDefaultDBPath: string;

//For TEngineParamRecord
function GetEngParamRec(AEngineParamDB: TSQLRestClientURI = nil): TEngineParamRecord;
function GetEngParamRecFromAddress(const AAddress: string; AEngineParamDB: TSQLRestClientURI = nil): TEngineParamRecord;
function GetEngParamRecFromParamNo(const AParamNo: string; AEngineParamDB: TSQLRestClientURI = nil): TEngineParamRecord;
function GetEngParamRecFromNotParamNo(AEngineParamDB: TSQLRestClientURI = nil): TEngineParamRecord;
function GetEngParamRecFromDescriptor(const ADescriptor: string; AEngineParamDB: TSQLRestClientURI = nil): TEngineParamRecord;
function GetEngParamRecFromSensorType(AEngineParamDB: TSQLRestClientURI = nil;
  const ASensorType: TSensorType = stNull; AIncludeDummy: Boolean = False): TEngineParamRecord;
function GetEngParamRecFromParamNoNCategory(const AParamNo: string;
  const ACategory: integer; AEngineParamDB: TSQLRestClientURI = nil): TEngineParamRecord;
function GetEngParamRecFromTagNo(const ATagName: string): TEngineParamRecord;
function GetVariantFromEngParamRecord(AEngineParamRecord:TEngineParamRecord): variant;
function GetEngParamList2JSONArrayFromSensorType(AEngineParamDB: TSQLRestClientURI = nil;
  const ASensorType: TSensorType = stNull; AIncludeDummy: Boolean=False): RawUTF8;
function GetEngParamList2JSONArrayFromNotParamNo(AEngineParamDB: TSQLRestClientURI = nil): RawUTF8;
function GetEngParamList2JSONArrayFromAddress(AEngineParamDB: TSQLRestClientURI = nil): RawUTF8;

procedure AddOrUpdatedEngParamRec(AEngineParamRecord: TEngineParamRecord; AEngineParamDB: TSQLRestClientURI = nil);
procedure LoadEngParamRecFromVariant(AEngineParamRecord: TEngineParamRecord; ADoc: variant);
function AddOrUpdateEngParamRecFromVariant(ADoc: variant; AIsOnlyAdd: Boolean = False; AEngineParamDB: TSQLRestClientURI = nil): integer;
procedure AddSensorData2SqliteFromSensorDB(ASrcDBFileName, ADestDBFileName: string);

//For TPLCInfoRec4Avat2
function GetPLCInfoRecFromSqlite(AEngineParamDB: TSQLRestClientURI = nil): TPLCInfoRec4Avat2;
procedure AddOrUpdatedPLCInfoRec(APLCInfoRec: TPLCInfoRec4Avat2; AEngineParamDB: TSQLRestClientURI = nil);

//For TUITextPoolRec4Avat2
function GetUITextPoolRecFromSqlite(AUITextPoolDB: TSQLRestClientURI = nil): TUITextPoolRec4Avat2;
function GetUITextPoolRecFromTextKey(ATextKey: string; AUITextPoolDB: TSQLRestClientURI = nil): TUITextPoolRec4Avat2;
procedure AddOrUpdatedUITextPoolRec(AUITextPoolRec: TUITextPoolRec4Avat2; AUITextPoolDB: TSQLRestClientURI = nil);

//For TParamNDescriptorRec4Avat2
function GetParamNDescriptorRecFromSqlite(AParamNDescriptorDB: TSQLRestClientURI = nil): TParamNDescriptorRec4Avat2;
function GetParamNDescriptorRecFromParamNo(AParamNo: string; AParamNDescriptorDB: TSQLRestClientURI = nil): TParamNDescriptorRec4Avat2;
function GetParamNDescriptorRecFromDescriptor(ADescriptor: string; AParamNDescriptorDB: TSQLRestClientURI = nil): TParamNDescriptorRec4Avat2;
function GetParamNDescriptorRecFromDisplayName(ADisplayName: string; AParamNDescriptorDB: TSQLRestClientURI = nil): TParamNDescriptorRec4Avat2;
procedure AddOrUpdatedParamNDescriptorRec(AParamNDescriptorRec: TParamNDescriptorRec4Avat2; AParamNDescriptorDB: TSQLRestClientURI = nil);

//For TParamDescBase4AVAT2
function GetParamDescBaseRecFromParamNo(AParamNo: string; AParamDescBaseDB: TSQLRestClientURI = nil): TParamDescBase4AVAT2;
function GetParamDescBaseRecFromSubCategoryStr(ASubCategoryStr: string; AParamDescBaseDB: TSQLRestClientURI = nil): TParamDescBase4AVAT2;
procedure AddOrUpdatedParamDescBaseRec(AParamDescBaseRec: TParamDescBase4AVAT2; AParamDescBaseDB: TSQLRestClientURI = nil);
procedure UpdatedParamDescBaseRec2CategoryEnum(AParamDescBaseDB: TSQLRestClientURI = nil);
procedure LoadParamDescBaseRecFromVariant(AParamDescBaseRec: TParamDescBase4AVAT2; ADoc: variant);

//For TDiscreteValue4Avat2
function GetDiscreteValueRecFromDescriptor(ADescriptor: string; AEngineParamDB: TSQLRestClientURI = nil): TDiscreteValue4Avat2;
procedure AddOrUpdatedDiscreteValueRec(ADiscreteRec: TDiscreteValue4Avat2; AEngineParamDB: TSQLRestClientURI = nil);

//For TEngineSensorRecord
function GetEngSensorRec(AEngineParamDB: TSQLRestClientURI = nil): TEngineSensorRecord;
function GetEngSensorRecFromTagName(const ATagName: string; AEngineParamDB: TSQLRestClientURI = nil): TEngineSensorRecord;
procedure AddOrUpdateEngSensorRec(AEngSensorRec: TEngineSensorRecord; AEngineParamDB: TSQLRestClientURI = nil);

//For TParameter4AVAT2
function GetAllParam4AVAT2Rec(AParam4AVAT2DB: TSQLRestClientURI = nil): TParameter4AVAT2;
function GetParam4AVAT2RecFromParamNo(AParamNo: string; AParam4AVAT2DB: TSQLRestClientURI = nil): TParameter4AVAT2;
function GetParam4AVAT2RecFromDescriptor(Adescriptor: string; AParam4AVAT2DB: TSQLRestClientURI = nil): TParameter4AVAT2;
procedure AddOrUpdatedParam4AVAT2Rec(AParam4AVAT2Rec: TParameter4AVAT2; AParam4AVAT2DB: TSQLRestClientURI = nil);

var
  g_EngineParamDB: TSQLRestClientURI;
  EngineParamModel: TSQLModel;

  g_UITextPoolDB: TSQLRestClientURI;
  UITextPoolModel: TSQLModel;

  g_ParamNDescriptorDB: TSQLRestClientURI;
  ParamNDescriptorModel: TSQLModel;

  g_ParamBaseDB: TSQLRestClientURI;
  ParamBaseModel: TSQLModel;

  g_Param4AVAT2DB: TSQLRestClientURI;
  Param4AVAT2Model: TSQLModel;

implementation

uses SysUtils, mORMotSQLite3, Forms, VarRecUtils, Vcl.Dialogs, UnitStringUtil,
  UnitFolderUtil, UnitRttiUtil, RTTI, UnitRegistrationClass, UnitEncryptedRegInfo;

procedure InitEngineParamClient(AEngineParamDBName: string = '');
var
  LStr: string;
begin
  if Assigned(g_EngineParamDB) then
    exit;

  if AEngineParamDBName = '' then
  begin
    AEngineParamDBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(AEngineParamDBName);
    AEngineParamDBName := ExtractFileName(AEngineParamDBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + AEngineParamDBName;
  EngineParamModel:= CreateEngineParamModel;
  g_EngineParamDB:= TSQLRestClientDB.Create(EngineParamModel, CreateEngineParamModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_EngineParamDB).Server.CreateMissingTables;
end;

function InitEngineParamClient2(AEngineParamDBName: string;
  var AEngineParamModel: TSQLModel):TSQLRestClientURI;
var
  LStr: string;
begin
  if AEngineParamDBName = '' then
  begin
    AEngineParamDBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(AEngineParamDBName);
    AEngineParamDBName := ExtractFileName(AEngineParamDBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + AEngineParamDBName;
  AEngineParamModel:= CreateEngineParamModel;
  Result:= TSQLRestClientDB.Create(AEngineParamModel, CreateEngineParamModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(Result).Server.CreateMissingTables;
end;

function CreateEngineParamModel: TSQLModel;
begin
  result := TSQLModel.Create([TEngineParamRecord, TPLCInfoRec4Avat2, TDiscreteValue4Avat2,
    TEngineMultiStateRecord, TParamDescBase4AVAT2, TEncryptedRegInfo]);
end;

procedure DestroyEngineParamClient;
begin
  if Assigned(EngineParamModel) then
    FreeAndNil(EngineParamModel);

  if Assigned(g_EngineParamDB) then
    FreeAndNil(g_EngineParamDB);
end;

procedure DestroyEngineParamClient(AEngineParamDB: TSQLRestClientURI; AEngineParamModel: TSQLModel);
begin
  if Assigned(AEngineParamModel) then
    FreeAndNil(AEngineParamModel);

  if Assigned(AEngineParamDB) then
    FreeAndNil(AEngineParamDB);
end;

procedure InitUITextPoolClient(AUITextPoolDBName: string = '');
var
  LStr: string;
begin
  if Assigned(g_UITextPoolDB) then
    exit;

  if AUITextPoolDBName = '' then
  begin
    AUITextPoolDBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(AUITextPoolDBName);
    AUITextPoolDBName := ExtractFileName(AUITextPoolDBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + AUITextPoolDBName;
  UITextPoolModel:= CreateUITextPoolModel;
  g_UITextPoolDB:= TSQLRestClientDB.Create(UITextPoolModel, CreateUITextPoolModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_UITextPoolDB).Server.CreateMissingTables;
end;

function CreateUITextPoolModel: TSQLModel;
begin
  result := TSQLModel.Create([TUITextPoolRec4Avat2]);
end;

procedure DestroyUITextPoolClient; overload;
begin
  if Assigned(UITextPoolModel) then
    FreeAndNil(UITextPoolModel);

  if Assigned(g_UITextPoolDB) then
    FreeAndNil(g_UITextPoolDB);
end;

procedure InitParamNDescriptorClient(AParamNDescriptorDBName: string = '');
var
  LStr: string;
begin
  if Assigned(g_ParamNDescriptorDB) then
    exit;

  if AParamNDescriptorDBName = '' then
  begin
    AParamNDescriptorDBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(AParamNDescriptorDBName);
    AParamNDescriptorDBName := ExtractFileName(AParamNDescriptorDBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + AParamNDescriptorDBName;
  ParamNDescriptorModel:= CreateParamNDescriptorModel;
  g_ParamNDescriptorDB:= TSQLRestClientDB.Create(ParamNDescriptorModel, CreateParamNDescriptorModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_ParamNDescriptorDB).Server.CreateMissingTables;
end;

function CreateParamNDescriptorModel: TSQLModel;
begin
  result := TSQLModel.Create([TParamNDescriptorRec4Avat2]);
end;

procedure DestroyParamNDescriptorClient; overload;
begin
  if Assigned(ParamNDescriptorModel) then
    FreeAndNil(ParamNDescriptorModel);

  if Assigned(g_ParamNDescriptorDB) then
    FreeAndNil(g_ParamNDescriptorDB);
end;

procedure InitParamBaseClient(AParamBaseDBName: string = '');
var
  LStr: string;
begin
  if Assigned(g_ParamBaseDB) then
    exit;

  if AParamBaseDBName = '' then
  begin
    AParamBaseDBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(AParamBaseDBName);
    AParamBaseDBName := ExtractFileName(AParamBaseDBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + AParamBaseDBName;
  ParamBaseModel:= CreateParamBaseModel;
  g_ParamBaseDB:= TSQLRestClientDB.Create(ParamBaseModel, CreateParamBaseModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_ParamBaseDB).Server.CreateMissingTables;
end;

function CreateParamBaseModel: TSQLModel;
begin
  result := TSQLModel.Create([TParamDescBase4AVAT2]);
end;

procedure DestroyParamBaseClient; overload;
begin
  if Assigned(ParamBaseModel) then
    FreeAndNil(ParamBaseModel);

  if Assigned(g_ParamBaseDB) then
    FreeAndNil(g_ParamBaseDB);
end;

procedure InitParam4AVAT2Client(AParam4AVAT2DBName: string = '');
var
  LStr: string;
begin
  if Assigned(g_Param4AVAT2DB) then
    exit;

  if AParam4AVAT2DBName = '' then
  begin
    AParam4AVAT2DBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(AParam4AVAT2DBName);
    AParam4AVAT2DBName := ExtractFileName(AParam4AVAT2DBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  LStr := LStr + AParam4AVAT2DBName;
  Param4AVAT2Model:= CreateParam4AVAT2Model;
  g_Param4AVAT2DB:= TSQLRestClientDB.Create(Param4AVAT2Model, CreateParam4AVAT2Model,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_Param4AVAT2DB).Server.CreateMissingTables;
end;

function CreateParam4AVAT2Model: TSQLModel;
begin
  result := TSQLModel.Create([TParameter4AVAT2]);
end;

procedure DestroyParam4AVAT2Client; overload;
begin
  if Assigned(Param4AVAT2Model) then
    FreeAndNil(Param4AVAT2Model);

  if Assigned(g_Param4AVAT2DB) then
    FreeAndNil(g_Param4AVAT2DB);
end;

function GetDefaultDBPath: string;
var
  LStr: string;
begin
  LStr := ExtractFilePath(Application.ExeName);
  SetCurrentDir(LStr);

  if ExtractFileName(Application.ExeName) = 'HiMECS.exe' then
    Result := IncludeTrailingBackSlash(LStr) + 'db\'
  else
    Result := '..\db\';
end;

function GetEngParamRec(AEngineParamDB: TSQLRestClientURI = nil): TEngineParamRecord;
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
    'ID <> ?', [-1]);
end;

function GetEngParamRecFromAddress(const AAddress: string; AEngineParamDB: TSQLRestClientURI = nil): TEngineParamRecord;
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  if AAddress = '' then
    Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
      'Address <> ? order by BlockNo', [AAddress])
  else
    Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
      'Address = ? order by BlockNo', [AAddress]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetEngParamRecFromParamNo(const AParamNo: string; AEngineParamDB: TSQLRestClientURI): TEngineParamRecord;
begin
  if AParamNo = '' then
  begin
    Result := TEngineParamRecord.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    if not Assigned(AEngineParamDB) then
      AEngineParamDB := g_EngineParamDB;

    Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
      'ParamNo = ?', [AParamNo]);

    if Result.FillOne then
      Result.IsUpdate := True
    else
      Result.IsUpdate := False;
  end;
end;

function GetEngParamRecFromNotParamNo(AEngineParamDB: TSQLRestClientURI): TEngineParamRecord;
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
    'ParamNo = ?', ['']);
end;

function GetEngParamRecFromDescriptor(const ADescriptor: string;
  AEngineParamDB: TSQLRestClientURI): TEngineParamRecord;
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  if ADescriptor = '' then
    Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
      'descriptor IS NOT NULL', [])
  else
    Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
      'descriptor = ?', [ADescriptor]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetEngParamRecFromSensorType(AEngineParamDB: TSQLRestClientURI;
  const ASensorType: TSensorType; AIncludeDummy: Boolean): TEngineParamRecord;
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  if ASensorType = stNull then
  begin
    if AIncludeDummy then
      Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
        'SensorType <> ?', [-1])
    else
      Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
        'SensorType <> ? and TagName <> ?', [-1, 'DUMMY']);
  end
  else
  begin
    if AIncludeDummy then
      Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
        'SensorType = ?', [Ord(ASensorType)])
    else
      Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
        'SensorType = ? and TagName <> ?', [Ord(ASensorType), 'DUMMY']);
  end;

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetEngParamRecFromParamNoNCategory(const AParamNo: string;
  const ACategory: integer; AEngineParamDB: TSQLRestClientURI): TEngineParamRecord;
begin
  if AParamNo = '' then
  begin
    Result := TEngineParamRecord.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    if not Assigned(AEngineParamDB) then
      AEngineParamDB := g_EngineParamDB;

    Result := TEngineParamRecord.CreateAndFillPrepare(AEngineParamDB,
      'ParamNo LIKE ? and ParameterCatetory4AVAT2 = ?', ['%'+AParamNo+'%', ACategory]);

    if Result.FillOne then
      Result.IsUpdate := True
    else
      Result.IsUpdate := False;
  end;
end;

function GetEngParamRecFromTagNo(const ATagName: string): TEngineParamRecord;
begin
  if ATagName = '' then
  begin
    Result := TEngineParamRecord.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    Result := TEngineParamRecord.CreateAndFillPrepare(g_EngineParamDB,
      'TagName = ?', [ATagName]);

    if Result.FillOne then
      Result.IsUpdate := True
    else
      Result.IsUpdate := False;
  end;
end;

function GetVariantFromEngParamRecord(AEngineParamRecord:TEngineParamRecord): variant;
begin
  TDocVariant.New(Result);
  LoadRecordPropertyToVariant(AEngineParamRecord, Result);
end;

function GetEngParamList2JSONArrayFromSensorType(AEngineParamDB: TSQLRestClientURI;
  const ASensorType: TSensorType; AIncludeDummy: Boolean): RawUTF8;
var
  LEngineParamRecord:TEngineParamRecord;
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LEngineParamRecord := GetEngParamRecFromSensorType(AEngineParamDB, ASensorType, AIncludeDummy);

  try
    LEngineParamRecord.FillRewind;

    while LEngineParamRecord.FillOne do
    begin
      LUtf8 := LEngineParamRecord.GetJSONValues(true, true, soSelect);
      LDynArr.Add(LUtf8);
    end;

    LUtf8 := LDynArr.SaveToJSON;
    Result := LUtf8;
  finally
    FreeAndNil(LEngineParamRecord);
  end;
end;

function GetEngParamList2JSONArrayFromNotParamNo(AEngineParamDB: TSQLRestClientURI): RawUTF8;
var
  LEngineParamRecord:TEngineParamRecord;
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LEngineParamRecord := GetEngParamRecFromNotParamNo(AEngineParamDB);

  try
    while LEngineParamRecord.FillOne do
    begin
      LUtf8 := LEngineParamRecord.GetJSONValues(true, true, soSelect);
      LDynArr.Add(LUtf8);
    end;

    LUtf8 := LDynArr.SaveToJSON;
    Result := LUtf8;
  finally
    FreeAndNil(LEngineParamRecord);
  end;
end;

function GetEngParamList2JSONArrayFromAddress(AEngineParamDB: TSQLRestClientURI): RawUTF8;
var
  LEngineParamRecord:TEngineParamRecord;
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LEngineParamRecord := GetEngParamRecFromAddress('',AEngineParamDB);

  try
    LEngineParamRecord.FillRewind;

    while LEngineParamRecord.FillOne do
    begin
      LUtf8 := LEngineParamRecord.GetJSONValues(true, true, soSelect);
      LDynArr.Add(LUtf8);
    end;

    LUtf8 := LDynArr.SaveToJSON;
    Result := LUtf8;
  finally
    FreeAndNil(LEngineParamRecord);
  end;
end;

procedure AddOrUpdatedEngParamRec(AEngineParamRecord: TEngineParamRecord;
  AEngineParamDB: TSQLRestClientURI);
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  if AEngineParamRecord.IsUpdate then
  begin
    AEngineParamDB.Update(AEngineParamRecord);
  end
  else
  begin
    AEngineParamDB.Add(AEngineParamRecord, true);
  end;
end;

procedure LoadEngParamRecFromVariant(AEngineParamRecord: TEngineParamRecord; ADoc: variant);
begin
  if ADoc = null then
    exit;

  LoadRecordPropertyFromVariant(AEngineParamRecord, ADoc);
end;

function AddOrUpdateEngParamRecFromVariant(ADoc: variant; AIsOnlyAdd: Boolean;
  AEngineParamDB: TSQLRestClientURI): integer;
var
  LEngineParamRecord: TEngineParamRecord;
  LIsUpdate: Boolean;
//  LParameterCatetory4AVAT2: integer;
begin
//  LParameterCatetory4AVAT2 := Ord(TRttiEnumerationType.GetValue<TParameterCatetory4AVAT2>(ADoc.ParameterCatetory4AVAT2));

  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  LEngineParamRecord := GetEngParamRecFromParamNoNCategory(ADoc.ParamNo, ADoc.ParameterCatetory4AVAT2, AEngineParamDB);
  LIsUpdate := LEngineParamRecord.IsUpdate;
  try
    if AIsOnlyAdd then
    begin
      if not LEngineParamRecord.IsUpdate then
      begin
        LoadEngParamRecFromVariant(LEngineParamRecord, ADoc);
        LEngineParamRecord.IsUpdate := LIsUpdate;

        AddOrUpdatedEngParamRec(LEngineParamRecord, AEngineParamDB);
        Inc(Result);
      end;
    end
    else
    begin
      if LEngineParamRecord.IsUpdate then
        Inc(Result);

      LoadEngParamRecFromVariant(LEngineParamRecord, ADoc);
      LEngineParamRecord.IsUpdate := LIsUpdate;

      AddOrUpdatedEngParamRec(LEngineParamRecord, AEngineParamDB);
    end;
  finally
    FreeAndNil(LEngineParamRecord);
  end;
end;

procedure AddSensorData2SqliteFromSensorDB(ASrcDBFileName, ADestDBFileName: string);
var
  LSrcDB, LDestDB: TSQLRestClientURI;
  LSrcModel, LDestModel: TSQLModel;
  LEngineParamRecord: TEngineParamRecord;
begin
  LSrcDB := InitEngineParamClient2(ASrcDBFileName, LSrcModel);
  LDestDB := InitEngineParamClient2(ADestDBFileName, LDestModel);
  try
    LEngineParamRecord := GetEngParamRecFromAddress('', LSrcDB);
    LEngineParamRecord.FillRewind;

    while LEngineParamRecord.FillOne() do
    begin
      LEngineParamRecord.IsUpdate := False;
      AddOrUpdatedEngParamRec(LEngineParamRecord, LDestDB);
    end;

    ShowMessage('Sensor data is added to ''' + ADestDBFileName + ''' file succefully!');
  finally
    DestroyEngineParamClient(LDestDB, LDestModel);
    DestroyEngineParamClient(LSrcDB, LSrcModel);
  end;
end;

function GetPLCInfoRecFromSqlite(AEngineParamDB: TSQLRestClientURI = nil): TPLCInfoRec4Avat2;
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  Result := TPLCInfoRec4Avat2.CreateAndFillPrepare(AEngineParamDB,
      'ID <> ?', [-1]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure AddOrUpdatedPLCInfoRec(APLCInfoRec: TPLCInfoRec4Avat2; AEngineParamDB: TSQLRestClientURI = nil);
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  if APLCInfoRec.IsUpdate then
  begin
    AEngineParamDB.Update(APLCInfoRec);
  end
  else
  begin
    AEngineParamDB.Add(APLCInfoRec, true);
  end;
end;

function GetUITextPoolRecFromSqlite(AUITextPoolDB: TSQLRestClientURI = nil): TUITextPoolRec4Avat2;
begin
  if not Assigned(AUITextPoolDB) then
    AUITextPoolDB := g_UITextPoolDB;

  Result := TUITextPoolRec4Avat2.CreateAndFillPrepare(AUITextPoolDB,
      'ID <> ?', [-1]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetUITextPoolRecFromTextKey(ATextKey: string; AUITextPoolDB: TSQLRestClientURI = nil): TUITextPoolRec4Avat2;
begin
  if not Assigned(AUITextPoolDB) then
    AUITextPoolDB := g_UITextPoolDB;

  Result := TUITextPoolRec4Avat2.CreateAndFillPrepare(AUITextPoolDB,
      'entries_textKey = ?', [ATextKey]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure AddOrUpdatedUITextPoolRec(AUITextPoolRec: TUITextPoolRec4Avat2; AUITextPoolDB: TSQLRestClientURI = nil);
begin
  if not Assigned(AUITextPoolDB) then
    AUITextPoolDB := g_UITextPoolDB;

  if AUITextPoolRec.IsUpdate then
  begin
    AUITextPoolDB.Update(AUITextPoolRec);
  end
  else
  begin
    AUITextPoolDB.Add(AUITextPoolRec, true);
  end;
end;

function GetParamNDescriptorRecFromSqlite(AParamNDescriptorDB: TSQLRestClientURI = nil): TParamNDescriptorRec4Avat2;
begin
  if not Assigned(AParamNDescriptorDB) then
    AParamNDescriptorDB := g_ParamNDescriptorDB;

  Result := TParamNDescriptorRec4Avat2.CreateAndFillPrepare(AParamNDescriptorDB,
      'ID <> ?', [-1]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetParamNDescriptorRecFromParamNo(AParamNo: string; AParamNDescriptorDB: TSQLRestClientURI = nil): TParamNDescriptorRec4Avat2;
begin
  if not Assigned(AParamNDescriptorDB) then
    AParamNDescriptorDB := g_ParamNDescriptorDB;

  Result := TParamNDescriptorRec4Avat2.CreateAndFillPrepare(AParamNDescriptorDB,
      'ParamNo = ?', [AParamNo]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetParamNDescriptorRecFromDescriptor(ADescriptor: string; AParamNDescriptorDB: TSQLRestClientURI = nil): TParamNDescriptorRec4Avat2;
begin
  if not Assigned(AParamNDescriptorDB) then
    AParamNDescriptorDB := g_ParamNDescriptorDB;

  Result := TParamNDescriptorRec4Avat2.CreateAndFillPrepare(AParamNDescriptorDB,
      'descriptor = ?', [ADescriptor]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetParamNDescriptorRecFromDisplayName(ADisplayName: string; AParamNDescriptorDB: TSQLRestClientURI = nil): TParamNDescriptorRec4Avat2;
begin
  if not Assigned(AParamNDescriptorDB) then
    AParamNDescriptorDB := g_ParamNDescriptorDB;

  Result := TParamNDescriptorRec4Avat2.CreateAndFillPrepare(AParamNDescriptorDB,
      'displayName = ?', [ADisplayName]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure AddOrUpdatedParamNDescriptorRec(AParamNDescriptorRec: TParamNDescriptorRec4Avat2; AParamNDescriptorDB: TSQLRestClientURI = nil);
begin
  if not Assigned(AParamNDescriptorDB) then
    AParamNDescriptorDB := g_ParamNDescriptorDB;

  if AParamNDescriptorRec.IsUpdate then
  begin
    AParamNDescriptorDB.Update(AParamNDescriptorRec);
  end
  else
  begin
    AParamNDescriptorDB.Add(AParamNDescriptorRec, true);
  end;
end;

function GetParamDescBaseRecFromParamNo(AParamNo: string; AParamDescBaseDB: TSQLRestClientURI = nil): TParamDescBase4AVAT2;
begin
  if not Assigned(AParamDescBaseDB) then
  begin
    if not Assigned(g_ParamBaseDB) then
      InitParamBaseClient(DF_AVAT2_PARAM_BASE_DB_NAME);

    AParamDescBaseDB := g_ParamBaseDB;
  end;

  Result := TParamDescBase4AVAT2.CreateAndFillPrepare(AParamDescBaseDB,
      'ParamNo = ?', [AParamNo]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetParamDescBaseRecFromSubCategoryStr(ASubCategoryStr: string; AParamDescBaseDB: TSQLRestClientURI = nil): TParamDescBase4AVAT2;
begin
  if not Assigned(AParamDescBaseDB) then
  begin
    if not Assigned(g_ParamBaseDB) then
      InitParamBaseClient(DF_AVAT2_PARAM_BASE_DB_NAME);

    AParamDescBaseDB := g_ParamBaseDB;
  end;

  if ASubCategoryStr = '' then
    Result := TParamDescBase4AVAT2.CreateAndFillPrepare(AParamDescBaseDB,
        'SubCategory <> ?', [ASubCategoryStr])
  else
    Result := TParamDescBase4AVAT2.CreateAndFillPrepare(AParamDescBaseDB,
        'SubCategory = ?', [ASubCategoryStr]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure AddOrUpdatedParamDescBaseRec(AParamDescBaseRec: TParamDescBase4AVAT2; AParamDescBaseDB: TSQLRestClientURI = nil);
begin
  if not Assigned(AParamDescBaseDB) then
    AParamDescBaseDB := g_ParamBaseDB;

  if AParamDescBaseRec.IsUpdate then
  begin
    AParamDescBaseDB.Update(AParamDescBaseRec);
  end
  else
  begin
    AParamDescBaseDB.Add(AParamDescBaseRec, true);
  end;
end;

procedure UpdatedParamDescBaseRec2CategoryEnum(AParamDescBaseDB: TSQLRestClientURI = nil);
var
  i: integer;
  LCategoryList, LSubCategoryList: TStrings;
  LParamDescBase4AVAT2: TParamDescBase4AVAT2;
begin
  if not Assigned(AParamDescBaseDB) then
    AParamDescBaseDB := g_ParamBaseDB;

  if not g_ParameterCategory4AVAT2.IsInitArray then
    g_ParameterCategory4AVAT2.InitArrayRecord(R_ParameterCategory4AVAT2);

  if not g_ParameterSubCategory4AVAT2.IsInitArray then
    g_ParameterSubCategory4AVAT2.InitArrayRecord(R_ParameterSubCategory4AVAT2);

  LCategoryList := g_ParameterCategory4AVAT2.GetTypeLabels;
  LSubCategoryList := g_ParameterSubCategory4AVAT2.GetTypeLabels;

  LParamDescBase4AVAT2 := GetParamDescBaseRecFromSubCategoryStr('', AParamDescBaseDB);
  try
    if LParamDescBase4AVAT2.IsUpdate then
    begin
      LParamDescBase4AVAT2.FillRewind;

      while LParamDescBase4AVAT2.FillOne do
      begin
        i := LCategoryList.IndexOf(LParamDescBase4AVAT2.Category);

        if i > -1 then
        begin
          LParamDescBase4AVAT2.CategoryEnum := g_ParameterCategory4AVAT2.ToType(LCategoryList.Strings[i]);
        end;

        i := LSubCategoryList.IndexOf(LParamDescBase4AVAT2.SubCategory);

        if i > -1 then
        begin
          LParamDescBase4AVAT2.SubCategoryEnum := g_ParameterSubCategory4AVAT2.ToType(LSubCategoryList.Strings[i]);
        end;

        LParamDescBase4AVAT2.IsUpdate := True;
        AddOrUpdatedParamDescBaseRec(LParamDescBase4AVAT2, AParamDescBaseDB);
      end;//while
    end;
  finally
    LCategoryList.Free;
    LSubCategoryList.Free;
    LParamDescBase4AVAT2.Free;
  end;
end;

procedure LoadParamDescBaseRecFromVariant(AParamDescBaseRec: TParamDescBase4AVAT2; ADoc: variant);
begin
  if ADoc = null then
    exit;

  LoadRecordPropertyFromVariant(AParamDescBaseRec, ADoc);
end;

function GetDiscreteValueRecFromDescriptor(ADescriptor: string;
  AEngineParamDB: TSQLRestClientURI = nil): TDiscreteValue4Avat2;
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  Result := TDiscreteValue4Avat2.CreateAndFillPrepare(AEngineParamDB,
      'Descriptor LIKE ?', ['%'+ADescriptor+'%']);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure AddOrUpdatedDiscreteValueRec(ADiscreteRec: TDiscreteValue4Avat2;
  AEngineParamDB: TSQLRestClientURI = nil);
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  if ADiscreteRec.IsUpdate then
  begin
    AEngineParamDB.Update(ADiscreteRec);
  end
  else
  begin
    AEngineParamDB.Add(ADiscreteRec, true);
  end;
end;

function GetEngSensorRec(AEngineParamDB: TSQLRestClientURI = nil): TEngineSensorRecord;
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  Result := TEngineSensorRecord.CreateAndFillPrepare(AEngineParamDB,
    'ID <> ?', [-1]);
end;

function GetEngSensorRecFromTagName(const ATagName: string; AEngineParamDB: TSQLRestClientURI = nil): TEngineSensorRecord;
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  if ATagName = '' then
    Result := TEngineSensorRecord.CreateAndFillPrepare(AEngineParamDB,
      'Address <> ?', [ATagName])
  else
    Result := TEngineSensorRecord.CreateAndFillPrepare(AEngineParamDB,
      'Address = ?', [ATagName]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure AddOrUpdateEngSensorRec(AEngSensorRec: TEngineSensorRecord; AEngineParamDB: TSQLRestClientURI = nil);
begin
  if not Assigned(AEngineParamDB) then
    AEngineParamDB := g_EngineParamDB;

  if AEngSensorRec.IsUpdate then
  begin
    AEngineParamDB.Update(AEngSensorRec);
  end
  else
  begin
    AEngineParamDB.Add(AEngSensorRec, true);
  end;
end;

function GetAllParam4AVAT2Rec(AParam4AVAT2DB: TSQLRestClientURI = nil): TParameter4AVAT2;
begin
  if not Assigned(AParam4AVAT2DB) then
    AParam4AVAT2DB := g_Param4AVAT2DB;

  Result := TParameter4AVAT2.CreateAndFillPrepare(AParam4AVAT2DB,
      'ID <> ?', [0]);
end;

function GetParam4AVAT2RecFromParamNo(AParamNo: string; AParam4AVAT2DB: TSQLRestClientURI = nil): TParameter4AVAT2;
begin
  if not Assigned(AParam4AVAT2DB) then
    AParam4AVAT2DB := g_Param4AVAT2DB;

  Result := TParameter4AVAT2.CreateAndFillPrepare(AParam4AVAT2DB,
      'ParamNo = ?', [AParamNo]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetParam4AVAT2RecFromDescriptor(Adescriptor: string; AParam4AVAT2DB: TSQLRestClientURI = nil): TParameter4AVAT2;
begin
  if not Assigned(AParam4AVAT2DB) then
    AParam4AVAT2DB := g_Param4AVAT2DB;

  Result := TParameter4AVAT2.CreateAndFillPrepare(AParam4AVAT2DB,
      'descriptor = ?', [Adescriptor]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

procedure AddOrUpdatedParam4AVAT2Rec(AParam4AVAT2Rec: TParameter4AVAT2; AParam4AVAT2DB: TSQLRestClientURI = nil);
begin
  if not Assigned(AParam4AVAT2DB) then
    AParam4AVAT2DB := g_Param4AVAT2DB;

  if AParam4AVAT2Rec.IsUpdate then
  begin
    AParam4AVAT2DB.Update(AParam4AVAT2Rec);
  end
  else
  begin
    AParam4AVAT2DB.Add(AParam4AVAT2Rec, true);
  end;
end;

initialization

finalization
  DestroyEngineParamClient;

end.

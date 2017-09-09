unit EngineParameterClass;
{
  TEngineParameterItem 추가 시 수정해야 하는 내용 >--
    1) TEngineParameterItemRecord.AssignToParamItem 함수에 내용 추가
    2) TEngineParameterItemRecord.AssignTo 함수에 내용 추가
    3) TEngineParameterItem.AssignTo 함수에 내용 추가
    4) TEngineParameterItem.Assign 함수에 내용 추가
  --<
}
interface

uses classes, BaseConfigCollect, HiMECSConst, SynCommons;

type
  TEngineParameterCollect = class;
  TEngineParameterItem = class;

  TMatrixCollect = class;
  TMatrixItem = class;

  PMatrixItemRecord = ^TMatrixItemRecord;
  TMatrixItemRecord = record
    FXAxisIData: String[100];
    FXAxisILength: integer;
    FYAxisIData: String[100];
    FYAxisILength: integer;
    FZAxisIData: String[100];
    FZAxisILength: integer;
    FValueIData: array[0..1000] of integer;
    FValueILength: integer;
    FXAxisFData: String[100];
    FXAxisFLength: integer;
    FYAxisFData: String[100];
    FYAxisFLength: integer;
    FZAxisFData: String[100];
    FZAxisFLength: integer;
    FValueFData: array[0..1000] of single;
    FValueFLength: integer;
  end;

  PEngineParameterItemRecord = ^TEngineParameterItemRecord;
  TEngineParameterItemRecord = record
    FUserLevel: THiMECSUserLevel;
    FAlarmLevel,
    FLevelIndex,
    FNodeIndex,
    FAbsoluteIndex,
    FMaxValue,
    FBlockNo,
    FContact //1: A 접점, 2: B 접점
    : integer;
    FMaxValue_real: double;
    FValue: string[50];
    FProjNo:string[10]; //공사번호
    FEngNo: string[2];//엔진순번(1부터 시작)
    FSharedName: string[200];
    FTagName: string[200];
    FDescription: string[200];
    FAddress: string[10];
    FFCode: string[3];
    FUnit: string[10];
    FMinMaxType: TValueType; //mmtInteger, mmtReal
    FAlarm: Boolean;
    FRadixPosition: integer; //Binary data일 경우 32Bit내 Index를 저장함.
    FDisplayUnit: Boolean; //단위 표시 유무
    FDisplayThousandSeperator: Boolean;//1000 단위 구분자(,) 표시 유무
    FDisplayFormat: string[20];

    FSensorType: TSensorType;
    FParameterCatetory: TParameterCatetory;
    FParameterType: TParameterType;
    FParameterSource: TParameterSource;
    //==================================================
    FSelectFaultValue: integer;//0:not used, 1: original, 2: this
    FAlarmPriority: TAlarmPriority;//(apCritical, apWarning, apAdvisory, apLog)
    FAlarmEnable: Boolean;

    FMinAlarmEnable: Boolean; //아래 변수들 사용 여부
    FMaxAlarmEnable: Boolean; //
    FMinFaultEnable: Boolean;
    FMaxFaultEnable: Boolean;

    FMinAlarmValue: double; //Fault보다 낮은 레벨
    FMaxAlarmValue: double; //
    FMinFaultValue: double;
    FMaxFaultValue: double;

    FMinAlarmColor: Longint; //Alarm 발생시 표시색
    FMaxAlarmColor: Longint;
    FMinFaultColor: Longint;
    FMaxFaultColor: Longint;

    FMinAlarmBlink: Boolean; //Alarm 발생시 Blink
    FMaxAlarmBlink: Boolean;
    FMinFaultBlink: Boolean;
    FMaxFaultBlink: Boolean;

    FMinAlarmSoundEnable: Boolean; //Sound들 사용 여부
    FMaxAlarmSoundEnable: Boolean;
    FMinFaultSoundEnable: Boolean;
    FMaxFaultSoundEnable: Boolean;

    FMinAlarmSoundFilename: string[100]; //Sound File Name
    FMaxAlarmSoundFilename: string[100]; //
    FMinFaultSoundFilename: string[100];
    FMaxFaultSoundFilename: string[100];

    FFormulaValueList: string[200]; //Item간 계산 식(=''이면 Raw Item)

    //=====================//for Graph (Watch 폼에서
    FIsDisplayTrend: Boolean;
    FIsDisplayXY: Boolean;
    FTrendChannelIndex,
    FTrendAlarmIndex,
    FTrendFaultIndex,
    FTrendYAxisIndex: integer;
    FPlotXValue: double;
    FMinValue: integer;
    FMinValue_Real: real;
    FIsDisplaySimple: Boolean;
    FYAxesMinValue: Double;
    FYAxesSpanValue: Double;
    FUseXYGraphConstant: Boolean;
    FIsDisplayTrendAlarm: Boolean;
    FIsDisplayTrendFault: Boolean;

    FAllowUserLevelWatchList: THiMECSUserLevel; //watch list에서 파일 오픈시 허용 가능한 레벨
    FIsAverageValue: Boolean;//Watch Save시에 평균값 저장 여부
    FExcelRange: string[100];//엑셀 보고서 위치 정보

    //TEngineParameterClass에는 없음, WatchList 파일을 선별적으로 Load할때 쓰임
    //아래 변수를 레코드 맨 마지막에 선언하면 SendCopy 시에 에러 남.(20120706)
    FProjectFileName: string[100];
    //==========Form State
    FFormWidth,
    FFormHeight,
    FFormTop,
    FFormLeft: integer;
    FFormState: TpjhWindowState;

    FMatrixItemIndex,
    FXAxisSize,
    FYAxisSize,
    FZAxisSize: integer;
    FMatrixItemRecord: TMatrixItemRecord;

    FKbdShiftState: TShiftState;//Watch2 Form에 Ctrl 키 누름 상태 보내기 위해 사용 됨
    FParamDragCopyMode: TParamDragCopyMode;//Watch2 Form에 Drag시 Copy Mode 상태 보내기 위해 사용 됨

{    FXAxisIData: String[200];
    FXAxisILength: integer;
    FYAxisIData: String[200];
    FYAxisILength: integer;
    FZAxisIData: String[200];
    FZAxisILength: integer;
    FValueIData: String[200];
    FValueILength: integer;
    FXAxisFData: String[200];
    FXAxisFLength: integer;
    FYAxisFData: String[200];
    FYAxisFLength: integer;
    FZAxisFData: String[200];
    FZAxisFLength: integer;
    FValueFData: String[200];
    FValueFLength: integer;
}
    procedure AssignToParamItem(var AEPItem: TEngineParameterItem);
    procedure AssignToMatrixItem(var AMItem: TMatrixItem);
    procedure AssignTo(var AEPItemRecord:TEngineParameterItemRecord);
  end;

  //TEngineParameter_DynArray = array of TEngineParameterItemRecord;

  TEngineParameter = class(TpjhBase)
  private
    FEngineParameterCollect: TEngineParameterCollect;
    FMatrixCollect: TMatrixCollect;
    FFilePath: string;//
    FExeName: string;
    FProjectFileName: string;
    FAllowUserLevelWatchList: THiMECSUserLevel; //watch list에서 파일 오픈시 허용 가능한 레벨
    //==========Form State
    FFormWidth,
    FFormHeight,
    FFormTop,
    FFormLeft: integer;
    FFormState: TpjhWindowState;
    FStayOnTop,
    FSaveWatchForm: Boolean;
    FUseAlphaBlend: Boolean;
    FAlphaValue: integer;
    FTabShow: Boolean;
    FBorderShow: Boolean;
    FFactoryName: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function LoadFromJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; override;
    function SaveToJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; override;

    function GetItemIndex(AEPItem: TEngineParameterItem): integer; overload;
    function GetItemIndex(ATagName: string): integer; overload;

    function GetMatrixDataIdx(XIdx, YIdx: integer; AMatrixItem: TMatrixItem): integer; overload;
    //Matrix Item의 저장된(Published) 데이터를 내부변수(Public)로 복사함.
    procedure MatrixPublished2Public;
    //Config Parameter(published-파일에 저장되는 변수) 비교
    //같으면 0, 다르면 0보다 큰 숫자;
    function ComparePublishedMatrix(AParam: TEngineParameter): integer;
    //Config Parameter(public) 비교
    //같으면 0, 다르면 0보다 큰 숫자;
    function ComparePublicMatrix(AParam: TEngineParameter): integer;
  published
    property EngineParameterCollect: TEngineParameterCollect read FEngineParameterCollect write FEngineParameterCollect;
    property MatrixCollect: TMatrixCollect read FMatrixCollect write FMatrixCollect;
    property ExeName: string read FExeName write FExeName;
    property ProjectFileName: string read FProjectFileName write FProjectFileName;
    property FilePath: string read FFilePath write FFilePath;
    property AllowUserLevelWatchList: THiMECSUserLevel read FAllowUserLevelWatchList write FAllowUserLevelWatchList;

    property FormWidth: integer read FFormWidth write FFormWidth;
    property FormHeight: integer read FFormHeight write FFormHeight;
    property FormTop: integer read FFormTop write FFormTop;
    property FormLeft: integer read FFormLeft write FFormLeft;
    property FormState: TpjhWindowState read FFormState write FFormState;
    property UseAlphaBlend: Boolean read FUseAlphaBlend write FUseAlphaBlend;
    property AlphaValue: integer read FAlphaValue write FAlphaValue;
    property TabShow: Boolean read FTabShow write FTabShow;
    property BorderShow: Boolean read FBorderShow write FBorderShow;
    property StayOnTop: Boolean read FStayOnTop write FStayOnTop;
    property SaveWatchForm: Boolean read FSaveWatchForm write FSaveWatchForm;
    property FactoryName: string read FFactoryName  write FFactoryName;
  end;

  //Item 추가시에 Assign에도 추가할 것
  PEngineParameterItem = ^TEngineParameterItem;
  TEngineParameterItem = class(TCollectionItem)
  private
    FUserLevel: THiMECSUserLevel;
    FAlarmLevel,
    FLevelIndex,
    FNodeIndex,
    FAbsoluteIndex, //Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index) : 0부터 시작함
    FMaxValue,
    FBlockNo,
    FContact, //1: A 접점, 2: B 접점
    FScale
    : integer;
    FMaxValue_Real: real; //avat의 경우 real값이 옴.
    FSharedName,
    FTagName,
    FDescription,  //Matrix Data일 경우 Description(XAxis Desc;YAxis Desc;ZAxis Desc)
    FAddress,
    FFCode,
    FUnit,
    FValue,
    FProjNo, //공사번호
    FEngNo: string;//엔진순번(1부터 시작)

    FMinMaxType: TValueType; //mmtInteger, mmtReal

    FAlarm: Boolean;//True = Analog, False = Digital
    //소수점 위치 = 0이면 정수, 1이면 0.1 ... (Binary Type일 경우 32Bit 중 Position Index 저장)
    FRadixPosition: integer;
    FDisplayUnit: Boolean; //단위 표시 유무
    FDisplayThousandSeperator: Boolean;//1000 단위 구분자(,) 표시 유무
    FDisplayFormat: string; //FormatFloat함수 인자로 사용됨

    FSensorType: TSensorType;
    FParameterCatetory: TParameterCatetory;
    FParameterType: TParameterType;
    FParameterSource: TParameterSource;
    //==================================================
    FAlarmPriority: TAlarmPriority;//(apCritical, apWarning, apAdvisory, apLog)
    FAlarmEnable: Boolean;
    FDigitalAlarmValue: Boolean; //Digital Type 알람 설정 값

    FMinAlarmEnable: Boolean; //아래 변수들 사용 여부
    FMaxAlarmEnable: Boolean; //
    FMinFaultEnable: Boolean;
    FMaxFaultEnable: Boolean;

    FMinAlarmValue: double; //Fault보다 낮은 레벨
    FMaxAlarmValue: double; //
    FMinFaultValue: double;
    FMaxFaultValue: double;

    FMinAlarmDeadBand: double;
    FMaxAlarmDeadBand: double;
    FMinFaultDeadBand: double;
    FMaxFaultDeadBand: double;

    FMinAlarmDelay: integer; //mSec Delay time
    FMaxAlarmDelay: integer;
    FMinFaultDelay: integer;
    FMaxFaultDelay: integer; //Digital Type일 경우 FMaxFaultDelay를 해당 Alarm의 DelayTime으로 사용함

    FMinAlarmStartTime: TDateTime; //mSec Start time when Alarm on
    FMaxAlarmStartTime: TDateTime;
    FMinFaultStartTime: TDateTime;
    FMaxFaultStartTime: TDateTime; //Digital Type일 경우 FMaxFaultStartTime을 해당 Alarm의 StartTime으로 사용함

    FMinAlarmColor: Longint; //Alarm 발생시 표시색
    FMaxAlarmColor: Longint;
    FMinFaultColor: Longint;
    FMaxFaultColor: Longint;

    FMinAlarmBlink: Boolean; //Alarm 발생시 Blink
    FMaxAlarmBlink: Boolean;
    FMinFaultBlink: Boolean;
    FMaxFaultBlink: Boolean;

    FMinAlarmSoundEnable: Boolean; //Sound들 사용 여부
    FMaxAlarmSoundEnable: Boolean;
    FMinFaultSoundEnable: Boolean;
    FMaxFaultSoundEnable: Boolean;

    FMinAlarmSoundFilename: string; //Sound File Name
    FMaxAlarmSoundFilename: string; //
    FMinFaultSoundFilename: string;
    FMaxFaultSoundFilename: string;

    FMinAlarmNeedAck: Boolean; //알람 해제시 ACK 필요 여부
    FMaxAlarmNeedAck: Boolean;
    FMinFaultNeedAck: Boolean;
    FMaxFaultNeedAck: Boolean;

    FFormulaValueList: string; //Item간 계산 식(=''이면 Raw Item)
//    FAlarmSetType: TAlarmSetType; //알람 발생했을 경우 어느 알람인지 저장함

    //=====================//for Graph (Watch 폼에서)
    FIsDisplayTrend: Boolean;
    FIsDisplayXY: Boolean;
    FTrendChannelIndex,
    FTrendAlarmIndex,
    FTrendFaultIndex,
    FTrendYAxisIndex: integer;
    FPlotXValue: double;
    FMinValue: integer;
    FMinValue_Real: real;
    FIsDisplaySimple: Boolean;
    FYAxesMinValue: Double;
    FYAxesSpanValue: Double;
    FUseXYGraphConstant: Boolean;
    FIsDisplayTrendAlarm: Boolean;
    FIsDisplayTrendFault: Boolean;

    //=====================//for Graph (Watch Save 폼에서)
    FIsAverageValue: Boolean;
    FExcelRange: string;

    //====================//for Config Matrix
    FMatrixItemIndex,//Matrix Data일 경우 TMatrixItem Index
    FXAxisSize,      //Matrix Data일 경우 XAxis ArrayLength
    FYAxisSize,      //Matrix Data일 경우 YAxis ArrayLength
    FZAxisSize: integer; //Matrix Data일 경우 ZAxis ArrayLength

    FSensorCode: string; //Sensor 정보 및 위치를 추적하기 위해 사용됨

    //===================//DataSaveAll에서 사용
    FIsSaveItem: Boolean;//False = DB 또는 File에 저장하지 않음(모니터링만 함-통신)

    FIsSimulateMode: Boolean;
    FSimulateValue: string;
    FFormulaValueStringList: TStringList;
    FNextGridRow: Pointer;
  public
    FPCircularArray: Pointer;  //HiMECS_WathSave에서 평균값을 저장하기 위한 원형큐를 저장함

    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(var ARecord: TEngineParameterItemRecord);
    function IsMatrixData: Boolean;

    property MinAlarmStartTime: TDateTime read FMinAlarmStartTime write FMinAlarmStartTime;
    property MaxAlarmStartTime: TDateTime read FMaxAlarmStartTime write FMaxAlarmStartTime;
    property MinFaultStartTime: TDateTime read FMinFaultStartTime write FMinFaultStartTime;
    property MaxFaultStartTime: TDateTime read FMaxFaultStartTime write FMaxFaultStartTime;
    property IsSimulateMode: Boolean read FIsSimulateMode write FIsSimulateMode;
    property SimulateValue: string read FSimulateValue write FSimulateValue;
    property FormulaValueStringList: TStringList read FFormulaValueStringList write FFormulaValueStringList;
    property NextGridRow: Pointer read FNextGridRow write FNextGridRow;
  published
    property SharedName: string read FSharedName write FSharedName;
    property UserLevel: THiMECSUserLevel read FUserLevel write FUserLevel;
    property LevelIndex: integer read FLevelIndex write FLevelIndex;
    property NodeIndex: integer read FNodeIndex write FNodeIndex;
    property AbsoluteIndex: integer read FAbsoluteIndex write FAbsoluteIndex;
    property MaxValue: integer read FMaxValue write FMaxValue;
    property BlockNo: integer read FBlockNo write FBlockNo;
    property MaxValue_Real: real read FMaxValue_Real write FMaxValue_Real;
    property Contact: integer read FContact write FContact;
    property Scale: integer read FScale write FScale;
    property TagName: string read FTagName write FTagName;
    property Description: string read FDescription write FDescription;
    property Address: string read FAddress write FAddress;
    property Alarm: Boolean read FAlarm write FAlarm;
    property FCode: string read FFCode write FFCode;
    property FFUnit: string read FUnit write FUnit;
    property Value: string read FValue write FValue;
    property RadixPosition: integer read FRadixPosition write FRadixPosition;
    property MinMaxType: TValueType read FMinMaxType write FMinMaxType;
    property DisplayUnit: Boolean read FDisplayUnit write FDisplayUnit;
    property DisplayThousandSeperator: Boolean read FDisplayThousandSeperator write FDisplayThousandSeperator;
    property DisplayFormat: string read FDisplayFormat write FDisplayFormat;

    property SensorType: TSensorType read FSensorType write FSensorType;
    property ParameterCatetory: TParameterCatetory read FParameterCatetory write FParameterCatetory;
    property ParameterType: TParameterType read FParameterType write FParameterType;
    property ParameterSource: TParameterSource read FParameterSource write FParameterSource;
    //==========================================================================
    property AlarmPriority: TAlarmPriority read FAlarmPriority write FAlarmPriority;
    property MinAlarmEnable: Boolean read FMinAlarmEnable write FMinAlarmEnable default false;
    property MaxAlarmEnable: Boolean read FMaxAlarmEnable write FMaxAlarmEnable default false;
    property MinFaultEnable: Boolean read FMinFaultEnable write FMinFaultEnable default false;
    property MaxFaultEnable: Boolean read FMaxFaultEnable write FMaxFaultEnable default false;
    property MinAlarmValue: double read FMinAlarmValue write FMinAlarmValue;
    property MinFaultValue: double read FMinFaultValue write FMinFaultValue;
    property MaxAlarmValue: double read FMaxAlarmValue write FMaxAlarmValue;
    property MaxFaultValue: double read FMaxFaultValue write FMaxFaultValue;
    property MinAlarmColor: Longint read FMinAlarmColor write FMinAlarmColor default $0000FFFF;
    property MaxAlarmColor: Longint read FMaxAlarmColor write FMaxAlarmColor default $000000FF;
    property MinFaultColor: Longint read FMinFaultColor write FMinFaultColor default $00FFFF99;
    property MaxFaultColor: Longint read FMaxFaultColor write FMaxFaultColor default $00FF0000;
    property MinAlarmBlink: Boolean read FMinAlarmBlink write FMinAlarmBlink default false;
    property MaxAlarmBlink: Boolean read FMaxAlarmBlink write FMaxAlarmBlink default false;
    property MinFaultBlink: Boolean read FMinFaultBlink write FMinFaultBlink default false;
    property MaxFaultBlink: Boolean read FMaxFaultBlink write FMaxFaultBlink default false;
    property MinAlarmSoundEnable: Boolean read FMinAlarmSoundEnable write FMinAlarmSoundEnable default false;
    property MaxAlarmSoundEnable: Boolean read FMaxAlarmSoundEnable write FMaxAlarmSoundEnable default false;
    property MinFaultSoundEnable: Boolean read FMinFaultSoundEnable write FMinFaultSoundEnable default false;
    property MaxFaultSoundEnable: Boolean read FMaxFaultSoundEnable write FMaxFaultSoundEnable default false;
    property MinAlarmSoundFilename: string read FMinAlarmSoundFilename write FMinAlarmSoundFilename;
    property MaxAlarmSoundFilename: string read FMaxAlarmSoundFilename write FMaxAlarmSoundFilename;
    property MinFaultSoundFilename: string read FMinFaultSoundFilename write FMinFaultSoundFilename;
    property MaxFaultSoundFilename: string read FMaxFaultSoundFilename write FMaxFaultSoundFilename;
    property FormulaValueList: string read FFormulaValueList write FFormulaValueList;

    property IsDisplayTrend: Boolean read FIsDisplayTrend write FIsDisplayTrend default false;
    property IsDisplayXY: Boolean read FIsDisplayXY write FIsDisplayXY default false;
    property TrendChannelIndex: integer read FTrendChannelIndex write FTrendChannelIndex;
    property TrendAlarmIndex: integer read FTrendAlarmIndex write FTrendAlarmIndex;
    property TrendFaultIndex: integer read FTrendFaultIndex write FTrendFaultIndex;
    property TrendYAxisIndex: integer read FTrendYAxisIndex write FTrendYAxisIndex;
    property PlotXValue: double read FPlotXValue write FPlotXValue;
    property MinValue: integer read FMinValue write FMinValue;
    property MinValue_Real: real read FMinValue_Real write FMinValue_Real;
    property IsDisplaySimple: Boolean read FIsDisplaySimple write FIsDisplaySimple default false;
    property YAxesMinValue: double read FYAxesMinValue write FYAxesMinValue;
    property YAxesSpanValue: double read FYAxesSpanValue write FYAxesSpanValue;
    property UseXYGraphConstant: Boolean read FUseXYGraphConstant write FUseXYGraphConstant default false;
    property IsDisplayTrendAlarm: Boolean read FIsDisplayTrendAlarm write FIsDisplayTrendAlarm default false;
    property IsDisplayTrendFault: Boolean read FIsDisplayTrendFault write FIsDisplayTrendFault default false;

    //True = 모니터링 값을 평균값으로 보여 줌
    property IsAverageValue: Boolean read FIsAverageValue write FIsAverageValue;
    property AlarmLevel: integer read FAlarmLevel write FAlarmLevel;
    property FFExcelRange: string read FExcelRange write FExcelRange;

    property MatrixItemIndex: integer read FMatrixItemIndex write FMatrixItemIndex;
    property XAxisSize: integer read FXAxisSize write FXAxisSize;
    property YAxisSize: integer read FYAxisSize write FYAxisSize;
    property ZAxisSize: integer read FZAxisSize write FZAxisSize;

    property SensorCode: string read FSensorCode write FSensorCode;
    property IsSaveItem: Boolean read FIsSaveItem write FIsSaveItem;
    property AlarmEnable: Boolean read FAlarmEnable write FAlarmEnable;

    property MinAlarmDeadBand: double read FMinAlarmDeadBand write FMinAlarmDeadBand;
    property MaxAlarmDeadBand: double read FMaxAlarmDeadBand write FMaxAlarmDeadBand;
    property MinFaultDeadBand: double read FMinFaultDeadBand write FMinFaultDeadBand;
    property MaxFaultDeadBand: double read FMaxFaultDeadBand write FMaxFaultDeadBand;

    property MinAlarmDelay: integer read FMinAlarmDelay write FMinAlarmDelay;
    property MaxAlarmDelay: integer read FMaxAlarmDelay write FMaxAlarmDelay;
    property MinFaultDelay: integer read FMinFaultDelay write FMinFaultDelay;
    property MaxFaultDelay: integer read FMaxFaultDelay write FMaxFaultDelay;

    property ProjNo: string read FProjNo write FProjNo;    //AMS를 위해 추가함
    property EngNo: string read FEngNo write FEngNo; //AMS를 위해 추가함
    property DigitalAlarmValue: Boolean read FDigitalAlarmValue write FDigitalAlarmValue default true;

    property MinAlarmNeedAck: Boolean read FMinAlarmNeedAck write FMinAlarmNeedAck default false;
    property MaxAlarmNeedAck: Boolean read FMaxAlarmNeedAck write FMaxAlarmNeedAck default false;
    property MinFaultNeedAck: Boolean read FMinFaultNeedAck write FMinFaultNeedAck default false;
    property MaxFaultNeedAck: Boolean read FMaxFaultNeedAck write FMaxFaultNeedAck default false;
  end;

  TEngineParameterCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TEngineParameterItem;
    procedure SetItem(Index: Integer; const Value: TEngineParameterItem);
  public
    FEngProjNo: string;
    FEngNo: string;
    FPowerOn: Boolean;

    function AddEngineParameterItem(ASource: TEngineParameterItem): TEngineParameterItem;
    procedure AddEngineParameterCollect(ASource: TEngineParameterCollect);
    function GetUniqueParamSourceName(AIdx: integer): string;

    function  Add: TEngineParameterItem;
    function Insert(Index: Integer): TEngineParameterItem;

    property Items[Index: Integer]: TEngineParameterItem read GetItem  write SetItem; default;
    property EngProjNo: string read FEngProjNo  write FEngProjNo;
    property EngNo: string read FEngNo  write FEngNo;
    property PowerOn: Boolean read FPowerOn  write FPowerOn;
  end;

  PMatrixItem = ^TMatrixItem;
  TMatrixItem = class(TCollectionItem)
  private
    FXAxisIArray: TMatrixIArray;
    FYAxisIArray: TMatrixIArray;
    FZAxisIArray: TMatrixIArray;
    FValueIArray: TMatrixIArray;

    FXAxisFArray: TMatrixFArray;
    FYAxisFArray: TMatrixFArray;
    FZAxisFArray: TMatrixFArray;
    FValueFArray: TMatrixFArray;

    FXAxisICount: integer;
    FYAxisICount: integer;
    FZAxisICount: integer;
    FValueICount: integer;
    FXAxisFCount: integer;
    FYAxisFCount: integer;
    FZAxisFCount: integer;
    FValueFCount: integer;

    FXAxisIData: RawByteString;
    FYAxisIData: RawByteString;
    FZAxisIData: RawByteString;
    FValueIData: RawByteString;
    FXAxisFData: RawByteString;
    FYAxisFData: RawByteString;
    FZAxisFData: RawByteString;
    FValueFData: RawByteString;

    function GetXAxisIArray(AIndex: integer): TMatrixInteger;
    procedure SetXAxisIArray(AIndex: integer; AValue: TMatrixInteger);
    function GetYAxisIArray(AIndex: integer): TMatrixInteger;
    procedure SetYAxisIArray(AIndex: integer; AValue: TMatrixInteger);
    function GetZAxisIArray(AIndex: integer): TMatrixInteger;
    procedure SetZAxisIArray(AIndex: integer; AValue: TMatrixInteger);
    function GetValueIArray(AIndex: integer): TMatrixInteger;
    procedure SetValueIArray(AIndex: integer; AValue: TMatrixInteger);

    function GetXAxisFArray(AIndex: integer): TMatrixFloat;
    procedure SetXAxisFArray(AIndex: integer; AValue: TMatrixFloat);
    function GetYAxisFArray(AIndex: integer): TMatrixFloat;
    procedure SetYAxisFArray(AIndex: integer; AValue: TMatrixFloat);
    function GetZAxisFArray(AIndex: integer): TMatrixFloat;
    procedure SetZAxisFArray(AIndex: integer; AValue: TMatrixFloat);
    function GetValueFArray(AIndex: integer): TMatrixFloat;
    procedure SetValueFArray(AIndex: integer; AValue: TMatrixFloat);

    function GetXAxisIData: RawByteString;
    procedure SetXAxisIData(AValue: RawByteString);
    function GetXAxisILength: integer;
    procedure SetXAxisILength(AValue: integer);
    function GetYAxisIData: RawByteString;
    procedure SetYAxisIData(AValue: RawByteString);
    function GetYAxisILength: integer;
    procedure SetYAxisILength(AValue: integer);
    function GetZAxisIData: RawByteString;
    procedure SetZAxisIData(AValue: RawByteString);
    function GetZAxisILength: integer;
    procedure SetZAxisILength(AValue: integer);
    function GetValueIData: RawByteString;
    procedure SetValueIData(AValue: RawByteString);
    function GetValueILength: integer;
    procedure SetValueILength(AValue: integer);
    function GetXAxisFData: RawByteString;
    procedure SetXAxisFData(AValue: RawByteString);
    function GetXAxisFLength: integer;
    procedure SetXAxisFLength(AValue: integer);
    function GetYAxisFData: RawByteString;
    procedure SetYAxisFData(AValue: RawByteString);
    function GetYAxisFLength: integer;
    procedure SetYAxisFLength(AValue: integer);
    function GetZAxisFData: RawByteString;
    procedure SetZAxisFData(AValue: RawByteString);
    function GetZAxisFLength: integer;
    procedure SetZAxisFLength(AValue: integer);
    function GetValueFData: RawByteString;
    procedure SetValueFData(AValue: RawByteString);
    function GetValueFLength: integer;
    procedure SetValueFLength(AValue: integer);

  public
    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(var ARecord: TEngineParameterItemRecord);

    procedure PublicToPublished(AMatrixItem: TMatrixItem);//내부변수 데이터를 저장 가능 변수로 이동함.
    procedure PublishedToPublic(AMatrixItem: TMatrixItem);//저장된 데이터를 내부 변수로 이동함.

    procedure DynArraySaveToMatrix1Value;
    procedure LoadFromMatrix1ValueToDynArray;

    procedure DynArraySaveToMatrix2Value;
    procedure LoadFromMatrix2ValueToDynArray;

    procedure DynArraySaveToMatrix3Value;
    procedure LoadFromMatrix3ValueToDynArray;

    procedure DynArraySaveToMatrix1fValue;
    procedure LoadFromMatrix1fValueToDynArray;

    procedure DynArraySaveToMatrix2fValue;
    procedure LoadFromMatrix2fValueToDynArray;

    procedure DynArraySaveToMatrix3fValue;
    procedure LoadFromMatrix3fValueToDynArray;

    procedure DynArraySaveToValueIData;
    procedure DynArraySaveToValueFData;

    //저장이 안됨
    property XAxisIArray[AIndex: integer]: TMatrixInteger read GetXAxisIArray write SetXAxisIArray;
    property YAxisIArray[AIndex: integer]: TMatrixInteger read GetYAxisIArray write SetYAxisIArray;
    property ZAxisIArray[AIndex: integer]: TMatrixInteger read GetZAxisIArray write SetZAxisIArray;
    property ValueIArray[AIndex: integer]: TMatrixInteger read GetValueIArray write SetValueIArray;

    property XAxisFArray[AIndex: integer]: TMatrixFloat read GetXAxisFArray write SetXAxisFArray;
    property YAxisFArray[AIndex: integer]: TMatrixFloat read GetYAxisFArray write SetYAxisFArray;
    property ZAxisFArray[AIndex: integer]: TMatrixFloat read GetZAxisFArray write SetZAxisFArray;
    property ValueFArray[AIndex: integer]: TMatrixFloat read GetValueFArray write SetValueFArray;
  published
    //Base64로 저장됨
    property XAxisIData: RawByteString read GetXAxisIData write SetXAxisIData;
    property XAxisILength: integer read GetXAxisILength write SetXAxisILength;
    property YAxisIData: RawByteString read GetYAxisIData write SetYAxisIData;
    property YAxisILength: integer read GetYAxisILength write SetYAxisILength;
    property ZAxisIData: RawByteString read GetZAxisIData write SetZAxisIData;
    property ZAxisILength: integer read GetZAxisILength write SetZAxisILength;
    property ValueIData: RawByteString read GetValueIData write SetValueIData;
    property ValueILength: integer read GetValueILength write SetValueILength;
    property XAxisFData: RawByteString read GetXAxisFData write SetXAxisFData;
    property XAxisFLength: integer read GetXAxisFLength write SetXAxisFLength;
    property YAxisFData: RawByteString read GetYAxisFData write SetYAxisFData;
    property YAxisFLength: integer read GetYAxisFLength write SetYAxisFLength;
    property ZAxisFData: RawByteString read GetZAxisFData write SetZAxisFData;
    property ZAxisFLength: integer read GetZAxisFLength write SetZAxisFLength;
    property ValueFData: RawByteString read GetValueFData write SetValueFData;
    property ValueFLength: integer read GetValueFLength write SetValueFLength;
  end;

  TMatrixCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TMatrixItem;
    procedure SetItem(Index: Integer; const Value: TMatrixItem);
  public
    procedure AddMatrixItem(AMatrixItem: TMatrixItem);
    function  Add: TMatrixItem;
    function Insert(Index: Integer): TMatrixItem;
    property Items[Index: Integer]: TMatrixItem read GetItem  write SetItem; default;
  end;

implementation

{ TEngineParameter }

procedure TEngineParameter.Assign(Source: TPersistent);
var
  i: integer;
begin
  if Source is TEngineParameter then
  begin
    if Assigned(EngineParameterCollect) then
    begin
      EngineParameterCollect.Clear;

      for i := 0 to TEngineParameter(Source).EngineParameterCollect.Count - 1 do
        with EngineParameterCollect.Add do
          Assign(TEngineParameter(Source).EngineParameterCollect[i]);
    end;

    if Assigned(MatrixCollect) then
    begin
      MatrixCollect.Clear;

      for i := 0 to TEngineParameter(Source).MatrixCollect.Count - 1 do
        with MatrixCollect.Add do
          Assign(TEngineParameter(Source).MatrixCollect[i]);
    end;

    ExeName := TEngineParameter(Source).ExeName;
    ProjectFileName := TEngineParameter(Source).ProjectFileName;
    FilePath := TEngineParameter(Source).FilePath;
    AllowUserLevelWatchList := TEngineParameter(Source).AllowUserLevelWatchList;

    FormWidth := TEngineParameter(Source).FormWidth;
    FormHeight := TEngineParameter(Source).FormHeight;
    FormTop := TEngineParameter(Source).FormTop;
    FormLeft := TEngineParameter(Source).FormLeft;
    FormState := TEngineParameter(Source).FormState;
  end
  else
    inherited;
end;

constructor TEngineParameter.Create(AOwner: TComponent);
begin
  FEngineParameterCollect := TEngineParameterCollect.Create(TEngineParameterItem);
  FMatrixCollect := TMatrixCollect.Create(TMatrixItem);
end;

destructor TEngineParameter.Destroy;
begin
  inherited Destroy;
  FMatrixCollect.Free;
  FEngineParameterCollect.Free;
end;

function TEngineParameter.GetItemIndex(AEPItem: TEngineParameterItem): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to EngineParameterCollect.Count - 1 do
  begin
    if EngineParameterCollect.Items[i].FTagName = AEPItem.FTagName then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TEngineParameter.GetItemIndex(ATagName: string): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to EngineParameterCollect.Count - 1 do
  begin
    if EngineParameterCollect.Items[i].FTagName = ATagName then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TEngineParameter.GetMatrixDataIdx(XIdx, YIdx: integer;
  AMatrixItem: TMatrixItem): integer;
begin
  //AMatrixItem.
end;

function TEngineParameter.LoadFromJSONFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
begin
  inherited;

  if MatrixCollect.Count > 0 then
    MatrixPublished2Public;
end;

procedure TEngineParameter.MatrixPublished2Public;
var
  i: integer;
begin
  for i := 0 to MatrixCollect.Count - 1 do
  begin
    MatrixCollect.Items[i].PublishedToPublic(MatrixCollect.Items[i]);
  end;//for
end;

function TEngineParameter.ComparePublicMatrix(
  AParam: TEngineParameter): integer;
var
  i,j: integer;
begin
  Result := 0;

  if MatrixCollect.Count = AParam.MatrixCollect.Count then
  begin
    for i := 0 to MatrixCollect.Count - 1 do
    begin
      //배열 크기 비교
      if High(MatrixCollect.Items[i].FXAxisIArray) =
        High(AParam.FMatrixCollect.Items[i].FXAxisIArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FXAxisICount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].XAxisIArray[j].Value <>
            AParam.FMatrixCollect.Items[i].XAxisIArray[j].Value then
          begin
            Result := 1;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 100;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FXAxisFArray) =
        High(AParam.FMatrixCollect.Items[i].FXAxisFArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FXAxisFCount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].XAxisFArray[j].Value <>
            AParam.FMatrixCollect.Items[i].XAxisFArray[j].Value then
          begin
            Result := 2;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 200;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FYAxisIArray) =
        High(AParam.FMatrixCollect.Items[i].FYAxisIArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FYAxisICount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].YAxisIArray[j].Value <>
            AParam.FMatrixCollect.Items[i].YAxisIArray[j].Value then
          begin
            Result := 11;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 110;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FYAxisFArray) =
        High(AParam.FMatrixCollect.Items[i].FYAxisFArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FYAxisFCount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].YAxisFArray[j].Value <>
            AParam.FMatrixCollect.Items[i].YAxisFArray[j].Value then
          begin
            Result := 12;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 120;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FZAxisIArray) =
        High(AParam.FMatrixCollect.Items[i].FZAxisIArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FZAxisICount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].ZAxisIArray[j].Value <>
            AParam.FMatrixCollect.Items[i].ZAxisIArray[j].Value then
          begin
            Result := 21;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 210;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FZAxisFArray) =
        High(AParam.FMatrixCollect.Items[i].FZAxisFArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FZAxisFCount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].ZAxisFArray[j].Value <>
            AParam.FMatrixCollect.Items[i].ZAxisFArray[j].Value then
          begin
            Result := 22;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 220;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FValueIArray) =
        High(AParam.FMatrixCollect.Items[i].FValueIArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FValueICount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].ValueIArray[j].Value <>
            AParam.FMatrixCollect.Items[i].ValueIArray[j].Value then
          begin
            Result := 31;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 310;
        exit;
      end;

      //배열 크기 비교
      if High(MatrixCollect.Items[i].FValueFArray) =
        High(AParam.FMatrixCollect.Items[i].FValueFArray) then
      begin
        for j := 0 to MatrixCollect.Items[i].FValueFCount - 1 do
        begin//배열 내용 비교
          if MatrixCollect.Items[i].ValueFArray[j].Value <>
            AParam.FMatrixCollect.Items[i].ValueFArray[j].Value then
          begin
            Result := 32;
            exit;
          end;
        end//for
      end
      else
      begin
        Result := 320;
        exit;
      end;
    end;//for
  end
  else
    Result := 50;
end;

function TEngineParameter.ComparePublishedMatrix(AParam: TEngineParameter): integer;
var
  i: integer;
begin
  Result := 0;

  if MatrixCollect.Count = AParam.MatrixCollect.Count then
  begin
    for i := 0 to MatrixCollect.Count - 1 do
    begin
      if MatrixCollect.Items[i].XAxisIData <> AParam.FMatrixCollect.Items[i].XAxisIData then
      begin
        Result := 1;
        exit;
      end;

      if MatrixCollect.Items[i].XAxisFData <> AParam.FMatrixCollect.Items[i].XAxisFData then
      begin
        Result := 2;
        exit;
      end;

      if MatrixCollect.Items[i].XAxisILength <> AParam.FMatrixCollect.Items[i].XAxisILength then
      begin
        Result := 3;
        exit;
      end;

      if MatrixCollect.Items[i].XAxisFLength <> AParam.FMatrixCollect.Items[i].XAxisFLength then
      begin
        Result := 4;
        exit;
      end;

      if MatrixCollect.Items[i].YAxisIData <> AParam.FMatrixCollect.Items[i].YAxisIData then
      begin
        Result := 11;
        exit;
      end;

      if MatrixCollect.Items[i].YAxisFData <> AParam.FMatrixCollect.Items[i].YAxisFData then
      begin
        Result := 12;
        exit;
      end;

      if MatrixCollect.Items[i].YAxisILength <> AParam.FMatrixCollect.Items[i].YAxisILength then
      begin
        Result := 13;
        exit;
      end;

      if MatrixCollect.Items[i].YAxisFLength <> AParam.FMatrixCollect.Items[i].YAxisFLength then
      begin
        Result := 14;
        exit;
      end;

      if MatrixCollect.Items[i].ZAxisIData <> AParam.FMatrixCollect.Items[i].ZAxisIData then
      begin
        Result := 21;
        exit;
      end;

      if MatrixCollect.Items[i].ZAxisFData <> AParam.FMatrixCollect.Items[i].ZAxisFData then
      begin
        Result := 22;
        exit;
      end;

      if MatrixCollect.Items[i].ZAxisILength <> AParam.FMatrixCollect.Items[i].ZAxisILength then
      begin
        Result := 23;
        exit;
      end;

      if MatrixCollect.Items[i].ZAxisFLength <> AParam.FMatrixCollect.Items[i].ZAxisFLength then
      begin
        Result := 24;
        exit;
      end;

      if MatrixCollect.Items[i].ValueIData <> AParam.FMatrixCollect.Items[i].ValueIData then
      begin
        Result := 31;
        exit;
      end;

      if MatrixCollect.Items[i].ValueFData <> AParam.FMatrixCollect.Items[i].ValueFData then
      begin
        Result := 32;
        exit;
      end;

      if MatrixCollect.Items[i].ValueILength <> AParam.FMatrixCollect.Items[i].ValueILength then
      begin
        Result := 33;
        exit;
      end;

      if MatrixCollect.Items[i].ValueFLength <> AParam.FMatrixCollect.Items[i].ValueFLength then
      begin
        Result := 34;
        exit;
      end;
  end;//for
  end
  else
    Result := 50;
end;

function TEngineParameter.SaveToJSONFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
begin
  inherited;
end;

{ TEngineParameterCollect }

function TEngineParameterCollect.Add: TEngineParameterItem;
begin
  Result := TEngineParameterItem(inherited Add);
end;

procedure TEngineParameterCollect.AddEngineParameterCollect(
  ASource: TEngineParameterCollect);
var
  i: integer;
begin
  for i := 0 to ASource.Count - 1 do
    AddEngineParameterItem(ASource.Items[i]);
end;

function TEngineParameterCollect.AddEngineParameterItem(
  ASource: TEngineParameterItem): TEngineParameterItem;
var
  LEngineParameterItem: TEngineParameterItem;
begin
  LEngineParameterItem := Add;
  LEngineParameterItem.Assign(ASource);
  Result := LEngineParameterItem;

//  with LEngineParameterItem do
//  begin
//    SharedName := AEngineParameterItem.SharedName;
//    UserLevel := AEngineParameterItem.UserLevel;
//    LevelIndex := AEngineParameterItem.LevelIndex;
//    NodeIndex := AEngineParameterItem.NodeIndex;
//    AbsoluteIndex := AEngineParameterItem.AbsoluteIndex;
//    MaxValue := AEngineParameterItem.MaxValue;
//    BlockNo := AEngineParameterItem.BlockNo;
//    MaxValue_Real := AEngineParameterItem.MaxValue_Real;
//    Contact := AEngineParameterItem.Contact;
//    TagName := AEngineParameterItem.TagName;
//    Description := AEngineParameterItem.Description;
//    Address := AEngineParameterItem.Address;
//    Alarm := AEngineParameterItem.Alarm;
//    FCode := AEngineParameterItem.FCode;
//    FFUnit := AEngineParameterItem.FFUnit;
//    Value := AEngineParameterItem.Value;
//    RadixPosition := AEngineParameterItem.RadixPosition;
//    MinMaxType := AEngineParameterItem.MinMaxType;
//
//    SensorType := AEngineParameterItem.SensorType;
//    ParameterCatetory := AEngineParameterItem.ParameterCatetory;
//    ParameterType := AEngineParameterItem.ParameterType;
//    ParameterSource := AEngineParameterItem.ParameterSource;
//
//    MinAlarmEnable := AEngineParameterItem.MinAlarmEnable;
//    MaxAlarmEnable := AEngineParameterItem.MaxAlarmEnable;
//    MinFaultEnable := AEngineParameterItem.MinFaultEnable;
//    MaxFaultEnable := AEngineParameterItem.MaxFaultEnable;
//    MinAlarmValue := AEngineParameterItem.MinAlarmValue;
//    MinFaultValue := AEngineParameterItem.MinFaultValue;
//    MaxAlarmValue := AEngineParameterItem.MaxAlarmValue;
//    MaxFaultValue := AEngineParameterItem.MaxFaultValue;
//    MinAlarmColor := AEngineParameterItem.MinAlarmColor;
//    MaxAlarmColor := AEngineParameterItem.MaxAlarmColor;
//    MinFaultColor := AEngineParameterItem.MinFaultColor;
//    MaxFaultColor := AEngineParameterItem.MaxFaultColor;
//    MinAlarmBlink := AEngineParameterItem.MinAlarmBlink;
//    MaxAlarmBlink := AEngineParameterItem.MaxAlarmBlink;
//    MinFaultBlink := AEngineParameterItem.MinFaultBlink;
//    MaxFaultBlink := AEngineParameterItem.MaxFaultBlink;
//    MinAlarmSoundEnable := AEngineParameterItem.MinAlarmSoundEnable;
//    MaxAlarmSoundEnable := AEngineParameterItem.MaxAlarmSoundEnable;
//    MinFaultSoundEnable := AEngineParameterItem.MinFaultSoundEnable;
//    MaxFaultSoundEnable := AEngineParameterItem.MaxFaultSoundEnable;
//    MinAlarmSoundFilename := AEngineParameterItem.MinAlarmSoundFilename;
//    MaxAlarmSoundFilename := AEngineParameterItem.MaxAlarmSoundFilename;
//    MinFaultSoundFilename := AEngineParameterItem.MinFaultSoundFilename;
//    MaxFaultSoundFilename := AEngineParameterItem.MaxFaultSoundFilename;
//    FormulaValueList := AEngineParameterItem.FormulaValueList;
//
//    IsDisplayTrend := AEngineParameterItem.IsDisplayTrend;
//    IsDisplayXY := AEngineParameterItem.IsDisplayXY;
//    TrendChannelIndex := AEngineParameterItem.TrendChannelIndex;
//    TrendAlarmIndex := AEngineParameterItem.TrendAlarmIndex;
//    TrendFaultIndex := AEngineParameterItem.TrendFaultIndex;
//    TrendYAxisIndex := AEngineParameterItem.TrendYAxisIndex;
//    PlotXValue := AEngineParameterItem.PlotXValue;
//    MinValue := AEngineParameterItem.MinValue;
//    MinValue_Real := AEngineParameterItem.MinValue_Real;
//    IsDisplaySimple := AEngineParameterItem.IsDisplaySimple;
//    YAxesMinValue := AEngineParameterItem.YAxesMinValue;
//    YAxesSpanValue := AEngineParameterItem.YAxesSpanValue;
//    UseXYGraphConstant := AEngineParameterItem.UseXYGraphConstant;
//    IsDisplayTrendAlarm := AEngineParameterItem.IsDisplayTrendAlarm;
//    IsDisplayTrendFault := AEngineParameterItem.IsDisplayTrendFault;
//
//    IsAverageValue := AEngineParameterItem.IsAverageValue;
//    AlarmLevel := AEngineParameterItem.AlarmLevel;
//    FFExcelRange := AEngineParameterItem.FFExcelRange;
//
//    MatrixItemIndex := AEngineParameterItem.MatrixItemIndex;
//    XAxisSize := AEngineParameterItem.XAxisSize;
//    YAxisSize := AEngineParameterItem.YAxisSize;
//    ZAxisSize := AEngineParameterItem.ZAxisSize;
//  end;
end;

function TEngineParameterCollect.GetItem(Index: Integer): TEngineParameterItem;
begin
  Result := TEngineParameterItem(inherited Items[Index]);
end;

function TEngineParameterCollect.GetUniqueParamSourceName(
  AIdx: integer): string;
begin
  Result := ParameterSource2String(Items[AIdx].ParameterSource) + '_' +
    Items[AIdx].ProjNo + '_' + Items[AIdx].EngNo;
end;

function TEngineParameterCollect.Insert(Index: Integer): TEngineParameterItem;
begin
  Result := TEngineParameterItem(inherited Insert(Index));
end;

procedure TEngineParameterCollect.SetItem(Index: Integer;
  const Value: TEngineParameterItem);
begin
  Items[Index].Assign(Value);
end;

{ TMatrixCollect }

function TMatrixCollect.Add: TMatrixItem;
begin
  Result := TMatrixItem(inherited Add);
end;

procedure TMatrixCollect.AddMatrixItem(AMatrixItem: TMatrixItem);
begin
  with Add do
  begin
    Assign(AMatrixItem);
  end;//with
end;

function TMatrixCollect.GetItem(
  Index: Integer): TMatrixItem;
begin
  Result := TMatrixItem(inherited Items[Index]);
end;

function TMatrixCollect.Insert(Index: Integer): TMatrixItem;
begin
  Result := TMatrixItem(inherited Insert(Index));
end;

procedure TMatrixCollect.SetItem(Index: Integer;
  const Value: TMatrixItem);
begin
  Items[Index].Assign(Value);
end;

{ TMatrixItem }

procedure TMatrixItem.Assign(Source: TPersistent);
begin
  if Source is TMatrixItem then
  begin
    PublicToPublished(TMatrixItem(Source));

    XAxisIData := TMatrixItem(Source).XAxisIData;
    XAxisILength := TMatrixItem(Source).XAxisILength;
    YAxisIData := TMatrixItem(Source).YAxisIData;
    YAxisILength := TMatrixItem(Source).YAxisILength;
    ZAxisIData := TMatrixItem(Source).ZAxisIData;
    ZAxisILength := TMatrixItem(Source).ZAxisILength;
    ValueIData := TMatrixItem(Source).ValueIData;
    ValueILength := TMatrixItem(Source).ValueILength;
    XAxisFData := TMatrixItem(Source).XAxisFData;
    XAxisFLength := TMatrixItem(Source).XAxisFLength;
    YAxisFData := TMatrixItem(Source).YAxisFData;
    YAxisFLength := TMatrixItem(Source).YAxisFLength;
    ZAxisFData := TMatrixItem(Source).ZAxisFData;
    ZAxisFLength := TMatrixItem(Source).ZAxisFLength;
    ValueFData := TMatrixItem(Source).ValueFData;
    ValueFLength := TMatrixItem(Source).ValueFLength;

    PublishedToPublic(Self);
  end
  else
    inherited;
end;

{ TEngineParameterItem }

procedure TMatrixItem.AssignTo(var ARecord: TEngineParameterItemRecord);
var
  i: integer;
begin
  //DragDrop에 Rawbytestring을 전달할 수 없어 string으로 변환함
  ARecord.FMatrixItemRecord.FXAxisIData := Ansi7ToString(XAxisIData);
  ARecord.FMatrixItemRecord.FXAxisILength := XAxisILength;
  ARecord.FMatrixItemRecord.FYAxisIData := Ansi7ToString(YAxisIData);
  ARecord.FMatrixItemRecord.FYAxisILength := YAxisILength;
  ARecord.FMatrixItemRecord.FZAxisIData := Ansi7ToString(ZAxisIData);
  ARecord.FMatrixItemRecord.FZAxisILength := ZAxisILength;

  if (Length(ValueIData) <> 0) then
  begin
    for i := 0 to ValueILength - 1 do
      ARecord.FMatrixItemRecord.FValueIData[i] := ValueIArray[i].Value;
  end;

  ARecord.FMatrixItemRecord.FValueILength := ValueILength;
  ARecord.FMatrixItemRecord.FXAxisFData := Ansi7ToString(XAxisFData);
  ARecord.FMatrixItemRecord.FXAxisFLength := XAxisFLength;
  ARecord.FMatrixItemRecord.FYAxisFData := Ansi7ToString(YAxisFData);
  ARecord.FMatrixItemRecord.FYAxisFLength := YAxisFLength;
  ARecord.FMatrixItemRecord.FZAxisFData := Ansi7ToString(ZAxisFData);
  ARecord.FMatrixItemRecord.FZAxisFLength := ZAxisFLength;

  if (Length(ValueFData) <> 0) then
  begin
    for i := 0 to ValueFLength - 1 do
      ARecord.FMatrixItemRecord.FValueFData[i] := ValueFArray[i].Value;
  end;

  //ARecord.FMatrixItemRecord.FValueFData := Ansi7ToString(ValueFData);
  ARecord.FMatrixItemRecord.FValueFLength := ValueFLength;
end;

procedure TMatrixItem.DynArraySaveToMatrix1fValue;
var
  LDynArray, LDynArray2: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  //for i := Low(FXAxisFArray) to High(FXAxisFArray) do
    //LDynArray.Add(FXAxisFArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisFData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixFArray), FValueFArray);
  //for i := Low(FValueFArray) to High(FValueFArray) do
    //LDynArray2.Add(FValueFArray[i]);

  LStr := LDynArray2.SaveTo;
  ValueFData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix1Value;
var
  LDynArray, LDynArray2: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  //FXAxisIArray 배열이 계속 증가하기 때문에 주석처리함
  //for i := Low(FXAxisIArray) to High(FXAxisIArray) do
    //LDynArray.Add(FXAxisIArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisIData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixIArray), FValueIArray);
  //for i := Low(FValueIArray) to High(FValueIArray) do
    //LDynArray2.Add(FValueIArray[i]);

  LStr := LDynArray2.SaveTo;
  ValueIData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix2fValue;
var
  LDynArray, LDynArray2, LDynArray3: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  //for i := Low(FXAxisFArray) to High(FXAxisFArray) do
    //LDynArray.Add(FXAxisFArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisFData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixFArray), FYAxisFArray);
  //for i := Low(FYAxisFArray) to High(FYAxisFArray) do
    //LDynArray.Add(FYAxisFArray[i]);

  LStr := LDynArray2.SaveTo;
  YAxisFData := BinToBase64(LStr);

  LDynArray3.Init(TypeInfo(TMatrixFArray), FValueFArray);
  //for i := Low(FValueFArray) to High(FValueFArray) do
    //LDynArray2.Add(FValueFArray[i]);

  LStr := LDynArray3.SaveTo;
  ValueFData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix2Value;
var
  LDynArray, LDynArray2, LDynArray3: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  //for i := Low(FXAxisIArray) to High(FXAxisIArray) do
    //LDynArray.Add(FXAxisIArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisIData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixIArray), FYAxisIArray);
  //for i := Low(FYAxisIArray) to High(FYAxisIArray) do
    //LDynArray.Add(FYAxisIArray[i]);

  LStr := LDynArray2.SaveTo;
  YAxisIData := BinToBase64(LStr);

  LDynArray3.Init(TypeInfo(TMatrixIArray), FValueIArray);
  //for i := Low(FValueIArray) to High(FValueIArray) do
    //LDynArray2.Add(FValueIArray[i]);

  LStr := LDynArray3.SaveTo;
  ValueIData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix3fValue;
var
  LDynArray, LDynArray2, LDynArray3, LDynArray4: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  //for i := Low(FXAxisFArray) to High(FXAxisFArray) do
    //LDynArray.Add(FXAxisFArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisFData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixFArray), FYAxisFArray);
  //for i := Low(FYAxisFArray) to High(FYAxisFArray) do
    //LDynArray.Add(FYAxisFArray[i]);

  LStr := LDynArray2.SaveTo;
  YAxisFData := BinToBase64(LStr);

  LDynArray3.Init(TypeInfo(TMatrixFArray), FZAxisFArray);
  //for i := Low(FZAxisFArray) to High(FZAxisFArray) do
    //LDynArray.Add(FZAxisFArray[i]);

  LStr := LDynArray3.SaveTo;
  ZAxisFData := BinToBase64(LStr);

  LDynArray4.Init(TypeInfo(TMatrixFArray), FValueFArray);
  //for i := Low(FValueFArray) to High(FValueFArray) do
    //LDynArray2.Add(FValueFArray[i]);

  LStr := LDynArray4.SaveTo;
  ValueFData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToMatrix3Value;
var
  LDynArray, LDynArray2, LDynArray3, LDynArray4: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  //for i := Low(FXAxisIArray) to High(FXAxisIArray) do
    //LDynArray.Add(FXAxisIArray[i]);

  LStr := LDynArray.SaveTo;
  XAxisIData := BinToBase64(LStr);

  LDynArray2.Init(TypeInfo(TMatrixIArray), FYAxisIArray);
  //for i := Low(FYAxisIArray) to High(FYAxisIArray) do
    //LDynArray.Add(FYAxisIArray[i]);

  LStr := LDynArray2.SaveTo;
  YAxisIData := BinToBase64(LStr);

  LDynArray3.Init(TypeInfo(TMatrixIArray), FZAxisIArray);
  //for i := Low(FZAxisIArray) to High(FZAxisIArray) do
    //LDynArray.Add(FZAxisIArray[i]);

  LStr := LDynArray3.SaveTo;
  ZAxisIData := BinToBase64(LStr);

  LDynArray4.Init(TypeInfo(TMatrixIArray), FValueIArray);
  //for i := Low(FValueIArray) to High(FValueIArray) do
    //LDynArray2.Add(FValueIArray[i]);

  LStr := LDynArray4.SaveTo;
  ValueIData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToValueFData;
var
  LDynArray2: TDynArray;
  LStr: RawByteString;
begin
  LDynArray2.Init(TypeInfo(TMatrixFArray), FValueFArray);

  LStr := LDynArray2.SaveTo;
  ValueFData := BinToBase64(LStr);
end;

procedure TMatrixItem.DynArraySaveToValueIData;
var
  LDynArray2: TDynArray;
  LStr: RawByteString;
begin
  LDynArray2.Init(TypeInfo(TMatrixIArray), FValueIArray);

  LStr := LDynArray2.SaveTo;
  ValueIData := BinToBase64(LStr);
end;

function TMatrixItem.GetXAxisIArray(AIndex: integer): TMatrixInteger;
begin
  if AIndex <= High(FXAxisIArray) then
    Result :=FXAxisIArray[AIndex];
  //else
    //Result := TMatrix1Param(nil);
end;

function TMatrixItem.GetXAxisFArray(AIndex: integer): TMatrixFloat;
begin
  if AIndex <= High(FXAxisFArray) then
    Result := FXAxisFArray[AIndex];
end;

function TMatrixItem.GetXAxisILength: integer;
begin
  Result := FXAxisICount;
end;

function TMatrixItem.GetXAxisFLength: integer;
begin
  Result := FXAxisFCount;
end;

function TMatrixItem.GetYAxisIArray(AIndex: integer): TMatrixInteger;
begin
  Result := FYAxisIArray[AIndex];
end;

function TMatrixItem.GetYAxisFArray(AIndex: integer): TMatrixFloat;
begin
  if AIndex <= High(FYAxisFArray) then
    Result := FYAxisFArray[AIndex];
end;

function TMatrixItem.GetYAxisILength: integer;
begin
  Result := FYAxisICount;
end;

function TMatrixItem.GetYAxisFLength: integer;
begin
  Result := FYAxisFCount;
end;

function TMatrixItem.GetZAxisIArray(AIndex: integer): TMatrixInteger;
begin
  Result := FZAxisIArray[AIndex];
end;

function TMatrixItem.GetZAxisFArray(AIndex: integer): TMatrixFloat;
begin
  Result := FZAxisFArray[AIndex];
end;

function TMatrixItem.GetZAxisILength: integer;
begin
  Result := FZAxisICount;
end;

function TMatrixItem.GetZAxisFLength: integer;
begin
  Result := FZAxisFCount;
end;

function TMatrixItem.GetValueIArray(AIndex: integer): TMatrixInteger;
begin
  Result := FValueIArray[AIndex];
end;

function TMatrixItem.GetValueFArray(AIndex: integer): TMatrixFloat;
begin
  Result := FValueFArray[AIndex];
end;

function TMatrixItem.GetValueILength: integer;
begin
  Result := FValueICount;
end;

function TMatrixItem.GetValueFLength: integer;
begin
  Result := FValueFCount;
end;

procedure TMatrixItem.SetXAxisIArray(AIndex: integer;
  AValue: TMatrixInteger);
begin
  if AIndex <= High(FXAxisIArray) then
  begin
    FXAxisIArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetXAxisFArray(AIndex: integer;
  AValue: TMatrixFloat);
begin
  if AIndex <= High(FXAxisFArray) then
  begin
    FXAxisFArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetXAxisILength(AValue: integer);
begin
  if FXAxisICount <> AValue then
  begin
    FXAxisICount := AValue;
    SetLength(FXAxisIArray, FXAxisICount);
  end;
end;

procedure TMatrixItem.SetXAxisFLength(AValue: integer);
begin
  if FXAxisFCount <> AValue then
  begin
    FXAxisFCount := AValue;
    SetLength(FXAxisFArray, FXAxisFCount);
  end;
end;

procedure TMatrixItem.SetYAxisIArray(AIndex: integer;
  AValue: TMatrixInteger);
begin
  if AIndex <= High(FYAxisIArray) then
  begin
    FYAxisIArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetYAxisFArray(AIndex: integer;
  AValue: TMatrixFloat);
begin
  if AIndex <= High(FYAxisFArray) then
  begin
    FYAxisFArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetYAxisILength(AValue: integer);
begin
  if FYAxisICount <> AValue then
  begin
    FYAxisICount := AValue;
    SetLength(FYAxisIArray, FYAxisICount);
  end;
end;

procedure TMatrixItem.SetYAxisFLength(AValue: integer);
begin
  if FYAxisFCount <> AValue then
  begin
    FYAxisFCount := AValue;
    SetLength(FYAxisFArray, FYAxisFCount);
  end;
end;

procedure TMatrixItem.SetZAxisIArray(AIndex: integer;
  AValue: TMatrixInteger);
begin
  if AIndex <= High(FZAxisIArray) then
  begin
    FZAxisIArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetZAxisFArray(AIndex: integer;
  AValue: TMatrixFloat);
begin
  if AIndex <= High(FZAxisFArray) then
  begin
    FZAxisFArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetZAxisILength(AValue: integer);
begin
  if FZAxisICount <> AValue then
  begin
    FZAxisICount := AValue;
    SetLength(FZAxisIArray, FZAxisICount);
  end;
end;

procedure TMatrixItem.SetZAxisFLength(AValue: integer);
begin
  if FZAxisFCount <> AValue then
  begin
    FZAxisFCount := AValue;
    SetLength(FZAxisFArray, FZAxisFCount);
  end;
end;

procedure TMatrixItem.SetValueIArray(AIndex: integer;
  AValue: TMatrixInteger);
begin
  if AIndex <= High(FValueIArray) then
  begin
    FValueIArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetValueFArray(AIndex: integer;
  AValue: TMatrixFloat);
begin
  if AIndex <= High(FValueFArray) then
  begin
    FValueFArray[AIndex].Value := AValue.Value;
  end;
end;

procedure TMatrixItem.SetValueILength(AValue: integer);
begin
  if FValueICount <> AValue then
  begin
    FValueICount := AValue;
    SetLength(FValueIArray, FValueICount);
  end;
end;

procedure TMatrixItem.SetValueFLength(AValue: integer);
begin
  if FValueFCount <> AValue then
  begin
    FValueFCount := AValue;
    SetLength(FValueFArray, FValueFCount);
  end;
end;

function TMatrixItem.GetXAxisIData: RawByteString;
begin
  Result := FXAxisIData;
end;

function TMatrixItem.GetXAxisFData: RawByteString;
begin
  Result := FXAxisFData;
end;

function TMatrixItem.GetYAxisIData: RawByteString;
begin
  Result := FYAxisIData;
end;

function TMatrixItem.GetYAxisFData: RawByteString;
begin
  Result := FYAxisFData;
end;

function TMatrixItem.GetZAxisIData: RawByteString;
begin
  Result := FZAxisIData;
end;

function TMatrixItem.GetZAxisFData: RawByteString;
begin
  Result := FZAxisFData;
end;

function TMatrixItem.GetValueIData: RawByteString;
begin
  Result := FValueIData;
end;

function TMatrixItem.GetValueFData: RawByteString;
begin
  Result := FValueFData;
end;

procedure TMatrixItem.LoadFromMatrix1fValueToDynArray;
var
  LDynArray, LDynArray2: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisFData);
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueFData);
  LDynArray2.Init(TypeInfo(TMatrixFArray), FValueFArray);
  LDynArray2.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix1ValueToDynArray;
var
  LDynArray, LDynArray2: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisIData);
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueIData);
  LDynArray2.Init(TypeInfo(TMatrixIArray), FValueIArray);
  LDynArray2.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix2fValueToDynArray;
var
  LDynArray, LDynArray2, LDynArray3: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisFData);
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(YAxisFData);
  LDynArray2.Init(TypeInfo(TMatrixFArray), FYAxisFArray);
  LDynArray2.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueFData);
  LDynArray3.Init(TypeInfo(TMatrixFArray), FValueFArray);
  LDynArray3.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix2ValueToDynArray;
var
  LDynArray, LDynArray2, LDynArray3: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisIData);
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(YAxisIData);
  LDynArray2.Init(TypeInfo(TMatrixIArray), FYAxisIArray);
  LDynArray2.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueIData);
  LDynArray3.Init(TypeInfo(TMatrixIArray), FValueIArray);
  LDynArray3.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix3fValueToDynArray;
var
  LDynArray, LDynArray2, LDynArray3, LDynArray4: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisFData);
  LDynArray.Init(TypeInfo(TMatrixFArray), FXAxisFArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(YAxisFData);
  LDynArray2.Init(TypeInfo(TMatrixFArray), FYAxisFArray);
  LDynArray2.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ZAxisFData);
  LDynArray3.Init(TypeInfo(TMatrixFArray), FZAxisFArray);
  LDynArray3.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueFData);
  LDynArray4.Init(TypeInfo(TMatrixFArray), FValueFArray);
  LDynArray4.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.LoadFromMatrix3ValueToDynArray;
var
  LDynArray, LDynArray2, LDynArray3, LDynArray4: TDynArray;
  LStr: RawByteString;
  i: integer;
begin
  LStr := Base64ToBin(XAxisIData);
  LDynArray.Init(TypeInfo(TMatrixIArray), FXAxisIArray);
  LDynArray.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(YAxisIData);
  LDynArray2.Init(TypeInfo(TMatrixIArray), FYAxisIArray);
  LDynArray2.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ZAxisIData);
  LDynArray3.Init(TypeInfo(TMatrixIArray), FZAxisIArray);
  LDynArray3.LoadFrom(Pointer(LStr));

  LStr := Base64ToBin(ValueIData);
  LDynArray4.Init(TypeInfo(TMatrixIArray), FValueIArray);
  LDynArray4.LoadFrom(Pointer(LStr));
end;

procedure TMatrixItem.PublicToPublished(AMatrixItem: TMatrixItem);
begin
  if AMatrixItem.ZAxisFLength > 0 then
    AMatrixItem.DynArraySaveToMatrix3fValue
  else
  if AMatrixItem.ZAxisILength > 0 then
    AMatrixItem.DynArraySaveToMatrix3Value
  else
  if AMatrixItem.YAxisFLength > 0 then
    AMatrixItem.DynArraySaveToMatrix2fValue
  else
  if AMatrixItem.YAxisILength > 0 then
    AMatrixItem.DynArraySaveToMatrix2Value
  else
  if AMatrixItem.XAxisFLength > 0 then
    AMatrixItem.DynArraySaveToMatrix1fValue
  else
  if AMatrixItem.XAxisILength > 0 then
    AMatrixItem.DynArraySaveToMatrix1Value;
end;

procedure TMatrixItem.PublishedToPublic(AMatrixItem: TMatrixItem);
begin
  if ZAxisFLength > 0 then
    LoadFromMatrix3fValueToDynArray
  else
  if ZAxisILength > 0 then
    LoadFromMatrix3ValueToDynArray
  else
  if YAxisFLength > 0 then
    LoadFromMatrix2fValueToDynArray
  else
  if YAxisILength > 0 then
    LoadFromMatrix2ValueToDynArray
  else
  if XAxisFLength > 0 then
    LoadFromMatrix1fValueToDynArray
  else
  if XAxisILength > 0 then
    LoadFromMatrix1ValueToDynArray;
end;

procedure TMatrixItem.SetXAxisIData(AValue: RawByteString);
begin
  FXAxisIData := AValue;
end;

procedure TMatrixItem.SetXAxisFData(AValue: RawByteString);
begin
  FXAxisFData := AValue;
end;

procedure TMatrixItem.SetYAxisIData(AValue: RawByteString);
begin
  FYAxisIData := AValue;
end;

procedure TMatrixItem.SetYAxisFData(AValue: RawByteString);
begin
  FYAxisFData := AValue;
end;

procedure TMatrixItem.SetZAxisIData(AValue: RawByteString);
begin
  FZAxisIData := AValue;
end;

procedure TMatrixItem.SetZAxisFData(AValue: RawByteString);
begin
  FZAxisFData := AValue;
end;

procedure TMatrixItem.SetValueIData(AValue: RawByteString);
begin
  FValueIData := AValue;
end;

procedure TMatrixItem.SetValueFData(AValue: RawByteString);
begin
  FValueFData := AValue;
end;

//TEngineParameterItem

procedure TEngineParameterItem.Assign(Source: TPersistent);
begin
  if Source is TEngineParameterItem then
  begin
    SharedName := TEngineParameterItem(Source).SharedName;
    UserLevel := TEngineParameterItem(Source).UserLevel;
    LevelIndex := TEngineParameterItem(Source).LevelIndex;
    NodeIndex := TEngineParameterItem(Source).NodeIndex;
    AbsoluteIndex := TEngineParameterItem(Source).AbsoluteIndex;
    MaxValue := TEngineParameterItem(Source).MaxValue;
    BlockNo := TEngineParameterItem(Source).BlockNo;
    MaxValue_Real := TEngineParameterItem(Source).MaxValue_Real;
    Contact := TEngineParameterItem(Source).Contact;
    TagName := TEngineParameterItem(Source).TagName;
    Description := TEngineParameterItem(Source).Description;
    Address := TEngineParameterItem(Source).Address;
    Alarm := TEngineParameterItem(Source).Alarm;
    FCode := TEngineParameterItem(Source).FCode;
    FFUnit := TEngineParameterItem(Source).FFUnit;
    Value := TEngineParameterItem(Source).Value;
    ProjNo := TEngineParameterItem(Source).ProjNo;
    EngNo := TEngineParameterItem(Source).EngNo;
    RadixPosition := TEngineParameterItem(Source).RadixPosition;
    MinMaxType := TEngineParameterItem(Source).MinMaxType;
    DisplayUnit := TEngineParameterItem(Source).DisplayUnit;
    DisplayThousandSeperator := TEngineParameterItem(Source).DisplayThousandSeperator;
    DisplayFormat := TEngineParameterItem(Source).DisplayFormat;

    SensorType := TEngineParameterItem(Source).SensorType;
    ParameterCatetory := TEngineParameterItem(Source).ParameterCatetory;
    ParameterType := TEngineParameterItem(Source).ParameterType;
    ParameterSource := TEngineParameterItem(Source).ParameterSource;

    AlarmEnable := TEngineParameterItem(Source).AlarmEnable;
    MinAlarmEnable := TEngineParameterItem(Source).MinAlarmEnable;
    MaxAlarmEnable := TEngineParameterItem(Source).MaxAlarmEnable;
    MinFaultEnable := TEngineParameterItem(Source).MinFaultEnable;
    MaxFaultEnable := TEngineParameterItem(Source).MaxFaultEnable;
    MinAlarmValue := TEngineParameterItem(Source).MinAlarmValue;
    MinFaultValue := TEngineParameterItem(Source).MinFaultValue;
    MaxAlarmValue := TEngineParameterItem(Source).MaxAlarmValue;
    MaxFaultValue := TEngineParameterItem(Source).MaxFaultValue;
    MinAlarmColor := TEngineParameterItem(Source).MinAlarmColor;
    MaxAlarmColor := TEngineParameterItem(Source).MaxAlarmColor;
    MinFaultColor := TEngineParameterItem(Source).MinFaultColor;
    MaxFaultColor := TEngineParameterItem(Source).MaxFaultColor;
    MinAlarmBlink := TEngineParameterItem(Source).MinAlarmBlink;
    MaxAlarmBlink := TEngineParameterItem(Source).MaxAlarmBlink;
    MinFaultBlink := TEngineParameterItem(Source).MinFaultBlink;
    MaxFaultBlink := TEngineParameterItem(Source).MaxFaultBlink;
    MinAlarmSoundEnable := TEngineParameterItem(Source).MinAlarmSoundEnable;
    MaxAlarmSoundEnable := TEngineParameterItem(Source).MaxAlarmSoundEnable;
    MinFaultSoundEnable := TEngineParameterItem(Source).MinFaultSoundEnable;
    MaxFaultSoundEnable := TEngineParameterItem(Source).MaxFaultSoundEnable;
    MinAlarmSoundFilename := TEngineParameterItem(Source).MinAlarmSoundFilename;
    MaxAlarmSoundFilename := TEngineParameterItem(Source).MaxAlarmSoundFilename;
    MinFaultSoundFilename := TEngineParameterItem(Source).MinFaultSoundFilename;
    MaxFaultSoundFilename := TEngineParameterItem(Source).MaxFaultSoundFilename;
    FormulaValueList := TEngineParameterItem(Source).FormulaValueList;

    IsDisplayTrend := TEngineParameterItem(Source).IsDisplayTrend;
    IsDisplayXY := TEngineParameterItem(Source).IsDisplayXY;
    TrendChannelIndex := TEngineParameterItem(Source).TrendChannelIndex;
    TrendAlarmIndex := TEngineParameterItem(Source).TrendAlarmIndex;
    TrendFaultIndex := TEngineParameterItem(Source).TrendFaultIndex;
    TrendYAxisIndex := TEngineParameterItem(Source).TrendYAxisIndex;
    PlotXValue := TEngineParameterItem(Source).PlotXValue;
    MinValue := TEngineParameterItem(Source).MinValue;
    MinValue_Real := TEngineParameterItem(Source).MinValue_Real;
    IsDisplaySimple := TEngineParameterItem(Source).IsDisplaySimple;
    YAxesMinValue := TEngineParameterItem(Source).YAxesMinValue;
    YAxesSpanValue := TEngineParameterItem(Source).YAxesSpanValue;
    UseXYGraphConstant := TEngineParameterItem(Source).UseXYGraphConstant;
    IsDisplayTrendAlarm := TEngineParameterItem(Source).IsDisplayTrendAlarm;
    IsDisplayTrendFault := TEngineParameterItem(Source).IsDisplayTrendFault;

    IsAverageValue := TEngineParameterItem(Source).IsAverageValue;
    AlarmLevel := TEngineParameterItem(Source).AlarmLevel;
    FFExcelRange := TEngineParameterItem(Source).FFExcelRange;

    MatrixItemIndex := TEngineParameterItem(Source).MatrixItemIndex;
    XAxisSize := TEngineParameterItem(Source).XAxisSize;
    YAxisSize := TEngineParameterItem(Source).YAxisSize;
    ZAxisSize := TEngineParameterItem(Source).ZAxisSize;
  end
  else
    inherited;
end;

procedure TEngineParameterItem.AssignTo(
  var ARecord: TEngineParameterItemRecord);
begin
    ARecord.FSharedName := SharedName;
    ARecord.FUserLevel := UserLevel;
    ARecord.FLevelIndex := LevelIndex;
    ARecord.FNodeIndex := NodeIndex;
    ARecord.FAbsoluteIndex := AbsoluteIndex;
    ARecord.FMaxValue := MaxValue;
    ARecord.FBlockNo := BlockNo;
    ARecord.FMaxValue_Real := MaxValue_Real;
    ARecord.FContact := Contact;
    ARecord.FTagName := TagName;
    ARecord.FDescription := Description;
    ARecord.FAddress := Address;
    ARecord.FAlarm := Alarm;
    ARecord.FFCode := FCode;
    ARecord.FUnit := FFUnit;
    ARecord.FValue := Value;
    ARecord.FProjNo := ProjNo;
    ARecord.FEngNo := EngNo;
    ARecord.FMinMaxType := MinMaxType;
    ARecord.FRadixPosition := RadixPosition;
    ARecord.FDisplayUnit := DisplayUnit;
    ARecord.FDisplayThousandSeperator := DisplayThousandSeperator;
    ARecord.FDisplayFormat := DisplayFormat;

    ARecord.FSensorType := SensorType;
    ARecord.FParameterCatetory := ParameterCatetory;
    ARecord.FParameterType := ParameterType;
    ARecord.FParameterSource := ParameterSource;

    ARecord.FAlarmEnable := AlarmEnable;
    ARecord.FMinAlarmEnable := MinAlarmEnable;
    ARecord.FMaxAlarmEnable := MaxAlarmEnable;
    ARecord.FMinFaultEnable := MinFaultEnable;
    ARecord.FMaxFaultEnable := MaxFaultEnable;
    ARecord.FMinAlarmValue := MinAlarmValue;
    ARecord.FMinFaultValue := MinFaultValue;
    ARecord.FMaxAlarmValue := MaxAlarmValue;
    ARecord.FMaxFaultValue := MaxFaultValue;
    ARecord.FMinAlarmColor := MinAlarmColor;
    ARecord.FMaxAlarmColor := MaxAlarmColor;
    ARecord.FMinFaultColor := MinFaultColor;
    ARecord.FMaxFaultColor := MaxFaultColor;
    ARecord.FMinAlarmBlink := MinAlarmBlink;
    ARecord.FMaxAlarmBlink := MaxAlarmBlink;
    ARecord.FMinFaultBlink := MinFaultBlink;
    ARecord.FMaxFaultBlink := MaxFaultBlink;
    ARecord.FMinAlarmSoundEnable := MinAlarmSoundEnable;
    ARecord.FMaxAlarmSoundEnable := MaxAlarmSoundEnable;
    ARecord.FMinFaultSoundEnable := MinFaultSoundEnable;
    ARecord.FMaxFaultSoundEnable := MaxFaultSoundEnable;
    ARecord.FMinAlarmSoundFilename := MinAlarmSoundFilename;
    ARecord.FMaxAlarmSoundFilename := MaxAlarmSoundFilename;
    ARecord.FMinFaultSoundFilename := MinFaultSoundFilename;
    ARecord.FMaxFaultSoundFilename := MaxFaultSoundFilename;
    ARecord.FFormulaValueList := FormulaValueList;

    ARecord.FIsDisplayTrend := IsDisplayTrend;
    ARecord.FIsDisplayXY := IsDisplayXY;
    ARecord.FTrendChannelIndex := TrendChannelIndex;
    ARecord.FTrendAlarmIndex := TrendAlarmIndex;
    ARecord.FTrendFaultIndex := TrendFaultIndex;
    ARecord.FTrendYAxisIndex := TrendYAxisIndex;
    ARecord.FPlotXValue := PlotXValue;
    ARecord.FMinValue := MinValue;
    ARecord.FMinValue_Real := MinValue_Real;
    ARecord.FIsDisplaySimple := IsDisplaySimple;
    ARecord.FYAxesMinValue := YAxesMinValue;
    ARecord.FYAxesSpanValue := YAxesSpanValue;
    ARecord.FUseXYGraphConstant := UseXYGraphConstant;
    ARecord.FIsDisplayTrendAlarm := IsDisplayTrendAlarm;
    ARecord.FIsDisplayTrendFault := IsDisplayTrendFault;

    ARecord.FIsAverageValue := IsAverageValue;
    ARecord.FAlarmLevel := AlarmLevel;
    ARecord.FExcelRange := FFExcelRange;

    ARecord.FMatrixItemIndex := MatrixItemIndex;
    ARecord.FXAxisSize := XAxisSize;
    ARecord.FYAxisSize := YAxisSize;
    ARecord.FZAxisSize := ZAxisSize;
end;

function TEngineParameterItem.IsMatrixData: Boolean;
begin
  Result := (ParameterType in TMatrixTypes);
end;

{ TEngineParameterItemRecord }

procedure TEngineParameterItemRecord.AssignTo(
  var AEPItemRecord: TEngineParameterItemRecord);
begin
  AEPItemRecord.FUserLevel := FUserLevel;
  AEPItemRecord.FAlarmLevel := FAlarmLevel;
  AEPItemRecord.FLevelIndex := FLevelIndex;
  AEPItemRecord.FNodeIndex := FNodeIndex;
  AEPItemRecord.FAbsoluteIndex := FAbsoluteIndex;
  AEPItemRecord.FMaxValue := FMaxValue;
  AEPItemRecord.FBlockNo := FBlockNo;
  AEPItemRecord.FContact := FContact;
  AEPItemRecord.FMaxValue_Real := FMaxValue_real;
  AEPItemRecord.FValue := FValue;
  AEPItemRecord.FProjNo := FProjNo;
  AEPItemRecord.FEngNo := FEngNo;
  AEPItemRecord.FSharedName := FSharedName;
  AEPItemRecord.FTagName := FTagName;
  AEPItemRecord.FDescription := FDescription;
  AEPItemRecord.FAddress := FAddress;
  AEPItemRecord.FFCode := FFCode;
  AEPItemRecord.FUnit := FUnit;
  AEPItemRecord.FMinMaxType := FMinMaxType; //mmtInteger, mmtReal
  AEPItemRecord.FAlarm := FAlarm;
  AEPItemRecord.FRadixPosition := FRadixPosition;
  AEPItemRecord.FDisplayUnit := FDisplayUnit;
  AEPItemRecord.FDisplayThousandSeperator := FDisplayThousandSeperator;
  AEPItemRecord.FDisplayFormat := FDisplayFormat;

  AEPItemRecord.FSensorType := FSensorType;
  AEPItemRecord.FParameterCatetory := FParameterCatetory;
  AEPItemRecord.FParameterType := FParameterType;
  AEPItemRecord.FParameterSource := FParameterSource;
  //==================================================
  //AEPItemRecord FSelectFaultValue: integer;//0:not used, 1: original, 2: this

  AEPItemRecord.FAlarmEnable := FAlarmEnable;

  AEPItemRecord.FMinAlarmEnable := FMinAlarmEnable;
  AEPItemRecord.FMaxAlarmEnable := FMaxAlarmEnable;
  AEPItemRecord.FMinFaultEnable := FMinFaultEnable;
  AEPItemRecord.FMaxFaultEnable := FMaxFaultEnable;

  AEPItemRecord.FMinAlarmValue := FMinAlarmValue;
  AEPItemRecord.FMaxAlarmValue := FMaxAlarmValue;
  AEPItemRecord.FMinFaultValue := FMinFaultValue;
  AEPItemRecord.FMaxFaultValue := FMaxFaultValue;

  AEPItemRecord.FMinAlarmColor := FMinAlarmColor;
  AEPItemRecord.FMaxAlarmColor := FMaxAlarmColor;
  AEPItemRecord.FMinFaultColor := FMinFaultColor;
  AEPItemRecord.FMaxFaultColor := FMaxFaultColor;

  AEPItemRecord.FMinAlarmBlink := FMinAlarmBlink;
  AEPItemRecord.FMaxAlarmBlink := FMaxAlarmBlink;
  AEPItemRecord.FMinFaultBlink := FMinFaultBlink;
  AEPItemRecord.FMaxFaultBlink := FMaxFaultBlink;

  AEPItemRecord.FMinAlarmSoundEnable := FMinAlarmSoundEnable;
  AEPItemRecord.FMaxAlarmSoundEnable := FMaxAlarmSoundEnable;
  AEPItemRecord.FMinFaultSoundEnable := FMinFaultSoundEnable;
  AEPItemRecord.FMaxFaultSoundEnable := FMaxFaultSoundEnable;

  AEPItemRecord.FMinAlarmSoundFilename := FMinAlarmSoundFilename;
  AEPItemRecord.FMaxAlarmSoundFilename := FMaxAlarmSoundFilename;
  AEPItemRecord.FMinFaultSoundFilename := FMinFaultSoundFilename;
  AEPItemRecord.FMaxFaultSoundFilename := FMaxFaultSoundFilename;

  AEPItemRecord.FFormulaValueList := FFormulaValueList;

  //=====================//for Graph (Watch 폼에서
  AEPItemRecord.FIsDisplayTrend := FIsDisplayTrend;
  AEPItemRecord.FIsDisplayXY := FIsDisplayXY;
  AEPItemRecord.FTrendChannelIndex := FTrendChannelIndex;
  AEPItemRecord.FTrendChannelIndex := FTrendAlarmIndex;
  AEPItemRecord.FTrendFaultIndex := FTrendFaultIndex;
  AEPItemRecord.FTrendYAxisIndex := FTrendYAxisIndex;
  AEPItemRecord.FPlotXValue := FPlotXValue;
  AEPItemRecord.FMinValue := FMinValue;
  AEPItemRecord.FMinValue_Real := FMinValue_Real;
  AEPItemRecord.FIsDisplaySimple := FIsDisplaySimple;
  AEPItemRecord.FYAxesMinValue := FYAxesMinValue;
  AEPItemRecord.FYAxesSpanValue := FYAxesSpanValue;
  AEPItemRecord.FUseXYGraphConstant := FUseXYGraphConstant;
  AEPItemRecord.FIsDisplayTrendAlarm := FIsDisplayTrendAlarm;
  AEPItemRecord.FIsDisplayTrendFault := FIsDisplayTrendFault;

  //FAllowUserLevelWatchList: THiMECSUserLevel; //watch list에서 파일 오픈시 허용 가능한 레벨
  AEPItemRecord.FIsAverageValue := FIsAverageValue;
  AEPItemRecord.FExcelRange := FExcelRange;

  AEPItemRecord.FMatrixItemIndex := FMatrixItemIndex;
  AEPItemRecord.FXAxisSize := FXAxisSize;
  AEPItemRecord.FYAxisSize := FYAxisSize;
  AEPItemRecord.FZAxisSize := FZAxisSize;

//  AEPItemRecord.FKbdShiftState := FKbdShiftState;
//  AEPItemRecord.FParamDragCopyMode := FParamDragCopyMode;
end;

procedure TEngineParameterItemRecord.AssignToMatrixItem(
  var AMItem: TMatrixItem);
var
  i: integer;
  LMInteger: TMatrixInteger;
  LMFloat: TMatrixFloat;
begin
  if FParameterType in TMatrixTypes then
  begin
    //string을 Rawbytestring으로 변환함
    AMItem.XAxisIData := StringToAnsi7(FMatrixItemRecord.FXAxisIData);
    AMItem.XAxisILength := FMatrixItemRecord.FXAxisILength;
    AMItem.YAxisIData := StringToAnsi7(FMatrixItemRecord.FYAxisIData);
    AMItem.YAxisILength := FMatrixItemRecord.FYAxisILength;
    AMItem.ZAxisIData := StringToAnsi7(FMatrixItemRecord.FZAxisIData);
    AMItem.ZAxisILength := FMatrixItemRecord.FZAxisILength;

    //AMItem.ValueIArray에 값을 넣기 전에 AMItem.ValueILength 값이 설정 되어야 함.
    AMItem.ValueILength := FMatrixItemRecord.FValueILength;

    for i := 0 to FMatrixItemRecord.FValueILength - 1 do
    begin
      LMInteger.Value := FMatrixItemRecord.FValueIData[i];
      AMItem.ValueIArray[i] := LMInteger;
    end;

    AMItem.DynArraySaveToValueIData;
    //AMItem.ValueIData := StringToAnsi7(LStr);

    AMItem.XAxisFData := StringToAnsi7(FMatrixItemRecord.FXAxisFData);
    AMItem.XAxisFLength := FMatrixItemRecord.FXAxisFLength;
    AMItem.YAxisFData := StringToAnsi7(FMatrixItemRecord.FYAxisFData);
    AMItem.YAxisFLength := FMatrixItemRecord.FYAxisFLength;
    AMItem.ZAxisFData := StringToAnsi7(FMatrixItemRecord.FZAxisFData);
    AMItem.ZAxisFLength := FMatrixItemRecord.FZAxisFLength;
    //AMItem.ValueFData := StringToAnsi7(FMatrixItemRecord.FValueFData);
    AMItem.ValueFLength := FMatrixItemRecord.FValueFLength;

    for i := 0 to FMatrixItemRecord.FValueFLength - 1 do
    begin
      LMFloat.Value := FMatrixItemRecord.FValueFData[i];
      AMItem.ValueFArray[i] := LMFloat;
    end;

    AMItem.DynArraySaveToValueFData;
  end;

  AMItem.PublishedToPublic(AMItem);

end;

procedure TEngineParameterItemRecord.AssignToParamItem(
  var AEPItem: TEngineParameterItem);
begin
  AEPItem.UserLevel := FUserLevel;
  AEPItem.AlarmLevel := FAlarmLevel;
  AEPItem.LevelIndex := FLevelIndex;
  AEPItem.NodeIndex := FNodeIndex;
  AEPItem.AbsoluteIndex := FAbsoluteIndex;
  AEPItem.MaxValue := FMaxValue;
  AEPItem.BlockNo := FBlockNo;
  AEPItem.Contact := FContact;
  AEPItem.MaxValue_Real := FMaxValue_real;
  AEPItem.Value := FValue;
  AEPItem.SharedName := FSharedName;
  AEPItem.TagName := FTagName;
  AEPItem.Description := FDescription;
  AEPItem.Address := FAddress;
  AEPItem.FCode := FFCode;
  AEPItem.FFUnit := FUnit;
  AEPItem.MinMaxType := FMinMaxType; //mmtInteger, mmtReal
  AEPItem.Alarm := FAlarm;
  AEPItem.RadixPosition := FRadixPosition;
  AEPItem.DisplayUnit := FDisplayUnit;
  AEPItem.DisplayThousandSeperator := FDisplayThousandSeperator;
  AEPItem.FDisplayFormat := FDisplayFormat;
  AEPItem.ProjNo := FProjNo;
  AEPItem.EngNo := FEngNo;

  AEPItem.SensorType := FSensorType;
  AEPItem.ParameterCatetory := FParameterCatetory;
  AEPItem.ParameterType := FParameterType;
  AEPItem.ParameterSource := FParameterSource;
  //==================================================
  //AEPItem FSelectFaultValue: integer;//0:not used, 1: original, 2: this
  AEPItem.AlarmEnable := FAlarmEnable;

  AEPItem.MinAlarmEnable := FMinAlarmEnable;
  AEPItem.MaxAlarmEnable := FMaxAlarmEnable;
  AEPItem.MinFaultEnable := FMinFaultEnable;
  AEPItem.MaxFaultEnable := FMaxFaultEnable;

  AEPItem.MinAlarmValue := FMinAlarmValue;
  AEPItem.MaxAlarmValue := FMaxAlarmValue;
  AEPItem.MinFaultValue := FMinFaultValue;
  AEPItem.MaxFaultValue := FMaxFaultValue;

  AEPItem.MinAlarmColor := FMinAlarmColor;
  AEPItem.MaxAlarmColor := FMaxAlarmColor;
  AEPItem.MinFaultColor := FMinFaultColor;
  AEPItem.MaxFaultColor := FMaxFaultColor;

  AEPItem.MinAlarmBlink := FMinAlarmBlink;
  AEPItem.MaxAlarmBlink := FMaxAlarmBlink;
  AEPItem.MinFaultBlink := FMinFaultBlink;
  AEPItem.MaxFaultBlink := FMaxFaultBlink;

  AEPItem.MinAlarmSoundEnable := FMinAlarmSoundEnable;
  AEPItem.MaxAlarmSoundEnable := FMaxAlarmSoundEnable;
  AEPItem.MinFaultSoundEnable := FMinFaultSoundEnable;
  AEPItem.MaxFaultSoundEnable := FMaxFaultSoundEnable;

  AEPItem.MinAlarmSoundFilename := FMinAlarmSoundFilename;
  AEPItem.MaxAlarmSoundFilename := FMaxAlarmSoundFilename;
  AEPItem.MinFaultSoundFilename := FMinFaultSoundFilename;
  AEPItem.MaxFaultSoundFilename := FMaxFaultSoundFilename;

  AEPItem.FormulaValueList := FFormulaValueList;

  //=====================//for Graph (Watch 폼에서
  AEPItem.IsDisplayTrend := FIsDisplayTrend;
  AEPItem.IsDisplayXY := FIsDisplayXY;
  AEPItem.TrendChannelIndex := FTrendChannelIndex;
  AEPItem.TrendChannelIndex := FTrendAlarmIndex;
  AEPItem.TrendFaultIndex := FTrendFaultIndex;
  AEPItem.TrendYAxisIndex := FTrendYAxisIndex;
  AEPItem.PlotXValue := FPlotXValue;
  AEPItem.MinValue := FMinValue;
  AEPItem.MinValue_Real := FMinValue_Real;
  AEPItem.IsDisplaySimple := FIsDisplaySimple;
  AEPItem.YAxesMinValue := FYAxesMinValue;
  AEPItem.YAxesSpanValue := FYAxesSpanValue;
  AEPItem.UseXYGraphConstant := FUseXYGraphConstant;
  AEPItem.IsDisplayTrendAlarm := FIsDisplayTrendAlarm;
  AEPItem.IsDisplayTrendFault := FIsDisplayTrendFault;

  //FAllowUserLevelWatchList: THiMECSUserLevel; //watch list에서 파일 오픈시 허용 가능한 레벨
  AEPItem.IsAverageValue := FIsAverageValue;
  AEPItem.FFExcelRange := FExcelRange;

  AEPItem.MatrixItemIndex := FMatrixItemIndex;
  AEPItem.XAxisSize := FXAxisSize;
  AEPItem.YAxisSize := FYAxisSize;
  AEPItem.ZAxisSize := FZAxisSize;
  //FProjectFileName;
  //==========Form State
  //FFormWidth,
  //FFormHeight,
  //FFormTop,
  //FFormLeft: integer;
  //FFormState: TpjhWindowState;

  //FMatrixItemRecord: TMatrixItemRecord;
//  FKbdShiftState: TShiftState;
//  FParamDragCopyMode: TParamDragCopyMode;
end;

end.

unit EngineParameterClass2;

interface

uses classes, HiMECSConst;

type
  TEngineParameterCollect2 = class;
  TEngineParameterItem2 = class;

  TEngineParameter2 = class(TObject)
  private
    FEngineParameterCollect: TEngineParameterCollect2;
    FFilePath: string;//
    FExeName: string;
    FAllowUserLevelWatchList: THiMECSUserLevel; //watch list에서 파일 오픈시 허용 가능한 레벨
    //==========Form State
    FFormWidth,
    FFormHeight,
    FFormTop,
    FFormLeft: integer;
    FFormState: TpjhWindowState;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    function GetItemIndex(AEPItem: TEngineParameterItem2): integer;
    function SaveToFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
    class function LoadFromFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): TEngineParameter2;
  published
    property EngineParameterCollect: TEngineParameterCollect2 read FEngineParameterCollect write FEngineParameterCollect;
    property ExeName: string read FExeName write FExeName;
    property FilePath: string read FFilePath write FFilePath;
    property AllowUserLevelWatchList: THiMECSUserLevel read FAllowUserLevelWatchList write FAllowUserLevelWatchList;

    property FormWidth: integer read FFormWidth write FFormWidth;
    property FormHeight: integer read FFormHeight write FFormHeight;
    property FormTop: integer read FFormTop write FFormTop;
    property FormLeft: integer read FFormLeft write FFormLeft;
    property FormState: TpjhWindowState read FFormState write FFormState;
  end;

  PEngineParameterItem = ^TEngineParameterItem2;
  TEngineParameterItem2 = class(TCollectionItem)
  private
    FUserLevel: THiMECSUserLevel;
    FAlarmLevel,
    FLevelIndex,
    FNodeIndex,
    FAbsoluteIndex,
    FMaxValue,
    FContact //1: A 접점, 2: B 접점
    : integer;
    FMaxValue_Real: real; //avat의 경우 real값이 옴.
    FSharedName,
    FTagName,
    FDescription,
    FAddress,
    FFCode,
    FUnit,
    FValue: string;

    FMinMaxType: TValueType; //mmtInteger, mmtReal

    FAlarm: Boolean;
    FRadixPosition: integer;//소수점 위치 = 0이면 정수, 1이면 0.1 ...

    FSensorType: TSensorType;
    FParameterCatetory: TParameterCatetory;
    FParameterType: TParameterType;
    FParameterSource: TParameterSource;
    //==================================================
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

    FMinAlarmSoundFilename: string; //Sound File Name
    FMaxAlarmSoundFilename: string; //
    FMinFaultSoundFilename: string;
    FMaxFaultSoundFilename: string;

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
  published
    property SharedName: string read FSharedName write FSharedName;
    property UserLevel: THiMECSUserLevel read FUserLevel write FUserLevel;
    property LevelIndex: integer read FLevelIndex write FLevelIndex;
    property NodeIndex: integer read FNodeIndex write FNodeIndex;
    property AbsoluteIndex: integer read FAbsoluteIndex write FAbsoluteIndex;
    property MaxValue: integer read FMaxValue write FMaxValue;
    property MaxValue_Real: real read FMaxValue_Real write FMaxValue_Real;
    property Contact: integer read FContact write FContact;
    property TagName: string read FTagName write FTagName;
    property Description: string read FDescription write FDescription;
    property Address: string read FAddress write FAddress;
    property Alarm: Boolean read FAlarm write FAlarm;
    property FCode: string read FFCode write FFCode;
    property FFUnit: string read FUnit write FUnit;
    property Value: string read FValue write FValue;
    property RadixPosition: integer read FRadixPosition write FRadixPosition;
    property MinMaxType: TValueType read FMinMaxType write FMinMaxType;

    property SensorType: TSensorType read FSensorType write FSensorType;
    property ParameterCatetory: TParameterCatetory read FParameterCatetory write FParameterCatetory;
    property ParameterType: TParameterType read FParameterType write FParameterType;
    property ParameterSource: TParameterSource read FParameterSource write FParameterSource;
    //==========================================================================
    property MinAlarmEnable: Boolean read FMinAlarmEnable write FMinAlarmEnable;
    property MaxAlarmEnable: Boolean read FMaxAlarmEnable write FMaxAlarmEnable;
    property MinFaultEnable: Boolean read FMinFaultEnable write FMinFaultEnable;
    property MaxFaultEnable: Boolean read FMaxFaultEnable write FMaxFaultEnable;
    property MinAlarmValue: double read FMinAlarmValue write FMinAlarmValue;
    property MinFaultValue: double read FMinFaultValue write FMinFaultValue;
    property MaxAlarmValue: double read FMaxAlarmValue write FMaxAlarmValue;
    property MaxFaultValue: double read FMaxFaultValue write FMaxFaultValue;
    property MinAlarmColor: Longint read FMinAlarmColor write FMinAlarmColor;
    property MaxAlarmColor: Longint read FMaxAlarmColor write FMaxAlarmColor;
    property MinFaultColor: Longint read FMinFaultColor write FMinFaultColor;
    property MaxFaultColor: Longint read FMaxFaultColor write FMaxFaultColor;
    property MinAlarmBlink: Boolean read FMinAlarmBlink write FMinAlarmBlink;
    property MaxAlarmBlink: Boolean read FMaxAlarmBlink write FMaxAlarmBlink;
    property MinFaultBlink: Boolean read FMinFaultBlink write FMinFaultBlink;
    property MaxFaultBlink: Boolean read FMaxFaultBlink write FMaxFaultBlink;
    property MinAlarmSoundEnable: Boolean read FMinAlarmSoundEnable write FMinAlarmSoundEnable;
    property MaxAlarmSoundEnable: Boolean read FMaxAlarmSoundEnable write FMaxAlarmSoundEnable;
    property MinFaultSoundEnable: Boolean read FMinFaultSoundEnable write FMinFaultSoundEnable;
    property MaxFaultSoundEnable: Boolean read FMaxFaultSoundEnable write FMaxFaultSoundEnable;
    property MinAlarmSoundFilename: string read FMinAlarmSoundFilename write FMinAlarmSoundFilename;
    property MaxAlarmSoundFilename: string read FMaxAlarmSoundFilename write FMaxAlarmSoundFilename;
    property MinFaultSoundFilename: string read FMinFaultSoundFilename write FMinFaultSoundFilename;
    property MaxFaultSoundFilename: string read FMaxFaultSoundFilename write FMaxFaultSoundFilename;

    property IsDisplayTrend: Boolean read FIsDisplayTrend write FIsDisplayTrend;
    property IsDisplayXY: Boolean read FIsDisplayXY write FIsDisplayXY;
    property TrendChannelIndex: integer read FTrendChannelIndex write FTrendChannelIndex;
    property TrendAlarmIndex: integer read FTrendAlarmIndex write FTrendAlarmIndex;
    property TrendFaultIndex: integer read FTrendFaultIndex write FTrendFaultIndex;
    property TrendYAxisIndex: integer read FTrendYAxisIndex write FTrendYAxisIndex;
    property PlotXValue: double read FPlotXValue write FPlotXValue;
    property MinValue: integer read FMinValue write FMinValue;
    property MinValue_Real: real read FMinValue_Real write FMinValue_Real;
    property IsDisplaySimple: Boolean read FIsDisplaySimple write FIsDisplaySimple;
    property YAxesMinValue: double read FYAxesMinValue write FYAxesMinValue;
    property YAxesSpanValue: double read FYAxesSpanValue write FYAxesSpanValue;
    property UseXYGraphConstant: Boolean read FUseXYGraphConstant write FUseXYGraphConstant;
    property IsDisplayTrendAlarm: Boolean read FIsDisplayTrendAlarm write FIsDisplayTrendAlarm;
    property IsDisplayTrendFault: Boolean read FIsDisplayTrendFault write FIsDisplayTrendFault;

    property IsAverageValue: Boolean read FIsAverageValue write FIsAverageValue;
    property AlarmLevel: integer read FAlarmLevel write FAlarmLevel;
    property FFExcelRange: string read FExcelRange write FExcelRange;
  end;

  TEngineParameterCollect2 = class(TCollection)
  private
    function GetItem(Index: Integer): TEngineParameterItem2;
    procedure SetItem(Index: Integer; const Value: TEngineParameterItem2);
  public
    function  Add: TEngineParameterItem2;
    function Insert(Index: Integer): TEngineParameterItem2;
    property Items[Index: Integer]: TEngineParameterItem2 read GetItem  write SetItem; default;
  end;

implementation

uses XmlDoc, XmlSerial;

{ TEngineParameter }

constructor TEngineParameter2.Create(AOwner: TComponent);
begin
  FEngineParameterCollect := TEngineParameterCollect2.Create(TEngineParameterItem2);
end;

destructor TEngineParameter2.Destroy;
begin
  inherited Destroy;
  FEngineParameterCollect.Free;
end;

function TEngineParameter2.GetItemIndex(AEPItem: TEngineParameterItem2): integer;
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

class function TEngineParameter2.LoadFromFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): TEngineParameter2;
var
  lSerialize : TXmlSerializer<TEngineParameter2>;
  lOwner : TComponent;
  lDoc   : TxmlDocument;
begin
  lOwner := TComponent.Create(nil);  // Required to make TXmlDocument work!
  try
    lDoc := TXmlDocument.Create(lOwner);  // will be freed with lOwner.Free
    lDoc.LoadFromFile(AFileName);
    lSerialize := TXmlSerializer<TEngineParameter2>.Create;
    try
      result := lSerialize.Deserialize(lDoc);
    finally
      lSerialize.Free;
    end;
  finally
    lOwner.Free;
  end;
end;

function TEngineParameter2.SaveToFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  lSerialize : TXmlSerializer<TEngineParameter2>;
  lOwner : TComponent;
  lDoc   : TxmlDocument;
begin
  lOwner := TComponent.Create(nil);  // Required to make TXmlDocument work!
  try
    lDoc := TXmlDocument.Create(lOwner);  // will be freed with lOwner.Free
    lSerialize := TXmlSerializer<TEngineParameter2>.Create;
    try
      lSerialize.Serialize(lDoc,Self);
      lDoc.SaveToFile(AFileName);
    finally
      lSerialize.Free;
    end;
  finally
    lOwner.Free;
  end;
end;

{ TEngineParameterCollect2 }

function TEngineParameterCollect2.Add: TEngineParameterItem2;
begin
  Result := TEngineParameterItem2(inherited Add);
end;

function TEngineParameterCollect2.GetItem(Index: Integer): TEngineParameterItem2;
begin
  Result := TEngineParameterItem2(inherited Items[Index]);
end;

function TEngineParameterCollect2.Insert(Index: Integer): TEngineParameterItem2;
begin
  Result := TEngineParameterItem2(inherited Insert(Index));
end;

procedure TEngineParameterCollect2.SetItem(Index: Integer;
  const Value: TEngineParameterItem2);
begin
  Items[Index].Assign(Value);
end;

end.

unit ConfigOptionClass;

interface

uses classes, BaseConfigCollect, HiMECSConst, GpCommandLineParser, Generics.Legacy;

type
  TWatchCommandLineOption = class
    FConfigFileName,
    FWatchListFileName,
    FDummyFormHandle: string;
    FAutoExecute,
    FAlarmMode,
    FMDIChildMode,
    FIsDisplayTrend,
    FIsDisplaySimple: Boolean;
    FUserLevel: integer;
  public
    [CLPName('p'), CLPLongName('param'), CLPDescription('param file name'), CLPDefault('')]//, '<path>'
    property WatchListFileName: string read FWatchListFileName write FWatchListFileName;
    [CLPName('c'), CLPLongName('ConfigFile'), CLPDescription('Config File Name'), CLPDefault('')]
    property ConfigFileName: string read FConfigFileName write FConfigFileName;
    [CLPName('a'), CLPLongName('AutoExcute', 'Auto'), CLPDescription('Enable autotest mode.')]
    property AutoExecute: boolean read FAutoExecute write FAutoExecute;
    [CLPName('m'), CLPLongName('MDIChildMode', 'MDI'), CLPDescription('Enable MDI Child mode.')]
    property MDIChildMode: boolean read FMDIChildMode write FMDIChildMode;
    [CLPName('r'), CLPLongName('AlarmMode', 'Alarm'), CLPDescription('Enable Alarm Mode.')]
    property AlarmMode: boolean read FAlarmMode write FAlarmMode;
    [CLPLongName('DisplayTrend', 'Trend'), CLPDescription('Display Trend Sheet When Start.')]
    property IsDisplayTrend: boolean read FIsDisplayTrend write FIsDisplayTrend;
    [CLPLongName('DisplaySimple', 'Simple'), CLPDescription('Display Simple Sheet When Start.')]
    property IsDisplaySimple: boolean read FIsDisplaySimple write FIsDisplaySimple;
    [CLPName('d'), CLPDescription('Dummy Handle'), CLPDefault('')]//'<days>'
    property DummyFormHandle: string read FDummyFormHandle write FDummyFormHandle;
    [CLPName('u'), CLPDescription('User Level'), CLPDefault('0')]//'<days>'
    property UserLevel: integer read FUserLevel write FUserLevel;
  end;

  TConfigOptionCollect = class;
  TConfigOptionItem = class;

  TMQServerTopicItem = class(TCollectionItem)
  private
    FTopicName: string;
  published
    property TopicName: string read FTopicName write FTopicName;
  end;

  TMQServerTopicCollect<T: TMQServerTopicItem> = class(Generics.Legacy.TCollection<T>)
  end;

  TConfigOption = class(TpjhBase)
  private
    FConfigOptionCollect: TConfigOptionCollect;
    FMQServerTopicCollect: TMQServerTopicCollect<TMQServerTopicItem>;

    FModbusFileName: string;
    FDefaultSoundFileName: string;
    FAverageSize: integer; //평균을 위한 배열 size

    FNameFontSize,
    FValueFontSize: integer; //Display font size

    FSelectAlarmValue: integer;//0:not used, 1: original, 2: this
    FSelDisplayInterval: integer;//0: By Event, 1: By Timer
    FDisplayInterval: integer; //값을 화면에 표시하는 Timer Intervel
    FAliveSendInterval: integer;

    FMinAlarmValue: double; //Fault보다 낮은 레벨
    FMaxAlarmValue: double; //Fault보다 낮은 레벨
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

    FViewAvgValue: Boolean;
    FSubWatchClose: Boolean;//프로그램 종료시에 sub watch list 종료 여부
    FZoomToFitTrend: Boolean; //Trend 표시 될때마다 ZoomtoFit 실행 여부
    FRingBufferSize: LongWord;
    FFormCaption: string;//Watch2 Form Caption
    FEngParamEncrypt: Boolean;//Engine Parameter file Encryption
    FEngParamFileFormat: integer; //0: XML, 1: JSON
    FMonDataSource: integer; //0: By IPC, 1: By DB, 2: By MQ

    FMQServerIP,
    FMQServerPort,
    FMQServerTopic,
    FMQServerUserId,
    FMQServerPasswd: string;
    FWatchListFileName,
    FConfigFileName: string;
    FDisplayAverageValue: Boolean;
  public
    FDisplayAverageValueChanged,
    FMQServerIPChanged,
    FMQServerPortChanged,
    FMQServerTopicChanged,
    FWatchListFileNameChanged,
    FAverageSizeChanged: Boolean;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure InitValueChanged;
    procedure CheckValueChanged(AOldValue: TConfigOption);
    procedure SetTopic2StrList(out AList: TStringList);
  published
    property ConfigOptionCollect: TConfigOptionCollect read FConfigOptionCollect write FConfigOptionCollect;
    property MQServerTopicCollect: TMQServerTopicCollect<TMQServerTopicItem> read FMQServerTopicCollect write FMQServerTopicCollect;

    property FormCaption: string read FFormCaption write FFormCaption;
    property ModbusFileName: string read FModbusFileName write FModbusFileName;
    property DefaultSoundFileName: string read FDefaultSoundFileName write FDefaultSoundFileName;
    property AverageSize: integer read FAverageSize write FAverageSize;
    property NameFontSize: integer read FNameFontSize write FNameFontSize;
    property ValueFontSize: integer read FValueFontSize write FValueFontSize;
    property SelDisplayInterval: integer read FSelDisplayInterval write FSelDisplayInterval;
    property DisplayInterval: integer read FDisplayInterval write FDisplayInterval;
    property AliveSendInterval: integer read FAliveSendInterval write FAliveSendInterval;

    property SelectAlarmValue: integer read FSelectAlarmValue write FSelectAlarmValue;
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
    property ViewAvgValue: Boolean read FViewAvgValue write FViewAvgValue;
    property SubWatchClose: Boolean read FSubWatchClose write FSubWatchClose;
    property ZoomToFitTrend: Boolean read FZoomToFitTrend write FZoomToFitTrend;
    property RingBufferSize: LongWord read FRingBufferSize write FRingBufferSize;
    property EngParamEncrypt: Boolean read FEngParamEncrypt write FEngParamEncrypt;
    property EngParamFileFormat: Integer read FEngParamFileFormat write FEngParamFileFormat;
    property MonDataSource: Integer read FMonDataSource write FMonDataSource;

    property MQServerIP : string read FMQServerIP write FMQServerIP;
    property MQServerPort : string read FMQServerPort write FMQServerPort;
    property MQServerTopic : string read FMQServerTopic write FMQServerTopic;
    property MQServerUserId : string read FMQServerUserId write FMQServerUserId;
    property MQServerPasswd : string read FMQServerPasswd write FMQServerPasswd;

    property WatchListFileName : string read FWatchListFileName write FWatchListFileName;
    property ConfigFileName : string read FConfigFileName write FConfigFileName;
    //Items에 Avg 보여줌
    property DisplayAverageValue : Boolean read FDisplayAverageValue write FDisplayAverageValue;
  end;

  TConfigOptionItem = class(TCollectionItem)
  private
  published
    //property PartName: string read FPartName write FPartName;
  end;

  TConfigOptionCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TConfigOptionItem;
    procedure SetItem(Index: Integer; const Value: TConfigOptionItem);
  public
    function  Add: TConfigOptionItem;
    function Insert(Index: Integer): TConfigOptionItem;
    property Items[Index: Integer]: TConfigOptionItem read GetItem  write SetItem; default;
  end;

implementation

{ TInternalCombustionEngine }

procedure TConfigOption.CheckValueChanged(AOldValue: TConfigOption);
begin
  FDisplayAverageValueChanged := DisplayAverageValue <> AOldValue.DisplayAverageValue;
  FMQServerIPChanged := MQServerIP <> AOldValue.MQServerIP;
  FMQServerPortChanged := MQServerPort <> AOldValue.MQServerPort;
//  FMQServerTopicChanged := MQServerTopic <> AOldValue.MQServerTopic;
  FWatchListFileNameChanged := WatchListFileName <> AOldValue.WatchListFileName;
  FAverageSizeChanged := AverageSize <> AOldValue.AverageSize;
end;

constructor TConfigOption.Create(AOwner: TComponent);
begin
  FConfigOptionCollect := TConfigOptionCollect.Create(TConfigOptionItem);
  FMQServerTopicCollect := TMQServerTopicCollect<TMQServerTopicItem>.Create;
end;

destructor TConfigOption.Destroy;
begin
  inherited Destroy;

  FMQServerTopicCollect.Free;
  FConfigOptionCollect.Free;
end;

procedure TConfigOption.InitValueChanged;
begin
  FDisplayAverageValueChanged := False;
  FMQServerIPChanged := False;
  FMQServerPortChanged := False;
  FMQServerTopicChanged := False;
  FWatchListFileNameChanged := False;
  FAverageSizeChanged := False;
end;

procedure TConfigOption.SetTopic2StrList(out AList: TStringList);
var
  i: integer;
begin
  for i := 0 to FMQServerTopicCollect.Count - 1 do
    AList.Add(FMQServerTopicCollect.Items[i].TopicName);
end;

{ TConfigOptionCollect }

function TConfigOptionCollect.Add: TConfigOptionItem;
begin
  Result := TConfigOptionItem(inherited Add);
end;

function TConfigOptionCollect.GetItem(Index: Integer): TConfigOptionItem;
begin
  Result := TConfigOptionItem(inherited Items[Index]);
end;

function TConfigOptionCollect.Insert(Index: Integer): TConfigOptionItem;
begin
  Result := TConfigOptionItem(inherited Insert(Index));
end;

procedure TConfigOptionCollect.SetItem(Index: Integer; const Value: TConfigOptionItem);
begin
  Items[Index].Assign(Value);
end;

end.

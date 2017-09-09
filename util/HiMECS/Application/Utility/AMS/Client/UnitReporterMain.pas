unit UnitReporterMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.AppEvnts, DropTarget, DragDropText,
  AdvOfficeStatusBar, AdvOfficeStatusBarStylers, CalcExpress, DragDrop,
  DropSource, JvDialogs, Vcl.ImgList, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  iXYPlot, iComponent, iVCLComponent, iCustomComponent, iPlotComponent, iPlot,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl, NxCells,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, JvExComCtrls, JvComCtrls, JvStatusBar,
  Generics.Collections, OtlCommon, OtlComm, System.SyncObjs, OtlContainerObserver,
  AdvOfficePager, UnitFrameIPCMonitorAll, TimerPool, HiMECSConst,
  EngineParameterClass, WatchConst2, DragDropRecord, mORMot, mORMotHttpClient, Data.DB,
  UnitAlarmConfigClass, UnitAlarmConfig, UnitAlarmConst, UnitEngParamConfig,
  NxCollection, AdvSmoothPanel, AdvSmoothExpanderPanel,
  cyMathParser, AeroButtons, AdvOfficeButtons, AdvGroupBox, JvExControls,
  JvLabel, CurvyControls, DateUtils, UnitFrameWatchGrid, UnitInterfaceHTTPManager,
  UnitAlarmReportInterface, UnitAlarmListConfigEdit, UnitFrameAlarmConfigGrid,
  UnitAlarmReportCallBackInterface, SynCommons, UnitFrameCommServer, JwsclFirewall,
  UnitWinFireWallManage, UnitSTOMPClass, UnitWorker4OmniMsgQ;

const
  MSG_RESULT_PROCESS = WM_USER + 1000;
  DefaultPassPhrase = 'DefaultPassPhrase';
  MY_SERVICE_ROOT_NAME = 'root';
  SERVER_ROOT_NAME = 'root';
  AMSREPORTER_PORTNO = '706';
  //DefaultConfigFileName = 'DefaultAlarm.config';
  DefaultEncryption = False;
  DefaultAlarmListCellColor = clWhite;

type
  TChgNotifyRecord = packed record
    FUniqueEngine: string;
    FSendUrl: string;
  end;

  //SQLite3에서 제공하는 데이터 타입
  TSQLParamType = (sptNull, sptBlob, sptReal, sptInteger, sptText);
  TSQLParamDict = TDictionary<string, TSQLParamType>;

  TServiceAMSReportCB = class(TInterfacedObject, IAlarmReportCallBack)
    //==========================================================================
    //IAlarmReportCallBack
    //==========================================================================
    function AlarmConfigChangedPerEngine(UniqueEngine: RawUTF8; SenderUrl: string): Boolean;
  end;

  TFormAlarmList = class(TForm)
    PageControl1: TAdvOfficePager;
    ItemsTabSheet: TAdvOfficePage;
    JvStatusBar1: TJvStatusBar;
    Label4: TLabel;
    EnableAlphaCB: TCheckBox;
    JvTrackBar1: TJvTrackBar;
    StayOnTopCB: TCheckBox;
    ImageList1: TImageList;
    JvSaveDialog1: TJvSaveDialog;
    JvOpenDialog1: TJvOpenDialog;
    EngParamSource2: TDropTextSource;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    DropTextTarget1: TDropTextTarget;
    ApplicationEvents1: TApplicationEvents;
    WatchListPopup: TPopupMenu;
    Items1: TMenuItem;
    AddtoCalculated1: TMenuItem;
    N5: TMenuItem;
    LoadWatchListFromFile1: TMenuItem;
    SaveWatchLittoNewName1: TMenuItem;
    N3: TMenuItem;
    DeleteItem1: TMenuItem;
    N10: TMenuItem;
    Properties1: TMenuItem;
    AlarmHistoryTabSheet: TAdvOfficePage;
    AlarmListGrid: TNextGrid;
    IssueTime: TNxTextColumn;
    EngNo: TNxTextColumn;
    Desc: TNxTextColumn;
    AlarmType: TNxTextColumn;
    AlarmMessage: TNxTextColumn;
    Priority: TNxTextColumn;
    AlarmHistoryPopup: TPopupMenu;
    Config2: TMenuItem;
    N2: TMenuItem;
    DeleteItem2: TMenuItem;
    SetAlarmEnable1: TMenuItem;
    SetAlarmDisable1: TMenuItem;
    N1: TMenuItem;
    LoadAlarmDataFromDB1: TMenuItem;
    N4: TMenuItem;
    ClearAllDB1: TMenuItem;
    ReleaseTime: TNxTextColumn;
    est1: TMenuItem;
    Timer1: TTimer;
    cyMathParser1: TcyMathParser;
    ImageList32x32: TImageList;
    NxFlipPanel1: TNxFlipPanel;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel6: TJvLabel;
    CurvyPanel2: TCurvyPanel;
    Label1: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    cb_engProjNo: TComboBox;
    CurvyPanel3: TCurvyPanel;
    AeroButton1: TAeroButton;
    AeroButton4: TAeroButton;
    IPCMonitorAll1: TFrameIPCMonitor;
    FWG: TFrameWatchGrid;
    SetValueTo1: TMenuItem;
    SetSimulateMode1: TMenuItem;
    ReleaseSimulateMode1: TMenuItem;
    ReleaseSimulateModeAll1: TMenuItem;
    N6: TMenuItem;
    AlarmConfigTabSheet: TAdvOfficePage;
    FACG: TFrame1;
    AlarmValue: TNxTextColumn;
    ImageList16x16: TImageList;
    Ack: TNxImageColumn;
    AckTime: TNxTextColumn;
    AlarmConfigPopup: TPopupMenu;
    AlarmListConfig1: TMenuItem;
    GetAlarmConfigListFromDB1: TMenuItem;
    N7: TMenuItem;
    UserId: TNxTextColumn;
    RestServerSheet: TAdvOfficePage;
    FCS: TFrameCommServer;
    ShowCalculatedListCount1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EnableAlphaCBClick(Sender: TObject);
    procedure JvTrackBar1Change(Sender: TObject);
    procedure StayOnTopCBClick(Sender: TObject);
    procedure SaveWatchLittoNewName1Click(Sender: TObject);
    procedure LoadWatchListFromFile1Click(Sender: TObject);
    procedure Config2Click(Sender: TObject);
    procedure SetAlarmEnable1Click(Sender: TObject);
    procedure SetAlarmDisable1Click(Sender: TObject);
    procedure LoadAlarmDataFromDB1Click(Sender: TObject);
    procedure ClearAllDB1Click(Sender: TObject);
    procedure est1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AckChange(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure AeroButton4Click(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure AlarmListConfig1Click(Sender: TObject);
    procedure DeleteItem1Click(Sender: TObject);
    procedure AlarmListGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure SetValueTo1Click(Sender: TObject);
    procedure SetSimulateMode1Click(Sender: TObject);
    procedure ReleaseSimulateMode1Click(Sender: TObject);
    procedure ReleaseSimulateModeAll1Click(Sender: TObject);
    procedure AddtoCalculated1Click(Sender: TObject);
    procedure FWGNextGrid1CustomDrawCell(Sender: TObject; ACol, ARow: Integer;
      CellRect: TRect; CellState: TCellState);
    procedure GetAlarmConfigListFromDB1Click(Sender: TObject);
    procedure ShowCalculatedListCount1Click(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
//    FCalculatedItemTimerHandle: integer; //Calculated Item display용 Timer Handle
    FEngineParameterTarget: TEngineParameterDataFormat;
    FEngParamSource: TEngineParameterDataFormat;
    FEngineParameterItemRecord: TEngineParameterItemRecord; //Save폼에 값 전달시 사용
    FMousePoint: TPoint;
    FFilePath,                       //파일을 저장할 경로
    FWatchListFileName: string;

    FAlarmConfig : TAlarmConfig; //알람 설정 리스트
    FAlarmListRecord: TAlarmListRecord; //발생한 알람 정보 레코드
    //발생한 알람 중 해제가 되지 않은 알람 리스트(Object에 AlarmListGrid의 Row Pointer가 저장됨)
    ////UserId_Category_ProjNo_EngNo_TagName_AlarmType이 저장됨
    FAlarmStrList: TStringList;
    //UserId_CatCode_ProjNo_EngNo_TagName_AlarmType이 저장 됨(동일한 Alarm을 두명 이상이 설정했을때 필요함)
    FAlarmStrListPerUser: TStringList;
    //발생한 알람 중 해제가 되지 않은 알람 Config List(AlarmListGrid의 Row[i].data에 TAlarmConfigItem Pointer가 저장됨)
    FAlarmHistoryCollect: TAlarmConfigCollect;
    //본 프로그램이 Sensor Data를  Monitoring 하는 Engine List
    //Key: ProjNo + ';' + EngNo  = HiMECSConst.GetUniqueEngName()
    FMonitoringEngineList: TMonEngInfoDict;

    FAlarmSetDoing: Boolean;
    FFirst: Boolean;

    //엔진별 알람 설정 리스트(ProjNo_EngNo_TagName_AlarmType)
    FAlarmConfigDict: TAlarmConfigDict;

//    FModel: TSQLModel;
//    FHTTPClient: TSQLRestClientURI;
    FHTTPClient: TmORMotHTTPClient;
    FJwsclFirewall: TPJHJwsclFirewall;

    FResponseQueue   : TOmniMessageQueue;
    FResponseObserver: TOmniContainerWindowsMessageObserver;
    FWorker          : TThread;
    FpjhSTOMPClass: TpjhSTOMPClass;

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WMDisplayMessage(var Msg: TMessage); message WM_DISPLAYMESSAGE;
    procedure WorkerResult(var msg: TMessage); message MSG_RESULT_PROCESS;
    procedure StartServer;
    procedure ProcessResults;
    procedure StartWorker;
    procedure StopWorker;

    procedure CheckAlarmFromEngineParameterConfig(AEPIndex: integer);
    procedure CheckAlarmFromAlarmConfig(AEPIndex: integer);
    function IsAlarm(AAlarmSetType: TAlarmSetType; ASensorValue, ASetValue: Double): Boolean;
    //AUniqueEngine = ProjNo;EngNo
    function IsEngineRunning(AUniqueEngine: string): Boolean;

    //AConfigSource: 0 = FromAlarmConfig, 1 = FromEngineParameterConfig
    procedure AddAlarm2List(AParameterIndex: integer; ASetType: TAlarmSetType;
      AConfigSource: integer=1; AAlarmConfigItem: TAlarmConfigItem=nil );
    function AddData2AlarmListMap(AParameterIndex: integer;
      AUniqueTagName, AAlarmDesc: string; ASetType: TAlarmSetType): TAlarmListRecord; overload;
    function AddData2AlarmListMap(AParameterIndex: integer;
      AUniqueTagName: string; AAlarmConfigItem: TAlarmConfigItem; AColor: TColor): integer; overload;
    procedure UpdateAlarmAckTime2DB(AAlarmConfigItem: TAlarmConfigItem);
    procedure UpdateAlarmOutTime2DB(AAlarmConfigItem: TAlarmConfigItem);
    function AddAlarmItem2AlarmListGrid(AUniqueTagName: string;AAlarmConfigItem: TAlarmConfigItem; AColor: TColor): TRow;
    procedure DisplayAlarm2ItemGrid(APIndex: integer; AColor: TColor);
    procedure AlarmAcknowledge(ARow: integer);
    procedure SendAlarm2Server(AAlarmRecord: TAlarmListRecord);
    procedure SendReleaseAlarm2Server(AAlarmRecord: TAlarmListRecord);
    procedure NotifyAlarmConfigChanged2Server(AIsUseMQ: Boolean = False);

    function GetUniqueTagName(APIndex: integer; ASetType: TAlarmSetType): string;
    procedure GridAlarmUpdate(ARow: integer; ATime: TDateTime);
    procedure ReleaseAlarm4Analog(AEPIndex: integer; AUniqueTagName: string; AAlarmStrList: TStringList);
    procedure UpdateGridRowIndexFromRecord(AIsInc: Boolean);
    function GetNeedAckSetValue(AEPIndex: integer; ASetType: TAlarmSetType): Boolean;

    procedure CheckDigital(APIndex: integer; AUniqueTagName: string); overload;
    procedure CheckMinFault(APIndex: integer; AUniqueTagName: string; ADelay: integer; AAlarmMessage: string = ''); overload;
    procedure CheckMaxFault(APIndex: integer; AUniqueTagName: string; ADelay: integer; AAlarmMessage: string = ''); overload;
    procedure CheckMinWarn(APIndex: integer; AUniqueTagName: string; ADelay: integer; AAlarmMessage: string = ''); overload;
    procedure CheckMaxWarn(APIndex: integer; AUniqueTagName: string; ADelay: integer; AAlarmMessage: string = ''); overload;

    procedure CheckDigital(APIndex: integer; AUniqueTagName: string; AAlarmConfigItem: TAlarmConfigItem); overload;
    procedure CheckMinFault(APIndex: integer; AUniqueTagName: string; AAlarmConfigItem: TAlarmConfigItem); overload;
    procedure CheckMaxFault(APIndex: integer; AUniqueTagName: string; AAlarmConfigItem: TAlarmConfigItem); overload;
    procedure CheckMinWarn(APIndex: integer; AUniqueTagName: string; AAlarmConfigItem: TAlarmConfigItem); overload;
    procedure CheckMaxWarn(APIndex: integer; AUniqueTagName: string; AAlarmConfigItem: TAlarmConfigItem); overload;

    //알람 설정 DB(HITEMS_ALARM_CONFIG)로 부터 해당 엔진(AEngNo)의 설정값을 가져와
    //FAlarmConfigDict에 저장함
    //EngineParameter의 ProjNo+EngNo에 있는 것만 가져옴
    procedure GetAlarmConfigListFromDB;
    //반드시 GetAlarmConfigListFromDB 함수 호출 이후에 실행 되어야 함.(AlarmHistotyTableName을 알아야 하기 때문임)
    procedure GetAlarmHistoryFromDB4NoReleased;
    procedure FillInAlarmConfigList2Grid;
    procedure FillInAlarmHistoryList2Grid(ACollect: TAlarmConfigCollect);
    procedure UpdateAlarmOutTime2HistoryDB4UnConfigAlarm(AAlarmHistoryList: TAlarmConfigCollect);
    procedure AlarmConfigItem2AlarmListRecord(AAlarmConfigItem: TAlarmConfigItem;
      var AlarmListRecord: TAlarmListRecord);
    procedure ClearAlarmConfigDic;
    procedure SetMonitoringTableListFromAlarmConfig;
    procedure MonEngInfoDictClear;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TAlarmConfigF);
    procedure LoadConfigForm2Object(AForm: TAlarmConfigF);
    procedure SetConfig;
    procedure ApplyUI;
    procedure LoadAlarmListConfigFromFile(AFileName: string = '');
    procedure LoadAlarmListConfig2Form(AForm: TAlarmListConfigF);
    procedure LoadAlarmListConfigForm2Object(AForm: TAlarmListConfigF);
    procedure SetAlarmListConfig;
    procedure DisplayAlarmConfig2Grid(ACollect: TAlarmConfigCollect; AGrid: TNextGrid);

    function CheckDBFile(AFileName: string): Boolean;
    procedure DB_Create_Table;
    function DB_Alarm_insert(ATableName: string; ARecord: TAlarmListRecord): integer;//ALevel: integer; ATime: TDateTime; ATagname, AAlarmDesc : string): integer;
    function DB_Alarm_insert_Zeos(ARecord: TAlarmListRecord): integer;
    procedure DB_Alarm_Update(ASeqNo: integer; ATime: TDateTime);
    procedure DB_Alarm_Release_Update_Zeos(ASeqNo: integer; ATime: TDateTime);
    procedure DB_Alarm_Acked_Update_Zeos(ASeqNo: integer; ATime: TDateTime);
    procedure DB_Alarm_Select(ASql: string; AParamList: TSQLParamDict; AValueList: TStringList);
    procedure DB_Alarm_Delect(ASql: string; AParamList: TSQLParamDict);
    procedure LoadAlarmDataFromDB;
    procedure ClearAllDB;
    procedure TestDBInsert;
    ///////////////////////////////////////////////////////////////////////////
    procedure DeleteEngineParamterFromGrid(AIndex: integer);

    //데이터 한건 당 한번씩 Trigger됨
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer); virtual;
    procedure WatchValue2Screen_Calculated(Name: string; AValue: string;
                                AEPIndex: integer); virtual;
    //데이터를 모두 읽은 후 한번만 Trigger됨
    procedure WatchValue2Screen_Analog2;
    procedure WatchValue2Screen_Digital(Name: string; AValue: string;
                                AEPIndex: integer); virtual;
    procedure SetAlarmEnable(AEnable: Boolean);

    function GetFromDay(ADate: TDateTime): TDateTime;
    function GetToDay(ADate: TDateTime): TDateTime;
    procedure SaveWatchList(AFileName: string; ASaveWatchListFolder: Boolean = True);
    procedure LoadWatchListFromFile(AFileName: string);
    procedure FillInItemsGridFromEP;
    procedure FillInItemValueFromEP;
    procedure AddMonitoringEngInfo2List(AProjNo, AEngNo: string);

    //프로그램이 실행되고 있는 컴의 TCP Port가 사용 가능한지 확인
    //Alarm Config Changed Notify를 수신하기 위해서는 TCP Open 되어야 함
    function CheckPortOpenOnFireWall(APortNo: integer): Boolean;
  protected
    FSettings : TConfigSettings;
    FGetItemValueFromDBHandle: integer;
    FServerConnected: Boolean;

    procedure OnGetItemValueFromDB(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
  public
    FProgramMode: integer; //0: Report Mode, 1: User Monitor Mode
    FDisplayMessage: string;
    FCommandQueue    : TOmniMessageQueue;

    procedure InitAlarmList;
    procedure InitVar;
    procedure DestroyVar;
    procedure InitSTOMP;
    procedure DestroySTOMP;

    procedure HttpStart;
    procedure HttpStop;
    procedure ServerLogIn;
    procedure ServerLogOut;

    procedure DisplayMessage(msg: string);
    procedure AlarmConfigChangedPerEngine(AUniqueEngine, ASenderUrl: String);
  end;

var
  FormAlarmList: TFormAlarmList;
  g_AlarmConfigEditing: Boolean;
  g_ServiceQuerying: Boolean; //서비스 실행 중이면 true

implementation

uses System.Rtti, UnitCopyWatchList, CopyData, CommonUtil, UnitDM,
  UnitSimulatedValueInput, UnitAMSessionInterface, UnitAlarmConfigInterface,
  NetFwTypeLib_TLB, getIP;

{$R *.dfm}

type
  TWorker = class(TThread)
  strict private
    FCommandQueue : TOmniMessageQueue;
    FResponseQueue: TOmniMessageQueue;
    FStopEvent    : TEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(commandQueue, responseQueue: TOmniMessageQueue);
    destructor Destroy; override;
    procedure Stop;
  end;

procedure TFormAlarmList.AddAlarm2List(AParameterIndex: integer;
  ASetType: TAlarmSetType; AConfigSource: integer; AAlarmConfigItem: TAlarmConfigItem);
var
  LUniqueName: string;
  LDelay: integer;
begin
  LUniqueName := DM1.GetUniqueTagName(AAlarmConfigItem); //UserId_Category_ProjNo_EngNo_TagName_AlarmType
  if FAlarmStrList.IndexOf(LUniqueName) = -1 then //신규 알람 이면
  begin
    if AConfigSource = 1 then  //FromEngineParameterConfig
    begin
      case ASetType of
        astDigital: CheckDigital(AParameterIndex,LUniqueName);
        astLo: begin
          LDelay := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].MinAlarmDelay;
          CheckMinWarn(AParameterIndex,LUniqueName,LDelay);
        end;
        astLoLo: begin
          LDelay := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].MinFaultDelay;
          CheckMinFault(AParameterIndex,LUniqueName,LDelay);
        end;
        astHi: begin
          LDelay := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].MaxAlarmDelay;
          CheckMaxWarn(AParameterIndex,LUniqueName,LDelay);
        end;
        astHiHi: begin
          LDelay := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].MaxFaultDelay;
          CheckMaxFault(AParameterIndex,LUniqueName,LDelay);
        end;
      end;
    end
    else if AConfigSource = 0 then //FromAlarmConfig
    begin
      if Assigned(AAlarmConfigItem) then
      begin
        case ASetType of
          astDigital: CheckDigital(AParameterIndex,LUniqueName,AAlarmConfigItem);
          astLo: begin
            CheckMinWarn(AParameterIndex,LUniqueName,AAlarmConfigItem);
          end;
          astLoLo: begin
            CheckMinFault(AParameterIndex,LUniqueName,AAlarmConfigItem);
          end;
          astHi: begin
            CheckMaxWarn(AParameterIndex,LUniqueName,AAlarmConfigItem);
          end;
          astHiHi: begin
            CheckMaxFault(AParameterIndex,LUniqueName,AAlarmConfigItem);
          end;
        end;
      end;
    end;
  end;
end;

function TFormAlarmList.AddAlarmItem2AlarmListGrid(AUniqueTagName: string;
  AAlarmConfigItem: TAlarmConfigItem; AColor: TColor): TRow;
var
  r, LCol: integer;
  LAlarmConfigItem: TAlarmConfigItem;
begin
  LAlarmConfigItem := FAlarmHistoryCollect.Add;
  AAlarmConfigItem.AssignTo(LAlarmConfigItem);

  if AlarmListGrid.RowCount > 0 then
  begin
    r := 0;
    AlarmListGrid.InsertRow(r);
  end
  else
  begin
    r := AlarmListGrid.AddRow();
  end;

  AlarmListGrid.CellByName['Ack',0].AsInteger := BoolToInt(LAlarmConfigItem.NeedAck);
  AlarmListGrid.CellByName['IssueTime',0].AsString := FormatDateTime('yyyy-mm-dd hh:nn:ss', LAlarmConfigItem.IssueDateTime);
  AlarmListGrid.CellByName['EngNo',0].AsString := AAlarmConfigItem.EngType + '(' + AAlarmConfigItem.EngNo + ')';
//  AlarmListGrid.CellByName['Desc',0].AsString := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description;
  AlarmListGrid.CellByName['AlarmType',0].AsString := TRttiEnumerationType.GetName<TAlarmSetType>(LAlarmConfigItem.AlarmSetType);
  AlarmListGrid.CellByName['AlarmMessage',0].AsString := LAlarmConfigItem.AlarmMessage;
  AlarmListGrid.CellByName['Priority',0].AsString := ArarmPriority2String(AAlarmConfigItem.AlarmPriority);

  if LAlarmConfigItem.AlarmSetType = astDigital then
    AlarmListGrid.CellByName['AlarmValue',0].AsString := BoolToStr(IntToBool(StrToInt(LAlarmConfigItem.SensorValue)), True)
  else
    AlarmListGrid.CellByName['AlarmValue',0].AsString := LAlarmConfigItem.SensorValue;
  AlarmListGrid.CellByName['UserId',0].AsString := LAlarmConfigItem.UserID;
  AlarmListGrid.Row[r].Data := LAlarmConfigItem;
  LAlarmConfigItem.NextGridRow := AlarmListGrid.Row[r];
//  UpdateGridRowIndexFromRecord(True);
  //if not AALRecord.FNeedAck then
    //TNxCheckBoxColumn(AlarmListGrid.Cell[0,0]).Visible := False;
  Result := AlarmListGrid.Row[r];
  //해제 되지 않은 Alarm을  List에 저장함
  FAlarmStrList.InsertObject(0, AUniqueTagName, Result);

  for LCol := 0 to AlarmListGrid.Columns.Count - 1 do
  begin
    AlarmListGrid.Cell[LCol, r].Color := AColor;
//    AlarmListGrid.Cell[LCol, r].FontStyle := fsBold;
  end;

end;

function TFormAlarmList.AddData2AlarmListMap(AParameterIndex: integer;
  AUniqueTagName: string; AAlarmConfigItem: TAlarmConfigItem; AColor: TColor): integer;
var
  LStr: string;
  LGridRow: TRow;
  LAlarmListRecord: TAlarmListRecord;
begin
  AlarmConfigItem2AlarmListRecord(AAlarmConfigItem, LAlarmListRecord);
  //Alarm History 창에 Alarm 표시함
  LGridRow := AddAlarmItem2AlarmListGrid(AUniqueTagName, AAlarmConfigItem, AColor);

  if FProgramMode = 0 then
  begin
    if not IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].IsSimulateMode then
    begin
      DB_Alarm_insert(AAlarmConfigItem.AlarmHistoryTableName, LAlarmListRecord);
    end;

    LAlarmListRecord.FAlarmAction := aaAlarmIssue;
    SendAlarm2Server(LAlarmListRecord);
  end;

  DisplayAlarm2ItemGrid(AParameterIndex, AColor);
end;

procedure TFormAlarmList.AddMonitoringEngInfo2List(AProjNo, AEngNo: string);
var
  LMonitoringEngInfo: TMonitoringEngInfo;
begin
  LMonitoringEngInfo := TMonitoringEngInfo.Create;
  LMonitoringEngInfo.ProjNo := AProjNo;
  LMonitoringEngInfo.EngNo := AEngNo;
  FMonitoringEngineList.Add(GetUniqueEngName(AProjNo, AEngNo), LMonitoringEngInfo);
//  SetMonitoringTableListFromAlarmConfig;
end;

function TFormAlarmList.AddData2AlarmListMap(AParameterIndex: integer;
  AUniqueTagName, AAlarmDesc: string; ASetType: TAlarmSetType): TAlarmListRecord;
var
  i: integer;
  LStr: string;
begin
//  Result := nil;
  i := FAlarmStrList.IndexOf(AUniqueTagName);

  if i = -1 then
  begin
//    Result:= TAlarmListRecord.Create;
//    Result.FTagName := AUniqueTagName;
//    Result.FValue := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].Value;
//    Result.FAlarmDesc := AAlarmDesc;
//    Result.FIssueDateTime := now;
//    Result.FEngineNo := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].SharedName;
//    Result.FAlarmPriority := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].AlarmPriority;
//    Result.FTagDesc := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].Description;
//    Result.FNeedAck := GetNeedAckSetValue(AParameterIndex, ASetType);
//    Result.FAcknowledgedTime := 0;
//    Result.FSuppressed := False;
//    Result.FParamIndex := AParameterIndex;
//    Result.FAlarmSetType := ASetType;
//    //처음에는 Grid의 0번째 행에 Insert 함(데이터 추가/삭제되면 변경됨)
//    Result.FGridRowIndex := 0;

//    FAlarmStrList.InsertObject(0, AUniqueTagName, Result);
  end;
end;

procedure TFormAlarmList.AddtoCalculated1Click(Sender: TObject);
begin
  FWG.AddCalculated2GridFromMenu;
end;

procedure TFormAlarmList.AeroButton1Click(Sender: TObject);
var
  LSQLParamDict: TSQLParamDict;
  LValueList: TStringList;
  LSQL: string;
  i,j: integer;
begin
  LSQLParamDict := TSQLParamDict.Create;
  LValueList := TStringList.Create;
  try
    LSQL := 'select * from AlarmList where IssueDateTime >= :Fromday and IssueDateTime <= :ToDay';//ReleaseDateTime = 0';
    LSQLParamDict.Add('Fromday', sptReal);
    LSQLParamDict.Add('ToDay', sptReal);
    LValueList.Add(FloatToStr(GetFromDay(dt_begin.DateTime)));
    LValueList.Add(FloatToStr(GetToDay(dt_end.DateTime)));
    DB_Alarm_Select(LSQL, LSQLParamDict, LValueList);

//    if FQuery.Active then
//    begin
//      AlarmListGrid.ClearRows;
//
//      for i := 0 to FQuery.RecordCount - 1 do
//      begin
//        j := AlarmListGrid.AddRow();
//
//        //TNxCheckBoxColumn(AlarmListGrid.Cell[0,j]).Visible := Boolean(FQuery.FieldByName('NeedAcked').AsInteger);
//
//        AlarmListGrid.Cells[CI_TIME_IN,i] := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',TDateTime(FQuery.Fields[3].AsFloat));
//
//        if FQuery.Fields[4].AsFloat > 0 then
//          AlarmListGrid.Cells[CI_TIME_OUT,i] := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',TDateTime(FQuery.Fields[4].AsFloat));
//        AlarmListGrid.Cells[CI_ENGINE_NO,i] := FQuery.Fields[1].AsString;
//        AlarmListGrid.Cells[CI_TAG_DESC,i] := FQuery.Fields[6].AsString;
//        AlarmListGrid.Cells[CI_ALARMMSG,i] := FQuery.Fields[7].AsString;
//        AlarmListGrid.Cells[CI_ALARMPRIO,i] := ArarmPriority2String(TAlarmPriority(FQuery.Fields[8].AsInteger));
//        FQuery.Next;
//      end;
//    end;
  finally
    LValueList.Free;
    LSQLParamDict.Free;
  end;
end;

procedure TFormAlarmList.AeroButton4Click(Sender: TObject);
begin
  close;
end;

procedure TFormAlarmList.AlarmAcknowledge(ARow: integer);
var
 LAlarmListRecord: TAlarmConfigItem;
 LStr: string;
 i: integer;
begin
  LAlarmListRecord := TAlarmConfigItem(AlarmListGrid.Row[ARow].Data);

  if Assigned(LAlarmListRecord) then
  begin
    LStr := DM1.GetUniqueTagName(LAlarmListRecord); //UserId_Category_ProjNo_EngNo_TagName_AlarmType
    i := FAlarmStrList.IndexOf(LStr);

    if i > -1 then //Data가 Map에 존재하면
    begin
      if LAlarmListRecord.NeedAck then
      begin
//        DB_Alarm_Acked_Update_Zeos(LAlarmListRecord.FSeqNo, now);
        FreeAndNil(LAlarmListRecord);
        AlarmListGrid.Row[ARow].Data := nil;
//        FAlarmStrList.Delete(i);
      end;
    end;
  end;
end;

procedure TFormAlarmList.AlarmConfigChangedPerEngine(AUniqueEngine, ASenderUrl: String);
var
  LEngine, LUserID, LCat, LProj, LEng, LAction: string;
  LUrl: string;
begin
  LUrl := ASenderUrl;

  if LUrl = FCS.FURL then
  begin
    FDisplayMessage := DateTimeToStr(now) + ' : ' + LUrl + ' is sent by myself. (Notify skipped)';
    SendMessage(Self.Handle, WM_DISPLAYMESSAGE, 0, 0);
    exit;
  end;

  if g_AlarmConfigEditing then
    exit;

  g_AlarmConfigEditing := True;
  try
    //AUniqueEngine = userid;catno;projno;engno
    LEngine := AUniqueEngine;
    if FProgramMode = 0 then //Report Mode
    begin
      FAlarmSetDoing := True;
      try
        LUserID := strToken(LEngine, ';');
        LCat := strToken(LEngine, ';');
        LProj := strToken(LEngine, ';');
        LEng := strToken(LEngine, ';');
        LAction := strToken(LEngine, ';');
        LEngine := GetUniqueEngName(LProj, LEng);

        if LAction = 'DELETE' then
        begin
          DM1.DeleteAlarmConfigFromUser(LUserID, LCat, FAlarmConfig, FAlarmConfigDict);
          DM1.GetAlarmConfigFromDBPerUserNAssign2Collect(LUserID, LCat,
            FAlarmConfig, FAlarmConfigDict,IPCMonitorAll1.FEngineParameter.EngineParameterCollect);
        end
        else
        if FMonitoringEngineList.ContainsKey(LEngine) then
        begin
          //해당 User의 모든 알람 설정 값을 삭제함
          DM1.DeleteAlarmConfigFromUser(LUserID, LCat, FAlarmConfig, FAlarmConfigDict);
          DM1.GetAlarmConfigFromDBPerUserNAssign2Collect(LUserID, LCat,
            FAlarmConfig, FAlarmConfigDict,IPCMonitorAll1.FEngineParameter.EngineParameterCollect);
          //FAlarmConfig에서 해당 엔진 삭제
//          DM1.DeleteAlarmConfigFromUniqueEngine(LEngine, FAlarmConfig, FAlarmConfigDict);
          //엔진 조회(projno;engno), 조회한 엔진을 FAlarmConfign에 저장
//          DM1.GetAlarmConfigFromDBPerEngineNAssign2Collect(LEngine,
//            FAlarmConfig, FAlarmConfigDict,IPCMonitorAll1.FEngineParameter.EngineParameterCollect);
    //      DM1.AssignAlarmConfig2Collect(DM1.OraQuery1);
        end;
      finally
        FAlarmSetDoing := False;
      end;
    end
    else
    if FProgramMode = 1 then //User Mode일떄는 UserId와 CatNo만 가져옴
    begin
      LUserID := strToken(LEngine, ';');

      if LUserID = DM1.FUserInfo.UserID then
      begin
        GetAlarmConfigListFromDB;
      end;
    end;

    FillInAlarmConfigList2Grid;
  finally
    FDisplayMessage := DateTimeToStr(now) + ' :  AlarmConfigChange Notify is received';
    SendMessage(Self.Handle, WM_DISPLAYMESSAGE, 0, 0);
    g_AlarmConfigEditing := False;
  end;
end;

procedure TFormAlarmList.AlarmConfigItem2AlarmListRecord(
  AAlarmConfigItem: TAlarmConfigItem; var AlarmListRecord: TAlarmListRecord);
var
  LDate: TDateTime;
  YY,MM,DD,HH,MI,SS,zz: word;
begin
  DecodeDateTime(now,YY,MM,DD,HH,MI,SS,zz);
  LDate := EncodeDateTime(YY,MM,DD,HH,MI,SS,0);
  AAlarmConfigItem.IssueDateTime := LDate;

  AlarmListRecord.FUserID := AAlarmConfigItem.UserID;
  AlarmListRecord.FCategory := AAlarmConfigItem.Category;
  AlarmListRecord.FProjNo := AAlarmConfigItem.ProjNo;
  AlarmListRecord.FEngNo := AAlarmConfigItem.EngNo;
  AlarmListRecord.FTagName := AAlarmConfigItem.TagName;
  AlarmListRecord.FAlarmSetType := AAlarmConfigItem.AlarmSetType;
  AlarmListRecord.FIssueDateTime := LDate;
  AlarmListRecord.FReleaseDateTime := 0;
  AlarmListRecord.FAcknowledgedTime := 0;
  AlarmListRecord.FSuppressedTime := 0;
  AlarmListRecord.FIsOutLamp := AAlarmConfigItem.IsOutLamp;
  AlarmListRecord.FIsOnlyRun := AAlarmConfigItem.IsOnlyRun;
  AlarmListRecord.FAlarmPriority := AAlarmConfigItem.AlarmPriority;
  AlarmListRecord.FNeedAck := AAlarmConfigItem.NeedAck;
  if AAlarmConfigItem.AlarmSetType = astDigital then
    AlarmListRecord.FSetValue := BoolToStr(IntToBool(StrToInt(AAlarmConfigItem.SetValue)), True)
  else
    AlarmListRecord.FSetValue := AAlarmConfigItem.SetValue;
  AlarmListRecord.FSensorValue := AAlarmConfigItem.SensorValue;
  AlarmListRecord.FAlarmMessage := AAlarmConfigItem.AlarmMessage;
  AlarmListRecord.FDelay := AAlarmConfigItem.Delay;
  AlarmListRecord.FDeadBand := AAlarmConfigItem.DeadBand;
  AlarmListRecord.FNotifyApps := AAlarmConfigItem.NotifyApps;
  AlarmListRecord.FRecipients := AAlarmConfigItem.Recipients
end;

procedure TFormAlarmList.AlarmListConfig1Click(Sender: TObject);
begin
  SetAlarmListConfig;
end;

procedure TFormAlarmList.AlarmListGridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  LAlarmConfigItem: TAlarmConfigItem;
begin
  if (ARow <> -1) and (ACol = 0) then  //Ack Click
  begin
    LAlarmConfigItem := TAlarmConfigItem(AlarmListGrid.Row[ARow].Data);

    if not Assigned(LAlarmConfigItem) then
      exit;

    if LAlarmConfigItem.NeedAck then
    begin
      AlarmListGrid.Cell[ACol,ARow].AsInteger := 2; //Ack Checked Box Display

      if LAlarmConfigItem.AcknowledgedTime = 0 then
      begin
        LAlarmConfigItem.AcknowledgedTime := now;
        UpdateAlarmAckTime2DB(LAlarmConfigItem);
        AlarmListGrid.CellByName['AckTime', ARow].AsString :=
          FormatDateTime('yyyy-mm-dd hh:nn:ss', LAlarmConfigItem.AcknowledgedTime);
      end;
    end;
  end;
end;

procedure TFormAlarmList.ApplyUI;
begin
  FillInAlarmConfigList2Grid;
  NotifyAlarmConfigChanged2Server;
end;

procedure TFormAlarmList.CheckAlarmFromAlarmConfig(AEPIndex: integer);
var
  LEPItem: TEngineParameterItem;
  LAlarmConfigItem: TAlarmConfigItem;
  LStr, LValue, LUniqueName, LUniqueTagName, LUniqueEng: string;
  i: TAlarmSetType;
  j: integer;
  tmpdouble, LSetValue, LSetValueWithDeadBand: double;
  LAlarmSetType: TAlarmSetType;
  LConfigSrc: integer;
  LList: TList<TAlarmConfigItem>;
  LIsRelease: Boolean;
begin
  if FAlarmSetDoing then
    exit;

  if g_AlarmConfigEditing then
    exit;

  LEPItem := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex];

  if Pos(LEPItem.ProjNo, LEPItem.TagName) > 0 then
    LUniqueName := LEPItem.TagName + '_'
  else
    LUniqueName := LEPItem.ProjNo + '_' + LEPItem.EngNo + '_'  + LEPItem.TagName + '_';

  for i := Low(TAlarmSetType) to High(TAlarmSetType) do
  begin
    LIsRelease := False;

    LStr := LUniqueName + FAlarmSetTypeNames[i];
//    LStr := GetUniqueTagName(AEPIndex, i); //ProjNo_EngNo_TagName_AlarmType
    //Alarm이 Setting 되어 있으면
    if FAlarmConfigDict.ContainsKey(LStr) then
    begin
      LAlarmSetType := astNone;

      if LEPItem.IsSimulateMode then
        LValue := LEPItem.SimulateValue
      else
        LValue := LEPItem.Value;

      if LEPItem.Alarm then //Analog
      begin
        if Pos('.', LValue) > 0 then
          tmpdouble := StrToFloatDef(LValue, 0.0)
        else
          tmpdouble := StrToIntDef(LValue, 0);
      end
      else
        tmpdouble := StrToIntDef(LValue,0);
//        tmpdouble := BoolToInt(StrToBoolDef(LValue, False));

      LConfigSrc := StrToIntDef(FSettings.ConfigSource,0);
      LList := FAlarmConfigDict[LStr];

      //사용자별,카테고리별로 동일한 알람이 세팅되었을 수도 있음
      for j := 0 to LList.Count - 1  do
      begin
        LAlarmConfigItem := LList.Items[j];

        if not Assigned(LAlarmConfigItem) then
          continue;

//        LUniqueTagName := LAlarmConfigItem.UserID + '_' +
//            LAlarmConfigItem.Category + '_' +
//            LAlarmConfigItem.ProjNo + '_' +
//            LAlarmConfigItem.EngNo + '_' +
//            LAlarmConfigItem.TagName + '_' + FAlarmSetTypeNames[LAlarmConfigItem.AlarmSetType];

        LUniqueTagName := DM1.GetUniqueTagName(LAlarmConfigItem);
        LAlarmConfigItem.SensorValue := LValue;
        LAlarmSetType := astNone;

        if i = astDigital then
          LSetValue := StrToIntDef(LAlarmConfigItem.SetValue, 1)
//          LSetValue := BoolToInt(StrToBoolDef(LAlarmConfigItem.SetValue, True))
        else
          LSetValue := StrToFloatDef(LAlarmConfigItem.SetValue, 0.0);

        LSetValueWithDeadBand := LSetValue + LAlarmConfigItem.DeadBand;

        //Run Condition이 설정된 경우
        if LAlarmConfigItem.IsOnlyRun then
        begin
          LUniqueEng := GetUniqueEngName(LAlarmConfigItem.ProjNo, LAlarmConfigItem.EngNo);

          if not IsEngineRunning(LUniqueEng) then
          begin
            if IsAlarm(i, tmpdouble, LSetValue) then
              //해제 되지 않은 Alarm이 존재 하면
              if (LAlarmSetType = astNone) and (FAlarmStrList.Count > 0) then
                ReleaseAlarm4Analog(AEPIndex, LUniqueTagName, FAlarmStrList);
            exit;
          end;
        end;

        if IsAlarm(i, tmpdouble, LSetValueWithDeadBand) then
        begin
          LAlarmSetType := i;
          AddAlarm2List(AEPIndex, LAlarmSetType, LConfigSrc, LAlarmConfigItem);
        end
        else
          LIsRelease := LAlarmConfigItem.DeadBand = 0;

          if not LIsRelease then
            //Alarm Release할 때는 DeadBand값을 제외하고 Alarm 여부를 판단함
            LIsRelease := not IsAlarm(i, tmpdouble, LSetValue);

        //해제 되지 않은 Alarm이 존재 하면
        if (LAlarmSetType = astNone) and (FAlarmStrList.Count > 0) and (LIsRelease) then
          ReleaseAlarm4Analog(AEPIndex, LUniqueTagName, FAlarmStrList);
      end;//for
    end;
  end;
end;

procedure TFormAlarmList.CheckAlarmFromEngineParameterConfig(AEPIndex: integer);
var
  LStr, LValue: string;
  tmpdouble: double;
  LEPItem: TEngineParameterItem;
  LAlarmSetType: TAlarmSetType;
begin
  LEPItem := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex];

  if LEPItem.AlarmEnable then
  begin
    LStr := GetUniqueTagName(AEPIndex, astOriginalEP);

    if LEPItem.IsSimulateMode then
    begin
      tmpdouble := StrToFloatDef(LEPItem.SimulateValue, 0.0);
      LValue := LEPItem.SimulateValue;
    end
    else
    begin
      tmpdouble := StrToFloatDef(LEPItem.Value, 0.0);
      LValue := LEPItem.Value;
    end;

    LAlarmSetType := astNone;

    if LEPItem.MinFaultEnable then
    begin
      if tmpdouble < LEPItem.MinFaultValue then
      begin
        AddAlarm2List(AEPIndex, astLoLo);
        LAlarmSetType := astLoLo;
      end;
    end;

    if LEPItem.MinAlarmEnable then
    begin
      if tmpdouble < LEPItem.MinAlarmValue then
      begin
        AddAlarm2List(AEPIndex, astLo);
        LAlarmSetType := astLo;
      end;
    end;

    if LEPItem.MaxFaultEnable then
    begin
      if tmpdouble > LEPItem.MaxFaultValue then
      begin
        AddAlarm2List(AEPIndex, astHiHi);
        LAlarmSetType := astHiHi;
      end;
    end;

    if LEPItem.MaxAlarmEnable then
    begin
      if tmpdouble > LEPItem.MaxAlarmValue then
      begin
        AddAlarm2List(AEPIndex, astHi);
        LAlarmSetType := astHi;
      end;
    end;

    //해제 되지 않은 Alarm이 존재 하면
    if (LAlarmSetType = astNone) and (FAlarmStrList.Count > 0) then
      ReleaseAlarm4Analog(AEPIndex, LStr, FAlarmStrList);

//      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].AlarmSetType := LAlarmSetType;
  end;
end;

function TFormAlarmList.CheckDBFile(AFileName: string): Boolean;
begin
  if AFileName = '' then
  begin
    Result := True;
    exit;
  end;

  if FileExists(AFileName) then
  begin
    Result := True;
  end
  else
    Result := False;
end;

procedure TFormAlarmList.CheckDigital(APIndex: integer; AUniqueTagName: string;
  AAlarmConfigItem: TAlarmConfigItem);
var
  j, LRow: integer;
  LSuccess, LAlarm: Boolean;
  LSeqNo: integer;
  //it: Diterator;
  LDelay: TDateTime;
  LGridRow: TRow;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if not Alarm then//not analog type
    begin
      if StrToFloatDef(Value, 0.0) > 0.0 then
      begin
        case Contact of
          1: LAlarm := True; //A 접점
          2: LAlarm := False;//B 접점
          else
            LAlarm := True;//기타 값은 A접점으로 간주함
        end;
      end
      else
      begin
        case Contact of
          1: LAlarm := False; //A 접점
          2: LAlarm := True;//B 접점
          else
            LAlarm := False;//기타 값은 A접점으로 간주함
        end;
      end;

      if LAlarm then
      begin
        if AAlarmConfigItem.Delay > 0 then
        begin
          //Alarm Delay
          if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime = 0 then
          begin
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime := now;
            exit;
          end
          else
          begin
            LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime;

            //Delay 시간이 경과 하지 않은 경우
            if LDelay < AAlarmConfigItem.Delay then
              exit;
          end;
        end;

        if AAlarmConfigItem.AlarmMessage = '' then
          AAlarmConfigItem.AlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + ' Alarm';

//        AAlarmConfigItem.AlarmSetType := astDigital;
        if MinAlarmColor = 0 then
          MinAlarmColor := DefaultMinAlarmColor;

        AddData2AlarmListMap(APIndex,AUniqueTagName,AAlarmConfigItem, MinAlarmColor);
      end
      else
      begin //Alarm 해제
      end;
    end;
  end;//with
end;

procedure TFormAlarmList.CheckDigital(APIndex: integer;
  AUniqueTagName: string);
var
  j, LRow: integer;
  LSuccess, LAlarm: Boolean;
  LSeqNo: integer;
  //it: Diterator;
  LAlarmListRecord: TAlarmListRecord;
  LAlarmMessage: string;
  LDelay: TDateTime;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if not Alarm then//not analog type
    begin
      if StrToFloatDef(Value, 0.0) > 0.0 then
      begin
        case Contact of
          1: LAlarm := True; //A 접점
          2: LAlarm := False;//B 접점
          else
            LAlarm := True;//기타 값은 A접점으로 간주함
        end;
      end
      else
      begin
        case Contact of
          1: LAlarm := False; //A 접점
          2: LAlarm := True;//B 접점
          else
            LAlarm := False;//기타 값은 A접점으로 간주함
        end;
      end;

      if LAlarm then
      begin
        if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultDelay > 0 then
        begin
          //Alarm Delay
          if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime = 0 then
          begin
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime := now;
            exit;
          end
          else
          begin
            LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime;

            //Delay 시간이 경과 하지 않은 경우
            if LDelay < IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultDelay then
              exit;
          end;
        end;

        LAlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + ' Alarm';
        LAlarmListRecord := AddData2AlarmListMap(APIndex,AUniqueTagName,LAlarmMessage,astDigital);

//        if Assigned(LAlarmListRecord) then
//        begin
//          DB_Alarm_insert(AAlarmConfigItem.AlarmHistoryTableName, LAlarmListRecord);
//          AddAlarmItem2AlarmListGrid(APIndex, LAlarmListRecord);
          DisplayAlarm2ItemGrid(APIndex, MaxAlarmColor);
//        end;
      end
      else
      begin //Alarm 해제
//        LRow := DeleteDataFromAlarmListMap_DB(AUniqueTagName);
//
//        if (LRow > -1) and (LRow < AlarmListGrid.RowCount) then
//        begin
//          for j := 0 to AlarmListGrid.Columns.Count - 1 do
//            AlarmListGrid.Cell[j, LRow].Color := DefaultAlarmListCellColor;
//        end;
      end;
    end;
  end;//with
end;

procedure TFormAlarmList.CheckMaxFault(APIndex: integer;
  AUniqueTagName: string; ADelay: integer; AAlarmMessage: string);
var
  j, LRow: integer;
  LSuccess: Boolean;
  LSeqNo: integer;
  //it: Diterator;
  LAlarmListRecord: TAlarmListRecord;
  LAlarmMessage: string;
  LDelay: TDateTime;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
//    if MaxFaultEnable then
//    begin //Fault 발생
//      if StrToFloatDef(Value, 0.0) > MaxFaultValue then
//      begin
        if ADelay > 0 then
        begin
          //Alarm Delay
          if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime = 0 then
          begin
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime := now;
            exit;
          end
          else
          begin
            LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime;

            //Delay 시간이 경과 하지 않은 경우
            if LDelay < ADelay then
              exit;
          end;
        end;

        if AAlarmMessage <> '' then
          LAlarmMessage := AAlarmMessage
        else
          LAlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + 'High Fault';

        LAlarmListRecord := AddData2AlarmListMap(APIndex,AUniqueTagName,LAlarmMessage,astHiHi);

//        if Assigned(LAlarmListRecord) then
//        begin
//          DB_Alarm_insert(AAlarmConfigItem.AlarmHistoryTableName, LAlarmListRecord);
//          AddAlarmItem2AlarmListGrid(APIndex, LAlarmListRecord);
          DisplayAlarm2ItemGrid(APIndex, MaxFaultColor);
//        end;
//      end
//      else
//      if StrToFloatDef(Value, 0.0) <= (MaxFaultValue - MaxFaultDeadBand) then
//      begin //Alarm 해제
//        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime := 0;
//        LRow := DeleteDataFromAlarmListMap_DB(AUniqueTagName);
//
//        if (LRow > -1) and (LRow < AlarmListGrid.RowCount) then
//        begin
//          for j := 0 to AlarmListGrid.Columns.Count - 1 do
//            AlarmListGrid.Cell[j, LRow].Color := DefaultAlarmListCellColor;
//        end;
//      end;
//    end;
  end;//with
end;

procedure TFormAlarmList.CheckMaxWarn(APIndex: integer;
  AUniqueTagName: string; ADelay: integer; AAlarmMessage: string);
var
  j, LRow: integer;
  LSuccess: Boolean;
  LSeqNo: integer;
  //it: Diterator;
  LAlarmListRecord: TAlarmListRecord;
  LAlarmMessage: string;
  LDelay: TDateTime;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
//    if MaxAlarmEnable then
//    begin //Alarm 발생
//      if StrToFloatDef(Value, 0.0) > MaxAlarmValue then
//      begin
        if ADelay > 0 then
        begin
          //Alarm Delay
          if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxAlarmStartTime = 0 then
          begin
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxAlarmStartTime := now;
            exit;
          end
          else
          begin
            LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxAlarmStartTime;

            //Delay 시간이 경과 하지 않은 경우
            if LDelay < ADelay then
              exit;
          end;
        end;

        if AAlarmMessage <> '' then
          LAlarmMessage := AAlarmMessage
        else
          LAlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + 'High Alarm';

        LAlarmListRecord := AddData2AlarmListMap(APIndex,AUniqueTagName,LAlarmMessage,astHi);

//        if Assigned(LAlarmListRecord) then
//        begin
          DB_Alarm_insert_Zeos(LAlarmListRecord);
//          AddAlarmItem2AlarmListGrid(APIndex, LAlarmListRecord);
          DisplayAlarm2ItemGrid(APIndex, MaxAlarmColor);
//        end;
//      end
//      else
//      if StrToFloatDef(Value, 0.0) <= (MaxAlarmValue - MaxAlarmDeadBand) then
//      begin //Alarm 해제
//        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxAlarmStartTime := 0;
//        LRow := DeleteDataFromAlarmListMap_DB(AUniqueTagName);
//
//        if (LRow > -1) and (LRow < AlarmListGrid.RowCount) then
//        begin
//          for j := 0 to AlarmListGrid.Columns.Count - 1 do
//            AlarmListGrid.Cell[j, LRow].Color := DefaultAlarmListCellColor;
//        end;
//      end;
//    end;
  end;//with
end;

procedure TFormAlarmList.CheckMinFault(APIndex: integer;
  AUniqueTagName: string; ADelay: integer; AAlarmMessage: string);
var
  j, LRow: integer;
  LSuccess: Boolean;
  LSeqNo: integer;
  //it: Diterator;
  LAlarmListRecord: TAlarmListRecord;
  LAlarmMessage: string;
  LDelay: TDateTime;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
//    if MinFaultEnable then
//    begin //Fault 발생
//      if StrToFloatDef(Value, 0.0) < MinFaultValue then
//      begin
        if ADelay > 0 then
        begin
          //Alarm Delay
          if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime = 0 then
          begin
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime := now;
            exit;
          end
          else
          begin
            LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime;

            //Delay 시간이 경과 하지 않은 경우
            if LDelay < ADelay then
              exit;
          end;
        end;

        if AAlarmMessage <> '' then
          LAlarmMessage := AAlarmMessage
        else
          LAlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + ' Low Fault';

        LAlarmListRecord := AddData2AlarmListMap(APIndex,AUniqueTagName,LAlarmMessage,astLoLo);

//        if Assigned(LAlarmListRecord) then
//        begin
          DB_Alarm_insert_Zeos(LAlarmListRecord);
//          AddAlarmItem2AlarmListGrid(APIndex, LAlarmListRecord);
          DisplayAlarm2ItemGrid(APIndex, MinFaultColor);
          LAlarmListRecord.FAlarmAction := aaAlarmIssue;
//          SendAlarm2Server(LAlarmListRecord);
//        end
//        else
//        begin
//
//        end;
//      end
//      else
//      if StrToFloatDef(Value, 0.0) >= (MinFaultValue+MinFaultDeadBand) then
//      begin //Alarm 해제
//        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime := 0;
//
//        LRow := DeleteDataFromAlarmListMap_DB(AUniqueTagName);
//
//        if (LRow > -1) and (LRow < AlarmListGrid.RowCount) then
//        begin
//          for j := 0 to AlarmListGrid.Columns.Count - 1 do
//            AlarmListGrid.Cell[j, LRow].Color := DefaultAlarmListCellColor;
//        end;
//      end;
//    end;
  end;//with
end;

procedure TFormAlarmList.CheckMinWarn(APIndex: integer;
  AUniqueTagName: string; ADelay: integer; AAlarmMessage: string);
var
  j, LRow: integer;
  LSuccess: Boolean;
  LSeqNo: integer;
  //it: Diterator;
  LAlarmListRecord: TAlarmListRecord;
  LAlarmMessage: string;
  LDelay: TDateTime;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
//    if MinAlarmEnable then
//    begin //Alarm 발생
      //AddToAlarmList 실행 시에 체크함
//      if StrToFloatDef(Value, 0.0) < MinAlarmValue then
//      begin
        if ADelay > 0 then
        begin
          //Alarm Delay
          if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinAlarmStartTime = 0 then
          begin
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinAlarmStartTime := now;
            exit;
          end
          else
          begin
            LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinAlarmStartTime;

            //Delay 시간이 경과 하지 않은 경우
            if LDelay < ADelay then
              exit;
          end;
        end;

        if AAlarmMessage <> '' then
          LAlarmMessage := AAlarmMessage
        else
          LAlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + 'Low Alarm';

        LAlarmListRecord := AddData2AlarmListMap(APIndex,AUniqueTagName,LAlarmMessage,astLo);

//        if Assigned(LAlarmListRecord) then
//        begin
          DB_Alarm_insert_Zeos(LAlarmListRecord);
//          AddAlarmItem2AlarmListGrid(APIndex, LAlarmListRecord);
          DisplayAlarm2ItemGrid(APIndex, MinAlarmColor);
//        end;
//      end
//      else
//      if StrToFloatDef(Value, 0.0) >= (MinAlarmValue+MinAlarmDeadBand) then
//      begin //Alarm 해제
//        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinAlarmStartTime := 0;
//        LRow := DeleteDataFromAlarmListMap_DB(AUniqueTagName);
//
//        if (LRow > -1) and (LRow < AlarmListGrid.RowCount) then
//        begin
//          for j := 0 to AlarmListGrid.Columns.Count - 1 do
//            AlarmListGrid.Cell[j, LRow].Color := DefaultAlarmListCellColor;
//        end;
//      end;
//    end;
  end;//with
end;

procedure TFormAlarmList.ClearAlarmConfigDic;
var
  LKey: string;
begin
  for LKey in FAlarmConfigDict.Keys do
  begin
    FAlarmConfigDict.Items[Lkey].Free;//TList 해제
  end;

  FAlarmConfigDict.Clear;
end;

procedure TFormAlarmList.ClearAllDB;
var
  LSQLParamDict: TSQLParamDict;
  LSQL: string;
  i: integer;
begin
  LSQLParamDict := TSQLParamDict.Create;
  try
    LSQL := 'delete from AlarmList';
    DB_Alarm_Delect(LSQL, LSQLParamDict);
  finally
    LSQLParamDict.Free;
  end;

end;

procedure TFormAlarmList.ClearAllDB1Click(Sender: TObject);
begin
  ClearAllDB;
end;

procedure TFormAlarmList.Config2Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TFormAlarmList.DB_Alarm_Acked_Update_Zeos(ASeqNo: integer;
  ATime: TDateTime);
var
  LIssueDate: TDateTime;
  LSQL: string;
begin
//  ZQuery1.Close;
//  ZQuery1.SQL.Clear;
//  LSQL := 'UPDATE ALARMLIST SET ';
//  LSQL := LSQL + 'AckedDateTime = :AckedDateTime';
//  LSQL := LSQL + ' WHERE ';
//  LSQL := LSQL + 'SeqNo = :SeqNo and ';
//  LSQL := LSQL + 'ReleaseDateTime > 0 and';
//  LSQL := LSQL + 'AckedDateTime = 0';
//  ZQuery1.SQL.Add(LSQL);
//  ZQuery1.Prepare;
//
//  if ZQuery1.Params.Count > 0 then
//  begin
//    ZQuery1.ParamByName('AckedDateTime').AsFloat := ATime;
//    ZQuery1.ParamByName('SeqNo').AsInteger := ASeqNo;
//    ZQuery1.ExecSQL;
//  end;
end;

procedure TFormAlarmList.DB_Alarm_Delect(ASql: string;
  AParamList: TSQLParamDict);
var
  LKey: String;
begin
//  FQuery.Close;
//  FQuery.SQL.Clear;
//  FQuery.SQL.Add(ASql);
//  FQuery.Prepare;
//
//  if FQuery.Params.Count = AParamList.Count then
//  begin
//    for LKey in AParamList.Keys do
//    begin
//      case AParamList.Items[LKey] of
//        sptNull: FQuery.ParamByName(LKey).AsInteger;
//        sptReal: FQuery.ParamByName(LKey).AsFloat;
//        sptInteger: FQuery.ParamByName(LKey).AsInteger;
//        sptText: FQuery.ParamByName(LKey).AsString;
//        sptBlob: FQuery.ParamByName(LKey).AsBlob;
//      end;
//    end;
//
//    FQuery.ExecSQL;
//  end;
end;

function TFormAlarmList.DB_Alarm_insert(ATableName: string; ARecord: TAlarmListRecord): integer;
var
  LSQL: string;
begin
  Result := -1;
  DM1.SaveAlarm2HistoryDB(ATableName, ARecord);
end;

function TFormAlarmList.DB_Alarm_insert_Zeos(
  ARecord: TAlarmListRecord): integer;
var
  LSQL: string;
begin
  Result := -1;

//  if ZConnection1.Connected then
//  begin
//    ZQuery1.SQL.Clear;
//    LSQL := 'INSERT INTO ';
//    LSQL := LSQL + 'AlarmList' + ' ('#13#10;
//    LSQL := LSQL + 'EngineNo' + ',';
//    LSQL := LSQL + 'AlarmLevel' + ',';
//    LSQL := LSQL + 'IssueDateTime' + ',';
//    LSQL := LSQL + 'ReleaseDateTime' + ',';
//    LSQL := LSQL + 'TagName' + ',';
//    LSQL := LSQL + 'TagDesc' + ',';
//    LSQL := LSQL + 'AlarmMessage' + ',';
//    LSQL := LSQL + 'AlarmPriority' + ',';
//    LSQL := LSQL + 'AckedDateTime' + ',';
//    LSQL := LSQL + 'AlarmSuppressed' + ',';
//    LSQL := LSQL + 'NeedAcked' + ',';
//    LSQL := LSQL + 'SensorCode' + ')';
//    LSQL := LSQL + ' VALUES ('#13#10;
//    LSQL := LSQL + ':EngineNo, :AlarmLevel,:IssueDateTime,:ReleaseDateTime,';
//    LSQL := LSQL + ':TagName,:TagDesc,:AlarmMessage,:AlarmPriority,:AckedDateTime,';
//    LSQL := LSQL + ':AlarmSuppressed, :NeedAcked, :SensorCode' + ')';
//    ZQuery1.SQL.Add(LSQL);
//    ZQuery1.Prepare;
//    //FExec.CommandText.Add(LSQL);
//    if ZQuery1.Params.Count > 0 then
//    begin
//      ZQuery1.ParamByName('EngineNo').AsString := ARecord.FEngineNo;
//      ZQuery1.ParamByName('AlarmLevel').AsInteger := ARecord.FAlarmLevel;
//      ZQuery1.ParamByName('IssueDateTime').AsFloat := ARecord.FIssueDateTime;
//      ZQuery1.ParamByName('ReleaseDateTime').AsFloat := 0.0;
//      ZQuery1.ParamByName('TagName').AsString := ARecord.FTagName;
//      ZQuery1.ParamByName('TagDesc').AsString := ARecord.FTagDesc;
//      ZQuery1.ParamByName('AlarmMessage').AsString := ARecord.FAlarmDesc;
//      ZQuery1.ParamByName('AlarmPriority').AsInteger := ARecord.FAlarmPriority;
//      ZQuery1.ParamByName('AckedDateTime').AsFloat := 0;//Ord(ARecord.FAcknowledged);
//      ZQuery1.ParamByName('AlarmSuppressed').AsInteger := Ord(ARecord.FSuppressed);
//      ZQuery1.ParamByName('NeedAcked').AsInteger := Ord(ARecord.FNeedAck);
//      ZQuery1.ParamByName('SensorCode').AsString := ARecord.FSensorCode;
//
//      ZQuery1.ExecSQL;
//
//      ZQuery1.SQL.Clear;
//      LSQL := 'select max(SeqNo) from alarmlist';
//      ZQuery1.SQL.Add(LSQL);
//      ZQuery1.Prepare;
//      ZQuery1.Open;
//
//      if ZQuery1.Active then
//      begin
//        Result := ZQuery1.Fields[0].AsInteger;
//        ARecord.FSeqNo := Result;
//      end;
//    end;
//  end;

end;

procedure TFormAlarmList.DB_Alarm_Select(ASql: string;
  AParamList: TSQLParamDict; AValueList: TStringList);
var
  LKey: String;
  i: integer;
begin
//  FQuery.Close;
//  FQuery.SQL.Clear;
//  FQuery.SQL.Add(ASql);
//  FQuery.Prepare;
//
//  if (FQuery.Params.Count = AParamList.Count) and
//    (AParamList.Count = AValueList.Count) then
//  begin
//    i := 0;
//
//    for LKey in AParamList.Keys do
//    begin
//      case AParamList.Items[LKey] of
//        sptNull: FQuery.ParamByName(LKey).AsInteger := StrToInt(AValueList.Strings[i]);
//        sptReal: FQuery.ParamByName(LKey).AsFloat :=  StrToFloat(AValueList.Strings[i]);
//        sptInteger: FQuery.ParamByName(LKey).AsInteger := StrToInt(AValueList.Strings[i]);
//        sptText: FQuery.ParamByName(LKey).AsString := AValueList.Strings[i];
//        //sptBlob: FQuery.ParamByName(LKey).AsBlob := StrToInt(AValueList.Strings[i]);
//      end;
//
//      inc(i);
//    end;
//
//    FQuery.Open;
//  end;
end;

procedure TFormAlarmList.DB_Alarm_Update(ASeqNo: integer;
  ATime: TDateTime);
var
  LIssueDate: TDateTime;
  LSQL: string;
begin
//  FQuery.Close;
//  FQuery.SQL.Clear;
//  LSQL := 'UPDATE ALARMLIST SET ';
//  LSQL := LSQL + CheckQuotation('ReleaseDateTime') + '= :ReleaseDateTime';
//  LSQL := LSQL + ' WHERE ';
//  LSQL := LSQL + CheckQuotation('SeqNo') + '= :SeqNo and ';
//  LSQL := LSQL + CheckQuotation('ReleaseDateTime') + '= 0';
//  FQuery.SQL.Add(LSQL);
//  FQuery.Prepare;
//
//  if FQuery.Params.Count > 0 then
//  begin
//    FQuery.ParamByName('ReleaseDateTime').AsFloat := ATime;
//    FQuery.ParamByName('SeqNo').AsInteger := ASeqNo;
//    FQuery.ExecSQL;
//  end;
end;

procedure TFormAlarmList.DB_Alarm_Release_Update_Zeos(ASeqNo: integer;
  ATime: TDateTime);
var
  LIssueDate: TDateTime;
  LSQL: string;
begin
//  ZQuery1.Close;
//  ZQuery1.SQL.Clear;
//  LSQL := 'UPDATE ALARMLIST SET ';
//  LSQL := LSQL + 'ReleaseDateTime = :ReleaseDateTime';
//  LSQL := LSQL + ' WHERE ';
//  LSQL := LSQL + 'SeqNo = :SeqNo and ';
//  LSQL := LSQL + 'ReleaseDateTime = 0';
//  ZQuery1.SQL.Add(LSQL);
//  ZQuery1.Prepare;
//
//  if ZQuery1.Params.Count > 0 then
//  begin
//    ZQuery1.ParamByName('ReleaseDateTime').AsFloat := ATime;
//    ZQuery1.ParamByName('SeqNo').AsInteger := ASeqNo;
//    ZQuery1.ExecSQL;
//  end;
end;

procedure TFormAlarmList.DB_Create_Table;
var
  LStr: string;
begin
  if FAlarmConfig.AlarmDBDriver = '' then
  begin
    ShowMessage('AlarmDBDriver empty!');
    exit;
  end;

  if FAlarmConfig.AlarmDBFileName = '' then
  begin
    ShowMessage('AlarmDBFileName empty!');
    exit;
  end;

//  FDataBase.CreateDatabase(deUTF_8, True,
//        FAlarmConfig.AlarmDBFileName, 'Alarm List DataBase');
//  LStr := 'CREATE TABLE AlarmList(';
//  LStr := LStr + ' SeqNo INTEGER PRIMARY KEY AUTOINCREMENT,';
//  LStr := LStr + ' EngineNo TEXT,';//Module
//  LStr := LStr + ' AlarmLevel INTEGER,';
//  LStr := LStr + ' IssueDateTime REAL,';
//  LStr := LStr + ' ReleaseDateTime REAL,';
//  LStr := LStr + ' TagName TEXT,';
//  LStr := LStr + ' TagDesc TEXT,';
//  LStr := LStr + ' AlarmMessage TEXT,';
//  LStr := LStr + ' AlarmPriority INTEGER,';
//  LStr := LStr + ' AckedDateTime REAL,';
//  LStr := LStr + ' AlarmSuppressed INTEGER,';
//  LStr := LStr + ' NeedAcked INTEGER,';
//  LStr := LStr + ' SensorCode TEXT)';
//
//  FQuery.SQL.Add(LStr);
//  FQuery.Prepare;
//  FQuery.ExecSQL;
end;

procedure TFormAlarmList.UpdateAlarmAckTime2DB(AAlarmConfigItem: TAlarmConfigItem);
begin
  DM1.UpdateAlarmAckTime2HistoryDB(AAlarmConfigItem);
end;

procedure TFormAlarmList.UpdateAlarmOutTime2DB(AAlarmConfigItem: TAlarmConfigItem);
begin
  DM1.UpdateAlarmOutTime2HistoryDB(AAlarmConfigItem);
end;

procedure TFormAlarmList.UpdateAlarmOutTime2HistoryDB4UnConfigAlarm(
  AAlarmHistoryList: TAlarmConfigCollect);
var
  LKey: string;
  LList: TList<TAlarmConfigItem>;
  LAlarmConfigItem: TAlarmConfigItem;
  i, j: integer;
  LExistConfig4AlarmHistory: Boolean;
begin
  for j := 0 to AAlarmHistoryList.Count - 1 do
  begin
    LExistConfig4AlarmHistory := False;

    for LKey in FAlarmConfigDict.Keys do
    begin
      LList := FAlarmConfigDict.Items[Lkey];

      for i := 0 to LList.Count - 1  do
      begin
        LAlarmConfigItem := LList.Items[i];
        //Alarm History Item이 Config Item에 없으면(모니터링 하지 않으면)
        //AlarmOutTime을 현재 시간으로 설정하여 Alarm Release 시킴
        if (AAlarmHistoryList.Items[j].UserID = LAlarmConfigItem.UserID) and
         (AAlarmHistoryList.Items[j].Category = LAlarmConfigItem.Category) and
         (AAlarmHistoryList.Items[j].ProjNo = LAlarmConfigItem.ProjNo) and
         (AAlarmHistoryList.Items[j].EngNo = LAlarmConfigItem.EngNo) and
         (AAlarmHistoryList.Items[j].TagName = LAlarmConfigItem.TagName) and
         (AAlarmHistoryList.Items[j].AlarmSetType = LAlarmConfigItem.AlarmSetType) then
        begin
          LExistConfig4AlarmHistory := True;
          break;
        end;
      end;//for

      if LExistConfig4AlarmHistory then
        break;
    end;//for

    if not LExistConfig4AlarmHistory then
    begin
      AAlarmHistoryList.Items[j].ReleaseDateTime := now;
      DM1.UpdateAlarmOutTime2HistoryDB(AAlarmHistoryList.Items[j]);
    end;
  end;//for
end;

procedure TFormAlarmList.DeleteEngineParamterFromGrid(AIndex: integer);
begin
  FWG.FreeStrListFromGrid(AIndex);
//  DeleteFromTrend1Click(nil);
//  DeleteItem2pjhTagInfo(AIndex);
  FWG.NextGrid1.DeleteRow(AIndex);
  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Delete(AIndex);
end;

procedure TFormAlarmList.DeleteItem1Click(Sender: TObject);
var
  LUniqueName: string;
  LAlarmConfigItem: TAlarmConfigItem;
  LRow,i: integer;
begin
  if FProgramMode = 1 then
  begin
    ShowMessage('This menu can be used only Report Mode');
    exit;
  end;

  if MessageDlg('Alarm history will be deleted.' + #13#10 + 'Are you sure?',
                                mtConfirmation, [mbYes, mbNo], 0)= mrYes then
  begin
    LRow := FWG.NextGrid1.SelectedRow;
    LAlarmConfigItem := TAlarmConfigItem(AlarmListGrid.Row[LRow].Data);
    LUniqueName := DM1.GetUniqueTagName(LAlarmConfigItem); //UserId_Category_ProjNo_EngNo_TagName_AlarmType
    i := FAlarmStrList.IndexOf(LUniqueName);
    if i <> -1 then
    begin
      DM1.DeleteAlarmHistory(LAlarmConfigItem);
      FAlarmStrList.Delete(i);
    end;

    FAlarmHistoryCollect.Delete(LAlarmConfigItem.Index);
    FWG.DeleteGridItem;
  end;
end;

procedure TFormAlarmList.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.Free;
end;

procedure TFormAlarmList.DestroyVar;
begin
  FPJHTimerPool.RemoveAll;
  StopWorker;
  ServerLogOut;
  FJwsclFirewall.Free;
  FSettings.Free;
  IPCMonitorAll1.DestroyIPCMonitorAll;
  FEngineParameterTarget.Free;
  FEngParamSource.Free;

  //////////////////////////
  FAlarmConfig.Free;

  MonEngInfoDictClear;
  FMonitoringEngineList.Free;
  FAlarmHistoryCollect.Free;
  FAlarmStrList.Free;
  FAlarmStrListPerUser.Free;

  ClearAlarmConfigDic;
  FAlarmConfigDict.Free;
  FPJHTimerPool.Free;

  HttpStop;
end;

procedure TFormAlarmList.DisplayAlarm2ItemGrid(APIndex: integer;
  AColor: TColor);
var
  LCol, LRow: integer;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    LRow := FWG.NextGrid1.GetRowIndex(NextGridRow);
    for LCol := 0 to FWG.NextGrid1.Columns.Count - 1 do
    begin
      FWG.NextGrid1.Cell[LCol, LRow].Color := AColor;
    end;
  end;
end;

procedure TFormAlarmList.DisplayAlarmConfig2Grid(ACollect: TAlarmConfigCollect;
  AGrid: TNextGrid);
var
  i, LRow: integer;
begin
  with AGrid do
  begin
    BeginUpdate;
    ClearRows;
    try
      for i := 0 to ACollect.Count - 1 do
      begin
        LRow := AddRow;
        CellByName['Grp_ProjNo', LRow].AsString := ACollect.Items[i].EngType;
        CellByName['Grp_EngNo', LRow].AsString := ACollect.Items[i].EngNo;
        CellByName['Grp_CodeName', LRow].AsString := ACollect.Items[i].TagName;
      end;
    finally
      EndUpdate;
    end;
  end; //with
end;

procedure TFormAlarmList.DisplayMessage(msg: string);
begin
  FCS.DisplayMessage(msg, dtSystemLog);
end;

procedure TFormAlarmList.EnableAlphaCBClick(Sender: TObject);
begin
  AlphaBlend := EnableAlphaCB.Checked;
end;

procedure TFormAlarmList.est1Click(Sender: TObject);
begin
  TestDBInsert;
end;

procedure TFormAlarmList.FillInAlarmConfigList2Grid;
begin
  FACG.FillInAlarmCollect2GrpGrid(FAlarmConfig.AlarmConfigCollect);
end;

procedure TFormAlarmList.FillInAlarmHistoryList2Grid(ACollect: TAlarmConfigCollect);
var
  i: integer;
  LStr: string;
begin
  with AlarmListGrid do
  begin
    BeginUpdate;
    ClearRows;
    try
      for i := 0 to ACollect.Count - 1 do
      begin
        LStr := DM1.GetUniqueTagName(ACollect.Items[i]);//UserId_Category_ProjNo_EngNo_TagName_AlarmType
        AddAlarmItem2AlarmListGrid(LStr,ACollect.Items[i], DefaultAlarmListCellColor);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TFormAlarmList.FillInItemsGridFromEP;
var
  i,LCount: integer;
  LUniqueEng: string;
  LEngineParameterItem: TEngineParameterItem;
begin
//  MonEngInfoDictClear;
  FWG.NextGrid1.ClearRows;
  FWG.ClearCompountList;
  LCount := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count;

  for i := 0 to LCount - 1 do
  begin
    LEngineParameterItem := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i];
    //DisplayFormat 속성이 나중에 추가 되었기 때문에 적용 안된 WatchList파일의 경우 적용하기 위함
    if LEngineParameterItem.DisplayFormat = '' then
    begin
      LEngineParameterItem.DisplayFormat :=
        GetDisplayFormat(LEngineParameterItem.RadixPosition,
                        LEngineParameterItem.DisplayThousandSeperator);
    end;

//      if UpperCase(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) = 'DUMMY' then
//        continue;
    LUniqueEng := GetUniqueEngName(LEngineParameterItem.ProjNo,
      LEngineParameterItem.EngNo);

    if not FMonitoringEngineList.ContainsKey(LUniqueEng) then
    begin
      AddMonitoringEngInfo2List(LEngineParameterItem.ProjNo, LEngineParameterItem.EngNo);
    end;

    LEngineParameterItem.NextGridRow := nil;
    FWG.AddEngineParameter2Grid(i);
  end;

  JvStatusBar1.Panels[0].Text := IntToStr(LCount) + ' Rows';
end;

procedure TFormAlarmList.FillInItemValueFromEP;
var
  i: integer;
  LEP: TEngineParameterCollect;
begin
  LEP := IPCMonitorAll1.FEngineParameter.EngineParameterCollect;
  for i := 0 to LEP.Count - 1 do
  begin
    if LEP.Items[i].Alarm then //Analog
      WatchValue2Screen_Analog('','', i)
    else
      WatchValue2Screen_Digital('','',i);
  end;
end;

procedure TFormAlarmList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FMonitorStart := False;
  Timer1.Enabled := False;
  SaveWatchList(FSettings.ItemsFileName, False);
  DestroyVar;
end;

procedure TFormAlarmList.FormCreate(Sender: TObject);
var
  LUserId: string;
begin
  LUserId := ParamStr(1);
  DM1.InitUserInfo(LUserId);
  FProgramMode := 0;

  if DM1.FUserInfo.UserID <> '' then
  begin
    Caption := Caption + ' (사용자: ' + DM1.FUserInfo.UserName + ')';
    FProgramMode := 1;
  end;

  InitVar;
  StartWorker;

  FWG.NextGrid1.DoubleBuffered := False;
  AlarmListGrid.DoubleBuffered := False;
  dt_begin.Date := Now;
  dt_end.Date   := Now;
end;

procedure TFormAlarmList.FWGNextGrid1CustomDrawCell(Sender: TObject; ACol,
  ARow: Integer; CellRect: TRect; CellState: TCellState);
begin
  FWG.NextGrid1CustomDrawCell(Sender, ACol, ARow, CellRect, CellState);

  if TEngineParameterItem(FWG.NextGrid1.Row[ARow].Data).IsSimulateMode then
    FWG.NextGrid1.Cell[ACol, ARow].TextColor := $00E9FFD2;
end;

//procedure TFormAlarmList.GetFields2Grid(ADb: TSivak3Database;
//  ATableName: String; AGrid: TNextGrid);
//var
//  LnxTextColumn: TnxTextColumn;
//  LStrList: TStringList;
//  Li: integer;
//begin
//  LStrList := TStringList.Create;
//  try
//    ADb.GetFieldNames(LStrList, ATableName);
//
//    if LStrList.Count > 0 then
//    begin
//      with AGrid do
//      begin
//        ClearRows;
//        Columns.Clear;
//        //Columns.Add(TnxIncrementColumn,'No.');
//      end;
//    end;
//
//    for Li := 0 to LStrList.Count - 1 do
//    begin
//      with AGrid do
//      begin
//        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn, LStrList[Li]));
//        LnxTextColumn.Name := LStrList[Li];
//        LnxTextColumn.Header.Alignment := taCenter;
//        LnxTextColumn.Options := [coCanClick,coCanInput,coCanSort,coEditing,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
//      end;
//    end;
//  finally
//    LStrList.Free;
//  end;
//end;

procedure TFormAlarmList.GetAlarmConfigListFromDB;
var
  i, j: integer;
  LStr, LProj, LEng: string;
  LEngList: TStringList;
  LEP: TEngineParameterCollect;
  LMonitoringEngInfo: TMonitoringEngInfo;
  LUpdateItemsGrid: Boolean;
begin
//  FAlarmConfigDict.Clear;
  LUpdateItemsGrid := False;
  ClearAlarmConfigDic;
  FAlarmConfig.Clear;

  MonEngInfoDictClear;

  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    LStr := GetUniqueEngName(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ProjNo,
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].EngNo);

    if not FMonitoringEngineList.ContainsKey(LStr) then
    begin
      LMonitoringEngInfo := TMonitoringEngInfo.Create;
      LMonitoringEngInfo.ProjNo := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ProjNo;
      LMonitoringEngInfo.EngNo := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].EngNo;
      FMonitoringEngineList.Add(LStr, LMonitoringEngInfo);
    end;
  end;

  if FileExists(FSettings.RunConditionFileName) then
    FMonitoringEngineList.LoadFromFile(FSettings.RunConditionFileName);

  //Montoring Engine이 Fix 상태임
  if FProgramMode = 0 then //Report Mode
  begin
    if FMonitoringEngineList.Count > 0 then
      g_AlarmConfigEditing := True;

    try
      for LStr in FMonitoringEngineList.Keys do
      begin
        DM1.GetAlarmConfigFromDBPerEngine(DM1.OraQuery1, LStr);
        DM1.AssignAlarmConfig2Collect(DM1.OraQuery1, FAlarmConfig, FAlarmConfigDict,
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect, True);
      end;
    finally
      g_AlarmConfigEditing := False;
    end;
  end
  else
  //Montoring Engine이 User가 설정한 Config에 따라 결정됨
  if FProgramMode = 1 then //User Monitor Mode
  begin
    LEngList := TStringList.Create;
    try
      //FUserId로 설정된 모든 Alarm Config로 부터 LEngList(ProjNo;EngNo)를 가져옴
      DM1.GetEngineMonListFromUser(DM1.FUserInfo.UserID, LEngList);
      //위 함수에서 가져온 Alarm Config를 FAlarmConfig 및 FAlamrConfigDict에 저장함
      DM1.AssignAlarmConfig2Collect(DM1.OraQuery1, FAlarmConfig, FAlarmConfigDict,
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect, False);
      //기존 MonitoringEngineList에 신규 Config의 Engine List가 없으면 기존 EngParameter를 삭제함
      for LStr in FMonitoringEngineList.Keys do
      begin
        if LEngList.IndexOf(LStr) = -1 then
        begin
          LProj := FMonitoringEngineList[LStr].ProjNo;
          LEng := FMonitoringEngineList[LStr].EngNo;
//          IPCMonitorAll1.DeleteEngParamPerEngine(LProj, LEng);
          FWG.DeleteEngParamPerEngine(LProj, LEng);
          LUpdateItemsGrid := True;
        end;
      end;

      for j := 0 to LEngList.Count - 1 do
      begin
        LStr := LEngList.Strings[j];

        //기존 EngineParameterCollect에 없으면 DB로 부터 Param File 추가함
        if not FMonitoringEngineList.ContainsKey(LStr) then
        begin
          LProj := GetProjNo(LStr);
          LEng := GetEngNo(LStr);
          LEP := TEngineParameterCollect.Create(TEngineParameterItem);
          try
            //Engine Parameter File을 LEP에 가져옴
            DM1.SelectEngParamFileFromDB(LProj, LEng, LEP);
            //위에서 가져온 LEP를 FEngineparameter에 저장함
            IPCMonitorAll1.AppendEngParam(LEP);
            AddMonitoringEngInfo2List(LProj, LEng);
            LUpdateItemsGrid := True;
          finally
            LEP.Free;
          end;
        end;
        //FMonitoringEngineList.FMonTableName에 Measured_Data Table name을 저장함
        SetMonitoringTableListFromAlarmConfig;

        if LUpdateItemsGrid then
          FillInItemsGridFromEP;
      end;
    finally
      LEngList.Free;
    end;
  end;
end;

procedure TFormAlarmList.GetAlarmConfigListFromDB1Click(Sender: TObject);
begin
  GetAlarmConfigListFromDB;
  FillInAlarmConfigList2Grid;
end;

procedure TFormAlarmList.GetAlarmHistoryFromDB4NoReleased;
var
  LKey: string;
  LList: TList<TAlarmConfigItem>;
  LAlarmConfigItem: TAlarmConfigItem;
  i: integer;
  LStrList: TStringList;
  LAlarmConfigCollect: TAlarmConfigCollect;
begin
  LStrList := TStringList.Create;
  try
    //현재 PC에서 모니터링 중인 엔진의 Alarm History Table Name List 가져오기
    for LKey in FAlarmConfigDict.Keys do
    begin
      LList := FAlarmConfigDict.Items[Lkey];

      for i := 0 to LList.Count - 1  do
      begin
        LAlarmConfigItem := LList.Items[i];

        if LStrList.IndexOf(LAlarmConfigItem.AlarmHistoryTableName) = -1 then
          LStrList.Add(LAlarmConfigItem.AlarmHistoryTableName);
      end;//for
    end;//for

    LAlarmConfigCollect := TAlarmConfigCollect.Create(TAlarmConfigItem);
    try
      for i := 0 to LStrList.Count - 1 do
      begin
        LKey := LStrList.Strings[i];
        //Alarm History Table에서 Release 되지 않은 Alarm History 가져오기
        DM1.GetAlarmHistoryFromDB4NonReleased(LKey, LAlarmConfigCollect);
      end;

      UpdateAlarmOutTime2HistoryDB4UnConfigAlarm(LAlarmConfigCollect);
      FillInAlarmHistoryList2Grid(LAlarmConfigCollect);
    finally
      LAlarmConfigCollect.Free;
    end;
  finally
    LStrList.Free;
  end;
end;

function TFormAlarmList.GetFromDay(ADate: TDateTime): TDateTime;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(ADate, Year, Month, Day);
  Result := EncodeDate(Year, Month, Day);
end;

function TFormAlarmList.GetNeedAckSetValue(AEPIndex: integer;
  ASetType: TAlarmSetType): Boolean;
begin
  case ASetType of
    astDigital: Result := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultNeedAck;
    astLo: Result := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmNeedAck;
    astLoLo: Result := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultNeedAck;
    astHi: Result := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmNeedAck;
    astHiHi: Result := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultNeedAck;
  end;
end;

function TFormAlarmList.GetToDay(ADate: TDateTime): TDateTime;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(ADate + 1, Year, Month, Day);
  Result := EncodeDate(Year, Month, Day);
end;

function TFormAlarmList.GetUniqueTagName(APIndex: integer; ASetType: TAlarmSetType): string;
var
  LEngineParameterItem: TEngineParameterItem;
begin
  LEngineParameterItem := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex];
  //여러 엔진중  파라미터 tagname의 중복을 피하기 위해 ShardName 과 AlarmSetType을 추가함
  Result := LEngineParameterItem.ProjNo + '_' + LEngineParameterItem.EngNo + '_'  + LEngineParameterItem.TagName + '_'  +
            FAlarmSetTypeNames[ASetType];
//    TRttiEnumerationType.GetName<TAlarmSetType>(ASetType);
end;

procedure TFormAlarmList.GridAlarmUpdate(ARow: integer; ATime: TDateTime);
//var
//  i: integer;
//  LALR: TAlarmListRecord;
begin
//  for i := 0 to AlarmListGrid.RowCount - 1 do
//  begin
//    LALR := TAlarmListRecord(AlarmListGrid.Row[i].Data);
//
//    if AAlarmListRecord.FSeqNo = LALR.FSeqNo then
//    begin
//      AlarmListGrid.CellByName['ReleaseTime',i].AsString := FormatDateTime('yyyy-mm-dd hh:nn:ss', ATime);
//      break;
//    end;
//  end;
  AlarmListGrid.CellByName['ReleaseTime',ARow].AsString := FormatDateTime('yyyy-mm-dd hh:nn:ss', ATime);
end;

procedure TFormAlarmList.ServerLogIn;
var
  I: IAMSessionLog;
  LResult: Boolean;
  LKey, LId: string;
begin
  if not Assigned(FHTTPClient) then
    HttpStart;

  if not Assigned(FHTTPClient) then
  begin
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ServerLogIn Error => not Assigned(FHTTPClient)');
    exit;
  end;

  try
//    I := FHTTPClient.Service<IAlarmReport>;
    I := FHTTPClient.FHTTPClient.Service<IAMSessionLog>;
  except
    on E: Exception do
    begin
      I := nil;
      HttpStop;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ServerLogIn-FHTTPClient.Service<IAMSessionLog>');
      exit;
    end;
  end;

  try
    if I <> nil then   //AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl
    begin
      if DM1.FUserInfo.UserID <> '' then
        LResult := I.LogIn(DM1.FUserInfo.UserID, '', FCS.FIpAddr, DM1.FUserInfo.UserName, '', FCS.FURL)
      else
      begin
        LId := '';
        for Lkey in FMonitoringEngineList.Keys do
          LId := LId + LKey + ';';

        LResult := I.LogIn(LId, '', FCS.FIpAddr, LId, '', FCS.FURL);
      end;
    end;
  except
    on E: Exception do
    begin
      I := nil;
      HttpStop;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ServerLogIn-I.LogIn()');
      exit;
    end;
  end;

  if LResult then
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ServerLogIn-성공');
end;

procedure TFormAlarmList.ServerLogOut;
var
  I: IAMSessionLog;
  LResult: Boolean;
  LKey, LId: string;
begin
  if not Assigned(FHTTPClient) then
    HttpStart;

  if not Assigned(FHTTPClient) then
  begin
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ServerLogOut Error => not Assigned(FHTTPClient)');
    exit;
  end;

  if not FServerConnected then
  begin
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : Not Connected - ServerLogOut 실패');
    exit;
  end;

  try
//    I := FHTTPClient.Service<IAlarmReport>;
    I := FHTTPClient.FHTTPClient.Service<IAMSessionLog>;
  except
    on E: Exception do
    begin
      I := nil;
      HttpStop;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ServerLogOut-FHTTPClient.Service<IAMSessionLog>');
      exit;
    end;
  end;

  try
    if I <> nil then   //AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl
    begin
      if DM1.FUserInfo.UserID <> '' then
        LResult := I.LogOut(DM1.FUserInfo.UserID, '', FCS.FIpAddr, DM1.FUserInfo.UserName, '', FCS.FURL)
      else
      begin
        LId := '';
        for Lkey in FMonitoringEngineList.Keys do
          LId := LId + LKey + ';';

        try
          LResult := I.LogOut(LId, '', FCS.FIpAddr, LId, '', FCS.FURL);
        except

        end;
      end;
    end;
  except
    on E: Exception do
    begin
      I := nil;
      HttpStop;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ServerLogOut-I.LogOut()');
      exit;
    end;
  end;

  if LResult then
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ServerLogOut-성공');
end;

procedure TFormAlarmList.HttpStart;
begin
  try
//    if not CheckTCP_PortOpen(FSettings.ServerIP, StrToIntDef(FSettings.ServerPort, -1)) then
    if not IsPortActive(FSettings.ServerIP, StrToIntDef(FSettings.ServerPort, -1)) then
    begin
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' => Server(IP : ' +
        FSettings.ServerIP + ', Port: ' + FSettings.ServerPort + ') is not available!');
      exit;
    end;

//    if FModel = nil then
//      FModel := TSQLModel.Create([],'root');

//    FHTTPClient := TSQLHttpClient.Create(FSettings.ServerIP,FSettings.ServerPort, FModel);
    FHTTPClient := TmORMotHttpClient.Create(SERVER_ROOT_NAME,FSettings.ServerIP,FSettings.ServerPort);
    FHTTPClient.CreateHTTPClient;
//    if not FHTTPClient.ServerTimeStampSynchronize then
//    begin
//      exit;
//    end;

//    FHTTPClient.ServiceRegister([TypeInfo(IAlarmReport)], sicClientDriven);
    FHTTPClient.FHTTPClient.ServiceRegister([TypeInfo(IAlarmReport)], sicClientDriven);
    FServerConnected := True;
  except
    FServerConnected := False;
//    ShowMessage('');
  end;
end;

procedure TFormAlarmList.HttpStop;
begin
  if FServerConnected then
  begin
    FHTTPClient.Free;
    FServerConnected := False;
  end;
end;

procedure TFormAlarmList.InitAlarmList;
var
  LStr: string;
begin
  InitAlarmEnums;
  GetAlarmConfigListFromDB;
  FillInAlarmConfigList2Grid;
  GetAlarmHistoryFromDB4NoReleased;

  if FProgramMode = 1 then
    FGetItemValueFromDBHandle := FPJHTimerPool.Add(OnGetItemValueFromDB,
      StrToIntDef(FSettings.ItemValueSelectInterval, 1000));
//  LoadAlarmDataFromDB;
end;

procedure TFormAlarmList.InitSTOMP;
begin
  if FSettings.MQServerTopic = '' then
    FSettings.MQServerTopic := IPCMonitorAll1.GetEngineName;//'UniqueEngineName';

  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(FSettings.MQServerUserId,
                                            FSettings.MQServerPasswd,
                                            FSettings.MQServerIP,
                                            FSettings.MQServerTopic,
                                            Self.Handle);
  end;
end;

procedure TFormAlarmList.InitVar;
var
  LIni: string;
begin
  DM1.FIsClientMode := True; //ShowMessage출력 여부(서버에서는 출력하면 안됨)

  LIni := ChangeFileExt(Application.ExeName, '.ini');
  FSettings := TConfigSettings.create(LIni);

  if FileExists(LIni) then
    LoadConfigFromFile
  else
  begin
    DM1.GetServerInfo;
    FSettings.ServerIP := DM1.FServerInfo.IpAddr;
    FSettings.ServerPort := DM1.FServerInfo.PortNo;
    FSettings.MyPortNo := AMSREPORTER_PORTNO;
  end;

  if FSettings.ItemsFileName = '' then
    FSettings.ItemsFileName := ChangeFileExt(Application.ExeName, '.AlarmItem');
  FWatchListFileName := FSettings.ItemsFileName;

  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  SetCurrentDir(FFilePath);

  FWG.FCalculatedItemTimerHandle := -1;
  FWG.SetIPCMonitorAll(IPCMonitorAll1);
  FWG.SetStatusBar(JvStatusBar1);
  FWG.SetMainFormHandle(Handle);
  FWG.SetDeleteEngineParamterFromGrid(DeleteEngineParamterFromGrid);
  //Calculated Items을 계산하여 EngineParameter에 저장함
  FWG.SetWatchValue2Screen_Analog(WatchValue2Screen_Calculated);
  FWG.NextGrid1.DoubleBuffered := False;

  IPCMonitorAll1.FNextGrid := FWG.NextGrid1;
  IPCMonitorAll1.FPageControl := PageControl1;
  IPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;
  IPCMonitorAll1.FWatchValue2Screen_DigitalEvent := WatchValue2Screen_Digital;
  IPCMonitorAll1.SetValue2ScreenEvent_2(WatchValue2Screen_Analog2);

//  HttpStart;

  FPJHTimerPool := TPJHTimerPool.Create(nil);
//  FCalculatedItemTimerHandle := -1;
  FEngineParameterTarget := TEngineParameterDataFormat.Create(DropTextTarget1);
  FEngParamSource := TEngineParameterDataFormat.Create(EngParamSource2);
  FFirst := True;

  FAlarmConfigDict := TAlarmConfigDict.Create;
  FAlarmConfig := TAlarmConfig.Create(Self);
  FAlarmStrList := TStringList.Create;
  FAlarmStrListPerUser := TStringList.Create;
  FAlarmHistoryCollect := TAlarmConfigCollect.Create(TAlarmConfigItem);
  FMonitoringEngineList := TMonEngInfoDict.Create;

  FWG.SetProgramMode(pmAlarmList);
  FJwsclFirewall := TPJHJwsclFirewall.create;
  StartServer;
end;

function TFormAlarmList.IsAlarm(AAlarmSetType: TAlarmSetType; ASensorValue, ASetValue: Double): Boolean;
begin
  Result := False;

  case AAlarmSetType of
    astDigital: begin
      Result := Round(ASensorValue) = ASetValue;
    end;
    astLoLo: begin
      Result := ASensorValue < ASetValue;
    end;
    astLo: begin
      Result := ASensorValue < ASetValue;
    end;
    astHiHi: begin
      Result := ASensorValue > ASetValue;
    end;
    astHi: begin
      Result := ASensorValue > ASetValue;
    end;
  end;//case
end;

function TFormAlarmList.IsEngineRunning(AUniqueEngine: string): Boolean;
var
  LMonitoringEngInfo: TMonitoringEngInfo;
  LEPItem: TEngineParameterItem;
  i: integer;
  LValue: string;
  LDouble: double;
begin
  Result := False;

  if FMonitoringEngineList.ContainsKey(AUniqueEngine) then
  begin
    LMonitoringEngInfo := FMonitoringEngineList[AUniqueEngine];
    i := StrToIntDef(LMonitoringEngInfo.RunCondParamIndex, -1);

    if i > -1 then
    begin
      if i < IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count then
      begin
        LEPItem := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i];
        if LEPItem.IsSimulateMode then
          LValue := LEPItem.SimulateValue
        else
          LValue := LEPItem.Value;

        if LEPItem.Alarm then //Analog
          LDouble := StrToFloatDef(LValue, 0.0)
        else
          LDouble := StrToIntDef(LValue, 0);
//          LDouble := BoolToInt(StrToBoolDef(LValue, False));

        if LDouble > 0 then
          Result := True;
      end;
    end;
  end;
end;

procedure TFormAlarmList.JvTrackBar1Change(Sender: TObject);
begin
  if EnableAlphaCB.Checked then
    AlphaBlendValue := JvTrackBar1.Position;
end;

procedure TFormAlarmList.LoadAlarmDataFromDB;
var
  LSQLParamDict: TSQLParamDict;
  LValueList: TStringList;
  LSQL: string;
  i,j: integer;
begin
  LSQLParamDict := TSQLParamDict.Create;
  LValueList := TStringList.Create;
  try
    LSQL := 'select * from AlarmList where (IssueDateTime >= :Fromday and IssueDateTime <= :ToDay) or (ReleaseDateTime = 0)';
    LSQLParamDict.Add('Fromday', sptReal);
    LSQLParamDict.Add('ToDay', sptReal);
    LValueList.Add(FloatToStr(GetFromDay(now)));
    LValueList.Add(FloatToStr(GetToDay(now)));
    DB_Alarm_Select(LSQL, LSQLParamDict, LValueList);

//    if FQuery.Active then
//    begin
//      AlarmListGrid.ClearRows;
//
//      for i := 0 to FQuery.RecordCount - 1 do
//      begin
//        j := AlarmListGrid.AddRow();
//
//        TNxCheckBoxColumn(AlarmListGrid.Cell[0,j]).Visible := Boolean(FQuery.FieldByName('NeedAcked').AsInteger);
//
//        AlarmListGrid.Cells[CI_TIME_IN,i] := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',TDateTime(FQuery.Fields[3].AsFloat));
//
//        if FQuery.Fields[4].AsFloat > 0 then
//          AlarmListGrid.Cells[CI_TIME_OUT,i] := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',TDateTime(FQuery.Fields[4].AsFloat));
//
//        AlarmListGrid.Cells[CI_ENGINE_NO,i] := FQuery.Fields[1].AsString;
//        AlarmListGrid.Cells[CI_TAG_DESC,i] := FQuery.Fields[6].AsString;
//        AlarmListGrid.Cells[CI_ALARMMSG,i] := FQuery.Fields[7].AsString;
//        AlarmListGrid.Cells[CI_ALARMPRIO,i] := ArarmPriority2String(TAlarmPriority(FQuery.Fields[8].AsInteger));
//        FQuery.Next;
//      end;
//    end;
  finally
    LValueList.Free;
    LSQLParamDict.Free;
  end;
end;

procedure TFormAlarmList.LoadAlarmDataFromDB1Click(Sender: TObject);
begin
  LoadAlarmDataFromDB;
end;

procedure TFormAlarmList.LoadAlarmListConfig2Form(AForm: TAlarmListConfigF);
var
  LList: TList<TAlarmConfigItem>;
  LAlarmConfigItem: TAlarmConfigItem;
  LKey: string;
  i: integer;
begin
  AForm.FProgramMode := FProgramMode;

  if FProgramMode = 1 then //User Monitor Mode
  begin
    with AForm do
    begin
      AeroButton1.Visible := False;

      if DM1.FUserInfo.UserId <> '' then
      begin
        cb_dept.Enabled := False;
        cb_team.Enabled := False;
        cb_user.Enabled := False;
        cb_dept.Text := DM1.FUserInfo.DeptName;
        cb_dept.Tag := 1;
        cb_dept.Hint := DM1.FUserInfo.Dept_Cd;
        cb_team.Text := DM1.FUserInfo.TeamName;
        cb_team.Hint := DM1.FUserInfo.TeamNo;
        cb_team.Tag := 1;
        cb_user.Text := DM1.FUserInfo.UserName;
        cb_user.Hint := DM1.FUserInfo.UserID;
        cb_user.Tag := 1;
        AForm.FillInAlarmConfigList2Grid;
      end;
    end;
  end;
//  for LKey in FAlarmConfigDict.Keys do
//  begin
//    LList := FAlarmConfigDict.Items[Lkey];
//
//    for i := 0 to LList.Count - 1  do
//    begin
//      LAlarmConfigItem := LList.Items[i];
////      LAlarmConfigItem.EngType;
//    end;//for
//  end;//for

//  DisplayAlarmConfig2Grid();
end;

procedure TFormAlarmList.LoadAlarmListConfigForm2Object(
  AForm: TAlarmListConfigF);
begin
  if AForm.FUpdated then
  begin
    GetAlarmConfigListFromDB;
  end;
end;

procedure TFormAlarmList.LoadAlarmListConfigFromFile(AFileName: string);
begin

end;

procedure TFormAlarmList.LoadConfig2Form(AForm: TAlarmConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);

  if FSettings.RunConditionFileName = '' then //Run Condition List(rcl)
    FSettings.RunConditionFileName := ChangeFileExt(Application.ExeName, '.rcl');

  AForm.LoadRunConditionFromList(FMonitoringEngineList);
end;

procedure TFormAlarmList.LoadConfigForm2Object(AForm: TAlarmConfigF);
var
  i: integer;
  LKey: string;
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);

  if FSettings.RunConditionFileName = '' then
    FSettings.RunConditionFileName := ChangeFileExt(Application.ExeName, '.rcl');

  for i := 0 to AForm.RunConditionGrid.RowCount - 1 do
  begin
    LKey := GetUniqueEngName(AForm.RunConditionGrid.CellByName['ProjNo',i].AsString,
      AForm.RunConditionGrid.CellByName['EngNo',i].AsString);

    if FMonitoringEngineList.ContainsKey(LKey) then
    begin
      FMonitoringEngineList[LKey].RunCondTagName := AForm.RunConditionGrid.CellByName['TagName',i].AsString;
      FMonitoringEngineList[LKey].RunCondTagDesc := AForm.RunConditionGrid.CellByName['TagDesc',i].AsString;
      FMonitoringEngineList[LKey].RunCondParamIndex := AForm.RunConditionGrid.CellByName['ParamIndex',i].AsString;
    end;
  end;

  FMonitoringEngineList.SaveToFile(FSettings.RunConditionFileName);
//  AForm.SaveRunCondition2File(FSettings.RunConditionFileName);
end;

procedure TFormAlarmList.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);
end;

procedure TFormAlarmList.LoadWatchListFromFile(AFileName: string);
begin
  if FileExists(AFileName) then
  begin
    if FWG.NextGrid1.RowCount > 0 then
    begin
      if MessageDlg('Do you want to apppend the watch list to the grid?',
                                mtConfirmation, [mbYes, mbNo], 0)= mrYes then
      begin
        FWG.AppendEngineParameterFromFile(AFileName, 1, False, False);
      end
      else
      begin
        if MessageDlg('Are you sure overwrite the existing items ?',
                                mtConfirmation, [mbYes, mbNo], 0)= mrYes then
        begin
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
          FWG.FCompoundItemList.clear;
          IPCMonitorAll1.FEngineParameter.LoadFromJSONFile(AFileName,
                    ExtractFileName(AFileName),False);
        end
        else
          exit;
      end;

      FWG.NextGrid1.ClearRows;
    end
    else
    begin
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
      FWG.FCompoundItemList.clear;
      IPCMonitorAll1.FEngineParameter.LoadFromJSONFile(AFileName,
                ExtractFileName(AFileName),False);
    end;

    FillInItemsGridFromEP;
  end;
end;

procedure TFormAlarmList.LoadWatchListFromFile1Click(Sender: TObject);
begin
  if FProgramMode = 1 then
  begin
    ShowMessage('This menu can be used only Report Mode');
    exit;
  end;

  SetCurrentDir(FFilePath);
  JvOpenDialog1.InitialDir := WatchListPath;
  JvOpenDialog1.Filter := '*.*';

  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      FWatchListFileName := jvOpenDialog1.FileName;
      LoadWatchListFromFile(FWatchListFileName);
      InitAlarmList;
    end;
  end;
end;

procedure TFormAlarmList.MonEngInfoDictClear;
var
  LKey: string;
begin
  for LKey in FMonitoringEngineList.Keys do
    FMonitoringEngineList[LKey].Free;

  FMonitoringEngineList.Clear;
end;

procedure TFormAlarmList.NotifyAlarmConfigChanged2Server(AIsUseMQ: Boolean);
var
  I: IAlarmConfig;
  LUniqueName, LUrl: String;
//  LResult: Boolean;
  Li: integer;
  LDynArr: TDynArray;
  LRawUTF8DynArray: TRawUTF8DynArray;
  LCount: integer;
  LStrList: TStringList;
  LRawUTF8: RawUTF8;

  procedure GetConfigCollect;
  begin
    LStrList := TStringList.Create;
    LDynArr.Init(TypeInfo(TRawUTF8DynArray),LRawUTF8DynArray,@LCount);
    try
      if FAlarmConfig.AlarmConfigCollect.Count = 0 then
      begin
        LUniqueName := DM1.FUserInfo.UserID + ';' + 'Default;;;' + 'DELETE';
        LStrList.Add(LUniqueName);
      end;

      for Li := 0 to FAlarmConfig.AlarmConfigCollect.Count - 1 do
      begin
        LUniqueName := FAlarmConfig.AlarmConfigCollect.Items[Li].UserID + ';' +
          FAlarmConfig.AlarmConfigCollect.Items[Li].Category + ';' +
          FAlarmConfig.AlarmConfigCollect.Items[Li].ProjNo + ';' +
          FAlarmConfig.AlarmConfigCollect.Items[Li].EngNo + ';';

        if LStrList.IndexOf(LUniqueName) = -1 then
          LStrList.Add(LUniqueName);
      end;

      for Li := 0 to LStrList.Count - 1 do
      begin
        LRawUTF8 := StringToUTF8(LStrList.Strings[Li]);
        LDynArr.Add(LRawUTF8);
      end;

    finally
      Li := LStrList.Count;
      LStrList.Free;
    end;

    LUrl := FCS.FURL;  //자기 자신이 보낸 Notify는 skip하기 위함
  end;
begin
  if AIsUseMQ then
  begin
    GetConfigCollect;
    LDynArr.SaveToJSON;
  end
  else
  begin
    if not Assigned(FHTTPClient) then
      HttpStart;

    if not Assigned(FHTTPClient) then
    begin
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : NotifyAlarmConfigChanged2Server Error => not Assigned(FHTTPClient)');
      exit;
    end;

    try
      I := FHTTPClient.FHTTPClient.Service<IAlarmConfig>;
    except
      on E: Exception do
      begin
        I := nil;
        HttpStop;
        DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
        DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : NotifyAlarmConfigChanged2Server-FHTTPClient.Service<IAlarmReport>');
        exit;
      end;
    end;

    try
      if I <> nil then
      begin
        GetConfigCollect;
        I.NotifyAlarmConfigChanged(LRawUTF8DynArray, Li, LUrl);
      end;
    except
      on E: Exception do
      begin
        I := nil;
        HttpStop;
        DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
        DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : NotifyAlarmConfigChanged2Server-I.AddAlarmCollect(AAlarmCollect)');
        exit;
      end;
    end;
  end;

//  if LResult then
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : NotifyAlarmConfigChanged2Server-성공');
end;

procedure TFormAlarmList.OnGetItemValueFromDB(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  LKey, LStr: string;
begin
  FPJHTimerPool.Enabled[Handle] := False;
  try
    for LKey in FMonitoringEngineList.Keys do
    begin
      LStr := GetUniqueEngName(FMonitoringEngineList[LKey].ProjNo,FMonitoringEngineList[LKey].EngNo);
      LStr := LStr + ';' + FMonitoringEngineList[LKey].MonTableName;
      DM1.GetEngParamDataFromDB(LStr, IPCMonitorAll1.FEngineParameter.EngineParameterCollect);
      FillInItemValueFromEP;
    end;
  finally
    FPJHTimerPool.Enabled[Handle] := True;
  end;
end;

procedure TFormAlarmList.ProcessResults;
var
  msg: TOmniMessage;
  rec: TDispMsgRecord;
  rec2: TChgNotifyRecord;
  LMsg, LMsg2: string;
  LTarget: TDisplayTarget;
begin
  while FResponseQueue.TryDequeue(msg) do
  begin
    case msg.MsgID of
      0: begin
        rec := msg.MsgData.ToRecord<TDispMsgRecord>;
        LMsg := rec.FMsg;
        LTarget := rec.FDspTarget;

        FCS.DisplayMessage(DateTimeToStr(now) + ': ' + LMsg, LTarget);
      end;
      1: begin
        rec2 := msg.MsgData.ToRecord<TChgNotifyRecord>;
        LMsg := rec2.FUniqueEngine;
        LMsg2 := rec2.FSendUrl;
        AlarmConfigChangedPerEngine(LMsg, LMsg2);
      end;
    end;
  end;
end;

procedure TFormAlarmList.ReleaseAlarm4Analog(AEPIndex: integer;
  AUniqueTagName: string; AAlarmStrList: TStringList);
var
  i,j,LRow: integer;
  LAlarmConfigItem: TAlarmConfigItem;
  LGridRow: TRow;
  LDate: TDateTime;
  LAlarmListRecord: TAlarmListRecord;
begin
  j := AAlarmStrList.IndexOf(AUniqueTagName);//UserId_Category_ProjNo_EngNo_TagName_AlarmType
  if j > -1 then
  begin
    LGridRow := TRow(AAlarmStrList.Objects[j]);
    LAlarmConfigItem := TAlarmConfigItem(LGridRow.Data);

    if (not LAlarmConfigItem.NeedAck) or
      ((LAlarmConfigItem.NeedAck) and (LAlarmConfigItem.AcknowledgedTime <> 0)) then
    begin
      //Alarm 해제
      case TAlarmSetType(i) of
        astDigital: IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmStartTime := 0;
        astLo: IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmStartTime := 0;
        astLoLo: IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultStartTime := 0;
        astHi: IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmStartTime := 0;
        astHiHi: IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultStartTime := 0;
      end;

      LDate := Now;
      LRow := AlarmListGrid.GetRowIndex(LGridRow);
      GridAlarmUpdate(LRow, LDate);
      LAlarmConfigItem.ReleaseDateTime := LDate;
      AAlarmStrList.Delete(j);
      AlarmConfigItem2AlarmListRecord(LAlarmConfigItem, LAlarmListRecord);

      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].IsSimulateMode then
        LAlarmListRecord.FSensorValue := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].SimulateValue
      else
        LAlarmListRecord.FSensorValue := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;

      if FProgramMode = 0 then
      begin
        LAlarmListRecord.FAlarmAction := aaAlarmRelease;
        UpdateAlarmOutTime2DB(LAlarmConfigItem);
        SendReleaseAlarm2Server(LAlarmListRecord);
      end;

      if (LRow > -1) and (LRow < AlarmListGrid.RowCount) then
      begin
        for j := 0 to AlarmListGrid.Columns.Count - 1 do
          AlarmListGrid.Cell[j, LRow].Color := DefaultAlarmListCellColor;
      end;

      DisplayAlarm2ItemGrid(AEPIndex, DefaultAlarmListCellColor);
    end;
  end;
end;

procedure TFormAlarmList.ReleaseSimulateMode1Click(Sender: TObject);
begin
  if FWG.NextGrid1.Row[FWG.NextGrid1.SelectedRow].Selected then
  begin
    TEngineParameterItem(FWG.NextGrid1.Row[FWG.NextGrid1.SelectedRow].Data).IsSimulateMode := False;
  end;
end;

procedure TFormAlarmList.ReleaseSimulateModeAll1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    TEngineParameterItem(FWG.NextGrid1.Row[i].Data).IsSimulateMode := False;
  end;
end;

procedure TFormAlarmList.AckChange(Sender: TObject);
var
  LRow: integer;
begin
  LRow := AlarmListGrid.SelectedRow;

  if AlarmListGrid.CellByName['Ack', LRow].AsBoolean then
  begin
    AlarmAcknowledge(LRow);
  end
  else
    AlarmListGrid.CellByName['Ack', LRow].AsBoolean := True;
end;

procedure TFormAlarmList.rg_periodClick(Sender: TObject);
begin
  dt_begin.Enabled := False;
  dt_end.Enabled   := False;
  case rg_period.ItemIndex of
    0 :
    begin
      dt_begin.Date := Now;
      dt_end.Date   := Now;
    end;
    1 :
    begin
      dt_begin.Date := StartOfTheWeek(Now);
      dt_end.Date   := EndOfTheWeek(Now);
    end;
    2 :
    begin
      dt_begin.Date := StartOfTheMonth(Now);
      dt_end.Date   := EndOfTheMonth(Now);
    end;
    3 :
    begin
      dt_begin.Enabled := True;
      dt_end.Enabled   := True;
    end;
  end;
end;


procedure TFormAlarmList.SaveWatchList(AFileName: string;
  ASaveWatchListFolder: Boolean);
var
  i, LChCount: integer;
  LStr, LWatchListPath: string;
begin
  if ASaveWatchListFolder then
    LWatchListPath := WatchListPath
  else
    LWatchListPath := '';

  IPCMonitorAll1.FEngineParameter.ExeName := ExtractFileName(Application.ExeName);
  IPCMonitorAll1.FEngineParameter.FormWidth := Width;
  IPCMonitorAll1.FEngineParameter.FormHeight := Height;
  IPCMonitorAll1.FEngineParameter.FormTop := Top;
  IPCMonitorAll1.FEngineParameter.FormLeft := Left;
  IPCMonitorAll1.FEngineParameter.FormState := TpjhWindowState(WindowState);
  IPCMonitorAll1.FEngineParameter.BorderShow := BorderStyle <> TFormBorderStyle.bsNone;

  LStr := LWatchListPath+AFileName;
  IPCMonitorAll1.FEngineParameter.SaveToJSONFile(LStr,ExtractFileName(LStr),False);
end;

procedure TFormAlarmList.SaveWatchLittoNewName1Click(Sender: TObject);
var
  LFileName: string;
begin
  SetCurrentDir(FFilePath);
  JvSaveDialog1.InitialDir := WatchListPath;

  if JvSaveDialog1.Execute then
  begin
    LFileName := JvSaveDialog1.FileName;

    if FileExists(LFileName) then
    begin
      if MessageDlg('File is already existed. Are you overwrite? if No press, then the data is not saved!.',
      mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        exit;
    end;
  end;

  SaveWatchList(LFileName, False);
end;

procedure TFormAlarmList.SendAlarm2Server(AAlarmRecord: TAlarmListRecord);
var
  I: IAlarmReport;
  LResult: Boolean;
begin
  if not Assigned(FHTTPClient) then
    HttpStart;

  if not Assigned(FHTTPClient) then
  begin
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : SendAlarm2Server Error => not Assigned(FHTTPClient)');
    exit;
  end;

  try
//    I := FHTTPClient.Service<IAlarmReport>;
    I := FHTTPClient.FHTTPClient.Service<IAlarmReport>;
  except
    on E: Exception do
    begin
      I := nil;
      HttpStop;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : SendAlarm2Server-FHTTPClient.Service<IAlarmReport>');
      exit;
    end;
  end;

  try
    if I <> nil then
      LResult := I.AddAlarmRecord(AAlarmRecord);
  except
    on E: Exception do
    begin
      I := nil;
      HttpStop;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : SendAlarm2Server-I.AddAlarmCollect(AAlarmCollect)');
      exit;
    end;
  end;

  if LResult then
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : SendAlarm2Server-성공');
end;

procedure TFormAlarmList.SendReleaseAlarm2Server(
  AAlarmRecord: TAlarmListRecord);
var
  I: IAlarmReport;
  LResult: Boolean;
begin
  if not Assigned(FHTTPClient) then
    HttpStart;

  if not Assigned(FHTTPClient) then
  begin
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : SendReleaseAlarm2Server Error => not Assigned(FHTTPClient)');
    exit;
  end;

  try
    I := FHTTPClient.FHTTPClient.Service<IAlarmReport>;
  except
    on E: Exception do
    begin
      I := nil;
      HttpStop;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : SendReleaseAlarm2Server-FHTTPClient.Service<IAlarmReport>');
      exit;
    end;
  end;

  try
    if I <> nil then
      LResult := I.ReleaseAlarmRecord(AAlarmRecord);
  except
    on E: Exception do
    begin
      I := nil;
      HttpStop;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : SendReleaseAlarm2Server-I.AddAlarmCollect(AAlarmCollect)');
      exit;
    end;
  end;

  if LResult then
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : SendReleaseAlarm2Server-성공');
end;

procedure TFormAlarmList.SetAlarmDisable1Click(Sender: TObject);
begin
  SetAlarmEnable(False);
end;

procedure TFormAlarmList.SetAlarmEnable(AEnable: Boolean);
var
  i: integer;
begin
  FAlarmSetDoing := True;

  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.Row[i].Selected then
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].AlarmEnable := AEnable;
  end;

  ShowMessage('Selected Item''s AlarmEnable set to ''' + BoolToStr(AEnable, true) + ''' is finished');
  FAlarmSetDoing := False;
end;

procedure TFormAlarmList.SetAlarmEnable1Click(Sender: TObject);
begin
  SetAlarmEnable(True);
end;

procedure TFormAlarmList.SetAlarmListConfig;
var
  LConfigF: TAlarmListConfigF;
begin
  LConfigF := TAlarmListConfigF.Create(Self);

  try
    LoadAlarmListConfig2Form(LConfigF);

    if LConfigF.ShowModal = mrOK then
    begin
      //설정이 변경 되었으므로 Alarm Config를 DB에서 다시 가져옴
      LoadAlarmListConfigForm2Object(LConfigF);
      //서버에 변경 통보하고 Alamr Config List Grid 갱신함
      ApplyUI;
    end;
  finally
    LConfigF.Free;
  end;
end;

procedure TFormAlarmList.SetConfig;
var
  LConfigF: TAlarmConfigF;
begin
  LConfigF := TAlarmConfigF.Create(Self);

  if FProgramMode = 1 then
    FPJHTimerPool.Enabled[FGetItemValueFromDBHandle] := False;
  try
    LoadConfig2Form(LConfigF);

    if LConfigF.ShowModal = mrOK then
    begin
      LoadConfigForm2Object(LConfigF);
      FSettings.Save();
      FillInAlarmConfigList2Grid;
    end;
  finally
    if FProgramMode = 1 then
    begin
      FPJHTimerPool.Interval[FGetItemValueFromDBHandle] := StrToIntDef(FSettings.ItemValueSelectInterval, 1000);
      FPJHTimerPool.Enabled[FGetItemValueFromDBHandle] := True;
    end;

    LConfigF.Free;
  end;
end;

procedure TFormAlarmList.SetMonitoringTableListFromAlarmConfig;
var
  i: integer;
  LKey, LProjNo, LEngNo: string;
begin
  for i := 0 to FAlarmConfig.AlarmConfigCollect.Count - 1 do
  begin
    LProjNo := FAlarmConfig.AlarmConfigCollect.Items[i].ProjNo;
    LEngNo := FAlarmConfig.AlarmConfigCollect.Items[i].EngNo;

    LKey := GetUniqueEngName(LProjNo, LEngNo);

    if FMonitoringEngineList.ContainsKey(LKey) then
      FMonitoringEngineList[LKey].MonTableName := FAlarmConfig.AlarmConfigCollect.Items[i].MonTableName;
  end;
end;

procedure TFormAlarmList.SetSimulateMode1Click(Sender: TObject);
begin
  if FWG.NextGrid1.Row[FWG.NextGrid1.SelectedRow].Selected then
  begin
    TEngineParameterItem(FWG.NextGrid1.Row[FWG.NextGrid1.SelectedRow].Data).IsSimulateMode := True;
  end;
end;

procedure TFormAlarmList.SetValueTo1Click(Sender: TObject);
var
  LSimulatedValueInputF: TSimulatedValueInputF;
begin
  if FWG.NextGrid1.Row[FWG.NextGrid1.SelectedRow].Selected then
  begin
    if TEngineParameterItem(FWG.NextGrid1.Row[FWG.NextGrid1.SelectedRow].Data).AlarmEnable then
    begin
      LSimulatedValueInputF := TSimulatedValueInputF.Create(nil);
      try
        LSimulatedValueInputF.SimValueEdit.Text := TEngineParameterItem(FWG.NextGrid1.Row[FWG.NextGrid1.SelectedRow].Data).SimulateValue;
        if LSimulatedValueInputF.ShowModal = mrOK then
        begin
          TEngineParameterItem(FWG.NextGrid1.Row[FWG.NextGrid1.SelectedRow].Data).IsSimulateMode := True;
          TEngineParameterItem(FWG.NextGrid1.Row[FWG.NextGrid1.SelectedRow].Data).SimulateValue := LSimulatedValueInputF.SimValueEdit.Text;
        end;
      finally
        LSimulatedValueInputF.Free;
      end;
      //PulseEvent
    end
    else
      ShowMessage('This item is not AlarmEnabled.' + #13#10 +
        'If you want to set the simulateValue, then Check the AlarmEnable on General Tab');
  end;
end;

procedure TFormAlarmList.ShowCalculatedListCount1Click(Sender: TObject);
begin
  ShowMessage(IntToStr(FWG.FCompoundItemList.Count));
end;

procedure TFormAlarmList.StartServer;
begin
  if CheckPortOpenOnFireWall(StrToInt(FSettings.MyPortNo)) then
  begin
    FCS.CreateHttpServer(MY_SERVICE_ROOT_NAME, 'AMSReporter.json', FSettings.MyPortNo, TServiceAMSReportCB,
      [TypeInfo(IAlarmReportCallBack)], sicClientDriven , True);//sicClientDriven
    FCS.ServerStartBtnClick(nil);
  end;
end;

procedure TFormAlarmList.StartWorker;
begin
  FCommandQueue := TOmniMessageQueue.Create(1000);

  FResponseQueue := TOmniMessageQueue.Create(1000, false);
  FResponseObserver := CreateContainerWindowsMessageObserver(Handle, MSG_RESULT_PROCESS, 0, 0);
  FResponseQueue.ContainerSubject.Attach(FResponseObserver, coiNotifyOnAllInserts);

  FWorker := TWorker.Create(FCommandQueue, FResponseQueue);
end;

procedure TFormAlarmList.StayOnTopCBClick(Sender: TObject);
begin
  if StayOnTopCB.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TFormAlarmList.StopWorker;
begin
  if assigned(FWorker) then begin
    TWorker(FWorker).Stop;
    FWorker.WaitFor;
    FreeAndNil(FWorker);
  end;

  if assigned(FResponseQueue) then begin
    FResponseQueue.ContainerSubject.Detach(FResponseObserver, coiNotifyOnAllInserts);
    FreeAndNil(FResponseObserver);
    ProcessResults;
    FreeAndNil(FResponseQueue);
  end;

  FreeAndNil(FCommandQueue);
end;

procedure TFormAlarmList.TestDBInsert;
var
  LSQL: string;
begin
end;

procedure TFormAlarmList.Timer1Timer(Sender: TObject);
var
  i,j: integer;
  LStr: string;
begin
  Timer1.Enabled := False;
  try
    if FFirst then
    begin
      FFirst := False;
      for i := 1 to ParamCount do
      begin
        LStr := UpperCase(ParamStr(i));

        j := Pos('/P', LStr); //parameter file name
        if j > 0 then  //P 제거
        begin
          LStr := Copy(LStr, j+2, Length(LStr)-j-1);
          FWatchListFileName := LStr;
        end;
      end;//for

      LoadWatchListFromFile(FWatchListFileName);
      InitAlarmList;
      ServerLogIn;
    end;//if FFirst

  finally
    //Timer1.Enabled := True;
  end;

end;

procedure TFormAlarmList.UpdateGridRowIndexFromRecord(AIsInc: Boolean);
var
  i: integer;
  LAlarmListRecord: TAlarmConfigItem;
begin
  for i := 1 to FAlarmStrList.Count - 1 do
  begin
    LAlarmListRecord := FAlarmStrList.Objects[i] as TAlarmConfigItem;
//    if AIsInc then
//      Inc(LAlarmListRecord.Index)
//    else
//      Dec(LAlarmListRecord.FGridRowIndex);
  end;
end;

procedure TFormAlarmList.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer);
begin
  if g_AlarmConfigEditing then
    exit;

  try
    case StrToIntDef(FSettings.ConfigSource,0) of
      0: CheckAlarmFromAlarmConfig(AEPIndex);
      1: CheckAlarmFromEngineParameterConfig(AEPIndex);
    end; //case
  finally
    case PageControl1.ActivePageIndex of
      0: begin //Items
          FWG.NextGrid1.CellsByName['Value', AEPIndex] :=
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
      end;
    end;
  end;
end;

procedure TFormAlarmList.WatchValue2Screen_Analog2;
begin

end;

procedure TFormAlarmList.WatchValue2Screen_Calculated(Name, AValue: string;
  AEPIndex: integer);
begin
  case PageControl1.ActivePageIndex of
    0: begin //Items
        FWG.NextGrid1.CellsByName['Value', AEPIndex] :=
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
    end;
  end;
end;

procedure TFormAlarmList.WatchValue2Screen_Digital(Name, AValue: string;
  AEPIndex: integer);
var
  i: integer;
  LEPItem: TEngineParameterItem;
begin
  if g_AlarmConfigEditing then
    exit;

  LEPItem := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex];

  if LEPItem.AlarmEnable then
  begin
//    if LEPItem.Value <> '0' then => B접점 인 경우에는 0이 알람이므로 이 조건은 맞지 않음
//      AddAlarm2List(AEPIndex, astDigital, StrToIntDef(FSettings.ConfigSource,0));
  end;

  try
    case StrToIntDef(FSettings.ConfigSource,0) of
      0: CheckAlarmFromAlarmConfig(AEPIndex);
      1: CheckAlarmFromEngineParameterConfig(AEPIndex);
    end; //case
  finally
    case PageControl1.ActivePageIndex of
      0: begin //Items
        if LEPItem.Value <> '0' then
          FWG.NextGrid1.CellsByName['Value', AEPIndex] := 'False'
        else
          FWG.NextGrid1.CellsByName['Value', AEPIndex] := 'True';
      end;
    end;
  end;
end;

procedure TFormAlarmList.WMCopyData(var Msg: TMessage);
var
  LDragCopyMode: TParamDragCopyMode;
begin
  case Msg.WParam of
    0: begin
      LDragCopyMode := PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^.FParamDragCopyMode;

      if LDragCopyMode <> dcmCopyCancel then //HiMECS에서 모드가 전송 되어 오는 경우

      else//마우스로 모드 선택하는 경우
        LDragCopyMode := FWG.FDragCopyMode;

      FWG.CreateIPCMonitor(TEngineParameterItemRecord((PCopyDataStruct(Msg.LParam)^.lpData)^), LDragCopyMode);
    end;
    1: begin
//      ChangeAlarmListMode;
    end;
    2: begin

    end;

  end;
end;

procedure TFormAlarmList.WMDisplayMessage(var Msg: TMessage);
var
//  LRec: TDispMsgRecord;
  LOmniValue: TOmniValue;
begin
//  FCS.DisplayMessage(FDisplayMessage, dtSystemLog);
end;

procedure TFormAlarmList.WorkerResult(var msg: TMessage);
begin
  ProcessResults;
end;

procedure TFormAlarmList.CheckMaxFault(APIndex: integer; AUniqueTagName: string;
  AAlarmConfigItem: TAlarmConfigItem);
var
  LDelay: TDateTime;
  LGridRow: TRow;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if AAlarmConfigItem.Delay > 0 then
    begin
      //Alarm Delay
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime = 0 then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime := now;
        exit;
      end
      else
      begin
        LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MaxFaultStartTime;

        //Delay 시간이 경과 하지 않은 경우
        if LDelay < AAlarmConfigItem.Delay then
          exit;
      end;
    end;

    if AAlarmConfigItem.AlarmMessage = '' then
      AAlarmConfigItem.AlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + ' High Fault';

//    AAlarmConfigItem.AlarmSetType := astHiHi;
    if MaxFaultColor = 0 then
      MaxFaultColor := DefaultMaxFaultColor;

    AddData2AlarmListMap(APIndex,AUniqueTagName,AAlarmConfigItem, MaxFaultColor);
  end;//with
end;

procedure TFormAlarmList.CheckMaxWarn(APIndex: integer; AUniqueTagName: string;
  AAlarmConfigItem: TAlarmConfigItem);
var
  LDelay: TDateTime;
  LGridRow: TRow;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if AAlarmConfigItem.Delay > 0 then
    begin
      //Alarm Delay
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime = 0 then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime := now;
        exit;
      end
      else
      begin
        LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime;

        //Delay 시간이 경과 하지 않은 경우
        if LDelay < AAlarmConfigItem.Delay then
          exit;
      end;
    end;

    if AAlarmConfigItem.AlarmMessage = '' then
      AAlarmConfigItem.AlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + ' High Alarm';

//    AAlarmConfigItem.AlarmSetType := astHi;
    if MaxAlarmColor = 0 then
      MaxAlarmColor := DefaultMaxAlarmColor;

    AddData2AlarmListMap(APIndex,AUniqueTagName,AAlarmConfigItem, MaxAlarmColor);
  end;//with
end;

procedure TFormAlarmList.CheckMinFault(APIndex: integer; AUniqueTagName: string;
  AAlarmConfigItem: TAlarmConfigItem);
var
  LDelay: TDateTime;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if AAlarmConfigItem.Delay > 0 then
    begin
      //Alarm Delay
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime = 0 then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime := now;
        exit;
      end
      else
      begin
        LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime;

        //Delay 시간이 경과 하지 않은 경우
        if LDelay < AAlarmConfigItem.Delay then
          exit;
      end;
    end;

    if AAlarmConfigItem.AlarmMessage = '' then
      AAlarmConfigItem.AlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + ' Low Fault';

//    AAlarmConfigItem.AlarmSetType := astLoLo;
    if MinFaultColor = 0 then
      MinFaultColor := DefaultMinFaultColor;

    AddData2AlarmListMap(APIndex,AUniqueTagName,AAlarmConfigItem, MinFaultColor);
  end;//with
end;

procedure TFormAlarmList.CheckMinWarn(APIndex: integer; AUniqueTagName: string;
  AAlarmConfigItem: TAlarmConfigItem);
var
  LDelay: TDateTime;
  LGridRow: TRow;
begin
  with IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if AAlarmConfigItem.Delay > 0 then
    begin
      //Alarm Delay
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime = 0 then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime := now;
        exit;
      end
      else
      begin
        LDelay := now - IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].MinFaultStartTime;

        //Delay 시간이 경과 하지 않은 경우
        if LDelay < AAlarmConfigItem.Delay then
          exit;
      end;
    end;

    if AAlarmConfigItem.AlarmMessage = '' then
      AAlarmConfigItem.AlarmMessage := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + ' Low Alarm';

//    AAlarmConfigItem.AlarmSetType := astLo;
    if MinAlarmColor = 0 then
      MinAlarmColor := DefaultMinAlarmColor;

    AddData2AlarmListMap(APIndex,AUniqueTagName,AAlarmConfigItem, MinAlarmColor);
  end;//with
end;

function TFormAlarmList.CheckPortOpenOnFireWall(APortNo: integer): Boolean;
var
  LStr: string;
  LPort: integer;
begin
  Result := False;

  LStr := ExtractFileName(Application.ExeName);
  LPort := StrToInt(FSettings.MyPortNo);
  Result := DoIsTCPPortAllowed(LPort, FCS.FIpAddr);
  if not Result then
//  if not FJwsclFirewall.IsAppRulePresent(Application.ExeName) then
  begin
    DisplayMessage('이 컴퓨터의 Port(' + FSettings.MyPortNo + ') 가 방화벽에 막혀 있어서 강제로 오픈 합니다.');
//    FJwsclFirewall.PJHAddTcpPortToFirewall(LStr, LPort, NET_FW_SCOPE_ALL);
    FJwsclFirewall.AddTcpPortToFirewall(LStr, LPort);
    GetRulesFromFirewall(LStr);

    Result := True;
  end
  else
    DisplayMessage('이 컴퓨터의 Port(' + FSettings.MyPortNo + ') 가 오픈 되어 있습니다.');
//  LPort := StrToInt(FSettings.MyPortNo);
//  Result := DoIsTCPPortAllowed(LPort, FCS.FIpAddr);
//
//  if not Result then
//  begin
//    LStr := ExtractFileName(Application.ExeName);
//    DoAddExceptionToFirewall(LStr, Application.ExeName, LPort);
//    Result := True;
//  end;
end;

{ TServiceAMSReportCB }

function TServiceAMSReportCB.AlarmConfigChangedPerEngine(
  UniqueEngine: RawUTF8; SenderUrl: string): Boolean;
var
  LOmniValue: TOmniValue;
  LChgNotifyRecord: TChgNotifyRecord;
begin
  Result := False;

  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    LChgNotifyRecord.FUniqueEngine := UTF8ToString(UniqueEngine);
    LChgNotifyRecord.FSendUrl := SenderUrl;
    LOmniValue := TOmniValue.FromRecord<TChgNotifyRecord>(LChgNotifyRecord);

    if not FormAlarmList.FCommandQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
      raise Exception.Create('Command queue is full!');
  finally
    g_ServiceQuerying := False;
  end;

  Result := True;
end;

{ TWorker }

constructor TWorker.Create(commandQueue, responseQueue: TOmniMessageQueue);
begin
  inherited Create;
  FCommandQueue := commandQueue;
  FResponseQueue := responseQueue;
  FStopEvent := TEvent.Create;
end;

destructor TWorker.Destroy;
begin
  FreeAndNil(FStopEvent);
  inherited;
end;

procedure TWorker.Execute;
var
  handles: array [0..1] of THandle;
  msg    : TOmniMessage;
  rec    : TDispMsgRecord;
//  LOmniValue: TOmniValue;
begin
//  CoInitialize(nil);
//  try
    handles[0] := FStopEvent.Handle;
    handles[1] := FCommandQueue.GetNewMessageEvent;
    while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
    begin
      while FCommandQueue.TryDequeue(msg) do
      begin
        case msg.MsgID of
          0: begin
//            rec := msg.MsgData.ToRecord<TDispMsgRecord>;
//            LOmniValue := TOmniValue.FromRecord<TDispMsgRecord>(rec);
            if not FResponseQueue.Enqueue(TOmniMessage.Create(0 {ignored}, msg.MsgData)) then
              raise Exception.Create('Response queue is full!');
          end;
          1: begin
            if not FResponseQueue.Enqueue(TOmniMessage.Create(1 {ignored}, msg.MsgData)) then
              raise Exception.Create('Response queue is full!');
          end;
        end;
      end;
    end;
//  finally
//    CoUnInitialize;
//  end;
end;

procedure TWorker.Stop;
begin
  FStopEvent.SetEvent;
end;

end.

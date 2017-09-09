unit HiMECS_Watch2;
{ 실행 방법
  HiMECS_Watch2p.exe /pEngParamFileName Command = Param파일 읽어서 Command에 따라 표시함.
                     /mAlarmlist = Alarmlist mode로 시작함
                     /uUserLevel = UserLevel 프로그램 시작함(0..3)
  Command = DISPLAYTREND: CopyData로 받은 Engparamd을 Trend로 보여줌
            SIMPLE: CopyData로 받은 Engparamd을 Simple로 보여줌

  2013.5.21
  - HiMECS_Watch2p.manifest 파일 적용, release 모드일 경우에만(볼랜드포럼에서 참조)
    : 관리자 권한으로 실행 됨(F9로 실행 안됨)
    : Debug 모드에서는 사용자 권한으로 실행(F9 실행 됨)
  2011.1.3:
    1) iPlotDataCursor.pas 수정: AddMenuItems함수에 UserMenuItem 추가
  2011.11.2:
    1) iPlotDataCursor.pas 수정: DeltaX mode시 X,Y값 변수 추가
                               : SetData_DeltaX함수 추가
    2) iPlotChannel.pas 수정:DataCursorUpate 함수 수정
      (data cursor의 DeltaX mode를 이용해 구간내 Y값을 가져오기 위함)
  2011.11.26:
    1) popup menu item의 tag는 user level로 사용됨-Timer 함수에서 처리
  2011.11.30
  1) watch list file name 변경: x xxxxxxxxxxx x
                                -             -
                                실행프로그램  User Level
    실행프로그램: 1: HiMECS_Watch2p.exe
                  2: HiMECS_WatchSavep.exe
  2011.12.12
  1) UnitFrameIPCMonitorAll 적용함

}
//{$DEFINE USE_PACKAGE}//HiMECS.inc file로 대체함
//HiMECS_Watch2_Nobpl.exe 실행시에는 HiMECS.inc 내용 중에  {$DEFINE USE_PACKAGE}를 Comment 처리 한 후 실행 해야 함
{$I HiMECS.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  system.Generics.Collections,
  Dialogs, ComCtrls, iComponent, iVCLComponent, iCustomComponent, Vcl.AppEvnts,
  iPlotComponent, iPlot, StdCtrls, ExtCtrls,SyncObjs, iniFiles, DeCALIO,
  Menus, iProgressComponent, iLedBar, ShadowButton, SuperStream,//janSQL,
  iPositionComponent, iScaleComponent, iGaugeComponent, iAngularGauge, iXYPlotChannel,
  iPlotToolBar, iPlotObjects,iPlotChannelCustom, iTypes,
  DragDrop, DropTarget, DragDropFormats, DragDropText, AdvTrackBar,
  EngineParameterClass, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, iXYPlot, NxColumns, NxColumnClasses, ImgList, JvDialogs,
  DropSource, JvExComCtrls, JvStatusBar, JclDebug, JvComCtrls,
  DB, UnitAlarmConfig, Mask, JvExMask, JvComponent, JvAppHotKey,
  JvToolEdit, AdvOfficeStatusBar, cyMathParser, //CalcExpress, sql3_defs
  AdvOfficeStatusBarStylers, AdvOfficePager, pjhFormDesigner,
  DesignFormConfigClass, pjhPanel, JvComponentBase, JvDockTree,
  JvDockControlForm, JvDockVIDStyle, JvDockVSNetStyle, TimerPool,
  UnitAlarmConfigClass, DeCAL, WatchConfig2, CircularArray, WatchConst2,
  UnitEngParamConfig, Watch2Interface, CopyData, GpCommandLineParser,
  //IPCThrd_LBX, IPCThrdMonitor_LBX, IPCThrd_WT1600, IPCThrdMonitor_WT1600,
  //IPCThrd_ECS_kumo, IPCThrdMonitor_ECS_kumo, IPCThrd_MEXA7000, IPCThrdMonitor_MEXA7000,
  //IPCThrd_MT210, IPCThrdMonitor_MT210, IPCThrd_FlowMeter, IPCThrdMonitor_FlowMeter,
  //IPCThrd_DYNAMO, IPCThrdMonitor_DYNAMO, IPCThrd_ECS_AVAT, IPCThrdMonitor_ECS_AVAT,
  //IPCThrd_GasCalc, IPCThrdMonitor_GasCalc,
  UnitFrameIPCMonitorAll, ModbusComStruct, ConfigOptionClass, DragDropRecord, HiMECSConst,
  Cromis.Comm.IPC, Cromis.Threading, IPCThrd_HiMECS_MDI, JvExExtCtrls, JvExtComponent,
  JvItemsPanel, UnitParameterManager, UnitFrameWatchGrid, NxCollection,
  UnitSTOMPClass, UnitWorker4OmniMsgQ, UnitMQConst, UnitSynLog, SynCommons, SynLog
 {$IFDEF USECODESITE} ,CodeSiteLogging {$ENDIF}

 {$IFDEF USE_PACKAGE}
  //, pjhFlowChartCompnents
 {$ELSE}
  ,frmDesignManagerDockUnit
 {$ENDIF}
 ;

Const
  DYNAMIC_PAGE_INDEX = 5; //pageControl의 0~4는 고정 페이지, 5부터 동적 생성함

type
  TCreateFuncFromBPL = function: TForm;

//  TEventData_MEXA7000_2 = packed record
//    CO2: Double;//String 변수는 공유메모리에 사용 불가함
//    CO_L: Double;
//    O2: Double;
//    NOx: Double;
//    THC: Double;
//    CH4: Double;
//    non_CH4: Double;
//    CollectedValue: Double;
// end;

  PDoublePoint = ^TDoublePoint;
  TDoublePoint = class
    X: Double;
    Y: Double;
  end;

  TWatchF2 = class(TForm, IWatch2Interface)
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    WatchListPopup: TPopupMenu;
    Items1: TMenuItem;
    AddtoSimple1: TMenuItem;
    AddToSimple3: TMenuItem;
    AddToSimpleInNewWindow1: TMenuItem;
    AddtoTrend1: TMenuItem;
    AddtoTrend2: TMenuItem;
    AddtoNewTrendWindow1: TMenuItem;
    N12: TMenuItem;
    AddAlarmValue1: TMenuItem;
    AddFaultValue1: TMenuItem;
    N6: TMenuItem;
    DeleteFromTrend1: TMenuItem;
    DeleteAlarmValueFromTrend1: TMenuItem;
    DeleteFaultValueFromTrend1: TMenuItem;
    N8: TMenuItem;
    LoadDatafromfile1: TMenuItem;
    LoadTrendDataFromFileUsingWatchList1: TMenuItem;
    AddtoSimple2: TMenuItem;
    AddtoXYGraph2: TMenuItem;
    AddtoXYGraph1: TMenuItem;
    AddToXYGraphFromFile1: TMenuItem;
    AddtoXYGraphinNewWindow1: TMenuItem;
    N7: TMenuItem;
    AddtoXAxis1: TMenuItem;
    AddtoXAxis2: TMenuItem;
    N11: TMenuItem;
    DeleteFromXYGraph1: TMenuItem;
    N5: TMenuItem;
    DataSave1: TMenuItem;
    NotifyAlarmList1: TMenuItem;
    N9: TMenuItem;
    LoadWatchListFromFile1: TMenuItem;
    N3: TMenuItem;
    DeleteItem1: TMenuItem;
    N10: TMenuItem;
    Properties1: TMenuItem;
    JvSaveDialog1: TJvSaveDialog;
    JvOpenDialog1: TJvOpenDialog;
    PopupMenu2: TPopupMenu;
    Add1: TMenuItem;
    Average1: TMenuItem;
    MinValue1: TMenuItem;
    MaxValue1: TMenuItem;
    N4: TMenuItem;
    LoadFromFile1: TMenuItem;
    AddtoCalculated1: TMenuItem;
    PageControl1: TAdvOfficePager;
    ItemsTabSheet: TAdvOfficePage;
    SimpleTabSheet: TAdvOfficePage;
    MinMaxTabSheet: TAdvOfficePage;
    JvStatusBar1: TJvStatusBar;
    Label4: TLabel;
    EnableAlphaCB: TCheckBox;
    JvTrackBar1: TJvTrackBar;
    StayOnTopCB: TCheckBox;
    AllowUserlevelCB: TComboBox;
    SaveListCB: TCheckBox;
    DisplayPanel: TPanel;
    Label1: TLabel;
    WatchLabel: TLabel;
    AvgPanel: TPanel;
    Label2: TLabel;
    AvgLabel: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    CurLabel: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MinLabel: TLabel;
    MaxLabel: TLabel;
    Button1: TButton;
    TrendTabSheet: TAdvOfficePage;
    iPlot1: TiPlot;
    XYGraphTabSheet: TAdvOfficePage;
    iXYPlot1: TiXYPlot;
    Button2: TButton;
    Button3: TButton;
    ConstantEdit: TEdit;
    PopupMenu3: TPopupMenu;
    LoadDesignPanel1: TMenuItem;
    SaveWatchLittoNewName1: TMenuItem;
    LoadDesginFormFromdfcFile1: TMenuItem;
    N13: TMenuItem;
    LoadDesignFormFromdfmfile1: TMenuItem;
    SaveOnlyDFM1: TMenuItem;
    N2: TMenuItem;
    ChangeTabCaption1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    FullScreen1: TMenuItem;
    abShowHide1: TMenuItem;
    CaptionShowHide1: TMenuItem;
    AdjustParameter1: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    AdjustparameterIndex1: TMenuItem;
    ShowGridRowIndex1: TMenuItem;
    InitializeCompValues1: TMenuItem;
    Refresh1: TMenuItem;
    FWG: TFrameWatchGrid;
    SellectAll1: TMenuItem;
    ShowEventName1: TMenuItem;
    NxAlertWindow1: TNxAlertWindow;
    ShowWindowsHandle1: TMenuItem;
    IPCMonitorAll1: TFrameIPCMonitor;
    ShowMQName1: TMenuItem;
    N16: TMenuItem;
    CheckedAvgAllSelected1: TMenuItem;
    UnCheckedAvgAllSelected1: TMenuItem;
    ResetAvgValue1: TMenuItem;
    LoadItemsFromFile1: TMenuItem;
    N17: TMenuItem;
    ShowEngineName1: TMenuItem;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Average1Click(Sender: TObject);
    procedure MinValue1Click(Sender: TObject);
    procedure MaxValue1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure AddtoTrend2Click(Sender: TObject);
    procedure LoadFromFile1Click(Sender: TObject);
    procedure AddtoXYGraph1Click(Sender: TObject);
    procedure AddtoXYGraphFromTrendData1Click(Sender: TObject);
    procedure EnableAlphaCBClick(Sender: TObject);
    procedure DataSave1Click(Sender: TObject);
    procedure LoadDatafromfile1Click(Sender: TObject);
    procedure LoadWatchListFromFile1Click(Sender: TObject);
    procedure iPlot1ToolBarButtonClick(Index: Integer;
      ButtonType: TiPlotToolBarButtonType);
    procedure AddtoNewTrendWindow1Click(Sender: TObject);
    procedure DeleteFromTrend1Click(Sender: TObject);
    procedure AddToSimple3Click(Sender: TObject);
    procedure AddToSimpleInNewWindow1Click(Sender: TObject);
    procedure LoadTrendDataFromFileUsingWatchList1Click(Sender: TObject);
    procedure JvStatusBar1Click(Sender: TObject);
    procedure JvTrackBar1Change(Sender: TObject);
    procedure AddToXYGraphFromFile1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure DeleteFromXYGraph1Click(Sender: TObject);
    procedure AddAlarmValue1Click(Sender: TObject);
    procedure DeleteAlarmValueFromTrend1Click(Sender: TObject);
    procedure DeleteFaultValueFromTrend1Click(Sender: TObject);
    procedure StayOnTopCBClick(Sender: TObject);
    procedure AddtoCalculated1Click(Sender: TObject);
    procedure PageControl1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PageControl1InsertPage(Sender: TObject; APage: TAdvOfficePage);
    procedure LoadDesignPanel1Click(Sender: TObject);
    procedure CloseDesignPanel1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; FromPage, ToPage: Integer;
      var AllowChange: Boolean);
    procedure PageControl1ClosePage(Sender: TObject; PageIndex: Integer;
      var Allow: Boolean);
    procedure PageControl1ClosedPage(Sender: TObject; PageIndex: Integer);
    procedure SaveWatchLittoNewName1Click(Sender: TObject);
    procedure LoadDesginFormFromdfcFile1Click(Sender: TObject);
    procedure LoadDesignFormFromdfmfile1Click(Sender: TObject);
    procedure SaveOnlyDFM1Click(Sender: TObject);
    procedure ValueButtonClick(Sender: TObject);
    procedure ChangeTabCaption1Click(Sender: TObject);
    procedure ApplicationEvents1ShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FullScreen1Click(Sender: TObject);
    procedure abShowHide1Click(Sender: TObject);
    procedure CaptionShowHide1Click(Sender: TObject);
    procedure DisplayPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure iXYPlot1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AdjustParameter1Click(Sender: TObject);
    procedure AdjustparameterIndex1Click(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure InitializeCompValues1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DeleteItem1Click(Sender: TObject);
    procedure SellectAll1Click(Sender: TObject);
    procedure FWGNextGrid1SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure ShowEventName1Click(Sender: TObject);
    procedure ShowWindowsHandle1Click(Sender: TObject);
    procedure ShowMQName1Click(Sender: TObject);
    procedure CheckedAvgAllSelected1Click(Sender: TObject);
    procedure UnCheckedAvgAllSelected1Click(Sender: TObject);
    procedure ResetAvgValue1Click(Sender: TObject);
    procedure LoadItemsFromFile1Click(Sender: TObject);
    procedure ShowEngineName1Click(Sender: TObject);
  private
    FFilePath: string;      //파일을 저장할 경로
    FProgramMode: TProgramMode;
    FIsMDIChileMode: Boolean;//HiMECS에서 MDI Child로 실행할 경우 True
    //FCurrentUserLevel: THiMECSUserLevel;
    FWatchListFileName: string;//실행시 파라미터로 입력 받음(파라미터 저장파일)

    FCriticalSection: TCriticalSection;
    FPJHTimerPool: TPJHTimerPool;

    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FFirst: Boolean; //타이머 동작 완료하면 True
    FMsgList: TStringList;  //Message를 저장하는 리스트

    //FEngineParameter: TEngineParameter;

    FPackageModules : array of HModule;
    FCreateFuncFromBPL : array of TCreateFuncFromBPL;
    FDesignManagerForm: TForm; //Design Control Form from bpl
    FDesignManagerFormClass: TFormClass; //Design Control Form Class
    FColsedPageIndex: integer; //tab close시에 tag 접근시 에러 방지 목적

    FBplFileList: TStringList;
    FPackageHandles : array of HModule;

    FDummyFormHandle: string;
    FControlPressed: Boolean;

    //IPC Thread -->
    Flags: TClientFlags;
    IPCClient_HiMECS_MDI: TIPCClient_HiMECS_MDI;

    FpjhSTOMPClass: TpjhSTOMPClass;
    FCommandLine: TWatchCommandLineOption;

    procedure SetWatchListFileName(AFileName: string);
    procedure OnConnect(Sender: TIPCThread_HiMECS_MDI; Connecting: Boolean);
    procedure OnSignal(Sender: TIPCThread_HiMECS_MDI; Data: TEventData_HiMECS_MDI);
    procedure UpdateStatusBar(var Msg: TMessage); message WM_UPDATESTATUS_HiMECS_MDI;
    //IPC Thread <--

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WMDesignManagerClose(var Msg: TMessage); message WM_DESIGNMANAGER_CLOSE;
    procedure WMClose(var Msg: TMessage); message WM_CLOSE;
    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;

    procedure ProcessResults;
    procedure OnWindowCaptionDrag;
    procedure pjhPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToggleBorderStyle;
    procedure ToggleWindowMaxmize;
    procedure ToggleTabShow;
    procedure ResetWindowPosition;
    procedure ToggleStayOnTop;

    procedure DeleteItem2pjhTagInfo(AIndex: integer);

    procedure OnChangeDispPanelColor(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure GetEngineParameterFromSavedWatchListFile(AAutoStart: Boolean;
              AFileName: string);
    function GetTagNameFromDescriptor(ADescriptor: string): string;
    procedure DeleteEngineParamterFromGrid(AIndex: integer);

    function GetAxisFromString(AAxes: String): TAxis;

//    procedure GetFields2Grid(ADb: TSivak3Database; ATableName: String; AGrid: TNextGrid);

    procedure MyMouseEvent(var Msg: TMsg;var Handled: Boolean);
    function GetDesignPanel(LPage: TAdvOfficePage): TELDesignPanel;
    function GetDesignControl(LPage: TAdvOfficePage): TControl;
    procedure UnloadAddInPackage(var AOwner: TComponent; AModule: THandle);
    procedure DestroyDynamicPanel;
    procedure DestroyComponentOnPage(LPage: TAdvOfficePage);
    function LoadNCreateOrShowDM: Boolean;
    procedure AssignPanel2Designer(AForm: TForm);
    procedure SaveDesignMode2ControlTag(APageIndex: Integer);

    procedure ShowHideGridRowIndex(AShowIndex: Boolean = True);
    procedure RemoveControlsOnPanel(AControl: TPanel);
    function CommandLineParse(var AErrMsg: string): boolean;
  public
    //FOnExit: Boolean; //프로그램 종료시 True
    FStartTrend: Boolean;
    FOwnerHandle: THandle;//Owner form handle
    FOwnerListIndex: integer;//TList에 저장되는 Index(해제시에 필요함)
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체
    FConfigOption: TConfigOption;
    FDesignFormConfig: TDesignFormConfig; //Design Form Config Class
    FWatchHandles : array of THandle;

    FTrendDataMap: DMap;
    FTrendDataMapFromFile: DMap;
    FXYDataMap: DMultiMap;

    FXYDataIndex: array[0..1] of integer; //[0] = x 축 Index, [1] = Y 축 Index
    //FSharedName: string;//공유 메모리 이름
    //FFuncCode: string;//Modbus Function Code
    //FAddress: string;//Modbus Address
    FLabelName: string; //모니터링하고자 하는 데이타의 이름을 저장함.
    FWatchName: string; //component 이름을 저장함.(FunctionCode+Address)
    FWatchValue: string; //모니터링 데이타

    //Option변경시에 파일이름이 같을 경우 Readmap을 하지 않기 위해 필요함
    FCurrentModbusFileName: string;

    //FWatchValueRecord: TEventData_MEXA7000; //유승원 요청사항, 모든 데이타를 한개의 차트에 표시하기 위함.
    FEnterWatchValue2Screen,
    FEnterWatchAnalogValue2DesignScreen: Boolean;

    FWatchValueMin: double; //Min data
    FWatchValueMax: double; //Max data
    FWatchValueSum: double; //Sum data
    FWatchValueAvg: double; //Average data
    FWatchCA: TCircularArray;// Circular Array

    FCurrentAryIndex: integer; //처음에 배열에 저장시에 평균값 구하기 위함
    FFirstCalcAry: boolean; //처음 배열을 채워갈때는 True, 한번 다 채우면 False
    FCurrentEPIndex4Watch: integer; //Simple에 표시될 Engine Parameter Index
    FPrevEPIndex4Watch: integer; //Simple에 표시될 이미지 지우기 위함(한개만 표시되어야 함)

    FIsAverageValueGraph: boolean;//평균값을 그래프로 표현하면 True
    FAverageValueChannel: integer;// FIsCurrentValueGraph=true 일 경우 채널 번호
    FAverageValueX: double;

    FIsMinValueGraph: boolean;//최소값을 그래프로 표현하면 True
    FMinValueChannel: integer;// FIsCurrentValueGraph=true 일 경우 채널 번호
    FMinValueX: double;

    FIsMaxValueGraph: boolean;//최대값을 그래프로 표현하면 True
    FMaxValueChannel: integer;// FIsCurrentValueGraph=true 일 경우 채널 번호
    FMaxValueX: double;

    FCurrentChangeColor: Longint; //Warning 또는 Alarm시에 변경할 색상
    FBlinkEnable: Boolean; //Blink Mode이면 True
    FBlinkOn : Boolean;//Blink시에 깜박이용으로 사용

    FTaskPool: TTaskPool;
    FIsAutoFree: Boolean; //True: Close시에 자동 메모리 해제

    procedure OnMessageComplete(const Msg: ITaskMessage);
    procedure OnAsynchronousIPCTask(const ATask: ITask);
    procedure SendAliveOk;

    procedure InitVar;
    procedure InitSTOMP;
    procedure DestroySTOMP;
    procedure DisplayMessage(Msg: string; AIsSaveLog: Boolean = False; AMsgLevel: TSynLogInfo = sllInfo);
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer);
    procedure WatchValue2Screen_Digital(Name: string; AValue: string;
                                AEPIndex: integer);
    procedure WatchValue2Screen_Once;
    procedure WatchValue2Screen_2;
    procedure WatchAnalogValue2DesignScreen;
    procedure WatchDigitalValue2DesignScreen(Name: string; AValue: string;
                                AEPIndex: integer);
    procedure AdjustParamIndexOfComponents;
    function GetparamIndexFromCollect(ATagName: string; var ADesc: string): integer;
    procedure InitializeComponentValues;
    procedure LockUnLockValue2Screen(AIsLock: Boolean);

    procedure Value2Screen_ECS_kumo(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_AVAT(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_Analog_ECS_kumo(AName: string; AValue: Integer; AMaxVal: real);
    procedure Value2Screen_Digital_ECS(Name: string; AValue: Integer;
                                    AMaxVal: real; AContact: integer);
    procedure GetDataFromTrendGraph2XYMap(AArray: DArray);
    procedure AddData2TrendMap(AParameterIndex: integer; AXValue, AYValue: double);
    procedure AddData2TrendMapFromFile(AKeyName: string; AXValue, AYValue: double);
    procedure AddData2XYMap(AParameterIndex: integer; AXValue, AYValue: double);
    procedure DisplayTrend(AXValueisDateTime: Boolean; ATime: TDateTime);
    procedure DisplayTrendFromMap(APlot: TiPlot; AMap: DMap);
    procedure DisplayXYGraphRealTime(APlotChannel: TiXYPlotChannel);
    function MakeXYDataFromFile(AArray: DArray; AFileName: string; AIsFirst: Boolean; AXYMap: DMultiMap; AIsDuplicate: Boolean): boolean;
    procedure FillXYMapFromFile(AXYMap: DMultiMap; AList: TStringList;
                                    AIsDuplicated: Boolean; AStr: string);
    function GetTrendDataFromTagName(ATagName: string; AMap: DMap): DArray;
    procedure DisplayXYGraphWithDup(APlotChannel: TiXYPlotChannel; AMap: DMultiMap);
    procedure DisplayXYGraphWithOutDup(APlotChannel: TiXYPlotChannel; AMap: DMultiMap);
    procedure SaveDMap2File(AFileName: string; AMap: DMap);
    procedure LoadTrendDataMapFromFile(AFileName: string);
    procedure LoadTrendDataFromFile(AFileName: string; AIsFirstFile: Boolean;
                AIsUseWatchList: Boolean);
    procedure OpenTrendDataFile(AIsUseWatchList: Boolean);
    procedure SaveDMultiMap2File(AFileName: string; AMap: DMultiMap);
    procedure ReplaceOrAddMap(AMap: DMultiMap; AKey, AValue: double; AIsXAxis:Boolean);
    procedure XYDataAdd2Map(AMap: DMultiMap; AKey, AValue: double; AIsXAxis:Boolean);
    function PrepareXYGraph(AArray: DArray; AIsChannelClear: Boolean): Boolean;

    procedure GetXYPeriod(var Ai,Aj: integer);
    function GetPeriodDataFromTrend(AIndex, Ai, Aj: integer; ADataType: TPeriodDataType): double;
    procedure SelectTrendItemsForXYGraph;
    procedure SelectItemsClick(Sender: TObject);
    procedure CalcAverageFromTrend(Sender: TObject);
    procedure CalcSumFromTrend(Sender: TObject);
    procedure CalcMinFromTrend(Sender: TObject);
    procedure CalcMaxFromTrend(Sender: TObject);
    procedure CalcDiffFromTrend(Sender: TObject);
    procedure CalcPointSpanFromTrend(Sender: TObject);
    procedure CalcPointFromTrend(Sender: TObject);

    function AddChannelAndYAxis(AParamIndex: integer; ACheckTrendType: TTrendDataType): integer;
    procedure DeleteAllTrend;
    procedure UpdateChannelIndex(AIndex: integer);
    procedure UpdateYAxisIndex(AIndex: integer);
    procedure AddToSimple(AParamIndex: integer);
    procedure AddToNewWindow(ACommand: string);
    function AddToXYGraphInRealTime: Boolean;
    function DetermineIndexForXYGraph(AIsChClear: Boolean): Boolean;

    procedure DisplayMessage2SB(Msg: string);
    procedure ChangeDispPanelColor(AColor: TColor);
    procedure ChangeAlarmListMode;

    procedure ApplyAvgSize;
    procedure ApplyOption;
    procedure ApplyCommandLineOption;
    procedure ApplyOption4AvgCalc;

    procedure CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord; ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist);

    function GetFileNameFromWatchList: string;
    procedure LoadConfigDataXml2Var(AFileName: string = '');
    procedure LoadConfigDataVar2Form(AMonitorConfigF : TWatchConfigF);
    procedure SaveConfigData2Xml;
    procedure SaveConfigDataForm2Xml(AMonitorConfigF : TWatchConfigF);
    procedure SetConfigData;
    procedure SetAlarm4OriginalOption(AValue: double; AEPIndex: integer);
    procedure SetAlarm4ThisOption(AValue: double);
    procedure SaveWatchList(AFileName: string; ASaveWatchListFolder: Boolean = True);
    procedure SaveDesignForm(AFileName: string);
    procedure SaveOnlyDFMofCurPage(AFileName: string);
    procedure LoadDesignForm(AFileName: string);
    procedure LoadDesignFormFromMenu(AFileName: string; AIsFromdfc: Boolean);
    procedure LoadDesignFormFromDFM(AFileName: string);
    procedure LoadDesignComponentPackage;
    procedure LoadDesignComponentPackageFromOnlyComp(ADfc: TDesignFormConfig);
    procedure LoadDesignComponentPackageAll;
    procedure AddBpllist2DFConfig(ABplist: TStringList;ADfc: TDesignFormConfig);
    procedure GetBplNamesFromDesignPanel(ABplNameList: TStringList;
                                        AAdvOfficePage: TAdvOfficePage);

    procedure IPCAll_Final;

    procedure SaveWatchListFileOfSummary(AFileName: string);

    //For IWatch2Interface
    //Object Inspector에서 컴포넌트 연결시 사용됨
    procedure GetTagNames(ATagNameList, ADescriptList: TStringList);
    procedure GetLoadedPackages(APackageList: TStringList);
    //For IWatch2Interface

    procedure SetMatrix;

    property WatchListFileName: string read FWatchListFileName write SetWatchListFileName;
  end;

    procedure DoublePointIO(obj : TObject; stream : TObjStream; direction : TObjIODirection;
              version : Integer; var callSuper : Boolean);

var
  WatchF2: TWatchF2;

implementation

uses CommonUtil, UnitAxisSelect, UnitCopyWatchList, frmMainInterface,
  pjhDesignCompIntf, pjhDesignCompIntf2, UtilUnit, jclNTFS,
  HiMECSWatchCommon, pjhclasses, UnitSetMatrix, UnitCaptionInput,
  WindowUtil, otlComm, mORMot, StompTypes;

{$R *.dfm}

//List에 있는 TagName과 연결되어 있는 Component만 골라서 값을 0으로 초기화 함.
procedure TWatchF2.InitializeComponentValues;
var
  i, j, k, PnlIndex: integer;
  LStr: string;
  LPanel: TpjhPanel;
  IpjhDI: IpjhDesignCompInterface;
begin
  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psManualInput then
      continue;

    IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value := '0';
    LStr := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName;

    for k := 5 to PageControl1.AdvPageCount - 1 do
    begin
      with PageControl1.AdvPages[k] do
      begin
        for j := 0 to ComponentCount - 1 do
        begin
          //find panel component(only one exist on Page)
          if Components[j].ClassType = TpjhPanel then
          begin
            PnlIndex := j;
            break;
          end;
        end;//for

        LPanel := Components[PnlIndex] as TpjhPanel;

        for j := 0 to LPanel.ComponentCount - 1 do
        begin
          if Supports(LPanel.Components[j], IpjhDesignCompInterface, IpjhDI) then
          begin
            if IpjhDI.pjhTagInfo.TagName =  LStr then
            begin
              PnlIndex := GetparamIndexFromCollect(IpjhDI.pjhTagInfo.TagName, LStr);
              if PnlIndex <> -1 then
              begin
                IpjhDI.pjhValue := '0';
              end;
            end;
          end;
        end;//for
      end;//with
    end;
  end;

end;

procedure TWatchF2.InitializeCompValues1Click(Sender: TObject);
begin
  InitializeComponentValues;
end;

procedure TWatchF2.InitSTOMP;
var
  i: integer;
  LStrList: TStringList;
begin
  DestroySTOMP;

  if FConfigOption.MQServerTopicCollect.Count = 0 then
    FConfigOption.MQServerTopicCollect.Add.TopicName := IPCMonitorAll1.GetEngineName;//'UniqueEngineName';

  if FConfigOption.MQServerTopicCollect.Items[0].TopicName = '' then
    FConfigOption.MQServerTopicCollect.Items[0].TopicName := MQ_DEFAULT_Q_NAME;

  if FConfigOption.MQServerIP = '' then
    FConfigOption.MQServerIP := MQ_DEFAULT_SERVER_IP;

  if FConfigOption.MQServerPort = '' then
    FConfigOption.MQServerPort := MQ_DEFAULT_PORT;

  if FConfigOption.MQServerUserId = '' then
    FConfigOption.MQServerUserId := MQ_DEFAULT_USER_ID;

  if FConfigOption.MQServerPasswd = '' then
    FConfigOption.MQServerPasswd := MQ_DEFAULT_PASSED;

  if not Assigned(FpjhSTOMPClass) then
  begin
    LStrList := TStringList.Create;
    try
      FConfigOption.SetTopic2StrList(LStrList);
      FpjhSTOMPClass := TpjhSTOMPClass.Create(FConfigOption.MQServerUserId,
                                              FConfigOption.MQServerPasswd,
                                              FConfigOption.MQServerIP,
                                              LStrList,
                                              Self.Handle);
    finally
      LStrList.Free;
    end;
  end;
end;

procedure TWatchF2.InitVar;
var
  LStr: string;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FProgramMode := pmWatchList;
  SetCurrentDir(FFilePath);
  FCriticalSection := TCriticalSection.Create;
  FAddressMap := DMap.Create;
  FConfigOption := TConfigOption.Create(nil);
  FDesignFormConfig := TDesignFormConfig.Create(nil);
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  //FEngineParameter := TEngineParameter.Create(nil);
  FCommandLine := TWatchCommandLineOption.Create;

  FWG.FCalculatedItemTimerHandle := -1;
  FWG.SetIPCMonitorAll(IPCMonitorAll1);
  FWG.SetStatusBar(JvStatusBar1);
  FWG.SetMainFormHandle(Handle);
  FWG.SetDeleteEngineParamterFromGrid(DeleteEngineParamterFromGrid);
  FWG.SetWatchValue2Screen_Analog(WatchValue2Screen_Analog); //Calculated Items을 계산하여 EngineParameter에 저장함
  FWG.NextGrid1.DoubleBuffered := False;
  FWG.FDisplayMessage := DisplayMessage;
  InitSynLog;

  IPCMonitorAll1.FNextGrid := FWG.NextGrid1;
  IPCMonitorAll1.FPageControl := PageControl1;
  IPCMonitorAll1.SetValue2ScreenEvent_2(WatchValue2Screen_2);
  IPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;
  IPCMonitorAll1.FWatchValue2Screen_DigitalEvent := WatchValue2Screen_Digital;
  IPCMonitorAll1.FStatusBar := JvStatusBar1;

//  if FConfigOption.MonDataSource <> 0 then
//    IPCMonitorAll1.SetIsUseIPCSharedMMEvent(False);

    //ApplyOption 함수에서 실행함
//  if FConfigOption.MonDataSource = 2 then //MonDataSource = By MQ
//    InitSTOMP;

  FTaskPool := TTaskPool.Create(5);
  FTaskPool.OnTaskMessage := OnMessageComplete;
  FTaskPool.Initialize;

  FTrendDataMap := DMap.Create;
  TObjStream.RegisterClass(TDoublePoint, DoublePointIO, 1);

  FTrendDataMapFromFile := DMap.Create;

  FXYDataMap := DMultiMap.Create;

  FMsgList := TStringList.Create;
  FMonitorStart := False;
  FFirst := True;

  LoadDesignComponentPackageAll;

  FCurrentAryIndex := 0;
  FCurrentEPIndex4Watch := -1;
  FPrevEPIndex4Watch := -1;
  FFirstCalcAry := True;
  FXYDataIndex[0] := -1;
  FXYDataIndex[1] := -1;
  FWatchCA := TCircularArray.Create(FConfigOption.AverageSize);

  CommandLineParse(LStr);
  LoadConfigDataXml2Var(FCommandLine.ConfigFileName);
  ApplyOption;
  ApplyCommandLineOption; //Config file load 후 실행해야 Command line option이 적용 됨

  if FConfigOption.WatchListFileName <> '' then
  begin
    GetEngineParameterFromSavedWatchListFile(True, FConfigOption.WatchListFileName);
    FProgramMode := pmWatchList;
  end;

  iPlot1.RemoveAllYAxes;
  iPlot1.RemoveAllChannels;

  iPlot1.DataCursor[0].SelectItemMenuClick := SelectItemsClick;
  iPlot1.DataCursor[0].AverageMenuClick := CalcAverageFromTrend;
  iPlot1.DataCursor[0].SumMenuClick := CalcSumFromTrend;
  iPlot1.DataCursor[0].MinMenuClick := CalcMinFromTrend;
  iPlot1.DataCursor[0].MaxMenuClick := CalcMaxFromTrend;
  iPlot1.DataCursor[0].DiffMenuClick := CalcDiffFromTrend;
  iPlot1.DataCursor[0].PointSpanMenuClick := CalcPointSpanFromTrend;
  iPlot1.DataCursor[0].PointMenuClick := CalcPointFromTrend;

  SetLength(FPackageModules, 1);
  FPackageModules[0] := 0;
  SetLength(FCreateFuncFromBPL, 1);
  FDesignManagerForm := nil;
end;

procedure TWatchF2.AssignPanel2Designer(AForm: TForm);
var
  IbMI : IbplMainInterface;
  LPage: TAdvOfficePage;
  LDesignPanel: TELDesignPanel;
  LPanel: TpjhPanel;
begin
  if Assigned(AForm) then
  begin
    if Supports(AForm, IbplMainInterface, IbMI) then
    begin
      IbMI.BplOwner := Self;

      with IbMI.Designer do
      begin
        Active := False;
        LPage := PageControl1.ActivePage;
        LDesignPanel := nil;
        LDesignPanel := GetDesignPanel(LPage);
        if Assigned(LDesignPanel) then
          DesignPanel := LDesignPanel
        else
        begin
          exit;
        end;

        LPanel := TpjhPanel(GetDesignControl(LPage));
        DesignControl := LPanel;
        //DesignControl := WatchF2;

        if LPanel.Tag = 0 then //0일 경우 처음 생성한 것임
          Active := True
        else
        begin
          Active := IntToBool(LPanel.Tag - 1);
          if Active then
            FDesignManagerForm.Show;
        end;

        DesignPanel.FormRefresh;
        //DesignControlRefresh; //이거 실행하면 컴포넌트가 Run Mode에서 안보임
      end;//with

      //PrepareOIInterface의 FPropForm <> nil 조건을 만족하기 위해 PrepareOIInterface보다 먼저 실행 되어야 함
      IbMI.InitializePackage;
      IbMI.PrepareOIInterface(LPanel);
      //IbMI.SetDockStyle(JvDockVSNetStyle1);
      //AForm.Show;
    end;
  end;
end;

procedure TWatchF2.IPCAll_Final;
begin
  IPCMonitorAll1.DestroyIPCMonitorAll;

{  IPCMonitorAll1.DestroyIPCMonitor(psECS_kumo);
  IPCMonitorAll1.DestroyIPCMonitor(psECS_AVAT);
  IPCMonitorAll1.DestroyIPCMonitor(psMT210);
  IPCMonitorAll1.DestroyIPCMonitor(psMEXA7000);
  IPCMonitorAll1.DestroyIPCMonitor(psWT1600);
  IPCMonitorAll1.DestroyIPCMonitor(psDynamo);
  IPCMonitorAll1.DestroyIPCMonitor(psLBX);
  IPCMonitorAll1.DestroyIPCMonitor(psFlowMeter);
  IPCMonitorAll1.DestroyIPCMonitor(psGasCalculated);  }
end;

procedure TWatchF2.iPlot1ToolBarButtonClick(Index: Integer;
  ButtonType: TiPlotToolBarButtonType);
begin
  if iptbbtEdit = ButtonType then
  begin
    FormStyle := fsNormal;
  end;

end;

procedure TWatchF2.iXYPlot1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  OnWindowCaptionDrag;
end;

procedure TWatchF2.JvStatusBar1Click(Sender: TObject);
begin
  JvStatusBar1.SimplePanel := not JvStatusBar1.SimplePanel;
  SaveListCB.Visible := not SaveListCB.Visible;
  AllowUserlevelCB.Visible := not AllowUserlevelCB.Visible;
  StayOnTopCB.Visible := not StayOnTopCB.Visible;
  Label4.Visible := not Label4.Visible;
  EnableAlphaCB.Visible := not EnableAlphaCB.Visible;
  JvTrackBar1.Visible := not JvTrackBar1.Visible;
end;

procedure TWatchF2.JvTrackBar1Change(Sender: TObject);
begin
  if EnableAlphaCB.Checked then
    AlphaBlendValue := JvTrackBar1.Position;
end;

procedure TWatchF2.LoadConfigDataVar2Form(AMonitorConfigF: TWatchConfigF);
var
  i: integer;
begin
  AMonitorConfigF.CaptionEdit.Text := FConfigOption.FormCaption;

  AMonitorConfigF.MapFilenameEdit.FileName := FConfigOption.ModbusFileName;
  AMonitorConfigF.AvgEdit.Text := IntToStr(FConfigOption.AverageSize);
  AMonitorConfigF.WatchFileNameEdit.Text := WatchListFileName;

  AMonitorConfigF.IntervalRG.ItemIndex := FConfigOption.SelDisplayInterval;
  AMonitorConfigF.IntervalEdit.Text := IntToStr(FConfigOption.DisplayInterval);
  AMonitorConfigF.AliveIntervalEdit.Text := IntToStr(FConfigOption.AliveSendInterval);

  AMonitorConfigF.SelAlarmValueRG.ItemIndex := FConfigOption.SelectAlarmValue;
  AMonitorConfigF.MinAlarmEdit.Text := FloatToStr(FConfigOption.MinAlarmValue);
  AMonitorConfigF.MaxAlarmEdit.Text := FloatToStr(FConfigOption.MaxAlarmValue);
  AMonitorConfigF.MinFaultEdit.Text := FloatToStr(FConfigOption.MinFaultValue);
  AMonitorConfigF.MaxFaultEdit.Text := FloatToStr(FConfigOption.MaxFaultValue);
  AMonitorConfigF.MinAlarmColorSelector.SelectedColor := TColor(FConfigOption.MinAlarmColor);
  AMonitorConfigF.MaxAlarmColorSelector.SelectedColor := TColor(FConfigOption.MaxAlarmColor);
  AMonitorConfigF.MinFaultColorSelector.SelectedColor := TColor(FConfigOption.MinFaultColor);
  AMonitorConfigF.MaxFaultColorSelector.SelectedColor := TColor(FConfigOption.MaxFaultColor);
  AMonitorConfigF.MinAlarmBlinkCB.Checked := FConfigOption.MinAlarmBlink;
  AMonitorConfigF.MaxAlarmBlinkCB.Checked := FConfigOption.MaxAlarmBlink;
  AMonitorConfigF.MaxFaultBlinkCB.Checked := FConfigOption.MinFaultBlink;
  AMonitorConfigF.MinFaultBlinkCB.Checked := FConfigOption.MaxFaultBlink;
  AMonitorConfigF.ViewAvgValueCB.Checked := FConfigOption.ViewAvgValue;
  AMonitorConfigF.SubWatchCloseCB.Checked := FConfigOption.SubWatchClose;
  AMonitorConfigF.ZoomToFitCB.Checked := FConfigOption.ZoomToFitTrend;
  AMonitorConfigF.DefaultSoundEdit.FileName := FConfigOption.DefaultSoundFileName;
  AMonitorConfigF.NameFontSizeEdit.Text := IntToStr(FConfigOption.NameFontSize);
  AMonitorConfigF.ValueFontSizeEdit.Text := IntToStr(FConfigOption.ValueFontSize);
  AMonitorConfigF.RingBufSizeEdit.Text := IntToStr(FConfigOption.RingBufferSize);
  AMonitorConfigF.EngParamEncryptCB.Checked := FConfigOption.EngParamEncrypt;
  AMonitorConfigF.ConfFileFormatRG.ItemIndex := FConfigOption.EngParamFileFormat;
  AMonitorConfigF.MonDataFromRG.ItemIndex := FConfigOption.MonDataSource;

  //MQ Server
  AMonitorConfigF.MQIPAddress.Text := FConfigOption.MQServerIP;
  AMonitorConfigF.MQPortEdit.Text := FConfigOption.MQServerPort;
  AMonitorConfigF.MQUserEdit.Text := FConfigOption.MQServerUserId;
  AMonitorConfigF.MQPasswdEdit.Text := FConfigOption.MQServerPasswd;

  for i := 0 to FConfigOption.MQServerTopicCollect.Count - 1 do
    AMonitorConfigF.MQTopicLB.Items.Add(FConfigOption.MQServerTopicCollect.Items[i].TopicName);

  AMonitorConfigF.DispAvgValueCB.Checked := FConfigOption.DisplayAverageValue;

  case FConfigOption.SelectAlarmValue of
    0: AMonitorConfigF.AlarmValueGB.Enabled := False;
    1: AMonitorConfigF.AlarmValueGB.Enabled := False;
    2: AMonitorConfigF.AlarmValueGB.Enabled := True;
  end;

  case FConfigOption.SelDisplayInterval of
    0: AMonitorConfigF.IntervalEdit.Enabled := False;
    1: AMonitorConfigF.IntervalEdit.Enabled := True;
  end;
end;

procedure TWatchF2.LoadConfigDataXml2Var(AFileName: string);
var
  LOption: TConfigOption;
begin
  if AFileName = '' then
    AFileName := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);

  if FileExists(AFileName) then
  begin
    LOption := TConfigOption.Create(nil);
    try
      CopyObject(FConfigOption, LOption);
      FConfigOption.LoadFromJSONFile(AFileName, '', False);
      FConfigOption.InitValueChanged;
      FConfigOption.CheckValueChanged(LOption);
      IPCMonitorAll1.FModbusMapFileName := FConfigOption.ModbusFileName;
    finally
      LOption.Free;
    end;
  end;
end;

procedure TWatchF2.LoadDatafromfile1Click(Sender: TObject);
begin
  OpenTrendDataFile(False);
end;

procedure TWatchF2.LoadDesginFormFromdfcFile1Click(Sender: TObject);
begin
  LoadDesignFormFromMenu('', True);
end;

//동적 생성 DFM 파일을 읽기위한 Component Bpl Load
//Bpl 파일 이름은 각 Component 속성 pjhBplFileName에서 가져와 저장함
procedure TWatchF2.LoadDesignComponentPackage;
var
  i: integer;
  LStr, LDFName: string;
  LStrList: TStringList;
begin
  SetCurrentDir(FFilePath);

  if FDesignFormConfig.DesignFormConfigCollect.Count > 0 then
  begin
    if Assigned(FBplFileList) then
    begin
      for i := 0 to FBplFileList.Count - 1 do
        UnLoadPackage(HModule(FBplFileList.Objects[i]));
      FBplFileList.Clear;
    end
    else
      FBplFileList := TStringList.Create;
  end;

  LStrList := TStringList.Create;

  try
    for i := 0 to FDesignFormConfig.DesignFormConfigCollect.Count - 1 do
    begin
      LStr := FDesignFormConfig.DesignFormConfigCollect.Items[i].BplFileList;
      if LStr <> '' then
      begin
        while LStr <> '' do
        begin
          LDFName := GetTokenWithComma(LStr);
          if LStrList.IndexOf(LDFName) = -1 then
            LStrList.Add(LDFName);
        end;
      end;
    end;

    SetLength(FPackageHandles, LStrList.Count);

    for i := 0 to LStrList.Count - 1 do
    begin
      FPackageHandles[i] := LoadPackage('..\Bpls\' + LStrList.Strings[i]);
      FBplFileList.AddObject(LStrList.Strings[i], Pointer(FPackageHandles[i]));
    end;
  finally
    LStrList.Free;
  end;
end;

procedure TWatchF2.LoadDesignComponentPackageAll;
var
  i: integer;
  LStrList: TStringList;
begin
  if Assigned(FBplFileList) then
  begin
    for i := 0 to FBplFileList.Count - 1 do
      UnLoadPackage(HModule(FBplFileList.Objects[i]));
    FBplFileList.Clear;
  end
  else
    FBplFileList := TStringList.Create;

  try
    SetCurrentDir(FFilePath);

//    if FileExists('..\Bpls\pjhCommonUnit4ExtLib.bpl') then
//    begin
//      SetLength(FPackageHandles, 1);
//      FPackageHandles[0] := LoadPackage('..\Bpls\pjhCommonUnit4ExtLib.bpl');
//      FBplFileList.AddObject('pjhCommonUnit4ExtLib.bpl', Pointer(FPackageHandles[High(FPackageHandles)]));
//    end;
//
//    if FileExists('..\Bpls\pjhCompSharedPkg.bpl') then
//    begin
//      SetLength(FPackageHandles, High(FPackageHandles) + 1 + 1);
//      FPackageHandles[High(FPackageHandles)] := LoadPackage('..\Bpls\pjhCompSharedPkg.bpl');
//      FBplFileList.AddObject('pjhCompSharedPkg.bpl', Pointer(FPackageHandles[High(FPackageHandles)]));
//    end;
//
//    if FileExists('..\Bpls\ExtLib_DXE5.bpl') then
//    begin
//      SetLength(FPackageHandles, High(FPackageHandles) + 1 + 1);
//      FPackageHandles[High(FPackageHandles)] := LoadPackage('..\Bpls\ExtLib_DXE5.bpl');
//      FBplFileList.AddObject('ExtLib_DXE5.bpl', Pointer(FPackageHandles[High(FPackageHandles)]));
//    end;

    LStrList := GetFileListFromDir('..\Bpls\', '*.bpl', false);
    SetLength(FPackageHandles, LStrList.Count);

    //ExtLib_XE5.bpl 보다 pjhCommonUnit4ExtLib.bpl이 반드시 먼저 Load 되어야 함
    for i := Low(FPackageHandles) to High(FPackageHandles) do
    begin
//      if (LStrList.Strings[i] <> 'pjhCommonUnit4ExtLib.bpl') and
//         (LStrList.Strings[i] <> 'pjhCompSharedPkg.bpl') and
//         (LStrList.Strings[i] <> 'ExtLib_DXE5.bpl') then
//      begin
        FPackageHandles[i] := LoadPackage(LStrList.Strings[i]);
        FBplFileList.AddObject(LStrList.Strings[i], Pointer(FPackageHandles[i]));
      end;
//    end;
  finally
    LStrList.Free;
  end;
end;

//Load from DFM 메뉴로 컴포넌트 Load시 기존 FBplFileList에 bpl file 추가함.
//ADfc의 내용을 FDesignFormConfig에 추가함
procedure TWatchF2.LoadDesignComponentPackageFromOnlyComp(ADfc: TDesignFormConfig);
var
  i,PrevPackSize: integer;
  LStr, LDFName: string;
  LStrList,LStrList2: TStringList;
begin
  SetCurrentDir(FFilePath);

  if not Assigned(FBplFileList) then
    FBplFileList := TStringList.Create;

  LStrList := TStringList.Create;
  LStrList2 := TStringList.Create;

  try
    //전역의 BplFileList를 가져옴
    for i := 0 to FDesignFormConfig.DesignFormConfigCollect.Count - 1 do
    begin
      LStr := FDesignFormConfig.DesignFormConfigCollect.Items[i].BplFileList;
      if LStr <> '' then
      begin
        while LStr <> '' do
        begin
          LDFName := GetTokenWithComma(LStr);
          if LStrList2.IndexOf(LDFName) = -1 then
            LStrList2.Add(LDFName);
        end;
      end;
    end;
//    System.EnumModules(EnumModulesFunc, LStrList2);

    for i := 0 to ADfc.DesignFormConfigCollect.Count - 1 do
    begin
      LStr := ADfc.DesignFormConfigCollect.Items[i].BplFileList;
      if LStr <> '' then
      begin
        while LStr <> '' do
        begin
          LDFName := GetTokenWithComma(LStr);
          if LStrList2.IndexOf(LDFName) = -1 then //새로운 bpl이면 load하기 위해
          begin
            LStrList.Add(LDFName);
            LStrList2.Add(LDFName);
          end;
        end;
      end;
    end;

    if LStrList.Count > 0 then
    begin
      with FDesignFormConfig.DesignFormConfigCollect.Add do
      begin
        BplFileList := LStrList.CommaText;
        DesignFormCaption := PageControl1.ActivePage.Caption;
        DesignFormIndex := 0;
        DesignFormFileName := '';
      end;
    end;

    PrevPackSize := High(FPackageHandles) + 1;
    //LStrList에는 아직 Load되지 않은 BPL file list가 있음
    SetLength(FPackageHandles, PrevPackSize + LStrList.Count);

    for i := PrevPackSize to PrevPackSize + LStrList.Count - 1 do
    begin
      FPackageHandles[i] := LoadPackage('..\Bpls\' + LStrList.Strings[i-PrevPackSize]);
      FBplFileList.AddObject(LStrList.Strings[i-PrevPackSize], Pointer(FPackageHandles[i]));
    end;
  finally
    LStrList2.Free;
    LStrList.Free;
  end;
end;

//동적으로 생성한 디자인 폼을 파일로부터 읽어들임
//AFileName: Watchlist 파일 이름임. + _pageIndex 를 붙여서 파일을 읽어 들임
procedure TWatchF2.LoadDesignForm(AFileName: string);
var
  i,j: integer;
  LStr, LFileName, LDFName: string;
  LPage: TAdvOfficePage;
  LPanel: TpjhPanel;
  LIsLoadFrom_dfc: boolean;
begin
  if not FileExists(AFileName) then
  begin
    //ShowMessage(AFileName + ' file not found.');
    exit;
  end;

  //AFileName의 끝부분에  _dfc가 없으면  추가함
  LStr := Copy(AFileName, Length(AFileName) - 3, 4);
  LIsLoadFrom_dfc := Pos(DESIGNFORM_FILENAME, LStr) > 0;

  LFileName := AFileName;

  if not LIsLoadFrom_dfc then
  begin
    i := PosRev('_', LFileName);
    if i > 0 then
      LFileName := Copy(LFileName, 1, i-1);

    LFileName := LFileName + DESIGNFORM_FILENAME;
  end;

  FDesignFormConfig.DesignFormConfigCollect.Clear;
  FDesignFormConfig.LoadFromFile(LFileName,'',False);
//  LoadDesignComponentPackage;
  LFileName := ExtractFileName(AFileName);

  for i := 0 to FDesignFormConfig.DesignFormConfigCollect.Count - 1 do
  begin
    LDFName := FDesignFormConfig.DesignFormConfigCollect.Items[i].DesignFormFileName;

    if (not LIsLoadFrom_dfc) and (LFileName <> ExtractFileName(LDFName))then
      continue;

    LStr := FDesignFormConfig.DesignFormConfigCollect.Items[i].DesignFormCaption;
    if LStr = '' then
      LStr := 'DefaultName';

    if LIsLoadFrom_dfc then
    begin
      //PageControl1.RemoveAdvPage(PageControl1.ActivePage);
      j := PageControl1.AddAdvPage(LStr);
      LPage := PageControl1.AdvPages[j];
      PageControl1InsertPage(Self, LPage); //Design Panel 생성
      PageControl1.ActivePageIndex := j;
    end
    else
    begin
      LPage := PageControl1.ActivePage;
    end;

    LPanel := TpjhPanel(GetDesignControl(LPage));
    LoadFromDFM(LDFName, TWinControl(LPanel));
//    LoadComponentFromFile(TComponent(LPanel), LDFName);
    LPage.Hint := LDFName;
  end;

  Caption := FDesignFormConfig.MainFormCaption;
  BorderStyle := TBorderStyle(FDesignFormConfig.BorderStyle);
  PageControl1.TabSettings.Height := FDesignFormConfig.TabHeight;
end;

procedure TWatchF2.LoadDesignFormFromMenu(AFileName: string; AIsFromdfc: Boolean);
var
  LStr: string;
begin
  if AFileName = '' then
    AFileName := GetFileNameFromWatchList;

  LStr := AFileName;
  LStr := Copy(LStr, Length(LStr) -3 , 4);

  if LStr <> DESIGNFORM_FILENAME then
  begin
    if AIsFromdfc then
    begin
      ShowMessage('''dfc'' should be included at the end of the Design Form File Name!');
      exit;
    end;
  end
  else
  begin
    if not AIsFromdfc then
    begin
      ShowMessage('''dfc'' should not be included at the end of the Design Form File Name!');
      exit;
    end;
  end;

  if AIsFromdfc then
    LoadDesignForm(AFileName)
  else
    ;
end;

procedure TWatchF2.LoadDesignFormFromDFM(AFileName: string);
var
  LPage: TAdvOfficePage;
  LPanel: TpjhPanel;
  LDFName: string;
  LDesignFormConfig: TDesignFormConfig;
//  LStrLst: TStringList;
begin
  LPage := PageControl1.ActivePage;
  LPanel := TpjhPanel(GetDesignControl(LPage));

  if LPanel.ComponentCount > 0 then
  begin
    ShowMessage('This action should be on empty form.'+#13#10+'Try again on new page');
    exit;
  end;

  if AFileName = '' then
    LDFName := GetFileNameFromWatchList
  else
    LDFName := AFileName;

//  LDesignFormConfig := TDesignFormConfig.Create(nil);
//  SetCurrentDir(FFilePath+'..');
//  LStrLst := GetFileListFromDir(GetCurrentDir+'\Bpls\', '*.bpl', false);
  try
//    LDesignFormConfig.DesignFormConfigCollect.Clear;
//    AddBpllist2DFConfig(LStrLst, LDesignFormConfig);

//    LoadDesignComponentPackageFromOnlyComp(LDesignFormConfig);
    LoadFromDFM(LDFName, TWinControl(LPanel));
//    LoadComponentFromFile(TComponent(LPanel), LDFName); //이함수를 사용하면 종료시 에러 발생함(원인불명)
    LPage.Hint := LDFName;//dfm 파일 이름을 sheet의 hint에 저장 함
  finally
//    FreeAndNil(LDesignFormConfig);
//    FreeAndNil(LStrLst);
  end;
//  LoadDesignFormFromMenu('', False);
end;

procedure TWatchF2.LoadDesignFormFromdfmfile1Click(Sender: TObject);
begin
  LoadDesignFormFromDFM('');
end;

procedure TWatchF2.LoadDesignPanel1Click(Sender: TObject);
begin
  //처음 생성시 Insert 함수 실행됨
  if LoadNCreateOrShowDM then
  begin
    AssignPanel2Designer(FDesignManagerForm);
    FDesignManagerForm.Show;
  end;
end;

procedure TWatchF2.LoadFromFile1Click(Sender: TObject);
begin
  LoadTrendDataMapFromFile('');
  DisplayTrendFromMap(iPlot1, FTrendDataMap);
end;

procedure TWatchF2.LoadItemsFromFile1Click(Sender: TObject);
begin
  SetCurrentDir(FFilePath);
  JvOpenDialog1.InitialDir := WatchListPath;
  JvOpenDialog1.Filter := '*.*';

  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
//      WatchListFileName := ExtractFileName(jvOpenDialog1.FileName);
      FWG.GetItemsFromParamFile2Collect(jvOpenDialog1.FileName, FConfigOption.EngParamFileFormat,
                FConfigOption.EngParamEncrypt);
      FWG.AddEngineParameter2Grid;
      ApplyOption4AvgCalc;
    end;
  end;
end;

//Result = Create하면 True
//         Show하면 False
function TWatchF2.LoadNCreateOrShowDM: Boolean;
var
  IbMI : IbplMainInterface;
begin
  if FPackageModules[0] = 0 then
{$IFDEF USE_PACKAGE}
    FPackageModules[0] := LoadPackage('..\Forms\DesignManagerDock.bpl');
{$ELSE}
    FPackageModules[0] := 1;
{$ENDIF};

  if FPackageModules[0] <> 0 then
  begin
    try
      //@FCreateFuncFromBPL[0] := GetProcAddress(FPackageModules[0], 'Create_VisualCommForms');
    except
      ShowMessage('Package Create function: '+
        ' not found!');
      exit;
    end;

    if not Assigned(FDesignManagerFormClass) then
      FDesignManagerFormClass := TFormClass(Classes.GetClass('TfrmDesignManagerDock'));
      //FDesignManagerFormClass := Classes.GetClass('TfrmMain');

    if Assigned(FDesignManagerFormClass) then
    begin
      if not Assigned(FDesignManagerForm) then
      begin
        //Application.CreateForm(TComponentClass(FDesignManagerFormClass), FDesignManagerForm);
        FDesignManagerForm := FDesignManagerFormClass.Create(Self);
        Result := True;
      end
      else
      begin
        FDesignManagerForm.Show;
        Result := False;
      end;
    end;
  end;
end;

//파일의 첫줄은 반드시 헤더가 있어야 함.
procedure TWatchF2.LoadTrendDataFromFile(AFileName: string;
  AIsFirstFile: Boolean; AIsUseWatchList: Boolean);
var
  LStr, LIndexList: TStringList;
  LStr2,LStr3,LStr4: string;
  tmpdouble2, tmpdouble: double;
  i,j,k,LColumnCount,tmpCount: integer;
begin
  LStr:= TStringList.Create;
  try
    LStr.LoadFromFile(AFileName,TEncoding.UTF8);

    if LStr.Count = 0 then //실패했을 경우 다시 읽어 들임
    begin
      LStr.LoadFromFile(AFileName);
    end;

    if LStr.Count > 0 then
    begin
      if AIsFirstFile and (not AIsUseWatchList) then
      begin
        FTrendDataMapFromFile.Clear;
        iPlot1.RemoveAllChannels;
        iPlot1.RemoveAllYAxes;
        FWG.NextGrid1.ClearRows;
      end;

      LStr2 := LStr.Strings[0]; //Head Read
      GetTokenWithComma(LStr2); //시간은 먼저 읽어서 없앰

      LColumnCount := strTokenCount(LStr.Strings[0], ',');
      //index 0은 날짜시간이므로 제외함
      if AIsFirstFile and (not AIsUseWatchList) then
      begin //복수개의 파일중에 첫번째 파일이면 헤더 처리
        for i := 1 to LColumnCount - 1 do
        begin
          k := iPlot1.AddChannel;
          j := iPlot1.AddYAxis;
          FWG.NextGrid1.AddRow();

          LStr3 := GetTokenWithComma(LStr2);
          FWG.NextGrid1.Cell[0, i-1].AsInteger := -1;
          FWG.NextGrid1.Cell[1, i-1].AsInteger := 1;
          FWG.NextGrid1.Cell[2, i-1].AsString := LStr3;
          iPlot1.YAxis[j].Title := LStr3;
          iPlot1.YAxis[j].ScaleLinesColor := iPlot1.Channel[k].Color;
          iPlot1.YAxis[j].LabelsFont.Color := iPlot1.Channel[k].Color;
          iPlot1.Channel[k].YAxisName := iPlot1.YAxis[j].Name;
          iPlot1.Channel[k].TitleText := LStr3;
          //iPlot1.Channel[k].Name := 'C_'+ iPlot1.YAxis[j].Name;
        end;
      end;
    end;

    if not AIsUseWatchList then
    begin
      for i := 1 to LStr.Count - 1 do
      begin
        LStr2 := LStr.Strings[i];
        LStr3 := GetTokenWithComma(LStr2);
        tmpdouble2 := StrToDateTime(LStr3);

        for j := 0 to LColumnCount - 2 do
        begin
          LStr3 := GetTokenWithComma(LStr2);
          tmpdouble := StrToFloatDef(LStr3,0.0);
          iPlot1.Channel[j].AddXY(tmpdouble2, tmpdouble);
          if AIsUseWatchList then
            LStr4 := GetTagNameFromDescriptor(FWG.NextGrid1.Cell[2, j].AsString)
          else
            LStr4 := FWG.NextGrid1.Cell[2, j].AsString;

          AddData2TrendMapFromFile(LStr4, tmpdouble2, tmpdouble);
        end;//for
      end;//for
    end
    else //if AIsUseWatchList
    begin
      //Channel 수가 표시할 데이터 종류보다 작으면 데이터 종류만큼 채널 생성
      //if iPlot1.ChannelCount < FWG.NextGrid1.SelectedCount then
      //begin
        //iPlot1.RemoveAllChannels;
        //iPlot1.RemoveAllYAxes;
        DeleteAllTrend;
        //그리드에서 선택된 데이터만 Trend에 추가
        for i := 0 to FWG.NextGrid1.RowCount - 1 do
          if FWG.NextGrid1.Row[i].Selected then
            AddChannelAndYAxis(i, tdtValue);
      //end;

      LIndexList := TStringList.Create;
      try
        //k := 0;//각 Index별 간격을 저장하기 위한 기준값 초기화
        for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
        begin
          if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
          begin
            if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesMinValue <> 0 then
              iPlot1.YAxis[LColumnCount].Min := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesMinValue;
            if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesSpanValue <> 0 then
              iPlot1.YAxis[LColumnCount].Span := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesSpanValue;

            LStr2 := LStr.Strings[0];
            LStr3 := GetTokenWithComma(LStr2); //맨 앞 시간 제거
            for j := 1 to LColumnCount - 1 do
            begin
              LStr3 := GetTokenWithComma(LStr2);
              if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName = LStr3 then
              begin
                LIndexList.Add(IntToStr(j)); //이전 값과의 차이를 저장함(속도 향상을 위해)
                //k := j;
                break;
              end;
            end;
          end;
        end;//for

        LIndexList.Sort;

        for i := 1 to LStr.Count - 1 do
        begin
          LStr2 := LStr.Strings[i];
          LStr3 := GetTokenWithComma(LStr2);
          tmpdouble2 := StrToDateTime(LStr3);

          tmpCount := 0;
          for j := 0 to LIndexList.Count - 1 do
          begin
            LColumnCount := StrToInt(LIndexList.Strings[j]) - tmpCount;
            tmpCount := StrToInt(LIndexList.Strings[j]);
            for k := 1 to LColumnCount do
              LStr3 := GetTokenWithComma(LStr2);
            tmpdouble := StrToFloatDef(LStr3,0.0);
            iPlot1.Channel[j].AddXY(tmpdouble2, tmpdouble);
          end;//for
        end;//for
      finally
        FreeAndNil(LIndexList);
      end;
    end;
  finally
    FreeAndNil(LStr);
  end;
end;

procedure TWatchF2.LoadTrendDataFromFileUsingWatchList1Click(Sender: TObject);
begin
  OpenTrendDataFile(True);
end;

procedure TWatchF2.LoadTrendDataMapFromFile(AFileName: string);
begin
  if AFileName = '' then
  begin
    JvOpenDialog1.InitialDir := FFilePath;
    JvOpenDialog1.Filter := '*.dmap||*.*';
    if JvOpenDialog1.Execute then
    begin
      if jvOpenDialog1.FileName <> '' then
      begin
        AFileName := jvOpenDialog1.FileName;
      end;
    end;
  end;

  if not FileExists(AFileName) then
    exit;

  FTrendDataMap.Clear;
  FTrendDataMap := TObjStream.ReadObjectInfile(AFileName, []) as DMap;
end;

procedure TWatchF2.LoadWatchListFromFile1Click(Sender: TObject);
begin
  SetCurrentDir(FFilePath);
  JvOpenDialog1.InitialDir := WatchListPath;
  JvOpenDialog1.Filter := '*.*';

  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      WatchListFileName := ExtractFileName(jvOpenDialog1.FileName);
      GetEngineParameterFromSavedWatchListFile(False, jvOpenDialog1.FileName);
      //LoadDesignFormFromMenu(jvOpenDialog1.FileName+DESIGNFORM_FILENAME, True);
    end;
  end;
end;

procedure TWatchF2.LockUnLockValue2Screen(AIsLock: Boolean);
begin
  FEnterWatchValue2Screen := AIsLock;
  FEnterWatchAnalogValue2DesignScreen := AIsLock;
end;

procedure TWatchF2.SaveConfigData2Xml;
var
  Lstr: string;
begin
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);
  FConfigOption.SaveToJSONFile(Lstr, '', False);
end;

procedure TWatchF2.SaveConfigDataForm2Xml(AMonitorConfigF: TWatchConfigF);
var
  Lstr: string;
  i: integer;
begin
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);

  FConfigOption.FormCaption := AMonitorConfigF.CaptionEdit.Text;
  FConfigOption.ModbusFileName := AMonitorConfigF.MapFilenameEdit.FileName;
  FCurrentModbusFileName := FConfigOption.ModbusFileName;
  FConfigOption.AverageSize := StrToIntDef(AMonitorConfigF.AvgEdit.Text,1);
  WatchListFileName := AMonitorConfigF.WatchFileNameEdit.Text;

  FConfigOption.SelDisplayInterval :=AMonitorConfigF.IntervalRG.ItemIndex;
  FConfigOption.DisplayInterval := StrToIntDef(AMonitorConfigF.IntervalEdit.Text,0);
  FConfigOption.AliveSendInterval := StrToIntDef(AMonitorConfigF.AliveIntervalEdit.Text,0);

  FConfigOption.SelectAlarmValue := AMonitorConfigF.SelAlarmValueRG.ItemIndex;
  FConfigOption.MinFaultValue := StrToFloatDef(AMonitorConfigF.MinFaultEdit.Text,0.0);
  FConfigOption.MaxAlarmValue := StrToFloatDef(AMonitorConfigF.MaxAlarmEdit.Text,0.0);
  FConfigOption.MinFaultValue := StrToFloatDef(AMonitorConfigF.MinFaultEdit.Text,0.0);
  FConfigOption.MaxFaultValue := StrToFloatDef(AMonitorConfigF.MaxFaultEdit.Text,0.0);
  FConfigOption.MinAlarmColor := Longint(AMonitorConfigF.MinAlarmColorSelector.SelectedColor);
  FConfigOption.MaxAlarmColor := Longint(AMonitorConfigF.MaxAlarmColorSelector.SelectedColor);
  FConfigOption.MinFaultColor := Longint(AMonitorConfigF.MinFaultColorSelector.SelectedColor);
  FConfigOption.MaxFaultColor := Longint(AMonitorConfigF.MaxFaultColorSelector.SelectedColor);
  FConfigOption.MinAlarmBlink := AMonitorConfigF.MinAlarmBlinkCB.Checked;
  FConfigOption.MaxAlarmBlink := AMonitorConfigF.MaxAlarmBlinkCB.Checked;
  FConfigOption.MinFaultBlink := AMonitorConfigF.MinFaultBlinkCB.Checked;
  FConfigOption.MaxFaultBlink := AMonitorConfigF.MaxFaultBlinkCB.Checked;
  FConfigOption.ViewAvgValue := AMonitorConfigF.ViewAvgValueCB.Checked;
  FConfigOption.SubWatchClose := AMonitorConfigF.SubWatchCloseCB.Checked;
  FConfigOption.ZoomToFitTrend := AMonitorConfigF.ZoomToFitCB.Checked;
  FConfigOption.DefaultSoundFileName := AMonitorConfigF.DefaultSoundEdit.FileName;
  FConfigOption.NameFontSize := StrToIntDef(AMonitorConfigF.NameFontSizeEdit.Text,20);
  FConfigOption.ValueFontSize := StrToIntDef(AMonitorConfigF.ValueFontSizeEdit.Text,70);
  FConfigOption.RingBufferSize := StrToIntDef(AMonitorConfigF.RingBufSizeEdit.Text,0);
  FConfigOption.EngParamEncrypt := AMonitorConfigF.EngParamEncryptCB.Checked;
  FConfigOption.EngParamFileFormat := AMonitorConfigF.ConfFileFormatRG.ItemIndex;
  FConfigOption.MonDataSource := AMonitorConfigF.MonDataFromRG.ItemIndex;

  //MQ Server
  FConfigOption.MQServerIP := AMonitorConfigF.MQIPAddress.Text;
  FConfigOption.MQServerPort := AMonitorConfigF.MQPortEdit.Text;
  FConfigOption.MQServerUserId := AMonitorConfigF.MQUserEdit.Text;
  FConfigOption.MQServerPasswd := AMonitorConfigF.MQPasswdEdit.Text;

  FConfigOption.MQServerTopicCollect.Clear;
  for i := 0 to AMonitorConfigF.MQTopicLB.Count - 1 do
    FConfigOption.MQServerTopicCollect.Add.TopicName := AMonitorConfigF.MQTopicLB.Items[i];
  FConfigOption.DisplayAverageValue := AMonitorConfigF.DispAvgValueCB.Checked;

  FConfigOption.SaveToJSONFile(Lstr);
end;

//동적으로 생성한 디자인 폼을 저장함
//AFileName: Watchlist 파일 이름임. + _pageIndex 를 붙여서 저장함
procedure TWatchF2.SaveDesignForm(AFileName: string);
var
  i,j: integer;
  LPanel: TpjhPanel;
  LStr: string;
  LBplFileNameList: TStringList;
  LStrLst: TStringList;
  LPage: TAdvOfficePage;
begin
  SetCurrentDir(FFilePath);
  //만약 기존에 파일이 존재하면 모두 삭제함(AFileName_x, _dfc)
  try
    LStrLst := GetFileListFromDir('..\WatchList\', ExtractFileName(AFileName) + '*', false);
    for i := 0 to LStrLst.Count - 1 do
    begin
      if UpperCase(ExtractFileName(LStrLst.Strings[i])) <> UpperCase(ExtractFileName(AFileName)) then
        DeleteFile(LStrLst.Strings[i]);
    end;

  finally
    LStrLst.Free;
  end;

  //Design Form이 존재할 경우
  if PageControl1.AdvPageCount > DYNAMIC_PAGE_INDEX then
  begin
    FDesignFormConfig.DesignFormConfigCollect.Clear;
    LBplFileNameList := TStringList.Create;
    try
      for i := DYNAMIC_PAGE_INDEX to PageControl1.AdvPageCount - 1 do
      begin
        LStr := AFileName + '_' + IntToStr(i);
        LPanel := TpjhPanel(GetDesignControl(PageControl1.AdvPages[i]));
        SaveToDFM(LStr, TWinControl(LPanel));
//          SaveComponentToFile(TComponent(LPanel), LStr);
        with FDesignFormConfig.DesignFormConfigCollect.Add do
        begin
          for j := DYNAMIC_PAGE_INDEX to PageControl1.AdvPageCount - 1 do
          begin
            LPage := PageControl1.AdvPages[j];
            GetBplNamesFromDesignPanel(LBplFileNameList, LPage);
          end;

          BplFileList := LBplFileNameList.CommaText;
          DesignFormCaption := PageControl1.AdvPages[i].Caption;
          DesignFormIndex := i;
          DesignFormFileName := LStr;
        end;
      end; //for

      FDesignFormConfig.MainFormCaption := Caption;
      FDesignFormConfig.BorderStyle := ord(BorderStyle);
      FDesignFormConfig.TabHeight := PageControl1.TabSettings.Height;

    finally
      FreeAndNil(LBplFileNameList);
    end;

    FDesignFormConfig.SaveToFile(AFileName + DESIGNFORM_FILENAME);
  end;
end;

//Tab Change시에 FromPage의 TpjhPanel.Tag에 Designer.Active상태 저장
//Page 복원시에 적용하기 위함
procedure TWatchF2.SaveDesignMode2ControlTag(APageIndex: Integer);
var
  IbMI : IbplMainInterface;
  LPage: TAdvOfficePage;
  LPanel: TpjhPanel;
  i: integer;
begin
  if APageIndex >= PageControl1.AdvPageCount then
    exit;

  LPage := PageControl1.AdvPages[APageIndex];

  for i := 0 to LPage.ComponentCount - 1 do
  begin
    if LPage.Components[i] is TpjhPanel then
    begin
      LPanel := LPage.Components[i] as TpjhPanel;
      if Assigned(FDesignManagerForm) then
      begin
        if Supports(FDesignManagerForm, IbplMainInterface, IbMI) then
        begin
          LPanel.Tag := BoolToInt(IbMI.Designer.Active)+1;//0일 경우 처음 생성한 것임
          break;
        end;
      end;
    end;
  end;
end;

procedure TWatchF2.SaveDMap2File(AFileName: string; AMap: DMap);
begin
  if AFileName = '' then
  begin
    JvSaveDialog1.InitialDir := FFilePath;
    JvSaveDialog1.Filter :=  '*.dmap||*.*';

    if JvSaveDialog1.Execute then
    begin
      AFileName := JvSaveDialog1.FileName;

      if FileExists(AFileName) then
      begin
        if MessageDlg('File is already existed. Are you overwrite? if No press, then the data is not saved!.',
        mtConfirmation, [mbYes, mbNo], 0)= mrNo then
          exit;
      end;
    end;
  end;

  TObjStream.WriteObjectToFile(AFileName, [], AMap);
end;

procedure TWatchF2.SaveDMultiMap2File(AFileName: string; AMap: DMultiMap);
var
  it: DIterator;
  LDoublePoint: TDoublePoint;
  LStr, LStr2: string;
begin
  it := AMap.startKey;
  SetToValue(it);

  while not atEnd(it) do
  begin
    LDoublePoint := GetObject(it) as TDoublePoint;
    LStr := format('%f'+#9+'%f',[LDoublePoint.X,LDoublePoint.Y]);
    LStr2 := 'dat';
    SaveData2DateFile(AFileName, LStr2, LStr, soFromEnd);
    Advance(it);
  end;//while
end;

procedure TWatchF2.SaveOnlyDFM1Click(Sender: TObject);
var
  LFileName: string;
begin
  SetCurrentDir(FFilePath);
  JvSaveDialog1.InitialDir := '..\WatchList';

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

  SaveOnlyDFMofCurPage(LFileName);
end;

//현재 페이지의 컴포넌트를 저장함.
procedure TWatchF2.SaveOnlyDFMofCurPage(AFileName: string);
var
  LPanel: TpjhPanel;
begin
  LPanel := TpjhPanel(GetDesignControl(PageControl1.ActivePage));
  SaveToDFM(AFileName, TWinControl(LPanel));
//  SaveComponentToFile(TComponent(LPanel), AFileName);
end;

procedure TWatchF2.SaveWatchList(AFileName: string; ASaveWatchListFolder: Boolean = True);
var
  i, LChCount: integer;
  LStr, LWatchListPath: string;
  LUser, LUser2: THiMECSUserLevel;
  LDeleteFileList : TStringList;
begin
  if ASaveWatchListFolder then
  begin
    LWatchListPath := WatchListPath;
    AFileName := ExtractFileName(AFileName);
  end
  else
    LWatchListPath := '';

  //Administrator 이상의 권한만 저장 가능함
  if (IPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator) and
      (AllowUserlevelCB.Enabled) and (AllowUserlevelCB.Text <> '') then
  begin
    i := Length(AFileName);
    LStr := System.Copy(AFileName,i,1);

    if LStr <> '' then
    begin
      i := StrToIntDef(LStr,-1);
      //사용자 지정 파일 이름이면 끝문자가 숫자가 아닐 수 있음
      if i <> -1 then
      begin
        LUser := THiMECSUserLevel(i);
        LUser2 := String2UserLevel(AllowUserlevelCB.Text);

        if LUser2 <> LUser then  //ComboBox User Level과 filename의 user level 비교
        begin
          if FileExists(LWatchListPath+AFileName) then
          begin
            if MessageDlg('ComboBox User and FileName user level are different.'+#13#10+'Change file name to ComboBox User Level?',
                                        mtConfirmation, [mbYes, mbNo], 0)= mrYes then
            begin
              LDeleteFileList := TStringList.Create;
              try
                GetFiles(LDeleteFileList, LWatchListPath+AFileName);
                for i := 0 to LDeleteFileList.Count - 1 do
                  ;//DeleteFile(LDeleteFileList.Strings[i]);
              finally
                LDeleteFileList.Free;
              end;

              //DeleteFile(LWatchListPath+AFileName);
              AFileName := formatDateTime('yyyymmddhhnnsszz',now)+
              IntToStr(FConfigOption.EngParamFileFormat) + IntToStr(Ord(LUser2));
            end;
          end;
        end;
      end;//if LUser <> -1
    end;

    IPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := String2UserLevel(AllowUserlevelCB.Text);
  end
  else
    IPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := IPCMonitorAll1.FCurrentUserLevel;

  IPCMonitorAll1.FEngineParameter.ExeName := ExtractFileName(Application.ExeName);

  if not FIsMDIChileMode then
  begin
    IPCMonitorAll1.FEngineParameter.FormWidth := Width;
    IPCMonitorAll1.FEngineParameter.FormHeight := Height;
    IPCMonitorAll1.FEngineParameter.FormTop := Top;
    IPCMonitorAll1.FEngineParameter.FormLeft := Left;
    IPCMonitorAll1.FEngineParameter.FormState := TpjhWindowState(WindowState);
    IPCMonitorAll1.FEngineParameter.SaveWatchForm := SaveListCB.Checked;
    IPCMonitorAll1.FEngineParameter.StayOnTop := StayOnTopCB.Checked;
    IPCMonitorAll1.FEngineParameter.UseAlphaBlend := EnableAlphaCB.Checked;
    IPCMonitorAll1.FEngineParameter.AlphaValue := JvTrackBar1.Position;
    IPCMonitorAll1.FEngineParameter.TabShow := PageControl1.TabSettings.Height > 0;
    IPCMonitorAll1.FEngineParameter.BorderShow := BorderStyle <> bsNone;
  end;

  LChCount := 0;

  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
    begin
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesMinValue :=
            iPlot1.YAxis[LChCount].Min;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesSpanValue :=
            iPlot1.YAxis[LChCount].Span;
      Inc(LChCount);
    end;
  end;

  if LWatchListPath <> '' then
  begin
    SetCurrentDir(FFilePath);
    if not setcurrentdir(LWatchListPath) then
      createdir(LWatchListPath);
  end;

  SetCurrentDir(FFilePath);

  if AFileName = '' then //file name 앞에 프로그램명(1=HiMECS_Watch2.exe) 붙임
    LStr := LWatchListPath+formatDateTime('1yyyymmddhhnnsszz',now)+
      IntToStr(FConfigOption.EngParamFileFormat) +
      IntToStr(Ord(IPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList))
  else
    LStr := LWatchListPath+AFileName;

  //IPCMonitorAll1.FEngineParameter.SaveToFile(LStr);
  if FConfigOption.EngParamFileFormat = 0 then //XML format
    IPCMonitorAll1.FEngineParameter.SaveToFile(LStr,
              ExtractFileName(LStr),FConfigOption.EngParamEncrypt)
  else
  if FConfigOption.EngParamFileFormat = 1 then //JSON format
    IPCMonitorAll1.FEngineParameter.SaveToJSONFile(LStr,
              ExtractFileName(LStr),FConfigOption.EngParamEncrypt);

  SaveWatchListFileOfSummary(LStr);

  SaveDesignForm(LStr);
end;

procedure TWatchF2.SaveWatchListFileOfSummary(AFileName: string);
var
  LFS: TJclFileSummary;
  LFSI: TJclFileSummaryInformation;
begin
//  LFS:= TJclFileSummary.Create(AFileName, fsaReadWrite, fssDenyAll);
//  try
//    LFS.GetPropertySet(TJclFileSummaryInformation, LFSI);
//    if Assigned(LFSI) then
//    begin
//      LFSI.Template := IPCMonitorAll1.FEngineParameter.ProjectFileName;
//    end;
//  finally
//    FreeAndNil(LFSI);
//    LFS.Free;
//  end;
end;

procedure TWatchF2.SaveWatchLittoNewName1Click(Sender: TObject);
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

procedure TWatchF2.SelectItemsClick(Sender: TObject);
begin
  SelectTrendItemsForXYGraph;
end;

procedure TWatchF2.SelectTrendItemsForXYGraph;
var
  i: integer;
begin
  with TCopyWatchListF.Create(nil) do
  begin
    FWG.NextGrid1.SaveToTextFile(TEMPFILENAME);
    SelectGrid.LoadFromTextFile(TEMPFILENAME);

    for i := 0 to iXYPlot1.ChannelCount - 1 do
    begin
      ChannelListCB.AddItem(iXYPlot1.Channel[i].Name,self);
    end;

    while True do
    begin
      if ShowModal = mrOK then
      begin
        if ChannelListCB.Text = '' then
        begin
          ShowMessage('Select channel!');
          ChannelListCB.SetFocus;
          continue;
        end;

        for i := 0 to SelectGrid.RowCount - 1 do
          SelectGrid.Cell[7,i].AsBoolean := SelectGrid.Row[i].Selected; //hidden field

        SelectGrid.SaveToTextFile(TEMPFILENAME);
        FWG.NextGrid1.ClearRows;
        FWG.NextGrid1.LoadFromTextFile(TEMPFILENAME);

        for i := 0 to FWG.NextGrid1.RowCount - 1 do
          FWG.NextGrid1.Row[i].Selected := FWG.NextGrid1.Cell[7,i].AsBoolean;

        if DetermineIndexForXYGraph(ChClearCB.Checked) then //X,Y의 Parameter Index 저장
        begin
          //DataViewZHorz에 select 된 Channel index 저장
          iXYPlot1.DataViewZHorz := ChannelListCB.ItemIndex;
          iXYPlot1.Channel[ChannelListCB.ItemIndex].MarkersVisible := True;
          iXYPlot1.Channel[ChannelListCB.ItemIndex].MarkersStyle := TiPlotMarkerStyle(1);
          break;
        end;
      end
      else
        break;
    end;
  end;//with
end;

procedure TWatchF2.SellectAll1Click(Sender: TObject);
begin
  FWG.NextGrid1.SelectAll;
end;

procedure TWatchF2.SendAliveOk;
var
  AsyncTask: ITask;
begin
  AsyncTask := FTaskPool.AcquireTask(OnAsynchronousIPCTask, 'AsyncTask');
  //AsyncTask.Values.Ensure('ComputerName').AsString := eComputerName.Text;
  AsyncTask.Values.Ensure('ServerName').AsString := FDummyFormHandle;//HIMECS_CROMIS_SERVER_NAME;
  AsyncTask.Run;
end;

procedure TWatchF2.SetAlarm4OriginalOption(AValue: double; AEPIndex: integer);
var
  LSoundF: string;
begin
  if AEPIndex < 0 then
    exit;

  if (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultEnable) and
    (AValue > IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultValue) then
  begin
    FCurrentChangeColor := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultColor;
    FBlinkEnable := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultSoundEnable then
    begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  if (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmEnable) and
    (AValue > IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmValue) then
  begin
    FCurrentChangeColor := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmColor;
    FBlinkEnable := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmSoundEnable then
    begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  if (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultEnable) and
    (AValue < IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultValue) then
  begin
    FCurrentChangeColor := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultColor;
    FBlinkEnable := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultSoundEnable then
    begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  if (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmEnable) and
    (AValue < IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmValue) then
  begin
    FCurrentChangeColor := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmColor;
    FBlinkEnable := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmSoundEnable then
    begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  begin
    FBlinkEnable := False;
    FBlinkOn := False;
    ChangeDispPanelColor(clBlack);
    ExecuteSound('', true);
  end;
end;

procedure TWatchF2.SetAlarm4ThisOption(AValue: double);
begin
  if AValue > FConfigOption.MaxAlarmValue then
  begin
    FCurrentChangeColor := FConfigOption.MaxAlarmColor;
    FBlinkEnable := FConfigOption.MaxAlarmBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);
  end
  else
  if AValue > FConfigOption.MaxFaultValue then
  begin
    FCurrentChangeColor := FConfigOption.MaxFaultColor;
    FBlinkEnable := FConfigOption.MaxFaultBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);
  end
  else
  if AValue < FConfigOption.MinAlarmValue then
  begin
    FCurrentChangeColor := FConfigOption.MinAlarmColor;
    FBlinkEnable := FConfigOption.MinAlarmBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);
  end
  else
  if AValue < FConfigOption.MinFaultValue then
  begin
    FCurrentChangeColor := FConfigOption.MinFaultColor;
    FBlinkEnable := FConfigOption.MinFaultBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);
  end
  else
  begin
    FBlinkEnable := False;
    FBlinkOn := False;
    ChangeDispPanelColor(clBlack);
  end;
end;

procedure TWatchF2.SetConfigData;
var
  EngMonitorConfigF: TWatchConfigF;
begin
  EngMonitorConfigF := TWatchConfigF.Create(Application);
  with EngMonitorConfigF do
  begin
    try
      LoadConfigDataVar2Form(EngMonitorConfigF);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2Xml(EngMonitorConfigF);
        LoadConfigDataXml2Var;
        //FExhTempAvg_A.Size := FConfigOption.AverageSize;
        ApplyAvgSize;
        ApplyOption;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TWatchF2.SetMatrix;
var
  LSetMatrixForm: TSetMatrixForm;
  i,j: integer;
  LStr: string;
begin
  i := FWG.NextGrid1.SelectedRow;

  if not (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterType in TMatrixTypes) then
  begin
    ShowMessage('ParameterType should be one of Matrix types!');
    exit;
  end;

  LSetMatrixForm := TSetMatrixForm.Create(Self);
  try
    LSetMatrixForm.FParamItemIndex := i;
    LSetMatrixForm.FEngineParameter.Assign(IPCMonitorAll1.FEngineParameter);
    LSetMatrixForm.MoveParameter2Grid;
    LSetMatrixForm.SetDisplay;
    LSetMatrixForm.ShowModal;
  finally
    j := IPCMonitorAll1.FEngineParameter.ComparePublicMatrix(LSetMatrixForm.FEngineParameter);

    if j <> 0 then
    begin
      LStr := 'Parameter data is modified. Do you want to accept?'+#13#10#13#10+
          'Yes: Adapt to current parameter on memory, No: discard changed.';
      if MessageDlg(LStr, mtConfirmation, [mbYes, mbNo], 0)= mrYes then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
        IPCMonitorAll1.FEngineParameter.MatrixCollect.Clear;
        IPCMonitorAll1.FEngineParameter.Assign(LSetMatrixForm.FEngineParameter);
      end;
    end;

    FreeAndNil(LSetMatrixForm);
  end;
end;

procedure TWatchF2.SetWatchListFileName(AFileName: string);
begin
  FWatchListFileName := AFileName;
  FConfigOption.WatchListFileName := FWatchListFileName;
end;

procedure TWatchF2.ShowEngineName1Click(Sender: TObject);
begin
  ShowMessage(IPCMonitorAll1.GetEventData_PLCMODBUS_ListName);
end;

procedure TWatchF2.ShowEventName1Click(Sender: TObject);
begin
  ShowMessage(FWG.FEventName4Item);
end;

procedure TWatchF2.ShowHideGridRowIndex(AShowIndex: Boolean);
var
  i: integer;
  LColumn: TNxCustomColumn;
  LExistIndex: Boolean;
begin
  i := FWG.NextGrid1.Columns.Count;

  LExistIndex := FWG.NextGrid1.Columns.Item[i-1].Name = 'ParamIndex';

  if AShowIndex then
  begin
    if LExistIndex then
      exit
    else
    begin
      LColumn := FWG.NextGrid1.Columns.Add(TNxIncrementColumn, 'Index');
      LColumn.Name := 'ParamIndex';
    end;
  end
  else
  begin

  end;
end;

procedure TWatchF2.ShowMQName1Click(Sender: TObject);
var
  LStr: string;
  i: integer;
begin
  LStr := 'MQ Server IP : ' + FConfigOption.MQServerIP + #13#10 +
    'MQ Server Port : ' + FConfigOption.MQServerPort + #13#10 +
    'MQ User : ' + FConfigOption.MQServerUserId + #13#10 +
    'MQ Queue Name : ';

  for i := 0 to FConfigOption.MQServerTopicCollect.Count - 1 do
    LStr := LStr + FConfigOption.MQServerTopicCollect.Items[i].TopicName + #13#10;

  ShowMessage(LStr);
end;

procedure TWatchF2.ShowWindowsHandle1Click(Sender: TObject);
begin
  ShowMessage(IntToStr(Handle));
end;

procedure TWatchF2.StayOnTopCBClick(Sender: TObject);
begin
  if StayOnTopCB.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure DoublePointIO(obj: TObject; stream: TObjStream;
  direction: TObjIODirection; version: Integer; var callSuper: Boolean);
begin
  with obj as TDoublePoint do
    stream.TransferItemsEx([x,y], [@x,@y],[ssvtDateTime,ssvtDouble], direction, version);
    //stream.transferItems([x,y], [@x,@y], direction, version);
    //stream.TransferBlocks([FBitmapData], [FBitmapSize], direction);
  //callSuper := False;
end;

procedure TWatchF2.Timer1Timer(Sender: TObject);
var
  i,j: integer;
begin
  Timer1.Enabled := False;
  try
    if FMonitorStart then
    begin
      DisplayMessage('');
    end;

    if FBlinkEnable then
    begin
      if FBlinkOn then
        ChangeDispPanelColor(TColor(FCurrentChangeColor))
      else
        ChangeDispPanelColor(clBlack);
    end;

    if FFirst then
    begin
      FFirst := False;
      UserLevel2Strings(AllowUserlevelCB.Items);
      FWG.NextGrid1.PopupMenu := WatchListPopup;

      AdjustComponentByUserLevel;

      if FConfigOption.AliveSendInterval = 0 then
        Timer1.Interval := 10000
      else
        Timer1.Interval := FConfigOption.AliveSendInterval;

      ///======================================================================
      //LStr := Format('%s (%X)', [Application.Title, GetCurrentProcessID]);
      //Label4.Caption := IntToStr(GetCurrentProcessID);
      try
//        IPCClient_HiMECS_MDI := TIPCClient_HiMECS_MDI.Create(Handle, Self.Caption);
        //IPCClient_HiMECS_MDI := TIPCClient_HiMECS_MDI.Create(GetCurrentProcessID, LStr);
        //IPCClient_HiMECS_MDI.OnConnect := OnConnect;
        //IPCClient_HiMECS_MDI.OnSignal := OnSignal;
//        IPCClient_HiMECS_MDI.Activate;

//        if IPCClient_HiMECS_MDI.State <> stConnected then
//          OnConnect(nil, False);
      except
//        Application.HandleException(ExceptObject);
//        Application.Terminate;
      end;
    end;

    //SendAliveOk;
  finally
    FMonitorStart := True;
    Timer1.Enabled := True;
  end;//try

end;

procedure TWatchF2.ToggleBorderStyle;
begin
  if BorderStyle = bsNone then
    BorderStyle := bsSizeable
  else
    BorderStyle := bsNone;
end;

procedure TWatchF2.ToggleStayOnTop;
begin
  if FormStyle = fsNormal then
    FormStyle := fsStayOnTop
  else
  if FormStyle = fsStayOnTop then
    FormStyle := fsNormal;
end;

procedure TWatchF2.ToggleTabShow;
begin
  if PageControl1.TabSettings.Height = 0 then
    PageControl1.TabSettings.Height := 26
  else
    PageControl1.TabSettings.Height := 0;
end;

procedure TWatchF2.ToggleWindowMaxmize;
begin
  if WindowState = wsMaximized then
    WindowState := wsNormal
  else
    WindowState := wsMaximized;
end;

//AStr: 'x축tagname;y축tagname'
procedure TWatchF2.FillXYMapFromFile(AXYMap: DMultiMap; AList: TStringList;
  AIsDuplicated: Boolean; AStr: string);
var
  LStr2,LStr3,TagX,TagY: string;
  i,j,k,LColumnCount,X_Index,Y_Index: integer;
  tmpdouble, tmpdouble2: double;
  IsXFirst: boolean;
begin
  LColumnCount := strTokenCount(AList.Strings[0], ',');
  TagX := strToken(AStr,';'); //X축 Tag name
  TagY := strToken(AStr,';'); //Y축 Tag name
    
  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayXY then
    begin
      LStr2 := AList.Strings[0];
      LStr3 := GetTokenWithComma(LStr2); //맨 앞 시간 제거
      for j := 1 to LColumnCount - 1 do
      begin
        LStr3 := GetTokenWithComma(LStr2);
        if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName = LStr3 then
        begin
          if LStr3 = TagX then
            X_Index := j
          else
            Y_Index := j;
          break;
        end;
      end;
    end;
  end;//for

  if X_Index <= Y_Index then  //X축 Index 숫자가 작으면 True
    IsXFirst := True
  else
    IsXFirst := False;
      
  for i := 1 to AList.Count - 1 do
  begin
    LStr2 := AList.Strings[i];
    LStr3 := GetTokenWithComma(LStr2);

    if IsXFirst then  //Index가 작은 것 부터 먼저 값을 가져옴
      LColumnCount := X_Index
    else
      LColumnCount := Y_Index;

    for k := 1 to LColumnCount do
      LStr3 := GetTokenWithComma(LStr2);
        
    if IsXFirst then
      tmpdouble := StrToFloatDef(LStr3,0.0) //x값
    else
      tmpdouble2 := StrToFloatDef(LStr3,0.0); //Y값
        
    if IsXFirst then
      LColumnCount := Y_Index - X_index
    else
      LColumnCount := X_Index - Y_Index;
          
    for k := 1 to LColumnCount do
      LStr3 := GetTokenWithComma(LStr2);
        
    if IsXFirst then
      tmpdouble2 := StrToFloatDef(LStr3,0.0)
    else
      tmpdouble := StrToFloatDef(LStr3,0.0);

    if AIsDuplicated then
      XYDataAdd2Map(AXYMap, tmpdouble, tmpdouble2, True)
    else
      ReplaceOrAddMap(AXYMap, tmpdouble, tmpdouble2, True);
  end;//for
end;

procedure TWatchF2.FormClose(Sender: TObject; var Action: TCloseAction);
var
  LUserLevel: THiMECSUserLevel;
  it: DIterator;
  LArray: DArray;
  i: integer;
  LDeleteFileList: TStringList;
begin
  FMonitorStart := False;
  Timer1.Enabled := False;
  SendMessage(FOwnerHandle, WM_WATCHFORM_CLOSE, FOwnerListIndex, 0);

  FCommandLine.Free;

  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;

  if FConfigOption.MonDataSource = 2 then //MonDataSource = By MQ
    DestroySTOMP;

  if SaveListCB.Checked then
    SaveWatchList(FConfigOption.WatchListFileName)
  else
  begin
    if FConfigOption.WatchListFileName <> '' then
    begin
      if FileExists(WatchListPath+WatchListFileName) then
      begin
        //LUserLevel := IPCMonitorAll1.FCurrentUserLevel;
        //if IPCMonitorAll1.CheckUserLevelForWatchListFile(WatchListFilename, LUserLevel) then
        //begin
          //if MessageDlg('Do you want to delete the watch list file?',
          //                        mtConfirmation, [mbYes, mbNo], 0)= mrYes then
          //begin
          //  LDeleteFileList := TStringList.Create;
          //  try
          //    GetFiles(LDeleteFileList, WatchListPath+WatchListFileName);
          //    for i := 0 to LDeleteFileList.Count - 1 do
          //      DeleteFile(LDeleteFileList.Strings[i]);
          //  finally
          //    LDeleteFileList.Free;
          //  end;
          //end;
        //end;
      end;
    end;
  end;

  if FConfigOption.SubWatchClose then
    for i := Low(FWatchHandles) to High(FWatchHandles) do
      SendMessage(FWatchHandles[i], WM_CLOSE, 0, 0);

  FWatchHandles := nil;

  IPCAll_Final;

  FCriticalSection.Free;

  ObjFree(FAddressMap);
  FAddressMap.free;

  it := FTrendDataMap.start;
  while not atEnd(it) do
  begin
    LArray := GetObject(it) as DArray;
    ObjFree(LArray);
    advance(it);
    //LArray.Free;
  end;

  ObjFree(FTrendDataMap);
  FTrendDataMap.Free;

  it := FTrendDataMapFromFile.start;
  while not atEnd(it) do
  begin
    LArray := GetObject(it) as DArray;
    ObjFree(LArray);
    advance(it);
    //LArray.Free;
  end;

  ObjFree(FTrendDataMapFromFile);
  FTrendDataMapFromFile.Free;

  //Grid.Data의 StringList 해제
//  FreeStrListFromGrid;

  ObjFree(FXYDataMap);
  FXYDataMap.Free;


  FConfigOption.Free;
  FDesignFormConfig.Free;

  //IPCMonitorAll1.FEngineParameter.Free;

  FMsgList.Free;
  FWatchCA.Free;

  DestroyDynamicPanel;
  CloseDesignPanel1Click(nil);

  if Assigned(FPackageModules) then
  begin
    for i := Low(FPackageModules) to High(FPackageModules) do
      if FPackageModules[i] <> 0 then
        UnloadAddInPackage(TComponent(Self), HMODULE(FPackageModules[i]));
        //UnloadPackage(FPackageModules[i]);

    FPackageModules := nil;
  end;

  if Assigned(FPackageHandles) then
  begin
    for i := Low(FPackageHandles) to High(FPackageHandles) do
      if FPackageHandles[i] <> 0 then
        UnloadAddInPackage(TComponent(Self), HMODULE(FPackageHandles[i]));
        //UnloadPackage(FPackageModules[i]);
    FPackageHandles := nil;
  end;

  FCreateFuncFromBPL := nil;
  FBplFileList.Free;

//  IPCClient_HiMECS_MDI.Free;

  FTaskPool.Finalize;
  FTaskPool.Free;

  if FIsAutoFree then
    Action := caFree;
end;

//Trend에서 Channel Delete 시에 Channel Index를 재조정하는 함수
procedure TWatchF2.UpdateChannelIndex(AIndex: integer);
var
  i,j: integer;
begin
  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
    if AIndex < j then
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex := j - 1;

    j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex;
    if AIndex < j then
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex := j - 1;

    j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex;
    if AIndex < j then
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex := j - 1;
  end;
end;

procedure TWatchF2.UpdateStatusBar(var Msg: TMessage);
const
  ConnectStr: Array[Boolean] of PChar = ('Not Connected', 'Connected');
begin
  JvStatusBar1.SimpleText := ConnectStr[Boolean(Msg.WParam)];
end;

procedure TWatchF2.UpdateYAxisIndex(AIndex: integer);
var
  i,j: integer;
begin
  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendYAxisIndex;
    if AIndex < j then
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendYAxisIndex := j - 1;
  end;
end;

procedure TWatchF2.Value2Screen_Analog_ECS_kumo(AName: string; AValue: Integer;
  AMaxVal: real);
var
  LisPress: boolean;
  LComponent, LComponent2: TComponent;
  Le: Single;
  LPos: integer;
  LStr: string;
begin
  FCriticalSection.Enter;

  try
    LisPress := False;
    LComponent2 := nil;

    LComponent := FindComponent(AName);
    if Assigned(LComponent) then
    begin
      Le := (AValue * AMaxVal) / 4095;

      if (AName = 'AI_ENGINERPM') then //Engine RPM
      begin
        with TPanel(LComponent) do
          Caption := IntToStr(Round(Le));

        with TiAngularGauge(FindComponent(AName+'_G')) do
          Position := Round(Le);

        with TPanel(FindComponent(AName+'_P')) do
          Caption := IntToStr(Round(Le));

      end
      else if (AName = 'AI_TC_A_RPM') or (AName = 'AI_TC_B_RPM') then
      begin
        with TPanel(LComponent) do
          Caption := IntToStr(Round(Le));

        with TiAngularGauge(FindComponent(AName+'_G')) do
          Position := Round(Le);

        with TPanel(FindComponent(AName+'_P')) do
          Caption := IntToStr(Round(Le));
      end
      else
      begin
        if System.Pos('AI_EXH_',AName) > 0 then
        begin
          LComponent2 := FindComponent(AName+'_L');
          if Assigned(LComponent2) then
            TiLedBar(LComponent2).Position := Round(Le);

          TPanel(LComponent).Caption := IntToStr(Round(Le));

          LPos := Pos('AI_EXH_A_',AName);
          if LPos > 0 then
          begin
            LStr := Copy(AName,LPos+9,Length(AName)-LPos-8);
            if StrToIntDef(LStr,FConfigOption.AverageSize+1) <= FConfigOption.AverageSize then
            begin //숫자가 아닌것은 FConfigOption.AverageSize 보다 1 크게
              //FExhTempAvg_A.Put(Le);
              //LComponent2 := FindComponent('AI_EXH_A_Avg');
              //if Assigned(LComponent2) then
              //  TPanel(LComponent2).Caption := IntToStr(Round(FExhTempAvg_A.Average));
                //TiSevenSegmentInteger(LComponent2).Value := Round(FExhTempAvg_A.Average);

              //LComponent2 := nil;
              //LComponent2 := FindComponent('AI_EXH_A_Avg_L');
              //if Assigned(LComponent2) then
              //  TiLedBar(LComponent2).Position := Round(FExhTempAvg_A.Average);
            end;
          end
          else
          begin
            LPos := Pos('AI_EXH_B',AName);
            if LPos > 0 then
            begin
              LStr := Copy(AName,LPos+9,Length(AName)-LPos-8);
              if StrToIntDef(LStr,FConfigOption.AverageSize+1) <= FConfigOption.AverageSize then
              begin //숫자가 아닌것은 FConfigOption.AverageSize 보다 1 크게
                //FExhTempAvg_B.Put(Le);
                //LComponent2 := FindComponent('AI_EXH_B_Avg');
                //if Assigned(LComponent2) then
                //  TPanel(LComponent2).Caption := IntToStr(Round(FExhTempAvg_B.Average));
                  //TiSevenSegmentInteger(LComponent2).Value := Round(FExhTempAvg_B.Average);

                //LComponent2 := nil;
                //LComponent2 := FindComponent('AI_EXH_B_Avg_L');
                //if Assigned(LComponent2) then
                // TiLedBar(LComponent2).Position := Round(FExhTempAvg_B.Average);
              end;
            end;
          end;
        end
        else
        begin
          //with TiAnalogDisplay(LComponent) do
          //begin
            //Value := Le;
            {if LisPress then
              Caption := format('%.2f', [AValue * AMaxVal])
            else
              Caption := format('%.f', [AValue * AMaxVal]);
            }
          //end;
        end;
      end;
    end;//if Assigned(LComponent)
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TWatchF2.Value2Screen_Digital_ECS(Name: string; AValue: Integer;
  AMaxVal: real; AContact: integer);
begin

end;

procedure TWatchF2.Value2Screen_ECS_AVAT(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
var
  Le: Single;
  LIsFloat: boolean;
  LStr: string;
begin
  if AHiMap.FAlarm then //Analog data
  begin
    if AModbusMode = 3 then
      Le := AHiMap.FValue
    else
      Le := AHiMap.FValue * AHiMap.FMaxval;

    LIsFloat := IsFloat(Le);

    if LIsFloat then
    begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].RadixPosition > 1 then
        LStr := IntToStr(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].RadixPosition)
      else
        LStr := '1';

      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := format('%.'+LStr+'f',[Le]);
    end
    else
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));

    WatchValue2Screen_Analog(AHiMap.FName, FWatchValue, AEPIndex);
  end
  else //Digital data
  begin

  end;
end;

//AModbusMode = 3 Rtu mode simulate
procedure TWatchF2.Value2Screen_ECS_kumo(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
var
  Le: Single;
begin
  if AHiMap.FAlarm then //Analog data
  begin
    if AModbusMode = 3 then
      Le := AHiMap.FValue
    else
      Le := (AHiMap.FValue * AHiMap.FMaxval) / 4095;

    if (AHiMap.FName = 'AI_ENGINERPM') then //Engine RPM
    begin
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));
    end
    else if (AHiMap.FName = 'AI_TC_A_RPM') or (AHiMap.FName = 'AI_TC_B_RPM') then
    begin
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));
    end
    else
    begin
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));
    end;

    WatchValue2Screen_Analog(AHiMap.FName, FWatchValue, AEPIndex);
  end
  else //Digital data
  begin

  end;
end;

procedure TWatchF2.ValueButtonClick(Sender: TObject);
begin
  SetMatrix;
end;

procedure TWatchF2.DataSave1Click(Sender: TObject);
var
  i,j,LHandle: integer;
  LProcessId: THandle;
begin
  if FWG.NextGrid1.SelectedCount > 0 then
  begin
    SetCurrentDir(FFilePath);
    LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FFilePath)+HiMECSWatchSaveName);
    LHandle := DSiGetProcessWindow(LProcessId);
    SetLength(FWatchHandles, Length(FWatchHandles)+1);
    FWatchHandles[High(FWatchHandles)] := LHandle;

    for i := 0 to FWG.NextGrid1.RowCount - 1 do
    begin
      if FWG.NextGrid1.Row[i].Selected then
      begin
        IPCMonitorAll1.MoveEngineParameterItemRecord2(FWG.FEngineParameterItemRecord,i);
        FWG.FPM.SendEPCopyData(Handle, LHandle,FWG.FEngineParameterItemRecord);
        //exit;
      end;
    end;
  end;
end;

procedure TWatchF2.DeleteAlarmValueFromTrend1Click(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.Row[i].Selected then
    begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm := false;
        j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex;
        iPlot1.DeleteChannel(j);
        UpdateChannelIndex(j);
      end;
    end;
  end;
end;

procedure TWatchF2.DeleteAllTrend;
var
  i,j: integer;
begin
  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend := False;
    IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm := False;
    IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault := False;
    FWG.NextGrid1.Cell[1, i].AsInteger := -1;
  end;

  iPlot1.RemoveAllYAxes;
  iPlot1.RemoveAllChannels;
end;

procedure TWatchF2.DeleteEngineParamterFromGrid(AIndex: integer);
begin
  FWG.FreeStrListFromGrid(AIndex);
  DeleteFromTrend1Click(nil);
  DeleteItem2pjhTagInfo(AIndex);
  FWG.NextGrid1.DeleteRow(AIndex);
  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Delete(AIndex);
end;

procedure TWatchF2.DeleteFaultValueFromTrend1Click(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.Row[i].Selected then
    begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault := false;
        j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex;
        iPlot1.DeleteChannel(j);
        UpdateChannelIndex(j);
      end;
    end;
  end;
end;

procedure TWatchF2.DeleteFromTrend1Click(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.Row[i].Selected then
    begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
      begin
        if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm then
        begin
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm := false;
          j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex;
          iPlot1.DeleteChannel(j);
        end;

        if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault then
        begin
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault := false;
          j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex;
          iPlot1.DeleteChannel(j);
        end;

        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend := false;
        j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
        iPlot1.DeleteChannel(j);
        UpdateChannelIndex(j);
        j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendYAxisIndex;
        iPlot1.DeleteYAxis(j);
        UpdateYAxisIndex(j);
      end;

      FWG.NextGrid1.Cell[1, i].AsInteger := -1;
    end;
  end;
end;

procedure TWatchF2.DeleteFromXYGraph1Click(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    //if FWG.NextGrid1.Row[i].Selected then
    //begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayXY then
      begin
        for j := 0 to iXYPlot1.ChannelCount - 1 do
          iXYPlot1.Channel[j].Clear;

        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayXY := False;
        FWG.NextGrid1.Cell[5, i].AsInteger := -1;
        FXYDataIndex[0] := -1;
        FXYDataIndex[1] := -1;
      end;
    //end;
  end;
end;

//Items(Grid)에서 Item 삭제 시 pjhTagName 설정값도 삭제하기 위함
//AIndex: 삭제할 Grid Row Index
procedure TWatchF2.DeleteItem1Click(Sender: TObject);
begin
  FWG.DeleteGridItem;
end;

procedure TWatchF2.DeleteItem2pjhTagInfo(AIndex: integer);
var
  i, j, k: integer;
  LPage: TAdvOfficePage;
  LPanel: TpjhPanel;
  IpjhDI: IpjhDesignCompInterface;
begin
    j := 5;

    while j < PageControl1.AdvPageCount do
    begin
      LPage := PageControl1.AdvPages[j];

      for k := 0 to LPage.ComponentCount - 1 do
      begin
        //find panel component(only one exist on Page)
        if LPage.Components[k].ClassType = TpjhPanel then
        begin
          LPanel := LPage.Components[k] as TpjhPanel;

          for i := 0 to LPanel.ComponentCount - 1 do
          begin
            if Supports(LPanel.Components[i], IpjhDesignCompInterface, IpjhDI) then
            begin
              if IpjhDI.pjhTagInfo.TagName = FWG.NextGrid1.CellsByName['ItemName', AIndex] then
              begin
                IpjhDI.pjhTagInfo.TagName := '';
                IpjhDI.pjhTagInfo.ParamIndex := 0;
                IpjhDI.pjhValue := '';
                Break;
              end;
            end;
          end;//for

          break;
        end;//if
      end;//for

      inc(j);
    end;//while
end;

procedure TWatchF2.DestroyComponentOnPage(LPage: TAdvOfficePage);
var
  j,k: integer;
  LPanel: TpjhPanel;
begin
  for j := 0 to LPage.ComponentCount - 1 do
  begin
    if LPage.Components[j] is TpjhPanel then
    begin
      LPanel := LPage.Components[j] as TpjhPanel;
      for k := LPanel.ComponentCount - 1 downto 0 do
        LPanel.Components[k].Free;
    end;
  end;
end;

procedure TWatchF2.DestroyDynamicPanel;
var
  i: integer;
  LPage: TAdvOfficePage;
  LPanel: TpjhPanel;
begin
  for i := DYNAMIC_PAGE_INDEX to PageControl1.AdvPageCount - 1 do
  begin
    LPage := PageControl1.AdvPages[i];
    DestroyComponentOnPage(LPage);
//    LPanel := TpjhPanel(GetDesignControl(LPage));
//    if not Assigned(LPanel) then
//      ShowMessage('aaa');
//    Application.RemoveComponent(TComponent(LPanel));
  end;
end;

procedure TWatchF2.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass.DisConnectStomp;
    FpjhSTOMPClass.Free;
  end;
end;

procedure TWatchF2.DisplayMessage(Msg: string; AIsSaveLog: Boolean; AMsgLevel: TSynLogInfo);
var
  ILog: ISynLog;
  i: integer;
begin
  if (Msg = '') and (FMsgList.Count > 0) then
    Msg := FMsgList.Strings[0];

  //MsgLed.Caption := Msg;
  i := FMsgList.IndexOf(Msg);
  //메세지 출력 후 리스트에서 삭제함(매번 Timer함수에 의해 다시 들어오기 때문임)
  if i > -1 then
    FMsgList.Delete(i);

  if AIsSaveLog then
  begin
    ILog := TSQLLog.Enter;
    ILog.Log(AMsgLevel,Msg);
  end;
end;

procedure TWatchF2.DisplayMessage2SB(Msg: string);
begin
  JvStatusBar1.SimplePanel := True;
  JvStatusBar1.SimpleText := Msg;
end;

procedure TWatchF2.DisplayPanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  OnWindowCaptionDrag;
end;

//AXValueisDataTime: X 축 값이 시간일 경우 true
//                             횟수일 경우 false
procedure TWatchF2.DisplayTrend(AXValueisDateTime: Boolean; ATime: TDateTime);
var
  i,j: integer;
  tmpdouble, tmpdouble2: double;
begin
  if not FStartTrend then
    exit;

  tmpdouble2 := 0.0;

  if AXValueisDateTime then
    tmpdouble2 := ATime;

  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
    begin
      if not AXValueisDateTime then
      begin
        tmpdouble2 := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].PlotXValue;
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].PlotXValue :=
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].PlotXValue + 1.0;
      end;
      j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
      tmpdouble := StrToFloatDef(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value,0.0);
      //if AXValueisDateTime then
      //  iPlot1.Channel[j].AddYNow(tmpdouble)
      //else
        iPlot1.Channel[j].AddXY(tmpdouble2, tmpdouble);

      //iPlot1.Channel[j].AddYElapsedTime(LValue);
      if FConfigOption.ZoomToFitTrend then
        iPlot1.Channel[j].YAxis.ZoomToFit;
      //AddData2TrendMap(i, tmpdouble2, tmpdouble);

      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm then
      begin
        j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex;
        if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinAlarmEnable then
          tmpdouble := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinAlarmValue
        else
          tmpdouble := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MaxAlarmValue;

        iPlot1.Channel[j].AddXY(tmpdouble2, tmpdouble);
      end;

      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault then
      begin
        j := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex;
        if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinFaultEnable then
          tmpdouble := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinFaultValue
        else
          tmpdouble := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MaxFaultValue;

        iPlot1.Channel[j].AddXY(tmpdouble2, tmpdouble);
      end;
    end;

  end;

end;

procedure TWatchF2.DisplayTrendFromMap(APlot: TiPlot; AMap: DMap);
var
  it, it2: Diterator;
  LArray: DArray;
  LDoublePoint: TDoublePoint;
  i: integer;
  LStr: string;
begin
  it := AMap.start;
  SetToKey(it);
  //APlot.ClearAllData;
  APlot.AddXAxis;
  LStr := getString(it);
  SetToValue(it);

  while not atEnd(it) do
  begin
    LArray := GetObject(it) as DArray;
    it2 := LArray.start;
    i := APlot.AddYAxis;
    Aplot.YAxis[i].Title := LStr;
    i := APlot.AddChannel;
    while not atEnd(it2) do
    begin
      LDoublePoint := GetObject(it2) as TDoublePoint;
      APlot.Channel[i].AddXY(LDoublePoint.X, LDoublePoint.Y);
      //ShowMessage(FloatToStr(GetInteger(it2)));
      advance(it2);
    end;
    advance(it);
  end;
end;

//AMap안에 DArray로 데이터 저장됨
procedure TWatchF2.DisplayXYGraphRealTime(APlotChannel: TiXYPlotChannel);
var
  i,j: integer;
  tmpdouble, tmpdouble2: double;
begin
  if (FXYDataIndex[0] = -1) or (FXYDataIndex[1] = -1) then
    exit;

  i := FXYDataIndex[0];
  j := FXYDataIndex[1];

  tmpdouble := StrToFloatDef(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value,0.0);
  tmpdouble2 := StrToFloatDef(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].Value,0.0);

  APlotChannel.AddXY(tmpdouble, tmpdouble2);
end;

procedure TWatchF2.DisplayXYGraphWithDup(APlotChannel: TiXYPlotChannel;
  AMap: DMultiMap);
var
  Li: integer;
  it, LArrIt: DIterator;
  LMultiMap: DMultiMap;
  //LArray: DArray;
  LDoublePoint: TDoublePoint;
  LStr: string;
begin
  APlotChannel.Clear;
  it := AMap.startKey;
  SetToKey(it);
  LStr := getString(it);
  APlotChannel.XAxis.TitleShow := True;
  APlotChannel.XAxis.Title := strToken(LStr,';');
  APlotChannel.YAxis.TitleShow := True;
  APlotChannel.YAxis.Title := strToken(LStr,';');

  SetToValue(it);

  while not atEnd(it) do
  begin
    LMultiMap := GetObject(it) as DMultiMap;
    LArrIt := LMultiMap.start;
    while not atEnd(LArrIt) do
    begin
      LDoublePoint := GetObject(LArrIt) as TDoublePoint;
      APlotChannel.AddXY(LDoublePoint.X, LDoublePoint.Y);
      Advance(LArrIt);
    end;
    Advance(it);
  end;//while
end;

//AMap안에 DMultiMap으로 데이터 저장됨
procedure TWatchF2.DisplayXYGraphWithOutDup(APlotChannel: TiXYPlotChannel;
  AMap: DMultiMap);
var
  Li: integer;
  it: DIterator;
  LDoublePoint: TDoublePoint;
begin
  APlotChannel.Clear;
  it := AMap.startKey;
  SetToValue(it);

  while not atEnd(it) do
  begin
    LDoublePoint := GetObject(it) as TDoublePoint;
    APlotChannel.AddXY(LDoublePoint.X, LDoublePoint.Y);
    Advance(it);
  end;//while
end;

//Design Form위의 컴포넌트에 데이터 보여줌
procedure TWatchF2.WatchAnalogValue2DesignScreen;
var
  i, j, PnlIndex: integer;
//  LPanel: TpjhPanel;
  IpjhDI: IpjhDesignCompInterface;
  IpjhDI2: IpjhDesignCompInterface2; //Plot용 Interface(Channel 값 할당)
  LValue: string;
  tmpdouble: double;
  LEP: TEngineParameterCollect;
begin
  if FEnterWatchAnalogValue2DesignScreen then
    exit
  else
    FEnterWatchAnalogValue2DesignScreen := True;

  try
    with PageControl1.AdvPages[PageControl1.ActivePageIndex] do
    begin
      PnlIndex := -1;

      for i := 0 to ComponentCount - 1 do
      begin
        //find panel component(only one exist on Page)
        if Components[i].ClassType = TpjhPanel then
        begin
          PnlIndex := i;
          break;
        end;
      end;//for

      if PnlIndex = -1 then
        exit;

      with Components[PnlIndex] as TpjhPanel do
      begin
        LEP := IPCMonitorAll1.FEngineParameter.EngineParameterCollect;

        for i := 0 to ComponentCount - 1 do
        begin
          if Supports(Components[i], IpjhDesignCompInterface2, IpjhDI2) then
          begin
            if IpjhDI2.pjhTagInfoList.Count = IpjhDI2.pjhChannelCount then
            begin
              for j := 0 to IpjhDI2.pjhChannelCount - 1 do
              begin
                PnlIndex := TpjhTagInfo(IpjhDI2.pjhTagInfoList.Objects[j]).ParamIndex;
                IpjhDI2.SetpjhValues2Channel(PnlIndex,
                  LEP.Items[IpjhDI.pjhTagInfo.ParamIndex].Value,
                  LEP.Items[IpjhDI.pjhTagInfo.ParamIndex].Value);
              end;
            end;
          end
          else if Supports(Components[i], IpjhDesignCompInterface, IpjhDI) then
          begin
            if IpjhDI.pjhTagInfo.TagName <> '' then
            begin
              if IpjhDI.pjhTagInfo.ParamIndex < LEP.Count then
              begin
                PnlIndex := IpjhDI.pjhTagInfo.ParamIndex;
                if FConfigOption.DisplayAverageValue and
                  LEP.Items[PnlIndex].IsAverageValue then
                begin
                  tmpdouble := TCircularArray(LEP.Items[PnlIndex].FPCircularArray).Average;
                  if LEP.Items[PnlIndex].RadixPosition = 0 then
                    LValue := Format('%d', [Round(tmpdouble)])
                  else
                    LValue := FormatFloat(LEP.Items[PnlIndex].DisplayFormat, tmpdouble);
                  IpjhDI.pjhValue := LValue;
                end
                else
                  IpjhDI.pjhValue := LEP.Items[PnlIndex].Value;
              end;
            end;
          end;
        end;//for
      end;//with
    end;//with
  finally
    FEnterWatchAnalogValue2DesignScreen := False;
  end;
end;

procedure TWatchF2.WatchDigitalValue2DesignScreen(Name, AValue: string;
  AEPIndex: integer);
begin
  WatchAnalogValue2DesignScreen;
end;

procedure TWatchF2.WatchValue2Screen_2;
begin
  WatchAnalogValue2DesignScreen;
end;

procedure TWatchF2.WatchValue2Screen_Analog(Name: string; AValue: string;
  AEPIndex: integer);
var
  tmpdouble: double;
  //tmpValue: string;
  i: integer;
begin
  if FEnterWatchValue2Screen then
    exit
  else
    FEnterWatchValue2Screen := True;

  try
    tmpdouble := StrToFloatDef(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value, 0.0);

    if FCurrentEPIndex4Watch = AEPIndex then
      FWatchCA.Put(tmpdouble);

    DisplayTrend(true,now);
    DisplayXYGraphRealTime( iXYPlot1.Channel[0] );

    case PageControl1.ActivePageIndex of
      0: begin //Items
        //for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
        //begin
          FWG.NextGrid1.CellsByName['Value', AEPIndex] := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
        //end;
      end;
      1: begin //simple
        if FCurrentEPIndex4Watch > -1 then
        begin
          WatchLabel.Caption := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[FCurrentEPIndex4Watch].Value;
          AvgLabel.Caption := format('%.2f',[FWatchCA.Average]);
        end;

        if FConfigOption.SelectAlarmValue = 2 then //FConfigOption(this) 사용일 경우
          SetAlarm4ThisOption(tmpDouble)
        else
        if FConfigOption.SelectAlarmValue = 1 then //original 사용일 경우
          SetAlarm4OriginalOption(tmpDouble, FCurrentEPIndex4Watch);
      end;
      2: begin //Min/Max
        if FCurrentEPIndex4Watch > -1 then
        begin
          MinLabel.Caption := format('%.2f',[FWatchCA.Min]);//FloatToStr(FWatchValueMin);
          MaxLabel.Caption := format('%.2f',[FWatchCA.Max]);//FloatToStr(FWatchValueMax);
          CurLabel.Caption := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[FCurrentEPIndex4Watch].Value;
        end;
      end;
      3: begin //Trend
      end;
      4: begin //XY Graph
      end;
//      else
//        WatchAnalogValue2DesignScreen(Name,AValue,AEPIndex);
    end;//case
  finally
    FEnterWatchValue2Screen := False;
  end;
end;

procedure TWatchF2.WatchValue2Screen_Digital(Name, AValue: string;
  AEPIndex: integer);
var
  LDouble: double;
  i: integer;
  LValue: string;
begin
  if FEnterWatchValue2Screen then
    exit
  else
    FEnterWatchValue2Screen := True;

  try
    LValue := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;

    if LValue = '' then
      exit;

    LDouble := StrToFloatDef(LValue, 0.0);

    case PageControl1.ActivePageIndex of
      0: begin //Items
        if LValue = '0' then
          FWG.NextGrid1.CellsByName['Value', AEPIndex] := 'False'
        else
          FWG.NextGrid1.CellsByName['Value', AEPIndex] := 'True';
      end;
      1: begin //simple
        if FCurrentEPIndex4Watch > -1 then
        begin
          if LValue = '0' then
            WatchLabel.Caption := 'False'
          else
            WatchLabel.Caption := 'True';
        end;

        if FConfigOption.SelectAlarmValue = 2 then //FConfigOption(this) 사용일 경우
          SetAlarm4ThisOption((LDouble))
        else
        if FConfigOption.SelectAlarmValue = 1 then //original 사용일 경우
          SetAlarm4OriginalOption(Double(LDouble), FCurrentEPIndex4Watch);
      end;
      2: begin //Min/Max
      end;
      3: begin //Trend
      end;
      4: begin //XY Graph
      end;
//      else
//        WatchDigitalValue2DesignScreen(Name,AValue,AEPIndex);
    end;//case
  finally
    FEnterWatchValue2Screen := False;
  end;
end;

procedure TWatchF2.WatchValue2Screen_Once;
var
  i: integer;
  tmpdouble: double;
  LValue: string;
begin
  if FEnterWatchValue2Screen then
    exit
  else
    FEnterWatchValue2Screen := True;

  FWG.NextGrid1.BeginUpdate;
  try
    with IPCMonitorAll1.FEngineParameter.EngineParameterCollect do
    begin
      for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
//        if Items[i].Alarm then //Analog data
//        begin
        if Items[i].Value = '' then
            Continue;

        tmpdouble := StrToFloatDef(Items[i].Value, 0.0);

        if FCurrentEPIndex4Watch = i then
          FWatchCA.Put(tmpdouble);

        DisplayTrend(true,now);
        DisplayXYGraphRealTime( iXYPlot1.Channel[0] );

        case PageControl1.ActivePageIndex of
          0: begin //Items
            if Items[i].Alarm then //Analog data
              FWG.NextGrid1.CellsByName['Value', i] := Items[i].Value
            else
            begin //Digital data
              if LValue = '0' then
                FWG.NextGrid1.CellsByName['Value', i] := 'False'
              else
                FWG.NextGrid1.CellsByName['Value', i] := 'True';
            end;
          end;
          1: begin //simple
            if Items[i].Alarm then //Analog data
            begin
              if FCurrentEPIndex4Watch > -1 then
              begin
                WatchLabel.Caption := Items[FCurrentEPIndex4Watch].Value;
                AvgLabel.Caption := format('%.2f',[FWatchCA.Average]);
              end;
            end
            else
            begin  //Digital data
              if FCurrentEPIndex4Watch > -1 then
              begin
                if LValue = '0' then
                  WatchLabel.Caption := 'False'
                else
                  WatchLabel.Caption := 'True';
              end;
            end;

            if FConfigOption.SelectAlarmValue = 2 then //FConfigOption(this) 사용일 경우
              SetAlarm4ThisOption(tmpDouble)
            else
            if FConfigOption.SelectAlarmValue = 1 then //original 사용일 경우
              SetAlarm4OriginalOption(tmpDouble, FCurrentEPIndex4Watch);
          end;
          2: begin //Min/Max
            if FCurrentEPIndex4Watch > -1 then
            begin
              MinLabel.Caption := format('%.2f',[FWatchCA.Min]);//FloatToStr(FWatchValueMin);
              MaxLabel.Caption := format('%.2f',[FWatchCA.Max]);//FloatToStr(FWatchValueMax);
              CurLabel.Caption := Items[FCurrentEPIndex4Watch].Value;
            end;
          end;
          3: begin //Trend
          end;
          4: begin //XY Graph
          end;
        end;//case
//        end//if Analog data
      end;//for
    end;//with

    if PageControl1.ActivePageIndex > 4 then
      WatchAnalogValue2DesignScreen;
  finally
    FWG.NextGrid1.EndUpdate;
    FEnterWatchValue2Screen := False;
  end;
end;

procedure TWatchF2.WMClose(var Msg: TMessage);
begin
  Close;
end;

procedure TWatchF2.WMCopyData(var Msg: TMessage);
var
  LDragCopyMode: TParamDragCopyMode;
begin
  case Msg.WParam of
    0: begin
      FProgramMode := pmWatchList;
//      FPM.SendEPCopyData(PCopyDataStruct(Msg.LParam)^.dwData, FWG.Handle, PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^);

      LDragCopyMode := PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^.FParamDragCopyMode;

  {$IFDEF USECODESITE}
  CodeSite.EnterMethod('TWatchF2.WMCopyData ===>');
  try
    CodeSite.Send('Msg.WParam', Ord(LDragCopyMode));
    CodeSite.Send('FWG.Handle', FWG.Handle);
    CodeSite.Send('FRadixPosition', PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^.FRadixPosition);
  finally
    CodeSite.ExitMethod('TWatchF2.WMCopyData <===');
  end;
  {$ENDIF}

      if LDragCopyMode <> dcmCopyCancel then //HiMECS에서 모드가 전송 되어 오는 경우
        CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^, LDragCopyMode)
      else//마우스로 모드 선택하는 경우
        CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^, FWG.FDragCopyMode);
      //PageControl1.Pages[PageControl1.PageCount - 1].TabVisible := False;
    end;
    1: begin
      ChangeAlarmListMode;
    end;
    2: begin

    end;

  end;
end;

procedure TWatchF2.WMDesignManagerClose(var Msg: TMessage);
begin
  //CloseDesignPanel1Click(nil);

end;

procedure TWatchF2.WorkerResult(var msg: TMessage);
begin
  ProcessResults;
end;

procedure TWatchF2.XYDataAdd2Map(AMap: DMultiMap; AKey, AValue: double;
  AIsXAxis: Boolean);
var
  LDoublePoint : TDoublePoint;
begin
  LDoublePoint := TDoublePoint.Create;
  if AIsXAxis then  //Key Is X Axis
  begin
    LDoublePoint.X := AKey;
    LDoublePoint.Y := AValue;
  end
  else
  begin
    LDoublePoint.Y := AKey;
    LDoublePoint.X := AValue;
  end;
  AMap.putPair([AKey, LDoublePoint]);
end;

procedure TWatchF2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_control: begin
      if (ssCtrl in Shift) then
      begin
        FControlPressed := True;
      end;
    end;
    vk_up: begin
      JvTrackBar1.Position := JvTrackBar1.Position + 1;
    end;
    vk_down: begin
      JvTrackBar1.Position := JvTrackBar1.Position - 1;
    end;
  end;
end;

procedure TWatchF2.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FWG.FKeyBdShiftState := Shift;

  case Key of
    vk_control: FControlPressed := False;
  end;
end;

procedure TWatchF2.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TWatchF2.CalcAverageFromTrend(Sender: TObject);
var
  LChIndex, Li, Lj: integer;
  LXValue, LYValue: double;
begin
  GetXYPeriod(Li,Lj);

  LChIndex := iXYPlot1.HelpContext; //X축 Parameter index
  LXValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtAverage);

  LChIndex := iXYPlot1.Tag; //Y축 Parameter index
  LYValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtAverage);

  LChIndex := iXYPlot1.DataViewZHorz; //XY Graph Channel Index
  iXYPlot1.Channel[LChIndex].AddXY(LXValue, LYValue);
end;

procedure TWatchF2.CalcDiffFromTrend(Sender: TObject);
begin
  ;
end;

procedure TWatchF2.CalcMaxFromTrend(Sender: TObject);
var
  LChIndex, Li, Lj: integer;
  LXValue, LYValue: double;
begin
  GetXYPeriod(Li,Lj);

  LChIndex := iXYPlot1.HelpContext; //X축 Parameter index
  LXValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtMax);

  LChIndex := iXYPlot1.Tag; //Y축 Parameter index
  LYValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtMax);

  LChIndex := iXYPlot1.DataViewZHorz; //XY Graph Channel Index
  iXYPlot1.Channel[LChIndex].AddXY(LXValue, LYValue);
end;

procedure TWatchF2.CalcMinFromTrend(Sender: TObject);
var
  LChIndex, Li, Lj: integer;
  LXValue, LYValue: double;
begin
  GetXYPeriod(Li,Lj);

  LChIndex := iXYPlot1.HelpContext; //X축 Parameter index
  LXValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtMin);

  LChIndex := iXYPlot1.Tag; //Y축 Parameter index
  LYValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtMin);

  LChIndex := iXYPlot1.DataViewZHorz; //XY Graph Channel Index
  iXYPlot1.Channel[LChIndex].AddXY(LXValue, LYValue);
end;

procedure TWatchF2.CalcPointFromTrend(Sender: TObject);
var
  LChIndex, Li, Lj: integer;
  LXValue, LYValue: double;
begin
  Li := iPlot1.Channel[0].CalcIndex(iPlot1.DataCursor[0].ValueX);
  Lj := Li;

  LChIndex := iXYPlot1.HelpContext; //X축 Parameter index
  LXValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtPoint);

  LChIndex := iXYPlot1.Tag; //Y축 Parameter index
  LYValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtPoint);

  LChIndex := iXYPlot1.DataViewZHorz; //XY Graph Channel Index
  iXYPlot1.Channel[LChIndex].AddXY(LXValue, LYValue);
end;

procedure TWatchF2.CalcPointSpanFromTrend(Sender: TObject);
var
  LChIndex, Li, Lj, i: integer;
  LXValue, LYValue: double;
begin
  GetXYPeriod(Li,Lj);

  for i := Li to Lj do
  begin
    LChIndex := iXYPlot1.HelpContext; //X축 Parameter index
    LXValue := GetPeriodDataFromTrend(LChIndex,i,i,pdtPoint);

    LChIndex := iXYPlot1.Tag; //Y축 Parameter index
    LYValue := GetPeriodDataFromTrend(LChIndex,i,i,pdtPoint);

    LChIndex := iXYPlot1.DataViewZHorz; //XY Graph Channel Index
    iXYPlot1.Channel[LChIndex].AddXY(LXValue, LYValue);
  end;
end;

procedure TWatchF2.CalcSumFromTrend(Sender: TObject);
var
  LChIndex, Li, Lj: integer;
  LXValue, LYValue: double;
begin
  GetXYPeriod(Li,Lj);

  LChIndex := iXYPlot1.HelpContext; //X축 Parameter index
  LXValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtSum);

  LChIndex := iXYPlot1.Tag; //Y축 Parameter index
  LYValue := GetPeriodDataFromTrend(LChIndex,Li,Lj,pdtSum);

  LChIndex := iXYPlot1.DataViewZHorz; //XY Graph Channel Index
  iXYPlot1.Channel[LChIndex].AddXY(LXValue, LYValue);
end;

procedure TWatchF2.CaptionShowHide1Click(Sender: TObject);
begin
  ToggleBorderStyle;
end;

procedure TWatchF2.ChangeAlarmListMode;
var
  i: integer;
begin
{  FProgramMode := pmAlarmList;
  PageControl1.Pages[0].Caption := 'Alarm Items';
  PageControl1.Pages[PageControl1.PageCount - 1].TabVisible := True;

  for i := 1 to PageControl1.PageCount - 2 do
    PageControl1.Pages[i].TabVisible := False;

  FWG.NextGrid1.PopupMenu := AlarmListPopup;
  TabSheet5.PopupMenu := nil;
  SaveListCB.Checked := True;

  InitAlarmList;
  LoadConfigCollectFromFile(FFilePath+DefaultAlarmListConfigFileName, DefaultEncryption);
  }
end;

procedure TWatchF2.ChangeDispPanelColor(AColor: TColor);
var
  LColor: TColor;
begin
  DisplayPanel.Color := AColor;
  WatchLabel.Color := DisplayPanel.Color;
  AvgLabel.Color := DisplayPanel.Color;
  Label1.Color := DisplayPanel.Color;
  Label3.Color := DisplayPanel.Color;
  Label2.Color := DisplayPanel.Color;

  LColor := CalcComplementalColor(DisplayPanel.Color);

  WatchLabel.Font.Color := LColor;
  AvgLabel.Font.Color := LColor;
  Label1.Font.Color := LColor;
  Label3.Font.Color := LColor;
  Label2.Font.Color := LColor;
end;

procedure TWatchF2.ChangeTabCaption1Click(Sender: TObject);
var
  LCaptionInputF: TCaptionInputF;
begin
  if PageControl1.ActivePage.TabIndex < 4 then
  begin
    ShowMessage('Current tab should be greater than 4!');
    exit;
  end;

  LCaptionInputF := TCaptionInputF.Create(Application);
  with LCaptionInputF do
  begin
    try
      CaptionNameEdit.Text := PageControl1.ActivePage.Caption;

      if ShowModal = mrOK then
      begin
        if CaptionNameEdit.Text = '' then
        begin
          ShowMessage('Caption should not be blank!');
          exit;
        end;

        PageControl1.ActivePage.Caption := CaptionNameEdit.Text;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TWatchF2.CheckedAvgAllSelected1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
    if FWG.NextGrid1.Row[i].Selected then
      FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean := True;
end;

procedure TWatchF2.EnableAlphaCBClick(Sender: TObject);
begin
  AlphaBlend := EnableAlphaCB.Checked;
end;

procedure TWatchF2.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TWatchF2.CloseDesignPanel1Click(Sender: TObject);
var
  IbMI : IbplMainInterface;
begin
  if Assigned(FDesignManagerForm) then
  begin
    if Supports(FDesignManagerForm, IbplMainInterface, IbMI) then
    begin
      IbMI.DestroyOIInterface;
      //IbMI.Designer.Active := False;
    end;

    FDesignManagerForm.Close;
    //FDesignManagerForm := nil;
    FreeAndNil(FDesignManagerForm);
  end;

  if Assigned(FDesignManagerFormClass) then
    FDesignManagerFormClass := nil;
end;

function TWatchF2.CommandLineParse(var AErrMsg: string): boolean;
var
  LStr: string;
begin
  AErrMsg := '';
  FCommandLine := TWatchCommandLineOption.Create;
//  try
    try
//      CommandLineParser.Options := [opIgnoreUnknownSwitches];
      Result := CommandLineParser.Parse(FCommandLine);
    except
      on E: ECLPConfigurationError do begin
        AErrMsg := '*** Configuration error ***' + #13#10 +
          Format('%s, position = %d, name = %s',
            [E.ErrorInfo.Text, E.ErrorInfo.Position, E.ErrorInfo.SwitchName]);
        Exit;
      end;
    end;

    if not Result then
    begin
      AErrMsg := Format('%s, position = %d, name = %s',
        [CommandLineParser.ErrorInfo.Text, CommandLineParser.ErrorInfo.Position,
         CommandLineParser.ErrorInfo.SwitchName]) + #13#10;
      for LStr in CommandLineParser.Usage do
        AErrMsg := AErrMSg + LStr + #13#10;
    end
    else
    begin
    end;
//  finally cl.Free; end;
end;

procedure TWatchF2.Config1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TWatchF2.CreateIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord; ADragCopyMode: TParamDragCopyMode);
var
  i, j, LResult: integer;
begin
  //From IPC가 아니면 IPC를 생성하지 않음, From MQ는 직접 OnSignal 함수를 호출 함
  if FConfigOption.MonDataSource <> 0 then
    exit;

  LResult := FWG.CreateIPCMonitor(AEP_DragDrop, ADragCopyMode);

  //신규 Item 이면
  if not (ADragCopyMode = dcmCopyOnlyExist) and (LResult = -1) then
  begin
   //Administrator이상의 권한자 만이 Config form에서 level 조정 가능함
    if IPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator then
    begin
      AllowUserlevelCB.Enabled := True;
    end;

    if AllowUserlevelCB.Text = '' then
      AllowUserlevelCB.Text := UserLevel2String(IPCMonitorAll1.FCurrentUserLevel);
  end;

  if FCommandLine.IsDisplayTrend or AEP_DragDrop.FIsDisplayTrend then
  begin
    i := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1;
    AddChannelAndYAxis(i, tdtValue);
    PageControl1.ActivePage := TrendTabSheet;
  end
  else
  if FCommandLine.IsDisplaySimple or AEP_DragDrop.FIsDisplaySimple then
  begin
    i := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1;
    AddToSimple(i);
    PageControl1.ActivePage := SimpleTabSheet;
  end
end;

procedure TWatchF2.Average1Click(Sender: TObject);
begin
  FIsAverageValueGraph := True;
  FAverageValueChannel := iPlot1.AddChannel;
  iPlot1.Channel[FAverageValueChannel].VisibleInLegend := False;
  FAverageValueX := 0;
  Average1.Enabled := False;
end;

procedure TWatchF2.MinValue1Click(Sender: TObject);
begin
  FIsMinValueGraph := True;
  FMinValueChannel := iPlot1.AddChannel;
  iPlot1.Channel[FMinValueChannel].VisibleInLegend := False;
  FMinValueX := 0;
  MinValue1.Enabled := False;
end;

procedure TWatchF2.MyMouseEvent(var Msg: TMsg; var Handled: Boolean);
begin
  DefWindowProc(Handle, Msg.message, Msg.wParam, Msg.lParam);
  case Msg.message of
    WM_LButtonDown: begin
      //ShowMessage('LButton Down');
      Caption := IntToStr(Random(Msg.message));
    end;
  end;

end;

procedure TWatchF2.UnCheckedAvgAllSelected1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
    if FWG.NextGrid1.Row[i].Selected then
      FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean := not FWG.NextGrid1.Row[i].Selected;
end;

procedure TWatchF2.UnloadAddInPackage(var AOwner: TComponent; AModule: THandle);
var
  i: integer;
  M: TMemoryBasicInformation;
begin
  for i := AOwner.ComponentCount - 1 downto 0 do
  begin
    VirtualQuery(Classes.GetClass(AOwner.Components[i].ClassName), M, SizeOf(M));

    if (AModule = 0) or (HMODULE(M.AllocationBase) = AModule) then
    begin
      //FreeAndNil(AOWner.Components[i]);
      AOWner.Components[i].Free;
    end;
  end;

  UnRegisterModuleClasses(AModule);
  UnLoadPackage(AModule);
end;

procedure TWatchF2.UpButtonClick(Sender: TObject);
begin
  FWG.NextGrid1.MoveRow(FWG.NextGrid1.SelectedRow, FWG.NextGrid1.SelectedRow - 1);
  FWG.NextGrid1.SelectedRow := FWG.NextGrid1.SelectedRow - 1;
end;

procedure TWatchF2.DownButtonClick(Sender: TObject);
begin
  FWG.NextGrid1.MoveRow(FWG.NextGrid1.SelectedRow, FWG.NextGrid1.SelectedRow + 1);
  FWG.NextGrid1.SelectedRow := FWG.NextGrid1.SelectedRow + 1;
end;

procedure TWatchF2.OnAsynchronousIPCTask(const ATask: ITask);
var
  Result: IIPCData;
  Request: IIPCData;
  IPCClient: TIPCClient;
  TimeStamp: TDateTime;
begin
  IPCClient := TIPCClient.Create;
  try
    //IPCClient.ComputerName := ATask.Values.Get('ComputerName').AsString;
    IPCClient.ServerName := ATask.Values.Get('ServerName').AsString;

    Request := AcquireIPCData;
    Request.ID := IntToStr(Handle);// DateTimeToStr(Now);
    Request.Data.WriteUTF8String('Command', Caption);
    Result := IPCClient.ExecuteRequest(Request);

    {if IPCClient.AnswerValid then
    begin
      ATask.Message.Ensure('ID').AsString := Result.ID;
      TimeStamp := Result.Data.ReadDateTime('TDateTime');
      ATask.Message.Ensure('TDateTime').AsString := DateTimeToStr(TimeStamp);
      ATask.Message.Ensure('Integer').AsInteger := Result.Data.ReadInteger('Integer');
      ATask.Message.Ensure('Real').AsFloat := Result.Data.ReadReal('Real');
      ATask.Message.Ensure('String').AsString := string(Result.Data.ReadUTF8String('String'));
      ATask.SendMessageAsync;
    end;
    }
  finally
    IPCClient.Free;
  end;
end;

procedure TWatchF2.OnChangeDispPanelColor(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  ChangeDispPanelColor(TColor(FCurrentChangeColor));
end;

procedure TWatchF2.OnConnect(Sender: TIPCThread_HiMECS_MDI;
  Connecting: Boolean);
begin
  PostMessage(Handle, WM_UPDATESTATUS_HiMECS_MDI, WPARAM(Connecting), 0);
end;

{//Memory Leak 때문에 Calc32 Component 상용 불가함->cyMathparser로 대체 함 => 2013.9.11
procedure TWatchF2.OnDisplayCalculatedItemValue(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
var
  it: DIterator;
  i,j,k,r: integer;
  LNameStrings, LStrList: TStringList;
  Largs : array [0..100] of extended;
  LDouble: Double;
begin
  LNameStrings := TStringList.Create;
  try
    it := FCompoundItemList.start;
    while iterateOver(it) do
    begin
      i := GetInteger(it);

      if i > (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1) then
        exit;

      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].SharedName = '' then
        exit;

      CalcExpress1.Formula :=
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].SharedName;

      LNameStrings.Clear;
      LStrList := TStringList(FWG.NextGrid1.Row[i].Data);
      for j := 0 to TStringList(FWG.NextGrid1.Row[i].Data).Count - 1 do
      begin
        LNameStrings.Add(LStrList.Names[j]);
        k := StrToInt(LStrList.ValueFromIndex[j]);
        //k가 Collect 범위 내에 존재 하면
        if k < IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count then
          Largs[j] := StrToFloatDef(
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[k].Value,0.0);
      end;

      CalcExpress1.Variables := LNameStrings;//.Assign(LNameStrings);
      try
        LDouble := CalcExpress1.calc(Largs);
      except
        LDouble := 0;
      end;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value :=
        Format('%.2f', [LDouble]);
      r := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
      if r = 0 then
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value :=
          Format('%d', [Round(LDouble)]);

      WatchValue2Screen_Analog('', '', i);
    end;//while

  finally
    FreeAndNil(LNameStrings);
  end;
end;
}
procedure TWatchF2.OnMessageComplete(const Msg: ITaskMessage);
begin
{  ListBox1.Items.Add(Format('ASynchronous Response with ID: %s', [Msg.Values.Get('ID').AsString]));
  ListBox1.Items.Add(Format('Response: TDateTime [%s]', [Msg.Values.Get('TDateTime').AsString]));
  ListBox1.Items.Add(Format('Response: Integer [%d]', [Msg.Values.Get('Integer').AsInteger]));
  ListBox1.Items.Add(Format('Response: Real [%f]', [Msg.Values.Get('Real').AsFloat]));
  ListBox1.Items.Add(Format('Response: String [%s]', [Msg.Values.Get('String').AsString]));
  ListBox1.Items.Add('-----------------------------------------------------------');
}
end;

procedure TWatchF2.OnSignal(Sender: TIPCThread_HiMECS_MDI; Data: TEventData_HiMECS_MDI);
begin
  Flags := Data.Flags;
end;

procedure TWatchF2.OnWindowCaptionDrag;
const
  sc_DragMove = $F012;
begin
  ReleaseCapture;
  Perform( wm_SysCommand, sc_DragMove, 0 );
end;

//AIsUseWatchList = True : WatchList 및 Trend Data 설정이 완료된 상태임
//                         Load Watch List From File를 먼저 실행 해야 함.
//                         따라서 읽어오는 파일 내용이 WatchList와 일치해야 함.
//        False: 파일 내용 만으로 Watch List 재구성함.(Parameter내용이 불완전함)
procedure TWatchF2.OpenTrendDataFile(AIsUseWatchList: Boolean);
var
  LFileName: string;
  i: integer;
  LIsFirst: Boolean;
begin
  JvOpenDialog1.Options := JvOpenDialog1.Options + [ofAllowMultiSelect];
  JvOpenDialog1.InitialDir := FFilePath;

  if JvOpenDialog1.Execute then
  begin
    for i := 0 to JvOpenDialog1.Files.Count - 1 do
    begin
      LIsFirst := i = 0;

      LFileName := JvOpenDialog1.Files[i];
      LoadTrendDataFromFile(LFileName, LIsFirst, AIsUseWatchList);
      PageControl1.ActivePage := TrendTabSheet;
    end;
  end;
end;

procedure TWatchF2.PageControl1Change(Sender: TObject);
var
  i: integer;
begin
  if PageControl1.ActivePageIndex >= DYNAMIC_PAGE_INDEX then
  begin
    AssignPanel2Designer(FDesignManagerForm);
  end;

  //FColsedPageIndex := -1;
end;

procedure TWatchF2.PageControl1Changing(Sender: TObject; FromPage,
  ToPage: Integer; var AllowChange: Boolean);
begin
  if FromPage >= DYNAMIC_PAGE_INDEX then
    if FColsedPageIndex <> FromPage then
      SaveDesignMode2ControlTag(FromPage);
end;

procedure TWatchF2.PageControl1ClosedPage(Sender: TObject; PageIndex: Integer);
begin
  FColsedPageIndex := -1;
end;

procedure TWatchF2.PageControl1ClosePage(Sender: TObject; PageIndex: Integer;
  var Allow: Boolean);
begin
  if PageIndex >= DYNAMIC_PAGE_INDEX then
  begin
    if MessageDlg('Are you sure to close this tab?',
                              mtConfirmation, [mbYes, mbNo], 0)= mrYes then
    begin
      FColsedPageIndex := PageIndex;
      DestroyComponentOnPage(PageControl1.AdvPages[PageIndex]);
    end
    else
      Allow := False;
  end;
end;

procedure TWatchF2.PageControl1InsertPage(Sender: TObject;
  APage: TAdvOfficePage);
var
  LDesignPanel: TELDesignPanel;
  LPanel: TpjhPanel;
begin
  APage.ShowClose := True;
  APage.PopupMenu := PopupMenu3;
  LDesignPanel := TELDesignPanel.Create(APage);
  LDesignPanel.Parent := APage;
  LDesignPanel.Align := alClient;

  LPanel := TpjhPanel.Create(APage);
  //LPanel.Color := clBlack;
  LPanel.Parent := LDesignPanel;
  LPanel.Align := alClient;
  LPanel.OnMouseDown := pjhPanelMouseDown;

  AssignPanel2Designer(FDesignManagerForm);
end;

procedure TWatchF2.PageControl1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//  FWG.NextGrid1.Invalidate;
end;

procedure TWatchF2.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  OnWindowCaptionDrag;
end;

procedure TWatchF2.pjhPanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  OnWindowCaptionDrag;
end;

function TWatchF2.PrepareXYGraph(AArray: DArray; AIsChannelClear: Boolean): Boolean;
var
  i,j,k: integer;
  LXYInfo: TXYGraphInfo;
  it: Diterator;
begin
  Result := False;

  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.Row[i].Selected then
    begin
      LXYInfo := TXYGraphInfo.Create;
      LXYInfo.FTagname := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;
      LXYInfo.FParameterIndex := i;
      AArray.add([LXYInfo]);

      if AArray.Size = 2 then
      begin
        with TAxisSelectF.Create(nil) do
        begin
          try
            XYSelectGrid.AddRow(2);

            it := AArray.start;
            LXYInfo := GetObject(it) as TXYGraphInfo;
            XYSelectGrid.Cells[0,0] := LXYInfo.FTagname;

            advance(it);
            LXYInfo := GetObject(it) as TXYGraphInfo;
            XYSelectGrid.Cells[0,1] := LXYInfo.FTagname;

            while True do
            begin
              if ShowModal = mrOK then
              begin
                if ((XYSelectGrid.Cells[1,0] = 'X') and (XYSelectGrid.Cells[1,1] = 'X')) or
                  ((XYSelectGrid.Cells[1,0] = 'Y') and (XYSelectGrid.Cells[1,1] = 'Y')) then
                begin
                  ShowMessage('X and Y axis should be selected only once!');
                  continue;
                end;

                if (XYSelectGrid.Cells[1,0] = '') or (XYSelectGrid.Cells[1,1] = '') then
                begin
                  ShowMessage('Choose X or Y Axis!');
                  XYSelectGrid.SelectCell(1,0);
                  continue;
                end;

                if AIsChannelClear then
                  DeleteFromXYGraph1Click(nil); //XY Graph 초기화(기존 데이터 제거)

                it := AArray.start;
                LXYInfo := GetObject(it) as TXYGraphInfo;
                LXYInfo.FAxis := GetAxisFromString(XYSelectGrid.Cells[1,0]);

                if XYSelectGrid.Cells[2,0] <> '' then
                begin
                  LXYInfo.FUseConstant := XYSelectGrid.Cell[2,0].AsBoolean;
                end;

                LXYInfo.FIsDuplicated := CheckBox1.Checked;
                j := LXYInfo.FParameterIndex;
                IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].IsDisplayXY := True;
                FWG.NextGrid1.Cell[5, j].AsInteger := 1;

                advance(it);
                LXYInfo := GetObject(it) as TXYGraphInfo;
                LXYInfo.FAxis := GetAxisFromString(XYSelectGrid.Cells[1,1]);

                if XYSelectGrid.Cells[2,1] <> '' then
                begin
                  LXYInfo.FUseConstant := XYSelectGrid.Cell[2,1].AsBoolean;
                end;

                j := LXYInfo.FParameterIndex;
                IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].IsDisplayXY := True;
                FWG.NextGrid1.Cell[5, j].AsInteger := 1;
                Result := True;

                if AIsChannelClear then
                begin
                  for k := 0 to iXYPlot1.ChannelCount - 1 do
                    iXYPlot1.Channel[k].Clear;//그래프 초기화
                end;

                break;
              end
              else
              begin
                exit;
              end;
            end;
          finally
            free;
          end;
        end;

        break;
      end;//LStrList.Count = 2
    end;
  end; //for
end;

procedure TWatchF2.ProcessResults;
var
  msg: TOmniMessage;
  LStompFrame: IStompFrame;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    LStompFrame := msg.MsgData.AsInterface as IStompFrame;
    IPCMonitorAll1.ProcessDataFromMQ(LStompFrame.GetBody);
//    Memo1.Lines.Add('******' + LEventData.EngineName + '****** Pulse Event OK!');
  end;
end;

procedure TWatchF2.Properties1Click(Sender: TObject);
begin
  FWG.ShowProperties;
end;

procedure TWatchF2.Refresh1Click(Sender: TObject);
var
  LPage: TAdvOfficePage;
  LPanel: TpjhPanel;
  LDFName: string;
  i,j: integer;
begin
  j := PageControl1.ActivePageIndex;

  if FDesignFormConfig.DesignFormConfigCollect.Count > (j - 5) then
  begin
    LDFName := FDesignFormConfig.DesignFormConfigCollect.Items[j-5].DesignFormFileName;

    if LDFName = '' then
      LDFName := PageControl1.ActivePage.Hint; //Page Hint에 Form File Name이  저장 되어 있음

    PageControl1.ActivePage.Caption := FDesignFormConfig.DesignFormConfigCollect.Items[j-5].DesignFormCaption;
    LPage := PageControl1.ActivePage;
    LPanel := TpjhPanel(GetDesignControl(LPage));
    RemoveControlsOnPanel(LPanel);
    LoadFromDFM(LDFName, TWinControl(LPanel));
//    LoadComponentFromFile(TComponent(LPanel), LDFName);

    NxAlertWindow1.Caption := '※.Design Form Name';
    NxAlertWindow1.Text := ExtractFilepath(LDFName) + #13#10 + ExtractFileName(LDFName);
    NxAlertWindow1.Width := Length(NxAlertWindow1.Text) * 6;
    NxAlertWindow1.Popup;
  end;
end;

procedure TWatchF2.RemoveControlsOnPanel(AControl: TPanel);
var
  i: integer;
begin
  for i := AControl.ControlCount - 1 downto 0 do
    AControl.Controls[i].Free;
end;

//x축이 key값이면 AIsXAxis = true
procedure TWatchF2.ReplaceOrAddMap(AMap: DMultiMap; AKey, AValue: double;
  AIsXAxis: Boolean);
var
  it: DIterator;
  LDoublePoint : TDoublePoint;
begin
  it := AMap.locate([AKey]);
  LDoublePoint := GetObject(it) as TDoublePoint;
  if Assigned(LDoublePoint) then
  begin
    if AIsXAxis then  //Key Is X Axis
      LDoublePoint.Y := AValue
    else
      LDoublePoint.X := AValue
  end
  else
  begin
    LDoublePoint := TDoublePoint.Create;
    if AIsXAxis then  //Key Is X Axis
    begin
      LDoublePoint.X := AKey;
      LDoublePoint.Y := AValue;
    end
    else
    begin
      LDoublePoint.Y := AKey;
      LDoublePoint.X := AValue;
    end;
    AMap.putPair([AKey, LDoublePoint]);
  end;
end;

procedure TWatchF2.ResetAvgValue1Click(Sender: TObject);
var
  i: integer;
begin
  FWG.StopAvgCalc;

  for i := 0 to FWG.NextGrid1.RowCount - 1 do
    if FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean then
      FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean := False;
end;

procedure TWatchF2.ResetWindowPosition;
begin
  Top := 0;
  Left := 0;
end;

//AArray: tagname과 axes(aX, aY) 정보 있음.
//AIsDuplicate: true = 중복데이터 허용
//              false = 기존데이터는 replace
function TWatchF2.MakeXYDataFromFile(AArray: DArray;AFileName: string; AIsFirst: Boolean; 
  AXYMap: DMultiMap; AIsDuplicate: Boolean): Boolean;
var
  LArray, LArray2, LArray3: DArray;
  LDoublePoint, LDoublePoint2: TDoublePoint;
  it, it2, it3: Diterator;
  LXYInfo: TXYGraphInfo;
  LChange: Boolean;
  LMultiMap: DMultiMap;
  LStr: string;
  LStrList: TStringList;
begin
  Result := True;
  LStrList:= TStringList.Create;
  try
    LStrList.LoadFromFile(AFileName);

    if LStrList.Count > 0 then
    begin
      LArray3 := DArray.Create;

      try
        //LArray3에 데이터 저장 후 최종적으로 MultiMap에 저장함.
        LMultiMap := DMultiMap.Create;
        it3 := AArray.start;
        LXYInfo := GetObject(it3) as TXYGraphInfo;
        LStr := LXYInfo.FTagname;

        advance(it3);
        LXYInfo := GetObject(it3) as TXYGraphInfo;
        if LXYInfo.FAxis = aY then
          LStr := LStr + ';' + LXYInfo.FTagname
        else if LXYInfo.FAxis = aX then
          LStr := LXYInfo.FTagname + ';' + LStr;
        
        FillXYMapFromFile(LMultiMap, LStrList, AIsDuplicate, LStr);
        AXYMap.putPair([LStr,LMultiMap])
      finally
        ObjFree(LArray3);
        LArray3.Free;
      end;
    end;
  finally
    FreeAndNil(LStrList);
  end;
end;

procedure TWatchF2.MaxValue1Click(Sender: TObject);
begin
  FIsMaxValueGraph := True;
  FMaxValueChannel := iPlot1.AddChannel;
  iPlot1.Channel[FMaxValueChannel].VisibleInLegend := False;
  FMaxValueX := 0;
  MaxValue1.Enabled := False;
end;

procedure TWatchF2.abShowHide1Click(Sender: TObject);
begin
  ToggleTabShow;
end;

procedure TWatchF2.AddAlarmValue1Click(Sender: TObject);
var
  i: integer;
begin
  if FWG.NextGrid1.SelectedCount = 1 then
  begin
    i := FWG.NextGrid1.SelectedRow;

    if not IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
    begin
      ShowMessage('Please execute ''Add To Trend'' Frist!');
      exit;
    end;

    if (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinAlarmEnable) or
      (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MaxAlarmEnable) then
    begin
      AddChannelAndYAxis(i, tdtAlarm);
    end
    else
    begin
      ShowMessage('Please set the Min or Max Alarm Enable in configuration!');
      exit;
    end;

  end
  else
    ShowMessage('Selected item should be only one for this function');
end;

procedure TWatchF2.AddBpllist2DFConfig(ABplist: TStringList;
  ADfc: TDesignFormConfig);
var
  i: integer;
  LStr: string;
begin
  LStr := '';

  for i := 0 to ABplist.Count - 1 do
    ABplist.Strings[i] := ExtractFileName(ABplist.Strings[i]);

  ADfc.DesignFormConfigCollect.Add.BplFileList := ABplist.CommaText;
end;

//ACheckTrendType=
//Alarm 과 Fault의 경우에는 Channel만 생성하고 Y Axis는 생성 안함
//Alarm과 Fault의 경우 이미 IsDisplayTrend 상태임
function TWatchF2.AddChannelAndYAxis(AParamIndex: integer; ACheckTrendType: TTrendDataType): integer;
var
  i,j,k: integer;
begin
  case ACheckTrendType of //기존 display시에는 중복 방지하기 위함
    tdtValue: begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrend then
        exit;
    end;
    tdtAlarm: begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrendAlarm then
        exit;
    end;
    tdtFault: begin
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrendFault then
        exit;
    end;
  end;

  k := iPlot1.AddChannel;

  case ACheckTrendType of //기존 display시에는 중복 방지하기 위함
    tdtValue: begin
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrend := True;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendChannelIndex := k;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].PlotXValue := 0;
      FWG.NextGrid1.Cell[1, AParamIndex].AsInteger := 1;

      j := iPlot1.AddYAxis;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendYAxisIndex := j;
      iPlot1.YAxis[j].Name := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TagName;
      iPlot1.YAxis[j].ScaleLinesColor := iPlot1.Channel[k].Color;
      iPlot1.YAxis[j].LabelsFont.Color := iPlot1.Channel[k].Color;
      iPlot1.YAxis[j].Min := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].YAxesMinValue;
      iPlot1.YAxis[j].Span := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].YAxesSpanValue;
      iPlot1.Channel[k].YAxisName := iPlot1.YAxis[j].Name;
      iPlot1.Channel[k].TitleText := iPlot1.YAxis[j].Name;
      iPlot1.Channel[k].Name := 'C_'+ iPlot1.YAxis[j].Name;
      iPlot1.YAxis[j].Title := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].Description;
      iPlot1.YAxis[j].Name := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TagName;
    end;
    tdtAlarm: begin
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrendAlarm := True;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendAlarmIndex := k;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].PlotXValue := 0;
      i := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendYAxisIndex;
      iPlot1.Channel[k].YAxisName := iPlot1.YAxis[i].Name;
      iPlot1.Channel[k].TitleText := iPlot1.YAxis[i].Name + '''s Alarm';
      iPlot1.Channel[k].Name := 'C_'+ iPlot1.YAxis[i].Name + '_Alarm';
    end;
    tdtFault: begin
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrendFault := True;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendFaultIndex := k;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].PlotXValue := 0;
      i := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendYAxisIndex;
      iPlot1.Channel[k].YAxisName := iPlot1.YAxis[i].Name;
      iPlot1.Channel[k].TitleText := iPlot1.YAxis[i].Name + '''s Fault';
      iPlot1.Channel[k].Name := 'C_'+ iPlot1.YAxis[i].Name + '_Fault';
    end;
  end;

  PageControl1.ActivePage := TrendTabSheet;
end;

procedure TWatchF2.AddData2TrendMap(AParameterIndex: integer; AXValue, AYValue: double);
var
  it: Diterator;
  LArray: DArray;
  LDoublePoint: TDoublePoint;
  LStr: string;
begin
  LStr := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].TagName;
  it := FTrendDataMap.locate( [LStr] );

  if not atEnd(it) then
  begin
    LArray := GetObject(it) as DArray;

    LDoublePoint := TDoublePoint.Create;
    LDoublePoint.X := AXValue;
    LDoublePoint.Y := AYValue;
    LArray.add([LDoublePoint]);
  end
  else
  begin
    LArray := DArray.Create;

    LDoublePoint := TDoublePoint.Create;
    LDoublePoint.X := AXValue;
    LDoublePoint.Y := AYValue;
    LArray.add([LDoublePoint]);

    FTrendDataMap.putPair([LStr, LArray]);
  end;

end;

procedure TWatchF2.AddData2TrendMapFromFile(AKeyName: string; AXValue,
  AYValue: double);
var
  it: Diterator;
  LArray: DArray;
  LDoublePoint: TDoublePoint;
begin
  it := FTrendDataMapFromFile.locate( [AKeyName] );

  if not atEnd(it) then
  begin
    LArray := GetObject(it) as DArray;

    LDoublePoint := TDoublePoint.Create;
    LDoublePoint.X := AXValue;
    LDoublePoint.Y := AYValue;
    LArray.add([LDoublePoint]);
  end
  else
  begin
    LArray := DArray.Create;

    LDoublePoint := TDoublePoint.Create;
    LDoublePoint.X := AXValue;
    LDoublePoint.Y := AYValue;
    LArray.add([LDoublePoint]);

    FTrendDataMapFromFile.putPair([AKeyName, LArray]);
  end;
end;

procedure TWatchF2.AddData2XYMap(AParameterIndex: integer; AXValue,
  AYValue: double);
var
  it: Diterator;
  LArray: DArray;
  LDoublePoint: TDoublePoint;
  LStr: string;
begin
  LStr := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].TagName;
  it := FXYDataMap.locate( [LStr] );

  if not atEnd(it) then
  begin
    LArray := GetObject(it) as DArray;

    LDoublePoint := TDoublePoint.Create;
    LDoublePoint.X := AXValue;
    LDoublePoint.Y := AYValue;
    LArray.add([LDoublePoint]);
  end
  else
  begin
    LArray := DArray.Create;

    LDoublePoint := TDoublePoint.Create;
    LDoublePoint.X := AXValue;
    LDoublePoint.Y := AYValue;
    LArray.add([LDoublePoint]);

    FXYDataMap.putPair([LStr, LArray]);
  end;
end;

function TWatchF2.DetermineIndexForXYGraph(AIsChClear: Boolean): Boolean;
var
  LArray: DArray;
  LXYInfo: TXYGraphInfo;
  it: Diterator;
  LStr: string;
  i,j: integer;
begin
  Result := True;

  if FWG.NextGrid1.SelectedCount <> 2 then
  begin
    ShowMessage('XY Graph needs only 2 items!' + #13#10 +
      'But you have selected ' + IntToStr(FWG.NextGrid1.SelectedCount) + ' items.');
    Result := False;
    exit;
  end;

  LArray := DArray.Create;
  try
    if PrepareXYGraph(LArray, AIsChClear) then
    begin
      for j := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].UseXYGraphConstant := False;
      end;

      it := LArray.start;
      LXYInfo := GetObject(it) as TXYGraphInfo;
      LStr := LXYInfo.FTagname;
      i := LXYInfo.FParameterIndex;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].UseXYGraphConstant := LXYInfo.FUseConstant;

      advance(it);
      LXYInfo := GetObject(it) as TXYGraphInfo;

      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[LXYInfo.FParameterIndex].UseXYGraphConstant := LXYInfo.FUseConstant;

      if LXYInfo.FAxis = aX then
      begin
        iXYPlot1.XAxis[0].Title := LXYInfo.FTagname;
        iXYPlot1.YAxis[0].Title := LStr;
        //X축 Index를 HelpContext에 저장
        iXYPlot1.HelpContext := LXYInfo.FParameterIndex;
        //Y축 Index를 Tag에  저장
        iXYPlot1.Tag := i;
      end
      else
      begin
        iXYPlot1.XAxis[0].Title := LStr;
        iXYPlot1.YAxis[0].Title := LXYInfo.FTagname;
        //X축 Index를 HelpContext에 저장
        iXYPlot1.HelpContext := i;
        //Y축 Index를 Tag에  저장
        iXYPlot1.Tag := LXYInfo.FParameterIndex;
      end;

    end;
  finally
    ObjFree(LArray);
    LArray.Free;
  end;
end;

procedure TWatchF2.AddtoCalculated1Click(Sender: TObject);
//var
//  i,j: integer;
//  Lstr, LStr2: string;
//  LStrList, LtmpList: TStringList;
//  LEP_DragDrop: TEngineParameterItemRecord;
//  LMemoryStream: TMemoryStream;
//  LCopyWatchListF: TCopyWatchListF;
begin
  FWG.AddCalculated2GridFromMenu;
//  LCopyWatchListF := TCopyWatchListF.Create(nil);
//  try
//    with LCopyWatchListF do
//    begin
//      //LMemoryStream := TMemoryStream.Create;
//      //try
//        //FWG.NextGrid1.SaveToStream(LMemoryStream);
//        //LMemoryStream.Position := 0;
//        //SelectGrid.LoadFromStream(LMemoryStream);
//      //finally
//        //FreeAndNil(LMemoryStream);
//      //end;
//
//      FWG.NextGrid1.SaveToTextFile(TEMPFILENAME);
//      SelectGrid.LoadFromTextFile(TEMPFILENAME);
//
//      Sel4XYGraphPanel.Visible := False;
//      FormulaPanel.Visible := True;
//
//      SelectGrid.Columns.Item[0].Visible := False;
//      SelectGrid.Columns.Item[1].Visible := False;
//      SelectGrid.Columns.Item[4].Visible := False;
//      SelectGrid.Columns.Item[5].Visible := False;
//      SelectGrid.Columns.Item[6].Visible := False;
//      SelectGrid.Columns.Item[7].Visible := False;
//
//      SelectGrid.Options := SelectGrid.Options - [goMultiSelect];
//
//      for i := 0 to SelectGrid.RowCount - 1 do
//        SelectGrid.Cell[3,i].AsString :=
//          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName;
//
//      if ShowModal = mrOK then
//      begin
//        FWG.AddCalculated2Grid(ExprEdt.Text, ItemNameEdit.Text, True);
//      end;
//    end;//with
//
//  finally
//    FreeAndNil(LCopyWatchListF);
//  end;
end;

procedure TWatchF2.AddtoNewTrendWindow1Click(Sender: TObject);
var
  LCommand: string;
begin
  LCommand := HiMECSWatchName2 + ' ___ ' + 'DISPLAYTREND';
  AddToNewWindow(LCommand);
end;

procedure TWatchF2.AddToNewWindow(ACommand: string);
var
  i,LHandle: integer;
  LProcessId: THandle;
begin
  if FWG.NextGrid1.SelectedCount > 0 then
  begin
    SetCurrentDir(FFilePath);
    LProcessId := ExecNewProcess2(ACommand);
    LHandle := DSiGetProcessWindow(LProcessId);
    SetLength(FWatchHandles, Length(FWatchHandles)+1);
    FWatchHandles[High(FWatchHandles)] := LHandle;

    if Pos('SIMPLE', ACommand) > 0 then
    begin
      i := FWG.NextGrid1.SelectedRow;
      IPCMonitorAll1.MoveEngineParameterItemRecord2(FWG.FEngineParameterItemRecord,i);
      FWG.FEngineParameterItemRecord.FIsDisplaySimple := True;
      FWG.FPM.SendEPCopyData(Handle, LHandle, FWG.FEngineParameterItemRecord);
    end
    else
    if Pos('DISPLAYTREND', ACommand) > 0 then
    begin
      for i := 0 to FWG.NextGrid1.RowCount - 1 do
      begin
        if FWG.NextGrid1.Row[i].Selected then
        begin
          IPCMonitorAll1.MoveEngineParameterItemRecord2(FWG.FEngineParameterItemRecord,i);
          FWG.FEngineParameterItemRecord.FIsDisplayTrend := True;
          FWG.FPM.SendEPCopyData(Handle, LHandle,FWG.FEngineParameterItemRecord);
        end;
      end;
    end;
  end;
end;

procedure TWatchF2.AddToSimple(AParamIndex: integer);
begin
  Label1.Caption := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].Description;
  Label3.Caption := Label1.Caption;

  if FCurrentEPIndex4Watch > -1 then
    FPrevEPIndex4Watch := FCurrentEPIndex4Watch;

  FCurrentEPIndex4Watch := AParamIndex;
  if FPrevEPIndex4Watch > -1 then
  begin
    FWG.NextGrid1.Cell[0, FPrevEPIndex4Watch].AsInteger := -1;
    IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[FPrevEPIndex4Watch].IsDisplaySimple := False;
  end;

  FWG.NextGrid1.Cell[0, AParamIndex].AsInteger := 1;
  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplaySimple := True;

  if FCurrentEPIndex4Watch <> FPrevEPIndex4Watch then
  begin
    //FWatchCA.Size := 0;
    //FWatchCA.Size := FConfigOption.AverageSize;
    FWatchCA.ClearBuffer;
  end;
end;

procedure TWatchF2.AddToSimple3Click(Sender: TObject);
begin
  AddToSimple(FWG.NextGrid1.SelectedRow);
end;

procedure TWatchF2.AddToSimpleInNewWindow1Click(Sender: TObject);
var
  LCommand: string;
begin
  if FWG.NextGrid1.SelectedCount > 1 then
  begin
    ShowMessage('You must select only one item for simple display!');
    exit;
  end;

  LCommand := HiMECSWatchName2 + ' ___ ' + 'SIMPLE';
  AddToNewWindow(LCommand);
end;

procedure TWatchF2.AddtoTrend2Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.Row[i].Selected then
    begin
      AddChannelAndYAxis(i, tdtValue);
    end;
  end;
end;

function TWatchF2.AddToXYGraphInRealTime: Boolean;
var
  LArray: DArray;
  LXYInfo: TXYGraphInfo;
  it: Diterator;
  LStr: string;
  i: integer;
begin
  Result := False;

  if FWG.NextGrid1.SelectedCount <> 2 then
  begin
    ShowMessage('XY Graph needs only 2 items!' + #13#10 +
      'But you have selected ' + IntToStr(FWG.NextGrid1.SelectedCount) + ' items.');
    exit;
  end;

  LArray := DArray.Create;
  try
    if PrepareXYGraph(LArray, True) then
    begin
      it := LArray.start;
      LXYInfo := GetObject(it) as TXYGraphInfo;
      //FXYDataIndex[0] := LXYInfo.FParameterIndex;
      LStr := LXYInfo.FTagname;
      i := LXYInfo.FParameterIndex;

      advance(it);
      LXYInfo := GetObject(it) as TXYGraphInfo;
      //FXYDataIndex[1] := LXYInfo.FParameterIndex;

      if LXYInfo.FAxis = aX then
      begin
        iXYPlot1.XAxis[0].Title := LXYInfo.FTagname;
        iXYPlot1.YAxis[0].Title := LStr;
        FXYDataIndex[0] := LXYInfo.FParameterIndex;
        FXYDataIndex[1] := i;
      end
      else
      begin
        iXYPlot1.XAxis[0].Title := LStr;
        iXYPlot1.YAxis[0].Title := LXYInfo.FTagname;
        FXYDataIndex[0] := i;
        FXYDataIndex[1] := LXYInfo.FParameterIndex;
      end;

      Result := True;
    end;
  finally
    ObjFree(LArray);
    LArray.Free;
  end;

end;

procedure TWatchF2.AdjustParameter1Click(Sender: TObject);
begin
  AdjustParamIndexOfComponents;
end;

procedure TWatchF2.AdjustparameterIndex1Click(Sender: TObject);
begin
  AdjustParamIndexOfComponents;
end;

procedure TWatchF2.AdjustParamIndexOfComponents;
var
  i, j, k, PnlIndex: integer;
  LStr: string;
  LPanel: TpjhPanel;
  IpjhDI: IpjhDesignCompInterface;
  IpjhDI2: IpjhDesignCompInterface2; //Plot용 Interface(Channel 값 할당)
begin
  for k := 5 to PageControl1.AdvPageCount - 1 do
  begin
    with PageControl1.AdvPages[k] do
    begin
      for i := 0 to ComponentCount - 1 do
      begin
        //find panel component(only one exist on Page)
        if Components[i].ClassType = TpjhPanel then
        begin
          PnlIndex := i;
          break;
        end;
      end;//for

      LPanel := Components[PnlIndex] as TpjhPanel;

      for i := 0 to LPanel.ComponentCount - 1 do
      begin
        if Supports(LPanel.Components[i], IpjhDesignCompInterface2, IpjhDI2) then
        begin
          if IpjhDI2.pjhTagInfoList.Count = IpjhDI2.pjhChannelCount then
          begin
            for j := 0 to IpjhDI2.pjhChannelCount - 1 do
            begin
              PnlIndex := GetparamIndexFromCollect(TpjhTagInfo(IpjhDI2.pjhTagInfoList.Objects[j]).TagName, LStr);
              if PnlIndex <> -1 then
              begin
                TpjhTagInfo(IpjhDI2.pjhTagInfoList.Objects[j]).ParamIndex := PnlIndex;
                TpjhTagInfo(IpjhDI2.pjhTagInfoList.Objects[j]).Description := LStr;
              end;
            end;
          end;
        end
        else if Supports(LPanel.Components[i], IpjhDesignCompInterface, IpjhDI) then
        begin
          if IpjhDI.pjhTagInfo.TagName <> '' then
          begin
            PnlIndex := GetparamIndexFromCollect(IpjhDI.pjhTagInfo.TagName, LStr);
            if PnlIndex <> -1 then
            begin
              IpjhDI.pjhTagInfo.ParamIndex := PnlIndex;
              IpjhDI.pjhTagInfo.Description := LStr;
            end;
          end;
        end;
      end;//for
    end;//with
  end;
end;

procedure TWatchF2.AddtoXYGraph1Click(Sender: TObject);
begin
  AddToXYGraphInRealTime;
end;

procedure TWatchF2.AddToXYGraphFromFile1Click(Sender: TObject);
var
  LArray: DArray;
  LFileName: string;
  i: integer;
  LIsFirst: Boolean;
begin
  if FWG.NextGrid1.SelectedCount <> 2 then
  begin
    ShowMessage('XY Graph needs only 2 items!' + #13#10 +
      'But you have selected ' + IntToStr(FWG.NextGrid1.SelectedCount) + ' items.');
    exit;
  end;

  LArray := DArray.Create;
  try
    if PrepareXYGraph(LArray, True) then
    begin
      FXYDataMap.clear;
      JvOpenDialog1.Options := JvOpenDialog1.Options + [ofAllowMultiSelect];
      JvOpenDialog1.InitialDir := FFilePath;

      if JvOpenDialog1.Execute then
      begin
        for i := 0 to JvOpenDialog1.Files.Count - 1 do
        begin
          LIsFirst := i = 0;

          LFileName := JvOpenDialog1.Files[i];
          if MakeXYDataFromFile(LArray, LFileName, LIsFirst, FXYDataMap, False) then
            LFileName := 'Success';
        end;

        if LFileName = 'Success' then
        begin
          DisplayXYGraphWithDup(iXYPlot1.Channel[0] ,FXYDataMap);
          PageControl1.ActivePage := XYGraphTabSheet;
        end;
      end;
    end;
  finally
    ObjFree(LArray);
    LArray.Free;
  end;
end;

procedure TWatchF2.AddtoXYGraphFromTrendData1Click(Sender: TObject);
var
  LArray: DArray;
begin
  if FWG.NextGrid1.SelectedCount <> 2 then
  begin
    ShowMessage('XY Graph needs only 2 items!' + #13#10 +
      'But you have selected ' + IntToStr(FWG.NextGrid1.SelectedCount) + ' items.');
    exit;
  end;

  LArray := DArray.Create;
  try
    if PrepareXYGraph(LArray, True) then
    begin
      FXYDataMap.clear;
      GetDataFromTrendGraph2XYMap(LArray);
      DisplayXYGraphWithDup(iXYPlot1.Channel[0] ,FXYDataMap);
      PageControl1.ActivePage := XYGraphTabSheet;
    end;
  finally
    ObjFree(LArray);
    LArray.Free;
  end;
end;

procedure TWatchF2.ApplicationEvents1Activate(Sender: TObject);
begin
//  if Assigned(IPCClient_HiMECS_MDI) then
//  begin
//    if IPCClient_HiMECS_MDI.State <> stConnected then
//    begin
//      IPCClient_HiMECS_MDI.MakeCurrent;
//      ShowMessage('IPCClient_HiMECS_MDI.MakeCurrent');
//    end;
//  end;
end;

procedure TWatchF2.ApplicationEvents1ShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  //(GetKeyState(VK_SHIFT) < 0) and
  //(GetKeyState(VK_CONTROL) < 0) then

  //Alt key가 눌려 졌으면 exit
  if HiWord(GetKeyState(VK_MENU)) = 0 then
    exit;

  //Shift key가 눌려 졌으면 exit
  if HiWord(GetKeyState(VK_SHIFT)) = 0 then
    exit;

  //Control key가 눌려 졌으면 exit
  if HiWord(GetKeyState(VK_CONTROL)) = 0 then
    exit;

  if (Msg.CharCode = VK_F2) then
  begin
    //ShowMessage('F2 pressed!') ;
    ToggleBorderStyle;
    ToggleWindowMaxmize;
    Handled := True;
  end;

  if (Msg.CharCode = VK_F3) then
    ToggleTabShow;

  if (Msg.CharCode = VK_F4) then
    ToggleBorderStyle;

  if (Msg.CharCode = VK_F5) then
    ToggleStayOnTop;

  if (Msg.CharCode = VK_F6) then
    ResetWindowPosition;
end;

procedure TWatchF2.ApplyAvgSize;
begin
  FCriticalSection.Enter;
  try
    FCurrentAryIndex := 0;
    FFirstCalcAry := True;
    FWatchCA.Size := FConfigOption.AverageSize;
  finally
    FCriticalSection.Leave;
  end;//try
end;

procedure TWatchF2.ApplyCommandLineOption;
begin
  if FCommandLine.WatchListFileName <> '' then
    FConfigOption.WatchListFileName := FCommandLine.WatchListFileName;

  if FCommandLine.UserLevel <> 0 then
    IPCMonitorAll1.FCurrentUserLevel := THiMECSUserLevel(FCommandLine.UserLevel);

  if FCommandLine.AlarmMode then
    ChangeAlarmListMode;

  if FCommandLine.DummyFormHandle <> '' then
  begin
    FDummyFormHandle := FCommandLine.DummyFormHandle;
    SendAliveOk;
  end;

  FIsMDIChileMode := FCommandLine.MDIChildMode;
end;

procedure TWatchF2.ApplyOption;
var
  i: integer;
begin
  if FConfigOption.MonDataSource = 2 then //MonDataSource = By MQ
    InitSTOMP;

  if not FFirst and (FConfigOption.AliveSendInterval > 0) then
    Timer1.Interval := FConfigOption.AliveSendInterval;

  if FCurrentModbusFileName <> FConfigOption.ModbusFileName then
  begin
    if FileExists(FConfigOption.ModbusFileName) then
    begin
//      IPCMonitorAll1.SetModbusMapFileName(FConfigOption.ModbusFileName, psECS_AVAT);
    end;
  end;

  //Simple에 보여줌
  AvgPanel.Visible := FConfigOption.ViewAvgValue;

  ApplyOption4AvgCalc;

  if FConfigOption.NameFontSize > 0 then
    Label1.Font.Size := FConfigOption.NameFontSize;

  if FConfigOption.ValueFontSize > 0 then
    WatchLabel.Font.Size := FConfigOption.ValueFontSize;

  if FConfigOption.FormCaption <> '' then
    Caption := FConfigOption.FormCaption;

  for i := 0 to iPlot1.ChannelCount - 1 do
    iPlot1.Channel[i].RingBufferSize := FConfigOption.RingBufferSize;
end;

procedure TWatchF2.ApplyOption4AvgCalc;
var
  LUseQFilalize: Boolean;
begin
  //Items에 보여줌
  if FConfigOption.DisplayAverageValue then
  begin
    LUseQFilalize := not FConfigOption.FDisplayAverageValueChanged and
          FConfigOption.FAverageSizeChanged;
    FWG.RestartAvgCalc(LUseQFilalize, FConfigOption.AverageSize)
  end;
end;

procedure TWatchF2.FormShow(Sender: TObject);
begin
  Label1.Caption := FLabelName;
  Label3.Caption := FLabelName;
  Self.Caption := Self.Caption + FLabelName;
end;

procedure TWatchF2.FullScreen1Click(Sender: TObject);
begin
  ToggleBorderStyle;
  ToggleWindowMaxmize;
end;

procedure TWatchF2.FWGNextGrid1SelectCell(Sender: TObject; ACol, ARow: Integer);
begin
  ShowEventName1.Enabled := FWG.NextGrid1.SelectedCount = 1;
  FWG.NextGrid1SelectCell(Sender, ACol, ARow);
end;

function TWatchF2.GetAxisFromString(AAxes: String): TAxis;
begin
  if AAxes = 'X' then
    Result := aX
  else if AAxes = 'Y' then
    Result := aY
  else if AAxes = 'Z' then
    Result := aZ;
end;

procedure TWatchF2.GetBplNamesFromDesignPanel(ABplNameList: TStringList;
  AAdvOfficePage: TAdvOfficePage);
var
  j, PnlIndex: integer;
  LPanel: TpjhPanel;
  IpjhDI: IpjhDesignCompInterface;
  LStr: string;
begin
  with AAdvOfficePage do
  begin
    for j := 0 to ComponentCount - 1 do
    begin
      //find panel component(only one exist on Page)
      if Components[j].ClassType = TpjhPanel then
      begin
        PnlIndex := j;
        break;
      end;
    end;//for

    LPanel := Components[PnlIndex] as TpjhPanel;

    for j := 0 to LPanel.ComponentCount - 1 do
    begin
      if Supports(LPanel.Components[j], IpjhDesignCompInterface, IpjhDI) then
      begin
        LStr := IpjhDI.pjhBplFileName;
        if ABplNameList.IndexOf(LStr) = -1 then
        begin
          ABplNameList.Add(LStr);
        end;
      end;
    end;//for
  end;
end;

procedure TWatchF2.GetDataFromTrendGraph2XYMap(AArray: DArray);
var
  i,j: integer;
  LXYInfo: TXYGraphInfo;
  it: Diterator;
  tmpdouble, tmpdouble2: double;
  LSmallerCount: integer;
  ChannelX, ChannelY: integer;
  LMultiMap: DMultiMap;
  LStr, LStr2: string;
  LIsDuplicated: Boolean;
begin
  it := AArray.start;
  LXYInfo := GetObject(it) as TXYGraphInfo;
  i := LXYInfo.FParameterIndex;
  LIsDuplicated := LXYInfo.FIsDuplicated;

  if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
  begin
    if LXYInfo.FAxis = aX then
    begin
      ChannelX := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
      LStr := LXYInfo.FTagname;
    end
    else
    begin
      ChannelY := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
      LStr2 := LXYInfo.FTagname;
    end;
  end;

  advance(it);
  LXYInfo := GetObject(it) as TXYGraphInfo;
  j := LXYInfo.FParameterIndex;

  if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].IsDisplayTrend then
  begin
    if LXYInfo.FAxis = aX then
    begin
      ChannelX := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].TrendChannelIndex;
      LStr := LXYInfo.FTagname + ';' + LStr2;
    end
    else
    begin
      ChannelY := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].TrendChannelIndex;
      LStr := LStr + ';' + LXYInfo.FTagname;
    end;
  end;

  //X,Y중 데이터 수가 더 작은 것 선택
  if iPlot1.Channel[i].Count > iPlot1.Channel[j].Count then
    LSmallerCount := iPlot1.Channel[j].Count - 1
  else
    LSmallerCount := iPlot1.Channel[i].Count - 1;

  LMultiMap := DMultiMap.Create;

  for i := 0 to LSmallerCount do
  begin
    tmpdouble := iPlot1.Channel[ChannelX].DataY[i];
    tmpdouble2 := iPlot1.Channel[ChannelY].DataY[i];

    if LIsDuplicated then
      XYDataAdd2Map(LMultiMap, tmpdouble, tmpdouble2, True)
    else
      ReplaceOrAddMap(LMultiMap, tmpdouble, tmpdouble2, True);
  end;

  FXYDataMap.putPair([LStr,LMultiMap])
end;

function TWatchF2.GetDesignControl(LPage: TAdvOfficePage): TControl;
var
  i: integer;
begin
  Result := nil;

  for i := 0 to LPage.ComponentCount - 1 do
  begin
    if LPage.Components[i] is TpjhPanel then
    begin
      Result := TControl(LPage.Components[i]);
      break;
    end;
  end;
end;

function TWatchF2.GetDesignPanel(LPage: TAdvOfficePage): TELDesignPanel;
var
  i: integer;
begin
  Result := nil;

  for i := 0 to LPage.ComponentCount - 1 do
  begin
    if LPage.Components[i] is TELDesignPanel then
    begin
      Result := TELDesignPanel(LPage.Components[i]);
      break;
    end;
  end;
end;

//AAutoStart: True = 프로그램 시작시에 watch file name을 parameter로 입력받는 경우
//            False = LoadFromFile 메뉴로 실행되는 경우
procedure TWatchF2.GetEngineParameterFromSavedWatchListFile(AAutoStart: Boolean;
  AFileName: string);
var
  i,j,k: integer;
  LStr: string;
  LUserLevel: THiMECSUserLevel;
  LStrList: TStringList;
begin
  if AFileName = '' then
  begin
    if Pos('\', FConfigOption.WatchListFileName) = 0 then
      AFileName := WatchListPath + FConfigOption.WatchListFileName
    else
      AFileName := FConfigOption.WatchListFileName;
  end;

  if FileExists(AFileName) then
  begin
    {LStr := IPCMonitorAll1.CheckExeFileNameForWatchListFile(FWatchListFileName);
    if LStr <> '' then
    begin
      LStr := ''''+FWatchListFileName + ''' file should be opend by ''' + LStr + '''';
      ShowMessage(LStr);
      exit;
    end;
    LUserLevel := IPCMonitorAll1.FCurrentUserLevel;
    if not IPCMonitorAll1.CheckUserLevelForWatchListFile(WatchListPath+FWatchListFileName, LUserLevel) then
    begin
      if AAutoStart then
        halt(0)
      else
      begin
        LStr := 'It is not match the user level.'+#13#10+'CurrentUserLevel = ';
        LStr := LStr + UserLevel2String(IPCMonitorAll1.FCurrentUserLevel) + #13#10+ 'Allow User Level = ';
        LStr := LStr + UserLevel2String(LUserLevel);//IPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList);
        ShowMessage(LStr);
        exit;
      end;
    end;
    }

    //LStr := WatchListPath+FWatchListFileName;
    FWG.GetItemsFromParamFile2Collect(AFileName, FConfigOption.EngParamFileFormat,
                FConfigOption.EngParamEncrypt, FIsMDIChileMode);

    FWG.NextGrid1.ClearRows;
    iPlot1.RemoveAllChannels;
    iPlot1.RemoveAllYAxes;

    //Administrator이상의 권한자 만이 Save user level 조정 가능함
    if IPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator then
    begin
      AllowUserlevelCB.Enabled := True;
    end;

    AllowUserlevelCB.Text := UserLevel2String(IPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList);

    if AllowUserlevelCB.Text = '' then
      AllowUserlevelCB.Text := UserLevel2String(IPCMonitorAll1.FCurrentUserLevel);

    if not FIsMDIChileMode then
    begin
      if (IPCMonitorAll1.FEngineParameter.FormWidth > 0) and
        (IPCMonitorAll1.FEngineParameter.FormHeight > 0) then
      begin
        Width := IPCMonitorAll1.FEngineParameter.FormWidth;
        Height := IPCMonitorAll1.FEngineParameter.FormHeight;
        Top := IPCMonitorAll1.FEngineParameter.FormTop;
        Left := IPCMonitorAll1.FEngineParameter.FormLeft;
        WindowState := TWindowState(IPCMonitorAll1.FEngineParameter.FormState);

        StayOnTopCB.Checked := IPCMonitorAll1.FEngineParameter.StayOnTop;
        SaveListCB.Checked := IPCMonitorAll1.FEngineParameter.SaveWatchForm;
        EnableAlphaCB.Checked := IPCMonitorAll1.FEngineParameter.UseAlphaBlend;
        JvTrackBar1.Position := IPCMonitorAll1.FEngineParameter.AlphaValue;
        if not IPCMonitorAll1.FEngineParameter.TabShow then
          PageControl1.TabSettings.Height := 0;
        if not IPCMonitorAll1.FEngineParameter.BorderShow then
          BorderStyle := bsNone;
      end;
    end;

    for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      //DisplayFormat 속성이 나중에 추가 되었기 때문에 적용 안된 WatchList파일의 경우 적용하기 위함
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat = '' then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat :=
          GetDisplayFormat(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition,
                          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].DisplayThousandSeperator);
      end;

      FWG.AddEngineParameter2Grid(i);

      if FWG.FEngineParameterItemRecord.FIsDisplayTrend then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend := False;
        AddChannelAndYAxis(i, tdtValue);
      end;

      if FWG.FEngineParameterItemRecord.FIsDisplaySimple then
      begin
        AddToSimple(i);
      end;
    end; //for

    LoadDesignForm(AFileName+DESIGNFORM_FILENAME);

    //SaveListCB.Checked := True;

    if AAutoStart then
    begin
      if PageControl1.AdvPageCount >= 5 then
        PageControl1.ActivePageIndex := 5;
    end;
  end
  else
  begin
    LStr := 'File not found : ' + AFileName;
    DisplayMessage(LStr);
    ShowMessage(LStr);
  end;

  if FConfigOption.DisplayAverageValue then
  begin
    FWG.FIsAvgDisplay4Items := True;
    FWG.FAverageQSize := FConfigOption.AverageSize;
    FWG.InitAvgMode;//각 Item에 Avg Q 생성
    FWG.SelectAllItems4Avg;
    FWG.StartAvgCalc;
  end;
end;

//procedure TWatchF2.GetFields2Grid(ADb: TSivak3Database; ATableName: String;
//  AGrid: TNextGrid);
//var
//  LnxTextColumn: TnxTextColumn;
//  LnxIncColumn: TnxIncrementColumn;
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
//    LnxIncColumn := TnxIncrementColumn(AGrid.Columns.Add(TnxIncrementColumn, 'No'));
//    LnxIncColumn.Name := 'No';
//    LnxIncColumn.Header.Alignment := taCenter;
//    LnxIncColumn.Sorted := True;
//    LnxIncColumn.SortKind := skDescending;
//    LnxIncColumn.SortType := stNumeric;
//
//    for Li := 0 to LStrList.Count - 1 do
//    begin
//      with AGrid do
//      begin
//        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn, LStrList[Li]));
//        LnxTextColumn.Name := LStrList[Li];
//        LnxTextColumn.Header.Alignment := taCenter;
//        LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
//      end;
//    end;
//  finally
//    LStrList.Free;
//  end;
//end;

function TWatchF2.GetFileNameFromWatchList: string;
begin
  Result := '';
  SetCurrentDir(FFilePath);
  JvOpenDialog1.InitialDir := '..\WatchList';
  JvOpenDialog1.Filter := '*.*';
  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      Result := jvOpenDialog1.FileName;
    end;
  end;
end;

procedure TWatchF2.GetLoadedPackages(APackageList: TStringList);
var
  i: integer;
begin
  if not Assigned(FBplFileList) then
    FBplFileList := TStringList.Create;

  for i := 0 to FBplFileList.Count - 1 do
  begin
    if APackageList.IndexOf(FBplFileList.Strings[i]) = -1 then
    begin
      APackageList.AddObject(FBplFileList.Strings[i], Pointer(FBplFileList.Objects[i]));
    end;
  end;
end;

function TWatchF2.GetparamIndexFromCollect(ATagName: string; var ADesc: string): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if ATagName = IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName then
    begin
      Result := i;
      ADesc := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;
      break;
    end;
  end;
end;

function TWatchF2.GetPeriodDataFromTrend(AIndex, Ai, Aj: integer; ADataType: TPeriodDataType): double;
var
  i: integer;
  LCA: TCircularArray;
begin
  if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AIndex].UseXYGraphConstant then
  begin
    Result := StrToFloatDef(ConstantEdit.Text, 0.0);
    exit;
  end;

  LCA := TCircularArray.Create(Aj-Ai+1);
  try
    AIndex := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AIndex].TrendChannelIndex;
    for i := Ai to Aj do
      LCA.Put(iPlot1.Channel[AIndex].DataY[i]);

    case ADataType of
      pdtAverage: Result := LCA.Average;
      pdtSum: Result := LCA.Sum;
      pdtMin: Result := LCA.Min;
      pdtMax: Result := LCA.Max;
      pdtPoint: Result := LCA.FData[0];
    end;
  finally
    FreeAndNil(LCA);
  end;
end;

function TWatchF2.GetTagNameFromDescriptor(ADescriptor: string): string;
var
  i: integer;
begin
  Result := '';

  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if ADescriptor = IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description then
    begin
      Result := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName;
      exit;
    end;
  end;
end;

//Tag Name과 Description을 각각의 StringList에 반환함
procedure TWatchF2.GetTagNames(ATagNameList, ADescriptList: TStringList);
var
  i: integer;
begin
  //ShowMessage('GetTagNames');
  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    ATagNameList.Add(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName);
    ADescriptList.Add(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description);
  end;
end;

function TWatchF2.GetTrendDataFromTagName(ATagName: string; AMap: DMap): DArray;
var
  it: Diterator;
begin
  Result := nil;
  it := AMap.locate([ATagName]);

  if not atEnd(it) then
    Result := GetObject(it) as DArray;
end;

procedure TWatchF2.GetXYPeriod(var Ai, Aj: integer);
var
  i: integer;
begin
  Ai := iPlot1.Channel[0].CalcIndex(iPlot1.DataCursor[0].DeltaX_P1_ValueX);
  Aj := iPlot1.Channel[0].CalcIndex(iPlot1.DataCursor[0].DeltaX_P2_ValueX);

  if Ai > Aj then
  begin
    i := Ai;
    Ai := Aj;
    Aj := i;
  end;

end;

procedure TWatchF2.Button1Click(Sender: TObject);
begin
  FWatchValueMax := 0;
  FWatchValueMin := 0;
end;

procedure TWatchF2.Button2Click(Sender: TObject);
begin
  FStartTrend := True;
end;

procedure TWatchF2.Button3Click(Sender: TObject);
begin
  FStartTrend := False;
end;

end.



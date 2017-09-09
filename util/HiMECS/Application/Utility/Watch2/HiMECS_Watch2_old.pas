unit HiMECS_Watch2_old;
{ 실행 방법
  HiMECS_Watch2p.exe /pEngParamFileName Command = Param파일 읽어서 Command에 따라 표시함.
                     /mAlarmlist = Alarmlist mode로 시작함
  Command = DISPLAYTREND: CopyData로 받은 Engparamd을 Trend로 보여줌
            SIMPLE: CopyData로 받은 Engparamd을 Simple로 보여줌

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
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, iComponent, iVCLComponent, iCustomComponent,
  iPlotComponent, iPlot, StdCtrls, ExtCtrls,SyncObjs, iniFiles, DeCALIO,
  DeCAL, Menus, janSQL, iProgressComponent, iLedBar, ShadowButton, SuperStream,
  iPositionComponent, iScaleComponent, iGaugeComponent, iAngularGauge, iXYPlotChannel,
  iPlotToolBar, iPlotObjects,iPlotChannelCustom, iTypes,
  DragDrop,
  DropTarget,
  DragDropFormats,
  DragDropText,
  WatchConfig2, CircularArray, WatchConst2, IPCThrd_LBX, IPCThrdMonitor_LBX,
  IPCThrd_WT1600, IPCThrdMonitor_WT1600, IPCThrd_ECS_kumo, IPCThrdMonitor_ECS_kumo,
  IPCThrd_MEXA7000, IPCThrdMonitor_MEXA7000, IPCThrd_MT210, IPCThrdMonitor_MT210,
  IPCThrd_FlowMeter, IPCThrdMonitor_FlowMeter, IPCThrd_DYNAMO, IPCThrdMonitor_DYNAMO,
  IPCThrd_ECS_AVAT, IPCThrdMonitor_ECS_AVAT, IPCThrd_GasCalc, IPCThrdMonitor_GasCalc,
  ModbusComStruct, ConfigOptionClass, DragDropRecord, HiMECSConst, AdvTrackBar,
  SBPro, TimerPool, EngineParameterClass, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, iXYPlot, NxColumns, NxColumnClasses, ImgList, JvDialogs,
  DropSource, JvExComCtrls, JvStatusBar, JclDebug, JvComCtrls, UnitEngParamConfig,
  UnitAlarmConfigClass, sql3_defs, DB, UnitAlarmConfig, Mask, JvExMask,
  JvToolEdit, UnitFrameIPCMonitorAll, CalcExpress;

type
  TEventData_MEXA7000_2 = packed record
    CO2: Double;//String 변수는 공유메모리에 사용 불가함
    CO_L: Double;
    O2: Double;
    NOx: Double;
    THC: Double;
    CH4: Double;
    non_CH4: Double;
    CollectedValue: Double;
 end;

  PDoublePoint = ^TDoublePoint;
  TDoublePoint = class
    X: Double;
    Y: Double;
  end;

  TWatchF2 = class(TForm)
    TFrameIPCMonitorAll1: TFrameIPCMonitorAll;
    PageControl1: TPageControl;
    TabSheet5: TTabSheet;
    NextGrid1: TNextGrid;
    NxImageColumn1: TNxImageColumn;
    NxImageColumn2: TNxImageColumn;
    ItemName: TNxTextColumn;
    Value: TNxTextColumn;
    FUnit: TNxTextColumn;
    NxImageColumn3: TNxImageColumn;
    NxImageColumn4: TNxImageColumn;
    NxCheckBoxColumn2: TNxCheckBoxColumn;
    JvStatusBar1: TJvStatusBar;
    Label4: TLabel;
    SaveListCB: TCheckBox;
    EnableAlphaCB: TCheckBox;
    JvTrackBar1: TJvTrackBar;
    StayOnTopCB: TCheckBox;
    AllowUserlevelCB: TComboBox;
    SimpleTabSheet: TTabSheet;
    DisplayPanel: TPanel;
    Label1: TLabel;
    WatchLabel: TLabel;
    AvgPanel: TPanel;
    Label2: TLabel;
    AvgLabel: TLabel;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Label3: TLabel;
    CurLabel: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MinLabel: TLabel;
    MaxLabel: TLabel;
    Button1: TButton;
    TrendTabSheet: TTabSheet;
    iPlot1: TiPlot;
    Button2: TButton;
    Button3: TButton;
    XYGraphTabSheet: TTabSheet;
    iXYPlot1: TiXYPlot;
    ConstantEdit: TEdit;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    DropTextTarget1: TDropTextTarget;
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
    ImageList1: TImageList;
    JvSaveDialog1: TJvSaveDialog;
    JvOpenDialog1: TJvOpenDialog;
    EngParamSource2: TDropTextSource;
    PopupMenu2: TPopupMenu;
    Add1: TMenuItem;
    Average1: TMenuItem;
    MinValue1: TMenuItem;
    MaxValue1: TMenuItem;
    N4: TMenuItem;
    LoadFromFile1: TMenuItem;
    AddtoCalculated1: TMenuItem;
    CalcExpress1: TCalcExpress;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Average1Click(Sender: TObject);
    procedure MinValue1Click(Sender: TObject);
    procedure MaxValue1Click(Sender: TObject);
    procedure DropTextTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure Close1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NextGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DeleteItem1Click(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure NextGrid1RowMove(Sender: TObject; FromPos, ToPos: Integer;
      var Accept: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure AddtoTrend2Click(Sender: TObject);
    procedure LoadFromFile1Click(Sender: TObject);
    procedure AddtoXYGraph1Click(Sender: TObject);
    procedure AddtoXYGraphFromTrendData1Click(Sender: TObject);
    procedure EnableAlphaCBClick(Sender: TObject);
    procedure DataSave1Click(Sender: TObject);
    procedure NextGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
    procedure NextGrid1DblClick(Sender: TObject);
    procedure DeleteFromXYGraph1Click(Sender: TObject);
    procedure AddAlarmValue1Click(Sender: TObject);
    procedure DeleteAlarmValueFromTrend1Click(Sender: TObject);
    procedure DeleteFaultValueFromTrend1Click(Sender: TObject);
    procedure StayOnTopCBClick(Sender: TObject);
    procedure NextGrid1CustomDrawCell(Sender: TObject; ACol, ARow: Integer;
      CellRect: TRect; CellState: TCellState);
    procedure AddtoCalculated1Click(Sender: TObject);
  private
    FFilePath: string;      //파일을 저장할 경로
    FProgramMode: TProgramMode;
    //FCurrentUserLevel: THiMECSUserLevel;

    FCriticalSection: TCriticalSection;
    FPJHTimerPool: TPJHTimerPool;
    FCalculatedItemTimerHandle: integer; //Calculated Item display용 Timer Handle

    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FFirst: Boolean; //타이머 동작 완료하면 True
    FMsgList: TStringList;  //Message를 저장하는 리스트

    FEngineParameterTarget: TEngineParameterDataFormat;
    //FEngineParameter: TEngineParameter;
    FEngParamSource: TEngineParameterDataFormat;
    FEngineParameterItemRecord: TEngineParameterItemRecord; //Save폼에 값 전달시 사용

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;

    procedure SendEPCopyData(ToHandle: integer; AEP:TEngineParameterItemRecord);
    procedure SendAlarmCopyData(ToHandle: integer; AEP:TEngineParameterItemRecord);

    procedure OnChangeDispPanelColor(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnDisplayCalculatedItemValue(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure SendFormCopyData(ToHandle: integer; AForm:TForm);
    function CheckExistTagName(AParameterSource: TParameterSource;
                                                  ATagName: string): integer;
    procedure GetEngineParameterFromSavedWatchListFile(AAutoStart: Boolean);
    function GetTagNameFromDescriptor(ADescriptor: string): string;
    procedure AppendEngineParameterFromFile(AFileName: string);
    procedure MoveEngineParameterItemRecord2(AEPItemRecord:TEngineParameterItem);
    procedure DeleteEngineParamterFromGrid(AIndex: integer);

    function GetAxisFromString(AAxes: String): TAxis;

    procedure LoadConfigEngParamItem2Form(AForm: TEngParamItemConfigForm;
      AEPItem:TEngineParameterItem);
    procedure GetFields2Grid(ADb: TSivak3Database; ATableName: String; AGrid: TNextGrid);

    procedure AdjustComponentByUserLevel;
    procedure FreeStrListFromGrid(AIndex: integer = -1);
  public
    //FOnExit: Boolean; //프로그램 종료시 True
    FStartTrend: Boolean;
    FOwnerHandle: THandle;//Owner form handle
    FOwnerListIndex: integer;//TList에 저장되는 Index(해제시에 필요함)
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체
    FConfigOption: TConfigOption;
    FWatchHandles : array of THandle;

    FTrendDataMap: DMap;
    FTrendDataMapFromFile: DMap;
    FXYDataMap: DMultiMap;
    FCompoundItemList: DArray; //Calculated Item List

    FXYDataIndex: array[0..1] of integer; //[0] = x 축 Index, [1] = Y 축 Index
    //FSharedName: string;//공유 메모리 이름
    //FFuncCode: string;//Modbus Function Code
    //FAddress: string;//Modbus Address
    FLabelName: string; //모니터링하고자 하는 데이타의 이름을 저장함.
    FWatchName: string; //component 이름을 저장함.(FunctionCode+Address)
    FWatchValue: string; //모니터링 데이타

    FWatchListFileName: string;//실행시 파라미터로 입력 받음(파라미터 저장파일)
    //Option변경시에 파일이름이 같을 경우 Readmap을 하지 않기 위해 필요함
    FCurrentModbusFileName: string;

    FWatchValueRecord: TEventData_MEXA7000; //유승원 요청사항, 모든 데이타를 한개의 차트에 표시하기 위함.
    FEnterWatchValue2Screen: Boolean;

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

    procedure InitVar;
    procedure DisplayMessage(Msg: string);
    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string);
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer);
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

    procedure CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);

    procedure LoadConfigDataXml2Var;
    procedure LoadConfigDataVar2Form(AMonitorConfigF : TWatchConfigF);
    procedure SaveConfigData2Xml;
    procedure SaveConfigDataForm2Xml(AMonitorConfigF : TWatchConfigF);
    procedure SetConfigData;
    procedure SetAlarm4OriginalOption(AValue: double; AEPIndex: integer);
    procedure SetAlarm4ThisOption(AValue: double);
    procedure SaveWatchList;

    procedure SetConfigEngParamItemData(AEPItem:TEngineParameterItem);

    procedure IPCAll_Final;
  end;

    procedure DoublePointIO(obj : TObject; stream : TObjStream; direction : TObjIODirection;
              version : Integer; var callSuper : Boolean);

var
  WatchF2: TWatchF2;

implementation

uses CommonUtil, UnitAxisSelect, UnitCopyWatchList;

{$R *.dfm}

procedure TWatchF2.InitVar;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FProgramMode := pmWatchList;
  SetCurrentDir(FFilePath);
  FCriticalSection := TCriticalSection.Create;
  FAddressMap := DMap.Create;
  FConfigOption := TConfigOption.Create(nil);

  FEngineParameterTarget := TEngineParameterDataFormat.Create(DropTextTarget1);
  FEngParamSource := TEngineParameterDataFormat.Create(EngParamSource2);
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FCalculatedItemTimerHandle := -1;
  //FEngineParameter := TEngineParameter.Create(nil);

  TFrameIPCMonitorAll1.FNextGrid := NextGrid1;
  TFrameIPCMonitorAll1.FPageControl := PageControl1;
  TFrameIPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;

  FTrendDataMap := DMap.Create;
  TObjStream.RegisterClass(TDoublePoint, DoublePointIO, 1);

  FTrendDataMapFromFile := DMap.Create;

  FXYDataMap := DMultiMap.Create;
  FCompoundItemList := DArray.Create;

  FMsgList := TStringList.Create;
  FMonitorStart := False;
  FFirst := True;
  LoadConfigDataXml2Var;

  FCurrentAryIndex := 0;
  FCurrentEPIndex4Watch := -1;
  FPrevEPIndex4Watch := -1;
  FFirstCalcAry := True;
  FXYDataIndex[0] := -1;
  FXYDataIndex[1] := -1;
  FWatchCA := TCircularArray.Create(FConfigOption.AverageSize);
  ApplyOption;

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
end;

procedure TWatchF2.IPCAll_Final;
begin
  TFrameIPCMonitorAll1.DestroyIPCMonitor(psECS_kumo);
  TFrameIPCMonitorAll1.DestroyIPCMonitor(psECS_AVAT);
  TFrameIPCMonitorAll1.DestroyIPCMonitor(psMT210);
  TFrameIPCMonitorAll1.DestroyIPCMonitor(psMEXA7000);
  TFrameIPCMonitorAll1.DestroyIPCMonitor(psWT1600);
  TFrameIPCMonitorAll1.DestroyIPCMonitor(psDynamo);
  TFrameIPCMonitorAll1.DestroyIPCMonitor(psLBX);
  TFrameIPCMonitorAll1.DestroyIPCMonitor(psFlowMeter);
  TFrameIPCMonitorAll1.DestroyIPCMonitor(psGasCalculated);
end;

procedure TWatchF2.iPlot1ToolBarButtonClick(Index: Integer;
  ButtonType: TiPlotToolBarButtonType);
begin
  if iptbbtEdit = ButtonType then
  begin
    FormStyle := fsNormal;
  end;

end;

procedure TWatchF2.JvStatusBar1Click(Sender: TObject);
begin
  JvStatusBar1.SimplePanel := not JvStatusBar1.SimplePanel;
end;

procedure TWatchF2.JvTrackBar1Change(Sender: TObject);
begin
  if EnableAlphaCB.Checked then
    AlphaBlendValue := JvTrackBar1.Position;
end;

procedure TWatchF2.LoadConfigDataVar2Form(AMonitorConfigF: TWatchConfigF);
begin
  AMonitorConfigF.MapFilenameEdit.FileName := FConfigOption.ModbusFileName;
  AMonitorConfigF.AvgEdit.Text := IntToStr(FConfigOption.AverageSize);
  AMonitorConfigF.DivisorEdit.Text := IntToStr(FConfigOption.Divisor);

  AMonitorConfigF.IntervalRG.ItemIndex := FConfigOption.SelDisplayInterval;
  AMonitorConfigF.IntervalEdit.Text := IntToStr(FConfigOption.DisplayInterval);

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

procedure TWatchF2.LoadConfigDataXml2Var;
var
  Lstr: string;
begin
  //Lstr := ExtractFileName(Application.ExeName);
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);
  if FileExists(LStr) then
  begin
    FConfigOption.LoadFromFile(Lstr, '', False);
    TFrameIPCMonitorAll1.FModbusMapFileName := FConfigOption.ModbusFileName;
  end;
end;

procedure TWatchF2.LoadConfigEngParamItem2Form(AForm: TEngParamItemConfigForm;
  AEPItem: TEngineParameterItem);
begin
  with AForm do
  begin
    //--------- General Page --------------
    TagNameEdit.Text := AEPItem.TagName;
    DescEdit.Text := AEPItem.Description;
    UnitEdit.Text := AEPItem.FFUnit;

    IntRB.Checked := AEPItem.MinMaxType = mmtInteger;
    RealRB.Checked := AEPItem.MinMaxType = mmtReal;

    if IntRB.Checked then
    begin
      MaxValueEdit.Text := IntToStr(AEPItem.MaxValue);
      MinValueEdit.Text := IntToStr(AEPItem.MinValue);
    end
    else if RealRB.Checked then
    begin
      MaxValueEdit.Text := FloatToStr(AEPItem.MaxValue_Real);
      MinValueEdit.Text := FloatToStr(AEPItem.MinValue_Real);
    end;

    ContactEdit.Text := IntToStr(AEPItem.Contact);
    IsAnalogCB.Checked := AEPItem.Alarm;

    SharedNameEdit.Text := AEPItem.SharedName;
    AddressEdit.Text := AEPItem.Address;
    FCEdit.Text := AEPItem.FCode;
    RadixEdit.Text := IntToStr(AEPItem.RadixPosition);

    //--------- Classfy Page --------------
    ParameterType2Combo(ParamTypeCombo);
    SensorType2Combo(SensorTypeCombo);
    ParameterSource2Combo(ParamSourceCombo);
    ParameterCatetory2Combo(ParamCategoryCombo);

    SensorTypeCombo.Text := SensorType2String(AEPItem.SensorType);
    ParamCategoryCombo.Text := ParameterCatetory2String(AEPItem.ParameterCatetory);
    ParamTypeCombo.Text := ParameterType2String(AEPItem.ParameterType);
    ParamSourceCombo.Text := ParameterSource2String(AEPItem.ParameterSource);

    //--------- Limit Value Page --------------
    LowAlarmGroup.Enabled := AEPItem.MinAlarmEnable;
    MaxAlarmGroup.Enabled := AEPItem.MaxAlarmEnable;
    LowFaultGroup.Enabled := AEPItem.MinFaultEnable;
    MaxFaultGroup.Enabled := AEPItem.MaxFaultEnable;

    LowAlarmEnableCB.Checked := AEPItem.MinAlarmEnable;
    MaxAlarmEnableCB.Checked := AEPItem.MaxAlarmEnable;
    LowFaultEnableCB.Checked := AEPItem.MinFaultEnable;
    MaxFaultEnableCB.Checked := AEPItem.MaxFaultEnable;

    MinAlarmEdit.Text := FloatToStr(AEPItem.MinAlarmValue);
    MinAlarmColorSelector.SelectedColor := AEPItem.MinAlarmColor;
    MinAlarmBlinkCB.Checked := AEPItem.MinAlarmBlink;
    MinAlarmSoundCB.Checked := AEPItem.MinAlarmSoundEnable;
    MinAlarmSoundEdit.FileName := AEPItem.MinAlarmSoundFilename;

    MaxAlarmEdit.Text := FloatToStr(AEPItem.MaxAlarmValue);
    MaxAlarmColorSelector.SelectedColor := AEPItem.MaxAlarmColor;
    MaxAlarmBlinkCB.Checked := AEPItem.MaxAlarmBlink;
    MaxAlarmSoundCB.Checked := AEPItem.MaxAlarmSoundEnable;
    MaxAlarmSoundEdit.FileName := AEPItem.MaxAlarmSoundFilename;

    MinFaultEdit.Text := FloatToStr(AEPItem.MinFaultValue);
    MinFaultColorSelector.SelectedColor := AEPItem.MinFaultColor;
    MinFaultBlinkCB.Checked := AEPItem.MinFaultBlink;
    MinFaultSoundCB.Checked := AEPItem.MinFaultSoundEnable;
    MinFaultSoundEdit.FileName := AEPItem.MinFaultSoundFilename;

    MaxFaultEdit.Text := FloatToStr(AEPItem.MaxFaultValue);
    MaxFaultColorSelector.SelectedColor := AEPItem.MaxFaultColor;
    MaxFaultBlinkCB.Checked := AEPItem.MaxFaultBlink;
    MaxFaultSoundCB.Checked := AEPItem.MaxFaultSoundEnable;
    MaxFaultSoundEdit.FileName := AEPItem.MaxFaultSoundFilename;

    MinEdit.Text := FloatToStr(AEPItem.YAxesMinValue);
    SpanEdit.Text := FloatToStr(AEPItem.YAxesSpanValue);
  end;
end;

procedure TWatchF2.LoadDatafromfile1Click(Sender: TObject);
begin
  OpenTrendDataFile(False);
end;

procedure TWatchF2.LoadFromFile1Click(Sender: TObject);
begin
  LoadTrendDataMapFromFile('');
  DisplayTrendFromMap(iPlot1, FTrendDataMap);
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
        NextGrid1.ClearRows;
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
          NextGrid1.AddRow();

          LStr3 := GetTokenWithComma(LStr2);
          NextGrid1.Cell[0, i-1].AsInteger := -1;
          NextGrid1.Cell[1, i-1].AsInteger := 1;
          NextGrid1.Cell[2, i-1].AsString := LStr3;
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
            LStr4 := GetTagNameFromDescriptor(NextGrid1.Cell[2, j].AsString)
          else
            LStr4 := NextGrid1.Cell[2, j].AsString;

          AddData2TrendMapFromFile(LStr4, tmpdouble2, tmpdouble);
        end;//for
      end;//for
    end
    else //if AIsUseWatchList
    begin
      //Channel 수가 표시할 데이터 종류보다 작으면 데이터 종류만큼 채널 생성
      //if iPlot1.ChannelCount < NextGrid1.SelectedCount then
      //begin
        //iPlot1.RemoveAllChannels;
        //iPlot1.RemoveAllYAxes;
        DeleteAllTrend;
        //그리드에서 선택된 데이터만 Trend에 추가
        for i := 0 to NextGrid1.RowCount - 1 do
          if NextGrid1.Row[i].Selected then
            AddChannelAndYAxis(i, tdtValue);
      //end;

      LIndexList := TStringList.Create;
      try
        //k := 0;//각 Index별 간격을 저장하기 위한 기준값 초기화
        for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
        begin
          if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
          begin
            if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesMinValue <> 0 then
              iPlot1.YAxis[LColumnCount].Min := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesMinValue;
            if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesSpanValue <> 0 then
              iPlot1.YAxis[LColumnCount].Span := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesSpanValue;

            LStr2 := LStr.Strings[0];
            LStr3 := GetTokenWithComma(LStr2); //맨 앞 시간 제거
            for j := 1 to LColumnCount - 1 do
            begin
              LStr3 := GetTokenWithComma(LStr2);
              if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName = LStr3 then
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
      FWatchListFileName := ExtractFileName(jvOpenDialog1.FileName);
      GetEngineParameterFromSavedWatchListFile(False);
    end;
  end;
end;

procedure TWatchF2.SaveConfigData2Xml;
var
  Lstr: string;
begin
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);
  FConfigOption.SaveToFile(Lstr, '', False);
end;

procedure TWatchF2.SaveConfigDataForm2Xml(AMonitorConfigF: TWatchConfigF);
var
  Lstr: string;
begin
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);

  FConfigOption.ModbusFileName := AMonitorConfigF.MapFilenameEdit.FileName;
  FCurrentModbusFileName := FConfigOption.ModbusFileName;
  FConfigOption.AverageSize := StrToIntDef(AMonitorConfigF.AvgEdit.Text,1);
  FConfigOption.Divisor := StrToIntDef(AMonitorConfigF.DivisorEdit.Text,1);

  FConfigOption.SelDisplayInterval :=AMonitorConfigF.IntervalRG.ItemIndex;
  FConfigOption.DisplayInterval := StrToIntDef(AMonitorConfigF.IntervalEdit.Text,0);

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
  FConfigOption.SaveToFile(Lstr);
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
  LStr: string;
begin
  it := AMap.startKey;
  SetToValue(it);

  while not atEnd(it) do
  begin
    LDoublePoint := GetObject(it) as TDoublePoint;
    LStr := format('%f'+#9+'%f',[LDoublePoint.X,LDoublePoint.Y]);
    SaveData2DateFile(AFileName,'dat', LStr, soFromEnd);
    Advance(it);
  end;//while
end;

procedure TWatchF2.SaveWatchList;
var
  i, LChCount: integer;
  LStr: string;
  LUser, LUser2: THiMECSUserLevel;
begin
  if (TFrameIPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator) and
      (AllowUserlevelCB.Enabled) and (AllowUserlevelCB.Text <> '') then
  begin
    i := Length(FWatchListFileName);
    LStr := System.Copy(FWatchListFileName,i,1);

    if LStr <> '' then
    begin
      LUser := THiMECSUserLevel(StrToInt(LStr));
      LUser2 := String2UserLevel(AllowUserlevelCB.Text);

      if LUser2 <> LUser then  //ComboBox User Level과 filename의 user level 비교
      begin
        if FileExists(WatchListPath+FWatchListFileName) then
        begin
          if MessageDlg('ComboBox User and FileName user level are different.'+#13#10+'Change file name to ComboBox User Level?',
                                      mtConfirmation, [mbYes, mbNo], 0)= mrYes then
          begin
              DeleteFile(WatchListPath+FWatchListFileName);
              FWatchListFileName := formatDateTime('yyyymmddhhnnsszzz',now)+IntToStr(Ord(LUser2));
          end;
        end;
      end;
    end;

      TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := String2UserLevel(AllowUserlevelCB.Text);
  end
  else
    TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := TFrameIPCMonitorAll1.FCurrentUserLevel;

  TFrameIPCMonitorAll1.FEngineParameter.ExeName := ExtractFileName(Application.ExeName);
  TFrameIPCMonitorAll1.FEngineParameter.FormWidth := Width;
  TFrameIPCMonitorAll1.FEngineParameter.FormHeight := Height;
  TFrameIPCMonitorAll1.FEngineParameter.FormTop := Top;
  TFrameIPCMonitorAll1.FEngineParameter.FormLeft := Left;
  TFrameIPCMonitorAll1.FEngineParameter.FormState := TpjhWindowState(WindowState);

  LChCount := 0;

  for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
    begin
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesMinValue :=
            iPlot1.YAxis[LChCount].Min;
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].YAxesSpanValue :=
            iPlot1.YAxis[LChCount].Span;
      Inc(LChCount);
    end;
  end;

  SetCurrentDir(FFilePath);
  if not setcurrentdir(WatchListPath) then
    createdir(WatchListPath);
  SetCurrentDir(FFilePath);

  if FWatchListFileName = '' then //file name 앞에 프로그램명(1) 붙임
    LStr := formatDateTime('1yyyymmddhhnnsszzz',now)+IntToStr(Ord(TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList))
  else
    LStr := FWatchListFileName;

  TFrameIPCMonitorAll1.FEngineParameter.SaveToFile(WatchListPath+LStr);
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
    NextGrid1.SaveToTextFile(TEMPFILENAME);
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
        NextGrid1.ClearRows;
        NextGrid1.LoadFromTextFile(TEMPFILENAME);

        for i := 0 to NextGrid1.RowCount - 1 do
          NextGrid1.Row[i].Selected := NextGrid1.Cell[7,i].AsBoolean;

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

procedure TWatchF2.SendAlarmCopyData(ToHandle: integer;
  AEP: TEngineParameterItemRecord);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := Handle;
    cbData := sizeof(AEP);
    lpData := @AEP;
  end;//with
                                   //WParam = 1: TAlarmListRecord
  SendMessage(ToHandle, WM_COPYDATA, 1, LongInt(@cd));
end;

procedure TWatchF2.SendEPCopyData(ToHandle: integer;
  AEP: TEngineParameterItemRecord);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := Handle;
    cbData := sizeof(AEP);
    lpData := @AEP;
  end;//with
                                   //WParam = 0: TEngineParameterItemRecord
  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
end;

procedure TWatchF2.SendFormCopyData(ToHandle: integer; AForm: TForm);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := Handle;
    cbData := sizeof(AForm);
    lpData := @AForm;
  end;//with

  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
end;

procedure TWatchF2.SetAlarm4OriginalOption(AValue: double; AEPIndex: integer);
var
  LSoundF: string;
begin
  if AEPIndex < 0 then
    exit;

  if (TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultEnable) and
    (AValue > TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultValue) then
  begin
    FCurrentChangeColor := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultColor;
    FBlinkEnable := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultSoundEnable then
    begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxFaultSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  if (TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmEnable) and
    (AValue > TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmValue) then
  begin
    FCurrentChangeColor := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmColor;
    FBlinkEnable := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmSoundEnable then
    begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MaxAlarmSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  if (TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultEnable) and
    (AValue < TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultValue) then
  begin
    FCurrentChangeColor := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultColor;
    FBlinkEnable := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultSoundEnable then
    begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinFaultSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  if (TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmEnable) and
    (AValue < TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmValue) then
  begin
    FCurrentChangeColor := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmColor;
    FBlinkEnable := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmSoundEnable then
    begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].MinAlarmSoundFilename;

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
var EngMonitorConfigF: TWatchConfigF;
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

procedure TWatchF2.SetConfigEngParamItemData(AEPItem: TEngineParameterItem);
var
  ConfigData: TEngParamItemConfigForm;
begin
  ConfigData := nil;
  ConfigData := TEngParamItemConfigForm.Create(Self);
  try
    with ConfigData do
    begin
      LoadConfigEngParamItem2Form(ConfigData, AEPItem);
      if ShowModal = mrOK then
      begin
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
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
  i: integer;
  LStr: string;
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

      FWatchListFileName := '';

      if ParamCount > 0 then
      begin
        LStr := UpperCase(ParamStr(1));
        i := Pos('/P', LStr);
        if i > 0 then  //P 제거
        begin
          LStr := Copy(LStr, i+2, Length(LStr)-i-1);
          FWatchListFileName := LStr;
          GetEngineParameterFromSavedWatchListFile(True);
          FProgramMode := pmWatchList;
          NextGrid1.PopupMenu := WatchListPopup;
        end;

        i := Pos('/M', LStr);
        if i > 0 then  //M 제거
        begin
          LStr := Copy(LStr, i+2, Length(LStr)-i-1);
          if LStr = 'ALARMLIST' then
          begin
            ChangeAlarmListMode;
          end;
        end;
      end
      else
        NextGrid1.PopupMenu := WatchListPopup;

      AdjustComponentByUserLevel;
      //Application.ShowMainForm := True;
      //Visible := True;
    end;
  finally
    FMonitorStart := True;
    Timer1.Enabled := True;
  end;//try

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
    
  for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayXY then
    begin
      LStr2 := AList.Strings[0];
      LStr3 := GetTokenWithComma(LStr2); //맨 앞 시간 제거
      for j := 1 to LColumnCount - 1 do
      begin
        LStr3 := GetTokenWithComma(LStr2);
        if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName = LStr3 then
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
begin
  FMonitorStart := False;
  //Action := caFree;
  SendMessage(FOwnerHandle, WM_WATCHFORM_CLOSE, FOwnerListIndex, 0);

  if SaveListCB.Checked then
    SaveWatchList
  else
  begin
    if FWatchListFileName <> '' then
    begin
      if FileExists(WatchListPath+FWatchListFileName) then
      begin
        LUserLevel := TFrameIPCMonitorAll1.FCurrentUserLevel;
        if TFrameIPCMonitorAll1.CheckUserLevelForWatchListFile(FWatchListFilename, LUserLevel) then
          if MessageDlg('Do you want to delete the watch list file?',
                                  mtConfirmation, [mbYes, mbNo], 0)= mrYes then
            DeleteFile(WatchListPath+FWatchListFileName);
      end;
    end;
  end;
end;

//Trend에서 Channel Delete 시에 Channel Index를 재조정하는 함수
procedure TWatchF2.UpdateChannelIndex(AIndex: integer);
var
  i,j: integer;
begin
  for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
    if AIndex < j then
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex := j - 1;

    j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex;
    if AIndex < j then
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex := j - 1;

    j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex;
    if AIndex < j then
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex := j - 1;
  end;
end;

procedure TWatchF2.UpdateYAxisIndex(AIndex: integer);
var
  i,j: integer;
begin
  for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendYAxisIndex;
    if AIndex < j then
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendYAxisIndex := j - 1;
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
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].RadixPosition > 1 then
        LStr := IntToStr(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].RadixPosition)
      else
        LStr := '1';

      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := format('%.'+LStr+'f',[Le]);
    end
    else
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));

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
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));
    end
    else if (AHiMap.FName = 'AI_TC_A_RPM') or (AHiMap.FName = 'AI_TC_B_RPM') then
    begin
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));
    end
    else
    begin
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));
    end;

    WatchValue2Screen_Analog(AHiMap.FName, FWatchValue, AEPIndex);
  end
  else //Digital data
  begin

  end;
end;

procedure TWatchF2.DataSave1Click(Sender: TObject);
var
  i,j,LHandle: integer;
  LProcessId: THandle;
begin
  if NextGrid1.SelectedCount > 0 then
  begin
    SetCurrentDir(FFilePath);
    LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FFilePath)+HiMECSWatchSaveName);
    LHandle := DSiGetProcessWindow(LProcessId);
    SetLength(FWatchHandles, Length(FWatchHandles)+1);
    FWatchHandles[High(FWatchHandles)] := LHandle;

    for i := 0 to NextGrid1.RowCount - 1 do
    begin
      if NextGrid1.Row[i].Selected then
      begin
        MoveEngineParameterItemRecord2(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i]);
        SendEPCopyData(LHandle,FEngineParameterItemRecord);
        //exit;
      end;
    end;
  end;
end;

procedure TWatchF2.DeleteAlarmValueFromTrend1Click(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if NextGrid1.Row[i].Selected then
    begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm then
      begin
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm := false;
        j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex;
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
  for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend := False;
    TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm := False;
    TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault := False;
    NextGrid1.Cell[1, i].AsInteger := -1;
  end;

  iPlot1.RemoveAllYAxes;
  iPlot1.RemoveAllChannels;
end;

procedure TWatchF2.DeleteEngineParamterFromGrid(AIndex: integer);
begin
  FreeStrListFromGrid(AIndex);
  DeleteFromTrend1Click(nil);
  NextGrid1.DeleteRow(AIndex);
  TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Delete(AIndex);
end;

procedure TWatchF2.DeleteFaultValueFromTrend1Click(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if NextGrid1.Row[i].Selected then
    begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault then
      begin
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault := false;
        j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex;
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
  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if NextGrid1.Row[i].Selected then
    begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
      begin
        if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm then
        begin
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm := false;
          j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex;
          iPlot1.DeleteChannel(j);
        end;

        if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault then
        begin
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault := false;
          j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex;
          iPlot1.DeleteChannel(j);
        end;

        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend := false;
        j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
        iPlot1.DeleteChannel(j);
        UpdateChannelIndex(j);
        j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendYAxisIndex;
        iPlot1.DeleteYAxis(j);
        UpdateYAxisIndex(j);
      end;

      NextGrid1.Cell[1, i].AsInteger := -1;
    end;
  end;
end;

procedure TWatchF2.DeleteFromXYGraph1Click(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    //if NextGrid1.Row[i].Selected then
    //begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayXY then
      begin
        for j := 0 to iXYPlot1.ChannelCount - 1 do
          iXYPlot1.Channel[j].Clear;

        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayXY := False;
        NextGrid1.Cell[5, i].AsInteger := -1;
        FXYDataIndex[0] := -1;
        FXYDataIndex[1] := -1;
      end;
    //end;
  end;
end;

procedure TWatchF2.DeleteItem1Click(Sender: TObject);
var
  i: integer;
begin
  //Grid Item 삭제시에 Timer 함수에서 접근시 AVE 발생하기 때문
  if FCalculatedItemTimerHandle <> -1 then
    FPJHTimerPool.Enabled[FCalculatedItemTimerHandle] := False;

  for i := NextGrid1.RowCount - 1 Downto 0 do
    if NextGrid1.Row[i].Selected then
      DeleteEngineParamterFromGrid(i);

  if FCalculatedItemTimerHandle <> -1 then
    FPJHTimerPool.Enabled[FCalculatedItemTimerHandle] := True;
end;

procedure TWatchF2.DisplayMessage(Msg: string);
var
  i: integer;
begin
  if (Msg = '') and (FMsgList.Count > 0) then
    Msg := FMsgList.Strings[0];

  //MsgLed.Caption := Msg;
  i := FMsgList.IndexOf(Msg);
  //메세지 출력 후 리스트에서 삭제함(매번 Timer함수에 의해 다시 들어오기 때문임)
  if i > -1 then
    FMsgList.Delete(i);
end;

procedure TWatchF2.DisplayMessage2SB(Msg: string);
begin
  JvStatusBar1.SimplePanel := True;
  JvStatusBar1.SimpleText := Msg;
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

  for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
    begin
      if not AXValueisDateTime then
      begin
        tmpdouble2 := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].PlotXValue;
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].PlotXValue :=
            TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].PlotXValue + 1.0;
      end;
      j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
      tmpdouble := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value,0.0);
      //if AXValueisDateTime then
      //  iPlot1.Channel[j].AddYNow(tmpdouble)
      //else
        iPlot1.Channel[j].AddXY(tmpdouble2, tmpdouble);

      //iPlot1.Channel[j].AddYElapsedTime(LValue);
      if FConfigOption.ZoomToFitTrend then
        iPlot1.Channel[j].YAxis.ZoomToFit;
      //AddData2TrendMap(i, tmpdouble2, tmpdouble);

      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendAlarm then
      begin
        j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendAlarmIndex;
        if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinAlarmEnable then
          tmpdouble := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinAlarmValue
        else
          tmpdouble := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MaxAlarmValue;

        iPlot1.Channel[j].AddXY(tmpdouble2, tmpdouble);
      end;

      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrendFault then
      begin
        j := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendFaultIndex;
        if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinFaultEnable then
          tmpdouble := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinFaultValue
        else
          tmpdouble := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MaxFaultValue;

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

  tmpdouble := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value,0.0);
  tmpdouble2 := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].Value,0.0);

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

procedure TWatchF2.DropTextTarget1Drop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
begin
  // Determine if we got our custom format.
  if (FEngineParameterTarget.HasData) then
  begin
    // Extract the dropped data into our custom struct.
    //FEngineParameterTarget.GetDataHere(FEngineParameterTarget.EPD, sizeof(FEngineParameterTarget.EPD));

    // Display the data.
    //FSharedName := TEP.FSharedName;
    //FFuncCode := TEP.FFunctionCode;
    //FAddress := TEP.FAddress;
    //FWatchName := FEngineParameterTarget.EPD.FFCode + FEngineParameterTarget.EPD.FAddress;
    //Label1.Caption := FEngineParameterTarget.EPD.FDescription;
    //Caption := 'Multi-Watch: '+ Label1.Caption;

    CreateIPCMonitor(FEngineParameterTarget.EPD);
  end else
    ;//PanelDest.Caption := TDropTextTarget(Sender).Text;
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
    tmpdouble := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value, 0.0);

    if FCurrentEPIndex4Watch = AEPIndex then
      FWatchCA.Put(tmpdouble);

    DisplayTrend(true,now);
    DisplayXYGraphRealTime( iXYPlot1.Channel[0] );

    case PageControl1.ActivePageIndex of
      0: begin //Items
        //for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
        //begin
          NextGrid1.CellsByName['Value', AEPIndex] := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
        //end;
      end;
      1: begin //simple
        if FCurrentEPIndex4Watch > -1 then
        begin
          WatchLabel.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[FCurrentEPIndex4Watch].Value;
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
          CurLabel.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[FCurrentEPIndex4Watch].Value;
        end;
      end;
      3: begin //Trend
      end;
      4: begin //XY Graph
      end;
    end;//case
  finally
    FEnterWatchValue2Screen := False;
  end;
end;

procedure TWatchF2.WMCopyData(var Msg: TMessage);
var
  i: integer;
begin
  case Msg.WParam of
    0: begin
      FProgramMode := pmWatchList;
      //PageControl1.Pages[PageControl1.PageCount - 1].TabVisible := False;
    end;
    1: begin
      ChangeAlarmListMode;
    end;
  end;

  if Msg.WParam = 2 then //User Level Receive
  begin
    TFrameIPCMonitorAll1.FCurrentUserLevel := THiMECSUserLevel(PCopyDataStruct(Msg.LParam)^.cbData);
  end
  else
    CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^);
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

procedure TWatchF2.FormDestroy(Sender: TObject);
var
  it: DIterator;
  LArray: DArray;
  i: integer;
begin
  if FConfigOption.SubWatchClose then
    for i := Low(FWatchHandles) to High(FWatchHandles) do
      SendMessage(FWatchHandles[i], WM_CLOSE, 0, 0);

  FWatchHandles := nil;
  FEngParamSource.Free;

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

  FreeStrListFromGrid;

  FCompoundItemList.Free;

  ObjFree(FXYDataMap);
  FXYDataMap.Free;


  FConfigOption.Free;
  FEngineParameterTarget.Free;

  //TFrameIPCMonitorAll1.FEngineParameter.Free;

  FMsgList.Free;
  FWatchCA.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
end;

procedure TWatchF2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  case Key of
    vk_control: begin
      if (ssCtrl in Shift) then
      begin
        ;//
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

procedure TWatchF2.ChangeAlarmListMode;
var
  i: integer;
begin
{  FProgramMode := pmAlarmList;
  PageControl1.Pages[0].Caption := 'Alarm Items';
  PageControl1.Pages[PageControl1.PageCount - 1].TabVisible := True;

  for i := 1 to PageControl1.PageCount - 2 do
    PageControl1.Pages[i].TabVisible := False;

  NextGrid1.PopupMenu := AlarmListPopup;
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

procedure TWatchF2.EnableAlphaCBClick(Sender: TObject);
begin
  AlphaBlend := EnableAlphaCB.Checked;
end;

function TWatchF2.CheckExistTagName(AParameterSource: TParameterSource;
                                                  ATagName: string): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if (TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource =
                                                AParameterSource) and
        (TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName =
                                                ATagName) then
    begin
      Result := i;
      exit;
    end;
  end;
end;

procedure TWatchF2.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TWatchF2.Config1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TWatchF2.CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
var
  i, LResult: integer;
begin
  LResult := TFrameIPCMonitorAll1.CreateIPCMonitor(AEP_DragDrop);

  if LResult = -1 then
  begin
    i := NextGrid1.AddRow();
    NextGrid1.CellsByName['ItemName', i] := AEP_DragDrop.FDescription;
    NextGrid1.CellsByName['FUnit', i] := AEP_DragDrop.FUnit;
    NextGrid1.ClearSelection;
    //NextGrid1.Selected[i] := True;
    NextGrid1.ScrollToRow(i);
    NextGrid1.Cell[0, i].AsInteger := -1;
    NextGrid1.Cell[1, i].AsInteger := -1;
    NextGrid1.Cell[5, i].AsInteger := -1;

   //Administrator이상의 권한자 만이 Config form에서 level 조정 가능함
    if TFrameIPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator then
    begin
      AllowUserlevelCB.Enabled := True;
    end;

    if AllowUserlevelCB.Text = '' then
      AllowUserlevelCB.Text := UserLevel2String(TFrameIPCMonitorAll1.FCurrentUserLevel);
  end;

  if ParamCount > 1 then
  begin
    if UpperCase(ParamStr(2)) = 'DISPLAYTREND' then
    begin
      i := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1;
      AddChannelAndYAxis(i, tdtValue);
      PageControl1.ActivePage := TrendTabSheet;
    end
    else
    if UpperCase(ParamStr(2)) = 'SIMPLE' then
    begin
      i := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1;
      AddToSimple(i);
      PageControl1.ActivePage := SimpleTabSheet;
    end
  end;
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

procedure TWatchF2.MoveEngineParameterItemRecord2(
  AEPItemRecord: TEngineParameterItem);
begin
  FEngineParameterItemRecord.FLevelIndex := AEPItemRecord.LevelIndex;
  FEngineParameterItemRecord.FNodeIndex := AEPItemRecord.NodeIndex;
  FEngineParameterItemRecord.FAbsoluteIndex := AEPItemRecord.AbsoluteIndex;
  FEngineParameterItemRecord.FMaxValue := AEPItemRecord.MaxValue;
  FEngineParameterItemRecord.FContact := AEPItemRecord.Contact;

  FEngineParameterItemRecord.FSharedName := AEPItemRecord.SharedName;
  FEngineParameterItemRecord.FTagName := AEPItemRecord.Tagname;
  FEngineParameterItemRecord.FDescription := AEPItemRecord.Description;
  FEngineParameterItemRecord.FAddress := AEPItemRecord.Address;
  FEngineParameterItemRecord.FFCode := AEPItemRecord.FCode;
  FEngineParameterItemRecord.FUnit := AEPItemRecord.FFUnit;
  FEngineParameterItemRecord.FMinMaxType := AEPItemRecord.MinMaxType;
  FEngineParameterItemRecord.FAlarm := AEPItemRecord.Alarm;
  FEngineParameterItemRecord.FRadixPosition := AEPItemRecord.RadixPosition;

  FEngineParameterItemRecord.FSensorType := AEPItemRecord.SensorType;
  FEngineParameterItemRecord.FParameterCatetory := AEPItemRecord.ParameterCatetory;
  FEngineParameterItemRecord.FParameterType := AEPItemRecord.ParameterType;
  FEngineParameterItemRecord.FParameterSource := AEPItemRecord.ParameterSource;

  FEngineParameterItemRecord.FMinAlarmEnable := AEPItemRecord.MinAlarmEnable;
  FEngineParameterItemRecord.FMaxAlarmEnable := AEPItemRecord.MaxAlarmEnable;
  FEngineParameterItemRecord.FMinFaultEnable := AEPItemRecord.MinFaultEnable;
  FEngineParameterItemRecord.FMaxFaultEnable := AEPItemRecord.MaxFaultEnable;

  FEngineParameterItemRecord.FMinAlarmValue := AEPItemRecord.MinAlarmValue;
  FEngineParameterItemRecord.FMaxAlarmValue := AEPItemRecord.MaxAlarmValue;
  FEngineParameterItemRecord.FMinFaultValue := AEPItemRecord.MinFaultValue;
  FEngineParameterItemRecord.FMaxFaultValue := AEPItemRecord.MaxFaultValue;

  FEngineParameterItemRecord.FMinAlarmColor := AEPItemRecord.MinAlarmColor;
  FEngineParameterItemRecord.FMaxAlarmColor := AEPItemRecord.MaxAlarmColor;
  FEngineParameterItemRecord.FMinFaultColor := AEPItemRecord.MinFaultColor;
  FEngineParameterItemRecord.FMaxFaultColor := AEPItemRecord.MaxFaultColor;

  FEngineParameterItemRecord.FMinAlarmBlink := AEPItemRecord.MinAlarmBlink;
  FEngineParameterItemRecord.FMaxAlarmBlink := AEPItemRecord.MaxAlarmBlink;
  FEngineParameterItemRecord.FMinFaultBlink := AEPItemRecord.MinFaultBlink;
  FEngineParameterItemRecord.FMaxFaultBlink := AEPItemRecord.MaxFaultBlink;

  FEngineParameterItemRecord.FMinAlarmSoundEnable := AEPItemRecord.MinAlarmSoundEnable;
  FEngineParameterItemRecord.FMaxAlarmSoundEnable := AEPItemRecord.MaxAlarmSoundEnable;
  FEngineParameterItemRecord.FMinFaultSoundEnable := AEPItemRecord.MinFaultSoundEnable;
  FEngineParameterItemRecord.FMaxFaultSoundEnable := AEPItemRecord.MaxFaultSoundEnable;

  FEngineParameterItemRecord.FMinAlarmSoundFilename := AEPItemRecord.MinAlarmSoundFilename;
  FEngineParameterItemRecord.FMaxAlarmSoundFilename := AEPItemRecord.MaxAlarmSoundFilename;
  FEngineParameterItemRecord.FMinFaultSoundFilename := AEPItemRecord.MinFaultSoundFilename;
  FEngineParameterItemRecord.FMaxFaultSoundFilename := AEPItemRecord.MaxFaultSoundFilename;

  FEngineParameterItemRecord.FIsDisplayTrend := AEPItemRecord.IsDisplayTrend;
  FEngineParameterItemRecord.FIsDisplaySimple := AEPItemRecord.IsDisplaySimple;
  FEngineParameterItemRecord.FTrendChannelIndex := AEPItemRecord.TrendChannelIndex;
  FEngineParameterItemRecord.FPlotXValue := AEPItemRecord.PlotXValue;
  FEngineParameterItemRecord.FMinValue := AEPItemRecord.MinValue;
  FEngineParameterItemRecord.FMinValue_Real := AEPItemRecord.MinValue_Real;

  FEngineParameterItemRecord.FAllowUserLevelWatchList := TFrameIPCMonitorAll1.FCurrentUserLevel;
{
  FEngineParameterItemRecord.FFormWidth := AEPItemRecord.FormWidth;
  FEngineParameterItemRecord.FFormHeight := AEPItemRecord.FormHeight;
  FEngineParameterItemRecord.FFormTop := AEPItemRecord.FormTop;
  FEngineParameterItemRecord.FFormLeft := AEPItemRecord.FormLeft;
  FEngineParameterItemRecord.FFormState := AEPItemRecord.FormState;
}
end;

procedure TWatchF2.NextGrid1CustomDrawCell(Sender: TObject; ACol, ARow: Integer;
  CellRect: TRect; CellState: TCellState);
begin
  //if (ARow mod 2) = 0 then
  //  NextGrid1.Cell[ACol, ARow].Color := $00E9FFD2;
end;

procedure TWatchF2.NextGrid1DblClick(Sender: TObject);
begin
  Properties1Click(nil);
end;

procedure TWatchF2.NextGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_delete: begin
      DeleteItem1Click(nil);
      //DeleteEngineParamterFromGrid(NextGrid1.SelectedRow);
    end;
  end;
end;

procedure TWatchF2.NextGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LEngineParameterItem: TEngineParameterItem;
begin
  if NextGrid1.SelectedCount > 0 then
  begin
    if (DragDetectPlus(TWinControl(Sender).Handle, Point(X,Y))) then
    begin
      for i := 0 to NextGrid1.RowCount - 1 do
      begin
        if NextGrid1.Row[i].Selected then
        begin
          MoveEngineParameterItemRecord2(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i]);

          // Transfer the structure to the drop source data object and execute the drag.
          //FEngParamSource.SetDataHere(FEP_DragDrop, sizeof(FEP_DragDrop));
          FEngParamSource.EPD := FEngineParameterItemRecord;

          EngParamSource2.Execute;
          exit;
        end;
      end;
    end;

  end;
end;

procedure TWatchF2.NextGrid1RowMove(Sender: TObject; FromPos, ToPos: Integer;
  var Accept: Boolean);
begin
  //ShowMessage(IntToStr(FromPos)+'->'+IntToStr(ToPos));
end;

procedure TWatchF2.UpButtonClick(Sender: TObject);
begin
  NextGrid1.MoveRow(NextGrid1.SelectedRow, NextGrid1.SelectedRow - 1);
  NextGrid1.SelectedRow := NextGrid1.SelectedRow - 1;
end;

procedure TWatchF2.DownButtonClick(Sender: TObject);
begin
  NextGrid1.MoveRow(NextGrid1.SelectedRow, NextGrid1.SelectedRow + 1);
  NextGrid1.SelectedRow := NextGrid1.SelectedRow + 1;
end;

procedure TWatchF2.OnChangeDispPanelColor(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  ChangeDispPanelColor(TColor(FCurrentChangeColor));
end;

procedure TWatchF2.OnDisplayCalculatedItemValue(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
var
  it: DIterator;
  i,j,k: integer;
  LNameStrings: TStringList;
  Largs : array [0..100] of extended;
  LDouble: Double;
begin
  LNameStrings := TStringList.Create;
  try
    it := FCompoundItemList.start;
    while iterateOver(it) do
    begin
      i := GetInteger(it);
      CalcExpress1.Formula :=
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;

      LNameStrings.Clear;

      for j := 0 to TStringList(NextGrid1.Row[i].Data).Count - 1 do
      begin
        LNameStrings.Add(TStringList(NextGrid1.Row[i].Data).Names[j]);
        k := StrToInt(TStringList(NextGrid1.Row[i].Data).ValueFromIndex[j]);
        Largs[j] := StrToFloatDef(
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[k].Value,
          0.0);
      end;

      CalcExpress1.Variables := LNameStrings;//.Assign(LNameStrings);
      LDouble := CalcExpress1.calc(Largs);
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value :=
        Format('%.2f', [LDouble]);
      WatchValue2Screen_Analog('', '', i);
    end;//while

  finally
    FreeAndNil(LNameStrings);
  end;
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

//X,Y축 설정
function TWatchF2.PrepareXYGraph(AArray: DArray; AIsChannelClear: Boolean): Boolean;
var
  i,j,k: integer;
  LXYInfo: TXYGraphInfo;
  it: Diterator;
begin
  Result := False;

  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if NextGrid1.Row[i].Selected then
    begin
      LXYInfo := TXYGraphInfo.Create;
      LXYInfo.FTagname := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;
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
                TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].IsDisplayXY := True;
                NextGrid1.Cell[5, j].AsInteger := 1;

                advance(it);
                LXYInfo := GetObject(it) as TXYGraphInfo;
                LXYInfo.FAxis := GetAxisFromString(XYSelectGrid.Cells[1,1]);
                if XYSelectGrid.Cells[2,1] <> '' then
                begin
                  LXYInfo.FUseConstant := XYSelectGrid.Cell[2,1].AsBoolean;
                end;
                j := LXYInfo.FParameterIndex;
                TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].IsDisplayXY := True;
                NextGrid1.Cell[5, j].AsInteger := 1;
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

procedure TWatchF2.Properties1Click(Sender: TObject);
var
  LEngineParameterItem: TEngineParameterItem;
  Li: integer;
begin
  if NextGrid1.SelectedCount > 1 then
  begin
    ShowMessage('This function allows when selected only one row!');
    exit;
  end;

  if NextGrid1.SelectedCount = 1 then
  begin
    Li := NextGrid1.SelectedRow;
    LEngineParameterItem := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[Li];
    SetConfigEngParamItemData(LEngineParameterItem);
  end;

end;

procedure TWatchF2.ReadMapAddress(AddressMap: DMap; MapFileName: string);
var
  sqltext, MapFilePath: string;
  sqlresult, reccnt, fldcnt: integer;
  i: integer;
  filename, fcode: string;
  shbtn: TShadowButton;
  janDB: TjanSQL;
  HiMap: THiMap;
begin
  if fileexists(MapFileName) then
  begin
    Filename := ExtractFileName(MapFileName);
    FileName := Copy(Filename,1, Pos('.',Filename) - 1);
    MapFilePath := ExtractFilePath(MapFileName);
    janDB :=TjanSQL.create;
    try
      sqltext := 'connect to ''' + MapFilePath + '''';

      sqlresult := janDB.SQLDirect(sqltext);
      //Connect 성공
      if sqlresult <> 0 then
      begin
        with janDB do
        begin
          sqltext := 'select * from ' + FileName + ' group by cnt';
          sqlresult := SQLDirect(sqltext);
          //Query 정상
          if sqlresult <> 0 then
          begin
            //데이타 건수가 1개 이상 있으면
            if sqlresult>0 then
            begin
              fldcnt := RecordSets[sqlresult].FieldCount;
              //Field Count가 0 이면
              if fldcnt = 0 then exit;

              reccnt := RecordSets[sqlresult].RecordCount;
              //Record Count가 0 이면
              if reccnt = 0 then exit;

              for i := 0 to reccnt - 1 do
              begin
                HiMap := THiMap.Create;
                with HiMap, RecordSets[SqlResult].Records[i] do
                begin
                  FName := Fields[0].Value;
                  FDescription := Fields[1].Value;
                  FSid := StrToInt(Fields[2].Value);
                  FAddress := Fields[3].Value;
                  FBlockNo := StrToInt(Fields[4].Value);
                  //kumo ECS를 Value2Screen_ECS 함수에서 처리하기 위함
                  FUnit := Fields[5].Value;

                  if Fields[5].Value = 'FALSE' then
                  begin
                    FAlarm := False;
                    fcode := '1';
                  end
                  else if Fields[5].Value = 'TRUE4' then
                  begin
                    FAlarm := True;
                    fcode := '4';
                  end
                  else if Fields[5].Value = 'TRUE' then
                  begin
                    FAlarm := True;
                    fcode := '3';
                  end
                  else if Fields[5].Value = 'FALSE3' then
                  begin
                    FAlarm := False;
                    fcode := '3';
                  end;

                  FMaxval := StrToFloat(Fields[6].Value);
                  FContact := StrToInt(Fields[7].Value);
                  FUnit := '';

                  shbtn := nil;
                  shbtn := TShadowButton(FindComponent(FName));
                  if Assigned(shbtn) then
                    shbtn.Hint := FDescription;
                end;//with

                AddressMap.PutPair([fcode + HiMap.FAddress,HiMap]);
              end;//for
            end;

          end
          else
            DisplayMessage2SB(janDB.Error);
        end;//with
      end
      else
        Application.MessageBox('Connect 실패',
            PChar('폴더 ' + FFilePath + ' 를 만든 후 다시 하시오'),MB_ICONSTOP+MB_OK);
    finally
      janDB.Free;
    end;
  end
  else
  begin
    sqltext := MapFileName + '파일을 만든 후에 다시 하시오';
    Application.MessageBox('Data file does not exist!', PChar(sqltext) ,MB_ICONSTOP+MB_OK);
  end;
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

procedure TWatchF2.AddAlarmValue1Click(Sender: TObject);
var
  i: integer;
begin
  if NextGrid1.SelectedCount = 1 then
  begin
    i := NextGrid1.SelectedRow;

    if not TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
    begin
      ShowMessage('Please execute ''Add To Trend'' Frist!');
      exit;
    end;

    if (TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MinAlarmEnable) or
      (TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].MaxAlarmEnable) then
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

//ACheckTrendType=
//Alarm 과 Fault의 경우에는 Channel만 생성하고 Y Axis는 생성 안함
//Alarm과 Fault의 경우 이미 IsDisplayTrend 상태임
function TWatchF2.AddChannelAndYAxis(AParamIndex: integer; ACheckTrendType: TTrendDataType): integer;
var
  i,j,k: integer;
begin
  case ACheckTrendType of //기존 display시에는 중복 방지하기 위함
    tdtValue: begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrend then
        exit;
    end;
    tdtAlarm: begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrendAlarm then
        exit;
    end;
    tdtFault: begin
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrendFault then
        exit;
    end;
  end;

  k := iPlot1.AddChannel;

  case ACheckTrendType of //기존 display시에는 중복 방지하기 위함
    tdtValue: begin
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrend := True;
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendChannelIndex := k;
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].PlotXValue := 0;
      NextGrid1.Cell[1, AParamIndex].AsInteger := 1;

      j := iPlot1.AddYAxis;
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendYAxisIndex := j;
      iPlot1.YAxis[j].Name := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TagName;
      iPlot1.YAxis[j].ScaleLinesColor := iPlot1.Channel[k].Color;
      iPlot1.YAxis[j].LabelsFont.Color := iPlot1.Channel[k].Color;
      iPlot1.YAxis[j].Min := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].YAxesMinValue;
      iPlot1.YAxis[j].Span := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].YAxesSpanValue;
      iPlot1.Channel[k].YAxisName := iPlot1.YAxis[j].Name;
      iPlot1.Channel[k].TitleText := iPlot1.YAxis[j].Name;
      iPlot1.Channel[k].Name := 'C_'+ iPlot1.YAxis[j].Name;
      iPlot1.YAxis[j].Title := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].Description;
      iPlot1.YAxis[j].Name := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TagName;
    end;
    tdtAlarm: begin
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrendAlarm := True;
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendAlarmIndex := k;
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].PlotXValue := 0;
      i := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendYAxisIndex;
      iPlot1.Channel[k].YAxisName := iPlot1.YAxis[i].Name;
      iPlot1.Channel[k].TitleText := iPlot1.YAxis[i].Name + '''s Alarm';
      iPlot1.Channel[k].Name := 'C_'+ iPlot1.YAxis[i].Name + '_Alarm';
    end;
    tdtFault: begin
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplayTrendFault := True;
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendFaultIndex := k;
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].PlotXValue := 0;
      i := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].TrendYAxisIndex;
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
  LStr := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].TagName;
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
  LStr := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].TagName;
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

  if NextGrid1.SelectedCount <> 2 then
  begin
    ShowMessage('XY Graph needs only 2 items!' + #13#10 +
      'But you have selected ' + IntToStr(NextGrid1.SelectedCount) + ' items.');
    Result := False;
    exit;
  end;

  LArray := DArray.Create;
  try
    if PrepareXYGraph(LArray, AIsChClear) then
    begin
      for j := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].UseXYGraphConstant := False;
      end;

      it := LArray.start;
      LXYInfo := GetObject(it) as TXYGraphInfo;
      LStr := LXYInfo.FTagname;
      i := LXYInfo.FParameterIndex;
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].UseXYGraphConstant := LXYInfo.FUseConstant;

      advance(it);
      LXYInfo := GetObject(it) as TXYGraphInfo;

      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[LXYInfo.FParameterIndex].UseXYGraphConstant := LXYInfo.FUseConstant;

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
var
  i,j: integer;
  Lstr, LStr2: string;
  LStrList, LtmpList: TStringList;
  LEP_DragDrop: TEngineParameterItemRecord;
begin
  with TCopyWatchListF.Create(nil) do
  begin
    NextGrid1.SaveToTextFile(TEMPFILENAME);
    SelectGrid.LoadFromTextFile(TEMPFILENAME);

    Sel4XYGraphPanel.Visible := False;
    FormulaPanel.Visible := True;

    SelectGrid.Columns.Item[0].Visible := False;
    SelectGrid.Columns.Item[1].Visible := False;
    SelectGrid.Columns.Item[4].Visible := False;
    SelectGrid.Columns.Item[5].Visible := False;
    SelectGrid.Columns.Item[6].Visible := False;
    SelectGrid.Columns.Item[7].Visible := False;

    SelectGrid.Options := SelectGrid.Options - [goMultiSelect];

    for i := 0 to SelectGrid.RowCount - 1 do
      SelectGrid.Cell[3,i].AsString :=
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName;

    while True do
    begin
      if ShowModal = mrOK then
      begin
        LStrList:= TStringList.Create;
        LtmpList := TStringList.Create;;
        //CalcExpress1.Formula := ExprEdt.Text;
        CalcExpress1.Variables.Assign(LtmpList);
        CalcExpress1.init(ExprEdt.Text,True);//make variable list from the formula

        for i := 0 to NextGrid1.RowCount - 1 do
        begin
          LStr := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName;
          //if Pos(LStr, ExprEdt.Text) > 0 then
          //begin
            //LStrList.Add(LStr + '=' + IntToStr(i));

          j := CalcExpress1.Variables.IndexOf(LStr);
          if j > -1 then
            LStrList.Add(LStr + '=' + IntToStr(i));
        end;
        FreeAndNil(LtmpList);

        j := NextGrid1.AddRow();
        NextGrid1.Cell[0, j].AsInteger := -1;
        NextGrid1.Cell[1, j].AsInteger := -1;
        NextGrid1.Cell[5, j].AsInteger := -1;
        NextGrid1.Cell[6, j].AsInteger := -1;
        NextGrid1.CellByName['ItemName',j].AsString := ExprEdt.Text;
        NextGrid1.Row[j].Data := LStrList;
        FCompoundItemList.add([j]);
        LEP_DragDrop.FTagName := CalcExpress1.GetVarFromFormula;
        LEP_DragDrop.FDescription := ExprEdt.Text;
        TFrameIPCMonitorAll1.MoveEngineParameterItemRecord(LEP_DragDrop);
        i := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1;
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FormulaValueList :=
          LStrList.Text;
        if FCalculatedItemTimerHandle = -1 then
          FCalculatedItemTimerHandle := FPJHTimerPool.Add(OnDisplayCalculatedItemValue,1000);
        break;
      end
      else
        break;
    end;
  end;//with
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
  if NextGrid1.SelectedCount > 0 then
  begin
    SetCurrentDir(FFilePath);
    LProcessId := ExecNewProcess2(ACommand);
    LHandle := DSiGetProcessWindow(LProcessId);
    SetLength(FWatchHandles, Length(FWatchHandles)+1);
    FWatchHandles[High(FWatchHandles)] := LHandle;

    if Pos('SIMPLE', ACommand) > 0 then
    begin
      i := NextGrid1.SelectedRow;
      MoveEngineParameterItemRecord2(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i]);
      FEngineParameterItemRecord.FIsDisplaySimple := True;
      SendEPCopyData(LHandle,FEngineParameterItemRecord);
    end
    else
    if Pos('DISPLAYTREND', ACommand) > 0 then
    begin
      for i := 0 to NextGrid1.RowCount - 1 do
      begin
        if NextGrid1.Row[i].Selected then
        begin
          MoveEngineParameterItemRecord2(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i]);
          FEngineParameterItemRecord.FIsDisplayTrend := True;
          SendEPCopyData(LHandle,FEngineParameterItemRecord);
        end;
      end;
    end;
  end;
end;

procedure TWatchF2.AddToSimple(AParamIndex: integer);
begin
  Label1.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].Description;
  Label3.Caption := Label1.Caption;

  if FCurrentEPIndex4Watch > -1 then
    FPrevEPIndex4Watch := FCurrentEPIndex4Watch;

  FCurrentEPIndex4Watch := AParamIndex;
  if FPrevEPIndex4Watch > -1 then
  begin
    NextGrid1.Cell[0, FPrevEPIndex4Watch].AsInteger := -1;
    TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[FPrevEPIndex4Watch].IsDisplaySimple := False;
  end;

  NextGrid1.Cell[0, AParamIndex].AsInteger := 1;
  TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIndex].IsDisplaySimple := True;

  if FCurrentEPIndex4Watch <> FPrevEPIndex4Watch then
  begin
    //FWatchCA.Size := 0;
    //FWatchCA.Size := FConfigOption.AverageSize;
    FWatchCA.ClearBuffer;
  end;
end;

procedure TWatchF2.AddToSimple3Click(Sender: TObject);
begin
  AddToSimple(NextGrid1.SelectedRow);
end;

procedure TWatchF2.AddToSimpleInNewWindow1Click(Sender: TObject);
var
  LCommand: string;
begin
  if NextGrid1.SelectedCount > 1 then
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
  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if NextGrid1.Row[i].Selected then
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

  if NextGrid1.SelectedCount <> 2 then
  begin
    ShowMessage('XY Graph needs only 2 items!' + #13#10 +
      'But you have selected ' + IntToStr(NextGrid1.SelectedCount) + ' items.');
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

//popup menu item등을 current user level에 맞게 disable 시킴
procedure TWatchF2.AdjustComponentByUserLevel;
begin
;
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
  if NextGrid1.SelectedCount <> 2 then
  begin
    ShowMessage('XY Graph needs only 2 items!' + #13#10 +
      'But you have selected ' + IntToStr(NextGrid1.SelectedCount) + ' items.');
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
  if NextGrid1.SelectedCount <> 2 then
  begin
    ShowMessage('XY Graph needs only 2 items!' + #13#10 +
      'But you have selected ' + IntToStr(NextGrid1.SelectedCount) + ' items.');
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

procedure TWatchF2.AppendEngineParameterFromFile(AFileName: string);
var
  LEngineParam: TEngineParameter;
  AEPItemRecord: TEngineParameterItem;
  i: integer;
begin
  LEngineParam := TEngineParameter.Create(nil);
  try
    LEngineParam.LoadFromFile(AFileName);

    TFrameIPCMonitorAll1.FEngineParameter.ExeName := LEngineParam.ExeName;
    TFrameIPCMonitorAll1.FEngineParameter.FilePath := LEngineParam.FilePath;
    TFrameIPCMonitorAll1.FEngineParameter.FormWidth := LEngineParam.FormWidth;
    TFrameIPCMonitorAll1.FEngineParameter.FormHeight := LEngineParam.FormHeight;
    TFrameIPCMonitorAll1.FEngineParameter.FormTop := LEngineParam.FormTop;
    TFrameIPCMonitorAll1.FEngineParameter.FormLeft := LEngineParam.FormLeft;
    TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := LEngineParam.AllowUserLevelWatchList;

    for i := 0 to LEngineParam.EngineParameterCollect.Count - 1 do
    begin
      AEPItemRecord := LEngineParam.EngineParameterCollect.Items[i];
      if CheckExistTagName(AEPItemRecord.ParameterSource,AEPItemRecord.TagName) = -1 then
      begin //동일한 태그가 존재하지 않으면 추가
        with TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Add do
        begin
          LevelIndex := AEPItemRecord.LevelIndex;
          NodeIndex := AEPItemRecord.NodeIndex;
          AbsoluteIndex := AEPItemRecord.AbsoluteIndex;
          MaxValue := AEPItemRecord.MaxValue;
          MaxValue_real := AEPItemRecord.MaxValue_real;
          Contact := AEPItemRecord.Contact;

          SharedName := AEPItemRecord.SharedName;
          TagName := AEPItemRecord.Tagname;
          Description := AEPItemRecord.Description;
          Address := AEPItemRecord.Address;
          FCode := AEPItemRecord.FCode;
          FFUnit := AEPItemRecord.FFUnit;
          MinMaxType := AEPItemRecord.MinMaxType;
          Alarm := AEPItemRecord.Alarm;
          RadixPosition := AEPItemRecord.RadixPosition;

          SensorType := AEPItemRecord.SensorType;
          ParameterCatetory := AEPItemRecord.ParameterCatetory;
          ParameterType := AEPItemRecord.ParameterType;
          ParameterSource := AEPItemRecord.ParameterSource;

          MinAlarmEnable := AEPItemRecord.MinAlarmEnable;
          MaxAlarmEnable := AEPItemRecord.MaxAlarmEnable;
          MinFaultEnable := AEPItemRecord.MinFaultEnable;
          MaxFaultEnable := AEPItemRecord.MaxFaultEnable;

          MinAlarmValue := AEPItemRecord.MinAlarmValue;
          MaxAlarmValue := AEPItemRecord.MaxAlarmValue;
          MinFaultValue := AEPItemRecord.MinFaultValue;
          MaxFaultValue := AEPItemRecord.MaxFaultValue;

          MinAlarmColor := AEPItemRecord.MinAlarmColor;
          MaxAlarmColor := AEPItemRecord.MaxAlarmColor;
          MinFaultColor := AEPItemRecord.MinFaultColor;
          MaxFaultColor := AEPItemRecord.MaxFaultColor;

          MinAlarmBlink := AEPItemRecord.MinAlarmBlink;
          MaxAlarmBlink := AEPItemRecord.MaxAlarmBlink;
          MinFaultBlink := AEPItemRecord.MinFaultBlink;
          MaxFaultBlink := AEPItemRecord.MaxFaultBlink;

          MinAlarmSoundEnable := AEPItemRecord.MinAlarmSoundEnable;
          MaxAlarmSoundEnable := AEPItemRecord.MaxAlarmSoundEnable;
          MinFaultSoundEnable := AEPItemRecord.MinFaultSoundEnable;
          MaxFaultSoundEnable := AEPItemRecord.MaxFaultSoundEnable;

          MinAlarmSoundFilename := AEPItemRecord.MinAlarmSoundFilename;
          MaxAlarmSoundFilename := AEPItemRecord.MaxAlarmSoundFilename;
          MinFaultSoundFilename := AEPItemRecord.MinFaultSoundFilename;
          MaxFaultSoundFilename := AEPItemRecord.MaxFaultSoundFilename;

          IsDisplayTrend := AEPItemRecord.IsDisplayTrend;
          IsDisplayTrendAlarm := AEPItemRecord.IsDisplayTrendAlarm;
          IsDisplayTrendFault := AEPItemRecord.IsDisplayTrendFault;
          TrendChannelIndex := AEPItemRecord.TrendChannelIndex;
          PlotXValue := AEPItemRecord.PlotXValue;
          MinValue := AEPItemRecord.MinValue;
          MinValue_Real := AEPItemRecord.MinValue_Real;
        end;//with
      end;
    end;
  finally
    LEngineParam.Free;
  end;
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

procedure TWatchF2.ApplyOption;
var
  i: integer;
begin
  if FCurrentModbusFileName <> FConfigOption.ModbusFileName then
  begin
    if FileExists(FConfigOption.ModbusFileName) then
    begin
      TFrameIPCMonitorAll1.SetModbusMapFileName(FConfigOption.ModbusFileName, psECS_AVAT);
    end;
  end;

  AvgPanel.Visible := FConfigOption.ViewAvgValue;

  Label1.Font.Size := FConfigOption.NameFontSize;
  WatchLabel.Font.Size := FConfigOption.ValueFontSize;

  for i := 0 to iPlot1.ChannelCount - 1 do
    iPlot1.Channel[i].RingBufferSize := FConfigOption.RingBufferSize;
end;

procedure TWatchF2.FormShow(Sender: TObject);
begin
  Label1.Caption := FLabelName;
  Label3.Caption := FLabelName;
  Self.Caption := Self.Caption + FLabelName;
end;

procedure TWatchF2.FreeStrListFromGrid(AIndex: integer = -1);
var
  it: DIterator;
  i: integer;
begin
  it := FCompoundItemList.start;
  while iterateOver(it) do
  begin
    i := GetInteger(it);

    if AIndex = -1 then //모든 List Free(OnDestroy시에)
    begin
      TStringList(NextGrid1.Row[i].Data).Free;
    end
    else //DeleteItem선택시에 실행됨
    begin
      if AIndex = i then
      begin
        FCompoundItemList.removeAt(i);
        TStringList(NextGrid1.Row[i].Data).Free;
      end;
    end;
  end;
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

  if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend then
  begin
    if LXYInfo.FAxis = aX then
    begin
      ChannelX := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
      LStr := LXYInfo.FTagname;
    end
    else
    begin
      ChannelY := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TrendChannelIndex;
      LStr2 := LXYInfo.FTagname;
    end;
  end;

  advance(it);
  LXYInfo := GetObject(it) as TXYGraphInfo;
  j := LXYInfo.FParameterIndex;

  if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].IsDisplayTrend then
  begin
    if LXYInfo.FAxis = aX then
    begin
      ChannelX := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].TrendChannelIndex;
      LStr := LXYInfo.FTagname + ';' + LStr2;
    end
    else
    begin
      ChannelY := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[j].TrendChannelIndex;
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

//AAutoStart: True = 프로그램 시작시에 watch file name을 parameter로 입력받는 경우
//            False = LoadFromFile 메뉴로 실행되는 경우
procedure TWatchF2.GetEngineParameterFromSavedWatchListFile(AAutoStart: Boolean);
var
  i,j,k: integer;
  LStr: string;
  LUserLevel: THiMECSUserLevel;
  LStrList: TStringList;
begin
  if FileExists(WatchListPath+FWatchListFileName) then
  begin
    LStr := TFrameIPCMonitorAll1.CheckExeFileNameForWatchListFile(FWatchListFileName);
    if LStr <> '' then
    begin
      LStr := ''''+FWatchListFileName + ''' file should be opend by ''' + LStr + '''';
      ShowMessage(LStr);
      exit;
    end;

    LUserLevel := TFrameIPCMonitorAll1.FCurrentUserLevel;
    if not TFrameIPCMonitorAll1.CheckUserLevelForWatchListFile(WatchListPath+FWatchListFileName, LUserLevel) then
    begin
      if AAutoStart then
        halt(0)
      else
      begin
        LStr := 'It is not match the user level.'+#13#10+'CurrentUserLevel = ';
        LStr := LStr + UserLevel2String(TFrameIPCMonitorAll1.FCurrentUserLevel) + #13#10+ 'Allow User Level = ';
        LStr := LStr + UserLevel2String(LUserLevel);//TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList);
        ShowMessage(LStr);
        exit;
      end;
    end;

    if NextGrid1.RowCount > 0 then
    begin
      if MessageDlg('Do you want to apppend the watch list to the grid?',
                                mtConfirmation, [mbYes, mbNo], 0)= mrYes then
      begin
        AppendEngineParameterFromFile(WatchListPath+FWatchListFileName);
      end
      else
      begin
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
        TFrameIPCMonitorAll1.FEngineParameter.LoadFromFile_Thread(Application, WatchListPath+FWatchListFileName);
      end;

      NextGrid1.ClearRows;
      iPlot1.RemoveAllChannels;
      iPlot1.RemoveAllYAxes;
    end
    else
      TFrameIPCMonitorAll1.FEngineParameter.LoadFromFile_Thread(Application, WatchListPath+FWatchListFileName);

    //Administrator이상의 권한자 만이 Save user level 조정 가능함
    if TFrameIPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator then
    begin
      AllowUserlevelCB.Enabled := True;
    end;

    AllowUserlevelCB.Text := UserLevel2String(TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList);

    if AllowUserlevelCB.Text = '' then
      AllowUserlevelCB.Text := UserLevel2String(TFrameIPCMonitorAll1.FCurrentUserLevel);

    Width := TFrameIPCMonitorAll1.FEngineParameter.FormWidth;
    Height := TFrameIPCMonitorAll1.FEngineParameter.FormHeight;
    Top := TFrameIPCMonitorAll1.FEngineParameter.FormTop;
    Left := TFrameIPCMonitorAll1.FEngineParameter.FormLeft;
    WindowState := TWindowState(TFrameIPCMonitorAll1.FEngineParameter.FormState);

    for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      MoveEngineParameterItemRecord2(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i]);

      case TParameterSource(FEngineParameterItemRecord.FParameterSource) of
        psECS_kumo: TFrameIPCMonitorAll1.CreateECSkumoIPCMonitor(FEngineParameterItemRecord);
        psECS_AVAT: TFrameIPCMonitorAll1.CreateECSAVATIPCMonitor(FEngineParameterItemRecord);
        psMT210: TFrameIPCMonitorAll1.CreateMT210IPCMonitor(FEngineParameterItemRecord);
        psMEXA7000: TFrameIPCMonitorAll1.CreateMEXA7000IPCMonitor(FEngineParameterItemRecord);
        psLBX: TFrameIPCMonitorAll1.CreateLBXIPCMonitor(FEngineParameterItemRecord);
        psFlowMeter: TFrameIPCMonitorAll1.CreateFlowMeterIPCMonitor(FEngineParameterItemRecord);
        psWT1600: TFrameIPCMonitorAll1.CreateWT1600IPCMonitor(FEngineParameterItemRecord);
        psDynamo: TFrameIPCMonitorAll1.CreateDynamoIPCMonitor(FEngineParameterItemRecord);
        psGasCalculated: TFrameIPCMonitorAll1.CreateGasCalcIPCMonitor(FEngineParameterItemRecord);
      end; //case

      j := NextGrid1.AddRow();

      NextGrid1.Cell[0, j].AsInteger := -1;
      NextGrid1.Cell[1, j].AsInteger := -1;
      NextGrid1.Cell[5, j].AsInteger := -1;
      NextGrid1.Cell[6, j].AsInteger := -1;
      NextGrid1.CellsByName['ItemName', j] := FEngineParameterItemRecord.FDescription;
      NextGrid1.CellsByName['FUnit', j] := FEngineParameterItemRecord.FUnit;

      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FormulaValueList <> '' then
      begin
        LStr := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FormulaValueList;
        NextGrid1.CellByName['ItemName',j].AsString := LStr;

        LStrList := TStringList.Create;
        LStrList.Text := LStr;
        NextGrid1.Row[j].Data := LStrList;
        FCompoundItemList.add([j]);
      end;

      if FEngineParameterItemRecord.FIsDisplayTrend then
      begin
        //NextGrid1.Selected[j] := True;
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsDisplayTrend := False;
        AddChannelAndYAxis(i, tdtValue);
      end;

      if FEngineParameterItemRecord.FIsDisplaySimple then
      begin
        AddToSimple(i);
      end;
    end; //for

    SaveListCB.Checked := True;

  end;
end;

procedure TWatchF2.GetFields2Grid(ADb: TSivak3Database; ATableName: String;
  AGrid: TNextGrid);
var
  LnxTextColumn: TnxTextColumn;
  LnxIncColumn: TnxIncrementColumn;
  LStrList: TStringList;
  Li: integer;
begin
  LStrList := TStringList.Create;
  try
    ADb.GetFieldNames(LStrList, ATableName);

    if LStrList.Count > 0 then
    begin
      with AGrid do
      begin
        ClearRows;
        Columns.Clear;
        //Columns.Add(TnxIncrementColumn,'No.');
      end;
    end;

    LnxIncColumn := TnxIncrementColumn(AGrid.Columns.Add(TnxIncrementColumn, 'No'));
    LnxIncColumn.Name := 'No';
    LnxIncColumn.Header.Alignment := taCenter;
    LnxIncColumn.Sorted := True;
    LnxIncColumn.SortKind := skDescending;
    LnxIncColumn.SortType := stNumeric;

    for Li := 0 to LStrList.Count - 1 do
    begin
      with AGrid do
      begin
        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn, LStrList[Li]));
        LnxTextColumn.Name := LStrList[Li];
        LnxTextColumn.Header.Alignment := taCenter;
        LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
      end;
    end;
  finally
    LStrList.Free;
  end;
end;

function TWatchF2.GetPeriodDataFromTrend(AIndex, Ai, Aj: integer; ADataType: TPeriodDataType): double;
var
  i: integer;
  LCA: TCircularArray;
begin
  if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AIndex].UseXYGraphConstant then
  begin
    Result := StrToFloatDef(ConstantEdit.Text, 0.0);
    exit;
  end;

  LCA := TCircularArray.Create(Aj-Ai+1);
  try
    AIndex := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AIndex].TrendChannelIndex;
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

  for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if ADescriptor = TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description then
    begin
      Result := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName;
      exit;
    end;
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





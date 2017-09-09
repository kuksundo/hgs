unit HiMECS_WatchSave;
{
  - 2011.11.30
  1) watch list file name 변경: x xxxxxxxxxxx x
                                -             -
                                실행프로그램  User Level
    실행프로그램: 1: HiMECS_Watch2p.exe
                  2: HiMECS_WatchSavep.exe
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,SyncObjs, iniFiles,  NxCells,
  DeCAL, Menus, iLedBar, ShadowButton, Clipbrd,
  DragDrop,
  DropTarget,
  DragDropFormats,
  DragDropText,
  WatchSaveConfig, CircularArray, WatchSaveConst, IPCThrd_LBX, IPCThrdMonitor_LBX,
  IPCThrd_WT1600, IPCThrdMonitor_WT1600, IPCThrd_ECS_kumo, IPCThrdMonitor_ECS_kumo,
  IPCThrd_MEXA7000, IPCThrdMonitor_MEXA7000, IPCThrd_MT210, IPCThrdMonitor_MT210,
  IPCThrd_FlowMeter, IPCThrdMonitor_FlowMeter, IPCThrd_DYNAMO, IPCThrdMonitor_DYNAMO,
  IPCThrd_GasCalc, IPCThrdMonitor_GasCalc,
  ModbusComStruct, WatchSaveConfigOptionClass, DragDropRecord, HiMECSConst, AdvTrackBar,
  TimerPool, EngineParameterClass, NxScrollControl, NxCustomGridControl,//SBPro,
  NxCustomGrid, NxGrid, NxColumns, NxColumnClasses, ImgList, JvDialogs,
  Mask, JvExMask, JvToolEdit, JvExComCtrls, GpCommandLineParser,//DataSave2FileThread,
  JvStatusBar, JclDebug, UnitEngParamConfig, DataSaveAll_Const,
  UnitFrameIPCMonitorAll, NxEdit, StopWatch, LocalSheet_Unit, CalcExpress,
  AdvOfficePager, UnitFrameDataSaveAll, UnitFrameWatchGrid, UnitParameterManager,
  UnitSTOMPClass, UnitWorker4OmniMsgQ, UnitMQConst,
  AdvMenus, AdvGlowButton, AdvToolBar, DataSave2FileOmniThread, OtlCommon
  ;

const
  TEMPFILENAME = 'c:\pjhtemp';
  FILESAVE_MSG_RESULT = WM_USER + 1001;

type
  TDisplayTarget = (dtSendMemo, dtStatusBar);

  TEventData_MEXA7000_2 = packed record
    CO2: Double;
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

  TWatchSaveF = class(TForm)
    Panel2: TPanel;
    JvStatusBar1: TJvStatusBar;
    SaveListCB: TCheckBox;
    AllowUserlevelCB: TComboBox;
    StayOnTopCB: TCheckBox;
    EnableAlphaCB: TCheckBox;
    AlphaTrackBar: TAdvTrackBar;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    PopupMenu3: TPopupMenu;
    SelectAvg1: TMenuItem;
    DeselectAvg1: TMenuItem;
    N2: TMenuItem;
    LoadWatchListFromFile1: TMenuItem;
    Savesa1: TMenuItem;
    N3: TMenuItem;
    DeleteItem1: TMenuItem;
    N4: TMenuItem;
    Properties1: TMenuItem;
    ImageList1: TImageList;
    JvSaveDialog1: TJvSaveDialog;
    JvOpenDialog1: TJvOpenDialog;
    ResetSelect1: TMenuItem;
    Items1: TMenuItem;
    N5: TMenuItem;
    AddtoCalculated1: TMenuItem;
    PageControl1: TAdvOfficePager;
    ItemsTabSheet: TAdvOfficePage;
    AvgModePanel: TPanel;
    Label8: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    StartAvgButton: TButton;
    StopAvgButton: TButton;
    JvFilenameEdit1: TJvFilenameEdit;
    interval2: TEdit;
    CancelAvgBtn: TButton;
    Button2: TButton;
    TestCntEdit: TNxNumberEdit;
    ElapsedTimeEdit: TNxEdit;
    Save2CsvBtn: TButton;
    Button3: TButton;
    PopupMenu4: TPopupMenu;
    Copyonlyexistingitems1: TMenuItem;
    Copynonexistingitems1: TMenuItem;
    FWG: TFrameWatchGrid;
    TFrameIPCMonitorAll1: TFrameIPCMonitor;
    AvgModeCB: TCheckBox;
    ClearExcelRange1: TMenuItem;
    AdvPopupMenu1: TAdvPopupMenu;
    CreateReportWithExcelRange1: TMenuItem;
    AdvGlowMenuButton1: TAdvGlowMenuButton;
    CreateReportWithCSVFile1: TMenuItem;
    AdvOfficePage1: TAdvOfficePage;
    MsgWindowMemo: TMemo;
    N6: TMenuItem;
    LoadItemsFromFile1: TMenuItem;
    CsvFileSaveCB: TCheckBox;
    ChangeSheetNameforExcelRange1: TMenuItem;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure AlphaTrackBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Close1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EnableAlphaCBClick(Sender: TObject);
    procedure CB_ActiveClick(Sender: TObject);
    procedure StartAvgButtonClick(Sender: TObject);
    procedure AvgModeCBClick(Sender: TObject);
    procedure StopAvgButtonClick(Sender: TObject);
    procedure LoadWatchListFromFile1Click(Sender: TObject);
    procedure StayOnTopCBClick(Sender: TObject);
    procedure Savesa1Click(Sender: TObject);
    procedure SelectAvg1Click(Sender: TObject);
    procedure DeselectAvg1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure JvStatusBar1Click(Sender: TObject);
    procedure ExcelRangeButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ResetSelect1Click(Sender: TObject);
    procedure Save2CsvBtnClick(Sender: TObject);
    procedure CancelAvgBtnClick(Sender: TObject);
    procedure AddtoCalculated1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Copyonlyexistingitems1Click(Sender: TObject);
    procedure Copynonexistingitems1Click(Sender: TObject);
    procedure DeleteItem1Click(Sender: TObject);
    procedure JvFilenameEdit1BeforeDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure FWGExcelRangeButtonClick(Sender: TObject);
    procedure ClearExcelRange1Click(Sender: TObject);
    procedure CreateReportWithExcelRange1Click(Sender: TObject);
    procedure CreateReportWithCSVFile1Click(Sender: TObject);
    procedure LoadItemsFromFile1Click(Sender: TObject);
    procedure CsvFileSaveCBClick(Sender: TObject);
    procedure ChangeSheetNameforExcelRange1Click(Sender: TObject);
  private
    FFilePath: string;      //파일을 저장할 경로
    //FCurrentUserLevel: THiMECSUserLevel;

    FCriticalSection: TCriticalSection;
    FPJHTimerPool: TPJHTimerPool;
    FCalculatedItemTimerHandle: integer; //Calculated Item display용 Timer Handle
    FFileSaveTimerHandle: integer;

    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FFirst: Boolean; //타이머 동작 완료하면 True

    FEngineParameterItemRecord: TEngineParameterItemRecord; //Main폼으로 부터 파라미터 수신용
    FTempParamItemRecord: TEngineParameterItemRecord;
    //FEngineParameter: TEngineParameter;

    //===== Data Save
//    FDataSave2FileThread: TDataSave2FileThread;//파일에 데이타 저장하는 객체
    FFileName_Convention: TFileName_Convetion;//파일에 저장시에 파일이름부여 방법
    FSaveDataBuf: string; //파일에 저장할 데이타를 저장하는 버퍼
    FCSVHeader: string;
    FLogStart: Boolean;  //Log save Start sig.
    FSaveFileName: string; //데이타를 저장할 File 이름(설정에 따라 변경됨)
    FOldSaveFileName: string;//테스트 건수를 증가 시키기 위해 이전 파일이름 저장함.
    FSaveFileName2, FSaveFileExt: string;
    FFileIndex : integer; //파일이름 뒤에 붙일 순서번호
    FLineCount: integer;

    FSaveDBDataBuf: string;
    FAppendStr: string;

    FMousePoint: TPoint;
    FDragCopyMode: TParamDragCopyMode; //Multi Drag 시에 Popup Menu에서 선택한 값이 저장 됨
    FMultiDragOn: integer; //Multi Drag 시작 시 = 1, 진행중 = 2, Drag 완료 = 0
    FPM: TParameterManager;
    FpjhSTOMPClass: TpjhSTOMPClass;
    FCommandLine: TWatchSaveCommandLineOption;
    FFileSaveOmniThread: TDataSave2FileOmniThread;

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;

    procedure ProcessResults;
    //=====
    procedure OnTrigger4AvgSaveTimeDisplay(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnAvgCalc(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnAvgSave(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure DeleteEngineParamterFromGrid(AIndex: integer);
    function CommandLineParse(var AErrMsg: string): boolean;
    procedure GetEngineParameterFromSavedWatchListFile(AAutoStart: Boolean;
              AFileName: string = '');
    procedure ClearAllExcelRange;
    procedure CreateReportWithCSVFile;
    procedure CreateReportWithExcelRange(AXlFileName: string);
    procedure GetExcelInfoFromGrid(out AExcelInfoCollect: TExcelInfoCollect<TExcelInfoItem>);
    procedure DisplayMessage(msg: string; ADspNo: Integer=1);
  public
    //FOnExit: Boolean; //프로그램 종료시 True
    FOwnerListIndex: integer;//TList에 저장되는 Index(해제시에 필요함)

    FConfigOption: TWatchSaveConfigOption;
    FStopWatch: TStopWatch;

    //Option변경시에 파일이름이 같을 경우 Readmap을 하지 않기 위해 필요함
    FCurrentModbusFileName: string;
//    FWatchListFileName: string;//실행시 파라미터로 입력 받음(파라미터 저장파일)

    FLocalSheet_Frm: TLocalSheet_Frm;
    FIsAverageFinish: Boolean;//Start Average 누른 후 Stop Average 누르면 True;

    FIsSaveToCSVCurData: Boolean; //테스트 건수 증가시 저장된 데이터만 증가하기 위함
    //생성할 보고서 파일 이름(Excel Range 설정시 사용한 파일)
    //SetCellPos 프로그램으로 부터 Clipboard로 파일 이름 가져옴
    FReportFileName: string;
    FToggleBackground: Boolean;

    procedure InitVar;
    procedure InitSTOMP;
    procedure DestroySTOMP;

    procedure DisplayMessage2SB(Msg: string);
    procedure DataSaveByEvent;

    procedure ApplyAvgSize;
    procedure ApplyOption;
    procedure ApplyCommandLineOption;

    procedure SaveWatchList(AFileName: string; ASaveWatchListFolder: Boolean = True);

    procedure StartAvgCalc;
    function StopAvgCalc: Boolean;
    function SaveAvg2File(AFilename: string): Boolean;
    procedure ResetAvgCalc;

    procedure CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord; ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist);

    procedure LoadConfigDataJson2Var(AFileName: string = '');
    procedure LoadConfigDataVar2Form(AMonitorConfigF : TWatchSaveConfigF);
    procedure SaveConfigDataForm2Json(AMonitorConfigF : TWatchSaveConfigF);
    procedure SetConfigData;

    procedure IPCAll_Final;

    procedure CreateLocalSheet_Frm;
    procedure LoadLocalDataFromSheet;

    procedure SetVisible4WatchSave;
  end;

var
  WatchSaveF: TWatchSaveF;

implementation

uses CommonUtil, UnitTestReport, UnitCopyWatchList2, HiMECSWatchCommon,
  CopyData, UnitCopyModeMenu, otlComm, UnitCaptionInput;

{$R *.dfm}

procedure TWatchSaveF.InitSTOMP;
var
  i: integer;
  LStrList: TStringList;
begin
  DestroySTOMP;

  if FConfigOption.MQServerTopic = '' then
    FConfigOption.MQServerTopic := TFrameIPCMonitorAll1.GetEngineName;//'UniqueEngineName';

  if FConfigOption.MQServerTopic = '' then
    FConfigOption.MQServerTopic := MQ_DEFAULT_Q_NAME;

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

procedure TWatchSaveF.InitVar;
var
  LStr: string;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  SetCurrentDir(FFilePath);
  FCriticalSection := TCriticalSection.Create;
  FConfigOption := TWatchSaveConfigOption.Create(nil);
  FCommandLine := TWatchSaveCommandLineOption.Create;
  FFileSaveOmniThread := TDataSave2FileOmniThread.Create;

  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FStopWatch := TStopWatch.Create(False);

  //TFrameIPCMonitorAll1.InitVar; ==> Frame OnCreate서 실행됨
  TFrameIPCMonitorAll1.FNextGrid := FWG.NextGrid1;
  TFrameIPCMonitorAll1.FPageControl := PageControl1;

  SetVisible4WatchSave;
  //TFrameIPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;

  FPM := TParameterManager.Create;

  FWG.FCalculatedItemTimerHandle := -1;
  FWG.SetIPCMonitorAll(TFrameIPCMonitorAll1);
  FWG.SetStatusBar(JvStatusBar1);
  FWG.SetMainFormHandle(Handle);
  FWG.SetDeleteEngineParamterFromGrid(DeleteEngineParamterFromGrid);
  FWG.NextGrid1.Color := $00C0FEEF;

  FMonitorStart := False;
  FFirst := True;

  FpjhSTOMPClass := nil;
  CommandLineParse(LStr);
  LoadConfigDataJson2Var(FCommandLine.ConfigFileName);
  ApplyOption;
  ApplyCommandLineOption; //Config file load 후 실행해야 Command line option이 적용 됨

  if FConfigOption.WatchListFileName <> '' then
  begin
    GetEngineParameterFromSavedWatchListFile(True);
  end;

  FLineCount := 0;
  FFileIndex := 0;
  FLocalSheet_Frm := nil;
  FFileSaveTimerHandle := -1;
end;

procedure TWatchSaveF.IPCAll_Final;
begin
  TFrameIPCMonitorAll1.DestroyIPCMonitorAll;
end;

procedure TWatchSaveF.JvFilenameEdit1BeforeDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  JvFilenameEdit1.InitialDir := FFilePath;
end;

procedure TWatchSaveF.JvStatusBar1Click(Sender: TObject);
begin
  JvStatusBar1.SimplePanel := not JvStatusBar1.SimplePanel;
end;

procedure TWatchSaveF.LoadConfigDataVar2Form(AMonitorConfigF: TWatchSaveConfigF);
var
  i: integer;
begin
//  AMonitorConfigF.MapFilenameEdit.FileName := FConfigOption.ModbusFileName;
  AMonitorConfigF.MapFilenameEdit.FileName := FConfigOption.WatchListFileName;
  AMonitorConfigF.AvgEdit.Text := IntToStr(FConfigOption.AverageSize);
  AMonitorConfigF.SplitEdit.Text := IntToStr(FConfigOption.SplitCount);

  AMonitorConfigF.IntervalRG.ItemIndex := FConfigOption.SelDisplayInterval;
  AMonitorConfigF.IntervalEdit.Text := IntToStr(FConfigOption.DisplayInterval);
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

  case FConfigOption.SelDisplayInterval of
    0: AMonitorConfigF.IntervalEdit.Enabled := False;
    1: AMonitorConfigF.IntervalEdit.Enabled := True;
  end;

  AMonitorConfigF.InitialCB.Checked := FConfigOption.InitialFileIndex;
  AMonitorConfigF.InitialEdit.Text := IntToStr(FConfigOption.InitialIndex);
end;

procedure TWatchSaveF.LoadItemsFromFile1Click(Sender: TObject);
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
//      ApplyOption4AvgCalc;
    end;
  end;
end;

procedure TWatchSaveF.LoadConfigDataJson2Var(AFileName: string);
begin
  if AFileName = '' then
    AFileName := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);

  if FileExists(AFileName) then
  begin
    FConfigOption.LoadFromJsonFile(AFileName, '', False);
    TFrameIPCMonitorAll1.FModbusMapFileName := FConfigOption.ModbusFileName;
  end;
end;

procedure TWatchSaveF.LoadLocalDataFromSheet;
var
  i,j,k: integer;
  LEngineParameterItem: TEngineParameterItem;
begin
  if not Assigned(FLocalSheet_Frm) then
    exit;

  k := -1;

  with FLocalSheet_Frm do
  begin
    for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Measure_StartTime') then
      begin
        //NextGrid1.CellByName['Value',i].AsFloat := mTime.DateTime;
        //NextGrid1.CellByName['AvgValue',i].AsFloat := mTime.DateTime;
        //k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Total_RunHour') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := runTime.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := runTime.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Ambient_Temp') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := ambTemp.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := ambTemp.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Ambient_Press') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := ambPress.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := ambPress.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Ambient_Humidity') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := ambHumidity.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := ambHumidity.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Before_Comp_Press') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := compPress.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := compPress.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Before_Comp_Temp') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := compTemp.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := compTemp.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('SeaWater_Press') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := seaWater.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := seaWater.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('GRU_inlet_press') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := inlet.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := inlet.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('GRU_Mainchamber_press') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := mChamber.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := mChamber.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('GRU_Prechamber_press') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := pChamber.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := pChamber.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Gas_Volume') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := gVolume.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := gVolume.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Gas_Duration') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := gDuration.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := gDuration.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('Chamber_Internal_Press') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := chamberIn.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := chamberIn.Text;
        k := i;
      end
      else
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
        UpperCase('LO_Level') then
      begin
        FWG.NextGrid1.CellByName['Value',i].AsString := loLevel.Text;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := loLevel.Text;
        k := i;
      end
      else
      begin
        for j := 1 to 9 do
        begin
          if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
            (UpperCase('Pmax_A')+IntToStr(j)) then
          begin
            FWG.NextGrid1.CellByName['Value',i].AsString := AGrid.Cells[j-1,1];
            FWG.NextGrid1.CellByName['AvgValue',i].AsString := AGrid.Cells[j-1,1];
            k := i;
          end
          else
          if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) =
            (UpperCase('Pmax_B')+IntToStr(j)) then
          begin
            FWG.NextGrid1.CellByName['Value',i].AsString := BGrid.Cells[j-1,1];
            FWG.NextGrid1.CellByName['AvgValue',i].AsString := BGrid.Cells[j-1,1];
            k := i;
          end
        end; //for
      end;

      if FWG.NextGrid1.CellByName['Value',i].AsString = '' then
        FWG.NextGrid1.CellByName['Value',i].AsString := '0';

      if k <> -1 then
      begin
        LEngineParameterItem := TEngineParameterItem(FWG.NextGrid1.Row[k].Data);
        TCircularArray(LEngineParameterItem.FPCircularArray).ClearBuffer;
        TCircularArray(LEngineParameterItem.FPCircularArray).Put(FWG.NextGrid1.CellByName['Value',k].AsFloat);
      end;
    end;//for
  end;//with
end;

procedure TWatchSaveF.LoadWatchListFromFile1Click(Sender: TObject);
begin
  SetCurrentDir(FFilePath);
  JvOpenDialog1.InitialDir := WatchListPath;
  JvOpenDialog1.Filter := '*.*';

  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      FConfigOption.WatchListFileName := jvOpenDialog1.FileName;
      GetEngineParameterFromSavedWatchListFile(False);
    end;
  end;

end;

function TWatchSaveF.SaveAvg2File(AFilename: string): Boolean;
begin
  Result := False;
end;

procedure TWatchSaveF.SaveConfigDataForm2Json(AMonitorConfigF: TWatchSaveConfigF);
var
  Lstr: string;
  i: integer;
begin
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);

//  FConfigOption.ModbusFileName := AMonitorConfigF.MapFilenameEdit.FileName;
  FConfigOption.WatchListFileName := AMonitorConfigF.MapFilenameEdit.FileName;
  FCurrentModbusFileName := FConfigOption.ModbusFileName;
  FConfigOption.AverageSize := StrToIntDef(AMonitorConfigF.AvgEdit.Text,1);
  FConfigOption.SplitCount := StrToIntDef(AMonitorConfigF.SplitEdit.Text,1);

  FConfigOption.SelDisplayInterval :=AMonitorConfigF.IntervalRG.ItemIndex;
  FConfigOption.DisplayInterval := StrToIntDef(AMonitorConfigF.IntervalEdit.Text,0);
  FConfigOption.InitialFileIndex := AMonitorConfigF.InitialCB.Checked;
  FConfigOption.InitialIndex := StrToIntDef(AMonitorConfigF.InitialEdit.Text,0);
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

  FConfigOption.SaveToJsonFile(Lstr);
end;

procedure TWatchSaveF.Savesa1Click(Sender: TObject);
begin
//  FWatchListFileName := '';
  SaveWatchList('', False);
end;

procedure TWatchSaveF.SaveWatchList(AFileName: string; ASaveWatchListFolder: Boolean = True);
var
  i, LChCount: integer;
  LStr, LWatchListPath: string;
  LUser, LUser2: THiMECSUserLevel;
  LDeleteFileList : TStringList;
begin
  if ASaveWatchListFolder then
    LWatchListPath := WatchListPath
  else
    LWatchListPath := '';

  //Administrator 이상의 권한만 저장 가능함
  if (TFrameIPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator) and
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

    TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := String2UserLevel(AllowUserlevelCB.Text);
  end
  else
    TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := TFrameIPCMonitorAll1.FCurrentUserLevel;

//  if (TFrameIPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator) and
//      (AllowUserlevelCB.Enabled) and (AllowUserlevelCB.Text <> '') then
//  begin
//    i := Length(FWatchListFileName);
//    LStr := System.Copy(FWatchListFileName,i,1);
//
//    if LStr <> '' then
//    begin
//      LUser := THiMECSUserLevel(StrToInt(LStr));
//      LUser2 := String2UserLevel(AllowUserlevelCB.Text);
//
//      if LUser2 <> LUser then  //ComboBox User Level과 filename의 user level 비교
//      begin
//        if FileExists(WatchListPath+FWatchListFileName) then
//        begin
//          if MessageDlg('ComboBox User and FileName user level are different.'+#13#10+'Change file name to ComboBox User Level?',
//                                      mtConfirmation, [mbYes, mbNo], 0)= mrYes then
//          begin
//            LDeleteFileList := TStringList.Create;
//            try
//              GetFiles(LDeleteFileList, WatchListPath+FWatchListFileName);
//              for i := 0 to LDeleteFileList.Count - 1 do
//                DeleteFile(LDeleteFileList.Strings[i]);
//            finally
//              LDeleteFileList.Free;
//            end;
//
//            //DeleteFile(WatchListPath+AFileName);
//            FWatchListFileName := formatDateTime('yyyymmddhhnnsszz',now)+
//            IntToStr(FConfigOption.EngParamFileFormat) + IntToStr(Ord(LUser2));
//          end;
//        end;
//      end;
//    end;
//
//      TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := String2UserLevel(AllowUserlevelCB.Text);
//  end
//  else
//    TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := TFrameIPCMonitorAll1.FCurrentUserLevel;

  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsAverageValue := FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean;
    TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FFExcelRange := FWG.NextGrid1.CellByName['ExcelRange',i].AsString;
  end;

  TFrameIPCMonitorAll1.FEngineParameter.ExeName := ExtractFileName(Application.ExeName);
  TFrameIPCMonitorAll1.FEngineParameter.FormWidth := Width;
  TFrameIPCMonitorAll1.FEngineParameter.FormHeight := Height;
  TFrameIPCMonitorAll1.FEngineParameter.FormTop := Top;
  TFrameIPCMonitorAll1.FEngineParameter.FormLeft := Left;
  TFrameIPCMonitorAll1.FEngineParameter.FormState := TpjhWindowState(WindowState);

    TFrameIPCMonitorAll1.FEngineParameter.FormWidth := Width;
    TFrameIPCMonitorAll1.FEngineParameter.FormHeight := Height;
    TFrameIPCMonitorAll1.FEngineParameter.FormTop := Top;
    TFrameIPCMonitorAll1.FEngineParameter.FormLeft := Left;
    TFrameIPCMonitorAll1.FEngineParameter.FormState := TpjhWindowState(WindowState);
    TFrameIPCMonitorAll1.FEngineParameter.SaveWatchForm := SaveListCB.Checked;
    TFrameIPCMonitorAll1.FEngineParameter.StayOnTop := StayOnTopCB.Checked;
    TFrameIPCMonitorAll1.FEngineParameter.UseAlphaBlend := EnableAlphaCB.Checked;
    TFrameIPCMonitorAll1.FEngineParameter.AlphaValue := AlphaTrackBar.Position;
    TFrameIPCMonitorAll1.FEngineParameter.TabShow := PageControl1.TabSettings.Height > 0;
    TFrameIPCMonitorAll1.FEngineParameter.BorderShow := BorderStyle <> bsNone;

  SetCurrentDir(FFilePath);
  if not setcurrentdir(WatchListPath) then
    createdir(WatchListPath);
  SetCurrentDir(FFilePath);

  if FConfigOption.WatchListFileName = '' then        //file name 앞에 프로그램명(2) 붙임
    LStr := WatchListPath+formatDateTime('2yyyymmddhhnnsszz',now)+
      IntToStr(FConfigOption.EngParamFileFormat) +
      IntToStr(Ord(TFrameIPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList))
  else
    LStr := LWatchListPath + FConfigOption.WatchListFileName;

  //TFrameIPCMonitorAll1.FEngineParameter.SaveToFile(LStr);
  if FConfigOption.EngParamFileFormat = 0 then //XML format
    TFrameIPCMonitorAll1.FEngineParameter.SaveToFile(LStr,
              ExtractFileName(LStr),FConfigOption.EngParamEncrypt)
  else
  if FConfigOption.EngParamFileFormat = 1 then //JSON format
    TFrameIPCMonitorAll1.FEngineParameter.SaveToJSONFile(LStr,
              ExtractFileName(LStr),FConfigOption.EngParamEncrypt);

  ShowMessage('File saved successfully! => ' + LStr);
end;

procedure TWatchSaveF.SelectAvg1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
    if FWG.NextGrid1.Row[i].Selected then
      FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean := True;
end;

procedure TWatchSaveF.CancelAvgBtnClick(Sender: TObject);
var
  i: integer;
  LEngineParameterItem: TEngineParameterItem;
begin
  FPJHTimerPool.RemoveAll;

  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean then
    begin
      LEngineParameterItem := TEngineParameterItem(FWG.NextGrid1.Row[i].Data);
      if Assigned(LEngineParameterItem.FPCircularArray) then
      begin
        TCircularArray(LEngineParameterItem.FPCircularArray).Free;
        LEngineParameterItem.FPCircularArray := nil;
      end;

      FWG.NextGrid1.CellByName['AvgValue',i].AsString := '';
//      FWG.NextGrid1.Cell[4,i].AsString := '';
    end;
  end;

  StopAvgButton.Enabled := False;
  StartAvgButton.Enabled := True;

  FWG.NextGrid1.Color := clWindow;

  FMonitorStart := False;
  FIsAverageFinish := False;
  Timer1.Enabled := False;
  FIsSaveToCSVCurData := False;
end;

procedure TWatchSaveF.SetConfigData;
var EngMonitorConfigF: TWatchSaveConfigF;
begin
  EngMonitorConfigF := TWatchSaveConfigF.Create(Application);
  with EngMonitorConfigF do
  begin
    try
      LoadConfigDataVar2Form(EngMonitorConfigF);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2Json(EngMonitorConfigF);
        LoadConfigDataJson2Var;
        //FExhTempAvg_A.Size := FConfigOption.AverageSize;
        ApplyAvgSize;
        ApplyOption;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TWatchSaveF.SetVisible4WatchSave;
begin
  FWG.NextGrid1.ColumnByName['SimpleDisplay'].Visible := False;
  FWG.NextGrid1.ColumnByName['TrendDisplay'].Visible := False;
  FWG.NextGrid1.ColumnByName['XYDisplay'].Visible := False;
  FWG.NextGrid1.ColumnByName['AlarmEnable'].Visible := False;

  FWG.NextGrid1.ColumnByName['IsAvg'].Visible := True;
  FWG.NextGrid1.ColumnByName['AvgValue'].Visible := True;
  FWG.NextGrid1.ColumnByName['ExcelRange'].Visible := True;
end;

procedure TWatchSaveF.StartAvgButtonClick(Sender: TObject);
var
  i,j: integer;
begin
  if AvgModeCB.Checked then
  begin
    j := 0;
    for i := 0 to FWG.NextGrid1.RowCount - 1 do
    begin
      if FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean then
        inc(j);
    end;

    if j = 0 then
    begin
      if MessageDlg('There is no selection.'+#13#10+'Do you want to calculate for all items?',
      mtConfirmation, [mbYes, mbNo], 0)= mrYes then
      begin
        for i := 0 to FWG.NextGrid1.RowCount - 1 do
          FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean := True;
      end
      else
        exit;
    end
    else
    begin
      if MessageDlg(IntToStr(j) + ' Item(s) are selected.'+#13#10+
          'Do you want to calculate average for selected item(s)?',
          mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        exit;
    end;

    FSaveFileName := JvFilenameEdit1.FileName;
    FSaveFileName2 := Copy(FSaveFileName,0,Pos('.',FSaveFileName)-1);
    FSaveFileExt := ExtractFileExt(FSaveFileName);
    if FSaveFileExt = '' then
    begin
      FSaveFileExt := '.csv';
      FSaveFileName := ChangeFileExt(FSaveFileName, FSaveFileExt);
      JvFilenameEdit1.FileName := FSaveFileName;
    end;

    //FSaveFileExt := Copy(FSaveFileName,Pos('.',FSaveFileName),Length(FSaveFileName));

    StartAvgCalc;

    StopAvgButton.Enabled := AvgModeCB.Checked;
    StartAvgButton.Enabled := not AvgModeCB.Checked;
    //FSaveDataBuf := formatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now);
    FMonitorStart := True;
  end;
end;

procedure TWatchSaveF.StartAvgCalc;
var
  i: integer;
  LEngineParameterItem: TEngineParameterItem;
begin
  FWG.NextGrid1.Color := clYellow;

  if FOldSaveFileName <> JvFilenameEdit1.FileName then
  begin
    FOldSaveFileName := JvFilenameEdit1.FileName;
    TestCntEdit.Text := '1';
  end
  else
  begin
    if FIsSaveToCSVCurData then
    begin
      i := StrToInt(TestCntEdit.Text);
      inc(i);
      TestCntEdit.Text := IntToStr(i);
    end;
  end;

  FCSVHeader := formatDateTime('yyyy-mm-dd hh:nn:ss',now) + ','+FCSVHeader;
  FConfigOption.SelDisplayInterval := 1; //Set Interval by timer
//  if interval2.Text = '' then
//    interval2.Text := '1000';
//  FConfigOption.DisplayInterval := StrToIntDef(interval2.Text,1000);

  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean then
    begin
      LEngineParameterItem := TEngineParameterItem(FWG.NextGrid1.Row[i].Data);

      if FConfigOption.AverageSize = 0 then
        FConfigOption.AverageSize := 1000;

      LEngineParameterItem.FPCircularArray := TCircularArray.Create(FConfigOption.AverageSize);
    end;
  end;

//  Timer1.Interval := FConfigOption.DisplayInterval;
//  Timer1.Enabled := True;
  FPJHTimerPool.Add(OnTrigger4AvgSaveTimeDisplay, 1000); //경과시간 표시
  FPJHTimerPool.Add(OnAvgCalc, FConfigOption.DisplayInterval);
  //FStopWatch.Start;
  FIsAverageFinish := False;
  FIsSaveToCSVCurData := False;
end;

procedure TWatchSaveF.StayOnTopCBClick(Sender: TObject);
begin
  if StayOnTopCB.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TWatchSaveF.StopAvgButtonClick(Sender: TObject);
begin
  if StopAvgCalc then
  begin
    StopAvgButton.Enabled := not StopAvgButton.Enabled;
    StartAvgButton.Enabled := not StopAvgButton.Enabled;

    FWG.NextGrid1.Color := clWindow;

    FMonitorStart := False;
    FIsAverageFinish := True;
    Timer1.Enabled := False;
  end;
end;

function TWatchSaveF.StopAvgCalc: Boolean;
var
  i: integer;
begin
  Result := False;

  if (not StartAvgButton.Enabled and StopAvgButton.Enabled) then
  begin
    FPJHTimerPool.RemoveAll;

    Result := True;
  end;
end;

procedure TWatchSaveF.Timer1Timer(Sender: TObject);
var
  i: integer;
  tmpdouble: double;
  LStr: string;
begin
  Timer1.Enabled := False;
  try
    if FMonitorStart then
    begin
      if FConfigOption.SelDisplayInterval = 1 then  //by timer
      begin
//        //CSV에 데이터 저장
//        if CB_Active.Checked and CB_CSVlogging.Checked then
//        begin
//          DisplayMessage(#13#10+TimeToStr(Time)+' Data Received by timer!', dtSendMemo);
//          FSaveDataBuf := formatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now);
//
//          for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
//          begin
//            FSaveDataBuf := FSaveDataBuf+ ',' + TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value;
//            FSaveDBDataBuf := FSaveDBDataBuf+ ',' + TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value;
//          end;
//        end
//        else if (not StartAvgButton.Enabled) and StopAvgButton.Enabled then //Average Mode
//        begin
//          DisplayMessage(#13#10+TimeToStr(Time)+' Data Received by timer in Average Mode!', dtSendMemo);
//          FSaveDataBuf := formatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now);
//
//          for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
//          begin
//            tmpdouble := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value,0.0);
//            if FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean then //Average Calc Mode
//            begin
//              TCircularArray(FWG.NextGrid1.Row[i].Data).Put(tmpdouble);
//              FWG.NextGrid1.Cell[4,i].AsFloat := TCircularArray(FWG.NextGrid1.Row[i].Data).Average;
//              //FSaveDataBuf := FSaveDataBuf+ ',' + FloatToStr(TCircularArray(NextGrid1.Row[i].Data).Average);
//              //FSaveDBDataBuf := FSaveDBDataBuf+ ',' + FloatToStr(TCircularArray(NextGrid1.Row[i].Data).Average);
//            end;
//          end;
//        end;

//        if (CB_Active.Checked and CB_CSVlogging.Checked) then
//        begin
//          SaveData2File;    //CSV 파일에 저장
//        end;
//
//        if (CB_Active.Checked and CB_DBlogging.Checked) then
//        begin
//          SaveData2DB;      //DB에 저장
//        end;
//        Timer1.Enabled := True;
      end;
    end;

    if FFirst then
    begin
      FFirst := False;
      UserLevel2Strings(AllowUserlevelCB.Items);

      AdjustComponentByUserLevel;
//      DSA.CreateSave2FileThread;

      if FConfigOption.SelDisplayInterval = 1 then  //by timer
        Timer1.Interval := FConfigOption.DisplayInterval;
    end;
  finally
    FMonitorStart := True;
    //Timer1.Enabled := True;
  end;//try

end;

procedure TWatchSaveF.FormClose(Sender: TObject; var Action: TCloseAction);
var
  LUserLevel: THiMECSUserLevel;
  LDeleteFileList: TStringList;
  i: integer;
  LStr: string;
begin
  FMonitorStart := False;
  Timer1.Enabled := False;
  FCommandLine.Free;
  FFileSaveOmniThread.Terminate;
  FFileSaveOmniThread.Stop;

  if (not StartAvgButton.Enabled) and StopAvgButton.Enabled then
  begin
    StopAvgButtonClick(nil);
  end;

  if SaveListCB.Checked then
    SaveWatchList('')
  else
  begin
    if FConfigOption.WatchListFileName <> '' then
    begin
      LStr := WatchListPath+FConfigOption.WatchListFileName;
      if FileExists(LStr) then
      begin
        LUserLevel := TFrameIPCMonitorAll1.FCurrentUserLevel;
//        if TFrameIPCMonitorAll1.CheckUserLevelForWatchListFile(FConfigOption.WatchListFileName, LUserLevel) then
//        begin
//          if MessageDlg('Do you want to delete the watch list file(' + LStr + ')?',
//                                    mtConfirmation, [mbYes, mbNo], 0)= mrYes then
//          begin
//            LDeleteFileList := TStringList.Create;
//            try
//              GetFiles(LDeleteFileList, WatchListPath+FConfigOption.WatchListFileName);
//              for i := 0 to LDeleteFileList.Count - 1 do
//                DeleteFile(LDeleteFileList.Strings[i]);
//            finally
//              LDeleteFileList.Free;
//            end;
//          end;
//        end;
      end;
    end;
  end;
end;

procedure TWatchSaveF.DataSaveByEvent;
var
  i: integer;
begin
  if FConfigOption.SelDisplayInterval = 0 then  //by event
  begin
    //CSV에 데이터 저장
//    if CB_Active.Checked and (CB_CSVlogging.Checked or CB_DBlogging.Checked) then
//    begin
//      DisplayMessage(#13#10+TimeToStr(Time)+' Data Received by event!', dtSendMemo);
//      FSaveDataBuf := formatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now);
//
//      for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
//      begin
//        FSaveDataBuf := FSaveDataBuf+ ',' + TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value;
//        FSaveDBDataBuf := FSaveDBDataBuf+ ',' + TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value;
//      end;
//    end;
//
//    if CB_Active.Checked and CB_CSVlogging.Checked then
//      SaveData2File;    //CSV 파일에 저장
//
//    if CB_Active.Checked and CB_DBlogging.Checked then
//      SaveData2DB;      //DB에 저장
  end;
end;

procedure TWatchSaveF.DeleteEngineParamterFromGrid(AIndex: integer);
begin
  FWG.NextGrid1.DeleteRow(AIndex);
  TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Delete(AIndex);
end;

procedure TWatchSaveF.DeleteItem1Click(Sender: TObject);
begin
  FWG.DeleteGridItem;
end;

procedure TWatchSaveF.DeselectAvg1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
    if FWG.NextGrid1.Row[i].Selected then
      FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean := not FWG.NextGrid1.Row[i].Selected;
end;

procedure TWatchSaveF.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass.DisConnectStomp;
    FpjhSTOMPClass.Free;
  end;
end;

procedure TWatchSaveF.DisplayMessage(msg: string; ADspNo: Integer);
begin
//  if FToggleBackground then
//    MsgWindowMemo.Color := $0080FF80
//  else
//    MsgWindowMemo.Color := clWhite;

  case TDisplayTarget(ADspNo) of
    dtSendMemo : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

      with MsgWindowMemo do
      begin
        if Lines.Count > 100 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtSendMemo
  end;
end;

procedure TWatchSaveF.DisplayMessage2SB(Msg: string);
begin
  JvStatusBar1.SimplePanel := True;
  JvStatusBar1.SimpleText := Msg;
end;

procedure TWatchSaveF.WMCopyData(var Msg: TMessage);
begin
  case Msg.WParam of
    0: begin
      FPM.SendEPCopyData(PCopyDataStruct(Msg.LParam)^.dwData, FWG.Handle, PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^);
    end;
  end;
//  case Msg.WParam of
//    //User Level Receive
//    2: TFrameIPCMonitorAll1.FCurrentUserLevel := THiMECSUserLevel(PCopyDataStruct(Msg.LParam)^.cbData);
//    //dcmCopyOnlyExist Receive
//    3: CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^, dcmCopyOnlyExist);
//    else
//      CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^, FDragCopyMode);
//  end;
end;

procedure TWatchSaveF.WorkerResult(var msg: TMessage);
begin
  ProcessResults;
end;

procedure TWatchSaveF.FormDestroy(Sender: TObject);
var
  it: DIterator;
  LArray: DArray;
begin
  FPJHTimerPool.RemoveAll;
  FCriticalSection.Free;

//  FreeStrListFromGrid;

  FConfigOption.Free;

  //TFrameIPCMonitorAll1.FEngineParameter.Free;
  DestroySTOMP;
  IPCAll_Final;

  FreeAndNil(FStopWatch);
  FPJHTimerPool.Free;

  if Assigned(FLocalSheet_Frm) then
    FreeAndNil(FLocalSheet_Frm);

//  if Assigned(FDataSave2FileThread) then
//  begin
    //FDataSave2FileThread.FDataSaveEvent.Signal;
//    FDataSave2FileThread.Terminate;
    //FDataSave2FileThread.Free;
//  end;

  FPM.Free;
end;

procedure TWatchSaveF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_control: begin
      if (ssCtrl in Shift) then
      begin
        ;//AlphaTrackBar.Buttons.
      end;
    end;
  end;
end;

procedure TWatchSaveF.FWGExcelRangeButtonClick(Sender: TObject);
begin
  FWG.ExcelRangeButtonClick(Sender);
end;

procedure TWatchSaveF.GetEngineParameterFromSavedWatchListFile(
  AAutoStart: Boolean; AFileName: string);
var
  i,j,k: integer;
  LStr: string;
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
    if FWG.NextGrid1.RowCount > 0 then
    begin
      if MessageDlg('Do you want to apppend the watch list to the grid?',
                                mtConfirmation, [mbYes, mbNo], 0)= mrYes then
      begin
        FWG.AppendEngineParameterFromFile(AFileName, FConfigOption.EngParamFileFormat,
                FConfigOption.EngParamEncrypt, False);
      end
      else
      begin
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
        FWG.FCompoundItemList.clear;

        if FConfigOption.EngParamFileFormat = 0 then //XML format
          TFrameIPCMonitorAll1.FEngineParameter.LoadFromFile_Thread(Application, AFileName)
        else
        if FConfigOption.EngParamFileFormat = 1 then //JSON format
          TFrameIPCMonitorAll1.FEngineParameter.LoadFromJSONFile(AFileName,
                    ExtractFileName(AFileName),FConfigOption.EngParamEncrypt);
      end;

      FWG.NextGrid1.ClearRows;
    end
    else
    begin
      if FConfigOption.EngParamFileFormat = 0 then //XML format
        TFrameIPCMonitorAll1.FEngineParameter.LoadFromFile_Thread(Application, AFileName)
      else
      if FConfigOption.EngParamFileFormat = 1 then //JSON format
        TFrameIPCMonitorAll1.FEngineParameter.LoadFromJSONFile(AFileName,
                  ExtractFileName(AFileName), FConfigOption.EngParamEncrypt);
    end;

    if (TFrameIPCMonitorAll1.FEngineParameter.FormWidth > 0) and
      (TFrameIPCMonitorAll1.FEngineParameter.FormHeight > 0) then
    begin
      Width := TFrameIPCMonitorAll1.FEngineParameter.FormWidth;
      Height := TFrameIPCMonitorAll1.FEngineParameter.FormHeight;
      Top := TFrameIPCMonitorAll1.FEngineParameter.FormTop;
      Left := TFrameIPCMonitorAll1.FEngineParameter.FormLeft;
      WindowState := TWindowState(TFrameIPCMonitorAll1.FEngineParameter.FormState);
    end;

    for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      //DisplayFormat 속성이 나중에 추가 되었기 때문에 적용 안된 WatchList파일의 경우 적용하기 위함
      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat = '' then
      begin
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat :=
          GetDisplayFormat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition,
                          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].DisplayThousandSeperator);
      end;

      FWG.AddEngineParameter2Grid(i);
    end; //for
  end;
end;

procedure TWatchSaveF.GetExcelInfoFromGrid(
  out AExcelInfoCollect: TExcelInfoCollect<TExcelInfoItem>);
var
  i: integer;
  LStr: string;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.CellByName['ISAvg',i].AsBoolean then
    begin
      LStr := FWG.NextGrid1.CellByName['ExcelRange',i].AsString;
      strToken(LStr, '(');

      with AExcelInfoCollect.Add do
      begin
        SheetName := strToken(LStr, '!');
        CellRange := strToken(LStr, ')');
        ItemName := FWG.NextGrid1.CellByName['ItemName',i].AsString;
        ItemValue := FWG.NextGrid1.CellByName['Value',i].AsString;
        ItemAvgValue := FWG.NextGrid1.CellByName['AvgValue',i].AsString;
      end;
    end;
  end;//for
end;

procedure TWatchSaveF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TWatchSaveF.CB_ActiveClick(Sender: TObject);
var
  i: integer;
begin
  //Data save를 시작했을 경우
//  if CB_Active.Checked then
//  begin
//    AvgModeCB.Enabled := False;
//
//    if (not StartAvgButton.Enabled) and StopAvgButton.Enabled then
//    begin
//      ShowMessage('Average Mode is active' + #13#10 + 'Stop the Average Mode');
//      CB_Active.Checked := False;
//      PageControl1.ActivePageIndex := 1;
//      StopAvgButton.SetFocus;
//      exit;
//    end;
//
//    FMonitorStart := True;
//    DisplayMessage (#13#10+ '#####################' +#13#10+ TimeToStr(Time)+' Start Data Receiving');
//    FLogStart := True;
//
//    //CSV 파일에 Data Save할 경우
//    if CB_CSVlogging.Checked then
//    begin
//      FCSVHeader := FormatDateTime('yyyy-mm-dd hh:nn:ss',now);
//
//      for i := 0 to FWG.NextGrid1.RowCount - 1 do
//        FCSVHeader := FCSVHeader+ ',' + FWG.NextGrid1.CellByName['ItemName',i].AsString;
//
//      FTagNameBuf := FCSVHeader;
//      if FSaveFileName <> ED_csv.Text then
//      begin
//        //Data Save 프로그램의 저장 파일과 구분하기 위해 ws_를 붙임
//        if RB_bydate.Checked then
//          FSaveFileName := 'ws_' + ED_csv.Text
//        else
//          FSaveFileName := ED_csv.Text;
//
//        FDataSave2FileThread.FFileName := FSaveFileName;
//
//        if FConfigOption.InitialFileIndex then
//          FFileIndex := FConfigOption.InitialIndex
//        else
//          FFileIndex := 0;
//      end;
//
//      FSaveFileName2 := Copy(FSaveFileName,0,Pos('.',FSaveFileName)-1);
//      FSaveFileExt := Copy(FSaveFileName,Pos('.',FSaveFileName),Length(FSaveFileName));
//      Timer1.Interval := StrToInt(ED_interval.Text);
//      Timer1.Enabled := True;
//      //SaveData2File;
//    end;
//
//    //공유메모리 모니터쓰레드 동작 시작
//    //FIPCMonitor_ECS_kumo.Resume;
//
//    //Data save 도중엔 세팅변경 불가
//    CB_DBlogging.Enabled := False;
//    CB_CSVlogging.Enabled := False;
//    RB_bydate.Enabled := False;
//    RB_byfilename.Enabled := False;
//    ED_csv.Enabled := False;
//    RB_byevent.Enabled := False;
//    RB_byinterval.Enabled := False;
//    ED_interval.Enabled := False;
//  end
//
//  //Data save를 종료할 경우
//  else
//  begin
//    AvgModeCB.Enabled := True;
//
//    FMonitorStart := False;
//    DisplayMessage (TimeToStr(Time)+#13#10+' Processing terminated');
//    FlogStart := False;
//    //FIPCMonitor_ECS_kumo.Suspend;    //공유메모리 모니터쓰레드 동작 중지
//
//    //Data save해제와 동시에 각 버튼 세팅변경불가 해지
//    CB_DBlogging.Enabled := True;
//    CB_CSVlogging.Enabled := True;
//    RB_bydate.Enabled := True;
//    RB_byfilename.Enabled := True;
//
//    if RB_byfilename.Checked then
//    begin
//      ED_csv.Enabled := True;
//    end;
//
//    //RB_byevent.Enabled := True;
//    RB_byinterval.Enabled := True;
//    if RB_byinterval.Checked then
//    begin
//      ED_interval.Enabled := True;
//    end;
//  end;
end;

procedure TWatchSaveF.ChangeSheetNameforExcelRange1Click(Sender: TObject);
var
  LCaptionInputF: TCaptionInputF;
  i: integer;
  LStr, LSheetName: string;
begin
  LCaptionInputF := TCaptionInputF.Create(Application);

  with LCaptionInputF do
  begin
    try
      CaptionNameEdit.Text := '';
      Label1.Caption := 'Excel Sheet Name:';
      Caption := 'Change Excel Sheet Name';

      if ShowModal = mrOK then
      begin
        if CaptionNameEdit.Text = '' then
        begin
          ShowMessage(Label1.Caption + ' should not be blank!');
          exit;
        end;

        FWG.NextGrid1.BeginUpdate;
        try
          for i := 0 to FWG.NextGrid1.RowCount - 1 do
          begin
            LStr := FWG.NextGrid1.CellByName['ExcelRange', i].AsString;

            if LStr = '' then
              continue;

            strToken(LStr, '(');
            LStr := strToken(LStr, '!');
            LSheetName := StringReplace(FWG.NextGrid1.CellByName['ExcelRange', i].AsString,
              LStr, CaptionNameEdit.Text, [rfReplaceAll, rfIgnoreCase]);
            FWG.NextGrid1.CellByName['ExcelRange', i].AsString := LSheetName;
          end;
        finally
          FWG.NextGrid1.EndUpdate;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TWatchSaveF.EnableAlphaCBClick(Sender: TObject);
begin
  AlphaBlend := EnableAlphaCB.Checked;
end;

procedure TWatchSaveF.ClearAllExcelRange;
var
  i: integer;
begin
  FWG.NextGrid1.BeginUpdate;
  try
    for i := 0 to FWG.NextGrid1.RowCount - 1 do
      FWG.NextGrid1.CellByName['ExcelRange', i].Clear;
  finally
    FWG.NextGrid1.EndUpdate;
  end;
end;

procedure TWatchSaveF.ClearExcelRange1Click(Sender: TObject);
begin
  ClearAllExcelRange;
end;

procedure TWatchSaveF.Close1Click(Sender: TObject);
begin
  Close;
end;

function TWatchSaveF.CommandLineParse(var AErrMsg: string): boolean;
var
//  cl    : TWatchSaveCommandLineOption;
  LStr: string;
begin
  AErrMsg := '';
//  cl := TWatchSaveCommandLineOption.Create;
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

procedure TWatchSaveF.Config1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TWatchSaveF.Copynonexistingitems1Click(Sender: TObject);
begin
  FWG.ProcessItemsDrop(dcmCopyAllOverWrite);
end;

procedure TWatchSaveF.Copyonlyexistingitems1Click(Sender: TObject);
begin
  FWG.ProcessItemsDrop(dcmCopyOnlyExist);
end;

procedure TWatchSaveF.CreateIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord; ADragCopyMode: TParamDragCopyMode);
var
  i, j, LResult: integer;
begin
  LResult := FWG.CreateIPCMonitor(AEP_DragDrop, ADragCopyMode);

  //신규 Item 이면
  if not (ADragCopyMode = dcmCopyOnlyExist) and (LResult = -1) then
  begin
   //Administrator이상의 권한자 만이 Config form에서 level 조정 가능함
    if TFrameIPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator then
    begin
      AllowUserlevelCB.Enabled := True;
    end;

    if AllowUserlevelCB.Text = '' then
      AllowUserlevelCB.Text := UserLevel2String(TFrameIPCMonitorAll1.FCurrentUserLevel);
  end;
end;

procedure TWatchSaveF.CreateLocalSheet_Frm;
begin
  FLocalSheet_Frm := TLocalSheet_Frm.Create(Self);
end;

procedure TWatchSaveF.CreateReportWithCSVFile;
var
  LExcelInfo: TExcelInfoCollect<TExcelInfoItem>;
begin
  SetCurrentDir(FFilePath);

  with TFormTestReport.Create(self) do
  begin
    LExcelInfo := TExcelInfoCollect<TExcelInfoItem>.Create;
    try
      GetExcelInfoFromGrid(LExcelInfo);
      LExcelInfo.AssignTo(FExcelInfo);

      ReportFilenameEdit.FileName := FReportFileName;
      //if Pos(':\', JvFilenameEdit1.FileName) = 0 then
      if ExtractFilePath(JvFilenameEdit1.FileName) = '' then
        FileNameEdt.Text := '.\CSVFile\' + JvFilenameEdit1.FileName
      else
        FileNameEdt.Text := JvFilenameEdit1.FileName;

      LoadFromFile2Grid(FileNameEdt.Text);

      ShowModal;
    finally
      Free;
      LExcelInfo.Free;
    end;
  end;
end;

procedure TWatchSaveF.CreateReportWithCSVFile1Click(Sender: TObject);
begin
  CreateReportWithCSVFile;
end;

procedure TWatchSaveF.CreateReportWithExcelRange(AXlFileName: string);
var
  i: integer;
  LExcelInfo: TExcelInfoCollect<TExcelInfoItem>;
begin
  if AXlFileName = '' then
  begin
    ShowMessage('Select File Name Frist!');
    exit;
  end;

  LExcelInfo := TExcelInfoCollect<TExcelInfoItem>.Create;
  try
    GetExcelInfoFromGrid(LExcelInfo);
    LExcelInfo.MakeExcelReport(AXlFileName);
  finally
    LExcelInfo.Free;
  end;
//  FWorkBook.Close;
//  FExcel.Quit;
end;

procedure TWatchSaveF.CreateReportWithExcelRange1Click(Sender: TObject);
begin
  JvOpenDialog1.InitialDir := FFilePath;
  JvOpenDialog1.Filter := '*.*';

  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      CreateReportWithExcelRange(jvOpenDialog1.FileName);
    end;
  end;
end;

procedure TWatchSaveF.CsvFileSaveCBClick(Sender: TObject);
begin
  FConfigOption.IsCsvFileSave := CsvFileSaveCB.Checked;

  if CsvFileSaveCB.Checked then
  begin
    if Interval2.Text = '' then
      Interval2.Text := '1000';

    FConfigOption.FileSaveInterval := StrToIntDef(Interval2.Text, 1000);

    if JvFilenameEdit1.FileName = '' then
      JvFilenameEdit1.FileName := ExtractFilePath(Application.ExeName) +
        formatDateTime('yyyymmdd',now) + '.csv';

    if FFileSaveTimerHandle = -1 then
      FFileSaveTimerHandle := FPJHTimerPool.Add(OnAvgSave, FConfigOption.FileSaveInterval);
  end
  else
    if FFileSaveTimerHandle <> -1 then
    begin
      FPJHTimerPool.Remove(FFileSaveTimerHandle);
      FFileSaveTimerHandle := -1;
      ShowMessage('Stopped CSV Data Save!');
    end;
end;

procedure TWatchSaveF.ExcelRangeButtonClick(Sender: TObject);
begin
  //ShowMessage(IntTostr(FWG.NextGrid1.SelectedColumn));
  //ShowMessage(IntTostr(FWG.NextGrid1.Columns.Count));
  FWG.NextGrid1.Columns[FWG.NextGrid1.SelectedColumn].Editor.AsString := Clipboard.AsText;
end;

procedure TWatchSaveF.OnAvgCalc(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i, LRow: integer;
  tmpdouble: double;
  LEP: TEngineParameterCollect;
  LStr, LSaveDataBuf: string;
  LValue: TOmniValue;
  LCsvDataRecord: TCsvDataRecord;
begin
  System.TMonitor.Enter(Self);
  try
    if (not StartAvgButton.Enabled) and StopAvgButton.Enabled then //Average Mode
    begin
      DisplayMessage(#13#10+TimeToStr(Time)+' Data Received by timer in Average Mode!', 0);
      LSaveDataBuf := formatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now);
      LEP := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect;
      FCSVHeader := 'Data Saved Time';

      for i := 0 to LEP.Count - 1 do
      begin
        if Assigned(LEP.Items[i].NextGridRow) then
        begin
          LRow := FWG.NextGrid1.GetRowIndex(TRow(LEP.Items[i].NextGridRow));

          if FWG.NextGrid1.CellByName['IsAvg',LRow].AsBoolean then //Average Calc Mode
          begin
            if Pos('.', LEP.Items[i].Value) > 0 then
              tmpdouble := StrToFloatDef(LEP.Items[i].Value, 0.0)
            else
              tmpdouble := StrToIntDef(LEP.Items[i].Value, 0)/1;

            TCircularArray(LEP.Items[i].FPCircularArray).Put(tmpdouble);
            tmpdouble := TCircularArray(LEP.Items[i].FPCircularArray).Average;
            if LEP.Items[i].RadixPosition = 0 then
              LStr := Format('%d', [Round(tmpdouble)])
            else
              LStr := FormatFloat(LEP.Items[i].DisplayFormat, tmpdouble);

            FWG.NextGrid1.CellByName['AvgValue',LRow].AsString := LStr;
            LSaveDataBuf := LSaveDataBuf+ ',' + LStr;//FloatToStr(tmpdouble);
            FCSVHeader := FCSVHeader + ',' + FWG.NextGrid1.CellByName['ItemName',LRow].AsString;
            //FSaveDBDataBuf := FSaveDBDataBuf+ ',' + FloatToStr(TCircularArray(NextGrid1.Row[i].Data).Average);
          end;
        end;
      end;

      if FConfigOption.IsCsvFileSave then
      begin
        FCriticalSection.Enter;
        try
          FSaveDataBuf := LSaveDataBuf;
        finally
          FCriticalSection.Leave;
        end;//try
      end;
    end;
  finally
    System.TMonitor.Exit(Self);
  end;
end;

procedure TWatchSaveF.OnAvgSave(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  LValue: TOmniValue;
  LCsvDataRecord: TCsvDataRecord;
begin
  if FConfigOption.IsCsvFileSave then
  begin
    FCriticalSection.Enter;
    try
      LCsvDataRecord.FCsvData := FSaveDataBuf;
    finally
      FCriticalSection.Leave;
    end;//try

    FFileSaveOmniThread.FHeaderData := FCSVHeader;
    LCsvDataRecord.FFileName := JvFilenameEdit1.FileName;
    LValue := TOmniValue.FromRecord<TCsvDataRecord>(LCsvDataRecord);
    FFileSaveOmniThread.FCsvMsgQueue.Enqueue(TOmniMessage.Create(0, LValue));
  end;
end;

procedure TWatchSaveF.OnTrigger4AvgSaveTimeDisplay(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
//평균값 계산시 경과 시간 표시에 사용 됨.
var
  LTime: integer;
begin
  LTime := ElapsedTime div 1000;
  ElapsedTimeEdit.Text := FORMAT_TIME(LTime);
end;

procedure TWatchSaveF.ProcessResults;
var
  msg: TOmniMessage;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    TFrameIPCMonitorAll1.ProcessDataFromMQ(msg.MsgData);
  end;
end;

procedure TWatchSaveF.Properties1Click(Sender: TObject);
begin
  FWG.ShowProperties;
end;

procedure TWatchSaveF.ResetAvgCalc;
var
  i: integer;
begin
  for i := 0 to FWG.NextGrid1.RowCount - 1 do
    if FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean then
      FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean := False;
end;

procedure TWatchSaveF.ResetSelect1Click(Sender: TObject);
begin
  if (not StartAvgButton.Enabled) and StopAvgButton.Enabled then
    StopAvgButtonClick(nil);

  ResetAvgCalc;
end;

//popup menu item등을 current user level에 맞게 disable 시킴
//Tagname에 '.'이 있으면 에러 남
procedure TWatchSaveF.AddtoCalculated1Click(Sender: TObject);
begin
  FWG.AddCalculated2GridFromMenu;
end;

//popup menu item등을 current user level에 맞게 disable 시킴
procedure TWatchSaveF.AlphaTrackBarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  AlphaBlendValue := AlphaTrackBar.Position;
end;

procedure TWatchSaveF.ApplyAvgSize;
begin
end;

procedure TWatchSaveF.ApplyCommandLineOption;
begin
  if FCommandLine.WatchListFileName <> '' then
    FConfigOption.WatchListFileName := FCommandLine.WatchListFileName;
end;

procedure TWatchSaveF.ApplyOption;
begin
  if FCurrentModbusFileName <> FConfigOption.ModbusFileName then
  begin
    if FileExists(FConfigOption.ModbusFileName) then
    begin
//      TFrameIPCMonitorAll1.SetModbusMapFileName(FConfigOption.ModbusFileName, psECS_AVAT);
    end;
  end;

  if FConfigOption.MonDataSource = 2 then //By MQ
    InitSTOMP
  else
    DestroySTOMP;
end;

procedure TWatchSaveF.AvgModeCBClick(Sender: TObject);
begin
  if not AvgModeCB.Checked then
  begin
    if (not StartAvgButton.Enabled) and StopAvgButton.Enabled then
      StopAvgButtonClick(nil);
  end
  else
  begin
    if not Assigned(FLocalSheet_Frm) then
      CreateLocalSheet_Frm;
  end;

  AvgModePanel.Visible := AvgModeCB.Checked;
  PageControl1.ActivePageIndex := 0;
end;

procedure TWatchSaveF.Button2Click(Sender: TObject);
begin
  //SetCurrentDir(FFilePath);
  ExecNewProcess2(IncludeTrailingPathDelimiter(FFilePath)+HiMECSExcelRangeName);
end;

procedure TWatchSaveF.Button3Click(Sender: TObject);
begin
  FReportFileName := Clipboard.AsText;
  Caption := 'Save Watch : Report File Name = ' + FReportFileName;
end;

procedure TWatchSaveF.Save2CsvBtnClick(Sender: TObject);
var
  i: integer;
  LEngineParameterItem: TEngineParameterItem;
begin
  if JvFilenameEdit1.FileName = '' then
  begin
    ShowMessage('Select save csv file name.');
    JvFilenameEdit1.SetFocus;
    exit;
  end;

  if not FIsAverageFinish then
  begin
    ShowMessage('Push the ''Stop Average'' button first');
    exit;
  end;

//  if MessageDlg('Local data are added to the report.'+#13#10+'Are you sure?',
//                              mtConfirmation, [mbYes, mbNo], 0)= mrYes then
//    LoadLocalDataFromSheet
//  else
//    exit;

  FSaveDataBuf := FormatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now);
  FCSVHeader := FormatDateTime('yyyy-mm-dd hh:nn:ss',now);

  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if FWG.NextGrid1.CellByName['IsAvg',i].AsBoolean then
    begin
      FCSVHeader := FCSVHeader+ ',' + FWG.NextGrid1.CellByName['ItemName',i].AsString;// +
//                    FWG.NextGrid1.Cell[5,i].AsString;
      LEngineParameterItem := TEngineParameterItem(FWG.NextGrid1.Row[i].Data);

      if Assigned(LEngineParameterItem.FPCircularArray) then
      begin
        FSaveDataBuf := FSaveDataBuf + ',' + FloatToStr(TCircularArray(LEngineParameterItem.FPCircularArray).Average);
        TCircularArray(LEngineParameterItem.FPCircularArray).Free;
        LEngineParameterItem.FPCircularArray := nil;
        FWG.NextGrid1.CellByName['AvgValue',i].AsString := '';
      end;
    end;
  end;

  FSaveFileName := JvFilenameEdit1.FileName;

  if FileExists(FSaveFileName) then
    FCSVHeader := '';

  SaveData2FixedFile('CSVFile', FSaveFileName, FSaveDataBuf, soFromEnd, FCSVHeader);
//  DSA.SetSaveFileName(FSaveFileName);
//  //FSaveFileName := ExtractFileName(FSaveFileName);
//  DSA.SetFileNameConvention(FC_FIXED);
//  DSA.SetTagBuf(FCSVHeader);
//  DSA.SetSaveDataBuf(FSaveDataBuf);
//  DSA.SaveData2File;
  FIsSaveToCSVCurData := True;
end;

end.





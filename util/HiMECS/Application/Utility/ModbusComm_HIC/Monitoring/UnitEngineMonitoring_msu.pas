unit UnitEngineMonitoring_msu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ExtCtrls,
  Dialogs, DeCAL, janSQL, IPCThrd_ECS_kumo, ModbusComStruct, IPCThrdMonitor_ECS_kumo,
  ConfigConst, SBPro, CommonUtil, iPlotComponent, iXYPlot, iPlotAxis,
  iVCLComponent, iCustomComponent, iPositionComponent, iScaleComponent,
  iGaugeComponent,iXYPlotChannel, iAngularGauge, iPanel, iLabel, iAnalogDisplay,
  iProgressComponent, iLedBar, iComponent, ShadowButton, ConfigOptionClass,
  MonitorConfig, Menus, iSevenSegmentDisplay, iSevenSegmentInteger, StdCtrls,
  iLedArrow, iLed, iLedRectangle, JvExControls, JvSpeedButton, ComCtrls,
  NxPageControl, CircularArray, SyncObjs, StopWatch, iThermometer,
  CSelectOnRunTime, CSaveComps, JvComponentBase, JvMouseGesture;

type
  TFrmEngineMonitoring = class(TForm)
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    SetConfig1: TMenuItem;
    ScrollBox1: TScrollBox;
    NxPageControl1: TNxPageControl;
    NxTabSheet1: TNxTabSheet;
    Panel7: TPanel;
    Label19: TLabel;
    Panel8: TPanel;
    iLedRectangle18: TiLedRectangle;
    iLedRectangle19: TiLedRectangle;
    iLedRectangle20: TiLedRectangle;
    iLedRectangle21: TiLedRectangle;
    iLedRectangle22: TiLedRectangle;
    iLedRectangle23: TiLedRectangle;
    iLedRectangle24: TiLedRectangle;
    iLedRectangle25: TiLedRectangle;
    iLedRectangle26: TiLedRectangle;
    iLedArrow1: TiLedArrow;
    NxTabSheet2: TNxTabSheet;
    Panel36: TPanel;
    Panel42: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label22: TLabel;
    AI_EXH_A_1_L: TiLedBar;
    AI_EXH_A_2_L: TiLedBar;
    AI_EXH_A_3_L: TiLedBar;
    AI_EXH_A_5_L: TiLedBar;
    AI_EXH_A_4_L: TiLedBar;
    AI_EXH_A_6_L: TiLedBar;
    AI_EXH_A_TCINLET_A_L: TiLedBar;
    AI_EXH_A_Avg_L: TiLedBar;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    AI_FOTEMPINLET: TiAnalogDisplay;
    AI_LOTEMPINLET: TiAnalogDisplay;
    StaticText1: TStaticText;
    StaticText4: TStaticText;
    StaticText7: TStaticText;
    AI_CAPRESS: TiAnalogDisplay;
    AI_FOFILTERINLETPRESS: TiAnalogDisplay;
    AI_LOFILTERPRESSINLET: TiAnalogDisplay;
    StaticText9: TStaticText;
    AI_FOFILTEROUTLETPRESS: TiAnalogDisplay;
    StaticText10: TStaticText;
    AI_HTTEMPINLET: TiAnalogDisplay;
    StaticText14: TStaticText;
    AI_HTTEMPOUTLET: TiAnalogDisplay;
    StaticText15: TStaticText;
    AI_LOFILTERPRESSOUTLET: TiAnalogDisplay;
    StaticText16: TStaticText;
    AI_LOTC_A_PRESS: TiAnalogDisplay;
    StaticText17: TStaticText;
    AI_LTPRESSINLET: TiAnalogDisplay;
    StaticText18: TStaticText;
    AI_LTTEMPINLET: TiAnalogDisplay;
    StaticText19: TStaticText;
    AI_LTTEMPOUTLET: TiAnalogDisplay;
    StaticText21: TStaticText;
    AI_STARTINGAIRPRESS: TiAnalogDisplay;
    StaticText26: TStaticText;
    AI_LOTC_A_TEMP: TiAnalogDisplay;
    StaticText27: TStaticText;
    AI_HTPRESSINLET_A: TiAnalogDisplay;
    AI_EXH_A_TCOUTLET_L: TiLedBar;
    AI_EXH_A_1: TPanel;
    AI_EXH_A_2: TPanel;
    AI_EXH_A_3: TPanel;
    AI_EXH_A_4: TPanel;
    AI_EXH_A_5: TPanel;
    AI_EXH_A_6: TPanel;
    AI_EXH_A_TCOUTLET: TPanel;
    AI_EXH_A_TCINLET_A: TPanel;
    AI_EXH_A_Avg: TPanel;
    Panel10: TPanel;
    Label20: TLabel;
    Label25: TLabel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel18: TPanel;
    Panel17: TPanel;
    Panel21: TPanel;
    AI_ENGINERPM_P: TPanel;
    Panel23: TPanel;
    AI_TC_A_RPM_P: TPanel;
    Panel25: TPanel;
    AI_TC_B_RPM_P: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    RunHourPanel: TPanel;
    Panel33: TPanel;
    DateTimePanel: TPanel;
    Panel19: TPanel;
    Panel35: TPanel;
    NxTabSheet3: TNxTabSheet;
    AI_EXH_A_1_L_: TiLedBar;
    AI_EXH_A_2_L_: TiLedBar;
    AI_EXH_A_3_L_: TiLedBar;
    AI_EXH_A_4_L_: TiLedBar;
    AI_EXH_A_5_L_: TiLedBar;
    AI_EXH_A_6_L_: TiLedBar;
    AI_EXH_A_7_L_: TiLedBar;
    AI_EXH_A_8_L_: TiLedBar;
    AI_EXH_A_9_L_: TiLedBar;
    AI_EXH_A_1_: TPanel;
    AI_EXH_A_2_: TPanel;
    AI_EXH_A_3_: TPanel;
    AI_EXH_A_4_: TPanel;
    AI_EXH_A_5_: TPanel;
    AI_EXH_A_6_: TPanel;
    AI_EXH_A_7_: TPanel;
    AI_EXH_A_8_: TPanel;
    AI_EXH_A_9_: TPanel;
    Panel24: TPanel;
    Panel26: TPanel;
    Panel32: TPanel;
    Panel34: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Panel43: TPanel;
    Panel44: TPanel;
    Panel45: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel46: TPanel;
    AI_EXH_B_1_L_: TiLedBar;
    AI_EXH_B_2_L_: TiLedBar;
    AI_EXH_B_3_L_: TiLedBar;
    AI_EXH_B_4_L_: TiLedBar;
    AI_EXH_B_5_L_: TiLedBar;
    AI_EXH_B_6_L_: TiLedBar;
    AI_EXH_B_7_L_: TiLedBar;
    AI_EXH_B_8_L_: TiLedBar;
    AI_EXH_B_9_L_: TiLedBar;
    AI_EXH_B_1_: TPanel;
    AI_EXH_B_2_: TPanel;
    AI_EXH_B_3_: TPanel;
    AI_EXH_B_4_: TPanel;
    AI_EXH_B_5_: TPanel;
    AI_EXH_B_6_: TPanel;
    AI_EXH_B_7_: TPanel;
    AI_EXH_B_8_: TPanel;
    AI_EXH_B_9_: TPanel;
    Panel56: TPanel;
    Panel57: TPanel;
    Panel58: TPanel;
    Panel59: TPanel;
    Panel60: TPanel;
    Panel61: TPanel;
    Panel62: TPanel;
    Panel63: TPanel;
    Panel64: TPanel;
    Bevel3: TBevel;
    Panel66: TPanel;
    Panel67: TPanel;
    AI_TC_A_RPM_G: TiAngularGauge;
    AI_ENGINERPM_G: TiAngularGauge;
    AI_TC_A_RPM: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    AI_ENGINERPM: TPanel;
    AI_TC_A_RPM_G_: TiAngularGauge;
    AI_TC_B_RPM_G_: TiAngularGauge;
    AI_ENGINERPM_G_: TiAngularGauge;
    AI_TC_A_RPM_: TPanel;
    Panel71: TPanel;
    Panel72: TPanel;
    Panel73: TPanel;
    AI_TC_B_RPM_: TPanel;
    AI_ENGINERPM_: TPanel;
    Panel68: TPanel;
    Panel65: TPanel;
    Panel99: TPanel;
    AI_EXH_A_Avg_L_: TiLedBar;
    AI_EXH_A_Avg_: TPanel;
    Panel101: TPanel;
    AI_EXH_B_Avg_L_: TiLedBar;
    AI_EXH_B_Avg_: TPanel;
    Panel69: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    AI_EXH_A_TCINLET_A_L_: TiLedBar;
    AI_EXH_A_TCOUTLET_L_: TiLedBar;
    AI_EXH_A_TCINLET_A_: TPanel;
    AI_EXH_A_TCOUTLET_: TPanel;
    Panel9: TPanel;
    Panel20: TPanel;
    AI_EXH_B_TCINLET_A_L_: TiLedBar;
    AI_EXH_B_TCOUTLET_L_: TiLedBar;
    AI_EXH_B_TCINLET_A_: TPanel;
    AI_EXH_B_TCOUTLET_: TPanel;
    NxTabSheet4: TNxTabSheet;
    Bevel4: TBevel;
    AI_MAINBERGTEMP_1_L_: TiLedBar;
    AI_MAINBERGTEMP_2_L_: TiLedBar;
    AI_MAINBERGTEMP_3_L_: TiLedBar;
    AI_MAINBERGTEMP_4_L_: TiLedBar;
    AI_MAINBERGTEMP_5_L_: TiLedBar;
    AI_MAINBERGTEMP_6_L_: TiLedBar;
    AI_MAINBERGTEMP_7_L_: TiLedBar;
    AI_MAINBERGTEMP_8_L_: TiLedBar;
    AI_MAINBERGTEMP_9_L_: TiLedBar;
    AI_MAINBERGTEMP_10_L_: TiLedBar;
    AI_MAINBERGTEMP_11_L_: TiLedBar;
    AI_MAINBERGTEMP_1_: TPanel;
    AI_MAINBERGTEMP_2_: TPanel;
    AI_MAINBERGTEMP_3_: TPanel;
    AI_MAINBERGTEMP_4_: TPanel;
    AI_MAINBERGTEMP_5_: TPanel;
    AI_MAINBERGTEMP_6_: TPanel;
    AI_MAINBERGTEMP_7_: TPanel;
    AI_MAINBERGTEMP_8_: TPanel;
    AI_MAINBERGTEMP_9_: TPanel;
    AI_MAINBERGTEMP_10_: TPanel;
    AI_MAINBERGTEMP_11_: TPanel;
    Panel87: TPanel;
    Panel88: TPanel;
    Panel89: TPanel;
    Panel90: TPanel;
    Panel91: TPanel;
    Panel92: TPanel;
    Panel93: TPanel;
    Panel94: TPanel;
    Panel95: TPanel;
    Panel96: TPanel;
    Panel97: TPanel;
    Panel98: TPanel;
    AI_EXH_A_1_L_UP: TiLedBar;
    AI_EXH_A_1_L_DOWN: TiLedBar;
    Bevel5: TBevel;
    AI_EXH_A_2_L_UP: TiLedBar;
    AI_EXH_A_2_L_DOWN: TiLedBar;
    AI_EXH_A_3_L_UP: TiLedBar;
    AI_EXH_A_4_L_UP: TiLedBar;
    AI_EXH_A_3_L_DOWN: TiLedBar;
    AI_EXH_A_4_L_DOWN: TiLedBar;
    AI_EXH_A_5_L_UP: TiLedBar;
    AI_EXH_A_5_L_DOWN: TiLedBar;
    AI_EXH_A_6_L_UP: TiLedBar;
    AI_EXH_A_6_L_DOWN: TiLedBar;
    AI_EXH_A_7_L_UP: TiLedBar;
    AI_EXH_A_8_L_UP: TiLedBar;
    AI_EXH_A_7_L_DOWN: TiLedBar;
    AI_EXH_A_8_L_DOWN: TiLedBar;
    AI_EXH_A_9_L_UP: TiLedBar;
    AI_EXH_A_9_L_DOWN: TiLedBar;
    AI_EXH_A_1_Diff: TPanel;
    AI_EXH_A_2_Diff: TPanel;
    AI_EXH_A_3_Diff: TPanel;
    AI_EXH_A_4_Diff: TPanel;
    AI_EXH_A_5_Diff: TPanel;
    AI_EXH_A_6_Diff: TPanel;
    AI_EXH_A_7_Diff: TPanel;
    AI_EXH_A_8_Diff: TPanel;
    AI_EXH_A_9_Diff: TPanel;
    Bevel6: TBevel;
    AI_EXH_B_1_L_UP: TiLedBar;
    AI_EXH_B_1_L_DOWN: TiLedBar;
    Bevel7: TBevel;
    AI_EXH_B_2_L_UP: TiLedBar;
    AI_EXH_B_2_L_DOWN: TiLedBar;
    AI_EXH_B_3_L_UP: TiLedBar;
    AI_EXH_B_4_L_UP: TiLedBar;
    AI_EXH_B_3_L_DOWN: TiLedBar;
    AI_EXH_B_4_L_DOWN: TiLedBar;
    AI_EXH_B_5_L_UP: TiLedBar;
    AI_EXH_B_5_L_DOWN: TiLedBar;
    AI_EXH_B_6_L_UP: TiLedBar;
    AI_EXH_B_6_L_DOWN: TiLedBar;
    AI_EXH_B_7_L_UP: TiLedBar;
    AI_EXH_B_8_L_UP: TiLedBar;
    AI_EXH_B_7_L_DOWN: TiLedBar;
    AI_EXH_B_8_L_DOWN: TiLedBar;
    AI_EXH_B_9_L_UP: TiLedBar;
    AI_EXH_B_9_L_DOWN: TiLedBar;
    AI_EXH_B_1_Diff: TPanel;
    AI_EXH_B_2_Diff: TPanel;
    AI_EXH_B_3_Diff: TPanel;
    AI_EXH_B_4_Diff: TPanel;
    AI_EXH_B_5_Diff: TPanel;
    AI_EXH_B_6_Diff: TPanel;
    AI_EXH_B_7_Diff: TPanel;
    AI_EXH_B_8_Diff: TPanel;
    AI_EXH_B_9_Diff: TPanel;
    Bevel8: TBevel;
    PopupMenu2: TPopupMenu;
    Visible1: TMenuItem;
    StatusBar1: TStatusBar;
    Label2: TLabel;
    AI_EXH_A_TCINLET_B_L: TiLedBar;
    AI_EXH_A_TCINLET_B: TPanel;
    Label3: TLabel;
    AI_EXH_A_TCINLET_C_L: TiLedBar;
    AI_EXH_A_TCINLET_C: TPanel;
    StaticText5: TStaticText;
    AI_CATEMP: TiAnalogDisplay;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure SetConfig1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Visible1Click(Sender: TObject);
  private
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FjanDB : TjanSQL; //text 기반 SQL DB
    FFilePath: string;      //파일을 저장할 경로
    FMapFilePath: string;   //Map이 있는파일 경로
    FHiMap: THiMap;         //Modbus Address 구조체 -> 동적으로 생성함
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체
    FOptionFileName: string;//Option 저장하는  XML file name
    FECSData: TEventData_ECS_kumo;
    FMsgList: TStringList;  //Message를 저장하는 리스트
    FConfigOption: TConfigOption;
    FExhTempAvg_A,
    FExhTempAvg_B: TCircularArray;// Exh Temp. Average Circular Array
    FAvgSize: integer; //Exh Temp.평균을 위한 배열 size

    FAnalogEnter: Boolean;
    FCriticalSection: TCriticalSection;

    FStopWatch: TStopWatch;//Running Hour 계산용 Class
    FEngineRunning: Boolean;

    procedure pjhMouseEvent(var Msg: TMsg; var Handled: boolean);
    procedure ECS_OnSignal(Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo);
    procedure UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo); message WM_EVENT_ECS;
    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string);
    function  ModBusValueResolve(value:integer; max: real; datatype: TDataType): string;
    procedure Value2Screen_ECS_kumo(BlockNo: integer; AModbusMode: integer);
    procedure Value2Screen_Analog_ECS_kumo(AName: string; AValue: Integer; AMaxVal: real; AModbusMode: integer);
    procedure Value2Screen_Analog1_ECS_kumo(AName: string; AValue: Integer; AMaxVal: real; AModbusMode: integer);
    procedure Value2Screen_Analog2_ECS_kumo(AName: string; AValue: Integer; AMaxVal: real; AModbusMode: integer);
    procedure Value2Screen_Analog3_ECS_kumo(AName: string; AValue: Integer; AMaxVal: real; AModbusMode: integer);
    procedure Value2Screen_Digital_ECS_kumo(Name: string; AValue: Integer;
                                    AMaxVal: real; AContact: integer);
    procedure Value2Screen_Digital1_ECS_kumo(Name: string; AValue: Integer;
                                    AMaxVal: real; AContact: integer);
    procedure Value2Screen_Digital2_ECS_kumo(Name: string; AValue: Integer;
                                    AMaxVal: real; AContact: integer);

    function CheckEngineRunning(ARpm: integer): Boolean;

    procedure LoadConfigDataXml2Var;
    procedure LoadConfigDataVar2Form(AMonitorConfigF : TModbusConfigF);
    procedure SaveConfigData2Xml;
    procedure SaveConfigDataForm2Xml(AMonitorConfigF : TModbusConfigF);
    procedure SetConfigData;

    procedure AddMessage2List(Msg: string);
    procedure DisplayMessage2SB(Msg: string);

  public
    FIPCMonitor_ECS_kumo: TIPCMonitor_ECS_kumo;//AVAT ECS
  end;

var
  FrmEngineMonitoring: TFrmEngineMonitoring;

implementation

{$R *.dfm}

procedure TFrmEngineMonitoring.AddMessage2List(Msg: string);
begin
  if FMsgList.IndexOf(Msg) = -1 then
    FMsgList.Add(Msg);
end;

function TFrmEngineMonitoring.CheckEngineRunning(ARpm: integer): Boolean;
begin
  if FConfigOption.UseECUEngineRunningSignal then
  begin
    Result := FEngineRunning;
  end
  else
  begin
    if not FEngineRunning then
      Result :=  ARpm > FConfigOption.RunningRPM
    else
      Result := ARpm < FConfigOption.NotRunningRPM;

    FEngineRunning := Result;
  end;

end;

procedure TFrmEngineMonitoring.DisplayMessage2SB(Msg: string);
begin
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := Msg;
end;

procedure TFrmEngineMonitoring.ECS_OnSignal(Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo);
var
  i,dcount: integer;
begin
  if not FMonitorStart then
    exit;

  FillChar(FECSData.InpDataBuf[0], High(FECSData.InpDataBuf) - 1, #0);
  FECSData.ModBusMode := Data.ModBusMode;
  
  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FECSData.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData div 2;
    FECSData.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FECSData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FECSData.InpDataBuf[i] := FECSData.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//      FModBusData.InpDataBuf[i] :=  ;
    end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end
  else
  if (Data.ModBusMode = 3) then //RTU mode simulate 이면
  begin
    dcount := Data.NumOfData;
    FECSData.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf_double, FECSData.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
  end;//Data.ModBusMode = 3

  FECSData.ModBusAddress := Data.ModBusAddress;

  FECSData.NumOfData := dcount;
  FECSData.ModBusFunctionCode := Data.ModBusFunctionCode;

  DisplayMessage2SB(FECSData.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_ECS, 0,0);
end;

procedure TFrmEngineMonitoring.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FStopWatch.Stop;
  FConfigOption.RunHour := FStopWatch.AccumulatedTicks;
  SaveConfigData2Xml;
  
  //FIPCMonitor_ECS_kumo.FMonitorEvent.Pulse;
  FIPCMonitor_ECS_kumo.Terminate;
  FStopWatch.Free;
  FMsgList.Free;
  FExhTempAvg_A.Free;
  FExhTempAvg_B.Free;
  FConfigOption.Free;
  ObjFree(FAddressMap);
  FAddressMap.free;
  FCriticalSection.Free;
end;

procedure TFrmEngineMonitoring.FormCreate(Sender: TObject);
begin
  Application.OnMessage := pjhMouseEvent;

  FIPCMonitor_ECS_kumo := TIPCMonitor_ECS_kumo.Create(0, ECS_SHARE_NAME, True);
  FIPCMonitor_ECS_kumo.OnSignal := ECS_OnSignal;
  FIPCMonitor_ECS_kumo.FreeOnTerminate := True;
  FIPCMonitor_ECS_kumo.Resume;

  FAddressMap := DMap.Create;
  FMsgList := TStringList.Create;
  FConfigOption := TConfigOption.Create(nil);
  LoadConfigDataXml2Var;
  FExhTempAvg_A := TCircularArray.Create(FConfigOption.AverageSize);
  FExhTempAvg_B := TCircularArray.Create(FConfigOption.AverageSize);

  FCriticalSection := TCriticalSection.Create;
  FStopWatch := TStopWatch.Create;
  FStopWatch.AccumulatedTicks := FConfigOption.RunHour;

  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FMonitorStart := False;
  FAnalogEnter := False;
end;

procedure TFrmEngineMonitoring.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LCtrl: TWinControl;
begin
{  if not DesignMode1.Checked then
    exit;

  LCtrl := FindVCLWindow(Mouse.CursorPos);

  if LCtrl <> nil then
  begin
    SelectOnRunTime1.SelectControl := nil;
    SelectOnRunTime1.SelectControl := TControl(LCtrl);
    //SelectOnRunTime1.SelectControl.PopupMenu := PopupMenu2;
  end;}
end;

procedure TFrmEngineMonitoring.LoadConfigDataVar2Form(
  AMonitorConfigF: TModbusConfigF);
begin
  AMonitorConfigF.MapFilenameEdit.FileName := FConfigOption.ModbusFileName;
  AMonitorConfigF.AvgEdit.Text := IntToStr(FConfigOption.AverageSize);
  AMonitorConfigF.RunRPMEdit.Text := IntToStr(FConfigOption.RunningRPM);
  AMonitorConfigF.NotRunRPMEdit.Text := IntToStr(FConfigOption.NotRunningRPM);
  AMonitorConfigF.RunHourEdit.Text := IntToStr(FConfigOption.RunHour);
  AMonitorConfigF.UseECUSignalCB.Checked := FConfigOption.UseECUEngineRunningSignal;
end;

procedure TFrmEngineMonitoring.LoadConfigDataXml2Var;
var
  Lstr: string;
begin
  //Lstr := ExtractFileName(Application.ExeName);
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);
  if FileExists(LStr) then
    FConfigOption.LoadFromFile(Lstr, '', False);
end;

function TFrmEngineMonitoring.ModBusValueResolve(value: integer; max: real;
  datatype: TDataType): string;
var tmpvalue: real;
begin
  case datatype of
    dtmA:begin
      tmpvalue := (value * max) / 32767;
      Result := Real2Str(tmpvalue,2);
    end;

    dtRTD, dtTC:
      if max <> 0 then
        Result := IntToStr(value div Round(max))
      else
        Result := '0';
    //들어오는 값 그대로 표시함
    dtDirect: Result := IntToStr(value);
    //Digital 값인 경우
    dtDigital:begin
      if Value > 0 then  //$FF로 들어옴
        Result := 'ON'
      else
        Result := 'OFF';
    end;

    dtKumo: begin
      tmpvalue := (value * max) / 4095;
      Result := Real2Str(tmpvalue,2);
    end;
  end;//case
end;

procedure TFrmEngineMonitoring.pjhMouseEvent(var Msg: TMsg;
  var Handled: boolean);
begin
  case Msg.message of
    WM_LBUTTONDOWN: begin
      FormMouseDown(self, mbLeft, [], Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
  end;
end;

procedure TFrmEngineMonitoring.ReadMapAddress(AddressMap: DMap; MapFileName: string);
var
  sqltext: string;
  sqlresult, reccnt, fldcnt: integer;
  i: integer;
  filename, fcode: string;
  shbtn: TShadowButton;
begin
  if fileexists(MapFileName) then
  begin
    Filename := ExtractFileName(MapFileName);
    FileName := Copy(Filename,1, Pos('.',Filename) - 1);
    FMapFilePath := ExtractFilePath(MapFileName);
    FjanDB :=TjanSQL.create;
    try
      sqltext := 'connect to ''' + FMapFilePath + '''';

      sqlresult := FjanDB.SQLDirect(sqltext);
      //Connect 성공
      if sqlresult <> 0 then
      begin
        with FjanDB do
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
                FHiMap := THiMap.Create;
                with FHiMap, RecordSets[SqlResult].Records[i] do
                begin
                  FName := Fields[0].Value;
                  FDescription := Fields[1].Value;
                  FSid := StrToInt(Fields[2].Value);
                  FAddress := Fields[3].Value;
                  FBlockNo := StrToInt(Fields[4].Value);
                  //kumo ECS를 Value2Screen_ECS_kumo 함수에서 처리하기 위함
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

                AddressMap.PutPair([fcode + FHiMap.FAddress,FHiMap]);
              end;//for
            end;

          end
          else
            DisplayMessage2SB(FjanDB.Error);
        end;//with
      end
      else
        Application.MessageBox('Connect 실패',
            PChar('폴더 ' + FFilePath + ' 를 만든 후 다시 하시오'),MB_ICONSTOP+MB_OK);
    finally
      FjanDB.Free;
    end;
  end
  else
  begin
    sqltext := FileName + '파일을 만든 후에 다시 하시오';
    Application.MessageBox('Data file does not exist!', PChar(sqltext) ,MB_ICONSTOP+MB_OK);
  end;
end;

procedure TFrmEngineMonitoring.SaveConfigData2Xml;
var
  Lstr: string;
begin
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);
  FConfigOption.SaveToFile(Lstr, '', False);
end;

procedure TFrmEngineMonitoring.SaveConfigDataForm2Xml(AMonitorConfigF : TModbusConfigF);
var
  Lstr: string;
begin
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);

  FConfigOption.ModbusFileName := AMonitorConfigF.MapFilenameEdit.FileName;
  FConfigOption.AverageSize := StrToIntDef(AMonitorConfigF.AvgEdit.Text,1);
  FConfigOption.RunningRPM := StrToIntDef(AMonitorConfigF.RunRPMEdit.Text,0);
  FConfigOption.NotRunningRPM := StrToIntDef(AMonitorConfigF.NotRunRPMEdit.Text,0);
  FConfigOption.RunHour := StrToIntDef(AMonitorConfigF.RunHourEdit.Text,0);
  FConfigOption.UseECUEngineRunningSignal := AMonitorConfigF.UseECUSignalCB.Checked;

  FConfigOption.SaveToFile(Lstr, '', False);
end;

procedure TFrmEngineMonitoring.SetConfig1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TFrmEngineMonitoring.SetConfigData;
var EngMonitorConfigF: TModbusConfigF;
begin
  EngMonitorConfigF := TModbusConfigF.Create(Application);
  with EngMonitorConfigF do
  begin
    try
      LoadConfigDataVar2Form(EngMonitorConfigF);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2Xml(EngMonitorConfigF);
        LoadConfigDataXml2Var;
        FExhTempAvg_A.Size := FConfigOption.AverageSize;
        FExhTempAvg_B.Size := FConfigOption.AverageSize;
        FAddressMap.clear;
        ReadMapAddress(FAddressMap,FConfigOption.ModbusFileName);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TFrmEngineMonitoring.Timer1Timer(Sender: TObject);
var
  LStr: string;
begin
  Timer1.Enabled := False;
  try
    if FMonitorStart then
    begin
      //DisplayMessage2SB('');
    end
    else
    begin
      ReadMapAddress(FAddressMap,FConfigOption.ModbusFileName);
      RunHourPanel.Caption := FStopWatch.Elapsed;
    end;

    DateTimeToString(LStr, 'yyyy.m.d hh:nn:ss', now);
    DateTimePanel.Caption := LStr;
    if FEngineRunning then
      RunHourPanel.Caption := FStopWatch.CurrentElapsed;
  finally
    if not FMonitorStart then
      FMonitorStart := True;

    Timer1.Enabled := True;
  end;//try
end;

procedure TFrmEngineMonitoring.UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo);
var
  it: DIterator;
  pHiMap: THiMap;
  i, j, BlockNo: integer;
  tmpStr: string;
  tmpByte, ProcessBitCnt: Byte;
  IsFirst, IsSecond: Boolean;
begin
  BlockNo := 0;
  i := 0;
  j := 0;
  ProcessBitCnt := 0;

  IsFirst := True;
  IsSecond := False;

  if FECSData.ModBusMode = 3 then //RTU mode simulated
  begin
    it := FAddressMap.start;
  end
  else
  begin
    tmpStr := IntToStr(FECSData.ModBusFunctionCode) + FECSData.ModBusAddress;
    it := FAddressMap.locate( [tmpStr] );
  end;

  SetToValue(it);

  while not atEnd(it) do
  begin
    if i > FECSData.NumOfData - 1 then
      break;

    pHiMap := GetObject(it) as THiMap;

    if (FECSData.ModBusFunctionCode = 3) or (FECSData.ModBusFunctionCode = 4) then
    begin
      if FECSData.ModBusMode = 3 then
        pHiMap.FValue := FECSData.InpDataBuf_double[i]
      else
        pHiMap.FValue := FECSData.InpDataBuf[i];

      Inc(i);
      BlockNo := pHiMap.FBlockNo;
      Advance(it);
    end
    else
    begin
      BlockNo := pHiMap.FBlockNo;
      for i := 0 to FECSData.NumOfData - 1 do
      begin
        tmpByte := Hi(FECSData.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;

        tmpByte := Lo(FECSData.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;
      end;

      if ((FECSData.NumOfBit div 8) mod 2) > 0 then
      begin
        tmpByte := Lo(FECSData.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;
      end;
    end;

  end;//while

  DisplayMessage2SB(FECSData.ModBusAddress + ' 처리중...');

  //수신된 데이타를 화면에 뿌려줌
  Value2Screen_ECS_kumo(BlockNo,FECSData.ModBusMode);
end;

procedure TFrmEngineMonitoring.Value2Screen_Analog1_ECS_kumo(AName: string;
  AValue: Integer; AMaxVal: real; AModbusMode: integer);
var
  LisPress: boolean;
  LComponent, LComponent2: TComponent;
  Le: Single;
  LPos: integer;
  LStr: string;
begin
  FCriticalSection.Enter;

  FAnalogEnter := True;
  try
    LisPress := False;
    LComponent2 := nil;

    LComponent := FindComponent(AName);
    if Assigned(LComponent) then
    begin
      if AModbusMode = 3 then
        Le := AValue
      else
        Le := (AValue * AMaxVal) / 4095;
        //Le := AValue;

      if (AName = 'AI_ENGINERPM') then //Engine RPM
      begin
        with TPanel(LComponent) do
          Caption := IntToStr(Round(Le));

        with TiAngularGauge(FindComponent(AName+'_G')) do
          Position := Round(Le);

        with TPanel(FindComponent(AName+'_P')) do
          Caption := IntToStr(Round(Le));

        if CheckEngineRunning(Round(Le)) then
        begin
          FStopWatch.Start;
        end
        else
        begin
          FStopWatch.Stop;
        end;
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
          //H4660은 18H 이므로 Air Cooler Temp가 연결됨
          if (Pos('AI_EXH_A_10',AName) > 0) or (Pos('AI_EXH_B_10',AName) > 0) then
          begin
            TiAnalogDisplay(LComponent).Value := Le;
            exit;
          end;

          LComponent2 := FindComponent(AName+'_L');
          if Assigned(LComponent2) then
            TiLedBar(LComponent2).Position := Round(Le);

          //TiSevenSegmentInteger(LComponent).Value := Round(Le);
          TPanel(LComponent).Caption := IntToStr(Round(Le));


          LPos := Pos('AI_EXH_A_',AName);
          if LPos > 0 then
          begin //평균값이 나타나지 않을 경우 환경설정에서 Ave size를 조정 할 것
            LStr := Copy(AName,LPos+9,Length(AName)-LPos-8);
            if StrToIntDef(LStr,FConfigOption.AverageSize+1) <= FConfigOption.AverageSize then
            begin //숫자가 아닌것은 FConfigOption.AverageSize 보다 1 크게
              FExhTempAvg_A.Put(Le);
              LComponent2 := FindComponent('AI_EXH_A_Avg');
              if Assigned(LComponent2) then
                TPanel(LComponent2).Caption := IntToStr(Round(FExhTempAvg_A.Average));
                //TiSevenSegmentInteger(LComponent2).Value := Round(FExhTempAvg_A.Average);

              LComponent2 := nil;
              LComponent2 := FindComponent('AI_EXH_A_Avg_L');
              if Assigned(LComponent2) then
                TiLedBar(LComponent2).Position := Round(FExhTempAvg_A.Average);
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
                FExhTempAvg_B.Put(Le);
                LComponent2 := FindComponent('AI_EXH_B_Avg');
                if Assigned(LComponent2) then
                  TPanel(LComponent2).Caption := IntToStr(Round(FExhTempAvg_B.Average));
                  //TiSevenSegmentInteger(LComponent2).Value := Round(FExhTempAvg_B.Average);

                LComponent2 := nil;
                LComponent2 := FindComponent('AI_EXH_B_Avg_L');
                if Assigned(LComponent2) then
                  TiLedBar(LComponent2).Position := Round(FExhTempAvg_B.Average);
              end;
            end;
          end;
        end
        else if System.Pos('AI_MAINBERGTEMP',AName) > 0 then
        begin
          LComponent2 := FindComponent(AName+'_L');
          if Assigned(LComponent2) then
            TiLedBar(LComponent2).Position := Round(Le);
          TPanel(LComponent).Caption := IntToStr(Round(Le));
          //TiSevenSegmentInteger(LComponent).Value := Round(Le);
        end
        else if System.Pos('AI_STARTINGAIRPRESS',AName) > 0 then
        begin
          TiAnalogDisplay(LComponent).Value := Le/CmmWC;
          //TiSevenSegmentInteger(LComponent).Value := Round(Le);
        end
        else
        begin
          with TiAnalogDisplay(LComponent) do
          begin
            Value := Le;
            {if LisPress then
              Caption := format('%.2f', [AValue * AMaxVal])
            else
              Caption := format('%.f', [AValue * AMaxVal]);
            }
          end;
        end;
      end;
    end;//if Assigned(LComponent)
  finally
    FAnalogEnter := False;
  end;
  FCriticalSection.Leave;
end;

procedure TFrmEngineMonitoring.Value2Screen_Analog2_ECS_kumo(AName: string;
  AValue: Integer; AMaxVal: real; AModbusMode: integer);
var
  LisPress: boolean;
  LComponent, LComponent2: TComponent;
  Le, Le2: Single;
  LPos: integer;
  LStr: string;
begin
  FCriticalSection.Enter;

  FAnalogEnter := True;
  try
    LisPress := False;
    LComponent2 := nil;

    LComponent := FindComponent(AName+'_');
    if Assigned(LComponent) then
    begin
      if AModbusMode = 3 then
        Le := AValue
      else
        Le := (AValue * AMaxVal) / 4095;

      if (AName = 'AI_ENGINERPM_') then //Engine RPM
      begin
        with TPanel(LComponent) do
          Caption := IntToStr(Round(Le));

        with TiAngularGauge(FindComponent(AName+'_G_')) do
          Position := Round(Le);

        with TPanel(FindComponent(AName+'_P_')) do
          Caption := IntToStr(Round(Le));

        if CheckEngineRunning(Round(Le)) then
        begin
          FStopWatch.Start;
        end
        else
        begin
          FStopWatch.Stop;
        end;
      end
      else if (AName = 'AI_TC_A_RPM_') or (AName = 'AI_TC_B_RPM_') then
      begin
        with TPanel(LComponent) do
          Caption := IntToStr(Round(Le));

        with TiAngularGauge(FindComponent(AName+'_G_')) do
          Position := Round(Le);

        with TPanel(FindComponent(AName+'_P_')) do
          Caption := IntToStr(Round(Le));
      end
      else
      begin
        if System.Pos('AI_EXH_',AName) > 0 then
        begin
          LComponent2 := FindComponent(AName+'_L_');
          if Assigned(LComponent2) then
            TiLedBar(LComponent2).Position := Round(Le);

          TPanel(LComponent).Caption := IntToStr(Round(Le));


          LPos := Pos('AI_EXH_A_',AName);
          if LPos > 0 then
          begin //평균값이 나타나지 않을 경우 환경설정에서 Ave size를 조정 할 것
            LStr := Copy(AName,LPos+9,Length(AName)-LPos-8);
            if StrToIntDef(LStr,FConfigOption.AverageSize+1) <= FConfigOption.AverageSize then
            begin //숫자가 아닌것은 FConfigOption.AverageSize 보다 1 크게
              FExhTempAvg_A.Put(Le);
              LComponent2 := FindComponent('AI_EXH_A_Avg_');
              if Assigned(LComponent2) then
                TPanel(LComponent2).Caption := IntToStr(Round(FExhTempAvg_A.Average));

              LComponent2 := nil;
              LComponent2 := FindComponent('AI_EXH_A_Avg_L_');
              if Assigned(LComponent2) then
                TiLedBar(LComponent2).Position := Round(FExhTempAvg_A.Average);

              //Difference 표시
              Le2 := Le - FExhTempAvg_A.Average;

              LComponent2 := nil;
              LComponent2 := FindComponent(AName + '_Diff');
              if Assigned(LComponent2) then
                TPanel(LComponent2).Caption := IntToStr(Round(Le2));

              if Le2 >= 0 then  //+
              begin
                LComponent2 := nil;
                LComponent2 := FindComponent(AName + '_L_UP');
                if Assigned(LComponent2) then
                  TiLedBar(LComponent2).Position := Round(Le2);

                LComponent2 := nil;
                LComponent2 := FindComponent(AName + '_L_DOWN');
                if Assigned(LComponent2) then
                  TiLedBar(LComponent2).Position := 0;
              end
              else  //-
              begin
                LComponent2 := nil;
                LComponent2 := FindComponent(AName + '_L_DOWN');
                if Assigned(LComponent2) then
                  TiLedBar(LComponent2).Position := Round(ABS(Le2));

                LComponent2 := nil;
                LComponent2 := FindComponent(AName + '_L_UP');
                if Assigned(LComponent2) then
                  TiLedBar(LComponent2).Position := 0;
              end;
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
                FExhTempAvg_B.Put(Le);
                LComponent2 := FindComponent('AI_EXH_B_Avg_');
                if Assigned(LComponent2) then
                  TPanel(LComponent2).Caption := IntToStr(Round(FExhTempAvg_B.Average));

                LComponent2 := nil;
                LComponent2 := FindComponent('AI_EXH_B_Avg_L_');
                if Assigned(LComponent2) then
                  TiLedBar(LComponent2).Position := Round(FExhTempAvg_B.Average);

                //Difference 표시
                Le2 := Le - FExhTempAvg_B.Average;

                LComponent2 := nil;
                LComponent2 := FindComponent(AName + '_Diff');
                if Assigned(LComponent2) then
                  TPanel(LComponent2).Caption := IntToStr(Round(Le2));

                if Le2 >= 0 then  //+
                begin
                  LComponent2 := nil;
                  LComponent2 := FindComponent(AName + '_L_UP');
                  if Assigned(LComponent2) then
                    TiLedBar(LComponent2).Position := Round(Le2);

                  LComponent2 := nil;
                  LComponent2 := FindComponent(AName + '_L_DOWN');
                  if Assigned(LComponent2) then
                    TiLedBar(LComponent2).Position := 0;
                end
                else  //-
                begin
                  LComponent2 := nil;
                  LComponent2 := FindComponent(AName + '_L_DOWN');
                  if Assigned(LComponent2) then
                    TiLedBar(LComponent2).Position := Round(ABS(Le2));

                  LComponent2 := nil;
                  LComponent2 := FindComponent(AName + '_L_UP');
                  if Assigned(LComponent2) then
                    TiLedBar(LComponent2).Position := 0;
                end;
              end;
            end;
          end;
        end
        else
        begin
          with TiAnalogDisplay(LComponent) do
          begin
            Value := Le;
              //Caption := format('%.f', [AValue * AMaxVal]);
          end;
        end;
      end;
    end;//if Assigned(LComponent)
  finally
    FAnalogEnter := False;
  end;
  FCriticalSection.Leave;
end;

procedure TFrmEngineMonitoring.Value2Screen_Analog3_ECS_kumo(AName: string;
  AValue: Integer; AMaxVal: real; AModbusMode: integer);
var
  LisPress: boolean;
  LComponent, LComponent2: TComponent;
  Le: Single;
  LPos: integer;
  LStr: string;
begin
  FCriticalSection.Enter;

  FAnalogEnter := True;
  try
    LisPress := False;
    LComponent2 := nil;

    LComponent := FindComponent(AName+'_');
    if Assigned(LComponent) then
    begin
      if AModbusMode = 3 then
        Le := AValue
      else
        Le := (AValue * AMaxVal) / 4095;

      if (AName = 'AI_ENGINERPM_') then //Engine RPM
      begin
        with TPanel(LComponent) do
          Caption := IntToStr(Round(Le));

        with TiAngularGauge(FindComponent(AName+'_G_')) do
          Position := Round(Le);

        with TPanel(FindComponent(AName+'_P_')) do
          Caption := IntToStr(Round(Le));

        if CheckEngineRunning(Round(Le)) then
        begin
          FStopWatch.Start;
        end
        else
        begin
          FStopWatch.Stop;
        end;
      end
      else if (AName = 'AI_TC_A_RPM_') or (AName = 'AI_TC_B_RPM_') then
      begin
        with TPanel(LComponent) do
          Caption := IntToStr(Round(Le));

        with TiAngularGauge(FindComponent(AName+'_G_')) do
          Position := Round(Le);

        with TPanel(FindComponent(AName+'_P_')) do
          Caption := IntToStr(Round(Le));
      end
      else
      begin
        if System.Pos('AI_MAINBERGTEMP',AName) > 0 then
        begin
          LComponent2 := FindComponent(AName+'_L_');
          if Assigned(LComponent2) then
            TiLedBar(LComponent2).Position := Round(Le);
          TPanel(LComponent).Caption := IntToStr(Round(Le));
        end
        else
        begin
          with TiAnalogDisplay(LComponent) do
          begin
            Value := Le;
              //Caption := format('%.f', [AValue * AMaxVal]);
          end;
        end;
      end;
    end;//if Assigned(LComponent)
  finally
    FAnalogEnter := False;
  end;
  FCriticalSection.Leave;
end;

procedure TFrmEngineMonitoring.Value2Screen_Analog_ECS_kumo(AName: string; AValue: Integer;
  AMaxVal: real; AModbusMode: integer);
begin
  case NxPageControl1.ActivePageIndex of
    1: Value2Screen_Analog1_ECS_kumo( AName, AValue, AMaxVal, AModbusMode );
    2: Value2Screen_Analog2_ECS_kumo( AName, AValue, AMaxVal, AModbusMode );
    3: Value2Screen_Analog3_ECS_kumo( AName, AValue, AMaxVal, AModbusMode );
  end;
end;

//AContact: 1 = A접점, 2 = B접점, 3 = C접점
procedure TFrmEngineMonitoring.Value2Screen_Digital1_ECS_kumo(Name: string; AValue: Integer;
  AMaxVal: real; AContact: integer);
var
  rslt: string;
  shbtn: TShadowButton;
  tmponColor, tmpoffColor: TColor;
begin
  shbtn := nil;
  shbtn := TShadowButton(FindComponent(Name));

  if shbtn <> nil then
  begin
    rslt := ModBusValueResolve(AValue,AMaxVal,dtDigital);

    if (FConfigOption.UseECUEngineRunningSignal) and (Name = 'DI_ENGINERUNNING') then
    begin
      if rslt = 'ON' then
        FEngineRunning := True
      else
        FEngineRunning := False;
    end;

    case AContact of
      1: begin
          if shbtn.tag = 100 then
          begin
            tmpOnColor := COLOR_ON2;
            tmpOffColor := COLOR_OFF2;
          end
          else
          begin
            tmpOnColor := COLOR_ON;
            tmpOffColor := COLOR_OFF;
          end;

          if rslt = 'ON' then
            AddMessage2List(shbtn.hint)
            //MsgLed.Caption := shbtn.hint
          else
            //MsgLed.Caption := '';
        end;
      2: begin
          if shbtn.tag = 100 then
          begin
            tmpOnColor := COLOR_OFF2;
            tmpOffColor := COLOR_ON2;
          end
          else
          begin
            tmpOnColor := COLOR_OFF;
            tmpOffColor := COLOR_ON;
          end;

          if rslt = 'OFF' then
          begin
            AddMessage2List(shbtn.hint);
            //MsgLed.Caption := shbtn.hint
          end
          else
            //MsgLed.Caption := '';
        end;
     end;

    if rslt = 'ON' then
      shbtn.Color := tmpOnColor
    else
      shbtn.Color := tmpOffColor;
  end;
end;

procedure TFrmEngineMonitoring.Value2Screen_Digital2_ECS_kumo(Name: string;
  AValue: Integer; AMaxVal: real; AContact: integer);
begin
  Value2Screen_Digital1_ECS_kumo(Name+'_', AValue, AMaxVal, AContact);
end;

procedure TFrmEngineMonitoring.Value2Screen_Digital_ECS_kumo(Name: string;
  AValue: Integer; AMaxVal: real; AContact: integer);
begin
  case NxPageControl1.ActivePageIndex of
    0: Value2Screen_Digital1_ECS_kumo(Name, AValue, AMaxval, AContact);
    1: Value2Screen_Digital2_ECS_kumo(Name, AValue, AMaxval, AContact);
  end;
end;

procedure TFrmEngineMonitoring.Value2Screen_ECS_kumo(BlockNo: integer; AModbusMode: integer);
var
  it: DIterator;
  pHiMap: THiMap;
begin
  if BlockNo = 0 then
    exit;

  it := FAddressMap.start;

  while not atEnd(it) do
  begin
    pHiMap := GetObject(it) as THiMap;

    if pHiMap.FBlockNo = BlockNo then
    begin
      if pHiMap.FAlarm then
        Value2Screen_Analog_ECS_kumo(pHiMap.FName ,pHiMap.FValue, pHiMap.FMaxval,FECSData.ModBusMode)
      else
        Value2Screen_Digital_ECS_kumo(pHiMap.FName ,pHiMap.FValue, pHiMap.FMaxval, pHiMap.FContact);
    end;

    Advance(it);
  end;//while
end;

procedure TFrmEngineMonitoring.Visible1Click(Sender: TObject);
begin
{  Visible1.Checked := not Visible1.Checked;

  if SelectOnRunTime1.SelectControl <> nil then
  begin
    SelectOnRunTime1.SelectControl.Visible := Visible1.Checked;
  end;   }
end;

end.

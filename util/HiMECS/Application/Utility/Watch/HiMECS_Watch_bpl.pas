unit HiMECS_Watch_bpl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, iComponent, iVCLComponent, iCustomComponent,
  iPlotComponent, iPlot, StdCtrls, ExtCtrls,SyncObjs, iniFiles,
  DeCAL, Menus, janSQL, iProgressComponent, iLedBar, ShadowButton,
  iPositionComponent, iScaleComponent, iGaugeComponent, iAngularGauge,
  DragDrop,
  DropTarget,
  DragDropFormats,
  DragDropText,
  WatchConfig, CircularArray, WatchConst, IPCThrd_LBX, IPCThrdMonitor_LBX,
  IPCThrd_WT1600, IPCThrdMonitor_WT1600, IPCThrd_ECS_kumo, IPCThrdMonitor_ECS_kumo,
  IPCThrd_MEXA7000, IPCThrdMonitor_MEXA7000, IPCThrd_MT210, IPCThrdMonitor_MT210,
  IPCThrd_FlowMeter, IPCThrdMonitor_FlowMeter, IPCThrd_DYNAMO, IPCThrdMonitor_DYNAMO,
  IPCThrd_ECS_AVAT, IPCThrdMonitor_ECS_AVAT,
  ModbusComStruct, ConfigOptionClass, DragDropRecord, HiMECSConst, AdvTrackBar,
  SBPro, TimerPool, EngineParameterClass;

type
  TEventData_WT1600_Main = packed record
    IPAddress: string[16];
    URMS1: string[50];
    URMS2: string[50];
    URMS3: string[50];
    IRMS1: string[50];
    IRMS2: string[50];
    IRMS3: string[50];
    PSIGMA: string[50];
    SSIGMA: string[50];
    QSIGMA: string[50];
    RAMDA: string[50];
    FREQUENCY: string[50];
    PowerMeterOn: boolean;
    PowerMeterNo: integer;
  end;

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

  TWatchF2 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    DisplayPanel: TPanel;
    Label1: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    CurLabel: TLabel;
    Button1: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MinLabel: TLabel;
    MaxLabel: TLabel;
    iPlot1: TiPlot;
    WatchLabel: TLabel;
    Timer1: TTimer;
    PopupMenu2: TPopupMenu;
    Add1: TMenuItem;
    CurrentValue1: TMenuItem;
    Average1: TMenuItem;
    MinValue1: TMenuItem;
    MaxValue1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    N1: TMenuItem;
    Displayalldatainthischart1: TMenuItem;
    DropTextTarget1: TDropTextTarget;
    StatusBarPro1: TStatusBarPro;
    AlphaTrackBar: TAdvTrackBar;
    Label4: TLabel;
    AvgPanel: TPanel;
    Label2: TLabel;
    AvgLabel: TLabel;
    N2: TMenuItem;
    Close1: TMenuItem;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CurrentValue1Click(Sender: TObject);
    procedure Average1Click(Sender: TObject);
    procedure MinValue1Click(Sender: TObject);
    procedure MaxValue1Click(Sender: TObject);
    procedure Displayalldatainthischart1Click(Sender: TObject);
    procedure DropTextTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure AlphaTrackBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Close1Click(Sender: TObject);
  private
    FFilePath: string;      //파일을 저장할 경로

    FECSData_kumo: TEventData_ECS_kumo;
    FECSData_AVAT: TEventData_ECS_AVAT;
    FMEXA7000Data: TEventData_MEXA7000_2;
    FLBXData: TEventData_LBX;
    FWT1600Data: TEventData_WT1600_Main;
    FMT210Data: TEventData_MT210;
    FDYNAMOData: TEventData_DYNAMO;

    FCriticalSection: TCriticalSection;
    FPJHTimerPool: TPJHTimerPool;

    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FFirst: Boolean; //타이머 동작 완료하면 True
    FMsgList: TStringList;  //Message를 저장하는 리스트

    FEngineParameterTarget: TEngineParameterDataFormat;
    FEngineParameterItemRecord: TEngineParameterItemRecord; //Main폼으로 부터 파라미터 수신용

    procedure WT1600_OnSignal(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure MEXA7000_OnSignal(Sender: TIPCThread_MEXA7000; Data: TEventData_MEXA7000);
    procedure MT210_OnSignal(Sender: TIPCThread_MT210; Data: TEventData_MT210);
    procedure ECS_OnSignal_kumo(Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo);
    procedure ECS_OnSignal_AVAT(Sender: TIPCThread_ECS_AVAT; Data: TEventData_ECS_AVAT);
    procedure LBX_OnSignal(Sender: TIPCThread_LBX; Data: TEventData_LBX);
    procedure DYNAMO_OnSignal(Sender: TIPCThread_DYNAMO; Data: TEventData_DYNAMO);

    procedure UpdateTrace_WT1600(var Msg: TEventData_WT1600); message WM_EVENT_WT1600;
    procedure UpdateTrace_MEXA7000(var Msg: TEventData_MEXA7000); message WM_EVENT_MEXA7000;
    procedure UpdateTrace_MT210(var Msg: TEventData_MT210); message WM_EVENT_MT210;
    procedure UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo); message WM_EVENT_ECS_KUMO;
    procedure UpdateTrace_ECS_AVAT(var Msg: TEventData_ECS_AVAT); message WM_EVENT_ECS_AVAT;
    procedure UpdateTrace_LBX(var Msg: TEventData_LBX); message WM_EVENT_LBX;
    procedure UpdateTrace_DYNAMO(var Msg: TEventData_DYNAMO); message WM_EVENT_DYNAMO;

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;

    procedure OnChangeDispPanelColor(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure SendFormCopyData(ToHandle: integer; AForm:TForm);
    procedure MoveEngineParameterItemRecord(AEPItemRecord:TEngineParameterItemRecord);
  public
    FOwnerHandle: THandle;//Owner form handle
    FOwnerListIndex: integer;//TList에 저장되는 Index(해제시에 필요함)
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체
    FConfigOption: TConfigOption;

    FIPCMonitor_WT1600: TIPCMonitor_WT1600;//WT1600
    FIPCMonitor_MEXA7000: TIPCMonitor_MEXA7000;//MEXA7000
    FIPCMonitor_MT210: TIPCMonitor_MT210;//MT210
    FIPCMonitor_ECS_kumo: TIPCMonitor_ECS_kumo;//kumo ECS
    FIPCMonitor_ECS_AVAT: TIPCMonitor_ECS_AVAT;//AVAT ECS
    FIPCMonitor_LBX: TIPCMonitor_LBX;//LBX
    FIPCMonitor_FlowMeter: TIPCMonitor_FlowMeter;//FlowMeter
    FIPCMonitor_Dynamo: TIPCMonitor_Dynamo;//DynamoMeter

    //FSharedName: string;//공유 메모리 이름
    //FFuncCode: string;//Modbus Function Code
    //FAddress: string;//Modbus Address
    FLabelName: string; //모니터링하고자 하는 데이타의 이름을 저장함.
    FWatchName: string; //component 이름을 저장함.(FunctionCode+Address)
    FWatchValue: string; //모니터링 데이타

    //Option변경시에 파일이름이 같을 경우 Readmap을 하지 않기 위해 필요함
    FCurrentModbusFileName: string;

    FWatchValueRecord: TEventData_MEXA7000; //유승원 요청사항, 모든 데이타를 한개의 차트에 표시하기 위함.
    FDisplayAllData: Boolean; //한개의 차트에 모두 표시할려면 True

    FWatchValueMin: double; //Min data
    FWatchValueMax: double; //Max data
    FWatchValueSum: double; //Sum data
    FWatchValueAvg: double; //Average data
    FWatchValueAry: array of double;
    FWatchCA: TCircularArray;// Circular Array
    FCurrentAryIndex: integer; //처음에 배열에 저장시에 평균값 구하기 위함
    FFirstCalcAry: boolean; //처음 배열을 채워갈때는 True, 한번 다 채우면 False

    FIsCurrentValueGraph: boolean;//현재값을 그래프로 표현하면 True
    FCurrentValueChannel: integer;// FIsCurrentValueGraph=true 일 경우 채널 번호
    FCurrentValueX: double;

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
    procedure WatchValue2Screen_Analog(Name: string; AValue: string; AIsFloat: Boolean = false);
    procedure Value2Screen_ECS_kumo(AHiMap: THiMap);
    procedure Value2Screen_ECS_AVAT(AHiMap: THiMap);
    procedure Value2Screen_Analog_ECS_kumo(AName: string; AValue: Integer; AMaxVal: real);
    procedure Value2Screen_Digital_ECS(Name: string; AValue: Integer;
                                    AMaxVal: real; AContact: integer);

    procedure DisplayMessage2SB(Msg: string);
    procedure ChangeDispPanelColor(AColor: TColor);

    procedure ApplyAvgSize;
    procedure ApplyOption;
    procedure CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSkumoIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSAVATIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateWT1600IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateMT210IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateMEXA7000IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateLBXIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateFlowMeterIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateDynamoIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);

    procedure DestroyIPCMonitor(AExceptIPCMonitor: TParameterSource);

    procedure LoadConfigDataXml2Var;
    procedure LoadConfigDataVar2Form(AMonitorConfigF : TWatchConfigF);
    procedure SaveConfigData2Xml;
    procedure SaveConfigDataForm2Xml(AMonitorConfigF : TWatchConfigF);
    procedure SetConfigData;
    procedure SetAlarm4OriginalOption(AValue: double);
    procedure SetAlarm4ThisOption(AValue: double);
  end;

var
  WatchF2: TWatchF2;

implementation

uses CommonUtil;

{$R *.dfm}

procedure Create_HiMECS_Watchp_bpl;
begin
  TWatchF2.Create(Application);
end;


procedure TWatchF2.InitVar;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FCriticalSection := TCriticalSection.Create;
  FAddressMap := DMap.Create;
  FConfigOption := TConfigOption.Create(nil);

  FEngineParameterTarget := TEngineParameterDataFormat.Create(DropTextTarget1);
  FPJHTimerPool := TPJHTimerPool.Create(nil);

  { Pipe로 생성 클래스 수신 후 생성 할 것
  FIPCMonitor_WT1600 := TIPCMonitor_WT1600.Create(nil);
  FIPCMonitor_MEXA7000 := TIPCMonitor_MEXA7000.Create(nil);
  FIPCMonitor_MT210 := TIPCMonitor_MT210.Create(nil);
  FIPCMonitor_ECS := TIPCMonitor_ECS.Create(nil);
  FIPCMonitor_LBX := TIPCMonitor_LBX.Create(nil);
  }
  FMsgList := TStringList.Create;
  FMonitorStart := False;
  FFirst := True;
  LoadConfigDataXml2Var;

  SetLength(FWatchValueAry, FConfigOption.AverageSize);
  //FillChar(FWatchValueAry,Sizeof(FWatchValueAry) * FAvgSize,0);
  FCurrentAryIndex := 0;
  FFirstCalcAry := True;

  FWatchCA := TCircularArray.Create(FConfigOption.AverageSize);
  ApplyOption;
end;

procedure TWatchF2.LBX_OnSignal(Sender: TIPCThread_LBX; Data: TEventData_LBX);
begin

end;

procedure TWatchF2.LoadConfigDataVar2Form(AMonitorConfigF: TWatchConfigF);
begin
  AMonitorConfigF.MapFilenameEdit.FileName := FConfigOption.ModbusFileName;
  AMonitorConfigF.AvgEdit.Text := IntToStr(FConfigOption.AverageSize);
  AMonitorConfigF.DivisorEdit.Text := IntToStr(FConfigOption.Divisor);

  AMonitorConfigF.SelAlarmValueRG.ItemIndex := FConfigOption.SelectAlarmValue;
  AMonitorConfigF.MinWarnEdit.Text := FloatToStr(FConfigOption.MinWarnValue);
  AMonitorConfigF.MaxWarnEdit.Text := FloatToStr(FConfigOption.MaxWarnValue);
  AMonitorConfigF.MinAlarmEdit.Text := FloatToStr(FConfigOption.MinAlarmValue);
  AMonitorConfigF.MaxAlarmEdit.Text := FloatToStr(FConfigOption.MaxAlarmValue);
  AMonitorConfigF.MinWarnColorSelector.SelectedColor := TColor(FConfigOption.MinWarnColor);
  AMonitorConfigF.MaxWarnColorSelector.SelectedColor := TColor(FConfigOption.MaxWarnColor);
  AMonitorConfigF.MinAlarmColorSelector.SelectedColor := TColor(FConfigOption.MinAlarmColor);
  AMonitorConfigF.MaxAlarmColorSelector.SelectedColor := TColor(FConfigOption.MaxAlarmColor);
  AMonitorConfigF.MinWarnBlinkCB.Checked := FConfigOption.MinWarnBlink;
  AMonitorConfigF.MaxWarnBlinkCB.Checked := FConfigOption.MaxWarnBlink;
  AMonitorConfigF.MaxAlarmBlinkCB.Checked := FConfigOption.MinAlarmBlink;
  AMonitorConfigF.MinAlarmBlinkCB.Checked := FConfigOption.MaxAlarmBlink;
  AMonitorConfigF.ViewAvgValueCB.Checked := FConfigOption.ViewAvgValue;
  AMonitorConfigF.DefaultSoundEdit.FileName := FConfigOption.DefaultSoundFileName;

  case FConfigOption.SelectAlarmValue of
    0: AMonitorConfigF.AlarmValueGB.Enabled := False;
    1: AMonitorConfigF.AlarmValueGB.Enabled := False;
    2: AMonitorConfigF.AlarmValueGB.Enabled := True;
  end;

end;

procedure TWatchF2.LoadConfigDataXml2Var;
var
  Lstr: string;
begin
  //Lstr := ExtractFileName(Application.ExeName);
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);
  if FileExists(LStr) then
    FConfigOption.LoadFromFile(Lstr, '', False);
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

  FConfigOption.SelectAlarmValue := AMonitorConfigF.SelAlarmValueRG.ItemIndex;
  FConfigOption.MinWarnValue := StrToFloatDef(AMonitorConfigF.MinWarnEdit.Text,0.0);
  FConfigOption.MaxWarnValue := StrToFloatDef(AMonitorConfigF.MaxWarnEdit.Text,0.0);
  FConfigOption.MinAlarmValue := StrToFloatDef(AMonitorConfigF.MinAlarmEdit.Text,0.0);
  FConfigOption.MaxAlarmValue := StrToFloatDef(AMonitorConfigF.MaxAlarmEdit.Text,0.0);
  FConfigOption.MinWarnColor := Longint(AMonitorConfigF.MinWarnColorSelector.SelectedColor);
  FConfigOption.MaxWarnColor := Longint(AMonitorConfigF.MaxWarnColorSelector.SelectedColor);
  FConfigOption.MinAlarmColor := Longint(AMonitorConfigF.MinAlarmColorSelector.SelectedColor);
  FConfigOption.MaxAlarmColor := Longint(AMonitorConfigF.MaxAlarmColorSelector.SelectedColor);
  FConfigOption.MinWarnBlink := AMonitorConfigF.MinWarnBlinkCB.Checked;
  FConfigOption.MaxWarnBlink := AMonitorConfigF.MaxWarnBlinkCB.Checked;
  FConfigOption.MinAlarmBlink := AMonitorConfigF.MinAlarmBlinkCB.Checked;
  FConfigOption.MaxAlarmBlink := AMonitorConfigF.MaxAlarmBlinkCB.Checked;
  FConfigOption.ViewAvgValue := AMonitorConfigF.ViewAvgValueCB.Checked;
  FConfigOption.DefaultSoundFileName := AMonitorConfigF.DefaultSoundEdit.FileName;

  FConfigOption.SaveToFile(Lstr);
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

procedure TWatchF2.SetAlarm4OriginalOption(AValue: double);
var
  LSoundF: string;
begin
  if AValue > FEngineParameterItemRecord.FMaxAlarmValue then
  begin
    FCurrentChangeColor := FEngineParameterItemRecord.FMaxAlarmColor;
    FBlinkEnable := FEngineParameterItemRecord.FMaxAlarmBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if FEngineParameterItemRecord.FMaxAlarmSoundEnable then
    begin
      if FEngineParameterItemRecord.FMaxAlarmSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := FEngineParameterItemRecord.FMaxAlarmSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  if AValue > FEngineParameterItemRecord.FMaxWarnValue then
  begin
    FCurrentChangeColor := FEngineParameterItemRecord.FMaxWarnColor;
    FBlinkEnable := FEngineParameterItemRecord.FMaxWarnBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if FEngineParameterItemRecord.FMaxWarnSoundEnable then
    begin
      if FEngineParameterItemRecord.FMaxWarnSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := FEngineParameterItemRecord.FMaxWarnSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  if AValue < FEngineParameterItemRecord.FMinAlarmValue then
  begin
    FCurrentChangeColor := FEngineParameterItemRecord.FMinAlarmColor;
    FBlinkEnable := FEngineParameterItemRecord.FMinAlarmBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if FEngineParameterItemRecord.FMinAlarmSoundEnable then
    begin
      if FEngineParameterItemRecord.FMinAlarmSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := FEngineParameterItemRecord.FMinAlarmSoundFilename;

      ExecuteSound(LSoundF);
    end;
  end
  else
  if AValue < FEngineParameterItemRecord.FMinWarnValue then
  begin
    FCurrentChangeColor := FEngineParameterItemRecord.FMinWarnColor;
    FBlinkEnable := FEngineParameterItemRecord.FMinWarnBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);

    if FEngineParameterItemRecord.FMinWarnSoundEnable then
    begin
      if FEngineParameterItemRecord.FMinWarnSoundFilename = '' then
        LSoundF := FConfigOption.DefaultSoundFileName
      else
        LSoundF := FEngineParameterItemRecord.FMinWarnSoundFilename;

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
  if AValue > FConfigOption.MaxWarnValue then
  begin
    FCurrentChangeColor := FConfigOption.MaxWarnColor;
    FBlinkEnable := FConfigOption.MaxWarnBlink;

    if FBlinkEnable then
      FBlinkOn := not FBlinkOn
    else
      FPJHTimerPool.AddOneShot(OnChangeDispPanelColor,100);
  end
  else
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
  if AValue < FConfigOption.MinWarnValue then
  begin
    FCurrentChangeColor := FConfigOption.MinWarnColor;
    FBlinkEnable := FConfigOption.MinWarnBlink;

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

procedure TWatchF2.Timer1Timer(Sender: TObject);
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
      //Caption := IntToStr(Application.MainFormHandle) + ' ' + IntToStr(GetCurrentProcessid);
      //FSharedName := FWatchName;
      //FIPCMonitor := TIPCMonitor2.Create(0, FSharedName, True);
      //FIPCMonitor.OnSignal := OnSignal;
      //FIPCMonitor.Resume;
    end;
  finally
    FMonitorStart := True;
    Timer1.Enabled := True;
  end;//try

end;

procedure TWatchF2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMonitorStart := False;
  Action := caFree;
  SendMessage(FOwnerHandle, WM_WATCHFORM_CLOSE, FOwnerListIndex, 0);
end;

procedure TWatchF2.UpdateTrace_DYNAMO(var Msg: TEventData_DYNAMO);
begin
;
end;

procedure TWatchF2.UpdateTrace_ECS_AVAT(var Msg: TEventData_ECS_AVAT);
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

  tmpStr := IntToStr(FECSData_AVAT.ModBusFunctionCode) + FECSData_AVAT.ModBusAddress;
  it := FAddressMap.locate( [tmpStr] );
  SetToValue(it);

  while not atEnd(it) do
  begin
    if i > FECSData_AVAT.NumOfData - 1 then
      break;

    pHiMap := GetObject(it) as THiMap;

    if (FECSData_AVAT.ModBusFunctionCode = 3) or (FECSData_AVAT.ModBusFunctionCode = 4) then
    begin
      //BlockNo := pHiMap.FBlockNo;
      if (IntToStr(FECSData_AVAT.ModBusFunctionCode) = FEngineParameterItemRecord.FFCode) and
                (pHiMap.FAddress = FEngineParameterItemRecord.FAddress) then
      begin
        pHiMap.FValue := FECSData_AVAT.InpDataBuf[i];
        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_AVAT(pHiMap);
        break;
     end;

      Inc(i);
      Advance(it);
    end
    else
    begin
      BlockNo := pHiMap.FBlockNo;
      for i := 0 to FECSData_AVAT.NumOfData - 1 do
      begin
        tmpByte := Hi(FECSData_AVAT.InpDataBuf[i]);
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

        tmpByte := Lo(FECSData_AVAT.InpDataBuf[i]);
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

      if ((FECSData_AVAT.NumOfBit div 8) mod 2) > 0 then
      begin
        tmpByte := Lo(FECSData_AVAT.InpDataBuf[i]);
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

      if (IntToStr(FECSData_AVAT.ModBusFunctionCode) = FEngineParameterItemRecord.FFCode) and
                (pHiMap.FAddress = FEngineParameterItemRecord.FAddress) then
      begin
        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_AVAT(pHiMap);
        break;
      end;
    end;//else
  end;//while

  DisplayMessage2SB(FECSData_AVAT.ModBusAddress + ' 처리중...');
end;

procedure TWatchF2.UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo);
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

  tmpStr := IntToStr(FECSData_kumo.ModBusFunctionCode) + FECSData_kumo.ModBusAddress;
  it := FAddressMap.locate( [tmpStr] );
  SetToValue(it);

  while not atEnd(it) do
  begin
    if i > FECSData_kumo.NumOfData - 1 then
      break;

    pHiMap := GetObject(it) as THiMap;

    if (FECSData_kumo.ModBusFunctionCode = 3) or (FECSData_kumo.ModBusFunctionCode = 4) then
    begin
      //BlockNo := pHiMap.FBlockNo;
      if (IntToStr(FECSData_kumo.ModBusFunctionCode) = FEngineParameterItemRecord.FFCode) and
                (pHiMap.FAddress = FEngineParameterItemRecord.FAddress) then
      begin
        pHiMap.FValue := FECSData_AVAT.InpDataBuf[i];
        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_kumo(pHiMap);
        break;
     end;

      Inc(i);
      Advance(it);
    end
    else
    begin
      BlockNo := pHiMap.FBlockNo;
      for i := 0 to FECSData_kumo.NumOfData - 1 do
      begin
        tmpByte := Hi(FECSData_kumo.InpDataBuf[i]);
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

        tmpByte := Lo(FECSData_kumo.InpDataBuf[i]);
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
      end;//for

      if ((FECSData_kumo.NumOfBit div 8) mod 2) > 0 then
      begin
        tmpByte := Lo(FECSData_kumo.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end; //for
      end;

      if (IntToStr(FECSData_kumo.ModBusFunctionCode) = FEngineParameterItemRecord.FFCode) and
                (pHiMap.FAddress = FEngineParameterItemRecord.FAddress) then
      begin
        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_kumo(pHiMap);
        break;
      end;
    end;//else
  end;//while

  DisplayMessage2SB(FECSData_kumo.ModBusAddress + ' 처리중...');

end;

procedure TWatchF2.UpdateTrace_LBX(var Msg: TEventData_LBX);
begin

end;

procedure TWatchF2.UpdateTrace_MEXA7000(var Msg: TEventData_MEXA7000);
begin
  //EngDataF.Nox.Value := FMEXA7000Data.NOx;
  //EngDataF.Noxato2.Value := FMEXA7000Data.CollectedValue;
  WatchValue2Screen_Analog(FLabelName, FWatchValue);
end;

procedure TWatchF2.UpdateTrace_MT210(var Msg: TEventData_MT210);
begin
  //EngDataF.MT210Analog.Value := FMT210Data.FData;
  WatchValue2Screen_Analog(FLabelName, FWatchValue);
end;

procedure TWatchF2.UpdateTrace_WT1600(var Msg: TEventData_WT1600);
begin
  WatchValue2Screen_Analog(FLabelName, FWatchValue);
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

procedure TWatchF2.Value2Screen_ECS_AVAT(AHiMap: THiMap);
var
  Le: Single;
  LIsFloat: boolean;
  LStr: string;
begin
  if AHiMap.FAlarm then //Analog data
  begin
    Le := AHiMap.FValue * AHiMap.FMaxval;

    LIsFloat := IsFloat(Le);

    if LIsFloat then
    begin
      if FEngineParameterItemRecord.FRadixPosition > 1 then
        LStr := IntToStr(FEngineParameterItemRecord.FRadixPosition)
      else
        LStr := '1';

      FWatchValue := format('%.'+LStr+'f',[Le]);
    end
    else
      FWatchValue := IntToStr(Round(Le));

    WatchValue2Screen_Analog(AHiMap.FName, FWatchValue);
  end
  else //Digital data
  begin

  end;
end;

procedure TWatchF2.Value2Screen_ECS_kumo(AHiMap: THiMap);
var
  Le: Single;
begin
  if AHiMap.FAlarm then //Analog data
  begin
    Le := (AHiMap.FValue * AHiMap.FMaxval) / 4095;
    if (AHiMap.FName = 'AI_ENGINERPM') then //Engine RPM
    begin
      FWatchValue := IntToStr(Round(Le));
    end
    else if (AHiMap.FName = 'AI_TC_A_RPM') or (AHiMap.FName = 'AI_TC_B_RPM') then
    begin
      FWatchValue := IntToStr(Round(Le));
    end
    else
    begin
      FWatchValue := IntToStr(Round(Le));
    end;

    WatchValue2Screen_Analog(AHiMap.FName, FWatchValue);
  end
  else //Digital data
  begin

  end;
end;

procedure TWatchF2.DestroyIPCMonitor(AExceptIPCMonitor: TParameterSource);
begin

  if Assigned(FIPCMonitor_WT1600) and (AExceptIPCMonitor <> psWT1600) then
    FreeAndNil(FIPCMonitor_WT1600);

  if Assigned(FIPCMonitor_MEXA7000) and (AExceptIPCMonitor <> psMEXA7000)  then
    FreeAndNil(FIPCMonitor_MEXA7000);

  if Assigned(FIPCMonitor_MT210) and (AExceptIPCMonitor <> psMT210)  then
    FreeAndNil(FIPCMonitor_MT210);

  if Assigned(FIPCMonitor_ECS_kumo) and (AExceptIPCMonitor <> psECS_kumo)  then
    FreeAndNil(FIPCMonitor_ECS_kumo);

  if Assigned(FIPCMonitor_ECS_AVAT) and (AExceptIPCMonitor <> psECS_AVAT)  then
    FreeAndNil(FIPCMonitor_ECS_AVAT);

  if Assigned(FIPCMonitor_LBX) and (AExceptIPCMonitor <> psLBX)  then
    FreeAndNil(FIPCMonitor_LBX);

  if Assigned(FIPCMonitor_Dynamo) and (AExceptIPCMonitor <> psDynamo)  then
    FreeAndNil(FIPCMonitor_Dynamo);
end;

procedure TWatchF2.Displayalldatainthischart1Click(Sender: TObject);
var
  Li : integer;
begin
  Displayalldatainthischart1.Checked := not Displayalldatainthischart1.Checked;
  FDisplayAllData := Displayalldatainthischart1.Checked;

  if FDisplayAllData then
  begin
    for Li := iPlot1.ChannelCount - 1 downto 0 do
    begin
      iPlot1.DeleteChannel(Li);
      //iPlot1.DeleteYAxis(Li);
    end;

    for Li := 0 to MAXCHANNELCOUNT - 1 do
    begin
      FCurrentValueChannel := iPlot1.AddChannel;
      iPlot1.Channel[FCurrentValueChannel].VisibleInLegend := True;
      //iPlot1.AddYAxis;
    end;                                      
    
    FCurrentValueX := 0;
  end;//if
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
  StatusBarPro1.SimplePanel := True;
  StatusBarPro1.SimpleText := Msg;
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
    FWatchName := FEngineParameterTarget.EPD.FFCode + FEngineParameterTarget.EPD.FAddress;
    Label1.Caption := FEngineParameterTarget.EPD.FDescription;

    CreateIPCMonitor(FEngineParameterTarget.EPD);
  end else
    ;//PanelDest.Caption := TDropTextTarget(Sender).Text;
end;

procedure TWatchF2.DYNAMO_OnSignal(Sender: TIPCThread_DYNAMO;
  Data: TEventData_DYNAMO);
begin
;
end;

procedure TWatchF2.ECS_OnSignal_AVAT(Sender: TIPCThread_ECS_AVAT;
  Data: TEventData_ECS_AVAT);
var
  i,dcount: integer;
begin
  if not FMonitorStart then
    exit;

  FillChar(FECSData_AVAT.InpDataBuf[0], High(FECSData_AVAT.InpDataBuf) - 1, #0);
  FECSData_AVAT.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FECSData_AVAT.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData div 2;
    FECSData_AVAT.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FECSData_AVAT.InpDataBuf[i] := FECSData_AVAT.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//      FModBusData.InpDataBuf[i] :=  ;
    end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end;//else

  FECSData_AVAT.ModBusAddress := Data.ModBusAddress;

  FECSData_AVAT.NumOfData := dcount;
  FECSData_AVAT.ModBusFunctionCode := Data.ModBusFunctionCode;

  DisplayMessage2SB(FECSData_AVAT.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_ECS_AVAT, 0,0);
end;

procedure TWatchF2.ECS_OnSignal_kumo(Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo);
var
  i,dcount: integer;
begin
  if not FMonitorStart then
    exit;

  FillChar(FECSData_kumo.InpDataBuf[0], High(FECSData_kumo.InpDataBuf) - 1, #0);
  FECSData_kumo.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FECSData_kumo.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData div 2;
    FECSData_kumo.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FECSData_kumo.InpDataBuf[i] := FECSData_kumo.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//      FModBusData.InpDataBuf[i] :=  ;
    end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end;//else

  FECSData_kumo.ModBusAddress := Data.ModBusAddress;

  FECSData_kumo.NumOfData := dcount;
  FECSData_kumo.ModBusFunctionCode := Data.ModBusFunctionCode;

  DisplayMessage2SB(FECSData_kumo.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_ECS_KUMO, 0,0);

end;

procedure TWatchF2.WatchValue2Screen_Analog(Name: string; AValue: string;
  AIsFloat: Boolean = false);
var
  tmpdouble: double;
  //tmpValue: string;
begin
  //tmpdouble := StrToFloatDef(AValue, 0.0)/FConfigOption.Divisor;
  tmpdouble := StrToFloatDef(AValue, 0.0);
  //tmpValue := format('%.2f',[tmpdouble]);

  FWatchCA.Put(tmpdouble);

  //FWatchValue := FloatToStr(tmpdouble);
  case PageControl1.ActivePageIndex of
    0: begin //simple
      WatchLabel.Caption := AValue;
      AvgLabel.Caption := format('%.2f',[FWatchCA.Average]);

      if FConfigOption.SelectAlarmValue = 2 then //FConfigOption(this) 사용일 경우
        SetAlarm4ThisOption(tmpDouble)
      else
      if FConfigOption.SelectAlarmValue = 1 then //original 사용일 경우
        SetAlarm4OriginalOption(tmpDouble);

    end;
    1: begin //Min/Max
      MinLabel.Caption :=  format('%.2f',[FWatchCA.Min]);//FloatToStr(FWatchValueMin);
      MaxLabel.Caption :=  format('%.2f',[FWatchCA.Max]);//FloatToStr(FWatchValueMax);
      CurLabel.Caption := AValue;
    end;
    2: begin //Graph
      if not FDisplayAllData then
      begin
        if FIsCurrentValueGraph then
        begin
          iPlot1.Channel[FCurrentValueChannel].AddXY(FCurrentValueX, tmpdouble);
          FCurrentValueX := FCurrentValueX + 1;
        end;

        if FIsAverageValueGraph then
        begin
          iPlot1.Channel[FAverageValueChannel].AddXY(FAverageValueX, FWatchCA.Average);
          FAverageValueX := FAverageValueX + 1;
        end;

        if FIsMinValueGraph then
        begin
          iPlot1.Channel[FMinValueChannel].AddXY(FMinValueX, FWatchCA.Min);
          FMinValueX := FMinValueX + 1;
        end;

        if FIsMaxValueGraph then
        begin
          iPlot1.Channel[FMaxValueChannel].AddXY(FMaxValueX, FWatchCA.Max);
          FMaxValueX := FMaxValueX + 1;
        end;
      end;
    end;
    3: begin //Meter
    end;
    4: begin //Bar
    end;
  end;//case
{
  if FDisplayAllData then
  begin
    tmpdouble := StrToFloatDef(FWatchValueRecord.CO2, 0.0);
    iPlot1.Channel[0].AddXY(FCurrentValueX, tmpdouble);
    tmpdouble := StrToFloatDef(FWatchValueRecord.CO_L, 0.0);
    iPlot1.Channel[1].AddXY(FCurrentValueX, tmpdouble);
    tmpdouble := StrToFloatDef(FWatchValueRecord.O2, 0.0);
    iPlot1.Channel[2].AddXY(FCurrentValueX, tmpdouble);
    tmpdouble := StrToFloatDef(FWatchValueRecord.NOx, 0.0);
    iPlot1.Channel[3].AddXY(FCurrentValueX, tmpdouble);
    tmpdouble := StrToFloatDef(FWatchValueRecord.THC, 0.0);
    iPlot1.Channel[4].AddXY(FCurrentValueX, tmpdouble);
    tmpdouble := StrToFloatDef(FWatchValueRecord.CH4, 0.0);
    iPlot1.Channel[5].AddXY(FCurrentValueX, tmpdouble);
    tmpdouble := StrToFloatDef(FWatchValueRecord.non_CH4, 0.0);
    iPlot1.Channel[6].AddXY(FCurrentValueX, tmpdouble);
    tmpdouble := FWatchValueRecord.CollectedValue;
    iPlot1.Channel[7].AddXY(FCurrentValueX, tmpdouble);

    FCurrentValueX := FCurrentValueX + 1;
  end;
}
end;

procedure TWatchF2.WMCopyData(var Msg: TMessage);
begin
  FWatchName := PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^.FFCode +
          PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^.FAddress;
  Label1.Caption := PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^.FDescription;
  //SendFormCopyData(PCopyDataStruct(Msg.LParam)^.dwData, Self);
  Caption := Caption + ': '+ Label1.Caption;
  CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^);
end;

procedure TWatchF2.WT1600_OnSignal(Sender: TIPCThread_WT1600;
  Data: TEventData_WT1600);
begin
  if FWatchName = UpperCase('PSIGMA') then
    FWatchValue := String(Data.PSIGMA)
  else if FWatchName = UpperCase('SSIGMA') then
    FWatchValue := String(Data.SSIGMA)
  else if FWatchName = UpperCase('QSIGMA') then
    FWatchValue := String(Data.QSIGMA)
  else if FWatchName = UpperCase('URMS1') then
    FWatchValue := String(Data.URMS1)
  else if FWatchName = UpperCase('URMS2') then
    FWatchValue := String(Data.URMS2)
  else if FWatchName = UpperCase('URMS3') then
    FWatchValue := String(Data.URMS3)
  else if FWatchName = UpperCase('IRMS1') then
    FWatchValue := String(Data.IRMS1)
  else if FWatchName = UpperCase('IRMS2') then
    FWatchValue := String(Data.IRMS2)
  else if FWatchName = UpperCase('IRMS3') then
    FWatchValue := String(Data.URMS3)
  else if FWatchName = UpperCase('RAMDA') then
    FWatchValue := String(Data.RAMDA)
  else if FWatchName = UpperCase('FREQUENCY') then
    FWatchValue := String(Data.FREQUENCY);


  //FWT1600Data.IpAddress := String(Data.IPAddress);
  //FWT1600Data.PowerMeterNo := Data.PowerMeterNo;
  //FWT1600Data.PowerMeterOn := Data.PowerMeterOn;

  SendMessage(Handle, WM_EVENT_WT1600, 0,0);

end;

procedure TWatchF2.FormDestroy(Sender: TObject);
begin
  FWatchValueAry := nil;

  FCriticalSection.Free;

  ObjFree(FAddressMap);
  FAddressMap.free;
  FConfigOption.Free;
  FEngineParameterTarget.Free;

  if Assigned(FIPCMonitor_WT1600) then
    FreeAndNil(FIPCMonitor_WT1600);

  if Assigned(FIPCMonitor_MEXA7000) then
    FreeAndNil(FIPCMonitor_MEXA7000);

  if Assigned(FIPCMonitor_MT210) then
    FreeAndNil(FIPCMonitor_MT210);

  if Assigned(FIPCMonitor_ECS_kumo) then
    FreeAndNil(FIPCMonitor_ECS_kumo);

  if Assigned(FIPCMonitor_ECS_AVAT) then
    FreeAndNil(FIPCMonitor_ECS_AVAT);

  if Assigned(FIPCMonitor_LBX) then
    FreeAndNil(FIPCMonitor_LBX);

  if Assigned(FIPCMonitor_Dynamo) then
    FreeAndNil(FIPCMonitor_Dynamo);

  FMsgList.Free;
  FWatchCA.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
end;

procedure TWatchF2.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TWatchF2.ChangeDispPanelColor(AColor: TColor);
var
  LColor: TColor;
begin
  DisplayPanel.Color := AColor;
  WatchLabel.Color := DisplayPanel.Color;
  AvgLabel.Color := DisplayPanel.Color;
  Label1.Color := DisplayPanel.Color;
  Label2.Color := DisplayPanel.Color;

  LColor := CalcComplementalColor(DisplayPanel.Color);

  WatchLabel.Font.Color := LColor;
  AvgLabel.Font.Color := LColor;
  Label1.Font.Color := LColor;
  Label2.Font.Color := LColor;
end;

procedure TWatchF2.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TWatchF2.Config1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TWatchF2.CreateDynamoIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_Dynamo) then
    exit;

  DestroyIPCMonitor(psDynamo);

  LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource);
  FIPCMonitor_Dynamo := TIPCMonitor_Dynamo.Create(0, LSM, True);
  FIPCMonitor_Dynamo.OnSignal := Dynamo_OnSignal;
  FIPCMonitor_Dynamo.Resume;
end;

procedure TWatchF2.CreateECSAVATIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_ECS_AVAT) then
    exit;

  DestroyIPCMonitor(psECS_AVAT);

  FAddressMap.clear;
  ReadMapAddress(FAddressMap,FConfigOption.ModbusFileName);

  LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource);
  FIPCMonitor_ECS_AVAT := TIPCMonitor_ECS_AVAT.Create(0, LSM, True);
  FIPCMonitor_ECS_AVAT.OnSignal := ECS_OnSignal_AVAT;
  FIPCMonitor_ECS_AVAT.Resume;
end;

procedure TWatchF2.CreateECSkumoIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_ECS_kumo) then
    exit;

  DestroyIPCMonitor(psECS_kumo);

  FAddressMap.clear;
  ReadMapAddress(FAddressMap,FConfigOption.ModbusFileName);

  LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource);
  FIPCMonitor_ECS_kumo := TIPCMonitor_ECS_kumo.Create(0, LSM, True);
  FIPCMonitor_ECS_kumo.OnSignal := ECS_OnSignal_kumo;
  FIPCMonitor_ECS_kumo.Resume;
end;

procedure TWatchF2.CreateFlowMeterIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_FlowMeter) then
    exit;

  DestroyIPCMonitor(psFlowMeter);

  LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource);
  FIPCMonitor_LBX := TIPCMonitor_LBX.Create(0, LSM, True);
  FIPCMonitor_LBX.OnSignal := LBX_OnSignal;
  FIPCMonitor_LBX.Resume;
end;

procedure TWatchF2.CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
begin
  MoveEngineParameterItemRecord(AEP_DragDrop);

  case TParameterSource(AEP_DragDrop.FParameterSource) of
    psECS_kumo: CreateECSkumoIPCMonitor(AEP_DragDrop);
    psECS_AVAT: CreateECSAVATIPCMonitor(AEP_DragDrop);
    psMT210: CreateMT210IPCMonitor(AEP_DragDrop);
    psMEXA7000: CreateMEXA7000IPCMonitor(AEP_DragDrop);
    psLBX: CreateLBXIPCMonitor(AEP_DragDrop);
    psFlowMeter: CreateFlowMeterIPCMonitor(AEP_DragDrop);
    psWT1600: CreateWT1600IPCMonitor(AEP_DragDrop);
  end;

end;

procedure TWatchF2.CreateLBXIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_LBX) then
    exit;

  DestroyIPCMonitor(psLBX);

  LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource);
  FIPCMonitor_LBX := TIPCMonitor_LBX.Create(0, LSM, True);
  FIPCMonitor_LBX.OnSignal := LBX_OnSignal;
  FIPCMonitor_LBX.Resume;
end;

procedure TWatchF2.CreateMEXA7000IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_MEXA7000) then
    exit;

  DestroyIPCMonitor(psMEXA7000);

  LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource);
  FIPCMonitor_MEXA7000 := TIPCMonitor_MEXA7000.Create(0, LSM, True);
  FIPCMonitor_MEXA7000.OnSignal := MEXA7000_OnSignal;
  FIPCMonitor_MEXA7000.Resume;
end;

procedure TWatchF2.CreateMT210IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_MT210) then
    exit;

  DestroyIPCMonitor(psMT210);

  LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource);
  FIPCMonitor_MT210 := TIPCMonitor_MT210.Create(0, LSM, True);
  FIPCMonitor_MT210.OnSignal := MT210_OnSignal;
  FIPCMonitor_MT210.Resume;
end;

procedure TWatchF2.CreateWT1600IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_WT1600) then
    exit;

  DestroyIPCMonitor(psWT1600);

  LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource);
  FIPCMonitor_WT1600 := TIPCMonitor_WT1600.Create(0, LSM, True);
  FIPCMonitor_WT1600.OnSignal := WT1600_OnSignal;
  FIPCMonitor_WT1600.Resume;
end;

procedure TWatchF2.CurrentValue1Click(Sender: TObject);
begin
  FIsCurrentValueGraph := True;
  FCurrentValueChannel := iPlot1.AddChannel;
  iPlot1.Channel[FCurrentValueChannel].VisibleInLegend := False;
  FCurrentValueX := 0;
  CurrentValue1.Enabled := False;
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

procedure TWatchF2.MoveEngineParameterItemRecord(
  AEPItemRecord: TEngineParameterItemRecord);
begin
  FEngineParameterItemRecord.FLevelIndex := AEPItemRecord.FLevelIndex;
  FEngineParameterItemRecord.FNodeIndex := AEPItemRecord.FNodeIndex;
  FEngineParameterItemRecord.FAbsoluteIndex := AEPItemRecord.FAbsoluteIndex;
  FEngineParameterItemRecord.FMaxValue := AEPItemRecord.FMaxValue;
  FEngineParameterItemRecord.FMaxValue_real := AEPItemRecord.FMaxValue_real;
  FEngineParameterItemRecord.FContact := AEPItemRecord.FContact;

  FEngineParameterItemRecord.FTagName := AEPItemRecord.FTagname;
  FEngineParameterItemRecord.FDescription := AEPItemRecord.FDescription;
  FEngineParameterItemRecord.FAddress := AEPItemRecord.FAddress;
  FEngineParameterItemRecord.FFCode := AEPItemRecord.FFCode;
  FEngineParameterItemRecord.FUnit := AEPItemRecord.FUnit;
  FEngineParameterItemRecord.FRadixPosition := AEPItemRecord.FRadixPosition;

  FEngineParameterItemRecord.FSensorType := AEPItemRecord.FSensorType;
  FEngineParameterItemRecord.FParameterCatetory := AEPItemRecord.FParameterCatetory;
  FEngineParameterItemRecord.FParameterType := AEPItemRecord.FParameterType;
  FEngineParameterItemRecord.FParameterSource := AEPItemRecord.FParameterSource;

  FEngineParameterItemRecord.FMinWarnEnable := AEPItemRecord.FMinWarnEnable;
  FEngineParameterItemRecord.FMaxWarnEnable := AEPItemRecord.FMaxWarnEnable;
  FEngineParameterItemRecord.FMinAlarmEnable := AEPItemRecord.FMinAlarmEnable;
  FEngineParameterItemRecord.FMaxAlarmEnable := AEPItemRecord.FMaxAlarmEnable;

  FEngineParameterItemRecord.FMinWarnValue := AEPItemRecord.FMinWarnValue;
  FEngineParameterItemRecord.FMaxWarnValue := AEPItemRecord.FMaxWarnValue;
  FEngineParameterItemRecord.FMinAlarmValue := AEPItemRecord.FMinAlarmValue;
  FEngineParameterItemRecord.FMaxAlarmValue := AEPItemRecord.FMaxAlarmValue;

  FEngineParameterItemRecord.FMinWarnColor := AEPItemRecord.FMinWarnColor;
  FEngineParameterItemRecord.FMaxWarnColor := AEPItemRecord.FMaxWarnColor;
  FEngineParameterItemRecord.FMinAlarmColor := AEPItemRecord.FMinAlarmColor;
  FEngineParameterItemRecord.FMaxAlarmColor := AEPItemRecord.FMaxAlarmColor;

  FEngineParameterItemRecord.FMinWarnBlink := AEPItemRecord.FMinWarnBlink;
  FEngineParameterItemRecord.FMaxWarnBlink := AEPItemRecord.FMaxWarnBlink;
  FEngineParameterItemRecord.FMinAlarmBlink := AEPItemRecord.FMinAlarmBlink;
  FEngineParameterItemRecord.FMaxAlarmBlink := AEPItemRecord.FMaxAlarmBlink;

  FEngineParameterItemRecord.FMinWarnSoundEnable := AEPItemRecord.FMinWarnSoundEnable;
  FEngineParameterItemRecord.FMaxWarnSoundEnable := AEPItemRecord.FMaxWarnSoundEnable;
  FEngineParameterItemRecord.FMinAlarmSoundEnable := AEPItemRecord.FMinAlarmSoundEnable;
  FEngineParameterItemRecord.FMaxAlarmSoundEnable := AEPItemRecord.FMaxAlarmSoundEnable;

  FEngineParameterItemRecord.FMinWarnSoundFilename := AEPItemRecord.FMinWarnSoundFilename;
  FEngineParameterItemRecord.FMaxWarnSoundFilename := AEPItemRecord.FMaxWarnSoundFilename;
  FEngineParameterItemRecord.FMinAlarmSoundFilename := AEPItemRecord.FMinAlarmSoundFilename;
  FEngineParameterItemRecord.FMaxAlarmSoundFilename := AEPItemRecord.FMaxAlarmSoundFilename;
end;

procedure TWatchF2.MT210_OnSignal(Sender: TIPCThread_MT210;
  Data: TEventData_MT210);
begin
  {FMT210Data.FUnit := Data.FUnit;
  FMT210Data.FState := Data.FState;
  FMT210Data.FData := Data.FData;
  }
  FWatchValue := FloatToStr(Data.FData);

  SendMessage(Handle, WM_EVENT_MT210, 0,0);
end;

procedure TWatchF2.OnChangeDispPanelColor(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  ChangeDispPanelColor(TColor(FCurrentChangeColor));
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
    sqltext := FileName + '파일을 만든 후에 다시 하시오';
    Application.MessageBox('Data file does not exist!', PChar(sqltext) ,MB_ICONSTOP+MB_OK);
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

procedure TWatchF2.MEXA7000_OnSignal(Sender: TIPCThread_MEXA7000;
  Data: TEventData_MEXA7000);
begin
  if FWatchName = UpperCase('CO2') then
    FWatchValue := FloatToStr(StrToFloatDef(Data.CO2, 0.0)/10000)
  else if FWatchName = UpperCase('CO_L') then
    FWatchValue := Data.CO_L
  else if FWatchName = UpperCase('O2') then
    FWatchValue := FloatToStr(StrToFloatDef(Data.O2, 0.0)/10000)
  else if FWatchName = UpperCase('NOx') then
    FWatchValue := Data.NOx
  else if FWatchName = UpperCase('THC') then
    FWatchValue := Data.THC
  else if FWatchName = UpperCase('CH4') then
    FWatchValue := Data.CH4
  else if FWatchName = UpperCase('non_CH4') then
    FWatchValue := Data.non_CH4
  else if FWatchName = UpperCase('CollectedValue') then
    FWatchValue := FloatToStr(Data.CollectedValue);

  SendMessage(Handle, WM_EVENT_MEXA7000, 0,0);
end;

procedure TWatchF2.AlphaTrackBarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  AlphaBlendValue := AlphaTrackBar.Position;
end;

procedure TWatchF2.ApplyAvgSize;
begin
  FCriticalSection.Enter;
  try
    SetLength(FWatchValueAry, FConfigOption.AverageSize);
    FCurrentAryIndex := 0;
    FFirstCalcAry := True;
    FWatchCA.Size := FConfigOption.AverageSize;
  finally
    FCriticalSection.Leave;
  end;//try
end;

procedure TWatchF2.ApplyOption;
begin
  if FCurrentModbusFileName <> FConfigOption.ModbusFileName then
  begin
    if FileExists(FConfigOption.ModbusFileName) then
    begin
      if Assigned(FIPCMonitor_ECS_kumo) or Assigned(FIPCMonitor_ECS_AVAT) then
      begin
        FAddressMap.clear;
        ReadMapAddress(FAddressMap,FConfigOption.ModbusFileName);
      end;
    end;
  end;

  AvgPanel.Visible := FConfigOption.ViewAvgValue;
end;

procedure TWatchF2.FormShow(Sender: TObject);
begin
  Label1.Caption := FLabelName;
  Label3.Caption := FLabelName;
  Self.Caption := Self.Caption + ' :: ' + FLabelName;
end;

procedure TWatchF2.Button1Click(Sender: TObject);
begin
  FWatchValueMax := 0;
  FWatchValueMin := 0;
end;

exports //The export name is Case Sensitive
  Create_HiMECS_Watchp_bpl;

end.





unit WT1600_Watch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, iComponent, iVCLComponent, iCustomComponent,
  iPlotComponent, iPlot, StdCtrls, ExtCtrls,SyncObjs, iniFiles,
  IPCThrd_WT1600, IPCThrdMonitor_WT1600, WT1600_Watchonfig,//janSQL,
  WT1600ComStruct, WT1600Const, Menus, iProgressComponent, iLedBar,
  iPositionComponent, iScaleComponent, iGaugeComponent, iAngularGauge;

type
  TWatchF = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Panel2: TPanel;
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
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    Label10: TLabel;
    AvgEdit: TEdit;
    UpDown1: TUpDown;
    Button2: TButton;
    Label2: TLabel;
    AvgLabel: TLabel;
    iAngularGauge1: TiAngularGauge;
    iLedBar1: TiLedBar;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FFilePath: string;      //파일을 저장할 경로
    FIPCMonitor: TIPCMonitor_WT1600;//공유 메모리 및 이벤트 객체
    FWT1600Data: TWMWT1600Data;
    FCriticalSection: TCriticalSection;
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FMsgList: TStringList;  //Message를 저장하는 리스트

    procedure OnSignal(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure UpdateTraceData(var Msg: TWMWT1600Data); message WM_WT1600DATA;
  public
    FSharedName: string;//공유 메모리 이름
    FLabelName: string; //모니터링하고자 하는 데이타의 이름을 저장함.
    FWatchName: string; //component 이름을 저장함.(FunctionCode+Address)
    FWatchValue: string; //모니터링 데이타
    
    FWatchValueMin: double; //Min data
    FWatchValueMax: double; //Max data
    FWatchValueSum: double; //Sum data
    FWatchValueAvg: double; //Average data
    FWatchValueAry: array of double;
    FCurrentAryIndex: integer; //처음에 배열에 저장시에 평균값 구하기 위함
    FAvgSize: integer; //평균을 위한 배열 size
    FFirstCalcAry: boolean; //처음 배열을 채워갈때는 True, 한번 다 채우면 False
    FWatchTag: integer;

    procedure InitVar;
    procedure DisplayMessage(Msg: string);
    procedure WatchValue2Screen_Analog_WT1600(Name: string; AValue: string);

    procedure ApplyAvgSize;

    procedure ClearWT1600Data;
    
    procedure LoadConfigDataini2Form(ConfigForm:TWT1600WatchConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TWT1600WatchConfigF);
    procedure SetConfigData;
  end;

var
  WatchF: TWatchF;

implementation

uses CommonUtil;

{$R *.dfm}

procedure TWatchF.InitVar;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FCriticalSection := TCriticalSection.Create;

  FIPCMonitor := TIPCMonitor_WT1600.Create(0, FSharedName, True);
  FIPCMonitor.OnSignal := OnSignal;
  FIPCMonitor.Resume;

  FMsgList := TStringList.Create;
  FMonitorStart := False;

  LoadConfigDataini2Var;
  LoadConfigDataini2Form(nil);
  SetLength(FWatchValueAry, FAvgSize);
  //FillChar(FWatchValueAry,Sizeof(FWatchValueAry) * FAvgSize,0);
  FCurrentAryIndex := 0;
  FFirstCalcAry := True;

end;

procedure TWatchF.LoadConfigDataini2Form(ConfigForm: TWT1600WatchConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      if Assigned(ConfigForm) then
      begin
        with ConfigForm do
        begin
          //FilenameEdit.Text := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name1', '.\ss197_Modbus_Map.txt');
        end;//with
      end
      else
      begin
        //AvgEdit.Text := ReadString(ENGMONITOR_SECTION, 'Aveage Size', '1');
      end;
      //FilenameEdit2.Filename := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name2', '.\ss197_Modbus_Map.txt');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWatchF.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      //FAvgSize := ReadInteger(ENGMONITOR_SECTION, 'Aveage Size', 1);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWatchF.SaveConfigDataForm2ini(ConfigForm: TWT1600WatchConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      if Assigned(ConfigForm) then
      begin
        with ConfigForm do
        begin
          //WriteString(ENGMONITOR_SECTION, 'Modbus Map File Name1', FilenameEdit.Text);
        end;
      end
      else
      begin
        //WriteString(ENGMONITOR_SECTION, 'Aveage Size', AvgEdit.Text);
      end;
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWatchF.SetConfigData;
var WT1600WatchConfigF: TWT1600WatchConfigF;
begin
  WT1600WatchConfigF := TWT1600WatchConfigF.Create(Application);
  with WT1600WatchConfigF do
  begin
    try
      LoadConfigDataini2Form(WT1600WatchConfigF);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(WT1600WatchConfigF);
        LoadConfigDataini2Var;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TWatchF.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    if FMonitorStart then
    begin
      DisplayMessage('');
    end
    else
    begin
    end;
  finally
    FMonitorStart := True;
    Timer1.Enabled := True;
  end;//try

end;

procedure TWatchF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TWatchF.OnSignal(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
var
  i,dcount: integer;
begin
  if not FMonitorStart then
    exit;

  ClearWT1600Data;

  FWT1600Data.IPAddress := String(Data.IPAddress);
  FWT1600Data.URMS1 := String(Data.URMS1);
  FWT1600Data.URMS2 := String(Data.URMS2);
  FWT1600Data.URMS3 := String(Data.URMS3);
  FWT1600Data.IRMS1 := String(Data.IRMS1);
  FWT1600Data.IRMS2 := String(Data.IRMS2);
  FWT1600Data.IRMS3 := String(Data.IRMS3);
  FWT1600Data.PSIGMA := String(Data.PSIGMA);
  FWT1600Data.SSIGMA := String(Data.SSIGMA);
  FWT1600Data.QSIGMA := String(Data.QSIGMA);
  FWT1600Data.RAMDA := String(Data.RAMDA);
  FWT1600Data.FREQUENCY := String(Data.FREQUENCY);

  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := FWT1600Data.IPAddress + ' 데이타 도착';

  SendMessage(Handle, WM_WT1600DATA, 0,0);
end;

procedure TWatchF.UpdateTraceData(var Msg: TWMWT1600Data);
var
  i, j: integer;
  tmpStr: string;
  tmpByte, ProcessBitCnt: Byte;
  IsFirst, IsSecond: Boolean;
begin

  StatusBar1.SimpleText := FWT1600Data.IPAddress + ' 처리중...';

  //수신된 데이타를 화면에 뿌려줌
  WatchValue2Screen_Analog_WT1600(FWatchName, FWatchValue);
end;

procedure TWatchF.DisplayMessage(Msg: string);
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

procedure TWatchF.WatchValue2Screen_Analog_WT1600(Name: string; AValue: string);
var
  tmpdouble: double;
  tmpValue: string;
begin
  tmpdouble := StrToFloat(AValue);
  tmpValue := format('%10.2f',[tmpdouble]);

  if tmpdouble > FWatchValueMax then
    FWatchValueMax := tmpdouble;

  if tmpdouble < FWatchValueMin then
    FWatchValueMin := tmpdouble;


  if FCurrentAryIndex = (FAvgSize - 1) then
  begin
    FFirstCalcAry := False;
    FCurrentAryIndex := 0;
    FWatchValueSum := FWatchValueSum - FWatchValueAry[FCurrentAryIndex] + tmpdouble;
  end
  else
  begin
    Inc(FCurrentAryIndex);

    if FFirstCalcAry = true then
      FWatchValueSum := FWatchValueSum  + tmpdouble
    else
      FWatchValueSum := FWatchValueSum - FWatchValueAry[FCurrentAryIndex] + tmpdouble;
  end;

  FCriticalSection.Enter;

  try
    if FFirstCalcAry = true then
      FWatchValueAvg := FWatchValueSum / (FCurrentAryIndex + 1)
    else
      FWatchValueAvg := FWatchValueSum / FAvgSize;

    FWatchValueAry[FCurrentAryIndex] := tmpdouble;
  finally
    FCriticalSection.Leave;
  end;//try

  FWatchValue := FloatToStr(tmpdouble);
  case PageControl1.ActivePageIndex of
    0: begin //simple
      WatchLabel.Caption := FWatchValue;
      AvgLabel.Caption := format('%10.2f',[FWatchValueAvg]);//FloatToStr(FWatchValueAvg);
    end;
    1: begin //Min/Max
      MinLabel.Caption :=  format('%10.2f',[FWatchValueMin]);//FloatToStr(FWatchValueMin);
      MaxLabel.Caption :=  format('%10.2f',[FWatchValueMax]);//FloatToStr(FWatchValueMax);
      CurLabel.Caption := FWatchValue;
    end;
    2: begin //Graph
    end;
    3: begin //Meter
    end;
    4: begin //Bar
    end;
  end;//case

end;

procedure TWatchF.FormDestroy(Sender: TObject);
begin
  FWatchValueAry := nil;

  FCriticalSection.Free;

  FIPCMonitor.Free;
  FMsgList.Free;
end;

procedure TWatchF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TWatchF.Config1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TWatchF.Button2Click(Sender: TObject);
begin
  ApplyAvgSize;
end;

procedure TWatchF.ApplyAvgSize;
begin
  SaveConfigDataForm2ini(nil);
  LoadConfigDataini2Form(nil);
  LoadConfigDataini2Var;
  FCriticalSection.Enter;
  try
    SetLength(FWatchValueAry, FAvgSize);
    FCurrentAryIndex := 0;
    FFirstCalcAry := True;
  finally
    FCriticalSection.Leave;
  end;//try
end;

procedure TWatchF.FormShow(Sender: TObject);
begin
  Label1.Caption := FLabelName;
  Label3.Caption := FLabelName;
  Self.Caption := Self.Caption + ' :: ' + FLabelName;
end;

procedure TWatchF.Button1Click(Sender: TObject);
begin
  FWatchValueMax := 0;
  FWatchValueMin := 0;
end;

procedure TWatchF.ClearWT1600Data;
begin
  with FWT1600Data do
  begin
    IPAddress:= '';
    URMS1:= '';
    URMS2:= '';
    URMS3:= '';
    IRMS1:= '';
    IRMS2:= '';
    IRMS3:= '';
    PSIGMA:= '';
    SSIGMA:= '';
    QSIGMA:= '';
    RAMDA:= '';
    FREQUENCY:= '';
  end;//with
end;

end.





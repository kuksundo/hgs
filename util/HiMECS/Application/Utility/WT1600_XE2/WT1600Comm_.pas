unit WT1600Comm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SyncObjs, inifiles, iComponent, iVCLComponent,
  iCustomComponent, iSwitchLed, WT1600Const, WT1600CommThread, ExtCtrls, Menus,
  WT1600Config, MyKernelObject, CopyData, IPCThrd2, IPCThrdClient2,
  ComCtrls, WT1600PingThread;

type
  TDisplayTarget = (dtSendMemo, dtRecvMemo, dtStatusBar);

  TWT1600CommF = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    SendComMemo: TMemo;
    Splitter1: TSplitter;
    RecvComMemo: TMemo;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel36: TPanel;
    Panel23: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel34: TPanel;
    Panel8: TPanel;
    Panel83: TPanel;
    PSIGMA: TPanel;
    SSIGMA: TPanel;
    QSIGMA: TPanel;
    FREQUENCY: TPanel;
    RAMDA: TPanel;
    IRMS1: TPanel;
    IRMS2: TPanel;
    IRMS3: TPanel;
    URMS1: TPanel;
    URMS2: TPanel;
    URMS3: TPanel;
    Panel9: TPanel;
    Panel18: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel19: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    iSwitchLed1: TiSwitchLed;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure CONSUMPTIONQDblClick(Sender: TObject);
    procedure iSwitchLed1Click(Sender: TObject);
  private
    //FThreadPool: TThreadPool;
    FFirst: Boolean;//맨처음에 실행될때 True 그 다음부터는 False
    FFilePath: string;      //파일을 저장할 경로
    //FStoreType: TStoreType; //저장방식(ini or registry)
    FIPCClient: TIPCClient2;//공유 메모리 및 이벤트 객체
    FWT1600CommThread: TWT1600CommThread;
    FWT1600PingThread:TWT1600PingThread;
    FRecvStrBuf: string; //Thread 통신 객체

    procedure WMPowerMeterOn(var Msg: TMessage); message WM_POWERMETER_ON;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure SetCurrentCommandIndex(aIndex: integer);

    procedure DestroyAll;
  protected
  public
    FOwner: TForm;
    FWT1600On: Boolean;
    FIPAddress: string;
    FPingInterval: Word;

    FStop: boolean;
    FSuspend: boolean;
    ///
    FSendCommandList: TStringList;//WT1600 통신 명령 리스트
    //현재 Comport에 Write한 FSendCommandList의 Index(0부터 시작함)
    FCurrentCommandIndex: integer;
    //일정시간 이상 통신에 대한 반응이 없으면 제어기 다운으로 간주(Wait 시간 설정)
    FCommFail: Boolean;
    FCommFailCount: integer; //통신 반응이 없이 FQueryInterval이 경과한 횟수
    FCriticalSection: TCriticalSection;
    FErrCnt: integer; //LRC Error Log

    FMenuItem: TMenuItem;//메인 메뉴에서 메뉴를 선택한 아이템
    FPowerMeterNo: word;//Power Meter No.

    //constructor Create(AIpAddress: string);
    procedure InitVar;
    procedure MakeCommand;
    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
    procedure Value2Screen(AData: string);
    procedure NullValue2Screen;

    procedure LoadConfigDataini2Form(ConfigForm:TWT1600ConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TWT1600ConfigF);
    procedure SetConfigData;
  published
    property FilePath: string read FFilePath;
    //property StoreType: TStoreType read FStoreType;
    property StrBuf: string read FRecvStrBuf write FRecvStrBuf;
    property CurrentCommandIndex: integer read FCurrentCommandIndex write SetCurrentCommandIndex;
  end;

var
  WT1600CommF: TWT1600CommF;

implementation

uses WT1600_Util;

{$R *.dfm}

procedure TWT1600CommF.InitVar;
begin
  FErrCnt := 0;
  //FStoreType := stIniFile;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  //FIPAddress := '10.14.21.112';
  FPingInterval := 1000;

  FSendCommandList := TStringList.Create;
  //FThreadPool := TThreadPool.Create(5,10,0); //max 10 thread
  //FThreadPool.ExecuteProc(CheckPowerMeterOn,Pointer(self));

  FStop := False;

  FCriticalSection := TCriticalSection.Create;
  FIPCClient := TIPCClient2.Create(0, FIPAddress, True);
  FWT1600CommThread := TWT1600CommThread.Create(Self,FIPAddress,'anonymous');
  FWT1600CommThread.StopComm := True;

  FWT1600PingThread := TWT1600PingThread.Create(Self, FIPAddress);

  LoadConfigDataini2Var;
end;

procedure TWT1600CommF.FormCreate(Sender: TObject);
begin
  FFirst := True;
end;

procedure TWT1600CommF.WMPowerMeterOn(var Msg: TMessage);
begin
//  FCriticalSection.Enter;
  if FStop then
    exit;

  FWT1600On := (Msg.WParamLo = 1);
  FWT1600CommThread.FPingOK := FWT1600On;
  iSwitchLed1.Active := FWT1600On;
  SendMessage(FOwner.Handle, WM_POWERMETER_ON, Msg.WParam, Msg.LParam);
//  FCriticalSection.Leave;
end;

procedure TWT1600CommF.FormClose(Sender: TObject; var Action: TCloseAction);
var
  LMsg: TMessage;
begin
  LMsg.WParamLo := 0;
  LMsg.WParamHi := FPowerMeterNo;
  SendMessage(FOwner.Handle, WM_POWERMETER_ON, LMsg.WParam, 0);

  FMenuItem.Enabled := True;
  FStop := True;
  DestroyAll;
  //Action := caFree;
end;

procedure TWT1600CommF.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
begin
  case ADspNo of
    dtSendMemo : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

      with SendComMemo do
      begin
        if Lines.Count > 100 then
          Clear;

        //Lines.Add(msg);
      end;//with
    end;//dtSendMemo

    dtRecvMemo: begin
      if msg = 'RxTrue' then
      begin
        exit;
      end
      else
      if msg = 'RxFalse' then
      begin
        exit;
      end;

      with RecvComMemo do
      begin
        if Lines.Count > 100 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtRecvMemo

    dtStatusBar: begin
       StatusBar1.SimplePanel := True;
       StatusBar1.SimpleText := DateTimeToStr(now) + ' : ' + msg;
    end;//dtStatusBar
  end;//case
end;

procedure TWT1600CommF.LoadConfigDataini2Form(ConfigForm: TWT1600ConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      QueryIntervalEdit.Text := ReadString(WT1600_SECTION, 'Query Interval','0');
      ResponseWaitTimeOutEdit.Text := ReadString(WT1600_SECTION, 'Response Wait Time Out','0');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWT1600CommF.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      FWT1600CommThread.QueryInterval :=
                              ReadInteger(WT1600_SECTION, 'Query Interval',0);
      //FWT1600CommThread.TimeOut :=
                      //ReadInteger(WT1600_SECTION, 'Response Wait Time Out',0);
    end;//with

  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWT1600CommF.MakeCommand;
begin
  FSendCommandList.Clear;
  FSendCommandList.Add(':NUMERIC:NORMAL:VALUE?');
  FWT1600CommThread.FSendCommandList.Assign(FSendCommandList);
  FWT1600CommThread.FWT1600ID := FPowerMeterNo - 1;
  //FWT1600CommThread.InitVar(FWT1600CommThread.FWT1600ID);
  //FWT1600CommThread.SendItemSettings;
  FWT1600CommThread.FIsInitExec := True;

  FWT1600PingThread.FIpAddress := FIPAddress;
  FWT1600PingThread.FPingInterval := FPingInterval;
  FWT1600PingThread.FPowerMeterNo := FPowerMeterNo;
  FWT1600PingThread.Priority := tpLowest;
end;

procedure TWT1600CommF.SaveConfigDataForm2ini(ConfigForm: TWT1600ConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      WriteString(WT1600_SECTION, 'Query Interval',QueryIntervalEdit.Text);
      WriteString(WT1600_SECTION, 'Response Wait Time Out', ResponseWaitTimeOutEdit.Text);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWT1600CommF.SetConfigData;
var
  ConfigData: TWT1600ConfigF;
begin
  ConfigData := nil;
  ConfigData := TWT1600ConfigF.Create(Self);
  try
    with ConfigData do
    begin
      LoadConfigDataini2Form(ConfigData);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(ConfigData);
        LoadConfigDataini2Var;
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TWT1600CommF.SetCurrentCommandIndex(aIndex: integer);
begin
  if FCurrentCommandIndex <> aIndex then
    FCurrentCommandIndex := aIndex;
end;

procedure TWT1600CommF.Timer1Timer(Sender: TObject);
begin
  with Timer1 do
  begin
    Enabled := False;
    try
      SetCurrentDir(FilePath);

      if FFirst then
      begin
        FFirst := False;
        InitVar;
        Interval := 1000;
        Caption := Caption + ' ('+ FIPAddress + ' )';
        FWT1600PingThread.CheckPowerMeterOn;

        FWT1600CommThread.StopComm := False;
        FWT1600CommThread.Resume;

        FWT1600PingThread.FStopPing := False;
        FWT1600PingThread.Resume;
        Interval := FPingInterval;

        MakeCommand;
      end//if
      else
      begin
        if FStop then
          exit;
          
        if (FWT1600CommThread.FPingOK) and (not FWT1600CommThread.FWT1600Connected) then
          MakeCommand;

        FWT1600PingThread.FEventHandle.Pulse;

        if not FWT1600On then
          NullValue2Screen
        else
          FWT1600CommThread.FEventHandle.Pulse;
        //Enabled := False;
      end;
    finally
      Enabled := True;
    end;//try
  end;//with
end;

procedure TWT1600CommF.CONSUMPTIONQDblClick(Sender: TObject);
begin
{  with TWatchF.Create(Application) do
  begin
    FWatchName := TPanel(Sender).Hint;
    FLabelName := Panel29.Caption;
    Show;
  end;
}
end;

procedure TWT1600CommF.WMCopyData(var Msg: TMessage);
begin
//  FCriticalSection.Enter;
  if FStop then
    exit;

  if (PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle = 4) or
    (PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle = 5) then
  begin//Data인 경우
    Value2Screen(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg);
  end
  //else
  //if PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle = 5 then
  //  NullValue2Screen
  else
    DisplayMessage(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg,
      TDisplayTarget(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle));
//  FCriticalSection.Leave;
end;

procedure TWT1600CommF.Value2Screen(AData: string);
var
  EventData: TEventData2;
  LData, LStr: string;
  LDouble: double;
begin
  LData := AData;

  {URMS1.Caption := GetToken(AData, ',');
  URMS2.Caption := GetToken(AData, ',');
  URMS3.Caption := GetToken(AData, ',');
  IRMS1.Caption := GetToken(AData, ',');
  IRMS2.Caption := GetToken(AData, ',');
  IRMS3.Caption := GetToken(AData, ',');
  FREQUENCY.Caption := GetToken(AData, ',');
  RAMDA.Caption := GetToken(AData, ',');
  PSIGMA.Caption := GetToken(AData, ',');
  SSIGMA.Caption := GetToken(AData, ',');
  QSIGMA.Caption := GetToken(AData, ',');
  }
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  URMS1.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  URMS2.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  URMS3.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  IRMS1.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  IRMS2.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  IRMS3.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  FREQUENCY.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  RAMDA.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  PSIGMA.Caption := Format('%.2f', [LDouble/1000]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  SSIGMA.Caption := Format('%.2f', [LDouble/1000]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  QSIGMA.Caption := Format('%.2f', [LDouble/1000]);

  StrPCopy(@EventData.IpAddress[0],FIPAddress);
  StrPCopy(@EventData.URMS1[0],GetToken(AData, ','));
  StrPCopy(@EventData.URMS2[0],GetToken(AData, ','));
  StrPCopy(@EventData.URMS3[0],GetToken(AData, ','));
  StrPCopy(@EventData.IRMS1[0],GetToken(AData, ','));
  StrPCopy(@EventData.IRMS2[0],GetToken(AData, ','));
  StrPCopy(@EventData.IRMS3[0],GetToken(AData, ','));
  StrPCopy(@EventData.FREQUENCY[0],GetToken(AData, ','));
  StrPCopy(@EventData.RAMDA[0],GetToken(AData, ','));
  StrPCopy(@EventData.PSIGMA[0],GetToken(AData, ','));
  StrPCopy(@EventData.SSIGMA[0],GetToken(AData, ','));
  StrPCopy(@EventData.QSIGMA[0],GetToken(AData, ','));
  EventData.PowerMeterOn := FWT1600On;
  EventData.PowerMeterNo := FPowerMeterNo;
  //DisplayMessage('WT1600On = '+IntToStr(Ord(FWT1600On)), dtSendMemo);
  //EventData.IpAddress :=
  {EventData.URMS1 := GetToken(AData, ',');
  EventData.URMS2 := GetToken(AData, ',');
  EventData.URMS3 := GetToken(AData, ',');
  EventData.IRMS1 := GetToken(AData, ',');
  EventData.IRMS2 := GetToken(AData, ',');
  EventData.IRMS3 := GetToken(AData, ',');
  EventData.FREQUENCY := GetToken(AData, ',');
  EventData.RAMDA := GetToken(AData, ',');
  EventData.PSIGMA := GetToken(AData, ',');
  EventData.SSIGMA := GetToken(AData, ',');
  EventData.QSIGMA := GetToken(AData, ',');
  }
  FIPCClient.PulseMonitor(EventData);
  //FWT1600CommThread.FEventHandle.Pulse;
  DisplayMessage('********* 공유메모리에 데이타 전달함!!! **********'+#13#10, TDisplayTarget(1));
end;

procedure TWT1600CommF.NullValue2Screen;
var
  EventData: TEventData2;
begin
  StrPCopy(@EventData.URMS1[0],'0.0');
  StrPCopy(@EventData.URMS2[0],'0.0');
  StrPCopy(@EventData.URMS3[0],'0.0');
  StrPCopy(@EventData.IRMS1[0],'0.0');
  StrPCopy(@EventData.IRMS2[0],'0.0');
  StrPCopy(@EventData.IRMS3[0],'0.0');
  StrPCopy(@EventData.FREQUENCY[0],'0.0');
  StrPCopy(@EventData.RAMDA[0],'0.0');
  StrPCopy(@EventData.PSIGMA[0],'0.0');
  StrPCopy(@EventData.SSIGMA[0],'0.0');
  StrPCopy(@EventData.QSIGMA[0],'0.0');
  EventData.PowerMeterOn := False;
  EventData.PowerMeterNo := FPowerMeterNo;
  FIPCClient.PulseMonitor(EventData);
  FWT1600CommThread.FEventHandle.Pulse;
end;

procedure TWT1600CommF.iSwitchLed1Click(Sender: TObject);
begin
  FWT1600CommThread.StopComm := not FWT1600CommThread.StopComm;
end;

procedure TWT1600CommF.DestroyAll;
begin
  FCriticalSection.Enter;

  FWT1600CommThread.StopComm := True;
  
  FWT1600CommThread.Terminate;
  DisplayMessage('FWT1600CommThread.Terminate', TDisplayTarget(1));
  FWT1600CommThread.FEventHandle.Signal;
  DisplayMessage('FWT1600CommThread.FEventHandle.Signal', TDisplayTarget(1));

  if FWT1600CommThread.Suspended then
    FWT1600CommThread.Resume;

  //FWT1600CommThread.WaitFor;
  //DisplayMessage('FWT1600CommThread.WaitFor', TDisplayTarget(1));
  FWT1600CommThread.Free;
  DisplayMessage('FWT1600CommThread.Free', TDisplayTarget(1));

  if FWT1600PingThread.Suspended then
    FWT1600PingThread.Resume;

  FWT1600PingThread.Terminate;
  DisplayMessage('FWT1600PingThread.Terminate', TDisplayTarget(1));
  FWT1600PingThread.FEventHandle.Signal;
  DisplayMessage('FWT1600PingThread.FEventHandle.Signal', TDisplayTarget(1));
  FWT1600PingThread.WaitFor;
  DisplayMessage('FWT1600PingThread.WaitFor', TDisplayTarget(1));
  FWT1600PingThread.Free;
  DisplayMessage('FWT1600PingThread.Free', TDisplayTarget(1));

  //FreeAndNil(FWT1600PingThread);//.Free;
  //FreeAndNil(FWT1600CommThread);//.Free;

  if FIPCClient.Suspended then
    FIPCClient.Resume;

  FIPCClient.Terminate;
  DisplayMessage('FIPCClient.Terminate', TDisplayTarget(1));
  FIPCClient.FMonitorEvent.Pulse;
  DisplayMessage('FIPCClient.FEventHandle.Signal', TDisplayTarget(1));
  FIPCClient.WaitFor;
  DisplayMessage('FIPCClient.WaitFor', TDisplayTarget(1));
  FIPCClient.Free;
  DisplayMessage('FIPCClient.Free', TDisplayTarget(1));
  //FreeAndNil(FIPCClient);//.Free;
  //DisplayMessage('FreeAndNil(FIPCClient)', TDisplayTarget(1));
  FreeAndNil(FSendCommandList);//.Free;
  DisplayMessage('FreeAndNil(FSendCommandList)', TDisplayTarget(1));
  //FEventHandle.Free;

//  while FThreadPool.RunningThreadCount > 0 do
//    FThreadPool.CleanUp;
  //try FThreadPool.Free; except end; //wait for ThreadPool threads
  FCriticalSection.Leave;
  FreeAndNil(FCriticalSection);//.Free;
  DisplayMessage('FreeAndNil(FCriticalSection)', TDisplayTarget(1));
end;

end.

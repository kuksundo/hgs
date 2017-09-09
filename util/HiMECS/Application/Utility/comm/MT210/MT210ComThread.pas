unit MT210ComThread;

interface

uses Windows, classes, Forms, CPort, MT210ComConst, MyKernelObject, CopyData;

Type
  TMT210ComThread = class(TThread)
    FOwner: TForm;
    FComPort: TComPort;     //통신 포트
    FStoreType: TStoreType; //저장방식(ini or registry)
    FQueryInterval: integer;//ModBus Query 간격(mSec)
    FStopComm: Boolean;//통신 일시 중지 = True
    FTimeOut: integer;//통신 Send후 다음 Send까지 대기하는 시간(mSec) - INFINITE
    FBufStr: String;//ASCII Mode에서 사용되는 수신버퍼

    procedure OnReceiveChar(Sender: TObject; Count: Integer);
    procedure SetStopComm(Value: Boolean);
    procedure SetTimeOut(Value: integer);
    procedure SetQueryInterval(Value: integer);

  protected
    procedure Execute; override;

  public
    FSendCommandOnce: Boolean;
    FSendCommandRepeat: Boolean;
    FIsSetup: Boolean; //시작시에 컴포트 셋업 화면띄움

    FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event
    FSendCommandListRepeat,
    FSendCommandListOnce: TStringList;//통신 명령 리스트

    constructor Create(AOwner: TForm; QueryInterval: integer);
    destructor Destroy; override;
    procedure InitComPort(PortName: string; QueryInterval: integer);
    procedure SendQuery;
  published
    property CommPort: TComPort read FComPort write FComPort;
    property StopComm: Boolean read FStopComm write SetStopComm;
    property TimeOut: integer read FTimeOut write SetTimeOut;
    property QueryInterval: integer read FQueryInterval write SetQueryInterval;
  end;

implementation

uses MT210_Comm, CommonUtil;

{ TMT210ComThread }

constructor TMT210ComThread.Create(AOwner: TForm; QueryInterval: integer);
begin
  inherited Create(True);

  FOwner := AOwner;
  FStopComm := False;
  FSendCommandOnce := False;
  FSendCommandRepeat := False;

  FSendCommandListRepeat := TStringList.Create;
  FSendCommandListOnce := TStringList.Create;//통신 명령 리스트

  //FComport := TComport.Create(nil);
  FEventHandle := TEvent.Create('',False);
  FTimeOut := 3000; //3초 기다린 후에 계속 명령을 전송함(Default = INFINITE)
  FBufStr := '';
  //try
  //  InitComPort('Com1', QueryInterval);
  //except
  //  SendCopyData2(FOwner.Handle, 'Comm port open fail!', 1);
  //end;
  Resume;
end;

destructor TMT210ComThread.Destroy;
begin
  FSendCommandListRepeat.Free;
  FSendCommandListOnce.Free;//통신 명령 리스트
  //FComport.Free;
  FEventHandle.Free;

  inherited;
end;

procedure TMT210ComThread.Execute;
begin
  while not terminated do
  begin
    if FStopComm then
      Suspend;

    Sleep(FQueryInterval);
    SendQuery;
 end;//while
end;

//통신포트 초기화
//PortName = 'Com1'
//ModBusMode = ASCII_MODE
procedure TMT210ComThread.InitComPort(PortName: string; QueryInterval: integer);
begin
  FStoreType := stIniFile;
  FQueryInterval := QueryInterval;

  with FComport do
  begin
    if FIsSetup then
      ShowSetupDialog;

    if Port = '' then
    begin
      SendCopyData2(FOwner.Handle,'Port Name is empty!', 1);
      exit;
    end;
    
    FlowControl.ControlDTR := dtrEnable;
    OnRxChar := OnReceiveChar;
    //Port := PortName;
    //name := Port;
    //LoadSettings(FStoreType,TModbusComF(FOwner).FilePath + INIFILENAME);
    //ShowSetupDialog;
    //StoreSettings(FStoreType,TModbusComF(FOwner).FilePath + INIFILENAME);

    if Connected then
      Close;

    //통신포트를 오픈한다
    Open;
    Sleep(100);
    ClearBuffer(True,True);
    TMT210ComF(FOwner).FCommOK := True;
  end;//with

end;

procedure TMT210ComThread.OnReceiveChar(Sender: TObject; Count: Integer);
var
  TmpBufStr: String;
  BufByte: Array[0..255] of Byte;
begin
  if TMT210ComF(FOwner).FCommFail then
    TMT210ComF(FOwner).FCommFail := not TMT210ComF(FOwner).FCommFail;
  try
    //TModbusComF(FOwner).RxLed.Value := True;
    //SendCopyData2(FOwner.Handle, 'RxTrue', 0);

    //버퍼 초기화
    TmpBufStr := '';
    //버퍼에 문자열을 수신함
    FComPort.ReadStr(TmpBufStr, Count);

    FBufStr := FBufStr + TmpBufStr;

    //CRLF가 없으면 아직 완성되지 않은 패킷임
    if System.Pos(#13#10, FBufStr) = 0 then
      exit;

    TMT210ComF(FOwner).FCriticalSection.Enter;
    TMT210ComF(FOwner).StrBuf := FBufStr;
    FBufStr := '';
    SendMessage(TMT210ComF(FOwner).Handle,WM_RECEIVESTRING, 0, 0);
    //FEventHandle.Signal;
    TMT210ComF(FOwner).FCriticalSection.Leave;
  finally
    //TModbusComF(FOwner).RxLed.Value := False;
    //SendCopyData2(FOwner.Handle, 'RxFalse', 0);
  end;
end;

procedure TMT210ComThread.SendQuery;
var
  i, SendLength: integer;
  tmpStr: string;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if StopComm then
    exit;

  //FComport.SetDTR(True);

  if FSendCommandOnce then
  begin
    for i := 0 to FSendCommandListOnce.Count - 1 do
    begin
      if StopComm then
        exit;

      FComport.SetRTS(True);
      SendCopyData2(TMT210ComF(FOwner).Handle, ' ', 1);
      Sleep(FQueryInterval);
      FComPort.Writestr(FSendCommandListOnce.Strings[i]);
      SendCopyData2(TMT210ComF(FOwner).Handle, FSendCommandListOnce.Strings[i] ,1);
    end;
    FSendCommandOnce := False;
  end;

  if FSendCommandRepeat then
  begin
    for i := 0 to FSendCommandListRepeat.Count - 1 do
    begin
      if StopComm then
        exit;

      //FComport.SetRTS(True);
      SendCopyData2(TMT210ComF(FOwner).Handle, ' ', 1);
      Sleep(FQueryInterval);
      FComPort.Writestr(FSendCommandListRepeat.Strings[i]);
      SendCopyData2(TMT210ComF(FOwner).Handle, FSendCommandListRepeat.Strings[i] ,1);
    end;
  end;
end;

procedure TMT210ComThread.SetQueryInterval(Value: integer);
begin
  if FQueryInterval <> Value then
    FQueryInterval := Value;
end;

procedure TMT210ComThread.SetStopComm(Value: Boolean);
begin
  if FStopComm <> Value then
  begin
    FStopComm := Value;

    if FStopComm then
      //Suspend
    else
      if Suspended then
        Resume;
  end;
end;

procedure TMT210ComThread.SetTimeOut(Value: integer);
begin
  if FTimeOut <> Value then
    FTimeOUt := Value;
end;

end.

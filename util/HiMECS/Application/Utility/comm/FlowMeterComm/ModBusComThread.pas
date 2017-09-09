unit ModBusComThread;

interface

uses Windows, classes, Forms, CPort, ModbusComConst, MyKernelObject, CopyData;

Type
  TModBusComThread = class(TThread)
    FOwner: TForm;
    FComPort: TComPort;     //통신 포트
    FStoreType: TStoreType; //저장방식(ini or registry)
    FModBusMode: TModBusMode;//ASCII, RTU mode
    FQueryInterval: integer;//ModBus Query 간격(mSec)
    FStopComm: Boolean;//통신 일시 중지 = True
    FTimeOut: integer;//통신 Send후 다음 Send까지 대기하는 시간(mSec) - INFINITE
    FSendBuf: array[0..255] of byte;//RTU Mode에서 사용하는 송신 버퍼
    FBufStr: String;//ASCII Mode에서 사용되는 수신버퍼
    FReqByteCount: integer;//RTU Mode일때 Send시에 요구 바이트 수를 알아야 체크가능

    procedure OnReceiveChar(Sender: TObject; Count: Integer);
    procedure SetStopComm(Value: Boolean);
    procedure SetTimeOut(Value: integer);
    procedure SetQueryInterval(Value: integer);

  protected
    procedure Execute; override;

  public
    FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event
    FSendCommandList: TStringList;//Modbus 통신 명령 리스트

    constructor Create(AOwner: TForm; QueryInterval: integer);
    destructor Destroy; override;
    procedure InitComPort(PortName: string; ModBusMode: TModBusMode;
                                                        QueryInterval: integer);
    procedure SendQuery;
    procedure SendBufClear;
  published
    property StopComm: Boolean read FStopComm write SetStopComm;
    property TimeOut: integer read FTimeOut write SetTimeOut;
    property QueryInterval: integer read FQueryInterval write SetQueryInterval;
  end;

implementation

uses ModbusCom_multidrop, CommonUtil;

{ TModBusComThread }

constructor TModBusComThread.Create(AOwner: TForm; QueryInterval: integer);
begin
  inherited Create(True);

  FOwner := AOwner;
  FStopComm := False;
  FComport := TComport.Create(nil);
  FEventHandle := TEvent.Create('',False);
  FSendCommandList := TStringList.Create;
  InitComPort('Com10', ASCII_MODE, QueryInterval);
  FTimeOut := 3000; //3초 기다린 후에 계속 명령을 전송함(Default = INFINITE)
  FBufStr := '';
  
  //Resume;
end;

destructor TModBusComThread.Destroy;
begin
  FComport.Free;
  FEventHandle.Free;
  FSendCommandList.Free;

  inherited;
end;

procedure TModBusComThread.Execute;
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
procedure TModBusComThread.InitComPort(PortName: string; ModBusMode: TModBusMode;
                                                        QueryInterval: integer);
begin
  FStoreType := stIniFile;
  FModBusMode := ModBusMode;
  FQueryInterval := QueryInterval;

  with FComport do
  begin
    FlowControl.ControlDTR := dtrEnable;
    OnRxChar := OnReceiveChar;
    Port := PortName;
    name := Port;
    LoadSettings(FStoreType,TModbusComF(FOwner).FilePath + INIFILENAME);
    //ShowSetupDialog;
    //StoreSettings(FStoreType,TModbusComF(FOwner).FilePath + INIFILENAME);

    if Connected then
      Close;

    try
    //통신포트를 오픈한다
      Open;
    except
      SendMessage(TModbusComF(FOwner).Handle,WM_INITCOMPORTERROR, 0, 0);
      exit;
    end;

    Sleep(100);
    ClearBuffer(True,True);
  end;//with

end;

procedure TModBusComThread.OnReceiveChar(Sender: TObject; Count: Integer);
var
  TmpBufStr: String;
  BufByte: Array[0..255] of Byte;
begin
  if TModbusComF(FOwner).FCommFail then
    TModbusComF(FOwner).FCommFail := not TModbusComF(FOwner).FCommFail;
  try
    //TModbusComF(FOwner).RxLed.Value := True;
    SendCopyData2(FOwner.Handle, 'RxTrue', 0);

    //ACSII Mode인 경우
    if FModBusMode = ASCII_MODE then
    begin
      //버퍼 초기화
      TmpBufStr := '';
      //버퍼에 문자열을 수신함
      FComPort.ReadStr(TmpBufStr, Count);

      FBufStr := FBufStr + TmpBufStr;

      //CRLF가 없으면 아직 완성되지 않은 패킷임
      if System.Pos(#13#10, FBufStr) = 0 then
        exit;

      TModbusComF(FOwner).FCriticalSection.Enter;
      TModbusComF(FOwner).StrBuf := FBufStr;
      FBufStr := '';
      SendMessage(TModbusComF(FOwner).Handle,WM_RECEIVESTRING, 0, 0);
      //FEventHandle.Signal;
      TModbusComF(FOwner).FCriticalSection.Leave;
    end
    else// RTU Mode인 경우
    begin
      //버퍼 초기화
      FillChar(BufByte, SizeOf(BufByte),0);
      //버퍼에 헥사값을 수신함
      FComPort.Read(BufByte, Count);

      TModbusComF(FOwner).FRecvByteBuf.AppendByteArray(BufByte, Count);

      //요청한 수량만큼 버퍼에 차면 Main 폼에 메세지 전송
      if TModbusComF(FOwner).FRecvByteBuf.Size >= FReqByteCount + 5 then
      begin
        SendMessage(TModbusComF(FOwner).Handle,WM_RECEIVEBYTE, 0, 0);
        //FEventHandle.Signal;
      end;
    end;
  finally
    //TModbusComF(FOwner).RxLed.Value := False;
    SendCopyData2(FOwner.Handle, 'RxFalse', 0);
  end;
end;

procedure TModBusComThread.SendBufClear;
begin
  FillChar(FSendBuf, Length(FSendBuf), #0);
end;

procedure TModBusComThread.SendQuery;
var
  i, SendLength: integer;
  tmpStr: string;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if StopComm then
    exit;

  FComport.SetDTR(True);

  for i := 0 to FSendCommandList.Count - 1 do
  begin
    if StopComm then
      exit;

    //odbusComF(FOwner).TxLed.Value := True;
    SendCopyData2(FOwner.Handle, ' ', 1);
    //SystemBase사의 컨버터에서는 Send시에 RTS를 High로 해야함
    FComport.SetRTS(True);
    //ACSII Mode인 경우
    if FModBusMode = ASCII_MODE then
    begin
      FComPort.Writestr(FSendCommandList.Strings[i]);
      SendCopyData2(FOwner.Handle, FSendCommandList.Strings[i], 1);
      //TModbusComF(FOwner).DisplayMessage(FSendCommandList.Strings[i], True);
    end
    else // RTU Mode인 경우
    begin
      //tmpStr := Copy(FSendCommandList.Strings[i], 2, Length(FSendCommandList.Strings[i]) - 3);
      tmpStr := Copy(FSendCommandList.Strings[i], 1, Length(FSendCommandList.Strings[i]));
      SendLength := String2HexByteAry(tmpStr, FSendBuf);
      FReqByteCount := FSendBuf[5];

      if Copy(FSendCommandList.Strings[i], 3, 2) = '01' then
        FReqByteCount := (FReqByteCount div 8) + Ord(FReqByteCount mod 8 > 0);

      FComport.Write(FSendBuf[0], SendLength);
      SendBufClear();
      SendCopyData2(FOwner.Handle, tmpStr, 1);
    end;

    TModbusComF(FOwner).CurrentCommandIndex := i;
    //odbusComF(FOwner).TxLed.Value := False;
    //SystemBase사의 컨버터에서는 Send후에 RTS를 Low로 해야함
    FComport.SetRTS(False);

    if FEventHandle.Wait(FTimeOut) then
    begin
      if terminated then
        exit;
    end
    else
      Continue;

    Sleep(FQueryInterval);
  end;//for

end;

procedure TModBusComThread.SetQueryInterval(Value: integer);
begin
  if FQueryInterval <> Value then
    FQueryInterval := Value;
end;

procedure TModBusComThread.SetStopComm(Value: Boolean);
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

procedure TModBusComThread.SetTimeOut(Value: integer);
begin
  if FTimeOut <> Value then
    FTimeOUt := Value;
end;

end.

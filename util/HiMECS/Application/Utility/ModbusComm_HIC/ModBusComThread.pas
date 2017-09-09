unit ModBusComThread;

interface

uses Windows, classes, Forms, CPort, ModbusComConst_HIC, MyKernelObject, CopyData;

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
    FWriteCommandList: TStringList;//Write 통신 명령 리스트
    FSendCommandOnce: string;//한번만 Read 명령
    FCommMode: TCommMode;
    FIsConfirmMode: Boolean;//write function 실행 후 return값 확인할 경우  true

    constructor Create(AOwner: TForm; QueryInterval: integer);
    destructor Destroy; override;
    procedure InitComPort(PortName: string; ModBusMode: TModBusMode;
                                                        QueryInterval: integer);
    procedure SendQuery;
    procedure SendBufClear;
    procedure SetModbusMode(AModbusMode: TModbusMode);
  published
    property CommPort: TComPort read FComPort write FComPort;
    property StopComm: Boolean read FStopComm write SetStopComm;
    property TimeOut: integer read FTimeOut write SetTimeOut;
    property QueryInterval: integer read FQueryInterval write SetQueryInterval;
  end;

implementation

uses ModbusCom_main, CommonUtil;

{ TModBusComThread }

constructor TModBusComThread.Create(AOwner: TForm; QueryInterval: integer);
begin
  inherited Create(True);

  FOwner := AOwner;
  FStopComm := False;
  //FComport := TComport.Create(nil);
  FEventHandle := TEvent.Create('',False);
  FSendCommandList := TStringList.Create;
  FWriteCommandList := TStringList.Create;
  FTimeOut := 3000; //3초 기다린 후에 계속 명령을 전송함(Default = INFINITE)
  FBufStr := '';
{  try
    InitComPort('Com1', ASCII_MODE, QueryInterval);
  except
    SendCopyData2(FOwner.Handle, 'Comm port open fail!', 1);
  end;
}
  Resume;
end;

destructor TModBusComThread.Destroy;
begin
  FComport.Free;
  FEventHandle.Free;
  FWriteCommandList.Free;
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

    //통신포트를 오픈한다
    Open;
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

      if (FCommMode = CM_DATA_READ) or (FCommMode = CM_CONFIG_READ) then
      begin
        //요청한 수량만큼 버퍼에 차면 Main 폼에 메세지 전송
        //(FReqByteCount*2) 수정 2013.2.20 for HIC
        if TModbusComF(FOwner).FRecvByteBuf.Size >= (FReqByteCount*2) + 5 then
        begin
          if FCommMode = CM_CONFIG_READ then //Read Matrix Data(자료구조가 CM_DATA_READ와 다름)
            SendMessage(TModbusComF(FOwner).Handle,WM_RECEIVEBYTE_CONFIGDATA, 0, 0)
          else
            SendMessage(TModbusComF(FOwner).Handle,WM_RECEIVEBYTE, 0, 0);
          //FEventHandle.Signal;
        end;
      end
      else
      if (FCommMode = CM_CONFIG_WRITE) or (FCommMode = CM_CONFIG_WRITE_CONFIRM) then
      begin
        //요청한 수량만큼 버퍼에 차면 Main 폼에 메세지 전송
        if TModbusComF(FOwner).FRecvByteBuf.Size >= 5 then
        begin
          case FCommMode of
            CM_CONFIG_WRITE: SendMessage(TModbusComF(FOwner).Handle,WM_RECEIVEBYTE_WRITE, 3, 0);
            CM_CONFIG_WRITE_CONFIRM: SendMessage(TModbusComF(FOwner).Handle,WM_RECEIVEBYTE_WRITE, 4, 0);
          end;
          //FEventHandle.Signal;
        end;
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
  i, SendLength, j: integer;
  tmpStr: string;

  procedure SendInternalQuery(ACommand: string; Aindex: integer);
  var
    i: integer;
  begin
    if StopComm then
      exit;

    SendCopyData2(FOwner.Handle, ' ', 1);
    //SystemBase사의 컨버터에서는 Send시에 RTS를 High로 해야함
    FComport.SetRTS(True);
    //ACSII Mode인 경우
    if FModBusMode = ASCII_MODE then
    begin
      FComPort.Writestr(ACommand);
      SendCopyData2(FOwner.Handle, ACommand, 1);
    end
    else if FModBusMode = RTU_MODE then// RTU Mode인 경우
    begin
      tmpStr := Copy(ACommand, 1, Length(ACommand));
      SendLength := String2HexByteAry(tmpStr, FSendBuf);
      FReqByteCount := FSendBuf[5];

      if Copy(ACommand, 3, 2) = '01' then
        FReqByteCount := (FReqByteCount div 8) + Ord(FReqByteCount mod 8 > 0);
      FComport.Write(FSendBuf[0], SendLength);
      SendBufClear();
      SendCopyData2(FOwner.Handle, tmpStr, 1);
    end;

    TModbusComF(FOwner).CurrentCommandIndex := Aindex;
    FComport.SetRTS(False);

    if FEventHandle.Wait(FTimeOut) then
    begin
      if terminated then
        exit;
    end;

    Sleep(FQueryInterval);
  end;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if StopComm then
    exit;

  if FWriteCommandList.Count > 0 then
  begin
    if FIsConfirmMode then
    begin
      FCommMode := CM_CONFIG_WRITE_CONFIRM;
      FIsConfirmMode := False;
    end
    else
      FCommMode := CM_CONFIG_WRITE;

    try
      for i := FWriteCommandList.Count - 1 downto 0 do
      begin
        SendCopyData2(FOwner.Handle, '=== Write Command ===', 1);
        SendInternalQuery(FWriteCommandList.Strings[i],i);
        FWriteCommandList.Delete(i);
      end;
    finally
      //FWriteCommandList.Clear;
    end;
  end;

  if FSendCommandOnce <> '' then
  begin
    FCommMode := CM_CONFIG_READ;
    SendCopyData2(FOwner.Handle, '=== Once Read Command ===', 1);
    SendInternalQuery(FSendCommandOnce, -1);
    FSendCommandOnce := '';
  end;

  for i := 0 to FSendCommandList.Count - 1 do
  begin
    FCommMode := CM_DATA_READ;

    SendInternalQuery(FSendCommandList.Strings[i],i);

    if FWriteCommandList.Count > 0 then
    begin
      if FIsConfirmMode then
      begin
        FCommMode := CM_CONFIG_WRITE_CONFIRM;
        FIsConfirmMode := False;
      end
      else
        FCommMode := CM_CONFIG_WRITE;

      try
        for j := FWriteCommandList.Count - 1 downto 0 do
        begin
          SendCopyData2(FOwner.Handle, '=== Write Command ===', 1);
          SendInternalQuery(FWriteCommandList.Strings[j],j);
          FWriteCommandList.Delete(j);
        end;
      finally
        //FWriteCommandList.Clear;
      end;
    end;
  end;//for
end;

procedure TModBusComThread.SetModbusMode(AModbusMode: TModbusMode);
begin
  FModBusMode := AModBusMode;
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

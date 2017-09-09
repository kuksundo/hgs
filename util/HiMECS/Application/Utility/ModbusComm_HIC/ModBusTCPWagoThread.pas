unit ModBusTCPWagoThread;

interface

uses Windows, sysutils, classes, Forms, CPort, ModbusComConst_HIC, MyKernelObject,
  CopyData, MBT2;

Type
  TModBusTCPWagoThread = class(TThread)
    FOwner: TForm;
    FSocket: LongInt;     //TCP 포트
    FStoreType: TStoreType; //저장방식(ini or registry)
    FModBusMode: TModBusMode;//ASCII, RTU mode, TCP_WAGO_MODE
    FQueryInterval: integer;//ModBus Query 간격(mSec)
    FStopComm: Boolean;//통신 일시 중지 = True
    FTimeOut: integer;//통신 Send후 다음 Send까지 대기하는 시간(mSec) - INFINITE
    FRequestTimeOut: integer;//Connect 시 연결 대기 시간
    FSendBuf: array[0..255] of byte;//RTU Mode에서 사용하는 송신 버퍼
    FBufStr: String;//ASCII Mode에서 사용되는 수신버퍼
    FReqByteCount: integer;//RTU Mode일때 Send시에 요구 바이트 수를 알아야 체크가능
    FConnected: Boolean;//TCP 연결되면 True
    procedure SetStopComm(Value: Boolean);
    procedure SetTimeOut(Value: integer);
    procedure SetQueryInterval(Value: integer);

  protected
    procedure Execute; override;

  public
    FIP: string;
    FPort: integer;

    FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event
    FSendCommandList: TStringList;//Modbus 통신 명령 리스트

    constructor Create(AOwner: TForm; AIP: string; APort, AQueryInterval: integer);
    destructor Destroy; override;
    procedure InitComPort(AIP: string; APort: integer; AModBusMode: TModBusMode; AQueryInterval: integer);
    procedure SendQuery;
    procedure SendBufClear;

    procedure DisconnectTCP;
  published
    property StopComm: Boolean read FStopComm write SetStopComm;
    property TimeOut: integer read FTimeOut write SetTimeOut;
    property QueryInterval: integer read FQueryInterval write SetQueryInterval;
  end;

implementation

uses ModbusCom_main, CommonUtil;

var g_Socket: LongInt;

{ TModBusComThread }

constructor TModBusTCPWagoThread.Create(AOwner: TForm; AIP: string; APort, AQueryInterval: integer);
begin
  inherited Create(True);

  FOwner := AOwner;
  FStopComm := False;
  FEventHandle := TEvent.Create('',False);
  FSendCommandList := TStringList.Create;
  FTimeOut := 3000; //3초 기다린 후에 계속 명령을 전송함(Default = INFINITE)
  FBufStr := '';
  QueryInterval := AQueryInterval;
  FModBusMode := TCP_WAGO_MODE;
  InitComPort(AIP, APort, FModBusMode, 1000);
  Resume;
end;

destructor TModBusTCPWagoThread.Destroy;
begin
  DisconnectTCP;
  FEventHandle.Free;
  FSendCommandList.Free;

  inherited;
end;

procedure TModBusTCPWagoThread.DisconnectTCP;
begin
  if FConnected then
  begin
    MBTDisconnect(FSocket);
    MBTExit;
    FConnected := False;
  end;
end;

procedure TModBusTCPWagoThread.Execute;
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
//ModBusMode = TCP_WAGO_MODE
procedure TModBusTCPWagoThread.InitComPort(AIP: string; APort: integer; AModBusMode: TModBusMode; AQueryInterval: integer);
var ret: LongInt;
begin
  Suspend;

  FIP :=AIP;
  FModBusMode := AModBusMode;
  FPort:= APort;
  
  FStoreType := stIniFile;
  FQueryInterval := AQueryInterval;

  if FConnected then
    DisconnectTCP;

  //통신 연결
  if AIP = '' then
  begin
    SendCopyData2(FOwner.Handle, 'IP 주소가 없슴!', 1);
    exit;
  end;

  MBTInit;
  SendCopyData2(FOwner.Handle, 'MBTInit', 1);

  ret := MBTConnect(AIP, APort, True, 1000, @g_Socket);
  if ret <> 0 then
  begin
    SendCopyData2(FOwner.Handle, 'MBTConnect Fail!', 1);
    SendCopyData2(FOwner.Handle, 'Couldn''t connect to MB Device: 0x'+IntToHex(Trunc(ret),0), 1);
    MBTExit;
    SendCopyData2(FOwner.Handle, 'MBTExit!', 1);
    FConnected := False;
    Exit;
  end
  else
  begin
    FConnected := True;
    FSocket := g_Socket;
    SendCopyData2(FOwner.Handle, 'MBTConnect Success!', 1);
  end;
  
  resume;
end;

procedure TModBusTCPWagoThread.SendBufClear;
begin
  FillChar(FSendBuf, Length(FSendBuf), #0);
end;

procedure TModBusTCPWagoThread.SendQuery;
var
  BufWord: Array[0..255] of Word;
  i,j, SendLength: integer;
  tmpStr: string;
  LFunctionCode,
  LAddress,
  LCount: integer;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if StopComm then
    exit;

  for i := 0 to FSendCommandList.Count - 1 do
  begin
    if StopComm then
      exit;

    SendCopyData2(FOwner.Handle, ' ', 1);

    //ACSII Mode인 경우
    if FModBusMode = TCP_WAGO_MODE then
    begin
      tmpStr := FSendCommandList.Strings[i];
      LFunctionCode := StrToInt(Copy(tmpStr, 4,2));
      LAddress := HexToInt(Copy(tmpStr, 6,4));
      LCount := HexToInt(Copy(tmpStr, 10,4));

      TModbusComF(FOwner).FRecvWordBuf[0] := LFunctionCode;//Function Code
      TModbusComF(FOwner).FRecvWordBuf[1] := LCount;//Data Count

      //버퍼 초기화
      FillChar(BufWord, SizeOf(BufWord),0);

      if (LFunctionCode = 1) or (LFunctionCode = 2) then
      begin
        MBTReadCoils(FSocket,
                      MODBUSTCP_TABLE_OUTPUT_COIL,
                      LAddress,
                      LCount,
                      @BufWord,
                      0,0);

        SendLength := LCount div 16;
        if (LCount mod 16) > 0 then
          inc(SendLength);

        for j := 2 to SendLength + 1 do
          TModbusComF(FOwner).FRecvWordBuf[j] := BufWord[j-2];
      end
      else
      if (LFunctionCode = 3) or (LFunctionCode = 4) then
      begin
        MBTReadRegisters(FSocket,
                          MODBUSTCP_TABLE_INPUT_REGISTER,
                          LAddress,
                          LCount,
                          @BufWord,
                          0,0);

        for j := 2 to LCount + 1 do
          TModbusComF(FOwner).FRecvWordBuf[j] := MBTSwapWord(BufWord[j-2]);
      end;

      TModbusComF(FOwner).CurrentCommandIndex := i;
      //요청한 수량만큼 버퍼에 차면 Main 폼에 메세지 전송
      SendMessage(TModbusComF(FOwner).Handle,WM_RECEIVEWORD_TCPWAGO, 0, 0);

      //SendCopyData2(FOwner.Handle, FSendCommandList.Strings[i], 1);
    end;

    if FEventHandle.Wait(FTimeOut) then
    begin
      if terminated then
       exit;
    end
    else
      Continue;

    //Sleep(FQueryInterval);
  end;//for

end;

procedure TModBusTCPWagoThread.SetQueryInterval(Value: integer);
begin
  if FQueryInterval <> Value then
    FQueryInterval := Value;
end;

procedure TModBusTCPWagoThread.SetStopComm(Value: Boolean);
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

procedure TModBusTCPWagoThread.SetTimeOut(Value: integer);
begin
  if FTimeOut <> Value then
    FTimeOUt := Value;
end;

end.

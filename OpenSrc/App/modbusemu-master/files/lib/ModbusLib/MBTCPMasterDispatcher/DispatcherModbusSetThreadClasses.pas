unit DispatcherModbusSetThreadClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, syncobjs, contnrs,
     LoggerItf,
     MBDefine,
     SocketMyTypes, SocketSimpleTypes,
     MBReaderTCPPacketClasses;

type

  { TSetMessage }

  TSetMessage = class
   private
     FAddress : Cardinal;
     FDevNum  : Byte;
     FMBType  : TRegMBTypes;
     FPort    : Word;
     FRegAddr : Word;
     FValBool : Boolean;
     FValWord : Word;
   public
    constructor Create; virtual;
    property Address : Cardinal read FAddress write FAddress;
    property Port    : Word read FPort write FPort;
    property MBType  : TRegMBTypes read FMBType write FMBType;
    property DevNum  : Byte read FDevNum write FDevNum;
    property RegAddr : Word read FRegAddr write FRegAddr;
    property ValBool : Boolean read FValBool write FValBool;
    property ValWord : Word read FValWord write FValWord;
  end;

  { TSetMsgQueue }

  TSetMsgQueue = class(TObjectLogged)
   private
    FCSection : TCriticalSection;
    FQueue    : TObjectQueue;
    function GetCount: Integer;
   public
    constructor Create; virtual;
    destructor  Destroy; override;

    procedure Push(AMsg : TSetMessage);
    function  Pop : TSetMessage;
    function  Peek : TSetMessage;

    procedure Lock;
    procedure Unlock;
    procedure Clear;

    property Count : Integer read GetCount;
  end;

  { TMBSlaveSetThread }

  TMBSlaveSetThread = class(TThreadLogged)
   private
    FTCPClient            : TBaseClientSocket;
    FQueue                : TSetMsgQueue;
    FEvent                : TEvent;
    FPollingIntervalQueue : Cardinal;
    FCoilRespReader       : TReaderMBTCPF5Packet;
    FInputRespReader      : TReaderMBTCPF6Packet;
   protected
    procedure SetLogger(const Value: IDLogger); override;

    procedure Execute; override;

    procedure InitThread;
    procedure CloseThread;

    procedure OpenConnection(AMsg : TSetMessage);
    procedure OnSocketErrorProc(Source: TObject; ErrorEvent: TErrorEvent; var ErrorCode: Integer);

    function  SendSetMessage(AMsg : TSetMessage; var ATransNum : Word) : Boolean;
    procedure ReceiveAnswer(ATransNum : Word);
   public
    constructor Create(CreateSuspended: Boolean; const StackSize: SizeUInt = 65535); reintroduce;
    destructor  Destroy; override;

    procedure AddCoilMessage(AAdress : Cardinal; APort : Word; ADevNum : Byte; ARegAddr : Word; AValue : Boolean);
    procedure AddInputMessage(AAdress : Cardinal; APort : Word; ADevNum : Byte; ARegAddr : Word; AValue : Word);

    property PollingIntervalQueue : Cardinal read FPollingIntervalQueue write FPollingIntervalQueue default 50;
  end;

implementation

uses MBRequestTypes, DispatcherResStrings, SocketMisc;

{ TMBSlaveSetThread }

constructor TMBSlaveSetThread.Create(CreateSuspended: Boolean; const StackSize: SizeUInt);
begin
  inherited Create(CreateSuspended, StackSize);
  FTCPClient                := TBaseClientSocket.Create;
  FTCPClient.SelectEnable   := False;
  FTCPClient.BlockingSocket := False;
  FTCPClient.SelectTimeOut  := 500;
  FTCPClient.OnError        := @OnSocketErrorProc;


  FQueue                := TSetMsgQueue.Create;
  FEvent                := TEvent.Create(nil,True,False,'SlaveSetEvent');
  FPollingIntervalQueue := 50;
  FCoilRespReader       := TReaderMBTCPF5Packet.Create(nil);
  FInputRespReader      := TReaderMBTCPF6Packet.Create(nil);
end;

destructor TMBSlaveSetThread.Destroy;
begin
  FreeAndNil(FQueue);
  FreeAndNil(FTCPClient);
  FreeAndNil(FEvent);
  FreeAndNil(FCoilRespReader);
  FreeAndNil(FInputRespReader);
  inherited Destroy;
end;

procedure TMBSlaveSetThread.Execute;
var TempMsg : TSetMessage;
    TempRes : Boolean;
    TempTransNum : Word;
begin
  InitThread;
  try
   TempTransNum := 0;
   while Terminated do
    begin
     try
      if FEvent.WaitFor(FPollingIntervalQueue) <> wrTimeout then
       begin
        Sleep(FPollingIntervalQueue);
        Continue;
       end;
      if Terminated then Break;
      while FQueue.Count > 0 do
       begin
        if Terminated then Break;
        // сообщение из очереди
        TempMsg := FQueue.Pop;
        if not Assigned(TempMsg) then Continue;
        try
         TempRes := SendSetMessage(TempMsg,TempTransNum);
         if not TempRes then Continue;
         ReceiveAnswer(TempTransNum);
        finally
         FreeAndNil(TempMsg);
        end;
       end;
     except
      on E : Exception do
       begin
        SendLogMessage(llError,rsSetThread,Format(rsESetThread6,[E.Message]));
       end;
     end;
    end;
  finally
   CloseThread;
  end;
end;

procedure TMBSlaveSetThread.InitThread;
begin
  try

  except
   on E : Exception do
    begin
     SendLogMessage(llError,rsSetThread,Format(rsESetThread7,[E.Message]));
    end;
  end;
end;

procedure TMBSlaveSetThread.CloseThread;
begin
  try
   FTCPClient.Close;
   FQueue.Clear;
  except
   on E : Exception do
    begin
     SendLogMessage(llError,rsSetThread,Format(rsESetThread8,[E.Message]));
    end;
  end;
end;

procedure TMBSlaveSetThread.OnSocketErrorProc(Source: TObject; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  SendLogMessage(llError,rsSetThread,Format(rsESetThread9,[FTCPClient.Address,FTCPClient.Port,ErrorCode,SysErrorMessage(ErrorCode)]));
end;

procedure TMBSlaveSetThread.OpenConnection(AMsg: TSetMessage);
begin
  if SameText(FTCPClient.Address,GetIPStr(AMsg.Address)) and (FTCPClient.Port = AMsg.Port) and (FTCPClient.Active) then Exit;
  FTCPClient.Close;
  FTCPClient.Address := GetIPStr(AMsg.Address);
  FTCPClient.Port    := AMsg.Port;
  FTCPClient.Open;
end;

function TMBSlaveSetThread.SendSetMessage(AMsg: TSetMessage; var ATransNum : Word): Boolean;
var TempRequest : TMBTCPF1RequestNew;
    SendRes     : Integer;
begin
  Result := False;

  OpenConnection(AMsg);

  if not FTCPClient.Active then Exit;

  try
   Inc(ATransNum);
  except
   ATransNum := 0;
  end;
  TempRequest.Header.DeviceInfo.DeviceAddress := AMsg.DevNum;
  case AMsg.MBType of
   rgCoils : begin
              TempRequest.Header.DeviceInfo.FunctionCode := 5;
              if AMsg.ValBool then TempRequest.Header.RequestData.Quantity := $FF00
               else TempRequest.Header.RequestData.Quantity := $0000;
             end;
   rgInput : begin
              TempRequest.Header.DeviceInfo.FunctionCode := 6;
              TempRequest.Header.RequestData.Quantity    := Swap(AMsg.ValWord);
             end
  else
   Exit;
  end;
  TempRequest.Header.RequestData.StartingAddress := AMsg.RegAddr;
  TempRequest.TCPHeader.ProtocolID               := 0;
  TempRequest.TCPHeader.TransactioID             := Swap(ATransNum);
  TempRequest.TCPHeader.Length                   := 6;

  SendRes := FTCPClient.SendBuf(TempRequest,12);
  if SendRes <> 12 then
   begin
    if SendRes = -1 then
     begin
      SendLogMessage(llError,rsSetThread,Format(rsEDispThread3,[FTCPClient.LastWaitError]));
      FTCPClient.Active := False;
      Exit;
     end
    else
     SendLogMessage(llError,rsSetThread,rsESetThread1);
   end;

 Result := True;
end;

procedure TMBSlaveSetThread.ReceiveAnswer(ATransNum : Word);
var WaitRes : TWaitResult;
    Counter : Integer;
    ReadRes : Cardinal;
    TempBuffSize : Integer;
    TempBuff     : Pointer;
    TempResponse : PMBTCPF1RequestNew;
begin
   WaitRes := wrAbandoned;
   Counter := 0;

   while (Counter <= 5) do
    begin
     WaitRes := FTCPClient.WaiteReceiveData;
     if (WaitRes = wrSignaled) then Break;
     Inc(Counter);
     if Terminated then Break;
    end;

   if (WaitRes <> wrSignaled) or (Counter >=5) then
    begin
     SendLogMessage(llError,rsDispThread,rsEDispThread4);
     FTCPClient.Active := False;
     Exit;
    end;

   ReadRes := FTCPClient.GetQuantityDataCame;
   if ReadRes = 0 then
    begin
     SendLogMessage(llError,rsSetThread,Format(rsESetThread2,[FTCPClient.LastWaitError]));
     FTCPClient.Close;
     Exit;
    end;

   TempBuffSize := 1024;
   TempBuff     := GetMem(TempBuffSize);
   if not Assigned(TempBuff) then
    begin
     SendLogMessage(llError,rsSetThread,rsESetThread3);
     Exit;
    end;

   try
    ReadRes := FTCPClient.ReceiveBuf(TempBuff^, ReadRes);
    if ReadRes = 0 then
     begin
      SendLogMessage(llError,rsSetThread,Format(rsESetThread2,[FTCPClient.LastWaitError]));
      FTCPClient.Close;
      Exit;
     end;

    TempResponse := TempBuff;

    if TempResponse^.TCPHeader.TransactioID <> Swap(ATransNum) then
     begin
      SendLogMessage(llError,rsSetThread, rsESetThread4);
      Exit;
     end;

    if TempResponse^.Header.DeviceInfo.FunctionCode > $80 then
     begin
      SendLogMessage(llError,rsSetThread, rsESetThread5);
      Exit;
     end;
   finally
    Freemem(TempBuff);
   end;
end;

procedure TMBSlaveSetThread.SetLogger(const Value: IDLogger);
begin
  inherited SetLogger(Value);
  FTCPClient.Logger := Logger;
  FQueue.Logger     := Logger;
end;

procedure TMBSlaveSetThread.AddCoilMessage(AAdress: Cardinal; APort: Word; ADevNum: Byte; ARegAddr: Word; AValue: Boolean);
var TempMsg : TSetMessage;
begin
  TempMsg := TSetMessage.Create;
  TempMsg.Address := AAdress;
  TempMsg.Port    := APort;
  TempMsg.DevNum  := ADevNum;
  TempMsg.RegAddr := ARegAddr;
  TempMsg.ValBool := AValue;
  TempMsg.MBType  := rgCoils;
  FQueue.Push(TempMsg);
end;

procedure TMBSlaveSetThread.AddInputMessage(AAdress: Cardinal; APort: Word; ADevNum: Byte; ARegAddr: Word; AValue: Word);
var TempMsg : TSetMessage;
begin
  TempMsg := TSetMessage.Create;
  TempMsg.Address := AAdress;
  TempMsg.Port    := APort;
  TempMsg.DevNum  := ADevNum;
  TempMsg.RegAddr := ARegAddr;
  TempMsg.ValWord := AValue;
  TempMsg.MBType  := rgInput;
  FQueue.Push(TempMsg);
end;

{ TSetMsgQueue }

constructor TSetMsgQueue.Create;
begin
  FCSection := TCriticalSection.Create;
  FQueue    := TObjectQueue.Create;
end;

destructor TSetMsgQueue.Destroy;
begin
  Clear;
  FreeAndNil(FQueue);
  FreeAndNil(FCSection);
  inherited Destroy;
end;

function TSetMsgQueue.GetCount: Integer;
begin
  Result := FQueue.Count;
end;

procedure TSetMsgQueue.Push(AMsg: TSetMessage);
begin
  Lock;
  try
   FQueue.Push(AMsg);
  finally
   Unlock;
  end;
end;

function TSetMsgQueue.Pop: TSetMessage;
begin
  Lock;
  try
   Result := TSetMessage(FQueue.Pop);
  finally
   Unlock;
  end;
end;

function TSetMsgQueue.Peek: TSetMessage;
begin
  Lock;
  try
   Result := TSetMessage(FQueue.Peek);
  finally
   Unlock;
  end;
end;

procedure TSetMsgQueue.Lock;
begin
  FCSection.Enter;
end;

procedure TSetMsgQueue.Unlock;
begin
  FCSection.Leave;
end;

procedure TSetMsgQueue.Clear;
var TempMsg : TSetMessage;
begin
  Lock;
  try
   while FQueue.Count > 0 do
    begin
     TempMsg := Pop;
     if Assigned(TempMsg) then FreeAndNil(TempMsg);
    end;
  finally
   Unlock;
  end;
end;

{ TSetMessage }

constructor TSetMessage.Create;
begin
  FAddress := 0;
  FDevNum  := 1;
  FMBType  := rgNone;
  FPort    := 502;
  FRegAddr := 0;
  FValBool := False;
  FValWord := 0;
end;

end.


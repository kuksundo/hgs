unit MQTT;

interface

uses
  SysUtils,
  Types,
  Classes,
  ExtCtrls,
  Generics.Collections,
  SyncObjs,
  blcksock,
  MQTTHeaders,
  MQTTReadThread,
  UnitCodeSiteUtil;//,  JclAnsiStrings;

type
  {$IF not declared(TBytes)}
    TBytes = array of Byte;
  {$IFEND}

  TMQTT = class
    private
    { Private Declarations }
      FClientID: AnsiString;
      FHostname: string;
      FPort: Integer;
      FMessageID: Integer;
      FisConnected: boolean;
      FRecvThread: TMQTTReadThread;
      FCSSock: TCriticalSection;

      FWillMsg: AnsiString;
      FWillTopic: AnsiString;
      FUsername: AnsiString;
      FPassword: AnsiString;
//      FTopic: AnsiString;
//      FQos: integer;

      FSocket: TTCPBlockSocket;
      FKeepAliveTimer: TTimer;

      // Event Fields
      FConnAckEvent: TConnAckEvent;
      FPublishEvent: TPublishEvent;
      FPingRespEvent: TPingRespEvent;
      FPingReqEvent: TPingReqEvent;
      FSubAckEvent: TSubAckEvent;
      FUnSubAckEvent: TUnSubAckEvent;
      FPubAckEvent: TPubAckEvent;
      FPubRelEvent: TPubRelEvent;
      FPubRecEvent: TPubRecEvent;
      FPubCompEvent: TPubCompEvent;
      FReConnectReqEvent: TReConnectReqEvent;

      function WriteData(AData: TBytes): boolean;
      function hasWill: boolean;
      function getNextMessageId: integer;
      function createAndResumeRecvThread(Socket: TTCPBlockSocket): boolean;

      // TMQTTMessage Factory Methods.
      function ConnectMessage: TMQTTMessage;
      function DisconnectMessage: TMQTTMessage;
      function PublishMessage: TMQTTMessage;
      function PingReqMessage: TMQTTMessage;
      function SubscribeMessage: TMQTTMessage;
      function UnsubscribeMessage: TMQTTMessage;

      // Our Keep Alive Ping Timer Event
      procedure KeepAliveTimer_Event(sender: TObject);
//      procedure SetTopic(ATopic: AnsiString);
//      procedure SetQos(AQos: integer);

      // Recv Thread Event Handling Procedures.
      procedure GotConnAck(Sender: TObject; ReturnCode: integer);
      procedure GotPingResp(Sender: TObject);
      procedure GotSubAck(Sender: TObject; MessageID: integer; GrantedQoS: Array of integer);
      procedure GotUnSubAck(Sender: TObject; MessageID: integer);
      procedure GotPub(Sender: TObject; topic, payload: Ansistring);
      procedure GotPubAck(Sender: TObject; MessageID: integer);
      procedure GotPubRec(Sender: TObject; MessageID: integer);
      procedure GotPubRel(Sender: TObject; MessageID: integer);
      procedure GotPubComp(Sender: TObject; MessageID: integer);
      procedure GotReConnectReq(Sender: TObject);
    public
      function Connect: boolean;
      function Disconnect: boolean;
      function Publish(Topic: Ansistring; sPayload: Ansistring): boolean; overload;
      function Publish(Topic: Ansistring; sPayload: Ansistring; Retain: boolean): boolean; overload;
      function Publish(Topic: Ansistring; sPayload: Ansistring; Retain: boolean; QoS: integer): boolean; overload;
      function Subscribe(Topic: Ansistring; RequestQoS: integer): integer; overload;
      function Subscribe(Topics: TDictionary<Ansistring, integer>): integer; overload;
      function Unsubscribe(Topic: Ansistring): integer; overload ;
      function Unsubscribe(Topics: TStringList): integer; overload;
      procedure PingReq;

      procedure PingStop;
      procedure DoSubscribe(Topic: Ansistring; RequestQoS: integer);
      procedure DoSubscribe4Thread(Topic: Ansistring; RequestQoS: integer);
      procedure DoUnSubscribe(Topic: Ansistring);
      procedure DoUnSubscribe4Thread(Topic: Ansistring);
      procedure DoPing;

      constructor Create(hostName: string; port: integer);
      destructor Destroy; override;

      property WillTopic: AnsiString read FWillTopic write FWillTopic;
      property WillMsg: AnsiString read FWillMsg write FWillMsg;
//      property Topic: AnsiString read FTopic write SetTopic;
//      property Qos: integer read FQos write SetQos;

      property Username: AnsiString read FUsername write FUsername;
      property Password: AnsiString read FPassword write FPassword;
      // Client ID is our Client Identifier.
      property ClientID : AnsiString read FClientID write FClientID;
      property isConnected: boolean read FisConnected;

      // Event Handlers
      property OnConnAck : TConnAckEvent read FConnAckEvent write FConnAckEvent;
      property OnPublish : TPublishEvent read FPublishEvent write FPublishEvent;
      property OnPingResp : TPingRespEvent read FPingRespEvent write FPingRespEvent;
      property OnPingReq : TPingRespEvent read FPingRespEvent write FPingRespEvent;
      property OnSubAck : TSubAckEvent read FSubAckEvent write FSubAckEvent;
      property OnUnSubAck : TUnSubAckEvent read FUnSubAckEvent write FUnSubAckEvent;
      property OnPubAck : TUnSubAckEvent read FUnSubAckEvent write FUnSubAckEvent;
      property OnPubRec : TUnSubAckEvent read FUnSubAckEvent write FUnSubAckEvent;
      property OnPubRel : TUnSubAckEvent read FUnSubAckEvent write FUnSubAckEvent;
      property OnPubComp : TUnSubAckEvent read FUnSubAckEvent write FUnSubAckEvent;
      property OnReConnectReq : TReConnectReqEvent read FReConnectReqEvent write FReConnectReqEvent;
  end;

implementation

{ TMQTTClient }

procedure TMQTT.GotConnAck(Sender: TObject; ReturnCode: integer);
begin
  if Assigned(FConnAckEvent) then OnConnAck(Self, ReturnCode);
end;

procedure TMQTT.GotReConnectReq(Sender: TObject);
begin
  if Assigned(FReConnectReqEvent) then OnReConnectReq(Self);
end;

function TMQTT.Connect: boolean;
var
  Msg: TMQTTMessage;
begin
  if FisConnected then
  begin
    FSocket.CloseSocket;
    FisConnected := false;
  end;

  if Assigned(FSocket) then
    FreeAndNil(FSocket);

  // Create socket and connect.
  FSocket := TTCPBlockSocket.Create;
  try
    FSocket.Connect(Self.FHostname, IntToStr(Self.FPort));
    FisConnected := true;
  except
    // If we encounter an exception upon connection then reraise it, free the socket
    // and reset our isConnected flag.
    on E: Exception do
      begin
        raise;
        FisConnected := false;
        FSocket.Free;
      end;
  end;

  if FisConnected then
  begin
    Msg := ConnectMessage;
    try
      Msg.Payload.Contents.Add(Self.FClientID);
      (Msg.VariableHeader as TMQTTConnectVarHeader).WillFlag := ord(hasWill);
      if hasWill then
      begin
        Msg.Payload.Contents.Add(Self.FWillTopic);
        Msg.Payload.Contents.Add(Self.FWillMsg);
      end;

      if ((Length(FUsername) > 1) and (Length(FPassword) > 1)) then
      begin
        Msg.Payload.Contents.Add(FUsername);
        Msg.Payload.Contents.Add(FPassword);
      end;


//      CodeSiteLog('Connect->WriteData', '0');
      if WriteData(Msg.ToBytes) then Result := true else Result := false;
//      CodeSiteLog('Connect->WriteData', '1');
      // Start our Receive thread.
      if (Result and createAndResumeRecvThread(FSocket)) then
      begin
        //(Round((Msg.VariableHeader as TMQTTConnectVarHeader).KeepAlive * 0.80)) * 1000;
        // Use the KeepAlive that we just sent to determine our ping timer.
        FKeepAliveTimer.Interval := 1800000; //30분에 한번씩 Ping을 해줘야 접속이 유지됨(서버 설정-KeppAlive은 한시간으로 정함)
        FKeepAliveTimer.Enabled := true;
      end;

    finally
      Msg.Free;
    end;
  end;
end;

function TMQTT.ConnectMessage: TMQTTMessage;
begin
  Result := TMQTTMessage.Create;
  Result.VariableHeader := TMQTTConnectVarHeader.Create;
  Result.Payload := TMQTTPayload.Create;
  Result.FixedHeader.MessageType := Ord(TMQTTMessageType.CONNECT);
  Result.FixedHeader.Retain := 0;
  Result.FixedHeader.QoSLevel := 0;
  Result.FixedHeader.Duplicate := 0;
end;

constructor TMQTT.Create(hostName: string; port: integer);
begin
  inherited Create;

  Self.FisConnected := false;
  Self.FHostname := Hostname;
  Self.FPort := Port;
  Self.FMessageID := 1;
  // Randomise and create a random client id.
  Randomize;
  Self.FClientID := 'TMQTT' + IntToStr(Random(1000) + 1);
  FCSSock := TCriticalSection.Create;

  // Create the timer responsible for pinging.
  FKeepAliveTimer := TTimer.Create(nil);
  FKeepAliveTimer.Enabled := false;
  FKeepAliveTimer.OnTimer := KeepAliveTimer_Event;
  FSocket := nil;
end;

function TMQTT.createAndResumeRecvThread(Socket: TTCPBlockSocket): boolean;
begin
  Result := false;
  try
    FRecvThread := TMQTTReadThread.Create(Socket, FCSSock);

    { Todo: Assign Event Handlers here.   }
    FRecvThread.OnConnAck := Self.GotConnAck;
    FRecvThread.OnPublish := Self.GotPub;
    FRecvThread.OnPingResp := Self.GotPingResp;
    FRecvThread.OnSubAck := Self.GotSubAck;
    FRecvThread.OnUnSubAck := Self.GotUnSubAck;
    FRecvThread.OnPubAck := Self.GotPubAck;
    FRecvThread.OnReConnectReq := Self.GotReConnectReq;

    FRecvThread.SubscribeProc := Self.DoSubscribe4Thread;
    FRecvThread.UnSubscribeProc := Self.DoUnSubscribe4Thread;
    FRecvThread.PingReqProc := Self.PingReq;
    Result := true;
  except
    Result := false;
  end;
end;

destructor TMQTT.Destroy;
begin
  if Assigned(FSocket) then
  begin
    if isConnected then
      Disconnect;
  end;

  if Assigned(FKeepAliveTimer) then
    begin
      FreeAndNil(FKeepAliveTimer);
    end;
  if Assigned(FRecvThread) then
    begin
      FreeAndNil(FRecvThread);
    end;
  if Assigned(FCSSock) then
    begin
      FreeAndNil(FCSSock);
    end;
  inherited;
end;

function TMQTT.Disconnect: boolean;
var
  Msg: TMQTTMessage;
begin
  Result := false;

  if isConnected then
  begin
    FKeepAliveTimer.Enabled := false;
    // Terminate our socket receive thread.
    FRecvThread.Terminate;
    FRecvThread.WaitFor;

    Msg := DisconnectMessage;
    if WriteData(Msg.ToBytes) then Result := true else Result := false;
    Msg.Free;
    Result := true;

    // Close our socket.
    FSocket.CloseSocket;
    FisConnected := False;

    // Free everything.
    if Assigned(FRecvThread) then FreeAndNil(FRecvThread);
    if Assigned(FSocket) then FreeAndNil(FSocket);
  end;
end;

function TMQTT.DisconnectMessage: TMQTTMessage;
begin
  Result := TMQTTMessage.Create;
  Result.FixedHeader.MessageType := Ord(TMQTTMessageType.DISCONNECT);
end;

procedure TMQTT.DoPing;
begin
  FRecvThread.IsPingReqExec := True;
end;

procedure TMQTT.DoSubscribe(Topic: Ansistring; RequestQoS: integer);
begin
  FRecvThread.SetSubscribeTopic(Topic, RequestQoS);
  FRecvThread.IsSubscribeExec := True;
end;

procedure TMQTT.DoSubscribe4Thread(Topic: Ansistring; RequestQoS: integer);
begin
  Subscribe(Topic,RequestQoS);
end;

procedure TMQTT.DoUnSubscribe(Topic: Ansistring);
begin
  FRecvThread.SetSubscribeTopic(Topic, 0);
  FRecvThread.IsUnSubscribeExec := True;
end;

procedure TMQTT.DoUnSubscribe4Thread(Topic: Ansistring);
begin
  UnSubscribe(Topic);
end;

function TMQTT.getNextMessageId: integer;
begin
  // If we've reached the upper bounds of our 16 bit unsigned message Id then
  // start again. The spec says it typically does but is not required to Inc(MsgId,1).
  if (FMessageID = 65535) then
    begin
      FMessageID := 1;
    end;

  // Return our current message Id
  Result := FMessageID;
  // Increment message Id
  Inc(FMessageID);
end;

function TMQTT.hasWill: boolean;
begin
  if ((Length(FWillTopic) < 1) and (Length(FWillMsg) < 1)) then
    begin
      Result := false;
    end else Result := true;
end;

procedure TMQTT.KeepAliveTimer_Event(sender: TObject);
begin
  DoPing;
//  if Self.isConnected then
//    begin
//      PingReq;
//    end;
end;

procedure TMQTT.PingReq;
var
  Msg: TMQTTMessage;
begin
  if isConnected then
  begin
    Msg := PingReqMessage;
    CodeSiteLog('PingReq->WriteData', 'WriteData 0');
    if WriteData(Msg.ToBytes) then ;//Result := true else Result := false;
    CodeSiteLog('PingReq->WriteData', 'WriteData 1');
    Msg.Free;
  end;
end;

function TMQTT.PingReqMessage: TMQTTMessage;
begin
  Result := TMQTTMessage.Create;
  Result.FixedHeader.MessageType := Ord(TMQTTMessageType.PINGREQ);
end;

procedure TMQTT.PingStop;
begin
  FKeepAliveTimer.Enabled := False;
end;

procedure TMQTT.GotPingResp(Sender: TObject);
begin
  if Assigned(FPingRespEvent) then OnPingResp(Self);
end;

function TMQTT.Publish(Topic, sPayload: Ansistring; Retain: boolean): boolean;
begin
  Result := Publish(Topic, sPayload, Retain, 0);
end;

function TMQTT.Publish(Topic, sPayload: Ansistring): boolean;
begin
  Result := Publish(Topic, sPayload, false, 0);
end;

function TMQTT.Publish(Topic, sPayload: Ansistring; Retain: boolean;
  QoS: integer): boolean;
var
  Msg: TMQTTMessage;
begin
  if ((QoS > -1) and (QoS <= 3)) then
  begin
    if isConnected then
    begin
       Msg := PublishMessage;
       Msg.FixedHeader.QoSLevel := QoS;
       (Msg.VariableHeader as TMQTTPublishVarHeader).QoSLevel := QoS;
       (Msg.VariableHeader as TMQTTPublishVarHeader).Topic := Topic;
       if (QoS > 0) then
        begin
          (Msg.VariableHeader as TMQTTPublishVarHeader).MessageID := getNextMessageId;
        end;
       Msg.Payload.Contents.Add(sPayload);
       Msg.Payload.PublishMessage := true;
       CodeSiteLog('Publish->WriteData', '0');
       if WriteData(Msg.ToBytes) then Result := true else Result := false;
       CodeSiteLog('Publish->WriteData', '1');
       Msg.Free;
    end;
  end
  else
    raise EInvalidOp.Create('QoS level can only be equal to or between 0 and 3.');
end;

function TMQTT.PublishMessage: TMQTTMessage;
begin
  Result := TMQTTMessage.Create;
  Result.FixedHeader.MessageType := Ord(TMQTTMessageType.PUBLISH);
  Result.VariableHeader := TMQTTPublishVarHeader.Create(0);
  Result.Payload := TMQTTPayload.Create;
end;

procedure TMQTT.GotPubRec(Sender: TObject; MessageID: integer);
begin
  if Assigned(FPubRecEvent) then OnPubRec(Self, MessageID);
end;

procedure TMQTT.GotPubRel(Sender: TObject; MessageID: integer);
begin
  if Assigned(FPubRelEvent) then OnPubRel(Self, MessageID);
end;

function TMQTT.Subscribe(Topic: Ansistring; RequestQoS: integer): integer;
var
  dTopics: TDictionary<Ansistring, integer>;
begin
  dTopics := TDictionary<Ansistring, integer>.Create;
  dTopics.Add(Topic, RequestQoS);
  Result := Subscribe(dTopics);
  dTopics.Free;
end;

procedure TMQTT.GotSubAck(Sender: TObject; MessageID: integer;
  GrantedQoS: array of integer);
begin
  if Assigned(FSubAckEvent) then OnSubAck(Self, MessageID, GrantedQoS);
end;

//procedure TMQTT.SetQos(AQos: integer);
//begin
//  FQos := AQos;
//end;
//
//procedure TMQTT.SetTopic(ATopic: AnsiString);
//begin
//  FTopic :=ATopic;
//  FRecvThread.SetSubscribeTopic(FTopic, FQos);
//end;

function TMQTT.Subscribe(Topics: TDictionary<Ansistring, integer>): integer;
var
  Msg: TMQTTMessage;
  MsgId: Integer;
  sTopic: AnsiString;
  data: TBytes;
begin
  Result := -1;
  if isConnected then
    begin
      Msg := SubscribeMessage;
      MsgId := getNextMessageId;
      (Msg.VariableHeader as TMQTTSubscribeVarHeader).MessageID := MsgId;

      for sTopic in Topics.Keys do
      begin
        Msg.Payload.Contents.Add(sTopic);
        Msg.Payload.Contents.Add(IntToStr(Topics.Items[sTopic]))
      end;
      // the subscribe message contains integer literals not encoded as strings.
      Msg.Payload.ContainsIntLiterals := true;

      data := Msg.ToBytes;
      CodeSiteLog('Subscribe->WriteData', '0');
      if WriteData(data) then Result := MsgId;
      CodeSiteLog('Subscribe->WriteData', '1');

      Msg.Free;
    end;
end;

function TMQTT.SubscribeMessage: TMQTTMessage;
begin
  Result := TMQTTMessage.Create;
  Result.FixedHeader.MessageType := Ord(TMQTTMessageType.SUBSCRIBE);
  Result.FixedHeader.QoSLevel := 1;  //0->1로 수정함 by pjh (SubScribe할때마다 접속 끊기는 문제 해결위함)
  Result.VariableHeader := TMQTTSubscribeVarHeader.Create;
  Result.Payload := TMQTTPayload.Create;
end;

function TMQTT.Unsubscribe(Topic: Ansistring): integer;
var
  slTopics: TStringList;
begin
  slTopics := TStringList.Create;
  slTopics.Add(Topic);
  Result := Unsubscribe(slTopics);
  slTopics.Free;
end;

procedure TMQTT.GotUnSubAck(Sender: TObject; MessageID: integer);
begin
  if Assigned(FUnSubAckEvent) then OnUnSubAck(Self, MessageID);
end;

function TMQTT.Unsubscribe(Topics: TStringList): integer;
var
  Msg: TMQTTMessage;
  MsgId: integer;
  sTopic: AnsiString;
begin
  Result := -1;

  if isConnected then
  begin
    Msg := UnsubscribeMessage;
    MsgId := getNextMessageId;
    TMQTTSubscribeVarHeader(Msg.VariableHeader).MessageID := MsgId;

    Msg.Payload.Contents.AddStrings(Topics);

    CodeSiteLog('Unsubscribe->WriteData', '0');
    if WriteData(Msg.ToBytes) then Result := MsgId;
    CodeSiteLog('Unsubscribe->WriteData', '1');

    Msg.Free;
  end;
end;

function TMQTT.UnsubscribeMessage: TMQTTMessage;
var
  Msg: TMQTTMessage;
begin
  Result := TMQTTMessage.Create;
  Result.FixedHeader.MessageType := Ord(TMQTTMessageType.UNSUBSCRIBE);
  Result.FixedHeader.QoSLevel := 1;
  Result.VariableHeader := TMQTTUnsubscribeVarHeader.Create;
  Result.Payload := TMQTTPayload.Create;
end;

function TMQTT.WriteData(AData: TBytes): boolean;
var
  sentData: integer;
  attemptsToWrite: integer;
begin
  Result := False;
  sentData := 0;
  attemptsToWrite := 1;

  if isConnected then
  begin
    repeat
      FCSSock.Acquire;
      try
        if FSocket.CanWrite(500 * attemptsToWrite) then
        begin
          sentData := sentData + FSocket.SendBuffer(Pointer(Copy(AData, sentData - 1, Length(AData) + 1)), Length(AData) - sentData);
          Inc(attemptsToWrite);
        end;
      finally
        FCSSock.Release;
      end;
    until ((attemptsToWrite = 3) or (sentData = Length(AData)));

    if sentData = Length(AData) then
    begin
      Result := True;
      FisConnected := true;
    end
    else
    begin
      Result := False;
      FisConnected := false;
      Connect;
      raise Exception.Create('Error Writing to Socket, it appears to be disconnected');
    end;
  end;
end;


procedure TMQTT.GotPub(Sender: TObject; topic, payload: Ansistring);
begin
  if Assigned(FPublishEvent) then OnPublish(Self, topic, payload);
end;

procedure TMQTT.GotPubAck(Sender: TObject; MessageID: integer);
begin
  if Assigned(FPubAckEvent) then OnPubAck(Self, MessageID);
end;

procedure TMQTT.GotPubComp(Sender: TObject; MessageID: integer);
begin
  if Assigned(FPubCompEvent) then OnPubComp(Self, MessageID);
end;

end.

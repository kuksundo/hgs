unit UnitMQTTClass;

interface

uses System.SysUtils, System.Classes, WinApi.Windows,
 MQTT, OtlComm, OtlCommon, OtlSync,
 UnitWorker4OmniMsgQ, UnitMQTTMsg.Events,
 UnitMQTTMsg.EventThreads;

type
  TMQTTMsgEventProc = procedure(AMsgEvent: TMQTTMsgEvent) of object;

  TpjhMQTTClass = class
  private
    FMqtt: TMQTT;
    FUserId, FPasswd, FHostIP, FHostPort,
    FTopic: string;
//    FThSender: TThreadSender4STOMP;
    FpjhOmniMsgQClass: TpjhOmniMsgQClass;
    FSubScribeTopicList: TStringList;
    FDisconnecting: Boolean;
    FMQTTMsgEventProc: TMQTTMsgEventProc;
    FWaiteUntilDisConnect : TWaitFor;
    FHandles: array of THandle;

    procedure CreateEvents(manualReset: boolean);
    procedure DestroyEvents;
    procedure WaitForAll(timeout_ms: cardinal; expectedResult: TWaitFor.TWaitResult;
      const msg: string);

    procedure GotConnAck(Sender: TObject; ReturnCode: integer);
    procedure GotPingResp(Sender: TObject);
    procedure GotSubAck(Sender: TObject; MessageID: integer; GrantedQoS: Array of integer);
    procedure GotUnSubAck(Sender: TObject; MessageID: integer);
    procedure GotPub(Sender: TObject; topic, payload: Ansistring);
    procedure GotPubAck(Sender: TObject; MessageID: integer);
    procedure GotPubRec(Sender: TObject; MessageID: integer);
    procedure GotPubRel(Sender: TObject; MessageID: integer);
    procedure GotPubComp(Sender: TObject; MessageID: integer);
  public
    constructor Create(AUserId, APasswd, AHostIp, AHostPort, ATopic: string; AHandle: THandle);
    destructor Destroy; override;

    function ConnectMQTT(AIP: string = ''; APort: string=''): boolean;
    function DisConnectMQTT: Boolean;
    procedure StartWorker;
    procedure StopWorker;

    procedure MQTTSendMsg(AMsg: string);
    procedure SetFormHandle(AHandle: THandle);
    function GetResponseQMsg(var AMsg: TOmniMessage): Boolean;
    procedure ProcessMQTTMsg(AMsgEvent: TMQTTMsgEvent);
    procedure SetSynchroProc(AProc: TSynchroProc);
    procedure SetMQTTMsgProc(AProc: TMQTTMsgProc);

    procedure MQTTPing;
    procedure MQTTPublishMsg(ATopic, AMsg: string);
    function MQTTSubscribe(ATopic: string; AMQTTQOSType: integer): integer;
    function MQTTUnSubscribe(ATopic: string = ''): integer;

    property OnTMQTTMsgEventProc : TMQTTMsgEventProc read FMQTTMsgEventProc write FMQTTMsgEventProc;
  end;

var
  GlobalSection: TRTLCriticalSection;

implementation

const
  EVENT_SIZE = 1;

function TpjhMQTTClass.ConnectMQTT(AIP: string; APort: string): boolean;
var
  LStr: string;
begin
  Result := False;
  FDisconnecting := False;

  if AIP = '' then
    AIP := FHostIP;

  if APort = '' then
    APort := FHostPort;

  if not Assigned(FMQTT) then
  begin
    FMQTT := TMQTT.Create(AIP, StrToInt(APort));
    FMQTT.WillTopic := '/clients/will';
    FMQTT.WillMsg := 'Broker died!';
    // Events
    FMQTT.OnConnAck := GotConnAck;
    FMQTT.OnPublish := GotPub;
    FMQTT.OnPingResp := GotPingResp;
    FMQTT.OnSubAck := GotSubAck;
    FMQTT.OnUnSubAck := GotUnSubAck;
    FMQTT.OnPubAck := GotPubAck;

    if FMQTT.Connect then
    begin
      if FTopic <> '' then
      begin
        FMQTT.DoSubscribe(FTopic, 0);
        TMQTTMsgEvent.Create('Topic', FTopic + ' is subscribed',0,4).Queue

//        if MQTTSubscribe(FTopic, 0) > -1 then
//          TMQTTMsgEvent.Create('Topic', FTopic + ' is subscribed').Queue
//        else
//          TMQTTMsgEvent.Create('Topic', FTopic + ' is not subscribed').Queue
      end;

      LStr := 'Connected to ' + AIP + ' on ' + APort + ': Topic = ' + FTopic;
    end
    else
      LStr := 'Failed to connect';

    Result := True;
    TMQTTMsgEvent.Create('', LStr).Queue;
  end
  else
    TMQTTMsgEvent.Create('Connect Error: ', 'Already Assigned MQTT',0,4).Queue;

end;

constructor TpjhMQTTClass.Create(AUserId, APasswd, AHostIp, AHostPort,
  ATopic: string; AHandle: THandle);
begin
  FDisconnecting := False;
  CreateEvents(true);

  if AHostPort = '' then
    AHostPort := '1883';

  FUserId := AUserId;
  FPasswd := APasswd;
  FHostIP := AHostIp;
  FHostPort := AHostPort;
  FTopic := ATopic;

  FSubScribeTopicList := TStringList.Create;
  FpjhOmniMsgQClass := TpjhOmniMsgQClass.Create(1000, AHandle);
  MQTTMsgEventThread.SetMQTTMsgProc(ProcessMQTTMsg);

  ConnectMQTT;
end;

procedure TpjhMQTTClass.CreateEvents(manualReset: boolean);
var
  i: integer;
begin
  SetLength(FHandles, EVENT_SIZE);

  for i := Low(FHandles) to High(FHandles) do
    FHandles[i] := CreateEvent(nil, manualReset, false, nil);

  FWaiteUntilDisConnect := TWaitFor.Create(FHandles);
end;

destructor TpjhMQTTClass.Destroy;
begin
  DisConnectMQTT;
  FpjhOmniMsgQClass.Free;
  FSubScribeTopicList.Free;
  DestroyEvents;

  inherited;
end;

procedure TpjhMQTTClass.DestroyEvents;
var
  i: integer;
begin
  FreeAndNil(FWaiteUntilDisConnect);

  for i := Low(FHandles) to High(FHandles) do
    if FHandles[i] <> 0 then
      Win32Check(CloseHandle(FHandles[i]));
end;

function TpjhMQTTClass.DisConnectMQTT: Boolean;
begin
  Result := False;
  FDisconnecting := True;

  if Assigned(FMQTT) then
  begin
    TMQTTMsgEvent.Create('','DisConnectMQTT Start....',0,4).Queue;
    FMQTT.DoUnSubscribe(FTopic);
    FMQTT.OnPublish := nil;
    FMQTT.OnPingResp := nil;
    TMQTTMsgEvent.Create('','DisConnectMQTT Doing!',0,4).Queue;

    WaitForAll(2000, waAwaited, 'Waiting for UnSubscribed in 3 seconds');

    if FMQTT.Disconnect then
    begin
      FreeAndNil(FMQTT);
      TMQTTMsgEvent.Create('','FreeAndNil(FMQTT) 성공',0,4).Queue;
    end
    else
      TMQTTMsgEvent.Create('','FreeAndNil(FMQTT) 실패',0,4).Queue;
//    mStatus.Lines.Add('Disconnected');
  end;

  Result := True;
end;

function TpjhMQTTClass.GetResponseQMsg(var AMsg: TOmniMessage): Boolean;
begin
  Result := FpjhOmniMsgQClass.FResponseQueue.TryDequeue(AMsg);
end;

procedure TpjhMQTTClass.GotConnAck(Sender: TObject; ReturnCode: integer);
begin
  TMQTTMsgEvent.Create('', 'Connection Acknowledged: ' + IntToStr(ReturnCode),0,4).Queue;
end;

procedure TpjhMQTTClass.GotPingResp(Sender: TObject);
begin
  if FDisconnecting then
    exit;
  TMQTTMsgEvent.Create('', 'PONG ',1,4).Queue;
end;

procedure TpjhMQTTClass.GotPub(Sender: TObject; topic, payload: Ansistring);
begin
  if FDisconnecting then
    exit;

  TMQTTMsgEvent.Create(topic, payload,0).Queue;
//  mStatus.Lines.Add('Message Recieved on ' + topic + ' payload: ' + payload);
end;

procedure TpjhMQTTClass.GotPubAck(Sender: TObject; MessageID: integer);
begin
  TMQTTMsgEvent.Create('', 'Got PubAck ' + IntToStr(MessageID),0,4).Queue;
end;

procedure TpjhMQTTClass.GotPubComp(Sender: TObject; MessageID: integer);
begin
  TMQTTMsgEvent.Create('', 'Got PubComp ' + IntToStr(MessageID),0,4).Queue;
end;

procedure TpjhMQTTClass.GotPubRec(Sender: TObject; MessageID: integer);
begin
  TMQTTMsgEvent.Create('', 'Got PubRec ' + IntToStr(MessageID),0,4).Queue;
end;

procedure TpjhMQTTClass.GotPubRel(Sender: TObject; MessageID: integer);
begin
  TMQTTMsgEvent.Create('', 'Got PubRel ' + IntToStr(MessageID),0,4).Queue;
end;

procedure TpjhMQTTClass.GotSubAck(Sender: TObject; MessageID: integer;
  GrantedQoS: array of integer);
begin
  TMQTTMsgEvent.Create('', 'Got SubAck ' + IntToStr(MessageID),0,4).Queue;
end;

procedure TpjhMQTTClass.GotUnSubAck(Sender: TObject; MessageID: integer);
begin
  TMQTTMsgEvent.Create('', 'Got UnSubAck ' + IntToStr(MessageID),0,4).Queue;
  SetEvent(FHandles[0]);
end;

procedure TpjhMQTTClass.MQTTPing;
begin
  if FDisconnecting then
    exit;

  if Assigned(FMQTT) then
  begin
//    mStatus.Lines.Add('Ping');
    FMQTT.PingReq;
  end;
end;

procedure TpjhMQTTClass.MQTTPublishMsg(ATopic, AMsg: string);
begin
  if Assigned(FMQTT) then
  begin
    FMQTT.Publish(ATopic, AMsg);
//    mStatus.Lines.Add('Published');
  end;
end;

procedure TpjhMQTTClass.MQTTSendMsg(AMsg: string);
begin

end;

function TpjhMQTTClass.MQTTSubscribe(ATopic: string; AMQTTQOSType: integer): integer;
begin
  Result := -2;

  if Assigned(FMQTT) then
  begin
    FMQTT.DoSubscribe(ATopic, AMQTTQOSType);
    if Result <> -1 then
      FSubScribeTopicList.Add(ATopic);
//    mStatus.Lines.Add('Subscribe');
  end;
end;

function TpjhMQTTClass.MQTTUnSubscribe(ATopic: string): integer;
var
  i: integer;
begin
  if ATopic = '' then
  begin
    for i := 0 to FSubScribeTopicList.Count - 1 do
      Result := FMQTT.Unsubscribe(FSubScribeTopicList.Strings[i]);

    FSubScribeTopicList.Clear;
  end
  else
  begin
    Result := FMQTT.Unsubscribe(ATopic);

    i := FSubScribeTopicList.IndexOf(ATopic);

    if i > -1 then
      FSubScribeTopicList.Delete(i);
  end;
end;

//Event Thread 에서 실행 됨
procedure TpjhMQTTClass.ProcessMQTTMsg(AMsgEvent: TMQTTMsgEvent);
var
  rec   : TCommandMsgRecord;
  LValue: TOmniValue;
begin
  if Assigned(OnTMQTTMsgEventProc) then
    OnTMQTTMsgEventProc(AMsgEvent);
//  rec.FCommand := AMsgEvent.Command;
//  rec.FTopic := AMsgEvent.Topic;
//  rec.FMessage := AMsgEvent.FFMessage;
//  LValue := TOmniValue.FromRecord<TCommandMsgRecord>(rec);
//
//  if not FpjhOmniMsgQClass.FResponseQueue.Enqueue(TOmniMessage.Create(0, LValue)) then
//    raise Exception.Create('Response queue is full when ProcessMQTTMsg!');
end;

procedure TpjhMQTTClass.SetFormHandle(AHandle: THandle);
begin
  FpjhOmniMsgQClass.FormHandle := AHandle;
end;

procedure TpjhMQTTClass.SetMQTTMsgProc(AProc: TMQTTMsgProc);
begin
  MQTTMsgEventThread.SetMQTTMsgProc(AProc);
end;

procedure TpjhMQTTClass.SetSynchroProc(AProc: TSynchroProc);
begin
end;

procedure TpjhMQTTClass.StartWorker;
begin

end;

procedure TpjhMQTTClass.StopWorker;
begin

end;

procedure TpjhMQTTClass.WaitForAll(timeout_ms: cardinal;
  expectedResult: TWaitFor.TWaitResult; const msg: string);
begin
  if FWaiteUntilDisConnect.WaitAll(timeout_ms) = expectedResult then
    TMQTTMsgEvent.Create('', 'Disconnect wait OK ', 0,4).Queue
  else
    TMQTTMsgEvent.Create('', 'Disconnect wait returned unexpected result ', 0,4).Queue;
end;

end.

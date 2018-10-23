unit UnitSTOMPClass;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, System.SyncObjs,
  stompclient, StompTypes,
  OtlComm, OtlCommon, UnitWorker4OmniMsgQ, UnitSTOMPMsg.Events;

type
  TSTOMPMsgEventProc = procedure(AMsgEvent: TSTOMPMsgEvent) of object;

  TThreadReceiver4STOMP = class(TThread)
  private
    FStompClient: IStompClient;
    FStompFrame: IStompFrame;
    procedure SetStompClient(const Value: IStompClient);
  protected
    procedure Execute; override;
  public
    FResponseQueue: TOmniMessageQueue;

    constructor Create(CreateSuspended: Boolean; AresponseQueue: TOmniMessageQueue);
    procedure ReceiveStompMsg;
    property StompClient: IStompClient read FStompClient write SetStompClient;
  end;

  TThreadSender4STOMP = class(TThread)
  private
    FStopEvent    : TEvent;
    FStompClient: IStompClient;
    FStompFrame: IStompFrame;
    FSendMsgQueue: TOmniMessageQueue;
    FUserId: string;

    procedure SetStompClient(const Value: IStompClient);
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; ASendMsgQueue: TOmniMessageQueue;
      AUserId: string);
    destructor Destroy; override;

    procedure Stop;
    procedure SendStompMsg(ATopic, AMsg: string);
    property StompClient: IStompClient read FStompClient write SetStompClient;
  end;

  TpjhSTOMPClass = class
  private
    FStomp: IStompClient;//TStompClient;
    FUserId, FPasswd, FHostIP, FHostPort: string;
    FTopicList: TStringList;
    FThReceiver: TThreadReceiver4STOMP;
    FThSender: TThreadSender4STOMP;
    FpjhOmniMsgQClass: TpjhOmniMsgQClass;
    FSTOMPMsgEventProc: TSTOMPMsgEventProc;
    FIsSubScribe: Boolean;
  public
    constructor Create(AUserId, APasswd, AHostIp: string; ATopic: TStrings;
      AHandle: THandle; AIsConnectNow: Boolean = True);
    constructor CreateWithStr(AUserId, APasswd, AHostIp, ATopic: string;
      AHandle: THandle; AIsSubScribe: Boolean = True; AIsConnectNow: Boolean = True);
    destructor Destroy; override;

    function ConnectStomp(AIsSubscribe: Boolean = True): boolean;
    function DisConnectStomp: Boolean;
    procedure StartWorker;
    procedure StopWorker;

    procedure StompSendMsg(AMsg: string; ATopic: string = '');
    procedure SetFormHandle(AHandle: THandle);
    function GetResponseQMsg(var AMsg: TOmniMessage): Boolean;
    procedure AddTopic2List(ATopic: string); overload;
    procedure AddTopic2List(ATopicList: TStrings); overload;
    procedure ProcessSTOMPMsg(AMsgEvent: TSTOMPMsgEvent);

    property UserId: string read FuserId;
    property Passwd: string read FPasswd;
    property HostIP: string read FHostIP;
    property HostPort: string read FHostPort;
    property IsSubScribe: Boolean read FIsSubScribe;
    property TopicList: TStringList read FTopicList;
    property OnSTOMPMsgEventProc : TSTOMPMsgEventProc read FSTOMPMsgEventProc write FSTOMPMsgEventProc;
  end;

implementation

uses UnitSTOMPMsg.EventThreads;

{ TpjhSTOMPClass }

procedure TpjhSTOMPClass.AddTopic2List(ATopic: string);
begin
  FTopicList.Add(ATopic);
end;

procedure TpjhSTOMPClass.AddTopic2List(ATopicList: TStrings);
var
  i: integer;
begin
  FTopicList.Clear;

  for i := 0 to ATopicList.Count - 1 do
    FTopicList.Add(ATopicList.Strings[i]);
end;

function TpjhSTOMPClass.ConnectStomp(AIsSubscribe: Boolean): boolean;
var
  i: integer;
begin
  if not Assigned(FStomp) then
    FStomp := TStompClient.Create;

  FStomp.SetUserName(FUserId); //pjh
  FStomp.SetPassword(FPasswd); //pjh
  FStomp.SetHeartBeat(5000,5000);
  FStomp.Connect(FHostIP);

  if AIsSubscribe then
    for i := 0 to FTopicList.Count - 1 do
      FStomp.Subscribe(FTopicList.Strings[i], amAuto); //amClient

  StartWorker;

  Result := FStomp.Connected;
end;

constructor TpjhSTOMPClass.CreateWithStr(AUserId, APasswd, AHostIp, ATopic: string;
  AHandle: THandle; AIsSubScribe: Boolean; AIsConnectNow: Boolean);
begin
  FUserId := AUserId;
  FPasswd := APasswd;
  FHostIP := AHostIp;

  if not Assigned(FTopicList) then
    FTopicList := TStringList.Create;

  AddTopic2List(ATopic);

  FThReceiver := nil;
  FpjhOmniMsgQClass := TpjhOmniMsgQClass.Create(1000, AHandle);
  STOMPMsgEventThread.SetSTOMPMsgProc(ProcessSTOMPMsg);
  FIsSubScribe := AIsSubScribe;

  if AIsConnectNow then
    ConnectStomp(AIsSubScribe);
end;

constructor TpjhSTOMPClass.Create(AUserId, APasswd, AHostIp: string;
   ATopic: TStrings; AHandle: THandle; AIsConnectNow: Boolean);
begin
  FUserId := AUserId;
  FPasswd := APasswd;
  FHostIP := AHostIp;

  if not Assigned(FTopicList) then
    FTopicList := TStringList.Create;

  AddTopic2List(ATopic);

  FThReceiver := nil;
  FpjhOmniMsgQClass := TpjhOmniMsgQClass.Create(1000, AHandle);

  if AIsConnectNow then
    ConnectStomp;
end;

destructor TpjhSTOMPClass.Destroy;
begin
  StopWorker;
//  DisConnectStomp;

//  FThReceiver.Terminate;
//  FThReceiver.FResponseQueue.Enqueue(TOmniMessage.Create(0, ''));
//  Sleep(10);
//  FThReceiver.Free;
//  FThSender.Terminate;
//  FThSender.FSendMsgQueue.Enqueue(TOmniMessage.Create(0, ''));
//  Sleep(10);
//  FThSender.Free;
  FpjhOmniMsgQClass.Free;
  FTopicList.Free;
//  FStomp.Free;
//  inherited;
end;

function TpjhSTOMPClass.DisConnectStomp: Boolean;
var
  i: integer;
begin
  if FStomp.Connected then
  begin
    if FIsSubScribe then
      for i := 0 to FTopicList.Count - 1 do
        FStomp.Unsubscribe(FTopicList.Strings[i]);
    FStomp.Disconnect;
  end;
end;

function TpjhSTOMPClass.GetResponseQMsg(var AMsg: TOmniMessage): Boolean;
begin
  Result := FThReceiver.FResponseQueue.TryDequeue(AMsg);
end;

procedure TpjhSTOMPClass.ProcessSTOMPMsg(AMsgEvent: TSTOMPMsgEvent);
begin
  if Assigned(OnSTOMPMsgEventProc) then
    OnSTOMPMsgEventProc(AMsgEvent);
end;

procedure TpjhSTOMPClass.SetFormHandle(AHandle: THandle);
begin
  FpjhOmniMsgQClass.FormHandle := AHandle;
end;

procedure TpjhSTOMPClass.StartWorker;
begin
  if not Assigned(FThReceiver) then
  begin
    FThReceiver := TThreadReceiver4STOMP.Create(True, FpjhOmniMsgQClass.FResponseQueue);
    FThReceiver.StompClient := FStomp;
    FThReceiver.Start;
  end;

  if not Assigned(FThSender) then
  begin
    FThSender := TThreadSender4STOMP.Create(True, FpjhOmniMsgQClass.FSendMsgQueue,FUserId);
    FThSender.StompClient := FStomp;
    FThSender.Start;
  end;
end;

procedure TpjhSTOMPClass.StompSendMsg(AMsg: string; ATopic: string);
begin
  if ATopic = '' then
    ATopic := FTopicList.Strings[0];

  if Assigned(FStomp) then
  begin
    if not FStomp.Connected then
      ConnectStomp(False);
  end
  else
    ConnectStomp(False);

  if FStomp.Connected then
  begin
    FStomp.Send(ATopic, AMsg,
      StompUtils.NewHeaders
        .Add('sender', FUserId)
        .Add('datetime', FormatDateTime('yyyy/mm/dd hh:nn:ss', now))
        .Add(TStompHeaders.NewPersistentHeader(true))
        );

    TSTOMPMsgEvent.Create(ATopic, 'StompSendMsg => ' + AMsg).Queue;
  end;
end;

procedure TpjhSTOMPClass.StopWorker;
begin
  if Assigned(FThReceiver) then
  begin
    TThreadReceiver4STOMP(FThReceiver).Terminate;
    FThReceiver.WaitFor;
    FreeAndNil(FThReceiver);
  end;

  if Assigned(FThSender) then
  begin
    TThreadSender4STOMP(FThSender).Stop;
    FThSender.WaitFor;
    FreeAndNil(FThSender);
  end;
end;

{ TThreadReceiver4STOMP }

constructor TThreadReceiver4STOMP.Create(CreateSuspended: Boolean;
  AresponseQueue: TOmniMessageQueue);
begin
  FStompFrame := TStompFrame.Create;
  FResponseQueue := AresponseQueue;
  inherited Create(CreateSuspended);
end;

procedure TThreadReceiver4STOMP.Execute;
begin
  NameThreadForDebugging('ThreadReceiver');

  while not Terminated do
  begin
    if FStompClient.Receive(FStompFrame,2000) then
    begin
      Sleep(100);
      ReceiveStompMsg;
    end
    else
    begin

    end;
  end;
end;

procedure TThreadReceiver4STOMP.ReceiveStompMsg;
var
  LValue: TOmniValue;
begin
  LValue := FStompFrame;
  if not FResponseQueue.Enqueue(TOmniMessage.Create(0, LValue)) then
    raise Exception.Create('Response queue is full!');
//  ReceiverMainForm.MessageMemo.Lines.Add(FStompFrame.Output);
end;

procedure TThreadReceiver4STOMP.SetStompClient(const Value: IStompClient);
begin
  FStompClient := Value;
end;

{ TThreadSender4STOMP }

constructor TThreadSender4STOMP.Create(CreateSuspended: Boolean;
  ASendMsgQueue: TOmniMessageQueue; AUserId: string);
begin
  FStompFrame := TStompFrame.Create;
  FSendMsgQueue := ASendMsgQueue;
  FUserId := AUserId;

  FStopEvent := TEvent.Create;

  inherited Create(CreateSuspended);
end;

destructor TThreadSender4STOMP.Destroy;
begin
  FreeAndNil(FStopEvent);

  inherited;
end;

procedure TThreadSender4STOMP.Execute;
var
  handles: array [0..1] of THandle;
  msg    : TOmniMessage;
  rec    : TCommandMsgRecord;
begin
  handles[0] := FStopEvent.Handle;
  handles[1] := FSendMsgQueue.GetNewMessageEvent;

  while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
  begin
    if Terminated then
      exit;

    while FSendMsgQueue.TryDequeue(msg) do
    begin
      rec := msg.MsgData.ToRecord<TCommandMsgRecord>;
      SendStompMsg(rec.FTopic, rec.FMessage);
    end;
  end;
end;

procedure TThreadSender4STOMP.SendStompMsg(ATopic, AMsg: string);
begin
  FStompClient.Send(ATopic, AMsg,
    StompUtils.NewHeaders
      .Add('sender', FUserId)
      .Add('datetime', FormatDateTime('yyyy/mm/dd hh:nn:ss', now))
      .Add(TStompHeaders.NewPersistentHeader(true))
      );
end;

procedure TThreadSender4STOMP.SetStompClient(const Value: IStompClient);
begin
  FStompClient := Value;
end;

procedure TThreadSender4STOMP.Stop;
begin
  FStopEvent.SetEvent;
end;

end.

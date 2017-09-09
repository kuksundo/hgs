unit UnitWorker4OmniMsgQ;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Winapi.Messages,
  OtlCommon, OtlComm, System.SyncObjs, OtlContainerObserver;

const
  MSG_RESULT = WM_USER + 1000;

type
  TProcessResults = procedure of object;

  TCommandWord = (cwNone, cwSendMsg, cwRecvMsg, cwDispMsg, cwCustomCommand);

  TCommandMsgRecord = record
    FCommand: integer;
    FTopic: string;
    FMessage: string;
  end;

  //FCommandQueue에 메시지가 들어오면 FCommand = 1 이면 FSendMsgQueue에,
  //                                  FCommand = 2 이면 FResponseQueue에 저장하는 역할
  TWorker = class(TThread)
  private
    FCommandQueue : TOmniMessageQueue;
    FResponseQueue: TOmniMessageQueue;
    FSendMsgQueue: TOmniMessageQueue;
    FStopEvent    : TEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(commandQueue, responseQueue, sendQueue: TOmniMessageQueue);
    destructor Destroy; override;
    procedure Stop;
  end;

  {ex:
    var
      LOmniValue: TOmniValue;
      LChgNotifyRecord: TChgNotifyRecord;

    LChgNotifyRecord.FSendUrl := SenderUrl;
    LOmniValue := TOmniValue.FromRecord<TChgNotifyRecord>(LChgNotifyRecord);

    AMsgQ := TpjhOmniMsgQClass.Create(1000);
    AMsgQ.ProcessResults := MyProc;
    if not AMsgQ.FCommandQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
      raise Exception.Create('Command queue is full!');
  }
  TpjhOmniMsgQClass = class
    FCommandQueue    : TOmniMessageQueue;
    FSendMsgQueue    : TOmniMessageQueue;
    FSendMsgObserver : TOmniContainerWindowsEventObserver;
    FResponseQueue   : TOmniMessageQueue;
    FResponseObserver: TOmniContainerWindowsMessageObserver;
    FWorker          : TWorker;
    FFormHandle: THandle;
    class var FProcessResults: TProcessResults;

    class procedure SetProcessResult(AProc: TProcessResults); static;
    procedure StartWorker(AnumMessages: integer; AMsg: Cardinal = MSG_RESULT);
    procedure StopWorker;
    procedure SetFormHandle(AHandle: THandle);
  public
    //AWMMsg : Window Message (WM_USER + xxxx)
    constructor Create(AnumMessages: integer; AHandle: THandle; AWMMsg: Cardinal = MSG_RESULT);
    destructor Destroy;

    property CommandQueue: TOmniMessageQueue read FCommandQueue write FCommandQueue;
    property ResponseQueue: TOmniMessageQueue read FResponseQueue write FResponseQueue;
    property SendMsgQueue: TOmniMessageQueue read FSendMsgQueue write FSendMsgQueue;
    property FormHandle: THandle read FFormHandle write SetFormHandle;
    class property ProcessResults: TProcessResults read FProcessResults write SetProcessResult;
  end;

implementation

{ TWorker ex:
    if not g_CommandQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
      raise Exception.Create('Command queue is full!');
 }

constructor TWorker.Create(commandQueue, responseQueue,
  sendQueue: TOmniMessageQueue);
begin
  inherited Create;

  FCommandQueue := commandQueue;
  FResponseQueue := responseQueue;
  FSendMsgQueue := sendQueue;
  FStopEvent := TEvent.Create;
end;

destructor TWorker.Destroy;
begin
  FreeAndNil(FStopEvent);
  inherited;
end;

procedure TWorker.Execute;
var
  handles: array [0..1] of THandle;
  msg    : TOmniMessage;
  rec    : TCommandMsgRecord;
//  LOmniValue: TOmniValue;
begin
  handles[0] := FStopEvent.Handle;
  handles[1] := FCommandQueue.GetNewMessageEvent;

  while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
  begin
//    LOmniValue := TOmniValue.FromRecord<TDispMsgRecord>(rec);
    while FCommandQueue.TryDequeue(msg) do
    begin
      rec := msg.MsgData.ToRecord<TCommandMsgRecord>;

      case TCommandWord(rec.FCommand) of
        cwSendMsg: begin//send Msg (1)
          if not FSendMsgQueue.Enqueue(TOmniMessage.Create(msg.MsgID, msg.MsgData)) then
            raise Exception.Create('SendMsgQueue is full!');
        end;
        cwRecvMsg: begin//Recv Msg (2)
          if not FResponseQueue.Enqueue(TOmniMessage.Create(msg.MsgID, msg.MsgData)) then
            raise Exception.Create('Response queue is full!');
        end;
        cwDispMsg: begin//Display Msg (3)
          if not FResponseQueue.Enqueue(TOmniMessage.Create(msg.MsgID, msg.MsgData)) then
            raise Exception.Create('Response queue is full!');
        end;
      end;

      if Assigned(TpjhOmniMsgQClass.ProcessResults) then
        TpjhOmniMsgQClass.ProcessResults();
    end;
  end;
end;

procedure TWorker.Stop;
begin
  FStopEvent.SetEvent;
end;

{ TpjhOmniMsgQClass }

constructor TpjhOmniMsgQClass.Create(AnumMessages: integer; AHandle: THandle;
  AWMMsg: Cardinal);
begin
  FProcessResults := nil;
  FFormHandle := AHandle;
  StartWorker(AnumMessages, AWMMsg);
end;

destructor TpjhOmniMsgQClass.Destroy;
begin
  StopWorker;
end;

procedure TpjhOmniMsgQClass.SetFormHandle(AHandle: THandle);
begin
  FFormHandle := AHandle;
end;

class procedure TpjhOmniMsgQClass.SetProcessResult(AProc: TProcessResults);
begin
  FProcessResults := AProc;
end;

procedure TpjhOmniMsgQClass.StartWorker(AnumMessages: integer; AMsg: Cardinal);
begin
  FCommandQueue := TOmniMessageQueue.Create(AnumMessages); //1000

  FSendMsgQueue := TOmniMessageQueue.Create(AnumMessages);
  //아래 내용 살리면 Abstract Error 발생함(Main Form과 통신하는 수단 인데...)
//  FSendMsgObserver := TOmniContainerWindowsEventObserver.Create;
//  FSendMsgQueue.ContainerSubject.Attach(FSendMsgObserver, coiNotifyOnAllInserts);

  FResponseQueue := TOmniMessageQueue.Create(AnumMessages, false); //1000
  FResponseObserver := CreateContainerWindowsMessageObserver(FFormHandle, AMsg, 0, 0);
  FResponseQueue.ContainerSubject.Attach(FResponseObserver, coiNotifyOnAllInserts);

  FWorker := TWorker.Create(FCommandQueue, FResponseQueue, FSendMsgQueue);
end;

procedure TpjhOmniMsgQClass.StopWorker;
begin
  if Assigned(FWorker) then
  begin
    TWorker(FWorker).Stop;
    FWorker.WaitFor;
    FreeAndNil(FWorker);
  end;

  if Assigned(FResponseQueue) then
  begin
    FResponseQueue.ContainerSubject.Detach(FResponseObserver, coiNotifyOnAllInserts);
    FreeAndNil(FResponseObserver);
    ProcessResults;
    FreeAndNil(FResponseQueue);
  end;

  if Assigned(FSendMsgQueue) then
  begin
    FSendMsgQueue.ContainerSubject.Detach(FSendMsgObserver, coiNotifyOnAllInserts);
    TEvent(FSendMsgObserver.GetEvent).SetEvent;
    FreeAndNil(FSendMsgObserver);
    FreeAndNil(FSendMsgQueue);
  end;

  FreeAndNil(FCommandQueue);
end;

end.

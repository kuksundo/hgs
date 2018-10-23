unit UnitHhiSMSClass;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, System.SyncObjs,
  OtlComm, OtlCommon, UnitWorker4OmniMsgQ, UnitHHIMessage;

type
  TThreadSender4HhiSMS = class(TThread)
  private
    FStopEvent    : TEvent;
    FSendMsgQueue: TOmniMessageQueue;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; ASendMsgQueue: TOmniMessageQueue);
    destructor Destroy; override;
    procedure Stop;
  end;

  TpjhHhiSMSClass = class
  private
    FThSender: TThreadSender4HhiSMS;
    FpjhOmniMsgQClass: TpjhOmniMsgQClass;
  public
    constructor Create(AHandle: THandle);
    destructor Destroy; override;

    procedure StartWorker;
    procedure StopWorker;

    procedure SetFormHandle(AHandle: THandle);
    procedure SendHhiSMSMsg(ARecord: THhiSMSRecord);
  end;

implementation

uses ActiveX;

{ TpjhHhiSMSClass }

constructor TpjhHhiSMSClass.Create(AHandle: THandle);
begin
  FpjhOmniMsgQClass := TpjhOmniMsgQClass.Create(1000, AHandle);
  StartWorker;
end;

destructor TpjhHhiSMSClass.Destroy;
begin
  StopWorker;
  FpjhOmniMsgQClass.Free;
  inherited;
end;

procedure TpjhHhiSMSClass.SendHhiSMSMsg(ARecord: THhiSMSRecord);
var
  LOmniValue: TOmniValue;
begin
  LOmniValue := TOmniValue.FromRecord<THhiSMSRecord>(ARecord);
  if not FpjhOmniMsgQClass.SendMsgQueue.Enqueue(TOmniMessage.Create(Ord(cwSendMsg), LOmniValue)) then
    raise Exception.Create('Command queue is full!');
end;

procedure TpjhHhiSMSClass.SetFormHandle(AHandle: THandle);
begin
  FpjhOmniMsgQClass.FormHandle := AHandle;
end;

procedure TpjhHhiSMSClass.StartWorker;
begin
  if not Assigned(FThSender) then
  begin
    FThSender := TThreadSender4HhiSMS.Create(True, FpjhOmniMsgQClass.FSendMsgQueue);
  end;

  FThSender.Start;
end;

procedure TpjhHhiSMSClass.StopWorker;
begin
  if Assigned(FThSender) then
  begin
    TThreadSender4HhiSMS(FThSender).Stop;
    FThSender.WaitFor;
    FreeAndNil(FThSender);
  end;
end;

{ TThreadSender4HhiSMS }

constructor TThreadSender4HhiSMS.Create(CreateSuspended: Boolean;
  ASendMsgQueue: TOmniMessageQueue);
begin
  FSendMsgQueue := ASendMsgQueue;
  FStopEvent := TEvent.Create;

  inherited Create(CreateSuspended);
end;

destructor TThreadSender4HhiSMS.Destroy;
begin
  FreeAndNil(FStopEvent);

  inherited;
end;

procedure TThreadSender4HhiSMS.Execute;
var
  handles: array [0..1] of THandle;
  msg    : TOmniMessage;
  rec    : THhiSMSRecord;
begin
  CoInitialize(nil);
  try
    handles[0] := FStopEvent.Handle;
    handles[1] := FSendMsgQueue.GetNewMessageEvent;

    while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
    begin
      if Terminated then
        exit;

      while FSendMsgQueue.TryDequeue(msg) do
      begin
        rec := msg.MsgData.ToRecord<THhiSMSRecord>;
        Send_Message_Main_CODE(rec);
      end;
    end;
  finally
    CoUnInitialize;
  end;
end;

procedure TThreadSender4HhiSMS.Stop;
begin
  FStopEvent.SetEvent;
end;

end.

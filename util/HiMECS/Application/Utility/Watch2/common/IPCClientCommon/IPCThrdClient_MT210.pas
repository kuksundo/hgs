unit IPCThrdClient_MT210;
{
  IPCThrdClient Unit에서 다음이 추가됨
  1. 모니터링 이외의 사항 모두 삭제함(debug, client directory등)
  2. FState 관련 삭제
}

interface

uses Windows, SysUtils, IPCThrd_MT210;

Type
{ TIPCClient2 }

  TIPCClient_MT210 = class(TIPCThread_MT210)
  private
    FWaitEvent: TIPCEvent_MT210;
  protected
    procedure Execute; override;
  public
    procedure SignalMonitor(Data: TEventData_MT210);
    procedure PulseMonitor(Data: TEventData_MT210);
  end;

implementation

{ TIPCClient2 }

procedure TIPCClient_MT210.Execute;
begin
  DbgStr(FName + ' Activated');

  while not Terminated do
  try
    if WaitForSingleObject(FWaitEvent.Handle, INFINITE) <> WAIT_OBJECT_0 then Break;

    case FWaitEvent.Kind of
      evMonitorSignal: if Assigned(FOnSignal) then FOnSignal(Self, FWaitEvent.Data);
    end;
  except
    on E:Exception do
      DbgStr(Format('Exception raised in Thread Handler: %s at %X', [E.Message, ExceptAddr]));
  end;

  DbgStr('Thread Handler Exited');
end;

procedure TIPCClient_MT210.SignalMonitor(Data: TEventData_MT210);
begin
  DbgStr('Signaling Monitor');
  FMonitorEvent.SignalData(evClientSignal, FID, Data);
end;

procedure TIPCClient_MT210.PulseMonitor(Data: TEventData_MT210);
begin
  DbgStr('Pulse Monitor');
  FMonitorEvent.PulseData(evClientSignal, FID, Data);
end;

end.
 
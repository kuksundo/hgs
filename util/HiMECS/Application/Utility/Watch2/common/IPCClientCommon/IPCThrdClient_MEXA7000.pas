unit IPCThrdClient_MEXA7000;
{
  IPCThrdClient Unit에서 다음이 추가됨
  1. 모니터링 이외의 사항 모두 삭제함(debug, client directory등)
  2. FState 관련 삭제
}

interface

uses Windows, SysUtils, IPCThrd_MEXA7000;

Type
{ TIPCClient_MEXA7000 }

  TIPCClient_MEXA7000 = class(TIPCThread_MEXA7000)
  private
    FWaitEvent: TIPCEvent_MEXA7000;
  protected
    procedure Execute; override;
  public
    procedure SignalMonitor(Data: TEventData_MEXA7000);
    procedure PulseMonitor(Data: TEventData_MEXA7000);
  end;

implementation

{ TIPCClient_MEXA7000 }

procedure TIPCClient_MEXA7000.Execute;
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

procedure TIPCClient_MEXA7000.SignalMonitor(Data: TEventData_MEXA7000);
begin
  DbgStr('Signaling Monitor');
  FMonitorEvent.SignalData(evClientSignal, FID, Data);
end;

procedure TIPCClient_MEXA7000.PulseMonitor(Data: TEventData_MEXA7000);
begin
  DbgStr('Pulse Monitor');
  FMonitorEvent.PulseData(evClientSignal, FID, Data);
end;

end.
 
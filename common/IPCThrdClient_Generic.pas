unit IPCThrdClient_Generic;
{
  IPCThrdClient Unit에서 다음이 추가됨
  1. 모니터링 이외의 사항 모두 삭제함(debug, client directory등)
  2. FState 관련 삭제
}

interface

uses Windows, Classes, SysUtils, {$IFDEF USEGPSM}IPCThreadEvent2{$ELSE}IPCThreadEvent{$ENDIF};

Type
{ TIPCClient2 }

  TIPCClient<TEventData> = class(TThread)
  private
    FWaitEvent: TIPCEvent<TEventData>;
    FIPCObject: TIPCObject<TEventData>;
    FEventName: string;

    function GetSharedMemSize: cardinal;
    function GetEventName: string;
  protected
    procedure Execute; override;
  public
    constructor Create(const AName, AConstName: string; AMalual: Boolean = true);
    destructor Destroy; override;
    procedure PulseMonitor(Data: TEventData; ASMSize: cardinal = 0);
    procedure PulseMonitor4Stream(Data: Pointer; ASMSize: cardinal = 0);

    property SharedMemSize: cardinal read GetSharedMemSize;
    property EventName: string read GetEventName;
  end;

implementation

uses TypInfo;

{ TIPCClient2 }

constructor TIPCClient<TEventData>.Create(const AName, AConstName: string;
  AMalual: Boolean);
begin
  inherited Create(AMalual);

  FIPCObject := TIPCObject<TEventData>.Create(AName, AConstName);
  FWaitEvent := FIPCObject.FMonitorEvent;
  FEventName := AName + '_' + AConstName;
end;

destructor TIPCClient<TEventData>.Destroy;
begin
  Terminate;
  FreeAndNil(FIPCObject);
  inherited Destroy;
end;

procedure TIPCClient<TEventData>.Execute;
begin
  //DbgStr(FName + ' Activated');

  while not Terminated do
  try
    if WaitForSingleObject(FWaitEvent.Handle, INFINITE) <> WAIT_OBJECT_0 then Break;
      if Assigned(FIPCObject.OnSignal) then
        FIPCObject.OnSignal(FWaitEvent.FData^);
  except
    on E:Exception do
      ;//DbgStr(Format('Exception raised in Thread Handler: %s at %X', [E.Message, ExceptAddr]));
  end;

  //DbgStr('Thread Handler Exited');
end;

function TIPCClient<TEventData>.GetEventName: string;
begin
  Result := FEventName;
end;

function TIPCClient<TEventData>.GetSharedMemSize: cardinal;
begin
  Result := FWaitEvent.SharedMemSize;
  //Result := SizeOf(TEventData);
end;

procedure TIPCClient<TEventData>.PulseMonitor(Data: TEventData; ASMSize: cardinal);
begin
  //DbgStr('Pulse Monitor');
  {$IFDEF USEGPSM}
  {$ELSE}
  {$ENDIF}

  if ASMSize > 0 then
    FIPCObject.FMonitorEvent.SharedMemSize := ASMSize;

  FIPCObject.FMonitorEvent.PulseData(Data);
end;

procedure TIPCClient<TEventData>.PulseMonitor4Stream(Data: Pointer; ASMSize: cardinal);
//var
//  LF: TFileStream;
begin
//  LF := TFileStream.Create('c:\aaa.ppsx',fmCreate or fmOpenWrite);
//  try
//    LF.Write(Data, ASMSize);
////    LF.CopyFrom(Data, ASMSize);
//  finally
//    LF.Free;
//  end;

  if ASMSize > 0 then
    FIPCObject.FMonitorEvent.SharedMemSize := ASMSize;

//  FIPCObject.FMonitorEvent.PulseData4Stream(Data);
end;

end.

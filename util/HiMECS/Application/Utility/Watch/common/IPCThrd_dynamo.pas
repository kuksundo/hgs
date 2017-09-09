unit IPCThrd_dynamo;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_dynamo;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_DYNAMO = class;

{ TIPCEvent_DYNAMO }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_DYNAMO = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_DYNAMO = (cfError, cfModBusCom);
  TClientFlag_DYNAMOs = set of TClientFlag_DYNAMO;

  PEventData_DYNAMO = ^TEventData_DYNAMO;
  TEventData_DYNAMO = packed record
    FUnit: string[10]; //측정 단위
    FState: string[2];//에러 유무
    FData: double;//측정 데이타 갯수
 end;

  TIPCNotifyEvent_DYNAMO = procedure (Sender: TIPCThread_DYNAMO; Data: TEventData_DYNAMO) of Object;

  PIPCEventInfo_DYNAMO = ^TIPCEventInfo_DYNAMO;
  TIPCEventInfo_DYNAMO = record
    FID: Integer;
    FKind: TEventKind_DYNAMO;
    FData: TEventData_DYNAMO;
  end;

  TIPCEvent_DYNAMO = class(TEvent)
  private
    FOwner: TIPCThread_DYNAMO;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_DYNAMO;
    procedure SetKind(Value: TEventKind_DYNAMO);
    function GetData: TEventData_DYNAMO;
    procedure SetData(Value: TEventData_DYNAMO);
  public
    FEventInfo: PIPCEventInfo_DYNAMO;

    constructor Create(AOwner: TIPCThread_DYNAMO; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_DYNAMO);
    procedure SignalID(Kind: TEventKind_DYNAMO; ID: Integer);
    procedure SignalData(Kind: TEventKind_DYNAMO; ID: Integer; Data: TEventData_DYNAMO);
    procedure PulseData(Kind: TEventKind_DYNAMO; ID: Integer; Data: TEventData_DYNAMO);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_DYNAMO): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_DYNAMO read GetKind write SetKind;
    property Data: TEventData_DYNAMO read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_DYNAMO }

{ The TIPCThread_DYNAMO class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_DYNAMO = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_DYNAMO;
    FOnSignal: TIPCNotifyEvent_DYNAMO;
  public
    FMonitorEvent: TIPCEvent_DYNAMO;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_DYNAMO read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_DYNAMO }

constructor TIPCEvent_DYNAMO.Create(AOwner: TIPCThread_DYNAMO; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_DYNAMO));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_DYNAMO.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_DYNAMO.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_DYNAMO.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_DYNAMO.GetKind: TEventKind_DYNAMO;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_DYNAMO.SetKind(Value: TEventKind_DYNAMO);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_DYNAMO.GetData: TEventData_DYNAMO;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_DYNAMO.SetData(Value: TEventData_DYNAMO);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_DYNAMO.Signal(Kind: TEventKind_DYNAMO);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_DYNAMO.SignalID(Kind: TEventKind_DYNAMO; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_DYNAMO.SignalData(Kind: TEventKind_DYNAMO; ID: Integer; Data: TEventData_DYNAMO);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_DYNAMO.PulseData(Kind: TEventKind_DYNAMO; ID: Integer; Data: TEventData_DYNAMO);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_DYNAMO.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_DYNAMO): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_DYNAMO }

constructor TIPCThread_DYNAMO.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_DYNAMO.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_DYNAMO.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_DYNAMO(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_DYNAMO.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

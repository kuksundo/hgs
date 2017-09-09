unit IPCThrd_EngineParam;
{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_EngineParam;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }

const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_EngineParam = class;

{ TIPCEvent_EngineParam }

{ Win3_EngineParam events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_EngineParam = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_EngineParam = (cfError, cfModBusCom);
  TClientFlag_EngineParams = set of TClientFlag_EngineParam;

  PEventData_EngineParam = ^TEventData_EngineParam;
  TEventData_EngineParam = packed record
    FDataCount: integer;
    FData: array[0..255] of string[50];
  end;

  TIPCNotifyEvent_EngineParam = procedure (Sender: TIPCThread_EngineParam; Data: TEventData_EngineParam) of Object;

  PIPCEventInfo_EngineParam = ^TIPCEventInfo_EngineParam;
  TIPCEventInfo_EngineParam = record
    FID: Integer;
    FKind: TEventKind_EngineParam;
    FData: TEventData_EngineParam;
  end;

  TIPCEvent_EngineParam = class(TEvent)
  private
    FOwner: TIPCThread_EngineParam;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_EngineParam;
    procedure SetKind(Value: TEventKind_EngineParam);
    function GetData: TEventData_EngineParam;
    procedure SetData(Value: TEventData_EngineParam);
  public
    FEventInfo: PIPCEventInfo_EngineParam;

    constructor Create(AOwner: TIPCThread_EngineParam; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_EngineParam);
    procedure SignalID(Kind: TEventKind_EngineParam; ID: Integer);
    procedure SignalData(Kind: TEventKind_EngineParam; ID: Integer; Data: TEventData_EngineParam);
    procedure PulseData(Kind: TEventKind_EngineParam; ID: Integer; Data: TEventData_EngineParam);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_EngineParam): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_EngineParam read GetKind write SetKind;
    property Data: TEventData_EngineParam read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_EngineParam }

{ The TIPCThread_EngineParam class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_EngineParam = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_EngineParam;
    FOnSignal: TIPCNotifyEvent_EngineParam;
  public
    FMonitorEvent: TIPCEvent_EngineParam;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_EngineParam read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_EngineParam }

constructor TIPCEvent_EngineParam.Create(AOwner: TIPCThread_EngineParam; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_EngineParam));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_EngineParam.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_EngineParam.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_EngineParam.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_EngineParam.GetKind: TEventKind_EngineParam;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_EngineParam.SetKind(Value: TEventKind_EngineParam);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_EngineParam.GetData: TEventData_EngineParam;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_EngineParam.SetData(Value: TEventData_EngineParam);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_EngineParam.Signal(Kind: TEventKind_EngineParam);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_EngineParam.SignalID(Kind: TEventKind_EngineParam; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_EngineParam.SignalData(Kind: TEventKind_EngineParam; ID: Integer; Data: TEventData_EngineParam);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_EngineParam.PulseData(Kind: TEventKind_EngineParam; ID: Integer; Data: TEventData_EngineParam);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_EngineParam.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_EngineParam): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_EngineParam }

constructor TIPCThread_EngineParam.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_EngineParam.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_EngineParam.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_EngineParam(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_EngineParam.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

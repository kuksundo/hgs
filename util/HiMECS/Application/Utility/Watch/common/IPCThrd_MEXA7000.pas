unit IPCThrd_MEXA7000;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_MEXA7000;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_MEXA7000 = class;

{ TIPCEvent_MEXA7000 }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_MEXA7000 = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_MEXA7000 = (cfError, cfModBusCom);
  TClientFlag_MEXA7000s = set of TClientFlag_MEXA7000;

  PEventData_MEXA7000 = ^TEventData_MEXA7000;
  TEventData_MEXA7000 = packed record
    CO2: string[50];//String 변수는 공유메모리에 사용 불가함
    CO_L: string[50];
    O2: string[50];
    NOx: string[50];
    THC: string[50];
    CH4: string[50];
    non_CH4: string[50];
    CollectedValue: Double;
  end;

  TIPCNotifyEvent_MEXA7000 = procedure (Sender: TIPCThread_MEXA7000; Data: TEventData_MEXA7000) of Object;

  PIPCEventInfo_MEXA7000 = ^TIPCEventInfo_MEXA7000;
  TIPCEventInfo_MEXA7000 = record
    FID: Integer;
    FKind: TEventKind_MEXA7000;
    FData: TEventData_MEXA7000;
  end;

  TIPCEvent_MEXA7000 = class(TEvent)
  private
    FOwner: TIPCThread_MEXA7000;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_MEXA7000;
    procedure SetKind(Value: TEventKind_MEXA7000);
    function GetData: TEventData_MEXA7000;
    procedure SetData(Value: TEventData_MEXA7000);
  public
    FEventInfo: PIPCEventInfo_MEXA7000;

    constructor Create(AOwner: TIPCThread_MEXA7000; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_MEXA7000);
    procedure SignalID(Kind: TEventKind_MEXA7000; ID: Integer);
    procedure SignalData(Kind: TEventKind_MEXA7000; ID: Integer; Data: TEventData_MEXA7000);
    procedure PulseData(Kind: TEventKind_MEXA7000; ID: Integer; Data: TEventData_MEXA7000);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_MEXA7000): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_MEXA7000 read GetKind write SetKind;
    property Data: TEventData_MEXA7000 read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_MEXA7000 }

{ The TIPCThread_MEXA7000 class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_MEXA7000 = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_MEXA7000;
    FOnSignal: TIPCNotifyEvent_MEXA7000;
  public
    FMonitorEvent: TIPCEvent_MEXA7000;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_MEXA7000 read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_MEXA7000 }

constructor TIPCEvent_MEXA7000.Create(AOwner: TIPCThread_MEXA7000; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_MEXA7000));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_MEXA7000.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_MEXA7000.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_MEXA7000.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_MEXA7000.GetKind: TEventKind_MEXA7000;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_MEXA7000.SetKind(Value: TEventKind_MEXA7000);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_MEXA7000.GetData: TEventData_MEXA7000;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_MEXA7000.SetData(Value: TEventData_MEXA7000);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_MEXA7000.Signal(Kind: TEventKind_MEXA7000);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_MEXA7000.SignalID(Kind: TEventKind_MEXA7000; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_MEXA7000.SignalData(Kind: TEventKind_MEXA7000; ID: Integer; Data: TEventData_MEXA7000);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_MEXA7000.PulseData(Kind: TEventKind_MEXA7000; ID: Integer; Data: TEventData_MEXA7000);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_MEXA7000.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_MEXA7000): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_MEXA7000 }

constructor TIPCThread_MEXA7000.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_MEXA7000.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_MEXA7000.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_MEXA7000(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_MEXA7000.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

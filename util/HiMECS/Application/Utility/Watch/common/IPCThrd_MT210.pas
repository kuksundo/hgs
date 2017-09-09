unit IPCThrd_MT210;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_MT210;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_MT210 = class;

{ TIPCEvent_MEXA7000 }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_MT210 = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_MT210 = (cfError, cfModBusCom);
  TClientFlag_MT210s = set of TClientFlag_MT210;

  PEventData_MT210 = ^TEventData_MT210;
  TEventData_MT210 = packed record
    FUnit: string[10]; //측정 단위
    FState: string[2];//에러 유무
    FData: double;//측정 데이타 갯수
 end;

  TIPCNotifyEvent_MT210 = procedure (Sender: TIPCThread_MT210; Data: TEventData_MT210) of Object;

  PIPCEventInfo_MT210 = ^TIPCEventInfo_MT210;
  TIPCEventInfo_MT210 = record
    FID: Integer;
    FKind: TEventKind_MT210;
    FData: TEventData_MT210;
  end;

  TIPCEvent_MT210 = class(TEvent)
  private
    FOwner: TIPCThread_MT210;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_MT210;
    procedure SetKind(Value: TEventKind_MT210);
    function GetData: TEventData_MT210;
    procedure SetData(Value: TEventData_MT210);
  public
    FEventInfo: PIPCEventInfo_MT210;

    constructor Create(AOwner: TIPCThread_MT210; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_MT210);
    procedure SignalID(Kind: TEventKind_MT210; ID: Integer);
    procedure SignalData(Kind: TEventKind_MT210; ID: Integer; Data: TEventData_MT210);
    procedure PulseData(Kind: TEventKind_MT210; ID: Integer; Data: TEventData_MT210);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_MT210): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_MT210 read GetKind write SetKind;
    property Data: TEventData_MT210 read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_MT210 }

{ The TIPCThread_MT210 class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_MT210 = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_MT210;
    FOnSignal: TIPCNotifyEvent_MT210;
  public
    FMonitorEvent: TIPCEvent_MT210;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_MT210 read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_MT210 }

constructor TIPCEvent_MT210.Create(AOwner: TIPCThread_MT210; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_MT210));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_MT210.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_MT210.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_MT210.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_MT210.GetKind: TEventKind_MT210;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_MT210.SetKind(Value: TEventKind_MT210);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_MT210.GetData: TEventData_MT210;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_MT210.SetData(Value: TEventData_MT210);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_MT210.Signal(Kind: TEventKind_MT210);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_MT210.SignalID(Kind: TEventKind_MT210; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_MT210.SignalData(Kind: TEventKind_MT210; ID: Integer; Data: TEventData_MT210);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_MT210.PulseData(Kind: TEventKind_MT210; ID: Integer; Data: TEventData_MT210);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_MT210.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_MT210): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_MT210 }

constructor TIPCThread_MT210.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_MT210.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_MT210.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_MT210(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_MT210.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

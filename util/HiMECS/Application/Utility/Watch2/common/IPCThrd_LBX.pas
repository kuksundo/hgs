unit IPCThrd_LBX;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_LBX;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_LBX = class;

{ TIPCEvent_LBX }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_LBX = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_LBX = (cfError, cfModBusCom);
  TClientFlag_LBXs = set of TClientFlag_LBX;

  PEventData_LBX = ^TEventData_LBX;
  TEventData_LBX = packed record
    IPAddress: string[16];
    ENGRPM: integer;
    HTTEMP: integer;
    LOTEMP: integer;
    TCRPMA: integer;
    TCRPMB: integer;
    TCINLETTEMP: integer;
    LBXNo: integer;
  end;

  TIPCNotifyEvent_LBX = procedure (Sender: TIPCThread_LBX; Data: TEventData_LBX) of Object;

  PIPCEventInfo_LBX = ^TIPCEventInfo_LBX;
  TIPCEventInfo_LBX = record
    FID: Integer;
    FKind: TEventKind_LBX;
    FData: TEventData_LBX;
  end;

  TIPCEvent_LBX = class(TEvent)
  private
    FOwner: TIPCThread_LBX;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_LBX;
    procedure SetKind(Value: TEventKind_LBX);
    function GetData: TEventData_LBX;
    procedure SetData(Value: TEventData_LBX);
  public
    FEventInfo: PIPCEventInfo_LBX;

    constructor Create(AOwner: TIPCThread_LBX; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_LBX);
    procedure SignalID(Kind: TEventKind_LBX; ID: Integer);
    procedure SignalData(Kind: TEventKind_LBX; ID: Integer; Data: TEventData_LBX);
    procedure PulseData(Kind: TEventKind_LBX; ID: Integer; Data: TEventData_LBX);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_LBX): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_LBX read GetKind write SetKind;
    property Data: TEventData_LBX read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread2 }

{ The TIPCThread2 class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_LBX = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_LBX;
    FOnSignal: TIPCNotifyEvent_LBX;
  public
    FMonitorEvent: TIPCEvent_LBX;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_LBX read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent2 }

constructor TIPCEvent_LBX.Create(AOwner: TIPCThread_LBX; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_LBX));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_LBX.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_LBX.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_LBX.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_LBX.GetKind: TEventKind_LBX;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_LBX.SetKind(Value: TEventKind_LBX);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_LBX.GetData: TEventData_LBX;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_LBX.SetData(Value: TEventData_LBX);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_LBX.Signal(Kind: TEventKind_LBX);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_LBX.SignalID(Kind: TEventKind_LBX; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_LBX.SignalData(Kind: TEventKind_LBX; ID: Integer; Data: TEventData_LBX);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_LBX.PulseData(Kind: TEventKind_LBX; ID: Integer; Data: TEventData_LBX);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_LBX.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_LBX): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread2 }

constructor TIPCThread_LBX.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_LBX.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_LBX.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind2(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_LBX.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

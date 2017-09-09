unit IPCThrd_WT1600;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_WT1600;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_WT1600 = class;

{ TIPCEvent_WT1600 }

{ Win3_WT1600 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_WT1600 = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_WT1600 = (cfError, cfModBusCom);
  TClientFlag_WT1600s = set of TClientFlag_WT1600;

  PEventData_WT1600 = ^TEventData_WT1600;
  TEventData_WT1600 = packed record
    IPAddress: string[16];
    URMS1: string[50];
    URMS2: string[50];
    URMS3: string[50];
    IRMS1: string[50];
    IRMS2: string[50];
    IRMS3: string[50];
    PSIGMA: string[50];
    SSIGMA: string[50];
    QSIGMA: string[50];
    RAMDA: string[50];
    URMSAVG: string[50];
    IRMSAVG: string[50];
    FREQUENCY: string[50];
    F1: string[50];
    PowerMeterOn: Boolean;
    PowerMeterNo: integer;
  end;

  TIPCNotifyEvent_WT1600 = procedure (Sender: TIPCThread_WT1600; Data: TEventData_WT1600) of Object;

  PIPCEventInfo_WT1600 = ^TIPCEventInfo_WT1600;
  TIPCEventInfo_WT1600 = record
    FID: Integer;
    FKind: TEventKind_WT1600;
    FData: TEventData_WT1600;
  end;

  TIPCEvent_WT1600 = class(TEvent)
  private
    FOwner: TIPCThread_WT1600;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_WT1600;
    procedure SetKind(Value: TEventKind_WT1600);
    function GetData: TEventData_WT1600;
    procedure SetData(Value: TEventData_WT1600);
  public
    FEventInfo: PIPCEventInfo_WT1600;

    constructor Create(AOwner: TIPCThread_WT1600; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_WT1600);
    procedure SignalID(Kind: TEventKind_WT1600; ID: Integer);
    procedure SignalData(Kind: TEventKind_WT1600; ID: Integer; Data: TEventData_WT1600);
    procedure PulseData(Kind: TEventKind_WT1600; ID: Integer; Data: TEventData_WT1600);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_WT1600): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_WT1600 read GetKind write SetKind;
    property Data: TEventData_WT1600 read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_WT1600 }

{ The TIPCThread_WT1600 class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_WT1600 = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_WT1600;
    FOnSignal: TIPCNotifyEvent_WT1600;
  public
    FMonitorEvent: TIPCEvent_WT1600;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_WT1600 read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_WT1600 }

constructor TIPCEvent_WT1600.Create(AOwner: TIPCThread_WT1600; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_WT1600));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_WT1600.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_WT1600.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_WT1600.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_WT1600.GetKind: TEventKind_WT1600;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_WT1600.SetKind(Value: TEventKind_WT1600);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_WT1600.GetData: TEventData_WT1600;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_WT1600.SetData(Value: TEventData_WT1600);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_WT1600.Signal(Kind: TEventKind_WT1600);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_WT1600.SignalID(Kind: TEventKind_WT1600; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_WT1600.SignalData(Kind: TEventKind_WT1600; ID: Integer; Data: TEventData_WT1600);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_WT1600.PulseData(Kind: TEventKind_WT1600; ID: Integer; Data: TEventData_WT1600);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_WT1600.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_WT1600): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_WT1600 }

constructor TIPCThread_WT1600.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_WT1600.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_WT1600.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_WT1600(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_WT1600.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

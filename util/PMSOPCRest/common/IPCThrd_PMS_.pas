unit IPCThrd_PMS;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_PMS, IPC_PMS_Const;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_PMS = class;

{ TIPCEvent_PMS }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_PMS = (cfError, cfModBusCom);
  TClientFlag_PMSs = set of TClientFlag_PMS;

//  PEventData_PMS = ^TEventData_PMS;
//  TEventData_PMS = packed record
//    InpDataBuf: array[0..600] of string[20];
//  end;

  TIPCNotifyEvent_PMS = procedure (Sender: TIPCThread_PMS; Data: TEventData_PMS) of Object;

  TIPCEvent_PMS = class(TEvent)
  private
    FOwner: TIPCThread_PMS;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_PMS;
    procedure SetKind(Value: TEventKind_PMS);
    function GetData: TEventData_PMS;
    procedure SetData(Value: TEventData_PMS);
  public
    FEventInfo: PIPCEventInfo_PMS;

    constructor Create(AOwner: TIPCThread_PMS; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_PMS);
    procedure SignalID(Kind: TEventKind_PMS; ID: Integer);
    procedure SignalData(Kind: TEventKind_PMS; ID: Integer; Data: TEventData_PMS);
    procedure PulseData(Kind: TEventKind_PMS; ID: Integer; Data: TEventData_PMS);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_PMS): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_PMS read GetKind write SetKind;
    property Data: TEventData_PMS read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_PMS }

{ The TIPCThread_PMS class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_PMS = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_PMS;
    FOnSignal: TIPCNotifyEvent_PMS;
  public
    FMonitorEvent: TIPCEvent_PMS;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_PMS read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_PMS }

constructor TIPCEvent_PMS.Create(AOwner: TIPCThread_PMS; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_PMS));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_PMS.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_PMS.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_PMS.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_PMS.GetKind: TEventKind_PMS;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_PMS.SetKind(Value: TEventKind_PMS);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_PMS.GetData: TEventData_PMS;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_PMS.SetData(Value: TEventData_PMS);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_PMS.Signal(Kind: TEventKind_PMS);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_PMS.SignalID(Kind: TEventKind_PMS; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_PMS.SignalData(Kind: TEventKind_PMS; ID: Integer; Data: TEventData_PMS);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_PMS.PulseData(Kind: TEventKind_PMS; ID: Integer; Data: TEventData_PMS);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_PMS.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_PMS): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_PMS }

constructor TIPCThread_PMS.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_PMS.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_PMS.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_PMS(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_PMS.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

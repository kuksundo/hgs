unit IPCThrd_ECS;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_ECS;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_ECS = class;

{ TIPCEvent_ECS }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_ECS = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_ECS = (cfError, cfModBusCom);
  TClientFlag_ECSs = set of TClientFlag_ECS;

  PEventData_ECS = ^TEventData_ECS;
  TEventData_ECS = packed record
    InpDataBuf: array[0..255] of integer;
    InpDataBuf2: array[0..255] of Byte;
    NumOfData: integer;//데이타 갯수 반납
    NumOfBit: integer;//Bit 갯수 반납(01 function 일 경우 Bit 단위로 전달되기 때문임)
    //Block Mode 일경우 Modbus Block Start Address,
    //Individual Mode일경우 Modbus Address
    ModBusFunctionCode: integer;
    ModBusAddress: string[5];//String 변수는 공유메모리에 사용 불가함
    //ModBusAddress: array[0..19] of char;//String 변수는 공유메모리에 사용 불가함
    //ASCII Mode = 0, RTU Mode = 1;
    ModBusMode: integer;
  end;

  TIPCNotifyEvent_ECS = procedure (Sender: TIPCThread_ECS; Data: TEventData_ECS) of Object;

  PIPCEventInfo_ECS = ^TIPCEventInfo_ECS;
  TIPCEventInfo_ECS = record
    FID: Integer;
    FKind: TEventKind_ECS;
    FData: TEventData_ECS;
  end;

  TIPCEvent_ECS = class(TEvent)
  private
    FOwner: TIPCThread_ECS;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_ECS;
    procedure SetKind(Value: TEventKind_ECS);
    function GetData: TEventData_ECS;
    procedure SetData(Value: TEventData_ECS);
  public
    FEventInfo: PIPCEventInfo_ECS;

    constructor Create(AOwner: TIPCThread_ECS; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_ECS);
    procedure SignalID(Kind: TEventKind_ECS; ID: Integer);
    procedure SignalData(Kind: TEventKind_ECS; ID: Integer; Data: TEventData_ECS);
    procedure PulseData(Kind: TEventKind_ECS; ID: Integer; Data: TEventData_ECS);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_ECS): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_ECS read GetKind write SetKind;
    property Data: TEventData_ECS read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_ECS }

{ The TIPCThread_ECS class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_ECS = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_ECS;
    FOnSignal: TIPCNotifyEvent_ECS;
  public
    FMonitorEvent: TIPCEvent_ECS;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_ECS read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_ECS }

constructor TIPCEvent_ECS.Create(AOwner: TIPCThread_ECS; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_ECS));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_ECS.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_ECS.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_ECS.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_ECS.GetKind: TEventKind_ECS;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_ECS.SetKind(Value: TEventKind_ECS);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_ECS.GetData: TEventData_ECS;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_ECS.SetData(Value: TEventData_ECS);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_ECS.Signal(Kind: TEventKind_ECS);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_ECS.SignalID(Kind: TEventKind_ECS; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_ECS.SignalData(Kind: TEventKind_ECS; ID: Integer; Data: TEventData_ECS);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_ECS.PulseData(Kind: TEventKind_ECS; ID: Integer; Data: TEventData_ECS);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_ECS.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_ECS): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_ECS }

constructor TIPCThread_ECS.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_ECS.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_ECS.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_ECS(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_ECS.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

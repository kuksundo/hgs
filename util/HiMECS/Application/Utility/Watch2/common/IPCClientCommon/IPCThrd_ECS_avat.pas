unit IPCThrd_ECS_avat;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_ECS_avat;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_ECS_avat = class;

{ TIPCEvent_ECS_avat }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_ECS_avat = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_ECS_avat = (cfError, cfModBusCom);
  TClientFlag_ECS_avats = set of TClientFlag_ECS_avat;

  PEventData_ECS_avat = ^TEventData_ECS_avat;
  TEventData_ECS_avat = packed record
    InpDataBuf: array[0..255] of integer;
    InpDataBuf2: array[0..255] of Byte;
    InpDataBuf_double: array[0..255] of double;
    NumOfData: integer;//데이타 갯수 반납
    NumOfBit: integer;//Bit 갯수 반납(01 function 일 경우 Bit 단위로 전달되기 때문임)
    //Block Mode 일경우 Modbus Block Start Address,
    //Individual Mode일경우 Modbus Address
    ModBusFunctionCode: integer;
    ModBusAddress: string[5];//String 변수는 공유메모리에 사용 불가함
    //ModBusAddress: array[0..19] of char;//String 변수는 공유메모리에 사용 불가함
    //ASCII Mode = 0, RTU Mode = 1, RTU mode simulation = 3;
    ModBusMode: integer;
    BlockNo: integer;
  end;

  TIPCNotifyEvent_ECS_avat = procedure (Sender: TIPCThread_ECS_avat; Data: TEventData_ECS_avat) of Object;

  PIPCEventInfo_ECS_avat = ^TIPCEventInfo_ECS_avat;
  TIPCEventInfo_ECS_avat = record
    FID: Integer;
    FKind: TEventKind_ECS_avat;
    FData: TEventData_ECS_avat;
  end;

  TIPCEvent_ECS_avat = class(TEvent)
  private
    FOwner: TIPCThread_ECS_avat;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_ECS_avat;
    procedure SetKind(Value: TEventKind_ECS_avat);
    function GetData: TEventData_ECS_avat;
    procedure SetData(Value: TEventData_ECS_avat);
  public
    FEventInfo: PIPCEventInfo_ECS_avat;

    constructor Create(AOwner: TIPCThread_ECS_avat; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_ECS_avat);
    procedure SignalID(Kind: TEventKind_ECS_avat; ID: Integer);
    procedure SignalData(Kind: TEventKind_ECS_avat; ID: Integer; Data: TEventData_ECS_avat);
    procedure PulseData(Kind: TEventKind_ECS_avat; ID: Integer; Data: TEventData_ECS_avat);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_ECS_avat): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_ECS_avat read GetKind write SetKind;
    property Data: TEventData_ECS_avat read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_ECS_avat }

{ The TIPCThread_ECS_avat class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_ECS_avat = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_ECS_avat;
    FOnSignal: TIPCNotifyEvent_ECS_avat;
  public
    FMonitorEvent: TIPCEvent_ECS_avat;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_ECS_avat read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_ECS_avat }

constructor TIPCEvent_ECS_avat.Create(AOwner: TIPCThread_ECS_avat; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_ECS_avat));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_ECS_avat.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_ECS_avat.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_ECS_avat.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_ECS_avat.GetKind: TEventKind_ECS_avat;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_ECS_avat.SetKind(Value: TEventKind_ECS_avat);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_ECS_avat.GetData: TEventData_ECS_avat;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_ECS_avat.SetData(Value: TEventData_ECS_avat);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_ECS_avat.Signal(Kind: TEventKind_ECS_avat);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_ECS_avat.SignalID(Kind: TEventKind_ECS_avat; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_ECS_avat.SignalData(Kind: TEventKind_ECS_avat; ID: Integer; Data: TEventData_ECS_avat);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_ECS_avat.PulseData(Kind: TEventKind_ECS_avat; ID: Integer; Data: TEventData_ECS_avat);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_ECS_avat.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_ECS_avat): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_ECS_avat }

constructor TIPCThread_ECS_avat.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_ECS_avat.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_ECS_avat.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_ECS_avat(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_ECS_avat.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

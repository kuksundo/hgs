unit IPCThrd_FlowMeter;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_FlowMeter;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_FlowMeter = class;

{ TIPCEvent2 }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind2 = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag2 = (cfError, cfModBusCom);
  TClientFlag2s = set of TClientFlag2;

  PEventData_FlowMeter = ^TEventData_FlowMeter;
  TEventData_FlowMeter = packed record
    InpDataBuf: array[0..255] of integer;
    InpDataBuf2: array[0..255] of Byte;
    NumOfData: integer;//데이타 갯수 반납
    NumOfBit: integer;//Bit 갯수 반납(01 function 일 경우 Bit 단위로 전달되기 때문임)
    //Block Mode 일경우 Modbus Block Start Address,
    //Individual Mode일경우 Modbus Address
    ModBusFunctionCode: integer;
    ModBusAddress: array[0..19] of char;//String 변수는 공유메모리에 사용 불가함
    //ASCII Mode = 0, RTU Mode = 1;
    ModBusMode: integer;
    Flag: TClientFlag2;
    Flags: TClientFlag2s;
  end;

  TIPCNotifyEvent2 = procedure (Sender: TIPCThread_FlowMeter; Data: TEventData_FlowMeter) of Object;

  PIPCEventInfo2 = ^TIPCEventInfo2;
  TIPCEventInfo2 = record
    FID: Integer;
    FKind: TEventKind2;
    FData: TEventData_FlowMeter;
  end;

  TIPCEvent_FlowMeter = class(TEvent)
  private
    FOwner: TIPCThread_FlowMeter;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind2;
    procedure SetKind(Value: TEventKind2);
    function GetData: TEventData_FlowMeter;
    procedure SetData(Value: TEventData_FlowMeter);
  public
    FEventInfo: PIPCEventInfo2;

    constructor Create(AOwner: TIPCThread_FlowMeter; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind2);
    procedure SignalID(Kind: TEventKind2; ID: Integer);
    procedure SignalData(Kind: TEventKind2; ID: Integer; Data: TEventData_FlowMeter);
    procedure PulseData(Kind: TEventKind2; ID: Integer; Data: TEventData_FlowMeter);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind2): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind2 read GetKind write SetKind;
    property Data: TEventData_FlowMeter read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_FlowMeter }

{ The TIPCThread_FlowMeter class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_FlowMeter = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_FlowMeter;
    FOnSignal: TIPCNotifyEvent2;
  public
    FMonitorEvent: TIPCEvent_FlowMeter;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent2 read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_FlowMeter }

constructor TIPCEvent_FlowMeter.Create(AOwner: TIPCThread_FlowMeter; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo2));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_FlowMeter.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_FlowMeter.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_FlowMeter.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_FlowMeter.GetKind: TEventKind2;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_FlowMeter.SetKind(Value: TEventKind2);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_FlowMeter.GetData: TEventData_FlowMeter;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_FlowMeter.SetData(Value: TEventData_FlowMeter);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_FlowMeter.Signal(Kind: TEventKind2);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_FlowMeter.SignalID(Kind: TEventKind2; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_FlowMeter.SignalData(Kind: TEventKind2; ID: Integer; Data: TEventData_FlowMeter);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_FlowMeter.PulseData(Kind: TEventKind2; ID: Integer; Data: TEventData_FlowMeter);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_FlowMeter.WaitFor(TimeOut, ID: Integer; Kind: TEventKind2): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_FlowMeter }

constructor TIPCThread_FlowMeter.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_FlowMeter.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_FlowMeter.Destroy;
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

procedure TIPCThread_FlowMeter.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

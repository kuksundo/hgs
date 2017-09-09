unit IPCThrd_PLC_S7;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_PLC_S7;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_PLC_S7 = class;

{ TIPCEvent_PLC_S7 }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_PLC_S7 = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // 다른 프로젝트에 적용시 이 부분을 수정해야 함. (change)
  // 반드시 해당 디렉토리에 복사하여 사용할 것.
  TClientFlag_PLC_S7 = (cfError, cfModBusCom);
  TClientFlag_PLC_S7s = set of TClientFlag_PLC_S7;

  PEventData_PLC_S7 = ^TEventData_PLC_S7;
  TEventData_PLC_S7 = packed record
    DataByte: array[0..255] of byte;
    DataWord: array[0..255] of word;
    DataInt: array[0..255] of smallint;
    DataDWord: array[0..255] of cardinal;
    DataDInt: array[0..255] of integer;
    DataFloat: array[0..255] of extended;
    DataType: integer; //S7 Data Type
    NumOfData: integer;//데이타 갯수 반납
    NumOfBit: integer;//Bit 갯수 반납(01 function 일 경우 Bit 단위로 전달되기 때문임)
    BlockNo: integer;
    ModBusMapFileName: string[255];
  end;

  TIPCNotifyEvent_PLC_S7 = procedure (Sender: TIPCThread_PLC_S7; Data: TEventData_PLC_S7) of Object;

  PIPCEventInfo_PLC_S7 = ^TIPCEventInfo_PLC_S7;
  TIPCEventInfo_PLC_S7 = record
    FID: Integer;
    FKind: TEventKind_PLC_S7;
    FData: TEventData_PLC_S7;
  end;

  TIPCEvent_PLC_S7 = class(TEvent)
  private
    FOwner: TIPCThread_PLC_S7;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_PLC_S7;
    procedure SetKind(Value: TEventKind_PLC_S7);
    function GetData: TEventData_PLC_S7;
    procedure SetData(Value: TEventData_PLC_S7);
  public
    FEventInfo: PIPCEventInfo_PLC_S7;

    constructor Create(AOwner: TIPCThread_PLC_S7; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_PLC_S7);
    procedure SignalID(Kind: TEventKind_PLC_S7; ID: Integer);
    procedure SignalData(Kind: TEventKind_PLC_S7; ID: Integer; Data: TEventData_PLC_S7);
    procedure PulseData(Kind: TEventKind_PLC_S7; ID: Integer; Data: TEventData_PLC_S7);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_PLC_S7): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_PLC_S7 read GetKind write SetKind;
    property Data: TEventData_PLC_S7 read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_PLC_S7 }

{ The TIPCThread_PLC_S7 class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_PLC_S7 = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_PLC_S7;
    FOnSignal: TIPCNotifyEvent_PLC_S7;
  public
    FMonitorEvent: TIPCEvent_PLC_S7;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_PLC_S7 read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_PLC_S7 }

constructor TIPCEvent_PLC_S7.Create(AOwner: TIPCThread_PLC_S7; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_PLC_S7));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_PLC_S7.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_PLC_S7.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_PLC_S7.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_PLC_S7.GetKind: TEventKind_PLC_S7;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_PLC_S7.SetKind(Value: TEventKind_PLC_S7);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_PLC_S7.GetData: TEventData_PLC_S7;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_PLC_S7.SetData(Value: TEventData_PLC_S7);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_PLC_S7.Signal(Kind: TEventKind_PLC_S7);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_PLC_S7.SignalID(Kind: TEventKind_PLC_S7; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_PLC_S7.SignalData(Kind: TEventKind_PLC_S7; ID: Integer; Data: TEventData_PLC_S7);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_PLC_S7.PulseData(Kind: TEventKind_PLC_S7; ID: Integer; Data: TEventData_PLC_S7);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_PLC_S7.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_PLC_S7): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_PLC_S7 }

constructor TIPCThread_PLC_S7.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_PLC_S7.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_PLC_S7.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_PLC_S7(0));
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_PLC_S7.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

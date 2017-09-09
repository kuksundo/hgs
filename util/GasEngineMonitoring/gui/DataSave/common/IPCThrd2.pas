unit IPCThrd2;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread2 = class;

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

  PEventData2 = ^TEventData2;
  TEventData2 = packed record
    FSVP: double;// Saturation Vapour Press.(kPa)
    FIAH2: double;// Intake Air Humidity(g/kg)
    FUFC: double;// Uncorrected Fuel Consumption(g/kwh)
    FNhtCF: double;  //Nox humidity/temp. Correction Factor
    FDWCFE: double;//Dry/Wet Correction Factor Exhaust:
    FEGF: double; //Exhaust Gas Flow(kg/h)
    FNOxAtO213: double;//NOx at 13% O2
    FAF1: double; //Air Flow (kg/h)
    FAF2: double; //Air Flow (kg/kwh)
    FAF3: double; //Air Flow (kg/s)
    FFC: double;//Fuel Consumption(kg/h)
    FEngineOutput: Double; //Calculated Engine Output(kW/h)
    FEngineLoad: double; //Current Engine Load(%)
    FGenEfficiency: double; //Generator Efficiency at current Load(%/100)
    FBHP: double; //Brake Horse Power
    FBMEP: double;//Brake Mean Effective Press.
    FLamda: double; //Lamda Ratio
    FLamda_Brettschneider: double; //Lamda(Brettschneider equation) - Normalized Air/Fuel balance
    FAFRatio: double;//Air Fuel Ratio
  end;

  TIPCNotifyEvent2 = procedure (Sender: TIPCThread2; Data: TEventData2) of Object;

  PIPCEventInfo2 = ^TIPCEventInfo2;
  TIPCEventInfo2 = record
    FID: Integer;
    FKind: TEventKind2;
    FData: TEventData2;
  end;

  TIPCEvent2 = class(TEvent)
  private
    FOwner: TIPCThread2;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind2;
    procedure SetKind(Value: TEventKind2);
    function GetData: TEventData2;
    procedure SetData(Value: TEventData2);
  public
    FEventInfo: PIPCEventInfo2;

    constructor Create(AOwner: TIPCThread2; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind2);
    procedure SignalID(Kind: TEventKind2; ID: Integer);
    procedure SignalData(Kind: TEventKind2; ID: Integer; Data: TEventData2);
    procedure PulseData(Kind: TEventKind2; ID: Integer; Data: TEventData2);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind2): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind2 read GetKind write SetKind;
    property Data: TEventData2 read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread2 }

{ The TIPCThread2 class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread2 = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent2;
    FOnSignal: TIPCNotifyEvent2;
  public
    FMonitorEvent: TIPCEvent2;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent2 read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent2 }

constructor TIPCEvent2.Create(AOwner: TIPCThread2; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo2));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent2.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent2.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent2.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent2.GetKind: TEventKind2;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent2.SetKind(Value: TEventKind2);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent2.GetData: TEventData2;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent2.SetData(Value: TEventData2);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent2.Signal(Kind: TEventKind2);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent2.SignalID(Kind: TEventKind2; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent2.SignalData(Kind: TEventKind2; ID: Integer; Data: TEventData2);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent2.PulseData(Kind: TEventKind2; ID: Integer; Data: TEventData2);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent2.WaitFor(TimeOut, ID: Integer; Kind: TEventKind2): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread2 }

constructor TIPCThread2.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent2.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread2.Destroy;
begin
  Terminate;
  FMonitorEvent.Signal(TEventKind2(0));

  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread2.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

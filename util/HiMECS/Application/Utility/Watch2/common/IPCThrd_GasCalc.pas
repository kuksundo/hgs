unit IPCThrd_GasCalc;

{
  IPCThrd Unit에서 다음이 추가됨
  1. IPCThread 에서 Create의 기능수정(Shared Memeory 생성시 이름을 매개변수로 할당함)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_GasCalc;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_GasCalc = class;

{ TIPCEvent_GasCalc }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent_GasCalc class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_GasCalc = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  PEventData_GasCalc = ^TEventData_GasCalc;
  TEventData_GasCalc = packed record
    FSVP: double;// Saturation Vapour Press.(kPa)
    FIAH2: double;// Intake Air Humidity(g/kg)
    FUFC: double;// Uncorrected Fuel Consumption(g/kwh)
    FNhtCF: double;  //Nox humidity/temp. Correction Factor
    FDWCFE: double;//Dry/Wet Correction Factor Exhaust:
    FEGF: double; //Exhaust Gas Flow(kg/h)
    FNOxAtO213: double;//NOx at 13% O2
    FNOx: double;//NOx(ppm)
    FAF1: double; //Air Flow (kg/h)
    FAF2: double; //Air Flow (kg/kwh)
    FAF3: double; //Air Flow (kg/s)
    FAF_Measured: double; //Measured Air Flow (kg/h):MT210
    FMT210: double; //Measured Diff. Press(mmH2O=mmAq=mm):MT210
    FFC: double;//Fuel Consumption(kg/h)
    FEngineOutput: Double; //Calculated(kW/h)
    FGeneratorOutput: Double; //Calculated(kW/h)
    FEngineLoad: double; //Current Engine Load(%)
    FGenEfficiency: double; //Generator Efficiency at current Load(%/100)
    FBHP: double; //Brake Horse Power
    FBMEP: double;//Brake Mean Effective Press.
    FLamda_Calculated: double; //Lamda Ratio by MEXA7000
    FLamda_Measured: double; //Lamda Ratio by MT210
    FLamda_Brettschneider: double; //Lamda(Brettschneider equation) - Normalized Air/Fuel balance
    FAFRatio_Calculated: double;//Air Fuel Ratio calculated by MEXA7000
    FAFRatio_Measured: double;//Air Fuel Ratio Measured by MT210
    FExhTempAvg: double;//Average of Exh. Temp.
    FWasteGatePosition: double;//Waste Gate Position
    FThrottlePosition: double;//Throttle Valve Position
    FBoostPress: double;//Boost Pressure
    FDensity: double;//Density (kg/m3)
    FLCV: double;//Low Caloric Value (kJ/kg)
  end;

  TIPCNotifyEvent_GasCalc = procedure (Sender: TIPCThread_GasCalc; Data: TEventData_GasCalc) of Object;

  PIPCEventInfo_GasCalc = ^TIPCEventInfo_GasCalc;
  TIPCEventInfo_GasCalc = record
    FID: Integer;
    FKind: TEventKind_GasCalc;
    FData: TEventData_GasCalc;
  end;

  TIPCEvent_GasCalc = class(TEvent)
  private
    FOwner: TIPCThread_GasCalc;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_GasCalc;
    procedure SetKind(Value: TEventKind_GasCalc);
    function GetData: TEventData_GasCalc;
    procedure SetData(Value: TEventData_GasCalc);
  public
    FEventInfo: PIPCEventInfo_GasCalc;

    constructor Create(AOwner: TIPCThread_GasCalc; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_GasCalc);
    procedure SignalID(Kind: TEventKind_GasCalc; ID: Integer);
    procedure SignalData(Kind: TEventKind_GasCalc; ID: Integer; Data: TEventData_GasCalc);
    procedure PulseData(Kind: TEventKind_GasCalc; ID: Integer; Data: TEventData_GasCalc);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_GasCalc): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_GasCalc read GetKind write SetKind;
    property Data: TEventData_GasCalc read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_GasCalc }

{ The TIPCThread_GasCalc class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_GasCalc = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_GasCalc;
    FOnSignal: TIPCNotifyEvent_GasCalc;
  public
    FMonitorEvent: TIPCEvent_GasCalc;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_GasCalc read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_GasCalc }

constructor TIPCEvent_GasCalc.Create(AOwner: TIPCThread_GasCalc; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_GasCalc));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_GasCalc.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_GasCalc.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_GasCalc.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_GasCalc.GetKind: TEventKind_GasCalc;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_GasCalc.SetKind(Value: TEventKind_GasCalc);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_GasCalc.GetData: TEventData_GasCalc;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_GasCalc.SetData(Value: TEventData_GasCalc);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_GasCalc.Signal(Kind: TEventKind_GasCalc);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_GasCalc.SignalID(Kind: TEventKind_GasCalc; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_GasCalc.SignalData(Kind: TEventKind_GasCalc; ID: Integer; Data: TEventData_GasCalc);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_GasCalc.PulseData(Kind: TEventKind_GasCalc; ID: Integer; Data: TEventData_GasCalc);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_GasCalc.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_GasCalc): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_GasCalc }

constructor TIPCThread_GasCalc.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_GasCalc.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_GasCalc.Destroy;
begin
  Terminate;
  FMonitorEvent.Signal(TEventKind_GasCalc(0));

  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_GasCalc.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

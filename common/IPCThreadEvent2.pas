unit IPCThreadEvent2;
{
  //2016.12.6
  1. MyKernelObject unit 삭제
  2. MyKernelObject4GpSharedMem 추가
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject4GpSharedMem;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }

type
  TIPCObject<TEventData> = class;

{ TIPCEvent }

  TIPCNotifyEvent<TEventData> = procedure (Data: TEventData ) of Object;

  TEventKind = (
    evMonitor4Stream   // Notify Monitor that using stream
  );
  //PIPCEventInfo = ^TIPCEventInfo<TEventData>;
  TIPCEventInfo<TEventData> = packed record
    FID: Integer;
    FKind: TEventKind;
    FData: ^TEventData;
  end;

  TIPCEvent<TEventData> = class(TEvent)
  private
    FSharedMemSize: Integer;

    function GetData: TEventData ;
    procedure SetData(Value: TEventData);
    function GetSharedMemSize: integer;
    function GetSahredMemName: string;
  public
    FSharedMem: TSharedMem;
    FData: ^TEventData;

    constructor Create(const AName: string);
    destructor Destroy; override;
    procedure PulseData(Data: TEventData);
    procedure PulseData4Stream(Data: Pointer);

    //property Data: TEventData  read GetData write SetData;
    property SharedMemSize: Integer read GetSharedMemSize;
    property SharedMemName: string read GetSahredMemName;
  end;

{ TIPCThread  }

  TIPCObject<TEventData> = class(TObject)
  protected
    FName: string;
    //FClientEvent: TIPCEvent<TEventData>;
    FOnSignal: TIPCNotifyEvent<TEventData>;
  public
    FMonitorEvent: TIPCEvent<TEventData>;

    constructor Create(const AName, AConstName: string);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent<TEventData> read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo{$IFDEF USEGPSM}, GpSharedMemory {$ENDIF};

{ TIPCEvent }

constructor TIPCEvent<TEventData>.Create(const AName: string);
begin
  //FSharedMem := TSharedMem.Create(Format('%s.Data', [AName]), ASharedMMSize);
  inherited Create(AName, True);

  FSharedMem := TSharedMem.Create(Format('%s.Data', [AName]), SizeOf(TEventData));
//  {$IFNDEF USEGPSM}
  FData := FSharedMem.Buffer;// GetEventDataFromPointer;
//  {$ENDIF}
end;

destructor TIPCEvent<TEventData>.Destroy;
begin
//  FSharedMem.Free;
  inherited;
end;

function TIPCEvent<TEventData>.GetData: TEventData;
begin
//  {$IFNDEF USEGPSM}
  Result := FData^;
//  {$ELSE}
//  Result := FSharedMem.FGpSM.AsString;
//  {$ENDIF}
end;

function TIPCEvent<TEventData>.GetSahredMemName: string;
begin
  Result := FSharedMem.Name;
end;

function TIPCEvent<TEventData>.GetSharedMemSize: integer;
begin
  Result := FSharedMem.Size;
end;

procedure TIPCEvent<TEventData>.SetData(Value: TEventData);
begin
//  {$IFNDEF USEGPSM}
  FData^ := Value;
//  {$ELSE}
//  FSharedMem.FGpSM.AsString := Value;
//  {$ENDIF}
end;

procedure TIPCEvent<TEventData>.PulseData(Data: TEventData);
begin
  {$IFDEF USEGPSM}
  {$ELSE}
  FData^ := Data;
  inherited Pulse;
  {$ENDIF}
//  FSharedMem.FGpSM.AsString := Data;
end;

procedure TIPCEvent<TEventData>.PulseData4Stream(Data: Pointer);
var
  LStream: TGpSharedStream;
//  LF: TFileStream;
begin
  {$IFDEF USEGPSM}
  TGpSharedMemory(FSharedMem.Buffer).AcquireMemory(True,10000);
//  LF := TFileStream.Create('c:\bbb.ppsx',fmCreate or fmOpenWrite);
  try
//    LF.Write(Data, FSharedMem.Size);
    LStream := TGpSharedMemory(FSharedMem.Buffer).AsStream;
    LStream.SetSize(FSharedMem.Size);
//    LStream.Position := 0;
    LStream.Write(Data, FSharedMem.Size);
  finally
//    LF.Free;
    TGpSharedMemory(FSharedMem.Buffer).ReleaseMemory;
    inherited Pulse;
  end;
  {$ELSE}
  FData^ := Data;
  inherited Pulse;
  {$ENDIF}
end;

{ TIPCObject  }

constructor TIPCObject<TEventData>.Create(const AName, AConstName: string);
begin
  FName := AName;
  FMonitorEvent := TIPCEvent<TEventData>.Create(AName+'_'+AConstName);
  //FMonitorEvent := TIPCEvent<TEventData>.Create(AName+'_', ASharedMMSize);
end;

destructor TIPCObject<TEventData>.Destroy;
begin
  //Client 종료시 Monitor에서 FMonitorEvent 가 계속 Signaled 상태로 남아있어서
  //CPU 점유율이 상승하는 문제 해결 위해 아래 코드로 대체함
  FMonitorEvent.Pulse;
  FMonitorEvent.Free;
//  inherited Destroy;
end;

procedure TIPCObject<TEventData>.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.

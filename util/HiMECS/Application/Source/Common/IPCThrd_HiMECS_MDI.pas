unit IPCThrd_HiMECS_MDI;

{ Inter-Process Communication Thread Classes }

interface

uses
  SysUtils, Classes, Windows, MyKernelObject;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

const
  MAX_CLIENTS        = 50;
  TIMEOUT            = 2000;
  MONITOR_EVENT_NAME = 'MONITOR_EVENT_HiMECS_MDI';
  CLIENT_EVENT_NAME  = 'CLIENT_EVENT_HiMECS_MDI';
  CONNECT_EVENT_NAME = 'CONNECT_EVENT_HiMECS_MDI';
  CLIENT_DIR_NAME    = 'CLIENT_DIRECTORY_HiMECS_MDI';
  CLIENT_DIR_MUTEX   = 'DIRECTORY_MUTEX_HiMECS_MDI';

type

  EMonitorActive = class(Exception);

  TIPCThread_HiMECS_MDI = class;


{ TIPCEvent }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind = (
    evMonitorAttach,    // Notify client that monitor is attaching
    evMonitorDetach,    // Notify client that monitor is detaching
    evMonitorSignal,    // Monitor signaling client
    evMonitorExit,      // Monitor is exiting
    evClientStart,      // Notify monitor a client has started
    evClientStop,       // Notify monitor a client has stopped
    evClientAttach,     // Notify monitor a client is attaching
    evClientDetach,     // Notify monitor a client is detaching
    evClientSwitch,     // Notify monitor to switch to a new client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  TClientFlag = (cfError, cfMouseMove, cfMouseDown, cfResize, cfAttach);
  TClientFlags = set of TClientFlag;

  PEventData = ^TEventData_HiMECS_MDI;
  TEventData_HiMECS_MDI = packed record
    X: SmallInt;
    Y: SmallInt;
    Flag: TClientFlag;
    Flags: TClientFlags;
  end;

  TConnectEvent = procedure (Sender: TIPCThread_HiMECS_MDI; Connecting: Boolean; AID: integer) of Object;
  TDirUpdateEvent = procedure (Sender: TIPCThread_HiMECS_MDI) of Object;
  TIPCNotifyEvent = procedure (Sender: TIPCThread_HiMECS_MDI; Data: TEventData_HiMECS_MDI) of Object;

  PIPCEventInfo = ^TIPCEventInfo;
  TIPCEventInfo = record
    FID: Integer;
    FKind: TEventKind;
    FData: TEventData_HiMECS_MDI;
  end;

  TIPCEvent_HiMECS_MDI = class(TEvent)
  private
    FOwner: TIPCThread_HiMECS_MDI;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    FEventInfo: PIPCEventInfo;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind;
    procedure SetKind(Value: TEventKind);
    function GetData: TEventData_HiMECS_MDI;
    procedure SetData(Value: TEventData_HiMECS_MDI);
  public
    constructor Create(AOwner: TIPCThread_HiMECS_MDI; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind);
    procedure SignalID(Kind: TEventKind; ID: Integer);
    procedure SignalData(Kind: TEventKind; ID: Integer; Data: TEventData_HiMECS_MDI);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind read GetKind write SetKind;
    property Data: TEventData_HiMECS_MDI read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TClientDirectory }

{ The client directory is a block of shared memory where the list of all
  active clients is maintained }

  TClientDirEntry = packed record
    ID: Integer;
    Name: Array[0..58] of Char;
  end;

  TClientDirRecords = array[1..MAX_CLIENTS] of TClientDirEntry;
  PClientDirRecords = ^TClientDirRecords;

  TClientDirectory = class
  private
    FClientCount: PInteger;
    FMonitorID: PInteger;
    FMaxClients: Integer;
    FMutex: TMutex;
    FSharedMem: TSharedMem;
    FDirBuffer: PClientDirRecords;
    function GetCount: Integer;
    function GetClientName(ClientID: Integer): string;
    function GetClientRec(Index: Integer): TClientDirEntry;
    function IndexOf(ClientID: Integer): Integer;
    function GetMonitorID: Integer;
    procedure SetMonitorID(MonitorID: Integer);
  public
    constructor Create(MaxClients: Integer);
    destructor Destroy; override;
    function AddClient(ClientID: Integer; const AName: string): Integer;
    function Last: Integer;
    function RemoveClient(ClientID: Integer): Boolean;
    property Count: Integer read GetCount;
    property ClientRec[Index: Integer]: TClientDirEntry read GetClientRec;
    property MonitorID: Integer read GetMonitorID write SetMonitorID;
    property Name[ClientID: Integer]: string read GetClientName;
  end;

{ TIPCThread_HiMECS_MDI }

{ The TIPCThread_HiMECS_MDI class implements the functionality which is common between
  the monitor and client thread classes. }

  TState = (stInActive, stDisconnected, stConnected);

  TIPCThread_HiMECS_MDI = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FState: TState;
    FClientEvent: TIPCEvent_HiMECS_MDI;
    FMonitorEvent: TIPCEvent_HiMECS_MDI;
    FConnectEvent: TIPCEvent_HiMECS_MDI;
    FClientDirectory: TClientDirectory;
    FOnSignal: TIPCNotifyEvent;
    FOnConnect: TConnectEvent;
  public
    constructor Create(AID: Integer; const AName: string);
    destructor Destroy; override;
    procedure Activate; virtual; abstract;
    procedure DeActivate; virtual; abstract;
    procedure DbgStr(const S: string);
    property State: TState read FState;
  published
    property OnConnect: TConnectEvent read FOnConnect write FOnConnect;
    property OnSignal: TIPCNotifyEvent read FOnSignal write FOnSignal;
  end;

{ TIPCMonitor }

  TIPCMonitor_HiMECS_MDI = class(TIPCThread_HiMECS_MDI)
  private
    FClientID: Integer;
    FAutoSwitch: Boolean;
    FOnDirUpdate: TDirUpdateEvent;
  protected
    procedure ConnectToClient(ID: Integer);
    procedure DisconnectFromClient(Wait: Boolean);
    procedure DoOnSignal;
    function GetClientName: string;
    procedure Execute; override;
    procedure SetCurrentClient(ID: Integer);
    procedure DoOnDirUpdate;
  public
    constructor Create(AID: Integer; const AName: string);
    procedure Activate; override;
    procedure DeActivate; override;
    procedure SignalClient(const Value: TClientFlags);
    procedure GetClientNames(List: TStrings);
    procedure GetDebugInfo(List: TStrings);
    procedure SaveDebugInfo(const FileName: string);
    procedure ClearDebugInfo;
    property AutoSwitch: Boolean read FAutoSwitch write FAutoSwitch;
    property ClientName: string read GetClientName;
    property ClientID: Integer read FClientID write SetCurrentClient;
    property OnDirectoryUpdate: TDirUpdateEvent read FOnDirUpdate write FOnDirUpdate;
  end;

{ TIPCClient }

  TIPCClient_HiMECS_MDI = class(TIPCThread_HiMECS_MDI)
  private
    FWaitEvent: TIPCEvent_HiMECS_MDI;
    procedure ConnectToMonitor;
    procedure DisconnectFromMonitor(Wait: Boolean);
  protected
    procedure Execute; override;
  public
    procedure Activate; override;
    procedure DeActivate; override;
    function ClientCount: Integer;
    procedure SignalMonitor(Data: TEventData_HiMECS_MDI);
    procedure MakeCurrent;
  end;

function IsMonitorRunning(var Hndl: THandle): Boolean;

implementation

uses TypInfo;

{ Utility Routines }

procedure Error(const Msg: string);
begin
  raise Exception.Create(Msg);
end;

function EventName(Event: TEventKind): string;
begin
  Result := GetEnumName(TypeInfo(TEventKind), ord(Event));
end;

{ Utility function used by the monitor to determine if another monitor is
  already running.  This is needed to make the monitor a single instance .EXE.
  This function relies on the fact that the first 4 bytes of the client
  directory always contain the Application handle of the monitor, or zero if
  no monitor is running.  This function is used in Monitor.dpr. }

function IsMonitorRunning(var Hndl: THandle): Boolean;
var
  SharedMem: TSharedMem;
begin
  SharedMem := TSharedMem.Create(CLIENT_DIR_NAME, 4);
  Hndl := PHandle(SharedMem.Buffer)^;
  Result := Hndl <> 0;
  SharedMem.Free;
end;

{ TIPCEvent_HiMECS_MDI }

constructor TIPCEvent_HiMECS_MDI.Create(AOwner: TIPCThread_HiMECS_MDI; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEvent_HiMECS_MDI));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_HiMECS_MDI.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_HiMECS_MDI.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_HiMECS_MDI.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_HiMECS_MDI.GetKind: TEventKind;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_HiMECS_MDI.SetKind(Value: TEventKind);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_HiMECS_MDI.GetData: TEventData_HiMECS_MDI;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_HiMECS_MDI.SetData(Value: TEventData_HiMECS_MDI);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_HiMECS_MDI.Signal(Kind: TEventKind);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_HiMECS_MDI.SignalID(Kind: TEventKind; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_HiMECS_MDI.SignalData(Kind: TEventKind; ID: Integer; Data: TEventData_HiMECS_MDI);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

function TIPCEvent_HiMECS_MDI.WaitFor(TimeOut, ID: Integer; Kind: TEventKind): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
  if not Result then
    FOwner.DbgStr(Format('Wait Failed %s Kind: %s ID: %x' ,
      [FOwner.ClassName, EventName(Kind), ID]));
end;

{ TClientDirectory }

constructor TClientDirectory.Create(MaxClients: Integer);
begin
  FMaxClients := MaxClients;
  FMutex := TMutex.Create(CLIENT_DIR_MUTEX);
  FSharedMem := TSharedMem.Create(CLIENT_DIR_NAME,
    FMaxClients * SizeOf(TClientDirEntry) + 8);
  FMonitorID := FSharedMem.Buffer;
  Integer(FClientCount) := Integer(FMonitorID) + SizeOf(FMonitorID);
  Integer(FDirBuffer) := Integer(FClientCount) + SizeOf(FClientCount);
end;

destructor TClientDirectory.Destroy;
begin
  FSharedMem.Free;
  FMutex.Free;
end;

function TClientDirectory.AddClient(ClientID: Integer; const AName: string): Integer;
begin
  Result := -1;
  if Count = FMaxClients then
    Error(Format('Maximum of %d clients allowed', [FMaxClients]));
  if IndexOf(ClientID) > -1 then
    Error('Duplicate client ID');
  if FMutex.Get(TIMEOUT) then
  try
    with FDirBuffer[Count+1] do
    begin
      ID := ClientID;
      StrPLCopy(Name, PChar(AName), SizeOf(Name)-1);
      Inc(FClientCount^);
      Result := Count;
    end;
  finally
    FMutex.Release;
  end;
end;

function TClientDirectory.GetCount: Integer;
begin
  Result := FClientCount^;
end;

function TClientDirectory.GetClientRec(Index: Integer): TClientDirEntry;
begin
  if (Index > 0) and (Index <= Count) then
    Result := FDirBuffer[Index]
  else
    Error('Invalid client list index');
end;

function TClientDirectory.GetClientName(ClientID: Integer): string;
var
  Index: Integer;
begin
  Index := IndexOf(ClientID);
  if Index > 0 then
    Result := FDirBuffer[Index].Name
  else
    Result := '';
end;

function TClientDirectory.IndexOf(ClientID: Integer): Integer;
var
  I: Integer;
begin
  for I := 1 to Count do
    if FDirBuffer[I].ID = ClientID then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

function TClientDirectory.Last: Integer;
begin
  if Count > 0 then
    Result := FDirBuffer[Count].ID else
    Result := 0;
end;

function TClientDirectory.RemoveClient(ClientID: Integer): Boolean;
var
  Index: Integer;
begin
  Index := IndexOf(ClientID);
  if (Index > -1) and FMutex.Get(TIMEOUT) then
  try
    if (Index > 0) and (Index < Count) then
      Move(FDirBuffer[Index+1], FDirBuffer[Index],
        (Count - Index) * SizeOf(TClientDirEntry));
    Dec(FClientCount^);
    Result := True;
  finally
    FMutex.Release;
  end
  else
    Result := False;
end;

function TClientDirectory.GetMonitorID: Integer;
begin
  Result := FMonitorID^;
end;

procedure TClientDirectory.SetMonitorID(MonitorID: Integer);
begin
  FMonitorID^ := MonitorID;
end;

{ TIPCThread_HiMECS_MDI }

constructor TIPCThread_HiMECS_MDI.Create(AID: Integer; const AName: string);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_HiMECS_MDI.Create(Self, MONITOR_EVENT_NAME, False);
  FClientEvent := TIPCEvent_HiMECS_MDI.Create(Self, CLIENT_EVENT_NAME, False);
  FConnectEvent := TIPCEvent_HiMECS_MDI.Create(Self, CONNECT_EVENT_NAME, True);
  FClientDirectory := TClientDirectory.Create(MAX_CLIENTS);
end;

destructor TIPCThread_HiMECS_MDI.Destroy;
begin
  DeActivate;
  inherited Destroy;
  FClientDirectory.Free;
  FClientEvent.Free;
  FConnectEvent.Free;
  FMonitorEvent.Free;
  FState := stInActive;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_HiMECS_MDI.DbgStr(const S: string);
begin
end;

{ TIPCMonitor_HiMECS_MDI }

constructor TIPCMonitor_HiMECS_MDI.Create(AID: Integer; const AName: string);
begin
  inherited Create(AID, AName);
  FAutoSwitch := True;
end;

procedure TIPCMonitor_HiMECS_MDI.Activate;
begin
  if FState = stInActive then
  begin
    { Put the monitor handle into the client directory so we can use it to
      prevent multiple monitors from running }
    if FClientDirectory.MonitorID = 0 then
      FClientDirectory.MonitorID := FID
    else
      raise EMonitorActive.Create('');
    FState := stDisconnected;
    Resume;
  end;
end;

procedure TIPCMonitor_HiMECS_MDI.DeActivate;
begin
  if (State <> stInActive) and not Suspended then
  begin
    FClientDirectory.MonitorID := 0;
    FMonitorEvent.Signal(evMonitorExit);
    if WaitForSingleObject(Handle, TIMEOUT) <> WAIT_OBJECT_0 then
      TerminateThread(Handle, 0);
  end;
end;

{ This method, and the TIPCClient_HiMECS_MDI.Execute method represent the meat of this
  program.  These two thread handlers are responsible for communcation with
  each other through the IPC event classes }

procedure TIPCMonitor_HiMECS_MDI.Execute;
var
  WaitResult: Integer;
begin
  DbgStr(FName + ' Activated');
  if FClientDirectory.Count > 0 then
    FMonitorEvent.SignalID(evClientStart, FClientDirectory.Last);
  while True do
  try
    WaitResult := WaitForSingleObject(FMonitorEvent.Handle, INFINITE);
    if WaitResult >= WAIT_ABANDONED then        { Something went wrong }
      DisconnectFromClient(False) else
    if WaitResult = WAIT_OBJECT_0 then          { Monitor Event }
    begin
      DbgStr('Event Signaled: '+EventName(FMonitorEvent.Kind));
      case FMonitorEvent.Kind of
        evClientSignal:
          DoOnSignal;
        evClientStart:
          begin
            if AutoSwitch or (FClientID = 0) then
              ConnectToClient(FMonitorEvent.ID);
            DoOnDirUpdate;
          end;
        evClientStop:
          DoOnDirUpdate;
        evClientDetach:
          begin
            DisconnectFromClient(False);
            Sleep(100);
            if AutoSwitch then
              ConnectToClient(FClientDirectory.Last);
          end;
        evClientSwitch:
          ConnectToClient(FMonitorEvent.ID);
        evMonitorExit:
          begin
            DisconnectFromClient(False);
            break;
          end;
      end;
    end
    else
      DbgStr(Format('Unexpected Wait Return Code: %d', [WaitResult]));
  except
    on E:Exception do
      DbgStr(Format('Exception raised in Thread Handler: %s at %X', [E.Message, ExceptAddr]));
  end;
  FState := stInActive;
  DbgStr('Thread Handler Exited');
end;

procedure TIPCMonitor_HiMECS_MDI.ConnectToClient(ID: Integer);
begin
  if ID = FClientID then Exit;
  if FState = stConnected then
    DisconnectFromClient(True);
  if ID = 0 then Exit;
  DbgStr(Format('Sending evMonitorAttach: %X', [ID]));
  { Tell a client we want to attach to them }
  FConnectEvent.SignalID(evMonitorAttach, ID);
  { Wait for the client to say "OK" }
  if FMonitorEvent.WaitFor(TIMEOUT, ID, evClientAttach) and
    (FMonitorEvent.Data.Flag = cfAttach) then
  begin
    FClientID := ID;
    FState := stConnected;
    if Assigned(FOnConnect) then FOnConnect(Self, True, ID);
    DbgStr('ConnectToClient Successful');
  end
  else
    DbgStr('ConnectToClient Failed: '+EventName(FMonitorEvent.Kind));
end;

{ If Wait is true ... }

procedure TIPCMonitor_HiMECS_MDI.DisconnectFromClient(Wait: Boolean);
begin
  if FState = stConnected then
  begin
    DbgStr(Format('Sending evMonitorDetach: %x', [FClientID]));
    { Tell the client we are detaching }
    FClientEvent.SignalID(evMonitorDetach, FClientID);
    { If we (the monitor) initiated the detach process, then wait around
      for the client to acknowledge the detach, otherwise, just continue on }
    if Wait then
      if not FMonitorEvent.WaitFor(TIMEOUT, FClientID, evClientDetach) then
      begin
        DbgStr(Format('Error waiting for client to detach: %x', [FClientID]));
        FClientDirectory.RemoveClient(FClientID);
      end;
    FClientID := 0;
    FState := stDisconnected;
    if Assigned(FOnConnect) then FOnConnect(Self, False, FClientID);
    if not Wait and Assigned(FOnDirUpdate) then
      DoOnDirUpdate;
  end;
end;

{ This method is called when the client has new data for us }

procedure TIPCMonitor_HiMECS_MDI.DoOnSignal;
begin
  if Assigned(FOnSignal) and (FMonitorEvent.ID = FClientID) then
    FOnSignal(Self, FMonitorEvent.Data);
end;

{ Tell the client we have new flags for it }

procedure TIPCMonitor_HiMECS_MDI.SignalClient(const Value: TClientFlags);
begin
  if FState = stConnected then
  begin
    FClientEvent.FEventInfo.FData.Flags := Value;
    DbgStr('Signaling Client');
    FClientEvent.SignalData(evMonitorSignal, FClientID, FClientEvent.Data);
  end;
end;

function TIPCMonitor_HiMECS_MDI.GetClientName: string;
begin
  Result := FClientDirectory.Name[FClientID];
end;

procedure TIPCMonitor_HiMECS_MDI.GetClientNames(List: TStrings);
var
  I: Integer;
  S: string;
  DupCnt: Integer;
begin
  List.BeginUpdate;
  try
    List.Clear;
    for I := 1 to FClientDirectory.Count do
      with FClientDirectory.ClientRec[I] do
      begin
        S := Name;
        DupCnt := 1;
        { Number duplicate names so we can distinguish them in the client menu }
        while(List.IndexOf(S) > -1) do
        begin
          Inc(DupCnt);
          S := Format('%s (%d)', [Name, DupCnt]);
        end;
        List.AddObject(S, TObject(ID));
     end;
  finally
    List.EndUpdate;
  end;
end;

procedure TIPCMonitor_HiMECS_MDI.SetCurrentClient(ID: Integer);
begin
  if ID = 0 then ID := FClientDirectory.Last;
  if ID <> 0 then
    FMonitorEvent.SignalID(evClientSwitch, ID);
end;

procedure TIPCMonitor_HiMECS_MDI.ClearDebugInfo;
begin
end;

procedure TIPCMonitor_HiMECS_MDI.GetDebugInfo(List: TStrings);
begin
end;

procedure TIPCMonitor_HiMECS_MDI.SaveDebugInfo(const FileName: string);
begin
end;

procedure TIPCMonitor_HiMECS_MDI.DoOnDirUpdate;
begin
  if Assigned(FOnDirUpdate) then FOnDirUpdate(Self);
end;

{ TIPCClient_HiMECS_MDI }

procedure TIPCClient_HiMECS_MDI.Activate;
begin
  if FState = stInActive then
  begin
    FWaitEvent := FConnectEvent;
    FMonitorEvent.OwnerID := FID;
    FConnectEvent.OwnerID := FID;
    FClientEvent.OwnerID := FID;
    FClientDirectory.AddClient(FID, FName);
    FState := stDisconnected;
    Resume;
  end
end;

procedure TIPCClient_HiMECS_MDI.DeActivate;
begin
  if Assigned(FClientDirectory) then
    FClientDirectory.RemoveClient(FID);
  if (FState <> stInActive) and not Suspended then
  begin
    FWaitEvent.Signal(evClientExit);
    if WaitForSingleObject(Handle, TIMEOUT) <> WAIT_OBJECT_0 then
      TerminateThread(Handle, 0);
  end;
end;

procedure TIPCClient_HiMECS_MDI.Execute;
begin
  DbgStr(FName + ' Activated');
  if FClientDirectory.MonitorID <> 0 then
    FMonitorEvent.SignalID(evClientStart, FID);
  while True do
  try
    if WaitForSingleObject(FWaitEvent.Handle, INFINITE) <> WAIT_OBJECT_0 then Break;
    if FWaitEvent.ID <> FID then
    begin
      Sleep(200);
      continue;
    end;
    DbgStr('Client Event Signaled: '+EventName(FWaitEvent.Kind));
    case FWaitEvent.Kind of
      evMonitorSignal: if Assigned(FOnSignal) then FOnSignal(Self, FWaitEvent.Data);
      evMonitorAttach: ConnectToMonitor;
      evMonitorDetach:
        begin
          DisconnectFromMonitor(False);
          Sleep(200);
        end;
      evClientExit:
        begin
          if FClientDirectory.MonitorID <> 0 then
          begin
            if FState = stConnected then
              DisconnectFromMonitor(True)
            else
              FMonitorEvent.Signal(evClientStop);
          end;
          break;
        end;
    end;
  except
    on E:Exception do
      DbgStr(Format('Exception raised in Thread Handler: %s at %X', [E.Message, ExceptAddr]));
  end;
  FState := stInActive;
  DbgStr('Thread Handler Exited');
end;

procedure TIPCClient_HiMECS_MDI.ConnectToMonitor;
var
  Data: TEventData_HiMECS_MDI;
begin
  DbgStr('ConnectToMonitor Begin');
  FConnectEvent.Reset;
  try
    FState := stConnected;
    FWaitEvent := FClientEvent;
    Data.Flag := cfAttach;
    FMonitorEvent.SignalData(evClientAttach, FID, Data);
    if Assigned(FOnConnect) then FOnConnect(Self, True, FID);
  except
    DbgStr('Exception in ConnectToMonitor: '+Exception(ExceptObject).Message);
    Data.Flag := cfError;
    FMonitorEvent.SignalData(evClientAttach, FID, Data);
  end;
  DbgStr('ConnectToMonitor End');
end;

procedure TIPCClient_HiMECS_MDI.DisconnectFromMonitor(Wait: Boolean);
begin
  DbgStr('DisconnectFromMonitor Begin');
  if FState = stConnected then
  begin
    if Wait then
    begin
      DbgStr('Sending evClientDetach');
      FMonitorEvent.Signal(evClientDetach);
      if FClientEvent.WaitFor(TIMEOUT, FID, evMonitorDetach) then
        DbgStr('Got evMonitorDetach') else
        DbgStr('Error waiting for evMonitorDetach');
    end;
    FState := stDisconnected;
    FWaitEvent := FConnectEvent;
    if not Wait then
    begin
      DbgStr('DisconnectFromMonitor sending evClientDetach');
      FMonitorEvent.Signal(evClientDetach);
    end;
    if Assigned(FOnConnect) then FOnConnect(Self, False, FID);
  end;
  DbgStr('DisconnectFromMonitor End');
end;

procedure TIPCClient_HiMECS_MDI.SignalMonitor(Data: TEventData_HiMECS_MDI);
begin
  if FState = stConnected then
  begin
    DbgStr('Signaling Monitor');
    FMonitorEvent.SignalData(evClientSignal, FID, Data);
  end;
end;

function TIPCClient_HiMECS_MDI.ClientCount: Integer;
begin
  Result := FClientDirectory.Count;
end;

procedure TIPCClient_HiMECS_MDI.MakeCurrent;
begin
  FMonitorEvent.SignalID(evClientStart, FID);
end;

end.

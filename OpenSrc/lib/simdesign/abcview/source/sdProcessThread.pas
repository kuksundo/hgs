{ sdProcessThread.pas

  Generic processing thread.
  Used for abcview but can also be used by other applications

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2011 by SimDesign B.V.
}
unit sdProcessThread;

interface

uses
  Classes, SysUtils, Contnrs, SyncObjs;

type

  TProcessStatus = (
    psIdle,
    psRun,
    psTerminated,
    psPausing,
    psPaused
  );

  TProcessOption = (
    poAllowStop,
    poAllowPause
  );
  TProcessOptions = set of TProcessOption;

  TProcessList = class; //forward decl

  TProcess = class(TThread)
  private
    FName: Utf8String;
    FTask: Utf8String;
    FOptions: TProcessOptions;
    FStatus: TProcessStatus;
    procedure DoRemove;
  protected
    FOwner: TProcessList;
    function GetTask: Utf8String;
    procedure Execute; override;
    procedure Run; virtual; abstract;
    procedure Pause;
  public
    constructor Create(CreateSuspended: boolean; AOwner: TProcessList); virtual;
    function IsPaused: boolean;
    property Name: Utf8String read FName write FName;
    property Options: TProcessOptions read FOptions write FOptions;
    property Status: TProcessStatus read FStatus write FStatus;
    property Task: Utf8String read FTask write FTask;
  end;

  TProcessList = class(TObjectList)
  protected
    FLock: TCriticalSection;
    function GetItems(Index: integer): TProcess;
    procedure ProcessRemove(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure StopAllProcesses;
    property Items[Index: integer]: TProcess read GetItems; default;
  end;

const

  cStatusText: array[TProcessStatus] of Utf8String =
    ('Idle', 'Running', 'Terminated', 'Pausing', 'Paused');

  cStatusImage: array[TProcessStatus] of integer =
    (-1, 0, 2, 3, 1);

var
  // global process list
  glProcessList: TProcessList = nil;

implementation

{ TProcess }

procedure TProcess.Execute;
begin
  Status := psRun;
  Run;
  DoRemove;
end;

function TProcess.GetTask: Utf8String;
begin
  if FStatus = psRun then
    Result := FTask
  else
    Result := '';
end;

constructor TProcess.Create(CreateSuspended: boolean; AOwner: TProcessList);
begin
  inherited Create(True);
  FOwner := AOwner;
  if assigned(FOwner) then
    FOwner.Add(Self);
  FreeOnTerminate := True;
  FOptions := [poAllowStop, poAllowPause];
  if not CreateSuspended then
    Resume;
end;

function TProcess.IsPaused: boolean;
begin
  Result := FStatus = psPaused;
end;

procedure TProcess.Pause;
var
  OldPrio: TThreadPriority;
begin
  OldPrio := Priority;
  Priority := tpLower;
  FStatus := psPaused;
  FTask := '';
  while not Terminated and (FStatus = psPaused) do
    sleep(2);
  if not Terminated then
    Priority := OldPrio;
end;

procedure TProcess.DoRemove;
begin
  if assigned(FOwner) then
    FOwner.ProcessRemove(Self);
end;

{ TProcessList }

function TProcessList.GetItems(Index: integer): TProcess;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

destructor TProcessList.Destroy;
begin
  StopAllProcesses;
  FreeAndNil(FLock);
  inherited;
end;

procedure TProcessList.ProcessRemove(Sender: TObject);
var
  Process: TProcess;
begin
  FLock.Enter;
  try
    Process := Items[IndexOf(Sender)];
    Remove(Process);
  finally
    FLock.Leave;
  end;
end;

procedure TProcessList.StopAllProcesses;
var
  i: integer;
begin
  // Indicate to all processes to terminate
  FLock.Enter;
  try
    for i := Count - 1 downto 0 do
      Items[i].Terminate;
  finally
    FLock.Leave;
  end;

  // Wait for the count to go to zero
  while Count > 0 do
    sleep(10);
end;

constructor TProcessList.Create;
begin
  inherited Create(False);
  FLock := TCriticalSection.Create;
end;

end.

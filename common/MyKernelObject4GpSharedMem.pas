unit MyKernelObject4GpSharedMem;

interface

uses
  SysUtils, Classes, Windows {$IFDEF USEGPSM}, GpSharedMemory {$ENDIF};

const
  MAX_SHARED_MEM_SIZE = 300000000;

type

{ WIN32 Helper Classes }

{ THandledObject }

{ This is a generic class for all encapsulated WinAPI's which need to call
  CloseHandle when no longer needed.  This code eliminates the need for
  3 identical destructors in the TEvent, TMutex, and TSharedMem classes
  which are descended from this class. }

  THandledObject = class(TObject)
  protected
    FHandle: THandle;
  public
    destructor Destroy; override;
    property Handle: THandle read FHandle;
  end;

{ TEvent }

{ This class encapsulates the concept of a Win32 event (not to be
  confused with Delphi events), see "CreateEvent" in the Win32
  reference for more information }

  TEvent = class(THandledObject)
  public
    constructor Create(const Name: string; Manual: Boolean);
    procedure Signal;
    procedure Reset;
    function Pulse: Boolean;
    function Wait(TimeOut: Integer): Boolean;
  end;

{ TMutex }

{ This class encapsulates the concept of a Win32 mutex.  See "CreateMutex"
  in the Win32 reference for more information }

  TMutex = class(THandledObject)
  public
    constructor Create(const Name: string);
    function Get(TimeOut: Integer): Boolean;
    function Release: Boolean;
  end;

{ TSharedMem }

{ This class simplifies the process of creating a region of shared memory.
  In Win32, this is accomplished by using the CreateFileMapping and
  MapViewOfFile functions. }

  TSharedMem = class(THandledObject)
  private
    FName: string;
    FSize: cardinal;
    FCreated: Boolean;
    FFileView: Pointer;
  protected
    procedure SetSize(ASize: cardinal);
  public
//    FGpSM: TpjhGpSharedMemory;

    constructor Create(const Name: string; ASize: cardinal);
    destructor Destroy; override;
    property Name: string read FName;
    property Size: cardinal read FSize write SetSize;
    property Buffer: Pointer read FFileView;
    property Created: Boolean read FCreated;
  end;

implementation

{ THandledObject }

destructor THandledObject.Destroy;
begin
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

{ TEvent }
//PulseEvent를 사용시에 복수개의 Process에서 동시에 Wait 함수가 Return 할려면
//Manual Reset방식으로 해야함(Auto-Reset은 한개씩만 Return 됨)
constructor TEvent.Create(const Name: string; Manual: Boolean);
var i: integer;
begin
  FHandle := CreateEvent(nil, Manual, False, PChar(Name));
  i := GetLastError;
  if i =  ERROR_ALREADY_EXISTS then
    FHandle := OpenEvent(EVENT_ALL_ACCESS,True,PChar(Name));
  if FHandle = 0 then abort;
end;

procedure TEvent.Reset;
begin
  ResetEvent(FHandle);
end;

function TEvent.Pulse: Boolean;
begin
  Result := Windows.PulseEvent(FHandle);
end;

procedure TEvent.Signal;
begin
  SetEvent(FHandle);
end;

function TEvent.Wait(TimeOut: Integer): Boolean;
begin
  Result := WaitForSingleObject(FHandle, TimeOut) = WAIT_OBJECT_0;
end;

{ TMutex }

constructor TMutex.Create(const Name: string);
begin
  FHandle := CreateMutex(nil, False, PChar(Name));
  if FHandle = 0 then abort;
end;

function TMutex.Get(TimeOut: Integer): Boolean;
begin
  Result := WaitForSingleObject(FHandle, TimeOut) = WAIT_OBJECT_0;
end;

function TMutex.Release: Boolean;
begin
  Result := ReleaseMutex(FHandle);
end;

{ TSharedMem }

constructor TSharedMem.Create(const Name: string; ASize: cardinal);
begin
  try
    FName := Name;
    FSize := Size;
    {$IFDEF USEGPSM}
    FFileView := TGpSharedMemory.Create(Name, ASize, MAX_SHARED_MEM_SIZE);
    FCreated := True;
    FSize := ASize;
    {$ELSE}
    FHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0,
        Size, PChar(Name));
    if FHandle = 0 then abort;
    FCreated := GetLastError = 0;
    FFileView := MapViewOfFile(FHandle, FILE_MAP_WRITE, 0, 0, Size);
    if FFileView = nil then abort;
    {$ENDIF}
  except
    //Error(Format('Error creating shared memory %s (%d)', [Name, GetLastError]));
  end;
end;

destructor TSharedMem.Destroy;
begin
  {$IFDEF USEGPSM}
  FreeAndNil(FFileView);
  {$ENDIF}
//  if FFileView <> nil then
//    UnmapViewOfFile(FFileView);
  inherited Destroy;
end;

procedure TSharedMem.SetSize(ASize: cardinal);
begin
  FSize := ASize;
end;

{ IPC Classes }

end.
 
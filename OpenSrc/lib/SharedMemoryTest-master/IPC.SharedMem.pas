//   Copyright 2015 Asbj?n Heid
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
unit IPC.SharedMem;

interface

uses
  Winapi.Windows, System.SysUtils;

type
  SharedMemoryAccess = (SharedMemoryAccessReadOnly, SharedMemoryAccessReadWrite);

{$REGION 'Implementation details'}
  Detail = record type
    ISharedMemory = interface
      function GetAbandoned: boolean;
      function GetData: pointer;

      procedure AquireLock;
      procedure ReleaseLock;

      property Abandoned: boolean read GetAbandoned;
      property Data: pointer read GetData;
    end;

    TSharedMemoryImpl = class(TInterfacedObject, ISharedMemory)
    strict private
      FMutexHandle: THandle;
      FMutexAbandoned: boolean;
      FMappingHandle: THandle;
      FData: pointer;
    public
      constructor Create(const Size: NativeUInt; Access: SharedMemoryAccess; const Name: string);
      destructor Destroy; override;

      procedure AquireLock;
      procedure ReleaseLock;

      function GetAbandoned: boolean;
      function GetData: pointer;
    end;
  end;
{$ENDREGION}

  SharedMemory<TData: record> = record
  public
    type Ptr = ^TData;
  strict private
    FImpl: Detail.ISharedMemory;
    function GetAbandoned: boolean;
  private
    property Impl: Detail.ISharedMemory read FImpl;
  public
    class function Create(const Name: string; const Access: SharedMemoryAccess): SharedMemory<TData>; static;
    class operator Implicit(const Impl: Detail.ISharedMemory): SharedMemory<TData>;

    // direct access
    function BeginAccess: Ptr;
    procedure EndAccess;

    property Abandoned: boolean read GetAbandoned;
  end;

implementation

uses
  System.TypInfo;


{ Detail.TSharedMemoryImpl }

procedure Detail.TSharedMemoryImpl.AquireLock;
var
  r: cardinal;
begin
  r := WaitForSingleObject(FMutexHandle, INFINITE);

  FMutexAbandoned := (r = WAIT_ABANDONED);

  if (r <> WAIT_OBJECT_0) and (r <> WAIT_ABANDONED) then
    RaiseLastOSError();
end;

constructor Detail.TSharedMemoryImpl.Create(const Size: NativeUInt; Access: SharedMemoryAccess; const Name: string);
type
  UInt64Rec = record
    case integer of
      0: (i64: UInt64);
      1: (lo32, hi32: UInt32);
  end;
const
  FileMappingFlags: array[SharedMemoryAccess] of cardinal = (PAGE_READONLY, PAGE_READWRITE);
  MappingAccess: array[SharedMemoryAccess] of cardinal = (FILE_MAP_READ, FILE_MAP_ALL_ACCESS);
var
  bufferSize: UInt64Rec;
  lastError: cardinal;
  i: integer;
  mutexName: string;
  eventName: string;
begin
  inherited Create;

  // create mutex
  mutexName := Name + '__MUTEX__';

  for i := 0 to 9 do
  begin
    FMutexHandle := CreateMutex(nil, False, PChar(mutexName));
    if (FMutexHandle <> 0) then
      break;

    lastError := GetLastError;

    if (lastError <> ERROR_ACCESS_DENIED) then
      RaiseLastOSError(lastError);

    // access denied means the mutex exists but we have limited
    // rights, try to open it instead

    FMutexHandle := OpenMutex(SYNCHRONIZE, False, PChar(mutexName));
    if (FMutexHandle <> 0) then
      break;

    lastError := GetLastError;

    if (lastError <> ERROR_FILE_NOT_FOUND) then
      RaiseLastOSError(lastError);

    // mutex was closed between create and open call, try again
  end;


  // create shared memory mapping
  bufferSize.i64 := Size;

  FMappingHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil, FileMappingFlags[Access], bufferSize.hi32, bufferSize.lo32, PChar(Name));
  if (FMappingHandle = 0) then
    RaiseLastOSError();

  FData := MapViewOfFile(FMappingHandle, MappingAccess[Access], 0, 0, Size);
  if (FData = nil) then
    RaiseLastOSError();
end;

destructor Detail.TSharedMemoryImpl.Destroy;
begin
  if (FData <> nil) then
    UnmapViewOfFile(FData);

  if (FMappingHandle <> 0) then
    CloseHandle(FMappingHandle);

  CloseHandle(FMutexHandle);

  inherited;
end;

function Detail.TSharedMemoryImpl.GetAbandoned: boolean;
begin
  result := FMutexAbandoned;
end;

function Detail.TSharedMemoryImpl.GetData: pointer;
begin
  result := FData;
end;

procedure Detail.TSharedMemoryImpl.ReleaseLock;
begin
  ReleaseMutex(FMutexHandle);
end;

{ SharedMemory<TData> }

function SharedMemory<TData>.BeginAccess: Ptr;
begin
  Impl.AquireLock;
  result := Ptr(Impl.Data);
end;

class function SharedMemory<TData>.Create(const Name: string; const Access: SharedMemoryAccess): SharedMemory<TData>;
var
  ti: PTypeInfo;
  td: PTypeData;
begin
  ti := TypeInfo(TData);
  td := GetTypeData(ti);

//  if (td^.ManagedFldCount > 0) then
//    raise EArgumentException.CreateFmt('Shared memory data type %s cannot contain managed fields', [ti^.Name]);

  if (Name = '') then
    raise EArgumentException.Create('Shared memory name is empty');

  result := Detail.TSharedMemoryImpl.Create(SizeOf(TData), Access, Name);
end;

procedure SharedMemory<TData>.EndAccess;
begin
  Impl.ReleaseLock;
end;

function SharedMemory<TData>.GetAbandoned: boolean;
begin
  result := Impl.Abandoned;
end;

class operator SharedMemory<TData>.Implicit(const Impl: Detail.ISharedMemory): SharedMemory<TData>;
begin
  result.FImpl := Impl;
end;

end.

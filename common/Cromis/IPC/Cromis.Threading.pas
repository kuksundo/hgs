(*
 * This software is distributed under BSD license.
 *
 * Copyright (c) 2009 Iztok Kacin, Cromis (iztok.kacin@gmail.com).
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 * - Neither the name of the Iztok Kacin nor the names of its contributors may be
 *   used to endorse or promote products derived from this software without specific
 *   prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * =============================================================================
 * Threading support. Thread Pool and threading support routines and classes
 * =============================================================================
 * 26/11/2010 (1.0.0)
 *   - Initial implementation of a Thread Pool.
 * 27/11/2010 (1.1.0)
 *   - Use direct notification calls from threads instead of messages
 *   - Changed names of some procedures
 * 28/11/2010 (1.2.0)
 *   - Change approach to task based. No need to define your own threads anymore
 *   - Use TStreamStorage as versatile data carrier between threads
 * 30/11/2010 (1.3.0)
 *   - Renamed ThreadPool to TaskPool
 *   - Added ITask as the main pool object
 *   - Implemented ITaskValues / ITaskValue as data carrier for more flexibility
 * 03/12/2010 (1.3.1)
 *   - Added DynamicSize property. Pool downsizes if larger than initial size
 *   - Only MinPoolSize is left (no MaxPoolSize). Can be set before initialize
 * 06/12/2010 (1.3.2)
 *   - Added Task Queue class
 * 07/12/2010 (1.3.3)
 *   - Simplified Task Queue and made it faster
 * 15/12/2010 (1.3.4)
 *   - Added "SendMessageAsync" as means of sending messages from tasks
 * 12/03/2010 (1.3.5)
 *   - WaitFor is only available in Delphi 2005 and up
 *   - Added AsBoolean and AsInterface types for ITaskValue
 *   - Added ITaskValues.Exists
 * 05/09/2010 (1.3.6)
 *   - Added WaitFor so tasks can be waited upon
 *   - Added Terminated flag for task
 * 18/10/2010 (1.3.7)
 *   - Added ShutdownTimeout (INFINITE by default)
 *   - Wait for all tasks to finish then shutting down the task pool
 * 28/12/2010 (1.4.0)
 *   - Added TLockFreeStack based on Windows SLISTS
 *   - Added TThreadSafeQueue based on linked lists
 * 27/05/2011 (1.4.1)
 *   - TThreadSafeQueue.AcquireNewItem does not need the lock
 * 09/06/2011 (1.4.2)
 *   - TTaskQueue is not only available as ITaskQueue interface
 * 01/07/2011 (1.4.3)
 *   - Added StopAllTasks for TTaskPool
 * 18/03/2012 (1.5.0)
 *   - 64 bit compiler compatible
 * 18/02/2013 (1.6.0)
 *   - Use new TAnyValue for internal data carrier
 *   - Rewriten TLockFreeStack
 *   - Task pool no uses TLockFreeStack for free tasks list
 * =============================================================================
*)
unit Cromis.Threading;

interface

uses
  Windows, Messages, SysUtils, Classes, Contnrs, Variants,

  // cromis units
  Cromis.AnyValue;

const
  cDefaultTimeout = 5000;
  cDefaultSize = 5000;
  cCSSpinCount = 4000;

type
  PTaskQueueItem = ^TTaskQueueItem;
  TTaskQueueItem = record
    Next: PTaskQueueItem;
    Event: THandle;
    {$IF CompilerVersion >= 17}
      procedure WaitFor;
    {$IFEND}
  end;

  PTaskHeadItem = ^TTaskHeadItem;
  TTaskHeadItem = record
    Last: PTaskQueueItem;
    First: PTaskQueueItem;
    Count: Integer;
  end;

  ITaskQueue = Interface(IInterface)
  ['{D6DFBA09-968D-4634-BA1D-79AFD4A029BB}']
    function EnqueueTask: PTaskQueueItem;
    procedure DequeueTask;
    function GetQueueSize: Integer;
  end;

{$IFNDEF Threading_NoLockFreeStack}
type
  PStackItem = ^TStackItem;
  TStackItem = record
    Next: PStackItem;
    Data: TAnyVAlue;
  end;

  procedure InitializeSListHead(ListHead: Pointer); stdcall; external 'kernel32';
  function InterlockedPopEntrySList(ListHead: Pointer): Pointer; stdcall; external 'kernel32';
  function InterlockedPushEntrySList(ListHead: Pointer; ListEntry: Pointer): Pointer; stdcall; external 'kernel32';
  function InterlockedFlushSList(ListHead: Pointer): Pointer; stdcall; external 'kernel32';
  function QueryDepthSList(ListHead: Pointer): Word; stdcall; external 'kernel32';

type
  TLockFreeStack = class
  private
    FDeleted: Pointer;
    FListHead: Pointer;
    function GetCount: Integer;
    procedure DoFinalizeList(const ListHead: Pointer);
    procedure InitializeDeleteSize(const InitialSize: Integer);
  public
    constructor Create(const InitialSize: Integer = cDefaultSize);
    destructor Destroy; override;
    function Pop: TAnyValue;
    function Flush: PStackItem;
    function Push(const Value: TAnyValue): PStackItem;
    property Count: Integer read GetCount;
    procedure Clear;
  end;
{$ENDIF}

type
  PQueueItem = ^TQueueItem;
  TQueueItem = record
    Next: PQueueItem;
    Data: TAnyValue;
  end;

  TQueueControl = class
    CSection: TRTLCriticalSection;
    Head: PQueueItem;
    Tail: PQueueItem;
    Count: Int64;
  end;

  TThreadSafeQueue = class
  private
    FQueue: TQueueControl;
    FDeleted: TQueueControl;
    function GetCount: Int64;
    function AcquireNewItem: PQueueItem;
    procedure ClearData(const List: TQueueControl);
    procedure InitializeDeleteSize(const InitialSize: Integer);
  protected
    procedure DoEnqueue(const List: TQueueControl; const Item: PQueueItem);
    function DoDequeue(const List: TQueueControl; var Item: PQueueItem): Boolean;
  public
    constructor Create(const InitialSize: Integer = cDefaultSize);
    destructor Destroy; override;
    procedure Enqueue(const Value: TAnyValue);
    function Dequeue(var Value: TAnyValue): Boolean;
    property Count: Int64 read GetCount;
  end;

  // task values interfaces
  ITaskValues = IValueList;
  ITaskValue = IAnyValue;
  ITask = Interface;

  ITaskMessage = Interface(IInterface)
  ['{7E356929-C4BF-4352-84FD-472F87D50C3C}']
    function GetName: string;
    function GetValues: ITaskValues;
    property Name: string read GetName;
    property Values: ITaskValues read GetValues;
  end;

  TOnTaskMessage = procedure(const Msg: ITaskMessage) of Object;
  TOnTaskEvent = procedure(const ATask: ITask) of Object;

  ITask = Interface(IInterface)
  ['{3215E86F-ABC0-428C-9E5D-520BE08B0B50}']
    function GetName: string;
    function GetValues: ITaskValues;
    function GetMessage: ITaskValues;
    function GetTerminated: Boolean;
    function GetTaskMethod: TOnTaskEvent;
    procedure SetName(const Value: string);
    procedure SetTaskMethod(const Value: TOnTaskEvent);
    property TaskMethod: TOnTaskEvent read GetTaskMethod write SetTaskMethod;
    property Name: string read GetName write SetName;
    property Terminated: Boolean read GetTerminated;
    property Message: ITaskValues read GetMessage;
    property Values: ITaskValues read GetValues;
    // procedures of the ITask interface
    procedure SendMessageSync(const Timeout: Integer = cDefaultTimeout);
    procedure WaitFor(const Timeout: Cardinal = INFINITE);
    procedure SendMessageAsync;
    procedure Terminate;
    procedure Run;
  end;

  IBaseTaskList = Interface(IInterface)
  ['{942D599D-D651-452D-821A-37C1A11720E0}']
    procedure Clear;
    function GetCount: Int64;
    function AcquireFirstTask: ITask;
    procedure AddTask(const ATask: ITask);
    property Count: Int64 read GetCount;
  end;

  IFreeTaskList = Interface(IBaseTaskList)
  ['{5A40BA9E-66F5-45CB-86A5-2C32C88053A7}']
  end;

  IAllTaskList = Interface(IBaseTaskList)
  ['{460E7CF3-9467-4F4B-85C6-4D5EDDDA268E}']
    procedure RemoveTask(const ATask: ITask);
  end;

  TTaskPool = class
  strict private
    FRunning: Boolean;
    FWndHandle: HWND;
    FDynamicSize: Boolean;
    FMinPoolSize: Integer;
    FAllTaskList: IAllTaskList;
    FFreeTaskList: IFreeTaskList;
    FOnTaskMessage: TOnTaskMessage;
    FShutdownTimeout: Cardinal;
    function GetPoolSize: Integer;
    function GetFreeTasks: Integer;
    function AcquireFreeTask: ITask;
    procedure DeallocateHWnd(Wnd: HWND);
    procedure WatchWndProc(var Msg: TMessage);
    procedure OnTaskComplete(const ATask: ITask);
  strict protected
    procedure StopAllTasks;
  public
    destructor Destroy; override;
    constructor Create(const MinPoolSize: Integer);
    function AcquireTask(const TaskMethod: TOnTaskEvent; const Name: string): ITask;
    procedure Initialize;
    procedure Finalize;
    // properties of the thread pool
    property OnTaskMessage: TOnTaskMessage read FOnTaskMessage write FOnTaskMessage;
    property ShutdownTimeout: Cardinal read FShutdownTimeout write FShutdownTimeout;
    property DynamicSize: Boolean read FDynamicSize write FDynamicSize;
    property MinPoolSize: Integer read FMinPoolSize write FMinPoolSize;
    property FreeTasks: Integer read GetFreeTasks;
    property PoolSize: Integer read GetPoolSize;
    property Running: Boolean read FRunning;
  end;

  // acuire the task valus function
  function AcquireTaskValues: ITaskValues;
  function AcquireTaskQueue: ITaskQueue;

implementation

const
  WM_TASK_MESSAGE = WM_USER + 100;

type
  TTaskMessage = class(TInterfacedObject, ITaskMessage)
  private
    FName: string;
    FValues: ITaskValues;
    function GetName: string;
    function GetValues: ITaskValues;
  public
    constructor Create(const Name: string);
    property Name: string read GetName;
    property Values: ITaskValues read GetValues;
  end;

  TWorkerThread = class(TThread)
  private
    FOwner: ITask;
    FWaitEvent: THandle;
    FOnTaskComplete: TOnTaskEvent;
  protected
    procedure Execute; override;
  public
    destructor Destroy; override;
    constructor Create(const Owner: ITask; const OnTaskComplete: TOnTaskEvent);
    property WaitEvent: THandle read FWaitEvent;
  end;

  TMessageObj = class
  private
    FMessage: ITaskMessage;
  public
    constructor Create(const Msg: ITaskMessage);
    property Msg: ITaskMessage read FMessage;
  end;

  TFreeTaskList = class(TInterfacedObject, IFreeTaskList)
  private
  {$IFNDEF Threading_NoLockFreeStack}
    FInternalList: TLockFreeStack;
  {$ELSE}
    FInternalList: TInterfaceList;
    FCriticalSec: TRTLCriticalSection;
  {$ENDIF}
    function GetCount: Int64;
  public
    constructor Create;
    destructor Destroy; override;
    function AcquireFirstTask: ITask;
    procedure Clear;
    procedure AddTask(const ATask: ITask);
    property Count: Int64 read GetCount;
  end;

  TAllTaskList = class(TInterfacedObject, IAllTaskList)
  private
    FInternalList: TInterfaceList;
    FCriticalSec: TRTLCriticalSection;
    function GetCount: Int64;
  public
    constructor Create;
    destructor Destroy; override;
    function AcquireFirstTask: ITask;
    procedure Clear;
    procedure AddTask(const ATask: ITask);
    procedure RemoveTask(const ATask: ITask);
    property Count: Int64 read GetCount;
  end;

  TTask = class(TInterfacedObject, ITask)
  private
    FName: string;
    FHWND: HWND;
    FValues: ITaskValues;
    FTaskMethod: TOnTaskEvent;
    FThreadHandle: THandle;
    FWorkerThread: TWorkerThread;
    FCurrentMessage: TMessageObj;
    function GetName: string;
    function GetValues: ITaskValues;
    function GetMessage: ITaskValues;
    function GetTerminated: Boolean;
    function GetTaskMethod: TOnTaskEvent;
    procedure SetTaskMethod(const Value: TOnTaskEvent);
    procedure SetName(const Value: string);
  public
    destructor Destroy; override;
    constructor Create(const OnTaskComplete: TOnTaskEvent; const WinHandle: HWND);
    property TaskMethod: TOnTaskEvent read GetTaskMethod write SetTaskMethod;
    property Name: string read GetName write SetName;
    property Terminated: Boolean read GetTerminated;
    property Message: ITaskValues read GetMessage;
    property Values: ITaskValues read GetValues;
    // procedures of the ITask interface
    procedure SendMessageSync(const Timeout: Integer = cDefaultTimeout);
    procedure WaitFor(const Timeout: Cardinal = INFINITE);
    procedure SendMessageAsync;
    procedure Terminate;
    procedure Run;
  end;

  TTaskQueue = class(TInterfacedObject, ITaskQueue)
  private
    FHead: PTaskHeadItem;
    FDeleted: PTaskHeadItem;
    FCriticalSec: TRTLCriticalSection;
    function AcquireNewItem: PTaskQueueItem;
    procedure ClearData(const RootItem: PTaskHeadItem);
    procedure DeleteUnusedItem(const Item: PTaskQueueItem);
  public
    constructor Create;
    destructor Destroy; override;
    function EnqueueTask: PTaskQueueItem;
    procedure DequeueTask;
    function GetQueueSize: Integer;
  end;

function AcquireTaskValues: ITaskValues;
begin
  Result := AcquireValueList;
end;

function AcquireTaskQueue: ITaskQueue;
begin
  Result := TTaskQueue.Create;
end;

{ TThreadPool }

constructor TTaskPool.Create(const MinPoolSize: Integer);
begin
  FWndHandle := AllocateHWnd(WatchWndProc);
  FFreeTaskList := TFreeTaskList.Create;
  FAllTaskList := TAllTaskList.Create;

  // the shutdown timeout
  FShutdownTimeout := INFINITE;

  // minimum size of the pool
  FMinPoolSize := MinPoolSize;
end;

procedure TTaskPool.DeallocateHWnd(Wnd: HWND);
var
  Instance: Pointer;
begin
  Instance := Pointer(GetWindowLong(Wnd, GWL_WNDPROC));

  if Instance <> @DefWindowProc then
  begin
    { make sure we restore the default
      windows procedure before freeing memory }
    SetWindowLong(Wnd, GWL_WNDPROC, Longint(@DefWindowProc));
    FreeObjectInstance(Instance);
  end;

  DestroyWindow(Wnd);
end;

destructor TTaskPool.Destroy;
begin
  if FAllTaskList.Count > 0 then
    Finalize;

  // dealocate window handle
  DeallocateHWnd(FWndHandle);

  inherited;
end;

procedure TTaskPool.Finalize;
begin
  // not running
  FRunning := False;

  StopAllTasks;
  FAllTaskList.Clear;
  FFreeTaskList.Clear;
end;

function TTaskPool.GetFreeTasks: Integer;
begin
  Result := FFreeTaskList.Count;
end;

function TTaskPool.GetPoolSize: Integer;
begin
  Result := FAllTaskList.Count;
end;

procedure TTaskPool.Initialize;
var
  I: Integer;
  Task: ITask;
begin
  for I := 0 to FMinPoolSize - 1 do
  begin
    Task := TTask.Create(OnTaskComplete, FWndHandle);
    FFreeTaskList.AddTask(Task);
    FAllTaskList.AddTask(Task);
  end;

  // set the flag
  FRunning := True;
end;

procedure TTaskPool.OnTaskComplete(const ATask: ITask);
begin
  if (FDynamicSize and (FAllTaskList.Count > FMinPoolSize)) then
  begin
    FAllTaskList.RemoveTask(ATask);
    ATask.Terminate;
    Exit;
  end;

  if FRunning then
    FFreeTaskList.AddTask(ATask)
end;

procedure TTaskPool.StopAllTasks;
var
  Task: ITask;
begin
  Task := FAllTaskList.AcquireFirstTask;

  while Task <> nil do
  begin
    Task.Terminate;
    Task.WaitFor(FShutdownTimeout);
    // get the next task to be terminated
    Task := FAllTaskList.AcquireFirstTask;
  end;
end;

procedure TTaskPool.WatchWndProc(var Msg: TMessage);
var
  MessageObj: TMessageObj;
begin
  if Msg.msg = WM_TASK_MESSAGE then
  begin
    MessageObj := TMessageObj(Pointer(Msg.WParam));
    try
      if Assigned(FOnTaskMessage) then
        FOnTaskMessage(MessageObj.Msg);
    finally
      MessageObj.Free;
    end;
  end
  else
    Msg.Result := DefWindowProc(FWndHandle, Msg.Msg, Msg.wParam, Msg.lParam);
end;

function TTaskPool.AcquireTask(const TaskMethod: TOnTaskEvent; const Name: string): ITask;
begin
  // set task data
  Result := AcquireFreeTask;
  Result.TaskMethod := TaskMethod;
  Result.Name := Name;
  Result.Values.Clear;
end;

function TTaskPool.AcquireFreeTask: ITask;
begin
  Result := FFreeTaskList.AcquireFirstTask;

  if Result = nil then
  begin
    Result := TTask.Create(OnTaskComplete, FWndHandle);
    FAllTaskList.AddTask(Result);
  end;
end;

{ TWorkerThread }

constructor TWorkerThread.Create(const Owner: ITask; const OnTaskComplete: TOnTaskEvent);
begin
  inherited Create(False);

  // create the event to put thread to sleep
  FWaitEvent := CreateEvent(nil, False, False, nil);
  // set the pool window handle
  FOnTaskComplete := OnTaskComplete;
  // set the owner task
  FOwner := Owner;

  // free thread on terminate
  FreeOnTerminate := True;
end;

destructor TWorkerThread.Destroy;
begin
  CloseHandle(FWaitEvent);

  inherited;
end;

procedure TWorkerThread.Execute;
begin
  inherited;

  // wait until the thread is actually called
  WaitForSingleObject(FWaitEvent, INFINITE);

  // main thread loop
  while not Terminated do
  begin
    // execute the task
    FOwner.TaskMethod(FOwner);

    // signal we are done
    FOnTaskComplete(FOwner);
    // wait for the next client call
    WaitForSingleObject(FWaitEvent, INFINITE);
  end;
end;

{ TAllTaskList }

procedure TAllTaskList.Clear;
begin
  EnterCriticalSection(FCriticalSec);
  try
    FInternalList.Clear;
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
end;

constructor TAllTaskList.Create;
begin
  InitializeCriticalSectionAndSpinCount(FCriticalSec, cCSSpinCount);
  FInternalList := TInterfaceList.Create;
end;

destructor TAllTaskList.Destroy;
begin
  FreeAndNil(FInternalList);
  DeleteCriticalSection(FCriticalSec);

  inherited;
end;

procedure TAllTaskList.AddTask(const ATask: ITask);
begin
  EnterCriticalSection(FCriticalSec);
  try
    FInternalList.Add(ATask);
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
end;

function TAllTaskList.GetCount: Int64;
begin
  EnterCriticalSection(FCriticalSec);
  try
    Result := FInternalList.Count;
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
end;

procedure TAllTaskList.RemoveTask(const ATask: ITask);
begin
  EnterCriticalSection(FCriticalSec);
  try
    FInternalList.Remove(ATask);
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
end;

function TAllTaskList.AcquireFirstTask: ITask;
begin
  Result := nil;

  EnterCriticalSection(FCriticalSec);
  try
    if FInternalList.Count > 0 then
    begin
      Result := ITask(FInternalList.First);
      FInternalList.Remove(FInternalList.First);
    end;
  finally
     LeaveCriticalSection(FCriticalSec);
  end;
end;

{ TFreeTaskList }

function TFreeTaskList.AcquireFirstTask: ITask;
begin
{$IFNDEF Threading_NoLockFreeStack}
  Result := ITask(FInternalList.Pop.AsInterface);
{$ELSE}
  EnterCriticalSection(FCriticalSec);
  try
    Result := nil;

    if FInternalList.Count > 0 then
    begin
      Result := ITask(FInternalList.First);
      FInternalList.Remove(Result);
    end;
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
{$ENDIF}
end;

procedure TFreeTaskList.AddTask(const ATask: ITask);
begin
{$IFNDEF Threading_NoLockFreeStack}
  FInternalList.Push(ATask);
{$ELSE}
  EnterCriticalSection(FCriticalSec);
  try
    FInternalList.Add(ATask);
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
{$ENDIF}
end;

procedure TFreeTaskList.Clear;
begin
{$IFNDEF Threading_NoLockFreeStack}
  FInternalList.Clear;
{$ELSE}
  EnterCriticalSection(FCriticalSec);
  try
    FInternalList.Clear;
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
{$ENDIF}
end;

constructor TFreeTaskList.Create;
const
  cInitialSize = 500;
begin
{$IFNDEF Threading_NoLockFreeStack}
  FInternalList := TLockFreeStack.Create(cInitialSize);
{$ELSE}
  InitializeCriticalSectionAndSpinCount(FCriticalSec, cCSSpinCount);
  FInternalList := TInterfaceList.Create;
{$ENDIF}
end;

destructor TFreeTaskList.Destroy;
begin
  FreeAndNil(FInternalList);
{$IFDEF Threading_NoLockFreeStack}
  DeleteCriticalSection(FCriticalSec);
{$ENDIF}

  inherited;
end;

function TFreeTaskList.GetCount: Int64;
begin
{$IFNDEF Threading_NoLockFreeStack}
  Result := FInternalList.Count;
{$ELSE}
  EnterCriticalSection(FCriticalSec);
  try
    Result := FInternalList.Count;
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
{$ENDIF}
end;

{ TTask }

constructor TTask.Create(const OnTaskComplete: TOnTaskEvent; const WinHandle: HWND);
begin
  FWorkerThread := TWorkerThread.Create(Self, OnTaskComplete);
  FThreadHandle := FWorkerThread.Handle;
  FValues := AcquireTaskValues;
  FHWND := WinHandle;
end;

destructor TTask.Destroy;
begin
  if FCurrentMessage <> nil then
    FreeAndNil(FCurrentMessage);

  inherited;
end;

function TTask.GetValues: ITaskValues;
begin
  Result := FValues;
end;

function TTask.GetMessage: ITaskValues;
begin
  if FCurrentMessage = nil then
    FCurrentMessage := TMessageObj.Create(TTaskMessage.Create(FName));

  // return current message
  Result := FCurrentMessage.Msg.Values;
end;

function TTask.GetName: string;
begin
  Result := FName;
end;

function TTask.GetTaskMethod: TOnTaskEvent;
begin
  Result := FTaskMethod;
end;

function TTask.GetTerminated: Boolean;
begin
  Result := FWorkerThread.Terminated;
end;

procedure TTask.Run;
begin
  SetEvent(FWorkerThread.WaitEvent);
end;

procedure TTask.SendMessageAsync;
var
  AResult: Boolean;
  TryCount: Integer;
begin
  AResult := False;
  TryCount := 0;

  while not AResult and (TryCount < 3) do
  begin
    AResult := PostMessage(FHWND, WM_TASK_MESSAGE, Integer(Pointer(FCurrentMessage)), 0);
    Inc(TryCount);
  end;

  // check result
  case AResult of
    False: FreeAndNil(FCurrentMessage);
    True: FCurrentMessage := nil;
  end;
end;

procedure TTask.SendMessageSync(const Timeout: Integer);
var
  WParam: Integer;
  AResult: Integer;
  TryCount: Integer;
  Response: {$IF CompilerVersion >= 23}PDWORD_PTR{$ELSE}Cardinal{$IFEND};
begin
  {$IF CompilerVersion >= 23}Response := nil{$ELSE}Response := 0{$IFEND};
  WParam :=  Integer(Pointer(FCurrentMessage));
  TryCount := 0;
  AResult := 1;

  while (AResult <> 0) and (TryCount < 3) do
  begin
    AResult := SendMessageTimeout(FHWND, WM_TASK_MESSAGE, WParam, 0, SMTO_BLOCK, Timeout, Response);
    Inc(TryCount);
  end;

  case (AResult <> 0) of
    False: FreeAndNil(FCurrentMessage);
    True: FCurrentMessage := nil;
  end;
end;

procedure TTask.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TTask.SetTaskMethod(const Value: TOnTaskEvent);
begin
  FTaskMethod := Value;
end;

procedure TTask.Terminate;
begin
  FWorkerThread.Terminate;
  SetEvent(FWorkerThread.WaitEvent);
end;

procedure TTask.WaitFor(const Timeout: Cardinal = INFINITE);
begin
  WaitForSingleObject(FThreadHandle, Timeout);
end;

{ TTaskQueue }

constructor TTaskQueue.Create;
begin
  InitializeCriticalSectionAndSpinCount(FCriticalSec, cCSSpinCount);

  // create nodes
  New(FDeleted);
  New(FHead);

  // set pointer to last
  FDeleted.First := nil;
  FDeleted.Last := nil;
  FDeleted.Count := 0;

  // set pointer to last
  FHead.First := nil;
  FHead.Last := nil;
  FHead.Count := 0;
end;

destructor TTaskQueue.Destroy;
begin
  ClearData(FDeleted);
  ClearData(FHead);
  Dispose(FDeleted);
  Dispose(FHead);

  // delete the critical section last
  DeleteCriticalSection(FCriticalSec);

  inherited;
end;

procedure TTaskQueue.ClearData(const RootItem: PTaskHeadItem);
var
  Item: PTaskQueueItem;
  OldItem: PTaskQueueItem;
begin
  EnterCriticalSection(FCriticalSec);
  try
    Item := RootItem.Last;

    while Item <> nil do
    begin
      OldItem := Item;
      Item := Item.Next;

      CloseHandle(OldItem.Event);
      Dispose(OldItem);
    end;
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
end;

function TTaskQueue.AcquireNewItem: PTaskQueueItem;
begin
  if FDeleted.Last <> nil then
  begin
    Result := FDeleted.Last;
    FDeleted.Last := FDeleted.Last.Next;
    FDeleted.Count := FDeleted.Count - 1;

    if FDeleted.Last = nil then
      FDeleted.First := nil;
  end
  else
  begin
    New(Result);
    Result.Event := CreateEvent(nil, False, False, nil);
  end;

  // next is always nil
  Result.Next := nil;
end;

procedure TTaskQueue.DeleteUnusedItem(const Item: PTaskQueueItem);
begin
  // rewire the first element
  case FDeleted.First <> nil of
    True: FDeleted.First.Next := Item;
    False: FDeleted.Last := Item;
  end;

  // add the item at head
  FDeleted.Count := FDeleted.Count + 1;
  FDeleted.First := Item;
  Item.Next := nil;
end;

function TTaskQueue.EnqueueTask: PTaskQueueItem;
begin
  // acquire new item
  Result := AcquireNewItem;

  EnterCriticalSection(FCriticalSec);
  try
    // rewire the list
    FHead.Count := FHead.Count + 1;

    // rewire the first element
    if FHead.First <> nil then
      FHead.First.Next := Result;

    // Head.First points to new element
    FHead.First := Result;

    if FHead.Last = nil then
    begin
      SetEvent(Result.Event);
      FHead.Last := Result;
    end;
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
end;

procedure TTaskQueue.DequeueTask;
var
  CurrItem: PTaskQueueItem;
  NextItem: PTaskQueueItem;
begin
  EnterCriticalSection(FCriticalSec);
  try
    CurrItem := FHead.Last;
    try
      FHead.Count := FHead.Count - 1;
      NextItem := CurrItem.Next;
      FHead.Last := NextItem;

      if NextItem <> nil then
        // resume the oldest thread
        SetEvent(NextItem.Event)
      else
        FHead.First := nil;
    finally
      DeleteUnusedItem(CurrItem);
    end;
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
end;

function TTaskQueue.GetQueueSize: Integer;
begin
  EnterCriticalSection(FCriticalSec);
  try
    if FHead.First <> nil then
      Result := FHead.Count
    else
      Result := 0;
  finally
    LeaveCriticalSection(FCriticalSec);
  end;
end;

{ TQueueItem }

{$IF CompilerVersion >= 17}
procedure TTaskQueueItem.WaitFor;
begin
  WaitForSingleObject(Event, INFINITE);
end;
{$IFEND}

{ TMessageObj }

constructor TMessageObj.Create(const Msg: ITaskMessage);
begin
  FMessage := Msg;
end;

{ TTaskMessage }

constructor TTaskMessage.Create(const Name: string);
begin
  FName := Name;
  FValues := AcquireTaskValues;
end;

function TTaskMessage.GetName: string;
begin
  Result := FName;
end;

function TTaskMessage.GetValues: ITaskValues;
begin
  Result := FValues;
end;

{$IFNDEF Threading_NoLockFreeStack}

{ TLockFreeStack }

procedure TLockFreeStack.Clear;
begin
  while Count > 0 do
    Pop;
end;

constructor TLockFreeStack.Create(const InitialSize: Integer);
begin
  GetMem(FDeleted, 2 * SizeOf(NativeInt));
  GetMem(FListHead, 2 * SizeOf(NativeInt));

  InitializeSListHead(FDeleted);
  InitializeSListHead(FListHead);
  InitializeDeleteSize(InitialSize);
end;

destructor TLockFreeStack.Destroy;
begin
  DoFinalizeList(FListHead);
  DoFinalizeList(FDeleted);

  inherited;
end;

procedure TLockFreeStack.DoFinalizeList(const ListHead: Pointer);
var
  TempEntry: PStackItem;
  ListEntry: PStackItem;
  FirstEntry: PStackItem;
begin
  ListEntry := nil;
  try
    ListEntry := InterlockedFlushSList(ListHead);
    FirstEntry := InterlockedPopEntrySList(ListHead);
    FreeMem(ListHead);

    if FirstEntry <> nil then
      raise Exception.Create('Error: List was not emptied');
  finally
    // free all leftover items
    while ListEntry <> nil do
    begin
      TempEntry := ListEntry;
      ListEntry := ListEntry.Next;
      TempEntry.Data.Clear;
      FreeMem(TempEntry);
    end;
  end;
end;

function TLockFreeStack.Flush: PStackItem;
begin
  Result := InterlockedFlushSList(FListHead);
end;

function TLockFreeStack.GetCount: Integer;
begin
  Result := QueryDepthSList(FListHead);
end;

procedure TLockFreeStack.InitializeDeleteSize(const InitialSize: Integer);
var
  I: Integer;
  Item : PStackItem;
begin
  for I := 1 to InitialSize do
  begin
    New(Item);
    Item.Next := nil;
    InterlockedPushEntrySList(FDeleted, Item);
  end;
end;

function TLockFreeStack.Pop: TAnyValue;
var
  Item : PStackItem;
begin
  Item := InterlockedPopEntrySList(FListHead);

  if Item = nil then
    Result := TAnyValue.Null
  else
  begin
    Result := Item.Data;

    Item.Data.Clear;
    InterlockedPushEntrySList(FDeleted, Item);
  end;
end;

function TLockFreeStack.Push(const Value: TAnyValue): PStackItem;
var
  Item : PStackItem;
begin
  Item := InterlockedPopEntrySList(FDeleted);

  if Item = nil then
    New(Item);

  Item.Data := Value;
  Result := InterlockedPushEntrySList(FListHead, Item);
end;

{$ENDIF}

{ TThreadSafeQueue }

function TThreadSafeQueue.AcquireNewItem: PQueueItem;
begin
  if not DoDequeue(FDeleted, Result) then
    New(Result);

  // next is always nil
  Result.Next := nil;
  Result.Data.Clear;
end;

procedure TThreadSafeQueue.ClearData(const List: TQueueControl);
var
  Item: PQueueItem;
begin
  while DoDequeue(List, Item) do
  begin
    Item.Data.Clear;
    Dispose(Item);
  end;
end;

constructor TThreadSafeQueue.Create(const InitialSize: Integer);
begin
  FDeleted := TQueueControl.Create;
  FQueue := TQueueControl.Create;

  InitializeCriticalSectionAndSpinCount(FDeleted.CSection, cCSSpinCount);
  InitializeCriticalSectionAndSpinCount(FQueue.CSection, cCSSpinCount);

  // create nodes
  New(FQueue.Head);
  New(FDeleted.Head);

  // set queue pointers
  FQueue.Tail := FQueue.Head;
  FQueue.Head.Next := nil;
  FQueue.Count := 0;

  // set deleted pointers
  FDeleted.Tail := FDeleted.Head;
  FDeleted.Head.Next := nil;
  FDeleted.Count := 0;

  InitializeDeleteSize(InitialSize);
end;

destructor TThreadSafeQueue.Destroy;
begin
  ClearData(FDeleted);
  ClearData(FQueue);

  Dispose(FDeleted.Head);
  Dispose(FQueue.Head);

  // delete the critical sections
  DeleteCriticalSection(FQueue.CSection);
  DeleteCriticalSection(FDeleted.CSection);

  // free the objects
  FreeAndNil(FQueue);
  FreeAndNil(FDeleted);

  inherited;
end;

function TThreadSafeQueue.DoDequeue(const List: TQueueControl; var Item: PQueueItem): Boolean;
begin
  Result := False;

  EnterCriticalSection(List.CSection);
  try
    if List.Count > 0 then
    begin
      Item := List.Head.Next;

      // set head to the next element
      List.Head.Next := Item.Next;
      Dec(List.Count);

      if List.Count = 0 then
        List.Tail := List.Head;

      // success
      Result := True;
    end;
  finally
    LeaveCriticalSection(List.CSection);
  end;
end;

procedure TThreadSafeQueue.DoEnqueue(const List: TQueueControl; const Item: PQueueItem);
begin
  EnterCriticalSection(List.CSection);
  try
    List.Tail.Next := Item;
    List.Tail := Item;
    Inc(List.Count);
  finally
    LeaveCriticalSection(List.CSection);
  end;
end;

function TThreadSafeQueue.Dequeue(var Value: TAnyValue): Boolean;
var
  OldItem: PQueueItem;
begin
  Result := DoDequeue(FQueue, OldItem);

  if Result then
  begin
    Value := OldItem.Data;

    // delete the item
    OldItem.Data.Clear;
    DoEnqueue(FDeleted, OldItem);
  end;
end;

procedure TThreadSafeQueue.Enqueue(const Value: TAnyValue);
var
  NewItem: PQueueItem;
begin
  // acquire new item
  NewItem := AcquireNewItem;
  NewItem.Data := Value;

  DoEnqueue(FQueue, NewItem);
end;

function TThreadSafeQueue.GetCount: Int64;
begin
  EnterCriticalSection(FQueue.CSection);
  try
    Result := FQueue.Count;
  finally
    LeaveCriticalSection(FQueue.CSection);
  end;
end;

procedure TThreadSafeQueue.InitializeDeleteSize(const InitialSize: Integer);
var
  I: Integer;
  Item: PQueueItem;
begin
  for I := 1 to InitialSize do
  begin
    New(Item);
    Item.Data.Clear;
    Item.Next := nil;
    DoEnqueue(FDeleted, Item);
  end;
end;

end.

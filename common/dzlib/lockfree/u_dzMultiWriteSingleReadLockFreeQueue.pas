unit u_dzMultiWriteSingleReadLockFreeQueue;

interface

uses
  Windows,
  SysUtils,
  SyncObjs;

type
  TIntObj = class(TObject)
  public
    Value: Integer;
    constructor Create(_Value: integer);
  end;

type
  _ItemType_ = TIntObj;

type
  TMultiWriteSingleReadLockFreeQueue = class
  private
  {(*}
  type
    TInternalQueue = class
    private
      FReadIdx: integer;
      FWriteIdx: integer;
      FItems: array of _ItemType_;
    public
      constructor Create(_Length: integer);
      function Enqueue(_Item: _ItemType_): boolean;
      function Dequeue(out _Item: _ItemType_): boolean;
    end;
  {*)}
  private
    FWriteQueue: TInternalQueue;
    FReadQueue: TInternalQueue;
    FActiveWriters: integer;
    FActiveWritersZeroEvent: TEvent;
    FLength: integer;
    FQueueChanged: integer;
  public
    constructor Create(_Length: integer);
    destructor Destroy; override;
    function Enqueue(_Item: _ItemType_): boolean;
    function Dequeue(out _Item: _ItemType_): boolean;
    property QueueChanged: integer read FQueueChanged;
  end;

implementation

{ TIntObj }

constructor TIntObj.Create(_Value: integer);
begin
  inherited Create;
  Value := _Value;
end;

{ TInternalQueue }

constructor TMultiWriteSingleReadLockFreeQueue.TInternalQueue.Create(_Length: integer);
begin
  inherited Create;
  SetLength(FItems, _Length);
  FWriteIdx := -1;
  Assert(integer(@FWriteIdx) mod 4 = 0, 'FWriteIdx is not doubleword aligned');
end;

function TMultiWriteSingleReadLockFreeQueue.TInternalQueue.Enqueue(_Item: _ItemType_): boolean;
var
  Idx: integer;
begin
  Assert(Assigned(_Item), 'trying to insert NIL');

  // InterlockedIncrement increments FWriteIdx and returns the
  // new value. Only one thread at a time can execute this function
  // so we can be sure that the returned Idx is unique within all
  // threads that call Enqueue.
  Idx := InterlockedIncrement(FWriteIdx);
  // Here is the catch: We cannot increase the length of the array
  // in a thread safe manner without locking it, so it is possible
  // that Enqueue fails.
  Assert(Idx >= Low(FItems), 'Idx invalid');
  Result := Idx <= High(FItems);
  if Result then begin
    FItems[Idx] := _Item;
    // detect race condition
    Assert(FItems[Idx] = _Item, 'FItems[Idx] has been overwritten');
  end;
end;

function TMultiWriteSingleReadLockFreeQueue.TInternalQueue.Dequeue(out _Item: _ItemType_): boolean;
begin
  // We assume that we are the owner of this instance,
  // all write operations have finished and no more write
  // operations are possible, so we just read until we reach
  // FWriteIdx. No synchronization is necessary.
  Result := (FReadIdx <= FWriteIdx) and (FReadIdx < Length(FItems));
  if Result then begin
    _Item := FItems[FReadIdx];
    Inc(FReadIdx);
  end;
end;

{ TMultiWriteSingleReadLockFreeQueue }

constructor TMultiWriteSingleReadLockFreeQueue.Create(_Length: integer);
begin
  inherited Create;
  FActiveWritersZeroEvent := TEvent.Create;
  FLength := _Length;
  FWriteQueue := TInternalQueue.Create(_Length);
  FReadQueue := nil;
  Assert(integer(@FWriteQueue) mod 4 = 0, 'FWriteQueue is not doubleword aligned');
end;

destructor TMultiWriteSingleReadLockFreeQueue.Destroy;
var
  Item: _ItemType_;
begin
  // If you get any unexplicable access violations or invalid pointer exceptions
  // in the reader thread, check, whether you are freeing the queue while the
  // reader is still running.
  while Dequeue(Item) do
    Item.Free;
  FReadQueue.Free;
  FWriteQueue.Free;
  FActiveWritersZeroEvent.Free;
  inherited;
end;

function TMultiWriteSingleReadLockFreeQueue.Enqueue(_Item: _ItemType_): boolean;
var
  Queue: TInternalQueue;
begin
  // this is the simple case: The WriteQueue can be written to
  // by any number of threads in parallel, no locking is required
  // In addition we count the number of threads that are executing
  // this method and therefore hold a reference to the WriteQueue.
  // This is so the reader thread knows when it can safely
  // use its copy.
  InterlockedIncrement(FActiveWriters);
  try
    // First, we get our local reference of the WriteQueue,
    // this is probably not necessary but just to be sure.
    Queue := FWriteQueue;
    // Then we enqueue our item to it
    Result := Queue.Enqueue(_Item);
  finally
    // decrement the ActiveWriters, if we reach zero,
    // notify the reading thread that it now owns he
    // reading queue, in case it is waiting for it.
    if InterlockedDecrement(FActiveWriters) = 0 then
      FActiveWritersZeroEvent.SetEvent;
  end;
end;

function TMultiWriteSingleReadLockFreeQueue.Dequeue(out _Item: _ItemType_): boolean;
begin
  if not Assigned(FReadQueue) then begin
    // we create a new queue for all the writer threads to use
    // and assign it as the new WriteQueue, the old one is assigned
    // to ReadQueue. Since writing a doubleword aligned 32 bit integer
    // is an atomic operation, we don't need InterlockedExchange here.
    FReadQueue := FWriteQueue;
    FWriteQueue := TInternalQueue.Create(FLength);
    Inc(FQueueChanged);

    // Unfortunately it is possible that other threads still hold a
    // reference to the old queue.
    // To be 100% sure we need to wait until the ActiveWriters count
    // drops to 0 (once is enough, because all new calls to Enqueue
    // will use the new WriteQueue)
    // We reset the event, just in case we need it
    FActiveWritersZeroEvent.ResetEvent;
    // If there currently are writers, we wait for the event
    // which will be set by the first writer that decrements
    // ActiveWriters to 0. If there aren't, no need to wait.
    if FActiveWriters <> 0 then
      FActiveWritersZeroEvent.WaitFor(INFINITE);
  end;

  // OK, now we own the read queue, just Dequeue from it
  Result := FReadQueue.Dequeue(_Item);
  // If the ReadQueue is empty, free it
  { TODO -otwm -ccheck : 
    Maybe keep the queue around for using it as the next "new" queue?
    Could save a bit on memory allocation overhead. }
  if not Result then
    FreeAndNil(FReadQueue);
end;

end.


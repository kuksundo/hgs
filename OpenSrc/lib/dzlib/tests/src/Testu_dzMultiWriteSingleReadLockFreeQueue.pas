unit Testu_dzMultiWriteSingleReadLockFreeQueue;

interface

uses
  Windows,
  Classes,
  SysUtils,
  Forms,
  TestFramework,
  u_dzUnitTestUtils,
  u_dzNamedThread,
  u_dzMultiWriteSingleReadLockFreeQueue;

const
  PRODUCER_COUNT = 100;
  ENTRIES_PER_PRODUCER = 1000;

type
  TConsumerThread = class(TNamedThread)
  private
    FQueue: TMultiWriteSingleReadLockFreeQueue;
    FFound: array[0..PRODUCER_COUNT * ENTRIES_PER_PRODUCER - 1] of boolean;
    FDupes: integer;
    FExceptions: integer;
    FOutOfRange: integer;
    function GetMissingValues: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(_Queue: TMultiWriteSingleReadLockFreeQueue);
    property Dupes: integer read FDupes;
    property OutOfRange: integer read FOutOfRange;
    property MissingValues: integer read GetMissingValues;
    property Exceptions: integer read FExceptions;
  end;

type
  TProducerThread = class(TNamedThread)
  private
    FQueue: TMultiWriteSingleReadLockFreeQueue;
    FFrom: integer;
    FCount: integer;
    FFinished: boolean;
    FEnqueueFailures: Integer;
    FEnqueueErrors: Integer;
  protected
    procedure SetName(const _Name: string); override;
    procedure Execute; override;
  public
    constructor Create(_Queue: TMultiWriteSingleReadLockFreeQueue; _From, _Count: integer);
    property Finished: boolean read FFinished;
    property EnqueueFailures: Integer read FEnqueueFailures;
    property EnqueueErrors: Integer read FEnqueueErrors;
  end;

type
  TestTMultiWriteSingleReadLockFreeQueue = class(TdzTestCase)
  private
    FQueue: TMultiWriteSingleReadLockFreeQueue;
    FProducers: array[0..PRODUCER_COUNT - 1] of TProducerThread;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Test1;
  end;

implementation

{ TConsumerThread }

constructor TConsumerThread.Create(_Queue: TMultiWriteSingleReadLockFreeQueue);
begin
  inherited Create(True);
  FQueue := _Queue;
  Resume;
end;

procedure TConsumerThread.Execute;
var
  Item: TIntObj;
begin
  inherited;
  while not Terminated do begin
    try
      while FQueue.Dequeue(Item) do begin
        if (Item.Value < Low(FFound)) or (Item.Value > High(FFound)) then
          Inc(FOutOfRange)
        else if FFound[Item.Value] then
          Inc(FDupes)
        else
          FFound[Item.Value] := True;
        Item.Free;
      end;
    except
      Inc(FExceptions);
//      raise;
    end;
  end;

  try
    while FQueue.Dequeue(Item) do begin
      if (Item.Value < Low(FFound)) or (Item.Value > High(FFound)) then
        Inc(FOutOfRange)
      else if FFound[Item.Value] then
        Inc(FDupes)
      else
        FFound[Item.Value] := True;
      Item.Free;
    end;
  except
    Inc(FExceptions);
//      raise;
  end;
end;

function TConsumerThread.GetMissingValues: integer;
var
  i: integer;
begin
  Result := 0;
  for i := low(FFound) to High(FFound) do
    if not FFound[i] then
      Inc(Result);
end;

{ TProducerThread }

constructor TProducerThread.Create(_Queue: TMultiWriteSingleReadLockFreeQueue; _From, _Count: integer);
begin
  inherited Create(True);
  FQueue := _Queue;
  FFrom := _From;
  FCount := _Count;
  Resume;
end;

procedure TProducerThread.Execute;

var
  i: Integer;
  Item: TIntObj;
begin
  inherited;
  for i := FFrom to FFrom + FCount - 1 do begin
    Item := TIntObj.Create(i);
    while not FQueue.Enqueue(Item) do begin
      Sleep(0);
    end;
  end;
  FFinished := True;
end;

procedure TProducerThread.SetName(const _Name: string);
begin
  inherited SetName(ClassName + IntToStr(FFrom));
end;

{ TestTMultiWriteSingleReadLockFreeQueue }

procedure TestTMultiWriteSingleReadLockFreeQueue.SetUp;
begin
  FQueue := TMultiWriteSingleReadLockFreeQueue.Create((PRODUCER_COUNT * ENTRIES_PER_PRODUCER) div 10);
end;

procedure TestTMultiWriteSingleReadLockFreeQueue.TearDown;
begin
  FQueue.Free;
  FQueue := nil;
end;

procedure TestTMultiWriteSingleReadLockFreeQueue.Test1;
var
  Consumer: TConsumerThread;
  i: Integer;
  Running: boolean;
begin
  Consumer := TConsumerThread.Create(FQueue);
  try
    try
      for i := Low(FProducers) to High(FProducers) do begin
        FProducers[i] := TProducerThread.Create(FQueue,
          i * ENTRIES_PER_PRODUCER, ENTRIES_PER_PRODUCER);
      end;

      Running := True;
      while Running do begin
        Running := false;
        for i := Low(FProducers) to High(FProducers) do begin
          if not FProducers[i].Finished then begin
            Running := true;
            Sleep(10);
            Application.ProcessMessages;
            break;
          end;
        end;
      end;

      for i := Low(FProducers) to High(FProducers) do begin
        CheckEquals(0, FProducers[i].EnqueueErrors, 'EnqueueErrors[' + IntToStr(i) + ']');
      end;
      for i := Low(FProducers) to High(FProducers) do begin
        CheckEquals(0, FProducers[i].EnqueueFailures, 'EnqueueFailures[' + IntToStr(i) + ']');
      end;

    finally
      Consumer.Terminate;
      Consumer.WaitFor;
    end;

    CheckEquals(0, Consumer.Exceptions, 'Exceptions');
    CheckEquals(0, Consumer.OutOfRange, 'OutOfRange');
    CheckEquals(0, Consumer.Dupes, 'Dupes');
    for i := 0 to Length(Consumer.FFound) - 1 do
      CheckTrue(Consumer.FFound[i], 'Found[' + IntToStr(i) + ']');
    CheckEquals(0, Consumer.MissingValues, 'MissingValues');
  finally
    Consumer.Free;
    for i := Low(FProducers) to High(FProducers) do
      FProducers[i].Free;
  end;

  Check(FQueue.QueueChanged > 1, 'QueueChanged > 1');
end;

initialization
  RegisterTest(TestTMultiWriteSingleReadLockFreeQueue.Suite);
end.


unit AsyncCallsHelper;

interface

uses AsyncCalls;

type
  TIAsyncCallArray = array of IAsyncCall;
  TIAsyncCallArrays = array of TIAsyncCallArray;

  TAsyncCallsHelper = class
  strict private
    const
    MAX_WaitTasks = -1 + MAXIMUM_ASYNC_WAIT_OBJECTS;

    var
    mTaskIndex, cTaskIndex : integer;

    procedure AddTasksArray;
    procedure ClearAndNilTasks;
    procedure InitZeroArray;
  private
    fTasks : TIAsyncCallArrays;
    fTaskCount : integer;

    function GetMaxThreads: integer;
    procedure SetMaxThreads(const Value: integer);

    property Tasks : TIAsyncCallArrays read fTasks;
  public
    constructor Create;
    destructor Destroy; override;

    property MaxThreads : integer read GetMaxThreads write SetMaxThreads;
    property TaskCount : integer read fTaskCount;
    procedure AddTask(const call : IAsyncCall);
    procedure WaitAll;
    procedure CancelAll;
    function AllFinished : boolean;
  end;

var
  asyncHelper : TAsyncCallsHelper;

implementation

{ TAsyncCallsHelper }

procedure TAsyncCallsHelper.AddTask(const call: IAsyncCall);
begin
  if cTaskIndex = MAX_WaitTasks then
  begin
    Inc(mTaskIndex);

    AddTasksArray;

    cTaskIndex := 0;

    Tasks[High(Tasks)][cTaskIndex] := call;
  end
  else
  begin
    Tasks[mTaskIndex][cTaskIndex] := call;
    Inc(cTaskIndex);
  end;

  Inc(fTaskCount);
end;

procedure TAsyncCallsHelper.AddTasksArray;
begin
  SetLength(fTasks, 1 + Length(Tasks));
  SetLength(Tasks[High(Tasks)], MAX_WaitTasks);
end;

function TAsyncCallsHelper.AllFinished: boolean;
var
  i,j  : integer;
begin
  result := true;

  for i := High(Tasks) downto Low(Tasks) do
  begin
    for j := High(Tasks[i]) downto Low(Tasks[i]) do
    begin
      if Assigned(Tasks[i][j]) then result := result AND Tasks[i][j].Finished;
      if NOT result then Exit;
    end;
  end;
end;

procedure TAsyncCallsHelper.CancelAll;
var
  i,j  : integer;
begin
  for i := High(Tasks) downto Low(Tasks) do
  begin
    for j := High(Tasks[i]) downto Low(Tasks[i]) do
    begin
      if Assigned(Tasks[i][j]) AND NOT (Tasks[i][j].Finished) then Tasks[i][j].Cancel;
    end;
  end;

  WaitAll;

  ClearAndNilTasks;
  InitZeroArray;
end;

procedure TAsyncCallsHelper.ClearAndNilTasks;
var
  i : integer;
begin
  for i := Low(fTasks) to High(fTasks) do fTasks[i] := nil;
  fTasks := nil;
end;

constructor TAsyncCallsHelper.Create;
begin
  inherited Create;

  MaxThreads := 2 * System.CPUCount;

  InitZeroArray;
end;

destructor TAsyncCallsHelper.Destroy;
begin
  CancelAll;

  ClearAndNilTasks;

  inherited;
end;

function TAsyncCallsHelper.GetMaxThreads: integer;
begin
  result := AsyncCalls.GetMaxAsyncCallThreads;
end;

procedure TAsyncCallsHelper.InitZeroArray;
begin
  fTaskCount := 0;
  mTaskIndex := 0;
  cTaskIndex := 0;

  AddTasksArray;
end;

procedure TAsyncCallsHelper.SetMaxThreads(const Value: integer);
begin
  AsyncCalls.SetMaxAsyncCallThreads(Value);
end;

procedure TAsyncCallsHelper.WaitAll;
var
  i : integer;
begin
  for i := High(Tasks) downto Low(Tasks) do
  begin
    AsyncCalls.AsyncMultiSync(Tasks[i]);
  end;

  ClearAndNilTasks;
  InitZeroArray;
end;

initialization
  asyncHelper := TAsyncCallsHelper.Create;

finalization
  asyncHelper.Free;
  asyncHelper := nil;

end.

program SharedMemProducer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  IPC.SharedMem in 'IPC.SharedMem.pas',
  IPC.Events in 'IPC.Events.pas',
  CommonData in 'CommonData.pas';

procedure RunProducer;
type
  SharedMemoryData = SharedMemory<TData>;
var
  sharedData: SharedMemoryData;
  data: SharedMemoryData.Ptr;
  consumeEvent, produceEvent: Event;
  v1, v2: integer;
begin
  sharedData := SharedMemoryData.Create(SHARED_DATA_NAME, SharedMemoryAccessReadWrite);
  consumeEvent := Event.Create(CONSUME_EVENT_NAME);
  produceEvent := Event.Create(PRODUCE_EVENT_NAME);

  while True do
  begin
    produceEvent.WaitForSignal();

    try
      data := sharedData.BeginAccess;

      // check if other program quit, if so we do too
      if (sharedData.Abandoned) then
        exit;

      WriteLn('Enter two numbers:');
      ReadLn(v1, v2);

      data^.Value1 := v1;
      data^.Value2 := v2;
      data^.HasInput := True;

      // signal the output process that
      // the data is ready
      consumeEvent.Signal;
    finally
      sharedData.EndAccess;
    end;
  end;
end;


begin
  try
    RunProducer;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  WriteLn('Press any key');
  ReadLn;
end.

program SharedMemConsumer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  IPC.SharedMem in 'IPC.SharedMem.pas',
  IPC.Events in 'IPC.Events.pas',
  CommonData in 'CommonData.pas';

procedure RunConsumer;
type
  SharedMemoryData = SharedMemory<TData>;
var
  sharedData: SharedMemoryData;
  data: SharedMemoryData.Ptr;
  consumeEvent, produceEvent: Event;
begin
  sharedData := SharedMemoryData.Create(SHARED_DATA_NAME, SharedMemoryAccessReadWrite);
  consumeEvent := Event.Create(CONSUME_EVENT_NAME);
  produceEvent := Event.Create(PRODUCE_EVENT_NAME);

  while True do
  begin
    // signal producer process that
    // we require data
    produceEvent.Signal;

    // wait for it to deliver
    consumeEvent.WaitForSignal();

    try
      data := sharedData.BeginAccess;

      // check if other program quit, if so we do too
      if (sharedData.Abandoned) then
        exit;

      if (data^.HasInput) then
      begin
        data^.HasInput := False;
        WriteLn(Format('%d + %d = %d', [data^.Value1, data^.Value2, (data^.Value1 + data^.Value2)]));
        WriteLn;
      end;
    finally
      sharedData.EndAccess;
    end;
  end;
end;

begin
  try
    RunConsumer;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  WriteLn('Press any key');
  ReadLn;
end.

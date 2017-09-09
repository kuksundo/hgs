program multisocket_poller;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4,
  SysUtils, ZeroMQ;

var
  Z: IZeroMQ;
  Receiver, Subscriber: IZMQPair;
  Poll: IZMQPoll;

procedure ReceiverProc(Event: PollEvents);
var
  S: string;
begin
  if PollEvent_PollIn in Event then
  begin
    S := Receiver.ReceiveString;
    WriteLn('Receiver ! (', S, ')');
    Sleep(StrToInt(S));
  end;
end;

procedure SubscriberProc(Event: PollEvents);
begin
  if PollEvent_PollIn in Event then
    WriteLn('Subscriber ! (', Subscriber.ReceiveString, ')');
end;

procedure Run;
begin
  Z := TZeroMQ.Create;
  Receiver := Z.Start(ZMQSocket_Pull);
  Receiver.Connect('tcp://localhost:5557');

  Subscriber := Z.Start(ZMQSocket_Subscriber);
  Subscriber.Connect('tcp://localhost:5556');
  Subscriber.Subscribe('10001 ');

  Poll := Z.Poller;

  Poll.RegisterPair(Receiver, [PollEvent_PollIn], ReceiverProc
  );

  Poll.RegisterPair(Subscriber, [PollEvent_PollIn], SubscriberProc
  );

  while True do
    if Poll.PollOnce > 0 then
      Poll.FireEvents;
end;

begin
  try
    Run;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

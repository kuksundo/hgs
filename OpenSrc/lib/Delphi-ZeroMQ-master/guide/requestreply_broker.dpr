program requestreply_broker;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4,
  SysUtils, ZeroMQ;

var
  Z: IZeroMQ;
  Frontend, Backend: IZMQPair;
  Poller: IZMQPoll;

procedure FrontendProc(Event: PollEvents);
begin
  if PollEvent_PollIn in Event then
    Frontend.ForwardMessage(Backend);
end;

procedure BackendProc(Event: PollEvents);
begin
  if PollEvent_PollIn in Event then
    Backend.ForwardMessage(Frontend);
end;

procedure Run;
begin
  Z := TZeroMQ.Create;

  Frontend := Z.Start(ZMQSocket_Router);
  Frontend.Bind('tcp://*:5559');

  Backend := Z.Start(ZMQSocket_Dealer);
  Backend.Bind('tcp://*:5560');

  Poller := Z.Poller;

  Poller.RegisterPair(Frontend, [PollEvent_PollIn], FrontendProc
  );

  Poller.RegisterPair(Backend, [PollEvent_PollIn], BackendProc
  );

  while True do
    if Poller.PollOnce > 0 then
      Poller.FireEvents;
end;

begin
  try
    Run;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

program ppqueue;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, zmqapi;

const
  HEARTBEAT_LIVENESS = 3;       //  3-5 is reasonable
  HEARTBEAT_INTERVAL = 1000;    //  msecs
  //  Paranoid Pirate Protocol constants
  PPP_READY = '\001';      //  Signals worker is ready
  PPP_HEARTBEAT = '\002';      //  Signals worker heartbeat

type
  TWorker_t = class
    FIdentity : string;
    FExpiry : NativeInt;
  end;

procedure Run;
var
  ctx: TZMQContext;
  frontend,
  backend: TZMQSocket;
  workers: TZMQMsg;
  poller: TZMQPoller;
  pc: Integer;
  msg: TZMQMsg;
  identity,
  frame: TZMQFrame;
  Heartbeat_at: NativeInt;
begin
  ctx := TZMQContext.create;
  frontend := ctx.Socket( stRouter );
  backend := ctx.Socket( stRouter );
  frontend.bind( 'tcp://*:5555' );    //  For clients
  backend.bind( 'tcp://*:5556' );    //  For workers

  //  Queue of available workers
  workers := TZMQMsg.create;

  poller := TZMQPoller.Create( true );
  poller.Register( backend, [pePollIn] );
  poller.Register( frontend, [pePollIn] );

  //  Send out heartbeats at regular intervals
  Heartbeat_at := now + HEARTBEAT_INTERVAL;

  while not ctx.Terminated do
  try
    //  Poll frontend only if we have available workers
    if workers.size > 0 then
      pc := 2
    else
      pc := 1;

    pc := poller.poll( 1000, pc );

    if pc = -1 then
      break;  //  Interrupted

    //  Handle worker activity on backend
    if pePollIn in poller.PollItem[0].revents then
    begin
      //  Use worker identity for load-balancing
      backend.recv( msg );
      identity := msg.unwrap; //pop msgframe
      workers.add( identity );

      //  Forward message to client if it's not a READY
      frame := msg.first;
      if frame.asUtf8String = WORKER_READY then
      begin
        msg.Free;
        msg := nil;
      end else
        frontend.send( msg );
    end;

    if pePollIn in poller.PollItem[1].revents then
    begin
      //  Get client request, route to first available worker
      frontend.recv( msg );
      msg.wrap( workers.pop );
      backend.send( msg );
    end;
  except
  end;

  workers.Free;
  ctx.Free;

end;

begin

  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

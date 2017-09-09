program ppqueue;
//
//  Paranoid Pirate queue
//  @author Varga Bal?s <bb.varga@gmail.com>
//
{$APPTYPE CONSOLE}

uses
    SysUtils
  , Classes
  , zmqapi
  , zhelpers
  ;

const
  HEARTBEAT_LIVENESS = 3;       //  3-5 is reasonable
  HEARTBEAT_INTERVAL = 1000;    //  msecs

//  Paranoid Pirate Protocol constants
  PPP_READY =      '\001';      //  Signals worker is ready
  PPP_HEARTBEAT =  '\002';      //  Signals worker heartbeat

//  Here we define the worker class; a structure and a set of functions that
//  as constructor, destructor, and methods on worker objects:
type
  TWorker = class
    fIdentity: TZMQFrame;       //  Identity of worker
    fId: Utf8String;     //  Printable identity
    fExpiry: Int64;             //  Expires at this time
  public
    //  Construct new worker
    constructor Create( lIdentity: TZMQFrame );
    //  Destroy specified worker object, including identity frame.
    destructor Destroy; override;
    //  The ready method puts a worker to the end of the ready list:
    class procedure Ready( worker: TWorker; workers: TList );
    //  The next method returns the next available worker identity:
    class function Next( workers: TList ): TZMQFrame;
    //  The purge method looks for and kills expired workers. We hold workers
    //  from oldest to most recent, so we stop at the first alive worker:
    class procedure Purge( workers: TList );

    property Identity: TZMQFrame read fIdentity;
    property Id: Utf8String read fId;
    property Expiry: Int64 read fExpiry;

  end;

constructor TWorker.Create( lIdentity: TZMQFrame );
begin
  fIdentity := lIdentity;
  fId := fIdentity.dump;

  fExpiry := zIncTimeMs( zTimeStamp, HEARTBEAT_INTERVAL * HEARTBEAT_LIVENESS );
end;

destructor TWorker.Destroy;
begin
  if fIdentity <> nil then
    Identity.Free;
  inherited;
end;

class procedure TWorker.Ready(worker: TWorker; workers: TList);
var
  i: Integer;
begin
  i := 0;
  while ( i < workers.Count ) and
    ( TWorker(workers[i]).Id <> worker.Id ) do inc( i );
  if i < workers.Count then
  begin
    TWorker(workers[i]).Free;
    workers.Delete( i );
  end;
  workers.add( worker );
end;

class function TWorker.Next( workers: TList ): TZMQFrame;
var
  worker: TWorker;
begin
  if workers.Count > 0 then
  begin
    worker := workers[0];
    workers.Delete(0);
    result := worker.Identity;
    worker.fIdentity := nil;
    worker.Free;
  end else
    result := nil;
end;

class procedure TWorker.Purge(workers: TList);
var
  worker: TWorker;
begin
  while ( workers.Count > 0 ) do
  begin
    worker := workers[0];
    if zTimeStamp < worker.Expiry then
      break; //  Worker is alive, we're done here
    worker.Free;
    workers.Delete(0);
  end;
end;

//  The main task is a load-balancer with heartbeating on workers so we
//  can detect crashed or blocked worker tasks:
var
  ctx: TZMQContext;
  frontend,
  backend: TZMQSocket;
  workers: TList;
  heartbeat_at: Int64;
  poller: TZMQPoller;
  pc,i: Integer;
  msg: TZMQMsg;
  identity,
  frame: TZMQFrame;
  worker: TWorker;
begin
  ctx := TZMQContext.Create;
  frontend := ctx.Socket( stRouter );
  backend := ctx.Socket( stRouter );
  frontend.bind( 'tcp://*:5555' ); // For clients
  backend.bind( 'tcp://*:5556' ); // For workers

  //  List of available workers
  workers := TList.Create;

  //  Send out heartbeats at regular intervals
  heartbeat_at := zIncTimeMs( zTimeStamp, HEARTBEAT_INTERVAL );

  poller := TZMQPoller.Create( true );
  poller.Register( backend, [pePollIn] );
  poller.Register( frontend, [pePollIn] );

  msg := nil;
  while not ctx.Terminated do
  try
    //  Poll frontend only if we have available workers
    if workers.Count > 0 then
      pc := 2
    else
      pc := 1;

    poller.poll( HEARTBEAT_INTERVAL, pc );

    //  Handle worker activity on backend
    if pePollIn in poller.PollItem[0].revents then
    begin
      //  Use worker identity for load-balancing
      backend.recv( msg );

      //  Any sign of life from worker means it's ready
      identity := msg.unwrap;
      worker := TWorker.Create( identity );
      Tworker.Ready( worker, workers );

      //  Validate control message, or return reply to client
      if msg.size = 1 then
      begin
        frame := msg.first;

        if ( frame.asUtf8String <> PPP_READY ) and
          ( frame.asUtf8String <> PPP_HEARTBEAT ) then
        begin
          writeln( 'E: invalid message from worker' );
          writeln( frame.dump );
        end;
        FreeAndNil( msg );
      end else
        frontend.send( msg );
    end;

    if pePollIn in poller.PollItem[1].revents then
    begin
      //  Now get next client request, route to next worker
      frontend.recv( msg );
      msg.push( Tworker.Next( workers ) );
      backend.send( msg );
    end;

    //  We handle heartbeating after any socket activity. First we send
    //  heartbeats to any idle workers if it's time. Then we purge any
    //  dead workers:
    if zTimeStamp >= heartbeat_at then
    begin
      i := 0;
      while i < workers.Count do
      begin
        worker := workers[i];
        frame := worker.Identity.dup;
        backend.send( frame, [sfSndMore] );
        backend.send( PPP_HEARTBEAT );
        inc( i );
      end;
      heartbeat_at := zIncTimeMs( zTimeStamp, HEARTBEAT_INTERVAL );
    end;
    TWorker.Purge( workers );
  except
  end;

  //  When we're done, clean up properly
  for i := 0 to workers.Count - 1 do
    TWorker(workers[i]).Free;
  workers.Free;
  ctx.Free;
end.

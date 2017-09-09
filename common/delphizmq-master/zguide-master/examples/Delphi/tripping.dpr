program tripping;
//
//  Round-trip demonstrator
//
//  While this example runs in a single process, that is just to make
//  it easier to start and stop the example. The client task signals to
//  main when it's ready.
//  @author Varga Balázs <bb.varga@gmail.com>
//

{$APPTYPE CONSOLE}

uses
    SysUtils
  , zmqapi
  , zhelpers
  ;

procedure client_task( args: Pointer; Context: TZMQContext; Pipe: TZMQSocket );
var
  client: TZMQSocket;
  i,c: Integer;
  start: Int64;
  s: Utf8String;
begin
  try
  client := Context.Socket( stDealer );
  client.SndHWM := 100000;
  client.RcvHWM := 100000;
  client.connect( 'tcp://localhost:5555' );
  zNote( 'Setting up test...' );
  sleep( 100 );

  zNote( 'Synchronous round-trip test...' );
  c := 1000;
  start := zTimeStamp;
  for i := 1 to c do
  begin
    client.send( 'hello' );
    client.recv( s );
  end;
  zNote( Format( ' %f calls/second', [ 1000 * c / ( zCalcTimeMs( start, zTimeStamp ) ) ] ) );

  zNote( 'Asynchronous round-trip test...' );
  start := zTimeStamp;
  c := 10000;
  for i := 1 to c do
    client.send( 'hello' );
  for i := 1 to c do
    client.recv( s );

  zNote( Format( ' %f calls/second', [ 1000 * c / ( zCalcTimeMs( start, zTimeStamp ) ) ] ) );

  pipe.send( 'done' );
  except
    zNote('client terminated');
  end;
end;

//  Here is the worker task. All it does is receive a message, and
//  bounce it back the way it came:
procedure worker_task( args: Pointer; context: TZMQContext );
var
  worker: TZMQSocket;
  msg: TZMQMsg;
begin
  worker := Context.Socket( stDealer );
  worker.connect( 'tcp://localhost:5556' );
  msg := nil;
  while not context.Terminated do
  try
    worker.recv( msg );
    worker.send( msg );
  except
    zNote('worker terminated');
  end;
end;

//  Here is the broker task. It uses the zmq_proxy function to switch
//  messages between frontend and backend:
procedure broker_task( args: Pointer; context: TZMQContext );
var
  frontend,
  backend: TZMQSocket;
begin
  //  Prepare our context and sockets
  try
    frontend := context.Socket( stDealer );
    frontend.bind( 'tcp://*:5555' );
    backend := context.Socket( stDealer );
    backend.bind( 'tcp://*:5556' );
    ZMQProxy( frontend, backend, nil );
  except
    zNote('broker terminated');
  end;
end;

//  Finally, here's the main task, which starts the client, worker, and
//  broker, and then runs until the client signals it to stop:
var
  context: TZMQContext;
  client,
  worker,
  broker: TZMQThread;
  s: Utf8String;
begin
  //  Create threads
  context := TZMQContext.create;
  client := TZMQThread.CreateAttachedProc( client_task, context, nil );
  client.FreeOnTerminate := true;
  client.Resume;

  worker := TZMQThread.CreateDetachedProc( worker_task, nil );
  worker.FreeOnTerminate := true;
  worker.Resume;
  
  broker := TZMQThread.CreateDetachedProc( broker_task, nil );
  broker.FreeOnTerminate := true;
  broker.Resume;

  //  Wait for signal on client pipe
  try
    client.Pipe.recv( s );
  except
    zNote('main terminated');
  end;
  client.Free;
  sleep(1000);
  context.Free;
end.


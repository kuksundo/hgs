program mdbroker;
//
//  Majordomo Protocol broker
//  A minimal implementation of the Majordomo Protocol as defined in
//  http://rfc.zeromq.org/spec:7 and http://rfc.zeromq.org/spec:8.
//  @author Varga Bal?s <bb.varga@gmail.com>
//
{$APPTYPE CONSOLE}

uses
    SysUtils
  , Classes
  , StrUtils
  , zmq
  , zmqapi
  , mdp
  , zhelpers
  ;

//  We'd normally pull these from config data
const
  HEARTBEAT_LIVENESS = 3;       //  3-5 is reasonable
  HEARTBEAT_INTERVAL = 2500;    //  msecs
  HEARTBEAT_EXPIRY = HEARTBEAT_INTERVAL * HEARTBEAT_LIVENESS;

type
  TBroker = class
  private
    ctx: TZMQContext;                //  Our context
    Socket: TZMQSocket;              //  Socket for clients & workers
    Verbose: Boolean;                //  Print activity to stdout
    Endpoint: AnsiString;             //  Broker binds to this endpoint
    Services: TStringList;          //  Hash of known services
    Workers: TStringList;           //  Hash of known workers
    Waiting: TList;           //  List of waiting workers
    Heartbeat_at: Int64;      //  When to send HEARTBEAT

    procedure WorkerMsg( sender: TZMQFrame; msg: TZMQMsg );
    procedure ClientMsg( sender: TZMQFrame; msg: TZMQMsg );

  public
    constructor Create( lVerbose: Boolean );
    destructor Destroy; override;

    procedure Bind( lEndpoint: AnsiString );
    procedure Purge;
  end;

  //  The service class defines a single service instance:
  TService = class
  private
    broker: TBroker;           //  Broker instance
    name: Utf8String;                 //  Service name
    requests: TList;          //  List of client requests
    waiting: TList;           //  List of waiting workers
    workers: size_t;             //  How many workers we have
  public
    class function Require( lBroker: TBroker; serviceFrame: TZMQFrame ): TService;
    destructor Destroy; override; // (void *argument);
    procedure DispatchMsg( msg: TZMQMsg );
  end;

  //  The worker class defines a single worker, idle or active:
  TWorker = class
  private
    broker: TBroker;           //  Broker instance
    id_string: Utf8String;            //  Identity of worker as string
    identity: TZMQFrame;         //  Identity frame for routing
    service: TService;         //  Owning service, if known
    expiry: Int64;             //  Expires at unless heartbeat
  public
    class function Require( lBroker: TBroker; identity: TZMQFrame ): TWorker;
    destructor Destroy; override; // (void *argument);

    procedure Delete( disconnect: Boolean );
    procedure Send( command: AnsiChar; option: Utf8String; lmsg: TZMQMsg );
    procedure waiting;
  end;

//  Here are the constructor and destructor for the broker:
constructor TBroker.Create( lVerbose: Boolean );
begin
  //  Initialize broker state
  ctx := TZMQContext.create ();
  Socket := ctx.Socket( stRouter );
  Verbose := lVerbose;
  services := TStringList.Create;
  workers := TStringList.Create;
  waiting := TList.create;
  heartbeat_at := zIncTimeMs( zTimeStamp, HEARTBEAT_INTERVAL );
end;

destructor TBroker.Destroy;
begin
  ctx.Free;
  services.Free;
  workers.Free;
  waiting.Free;
end;

//  The bind method binds the broker instance to an endpoint. We can call
//  this multiple times. Note that MDP uses a single socket for both clients
//  and workers:

procedure TBroker.Bind( lEndpoint: AnsiString );
begin
  Endpoint := lEndpoint;
  socket.bind( Endpoint );
  zNote( Format( 'I: MDP broker/0.2.0 is active at %s', [ endpoint ] ) );
end;

//  The worker_msg method processes one READY, REPLY, HEARTBEAT or
//  DISCONNECT message sent to the broker by a worker:
procedure TBroker.WorkerMsg( sender: TZMQFrame; msg: TZMQMsg );
var
  command,
  service_frame,
  client: TZMQFrame;
  id_string: Utf8String;
  worker: TWorker;
  worker_ready: Boolean;
begin
  assert ( msg.size >= 1 );     //  At least, command

  command := msg.pop;
  id_string := sender.asHexString;

  worker_ready := workers.IndexOf( id_string ) > -1;
  worker := TWorker.Require( self, sender );

  if command.asUtf8String = MDPW_READY then
  begin
    if worker_ready then               //  Not first command in session
      worker.delete( true )
    else

    if ( sender.size >= 4 ) and //  Reserved service name
       AnsiStartsStr( 'mmi.', sender.asUtf8String ) then
      worker.Delete( true )

    else begin
      //  Attach worker to service and mark as idle
      service_frame := msg.pop;
      worker.service := TService.Require( self, service_frame );
      Inc( worker.service.workers );
      worker.waiting;
      service_frame.Free;
    end;
  end else

  if command.asUtf8String = MDPW_REPLY then
  begin
    if worker_ready then
    begin
      //  Remove & save client return envelope and insert the
      //  protocol header and service name, then rewrap envelope.
      client := msg.unwrap;
      msg.pushstr( worker.service.name );
      msg.pushstr( MDPC_CLIENT );
      msg.wrap( client );
      socket.send( msg );
      worker.waiting;
    end else
      worker.Delete( true );
  end else

  if command.asUtf8String = MDPW_HEARTBEAT then
  begin
    if worker_ready then
      worker.expiry := zIncTimeMs( zTimeStamp, HEARTBEAT_EXPIRY )
    else
      worker.Delete( true );
  end else

  if command.asUtf8String = MDPW_DISCONNECT then
    worker.Delete( false )

  else begin
    zNote( 'E: invalid input message' );
    zNote( msg.dump );
  end;

  command.Free;
  msg.Free
end;

//  Process a request coming from a client. We implement MMI requests
//  directly here (at present, we implement only the mmi.service request):

procedure TBroker.ClientMsg( sender: TZMQFrame; msg: TZMQMsg );
var
  service_frame,
  client: TZMQFrame;
  service: TService;
  return_code,
  name: Utf8String;
  indx: Integer;
begin
  assert( msg.size >= 2 );     //  Service name + body

  service_frame := msg.pop;
  service := TService.Require( self, service_frame );

  //  Set reply return identity to client sender
  msg.wrap( sender.dup );

  //  If we got a MMI service request, process that internally
  if ( service_frame.size >= 4 ) and
     ( AnsiStartsStr( 'mmi.', service_frame.asUtf8String ) ) then
  begin
    return_code := '';
    if service_frame.asUtf8String = 'mmi.service' then
    begin
      name := msg.last.asUtf8String;
      indx := services.IndexOf( name );
      if indx > -1 then
        service := TService( services.Objects[ indx ] )
      else
        service := nil;

      if ( service <> nil ) and ( service.workers > 0 ) then
        return_code := '200'
      else
        return_code := '404';
    end else
      return_code := '501';

    msg.last.asUtf8String := return_code;

    //  Remove & save client return envelope and insert the
    //  protocol header and service name, then rewrap envelope.
    client := msg.unwrap;
    msg.push( service_frame.dup );
    msg.pushstr( MDPC_CLIENT );
    msg.wrap( client );
    socket.send( msg );
  end else
    //  Else dispatch the message to the requested service
    service.DispatchMsg( msg );
  service_frame.Free;
end;

//  The purge method deletes any idle workers that haven't pinged us in a
//  while. We hold workers from oldest to most recent, so we can stop
//  scanning whenever we find a live worker. This means we'll mainly stop
//  at the first worker, which is essential when we have large numbers of
//  workers (since we call this method in our critical path):
procedure TBroker.Purge;
var
  worker: TWorker;
begin
  if waiting.Count > 0 then
    worker := waiting.first
  else
    worker := nil;

  while worker <> nil do
  begin
    if zTimeStamp < worker.expiry then
      break;

    if self.Verbose then
      zNote( Format( 'I: deleting expired worker: %s', [worker.id_string] ) );

    worker.Delete( false );
    if waiting.Count > 0 then
      worker := waiting.first
    else
      worker := nil;
  end;
end;

//  Here is the implementation of the methods that work on a service:

//  Lazy constructor that locates a service by name, or creates a new
//  service if there is no service already with that name.
class function TService.Require( lBroker: TBroker; serviceFrame: TZMQFrame ): TService;
var
  name: Utf8String;
  indx: Integer;
begin
  assert( serviceFrame <> nil );
  name := serviceFrame.asUtf8String;

  indx := lBroker.services.IndexOf( name );
  if indx > -1 then
    result := TService( lBroker.services.Objects[indx] )
  else begin
    result := TService.Create;
    result.broker := lBroker;
    result.name := name;
    result.requests := TList.create;
    result.waiting := TList.create;
    lbroker.Services.AddObject( name, result );
    if lBroker.Verbose then
      zNote( Format( 'I: added service: %s', [name] ) );
  end;
end;

//  Service destructor is called automatically whenever the service is
//  removed from broker->services.
destructor TService.Destroy;
var
  i: Integer;
begin
  for i := 0 to requests.Count - 1 do
    TZMqMsg(requests[i]).Free;
  requests.Free;
  waiting.Free;
  inherited;
end;

//  The dispatch method sends requests to waiting workers:
procedure TService.DispatchMsg( msg: TZMQMsg );
var
  worker: TWorker;
  lmsg: TZMQMsg;
begin
  if msg <> nil then //  Queue message if any
    requests.Add( msg );

  broker.Purge;
  while ( waiting.Count > 0 ) and ( requests.Count > 0 ) do
  begin
    if waiting.Count > 0 then
      worker := waiting.first
    else
      worker := nil;

    if worker <> nil then
      waiting.Delete( 0 );

    broker.Waiting.Delete( broker.Waiting.IndexOf( worker ) );

    lmsg := TZMQMsg( requests.First );
    if lmsg <> nil then requests.Delete( 0 );

    worker.Send( MDPW_REQUEST, '', lmsg );
    //msg.Free;
  end;

end;

//  Here is the implementation of the methods that work on a worker:

//  Lazy constructor that locates a worker by identity, or creates a new
//  worker if there is no worker already with that identity.

class function TWorker.Require( lBroker: TBroker; identity: TZMQFrame ): TWorker;
var
  id_string: Utf8String;
  indx: Integer;
begin
  assert( identity <> nil );

  //  self->workers is keyed off worker identity
  id_string := identity.asHexString;

  indx := lbroker.workers.IndexOf( id_string );
  if indx > -1 then
    result := TWorker( lbroker.workers.objects[indx] )
  else begin
    result := TWorker.Create;
    result.broker := lBroker;
    result.id_string := id_string;
    result.identity := identity.dup;
    lbroker.Workers.AddObject( id_string, result );
    if lBroker.Verbose then
      zNote( Format( 'I: registering new worker: %s', [id_string] ) );
  end;

end;

//  The delete method deletes the current worker.
procedure TWorker.Delete( disconnect: Boolean );
var
  indx: Integer;
begin
  if disconnect then
    send( MDPW_DISCONNECT, '', nil );

  if service <> nil then
  begin
    indx := service.waiting.IndexOf( self );
    if indx > -1 then
      service.waiting.Delete( indx );
    Dec( service.workers );
  end;

  indx := broker.Waiting.IndexOf( self );
  if indx > -1 then
    broker.Waiting.Delete( indx );

  //  This implicitly calls s_worker_destroy (not true in delphi)
  indx := broker.Workers.IndexOf( id_string );
  if indx > -1 then
    broker.Workers.Delete( indx );
  Free;

end;

//  Worker destructor is called automatically whenever the worker is
//  removed from broker->workers.
destructor TWorker.Destroy;
begin
  identity.Free;
  inherited;
end;

//  The send method formats and sends a command to a worker. The caller may
//  also provide a command option, and a message payload:
procedure TWorker.Send( command: AnsiChar; option: Utf8String; lmsg: TZMQMsg );
var
  msg: TZMQMsg;
begin
  if lmsg = nil then
    msg := TZMQMsg.create
  else
    msg := lmsg.dup;

  //  Stack protocol envelope to start of message
  if option <> '' then
    msg.pushstr( option );

  msg.pushstr( command );
  msg.pushstr( MDPW_WORKER );

  //  Stack routing envelope to start of message
  msg.wrap( identity.dup );

  if broker.verbose then
  begin
    zNote( Format( 'I: sending %s to worker', [ mdps_Commands[ Ord( command ) ] ] ) );
    zNote( msg.dump );
  end;

  broker.Socket.send( msg );
end;

//  This worker is now waiting for work
procedure TWorker.waiting;
begin
  //  Queue to broker and service waiting lists
  assert( broker <> nil );
  broker.Waiting.Add( self );
  service.waiting.Add( self );
  expiry := zIncTimeMs( zTimeStamp, HEARTBEAT_EXPIRY );
  service.DispatchMsg( nil );
end;

//  Finally here is the main task. We create a new broker instance and
//  then processes messages on the broker socket:
var
  verbose: Boolean;
  self: TBroker;
  poller: TZMQPoller;
  msg: TZMQMsg;
  sender,
  empty,
  header: TZMQFrame;
  i: Integer;
begin
  verbose := ( ParamCount > 0 ) and ( paramStr(1) = '-v' );
  self := TBroker.Create( verbose );
  self.Bind( 'tcp://*:5555' );

  poller := TZMQPoller.Create( True );
  poller.Register( self.Socket, [pePollIn] );

  //  Get and process messages forever or until interrupted
  while not self.ctx.Terminated do
  try
    poller.poll( HEARTBEAT_INTERVAL );

    //  Process next input message, if any
    if pePollIn in poller.PollItem[0].revents then
    begin
      msg := nil;
      self.socket.recv( msg );
      if self.verbose then
      begin
        zNote( 'I: received message:' );
        zNote( msg.dump );
      end;
      sender := msg.pop;
      empty := msg.pop;
      header := msg.pop;

      if header.asUtf8String = MDPC_CLIENT then
        self.ClientMsg( sender, msg )
      else
      if header.asUtf8String = MDPW_WORKER then
        self.WorkerMsg( sender, msg )
      else begin
        zNote( 'E: invalid message:' );
        zNote( msg.dump );
        FreeAndNil( msg );
      end;

      sender.Free;
      empty.Free;
      header.Free;
    end;

    //  Disconnect and delete any expired workers
    //  Send heartbeats to idle workers if needed
    if zTimeStamp > self.Heartbeat_at then
    begin
      self.Purge;
      for i := 0 to self.Waiting.Count - 1 do
        TWorker(self.Waiting[i]).Send( MDPW_HEARTBEAT, '', nil );

      self.Heartbeat_at := zIncTimeMs( zTimeStamp, HEARTBEAT_INTERVAL );
    end;
  except
  end;

  if self.ctx.Terminated then
    zNote( 'W: interrupt received, shutting down...' );

  self.Free;
end.

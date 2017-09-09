unit mdwrkapi;
{  =====================================================================
*  mdwrkapi.c - Majordomo Protocol Worker API
*  Implements the MDP/Worker spec at http://rfc.zeromq.org/spec:7.
*  ===================================================================== }
//  @author Varga Balázs <bb.varga@gmail.com>

interface

uses
    SysUtils
  , zmqapi
  , zmq
  , mdp
  ;

const
  //  Reliability parameters
  HEARTBEAT_LIVENESS = 3;       //  3-5 is reasonable

//  This is the structure of a worker API instance. We use a pseudo-OO
//  approach in a lot of the C examples, as well as the CZMQ binding:

type
  //  Structure of our class
  //  We access these properties only via class methods
  TMajorDomoWorker = class
  private
    ctx: TZMQContext;                //  Our context
    fBroker: AnsiString;
    fService: Utf8String;
    fWorker: TZMQSocket;               //  Socket to broker
    fVerbose: Boolean;                //  Print activity to stdout

    //  Heartbeat management
    heartbeat_at: Int64;      //  When to send HEARTBEAT
    liveness: size_t;            //  How many attempts left
    fHeartbeat: Integer;              //  Heartbeat delay, msecs
    fReconnect: Integer;              //  Reconnect delay, msecs

    expect_reply: Integer;           //  Zero only at start
    reply_to: TZMQFrame;         //  Return identity, if any

    function getTerminated: Boolean;
    //  We have two utility functions; to send a message to the broker and
    //  to (re-)connect to the broker:

    //  Send message to broker
    //  If no msg is provided, creates one internally
    procedure SendToBroker( command: AnsiChar; option: Utf8String; msg: TZMQMsg );
    //  Connect or reconnect to broker
    procedure ConnectToBroker;

  public
    //  Here we have the constructor and destructor for our class:
    constructor Create( lBroker, lService: Utf8String; lVerbose: Boolean );
    destructor Destroy; override;

    //  This is the recv method; it's a little misnamed since it first sends
    //  any reply and then waits for a new request. If you have a better name
    //  for this, let me know:
    function recv( var reply_p: TZMQMsg ): TZMQMsg;

    property Broker: AnsiString read fBroker;
    property Service: Utf8String read fService;
    property Verbose: Boolean read fVerbose;

    //  We provide two methods to configure the worker API. You can set the
    //  heartbeat interval and retries to match the expected network performance.
    property Heartbeat: Integer read fHeartbeat write fHeartbeat;
    property Reconnect: Integer read fReconnect write fReconnect;
    property Terminated: Boolean read getTerminated;
  end;

implementation

uses
    zhelpers
  ;

constructor TMajorDomoWorker.Create( lBroker, lService: Utf8String; lVerbose: Boolean );
begin
  Assert( lBroker <> '' );
  Assert( lService <> '' );

  ctx := TZMQContext.create;
  fBroker := lBroker;
  fService := lService;
  fVerbose := lVerbose;
  heartbeat := 2500;     //  msecs
  reconnect := 2500;     //  msecs

  ConnectToBroker;
end;

destructor TMajorDomoWorker.Destroy;
begin
  ctx.Free;
  inherited;
end;

function TMajorDomoWorker.getTerminated: Boolean;
begin
  result := ctx.Terminated;
end;

procedure TMajorDomoWorker.SendToBroker( command: AnsiChar; option: Utf8String; msg: TZMQMsg );
begin
  if msg <> nil then
    msg := msg.dup
  else
    msg := TZMQMsg.create;

  //  Stack protocol envelope to start of message
  if option <> '' then
    msg.pushstr( option );

  msg.pushstr( command );
  msg.pushstr( MDPW_WORKER );
  msg.pushstr( '' );

  if Verbose then
  begin
    zNote( Format( 'I: sending %s to broker', [mdps_Commands[Ord(command)]] ) );
    zNote( msg.dump );
  end;
  fWorker.send( msg );
end;

procedure TMajorDomoWorker.ConnectToBroker;
begin
  if fWorker <> nil then
    fWorker.Free;
  fWorker := ctx.Socket( stDealer );
  fWorker.Linger := 0;
  fWorker.connect( fBroker );

  if Verbose then
    zNote( Format( 'I: connecting to broker at %s...', [ Broker ] ) );

  //  Register service with broker
  SendToBroker( MDPW_READY, service, nil );

  //  If liveness hits zero, queue is considered disconnected
  liveness := HEARTBEAT_LIVENESS;
  heartbeat_at := zIncTimeMs( zTimeStamp, heartbeat );
end;

function TMajorDomoWorker.recv( var reply_p: TZMQMsg ): TZMQMsg;
var
  reply,
  msg: TZMQMsg;
  empty,
  header,
  command: TZMQFrame;
  pia: TZMQPollItem;
begin
  result :=nil;
  //  Send reply, if any, to broker and wait for next request.

  //  Format and send the reply if we were provided one
  reply := reply_p;
  assert( ( reply <> nil ) or ( expect_reply = 0 ) );

  if reply <> nil then
  begin
    assert( reply_to <> nil );
    reply.wrap( reply_to );
    SendToBroker( MDPW_REPLY, '', reply );
    FreeAndNil( reply_p );
  end;

  expect_reply := 1;

  while not ctx.Terminated do
  try
    pia.socket := fWorker;
    pia.events := [ pePollIn ];
    ZMQPoll( pia, 1, HeartBeat );
    if pePollIn in pia.revents then
    begin
      msg := nil;
      fWorker.recv( msg );
      if Verbose then
      begin
        zNote( 'I: received message from broker:' );
        zNote( msg.dump );
      end;
      liveness := HEARTBEAT_LIVENESS;

      //  Don't try to handle errors, just assert noisily
      assert( msg.size >= 3 );

      empty := msg.pop;
      assert( empty.AsUtf8String = '' );
      empty.Free;

      header := msg.pop;
      assert( header.AsUtf8String = MDPW_WORKER );
      header.Free;

      command := msg.pop;
      if command.asUtf8String = MDPW_REQUEST then
      begin
        //  We should pop and save as many addresses as there are
        //  up to a null part, but for now, just save one...
        reply_to := msg.unwrap;
        command.Free;
        //  Here is where we actually have a message to process; we
        //  return it to the caller application:
        result := msg;     //  We have a request to process
        break;
      end else
      if command.asUtf8String = MDPW_HEARTBEAT then
      begin
        //  Do nothing for heartbeats
      end else
      if command.asUtf8String = MDPW_DISCONNECT then
        ConnectToBroker
      else begin
        zNote( 'E: invalid input message ' );
        zNote( msg.dump );
      end;
      command.Free;
      msg.Free;
    end else
    begin
      dec( liveness );
      if liveness = 0 then
      begin
        if Verbose then
          zNote( 'W: disconnected from broker - retrying...' );
        sleep( Reconnect );
        ConnectToBroker;
      end;

      //  Send HEARTBEAT if it's time
      if zTimeStamp > heartbeat_at then
      begin
        SendToBroker( MDPW_HEARTBEAT, '', nil );
        heartbeat_at := zIncTimeMs( zTimeStamp, heartbeat );
      end;
    end;
  except
  end;

  if ctx.Terminated then
    zNote( 'W: interrupt received, killing worker...' );
end;

end.


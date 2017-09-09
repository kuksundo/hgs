unit mdcliapi2;
{  =====================================================================
*  mdcliapi.c - Majordomo Protocol Client API
*  Implements the MDP/Worker spec at http://rfc.zeromq.org/spec:7.
*  ===================================================================== }
//  @author Varga Balázs <bb.varga@gmail.com>

interface

uses
    SysUtils
  , zmqapi
  ;

type
  TMajorDomoClient = class
  private
    //  Structure of our class
    //  We access these properties only via class methods

    ctx: TZMQContext;   //  Our context
    Broker: AnsiString;
    Client: TZMQSocket; //  Socket to broker
    Verbose: Boolean;   //  Print activity to stdout
    fTimeout: Integer;   //  Request timeout
    poller: TZMQPoller;
    procedure ConnectToBroker;
  public
    constructor Create( lbroker: AnsiString; lverbose: Boolean );
    destructor Destroy; override;

    //  Here is the send method. It sends a request to the broker and gets a
    //  reply even if it has to retry several times. It takes ownership of the
    //  request message, and destroys it when sent. It returns the reply
    //  message, or NULL if there was no reply after multiple attempts:
    function send( service: Utf8String; var request: TZMQMsg ): Integer;
    function recv: TZMQMsg;

    //  We can set the request timeout and number
    //  of retry attempts, before sending requests:
    property Timeout: Integer read fTimeout write fTimeout;
  end;

implementation

uses
    zhelpers
  , mdp
  ;

//  The constructor and destructor are the same as in mdcliapi, except
//  we don't do retries, so there's no retries property.
constructor TMajorDomoClient.Create( lbroker: AnsiString; lverbose: Boolean );
begin
  assert( lbroker <> '' );
  ctx := TZMQContext.Create;
  Broker := lbroker;
  Verbose := lverbose;
  fTimeout := 2500; // msecs
  poller := TZMQPoller.Create( true );
  ConnectToBroker;
end;

destructor TMajorDomoClient.Destroy;
begin
  poller.Free;
  ctx.Free;
  inherited;
end;

//  ---------------------------------------------------------------------
//  Connect or reconnect to broker. In this asynchronous class we use a
//  DEALER socket instead of a REQ socket; this lets us send any number
//  of requests without waiting for a reply.
procedure TMajorDomoClient.ConnectToBroker;
begin
  if Client <> nil then
  begin
    Client.Free;
  end;
  Client := ctx.Socket( stDealer );
  Client.Linger := 0;
  Client.connect( Broker );
  poller.Register( client, [pePollIn] );

  if Verbose then
    zNote( Format( 'I: connecting to broker at %s...', [Broker] ) );
end;

//  The send method now just sends one message, without waiting for a
//  reply. Since we're using a DEALER socket we have to send an empty
//  frame at the start, to create the same envelope that the REQ socket
//  would normally make for us:
function TMajorDomoClient.send( service: Utf8String; var request: TZMQMsg ): Integer;
begin
  assert( request <> nil );
  //  Prefix request with protocol frames
  //  Frame 0: empty (REQ emulation)
  //  Frame 1: "MDPCxy" (six bytes, MDP/Client x.y)
  //  Frame 2: Service name (printable string)

  request.pushstr( service );
  request.pushstr( MDPC_CLIENT );
  request.pushstr( '' );
  if Verbose then
  begin
    zNote( Format( 'I: send request to "%s" service:', [service] ) );
    zNote( request.dump );
  end;

  Client.send( request );

  result := 0;
end;

//  The recv method waits for a reply message and returns that to the
//  caller.
//  ---------------------------------------------------------------------
//  Returns the reply message or NULL if there was no reply. Does not
//  attempt to recover from a broker failure, this is not possible
//  without storing all unanswered requests and resending them all…
function TMajorDomoClient.recv: TZMQMsg;
var
  empty,
  header,
  service: TZMQFrame;
begin
  //  Poll socket for a reply, with timeout
  try
    poller.poll( Timeout );
    result := nil;

    if pePollIn in poller.PollItem[0].revents then
    begin
      Client.recv( result );
      if verbose then
      begin
        zNote( 'I: received reply:' );
        zNote( result.dump );
      end;

      //  Don't try to handle errors, just assert noisily
      assert( result.size >= 4 );

      empty := result.pop;
      assert( empty.asUtf8String = '' );
      empty.Free;

      header := result.pop;
      assert( header.asUtf8String = MDPC_CLIENT );
      header.Free;

      service := result.pop;
      service.Free;
    end;

  except
  end;

  if ctx.Terminated then
    zNote( 'W: interrupt received, killing client...' ) else
  if ( result = nil ) and verbose then
    zNote( 'W: permanent error, abandoning request ');

end;

end.

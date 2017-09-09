unit mdcliapi;
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
    fBroker: AnsiString;
    fClient: TZMQSocket; //  Socket to broker
    fVerbose: Boolean;   //  Print activity to stdout
    fTimeout: Integer;   //  Request timeout
    fRetries: Integer;   //  Request retries
    poller: TZMQPoller;
    procedure ConnectToBroker;
  public
    constructor Create( lbroker: AnsiString; lverbose: Boolean );
    destructor Destroy; override;

    //  Here is the send method. It sends a request to the broker and gets a
    //  reply even if it has to retry several times. It takes ownership of the
    //  request message, and destroys it when sent. It returns the reply
    //  message, or NULL if there was no reply after multiple attempts:
    function send( service: Utf8String; var request: TZMQMsg ): TZMQMsg;

    //  We can set the request timeout and number
    //  of retry attempts, before sending requests:
    property Timeout: Integer read fTimeout write fTimeout;
    property Retries: Integer read fRetries write fRetries;
  end;

implementation

uses
    zhelpers
  , mdp
  ;
  
//  Here we have the constructor and destructor for our mdcli class:
//  ---------------------------------------------------------------------
//  Constructor
constructor TMajorDomoClient.Create( lbroker: AnsiString; lverbose: Boolean );
begin
  assert( lbroker <> '' );
  ctx := TZMQContext.Create;
  fBroker := lbroker;
  fVerbose := lverbose;
  fTimeout := 2500; // msecs
  fRetries := 3;    // Before we abandon
  poller := TZMQPoller.Create( true );
  ConnectToBroker;
end;

//  Destructor
destructor TMajorDomoClient.Destroy;
begin
  poller.Free;
  ctx.Free;
  inherited;
end;

//  Connect or reconnect to broker
procedure TMajorDomoClient.ConnectToBroker;
begin
  if fClient <> nil then
  begin
    poller.Deregister( fClient, [pePollIn] );
    fClient.Free;
  end;
  fClient := ctx.Socket( stReq );
  fClient.Linger := 0;
  fClient.connect( fBroker );
  poller.Register( fClient, [pePollIn] );
  if fVerbose then
    zNote( Format( 'I: connecting to broker at %s...', [fBroker] ) );
end;

function TMajorDomoClient.send( service: Utf8String; var request: TZMQMsg ): TZMQMsg;
var
  retries_left: Integer;
  msg: TZMQMsg;
  header,
  reply_service: TZMQFrame;
begin
  assert( request <> nil );
  //  Prefix request with protocol frames
  //  Frame 1: "MDPCxy" (six bytes, MDP/Client x.y)
  //  Frame 2: Service name (printable string)

  request.pushstr( service );
  request.pushstr( MDPC_CLIENT );
  if fVerbose then
  begin
    zNote( Format( 'I: send request to "%s" service:', [service] ) );
    zNote( request.dump );
  end;

  retries_left := Retries;

  while ( retries_left > 0 ) and not ctx.Terminated do
  try
    msg := request.dup;
    fClient.send( msg );

    //  On any blocking call, libzmq will return -1 if there was
    //  an error; we could in theory check for different error codes
    //  but in practice it's OK to assume it was EINTR (Ctrl-C):
    poller.poll( Timeout );

    //  If we got a reply, process it
    if pePollIn in poller.PollItem[0].revents then
    begin
      fClient.recv( msg );
      if fVerbose then
      begin
        zNote( 'I: received reply:' );
        zNote( msg.dump );
      end;

      //  We would handle malformed replies better in real code
      assert( msg.size >= 3 );

      header := msg.pop;
      assert( header.AsUtf8String = MDPC_CLIENT );
      header.Free;

      reply_service := msg.pop;
      assert( reply_service.AsUtf8String = service );
      reply_service.Free;

      FreeAndNil( request );
      result := msg;
      exit;     //  Success
    end else
    begin
      dec( retries_left );
      if retries_left > 0 then
      begin
        if fVerbose then
          zNote( 'W: no reply, reconnecting...' );
        ConnectToBroker;
      end else
      begin
        if fVerbose then
          zNote( 'W: permanent error, abandoning' );
        break; //  Give up
      end;
    end;
  except
  end;
  if ctx.Terminated then
    zNote( 'W: interrupt received, killing client...' );
  FreeAndNil( request );
  result := nil;
end;

end.
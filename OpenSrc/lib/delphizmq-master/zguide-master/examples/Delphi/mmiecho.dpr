program mmiecho;
//
//  MMI echo query example
//  @author Varga Bal?s <bb.varga@gmail.com>
//
{$APPTYPE CONSOLE}

uses
    SysUtils
  , zmqapi
  , mdcliapi
  , zhelpers
  ;

var
  verbose: Boolean;
  session: TMajorDomoClient;
  request,
  reply: TZMQMsg;
begin
  verbose := ( ParamCount > 0 ) and ( ParamStr( 1 ) = '-v' );
  session := TMajorDomoClient.Create( 'tcp://localhost:5555', verbose );

  //  This is the service we want to look up
  request := TZMQMsg.create;
  request.pushstr( 'echo' );

  //  This is the service we send our request to
  reply := session.send( 'mmi.service', request );

  if reply <> nil then
  begin
    zNote( Format( 'Lookup echo service: %s', [reply.first.asUtf8String] ) );
    reply.Free;
  end else
    zNote( 'E: no response from broker, make sure it''s running' );

  session.Free;
end.


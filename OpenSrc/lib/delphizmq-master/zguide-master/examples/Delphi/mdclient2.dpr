program mdclient2;
//
//  Majordomo Protocol client example - asynchronous
//  Uses the mdcli API to hide all MDP aspects
//
//  Lets us build this source without creating a library
//  @author Varga Bal?s <bb.varga@gmail.com>

{$APPTYPE CONSOLE}

uses
    SysUtils
  , mdcliapi2
  , zmqapi
  , zhelpers
  ;

var
  verbose: Boolean;
  session: TMajorDomoClient;
  i,count: Integer;
  request,
  reply: TZMQMsg;
begin
  verbose := ( ParamCount > 0 ) and ( ParamStr( 1 ) = '-v' );

  session := TMajorDomoClient.Create( 'tcp://localhost:5555', verbose );

  count := 10000;
  for i := 1 to count do
  begin
    request := TZMQMsg.Create;
    request.pushstr( 'Hello world' );
    session.send( 'echo', request );
  end;

  for i := 1 to count do
  begin
    reply := session.recv;
    reply.Free;
  end;

  zNote( Format( '%d replies received', [count] ) );
  session.Free;
end.


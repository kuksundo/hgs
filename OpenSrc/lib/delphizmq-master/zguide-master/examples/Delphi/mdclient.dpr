program mdclient;
//
//  Majordomo Protocol client example
//  Uses the mdcli API to hide all MDP aspects
//  @author Varga Bal?s <bb.varga@gmail.com>
//
{$APPTYPE CONSOLE}

//  Lets us build this source without creating a library

uses
    SysUtils
  , mdcliapi
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
  i := 0;
  while ( i < count ) do
  begin
    request := TZMQMsg.Create;
    request.pushstr( 'Hello world' );
    reply := session.send( 'echo', request );
    if reply <> nil then
      reply.Free
    else
      break; //  Interrupt or failure
    inc( i );
  end;
  zNote( Format( '%d requests/replies processed', [i] ) );
  session.Free;
end.


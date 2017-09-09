program mdworker;
//
//  Majordomo Protocol worker example
//  Uses the mdwrk API to hide all MDP aspects
//  @author Varga Bal?s <bb.varga@gmail.com>
//

{$APPTYPE CONSOLE}

uses
    SysUtils
  , zmqapi
  , mdwrkapi
  ;

var
  Verbose: Boolean;
  session: TMajorDomoWorker;
  reply,
  request: TZMQMsg;
begin
  Verbose := ( ParamCount > 0 ) and ( ParamStr( 1 ) = '-v' );
  session := TMajorDomoWorker.Create( 'tcp://localhost:5555', 'echo', verbose );

  reply := nil;
  while not session.Terminated do
  begin
    request := session.recv( reply );
    reply := request; //  Echo is complex... :-)
  end;
  session.Free;

end.

program monitor_socket;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4,
  SysUtils,
  ZeroMQ;

procedure ZMQEventProc(Events: ZMQEvents; Value: Integer; const Address: string);
const
  EVENT_STRING: array[ZMQEvent] of string = (
    'Connected', 'Delayed', 'Retried',
    'Listening', 'BindFailed',
    'Accepted', 'AcceptFailed',
    'Closed', 'CloseFailed', 'Disconnected',
    'MonitorStopped'
  );
var
  E: ZMQEvent;
begin
  for E := Low(ZMQEvent) to High(ZMQEvent) do
    if E in Events then
    begin
      WriteLn(EVENT_STRING[E] + ' socket descriptor: ' + IntToStr(Value));
      WriteLn(EVENT_STRING[E] + ' socket address: ' + Address);
    end;
end;

var
  Z: IZeroMQ;
  P: IZMQPair;
begin
  try
    Z := TZeroMQ.Create;
    P := Z.Start(ZMQSocket_Responder);
    if Z.Monitor(P, 'monitor.rep', ZMQAllEvents, ZMQEventProc
      )
    then
    begin
      WriteLn('Started Socket Monitor');
      P.Bind('tcp://*:6666');
      P.Close;
    end;

    Z.Sleep(2);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

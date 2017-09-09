program weather_proxy;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4,
  SysUtils, Types, ZeroMQ;

procedure Run;
var
  Z: IZeroMQ;
  Frontend: IZMQPair;
  Backend: IZMQPair;
  Messages: TStringDynArray;
begin
  Z := TZeroMQ.Create;
  Frontend := Z.Start(ZMQSocket_Subscriber);
  Frontend.Connect('tcp://localhost:5556');
  Frontend.Subscribe('');

  Backend := Z.Start(ZMQSocket_Publisher);
  Backend.Bind('tcp://*:8100');

  while True do
  begin
    Messages := Frontend.ReceiveStrings;
    Backend.SendStrings(Messages);
  end;
end;

begin
  try
    Run;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

program requestreply_broker_device;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4,
  SysUtils, ZeroMQ;

procedure Run;
var
  Z: IZeroMQ;
  Frontend, Backend: IZMQPair;
begin
  Z := TZeroMQ.Create;

  Frontend := Z.Start(ZMQSocket_Router);
  Frontend.Bind('tcp://*:5559');

  Backend := Z.Start(ZMQSocket_Dealer);
  Backend.Bind('tcp://*:5560');

  Z.StartProxy(Frontend, Backend);
end;

begin
  try
    Run;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

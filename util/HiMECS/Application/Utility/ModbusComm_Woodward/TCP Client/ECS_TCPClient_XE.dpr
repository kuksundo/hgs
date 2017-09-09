program ECS_TCPClient_XE;

uses
  RunOne,
  Forms,
  ECS_TCPClient_Main in 'ECS_TCPClient_Main.pas' {ClientFrmMain},
  TCPConfig in 'TCPConfig.pas' {TCPConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientFrmMain, ClientFrmMain);
  Application.Run;
end.

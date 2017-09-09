program ECS_Kumo_TCPServerp_xe;

uses
  RunOne_TCPServer_Kumo, Forms,
  ECS_TCPServerMain in 'ECS_TCPServerMain.pas' {ServerFrmMain},
  TCPServerConst in 'TCPServerConst.pas',
  TCPConfig in 'TCPConfig.pas' {TCPConfigF},
  TCPServer_Util in 'TCPServer_Util.pas',
  ECS_Kumo_TCPUtil in 'ECS_Kumo_TCPUtil.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServerFrmMain, ServerFrmMain);
  Application.Run;
end.

program MT210_TCPServerp_D2007;

uses
  Forms,
  MT210_TCPServerMain in 'MT210_TCPServerMain.pas' {ServerFrmMain},
  TCPServerConst in 'TCPServerConst.pas',
  TCPConfig in 'TCPConfig.pas' {TCPConfigF},
  TCPServer_Util in 'TCPServer_Util.pas',
  MT210_TCPUtil in 'MT210_TCPUtil.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServerFrmMain, ServerFrmMain);
  Application.Run;
end.

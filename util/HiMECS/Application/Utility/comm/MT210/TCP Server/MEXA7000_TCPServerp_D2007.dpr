program MEXA7000_TCPServerp_D2007;

uses
  Forms,
  MEXA7000_TCPServerMain in 'MEXA7000_TCPServerMain.pas' {ServerFrmMain},
  TCPServerConst in 'TCPServerConst.pas',
  TCPConfig in 'TCPConfig.pas' {TCPConfigF},
  TCPServer_Util in 'TCPServer_Util.pas',
  MEXA7000_TCPUtil in 'MEXA7000_TCPUtil.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServerFrmMain, ServerFrmMain);
  Application.Run;
end.

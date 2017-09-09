program TCPServerp_All;

uses
  RunOne_TCPServerAll,
  Forms,
  TCPServerAllMain in 'TCPServerAllMain.pas' {ServerFrmMain},
  TCPServerAllConst in 'TCPServerAllConst.pas',
  TCPServerAllConfig in 'TCPServerAllConfig.pas' {TCPConfigF},
  TCPServerAll_Util in 'TCPServerAll_Util.pas',
  UnitFrameIPCConst in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameIPCConst.pas',
  UnitFrameIPCMonitorAll4GasEngine in 'UnitFrameIPCMonitorAll4GasEngine.pas' {FrameIPCMonitorAll4GasEngine: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServerFrmMain, ServerFrmMain);
  Application.Run;
end.

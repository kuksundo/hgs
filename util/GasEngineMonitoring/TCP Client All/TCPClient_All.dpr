program TCPClient_All;

uses
  RunOne_TCPClientAll,
  Forms,
  TCPClientAll_Main in 'TCPClientAll_Main.pas' {ClientFrmMain},
  TCPClientAllConfig in 'TCPClientAllConfig.pas' {TCPConfigF},
  UnitFrameIPCClientAll in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameIPCClientAll.pas' {FrameIPCClientAll: TFrame},
  UnitFrameIPCClientAll4GasEngine in 'UnitFrameIPCClientAll4GasEngine.pas' {FrameIPCClientAll4GasEngine: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientFrmMain, ClientFrmMain);
  Application.Run;
end.

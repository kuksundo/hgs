program MT210_TCPClient_D2007;

uses
  RunOne,
  Forms,
  MT210_TCPClient_Main in 'MT210_TCPClient_Main.pas' {ClientFrmMain},
  TCPConfig in 'TCPConfig.pas' {TCPConfigF},
  MT210_TCPUtil in 'MT210_TCPUtil.pas',
  DataSave2FileThread in 'DataSave2FileThread.pas',
  DataSaveConst in 'DataSaveConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientFrmMain, ClientFrmMain);
  Application.Run;
end.

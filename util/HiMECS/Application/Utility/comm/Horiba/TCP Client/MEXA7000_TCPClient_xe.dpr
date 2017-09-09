program MEXA7000_TCPClient_xe;

uses
  RunOne,
  Forms,
  MEXA7000_TCPClient_Main in 'MEXA7000_TCPClient_Main.pas' {ClientFrmMain},
  TCPConfig in 'TCPConfig.pas' {TCPConfigF},
  MEXA7000_TCPUtil in 'MEXA7000_TCPUtil.pas',
  DataSave2FileThread in 'DataSave2FileThread.pas',
  DataSaveConst in 'DataSaveConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientFrmMain, ClientFrmMain);
  Application.Run;
end.

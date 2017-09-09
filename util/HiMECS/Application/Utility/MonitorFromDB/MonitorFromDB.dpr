program MonitorFromDB;

uses
  Vcl.Forms,
  UnitMonitorFromDB in 'UnitMonitorFromDB.pas' {MonitorFromDBF},
  UnitMonitorFromDBConfig in 'UnitMonitorFromDBConfig.pas' {MonitorDataFromDBConfigF},
  UnitFrameMonitorFromDB in '..\CommonFrame\UnitFrameMonitorFromDB.pas' {TFrameIPCClientFromDB: TFrame},
  UnitFrameWatchGrid in '..\CommonFrame\UnitFrameWatchGrid.pas' {FrameWatchGrid: TFrame},
  UnitStrMsg.Events in '..\..\..\..\..\common\UnitStrMsg.Events.pas',
  UnitStrMsg.EventThreads in '..\..\..\..\..\common\UnitStrMsg.EventThreads.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMonitorFromDBF, MonitorFromDBF);
  Application.Run;
end.

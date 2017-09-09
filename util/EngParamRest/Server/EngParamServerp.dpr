program EngParamServerp;

uses
  Vcl.Forms,
  UnitEngParamServer in 'UnitEngParamServer.pas' {EngParamServerF},
  UnitEngParamInterface in '..\Common\UnitEngParamInterface.pas',
  UnitFrameIPCMonitorAll in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitor: TFrame},
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  UnitFrameWatchGrid in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameWatchGrid.pas' {FrameWatchGrid: TFrame},
  DataModule_Unit in 'DataModule_Unit.pas' {DM1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TEngParamServerF, EngParamServerF);
  Application.CreateForm(TDM1, DM1);
  Application.Run;
end.

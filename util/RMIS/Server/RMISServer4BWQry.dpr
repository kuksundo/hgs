program RMISServer4BWQry;

uses
  Vcl.Forms,
  UnitRMISServer4BWQueryMain in 'UnitRMISServer4BWQueryMain.pas' {Form1},
  UnitBWQueryInterface in '..\Common\UnitBWQueryInterface.pas',
  UnitBWQueryConfig in 'UnitBWQueryConfig.pas' {ConfigF},
  BW_Query_Class in '..\Common\BW_Query_Class.pas',
  UnitDataView in 'UnitDataView.pas' {DataViewF},
  UnitHhiOfficeNewsInterface in '..\Common\UnitHhiOfficeNewsInterface.pas',
  UnitDM in 'UnitDM.pas' {DM1: TDataModule},
  UnitDPMSInfoClass in '..\Common\UnitDPMSInfoClass.pas',
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  UnitFrameIPCMonitorRMIS in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameIPCMonitorRMIS.pas' {FrameIPCMonitor4RMIS: TFrame},
  IPC_BWQry_Const in '..\..\HiMECS\Application\Utility\Watch2\common\IPC_BWQry_Const.pas',
  MyKernelObject4GpSharedMem in '..\..\..\common\MyKernelObject4GpSharedMem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

program BWQueryClient;

uses
  Vcl.Forms,
  UnitBWQueryClientMain in 'UnitBWQueryClientMain.pas' {Form1},
  UnitBWQueryInterface in '..\Common\UnitBWQueryInterface.pas',
  UnitBWQueryConfig in 'UnitBWQueryConfig.pas' {ConfigF},
  BW_Query_Class in '..\Common\BW_Query_Class.pas',
  UnitDataView in 'UnitDataView.pas' {DataViewF},
  UnitHhiOfficeNewsInterface in '..\Common\UnitHhiOfficeNewsInterface.pas',
  UnitDM in 'UnitDM.pas' {DM1: TDataModule},
  UnitDPMSInfoClass in '..\Common\UnitDPMSInfoClass.pas',
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  UnitIPCClientRMIS in '..\..\HiMECS\Application\Utility\CommonFrame\UnitIPCClientRMIS.pas',
  IPC_BWQry_Const in '..\..\HiMECS\Application\Utility\Watch2\common\IPC_BWQry_Const.pas',
  RMISConst in '..\Common\RMISConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

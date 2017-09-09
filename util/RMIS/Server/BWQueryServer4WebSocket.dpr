program BWQueryServer4WebSocket;

uses
  Vcl.Forms,
  UnitBWQueryMain4WS in 'UnitBWQueryMain4WS.pas' {Form1},
  UnitBWQueryInterface4WebSocket in '..\Common\UnitBWQueryInterface4WebSocket.pas',
  UnitBWQueryConfig in 'UnitBWQueryConfig.pas' {ConfigF},
  BW_Query_Class in '..\Common\BW_Query_Class.pas',
  UnitDataView in 'UnitDataView.pas' {DataViewF},
  UnitHhiOfficeNewsInterface in '..\Common\UnitHhiOfficeNewsInterface.pas',
  UnitClientInfoClass in '..\Common\UnitClientInfoClass.pas',
  UnitDM in 'UnitDM.pas' {DM1: TDataModule},
  UnitDPMSInfoClass in '..\Common\UnitDPMSInfoClass.pas',
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  BaseConfigCollect in '..\..\HiMECS\Application\Source\Common\BaseConfigCollect.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

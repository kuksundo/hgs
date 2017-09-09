program EngParamClientp;

uses
  Vcl.Forms,
  UnitEngParamClient in 'UnitEngParamClient.pas' {Form3},
  UnitEngParamInterface in '..\Common\UnitEngParamInterface.pas',
  UnitFrameWatchGrid in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameWatchGrid.pas' {FrameWatchGrid: TFrame},
  UnitFrameIPCMonitorAll in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitor: TFrame},
  IniPersist in '..\..\..\common\robstechcorner\rtti\IniPersist.pas',
  UnitEPClientConfig in 'UnitEPClientConfig.pas' {ConfigF},
  UtilUnit in '..\..\VisualComm\util\UtilUnit.pas',
  CommonUtil in '..\..\HiMECS\Application\Utility\ModbusComm_kumo\common\CommonUtil.pas',
  UnitRegistrationClass in '..\..\..\common\UnitRegistrationClass.pas',
  PJVersionInfo in '..\..\..\common\DelphiDabbler\dd-versioninfo\PJVersionInfo.pas',
  UnitRegistration in '..\..\..\common\UnitRegistration.pas' {RegistrationF},
  uSMBIOS in '..\..\..\common\TSmBios\Common\uSMBIOS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

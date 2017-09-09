program AMSReporter;

uses
  Vcl.Forms,
  UnitReporterMain in 'UnitReporterMain.pas' {FormAlarmList},
  UnitFrameIPCMonitorAll in '..\..\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitor: TFrame},
  UnitFrameWatchGrid in '..\..\CommonFrame\UnitFrameWatchGrid.pas' {FrameWatchGrid: TFrame},
  UnitAlarmConfig in '..\Common\UnitAlarmConfig.pas' {AlarmConfigF},
  UnitAlarmConst in '..\Common\UnitAlarmConst.pas',
  UnitEngParamConfig in '..\..\..\Source\Forms\UnitEngParamConfig.pas' {EngParamItemConfigForm},
  WatchConst2 in '..\..\Watch2\WatchConst2.pas',
  CommonUtil in '..\..\ModbusComm_kumo\common\CommonUtil.pas',
  UnitSqliteManager in '..\..\..\..\..\..\common\UnitSqliteManager.pas',
  UnitInterfaceHTTPManager in '..\..\..\..\..\..\common\UnitInterfaceHTTPManager.pas',
  UnitAlarmReportInterface in '..\Common\UnitAlarmReportInterface.pas',
  UnitDM in '..\Common\UnitDM.pas' {DM1: TDataModule},
  UnitAlarmListConfigEdit in '..\Common\UnitAlarmListConfigEdit.pas' {AlarmListConfigF},
  UnitSimulatedValueInput in 'UnitSimulatedValueInput.pas' {SimulatedValueInputF},
  UnitFrameAlarmConfigGrid in '..\..\CommonFrame\UnitFrameAlarmConfigGrid.pas' {Frame1: TFrame},
  UnitfindUser in '..\..\..\Source\Forms\UnitfindUser.pas' {findUser_Frm},
  UnitSelectUser in '..\..\..\Source\Forms\UnitSelectUser.pas' {SelectUserF},
  UnitSelectTagName in '..\..\CommonFrame\UnitSelectTagName.pas' {TagInfoEditorDlg},
  UnitAlarmReportCallBackInterface in '..\Common\UnitAlarmReportCallBackInterface.pas',
  SerializableObjectList in '..\..\..\..\..\..\common\SerializableObjectList.pas',
  UnitFrameCommServer in '..\..\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  UnitAMSessionInterface in '..\Common\UnitAMSessionInterface.pas',
  UnitAlarmConfigInterface in '..\Common\UnitAlarmConfigInterface.pas',
  JwaWindows in '..\..\..\..\..\..\common\JEDI API 2.3 and JEDI WSCL 0.9.3\jwa\branches\2.3\Win32API\jwaWindows\JwaWindows.pas',
  JwsclFirewall in '..\..\..\..\..\..\common\JEDI API 2.3 and JEDI WSCL 0.9.3\jwscl\branches\0.9.3\source\JwsclFirewall.pas',
  UnitWinFireWallManage in '..\..\..\..\..\..\common\UnitWinFireWallManage.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TFormAlarmList, FormAlarmList);
  Application.Run;
end.

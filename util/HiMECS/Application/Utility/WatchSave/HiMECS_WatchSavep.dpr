program HiMECS_WatchSavep;

uses
  Forms,
  HiMECS_WatchSave in 'HiMECS_WatchSave.pas' {WatchSaveF},
  WatchSaveConfig in 'WatchSaveConfig.pas' {WatchSaveConfigF},
  DragDropRecord in '..\..\Source\Common\DragDropRecord.pas',
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  EngineParameterClass in '..\..\Source\Common\EngineParameterClass.pas',
  UnitTestReport in 'UnitTestReport.pas' {FormTestReport},
  RpInfo_Unit in 'setCellPos\RpInfo_Unit.pas' {RpInfo_Frm},
  LocalSheet_Unit in 'setCellPos\LocalSheet_Unit.pas' {LocalSheet_Frm},
  UnitCopyWatchList2 in 'UnitCopyWatchList2.pas' {CopyWatchListF},
  UtilUnit in '..\..\..\..\VisualComm\util\UtilUnit.pas',
  UnitFrameDataSaveAll in '..\CommonFrame\UnitFrameDataSaveAll.pas' {FrameDataSaveAll: TFrame},
  UnitCopyModeMenu in '..\Watch2\UnitCopyModeMenu.pas' {CopyModeMenuF},
  UnitFrameIPCMonitorAll in '..\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitorAll: TFrame},
  UnitParameterManager in '..\Watch2\UnitParameterManager.pas',
  UnitFrameWatchGrid in '..\CommonFrame\UnitFrameWatchGrid.pas' {FrameWatchGrid: TFrame},
  UnitMQConst in '..\..\..\..\..\common\UnitMQConst.pas',
  GpCommandLineParser in '..\..\..\..\..\common\GpDelphiUnit\GpCommandLineParser.pas',
  ExcelUtil in '..\..\Source\Common\ExcelUtil.pas',
  Generics.Legacy in '..\..\..\..\..\common\Generics.Legacy.pas',
  UnitMQTTClass in '..\..\..\..\..\common\UnitMQTTClass.pas',
  UnitWorker4OmniMsgQ in '..\..\..\..\..\common\UnitWorker4OmniMsgQ.pas',
  DataSave2FileOmniThread in '..\..\..\..\..\common\DataSave2FileOmniThread.pas',
  UnitFileUtil in '..\..\..\..\..\common\UnitFileUtil.pas',
  CommonUtil in '..\ModbusComm_kumo\common\CommonUtil.pas',
  UnitCaptionInput in '..\Watch2\UnitCaptionInput.pas' {CaptionInputF};

{$R *.res}

begin
  //system.ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TWatchSaveF, WatchSaveF);
  Application.CreateForm(TCaptionInputF, CaptionInputF);
  Application.Run;
end.

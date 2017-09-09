program HiMECS_Watch2p;

uses
  CodeSiteLogging,
  Forms,
  HiMECS_Watch2 in 'HiMECS_Watch2.pas' {WatchF2},
  WatchConfig2 in 'WatchConfig2.pas' {WatchConfigF},
  DragDropRecord in '..\..\Source\Common\DragDropRecord.pas',
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  EngineParameterClass in '..\..\Source\Common\EngineParameterClass.pas',
  SuperStream in '..\..\..\..\..\Common\DeCAL\SuperStream.pas',
  UnitAxisSelect in 'UnitAxisSelect.pas' {AxisSelectF},
  UnitEngParamConfig in '..\..\Source\Forms\UnitEngParamConfig.pas' {EngParamItemConfigForm},
  UnitAlarmConfigClass in '..\..\Source\Common\UnitAlarmConfigClass.pas',
  UnitAlarmConfig in 'UnitAlarmConfig.pas' {AlarmConfigF},
  UnitAlarmList in 'UnitAlarmList.pas',
  WatchConst2 in 'WatchConst2.pas',
  UnitCopyWatchList in 'UnitCopyWatchList.pas' {CopyWatchListF},
  frmMainInterface in '..\..\..\..\VisualComm\frmMainInterface.pas',
  pjhDesignCompIntf in '..\..\..\..\VisualComm\Component\pjhDesignCompIntf.pas',
  UtilUnit in '..\..\..\..\VisualComm\util\UtilUnit.pas',
  DesignFormConfigClass in 'common\DesignFormConfigClass.pas',
  pjhPanel in 'pjhPanel.pas',
  frmDocInterface in '..\..\..\..\VisualComm\frmDocInterface.pas',
  HiMECSWatchCommon in 'common\HiMECSWatchCommon.pas',
  ScrollPanel2 in '..\..\..\..\VisualComm\Component\ScrollPanel2.pas',
  UnitSetMatrix in '..\..\Source\Forms\UnitSetMatrix.pas' {SetMatrixForm},
  UnitCaptionInput in 'UnitCaptionInput.pas' {CaptionInputF},
  UnitFrameTileList in '..\CommonFrame\UnitFrameTileList.pas' {Frame1: TFrame},
  IPCThrd_HiMECS_MDI in '..\..\Source\Common\IPCThrd_HiMECS_MDI.pas',
  CommonUtil in '..\ModbusComm_kumo\common\CommonUtil.pas',
  UnitCopyModeMenu in 'UnitCopyModeMenu.pas' {CopyModeMenuF},
  UnitParameterManager in 'UnitParameterManager.pas',
  WindowUtil in '..\..\..\..\..\common\WindowUtil.pas',
  UnitFrameWatchGrid in '..\CommonFrame\UnitFrameWatchGrid.pas' {FrameWatchGrid: TFrame},
  IPCMonitorInterface in '..\CommonFrame\IPCMonitorInterface.pas',
  UnitFrameIPCMonitorAll in '..\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitorAll: TFrame},
  UnitSelectUser in '..\..\Source\Forms\UnitSelectUser.pas' {SelectUserF},
  GpCommandLineParser in '..\..\..\..\..\common\GpDelphiUnit\GpCommandLineParser.pas',
  Generics.Legacy in '..\..\..\..\..\common\Generics.Legacy.pas',
  UnitSynLog in '..\..\..\..\..\common\UnitSynLog.pas';

{$R *.res}

begin
  //system.ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  {$IFDEF USECODESITE}
    //CodeSite.Enabled := True;
//    CodeSite.Enabled := CodeSite.Installed;
//
//    if CodeSite.Enabled then
//    begin
//      {Destination := TCodeSiteDestination.Create(Application);
//      Destination.LogFile.Active := True;
//      Destination.LogFile.FileName :=
//        ChangeFileExt(ExtractFileName(Application.ExeName), '.csl');
//      Destination.LogFile.FilePath := '$(MyDocs)\My CodeSite Files\Logs\';
//      CodeSite.Destination := Destination;  }
//      CodeSite.Clear;
//    end;
  {$ENDIF}
  //Application.ShowMainForm := False;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TWatchF2, WatchF2);
  Application.Run;
end.

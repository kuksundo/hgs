program PipeFlowDesigneR;

uses
  {$IFDEF USECODESITE}
  CodeSiteLogging,
  {$ENDIF }
  {$IfDef USE_REGCODE}
  UnitRegistrationUtil,
  {$EndIf USE_REGCODE}
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
  Generics.Legacy in '..\..\..\..\..\common\Generics.Legacy.pas',
  UnitSynLog in '..\..\..\..\..\common\UnitSynLog.pas',
  XBaloon_Util in '..\..\..\..\..\common\XBaloon_Util.pas',
  UnitHGSCurriculumData in '..\..\..\..\GSManage\CertManage\UnitHGSCurriculumData.pas',
  XBaloon in '..\..\..\..\..\..\vcl\util\XBaloon.pas',
  VarRecUtils in '..\..\..\..\..\common\openarr\source\VarRecUtils.pas',
  UnitVesselData in '..\..\..\..\GSManage\VesselList\UnitVesselData.pas',
  UnitBase64Util in '..\..\..\..\..\common\UnitBase64Util.pas';

{$R *.res}

begin
  {$IfDef USE_REGCODE}
    //UnitCryptUtil.EncryptString_Syn('{58674DAE-2D43-446A-8E93-637B8B8290D6}', True)
    CheckRegistration('Ye5EzlHjcmALBzzRUR3XCsKsLgVWsKiZ7OpMoIaCgmQYK4hx3gWkxezsIS5OncJHSW1yvESjyIUX1kKrFDiQmw==', [crmHTTP]);
  {$EndIf USE_REGCODE}
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

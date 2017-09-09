program HiMECS;

uses
  RunOne_HiMECS,
  Forms,
  System.SysUtils,
  CodeSiteLogging,
  MainUnit in 'Forms\MainUnit.pas' {MainForm},
  JvgXMLSerializer_Encrypt in 'Common\JvgXMLSerializer_Encrypt.pas',
  HiMECSUserClass in 'Common\HiMECSUserClass.pas',
  EngineBaseClass in 'Common\EngineBaseClass.pas',
  MenuBaseClass in 'Common\MenuBaseClass.pas',
  HiMECSConst in 'Common\HiMECSConst.pas',
  HiMECSInterface in 'Common\HiMECSInterface.pas',
  BaseConfigCollect in 'Common\BaseConfigCollect.pas',
  VesselBaseClass in 'Common\VesselBaseClass.pas',
  CommonUtil in '..\Utility\ModbusComm_kumo\common\CommonUtil.pas',
  UnitConfig in 'Forms\UnitConfig.pas' {ConfigF},
  EngineParameterClass in 'Common\EngineParameterClass.pas',
  UnitParamList in 'Forms\UnitParamList.pas' {FormParamList},
  EngineConst in 'Common\EngineConst.pas',
  UnitEngParamConfig in 'Forms\UnitEngParamConfig.pas' {EngParamItemConfigForm},
  UnitLogin in 'Forms\UnitLogin.pas' {FrmLogin},
  UnitSelectProject in 'Forms\UnitSelectProject.pas' {SelectProjectForm},
  UnitSetMatrix in 'Forms\UnitSetMatrix.pas' {SetMatrixForm},
  ProjectFileClass in 'Common\ProjectFileClass.pas',
  UnitConfigProjectFile in 'Forms\UnitConfigProjectFile.pas' {ConfigProjectFileForm},
  UnitSetScalarValue in 'Forms\UnitSetScalarValue.pas',
  UnitDummyForm in 'Forms\UnitDummyForm.pas' {DummyForm},
  HiMECSMonitorListClass in 'Common\HiMECSMonitorListClass.pas',
  HiMECSExeCollect in 'Common\HiMECSExeCollect.pas',
  HiMECSConfigCollect in 'Common\HiMECSConfigCollect.pas',
  AutoRunClass in 'Common\AutoRunClass.pas',
  MonitornewApp_Unit in '..\Utility\MON_LAUNCHER\Source\Forms\Common\MonitornewApp_Unit.pas' {newMonApp_Frm},
  CommnewApp_Unit in '..\Utility\MON_LAUNCHER\Source\Forms\Common\CommnewApp_Unit.pas' {newCommApp_Frm},
  UnitTileConfig in 'Forms\UnitTileConfig.pas' {TileConfigF},
  IPCThrd_HiMECS_MDI in 'Common\IPCThrd_HiMECS_MDI.pas',
  KillProcessListClass in 'Common\KillProcessListClass.pas',
  UnitKillProcessList in 'Forms\UnitKillProcessList.pas' {KillProcessListF},
  DragDropRecord in 'Common\DragDropRecord.pas',
  UnitFrameWatchGrid in '..\Utility\CommonFrame\UnitFrameWatchGrid.pas' {FrameWatchGrid: TFrame},
  UnitFrameIPCMonitorAll in '..\Utility\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitor: TFrame},
  UnitFrameTileList in '..\Utility\CommonFrame\UnitFrameTileList.pas' {Frame1: TFrame},
  UnitSelectUser in 'Forms\UnitSelectUser.pas' {SelectUserF},
  HiMECSManualClass in 'Common\HiMECSManualClass.pas',
  UnitPdfView in 'Forms\UnitPdfView.pas' {PDFViewF},
  UnitRegistration in '..\..\..\..\common\UnitRegistration.pas' {RegistrationF},
  UnitRegistrationClass in '..\..\..\..\common\UnitRegistrationClass.pas',
  uSMBIOS in '..\..\..\..\common\TSmBios\Common\uSMBIOS.pas',
  UnitSystemUtil in '..\..\..\..\common\UnitSystemUtil.pas';

{$R *.res}

//var
  //Destination: TCodeSiteDestination;
begin
  //system.ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  {$IFDEF USECODESITE}
    //CodeSite.Enabled := True;
    CodeSite.Enabled := CodeSite.Installed;

    if CodeSite.Enabled then
    begin
      {Destination := TCodeSiteDestination.Create(Application);
      Destination.LogFile.Active := True;
      Destination.LogFile.FileName :=
        ChangeFileExt(ExtractFileName(Application.ExeName), '.csl');
      Destination.LogFile.FilePath := '$(MyDocs)\My CodeSite Files\Logs\';
      CodeSite.Destination := Destination;  }
      CodeSite.Clear;
    end;
  {$ELSE}
    CodeSite.Enabled := False;
  {$ENDIF}
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

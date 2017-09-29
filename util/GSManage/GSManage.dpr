program GSManage;

uses
  RunOne_HiMECS,
  Forms,
  System.SysUtils,
  CodeSiteLogging,
  GSMainUnit in 'GSMainUnit.pas' {MainForm},
  JvgXMLSerializer_Encrypt in '..\HiMECS\Application\Source\Common\JvgXMLSerializer_Encrypt.pas',
  HiMECSUserClass in '..\HiMECS\Application\Source\Common\HiMECSUserClass.pas',
  EngineBaseClass in '..\HiMECS\Application\Source\Common\EngineBaseClass.pas',
  MenuBaseClass in '..\HiMECS\Application\Source\Common\MenuBaseClass.pas',
  HiMECSConst in '..\HiMECS\Application\Source\Common\HiMECSConst.pas',
  HiMECSInterface in '..\HiMECS\Application\Source\Common\HiMECSInterface.pas',
  BaseConfigCollect in '..\HiMECS\Application\Source\Common\BaseConfigCollect.pas',
  VesselBaseClass in '..\HiMECS\Application\Source\Common\VesselBaseClass.pas',
  CommonUtil in '..\HiMECS\Application\Utility\ModbusComm_kumo\common\CommonUtil.pas',
  UnitConfig in '..\HiMECS\Application\Source\Forms\UnitConfig.pas' {ConfigF},
  EngineParameterClass in '..\HiMECS\Application\Source\Common\EngineParameterClass.pas',
  UnitParamList in '..\HiMECS\Application\Source\Forms\UnitParamList.pas' {FormParamList},
  EngineConst in '..\HiMECS\Application\Source\Common\EngineConst.pas',
  UnitEngParamConfig in '..\HiMECS\Application\Source\Forms\UnitEngParamConfig.pas' {EngParamItemConfigForm},
  UnitLogin in '..\HiMECS\Application\Source\Forms\UnitLogin.pas' {FrmLogin},
  UnitSelectProject in '..\HiMECS\Application\Source\Forms\UnitSelectProject.pas' {SelectProjectForm},
  UnitSetMatrix in '..\HiMECS\Application\Source\Forms\UnitSetMatrix.pas' {SetMatrixForm},
  ProjectFileClass in '..\HiMECS\Application\Source\Common\ProjectFileClass.pas',
  UnitConfigProjectFile in '..\HiMECS\Application\Source\Forms\UnitConfigProjectFile.pas' {ConfigProjectFileForm},
  UnitSetScalarValue in '..\HiMECS\Application\Source\Forms\UnitSetScalarValue.pas',
  UnitDummyForm in '..\HiMECS\Application\Source\Forms\UnitDummyForm.pas' {DummyForm},
  HiMECSMonitorListClass in '..\HiMECS\Application\Source\Common\HiMECSMonitorListClass.pas',
  HiMECSExeCollect in '..\HiMECS\Application\Source\Common\HiMECSExeCollect.pas',
  HiMECSConfigCollect in '..\HiMECS\Application\Source\Common\HiMECSConfigCollect.pas',
  AutoRunClass in '..\HiMECS\Application\Source\Common\AutoRunClass.pas',
  MonitornewApp_Unit in '..\HiMECS\Application\Utility\MON_LAUNCHER\Source\Forms\Common\MonitornewApp_Unit.pas' {newMonApp_Frm},
  CommnewApp_Unit in '..\HiMECS\Application\Utility\MON_LAUNCHER\Source\Forms\Common\CommnewApp_Unit.pas' {newCommApp_Frm},
  UnitTileConfig in '..\HiMECS\Application\Source\Forms\UnitTileConfig.pas' {TileConfigF},
  IPCThrd_HiMECS_MDI in '..\HiMECS\Application\Source\Common\IPCThrd_HiMECS_MDI.pas',
  KillProcessListClass in '..\HiMECS\Application\Source\Common\KillProcessListClass.pas',
  UnitKillProcessList in '..\HiMECS\Application\Source\Forms\UnitKillProcessList.pas' {KillProcessListF},
  DragDropRecord in '..\HiMECS\Application\Source\Common\DragDropRecord.pas',
  UnitFrameWatchGrid in '..\HiMECS\Application\Utility\CommonFrame\UnitFrameWatchGrid.pas' {FrameWatchGrid: TFrame},
  UnitFrameIPCMonitorAll in '..\HiMECS\Application\Utility\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitor: TFrame},
  UnitFrameTileList in '..\HiMECS\Application\Utility\CommonFrame\UnitFrameTileList.pas' {Frame1: TFrame},
  UnitSelectUser in '..\HiMECS\Application\Source\Forms\UnitSelectUser.pas' {SelectUserF},
  HiMECSManualClass in '..\HiMECS\Application\Source\Common\HiMECSManualClass.pas',
  UnitPdfView in '..\HiMECS\Application\Source\Forms\UnitPdfView.pas' {PDFViewF},
  UnitRegistration in '..\..\common\UnitRegistration.pas' {RegistrationF},
  UnitRegistrationClass in '..\..\common\UnitRegistrationClass.pas',
  uSMBIOS in '..\..\common\TSmBios\Common\uSMBIOS.pas',
  UnitSystemUtil in '..\..\common\UnitSystemUtil.pas',
  FrmInqManage in 'FrmInqManage.pas' {InquiryF};

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

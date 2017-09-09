program DataSaveAll;

uses
  Vcl.Forms,
  DataSave2FileThread in 'DataSave2FileThread.pas',
  DataSave2DBThread in 'DataSave2DBThread.pas',
  DataSaveAll_ConfigUnit in 'DataSaveAll_ConfigUnit.pas' {FrmDataSaveAllConfig},
  DataSaveAll_Const in 'DataSaveAll_Const.pas',
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  EngineParameterClass in '..\..\Source\Common\EngineParameterClass.pas',
  TagNameListView in 'TagNameListView.pas' {TagInfoEditorDlg},
  UnitFrameDataSaveAll in '..\CommonFrame\UnitFrameDataSaveAll.pas' {FrameDataSaveAll: TFrame},
  DataSaveAll_FrameUnit in 'DataSaveAll_FrameUnit.pas' {DataSaveAllF},
  UnitFrameIPCMonitorAll in '..\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitor: TFrame},
  ElecPowerCalcClass in '..\..\..\..\..\common\ElecPowerCalcClass.pas',
  GpCommandLineParser in '..\..\..\..\..\common\GpDelphiUnit\GpCommandLineParser.pas',
  UnitSynLog in '..\..\..\..\..\common\UnitSynLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataSaveAllF, DataSaveAllF);
  Application.Run;
end.

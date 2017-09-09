program ECS_DataSave_Avat;

uses
  Forms,
  ECS_DataSave_Main in 'ECS_DataSave_Main.pas' {DataSaveMain},
  DataSave2FileThread in '..\..\HiMECS\Application\Utility\DataSaveAll\DataSave2FileThread.pas',
  DataSave2DBThread in '..\..\HiMECS\Application\Utility\DataSaveAll\DataSave2DBThread.pas',
  DataSaveConfig in 'DataSaveConfig.pas' {SaveConfigF},
  DataSaveConst in 'DataSaveConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataSaveMain, DataSaveMain);
  Application.Run;
end.

program ECS_DataSave_Drillship;

uses
  Forms,
  ECS_DataSave_Main_Drillship in 'ECS_DataSave_Main_Drillship.pas' {DataSaveMain},
  DataSaveConfig in 'DataSaveConfig.pas' {SaveConfigF},
  DataSaveConst in 'DataSaveConst.pas',
  DataSave2FileThread_drillship in 'DataSave2FileThread_drillship.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataSaveMain, DataSaveMain);
  Application.Run;
end.

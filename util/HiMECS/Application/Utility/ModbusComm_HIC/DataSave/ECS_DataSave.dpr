program ECS_DataSave;

uses
  Forms,
  ECS_DataSave_Main in 'ECS_DataSave_Main.pas' {DataSaveMain},
  DataSaveConfig in 'DataSaveConfig.pas' {SaveConfigF},
  DataSaveConst in 'DataSaveConst.pas',
  HiMECSConst in '..\..\..\Source\Common\HiMECSConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataSaveMain, DataSaveMain);
  Application.Run;
end.

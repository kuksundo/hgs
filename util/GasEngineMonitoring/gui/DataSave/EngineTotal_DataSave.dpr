program EngineTotal_DataSave;

uses
  Forms,
  EngineTotal_DataSave_Main in 'EngineTotal_DataSave_Main.pas' {DataSaveMain},
  DataSaveConst in 'DataSaveConst.pas',
  DataSave2FileThread in 'DataSave2FileThread.pas',
  DataSave2DBThread in 'DataSave2DBThread.pas',
  DataSaveConfig in 'DataSaveConfig.pas' {SaveConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataSaveMain, DataSaveMain);
  Application.CreateForm(TSaveConfigF, SaveConfigF);
  Application.CreateForm(TSaveConfigF, SaveConfigF);
  Application.Run;
end.

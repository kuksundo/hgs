program HiMECS_Watchp;

uses
  Forms,
  HiMECS_Watch in 'HiMECS_Watch.pas' {WatchF1},
  WatchConfig in 'WatchConfig.pas' {WatchConfigF},
  DragDropRecord in '..\..\Source\Common\DragDropRecord.pas',
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  EngineParameterClass in '..\..\Source\Common\EngineParameterClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TWatchF1, WatchF1);
  Application.Run;
end.

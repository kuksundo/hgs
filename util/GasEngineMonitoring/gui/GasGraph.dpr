program GasGraph;

uses
  Forms,
  GasEngine_Watch in 'GasEngine_Watch.pas' {WatchF},
  Watchonfig in 'Watchonfig.pas' {WatchConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TWatchF, WatchF);
  Application.CreateForm(TWatchConfigF, WatchConfigF);
  Application.Run;
end.

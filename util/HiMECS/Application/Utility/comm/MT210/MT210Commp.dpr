program MT210Commp;

uses
  RunOne_MT210,Forms,
  MT210_Comm in 'MT210_Comm.pas' {MT210ComF},
  MT210ComThread in 'MT210ComThread.pas',
  MT210Config in 'MT210Config.pas' {MT210ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMT210ComF, MT210ComF);
  Application.CreateForm(TMT210ConfigF, MT210ConfigF);
  Application.Run;
end.

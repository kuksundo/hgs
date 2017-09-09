program VideoCodecClient;

uses
  Forms,
  ClientU in 'ClientU.pas' {ClientF},
  CommonU in 'CommonU.pas',
  VideoCoDec in 'VideoCoDec.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientF, ClientF);
  Application.Run;
end.

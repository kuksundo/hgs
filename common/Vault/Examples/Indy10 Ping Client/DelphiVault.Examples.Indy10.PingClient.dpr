program DelphiVault.Examples.Indy10.PingClient;

uses
  Vcl.Forms,
  DelphiVault.Examples.Indy10.PingClient.MainForm in 'DelphiVault.Examples.Indy10.PingClient.MainForm.pas' {frmThreadedPingSample},
  DelphiVault.Indy10.PingClient in '..\..\Source\DelphiVault.Indy10.PingClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmThreadedPingSample, frmThreadedPingSample);
  Application.Run;
end.

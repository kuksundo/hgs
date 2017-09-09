program DelphiVault.Examples.AsyncMethods;

uses
  Vcl.Forms,
  DelphiVault.Examples.AsyncMethods.MainForm in 'DelphiVault.Examples.AsyncMethods.MainForm.pas' {frmAsyncExample},
  DelphiVault.Threading.AsyncMethods in '..\..\Source\DelphiVault.Threading.AsyncMethods.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmAsyncExample, frmAsyncExample);
  Application.Run;
end.

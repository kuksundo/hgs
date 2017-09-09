program DelphiVault.Examples.Windows.ServiceManager;

uses
  Vcl.Forms,
  DelphiVault.Examples.Windows.ServiceManager.MainForm in 'DelphiVault.Examples.Windows.ServiceManager.MainForm.pas' {frmServiceManagerExample},
  DelphiVault.Windows.ServiceManager in '..\..\Source\DelphiVault.Windows.ServiceManager.pas',
  DelphiVault.StringGrid.Helper in '..\..\Source\DelphiVault.StringGrid.Helper.pas',
  DelphiVault.Windows.Menus in '..\..\Source\DelphiVault.Windows.Menus.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmServiceManagerExample, frmServiceManagerExample);
  Application.Run;
end.

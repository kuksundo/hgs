program dynode;

uses
  Forms,
  dnMain in 'dnMain.pas' {frmMain},
  frmProjectOptions in 'frmProjectOptions.pas' {dlgProjectOptions},
  frmEnvironmentOptions in 'frmEnvironmentOptions.pas' {dlgEnvironmentOptions};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdlgProjectOptions, dlgProjectOptions);
  Application.CreateForm(TdlgEnvironmentOptions, dlgEnvironmentOptions);
  Application.Run;
end.

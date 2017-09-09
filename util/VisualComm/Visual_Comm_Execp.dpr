program Visual_Comm_Execp;

uses
  Forms,
  MAIN in 'MAIN.PAS' {MainForm},
  about in 'about.pas' {AboutBox},
  VisualCommExec in 'VisualCommExec.pas' {FrmDoc};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutF, AboutF);
  Application.Run;
end.

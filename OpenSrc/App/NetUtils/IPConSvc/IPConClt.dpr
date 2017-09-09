program IPConClt;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  InitFont,
  Forms,
  CltMain in 'CltMain.pas' {MainForm},
  CltConn in 'CltConn.pas' {ConnForm},
  CltNewSv in 'CltNewSv.pas' {NewServerDialog},
  CSConst in 'CSConst.pas';

{$R *.res}

begin
  Application.Initialize;
{$IF CompilerVersion >= 18.5}
  Application.MainFormOnTaskBar := True;
{$IFEND}
  Application.Title := 'IP Connections Client';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

program NetView;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  InitFont,
  Forms,
  NvMain in 'NvMain.pas' {MainForm},
  NvFind in 'NvFind.pas' {FindDialog},
  NvPing in 'NvPing.pas' {PingDialog},
  NvShdown in 'NvShdown.pas' {ShutdownDialog},
  NvConst in 'NvConst.pas';

{$R *.res}

begin
  Application.Initialize;
{$IF CompilerVersion >= 18.5}
  Application.MainFormOnTaskBar := True;
{$IFEND}
  Application.Title := 'NetView';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
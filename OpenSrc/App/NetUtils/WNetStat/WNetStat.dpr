program WNetStat;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  InitFont,
  Windows,
  Forms,
  NetConst,
  NsMain in 'NsMain.pas' {MainForm},
  NsOptions in 'NsOptions.pas' {OptionsDialog},
  NsConst in 'NsConst.pas';

{$R *.res}

begin
  CreateMutex(nil, True, 'WNetStat');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    MessageBox(0, PChar(SAlreadyRunning), 'WNetStat', MB_OK or MB_ICONINFORMATION);
    Halt;
  end;
  Application.Initialize;
{$IF CompilerVersion >= 18.5}
  Application.MainFormOnTaskBar := True;
{$IFEND}
  Application.Title := 'WNetStat';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

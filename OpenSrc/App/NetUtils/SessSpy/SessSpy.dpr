program SessSpy;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  InitFont,
  Windows,
  Forms,
  SsMain in 'SsMain.pas' {MainForm},
  SsPopup in 'SsPopup.pas' {PopupForm},
  SsConst in 'SsConst.pas';

{$R *.res}

begin
  CreateMutex(nil, True, 'SessSpy');
  if GetLastError = ERROR_ALREADY_EXISTS then
    Halt;
  Application.Initialize;
{$IF CompilerVersion >= 18.5}
  Application.MainFormOnTaskBar := True;
{$IFEND}
  Application.ShowMainForm := False;
  Application.Title := 'SessionSpy';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

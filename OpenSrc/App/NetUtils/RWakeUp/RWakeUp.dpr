program RWakeUp;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  InitFont,
  Windows,
  Forms,
  RwMain in 'RwMain.pas' {MainForm},
  RwNewHst in 'RwNewHst.pas' {NewHostDialog},
  RwSend in 'RwSend.pas' {SendDialog},
  RwOptions in 'RwOptions.pas' {OptionsDialog},
  RwConst in 'RwConst.pas';

{$R *.res}

begin
  CreateMutex(nil, True, 'RWakeUp');
  if GetLastError = ERROR_ALREADY_EXISTS then
    Halt;
  Application.Initialize;
{$IF CompilerVersion >= 18.5}
  Application.MainFormOnTaskBar := True;
{$IFEND}
  Application.Title := 'Remote Wake Up';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
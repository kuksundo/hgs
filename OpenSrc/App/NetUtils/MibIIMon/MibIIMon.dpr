program MibIIMon;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  InitFont,
  Forms,
  MrMain in 'MrMain.pas' {MainForm},
  MrOpts in 'MrOpts.pas' {OptionsDialog},
  MrChild in 'MrChild.pas' {ChildForm},
  MrConst in 'MrConst.pas';

{$R *.res}

begin
  Application.Initialize;
{$IF CompilerVersion >= 18.5}
  Application.MainFormOnTaskBar := True;
{$IFEND}
  Application.Title := 'MIB II Monitor';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

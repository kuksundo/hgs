program SnmpEye;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  InitFont,
  Forms,
  SeMain in 'SeMain.pas' {MainForm},
  SeDetls in 'SeDetls.pas' {DetailsDialog},
  SeOpts in 'SeOpts.pas' {OptionsDialog},
  SeConst in 'SeConst.pas';

{$R *.res}

begin
  Application.Initialize;
{$IF CompilerVersion >= 18.5}
  Application.MainFormOnTaskBar := True;
{$IFEND}
  Application.Title := 'SnmpEye';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

// NOTE: This demo ONLY runs under Windows.

program Mexa7000;

uses
  RunOne_Mexa7000,
  Forms,
  HoribaComponentClasses in 'HoribaComponentClasses.pas',
  Options in 'Options.pas',
  ConfigForm in 'ConfigForm.pas' {ConfigFormF},
  ConfigConst in 'ConfigConst.pas',
  ConfigUtil in 'ConfigUtil.pas',
  MEXA7000_Watch_r1 in 'MEXA7000_Watch_r1.pas' {WatchF2_},
  MainForm_XE2 in 'MainForm_XE2.pas' {Form1},
  HiMECSConst in '..\..\..\Source\Common\HiMECSConst.pas',
  HiMECS_Watch2 in '..\..\Watch2\HiMECS_Watch2.pas' {WatchF2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TWatchF2_, WatchF2_);
  Application.CreateForm(TWatchF2, WatchF2);
  Application.Run;
end.

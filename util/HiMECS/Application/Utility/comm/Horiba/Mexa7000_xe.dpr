// NOTE: This demo ONLY runs under Windows.

program Mexa7000_xe;

uses
  RunOne_Mexa7000, Forms,
  MainForm in 'MainForm.pas' {Form1},
  HoribaComponentClasses in 'HoribaComponentClasses.pas',
  Options in 'Options.pas',
  ConfigForm in 'ConfigForm.pas' {ConfigFormF},
  ConfigConst in 'ConfigConst.pas',
  ConfigUtil in 'ConfigUtil.pas',
  MEXA7000_Watch_r1 in 'MEXA7000_Watch_r1.pas' {WatchF2},
  CircularArray in 'common\CircularArray.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TWatchF2, WatchF2);
  Application.Run;
end.

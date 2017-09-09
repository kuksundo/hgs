program WT1600CommSDI_Manage_XE;

uses
  RunOne_WT1600_Manage, Forms,
  WT1600Main in 'WT1600Main.pas' {WT1600MainF},
  WaitForm in '..\WaitForm.pas' {WaitF},
  WT1600Const in '..\WT1600Const.pas',
  WT1600ComStruct in '..\WT1600ComStruct.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TWT1600MainF, WT1600MainF);
  Application.CreateForm(TWaitF, WaitF);
  Application.Run;
end.

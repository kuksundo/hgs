program WT1600Demop;

uses
  Forms,
  WT1600Demo in 'WT1600Demo.pas' {Form1},
  tmctl_h in 'tmctl_h.pas',
  WT1600Connection in 'WT1600Connection.pas',
  OPCAutomation_TLB in 'OPCAutomation_TLB.pas',
  WT1600Demo_Util in 'WT1600Demo_Util.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

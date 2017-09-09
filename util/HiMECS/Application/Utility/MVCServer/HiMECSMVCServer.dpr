program HiMECSMVCServer;

uses
  Vcl.Forms,
  UnitMainMVCServer in 'UnitMainMVCServer.pas' {Form1},
  HiMECSMVCModel in 'HiMECSMVCModel.pas',
  HiMECSMVCViewModel in 'HiMECSMVCViewModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

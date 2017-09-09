program CommunicationMonitor;

uses
  Forms,
  UnitCommMonitor in 'UnitCommMonitor.pas' {FrmCommMonitor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmCommMonitor, FrmCommMonitor);
  Application.Run;
end.

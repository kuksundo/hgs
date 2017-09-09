program FlowMeter_Monitoring;

uses
  Forms,
  FlowMeter_Form in 'FlowMeter_Form.pas' {Form1},
  Watch in 'Watch.pas' {WatchF};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

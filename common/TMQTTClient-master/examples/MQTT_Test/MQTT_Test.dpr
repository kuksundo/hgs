program MQTT_Test;

uses
  Forms,
  uMain in 'uMain.pas' {fMain},
  SiAuto;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  AApplication.CreateForm(TfMain, fMain);
  i.Enabled := True;
  Application.Run;
end.

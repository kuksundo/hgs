program StompTemplate;

uses
  Vcl.Forms,
  UnitSTOMP4EquipMonitor in 'Monitor\UnitSTOMP4EquipMonitor.pas' {Form8},
  UnitMQConfig in 'UnitMQConfig.pas' {ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

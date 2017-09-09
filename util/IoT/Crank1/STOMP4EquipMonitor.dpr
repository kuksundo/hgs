program STOMP4EquipMonitor;

uses
  Vcl.Forms,
  UnitSTOMP4EquipMonitor in 'Monitor\UnitSTOMP4EquipMonitor.pas' {Form8},
  UnitMQConfig in 'UnitMQConfig.pas' {ConfigF},
  UnitEquipList in 'Monitor\UnitEquipList.pas' {EquipListF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.Run;
end.

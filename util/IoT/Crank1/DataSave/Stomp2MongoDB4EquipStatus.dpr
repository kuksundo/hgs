program Stomp2MongoDB4EquipStatus;

uses
  Vcl.Forms,
  UnitSTOMP2MongoDB4EquipStatus in 'UnitSTOMP2MongoDB4EquipStatus.pas' {Form8},
  UnitMQConfig in 'UnitMQConfig.pas' {ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

program MQTT2Stomp4CrankCrane;

uses
  Vcl.Forms,
  UnitMQTT2STOMPCrankCrane in 'UnitMQTT2STOMPCrankCrane.pas' {Form8},
  UnitCraneStatusClass in 'Common\UnitCraneStatusClass.pas',
  UnitMQTT2STOMPConfig in 'UnitMQTT2STOMPConfig.pas' {ConfigF},
  UnitSynLog in '..\..\..\common\UnitSynLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

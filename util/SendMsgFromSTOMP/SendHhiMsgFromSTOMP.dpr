program SendHhiMsgFromSTOMP;

uses
  Vcl.Forms,
  UnitSendSMSFromSTOMP in 'UnitSendSMSFromSTOMP.pas' {Form8},
  UnitMQConfig in 'UnitMQConfig.pas' {ConfigF},
  UnitHHIMessage in '..\..\common\UnitHHIMessage.pas',
  UnitHhiSMSClass in '..\..\common\UnitHhiSMSClass.pas',
  UnitSTOMPMsg.Events in '..\..\common\LKSLEventUnits\UnitSTOMPMsg.Events.pas',
  UnitSTOMPMsg.EventThreads in '..\..\common\LKSLEventUnits\UnitSTOMPMsg.EventThreads.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

program BuzzerClient;

uses
  Vcl.Forms,
  UnitBuzzerClient in 'UnitBuzzerClient.pas' {Form3},
  UnitBuzzerInterface in 'UnitBuzzerInterface.pas',
  UnitAlarmCollect in '..\..\PMSOPCRest\common\UnitAlarmCollect.pas',
  BaseConfigCollect in '..\..\HiMECS\Application\Source\Common\BaseConfigCollect.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

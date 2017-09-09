program Project4;

uses
  Vcl.Forms,
  Unit4 in 'Unit4.pas' {Form4},
  UnitAlarmReportInterface in '..\Common\UnitAlarmReportInterface.pas',
  UnitAlarmConst in '..\Common\UnitAlarmConst.pas',
  HHI_WebService in '..\..\..\..\..\DPMS\CommonUtil\HHI_WebService.pas',
  UnitHHIMessage in '..\..\..\..\..\DPMS\CommonUtil\UnitHHIMessage.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

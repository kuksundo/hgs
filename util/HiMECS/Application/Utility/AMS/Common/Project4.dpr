program Project4;

uses
  Vcl.Forms,
  Unit4 in '..\test\Unit4.pas' {Form4},
  UnitAlarmReportInterface in 'UnitAlarmReportInterface.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

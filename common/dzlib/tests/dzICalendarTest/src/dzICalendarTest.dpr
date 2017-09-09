program dzICalendarTest;

uses
  Forms,
  w_dzICalendarTest in 'w_dzICalendarTest.pas' {Form1},
  u_dzICalendar in '..\..\..\src\u_dzICalendar.pas',
  u_dzICalDuration in '..\..\..\src\u_dzICalDuration.pas',
  u_dzICalParser in '..\..\..\src\u_dzICalParser.pas',
  u_dzNullableDate in '..\..\..\src\u_dzNullableDate.pas',
  u_dzNullableTime in '..\..\..\src\u_dzNullableTime.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

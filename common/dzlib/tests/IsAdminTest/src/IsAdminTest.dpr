program IsAdminTest;

uses
  Forms,
  w_IsAdminTest in 'w_IsAdminTest.pas' {f_IsAdminTest};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tf_IsAdminTest, f_IsAdminTest);
  Application.Run;
end.

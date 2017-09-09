program EMPL_Prj;

uses
  Forms,
  MF_EMPL in 'MF_EMPL.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

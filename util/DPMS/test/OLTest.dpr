program OLTest;

uses
  Vcl.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  UnitOutLookUtil in '..\..\..\common\UnitOutLookUtil.pas',
  Main in 'Main.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

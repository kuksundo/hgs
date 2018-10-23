program Project2;

uses
  Vcl.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  SynCommons in '..\..\..\common\mORMot\SynCommons.pas',
  UnitmORMotUtil in '..\..\..\common\UnitmORMotUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

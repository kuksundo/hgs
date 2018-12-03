program GetMD5;

uses
  Vcl.Forms,
  FrmGetMD5 in 'FrmGetMD5.pas' {Form3},
  UnitCryptUtil in '..\..\..\common\UnitCryptUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

program GetSHA256;

uses
  Vcl.Forms,
  FrmSHA256 in 'FrmSHA256.pas' {Form4},
  Bcrypt in '..\..\..\OpenSrc\bcrypt-for-delphi-master\Bcrypt.pas',
  SCrypt in '..\..\..\OpenSrc\scrypt-for-delphi-master\SCrypt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

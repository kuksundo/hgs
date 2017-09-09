program PstFileReader;

uses
  Vcl.Forms,
  UnitPstFileReaderMainForm in 'UnitPstFileReaderMainForm.pas' {Form2},
  Redemption_TLB in 'C:\Users\Administrator\Documents\RAD Studio\12.0\Imports\Redemption_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

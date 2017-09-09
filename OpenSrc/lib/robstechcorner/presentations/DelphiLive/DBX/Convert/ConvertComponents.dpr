program ConvertComponents;

uses
  Forms,
  uConvertMainForm in 'uConvertMainForm.pas' {Form3},
  uProcessFiles in 'uProcessFiles.pas',
  uFileProcess in 'uFileProcess.pas',
  uPASUnit in 'uPASUnit.pas',
  uDFMParser in 'uDFMParser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

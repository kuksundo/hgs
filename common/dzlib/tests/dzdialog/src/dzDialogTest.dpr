program dzDialogTest;

uses
  Forms,
  w_dzDialogText in 'w_dzDialogText.pas' {f_dzDialogTest},
  w_dzDialog in '..\..\..\forms\w_dzDialog.pas' {f_dzDialog},
  u_dzTranslator in '..\..\..\src\u_dzTranslator.pas',
  u_dzVclUtils in '..\..\..\src\u_dzVclUtils.pas',
  u_dzConvertUtils in '..\..\..\src\u_dzConvertUtils.pas',
  u_dzStringUtils in '..\..\..\src\u_dzStringUtils.pas',
  u_dzClassUtils in '..\..\..\src\u_dzClassUtils.pas',
  u_dzMiscUtils in '..\..\..\src\u_dzMiscUtils.pas',
  u_dzFileUtils in '..\..\..\src\u_dzFileUtils.pas',
  u_dzDateUtils in '..\..\..\src\u_dzDateUtils.pas',
  u_dzNullableTypesUtils in '..\..\..\src\u_dzNullableTypesUtils.pas',
  u_dzVariantUtils in '..\..\..\src\u_dzVariantUtils.pas',
  u_dzFileStreams in '..\..\..\src\u_dzFileStreams.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tf_dzDialogTest, f_dzDialogTest);
  Application.Run;
end.

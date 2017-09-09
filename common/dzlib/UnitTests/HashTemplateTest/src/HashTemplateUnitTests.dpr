program HashTemplateUnitTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options 
  to use the console test runner.  Otherwise the GUI test runner will be used by 
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}



uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  Testu_dzHashTemplateTest in 'Testu_dzHashTemplateTest.pas',
  u_MyItem in '..\..\..\TemplateExamples\u_MyItem.pas',
  u_MyItemHash in '..\..\..\TemplateExamples\u_MyItemHash.pas';

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.


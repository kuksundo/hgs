program QueueTemplatesUnitTests;
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
  Testu_dzQueueTemplateTest in 'Testu_dzQueueTemplateTest.pas',
  u_MyItem in '..\..\..\TemplateExamples\u_MyItem.pas',
  u_MyItemQueue in '..\..\..\TemplateExamples\u_MyItemQueue.pas';

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.


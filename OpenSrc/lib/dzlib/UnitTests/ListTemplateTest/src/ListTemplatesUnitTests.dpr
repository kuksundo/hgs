program ListTemplatesUnitTests;
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
  u_dzQuicksort in '..\..\..\src\u_dzQuicksort.pas',
  i_MyItemSortedList in '..\..\..\TemplateExamples\i_MyItemSortedList.pas',
  u_MyItemList in '..\..\..\TemplateExamples\u_MyItemList.pas',
  u_MyItemSortedList in '..\..\..\TemplateExamples\u_MyItemSortedList.pas',
  u_MyItem in '..\..\..\TemplateExamples\u_MyItem.pas',
  i_MyItemList in '..\..\..\TemplateExamples\i_MyItemList.pas',
  u_MyItemIntList in '..\..\..\TemplateExamples\u_MyItemIntList.pas',
  u_MyItemIntSortedList in '..\..\..\TemplateExamples\u_MyItemIntSortedList.pas',
  u_MyItemQueue in '..\..\..\TemplateExamples\u_MyItemQueue.pas',
  Testu_dzListTemplateTest in 'Testu_dzListTemplateTest.pas';

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.


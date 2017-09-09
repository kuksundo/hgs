program CmdLineParserTest;
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
  u_dzTranslator in '..\..\dzlib\src\u_dzTranslator.pas',
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  u_dzCmdLineParser_UnitTest in 'u_dzCmdLineParser_UnitTest.pas',
  u_dzGetOpt in '..\src\u_dzGetOpt.pas',
  u_dzOptionDescList in '..\src\u_dzOptionDescList.pas',
  u_dzParamDescList in '..\src\u_dzParamDescList.pas',
  u_dzParamFoundList in '..\src\u_dzParamFoundList.pas',
  u_dzOptionNameList in '..\src\u_dzOptionNameList.pas',
  u_dzOptionFoundList in '..\src\u_dzOptionFoundList.pas',
  u_dzGetOpt_UnitTest in 'u_dzGetOpt_UnitTest.pas',
  u_dzCmdLineParserStates in '..\src\u_dzCmdLineParserStates.pas',
  u_dzCmdLineParser in '..\src\u_dzCmdLineParser.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.


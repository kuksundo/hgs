program DUnitTest_dzFileUtils;
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
  u_dzFileUtils in '..\..\src\u_dzFileUtils.pas',
  Testu_dzFileUtils in 'Testu_dzFileUtils.pas',
  u_dzMiscUtils in '..\..\src\u_dzMiscUtils.pas',
  u_dzStringUtils in '..\..\src\u_dzStringUtils.pas',
  u_dzConvertUtils in '..\..\src\u_dzConvertUtils.pas',
  u_dzTranslator in '..\..\src\u_dzTranslator.pas',
  u_dzDateUtils in '..\..\src\u_dzDateUtils.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.


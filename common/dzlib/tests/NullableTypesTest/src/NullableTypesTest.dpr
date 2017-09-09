program NullableTypesTest;
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
  u_NullableTypesTest in 'u_NullableTypesTest.pas',
  u_dzNullableTypesUtils in '..\..\..\src\u_dzNullableTypesUtils.pas',
  u_dzNullableDouble in '..\..\..\src\u_dzNullableDouble.pas',
  u_dzNullableInteger in '..\..\..\src\u_dzNullableInteger.pas',
  u_dzNullableInt64 in '..\..\..\src\u_dzNullableInt64.pas',
  u_dzNullableSingle in '..\..\..\src\u_dzNullableSingle.pas',
  u_dzNullableExtended in '..\..\..\src\u_dzNullableExtended.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.


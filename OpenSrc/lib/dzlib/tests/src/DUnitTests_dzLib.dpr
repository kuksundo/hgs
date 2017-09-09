program DUnitTests_dzLib;
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
  u_dzUnitTestUtils in '..\..\src\u_dzUnitTestUtils.pas',
  u_dzVariantUtils in '..\..\src\u_dzVariantUtils.pas',
  Testu_dzConvertUtils in 'Testu_dzConvertUtils.pas',
  Testu_dzDateUtils in 'Testu_dzDateUtils.pas',
  u_dzClassUtils in '..\..\src\u_dzClassUtils.pas',
  u_dzDateUtils in '..\..\src\u_dzDateUtils.pas',
  Testu_dzStringUtils in 'Testu_dzStringUtils.pas',
  Testu_dzMultiWriteSingleReadLockFreeQueue in 'Testu_dzMultiWriteSingleReadLockFreeQueue.pas',
  u_dzMultiWriteSingleReadLockFreeQueue in '..\..\lockfree\u_dzMultiWriteSingleReadLockFreeQueue.pas',
  u_dzRecordArray in '..\..\src\u_dzRecordArray.pas',
  Testu_dzRecordArray in 'Testu_dzRecordArray.pas';

{$R *.RES}

begin
  IsMultithread := true;
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.


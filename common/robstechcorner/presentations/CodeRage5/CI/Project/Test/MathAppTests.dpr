program MathAppTests;
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
  FastMM4,
  Sysutils,
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  TestMathClass in 'TestMathClass.pas',
  MathClass in '..\MathClass.pas',
  XMLTestRunner in 'C:\Program Files\Embarcadero\RAD Studio\8.0\source\dUnit\Contrib\XMLReporting\XMLTestRunner.pas';

{$R *.RES}

var
 XmlFile : String;    // This is a test change
begin

  Application.Initialize;
  if IsConsole then
  begin
      if ParamCount = 1 then
        XmlFile := ParamStr(1)
      else
        XmlFile := ExtractFilePath(ParamStr(0)) + DEFAULT_FILENAME;
      XMLTestRunner.RunRegisteredTests(XmlFile);
  //  with TextTestRunner.RunRegisteredTests do
  //    Free
  end
  else
    GUITestRunner.RunRegisteredTests;
end.


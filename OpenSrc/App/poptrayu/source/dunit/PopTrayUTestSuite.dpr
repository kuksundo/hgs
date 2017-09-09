// Uncomment the following directive to create a console application
// or leave commented to create a GUI application... 
// {$APPTYPE CONSOLE}

program PopTrayUTestSuite;

uses
  TestFramework,
  Vcl.Forms,
  GUITestRunner,
  TextTestRunner,
  rcUtilsTester in 'rcUtilsTester.pas',
  uMailItemsTests in 'uMailItemsTests.pas';

{$R *.RES}

begin
  Application.Initialize;

{$IFDEF LINUX}
  QGUITestRunner.RunRegisteredTests;
{$ELSE}
  if System.IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
{$ENDIF}

end.


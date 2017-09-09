{ program xmltest - a simple NativeXml tester }
program xmltest;
uses
  Forms, xmltestmain in 'xmltestmain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

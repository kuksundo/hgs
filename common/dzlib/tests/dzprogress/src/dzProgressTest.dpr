program dzProgressTest;

uses
  Forms,
  w_dzProgressTest in 'w_dzProgressTest.pas' {f_dzProgressTest},
  w_dzProgress in '..\..\..\forms\w_dzProgress.pas' {f_dzProgress},
  w_dzDialog in '..\..\..\forms\w_dzDialog.pas' {f_dzDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tf_dzProgressTest, f_dzProgressTest);
  Application.Run;
end.

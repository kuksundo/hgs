program HotKeyP;

uses
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'CoolTrayIcon Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

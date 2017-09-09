program AutoUpdate;

uses
  Forms,
  UnitAutoUpdateMain in 'UnitAutoUpdateMain.pas' {Form1},
  UnitAutoUpdateproxy in 'UnitAutoUpdateproxy.pas' {proxy},
  UnitAutoUpdateSelComp in 'UnitAutoUpdateSelComp.pas' {selcomp},
  AutoUpdateClass in 'Common\AutoUpdateClass.pas',
  UnitAutoUpdateConfig in 'UnitAutoUpdateConfig.pas' {AutoUpdateConfigF};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

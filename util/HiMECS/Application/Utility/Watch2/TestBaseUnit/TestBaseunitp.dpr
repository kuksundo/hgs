program TestBaseunitp;

uses
  Vcl.Forms,
  UnitWatchBase in '..\..\CommonFrame\UnitWatchBase.pas' {HiMECSWatchBaseForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THiMECSWatchBaseForm, HiMECSWatchBaseForm);
  Application.Run;
end.

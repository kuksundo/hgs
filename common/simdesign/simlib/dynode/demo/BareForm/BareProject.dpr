program BareProject;

uses
  Forms,
  Bare in 'Bare.pas' {frmBare};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBare, frmBare);
  Application.Run;
end.

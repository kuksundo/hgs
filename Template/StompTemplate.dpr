program StompTemplate;

uses
  Vcl.Forms,
  UnitSTOMPTemplate in 'UnitSTOMPTemplate.pas' {Form8},
  UnitSTOMPConfig in 'UnitSTOMPConfig.pas' {ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

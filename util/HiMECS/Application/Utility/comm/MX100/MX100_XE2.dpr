program MX100_XE2;



uses
  Vcl.Forms,
  MX100Config in 'MX100Config.pas' {MX100ConfigForm},
  MX100DAO in 'MX100DAO.pas' {MX100DM: TDataModule},
  MX100Main in 'MX100Main.pas' {MX100MainForm},
  UnitDAQMX in 'UnitDAQMX.pas',
  MX100Const in 'MX100Const.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMX100DM, MX100DM);
  Application.CreateForm(TMX100MainForm, MX100MainForm);
  Application.Run;
end.

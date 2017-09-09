program TaskRecoveryp;

uses
  Vcl.Forms,
  UnitTaskRecovery in 'UnitTaskRecovery.pas' {TaskRecoveryF},
  UnitDataModule in 'UnitDataModule.pas' {DM1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTaskRecoveryF, TaskRecoveryF);
  Application.CreateForm(TDM1, DM1);
  Application.Run;
end.

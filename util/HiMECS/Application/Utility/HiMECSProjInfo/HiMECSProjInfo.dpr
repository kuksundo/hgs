program HiMECSProjInfo;

uses
  Vcl.Forms,
  UnitHiMECSProjInfo in 'UnitHiMECSProjInfo.pas' {Form2},
  VesselBaseClass in '..\..\Source\Common\VesselBaseClass.pas',
  UnitProjDM in 'UnitProjDM.pas' {DM1: TDataModule},
  EngineBaseClass in '..\..\Source\Common\EngineBaseClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TDM1, DM1);
  Application.Run;
end.

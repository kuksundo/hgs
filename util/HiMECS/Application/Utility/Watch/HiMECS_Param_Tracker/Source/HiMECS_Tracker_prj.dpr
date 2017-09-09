program HiMECS_Tracker_prj;

uses
  Forms,
  MainUnit in 'Form\MainUnit\MainUnit.pas' {Main_Frm},
  DataModule in 'Form\DataModule\DataModule.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain_Frm, Main_Frm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.

program HiTEMS_FUEL;

uses
  Vcl.Forms,
  fuelIn_Unit in 'Forms\fuelIn_Unit.pas' {fuelIn_Frm},
  devNo_Unit in 'Forms\Assist_Form\devNo_Unit.pas' {devNo_Frm},
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  fuelPrice_Unit in 'Forms\fuelPrice_Unit.pas' {fuelPrice_Frm},
  fuelMain_Unit in 'Forms\fuelMain_Unit.pas' {fuelMain_Frm},
  fuelConsumption_Unit in 'Forms\fuelConsumption_Unit.pas' {fuelConsumption_Frm},
  progressDialog_Unit in 'Forms\progressDialog_Unit.pas' {progressDialog_Frm},
  CommonUtil_Unit in '..\..\00.CommonUtils\CommonUtil_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TfuelMain_Frm, fuelMain_Frm);
  Application.Run;
end.

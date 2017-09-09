program HiTEMS_Daily_Fuel;

uses
  Vcl.Forms,
  dailyFuel_Unit in 'Forms\dailyFuel_Unit.pas' {dailyFuel_Frm},
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  CommonUtil_Unit in '..\..\00.CommonUtils\CommonUtil_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdailyFuel_Frm, dailyFuel_Frm);
  Application.CreateForm(TDM1, DM1);
  Application.Run;
end.

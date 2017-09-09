program HiTEMS_Himsen_Info;

uses
  Vcl.Forms,
  himsenMain_Unit in 'Forms\himsenMain_Unit.pas' {himsenMain_Frm},
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  findUser_Unit in 'Forms\findUser_Unit.pas' {findUser_Frm},
  CommonUtil_Unit in '..\..\00.CommonUtils\CommonUtil_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(ThimsenMain_Frm, himsenMain_Frm);
  Application.CreateForm(TfindUser_Frm, findUser_Frm);
  Application.Run;
end.

program DPMS_USER;

uses
  Vcl.Forms,
  userMain_Unit in 'Forms\userMain_Unit.pas' {detailUser_Frm},
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  getUserInfo_Unit in 'Forms\getUserInfo_Unit.pas' {getUserInfo_Frm},
  GetUser_Unit in 'Forms\GetUser_Unit.pas' {GetUser_Frm},
  CommonUtil_Unit in '..\..\CommonUtil\CommonUtil_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TdetailUser_Frm, detailUser_Frm);
  Application.Run;
end.

program HiTEMS_App_Manager;

{$R *.dres}

uses
  Vcl.Forms,
  main_Unit in 'Forms\main_Unit.pas' {main_Frm},
  appCode_Unit in 'Forms\Application_Form\appCode_Unit.pas' {appCode_Frm},
  DataModule_Unit in 'Forms\Common\DataModule_Unit.pas' {DM1: TDataModule},
  appVersion_Unit in 'Forms\Application_Form\appVersion_Unit.pas' {appVersion_Frm},
  CommonUtil_Unit in '..\..\00.CommonUtils\CommonUtil_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(Tmain_Frm, main_Frm);
  Application.Run;
end.

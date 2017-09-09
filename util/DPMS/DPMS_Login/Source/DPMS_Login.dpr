program DPMS_Login;

//{$R 'WindowsVista.res' 'WindowsVista.rc'}

uses
  Vcl.Forms,
  Controls,
  main_Unit in 'Forms\main_Form\main_Unit.pas' {main_Frm},
  login_Unit in 'Forms\main_Form\login_Unit.pas' {login_Frm},
  Vcl.Themes,
  Vcl.Styles,
  HiTEMS_CONST in 'Forms\Common\HiTEMS_CONST.pas',
  detailUser_Unit in 'Forms\main_Form\detailUser_Unit.pas' {detailUser_Frm},
  newUser_Unit in 'Forms\main_Form\newUser_Unit.pas' {newUser_Frm},
  appGrant_Unit in 'Forms\main_Form\appGrant_Unit.pas' {appGrant_Frm},
  CommonUtil_Unit in '..\..\CommonUtil\CommonUtil_Unit.pas',
  DataModule_Unit in '..\..\CommonUtil\DataModule_Unit.pas' {DM1: TDataModule},
  ByteArray in '..\..\..\HiMECS\Application\Utility\ModbusComm_kumo\common\ByteArray.pas',
  HiMECSUserClass in '..\..\..\HiMECS\Application\Source\Common\HiMECSUserClass.pas',
  RMISConst in '..\..\..\RMIS\Common\RMISConst.pas',
  HiMECSConst in '..\..\..\HiMECS\Application\Source\Common\HiMECSConst.pas',
  BaseConfigCollect in '..\..\..\HiMECS\Application\Source\Common\BaseConfigCollect.pas',
  SynCommons in '..\..\..\..\common\mORMot\SynCommons.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.CreateForm(TDM1, DM1);
  Create_LoginForm;
  if Start then
  begin
    Application.CreateForm(Tmain_Frm, main_Frm);
    if Assigned(login_Frm) then
      login_Frm.Free;

    Application.Run;
  end
  else
    if Assigned(login_Frm) then
      login_Frm.Free;

end.

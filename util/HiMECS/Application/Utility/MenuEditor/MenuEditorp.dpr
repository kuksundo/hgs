program MenuEditorp;

uses
  Forms,
  MainUnit in 'Forms\MainUnit.pas' {MainForm},
  MenuBaseClass in '..\..\Source\Common\MenuBaseClass.pas',
  JvgXMLSerializer_Encrypt in '..\..\Source\Common\JvgXMLSerializer_Encrypt.pas',
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  MenuSaveUnit in 'Forms\MenuSaveUnit.pas' {MenuSaveF},
  NextGridUtil in 'Common\NextGridUtil.pas',
  BaseConfigCollect in '..\..\Source\Common\BaseConfigCollect.pas',
  CommonUtil in '..\ModbusComm_kumo\common\CommonUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMenuSaveF, MenuSaveF);
  Application.Run;
end.

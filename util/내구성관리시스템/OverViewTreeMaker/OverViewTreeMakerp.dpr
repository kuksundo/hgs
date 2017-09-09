program OverViewTreeMakerp;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  PMSOverViewClass in '..\..\HiMECS\Application\Source\Common\PMSOverViewClass.pas',
  JvgXMLSerializer_Encrypt in '..\..\HiMECS\Application\Source\Common\JvgXMLSerializer_Encrypt.pas',
  HiMECSConst in '..\..\HiMECS\Application\Source\Common\HiMECSConst.pas',
  NextGridUtil in '..\..\HiMECS\Application\Utility\MenuEditor\Common\NextGridUtil.pas',
  BaseConfigCollect in '..\..\HiMECS\Application\Source\Common\BaseConfigCollect.pas',
  CommonUtil in '..\..\HiMECS\Application\Utility\ModbusComm_kumo\common\CommonUtil.pas',
  MenuSaveUnit in 'MenuSaveUnit.pas' {MenuSaveF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMenuSaveF, MenuSaveF);
  Application.Run;
end.

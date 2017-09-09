program HiMECSConfig;

uses
  Vcl.Forms,
  UnitConfig in '..\..\Source\Forms\UnitConfig.pas' {ConfigF},
  UnitHiMECSConfig in 'UnitHiMECSConfig.pas' {Form1},
  HiMECSConfigCollect in '..\..\Source\Common\HiMECSConfigCollect.pas',
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  CommonUtil in '..\ModbusComm_kumo\common\CommonUtil.pas',
  IPC_MEXA7000_Const in '..\Watch2\common\IPC_MEXA7000_Const.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  //ConfigF.LoadConfigCollect2Form(ConfigF);
  Application.Run;
end.

program ModbusMapConfp_XE5;

uses
  Forms,
  SynSqlite3Static,
  FrmModbusMapConf in 'FrmModbusMapConf.pas' {Form1},
  String_Func in 'common\String_Func.pas',
  EngineParameterClass in '..\HiMECS\Application\Source\Common\EngineParameterClass.pas',
  BaseConfigCollect in '..\HiMECS\Application\Source\Common\BaseConfigCollect.pas',
  HiMECSConst in '..\HiMECS\Application\Source\Common\HiMECSConst.pas',
  DBSelectUint in 'DBSelectUint.pas' {DBSelectForm},
  UnitSetMatrix in '..\HiMECS\Application\Source\Forms\UnitSetMatrix.pas' {SetMatrixForm},
  UnitModbusComConst in '..\HiMECS\Application\Utility\ModbusCommunication\UnitModbusComConst.pas',
  UnitEngParamConfig in '..\HiMECS\Application\Source\Forms\UnitEngParamConfig.pas' {EngParamItemConfigForm},
  UnitSelectUser in '..\HiMECS\Application\Source\Forms\UnitSelectUser.pas' {SelectUserF},
  UnitEngineParamRecord in '..\HiMECS\Application\Source\Common\UnitEngineParamRecord.pas',
  UnitEngineMasterData in '..\GSManage\VesselList\UnitEngineMasterData.pas',
  UnitEngineParamConst in '..\HiMECS\Application\Source\Common\UnitEngineParamConst.pas',
  UnitEnumHelper in '..\..\Common\UnitEnumHelper.pas',
  UnitRttiUtil in '..\..\Common\UnitRttiUtil.pas',
  UnitParameterManager in '..\HiMECS\Application\Utility\Watch2\UnitParameterManager.pas',
  UnitCryptUtil in '..\..\NoGitHub\Util\UnitCryptUtil.pas',
  UnitEncrypt in '..\..\NoGitHub\Util\UnitEncrypt.pas',
  UnitSimulateParamCommandLineOption in '..\HiMECS\Application\Utility\SimulateParamServer\UnitSimulateParamCommandLineOption.pas',
  UnitSimulateCommonData in '..\HiMECS\Application\Utility\SimulateParamServer\UnitSimulateCommonData.pas',
  FrmIntInputEdit in 'FrmIntInputEdit.pas' {IntInputF},
  UnitArrayUtil in '..\..\Common\UnitArrayUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

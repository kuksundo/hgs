program CommP_S7;

uses
  RunOne_ModbusComm_Kumo,
  Forms,
  UComm_S7 in 'UComm_S7.pas' {Comm_S7F},
  S7CommConst in 'S7CommConst.pas',
  S7Config in 'S7Config.pas' {S7ConfigF},
  HiMECSConst in '..\..\Source\Common\HiMECSConst.pas',
  EngineParameterClass in '..\..\Source\Common\EngineParameterClass.pas',
  S7CommThread in 'S7CommThread.pas',
  UnitPing in '..\..\..\..\..\common\UnitPing.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TComm_S7F, Comm_S7F);
  Application.Run;
end.

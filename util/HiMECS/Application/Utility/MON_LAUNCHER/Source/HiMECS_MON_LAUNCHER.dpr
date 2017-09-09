program HiMECS_MON_LAUNCHER;

uses
  Vcl.Forms,
  MonitornewApp_Unit in 'Forms\Common\MonitornewApp_Unit.pas' {newMonApp_Frm},
  MonitorlauncherMain_Unit in 'Forms\MonitorlauncherMain_Unit.pas' {launcherMain_Frm},
  HiMECSConst in '..\..\..\Source\Common\HiMECSConst.pas',
  HiMECSCommonWinMessage in '..\..\..\Source\Common\HiMECSCommonWinMessage.pas',
  CopyData in '..\..\ModbusComm_kumo\common\CopyData.pas',
  TimerPool in '..\..\ModbusComm_kumo\common\TimerPool.pas',
  UnitFrameTileList in '..\..\CommonFrame\UnitFrameTileList.pas' {Frame1: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TlauncherMain_Frm, launcherMain_Frm);
  Application.Run;
end.

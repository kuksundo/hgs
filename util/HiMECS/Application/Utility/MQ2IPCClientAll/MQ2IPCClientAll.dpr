program MQ2IPCClientAll;

uses
  Vcl.Forms,
  UnitIPCClientAll in '..\CommonFrame\UnitIPCClientAll.pas',
  UnitSTOMPClass in '..\..\..\..\..\common\UnitSTOMPClass.pas',
  UnitWorker4OmniMsgQ in '..\..\..\..\..\common\UnitWorker4OmniMsgQ.pas',
  UnitSTOMP2IPCClientAll in 'UnitSTOMP2IPCClientAll.pas' {STOMP2IPCClientAllF},
  CommonUtil in '..\ModbusComm_kumo\common\CommonUtil.pas',
  UnitSTOMP2IPCClientAllConfig in 'UnitSTOMP2IPCClientAllConfig.pas' {ConfigF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSTOMP2IPCClientAllF, STOMP2IPCClientAllF);
  Application.CreateForm(TConfigF, ConfigF);
  Application.Run;
end.

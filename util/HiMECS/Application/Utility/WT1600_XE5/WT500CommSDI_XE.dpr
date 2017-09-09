program WT500CommSDI_XE;

uses
  Forms,
  sysutils,
  RunOne_WT1600,
  tmctl_h in 'tmctl_h.pas',
  WT1600PingThread in 'WT1600PingThread.pas',
  WT1600Select in 'WT1600Select.pas' {WT1600SelectF},
  WT1600Config in 'WT1600Config.pas' {WT1600ConfigF},
  UnitPing in '..\..\..\..\..\common\UnitPing.pas',
  WT1600Connection in 'WT1600Connection.pas',
  WT1600CommThread in 'WT1600CommThread.pas',
  WTxxComm_SDI in 'WTxxComm_SDI.pas' {WT1600CommSDIF},
  UnitIPCClientAll in '..\CommonFrame\UnitIPCClientAll.pas',
  EngineParameterClass in '..\..\Source\Common\EngineParameterClass.pas',
  IPC_WT1600_Const in '..\Watch2\common\IPC_WT1600_Const.pas';

{$R *.res}

begin
  if ParamCount < 1 then
  begin
    with TWT1600SelectF.Create(nil) do
    begin
      ShowModal;

      if UseIPCB.Checked then
        StrPCopy(RunProgram,IPAddrEdit.Text)
      else
        StrPCopy(RunProgram, IntToStr(RadioGroup1.ItemIndex + 1));

      Free;
    end;
  end
  else
  begin
    //RunProgram := ParamStr(1);
    StrPCopy(RunProgram, ParamStr(1));
  end;

  DoIExist_Enter;

  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TWT1600CommSDIF, WT1600CommSDIF);
  Application.Run;

  DoIExist_Leave;
end.

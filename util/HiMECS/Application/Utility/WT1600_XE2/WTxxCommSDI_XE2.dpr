program WTxxCommSDI_XE2;

uses
  Vcl.Forms,
  SysUtils,
  RunOne_WT1600,
  WTxxComm_SDI in 'WTxxComm_SDI.pas' {WT1600CommSDIF},
  tmctl_h in 'tmctl_h.pas',
  WT1600Select in 'WT1600Select.pas' {WT1600SelectF},
  WT1600CommThread in 'WT1600CommThread.pas',
  WT1600PingThread in 'WT1600PingThread.pas',
  WT1600Connection in 'WT1600Connection.pas',
  WT1600Const in 'common\WT1600Const.pas',
  WT1600Config in 'WT1600Config.pas' {WT1600ConfigF};

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
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TWT1600CommSDIF, WT1600CommSDIF);
  Application.Run;

  DoIExist_Leave;
end.

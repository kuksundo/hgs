program HiMECSManualInfo;

uses
  Vcl.Forms,
  UnitManualInfo in 'UnitManualInfo.pas' {Form1},
  CommonUtil in '..\ModbusComm_kumo\common\CommonUtil.pas',
  UnitFolderSelect in 'UnitFolderSelect.pas' {FolderSelectF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

program TestBplunitp;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  CommonUtil in '..\..\ModbusComm_kumo\common\CommonUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

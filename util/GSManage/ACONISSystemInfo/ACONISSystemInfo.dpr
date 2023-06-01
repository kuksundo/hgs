program ACONISSystemInfo;

uses
  Vcl.Forms,
  FrmAconisSystemInfo in 'FrmAconisSystemInfo.pas' {SetACONISF},
  UnitIniFileUtil in '..\..\..\common\UnitIniFileUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSetACONISF, SetACONISF);
  Application.Run;
end.

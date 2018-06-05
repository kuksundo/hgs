program OLMailTitleChangeR;

uses
  Vcl.Forms,
  UnitBase64Util in '..\..\..\common\UnitBase64Util.pas',
  UnitMAPIMessage in 'UnitMAPIMessage.pas',
  FrmOLMailTitleChangerUsingOL in 'FrmOLMailTitleChangerUsingOL.pas' {OLMailTitleChangeF},
  UnitOutLookUtil in '..\..\..\common\UnitOutLookUtil.pas',
  getIp in '..\..\..\common\getIp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TOLMailTitleChangeF, OLMailTitleChangeF);
  Application.Run;
end.

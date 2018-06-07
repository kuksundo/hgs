program MakeHullNo2ProjNo;

uses
  Vcl.Forms,
  FrmHullNo2ProjNo in 'FrmHullNo2ProjNo.pas' {Form3},
  UnitExcelUtil in '..\..\..\common\UnitExcelUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

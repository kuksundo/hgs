program HiMAPManage;

uses
  Vcl.Forms,
  FrmHiMAPSelect in 'FrmHiMAPSelect.pas' {HiMAPSelectF},
  frmHiMAPDetail in 'frmHiMAPDetail.pas' {HiMAPDetailF},
  UnitHiMAPData in 'UnitHiMAPData.pas',
  UnitHiMAPRecord in '..\UnitHiMAPRecord.pas',
  VarRecUtils in '..\..\..\common\openarr\source\VarRecUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THiMAPDetailF, HiMAPDetailF);
  Application.Run;
end.

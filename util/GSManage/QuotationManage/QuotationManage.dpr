program QuotationManage;

uses
  Vcl.Forms,
  SynSqlite3Static,
  FrmQuotationManage in 'FrmQuotationManage.pas' {HimsenWearSpareQF},
  UnitHimsenWearingSpareMarineRecord in 'UnitHimsenWearingSpareMarineRecord.pas',
  VarRecUtils in '..\..\..\common\openarr\source\VarRecUtils.pas',
  UnitStringUtil in '..\..\..\common\UnitStringUtil.pas',
  UnitExcelUtil in '..\..\..\common\UnitExcelUtil.pas',
  UnitHimsenWearingSpareStationaryRecord in 'UnitHimsenWearingSpareStationaryRecord.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THimsenWearSpareQF, HimsenWearSpareQF);
  Application.Run;
end.

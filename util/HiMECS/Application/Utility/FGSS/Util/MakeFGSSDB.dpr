program MakeFGSSDB;

uses
  Vcl.Forms,
  SynSqlite3Static,
  Unit6 in 'Unit6.pas' {Form6},
  UnitFGSSTagRecord in '..\Common\UnitFGSSTagRecord.pas',
  UnitMakeFGSSDBFromXls in '..\Common\UnitMakeFGSSDBFromXls.pas',
  UnitFGSSKMTagConst in '..\Common\UnitFGSSKMTagConst.pas',
  VarRecUtils in '..\..\..\..\..\..\common\openarr\source\VarRecUtils.pas',
  UnitFGSSKMTagRecord in '..\Common\UnitFGSSKMTagRecord.pas',
  UnitFGSSManualRecord in '..\Common\UnitFGSSManualRecord.pas',
  UnitFGSSConst in '..\Common\UnitFGSSConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.

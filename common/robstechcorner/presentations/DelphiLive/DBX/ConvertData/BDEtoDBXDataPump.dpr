program BDEtoDBXDataPump;

uses
  Forms,
  uConvertDataForm in 'uConvertDataForm.pas' {frmBDEToDBX},
  uConvertDataModule in 'uConvertDataModule.pas' {dmConvert: TDataModule},
  DBXUtils in 'C:\Documents and Settings\All Users\Documents\RAD Studio\6.0\Demos\database\src\pas\dbx\datapump\DBXUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmConvert, dmConvert);
  Application.CreateForm(TfrmBDEToDBX, frmBDEToDBX);
  Application.Run;
end.

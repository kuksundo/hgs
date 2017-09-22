program InvoiceManage;

uses
  Vcl.Forms,
  FrmMainInvoiceManage in 'FrmMainInvoiceManage.pas' {InvoiceManageF},
  FrmInvoiceEdit in 'FrmInvoiceEdit.pas' {InvoiceTaskEditF},
  FrmFileList in 'FrmFileList.pas' {FileListF},
  UnitDM in '..\UnitDM.pas' {DM1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TInvoiceManageF, InvoiceManageF);
  Application.CreateForm(TInvoiceTaskEditF, InvoiceTaskEditF);
  Application.CreateForm(TFileListF, FileListF);
  Application.CreateForm(TDM1, DM1);
  Application.Run;
end.

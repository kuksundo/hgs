program Editor;

uses
  Forms,
  dtpEditorMain in 'dtpEditorMain.pas' {frmMain},
  fraBase in 'fraBase.pas' {frBase: TFrame},
  fraShape in 'fraShape.pas' {frShape: TfrBase},
  fraInlay in 'fraInlay.pas' {frInlay: TFrame},
  fraTextBaseShape in 'fraTextBaseShape.pas' {frTextBaseShape: TFrame},
  dtpWorkshop in 'dtpWorkshop.pas' {frmWorkshop};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

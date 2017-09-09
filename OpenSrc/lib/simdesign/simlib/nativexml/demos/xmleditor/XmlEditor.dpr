program XmlEditor;

uses
  FastMM,
  Forms,
  NativeXml,
  XmlEditorMain in 'XmlEditorMain.pas' {frmMain};
{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  //Application.CreateForm(TXmlOutputOptionsDlg, XmlOutputOptionsDlg);
  Application.Run;
end.

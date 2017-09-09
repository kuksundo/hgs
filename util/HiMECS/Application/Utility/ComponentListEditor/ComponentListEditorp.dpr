program ComponentListEditorp;

uses
  Forms,
  UnitComponentListEditor in 'UnitComponentListEditor.pas' {frmBPLListeditor},
  JvgXMLSerializer_Encrypt in '..\..\Source\Common\JvgXMLSerializer_Encrypt.pas',
  BaseConfigCollect in '..\..\Source\Common\BaseConfigCollect.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBPLListeditor, frmBPLListeditor);
  Application.Run;
end.

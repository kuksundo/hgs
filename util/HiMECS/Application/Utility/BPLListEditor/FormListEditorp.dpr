program FormListEditorp;

uses
  Forms,
  UnitFormListEditor in 'UnitFormListEditor.pas' {frmBPLListeditor},
  JvgXMLSerializer_Encrypt in '..\..\Source\Common\JvgXMLSerializer_Encrypt.pas',
  BaseConfigCollect in '..\..\Source\Common\BaseConfigCollect.pas',
  HiMECSFormCollect in '..\..\Source\Common\HiMECSFormCollect.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBPLListeditor, frmBPLListeditor);
  Application.Run;
end.

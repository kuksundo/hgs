program ExeListEditorp;

uses
  Forms,
  UnitExeListEditor in 'UnitExeListEditor.pas' {frmBPLListeditor},
  HiMECSExeCollect in '..\..\Source\Common\HiMECSExeCollect.pas',
  JvgXMLSerializer_Encrypt in '..\..\Source\Common\JvgXMLSerializer_Encrypt.pas',
  BaseConfigCollect in '..\..\Source\Common\BaseConfigCollect.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBPLListeditor, frmBPLListeditor);
  Application.Run;
end.

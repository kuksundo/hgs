program MacroManagement;

uses
  Vcl.Forms,
  UnitMacroRecorderMain in 'UnitMacroRecorderMain.pas' {MacroManageF},
  UnitAction in 'UnitAction.pas' {frmActions},
  thundax.lib.actions in '..\..\OpenSrc\thundax-macro-actions-master\thundax.lib.actions.pas',
  UnitNextGridFrame in '..\..\common\Frames\UnitNextGridFrame.pas' {Frame1: TFrame},
  pjhBaseCollect in '..\..\common\pjhBaseCollect.pas',
  UnitMacroListClass in 'UnitMacroListClass.pas',
  UnitNameEdit in 'UnitNameEdit.pas' {NameEditF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMacroManageF, MacroManageF);
  Application.Run;
end.

program ScheduledMacroActions;

uses
  Forms,
  frmScheduledAction in 'frmScheduledAction.pas' {frmActions},
  thundax.lib.actions in '..\..\OpenSrc\thundax-macro-actions-master\thundax.lib.actions.pas',
  Vcl.Themes,
  Vcl.Styles,
  ralarm in '..\..\..\vcl\ralarm\ralarm.pas',
  UnitNextGridFrame in '..\..\common\Frames\UnitNextGridFrame.pas' {Frame1: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Luna');
  Application.Title := 'Thundax Macro Actions';
  Application.CreateForm(TfrmActions, frmActions);
  Application.Run;
end.

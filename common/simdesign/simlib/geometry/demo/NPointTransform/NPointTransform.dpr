program NPointTransform;

uses
  Forms,
  zNPointTransform in 'zNPointTransform.pas' {frmNPointTransform},
  sdNPointTransform in '..\..\sdNPointTransform.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmNPointTransform, frmNPointTransform);
  Application.Run;
end.


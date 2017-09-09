program Update;

uses
  Forms,
  Dialogs,
  SysUtils,
  Windows,
  Messages,
  uUpdate in 'uUpdate.pas' {fmUpdate},
  constUpdate in 'constUpdate.pas',
  uUtils in 'uUtils.pas';

{$R *.RES}
begin
  if not CloseMainWindow then
    exit;
  
  Application.Initialize;
  Application.Title := PROGRAM_FILE_NAME + ' Update';
  Application.CreateForm(TfmUpdate, fmUpdate);
  Application.ShowMainForm := False;
  Application.Run;
end.

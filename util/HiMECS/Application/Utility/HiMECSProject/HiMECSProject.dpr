program HiMECSProject;

uses
  Vcl.Forms,
  UnitConfigProjectFile in '..\..\Source\Forms\UnitConfigProjectFile.pas' {ConfigProjectFileForm},
  UnitSelectProject in '..\..\Source\Forms\UnitSelectProject.pas' {SelectProjectForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSelectProjectForm, SelectProjectForm);
  Application.Run;
end.

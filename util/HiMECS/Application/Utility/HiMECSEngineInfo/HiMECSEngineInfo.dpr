program HiMECSEngineInfo;

uses
  Vcl.Forms,
  UnitEngineBaseClassUtil in '..\..\Source\Common\UnitEngineBaseClassUtil.pas',
  EngineBaseClass_Old in '..\..\Source\Common\EngineBaseClass_Old.pas',
  EngineBaseClass in '..\..\Source\Common\EngineBaseClass.pas',
  UnitHiMECSAddPart in 'UnitHiMECSAddPart.pas' {AddPartF},
  UnitHiMECSEngineInfo in 'UnitHiMECSEngineInfo.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

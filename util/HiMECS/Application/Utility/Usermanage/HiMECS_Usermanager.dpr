program HiMECS_Usermanager;

uses
  Forms,
  HiMECSUserClass in '..\..\Source\Common\HiMECSUserClass.pas',
  UintUserManage in 'UintUserManage.pas' {FrmUserManage};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmUserManage, FrmUserManage);
  Application.Run;
end.

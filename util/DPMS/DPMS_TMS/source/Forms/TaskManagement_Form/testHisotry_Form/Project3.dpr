program Project3;

uses
  Vcl.Forms,
  Todo_Detail in '..\Todo_Detail.pas' {ToDoDetailF},
  HiTEMS_TMS_CONST in '..\..\Common\HiTEMS_TMS_CONST.pas',
  CommonUtil_Unit in '..\..\..\..\..\CommonUtil\CommonUtil_Unit.pas',
  DataModule_Unit in '..\..\DataModule_Unit.pas',
  HoliDayCollect in '..\..\..\..\..\CommonUtil\HoliDayCollect.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TToDoDetailF, ToDoDetailF);
  Application.Run;
end.

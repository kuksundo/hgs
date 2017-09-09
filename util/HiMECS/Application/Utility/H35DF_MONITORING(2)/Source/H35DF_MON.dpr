program H35DF_MON;

uses
  Vcl.Forms,
  main_Unit in 'Forms\Main_Form\main_Unit.pas' {Form3},
  Vcl.Themes,
  Vcl.Styles,
  UnitFrameIPCMonitorAll in 'E:\pjh\project\util\HiMECS\Application\Utility\CommonFrame\UnitFrameIPCMonitorAll.pas' {FrameIPCMonitorAll: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

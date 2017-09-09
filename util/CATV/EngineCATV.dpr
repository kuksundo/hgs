program EngineCATV;

uses
  RunOne_CATV,
  Vcl.Forms,
  UnitCatvPanel in 'UnitCatvPanel.pas' {CatvPanelF},
  taskSchd in 'taskSchd.pas',
  UnitScheduleList in 'UnitScheduleList.pas' {ScheduleListF},
  UnitFrameCromisIPCServer in '..\HiMECS\Application\Utility\CommonFrame\UnitFrameCromisIPCServer.pas' {FrameCromisIPCServer: TFrame},
  TimerPool in '..\HiMECS\Application\Source\Common\TimerPool.pas',
  UnitCATVAsyncIPC in 'UnitCATVAsyncIPC.pas',
  UeventsSink_PPT in '..\..\common\UeventsSink_PPT.pas',
  UnitSynLog in '..\..\common\UnitSynLog.pas',
  ChangeNotificationDirDlgU in 'ChangeNotificationDirDlgU.pas' {ChangeNotificationDirDlg},
  ChangeNotificationMainFormU in 'ChangeNotificationMainFormU.pas' {ChangeNotificationMainForm},
  UnitDateUtil in '..\..\common\UnitDateUtil.pas',
  UnitCatvParamClass in 'UnitCatvParamClass.pas',
  GpCommandLineParser in '..\..\common\GpDelphiUnit\GpCommandLineParser.pas',
  PowerPoint_TLB in 'C:\Users\ppp\Documents\RAD Studio\12.0\Imports\PowerPoint_TLB.pas',
  Office_TLB in 'C:\Users\ppp\Documents\RAD Studio\12.0\Imports\Office_TLB.pas',
  UnitBlack in 'UnitBlack.pas' {BlackF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCatvPanelF, CatvPanelF);
  Application.CreateForm(TBlackF, BlackF);
  Application.Run;
end.

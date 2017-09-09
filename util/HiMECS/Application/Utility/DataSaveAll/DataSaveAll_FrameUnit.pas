unit DataSaveAll_FrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, JvExComCtrls, JvStatusBar,
  GpCommandLineParser,
  UnitFrameDataSaveAll, UnitFrameIPCMonitorAll, Vcl.Menus, Vcl.ExtCtrls;

type
  TDataSaveAllF = class(TForm)
    JvStatusBar1: TJvStatusBar;
    DSA: TFrameDataSaveAll;
    TFrameIPCMonitorAll1: TFrameIPCMonitor;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TFrameDataSaveAll1Option1Click(Sender: TObject);
    procedure TFrameDataSaveAll1ShowEventName1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataSaveAllF: TDataSaveAllF;

implementation

{$R *.dfm}

procedure TDataSaveAllF.FormCreate(Sender: TObject);
begin
  DSA.FStatusBar := JvStatusBar1;
//  DSA.FOwnerForm := Self;
  DSA.FIPCMonitorAll := TFrameIPCMonitorAll1;
end;

procedure TDataSaveAllF.TFrameDataSaveAll1Option1Click(Sender: TObject);
begin
  DSA.Option1Click(Sender);

end;

procedure TDataSaveAllF.TFrameDataSaveAll1ShowEventName1Click(Sender: TObject);
begin
  DSA.ShowEventName1Click(Sender);
end;

procedure TDataSaveAllF.Timer1Timer(Sender: TObject);
var
  LStr: string;
  i: integer;
begin
  Timer1.Enabled := False;

  Self.Menu := DSA.MainMenu1;
  Self.PopupMenu := DSA.PopupMenu1;

  if ParamCount > 0 then
  begin
    LStr := ParamStr(1);
    i := Pos('/A', UpperCase(LStr)); //Automatic Start
    if i > 0 then  //A 제거
    begin
      //LStr := '.\'+ Copy(LStr, i+2, Length(LStr)-i-1);//환경저장 파일이름
      DSA.LoadActionDataFromini(DSA.FIniFileName);
      DSA.FIsAutoRun := True;
    end;
  end
  else
  begin
    DSA.LoadConfigDataini2Var;
  end;

  //AdjustConfigData;

  DSA.ED_CSV.Text := FormatDatetime('yyyymmdd',date)+'.'+'CSV';

  DSA.LoadRunHourFromini;
  DSA.FRunHourEnable := DSA.IsRunHourEnable;

  if not DSA.FRunHourEnable then
  begin
    DSA.RunHourPanel.Font.Color := clYellow;
    DSA.Label2.Visible := False;
    DSA.RunHourPanel.Visible := False;
  end;

  if DSA.AutoStartCheck.Checked then
    DSA.SetOnAutoStartServer(1000);
//    FPJHTimerPool.AddOneShot(OnAutoStartServer, FAutoStartAfter);

  ///======================================================================
  //LStr := Format('%s (%X)', [Application.Title, GetCurrentProcessID]);
  //Label4.Caption := IntToStr(GetCurrentProcessID);
  try
//    IPCClient_HiMECS_MDI := TIPCClient_HiMECS_MDI.Create(GetCurrentProcessID, Self.Caption);
    //IPCClient_HiMECS_MDI := TIPCClient_HiMECS_MDI.Create(GetCurrentProcessID, LStr);
    //IPCClient_HiMECS_MDI.OnConnect := OnConnect;
    //IPCClient_HiMECS_MDI.OnSignal := OnSignal;
//    IPCClient_HiMECS_MDI.Activate;

//    if not (IPCClient_HiMECS_MDI.State = stConnected) then
//      OnConnect(nil, False);
  except
    Application.HandleException(ExceptObject);
    Application.Terminate;
  end;

  if DSA.FAppendStr = '' then
    LStr := 'No Append Str'
  else
    LStr := DSA.FAppendStr;

  Caption := Caption + '(' + LStr + ')';
end;

end.

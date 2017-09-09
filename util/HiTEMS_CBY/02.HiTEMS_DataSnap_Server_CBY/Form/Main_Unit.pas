unit Main_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,idGlobal,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.ComCtrls, IdStack,
  IdHTTPWebBrokerBridge,IdTCPConnection, AdvOfficeStatusBar, AdvOfficePager,
  AdvOfficePagerStylers;

type
  TMain_Frm = class(TForm)
    serverPager: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    PortLabel: TLabel;
    Bevel1: TBevel;
    PortField: TEdit;
    StartButton: TButton;
    StopButton: TButton;
    AutoStartCheck: TCheckBox;
    ButtonOpenBrowser: TButton;
    AutoStartTimer: TTimer;
    AdvOfficePagerOfficeStyler1: TAdvOfficePagerOfficeStyler;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    Label1: TLabel;
    im_svStatus: TImage;
    Label2: TLabel;
    lb_startTime: TLabel;
    sessionList: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    procedure StartButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure AutoStartTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FServerStartTime : TDateTime;
    FServer: TIdHTTPWebBrokerBridge;
    procedure AddSessionToList(const SessionId: String);
    procedure RemoveSessionFromList(const SessionId: String);
  public
    { Public declarations }
    procedure StartServer(const DoStart: Boolean);
    procedure ActivateUI(const IsActive: Boolean);
    procedure LoadPngImage(Res: String; Im: TImage);
  end;


//  Win32ProxyDownloader.exe -host 10.14.6.67:47110 -language java_android -output c:\Com
//
//  Win32ProxyDownloader.exe -host localhost:8086 -language java_android -output c:\com
//
//  Win32ProxyDownloader.exe -host 10.14.23.222:8086 -language java_android -output c:\mec

var
  Main_Frm: TMain_Frm;

implementation
uses
  Datasnap.DSService,
  Winapi.ShellApi,
  WebModule_Unit,
  ServerContainer_Unit;


{$R *.dfm}

procedure TMain_Frm.ActivateUI(const IsActive: Boolean);
begin
  if IsActive then
  begin
    Caption := '[::HiTEMS DataSnap Server (' + GStack.LocalAddress + ':' + PortField.Text + ')::]';
    LoadPngImage('pngGreen', im_svStatus);
    lb_startTime.Caption := FormatDateTime('YYYY-MM-DD HH:mm:ss',Now);
    //서버 시작시간
    FServerStartTime := Now;
    Timer1.Enabled := True;
  end else
  begin
    Caption := 'HiTEMS DataSnap Server';
    LoadPngImage('pngYellow', im_svStatus);
    lb_startTime.Caption := '-';
    //서버 시작시간
    Label4.Caption := '-';
    Timer1.Enabled := False;
  end;

  PortLabel.Enabled      := not IsActive;
  StartButton.Enabled    := not IsActive;
  PortField.Enabled      := not IsActive;
  AutoStartCheck.Enabled := not IsActive;
  AutoStartTimer.Enabled := not IsActive;

  StopButton.Enabled := IsActive;
  ButtonOpenBrowser.Enabled := IsActive;

end;

procedure TMain_Frm.AddSessionToList(const SessionId: String);
begin
  TThread.Queue(nil,
    procedure
    begin
      SessionList.Items.Add(SessionId);
    end);
end;

procedure TMain_Frm.AutoStartTimerTimer(Sender: TObject);
begin
  //disable timer. It will be enabled again if the user starts and then stops the server
  AutoStartTimer.Enabled := False;
  if AutoStartCheck.Checked then
    //server isn't running
//    if (not StopButton.Enabled) and (not ServerContainer1.DSServer1.Started) then
//      StartServer(True);
end;

procedure TMain_Frm.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
//  StartServer;
  LURL := Format('http://localhost:%s', [PortField.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;


procedure TMain_Frm.FormActivate(Sender: TObject);
begin
  TDSSessionManager.Instance.AddSessionEvent(
    procedure(Sender: TObject;
              const EventType: TDSSessionEventType;
              const Session: TDSSession)
    begin
      if EventType = TDSSessionEventType.SessionCreate then
        AddSessionToList(Session.SessionName)
      else
        RemoveSessionFromList(Session.SessionName);
    end);
end;

procedure TMain_Frm.FormCreate(Sender: TObject);
begin
  serverPager.ActivePageIndex := 0;

  FServer := TIdHTTPWebBrokerBridge.Create(Self);
end;


procedure TMain_Frm.LoadPngImage(Res: String; Im: TImage);
var
  MyResourceStream: TResourceStream;
  MyPNGImage: TPNGImage;
begin
  MyResourceStream := TResourceStream.Create(hInstance, Res, RT_RCDATA);

  try
    MyPNGImage := TPNGImage.Create;
    try
      MyPNGImage.LoadFromStream(MyResourceStream);
      Im.Picture.Graphic := MyPNGImage;
    finally
      MyPNGImage.Free
    end;
  finally
    MyResourceStream.Free
  end;

end;

procedure TMain_Frm.RemoveSessionFromList(const SessionId: String);
var
  LIndex: Integer;
begin
  TThread.Queue(nil,
    procedure
    begin
      LIndex := SessionList.Items.IndexOf(SessionId);
      if LIndex >= 0 then
        SessionList.Items.Delete(LIndex);
    end);
end;

procedure TMain_Frm.StartButtonClick(Sender: TObject);
begin
  StartServer(True);
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TMain_Frm.StartServer(const DoStart: Boolean);
var
  LPort: String;
begin
  if DoStart then
  begin
    LPort := PortField.Text;

    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(LPort);
    FServer.Active := True;


  end
  else
  begin
    TerminateThreads;
    FServer.Active := False;
    FServer.Bindings.Clear;
  end;
  ActivateUI(DoStart);


end;


procedure TMain_Frm.StopButtonClick(Sender: TObject);
begin
  StartServer(False);
end;

procedure TMain_Frm.Timer1Timer(Sender: TObject);
begin
  label4.Caption := FormatDateTime('HH:mm:ss',Now-FServerStartTime);

end;

end.


unit UnitFrameMQTTClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvOfficeStatusBar,
  AdvOfficeStatusBarStylers, Vcl.ExtCtrls, Vcl.Menus, JvComponentBase,
  JvTrayIcon, Vcl.StdCtrls, JvExControls, JvXPCore, JvXPButtons, Vcl.ComCtrls,
  UnitStrMsg.EventThreads, UnitStrMsg.Events, MQTT, UnitMQTTClientConfig,
  UnitMQTTClass;

type
  TMQTTQOSType =
  (
    qtAT_MOST_ONCE,   //  0 At most once Fire and Forget        <=1
    qtAT_LEAST_ONCE,  //  1 At least once Acknowledged delivery >=1
    qtEXACTLY_ONCE,   //  2 Exactly once Assured delivery       =1
    qtReserved3	      //  3	Reserved
  );

  TFrameMQTTClient = class(TFrame)
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lvConnections: TListView;
    TabSheet2: TTabSheet;
    Splitter2: TSplitter;
    SendMemo: TRichEdit;
    Recvmemo: TRichEdit;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    SMSysLog: TMemo;
    TabSheet5: TTabSheet;
    SMConnectLog: TMemo;
    TabSheet6: TTabSheet;
    SMTransferLog: TMemo;
    Panel1: TPanel;
    AutoStartCheck: TCheckBox;
    Panel2: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ServerConnectBtn: TJvXPButton;
    ServerDisconnectBtn: TJvXPButton;
    ServerPingBtn: TJvXPButton;
    PublishBtn: TJvXPButton;
    SubscribeBtn: TJvXPButton;
    JvXPButton6: TJvXPButton;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    JvTrayIcon1: TJvTrayIcon;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    rlsmd1: TMenuItem;
    StopMonitor1: TMenuItem;
    StartMonitor1: TMenuItem;
    N6: TMenuItem;
    ShowDebug1: TMenuItem;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N5: TMenuItem;
    MenuItem4: TMenuItem;
    Timer1: TTimer;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    PopupMenu2: TPopupMenu;
    DeleteItem1: TMenuItem;
    ServerPortEdit: TEdit;
    ServerIPEdit: TEdit;
    TopicEdit: TEdit;
    MsgEdit: TEdit;

    procedure ServerPingBtnClick(Sender: TObject);
    procedure ServerDisconnectBtnClick(Sender: TObject);
    procedure ServerConnectBtnClick(Sender: TObject);
    procedure PublishBtnClick(Sender: TObject);
    procedure SubscribeBtnClick(Sender: TObject);
  private
    FpjhMQTT: TpjhMQTTClass;
    FSettingFileName: string;
    FConfigSettings: TConfigSettings;

    procedure SetSettingFileName(AName: string);
    procedure LoadSettingFromFile(AFileName: string);
    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitVar;
    procedure DestroyVar;
    procedure DisplayMessage(msg: string; ADspNo: integer);
    procedure PushMessage2Display(msg: string; ADispNo: integer = 0);
    procedure ConnectMQTTServer(AIP, APort: string);
    procedure DisConnectMQTTServer;

    procedure DoSubScribe(AFilter: Ansistring; AMQTTQOSType: integer = 0);
    procedure DoPublish(ATopic, AMessage: Ansistring);
    procedure DoPing;

//    property SettingFileName: string read FSettingFileName write SetSettingFileName;
  end;

implementation

{$R *.dfm}

procedure TFrameMQTTClient.ApplyUI;
begin

end;

procedure TFrameMQTTClient.ConnectMQTTServer(AIP, APort: string);
begin
  if Assigned(FpjhMQTT) then
    FpjhMQTT.Free;

  FpjhMQTT := TpjhMQTTClass.Create('','',AIP, APort,'', Self.Handle);

  if FpjhMQTT.ConnectMQTT then
  begin
    PushMessage2Display('Connected to ' + AIP + ' on ' + APort);
    ServerDisconnectBtn.Enabled := True;
  end
  else
    PushMessage2Display('Failed to connect');
end;

constructor TFrameMQTTClient.Create(AOwner: TComponent);
begin
  inherited;

  InitVar;
end;

destructor TFrameMQTTClient.Destroy;
begin
  DestroyVar;
  inherited;
end;

procedure TFrameMQTTClient.DestroyVar;
begin
  FConfigSettings.Free;
end;

procedure TFrameMQTTClient.DisConnectMQTTServer;
begin
  if Assigned(FpjhMQTT) then
  begin
    FreeAndNil(FpjhMQTT);
    PushMessage2Display('Disconnected');
  end;
end;

procedure TFrameMQTTClient.DisplayMessage(msg: string; ADspNo: integer);
begin
  case ADspNo of
    0 : begin
      with SMSysLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with
    end;
    1 : begin
      with SMConnectLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with
    end;
    2 : begin
      with SMTransferLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with
    end;
  end;
end;

procedure TFrameMQTTClient.DoPing;
begin
  if Assigned(FpjhMQTT) then
  begin
    FpjhMQTT.MQTTPing;
    PushMessage2Display('Ping');
  end;
end;

procedure TFrameMQTTClient.DoPublish(ATopic, AMessage: Ansistring);
begin
  if (Assigned(FpjhMQTT)) then
  begin
    FpjhMQTT.MQTTPublishMsg(ATopic, AMessage);
    PushMessage2Display('Published');
  end;
end;

procedure TFrameMQTTClient.DoSubScribe(AFilter: Ansistring; AMQTTQOSType: integer);
begin
  if (Assigned(FpjhMQTT)) then
  begin
    FpjhMQTT.MQTTSubscribe(AFilter, AMQTTQOSType);
    PushMessage2Display('Subscribe');
  end;
end;

procedure TFrameMQTTClient.InitVar;
begin
  FConfigSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadSettingFromFile(FSettingFileName);
//  FSettings := TConfigSettings.create(FSettingFileName);
  StrMsgEventThread.FDisplayMsgProc := DisplayMessage;
end;

procedure TFrameMQTTClient.LoadConfig2Form(AForm: TConfigF);
begin
  FConfigSettings.LoadConfig2Form(AForm, FConfigSettings);
end;

procedure TFrameMQTTClient.LoadConfigForm2Object(AForm: TConfigF);
begin
  FConfigSettings.LoadConfigForm2Object(AForm, FConfigSettings);
end;

procedure TFrameMQTTClient.LoadConfigFromFile(AFileName: string);
begin
  FConfigSettings.Load(AFileName);
end;

procedure TFrameMQTTClient.LoadSettingFromFile(AFileName: string);
begin

end;

procedure TFrameMQTTClient.PublishBtnClick(Sender: TObject);
begin
  DoPublish('','');
end;

procedure TFrameMQTTClient.PushMessage2Display(msg: string; ADispNo: integer);
begin
  TStrMsgEvent.Create(msg, ADispNo).Queue;
end;

procedure TFrameMQTTClient.ServerConnectBtnClick(Sender: TObject);
begin
//  ConnectMQTTServer(FServerIP, FServerPort);
  ConnectMQTTServer(ServerIPEdit.Text, ServerPortEdit.Text);
end;

procedure TFrameMQTTClient.ServerDisconnectBtnClick(Sender: TObject);
begin
  DisConnectMQTTServer;
end;

procedure TFrameMQTTClient.ServerPingBtnClick(Sender: TObject);
begin
  DoPing;
end;

procedure TFrameMQTTClient.SetConfig;
var
  LConfigF: TConfigF;
begin
  LConfigF := TConfigF.Create(Self);

  try
    LoadConfig2Form(LConfigF);

    if LConfigF.ShowModal = mrOK then
    begin
      LoadConfigForm2Object(LConfigF);
      FConfigSettings.Save();
      ApplyUI;
    end;
  finally
    LConfigF.Free;
  end;
end;

procedure TFrameMQTTClient.SetSettingFileName(AName: string);
begin
  if AName = '' then
    exit;

  if FSettingFileName <> AName then
    FSettingFileName := AName;
end;

procedure TFrameMQTTClient.SubscribeBtnClick(Sender: TObject);
begin
  DoSubScribe(TopicEdit.Text,0);
end;

end.

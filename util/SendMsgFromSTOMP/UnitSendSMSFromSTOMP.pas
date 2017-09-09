unit UnitSendSMSFromSTOMP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.AppEvnts,
  OtlContainerObserver, OtlComm,
  UnitMQConfig, UnitSTOMPClass, UnitWorker4OmniMsgQ, UnitHhiSMSClass;

const
  MQ_TOPIC = '/topic/SendHHISMS';

type
  TForm8 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MQServerIPEdit: TEdit;
    MQServerPortEdit: TEdit;
    TopicEdit: TEdit;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Option1: TMenuItem;
    Config1: TMenuItem;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    PopupMenu1: TPopupMenu;
    Close2: TMenuItem;
    N1: TMenuItem;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FpjhSTOMPClass: TpjhSTOMPClass;
    FpjhHhiSMSClass: TpjhHhiSMSClass;
    FExeFilePath: string;
    FIniFileName: string;
    FIsDestroying: Boolean;
    FParamFileNameChanged: Boolean;

    procedure InitVar;
    procedure FinalizeVar;
    procedure InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroySTOMP;

    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessSubscribeMsg;
    procedure SendData2MQ(AMsg: string; ATopic: string = '');

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
    procedure DispConfigData;
    procedure DisplayMessage2Memo(msg: string; ADest: integer);

    procedure ShowMainForm;
  public
    FSettings : TConfigSettings;
    FCommandQueue    : TOmniMessageQueue;
  end;

var
  Form8: TForm8;

implementation

uses OtlCommon, StompTypes, SyncObjs, ActiveX,
  SynCommons, mORMot, UnitHHIMessage, UnitSTOMPMsg.Events, UnitSTOMPMsg.EventThreads;

{$R *.dfm}

procedure TForm8.ApplicationEvents1Minimize(Sender: TObject);
begin
  Hide();
  WindowState := wsMinimized;

//  { Show the animated tray icon and also a hint balloon. }
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TForm8.ApplyUI;
begin
  DispConfigData;
end;

procedure TForm8.Button1Click(Sender: TObject);
var
  LStr: string;
  LUtf8: RawUTF8;
  LHhiSMSRecord: THhiSMSRecord;
begin                            //'A' : 쪽지, 'B' : SMS
  MakeHhiSMSRecord(LHhiSMSRecord,'A','A379042','A379042','[알람]','AlarmEvent','내용');
  LStr := UTF8ToString(RecordSaveJSON(LHhiSMSRecord, TypeInfo(THhiSMSRecord)));
  FpjhSTOMPClass.StompSendMsg(LStr, MQ_TOPIC);
end;

procedure TForm8.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.Free;
end;

procedure TForm8.DispConfigData;
begin
  MQServerIPEdit.Text := FSettings.MQServerIP;
  MQServerPortEdit.Text := FSettings.MQServerPort;
  TopicEdit.Text := FSettings.MQServerTopic;
end;

procedure TForm8.DisplayMessage2Memo(msg: string; ADest: integer);
begin
  if FIsDestroying then
    exit;

  if msg = ' ' then
  begin
    exit;
  end;

  case ADest of
    0 : begin
      with Memo1 do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(DateTimeToStr(now) + ' :: ' + msg);
      end;//with
    end;//dtSystemLog
  end;//case
end;

procedure TForm8.FinalizeVar;
begin
  FpjhHhiSMSClass.Free;
  DestroySTOMP;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TForm8.FormDestroy(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  FinalizeVar;
end;

procedure TForm8.InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
begin
  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(AUserId,
                                            APasswd,
                                            AServerIP,
                                            ATopic,
                                            Self.Handle);
  end;
end;

procedure TForm8.InitVar;
var
  LStr: string;
begin
  FExeFilePath := ExtractFilePath(Application.ExeName);
  FIniFileName := '';

  if ParamCount > 0 then
  begin
    LStr := UpperCase(ParamStr(1));
    if POS('/F', LStr) > 0 then  //FIniFileName 설정
    begin
      Delete(LStr,1,2);

      if POS(':\', LStr) = 0 then
        LStr := '.\' + LStr;

      FIniFileName := LStr;
    end;
  end;

  if FIniFileName = '' then
    FIniFileName := ChangeFileExt(Application.ExeName, '.ini');

  FSettings := TConfigSettings.create(FIniFileName);
  LoadConfigFromFile;

  STOMPMsgEventThread.SetDisplayMsgProc(DisplayMessage2Memo);
  InitSTOMP(FSettings.MQServerUserId,FSettings.MQServerPasswd,FSettings.MQServerIP,MQ_TOPIC);
//  InitSTOMP('pjh','pjh','127.0.0.1',MQ_TOPIC);
  FpjhHhiSMSClass := TpjhHhiSMSClass.Create(Handle);
end;

procedure TForm8.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TForm8.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TForm8.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);

  if FSettings.MQServerIP = '' then
    FSettings.MQServerIP := '127.0.0.1';

  ApplyUI;
end;

procedure TForm8.ProcessSubscribeMsg;
var
  msg: TOmniMessage;
  FStompFrame: IStompFrame;
  LJSon: string;
  LUtf8: RawUTF8;
  LValue: THhiSMSRecord;
begin
//  CoInitialize(nil);
//  try
    while FpjhSTOMPClass.GetResponseQMsg(msg) do
    begin
      FStompFrame := msg.MsgData.AsInterface as IStompFrame;
      LJSon := FStompFrame.GetBody;
      LUtf8 := StringToUTF8(LJSon);
      RecordLoadJSON(LValue, pointer(LUtf8), TypeInfo(THhiSMSRecord));
      FpjhHhiSMSClass.SendHhiSMSMsg(LValue);
    end;
//  finally
//    CoUnInitialize;
//  end;
end;

procedure TForm8.SendData2MQ(AMsg, ATopic: string);
begin
  FpjhSTOMPClass.StompSendMsg(AMsg, ATopic);
end;

procedure TForm8.SetConfig;
var
  LConfigF: TConfigF;
  LParamFileName: string;
begin
  LConfigF := TConfigF.Create(Self);

  try
    LParamFileName := FSettings.ParamFileName;
    LoadConfig2Form(LConfigF);

    if LConfigF.ShowModal = mrOK then
    begin
      LoadConfigForm2Object(LConfigF);
      FSettings.Save();

      FParamFileNameChanged := (LParamFileName <> FSettings.ParamFileName) and
        (FileExists(FSettings.ParamFileName));
      ApplyUI;
    end;
  finally
    LConfigF.Free;
  end;
end;

procedure TForm8.ShowMainForm;
begin
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TForm8.TrayIcon1DblClick(Sender: TObject);
begin
  ShowMainForm;
end;

procedure TForm8.WorkerResult(var msg: TMessage);
begin
  ProcessSubscribeMsg;
end;

end.

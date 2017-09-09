unit UnitMQTTTemplate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitMQTTClass, UnitWorker4OmniMsgQ, UnitMQTTConfig,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

const
  MQ_TOPIC_MQTT = '';

type
  TForm9 = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FpjhMQTTClass: TpjhMQTTClass;
    FIniFileName: string;
    FExeFilePath: string;
    FIsDestroying: Boolean;
    FParamFileNameChanged: Boolean;

    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessSubscribeMsg;

    procedure InitVar;
    procedure FinalizeVar;
    procedure InitMQTT(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroyMQTT;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
    procedure DispConfigData;
    procedure DisplayMQTTMessage2Memo(msg: string; ADest: integer);
  public
    FSettings : TConfigSettings;
  end;

var
  Form9: TForm9;

implementation

uses OtlComm, UnitMQTTMsg.EventThreads;

{$R *.dfm}

{ TForm9 }

procedure TForm9.ApplyUI;
begin
  DispConfigData;
end;

procedure TForm9.DestroyMQTT;
begin
  if Assigned(FpjhMQTTClass) then
    FpjhMQTTClass.Free;
end;

procedure TForm9.DispConfigData;
begin
  MQServerIPEdit.Text := FSettings.MQTTServerIP;
  MQServerPortEdit.Text := FSettings.MQTTServerPort;
  TopicEdit.Text := FSettings.MQTTServerTopic;
end;

procedure TForm9.DisplayMQTTMessage2Memo(msg: string; ADest: integer);
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

procedure TForm9.FinalizeVar;
begin
  DestroyMQTT;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TForm9.FormDestroy(Sender: TObject);
begin
  FinalizeVar;
end;

procedure TForm9.InitMQTT(AUserId, APasswd, AServerIP, ATopic: string);
begin
  if AUserId <> '' then

  if not Assigned(FpjhMQTTClass) then
  begin
    FpjhMQTTClass := TpjhMQTTClass.Create(AUserId,
                                            APasswd,
                                            AServerIP, '',
                                            ATopic,
                                            Self.Handle);
  end;
end;

procedure TForm9.InitVar;
var
  LStr: string;
begin
  FExeFilePath := ExtractFilePath(Application.ExeName);
  FIniFileName := '';

  if ParamCount > 0 then
  begin
    LStr := UpperCase(ParamStr(1));
    if POS('/F', LStr) > 0 then  //FIniFileName ¼³Á¤
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

  MQTTMsgEventThread.SetDisplayMsgProc(DisplayMQTTMessage2Memo);
  InitMQTT(FSettings.MQTTServerUserId,FSettings.MQTTServerPasswd,FSettings.MQTTServerIP,FSettings.MQTTServerTopic);
end;

procedure TForm9.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TForm9.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TForm9.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);

  if FSettings.MQTTServerIP = '' then
    FSettings.MQTTServerIP := '127.0.0.1';

  if FSettings.MQTTServerTopic = '' then
    FSettings.MQTTServerTopic := MQ_TOPIC_MQTT;

  ApplyUI;
end;

procedure TForm9.ProcessSubscribeMsg;
var
  Amsg: TOmniMessage;
  rec : TCommandMsgRecord;
begin
  while FpjhMQTTClass.GetResponseQMsg(Amsg) do
  begin
    rec := Amsg.MsgData.ToRecord<TCommandMsgRecord>;
//    rec.FTopic;
//    rec.FMessage;
//    Memo1.Lines.Add(Amsg.MsgData);
  end;
end;

procedure TForm9.SetConfig;
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

procedure TForm9.WorkerResult(var msg: TMessage);
begin
  ProcessSubscribeMsg;
end;

end.

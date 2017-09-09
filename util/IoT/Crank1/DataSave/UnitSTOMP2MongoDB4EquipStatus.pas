unit UnitSTOMP2MongoDB4EquipStatus;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitSTOMPClass, UnitWorker4OmniMsgQ,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, UnitMQConfig,
  OtlParallel, OtlTaskControl, mORMot, mORMotUI, SynCommons, SynMongoDB;

const
  MQ_TOPIC = '/topic/IoT_Crank1_EquipStatus';

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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FpjhSTOMPClass: TpjhSTOMPClass;
    FExeFilePath: string;
    FIniFileName: string;
    FIsDestroying: Boolean;
    FParamFileNameChanged: Boolean;
    FClient : TMongoClient;
    FDB : TMongoDatabase;

    procedure InitVar;
    procedure FinalizeVar;
    procedure InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroySTOMP;
    procedure InitializeMongoDB(AHostIP, ADBName: string; APort: integer=27017);
    procedure FinalizeMongoDB;

    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessSubscribeMsg;
    procedure SendData2MQ(AMsg: string; ATopic: string = '');

    procedure InsertMongoDBFromSTOMP;
    procedure OnInsertMongoDBFromSTOMPCompleted(const task: IOmniTaskControl);

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
    procedure DispConfigData;
    procedure DisplayMessage2Memo(msg: string; ADest: integer);
  public
    FSettings : TConfigSettings;
  end;

var
  Form8: TForm8;

implementation

uses otlcomm, StompTypes;

{$R *.dfm}

{ TForm8 }

procedure TForm8.ApplyUI;
begin
  DispConfigData;
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

procedure TForm8.FinalizeMongoDB;
begin
  if Assigned(FClient) then
    FClient.Free;
end;

procedure TForm8.FinalizeVar;
begin
  DestroySTOMP;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TForm8.FormDestroy(Sender: TObject);
begin
  FinalizeVar;
end;

procedure TForm8.InitializeMongoDB(AHostIP, ADBName: string; APort: integer);
begin
  if Assigned(FClient) then
    FreeAndNil(FClient);

  FClient := TMongoClient.Create(AHostIP, APort);

  if Assigned(FClient) then
  begin
    FClient.WriteConcern := wcUnacknowledged;
    FDB := nil;
    FDB := FClient.Database[ADBName];
  end;
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

  InitSTOMP('pjh','pjh','127.0.0.1',MQ_TOPIC);
end;

procedure TForm8.InsertMongoDBFromSTOMP;
var
  msg: TOmniMessage;
  FStompFrame: IStompFrame;
  LJSon: string;
  LColl: TMongoCollection;
  LDoc: variant;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    FStompFrame := msg.MsgData.AsInterface as IStompFrame;
    LJSon := FStompFrame.GetBody;
    LColl := FDB.CollectionOrCreate[FSettings.MongoDBServerCollectName];
    try
      LDoc := TDocVariant.NewJSON(StringToUTF8(LJSon));
      LColl.Insert(LDoc); // insert all values at once
    except

    end;
  end;

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

procedure TForm8.OnInsertMongoDBFromSTOMPCompleted(
  const task: IOmniTaskControl);
begin

end;

procedure TForm8.ProcessSubscribeMsg;
begin
  Parallel.Async(InsertMongoDBFromSTOMP, Parallel.TaskConfig.OnTerminated(OnInsertMongoDBFromSTOMPCompleted));
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

procedure TForm8.WorkerResult(var msg: TMessage);
begin
  ProcessSubscribeMsg;
end;

end.

unit UnitMQTT2STOMPCrankEquip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitWorker4OmniMsgQ,
  UnitMQTTMsg.Events, UnitMQTTClass,  UnitSTOMPClass, UnitSTOMPMsg.Events,
  UnitEquipStatusClass, SynCommons, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, UnitMQTT2STOMPConfig, UnitTimerPool,
  OtlParallel, OtlTaskControl;

const
  MQ_TOPIC_STOMP = '/topic/IoT_Crank1_EquipStatus';
  MQ_TOPIC_MQTT = '/dev/mc/#/';

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
    Splitter1: TSplitter;
    Memo2: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    STOMPServerIPEdit: TEdit;
    Label7: TLabel;
    STOMPServerPortEdit: TEdit;
    Label8: TLabel;
    STOMPServerTopicEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FpjhSTOMPClass: TpjhSTOMPClass;
    FpjhMQTTClass: TpjhMQTTClass;
    FEquipStatusInfo: TEquipStatusInfo;
    FParamFileNameChanged: Boolean;
    FExeFilePath: string;
    FIniFileName: string;
    FIsDestroying: Boolean;
    FPJHTimerPool: TPJHTimerPool;

    procedure InitVar;
    procedure FinalizeVar;
    procedure InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroySTOMP;
    procedure InitMQTT(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroyMQTT;

    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessSubscribeMsg;
    procedure SendData2MQ(AMsg: string; ATopic: string = '');

    procedure MQTTMsg2Collect(AMsgEvent: TMQTTMsgEvent);
    function GetEquipNo(ATopic: string): string;
    procedure SendCollect2MQUsingSTOMP;
    procedure OnSendCollect2MQUsingSTOMPCompleted(const task: IOmniTaskControl);

    procedure DisplayMQTTMessage2Memo(msg: string; ADest: integer);
    procedure DisplaySTOMPMessage2Memo(msg: string; ADest: integer);

    procedure OnSendMQTT2STOMP(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

//    procedure Syncro_Main(AMsgEvent: TMQTTMsgEvent);
  protected
    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
    procedure DispConfigData;
  public
    FSettings : TConfigSettings;
  end;

var
  Form8: TForm8;

implementation

uses otlcomm, OtlCommon, StompTypes, UnitMQTTMsg.EventThreads, UnitSTOMPMsg.EventThreads;

{$R *.dfm}

{ TForm8 }

procedure TForm8.ApplyUI;
begin
  DispConfigData;
end;

procedure TForm8.Config1Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TForm8.DestroyMQTT;
begin
  if Assigned(FpjhMQTTClass) then
    FpjhMQTTClass.Free;
end;

procedure TForm8.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.Free;
end;

procedure TForm8.DispConfigData;
begin
  MQServerIPEdit.Text := FSettings.MQTTServerIP;
  MQServerPortEdit.Text := FSettings.MQTTServerPort;
  TopicEdit.Text := FSettings.MQTTServerTopic;

  STOMPServerIPEdit.Text := FSettings.STOMPServerIP;
  STOMPServerPortEdit.Text := FSettings.STOMPServerPort;
  STOMPServerTopicEdit.Text := FSettings.STOMPServerTopic;
end;

procedure TForm8.DisplayMQTTMessage2Memo(msg: string; ADest: integer);
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

procedure TForm8.DisplaySTOMPMessage2Memo(msg: string; ADest: integer);
begin
  if FIsDestroying then
    exit;

  if msg = ' ' then
  begin
    exit;
  end;

  case ADest of
    0 : begin
      with Memo2 do
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
  DestroyMQTT;
  DestroySTOMP;

  FEquipStatusInfo.Free;
end;

procedure TForm8.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FIsDestroying := True;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  FpjhMQTTClass.DisConnectMQTT;
  FpjhSTOMPClass.DisConnectStomp;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TForm8.FormDestroy(Sender: TObject);
begin
  FinalizeVar;
end;

function TForm8.GetEquipNo(ATopic: string): string;
var
  LStrList: TStringList;
begin
  Result := '';
// /dev/mc/xxx/ 형태로 들어옴
  LStrList := TStringList.Create;
  try
    ExtractStrings(['/'], [], PChar(ATopic), LStrList);

    if LStrList.Count > 2 then
      Result := LStrList.Strings[2]
    else;
//      TMQTTMsgEvent.Create('', 'GetEquipNo -> Topic Error : ' + ATopic).Queue;

  finally
    LStrList.Free;
  end;
end;

procedure TForm8.InitMQTT(AUserId, APasswd, AServerIP, ATopic: string);
begin
  if not Assigned(FpjhMQTTClass) then
  begin
    FpjhMQTTClass := TpjhMQTTClass.Create(AUserId,
                                            APasswd,
                                            AServerIP, '',
                                            ATopic,
                                            Self.Handle);
//    FpjhMQTTClass.SetSynchroProc(Syncro_Main);

    //MQTT Onsubscribe시에 실행되는 함수 설정
    //TpjhMQTTClass.ProcessMQTTMsg 함수에서 호출 함(Event Thread 에서 실행 됨)
    FpjhMQTTClass.OnTMQTTMsgEventProc := MQTTMsg2Collect;
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
                                            Self.Handle,
                                            False,
                                            False);
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

  FPJHTimerPool := TPJHTimerPool.Create(Self);
  FPJHTimerPool.Add(OnSendMQTT2STOMP, 60000);
  FEquipStatusInfo := TEquipStatusInfo.Create(Self);
  FEquipStatusInfo.InitEquipStatusInfo;

  MQTTMsgEventThread.SetDisplayMsgProc(DisplayMQTTMessage2Memo);
  STOMPMsgEventThread.SetDisplayMsgProc(DisplaySTOMPMessage2Memo);
  InitMQTT('','',FSettings.MQTTServerIP,MQ_TOPIC_MQTT);//'127.0.0.1'
  InitSTOMP(FSettings.STOMPServerUserId,FSettings.STOMPServerPasswd,FSettings.STOMPServerIP,FSettings.STOMPServerTopic);
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

  if FSettings.MQTTServerIP = '' then
    FSettings.MQTTServerIP := '127.0.0.1';

  if FSettings.MQTTServerTopic = '' then
    FSettings.MQTTServerTopic := MQ_TOPIC_MQTT;

  if FSettings.STOMPServerTopic = '' then
    FSettings.STOMPServerTopic := MQ_TOPIC_STOMP;

  ApplyUI;
end;

//MQTT subscribe 데이터를 Collect에 저장 함
procedure TForm8.MQTTMsg2Collect(AMsgEvent: TMQTTMsgEvent);
var
  rec   : TCommandMsgRecord;
  LValue: TOmniValue;
  LEquipNo, LRunStatus: string;
begin
  if FIsDestroying then
  begin
    FpjhMQTTClass.DisConnectMQTT;
    FpjhSTOMPClass.DisConnectStomp;
    exit;
  end;

  LEquipNo := GetEquipNo(AMsgEvent.Topic);

  if LEquipNo <> '' then
  begin
    LRunStatus := AMsgEvent.FFMessage;
    FEquipStatusInfo.SetRunStatus2Collect(LEquipNo, LRunStatus);
//    TMQTTMsgEvent.Create(LEquipNo, LRunStatus,4).Queue;
  end;

//  rec.FCommand := AMsgEvent.Command;
//  rec.FTopic := AMsgEvent.Topic;
//  rec.FMessage := AMsgEvent.FFMessage;
//  LValue := TOmniValue.FromRecord<TCommandMsgRecord>(rec);
//
//  if not FpjhOmniMsgQClass.FResponseQueue.Enqueue(TOmniMessage.Create(0, LValue)) then
//    raise Exception.Create('Response queue is full when ProcessMQTTMsg!');
end;

procedure TForm8.OnSendCollect2MQUsingSTOMPCompleted(
  const task: IOmniTaskControl);
begin
//  if FIsDestroying then
//  begin
//    FPJHTimerPool.RemoveAll;
//    exit;
//  end;

//  TSTOMPMsgEvent.Create('', 'OnSendCollect2MQUsingSTOMPCompleted').Queue;
end;

procedure TForm8.OnSendMQTT2STOMP(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  if FIsDestroying then
  begin
    FPJHTimerPool.RemoveAll;
    exit;
  end;

  Parallel.Async(SendCollect2MQUsingSTOMP, Parallel.TaskConfig.OnTerminated(OnSendCollect2MQUsingSTOMPCompleted));
end;

procedure TForm8.ProcessSubscribeMsg;
var
  msg: TOmniMessage;
  FStompFrame: IStompFrame;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    FStompFrame := msg.MsgData.AsInterface as IStompFrame;
//    Memo1.Lines.Add(FStompFrame.GetBody);
  end;
end;

procedure TForm8.SendData2MQ(AMsg, ATopic: string);
begin
  FpjhSTOMPClass.StompSendMsg(AMsg, ATopic);
  FpjhSTOMPClass.DisConnectStomp;
end;

procedure TForm8.SendCollect2MQUsingSTOMP;
var
  LEquipRunStatusRecord: TEquipRunStatusRecord;
  LStr: string;
  i: integer;
  LESItem: TEquipStatusItem;
begin
  SetLength(LEquipRunStatusRecord.RunStatus_DynArr, High(EquipNameAry)+1);
  SetLength(LEquipRunStatusRecord.LastUpdated_DynArr, High(EquipNameAry)+1);

  for i := 0 to FEquipStatusInfo.EquipStatusCollect.Count - 1 do
  begin
    LESItem := FEquipStatusInfo.EquipStatusCollect.Items[i];
    LEquipRunStatusRecord.RunStatus_DynArr[i] := LESItem.RunStatus;
    LEquipRunStatusRecord.LastUpdated_DynArr[i] := LESItem.LastUpdatedDate;
  end;

  LStr := UTF8ToString(RecordSaveJSON(LEquipRunStatusRecord, TypeInfo(TEquipRunStatusRecord)));

  SendData2MQ(LStr, MQ_TOPIC_STOMP);

//  TSTOMPMsgEvent.Create('', 'SendCollect2MQUsingSTOMP : ' + LStr).Queue;
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

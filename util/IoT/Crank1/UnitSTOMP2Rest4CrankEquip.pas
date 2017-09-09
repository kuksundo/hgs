unit UnitSTOMP2Rest4CrankEquip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitSTOMPClass, UnitWorker4OmniMsgQ,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, UnitMQConfig,
  UnitEquipStatusClass, OtlParallel, OtlTaskControl;

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
    FEquipStatusInfo: TEquipStatusInfo;

    procedure InitVar;
    procedure FinalizeVar;
    procedure InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroySTOMP;

    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessSubscribeMsg;
    procedure SendData2MQ(AMsg: string; ATopic: string = '');

    procedure GetCollectFromSTOMP;
    procedure OnGetCollectFromSTOMPCompleted(const task: IOmniTaskControl);

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

uses otlcomm, OtlCommon, StompTypes, UnitSTOMPMsg.Events, UnitSTOMPMsg.EventThreads,
  SynCommons, IdHTTP;

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

procedure TForm8.FinalizeVar;
begin
  DestroySTOMP;
  FEquipStatusInfo.Free;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TForm8.FormDestroy(Sender: TObject);
begin
  FinalizeVar;
end;

procedure TForm8.GetCollectFromSTOMP;
var
  msg: TOmniMessage;
  FStompFrame: IStompFrame;
  LJSon: string;
  LUtf8: RawUTF8;
  LValue: TEquipRunStatusRecord;
  LIdHTTP: TIdHTTP;
  LUrl, LUrlOk: string;
  LESItem: TEquipStatusItem;
  i: integer;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    FStompFrame := msg.MsgData.AsInterface as IStompFrame;
    LJSon := FStompFrame.GetBody;

    LUtf8 := StringToUTF8(LJSon);
    RecordLoadJSON(LValue, pointer(LUtf8), TypeInfo(TEquipRunStatusRecord));
//    FEquipStatusInfo.SetCollectFromRecord(LValue);

    LIdHTTP := TIdHTTP.Create(nil);
    LIdHTTP.HandleRedirects := True;
    try
      try
         for i := Low(LValue.RunStatus_DynArr) to High(LValue.RunStatus_DynArr) do
        begin
          LESItem := FEquipStatusInfo.EquipStatusCollect.Items[i];
          LESItem.RunStatus := LValue.RunStatus_DynArr[i];
          LESItem.LastUpdatedDate := LValue.LastUpdated_DynArr[i];

          LUrl := 'http://10.100.45.201:49392/IOT/K44/PSA004_MachineWorkTran.jsp?MCNO=';
          LUrl := LUrl + LESItem.EquipName;
          LUrl := LUrl + '&WORK=' + LESItem.RunStatus;
          LUrlOk := LIdHTTP.Get(Lurl);
          TSTOMPMsgEvent.Create('', 'GetCollectFromSTOMP : ' + LUrl).Queue;
        end;
      except

      end;
    finally
      LIdHTTP.Free;
    end;

    TSTOMPMsgEvent.Create('', 'GetCollectFromSTOMP : ' + LJSon).Queue;
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
//    FpjhSTOMPClass.OnSTOMPMsgEventProc := STOMPMsg2Collect;

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

  FEquipStatusInfo := TEquipStatusInfo.Create(Self);
  FEquipStatusInfo.InitEquipStatusInfo;

  STOMPMsgEventThread.SetDisplayMsgProc(DisplayMessage2Memo);
  InitSTOMP(FSettings.MQServerUserId,FSettings.MQServerPasswd,FSettings.MQServerIP,FSettings.MQServerTopic);
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

  if FSettings.MQServerTopic = '' then
    FSettings.MQServerTopic := MQ_TOPIC;

  ApplyUI;
end;

procedure TForm8.OnGetCollectFromSTOMPCompleted(
  const task: IOmniTaskControl);
begin

end;

procedure TForm8.ProcessSubscribeMsg;
begin
  Parallel.Async(GetCollectFromSTOMP, Parallel.TaskConfig.OnTerminated(OnGetCollectFromSTOMPCompleted));
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

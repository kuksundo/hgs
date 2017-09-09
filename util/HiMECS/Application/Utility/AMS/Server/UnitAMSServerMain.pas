unit UnitAMSServerMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UnitFrameCommServer, AdvOfficePager, OtlContainerObserver, OtlComm, SynCommons,
  mORMot, Vcl.Menus, SynLog, UnitAlarmReportInterface, UnitAMSessionInterface,
  UnitAlarmConfigInterface, UnitAlarmConst, UnitLampInterface, UnitAMSServerConfig,
  UnitAlarmConfigClass, UnitCommUserClass, OtlCommon, UnitSTOMPClass,
  UnitWorker4OmniMsgQ;

const
  MSG_WORKER_RESULT = WM_USER;
  MSG_ADD_COMM_USER = WM_USER + 200;

  SERVER_ROOT_NAME = 'root';
  SERVER_PORT_NAME = '705';

type
  TLogInInfo = record
    FUserId,
    FPasswd,
    FIpAddress,
    FUserName,
    FSessionId,
    FUrl: string;
  end;

  TServiceAMS = class(TInterfacedObject, IAlarmReport, IAlarmConfig, ILampService, IAMSessionLog)
    //==========================================================================
    //IAlarmReport
    //==========================================================================
    procedure AddAlarm(AAlarm: RawUTF8);
    function AddAlarmRecord(const AAlarmRecord: TAlarmListRecord): Boolean;
    function ReleaseAlarmRecord(const AAlarmRecord: TAlarmListRecord): Boolean;
    //==========================================================================
    //IAlarmConfig
    //==========================================================================
    //공장 리스트 반환
    function GetPlantList: TRawUTF8DynArray;
    //공장 내에 있는 엔진 리스트 반환
    procedure GetEngineListFromPlant(PlantName: string; out EngList: TAlarmConfigCollect);
    //엔진의 센서(태그)리스트 반환
    procedure GetTagListFromEngine(ProjNo, EngNo: string; out TagList: TAlarmConfigEPCollect);
    //엔진에 설정된 알람 설정 리스트를 DB로 부터 조회하여 반환
    procedure GetAlarmConfigList(UserId, CatCode, ProjNo, EngNo: string;
      out TagNames: TAlarmConfigCollect);
    //알람 설정값을 DB에 저장함
    function SetAlarmConfigList2(const TagNames: RawJSON): Boolean;
    procedure SetAlarmConfigList(TagNames: TAlarmConfigCollect);
    //PC용 AlarmConfig 프로그램에서 설정 변경시 AlarmReporter에 통지 되는 함수
    //UniqueEngine = userid;projno;engno
    procedure NotifyAlarmConfigChanged(const UniqueEngine: TRawUTF8DynArray; const ACount: integer; const ASenderUrl: string);

    //==========================================================================
    //ILampService
    //==========================================================================
    function SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType: integer): string;
    function SetRedLampRetainPrev(ARedLamp: integer): string;
    function SetYellowLampRetainPrev(AYellowLamp: integer): string;
    function SetGreenLampRetainPrev(AGreenLamp: integer): string;
    function SetSoundRetainLamp(ASoundIndex: integer): string;

    //==========================================================================
    //IAMSessionLog
    //==========================================================================
    function LogIn(AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl: string): Boolean;
    function LogOut(AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl: string): Boolean;
    function GetAMSUserList: RawUTF8;
  end;

  TAMSServerMainF = class(TForm)
    ServerPage: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AlarmLogPage: TAdvOfficePage;
    FCS: TFrameCommServer;
    SendSMS1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure SendSMS1Click(Sender: TObject);
  private
    FSettings : TConfigSettings;

    FResponseQueue   : TOmniMessageQueue;
    FResponseObserver: TOmniContainerWindowsMessageObserver;
    FWorker          : TThread;
    FpjhSTOMPClass: TpjhSTOMPClass;

    procedure ProcessResults;
    procedure Query(value: integer);
    procedure StartWorker;
    procedure StopWorker;
    procedure WorkerResult(var msg: TMessage); message MSG_WORKER_RESULT;
    procedure WMOnReceiveSubScribeMsg(var msg: TMessage); message MSG_RESULT;
    procedure ProcessOnReceiveSubScribeMsg;

    procedure StartServer;
    procedure TestLamp;
  public
    FExeFilePath: string;
    FCommandQueue    : TOmniMessageQueue;

    FRedLamp,
    FYellowLamp,
    FGreenLamp,
    FSoundIndex: integer;

    procedure InitVar;
    procedure DestroyVar;
    procedure InitSTOMP;
    procedure DestroySTOMP;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
    //ANotifyList = userid;catno;projno;engno(알람 설정이 변경된 리스트)
    procedure NotifyAlarmChange2Reporter(ANotifyList:TStringList; ASenderUrl: string);
    procedure AddCommUser(AValue: TOmniValue);
  end;

var
  AMSServerMainF: TAMSServerMainF;
  g_ServiceQuerying: Boolean; //서비스 실행 중이면 true

implementation

uses SyncObjs, UnitDM, HiMECSConst, UnitLampTest, UnitHHIMessage,
  QLite, ActiveX, CommonUtil;
//  InvokeRegistry, Rio, SOAPHTTPClient, SOAPHTTPTrans, HHI_WebService;

{$R *.dfm}

type
  TWorker = class(TThread)
  strict private
    FCommandQueue : TOmniMessageQueue;
    FResponseQueue: TOmniMessageQueue;
    FStopEvent    : TEvent;
  protected
    procedure Execute; override;
    procedure NotifyAlarm2User(AAlarmRecord: TAlarmListRecord);
  public
    constructor Create(commandQueue, responseQueue: TOmniMessageQueue);
    destructor Destroy; override;
    procedure Stop;

    //Aflag = 'A'; //쪽지
    //      = 'B'; //SMS
    //AUser = 사번
    procedure Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser, AFlag: string);
    procedure Send_Mail(AAlarmRecord: TAlarmListRecord);
  end;

{ TAMSServerMainF }

procedure TAMSServerMainF.AddCommUser(AValue: TOmniValue);
var
  LLogInInfo: TLogInInfo;
begin
  LLogInInfo := AValue.ToRecord<TLogInInfo>;

  with LLogInInfo do
    FCS.AddCommUser2Collect(FUserId, FPasswd, FIpAddress, FUserName, FSessionId, FUrl);
end;

procedure TAMSServerMainF.ApplyUI;
begin

end;

procedure TAMSServerMainF.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.Free;
end;

procedure TAMSServerMainF.DestroyVar;
begin
  StopWorker;
  FCS.DestroyHttpServer;
  FSettings.Free;
end;

procedure TAMSServerMainF.FormCreate(Sender: TObject);
begin
  InitVar;
  StartWorker;
end;

procedure TAMSServerMainF.InitSTOMP;
begin
  if FSettings.MQServerTopic = '' then
    FSettings.MQServerTopic := FIPCClientAll.GetEngineName;//'UniqueEngineName';

  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.Create(FSettings.MQServerUserId,
                                            FSettings.MQServerPasswd,
                                            FSettings.MQServerIP,
                                            FSettings.MQServerTopic,
                                            Self.Handle);
  end;
end;

procedure TAMSServerMainF.InitVar;
begin
  FExeFilePath := ExtractFilePath(Application.ExeName);

  FSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadConfigFromFile;

  TJSONSerializer.RegisterCollectionForJSON(TAlarmConfigCollect, TAlarmConfigItem);
  TJSONSerializer.RegisterCollectionForJSON(TAlarmConfigEPCollect, TAlarmConfigEPItem);

  FCS.FStartServerProc := StartServer;
  FCS.FAutoStartInterval := 5000; //10초
end;

procedure TAMSServerMainF.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);

  AForm.NoAlarmLampCB.Checked := IntToBool(StrToIntDef(AForm.NoAlarmLampEdit.Text, 0));
end;

procedure TAMSServerMainF.LoadConfigForm2Object(AForm: TConfigF);
begin
  AForm.NoAlarmLampEdit.Text := IntToStr(BoolToInt(AForm.NoAlarmLampCB.Checked));
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TAMSServerMainF.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);

  if FSettings.ServerPort = '' then
    FSettings.ServerPort := SERVER_PORT_NAME;

  if FSettings.ServerRootName = '' then
    FSettings.ServerRootName := SERVER_ROOT_NAME;
end;

procedure TAMSServerMainF.NotifyAlarmChange2Reporter(ANotifyList:TStringList;
  ASenderUrl: string);
var
  i,j,lsum: integer;
  LUrl,LUser: string;
begin
  //로그인 리스트 순회
  lsum := 0;
  for i := 0 to FCS.FCommUserList.CommUserCollect.Count - 1 do
  begin
    for j := 0 to ANotifyList.Count - 1 do
    begin
      LUser := ANotifyList.Strings[j]; //UserId;Cat;ProjNo;EngNo
      LUrl := FCS.FCommUserList.CommUserCollect.Items[i].Url;   //http://ipaddr:portno/rootname/

      //Alarm Change Notify한 Reporter 자신에게는 Notify 보내지 않음
      if LUrl <> ASenderUrl then
      begin
        LUrl := LUrl + 'AlarmReportCallBack/AlarmConfigChangedPerEngine?UniqueEngine=' + LUser +
          '&SenderUrl=' + ASenderUrl;
        DM1.getContent(LUrl);
        inc(lsum);
      end;
    end;
  end;

//  Caption := Caption + ' : Get Count (' + IntToStr(LSum) + ')';
  ANotifyList.Free;
end;

procedure TAMSServerMainF.ProcessOnReceiveSubScribeMsg;
var
  msg: TOmniMessage;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    SetParamItemValueFromModbusComm(msg.MsgData);
    FCS.DisplayMessage(DateTimeToStr(now) + ': ProcessOnReceiveSubScribeMsg = ' + msg.MsgData,dtCommLog);
  end;
end;

procedure TAMSServerMainF.ProcessResults;
var
  msg: TOmniMessage;
  rec    : TAlarmListRecord;
  LNotifyApps: TNotifyApps;
  LFlag, LMsg, LAction: string;
  LUrl: string;
  LStrList: TStringList;
begin
  while FResponseQueue.TryDequeue(msg) do
  begin
    case msg.MsgID of
      0: begin
        rec := msg.MsgData.ToRecord<TAlarmListRecord>;
        LNotifyApps := IntegerToNotifyAppSet(rec.FNotifyApps);
        LMsg := LAction + rec.FProjNo + '(' + rec.FEngNo + ') :' + rec.FAlarmMessage + '(현재값:' + rec.FSensorValue + ')';

        FCS.DisplayMessage(DateTimeToStr(now) + ': TServiceAMS.AddAlarmRecord = ' + rec.FUserID + '_' +
          rec.FCategory + '_' + rec.FProjNo + '_' + rec.FEngNo + '_' + rec.FTagName +
          ' : ' + LMsg,dtCommLog);

        if rec.FAlarmAction = aaAlarmIssue then
          LAction := '[알람발생]'
        else
        if rec.FAlarmAction = aaAlarmRelease then
          LAction := '[알람해제]';

      end;
      1: begin
        LStrList := msg.MsgData.AsObject as TStringList;
        LUrl := LStrList.Strings[LStrList.Count-1];
        LStrList.Delete(LStrList.Count-1);
        NotifyAlarmChange2Reporter(LStrList, LUrl);
      end;
      2: begin
        AddCommUser(msg.MsgData);
      end;
    end;
  end;
end;

procedure TAMSServerMainF.Query(value: integer);
begin
  if GetCurrentThreadID = MainThreadID then
//    lbLog.ItemIndex := lbLog.Items.Add(Format('%d * 2 ?', [value]))
  else
    TThread.Synchronize(nil,
      procedure
      begin
//        lbLog.ItemIndex := lbLog.Items.Add(Format('%d * 2 ?', [value]));
      end);

//  if not FCommandQueue.Enqueue(TOmniMessage.Create(0 {ignored}, value)) then
//    raise Exception.Create('Command queue is full!');
end;

procedure TAMSServerMainF.SendSMS1Click(Sender: TObject);
begin
  TWorker(FWorker).Send_Message('Head','Title','Content','A379042','A379042','B');
end;

procedure TAMSServerMainF.SetConfig;
var
  LConfigF: TConfigF;
begin
  LConfigF := TConfigF.Create(Self);

  try
    LoadConfig2Form(LConfigF);

    if LConfigF.ShowModal = mrOK then
    begin
      LoadConfigForm2Object(LConfigF);
      FSettings.Save();
      ApplyUI;
    end;
  finally
    LConfigF.Free;
  end;
end;

procedure TAMSServerMainF.StartServer;
begin
  FCS.CreateHttpServer(FSettings.ServerRootName, 'AMSServer.json', FSettings.ServerPort, TServiceAMS,
    [TypeInfo(IAlarmReport), TypeInfo(IAlarmConfig), TypeInfo(ILampService), TypeInfo(IAMSessionLog)],
    sicClientDriven , True);//sicClientDriven
  FCS.ServerStartBtnClick(nil);
end;

procedure TAMSServerMainF.StartWorker;
begin
  FCommandQueue := TOmniMessageQueue.Create(1000);

  FResponseQueue := TOmniMessageQueue.Create(1000, false);
  FResponseObserver := CreateContainerWindowsMessageObserver(Handle, MSG_WORKER_RESULT, 0, 0);
  FResponseQueue.ContainerSubject.Attach(FResponseObserver, coiNotifyOnAllInserts);

  FWorker := TWorker.Create(FCommandQueue, FResponseQueue);
end;

procedure TAMSServerMainF.StopWorker;
begin
  if assigned(FWorker) then begin
    TWorker(FWorker).Stop;
    FWorker.WaitFor;
    FreeAndNil(FWorker);
  end;

  if assigned(FResponseQueue) then begin
    FResponseQueue.ContainerSubject.Detach(FResponseObserver, coiNotifyOnAllInserts);
    FreeAndNil(FResponseObserver);
    ProcessResults;
    FreeAndNil(FResponseQueue);
  end;

  FreeAndNil(FCommandQueue);
end;

procedure TAMSServerMainF.TestLamp;
var
  LampTestF: TLampTestF;
begin
  LampTestF := TLampTestF.Create(Self);

  try
    with LampTestF do
    begin
      ShowModal;
    end;
  finally
    LampTestF.Free;
  end;
end;

procedure TAMSServerMainF.WMOnReceiveSubScribeMsg(var msg: TMessage);
begin
  ProcessOnReceiveSubScribeMsg;
end;

procedure TAMSServerMainF.WorkerResult(var msg: TMessage);
begin
  ProcessResults;
end;

{ TWorker }

constructor TWorker.Create(commandQueue, responseQueue: TOmniMessageQueue);
begin
  inherited Create;
  FCommandQueue := commandQueue;
  FResponseQueue := responseQueue;
  FStopEvent := TEvent.Create;
end;

destructor TWorker.Destroy;
begin
  FreeAndNil(FStopEvent);
  inherited;
end;

procedure TWorker.Execute;
var
  handles: array [0..1] of THandle;
  msg    : TOmniMessage;
  rec    : TAlarmListRecord;
begin
  CoInitialize(nil);
  try
    handles[0] := FStopEvent.Handle;
    handles[1] := FCommandQueue.GetNewMessageEvent;
    while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
    begin
      while FCommandQueue.TryDequeue(msg) do
      begin
        case msg.MsgID of
          0: begin
            rec := msg.MsgData.ToRecord<TAlarmListRecord>;
            NotifyAlarm2User(rec);

            //msg.MsgID is ignored in this demo
            //msg.MsgData contains a number which will be multiplied by 2,
            //converted into a string, prepended by '=' and returned to the owner form
            if not FResponseQueue.Enqueue(TOmniMessage.Create(0, msg.MsgData)) then
              raise Exception.Create('Response queue is full!');
          end;
          1: begin
            if not FResponseQueue.Enqueue(TOmniMessage.Create(msg.MsgID, msg.MsgData)) then
              raise Exception.Create('Response queue is full!(LogIn)');
          end;
          2: begin
            if not FResponseQueue.Enqueue(TOmniMessage.Create(msg.MsgID, msg.MsgData)) then
              raise Exception.Create('Response queue is full!(LogIn)');
          end;
        end;
      end;
    end;
  finally
    CoUnInitialize;
  end;
end;

procedure TWorker.NotifyAlarm2User(AAlarmRecord: TAlarmListRecord);
var
  LFlag, LMsg, LAction: string;
  LNotifyApps: TNotifyApps;
  LUser, LUserList: string;
begin
  LNotifyApps := IntegerToNotifyAppSet(AAlarmRecord.FNotifyApps);
  if AAlarmRecord.FAlarmAction = aaAlarmIssue then
    LAction := '[알람발생]'
  else
  if AAlarmRecord.FAlarmAction = aaAlarmRelease then
    LAction := '[알람해제]';

  LMsg := LAction + AAlarmRecord.FProjNo + '(' + AAlarmRecord.FEngNo + ') :' + AAlarmRecord.FAlarmMessage + '(현재값:' + AAlarmRecord.FSensorValue + ')';

  LUserList := AAlarmRecord.FRecipients;

  while LUserList <> '' do
  begin
    LUser := strToken(LUserList, ';');

    if naSMS in LNotifyApps then
    begin
      LFlag := 'B';
      Send_Message('[알람]', 'AlarmEvent', LMsg, AAlarmRecord.FUserID, LUser, LFlag); //+ ', at ' + FormatDateTime('m월dd일 hh시nn분', LMailItem.ReceivedTime)
    end;
    Application.ProcessMessages;

    if naNote in LNotifyApps then
    begin
      LFlag := 'A';
      Send_Message('[알람]', 'AlarmEvent', LMsg, AAlarmRecord.FUserID, LUser, LFlag); //+ ', at ' + FormatDateTime('m월dd일 hh시nn분', LMailItem.ReceivedTime)
    end;
    Application.ProcessMessages;
  end;

end;

//function TWorker.SendHHIMessage(ATXK0SMS2: TXK0SMS2): string;
//var
//  LRequest: WSTXK0SMS2_REQ;
//  LRespond: WSTXK0SMS2_RSP;
//begin
//  try
//    GHTTPRIO1 := THTTPRIO.Create(nil);
//    GHTTPRIO1.URL := 'http://biztalk.hhi.co.kr/HHI_IFService/HHI_WebService.asmx';
//
//    if Assigned(GHTTPRIO1) then
//    begin
//      GHTTPRIO1.OnAfterExecute := GEventHandlers.HTTPRIO1AfterExecute;
//      GHTTPRIO1.OnBeforeExecute := GEventHandlers.HTTPRIO1BeforeExecute;
//
//      SetLength(LRequest, 1);
//      LRequest[0] := ATXK0SMS2;
//      LRespond := (GHTTPRIO1 as HHI_WebServiceSoap).Send_TXK0SMS2(LRequest);
//      Result := LRespond.STATUS;
//    end;
//  finally
//    GHTTPRIO1.FreeOnRelease;
//  end;
//end;

procedure TWorker.Send_Mail(AAlarmRecord: TAlarmListRecord);
begin
;
end;

procedure TWorker.Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser,
  AFlag: string);
var
  lstr,
  lcontent : String;
begin
//  헤더의 길이가 21byte를 넘지 않아야 함.
//  lhead := 'HiTEMS-문제점보고서';
//  ltitle   := '업무변경건';
  lcontent := AContent;

  if Aflag = 'B' then
  begin
    while True do
    begin
      if lcontent = '' then
        Break;

      if Length(lcontent) > 90 then
      begin
        lstr := Copy(lcontent,1,90);
        lcontent := Copy(lcontent,91,Length(lcontent)-90);
      end else
      begin
        lstr := Copy(lcontent,1,Length(lcontent));
        lcontent := '';
      end;

      //문자 메세지는 title(lstr)만 보낸다.
      Send_Message_Main_CODE(AFlag,ASendUser,ARecvUser,AHead,lstr,ATitle);
    end;
  end
  else
  begin
    lstr := lcontent;
    Send_Message_Main_CODE(AFlag,ASendUser,ARecvUser,AHead,lstr,ATitle);
  end;
end;

//procedure TWorker.Send_Message_Main_CODE(FFlag, FSendID, FRecvID, FHead, FTitle,
//  FContent: String);
//var
//  LTXK0SMS2 : TXK0SMS2;
//begin
//
//  LTXK0SMS2 := TXK0SMS2.Create;
//  try
//    LTXK0SMS2.SEND_SABUN := FSendID;
//    LTXK0SMS2.RCV_SABUN := FRecvID;
//    LTXK0SMS2.SYS_TYPE := '112';
//    LTXK0SMS2.NOTICE_GUBUN := FFlag;
//
//    LTXK0SMS2.TITLE := FTitle;
//    //LTXK0SMS2.SEND_HPNO := '010-4190-6742';
//    //LTXK0SMS2.RCV_HPNO := '010-3351-7553';
//    LTXK0SMS2.CONTENT := FContent;
//    LTXK0SMS2.ALIM_HEAD := FHead;
//
//    SendHHIMessage(LTXK0SMS2);
//  finally
//    LTXK0SMS2.Free;
//  end;
//end;

procedure TWorker.Stop;
begin
  FStopEvent.SetEvent;
end;

{ TServiceAMS }

function TServiceAMS.AddAlarmRecord(const AAlarmRecord: TAlarmListRecord): Boolean;
var
  LOmniValue: TOmniValue;
begin
  Result := False;

  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    LOmniValue := TOmniValue.FromRecord<TAlarmListRecord>(AAlarmRecord);
    if not AMSServerMainF.FCommandQueue.Enqueue(TOmniMessage.Create(0, LOmniValue)) then
      raise Exception.Create('Command queue is full!');
  finally
    g_ServiceQuerying := False;
  end;

  Result := True;
end;

procedure TServiceAMS.AddAlarm(AAlarm: RawUTF8);
begin
//  Result := False;
  AMSServerMainF.FCS.DisplayMessage(DateTimeToStr(now) + ' : ' + AAlarm,dtCommLog);
//  Result := True;
end;

procedure TServiceAMS.GetAlarmConfigList(UserId, CatCode, ProjNo,
  EngNo: string; out TagNames: TAlarmConfigCollect);
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    DM1.GetAlarmConfigList(UserId, CatCode, ProjNo, EngNo, DM1.FAlarmConfigCollect);
    CopyObject(DM1.FAlarmConfigCollect, TagNames);
  finally
    g_ServiceQuerying := False;
  end;
end;

function TServiceAMS.GetAMSUserList: RawUTF8;
begin

end;

procedure TServiceAMS.GetEngineListFromPlant(PlantName: string;
  out EngList: TAlarmConfigCollect);
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    DM1.GetEngineListFromPlant(PlantName, DM1.FAlarmConfigCollect);
    CopyObject(DM1.FAlarmConfigCollect, EngList);
  finally
    g_ServiceQuerying := False;
  end;
end;

function TServiceAMS.GetPlantList: TRawUTF8DynArray;
var
  LDynArr: TDynArray;
  LCount: integer;
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;
  try
    LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
    Result := DM1.GetPlantList;
  finally
    g_ServiceQuerying := False;
  end;
end;

procedure TServiceAMS.GetTagListFromEngine(ProjNo, EngNo: string;
  out TagList: TAlarmConfigEPCollect);
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;
  try
    DM1.GetTagListFromEngine(ProjNo, EngNo, DM1.FAlarmConfigEPCollect);
    CopyObject(DM1.FAlarmConfigEPCollect, TagList);
  finally
    g_ServiceQuerying := False;
  end;
end;

function TServiceAMS.LogIn(AUserId, APasswd, AIpAddress, AUserName, ASessionId,
  AUrl: string): Boolean;
var
  LOmniValue: TOmniValue;
  LLogInInfo: TLogInInfo;
begin
  Result := False;

  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    LLogInInfo.FUserId := AUserId;
    LLogInInfo.FPasswd := APasswd;
    LLogInInfo.FIpAddress := AIpAddress;
    LLogInInfo.FUserName := AUserName;
    LLogInInfo.FSessionId := ASessionId;
    LLogInInfo.FUrl := AUrl;

    LOmniValue := TOmniValue.FromRecord<TLogInInfo>(LLogInInfo);
    if not AMSServerMainF.FCommandQueue.Enqueue(TOmniMessage.Create(2, LOmniValue)) then
      raise Exception.Create('Command queue is full!(LogIn)');
  finally
    g_ServiceQuerying := False;
  end;

  Result := True;
//  AMSServerMainF.FCS.AddCommUser2Collect(AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl);
end;

function TServiceAMS.LogOut(AUserId, APasswd, AIpAddress,
  AUserName, ASessionId, AUrl: string): Boolean;
begin
  AMSServerMainF.FCS.DeleteCommUser2Collect(AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl);
end;

procedure TServiceAMS.NotifyAlarmConfigChanged(const UniqueEngine: TRawUTF8DynArray;
  const ACount: integer; const ASenderUrl: string);
var
  LStrList: TStringList;
  i: integer;
  LOmniValue: TOmniValue;
begin
  LStrList := TStringList.Create;
  try
    //userid;cat;projno;engno
    for i := Low(UniqueEngine) to ACount - 1 do
      LStrList.Add(UTF8ToString(UniqueEngine[i]));

    //맨 마지막에 SendUrl 저장함
    LStrList.Add(ASenderUrl);

    LOmniValue := LStrList;
    if not AMSServerMainF.FCommandQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
      raise Exception.Create('Command queue is full!');

//    AMSServerMainF.NotifyAlarmChange2Reporter(LStrList, ASenderUrl);
  finally
//    LStrList.Free;
  end;
end;

function TServiceAMS.ReleaseAlarmRecord(
  const AAlarmRecord: TAlarmListRecord): Boolean;
var
  LAlarmListRecord: TAlarmListRecord;
  LOmniValue: TOmniValue;
begin
  Result := False;

  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    LAlarmListRecord := AAlarmRecord;
    LOmniValue := TOmniValue.FromRecord<TAlarmListRecord>(AAlarmRecord);
    if not AMSServerMainF.FCommandQueue.Enqueue(TOmniMessage.Create(0 {ignored}, LOmniValue)) then
      raise Exception.Create('Command queue is full!');
  finally
    g_ServiceQuerying := False;
  end;

  Result := True;
end;

procedure TServiceAMS.SetAlarmConfigList(TagNames: TAlarmConfigCollect);
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
  finally
    g_ServiceQuerying := False;
  end;
end;

function TServiceAMS.SetAlarmConfigList2(const TagNames: RawJSON): Boolean;
var
  LStrList: TStringList;
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    LStrList := DM1.SaveAlarmConfigList2DB(TagNames);
    AMSServerMainF.NotifyAlarmChange2Reporter(LStrList,'');
    Result := True;
  finally
    g_ServiceQuerying := False;
//    LStrList.Free;
  end;
end;

function TServiceAMS.SetGreenLampRetainPrev(AGreenLamp: integer): string;
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    with AMSServerMainF do
      Result := _SetLamp(FRedLamp, FYellowLamp, AGreenLamp, 0, FSoundIndex);
  finally
    g_ServiceQuerying := False;
  end;
end;

function TServiceAMS.SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont,
  ASoundType: integer): string;
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    with AMSServerMainF do
    begin
      FRedLamp := ARedLamp;
      FYellowLamp := AYellowLamp;
      FGreenLamp := AYellowLamp;
      FSoundIndex := ASoundType;
    end;

    Result := _SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType);
  finally
    g_ServiceQuerying := False;
  end;
end;

function TServiceAMS.SetRedLampRetainPrev(ARedLamp: integer): string;
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    with AMSServerMainF do
      Result := _SetLamp(ARedLamp, FYellowLamp, FGreenLamp, 0, FSoundIndex);
  finally
    g_ServiceQuerying := False;
  end;
end;

function TServiceAMS.SetSoundRetainLamp(ASoundIndex: integer): string;
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    with AMSServerMainF do
      Result := _SetLamp(FRedLamp, FYellowLamp, FGreenLamp, 0, ASoundIndex);
  finally
    g_ServiceQuerying := False;
  end;
end;

function TServiceAMS.SetYellowLampRetainPrev(AYellowLamp: integer): string;
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    with AMSServerMainF do
      Result := _SetLamp(FRedLamp, AYellowLamp, FGreenLamp, 0, FSoundIndex);
  finally
    g_ServiceQuerying := False;
  end;
end;

end.

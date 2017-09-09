unit UnitCraneIoTServerMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UnitFrameCommServer, AdvOfficePager, OtlContainerObserver, OtlComm, SynCommons,
  UnitCrankIotSensorInterface, mORMot, Vcl.Menus,
  SynLog;

const
  MSG_WORKER_RESULT = WM_USER;
  SERVER_ROOT_NAME = 'root';
  SERVER_PORT_NAME = '706';

type
  TServiceAMS = class(TInterfacedObject, ICraneSensor)
    //==========================================================================
    //ICraneSensor
    //==========================================================================
    function AddCraneXYnLoad(X,Y,Load: string): Boolean;
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

    procedure ProcessResults;
    procedure Query(value: integer);
    procedure StartWorker;
    procedure StopWorker;
    procedure WorkerResult(var msg: TMessage); message MSG_WORKER_RESULT;

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
    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
  end;

var
  AMSServerMainF: TAMSServerMainF;
  g_ServiceQuerying: Boolean; //서비스 실행 중이면 true

implementation

uses SyncObjs, UnitDM, OtlCommon, HiMECSConst, UnitLampTest, UnitHHIMessage;
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
//    procedure Send_Message_Main_CODE(FFlag,FSendID,FRecvID,FHead,FTitle,FContent:String); // 메세지 메인 함수
//    function SendHHIMessage(ATXK0SMS2: TXK0SMS2): string;
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

procedure TAMSServerMainF.ApplyUI;
begin

end;

procedure TAMSServerMainF.DestroyVar;
begin
  FCS.DestroyHttpServer;
  FSettings.Free;
end;

procedure TAMSServerMainF.FormCreate(Sender: TObject);
begin
  InitVar;
  StartWorker;
end;

procedure TAMSServerMainF.InitVar;
begin
  FExeFilePath := ExtractFilePath(Application.ExeName);

  FSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadConfigFromFile;

  TJSONSerializer.RegisterCollectionForJSON(TAlarmConfigCollect, TAlarmConfigItem);
  TJSONSerializer.RegisterCollectionForJSON(TAlarmConfigEPCollect, TAlarmConfigEPItem);

  FCS.FStartServerProc := StartServer;
  FCS.FAutoStartInterval := 10000; //10초
end;

procedure TAMSServerMainF.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TAMSServerMainF.LoadConfigForm2Object(AForm: TConfigF);
begin
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

procedure TAMSServerMainF.ProcessResults;
var
  msg: TOmniMessage;
  rec    : TAlarmListRecord;
  LNotifyApps: TNotifyApps;
  LFlag, LMsg, LAction: string;
begin
  while FResponseQueue.TryDequeue(msg) do
  begin
    rec := msg.MsgData.ToRecord<TAlarmListRecord>;
    LNotifyApps := IntegerToNotifyAppSet(rec.FNotifyApps);
    if rec.FAlarmAction = aaAlarmIssue then
      LAction := '[알람발생]'
    else
    if rec.FAlarmAction = aaAlarmRelease then
      LAction := '[알람해제]';

    LMsg := LAction + rec.FProjNo + '(' + rec.FEngNo + ') :' + rec.FAlarmMessage + '(현재값:' + rec.FSensorValue + ')';

    if naSMS in LNotifyApps then
    begin
      LFlag := 'B';
      TWorker(FWorker).Send_Message('[알람]', 'AlarmEvent', LMsg, rec.FUserID, rec.FUserID, LFlag); //+ ', at ' + FormatDateTime('m월dd일 hh시nn분', LMailItem.ReceivedTime)
    end;
    Application.ProcessMessages;

    if naNote in LNotifyApps then
    begin
      LFlag := 'A';
      TWorker(FWorker).Send_Message('[알람]', 'AlarmEvent', LMsg, rec.FUserID, rec.FUserID, LFlag); //+ ', at ' + FormatDateTime('m월dd일 hh시nn분', LMailItem.ReceivedTime)
    end;
    Application.ProcessMessages;

    FCS.DisplayMessage(DateTimeToStr(now) + ': TServiceAMS.AddAlarmRecord = ' + rec.FUserID + '_' +
      rec.FCategory + '_' + rec.FProjNo + '_' + rec.FEngNo + '_' + rec.FTagName +
      ' : ' + LMsg,dtCommLog);
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
  FCS.CreateHttpServer(FSettings.ServerRootName, 'BWQuery.json', FSettings.ServerPort, TServiceAMS,
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
//  rec    : TAlarmListRecord;
//  LNotifyApps: TNotifyApps;
//  LFlag: string;
begin
  handles[0] := FStopEvent.Handle;
  handles[1] := FCommandQueue.GetNewMessageEvent;
  while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
  begin
    while FCommandQueue.TryDequeue(msg) do
    begin
//      rec := msg.MsgData.ToRecord<TAlarmListRecord>;
//      LNotifyApps := IntegerToNotifyAppSet(rec.FNotifyApps);
//
//      if naSMS in LNotifyApps then
//      begin
//        LFlag := 'B';
////        Send_Message('Head','Title','Content','A379042','A379042','B');
//        Send_Message('[알람]', 'AlarmEvent', '[알람]' + rec.FProjNo + '(' +
//          rec.FEngNo + ') :' + rec.FAlarmMessage, rec.FUserID, rec.FUserID, LFlag); //+ ', at ' + FormatDateTime('m월dd일 hh시nn분', LMailItem.ReceivedTime)
//      end;
//      Application.ProcessMessages;
//
//      if naNote in LNotifyApps then
//      begin
//        LFlag := 'A';
//        Send_Message('[알람]', 'AlarmEvent', '[알람]' + rec.FProjNo + '(' +
//          rec.FEngNo + ') :' + rec.FAlarmMessage, rec.FUserID, rec.FUserID, LFlag); //+ ', at ' + FormatDateTime('m월dd일 hh시nn분', LMailItem.ReceivedTime)
//      end;
//      Application.ProcessMessages;

      //msg.MsgID is ignored in this demo
      //msg.MsgData contains a number which will be multiplied by 2,
      //converted into a string, prepended by '=' and returned to the owner form
      if not FResponseQueue.Enqueue(TOmniMessage.Create(0 {ignored}, msg.MsgData)) then
        raise Exception.Create('Response queue is full!');
    end;
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
    if not AMSServerMainF.FCommandQueue.Enqueue(TOmniMessage.Create(0 {ignored}, LOmniValue)) then
      raise Exception.Create('Command queue is full!');
  finally
    g_ServiceQuerying := False;
  end;

  Result := True;
end;

function TServiceAMS.AddAlarm(AAlarm: RawUTF8): Boolean;
begin
  Result := False;
  AMSServerMainF.FCS.DisplayMessage(DateTimeToStr(now) + AAlarm,dtCommLog);
  Result := True;
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
begin

end;

function TServiceAMS.LogOut(AUserId, APasswd, AIpAddress,
  ASessionId: string): Boolean;
begin

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
begin
  if g_ServiceQuerying then
    exit;

  g_ServiceQuerying := True;

  try
    DM1.SaveAlarmConfigList2DB(TagNames);
    Result := True;
  finally
    g_ServiceQuerying := False;
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

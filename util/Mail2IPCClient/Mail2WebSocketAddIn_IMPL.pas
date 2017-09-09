unit Mail2WebSocketAddIn_IMPL;

interface

uses
  SysUtils, ComObj, ComServ, ActiveX, Variants, Outlook2010, Office2010, adxAddIn,
  System.Types, System.StrUtils, CalContextAddIn_TLB, System.Classes, Dialogs,
  Winapi.Windows, OtlCommon, OtlComm, System.SyncObjs, OtlContainerObserver,
  adxHostAppEvents, adxolFormsManager, IPC.Events, CommonData,
  IdMessage, UnitSynLog,  SynCommons,
  SynLog,
  mORMot,
  SynBidirSock,
  mORMotHttpServer,
  MailCallbackInterface;

const
  OLUSERID = 'A379042';
  OLMAILADDR = 'jhpark@hyundai-gs.com';
type
  TMail2WSService = class(TInterfacedObject,IMailService)
  protected
    fConnected: array of IMailCallback;
  public
    procedure Join(const pseudo: string; const callback: IMailCallback);
    procedure ServerExecute(const command,msg: string);
    procedure CallbackReleased(const callback: IInvokable; const interfaceName: RawUTF8);
  end;

  TCoCalContextAddIn = class(TadxAddin, ICoCalContextAddIn)
  end;

  TWorker4STOMP = class(TThread)
  private
    FSendMsgQueue: TOmniMessageQueue;
    FStopEvent    : TEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(sendQueue: TOmniMessageQueue);
    destructor Destroy; override;
    procedure Stop;
  end;

  TWorker4OLMsg = class(TThread)
  private
    FOLMsgQueue: TOmniMessageQueue;
    FStopEvent    : TEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(sendQueue: TOmniMessageQueue);
    destructor Destroy; override;
    procedure Stop;
  end;

  TAddInModule = class(TadxCOMAddInModule)
    adxContextMenu1: TadxContextMenu;
    adxOutlookAppEvents1: TadxOutlookAppEvents;
    procedure adxContextMenu1Controls0Controls0Click(Sender: TObject);
    procedure adxOutlookAppEvents1Reminder(ASender: TObject;
      const Item: IDispatch);
    procedure adxOutlookAppEvents1ReminderFire(ASender: TObject;
      const ReminderObject: IDispatch);
    procedure adxOutlookAppEvents1NewMail(Sender: TObject);
    procedure adxOutlookAppEvents1NewMailEx(ASender: TObject;
      const EntryIDCollection: WideString);
    procedure adxCOMAddInModuleAddInInitialize(Sender: TObject);
    procedure adxCOMAddInModuleCreate(Sender: TObject);
    procedure adxCOMAddInModuleDestroy(Sender: TObject);
  private
    FConsumeEvent, FProduceEvent: Event;
    FWorker4OLMsg: TWorker4OLMsg;
    FOLMsgQueue,
    FSendMsgQueue: TOmniMessageQueue;
    FInboxStoreIdList: TStringList;
    FIPCClientList: TStringList;
  protected
    procedure GetInboxList;
    procedure DoItemAdd(ASender: TObject; const Item: IDispatch);
    procedure Log(Amsg: string; AIsSaveLog: Boolean = False;
      AMsgLevel: TSynLogInfo = sllInfo);
  public
    //Aflag = 'A'; //쪽지
    //      = 'B'; //SMS
    //AUser = 사번
    procedure Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser, AFlag: string);
    procedure SendMailInfoToNamedPipe(AEntryIDList: WideString);
    function AssignOLMailItemToIdMessage(AOLMailItem: MailItem;
      out AIdMsg: TIdMessage): boolean;
    procedure AssignOLRecipientToIdMsg(AOLMailItem: MailItem;
      out AIdMsg: TIdMessage);
    procedure AssignOLAttachmentToIdMsg(AOLMailItem: MailItem;
      out AIdMsg: TIdMessage);
  end;

var
  g_WorkingFolder: MAPIFolder;

implementation

uses HHI_WebService, UnitHHIMessage, CommonUtil_Unit, IdEMailAddress,
  IdAttachmentFile, StompClient, StompTypes;

{$R *.dfm}

procedure TAddInModule.adxCOMAddInModuleAddInInitialize(Sender: TObject);
//var
//  IFolderInbox: MAPIFolder;
begin
  Log(DateTimeToStr(now) + ':: adxCOMAddInModuleAddInInitialize', True);
  FOLMsgQueue := TOmniMessageQueue.Create(1000);
  FWorker4OLMsg := TWorker4OLMsg.Create(FOLMsgQueue);
  InitSynLog;
  FConsumeEvent := Event.Create(CONSUME_EVENT_NAME);
  FProduceEvent := Event.Create(PRODUCE_EVENT_NAME);
  FInboxStoreIdList := TStringList.Create;
  GetInboxList;
  FIPCClientList := TStringList.Create;

//  FItems := nil;
//  if Assigned(OutlookApp) then begin
//    IFolderInbox := OutlookApp.GetNamespace('MAPI').GetDefaultFolder(olFolderInbox);
//    if Assigned(IFolderInbox) then
//      try
//        FItems := TItems.Create(nil);
//        FItems.ConnectTo(IFolderInbox.Items);
//        FItems.OnItemAdd := DoItemAdd;
//      finally
//        IFolderInbox := nil;
//      end;
//  end;
end;

procedure TAddInModule.adxCOMAddInModuleCreate(Sender: TObject);
begin
  FWorker4OLMsg := nil;
//  FSharedData := SharedMemoryData.Create(SHARED_DATA_NAME, SharedMemoryAccessReadWrite);
//  FSMData := TGpSharedMemory.Create(gpSHARED_DATA_NAME, 10000, 300000000);
//  FSendMsgQueue := TOmniMessageQueue.Create(1000);
//  FOLMsgQueue := TOmniMessageQueue.Create(1000);
//  FWorker4STOMP := TWorker4STOMP.Create(FSendMsgQueue);
//  FWorker4OLMsg := TWorker4OLMsg.Create(FOLMsgQueue);
//  ShowMessage('OnCreate');
end;

procedure TAddInModule.adxCOMAddInModuleDestroy(Sender: TObject);
var
  i: integer;
begin
  if Assigned(FWorker4OLMsg) then
  begin
    FWorker4OLMsg.Terminate;
    FWorker4OLMsg.Stop;
    FOLMsgQueue.Free;
    FInboxStoreIdList.Free;
  end;

//  FSMData.Free;

//  ShowMessage('OnDestroy');

//  FWorker4STOMP.Terminate;
//  FWorker4STOMP.Stop;
//  FSendMsgQueue.Free;
end;

procedure TAddInModule.adxContextMenu1Controls0Controls0Click(Sender: TObject);
begin
  ShowMessage('Add To DPMS To-Do List');
end;

procedure TAddInModule.adxOutlookAppEvents1NewMail(Sender: TObject);
begin
//  ShowMessage('OnNewMail');
end;

procedure TAddInModule.adxOutlookAppEvents1NewMailEx(ASender: TObject;
  const EntryIDCollection: WideString);
begin
  SendMailInfoToNamedPipe(EntryIDCollection);
end;

procedure TAddInModule.adxOutlookAppEvents1Reminder(ASender: TObject;
  const Item: IDispatch);
begin
//  ShowMessage(DateTimeToStr(AppointmentItem(Item).Start));
end;

procedure TAddInModule.adxOutlookAppEvents1ReminderFire(ASender: TObject;
  const ReminderObject: IDispatch);
var
  LAppointmentItem: AppointmentItem;
begin
//  LAppointmentItem := Reminder(ReminderObject).Item as AppointmentItem;

//  if LAppointmentItem.Start >= now then
//  begin
//    Send_Message('[알림]', 'LAppointmentItem.Subject', '[일정]' + LAppointmentItem.Subject + ' => ' + FormatDateTime('hh시mm분', LAppointmentItem.Start),OLUSERID, OLUSERID, 'B');
//    ShowMessage(LAppointmentItem.Subject + ':' + DateTimeToStr(LAppointmentItem.Start));
//  end;
//    ShowMessage(LAppointmentItem.Subject + ':' + DateTimeToStr(LAppointmentItem.Start));
//    ShowMessage(Reminder(ReminderObject).Caption + ': ' + DateTimeToStr(Reminder(ReminderObject).NextReminderDate));
end;

procedure TAddInModule.AssignOLAttachmentToIdMsg(AOLMailItem: MailItem;
  out AIdMsg: TIdMessage);
var
  i: integer;
  LPath, LFileName: string;
begin
  LPath := 'c:\temp\';

//ShowMessage(IntToStr(AOLMailItem.Attachments.Count));
  for i := 1 to AOLMailItem.Attachments.Count do
  begin
//ShowMessage('AOLMailItem.Attachments.Count');
    LFileName := LPath + AOLMailItem.Attachments.Item(i).FileName;
    AOLMailItem.Attachments.Item(i).SaveAsFile(LFileName);
    TIdAttachmentFile.Create(AIdMsg.MessageParts, LFileName);
  end;
//ShowMessage('AssignOLAttachmentToIdMsg End');
end;

function TAddInModule.AssignOLMailItemToIdMessage(AOLMailItem: MailItem;
  out AIdMsg: TIdMessage): boolean;
begin
  Result := False;
  AIdMsg.From.Address := AOLMailItem.SenderEmailAddress;
//  ShowMessage(AOLMailItem.SenderEmailAddress);
  AIdMsg.Subject := AOLMailItem.Subject;
  AIdMsg.Body.Text := AOLMailItem.Body;
  ShowMessage(AOLMailItem.Subject + ':' + AOLMailItem.Body);// IntToStr(AOLMailItem.Attachments.Count));
  AssignOLRecipientToIdMsg(AOLMailItem, AIdMsg);
  AssignOLAttachmentToIdMsg(AOLMailItem, AIdMsg);
  Result := True;
end;

procedure TAddInModule.AssignOLRecipientToIdMsg(AOLMailItem: MailItem;
  out AIdMsg: TIdMessage);
var
  i: integer;
  LItem: TIdEMailAddressItem;
begin
  for i := 1 to AOLMailItem.Recipients.Count do
  begin
    case AOLMailItem.Recipients.Item(i).type_ of
      //olTo
      1: begin
        LItem := AIdMsg.Recipients.Add;
      end;
      //olCC
      2: begin
        LItem := AIdMsg.CCList.Add;
      end;
      //olBCC
      3: begin
        LItem := AIdMsg.BCCList.Add;
      end;
      else
        LItem := nil;
    end;

    if Assigned(LItem) then
    begin
      LItem.Address := AOLMailItem.Recipients.Item(i).Address;
    end;
  end;
end;

procedure TAddInModule.DoItemAdd(ASender: TObject; const Item: IDispatch);
begin

end;

procedure TAddInModule.GetInboxList;
var
  LNameSpace: _NameSpace;
  i,j,k: integer;
  LFolders: _Folders;
  LFolderName: string;
begin
  LNameSpace := OutlookApp.GetNamespace('MAPI') as _NameSpace;//.GetDefaultFolder();

//  ShowMessage(IntToStr(LNameSpace.Folders.Count));
  for j := 1 to LNameSpace.Folders.Count do
  begin
    LFolders := LNameSpace.Folders.Item(j).Folders;
    LFolderName := LNameSpace.Folders.Item(j).Name;

    for k := 1 to LFolders.Count do
    begin
      if LFolders.Item(k).Name = '받은 편지함' then
      begin
        FInboxStoreIdList.Add(LFolderName + '=' + LFolders.Item(k).StoreID);
//        ShowMessage(LFolders.Item(k).StoreID);
      end
      else
      if LFolders.Item(k).Name = 'Working' then
      begin
        g_WorkingFolder := LFolders.Item(k);
//        ShowMessage(g_WorkingFolder.Name + ' : ' + g_WorkingFolder.StoreID);
      end;
    end;
  end;
end;

procedure TAddInModule.Log(Amsg: string; AIsSaveLog: Boolean;
  AMsgLevel: TSynLogInfo);
var
  ILog: ISynLog;
begin
  if AIsSaveLog then
  begin
    ILog := TSQLLog.Enter;
    ILog.Log(AMsgLevel, DateTimeToStr(now) + ':: ' + Amsg);
  end;
end;

procedure TAddInModule.SendMailInfoToNamedPipe(AEntryIDList: WideString);
const
  GS_EMAIL = 'hyundai-gs.com';
var
  IFolderInbox: MAPIFolder;
  LNameSpace: _NameSpace;
  LMailItem: MailItem;
  LAccount: _Account;
  LStrArr: System.Types.TStringDynArray;
  LStoreID: string;
  LRec: TOLMsgFileRecord;
  LOmniValue: TOmniValue;
  i,j,k: integer;
begin
  LNameSpace := OutlookApp.GetNamespace('MAPI') as _NameSpace;
//  IFolderInbox := LNameSpace.Folders['jhpark@hyundai-gs.com'];
//  for i := 1 to LNameSpace.Session.Accounts.Count do
//  begin
//    LAccount := LNameSpace.Session.Accounts.Item(i);
//  ;// .GetDefaultFolder(olFolderInbox);
//    ShowMessage(LAccount.CurrentUser.Address);
//  end;
//    ShowMessage(LNameSpace.Session.CurrentUser.Address);

//  if not Assigned(IFolderInbox) then
//    exit;
//    ShowMessage(IFolderInbox.Session.CurrentUser.Address);

  LStrArr := SplitString(AEntryIDList, ',');

//  if IFolderInbox.Name = '받은 편지함' then

  begin
    Log('받은 편지함!', True);
    for i := Low(LStrArr) to High(LStrArr) do
    begin
      LMailItem := nil;

      for k := 0 to FInboxStoreIDList.Count - 1 do
      begin
        LStoreID := FInboxStoreIDList.ValueFromIndex[k];

        try
          LMailItem := LNameSpace.GetItemFromID(LStrArr[i],LStoreID) as MailItem;

          if Assigned(LMailItem) then
          begin
            LRec.FSender := LMailItem.SenderEmailAddress;
//            ShowMessage('>>> ' + LRec.FSender);

            for j := 1 to LMailItem.Recipients.Count do
              LRec.FReceiver := LRec.FReceiver + LMailItem.Recipients.Item(j).Address + ';';

            LRec.FSubject := LMailItem.Subject;
            LRec.FMailItem := LMailItem;
            LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(LRec);
//            ShowMessage(LRec.FReceiver + #13#10 + LRec.FSender + #13#10 + LRec.FSubject);
            if not FOLMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
              Log('Send queue is full!', True)
            else
              Log('Send queue is success!', True);

            Log('Receiver : ' + LRec.FReceiver, True);
    //        FConsumeEvent.Signal;
            Break;
          end;
        except
          continue;
        end;
      end;//for

//      ShowMessage(LStrArr[High(LStrArr)]);
    end;//for
  end;
//var
//  LRec: TOLMsgFileRecord;
//  LOmniValue: TOmniValue;
//begin
//  LRec.FSender := '';
//  LRec.FReceiver := '';
//  LRec.FSubject := '';
//  LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(LRec);
//
//  if not FSendMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
//    Log('Send queue is full!', True)
//  else
//    Log('Send queue is success!', True);
end;

procedure TAddInModule.Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser, AFlag: string);
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

{ TWorker4STOMP }

constructor TWorker4STOMP.Create(sendQueue: TOmniMessageQueue);
begin
  inherited Create;

  FreeOnTerminate := True;
  FSendMsgQueue := sendQueue;
  FStopEvent := TEvent.Create;
end;

destructor TWorker4STOMP.Destroy;
begin
  FreeAndNil(FStopEvent);

  inherited;
end;

procedure TWorker4STOMP.Execute;
var
  handles: array [0..1] of THandle;
  msg    : TOmniMessage;
  rec    : TOLMsgFile4STOMP;
  lClient: TStompClient;
begin
  handles[0] := FStopEvent.Handle;
  handles[1] := FSendMsgQueue.GetNewMessageEvent;
  lClient := TStompClient.Create;

  while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
  begin
    if terminated then
      break;

    while FSendMsgQueue.TryDequeue(msg) do
    begin
      rec := msg.MsgData.ToRecord<TOLMsgFile4STOMP>;
      lClient.SetUserName(rec.FUserId);
      lClient.SetPassword(rec.FPasswd);
      lClient.Connect(rec.FHost, 61613, '', TStompAcceptProtocol.Ver_1_1);
      try
        try
          lClient.Send(EMAIL_TOPIC_NAME, rec.FMsgFile);
        finally
          if lClient.Connected then
            lClient.Disconnect;
        end;
      except
      end;
    end;
  end;
end;

procedure TWorker4STOMP.Stop;
begin
  FStopEvent.SetEvent;
end;

{ TWorker4OLMsg }

constructor TWorker4OLMsg.Create(sendQueue: TOmniMessageQueue);
begin
  inherited Create;

  FreeOnTerminate := True;
  FOLMsgQueue := sendQueue;
  FStopEvent := TEvent.Create;
end;

destructor TWorker4OLMsg.Destroy;
begin
  FreeAndNil(FStopEvent);

  inherited;
end;

procedure TWorker4OLMsg.Execute;
var
  handles: array [0..1] of THandle;
  msg    : TOmniMessage;
  rec    : TOLMsgFileRecord;
  LMailItem : MailItem;
begin
  handles[0] := FStopEvent.Handle;
  handles[1] := FOLMsgQueue.GetNewMessageEvent;

  while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
  begin
    if terminated then
      break;

    while FOLMsgQueue.TryDequeue(msg) do
    begin
      rec := msg.MsgData.ToRecord<TOLMsgFileRecord>;

      if Pos(OLMAILADDR, rec.FReceiver) > 0 then
      begin
        LMailItem := rec.FMailItem.Move(g_WorkingFolder) as MailItem;
//        ShowMessage(rec.FMailItem.EntryID + ' ==> ' + g_WorkingFolder.StoreID);
//        ShowMessage(LMailItem.EntryID + ' ==> ' + g_WorkingFolder.StoreID);
      end;
    end;
  end;
end;

procedure TWorker4OLMsg.Stop;
begin
  FStopEvent.SetEvent;
end;

{ TMail2WSService }

procedure TMail2WSService.CallbackReleased(const callback: IInvokable;
  const interfaceName: RawUTF8);
begin
  if interfaceName='IMailCallback' then
    InterfaceArrayDelete(fConnected,callback);
end;

procedure TMail2WSService.Join(const pseudo: string;
  const callback: IMailCallback);
begin
  InterfaceArrayAdd(fConnected,callback);
end;

procedure TMail2WSService.ServerExecute(const command, msg: string);
var i: integer;
begin
  for i := high(fConnected) downto 0 do // downwards for InterfaceArrayDelete()
    try
      fConnected[i].ClientExecute(command,msg);
    except
      InterfaceArrayDelete(fConnected,i); // unsubscribe the callback on failure
    end;
end;

initialization
  TadxFactory.Create(ComServer, TCoCalContextAddIn, CLASS_CoCalContextAddIn, TAddInModule);

end.

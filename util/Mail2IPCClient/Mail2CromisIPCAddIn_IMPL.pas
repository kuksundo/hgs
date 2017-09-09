unit Mail2CromisIPCAddIn_IMPL;

interface

uses
  SysUtils, ComObj, ComServ, ActiveX, Variants, Outlook2010, Office2010, adxAddIn,
  System.Types, System.StrUtils, CalContextAddIn_TLB, System.Classes, Dialogs,
  Winapi.Windows, System.SyncObjs, adxHostAppEvents, adxolFormsManager, IPC.Events, CommonData, Messages,
  IdMessage, SynCommons, mORMot, GpSharedMemory, IPC.SharedMem,//, UnitSynLog, SynLog
  OtlCommon, OtlComm, OtlTaskControl, OtlContainerObserver, otlTask,
  LoggerPro.GlobalLogger,
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  mORMotHttpServer, mORMotWrappers, MailCallbackInterface, UnitClientInfoClass, AdvAlertWindow;

const
  OLUSERID = 'A379042';
  OLMYMAILADDR = 'jhpark@hyundai-gs.com';
  OLMYMAILADDR2 = 'junghyunpark@hyundai-gs.com';
  WM_RUN_TASK = WM_USER + 1;

type
  SharedMemoryData = SharedMemory<TGUIDFileName>;

  TCoCalContextAddIn = class(TadxAddin, ICoCalContextAddIn)
  end;

  TWorker4IPC = class(TThread)
  private
    FIPCClientList: TCommContextList;
    FOLMsg2IPCMQ: TOmniMessageQueue;
    FStopEvent    : TEvent;
    FTaskPool: TTaskPool;
  protected
    procedure Execute; override;
    procedure OnMessageComplete(const Msg: ITaskMessage);
    procedure OnAsynchronousIPCTask(const ATask: ITask);
  public
    constructor Create(sendQueue: TOmniMessageQueue; ClientList: TCommContextList);
    destructor Destroy; override;
    procedure Stop;
  end;

  TWorker4OLMsg = class(TThread)
  private
    FOLMsgQueue: TOmniMessageQueue;
    FOLMsg2IPCMQ: TOmniMessageQueue;
    FStopEvent    : TEvent;
    FInboxStoreIdList: TStringList;
    FNameSpace: _NameSpace;
  protected
    procedure Execute; override;
  public
    constructor Create(sendQueue, IPCQueue: TOmniMessageQueue;
      AInboxStoreIdList: TStringList; ANameSpace: _NameSpace);
    destructor Destroy; override;
    procedure Stop;
  end;

//  TOLMsgFileRecords = array of TOLMsgFileRecord;
//  POLMsgFileRecords = ^TOLMsgFileRecords;

  TServiceOL4WS = class(TInterfacedObject, IOLMailService)
  private
  protected
    fConnected: array of IOLMailCallback;
    FClientInfoList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Join(const pseudo: string; const callback: IOLMailCallback);
    procedure CallbackReleased(const callback: IInvokable; const interfaceName: RawUTF8);
    function ServerExecute(const Acommand: string): RawUTF8;
    function GetOLEmailInfo(ACommand: string): RawUTF8;
  end;

  TAddInModule = class(TadxCOMAddInModule)
    adxContextMenu1: TadxContextMenu;
    adxOutlookAppEvents1: TadxOutlookAppEvents;
    AdvAlertWindow1: TAdvAlertWindow;
    adxContextMenu2: TadxContextMenu;
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
    procedure adxContextMenu1Controls0Controls1Click(Sender: TObject);
    procedure adxContextMenu1Controls0Controls2Click(Sender: TObject);
    procedure adxContextMenu1Controls0Controls3Click(Sender: TObject);
    procedure adxContextMenu1Controls1Controls0Click(Sender: TObject);
    procedure adxContextMenu1BeforeAddControls(Sender: TObject);
    procedure adxContextMenu1Controls1Controls2Click(Sender: TObject);
    procedure adxContextMenu1Controls1Controls3Click(Sender: TObject);
    procedure adxContextMenu1Controls0Controls4Click(Sender: TObject);
    procedure adxContextMenu2Controls0Click(Sender: TObject);
    procedure adxContextMenu2Controls0Controls2Click(Sender: TObject);
  private
    FConsumeEvent, FProduceEvent: Event;
    FSMData: TGpSharedMemory;
    FSharedData: SharedMemoryData;
    FWorker4IPC: TWorker4IPC;
    FWorker4OLMsg: TWorker4OLMsg;
    FOLMsgQueue,
    FOLMsg2IPCMQ: TOmniMessageQueue;
    FEmailDisplayMQ: TOmniMessageQueue;
    FSEmailDisplaytopEvent    : TEvent;
    FInboxStoreIdList,
    FProductTypeStoreIdList: TStringList;
    FIPCServer,
    FIPCServer2: TIPCServer;
    FIPCClientList: TCommContextList;
    FNameSpace: _NameSpace;
    FEntryIDList: TStringList;
    FAutoSend4OLMsg2IPCMQ: Boolean;
    FCommModes: TCommModes;

    procedure OnClientConnect(const Context: ICommContext);
    procedure OnClientDisconnect(const Context: ICommContext);
    procedure OnServerError(const Context: ICommContext; const Error: TServerError);
    procedure OnExecuteRequest(const Context: ICommContext; const Request, Response: IMessageData);
    procedure WMRunTask(var Msg: TMessage); message WM_RUN_TASK;
//    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure OnClientConnect2(const Context: ICommContext);
    procedure OnClientDisconnect2(const Context: ICommContext);
    procedure OnServerError2(const Context: ICommContext; const Error: TServerError);
    procedure OnExecuteRequest2(const Context: ICommContext; const Request, Response: IMessageData);

    //Websocket-b
    procedure CreateHttpServer4WS(APort, ATransmissionKey: string;
      aClient: TInterfacedClass; const aInterfaces: array of TGUID);
    procedure DestroyHttpServer;
    function SessionCreate(Sender: TSQLRestServer; Session: TAuthSession;
                  Ctxt: TSQLRestServerURIContext): boolean;
    function SessionClosed(Sender: TSQLRestServer; Session: TAuthSession;
                  Ctxt: TSQLRestServerURIContext): boolean;
    //Websocket-e
  protected
    //Websocket-b
    FModel: TSQLModel;
    FHTTPServer: TSQLHttpServer;
    FRestServer: TSQLRestServer;
    FServiceFactoryServer: TServiceFactoryServer;

    FIpAddr: string;
    FURL: string; //Server에서 Client에 Config Change Notify 하기 위한 Call Back URL
    FIsServerActive: Boolean;
    FPortName: string;
    //Websocket-e

    procedure ShowStoreIdFromSelected;
    procedure GetInboxList;
    procedure DoItemAdd(ASender: TObject; const Item: IDispatch);
    procedure SendEntryID2IPCFromList;
  public
    //Aflag = 'A'; //쪽지
    //      = 'B'; //SMS
    //AUser = 사번
    procedure Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser, AFlag: string);
    procedure SendMailToSharedMM(AEntryIDList: WideString);
    procedure SendMailToMsgFile(AEntryIDList: WideString);
    procedure MoveMail2WorkingFolder(AEntryIDList: WideString);
    procedure AssignMailItem2Rec(AMail: MailItem; out ARec: TOLMsgFileRecord);
    procedure MoveMail2Folder(var AEntryIdRecord: TEntryIdRecord);
    function GetFolderFromPath(APath:string): MAPIFOLDER;
    function IsExistFolder(var AFolder: MAPIFolder; AFolderName: string): Boolean;

    function AssignOLMailItemToIdMessage(AOLMailItem: MailItem;
      out AIdMsg: TIdMessage): boolean;
    procedure AssignOLRecipientToIdMsg(AOLMailItem: MailItem;
      out AIdMsg: TIdMessage);
    procedure AssignOLAttachmentToIdMsg(AOLMailItem: MailItem;
      out AIdMsg: TIdMessage);
    procedure ShowMailContents(AEntryId, AStoreId: string);
    procedure ReplyMail(AEntryIdRecord: TEntryIdRecord);
    procedure CreateMail(AEntryIdRecord: TEntryIdRecord);
    procedure CreateAppointment(ATodoItem: variant);

    procedure AsyncEmailDisplay;
    procedure AsyncSendEntryId2IPC(AIsDrag: Boolean=True);
    function GetEmail2StrList: TStringList;
    function GetResponse4MoveFolder2StrList(AEntryIdRecord: TEntryIdRecord): TStringList;

    procedure ProcessCommandFromClient(ACommand: string);
    function ServerExecuteFromClient(ACommand: string): RawUTF8;
  end;

    procedure Log4OL(Amsg: string; AIsSaveLog: Boolean = False;
      AMsgLevel: TSynLogInfo = sllInfo);

var
  g_WorkingFolder: MAPIFolder;
  g_PrevStoreId: string;
  MyAddInModule : TAddInModule;

implementation

uses HHI_WebService, UnitHHIMessage, CommonUtil_Unit, IdEMailAddress,
  IdAttachmentFile, StompClient, StompTypes, OtlParallel;

{$R *.dfm}

procedure Log4OL(Amsg: string; AIsSaveLog: Boolean;
  AMsgLevel: TSynLogInfo);
begin
  if AIsSaveLog then
  begin
    Log.Debug(Amsg, '');
//    DoLog4OL(AMsg, True);
  end;
end;

procedure TAddInModule.adxCOMAddInModuleAddInInitialize(Sender: TObject);
//var
//  IFolderInbox: MAPIFolder;
begin
//  InitSynLog;
  Log4OL('adxCOMAddInModuleAddInInitialize', True);
  FOLMsgQueue := TOmniMessageQueue.Create(1000);
  FOLMsg2IPCMQ := TOmniMessageQueue.Create(1000);
  FEmailDisplayMQ := TOmniMessageQueue.Create(1000);
  FSEmailDisplaytopEvent := TEvent.Create;
  FIPCClientList := TCommContextList.Create;
  FInboxStoreIdList := TStringList.Create;
  FProductTypeStoreIdList := TStringList.Create;
  GetInboxList;
  FWorker4OLMsg := TWorker4OLMsg.Create(FOLMsgQueue, FOLMsg2IPCMQ,
    FInboxStoreIdList, FNameSpace);
  FWorker4IPC := TWorker4IPC.Create(FOLMsg2IPCMQ,FIPCClientList);
  FConsumeEvent := Event.Create(CONSUME_EVENT_NAME);
  FProduceEvent := Event.Create(PRODUCE_EVENT_NAME);

  FIPCServer := TIPCServer.Create;
  FIPCServer.OnServerError := OnServerError;
  FIPCServer.OnClientConnect := OnClientConnect;
  FIPCServer.OnExecuteRequest := OnExecuteRequest;
  FIPCServer.OnClientDisconnect := OnClientDisconnect;

  FIPCServer.ServerName := IPC_SERVER_NAME_4_OUTLOOK;
  FIPCServer.Start;

  FIPCServer2 := TIPCServer.Create;
  FIPCServer2.OnServerError := OnServerError2;
  FIPCServer2.OnClientConnect := OnClientConnect2;
  FIPCServer2.OnExecuteRequest := OnExecuteRequest2;
  FIPCServer2.OnClientDisconnect := OnClientDisconnect2;

  FIPCServer2.ServerName := IPC_SERVER_NAME_4_OUTLOOK2;
  FIPCServer2.Start;

  CreateHttpServer4WS(OL_PORT_NAME_4_WS, OL4WS_TRANSMISSION_KEY, TServiceOL4WS, [IOLMailService]);

  FEntryIDList := TStringList.Create;
  AsyncEmailDisplay;
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
  MyAddInModule := Self;
//  FSharedData := SharedMemoryData.Create(SHARED_DATA_NAME, SharedMemoryAccessReadWrite);
//  FSMData := TGpSharedMemory.Create(gpSHARED_DATA_NAME, 10000, 300000000);
//  FSendMsgQueue := TOmniMessageQueue.Create(1000);
//  FOLMsgQueue := TOmniMessageQueue.Create(1000);
//  FWorker4IPC := TWorker4IPC.Create(FSendMsgQueue);
//  FWorker4OLMsg := TWorker4OLMsg.Create(FOLMsgQueue);
//  ShowMessage('OnCreate');
end;

procedure TAddInModule.adxCOMAddInModuleDestroy(Sender: TObject);
var
  i: integer;
begin
  DestroyHttpServer;

  if FAutoSend4OLMsg2IPCMQ then
    SendEntryID2IPCFromList;

  if Assigned(FWorker4OLMsg) then
  begin
    FSEmailDisplaytopEvent.SetEvent;
    FIPCServer.Stop;
    FIPCServer2.Stop;
    FWorker4OLMsg.Terminate;
    FWorker4OLMsg.Stop;
    FWorker4IPC.Terminate;
    FWorker4IPC.Stop;
    FOLMsgQueue.Free;
    FOLMsg2IPCMQ.Free;
    FEmailDisplayMQ.Free;
    FInboxStoreIdList.Free;
    FProductTypeStoreIdList.Free;
    FIPCClientList.Free;
    FreeAndNil(FIPCServer);
    FreeAndNil(FIPCServer2);
    FreeAndNil(FSEmailDisplaytopEvent);
  end;

//  FSMData.Free;

//  ShowMessage('OnDestroy');

//  FWorker4IPC.Terminate;
//  FWorker4IPC.Stop;
//  FSendMsgQueue.Free;
end;

procedure TAddInModule.adxContextMenu1BeforeAddControls(Sender: TObject);
begin
  TadxCommandBarPopup(adxContextMenu1.Controls[1]).Controls[1].Enabled := not FAutoSend4OLMsg2IPCMQ;
  TadxCommandBarPopup(adxContextMenu1.Controls[1]).Controls[2].Enabled := FAutoSend4OLMsg2IPCMQ;
end;

procedure TAddInModule.adxContextMenu1Controls0Controls0Click(Sender: TObject);
begin
  ShowMessage('Add To DPMS To-Do List');
end;

procedure TAddInModule.adxContextMenu1Controls0Controls1Click(Sender: TObject);
begin
  ShowMessage(IntToStr(FIPCClientList.Count));
end;

procedure TAddInModule.adxContextMenu1Controls0Controls2Click(Sender: TObject);
begin
  ShowMessage(IntToStr(FEntryIDList.Count));
end;

procedure TAddInModule.adxContextMenu1Controls0Controls3Click(Sender: TObject);
var
  LMailItem: MailItem;
  i: integer;
  LOmniValue: TOmniValue;
//  LRec: TOLMsgFileRecord;
  LEntryRec: TEntryIdRecord;
  LText: string;
  LFolder: MAPIFolder;
begin
  i := OutlookApp.ActiveExplorer.Selection.Count;

  if i > 1 then
  begin
    ShowMessage('이 기능을 이용하기 위해서는 메일을 1개만 선택 하세요');
    exit;
  end;

  LMailItem := OutlookApp.ActiveExplorer.Selection.Item(i) as MailItem;
  LFolder := OutlookApp.ActiveExplorer.CurrentFolder as MAPIFolder;

  if Assigned(LMailItem) then
  begin
//    if g_PrevStoreId = LMailItem.EntryID then
//      ShowMessage('Same Entry Id');

    ShowMessage(LMailItem.EntryID + #13#10 + LFolder.StoreID);
//    g_PrevStoreId := LMailItem.EntryID;
  end;
end;

procedure TAddInModule.adxContextMenu1Controls0Controls4Click(Sender: TObject);
var
  LMailItem: MailItem;
  i: integer;
  LFolder: MAPIFolder;
  LEntryRec: TEntryIdRecord;
  LOmniValue: TOmniValue;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    begin
      i := OutlookApp.ActiveExplorer.Selection.Count;

      if i > 1 then
      begin
        ShowMessage('이 기능을 이용하기 위해서는 메일을 1개만 선택 하세요');
        exit;
      end;

      LMailItem := OutlookApp.ActiveExplorer.Selection.Item(i) as MailItem;
      LFolder := OutlookApp.ActiveExplorer.CurrentFolder as MAPIFolder;

      LEntryRec.FEntryId := LMailItem.EntryID;
      LEntryRec.FStoreId := LFolder.StoreID;

      LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(LEntryRec);
      FEmailDisplayMQ.Enqueue(TOmniMessage.Create(1, LOmniValue));
//      ShowMailContents(LMailItem.EntryID, LFolder.StoreID);
//      task.Invoke(
//        procedure
//        begin
////          ShowMessage(LMailItem.EntryID);
////          ShowMailContents(LMailItem.EntryID, LFolder.StoreID);
//        end
//      );
    end );
//  LEntryRec.FEntryId := LMailItem.EntryID;
//  LEntryRec.FStoreId := LFolder.StoreID;
//  LEntryRec.FIgnoreReceiver2pjh := True;
//  LEntryRec.FIgnoreEmailMove2WorkFolder := True;
//  LEntryRec.FIsShowMailContents := True;
//  LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(LEntryRec);
//
//  if not FOLMsgQueue.Enqueue(TOmniMessage.Create(3, LOmniValue)) then
//    Log4OL('Send queue is full!', True)
//  else
//  begin
//    Log4OL('Send queue is success!', True);
//  end;
end;

procedure TAddInModule.adxContextMenu1Controls1Controls0Click(Sender: TObject);
var
  LMailItem: MailItem;
  i: integer;
  LOmniValue: TOmniValue;
//  LRec: TOLMsgFileRecord;
  LEntryRec: TEntryIdRecord;
  LText: string;
  LFolder: MAPIFolder;
begin
  for i := 1 to OutlookApp.ActiveExplorer.Selection.Count do
  begin
    LMailItem := OutlookApp.ActiveExplorer.Selection.Item(i) as MailItem;
    LFolder := OutlookApp.ActiveExplorer.CurrentFolder as MAPIFolder;
//    AssignMailItem2Rec(LMailItem, LRec);
//    LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(LRec);
//    LOmniValue := LMailItem.EntryID;
    if Assigned(LMailItem) then
    begin
      LEntryRec.FEntryId := LMailItem.EntryID;
      LEntryRec.FStoreId := LFolder.StoreID;
      LEntryRec.FIgnoreReceiver2pjh := True;
      LEntryRec.FIgnoreEmailMove2WorkFolder := True;
      LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(LEntryRec);

      if not FOLMsgQueue.Enqueue(TOmniMessage.Create(3, LOmniValue)) then
        Log4OL('Send queue is full!', True)
      else
      begin
        LText := FEntryIDList.Text;
        StringReplace(LText, LMailItem.EntryID, '', [rfReplaceAll]);
        FEntryIDList.Text := LText;
        Log4OL('Send queue is success!', True);
      end;
    end;
  end;//for
end;

procedure TAddInModule.adxContextMenu1Controls1Controls2Click(Sender: TObject);
begin
  FAutoSend4OLMsg2IPCMQ := True;
end;

procedure TAddInModule.adxContextMenu1Controls1Controls3Click(Sender: TObject);
begin
  FAutoSend4OLMsg2IPCMQ := False;
end;

procedure TAddInModule.adxContextMenu2Controls0Click(Sender: TObject);
var
  LOmniValue: TOmniValue;
  LEntryRec: TEntryIdRecord;
  LFolder: MAPIFolder;
  LText: string;
begin
  LFolder := OutlookApp.ActiveExplorer.CurrentFolder as MAPIFolder;

  LEntryRec.FEntryId := LFolder.FolderPath + ';' + LFolder.Name;
  LEntryRec.FStoreId := LFolder.StoreID;
  LEntryRec.FIgnoreReceiver2pjh := True;
  LEntryRec.FIgnoreEmailMove2WorkFolder := True;
  LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(LEntryRec);

  if not FOLMsgQueue.Enqueue(TOmniMessage.Create(4, LOmniValue)) then
    Log4OL('Send queue is full!', True)
  else
  begin
    LText := FEntryIDList.Text;
//    StringReplace(LText, LMailItem.EntryID, '', [rfReplaceAll]);
    FEntryIDList.Text := LText;
    Log4OL('Send queue is success!', True);
  end;
end;

procedure TAddInModule.adxContextMenu2Controls0Controls2Click(Sender: TObject);
begin
  ShowStoreIdFromSelected;
end;

procedure TAddInModule.adxOutlookAppEvents1NewMail(Sender: TObject);
begin
//  ShowMessage('OnNewMail');
end;

procedure TAddInModule.adxOutlookAppEvents1NewMailEx(ASender: TObject;
  const EntryIDCollection: WideString);
var
  LOmniValue: TOmniValue;
  LEntryRec: TEntryIdRecord;
begin
//  SendMailToSharedMM(EntryIDCollection);
//  SendMailToMsgFile(EntryIDCollection);
//  MoveMail2WorkingFolder(EntryIDCollection);
  if not FAutoSend4OLMsg2IPCMQ then
  begin
    FEntryIDList.Add(EntryIDCollection);
    exit;
  end;

  if FIPCClientList.Count > 0 then
  begin
    LEntryRec.FEntryId := EntryIDCollection;
    LEntryRec.FStoreId := '';
    LEntryRec.FIgnoreReceiver2pjh := False;
    LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(LEntryRec);

    if not FOLMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
      Log4OL('Send queue is full!', True)
    else
      Log4OL('Send queue is success!', True);
  end
  else
  begin
    FEntryIDList.Add(EntryIDCollection);
  end;
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

procedure TAddInModule.AssignMailItem2Rec(AMail: MailItem; out ARec: TOLMsgFileRecord);
var
  i: integer;
begin
  ARec.FSender := AMail.SenderEmailAddress;

  for i := 1 to AMail.Recipients.Count do
    if AMail.Recipients.Item(i).type_ = OlTo then
      ARec.FReceiver := ARec.FReceiver + AMail.Recipients.Item(i).Address + ';'
    else if AMail.Recipients.Item(i).type_ = olCC then
      ARec.FCarbonCopy := ARec.FCarbonCopy + AMail.Recipients.Item(i).Address + ';'
    else if AMail.Recipients.Item(i).type_ = olBCC then
      ARec.FBlindCC := ARec.FBlindCC + AMail.Recipients.Item(i).Address + ';';

  ARec.FSubject := AMail.Subject;
  ARec.FMailItem := AMail;
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

procedure TAddInModule.AsyncEmailDisplay;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      i: integer;
      handles: array [0..1] of THandle;
      msg    : TOmniMessage;
      rec    : TEntryIdRecord;
      LID: TID;
    begin
      handles[0] := FSEmailDisplaytopEvent.Handle;
      handles[1] := FEmailDisplayMQ.GetNewMessageEvent;

      while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
      begin
        while FEmailDisplayMQ.TryDequeue(msg) do
        begin
          rec := msg.MsgData.ToRecord<TEntryIdRecord>;
          if msg.MsgID = 1 then //Request Mail View
          begin
            task.Invoke(
              procedure
              begin
                if (rec.FEntryID <> '') and (rec.FStoreID <> '') then
                  ShowMailContents(rec.FEntryID, rec.FStoreID);
              end
            );
          end
          else
          if msg.MsgID = 2 then //Request Reply Mail
          begin
            task.Invoke(
              procedure
              begin
                if (rec.FEntryID <> '') and (rec.FStoreID <> '') then
                  ReplyMail(rec);
              end
            );
          end
          else
          if msg.MsgID = 3 then //Request Create Mail
          begin
            task.Invoke(
              procedure
              begin
                if (rec.FTo <> '') and (rec.FSubject <> '') then
                  CreateMail(rec);
              end
            );
          end;
        end;
      end;
    end
  );
end;

procedure TAddInModule.AsyncSendEntryId2IPC(AIsDrag: Boolean);
var
  LMailItem: MailItem;
  LFolder: MAPIFolder;
  LRec: TOLMsgFileRecord;
  LOmniValue: TOmniValue;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      i: integer;
    begin
      i := OutlookApp.ActiveExplorer.Selection.Count;

      if (i > 1) and (AIsDrag) then
      begin
        ShowMessage('DragDrop 기능을 이용하기 위해서는 메일을 1개만 선택 하세요');
        exit;
      end;

      LFolder := OutlookApp.ActiveExplorer.CurrentFolder as MAPIFolder;

//      for i := 1 to OutlookApp.ActiveExplorer.Selection.Count do
//      begin
        LMailItem := OutlookApp.ActiveExplorer.Selection.Item(i) as MailItem;

        LRec.FEntryId := LMailItem.EntryID;
        LRec.FStoreId := LFolder.StoreID;
        LRec.FSender := LMailItem.SenderEmailAddress;
        LRec.FReceiveDate := LMailItem.ReceivedTime;
        LRec.FSubject := LMailItem.Subject;
        LRec.FMailItem := LMailItem;

        LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(LRec);
        FOLMsg2IPCMQ.Enqueue(TOmniMessage.Create(2, LOmniValue));
//      end;
    end );
end;

procedure TAddInModule.CreateAppointment(ATodoItem: variant);
var
  LAppointment: AppointmentItem;
  LStr: string;
  LTimeLog: TTimeLog;
begin
  LAppointment := OutlookApp.CreateItem(olAppointmentItem) as AppointmentItem;

  if Assigned(LAppointment) then
  begin
//    ShowMessage('ATodoItem.CreationDate=');
    LTimeLog := ATodoItem.Start;
    LAppointment.Start := TimeLogToDateTime(LTimeLog);
    LTimeLog := ATodoItem.End_;
    LAppointment.End_ := TimeLogToDateTime(LTimeLog);
//    LAppointment.Location;
    LAppointment.Body := ATodoItem.Body;
//    LAppointment.AllDayEvent := ATodoItem.Subject;
    LAppointment.Subject := ATodoItem.Subject;
    LAppointment.Save;
//    LAppointment.Display(True);
  end;
end;

procedure TAddInModule.CreateHttpServer4WS(APort, ATransmissionKey: string;
  aClient: TInterfacedClass; const aInterfaces: array of TGUID);
begin
  if not Assigned(FRestServer) then
  begin
    // initialize a TObjectList-based database engine
    FRestServer := TSQLRestServerFullMemory.CreateWithOwnModel([]);
    // register our Interface service on the server side
    FRestServer.CreateMissingTables;
    FServiceFactoryServer := FRestServer.ServiceDefine(aClient, aInterfaces , sicShared);
    FServiceFactoryServer.SetOptions([], [optExecLockedPerInterface]). // thread-safe fConnected[]
      ByPassAuthentication := true;

//    FRestMode := rmWebSocket;

//    FRestServer.OnSessionCreate := SessionCreate;
//    FRestServer.OnSessionClosed := SessionClosed;
  end;

  if not Assigned(FHTTPServer) then
  begin
    // launch the HTTP server
    FPortName := APort;
    FHTTPServer := TSQLHttpServer.Create(APort, [FRestServer], '+' , useBidirSocket);
    FHTTPServer.WebSocketsEnable(FRestServer, ATransmissionKey);
    FIsServerActive := True;
  end;

  FCommModes := FCommModes + [cmWebSocket];
end;

procedure TAddInModule.CreateMail(AEntryIdRecord: TEntryIdRecord);
var
  LMailItem: MailItem;
  LStr: string;
begin
  LMailItem := OutlookApp.CreateItem(olMailItem) as MailItem;

  if Assigned(LMailItem) then
  begin
    LMailItem.To_ := AEntryIdRecord.FTo;
    LMailItem.Subject := AEntryIdRecord.FSubject;
//    ShowMessage(Utf8ToString(Base64ToBin(StringToUtf8(AEntryIdRecord.FHTMLBody))));
    LStr := Utf8ToString(Base64ToBin(StringToUtf8(AEntryIdRecord.FHTMLBody)));
    LMailItem.HTMLBody := LStr + LMailItem.HTMLBody;
    LMailItem.Display(False);
  end;
end;

procedure TAddInModule.DestroyHttpServer;
begin
  if Assigned(FHTTPServer) then
    FreeAndNil(FHTTPServer);

  if Assigned(FRestServer) then
  begin
    FRestServer := nil
  end;

  if Assigned(FModel) then
    FreeAndNil(FModel);
end;

procedure TAddInModule.DoItemAdd(ASender: TObject; const Item: IDispatch);
begin

end;

function TAddInModule.IsExistFolder(var AFolder: MAPIFolder; AFolderName: string): Boolean;
var
  i: integer;
begin
  Result := False;

  for i := 1 to AFolder.Folders.Count do
  begin
    if AFolder.Folders.Item(i).Name = AFoldername then
    begin
      AFolder := AFolder.Folders.Item(i);
      Result := True;
      break;
    end;
  end;
end;

function TAddInModule.GetEmail2StrList: TStringList;
var
  LMailItem: MailItem;
  i,j: integer;
  LFolder: MAPIFolder;
  LReceiver, LCC, LBCC: string;
  Docs: TVariantDynArray;
  DocsDA: TDynArray;
  LCount: integer;
begin
  Result := TStringList.Create;

  LCount := OutlookApp.ActiveExplorer.Selection.Count;

  if LCount = 0 then
  begin
    ShowMessage('DragDrop 기능을 이용하기 위해서는 메일을 1개 이상 선택 하세요');
    exit;
  end;

  DocsDA.Init(TypeInfo(TVariantDynArray), Docs, @LCount);
  LCount := OutlookApp.ActiveExplorer.Selection.Count;
  SetLength(Docs,LCount);

  Result.Add('ServerName='+IPC_SERVER_NAME_4_INQMANAGE);
  Result.Add('Command='+CMD_SEND_MAIL_ENTRYID2);

  for i := 1 to OutlookApp.ActiveExplorer.Selection.Count do
  begin
    LMailItem := OutlookApp.ActiveExplorer.Selection.Item(i) as MailItem;
    LFolder := OutlookApp.ActiveExplorer.CurrentFolder as MAPIFolder;

    for j := 1 to LMailItem.Recipients.Count do
      if LMailItem.Recipients.Item(j).type_ = OlTo then
        LReceiver := LReceiver + LMailItem.Recipients.Item(j).Address + ';'
      else if LMailItem.Recipients.Item(j).type_ = olCC then
        LCC := LCC + LMailItem.Recipients.Item(j).Address + ';'
      else if LMailItem.Recipients.Item(j).type_ = olBCC then
        LBCC := LBCC + LMailItem.Recipients.Item(j).Address + ';';

    TDocVariant.New(Docs[i-1]);

    Docs[i-1].EntryId := LMailItem.EntryID;
    Docs[i-1].StoreId := LFolder.StoreID;
    Docs[i-1].Sender := LMailItem.SenderEmailAddress;
    Docs[i-1].Receiver := LReceiver;
    Docs[i-1].RecvDate := DateTimeToStr(LMailItem.ReceivedTime);
    Docs[i-1].CC := LCC;
    Docs[i-1].BCC := LBCC;
    Docs[i-1].Subject := LMailItem.Subject;
  end;

  LReceiver := Utf8ToString(DocsDA.SaveToJson);
//  ShowMessage(LReceiver);
  Result.Add('MailInfos='+LReceiver);
end;

function TAddInModule.GetFolderFromPath(APath: string): MAPIFOLDER;
var
  LStrArr: System.Types.TStringDynArray;
  LPath: string;
  i: integer;
  LFoundFolder : MAPIFOLDER;
  LSubFolders: _Folders;
begin
  LPath := StringReplace(APath, '\\', '', [rfReplaceAll]);
  LStrArr := SplitString(LPath, '\');

  LFoundFolder := OutlookApp.Session.Folders.Item(LStrArr[0]) as MAPIFOLDER;

  for i := 1 to High(LStrArr) do
  begin
    LSubFolders := LFoundFolder.Folders;

//    LIsFolderFound := Assigned(LSubFolders);
//
//    if LIsFolderFound then
    LFoundFolder := LSubFolders.Item(LStrArr[i]) as MAPIFOLDER
//    else
//      break;
  end;

//  if LIsFolderFound then
//    if Assigned(LFoundFolder) then
//      Showmessage('LFoundFolder');

    Result := LFoundFolder;
end;

procedure TAddInModule.GetInboxList;
var
  i,j,k: integer;
  LFolders: _Folders;
  LFolderName: string;
begin
  FNameSpace := OutlookApp.GetNamespace('MAPI') as _NameSpace;//.GetDefaultFolder();

//  ShowMessage(IntToStr(LNameSpace.Folders.Count));
  for j := 1 to FNameSpace.Folders.Count do
  begin
    LFolders := FNameSpace.Folders.Item(j).Folders;
    LFolderName := FNameSpace.Folders.Item(j).Name;

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

function TAddInModule.GetResponse4MoveFolder2StrList(AEntryIdRecord: TEntryIdRecord): TStringList;
begin
  Result := TStringList.Create;

  Result.Add('ServerName='+IPC_SERVER_NAME_4_INQMANAGE);
  Result.Add('Command='+CMD_RESPONDE_MOVE_FOLDER_MAIL);
  Result.Add('NewEntryId='+AEntryIdRecord.FNewEntryId);
  Result.Add('MovedStoreId='+AEntryIdRecord.FStoreId4Move);
end;

procedure TAddInModule.OnClientConnect(const Context: ICommContext);
begin
  FIPCClientList.AddContext(Context);

  if FAutoSend4OLMsg2IPCMQ then
    SendEntryID2IPCFromList;
end;

procedure TAddInModule.OnClientConnect2(const Context: ICommContext);
begin

end;

procedure TAddInModule.OnClientDisconnect(const Context: ICommContext);
var
  LCommContext: ICommContext;
begin
  LCommContext := FIPCClientList.GetByID(Context.ID);

  if Assigned(LCommContext) then
  begin
    FIPCClientList.RemoveContext(LCommContext);
  end;
end;

procedure TAddInModule.OnClientDisconnect2(const Context: ICommContext);
begin

end;

procedure TAddInModule.OnExecuteRequest(const Context: ICommContext;
  const Request, Response: IMessageData);
var
  LEntryId, LStoreId: string;
  rec    : TEntryIdRecord;
  LOmniValue: TOmniValue;
  LMailItem: MailItem;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      Command: AnsiString;
      LStrList,
      LStrList2: TStringList;
      LMailItem: MailItem;
    begin
      LStrList := TStringList.Create;
      try
        LStrList.Text := Request.Data.ReadUTF8String(CMD_LIST);
        Command := LStrList.Values['Command'];

        if Command = CMD_REQ_MAIL_VIEW then
        begin
          LEntryId := LStrList.Values['EntryId'];
          LStoreId := LStrList.Values['StoreId'];
          rec.FEntryId := LEntryId;
          rec.FStoreId := LStoreId;

          LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(rec);
          FEmailDisplayMQ.Enqueue(TOmniMessage.Create(1, LOmniValue));
        end
        else
        if Command = CMD_REQ_REPLY_MAIL then
        begin
          rec.FEntryId := LStrList.Values['EntryId'];;
          rec.FStoreId := LStrList.Values['StoreId'];;
          rec.FHTMLBody := LStrList.Values['HTMLBody'];

          LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(rec);
          FEmailDisplayMQ.Enqueue(TOmniMessage.Create(2, LOmniValue));
        end
        else
        if Command = CMD_REQ_CREATE_MAIL then
        begin
          rec.FEntryId := LStrList.Values['EntryId'];;
          rec.FStoreId := LStrList.Values['StoreId'];;
          rec.FSubject := LStrList.Values['Subject'];
          rec.FTo := LStrList.Values['To'];
          rec.FHTMLBody := LStrList.Values['HTMLBody'];

          LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(rec);
          FEmailDisplayMQ.Enqueue(TOmniMessage.Create(3, LOmniValue));
        end
        else
        if Command = CMD_REQ_MAILINFO_SEND then
        begin
          AsyncSendEntryId2IPC;
//          ShowMessage(CMD_REQ_MAILINFO_SEND);
        end;
      finally
        LStrList.Free;
      end;
    end
  );
end;

procedure TAddInModule.OnExecuteRequest2(const Context: ICommContext;
  const Request, Response: IMessageData);
var
  LEntryId, LStoreId: string;
  rec    : TEntryIdRecord;
  LOmniValue: TOmniValue;
  LMailItem: MailItem;
  Command: AnsiString;
  LStrList,
  LStrList2: TStringList;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Text := Request.Data.ReadUTF8String(CMD_LIST);
    Command := LStrList.Values['Command'];
    if Command = CMD_REQ_MAILINFO_SEND2 then
    begin
//          LStrList2.Clear;
      LStrList2 := GetEmail2StrList;
      try
        Response.ID := Format('Response nr. %d', [1]);
        Response.Data.WriteInteger('Integer', 5);
        Response.Data.WriteUTF8String(CMD_LIST,LStrList2.Text);
//        ShowMessage(LStrList2.Text);
      finally
        LStrList2.Free;
      end;
    end
    else
    if Command = CMD_REQ_MOVE_FOLDER_MAIL then
    begin
      LEntryId := LStrList.Values['EntryId'];
      LStoreId := LStrList.Values['StoreId'];
      rec.FEntryId := LEntryId;
      rec.FStoreId := LStoreId;
      rec.FStoreId4Move := LStrList.Values['MoveStoreId'];
      rec.FFolderPath := LStrList.Values['MoveStorePath'];
      rec.FHullNo := LStrList.Values['HullNo'];
      rec.FIsCreateHullNoFolder := StrToBool(LStrList.Values['IsCreateHullNoFolder']);

      MoveMail2Folder(rec);
      LStrList2 := GetResponse4MoveFolder2StrList(rec);
      try
        Response.ID := Format('Response nr. %d', [1]);
        Response.Data.WriteInteger('Integer', 5);
        Response.Data.WriteUTF8String(CMD_LIST,LStrList2.Text);
      finally
        LStrList2.Free;
      end;
    end;
  finally
    LStrList.Free;
  end;
end;

procedure TAddInModule.OnServerError(const Context: ICommContext;
  const Error: TServerError);
begin

end;

procedure TAddInModule.OnServerError2(const Context: ICommContext;
  const Error: TServerError);
begin

end;

procedure TAddInModule.ProcessCommandFromClient(ACommand: string);
var
  Command: string;
  LStrList,
  LStrList2: TStringList;
  LMailItem: MailItem;
  LEntryId, LStoreId: string;
  rec    : TEntryIdRecord;
  LOmniValue: TOmniValue;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Text := ACommand;
    Command := LStrList.Values['Command'];
    Log4OL(CMD_REQ_MAIL_VIEW, True);

    if Command = CMD_REQ_MAIL_VIEW then
    begin
      LEntryId := LStrList.Values['EntryId'];
      LStoreId := LStrList.Values['StoreId'];
      rec.FEntryId := LEntryId;
      rec.FStoreId := LStoreId;

      LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(rec);
      FEmailDisplayMQ.Enqueue(TOmniMessage.Create(1, LOmniValue));
    end
    else
    if Command = CMD_REQ_REPLY_MAIL then
    begin
      rec.FEntryId := LStrList.Values['EntryId'];;
      rec.FStoreId := LStrList.Values['StoreId'];;
      rec.FHTMLBody := LStrList.Values['HTMLBody'];

      LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(rec);
      FEmailDisplayMQ.Enqueue(TOmniMessage.Create(2, LOmniValue));
    end
    else
    if Command = CMD_REQ_CREATE_MAIL then
    begin
      rec.FEntryId := LStrList.Values['EntryId'];;
      rec.FStoreId := LStrList.Values['StoreId'];;
      rec.FSubject := LStrList.Values['Subject'];
      rec.FTo := LStrList.Values['To'];
      rec.FHTMLBody := LStrList.Values['HTMLBody'];

      LOmniValue := TOmniValue.FromRecord<TEntryIdRecord>(rec);
      FEmailDisplayMQ.Enqueue(TOmniMessage.Create(3, LOmniValue));
    end
    else
    if Command = CMD_REQ_MAILINFO_SEND then
    begin
      AsyncSendEntryId2IPC;
    end;
  finally
    LStrList.Free;
  end;
end;

procedure TAddInModule.ReplyMail(AEntryIdRecord: TEntryIdRecord);
var
  LMailItem,
  LReplyMail: MailItem;
  LStr: string;
begin
  LMailItem := FNameSpace.GetItemFromID(AEntryIdRecord.FEntryId,
    AEntryIdRecord.FStoreId) as MailItem;

  if Assigned(LMailItem) then
  begin
    LReplyMail := LMailItem.Reply;
//    LReplyMail.HTMLBody := AEntryIdRecord.FHTMLBody;
    LStr := Utf8ToString(Base64ToBin(StringToUtf8(AEntryIdRecord.FHTMLBody)));
//    ShowMessage(LStr);
    LReplyMail.HTMLBody := LStr + LReplyMail.HTMLBody;
    LReplyMail.Display(False);
  end;
end;

procedure TAddInModule.MoveMail2Folder(var AEntryIdRecord: TEntryIdRecord);
var
  LMailItem,
  LMailItem2 : MailItem;
  LFolder: MAPIFolder;
begin
  LMailItem := FNameSpace.GetItemFromID(AEntryIdRecord.FEntryId,
    AEntryIdRecord.FStoreId) as MailItem;

  if Assigned(LMailItem) then
  begin
    LFolder := GetFolderFromPath(AEntryIdRecord.FFolderPath);

    if AEntryIdRecord.FIsCreateHullNoFolder then
    begin
      if AEntryIdRecord.FHullNo <> '' then
      begin
        if not IsExistFolder(LFolder, AEntryIdRecord.FHullNo) then
          LFolder := LFolder.Folders.Add(AEntryIdRecord.FHullNo, olFolderInbox);
      end;
    end;

    LMailItem2 := LMailItem.Move(LFolder) as MailItem;
    AEntryIdRecord.FNewEntryId := LMailItem2.EntryID;
  end;
end;

procedure TAddInModule.MoveMail2WorkingFolder(AEntryIDList: WideString);
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
    Log4OL('받은 편지함!', True);
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
            AssignMailItem2Rec(LMailItem, LRec);
            LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(LRec);
//            ShowMessage(LRec.FReceiver + #13#10 + LRec.FSender + #13#10 + LRec.FSubject);
            if not FOLMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
              Log4OL('Send queue is full!', True)
            else
              Log4OL('Send queue is success!', True);

            Log4OL('Receiver : ' + LRec.FReceiver, True);
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
//    Log4OL('Send queue is full!', True)
//  else
//    Log4OL('Send queue is success!', True);
end;

procedure TAddInModule.SendEntryID2IPCFromList;
var
  LOmniValue: TOmniValue;
  i: integer;
begin
  if FIPCClientList.Count = 0 then
    exit;

  for i := FEntryIDList.Count - 1 downto 0 do
  begin
    LOmniValue := FEntryIDList.Strings[i];

    if not FOLMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
      Log4OL('Send queue is full!', True)
    else
    begin
      FEntryIDList.Delete(i);
      Log4OL('Send queue is success!', True);
    end;
  end;
end;

procedure TAddInModule.SendMailToMsgFile(AEntryIDList: WideString);
const
  GS_EMAIL = 'hyundai-gs.com';
var
  LNameSpace: _NameSpace;
  LMailItem: MailItem;
  LStrArr: System.Types.TStringDynArray;
  i,j,k: integer;
  LFolders: _Folders;
  LStrGuid: string;
  LData: SharedMemoryData.Ptr;
  LStrFile: string;
  LRec: TOLMsgFile4STOMP;
  LOmniValue: TOmniValue;
begin
//  LNameSpace := OutlookApp.GetNamespace('MAPI') as _NameSpace;//.GetDefaultFolder();
//  LStrArr := SplitString(AEntryIDList, ',');
//
//  for i := Low(LStrArr) to High(LStrArr) do
//  begin
//    LMailItem := nil;
//
//    for j := 1 to LNameSpace.Folders.Count do
//    begin
//        LFolders := LNameSpace.Folders.Item(j).Folders;
//
//        for k := 1 to LFolders.Count do
//        begin
//          if LFolders.Item(k).Name = '받은 편지함' then
//          begin
//            try
//              LMailItem := LNameSpace.GetItemFromID(LStrArr[i],LFolders.Item(k).StoreID) as MailItem;
//            except
//              continue;
//            end;
//
//            if Assigned(LMailItem) then
//            begin
//              LStrGuid := EnsureDirectoryExists('c:\temp\') +
//                TGuid.NewGuid.ToString + '.msg';
//              LMailItem.SaveAs(LStrGuid, olMSGUnicode);
//              LStrFile := Utf8ToString(BinToBase64(StringFromFile(LStrGuid)));
//              LRec.FHost := '10.100.23.63';
//              LRec.FUserId := 'pjh';
//              LRec.FPasswd := 'pjh';
//              LRec.FMsgFile := LStrFile;
//              LOmniValue := TOmniValue.FromRecord<TOLMsgFile4STOMP>(LRec);
//
//              if not FOLMsg2IPCMQ.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
//                Log4OL('Send queue is full!', True)
//              else
//                Log4OL('Send queue is success!', True);
//
//              SysUtils.DeleteFile(LStrGuid);
//
//              try
//                LData := FSharedData.BeginAccess;
//
//                if (FSharedData.Abandoned) then
//                  exit;
//
//                LData^.FileName := LStrGuid;
//                LData^.HasInput := True;
//                Log4OL(LStrGuid + ' Saved', True);
//                FConsumeEvent.Signal;
//              finally
//                FSharedData.EndAccess;
//              end;
//            end;
//          end;
//        end;//for
//    end;
//  end;
end;

procedure TAddInModule.SendMailToSharedMM(AEntryIDList: WideString);
const
  GS_EMAIL = 'hyundai-gs.com';
var
  LNameSpace: _NameSpace;
  LMailItem: MailItem;
  LStrArr, LEmailArr: System.Types.TStringDynArray;
  i,j,k: integer;
  LStr: string;
  LSMStream: TGpSharedStream;
  LDummyPointer: Pointer;
  LMailItem2: TIdMessage;
  InBox: MAPIFolder;
  LFolders: _Folders;
//  FSMData: TGpSharedMemory;
begin
//  ShowMessage(AEntryIDList);
  LNameSpace := OutlookApp.GetNamespace('MAPI') as _NameSpace;//.GetDefaultFolder();
  LStrArr := SplitString(AEntryIDList, ',');

  for i := Low(LStrArr) to High(LStrArr) do
  begin
//    ShowMessage(LStrArr[i]);
//    Log4OL(LStrArr[i], True);
    LMailItem := nil;
//    LMailItem := LNameSpace.GetItemFromID(LStrArr[i],OutlookApp.GetNamespace('MAPI').GetDefaultFolder(olFolderInbox).StoreID) as MailItem;
//    InBox := OutlookApp.GetNamespace('MAPI').GetDefaultFolder(olFolderInbox) as MAPIFolder;
    for j := 1 to LNameSpace.Folders.Count do
    begin
//      LEmailArr := SplitString(LNameSpace.Folders.Item(j).Name, '@');

      //hyundai-gs.com folder
//      if LEmailArr[1] = GS_EMAIL then
//      begin
        LFolders := LNameSpace.Folders.Item(j).Folders;

        for k := 1 to LFolders.Count do
        begin
          if LFolders.Item(k).Name = '받은 편지함' then
          begin
            try
              LMailItem := LNameSpace.GetItemFromID(LStrArr[i],LFolders.Item(k).StoreID) as MailItem;
            except
              continue;
            end;

            if Assigned(LMailItem) then
            begin
              LDummyPointer := FSMData.AcquireMemory(True,10000);
              try
                if Assigned(LDummyPointer) then
                begin
                  LSMStream := nil;
                  LSMStream := FSMData.AsStream;

                  if Assigned(LSMStream) then
                  begin
                    LMailItem2 := TIdMessage.Create(self);
                    try
                      if AssignOLMailItemToIdMessage(LMailItem, LMailItem2) then
                      begin
                        LMailItem2.SaveToStream(LSMStream);
          //              LSMStream.Write(LMailItem2., LStream.Size);
                        FConsumeEvent.Signal;
//  ShowMessage(LMailItem.Subject + ':' + LMailItem.Body + ':' + IntToStr(LMailItem.Attachments.Count));
                      end;
                    finally
                      LMailItem2.Free;
                    end;
                  end;
                end;
              finally
                FSMData.ReleaseMemory;
              end;
        //      ShowMessage(LNameSpace.Folders.Item(j).Name);//Name: email 주소임
            end;
          end;
//          ShowMessage(LFolders.Item(k).Name);
        end;
//      end;

//        LMailItem := LNameSpace.GetItemFromID(LStrArr[i],OutlookApp.GetNamespace('MAPI').GetDefaultFolder(olFolderInbox).StoreID) as MailItem;

//      LStr := LMailItem.SenderName;
//      LStr := StrToken(LStr,'(');
//      Send_Message('[메일알림]', 'adxOutlookAppEvents1NewMailEx', '[메일]' + LMailItem.Subject + ' [from:' + LStr + ']', OLUSERID, OLUSERID, 'B'); //+ ', at ' + FormatDateTime('m월dd일 hh시nn분', LMailItem.ReceivedTime)
//      ShowMessage(LMailItem.Subject + ' : ' + LMailItem.SenderName);
    end;
  end;
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

function TAddInModule.ServerExecuteFromClient(ACommand: string): RawUTF8;
var
  LEntryId, LStoreId: string;
  rec    : TEntryIdRecord;
  LOmniValue: TOmniValue;
  LMailItem: MailItem;
  Command, LJson: String;
  LStrList,
  LStrList2: TStringList;
  LVarArr: TVariantDynArray;
  i: integer;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Text := ACommand;
    Command := LStrList.Values['Command'];

    if Command = CMD_REQ_MAILINFO_SEND2 then
    begin
      LStrList2 := GetEmail2StrList;
      try
        Result := LStrList2.Text;
      finally
        LStrList2.Free;
      end;
    end
    else
    if Command = CMD_REQ_MOVE_FOLDER_MAIL then
    begin
      LEntryId := LStrList.Values['EntryId'];
      LStoreId := LStrList.Values['StoreId'];
      rec.FEntryId := LEntryId;
      rec.FStoreId := LStoreId;
      rec.FStoreId4Move := LStrList.Values['MoveStoreId'];
      rec.FFolderPath := LStrList.Values['MoveStorePath'];
      rec.FHullNo := LStrList.Values['HullNo'];
      rec.FIsCreateHullNoFolder := StrToBool(LStrList.Values['IsCreateHullNoFolder']);

      MoveMail2Folder(rec);
      LStrList2 := GetResponse4MoveFolder2StrList(rec);
      try
        Result := LStrList2.Text;
      finally
        LStrList2.Free;
      end;
    end
    else
    if Command = CMD_REQ_ADD_APPOINTMENT then
    begin
      LJson := LStrList.Values['TodoItemsJson'];
      LVarArr := JSONToVariantDynArray(LJson);
//      ShowMessage(LVarArr[0]);
      for i := 0 to High(LVarArr) do
      begin
        CreateAppointment(LVarArr[i]);
      end;
    end;
  finally
    LStrList.Free;
  end;
end;

function TAddInModule.SessionClosed(Sender: TSQLRestServer;
  Session: TAuthSession; Ctxt: TSQLRestServerURIContext): boolean;
begin
//  DeleteConnectionFromLV(Session.RemoteIP, FPortName, Session.ID, Session.User.LogonName);
//  Result := False;
end;

function TAddInModule.SessionCreate(Sender: TSQLRestServer;
  Session: TAuthSession; Ctxt: TSQLRestServerURIContext): boolean;
begin
//  AddConnectionToLV(Session.RemoteIP, FPortName, Session.ID, Session.User.LogonName);
//  Result := False;
end;

procedure TAddInModule.ShowMailContents(AEntryId, AStoreId: string);
var
  LMailItem: MailItem;
//  i: integer;
  LFolder: MAPIFolder;
begin
//  i := OutlookApp.ActiveExplorer.Selection.Count;
//
//  if i > 1 then
//  begin
//    ShowMessage('이 기능을 이용하기 위해서는 메일을 1개만 선택 하세요');
//    exit;
//  end;
//
//  LMailItem := OutlookApp.ActiveExplorer.Selection.Item(i) as MailItem;
//  LFolder := OutlookApp.ActiveExplorer.CurrentFolder as MAPIFolder;
//  LMailItem := FNameSpace.GetItemFromID(LMailItem.EntryID, LFolder.StoreID) as MailItem;
  LMailItem := FNameSpace.GetItemFromID(AEntryId, AStoreId) as MailItem;

  if Assigned(LMailItem) then
  begin
    LMailItem.Display(False);
//    ShowMessage(LMailItem.EntryID + #13#10 + LFolder.StoreID);
  end;
end;

procedure TAddInModule.ShowStoreIdFromSelected;
var
//  LMailItem: MailItem;
  i: integer;
  LFolder: MAPIFolder;
begin
  i := OutlookApp.ActiveExplorer.Selection.Count;

  if i > 1 then
  begin
    ShowMessage('이 기능을 이용하기 위해서는 메일을 1개만 선택 하세요');
    exit;
  end;

//  if Assigned(LFolder) then
//    ShowMessage(LFolder.Name);
//  LMailItem := OutlookApp.ActiveExplorer.Selection.Item(i) as MailItem;
  LFolder := OutlookApp.ActiveExplorer.CurrentFolder as MAPIFolder;

//  if IsExistFolder(LFolder, 'H1751') then
//  begin
//    ShowMessage('Not exist');
//    LFolder := LFolder.Folders.Add('H1752', olFolderInbox);
//  end;

//  if g_PrevStoreId = LFolder.StoreID then
//    ShowMessage('Same StoreID');

  if Assigned(LFolder) then
  begin
//    ShowMessage(LFolder.Name);
    ShowMessage(LFolder.Name + #13#10 + LFolder.StoreID);
//    g_PrevStoreId := LFolder.StoreID;
  end;
end;

procedure TAddInModule.WMRunTask(var Msg: TMessage);
begin

end;

{ TWorker4IPC }

constructor TWorker4IPC.Create(sendQueue: TOmniMessageQueue;
  ClientList: TCommContextList);
begin
  inherited Create;

  FreeOnTerminate := True;
  FOLMsg2IPCMQ := sendQueue;
  FStopEvent := TEvent.Create;
  FIPCClientList := ClientList;

  FTaskPool := TTaskPool.Create(5);
  FTaskPool.OnTaskMessage := OnMessageComplete;
  FTaskPool.Initialize;
end;

destructor TWorker4IPC.Destroy;
begin
  FreeAndNil(FStopEvent);
  FTaskPool.Finalize;
  FTaskPool.Free;

  inherited;
end;

procedure TWorker4IPC.Execute;
var
  handles: array [0..1] of THandle;
  msg: TOmniMessage;
  rec: TOLMsgFileRecord;
  rec2: TEntryIdRecord;
  LStrArr: System.Types.TStringDynArray;
  LStrList: TStringList;
  IPCClient: TIPCClient;
  TimeStamp: TDateTime;
  Request: IIPCData;
  Result: IIPCData;
  LStr: string;
begin
  LStrList := TStringList.Create;
  try
    handles[0] := FStopEvent.Handle;
    handles[1] := FOLMsg2IPCMQ.GetNewMessageEvent;

    while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
    begin
      if terminated then
        break;

      if FIPCClientList.Count = 0 then
        Continue;

      while FOLMsg2IPCMQ.TryDequeue(msg) do
      begin
        LStrList.Clear;
        IPCClient := TIPCClient.Create;
        try
          IPCClient.ServerName := IPC_SERVER_NAME_4_INQMANAGE;
          LStrList.Add('ServerName='+IPC_SERVER_NAME_4_INQMANAGE);

          if msg.MsgID = 2 then
          begin
            rec := msg.MsgData.ToRecord<TOLMsgFileRecord>;
            LStrList.Add('Command='+CMD_SEND_MAIL_ENTRYID);
            LStrList.Add('EntryId='+rec.FEntryId);
            LStrList.Add('StoreId='+rec.FStoreId);
            LStrList.Add('Sender='+rec.FSender);
            LStrList.Add('Receiver='+rec.FReceiver);
            LStrList.Add('RecvDate='+DateTimeToStr(rec.FReceiveDate));
            LStrList.Add('CC='+rec.FCarbonCopy);
            LStrList.Add('BCC='+rec.FBlindCC);
            LStrList.Add('Subject='+rec.FSubject);
          end
          else if msg.MsgID = 3 then
          begin
            rec2 := msg.MsgData.ToRecord<TEntryIdRecord>;
            LStrList.Add('Command='+CMD_SEND_FOLDER_STOREID);
            LStrArr := SplitString(rec2.FEntryId, ';');
            LStrList.Add('FolderPath='+LStrArr[0]);
            LStrList.Add('FolderName='+LStrArr[1]);
            LStrList.Add('StoreId='+rec2.FStoreId);
          end;

          Request := AcquireIPCData;
          Request.ID := DateTimeToStr(Now);
          Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);
          Result := IPCClient.ExecuteRequest(Request);

          if IPCClient.AnswerValid then
          begin
            TimeStamp := Result.Data.ReadDateTime('TDateTime');
            LStr := DateTimeToStr(TimeStamp) + ' : ' + #13#10 + LStrList.Text;

            Log4OL(LStr, True);
          end;
        finally
          IPCClient.Free;
        end;
      end;
    end;
  finally
    LStrList.Free;
  end;
end;

procedure TWorker4IPC.OnAsynchronousIPCTask(const ATask: ITask);
var
  Result: IIPCData;
  Request: IIPCData;
  IPCClient: TIPCClient;
  TimeStamp: TDateTime;
  LCommand,
  LStr, EntryId, StoreId, Sender, Receiver, Subject: string;
  LStrList: TStringList;
  i: integer;
begin
  IPCClient := TIPCClient.Create;
  LStrList := TStringList.Create;
  try
    LStrList.Text := ATask.Values.Get(CMD_LIST).AsString;
    IPCClient.ServerName := LStrList.Values['ServerName'];

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);

//    for i := 1 to LStrList.Count - 1 do
//      Request.Data.WriteUTF8String(LStrList.Names[i], LStrList.ValueFromIndex[i]);
    Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);
    Result := IPCClient.ExecuteRequest(Request);

    if IPCClient.AnswerValid then
    begin
      TimeStamp := Result.Data.ReadDateTime('TDateTime');
      LStr := DateTimeToStr(TimeStamp) + ' : ' + #13#10 + LStrList.Text;

      Log4OL(LStr, True);
//      ATask.Message.Ensure('ID').AsString := Result.ID;
//      ATask.Message.Ensure('TDateTime').AsString := DateTimeToStr(TimeStamp);
//      ATask.Message.Ensure('EntryId').AsString := EntryId;
//      ATask.Message.Ensure('StoreId').AsString := StoreId;
//      ATask.Message.Ensure('Subject').AsString := Subject;
//      ATask.Message.Ensure('Integer').AsInteger := Result.Data.ReadInteger('Integer');
//      ATask.Message.Ensure('Real').AsFloat := Result.Data.ReadReal('Real');
//      ATask.Message.Ensure('String').AsString := string(Result.Data.ReadUTF8String('String'));
//      ATask.SendMessageAsync;
    end;
  finally
    LStrList.Free;
    IPCClient.Free;
  end;
end;

procedure TWorker4IPC.OnMessageComplete(const Msg: ITaskMessage);
begin
//  ListBox1.Items.Add(Format('ASynchronous Response with ID: %s', [Msg.Values.Get('ID').AsString]));
//  ListBox1.Items.Add(Format('Response: TDateTime [%s]', [Msg.Values.Get('TDateTime').AsString]));
//  ListBox1.Items.Add(Format('Response: Integer [%d]', [Msg.Values.Get('Integer').AsInteger]));
//  ListBox1.Items.Add(Format('Response: Real [%f]', [Msg.Values.Get('Real').AsFloat]));
//  ListBox1.Items.Add(Format('Response: String [%s]', [Msg.Values.Get('String').AsString]));
end;

procedure TWorker4IPC.Stop;
begin
  FStopEvent.SetEvent;
end;

{ TWorker4OLMsg }

constructor TWorker4OLMsg.Create(sendQueue, IPCQueue: TOmniMessageQueue;
  AInboxStoreIdList: TStringList; ANameSpace: _NameSpace);
begin
  inherited Create;

  FreeOnTerminate := True;
  FOLMsgQueue := sendQueue;
  FOLMsg2IPCMQ := IPCQueue;
  FInboxStoreIdList := AInboxStoreIdList;
//  FNameSpace := OutlookApp.GetNamespace('MAPI') as _NameSpace;//.GetDefaultFolder();
  FNameSpace := ANameSpace;
//  ShowMessage(FNameSpace.DefaultStore.StoreID);
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
  LOmniValue: TOmniValue;
  i,k: integer;
  LStrArr: System.Types.TStringDynArray;
  LEntryIDList: string;
  LStoreID: string;
  LCheckReceiverOK: Boolean;
  LEntryRec: TEntryIdRecord;

//  procedure EmailDisplay;
//  begin
//    LMailItem.Display(False);
//  end;

  procedure SendIPCMq(AStoreId: string);
  var
    j: integer;
  begin
    LMailItem := FNameSpace.GetItemFromID(LStrArr[i], AStoreId) as MailItem;

    if Assigned(LMailItem) then
    begin
      rec.Clear;

      for j := 1 to LMailItem.Recipients.Count do
        if LMailItem.Recipients.Item(j).type_ = OlTo then
          rec.FReceiver := rec.FReceiver + LMailItem.Recipients.Item(j).Address + ';'
        else if LMailItem.Recipients.Item(j).type_ = olCC then
          rec.FCarbonCopy := rec.FCarbonCopy + LMailItem.Recipients.Item(j).Address + ';'
        else if LMailItem.Recipients.Item(j).type_ = olBCC then
          rec.FBlindCC := rec.FBlindCC + LMailItem.Recipients.Item(j).Address + ';';

      if LEntryRec.FIgnoreReceiver2pjh then
        LCheckReceiverOK := True
      else
      begin
        LCheckReceiverOK := (Pos(OLMYMAILADDR, rec.FReceiver) > 0) or
                          (Pos(OLMYMAILADDR2, rec.FReceiver) > 0);
      end;

      if LCheckReceiverOK then
      begin
        rec.FSender := LMailItem.SenderEmailAddress;
        rec.FReceiveDate := LMailItem.ReceivedTime;
        rec.FSubject := LMailItem.Subject;
        rec.FMailItem := LMailItem;

        if not LEntryRec.FIgnoreEmailMove2WorkFolder then
        begin
          rec.FMailItem := LMailItem.Move(g_WorkingFolder) as MailItem;
          rec.FStoreId := g_WorkingFolder.StoreID;
        end
        else
          rec.FStoreId := AStoreId;

        rec.FEntryId := LMailItem.EntryID;
        LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
        FOLMsg2IPCMQ.Enqueue(TOmniMessage.Create(2, LOmniValue));
//                ShowMessage(rec.FMailItem.EntryID + ' ==> ' + g_WorkingFolder.StoreID);
//                ShowMessage(LMailItem.EntryID + ' ==> ' + g_WorkingFolder.StoreID);
      end;
    end;
  end;
begin
  handles[0] := FStopEvent.Handle;
  handles[1] := FOLMsgQueue.GetNewMessageEvent;

  while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
  begin
    if terminated then
      break;

    while FOLMsgQueue.TryDequeue(msg) do
    begin
      if msg.MsgID = 4 then //Send 2 IPC FolderID(Popup Menu)
      begin
        FOLMsg2IPCMQ.Enqueue(TOmniMessage.Create(3, msg.MsgData));
      end
      else
      begin
//      LEntryIDList := msg.MsgData.AsString;
        LEntryRec := msg.MsgData.ToRecord<TEntryIdRecord>;
        LEntryIDList := LEntryRec.FEntryId;
        LStrArr := SplitString(LEntryIDList, ',');

        for i := Low(LStrArr) to High(LStrArr) do
        begin
  //        LMailItem := nil;

          if LEntryRec.FStoreId <> '' then
          begin
            SendIPCMq(LEntryRec.FStoreId);
          end
          else
          begin
            for k := 0 to FInboxStoreIDList.Count - 1 do
            begin
              LStoreID := FInboxStoreIDList.ValueFromIndex[k];

              try
                SendIPCMq(LStoreID);
              except
                continue;
              end;
            end;//for
          end;//else
        end;//for
      end;//else
    end;//while
  end;//while
end;

procedure TWorker4OLMsg.Stop;
begin
  FStopEvent.SetEvent;
end;

{ TServiceOL4WS }

procedure TServiceOL4WS.CallbackReleased(const callback: IInvokable;
  const interfaceName: RawUTF8);
var
  LClientInfo: TClientInfo;
  LIndex,i: integer;
begin
  assert(interfaceName = 'IOLCallback');
  LIndex := -1;
  LIndex := InterfaceArrayDelete(fConnected, callback);

  if LIndex <> -1 then
  begin
    LClientInfo := TClientInfo(FClientInfoList.Objects[LIndex]);
//    i := Mainform.FSendOnlyChangedClientList.IndexOf(LClientInfo.GUID);

//    if i <> -1 then
//      Mainform.FSendOnlyChangedClientList.Delete(i);

//    Mainform.FCS.DeleteConnectionFromLV(LClientInfo.IPAddress, IntToStr(LClientInfo.PortNo), LClientInfo.GUID, LClientInfo.UserName);
    FClientInfoList.Delete(LIndex);
  end;
end;

constructor TServiceOL4WS.Create;
begin
  FClientInfoList :=  TStringList.Create;
end;

destructor TServiceOL4WS.Destroy;
var
  i: integer;
begin
  for i := 0 to FClientInfoList.Count - 1 do
    TClientInfo(FClientInfoList.Objects[i]).Free;

  FClientInfoList.Free;

  inherited;
end;

function TServiceOL4WS.GetOLEmailInfo(ACommand: string): RawUTF8;
begin
  MyAddInModule.ProcessCommandFromClient(ACommand);
end;

procedure TServiceOL4WS.Join(const pseudo: string; const callback: IOLMailCallback);
begin
//  MyAddInModule.ServerExecuteFromClient(ACommand);
end;

function TServiceOL4WS.ServerExecute(const Acommand: string): RawUTF8;
begin
  Result := MyAddInModule.ServerExecuteFromClient(ACommand);
end;

initialization
  TadxFactory.Create(ComServer, TCoCalContextAddIn, CLASS_CoCalContextAddIn, TAddInModule);

end.

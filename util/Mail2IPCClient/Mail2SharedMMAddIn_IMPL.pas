unit Mail2SharedMMAddIn_IMPL;

interface

uses
  SysUtils, ComObj, ComServ, ActiveX, Variants, Outlook2010, Office2010, adxAddIn,
  System.Types, System.StrUtils, CalContextAddIn_TLB, System.Classes, Dialogs,
  Winapi.Windows, OtlCommon, OtlComm, System.SyncObjs, OtlContainerObserver,
  adxHostAppEvents, adxolFormsManager, IPC.Events, CommonData,
  IdMessage, UnitSynLog, SynLog, SynCommons, mORMot, GpSharedMemory, IPC.SharedMem;

const
  OLUSERID = 'A379042';
  OLMAILADDR = 'jhpark@hyundai-gs.com';

type
  SharedMemoryData = SharedMemory<TGUIDFileName>;

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
    FSMData: TGpSharedMemory;
    FSharedData: SharedMemoryData;
    FWorker4STOMP: TWorker4STOMP;
    FWorker4OLMsg: TWorker4OLMsg;
    FOLMsgQueue,
    FSendMsgQueue: TOmniMessageQueue;
  protected
    procedure DoItemAdd(ASender: TObject; const Item: IDispatch);
    procedure Log(Amsg: string; AIsSaveLog: Boolean = False;
      AMsgLevel: TSynLogInfo = sllInfo);
  public
    //Aflag = 'A'; //쪽지
    //      = 'B'; //SMS
    //AUser = 사번
    procedure Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser, AFlag: string);
    procedure SendMailToSharedMM(AEntryIDList: WideString);
    procedure SendMailToMsgFile(AEntryIDList: WideString);
    procedure SendMailInfoToNamedPipe(AEntryIDList: WideString);
    function AssignOLMailItemToIdMessage(AOLMailItem: MailItem;
      out AIdMsg: TIdMessage): boolean;
    procedure AssignOLRecipientToIdMsg(AOLMailItem: MailItem;
      out AIdMsg: TIdMessage);
    procedure AssignOLAttachmentToIdMsg(AOLMailItem: MailItem;
      out AIdMsg: TIdMessage);
  end;

implementation

uses HHI_WebService, UnitHHIMessage, CommonUtil_Unit, IdEMailAddress,
  IdAttachmentFile, StompClient, StompTypes;

{$R *.dfm}

procedure TAddInModule.adxCOMAddInModuleAddInInitialize(Sender: TObject);
//var
//  IFolderInbox: MAPIFolder;
begin
  InitSynLog;
  FConsumeEvent := Event.Create(CONSUME_EVENT_NAME);
  FProduceEvent := Event.Create(PRODUCE_EVENT_NAME);
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
  FSharedData := SharedMemoryData.Create(SHARED_DATA_NAME, SharedMemoryAccessReadWrite);
  FSMData := TGpSharedMemory.Create(gpSHARED_DATA_NAME, 10000, 300000000);
  FSendMsgQueue := TOmniMessageQueue.Create(1000);
  FOLMsgQueue := TOmniMessageQueue.Create(1000);
  FWorker4STOMP := TWorker4STOMP.Create(FSendMsgQueue);
  FWorker4OLMsg := TWorker4OLMsg.Create(FOLMsgQueue);
//  ShowMessage('OnCreate');
end;

procedure TAddInModule.adxCOMAddInModuleDestroy(Sender: TObject);
begin
  FSMData.Free;

  FWorker4OLMsg.Terminate;
  FWorker4OLMsg.Stop;
  FWorker4OLMsg.Free;

  FWorker4STOMP.Terminate;
  FWorker4STOMP.Stop;
  FSendMsgQueue.Free;
//  ShowMessage('OnDestroy');
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
//  SendMailToSharedMM(EntryIDCollection);
//  SendMailToMsgFile(EntryIDCollection);
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
  LAppointmentItem := Reminder(ReminderObject).Item as AppointmentItem;

  if LAppointmentItem.Start >= now then
  begin
    Send_Message('[알림]', 'LAppointmentItem.Subject', '[일정]' + LAppointmentItem.Subject + ' => ' + FormatDateTime('hh시mm분', LAppointmentItem.Start),OLUSERID, OLUSERID, 'B');
//    ShowMessage(LAppointmentItem.Subject + ':' + DateTimeToStr(LAppointmentItem.Start));
  end;
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
  LStrArr: System.Types.TStringDynArray;
  LStrFile: string;
  LRec: TOLMsgFileRecord;
  LOmniValue: TOmniValue;
  i,j: integer;
begin
  LNameSpace := OutlookApp.GetNamespace('MAPI') as _NameSpace;
  IFolderInbox := LNameSpace.GetDefaultFolder(olFolderInbox);

  if not Assigned(IFolderInbox) then
    exit;

  LStrArr := SplitString(AEntryIDList, ',');

  if IFolderInbox.Name = '받은 편지함' then
  begin
    Log('받은 편지함!', True);
    for i := Low(LStrArr) to High(LStrArr) do
    begin
      LMailItem := nil;

      try
        LMailItem := LNameSpace.GetItemFromID(LStrArr[i],IFolderInbox.StoreID) as MailItem;
      except
        continue;
      end;

      if Assigned(LMailItem) then
      begin
        LRec.FSender := LMailItem.SenderEmailAddress;

        for j := 1 to LMailItem.Recipients.Count do
          LRec.FReceiver := LRec.FReceiver + LMailItem.Recipients.Item(j).Address + ';';

        LRec.FSubject := LMailItem.Subject;
        LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(LRec);

        if not FSendMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
          Log('Send queue is full!', True)
        else
          Log('Send queue is success!', True);

        Log('Receiver : ' + LRec.FReceiver, True);
//        FConsumeEvent.Signal;
      end;
    end;
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
  LNameSpace := OutlookApp.GetNamespace('MAPI') as _NameSpace;//.GetDefaultFolder();
  LStrArr := SplitString(AEntryIDList, ',');

  for i := Low(LStrArr) to High(LStrArr) do
  begin
    LMailItem := nil;

    for j := 1 to LNameSpace.Folders.Count do
    begin
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
              LStrGuid := EnsureDirectoryExists('c:\temp\') +
                TGuid.NewGuid.ToString + '.msg';
              LMailItem.SaveAs(LStrGuid, olMSGUnicode);
              LStrFile := Utf8ToString(BinToBase64(StringFromFile(LStrGuid)));
              LRec.FHost := '10.100.23.63';
              LRec.FUserId := 'pjh';
              LRec.FPasswd := 'pjh';
              LRec.FMsgFile := LStrFile;
              LOmniValue := TOmniValue.FromRecord<TOLMsgFile4STOMP>(LRec);

              if not FSendMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue)) then
                Log('Send queue is full!', True)
              else
                Log('Send queue is success!', True);

              SysUtils.DeleteFile(LStrGuid);

              try
                LData := FSharedData.BeginAccess;

                if (FSharedData.Abandoned) then
                  exit;

                LData^.FileName := LStrGuid;
                LData^.HasInput := True;
                Log(LStrGuid + ' Saved', True);
                FConsumeEvent.Signal;
              finally
                FSharedData.EndAccess;
              end;
            end;
          end;
        end;//for
    end;
  end;
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
//    Log(LStrArr[i], True);
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

initialization
  TadxFactory.Create(ComServer, TCoCalContextAddIn, CLASS_CoCalContextAddIn, TAddInModule);

end.

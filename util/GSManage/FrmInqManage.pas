unit FrmInqManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Winapi.ActiveX,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, AdvOfficeTabSet,
  Vcl.StdCtrls, Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons, AeroButtons,
  JvExControls, JvLabel, CurvyControls, Vcl.ImgList, System.SyncObjs,
  OtlCommon, OtlComm, OtlTaskControl, OtlContainerObserver, otlTask,
  CommonData, TaskForm, UElecDataRecord, System.Rtti,
  DragDropInternet,DropSource,DragDropFile,DragDropFormats, DragDrop, DropTarget,
  mORMot, SynCommons, SynSqlite3Static, VarRecUtils,
  FrameDisplayTaskInfo, Vcl.Menus,
  mORMotHttpServer, mORMotWrappers, mORMotHttpClient, OLMailWSCallbackInterface,
  UnitRegistrationClass, UnitRegCodeConst,
  UnitHttpModule4RegServer, UnitRegCodeServerInterface, UnitRegistrationRecord,
  thundax.lib.actions, UnitMAPSMacro, UnitInqManageWSInterface, UnitUserDataRecord,
  Vcl.ExtCtrls, UnitElecServiceData;

const
  WM_OLMSG_RESULT = WM_USER + 1;

type
  TServiceIM4WS = class(TInterfacedObject, IInqManageService)
  private
  protected
    fConnected: array of IInqManageCallback;
    FClientInfoList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Join(const pseudo: string; const callback: IInqManageCallback);
    procedure CallbackReleased(const callback: IInvokable; const interfaceName: RawUTF8);
    function ServerExecute(const Acommand: RawUTF8): RawUTF8;
  end;

  TWorker4OLMsg = class(TThread)
  private
    FDBMsgQueue: TOmniMessageQueue;
    FIPCMQFromOL: TOmniMessageQueue;
    FStopEvent    : TEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(DBMsgQueue, IPCQueue: TOmniMessageQueue);
    destructor Destroy; override;
    procedure Stop;
  end;

  TOLMailCallback = class(TInterfacedCallback,IOLMailCallback)
  protected
    procedure ClientExecute(const command, msg: string);
  end;

  TInquiryF = class(TForm)
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterOutlook: TDataFormatAdapter;
    TDTF: TDisplayTaskF;
    MAPS1: TMenuItem;
    QUOTATIONINPUT1: TMenuItem;
    DropEmptySource1: TDropEmptySource;
    DataFormatAdapter2: TDataFormatAdapter;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DataFormatAdapter1: TDataFormatAdapter;
    N1: TMenuItem;
    N2: TMenuItem;
    est1: TMenuItem;
    Timer1: TTimer;
    File1: TMenuItem;
    OpenDialog1: TOpenDialog;
    est2: TMenuItem;
    ViewTariff1: TMenuItem;
    EditTariff1: TMenuItem;
    CreateNewTask1: TMenuItem;
    N4: TMenuItem;
    Close1: TMenuItem;
    N5: TMenuItem;
    ariff1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TDTFComboBox1DropDown(Sender: TObject);
    procedure TDTFbtn_SearchClick(Sender: TObject);
    procedure TDTFrg_periodClick(Sender: TObject);
    procedure TDTFgrid_ReqCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure TDTFEmailButtonClick(Sender: TObject);
    procedure TDTFJvLabel7Click(Sender: TObject);
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure TDTFShowTaskID1Click(Sender: TObject);
    procedure TDTFbtn_CloseClick(Sender: TObject);
    procedure QUOTATIONINPUT1Click(Sender: TObject);
    procedure TDTFgrid_ReqMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure TDTFN16Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure est1Click(Sender: TObject);
    procedure TDTFJvLabel8Click(Sender: TObject);
    procedure est2Click(Sender: TObject);
    procedure ViewTariff1Click(Sender: TObject);
    procedure EditTariff1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure CreateNewTask1Click(Sender: TObject);
  private
//    FIPCServer: TIPCServer;
//    FHttpClientWebsocket: TSQLHttpClientWebsockets;
    FStopEvent    : TEvent;
    FDBMsgQueue: TOmniMessageQueue;
    FIPCMQFromOL: TOmniMessageQueue;
    FWorker4OLMsg: TWorker4OLMsg;
    FTaskJson: String;
    FFileContent: RawByteString;
//    FRegInfo: TRegistrationInfo;

    //Websocket-b
    FModel: TSQLModel;
    FHTTPServer: TSQLHttpServer;
    FRestServer: TSQLRestServer;
    FServiceFactoryServer: TServiceFactoryServer;

    FIpAddr: string;
    FURL: string; //Server에서 Client에 Config Change Notify 하기 위한 Call Back URL
    FIsServerActive,
    FIsPJHPC,
    FIsRunRestServer: Boolean;

    FUserEmail,
    FUserName: string;
    FCommModes: TCommModes;
    //Websocket-e

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);

    procedure DisplayOLMsg2Grid(const task: IOmniTaskControl; const msg: TOmniMessage);
//    procedure DisplayTask2GridFromRemote();

    function CheckRegistration: Boolean;

    procedure ProcessCommand(ARespond: string);
    //Macro에서 ExecFunction으로 FunctionName을 주면 아래의 public란 Procedure에서
    //함수명을 찾아서 실행해 줌
    procedure ExecFunc(AFuncName: string);
    procedure ExecMethod(MethodName:string; const Args: array of TValue);

    function SaveCurrentTask2File(AFileName: string = '') : string;
    procedure CreateNewTask;

    //Websocket-b
    procedure CreateHttpServer4WS(APort, ATransmissionKey: string;
      aClient: TInterfacedClass; const aInterfaces: array of TGUID);
    procedure DestroyHttpServer;
    function SessionCreate(Sender: TSQLRestServer; Session: TAuthSession;
                  Ctxt: TSQLRestServerURIContext): boolean;
    function SessionClosed(Sender: TSQLRestServer; Session: TAuthSession;
                  Ctxt: TSQLRestServerURIContext): boolean;
    procedure InitNetwork;
    function ServerExecuteFromClient(ACommand: RawUTF8): RawUTF8;
    //Websocket-e

    procedure TestRemoteTaskList;
    procedure TestRemoteTaskDetail;
  public
    //Main or 단순 조회: Main := 0, 단순 조회 := 1
    FProgMode: integer;

    procedure TestRemoteTaskEmailList(ATask: TSQLGSTask);

    procedure AsynDisplayOLMsg2Grid;//(AStopEvent: TEvent; AIPCMQFromOL: TOmniMessageQueue);
    procedure SendReqOLEmailInfo;
    procedure SendReqOLEmailInfo_CromisIPC;
    procedure SendReqOLEmailInfo_WS;

    procedure KeyIn_CompanyCode;
    procedure KeyIn_RFQ;
    procedure Select_Money;
    procedure KeyIn_Content;
    procedure Select_DeliveryCondition;
    procedure Select_EstimateType;
    procedure Select_TermsOfPayment;
  end;

var
  InquiryF: TInquiryF;

implementation

Uses System.DateUtils, OtlParallel, Clipbrd, UViewMailList,
  UnitIPCModule, FrmRegistration, Vcl.ogutil, UnitDragUtil, UnitVariantJsonUtil,
  UnitMakeMasterCustomerDB, UnitBase64Util, UnitHttpModule4InqManageServer,
  FrmEditTariff, UnitGSTariffRecord, FrmDisplayTariff;

{$R *.dfm}

procedure TInquiryF.AsynDisplayOLMsg2Grid;//(AStopEvent: TEvent;
//  AIPCMQFromOL: TOmniMessageQueue);
var
  LEmailMsg,
  LEmailMsg2: TSQLEmailMsg;
  LTask,
  LTask2: TSQLGSTask;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      i: integer;
      handles: array [0..1] of THandle;
      msg    : TOmniMessage;
      rec    : TOLMsgFileRecord;
      LID: TID;
      LTaskIds: TIDDynArray;
      LIsAddTask,  //True=신규 Task 등록
      LIsProcessJson: Boolean; //Task정보를 Json파일로 받음
      LStr: string;
    begin
      try
        g_MyEmailInfo := SendReqOLEmailAccountInfo_WS;
      except
      end;

      handles[0] := FStopEvent.Handle;
      handles[1] := FIPCMQFromOL.GetNewMessageEvent;
      LEmailMsg := TSQLEmailMsg.Create;

      while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
      begin
        while FIPCMQFromOL.TryDequeue(msg) do
        begin
          LTask := TSQLGSTask.Create;
          try
            rec := msg.MsgData.ToRecord<TOLMsgFileRecord>;

            if msg.MsgID = 1 then
            begin
              LIsProcessJson := False;

              if (rec.FEntryID <> '') and (rec.FStoreID <> '') then
              begin
                LEmailMsg := TSQLEmailMsg.Create(g_ProjectDB,
                  'EntryID = ? AND StoreID = ?', [rec.FEntryID,rec.FStoreID]);

                //데이터가 없으면
  //              if LEmailMsg.ID = 0 then
                if not LEmailMsg.FillOne then
                begin
                  LEmailMsg.Sender := rec.FSender;
                  LEmailMsg.Receiver := rec.FReceiver;
                  LEmailMsg.CarbonCopy := rec.FCarbonCopy;
                  LEmailMsg.BlindCC := rec.FBlindCC;
                  LEmailMsg.EntryID := rec.FEntryId;
                  LEmailMsg.StoreID := rec.FStoreId;
                  LEmailMsg.Subject := rec.FSubject;
                  LEmailMsg.SavedOLFolderPath := rec.FSavedOLFolderPath;
                  LEmailMsg.RecvDate := TimeLogFromDateTime(rec.FReceiveDate);

                  LEmailMsg2 := TSQLEmailMsg.Create(g_ProjectDB,
                    'Subject = ?', [rec.FSubject]);

                  if LEmailMsg2.FillOne then //동일한 제목의 메일이 존재하면
                  begin
                    LIsAddTask := False;
                    LTask.EmailMsg.SourceGet(g_ProjectDB, LEmailMsg2.ID, LTaskIds);

                    try
                      for i:= low(LTaskIds) to high(LTaskIds) do
                      begin
                        LTask2 := CreateOrGetLoadTask(LTaskIds[i]);
                        break;
                      end;
                    finally
                      if LTask2.ID <> 0 then
                      begin
                        LTask2.EmailMsg.ManyAdd(g_ProjectDB, LTask2.ID, LEMailMsg.ID, True);
                        FreeAndNil(LTask2);
                      end;
                    end;

                    LEmailMsg.ParentID := LEmailMsg2.EntryID+';'+LEmailMsg2.StoreID;
                    LID := g_ProjectDB.Add(LEmailMsg, true);
                  end
                  else
                  begin //제목이 존재하지 않으면 Task도 새로 등록 해야 함
  //                  LIsAddTask := True;
                    LTask.InqRecvDate := TimeLogFromDateTime(rec.FReceiveDate);
                    LTask.ChargeInPersonId := rec.FUserEmail;
                    LIsAddTask := TaskForm.DisplayTaskInfo2EditForm(LTask, LEmailMsg, null);
    //                g_ProjectDB.Add(LTask, true);
    //                LTask.EmailMsg.ManyAdd(g_ProjectDB, LTask.ID, LEmailMsg.ID, true);
                  end;
                end;
              end;
            end
            else
            if msg.MsgID = 2 then
            begin
              //task.Invoke함수에서 Grid에 Task 추가하는 것을 방지함
              LIsAddTask := False;
              LIsProcessJson := False;
              TDTF.AddFolderListFromOL(rec.FEntryId + '=' + rec.FStoreId);
            end
            else
            if msg.MsgID = 3 then
            begin
              LStr := rec.FSubject;
              LIsProcessJson := True;
              LIsAddTask := False;
            end;

            task.Invoke(
              procedure
              begin
                //동일한 제목의 메일이 존재하지 않으면 Grid에 추가
                if LIsAddTask then
                begin
                  if Assigned(LTask) then
                  begin
                    TDTF.LoadTaskVar2Grid(LTask, TDTF.grid_Req);
                    FreeAndNil(LTask);
                  end;
  //                i := TDTF.grid_Req.AddRow;
  //                TDTF.grid_Req.CellByName['Subject',i].AsString := rec.FSubject;
  //                TDTF.grid_Req.Row[i].Data := TIDList.Create;
  //                TIDList(TDTF.grid_Req.Row[i].Data).EmailId := LID;
  //                TIDList(TDTF.grid_Req.Row[i].Data).TaskId := LTask.ID;
                end;

                if LIsProcessJson then
                begin
                  ProcessTaskJson(LStr);
                end;
              end
            );
          finally
            if (not LIsAddTask) and Assigned(LTask) then
              FreeAndNil(LTask);
          end;
        end;//while
      end;//while
    end,

    Parallel.TaskConfig.OnMessage(Self).OnTerminated(
      procedure
      begin
        FreeAndNil(LEmailMsg);
      end
    )
  );
end;

procedure TInquiryF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

function TInquiryF.CheckRegistration: Boolean;
begin

end;

procedure TInquiryF.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TInquiryF.CreateHttpServer4WS(APort, ATransmissionKey: string;
  aClient: TInterfacedClass; const aInterfaces: array of TGUID);
begin
  if not Assigned(FRestServer) then
  begin
    // initialize a TObjectList-based database engine
    FRestServer := TSQLRestServerFullMemory.CreateWithOwnModel([]);
    // register our Interface service on the server side
    FRestServer.CreateMissingTables;
    FServiceFactoryServer := FRestServer.ServiceDefine(aClient, aInterfaces , sicShared);  //sicClientDriven
    FServiceFactoryServer.SetOptions([], [optExecLockedPerInterface]). // thread-safe fConnected[]
      ByPassAuthentication := true;
  end;

  if not Assigned(FHTTPServer) then
  begin
    // launch the HTTP server
//    FPortName := APort;
    FHTTPServer := TSQLHttpServer.Create(APort, [FRestServer], '+' , useBidirSocket);
    FHTTPServer.WebSocketsEnable(FRestServer, ATransmissionKey);
    FIsServerActive := True;
  end;

  FCommModes := FCommModes + [cmWebSocket];
end;

procedure TInquiryF.CreateNewTask;
var
  LTask: TSQLGSTask;
begin
  LTask := TSQLGSTask.Create;
  try
  if TaskForm.DisplayTaskInfo2EditForm(LTask, nil, null) then
    TDTF.LoadTaskVar2Grid(LTask, TDTF.grid_Req);
  finally
    LTask.Free;
  end;
end;

procedure TInquiryF.CreateNewTask1Click(Sender: TObject);
begin
  CreateNewTask;
end;

procedure TInquiryF.DestroyHttpServer;
begin
  if Assigned(FHTTPServer) then
    FHTTPServer.Free;

  if Assigned(FRestServer) then
  begin
    FRestServer.Free;
  end;

  if Assigned(FModel) then
    FreeAndNil(FModel);
end;

procedure TInquiryF.DisplayOLMsg2Grid(const task: IOmniTaskControl;
  const msg: TOmniMessage);
var
  rec    : TOLMsgFileRecord;
begin
//  ShowMessage(rec.FSubject);
//  rec := msg.MsgData.ToRecord<TOLMsgFileRecord>;
end;

procedure TInquiryF.DropEmptyTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  LTargetStream: TStream;
  LStr: RawByteString;
  LProcessOK: Boolean;
  LFileName: string;
  rec    : TOLMsgFileRecord;
  LOmniValue: TOmniValue;
begin
  LFileName := '';
  // 윈도우 탐색기에서 Drag 했을 경우
  if (DataFormatAdapter1.DataFormat <> nil) then
  begin
    LFileName := (DataFormatAdapter1.DataFormat as TFileDataFormat).Files.Text;

    if LFileName <> '' then
    begin
      if ExtractFileExt(LFileName) <> '.hgs' then
      begin
        ShowMessage('This file is not auto created by HGS from explorer');
        exit;
      end;

      LStr := StringFromFile(LFileName);
      rec.FSubject := LStr;
      LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
      FIPCMQFromOL.Enqueue(TOmniMessage.Create(3, LOmniValue));
//      LProcessOK := ProcessTaskJson(LStr);
      exit;
    end;
  end;

  // OutLook에서 첨부파일을 Drag 했을 경우
  if (TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames.Count > 0) then
  begin
    LFileName := TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames[0];

    if ExtractFileExt(LFileName) <> '.msg' then
    begin
      if ExtractFileExt(LFileName) <> '.hgs' then
      begin
        ShowMessage('This file is not auto created by HGS');
        exit;
      end;

      LTargetStream := GetStreamFromDropDataFormat(TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat));
      try
        if not Assigned(LTargetStream) then
          ShowMessage('Not Assigned');

        LStr := StreamToRawByteString(LTargetStream);
  //      LStr := LTargetStream.DataString;

        rec.FSubject := LStr;
        LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
        FIPCMQFromOL.Enqueue(TOmniMessage.Create(3, LOmniValue));
        exit;
//        LProcessOK := ProcessTaskJson(LStr);

  //      LTargetStream.Seek(0,soBeginning);
  //      LStr := ReadStringFromStream(LTargetStream);
  //      ShowMessage(LStr);
      finally
        if Assigned(LTargetStream) then
          LTargetStream.Free;
      end;
    end;
  end;

  // OutLook에서 메일을 Drag 했을 경우
  if not LProcessOK and (DataFormatAdapterOutlook.DataFormat <> nil) then
  begin
    SendReqOLEmailInfo;
//    ShowMessage('Outlook Mail Dropped');
  end;
end;

procedure TInquiryF.EditTariff1Click(Sender: TObject);
begin
  DisplayTariffEditF;
end;

procedure TInquiryF.est1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportMasterCustomerFromXlsFile(OpenDialog1.FileName);
    end;
  end;
end;

procedure TInquiryF.est2Click(Sender: TObject);
begin
  TestRemoteTaskDetail;
end;

procedure TInquiryF.ExecFunc(AFuncName: string);
begin
  if AFuncName <> '' then
    ExecMethod(AFuncName,[]);
end;

procedure TInquiryF.ExecMethod(MethodName: string; const Args: array of TValue);
var
  R : TRttiContext;
  T : TRttiType;
  M : TRttiMethod;
begin
  T := R.GetType(Self.ClassType);

  for M in t.GetMethods do
  begin
    if (m.Parent = t) and (m.Name = MethodName)then
    begin
      M.Invoke(Self,Args);
      break;
    end;
  end;
end;

procedure TInquiryF.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  for i := 0 to TDTF.grid_Req.RowCount - 1 do
    TIDList(TDTF.grid_Req.Row[i].Data).Free;

  FStopEvent.SetEvent;
//  FIPCServer.Stop;
  g_IPCClient.DisconnectClient;
end;

procedure TInquiryF.FormCreate(Sender: TObject);
var
  LPort: integer;
begin
  LPort := StrToIntDef(RCS_PORT_NAME, -1);

//  if not DoIsTCPPortAllowed(LPort, RCS_DEFAULT_IP) then
//  begin
//    LStr := ExtractFileName(Application.ExeName);
//    DoAddExceptionToFirewall(LStr, Application.ExeName, LPort);
////    GetRulesFromFirewall(LStr);
//  end;

  CheckRegistration;

  FProgMode := 0;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
//  FIPCServer := TIPCServer.Create;
//  FIPCServer.OnServerError := OnServerError;
//  FIPCServer.OnClientConnect := OnClientConnect;
//  FIPCServer.OnExecuteRequest := OnExecuteRequest;
//  FIPCServer.OnClientDisconnect := OnClientDisconnect;
//
//  FIPCServer.ServerName := IPC_SERVER_NAME_4_INQMANAGE;
//  FIPCServer.Start;

  (DataFormatAdapter2.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;
  FDBMsgQueue := TOmniMessageQueue.Create(1000);
  FIPCMQFromOL := TOmniMessageQueue.Create(1000);
//  FWorker4OLMsg := TWorker4OLMsg.Create(FDBMsgQueue, FIPCMQFromOL);

  Parallel.TaskConfig.OnMessage(WM_OLMSG_RESULT,DisplayOLMsg2Grid);
  FStopEvent := TEvent.Create;
  UElecDataRecord.InitClient((Application.ExeName));
//  UnitRegistrationRecord.InitClient();
  InitUserClient(Application.ExeName);
  InitClient4GSTariff(Application.ExeName);
  AsynDisplayOLMsg2Grid();
  TDTF.rg_periodClick(nil);
  g_ExecuteFunction := ExecFunc;

  TDTF.LoadConfigFromFile;
end;

procedure TInquiryF.FormDestroy(Sender: TObject);
begin
//  FWorker4OLMsg.Terminate;
//  FWorker4OLMsg.Stop;
//  if Assigned(FRegInfo) then
//    FRegInfo.Free;

  if FIsRunRestServer then
    DestroyHttpServer;

  FStopEvent.SetEvent;
  FDBMsgQueue.Free;
  FIPCMQFromOL.Free;
//  FreeAndNil(FIPCServer);
  FreeAndNil(FStopEvent);
end;

procedure TInquiryF.InitNetwork;
begin
  CreateHttpServer4WS(TDTF.FPortName, TDTF.FTransmissionKey, TServiceIM4WS, [IInqManageService]);
  FIsRunRestServer := True;
  TDTF.StatusBarPro1.Panels[2].Text := 'Port = ' + TDTF.FPortName;
end;

procedure TInquiryF.KeyIn_CompanyCode;
var
  LCode: string;
  LTask: TSQLGSTask;
begin
  LTask := TDTF.GetTask;
  try
    LCode := GetCompanyCode(LTask);
    Key_Input_CompanyCode(LCode);
  finally
    LTask.Free;
  end;
end;

procedure TInquiryF.KeyIn_Content;
var
  LContent: string;
  LTask: TSQLGSTask;
begin
  LTask := TDTF.GetTask;
  try
    LContent := GetQTNContent(LTask);
    QTN_Key_Input_Content(LContent);
  finally
    LTask.Free;
  end;
end;

procedure TInquiryF.KeyIn_RFQ;
var
  LPONo: string;
  LTask: TSQLGSTask;
begin
  LTask := TDTF.GetTask;
  try
    LPONo := UTF8ToString(LTask.PO_No);
    Key_Input_RFQ(LPONo);
  finally
    LTask.Free;
  end;
end;

procedure TInquiryF.N2Click(Sender: TObject);
begin
  TDTF.SetConfig;
end;

//procedure TInquiryF.OnExecuteRequest(const Context: ICommContext; const Request,
//  Response: IMessageData);
//begin
//  Parallel.Async(
//    procedure (const task: IOmniTask)
//    var
//      Command: AnsiString;
//      LocalCount: Integer;
//      LFileName: string;
//      LFileStream: TMemoryStream;
//      LStrList: TStringList;
//      rec    : TOLMsgFileRecord;
//      LOmniValue: TOmniValue;
//    begin
//      LStrList := TStringList.Create;
//      try
//        LStrList.Text := Request.Data.ReadUTF8String(CMD_LIST);
//        Command := LStrList.Values['Command'];
//
//        if Command = CMD_SEND_MAIL_ENTRYID then
//        begin
//          rec.FEntryId := LStrList.Values['EntryId'];
//          rec.FStoreId := LStrList.Values['StoreId'];
//          rec.FSender := LStrList.Values['Sender'];
//          rec.FReceiver := LStrList.Values['Receiver'];
//          rec.FReceiveDate := StrToDateTime(LStrList.Values['RecvDate']);
//          rec.FCarbonCopy := LStrList.Values['CC'];
//          rec.FBlindCC := LStrList.Values['BCC'];
//          rec.FSubject := LStrList.Values['Subject'];
//          LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
//          FIPCMQFromOL.Enqueue(TOmniMessage.Create(1, LOmniValue));
//
//          Response.ID := Format('Response nr. %d', [LocalCount]);
//          Response.Data.WriteDateTime('TDateTime', Now);
//        end
//        else
//        if Command = CMD_SEND_FOLDER_STOREID then
//        begin
//          rec.FEntryId := LStrList.Values['FolderPath'];
//          rec.FSender := LStrList.Values['FolderName'];
//          rec.FStoreId := LStrList.Values['StoreId'];
//          LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
//          FIPCMQFromOL.Enqueue(TOmniMessage.Create(2, LOmniValue));
//        end
//        else
//        if Command = 'SaveFile' then
//        begin
//          LFileName := Request.Data.ReadUnicodeString('FileName');
//          LFileStream := TMemoryStream.Create;
//          try
//            Request.Data.ReadStream('File', LFileStream);
//            LFileStream.SaveToFile('c:\private\'+LFileName);
//          finally
//            LFileStream.Free;
//          end;
//        end;
//      finally
//        LStrList.Free;
//      end;
//    end,
//
//    Parallel.TaskConfig.OnMessage(Self).OnTerminated(
//      procedure
//      begin
//      end
//    )
//  );
//end;

procedure TInquiryF.OnGetStream(
  Sender: TFileContentsStreamOnDemandClipboardFormat; Index: integer;
  out AStream: IStream);
var
//  Data: AnsiString;
//  i: integer;
//  SelIndex: integer;
//  Found: boolean;
  LStream: TStringStream;
//  LStr: string;
begin
  LStream := TStringStream.Create;
  try
//    LStr := Utf8ToString(AnsiToUTF8(FTaskJson));
    LStream.WriteString(FTaskJson);
    AStream := nil;
    AStream := TFixedStreamAdapter.Create(LStream, soOwned);
  except
    raise;
  end;
end;

procedure TInquiryF.ProcessCommand(ARespond: string);
var
  Command: String;
  LocalCount: Integer;
  LFileName: string;
  LFileStream: TMemoryStream;
  LStrList: TStringList;
  rec    : TOLMsgFileRecord;
  LOmniValue: TOmniValue;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Text := ARespond;
    Command := LStrList.Values['Command'];

    if Command = CMD_SEND_MAIL_ENTRYID then
    begin
      rec.FEntryId := LStrList.Values['EntryId'];
      rec.FStoreId := LStrList.Values['StoreId'];
      rec.FSender := LStrList.Values['Sender'];
      rec.FReceiver := LStrList.Values['Receiver'];
      rec.FReceiveDate := StrToDateTime(LStrList.Values['RecvDate']);
      rec.FCarbonCopy := LStrList.Values['CC'];
      rec.FBlindCC := LStrList.Values['BCC'];
      rec.FSubject := LStrList.Values['Subject'];
      rec.FSavedOLFolderPath := LStrList.Values['FolderPath'];
      rec.FUserEMail := LStrList.Values['UserEmail'];
      rec.FUserName := LStrList.Values['UserName'];
      LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
      FIPCMQFromOL.Enqueue(TOmniMessage.Create(1, LOmniValue));
    end
    else
    if Command = CMD_SEND_FOLDER_STOREID then
    begin
      rec.FEntryId := LStrList.Values['FolderPath'];
      rec.FSender := LStrList.Values['FolderName'];
      rec.FStoreId := LStrList.Values['StoreId'];
      LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
      FIPCMQFromOL.Enqueue(TOmniMessage.Create(2, LOmniValue));
    end
    else
    if Command = 'SaveFile' then
    begin
//      LFileName := Request.Data.ReadUnicodeString('FileName');
//      LFileStream := TMemoryStream.Create;
//      try
//        Request.Data.ReadStream('File', LFileStream);
//        LFileStream.SaveToFile('c:\private\'+LFileName);
//      finally
//        LFileStream.Free;
//      end;
    end;
  finally
    LStrList.Free;
  end;
end;

procedure TInquiryF.QUOTATIONINPUT1Click(Sender: TObject);
begin
  QTN_Input;
end;

function TInquiryF.SaveCurrentTask2File(AFileName: string): string;
var
  LTask: TSQLGSTask;
//  LUtf8: RawUTF8;
//  LDynArr: TDynArray;
//  LCount: integer;
//  LCustomer: TSQLCustomer;
//  LSubCon: TSQLSubCon;
//  LMat4Proj: TSQLMaterial4Project;
//  LV,LV2,LV3: variant;
  LFileName, LStr: string;
//    LTaskJson: RawByteString;
//  LGuid: TGuid;
begin
//  if AFileName = '' then
//  begin
//    CreateGUID(LGuid);
//    AFileName := '.\' + GUIDToString(LGuid);
//  end;
  Result := '';
//  TDocVariant.New(LV);

  LTask := TDTF.GetTask;
  try
    if LTask.IsUpdate then
    begin
      FTaskJson := MakeTaskInfoEmailAttached(LTask, LFileName);

//      FTaskJson := UTF8ToAnsi(StringToUTF8(FTaskJson));
//      FTaskJson := SynLZDecompress(FTaskJson);
//      ShowMessage(FTaskJson);
      if AFileName = '' then
      begin
        AFileName := LFileName;
      end;

      Result := AFileName;
    end;
//    TDocVariant.New(LV3);
//    LV3 := _JSON(LUtf8);
//
//    TDocVariant.New(LV2);
//    LV2 := _JSON(LV3.Task);
//    ShowMessage(LV2.ShipName);
//    Memo1.Text := Utf8ToString(LV3.Task);
  finally
    LTask.Free;
  end;
end;

procedure TInquiryF.Select_DeliveryCondition;
var
  LDeliveryCondition: integer;
  LTask: TSQLGSTask;
begin
  LTask := TDTF.GetTask;
  try
    LDeliveryCondition := LTask.DeliveryCondition;
    Sel_DeliveryCondition(LDeliveryCondition);
  finally
    LTask.Free;
  end;
end;

procedure TInquiryF.Select_EstimateType;
var
  LEstimateType: integer;
  LTask: TSQLGSTask;
begin
  LTask := TDTF.GetTask;
  try
    LEstimateType := LTask.EstimateType;
    Sel_EstimateType(LEstimateType);
  finally
    LTask.Free;
  end;
end;

procedure TInquiryF.Select_Money;
var
  LCurrencyKind: integer;
  LTask: TSQLGSTask;
begin
  LTask := TDTF.GetTask;
  try
    LCurrencyKind := LTask.CurrencyKind;
    Sel_CurrencyKind(LCurrencyKind);
  finally
    LTask.Free;
  end;
end;

procedure TInquiryF.Select_TermsOfPayment;
var
  LTermsOfPayment: integer;
  LTask: TSQLGSTask;
begin
  LTask := TDTF.GetTask;
  try
    LTermsOfPayment := LTask.TermsOfPayment;
    Sel_TermsOfPayment(LTermsOfPayment);
  finally
    LTask.Free;
  end;
end;

procedure TInquiryF.SendReqOLEmailInfo;
begin
//  SendReqOLEmailInfo_CromisIPC;
  SendReqOLEmailInfo_WS;
end;

procedure TInquiryF.SendReqOLEmailInfo_CromisIPC;
var
  LStrList: TStringList;
//  Request: IIPCData;
//  Result: IIPCData;
begin
//  if g_IPCClient.IsConnected then
//  begin
//    LStrList := TStringList.Create;
//    try
//      LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK);
//      LStrList.Add('Command='+CMD_REQ_MAILINFO_SEND);
//
//      Request := AcquireIPCData;
//      Request.ID := DateTimeToStr(Now);
//      Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);
////      Result := g_IPCClient.ExecuteRequest(Request);
//      Result := g_IPCClient.ExecuteConnectedRequest(Request);
//
//      if g_IPCClient.AnswerValid then
//      begin
//      end;
//    finally
//      LStrList.Free;
//    end;
//  end
//  else
//  begin
//    ShowMessage('IPC is not connected : ' + IPC_SERVER_NAME_4_INQMANAGE);
////    ShowMessage('Try Again');
//  end;
end;

procedure TInquiryF.SendReqOLEmailInfo_WS;
var
  Client: TSQLHttpClientWebsockets;
  LCommand, LRespond: string;
  Service: IOLMailService;
  callback: IOLMailCallback;
  LStrList: TStringList;
begin
  Client := GetClientWS;
  try
    if not Client.Services.Resolve(IOLMailService,Service) then
      raise EServiceException.Create('Service IOLMailService unavailable');

    callback := TOLMailCallback.Create(Client,IOLMailCallback);
    try
//      Service.Join(workName,callback);
      LStrList := TStringList.Create;
      try
        LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK);
        LStrList.Add('Command='+CMD_REQ_MAILINFO_SEND);
        LCommand := LStrList.Text;
        LRespond := Service.GetOLEmailInfo(LCommand);
        ProcessCommand(LRespond);
      finally
        LStrList.Free;
      end;
    finally
      callback := nil;
      Service := nil; // release the service local instance BEFORE Client.Free
    end;
  finally
    Client.Free;
  end;
end;

function TInquiryF.ServerExecuteFromClient(ACommand: RawUTF8): RawUTF8;
var
  LOmniValue: TOmniValue;
  Command, LJson: String;
  LStrList: TStringList;
  LVarArr: TVariantDynArray;
  LSearchCondRec: TSearchCondRec;
  LTask: TSQLGSTask;
  LVar: Variant;
  i, LTaskId: integer;
  LRaw: RawByteString;
  LUtf8: RawUTF8;
  LFileName: string;
begin
  LJson := MakeBase64ToString(ACommand);
  LStrList := TStringList.Create;
  try
    LStrList.Text := LJson;
    Command := LStrList.Values['Command'];

    if Command = CMD_REQ_TASK_LIST then
    begin
      LJson := LStrList.Values['Parameter'];
      RecordLoadJson(LSearchCondRec, LJson, TypeInfo(TSearchCondRec));
      TDTF.DisplayTaskInfo2Grid(LSearchCondRec, True);
      LJson := TDTF.FTempJsonList.Text;
      System.Delete(LJson, Length(LJson)-1,2);
      Result := StringToUTF8(LJson);
      Result := MakeRawUTF8ToBin64(Result);
    end
    else
    if Command = CMD_REQ_TASK_DETAIL then
    begin
      LJson := LStrList.Values['Parameter'];
      LVar := _JSON(LJson);
      LTask:= CreateOrGetLoadTask(LVar.TaskId);
      Result := MakeTaskDetail2JSON(LTask);
      Result := MakeRawUTF8ToBin64(Result);
    end
    else
    if Command = CMD_REQ_TASK_EAMIL_LIST then
    begin
      LJson := LStrList.Values['Parameter'];
      LTaskId := StrToIntDef(LJson, 0);
      Result := MakeTaskEmailList2JSON(LTaskId);
      Result := MakeRawUTF8ToBin64(Result);
    end
    else
    if Command = CMD_REQ_TASK_EAMIL_CONTENT then
    begin
      LJson := LStrList.Values['Parameter'];
      Result := SendReqOLEmail2MagFile(LJson);  //file path + name이 반환됨
      LFileName := Utf8ToString(Result);

      if FileExists(LFileName) then
      begin
        LRaw := StringFromFile(LFileName);
        Result := MakeRawUTF8ToBin64(LRaw);
        System.SysUtils.DeleteFile(LFileName);
      end;
    end
    else
    if Command = CMD_EXECUTE_SAVE_TASK_DETAIL then
    begin
      LJson := LStrList.Values['Parameter'];
      LVar := _JSON(LJson);
      if SaveTaskInfo2DBFromJson(LVar) then
        Result := 'TRUE'
      else
        Result := 'FALSE';
    end;
  finally
    LStrList.Free;
  end;
end;

function TInquiryF.SessionClosed(Sender: TSQLRestServer; Session: TAuthSession;
  Ctxt: TSQLRestServerURIContext): boolean;
begin

end;

function TInquiryF.SessionCreate(Sender: TSQLRestServer; Session: TAuthSession;
  Ctxt: TSQLRestServerURIContext): boolean;
begin

end;

procedure TInquiryF.TDTFbtn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TInquiryF.TDTFbtn_SearchClick(Sender: TObject);
begin
  TDTF.btn_SearchClick(Sender);
end;

procedure TInquiryF.TDTFComboBox1DropDown(Sender: TObject);
begin
  TDTF.ComboBox1DropDown(Sender);
end;

procedure TInquiryF.TDTFEmailButtonClick(Sender: TObject);
begin
  TDTF.EmailButtonClick(Sender);
end;

procedure TInquiryF.TDTFgrid_ReqCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  TDTF.grid_ReqCellDblClick(Sender, ACol,ARow);
end;

procedure TInquiryF.TDTFgrid_ReqMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LFileName: string;
begin
  if not PtInRect(TDTF.grid_Req.GetRowRect(TDTF.grid_Req.SelectedRow), Point(X,Y)) then
    exit;

  if (DragDetectPlus(TDTF.grid_Req.Handle, Point(X,Y))) then
  begin
    if TDTF.grid_Req.SelectedRow = -1 then
      exit;

    TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).FileNames.Clear;
    LFileName := SaveCurrentTask2File;

    if LFileName <> '' then
      //파일 이름에 공란이 들어가면 OnGetStream 함수를 안 탐
      TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).
            FileNames.Add(LFileName);

    DropEmptySource1.Execute;
  end;
end;

procedure TInquiryF.TDTFJvLabel7Click(Sender: TObject);
//var
//  rec    : TOLMsgFileRecord;
//  LOmniValue: TOmniValue;
begin
//  rec.FEntryId := '999999999999';
//  rec.FStoreId := '444444444444';
//  rec.FSender := 'pjh@Sender.com';
//  rec.FReceiveDate := now-1;
//  rec.FReceiver := 'pjh@Receiver.com';
//  rec.FCarbonCopy := 'pjh@cc.com';
//  rec.FBlindCC := 'pjh@bcc.com';
//  rec.FSubject := 'subject ttttttttttttt';
//
//  LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
//  FIPCMQFromOL.Enqueue(TOmniMessage.Create(1, LOmniValue));
end;

procedure TInquiryF.TDTFJvLabel8Click(Sender: TObject);
begin
  TestRemoteTaskList
end;

procedure TInquiryF.TDTFN16Click(Sender: TObject);
begin
  TDTF.N16Click(Sender);

end;

procedure TInquiryF.TDTFrg_periodClick(Sender: TObject);
begin
  TDTF.rg_periodClick(Sender);
end;

procedure TInquiryF.TDTFShowTaskID1Click(Sender: TObject);
begin
  TDTF.ShowTaskID1Click(Sender);

end;

procedure TInquiryF.TestRemoteTaskDetail;
var
  LUtf8, LResult: RawUTF8;
  LIdList: TIDList;
begin
  LIdList := TIDList(TDTF.grid_Req.Row[TDTF.grid_Req.SelectedRow].Data);
  LUtf8 := ObjectToJson(LIdList);
  LUtf8 := MakeCommand4InqManagerServer(CMD_REQ_TASK_DETAIL, LUtf8);
  LUtf8 := ServerExecuteFromClient(LUtf8);
  LUtf8 := MakeBase64ToUTF8(LUtf8);
  TDTF.ShowTaskFormFromJson(LUtf8);
end;

procedure TInquiryF.TestRemoteTaskEmailList(ATask: TSQLGSTask);
var
  LViewMailListF: TViewMailListF;
  LUtf8: RawUTF8;
begin
  LViewMailListF := TViewMailListF.Create(nil);
  try
    begin
      LViewMailListF.FTask := ATask;
      LUtf8 := IntToStr(ATask.TaskID);
      LUtf8 := MakeCommand4InqManagerServer(CMD_REQ_TASK_EAMIL_LIST, LUtf8);
      LUtf8 := ServerExecuteFromClient(LUtf8);
      LUtf8 := MakeBase64ToUTF8(LUtf8);
      ShowEmailListFromJson(LViewMailListF.grid_Mail, LUtf8);

      if LViewMailListF.ShowModal = mrOK then
      begin
      end;
    end;
  finally
    LViewMailListF.Free;
  end;
end;

procedure TInquiryF.TestRemoteTaskList;
var
  LSearchCondRec: TSearchCondRec;
  LUtf8, LResult: RawUTF8;
begin
  TDTF.GetSearchCondRec(LSearchCondRec);
  LUtf8 := RecordSaveJson(LSearchCondRec, TypeInfo(TSearchCondRec));
  LResult := MakeCommand4InqManagerServer(CMD_REQ_TASK_LIST, LUtf8);
  LResult := ServerExecuteFromClient(LResult);
  LResult := MakeBase64ToUTF8(LResult);
  TDTF.DisplayTaskInfo2GridFromJson(LResult);
end;

procedure TInquiryF.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  if TDTF.FSettings.WSEnabled then
    InitNetwork;
//  TDTF.FUserList.Add(TDTF.GetMyName(g_MyEmailInfo.SmtpAddress)+'='+g_MyEmailInfo.SmtpAddress);
  TDTF.FillInUserList;
  TDTF.PICCB.Items.Assign(TDTF.FUserList);
  TDTF.PICCB.ItemIndex := -1;
end;

procedure TInquiryF.ViewTariff1Click(Sender: TObject);
var
  LDoc: variant;
begin
  LDoc := LoadGSTariff2VariantFromCompanyCodeNYear('0001056374', YearOf(now));
  //LDoc: [] 배열 형식임
  DisplayTariff(LDoc);
end;

{ TWorker4OLMsg }

constructor TWorker4OLMsg.Create(DBMsgQueue, IPCQueue: TOmniMessageQueue);
begin
  inherited Create;

  FreeOnTerminate := True;
  FDBMsgQueue := DBMsgQueue;
  FIPCMQFromOL:= IPCQueue;
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
//  LOmniValue: TOmniValue;
begin
//  handles[0] := FStopEvent.Handle;
//  handles[1] := FIPCMQFromOL.GetNewMessageEvent;
//
//  while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
//  begin
//    if terminated then
//      break;
//
//    while FIPCMQFromOL.TryDequeue(msg) do
//    begin
//      rec := msg.MsgData.ToRecord<TOLMsgFileRecord>;
////      LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
//      Parallel.Async(
//        procedure (const task: IOmniTask)
//        begin
//          ShowMessage(rec.FSubject);
////          task.Comm.Send(WM_OLMSG_RESULT, msg.MsgData);
//        end);
//    end;
//  end;
end;

procedure TWorker4OLMsg.Stop;
begin
  FStopEvent.SetEvent;
end;

{ TOLMailCallback }

procedure TOLMailCallback.ClientExecute(const command, msg: string);
begin

end;

{ TServiceIM4WS }

procedure TServiceIM4WS.CallbackReleased(const callback: IInvokable;
  const interfaceName: RawUTF8);
begin

end;

constructor TServiceIM4WS.Create;
begin
  FClientInfoList :=  TStringList.Create;
end;

destructor TServiceIM4WS.Destroy;
var
  i: integer;
begin
//  for i := 0 to FClientInfoList.Count - 1 do
//    TClientInfo(FClientInfoList.Objects[i]).Free;

  FClientInfoList.Free;

  inherited;
end;

procedure TServiceIM4WS.Join(const pseudo: string;
  const callback: IInqManageCallback);
begin

end;

function TServiceIM4WS.ServerExecute(const Acommand: RawUTF8): RawUTF8;
begin
  Result := InquiryF.ServerExecuteFromClient(ACommand);
end;

end.

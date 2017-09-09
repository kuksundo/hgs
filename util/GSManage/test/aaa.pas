unit FrmInqManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, AdvOfficeTabSet,
  Vcl.StdCtrls, Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons, AeroButtons,
  JvExControls, JvLabel, CurvyControls, Vcl.ImgList, System.SyncObjs,
  OtlCommon, OtlComm, OtlTaskControl, OtlContainerObserver, otlTask,
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  CommonData, TaskForm, UElecDataRecord,
  mORMot, SynCommons, SynSqlite3Static, VarRecUtils,
  FrameDisplayTaskInfo, DragDrop, DropTarget, Vcl.Menus;

const
  WM_OLMSG_RESULT = WM_USER + 1;

type
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

  TInquiryF = class(TForm)
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterOutlook: TDataFormatAdapter;
    TDTF: TDisplayTaskF;
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
  private
    FIPCServer: TIPCServer;
    FStopEvent    : TEvent;
    FDBMsgQueue: TOmniMessageQueue;
    FIPCMQFromOL: TOmniMessageQueue;
    FWorker4OLMsg: TWorker4OLMsg;

    procedure OnClientConnect(const Context: ICommContext);
    procedure OnClientDisconnect(const Context: ICommContext);
    procedure OnServerError(const Context: ICommContext; const Error: TServerError);
    procedure OnExecuteRequest(const Context: ICommContext; const Request, Response: IMessageData);
    procedure DisplayOLMsg2Grid(const task: IOmniTaskControl; const msg: TOmniMessage);

  public
    //Main or 단순 조회: Main := 0, 단순 조회 := 1
    FProgMode: integer;

    procedure AsynDisplayOLMsg2Grid;//(AStopEvent: TEvent; AIPCMQFromOL: TOmniMessageQueue);
    procedure SendReqOLEmailInfo;
  end;

var
  InquiryF: TInquiryF;

implementation

Uses System.DateUtils, OtlParallel,
  DragDropFile,
  DragDropInternet;

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
//      LOmniValue: TOmniValue;
      LID: TID;
      LTaskIds: TIDDynArray;
      LIsAddTask: Boolean;//True=신규 Task 등록
    begin
      handles[0] := FStopEvent.Handle;
      handles[1] := FIPCMQFromOL.GetNewMessageEvent;
      LEmailMsg := TSQLEmailMsg.Create;
      LTask := TSQLGSTask.Create;

      while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
      begin
        while FIPCMQFromOL.TryDequeue(msg) do
        begin
          rec := msg.MsgData.ToRecord<TOLMsgFileRecord>;

          if msg.MsgID = 1 then
          begin
            if (rec.FEntryID <> '') and (rec.FStoreID <> '') then
            begin
              LEmailMsg := TSQLEmailMsg.Create(g_ProjectDB,
                'EntryID = ? AND StoreID = ?', [rec.FEntryID,rec.FStoreID]);

              //데이터가 없으면
              if LEmailMsg.ID = 0 then
              begin
                LEmailMsg.Sender := rec.FSender;
                LEmailMsg.Receiver := rec.FReceiver;
                LEmailMsg.CarbonCopy := rec.FCarbonCopy;
                LEmailMsg.BlindCC := rec.FBlindCC;
                LEmailMsg.EntryID := rec.FEntryId;
                LEmailMsg.StoreID := rec.FStoreId;
                LEmailMsg.Subject := rec.FSubject;
                LEmailMsg.RecvDate := TimeLogFromDateTime(rec.FReceiveDate);

                LEmailMsg2 := TSQLEmailMsg.Create(g_ProjectDB,
                  'Subject = ?', [rec.FSubject]);

                if LEmailMsg2.ID <> 0 then //동일한 제목의 메일이 존재하면
                begin
                  LIsAddTask := False;
                  LTask.EmailMsg.SourceGet(g_ProjectDB, LEmailMsg2.ID, LTaskIds);

                  try
                    for i:= low(LTaskIds) to high(LTaskIds) do
                    begin
                      LTask2 := TDTF.CreateOrGetLoadTask(LTaskIds[i]);
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
                  LIsAddTask := True;
                  LTask.InqRecvDate := TimeLogFromDateTime(rec.FReceiveDate);
                  TDTF.DisplayTaskInfo2EditForm(LTask, LEmailMsg);
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

            TDTF.AddFolderListFromOL(rec.FEntryId + '=' + rec.FStoreId);
          end;

          task.Invoke(
            procedure
            begin
              //동일한 제목의 메일이 존재하지 않으면 Grid에 추가
              if LIsAddTask then
              begin
                if Assigned(LTask) then
                  TDTF.LoadTaskVar2Grid(LTask, TDTF.grid_Req);
//                i := TDTF.grid_Req.AddRow;
//                TDTF.grid_Req.CellByName['Subject',i].AsString := rec.FSubject;
//                TDTF.grid_Req.Row[i].Data := TIDList.Create;
//                TIDList(TDTF.grid_Req.Row[i].Data).EmailId := LID;
//                TIDList(TDTF.grid_Req.Row[i].Data).TaskId := LTask.ID;
              end
            end
          );
        end;//while
      end;//while
    end,

    Parallel.TaskConfig.OnMessage(Self).OnTerminated(
      procedure
      begin
        FreeAndNil(LEmailMsg);
        FreeAndNil(LTask);
      end
    )
  );
end;

procedure TInquiryF.btn_CloseClick(Sender: TObject);
begin
  Close;
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
begin
  // Check if we have a data format and if so...
  if (DataFormatAdapterOutlook.DataFormat <> nil) then
  begin
    SendReqOLEmailInfo;
//    ShowMessage('Outlook Mail Dropped');
  end;
end;

procedure TInquiryF.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  for i := 0 to TDTF.grid_Req.RowCount - 1 do
    TIDList(TDTF.grid_Req.Row[i].Data).Free;

  FStopEvent.SetEvent;
  FIPCServer.Stop;
  g_IPCClient.DisconnectClient;
end;

procedure TInquiryF.FormCreate(Sender: TObject);
begin
  FProgMode := 0;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  FIPCServer := TIPCServer.Create;
  FIPCServer.OnServerError := OnServerError;
  FIPCServer.OnClientConnect := OnClientConnect;
  FIPCServer.OnExecuteRequest := OnExecuteRequest;
  FIPCServer.OnClientDisconnect := OnClientDisconnect;

  FIPCServer.ServerName := IPC_SERVER_NAME_4_INQMANAGE;
  FIPCServer.Start;

  FDBMsgQueue := TOmniMessageQueue.Create(1000);
  FIPCMQFromOL := TOmniMessageQueue.Create(1000);
//  FWorker4OLMsg := TWorker4OLMsg.Create(FDBMsgQueue, FIPCMQFromOL);

  Parallel.TaskConfig.OnMessage(WM_OLMSG_RESULT,DisplayOLMsg2Grid);
  FStopEvent := TEvent.Create;
  InitClient();
  AsynDisplayOLMsg2Grid();
  TDTF.rg_periodClick(nil);
end;

procedure TInquiryF.FormDestroy(Sender: TObject);
begin
//  FWorker4OLMsg.Terminate;
//  FWorker4OLMsg.Stop;
  FStopEvent.SetEvent;
  FDBMsgQueue.Free;
  FIPCMQFromOL.Free;
  FreeAndNil(FIPCServer);
  FreeAndNil(FStopEvent);
end;

procedure TInquiryF.OnClientConnect(const Context: ICommContext);
begin

end;

procedure TInquiryF.OnClientDisconnect(const Context: ICommContext);
begin

end;

procedure TInquiryF.OnExecuteRequest(const Context: ICommContext; const Request,
  Response: IMessageData);
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      Command: AnsiString;
      LocalCount: Integer;
      LFileName: string;
      LFileStream: TMemoryStream;
      LStrList: TStringList;
      rec    : TOLMsgFileRecord;
      LOmniValue: TOmniValue;
    begin
      LStrList := TStringList.Create;
      try
        LStrList.Text := Request.Data.ReadUTF8String(CMD_LIST);
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
          LOmniValue := TOmniValue.FromRecord<TOLMsgFileRecord>(rec);
          FIPCMQFromOL.Enqueue(TOmniMessage.Create(1, LOmniValue));

          Response.ID := Format('Response nr. %d', [LocalCount]);
          Response.Data.WriteDateTime('TDateTime', Now);
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
          LFileName := Request.Data.ReadUnicodeString('FileName');
          LFileStream := TMemoryStream.Create;
          try
            Request.Data.ReadStream('File', LFileStream);
            LFileStream.SaveToFile('c:\private\'+LFileName);
          finally
            LFileStream.Free;
          end;
        end;
      finally
        LStrList.Free;
      end;
    end,

    Parallel.TaskConfig.OnMessage(Self).OnTerminated(
      procedure
      begin
      end
    )
  );
end;

procedure TInquiryF.OnServerError(const Context: ICommContext;
  const Error: TServerError);
begin

end;

procedure TInquiryF.SendReqOLEmailInfo;
var
  LStrList: TStringList;
  Request: IIPCData;
  Result: IIPCData;
begin
  if g_IPCClient.IsConnected then
  begin
    LStrList := TStringList.Create;
    try
      LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK);
      LStrList.Add('Command='+CMD_REQ_MAILINFO_SEND);

      Request := AcquireIPCData;
      Request.ID := DateTimeToStr(Now);
      Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);
      Result := g_IPCClient.ExecuteRequest(Request);

      if g_IPCClient.AnswerValid then
      begin
      end;
    finally
      LStrList.Free;
    end;
  end
  else
  begin
    ShowMessage('IPC is not connected : ' + IPC_SERVER_NAME_4_INQMANAGE);
    g_IPCClient.ConnectClient;
    ShowMessage('Try Again');
  end;
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

procedure TInquiryF.TDTFrg_periodClick(Sender: TObject);
begin
  TDTF.rg_periodClick(Sender);
end;

procedure TInquiryF.TDTFShowTaskID1Click(Sender: TObject);
begin
  TDTF.ShowTaskID1Click(Sender);

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

end.

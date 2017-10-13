unit UnitIPCModule;

interface

uses System.Classes, Dialogs, System.Rtti,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  CommonData, SynCommons, mORMot, DateUtils, System.SysUtils, UElecDataRecord,
  mORMotHttpClient, MailCallbackInterface, Winapi.ActiveX;

//AMailType = 1: invoice 송부, 2: 매출처리요청, 3: 직투입요청
//            4: 해외 매출 고객사 등록 요청, 5: 전전 비표준공사 생성 요청
//            6: PO 요청 메일, 7: 출하지시 요청
procedure SendCmd2IPC4ReplyMail(AEntryId, AStoreId: string; AMailType: integer; ATask: TSQLGSTask);
procedure SendCmd2IPC4CreateMail(AGrid: TNextGrid; ARow, AMailType: integer; ATask: TSQLGSTask);
procedure SendCmd2IPC4ViewEmail(AGrid: TNextGrid; ARow: integer);
function SendCmd2IPC4MoveFolderEmail(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath: string; ATask: TSQLGSTask): boolean;
function SendReqOLEmailInfo2(AGrid: TNextGrid; ATask: TSQLGSTask; var AResultList: TStringList): boolean;

procedure SendCmd2IPC4ReplyMail_CromisIPC(AGrid: TNextGrid; ARow, AMailType: integer; ATask: TSQLGSTask);
procedure SendCmd2IPC4CreateMail_CromisIPC(AGrid: TNextGrid; ARow, AMailType: integer; ATask: TSQLGSTask);
procedure SendCmd2IPC4ViewEmail_CromisIPC(AGrid: TNextGrid; ARow: integer);
function SendCmd2IPC4MoveFolderEmail_CromisIPC(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath: string; ATask: TSQLGSTask): boolean;
function SendReqOLEmailInfo2_CromisIPC(AGrid: TNextGrid; ATask: TSQLGSTask; var AResultList: TStringList): boolean;

procedure SendCmd2IPC4ReplyMail_WS(AEntryId, AStoreId: string; AMailType: integer; ATask: TSQLGSTask);
procedure SendCmd2IPC4CreateMail_WS(AGrid: TNextGrid; ARow, AMailType: integer; ATask: TSQLGSTask);
procedure SendCmd2IPC4ViewEmail_WS(AGrid: TNextGrid; ARow: integer);
function SendCmd2IPC4MoveFolderEmail_WS(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath: string; ATask: TSQLGSTask): boolean;
function SendReqOLEmailInfo2_WS(AGrid: TNextGrid; ATask: TSQLGSTask; var AResultList: TStringList): boolean;
function SendReqAddAppointment_WS(AJsonpjhTodoItem: string): boolean;

function GetClientWS: TSQLHttpClientWebsockets;

function ProcessTaskJson(AJson: String): Boolean;

procedure ShowEmailListFromIDs(AGrid: TNextGrid; AIDs: TIDDynArray);

implementation

uses UnitMakeReport, SynMustache, UnitStringUtil, TaskForm, UnitVariantJsonUtil;

procedure SendCmd2IPC4ReplyMail(AEntryId, AStoreId: string; AMailType: integer; ATask: TSQLGSTask);
begin
//  SendCmd2IPC4ReplyMail_CromisIPC(AGrid, ARow, AMailType,ATask);
  SendCmd2IPC4ReplyMail_WS(AEntryId, AStoreId, AMailType, ATask);
end;

procedure SendCmd2IPC4ViewEmail(AGrid: TNextGrid; ARow: integer);
begin
//  SendCmd2IPC4ViewEmail_CromisIPC(AGrid, ARow);
  SendCmd2IPC4ViewEmail_WS(AGrid, ARow);
end;

procedure SendCmd2IPC4CreateMail(AGrid: TNextGrid; ARow, AMailType: integer;ATask: TSQLGSTask);
begin
//  SendCmd2IPC4CreateMail_CromisIPC(AGrid, ARow, AMailType, ATask);
  SendCmd2IPC4CreateMail_WS(AGrid, ARow, AMailType, ATask);
end;

function SendCmd2IPC4MoveFolderEmail(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath: string; ATask: TSQLGSTask): boolean;
begin
//  SendCmd2IPC4MoveFolderEmail_CromisIPC(AOriginalEntryId, AOriginalStoreId,
//    AMoveStoreId, AMoveStorePath, ATask);
  Result := SendCmd2IPC4MoveFolderEmail_WS(AOriginalEntryId, AOriginalStoreId,
    AMoveStoreId, AMoveStorePath, ATask);
end;

function SendReqOLEmailInfo2(AGrid: TNextGrid; ATask: TSQLGSTask; var AResultList: TStringList): boolean;
begin
//  SendReqOLEmailInfo2_CromisIPC(AGrid, ATask, AResultList);
  Result := SendReqOLEmailInfo2_WS(AGrid, ATask, AResultList);
end;

procedure SendCmd2IPC4ReplyMail_CromisIPC(AGrid: TNextGrid; ARow, AMailType: integer; ATask: TSQLGSTask);
var
  Request: IIPCData;
  Result: IIPCData;
  LStrList: TStringList;
  LEntryId, LStoreId: string;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK);
    LStrList.Add('Command='+CMD_REQ_REPLY_MAIL);
    LEntryId := AGrid.CellByName['EntryId', ARow].AsString;
    LStoreId := AGrid.CellByName['StoreId', ARow].AsString;
    LStrList.Add('EntryId='+LEntryId);
    LStrList.Add('StoreId='+LStoreId);
    LStrList.Add('HTMLBody='+MakeEmailHTMLBody(ATask, AMailType));

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);

    Result := g_IPCClient.ExecuteConnectedRequest(Request);

    if g_IPCClient.AnswerValid then
    begin
//      ShowMessage(LEntryId + '=' + LStoreId);
//      ShowMessage('IPCClient.AnswerValid');
    end;
  finally
    LStrList.Free;
  end;
end;

procedure SendCmd2IPC4CreateMail_CromisIPC(AGrid: TNextGrid; ARow, AMailType: integer; ATask: TSQLGSTask);
var
  Request: IIPCData;
  Result: IIPCData;
  LStrList: TStringList;
  LEntryId, LStoreId: string;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_CREATE_MAIL);
    LEntryId := AGrid.CellByName['EntryId', ARow].AsString;
    LStoreId := AGrid.CellByName['StoreId', ARow].AsString;
    LStrList.Add('EntryId='+LEntryId);
    LStrList.Add('StoreId='+LStoreId);
    LStrList.Add('Subject='+MakeMailSubject(ATask, AMailType));
    LStrList.Add('To='+GetRecvEmailAddress(AMailType));
    LStrList.Add('HTMLBody='+MakeEmailHTMLBody(ATask,AMailType));

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);

    Result := g_IPCClient.ExecuteConnectedRequest(Request);

    if g_IPCClient.AnswerValid then
    begin
//      ShowMessage(LEntryId + '=' + LStoreId);
//      ShowMessage('IPCClient.AnswerValid');
    end;
  finally
    LStrList.Free;
  end;
end;

procedure SendCmd2IPC4ViewEmail_CromisIPC(AGrid: TNextGrid; ARow: integer);
var
  Request: IIPCData;
  Result: IIPCData;
  LStrList: TStringList;
  LEntryId, LStoreId: string;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK);
    LStrList.Add('Command='+CMD_REQ_MAIL_VIEW);
    LEntryId := AGrid.CellByName['EntryId', ARow].AsString;
    LStoreId := AGrid.CellByName['StoreId', ARow].AsString;
    LStrList.Add('EntryId='+LEntryId);
    LStrList.Add('StoreId='+LStoreId);

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);

    Result := g_IPCClient.ExecuteConnectedRequest(Request);

    if g_IPCClient.AnswerValid then
    begin
//      ShowMessage(LEntryId + '=' + LStoreId);
//      ShowMessage('IPCClient.AnswerValid');
    end;
  finally
    LStrList.Free;
  end;
end;

function SendCmd2IPC4MoveFolderEmail_CromisIPC(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath: string; ATask: TSQLGSTask): boolean;
var
  IPCClient: TIPCClient;
  Request: IIPCData;
  LIPCResult: IIPCData;
  LStrList: TStringList;
  LEntryId, LStoreId: string;
  Command: AnsiString;
  LEmailMsg: TSQLEmailMsg;
  LIds: TIDDynArray;
begin
  LStrList := TStringList.Create;
  IPCClient := TIPCClient.Create;
  try
    IPCClient.ServerName := IPC_SERVER_NAME_4_OUTLOOK2;
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_MOVE_FOLDER_MAIL);
//    LEntryId := AGrid.CellByName['EntryId', ARow].AsString;
//    LStoreId := AGrid.CellByName['StoreId', ARow].AsString;
    LEntryId := AOriginalEntryId;
    LStoreId := AOriginalStoreId;
    LStrList.Add('EntryId='+LEntryId);
    LStrList.Add('StoreId='+LStoreId);
    LStrList.Add('MoveStoreId='+AMoveStoreId);//AFolderList.ValueFromIndex[AFolderIndex]);
    LStrList.Add('MoveStorePath='+AMoveStorePath);//AFolderList.Names[AFolderIndex]);

    if Assigned(ATask) then
      LStrList.Add('HullNo='+ATask.HullNo);

    LStrList.Add('IsCreateHullNoFolder='+'True');

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);
    LIPCResult := IPCClient.ExecuteRequest(Request);

    if IPCClient.AnswerValid then
    begin
      LStrList.Clear;
      LStrList.Text := LIPCResult.Data.ReadUTF8String(CMD_LIST);
      Command := LStrList.Values['Command'];

      if Command = CMD_RESPONDE_MOVE_FOLDER_MAIL then
      begin
        LEmailMsg := TSQLEmailMsg.CreateAndFillPrepare(g_ProjectDB,
            'EntryID = ? AND StoreID = ?', [LEntryId,LStoreId]);

        try
          if LEmailMsg.FillOne then
          begin
            LEmailMsg.EntryID := LStrList.Values['NewEntryId'];
            LEmailMsg.StoreID := LStrList.Values['MovedStoreId'];
            g_ProjectDB.Update(LEmailMsg);
            Result := True;
//            if not AIsMultiDrop then
//              ShowMessage('Email move to folder( ' + AMoveStorePath + ' ) completed!');
//            ATask.EmailMsg.DestGet(g_ProjectDB, ATask.ID, LIds);
//            ShowEmailListFromIDs(AGrid, LIds, ATask, AMoveStoreId, AMoveStorePath);
          end;
        finally
          FreeAndNil(LEmailMsg);
        end;
      end;
    end;
  finally
    IPCClient.Free;
    LStrList.Free;
  end;
end;

function SendReqOLEmailInfo2_CromisIPC(AGrid: TNextGrid; ATask: TSQLGSTask; var AResultList: TStringList): boolean;
var
  IPCClient: TIPCClient;
  LStrList: TStringList;
  Request: IIPCData;
  IPCResult: IIPCData;
  Command: AnsiString;
  LEmailMsg,
  LEmailMsg2: TSQLEmailMsg;
  LTask: TSQLGSTask;
  LJson: string;
  LVarArr: TVariantDynArray;
  i: integer;
begin
  IPCClient := TIPCClient.Create;
  LStrList := TStringList.Create;
  LEmailMsg := TSQLEmailMsg.Create;
  try
    IPCClient.ServerName := IPC_SERVER_NAME_4_OUTLOOK2;
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_MAILINFO_SEND2);

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);
//    IPCResult := IPCClient.ExecuteConnectedRequest(Request);
    IPCResult := IPCClient.ExecuteRequest(Request);

    if IPCClient.AnswerValid then
    begin
      LStrList.Clear;
      LStrList.Text := IPCResult.Data.ReadUTF8String(CMD_LIST);
      Command := LStrList.Values['Command'];

      if Command = CMD_SEND_MAIL_ENTRYID2 then
      begin
        LJson := LStrList.Values['MailInfos'];
//        ShowMessage(LJson);
        LVarArr := JSONToVariantDynArray(LJson);

        for i := 0 to High(LVarArr) do
        begin
//          ShowMessage(LVarArr[i].EntryId);
          LEmailMsg.EntryID := LVarArr[i].EntryId;
          LEmailMsg.StoreID := LVarArr[i].StoreId;

          if (LEmailMsg.EntryID <> '') and (LEmailMsg.StoreID <> '') then
          begin
            LEmailMsg2 := TSQLEmailMsg.Create(g_ProjectDB,
              'EntryID = ? AND StoreID = ?', [LEmailMsg.EntryID,LEmailMsg.StoreID]);

            try
              //데이터가 없으면
  //            if LEmailMsg.ID = 0 then
              if not LEmailMsg2.FillOne then
              begin
                LEmailMsg2.EntryID := LVarArr[i].EntryId;
                LEmailMsg2.StoreID := LVarArr[i].StoreId;
                LEmailMsg2.Sender := LVarArr[i].Sender;
                LEmailMsg2.Receiver := LVarArr[i].Receiver;
                LEmailMsg2.CarbonCopy := LVarArr[i].CC;
                LEmailMsg2.BlindCC := LVarArr[i].BCC;
                LEmailMsg2.Subject := LVarArr[i].Subject;
                LEmailMsg2.RecvDate := TimeLogFromDateTime(StrToDateTime(LVarArr[i].RecvDate));

                g_ProjectDB.Add(LEmailMsg2, true);
                ATask.EmailMsg.ManyAdd(g_ProjectDB, ATask.ID, LEMailMsg2.ID, True);
                AResultList.Add(LEmailMsg2.EntryID + '=' + LEmailMsg2.StoreID);
                Result := True;
              end;
            finally
              FreeAndNil(LEmailMsg2);
            end;
          end;
        end;//for
      end;
    end;
  finally
    FreeAndNil(LEmailMsg);
    LStrList.Free;
    IPCClient.DisconnectClient;
    IPCClient.Free;
  end;
end;

procedure SendCmd2IPC4ReplyMail_WS(AEntryId, AStoreId: string; AMailType: integer; ATask: TSQLGSTask);
var
  Client: TSQLHttpClientWebsockets;
  Service: IOLMailService;
  LStrList: TStringList;
  LCommand, LRespond, LFileName: string;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK);
    LStrList.Add('Command='+CMD_REQ_REPLY_MAIL);
    LStrList.Add('EntryId='+AEntryId);
    LStrList.Add('StoreId='+AStoreId);
    LStrList.Add('TaskInfoAttached='+MakeTaskInfoEmailAttached(ATask, LFileName));
    LStrList.Add('AttachedFileName='+'.\'+LFileName);
    LStrList.Add('HTMLBody='+MakeEmailHTMLBody(ATask, AMailType));
    LCommand := LStrList.Text;
    Client := GetClientWS;
    try
      if not Client.Services.Resolve(IOLMailService,Service) then
        raise EServiceException.Create('Service IOLMailService unavailable');

      LRespond := Service.GetOLEmailInfo(LCommand);
    finally
      Service := nil;
      Client.Free;
    end;
  finally
    LStrList.Free;
  end;
end;

procedure SendCmd2IPC4CreateMail_WS(AGrid: TNextGrid; ARow, AMailType: integer; ATask: TSQLGSTask);
var
  Client: TSQLHttpClientWebsockets;
  Service: IOLMailService;
  LStrList: TStringList;
  LEntryId, LStoreId: string;
  LCommand, LRespond: string;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_CREATE_MAIL);

    if Assigned(AGrid) then
    begin
      LEntryId := AGrid.CellByName['EntryId', ARow].AsString;
      LStoreId := AGrid.CellByName['StoreId', ARow].AsString;
      LStrList.Add('EntryId='+LEntryId);
      LStrList.Add('StoreId='+LStoreId);
    end;

    LStrList.Add('Subject='+MakeMailSubject(ATask, AMailType));
    LStrList.Add('To='+GetRecvEmailAddress(AMailType));
    LStrList.Add('HTMLBody='+MakeEmailHTMLBody(ATask,AMailType));
    LCommand := LStrList.Text;

    Client := GetClientWS;
    try
      if not Client.Services.Resolve(IOLMailService,Service) then
        raise EServiceException.Create('Service IOLMailService unavailable');

      LRespond := Service.GetOLEmailInfo(LCommand);
    finally
      Service := nil;
      Client.Free;
    end;
  finally
    LStrList.Free;
  end;
end;

procedure SendCmd2IPC4ViewEmail_WS(AGrid: TNextGrid; ARow: integer);
var
  Client: TSQLHttpClientWebsockets;
  Service: IOLMailService;
  LStrList: TStringList;
  LEntryId, LStoreId: string;
  LCommand, LRespond: string;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK);
    LStrList.Add('Command='+CMD_REQ_MAIL_VIEW);
    LEntryId := AGrid.CellByName['EntryId', ARow].AsString;
    LStoreId := AGrid.CellByName['StoreId', ARow].AsString;
    LStrList.Add('EntryId='+LEntryId);
    LStrList.Add('StoreId='+LStoreId);
    LCommand := LStrList.Text;

    Client := GetClientWS;
    try
      if not Client.Services.Resolve(IOLMailService,Service) then
        raise EServiceException.Create('Service IOLMailService unavailable');

      LRespond := Service.GetOLEmailInfo(LCommand);
    finally
      Service := nil;
      FreeAndNil(Client);
    end;
  finally
    LStrList.Free;
  end;
end;

function SendCmd2IPC4MoveFolderEmail_WS(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath: string; ATask: TSQLGSTask): boolean;
var
  Client: TSQLHttpClientWebsockets;
  Service: IOLMailService;
  LStrList: TStringList;
  LEntryId, LStoreId: string;
  LEmailMsg: TSQLEmailMsg;
  LCommand, LRespond: string;
  LIds: TIDDynArray;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_MOVE_FOLDER_MAIL);
    LEntryId := AOriginalEntryId;
    LStoreId := AOriginalStoreId;
    LStrList.Add('EntryId='+LEntryId);
    LStrList.Add('StoreId='+LStoreId);
    LStrList.Add('MoveStoreId='+AMoveStoreId);//AFolderList.ValueFromIndex[AFolderIndex]);
    LStrList.Add('MoveStorePath='+AMoveStorePath);//AFolderList.Names[AFolderIndex]);

    if Assigned(ATask) then
      LStrList.Add('HullNo='+ATask.HullNo);

    LStrList.Add('IsCreateHullNoFolder='+'True');
    LCommand := LStrList.Text;

    Client := GetClientWS;
    try
      if not Client.Services.Resolve(IOLMailService,Service) then
        raise EServiceException.Create('Service IOLMailService unavailable');

      LRespond := Service.ServerExecute(LCommand);
    finally
      Service := nil;
      Client.Free;
    end;

    if LRespond <> '' then
    begin
      LStrList.Clear;
      LStrList.Text := LRespond;
      LCommand := LStrList.Values['Command'];

      if LCommand = CMD_RESPONDE_MOVE_FOLDER_MAIL then
      begin
        LEmailMsg := TSQLEmailMsg.CreateAndFillPrepare(g_ProjectDB,
            'EntryID = ? AND StoreID = ?', [LEntryId,LStoreId]);

        try
          if LEmailMsg.FillOne then
          begin
            LEmailMsg.EntryID := LStrList.Values['NewEntryId'];
            LEmailMsg.StoreID := LStrList.Values['MovedStoreId'];
            g_ProjectDB.Update(LEmailMsg);
            Result := True;
          end;
        finally
          FreeAndNil(LEmailMsg);
        end;
      end;
    end;
  finally
    LStrList.Free;
  end;
end;

function SendReqOLEmailInfo2_WS(AGrid: TNextGrid; ATask: TSQLGSTask; var AResultList: TStringList): boolean;
var
  Client: TSQLHttpClientWebsockets;
  Service: IOLMailService;
  LStrList: TStringList;
  LCommand, LRespond: String;
  LEmailMsg,
  LEmailMsg2: TSQLEmailMsg;
  LTask: TSQLGSTask;
  LJson: string;
  LVarArr: TVariantDynArray;
  i: integer;
begin
  LStrList := TStringList.Create;
  LEmailMsg := TSQLEmailMsg.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_MAILINFO_SEND2);
    LCommand := LStrList.Text;

    Client := GetClientWS;
    try
      if not Client.Services.Resolve(IOLMailService,Service) then
        raise EServiceException.Create('Service IOLMailService unavailable');

      LRespond := Service.ServerExecute(LCommand);
    finally
      Service := nil;
      Client.Free;
    end;


    if LRespond <> '' then
    begin
      LStrList.Clear;
      LStrList.Text := LRespond;
      LCommand := LStrList.Values['Command'];

      if LCommand = CMD_SEND_MAIL_ENTRYID2 then
      begin
        LJson := LStrList.Values['MailInfos'];
        LVarArr := JSONToVariantDynArray(LJson);

        for i := 0 to High(LVarArr) do
        begin
          LEmailMsg.EntryID := LVarArr[i].EntryId;
          LEmailMsg.StoreID := LVarArr[i].StoreId;

          if (LEmailMsg.EntryID <> '') and (LEmailMsg.StoreID <> '') then
          begin
            LEmailMsg2 := TSQLEmailMsg.Create(g_ProjectDB,
              'EntryID = ? AND StoreID = ?', [LEmailMsg.EntryID,LEmailMsg.StoreID]);

            try
              //데이터가 없으면
  //            if LEmailMsg.ID = 0 then
              if not LEmailMsg2.FillOne then
              begin
                LEmailMsg2.EntryID := LVarArr[i].EntryId;
                LEmailMsg2.StoreID := LVarArr[i].StoreId;
                LEmailMsg2.Sender := LVarArr[i].Sender;
                LEmailMsg2.Receiver := LVarArr[i].Receiver;
                LEmailMsg2.CarbonCopy := LVarArr[i].CC;
                LEmailMsg2.BlindCC := LVarArr[i].BCC;
                LEmailMsg2.Subject := LVarArr[i].Subject;
                LEmailMsg2.RecvDate := TimeLogFromDateTime(StrToDateTime(LVarArr[i].RecvDate));

                g_ProjectDB.Add(LEmailMsg2, true);
                ATask.EmailMsg.ManyAdd(g_ProjectDB, ATask.ID, LEMailMsg2.ID, True);
                AResultList.Add(LEmailMsg2.EntryID + '=' + LEmailMsg2.StoreID);
                Result := True;
              end;
            finally
              FreeAndNil(LEmailMsg2);
            end;
          end;
        end;//for
      end;
    end;
  finally
    FreeAndNil(LEmailMsg);
    LStrList.Free;
  end;
end;

function SendReqAddAppointment_WS(AJsonpjhTodoItem: string): boolean;
var
  Client: TSQLHttpClientWebsockets;
  Service: IOLMailService;
  LCommand, LRespond: String;
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_ADD_APPOINTMENT);
    LStrList.Add('TodoItemsJson='+AJsonpjhTodoItem);
    LCommand := LStrList.Text;

    Client := GetClientWS;
    try
      if not Client.Services.Resolve(IOLMailService,Service) then
        raise EServiceException.Create('Service IOLMailService unavailable');

      LRespond := Service.ServerExecute(LCommand);
    finally
      Service := nil;
      Client.Free;
    end;
  finally
    LStrList.Free;
  end;
end;

function GetClientWS: TSQLHttpClientWebsockets;
begin
  Result := TSQLHttpClientWebsockets.Create('127.0.0.1',OL_PORT_NAME_4_WS,TSQLModel.Create([]));
  Result.Model.Owner := Result;
  Result.WebSocketsUpgrade(OL4WS_TRANSMISSION_KEY);

  if not Result.ServerTimeStampSynchronize then
    raise EServiceException.Create(
      'Error connecting to the server: please run InqManage.exe');
  Result.ServiceDefine([IOLMailService], sicShared);//sicClientDriven
end;

function ProcessTaskJson(AJson: String): Boolean;
var
  LDoc: variant;
  LTask: TSQLGSTask;
  LUTF8: RawUTF8;
  LRaw: RawByteString;
begin
  TDocVariant.New(LDoc);
  LRaw := Base64ToBin(StringToUTF8(AJson));
  LRaw := SynLZDecompress(LRaw);
  LUTF8 := LRaw;
  LDoc := _JSON(LUTF8);
  Result := LDoc.TaskJsonDragSign = TASK_JSON_DRAG_SIGNATURE;

  if Result then
  begin
    LTask := GetTaskFromHullNoNPONo(LDoc.Task.HullNo, LDoc.Task.PO_No);
    try
      TaskForm.DisplayTaskInfo2EditForm(LTask, nil, LDoc);
    finally
      FreeAndNil(LTask);
    end;
  end
  else
    ShowMessage('Signature is not correct');
end;

procedure ShowEmailListFromIDs(AGrid: TNextGrid; AIDs: TIDDynArray);
var
 LSQLEmailMsg: TSQLEmailMsg;
 LRow: integer;
 LStr: string;
begin
  LSQLEmailMsg:= TSQLEmailMsg.CreateAndFillPrepare(g_ProjectDB, TInt64DynArray(AIDs));
  AGrid.BeginUpdate;
  try
    with AGrid do
    begin
      ClearRows;

      while LSQLEmailMsg.FillOne do
      begin
        LRow := AddRow;
        CellByName['Subject', LRow].AsString := LSQLEmailMsg.Subject;
        CellByName['RecvDate', LRow].AsDateTime := TimeLogToDateTime(LSQLEmailMsg.RecvDate);
        CellByName['Sender', LRow].AsString := LSQLEmailMsg.Sender;
        CellByName['Receiver', LRow].AsString := LSQLEmailMsg.Receiver;
        CellByName['CC', LRow].AsString := LSQLEmailMsg.CarbonCopy;
        CellByName['BCC', LRow].AsString := LSQLEmailMsg.BlindCC;
        CellByName['EMailId', LRow].AsString := IntToStr(LSQLEmailMsg.ID);
        CellByName['EntryId', LRow].AsString := LSQLEmailMsg.EntryID;
        CellByName['StoreId', LRow].AsString := LSQLEmailMsg.StoreID;

        if LSQLEmailMsg.ContainData <> cdmNone then
        begin
          LStr := TRttiEnumerationType.GetName<TContainData4Mail>(LSQLEmailMsg.ContainData);
          CellByName['ContainData', LRow].AsString := LStr;
        end;

        if LSQLEmailMsg.ParentID = '' then
        begin
          MoveRow(LRow, 0);
          LRow := 0;
        end;
      end;
    end;
  finally
    AGrid.EndUpdate;
    FreeAndNil(LSQLEmailMsg);

//    if (AutoMoveCB.Checked) and (MoveFolderCB.ItemIndex > -1) then
//      SendCmd2IPC4MoveFolderEmail(LRow, MoveFolderCB.ItemIndex);
  end;
end;

end.

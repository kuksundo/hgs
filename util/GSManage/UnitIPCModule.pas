unit UnitIPCModule;

interface

uses System.Classes, Dialogs, System.Rtti,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  CommonData, SynCommons, mORMot, DateUtils, System.SysUtils, UElecDataRecord,
  mORMotHttpClient, MailCallbackInterface;

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

function MakeEmailHTMLBody(ATask: TSQLGSTask; AMailType: integer): string;
function MakeSalesReqEmailBody(ATask: TSQLGSTask): string;
function MakeInvoiceEmailBody(ATask: TSQLGSTask): string;
function MakeDirectShippingEmailBody(ATask: TSQLGSTask): string;
function MakeForeignRegEmailBody(ATask: TSQLGSTask): string;
function MakeElecHullRegReqEmailBody(ATask: TSQLGSTask): string;
function MakePOReqEmailBody(ATask: TSQLGSTask): string;
function MakeShippingReqEmailBody(ATask: TSQLGSTask): string;
function MakeForwardFieldServiceEmailBody(ATask: TSQLGSTask): string;

function GetMustacheJSON(ADoc: variant; AMustacheFile: string): string;
function MakeMailSubject(ATask: TSQLGSTask; AMailType: integer): string;
function GetRecvEmailAddress(AMailType: integer): string;
procedure ShowEmailListFromIDs(AGrid: TNextGrid; AIDs: TIDDynArray);

implementation

uses UnitMakeReport, SynMustache, UnitStringUtil;

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
  LCommand, LRespond: string;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK);
    LStrList.Add('Command='+CMD_REQ_REPLY_MAIL);
    LStrList.Add('EntryId='+AEntryId);
    LStrList.Add('StoreId='+AStoreId);
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
    LEntryId := AGrid.CellByName['EntryId', ARow].AsString;
    LStoreId := AGrid.CellByName['StoreId', ARow].AsString;
    LStrList.Add('EntryId='+LEntryId);
    LStrList.Add('StoreId='+LStoreId);
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

function MakeDirectShippingEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LSQLMaterial: TSQLMaterial4Project;
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
begin
  TDocVariant.New(LDoc);
  LDoc.OrderNo := ATask.ShipName;

  LSQLMaterial := GetMaterial4ProjFromTask(ATask);
  try
    LDoc.PorNo := LSQLMaterial.PORNo;
  finally
    FreeAndNil(LSQLMaterial);
  end;

  Result := GetMustacheJSON(LDoc, DOC_DIR + DIRECT_SHIPPING_MUSTACHE_FILE_NAME);
end;

function MakeElecHullRegReqEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
  LSQLCustomer: TSQLCustomer;
begin
  TDocVariant.New(LDoc);
  LDoc.HullNo := ATask.HullNo;
  LDoc.Summary := ATask.WorkSummary;
  LDoc.ProductType := ATask.ProductType;

  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    LDoc.CompanyName := LSQLCustomer.CompanyName;
    LDoc.CompanyCode := LSQLCustomer.CompanyCode;
  finally
    FreeAndNil(LSQLCustomer);
  end;

  Result := GetMustacheJSON(LDoc, DOC_DIR + ELEC_HULLNO_REG_REQ_MUSTACHE_FILE_NAME);
end;

function MakeForeignRegEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
begin
  TDocVariant.New(LDoc);
  LDoc.CompanyName := ATask.ShipOwner;

  Result := GetMustacheJSON(LDoc, DOC_DIR + FOREIGN_REG_MUSTACHE_FILE_NAME);
end;

function MakeEmailHTMLBody(ATask: TSQLGSTask; AMailType: integer): string;
begin
  case AMailType of
    1: Result := MakeInvoiceEmailBody(ATask);
    2: Result := MakeSalesReqEmailBody(ATask);
    3: Result := MakeDirectShippingEmailBody(ATask);
    4: Result := MakeForeignRegEmailBody(ATask);
    5: Result := MakeElecHullRegReqEmailBody(ATask);
    6: Result := MakePOReqEmailBody(ATask);
    7: Result := MakeShippingReqEmailBody(ATask);
    8: Result := MakeForwardFieldServiceEmailBody(ATask);
  end;
end;

function MakeInvoiceEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LSQLCustomer: TSQLCustomer;
begin
  TDocVariant.New(LDoc);
  LDoc.VesselName := ATask.ShipName;
  LDoc.HullNo := ATask.HullNo;
  LDoc.Location := ATask.NationPort;

  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    LDoc.Name := LSQLCustomer.ManagerName;
  finally
    FreeAndNil(LSQLCustomer);
  end;

  Result := GetMustacheJSON(LDoc, DOC_DIR + INVOICE_SEND_MUSTACHE_FILE_NAME);
end;

function MakeMailSubject(ATask: TSQLGSTask; AMailType: integer): string;
begin
  case AMailType of
    1: Result := 'Send Invouice';
    2: Result := '[메출처리 요청 건] ' + ATask.Order_No;
    3: Result := '입고 처리 요청';
    4: Result := '해외매출 고객사 거래처 등록 요청의 건';
    5: Result := '전전 비표준 공사 생성 요청 건 (' + ATask.HullNo + ')';
    6: Result := MakeDirectShippingEmailBody(ATask);
    7: Result := '[출하 요청 건] / ' + ATask.ShippingNo;
  end;
end;

function MakePOReqEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
  LSQLCustomer: TSQLCustomer;
begin
  TDocVariant.New(LDoc);
  LDoc.HullNo := ATask.HullNo;
  LDoc.Summary := ATask.WorkSummary;
  LDoc.ProductType := ATask.ProductType;

  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    LDoc.CompanyName := LSQLCustomer.CompanyName;
    LDoc.CompanyCode := LSQLCustomer.CompanyCode;
  finally
    FreeAndNil(LSQLCustomer);
  end;

  Result := GetMustacheJSON(LDoc, DOC_DIR + PO_REQ_MUSTACHE_FILE_NAME);
end;

function MakeSalesReqEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LSQLCustomer: TSQLCustomer;
  LDate: TDate;
begin
  TDocVariant.New(LDoc);
  LDoc.To := SALES_MANAGER_SIG;
  LDoc.From := MY_EMAIL_SIG;
  LDoc.OrderNo := ATask.Order_No;
  LDoc.SalesPrice :=
    TRttiEnumerationType.GetName<TCurrencyKind>(TCurrencyKind(ATask.CurrencyKind)) +
     ' ' + AddThousandSeparator(UTF8ToString(ATask.SalesPrice),',') ;
  LDoc.ShippingNo := ATask.ShippingNo;

  LDate := TimeLogToDateTime(ATask.SalesReqDate);

  if YearOf(LDate) > 1900 then
    LDoc.SalesReqDate := FormatDateTime('yyyy-mm-dd',LDate)
  else
    LDoc.SalesReqDate := 'NIL';

  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    LDoc.CustName := LSQLCustomer.CompanyName;
    LDoc.CustNo := LSQLCustomer.CompanyCode;
  finally
    FreeAndNil(LSQLCustomer);
  end;

  Result := GetMustacheJSON(LDoc, DOC_DIR + SALES_MUSTACHE_FILE_NAME);
//  QuotedStrJSON(VariantToUTF8(LDoc), LJSON);
end;

function MakeShippingReqEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LSQLMaterial4Project: TSQLMaterial4Project;
  LDate: TDate;
begin
  TDocVariant.New(LDoc);
  LDoc.To := SHIPPING_MANAGER_SIG;
  LDoc.From := MY_EMAIL_SIG;
  LDoc.ShippingNo := ATask.ShippingNo; //출하지시번호
  LDoc.OrderNo := ATask.Order_No;//공사지시번호
  LDoc.PONo := ATask.PO_No;
  LDoc.ShipName := ATask.ShipName;

  LSQLMaterial4Project := GetMaterial4ProjFromTask(ATask);
  try
    LDoc.DeliveryAddr := LSQLMaterial4Project.DeliveryAddress;
  finally
    FreeAndNil(LSQLMaterial4Project);
  end;

  Result := GetMustacheJSON(LDoc, DOC_DIR + SHIPPING_MUSTACHE_FILE_NAME);
end;

function MakeForwardFieldServiceEmailBody(ATask: TSQLGSTask): string;
var
  LDoc: variant;
  LSQLCustomer: TSQLCustomer;
  LDate: TDate;
begin
  TDocVariant.New(LDoc);
  LDoc.To := FIELDSERVICE_MANAGER_SIG;
  LDoc.From := MY_EMAIL_SIG;
  LDoc.Summary := ATask.WorkSummary;
  LDoc.WorkDay := FormatDateTime('yyyy-mm-dd', TimeLogToDateTime(ATask.WorkBeginDate));
  LDoc.Port := ATask.NationPort;

  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    LDoc.LocalAgent := LSQLCustomer.AgentInfo;
  finally
    FreeAndNil(LSQLCustomer);
  end;

  Result := GetMustacheJSON(LDoc, DOC_DIR + FORWARD_FIELDSERVICE_MUSTACHE_FILE_NAME);
end;

function GetMustacheJSON(ADoc: variant;
  AMustacheFile: string): string;
var
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
begin
  LJSON := Utf8ToString(VariantSaveJson(ADoc));
  LFile := StringFromFile(AMustacheFile);
  LMustache := TSynMustache.Parse(LFile);
  Result := Utf8ToString(BinToBase64(LMustache.RenderJSON(LJSON)));
end;

function GetRecvEmailAddress(AMailType: integer): string;
begin
  case AMailType of
    1: Result := '';//Invoice 송부
    2: Result := SALES_DIRECTOR_EMAIL_ADDR;//매출처리요청
    3: Result := MATERIAL_INPUT_EMAIL_ADDR;//자재직투입요청
    4: Result := FOREIGN_INPUT_EMAIL_ADDR;//해외고객업체등록
    5: Result := ELEC_HULL_REG_EMAIL_ADDR;//전전비표준공사 생성 요청
    6: Result := PO_REQ_EMAIL_ADDR; //PO 요청
    7: Result := SHIPPING_REQ_EMAIL_ADDR; //출하 요청
  end;
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

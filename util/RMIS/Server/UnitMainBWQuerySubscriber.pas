unit UnitMainBWQuerySubscriber;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, TimerPool,
  Vcl.OleCtrls, SHDocVw,
  SynCommons, mORMot, mORMotSQLite3, mORMotHttpServer, UnitFrameCommServer,
  AdvOfficePager, Vcl.Menus, BW_Query_Class, BW_Query_Data_Class,
  tmsAdvGridExcel, UnitBWQueryInterface, UnitBWQueryConfig, UnitHhiOfficeNewsInterface,
  ralarm, Sea_Ocean_News_Class, UnitDPMSInfoClass, UnitRMISSessionInterface,
  UnitExtraMH, UnitDPMS, UnitExtraMHInfoInterface, UnitDPMSInfoInterface,
  UnitBWQuery, UnitHHIOfficeNews, RMISConst, UnitStrMsg.Events, UnitStrMsg.EventThreads,
  // cromis units
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading,
  UnitSTOMPClass;

//  {$IFDEF USECODESITE} ,CodeSiteLogging {$ENDIF}

type
  TServiceBWQuery = class(TInterfacedObject, IBWQuery, IDPMSInfo, IExtraMHInfo, IRMISSessionLog)
  public
    //IBWQuery
    function GetBWQryClass(AQueryName: RawUTF8; out ACount: Integer): TRawUTF8DynArray;
    function GetCellData(AQueryName: RawUTF8; out AEPCollect: TBWQryCellDataCollect): Boolean;
    function GetCellDataAll(out ABWQryCellDataAll: TBWQryCellDataAllCollect): Boolean;
    function GetRowHeaderData(AQueryName: RawUTF8; out AColCountOfRow: integer;  out AEPCollect: TBWQryRowHeaderCollect): Boolean;
    function GetColHeaderData(AQueryName: RawUTF8; out AEPCollect: TBWQryColumnHeaderCollect): Boolean;
    function GetOrderPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean;
    function GetSalesPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 매출 경영계획
    function GetProfitPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 손익 경영계획
    function GetNewsList2: TRawUTF8DynArray; //일간 조선 해양 뉴스
//    function GetAttachFileHhiOfficeNews(AFileName: RawUTF8): TServiceCustomAnswer; //일간 조선 해양 뉴스 첨부파일(pdf) 반환
    procedure GetAttachFileHhiOfficeNews2(AFileName:RawUTF8; out AFile: RawByteString); //일간 조선 해양 뉴스 첨부파일(pdf) 반환
    procedure GetHhiOfficeNewsList2(out ASeaOceanNewsCollect: TSONewsCollect);
    function GetInquiryPerProdPerGrade: TRawUTF8DynArray; //등급별 제품별 Inquiry 금액

    //IDPMSInfo
    function GetDPMSInfo(AFrom, ATo: string): RawUTF8;

    //IExtraMHInfo
    function GetExtraMHInfo(AFrom, ATo: string): RawUTF8;

    //ISessionLog : TSQLRestServerFullMemory.Create시에 aHandleUserAuthentication Parameter가
    //              False(SmartPhone에서 Url로 조회시 로그인 생략하기 위함) 로 설정된 경우
    //              OnSessionCreate와 OnSessionClosed Event가 작동 안 하므로 Client에서 아래 함수를 Call해 주어야
    //              서버에 로그를 기록할 수 있음
    function LogIn(AUserId, APasswd, AIpAddress, AUserName: string): Boolean;
    function LogOut(AUserId, APasswd, AIpAddress, AUserName: string): Boolean;
    function GetRMISUserList: RawUTF8;
    function IsRMISUser(AID: string): Boolean;
    function GetEngDiv_kWh(ADate: string): RawUTF8;
    procedure GetCrankShaftCraneInfo(X,Y,W: string);
  end;

  TMainForm = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    FCS: TFrameCommServer;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Etc1: TMenuItem;
    Close1: TMenuItem;
    Config1: TMenuItem;
    AdvGridExcelIO1: TAdvGridExcelIO;
    PopupMenu1: TPopupMenu;
    DataView1: TMenuItem;
    N12: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Header1: TMenuItem;
    Header2: TMenuItem;
    N13: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    HEADER3: TMenuItem;
    N14: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    Memo1: TMemo;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    Edit1: TEdit;
    AlarmFromTo1: TAlarmFromTo;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    Inquiry1: TMenuItem;
    OnGetBWQuery1: TMenuItem;
    est1: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    GS1: TMenuItem;
    GetRMISUser1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FCSServerStartBtnClick(Sender: TObject);
    procedure FCSServerStopBtnClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure FCSAutoStartCheckClick(Sender: TObject);
    procedure FCSJvXPButton6Click(Sender: TObject);
    procedure AlarmFromTo1AlarmBegin(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OnGetBWQuery1Click(Sender: TObject);
    procedure est1Click(Sender: TObject);
    procedure GetRMISUser1Click(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;
    FTaskPool: TTaskPool;

    procedure OnGetBWQueryFromPublisher(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnTryConnectPublisher(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnMessageComplete(const Msg: ITaskMessage);
    procedure OnAsynchronousIPCTask(const ATask: ITask);
    procedure OnAsynchronousIPCConnect(const ATask: ITask);
    procedure StartServer;
    procedure SendRequest(ACommand: string);
    procedure CheckConnectPublisher;
  protected
    FSettings : TConfigSettings;
    FpjhSTOMPClass: TpjhSTOMPClass;
    FIsConnectedPublisher: Boolean;
//    FAutoStartTimerHandle: integer;
    procedure GetBWQryDataFromPublisher;
  public
    FUserId, FPasswd, FTopic, FMQServerIp,
    FExeFilePath: string;
    FCsvFileName: string;

    FBWQueryData: TBWQryDataClass;
    FDPMS: TDPMS;
    FExtraMH: TExtraMH;
    FHHIOfficeNews: THHIOfficeNews;

    procedure InitVar;
    procedure DestroyVar;
    procedure InitCromisIPC;
    procedure DestroyCromisIPC;
    procedure InitSTOMP;
    procedure DestroySTOMP;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;

    procedure ClearMessage;
    procedure DisplayMessage(msg: string);
    procedure DisplayMessage2FCS(msg: string; ADest: integer);
    procedure SetFormCaption(ACaption: string);
    function GetFormCaption: string;
  end;

var
  MainForm: TMainForm;

implementation

uses UnitDM, StrUtils, DateUtils;

{$R *.dfm}

procedure TMainForm.AlarmFromTo1AlarmBegin(Sender: TObject);
var
  LPort: string;
begin
  GetBWQryDataFromPublisher;

  try
    LPort := FSettings.ServerPort_HhiOfficeNews;

    if LPort = '' then
    begin
      LPort := HHIOFFICE_PORT_NAME;
      FSettings.ServerPort_HhiOfficeNews := LPort;
    end;

    FHHIOfficeNews.GetHhiOfficeNewsFromServer(FSettings.ServerIP_HhiOfficeNews, LPort);
  except
  end;
end;

procedure TMainForm.ApplyUI;
begin
  AlarmFromTo1.ActiveBegin := False;
  AlarmFromTo1.AlarmTimeBegin := FSettings.ServerTimeToGetHhiOfficeNews;
  AlarmFromTo1.ActiveBegin := True;
end;

procedure TMainForm.CheckConnectPublisher;
var
  AsyncTask: ITask;
begin
  AsyncTask := FTaskPool.AcquireTask(OnAsynchronousIPCConnect, 'AsyncTask');
  AsyncTask.Values.Ensure('ServerName').AsString := FSettings.IPCServerName;
  AsyncTask.Run;
end;

procedure TMainForm.ClearMessage;
begin
  Memo1.Lines.Clear;
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Config1Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TMainForm.DestroyCromisIPC;
begin
  FTaskPool.Finalize;
  FTaskPool.Free;
end;

procedure TMainForm.DestroySTOMP;
begin
  FpjhSTOMPClass.Free;
end;

procedure TMainForm.DestroyVar;
begin
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  DestroySTOMP;
  DestroyCromisIPC;
  FCS.DestroyHttpServer;
  FSettings.Free;
  FBWQueryData.Free;
  FDPMS.Free;
  FExtraMH.Free;
//  FHHIOfficeNews.Free;
end;

procedure TMainForm.DisplayMessage(msg: string);
begin
  if msg = ' ' then
    exit;

  with Memo1 do
  begin
    if Lines.Count > 10000 then
      Clear;

    Lines.Add(msg);
  end;//with
end;

procedure TMainForm.DisplayMessage2FCS(msg: string; ADest: integer);
begin
  FCS.DisplayMessage(Msg, TDisplayTarget(ADest));
end;

procedure TMainForm.est1Click(Sender: TObject);
var
  LStrYear: string;
begin
  LStrYear := IntToStr(YearOf(Date));
  FExtraMH.GetExtraMHInfo(LStrYear + '01', LStrYear + '12');
end;

procedure TMainForm.FCSAutoStartCheckClick(Sender: TObject);
begin
  if not FCS.AutoStartCheck.Checked then
  begin
//    FPJHTimerPool.Remove(FAutoStartTimerHandle);
//    FAutoStartTimerHandle := -1;
  end;
end;

procedure TMainForm.FCSJvXPButton6Click(Sender: TObject);
begin
//  SendRequest('GET_BWQRY_COLUMN_HEADER_DATA_ALL');
  SendRequest('GET_BWQRYCLASS_ALL');
end;

procedure TMainForm.FCSServerStartBtnClick(Sender: TObject);
begin
  StartServer;
end;

procedure TMainForm.FCSServerStopBtnClick(Sender: TObject);
begin
  FCS.ServerStopBtnClick(Sender);
end;

procedure TMainForm.FormActivate(Sender: TObject);
var
  LPort: string;
begin
  LPort := FSettings.ServerPort_HhiOfficeNews;

  if LPort = '' then
  begin
    LPort := HHIOFFICE_PORT_NAME;
    FSettings.ServerPort_HhiOfficeNews := LPort;
  end;

//  FHHIOfficeNews.GetHhiOfficeNewsFromServer(FSettings.ServerIP_HhiOfficeNews, LPort);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

procedure TMainForm.GetBWQryDataFromPublisher;
begin
  SendRequest('GET_BWQRYCLASS_ALL');
end;

function TMainForm.GetFormCaption: string;
begin
  Result := Caption;
end;

procedure TMainForm.GetRMISUser1Click(Sender: TObject);
begin
  FDPMS.GetRMISUserList(True);
end;

procedure TMainForm.InitCromisIPC;
begin
  FTaskPool := TTaskPool.Create(5);
  FTaskPool.OnTaskMessage := OnMessageComplete;
  FTaskPool.Initialize;
end;

procedure TMainForm.InitSTOMP;
begin
  FUserId := 'pjh';
  FPasswd := 'pjh';
  FTopic := 'BWQry';
  FMQServerIp := '10.14.21.117';
  FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(FUserId,FPasswd,FMQServerIp,FTopic,Handle);
end;

procedure TMainForm.InitVar;
begin
  FExeFilePath := ExtractFilePath(Application.ExeName);
  FCsvFileName := ChangeFileExt(Application.ExeName, '.csv');
  StrMsgEventThread.FDisplayMsgProc := DisplayMessage2FCS;
  FSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadConfigFromFile;

  FBWQueryData := TBWQryDataClass.Create;
  FDPMS := TDPMS.Create;
  FExtraMH := TExtraMH.Create;
  FPJHTimerPool := TPJHTimerPool.Create(Self);
  TJSONSerializer.RegisterCollectionForJSON(TSONewsCollect, TSONewsItem);
//  FHHIOfficeNews := THHIOfficeNews.Create;
  g_DisplayMessage2MainForm := DisplayMessage;
  g_DisplayMessage2FCS := DisplayMessage2FCS;
  g_ClearMessage := ClearMessage;
  g_SetFormCaption := SetFormCaption;
  g_GetFormCaption := GetFormCaption;

//  if FCS.AutoStartCheck.Checked then
//    FAutoStartTimerHandle := FPJHTimerPool.Add(OnAutoStart, 1000);
  FCS.FStartServerProc := StartServer;
  FCS.FAutoStartInterval := 10000; //10초

  InitCromisIPC;
  InitSTOMP;
  CheckConnectPublisher;
  FPJHTimerPool.AddOneShot(OnGetBWQueryFromPublisher, 1000);
//  if FSettings.ServerTimeToGetHhiOfficeNews <> '' then
//  begin
//    AlarmFromTo1.AlarmTimeBegin := FSettings.ServerTimeToGetHhiOfficeNews;
//    AlarmFromTo1.ActiveBegin := True;
//  end;
end;

procedure TMainForm.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TMainForm.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TMainForm.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);
end;

procedure TMainForm.OnAsynchronousIPCConnect(const ATask: ITask);
var
  IPCClient: TIPCClient;
  LMsg: string;
begin
  FIsConnectedPublisher := False;
  IPCClient := TIPCClient.Create;
  try
    IPCClient.ServerName := ATask.Values.Get('ServerName').AsString;
    IPCClient.ConnectClient(1000);
    FIsConnectedPublisher := IPCClient.IsConnected;

    if FIsConnectedPublisher then
      FCS.DisplayMessageFromOuter('BW Query Publisher is connected.',0)
    else
    begin
      FCS.DisplayMessageFromOuter('BW Query Publisher is Disconnected! Try again...after 1 second',0);
      FPJHTimerPool.AddOneShot(OnTryConnectPublisher, 1000);
    end;

    IPCClient.DisconnectClient;
  finally

    IPCClient.Free;
  end;
end;

procedure TMainForm.OnAsynchronousIPCTask(const ATask: ITask);
var
  Result: IIPCData;
  Request: IIPCData;
  IPCClient: TIPCClient;
  TimeStamp: TDateTime;
  LCommand: string;
begin
  IPCClient := TIPCClient.Create;
  try
//    IPCClient.ComputerName := ATask.Values.Get('ComputerName').AsString;
    IPCClient.ServerName := ATask.Values.Get('ServerName').AsString;
    LCommand := ATask.Values.Get('Command').AsString;

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUnicodeString('Command', LCommand);
    Result := IPCClient.ExecuteRequest(Request);

    if IPCClient.AnswerValid then
    begin
      ATask.Message.Ensure('ID').AsString := Result.ID;
      TimeStamp := Result.Data.ReadDateTime('TDateTime');
      ATask.Message.Ensure('TDateTime').AsString := DateTimeToStr(TimeStamp);
//      ATask.Message.Ensure('Integer').AsInteger := Result.Data.ReadInteger('Integer');
//      ATask.Message.Ensure('Real').AsFloat := Result.Data.ReadReal('Real');
      ATask.Message.Ensure('Data').AsString := Result.Data.ReadUnicodeString('Data');
      ATask.SendMessageAsync;
    end;
  finally
    IPCClient.Free;
  end;
end;

procedure TMainForm.OnGetBWQuery1Click(Sender: TObject);
begin
//  FPJHTimerPool.AddOneShot(OnGetBWQuery, 500);
end;

procedure TMainForm.OnGetBWQueryFromPublisher(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  if FIsConnectedPublisher then
  begin
    FCS.DisplayMessageFromOuter('SendRequest(GET_BWQRYCLASS_ALL)',0);
    GetBWQryDataFromPublisher;
  end
  else
  begin
    FCS.DisplayMessageFromOuter('BW Query Publisher not connected, Wait 1 Second.',0);
    FPJHTimerPool.AddOneShot(OnGetBWQueryFromPublisher, 1000);
  end;
end;

procedure TMainForm.OnMessageComplete(const Msg: ITaskMessage);
var
  LId, LData, LCommand, LDateTime: string;
  LUtf8: RawUtf8;
  LValid: Boolean;
begin
  LId := Msg.Values.Get('ID').AsString;
  LDateTime := Msg.Values.Get('TDateTime').AsString;
//  LCommand := Msg.Values.Get('Command').AsString;
  LData := Msg.Values.Get('Data').AsString;
  LUtf8 := StringToUtf8(LData);

  if LId = '1' then //GET_BWQRY_CELL_DATA_ALL
  begin
//    JSONToObject();
  end
  else if LId = '2' then //GET_BWQRY_COLUMN_HEADER_DATA_ALL
  begin
    JsonToObject(FBWQueryData.FCellDataAllCollect, Pointer(LUtf8),LValid);
  end
  else if LId = '3' then //GET_BWQRY_ROW_HEADER_DATA_ALL
  begin

  end
  else if LId = '4' then //GET_BWQRYCLASS_ALL
  begin
    FBWQueryData.GetJSON2DataAllCollect2BWQryList(LData);
  end;

  FCS.DisplayMessageFromOuter(LDateTime + ': Command = ' + LCommand + ' >>> Send Data = ' + LData, 2);
end;

procedure TMainForm.OnTryConnectPublisher(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  CheckConnectPublisher;
end;

//ACommand :  GET_BWQRY_CELL_DATA_ALL, GET_BWQRY_COLUMN_HEADER_DATA_ALL, GET_BWQRY_ROW_HEADER_DATA_ALL
procedure TMainForm.SendRequest(ACommand: string);
var
  AsyncTask: ITask;
begin
  AsyncTask := FTaskPool.AcquireTask(OnAsynchronousIPCTask, 'AsyncTask');
  AsyncTask.Values.Ensure('ServerName').AsString := FSettings.IPCServerName;
  AsyncTask.Values.Ensure('Command').AsString := ACommand;
  AsyncTask.Run;
end;

procedure TMainForm.SetConfig;
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

procedure TMainForm.SetFormCaption(ACaption: string);
begin
  Caption := ACaption;
end;

procedure TMainForm.StartServer;
begin                                                                                                           //sicClientDriven
  FCS.CreateHttpServer(BWQRY_ROOT_NAME, 'BWQuery.json', BWQRY_PORT_NAME, TServiceBWQuery,
    [TypeInfo(IBWQuery), TypeInfo(IDPMSInfo), TypeInfo(IExtraMHInfo), TypeInfo(IRMISSessionLog)], sicClientDriven, True);
  FCS.ServerStartBtnClick(nil);
end;

{ TServiceBWQuery }

//function TServiceBWQuery.GetAttachFileHhiOfficeNews(
//  AFileName: RawUTF8): TServiceCustomAnswer;
//begin
//  Result.Header := TEXT_CONTENT_TYPE_HEADER;
//  Result.Content := StringFromFile(SHIP_OCEAN_PDF_FILE);
//end;

procedure TServiceBWQuery.GetAttachFileHhiOfficeNews2(AFileName: RawUTF8;
  out AFile: RawByteString);
var
  LFileName: TFileName;
begin
  LFileName := SHIP_OCEAN_PDF_FILE;

  if AFileName <> '' then
    LFileName := AFileName;

  AFile := StringFromFile(LFileName);
end;

function TServiceBWQuery.GetBWQryClass(AQueryName: RawUTF8; out ACount: Integer): TRawUTF8DynArray;
var
  LKey: string;
  LQueryName: string;
  LBQC: TBWQryClass;
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

//  if MainForm.FBWQueryData.FGetQrying then
//  begin
//    LDynArr.Add('GetQrying');
//    exit;
//  end;

  LBQC := nil;
  LQueryName := Utf8ToString(AQueryName);

  if LQueryName = 'NULL' then //모든 BWQryList를 가져옴
  begin
    for LKey in MainForm.FBWQueryData.FBWQryList.Keys do
    begin
      LBQC := MainForm.FBWQueryData.GetQueryClass(MainForm.FBWQueryData.FBWQryList.Items[LKey].QueryName);

      if Assigned(LBQC) then
      begin
        LValue := StringToUTF8(LBQC.Description) + ';';
        LValue := LValue + StringToUTF8(LBQC.QueryName) + ';';
        LValue := LValue + StringToUTF8(LBQC.QueryText) + ';';
        LValue := LValue + StringToUTF8(IntToStr(LBQC.QueryType)) + ';';
        LValue := LValue + StringToUTF8(IntToStr(Ord(LBQC.QryParamType))) + ';';
        LDynArr.Add(LValue);
      end;
    end;

//    ShowMessage(LBQC.QueryName);
  end
  else
  begin
    LBQC := MainForm.FBWQueryData.GetQueryClass(AQueryName);

    if Assigned(LBQC) then
    begin
//      LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
      LValue := StringToUTF8(LBQC.Description);
      LDynArr.Add(LValue);
      LValue := StringToUTF8(LBQC.QueryName);
      LDynArr.Add(LValue);
      LValue := StringToUTF8(LBQC.QueryText);
      LDynArr.Add(LValue);
      LValue := StringToUTF8(IntToStr(LBQC.QueryType));
      LDynArr.Add(LValue);
      LValue := StringToUTF8(IntToStr(Ord(LBQC.QryParamType)));
      LDynArr.Add(LValue);
    end;
  end;

  ACount := LCount;
end;

function TServiceBWQuery.GetCellData(AQueryName: RawUTF8;
  out AEPCollect: TBWQryCellDataCollect): Boolean;
var
//  LBWCellData: TBWQryCellDataCollect;
  LQueryName, LRemoteIP: string;
  LBQC: TBWQryClass;
begin
  LQueryName := Utf8ToString(AQueryName);
  LBQC := nil;
  LBQC := MainForm.FBWQueryData.GetQueryClass(AQueryName);

  try
    if Assigned(LBQC) then
    begin
      CopyObject(LBQC.BWQryCellDataCollect, AEPCollect);
      LRemoteIP := FormatDateTime('mm월 dd일, hh:nn:ss => ', now) + IntToStr(LBQC.BWQryCellDataCollect.Count) + ' Data have Sent to client(IP:';
      LRemoteIP := LRemoteIP + FindIniNameValue(pointer(ServiceContext.Request.Call.InHead),'REMOTEIP: ') +  ') for Query ( ' + AQueryName + ' )';
      MainForm.FCS.DisplayMessage(LRemoteIP, dtCommLog);
    end;
  finally
  end;
end;

function TServiceBWQuery.GetCellDataAll(out ABWQryCellDataAll: TBWQryCellDataAllCollect): Boolean;
var
  LValue: RawUTF8;
  LCount: integer;
begin
  Result := False;

  if g_GetCellDataAllRunning then
  begin
//    LDynArr.Add('GetCellDataAllRunning');
    exit;
  end
  else
    g_GetCellDataAllRunning := True;

  try
    MainForm.FBWQueryData.GetCellDataAll('GET_BWQRY_CELL_DATA_ALL');
    CopyObject(MainForm.FBWQueryData.FCellDataAllCollect, ABWQryCellDataAll);
    Result := True;
//    LDynArr.Add('Success');
  finally
    g_GetCellDataAllRunning := False;
  end;
end;

function TServiceBWQuery.GetColHeaderData(AQueryName: RawUTF8;
  out AEPCollect: TBWQryColumnHeaderCollect): Boolean;
var
  LQueryName: string;
  LBQC: TBWQryClass;
begin
  LBQC := nil;
  LQueryName := Utf8ToString(AQueryName);
  LBQC := MainForm.FBWQueryData.GetQueryClass(AQueryName);

  if Assigned(LBQC) then
    CopyObject(LBQC.BWQryColumnHeaderCollect, AEPCollect);
end;

procedure TServiceBWQuery.GetCrankShaftCraneInfo(X, Y, W: string);
var
  LStr: string;
begin
  LStr := DateTimeToStr(now) + ' ==> ' + X + ',' + Y + ',' + W + #13#10;
  TStrMsgEvent.Create(LStr, 0, MainForm.FCsvFileName).Queue;
end;

function TServiceBWQuery.GetDPMSInfo(AFrom, ATo: string): RawUTF8;
begin
  Result := MainForm.FDPMS.GetDPMSInfo(AFrom, ATo);
end;

function TServiceBWQuery.GetEngDiv_kWh(ADate: string): RawUTF8;
var
  LY,LM,LD: integer;
  LStr: string;
begin
  LStr := LeftStr(ADate,4);
  LY := StrToIntDef(LStr,0);
  LStr := MidStr(ADate, 5, 2);
  LM := StrToIntDef(LStr,0);
  LStr := RightStr(ADate,2);
  LD := StrToIntDef(LStr,0);

  Result := DM1.GetEngDiv_kWh(LY,LM,LD);
end;

function TServiceBWQuery.GetExtraMHInfo(AFrom, ATo: string): RawUTF8;
begin
  Result := MainForm.FExtraMH.GetExtraMHInfo(AFrom, ATo);
end;

procedure TServiceBWQuery.GetHhiOfficeNewsList2(
  out ASeaOceanNewsCollect: TSONewsCollect);
begin
//  CopyObject(MainForm.FHHIOfficeNews.FSeaOceanNewsCollect, ASeaOceanNewsCollect);
end;

function TServiceBWQuery.GetInquiryPerProdPerGrade: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
  Result := MainForm.FBWQueryData.GetInquiryPerProdPerGrade;
end;

function TServiceBWQuery.GetNewsList2: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
  Result := MainForm.FHHIOfficeNews.GetSONewsFromList;
end;

function TServiceBWQuery.GetOrderPlanPerProduct(
  out ACollect: TBWQryCellDataCollect): Boolean;
begin
  Result := False;

  if MainForm.FBWQueryData.FOrderPlanPerProduct.Count > 0 then
  begin
    CopyObject(MainForm.FBWQueryData.FOrderPlanPerProduct, ACollect);
    Result := True;
  end;
end;

function TServiceBWQuery.GetProfitPlanPerProduct(
  out ACollect: TBWQryCellDataCollect): Boolean;
begin
  Result := False;

  if MainForm.FBWQueryData.FOrderPlanPerProduct.Count > 0 then
  begin
    CopyObject(MainForm.FBWQueryData.FProfitPlanPerProduct, ACollect);
    Result := True;
  end;
end;

function TServiceBWQuery.GetRMISUserList: RawUTF8;
begin
  Result := MainForm.FDPMS.GetRMISUserList(True);
end;

function TServiceBWQuery.GetRowHeaderData(AQueryName: RawUTF8; out AColCountOfRow: integer;
  out AEPCollect: TBWQryRowHeaderCollect): Boolean;
var
  LQueryName: string;
  LBQC: TBWQryClass;
begin
  LBQC := nil;
  LQueryName := Utf8ToString(AQueryName);
  LBQC := MainForm.FBWQueryData.GetQueryClass(AQueryName);
  AColCountOfRow := LBQC.BWQryRowHeaderCollect.ColCountOfRow;

  if Assigned(LBQC) then
    CopyObject(LBQC.BWQryRowHeaderCollect, AEPCollect);
end;

function TServiceBWQuery.GetSalesPlanPerProduct(
  out ACollect: TBWQryCellDataCollect): Boolean;
begin
  Result := False;

  if MainForm.FBWQueryData.FOrderPlanPerProduct.Count > 0 then
  begin
    CopyObject(MainForm.FBWQueryData.FSalesPlanPerProduct, ACollect);
    Result := True;
  end;
end;

function TServiceBWQuery.IsRMISUser(AID: string): Boolean;
begin
  Result := MainForm.FDPMS.IsRMISUser(AID);
end;

function TServiceBWQuery.LogIn(AUserId, APasswd, AIpAddress,
  AUserName: string): Boolean;
begin
  if not UnitFrameCommServer.IsHandleUserAuthentication then
  begin

  end;
end;

function TServiceBWQuery.LogOut(AUserId, APasswd, AIpAddress,
  AUserName: string): Boolean;
begin
  if not UnitFrameCommServer.IsHandleUserAuthentication then
  begin

  end;
end;

end.

unit UnitFrameCommServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvOfficeStatusBar, OtlComm,
  AdvOfficeStatusBarStylers, Vcl.ExtCtrls, Vcl.Menus, JvComponentBase,
  JvTrayIcon, JvExControls, JvXPCore, JvXPButtons, Vcl.StdCtrls,
  Vcl.ComCtrls, Cromis.Threading, Cromis.AnyValue,
  TimerPool, SynCommons, mORMot, mORMotHttpServer, mORMotWrappers, UnitCommUserClass;

const
  IsHandleUserAuthentication = False;
  WM_OnMemoMessage = WM_USER + 1;

type
  TDisplayTarget = (dtSystemLog, dtConnectLog, dtCommLog, dtStatusBar);

  TDispMsgRecord = packed record
    FMsg: string;
    FDspTarget: TDisplayTarget;
  end;

  TRestMode = (rmRESTful, rmWebSocket);
  TStartServerProc = procedure of object;

  TFrameCommServer = class(TFrame)
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lvConnections: TListView;
    TabSheet2: TTabSheet;
    Splitter2: TSplitter;
    SendMemo: TRichEdit;
    Recvmemo: TRichEdit;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Panel1: TPanel;
    AutoStartCheck: TCheckBox;
    Panel2: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LblPort: TLabel;
    LblCurConnent: TLabel;
    LblMaxConn: TLabel;
    Label8: TLabel;
    ServerStartBtn: TJvXPButton;
    ServerStopBtn: TJvXPButton;
    JvXPButton3: TJvXPButton;
    JvXPButton4: TJvXPButton;
    JvXPButton5: TJvXPButton;
    JvXPButton6: TJvXPButton;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    JvTrayIcon1: TJvTrayIcon;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    rlsmd1: TMenuItem;
    StopMonitor1: TMenuItem;
    StartMonitor1: TMenuItem;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N5: TMenuItem;
    MenuItem4: TMenuItem;
    Timer1: TTimer;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    ServerIpCombo: TComboBox;
    PopupMenu2: TPopupMenu;
    DeleteItem1: TMenuItem;
    N6: TMenuItem;
    ShowDebug1: TMenuItem;
    SMCommLog: TMemo;
    SMSysLog: TMemo;
    SMUDPConnectLog: TMemo;
    procedure ServerStartBtnClick(Sender: TObject);
    procedure ServerStopBtnClick(Sender: TObject);
    procedure DeleteItem1Click(Sender: TObject);
    procedure ShowDebug1Click(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;
    FAutoStartTimerHandle: integer;

    procedure OnMemoMessage(var Msg: TMessage); message WM_OnMemoMessage;
    procedure OnAutoStartServer(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt); virtual;
    function SessionCreate(Sender: TSQLRestServer; Session: TAuthSession;
                  Ctxt: TSQLRestServerURIContext): boolean;
    function SessionClosed(Sender: TSQLRestServer; Session: TAuthSession;
                  Ctxt: TSQLRestServerURIContext): boolean;
  public
    FModel: TSQLModel;
    FHTTPServer: TSQLHttpServer;
    FRestServer: TSQLRestServer;
    FServiceFactoryServer: TServiceFactoryServer;

    FIpAddr: string;
    FURL: string; //Server에서 Client에 Config Change Notify 하기 위한 Call Back URL

    FRootName,
    FJSONName,
    FPortName: string;
    FIsServerActive: Boolean;
    FStartServerProc: TStartServerProc;
    FAutoStartInterval: integer;
    FRestMode: TRestMode;
    FCommUserList: TCommUser;
    FMessageQueue: TThreadSafeQueue;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitVar;
    procedure DestroyVar;

    procedure CreateHttpServer(ARootName, AJSONName, APort: string;
      aClient: TInterfacedClass; const aInterfaces: array of PTypeInfo;
            aInstanceCreation: TServiceInstanceImplementation; aIsClientWrapper: boolean = False);
    procedure CreateHttpServer4WS(APort, ATransmissionKey: string;
      aClient: TInterfacedClass; const aInterfaces: array of TGUID);
    procedure DestroyHttpServer;

    procedure MySessionCreate(ARemoteIP, ASessionID, AUserId: string);
    procedure MySessionClosed(ARemoteIP, ASessionID, AUserId: string);

    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
    procedure DisplayMessageFromOuter(msg: string; ADspNo: integer);

    procedure AddConnectionToLV(AIPAddr, APort, ASessionID: string; AUserName: string = ''); overload;
    procedure AddConnectionToLV(ACommUserItem: TCommUserItem); overload;
    function AddCommUser2Collect(AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl: string): Boolean;
    function DeleteCommUser2Collect(AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl: string): Boolean;
    function CheckExistUserFromList(AUserId,AIpAddress,AUrl: string): integer;
    procedure DeleteConnectionFromLV(AIPAddr, APort, ASessionID: string; AUserName: string = ''); overload;
    procedure DeleteConnectionFromLV(ACommUserItem: TCommUserItem); overload;

    procedure ApplyStatus2Component;
    function Get_HHI_IPAddr: string;
  end;

implementation

uses getIp, SynLog, System.StrUtils;

{$R *.dfm}

{ TFrameCommServer }

function TFrameCommServer.AddCommUser2Collect(AUserId, APasswd, AIpAddress,
  AUserName, ASessionId, AUrl: string): Boolean;
var
  LCommUserItem: TCommUserItem;
begin
  Result := CheckExistUserFromList(AUserId,AIpAddress,AUrl) <> -1; //있으면 True

  if not Result then
  begin
    LCommUserItem := FCommUserList.CommUserCollect.Add;
    LCommUserItem.UserID := AUserId;
    LCommUserItem.Passwd := APasswd;
    LCommUserItem.IpAddress := AIpAddress;
    LCommUserItem.UserName := AUserName;
    LCommUserItem.SessionId := ASessionId;
    LCommUserItem.Url := AUrl;

    AddConnectionToLV(LCommUserItem);
  end;
end;

procedure TFrameCommServer.AddConnectionToLV(AIPAddr, APort, ASessionID: string;
  AUserName: string);
var
  LListItem: TListItem;
begin
  LListItem := lvConnections.Items.Add;
  LListItem.Caption := AIPAddr;
  LListItem.SubItems.Add('Connected');
  LListItem.SubItems.Add(DateTimeToStr(Now));
  LListItem.SubItems.Add(APort);
  LListItem.SubItems.Add(AUserName);
  LListItem.SubItems.Add(ASessionID);
  DisplayMessage(DateTimeToStr(Now) + ' : Connected from [ ' + AIPAddr + ' : ' + AUserName + ' ]', dtConnectLog);
end;

procedure TFrameCommServer.AddConnectionToLV(ACommUserItem: TCommUserItem);
var
  LListItem: TListItem;
  LStr: string;
begin
  LListItem := lvConnections.Items.Add;
  LListItem.Caption := ACommUserItem.IpAddress;
  LListItem.SubItems.Add('Connected');
  LListItem.SubItems.Add(DateTimeToStr(Now));
  LListItem.SubItems.Add(ACommUserItem.ServerPortNo);
  LListItem.SubItems.Add(ACommUserItem.UserName);
  LListItem.SubItems.Add(ACommUserItem.SessionId);
  LStr := DateTimeToStr(Now) + ' : Connected from [ ' + ACommUserItem.IpAddress + ' : ' + ACommUserItem.UserName + ' ]';
  DisplayMessage(LStr, dtConnectLog);
end;

procedure TFrameCommServer.ApplyStatus2Component;
begin
  ServerStartBtn.Enabled := not FIsServerActive;
  ServerStopBtn.Enabled := FIsServerActive;

  ServerIpCombo.Text := FIpAddr;
  LblPort.Caption := FPortName;
end;

function TFrameCommServer.CheckExistUserFromList(AUserId,AIpAddress,AUrl: string): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to FCommUserList.CommUserCollect.Count - 1 do
  begin
    if (FCommUserList.CommUserCollect.Items[i].UserID = AUserId) and
      (FCommUserList.CommUserCollect.Items[i].IpAddress = AIpAddress) and
      (FCommUserList.CommUserCollect.Items[i].Url = AUrl) then
    begin
      Result := i;
      break;
    end;
  end;
end;

constructor TFrameCommServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InitVar;
end;

procedure TFrameCommServer.CreateHttpServer(ARootName, AJSONName, APort: string;
  aClient: TInterfacedClass; const aInterfaces: array of PTypeInfo;
  aInstanceCreation: TServiceInstanceImplementation; aIsClientWrapper: boolean);
begin
  if not Assigned(FModel) then
  begin
    FModel := TSQLModel.Create([],ARootName);
    FRootName := ARootName;
  end;

  if not Assigned(FRestServer) then
  begin
    // initialize a TObjectList-based database engine
    FRestServer := TSQLRestServerFullMemory.Create(FModel,AJSONName,false,IsHandleUserAuthentication);

    // add the http://localhost:888/root/wrapper code generation web page
    if aIsClientWrapper then
      AddToServerWrapperMethod(FRestServer,
        ['..\..\..\common\mORMot\CrossPlatform\templates','..\..\..\common\mORMot\CrossPlatform\templates']);

    FJSONName := AJSONName;
    // register our ICalculator service on the server side
    FRestServer.ServiceRegister(aClient, aInterfaces, aInstanceCreation);//.ByPassAuthentication := True;

    FRestServer.OnSessionCreate := SessionCreate;
    FRestServer.OnSessionClosed := SessionClosed;
  end;

  if not Assigned(FHTTPServer) then
  begin
    // launch the HTTP server
    FPortName := APort;
    FHTTPServer := TSQLHttpServer.Create(APort,[FRestServer],'+',useHttpApiRegisteringURI);
    FHTTPServer.AccessControlAllowOrigin := '*'; // for AJAX requests to work
    FIsServerActive := True;
  end;
end;

procedure TFrameCommServer.CreateHttpServer4WS(APort, ATransmissionKey: string;
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

    FRestMode := rmWebSocket;

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
end;

function TFrameCommServer.DeleteCommUser2Collect(AUserId, APasswd, AIpAddress,
  AUserName, ASessionId, AUrl: string): Boolean;
var
  i: integer;
//  LCommUserItem: TCommUserItem;
begin
  i := CheckExistUserFromList(AUserId,AIpAddress,AUrl);
  Result := i <> -1;//있으면 True

  if Result then
  begin
    DeleteConnectionFromLV(FCommUserList.CommUserCollect.Items[i]);
    FCommUserList.CommUserCollect.Delete(i);
  end;
end;

procedure TFrameCommServer.DeleteConnectionFromLV(ACommUserItem: TCommUserItem);
var
  i: integer;
  LListItem: TListItem;
begin
  for i := 0 to lvConnections.Items.Count - 1 do
  begin
    LListItem := lvConnections.Items.Item[i];

    if (LListItem.Caption = ACommUserItem.IpAddress) and
      (LListItem.SubItems.Strings[2] = ACommUserItem.ServerPortNo) and
      (LListItem.SubItems.Strings[3] = ACommUserItem.UserName) and
      (LListItem.SubItems.Strings[4] = ACommUserItem.SessionId) then
    begin
      lvConnections.Items.Delete(i);
      DisplayMessage(DateTimeToStr(Now) + ' : DisConnected from [ ' + ACommUserItem.IpAddress + ' : ' + ACommUserItem.UserName +  ' ]', dtConnectLog);
      break;
    end;
  end;
end;

procedure TFrameCommServer.DeleteConnectionFromLV(AIPAddr, APort, ASessionID,
  AUserName: string);
var
  i: integer;
  LListItem: TListItem;
begin
  for i := 0 to lvConnections.Items.Count - 1 do
  begin
    LListItem := lvConnections.Items.Item[i];

    if (LListItem.Caption = AIPAddr) and
      (LListItem.SubItems.Strings[2] = APort) and
      (LListItem.SubItems.Strings[3] = AUserName) and
      (LListItem.SubItems.Strings[4] = ASessionID) then
    begin
      lvConnections.Items.Delete(i);
      DisplayMessage(DateTimeToStr(Now) + ' : DisConnected from [ ' + AIPAddr + ' : ' + AUserName +  ' ]', dtConnectLog);
      break;
    end;
  end;
end;

procedure TFrameCommServer.DeleteItem1Click(Sender: TObject);
begin
  lvConnections.Items.Delete(lvConnections.Selected.Index);
  DisplayMessage(DateTimeToStr(Now) + ' : Deletedted from menu', dtConnectLog);
end;

destructor TFrameCommServer.Destroy;
begin
  DestroyVar;

  inherited;
end;

procedure TFrameCommServer.DestroyHttpServer;
begin
  if Assigned(FHTTPServer) then
    FreeAndNil(FHTTPServer);

  if Assigned(FRestServer) then
  begin
    if FRestMode = rmWebSocket then
      FRestServer := nil
    else
      FreeAndNil(FRestServer);
  end;

  if Assigned(FModel) then
    FreeAndNil(FModel);
end;

procedure TFrameCommServer.DestroyVar;
begin
  FCommUserList.Free;
  FPJHTimerPool.RemoveAll;
  FreeAndNil(FMessageQueue);
  FPJHTimerPool.Free;
end;

procedure TFrameCommServer.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
//var
//  LMemoHandle, LMemoCount: integer;
//  LMemo: TSynMemo;
begin
  if msg = ' ' then
  begin
    exit;
  end;

//  LMemo := nil;

  case ADspNo of
    dtSystemLog : begin
      with SMSysLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with

//      LMemo := SMSysLog;
    end;//dtSystemLog
    dtConnectLog: begin
      with SMUDPConnectLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with

//      LMemo := SMUDPConnectLog;
    end;//dtConnectLog
    dtCommLog: begin
      //SMCommLog.IsScrolling := true;
      with SMCommLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with

//      LMemo := SMCommLog;
    end;//dtCommLog

    dtStatusBar: begin
       AdvOfficeStatusBar1.SimplePanel := True;
       AdvOfficeStatusBar1.SimpleText := msg;
    end;//dtStatusBar
  end;//case

//  if Assigned(LMemo) then
//  begin
//    LMemo.SelStart := LMemo.GetTextLen;
//    LMemo.SelLength := 0;
//    LMemo.ScrollBy(0, LMemo.Lines.Count);
//    LMemo.Refresh;
//    SendMessage(LMemoHandle, EM_SCROLLCARET, 0, 0);
//    SendMessage(LMemoHandle, EM_LINESCROLL, 0, LMemoCount);
//  end;
end;

procedure TFrameCommServer.DisplayMessageFromOuter(msg: string;
  ADspNo: integer);
begin
  FMessageQueue.Enqueue(msg);
  PostMessage(Handle, WM_OnMemoMessage, ADspNo, 0);
end;

function TFrameCommServer.Get_HHI_IPAddr: string;
var
  i: integer;
begin
  Result := '';

  for i := 0 to ServerIpCombo.Items.Count - 1 do
  begin
    if LeftStr(ServerIpCombo.Items.Strings[i],3) = '10.' then
    begin
      Result := ServerIpCombo.Items.Strings[i];
      Break;
    end;
  end;
end;

procedure TFrameCommServer.InitVar;
begin
  FPJHTimerPool := TPJHTimerPool.Create(Self);
  FMessageQueue := TThreadSafeQueue.Create;
  ServerIpCombo.Items.Assign(GetLocalIPList);
  FCommUserList := TCommUser.Create(nil);

  if AutoStartCheck.Checked then
    FAutoStartTimerHandle := FPJHTimerPool.Add(OnAutoStartServer, 1000)
end;

procedure TFrameCommServer.MySessionClosed(ARemoteIP, ASessionID, AUserId: string);
begin
  DeleteConnectionFromLV(ARemoteIP, FPortName, ASessionID, AUserId);
end;

procedure TFrameCommServer.MySessionCreate(ARemoteIP, ASessionID, AUserId: string);
begin
  AddConnectionToLV(ARemoteIP, FPortName, ASessionID, AUserId);
end;

procedure TFrameCommServer.OnAutoStartServer(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  if AutoStartCheck.Checked then
  begin
    //server isn't running
    if (ServerStartBtn.Enabled) and (not ServerStopBtn.Enabled) and
          (not FIsServerActive) then
    begin
      if ElapsedTime > FAutoStartInterval then
      begin
        FPJHTimerPool.Remove(FAutoStartTimerHandle);
        FAutoStartTimerHandle := -1;
//        AutoStartCheck.Caption := 'Auto start after ' + IntToStr(FAutoStartInterval div 1000) + '  seconds';
        if Assigned(FStartServerProc) then
          FStartServerProc;
        AutoStartCheck.Caption := AutoStartCheck.Caption + '(Server start done.)';
      end
      else
      begin
        AutoStartCheck.Caption := 'Auto start after ' + IntToStr((FAutoStartInterval - ElapsedTime) div 1000) + ' seconds';
      end;
    end;
  end;
end;

procedure TFrameCommServer.OnMemoMessage(var Msg: TMessage);
var
  MessageValue: TAnyValue;
begin
  if Msg.WParam = 3 then
  begin
    while FMessageQueue.Dequeue(MessageValue) do
      DisplayMessage(MessageValue.AsString,TDisplayTarget(Msg.WParam));
  end
  else
  begin
    FMessageQueue.Dequeue(MessageValue);
    DisplayMessage(MessageValue.AsString,TDisplayTarget(Msg.WParam));
  end;
end;

procedure TFrameCommServer.ServerStartBtnClick(Sender: TObject);
begin
  FIpAddr := Get_HHI_IPAddr;
  FURL := 'http://' + FIpAddr + ':' + FPortName + '/' + FRootName + '/';
  ApplyStatus2Component;
end;

procedure TFrameCommServer.ServerStopBtnClick(Sender: TObject);
begin
  DestroyHttpServer;

  if FIsServerActive then
  begin
    FIsServerActive := False;
    ApplyStatus2Component;
  end;
end;

function TFrameCommServer.SessionClosed(Sender: TSQLRestServer;
  Session: TAuthSession; Ctxt: TSQLRestServerURIContext): boolean;
begin
  DeleteConnectionFromLV(Session.RemoteIP, FPortName, Session.ID, Session.User.LogonName);
  Result := False;
end;

function TFrameCommServer.SessionCreate(Sender: TSQLRestServer;
  Session: TAuthSession; Ctxt: TSQLRestServerURIContext): boolean;
begin
  AddConnectionToLV(Session.RemoteIP, FPortName, Session.ID, Session.User.LogonName);
  Result := False;
end;

procedure TFrameCommServer.ShowDebug1Click(Sender: TObject);
begin
  AllocConsole;
  TextColor(ccLightGray); // to force the console to be recognized
  with TSQLLog.Family do begin
    Level := LOG_VERBOSE;
    EchoToConsole := LOG_VERBOSE; // log all events to the console
  end;
end;

end.

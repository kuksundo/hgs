unit UnitFrameCromisIPCServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, TimerPool,
  // cromis units
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  AdvOfficeStatusBar, AdvOfficeStatusBarStylers, Vcl.ExtCtrls, Vcl.Menus,
  JvComponentBase, JvTrayIcon, JvExControls, JvXPCore, JvXPButtons, Vcl.ComCtrls;

const
  WM_OnMemoMessage = WM_USER + 1;
  WM_OnRequestFinished = WM_USER + 2;

type
  TStartServerProc = procedure of object;
  TCustomOnRequest = procedure(const Command: ICommContext; const Request, Response: IMessageData) of object;

  TFrameCromisIPCServer = class(TFrame)
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
    SMSysLog: TMemo;
    TabSheet5: TTabSheet;
    SMUDPConnectLog: TMemo;
    TabSheet6: TTabSheet;
    SMCommLog: TMemo;
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
    ServerIpCombo: TComboBox;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    JvTrayIcon1: TJvTrayIcon;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N5: TMenuItem;
    MenuItem4: TMenuItem;
    Timer1: TTimer;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    PopupMenu2: TPopupMenu;
    DeleteItem1: TMenuItem;
    procedure ServerStopBtnClick(Sender: TObject);
    procedure ServerStartBtnClick(Sender: TObject);
  private
    FRequestCount: Integer;
    FMessageQueue: TThreadSafeQueue;
    FPJHTimerPool: TPJHTimerPool;
    FAutoStartTimerHandle: integer;
    FOnCustomRequest: TCustomOnRequest;

    procedure OnAutoStartServer(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt); virtual;

    procedure WriteMsgToDisplay(const AMessage: string; ADispNo: integer);
    procedure OnClientConnect(const Context: ICommContext);
    procedure OnClientDisconnect(const Context: ICommContext);
    procedure OnServerError(const Context: ICommContext; const Error: TServerError);
    procedure OnExecuteRequest(const Context: ICommContext; const Request, Response: IMessageData);
    procedure OnRequestFinished(var Msg: TMessage); message WM_OnRequestFinished;
    procedure OnMemoMessage(var Msg: TMessage); message WM_OnMemoMessage;
  public
    FIPCServer: TIPCServer;
    FIPCServerName: string;
    FData: string;
    FAutoStartInterval: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DisplayMessage(msg: string; ADspNo: integer);
    procedure DisplayMessageFromOuter(msg: string; ADspNo: integer);
    procedure SetCustomOnRequest(AProc: TCustomOnRequest);
  end;

implementation

{$R *.dfm}

{ TFrame1 }

constructor TFrameCromisIPCServer.Create(AOwner: TComponent);
begin
  inherited;

  FPJHTimerPool := TPJHTimerPool.Create(Self);
  FMessageQueue := TThreadSafeQueue.Create;

  FIPCServer := TIPCServer.Create;
  FIPCServer.OnServerError := OnServerError;
  FIPCServer.OnClientConnect := OnClientConnect;
  FIPCServer.OnExecuteRequest := OnExecuteRequest;
  FIPCServer.OnClientDisconnect := OnClientDisconnect;

  if AutoStartCheck.Checked then
    FAutoStartTimerHandle := FPJHTimerPool.Add(OnAutoStartServer, 1000)
end;

destructor TFrameCromisIPCServer.Destroy;
begin
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  FreeAndNil(FIPCServer);
  FreeAndNil(FMessageQueue);

  inherited;
end;

procedure TFrameCromisIPCServer.DisplayMessage(msg: string; ADspNo: integer);
var
  LStr: string;
begin
  if msg = ' ' then
  begin
    exit;
  end;

  LStr := DateTimeToStr(now) + ' :: ' + msg;

  case ADspNo of
    0: begin
      with SMSysLog do
      begin
        if Lines.Count > 1000 then
          Clear;
        Lines.Add(LStr);
      end;//with
    end;//dtSystemLog
    1: begin
      with SMUDPConnectLog do
      begin
        if Lines.Count > 1000 then
          Clear;
        Lines.Add(LStr);
      end;//with
    end;//SMUDPConnectLog
    2: begin
      with SMCommLog do
      begin
        if Lines.Count > 1000 then
          Clear;
        Lines.Add(LStr);
      end;//with
    end;//SMCommLog
  end;
end;

procedure TFrameCromisIPCServer.DisplayMessageFromOuter(msg: string;
  ADspNo: integer);
begin
  FMessageQueue.Enqueue(msg);
  PostMessage(Handle, WM_OnMemoMessage, ADspNo, 0);
end;

procedure TFrameCromisIPCServer.OnAutoStartServer(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  if AutoStartCheck.Checked then
  begin
    //server isn't running
    if (ServerStartBtn.Enabled) and (not ServerStopBtn.Enabled) then
    begin
      if ElapsedTime > FAutoStartInterval then
      begin
        FPJHTimerPool.Remove(FAutoStartTimerHandle);
        FAutoStartTimerHandle := -1;

        if FIPCServerName = '' then
          FIPCServerName := 'CATV_IPC_Server';

        FIPCServer.ServerName := FIPCServerName;
        FIPCServer.Start;

        ServerIpCombo.Text := FIPCServer.ServerName;
        ServerStartBtn.Enabled := False;
        ServerStopBtn.Enabled := True;
        AutoStartCheck.Caption := AutoStartCheck.Caption + '(Server start done.)';
      end
      else
      begin
        AutoStartCheck.Caption := 'Auto start after ' + IntToStr((FAutoStartInterval - ElapsedTime) div 1000) + ' seconds';
      end;
    end;
  end;
end;

procedure TFrameCromisIPCServer.OnClientConnect(const Context: ICommContext);
begin
  FMessageQueue.Enqueue(Format('Client %s connected', [Context.Client.ID]));
  PostMessage(Handle, WM_OnMemoMessage, 1, 0);
end;

procedure TFrameCromisIPCServer.OnClientDisconnect(const Context: ICommContext);
begin
  FMessageQueue.Enqueue(Format('Client %s disconnected', [Context.Client.ID]));
  PostMessage(Handle, WM_OnMemoMessage, 1, 0);
end;

procedure TFrameCromisIPCServer.OnExecuteRequest(const Context: ICommContext; const Request,
  Response: IMessageData);
var
  Command: String;
  LocalCount: Integer;
begin
  Command := Request.Data.ReadUTF8String('Command');
  FMessageQueue.Enqueue(Format('%s request recieved from client %s (Sent at: %s)', [Command,
                                                                             Context.Client.ID,
                                                                             Request.ID]));
  PostMessage(Handle, WM_OnMemoMessage, 2, 0);

  if Assigned(FOnCustomRequest) then
    FOnCustomRequest(Context, Request, Response);

//  if UpperCase(Command) = 'GETBWQRYALL' then
//  begin
//    // increase the request count thread safe way
//    LocalCount := InterlockedIncrement(FRequestCount);
//
//    Response.ID := Format('Response nr. %d', [LocalCount]);
//    Response.Data.WriteDateTime('TDateTime', Now);
//    //  Response.Data.WriteInteger('Integer', 5);
//    //  Response.Data.WriteReal('Real', 5.33);
//    Response.Data.WriteUnicodeString('String', FData);
//
//    PostMessage(Handle, WM_OnRequestFinished, 0, 0);
//  end;
end;

procedure TFrameCromisIPCServer.OnMemoMessage(var Msg: TMessage);
var
  MessageValue: TAnyValue;
begin
  if Msg.WParam = 3 then
  begin
    while FMessageQueue.Dequeue(MessageValue) do
      DisplayMessage(MessageValue.AsString,Msg.WParam);
  end
  else
  begin
    FMessageQueue.Dequeue(MessageValue);
    DisplayMessage(MessageValue.AsString,Msg.WParam);
  end;
end;

procedure TFrameCromisIPCServer.OnRequestFinished(var Msg: TMessage);
var
  LocalCount: Integer;
begin
  InterlockedExchange(LocalCount, FRequestCount);
  Caption := Format('%d requests processed', [LocalCount]);
end;

procedure TFrameCromisIPCServer.OnServerError(const Context: ICommContext;
  const Error: TServerError);
begin
  FMessageQueue.Enqueue(Format('Server error: %d - %s', [Error.Code, Error.Desc]));
  PostMessage(Handle, WM_OnMemoMessage, 1, 0);
end;

procedure TFrameCromisIPCServer.ServerStartBtnClick(Sender: TObject);
begin
  FIPCServer.Start;
end;

procedure TFrameCromisIPCServer.ServerStopBtnClick(Sender: TObject);
begin
  FIPCServer.Stop;
end;

procedure TFrameCromisIPCServer.SetCustomOnRequest(AProc: TCustomOnRequest);
begin
  FOnCustomRequest := AProc;
end;

procedure TFrameCromisIPCServer.WriteMsgToDisplay(const AMessage: string; ADispNo: integer);
begin
  FMessageQueue.Enqueue(AMessage);
  PostMessage(Handle, WM_OnMemoMessage, ADispNo, 0);
end;

end.

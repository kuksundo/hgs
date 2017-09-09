{*******************************************************}
{                                                       }
{          IP Connections Service Version 2.7           }
{                                                       }
{          Copyright (c) 1999-2016 Vadim Crits          }
{                                                       }
{*******************************************************}

unit SvcMain;

{$R-}

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Menus, ActnList,
  ComCtrls, ImgList, SvcMgr, ScktComp, IPHlpApi, LVEx, NetUtils, NetBase;

type
  TConnForm = class(TBaseForm)
    ActionList: TActionList;
    actStart: TAction;
    actStop: TAction;
    PopupMenu1: TPopupMenu;
    actOpen: TAction;
    piOpen: TMenuItem;
    actExit: TAction;
    N2: TMenuItem;
    piExit: TMenuItem;
    N1: TMenuItem;
    piStart: TMenuItem;
    piStop: TMenuItem;
    StatusBar: TStatusBar;
    lvConnections: TListViewEx;
    ImageList: TImageList;
    actCloseConnection: TAction;
    PopupMenu2: TPopupMenu;
    piCloseConnection: TMenuItem;
    N3: TMenuItem;
    actAbout: TAction;
    piAbout: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure lvConnectionsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvConnectionsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actStartExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actCloseConnectionExecute(Sender: TObject);
    procedure actCloseConnectionUpdate(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
  private
    { Private declarations }
    FFromApp: Boolean;
    procedure ChangeIcon;
    procedure UpdateStatus;
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  public
    { Public declarations }
    procedure Initialize(FromApp: Boolean);
  end;

{ TConnService class }

  TConnService = class(TService)
  protected
    procedure Start(Sender: TService; var Started: Boolean);
    procedure Stop(Sender: TService; var Stopped: Boolean);
  public
    function GetServiceController: TServiceController; override;
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

  PConnRow = ^TConnRow;
  TConnRow = record
    State: TMibTcpState;
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwRemoteAddr: DWORD;
    dwRemotePort: DWORD;
    HostName: THostBuf;
    dtConnect: TDateTime;
    dtDisconnect: TDateTime;
    dwUId: DWORD;
  end;

{ TSpyThread class}

  TSpyThread = class(TThread)
  private
    FEvent: THandle;
  protected
    procedure Execute; override;
    function FoundListener: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TConnThread class }

  TConnThread = class(TThread)
  private
    FConnTable: TList;
    FConnRow: PConnRow;
    FUId: DWORD;
  protected
    procedure Execute; override;
    procedure AppendRowToLog;
    procedure AddConnect;
    procedure RemoveConnect;
    function GetUId: DWORD;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  ConnForm: TConnForm;
  ConnService: TConnService;
  ServerSocket: TServerSocket;
  SpyThread: TSpyThread;
  ConnThread: TConnThread;

implementation

uses CSConst, NetConst, NetAbout, WinSock, Types;

{$R *.dfm}

const
  SPY_TIMEOUT = 13000;

var
  ServerPort: DWORD;
  TimeOut: DWORD;
  LogFile: string;
  SingleLine: Boolean;
  ClientPort: DWORD;
  ComputerName: array[0..MAX_COMPUTERNAME_LENGTH] of Char;

{ TConnForm }

procedure TConnForm.FormCreate(Sender: TObject);
var
  StartupDir: string;
  SysMenu: HMENU;
  dwSize: DWORD;
begin
  with TStringList.Create do
  try
    StartupDir := Copy(ParamStr(0), 1, LastDelimiter(PathDelim, ParamStr(0)));
    try
      LoadFromFile(StartupDir + SCfgFile);
    except
      on E: Exception do
      begin
        MessageBox(0, PChar(E.Message), PChar(SServiceTitle), MB_OK or MB_ICONERROR);
        Halt;
      end;
    end;
    ServerPort := ntohs(StrToInt(Values[SServerPort]));
    LogFile := Values[SLogFile];
    TimeOut := StrToInt(Values[STimeOut]);
    SingleLine := StrToBool(Values[SSingleLine]);
    ClientPort := StrToInt(Values[SClientPort]);
  finally
    Free;
  end;
  SysMenu := GetSystemMenu(Handle, False);
  DeleteMenu(SysMenu, SC_MAXIMIZE, MF_BYCOMMAND);
  DeleteMenu(SysMenu, SC_MINIMIZE, MF_BYCOMMAND);
  DeleteMenu(SysMenu, SC_RESTORE, MF_BYCOMMAND);
  dwSize := SizeOf(ComputerName);
  GetComputerName(ComputerName, dwSize);
  Caption := SServiceTitle;
  UpdateStatus;
end;

procedure TConnForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  Action := caNone;
end;

procedure TConnForm.FormDestroy(Sender: TObject);
begin
  if FFromApp and actStop.Enabled then
    actStop.Execute;
  DeleteIcon;
end;

procedure TConnForm.lvConnectionsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if Data = -1 then
    Compare := AnsiCompareText(AlignIpAddress(Item1.Caption),
                               AlignIpAddress(Item2.Caption))
  else
    Compare := AnsiCompareText(Item1.SubItems[Data],
                               Item2.SubItems[Data]);
  if lvConnections.SortOrder = soDown then
    Compare := -Compare;
end;

procedure TConnForm.lvConnectionsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 65) and (Shift = [ssCtrl]) then
    lvConnections.SelectAll;
end;

procedure TConnForm.actStartExecute(Sender: TObject);
begin
  ServerSocket := TServerSocket.Create(Self);
  ServerSocket.Port := ClientPort;
  ServerSocket.OnClientRead := ServerSocketClientRead;
  ServerSocket.OnClientError := ServerSocketClientError;
  ServerSocket.Open;
  SpyThread := TSpyThread.Create;
  actStart.Enabled := False;
  actStop.Enabled := not actStart.Enabled;
end;

procedure TConnForm.actStopExecute(Sender: TObject);
begin
  with SpyThread do
  begin
    SetEvent(FEvent);
    Terminate;
    WaitFor;
    Free;
  end;
  ServerSocket.Free;
  actStop.Enabled := False;
  actStart.Enabled := not actStop.Enabled;
  if FFromApp then
  begin
    with lvConnections.Items do
    begin
      BeginUpdate;
      try
        Clear;
      finally
        EndUpdate;
      end;
    end;
    ChangeIcon;
    UpdateStatus;
  end;
end;

procedure TConnForm.actOpenExecute(Sender: TObject);
begin
  if Visible then
    SetForegroundWindow(Forms.Application.Handle)
  else
    Show;
  with Forms.Application do
    if IsIconic(Handle) then
    begin
      Restore;
      BringToFront;
    end;
end;

procedure TConnForm.actAboutExecute(Sender: TObject);
begin
  ShowAboutDialog(Self);
end;

procedure TConnForm.actExitExecute(Sender: TObject);
begin
  Forms.Application.Terminate;
end;

procedure TConnForm.actCloseConnectionExecute(Sender: TObject);
var
  I: Integer;
begin
  for I := lvConnections.Items.Count - 1 downto 0 do
    with lvConnections.Items[I] do
      if Selected then
      begin
        PMibTcpRow(Data)^.State := MIB_TCP_STATE_DELETE_TCB;
        SetTcpEntry(PMibTcpRow(Data));
      end;
end;

procedure TConnForm.actCloseConnectionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := lvConnections.SelCount > 0;
end;

procedure TConnForm.UpdateStatus;
begin
  StatusBar.SimpleText := Format(SCurrentConnections, [lvConnections.Items.Count]);
end;

procedure TConnForm.ChangeIcon;
const
  ResNames: array[Boolean] of string = ('MAINICON', 'MAINICON1');
begin
  with lvConnections.Items do
  begin
    Forms.Application.Icon.Handle := LoadIcon(HInstance, PChar(ResNames[Count > 0]));
    ModifyIcon(Format(SServiceTip, [Count]));
  end;
end;

procedure TConnForm.Initialize(FromApp: Boolean);
begin
  FFromApp := FromApp;
  if FromApp then
    actStart.Execute
  else
  begin
    N1.Visible := False;
    actStart.Visible := False;
    actStop.Visible := False;
    N2.Visible := False;
    actExit.Visible := False;
  end;
  TrayMenu := PopupMenu1;
  OnTrayDblClick := actOpenExecute;
  AddIcon(Format(SServiceTip, [lvConnections.Items.Count]));
end;

procedure TConnForm.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  RecvLen, TextLen, BufLen, I: Integer;
  Buffer: Pointer;
  dwUId: DWORD;
begin
  with Socket do
  begin
    RecvLen := ReceiveLength;
    GetMem(Buffer, RecvLen);
    try
      RecvLen := ReceiveBuf(Buffer^, RecvLen);
      if RecvLen > 0 then
        case PDWORD(Buffer)^ of
          acGetConnTable:
            with TStringList.Create do
            try
              for I := 0 to lvConnections.Items.Count - 1 do
                with lvConnections.Items[I] do
                  Add(Caption + cFldSep + SubItems[0] + cFldSep +
                      SubItems[1] + cFldSep + IntToStr(PConnRow(Data)^.dwUId));
              TextLen := Length(Text) * SizeOf(Char);
              BufLen := (AC_SIZE * 2) + TextLen;
              ReallocMem(Buffer, BufLen);
              PDWORD(Buffer)^ := acResult;
              PDWORD(DWORD(Buffer) + AC_SIZE)^ := TextLen;
              if TextLen > 0 then
                CopyMemory(PDWORD(DWORD(Buffer) + (AC_SIZE * 2)), @Text[1], TextLen);
              SendBuf(Buffer^, BufLen);
            finally
              Free;
            end;
          acCloseConnect:
            begin
              dwUId := PDWORD(DWORD(Buffer) + AC_SIZE)^;
              with lvConnections do
                for I := 0 to Items.Count - 1 do
                  with Items[I] do
                    if PConnRow(Data)^.dwUId = dwUId then
                    begin
                      PMibTcpRow(Data)^.dwState := Ord(MIB_TCP_STATE_DELETE_TCB);
                      SetTcpEntry(Data);
                      Break;
                    end;
            end;
        end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

procedure TConnForm.ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

{ TConnService }

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ConnService.Controller(CtrlCode);
end;

function TConnService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

constructor TConnService.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner, Dummy);
  AllowPause := False;
  Interactive := True;
  DisplayName := SServiceTitle;
  Name := SServiceName;
  StartType := stManual;
  OnStart := Start;
  OnStop := Stop;
end;

procedure TConnService.Start(Sender: TService; var Started: Boolean);
begin
  ConnForm.actStart.Execute;
  Started := True;
end;

procedure TConnService.Stop(Sender: TService; var Stopped: Boolean);
begin
  ConnForm.actStop.Execute;
  PostMessage(ConnForm.Handle, WM_QUIT, 0, 0);
  Stopped := True;
end;

{ TSpyThread }

constructor TSpyThread.Create;
begin
  FEvent := CreateEvent(nil, False, False, nil);
  inherited Create(False);
end;

destructor TSpyThread.Destroy;
begin
  CloseHandle(FEvent);
  inherited Destroy;
end;

procedure TSpyThread.Execute;
begin
  while True do
  begin
    if not FoundListener or Terminated then
    begin
      if Assigned(ConnThread) then
      begin
        ConnThread.Terminate;
        ConnThread.WaitFor;
        FreeAndNil(ConnThread);
      end;
    end
    else if not Assigned(ConnThread) then
      ConnThread := TConnThread.Create;
    if Terminated then
      Break;
    WaitForSingleObject(FEvent, SPY_TIMEOUT);
  end;
end;

function TSpyThread.FoundListener: Boolean;
var
  Sock: TSocket;
  Addr: TSockAddrIn;
  LastErr: Integer;
begin
  Result := False;
  Sock := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  if Sock <> INVALID_SOCKET then
  try
    Addr.sin_family := AF_INET;
    Addr.sin_port := ServerPort;
    Addr.sin_addr.S_addr := INADDR_ANY;
    if bind(Sock, Addr, SizeOf(Addr)) = SOCKET_ERROR then
    begin
      LastErr := WSAGetLastError;
      if (LastErr = WSAEADDRINUSE) or (LastErr = WSAEACCES) then
        Result := True;
    end;
  finally
    closesocket(Sock);
  end;
end;

{ TConnThread }

constructor TConnThread.Create;
begin
  FConnTable := TList.Create;
  FUId := 0;
  inherited Create(False);
end;

destructor TConnThread.Destroy;
var
  P: Pointer;
begin
  with FConnTable do
  begin
    while Count > 0 do
    begin
      P := Last;
      Remove(P);
      Dispose(P);
    end;
    Free;
  end;
  inherited Destroy;
end;

procedure TConnThread.Execute;
var
  TcpTable: PMibTcpTable;
  dwSize, dwResult: DWORD;
  I, J: Integer;
  NewConnect: Boolean;
  Addr: TSockAddrIn;
  HostBuf: THostBuf;
begin
  while not Terminated do
  begin
    dwSize := 0;
    GetTcpTable(nil, @dwSize, False);
    if dwSize = 0 then
      Continue;
    TcpTable := AllocMem(dwSize);
    try
      dwResult := GetTcpTable(TcpTable, @dwSize, False);
      if dwResult <> NO_ERROR then
        Continue;
      with FConnTable do
      begin
        for I := 0 to Count - 1 do
          PConnRow(items[I])^.State := MIB_TCP_STATE_CLOSED;
        with TcpTable^ do
          for I := 0 to dwNumEntries - 1 do
            if (table[I].State = MIB_TCP_STATE_ESTAB) and
              (table[I].dwLocalPort = ServerPort) then
            begin
              NewConnect := True;
              for J := 0 to Count - 1 do
                if (table[I].dwLocalAddr = PConnRow(items[J])^.dwLocalAddr) and
                  (table[I].dwLocalPort = PConnRow(items[J])^.dwLocalPort) and
                  (table[I].dwRemoteAddr = PConnRow(items[J])^.dwRemoteAddr) and
                  (table[I].dwRemotePort = PConnRow(items[J])^.dwRemotePort) then
                begin
                  NewConnect := False;
                  PConnRow(items[J])^.State := table[I].State;
                  Break;
                end;
              if NewConnect then
              begin
                New(FConnRow);
                CopyMemory(FConnRow, @table[I], SizeOf(TMibTcpRow));
                FillChar(Addr, SizeOf(Addr), 0);
                Addr.sin_family := AF_INET;
                Addr.sin_addr.S_addr := FConnRow^.dwRemoteAddr;
                if getnameinfo(@Addr, SizeOf(Addr), HostBuf, NI_MAXHOST, nil, 0, NI_NAMEREQD) = 0 then
                  CopyMemory(@FConnRow^.HostName, @HostBuf, SizeOf(HostBuf))
                else
                  CopyMemory(@FConnRow^.HostName, PChar(SUnknown), Length(SUnknown));
                FConnRow^.dtConnect := Now;
                FConnRow^.dtDisconnect := 0;
                FConnRow^.dwUId := GetUId;
                FConnTable.Add(FConnRow);
                Synchronize(AddConnect);
                if not SingleLine then
                  AppendRowToLog;
              end;
            end;
        for I := Count - 1 downto 0 do
          if PConnRow(items[I])^.State = MIB_TCP_STATE_CLOSED then
          begin
            FConnRow := items[I];
            FConnRow^.dtDisconnect := Now;
            AppendRowToLog;
            Synchronize(RemoveConnect);
            FConnTable.Remove(FConnRow);
            Dispose(FConnRow);
          end;
      end;
    finally
      FreeMem(TcpTable);
    end;
    Sleep(TimeOut);
  end;
end;

procedure TConnThread.AppendRowToLog;
var
  FileHandle: THandle;
  LogStr: string;
  lpNumberOfBytesWritten: DWORD;
begin
  FileHandle := CreateFile(PChar(LogFile),
                           GENERIC_READ or GENERIC_WRITE,
                           FILE_SHARE_READ or FILE_SHARE_WRITE,
                           nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
  try
    if SingleLine then
      LogStr := Format(SSingleFmtStr, [FormatIpAddress(FConnRow^.dwRemoteAddr),
                                       FConnRow^.HostName,
                                       FormatDateTime(SDTSingleFmtStr, FConnRow^.dtConnect),
                                       FormatDateTime(SDTSingleFmtStr, FConnRow^.dtDisconnect)])
    else if FConnRow^.dtDisconnect = 0 then
      LogStr := Format(SFmtStr, [ComputerName, FormatDateTime(SDTFmtStr, FConnRow^.dtConnect),
                                 SServiceTitle, SConnect, FormatIpAddress(FConnRow^.dwRemoteAddr),
                                 FConnRow^.HostName])
    else
      LogStr := Format(SFmtStr, [ComputerName, FormatDateTime(SDTFmtStr, FConnRow^.dtDisconnect),
                                 SServiceTitle, SDisconnect, FormatIpAddress(FConnRow^.dwRemoteAddr),
                                 FConnRow^.HostName]);
    SetFilePointer(FileHandle, 0, nil, FILE_END);
    WriteFile(FileHandle, PAnsiChar(AnsiString(LogStr))^, Length(LogStr), lpNumberOfBytesWritten, nil);
  finally
    CloseHandle(FileHandle);
  end;
end;

procedure TConnThread.AddConnect;
begin
  with ConnForm, lvConnections do
  begin
    with Items.Add do
    begin
      ImageIndex := 0;
      Caption := FormatIpAddress(FConnRow^.dwRemoteAddr);
      SubItems.Add(string(FConnRow^.HostName));
      SubItems.Add(FormatDateTime(SDTFmtStr, FConnRow^.dtConnect));
      Data := FConnRow;
    end;
    if not Assigned(ItemFocused) then
      Items[0].Focused := True;
    ChangeIcon;
    UpdateStatus;
  end;
end;

procedure TConnThread.RemoveConnect;
var
  Item: TListItem;
begin
  with ConnForm do
  begin
    Item := lvConnections.FindData(0, FConnRow, True, False);
    if Assigned(Item) then
      Item.Delete;
    ChangeIcon;
    UpdateStatus;
  end;
end;

function TConnThread.GetUId: DWORD;
begin
  if FUId = MAXDWORD then
    FUId := 0;
  Inc(FUId);
  Result := FUId;
end;

initialization
  Forms.Application.Title := SServiceTitle;
  SetThreadLocale($0409);
  GetFormatSettings;
  SetPriorityClass(GetCurrentProcess, IDLE_PRIORITY_CLASS);
end.

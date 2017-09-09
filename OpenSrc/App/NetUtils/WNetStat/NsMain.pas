{*******************************************************}
{                                                       }
{                  WNetStat Version 2.7                 }
{                                                       }
{          Copyright (c) 1999-2016 Vadim Crits          }
{                                                       }
{*******************************************************}

unit NsMain;

{$B-,R-}
{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, ToolWin, ExtCtrls, ImgList, ActnList, WinSock, IPHlpApi,
  CBEx, LVEx, NetBase;

type
  TStatType = (stNic, stArp, stIpAddr, stRoute, stConnections, stIf, stIp,
    stIcmp, stTcp, stUdp);

  TMainForm = class(TBaseForm)
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    StatusBar: TStatusBar;
    ListViewImages: TImageList;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    N1: TMenuItem;
    miExit: TMenuItem;
    miAbout: TMenuItem;
    miRefresh: TMenuItem;
    ListView: TListViewEx;
    TrayPopup: TPopupMenu;
    piOpen: TMenuItem;
    N9: TMenuItem;
    piExit: TMenuItem;
    miToolBar: TMenuItem;
    miStatusBar: TMenuItem;
    N2: TMenuItem;
    miConnections: TMenuItem;
    miIP: TMenuItem;
    miICMP: TMenuItem;
    miTCP: TMenuItem;
    miUDP: TMenuItem;
    miInterface: TMenuItem;
    miRoute: TMenuItem;
    ActionList: TActionList;
    actSave: TAction;
    actSaveAs: TAction;
    actExit: TAction;
    actToolBar: TAction;
    actStatusBar: TAction;
    actAbout: TAction;
    actByName: TAction;
    actAllEndpoints: TAction;
    ToolBar: TToolBar;
    btnSave: TToolButton;
    ToolButton1: TToolButton;
    btnRefresh: TToolButton;
    ToolButton2: TToolButton;
    btnStatistics: TToolButton;
    ToolBarPopup: TPopupMenu;
    actConnections: TAction;
    actIP: TAction;
    actICMP: TAction;
    actTCP: TAction;
    actUDP: TAction;
    actInterface: TAction;
    actRoute: TAction;
    actRefresh: TAction;
    tbrImages: TImageList;
    tbrHotImages: TImageList;
    actOpen: TAction;
    actTerminate: TAction;
    actNIC: TAction;
    actARP: TAction;
    actIPAddress: TAction;
    miARP: TMenuItem;
    miIPAddress: TMenuItem;
    miNIC: TMenuItem;
    N3: TMenuItem;
    actCloseConnection: TAction;
    Timer: TTimer;
    actOptions: TAction;
    N6: TMenuItem;
    miOptions: TMenuItem;
    actAutoRefresh: TAction;
    AutoRefresh1: TMenuItem;
    N5: TMenuItem;
    CoolBar: TCoolBarEx;
    MenuBar: TToolBar;
    ListViewPopup: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewInsert(Sender: TObject; Item: TListItem);
    procedure ListViewDeletion(Sender: TObject; Item: TListItem);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actToolBarExecute(Sender: TObject);
    procedure actStatusBarExecute(Sender: TObject);
    procedure actByNameExecute(Sender: TObject);
    procedure actAllEndpointsExecute(Sender: TObject);
    procedure actCloseConnectionExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actTerminateExecute(Sender: TObject);
    procedure ActionExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure btnStatisticsClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure actAutoRefreshExecute(Sender: TObject);
    procedure ListViewPopupPopup(Sender: TObject);
  private
    { Private declarations }
    FDone: Boolean;
    FViewChanged: Boolean;
    FAppendStatistics: Boolean;
    FAutoSave: Boolean;
    FCloseToTray: Boolean;
    FStatType: TStatType;
    FIfIndex: Integer;
    FFileName: string;
    procedure ApplicationActivate(Sender: TObject);
    procedure PopupClick(Sender: TObject);
    function GetActionIndexByTag(ATag: Integer): Integer;
    function GetFormattedAddress(Family: TAddressFamily; Port: DWORD;
      IpAddress: Pointer; ScopeId: ULONG; Local: Boolean; Data: Pointer = nil): string;
    function GetProcessNameByPId(PId: DWORD): string;
    procedure GetNicTable(ReNew: Boolean);
    procedure GetArpTable(ReNew: Boolean);
    procedure GetIpAddressTable(ReNew: Boolean);
    procedure GetRouteTable(ReNew: Boolean);
    procedure GetConnectionsTable(ReNew: Boolean);
    procedure GetIfStats(ReNew: Boolean);
    procedure GetIpStats(ReNew: Boolean);
    procedure GetIcmpStats(ReNew: Boolean);
    procedure GetTcpStats(ReNew: Boolean);
    procedure GetUdpStats(ReNew: Boolean);
    procedure MkFile(const FileName: string; CreationFlag: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses NsOptions, NsConst, NetConst, NetUtils, NetAbout, TlHelp32
  {$IF CompilerVersion > 24}, AnsiStrings{$IFEND};

{$R *.dfm}

type
  PTcpData = ^TTcpData;
  TTcpData = record
    case Integer of
      0: (TcpRow: TMibTcpRowOwnerPid);
      1: (Tcp6Row: TMibTcp6RowOwnerPid;
          NameInfoThread: TThread;
          ResolveResult: Integer;
          HostBuf: THostBuf);
  end;

var
  LocalHost: THostBuf;
  GetIpNetTable2: function(Family: TAddressFamily;
    var Table: PMibIpNetTable2): NETIOAPI_API; stdcall;
  GetUnicastIpAddressTable: function(Family: TAddressFamily;
    var Table: PMibUnicastIpAddressTable): NETIOAPI_API; stdcall;
  GetIpForwardTable2: function(Family: TAddressFamily;
    var Table: PMibIpForwardTable2): NETIOAPI_API; stdcall;
  GetIpInterfaceTable: function(Family: TAddressFamily;
    var Table: PMibIpInterfaceTable): NETIOAPI_API; stdcall;
  FreeMibTable: procedure(Memory: Pointer); stdcall;

procedure InitNetIoApi;
var
  hLib: THandle;
begin
  hLib := GetModuleHandle('iphlpapi.dll');
  @GetIpNetTable2 := GetProcAddress(hLib, 'GetIpNetTable2');
  @GetUnicastIpAddressTable := GetProcAddress(hLib, 'GetUnicastIpAddressTable');
  @GetIpForwardTable2 := GetProcAddress(hLib, 'GetIpForwardTable2');
  @GetIpInterfaceTable := GetProcAddress(hLib, 'GetIpInterfaceTable');
  @FreeMibTable := GetProcAddress(hLib, 'FreeMibTable');
end;

procedure EnableDebugPrivilege;
var
  hToken: THandle;
  TokenPrivileges: TTokenPrivileges;
  ReturnLength: DWORD;
begin
  if OpenProcessToken(GetCurrentProcess,
    TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  try
    if LookupPrivilegeValue(nil, 'SeDebugPrivilege',
      TokenPrivileges.Privileges[0].Luid) then
    begin
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      ReturnLength := 0;
      AdjustTokenPrivileges(hToken, False, TokenPrivileges, 0, nil, ReturnLength);
    end;
  finally
    CloseHandle(hToken);
  end;
end;

procedure CheckIpHelperResult(ResultCode: DWORD);
begin
  if ResultCode <> NO_ERROR then
    raise Exception.Create(SysErrorMessage(ResultCode));
end;

{ TNameInfoThread }

type
  TNameInfoThread = class(TThread)
  private
    FAddr: PSockAddr;
    FAddrSize: Integer;
    FData: Pointer;
    procedure ModifyRow;
  protected
    procedure Execute; override;
  public
    constructor Create(Addr: PSockAddr; AddrSize: Integer;
      Data: Pointer);
    destructor Destroy; override;
  end;

constructor TNameInfoThread.Create(Addr: PSockAddr; AddrSize: Integer;
  Data: Pointer);
begin
  FAddr := AllocMem(AddrSize);
  CopyMemory(FAddr, Addr, AddrSize);
  FAddrSize := AddrSize;
  FData := Data;
  FreeOnTerminate := True;
  inherited Create(False);
  Priority := tpIdle;
end;

destructor TNameInfoThread.Destroy;
begin
  FreeMem(FAddr, FAddrSize);
  inherited Destroy;
end;

procedure TNameInfoThread.ModifyRow;
var
  Item: TListItem;
begin
  with MainForm do
    if actByName.Checked then
    begin
      Item := ListView.FindData(0, FData, True, False);
      if Assigned(Item) then
        with Item do
          SubItems[1] := string(PTcpData(Data)^.HostBuf) + Copy(SubItems[1],
            Pos(':', SubItems[1]), MaxInt);
    end;
end;

procedure TNameInfoThread.Execute;
var
  RetVal: Integer;
begin
  RetVal := getnameinfo(FAddr, FAddrSize, PTcpData(FData)^.HostBuf,
    NI_MAXHOST, nil, 0, NI_NAMEREQD);
  if not Terminated then
    with PTcpData(FData)^ do
    begin
      ResolveResult := RetVal;
      if ResolveResult = 0 then
        Synchronize(ModifyRow);
      NameInfoThread := nil;
    end;
end;

{ TMainForm }

function TMainForm.GetActionIndexByTag(ATag: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  with ActionList do
    for I := 0 to ActionCount - 1 do
      if ((Actions[I] as TAction).GroupIndex = 1) and (Actions[I].Tag = ATag) then
        Result := Actions[I].Index;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  RetVal: Integer;
  WSAData: TWSAData;
begin
  RetVal := WSAStartup($0202, WSAData);
  if RetVal <> 0 then
    with Application do
    begin
      MessageBox(PChar(SysErrorMessage(RetVal)), PChar(Title),
                 MB_OK or MB_ICONERROR);
      ShowMainForm := False;
      Terminate;
    end;
  with Registry do
    if OpenKey(ApplicationKey, False) then
    try
      if ValueExists(SShowToolBar) then
        ToolBar.Visible := ReadBool(SShowToolBar);
      if ValueExists(SShowStatusBar) then
        StatusBar.Visible := ReadBool(SShowStatusBar);
      if ValueExists(SShowByName) then
        actByName.Checked := ReadBool(SShowByName);
      if ValueExists(SShowAllEndpoints) then
        actAllEndpoints.Checked := ReadBool(SShowAllEndpoints);
      if ValueExists(SAutoRefresh) then
        actAutoRefresh.Checked := ReadBool(SAutoRefresh);
      if ValueExists(SAppendStatistics) then
        FAppendStatistics := ReadBool(SAppendStatistics);
      if ValueExists(SAutoSave) then
        FAutoSave := ReadBool(SAutoSave);
      if ValueExists(SCloseToTray) then
      begin
        FCloseToTray := ReadBool(SCloseToTray);
        if FCloseToTray then
        begin
          TrayMenu := TrayPopup;
          OnTrayDblClick := actOpenExecute;
          AddIcon;
          actExit.Caption := SClose;
        end;
      end;
      if ValueExists(SStatType) then
        FStatType := TStatType(ReadInteger(SStatType));
      if ValueExists(SInterval) then
        Timer.Interval := ReadInteger(SInterval);
      if ValueExists(SLastFile) then
      begin
        FFileName := ReadString(SLastFile);
        if FFileName <> '' then
          Caption := Format('%s - %s', [Application.Title, FFileName]);
      end;
    finally
      CloseKey;
    end;
  Application.OnActivate := ApplicationActivate;
  gethostname(LocalHost, NI_MAXHOST);
  ListView.SortImmediately := False;
  FDone := True;
end;

procedure TMainForm.ApplicationActivate(Sender: TObject);
begin
  if ListView.Columns.Count = 0 then
  begin
    with MenuBar, Buttons[ButtonCount - 1] do
      if Left + Width > MenuBar.Width then
        MenuBar.Width := Left + Width;
    actRefresh.Execute;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCloseToTray then
  begin
    if FDone then
      Hide;
    Action := caNone;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  with Registry do
    if OpenKey(ApplicationKey, True) then
    try
      WriteBool(SShowToolBar, ToolBar.Visible);
      WriteBool(SShowStatusBar, StatusBar.Visible);
      WriteBool(SShowByName, actByName.Checked);
      WriteBool(SShowAllEndpoints, actAllEndpoints.Checked);
      WriteBool(SAutoRefresh, actAutoRefresh.Checked);
      WriteBool(SAppendStatistics, FAppendStatistics);
      WriteBool(SAutoSave, FAutoSave);
      WriteBool(SCloseToTray, FCloseToTray);
      WriteInteger(SStatType, Ord(FStatType));
      WriteInteger(SInterval, Timer.Interval);
      WriteString(SLastFile, FFileName);
    finally
      CloseKey;
    end;
  WSACleanup;
end;

procedure TMainForm.ListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if Data = -1 then
    Compare := AnsiCompareText(Item1.Caption,
                               Item2.Caption)
  else if ((FStatType = stNic) and (Data = 0)) or
    ((FStatType = stArp) and (Data in [1, 2])) or
    ((FStatType = stConnections) and (actByName.Checked or (Data in [2, 3]))) or
    ((FStatType in [stIp..stUdp]) and (Data = 0)) then
    Compare := AnsiCompareText(Item1.SubItems[Data],
                               Item2.SubItems[Data])
  else if ((FStatType in [stArp..stRoute]) and (Data = 0)) or
    ((FStatType = stIpAddr) and (Data = 1)) or
    ((FStatType = stRoute) and (Data <> 4)) then
    Compare := AnsiCompareText(AlignIpAddress(Item1.SubItems[Data]),
                               AlignIpAddress(Item2.SubItems[Data]))
  else if (FStatType = stConnections) and not actByName.Checked and (Data <> 2) then
    Compare := AnsiCompareText(AlignAddress(Item1.SubItems[Data]),
                               AlignAddress(Item2.SubItems[Data]))
  else
    Compare := AnsiCompareText(AlignString(Item1.SubItems[Data]),
                               AlignString(Item2.SubItems[Data]));
  if ListView.SortOrder = soDown then
    Compare := -Compare;
end;

procedure TMainForm.ListViewInsert(Sender: TObject; Item: TListItem);
begin
  if not Assigned(ListView.ItemFocused) then
    ListView.ItemFocused := Item;
end;

procedure TMainForm.ListViewDeletion(Sender: TObject; Item: TListItem);
begin
  if Assigned(Item.Data) then
  begin
    if (Item.Caption = STcpv4) or (Item.Caption = STcpv6) then
      with PTcpData(Item.Data)^ do
        if Assigned(NameInfoThread) then
          NameInfoThread.Terminate;
    FreeMem(Item.Data);
  end;
end;

procedure TMainForm.actSaveExecute(Sender: TObject);
begin
  if not FDone then
    Exit;
  if FFileName = '' then
    actSaveAs.Execute
  else
    MkFile(FFileName, not FAppendStatistics or not FileExists(FFileName));
end;

procedure TMainForm.actSaveAsExecute(Sender: TObject);
begin
  with TSaveDialog.Create(Self) do
  try
    Options := [ofEnableSizing, ofOverwritePrompt];
    DefaultExt := SDefExt;
    if FFileName = '' then
      FileName := '*' + DefaultExt
    else
      FileName := FFileName;
    Filter := Format(SFileFilter, [DefaultExt, DefaultExt]);
    if Execute then
    begin
      MkFile(FileName, True);
      Caption := Format('%s - %s', [Application.Title, FileName]);
      FFileName := FileName;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.actToolBarExecute(Sender: TObject);
begin
  ToolBar.Visible := not ToolBar.Visible;
end;

procedure TMainForm.actStatusBarExecute(Sender: TObject);
begin
  StatusBar.Visible := not StatusBar.Visible;
end;

procedure TMainForm.actByNameExecute(Sender: TObject);
begin
  if not FDone then
    Exit;
  actByName.Checked := not actByName.Checked;
  FViewChanged := True;
  actRefresh.Execute;
end;

procedure TMainForm.actAllEndpointsExecute(Sender: TObject);
begin
  if not FDone then
    Exit;
  actAllEndpoints.Checked := not actAllEndpoints.Checked;
  actRefresh.Execute;
end;

procedure TMainForm.actCloseConnectionExecute(Sender: TObject);
begin
  with ListView.Selected do
  begin
    PMibTcpRow(Data)^.dwState := Ord(MIB_TCP_STATE_DELETE_TCB);
    CheckIpHelperResult(SetTcpEntry(PMibTcpRow(Data)));
    Delete;
  end;
end;

procedure TMainForm.actRefreshExecute(Sender: TObject);
begin
  ActionList.Actions[GetActionIndexByTag(Ord(FStatType))].Execute;
end;

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  ShowAboutDialog(Self);
end;

procedure TMainForm.actOpenExecute(Sender: TObject);
begin
  if Visible then
    SetForegroundWindow(Application.Handle)
  else
    Show;
  with Application do
    if IsIconic(Handle) then
    begin
      Restore;
      BringToFront;
    end;
end;

procedure TMainForm.actTerminateExecute(Sender: TObject);
begin
  DeleteIcon;
  Application.Terminate;
end;

procedure TMainForm.ActionExecute(Sender: TObject);
var
  SaveCursor: TCursor;
  StatType: TStatType;
  ReNew: Boolean;
begin
  if not FDone then
    Exit;
  FDone := False;
  StatusBar.Panels[0].Text := SUpdating;
  StatusBar.Panels[1].Text := (Sender as TAction).Hint;
  Application.ProcessMessages;
  SaveCursor := Screen.Cursor;
  try
    Screen.Cursor := crAppStart;
    StatType := TStatType(TAction(Sender).Tag);
    ReNew := (StatType <> FStatType) or (ListView.Columns.Count = 0);
    if ReNew then
      FIfIndex := -1;
    with ListView do
    begin
      if ReNew then
      begin
        Items.BeginUpdate;
        try
          Items.Clear;
        finally
          Items.EndUpdate;
        end;
        Columns.BeginUpdate;
        try
          Columns.Clear;
        finally
          Columns.EndUpdate;
        end;
      end;
      case StatType of
        stNic:
          GetNicTable(ReNew);
        stArp:
          GetArpTable(ReNew);
        stIpAddr:
          GetIpAddressTable(ReNew);
        stRoute:
          GetRouteTable(ReNew);
        stConnections:
          GetConnectionsTable(ReNew);
        stIf:
          GetIfStats(ReNew);
        stIp:
          GetIpStats(ReNew);
        stIcmp:
          GetIcmpStats(ReNew);
        stTcp:
          GetTcpStats(ReNew);
        stUdp:
          GetUdpStats(ReNew);
      end;
      if SortColumn <> - 1 then
        CustomSort(nil, SortColumn - 1);
    end;
    FStatType := StatType;
    FViewChanged := False;
  finally
    FDone := True;
    StatusBar.Panels[0].Text := SReady;
    Screen.Cursor := SaveCursor;
  end;
end;

procedure TMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actToolBar.Checked := ToolBar.Visible;
  actStatusBar.Checked := StatusBar.Visible;
  actCloseConnection.Enabled := (FStatType = stConnections) and
    Assigned(ListView.Selected) and (ListView.Selected.Caption = STcpv4) and
    (ListView.Selected.SubItems[2] = TcpStateNames[MIB_TCP_STATE_ESTAB]);
  if (Action as TAction).GroupIndex = 1 then
    (Action as TAction).Checked := Action.Tag = Ord(FStatType);
  actByName.Enabled := actConnections.Checked;
  actAllEndpoints.Enabled := actConnections.Checked;
  Timer.Enabled := actAutoRefresh.Checked;
end;

procedure TMainForm.btnStatisticsClick(Sender: TObject);
var
  Tag: Integer;
begin
  Tag := Ord(FStatType);
  if FStatType = stUdp then
    Tag := -1;
  ActionList.Actions[GetActionIndexByTag(Tag + 1)].Execute;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  actRefresh.Execute;
  if FAutoSave and (FFileName <> '') then
    actSave.Execute;
end;

procedure TMainForm.actOptionsExecute(Sender: TObject);
begin
  with TOptionsDialog.Create(Self) do
  try
    udInterval.Position := Timer.Interval div MSecsPerSec;
    chkAppendStatistics.Checked := FAppendStatistics;
    chkAutoSave.Checked := FAutoSave;
    chkCloseToTray.Checked := FCloseToTray;
    ShowModal;
    if ModalResult = mrOk then
    begin
      Timer.Interval := udInterval.Position * MSecsPerSec;
      FAppendStatistics := chkAppendStatistics.Checked;
      FAutoSave := chkAutoSave.Checked;
      FCloseToTray := chkCloseToTray.Checked;
      if FCloseToTray then
      begin
        TrayMenu := TrayPopup;
        OnTrayDblClick := actOpenExecute;
        AddIcon;
        actExit.Caption := SClose;
      end
      else
      begin
        DeleteIcon;
        TrayMenu := nil;
        OnTrayDblClick := nil;
        actExit.Caption := SExit;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.actAutoRefreshExecute(Sender: TObject);
begin
  actAutoRefresh.Checked := not actAutoRefresh.Checked;
end;

function TMainForm.GetFormattedAddress(Family: TAddressFamily; Port: DWORD;
  IpAddress: Pointer; ScopeId: ULONG; Local: Boolean; Data: Pointer = nil): string;

  function FillAddress(var Addr: TSockAddrInet): Integer;
  begin
    with Addr do
    begin
      si_family := Family;
      if si_family = AF_INET then
        with Ipv4 do
        begin
          sin_port := Port;
          sin_addr.S_un.S_addr := PDWORD(IpAddress)^;
          if not Local and IsZeroIpAddress(Addr) then
            sin_port := 0;
          Result := SizeOf(TSockAddrIn);
        end
      else
        with Ipv6 do
        begin
          sin6_port := Port;
          sin6_scope_id := ScopeId;
          CopyMemory(@sin6_addr.u.Byte, IpAddress, SizeOf(TIn6Addr));
          if not Local and IsZeroIpAddress(Addr) then
            sin6_port := 0;
          Result := SizeOf(TSockAddrIn6);
        end;
    end;
  end;
  
var
  Addr: TSockAddrInet;
  AddrSize: Integer;
  Host: THostBuf;
  Serv: TServBuf;
begin
  Result := SUnknown;
  FillChar(Addr, SizeOf(Addr), 0);
  AddrSize := FillAddress(Addr);
  FillChar(Host, NI_MAXHOST, 0);
  FillChar(Serv, NI_MAXSERV, 0);
  if getnameinfo(@Addr, AddrSize, Host, NI_MAXHOST, Serv, NI_MAXSERV,
    NI_NUMERICHOST or NI_NUMERICSERV) = 0 then
  begin
    if Family = AF_INET6 then
      {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}
      StrPCopy(Host, '[' + AnsiString(Host) + ']');
    if actByName.Checked then
    begin
      getnameinfo(@Addr, AddrSize, nil, 0, Serv, NI_MAXSERV, 0);
      if Local or IsZeroIpAddress(Addr) then
        CopyMemory(@Host, @LocalHost, NI_MAXHOST)
      else if Assigned(Data) then
        with PTcpData(Data)^ do
          if HostBuf <> '' then
            CopyMemory(@Host, @HostBuf, NI_MAXHOST)
          else if not Assigned(NameInfoThread) and (ResolveResult = 0) then
            NameInfoThread := TNameInfoThread.Create(@Addr, AddrSize, Data);
    end;
    Result := Format('%s:%s', [Host, Serv]);
  end;
end;

function TMainForm.GetProcessNameByPId(PId: DWORD): string;
var
  hSnapProcess, hSnapModule: THandle;
  ProcessEntry: TProcessEntry32;
  ModuleEntry: TModuleEntry32;
begin
  Result := SUnknown;
  hSnapProcess := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if hSnapProcess <> INVALID_HANDLE_VALUE then
  try
    ProcessEntry.dwSize := SizeOf(TProcessEntry32);
    if Process32First(hSnapProcess, ProcessEntry) then
    repeat
      if ProcessEntry.th32ProcessID = PId then
      begin
        Result := ProcessEntry.szExeFile;
        hSnapModule := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, PId);
        if hSnapModule <> INVALID_HANDLE_VALUE then
        try
          ModuleEntry.dwSize := SizeOf(TModuleEntry32);
          if Module32First(hSnapModule, ModuleEntry) then
          repeat
            if AnsiLowerCase(Result) = AnsiLowerCase(ModuleEntry.szModule) then
            begin
              Result := ModuleEntry.szExePath;
              Break;
            end;
          until not Module32Next(hSnapModule, ModuleEntry);
        finally
          CloseHandle(hSnapModule);
        end;
        Break;
      end;
    until not Process32Next(hSnapProcess, ProcessEntry);
  finally
    CloseHandle(hSnapProcess);
  end;
  Result := Format('%s:%u', [Result, PId]);
end;

procedure TMainForm.GetNicTable(ReNew: Boolean);
var
  IfTable: PMibIfTable;
  dwSize: DWORD;
  I, J: Integer;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SName;
        Width := 380;
      end;
      with Columns.Add do
      begin
        Caption := SMacAddress;
        Width := 120;
      end;
      with Columns.Add do
      begin
        Caption := SSpeed;
        Alignment := taRightJustify;
        Width := 130;
      end;
      with Columns.Add do
      begin
        Caption := SNumber;
        Alignment := taRightJustify;
        Width := 100;
      end;
    end;
  dwSize := 0;
  if GetIfTable(nil, @dwSize, True) = ERROR_INSUFFICIENT_BUFFER then
  begin
    IfTable := AllocMem(dwSize);
    try
      CheckIpHelperResult(GetIfTable(IfTable, @dwSize, True));
      with IfTable^, ListView do
      begin
        for I := 0 to dwNumEntries - 1 do
        begin
          J := 0;
          if not ReNew then
            for J := 0 to Items.Count - 1 do
              if table[I].dwIndex = PMibIfRow(Items[J].Data)^.dwIndex then
                Break;
          if ReNew or (J > Items.Count - 1) then
            with Items.Add do
            begin
              ImageIndex := 1;
              Caption := string(PAnsiChar(@table[I].bDescr));
              if table[I].dwPhysAddrLen <> 0 then
                SubItems.Add(FormatMacAddress(table[I].bPhysAddr))
              else
                SubItems.Add('');
              SubItems.Add(FormatNumber(table[I].dwSpeed));
              SubItems.Add(FormatNumber(table[I].dwIndex));
              Data := AllocMem(SizeOf(TMibIfRow));
              CopyMemory(Data, @table[I], SizeOf(TMibIfRow));
            end;
        end;
        if not ReNew then
          for I := Items.Count - 1 downto 0 do
          begin
            for J := 0 to dwNumEntries - 1 do
              if PMibIfRow(Items[I].Data)^.dwIndex = table[J].dwIndex then
                Break;
            if J > Integer(dwNumEntries - 1) then
              Items[I].Delete;
          end;
      end;
    finally
      FreeMem(IfTable);
    end;
  end;
end;

procedure TMainForm.GetArpTable(ReNew: Boolean);
const
  ArpStateNames: array[TNlNeighborState] of string = (
    SUnreachable,
    SIncomplete,
    SProbe,
    SDelay,
    SStale,
    SReachable,
    SPermanent,
    SUnknown);
  ArpTypeNames: array[TMibIpNetType] of string = (
    SOther,
    SInvalid,
    SDynamic,
    SStatic);
var
  IpNetTable: Pointer;
  dwSize: DWORD;
  I, J: Integer;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SProtocol;
        Width := 70;
      end;
      with Columns.Add do
      begin
        Caption := SIpAddress;
        Width := 170;
      end;
      with Columns.Add do
      begin
        Caption := SMacAddress;
        Width := 120;
      end;
      with Columns.Add do
      begin
        if Assigned(GetIpNetTable2) then
          Caption := SState
        else
          Caption := SType;
        Width := 100;
      end;
      with Columns.Add do
      begin
        Caption := SInterface;
        Alignment := taRightJustify;
        Width := 100;
      end;
    end;
  if Assigned(GetIpNetTable2) then
  begin
    CheckIpHelperResult(GetIpNetTable2(AF_UNSPEC, PMibIpNetTable2(IpNetTable)));
    try
      with PMibIpNetTable2(IpNetTable)^, ListView do
      begin
        for I := 0 to NumEntries - 1 do
        begin
          J := 0;
          if not ReNew then
            for J := 0 to Items.Count - 1 do
              if CompareMem(@table[I].Address,
                @PMibIpNetRow2(Items[J].Data)^.Address, SizeOf(TSockAddrInet)) and
                (table[I].InterfaceIndex =
                PMibIpNetRow2(Items[J].Data)^.InterfaceIndex) then
              begin
                if table[I].State <> PMibIpNetRow2(Items[J].Data)^.State then
                begin
                  PMibIpNetRow2(Items[J].Data)^.State := table[I].State;
                  Items[I].SubItems[2] := ArpStateNames[table[I].State];
                end;
                Break;
              end;
          if ReNew or (J > Items.Count - 1) then
            with Items.Add do
            begin
              ImageIndex := 0;
              if table[I].Address.si_family = AF_INET then
                Caption := SIpv4
              else
                Caption := SIpv6;
              SubItems.Add(FormatIpAddress(table[I].Address));
              if table[I].PhysicalAddressLength <> 0 then
                SubItems.Add(FormatMacAddress(table[I].PhysicalAddress))
              else
                SubItems.Add('');
              SubItems.Add(ArpStateNames[table[I].State]);
              SubItems.Add(FormatNumber(table[I].InterfaceIndex));
              Data := AllocMem(SizeOf(TMibIpNetRow2));
              CopyMemory(Data, @table[I], SizeOf(TMibIpNetRow2));
            end;
        end;
        if not ReNew then
          for I := Items.Count - 1 downto 0 do
          begin
            for J := 0 to NumEntries - 1 do
              if CompareMem(@PMibIpNetRow2(Items[I].Data)^.Address,
                @table[J].Address, SizeOf(TSockAddrInet)) and
                (PMibIpNetRow2(Items[I].Data)^.InterfaceIndex =
                table[J].InterfaceIndex) then
                Break;
            if J > Integer(NumEntries - 1) then
              Items[I].Delete;
          end;
      end;
    finally
      FreeMibTable(IpNetTable);
    end;
  end
  else
  begin
    dwSize := 0;
    if GetIpNetTable(nil, @dwSize, True) = ERROR_INSUFFICIENT_BUFFER then
    begin
      IpNetTable := AllocMem(dwSize);
      try
        CheckIpHelperResult(GetIpNetTable(IpNetTable, @dwSize, True));
        with PMibIpNetTable(IpNetTable)^, ListView do
        begin
          for I := 0 to dwNumEntries - 1 do
          begin
            J := 0;
            if not ReNew then
              for J := 0 to Items.Count - 1 do
                if (table[I].dwAddr = PMibIpNetRow(Items[J].Data)^.dwAddr) and
                  (table[I].dwIndex = PMibIpNetRow(Items[J].Data)^.dwIndex) then
                  Break;
            if ReNew or (J > Items.Count - 1) then
              with Items.Add do
              begin
                ImageIndex := 0;
                Caption := SIpv4;
                SubItems.Add(FormatIpAddress(table[I].dwAddr));
                if table[I].dwPhysAddrLen <> 0 then
                  SubItems.Add(FormatMacAddress(table[I].bPhysAddr))
                else
                  SubItems.Add('');
                SubItems.Add(ArpTypeNames[table[I].NetType]);
                SubItems.Add(FormatNumber(table[I].dwIndex));
                Data := AllocMem(SizeOf(TMibIpNetRow));
                CopyMemory(Data, @table[I], SizeOf(TMibIpNetRow));
              end;
          end;
          if not ReNew then
            for I := Items.Count - 1 downto 0 do
            begin
              for J := 0 to dwNumEntries - 1 do
                if (PMibIpNetRow(Items[I].Data)^.dwAddr = table[J].dwAddr) and
                  (PMibIpNetRow(Items[I].Data)^.dwIndex = table[J].dwIndex) then
                  Break;
              if J > Integer(dwNumEntries - 1) then
                Items[I].Delete;
            end;
        end;
      finally
        FreeMem(IpNetTable);
      end;
    end;
  end;
end;

procedure TMainForm.GetIpAddressTable(ReNew: Boolean);
var
  IpAddrTable: Pointer;
  dwSize: DWORD;
  I, J: Integer;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SProtocol;
        Width := 70;
      end;
      with Columns.Add do
      begin
        Caption := SIpAddress;
        Width := 170;
      end;
      with Columns.Add do
      begin
        Caption := SNetmask;
        Width := 170;
      end;
      with Columns.Add do
      begin
        Caption := SInterface;
        Alignment := taRightJustify;
        Width := 100;
      end;
    end;
  if Assigned(GetUnicastIpAddressTable) then
  begin
    CheckIpHelperResult(GetUnicastIpAddressTable(AF_UNSPEC,
      PMibUnicastIpAddressTable(IpAddrTable)));
    try
      with PMibUnicastIpAddressTable(IpAddrTable)^, ListView do
      begin
        for I := 0 to NumEntries - 1 do
        begin
          J := 0;
          if not ReNew then
            for J := 0 to Items.Count - 1 do
              if CompareMem(@table[I].Address,
                @PMibUnicastIpAddressRow(Items[J].Data)^.Address,
                SizeOf(TSockAddrInet)) and
                (table[I].InterfaceIndex =
                PMibUnicastIpAddressRow(Items[J].Data)^.InterfaceIndex) then
              begin
                if (table[I].Address.si_family = AF_INET) and
                  (table[I].OnLinkPrefixLength <>
                  PMibUnicastIpAddressRow(Items[J].Data)^.OnLinkPrefixLength) then
                begin
                  PMibUnicastIpAddressRow(Items[J].Data)^.OnLinkPrefixLength :=
                    table[I].OnLinkPrefixLength;
                  Items[J].SubItems[1] :=
                    IpAddressPrefixToIpv4Mask(table[I].OnLinkPrefixLength);
                end;
                Break;
              end;
          if ReNew or (J > Items.Count - 1) then
            with Items.Add do
            begin
              ImageIndex := 0;
              if table[I].Address.si_family = AF_INET then
                Caption := SIpv4
              else
                Caption := SIpv6;
              SubItems.Add(FormatIpAddress(table[I].Address, True));
              if table[I].Address.si_family = AF_INET then
                SubItems.Add(IpAddressPrefixToIpv4Mask(table[I].OnLinkPrefixLength))
              else
                SubItems.Add('');
              SubItems.Add(FormatNumber(table[I].InterfaceIndex));
              Data := AllocMem(SizeOf(TMibUnicastIpAddressRow));
              CopyMemory(Data, @table[I], SizeOf(TMibUnicastIpAddressRow));
            end;
        end;
        if not ReNew then
          for I := Items.Count - 1 downto 0 do
          begin
            for J := 0 to NumEntries - 1 do
              if CompareMem(@PMibUnicastIpAddressRow(Items[I].Data)^.Address,
                @table[J].Address, SizeOf(TSockAddrInet))  and
                (PMibUnicastIpAddressRow(Items[I].Data)^.InterfaceIndex =
                table[J].InterfaceIndex) then
                Break;
            if J > Integer(NumEntries - 1) then
              Items[I].Delete;
          end;
      end;
    finally
      FreeMibTable(IpAddrTable);
    end;
  end
  else
  begin
    dwSize := 0;
    if GetIpAddrTable(nil, @dwSize, True) = ERROR_INSUFFICIENT_BUFFER then
    begin
      IpAddrTable := AllocMem(dwSize);
      try
        CheckIpHelperResult(GetIpAddrTable(IpAddrTable, @dwSize, True));
        with PMibIpAddrTable(IpAddrTable)^, ListView do
        begin
          for I := 0 to dwNumEntries - 1 do
          begin
            J := 0;
            if not ReNew then
              for J := 0 to Items.Count - 1 do
                if (table[I].dwAddr = PMibIpAddrRow(Items[J].Data)^.dwAddr) and
                  (table[I].dwIndex = PMibIpAddrRow(Items[J].Data)^.dwIndex) then
                begin
                  if table[I].dwMask <> PMibIpAddrRow(Items[J].Data)^.dwMask then
                  begin
                    PMibIpAddrRow(Items[J].Data)^.dwMask := table[I].dwMask;
                    Items[J].SubItems[0] := FormatIpAddress(table[I].dwMask);
                  end;
                  Break;
                end;
            if ReNew or (J > Items.Count - 1) then
              with Items.Add do
              begin
                ImageIndex := 0;
                Caption := SIpv4;
                SubItems.Add(FormatIpAddress(table[I].dwAddr));
                SubItems.Add(FormatIpAddress(table[I].dwMask));
                SubItems.Add(FormatNumber(table[I].dwIndex));
                Data := AllocMem(SizeOf(TMibIpAddrRow));
                CopyMemory(Data, @table[I], SizeOf(TMibIpAddrRow));
              end;
          end;
          if not ReNew then
            for I := Items.Count - 1 downto 0 do
            begin
              for J := 0 to dwNumEntries - 1 do
                if (PMibIpAddrRow(Items[I].Data)^.dwAddr = table[J].dwAddr) and
                  (PMibIpAddrRow(Items[I].Data)^.dwIndex = table[J].dwIndex) then
                  Break;
              if J > Integer(dwNumEntries - 1) then
                Items[I].Delete;
            end;
        end;
      finally
        FreeMem(IpAddrTable);
      end;
    end;
  end;
end;

procedure TMainForm.GetRouteTable(ReNew: Boolean);

  function GetIpAddressByIfIndex(IfIndex: TNetIfIndex): ULONG;
  var
    IpAddrTable: PMibIpAddrTable;
    dwSize: DWORD;
    I: Integer;
  begin
    Result := 0;
    dwSize := 0;
    if GetIpAddrTable(nil, @dwSize, True) = ERROR_INSUFFICIENT_BUFFER then
    begin
      IpAddrTable := AllocMem(dwSize);
      try
        CheckIpHelperResult(GetIpAddrTable(IpAddrTable, @dwSize, True));
        for I := 0 to IpAddrTable^.dwNumEntries - 1 do
          if IpAddrTable^.table[I].dwIndex = IfIndex then
          begin
            Result := IpAddrTable^.table[I].dwAddr;
            Break;
          end;
      finally
        FreeMem(IpAddrTable);
      end;
    end;
  end;

  function GetIfMetric(IfIndex: TNetIfIndex): ULONG;
  var
    IpInterfaceTable: PMibIpInterfaceTable;
    I: Integer;
  begin
    Result := 0;
    CheckIpHelperResult(GetIpInterfaceTable(AF_UNSPEC, IpInterfaceTable));
    try
      for I := 0 to IpInterfaceTable^.NumEntries - 1 do
        if IpInterfaceTable^.table[I].InterfaceIndex = IfIndex then
        begin
          Result := IpInterfaceTable^.table[I].Metric;
          Break;
        end;
    finally
      FreeMibTable(IpInterfaceTable);
    end;
  end;

var
  IpForwardTable: Pointer;
  dwSize: DWORD;
  I, J: Integer;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SProtocol;
        Width := 70;
      end;
      with Columns.Add do
      begin
        Caption := SNetworkDest;
        Width := 170;
      end;
      with Columns.Add do
      begin
        Caption := SNetmask;
        Width := 170;
      end;
      with Columns.Add do
      begin
        Caption := SGateway;
        Width := 170;
      end;
      with Columns.Add do
      begin
        Caption := SInterface;
        Width := 170;
      end;
      with Columns.Add do
      begin
        Caption := SMetric;
        Alignment := taRightJustify;
        Width := 60;
      end;
    end;
  if Assigned(GetIpForwardTable2) then
  begin
    CheckIpHelperResult(GetIpForwardTable2(AF_UNSPEC,
      PMibIpForwardTable2(IpForwardTable)));
    try
      with PMibIpForwardTable2(IpForwardTable)^, ListView do
      begin
        for I := 0 to NumEntries - 1 do
        begin
          J := 0;
          if not ReNew then
            for J := 0 to Items.Count - 1 do
              if (table[I].InterfaceIndex =
                PMibIpForwardRow2(Items[J].Data)^.InterfaceIndex) and
                CompareMem(@table[I].DestinationPrefix,
                @PMibIpForwardRow2(Items[J].Data)^.DestinationPrefix,
                SizeOf(TIpAddressPrefix)) then
              begin
                if not CompareMem(@table[I].NextHop,
                  @PMibIpForwardRow2(Items[J].Data)^.NextHop, SizeOf(TSockAddrInet)) then
                begin
                  CopyMemory(@PMibIpForwardRow2(Items[J].Data)^.NextHop,
                    @table[I].NextHop, SizeOf(TSockAddrInet));
                  if IsZeroIpAddress(table[I].NextHop) then
                    Items[J].SubItems[2] := SOnlink
                  else
                    Items[J].SubItems[2] := FormatIpAddress(table[I].NextHop);
                end;
                if table[I].Metric <> PMibIpForwardRow2(Items[J].Data)^.Metric then
                begin
                  PMibIpForwardRow2(Items[J].Data)^.Metric := table[I].Metric;
                  Items[J].SubItems[4] := FormatNumber(table[I].Metric +
                    GetIfMetric(table[I].InterfaceIndex));
                end;
                Break;
              end;
          if ReNew or (J > Items.Count - 1) then
            with Items.Add do
            begin
              ImageIndex := 0;
              with table[I], DestinationPrefix do
              begin
                if Prefix.si_family = AF_INET then
                begin
                  Caption := SIpv4;
                  SubItems.Add(FormatIpAddress(Prefix));
                  SubItems.Add(IpAddressPrefixToIpv4Mask(PrefixLength));
                end
                else
                begin
                  Caption := SIpv6;
                  SubItems.Add(Format('%s/%d', [FormatIpAddress(Prefix),
                                                PrefixLength]));
                  SubItems.Add('');
                end;
                if IsZeroIpAddress(NextHop) then
                  SubItems.Add(SOnlink)
                else
                  SubItems.Add(FormatIpAddress(NextHop));
                if Prefix.si_family = AF_INET then
                  SubItems.Add(FormatIpAddress(GetIpAddressByIfIndex(InterfaceIndex)))
                else
                  SubItems.Add(FormatNumber(InterfaceIndex));
                SubItems.Add(FormatNumber(Metric + GetIfMetric(InterfaceIndex)));
              end;
              Data := AllocMem(SizeOf(TMibIpForwardRow2));
              CopyMemory(Data, @table[I], SizeOf(TMibIpForwardRow2));
            end;
        end;
        if not ReNew then
          for I := Items.Count - 1 downto 0 do
          begin
            for J := 0 to NumEntries - 1 do
              if (PMibIpForwardRow2(Items[I].Data)^.InterfaceIndex =
                table[J].InterfaceIndex) and
                CompareMem(@PMibIpForwardRow2(Items[I].Data)^.DestinationPrefix,
                @table[J].DestinationPrefix, SizeOf(TIpAddressPrefix)) then
                Break;
            if J > Integer(NumEntries - 1) then
              Items[I].Delete;
          end;
      end;
    finally
      FreeMibTable(IpForwardTable);
    end;
  end
  else
  begin
    dwSize := 0;
    if GetIpForwardTable(nil, @dwSize, True) = ERROR_INSUFFICIENT_BUFFER then
    begin
      IpForwardTable := AllocMem(dwSize);
      try
        CheckIpHelperResult(GetIpForwardTable(IpForwardTable, @dwSize, True));
        with PMibIpForwardTable(IpForwardTable)^, ListView do
        begin
          for I := 0 to dwNumEntries - 1 do
          begin
            J := 0;
            if not ReNew then
              for J := 0 to Items.Count - 1 do
                if (table[I].dwForwardIfIndex = PMibIpForwardRow(Items[J].Data)^.dwForwardIfIndex) and
                  (table[I].dwForwardDest = PMibIpForwardRow(Items[J].Data)^.dwForwardDest) then
                begin
                  if table[I].dwForwardNextHop <> PMibIpForwardRow(Items[J].Data)^.dwForwardNextHop then
                  begin
                    PMibIpForwardRow(Items[J].Data)^.dwForwardNextHop := table[I].dwForwardNextHop;
                    Items[J].SubItems[2] := FormatIpAddress(table[I].dwForwardNextHop);
                  end;
                  if table[I].dwForwardMetric1 <> PMibIpForwardRow(Items[J].Data)^.dwForwardMetric1 then
                  begin
                    PMibIpForwardRow(Items[J].Data)^.dwForwardMetric1 := table[I].dwForwardMetric1;
                    Items[J].SubItems[4] := FormatNumber(table[I].dwForwardMetric1);
                  end;
                  Break;
                end;
            if ReNew or (J > Items.Count - 1) then
              with Items.Add do
              begin
                ImageIndex := 0;
                Caption := SIpv4;
                SubItems.Add(FormatIpAddress(table[I].dwForwardDest));
                SubItems.Add(FormatIpAddress(table[I].dwForwardMask));
                SubItems.Add(FormatIpAddress(table[I].dwForwardNextHop));
                SubItems.Add(FormatIpAddress(GetIpAddressByIfIndex(table[I].dwForwardIfIndex)));
                SubItems.Add(FormatNumber(table[I].dwForwardMetric1));
                Data := AllocMem(SizeOf(TMibIpForwardRow));
                CopyMemory(Data, @table[I], SizeOf(TMibIpForwardRow));
              end;
          end;
          if not ReNew then
            for I := Items.Count - 1 downto 0 do
            begin
              for J := 0 to dwNumEntries - 1 do
                if (PMibIpForwardRow(Items[I].Data)^.dwForwardIfIndex = table[J].dwForwardIfIndex) and
                  (PMibIpForwardRow(Items[I].Data)^.dwForwardDest = table[J].dwForwardDest) then
                  Break;
              if J > Integer(dwNumEntries - 1) then
                Items[I].Delete;
            end;
        end;
      finally
        FreeMem(IpForwardTable);
      end;
    end;
  end;
end;

procedure TMainForm.GetConnectionsTable(ReNew: Boolean);
var
  ConnTable: Pointer;
  dwSize: DWORD;
  I, J: Integer;
  ItemFound: Boolean;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SProtocol;
        Width := 70;
      end;
      with Columns.Add do
      begin
        Caption := SLocalAddress;
        Width := 200;
      end;
      with Columns.Add do
      begin
        Caption := SRemoteAddress;
        Width := 200;
      end;
      with Columns.Add do
      begin
        Caption := SState;
        Width := 100;
      end;
      with Columns.Add do
      begin
        Caption := SProcess;
        Width := 300;
      end;
    end;
  if not actAllEndpoints.Checked then
    with ListView.Items do
      for I := Count - 1 downto 0 do
        if (Item[I].SubItems[2] = TcpStateNames[MIB_TCP_STATE_CLOSED]) or
          (Item[I].SubItems[2] = TcpStateNames[MIB_TCP_STATE_LISTEN]) or
          (Item[I].SubItems[2] = '') then
          Item[I].Delete;

{ TCP connections }

  dwSize := 0;
  if GetExtendedTcpTable(nil, @dwSize, True,
    AF_INET, TCP_TABLE_OWNER_PID_ALL, 0) = ERROR_INSUFFICIENT_BUFFER then
  begin
    ConnTable := AllocMem(dwSize);
    try
      CheckIpHelperResult(GetExtendedTcpTable(ConnTable, @dwSize, True,
        AF_INET, TCP_TABLE_OWNER_PID_ALL, 0));
      with PMibTcpTableOwnerPid(ConnTable)^, ListView do
      begin
        for I := 0 to dwNumEntries - 1 do
        begin
          if not actAllEndpoints.Checked and
            ((table[I].dwState = DWORD(Ord(MIB_TCP_STATE_CLOSED))) or
            (table[I].dwState = DWORD(Ord(MIB_TCP_STATE_LISTEN)))) then Continue;
          J := 0;
          if not ReNew then
            for J := 0 to Items.Count - 1 do
            begin
              if (table[I].dwLocalAddr = PMibTcpRowOwnerPid(Items[J].Data)^.dwLocalAddr) and
                (table[I].dwLocalPort = PMibTcpRowOwnerPid(Items[J].Data)^.dwLocalPort) and
                (table[I].dwRemoteAddr = PMibTcpRowOwnerPid(Items[J].Data)^.dwRemoteAddr) and
                (table[I].dwRemotePort = PMibTcpRowOwnerPid(Items[J].Data)^.dwRemotePort) and
                (table[I].dwOwningPid = PMibTcpRowOwnerPid(Items[J].Data)^.dwOwningPid) then
              begin
                if FViewChanged then
                begin
                  Items[J].SubItems[0] := GetFormattedAddress(AF_INET,
                    table[I].dwLocalPort, @table[I].dwLocalAddr, 0, True);
                  Items[J].SubItems[1] := GetFormattedAddress(AF_INET,
                    table[I].dwRemotePort, @table[I].dwRemoteAddr, 0, False, Items[J].Data);
                end;
                if table[I].dwState <> PMibTcpRowOwnerPid(Items[J].Data)^.dwState then
                begin
                  PMibTcpRowOwnerPid(Items[J].Data)^.dwState := table[I].dwState;
                  Items[J].SubItems[2] := TcpStateNames[TMibTcpState(table[I].dwState)];
                end;
                Break;
              end;
              Application.ProcessMessages;
            end;
          if ReNew or (J > Items.Count - 1) then
            with Items.Add do
            begin
              Data := AllocMem(SizeOf(TTcpData));
              ImageIndex := 0;
              Caption := STcpv4;
              SubItems.Add(GetFormattedAddress(AF_INET, table[I].dwLocalPort,
                @table[I].dwLocalAddr, 0, True));
              SubItems.Add(GetFormattedAddress(AF_INET, table[I].dwRemotePort,
                @table[I].dwRemoteAddr, 0, False, Data));
              SubItems.Add(TcpStateNames[TMibTcpState(table[I].dwState)]);
              SubItems.Add(GetProcessNameByPId(table[I].dwOwningPid));
              CopyMemory(Data, @table[I], SizeOf(TMibTcpRowOwnerPid));
            end;
          Application.ProcessMessages;
        end;
        if not ReNew then
          for I := Items.Count - 1 downto 0 do
          begin
            if Items[I].Caption = STcpv4 then
            begin
              for J := 0 to dwNumEntries - 1 do
              begin
                if (PMibTcpRowOwnerPid(Items[I].Data)^.dwLocalAddr = table[J].dwLocalAddr) and
                  (PMibTcpRowOwnerPid(Items[I].Data)^.dwLocalPort = table[J].dwLocalPort) and
                  (PMibTcpRowOwnerPid(Items[I].Data)^.dwRemoteAddr = table[J].dwRemoteAddr) and
                  (PMibTcpRowOwnerPid(Items[I].Data)^.dwRemotePort = table[J].dwRemotePort) and
                  (PMibTcpRowOwnerPid(Items[I].Data)^.dwOwningPid = table[J].dwOwningPid) then
                  Break;
                Application.ProcessMessages;
              end;
              if J > Integer(dwNumEntries - 1) then
                Items[I].Delete;
            end;
            Application.ProcessMessages;
          end;
      end;
    finally
      FreeMem(ConnTable);
    end;
  end;  
  { TCPv6 }
  dwSize := 0;
  if GetExtendedTcpTable(nil, @dwSize, True,
    AF_INET6, TCP_TABLE_OWNER_PID_ALL, 0) = ERROR_INSUFFICIENT_BUFFER then
  begin
    ConnTable := AllocMem(dwSize);
    try
      CheckIpHelperResult(GetExtendedTcpTable(ConnTable, @dwSize, True,
        AF_INET6, TCP_TABLE_OWNER_PID_ALL, 0));
      with PMibTcp6TableOwnerPid(ConnTable)^, ListView do
      begin
        for I := 0 to dwNumEntries - 1 do
        begin
          if not actAllEndpoints.Checked and
            ((table[I].dwState = DWORD(Ord(MIB_TCP_STATE_CLOSED))) or
            (table[I].dwState = DWORD(Ord(MIB_TCP_STATE_LISTEN)))) then Continue;
          J := 0;
          if not ReNew then
            for J := 0 to Items.Count - 1 do
            begin
              if CompareMem(@table[I].ucLocalAddr,
                @PMibTcp6RowOwnerPid(Items[J].Data)^.ucLocalAddr, SizeOf(TIn6Addr)) and
                (table[I].dwLocalPort = PMibTcp6RowOwnerPid(Items[J].Data)^.dwLocalPort) and
                CompareMem(@table[I].ucRemoteAddr,
                @PMibTcp6RowOwnerPid(Items[J].Data)^.ucRemoteAddr, SizeOf(TIn6Addr)) and
                (table[I].dwRemotePort = PMibTcp6RowOwnerPid(Items[J].Data)^.dwRemotePort) then
              begin
                if FViewChanged then
                begin
                  Items[J].SubItems[0] := GetFormattedAddress(AF_INET6,
                    table[I].dwLocalPort, @table[I].ucLocalAddr,
                    table[I].dwLocalScopeId, True);
                  Items[J].SubItems[1] := GetFormattedAddress(AF_INET6,
                    table[I].dwRemotePort, @table[I].ucRemoteAddr,
                    table[I].dwRemoteScopeId, False, Items[J].Data);
                end;
                if table[I].dwState <> PMibTcp6RowOwnerPid(Items[J].Data)^.dwState then
                begin
                  PMibTcp6RowOwnerPid(Items[J].Data)^.dwState := table[I].dwState;
                  Items[J].SubItems[2] := TcpStateNames[TMibTcpState(table[I].dwState)];
                end;
                Break;
              end;
              Application.ProcessMessages;
            end;
          if ReNew or (J > Items.Count - 1) then
            with Items.Add do
            begin
              Data := AllocMem(SizeOf(TTcpData));
              ImageIndex := 0;
              Caption := STcpv6;
              SubItems.Add(GetFormattedAddress(AF_INET6, table[I].dwLocalPort,
                @table[I].ucLocalAddr, table[I].dwLocalScopeId, True));
              SubItems.Add(GetFormattedAddress(AF_INET6, table[I].dwRemotePort,
                @table[I].ucRemoteAddr, table[I].dwRemoteScopeId, False, Data));
              SubItems.Add(TcpStateNames[TMibTcpState(table[I].dwState)]);
              SubItems.Add(GetProcessNameByPId(table[I].dwOwningPid));
              CopyMemory(Data, @table[I], SizeOf(TMibTcp6RowOwnerPid));
            end;
          Application.ProcessMessages;
        end;
        if not ReNew then
          for I := Items.Count - 1 downto 0 do
          begin
            if Items[I].Caption = STcpv6 then
            begin
              for J := 0 to dwNumEntries - 1 do
              begin
                if CompareMem(@PMibTcp6RowOwnerPid(Items[I].Data)^.ucLocalAddr,
                  @table[J].ucLocalAddr, SizeOf(TIn6Addr)) and
                  (PMibTcp6RowOwnerPid(Items[I].Data)^.dwLocalPort = table[J].dwLocalPort) and
                  CompareMem(@PMibTcp6RowOwnerPid(Items[I].Data)^.ucRemoteAddr,
                  @table[J].ucRemoteAddr, SizeOf(TIn6Addr)) and
                  (PMibTcp6RowOwnerPid(Items[I].Data)^.dwRemotePort = table[J].dwRemotePort) then
                  Break;
                Application.ProcessMessages;
              end;
              if J > Integer(dwNumEntries - 1) then
                Items[I].Delete;
            end;
            Application.ProcessMessages;
          end;
      end;
    finally
      FreeMem(ConnTable);
    end;
  end;

{ UDP connections }

  if actAllEndpoints.Checked then
  begin
    dwSize := 0;
    if GetExtendedUdpTable(nil, @dwSize, True,
      AF_INET, UDP_TABLE_OWNER_PID, 0) = ERROR_INSUFFICIENT_BUFFER then
    begin
      ConnTable := AllocMem(dwSize);
      try
        CheckIpHelperResult(GetExtendedUdpTable(ConnTable, @dwSize, True,
          AF_INET, UDP_TABLE_OWNER_PID, 0));
        with PMibUdpTableOwnerPid(ConnTable)^, ListView do
        begin
          for I := 0 to dwNumEntries - 1 do
          begin
            ItemFound := False;
            if not ReNew then
              for J := 0 to Items.Count - 1 do
              begin
                if (table[I].dwLocalAddr = PMibUdpRowOwnerPid(Items[J].Data)^.dwLocalAddr) and
                  (table[I].dwLocalPort = PMibUdpRowOwnerPid(Items[J].Data)^.dwLocalPort) and
                  (table[I].dwOwningPid = PMibUdpRowOwnerPid(Items[J].Data)^.dwOwningPid) then
                begin
                  if FViewChanged then
                    Items[J].SubItems[0] := GetFormattedAddress(AF_INET,
                      table[I].dwLocalPort, @table[I].dwLocalAddr, 0, True);
                  ItemFound := True; // duplicates! without break!
                end;
                Application.ProcessMessages;
              end;
            if ReNew or not ItemFound then
              with Items.Add do
              begin
                ImageIndex := 0;
                Caption := SUdpv4;
                SubItems.Add(GetFormattedAddress(AF_INET, table[I].dwLocalPort,
                  @table[I].dwLocalAddr, 0, True));
                SubItems.Add('*:*');
                SubItems.Add('');
                SubItems.Add(GetProcessNameByPId(table[I].dwOwningPid));
                Data := AllocMem(SizeOf(TMibUdpRowOwnerPid));
                CopyMemory(Data, @table[I], SizeOf(TMibUdpRowOwnerPid));
              end;
            Application.ProcessMessages;
          end;
          if not ReNew then
            for I := Items.Count - 1 downto 0 do
            begin
              if Items[I].Caption = SUdpv4 then
              begin
                for J := 0 to dwNumEntries - 1 do
                begin
                  if (PMibUdpRowOwnerPid(Items[I].Data)^.dwLocalAddr = table[J].dwLocalAddr) and
                    (PMibUdpRowOwnerPid(Items[I].Data)^.dwLocalPort = table[J].dwLocalPort) and
                    (PMibUdpRowOwnerPid(Items[I].Data)^.dwOwningPid = table[J].dwOwningPid) then
                    Break;
                  Application.ProcessMessages;
                end;
                if J > Integer(dwNumEntries - 1) then
                  Items[I].Delete;
              end;
              Application.ProcessMessages;
            end;
        end;
      finally
        FreeMem(ConnTable);
      end;
    end;  
    { UDPv6 }
    dwSize := 0;
    if GetExtendedUdpTable(nil, @dwSize, True,
      AF_INET6, UDP_TABLE_OWNER_PID, 0) = ERROR_INSUFFICIENT_BUFFER then
    begin
      ConnTable := AllocMem(dwSize);
      try
        CheckIpHelperResult(GetExtendedUdpTable(ConnTable, @dwSize, True,
          AF_INET6, UDP_TABLE_OWNER_PID, 0));
        with PMibUdp6TableOwnerPid(ConnTable)^, ListView do
        begin
          for I := 0 to dwNumEntries - 1 do
          begin
            ItemFound := False;
            if not ReNew then
              for J := 0 to Items.Count - 1 do
              begin
                if CompareMem(@table[I].ucLocalAddr,
                  @PMibUdp6RowOwnerPid(Items[J].Data)^.ucLocalAddr, SizeOf(TIn6Addr)) and
                  (table[I].dwLocalPort = PMibUdp6RowOwnerPid(Items[J].Data)^.dwLocalPort) and
                  (table[I].dwOwningPid = PMibUdp6RowOwnerPid(Items[J].Data)^.dwOwningPid) then
                begin
                  if FViewChanged then
                    Items[J].SubItems[0] := GetFormattedAddress(AF_INET6,
                      table[I].dwLocalPort, @table[I].ucLocalAddr,
                      table[I].dwLocalScopeId, True);
                  ItemFound := True;
                end;
                Application.ProcessMessages;
              end;
            if ReNew or not ItemFound then
              with Items.Add do
              begin
                ImageIndex := 0;
                Caption := SUdpv6;
                SubItems.Add(GetFormattedAddress(AF_INET6, table[I].dwLocalPort,
                  @table[I].ucLocalAddr, table[I].dwLocalScopeId, True));
                SubItems.Add('*:*');
                SubItems.Add('');
                SubItems.Add(GetProcessNameByPId(table[I].dwOwningPid));
                Data := AllocMem(SizeOf(TMibUdp6RowOwnerPid));
                CopyMemory(Data, @table[I], SizeOf(TMibUdp6RowOwnerPid));
              end;
            Application.ProcessMessages;
          end;
          if not ReNew then
            for I := Items.Count - 1 downto 0 do
            begin
              if Items[I].Caption = SUdpv6 then
              begin
                for J := 0 to dwNumEntries - 1 do
                begin
                  if CompareMem(@PMibUdp6RowOwnerPid(Items[I].Data)^.ucLocalAddr,
                    @table[J].ucLocalAddr, SizeOf(TIn6Addr)) and
                    (PMibUdp6RowOwnerPid(Items[I].Data)^.dwLocalPort = table[J].dwLocalPort) and
                    (PMibUdp6RowOwnerPid(Items[I].Data)^.dwOwningPid = table[J].dwOwningPid) then
                    Break;
                  Application.ProcessMessages;
                end;
                if J > Integer(dwNumEntries - 1) then
                  Items[I].Delete;
              end;
              Application.ProcessMessages;
            end;
        end;
      finally
        FreeMem(ConnTable);
      end;
    end;
  end;
end;

procedure TMainForm.GetIfStats(ReNew: Boolean);
const
  IfDescs: array[0..5] of string = (
    SBytes,
    SUnicastPackets,
    SNonunicastPackets,
    SDiscards,
    SErrors,
    SUnknownProtocols);
var
  IfTable: PMibIfTable;
  Values: array[0..5, 0..1] of Int64;
  dwSize: DWORD;
  I: Integer;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SIfDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SReceived;
        Alignment := taRightJustify;
        Width := 130;
      end;
      with Columns.Add do
      begin
        Caption := SSent;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  dwSize := 0;
  if GetIfTable(nil, @dwSize, True) = ERROR_INSUFFICIENT_BUFFER then
  begin
    IfTable := AllocMem(dwSize);
    try
      CheckIpHelperResult(GetIfTable(IfTable, @dwSize, True));
      FillChar(Values, SizeOf(Values), 0);
      for I := 0 to IfTable^.dwNumEntries - 1 do
        with IfTable^.table[I] do
          if (FIfIndex = -1) or (DWORD(FIfIndex) = dwIndex) then
          begin
            Values[0,0] := Values[0,0] + dwInOctets;
            Values[1,0] := Values[1,0] + dwInUcastPkts;
            Values[2,0] := Values[2,0] + dwInNUcastPkts;
            Values[3,0] := Values[3,0] + dwInDiscards;
            Values[4,0] := Values[4,0] + dwInErrors;
            Values[5,0] := Values[5,0] + dwInUnknownProtos;
            Values[0,1] := Values[0,1] + dwOutOctets;
            Values[1,1] := Values[1,1] + dwOutUcastPkts;
            Values[2,1] := Values[2,1] + dwOutNUcastPkts;
            Values[3,1] := Values[3,1] + dwOutDiscards;
            Values[4,1] := Values[4,1] + dwOutErrors;
            if DWORD(FIfIndex) = dwIndex then
              Break;
          end;
      for I := 0 to High(IfDescs) do
        if ReNew then
          with ListView.Items.Add do
          begin
            ImageIndex := 2;
            Caption := IfDescs[I];
            SubItems.Add(FormatNumber(Values[I,0]));
            if I < High(IfDescs) then
              SubItems.Add(FormatNumber(Values[I,1]))
            else
              SubItems.Add('');
          end
        else
          with ListView.FindCaption(0, IfDescs[I], False, True, True) do
          begin
            SubItems[0] := FormatNumber(Values[I,0]);
            if I < High(IfDescs) then
              SubItems[1] := FormatNumber(Values[I,1]);
          end;
    finally
      FreeMem(IfTable);
    end;
  end;
end;

procedure TMainForm.GetIpStats(ReNew: Boolean);
const
  IpDescs: array[0..16] of string = (
    SPacketsRecv,
    SRecvHeaderErrors,
    SRecvAddressErrors,
    SDatagramsForwarded,
    SUnknownProtocolsRecv,
    SRecvPacketsDiscarded,
    SRecvPacketsDelivered,
    SOutputRequests,
    SRoutingDiscards,
    SDiscardedOutputPackets,
    SOutputPacketNoRoute,
    SReassemblyRequired,
    SReassemblySuccessful,
    SReassemblyFailures,
    SDatagramsSuccFragmented,
    SDatagramsFailFragmentation,
    SFragmentsCreated);
var
  IpStats: TMibIpStats;
  Values: array[0..16] of DWORD;
  I, J: Integer;
  dwResult: DWORD;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SProtocol;
        Width := 70;
      end;
      with Columns.Add do
      begin
        Caption := SIpDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SValue;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  FillChar(IpStats, SizeOf(IpStats), 0);
  CheckIpHelperResult(GetIpStatisticsEx(@IpStats, AF_INET));
  with IpStats do
  begin
    Values[0] := dwInReceives;
    Values[1] := dwInHdrErrors;
    Values[2] := dwInAddrErrors;
    Values[3] := dwForwDatagrams;
    Values[4] := dwInUnknownProtos;
    Values[5] := dwInDiscards;
    Values[6] := dwInDelivers;
    Values[7] := dwOutRequests;
    Values[8] := dwRoutingDiscards;
    Values[9] := dwOutDiscards;
    Values[10] := dwOutNoRoutes;
    Values[11] := dwReasmReqds;
    Values[12] := dwReasmOks;
    Values[13] := dwReasmFails;
    Values[14] := dwFragOks;
    Values[15] := dwFragFails;
    Values[16] := dwFragCreates;
  end;
  for I := 0 to High(IpDescs) do
    if ReNew then
      with ListView.Items.Add do
      begin
        ImageIndex := 0;
        Caption := SIpv4;
        SubItems.Add(IpDescs[I]);
        SubItems.Add(FormatNumber(Values[I]));
      end
    else
      for J := 0 to ListView.Items.Count - 1 do
        with ListView.Items[J] do
          if (Caption = SIpv4) and (SubItems[0] = IpDescs[I]) then
          begin
            SubItems[1] := FormatNumber(Values[I]);
            Break;
          end;
  FillChar(IpStats, SizeOf(IpStats), 0);
  dwResult := GetIpStatisticsEx(@IpStats, AF_INET6);
  if dwResult = ERROR_NOT_SUPPORTED then
    Exit
  else
    CheckIpHelperResult(dwResult);
  with IpStats do
  begin
    Values[0] := dwInReceives;
    Values[1] := dwInHdrErrors;
    Values[2] := dwInAddrErrors;
    Values[3] := dwForwDatagrams;
    Values[4] := dwInUnknownProtos;
    Values[5] := dwInDiscards;
    Values[6] := dwInDelivers;
    Values[7] := dwOutRequests;
    Values[8] := dwRoutingDiscards;
    Values[9] := dwOutDiscards;
    Values[10] := dwOutNoRoutes;
    Values[11] := dwReasmReqds;
    Values[12] := dwReasmOks;
    Values[13] := dwReasmFails;
    Values[14] := dwFragOks;
    Values[15] := dwFragFails;
    Values[16] := dwFragCreates;
  end;
  for I := 0 to High(IpDescs) do
    if ReNew then
      with ListView.Items.Add do
      begin
        ImageIndex := 0;
        Caption := SIpv6;
        SubItems.Add(IpDescs[I]);
        SubItems.Add(FormatNumber(Values[I]));
      end
    else
      for J := 0 to ListView.Items.Count - 1 do
        with ListView.Items[J] do
          if (Caption = SIpv6) and (SubItems[0] = IpDescs[I]) then
          begin
            SubItems[1] := FormatNumber(Values[I]);
            Break;
          end;
end;

procedure TMainForm.GetIcmpStats(ReNew: Boolean);
const
  Icmpv4Descs: array[0..14] of string = (
    SMessages,
    SErrors,
    SDestUnreachable,
    STimeExceeded,
    SParameterProblems,
    SSourceQuenchs,
    SRedirects,
    SEchos,
    SEchoReplies,
    STimestamps,
    STimestampReplies,
    SAddressMasks,
    SAddressMaskReplies,
    SRouterSolicitations,
    SRouterAdvertisements);
  Icmpv6Descs: array[0..16] of string = (
    SMessages,
    SErrors,
    SDestUnreachable,
    SPacketTooBig,
    STimeExceeded,
    SParameterProblems,
    SEchos,
    SEchoReplies,
    SMLDQueries,
    SMLDReports,
    SMLDDones,
    SRouterSolicitations,
    SRouterAdvertisements,
    SNeighborSolicitations,
    SNeighborAdvertisements,
    SRedirects,
    SRouterRenumberings);
var
  IcmpStatsEx: TMibIcmpEx;
  Values: array[0..16, 0..1] of DWORD;
  I, J: Integer;
  dwResult: DWORD;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SProtocol;
        Width := 70;
      end;
      with Columns.Add do
      begin
        Caption := SIcmpDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SReceived;
        Alignment := taRightJustify;
        Width := 130;
      end;
      with Columns.Add do
      begin
        Caption := SSent;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  FillChar(IcmpStatsEx, SizeOf(IcmpStatsEx), 0);
  CheckIpHelperResult(GetIcmpStatisticsEx(@IcmpStatsEx, AF_INET));
  with IcmpStatsEx do
  begin
    Values[0,0]  := icmpInStats.dwMsgs;
    Values[1,0]  := icmpInStats.dwErrors;
    Values[2,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP4_DST_UNREACH)];
    Values[3,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP4_TIME_EXCEEDED)];
    Values[4,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP4_PARAM_PROB)];
    Values[5,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP4_SOURCE_QUENCH)];
    Values[6,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP4_REDIRECT)];
    Values[7,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP4_ECHO_REQUEST)];
    Values[8,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP4_ECHO_REPLY)];
    Values[9,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP4_TIMESTAMP_REQUEST)];
    Values[10,0] := icmpInStats.rgdwTypeCount[Ord(ICMP4_TIMESTAMP_REPLY)];
    Values[11,0] := icmpInStats.rgdwTypeCount[Ord(ICMP4_MASK_REQUEST)];
    Values[12,0] := icmpInStats.rgdwTypeCount[Ord(ICMP4_MASK_REPLY)];
    Values[13,0] := icmpInStats.rgdwTypeCount[Ord(ICMP4_ROUTER_ADVERT)];
    Values[14,0] := icmpInStats.rgdwTypeCount[Ord(ICMP4_ROUTER_SOLICIT)];
    Values[0,1]  := icmpOutStats.dwMsgs;
    Values[1,1]  := icmpOutStats.dwErrors;
    Values[2,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP4_DST_UNREACH)];
    Values[3,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP4_TIME_EXCEEDED)];
    Values[4,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP4_PARAM_PROB)];
    Values[5,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP4_SOURCE_QUENCH)];
    Values[6,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP4_REDIRECT)];
    Values[7,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP4_ECHO_REQUEST)];
    Values[8,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP4_ECHO_REPLY)];
    Values[9,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP4_TIMESTAMP_REQUEST)];
    Values[10,1] := icmpOutStats.rgdwTypeCount[Ord(ICMP4_TIMESTAMP_REPLY)];
    Values[11,1] := icmpOutStats.rgdwTypeCount[Ord(ICMP4_MASK_REQUEST)];
    Values[12,1] := icmpOutStats.rgdwTypeCount[Ord(ICMP4_MASK_REPLY)];
    Values[13,1] := icmpOutStats.rgdwTypeCount[Ord(ICMP4_ROUTER_ADVERT)];
    Values[14,1] := icmpOutStats.rgdwTypeCount[Ord(ICMP4_ROUTER_SOLICIT)];
  end;
  for I := 0 to High(Icmpv4Descs)  do
    if ReNew then
      with ListView.Items.Add do
      begin
        ImageIndex := 0;
        Caption := SIcmpv4;
        SubItems.Add(Icmpv4Descs[I]);
        SubItems.Add(FormatNumber(Values[I,0]));
        SubItems.Add(FormatNumber(Values[I,1]));
      end
    else
      for J := 0 to ListView.Items.Count - 1 do
        with ListView.Items[J] do
          if (Caption = SIcmpv4) and (SubItems[0] = Icmpv4Descs[I]) then
          begin
            SubItems[1] := FormatNumber(Values[I,0]);
            SubItems[2] := FormatNumber(Values[I,1]);
            Break;
          end;
  FillChar(IcmpStatsEx, SizeOf(IcmpStatsEx), 0);
  dwResult := GetIcmpStatisticsEx(@IcmpStatsEx, AF_INET6);
  if dwResult = ERROR_NOT_SUPPORTED then
    Exit
  else
    CheckIpHelperResult(dwResult);
  with IcmpStatsEx do
  begin
    Values[0,0]  := icmpInStats.dwMsgs;
    Values[1,0]  := icmpInStats.dwErrors;
    Values[2,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP6_DST_UNREACH)];
    Values[3,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP6_PACKET_TOO_BIG)];
    Values[4,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP6_TIME_EXCEEDED)];
    Values[5,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP6_PARAM_PROB)];
    Values[6,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP6_ECHO_REQUEST)];
    Values[7,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP6_ECHO_REPLY)];
    Values[8,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP6_MEMBERSHIP_QUERY)];
    Values[9,0]  := icmpInStats.rgdwTypeCount[Ord(ICMP6_MEMBERSHIP_REPORT)];
    Values[10,0] := icmpInStats.rgdwTypeCount[Ord(ICMP6_MEMBERSHIP_REDUCTION)];
    Values[11,0] := icmpInStats.rgdwTypeCount[Ord(ND_ROUTER_SOLICIT)];
    Values[12,0] := icmpInStats.rgdwTypeCount[Ord(ND_ROUTER_ADVERT)];
    Values[13,0] := icmpInStats.rgdwTypeCount[Ord(ND_NEIGHBOR_SOLICIT)];
    Values[14,0] := icmpInStats.rgdwTypeCount[Ord(ND_NEIGHBOR_ADVERT)];
    Values[15,0] := icmpInStats.rgdwTypeCount[Ord(ND_REDIRECT)];
    Values[16,0] := icmpInStats.rgdwTypeCount[Ord(ICMP6_V2_MEMBERSHIP_REPORT)];
    Values[0,1]  := icmpOutStats.dwMsgs;
    Values[1,1]  := icmpOutStats.dwErrors;
    Values[2,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP6_DST_UNREACH)];
    Values[3,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP6_PACKET_TOO_BIG)];
    Values[4,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP6_TIME_EXCEEDED)];
    Values[5,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP6_PARAM_PROB)];
    Values[6,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP6_ECHO_REQUEST)];
    Values[7,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP6_ECHO_REPLY)];
    Values[8,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP6_MEMBERSHIP_QUERY)];
    Values[9,1]  := icmpOutStats.rgdwTypeCount[Ord(ICMP6_MEMBERSHIP_REPORT)];
    Values[10,1] := icmpOutStats.rgdwTypeCount[Ord(ICMP6_MEMBERSHIP_REDUCTION)];
    Values[11,1] := icmpOutStats.rgdwTypeCount[Ord(ND_ROUTER_SOLICIT)];
    Values[12,1] := icmpOutStats.rgdwTypeCount[Ord(ND_ROUTER_ADVERT)];
    Values[13,1] := icmpOutStats.rgdwTypeCount[Ord(ND_NEIGHBOR_SOLICIT)];
    Values[14,1] := icmpOutStats.rgdwTypeCount[Ord(ND_NEIGHBOR_ADVERT)];
    Values[15,1] := icmpOutStats.rgdwTypeCount[Ord(ND_REDIRECT)];
    Values[16,1] := icmpOutStats.rgdwTypeCount[Ord(ICMP6_V2_MEMBERSHIP_REPORT)];
  end;
  for I := 0 to High(Icmpv6Descs) do
    if ReNew then
      with ListView.Items.Add do
      begin
        ImageIndex := 0;
        Caption := SIcmpv6;
        SubItems.Add(Icmpv6Descs[I]);
        SubItems.Add(FormatNumber(Values[I,0]));
        SubItems.Add(FormatNumber(Values[I,1]));
      end
    else
      for J := 0 to ListView.Items.Count - 1 do
        with ListView.Items[J] do
          if (Caption = SIcmpv6) and (SubItems[0] = Icmpv6Descs[I]) then
          begin
            SubItems[1] := FormatNumber(Values[I,0]);
            SubItems[2] := FormatNumber(Values[I,1]);
            Break;
          end;
end;

procedure TMainForm.GetTcpStats(ReNew: Boolean);
const
  TcpDescs: array[0..7] of string = (
    SActiveOpens,
    SPassiveOpens,
    SFailedConnAttempts,
    SResetConns,
    SCurrentConns,
    SSegmentsRecv,
    SSegmentsSent,
    SSegmentsRetransmitted);
var
  TcpStats: TMibTcpStats;
  Values: array[0..7] of DWORD;
  I, J: Integer;
  dwResult: DWORD;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SProtocol;
        Width := 70;
      end;
      with Columns.Add do
      begin
        Caption := STcpDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SValue;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  FillChar(TcpStats, SizeOf(TcpStats), 0);
  CheckIpHelperResult(GetTcpStatisticsEx(@TcpStats, AF_INET));
  with TcpStats do
  begin
    Values[0] := dwActiveOpens;
    Values[1] := dwPassiveOpens;
    Values[2] := dwAttemptFails;
    Values[3] := dwEstabResets;
    Values[4] := dwCurrEstab;
    Values[5] := dwInSegs;
    Values[6] := dwOutSegs;
    Values[7] := dwRetransSegs;
  end;
  for I := 0 to High(TcpDescs) do
    if ReNew then
      with ListView.Items.Add do
      begin
        ImageIndex := 0;
        Caption := STcpv4;
        SubItems.Add(TcpDescs[I]);
        SubItems.Add(FormatNumber(Values[I]));
      end
    else
      for J := 0 to ListView.Items.Count - 1 do
        with ListView.Items[J] do
          if (Caption = STcpv4) and (SubItems[0] = TcpDescs[I]) then
          begin
            SubItems[1] := FormatNumber(Values[I]);
            Break;
          end;
  FillChar(TcpStats, SizeOf(TcpStats), 0);
  dwResult := GetTcpStatisticsEx(@TcpStats, AF_INET6);
  if dwResult = ERROR_NOT_SUPPORTED then
    Exit
  else
    CheckIpHelperResult(dwResult);
  with TcpStats do
  begin
    Values[0] := dwActiveOpens;
    Values[1] := dwPassiveOpens;
    Values[2] := dwAttemptFails;
    Values[3] := dwEstabResets;
    Values[4] := dwCurrEstab;
    Values[5] := dwInSegs;
    Values[6] := dwOutSegs;
    Values[7] := dwRetransSegs;
  end;
  for I := 0 to High(TcpDescs) do
    if ReNew then
      with ListView.Items.Add do
      begin
        ImageIndex := 0;
        Caption := STcpv6;
        SubItems.Add(TcpDescs[I]);
        SubItems.Add(FormatNumber(Values[I]));
      end
    else
      for J := 0 to ListView.Items.Count - 1 do
        with ListView.Items[J] do
          if (Caption = STcpv6) and (SubItems[0] = TcpDescs[I]) then
          begin
            SubItems[1] := FormatNumber(Values[I]);
            Break;
          end;
end;

procedure TMainForm.GetUdpStats(ReNew: Boolean);
const
  UdpDescs: array[0..3] of string = (
    SDatagramsRecv,
    SNoPorts,
    SRecvErrors,
    SDatagramsSent);
var
  UdpStats: TMibUdpStats;
  Values: array[0..3] of DWORD;
  I, J: Integer;
  dwResult: DWORD;
begin
  if ReNew then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SProtocol;
        Width := 70;
      end;
      with Columns.Add do
      begin
        Caption := SUdpDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SValue;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  FillChar(UdpStats, SizeOf(UdpStats), 0);
  CheckIpHelperResult(GetUdpStatisticsEx(@UdpStats, AF_INET));
  with UdpStats do
  begin
    Values[0] := dwInDatagrams;
    Values[1] := dwNoPorts;
    Values[2] := dwInErrors;
    Values[3] := dwOutDatagrams;
  end;
  for I := 0 to High(UdpDescs) do
    if ReNew then
      with ListView.Items.Add do
      begin
        ImageIndex := 0;
        Caption := SUdpv4;
        SubItems.Add(UdpDescs[I]);
        SubItems.Add(FormatNumber(Values[I]));
      end
    else
      for J := 0 to ListView.Items.Count - 1 do
        with ListView.Items[J] do
          if (Caption = SUdpv4) and (SubItems[0] = UdpDescs[I]) then
          begin
            SubItems[1] := FormatNumber(Values[I]);
            Break;
          end;
  FillChar(UdpStats, SizeOf(UdpStats), 0);
  dwResult := GetUdpStatisticsEx(@UdpStats, AF_INET6);
  if dwResult = ERROR_NOT_SUPPORTED then
    Exit
  else
    CheckIpHelperResult(dwResult);
  with UdpStats do
  begin
    Values[0] := dwInDatagrams;
    Values[1] := dwNoPorts;
    Values[2] := dwInErrors;
    Values[3] := dwOutDatagrams;
  end;
  for I := 0 to High(UdpDescs) do
    if ReNew then
      with ListView.Items.Add do
      begin
        ImageIndex := 0;
        Caption := SUdpv6;
        SubItems.Add(UdpDescs[I]);
        SubItems.Add(FormatNumber(Values[I]));
      end
    else
      for J := 0 to ListView.Items.Count - 1 do
        with ListView.Items[J] do
          if (Caption = SUdpv6) and (SubItems[0] = UdpDescs[I]) then
          begin
            SubItems[1] := FormatNumber(Values[I]);
            Break;
          end;
end;

procedure TMainForm.PopupClick(Sender: TObject);
begin
  FIfIndex := TMenuItem(Sender).Tag;
  if not actAutoRefresh.Checked then
    actRefresh.Execute;
end;

procedure TMainForm.ListViewPopupPopup(Sender: TObject);
var
  MenuItem: TMenuItem;
  IfTable: PMibIfTable;
  dwSize: DWORD;
  I: Integer;
begin
  ListViewPopup.Items.Clear;
  if FStatType = stConnections then
  begin
    MenuItem := TMenuItem.Create(Self);
    MenuItem.Action := actByName;
    ListViewPopup.Items.Add(MenuItem);
    MenuItem := TMenuItem.Create(Self);
    MenuItem.Action := actAllEndpoints;
    ListViewPopup.Items.Add(MenuItem);
    MenuItem := TMenuItem.Create(Self);
    MenuItem.Caption := '-';
    ListViewPopup.Items.Add(MenuItem);
    MenuItem := TMenuItem.Create(Self);
    MenuItem.Action := actCloseConnection;
    ListViewPopup.Items.Add(MenuItem);
  end
  else if (FStatType = stIf) and
    (GetIfTable(nil, @dwSize, True) = ERROR_INSUFFICIENT_BUFFER) then
  begin
    IfTable := AllocMem(dwSize);
    try
      CheckIpHelperResult(GetIfTable(IfTable, @dwSize, True));
      MenuItem := TMenuItem.Create(Self);
      MenuItem.Caption := SAll;
      MenuItem.Checked := FIfIndex = -1;
      MenuItem.RadioItem := True;
      MenuItem.Tag := -1;
      MenuItem.OnClick := PopupClick;
      ListViewPopup.Items.Add(MenuItem);
      MenuItem := TMenuItem.Create(Self);
      MenuItem.Caption := '-';
      ListViewPopup.Items.Add(MenuItem);
      for I := 0 to IfTable^.dwNumEntries - 1 do
      begin
        MenuItem := TMenuItem.Create(Self);
        MenuItem.Caption := string(PAnsiChar(@IfTable^.table[I].bDescr));
        MenuItem.Checked := (FIfIndex <> -1) and (IfTable^.table[I].dwIndex = DWORD(FIfIndex));
        MenuItem.RadioItem := True;
        MenuItem.Tag := IfTable^.table[I].dwIndex;
        MenuItem.OnClick := PopupClick;
        ListViewPopup.Items.Add(MenuItem);
      end;
    finally
      FreeMem(IfTable);
    end;
  end;
end;

procedure TMainForm.MkFile(const FileName: string; CreationFlag: Boolean);
var
  F: TextFile;
  FmtStr: string;
  I: Integer;
begin
  AssignFile(F, FileName);
  if CreationFlag then
    Rewrite(F)
  else
    Reset(F);
  try
    Append(F);
    Writeln(F, Format(#13#10'*** %s (%s) ***'#13#10, [StatusBar.Panels[1].Text,
      FormatDateTime({$IF CompilerVersion > 22}FormatSettings.{$IFEND}ShortDateFormat +
      ' ' + {$IF CompilerVersion > 22}FormatSettings.{$IFEND}LongTimeFormat, Now)]));
    with ListView do
      case FStatType of
        stNic:
          begin
            FmtStr := '%-80s %-17s %25s %9s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption]));
            Writeln(F, StringOfChar('=', 134));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2]]));
          end;
        stArp:
          begin
            FmtStr := '%-8s %-40s %-17s %-11s %9s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption,
                                       Columns[4].Caption]));
            Writeln(F, StringOfChar('=', 89));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2],
                                         Items[I].SubItems[3]]));
          end;
        stIpAddr:
          begin
            FmtStr := '%-8s %-50s %-15s %9s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption]));
            Writeln(F, StringOfChar('=', 85));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2]]));
          end;
        stRoute:
          begin
            FmtStr := '%-8s %-44s %-15s %-15s %-15s %9s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption,
                                       Columns[4].Caption,
                                       Columns[5].Caption]));
            Writeln(F, StringOfChar('=', 111));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2],
                                         Items[I].SubItems[3],
                                         Items[I].SubItems[4]]));
          end;
        stConnections:
          begin
            FmtStr := '%-8s %-58s %-80s %-12s %-80s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption,
                                       Columns[4].Caption]));
            Writeln(F, StringOfChar('=', 242));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2],
                                         Items[I].SubItems[3]]));
          end;
        stIf:
          begin
            FmtStr := '%-21s %25s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption]));
            Writeln(F, StringOfChar('=', 73));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1]]));
          end;
        stIp:
          begin
            FmtStr := '%-8s %-33s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption]));
            Writeln(F, StringOfChar('=', 68));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1]]));
          end;
        stIcmp:
          begin
            FmtStr := '%-8s %-23s %25s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption]));
            Writeln(F, StringOfChar('=', 84));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2]]));
          end;
        stTcp:
          begin
            FmtStr := '%-8s %-26s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption]));
            Writeln(F, StringOfChar('=', 61));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1]]));
          end;
        stUdp:
          begin
            FmtStr := '%-8s %-18s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption]));
            Writeln(F, StringOfChar('=', 53));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1]]));
          end;
      end;
  finally
    CloseFile(F);
  end;
end;

initialization
  InitNetIoApi;
  EnableDebugPrivilege;
end.

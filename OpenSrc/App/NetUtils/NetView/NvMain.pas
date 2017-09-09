{*******************************************************}
{                                                       }
{                 NetView Version 2.7                   }
{                                                       }
{          Copyright (c) 1999-2016 Vadim Crits          }
{                                                       }
{*******************************************************}

unit NvMain;

{$B-,R-}
{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, Menus, ImgList, ActnList, ExtCtrls, StdCtrls, CBEx, LVEx,
  NetBase;

type
  TResourceType = (rtComputer, rtSharedFolder, rtSharedPrinter);

  TMainForm = class(TBaseForm)
    StatusBar: TStatusBar;
    ListView: TListViewEx;
    ImageList: TImageList;
    CoolBar: TCoolBarEx;
    ActionList: TActionList;
    actSave: TAction;
    actSaveAs: TAction;
    actExit: TAction;
    actToolBar: TAction;
    actStatusBar: TAction;
    actRefresh: TAction;
    actFind: TAction;
    actPing: TAction;
    actAbout: TAction;
    MenuBar: TToolBar;
    PopupMenu: TPopupMenu;
    ToolBar: TToolBar;
    btnSave: TToolButton;
    ToolButton1: TToolButton;
    btnStop: TToolButton;
    btnRefresh: TToolButton;
    btnFind: TToolButton;
    btnPing: TToolButton;
    actStop: TAction;
    ResourceBar: TToolBar;
    cboResource: TComboBox;
    btnGo: TToolButton;
    actGo: TAction;
    actResourceBar: TAction;
    TbrImages: TImageList;
    TbrHotImages: TImageList;
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miView: TMenuItem;
    miResource: TMenuItem;
    miHelp: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    N1: TMenuItem;
    miExit: TMenuItem;
    miToolbars: TMenuItem;
    miStatusBar: TMenuItem;
    N2: TMenuItem;
    miGo: TMenuItem;
    miStop: TMenuItem;
    miRefresh: TMenuItem;
    miStandardButtons: TMenuItem;
    miResourceBar: TMenuItem;
    miFind: TMenuItem;
    miPing: TMenuItem;
    miAbout: TMenuItem;
    actOpen: TAction;
    btnOpen: TToolButton;
    ProgressBar: TProgressBar;
    miOpen: TMenuItem;
    piOpen: TMenuItem;
    piPing: TMenuItem;
    btnShutdown: TToolButton;
    actShutdown: TAction;
    piShutdown: TMenuItem;
    miShutdown: TMenuItem;
    edtDomain: TEdit;
    ToolButton2: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StatusBarResize(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure ComboBoxOrEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboResourceDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ResourceBarResize(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actToolBarExecute(Sender: TObject);
    procedure actResourceBarExecute(Sender: TObject);
    procedure actStatusBarExecute(Sender: TObject);
    procedure actGoExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actPingExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure PopupMenuPopup(Sender: TObject);
    procedure actShutdownExecute(Sender: TObject);
  private
    { Private declarations }
    FFileName: string;
    FResourceType: TResourceType;
    procedure UpdateResourceView;
    procedure ChildThreadDone(Sender: TObject);
    procedure MkFile(const FileName: string; CreationFlag: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses NvFind, NvPing, NvShdown, NvConst, NetConst, NetUtils, NetAbout, LMNet,
  WinSock, IPHlpApi, ShellAPI, Themes;

{$R *.dfm}

const
  NetResNames: array[TResourceType] of string = (
    SComputer,
    SSharedFolder,
    SSharedPrinter);

type
  PItemData = ^TItemData;
  TItemData = record
    ImageIndex: Integer;
    Caption : string;
    SubItem0: string;
    SubItem1: string;
    SubItem2: string;
    SubItem3: string;
    SubItem4: string;
    SubItem5: string;
  end;

{ TChildThread }

type
  TChildThread = class(TThread)
  private
    FResourceType: TResourceType;
    FDomain: string;
    FMaxValue: Integer;
    FItemData: TItemData;
    function GetDomain(const ServerName: string): string;
    function GetIpAddress(const ServerName: string): string;
    function GetMacAddress(const IpAddress: string): string;
    function GetUpTime(const ServerName: string): string;
    function GetServerType(Flags: DWORD): string;
    procedure GetServerInfo(ServerInfo: Pointer);
    procedure AddItem;
    procedure SetMax;
    procedure SetPosition;
  protected
    procedure Execute; override;
  public
    constructor Create(ResourceType: TResourceType; const Domain: string);
  end;

var
  ChildThread: TChildThread;

constructor TChildThread.Create(ResourceType: TResourceType; const Domain: string);
begin
  FResourceType := ResourceType;
  FDomain := Domain;
  inherited Create(False);
end;

function TChildThread.GetDomain(const ServerName: string): string;
var
  Domain: PWideChar;
  JoinStatus: TNetSetupJoinStatus;
begin
  Result := SUnknown;
  if NetGetJoinInformation(PWideChar(WideString(ServerName)),
    Domain, @JoinStatus) = NERR_Success then
  try
    if JoinStatus in [NetSetupWorkgroupName, NetSetupDomainName] then
      SetString(Result, Domain, Length(Domain));
  finally
    NetApiBufferFree(Domain);
  end;
end;

function TChildThread.GetIpAddress(const ServerName: string): string;
var
  Hints: TAddrInfo;
  Res: PAddrInfo;
begin
  Result := SUnknown;
  FillChar(Hints, SizeOf(Hints), 0);
  Hints.ai_family := AF_INET;
  Hints.ai_socktype := SOCK_STREAM;
  Hints.ai_protocol := IPPROTO_TCP;
  if getaddrinfo(PAnsiChar(AnsiString(ServerName)), nil, @Hints, Res) = 0 then
  begin
    Result := FormatIpAddress(PSockAddrInet(Res^.ai_addr)^);
    freeaddrinfo(Res);
  end;
end;

function TChildThread.GetMacAddress(const IpAddress: string): string;
var
  MacAddr: array[0..5] of Byte;
  AddrLen: ULONG;
begin
  Result := SUnknown;
  AddrLen := SizeOf(MacAddr);
  if SendARP(inet_addr(PAnsiChar(AnsiString(IpAddress))),
    0, @MacAddr, @AddrLen) = NO_ERROR then
    Result := FormatMacAddress(MacAddr);
end;

function TChildThread.GetUpTime(const ServerName: string): string;
var
  TimeOfDayInfo: PTimeOfDayInfo;
  Days, Hours, Mins, Secs: Word;
  Time: TDateTime;
begin
  Result := SUnknown;
  if NetRemoteTOD(PWideChar(WideString(ServerName)),
    PByte(TimeOfDayInfo)) = NERR_Success then
  try
    DecodeMSecs(TimeOfDayInfo^.tod_msecs, Days, Hours, Mins, Secs);
    Time := EncodeTime(Hours, Mins, Secs, 0);
    Result := Format(FormatDateTime(SShortUpTimeFmt, Time), [Days]);
  finally
    NetApiBufferFree(TimeOfDayInfo);
  end;
end;

function TChildThread.GetServerType(Flags: DWORD): string;
const
  ServerType: array[0..28] of DWORD = (
    SV_TYPE_WORKSTATION,
    SV_TYPE_SERVER,
    SV_TYPE_SQLSERVER,
    SV_TYPE_DOMAIN_CTRL,
    SV_TYPE_DOMAIN_BAKCTRL,
    SV_TYPE_TIME_SOURCE,
    SV_TYPE_AFP,
    SV_TYPE_NOVELL,
    SV_TYPE_DOMAIN_MEMBER,
    SV_TYPE_PRINTQ_SERVER,
    SV_TYPE_DIALIN_SERVER,
    SV_TYPE_SERVER_UNIX,
    SV_TYPE_NT,
    SV_TYPE_WFW,
    SV_TYPE_SERVER_MFPN,
    SV_TYPE_SERVER_NT,
    SV_TYPE_POTENTIAL_BROWSER,
    SV_TYPE_BACKUP_BROWSER,
    SV_TYPE_MASTER_BROWSER,
    SV_TYPE_DOMAIN_MASTER,
    SV_TYPE_SERVER_OSF,
    SV_TYPE_SERVER_VMS,
    SV_TYPE_WINDOWS,
    SV_TYPE_DFS,
    SV_TYPE_CLUSTER_NT,
    SV_TYPE_TERMINALSERVER,
    SV_TYPE_CLUSTER_VS_NT,
    SV_TYPE_DCE,
    SV_TYPE_ALTERNATE_XPORT);
  ServerTypeNames: array[0..28] of string = (
    'WORKSTATION',
    'SERVER',
    'SQLSERVER',
    'DOMAIN_CTRL',
    'DOMAIN_BAKCTRL',
    'TIME_SOURCE',
    'AFP',
    'NOVELL',
    'DOMAIN_MEMBER',
    'PRINTQ_SERVER',
    'DIALIN_SERVER',
    'SERVER_UNIX',
    'NT',
    'WFW',
    'SERVER_MFPN',
    'SERVER_NT',
    'POTENTIAL_BROWSER',
    'BACKUP_BROWSER',
    'MASTER_BROWSER',
    'DOMAIN_MASTER',
    'SERVER_OSF',
    'SERVER_VMS',
    'WINDOWS',
    'DFS',
    'CLUSTER_NT',
    'TERMINALSERVER',
    'CLUSTER_VS_NT',
    'DCE',
    'ALTERNATE_XPORT');
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(ServerType) do
    if Flags and ServerType[I] = ServerType[I] then
    begin
      if Result <> '' then
        Result := Result + ', ';
      Result := Result + ServerTypeNames[I];
    end;
  if Result = '' then
    Result := SUnknown;
end;

procedure TChildThread.GetServerInfo(ServerInfo: Pointer);
type
  PShareInfoTable = ^TShareInfoTable;
  TShareInfoTable = array[0..0] of TShareInfo1;
var
  Domain: string;
  dwResult, dwEntriesRead, dwTotalEntries, dwResumeHandle: DWORD;
  ShareInfoTable, ShareInfo: Pointer;
  I: Integer;
begin
  with PServerInfo101(ServerInfo)^ do
  begin
    Domain := FDomain;
    if Domain = '' then
      Domain := GetDomain(sv101_name);
    case FResourceType of
      rtComputer:
        with FItemData do
        begin
          ImageIndex := Ord(FResourceType);
          Caption := '\\' + sv101_name;
          SubItem0 := Domain;
          SubItem1 := GetIpAddress(sv101_name);
          SubItem2 := GetMacAddress(SubItem1);
          SubItem3 := GetServerType(sv101_type);
          SubItem4 := GetUpTime(sv101_name);
          SubItem5 := sv101_comment;
          if (SubItem1 = SUnknown) and (SubItem4 = SUnknown) then
            ImageIndex := 3;
          Synchronize(AddItem);
        end;
      rtSharedFolder, rtSharedPrinter:
        begin
          dwResumeHandle := 0;
          repeat
            dwResult := NetShareEnum(sv101_name, 1, ShareInfoTable,
              MAX_PREFERRED_LENGTH, @dwEntriesRead, @dwTotalEntries, @dwResumeHandle);
            if dwResult in [NERR_Success, ERROR_MORE_DATA] then
            try
              for I := 0 to dwEntriesRead - 1 do
              begin
                if Terminated then
                  Exit;
                with PShareInfoTable(ShareInfoTable)^[I] do
                  if ((FResourceType = rtSharedFolder) and (shi1_type = STYPE_DISKTREE)) or
                    ((FResourceType = rtSharedPrinter) and (shi1_type = STYPE_PRINTQ)) then
                  with FItemData do
                  begin
                    ImageIndex := Ord(FResourceType);
                    Caption := '\\' + sv101_name + '\' + shi1_netname;
                    SubItem0 := Domain;
                    if FResourceType = rtSharedFolder then
                    begin
                      SubItem1 := SUnknown;
                      SubItem2 := SUnknown;
                      SubItem3 := SUnknown;
                      if NetShareGetInfo(sv101_name, shi1_netname, 2, ShareInfo) = NERR_Success then
                      try
                        with PShareInfo2(ShareInfo)^ do
                        begin
                          SubItem1 := shi2_path;
                          SubItem2 := IntToStr(Integer(shi2_max_uses));
                          SubItem3 := IntToStr(shi2_current_uses);
                        end;
                      finally
                        NetApiBufferFree(ShareInfo);
                      end;
                      SubItem4 := shi1_remark;
                    end
                    else
                      SubItem1 := shi1_remark;
                    Synchronize(AddItem);
                  end;
              end;
            finally
              if Assigned(ShareInfoTable) then
                NetApiBufferFree(ShareInfoTable);
            end
            else
              Break;
          until (dwResult = NERR_Success) and not Terminated;
        end;
    end;
  end;
end;

procedure TChildThread.AddItem;
begin
  with MainForm.ListView.Items.Add do
  begin
    ImageIndex := FItemData.ImageIndex;
    Caption := FItemData.Caption;
    SubItems.Add(FItemData.SubItem0);
    SubItems.Add(FItemData.SubItem1);
    if FResourceType in [rtComputer, rtSharedFolder] then
    begin
      SubItems.Add(FItemData.SubItem2);
      SubItems.Add(FItemData.SubItem3);
      SubItems.Add(FItemData.SubItem4);
      if FResourceType = rtComputer then
        SubItems.Add(FItemData.SubItem5);
    end;
  end;
end;

procedure TChildThread.SetMax;
begin
  MainForm.ProgressBar.Max := FMaxValue;
end;

procedure TChildThread.SetPosition;
begin
  MainForm.ProgressBar.StepIt;
end;

procedure TChildThread.Execute;

  function IfThen(AValue: Boolean; const ATrue, AFalse: PWideChar): PWideChar;
  begin
    if AValue then
      Result := ATrue
    else
      Result := AFalse;
  end;

type
  PServerInfoTable = ^TServerInfoTable;
  TServerInfoTable = array[0..0] of TServerInfo101;
var
  dwResult, dwEntriesRead, dwTotalEntries, dwResumeHandle: DWORD;
  ServerInfoTable: Pointer;
  I: Integer;
begin
  dwResumeHandle := 0;
  repeat
    dwResult := NetServerEnum(nil, 101, ServerInfoTable, MAX_PREFERRED_LENGTH,
      @dwEntriesRead, @dwTotalEntries, SV_TYPE_ALL, IfThen(FDomain = '', nil,
      PWideChar(WideString(FDomain))), @dwResumeHandle);
    if dwResult in [NERR_Success, ERROR_MORE_DATA] then
    try
      FMaxValue := dwTotalEntries;
      Synchronize(SetMax);
      for I := 0 to dwEntriesRead - 1 do
      begin
        if Terminated then
          Exit;
        GetServerInfo(@PServerInfoTable(ServerInfoTable)^[I]);
        Synchronize(SetPosition);
      end;
    finally
      if Assigned(ServerInfoTable) then
        NetApiBufferFree(ServerInfoTable);
    end
    else
      raise Exception.Create(SysErrorMessage(dwResult));
  until (dwResult = NERR_Success) and not Terminated;
end;

{ TMainForm }

procedure TMainForm.UpdateResourceView;

  procedure AddColumns(const A: array of string);
  var
    I: Integer;
  begin
    for I := 0 to High(A) do
      with ListView.Columns.Add do
      begin
        Caption := A[I];
        Width := 130;
      end;
  end;

const
  ComputerColTitles: array[0..6] of string = (
    SName,
    SDomain,
    SIpAddress,
    SMacAddress,
    SType,
    SUpTime,
    SComment);
  SharedFolderColTitles: array[0..5] of string = (
    SName,
    SDomain,
    SPath,
    SMaxUses,
    SCurrentUses,
    SComment);
  SharedPrinterColTitles: array[0..2] of string = (
    SName,
    SDomain,
    SComment);
var
  ResourceType: TResourceType;
begin
  Screen.Cursor := crAppStart;
  ProgressBar.Visible := True;
  StatusBar.Panels[0].Text := SUpdating;
  ResourceType := TResourceType(cboResource.ItemIndex);
  with ListView do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
    finally
      Items.EndUpdate;
    end;
    if actGo.Enabled then
    begin
      Columns.BeginUpdate;
      try
        Columns.Clear;
      finally
        Columns.EndUpdate;
      end;
      case ResourceType of
        rtComputer:
          AddColumns(ComputerColTitles);
        rtSharedFolder:
          begin
            AddColumns(SharedFolderColTitles);
            Columns[3].Alignment := taRightJustify;
            Columns[4].Alignment := taRightJustify;
          end;
        rtSharedPrinter:
          AddColumns(SharedPrinterColTitles);
      end;
    end;
  end;
  ChildThread := TChildThread.Create(ResourceType, Trim(edtDomain.Text));
  ChildThread.OnTerminate := ChildThreadDone;
  ChildThread.FreeOnTerminate := True;
  FResourceType := ResourceType;
end;

procedure TMainForm.ChildThreadDone(Sender: TObject);
begin
  with ChildThread do
    if Assigned(FatalException) then
      Application.ShowException(Exception(FatalException));
  ProgressBar.Position := 0;
  ProgressBar.Visible := False;
  StatusBar.Panels[0].Text := Format(SResCount, [ListView.Items.Count,
                                                 AnsiLowerCase(NetResNames[FResourceType])]);
  ChildThread := nil;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  RetVal: Integer;
  WSAData: TWSAData;
  I: TResourceType;
begin
  RetVal := WSAStartup($0202, WSAData);
  if RetVal <> 0 then
    with Application do
    begin
      MessageBox(PChar(SysErrorMessage(RetVal)),
                 PChar(Title), MB_OK or MB_ICONERROR);
      ShowMainForm := False;
      Terminate;
    end;
  with cboResource do
  begin
    ItemHeight := Canvas.TextHeight('0') + 2;
    for I := Low(NetResNames) to High(NetResNames) do
      Items.Add(NetResNames[I]);
    ItemIndex := 0;
  end;
  with ProgressBar do
  begin
    Parent := StatusBar;
    Step := 1;
    Visible := False;
  end;
  with Registry do
    if OpenKey(ApplicationKey, False) then
    try
      if ValueExists(SResourceType) then
        cboResource.ItemIndex := ReadInteger(SResourceType);
      if ValueExists(SShowToolBar) then
        ToolBar.Visible := ReadBool(SShowToolBar);
      if ValueExists(SShowResourceBar) then
        ResourceBar.Visible := ReadBool(SShowResourceBar);
      if ValueExists(SShowStatusBar) then
        StatusBar.Visible := ReadBool(SShowStatusBar);
      if ValueExists(SLastDomain) then
        edtDomain.Text := ReadString(SLastDomain);
    finally
      CloseKey;
    end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if ResourceBar.Height < cboResource.Height then
    ResourceBar.Constraints.MinHeight := cboResource.Height;
  ResourceBar.Perform(WM_SIZE, 0, 0);
  UpdateResourceView;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  with Registry do
    if OpenKey(ApplicationKey, True) then
    try
      WriteInteger(SResourceType, Ord(FResourceType));
      WriteBool(SShowToolBar, ToolBar.Visible);
      WriteBool(SShowResourceBar, ResourceBar.Visible);
      WriteBool(SShowStatusBar, StatusBar.Visible);
      WriteString(SLastDomain, edtDomain.Text);
    finally
      CloseKey;
    end;
  actStop.Execute;
  WSACleanup;
end;

procedure TMainForm.ListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if Data = -1 then
    Compare := AnsiCompareText(Item1.Caption, Item2.Caption)
  else if (Data = 1) and (FResourceType = rtComputer) then
    Compare := AnsiCompareText(AlignIpAddress(Item1.SubItems[Data]),
                               AlignIpAddress(Item2.SubItems[Data]))
  else if (Data in [2, 3]) and (FResourceType = rtSharedFolder) then
    Compare := CompareNumber(StrToIntDef(Item1.SubItems[Data], -MaxInt),
                             StrToIntDef(Item2.SubItems[Data], -MaxInt))
  else if (Data = 4) and (FResourceType = rtComputer) then
    Compare := AnsiCompareText(AlignString(Item1.SubItems[Data]),
                               AlignString(Item2.SubItems[Data]))
  else
    Compare := AnsiCompareText(Item1.SubItems[Data],
                               Item2.SubItems[Data]);
  if ListView.SortOrder = soDown then
    Compare := -Compare;
end;

procedure TMainForm.ListViewDblClick(Sender: TObject);
begin
  actOpen.Execute;
end;

procedure TMainForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    actOpen.Execute;
end;

procedure TMainForm.StatusBarResize(Sender: TObject);
const
  W = 150;
begin
  with Sender as TStatusBar do
  begin
    if ClientWidth >= Panels[2].Width + W then
    begin
      Panels[0].Width := ClientWidth - Panels[1].Width - Panels[2].Width;
      if Panels[1].Width <= W then
        Panels[1].Width := W;
    end
    else
    begin
      Panels[0].Width := 1;
      Panels[1].Width := ClientWidth - Panels[2].Width;
      if ClientWidth <= Panels[2].Width then
        Panels[1].Width := 0;
    end;
    with ProgressBar do
    begin
      Left := Panels[0].Width + 2;
      if {$IF CompilerVersion < 23}
           ThemeServices.ThemesEnabled
         {$ELSE}
           StyleServices.Enabled
         {$IFEND} then
      begin
        Top := 4;
        Width := Panels[1].Width - 6;
        Height := StatusBar.Height - 6;
      end
      else
      begin
        Top := 2;
        Width := Panels[1].Width - 2;
        Height := StatusBar.Height - 2;
      end;
    end;
  end;
end;

procedure TMainForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  with StatusBar do
  begin
    ImageList.Draw(Canvas, Rect.Left + 1, Rect.Top +
      (Rect.Bottom - Rect.Top - ImageList.Height) div 2, 4);
    Canvas.TextOut(Rect.Left + ImageList.Width + 5, Rect.Top +
      (Rect.Bottom - Rect.Top - Canvas.TextHeight('0')) div 2, SNetwork);
  end;
end;

procedure TMainForm.ComboBoxOrEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    UpdateResourceView;
end;

procedure TMainForm.cboResourceDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  OldRect: TRect;
  DrawingStyle: TDrawingStyle;
begin
  with Control as TComboBox do
  begin
    OldRect := Rect;
    if odSelected in State then
      DrawingStyle := ImgList.dsSelected
    else
      DrawingStyle := ImgList.dsNormal;
    ImageList.Draw(Canvas, Rect.Left,
      Rect.Top + (Rect.Bottom - Rect.Top - ImageList.Height) div 2,
      Index, DrawingStyle, itImage);
    Rect.Right := Rect.Left + Canvas.TextWidth(Items[Index]) + 4;
    OffsetRect(Rect, ImageList.Width + 2, 0);
    Canvas.FillRect(Rect);
    Canvas.TextOut(Rect.Left + 2,
      Rect.Top + (Rect.Bottom - Rect.Top - Canvas.TextHeight('0')) div 2,
      Items[Index]);
    if odFocused in State then
    begin
      Canvas.DrawFocusRect(OldRect);
      Canvas.DrawFocusRect(Rect);
    end;
  end;
end;

procedure TMainForm.ResourceBarResize(Sender: TObject);
begin
  cboResource.Width := ResourceBar.Width - btnGo.Width - edtDomain.Width -
    ToolButton2.Width;
end;

procedure TMainForm.actSaveExecute(Sender: TObject);
begin
  if (FFileName = '') or not FileExists(FFileName) then
    actSaveAs.Execute
  else
    MkFile(FFileName, False);
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

procedure TMainForm.actResourceBarExecute(Sender: TObject);
begin
  with CoolBar.Bands.FindBand(ResourceBar) do
    Visible := not Visible;
end;

procedure TMainForm.actStatusBarExecute(Sender: TObject);
begin
  StatusBar.Visible := not StatusBar.Visible;
end;

procedure TMainForm.actGoExecute(Sender: TObject);
begin
  UpdateResourceView;
end;

procedure TMainForm.actStopExecute(Sender: TObject);
begin
  if Assigned(ChildThread) then
    with ChildThread do
    begin
      if Terminated then
        Exit;
      Terminate;
      StatusBar.Panels[0].Text := SStopping;
      while Assigned(ChildThread) do // instead of WaitFor
        Application.HandleMessage;
    end;
end;

procedure TMainForm.actRefreshExecute(Sender: TObject);
begin
  UpdateResourceView;
end;

procedure TMainForm.actFindExecute(Sender: TObject);
begin
  ShowFindDialog(Self);
end;

procedure TMainForm.actOpenExecute(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(ListView.Selected.Caption), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TMainForm.actPingExecute(Sender: TObject);
begin
  with ListView.Selected do
    ShowPingDialog(Self, Copy(Caption, 3, MaxInt), SubItems[1]);
end;

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  ShowAboutDialog(Self);
end;

procedure TMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actStop.Enabled := Assigned(ChildThread);
  actStop.Visible := actStop.Enabled;
  actGo.Enabled := not actStop.Enabled and
    ((FResourceType <> TResourceType(cboResource.ItemIndex)) or
    (ListView.Columns.Count = 0));
  actGo.Visible := actGo.Enabled;
  actRefresh.Enabled := not actStop.Enabled and not actGo.Enabled;
  actRefresh.Visible := actRefresh.Enabled;
  actSave.Enabled := not actStop.Enabled;
  actSaveAs.Enabled := actSave.Enabled;
  actToolBar.Checked := ToolBar.Visible;
  actResourceBar.Checked := ResourceBar.Visible;
  actStatusBar.Checked := StatusBar.Visible;
  with ListView do
  begin
    actFind.Enabled := Items.Count > 0;
    actOpen.Enabled := Assigned(Selected) and (Selected.ImageIndex in [0, 1]);
    actPing.Enabled := Assigned(Selected) and (Selected.ImageIndex = 0);
  end;
  actShutdown.Enabled := actPing.Enabled;
end;

procedure TMainForm.PopupMenuPopup(Sender: TObject);
begin
  actOpen.Update;
  piOpen.Visible := actOpen.Enabled;
  piPing.Visible := actPing.Enabled;
  piShutdown.Visible := actPing.Enabled;
end;

procedure TMainForm.actShutdownExecute(Sender: TObject);
begin
  ShowShutdownDialog(Self, Copy(ListView.Selected.Caption, 3, MaxInt));
end;

procedure TMainForm.MkFile(const FileName: string; CreationFlag: Boolean);
var
  F: TextFile;
  SaveCursor: TCursor;
  FmtStr: string;
  I: Integer;
begin
  AssignFile(F, FileName);
  if CreationFlag then
    Rewrite(F)
  else
    Reset(F);
  SaveCursor := Screen.Cursor;
  try
    Screen.Cursor := crAppStart;
    Append(F);
    Writeln(F, Format(#13#10'*** %s (%s) ***'#13#10, [NetResNames[FResourceType],
      FormatDateTime({$IF CompilerVersion > 22}FormatSettings.{$IFEND}ShortDateFormat +
      ' ' + {$IF CompilerVersion > 22}FormatSettings.{$IFEND}LongTimeFormat, Now)]));
    with ListView do
      case FResourceType of
        rtComputer:
          begin
            FmtStr := '%-17s %-16s %-15s %-17s %-119s %-17s %-48s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption,
                                       Columns[4].Caption,
                                       Columns[5].Caption,
                                       Columns[6].Caption]));
            Writeln(F, StringOfChar('=', 255));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2],
                                         Items[I].SubItems[3],
                                         Items[I].SubItems[4],
                                         Items[I].SubItems[5]]));
          end;
        rtSharedFolder:
          begin
            FmtStr := '%-48s %-16s %-48s %8s %12s %-48s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption,
                                       Columns[4].Caption,
                                       Columns[5].Caption]));
            Writeln(F, StringOfChar('=', 185));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2],
                                         Items[I].SubItems[3],
                                         Items[I].SubItems[4]]));
          end;
        rtSharedPrinter:
          begin
            FmtStr := '%-48s %-16s %-48s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption]));
            Writeln(F, StringOfChar('=', 114));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1]]));
          end;
      end;
  finally
    CloseFile(F);
    Screen.Cursor := SaveCursor;
  end;
end;

end.

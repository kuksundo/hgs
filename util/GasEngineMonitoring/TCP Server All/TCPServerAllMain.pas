unit TCPServerAllMain;

interface

uses
  AsyncCalls, AsyncCallsHelper,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdTCPServer, IdBaseComponent, IdStreamVCL,
  IdComponent, IdStack, Menus, ExtCtrls, iniFiles,
  TCPServerAllConfig, TCPServerAllConst, ComCtrls, SyncObjs,
  IdContext, IdCustomTCPServer, JvComponentBase, JvTrayIcon, JvExControls,
  JvXPCore, JvXPButtons, SynEdit, SynMemo, UnitFrameIPCMonitorAll, JvExComCtrls,
  JvStatusBar, HiMECSConst, TimerPool,
  UnitFrameIPCMonitorAll4GasEngine;

const
  TCPSERVER_SECTION = 'TCP Server';

type
  TDisplayTarget = (dtSystemLog, dtConnectLog, dtCommLog, dtStatusBar);

  PClient   = ^TClient;
  TClient   = record  // Object holding data of client (see events)
    DNS         : String[20];            { Hostname }
    Connected,                           { Time of connect }
    LastAction  : TDateTime;             { Time of last transaction }
    Thread      : Pointer;               { Pointer to thread }
  end;

  TServerFrmMain = class(TForm)
    TFrameIPCMonitorAll4GasEngine1: TFrameIPCMonitorAll4GasEngine;
    IdTCPServer1: TIdTCPServer;
    JvTrayIcon1: TJvTrayIcon;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    rlsmd1: TMenuItem;
    StopMonitor1: TMenuItem;
    StartMonitor1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lvConnections: TListView;
    TabSheet2: TTabSheet;
    Splitter2: TSplitter;
    SendMemo: TRichEdit;
    Recvmemo: TRichEdit;
    TabSheet3: TTabSheet;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    SMUDPSysLog: TSynMemo;
    JvStatusBar1: TJvStatusBar;
    TabSheet5: TTabSheet;
    SMUDPConnectLog: TSynMemo;
    TabSheet6: TTabSheet;
    SMCommLog: TSynMemo;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LblPort: TLabel;
    LblCurConnent: TLabel;
    LblMaxConn: TLabel;
    Label8: TLabel;
    LblIP: TLabel;
    JvXPButton1: TJvXPButton;
    JvXPButton2: TJvXPButton;
    JvXPButton3: TJvXPButton;
    JvXPButton4: TJvXPButton;
    JvXPButton5: TJvXPButton;
    JvXPButton6: TJvXPButton;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N5: TMenuItem;
    MenuItem4: TMenuItem;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);

    procedure Button1Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
    procedure JvXPButton1Click(Sender: TObject);
    procedure JvXPButton2Click(Sender: TObject);
    procedure JvXPButton6Click(Sender: TObject);
    procedure StopMonitor1Click(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;

    procedure OnSendTCP(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure AsyncSendTCP;
    function AsyncSendTCP2(AContext: TIdContext): integer;
    procedure LoadConfigDataini2Form(ConfigForm:TTCPConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TTCPConfigF);
    procedure AdjustConfigData;
  public
    FSendInterval: integer;
    FPortNum: integer;
    FFilePath: string;      //파일을 저장할 경로
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FDestroying: Boolean;   //종료중이면 True(종료시 먹통 떄문에 추가함)
    FCriticalSection: TCriticalSection;
    FIsTCPSending: boolean;

    FIPAddress: string;

    FEngineParameterItemRecord: TEngineParameterItemRecord;

    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
    procedure InitVar;
    procedure DisconnectAll;
    procedure IPCAll_Init;
    procedure IPCAll_Final;
  end;

var
  ServerFrmMain   : TServerFrmMain;
  Clients         : TList;     // Holds the data of all clients
  GStack: TIdStack = nil;

implementation

uses TCPAll_Util, TCPServerAll_Util;

{$R *.DFM}

procedure TServerFrmMain.FormCreate(Sender: TObject);
begin
  Clients := TList.Create;
  InitVar;
end;

procedure TServerFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMonitorStart := False;
  FDestroying := True;

  DisconnectAll;
  IdTCPServer1.Active := False;
  Clients.Free;
  FCriticalSection.Free;

  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;

  IPCAll_Final;
end;

////////////////////////////////////////////////////////////////////////////////
//프로그램 초기호 Timer1Timer 구문
procedure TServerFrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨

  TFrameIPCMonitorAll4GasEngine1.InitVar;//FConfigOption을 먼저 생성 후
  LoadConfigDataini2Var; //FConfigOption.ModbusMapFileName 할당함
  AdjustConfigData;

  IPCAll_Init;

  FMonitorStart := True;

  LblPort.Caption := IntToStr(FPortNum);
  LblIP.Caption := FIPAddress;

 // DisplayMessage(DateTimeToStr(now)+' Connection from "', dtCommLog);
end;

procedure TServerFrmMain.TrayIcon1DblClick(Sender: TObject);
begin
  application.Restore;
  ShowWindow(Application.Handle, SW_HIDE);
  Show;
end;

//ini 파일에서 초기화정보를 읽어 Form에다 뿌려주는 함수/////////////////////////
procedure TServerFrmMain.LoadConfigDataini2Form(ConfigForm: TTCPConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+'.ini');
  try
    with iniFile, ConfigForm do
    begin
      HostIpCB.Text := ReadString(TCPSERVER_SECTION, 'IP', '10.14.23.11');
      PortEdit.Text := ReadString(TCPSERVER_SECTION, 'Port', '47110');
      SendIntervalEdit.Text := ReadString(TCPSERVER_SECTION, 'Send Interval', '1000');
      JvFilenameEdit1.Text := ReadString(TCPSERVER_SECTION, 'Map File Name', '');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

//ini 파일에서 초기화정보를 읽어 프로그램에서 사용하는 변수로 저장하는 함수/////
procedure TServerFrmMain.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+'.ini');
  try
    with iniFile do
    begin
      FIPAddress := ReadString(TCPSERVER_SECTION, 'IP', '10.14.23.11');
      FPortNum := StrToInt(ReadString(TCPSERVER_SECTION, 'Port', '47110'));
      FSendInterval := ReadInteger(TCPSERVER_SECTION, 'Send Interval', 1000);
      TFrameIPCMonitorAll4GasEngine1.FModbusMapFileName := ReadString(TCPSERVER_SECTION, 'Map File Name', '');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TServerFrmMain.MenuItem1Click(Sender: TObject);
begin
  application.Restore;
  ShowWindow(Application.Handle, SW_HIDE);
  Show;
end;

procedure TServerFrmMain.MenuItem3Click(Sender: TObject);
begin
  ShowMessage('AVAT ECS TCP Server!');
end;

procedure TServerFrmMain.MenuItem4Click(Sender: TObject);
begin
  application.Terminate;
end;

//ini파일로 Host의 Port, IP 주소를 저장하는 함수 ///////////////////////////////
procedure TServerFrmMain.SaveConfigDataForm2ini(ConfigForm: TTCPConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+'.ini');
  try
    with iniFile, ConfigForm do
    begin
      WriteString(TCPSERVER_SECTION, 'IP', HostIPCB.Text);
      WriteString(TCPSERVER_SECTION, 'Port', PortEdit.Text);
      WriteString(TCPSERVER_SECTION, 'Send Interval', SendIntervalEdit.Text);
      WriteString(TCPSERVER_SECTION, 'Map File Name', JvFilenameEdit1.Text);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TServerFrmMain.StopMonitor1Click(Sender: TObject);
begin

end;

//시스템 초기 값 설정///////////////////////////////////////////////////////////
procedure TServerFrmMain.IdTCPServer1Connect(AContext: TIdContext);
var
  NewClient: PClient;
  LListItem: TListitem;
begin
  GetMem(NewClient, SizeOf(TClient));

  NewClient.DNS         := AContext.Connection.Socket.Binding.PeerIP;// .LocalName;
  NewClient.Connected   := Now;
  NewClient.LastAction  := NewClient.Connected;
  NewClient.Thread      :=AContext;

  AContext.Connection.Tag := 1; //Connect시에 1, Execute시에 0으로 됨
  AContext.Data:=TObject(NewClient);
  //AContext.Connection.IOHandler.ReadTimeout := 500;
  try
    Clients.Add(NewClient);
    LListItem := lvConnections.Items.Add;
    LListItem.Caption := NewClient.DNS;
    LListItem.SubItems.Add('connected');
    LListItem.SubItems.Add(DateTimeToStr(now));
    LListItem.SubItems.Add(IntToStr(AContext.Connection.Socket.Binding.PeerPort));
    LblCurConnent.Caption := IntToStr(Clients.Count);
  finally
    //Clients.UnlockList;
  end;

  DisplayMessage(DateTimeToStr(now)+' Connection from "'+NewClient.DNS+'"', dtConnectLog);
end;

procedure TServerFrmMain.IdTCPServer1Disconnect(AContext: TIdContext);
var
  ActClient: PClient;
  Li: integer;
begin
  if FDestroying then
    exit;

  ActClient := PClient(AContext.Data);
  DisplayMessage (DateTimeToStr(now)+' Disconnect from "'+ActClient^.DNS+'"', dtConnectLog);
  if Assigned(lvConnections) then
  begin
    for Li := 0 to lvConnections.Items.Count - 1 do
    begin
      if (ActClient.DNS = lvConnections.Items[Li].Caption) and
        (IntToStr(AContext.Binding.PeerPort) = lvConnections.Items[Li].SubItems.Strings[2]) then
      begin
        lvConnections.Items.Delete(Li);
        break;
      end;
    end;
  end;

  try
    Clients.Remove(ActClient);
    if Assigned(LblCurConnent) then
      LblCurConnent.Caption := IntToStr(Clients.Count);
  finally
    //Clients.UnlockList;
  end;
  FreeMem(ActClient);
  AContext.Data := nil;
end;

////////////////////////////////////////////////////////////////////////////////
//Client와의 최초 connect를 담당하는 함수///////////////////////////////////////
//RecThread에 Client의 명단을 관리하는 (중복되지 않도록) 함수///////////////////
procedure TServerFrmMain.IdTCPServer1Execute(AContext: TIdContext);
var
  ActClient, RecClient: PClient;
  CommBlock, NewCommBlock: TCommBlock;
  LStream: TMemoryStream;
  RecThread: TIdContext;
  i: Integer;
  LStr: string;
begin
  if AContext.Connection.Connected then
  begin
    if AContext.Connection.Tag = 1 then
    begin
      AContext.Connection.Tag := 0;
      exit;
    end;

    try
      LStr := AContext.Connection.IOHandler.ReadLn;
      if UpperCase(LStr) = REQ_DATA then
      begin
        //AsyncSendTCP2(AContext);
        asyncHelper.MaxThreads := 2 * System.CPUCount;
        asyncHelper.AddTask(TAsyncCalls.Invoke<TIdContext>(AsyncSendTCP2,AContext));
        DisplayMessage (DateTimeToStr(now) + ': Send To "' + AContext.Connection.Socket.Binding.PeerIP +
        '('+ LStr + '=> ' +
        IntToStr(TFrameIPCMonitorAll4GasEngine1.FEventData_IPCAll.ECS_AVAT_Data.BlockNo) + ')',dtCommLog);
        while NOT asyncHelper.AllFinished do Application.ProcessMessages;
      end;
    finally
    end;
  end;
end;

procedure TServerFrmMain.InitVar;
begin
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  //FPJHTimerPool.Add(OnSendTCP,500);
  FCriticalSection := TCriticalSection.Create;
  FMonitorStart := False;
  FDestroying := False;
end;

procedure TServerFrmMain.IPCAll_Final;
begin
  TFrameIPCMonitorAll4GasEngine1.DestroyIPCMonitor(psECS_AVAT);
  TFrameIPCMonitorAll4GasEngine1.DestroyIPCMonitor(psMT210);
  TFrameIPCMonitorAll4GasEngine1.DestroyIPCMonitor(psMEXA7000);
  TFrameIPCMonitorAll4GasEngine1.DestroyIPCMonitor(psWT1600);
  TFrameIPCMonitorAll4GasEngine1.DestroyIPCMonitor(psGasCalculated);
end;

procedure TServerFrmMain.IPCAll_Init;
var
  LStr: string;
begin
  LStr := TFrameIPCMonitorAll4GasEngine1.CreateIPCMonitor_ECS_AVAT;
  DisplayMessage(LStr + ' Created.', dtSystemLog);

  LStr := TFrameIPCMonitorAll4GasEngine1.CreateIPCMonitor_MT210;
  DisplayMessage(LStr + ' Created.', dtSystemLog);

  LStr := TFrameIPCMonitorAll4GasEngine1.CreateIPCMonitor_MEXA7000;
  DisplayMessage(LStr + ' Created.', dtSystemLog);

  LStr := TFrameIPCMonitorAll4GasEngine1.CreateIPCMonitor_WT1600('192.168.0.48');
  DisplayMessage(LStr + ' Created.', dtSystemLog);

  LStr := TFrameIPCMonitorAll4GasEngine1.CreateIPCMonitor_GasCalc;
  DisplayMessage(LStr + ' Created.', dtSystemLog);
end;

procedure TServerFrmMain.JvXPButton1Click(Sender: TObject);
begin
  IdTCPServer1.Active := True;
  JvXPButton1.Enabled := False;
  JvXPButton2.Enabled := True;
  DisplayMessage(DateTimeToStr(now)+'TCP Server Start...', dtSystemLog);
end;

procedure TServerFrmMain.JvXPButton2Click(Sender: TObject);
begin
  IdTCPServer1.Active := False;
  JvXPButton1.Enabled := true;
  JvXPButton2.Enabled := false;
  DisplayMessage(DateTimeToStr(now)+'TCP Server Stoped!', dtSystemLog);
end;

procedure TServerFrmMain.JvXPButton6Click(Sender: TObject);
begin

end;

////////////////////////////////////////////////////////////////////////////////
//서버 통신 Object를 활성화시키는 체크버튼//////////////////////////////////////
procedure TServerFrmMain.AsyncSendTCP;
var
  RecClient: PClient;
  RecThread: TIdContext;
  Li: integer;
  LStream: TMemoryStream;
  LStr: string;
begin
  if FIsTCPSending then
    exit;

  FIsTCPSending := True;

  LStream := TMemoryStream.Create;
  WriteEventData2Stream(TFrameIPCMonitorAll4GasEngine1.FEventData_IPCAll, LStream);

  LStr := IntToStr(TFrameIPCMonitorAll4GasEngine1.FEventData_IPCAll.ECS_AVAT_Data.NumOfData);
  try
    with Clients do
    try
      for Li := 0 to Count-1 do  // iterate through client-list
      begin
        RecClient := Items[Li];  // get client-object
        RecThread := RecClient.Thread;     // get client-thread out of it
        RecThread.Connection.IOHandler.Write(LStream, LStream.Size);  // send the stuff
        TAsyncCalls.VCLInvoke(
        procedure
        begin
          DisplayMessage (DateTimeToStr(now) + ': Send To "' + RecClient^.DNS +
            '('+ LStr + '=> ' +
            IntToStr(TFrameIPCMonitorAll4GasEngine1.FEventData_IPCAll.ECS_AVAT_Data.BlockNo) + ')',dtCommLog);
        end);
      end;
    finally
      //Clients.UnlockList;
    end;
  finally
    FIsTCPSending := False;
    LStream.Free;
  end;
end;

function TServerFrmMain.AsyncSendTCP2(AContext: TIdContext): integer;
var
  RecClient: PClient;
  RecThread: TIdContext;
  Li: integer;
  LStream: TMemoryStream;
  LStr: string;
begin
  if FIsTCPSending then
    exit;

  FIsTCPSending := True;

  LStream := TMemoryStream.Create;
  WriteEventData2Stream(TFrameIPCMonitorAll4GasEngine1.FEventData_IPCAll, LStream);

  LStr := IntToStr(TFrameIPCMonitorAll4GasEngine1.FEventData_IPCAll.ECS_AVAT_Data.NumOfData);
  try
    AContext.Connection.IOHandler.Write(LStream, LStream.Size);  // send the stuff
    {TAsyncCalls.VCLInvoke(
    procedure
    begin
      DisplayMessage (DateTimeToStr(now) + ': Send To "' + RecClient^.DNS +
        '('+ LStr + '=> ' +
        IntToStr(TFrameIPCMonitorAll4GasEngine1.FEventData_IPCAll.ECS_AVAT_Data.BlockNo) + ')',dtCommLog);
    end);  }
  finally
    FIsTCPSending := False;
    LStream.Free;
  end;
end;

//모니터링 초기화(reset) 버튼 구동함수//////////////////////////////////////////
procedure TServerFrmMain.Button1Click(Sender: TObject);
begin
  Hide;
end;

//설정 창을 활성화 시켜주는 버튼 구동 함수//////////////////////////////////////
procedure TServerFrmMain.N2Click(Sender: TObject);
var
  TCPConfigF: TTCPConfigF;
begin
  TCPConfigF := TTCPConfigF.Create(Application);

  with TCPConfigF do
  begin
    try
      LoadConfigDataini2Form(TCPConfigF);

      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(TCPConfigF);
        LoadConfigDataini2Var;
        AdjustConfigData;
      end;
    finally
      Free;
    end;
  end;
end;

//설정을 변경시켜주는 함수//////////////////////////////////////////////////////
procedure TServerFrmMain.AdjustConfigData;
begin
  if IdTCPServer1.Active then
  begin
    ShowMessage('Server를 중지한 후 환경설정을...');
    exit;
  end
  else
  begin
    IdTCPServer1.Bindings.Clear;
    IdTCPServer1.Bindings.Add.ip := FIPAddress;
    IdTCPServer1.Bindings.Add.Port := FPortNum;
    IdTCPServer1.DefaultPort := FPortNum;

    if FSendInterval > 0 then
    begin
      FPJHTimerPool.RemoveAll;
      //FPJHTimerPool.Add(OnSendTCP, FSendInterval);
    end;

    LblPort.Caption := IntToStr(FPortNum);
    LblIP.Caption := FIPAddress;
    //JvXPButton1Click(nil);
  end;
end;

//프로그램 종료 버튼////////////////////////////////////////////////////////////
procedure TServerFrmMain.N4Click(Sender: TObject);
begin
  Close;
end;

//Client에게  통신에서 받은 데이터를 TCP/IP로 전달하는 함수///////////////
procedure TServerFrmMain.OnSendTCP(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  {asyncHelper.MaxThreads := 2 * System.CPUCount;
  asyncHelper.AddTask(TAsyncCalls.Invoke(AsyncSendTCP));
  while NOT asyncHelper.AllFinished do Application.ProcessMessages;
  }
end;

procedure TServerFrmMain.DisconnectAll;
var
  RecClient: PClient;
  RecThread: TIdContext;
  Li: integer;
begin
  for Li := Clients.Count - 1 downto 0 do
  begin
    RecClient := Clients.Items[Li];  // get client-object
    RecThread := RecClient.Thread;
    RecThread.Connection.Disconnect;

    FreeMem(RecClient);
    Clients.Remove(RecClient);
  end;

  try
    LblCurConnent.Caption := IntToStr(Clients.Count);
  finally
    //Clients.UnlockList;
  end;
end;

//메시지를 화면에 표시하는 함수 ////////////////////////////////////////////////
procedure TServerFrmMain.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
begin
  if msg = ' ' then
  begin
    exit;
  end;

  case ADspNo of
    dtSystemLog : begin
      with SMUDPSysLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with
    end;//dtSystemLog
    dtConnectLog: begin
      with SMUDPConnectLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with
    end;//dtConnectLog
    dtCommLog: begin
      //SMCommLog.IsScrolling := true;
      with SMCommLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with
    end;//dtCommLog

    dtStatusBar: begin
       jvStatusBar1.SimplePanel := True;
       jvStatusBar1.SimpleText := msg;
    end;//dtStatusBar
  end;//case
end;

end.


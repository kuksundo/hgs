unit MEXA7000_TCPServerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdTCPServer, IdThreadMgr, IdThreadMgrDefault, IdBaseComponent,
  IdComponent, IdStack, IPCThrd2, IPCThrdMonitor2, Menus, ExtCtrls, iniFiles,
  TCPConfig, TCPServerConst, ComCtrls, SyncObjs, CoolTrayIcon, IdContext,
  IdCustomTCPServer;

const
  INIFILENAME = '.\TCPServer';
  TCPSERVER_SECTION = 'TCP Server';

type
  TDisplayTarget = (dtSendMemo, dtRecvMemo, dtStatusBar);

  PClient   = ^TClient;
  TClient   = record  // Object holding data of client (see events)
    DNS         : String[20];            { Hostname }
    Connected,                           { Time of connect }
    LastAction  : TDateTime;             { Time of last transaction }
    Thread      : Pointer;               { Pointer to thread }
  end;

  TServerFrmMain = class(TForm)
    Protocol: TMemo;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    CBServerActive: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    rlsmd1: TMenuItem;
    StopMonitor1: TMenuItem;
    StartMonitor1: TMenuItem;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N5: TMenuItem;
    MenuItem4: TMenuItem;
    IdTCPServer1: TIdTCPServer;

    procedure CBServerActiveClick(Sender: TObject);
    procedure ServerConnect(AThread: TIdPeerThread);
    procedure ServerExecute(AThread: TIdPeerThread);
    procedure ServerDisconnect(AThread: TIdPeerThread);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);

    procedure WMMEXA7000Data(var Msg: TMessage); message WM_MEXA7000_DATA;
    procedure StopMonitor1Click(Sender: TObject);
    procedure StartMonitor1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
  private
    procedure OnSignal(Sender: TIPCThread2; Data: TEventData2);
    procedure LoadConfigDataini2Form(ConfigForm:TTCPConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TTCPConfigF);
    procedure AdjustConfigData;
  public
    FPortNum: integer;
    FFilePath: string;      //파일을 저장할 경로
    FSharedMMName: string;  //공유 메모리 이름
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FCriticalSection: TCriticalSection;

    FIPCMonitor: TIPCMonitor2;//공유 메모리 및 이벤트 객체
    FIPAddress: string;
    FMEXA7000Data: TEventData2; //공유메모리로부터 받은 데이터 저장
    FEventData: TEventData2; //공유메모리로부터 받은 데이터 저장(smh)

    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
    procedure InitVar;
  end;

var
  ServerFrmMain   : TServerFrmMain;
  Clients         : TThreadList;     // Holds the data of all clients

implementation

uses MEXA7000_TCPUtil, TCPServer_Util;

{$R *.DFM}

procedure TServerFrmMain.FormCreate(Sender: TObject);
begin
  Clients := TThreadList.Create;
  InitVar;
end;

procedure TServerFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMonitorStart := False;

  FreeAndNil(FIPCMonitor);

  Server.Active := False;
  Clients.Free;
  FCriticalSection.Free;
end;

////////////////////////////////////////////////////////////////////////////////
//프로그램 초기호 Timer1Timer 구문//////////////////////////////////////////////
procedure TServerFrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  LoadConfigDataini2Var;
  AdjustConfigData;
  //IPC Monitor 함수 초기화 구문////////////////////////////////////////////////
  FIPCMonitor := TIPCMonitor2.Create(0, FSharedMMName, True);
  FIPCMonitor.OnSignal := OnSignal;
  FIPCMonitor.Resume;
  //////////////////////////////////////////////////////////////////////////////
  DisplayMessage('Shared Memory: ' + FSharedMMName + ' Created!', dtSendMemo);
  FMonitorStart := True;

  Label2.Caption := GetLocalIP;
  Caption := DeviceName + ' ==> ' + Label2.Caption;// + FIPAddress[Li];
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
  iniFile := TInifile.create(INIFILENAME+DeviceName+'.ini');
  try
    with iniFile, ConfigForm do
    begin
      PortEdit.Text := ReadString(TCPSERVER_SECTION, 'Port', '47110');
      SharedMMNameEdit.Text := ReadString(TCPSERVER_SECTION, 'Shared Memory Name', IPCCLIENTNAME1);
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
  iniFile := TInifile.create(INIFILENAME+DeviceName+'.ini');
  try
    with iniFile do
    begin
      FPortNum := StrToInt(ReadString(TCPSERVER_SECTION, 'Port', '47110'));
      FSharedMMName := ReadString(TCPSERVER_SECTION, 'Shared Memory Name', IPCCLIENTNAME1);
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

procedure TServerFrmMain.MenuItem4Click(Sender: TObject);
begin
  Close;
end;

//ini파일로 Host의 Port, IP 주소를 저장하는 함수 ///////////////////////////////
procedure TServerFrmMain.SaveConfigDataForm2ini(ConfigForm: TTCPConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+DeviceName+'.ini');
  try
    with iniFile, ConfigForm do
    begin
      WriteString(TCPSERVER_SECTION, 'Port', PortEdit.Text);
      WriteString(TCPSERVER_SECTION, 'Shared Memory Name', SharedMMNameEdit.Text);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

//시스템 초기 값 설정///////////////////////////////////////////////////////////
procedure TServerFrmMain.InitVar;
begin
  FCriticalSection := TCriticalSection.Create;

  FMonitorStart := False;

  FIPAddress := '192.168.0.70';
end;




////////////////////////////////////////////////////////////////////////////////
//Client와의 최초 connect를 담당하는 함수///////////////////////////////////////
procedure TServerFrmMain.ServerConnect(AThread: TIdPeerThread);
var
  NewClient: PClient;

begin
  GetMem(NewClient, SizeOf(TClient));

  NewClient.DNS         := AThread.Connection.Socket.Binding.PeerIP;// .LocalName;
  NewClient.Connected   := Now;
  NewClient.LastAction  := NewClient.Connected;
  NewClient.Thread      :=AThread;

  AThread.Data:=TObject(NewClient);

  try
    Clients.LockList.Add(NewClient);
  finally
    Clients.UnlockList;
  end;

  DisplayMessage(DateTimeToStr(now)+' Connection from "'+NewClient.DNS+'"', dtSendMemo);
end;
//RecThread에 Client의 명단을 관리하는 (중복되지 않도록) 함수///////////////////
procedure TServerFrmMain.ServerExecute(AThread: TIdPeerThread);
var
  ActClient, RecClient: PClient;
  CommBlock, NewCommBlock: TCommBlock;
  RecThread: TIdPeerThread;
  i: Integer;

begin
  if not AThread.Terminated and AThread.Connection.Connected then
  begin
    AThread.Connection.ReadBuffer (CommBlock, SizeOf (CommBlock));
    ActClient := PClient(AThread.Data);
    ActClient.LastAction := Now;  // update the time of last action

    DisplayMessage(DateTimeToStr(now)+'ServerExecute: ' + CommBlock.MyUserName, dtSendMemo);

    NewCommBlock := CommBlock; // again: nothing to change ;-))
    DisplayMessage(DateTimeToStr(now)+' Sending '+CommBlock.Command+' to "'+CommBlock.ReceiverName+'": "'+CommBlock.Msg+'"', dtSendMemo);
    with Clients.LockList do
    try
      for i := 0 to Count-1 do
      begin
        RecClient:=Items[i];
        if RecClient.DNS=CommBlock.ReceiverName then  // we don't have a login function so we have to use the DNS (Hostname)
        begin
          RecThread:=RecClient.Thread;
          //RecThread.Connection.WriteBuffer(NewCommBlock, SizeOf(NewCommBlock), True);
        end;
      end;
    finally
      Clients.UnlockList;
    end;
  end;
end;
//Client 모니터 기능 시작버튼///////////////////////////////////////////////////
procedure TServerFrmMain.StartMonitor1Click(Sender: TObject);
begin
  FIPCMonitor.FMonitorEvent.Pulse;
  FIPCMonitor.Resume;
  DisplayMessage('FIPCMonitor: ' + FIPAddress + ' Resume!', dtSendMemo);
end;
//Client 모니터 기능 중지버튼///////////////////////////////////////////////////
procedure TServerFrmMain.StopMonitor1Click(Sender: TObject);
begin
  FIPCMonitor.FMonitorEvent.Pulse;
  FIPCMonitor.Suspend;
  DisplayMessage('FIPCMonitor: ' + FIPAddress + ' Suspended!', dtSendMemo);
end;
//Client의 Disconnect를 담당////////////////////////////////////////////////////
procedure TServerFrmMain.ServerDisconnect(AThread: TIdPeerThread);
var
  ActClient: PClient;

begin
  ActClient := PClient(AThread.Data);
  DisplayMessage (DateTimeToStr(now)+' Disconnect from "'+ActClient^.DNS+'"', dtSendMemo);
  try
    Clients.LockList.Remove(ActClient);
  finally
    Clients.UnlockList;
  end;
  FreeMem(ActClient);
  AThread.Data := nil;
end;

////////////////////////////////////////////////////////////////////////////////
//MEXA-7000p에서 데이터 onsignal이 오는지를 인식하고 Client가 있는지 파악하여///
//WMMEXA7000Data 함수를 구동시키는 함수/////////////////////////////////////////
procedure TServerFrmMain.OnSignal(Sender: TIPCThread2; Data: TEventData2);
begin
  if not FMonitorStart then
    exit;
  //DisplayMessage (TimeToStr(Time) +' read' + ': CO2 :'+ Data.CO2 + ' : non CH4 :' + Data.non_CH4 , dtSendMemo);
  System.Move(Data, FEventData, SizeOf(TEventData2));
  SendMessage(Handle, WM_MEXA7000_DATA, 0,0);
end;

//Client에게  MEXA-7000p에서 받은 데이터를 TCP/IP로 전달하는 함수///////////////
procedure TServerFrmMain.WMMEXA7000Data(var Msg: TMessage);
var
  i: Integer;
  RecClient: PClient;
  RecThread: TIdPeerThread;
begin
  with Clients.LockList do
  try
    for i := 0 to Count-1 do  // iterate through client-list
    begin
      RecClient := Items[i];           // get client-object
      RecThread := RecClient.Thread;     // get client-thread out of it
      DisplayMessage (DateTimeToStr(now) + ': Send To "' + RecClient^.DNS,dtSendMemo);
      RecThread.Connection.WriteBuffer(FEventData,SizeOf(FEventData), True);  // send the stuff
      Application.ProcessMessages;
    end;
  finally
    Clients.UnlockList;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//서버 통신 Object를 활성화시키는 체크버튼//////////////////////////////////////
procedure TServerFrmMain.CBServerActiveClick(Sender: TObject);
begin
  Server.Active := CBServerActive.Checked;
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
  if Server.Active then
  begin
    ShowMessage('Server를 중지한 후 환경설정을...');
    exit;
  end
  else
  begin
    Server.DefaultPort := FPortNum;
    Server.Active := true ;
    CBServerActive.Checked := True;
    Label4.Caption := IntToStr(FPortNum);
  end;
end;
//프로그램 종료 버튼////////////////////////////////////////////////////////////
procedure TServerFrmMain.N4Click(Sender: TObject);
begin
  Close;
end;
//메시지를 화면에 표시하는 함수 ////////////////////////////////////////////////
procedure TServerFrmMain.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
begin
  case ADspNo of
    dtSendMemo : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

      with Protocol do
      begin
        if Lines.Count > 100 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtSendMemo

    dtStatusBar: begin
       StatusBar1.SimplePanel := True;
       StatusBar1.SimpleText := msg;
    end;//dtStatusBar
  end;//case
end;

end.


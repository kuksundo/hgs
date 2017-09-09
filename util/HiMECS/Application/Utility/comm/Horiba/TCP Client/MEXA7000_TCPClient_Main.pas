unit MEXA7000_TCPClient_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls,
  IPCThrd2, IPCThrdClient2, TCPConfig, ExtCtrls, inifiles, Menus,
  MEXA7000_TCPUtil, DataSave2FileThread, DataSaveConst, ComCtrls, CoolTrayIcon;

const
  INIFILENAME = '.\TCPClient';
  TCPCLIENT_SECTION = 'TCP Client';

type

  TClientFrmMain = class(TForm)
    CBClientActive: TCheckBox;
    IncomingMessages: TMemo;
    Label1: TLabel;
    Client: TIdTCPClient;
    Timer1: TTimer;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    StatusBar1: TStatusBar;
    TrayIcon1: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N5: TMenuItem;
    MenuItem4: TMenuItem;
    Button1: TButton;

    procedure CBClientActiveClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);

  private
    FSaveFileName: string; //데이타를 저장할 File 이름(설정에 따라 변경됨)
    FTagNameBuf: string;  //파일에 제목을 저장하기 위한 버퍼
    FDataSaveStart: Boolean; //설정된 시간이 경과 되었으면 True(Save시작함)
    FSaveDataBuf: string; //파일에 저장할 데이타를 저장하는 버퍼
    FLogStart: Boolean;  //Log save Start sig.
    FDataSave2FileThread: TDataSave2FileThread;//파일에 데이타 저장하는 객체
    FFileName_Convention: TFileName_Convetion;//파일에 저장시에 파일이름부여 방법

    procedure LoadConfigDataini2Form(ConfigForm:TTCPConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TTCPConfigF);
    procedure AdjustConfigData;

  public
    FIPCClient: TIPCClient2;//공유 메모리 및 이벤트 객체
    FPortNum: integer;
    FHostIP: string;
    FFilePath: string;      //파일을 저장할 경로
    FSharedMMName: string;  //공유 메모리 이름
    FFirstTime: boolean;
    FRecvString: string;
    procedure CreateSave2FileThread;
    procedure DestroySave2FileThread;
    procedure SaveData(BlockNo: integer);
    procedure SaveData2File;
    procedure DisplayMessage(msg: string);
  end;

  TClientHandleThread = class(TThread)
  private
    CB: TCommBlock;
    FData: TEventData2;
    FDataSave2FileThread: TDataSave2FileThread;//파일에 데이타 저장하는 객체
    procedure HandleInput;
  protected
    procedure Execute; override;
  end;

var
  ClientFrmMain: TClientFrmMain;
  ClientHandleThread: TClientHandleThread;   // variable (type see above)

implementation

{$R *.DFM}

procedure TClientFrmMain.FormCreate(Sender: TObject);
begin
  FFirstTime := True;
end;

procedure TClientFrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(ClientHandleThread) then
    ClientHandleThread.Terminate;
  Client.Disconnect;

  FreeAndNil(FIPCClient);
  DestroySave2FileThread;
end;

////////////////////////////////////////////////////////////////////////////////
//프로그램 초기화 함수//////////////////////////////////////////////////////////
procedure TClientFrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    if FFirstTime then
    begin
      FFirstTime := False;
      FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
      LoadConfigDataini2Var;
      AdjustConfigData;
      //IPC 함수 초기화 구문////////////////////////////////////////////////////
      FIPCClient := TIPCClient2.Create(0, FSharedMMName, True);
      //////////////////////////////////////////////////////////////////////////
      Label7.Caption := GetLocalIP;
      Caption := FHostIP + ' ==> ' + FSharedMMName;
      //DisplayMessage('Receive Data : ' + IntToStr(SizeOf(ClientHandleThread.FData)));
    end
    else
    begin
    end;
  finally
   Timer1.Enabled := True;
  end;
end;

procedure TClientFrmMain.TrayIcon1DblClick(Sender: TObject);
begin
  application.Restore;
  ShowWindow(Application.Handle, SW_HIDE);
  Show;

end;

//ini 파일에서 초기화정보를 읽어 프로그램에서 사용하는 변수로 저장하는 함수/////
procedure TClientFrmMain.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+DeviceName+'.ini');
  try
    with iniFile do
    begin
      //CreateSave2FileThread;  //CSV 파일로 저장하는 Thread create 명령
      //CSV 파일로 저장할 때 파일명을 지정하는 방식 결정
      FFileName_Convention := TFileName_Convetion(ReadInteger(TCPCLIENT_SECTION, 'File Name Type', 0));
      //파일명결정(의미 없는 것 같음->확인필요)
      FSaveFileName := ReadString(TCPCLIENT_SECTION, 'File Name', 'abc');
      FPortNum := StrToInt(ReadString(TCPCLIENT_SECTION, 'Port', '47110'));
      FHostIP := ReadString(TCPCLIENT_SECTION, 'Host IP', '10.14.23.40');
      FSharedMMName := ReadString(TCPCLIENT_SECTION, 'Shared Memory Name', DeviceName);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;
procedure TClientFrmMain.MenuItem1Click(Sender: TObject);
begin
  application.Restore;
  ShowWindow(Application.Handle, SW_HIDE);
  Show;

end;

procedure TClientFrmMain.MenuItem4Click(Sender: TObject);
begin
  Close;
end;

//ini파일로 Host의 Port, IP 주소를 저장하는 함수 ///////////////////////////////
procedure TClientFrmMain.SaveConfigDataForm2ini(ConfigForm: TTCPConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+DeviceName+'.ini');
  try
    with iniFile, ConfigForm do
    begin
      WriteString(TCPCLIENT_SECTION, 'Port', PortEdit.Text);
      WriteString(TCPCLIENT_SECTION, 'Host IP', HostIPEdit.Text);
      WriteString(TCPCLIENT_SECTION, 'Shared Memory Name', SharedMMNameEdit.Text);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;
//Client 쓰레드에 Host의 IP 주소와 Port를 설정해 주는 함수//////////////////////
procedure TClientFrmMain.AdjustConfigData;
begin
  if Client.Connected then
  begin
    ShowMessage('Server를 중지한 후 환경설정을...');
    exit;
  end
  else
  begin
    Client.Port := FPortNum;
    Client.Host := FHostIP;
    Label8.Caption := FHostIP;
    Label10.Caption := IntToStr(FPortNum);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//Acive 버튼 클릭 시 구동 함수//////////////////////////////////////////////////
procedure TClientFrmMain.CBClientActiveClick(Sender: TObject);
begin
  if CBClientActive.Checked then
  begin
    try
{      FLogStart := True;
      FSaveDataBuf :=#13#10+'START DATA LOGGING'+#13#10+'Time,CO2,CO_L,O2,NOx,THC,CH4,non_CH4';
      SaveData2File;
}
      //Client에 통신연결하는 함수 (Thread 동작)
      Client.Connect();  // in Indy < 8.1 leave the parameter away
      ClientHandleThread := TClientHandleThread.Create(True);
      ClientHandleThread.FreeOnTerminate:=True;
      ClientHandleThread.Resume;

    except
      on E: Exception do MessageDlg ('Error while connecting:'+#13+E.Message,
                                      mtError, [mbOk], 0);
    end;
  end
  else
  begin
    ClientHandleThread.Terminate;
    Client.Disconnect;
  end;

//  ButtonSend.Enabled := Client.Connected;
  CBClientActive.Checked := Client.Connected;
end;
//쓰레드 execute(ReadBuffer 명령있음)///////////////////////////////////////////
procedure TClientHandleThread.Execute;
var tmpStr: String;
begin
  while not Terminated do
  begin
    if not ClientFrmMain.Client.Connected then
      Terminate
    else
    try
      tmpStr := '';

      ClientFrmMain.Client.ReadBuffer(FData, SizeOf(FData));
      Synchronize(HandleInput);
    except
    end;
  end;
end;

//통신으로 받은 정보를 처리하는 쓰레드 /////////////////////////////////////////
procedure TClientHandleThread.HandleInput;
begin
  ClientFrmMain.DisplayMessage(TimeToStr(Time) + ': Receive Data');
{  ClientFrmMain.DisplayMessage(': CO2 ' + FData.CO2 +': CO_L');
  ClientFrmMain.FLogStart := True;
  ClientFrmMain.FSaveDataBuf :=TimeToStr(Time)+','+FData.CO2+','+FData.CO_L+','+FData.O2+','+FData.NOx+','+FData.THC+','+FData.CH4+','+FData.non_CH4;
  ClientFrmMain.SaveData2File;}
  //공유메모리에 데이터(FData)를 저장하는 구문//////////////////////////////////
  ClientFrmMain.FIPCClient.PulseMonitor(FData);
  //////////////////////////////////////////////////////////////////////////////
{
  if CB.Command = 'MESSAGE' then
    ClientFrmMain.DisplayMessage (CB.MyUserName + ': ' + CB.Msg)
  else
  if CB.Command = 'DIALOG' then
    MessageDlg ('"'+CB.MyUserName+'" sends you this message:'+#13+CB.Msg, mtInformation, [mbOk], 0)
  else ; // unknown command
}
end;




////////////////////////////////////////////////////////////////////////////////
//CSV 파일 저장 명령 함수 //////////////////////////////////////////////////////
procedure TClientFrmMain.SaveData2File;
begin
  with FDataSave2FileThread do
  begin
    FStrData := FSaveDataBuf; //저장할 데이터(FSaveDataBuf)를 변수(FStrData)에 입력
    FTagData := FTagNameBuf;  //최초에 저장파일 생성 시 헤더(머릿말) 입력
    FName_Convention := FFileName_Convention; //파일명을 지정해주는 방법설정
    FFileName := FSaveFileName; //안쓰는 기능임
    if not FSaving then
      FDataSaveEvent.Signal;
  end;//with
end;
//CSV 파일 저장 쓰레드 생성 함수////////////////////////////////////////////////
procedure TClientFrmMain.CreateSave2FileThread;
begin
  if not Assigned(FDataSave2FileThread) then
  begin
    FDataSave2FileThread := TDataSave2FileThread.Create(Self);
    FDataSave2FileThread.Resume;
  end;
end;
//CSV 파일 저장 쓰레드 삭제 함수////////////////////////////////////////////////
procedure TClientFrmMain.DestroySave2FileThread;
begin
  if Assigned(FDataSave2FileThread) then
  begin
    FDataSave2FileThread.Terminate;
    FDataSave2FileThread.FDataSaveEvent.Signal;
    FDataSave2FileThread.Free;
    FDataSave2FileThread := nil;
  end;//if
end;

//데이터 저장용 '타이머' 기능 함수///////////////////////////////////////////////
procedure TClientFrmMain.SaveData(BlockNo: integer);
begin
{  if (FLogStart = True) then
  begin
    WMSaveData(BlockNo);
    if (FLogStartTime + StrToTime(ed_LogHour.Text + ':' + ed_LogMin.Text + ':' + ed_LogSec.Text))< Time then
      Button3Click(Self);
  end;}
end;





////////////////////////////////////////////////////////////////////////////////
//설정창을 열어주는 버튼 클릭시 구동하는 함수///////////////////////////////////
procedure TClientFrmMain.N2Click(Sender: TObject);
var
  TCPConfigF: TTCPConfigF;
begin
  TCPConfigF := TTCPConfigF.Create(Application);

  with TCPConfigF do
  begin
    try
      Label1.Visible := True;
      HostIPEdit.Visible := True;

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

//ini 파일에 있는 Host IP, Port를 Form에 표시하는 함수 /////////////////////////
procedure TClientFrmMain.LoadConfigDataini2Form(ConfigForm: TTCPConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+DeviceName+'.ini');
  try
    with iniFile, ConfigForm do
    begin
      PortEdit.Text := ReadString(TCPCLIENT_SECTION, 'Port', '47110');
      HostIPEdit.Text := ReadString(TCPCLIENT_SECTION, 'Host IP', '10.14.16.80');
      SharedMMNameEdit.Text := ReadString(TCPCLIENT_SECTION, 'Shared Memory Name', 'ModBusCom_'+DeviceName);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

//메시지를 화면에 표시하는 함수 ////////////////////////////////////////////////
procedure TClientFrmMain.DisplayMessage(msg: string);
begin
  with IncomingMessages do
  begin
    if Lines.Count > 100 then
      Clear;

    Lines.Add(msg);
  end;//with
end;

//프로그램 종료 버튼////////////////////////////////////////////////////////////
procedure TClientFrmMain.N4Click(Sender: TObject);
begin
  Close;
end;

//현재 프로그램(MEXA_7000_TCPClient_Main)에서는 쓰지 않는 함수//////////////////
procedure TClientFrmMain.Button1Click(Sender: TObject);
begin
  Hide;
end;

procedure TClientFrmMain.ButtonSendClick(Sender: TObject);
var
  CommBlock : TCommBlock;

begin
{  if Client.Connected then
  begin
    CommBlock.Command      := EditCommand.Text;         // assign the data
    CommBlock.MyUserName   := Client.Socket.Binding.IP;//Client.Socket.;// .LocalName;
    CommBlock.Msg          := EditMessage.Text;
    CommBlock.ReceiverName := EditRecipient.Text;

    Client.WriteBuffer (CommBlock, SizeOf (CommBlock), true);

    if Assigned(FIPCClient) then
      FreeAndNil(FIPCClient);

    FSharedMMName := DeviceName;
    Caption := DeviceName + ' ==> ' + FSharedMMName;
    FIPCClient := TIPCClient2.Create(0, FSharedMMName, True);
  end
  else
    ShowMessage('Server에 연결 안됨!!'); }
end;


end.

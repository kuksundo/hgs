unit ECS_TCPClient_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls,
  IPCThrd_ECS_avat, IPCThrdClient_ECS_avat, TCPConfig, ExtCtrls, inifiles, Menus,
  DataSave2FileThread, DataSaveConst, ComCtrls, ECS_avat_TCPUtil, JvDialogs;

const
  INIFILENAME = '.\TCPClient_Avat';
  TCPCLIENT_SECTION = 'TCP Client Avat';

type

  TClientFrmMain = class(TForm)
    IncomingMessages: TMemo;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N5: TMenuItem;
    MenuItem4: TMenuItem;
    IdTCPClient1: TIdTCPClient;
    SimulateCommunication1: TMenuItem;
    N6: TMenuItem;
    JvOpenDialog1: TJvOpenDialog;
    SimulateCommunicationwithstep1: TMenuItem;
    Panel1: TPanel;
    CBClientActive: TCheckBox;
    Label5: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Button1: TButton;
    Button3: TButton;
    Button2: TButton;
    Splitter1: TSplitter;
    Label1: TLabel;
    Label2: TLabel;

    procedure CBClientActiveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure SimulateCommunication1Click(Sender: TObject);
    procedure SimulateCommunicationwithstep1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    FSaveFileName: string; //데이타를 저장할 File 이름(설정에 따라 변경됨)
    FTagNameBuf: string;  //파일에 제목을 저장하기 위한 버퍼
    FDataSaveStart: Boolean; //설정된 시간이 경과 되었으면 True(Save시작함)
    FSaveDataBuf: string; //파일에 저장할 데이타를 저장하는 버퍼
    FLogStart: Boolean;  //Log save Start sig.
    FDataSave2FileThread: TDataSave2FileThread;//파일에 데이타 저장하는 객체
    FFileName_Convention: TFileName_Convetion;//파일에 저장시에 파일이름부여 방법
    FECSData: TEventData_ECS_avat;//RTU simulate에 사용되는 Buffer
    FECSDataList: TStringList;//RTU simulate에 사용되는 List
    FBufferIndex: integer;

    procedure LoadDataFromFile(AFileName: string);
    function PrepareSimulate(AFileName: string): Boolean;
    procedure ProcessSimulateOneStep;

    procedure LoadConfigDataini2Form(ConfigForm:TTCPConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TTCPConfigF);
    procedure AdjustConfigData;

  public
    FIPCClient: TIPCClient_ECS_avat;//공유 메모리 및 이벤트 객체
    FPortNum: integer;
    FLocalIP: string;
    FHostIP: string;
    FFilePath: string;      //파일을 저장할 경로
    FSharedMMName: string;  //공유 메모리 이름
    FSimStep: integer;
    FFirstTime: boolean;
    FRecvString: string;
    procedure DisplayMessage(msg: string);
  end;

  TClientHandleThread = class(TThread)
  private
    CB: TCommBlock;
    FData: TEventData_ECS_avat;
    FStream: TMemoryStream;
    FDataSave2FileThread: TDataSave2FileThread;//파일에 데이타 저장하는 객체
    procedure HandleInput;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TForm);
    destructor Destroy();override;
  end;

var
  ClientFrmMain: TClientFrmMain;
  ClientHandleThread: TClientHandleThread;   // variable (type see above)

implementation

uses CommonUtil;

{$R *.DFM}

procedure TClientFrmMain.FormCreate(Sender: TObject);
begin
  FFirstTime := True;
  FECSDataList := TStringList.Create;
end;

procedure TClientFrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FECSDataList);

  if Assigned(ClientHandleThread) then
    ClientHandleThread.Terminate;
  IdTCPClient1.Disconnect;
  FreeAndNil(FIPCClient);
//  DestroySave2FileThread;
end;

////////////////////////////////////////////////////////////////////////////////
//프로그램 초기화 함수
procedure TClientFrmMain.Timer1Timer(Sender: TObject);
begin
  try
    if FFirstTime then
    begin
      FFirstTime := False;
      FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
      LoadConfigDataini2Var;
      AdjustConfigData;
      //IPC 함수 초기화 구문////////////////////////////////////////////////////
      FIPCClient := TIPCClient_ECS_avat.Create(0, FSharedMMName, True);
      //////////////////////////////////////////////////////////////////////////
      Label7.Caption := FLocalIP;
      Caption := DeviceName + ' ==> ' + FSharedMMName;
    end;

    if SimulateCommunicationwithstep1.Checked then
    begin
      ProcessSimulateOneStep;
    end
    else
      Timer1.Enabled := False;
  finally
   //Timer1.Enabled := True;
  end;
end;

procedure TClientFrmMain.TrayIcon1DblClick(Sender: TObject);
begin
  application.Restore;
  ShowWindow(Application.Handle, SW_HIDE);
  Show;
end;

////////////////////////////////////////////////////////////////////////////////
//ini 파일에서 초기화정보를 읽어 프로그램에서 사용하는 변수로 저장하는 함수
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
      //FFileName_Convention := TFileName_Convetion(ReadInteger(TCPCLIENT_SECTION, 'File Name Type', 0));
      //FSaveFileName := ReadString(TCPCLIENT_SECTION, 'File Name', 'abc');
      FLocalIP := ReadString(TCPCLIENT_SECTION, 'Local IP', '10.14.16.80');
      FPortNum := StrToInt(ReadString(TCPCLIENT_SECTION, 'Port', '47110'));
      FHostIP := ReadString(TCPCLIENT_SECTION, 'Host IP', '10.14.23.40');
      FSharedMMName := ReadString(TCPCLIENT_SECTION, 'Shared Memory Name', '192.168.0.40');
      FSimStep := ReadInteger(TCPCLIENT_SECTION, 'Simulate Step', 1000);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TClientFrmMain.LoadDataFromFile(AFileName: string);
var
  LStr: TStringList;
  LStr2,LStr3,LStr4: string;
  i,j,k,LColumnCount: integer;
  tmpdouble2, tmpdouble: double;
begin
  LStr:= TStringList.Create;
  try
    LStr.LoadFromFile(AFileName,TEncoding.UTF8);

    if LStr.Count = 0 then //실패했을 경우 다시 읽어 들임
    begin
      LStr.LoadFromFile(AFileName);
    end;

    if LStr.Count > 0 then
    begin
      LStr2 := LStr.Strings[0]; //Head Read
      GetTokenWithComma(LStr2); //시간은 먼저 읽어서 없앰

      LColumnCount := strTokenCount(LStr.Strings[0], ',');

      for i := 1 to LStr.Count - 1 do
      begin
        LStr2 := LStr.Strings[i];
        LStr3 := GetTokenWithComma(LStr2);
        tmpdouble2 := StrToDateTime(LStr3);
        FillChar(FECSData.InpDataBuf_double[0], High(FECSData.InpDataBuf_double) - 1, #0);
        FECSData.ModBusFunctionCode := 4;
        FECSData.ModBusMode := 3;
        FECSData.NumOfData := LColumnCount - 2;

        for j := 0 to LColumnCount - 2 do
        begin
          LStr3 := GetTokenWithComma(LStr2);
          if LStr3 = 'FALSE' then
            tmpdouble := 0.0
          else if LStr3 = 'TRUE' then
            tmpdouble := $FFFF
          else
            tmpdouble := StrToFloatDef(LStr3,0.0);

          FECSData.InpDataBuf_double[j] := tmpdouble;
        end;//for

        FIPCClient.PulseMonitor(FECSData);
      end;//for
    end;
  finally
    FreeAndNil(LStr);
  end;
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

//ini파일로 Host의 Port, IP 주소를 저장하는 함수
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
      WriteString(TCPCLIENT_SECTION, 'Local IP', HostIPCB.Text);
      WriteString(TCPCLIENT_SECTION, 'Port', PortEdit.Text);
      WriteString(TCPCLIENT_SECTION, 'Host IP', HostIPEdit.Text);
      WriteString(TCPCLIENT_SECTION, 'Shared Memory Name', SharedMMNameEdit.Text);
      WriteString(TCPCLIENT_SECTION, 'Simulate Step', SimStepEdit.Text);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TClientFrmMain.SimulateCommunication1Click(Sender: TObject);
var
  LFileName: string;
  i: integer;
  LIsFirst: Boolean;
begin
  SimulateCommunication1.Checked := not SimulateCommunication1.Checked;

  if SimulateCommunication1.Checked then
  begin
    CBClientActive.Checked := False;
    CBClientActiveClick(nil); //TCP Disconnect

    JvOpenDialog1.Options := JvOpenDialog1.Options + [ofAllowMultiSelect];
    JvOpenDialog1.InitialDir := FFilePath;
    if JvOpenDialog1.Execute then
    begin
      for i := 0 to JvOpenDialog1.Files.Count - 1 do
      begin
        LIsFirst := i = 0;
        LFileName := JvOpenDialog1.Files[i];

        LoadDataFromFile(LFileName);
      end;
    end
    else
      SimulateCommunication1.Checked := not SimulateCommunication1.Checked;

  end;
end;

//모드버스의 경우 Simulation file의 내용은 반드시 주소의 순으로 나열 되어 있어야 함.
procedure TClientFrmMain.SimulateCommunicationwithstep1Click(Sender: TObject);
var
  LFileName: string;
  i: integer;
  LIsFirst: Boolean;
begin
  SimulateCommunicationwithstep1.Checked := not SimulateCommunicationwithstep1.Checked;
  Button2.Enabled := SimulateCommunicationwithstep1.Checked;

  if SimulateCommunicationwithstep1.Checked then
  begin
    CBClientActive.Checked := False;
    CBClientActiveClick(nil); //TCP Disconnect
    FBufferIndex := 0;

    JvOpenDialog1.Options := JvOpenDialog1.Options + [ofAllowMultiSelect];
    JvOpenDialog1.InitialDir := FFilePath;
    JvOpenDialog1.Filter := '*.csv||*.*';
    if JvOpenDialog1.Execute then
    begin
      for i := 0 to JvOpenDialog1.Files.Count - 1 do
      begin
        LIsFirst := i = 0;
        LFileName := JvOpenDialog1.Files[i];

        if PrepareSimulate(LFileName) then
        begin
          Timer1.Interval := FSimStep;
          Timer1.Enabled := True;
        end
        else
        begin
          ShowMessage('Simulation Fail!');
          SimulateCommunicationwithstep1.Checked := not SimulateCommunicationwithstep1.Checked;
        end;
      end;
    end
    else
      SimulateCommunicationwithstep1.Checked := not SimulateCommunicationwithstep1.Checked;
  end;
end;

//Client 쓰레드에 Host의 IP 주소와 Port를 설정해 주는 함수
procedure TClientFrmMain.AdjustConfigData;
begin
  if IdTCPClient1.Connected then
  begin
    ShowMessage('Server를 중지한 후 환경설정을...');
    exit;
  end
  else
  begin
    IdTCPClient1.BoundIP := FLocalIP;
    IdTCPClient1.Port := FPortNum;
    IdTCPClient1.Host := FHostIP;
    Label7.Caption := FLocalIP;
    Label8.Caption := FHostIP;
    Label10.Caption := IntToStr(FPortNum);
    Timer1.Interval := FSimStep;

    if Assigned(FIPCClient) then
    begin
      FreeAndNil(FIPCClient);
      FIPCClient := TIPCClient_ECS_avat.Create(0, FSharedMMName, True);
    end;

  end;
end;

////////////////////////////////////////////////////////////////////////////////
//Acive 버튼 클릭 시 구동 함수
procedure TClientFrmMain.Button1Click(Sender: TObject);
begin
  Hide;
end;

procedure TClientFrmMain.Button2Click(Sender: TObject);
begin
  Timer1.Enabled := not Timer1.Enabled;
  Button3.Enabled := not Timer1.Enabled;

  if Timer1.Enabled then
  begin
    Button2.Caption := 'Pause';
  end
  else
  begin
    Button2.Caption := 'Start';
  end;
end;

procedure TClientFrmMain.Button3Click(Sender: TObject);
begin
  ProcessSimulateOneStep;
end;

procedure TClientFrmMain.CBClientActiveClick(Sender: TObject);
begin
  if CBClientActive.Checked then
  begin
    try
      //Client에 통신연결하는 함수 (Thread 동작)
      IdTCPClient1.Connect();  // in Indy < 8.1 leave the parameter away
      ClientHandleThread := TClientHandleThread.Create(Self);
      ClientHandleThread.FreeOnTerminate:=True;
      ClientHandleThread.Resume;

    except
      on E: Exception do MessageDlg ('Error while connecting:'+#13+E.Message,
                                      mtError, [mbOk], 0);
    end;
  end
  else
  begin
    if Assigned(ClientHandleThread) then
      ClientHandleThread.Terminate;
    IdTCPClient1.Disconnect;
  end;

//  ButtonSend.Enabled := Client.Connected;
  CBClientActive.Checked := IdTCPClient1.Connected;
end;

//쓰레드 execute 함수 (ReadBuffer 명령있음)
constructor TClientHandleThread.Create(AOwner: TForm);
begin
  inherited Create(true);

  FStream := TMemoryStream.Create;
end;

destructor TClientHandleThread.Destroy;
begin
  FreeAndNil(FStream);
  inherited Destroy();
end;

procedure TClientHandleThread.Execute;
var
  tmpStr: String;
begin
  while not Terminated do
  begin
    if not ClientFrmMain.IdTCPClient1.Connected then
      Terminate
    else
    begin
      try
        tmpStr := '';
        FStream.Position := 0;
        ClientFrmMain.IdTCPClient1.IOHandler.ReadStream(FStream, SizeOf(FData));

        if FStream.Size > 0 then
        begin
          FData := ReadEventDataFromStream(FStream);
          ClientFrmMain.FIPCClient.PulseMonitor(FData);
          Synchronize(HandleInput);
        end;
      finally
      end;
    end;
  end;
end;

//통신으로 받은 정보를 처리하는 쓰레드(HandleInput) 함수
procedure TClientHandleThread.HandleInput;
begin
  ClientFrmMain.DisplayMessage(TimeToStr(Time) + ': Receive Data');
  ClientFrmMain.DisplayMessage(#13#10+IntToStr(FData.NumOfData));
  ClientFrmMain.FIPCClient.PulseMonitor(FData); //공유메모리에 데이터(FData)를 저장하는 구문
end;

////////////////////////////////////////////////////////////////////////////////
//설정창을 열어주는 버튼 클릭시 구동하는 함수
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
      PortEdit.Text := ReadString(TCPCLIENT_SECTION, 'Port', '47113');
      HostIPEdit.Text := ReadString(TCPCLIENT_SECTION, 'Host IP', '10.14.16.80');
      HostIpCB.Text := ReadString(TCPCLIENT_SECTION, 'Local IP', '10.14.16.80');
      SharedMMNameEdit.Text := ReadString(TCPCLIENT_SECTION, 'Shared Memory Name', 'ModBusCom_'+DeviceName);
      SimStepEdit.Text := ReadString(TCPCLIENT_SECTION, 'Simulate Step', '1000');
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

function TClientFrmMain.PrepareSimulate(AFileName: string): Boolean;
var
  LColumnCount,i: integer;
  LStr2: string;
begin
  Result := False;

  FECSDataList.Clear;

  try
    FECSDataList.LoadFromFile(AFileName,TEncoding.UTF8);

    if FECSDataList.Count = 0 then //실패했을 경우 다시 읽어 들임
    begin
      FECSDataList.LoadFromFile(AFileName);
    end;

    if FECSDataList.Count > 0 then
    begin
      i := 0;
      while FECSDataList.Strings[i] = '' do
        inc(i);

      LStr2 := FECSDataList.Strings[i]; //Head Read
      GetTokenWithComma(LStr2); //시간은 먼저 읽어서 없앰

      LColumnCount := strTokenCount(FECSDataList.Strings[i], ',');
      FECSData.ModBusFunctionCode := 4;
      FECSData.ModBusMode := 3;
      FECSData.NumOfData := LColumnCount - 2;
      Label2.Caption := IntToStr(FECSDataList.Count);
      Result := True;
    end;
  finally

  end;
end;

procedure TClientFrmMain.ProcessSimulateOneStep;
var
  i: integer;
  LStr2,LStr3: string;
  tmpdouble,tmpdouble2: double;
begin
  inc(FBufferIndex); //1 부터 시작해야 함.(헤더를 건너뛰기 위함)
  if FBufferIndex >= FECSDataList.Count then
  begin
    SimulateCommunicationwithstep1.Checked := False;
    DisplayMessage(DateTimeToStr(now) + '>>> Finished: '+IntToStr(FBufferIndex));

    exit;
  end;

  LStr2 := FECSDataList.Strings[FBufferIndex];
  LStr3 := GetTokenWithComma(LStr2);
  tmpdouble2 := StrToDateTime(LStr3);
  FillChar(FECSData.InpDataBuf_double[0], High(FECSData.InpDataBuf_double) - 1, #0);

  for i := 0 to FECSData.NumOfData do
  begin
    LStr3 := GetTokenWithComma(LStr2);
    if LStr3 = 'FALSE' then
      tmpdouble := 0.0
    else if LStr3 = 'TRUE' then
      tmpdouble := $FFFF
    else
      tmpdouble := StrToFloatDef(LStr3,0.0);

    FECSData.InpDataBuf_double[i] := tmpdouble;
  end;

  FIPCClient.PulseMonitor(FECSData);
  LStr2 := DateTimeToStr(now) + '>>> Pulse Data Count: ';
  LStr2 := LStr2 + IntToStr(FECSData.NumOfData) + ',,, Buffer Index: ';
  LStr2 := LStr2 + IntToStr(FBufferIndex);
  DisplayMessage(LStr2);
end;

end.

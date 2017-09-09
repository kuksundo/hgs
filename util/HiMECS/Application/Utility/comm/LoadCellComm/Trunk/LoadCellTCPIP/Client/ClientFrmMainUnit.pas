{-----------------------------------------------------------------------------
 Demo Name: ClientFrmMainUnit
 Author:    Helge Jung (helge@eco-logic-software.de)
 Copyright: Indy Pit Crew
 Purpose:
 History:   Improvements supplied by: Enver ALTIN
 Date:      27/10/2002 00:24:26
 Checked with Indy version: 9.0 - Allen O'Neill - Springboard Technologies Ltd  - http://www.springboardtechnologies.com
-----------------------------------------------------------------------------
 Notes:

 Demonstration on how to use TIdTCPServer and TIdTCPClient
 with using Threads and WriteBuffer/ReadBuffer
}

unit ClientFrmMainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls,
  GlobalUnit, IPCThrd2, IPCThrdClient2, TCPConfig, ExtCtrls, inifiles,
  Menus;

const
  INIFILENAME = '.\TCPClient';
  TCPCLIENT_SECTION = 'TCP Client';

type
  TClientFrmMain = class(TForm)
    CBClientActive: TCheckBox;
    IncomingMessages: TMemo;
    Label1: TLabel;
    Client: TIdTCPClient;
    Label2: TLabel;
    EditCommand: TComboBox;
    Label3: TLabel;
    EditMessage: TEdit;
    Label4: TLabel;
    EditRecipient: TEdit;
    ButtonSend: TButton;
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

    procedure CBClientActiveClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);

  private
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

    procedure DisplayMessage(msg: string);

  end;

  TClientHandleThread = class(TThread)
  private
    CB: TCommBlock;
    FData: TEventData2;
    procedure HandleInput;
  protected
    procedure Execute; override;
  end;

var
  ClientFrmMain: TClientFrmMain;
  ClientHandleThread: TClientHandleThread;   // variable (type see above)

implementation

{$R *.DFM}

procedure TClientHandleThread.HandleInput;
begin
  ClientFrmMain.DisplayMessage('Receive Data : ' + IntToStr(FData.NumOfData));
  ClientFrmMain.FIPCClient.PulseMonitor(FData);
  FData.NumOfData := 0;

  if CB.Command = 'MESSAGE' then
    ClientFrmMain.DisplayMessage (CB.MyUserName + ': ' + CB.Msg)
  else
  if CB.Command = 'DIALOG' then
    MessageDlg ('"'+CB.MyUserName+'" sends you this message:'+#13+CB.Msg, mtInformation, [mbOk], 0)
  else  // unknown command
    ;//MessageDlg('Unknown command "'+CB.Command+'" containing this message:'+#13+CB.Msg, mtError, [mbOk], 0);
end;

procedure TClientHandleThread.Execute;
var tmpStr: String;
begin
  while not Terminated do
  begin
    if not ClientFrmMain.Client.Connected then
      Terminate
    else
    try
      //ClientFrmMain.Client.ReadBuffer(CB, SizeOf (CB));
      tmpStr := '';

      //while Pos('@pjh@', tmpStr) = 0 do
      //  tmpStr := ClientFrmMain.Client.ReadString(5);

      ClientFrmMain.Client.ReadBuffer(FData, SizeOf(FData));
      if FData.NumOfData > 0 then
        Synchronize(HandleInput);
    except
    end;
  end;
end;

procedure TClientFrmMain.CBClientActiveClick(Sender: TObject);
begin
  if CBClientActive.Checked then
  begin
    try
      Client.Connect();  // in Indy < 8.1 leave the parameter away

      ClientHandleThread := TClientHandleThread.Create(True);
      ClientHandleThread.FreeOnTerminate:=True;
      ClientHandleThread.Resume;
    except
      on E: Exception do MessageDlg ('Error while connecting:'+#13+E.Message, mtError, [mbOk], 0);
    end;
  end
  else
  begin
    ClientHandleThread.Terminate;
    Client.Disconnect;
  end;

  ButtonSend.Enabled := Client.Connected;
  CBClientActive.Checked := Client.Connected;
end;

procedure TClientFrmMain.ButtonSendClick(Sender: TObject);
var
  CommBlock : TCommBlock;

begin
  CommBlock.Command      := EditCommand.Text;         // assign the data
  CommBlock.MyUserName   := Client.LocalName;
  CommBlock.Msg          := EditMessage.Text;
  CommBlock.ReceiverName := EditRecipient.Text;

  Client.WriteBuffer (CommBlock, SizeOf (CommBlock), true);
end;

procedure TClientFrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FIPCClient);
end;

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
      SharedMMNameEdit.Text := ReadString(TCPCLIENT_SECTION, 'Shared Memory Name', 'ModBusCom'+DeviceName);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

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
      FPortNum := StrToInt(ReadString(TCPCLIENT_SECTION, 'Port', '47110'));
      FHostIP := ReadString(TCPCLIENT_SECTION, 'Host IP', '10.14.16.80');
      FSharedMMName := ReadString(TCPCLIENT_SECTION, 'Shared Memory Name', 'ModBusCom'+DeviceName);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

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

procedure TClientFrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  LoadConfigDataini2Var;
  AdjustConfigData;
  FIPCClient := TIPCClient2.Create(0, FSharedMMName, True);
  Label7.Caption := GetLocalIP;
  Caption := DeviceName + ' ==> ' + FSharedMMName;
end;

procedure TClientFrmMain.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TClientFrmMain.N2Click(Sender: TObject);
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

procedure TClientFrmMain.DisplayMessage(msg: string);
begin
  with IncomingMessages do
  begin
    if Lines.Count > 100 then
      Clear;

    Lines.Add(msg);
  end;//with
end;

end.

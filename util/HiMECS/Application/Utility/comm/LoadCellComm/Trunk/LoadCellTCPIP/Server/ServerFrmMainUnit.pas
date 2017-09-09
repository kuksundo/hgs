{-----------------------------------------------------------------------------
 Demo Name: ServerFrmMainUnit
 Author:    Helge Jung (helge@eco-logic-software.de)
 Copyright: Indy Pit Crew
 Purpose:
 History: Improvements supplied by: Enver ALTIN
 Date:      27/10/2002 00:23:25
 Checked with Indy version: 9.0 - Allen O'Neill - Springboard Technologies Ltd  - http://www.springboardtechnologies.com
-----------------------------------------------------------------------------
 Notes:

 Demonstration on how to use TIdTCPServer and TIdTCPClient
 with using Threads and WriteBuffer/ReadBuffer

}

unit ServerFrmMainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdTCPServer, IdThreadMgr, IdThreadMgrDefault, IdBaseComponent,
  IdComponent, IdStack, IPCThrd2, IPCThrdMonitor2, Menus, ExtCtrls, iniFiles,
  TCPConfig;

const
  INIFILENAME = '.\TCPServer';
  TCPSERVER_SECTION = 'TCP Server';

type
  PClient   = ^TClient;
  TClient   = record  // Object holding data of client (see events)
    DNS         : String[20];            { Hostname }
    Connected,                           { Time of connect }
    LastAction  : TDateTime;             { Time of last transaction }
    Thread      : Pointer;               { Pointer to thread }
  end;

  TServerFrmMain = class(TForm)
    Server: TIdTCPServer;
    CBServerActive: TCheckBox;
    Protocol: TMemo;
    IdThreadMgrDefault1: TIdThreadMgrDefault;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;

    procedure CBServerActiveClick(Sender: TObject);
    procedure ServerConnect(AThread: TIdPeerThread);
    procedure ServerExecute(AThread: TIdPeerThread);
    procedure ServerDisconnect(AThread: TIdPeerThread);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);

  private
    procedure OnSignal(Sender: TIPCThread2; Data: TEventData2);
    procedure LoadConfigDataini2Form(ConfigForm:TTCPConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TTCPConfigF);
    procedure AdjustConfigData;
  public
    FIPCMonitor: TIPCMonitor2;//공유 메모리 및 이벤트 객체
    FPortNum: integer;
    FFilePath: string;      //파일을 저장할 경로
    FSharedMMName: string;  //공유 메모리 이름

    procedure DisplayMessage(msg: string);
  end;

var
  ServerFrmMain   : TServerFrmMain;
  Clients         : TThreadList;     // Holds the data of all clients
  GStack: TIdStack = nil;

implementation

uses GlobalUnit;

{$R *.DFM}

procedure TServerFrmMain.CBServerActiveClick(Sender: TObject);
begin
  Server.Active := CBServerActive.Checked;
end;

procedure TServerFrmMain.ServerConnect(AThread: TIdPeerThread);
var
  NewClient: PClient;

begin
  GetMem(NewClient, SizeOf(TClient));

  NewClient.DNS         := AThread.Connection.LocalName;
  NewClient.Connected   := Now;
  NewClient.LastAction  := NewClient.Connected;
  NewClient.Thread      :=AThread;

  AThread.Data:=TObject(NewClient);

  try
    Clients.LockList.Add(NewClient);
  finally
    Clients.UnlockList;
  end;

  DisplayMessage(TimeToStr(Time)+' Connection from "'+NewClient.DNS+'"');
end;

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

    if (CommBlock.Command = 'MESSAGE') or (CommBlock.Command = 'DIALOG') then
    begin  // 'MESSAGE': A message was send - forward or broadcast it
           // 'DIALOG':  A dialog-window shall popup on the recipient's screen
           // it's the same code for both commands...

      if CommBlock.ReceiverName = '' then
      begin  // no recipient given - broadcast
        DisplayMessage (TimeToStr(Time)+' Broadcasting '+CommBlock.Command+': "'+CommBlock.Msg+'"');
        NewCommBlock := CommBlock;  // nothing to change ;-))

        with Clients.LockList do
        try
          for i := 0 to Count-1 do  // iterate through client-list
	        begin
            RecClient := Items[i];           // get client-object
            RecThread := RecClient.Thread;     // get client-thread out of it
            RecThread.Connection.WriteBuffer(NewCommBlock, SizeOf(NewCommBlock), True);  // send the stuff
          end;
        finally
          Clients.UnlockList;
        end;
      end
      else
      begin  // receiver given - search him and send it to him
        NewCommBlock := CommBlock; // again: nothing to change ;-))
        DisplayMessage(TimeToStr(Time)+' Sending '+CommBlock.Command+' to "'+CommBlock.ReceiverName+'": "'+CommBlock.Msg+'"');
        with Clients.LockList do
        try
          for i := 0 to Count-1 do
          begin
            RecClient:=Items[i];
            if RecClient.DNS=CommBlock.ReceiverName then  // we don't have a login function so we have to use the DNS (Hostname)
            begin
              RecThread:=RecClient.Thread;
              RecThread.Connection.WriteBuffer(NewCommBlock, SizeOf(NewCommBlock), True);
            end;
          end;
        finally
          Clients.UnlockList;
        end;
      end;
    end
    else
    begin  // unknown command given
      DisplayMessage (TimeToStr(Time)+' Unknown command from "'+CommBlock.MyUserName+'": '+CommBlock.Command);
      NewCommBlock.Command := 'DIALOG';       // the message should popup on the client's screen
      NewCommBlock.MyUserName := '[Server]';  // the server's username
      NewCommBlock.Msg := 'I don''t understand your command: "'+CommBlock.Command+'"';  // the message to show
      NewCommBlock.ReceiverName := '[return-to-sender]'; // unnecessary

      AThread.Connection.WriteBuffer (NewCommBlock, SizeOf (NewCommBlock), true);  // and there it goes...
    end;
  end;
end;

procedure TServerFrmMain.ServerDisconnect(AThread: TIdPeerThread);
var
  ActClient: PClient;

begin
  ActClient := PClient(AThread.Data);
  DisplayMessage (TimeToStr(Time)+' Disconnect from "'+ActClient^.DNS+'"');
  try
    Clients.LockList.Remove(ActClient);
  finally
    Clients.UnlockList;
  end;
  FreeMem(ActClient);
  AThread.Data := nil;
end;

procedure TServerFrmMain.FormCreate(Sender: TObject);
begin
  Clients := TThreadList.Create;
end;

procedure TServerFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Server.Active := False;
  FIPCMonitor.Free;
  Clients.Free;
end;

procedure TServerFrmMain.OnSignal(Sender: TIPCThread2; Data: TEventData2);
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
      //RecThread.Connection.Write('@pjh@');
      DisplayMessage (TimeToStr(Time) + ': Send To "' + RecClient^.DNS + '" of Num Data = ' + IntToStr(Data.NumOfData));
      RecThread.Connection.WriteBuffer(Data, SizeOf(Data), True);  // send the stuff
    end;
  finally
    Clients.UnlockList;
  end;

end;

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
      SharedMMNameEdit.Text := ReadString(TCPSERVER_SECTION, 'Shared Memory Name', 'ModBusCom_'+DeviceName);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

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
      FSharedMMName := ReadString(TCPSERVER_SECTION, 'Shared Memory Name', 'ModBusCom_'+DeviceName);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

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

procedure TServerFrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  LoadConfigDataini2Var;
  AdjustConfigData;
  FIPCMonitor := TIPCMonitor2.Create(0, FSharedMMName, True);
  FIPCMonitor.OnSignal := OnSignal;
  FIPCMonitor.Resume;
  Label2.Caption := GetLocalIP;
  Caption := DeviceName + ' ==> ' + FSharedMMName;
end;

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

procedure TServerFrmMain.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TServerFrmMain.DisplayMessage(msg: string);
begin
    with Protocol do
    begin
      if Lines.Count > 100 then
        Clear;

      Lines.Add(msg);
    end;//with
end;

end.


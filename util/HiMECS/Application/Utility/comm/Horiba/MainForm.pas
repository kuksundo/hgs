unit MainForm;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ToolWin, ComCtrls,
  Menus, Buttons, Spin, SysUtils, Classes, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, ExtCtrls, StdCtrls,
  IdAntiFreezeBase, IdAntiFreeze, IdUDPBase, IdUDPClient, Options,
  JvComponentBase, JvgXMLSerializer, SBPro, JvExComCtrls, JvListView,
  HoribaComponentClasses, ConfigConst,
  MyKernelObject, CopyData, IPCThrd_MEXA7000, IPCThrdClient_MEXA7000, iComponent, iVCLComponent,
  iCustomComponent, iAnalogDisplay, CLabels, MEXA7000_Watch_r1;

type
  TTCPReceiveThread = class(TThread)
  private
    procedure HandleInput;
  protected
    Msg : String;

    procedure Execute; override;
  end;

  TUDPReceiveThread = class(TThread)
  private
    procedure HandleInput;
  protected
    UDPMsg : String;
    
    procedure Execute; override;
  end;

  TTCPSendThread = class(TThread)
  private
    procedure HandleInput;
    procedure SendQuery;
  protected
    FSendCommandListRepeat,
    FSendCommandListOnce: TStringList;//Modbus 통신 명령 리스트
    FQueryInterval: integer;
    FStopSend: Boolean;

    procedure Execute; override;
  public
    FSendCommandOnce: Boolean;
    FSendCommandRepeat: Boolean;

    constructor Create(AQueryInterval: integer);
    destructor Destroy; override;

  published
    property StopSend: Boolean read FStopSend write FStopSend;
    property QueryInterval: integer read FQueryInterval write FQueryInterval;
  end;

  TForm1 = class(TForm)
    IdTCPClient1: TIdTCPClient;
    Timer1: TTimer;
    UDPClient: TIdUDPClient;
    UDPAntiFreeze: TIdAntiFreeze;
    Timer2: TTimer;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Setting1: TMenuItem;
    Options1: TMenuItem;
    Connect1: TMenuItem;
    DisConnect1: TMenuItem;
    N2: TMenuItem;
    JvgXMLSerializer: TJvgXMLSerializer;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    SBPro: TStatusBarPro;
    memLines: TMemo;
    Label4: TLabel;
    JvListView1: TJvListView;
    BitBtn2: TBitBtn;
    SpeedButton1: TSpeedButton;
    Command1: TMenuItem;
    MakeCommandList1: TMenuItem;
    GetComponentCode1: TMenuItem;
    N3: TMenuItem;
    BitBtn3: TBitBtn;
    Panel7: TPanel;
    co2lbl: TiAnalogDisplay;
    Panel3: TPanel;
    OHSymbLabel1: TOHSymbLabel;
    collbl: TiAnalogDisplay;
    Panel4: TPanel;
    OHSymbLabel2: TOHSymbLabel;
    o2lbl: TiAnalogDisplay;
    Panel5: TPanel;
    OHSymbLabel3: TOHSymbLabel;
    noxlbl: TiAnalogDisplay;
    Panel6: TPanel;
    OHSymbLabel4: TOHSymbLabel;
    thclbl: TiAnalogDisplay;
    Panel8: TPanel;
    OHSymbLabel5: TOHSymbLabel;
    ch4lbl: TiAnalogDisplay;
    Panel9: TPanel;
    OHSymbLabel6: TOHSymbLabel;
    nonch4lbl: TiAnalogDisplay;
    Panel10: TPanel;
    OHSymbLabel7: TOHSymbLabel;
    Panel11: TPanel;
    OHSymbLabel8: TOHSymbLabel;
    OHSymbLabel9: TOHSymbLabel;
    Shape1: TShape;
    OHSymbLabel10: TOHSymbLabel;
    OHSymbLabel11: TOHSymbLabel;
    o2lbl_2: TiAnalogDisplay;
    Noxlbl_2: TiAnalogDisplay;
    Collectedlbl: TiAnalogDisplay;
    OHSymbLabel12: TOHSymbLabel;
    BitBtn1: TBitBtn;
    BitBtn4: TBitBtn;
    MakeUDPCommandList1: TMenuItem;
    BitBtn5: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Options1Click(Sender: TObject);
    procedure Connect1Click(Sender: TObject);
    procedure DisConnect1Click(Sender: TObject);
    procedure GetComponentCode1Click(Sender: TObject);
    procedure WMTCPReceive( var Message: TMessage ); message WM_TCP_RECEIVE;
    procedure WMUDPReceice(var Msg: TMessage); message WM_UDP_RECEIVE;
    procedure WMIPCBroadcast( var Message: TMessage ); message WM_IPC_BROADCAST;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WMWatchFormClose(var Msg: TMessage); message WM_WATCHFORM_CLOSE;
    procedure MakeCommandList1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure co2lblDblClick(Sender: TObject);
    procedure collblDblClick(Sender: TObject);
    procedure o2lblDblClick(Sender: TObject);
    procedure noxlblDblClick(Sender: TObject);
    procedure thclblDblClick(Sender: TObject);
    procedure ch4lblDblClick(Sender: TObject);
    procedure nonch4lblDblClick(Sender: TObject);
    procedure CollectedlblDblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
  private
    procedure TCPConnect;
    procedure SetConfig;
    procedure UDPReceive;
  public
    FOptions: TOptionComponent;
    FComponentCodeList: THoribaComponent;
    FIPCClient: TIPCClient_MEXA7000;//공유 메모리 및 이벤트 객체
    FCCRecvCompleteEvent: TEvent;
    FTCPReceiveThread: TTCPReceiveThread;
    FUDPReceiveThread: TUDPReceiveThread;
    FTCPSendThread: TTCPSendThread;

    FDataSendEvent, FDataRecvEvent: TEvent;

    FCommandListOnce,
    FCommandListRepeat: TStringList;
    FWatchFormList: TList;
    FResponseMsg: string;
    FXMLFileName: string;

    FWatchValueAvg: double; //Average data
    FWatchValueAry: array of double;
    FCurrentAryIndex: integer; //처음에 배열에 저장시에 평균값 구하기 위함
    FAvgSize: integer; //평균을 위한 배열 size
    FFirstCalcAry: boolean; //처음 배열을 채워갈때는 True, 한번 다 채우면 False

    procedure LoadConfigFile2Var(AFileName: string);
    procedure DisplaySBMessage(AMsg: string);
    procedure DisplayMemoMessage(msg: string);
    procedure GetComponentCode;
    procedure DisplayComponentCode;
    procedure MakeTCPCommandList;
    procedure MakeUDPCommandList;
    procedure TCPCommandSendAll;
    procedure UDPCommandSend;

    procedure ApplyAvgSize;

    procedure CreateWatchForm(ALabel: string; ATag: integer);
  end;

var
  Form1: TForm1;

implementation

uses ConfigForm, ConfigUtil;

{$R *.DFM}

procedure TForm1.ApplyAvgSize;
begin

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  FTCPSendThread.FStopSend := False;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  //if FOptions.UseUDP then
  //  UDPCommandSend
  //else
    TCPCommandSendAll;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  FTCPSendThread.FStopSend := True;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  TCPConnect;
  if FCCRecvCompleteEvent.Wait(INFINITE) then
  begin
    //IdTCPClient1.Disconnect;
    MakeUDPCommandList;
    UDPCommandSend;
  end;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  //UDPClient.Send('
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //UDPClient.Send(edUDPMsg.Text+#13#10);
  //edUDPMsg.Text := '';
end;

procedure TForm1.ch4lblDblClick(Sender: TObject);
begin
  CreateWatchForm('CH4', ch4lbl.Tag);
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.co2lblDblClick(Sender: TObject);
begin
  CreateWatchForm('CO2', co2lbl.Tag);
end;

procedure TForm1.collblDblClick(Sender: TObject);
begin
  CreateWatchForm('CO_L', collbl.Tag);
end;

procedure TForm1.CollectedlblDblClick(Sender: TObject);
begin
  CreateWatchForm('Collected Value', Collectedlbl.Tag);
end;

procedure TForm1.Connect1Click(Sender: TObject);
begin
  TCPConnect;
end;

procedure TForm1.CreateWatchForm(ALabel: string; ATag: integer);
var
  LWatchF: TWatchF2;
begin
  LWatchF := TWatchF2.Create(self);
  LWatchF.FOwnerHandle := Self.Handle;
  LWatchF.FOwnerListIndex := FWatchFormList.Add(LWatchF);

  LWatchF.FLabelName := ALabel;
  LWatchF.FWatchTag := ATag;
  LWatchF.FWatchName := IPCCLIENTNAME1;
  LWatchF.Show;
end;

procedure TForm1.DisConnect1Click(Sender: TObject);
begin
  IdTCPClient1.Disconnect;
end;

procedure TForm1.DisplayComponentCode;
var
  ListItem: TListItem;
  Li: integer;
begin
  JvListView1.Items.Clear;
  
  with JvListView1.Items do
  begin
    for Li := 0 to FOptions.Option.Count - 1 do
    begin
      ListItem := Add;
      ListItem.Caption := FOptions.Option.Items[Li].GroupNo;
      ListItem.SubItems.Add(FOptions.Option.Items[Li].SerialNo);
      ListItem.SubItems.Add(FOptions.Option.Items[Li].ComponentCode);
      ListItem.SubItems.Add(FComponentCodeList.GetComponentNameByCode(
              StrToIntDef(FOptions.Option.Items[Li].ComponentCode,0)));
    end;
  end;

  FCCRecvCompleteEvent.Signal;
end;

procedure TForm1.DisplayMemoMessage(msg: string);
begin
  with memLines do
  begin
    if Lines.Count > 100 then
      Clear;

    Lines.Add(msg);
  end;//with
end;

procedure TForm1.DisplaySBMessage(AMsg: string);
begin
  SBPro.Panels[SB_MESSAGE_IDX].Text := AMsg;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Li: integer;
begin
  for Li := FWatchFormList.Count - 1 Downto 0 do
    TWatchF2(FWatchFormList.Items[Li]).Close;

  FWatchFormList.Free;
  
  FCCRecvCompleteEvent.Signal;
  FCCRecvCompleteEvent.Free;
    
  if FTCPSendThread.Suspended then
  begin
    FTCPSendThread.FStopSend := False;
    FTCPSendThread.Resume;
    Sleep(100);
  end;

  FTCPSendThread.Terminate;
  FTCPReceiveThread.Terminate;
  FUDPReceiveThread.Terminate;

  FCommandListOnce.Free;
  FCommandListRepeat.Free;
  FComponentCodeList.Free;
  FOptions.Free;
  FIPCClient.Free;
  FDataSendEvent.Free;
  FDataRecvEvent.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FOptions := TOptionComponent.Create(Self);
  FXMLFileName := ChangeFileExt(Application.ExeName, '.xml');
  LoadConfigFile2Var(FXMLFileName);

  FIPCClient := TIPCClient_MEXA7000.Create(0, IPCCLIENTNAME1, True);

  FCCRecvCompleteEvent := TEvent.Create('CCRecvComplete'+IntToStr(GetCurrentThreadID),False);

  FTCPReceiveThread := TTCPReceiveThread.Create(True);
  FTCPReceiveThread.FreeOnTerminate:=True;

  FUDPReceiveThread := TUDPReceiveThread.Create(True);
  FUDPReceiveThread.FreeOnTerminate:=True;
  FUDPReceiveThread.Resume;

  FTCPSendThread := TTCPSendThread.Create(FOptions.SendInterval);
  FTCPSendThread.FreeOnTerminate:=True;

  FComponentCodeList := THoribaComponent.Create(Self);
  FComponentCodeList.AddDefautProperties;

  FCommandListRepeat := TStringList.Create;
  FCommandListOnce := TStringList.Create;

  FWatchFormList := TList.Create;

  FDataSendEvent := TEvent.Create('MEXA7000DataSendEvent',False);
  FDataRecvEvent := TEvent.Create('MEXA7000DataRecvEvent',False);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  width := width + 1;
end;

procedure TForm1.GetComponentCode;
var
  LStr,
  Msg: string;
  Li, Lj: integer;
begin
  if not IdTcpClient1.Connected then
  begin
    ShowMessage('Disconnected...Please Connect first!');
    exit;
  end;

  IdTCPClient1.IOHandler.WriteLnRFC(C_MRDF);
  FDataSendEvent.Pulse;
  DisplayMemoMessage('Send: ' + C_MRDF);
end;

procedure TForm1.GetComponentCode1Click(Sender: TObject);
begin
  GetComponentCode;
end;

procedure TForm1.TCPCommandSendAll;
begin
  MakeTCPCommandList;
  FTCPSendThread.FSendCommandListOnce.Assign(FCommandListOnce);
  FTCPSendThread.FSendCommandListRepeat.Assign(FCommandListRepeat);
  FTCPSendThread.FStopSend := False;
  FTCPSendThread.FSendCommandOnce := True;
  FTCPSendThread.FSendCommandRepeat := True;
  FTCPSendThread.Resume;
end;

procedure TForm1.TCPConnect;
begin
  if (FOptions.IPAddress <> '') then
  begin
    DisplaySBMessage('TCP Connectting ...');
    IdTCPClient1.Host := FOptions.IPAddress;
    IdTCPClient1.Port := FOptions.TCPPort;
    try
      IdTCPClient1.Connect;
      DisplaySBMessage('TCP Connected!');
      FTCPReceiveThread.Resume;
    except 
      DisplaySBMessage('TCP Connection failed!');
    end;
  end
  else
  begin
    ShowMessage('You must put in a server ip address to connect.');
  end;

  GetComponentCode;
end;

procedure TForm1.thclblDblClick(Sender: TObject);
begin
  CreateWatchForm('THC', thclbl.Tag);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Com,
  Msg : String;
begin
  if not IdTcpClient1.Connected then
    exit;

  Msg := IdTCPClient1.IOHandler.ReadLn;// ReadLn('', 5);

  if Msg <> '' then
    if Msg[1] <> '@' then
      begin
        { Not a system command }
        memLines.Lines.Add(Msg);
      end
    else  ;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  LStr: string;
begin
  Timer2.Enabled := False;

  SBPro.Panels[1].Text := FOptions.IPAddress;
  SBPro.Panels[3].Text := IntToStr(FOptions.TCPPort);

  if ParamCount > 0 then
  begin
    LStr := UpperCase(ParamStr(1));
    if LStr = '/A' then  //Automatic Communication Start
    begin
      Connect1Click(nil);

      if JvListView1.Items.Count > 0 then
        BitBtn2Click(nil);
    end;
  end;
end;

procedure TForm1.UDPCommandSend;
var
  Li: integer;
begin
  for Li := 0 to FCommandListOnce.Count - 1 do
    IdTCPClient1.IOHandler.WriteLnRFC(FCommandListOnce.Strings[Li]);
    //UDPClient.Send(FCommandListOnce.Strings[Li]);
end;

procedure TForm1.UDPReceive;
var
  Com,
  Msg : String;
begin
  Msg := UDPClient.ReceiveString;

  //if Msg <> '' then
  //  UDPMemo.Lines.Add(Msg);
end;

procedure TForm1.WMCopyData(var Msg: TMessage);
begin
  DisplayMemoMessage(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg);
  //,Boolean(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle));
end;

procedure TForm1.WMIPCBroadcast(var Message: TMessage);
var
  EventData: TEventData_MEXA7000;
  Li: integer;
begin
  with EventData do
  try
    Li := FOptions.GetListIndexByComponentCode(3);
    if Li > -1  then
    begin
      CO2 := FOptions.Option.Items[Li].Value;
      co2lbl.Value := StrToFloatDef(CO2, 0.0);
    end;

    Li := FOptions.GetListIndexByComponentCode(1);
    if Li > -1  then
    begin
      CO_L := FOptions.Option.Items[Li].Value;
      collbl.Value := StrToFloatDef(CO_L, 0.0);
    end;

    Li := FOptions.GetListIndexByComponentCode(10);
    if Li > -1  then
    begin
      O2 := FOptions.Option.Items[Li].Value;
      o2lbl.Value := StrToFloatDef(O2, 0.0);
      o2lbl_2.Value := o2lbl.Value/10000;
    end;

    Li := FOptions.GetListIndexByComponentCode(8);
    if Li > -1  then
    begin
      NOx := FOptions.Option.Items[Li].Value;
      NOxlbl.Value := StrToFloatDef(NOx, 0.0);
      Noxlbl_2.Value := NOxlbl.Value;
    end;

    Li := FOptions.GetListIndexByComponentCode(6);
    if Li > -1  then
    begin
      THC := FOptions.Option.Items[Li].Value;
      THClbl.Value := StrToFloatDef(THC, 0.0);
    end;

    Li := FOptions.GetListIndexByComponentCode(11);
    if Li > -1  then
    begin
      CH4 := FOptions.Option.Items[Li].Value;
      CH4lbl.Value := StrToFloatDef(CH4, 0.0);
    end;

    Li := FOptions.GetListIndexByComponentCode(14);
    if Li > -1  then
    begin
      non_CH4 := FOptions.Option.Items[Li].Value;
      nonCH4lbl.Value := StrToFloatDef(non_CH4, 0.0);
    end;
    CollectedValue := ((21-13)/(21-o2lbl_2.Value)) * NOxlbl.Value;
    Collectedlbl.Value := CollectedValue;
  except on exception do ;

  end;


  FIPCClient.PulseMonitor(EventData);
end;

procedure TForm1.WMTCPReceive(var Message: TMessage);
var
  LStr, LStr2: string;
  Li, Lj: integer;
begin
  DisplayMemoMessage(FResponseMsg);

  LStr := GetToken(FResponseMsg, ',');

  if LStr <> '' then
    DisplayMemoMessage('Receive: ' + LStr + FResponseMsg);

  if LStr = 'MRDF' then
  begin
    FOptions.MRDF_Proc(FResponseMsg);

    if FOptions.Option.Count > 0 then
      DisplayComponentCode;
  end
  else if LStr = 'MRMD' then
  begin
    LStr2 := FOptions.MRMD_Proc(FResponseMsg);
    SendMessage(Self.Handle, WM_IPC_BROADCAST, 0, 0);
    DisplayMemoMessage('Status: ' + LStr2);
  end;

end;

procedure TForm1.WMUDPReceice(var Msg: TMessage);
begin
  SendMessage(Handle, WM_UDP_RECEIVE, 0, 0);
end;

procedure TForm1.WMWatchFormClose(var Msg: TMessage);
begin
  FWatchFormList.Delete(Msg.WParam);
end;

procedure TForm1.SetConfig;
//var
  //LConfigEditF: TConfigFormF;
begin
  with TConfigFormF.Create(self) do
  begin
    FOptions := Self.FOptions;
    FConfigFileName := ChangeFileExt(Application.ExeName, '.xml');
    LoadConfigVar2Form;

    if ShowModal = mrOK then
    begin
      LoadConfigFile2Var(FXMLFileName);
      FTCPSendThread.FQueryInterval := FOptions.SendInterval;
    end;

    Free;
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  TCPConnect;
end;

procedure TForm1.IdTCPClient1Connected(Sender: TObject);
begin
  //IdTCPClient1.WriteLn(edServer.Text);
end;

procedure TForm1.LoadConfigFile2Var(AFileName: string);
var
  Fs: TFileStream;
begin
  try
    //file이 없으면 생성하고
    if not FileExists(AFileName) then
    begin
      FOptions.FileName := AFileName;
      Fs := TFileStream.Create(AFileName, fmCreate);
      JvgXMLSerializer.Serialize(FOptions, Fs);
    end
    else
    begin
      FOptions.Option.Clear;
      Fs := TFileStream.Create(AFileName, fmOpenRead);
      JvgXMLSerializer.DeSerialize(FOptions, Fs);
    end;
  finally
    Fs.Free;
  end;
end;

procedure TForm1.MakeTCPCommandList;
var
  LStr: string;
  Li: integer;
begin
  if FOptions.Option.Count > 0 then
  begin
    FCommandListOnce.Clear;
    FCommandListOnce.Add(C_MSSM);

    LStr := IntToStr(FOptions.Option.Count) + ',';

    for Li := 0 to FOptions.Option.Count - 1 do
      LStr := LStr + FOptions.Option.Items[Li].GroupNo + ',' +
              FOptions.Option.Items[Li].SerialNo + ','+
              FOptions.Option.Items[Li].SamplingCount + ',';

    RTrimComma(LStr);

    FCommandListOnce.Add(C_MSMD + LStr);

    FCommandListRepeat.Clear;
    FCommandListRepeat.Add(C_MRMD);
    DisplayMemoMessage('Command added to list:');
    memLines.Lines.Add('==================');
    memLines.Lines.AddStrings(FCommandListOnce);
    memLines.Lines.AddStrings(FCommandListRepeat);
    memLines.Lines.Add('==================');
  end;

end;

procedure TForm1.MakeUDPCommandList;
var
  LStr: string;
  Li: integer;
begin
  if FOptions.Option.Count > 0 then
  begin
    FCommandListOnce.Clear;
    FCommandListOnce.Add(C_MSSM);

    LStr := IntToStr(FOptions.Option.Count) + ',';

    for Li := 0 to FOptions.Option.Count - 1 do
      LStr := LStr + FOptions.Option.Items[Li].GroupNo + ',' +
              FOptions.Option.Items[Li].SerialNo + ','+
              FOptions.Option.Items[Li].SamplingCount + ',';

    RTrimComma(LStr);

    FCommandListOnce.Add(C_MSMD + LStr);
    FCommandListOnce.Add(C_MSTT);

    DisplayMemoMessage('Command added to list:');
    memLines.Lines.Add('======================');
    memLines.Lines.AddStrings(FCommandListOnce);
    memLines.Lines.Add('======================');
  end;
end;

procedure TForm1.MakeCommandList1Click(Sender: TObject);
begin
  MakeTCPCommandList;
end;

procedure TForm1.nonch4lblDblClick(Sender: TObject);
begin
  CreateWatchForm('non-CH4', nonch4lbl.Tag);
end;

procedure TForm1.noxlblDblClick(Sender: TObject);
begin
  CreateWatchForm('NOx', noxlbl.Tag);
end;

procedure TForm1.o2lblDblClick(Sender: TObject);
begin
  CreateWatchForm('O2', o2lbl.Tag);
end;

procedure TForm1.Options1Click(Sender: TObject);
begin
  SetConfig;
end;

{ TClientHandleThread }

procedure TTCPReceiveThread.Execute;
begin
  while not Terminated do
  begin
    if not Form1.IdTCPClient1.Connected then
      //Terminate
    else
    try
      //if Form1.FDataSendEvent.Wait(INFINITE) then
      //begin
        Msg := Form1.IdTCPClient1.IOHandler.ReadLn;// ReadLnRFC('', 5);
        if Msg <> '' then
        begin
          Form1.FResponseMsg := Msg;
          SendMessage(Form1.Handle, WM_TCP_RECEIVE, 0, 0);
          Msg := '';
          //Form1.FDataRecvEvent.Pulse;
          //Form1.FDataSendEvent.Reset;
        end;
      //end;
    except
    end;
  end;
end;

procedure TTCPReceiveThread.HandleInput;
begin
end;

{ TTCPSendThread }

constructor TTCPSendThread.Create(AQueryInterval: integer);
begin
  inherited Create(True);

  FSendCommandListOnce := TStringList.Create;
  FSendCommandListRepeat := TStringList.Create;
  FStopSend := False;
  FSendCommandOnce := False;
  FSendCommandRepeat := False;
  FQueryInterval := AQueryInterval;
end;

destructor TTCPSendThread.Destroy;
begin
  FSendCommandListRepeat.Free;
  FSendCommandListOnce.Free;
end;

procedure TTCPSendThread.Execute;
begin
  while not terminated do
  begin
    if FStopSend then
      Suspend;

    if Terminated then
      exit;
      
    //Sleep(FQueryInterval);
    SendQuery;
 end;//while
end;

procedure TTCPSendThread.HandleInput;
begin
end;

procedure TTCPSendThread.SendQuery;
var
  i: integer;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if FStopSend then
    exit;

  if FSendCommandOnce then
  begin
    for i := 0 to FSendCommandListOnce.Count - 1 do
    begin
      if FStopSend then
        exit;

      SendCopyData2(Form1.Handle, ' ', 1);
      Sleep(FQueryInterval);
      Form1.IdTCPClient1.IOHandler.WriteLn(FSendCommandListOnce.Strings[i]);
      SendCopyData2(Form1.Handle, FSendCommandListOnce.Strings[i] ,1);
    end;
    FSendCommandOnce := False;
  end;

  if FSendCommandRepeat then
  begin
    for i := 0 to FSendCommandListRepeat.Count - 1 do
    begin
      if FStopSend then
        exit;

      //if Form1.FDataRecvEvent.Wait(INFINITE) then
      //begin
        SendCopyData2(Form1.Handle, ' ', 1);
        Sleep(FQueryInterval);
        Form1.IdTCPClient1.IOHandler.WriteLn(FSendCommandListRepeat.Strings[i]);
        //Form1.FDataSendEvent.Pulse;
        //Form1.FDataRecvEvent.Reset;
        SendCopyData2(Form1.Handle, FSendCommandListRepeat.Strings[i] ,1);
      //end;
    end;
    FSendCommandOnce := False;
  end;
end;

{ TUDPReceiveThread }

procedure TUDPReceiveThread.Execute;
begin
  while not Terminated do
  begin
    if not Form1.FOptions.UseUDP then
      //Terminate
    else
    try
      UDPMsg := Form1.UDPClient.ReceiveString;
      if UDPMsg <> '' then
      begin
        Synchronize(HandleInput);
        UDPMsg := '';
      end;
    except
    end;
  end;
end;

procedure TUDPReceiveThread.HandleInput;
begin
  Form1.FResponseMsg := UDPMsg;
  Form1.DisplayMemoMessage(UDPMsg);
  SendMessage(Form1.Handle, WM_UDP_RECEIVE, 0, 0);
end;

end.

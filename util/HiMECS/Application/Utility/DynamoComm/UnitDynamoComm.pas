unit UnitDynamoComm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, IdGlobal,
  IdTCPClient, UnitDynamoCommConfig, UnitDynamoConfigClass, ExtCtrls, ComCtrls,
  Menus, UnitIPCClientAll, UnitDynamoConst, IPC_dynamo_Const;

const
  CONFIG_FILE_EXT = '.config';

type
  TDynamoCommF = class(TForm)
    RecvComMemo: TMemo;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    StatusBar1: TStatusBar;
    SendComMemo: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    IPEdit: TEdit;
    PortEdit: TEdit;
    Splitter1: TSplitter;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    BRGTBPanel: TPanel;
    GroupBox2: TGroupBox;
    BRGMTRPanel: TPanel;
    GroupBox3: TGroupBox;
    WaterInletPanel: TPanel;
    GroupBox4: TGroupBox;
    WaterOutletPanel: TPanel;
    GroupBox5: TGroupBox;
    PowerPanel: TPanel;
    GroupBox6: TGroupBox;
    TorquePanel: TPanel;
    GroupBox7: TGroupBox;
    RPMPanel: TPanel;
    GroupBox8: TGroupBox;
    WaterSupplyPanel: TPanel;
    GroupBox9: TGroupBox;
    Body1Panel: TPanel;
    GroupBox11: TGroupBox;
    OilPressPanel: TPanel;
    GroupBox12: TGroupBox;
    Body2Panel: TPanel;
    GroupBox13: TGroupBox;
    Inlet1Panel: TPanel;
    GroupBox14: TGroupBox;
    Outlet1Panel: TPanel;
    Inlet2Panel: TPanel;
    Outlet2Panel: TPanel;
    Timer1: TTimer;
    IdUDPClient1: TIdUDPClient;
    PowerPanel2: TPanel;
    TorquePanel2: TPanel;
    RPMPanel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FDynamoConfig: TDynamoConfig;
    FSendBuffer,
    FRecvBuffer: TIdBytes;
    FIPCClient: TIPCClientAll;//공유 메모리 및 이벤트 객체
    FEventData: TEventData_DYNAMO;

    procedure WMDynamoRead(var Msg: TMessage); message WM_DYNAMO_READ;
    procedure SendData(APacket: TIdBytes);
    procedure RecvData(APacket: TIdBytes);
    procedure MakeCmdData(APacket: TIdBytes);
    function CheckDynamoData(ARecvPacket: TIdBytes; ARecvCount: integer): string;

    procedure DisplayMessage(msg: string; ADspNo: integer);

    procedure LoadConfig2Form(AConfigForm: TDynamoConfigF; ADynamo:TDynamoConfig);
    procedure MoveForm2xml(AConfigForm: TDynamoConfigF);
    procedure SetConfig(ADynamo:TDynamoConfig);
  public
    { Public declarations }
  end;

var
  DynamoCommF: TDynamoCommF;

implementation

{$R *.dfm}

procedure TDynamoCommF.Button1Click(Sender: TObject);
begin
  IdUDPClient1.Host := FDynamoConfig.DestIP;
  IdUDPClient1.Port := FDynamoConfig.DestPort;
  IdUDPClient1.BoundIP := FDynamoConfig.MyIP;//'192.168.1.1'
  IdUDPClient1.BoundPort := FDynamoConfig.MyPort; //5001;
  IdUDPClient1.Active := true;

  Timer1.Enabled := True;
end;

procedure TDynamoCommF.Button2Click(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

function TDynamoCommF.CheckDynamoData(ARecvPacket: TIdBytes; ARecvCount: integer): string;
Var
  LDataLen,
  MemexLen: Integer;
begin
  Result := '';

  LDataLen := ARecvPacket[7] shl 8;
  LDataLen := LDataLen + ARecvPacket[6];

  //Checks the total data length
  if ARecvCount <> LDataLen then
  begin
    Result := 'Receive Data count is different to packet bytes';
    exit;
  end;

  //Checks the packet type
  if ARecvPacket[0] <> $19 then
  begin //
    Result := 'Commands other than MEMOBUS commands are not accepted: '+ IntToHex(ARecvPacket[0],10);
    exit;
  end;

  MemexLen := ARecvPacket[13] shl 8;
  MemexLen := MemexLen + ARecvPacket[12];

  //Checks the Extended MEMOBUS Data Length
  if MemexLen <> LDataLen - 14 then
  begin
    Result := 'Extended MEMOBUS data length is not equal to Total data length -';
    Result := Result + ' 218 header(12 bytes) - Extended MEMOBUS length(2 bytes)';
    exit;
  end;

  //Checks the MFC
  if ARecvPacket[14] <> $20 then
  begin //MFC is fixed to 0x20
    Result := 'MFC is not $20: ' + IntToHex(ARecvPacket[14],10);
    exit;
  end;

  //Checks the SFC
  if ARecvPacket[15] <> $09 then
  begin //SFC is 0x09 (Read Holding Register Contents)
    Result := 'SFC is not $09(Read Holding Register Contents): ' + IntToHex(ARecvPacket[14],10);
    exit;
  end;

  //Checks the number of registers
  if ARecvPacket[18] <> $0F then //or ARecvPacket[19] <> $00
  begin
    Result := 'Not 15 words: ' + IntToHex(ARecvPacket[14],10);
    exit;
  end;

  //ARecvPacket[20] 부터 데이터 시작함
end;

procedure TDynamoCommF.DisplayMessage(msg: string; ADspNo: integer);
begin
  case ADspNo of
    1 : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

      with SendComMemo do
      begin
        if Lines.Count > 100 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtSendMemo

    2: begin
      with RecvComMemo do
      begin
        if Lines.Count > 100 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtRecvMemo

    3: begin
       StatusBar1.SimplePanel := True;
       StatusBar1.SimpleText := DateTimeToStr(now) + ' : ' + msg;
    end;//dtStatusBar
  end;//case
end;

procedure TDynamoCommF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //if FIPCClient.Suspended then
  //  FIPCClient.Resume;

  //FIPCClient.FMonitorEvent.Pulse;
  //FIPCClient.WaitFor;
  //FIPCClient.Terminate;
  FIPCClient.Free;

  FDynamoConfig.Free;
end;

procedure TDynamoCommF.FormCreate(Sender: TObject);
var
  LStr: string;
begin
  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);
  FDynamoConfig := TDynamoConfig.Create(Self);
  FDynamoConfig.LoadFromFile(Lstr);

  FIPCClient := TIPCClientAll.Create;//(0, FDynamoConfig.DestIP, True);
  FIPCClient.ReadAddressFromParamFile(FDynamoConfig.ParamFileName);
  FIPCClient.CreateIPCClientAll;
//  FUniqueEngineName := FIPCClientAll.FProjNo + '_' + FIPCClientAll.FEngNo;

  SetLength(FSendBuffer, 22);
  MakeCmdData(FSendBuffer);
  SetLength(FRecvBuffer, 2048);
end;

procedure TDynamoCommF.LoadConfig2Form(AConfigForm: TDynamoConfigF;
  ADynamo: TDynamoConfig);
begin
  With AConfigForm, ADynamo do
  begin
    HostIPEdit.Text := DestIP;
    PortEdit.Text := IntToStr(DestPort);
    MyIPEdit.Text := MyIP;
    MyPortEdit.Text := IntToStr(MyPort);
    IntervalEdit.Text := IntToStr(QueryInterval);
    ParaFilenameEdit.Text := ParamFileName;
  end;
end;

procedure TDynamoCommF.MakeCmdData(APacket: TIdBytes);
begin
  //==== Ethernet Header ===//
  //Sets the data type
  APacket[0] := $11;  //Extended MEMOBUS(reference command)

  //Sets the serial number(The serial number will be incremented every send data)
  APacket[1] := $00;

  //Sets the destination channel number
  APacket[2] := $00; //The channel number can be fixed to 0 as the channel of PLC is not specified.

  //Sets the destination channel number
  APacket[3] := $00; //Always set to 0 because a PC has no channel number

  APacket[4] := $00; //Reserved
  APacket[5] := $00; //Reserved

  //Sets all the number of data items(from the starting of 218 header to the end of MEMOBUS data)
  APacket[6] := $16; //L(22bytes = 218 header(12bytes) + MEMOBUS data(10 bytes)
  APacket[7] := $00; //H

  APacket[8] := $00; //Reserved
  APacket[9] := $00; //Reserved
  APacket[10] := $00; //Reserved
  APacket[11] := $00; //Reserved

  //==== MemoBus Header ===//
  APacket[12] := $08; //Len Low
  APacket[13] := $00; //Len High

  APacket[14] := $20; //MFC is fixed to 0x20

  //SFC is 0x09 (Read Holding Register Contents(extended))
  APacket[15] := $09; //SFC

  //Set the CPU number
  APacket[16] := $00; //Remote CPU No.: CPU1.Multi CPUs: 1-4. Local CPU No.: always 0

  APacket[17] := $00; //Always 0 for Spare

  //Sets the reference number.
  APacket[18] := $01; //Address Low(leading address: MW1)
  APacket[19] := $00; //Address High

  //Sets the number of registers
  APacket[20] := $0F; //Data Num Low: Reads 15 words from the DataNum(L) leading address.
  APacket[21] := $00; //Data Num High
end;

procedure TDynamoCommF.MoveForm2xml(AConfigForm: TDynamoConfigF);
var
  Lstr: string;
begin
  FDynamoConfig.DestIP := AConfigForm.HostIPEdit.Text;
  FDynamoConfig.DestPort := StrToIntDef(AConfigForm.PortEdit.Text,0);
  FDynamoConfig.MyIP := AConfigForm.MyIPEdit.Text;
  FDynamoConfig.MyPort := StrToIntDef(AConfigForm.MyPortEdit.Text,0);
  FDynamoConfig.QueryInterval := StrToIntDef(AConfigForm.IntervalEdit.Text, 1000);
  FDynamoConfig.ParamFileName := AConfigForm.ParaFilenameEdit.Text;

  Lstr := ChangeFileExt(Application.ExeName, CONFIG_FILE_EXT);
  FDynamoConfig.SaveToFile(LStr);
end;

procedure TDynamoCommF.N2Click(Sender: TObject);
begin
  SetConfig(FDynamoConfig);
end;

procedure TDynamoCommF.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TDynamoCommF.RecvData(APacket: TIdBytes);
var
  LRecvCount: integer;
  LValue: real;
begin
  LRecvCount := IdUDPClient1.ReceiveBuffer(APacket, 100);
  CheckDynamoData(APacket, LRecvCount);

  SendMessage(Handle, WM_DYNAMO_READ, LRecvCount, 0);
end;

procedure TDynamoCommF.SendData(APacket: TIdBytes);
begin
  IdUDPClient1.SendBuffer(APacket);
end;

procedure TDynamoCommF.SetConfig(ADynamo: TDynamoConfig);
var
  ConfigData: TDynamoConfigF;
begin
  ConfigData := nil;
  ConfigData := TDynamoConfigF.Create(Self);
  try
    with ConfigData do
    begin
      LoadConfig2Form(ConfigData, ADynamo);
      if ShowModal = mrOK then
      begin
        MoveForm2xml(ConfigData);
        Timer1.Interval := FDynamoConfig.QueryInterval;
        Self.IPEdit.Text := FDynamoConfig.DestIP;
        Self.PortEdit.Text := IntToStr(FDynamoConfig.DestPort);
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TDynamoCommF.Timer1Timer(Sender: TObject);
begin
  SendData(FSendBuffer);
  RecvData(FRecvBuffer);
end;

procedure TDynamoCommF.WMDynamoRead(var Msg: TMessage);
var
  LRecvCount: integer;
  LValue: double;
  LStr: string;
begin
  LRecvCount := Msg.WParam;
  RecvComMemo.Lines.Add(IntToStr(LRecvCount));

  LRecvCount := FRecvBuffer[21] shl 8;
  LValue := (LRecvCount + FRecvBuffer[20]);
  PowerPanel.Caption := format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[20] shl 8;
  LValue := (LRecvCount + FRecvBuffer[21]);
  PowerPanel2.Caption := format('%.1f',[LValue]);
  FEventData.FPower := LValue;
  LStr := format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[23] shl 8;
  LValue := (LRecvCount + FRecvBuffer[22]);
  TorquePanel.Caption := format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[22] shl 8;
  LValue := (LRecvCount + FRecvBuffer[23]);
  TorquePanel2.Caption := format('%.1f',[LValue]);
  FEventData.FTorque := LValue;
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[25] shl 8;
  LValue := (LRecvCount + FRecvBuffer[24]);
  RPMPanel.Caption := format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[24] shl 8;
  LValue := (LRecvCount + FRecvBuffer[25]);
  RPMPanel2.Caption := format('%.1f',[LValue]);
  FEventData.FRevolution := LValue;
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[27] shl 8;
  LValue := (LRecvCount + FRecvBuffer[26])/10;
  Body2Panel.Caption := format('%.1f',[LValue]);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[29] shl 8;
  LValue := (LRecvCount + FRecvBuffer[28])/10;
  WaterSupplyPanel.Caption := format('%.1f',[LValue]);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[31] shl 8;
  LValue := (LRecvCount + FRecvBuffer[30])/10;
  OilPressPanel.Caption := format('%.1f',[LValue]);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[33] shl 8;
  LValue := (LRecvCount + FRecvBuffer[32])/10;
  Body1Panel.Caption := format('%.1f',[LValue]);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[35] shl 8;
  LValue := (LRecvCount + FRecvBuffer[34])/10;
  FEventData.FInletOpen1 := LValue;
  Inlet1Panel.Caption := format('%.1f',[LValue]);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[37] shl 8;
  LValue := (LRecvCount + FRecvBuffer[36])/10;
  FEventData.FInletOpen2 := LValue;
  Inlet2Panel.Caption := format('%.1f',[LValue]);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[39] shl 8;
  LValue := (LRecvCount + FRecvBuffer[38])/10;
  Outlet1Panel.Caption := format('%.1f',[LValue]);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[41] shl 8;
  LValue := (LRecvCount + FRecvBuffer[40])/10;
  Outlet2Panel.Caption := format('%.1f',[LValue]);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[43] shl 8;
  LRecvCount := LRecvCount + FRecvBuffer[42];
  FEventData.FBrgTBTemp := LRecvCount;
  BRGTBPanel.Caption := IntToStr(LRecvCount);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[45] shl 8;
  LRecvCount := LRecvCount + FRecvBuffer[44];
  FEventData.FBrgMTRTemp := LRecvCount;
  BRGMTRPanel.Caption := IntToStr(LRecvCount);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[47] shl 8;
  LRecvCount := LRecvCount + FRecvBuffer[46];
  FEventData.FWaterInletTemp := LRecvCount;
  WaterInletPanel.Caption := IntToStr(LRecvCount);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  LRecvCount := FRecvBuffer[49] shl 8;
  LRecvCount := LRecvCount + FRecvBuffer[48];
  FEventData.FWaterOutletTemp := LRecvCount;
  WaterOutletPanel.Caption := IntToStr(LRecvCount);
  LStr := ' : ' + LStr + format('%.1f',[LValue]);

  FIPCClient.PulseEventData<TEventData_DYNAMO>(FEventData);
  DisplayMessage(LStr, 2);
  DisplayMessage(DateTimeToStr(now) + ' : ' + '********* 공유메모리에 데이타 전달함!!! **********'+#13#10, 2);
end;

end.

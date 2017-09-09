unit UComm_S7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, SyncObjs,
  Dialogs, CPort, DeCAL, IPCThrd_PLC_S7, IPCThrdClient_PLC_S7, CommonUtil,
  StdCtrls, ComCtrls, ExtCtrls, iniFiles, MyKernelObject, Menus, ByteArray,
  CopyData, JvExComCtrls, JvProgressBar, JvExControls, JvLED, SBPro,
  NoDaveComponent, EngineParameterClass, S7CommConst, S7CommThread, S7Config,
  TimerPool, UnitPing;

type
  TComm_S7F = class(TForm)
    Panel1: TPanel;
    ModBusSendComMemo: TMemo;
    Timer1: TTimer;
    Splitter1: TSplitter;
    ModBusRecvComMemo: TMemo;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    About1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    StatusBarPro1: TStatusBarPro;
    JvLED1: TJvLED;
    JvProgressBar1: TJvProgressBar;
    NoDave: TNoDave;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WMReceiveNoDave( var Message: TMessage ); message WM_RECEIVENODAVE;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure Timer1Timer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FFirst: Boolean;//맨처음에 실행될때 True 그 다음부터는 False
    FFilePath: string;      //파일을 저장할 경로
    FEngineParameter: TEngineParameter;
    FMapFileName: string;//Modbus map file name
    FIsEncryptParam: Boolean;

    FRecvStrBuf: String;        //스트링형 데이터 수신값이 저장됨
    FSharedMemName: string; //IPC Shared Memory Name
    FS7CommBlockList: TStringList;//Modbus Block 통신용 Address 저장 구조체
    FIPCClient: TIPCClient_PLC_S7;//공유 메모리 및 이벤트 객체
    FS7CommBlock: TS7CommBlock;//sendquery용 주소가 들어감(BlockNo별로)
    //FS7CommThread: TS7CommThread;

    FIPAddress: string;
    FPortNum: integer;
    FQueryInterval: integer;
    FTimeOut: integer;

    FPrevBlockNo: integer;//같은 데이터가 3번씩 오므로 1번만 Pulse하기 위함
    //FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event
    FPJHTimerPool: TPJHTimerPool;
    FPLCPingOK,
    FPinging: Boolean;
    FPingTimerHandle: integer;

    procedure SetCurrentCommandIndex(aIndex: integer);
    procedure OnNoDaveRead(Sender: TObject);
    procedure OnNoDaveError(Sender: TObject; ErrorMsg: string);

    procedure OnResetPLC(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnPingPLC(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    function DoPing: boolean;
  public
    FRecvWordBuf: array[0..255] of word;//TCP Wago 사용시 데이터 수신값 저장됨
    FRecvBoolBuf: array[0..255] of Bool;//TCP 사용시 Digital 데이터 수신값 저장됨
    FSendCommandList: TStringList;//Modbus 통신 명령 리스트
    //현재 Comport에 Write한 FSendCommandList의 Index(0부터 시작함)
    FCurrentCommandIndex: integer;
    //일정시간 이상 통신에 대한 반응이 없으면 제어기 다운으로 간주(Wait 시간 설정)
    FCommFail: Boolean;
    FCommFailCount: integer; //통신 반응이 없이 FQueryInterval이 경과한 횟수
    FCriticalSection: TCriticalSection;
    FErrCnt: integer; //LRC Error Log

    procedure InitVar;
    procedure ReadMapFile;
    procedure MakeCommand;

    procedure DisplayMessage(msg: string; IsSend: Boolean);

    procedure LoadConfigDataini2Form(ConfigForm:TS7ConfigF);
    procedure LoadConfigDataini2Var;
    procedure SetConfigData;


  published
    property FilePath: string read FFilePath;
    property StrBuf: string read FRecvStrBuf write FRecvStrBuf;
    property CurrentCommandIndex: integer read FCurrentCommandIndex write SetCurrentCommandIndex;
  end;

var
  Comm_S7F: TComm_S7F;

implementation

uses HiMECSConst;

{$R *.dfm}

const
  AreaNames: Array[0..13] of String = ('SI%1:s%4u', 'SF%1:s%4u', 'I%1:s%4u', 'Q%1:s%4u', 'I%1:s%4u', 'Q%1:s%4u', 'M%1:s%4u', 'DB%u.%s%4u', 'DI%u.%s%4u', 'DL%u.%s%4u', '?%u.%s%4u', 'C%1:s%4u', 'T%1:s%4u', 'PE%1:s%4u');
  TypeNames: Array[0..5] of String = ('B', 'W', 'Int', 'DW', 'DInt', 'Real');

procedure TComm_S7F.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TComm_S7F.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  //FS7CommThread.StopComm := True;
  //FS7CommThread.Terminate;
  FPJHTimerPool.RemoveAll;
  FreeAndNil(FPJHTimerPool);

  NoDave.FSendCommandList := nil;

  for i := 0 to FS7CommBlockList.Count - 1 do
    FS7CommBlockList.Objects[i].Free;

  FS7CommBlockList.free;
  FIPCClient.Free;
  FEngineParameter.Free;
  FCriticalSection.Free;
end;

procedure TComm_S7F.InitVar;
begin
  FFirst := True;
  FErrCnt := 0;
  FPrevBlockNo := -1;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨

  LoadConfigDataini2Var;

  FS7CommBlockList := TStringList.Create;
  FIPCClient := TIPCClient_PLC_S7.Create(0, FSharedMemName, True);
  FEngineParameter := TEngineParameter.Create(Self);

  FSendCommandList := TStringList.Create;

  FCriticalSection := TCriticalSection.Create;
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  //FS7CommThread := TS7CommThread.Create(Self);
  //FS7CommThread.FreeOnTerminate := True;
  //FS7CommThread.StopComm := True;
end;

procedure TComm_S7F.MakeCommand;
var
  i: integer;
  tmpstr: string;
begin
  DisplayMessage('===================================', True);
  DisplayMessage('            COMMAND LIST' , True);
  DisplayMessage('===================================', True);

  for i := 0 to FS7CommBlockList.Count - 1 do
  begin
    tmpstr := tmpStr +
      Format(AreaNames[Ord(TS7CommBlock(FS7CommBlockList.Objects[i]).FS7Area)],
        [TS7CommBlock(FS7CommBlockList.Objects[i]).FS7DBAddress,
        TypeNames[Ord(TS7CommBlock(FS7CommBlockList.Objects[i]).FS7DataType)],
        TS7CommBlock(FS7CommBlockList.Objects[i]).FS7StartOffset]) + ' x ' +
        IntToStr(TS7CommBlock(FS7CommBlockList.Objects[i]).FS7Count) + #13#10;
  end;

  DisplayMessage(tmpStr, True);
  DisplayMessage('===================================', True);
end;

procedure TComm_S7F.ReadMapFile;
var
  i, LPrevBlockNo, LCount: integer;
  LIndex: integer;
  LS7CommBlock: TS7CommBlock;
begin
  FEngineParameter.LoadFromJSONFile(FMapFileName,
                                    ExtractFileName(FMapFileName),
                                    FIsEncryptParam);

  if FEngineParameter.EngineParameterCollect.Count > 0 then
  begin
    for i := 0 to FS7CommBlockList.Count - 1 do
      FS7CommBlockList.Objects[i].Free;

    FS7CommBlockList.Clear;
  end;

  LPrevBlockNo := -1;
  LCount := 0;
  LIndex := 0;//시작 Offset index 저장

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if LPrevBlockNo = FEngineParameter.EngineParameterCollect.Items[i].BlockNo then
    begin
      if LPrevBlockNo <> -1 then
        inc(LCount);
    end
    else
    begin
      if LCount > 0 then
      begin
        LS7CommBlock := TS7CommBlock.Create;

        With LS7CommBlock do
        begin
          FS7Area := TS7Area(FEngineParameter.EngineParameterCollect.Items[i-1].LevelIndex);
          FS7DBAddress := FEngineParameter.EngineParameterCollect.Items[i-1].NodeIndex;
          FS7DataType := TS7DataType(FEngineParameter.EngineParameterCollect.Items[i-1].AbsoluteIndex);
          FS7StartOffset := FEngineParameter.EngineParameterCollect.Items[LIndex].MaxValue;
          FS7Count := LCount;
          FBlockNo := LPrevBlockNo;
          LIndex := i;
        end;//with

        FS7CommBlockList.AddObject(IntToStr(LCount),LS7CommBlock);
        LCount := 1;
      end
      else
        inc(LCount);

      LPrevBlockNo := FEngineParameter.EngineParameterCollect.Items[i].BlockNo;
    end;

  end;//for

  if LCount > 0 then
  begin
    LS7CommBlock := TS7CommBlock.Create;

    With LS7CommBlock do
    begin
      FS7Area := TS7Area(FEngineParameter.EngineParameterCollect.Items[i-1].LevelIndex);
      FS7DBAddress := FEngineParameter.EngineParameterCollect.Items[i-1].NodeIndex;
      FS7DataType := TS7DataType(FEngineParameter.EngineParameterCollect.Items[i-1].AbsoluteIndex);
      FS7StartOffset := FEngineParameter.EngineParameterCollect.Items[LIndex].MaxValue;
      FS7Count := LCount;
      FBlockNo := LPrevBlockNo;
    end;//with

    FS7CommBlockList.AddObject(IntToStr(LCount),LS7CommBlock);
  end;

end;

//같은 데이터가 3번씩 오는 이유?
procedure TComm_S7F.WMReceiveNoDave(var Message: TMessage);
var
  EventData: TEventData_PLC_S7;
  Data: Array of Variant;
  i, Index: Integer;
  Count, DataCount, DataSize: Integer;
  LStr: string;
begin
  //if FPrevBlockNo = TS7CommBlock(FS7CommBlockList.Objects[Self.Tag]).FBlockNo then
  //  exit;
  if NoDave.SeqNo = FPrevBlockNo then
     exit;

  DisplayMessage(FS7CommBlockList.Strings[NoDave.FCurrentCommandIndex]+#13#10, True);
  FCriticalSection.Enter;
  //FPrevBlockNo := TS7CommBlock(FS7CommBlockList.Objects[Self.Tag]).FBlockNo;
  FPrevBlockNo := NoDave.SeqNo;
  try
    DataCount := TS7CommBlock(FS7CommBlockList.Objects[NoDave.FCurrentCommandIndex]).FS7Count;
    DataSize := GetDataSize(TS7CommBlock(FS7CommBlockList.Objects[NoDave.FCurrentCommandIndex]).FS7DataType);
    //SetLength(Data, DataCount);
    Count:=0;

    While Count < DataCount do
    begin
      Index:=(Count * DataSize) + TS7CommBlock(FS7CommBlockList.Objects[NoDave.FCurrentCommandIndex]).FS7StartOffset;

      Case TS7CommBlock(FS7CommBlockList.Objects[NoDave.FCurrentCommandIndex]).FS7DataType of
        S7DTByte : begin
          EventData.DataByte[Count] := NoDave.GetByte(Index);
          LStr := LStr + IntToStr(EventData.DataByte[Count]) + ' , ';;
        end;
        S7DTWord : begin
          EventData.DataWord[Count] := NoDave.GetWord(Index);
          LStr := LStr + IntToStr(EventData.DataWord[Count]) + ' , ';;
        end;
        S7DTInt  : begin
          EventData.DataInt[Count] := NoDave.GetInt(Index);
          LStr := LStr + IntToStr(EventData.DataInt[Count]) + ' , ';;
        end;
        S7DTDWord: begin
          EventData.DataDWord[Count] := NoDave.GetDWord(Index);
          LStr := LStr + IntToStr(EventData.DataDWord[Count]) + ' , ';;
        end;
        S7DTDInt : begin
          EventData.DataDInt[Count] := NoDave.GetDInt(Index);
          LStr := LStr + IntToStr(EventData.DataDInt[Count]) + ' , ';;
        end;
        S7DTReal : begin
          EventData.DataFloat[Count] := NoDave.GetFloat(Index);
          LStr := LStr + FloatToStr(EventData.DataFloat[Count]) + ' , ';;
        end;
      end;
      Inc(Count);
    end;

    EventData.BlockNo := TS7CommBlock(FS7CommBlockList.Objects[NoDave.FCurrentCommandIndex]).FBlockNo;
    EventData.DataType := Ord(TS7CommBlock(FS7CommBlockList.Objects[NoDave.FCurrentCommandIndex]).FS7DataType);

    FIPCClient.PulseMonitor(EventData);
    //NoDave.BufferClear;
    //FS7CommThread.FEventHandle.Signal;
    DisplayMessage(LStr+#13#10, False);
    DisplayMessage('********* ' + FSharedMemName +' : Send OK!!! **********'+#13#10, False);
  finally
    FCriticalSection.Leave;
  end;//try
end;

procedure TComm_S7F.Timer1Timer(Sender: TObject);
var
  LStr: string;
begin
  with Timer1 do
  begin
    Enabled := False;
    try
      SetCurrentDir(FilePath);
      if FFirst then
      begin
        FFirst := False;
        Interval := 500;
        //FS7CommThread.FNoDave := NoDave;
        //FS7CommThread.InitS7Comm;
        //FS7CommThread.FSendCommandList.Assign(FS7CommBlockList);
        //FS7CommThread.FSendCommandList := FS7CommBlockList;
        NoDave.FSendCommandList := FS7CommBlockList;
        ReadMapFile;
        MakeCommand;

        NoDave.Active := False;
        NoDave.OnRead := OnNoDaveRead;
        NoDave.OnError := OnNoDaveError;
        NoDave.RepeatReadCount := -1;

        with NoDave do
        begin
          Area := TNoDaveArea(TS7CommBlock(FS7CommBlockList.Objects[0]).FS7Area);
          DBNumber := TS7CommBlock(FS7CommBlockList.Objects[0]).FS7DBAddress;
          BufLen := GetDataSize(TS7CommBlock(FS7CommBlockList.Objects[0]).FS7DataType)*
                    TS7CommBlock(FS7CommBlockList.Objects[0]).FS7Count;
          BufOffs := TS7CommBlock(FS7CommBlockList.Objects[0]).FS7StartOffset;
        end;

        if ParamCount > 0 then
        begin
          LStr := UpperCase(ParamStr(1));
          if LStr = '/A' then  //Automatic Communication Start
          begin
            Button1Click(nil)
          end;
        end;

      end//if
      else
      begin
        //SendQuery;
      end;
    finally
      Enabled := True;
    end;//try
  end;//with
end;

procedure TComm_S7F.DisplayMessage(msg: string; IsSend: Boolean);
begin
  if IsSend then
  begin
    if msg = ' ' then
    begin
      //TxLed.Value := True;
      exit;
    end
    else
      ;//TxLed.Value := False;

    with ModBusSendComMemo do
    begin
      if Lines.Count > 100 then
        Clear;

      Lines.Add(msg);
    end;//with
  end
  else
  begin
    if msg = 'RxTrue' then
    begin
      //RxLed.Value := True;
      exit;
    end
    else
    if msg = 'RxFalse' then
    begin
      //RxLed.Value := False;
      exit;
    end;

    with ModBusRecvComMemo do
    begin
      if Lines.Count > 100 then
        Clear;

      Lines.Add(msg);
    end;//with
  end;
end;

function TComm_S7F.DoPing: boolean;
var
  str:string;
  ping:Tping;
begin
  FPinging := True;
  ping := Tping.create(NoDave.IPAddress);
  FPLCPingOK := ping.pinghost2;
  if FPLCPingOK then
  begin
    FPingTimerHandle := FPJHTimerPool.Add(OnResetPLC, 1000);
  end;

  //DisplayMessage(DateTimeToStr(now) + ' ==> ' + str, False);
  FreeAndNil(ping);//.destroy ;
  FPinging := False;
end;

procedure TComm_S7F.SetCurrentCommandIndex(aIndex: integer);
begin
  if FCurrentCommandIndex <> aIndex then
    FCurrentCommandIndex := aIndex;
end;

procedure TComm_S7F.Button1Click(Sender: TObject);
begin
{  FS7CommThread.StopComm := not FS7CommThread.StopComm;

  if FS7CommThread.StopComm then
    Button1.Caption := 'Start'
  else
  begin
    FS7CommThread.Resume;
    Button1.Caption := 'Stop';
  end;
  }
  NoDave.Active := not NoDave.Active;

  if NoDave.Active then
    Button1.Caption := 'Stop'
  else
  begin
    Button1.Caption := 'Start';
  end;

end;

//IniFile -> Form
procedure TComm_S7F.LoadConfigDataini2Form(ConfigForm:TS7ConfigF);
begin
  try
    with ConfigForm do
    begin
      SetConnection('S7');
    end;//with
  finally
  end;//try
end;

procedure TComm_S7F.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    with iniFile, NoDave do
    begin
      Protocol := TNoDaveProtocol(ReadInteger(MODBUS_SECTION, 'Protocol',3));
      CPURack := ReadInteger(MODBUS_SECTION, 'CPURack',0);
      CPUSlot := ReadInteger(MODBUS_SECTION, 'CPUSlot',2);
      IPAddress := ReadString(MODBUS_SECTION, 'IPAddress','0.0.0.0');
      MPISpeed := TNoDaveSpeed(ReadInteger(MODBUS_SECTION, 'MPISpeed',2));
      MPILocal := ReadInteger(MODBUS_SECTION, 'MPILocal',0);
      MPIRemote := ReadInteger(MODBUS_SECTION, 'MPIRemote',2);
      IntfTimeout := ReadInteger(MODBUS_SECTION, 'TimeOut',100);
      Interval := ReadInteger(MODBUS_SECTION, 'Interval',1000);
      COMPort := ReadString(MODBUS_SECTION, 'COMPort','COM1:');

      FMapFileName := ReadString(MODBUS_SECTION, 'Modbus Map File Name', '.\ss197_Modbus_Map.txt');
      FSharedMemName := ReadString(MODBUS_SECTION, 'Shared Name', IPCCLIENTNAME1);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try

end;

procedure TComm_S7F.SetConfigData;
var
  ConfigData: TS7ConfigF;
begin
  if Button1.Caption = 'Stop' then
    Button1Click(nil);

  ConfigData := nil;
  ConfigData := TS7ConfigF.Create(Self);
  try
    with ConfigData do
    begin
      SharedName2Combo(SharedNameEdit);
      LoadConfigDataini2Form(ConfigData);
      if ShowModal = mrOK then
      begin
        LoadConfigDataini2Var;
        ReadMapFile;
        MakeCommand;
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TComm_S7F.N2Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TComm_S7F.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TComm_S7F.OnNoDaveError(Sender: TObject; ErrorMsg: string);
begin
  DisplayMessage(DateTimeToStr(now) + ' ==> ' + 'IP: ' + NoDave.IPAddress + '...Ping Failed!', False);
  if (not FPLCPingOK) and (not FPinging) then
    Doping;
  //FPingTimerHandle := FPJHTimerPool.AddOneShot(OnPingPLC, 500);
end;

procedure TComm_S7F.OnNoDaveRead(Sender: TObject);
begin
  SendMessage(Handle,WM_RECEIVENODAVE, 0, 0);
end;

procedure TComm_S7F.OnPingPLC(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  str:string;
  ping:Tping;
begin
  ping := Tping.create(NoDave.IPAddress);
  FPLCPingOK := ping.pinghost(NoDave.IPAddress,str);
  if FPLCPingOK then
  begin
    //FPJHTimerPool.Remove(FPingTimerHandle);
    FPJHTimerPool.AddOneShot(OnResetPLC, 1000);
  end;

  //DisplayMessage(DateTimeToStr(now) + ' ==> ' + str, False);
  FreeAndNil(ping);//.destroy ;
end;

procedure TComm_S7F.OnResetPLC(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  Button1Click(nil);

  if NoDave.Active then
  begin
    FPJHTimerPool.Remove(FPingTimerHandle);
    FPLCPingOK := False;
    //FPJHTimerPool.RemoveAll;
    //FPJHTimerPool.AddOneShot(OnResetPLC, 1000);
  end;
end;

procedure TComm_S7F.WMCopyData(var Msg: TMessage);
begin
  DisplayMessage(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg,
             Boolean(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle));
end;

end.

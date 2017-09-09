unit ModbusCom_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, SyncObjs,
  Dialogs, CPort,
  StdCtrls, ComCtrls, ExtCtrls, DB, DBTables, Grids, DBGrids, iniFiles, ModbusComStruct,
  MyKernelObject, ModBusComThread, ModbusConfig, Menus, ByteArray,
  janSQL, janSQLStrings, CopyData, ModBusTCPWagoThread, MBT2, JvExComCtrls,
  JvProgressBar, JvExControls, JvLED, SBPro, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdModBusClient, ModBusTCPThread, EngineParameterClass,
  DeCAL, IPCThreadEvent, ModbusComConst_HIC, CommonUtil,
  IPCThrdClient_Generic, UnitIPCClientAll, IPC_HIC_Const,
  IPCThrdMonitor_Generic, IPC_ModbusComm_Const;

type
  TModbusComF = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WMReceiveString( var Message: TMessage ); message WM_RECEIVESTRING;
    procedure WMReceiveByte( var Message: TMessage ); message WM_RECEIVEBYTE;
    procedure WMReceiveByte4Write( var Message: TMessage ); message WM_RECEIVEBYTE_WRITE;
    procedure WMReceiveByteConfigData( var Message: TMessage ); message WM_RECEIVEBYTE_CONFIGDATA;
    procedure WMReceiveWordTCPWago( var Message: TMessage ); message WM_RECEIVEWORD_TCPWAGO;
    procedure WMReceiveWordTCP( var Message: TMessage ); message WM_RECEIVEWORD_TCP;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure Timer1Timer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Switch1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FFirst: Boolean;//맨처음에 실행될때 True 그 다음부터는 False
    FFilePath: string;      //파일을 저장할 경로
    FStoreType: TStoreType; //저장방식(ini or registry)
    FRecvStrBuf: String;        //스트링형 데이터 수신값이 저장됨
    FSharedMemName: string; //IPCClient Shared Memory Name
    FMapFileName: string;//Modbus map file name
    FMapFileName2: string;//Modbus map file name
    FComPort: TComPort;     //통신 포트
    FModBusBlockList: DList;//Modbus Block 통신용 Address 저장 구조체
    //FIPCClient: TIPCClient<TEventDataRecord>;//공유 메모리 및 이벤트 객체
    FIPCClientAll: TIPCClientAll;
    FModBusBlock: TModbusBlock;//sendquery용 주소가 들어감(cnt별로)

    FModBusMode: TModBusMode;//ASCII, RTU , TCPWago Mode, simulate mode
    FMBTDLLHandle: THandle; //MBT.DLL file handle
    FIPAddress: string;
    FPortNum: integer;
    FQueryInterval: integer;
    FTimeOut: integer;

    //FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event

    FModBusComThread: TModBusComThread; //Thread 통신 객체
    FModBusTCPWagoThread: TModBusTCPWagoThread; //Thread 통신 객체
    FModBusTCPThread: TModBusTCPThread; //Thread 통신 객체

    procedure SetCurrentCommandIndex(aIndex: integer);
    procedure SetModBusMode(aMode:TModBusMode);

    procedure SerialCommStart;
    procedure DisplayIPCClientList;
  protected
    FIPCMonitor: TIPCMonitor<TConfigData_ModbusComm>;
    FWriteCommData: TConfigData_ModbusComm;
    FSharedMemName2: string; //IPCMonitor Shared Memory Name

    procedure UpdateTrace_WriteComm(var Msg: TConfigData_ModbusComm); message WM_EVENT_WRITECOMM;
    procedure WriteComm_OnSignal(Data: TConfigData_ModbusComm); virtual;

    procedure MakeCommand4Write1(var AValue: string);
    procedure MakeCommand4Write2(var AValue: string);
    procedure MakeCommand4Write3(var AValue: string);
    procedure MakeCommand4Write4(var AValue: string);
    procedure MakeCommand4Write5(var AValue: string);
    procedure MakeCommand4Write6(var AValue: string);
    procedure MakeCommand4ScalarValue(var AValue: string);
  public
    FRecvByteBuf: TByteArray2;//헥사유형의 데이터 수신값이 저장됨
    FRecvWordBuf: array[0..255] of word;//TCP Wago 사용시 데이터 수신값 저장됨
    FRecvBoolBuf: array[0..255] of Bool;//TCP 사용시 Digital 데이터 수신값 저장됨
    FSendCommandList: TStringList;//Modbus 통신 명령 리스트
    //FWriteCommandList: TStringList;//Write 통신 명령 리스트
    //현재 Comport에 Write한 FSendCommandList의 Index(0부터 시작함)
    FCurrentCommandIndex: integer;
    //일정시간 이상 통신에 대한 반응이 없으면 제어기 다운으로 간주(Wait 시간 설정)
    FCommFail: Boolean;
    FCommFailCount: integer; //통신 반응이 없이 FQueryInterval이 경과한 횟수
    //Base Address, Slave number와 Function Code(환경설정으로 받음)
    FBaseAddress, FSlaveNo, FFunctionCode: integer;
    FCriticalSection: TCriticalSection;
    FjanDB : TjanSQL; //text 기반 SQL DB
    FErrCnt: integer; //LRC Error Log
    FEngineParameter: TEngineParameter;
    FEngParamEncrypt: Boolean;
    FEngParamFileFormat: integer;
    FParamFileName: string;
    FConfigModified: Boolean;

    procedure InitVar;
    procedure InitComport;
    //세미콜론(;)으로 분리된 텍스트 화일을 ODBC를 거치지 않고 직접 접근함
    procedure ReadMapAddress(AMapFileName: string; AModBusBlockList:DList);
    procedure ReadMapAddressFromParamFile(AFilename: string; AModBusBlockList:DList);
    procedure ReadMapFile;
    procedure AddCommand2List(StartAddr: string; cnt, fcode: integer);
    procedure AddCommand2List_WriteRegs;
    procedure MakeCommand;

    procedure MakeDataASCII(RecvData: string);
    procedure MakeDataRTU(ASlaveNo, ADataMode: integer);
    procedure MakeDataRTU4WriteFunc(ASlaveNo, ADataMode, AFuncNo, AByteCount: integer);
    procedure MakeDataTCPWago;
    procedure MakeDataTCP;
    procedure DisplayMessage(msg: string; IsSend: Boolean);
    function GetModBusBlock(aIndex: integer): TModBusBlock;

    procedure LoadConfigDataini2Form(ConfigForm:TModbusConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TModbusConfigF);
    procedure SetConfigData;
    procedure SetConfigComm;
    function LoadDLL4TCPWago: Boolean; //MBT.dll file load check = load OK: true
    function MakeModbusTCPWago:Boolean;
    function MakeModbusTCP:Boolean;

    procedure TruncByte(AIndex: integer);

  published
    property FilePath: string read FFilePath;
    property StrBuf: string read FRecvStrBuf write FRecvStrBuf;
    property CurrentCommandIndex: integer read FCurrentCommandIndex write SetCurrentCommandIndex;
    property ModBusMode: TModBusMode read FModBusMode write SetModBusMode;
  end;

var
  ModbusComF: TModbusComF;

implementation

uses ModbusConsts, HiMECSConst;

{$R *.dfm}

procedure TModbusComF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TModbusComF.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  ObjFree(FModBusBlockList);
  FModBusBlockList.free;

  //FIPCClient.Free;
  FIPCClientAll.Free;
  //FWriteCommandList.Free;

  if (FModBusMode = MODBUSTCP_MODE) then
  begin
    for i := 0 to FSendCommandList.Count - 1 do
      TModbusTCP_Command(FSendCommandList.Objects[i]).Free;
  end
  else
    FSendCommandList.Free;

  FRecvByteBuf.Free;
  FCriticalSection.Free;
  //FEventHandle.Free;
  FModBusComThread.CommPort := nil;
  FComport.Free;
  if FModBusComThread.Suspended then
    FModBusComThread.Resume;

  FModBusComThread.FEventHandle.Signal;
  FModBusComThread.Terminate;

  //FModBusComThread.Free;

  if Assigned(FModBusTCPWagoThread) then
  begin
    if FModBusTCPWagoThread.Suspended then
      FModBusTCPWagoThread.Resume;

    FModBusTCPWagoThread.Terminate;
    FModBusTCPWagoThread.FEventHandle.Signal;

    FModBusTCPWagoThread.Free;

    if FMBTDLLHandle <> 0 then begin
      FreeLibrary(FMBTDLLHandle);
      FMBTDLLHandle := 0;
    end;
  end;

  if Assigned(FModBusTCPThread) then
  begin
    if FModBusTCPThread.Suspended then
      FModBusTCPThread.Resume;

    FModBusTCPThread.Terminate;
    FModBusTCPThread.FEventHandle.Signal;

    FModBusTCPThread.Free;
  end;

  FreeAndNil(FEngineParameter);
end;

procedure TModbusComF.InitComport;
begin
  SetCurrentDir(FilePath);
  
  FModBusComThread.SetModbusMode(ModBusMode);

  with FComport do
  begin
    FlowControl.ControlDTR := dtrEnable;
    OnRxChar := FModBusComThread.OnReceiveChar;
    FModBusComThread.FQueryInterval := FQueryInterval;
    LoadSettings(FStoreType, FilePath+INIFILENAME);
    StatusBarPro1.Panels[0].Text := Port;
    StatusBarPro1.Panels[2].Text := BaudRateToStr(BaudRate)+','+
        DataBitsToStr(DataBits)+','+StopBitsToStr(StopBits)+','+ParityToStr(Parity.Bits);
    if Connected then
      Close;
  end;//with
end;

procedure TModbusComF.InitVar;
begin
  FFirst := True;
  FErrCnt := 0;
  FStoreType := stIniFile;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FMBTDLLHandle := 0;

  LoadConfigDataini2Var;

  FModBusBlockList := DList.Create;
  //FIPCClient := TIPCClient<TEventDataRecord>.Create(FSharedMemName, HIC_EVENT_NAME, True);
  FIPCClientAll := TIPCClientAll.Create;

  FIPCMonitor := TIPCMonitor<TConfigData_ModbusComm>.Create(FSharedMemName2, MODBUSCOMM_EVENT_NAME, True);
  FIPCMonitor.FIPCObject.OnSignal := WriteComm_OnSignal;
  FIPCMonitor.FreeOnTerminate := True;
  FIPCMonitor.Resume;

  //ShowMessage(IntToStr(FIPCClient.SharedMemSize));
  FSendCommandList := TStringList.Create;
  //FWriteCommandList := TStringList.Create;
  FRecvByteBuf := TByteArray2.Create(0);
  //FEventHandle := TEvent.Create('',False);
  //FModBusMode := ASCII_MODE;
  FCriticalSection := TCriticalSection.Create;
  FComport := TComport.Create(nil);
  FComport.Name := 'COM1';
  FComport.SyncMethod := smWindowSync;

  FModBusComThread := TModBusComThread.Create(Self,1000);
  FModBusComThread.FreeOnTerminate := True;
  FModBusComThread.CommPort := FComport;
  FModBusComThread.StopComm := True;

  FEngineParameter := TEngineParameter.Create(Self);

  ReadMapFile;

  if ModbusMode = TCP_WAGO_MODE then
  begin
    FModBusTCPWagoThread := nil;
    MakeModbusTCPWago;
  end
  else
  if ModbusMode = MODBUSTCP_MODE then
  begin
    MakeModbusTCP;
  end;
end;

procedure TModbusComF.MakeCommand;
var pModbusBlock: TModbusBlock;
    it: DIterator;
    tmpstr: string;
begin
  if (FModBusMode = ASCII_MODE) or (FModBusMode = RTU_MODE) then
    FModBusComThread.FSendCommandList.Clear
  else if FModBusMode = MODBUSTCP_MODE then
    FModBusTCPThread.FSendCommandList.Clear
  else if FModBusMode = TCP_WAGO_MODE then
    FModBusTCPWagoThread.FSendCommandList.Clear;

  FSendCommandList.Clear;

  case FModBusMode of
    ASCII_MODE:
      tmpstr := '(ASCII Mode)';
    RTU_MODE:
      tmpstr := '(RTU Mode)';
    TCP_WAGO_MODE:
      tmpstr := '(TCP-Wago Mode)';
    MODBUSTCP_MODE:
      tmpstr := '(ModbusTCP Mode)';
  end;//case

  DisplayMessage('===================================', True);
  DisplayMessage('            COMMAND LIST' + tmpstr, True);
  DisplayMessage('===================================', True);

  it := FModBusBlockList.start;

  while not atEnd(it) do
  begin
    pModbusBlock := GetObject(it) as TModbusBlock;

    AddCommand2List(pModbusBlock.FStartAddr, pModbusBlock.FCount, pModbusBlock.FFunctionCode);
    Advance(it);
  end;//while

  DisplayMessage('===================================', True);

  if (FModBusMode = ASCII_MODE) or (FModBusMode = RTU_MODE) then
  begin
    FModBusComThread.FSendCommandList.Assign(FSendCommandList);
    //FModBusComThread.FWriteCommandList.Assign(FWriteCommandList);
  end
  else if FModBusMode = MODBUSTCP_MODE then
    FModBusTCPThread.FSendCommandList.Assign(FSendCommandList)
  else if FModBusMode = TCP_WAGO_MODE then
    FModBusTCPWagoThread.FSendCommandList.Assign(FSendCommandList);
end;

//(XAxis Data, Value Data) 순서로 저장됨
procedure TModbusComF.MakeCommand4ScalarValue(var AValue: string);
var
  i: integer;
  LNumOfData: integer;
begin
  with FWriteCommData do
  begin
    if ModBusFunctionCode = mbfWriteRegs then //WriteRegisters(16 = $10)
    begin
      LNumOfData := 1;
      AValue := AValue + Format('%.2x%.2x', [hi(LNumOfData), lo(LNumOfData)]);
      LNumOfData := LNumOfData * 2;
      AValue := AValue + Format('%.2x', [LNumOfData]);
      AValue := AValue + Format('%.2x%.2x', [hi(DataBuf[0]), lo(DataBuf[0])]);
    end;
  end;//with
end;

procedure TModbusComF.MakeCommand4Write1(var AValue: string);
var
  i: integer;
  LNumOfData: integer;
begin
  with FWriteCommData do
  begin
    if ModBusFunctionCode = mbfWriteRegs then //WriteRegisters(16 = $10)
    begin
      LNumOfData := NumOfData * 2;
      AValue := AValue + Format('%.2x%.2x', [hi(LNumOfData), lo(LNumOfData)]);
      LNumOfData := LNumOfData * 2;
      AValue := AValue + Format('%.2x', [LNumOfData]);

      for i := 0 to NumOfData_X - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(XAxisData[i]), lo(XAxisData[i])]);

      for i := 0 to NumOfData - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(DataBuf[i]), lo(DataBuf[i])]);
    end;
  end;//with
end;

//(XAxis Data, YAxis Data, Value Data) 순서로 저장됨
procedure TModbusComF.MakeCommand4Write2(var AValue: string);
var
  i,j,LNumOfData: integer;
begin
  with FWriteCommData do
  begin
    if ModBusFunctionCode = mbfWriteRegs then //WriteRegisters(16 = $10)
    begin
      LNumOfData := NumOfData_X + NumOfData_Y + NumOfData;
      AValue := AValue + Format('%.2x%.2x', [hi(LNumOfData), lo(LNumOfData)]);
      LNumOfData := LNumOfData * 2;
      AValue := AValue + Format('%.2x', [LNumOfData]);

      for i := 0 to NumOfData_X - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(XAxisData[i]), lo(XAxisData[i])]);

      for i := 0 to NumOfData_Y - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(YAxisData[i]), lo(YAxisData[i])]);

      for i := 0 to NumOfData - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(DataBuf[i]), lo(DataBuf[i])]);
    end;
  end;//with
end;

//(XAxis Data, YAxis Data, ZAxis Data, Value Data) 순서로 저장됨
procedure TModbusComF.MakeCommand4Write3(var AValue: string);
var
  i,j,k,LNumOfData: integer;
begin
  with FWriteCommData do
  begin
    if ModBusFunctionCode = mbfWriteRegs then //WriteRegisters(16 = $10)
    begin
      LNumOfData := NumOfData_X + NumOfData_Y + NumOfData_Z + NumOfData;
      AValue := AValue + Format('%.2x%.2x', [hi(LNumOfData), lo(LNumOfData)]);
      LNumOfData := LNumOfData * 2;
      AValue := AValue + Format('%.2x', [LNumOfData]);

      for i := 0 to NumOfData_X - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(XAxisData[i]), lo(XAxisData[i])]);

      for i := 0 to NumOfData_Y - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(YAxisData[i]), lo(YAxisData[i])]);

      for i := 0 to NumOfData_Z - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(ZAxisData[i]), lo(ZAxisData[i])]);

      for i := 0 to NumOfData - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(DataBuf[i]), lo(DataBuf[i])]);
    end;
  end;//with
end;

//array[0..255] of single
procedure TModbusComF.MakeCommand4Write4(var AValue: string);
var
  i,j,LNumOfData: integer;
  LSr: TSingleRec;
begin
  with FWriteCommData do
  begin
    if ModBusFunctionCode = mbfWriteRegs then //WriteRegisters(16 = $10)
    begin
      LNumOfData := NumOfData * 2;
      AValue := AValue + Format('%.2x%.2x', [hi(LNumOfData), lo(LNumOfData)]);
      LNumOfData := LNumOfData * 2;
      AValue := AValue + Format('%.2x', [LNumOfData]);

      for i := 0 to NumOfData_X - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(XAxisData[i]), lo(XAxisData[i])]);

      for i := 0 to NumOfData - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(DataBuf[i]), lo(DataBuf[i])]);
    end;
  end;//with
end;

//array[0..255] of array[0..255] of single
procedure TModbusComF.MakeCommand4Write5(var AValue: string);
var
  i,j,k,LNumOfData: integer;
  LSr: TSingleRec;
begin
  with FWriteCommData do
  begin
    if ModBusFunctionCode = mbfWriteRegs then //WriteRegisters(16 = $10)
    begin
      LNumOfData := NumOfData_X + NumOfData_Y + NumOfData;
      AValue := AValue + Format('%.2x%.2x', [hi(LNumOfData), lo(LNumOfData)]);
      LNumOfData := LNumOfData * 2;
      AValue := AValue + Format('%.2x', [LNumOfData]);

      for i := 0 to NumOfData_X - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(XAxisData[i]), lo(XAxisData[i])]);

      for i := 0 to NumOfData_Y - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(YAxisData[i]), lo(YAxisData[i])]);

      for i := 0 to NumOfData - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(DataBuf[i]), lo(DataBuf[i])]);
    end;
  end;//with
end;

//array[0..255] of array[0..255] of array[0..255] of single
procedure TModbusComF.MakeCommand4Write6(var AValue: string);
var
  i,j,k,n,LNumOfData: integer;
  LSr: TSingleRec;
begin
  with FWriteCommData do
  begin
    if ModBusFunctionCode = mbfWriteRegs then //WriteRegisters(16 = $10)
    begin
      LNumOfData := NumOfData_X + NumOfData_Y + NumOfData_Z + NumOfData;
      AValue := AValue + Format('%.2x%.2x', [hi(LNumOfData), lo(LNumOfData)]);
      LNumOfData := LNumOfData * 2;
      AValue := AValue + Format('%.2x', [LNumOfData]);

      for i := 0 to NumOfData_X - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(XAxisData[i]), lo(XAxisData[i])]);

      for i := 0 to NumOfData_Y - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(YAxisData[i]), lo(YAxisData[i])]);

      for i := 0 to NumOfData_Z - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(ZAxisData[i]), lo(ZAxisData[i])]);

      for i := 0 to NumOfData - 1 do
        AValue := AValue + Format('%.2x%.2x',
                          [hi(DataBuf[i]), lo(DataBuf[i])]);
    end;
  end;//with
end;

procedure TModbusComF.ReadMapAddress(AMapFileName: string; AModBusBlockList:DList);
var
  sqltext: string;
  sqlresult, reccnt: integer;
  i: integer;
  filename, LFilePath: string;
begin
  if fileexists(AMapFileName) then
  begin
    AModBusBlockList.clear;
    LFilePath := ExtractFilePath(AMapFileName);
    Filename := ExtractFileName(AMapFileName);
    FileName := Copy(Filename,1, Pos('.',Filename) - 1);
    FjanDB :=TjanSQL.create;
    try
      sqltext := 'connect to ''' + LFilePath + '''';

      sqlresult := FjanDB.SQLDirect(sqltext);
      //Connect 성공
      if sqlresult <> 0 then
      begin

        with FjanDB do
        begin
          sqltext := 'select count(addr) ,min(addr), cnt, alarm from ' + FileName + '  group by cnt, alarm';
          sqlresult := SQLDirect(sqltext);
          //Query 정상
          if sqlresult <> 0 then
          begin
            //데이타 건수가 1개 이상 있으면
            if sqlresult>0 then
            begin
              reccnt := RecordSets[sqlresult].FieldCount;
              //Field Count가 0 이면
              if reccnt = 0 then exit;

              reccnt := RecordSets[sqlresult].RecordCount;
              //Record Count가 0 이면
              if reccnt = 0 then exit;

              for i := 0 to reccnt - 1 do
              begin
                FModBusBlock := TModbusBlock.Create;
                With FModBusBlock do
                begin
                  FCount := StrToInt(RecordSets[sqlresult].records[i].fields[0].value);
                  FStartAddr := RecordSets[sqlresult].records[i].fields[1].value;
                  FBlockNo := RecordSets[sqlresult].records[i].fields[2].value;
                  filename := RecordSets[sqlresult].records[i].fields[3].value;
                  if (UpperCase(filename) = 'TRUE') or //Analog인경우
                      (UpperCase(filename) = 'FALSE3')then //Digital 인데 03으로(금오기전 제어기인 경우)
                  begin
                    FFunctionCode := 03;
                  end
                  else
                  if UpperCase(filename) = 'TRUE4' then //Function Code 04인 경우
                  begin
                    FFunctionCode := 04;
                  end
                  else
                  if (UpperCase(filename) = 'FALSE2') then //Digital 인데 02로인경우(Read Input Status)
                  begin
                    FFunctionCode := 02;
                  end
                  else
                  begin  //Read Coils
                    FFunctionCode := 01;
                  end;

                  AModBusBlockList.Add([FModBusBlock]);
                end;//with
              end;//for
            end;

          end
          else
            DisplayMessage(FjanDB.Error, True);
        end;//with
      end
      else
        Application.MessageBox('Connect 실패',
            PChar('폴더 ' + FFilePath + ' 를 만든 후 다시 하시오'),MB_ICONSTOP+MB_OK);
    finally
      FjanDB.Free;
      FjanDB := nil;
    end;//try
  end
  else
  begin
    sqltext := AMapFileName + ' 파일을 만든 후에 다시 하시오';
    Application.MessageBox('Data file does not exist!', PChar(sqltext) ,MB_ICONSTOP+MB_OK);
    //Application.Terminate;
  end;
end;

procedure TModbusComF.ReadMapAddressFromParamFile(AFilename: string;
  AModBusBlockList: DList);
var
  i, LPrevBlockNo, LCount: integer;
  LIndex: integer;
  LStartAddr:string;
  LBlockNo,
  LFuncCode,
  LParamType: integer;
begin
  if not FileExists(AFilename) then
  begin
    ShowMessage(AFilename + ' file is not exist');
    exit;
  end;

  FEngineParameter.LoadFromJSONFile(AFilename,
                                    ExtractFileName(AFilename),
                                    FEngParamEncrypt);
  AModBusBlockList.clear;

  LPrevBlockNo := -1;
  LCount := 0;
  LIndex := 0;//시작 Offset index 저장

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    //stConfig는 건너 뜀
    if (FEngineParameter.EngineParameterCollect.Items[i].SensorType = stConfig) and
      (FEngineParameter.EngineParameterCollect.Items[i].IsMatrixData) then
      continue;

    if LPrevBlockNo = FEngineParameter.EngineParameterCollect.Items[i].BlockNo then
    begin
      if LCount = 1 then
      begin
        LStartAddr := FEngineParameter.EngineParameterCollect.Items[i-1].Address;
        LBlockNo := FEngineParameter.EngineParameterCollect.Items[i-1].BlockNo;
        LFuncCode := StrToIntDef(FEngineParameter.EngineParameterCollect.Items[i-1].FCode,0);
        LParamType := Ord(FEngineParameter.EngineParameterCollect.Items[i-1].ParameterType);
      end;

      if LPrevBlockNo <> -1 then
        inc(LCount);
    end
    else
    begin
      if( LCount > 0) and
        (FEngineParameter.EngineParameterCollect.Items[i-1].BlockNo > 0) then
      begin
        FModBusBlock := TModbusBlock.Create;

        With FModBusBlock do
        begin
          //BlockNo가 변하는 곳까지 검색 후 변하는곳 이전 데이터 저장(i-1)
          FStartAddr := LStartAddr;
          FCount := LCount;
          FBlockNo := LBlockNo;
          FFunctionCode := LFuncCode;
          FParamType := LParamType;
        end;

        AModBusBlockList.Add([FModBusBlock]);

        LCount := 1;
      end
      else
        inc(LCount);

      LPrevBlockNo := FEngineParameter.EngineParameterCollect.Items[i].BlockNo;
    end;

  end;//for

  if( LCount > 0) and
    (FEngineParameter.EngineParameterCollect.Items[i-1].BlockNo > 0) then
  begin
    FModBusBlock := TModbusBlock.Create;

    With FModBusBlock do
    begin
      FCount := LCount;
      FStartAddr := LStartAddr;
      FBlockNo := LBlockNo;
      FFunctionCode := LFuncCode;
      FParamType := LParamType;
    end;//with

    AModBusBlockList.Add([FModBusBlock]);
  end;
end;

procedure TModbusComF.ReadMapFile;
begin
  FModBusComThread.TimeOut := FTimeOut;

  if not FFirst then
  begin
    ReadMapAddress(FMapFileName,FModBusBlockList);
    MakeCommand;
  end;

  if (ModbusMode = ASCII_MODE) or (ModbusMode = RTU_MODE) then
    if FileExists(FilePath+INIFILENAME) then
      FComport.LoadSettings(FStoreType, FilePath + INIFILENAME);
end;

procedure TModbusComF.AddCommand2List(StartAddr: string; cnt, fcode: integer);
var
  SendBuff: string;
  tmpStr: string;
  iAddr: integer;
  lrc: Byte;
  crc16: word;
  SendLength: integer;
  ModbusTCP_Command: TModbusTCP_Command;
  i: integer;
begin
  iAddr := Str2Hex_Int(StartAddr) - FBaseAddress - 1;//$5000;

  SendBuff := Format('%.2x%.2x%.2x%.2x%.2x%.2x',
                    [FSlaveNo,FCode,(iAddr shr 8) and $FF,iAddr and $FF,
                        (cnt shr 8) and $FF,cnt and $FF]);

  if (ModbusMode = ASCII_MODE) or (ModbusMode = TCP_WAGO_MODE) then
  begin
    SendBuff := ':' + SendBuff;
    tmpStr := Copy(SendBuff,2,12);
    lrc := Update_LRC(tmpStr, Length(tmpStr));
    SendBuff := SendBuff + Format('%.2x',[lrc]) + #13#10;
  end
  else
  if ModbusMode = RTU_MODE then
  begin
    tmpStr := SendBuff;
    crc16 := CalcCRC16_2(tmpStr);
    SendBuff := SendBuff + Format('%.4x', [crc16]);
  end;

  if ModbusMode = MODBUSTCP_MODE then
  begin
    ModbusTCP_Command := TModbusTCP_Command.Create;
    ModbusTCP_Command.FSlaveAddress := FSlaveNo;
    ModbusTCP_Command.FFunctionCode := FCode;
    ModbusTCP_Command.FStartAddress := iAddr;
    ModbusTCP_Command.FDataCountWord := cnt;

    FSendCommandList.AddObject(SendBuff, ModbusTCP_Command);
  end
  else
    FSendCommandList.Add(SendBuff);

  DisplayMessage(SendBuff, True);
end;

procedure TModbusComF.AddCommand2List_WriteRegs;
var
  ModbusTCP_Command: TModbusTCP_Command;
  i: integer;
  iAddr: integer;
  SendBuff: string;
begin
  iAddr := Str2Hex_Int(FWriteCommData.ModBusAddress) - FBaseAddress;//$5000;
  SendBuff := Format('%.2x%.2x%.2x%.2x%.2x%.2x',
                    [FWriteCommData.SlaveNo, FWriteCommData.ModBusFunctionCode,
                      (iAddr shr 8) and $FF,iAddr and $FF,
                        (FWriteCommData.NumOfData shr 8) and $FF,
                        FWriteCommData.NumOfData and $FF]);

  if FWriteCommData.ModbusMode = Ord(MODBUSTCP_MODE) then
  begin
    ModbusTCP_Command := TModbusTCP_Command.Create;
    ModbusTCP_Command.FFunctionCode := FWriteCommData.ModBusFunctionCode;
    ModbusTCP_Command.FStartAddress := iAddr;
    ModbusTCP_Command.FDataCountWord := FWriteCommData.NumOfData;

    if FWriteCommData.ModBusFunctionCode = mbfWriteRegs then //WriteRegisters(16 = $10)
    begin
      ModbusTCP_Command.FRepeatCount := 1;
      SetLength(ModbusTCP_Command.FBufferWord, Length(FWriteCommData.DataBuf));
      for i := Low(FWriteCommData.DataBuf) to High(FWriteCommData.DataBuf) do
        ModbusTCP_Command.FBufferWord[i] := FWriteCommData.DataBuf[i];
    end;

    FSendCommandList.AddObject(SendBuff, ModbusTCP_Command);
  end
end;

procedure TModbusComF.WMReceiveString(var Message: TMessage);
var
  TmpStr, TmpRecvStr: string;
  i, j, LengthStr: integer;
begin  //CRLF가 없으면 쓰레드에서 이 함수로 넘어오지 않음
  FCriticalSection.Enter;
  try

  LengthStr := Length(FRecvStrBuf);
  if LengthStr > 7 then //기본 packet의 byte count 이상 수신인지 확인
  begin
    if FRecvStrBuf[1] <> ':' then //첫문자가 ':'이 아니면 Invalid format
    begin
      DisplayMessage(FRecvStrBuf+' ==> 첫문자가 ":"이 아님', False);
      FRecvStrBuf := '';
      exit;
    end;

    TmpStr := FRecvStrBuf[6] + FRecvStrBuf[7]; //Data부분 Byte Size
    if TmpStr = '' then //Byte Count Field가 없으면 Dead Packet
    begin
      DisplayMessage(FRecvStrBuf+' ==> Byte Count Field가 없음(6,7번째)', False);
      FRecvStrBuf := '';
      exit;
    end;

    i := HexToInt(TmpStr) * 2; //ASCII Mode에서는 데이타 1개당 2Byte가 할당됨(?)
    if LengthStr >= i + 9 then //header(7)+lrc(2byte)제외,  crlf(2byte)는 Length의 반환값에서 제외됨
    begin
      tmpStr := '';
      j := 0;
      //두개 이상의 Response가 한꺼번에  수신된 경우 다음번 ':'은 저장하여 계속 처리함
      j := NextPos2(':', FRecvStrBuf, 2);
      if j > 0 then
      begin
        tmpStr := Copy(FRecvStrBuf, j - 1, Length(FRecvStrBuf) - j);
        FRecvStrBuf := Copy(FRecvStrBuf, 1, j - 2) + #13#10;
      end;

      TmpRecvStr := FRecvStrBuf;
      FRecvStrBuf := tmpStr;              //Buffer 초기화


      DisplayMessage(TmpRecvStr, False);
      MakeDataASCII(TmpRecvStr);
    end;
  end
  else
    ;//FStrBuf := '';

  //FEventHandle.Signal;
  finally
    FCriticalSection.Leave;
  end;//try
end;

procedure TModbusComF.WMReceiveByte(var Message: TMessage);
var
  i, SN, FC, LByteCount: integer;
  TempByteBuf: TByteArray2;
begin
  while true do
  begin
    //RTU Mode에서는 CRLF가 없음
    if FRecvByteBuf.Size > 5 then //기본 packet의 byte count 이상 수신인지 확인
    begin
      //첫데이타가 요청했던 Slave No가 아니면 Invalid format
      if (FRecvByteBuf.Items[0] <> FSlaveNo) then
      begin
        i := FRecvByteBuf.PosNext(FSlaveNo);
        if i > 0 then
        begin
          TruncByte(i);
          Continue;
        end;//if

        DisplayMessage(FRecvByteBuf.CopyToString(0,FRecvByteBuf.Size) + #13#10 +
                        ' ==> 첫 데이타가 유효한 Slave No가 아님('+
                        IntToStr(FSlaveNo)+')', False);
        FRecvByteBuf.Clear;
        exit;
      end;

      SN := FRecvByteBuf.Items[0];
      FC := FRecvByteBuf.Items[1];

      //if FC = 16 then
      //begin
      //  LByteCount := (FRecvByteBuf.Items[4] shl 8) and $FF00;
      //  LByteCount := LByteCount + FRecvByteBuf.Items[5];
      //end
      //else
        LByteCount := FRecvByteBuf.Items[2];

      if LByteCount <= 0 then //데이타 Count <= 0
      begin
        DisplayMessage(FRecvByteBuf.CopyToString(0,FRecvByteBuf.Size) + #13#10 +
                        ' ==> Byte Count Field 이상(3번째 Field)', False);
        FRecvByteBuf.Clear;
        exit;
      end;

      //Data Count + header(3byte)+crc(2byte)포함,  RTU Mode에서는 CRLF가 없슴
      if FRecvByteBuf.Size >= FRecvByteBuf.Items[2] + 5 then
      begin
        TempByteBuf := nil;

        //두개 이상의 Response가 한꺼번에  수신된 경우 다음번 SlaveNo,Function Code은 저장하여 계속 처리함
        i := FRecvByteBuf.PosNext(SN,FRecvByteBuf.Items[2] + 5);
        if i > 0 then  //또다른 FSlaveNo가 존재하는 경우
        begin
          if FRecvByteBuf.Items[i + 1] = FC then
          begin
            TempByteBuf := TByteArray2.Create(0);
            TempByteBuf.CopyByteArray(FRecvByteBuf, i, FRecvByteBuf.Size - i);
          end;
        end;

        DisplayMessage(FRecvByteBuf.CopyToString(0,FRecvByteBuf.Size), False);

        //if FC = 16 then
        //  MakeDataRTU4WriteFunc(SN, Message.WParam, FC, LByteCount)
        //else
          MakeDataRTU(SN, Message.WParam);

        //FRecvByteBuf.Clear;

        if Assigned(TempByteBuf) then
        begin
          FRecvByteBuf.CopyByteArray(TempByteBuf, 0, TempByteBuf.Size);
          TempByteBuf.Free;
          TempByteBuf := nil;
          continue;
        end
        else
          break;
      end
      else//아직 완성되지 않은 패킷
        break;
    end
    else
      break;
  end;//while
end;

//Response = Function Code(1byte), Starting Address(2byte), Quantity of Registers(2byte)
//                (0x10                     0x0000                 0x0000)
procedure TModbusComF.WMReceiveByte4Write(var Message: TMessage);
var
  i, SN, FC, iAddr, iAddr2, Lcount: integer;
  LStr: string;
begin
  //FModBusComThread.FEventHandle.Signal;
  while true do
  begin
    if FRecvByteBuf.Size >= 8 then //기본 packet의 byte count 이상 수신인지 확인
    begin
      //첫데이타가 요청했던 Slave No가 아니면 Invalid format
      if (FRecvByteBuf.Items[0] <> FSlaveNo) then
      begin
        i := FRecvByteBuf.PosNext(FSlaveNo);
        if i > 0 then
        begin
          TruncByte(i);
          Continue;
        end;//if

        DisplayMessage(FRecvByteBuf.CopyToString(0,FRecvByteBuf.Size) + #13#10 +
                        ' ==> 첫 데이타가 유효한 Slave No가 아님('+
                        IntToStr(FSlaveNo)+')', False);
        FRecvByteBuf.Clear;
        exit;
      end;

      SN := FRecvByteBuf.Items[0];
      FC := FRecvByteBuf.Items[1]; //0x10

      if FC = 16 then //0x10
      begin
        iAddr := Str2Hex_Int(FWriteCommData.ModBusAddress) - FBaseAddress - 1;//$5000;
        iAddr2 := (FRecvByteBuf.Items[2] shl 8) and $FF00; //Start Address Hi
        iAddr2 := iAddr2 + FRecvByteBuf.Items[3]; //Start Address Lo

        if iAddr = iAddr2 then
        begin
          Lcount := (FRecvByteBuf.Items[4] shl 8) and $FF00; //Quantity Hi
          Lcount := Lcount + FRecvByteBuf.Items[5]; //Quantity Lo

          if LCount = (FWriteCommData.NumOfData+FWriteCommData.NumOfData_X+FWriteCommData.NumOfData_Y+FWriteCommData.NumOfData_Z) then
          begin
            DisplayMessage(FRecvByteBuf.CopyToString(0,8), False);
            MakeDataRTU4WriteFunc(SN, Message.WParam, FC, Lcount);
          end
          else
          begin
            DisplayMessage(FRecvByteBuf.CopyToString(0,FRecvByteBuf.Size) + #13#10 +
                            ' ==> Byte Count Field 이상(5번째 Field)', False);
            FRecvByteBuf.Clear;
            exit;
          end;
        end;
      end;

{      if FRecvByteBuf.Items[2] <= 0 then //Start Address Hi
      begin
      end;
      if FRecvByteBuf.Items[3] <= 0 then //Start Address Lo
      begin
      end;
      if FRecvByteBuf.Items[4] <= 0 then //Quantity Hi
      begin
      end;
      if FRecvByteBuf.Items[5] <= 0 then //Quantity Lo
      begin
      end;
      if FRecvByteBuf.Items[6] <= 0 then //CRC Lo
      begin
      end;
      if FRecvByteBuf.Items[7] <= 0 then //CRC High
      begin
      end;
}
      break;
    end
    else
    if FRecvByteBuf.Size = 5 then //기본 packet의 byte count 이상 수신인지 확인
      break;
  end;//while
end;

//Matrix Data Read
procedure TModbusComF.WMReceiveByteConfigData(var Message: TMessage);
begin
  SendMessage(Handle,WM_RECEIVEBYTE, 1, 0);
end;

procedure TModbusComF.WMReceiveWordTCP(var Message: TMessage);
begin
  MakeDataTCP;
end;

procedure TModbusComF.WMReceiveWordTCPWago(var Message: TMessage);
begin
  MakeDataTCPWago;
end;

procedure TModbusComF.WriteComm_OnSignal(Data: TConfigData_ModbusComm);
begin
  //IPCClient가 Free 될때 pulsemonitor 실행되므로 이를 피하기 위함
  if Data.Termination then
  begin
    Data.Termination := False;
    exit;
  end;

  System.Move(Data, FWriteCommData, Sizeof(Data));
  SendMessage(Handle, WM_EVENT_WRITECOMM, 0,0);
end;

//수신한 ModBus Data에서 LRC 및 데이타 건수를 검사 한 후 데이타값만 공유메모리에 전달함
procedure TModbusComF.MakeDataASCII(RecvData: string);
var
  pModbusBlock: TModbusBlock;
  EventData: TEventData_HIC;
  arydata: array[0..19] of char;
  pAryData: PChar;
  i, j, k, m, ByteCount: integer;
  lrc, tmpByte: Byte;
  tmpstr, tmpstr2: string;
begin
  tmpstr := '';
  tmpstr := RecvData[Length(RecvData) - 3] + RecvData[Length(RecvData) - 2];

  tmpstr2 := Copy(RecvData, 2, Length(RecvData) - 5);
  lrc := Update_LRC(tmpstr2, Length(tmpstr2));

  //LRC가 정확한지 Check
  if Str2Hex_Byte(tmpstr) = lrc then
  begin
    tmpstr := '';
    tmpstr := RecvData[6] + RecvData[7];//Byte Count 가져옴
    ByteCount := Str2Hex_Byte(tmpstr);

    pModbusBlock := GetModBusBlock(FCurrentCommandIndex);
    if pModbusBlock <> nil then
    begin
      if (pModBusBlock.FFunctionCode = 1) or (pModBusBlock.FFunctionCode = 2) then
      begin
        j := (pModBusBlock.FCount div 8);
        if pModBusBlock.FCount mod 8 > 0 then
          Inc(j);
      end
      else
      begin
        //Byte Count가 Hi, Lo로 구분되어 오기 떄문에 나누기 2를한 값이 실제 데이타 갯수임
        ByteCount := ByteCount Div 2;
        j := pModBusBlock.FCount;
      end;

      with EventData do
      begin
        ModBusFunctionCode := pModBusBlock.FFunctionCode;
        if (pModBusBlock.FFunctionCode = 1) or (pModBusBlock.FFunctionCode = 2) then
        begin
          //m := 0;
          for i := 0 to ByteCount - 1 do
          begin
            //공유메모리에 값을 저장함
            tmpstr := RecvData[MODBUS_DATA_ASCII_START_HI_IDX + (i * 2)] +
                      RecvData[MODBUS_DATA_ASCII_START_HI_IDX + (i * 2) + 1];
            tmpByte := Str2Hex_Byte(tmpStr);

            if (i mod 2) = 0 then
              InpDataBuf[i div 2] := tmpByte shl 8
            else
              InpDataBuf[i div 2] := InpDataBuf[i div 2] + tmpByte;


(*            for k := 0 to 7 do
            begin
              if GetBitVal(tmpByte, k) = 0 then
                tmpstr := '0000'
              else
                tmpstr := 'FFFF';

              InpDataBuf[m] := Str2Hex_Int(tmpStr);
              inc(m);

              if m > pModBusBlock.FCount then
                break;
            end;//for
*)
          end;//for
        end
        else
        begin
          for i := 0 to ByteCount - 1 do
          begin
            tmpstr := RecvData[MODBUS_DATA_ASCII_START_HI_IDX + (i * 4)] +
                      RecvData[MODBUS_DATA_ASCII_START_HI_IDX + (i * 4) + 1] +
                      RecvData[MODBUS_DATA_ASCII_START_LO_IDX + (i * 4)] +
                      RecvData[MODBUS_DATA_ASCII_START_LO_IDX + (i * 4) + 1];
            //공유메모리에 값을 저장함
            InpDataBuf[i] := Str2Hex_Int(tmpStr);
          end;//for
        end;

        //Flag := cfModBusCom;
        NumOfData := ByteCount;
        ModBusMode := Ord(ASCII_MODE);

        //수신한 데이타수와 요구한 데이타수가 다르면 exit
        if ByteCount <> j then//pModBusBlock.FCount
        begin
          DisplayMessage(RecvData +
                          ' ==> 수신한 데이타수 -> 요구한 데이타수가 다름 (' +
                          IntToHex(ByteCount,2) +' -> '+ IntToHex(pModBusBlock.FCount,2)+ ')',
                                                      False);
          exit;
        end;//if

        //pAryData := @aryData[0];
        //pAryData := StrPCopy(pAryData,pModBusBlock.FStartAddr);
        //StrCopy(@ModBusAddress[0], pAryData);//pModBusBlock.FStartAddr;
        ModBusAddress := pModBusBlock.FStartAddr;
        BlockNo := pModBusBlock.FBlockNo;
      end;//with
    end//if
    else
    begin
      DisplayMessage('ModBusBlock을 가져올 수 없음(' +
                        IntToStr(FCurrentCommandIndex) +')', False);
      exit;//startaddress를 가져오지 못하면 exit
    end;

    FIPCClientAll.FIPCClient_HIC.PulseMonitor(EventData);
    FModBusComThread.FEventHandle.Signal;
    DisplayMessage('********* 공유메모리에 데이타 전달함!!! **********'+#13#10, False);
  end
  else
  begin
    Inc(FErrCnt);
    Label4.Caption := IntToStr(FErrCnt);
    //DisplayMessage(RecvData ,False);//LRC Packet Error
    DisplayMessage(''' ==> LRC Error (' +tmpstr+' -> '+ IntToHex(lrc,2)+ ')''',
                                                      False);//LRC Packet Error
  end;
end;

//수신한 데이타를  공유메모리에 전송하기 위해 코디
//ADataMode: CM_DATA_READ, CM_CONFIG_READ, CM_DATA_WRITE, CM_CONFIG_WRITE
procedure TModbusComF.MakeDataRTU(ASlaveNo, ADataMode: integer);
var
  CRC16,RecvCRC: word;
  i, j, ByteCount: integer;
  pModbusBlock: TModbusBlock;
  EventData: TEventData_HIC;
  arydata: array[0..19] of char;
  pAryData: PChar;
  tmpstr, LStr: string;
begin
  RecvCRC := (FRecvByteBuf.Items[FRecvByteBuf.Size - 2] shl 8) and $FF00;
  //tmpCRC := (tmpCRC shl 8) and $FF00;
  RecvCRC := RecvCRC + FRecvByteBuf.Items[FRecvByteBuf.Size - 1];
  tmpstr := FRecvByteBuf.CopyToString(0, FRecvByteBuf.Size-2);
  //CRC16 := UpdateCRC16(0, FRecvByteBuf.FBuffer, FRecvByteBuf.Size - 2);

  CRC16 := CalcCRC16_2(tmpstr);

  //CRC가 정확한지 Check
  if RecvCRC = CRC16 then
  begin
    ByteCount := FRecvByteBuf.Items[2];

    with EventData do
    begin
      for i := 0 to ByteCount - 1 do
      begin
        //공유메모리에 값을 저장함
        //제어기 Register가 16bit이고 수신된 데이터는 8bit이므로 두개를 합침(2013.2.20)
        InpDataBuf[i] := (FRecvByteBuf.Items[MODBUS_DATA_RTU_START_HI_IDX + (i * 2)] shl 8) and $FF00;
        InpDataBuf[i] := InpDataBuf[i] + FRecvByteBuf.Items[MODBUS_DATA_RTU_START_HI_IDX + (i * 2)+1];
      end;//for

      //Flag := cfModBusCom;
      NumOfData := ByteCount;
      ModBusMode := Ord(RTU_MODE);
      DataMode := ADataMode;

      //Read Once(CurrentCommandIndex = -1) 일 경우에는 ModbusBlock이 없고 FWriteCommData에 있음
      if FCurrentCommandIndex = -1 then
      begin
        ModBusFunctionCode := FWriteCommData.ModBusFunctionCode;
        ModbusAddress := FWriteCommData.ModBusAddress;
        BlockNo := FWriteCommData.BlockNo;
        //NumOfBit := FWriteCommData.;
      end
      else
      begin
        if ASlaveNo = FSlaveNo then
          pModbusBlock := GetModBusBlock(FCurrentCommandIndex);

        ModBusFunctionCode := pModBusBlock.FFunctionCode;
        NumOfBit := pModBusBlock.FCount;

        if pModbusBlock <> nil then
        begin
          //수신한 데이타수와 요구한 데이타수가 다르면 exit(요구한 데이타 수에 두배함0)
          if (pModBusBlock.FFunctionCode = 1) or (pModBusBlock.FFunctionCode = 2) then
          begin
            j := (pModBusBlock.FCount div 8);
            if pModBusBlock.FCount mod 8 > 0 then
              Inc(j);
          end
          else
            j := pModBusBlock.FCount * 2;

          if ByteCount <> j then
          begin
            DisplayMessage(FRecvByteBuf.CopyToString(0, FRecvByteBuf.Size) +
                            ' ==> 수신한 데이타수 -> 요구한 데이타수가 다름 (' +
                            IntToHex(ByteCount,2) +' -> '+ IntToHex(pModBusBlock.FCount,2)+ ')',
                                                        False);
            exit;
          end;//if

          //pAryData := @aryData[0];
          //pAryData := StrPCopy(pAryData,pModBusBlock.FStartAddr);
          //StrCopy(@ModBusAddress[0], pAryData);//pModBusBlock.FStartAddr;
          ModbusAddress := pModBusBlock.FStartAddr;
          BlockNo := pModBusBlock.FBlockNo;
        end//if
        else
        begin
          DisplayMessage('ModBusBlock을 가져올 수 없음(' +
                          IntToStr(FCurrentCommandIndex) +')', False);
          exit;//startaddress를 가져오지 못하면 exit
        end;
      end;
    end;//with

    if FRecvByteBuf.Items[0] = FSlaveNo then
      FIPCClientAll.FIPCClient_HIC.PulseMonitor(EventData);

    //Write Registers의 경우 시간이 걸리기 때문에 다음 Query를 Signal Timeout 까지 지연시킴
    if EventData.ModBusFunctionCode <> 16 then
      FModBusComThread.FEventHandle.Signal;

    FRecvByteBuf.Clear;
    Lstr := '********'''+ FSharedMemName + '(' + CommMode2String(TCommMode(EventData.DataMode)) +')'', Send OK!'+#13#10;
    DisplayMessage(LStr, False);
//    DisplayMessage('********* 공유메모리에 데이타 전달함!!! **********'+#13#10, False);
  end
  else
  begin
    //CRC16 Packet Error
    DisplayMessage(''' ==> CRC Error (' + IntToHex(RecvCRC,2) +
                    ' -> '+ IntToHex(CRC16,2)+ ')''', False);
    FRecvByteBuf.Clear;
  end;

end;

procedure TModbusComF.MakeDataRTU4WriteFunc(ASlaveNo, ADataMode, AFuncNo,
  AByteCount: integer);
var
  CRC16,RecvCRC: word;
  i, j, ByteCount: integer;
  pModbusBlock: TModbusBlock;
  EventData: TEventData_HIC;
  arydata: array[0..19] of char;
  pAryData: PChar;
  tmpstr, LStr: string;
begin
  if AFuncNo = 16 then
  begin
    RecvCRC := (FRecvByteBuf.Items[6] shl 8) and $FF00;
    RecvCRC := RecvCRC + FRecvByteBuf.Items[7];
    tmpstr := FRecvByteBuf.CopyToString(0, 6);
  end;

  CRC16 := CalcCRC16_2(tmpstr);

  //CRC가 정확한지 Check
  if RecvCRC = CRC16 then
  begin
    ByteCount := AByteCount;

    with EventData do
    begin
      //for i := 0 to ByteCount - 1 do
      //begin
        //공유메모리에 값을 저장함
        //제어기 Register가 16bit이고 수신된 데이터는 8bit이므로 두개를 합침(2013.2.20)
        InpDataBuf[0] := (FRecvByteBuf.Items[4] shl 8) and $FF00;
        InpDataBuf[0] := InpDataBuf[i] + FRecvByteBuf.Items[5];
      //end;//for

      //Flag := cfModBusCom;
      NumOfData := ByteCount;
      ModBusMode := Ord(RTU_MODE);
      DataMode := ADataMode;

      //Read Once(CurrentCommandIndex = -1) 일 경우에는 ModbusBlock이 없고 FWriteCommData에 있음
      if AFuncNo = 16 then
      begin
        ModBusFunctionCode := FWriteCommData.ModBusFunctionCode;
        ModbusAddress := FWriteCommData.ModBusAddress;
        BlockNo := FWriteCommData.BlockNo;
        ErrorCode := 9999;
      end;

    end;//with

    FIPCClientAll.FIPCClient_HIC.PulseMonitor(EventData);
    Lstr := '********'''+ FSharedMemName + '(' + CommMode2String(TCommMode(EventData.DataMode)) +')'', Send OK!'+#13#10;
    DisplayMessage(LStr, False);

    //Write Registers의 경우 시간이 걸리기 때문에 다음 Query를 Signal Timeout 까지 지연시킴
    if EventData.ModBusFunctionCode <> 16 then
      FModBusComThread.FEventHandle.Signal
    else
    begin
      if FRecvByteBuf.Size > 8 then
        TruncByte(8)
      else
        FRecvByteBuf.Clear;
    end;
  end
  else
    //CRC16 Packet Error
    DisplayMessage(''' ==> CRC Error (' + IntToHex(RecvCRC,2) +
                    ' -> '+ IntToHex(CRC16,2)+ ')''', False);
end;

procedure TModbusComF.MakeDataTCP;
var
  i, j, FC, LCount, Llength, Lloop: integer;
  EventData: TEventData_HIC;
  Lstr: string;
  arydata: array[0..19] of char;
  pAryData: PChar;
  pModbusBlock: TModbusBlock;
begin
  pModbusBlock := GetModBusBlock(FCurrentCommandIndex);
  if pModbusBlock <> nil then
  begin

    FC := FRecvWordBuf[0]; //Function Code
    LCount := FRecvWordBuf[1];//Data Count;

    LStr := IntToStr(FC) + ',' + IntToStr(LCount);

    with EventData do
    begin
      if (FC = 1) or (FC = 2) then
      begin
        Llength := LCount div 16;

        if (LCount mod 16) > 0 then
          inc(Llength);
      end
      else if (FC = 3) or (FC = 4) then
        Llength := LCount;

      for i := 0 to Llength - 1 do
      begin
        if (FC = 1) or (FC = 2) then
        begin
          if LCount < 16 then
            Lloop := LCount
          else
            Lloop := 16;

          for j := 0 to Lloop - 1 do
          begin
            //공유메모리에 값을 저장함
            if FRecvBoolBuf[j] then
              InpDataBuf[i*8+j] := $FFFF
            else
              InpDataBuf[i*8+j] := $0000;

            LStr := LStr + ',' + IntToStr(InpDataBuf[i*8+j]);
          end;
        end
        else if (FC = 3) or (FC = 4) then
        begin
          //공유메모리에 값을 저장함
          InpDataBuf[i] := FRecvWordBuf[MODBUS_DATA_TCPWAGO_START_HI_IDX + i];
          LStr := LStr + ',' + IntToStr(FRecvWordBuf[MODBUS_DATA_TCPWAGO_START_HI_IDX + i]);
        end;
      end;//for

      //Flag := cfModBusCom;
      NumOfData := LCount;
      ModBusMode := Ord(MODBUSTCP_MODE);
      ModBusFunctionCode := FC;
      NumOfBit := LCount;
      ModBusAddress := pModBusBlock.FStartAddr;
      BlockNo := pModBusBlock.FBlockNo;//1부터 시작함
      //pAryData := @aryData[0];
      //pAryData := StrPCopy(pAryData,pModBusBlock.FStartAddr);
      //StrCopy(@ModBusAddress[0], pAryData);//pModBusBlock.FStartAddr;
    end;//with

    FIPCClientAll.FIPCClient_HIC.PulseMonitor(EventData);
    FModBusTCPThread.FEventHandle.Signal;
    FRecvByteBuf.Clear;
    DisplayMessage(LStr +#13#10, False);
    Lstr := '********'''+ FSharedMemName + ''', Send OK!(ModbusTCP : IP = ''' + FIPAddress;
    LStr := LStr + ''', Port = ' + IntToStr(FPortNum) + ')***'+#13#10;
    DisplayMessage(LStr, False);
  end//if
  else
  begin
    DisplayMessage('ModBusBlock을 가져올 수 없음(' +
                      IntToStr(FCurrentCommandIndex) +')', False);
  end;
end;

procedure TModbusComF.MakeDataTCPWago;
var
  i, j, FC, LCount, Llength, Lloop: integer;
  EventData: TEventData_HIC;
  Lstr: string;
  arydata: array[0..19] of char;
  pAryData: PChar;
  pModbusBlock: TModbusBlock;
begin
  pModbusBlock := GetModBusBlock(FCurrentCommandIndex);
  if pModbusBlock <> nil then
  begin

    FC := FRecvWordBuf[0]; //Function Code
    LCount := FRecvWordBuf[1];//Data Count;

    LStr := IntToStr(FC) + ',' + IntToStr(LCount);

    with EventData do
    begin
      if (FC = 1) or (FC = 2) then
      begin
        Llength := LCount div 16;

        if (LCount mod 16) > 0 then
          inc(Llength);
      end
      else if (FC = 3) or (FC = 4) then
        Llength := LCount;

      for i := 0 to Llength - 1 do
      begin
        if (FC = 1) or (FC = 2) then
        begin
          if LCount < 16 then
            Lloop := LCount
          else
            Lloop := 15;

          for j := 0 to Lloop do
          begin
            //공유메모리에 값을 저장함
            if IsBitSet(FRecvWordBuf[MODBUS_DATA_TCPWAGO_START_HI_IDX + i],j) then
              InpDataBuf[i*8+j] := $FFFF
            else
              InpDataBuf[i*8+j] := $0000;

            LStr := LStr + ',' + IntToStr(InpDataBuf[i*8+j]);
          end;
        end
        else if (FC = 3) or (FC = 4) then
        begin
          //공유메모리에 값을 저장함
          InpDataBuf[i] := FRecvWordBuf[MODBUS_DATA_TCPWAGO_START_HI_IDX + i];
          LStr := LStr + ',' + IntToStr(FRecvWordBuf[MODBUS_DATA_TCPWAGO_START_HI_IDX + i]);
        end;
      end;//for

      //Flag := cfModBusCom;
      NumOfData := LCount;
      ModBusMode := Ord(TCP_WAGO_MODE);
      ModBusFunctionCode := FC;
      NumOfBit := LCount;
      pAryData := @aryData[0];
      pAryData := StrPCopy(pAryData,pModBusBlock.FStartAddr);
      StrCopy(@ModBusAddress[0], pAryData);//pModBusBlock.FStartAddr;
    end;//with

    FIPCClientAll.FIPCClient_HIC.PulseMonitor(EventData);
    FModBusTCPWagoThread.FEventHandle.Signal;
    FRecvByteBuf.Clear;
    DisplayMessage(LStr +#13#10, False);
    Lstr := '********'''+ FSharedMemName + ''', Send OK!(ModbusTCP : IP = ''' + FIPAddress;
    LStr := LStr + ''', Port = ' + IntToStr(FPortNum) + ')***'+#13#10;
    DisplayMessage(LStr, False);
  end//if
  else
  begin
    DisplayMessage('ModBusBlock을 가져올 수 없음(' +
                      IntToStr(FCurrentCommandIndex) +')', False);
  end;
end;

function TModbusComF.MakeModbusTCP: Boolean;
begin
  Result := False;

  if FModBusMode = MODBUSTCP_MODE then
  begin
    if not Assigned(FModBusTCPThread) then
    begin
      FModBusTCPThread := TModBusTCPThread.Create(Self, FIPAddress, FPortNum, FQueryInterval);
      FModBusTCPThread.StopComm := True;
    end
    else
      FModBusTCPThread.InitComPort(FIPAddress, FPortNum, FModBusMode, FQueryInterval);

    Result := True;
  end;
end;

function TModbusComF.MakeModbusTCPWago: Boolean;
begin
  Result := False;

  if FModBusMode = TCP_WAGO_MODE then
  begin
    if not LoadDLL4TCPWago then
    begin
      ShowMessage('MBT.dll file load fail!');
      Result := False;
    end
    else
      Result := True;

    //FPortNum := 502;
    if not Assigned(FModBusTCPWagoThread) then
    begin
      FModBusTCPWagoThread := TModBusTCPWagoThread.Create(Self, FIPAddress, FPortNum, FQueryInterval);
      FModBusTCPWagoThread.StopComm := True;
    end
    else
      FModBusTCPWagoThread.InitComPort(FIPAddress, FPortNum, FModBusMode, FQueryInterval);
  end;
end;

procedure TModbusComF.Timer1Timer(Sender: TObject);
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
        //ReadMapAddress(FMapFileName,FModBusBlockList);
        ReadMapAddressFromParamFile(FParamFileName,FModBusBlockList);
        FIPCClientAll.FEngineParameter.Assign(FEngineParameter);
        FIPCClientAll.CreateIPCClientAll;
        if FIPCClientAll.FIPCClientList.Count > 0 then
          FSharedMemName := FIPCClientAll.FIPCClientList.Strings[0];
        MakeCommand;

        if ParamCount > 0 then
        begin
          LStr := UpperCase(ParamStr(1));
          if LStr = '/A' then  //Automatic Communication Start
          begin
            if (FModBusMode = MODBUSTCP_MODE) or (FModBusMode = TCP_WAGO_MODE) then
              Button1Click(nil)
            else
              SerialCommStart;
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

procedure TModbusComF.DisplayIPCClientList;
var
  i: integer;
begin
  for i := 0 to FIPCClientAll.FIPCClientList.Count - 1 do
    DisplayMessage(FIPCClientAll.FIPCClientList.Strings[i] + ' Created.',True);
end;

procedure TModbusComF.DisplayMessage(msg: string; IsSend: Boolean);
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

//ModBusBlock의 aIndex번째 자료를 반환함
//aIndex는 FSendCommandList의 현재 Index를 가리킴(0부터 시작함)
function TModbusComF.GetModBusBlock(aIndex: integer): TModBusBlock;
var it: DIterator;
    i: integer;
begin
  Result := nil;
  i := 0;
  it := FModBusBlockList.start;

  while not atEnd(it) do
  begin
    if i = aIndex then
    begin
      Result := GetObject(it) as TModbusBlock;
      exit;
    end;//if
    Advance(it);
    Inc(i);
  end;//while
end;

procedure TModbusComF.SetCurrentCommandIndex(aIndex: integer);
begin
  if FCurrentCommandIndex <> aIndex then
    FCurrentCommandIndex := aIndex;
end;

//IniFile -> Form
procedure TModbusComF.LoadConfigDataini2Form(ConfigForm:TModbusConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(FilePath+INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      ModbusModeRG.ItemIndex := ReadInteger(MODBUS_SECTION, 'Modbus Mode', 0);
      BaseAddrEdit.Text := ReadString(MODBUS_SECTION, 'Base Address','0000');
      SlaveNoEdit.Text := ReadString(MODBUS_SECTION, 'Slave No','1');
      QueryIntervalEdit.Text := ReadString(MODBUS_SECTION, 'Query Interval','0');
      ResponseWaitTimeOutEdit.Text := ReadString(MODBUS_SECTION, 'Response Wait Time Out','0');
      ParaFilenameEdit.FileName := ReadString(MODBUS_SECTION, 'Parameter File Name', '');
      EngParamEncryptCB.Checked := ReadBool(MODBUS_SECTION, 'Parameter Encrypt', False);
      ConfFileFormatRG.ItemIndex := ReadInteger(MODBUS_SECTION, 'Param File Format', 0);
      FilenameEdit.Filename := ReadString(MODBUS_SECTION, 'Modbus Map File Name', '.\ss197_Modbus_Map.txt');
      FilenameEdit2.Filename := ReadString(MODBUS_SECTION, 'Modbus Map File Name2', '.\GTI_Modbus_Map.txt');
      JvIPAddress1.Text := ReadString(MODBUS_SECTION, 'IP Address', '127.0.0.1');
      PortNumEdit.Text := ReadString(MODBUS_SECTION, 'Port Number', '502');
      SharedNameEdit.Text := ReadString(MODBUS_SECTION, 'Shared Name', IPCMONITORNAME);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TModbusComF.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
  LStr: string;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(FilePath+INIFILENAME);
  try
    with iniFile do
    begin
      ModBusMode := TModBusMode(ReadInteger(MODBUS_SECTION, 'Modbus Mode', 0));
      FBaseAddress := Str2Hex_Int(ReadString(MODBUS_SECTION, 'Base Address','0000'));
      FSlaveNo := ReadInteger(MODBUS_SECTION, 'Slave No', 1);
      FQueryInterval := ReadInteger(MODBUS_SECTION, 'Query Interval',0);
      if (ModbusMode = ASCII_MODE) or (ModbusMode = RTU_MODE) then
      begin
        if Assigned(FModBusComThread) then
          FModBusComThread.QueryInterval := FQueryInterval;
      end
      else if (ModbusMode = MODBUSTCP_MODE) then
      begin
        if Assigned(FModBusTCPThread) then
          FModBusTCPThread.QueryInterval := FQueryInterval;
      end
      else if (ModbusMode = TCP_WAGO_MODE) then
      begin
        if Assigned(FModBusTCPWagoThread) then
          FModBusTCPWagoThread.QueryInterval := FQueryInterval;
      end;

      FTimeOut := ReadInteger(MODBUS_SECTION, 'Response Wait Time Out',0);

      LStr := ReadString(MODBUS_SECTION, 'Parameter File Name', '');
      FConfigModified := False;
      if FParamFileName <> LStr then
      begin
        FParamFileName := LStr;
        FConfigModified := True;
      end;

      FEngParamEncrypt := ReadBool(MODBUS_SECTION, 'Parameter Encrypt', false);
      FEngParamFileFormat := ReadInteger(MODBUS_SECTION, 'Param File Format', 0);

      FMapFileName := ReadString(MODBUS_SECTION, 'Modbus Map File Name', '.\ss197_Modbus_Map.txt');
      FMapFileName2 := ReadString(MODBUS_SECTION, 'Modbus Map File Name2', '.\GTI_Modbus_Map.txt');
      FIPAddress := ReadString(MODBUS_SECTION, 'IP Address', '127.0.0.1');
      FPortNum := ReadInteger(MODBUS_SECTION, 'Port Number', 502);
      FSharedMemName2 := ReadString(MODBUS_SECTION, 'Shared Name', ParameterSource2SharedMN(psHIC) + 'Matrix');
    end;//with

    //FModBusComThread.FComport.LoadSettings(FStoreType,FilePath + INIFILENAME);
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try

end;

procedure TModbusComF.SaveConfigDataForm2ini(ConfigForm:TModbusConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(FilePath+INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      WriteInteger(MODBUS_SECTION, 'Modbus Mode', ModbusModeRG.ItemIndex);
      WriteString(MODBUS_SECTION, 'Base Address', BaseAddrEdit.Text);
      WriteString(MODBUS_SECTION, 'Slave No', SlaveNoEdit.Text);
      WriteString(MODBUS_SECTION, 'Query Interval',QueryIntervalEdit.Text);
      WriteString(MODBUS_SECTION, 'Response Wait Time Out', ResponseWaitTimeOutEdit.Text);
      WriteString(MODBUS_SECTION, 'Parameter File Name', ParaFilenameEdit.FileName);
      WriteBool(MODBUS_SECTION, 'Parameter Encrypt', EngParamEncryptCB.Checked);
      WriteInteger(MODBUS_SECTION, 'Param File Format', ConfFileFormatRG.ItemIndex);
      WriteString(MODBUS_SECTION, 'Modbus Map File Name', FilenameEdit.Filename);
      WriteString(MODBUS_SECTION, 'Modbus Map File Name2', FilenameEdit2.Filename);
      WriteString(MODBUS_SECTION, 'IP Address', JvIPAddress1.Text);
      WriteString(MODBUS_SECTION, 'Port Number', PortNumEdit.Text);
      WriteString(MODBUS_SECTION, 'Shared Name', SharedNameEdit.Text);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TModbusComF.SetConfigData;
var
  ConfigData: TModbusConfigF;
begin
  if Button1.Caption = 'Stop' then
    Button1Click(nil);

  ConfigData := nil;
  ConfigData := TModbusConfigF.Create(Self);
  try
    with ConfigData do
    begin
      SharedName2Combo(SharedNameEdit);
      LoadConfigDataini2Form(ConfigData);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(ConfigData);
        LoadConfigDataini2Var;
        ReadMapFile;

        if ModbusModeRG.ItemIndex = 2 then //TCP Wago Mode
        begin
          if not MakeModbusTCPWago then
            exit;
        end;

      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

function TModbusComF.LoadDLL4TCPWago: Boolean;
begin
  Result := False;

  if FMBTDLLHandle <> 0 then
  begin
    FreeLibrary(FMBTDLLHandle);
    FMBTDLLHandle := 0;
  end;
  
  FMBTDLLHandle := LoadLibrary('MBT.dll');

  if FMBTDLLHandle <> 0 then
  begin
    MBTInit := GetProcAddress(FMBTDLLHandle,'MBTInit');
    MBTExit := GetProcAddress(FMBTDLLHandle,'MBTExit');
    MBTConnect := GetProcAddress(FMBTDLLHandle,'MBTConnect');
    MBTDisconnect := GetProcAddress(FMBTDLLHandle,'MBTDisconnect');
    MBTReadRegisters := GetProcAddress(FMBTDLLHandle,'MBTReadRegisters');
    MBTReadCoils := GetProcAddress(FMBTDLLHandle,'MBTReadCoils');
    MBTReadExceptionStatus := GetProcAddress(FMBTDLLHandle,'MBTReadExceptionStatus');
    MBTWriteRegisters := GetProcAddress(FMBTDLLHandle,'MBTWriteRegisters');
    MBTWriteCoils := GetProcAddress(FMBTDLLHandle,'MBTWriteCoils');
    MBTSwapWord := GetProcAddress(FMBTDLLHandle,'MBTSwapWord');
    MBTSwapDWord := GetProcAddress(FMBTDLLHandle,'MBTSwapDWord');
    Result := True;
  end;
end;

procedure TModbusComF.N2Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TModbusComF.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TModbusComF.SerialCommStart;
begin
  if (FModBusMode = MODBUSTCP_MODE) or (FModBusMode = TCP_WAGO_MODE) then
  begin
    ShowMessage('Can only be Serial communication mode');
    exit;
  end;

  try
    InitComPort;
  except
    ShowMessage('Comm port Initialize fail!');
    exit;
  end;

  FModBusComThread.StopComm := not FModBusComThread.StopComm;

  if FModBusComThread.StopComm then
  begin
    if FComport.Connected then
      FComport.Close;

    Button1.Caption := 'Start';
  end
  else
  begin
    //통신포트를 오픈한다
    FComport.Open;
    Sleep(100);
    FComport.ClearBuffer(True,True);

    FModBusComThread.Resume;
    Button1.Caption := 'Stop';
  end;

  JvLED1.Status := FComport.Connected;
end;

procedure TModbusComF.SetConfigComm;
begin
{  FModBusComThread.FComPort.ShowSetupDialog;
  FModBusComThread.FComPort.StoreSettings(FStoreType,FilePath + INIFILENAME);
  FModBusComThread.InitComPort('',ModbusMode,1000);
}
  FComPort.ShowSetupDialog;
  FComPort.StoreSettings(FStoreType,FilePath + INIFILENAME);
  InitComPort;
end;

procedure TModbusComF.Switch1Click(Sender: TObject);
begin
  FModBusComThread.StopComm := not FModBusComThread.StopComm;

  if FModBusComThread.StopComm then
    //Button2.Caption := '통신시작'
  else
  begin
    FModBusComThread.Resume;
    ;//Button2.Caption := '통신중지';
  end;
end;

procedure TModbusComF.SetModBusMode(aMode: TModBusMode);
begin
  FModBusMode := aMode;

  if (FModBusMode = MODBUSTCP_MODE) or (FModBusMode = TCP_WAGO_MODE) then
  begin

  end
  else
  if (FModBusMode = ASCII_MODE) or (FModBusMode = RTU_MODE) then
  begin
    if FModBusMode <> aMode then
    begin
      FModBusComThread.FModBusMode := aMode;
    end;
  end;
end;

procedure TModbusComF.WMCopyData(var Msg: TMessage);
begin
  DisplayMessage(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg,
             Boolean(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle));
end;

procedure TModbusComF.TruncByte(AIndex: integer);
var
  TempByteBuf: TByteArray2;
begin
  TempByteBuf := TByteArray2.Create(0);
  try
    TempByteBuf.CopyByteArray(FRecvByteBuf, AIndex, FRecvByteBuf.Size - AIndex);
    FRecvByteBuf.Clear;
    FRecvByteBuf.CopyByteArray(TempByteBuf, 0, TempByteBuf.Size);
  finally
    TempByteBuf.Free;
    TempByteBuf := nil;
  end;//try
end;

procedure TModbusComF.UpdateTrace_WriteComm(var Msg: TConfigData_ModbusComm);
var
  iAddr, LNumOfData: integer;
  SendBuff, tmpstr: string;
  crc16: word;
  LSlaveNo: integer;
begin
  with FWriteCommData do
  begin
    if SlaveNo = 0 then
      LSlaveNo := FSlaveNo
    else
      LSlaveNo := SlaveNo;

    iAddr := Str2Hex_Int(ModBusAddress) - FBaseAddress - 1;//$5000;
    SendBuff := Format('%.2x%.2x%.2x%.2x',
                      [LSlaveNo, ModBusFunctionCode, hi(iAddr),lo(iAddr)]);
  end;//with

  //0: Repeat Read, 1: Only One read(config data), 2: Only One Write, 3: Only One Write for Confirm
  if (FWriteCommData.CommMode = 2) or (FWriteCommData.CommMode = 3) then
  begin
    case FWriteCommData.ParameterType of
      2: MakeCommand4ScalarValue(SendBuff);//ptAnalog
      4: MakeCommand4Write1(SendBuff);//ptMatrix1
      5: MakeCommand4Write2(SendBuff);//ptMatrix2
      6: MakeCommand4Write3(SendBuff);//ptMatrix3
      7: MakeCommand4Write4(SendBuff);//ptMatrix1f
      8: MakeCommand4Write5(SendBuff);//ptMatrix2f
      9: MakeCommand4Write6(SendBuff);//ptMatrix3f
    else
      ;
    end;
  end
  else
  begin
    LNumOfData := FWriteCommData.NumOfData;
    SendBuff := SendBuff + Format('%.2x%.2x', [hi(LNumOfData), lo(LNumOfData)]);
  end;

  if ModbusMode = RTU_MODE then
  begin
    tmpStr := SendBuff;
    crc16 := CalcCRC16_2(tmpStr);
    SendBuff := SendBuff + Format('%.4x', [crc16]);
  end;

  //FWriteCommData.CommMode = 0: Repeat Read, 1: Only One read, 2: Only One Write, 3: Only One Write for Confirm
  if FWriteCommData.CommMode = 1 then
  begin
    //FModBusComThread.FCommMode := CM_CONFIG_READ;
    FModBusComThread.FSendCommandOnce := SendBuff;
  end
  else
  begin
    //if (FWriteCommData.CommMode = 2) then
    //  FModBusComThread.FCommMode := CM_CONFIG_WRITE
    //else
    if (FWriteCommData.CommMode = 3) then
      FModBusComThread.FIsConfirmMode := True;
    //  FModBusComThread.FCommMode := CM_CONFIG_WRITE_CONFIRM;

    FModBusComThread.FWriteCommandList.Add(SendBuff);
  end;
end;

procedure TModbusComF.Button1Click(Sender: TObject);
begin
  if FModBusMode = MODBUSTCP_MODE then
  begin
    if not FModBusTCPThread.FConnected then
      if not MakeModbusTCP then
        exit;

    if not FModBusTCPThread.FConnected then
    begin
      ShowMessage('TCP 연결이 안됨. 통신상태 확인 후 다시 한번 시도하시오!');
      exit;
    end;

    FModBusTCPThread.StopComm := not FModBusTCPThread.StopComm;

    if FModBusTCPThread.StopComm then
      Button1.Caption := 'Start'
    else
    begin
      FModBusTCPThread.Resume;
      Button1.Caption := 'Stop';
    end;
  end
  else
  if FModBusMode = TCP_WAGO_MODE then
  begin
    if not FModBusTCPWagoThread.FConnected then
      if not MakeModbusTCPWago then
        exit;

    if not FModBusTCPWagoThread.FConnected then
    begin
      ShowMessage('TCP 연결이 안됨. 통신상태 확인 후 다시 한번 시도하시어!');
      exit;
    end;
    
    FModBusTCPWagoThread.StopComm := not FModBusTCPWagoThread.StopComm;

    if FModBusTCPWagoThread.StopComm then
      Button1.Caption := 'Start'
    else
    begin
      FModBusTCPWagoThread.Resume;
      Button1.Caption := 'Stop';
    end;
  end
  else
  begin
    SerialCommStart;

    {FModBusComThread.StopComm := not FModBusComThread.StopComm;

    if FModBusComThread.StopComm then
      Button1.Caption := 'Start'
    else
    begin
      FModBusComThread.Resume;
      Button1.Caption := 'Stop';
    end;  }
  end;
end;

end.

unit ScaleCom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, SyncObjs,
  Dialogs, CPort, DeCAL_Pjh, IPCThrd2, IPCThrdClient2, ModbusComConst, CommonUtil,
  StdCtrls, ComCtrls, ExtCtrls, DB, DBTables, Grids, DBGrids, iniFiles, ModbusComStruct,
  MyKernelObject, ModBusComThread, ModbusConfig, Menus, ByteArray,
  ALed, Switch, janSQL, janSQLStrings, CopyData, AppEvnts;

{Function Code
  1: HD
  2: DD
  3:
}
type
  TModbusComF = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
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
    ApplicationEvents1: TApplicationEvents;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WMReceiveString( var Message: TMessage ); message WM_RECEIVESTRING;
    procedure WMReceiveByte( var Message: TMessage ); message WM_RECEIVEBYTE;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WMInitComportError(var Msg: TMessage); message WM_INITCOMPORTERROR;
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Switch1Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
  private
    FFirst: Boolean;//맨처음에 실행될때 True 그 다음부터는 False
    FFilePath: string;      //파일을 저장할 경로
    FStoreType: TStoreType; //저장방식(ini or registry)
    FRecvStrBuf: String;        //스트링형 데이터 수신값이 저장됨
    FMapFileName: string;//Modbus map file name
    FMapFileName2: string;//Modbus map file name
    //FComPort: TComPort;     //통신 포트
    FAddressMap: DMap;      //Modus Map 데이타 저장 구초체
    FModBusBlockList: DList;//Modbus Block 통신용 Address 저장 구조체
    FModBusBlockList2: DList;//두번째 FModBusBlockList(두개를 Multidrop으로 묶음)
    FIPCClient: TIPCClient2;//공유 메모리 및 이벤트 객체
    FIPCClient2: TIPCClient2;//공유 메모리 및 이벤트 객체
    FModBusBlock: TModbusBlock;//sendquery용 주소가 들어감(cnt별로)

    FModBusMode: TModBusMode;//ASCII, RTU mode
    //FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event

    FModBusComThread: TModBusComThread; //Thread 통신 객체

    procedure SetCurrentCommandIndex(aIndex: integer);
    procedure SetModBusMode(aMode:TModBusMode);
  public
    FRecvByteBuf: TByteArray2;//헥사유형의 데이터 수신값이 저장됨
    FSendCommandList: TStringList;//Modbus 통신 명령 리스트
    //현재 Comport에 Write한 FSendCommandList의 Index(0부터 시작함)
    FCurrentCommandIndex: integer;
    //일정시간 이상 통신에 대한 반응이 없으면 제어기 다운으로 간주(Wait 시간 설정)
    FCommFail: Boolean;
    FCommFailCount: integer; //통신 반응이 없이 FQueryInterval이 경과한 횟수
    //Base Address, Slave number와 Function Code(환경설정으로 받음)
    FBaseAddress, FSlaveNo, FFunctionCode: integer;
    FBaseAddress2, FSlaveNo2, FFunctionCode2: integer;
    FCriticalSection: TCriticalSection;
    FjanDB : TjanSQL; //text 기반 SQL DB
    FErrCnt: integer; //LRC Error Log

    procedure InitVar;
    //세미콜론(;)으로 분리된 텍스트 화일을 ODBC를 거치지 않고 직접 접근함
    procedure ReadMapAddress(AMapFileName: string; AModBusBlockList:DList);
    procedure AddCommand2List(StartAddr: string; cnt, fcode: integer);
    procedure MakeCommand;

    procedure AddCommand2List2(StartAddr: string; cnt, fcode: integer);
    procedure MakeCommand2;
    function GetModBusBlock2(aIndex: integer): TModBusBlock;

    procedure MakeDataASCII(RecvData: string);
    procedure MakeDataRTU(ASlaveNo: integer);
    procedure DisplayMessage(msg: string; IsSend: Boolean);
    function GetModBusBlock(aIndex: integer): TModBusBlock;

    procedure LoadConfigDataini2Form(ConfigForm:TModbusConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TModbusConfigF);
    procedure SetConfigData;
    procedure SetConfigComm;

    procedure TruncByte(AIndex: integer);

  published
    property FilePath: string read FFilePath;
    property StoreType: TStoreType read FStoreType;
    property StrBuf: string read FRecvStrBuf write FRecvStrBuf;
    property CurrentCommandIndex: integer read FCurrentCommandIndex write SetCurrentCommandIndex;
    property ModBusMode: TModBusMode read FModBusMode write SetModBusMode;
  end;

var
  ModbusComF: TModbusComF;

implementation

{$R *.dfm}

procedure TModbusComF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TModbusComF.FormDestroy(Sender: TObject);
begin
  //FComport.Free;
  ObjFree(FAddressMap);
  FAddressMap.free;
  ObjFree(FModBusBlockList);
  FModBusBlockList.free;
  ObjFree(FModBusBlockList2);
  FModBusBlockList2.free;

  FIPCClient.Free;
  FIPCClient2.Free;
  FSendCommandList.Free;
  FRecvByteBuf.Free;
  FCriticalSection.Free;
  //FEventHandle.Free;
  if FModBusComThread.Suspended then
    FModBusComThread.Resume;

  FModBusComThread.Terminate;
  FModBusComThread.FEventHandle.Signal;

  FModBusComThread.Free;
end;

procedure TModbusComF.InitVar;
begin
  FFirst := True;
  FErrCnt := 0;
  FStoreType := stIniFile;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FAddressMap := DMap.Create;
  FModBusBlockList := DList.Create;
  FModBusBlockList2 := DList.Create;
  FIPCClient := TIPCClient2.Create(0, IPCCLIENTNAME1, True);
  FIPCClient2 := TIPCClient2.Create(0, IPCCLIENTNAME2, True);
  FSendCommandList := TStringList.Create;
  FRecvByteBuf := TByteArray2.Create(0);
  FCriticalSection := TCriticalSection.Create;
  FModBusComThread := TModBusComThread.Create(Self,1000);
  FModBusComThread.StopComm := True;
  LoadConfigDataini2Var;
end;

procedure TModbusComF.MakeCommand;
var pModbusBlock: TModbusBlock;
    it: DIterator;
    tmpstr: string;
begin
  FModBusComThread.FSendCommandList.Clear;
  FSendCommandList.Clear;

  if FModBusMode = ASCII_MODE then
    tmpstr := '(ASCII Mode)'
  else
    tmpstr := '(RTU Mode)';

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
  FModBusComThread.FSendCommandList.Assign(FSendCommandList);
end;

procedure TModbusComF.MakeCommand2;
var pModbusBlock: TModbusBlock;
    it: DIterator;
    tmpstr: string;
    i: integer;
begin
  FSendCommandList.Clear;

  it := FModBusBlockList2.start;

  while not atEnd(it) do
  begin
    pModbusBlock := GetObject(it) as TModbusBlock;

    AddCommand2List2(pModbusBlock.FStartAddr, pModbusBlock.FCount, pModbusBlock.FFunctionCode);
    Advance(it);
  end;//while
  DisplayMessage('===================================', True);

  for i := 0 to FSendCommandList.Count - 1 do
    FModBusComThread.FSendCommandList.Add(FSendCommandList.Strings[i]);
end;

procedure TModbusComF.ReadMapAddress(AMapFileName: string; AModBusBlockList:DList);
var
  sqltext: string;
  sqlresult, reccnt: integer;
  i: integer;
  filename: string;
begin
  if fileexists(AMapFileName) then
  begin
    AModBusBlockList.clear;
    Filename := ExtractFileName(AMapFileName);
    FileName := Copy(Filename,1, Pos('.',Filename) - 1);
    FjanDB :=TjanSQL.create;
    try
      sqltext := 'connect to ''' + FFilePath + '''';

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
                  filename := RecordSets[sqlresult].records[i].fields[3].value;
                  if UpperCase(Filename) = 'TRUE' then //Analog인경우
                    FFunctionCode := 01
                  else
                    FFunctionCode := 01;

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












//////////////////////////////////////////////////////////////명령어 만드는 부분

procedure TModbusComF.AddCommand2List(StartAddr: string; cnt, fcode: integer);
var
  SendBuff: string;
  tmpStr: string;
  iAddr: integer;
  lrc: Byte;
  crc16: word;
  SendLength: integer;
  AryByteBuf: array[0..255] of byte;
begin
//  iAddr := Str2Hex_Int(StartAddr) - FBaseAddress;//$5000;

//  SendBuff := Format('%.2x%.2x%.2x%.2x%.2x%.2x',
//                    [FSlaveNo,FCode,(iAddr shr 8) and $FF,iAddr and $FF,
//                        (cnt shr 8) and $FF,cnt and $FF]);
  if ModbusMode = ASCII_MODE then
  begin
    SendBuff := chr(01)+'HD'+chr(13)+chr(10);
//    SendBuff := ':' + SendBuff;
//    tmpStr := Copy(SendBuff,2,12);
//    lrc := Update_LRC(tmpStr, Length(tmpStr));
//    SendBuff := SendBuff + Format('%.2x',[lrc]) + #13#10;
  end
  else
  if ModbusMode = RTU_MODE then
  begin
//    tmpStr := SendBuff;
//    crc16 := CalcCRC16_2(tmpStr);
//    SendBuff := SendBuff + Format('%.4x', [crc16]);
  end;

  FSendCommandList.Add(SendBuff);
  DisplayMessage(SendBuff, True);
end;

procedure TModbusComF.AddCommand2List2(StartAddr: string; cnt, fcode: integer);
var
  SendBuff: string;
  tmpStr: string;
  iAddr: integer;
  lrc: Byte;
  crc16: word;
  SendLength: integer;
  AryByteBuf: array[0..255] of byte;
begin
  iAddr := Str2Hex_Int(StartAddr) - FBaseAddress2;//$5000;

  SendBuff := Format('%.2x%.2x%.2x%.2x%.2x%.2x',
                    [FSlaveNo2,Fcode,(iAddr shr 8) and $FF,iAddr and $FF,
                        (cnt shr 8) and $FF,cnt and $FF]);
  if ModbusMode = ASCII_MODE then
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

  FSendCommandList.Add(SendBuff);
  DisplayMessage(SendBuff, True);
end;













////////////////////////////////////////////데이터를 받아서 처리하는 부분(ASCII)

procedure TModbusComF.WMReceiveString(var Message: TMessage);
var
  TmpStr, TmpRecvStr: string;
  i, j, LengthStr: integer;
begin  //#$D#$A가 없으면 쓰레드에서 이 함수로 넘어오지 않음
  FCriticalSection.Enter;
  try

  LengthStr := Length(FRecvStrBuf);
  if LengthStr > 4 then //기본 packet의 byte count 이상 수신인지 확인
  begin
//    if FRecvStrBuf[1] <> ':' then //첫문자가 ':'이 아니면 Invalid format
//    begin
//      DisplayMessage(FRecvStrBuf+' ==> 첫문자가 ":"이 아님', False);
//      FRecvStrBuf := '';
//      exit;
//    end;
//
//   TmpStr := FRecvStrBuf[6] + FRecvStrBuf[7]; //Data부분 Byte Size
//    if TmpStr = '' then //Byte Count Field가 없으면 Dead Packet
//    begin
//      DisplayMessage(FRecvStrBuf+' ==> Byte Count Field가 없음(6,7번째)', False);
//      FRecvStrBuf := '';
//      exit;
//    end;
//
//    i := HexToInt(TmpStr) * 2; //ASCII Mode에서는 데이타 1개당 2Byte가 할당됨(?)
//    if LengthStr >= i + 9 then //header(7)+lrc(2byte)제외,  crlf(2byte)는 Length의 반환값에서 제외됨
//    begin
//      tmpStr := '';
//      j := 0;
      //두개 이상의 Response가 한꺼번에  수신된 경우 다음번 ':'은 저장하여 계속 처리함
//      j := NextPos2(':', FRecvStrBuf, 2);
//      if j > 0 then
//      begin
//        tmpStr := Copy(FRecvStrBuf, j - 1, Length(FRecvStrBuf) - j);
      FRecvStrBuf := Copy(FRecvStrBuf, 1, 8) + #13#10;
      if (FRecvStrBuf[1] = ' ') then
        begin
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
  i, SN, FC: integer;
  TempByteBuf: TByteArray2;
begin
  while true do
  begin
  //RTU Mode에서는 CRLF가 없음
  if FRecvByteBuf.Size > 5 then //기본 packet의 byte count 이상 수신인지 확인
  begin
    //첫데이타가 요청했던 Slave No가 아니면 Invalid format
    if (FRecvByteBuf.Items[0] <> FSlaveNo) and
                                      (FRecvByteBuf.Items[0] <> FSlaveNo2) then
    begin
      i := FRecvByteBuf.PosNext(FSlaveNo);
      if i > 0 then
      begin
        TruncByte(i);
        Continue;
      end;//if

      DisplayMessage(FRecvByteBuf.CopyToString(0,FRecvByteBuf.Size) + #13#10 +
                      ' ==> 첫 데이타가 유효한 Slave No가 아님('+
                      IntToStr(FSlaveNo)+','+IntToStr(FSlaveNo2)+')', False);
      FRecvByteBuf.Clear;
      exit;
    end;

    SN := FRecvByteBuf.Items[0];

    FC := FRecvByteBuf.Items[1];

    if FRecvByteBuf.Items[2] <= 0 then //데이타 Count <= 0
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
          //FRecvByteBuf.ByteArrayToStr()
          TempByteBuf := TByteArray2.Create(0);
          TempByteBuf.CopyByteArray(FRecvByteBuf, i, FRecvByteBuf.Size - i);
        end;
      end;

      DisplayMessage(FRecvByteBuf.CopyToString(0,FRecvByteBuf.Size), False);
      MakeDataRTU(SN);
      FRecvByteBuf.Clear;

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












//수신한 ModBus Data에서 LRC 및 데이타 건수를 검사 한 후 데이타값만 공유메모리에 전달함
procedure TModbusComF.MakeDataASCII(RecvData: string);
var
  pModbusBlock: TModbusBlock;
  EventData: TEventData2;
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
  if {Str2Hex_Byte(tmpstr) = lrc}1=1 then
  begin
    tmpstr := '';
    tmpstr := RecvData[1]+RecvData[2]+RecvData[3]+RecvData[4]+RecvData[5]+RecvData[6]+RecvData[7]+RecvData[8];//Byte Count 가져옴
    ByteCount := 1;//Str2Hex_Byte(tmpstr);

    pModbusBlock := GetModBusBlock(FCurrentCommandIndex);
    if pModbusBlock <> nil then
    begin
      with EventData do
      begin
        ModBusFunctionCode := pModBusBlock.FFunctionCode;
        if pModBusBlock.FFunctionCode = 1 then  //HD 인 경우
        begin
          //공유메모리에 값을 저장함
          InpDataBuf[1] := StrToInt(tmpstr);
        end
        else
        begin
        end;

        //Flag := cfModBusCom;
        NumOfData := ByteCount;
        //ModBusMode := Ord(ASCII_MODE);

        //pAryData := @aryData[0];
        //pAryData := StrPCopy(pAryData,pModBusBlock.FStartAddr);
        //StrCopy(@ModBusAddress[0], pAryData);//pModBusBlock.FStartAddr;
      end;//with
    end//if
    else
    begin
      DisplayMessage('ModBusBlock을 가져올 수 없음(' +
                        IntToStr(FCurrentCommandIndex) +')', False);
      exit;//startaddress를 가져오지 못하면 exit
    end;

    FIPCClient.PulseMonitor(EventData);
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
procedure TModbusComF.MakeDataRTU(ASlaveNo: integer);
var
  CRC16,RecvCRC: word;
  i, j, ByteCount: integer;
  pModbusBlock: TModbusBlock;
  EventData: TEventData2;
  arydata: array[0..19] of char;
  pAryData: PChar;
  tmpstr: string;
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
        InpDataBuf2[i] := FRecvByteBuf.Items[MODBUS_DATA_RTU_START_HI_IDX + i];
      end;//for

      Flag := cfModBusCom;
      NumOfData := ByteCount;
      ModBusMode := Ord(RTU_MODE);

      if ASlaveNo = FSlaveNo then
        pModbusBlock := GetModBusBlock(FCurrentCommandIndex)
      else
      if ASlaveNo = FSlaveNo2 then
        pModbusBlock := GetModBusBlock2(FCurrentCommandIndex - FModBusBlockList.Size);

      ModBusFunctionCode := pModBusBlock.FFunctionCode;
      NumOfBit := pModBusBlock.FCount;

      if pModbusBlock <> nil then
      begin
        //수신한 데이타수와 요구한 데이타수가 다르면 exit(요구한 데이타 수에 두배함0)
        if pModBusBlock.FFunctionCode = 1 then
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

        pAryData := @aryData[0];
        pAryData := StrPCopy(pAryData,pModBusBlock.FStartAddr);
        StrCopy(@ModBusAddress[0], pAryData);//pModBusBlock.FStartAddr;
      end//if
      else
      begin
        DisplayMessage('ModBusBlock을 가져올 수 없음(' +
                        IntToStr(FCurrentCommandIndex) +')', False);
        exit;//startaddress를 가져오지 못하면 exit
      end;
    end;//with

    if FRecvByteBuf.Items[0] = FSlaveNo then
      FIPCClient.PulseMonitor(EventData)
    else
    if FRecvByteBuf.Items[0] = FSlaveNo2 then
      FIPCClient2.PulseMonitor(EventData);

    FModBusComThread.FEventHandle.Signal;
    FRecvByteBuf.Clear;
    DisplayMessage('********* 공유메모리에 데이타 전달함!!! **********'+#13#10, False);
  end
  else
    //CRC16 Packet Error
    DisplayMessage(''' ==> CRC Error (' + IntToHex(RecvCRC,2) +
                    ' -> '+ IntToHex(CRC16,2)+ ')''', False);

end;
















procedure TModbusComF.Timer1Timer(Sender: TObject);
begin
  with Timer1 do
  begin
    Enabled := False;
    try
      SetCurrentDir(FilePath);

      if FFirst then
      begin
        if not FileExists(FMapFileName) then
        begin
          ShowMessage(FmapFilename + ' 파일이 존재하지 않습니다. 파일을 다시 지정하세요!!!');
          SetConfigData;
        end;

        FFirst := False;
        Interval := 500;
        ReadMapAddress(FMapFileName,FModBusBlockList);
        MakeCommand;
        ReadMapAddress(FMapFileName2,FModBusBlockList2);
        MakeCommand2;
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













procedure TModbusComF.DisplayMessage(msg: string; IsSend: Boolean);
begin
  if IsSend then
  begin
    if msg = ' ' then
    begin
//      TxLed.Value := True;
      exit;
    end
    else
//      TxLed.Value := False;
      
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
//      RxLed.Value := True;
      exit;
    end
    else
    if msg = 'RxFalse' then
    begin
//      RxLed.Value := False;
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
//FAddressMap에 수신 데이타의값을 저장할 때 사용됨
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


















function TModbusComF.GetModBusBlock2(aIndex: integer): TModBusBlock;
var it: DIterator;
    i: integer;
begin
  Result := nil;
  i := 0;
  it := FModBusBlockList2.start;

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

procedure TModbusComF.Button2Click(Sender: TObject);
begin
  MakeDataASCII('00007777#13#10');
end;

//IniFile -> Form
procedure TModbusComF.LoadConfigDataini2Form(ConfigForm:TModbusConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      ModbusModeRG.ItemIndex := ReadInteger(MODBUS_SECTION, 'Modbus Mode', 0);
      BaseAddrEdit.Text := ReadString(MODBUS_SECTION, 'Base Address','5000');
      BaseAddrEdit2.Text := ReadString(MODBUS_SECTION, 'Base Address2','5000');
      QueryIntervalEdit.Text := ReadString(MODBUS_SECTION, 'Query Interval','0');
      ResponseWaitTimeOutEdit.Text := ReadString(MODBUS_SECTION, 'Response Wait Time Out','0');
      SlaveNoEdit.Text := ReadString(MODBUS_SECTION, 'Slave Number','1');
      SlaveNoEdit2.Text := ReadString(MODBUS_SECTION, 'Slave Number2','2');
      FuncCodeEdit.Text := ReadString(MODBUS_SECTION, 'Function Code','3');
      FuncCodeEdit2.Text := ReadString(MODBUS_SECTION, 'Function Code2','3');
      FilenameEdit.Filename := ReadString(MODBUS_SECTION, 'Modbus Map File Name', '.\ss197_Modbus_Map.txt');
      FilenameEdit2.Filename := ReadString(MODBUS_SECTION, 'Modbus Map File Name2', '.\GTI_Modbus_Map.txt');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TModbusComF.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      ModBusMode := TModBusMode(ReadInteger(MODBUS_SECTION, 'Modbus Mode', 0));
      FBaseAddress := Str2Hex_Int(ReadString(MODBUS_SECTION, 'Base Address','5000'));
      FBaseAddress2 := Str2Hex_Int(ReadString(MODBUS_SECTION, 'Base Address2','5000'));
      FModBusComThread.QueryInterval :=
                              ReadInteger(MODBUS_SECTION, 'Query Interval',0);
      FModBusComThread.TimeOut :=
                      ReadInteger(MODBUS_SECTION, 'Response Wait Time Out',0);
      FSlaveNo := ReadInteger(MODBUS_SECTION, 'Slave Number',1);
      FSlaveNo2 := ReadInteger(MODBUS_SECTION, 'Slave Number2',2);
      FFunctionCode := ReadInteger(MODBUS_SECTION, 'Function Code',3);
      FFunctionCode2 := ReadInteger(MODBUS_SECTION, 'Function Code2',3);
      FMapFileName := ReadString(MODBUS_SECTION, 'Modbus Map File Name', '.\ss197_Modbus_Map.txt');
      FMapFileName2 := ReadString(MODBUS_SECTION, 'Modbus Map File Name2', '.\GTI_Modbus_Map.txt');
    end;//with

    FModBusComThread.FComport.LoadSettings(FStoreType,FilePath + INIFILENAME);
  finally
    if not FFirst then
    begin
      ReadMapAddress('.\ss197_Modbus_Map.txt',FModBusBlockList);
      MakeCommand;
      ReadMapAddress('.\GTI_Modbus_Map.txt',FModBusBlockList2);
      MakeCommand2;
    end;

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
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      WriteInteger(MODBUS_SECTION, 'Modbus Mode', ModbusModeRG.ItemIndex);
      WriteString(MODBUS_SECTION, 'Base Address', BaseAddrEdit.Text);
      WriteString(MODBUS_SECTION, 'Base Address2', BaseAddrEdit2.Text);
      WriteString(MODBUS_SECTION, 'Query Interval',QueryIntervalEdit.Text);
      WriteString(MODBUS_SECTION, 'Response Wait Time Out', ResponseWaitTimeOutEdit.Text);
      WriteString(MODBUS_SECTION, 'Slave Number',SlaveNoEdit.Text);
      WriteString(MODBUS_SECTION, 'Slave Number2',SlaveNoEdit2.Text);
      WriteString(MODBUS_SECTION, 'Function Code',FuncCodeEdit.Text);
      WriteString(MODBUS_SECTION, 'Function Code2',FuncCodeEdit2.Text);
      WriteString(MODBUS_SECTION, 'Modbus Map File Name', FilenameEdit.Filename);
      WriteString(MODBUS_SECTION, 'Modbus Map File Name2', FilenameEdit2.Filename);
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
  ConfigData := nil;
  ConfigData := TModbusConfigF.Create(Self);
  try
    with ConfigData do
    begin
      LoadConfigDataini2Form(ConfigData);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(ConfigData);
        LoadConfigDataini2Var;
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TModbusComF.N2Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TModbusComF.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TModbusComF.SetConfigComm;
begin
  FModBusComThread.FComPort.ShowSetupDialog;
  FModBusComThread.FComPort.StoreSettings(FStoreType,FilePath + INIFILENAME)
end;

procedure TModbusComF.Switch1Click(Sender: TObject);
begin
  FModBusComThread.StopComm := not FModBusComThread.StopComm;

  if FModBusComThread.StopComm then
    
    Button1.Caption := '통신시작    '
  else
  begin
    FModBusComThread.Resume;
    Button1.Caption := '통신중지    ';
  end;
end;











////////////////////////////////////////////모드버스 모드 세팅부분(ASCII or RTU)

procedure TModbusComF.SetModBusMode(aMode: TModBusMode);
begin
  if FModBusMode <> aMode then
  begin
    FModBusMode := aMode;
    FModBusComThread.FModBusMode := aMode;
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
















procedure TModbusComF.WMInitComportError(var Msg: TMessage);
begin
  ShowMessage( FModBusComThread.FComPort.Port + ' 포트를 열 수 없읍니다. 다른 포트를 선택하시오!!');
  //SetConfigComm;
  //FModBusComThread.InitComPort();
end;

procedure TModbusComF.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
;
end;

end.

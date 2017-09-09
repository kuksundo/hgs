unit ComPortThread;

interface

uses Windows, SysUtils, classes, Forms, SyncObjs, CPort_pjh, CPort, CPortTypes, MyKernelObject,
      CopyData, ByteArray, SFTConst;

Type
  TComPortThread = class(TThread)
    FOwner: TForm;
    FComPort: TComPort_pjh;     //통신 포트
    FComPortStream: TComStream;
    FQueryInterval: integer;//Query 간격(mSec)
    FStopComm: Boolean;//통신 일시 중지 = True
    FTimeOut: integer;//통신 Send후 다음 Send까지 대기하는 시간(mSec) - INFINITE
    //FSendBuf: array[0..255] of byte;//송신 버퍼
    FBufStr: String;//수신버퍼
    FReqByteCount: integer;//RTU Mode일때 Send시에 요구 바이트 수를 알아야 체크가능
    FRecvByteBuf: TByteArray2;
    FRecvFileBuf: TByteArray2;

    procedure OnReceiveChar(Sender: TObject; Count: Integer);
    procedure SetStopComm(Value: Boolean);
    procedure SetTimeOut(Value: integer);
    procedure SetQueryInterval(Value: integer);

  protected
    procedure Execute; override;

  public
    FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event
    FSendCommandList: TList;//통신 명령 리스트
    FRecvCommandList: TList;//통신 명령 리스트
    FSendFileName: String;//전송할 파일 리스트
    FSendString:string;//전송할 String(RTF...)
    FIsFileSend,
    FIsCommandSend: Boolean;
    FCurrentState: COMM_STATE;
    FFileSize: integer;
    FReceivedSize: integer;
    FFileIndex: integer;
    FReceiveFileName: string;
    FCriticalSection: TCriticalSection;
    FImageStream: TMemoryStream;
    FString: string;

    constructor Create(AOwner: TForm; QueryInterval: integer);
    destructor Destroy; override;
    procedure SendFile(AIndex: integer);
    procedure SendImage(AIndex: integer);
    procedure SendRTF(AIndex: integer);
    procedure ReceiveFile;
    procedure SendCommand;
    procedure ReceiveCommand;
    procedure SendCommandBufClear;
    procedure SendFileBufClear;
    procedure ProcessCommand;

    property CommPort: TComPort_pjh read FComPort write FComPort;
    property RecvByteBuf: TByteArray2 read FRecvByteBuf write FRecvByteBuf;
    property StopComm: Boolean read FStopComm write SetStopComm;
    property TimeOut: integer read FTimeOut write SetTimeOut;
    property QueryInterval: integer read FQueryInterval write SetQueryInterval;
  end;

implementation

uses CommonUtil, SFTStruct;

{ TComPortThread }

constructor TComPortThread.Create(AOwner: TForm; QueryInterval: integer);
begin
  inherited Create(True);

  FreeOnTerminate := True;
  FOwner := AOwner;
  FStopComm := False;
  FEventHandle := TEvent.Create('',False);
  FCriticalSection := TCriticalSection.Create;
  FTimeOut := INFINITE; //3초 기다린 후에 계속 명령을 전송함(Default = INFINITE)
  FBufStr := '';
  FFileSize := 1056381;
  Resume;
end;

destructor TComPortThread.Destroy;
begin
  //FComport.Free;
  FEventHandle.Free;
  //FSendCommandList.Free;
  FCriticalSection.Free;
  inherited;
end;

procedure TComPortThread.Execute;
begin
  while not terminated do
  begin
    if FStopComm then
      Suspend;

    Sleep(FQueryInterval);

    ProcessCommand;
    //if FIsFileSend then
    //  SendFile;
 end;//while
end;

procedure TComPortThread.OnReceiveChar(Sender: TObject; Count: Integer);
var
  TmpBufStr: String;
  BufByte: Array[0..65535] of Byte;
  LPBuffer: PTransferRecord;
  LProgress: integer;
begin
  FCriticalSection.Enter;

  try
    SendCopyData2(FOwner.Handle, 'RxTrue', 0);

    //버퍼 초기화
    //FillChar(BufByte, SizeOf(BufByte),0);
    LPBuffer := @BufByte[0];

    //버퍼에 헥사값을 수신함
    FComPort.Read(PAnsiChar(LPBuffer), Count);

    if (FCurrentState = csFileRecv) or (FCurrentState = csImageRecv)
      or (FCurrentState = csRTFRecv) then
    begin
      FRecvFileBuf.AppendByteArray(BufByte, Count);

      if FRecvFileBuf.Size <= FFileSize then
        LProgress := FRecvFileBuf.Size;

      FReceivedSize := FRecvFileBuf.Size;
      SendMessage(FOwner.Handle, WM_FILERECV_PROGRESS, LProgress, 0);

      if FRecvFileBuf.Size >= (FFileSize{ + Sizeof(TransferRecord)}) then
      begin
        SendCopyData2(FOwner.Handle, IntToStr(FRecvFileBuf.Size {- Sizeof(TransferRecord)})+ ' Bytes received.', 0);
        if (FCurrentState = csImageRecv) then
          SendMessage(FOwner.Handle, WM_IMAGERECV_COMPLETE, 0, 0)
        else
        if (FCurrentState = csRTFRecv) then
          SendMessage(FOwner.Handle, WM_RTFRECV_COMPLETE, 0, 0)
        else
          SendMessage(FOwner.Handle, WM_FILERECV_COMPLETE, 0, 0);
      end;
    end
    else
    begin
      FRecvByteBuf.AppendByteArray(BufByte, Count);

      //요청한 수량만큼 버퍼에 차면 Main 폼에 메세지 전송
      if FRecvByteBuf.Size >= Sizeof(TransferRecord) then
      begin
        SendMessage(FOwner.Handle, WM_RECEIVEBYTE, 0, 0);
      end;
    end;
  finally
    SendCopyData2(FOwner.Handle, 'RxFalse', 0);
    FCriticalSection.Leave;
  end;
end;

procedure TComPortThread.ProcessCommand;
begin
  if FIsFileSend then
  begin
    FIsFileSend := False;
    if FSendFileName = IMAGEFILE then
      SendImage(FFileIndex)
    else
    if FSendFileName = RTFFILE then
      SendRTF(FFileIndex)
    else
      SendFile(FFileIndex);
  end
  else
  if FIsCommandSend then
  begin
     FIsCommandSend := False;
   SendCommand;
  end;
end;

procedure TComPortThread.ReceiveCommand;
begin

end;

procedure TComPortThread.ReceiveFile;
begin
;
end;

procedure TComPortThread.SendCommandBufClear;
var
  LRecord: PTransferRecord;
  Li: integer;
begin
  for Li := FSendCommandList.Count - 1 downto 0 do
  begin
    LRecord := FSendCommandList.Items[Li];
    Dispose(LRecord);
    LRecord := nil;

    FSendCommandList.Delete(Li);
  end;
end;

procedure TComPortThread.SendCommand;
var
  i, SendLength: integer;
begin
  if StopComm then
    exit;

  for i := 0 to FSendCommandList.Count - 1 do
  begin
    if StopComm then
      exit;

    FComPort.Write(FSendCommandList.Items[i], SizeOf(TransferRecord));

{    if FEventHandle.Wait(FTimeOut) then
    begin
      if terminated then
        exit;
    end
    else
      Continue;

    Sleep(FQueryInterval);
}
  end;//for

  SendCommandBufClear;
end;

procedure TComPortThread.SendFile(AIndex: integer);
var
  i, j, SendLength: integer;
  tmpStr: string;
  LPBuffer: PAnsiChar;
  LSendBuf, LTempBuf: TByteArray2;
  LProgress: integer;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if StopComm then
    exit;

  SendCopyData2(FOwner.Handle, ''''+FSendFileName+''' File Sending...', 0);
  LSendBuf := TByteArray2.Create(0);
  //LTempBuf := TByteArray2.Create(0);

  try
    LSendBuf.LoadFromFile(FSendFileName);
    FFileSize := LSendBuf.Size;
    //LSendBuf.AppendByteArray(LTempBuf.FBuffer,LTempBuf.Size);

    if LSendBuf.Size > MAX_SEND_SIZE then
      SendLength := MAX_SEND_SIZE
    else
      SendLength := LSendBuf.Size;

    j := FFileIndex;

    while true do
    begin
      if j >= LSendBuf.Size then
        break;

      if (LSendBuf.Size - j) <= MAX_SEND_SIZE then
      begin
        SendLength := LSendBuf.Size - j;
      end;

      LPBuffer := LSendBuf.CStrFrom[j];
      SendLength := FComport.Write(LPBuffer,SendLength);
      Sleep(100);

      j := j + SendLength;

      if j <= LSendBuf.Size then
        LProgress := j;

      SendMessage(FOwner.Handle, WM_FILESEND_PROGRESS, LProgress, 0);
    end; //while

    //FComport.Write(LSendBuf.CStrFrom[0],LSendBuf.Size);
    FComport.FlushComm;
    SendCopyData2(FOwner.Handle, 'File Send finished. ('+IntToStr(FFileSize)+' Bytes)', 0);
    SendMessage(FOwner.Handle, WM_FILESEND_COMPLETE, 0, 0);

  finally
    FComport.ClearBuffer(True,True);
    SendFileBufClear;
    LSendBuf.Free;
    //LTempBuf.Free;
  end;
end;

procedure TComPortThread.SendFileBufClear;
begin
  //FSendFileList.Clear;
end;

procedure TComPortThread.SendImage(AIndex: integer);
var
  j,SendLength: integer;
  LPBuffer: PAnsiChar;
  LSendBuf: TByteArray2;
  LProgress: integer;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if StopComm then
    exit;

  if FImageStream.Size = 0 then
  begin
    SendCopyData2(FOwner.Handle, ''''+FSendFileName+''' Image Size must be greater than 0!', 0);
    exit;
  end;

  SendCopyData2(FOwner.Handle, ''''+FSendFileName+''' Image Sending...', 0);

  try
    //SendLength := FComPortStream.CopyFrom(FImageStream,FImageStream.Size);
    LSendBuf := TByteArray2.Create(0);
    FImageStream.Seek(0, soFromBeginning);
    LSendBuf.LoadFromStream(FImageStream,FImageStream.Size);
    FFileSize := LSendBuf.Size;

    if LSendBuf.Size > MAX_SEND_SIZE then
      SendLength := MAX_SEND_SIZE
    else
      SendLength := LSendBuf.Size;

    j := FFileIndex;

    while true do
    begin
      if j >= LSendBuf.Size then
        break;

      if (LSendBuf.Size - j) <= MAX_SEND_SIZE then
        SendLength := LSendBuf.Size - j;

      LPBuffer := LSendBuf.CStrFrom[j];

      SendLength := FComport.Write(LPBuffer,SendLength);
      Sleep(100);

      j := j + SendLength;

      if j <= LSendBuf.Size then
        LProgress := j;

      SendMessage(FOwner.Handle, WM_FILESEND_PROGRESS, LProgress, 0);
    end; //while

    SendCopyData2(FOwner.Handle, 'Image Send finished. ('+IntToStr(SendLength)+' Bytes)', 0);
    SendMessage(FOwner.Handle, WM_IMAGESEND_COMPLETE, 0, 0);

  finally
    SendFileBufClear;
    LSendBuf.Free;
  end;
end;

procedure TComPortThread.SendRTF(AIndex: integer);
var
  j,SendLength: integer;
  LPBuffer: PAnsiChar;
  LSendBuf: TByteArray2;
  LProgress: integer;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if StopComm then
    exit;

  if Length(FSendString) = 0 then
  begin
    SendCopyData2(FOwner.Handle, ''''+FSendFileName+''' String Size must be greater than 0!', 0);
    exit;
  end;

  SendCopyData2(FOwner.Handle, ''''+FSendFileName+''' String Sending...', 0);

  try
    SendLength := FComport.Write(@FSendString[1], Length(FSendString)*Sizeof(FSendstring[1]));

    SendCopyData2(FOwner.Handle, 'String Send finished. ('+IntToStr(SendLength)+' Bytes)', 0);
    SendMessage(FOwner.Handle, WM_RTFSEND_COMPLETE, 0, 0);

  finally

  end;
end;

procedure TComPortThread.SetQueryInterval(Value: integer);
begin
  if FQueryInterval <> Value then
    FQueryInterval := Value;
end;

procedure TComPortThread.SetStopComm(Value: Boolean);
begin
  if FStopComm <> Value then
  begin
    FStopComm := Value;

    if FStopComm then
      //Suspend
    else
      if Suspended then
        Resume;
  end;
end;

procedure TComPortThread.SetTimeOut(Value: integer);
begin
  if FTimeOut <> Value then
    FTimeOUt := Value;
end;

end.

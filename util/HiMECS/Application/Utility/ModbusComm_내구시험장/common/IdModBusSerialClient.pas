{$I ModBusCompiler.inc}

unit IdModBusSerialClient;

interface

Uses IdModBusClient, ModbusTypes, ModbusConsts, ModBusSerialTypes, CommonUtil,
  IdGlobal, IdTCPConnection, ModbusUtils, System.SysUtils;

type
  TModBusSerialClientErrorEvent = procedure(const FunctionCode: Byte;
    const ErrorCode: Byte; const ResponseBuffer: TModBusSerialResponseBuffer) of object;
  TModBusSerialClientResponseMismatchEvent = procedure(const RequestFunctionCode: Byte;
    const ResponseFunctionCode: Byte; const ResponseBuffer: TModBusSerialResponseBuffer) of object;

  TIdModBusSerialClient = Class(TIdModBusClient)
  private
    FOnSerialResponseError: TModbusSerialClientErrorEvent;
    FOnSerialResponseMismatch: TModBusSerialClientResponseMismatchEvent;
  Protected
    procedure DoSerialResponseError(const FunctionCode: Byte; const ErrorCode: Byte;
      const ResponseBuffer: TModBusSerialResponseBuffer);
    procedure DoSerialResponseMismatch(const RequestFunctionCode: Byte; const ResponseFunctionCode: Byte;
      const ResponseBuffer: TModBusSerialResponseBuffer);
    function SendCommand_Serial(const AModBusFunction: TModBusFunction;
      const ARegNumber: Word; const ABlockLength: Word; var Data: array of Word): Boolean;
  public
    FCRC: word;
    FSlaveNumber: word;

    function ReadCoils_Serial(const RegNo: Word; const Blocks: Word; out RegisterData: array of Boolean): Boolean;
    function ReadInputBits_Serial(const RegNo: Word; const Blocks: Word; out RegisterData: array of Boolean): Boolean;
    function ReadHoldingRegisters_Serial(const RegNo: Word; const Blocks: Word; out RegisterData: array of Word): Boolean;
    function ReadInputRegisters_Serial(const RegNo: Word; const Blocks: Word; var RegisterData: array of Word): Boolean;
    function WriteRegisters_Serial(const RegNo: Word; const RegisterData: array of Word): Boolean;
  End;

implementation

uses ByteArray;

{ TIdModBusSerialClient }

procedure TIdModBusSerialClient.DoSerialResponseError(const FunctionCode,
  ErrorCode: Byte; const ResponseBuffer: TModBusSerialResponseBuffer);
begin
  if Assigned(FOnSerialResponseError) then
    FOnSerialResponseError(FunctionCode, ErrorCode, ResponseBuffer);
end;

procedure TIdModBusSerialClient.DoSerialResponseMismatch(
  const RequestFunctionCode, ResponseFunctionCode: Byte;
  const ResponseBuffer: TModBusSerialResponseBuffer);
begin
  if Assigned(FOnSerialResponseMismatch) then
    FOnSerialResponseMismatch(RequestFunctionCode, ResponseFunctionCode, ResponseBuffer);
end;

function TIdModBusSerialClient.ReadCoils_Serial(const RegNo, Blocks: Word;
  out RegisterData: array of Boolean): Boolean;
var
  i: Integer;
  Data: array of Word;
  bNewConnection: Boolean;
begin
  bNewConnection := False;
  if AutoConnect and not Connected then
  begin
  {$IFDEF DMB_INDY10}
    Connect;
  {$ELSE}
    Connect(FConnectTimeOut);
  {$ENDIF}
    bNewConnection := True;
  end;

  SetLength(Data, Blocks);
  FillChar(Data[0], Length(Data), 0);
  try
    Result := SendCommand_Serial(mbfReadCoils, RegNo, Blocks, Data);
    for i := 0 to (Blocks - 1) do
      RegisterData[i] := (Data[i] = 1);
  finally
    if bNewConnection then
      DisConnect;
  end;
end;

function TIdModBusSerialClient.ReadHoldingRegisters_Serial(const RegNo,
  Blocks: Word; out RegisterData: array of Word): Boolean;
var
  i: Integer;
  Data: array of Word;
  bNewConnection: Boolean;
begin
  bNewConnection := False;

  if AutoConnect and not Connected then
  begin
  {$IFDEF DMB_INDY10}
    Connect;
  {$ELSE}
    Connect(FConnectTimeOut);
  {$ENDIF}
    bNewConnection := True;
  end;

  try
    SetLength(Data, Blocks);
    FillChar(Data[0], Length(Data), 0);
    Result := SendCommand_Serial(mbfReadHoldingRegs, RegNo, Blocks, Data);

    for i := Low(Data) to High(Data) do
      RegisterData[i] := Data[i];
  finally
    if bNewConnection then
      DisConnect;
  end;
end;

function TIdModBusSerialClient.ReadInputBits_Serial(const RegNo, Blocks: Word;
  out RegisterData: array of Boolean): Boolean;
var
  i: Integer;
  Data: array of Word;
  bNewConnection: Boolean;
begin
  bNewConnection := False;
  if AutoConnect and not Connected then
  begin
  {$IFDEF DMB_INDY10}
    Connect;
  {$ELSE}
    Connect(FConnectTimeOut);
  {$ENDIF}
    bNewConnection := True;
  end;

  SetLength(Data, Blocks);
  FillChar(Data[0], Length(Data), 0);
  try
    Result := SendCommand_Serial(mbfReadInputBits, RegNo, Blocks, Data);
    for i := 0 to (Blocks - 1) do
      RegisterData[i] := (Data[i] = 1);
  finally
    if bNewConnection then
      DisConnect;
  end;
end;

function TIdModBusSerialClient.ReadInputRegisters_Serial(const RegNo,
  Blocks: Word; var RegisterData: array of Word): Boolean;
var
  bNewConnection: Boolean;
begin
  bNewConnection := False;
  if AutoConnect and not Connected then
  begin
  {$IFDEF DMB_INDY10}
    Connect;
  {$ELSE}
    Connect(FConnectTimeOut);
  {$ENDIF}
    bNewConnection := True;
  end;

  FillChar(RegisterData[0], Length(RegisterData), 0);
  try
    Result := SendCommand_Serial(mbfReadInputRegs, RegNo, Blocks, RegisterData);
  finally
    if bNewConnection then
      DisConnect;
  end;
end;

function TIdModBusSerialClient.SendCommand_Serial(
  const AModBusFunction: TModBusFunction; const ARegNumber, ABlockLength: Word;
  var Data: array of Word): Boolean;
var
  SendBuffer: TModBusSerialRequestBuffer;
  ReceiveBuffer: TModBusSerialResponseBuffer;
  BlockLength: Word;
  RegNumber: Word;
  dtTimeOut: TDateTime;
  LRecordLength: word;
  LCRC: word;
  LByteArray: TByteArray2;
  LDataAnsiStr: Ansistring;
{$IFDEF DMB_INDY10}
  Buffer: TIdBytes;
  RecBuffer: TIdBytes;
  iSize: Integer;
{$ENDIF}
begin
{$IFDEF DMB_INDY10}
  CheckForGracefulDisconnect(True);
{$ELSE}
  CheckForDisconnect(True, True);
{$ENDIF}

  try
    LByteArray := TByteArray2.Create;
  { Initialise data related variables }
    RegNumber := ARegNumber - BaseRegister;
  { Perform function code specific operations }
    SendBuffer.SlaveNumber := FSlaveNumber;
    LByteArray.Append(SendBuffer.SlaveNumber);

    case AModBusFunction of
      mbfReadCoils,
      mbfReadInputBits:
        begin
          BlockLength := ABlockLength;
        { Don't exceed max length }
          if (BlockLength > 250) then
            BlockLength := 250;
        { Initialise the data part }
          SendBuffer.FunctionCode := Byte(AModBusFunction); { Write appropriate function code }
          SendBuffer.MBPData[0] := Hi(RegNumber);
          SendBuffer.MBPData[1] := Lo(RegNumber);
          SendBuffer.MBPData[2] := Hi(BlockLength);
          SendBuffer.MBPData[3] := Lo(BlockLength);
          LByteArray.Append(SendBuffer.FunctionCode);
          LByteArray.AppendByteArray(SendBuffer.MBPData,4);
          LDataAnsiStr := LByteArray.CopyToString(0, 6);
          LCRC := CalcCRC16_2(String(LDataAnsiStr));
          FCRC := LCRC;
          SendBuffer.MBPData[4] := Hi(LCRC);
          SendBuffer.MBPData[5] := Lo(LCRC);
          LRecordLength := 8;
        end;
      mbfReadHoldingRegs,
      mbfReadInputRegs:
        begin
          BlockLength := ABlockLength;
          if (BlockLength > 125) then
            BlockLength := 125; { Don't exceed max length }
        { Initialise the data part }
          SendBuffer.FunctionCode := Byte(AModBusFunction); { Write appropriate function code }
          SendBuffer.MBPData[0] := Hi(RegNumber);
          SendBuffer.MBPData[1] := Lo(RegNumber);
          SendBuffer.MBPData[2] := Hi(BlockLength);
          SendBuffer.MBPData[3] := Lo(BlockLength);
          LByteArray.Append(SendBuffer.FunctionCode);
          LByteArray.AppendByteArray(SendBuffer.MBPData,4);
//          FTemp := Length(LByteArray.FBuffer);
          LDataAnsiStr := LByteArray.CopyToString(0, 6);
          LCRC := CalcCRC16_2(String(LDataAnsiStr));
          FCRC := LCRC;
          SendBuffer.MBPData[4] := Hi(LCRC);
          SendBuffer.MBPData[5] := Lo(LCRC);
          LRecordLength := 8;
        end;
      mbfWriteOneCoil:
        begin
        { Initialise the data part }
          SendBuffer.FunctionCode := Byte(AModBusFunction); { Write appropriate function code }
          SendBuffer.MBPData[0] := Hi(RegNumber);
          SendBuffer.MBPData[1] := Lo(RegNumber);
          if (Data[0] <> 0) then
            SendBuffer.MBPData[2] := 255
          else
            SendBuffer.MBPData[2] := 0;
          SendBuffer.MBPData[3] := 0;

          LByteArray.Append(SendBuffer.FunctionCode);
          LByteArray.AppendByteArray(SendBuffer.MBPData,4);
          LDataAnsiStr := LByteArray.CopyToString(0, 6);
          LCRC := CalcCRC16_2(String(LDataAnsiStr));
          FCRC := LCRC;
          SendBuffer.MBPData[4] := Hi(LCRC);
          SendBuffer.MBPData[5] := Lo(LCRC);
          LRecordLength := 8;
        end;
      mbfWriteOneReg:
        begin
        { Initialise the data part }
          SendBuffer.FunctionCode := Byte(AModBusFunction); { Write appropriate function code }
          SendBuffer.MBPData[0] := Hi(RegNumber);
          SendBuffer.MBPData[1] := Lo(RegNumber);
          SendBuffer.MBPData[2] := Hi(Data[0]);
          SendBuffer.MBPData[3] := Lo(Data[0]);
          LByteArray.Append(SendBuffer.FunctionCode);
          LByteArray.AppendByteArray(SendBuffer.MBPData,4);
          LDataAnsiStr := LByteArray.CopyToString(0, 6);
          LCRC := CalcCRC16_2(String(LDataAnsiStr));
          FCRC := LCRC;
          SendBuffer.MBPData[4] := Hi(LCRC);
          SendBuffer.MBPData[5] := Lo(LCRC);
          LRecordLength := 8;
        end;
      mbfWriteCoils:
        begin
          BlockLength := ABlockLength;
        { Don't exceed max length }
          if (BlockLength > 250) then
            BlockLength := 250;
        { Initialise the data part }
          SendBuffer.FunctionCode := Byte(AModBusFunction); { Write appropriate function code }
          SendBuffer.MBPData[0] := Hi(RegNumber);
          SendBuffer.MBPData[1] := Lo(RegNumber);
          SendBuffer.MBPData[2] := Hi(BlockLength);
          SendBuffer.MBPData[3] := Lo(BlockLength);
          SendBuffer.MBPData[4] := Byte((BlockLength + 7) div 8);
          PutCoilsIntoBuffer(@SendBuffer.MBPData[5], BlockLength, Data);

          LByteArray.Append(SendBuffer.FunctionCode);
          LByteArray.AppendByteArray(SendBuffer.MBPData,4);
          LDataAnsiStr := LByteArray.CopyToString(0, 6);
          LCRC := CalcCRC16_2(String(LDataAnsiStr));
          FCRC := LCRC;
          SendBuffer.MBPData[SendBuffer.MBPData[4] + 5] := Hi(LCRC);
          SendBuffer.MBPData[SendBuffer.MBPData[4] + 6] := Lo(LCRC);

          LRecordLength := Swap16(7 + SendBuffer.MBPData[4]) + 2;//2=CRC byte count
        end;
      mbfWriteRegs:
        begin
          BlockLength := ABlockLength;
        { Don't exceed max length }
          if (BlockLength > 250) then
            BlockLength := 250;
        { Initialise the data part }
          SendBuffer.FunctionCode := Byte(AModBusFunction); { Write appropriate function code }
          SendBuffer.MBPData[0] := Hi(RegNumber);
          SendBuffer.MBPData[1] := Lo(RegNumber);
          SendBuffer.MBPData[2] := Hi(BlockLength);
          SendBuffer.MBPData[3] := Lo(BlockLength);
          SendBuffer.MbpData[4] := Byte(BlockLength shl 1);
          PutRegistersIntoBuffer(@SendBuffer.MBPData[5], BlockLength, Data);
          LByteArray.Append(SendBuffer.FunctionCode);
          LByteArray.AppendByteArray(SendBuffer.MBPData,4);
          LDataAnsiStr := LByteArray.CopyToString(0, 6);
          LCRC := CalcCRC16_2(String(LDataAnsiStr));
          FCRC := LCRC;
          SendBuffer.MBPData[SendBuffer.MBPData[4] + 5] := Hi(LCRC);
          SendBuffer.MBPData[SendBuffer.MBPData[4] + 6] := Lo(LCRC);
          LRecordLength := Swap16(7 + SendBuffer.MbpData[4] + 2);//2=CRC byte count
        end;
    end;
  finally
    LByteArray.Free;
  end;
{ Writeout the data to the connection }
{$IFDEF DMB_INDY10}
  Buffer := RawToBytes(SendBuffer, Swap16(LRecordLength));
  IOHandler.WriteDirect(Buffer, LRecordLength); //ModbusTCP 와 다른점: LRecordLength 를 꼭 해줘야 함
{$ELSE}
  WriteBuffer(SendBuffer, Swap16(LRecordLength);
{$ENDIF}

{*** Wait for data from the PLC ***}
  if (TimeOut > 0) then
  begin
    dtTimeOut := Now + (TimeOut / 86400000);
  {$IFDEF DMB_INDY10}
    while (IOHandler.InputBuffer.Size < BlockLength) do
  {$ELSE}
    while (InputBuffer.Size = 0) do
  {$ENDIF}
    begin
   {$IFDEF DMB_INDY10}
      IOHandler.CheckForDataOnSource(FReadTimeout);
   {$ELSE}
      if Socket.Binding.Readable(FReadTimeout) then
        ReadFromStack;
    {$ENDIF}
      if (Now > dtTimeOut) then
      begin
        Result := False;
        Exit;
      end;
    end;
  end;

  Result := True;
{$IFDEF DMB_INDY10}
  iSize := IOHandler.InputBuffer.Size;
  IOHandler.ReadBytes(RecBuffer, iSize);
  Move(RecBuffer[0], ReceiveBuffer, iSize);
{$ELSE}
  ReadBuffer(ReceiveBuffer, InputBuffer.Size);
{$ENDIF}
{ Check if the result has the same function code as the request }
  if (AModBusFunction = ReceiveBuffer.FunctionCode) then
  begin
    case AModBusFunction of
      mbfReadCoils,
      mbfReadInputBits:
        begin
          BlockLength := ReceiveBuffer.MBPData[0] * 8;
          if (BlockLength > 250) then
            BlockLength := 250;
          GetCoilsFromBuffer(@ReceiveBuffer.MBPData[1], BlockLength, Data);
        end;
      mbfReadHoldingRegs,
      mbfReadInputRegs:
        begin
          BlockLength := (ReceiveBuffer.MBPData[0] shr 1);
          if (BlockLength > 125) then
            BlockLength := 125;
          GetRegistersFromBuffer(@ReceiveBuffer.MBPData[1], BlockLength, Data);
        end;
    end;
  end
  else
  begin
    if ((AModBusFunction or $80) = ReceiveBuffer.FunctionCode) then
      DoSerialResponseError(AModBusFunction, ReceiveBuffer.MBPData[0], ReceiveBuffer)
    else
      DoSerialResponseMismatch(AModBusFunction, ReceiveBuffer.FunctionCode, ReceiveBuffer);
    Result := False;
  end;
end;

function TIdModBusSerialClient.WriteRegisters_Serial(const RegNo: Word;
  const RegisterData: array of Word): Boolean;
var
  i: Integer;
  iBlockLength: Integer;
  Data: array of Word;
  bNewConnection: Boolean;
begin
  bNewConnection := False;
  iBlockLength := High(RegisterData) - Low(RegisterData) + 1;
  if AutoConnect and not Connected then
  begin
  {$IFDEF DMB_INDY10}
    Connect;
  {$ELSE}
    Connect(FConnectTimeOut);
  {$ENDIF}
    bNewConnection := True;
  end;

  try
    SetLength(Data, Length(RegisterData));
    for i := Low(RegisterData) to High(RegisterData) do
      Data[i] := RegisterData[i];
    Result := SendCommand_Serial(mbfWriteRegs, RegNo, iBlockLength, Data);
  finally
    if bNewConnection then
      DisConnect;
  end;
end;

end.

unit ChennelTCPClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils,
     ChennelClasses,
     SocketMyServerTypes,
     MBDeviceClasses,
     MBRequestReaderTCPClasses, MBBuilderTCPAnswerPacketClasses;

type

  { TChennelTCPThread }

  TChennelTCPThread = class(TChennelBaseThread)
   private
    FBindAddress : String;
    FPort        : Word;
    FSrvSocket   : TBaseServerSocket;

    FReader      : TMBTCPRequestReader;
    FAnswBits    : TBuilderMBTCPBitAswerPacket;
    FAnswWord    : TBuilderMBTCPWordAswerPacket;
   protected
    procedure Execute; override; // вертит путой цикл в 500 мс
    procedure InitThread;        // создает серверное соединение
    procedure CloseThread;       // уничтожает серверное соединение

    procedure OnClientConnectProc(Sender : TBaseServerSocket; aClient : TServerClientObj);
    procedure OnClientDisconnectProc(Sender : TBaseServerSocket; aClient : TServerClientObj);
    procedure OnClientReceiveDataProc(Sender : TServerClientObj; Buff : array of Byte; DataSize : Cardinal; QuantityDataCame : Cardinal);
    procedure OnSocketErrorProc(Sender : TObject);
    procedure OnClientErrorProc(Sender : TObject);

    procedure SendErrorMsg(ATaransID,AProtID : Word; ADevNum,AFuncNum,AError: Byte; AClient : TServerClientObj);

    procedure ResponseF1(ADev : TMBDevice; AClient : TServerClientObj); virtual;
    procedure ResponseF2(ADev : TMBDevice; AClient : TServerClientObj); virtual;
    procedure ResponseF3(ADev : TMBDevice; AClient : TServerClientObj); virtual;
    procedure ResponseF4(ADev : TMBDevice; AClient : TServerClientObj); virtual;
    procedure ResponseF5(ADev : TMBDevice; AClient : TServerClientObj); virtual;
    procedure ResponseF6(ADev : TMBDevice; AClient : TServerClientObj); virtual;
    procedure ResponseF15(ADev : TMBDevice; AClient : TServerClientObj); virtual;
    procedure ResponseF16(ADev : TMBDevice; AClient : TServerClientObj); virtual;
    procedure ResponseF17(ADev : TMBDevice; AClient : TServerClientObj); virtual;
   public
    constructor Create(CreateSuspended: Boolean; const StackSize: SizeUInt = 65535); reintroduce;
    destructor  Destroy; override;
    property BindAddress : String read FBindAddress write FBindAddress;
    property Port        : Word read FPort write FPort;
  end;

  TChennelTCP = class(TChennelBase)
   private
    FBindAddress : String;
    FPort        : Word;
   protected
    procedure SetActiveTrue; override;
   public
    constructor Create; override;
    property BindAddress : String read FBindAddress write FBindAddress;
    property Port        : Word read FPort write FPort default 502;
  end;

implementation

uses LoggerItf, ModbusEmuResStr,
     MBDefine, ExceptionsTypes,
     MBRequestTypes, MBResponseTypes,
     MBRegistersCalsses;

{ TChennelTCP }

procedure TChennelTCP.SetActiveTrue;
begin
  if Active then Exit;

  FChennelThread := TChennelTCPThread.Create(True);
  FChennelThread.Logger      := Logger;
  FChennelThread.CSection    := CSection;
  FChennelThread.DeviceArray := DeviceArray;
  TChennelTCPThread(FChennelThread).BindAddress := FBindAddress;
  TChennelTCPThread(FChennelThread).Port        := FPort;

  FChennelThread.Start;
end;

constructor TChennelTCP.Create;
begin
  inherited Create;
  FPort        := 502;
  FBindAddress := '0.0.0.0';
end;

{ TChennelTCPThread }

constructor TChennelTCPThread.Create(CreateSuspended : Boolean; const StackSize : SizeUInt);
begin
  inherited Create(CreateSuspended,StackSize);
  FPort        := 502;
  FBindAddress := '0.0.0.0';
  FSrvSocket   := nil;
  FReader      := TMBTCPRequestReader.Create(nil);
  FAnswBits    := TBuilderMBTCPBitAswerPacket.Create(nil);
  FAnswWord    := TBuilderMBTCPWordAswerPacket.Create(nil);
end;

destructor TChennelTCPThread.Destroy;
begin
  FreeAndNil(FReader);
  FreeAndNil(FAnswBits);
  FreeAndNil(FAnswWord);
  inherited Destroy;
end;

procedure TChennelTCPThread.OnClientReceiveDataProc(Sender : TServerClientObj; Buff : array of Byte; DataSize : Cardinal; QuantityDataCame : Cardinal);
var TempDevice : TMBDevice;
begin
  TempDevice := nil;
  if (Length(Buff) = 0) or (DataSize = 0) then Exit;

  SendLogMessage(llDebug,rsChanTCP1,Format('<- %s',[GetBuffAsStringHexMB(@Buff[0],DataSize)]));

  // читаем пакет
  try
   FReader.RequestRead(@Buff[0],DataSize);
  except
   on E : Exception do
   begin
    SendLogMessage(llError,rsChanTCP1,Format(rsOnClientReceiveDataProc1,[Sender.ClientAddr,Sender.ClientPort,E.Message]));
    Exit;
   end;
  end;

  Lock; // в ходим в критическую секцию для работы с массивом устройств
  try
    // получаем требуемый девайс
    try
     TempDevice := DeviceArray^[FReader.DeviceAddress];
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsChanTCP1,Format(rsOnClientReceiveDataProc2,[Sender.ClientAddr,Sender.ClientPort,E.Message]));
       Exit;
      end;
    end;
    if not Assigned(TempDevice) then
     begin
      SendLogMessage(llDebug,rsChanTCP1,Format(rsOnClientReceiveDataProc3,[Sender.ClientAddr,Sender.ClientPort,FReader.DeviceAddress]));
      Exit;
     end;
    if not(TMBFunctionsEnum(FReader.FunctionCode) in TempDevice.DeviceFunctions) then
     begin
      SendLogMessage(llDebug, rsChanTCP1,Format(rsOnClientReceiveDataProc4,[Sender.ClientAddr,Sender.ClientPort,FReader.FunctionCode,FReader.DeviceAddress]));
      SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_ILLEGAL_FUNCTION - ERR_MB_ERR_CUSTOM,Sender);
      Exit;
     end;
    case FReader.FunctionCode of
     1  : begin // чтение Coils rw
           ResponseF1(TempDevice,Sender);
          end;
     2  : begin // чтение Discrete r
           ResponseF2(TempDevice,Sender);
          end;
     3  : begin // чтение Holdings rw
           ResponseF3(TempDevice,Sender);
          end;
     4  : begin // чтение Input r
           ResponseF4(TempDevice,Sender);
          end;
     5  : begin // запись одного Coil
           ResponseF5(TempDevice,Sender);
          end;
     6  : begin // запись одного Holding
           ResponseF6(TempDevice,Sender);
          end;
     15 : begin // запись множества Coils
           ResponseF15(TempDevice,Sender);
          end;
     16 : begin // запись множества Holding
           ResponseF16(TempDevice,Sender);
          end;
     23 : begin // Чтение/запись Holdong регистров одним вызовом
           ResponseF17(TempDevice,Sender);
          end;
    end;
  finally
   UnLock;
  end;
end;

procedure TChennelTCPThread.OnSocketErrorProc(Sender : TObject);
begin
  SendLogMessage(llDebug,rsChanTCP1,Format(rsOpenChennel5,[TBaseServerSocket(Sender).LastError,TBaseServerSocket(Sender).LastErrorDescr]));
end;

procedure TChennelTCPThread.OnClientErrorProc(Sender : TObject);
begin
  SendLogMessage(llDebug,rsChanTCP1,Format(rsOpenChennel6,[TServerClientObj(Sender).ClientAddr,TServerClientObj(Sender).ClientPort,TServerClientObj(Sender).LastError]));
end;

procedure TChennelTCPThread.SendErrorMsg(ATaransID, AProtID : Word; ADevNum, AFuncNum, AError : Byte; AClient : TServerClientObj);
var TempErrResp : TMBTCPErrorHeder;
    TempSendRes : Integer;
begin
  TempErrResp.TransactioID           := Swap(ATaransID);
  TempErrResp.ProtocolID             := Swap(AProtID);
  TempErrResp.Length                 := 3;
  TempErrResp.DeviceID               := ADevNum;
  TempErrResp.ErrorData.FunctionCode := $80 or AFuncNum;
  TempErrResp.ErrorData.ErrorCode    := AError;

  TempSendRes := AClient.SendDada(TempErrResp,9);
  if TempSendRes = -1 then SendLogMessage(llError,rsChanTCP1,Format(rsSendErrorMsg1,[AClient.ClientAddr,AClient.ClientPort,AClient.LastError]));
end;

procedure TChennelTCPThread.ResponseF1(ADev : TMBDevice; AClient : TServerClientObj);
var TempStartAddr    : Word;
    TempQuantity     : Word;
    TempBits         : TBits;
    TempPackData     : Pointer;
    TempPackDataSize : Cardinal;
    TempSendRes      : Integer;
begin
   TempPackData := FReader.GetPacketData(TempPackDataSize);

   TempStartAddr := swap(PMBF1_6FRequestData(TempPackData)^.StartingAddress);
   TempQuantity  := swap(PMBF1_6FRequestData(TempPackData)^.Quantity);

   Freemem(TempPackData);

   try
    TempBits := ADev.GetCoilRegValues(TempStartAddr,TempQuantity);
   except
    on E : Exception do
     begin
      SendLogMessage(llError,rsChanTCP1, Format(rsResponseF1_1,[AClient.ClientAddr,AClient.ClientPort,FReader.DeviceAddress, TempStartAddr,TempQuantity,E.Message]));
      SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_SLAVE_DEVICE_FAILURE - ERR_MB_ERR_CUSTOM,AClient);
      Exit;
     end;
   end;

   try
    FAnswBits.BitData := TempBits;
   finally
    if Assigned(TempBits) then FreeAndNil(TempBits);
   end;

   FAnswBits.StartingAddress := TempStartAddr;
   FAnswBits.Quantity        := TempQuantity;
   FAnswBits.TransactionID   := FReader.TransactionID;
   FAnswBits.ProtocolID      := FReader.ProtocolID;
   FAnswBits.DeviceAddress   := FReader.DeviceAddress;
   FAnswBits.FunctionNum     := TMBFunctionsEnum(FReader.FunctionCode);
   // строим ответный пакет
   FAnswBits.Build;
   // получаем паект от построителя для отправки
   TempPackData     := FAnswBits.Packet;
   TempPackDataSize := FAnswBits.LenPacket;
   try

    // посылаем ответ
    TempSendRes := AClient.SendDada(TempPackData^,TempPackDataSize);
    if TempSendRes = -1 then
     begin
      SendLogMessage(llDebug, rsChanTCP1,Format(rsResponseF1_2,[AClient.ClientAddr,AClient.ClientPort]));
      Exit;
     end;

    SendLogMessage(llDebug,rsChanTCP1,Format('-> %s',[GetBuffAsStringHexMB(TempPackData,TempPackDataSize)]));
   finally
    // освобождаем память выделенную для пакета
    Freemem(TempPackData);
   end;
end;

procedure TChennelTCPThread.ResponseF2(ADev : TMBDevice; AClient : TServerClientObj);
var TempStartAddr    : Word;
    TempQuantity     : Word;
    TempBits         : TBits;
    TempPackData     : Pointer;
    TempPackDataSize : Cardinal;
    TempSendRes      : Integer;
begin
  TempPackData := FReader.GetPacketData(TempPackDataSize);

  TempStartAddr := swap(PMBF1_6FRequestData(TempPackData)^.StartingAddress);
  TempQuantity  := swap(PMBF1_6FRequestData(TempPackData)^.Quantity);

  Freemem(TempPackData);

  try
   TempBits := ADev.GetDiscretRegValues(TempStartAddr,TempQuantity);
  except
   on E : Exception do
    begin
     SendLogMessage(llError,rsChanTCP1, Format(rsResponseF2_1,[AClient.ClientAddr,AClient.ClientPort,FReader.DeviceAddress, TempStartAddr,TempQuantity,E.Message]));
     SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_SLAVE_DEVICE_FAILURE - ERR_MB_ERR_CUSTOM,AClient);
     Exit;
    end;
  end;

  try
   FAnswBits.BitData := TempBits;
  finally
   if Assigned(TempBits) then FreeAndNil(TempBits);
  end;

  FAnswBits.StartingAddress := TempStartAddr;
  FAnswBits.Quantity        := TempQuantity;
  FAnswBits.TransactionID   := FReader.TransactionID;
  FAnswBits.ProtocolID      := FReader.ProtocolID;
  FAnswBits.DeviceAddress   := FReader.DeviceAddress;
  FAnswBits.FunctionNum     := TMBFunctionsEnum(FReader.FunctionCode);
  FAnswBits.Build;

  TempPackData     := FAnswBits.Packet;
  TempPackDataSize := FAnswBits.LenPacket;
  try

   TempSendRes := AClient.SendDada(TempPackData^,TempPackDataSize);
   if TempSendRes = -1 then
    begin
     SendLogMessage(llDebug, rsChanTCP1,Format(rsResponseF2_2,[AClient.ClientAddr,AClient.ClientPort]));
     Exit;
    end;

   SendLogMessage(llDebug,rsChanTCP1,Format('-> %s',[GetBuffAsStringHexMB(TempPackData,TempPackDataSize)]));
  finally
   Freemem(TempPackData);
  end;
end;

procedure TChennelTCPThread.ResponseF3(ADev : TMBDevice; AClient : TServerClientObj);
var TempStartAddr    : Word;
    TempQuantity     : Word;
    TempWords        : TWordRegsValues;
    TempPackData     : Pointer;
    TempPackDataSize : Cardinal;
    TempSendRes      : Integer;
begin
  TempPackData := FReader.GetPacketData(TempPackDataSize);

  TempStartAddr := swap(PMBF1_6FRequestData(TempPackData)^.StartingAddress);
  TempQuantity  := swap(PMBF1_6FRequestData(TempPackData)^.Quantity);

  Freemem(TempPackData);

  try
   TempWords := ADev.GetHoldingRegValues(TempStartAddr,TempQuantity);
  except
   on E : Exception do
    begin
     SendLogMessage(llError,rsChanTCP1, Format(rsResponseF3_1,[AClient.ClientAddr,AClient.ClientPort,FReader.DeviceAddress, TempStartAddr,TempQuantity,E.Message]));
     SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_SLAVE_DEVICE_FAILURE - ERR_MB_ERR_CUSTOM,AClient);
     Exit;
    end;
  end;

  try
   FAnswWord.WordData := TempWords;
  finally
   SetLength(TempWords,0);
  end;

  FAnswWord.StartingAddress := TempStartAddr;
  FAnswWord.Quantity        := TempQuantity;
  FAnswWord.TransactionID   := FReader.TransactionID;
  FAnswWord.ProtocolID      := FReader.ProtocolID;
  FAnswWord.DeviceAddress   := FReader.DeviceAddress;
  FAnswWord.FunctionNum     := TMBFunctionsEnum(FReader.FunctionCode);
  FAnswWord.Build;

  TempPackData     := FAnswWord.Packet;
  TempPackDataSize := FAnswWord.LenPacket;
  try

   TempSendRes := AClient.SendDada(TempPackData^,TempPackDataSize);
   if TempSendRes = -1 then
    begin
     SendLogMessage(llDebug, rsChanTCP1,Format(rsResponseF3_2,[AClient.ClientAddr,AClient.ClientPort]));
     Exit;
    end;

   SendLogMessage(llDebug,rsChanTCP1,Format('-> %s',[GetBuffAsStringHexMB(TempPackData,TempPackDataSize)]));
  finally
   Freemem(TempPackData);
  end;
end;

procedure TChennelTCPThread.ResponseF4(ADev : TMBDevice; AClient : TServerClientObj);
var TempStartAddr    : Word;
    TempQuantity     : Word;
    TempWords        : TWordRegsValues;
    TempPackData     : Pointer;
    TempPackDataSize : Cardinal;
    TempSendRes      : Integer;
begin
  TempPackData := FReader.GetPacketData(TempPackDataSize);

  TempStartAddr := swap(PMBF1_6FRequestData(TempPackData)^.StartingAddress);
  TempQuantity  := swap(PMBF1_6FRequestData(TempPackData)^.Quantity);

  Freemem(TempPackData);

  try
   TempWords := ADev.GetInputRegValues(TempStartAddr,TempQuantity);
  except
   on E : Exception do
    begin
     SendLogMessage(llError,rsChanTCP1, Format(rsResponseF4_1,[AClient.ClientAddr,AClient.ClientPort,FReader.DeviceAddress, TempStartAddr,TempQuantity,E.Message]));
     SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_SLAVE_DEVICE_FAILURE - ERR_MB_ERR_CUSTOM,AClient);
     Exit;
    end;
  end;

  try
   FAnswWord.WordData := TempWords;
  finally
   SetLength(TempWords,0);
  end;

  FAnswWord.StartingAddress := TempStartAddr;
  FAnswWord.Quantity        := TempQuantity;
  FAnswWord.TransactionID   := FReader.TransactionID;
  FAnswWord.ProtocolID      := FReader.ProtocolID;
  FAnswWord.DeviceAddress   := FReader.DeviceAddress;
  FAnswWord.FunctionNum     := TMBFunctionsEnum(FReader.FunctionCode);
  FAnswWord.Build;

  TempPackData     := FAnswWord.Packet;
  TempPackDataSize := FAnswWord.LenPacket;
  try

   TempSendRes := AClient.SendDada(TempPackData^,TempPackDataSize);
   if TempSendRes = -1 then
    begin
     SendLogMessage(llDebug, rsChanTCP1,Format(rsResponseF4_2,[AClient.ClientAddr,AClient.ClientPort]));
     Exit;
    end;

   SendLogMessage(llDebug,rsChanTCP1,Format('-> %s',[GetBuffAsStringHexMB(TempPackData,TempPackDataSize)]));
  finally
   Freemem(TempPackData);
  end;
end;

procedure TChennelTCPThread.ResponseF5(ADev : TMBDevice; AClient : TServerClientObj);
var TempStartAddr    : Word;
    TempQuantity     : Word;
    TempBool         : Boolean;
    TempPackData     : Pointer;
    TempPackDataSize : Cardinal;
    TempSendRes      : Integer;
    TempResp5_6      : TMBTCPF1RequestNew;
begin
  TempPackData := FReader.GetPacketData(TempPackDataSize);

  try
   TempStartAddr := swap(PMBF1_6FRequestData(TempPackData)^.StartingAddress); // адрес
   TempQuantity  := swap(PMBF1_6FRequestData(TempPackData)^.Quantity);        // значение - должно быть либо $0000 - False либо $FF00 - True

   if TempQuantity = 0 then TempBool := False
    else TempBool := True;

   try
    ADev.BeginPacketUpdate;
    try
     ADev.Coils[TempStartAddr].Value := TempBool;
    finally
     ADev.EndPacketUpdate;
    end;

    TempResp5_6.TCPHeader.TransactioID := Swap(FReader.TransactionID);
    TempResp5_6.TCPHeader.ProtocolID   := Swap(FReader.ProtocolID);
    TempResp5_6.TCPHeader.Length       := Swap(FReader.Len);
    TempResp5_6.Header.DeviceInfo.DeviceAddress := FReader.DeviceAddress;
    TempResp5_6.Header.DeviceInfo.FunctionCode  := 5;
    TempResp5_6.Header.RequestData.StartingAddress := PMBF1_6FRequestData(TempPackData)^.StartingAddress;
    TempResp5_6.Header.RequestData.Quantity        := PMBF1_6FRequestData(TempPackData)^.Quantity;

    TempSendRes := AClient.SendDada(TempResp5_6,SizeOf(TempResp5_6));
    if TempSendRes = -1 then
     begin
      SendLogMessage(llDebug, rsChanTCP1,Format(rsResponseF5_2,[AClient.ClientAddr,AClient.ClientPort]));
      Exit;
     end;

    SendLogMessage(llDebug,rsChanTCP1,Format('-> %s',[GetBuffAsStringHexMB(@TempResp5_6,SizeOf(TempResp5_6))]));
   except
    on E : Exception do
     begin
      SendLogMessage(llError,rsChanTCP1,Format(rsResponseF5_1,[AClient.ClientAddr,AClient.ClientPort,FReader.DeviceAddress, TempStartAddr,TempQuantity,E.Message]));
      SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_SLAVE_DEVICE_FAILURE - ERR_MB_ERR_CUSTOM,AClient);
     end;
   end;
  finally
   Freemem(TempPackData);
  end;
end;

procedure TChennelTCPThread.ResponseF6(ADev : TMBDevice; AClient : TServerClientObj);
var TempStartAddr    : Word;
    TempQuantity     : Word;
    TempPackData     : Pointer;
    TempPackDataSize : Cardinal;
    TempSendRes      : Integer;
    TempResp5_6      : TMBTCPF1RequestNew;
begin
  TempPackData := FReader.GetPacketData(TempPackDataSize);
  try
   TempStartAddr := swap(PMBF1_6FRequestData(TempPackData)^.StartingAddress); // адрес
   TempQuantity  := swap(PMBF1_6FRequestData(TempPackData)^.Quantity);        // значение
   try
    ADev.BeginPacketUpdate;
    try
     ADev.Inputs[TempStartAddr].Value := TempQuantity;
    finally
     ADev.EndPacketUpdate;
    end;

    TempResp5_6.TCPHeader.TransactioID := Swap(FReader.TransactionID);
    TempResp5_6.TCPHeader.ProtocolID   := Swap(FReader.ProtocolID);
    TempResp5_6.TCPHeader.Length       := Swap(FReader.Len);
    TempResp5_6.Header.DeviceInfo.DeviceAddress := FReader.DeviceAddress;
    TempResp5_6.Header.DeviceInfo.FunctionCode  := 6;
    TempResp5_6.Header.RequestData.StartingAddress := PMBF1_6FRequestData(TempPackData)^.StartingAddress;
    TempResp5_6.Header.RequestData.Quantity        := PMBF1_6FRequestData(TempPackData)^.Quantity;

    TempSendRes := AClient.SendDada(TempResp5_6,SizeOf(TempResp5_6));
    if TempSendRes = -1 then
     begin
      SendLogMessage(llDebug, rsChanTCP1,Format(rsResponseF6_2,[AClient.ClientAddr,AClient.ClientPort]));
      Exit;
     end;

    SendLogMessage(llDebug,rsChanTCP1,Format('-> %s',[GetBuffAsStringHexMB(@TempResp5_6,SizeOf(TempResp5_6))]));
   except
    on E : Exception do
     begin
      SendLogMessage(llError,rsChanTCP1,Format(rsResponseF6_1,[AClient.ClientAddr,AClient.ClientPort,FReader.DeviceAddress, TempStartAddr,TempQuantity,E.Message]));
      SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_SLAVE_DEVICE_FAILURE - ERR_MB_ERR_CUSTOM,AClient);
     end;
   end;
  finally
   Freemem(TempPackData);
  end;
end;

procedure TChennelTCPThread.ResponseF15(ADev : TMBDevice; AClient : TServerClientObj);
var TempPackData     : Pointer;
    TempPackDataSize : Cardinal;
    TempBitArray     : PByteArray;
    TempStartAddr    : Word;
    TempQuantity     : Word;
    TempByteCount,
    TempByte,ByteVal : Byte;
    TempRegNum       : Word;
    i,ii,Count       : Integer;
    TempReg          : TMBBitRegister;
    TempSendRes      : Integer;
    TempResp5_6      : TMBTCPF1RequestNew;
begin
  TempPackData := FReader.GetPacketData(TempPackDataSize);
  {
   StartAddres
   Quantity
   ByteCount
   Size(DataBytes) = ByteCount
  }
  TempStartAddr := Swap(PMBF15ReguestPacketData(TempPackData)^.StartingAddress);
  TempQuantity  := Swap(PMBF15ReguestPacketData(TempPackData)^.Quantity);
  TempByteCount := PMBF15ReguestPacketData(TempPackData)^.ByteCount;
  TempBitArray  := PByteArray(Pointer(PtrUInt(@PMBF15ReguestPacketData(TempPackData)^.ByteCount)+1));
  try
   try
    if TempByteCount <> (TempPackDataSize-5) then Exit; // нужно исключение ?
    Count := TempByteCount-1;
    ADev.BeginPacketUpdate;
    try
     for i := 0 to Count do
      begin
       TempByte := TempBitArray^[i];
       ByteVal  := 1;
       for ii := 0 to 7 do
        begin
         TempRegNum := TempStartAddr+(i*8)+ii;
         if TempRegNum > (TempStartAddr+TempQuantity-1) then Break;
         TempReg := ADev.Coils[TempRegNum];
         TempReg.Value := TempByte and ByteVal = ByteVal;
         ByteVal := ByteVal * 2;
        end;
      end;
    finally
     ADev.EndPacketUpdate;
    end;
   finally
    if Assigned(TempPackData) then Freemem(TempPackData);
   end;

   TempResp5_6.TCPHeader.TransactioID := Swap(FReader.TransactionID);
   TempResp5_6.TCPHeader.ProtocolID   := Swap(FReader.ProtocolID);
   TempResp5_6.TCPHeader.Length       := Swap(FReader.Len);
   TempResp5_6.Header.DeviceInfo.DeviceAddress := FReader.DeviceAddress;
   TempResp5_6.Header.DeviceInfo.FunctionCode  := 15;
   TempResp5_6.Header.RequestData.StartingAddress := Swap(TempStartAddr);
   TempResp5_6.Header.RequestData.Quantity        := Swap(TempQuantity);

   TempSendRes := AClient.SendDada(TempResp5_6,SizeOf(TempResp5_6));
   if TempSendRes = -1 then
    begin
     SendLogMessage(llDebug, rsChanTCP1,Format(rsResponseF5_2,[AClient.ClientAddr,AClient.ClientPort]));
     Exit;
    end;

   SendLogMessage(llDebug,rsChanTCP1,Format('-> %s',[GetBuffAsStringHexMB(@TempResp5_6,SizeOf(TempResp5_6))]));
  except
   on E : Exception do
    begin
     SendLogMessage(llError,rsChanTCP1,Format(rsResponseF5_1,[AClient.ClientAddr,AClient.ClientPort,FReader.DeviceAddress, TempStartAddr,TempQuantity,E.Message]));
     SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_SLAVE_DEVICE_FAILURE - ERR_MB_ERR_CUSTOM,AClient);
    end;
  end;
end;

procedure TChennelTCPThread.ResponseF16(ADev : TMBDevice; AClient : TServerClientObj);
begin
  SendLogMessage(llError,rsChanTCP1,Format(rsResponseF16_1,[AClient.ClientAddr,AClient.ClientPort]));
  SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_ILLEGAL_FUNCTION - ERR_MB_ERR_CUSTOM,AClient);
end;

procedure TChennelTCPThread.ResponseF17(ADev : TMBDevice; AClient : TServerClientObj);
begin
  SendLogMessage(llError,rsChanTCP1,Format(rsResponseF17_1,[AClient.ClientAddr,AClient.ClientPort]));
  SendErrorMsg(FReader.TransactionID,FReader.ProtocolID,FReader.DeviceAddress,FReader.FunctionCode,ERR_MB_ILLEGAL_FUNCTION - ERR_MB_ERR_CUSTOM,AClient);
end;

procedure TChennelTCPThread.OnClientConnectProc(Sender : TBaseServerSocket; aClient : TServerClientObj);
begin
  SendLogMessage(llError,rsChanTCP1,Format(rsClientConnect1,[Sender.BindAddress,Sender.Port,aClient.ClientAddr,aClient.ClientPort]));
end;

procedure TChennelTCPThread.OnClientDisconnectProc(Sender : TBaseServerSocket;aClient : TServerClientObj);
begin
  SendLogMessage(llError,rsChanTCP1,Format(rsClientDisconnect1,[Sender.BindAddress,Sender.Port,aClient.ClientAddr,aClient.ClientPort]));
end;

procedure TChennelTCPThread.Execute;
begin
  InitThread;
  try
   while not Terminated do
    begin
     Sleep(500);
    end;
  finally
   CloseThread;
  end;
end;

procedure TChennelTCPThread.InitThread;
begin
  try
   FSrvSocket := TBaseServerSocket.Create;
   FSrvSocket.Logger := Logger;
   FSrvSocket.BindAddress := FBindAddress;
   FSrvSocket.Port        := FPort;
   FSrvSocket.OnClientConnect     := @OnClientConnectProc;
   FSrvSocket.OnClientDisconnect  := @OnClientDisconnectProc;
   FSrvSocket.OnClientReceiveData := @OnClientReceiveDataProc;
   FSrvSocket.OnError             := @OnSocketErrorProc;
   FSrvSocket.OnClientError       := @OnClientErrorProc;
   FSrvSocket.Open;

   if FSrvSocket.Active then SendLogMessage(llDebug,rsChanTCP1, Format(rsOpenChennel7,[FBindAddress,FPort]));

  except
   on E : Exception do
    begin
     SendLogMessage(llError,rsChanTCP1,Format(rsChanThreadIni,[E.Message]));
    end;
  end;
end;

procedure TChennelTCPThread.CloseThread;
begin
  try
   SendLogMessage(llDebug,rsChanTCP1, Format(rsCloseChennel5,[FSrvSocket.BindAddress,FSrvSocket.Port]));

   FreeAndNil(FSrvSocket);
  except
   on E : Exception do
    begin
     SendLogMessage(llError,rsChanTCP1,Format(rsChanThreadClose,[E.Message]));
    end;
  end;
end;

end.


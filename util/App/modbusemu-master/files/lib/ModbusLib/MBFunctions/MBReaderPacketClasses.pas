unit MBReaderPacketClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBDefine,
     MBResponseTypes, MBRequestTypes,
     MBReaderBase, MBInterfaces;

type

  TReaderMBRTUPacket = class(TReaderBase,IReaderRTUPacket)
   protected
    FSourceFunction : Byte;     //
    FSourceDevice   : Byte;     //
    FDeviceAddress  : Byte;     //
    FFunctionCode   : Byte;     //
    function  CheckBuffNil(Buff : Pointer) : Boolean; virtual;                    //
    function  CheckCRC(Buff : Pointer; BuffSize : Cardinal) : Boolean; virtual;   //
    function  CheckMBError(Buff : Pointer) : Boolean ; virtual;                   //
    function  CheckSourceDevice(Buff : Pointer): Boolean; virtual;                //
    function  CheckSourceFunction(Buff : Pointer): Boolean; virtual;              //
    procedure Notify(EventType : TReadPacketEventType ;AMessage : String = ''); override; //
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); virtual; abstract;           //

    function  GetDeviceAddress  : Byte; virtual;      //
    function  GetFunctionCode   : Byte; virtual;      //
   public
    constructor Create(AOwner : TComponent); override;                                          //
    destructor  Destroy; override;                                         //
    procedure Response(Buff : Pointer; BuffSize : Cardinal); override;     //
    property DeviceAddress  : Byte read GetDeviceAddress;                  //
    property FunctionCode   : Byte read GetFunctionCode;                   //
    property SourceDevice   : Byte read FSourceDevice write FSourceDevice; //
    property SourceFunction : Byte read FSourceFunction ;                  //
  end;

  TReaderMBTCPPacket = class(TReaderMBRTUPacket,IReaderTCPPacket)
  protected
    FSourceTransID : Word;
    FTransactionID : Word;
    FProtocolID    : Word;
    FLen           : Word;
    function  CheckTransactionID(Buff : Pointer):Boolean; virtual;
    function  CheckLen(Buff : Pointer; PacketSize : Cardinal): Boolean; virtual;

    function  CheckMBError(Buff : Pointer) : Boolean ; override;                   //
    function  CheckSourceDevice(Buff : Pointer): Boolean; override;                //
    function  CheckSourceFunction(Buff : Pointer): Boolean; override;              //

    function  GetTransactionID : Word; virtual;
    function  GetProtocolID    : Word; virtual;
    function  GetLen           : Word; virtual;
  public
    constructor Create(AOwner : TComponent); override;
    procedure Response(Buff : Pointer; BuffSize : Cardinal); override;
    property SourceTransID : Word read FSourceTransID write FSourceTransID;
    property TransactionID : Word read GetTransactionID;
    property ProtocolID    : Word read GetProtocolID;
    property Len           : Word read GetLen;
  end;

implementation

uses SysUtils,
     MBResourceString,
     {Библиотека MiscFunctions}
     ExceptionsTypes,
     CRC16Func;

{ TReaderMBRTUPacket }

constructor TReaderMBRTUPacket.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode  := 0;
  FDeviceAddress := 0;
  FReaderType := rtMBRTU;
  FErrorCode  := 0;
end;

function TReaderMBRTUPacket.CheckBuffNil(Buff : Pointer): Boolean;
begin
 Result:= Buff<>nil;
 if not Result then FErrorCode:= ERR_MASTER_BUFF_NOT_ASSIGNET;
end;

function TReaderMBRTUPacket.CheckCRC(Buff : Pointer; BuffSize : Cardinal): Boolean;
begin
 Result:= GetCRC16(Buff,BuffSize)=0;
 if not Result then FErrorCode:=ERR_MASTER_CRC;
end;

function TReaderMBRTUPacket.CheckMBError(Buff : Pointer): Boolean;
begin
 Result := PMBErrorHeder(Buff)^.ErrorData.FunctionCode<=$80;
 if not Result then
  begin
   FDeviceAddress:=PMBErrorHeder(Buff)^.DeviceAddress;
   FFunctionCode:=PMBErrorHeder(Buff)^.ErrorData.FunctionCode-$80;
   FErrorCode:=PMBErrorHeder(Buff)^.ErrorData.ErrorCode+ERR_MB_ERR_CUSTOM;
  end
 else
  begin
   FDeviceAddress:=PMBErrorHeder(Buff)^.DeviceAddress;
   FFunctionCode:=PMBErrorHeder(Buff)^.ErrorData.FunctionCode;
  end;
end;

destructor TReaderMBRTUPacket.Destroy;
begin
  inherited;
end;

procedure TReaderMBRTUPacket.Response(Buff: Pointer; BuffSize: Cardinal);
begin
 Notify(rpStartRead);
 FErrorCode:=0;
 FMessage:='';
 try
  if not CheckBuffNil(Buff)        then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckCRC(Buff,BuffSize)   then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckSourceDevice(Buff)   then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckMBError(Buff)        then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckSourceFunction(Buff) then raise Exception.Create(GetMBErrorString(FErrorCode));

  if FErrorCode=0 then ReadData(PUintPtr(PtrUInt(Buff)+2),BuffSize-4)
  else Exit;
 except
  on E : Exception do
   begin
    Notify(rpError, E.Message);
    Exit;
   end;
 end;
 Notify(rpEndRead);
end;

procedure TReaderMBRTUPacket.Notify(EventType: TReadPacketEventType; AMessage: String);
begin
  case EventType of
   rpError     : begin
                  FMessage:=AMessage;
                  if Assigned(FOnError) then FOnError(Self);
                 end;
   rpEndRead   : begin
                  if Assigned(FOnReadEnd) then FOnReadEnd(Self);
                 end;
   rpStartRead : begin
                  if Assigned(FOnReadStart) then FOnReadStart(Self);
                 end;
  end;
end;

function TReaderMBRTUPacket.CheckSourceDevice(Buff: Pointer): Boolean;
begin
  Result := FSourceDevice = PMBErrorHeder(Buff)^.DeviceAddress;
  if not Result then FErrorCode:=ERR_MASTER_DEVICE_ADDRESS;
end;

function TReaderMBRTUPacket.CheckSourceFunction(Buff: Pointer): Boolean;
begin
 if PMBErrorHeder(Buff)^.ErrorData.FunctionCode>$80 then
  begin
   Result:=PMBErrorHeder(Buff)^.ErrorData.FunctionCode-$80=FSourceFunction;
  end
 else
  begin
   Result:=PMBErrorHeder(Buff)^.ErrorData.FunctionCode=FSourceFunction;
  end;
 if not Result then  FErrorCode:=ERR_MASTER_FUNCTION_CODE;
end;


function TReaderMBRTUPacket.GetDeviceAddress: Byte;
begin
  Result:= FDeviceAddress;
end;

function TReaderMBRTUPacket.GetFunctionCode: Byte;
begin
  Result:=FFunctionCode;
end;

{ TReaderMBTCPPacket }

constructor TReaderMBTCPPacket.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FReaderType    := rtMBTCP;
  FTransactionID := 0;
  FProtocolID    := 0;
  FLen           := 0;
end;

function TReaderMBTCPPacket.CheckLen(Buff: Pointer; PacketSize: Cardinal): Boolean;
begin
  Result := False;
  if (PacketSize < 8) or (Swap(PMBTCPHeader(Buff)^.Length)<>(PacketSize-6)) then
   begin
    FErrorCode := ERR_MASTER_PACK_LEN;
    Exit;
   end;
  FLen :=PMBTCPHeader(Buff)^.Length;
  Result:=True;
end;

function TReaderMBTCPPacket.CheckTransactionID(Buff: Pointer): Boolean;
begin
  Result:=False;
  if Buff = nil then Exit;
  FTransactionID := PMBTCPHeader(Buff)^.TransactioID;
  FProtocolID    := PMBTCPHeader(Buff)^.ProtocolID;
  Result := True;
end;

function TReaderMBTCPPacket.CheckSourceDevice(Buff: Pointer): Boolean;
begin
  Result := FSourceDevice = PMBTCPErrorHeder(Buff)^.DeviceID;
  if not Result then FErrorCode:=ERR_MASTER_DEVICE_ADDRESS;
  FDeviceAddress:=PMBTCPErrorHeder(Buff)^.DeviceID;
end;

function TReaderMBTCPPacket.CheckMBError(Buff: Pointer): Boolean;
begin
 Result := PMBTCPErrorHeder(Buff)^.ErrorData.FunctionCode<=$80;
 if not Result then FErrorCode := PMBTCPErrorHeder(Buff)^.ErrorData.ErrorCode+ERR_MB_ERR_CUSTOM;
end;

function TReaderMBTCPPacket.CheckSourceFunction(Buff: Pointer): Boolean;
begin
  if PMBTCPErrorHeder(Buff)^.ErrorData.FunctionCode>$80 then
  begin
   Result:=PMBTCPErrorHeder(Buff)^.ErrorData.FunctionCode-$80=FSourceFunction;
   FFunctionCode:=PMBTCPErrorHeder(Buff)^.ErrorData.FunctionCode-$80;
  end
 else
  begin
   Result:=PMBTCPErrorHeder(Buff)^.ErrorData.FunctionCode=FSourceFunction;
   FFunctionCode:=PMBTCPErrorHeder(Buff)^.ErrorData.FunctionCode;
  end;
 if not Result then  FErrorCode:=ERR_MASTER_FUNCTION_CODE;
end;

function TReaderMBTCPPacket.GetLen: Word;
begin
  Result := FLen;
end;

function TReaderMBTCPPacket.GetProtocolID: Word;
begin
  Result := FProtocolID;
end;

function TReaderMBTCPPacket.GetTransactionID: Word;
begin
  Result := FTransactionID;
end;

procedure TReaderMBTCPPacket.Response(Buff: Pointer; BuffSize: Cardinal);
begin
 Notify(rpStartRead);
 FErrorCode:=0;
 FMessage:='';
 try
  if not CheckBuffNil(Buff)        then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckLen(Buff,BuffSize)   then raise Exception.Create(rsMBTCPPacketLenError);
  if not CheckTransactionID(Buff)  then raise Exception.Create(rsMBTCPPacketTrasError);
  if not CheckSourceDevice(Buff)   then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckMBError(Buff)        then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckSourceFunction(Buff) then raise Exception.Create(GetMBErrorString(FErrorCode));
  if FErrorCode=0 then ReadData(Pointer(PtrUInt(Buff)+8),BuffSize-8) // передаются только данные содержащиеся в пакете. Отрезается заголовок
  else Exit;
 except
  on E : Exception do
   begin
    Notify(rpError, E.Message);
    Exit;
   end;
 end;
 Notify(rpEndRead);
end;

end.

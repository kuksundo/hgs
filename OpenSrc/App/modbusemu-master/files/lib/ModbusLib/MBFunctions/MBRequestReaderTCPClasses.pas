unit MBRequestReaderTCPClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBInterfaces,MBRequestReaderBaseClasses;

type
  {
  Цель класса определить корректность пришедшего пакета в рамках протокола
  Modbus TCP, выделить "постоянные"(номер устройства, номер функции и т.п.) и
  переменные данные пришедшие в пакете.

  Класс не является потокобезопасным.

  Разбор пакета производится по средствам метода RequestRead.
  Метод может возбуждать исключения.
  Типы исключений:
  1)

  Метод GetPacketData возвращает блок памяти с данными запроса и его длинной.
  Программа, исползующая данный объект, должна освободить данный блок после его
  использования.
  }
  TMBTCPRequestReader = class(TMBRequestReaderBase,IMBTCPReuqestReader)
  private
    FTransactionID : Word;
    FProtocolID    : Word;
    FLen           : Word;
  protected
    function  GetTransactionID : Word;
    function  GetProtocolID    : Word;
    function  GetLen           : Word;

    procedure FreePacket; override;
    procedure InitHeader;
    function  CheckPacketNil(Packet : Pointer): Boolean;
    function  CheckPacketLen(Packet : Pointer; PacketLen : Cardinal): Boolean;
  public
    constructor Create(AOwner : TComponent); override;
    constructor CreateOnPacket(Packet : Pointer; PacketSize : Cardinal); virtual;

    function  GetPacketData(out DataSize : Cardinal): Pointer; override;
    procedure RequestRead(Packet : Pointer; PacketSize : Cardinal); override;

    property TransactionID : Word read GetTransactionID;
    property ProtocolID    : Word read GetProtocolID;
    property Len           : Word read GetLen;
  end;


implementation

uses SysUtils, 
     MBDefine,
     MBRequestTypes,
     {Библиотека MiscFunctions}
     ExceptionsTypes;

{ TMBTCPRequestReader }

constructor TMBTCPRequestReader.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FReaderType := rtMBTCP;
  InitHeader;
end;

constructor TMBTCPRequestReader.CreateOnPacket(Packet: Pointer; PacketSize: Cardinal);
begin
  Create(nil);
  RequestRead(Packet,PacketSize);
end;

procedure TMBTCPRequestReader.FreePacket;
begin
  inherited;
  InitHeader;
end;

function TMBTCPRequestReader.GetLen: Word;
begin
  Result := FLen;
end;

function TMBTCPRequestReader.GetPacketData( out DataSize: Cardinal): Pointer;
begin
  Result:=nil;
  if FPacket = nil then Exit;
  DataSize := FLen-2;
  Result := AllocMem(DataSize);
  Move(Pointer(PtrUInt(FPacket)+8)^,Result^, DataSize);
end;

function TMBTCPRequestReader.GetProtocolID: Word;
begin
  Result := FProtocolID;
end;

function TMBTCPRequestReader.GetTransactionID: Word;
begin
  Result := FTransactionID;
end;

procedure TMBTCPRequestReader.InitHeader;
begin
  FTransactionID := 0;
  FProtocolID    := 0;
  FLen           := 0;
end;

procedure TMBTCPRequestReader.RequestRead(Packet: Pointer; PacketSize: Cardinal);
var TempHeaderFN : PMBTCPHeaderFullFName;
begin
  FreePacket;
  Notify(rpStartRead);
  try
   if not CheckPacketNil(Packet)             then raise Exception.Create(GetMBErrorString(FErrorCode));
   if not CheckPacketLen(Packet, PacketSize) then raise Exception.Create(GetMBErrorString(FErrorCode));

   CopyPacket(Packet,PacketSize);

   TempHeaderFN := PMBTCPHeaderFullFName(FPacket);

   FTransactionID  := Swap(TempHeaderFN^.TCPHeaderFull.TransactioID);
   FProtocolID     := Swap(TempHeaderFN^.TCPHeaderFull.ProtocolID);
   FLen            := Swap(TempHeaderFN^.TCPHeaderFull.Length);
   FDeviceAddress  := TempHeaderFN^.TCPHeaderFull.DeviceID;
   FFunctionCode   := TempHeaderFN^.FunctionNum;

  except
    on E : Exception do
     begin
       Notify(rpError,E.Message);
       Exit;
     end;
  end;
  Notify(rpEndRead);
end;

function TMBTCPRequestReader.CheckPacketLen(Packet : Pointer; PacketLen: Cardinal): Boolean;
var TempHeader : PMBTCPHeaderFull;
begin
  Result := False;
  FErrorCode := ERR_MASTER_PACK_LEN;
  // минимальная длинна пакета запроса: 8 байт;
  // максимальная длинна пакета: 260 байт;
  if (PacketLen < 8) or (PacketLen > 260) then Exit;
  TempHeader := PMBTCPHeaderFull(Packet);
  if Swap(TempHeader^.Length)<>(PacketLen-6) then Exit;
  Result     := True;
  FErrorCode := 0;
end;

function TMBTCPRequestReader.CheckPacketNil(Packet: Pointer): Boolean;
begin
  Result := False;
  FErrorCode := ERR_MASTER_BUFF_NOT_ASSIGNET;
  if Packet = nil then Exit;
  Result     := True;
  FErrorCode := 0;
end;

end.

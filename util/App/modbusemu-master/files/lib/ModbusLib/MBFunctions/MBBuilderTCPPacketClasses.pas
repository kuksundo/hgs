unit MBBuilderTCPPacketClasses;

{$mode objfpc}{$H+}

{
  Реализация классов строителей запросов для
  MODBUS TCP Application Protocol Specification V1.1b
  Modbus TCP поддерживаются функции: 1,2,3,4,5,6,15,16,20,21,22,23,24,43,43/13,43/14
  Modbus RTU поддержифаются функции: все Modbus TCP,7,8,11,12,17
}

interface

uses Classes,
     MBBuilderPacketClasses,
     MBInterfaces, MBRequestTypes, MBBuilderBase;

type

  TBuilderMBTCPF1Request = class(TBuilderMBTCPPacket)
  protected
   procedure SetQuantity(const Value: Word); override;
  public
   constructor Create(AOwner : TComponent); override;
   procedure Build; override;
 end;

 TBuilderMBTCPF2Request = class(TBuilderMBTCPF1Request)
  constructor Create(AOwner : TComponent); override;
 end;

 TBuilderMBTCPF3Request = class(TBuilderMBTCPF1Request)
  protected
   procedure SetQuantity(const Value: Word); override;
  public
   constructor Create(AOwner : TComponent); override;
 end;

 TBuilderMBTCPF4Request = class(TBuilderMBTCPF3Request)
  constructor Create(AOwner : TComponent); override;
 end;

 TBuilderMBTCPF5Request = class(TBuilderMBTCPPacket)
  private
   function  GetOutputValue: Boolean;
   procedure SetOutputValue(const Value: Boolean);
  protected
   FOutputAddress : Word;
//   FFunctionNum   : Byte;
   FOutputValue   : Word;
  public
   constructor Create(AOwner : TComponent); override;
   procedure Build; override;
   property OutputAddress : Word read FOutputAddress write FOutputAddress;
   property OutputValue   : Boolean read GetOutputValue write SetOutputValue;
 end;

 TBuilderMBTCPF6Request = class(TBuilderMBTCPPacket)
  protected
//   FFunctionNum     : Byte;
   FRegisterAddress : Word;
   FRegisterValue   : Word;
   procedure SetRegisterValue(const Value: Word);
  public
   constructor Create(AOwner : TComponent); override;
   procedure Build; override;
   property RegisterAddress : Word read FRegisterAddress write FRegisterAddress;
   property RegisterValue   : Word read FRegisterValue write SetRegisterValue;
 end;

  TBuilderMBTCPF15Request = class(TBuilderMBTCPF1Request)
   private
    FByteCount : Byte;
    FBits      : TBits;
    function  GetBits(Index: Integer): Boolean;
    procedure SetBits(Index: Integer; const Value: Boolean);
   protected
    procedure SetQuantity(const Value: Word); override;
   public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure Assign(Source : TBits); reintroduce;
    function  AreEquivalent(Source : TBits): Boolean;
    procedure Build; override;
    property Bits[Index : Integer] : Boolean read GetBits write SetBits;
  end;

  TBuilderMBTCPF16Request = class(TBuilderMBTCPF1Request)
   private
    FByteCount : Byte;
    FRegValues : TWordValueArray;
    function  GetRegValues(Index: Integer): Word;
    procedure SetRegValues(Index: Integer; const Value: Word);
   protected
    procedure SetQuantity(const Value: Word); override;
   public
    constructor Create(AOwner : TComponent); override;
    function  AreEquivalent(Source : array of Byte): Boolean;
    procedure Assign(Source : array of Byte); reintroduce;
    procedure Build; override;
    property RegValues[Index : Integer] : Word read GetRegValues write SetRegValues;
  end;

  TBuilderMBTCPF20Request = class(TBuilderMBTCPPacket) // пока не реализовано
  public
    constructor Create(AOwner : TComponent); override;
    procedure Build; override;
  end;

  TBuilderMBTCPF21Request = class(TBuilderMBTCPPacket) // пока не реализовано
  public
    constructor Create(AOwner : TComponent); override;
    procedure Build; override;
  end;

  TBuilderMBTCPF22Request = class(TBuilderMBTCPPacket)
   private
    FFunctionCode     : Byte;
    FReferenceAddress : Word;
    FAndMask          : Word;
    FOrMask           : Word;
   public
    constructor Create(AOwner : TComponent); override;
    procedure Build; override;
    property ReferenceAddress : Word read FReferenceAddress write FReferenceAddress;
    property AndMask          : Word read FAndMask write FAndMask;
    property OrMask           : Word read FOrMask write FOrMask;
  end;

  TBuilderMBTCPF23Request = class(TBuilderMBTCPPacket)
   private
    FFunctionCode      : Byte;
    FReadStartAddress  : Word;
    FReadQuantity      : Word;
    FWriteStartAddress : Word;
    FWriteQuantity     : Word;
    FWriteByteCount    : Byte;
    FWriteValues       : TWordValueArray;
    function  GetWriteValues(Index: Integer): Word;
    procedure SetReadQuantity(const Value: Word);
    procedure SetWriteQuantity(const Value: Word);
    procedure SetWriteValues(Index: Integer; const Value: Word);
   public
    constructor Create(AOwner : TComponent); override;
    function  AreEquivalent(Source : array of Byte): Boolean;
    procedure Assign(Source : array of Byte); reintroduce;
    procedure Build; override;
    property ReadStartAddress  : Word read FReadStartAddress write FReadStartAddress;
    property ReadQuantity      : Word read FReadQuantity write SetReadQuantity;
    property WriteStartAddress : Word read FWriteStartAddress write FWriteStartAddress;
    property WriteQuantity     : Word read FWriteQuantity write SetWriteQuantity;
    property WriteValues[Index : Integer] : Word read GetWriteValues write SetWriteValues;
  end;

  TBuilderMBTCPF24Request = class(TBuilderMBTCPPacket)
   private
    FFunctionCode        : Byte;
    FFIFOPointerAddress  : Word;
   public
    constructor Create(AOwner : TComponent); override;
    procedure Build; override;
    property FIFOPointerAddress  : Word read FFIFOPointerAddress write FFIFOPointerAddress;
   end;

  TBuilderMBTCPF43Request = class(TBuilderMBTCPPacket)
   private
    FFunctionCode     : Byte;
    FMEIType          : Byte;
    FReadDeviceIDCode : Byte;
    FObjectID         : Byte;
    function  GetMEIType: TMEIType;
    function  GetObjectID: TObjectID;
    function  GetReadDeviceIDCode: TReadDeviceIDCode;
    procedure SetMEIType(const Value: TMEIType);
    procedure SetObjectID(const Value: TObjectID);
    procedure SetReadDeviceIDCode(const Value: TReadDeviceIDCode);
   public
    constructor Create(AOwner : TComponent); override;
    procedure Build; override;
    property MEIType          : TMEIType read GetMEIType write SetMEIType;
    property ReadDeviceIDCode : TReadDeviceIDCode read GetReadDeviceIDCode write SetReadDeviceIDCode;
    property ObjectID         : TObjectID read GetObjectID write SetObjectID;
  end;

  TBuilderMBTCPF72Request = class(TBuilderMBTCPPacket)
  private
    FChkRKey     : Byte;
    FExpectedKey : Byte;
    procedure SetChkRKey(const Value: Byte);
  protected
    procedure SetQuantity(const Value: Word); override;
  public
    constructor Create(AOwner : TComponent); override;
    procedure Build; override;
    procedure RebuilAtNextKey;
    property ChkRKey     : Byte read FChkRKey write SetChkRKey default $55;
    property ExpectedKey : Byte read FExpectedKey;
  end;

  TBuilderMBTCPF110Request = class(TBuilderMBTCPPacket)
  private
    FChkWKey     : Byte;
    FByteCount   : Byte;
    FRegValues   : TWordValueArray;
    FExpectedKey : Byte;
    function  GetRegValues(Index: Integer): Word;
    procedure SetRegValues(Index: Integer; const Value: Word);
    procedure SetChkWKey(const Value: Byte);
  protected
    procedure SetQuantity(const Value: Word); override;
  public
    constructor Create(AOwner : TComponent); override;
    function  AreEquivalent(Source : array of Byte): Boolean;
    procedure Assign(Source : array of Byte); reintroduce;
    procedure Build; override;
    procedure RebuilAtNextKey;
    property ChkWKey     : Byte read FChkWKey write SetChkWKey default $55;
    property ExpectedKey : Byte read FExpectedKey;
    property RegValues[Index : Integer] : Word read GetRegValues write SetRegValues;
  end;



implementation

uses SysUtils,
     MBResourceString,
     CRC16Func;

{ TBuilderMBTCPF1Request }

constructor TBuilderMBTCPF1Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=1;
end;

procedure TBuilderMBTCPF1Request.Build;
begin
  GetPacketMem;
  PMBTCPF1Request(FPacket)^.TCPHeader.TransactioID := Swap(FTransactionID);
  PMBTCPF1Request(FPacket)^.TCPHeader.ProtocolID   := Swap(FProtocolID);
  PMBTCPF1Request(FPacket)^.TCPHeader.Length       := Swap(FLen);
  PMBTCPF1Request(FPacket)^.Header.DeviceAddress   := FDeviceAddress;
  PMBTCPF1Request(FPacket)^.Header.FunctionCode    := FFunctionNum;
  PMBTCPF1Request(FPacket)^.Header.StartingAddress := Swap(FStartingAddress);
  PMBTCPF1Request(FPacket)^.Header.Quantity        := Swap(FQuantity);
  Notify(betBuild);
end;

procedure TBuilderMBTCPF1Request.SetQuantity(const Value: Word);
var TempByteCount : Word;
begin
  if (Value<1) or (Value>cMaxBitRegCount) then raise Exception.Create(erMBF1PacketBuild);
  inherited SetQuantity(Value);
  FLenPacket    := sizeof(TMBTCPF1Request);
  FLen          := FLenPacket-6;
  TempByteCount :=  Value div 8;
  if (TempByteCount mod 8)>0 then Inc(TempByteCount);
  FResponseSize :=11+TempByteCount;
end;

{ TBuilderMBTCPF2Request }

constructor TBuilderMBTCPF2Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=2;
end;

{ TBuilderMBTCPF3Request }

constructor TBuilderMBTCPF3Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=3;
end;

procedure TBuilderMBTCPF3Request.SetQuantity(const Value: Word);
begin
  if (Value<1) or (Value>cMaxWordRegCount) then raise Exception.Create(erMBF3PacketBuild);
  inherited SetQuantity(Value);
  FResponseSize:=11+Value*2;
end;

{ TBuilderMBTCPF4Request }

constructor TBuilderMBTCPF4Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=4;
end;

{ TBuilderMBTCPF5Request }

constructor TBuilderMBTCPF5Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=5;
end;

procedure TBuilderMBTCPF5Request.Build;
begin
  FLenPacket:=sizeof(TMBTCPF1Request);
  GetPacketMem;
  PMBTCPF1Request(FPacket)^.TCPHeader.TransactioID := Swap(FTransactionID);
  PMBTCPF1Request(FPacket)^.TCPHeader.ProtocolID   := Swap(FProtocolID);
  PMBTCPF1Request(FPacket)^.TCPHeader.Length       := Swap(FLenPacket-6);
  PMBTCPF1Request(FPacket)^.Header.DeviceAddress   := FDeviceAddress;
  PMBTCPF1Request(FPacket)^.Header.FunctionCode    := FFunctionNum;
  PMBTCPF1Request(FPacket)^.Header.StartingAddress := Swap(FOutputAddress);
  PMBTCPF1Request(FPacket)^.Header.Quantity        := Swap(FOutputValue);
  Notify(betBuild);
end;

function TBuilderMBTCPF5Request.GetOutputValue: Boolean;
begin
  Result:=FOutputValue<>0;
end;

procedure TBuilderMBTCPF5Request.SetOutputValue(const Value: Boolean);
begin
  if Value then FOutputValue:=$00FF
  else FOutputValue:=0;
end;

{ TBuilderMBTCPF6Request }

constructor TBuilderMBTCPF6Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=6;
end;

procedure TBuilderMBTCPF6Request.Build;
begin
  FLenPacket:=sizeof(TMBTCPF1Request);
  GetPacketMem;
  PMBTCPF1Request(FPacket)^.TCPHeader.TransactioID := Swap(FTransactionID);
  PMBTCPF1Request(FPacket)^.TCPHeader.ProtocolID   := Swap(FProtocolID);
  PMBTCPF1Request(FPacket)^.TCPHeader.Length       := Swap(FLenPacket-6);
  PMBTCPF1Request(FPacket)^.Header.DeviceAddress   := FDeviceAddress;
  PMBTCPF1Request(FPacket)^.Header.FunctionCode    := FFunctionNum;
  PMBTCPF1Request(FPacket)^.Header.StartingAddress := Swap(FRegisterAddress);
  PMBTCPF1Request(FPacket)^.Header.Quantity        := Swap(FRegisterValue);
  Notify(betBuild);
end;

procedure TBuilderMBTCPF6Request.SetRegisterValue(const Value: Word);
begin
  FRegisterValue := Swap(Value);
end;

{ TBuilderMBTCPF15Request }

constructor TBuilderMBTCPF15Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=15;
  FBits:=TBits.Create;
end;

destructor TBuilderMBTCPF15Request.Destroy;
begin
  FBits.Free;
  inherited;
end;

function TBuilderMBTCPF15Request.AreEquivalent(Source: TBits): Boolean;
var i,Count,Counter : Integer;
begin
  Result:=False;
  if FBits.Size<>Source.Size then Exit;
  Counter:=0;
  Count:=FBits.Size-1;
  for i:=0 to Count do if FBits.Bits[i] = Source.Bits[i] then Inc(Counter);
  Result := Counter = (Count+1);
end;

procedure TBuilderMBTCPF15Request.Assign(Source: TBits);
var i,Count : Integer;
begin
  if Source = nil then Exit;
  Count:=Source.Size-1;
  FBits.Size:=Count+1;
  for i:=0 to Count do FBits.Bits[i]:=Source.Bits[i];
end;

procedure TBuilderMBTCPF15Request.Build;
var TempBuff  : PByteArray;
    ByteIndex : Integer;
    BitIndex  : Integer;
    i         : Integer;
begin
 PMBTCPF15Request(FPacket)^.TCPHeader.TransactioID        := Swap(FTransactionID);
 PMBTCPF15Request(FPacket)^.TCPHeader.ProtocolID          := Swap(FProtocolID);
 PMBTCPF15Request(FPacket)^.TCPHeader.Length              := Swap(FLen);
 PMBTCPF15Request(FPacket)^.Header.Header.DeviceAddress   := FDeviceAddress;
 PMBTCPF15Request(FPacket)^.Header.Header.FunctionCode    := FFunctionNum;
 PMBTCPF15Request(FPacket)^.Header.Header.StartingAddress := Swap(FStartingAddress);
 PMBTCPF15Request(FPacket)^.Header.Header.Quantity        := Swap(FQuantity);
 PMBTCPF15Request(FPacket)^.Header.ByteCount              := FByteCount;
 TempBuff:=Pointer(PtrUInt(@PMBF15Request(FPacket)^.ByteCount) + 1);  // указатель на массив байт данных
 for i := 0 to FBits.Size-1 do
  begin
   ByteIndex:=i div 8;
   BitIndex:= i mod 8;
   case BitIndex of
     0 : if FBits.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 1
          else
           if (TempBuff^[ByteIndex] and 1)=1 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 1;
     1 :if FBits.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 2
          else
           if (TempBuff^[ByteIndex] and 2)=2 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 2;
     2 :if FBits.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 4
          else
           if (TempBuff^[ByteIndex] and 4)=4 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 4;
     3 :if FBits.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 8
          else
           if (TempBuff^[ByteIndex] and 8)=8 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 8;
     4 :if FBits.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 16
          else
           if (TempBuff^[ByteIndex] and 16)=16 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 16;
     5 :if FBits.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 32
          else
           if (TempBuff^[ByteIndex] and 32)=32 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 32;
     6 :if FBits.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 64
          else
           if (TempBuff^[ByteIndex] and 64)=64 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 64;
     7 :if FBits.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 128
          else
           if (TempBuff^[ByteIndex] and 128)=128 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 128;
   end;
  end;
 Notify(betBuild);
end;

function TBuilderMBTCPF15Request.GetBits(Index: Integer): Boolean;
begin
  Result:=FBits.Bits[Index];
end;

procedure TBuilderMBTCPF15Request.SetBits(Index: Integer; const Value: Boolean);
begin
  FBits.Bits[Index]:=Value;
end;

procedure TBuilderMBTCPF15Request.SetQuantity(const Value: Word);
begin
  if FQuantity = Value then Exit;
  FByteCount:= FQuantity div 8;
  if (FQuantity mod 8)>0 then FByteCount:=FByteCount+1;
  FBits.Size:=Value;
  ClearPacket;
  FLenPacket:=sizeof(TMBTCPF15Request)+FByteCount;
  GetPacketMem;
  FLen := FLenPacket - 6;
  FResponseSize := 12;
end;

{ TBuilderMBTCPF16Request }

constructor TBuilderMBTCPF16Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=16;
end;

function TBuilderMBTCPF16Request.AreEquivalent(Source: array of Byte): Boolean;
var TempByteCount : Byte;
begin
  Result:=False;
  TempByteCount:=Length(Source);
  if TempByteCount <> FByteCount then Exit;
  Result := CompareMem(@FRegValues[0],@Source[0],TempByteCount);
end;

procedure TBuilderMBTCPF16Request.Assign(Source: array of Byte);
var TempLength : Integer;
begin
  TempLength := Length(Source);
  if TempLength = 0 then Exit;
  if TempLength <> FByteCount then Exit;
  Move(Source[0],FRegValues[0], TempLength);
end;

procedure TBuilderMBTCPF16Request.Build;
var TempBuff  : PWordValueArray;
    i         : Integer;
begin
 PMBTCPF16Request(FPacket)^.TCPHeader.TransactioID        := Swap(FTransactionID);
 PMBTCPF16Request(FPacket)^.TCPHeader.ProtocolID          := Swap(FProtocolID);
 PMBTCPF16Request(FPacket)^.TCPHeader.Length              := Swap(FLen);
 PMBTCPF16Request(FPacket)^.Header.Header.DeviceAddress   := FDeviceAddress;
 PMBTCPF16Request(FPacket)^.Header.Header.FunctionCode    := FFunctionNum;
 PMBTCPF16Request(FPacket)^.Header.Header.StartingAddress := Swap(FStartingAddress);
 PMBTCPF16Request(FPacket)^.Header.Header.Quantity        := Swap(FQuantity);
 PMBTCPF16Request(FPacket)^.Header.ByteCount              := FByteCount;
 TempBuff:=Pointer(PtrUInt(@PMBF16Request(FPacket)^.ByteCount) + 1);
 for i := 0 to FQuantity-1 do
  begin
   TempBuff^[i]:=Swap(FRegValues[i]);
  end;
 Notify(betBuild);
end;

function TBuilderMBTCPF16Request.GetRegValues(Index: Integer): Word;
begin
  Result:=FRegValues[Index];
end;

procedure TBuilderMBTCPF16Request.SetQuantity(const Value: Word);
begin
  if (Value<1) or (Value>123) then raise Exception.Create(erMBF16PacketBuild);
  if Value=FQuantity then Exit;
  FQuantity := Value;
  FByteCount := FQuantity*2;
  ClearPacket;
  FLenPacket:=sizeof(TMBTCPF15Request)+FByteCount;
  GetPacketMem;
  FLen := FLenPacket - 6;
  FResponseSize := 12;
end;

procedure TBuilderMBTCPF16Request.SetRegValues(Index: Integer; const Value: Word);
begin
  FRegValues[Index]:=Value;
end;

{ TBuilderMBTCPF20Request }

constructor TBuilderMBTCPF20Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=20;
end;

procedure TBuilderMBTCPF20Request.Build;
begin
  FLenPacket := 0;
  GetPacketMem;
  // заглушка
end;

{ TBuilderMBTCPF21Request }

constructor TBuilderMBTCPF21Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=21;
end;

procedure TBuilderMBTCPF21Request.Build;
begin
  FLenPacket := 0;
  GetPacketMem;
  // заглушка
end;

{ TBuilderMBTCPF22Request }

constructor TBuilderMBTCPF22Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=22;
end;

procedure TBuilderMBTCPF22Request.Build;
begin
 FLenPacket:=sizeof(TMBTCPF22Request);
 FLen := FLenPacket - 6;
 FResponseSize := 14;
 GetPacketMem;
 PMBTCPF22Request(FPacket)^.TCPHeader.TransactioID  := Swap(FTransactionID);
 PMBTCPF22Request(FPacket)^.TCPHeader.ProtocolID    := Swap(FProtocolID);
 PMBTCPF22Request(FPacket)^.TCPHeader.Length        := Swap(FLen);
 PMBTCPF22Request(FPacket)^.Header.DeviceAddress    := FDeviceAddress;
 PMBTCPF22Request(FPacket)^.Header.FunctionCode     := FFunctionCode;
 PMBTCPF22Request(FPacket)^.Header.ReferenceAddress := Swap(FReferenceAddress);
 PMBTCPF22Request(FPacket)^.Header.AndMask          := Swap(FAndMask);
 PMBTCPF22Request(FPacket)^.Header.OrMask           := Swap(FOrMask);
 Notify(betBuild);
end;

{ TBuilderMBTCPF23Request }

constructor TBuilderMBTCPF23Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode:=23;
  FReadStartAddress:=0;
  FReadQuantity:=1;
  FWriteStartAddress:=0;
  FWriteQuantity:=1;
  FWriteByteCount:=2;
end;

function TBuilderMBTCPF23Request.AreEquivalent(Source: array of Byte): Boolean;
var TempByteCount : Byte;
begin
  Result:=False;
  TempByteCount:=Length(Source);
  if TempByteCount <> FWriteByteCount then Exit;
  Result := CompareMem(@FWriteValues[0],@Source[0],TempByteCount);
end;

procedure TBuilderMBTCPF23Request.Assign(Source: array of Byte);
var TempLength : Integer;
begin
  TempLength := Length(Source);
  if TempLength = 0 then Exit;
  if TempLength <> FWriteByteCount then Exit;
  Move(Source[0],FWriteValues[0], TempLength);
end;

procedure TBuilderMBTCPF23Request.Build;
var TempBuff  : PWordValueArray;
    i         : Integer;
begin
  PMBTCPF23RequestHeader(FPacket)^.TCPHeader.TransactioID               := Swap(FTransactionID);
  PMBTCPF23RequestHeader(FPacket)^.TCPHeader.ProtocolID                 := Swap(FProtocolID);
  PMBTCPF23RequestHeader(FPacket)^.TCPHeader.Length                     := Swap(FLen);
  PMBTCPF23RequestHeader(FPacket)^.Header.DeviceAddress                 := FDeviceAddress;
  PMBTCPF23RequestHeader(FPacket)^.Header.FunctionCode                  := FFunctionCode;
  PMBTCPF23RequestHeader(FPacket)^.Header.RequestData.ReadStartAddress  := Swap(FReadStartAddress);
  PMBTCPF23RequestHeader(FPacket)^.Header.RequestData.ReadQuantity      := Swap(FReadQuantity);
  PMBTCPF23RequestHeader(FPacket)^.Header.RequestData.WriteStartAddress := Swap(FWriteStartAddress);
  PMBTCPF23RequestHeader(FPacket)^.Header.RequestData.WriteQuantity     := Swap(FWriteQuantity);
  PMBTCPF23RequestHeader(FPacket)^.Header.RequestData.WriteByteCount    := FWriteByteCount;
  TempBuff:=Pointer(PtrUInt(@PMBTCPF23RequestHeader(FPacket)^.Header.RequestData.WriteByteCount) + 1);
  for i := 0 to FWriteQuantity-1 do
   begin
    TempBuff^[i]:=Swap(FWriteValues[i]);
   end;
  Notify(betBuild);
end;

function TBuilderMBTCPF23Request.GetWriteValues(Index: Integer): Word;
begin
  if (Index<0)or(Index>FWriteQuantity) then raise Exception.Create(erMBF23PacketBuild);
 Result:=FWriteValues[Index];
end;

procedure TBuilderMBTCPF23Request.SetReadQuantity(const Value: Word);
begin
  if (Value<1)or(Value>$7D) then raise Exception.Create(erMBF3PacketBuild);
  FReadQuantity := Value;
  FResponseSize := 9+Value*2;
end;

procedure TBuilderMBTCPF23Request.SetWriteQuantity(const Value: Word);
begin
  if (Value<1)or(Value>$79) then raise Exception.Create(erMBF23PacketBuild1);
  if FWriteQuantity = Value then Exit;
  FWriteQuantity := Value;
  FWriteByteCount := Value*2;
  ClearPacket;
  FLenPacket := sizeof(TMBTCPF23RequestHeader)+FWriteByteCount;
  FLen := FLenPacket - 6;
  GetPacketMem;
end;

procedure TBuilderMBTCPF23Request.SetWriteValues(Index: Integer; const Value: Word);
begin
  if (Index<0)or(Index>FWriteQuantity) then raise Exception.Create(erMBF23PacketBuild);
  FWriteValues[Index]:=Value;
end;

{ TBuilderMBTCPF24Request }

constructor TBuilderMBTCPF24Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=24;
end;

procedure TBuilderMBTCPF24Request.Build;
begin
  FLenPacket:=sizeof(TMBTCPF24Request);
  FLen := FLenPacket-6;
  GetPacketMem;
  PMBTCPF24Request(FPacket)^.TCPHeader.TransactioID    := Swap(FTransactionID);
  PMBTCPF24Request(FPacket)^.TCPHeader.ProtocolID      := Swap(FProtocolID);
  PMBTCPF24Request(FPacket)^.TCPHeader.Length          := Swap(FLen);
  PMBTCPF24Request(FPacket)^.Header.DeviceAddress      := FDeviceAddress;
  PMBTCPF24Request(FPacket)^.Header.FunctionCode       := FFunctionCode;
  PMBTCPF24Request(FPacket)^.Header.FIFOPointerAddress := Swap(FFIFOPointerAddress);
  Notify(betBuild);
end;

{ TBuilderMBTCPF43Request }

constructor TBuilderMBTCPF43Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode:=43;
  FMEIType:=$0E;
  FReadDeviceIDCode:=1;
  FObjectID:=0;
end;

procedure TBuilderMBTCPF43Request.Build;
begin
 case TMEIType(FMEIType) of
  mei14 : begin
           FLenPacket:=sizeof(TMBTCPF43_14Request);
           FLen := FLenPacket - 6;
           GetPacketMem;
           PMBTCPF43_14Request(FPacket)^.TCPHeader.TransactioID              := Swap(FTransactionID);
           PMBTCPF43_14Request(FPacket)^.TCPHeader.ProtocolID                := Swap(FProtocolID);
           PMBTCPF43_14Request(FPacket)^.TCPHeader.Length                    := Swap(FLen);
           PMBTCPF43_14Request(FPacket)^.Header.DeviceAddress                := FDeviceAddress;
           PMBTCPF43_14Request(FPacket)^.Header.FunctionCode                 := FFunctionCode;
           PMBTCPF43_14Request(FPacket)^.Header.RequestData.MEIType          := FMEIType;
           PMBTCPF43_14Request(FPacket)^.Header.RequestData.ReadDeviceIDCode := FReadDeviceIDCode;
           PMBTCPF43_14Request(FPacket)^.Header.RequestData.ObjectID         := FObjectID;
          end;
 else
  raise Exception.Create(erMBF43PacketBuild);
 end;
 Notify(betBuild);
end;

function TBuilderMBTCPF43Request.GetMEIType: TMEIType;
begin
  Result := TMEIType(FMEIType);
end;

function TBuilderMBTCPF43Request.GetObjectID: TObjectID;
begin
 Result:=TObjectID(FObjectID);
end;

function TBuilderMBTCPF43Request.GetReadDeviceIDCode: TReadDeviceIDCode;
begin
 Result:=TReadDeviceIDCode(FReadDeviceIDCode);
end;

procedure TBuilderMBTCPF43Request.SetMEIType(const Value: TMEIType);
begin
 if Value = mei13 then raise Exception.Create(erMBF43PacketBuild);
 FMEIType := ord(Value);
end;

procedure TBuilderMBTCPF43Request.SetObjectID(const Value: TObjectID);
begin
 if Value<>oiVendorName then raise Exception.Create(erMBF43PacketBuild);
 FObjectID:=ord(Value);
end;

procedure TBuilderMBTCPF43Request.SetReadDeviceIDCode(const Value: TReadDeviceIDCode);
begin
 if Value<>rdic_01 then  raise Exception.Create(erMBF43PacketBuild);
 FReadDeviceIDCode:=ord(Value);
end;

{ TBuilderMBTCPF72Request }

constructor TBuilderMBTCPF72Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FChkRKey     := $55;
  FExpectedKey := $AA;
  FFunctionNum := 72;
end;

procedure TBuilderMBTCPF72Request.Build;
begin
  FLenPacket:=sizeof(TMBTCPF72Request);
  FLen := FLenPacket - 6;
  GetPacketMem;
  PMBTCPF72Request(FPacket)^.TCPHeader.TransactioID := Swap(FTransactionID);
  PMBTCPF72Request(FPacket)^.TCPHeader.ProtocolID   := Swap(FProtocolID);
  PMBTCPF72Request(FPacket)^.TCPHeader.Length       := Swap(FLen);
  PMBTCPF72Request(FPacket)^.Header.DeviceAddress   := FDeviceAddress;
  PMBTCPF72Request(FPacket)^.Header.FunctionCode    := FFunctionNum;
  PMBTCPF72Request(FPacket)^.Header.StartingAddress := Swap(FStartingAddress);
  PMBTCPF72Request(FPacket)^.Header.ChkRKey         := FChkRKey;
  PMBTCPF72Request(FPacket)^.Header.Quantity        := FQuantity;
  Notify(betBuild);
end;

procedure TBuilderMBTCPF72Request.RebuilAtNextKey;
begin
  case ChkRKey of
   $55 : ChkRKey:=$AA;
   $AA : ChkRKey:=$55;
  end;
  Build;
end;

procedure TBuilderMBTCPF72Request.SetChkRKey(const Value: Byte);
begin
  if (Value<>$55) and (Value<>$AA) then Exception.Create(erMBF72PacketBuild1);
  if FChkRKey = Value then Exit;
  FChkRKey := Value;
  case FChkRKey of
   $55 : FExpectedKey:=$AA;
   $AA : FExpectedKey:=$55;
  end;
end;

procedure TBuilderMBTCPF72Request.SetQuantity(const Value: Word);
begin
  if (Value<1) or (Value>8) then raise Exception.Create(erMBF72PacketBuild);
  inherited SetQuantity(Value);
  FResponseSize:=11+Value*2+2;
end;

{ TBuilderMBTCPF110Request }

constructor TBuilderMBTCPF110Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum := 110;
  FChkWKey     := $55;
  FExpectedKey := $AA;
end;

function TBuilderMBTCPF110Request.AreEquivalent(Source: array of Byte): Boolean;
var TempByteCount : Byte;
begin
  Result:=False;
  TempByteCount:=Length(Source);
  if TempByteCount <> FByteCount then Exit;
  Result := CompareMem(@FRegValues[0],@Source[0],TempByteCount);
end;

procedure TBuilderMBTCPF110Request.Assign(Source: array of Byte);
var TempLength : Integer;
begin
  TempLength := Length(Source);
  if TempLength = 0 then Exit;
  if TempLength <> FByteCount then Exit;
  Move(Source[0],FRegValues[0], TempLength);
end;

procedure TBuilderMBTCPF110Request.Build;
var TempBuff  : PWordValueArray;
    i         : Integer;
begin
 FLenPacket:=sizeof(TMBTCPF110RequestHeader)+3+FByteCount+2;
 FLen:=FLenPacket-6;
 GetPacketMem;

 PMBTCPF110RequestHeader(FPacket)^.TCPHeader.TransactioID := Swap(FTransactionID);
 PMBTCPF110RequestHeader(FPacket)^.TCPHeader.ProtocolID   := Swap(FProtocolID);
 PMBTCPF110RequestHeader(FPacket)^.TCPHeader.Length       := Swap(FLen);
 PMBTCPF110RequestHeader(FPacket)^.Header.DeviceAddress   := FDeviceAddress;
 PMBTCPF110RequestHeader(FPacket)^.Header.FunctionCode    := FFunctionNum;
 PMBTCPF110RequestHeader(FPacket)^.Header.ChkWKey         := FChkWKey;

 Word(Pointer(PtrUInt(@PMBTCPF110RequestHeader(FPacket)^.Header.ChkWKey) + 1)^):= Swap(FStartingAddress);
 Byte(Pointer(PtrUInt(@PMBTCPF110RequestHeader(FPacket)^.Header.ChkWKey) + 3)^):= FQuantity;

 TempBuff:=Pointer(PtrUInt(@PMBTCPF110RequestHeader(FPacket)^.Header.ChkWKey) + 4);
 for i := 0 to FQuantity-1 do
  begin
   TempBuff^[i]:=Swap(FRegValues[i]);
  end;

 Word(Pointer(PtrUInt(FPacket)+FLenPacket-2)^):=GetCRC16(Pointer(PtrUInt(@PMBTCPF110RequestHeader(FPacket)^.Header.ChkWKey) + 1),3+FByteCount);

 Notify(betBuild);
end;

function TBuilderMBTCPF110Request.GetRegValues(Index: Integer): Word;
begin
  Result:= FRegValues[Index];
end;

procedure TBuilderMBTCPF110Request.RebuilAtNextKey;
begin
  case ChkWKey of
   $55 : ChkWKey:=$AA;
   $AA : ChkWKey:=$55;
  end;
  Build;
end;

procedure TBuilderMBTCPF110Request.SetChkWKey(const Value: Byte);
begin
  if (Value<>$55) and (Value<>$AA) then Exception.Create(erMBF110PacketBuild1);
  if FChkWKey = Value then Exit;
  FChkWKey := Value;
  case FChkWKey of
   $55 : FExpectedKey:=$AA;
   $AA : FExpectedKey:=$55;
  end;
end;

procedure TBuilderMBTCPF110Request.SetQuantity(const Value: Word);
begin
  if (Value<1) or (Value>8) then raise Exception.Create(erMBF110PacketBuild);
  if Value = FQuantity then Exit;
  FQuantity := Value;
  FByteCount := FQuantity*2;
end;

procedure TBuilderMBTCPF110Request.SetRegValues(Index: Integer; const Value: Word);
begin
  FRegValues[Index]:=Value;
end;

end.

unit MBBuilderRTUPacketClasses;

{$mode objfpc}{$H+}

{
  Реализация классов строителей запросов для
  MODBUS TCP Application Protocol Specification V1.1b
  Modbus TCP поддерживаются функции: 1,2,3,4,5,6,15,16,20,21,22,23,24,43,43/13,43/14
  Modbus RTU поддержифаются функции: все Modbus TCP,7,8,11,12,17
}

interface

uses Classes,
     MBBuilderBase, MBBuilderPacketClasses, MBRequestTypes;

type
  TBuilderMBF1Request = class(TBuilderMBRTUPacket)
  protected
   procedure SetQuantity(const Value: Word); override;
  public
   constructor Create(AOwner : TComponent); override;
   procedure Build; override;
 end;

 TBuilderMBF2Request = class(TBuilderMBF1Request)
  constructor Create(AOwner : TComponent); override;
 end;

 TBuilderMBF3Request = class(TBuilderMBF1Request)
  protected
   procedure SetQuantity(const Value: Word); override;
  public
   constructor Create(AOwner : TComponent); override;
 end;

 TBuilderMBF4Request = class(TBuilderMBF3Request)
  constructor Create(AOwner : TComponent); override;
 end;

 TBuilderMBF5Request = class(TBuilderMBRTUPacket)
  private
   function  GetOutputValue: Boolean;
   procedure SetOutputValue(const Value: Boolean);
  protected
   FOutputAddress : Word;
   FOutputValue   : Word;
  public
   constructor Create(AOwner : TComponent); override;
   procedure Build; override;
   property OutputAddress : Word read FOutputAddress write FOutputAddress;
   property OutputValue   : Boolean read GetOutputValue write SetOutputValue;
 end;

 TBuilderMBF6Request = class(TBuilderMBRTUPacket)
  protected
   FRegisterAddress : Word;
   FRegisterValue   : Word;
   procedure SetRegisterValue(const Value: Word);
  public
   constructor Create(AOwner : TComponent); override;
   procedure Build; override;
   property RegisterAddress : Word read FRegisterAddress write FRegisterAddress;
   property RegisterValue   : Word read FRegisterValue write SetRegisterValue;
 end;

 TBuilderMBF7Request = class(TBuilderMBRTUPacket)
  public
   constructor Create(AOwner : TComponent); override;
   procedure Build; override;
 end;

 TBuilderMBF8Request = class(TBuilderMBRTUPacket)
  private
   FSubfunctionNum  : Word;
   FData            : Word;
   function  GetChar: Char;
   function  GetRestartData: Boolean;
   function  GetSubFunctionNum: TMBF8SubfunctionType;
   procedure SetChar(const Value: Char);
   procedure SetRestartData(const Value: Boolean);
   procedure SetSubFunctionNum(const Value: TMBF8SubfunctionType);
  public
   constructor Create(AOwner : TComponent); override;
   procedure Build; override;
   property SubFunctionNum : TMBF8SubfunctionType read GetSubFunctionNum write SetSubFunctionNum;
   property Sub_00_LoopBackData   : Word read FData write FData;
   property Sub_01_RestartData    : Boolean read GetRestartData write SetRestartData;
   property Sub_03_Char           : Char read GetChar write SetChar;
  end;

  TBuilderMBF11Request = class(TBuilderMBF7Request)
   constructor Create(AOwner : TComponent); override;
  end;

  TBuilderMBF12Request = class(TBuilderMBF7Request)
   constructor Create(AOwner : TComponent); override;
  end;

  TBuilderMBF15Request = class(TBuilderMBF1Request)
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

  TBuilderMBF16Request = class(TBuilderMBF1Request)
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

  TBuilderMBF17Request = class(TBuilderMBF7Request)
   constructor Create(AOwner : TComponent); override;
  end;

  TBuilderMBF20Request = class(TBuilderPacketBase) // пока не реализовано
  public
    procedure Build; override;
  end;

  TBuilderMBF21Request = class(TBuilderPacketBase) // пока не реализовано
  public
    procedure Build; override;
  end;

  TBuilderMBF22Request = class(TBuilderMBRTUPacket)
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

  TBuilderMBF23Request = class(TBuilderMBRTUPacket)
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

  TBuilderMBF24Request = class(TBuilderMBRTUPacket)
   private
    FFunctionCode        : Byte;
    FFIFOPointerAddress  : Word;
   public
    constructor Create(AOwner : TComponent); override;
    procedure Build; override;
    property FIFOPointerAddress  : Word read FFIFOPointerAddress write FFIFOPointerAddress;
   end;

  TBuilderMBF43Request = class(TBuilderMBRTUPacket)
   private
    FFunctionCode     : Byte;
    FMEIType          : Byte;
    FReadDeviceIDCode : Byte;
    FObjectID         : Byte;
    function GetMEIType: TMEIType;
    function GetObjectID: TObjectID;
    function GetReadDeviceIDCode: TReadDeviceIDCode;
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

  TBuilderMBF72Request = class(TBuilderMBRTUPacket)
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

  TBuilderMBF110Request = class(TBuilderMBRTUPacket)
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

{ TBuildMBF1Request }

procedure TBuilderMBF1Request.Build;
begin
  FLenPacket := sizeof(TMBF1Request);
  GetPacketMem;
  PMBF1Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
  PMBF1Request(FPacket)^.Header.FunctionCode:=FFunctionNum;
  PMBF1Request(FPacket)^.Header.StartingAddress:=Swap(FStartingAddress);
  PMBF1Request(FPacket)^.Header.Quantity:=Swap(FQuantity);
  PMBF1Request(FPacket)^.CRC:=GetCRC16(FPacket,sizeof(TMBF1_6FRequestHeader));
  Notify(betBuild);
end;

constructor TBuilderMBF1Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=1;
end;

procedure TBuilderMBF1Request.SetQuantity(const Value: Word);
begin
  if (Value<1) or (Value>cMaxBitRegCount) then raise Exception.Create(erMBF1PacketBuild);
  inherited SetQuantity(Value);
end;

{ TBuildMBF2Request }

constructor TBuilderMBF2Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=2;
end;

{ TBuildMBF3Request }

constructor TBuilderMBF3Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=3;
end;

procedure TBuilderMBF3Request.SetQuantity(const Value: Word);
begin
  if (Value<1) or (Value>cMaxWordRegCount) then raise Exception.Create(erMBF3PacketBuild);
  inherited SetQuantity(Value);
  FResponseSize:=5+Value*2;
end;

{ TBuildMBF4Request }

constructor TBuilderMBF4Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=4;
end;

{ TBuildMBF5Request }

procedure TBuilderMBF5Request.Build;
begin
  FLenPacket:=sizeof(TMBF1Request);
  GetPacketMem;
  PMBF1Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
  PMBF1Request(FPacket)^.Header.FunctionCode:=FFunctionNum;
  PMBF1Request(FPacket)^.Header.StartingAddress:=Swap(FOutputAddress);
  PMBF1Request(FPacket)^.Header.Quantity:=Swap(FOutputValue);
  PMBF1Request(FPacket)^.CRC:=GetCRC16(FPacket,sizeof(TMBF1_6FRequestHeader));
  Notify(betBuild);
end;

constructor TBuilderMBF5Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=5;
end;

function TBuilderMBF5Request.GetOutputValue: Boolean;
begin
 Result:=FOutputValue<>0;
end;

procedure TBuilderMBF5Request.SetOutputValue(const Value: Boolean);
begin
 if Value then FOutputValue:=$00FF
  else FOutputValue:=0;
end;

{ TBuildMBF6Request }

procedure TBuilderMBF6Request.Build;
begin
  FLenPacket:=sizeof(TMBF1Request);
  GetPacketMem;
  PMBF1Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
  PMBF1Request(FPacket)^.Header.FunctionCode:=FFunctionNum;
  PMBF1Request(FPacket)^.Header.StartingAddress:=Swap(FRegisterAddress);
  PMBF1Request(FPacket)^.Header.Quantity:=Swap(FRegisterValue);
  PMBF1Request(FPacket)^.CRC:=GetCRC16(FPacket,sizeof(TMBF1_6FRequestHeader));
  Notify(betBuild);
end;

constructor TBuilderMBF6Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=6;
end;

procedure TBuilderMBF6Request.SetRegisterValue(const Value: Word);
begin
  FRegisterValue := Swap(Value);
end;

{ TBuilderMBF7Request }

procedure TBuilderMBF7Request.Build;
begin
  FLenPacket:=sizeof(TMBF7Request);
  GetPacketMem;
  PMBF7Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
  PMBF7Request(FPacket)^.Header.FunctionCode:=FFunctionNum;
  PMBF7Request(FPacket)^.CRC:=GetCRC16(FPacket,sizeof(TMBF7RequestHeader));
  Notify(betBuild);
end;

constructor TBuilderMBF7Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=7;
end;

{ TBuilderMBF8Request }

procedure TBuilderMBF8Request.Build;
begin
 FLenPacket:=sizeof(TMBF8Request);
 GetPacketMem;
 PMBF8Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
 PMBF8Request(FPacket)^.Header.FunctionCode:=FFunctionNum;
 PMBF8Request(FPacket)^.Header.SubFunctionCode:=FSubfunctionNum;
 PMBF8Request(FPacket)^.Header.Data:=Swap(FData);
 PMBF8Request(FPacket)^.CRC:=GetCRC16(FPacket,sizeof(TMBF8RequestHeader));
 Notify(betBuild);
end;

constructor TBuilderMBF8Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=8;
  FData:=0;
end;

function TBuilderMBF8Request.GetChar: Char;
var TempByte : Byte;
begin
 TempByte:=FData shr 8;
 Result:=Char(TempByte);
end;

procedure TBuilderMBF8Request.SetChar(const Value: Char);
begin
  FData:=ord(Value);
  FData:= FData shl 8;
end;

function TBuilderMBF8Request.GetRestartData: Boolean;
begin
 Result:=FData<>0;
end;

procedure TBuilderMBF8Request.SetRestartData(const Value: Boolean);
begin
 if Value then FData:=$FF00
  else FData:=0;
end;

function TBuilderMBF8Request.GetSubFunctionNum: TMBF8SubfunctionType;
var TempByte : Byte;
begin
  TempByte:= FSubfunctionNum;
  Result:= TMBF8SubfunctionType(TempByte);
end;

procedure TBuilderMBF8Request.SetSubFunctionNum(const Value: TMBF8SubfunctionType);
begin
  if Value=TMBF8SubfunctionType(FSubfunctionNum) then Exit;
  FSubfunctionNum:=ord(Value);
  case Value of
   Sub_00 : ;
   Sub_01 : ;
   Sub_03 : ;
   Sub_02, Sub_04,
   Sub_0A, Sub_0B,
   Sub_0C, Sub_0D,
   Sub_0E, Sub_0F,
   Sub_10, Sub_11,
   Sub_12, Sub_14 : FData:=0;
  end;
end;

{ TBuilderMBF11Request }

constructor TBuilderMBF11Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=11;
end;

{ TBuilderMBF12Request }

constructor TBuilderMBF12Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=12;
end;

{ TBuilderMBF15Request }

function TBuilderMBF15Request.AreEquivalent(Source: TBits): Boolean;
var i,Count,Counter : Integer;
begin
  Result:=False;
  if FBits.Size<>Source.Size then Exit;
  Counter:=0;
  Count:=FBits.Size-1;
  for i:=0 to Count do if FBits.Bits[i] = Source.Bits[i] then Inc(Counter);
  Result := Counter = (Count+1);
end;

procedure TBuilderMBF15Request.Assign(Source: TBits);
var i,Count : Integer;
begin
  if Source = nil then Exit;
  Count:=Source.Size-1;
  FBits.Size:=Count+1;
  for i:=0 to Count do FBits.Bits[i]:=Source.Bits[i];
end;

procedure TBuilderMBF15Request.Build;
var TempBuff  : PByteArray;
    ByteIndex : Integer;
    BitIndex  : Integer;
    i         : Integer;
begin
 FLenPacket:=sizeof(TMBF15Request)+FByteCount+2;
 GetPacketMem;
 PMBF15Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
 PMBF15Request(FPacket)^.Header.FunctionCode:=FFunctionNum;
 PMBF15Request(FPacket)^.Header.StartingAddress:=Swap(FStartingAddress);
 PMBF15Request(FPacket)^.Header.Quantity:=Swap(FQuantity);
 PMBF15Request(FPacket)^.ByteCount:=FByteCount;
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
 Word(Pointer(PtrUInt(FPacket)+FLenPacket-2)^):=GetCRC16(FPacket,FLenPacket-2);
 Notify(betBuild);
end;

constructor TBuilderMBF15Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=15;
  FBits:=TBits.Create;
end;

destructor TBuilderMBF15Request.Destroy;
begin
  FBits.Free;
  inherited;
end;

function TBuilderMBF15Request.GetBits(Index: Integer): Boolean;
begin
  Result:=FBits.Bits[Index];
end;

procedure TBuilderMBF15Request.SetBits(Index: Integer; const Value: Boolean);
begin
  FBits.Bits[Index]:=Value;
end;

procedure TBuilderMBF15Request.SetQuantity(const Value: Word);
begin
  inherited;
  FByteCount:= FQuantity div 8;
  if (FQuantity mod 8)>0 then FByteCount:=FByteCount+1;
  FBits.Size:=Value;
end;

{ TBuilderMBF16Request }

constructor TBuilderMBF16Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=16;
end;

function TBuilderMBF16Request.GetRegValues(Index: Integer): Word;
begin
  Result:=FRegValues[Index];
end;

procedure TBuilderMBF16Request.SetRegValues(Index: Integer; const Value: Word);
begin
  FRegValues[Index]:=Value;
end;

procedure TBuilderMBF16Request.SetQuantity(const Value: Word);
begin
  if (Value<1) or (Value>123) then raise Exception.Create(erMBF16PacketBuild);
  if Value=FQuantity then Exit;
  FQuantity := Value;
  FByteCount := FQuantity*2;
end;

procedure TBuilderMBF16Request.Build;
var TempBuff  : PWordValueArray;
    i         : Integer;
begin
 FLenPacket:=sizeof(TMBF16Request)+FByteCount+2;
 GetPacketMem;
 PMBF16Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
 PMBF16Request(FPacket)^.Header.FunctionCode:=FFunctionNum;
 PMBF16Request(FPacket)^.Header.StartingAddress:=Swap(FStartingAddress);
 PMBF16Request(FPacket)^.Header.Quantity:=Swap(FQuantity);
 PMBF16Request(FPacket)^.ByteCount:=FByteCount;
 TempBuff:=Pointer(PtrUInt(@PMBF16Request(FPacket)^.ByteCount) + 1);
 for i := 0 to FQuantity-1 do
  begin
   TempBuff^[i]:=Swap(FRegValues[i]);
  end;
 Word(Pointer(PtrUInt(FPacket)+FLenPacket-2)^):=GetCRC16(FPacket,FLenPacket-2);
 Notify(betBuild);
end;

function TBuilderMBF16Request.AreEquivalent(Source: array of Byte): Boolean;
var TempByteCount : Byte;
begin
  Result:=False;
  TempByteCount:=Length(Source);
  if TempByteCount <> FByteCount then Exit;
  Result := CompareMem(@FRegValues[0],@Source[0],TempByteCount);
end;

procedure TBuilderMBF16Request.Assign(Source: array of Byte);
var TempLength : Integer;
begin
  TempLength := Length(Source);
  if TempLength = 0 then Exit;
  if TempLength <> FByteCount then Exit;
  Move(Source[0],FRegValues[0], TempLength);
end;

{ TBuilderMBF17Request }

constructor TBuilderMBF17Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum:=17;
end;

{ TBuilderMBF22Request }

procedure TBuilderMBF22Request.Build;
begin
 FLenPacket:=sizeof(TMBF22Request);
 GetPacketMem;
 PMBF22Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
 PMBF22Request(FPacket)^.Header.FunctionCode:=FFunctionCode;
 PMBF22Request(FPacket)^.Header.ReferenceAddress:=Swap(FReferenceAddress);
 PMBF22Request(FPacket)^.Header.AndMask:=Swap(FAndMask);
 PMBF22Request(FPacket)^.Header.OrMask:=Swap(FOrMask);
 PMBF22Request(FPacket)^.CRC:=GetCRC16(FPacket,FLenPacket-2);
 Notify(betBuild);
end;

constructor TBuilderMBF22Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode:=22;
end;

{ TBuilderMBF23Request }

constructor TBuilderMBF23Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode:=23;
  FReadStartAddress:=0;
  FReadQuantity:=1;
  FWriteStartAddress:=0;
  FWriteQuantity:=1;
  FWriteByteCount:=2;
end;

procedure TBuilderMBF23Request.Build;
var TempBuff  : PWordValueArray;
    i         : Integer;
begin
  FLenPacket:=sizeof(TMBF23RequestHeader)+FWriteByteCount+2;
  GetPacketMem;
  PMBF23RequestHeader(FPacket)^.DeviceAddress:=FDeviceAddress;
  PMBF23RequestHeader(FPacket)^.FunctionCode:=FFunctionCode;
  PMBF23RequestHeader(FPacket)^.RequestData.ReadStartAddress:=Swap(FReadStartAddress);
  PMBF23RequestHeader(FPacket)^.RequestData.ReadQuantity:=Swap(FReadQuantity);
  PMBF23RequestHeader(FPacket)^.RequestData.WriteStartAddress:=Swap(FWriteStartAddress);
  PMBF23RequestHeader(FPacket)^.RequestData.WriteQuantity:=Swap(FWriteQuantity);
  PMBF23RequestHeader(FPacket)^.RequestData.WriteByteCount:=FWriteByteCount;
  TempBuff:=Pointer(PtrUInt(@PMBF23RequestHeader(FPacket)^.RequestData.WriteByteCount) + 1);
  for i := 0 to FWriteQuantity-1 do
   begin
    TempBuff^[i]:=Swap(FWriteValues[i]);
   end;
  Word(Pointer(PtrUInt(FPacket)+FLenPacket-2)^):=GetCRC16(FPacket,FLenPacket-2);
  Notify(betBuild);
end;

function TBuilderMBF23Request.GetWriteValues(Index: Integer): Word;
begin
 if (Index<0)or(Index>FWriteQuantity) then raise Exception.Create(erMBF23PacketBuild);
 Result:=FWriteValues[Index];
end;

procedure TBuilderMBF23Request.SetWriteValues(Index: Integer; const Value: Word);
begin
 if (Index<0)or(Index>FWriteQuantity) then raise Exception.Create(erMBF23PacketBuild);
 FWriteValues[Index]:=Value;
end;

procedure TBuilderMBF23Request.SetReadQuantity(const Value: Word);
begin
  if (Value<1)or(Value>$7D) then raise Exception.Create(erMBF3PacketBuild);
  FReadQuantity := Value;
end;

procedure TBuilderMBF23Request.SetWriteQuantity(const Value: Word);
begin
  if (Value<1)or(Value>$79) then raise Exception.Create(erMBF23PacketBuild1);
  FWriteQuantity := Value;
  FWriteByteCount := Value*2;
end;

function TBuilderMBF23Request.AreEquivalent(Source: array of Byte): Boolean;
var TempByteCount : Byte;
begin
  Result:=False;
  TempByteCount:=Length(Source);
  if TempByteCount <> FWriteByteCount then Exit;
  Result := CompareMem(@FWriteValues[0],@Source[0],TempByteCount);
end;

procedure TBuilderMBF23Request.Assign(Source: array of Byte);
var TempLength : Integer;
begin
  TempLength := Length(Source);
  if TempLength = 0 then Exit;
  if TempLength <> FWriteByteCount then Exit;
  Move(Source[0],FWriteValues[0], TempLength);
end;

{ TBuilderMBF24Request }

procedure TBuilderMBF24Request.Build;
begin
  FLenPacket:=sizeof(TMBF24Request);
  GetPacketMem;
  PMBF24Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
  PMBF24Request(FPacket)^.Header.FunctionCode:=FFunctionCode;
  PMBF24Request(FPacket)^.Header.FIFOPointerAddress:=Swap(FFIFOPointerAddress);
  PMBF24Request(FPacket)^.CRC:=GetCRC16(FPacket,FLenPacket-2);
  Notify(betBuild);
end;

constructor TBuilderMBF24Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode:=24;
end;

{ TBuilderMBF43Request }

constructor TBuilderMBF43Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode:=43;
  FMEIType:=$0E;
  FReadDeviceIDCode:=1;
  FObjectID:=0;
end;

procedure TBuilderMBF43Request.Build;
begin
 case TMEIType(FMEIType) of
  mei14 : begin
           FLenPacket:=sizeof(TMBF43_14Request);
           GetPacketMem;
           PMBF43_14Request(FPacket)^.Header.DeviceAddress:=FDeviceAddress;
           PMBF43_14Request(FPacket)^.Header.FunctionCode:=FFunctionCode;
           PMBF43_14Request(FPacket)^.Header.RequestData.MEIType:=FMEIType;
           PMBF43_14Request(FPacket)^.Header.RequestData.ReadDeviceIDCode:=FReadDeviceIDCode;
           PMBF43_14Request(FPacket)^.Header.RequestData.ObjectID:=FObjectID;
           PMBF43_14Request(FPacket)^.CRC:=GetCRC16(FPacket,FLenPacket-2);
          end;
 else
  raise Exception.Create(erMBF43PacketBuild);
 end;
 Notify(betBuild);
end;

function TBuilderMBF43Request.GetMEIType: TMEIType;
begin
  Result := TMEIType(FMEIType);
end;

procedure TBuilderMBF43Request.SetMEIType(const Value: TMEIType);
begin
 if Value=mei13 then raise Exception.Create(erMBF43PacketBuild);
 FMEIType := ord(Value);
end;

function TBuilderMBF43Request.GetObjectID: TObjectID;
begin
 Result:=TObjectID(FObjectID);
end;

procedure TBuilderMBF43Request.SetObjectID(const Value: TObjectID);
begin
 if Value<>oiVendorName then raise Exception.Create(erMBF43PacketBuild);
 FObjectID:=ord(Value);
end;

function TBuilderMBF43Request.GetReadDeviceIDCode: TReadDeviceIDCode;
begin
 Result:=TReadDeviceIDCode(FReadDeviceIDCode);
end;

procedure TBuilderMBF43Request.SetReadDeviceIDCode( const Value: TReadDeviceIDCode);
begin
 if Value<>rdic_01 then  raise Exception.Create(erMBF43PacketBuild);
 FReadDeviceIDCode:=ord(Value);
end;

{ TBuilderMBF72Request }

procedure TBuilderMBF72Request.Build;
begin
  FLenPacket:=sizeof(TMBF72Request);
  GetPacketMem;
  PMBF72Request(FPacket)^.Header.DeviceAddress   := FDeviceAddress;
  PMBF72Request(FPacket)^.Header.FunctionCode    := FFunctionNum;
  PMBF72Request(FPacket)^.Header.StartingAddress := Swap(FStartingAddress);
  PMBF72Request(FPacket)^.Header.ChkRKey         := FChkRKey;
  PMBF72Request(FPacket)^.Header.Quantity        := FQuantity;
  PMBF72Request(FPacket)^.CRC:=GetCRC16(FPacket,sizeof(TMBF72RequestHeader));
  Notify(betBuild);
end;

constructor TBuilderMBF72Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FChkRKey     := $55;
  FExpectedKey := $AA;
  FFunctionNum := 72;
end;

procedure TBuilderMBF72Request.RebuilAtNextKey;
begin
  case ChkRKey of
   $55 : ChkRKey:=$AA;
   $AA : ChkRKey:=$55;
  end;
  Build;
end;

procedure TBuilderMBF72Request.SetChkRKey(const Value: Byte);
begin
  if (Value<>$55) and (Value<>$AA) then Exception.Create(erMBF72PacketBuild1);
  if FChkRKey = Value then Exit;
  FChkRKey := Value;
  case FChkRKey of
   $55 : FExpectedKey:=$AA;
   $AA : FExpectedKey:=$55;
  end;
end;

procedure TBuilderMBF72Request.SetQuantity(const Value: Word);
begin
  if (Value<1) or (Value>8) then raise Exception.Create(erMBF72PacketBuild);
  inherited SetQuantity(Value);
  FResponseSize:=5+Value*2+2;
end;

{ TBuilderMBF110Request }

function TBuilderMBF110Request.AreEquivalent(Source: array of Byte): Boolean;
var TempByteCount : Byte;
begin
  Result:=False;
  TempByteCount:=Length(Source);
  if TempByteCount <> FByteCount then Exit;
  Result := CompareMem(@FRegValues[0],@Source[0],TempByteCount);
end;

procedure TBuilderMBF110Request.Assign(Source: array of Byte);
var TempLength : Integer;
begin
  TempLength := Length(Source);
  if TempLength = 0 then Exit;
  if TempLength <> FByteCount then Exit;
  Move(Source[0],FRegValues[0], TempLength);
end;

procedure TBuilderMBF110Request.Build;
var TempBuff  : PWordValueArray;
    i         : Integer;
begin
 FLenPacket:=sizeof(TMBF110RequestHeader)+3+FByteCount+4;
 GetPacketMem;

 PMBF110RequestHeader(FPacket)^.DeviceAddress   := FDeviceAddress;
 PMBF110RequestHeader(FPacket)^.FunctionCode    := FFunctionNum;
 PMBF110RequestHeader(FPacket)^.ChkWKey         := FChkWKey;

 Word(Pointer(PtrUInt(@PMBF110RequestHeader(FPacket)^.ChkWKey) + 1)^):= Swap(FStartingAddress);
 Byte(Pointer(PtrUInt(@PMBF110RequestHeader(FPacket)^.ChkWKey) + 3)^):= FQuantity;

 TempBuff:=Pointer(PtrUInt(@PMBF110RequestHeader(FPacket)^.ChkWKey) + 4);
 for i := 0 to FQuantity-1 do
  begin
   TempBuff^[i]:=Swap(FRegValues[i]);
  end;

 Word(Pointer(PtrUInt(FPacket)+FLenPacket-4)^):=GetCRC16(Pointer(PtrUInt(@PMBF110RequestHeader(FPacket)^.ChkWKey) + 1),3+FByteCount);

 Word(Pointer(PtrUInt(FPacket)+FLenPacket-2)^):=GetCRC16(FPacket,FLenPacket-2);

 Notify(betBuild);
end;

constructor TBuilderMBF110Request.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum := 110;
  FChkWKey     := $55;
  FExpectedKey := $AA;
end;

function TBuilderMBF110Request.GetRegValues(Index: Integer): Word;
begin
  Result:= FRegValues[Index];
end;

procedure TBuilderMBF110Request.RebuilAtNextKey;
begin
  case ChkWKey of
   $55 : ChkWKey:=$AA;
   $AA : ChkWKey:=$55;
  end;
  Build;
end;

procedure TBuilderMBF110Request.SetChkWKey(const Value: Byte);
begin
  if (Value<>$55) and (Value<>$AA) then Exception.Create(erMBF110PacketBuild1);
  if FChkWKey = Value then Exit;
  FChkWKey := Value;
  case FChkWKey of
   $55 : FExpectedKey:=$AA;
   $AA : FExpectedKey:=$55;
  end;
end;

procedure TBuilderMBF110Request.SetQuantity(const Value: Word);
begin
  if (Value<1) or (Value>8) then raise Exception.Create(erMBF110PacketBuild);
  if Value = FQuantity then Exit;
  FQuantity := Value;
  FByteCount := FQuantity*2;
end;

procedure TBuilderMBF110Request.SetRegValues(Index: Integer; const Value: Word);
begin
  FRegValues[Index]:=Value;
end;

{ TBuilderMBF20Request }

procedure TBuilderMBF20Request.Build;
begin
  // заглушка
end;

{ TBuilderMBF21Request }

procedure TBuilderMBF21Request.Build;
begin
  // заглушка
end;

end.

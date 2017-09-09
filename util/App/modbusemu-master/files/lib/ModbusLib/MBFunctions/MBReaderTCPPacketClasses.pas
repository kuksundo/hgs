unit MBReaderTCPPacketClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBResponseTypes, MBRequestTypes, MBReaderPacketClasses;
  // Modbus TCP поддерживаются функции: 1,2,3,4,5,6,15,16,20,21,22,23,24,43,43/13,43/14
  // Modbus RTU поддержифаются функции: все Modbus TCP,7,8,11,12,17
type
 TReaderMBTCPF1Packet = class(TReaderMBTCPPacket)
   private
    FBits  : TBits;
    function GetBitCount: Integer;
    function GetBits(Index: Integer): Boolean;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    property BitCount : Integer read GetBitCount;
    property Bits[Index : Integer] : Boolean read GetBits;
  end;

  TReaderMBTCPF2Packet = class(TReaderMBTCPF1Packet)
   public
    constructor Create(AOwner : TComponent); override;
  end;

  TReaderMBTCPF3Packet = class(TReaderMBTCPPacket)
   private
    FRegValues : TWordRegVlueArray;
    FRegCount  : Integer;
    function GetRegCount: Integer;
    function GetRegValues(Index: Integer): Word;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property RegCount : Integer read GetRegCount;
    property RegValues [Index: Integer] : Word read GetRegValues;
  end;

  TReaderMBTCPF4Packet = class(TReaderMBTCPF3Packet)
   public
    constructor Create(AOwner : TComponent); override;
  end;

  TReaderMBTCPF5Packet = class(TReaderMBTCPPacket)
   private
    FOutputAddress : Word;
    FOutputValue   : Word;
    function GetOutputValue: Boolean;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property Address : Word read FOutputAddress;
    property Value   : Boolean read GetOutputValue;
  end;

  TReaderMBTCPF6Packet = class(TReaderMBTCPPacket)
   private
    FWriteAddress : Word;
    FWriteValue   : Word;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property Address : Word read FWriteAddress;
    property Value   : Word read FWriteValue;
  end;

  TReaderMBTCPF15Packet = class(TReaderMBTCPPacket)
   private
    FStartingAddress : Word;
    FQuantityOutputs : Word;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property StartingAddress : Word read FStartingAddress;
    property QuantityOutputs : Word read FQuantityOutputs;
  end;

  TReaderMBTCPF16Packet = class(TReaderMBTCPF15Packet)
  public
    constructor Create(AOwner : TComponent); override;
  end;

  TReaderMBTCPF20Packet = class(TReaderMBTCPPacket)  // пока не реализовано
   //public
   // constructor Create; override;
  end;

  TReaderMBTCPF21Packet = class(TReaderMBTCPPacket)  // пока не реализовано
   //public
   // constructor Create; override;
  end;

  TReaderMBTCPF22Packet = class(TReaderMBTCPPacket)
   private
    FReferenceAddress : Word;
    FAnd_Mask         : Word;
    FOr_Mask          : Word;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property ReferenceAddress : Word read FReferenceAddress;
    property And_Mask         : Word read FAnd_Mask;
    property Or_Mask          : Word read FOr_Mask;
  end;

  TReaderMBTCPF23Packet = class(TReaderMBTCPPacket)
   private
    FByteCount          : Byte;
    FReadRegistersValue : TWordRegVlueArray;
    function GetRegCount: Byte;
    function GetValues(Index: Integer): Word;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property RegCount : Byte read GetRegCount;
    property RegValues[Index : Integer] : Word read GetValues;
  end;

  TReaderMBTCPF24Packet = class(TReaderMBTCPPacket)
   private
    FByteCount          : Word;
    FFIFOCount          : Word;
    FFIFORegistersValue : TWordRegVlueArray;
    function GetRegCount : Word;
    function GetValues(Index: Integer): Word;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property FIFOCount : Word read GetRegCount;
    property FIFORegisters[Index : Integer] : Word read GetValues;
  end;

  TReaderMBTCPF43Packet = class(TReaderMBTCPPacket)
   private
    FMEIType          : TMEIType;
    FReadDeviceIDCode : TReadDeviceIDCode;
    FConformityLevel  : TConformityLevel;
    FMoreFollows      : Boolean;
    FNextObjectID     : TObjectID;
    FNumberOfObjects  : Byte;
    FListOfObjects    : TObjectList;
    function GetObjectData(Index: Integer): TObjectData;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property MEIType          : TMEIType read FMEIType;
    property ReadDeviceIDCode : TReadDeviceIDCode read FReadDeviceIDCode;
    property ConformityLevel  : TConformityLevel read FConformityLevel;
    property MoreFollows      : Boolean read FMoreFollows;
    property NextObjectID     : TObjectID read FNextObjectID;
    property NumberOfObjects  : Byte read FNumberOfObjects;
    property Objects[Index : Integer] : TObjectData read GetObjectData;
  end;

  TReaderMBTCPF72Packet = class(TReaderMBTCPPacket)
   private
    FRegValues   : TWordRegVlueArray;
    FRegCount    : Byte;
    FChkRKey     : Byte;
    FExpectedKey : Byte;
    function  GetRegCount: Byte;
    function  GetRegValues(Index: Integer): Word;
    procedure SetExpectedKey(const Value: Byte);
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    procedure Response(Buff : Pointer; BuffSize : Cardinal); override;     //
    property RegCount    : Byte read GetRegCount;
    property RegValues [Index: Integer] : Word read GetRegValues;
    property ChkRKey     : Byte read FChkRKey;
    property ExpectedKey : Byte read FExpectedKey write SetExpectedKey;
  end;

  TReaderMBTCPF110Packet = class(TReaderMBTCPPacket)
   private
    FStartAddress : Word;
    FRegCount     : Byte;
    FChkRKey      : Byte;
    FExpectedKey  : Byte;
    function  GetRegCount: Byte;
    procedure SetExpectedKey(const Value: Byte);
   protected
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    procedure Response(Buff : Pointer; BuffSize : Cardinal); override;     //
    property StartAddress : Word read FStartAddress;
    property ChkRKey      : Byte read FChkRKey;
    property RegCount     : Byte read GetRegCount;
    property ExpectedKey  : Byte read FExpectedKey write SetExpectedKey;
  end;

implementation

uses SysUtils,
     MBDefine,
     MBReaderBase,
     MBResourceString,
     {Библиотека MiscFunctions}
     ExceptionsTypes;

{ TReaderMBTCPF1Packet }

constructor TReaderMBTCPF1Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FBits:=TBits.Create;
  FSourceFunction:=1;
end;

destructor TReaderMBTCPF1Packet.Destroy;
begin
  FBits.Free;
  inherited;
end;

function TReaderMBTCPF1Packet.GetBitCount: Integer;
begin
  Result:=FBits.Size;
end;

function TReaderMBTCPF1Packet.GetBits(Index: Integer): Boolean;
begin
  Result:=FBits.Bits[Index];
end;

function TReaderMBTCPF1Packet.GetRegisterCount: Word;
begin
  Result:=GetBitCount;
end;

procedure TReaderMBTCPF1Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var ByteCount     : Byte;
    TempByteArray : PByteArray;
    BitIndex      : Integer;
    i             : Integer;
begin
  ByteCount:=Byte(Buff^);
  TempByteArray := PByteArray(PtrUInt(Buff)+1);
  FBits.Size:=ByteCount*8;
  for i := 0 to ByteCount-1 do
   begin
     BitIndex:=i*8;
     FBits[BitIndex+0]:=((TempByteArray^[i] and 1)= 1);
     FBits[BitIndex+1]:=((TempByteArray^[i] and 2)= 2);
     FBits[BitIndex+2]:=((TempByteArray^[i] and 4)= 4);
     FBits[BitIndex+3]:=((TempByteArray^[i] and 8)= 8);
     FBits[BitIndex+4]:=((TempByteArray^[i] and 16)= 16);
     FBits[BitIndex+5]:=((TempByteArray^[i] and 32)= 32);
     FBits[BitIndex+6]:=((TempByteArray^[i] and 64)= 64);
     FBits[BitIndex+7]:=((TempByteArray^[i] and 128)= 128);
   end;
end;

{ TReaderMBTCPF3Packet }

constructor TReaderMBTCPF3Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FRegCount:=0;
  FSourceFunction:=3;
end;

function TReaderMBTCPF3Packet.GetRegCount: Integer;
begin
  Result:=FRegCount;
end;

function TReaderMBTCPF3Packet.GetRegisterCount: Word;
begin
  Result:=GetRegCount;
end;

function TReaderMBTCPF3Packet.GetRegValues(Index: Integer): Word;
begin
 Result:=FRegValues[Index];
end;

procedure TReaderMBTCPF3Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var TemRegValues : PWordRegF3Response;
    i : Integer;
begin
  FRegCount:=0;
  FillChar(FRegValues,Sizeof(FRegValues),$FF);
  if (BuffSize mod 2) <> 1 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  TemRegValues:=Buff;
  if (TemRegValues^.ByteCount mod 2)>0 then
   begin
    FErrorCode:=ERR_MASTER_WORD_READ;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FRegCount:=TemRegValues^.ByteCount div 2;

  for i := 0 to FRegCount-1 do FRegValues[i]:=TemRegValues^.RegValues[i];
end;

{ TReaderMBTCPF5Packet }

constructor TReaderMBTCPF5Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=5;
end;

function TReaderMBTCPF5Packet.GetOutputValue: Boolean;
begin
  Result:=FOutputValue<>0;
end;

function TReaderMBTCPF5Packet.GetRegisterCount: Word;
begin
  Result:=0;
end;

procedure TReaderMBTCPF5Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
  if BuffSize<>4 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FOutputAddress:=Word(Buff^);
  FOutputValue:=Word(PUintPtr(PtrUInt(Buff)+2)^);
end;

{ TReaderMBTCPF6Packet }

constructor TReaderMBTCPF6Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=6;
end;

function TReaderMBTCPF6Packet.GetRegisterCount: Word;
begin
  Result:=0;
end;

procedure TReaderMBTCPF6Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
 if BuffSize<>4 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FWriteAddress:=Word(Buff^);
  FWriteValue:=Word(PUintPtr(PtrUInt(Buff)+2)^);
end;

{ TReaderMBTCPF15Packet }

constructor TReaderMBTCPF15Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=15;
end;

function TReaderMBTCPF15Packet.GetRegisterCount: Word;
begin
  Result:=FQuantityOutputs;
end;

procedure TReaderMBTCPF15Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var TempWord : Word;
begin
  FStartingAddress:=0;
  FQuantityOutputs:=0;
  if BuffSize<>4 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FStartingAddress:=Word(Buff^);
  TempWord:=Swap(Word(PUintPtr(PtrUInt(Buff)+2)^));
  if (TempWord<1)or(TempWord>$7B) then
   begin
    FErrorCode:=ERR_MASTER_QUANTITY;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FQuantityOutputs:=TempWord;
end;

{ TReaderMBTCPF22Packet }

constructor TReaderMBTCPF22Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=22;
end;

function TReaderMBTCPF22Packet.GetRegisterCount: Word;
begin
  Result:=0;
end;

procedure TReaderMBTCPF22Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
  if BuffSize<>6 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FReferenceAddress:=Word(Buff^);
  FAnd_Mask:=Word(PUintPtr(PtrUInt(Buff)+2)^);
  FOr_Mask:=Word(PUintPtr(PtrUInt(Buff)+4)^);
end;

{ TReaderMBTCPF23Packet }

constructor TReaderMBTCPF23Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=23;
end;

function TReaderMBTCPF23Packet.GetRegCount: Byte;
begin
  Result:=FByteCount div 2;
end;

function TReaderMBTCPF23Packet.GetRegisterCount: Word;
begin
 Result:=GetRegCount;
end;

function TReaderMBTCPF23Packet.GetValues(Index: Integer): Word;
begin
  if Index>(FByteCount div 2) then raise Exception.Create(RS_OUT_OF_RANGE);
  Result:= FReadRegistersValue[Index];
end;

procedure TReaderMBTCPF23Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var TempValues : PWordRegVlueArray;
    i : Integer;
begin
  FByteCount:=Byte(Buff^);
  if BuffSize<>Cardinal(FByteCount+1) then
   begin
    FByteCount:=0;
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  TempValues:=PWordRegVlueArray(PUintPtr(PtrUInt(Buff)+1));
  for i := 0 to (FByteCount div 2)-1 do FReadRegistersValue[i]:= TempValues^[i];
end;

{ TReaderMBTCPF24Packet }

constructor TReaderMBTCPF24Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=24;
end;

function TReaderMBTCPF24Packet.GetRegCount: Word;
begin
  Result:=FFIFOCount;
end;

function TReaderMBTCPF24Packet.GetRegisterCount: Word;
begin
  Result:=GetRegCount;
end;

function TReaderMBTCPF24Packet.GetValues(Index: Integer): Word;
begin
  if Index>FFIFOCount then raise Exception.Create(RS_OUT_OF_RANGE);
  Result := FFIFORegistersValue[Index];
end;

procedure TReaderMBTCPF24Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var TempValues : PWordRegVlueArray;
    i : Integer;
begin
 FByteCount:=Word(Buff^);
 if BuffSize<>Cardinal(FByteCount+2) then
  begin
   FByteCount:=0;
   FErrorCode:=ERR_MASTER_PACK_LEN;
   Notify(rpError,GetMBErrorString(FErrorCode));
   Exit;
  end;
 FFIFOCount:=Word(PUintPtr(PtrUInt(Buff)+2)^);
 if FFIFOCount>31 then
  begin
   FByteCount:=0;
   FFIFOCount:=0;
   FErrorCode:=ERR_MASTER_PACK_LEN;
   Notify(rpError,GetMBErrorString(FErrorCode));
   Exit;
  end;
 TempValues:=PWordRegVlueArray(PUintPtr(PtrUInt(Buff)+4));
 for i := 0 to FFIFOCount-1 do FFIFORegistersValue[i]:=TempValues^[i];
end;

{ TReaderMBTCPF43Packet }

constructor TReaderMBTCPF43Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=43;
end;

function TReaderMBTCPF43Packet.GetObjectData(Index: Integer): TObjectData;
begin
 if Index>FNumberOfObjects-1 then raise Exception.Create(RS_OUT_OF_RANGE);
 Result:=FListOfObjects[Index];
end;

function TReaderMBTCPF43Packet.GetRegisterCount: Word;
begin
 Result:=0;
end;

procedure TReaderMBTCPF43Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var i, ii   : Integer;
    TempBuf : Pointer;
begin
  if TMEIType(Byte(Buff^))<>mei14 then
   begin
    FErrorCode:=ERR_MASTER_MEI;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FMEIType := TMEIType(Byte(Buff^));
  if TReadDeviceIDCode(Byte(PUintPtr(PtrUInt(Buff)+1)^))<>rdic_01 then
   begin
    FErrorCode:=ERR_MASTER_RDIC;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FReadDeviceIDCode:=TReadDeviceIDCode(Byte(PUintPtr(PtrUInt(Buff)+1)^));
  FConformityLevel:=TConformityLevel(Byte(PUintPtr(PtrUInt(Buff)+2)^));
  if (Byte(PUintPtr(PtrUInt(Buff)+3)^)<>0)and(Byte(PUintPtr(PtrUInt(Buff)+3)^)<>$FF) then
   begin
    FErrorCode:=ERR_MASTER_MOREFOLLOWS;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FMoreFollows := Boolean(Byte(PUintPtr(PtrUInt(Buff)+3)^));
  FNextObjectID := TObjectID(Byte(PUintPtr(PtrUInt(Buff)+4)^));
  FNumberOfObjects := Byte(PUintPtr(PtrUInt(Buff)+5)^);
  SetLength(FListOfObjects,FNumberOfObjects);
  TempBuf:=PUintPtr(PtrUInt(Buff)+6);
  for i := 0 to FNumberOfObjects-1 do
   begin
    if (PtrUInt(TempBuf)-PtrUInt(Buff))>= BuffSize then Break;
    FListOfObjects[i].ObjectID:=TObjectID(Byte(TempBuf^));
    FListOfObjects[i].ObjectLen:=Byte(PUintPtr(PtrUInt(TempBuf)+1)^);
    for ii := 0 to FListOfObjects[i].ObjectLen-1 do
      FListOfObjects[i].ObjectValue[ii]:=Byte(PUintPtr(PtrUInt(TempBuf)+2+Cardinal(ii))^);
    TempBuf:=PUintPtr(PtrUInt(TempBuf)+2+FListOfObjects[i].ObjectLen);
   end;
end;

{ TReaderMBTCPF21Packet }

{constructor TReaderMBTCPF21Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=21;
end;}

{ TReaderMBTCPF20Packet }

{constructor TReaderMBTCPF20Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=20;
end;}

{ TReaderMBTCPF4Packet }

constructor TReaderMBTCPF4Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=4;
end;

{ TReaderMBTCPF2Packet }

constructor TReaderMBTCPF2Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=2;
end;

{ TReaderMBTCPF16Packet }

constructor TReaderMBTCPF16Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=16;
end;

{ TReaderMBTCPF72Packet }

constructor TReaderMBTCPF72Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode   := 72;
  FSourceFunction := 72;
  FChkRKey        := $55;
  FExpectedKey    := $AA
end;

function TReaderMBTCPF72Packet.GetRegCount: Byte;
begin
  Result := FRegCount;
end;

function TReaderMBTCPF72Packet.GetRegisterCount: Word;
begin
  Result:=GetRegCount;
end;

function TReaderMBTCPF72Packet.GetRegValues(Index: Integer): Word;
begin
  Result:=FRegValues[Index];
end;

procedure TReaderMBTCPF72Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
  FRegCount:=0;
  FillChar(FRegValues,Sizeof(FRegValues),$FF);
  if (Buff=nil) or (BuffSize=0) then Exit;
  FRegCount:=BuffSize div 2;
  Move(Buff^,FRegValues,BuffSize);
end;

procedure TReaderMBTCPF72Packet.Response(Buff: Pointer; BuffSize: Cardinal);
begin
 Notify(rpStartRead);
 FErrorCode:=0;
 FMessage:='';
 try
  if (not CheckBuffNil(Buff)) or (BuffSize = 0)then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckCRC(Buff,BuffSize)   then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckSourceDevice(Buff)   then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckMBError(Buff)        then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckSourceFunction(Buff) then raise Exception.Create(GetMBErrorString(FErrorCode));

  // проверки дополнительных контрольных полей
  if PMBF72ResponceHeader(Buff)^.ChkRKey<>FExpectedKey then
    raise EMBF72ChkRKey.Create;

  if (PMBF72ResponceHeader(Buff)^.Quantity<1) or (PMBF72ResponceHeader(Buff)^.Quantity>8) then
    raise EMBF72Quantity.Create;

  if not CheckCRC(@PMBF72ResponceHeader(Buff)^.StartReg,BuffSize-5) then
   raise EMBF72CRC.Create;

  // Разбор самих данных
  if FErrorCode=0 then
   ReadData(PUintPtr(PtrUInt(@PMBF72ResponceHeader(Buff)^.Quantity)+1),PMBF72ResponceHeader(Buff)^.Quantity*2)
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

procedure TReaderMBTCPF72Packet.SetExpectedKey(const Value: Byte);
begin
  FExpectedKey := Value;
end;

{ TReaderMBTCPF110Packet }

constructor TReaderMBTCPF110Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode   := 110;
  FSourceFunction := 110;
  FChkRKey        := $55;
  FExpectedKey    := $AA
end;

function TReaderMBTCPF110Packet.GetRegCount: Byte;
begin
  Result:=FRegCount;
end;

function TReaderMBTCPF110Packet.GetRegisterCount: Word;
begin
  Result:=GetRegCount;
end;

procedure TReaderMBTCPF110Packet.Response(Buff: Pointer; BuffSize: Cardinal);
begin
 Notify(rpStartRead);
 FErrorCode:=0;
 FMessage:='';
 try
  if (not CheckBuffNil(Buff)) or (BuffSize = 0)then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckCRC(Buff,BuffSize)   then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckSourceDevice(Buff)   then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckMBError(Buff)        then raise Exception.Create(GetMBErrorString(FErrorCode));
  if not CheckSourceFunction(Buff) then raise Exception.Create(GetMBErrorString(FErrorCode));

  // проверки дополнительных контрольных полей
  if PMBF110ResponceHeader(Buff)^.ChkWKey<>FExpectedKey then
    raise EMBF110ChkWKey.Create;

  if (PMBF110ResponceHeader(Buff)^.Quantity<1) or (PMBF110ResponceHeader(Buff)^.Quantity>8) then
    raise EMBF110Quantity.Create;

  // Разбор самих данных
  FStartAddress := PMBF110ResponceHeader(Buff)^.StartReg;
  FRegCount     := PMBF110ResponceHeader(Buff)^.Quantity;

 except
  on E : Exception do
   begin
    Notify(rpError, E.Message);
    Exit;
   end;
 end;
 Notify(rpEndRead);
end;

procedure TReaderMBTCPF110Packet.SetExpectedKey(const Value: Byte);
begin
  FExpectedKey := Value;
end;

end.

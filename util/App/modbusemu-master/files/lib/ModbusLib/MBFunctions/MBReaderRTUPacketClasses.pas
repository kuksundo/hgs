unit MBReaderRTUPacketClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBReaderPacketClasses, MBResponseTypes, MBRequestTypes;

type
  // Modbus TCP поддерживаются функции: 1,2,3,4,5,6,15,16,20,21,22,23,24,43,43/13,43/14
  // Modbus RTU поддержифаются функции: все Modbus TCP,7,8,11,12,17

  TReaderMBF1Packet = class(TReaderMBRTUPacket)
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

  TReaderMBF2Packet = class(TReaderMBF1Packet)
   public
    constructor Create(AOwner : TComponent); override;
  end;

  TReaderMBF3Packet = class(TReaderMBRTUPacket)
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

  TReaderMBF4Packet = class(TReaderMBF3Packet)
   public
    constructor Create(AOwner : TComponent); override;
  end;

  TReaderMBF5Packet = class(TReaderMBRTUPacket)
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

  TReaderMBF6Packet = class(TReaderMBRTUPacket)
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

  TReaderMBF7Packet = class(TReaderMBRTUPacket)
   private
    FOutputData  : Byte;
    function GetOutputData: Boolean;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property OutputData : Boolean read GetOutputData;
  end;

  TReaderMBF8Packet = class(TReaderMBRTUPacket)
   private
    FSubFunction : Word;
    FDataCount   : Byte;
    FData        : TWordRegVlueArray;
    function GetData(Index: Byte): Word;
    function GetSubFunction: TMBF8SubfunctionType;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property SubFunction : TMBF8SubfunctionType read GetSubFunction;
    property DataCount   : Byte read FDataCount;
    property Data[Index : Byte] : Word read GetData;
  end;

  TReaderMBF11Packet = class(TReaderMBRTUPacket)
   private
    FStatus     : Word;
    FEventCount : Word;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property Status     : Word read FStatus;
    property EventCount : Word read FEventCount;
  end;

  TReaderMBF12Packet = class(TReaderMBRTUPacket)
   private
    FByteCount    : Byte;
    FStatus       : Word;
    FEventCount   : Word;
    FMessageCount : Word;
    FEventsLen    : Byte;
    FEvents       : TEventArray;
    function GetEvents(Index: Integer): Byte;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property ByteCount    : Byte read FByteCount;
    property Status       : Word read FStatus;
    property EventCount   : Word read FEventCount;
    property MessageCount : Word read FMessageCount;
    property EventsLen    : Byte read FEventsLen;
    property Events[ Index : Integer] : Byte read GetEvents;
  end;

  TReaderMBF15Packet = class(TReaderMBRTUPacket)
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

  TReaderMBF16Packet = class(TReaderMBF15Packet)
  public
    constructor Create(AOwner : TComponent); override;
  end;

  TReaderMBF17Packet = class(TReaderMBRTUPacket)  // содержимое поля данных зависит от конкретного устройства
   private
    FByteCount : Byte;
    FDataBuff  : TDataArray;
    function GetData(Index: Integer): Byte;
   protected
    procedure ReadData(Buff : Pointer; BuffSize : Cardinal); override;
    function  GetRegisterCount: Word; override;
   public
    constructor Create(AOwner : TComponent); override;
    property DataLen               : Byte read FByteCount;
    property Data[Index : Integer] : Byte read GetData;
  end;

  TReaderMBF20Packet = class  // пока не реализовано
   //public
   // constructor Create; override;
  end;

  TReaderMBF21Packet = class  // пока не реализовано
   //public
   // constructor Create; override;
  end;

  TReaderMBF22Packet = class(TReaderMBRTUPacket)
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

  TReaderMBF23Packet = class(TReaderMBRTUPacket)
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

  TReaderMBF24Packet = class(TReaderMBRTUPacket)
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

  TReaderMBF43Packet = class(TReaderMBRTUPacket)
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

  TReaderMBF72Packet = class(TReaderMBRTUPacket)
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
    procedure Response(Buff : Pointer; BuffSize : Cardinal); override;
    property RegCount    : Byte read GetRegCount;
    property RegValues [Index: Integer] : Word read GetRegValues;
    property ChkRKey     : Byte read FChkRKey;
    property ExpectedKey : Byte read FExpectedKey write SetExpectedKey;
  end;

  TReaderMBF110Packet = class(TReaderMBRTUPacket)
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
     MBReaderBase, MBResourceString,
     {Библиотека MiscFunctions}
     ExceptionsTypes;

{ TReaderMBF1Packet }

constructor TReaderMBF1Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FBits:=TBits.Create;
  FSourceFunction:=1;
end;

destructor TReaderMBF1Packet.Destroy;
begin
  FBits.Free;
  inherited;
end;

function TReaderMBF1Packet.GetBitCount: Integer;
begin
  Result:=FBits.Size;
end;

function TReaderMBF1Packet.GetBits(Index: Integer): Boolean;
begin
  Result:=FBits.Bits[Index];
end;

function TReaderMBF1Packet.GetRegisterCount: Word;
begin
  Result:=GetBitCount;
end;

procedure TReaderMBF1Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
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

{ TReaderMBF3Packet }

constructor TReaderMBF3Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FRegCount:=0;
  FSourceFunction:=3;
end;

function TReaderMBF3Packet.GetRegCount: Integer;
begin
  Result:=FRegCount;
end;

function TReaderMBF3Packet.GetRegisterCount: Word;
begin
  Result:=GetRegCount;
end;

function TReaderMBF3Packet.GetRegValues(Index: Integer): Word;
begin
 Result:=FRegValues[Index];
end;

procedure TReaderMBF3Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
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

  for i := 0 to FRegCount-1 do FRegValues[i] := Swap(TemRegValues^.RegValues[i]);
end;

{ TReaderMBF5Packet }

constructor TReaderMBF5Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=5;
end;

function TReaderMBF5Packet.GetOutputValue: Boolean;
begin
  Result:=FOutputValue<>0;
end;

function TReaderMBF5Packet.GetRegisterCount: Word;
begin
  Result:=0;
end;

procedure TReaderMBF5Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
  if BuffSize<>4 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FOutputAddress:=Word(Buff^);
  FOutputValue:=Word(Pointer(PtrUInt(Buff)+2)^);
end;

{ TReaderMBF6Packet }

constructor TReaderMBF6Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=6;
end;

function TReaderMBF6Packet.GetRegisterCount: Word;
begin
  Result:=0;
end;

procedure TReaderMBF6Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
 if BuffSize<>4 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FWriteAddress:=Word(Buff^);
  FWriteValue:=Word(Pointer(PtrUInt(Buff)+2)^);
end;

{ TReaderMBF7Packet }

constructor TReaderMBF7Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=7;
end;

function TReaderMBF7Packet.GetOutputData: Boolean;
begin
  Result:=FOutputData<>0;
end;

function TReaderMBF7Packet.GetRegisterCount: Word;
begin
  Result:=0;
end;

procedure TReaderMBF7Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
  if BuffSize<>1 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FOutputData:=Byte(Buff^)
end;

{ TReaderMBF8Packet }

constructor TReaderMBF8Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=8;
end;

function TReaderMBF8Packet.GetData(Index: Byte): Word;
begin
  Result:=FData[Index];
end;

function TReaderMBF8Packet.GetRegisterCount: Word;
begin
  Result:=FDataCount;
end;

function TReaderMBF8Packet.GetSubFunction: TMBF8SubfunctionType;
begin
  Result:=TMBF8SubfunctionType(FSubFunction);
end;

procedure TReaderMBF8Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var TemData : PWordRegVlueArray;
    i : Integer;
begin
  if (BuffSize mod 2) <> 0 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FDataCount:= (BuffSize-2) div 2;
  FSubFunction:=Word(Buff^);
  TemData:=PWordRegVlueArray(PtrUInt(Buff)+2);
  for i := 0 to FDataCount-1 do FData[i]:=TemData^[i];
end;

{ TReaderMBF11Packet }

constructor TReaderMBF11Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=11;
end;

function TReaderMBF11Packet.GetRegisterCount: Word;
begin
  Result:=FEventCount;
end;

procedure TReaderMBF11Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
  if (BuffSize mod 2) <> 0 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FStatus:=Word(Buff^);
  FEventCount:=Word(Pointer(PtrUInt(Buff)+2)^);
end;

{ TReaderMBF12Packet }

constructor TReaderMBF12Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=12;
end;

function TReaderMBF12Packet.GetEvents(Index: Integer): Byte;
begin
  Result:= FEvents[Index];
end;

function TReaderMBF12Packet.GetRegisterCount: Word;
begin
  Result:=FByteCount;
end;

procedure TReaderMBF12Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var TempEvents : PEventArray;
    i : Integer;
begin
  FByteCount := Byte(Buff^);
  if BuffSize<>FByteCount+1 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FStatus := Word(Pointer(PtrUInt(Buff)+1)^);
  FEventCount := Word(Pointer(PtrUInt(Buff)+3)^);
  FMessageCount := Word(Pointer(PtrUInt(Buff)+5)^);
  FEventsLen := FByteCount-6;
  TempEvents := Pointer(PtrUInt(Buff)+7);
  for i := 0 to FEventsLen-1 do FEvents[i]:= TempEvents^[i];
end;

{ TReaderMBF15Packet }

constructor TReaderMBF15Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=15;
end;

function TReaderMBF15Packet.GetRegisterCount: Word;
begin
  Result:=FQuantityOutputs;
end;

procedure TReaderMBF15Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
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
  TempWord:=Swap(Word(Pointer(PtrUInt(Buff)+2)^));
  if (TempWord<1)or(TempWord>$7B) then
   begin
    FErrorCode:=ERR_MASTER_QUANTITY;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FQuantityOutputs:=TempWord;
end;

{ TReaderMBF17Packet }

constructor TReaderMBF17Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=17;
end;

function TReaderMBF17Packet.GetData(Index: Integer): Byte;
begin
  if Index>FByteCount-1 then
   begin
    raise Exception.Create(RS_OUT_OF_RANGE);
   end;
  Result:= FDataBuff[Index];
end;

function TReaderMBF17Packet.GetRegisterCount: Word;
begin
  Result:=FByteCount;
end;

procedure TReaderMBF17Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var TempData : PDataArray;
    i : Integer;
begin
  FByteCount:=Byte(Buff^);
  if BuffSize<>(FByteCount+1) then
   begin
    FByteCount:=0;
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  TempData:=Pointer(PtrUInt(Buff)+1);
  for i := 0 to FByteCount-1 do FDataBuff[i] := TempData^[i];
end;

{ TReaderMBF22Packet }

constructor TReaderMBF22Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=22;
end;

function TReaderMBF22Packet.GetRegisterCount: Word;
begin
  Result:=0;
end;

procedure TReaderMBF22Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
  if BuffSize<>6 then
   begin
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FReferenceAddress:=Word(Buff^);
  FAnd_Mask:=Word(Pointer(PtrUInt(Buff)+2)^);
  FOr_Mask:=Word(Pointer(PtrUInt(Buff)+4)^);
end;

{ TReaderMBF23Packet }

constructor TReaderMBF23Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=23;
end;

function TReaderMBF23Packet.GetRegCount: Byte;
begin
  Result:=FByteCount div 2;
end;

function TReaderMBF23Packet.GetRegisterCount: Word;
begin
 Result:=GetRegCount;
end;

function TReaderMBF23Packet.GetValues(Index: Integer): Word;
begin
  if Index>(FByteCount div 2) then raise Exception.Create(RS_OUT_OF_RANGE);
  Result:= FReadRegistersValue[Index];
end;

procedure TReaderMBF23Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var TempValues : PWordRegVlueArray;
    i : Integer;
begin
  FByteCount:=Byte(Buff^);
  if BuffSize<>(FByteCount+1) then
   begin
    FByteCount:=0;
    FErrorCode:=ERR_MASTER_PACK_LEN;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  TempValues:=PWordRegVlueArray(PtrUInt(Buff)+1);
  for i := 0 to (FByteCount div 2)-1 do FReadRegistersValue[i]:= TempValues^[i];
end;

{ TReaderMBF24Packet }

constructor TReaderMBF24Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=24;
end;

function TReaderMBF24Packet.GetRegCount: Word;
begin
  Result:=FFIFOCount;
end;

function TReaderMBF24Packet.GetRegisterCount: Word;
begin
  Result:=GetRegCount;
end;

function TReaderMBF24Packet.GetValues(Index: Integer): Word;
begin
  if Index>FFIFOCount then raise Exception.Create(RS_OUT_OF_RANGE);
  Result := FFIFORegistersValue[Index];
end;

procedure TReaderMBF24Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
var TempValues : PWordRegVlueArray;
    i : Integer;
begin
 FByteCount:=Word(Buff^);
 if BuffSize<>(FByteCount+2) then
  begin
   FByteCount:=0;
   FErrorCode:=ERR_MASTER_PACK_LEN;
   Notify(rpError,GetMBErrorString(FErrorCode));
   Exit;
  end;
 FFIFOCount:=Word(Pointer(PtrUInt(Buff)+2)^);
 if FFIFOCount>31 then
  begin
   FByteCount:=0;
   FFIFOCount:=0;
   FErrorCode:=ERR_MASTER_PACK_LEN;
   Notify(rpError,GetMBErrorString(FErrorCode));
   Exit;
  end;
 TempValues:=PWordRegVlueArray(PtrUInt(Buff)+4);
 for i := 0 to FFIFOCount-1 do FFIFORegistersValue[i]:=TempValues^[i];
end;

{ TReaderMBF43Packet }

constructor TReaderMBF43Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=43;
end;

function TReaderMBF43Packet.GetObjectData(Index: Integer): TObjectData;
begin
 if Index>FNumberOfObjects-1 then raise Exception.Create(RS_OUT_OF_RANGE);
 Result:=FListOfObjects[Index];
end;

function TReaderMBF43Packet.GetRegisterCount: Word;
begin
 Result:=0;
end;

procedure TReaderMBF43Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
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
  if TReadDeviceIDCode(Byte(Pointer(PtrUInt(Buff)+1)^))<>rdic_01 then
   begin
    FErrorCode:=ERR_MASTER_RDIC;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FReadDeviceIDCode:=TReadDeviceIDCode(Byte(Pointer(PtrUInt(Buff)+1)^));
  FConformityLevel:=TConformityLevel(Byte(Pointer(PtrUInt(Buff)+2)^));
  if (Byte(Pointer(system.PtrUInt(Buff)+3)^)<>0)and(Byte(Pointer(system.PtrUInt(Buff)+3)^)<>$FF) then
   begin
    FErrorCode:=ERR_MASTER_MOREFOLLOWS;
    Notify(rpError,GetMBErrorString(FErrorCode));
    Exit;
   end;
  FMoreFollows := Boolean(Byte(Pointer(PtrUInt(Buff)+3)^));
  FNextObjectID := TObjectID(Byte(Pointer(PtrUInt(Buff)+4)^));
  FNumberOfObjects := Byte(Pointer(PtrUInt(Buff)+5)^);
  SetLength(FListOfObjects,FNumberOfObjects);
  TempBuf:=Pointer(PtrUInt(Buff)+6);
  for i := 0 to FNumberOfObjects-1 do
   begin
    if (PtrUInt(TempBuf)-PtrUInt(Buff))>= BuffSize then Break;
    FListOfObjects[i].ObjectID:=TObjectID(Byte(TempBuf^));
    FListOfObjects[i].ObjectLen:=Byte(Pointer(PtrUInt(TempBuf)+1)^);
    for ii := 0 to FListOfObjects[i].ObjectLen-1 do
      FListOfObjects[i].ObjectValue[ii]:=Byte(Pointer(PtrUInt(TempBuf)+2+Cardinal(ii))^);
    TempBuf:=Pointer(PtrUInt(TempBuf)+2+FListOfObjects[i].ObjectLen);
   end;
end;

{ TReaderMBF21Packet }

{constructor TReaderMBF21Packet.Create;
begin
  inherited;
  FSourceFunction:=21;
end;}

{ TReaderMBF20Packet }

{constructor TReaderMBF20Packet.Create;
begin
  inherited;
  FSourceFunction:=20;
end;}

{ TReaderMBF4Packet }

constructor TReaderMBF4Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=4;
end;

{ TReaderMBF2Packet }

constructor TReaderMBF2Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=2;
end;

{ TReaderMBF16Packet }

constructor TReaderMBF16Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSourceFunction:=16;
end;

{ TReaderMBF72Packet }

constructor TReaderMBF72Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode   := 72;
  FSourceFunction := 72;
  FChkRKey        := $55;
  FExpectedKey    := $AA
end;

function TReaderMBF72Packet.GetRegCount: Byte;
begin
  Result := FRegCount;
end;

function TReaderMBF72Packet.GetRegisterCount: Word;
begin
  Result:=GetRegCount;
end;

function TReaderMBF72Packet.GetRegValues(Index: Integer): Word;
begin
  Result:=FRegValues[Index];
end;

procedure TReaderMBF72Packet.ReadData(Buff: Pointer; BuffSize: Cardinal);
begin
  FRegCount:=0;
  FillChar(FRegValues,Sizeof(FRegValues),$FF);
  if (Buff=nil) or (BuffSize=0) then Exit;
  FRegCount:=BuffSize div 2;
  Move(Buff^,FRegValues,BuffSize);
end;

procedure TReaderMBF72Packet.Response(Buff: Pointer; BuffSize: Cardinal);
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
   ReadData(Pointer(PtrUInt(@PMBF72ResponceHeader(Buff)^.Quantity)+1),PMBF72ResponceHeader(Buff)^.Quantity*2)
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

procedure TReaderMBF72Packet.SetExpectedKey(const Value: Byte);
begin
  FExpectedKey := Value;
end;

{ TReaderMBF110Packet }

constructor TReaderMBF110Packet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionCode   := 110;
  FSourceFunction := 110;
  FChkRKey        := $55;
  FExpectedKey    := $AA
end;

function TReaderMBF110Packet.GetRegCount: Byte;
begin
  Result:=FRegCount;
end;

function TReaderMBF110Packet.GetRegisterCount: Word;
begin
  Result:=GetRegCount;
end;

procedure TReaderMBF110Packet.Response(Buff: Pointer; BuffSize: Cardinal);
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

procedure TReaderMBF110Packet.SetExpectedKey(const Value: Byte);
begin
  FExpectedKey := Value;
end;

end.

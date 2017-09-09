unit RegisterModul;

{$mode objfpc}{$H+}

interface

uses Windows, Classes, IniFiles,
     MBResourceString, MBDefine, MBAddressActions, BitsClasses, ByteClasses,
     MBRegListClasses;

type
  TMBWordRegister = class;
  TMBBitRegister  = class;

  TOnRegWordChange = procedure // процедурный тип определяющий формат обработчика события изменения данных в регистре
                              (Sender       : TMBWordRegister;  // измененного регистра
                               ChangeBitSet : TRegBits = []     // список идентификаторов изменных бит
                               )of object;
  TOnRegBitChange = procedure(Sender : TMBBitRegister) of object;

  TMBRegister = class                // базовый класс для регистров не содержит полей данных, содержит только поля для обработки адреса
   private
    FType       : TRegMBTypes;       // тип диапазона регистров
    FNumber     : Word;              // номер регистра в диапазоне. первое значение - 1
    FStrAdderss : String;            // строковое представление адреса
    function  GetAddress: DWord;
    procedure SetRegNumber(const Value: Word);
    procedure SetRegType(const Value: TRegMBTypes);
    procedure SetAddress(const Value: DWord);
   protected
    FReadOnly   : Boolean;           // флаг регистр только на чтение
   public
    constructor Create; virtual;
    function GetStrAddress: String; virtual;
    property MBRegType   : TRegMBTypes read FType write SetRegType;
    property Address     : DWord read GetAddress write SetAddress;
    property RegNumber   : Word read FNumber write SetRegNumber;
    property RegReadOnly : Boolean read FReadOnly write FReadOnly;
  end;

  TMBBitRegister = class(TMBRegister) // класс описывающий битовый регистр
   private
    FRegType  : TRegTypes;       // тип регистра
    FOnChange : TOnRegBitChange; // обработчик события изменения значения регистра
   protected
    FValue    : Boolean;         // значение регистра
    procedure SetValue(const Value: Boolean); virtual;
   public
    constructor Create; override;
    property RegType   : TRegTypes read FRegType;
    property Value     : Boolean read FValue write SetValue;
    property OnChange  : TOnRegBitChange read FOnChange write FOnChange;
  end;

  TMBWordRegister = class (TMBRegister)  // класс описывающий word регистр Modbus
   protected
    FValue    : Word;                    // значение содержащееся в регистре
    FRegType  : TRegTypes;               // тип регистра word или смесь байтов
    FOnChange : TOnRegWordChange;        // обработчик события изменения регистра
    procedure SetValue(const Value: Word); virtual;
    function  GetWordChange(Value:Word): TRegBits; virtual;
   public
    constructor Create; override;
    procedure Assigin(Source : TMBWordRegister); virtual;
    property RegType   : TRegTypes read FRegType;
    property Value     : Word read FValue write SetValue;
    property OnChange  : TOnRegWordChange read FOnChange write FOnChange;
  end;

  TMBWordBitRegister = class(TMBWordRegister)  // класс реализующий два типа регистра аналоговый (16 бит) и битовый (16бит)
   private
    FRegBits  : TBitString;                    // битовое представление регистра
    function  GetRegBits(i: integer): Boolean;
    procedure SetRegBits(i: integer; const Value: Boolean);
   protected
    procedure SetValue(const Value: Word); override;
   public
    constructor Create; override;
    destructor  Destroy; override;
    property Value              : Word read FValue write SetValue;
    property RegBits[i:integer] : Boolean read GetRegBits write SetRegBits;
  end;

  TMBByteMixedRegister = class(TMBWordRegister)  // класс реализует разбиение регистра на байты
   private
    FHigthByte : TRegByte;                       // старший байт регистра
    FLowByte   : TRegByte;                       // младший байт регистра
    function  GetHigthByteValue: Byte;
    function  GetLowByteValue: Byte;
    function  GetHigthByteBits(i: integer): Boolean;
    function  GetLowByteBits(i: integer): Boolean;
    procedure SetHigthByteValue(const Value: Byte);
    procedure SetLowByteValue(const Value: Byte);
    procedure SetHigthByteBits(i: integer; const Value: Boolean);
    procedure SetLowByteBits(i: integer; const Value: Boolean);
    procedure OnHigthChange(Sender : TRegByte; ChangeBitSet : TRegBits = []);
    procedure OnLowChange(Sender : TRegByte; ChangeBitSet : TRegBits = []);
   protected
    procedure SetLowByteInWord(Value:Byte); virtual;
    procedure SetHigthByteInWord(Value:Byte); virtual;
    procedure SetValue(const Value: Word); override;
   public
    constructor Create; override;
    destructor  Destroy; override;
    property Value                    : Word read FValue write SetValue;
    property LowByteValue             : Byte read GetLowByteValue write SetLowByteValue;
    property HigthByteValue           : Byte read GetHigthByteValue write SetHigthByteValue;
    property LowByteBits[i:integer]   : Boolean read GetLowByteBits write SetLowByteBits;
    property HigthByteBits[i:integer] : Boolean read GetHigthByteBits write SetHigthByteBits;
    property OnChange                 : TOnRegWordChange read FOnChange write FOnChange;
  end;

  TMBDevice = class                      // абстрактный класс описывающий устройство
   private
    FDeviceID      : Byte;               // номер устройства
    function GetDeviceName: String;
   protected
    FRegListDiscret : TMBDiscretRegList; // список дискретных переменных устройства
    FRegListCoils   : TMBCoilRegList;    // список битовых переменных устройства
    FRegListInput   : TMBInputRegList;   // список входных переменных устройства
    FRegListHolding : TMBHoldingRegList; // список хранимых переменных устройства
    FDeviceType     : TDeviceID;         // идентификатор устройства по нашей классификации
   public
    constructor Create; virtual;
    destructor  Destroy; override;
    procedure Init(FileName : String = ''); virtual; abstract; // инициализация устройства - создание перечня переменных
    property DeviceID       : Byte read FDeviceID write FDeviceID;
    property DeviceName     : String read GetDeviceName;
    property DeviceType     : TDeviceID read FDeviceType;
    //property DiscretRegisters[Address : DWORD] : TMBBitRegister read GetDiscretRegisters;
    //property CoilsRegisters[Address : DWORD]   : TMBBitRegister read GetCoilsRegisters;
    //property InputRegisters[Address : DWORD]   : TMBWordRegister read GetInputRegisters;
    //property HoldingRegisters[Address : DWORD] : TMBWordRegister read GetHoldingRegisters;
  end;

implementation

uses SysUtils;

{ TMBWordRegister }

procedure TMBWordRegister.Assigin(Source: TMBWordRegister);
begin
  Address     := Source.Address;
  Value       := Source.Value;
  RegReadOnly := Source.RegReadOnly;
  OnChange    := Source.OnChange;
end;

constructor TMBWordRegister.Create;
begin
 FValue:=0;
 FRegType:=rtSimpleWord;
end;

procedure TMBWordRegister.SetValue(const Value: Word);
var TempBits : TRegBits;
begin
  if FReadOnly then raise Exception.Create(ErrReadOnly);
  if FValue= Value then Exit;
  TempBits:=[];
  TempBits:=GetWordChange(Value);
  FValue := Value;
  if Assigned(FOnChange) then FOnChange(Self,TempBits);
end;

function TMBWordRegister.GetWordChange(Value: Word): TRegBits;
begin
  Result:=[];
  if (((FValue and 1)=1) and ((Value and 1)<>1)) or
    (((Value and 1)<>1) and ((Value and 1)=1)) then
  begin
   Result:=Result+[rb0];
  end;
 if (((FValue and 2)=2) and ((Value and 2)<>2)) or
    (((Value and 2)<>2) and ((Value and 2)=2)) then
  begin
   Result:=Result+[rb1];
  end;
 if (((FValue and 4)=4) and ((Value and 4)<>4)) or
    (((Value and 4)<>4) and ((Value and 4)=4)) then
  begin
   Result:=Result+[rb2];
  end;
 if (((FValue and 8)=8) and ((Value and 8)<>8)) or
    (((Value and 8)<>8) and ((Value and 8)=8)) then
  begin
   Result:=Result+[rb3];
  end;
 if (((FValue and 16)=16) and ((Value and 16)<>16)) or
    (((Value and 16)<>16) and ((Value and 16)=16)) then
  begin
   Result:=Result+[rb4];
  end;
 if (((FValue and 32)=32) and ((Value and 32)<>32)) or
    (((Value and 32)<>32) and ((Value and 32)=32)) then
  begin
   Result:=Result+[rb5];
  end;
 if (((FValue and 64)=64) and ((Value and 64)<>64)) or
    (((Value and 64)<>64) and ((Value and 64)=64)) then
  begin
   Result:=Result+[rb6];
  end;
 if (((FValue and 128)=128) and ((Value and 128)<>128)) or
    (((Value and 128)<>128) and ((Value and 128)=128)) then
  begin
   Result:=Result+[rb7];
  end;
 if (((FValue and 256)=256) and ((Value and 256)<>256)) or
    (((Value and 256)<>256) and ((Value and 256)=256)) then
  begin
   Result:=Result+[rb8];
  end;
 if (((FValue and 512)=512) and ((Value and 512)<>512)) or
    (((Value and 512)<>512) and ((Value and 512)=512)) then
  begin
   Result:=Result+[rb9];
  end;
 if (((FValue and 1024)=1024) and ((Value and 1024)<>1024)) or
    (((Value and 1024)<>1024) and ((Value and 1024)=1024)) then
  begin
   Result:=Result+[rb10];
  end;
 if (((FValue and 2048)=2048) and ((Value and 2048)<>2048)) or
    (((Value and 2048)<>2048) and ((Value and 2048)=2048)) then
  begin
   Result:=Result+[rb11];
  end;
 if (((FValue and 4096)=4096) and ((Value and 4096)<>4096)) or
    (((Value and 4096)<>4096) and ((Value and 4096)=4096)) then
  begin
   Result:=Result+[rb12];
  end;
 if (((FValue and 8192)=8192) and ((Value and 8192)<>8192)) or
    (((Value and 8192)<>8192) and ((Value and 8192)=8192)) then
  begin
   Result:=Result+[rb13];
  end;
 if (((FValue and 16384)=16384) and ((Value and 16384)<>16384)) or
    (((Value and 16384)<>16384) and ((Value and 16384)=16384)) then
  begin
   Result:=Result+[rb14];
  end;
 if (((FValue and 32768)=32768) and ((Value and 32768)<>32768)) or
    (((Value and 32768)<>32768) and ((Value and 32768)=32768)) then
  begin
   Result:=Result+[rb15];
  end;
end;

{ TMBRegister }

constructor TMBRegister.Create;
begin
 FType:=rgHolding;
 FNumber:=0;
 FStrAdderss:='400001';
 FReadOnly:=False;
end;

function TMBRegister.GetAddress: DWord;
begin
 Result:=StrToInt(FStrAdderss);
end;

function TMBRegister.GetStrAddress: String;
begin
 Result:=FStrAdderss;
end;

procedure TMBRegister.SetAddress(const Value: DWord);
var str : String ;
begin
  TMBAddressActions.CheckAllDapasonAddress(Value);
  str := TMBAddressActions.GetStringAddress(Value);
  if (Value>0) and (Value<65535) then
   begin
    FType:=rgDiscrete;
    FNumber:=Value-1;
    FStrAdderss:=str;
    Exit;
   end;
  if (Value>100000) and (Value<165636) then
   begin
    FType:=rgCoils;
    FNumber:=Value-100001;
    FStrAdderss:=str;
    Exit;
   end;
  if (Value>300000) and (Value<365536) then
   begin
    FType:=rgInput;
    FNumber:=Value-300001;
    FStrAdderss:=str;
    Exit;
   end;
  if (Value>400000) and (Value<465536) then
   begin
    FType:=rgHolding;
    FNumber:=Value-400001;
    FStrAdderss:=str;
   end;
end;

procedure TMBRegister.SetRegNumber(const Value: Word);
begin
  if FNumber=Value then Exit;
  FNumber := Value;
end;

procedure TMBRegister.SetRegType(const Value: TRegMBTypes);
begin
  if FType=Value then Exit;
  FType := Value;
end;

{ TMBWordBitRegister }

constructor TMBWordBitRegister.Create;
begin
  inherited;
  FRegBits:=TBitString.Create;
  FRegBits.Size:=16;
  FRegType:=rtWord;
end;

destructor TMBWordBitRegister.Destroy;
begin
  FRegBits.Free;
  inherited;
end;

function TMBWordBitRegister.GetRegBits(i: integer): Boolean;
begin
 Result:=FRegBits.Bits[i];
end;

procedure TMBWordBitRegister.SetRegBits(i: integer; const Value: Boolean);
var TempBits : TRegBits;
begin
 if FRegBits.Bits[i]=Value then Exit;
 TempBits:=[];
 FRegBits.Bits[i]:=Value;
 case i of
   0:  begin if Value then FValue:= FValue or 1 else FValue:=FValue xor 1; TempBits:=[rb0] end;
   1:  begin if Value then FValue:= FValue or 2 else FValue:=FValue xor 2; TempBits:=[rb1] end;
   2:  begin if Value then FValue:= FValue or 4 else FValue:=FValue xor 4; TempBits:=[rb2] end;
   3:  begin if Value then FValue:= FValue or 8 else FValue:=FValue xor 8; TempBits:=[rb3] end;
   4:  begin if Value then FValue:= FValue or 16 else FValue:=FValue xor 16; TempBits:=[rb4] end;
   5:  begin if Value then FValue:= FValue or 32 else FValue:=FValue xor 32; TempBits:=[rb5] end;
   6:  begin if Value then FValue:= FValue or 64 else FValue:=FValue xor 64; TempBits:=[rb6] end;
   7:  begin if Value then FValue:= FValue or 128 else FValue:=FValue xor 128; TempBits:=[rb7] end;
   8:  begin if Value then FValue:= FValue or 256 else FValue:=FValue xor 256; TempBits:=[rb8] end;
   9:  begin if Value then FValue:= FValue or 512 else FValue:=FValue xor 512; TempBits:=[rb9] end;
   10: begin if Value then FValue:= FValue or 1024 else FValue:=FValue xor 1024; TempBits:=[rb10] end;
   11: begin if Value then FValue:= FValue or 2048 else FValue:=FValue xor 2048; TempBits:=[rb11] end;
   12: begin if Value then FValue:= FValue or 4096 else FValue:=FValue xor 4096; TempBits:=[rb12] end;
   13: begin if Value then FValue:= FValue or 8192 else FValue:=FValue xor 8192; TempBits:=[rb13] end;
   14: begin if Value then FValue:= FValue or 16384 else FValue:=FValue xor 16384; TempBits:=[rb14] end;
   15: begin if Value then FValue:= FValue or 32768 else FValue:=FValue xor 32768; TempBits:=[rb15] end;
 end;
 if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

procedure TMBWordBitRegister.SetValue(const Value: Word);
var TempBits : TRegBits;
begin
 if FReadOnly then raise Exception.Create(ErrReadOnly);
 if FValue=Value then Exit;
 TempBits:=[];
 TempBits:=GetWordChange(Value);
   if rb0 in TempBits then if ((Value and 1)=1) then FRegBits.Bits[0]:=True else FRegBits.Bits[0]:= False;
   if rb1 in TempBits then if ((Value and 2)=2) then FRegBits.Bits[1]:=True else FRegBits.Bits[1]:= False;
   if rb2 in TempBits then if ((Value and 4)=4) then FRegBits.Bits[2]:=True else FRegBits.Bits[2]:= False;
   if rb3 in TempBits then if ((Value and 8)=8) then FRegBits.Bits[3]:=True else FRegBits.Bits[3]:= False;
   if rb4 in TempBits then if ((Value and 16)=16) then FRegBits.Bits[4]:=True else FRegBits.Bits[4]:= False;
   if rb5 in TempBits then if ((Value and 32)=32) then FRegBits.Bits[5]:=True else FRegBits.Bits[5]:= False;
   if rb6 in TempBits then if ((Value and 64)=64) then FRegBits.Bits[6]:=True else FRegBits.Bits[6]:= False;
   if rb7 in TempBits then if ((Value and 128)=128) then FRegBits.Bits[7]:=True else FRegBits.Bits[7]:= False;
   if rb8 in TempBits then if ((Value and 256)=256) then FRegBits.Bits[8]:=True else FRegBits.Bits[8]:= False;
   if rb9 in TempBits then if ((Value and 512)=512) then FRegBits.Bits[9]:=True else FRegBits.Bits[9]:= False;
   if rb10 in TempBits then if ((Value and 1024)=1024) then FRegBits.Bits[10]:=True else FRegBits.Bits[10]:= False;
   if rb11 in TempBits then if ((Value and 2048)=2048) then FRegBits.Bits[11]:=True else FRegBits.Bits[11]:= False;
   if rb12 in TempBits then if ((Value and 4096)=4096) then FRegBits.Bits[12]:=True else FRegBits.Bits[12]:= False;
   if rb13 in TempBits then if ((Value and 8192)=8192) then FRegBits.Bits[13]:=True else FRegBits.Bits[13]:= False;
   if rb14 in TempBits then if ((Value and 16384)=16384) then FRegBits.Bits[14]:=True else FRegBits.Bits[14]:= False;
   if rb15 in TempBits then if ((Value and 32768)=32768) then FRegBits.Bits[15]:=True else FRegBits.Bits[15]:= False;
 FValue:=Value;
 if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

{ TMBByteMixedRegister }

constructor TMBByteMixedRegister.Create;
begin
  inherited;
  FLowByte:=TRegByte.Create;
  FLowByte.OnChange:=OnLowChange;
  FHigthByte:=TRegByte.Create;
  FHigthByte.OnChange:=OnHigthChange;
  FRegType:=rtWordByte;
end;

destructor TMBByteMixedRegister.Destroy;
begin
  FLowByte.Free;
  FHigthByte.Free;
  inherited;
end;

function TMBByteMixedRegister.GetHigthByteBits(i: integer): Boolean;
begin
 Result:=FHigthByte.Bits[i];
end;

function TMBByteMixedRegister.GetHigthByteValue: Byte;
begin
 Result:=FHigthByte.Value;
end;

function TMBByteMixedRegister.GetLowByteBits(i: integer): Boolean;
begin
 Result:=FLowByte.Bits[i];
end;

function TMBByteMixedRegister.GetLowByteValue: Byte;
begin
 Result:=FLowByte.Value;
end;

procedure TMBByteMixedRegister.SetHigthByteBits(i: integer; const Value: Boolean);
begin
 if FHigthByte.Bits[i]=Value then Exit;
 FHigthByte.Bits[i]:=Value;
 SetHigthByteInWord(FHigthByte.Value);
end;

procedure TMBByteMixedRegister.SetLowByteBits(i: integer; const Value: Boolean);
begin
 if FLowByte.Bits[i]=Value then Exit;
 FLowByte.Bits[i]:=Value;
 SetLowByteInWord(FLowByte.Value);
end;

procedure TMBByteMixedRegister.SetHigthByteValue(const Value: Byte);
begin
  if FHigthByte.Value=Value then Exit;
  SetHigthByteInWord(Value);
  FHigthByte.Value:=Value;
end;

procedure TMBByteMixedRegister.SetLowByteValue(const Value: Byte);
begin
 if FLowByte.Value=Value then Exit;
 SetLowByteInWord(Value);
 FLowByte.Value:=Value;
end;

procedure TMBByteMixedRegister.SetValue(const Value: Word);
begin
  if FReadOnly then raise Exception.Create(ErrReadOnly);
  if FValue=Value then Exit;
  FValue:=Value;
  FLowByte.Value:= Value and $00FF;
  FHigthByte.Value:= Value shr 8;
end;

procedure TMBByteMixedRegister.SetHigthByteInWord(Value: Byte);
var TempValue,TempNew : Word;
begin
  TempNew:=0;
  TempNew:=TempNew or Value;
  TempNew:=TempNew shl 8;
  TempValue:=(FValue and $00ff) or TempNew;
  FValue:=TempValue;
end;

procedure TMBByteMixedRegister.SetLowByteInWord(Value: Byte);
var TempValue : Word;
begin
 TempValue:=FValue;
 TempValue:=(TempValue and $ff00) or Value;
 FValue:= TempValue;
end;

procedure TMBByteMixedRegister.OnHigthChange(Sender: TRegByte; ChangeBitSet: TRegBits);
var TempBitSet : TRegBits;
begin
 if not Assigned(FOnChange) then Exit;
 TempBitSet:=[];
 if rb0 in ChangeBitSet then TempBitSet:=TempBitSet+[rb8];
 if rb1 in ChangeBitSet then TempBitSet:=TempBitSet+[rb9];
 if rb2 in ChangeBitSet then TempBitSet:=TempBitSet+[rb10];
 if rb3 in ChangeBitSet then TempBitSet:=TempBitSet+[rb11];
 if rb4 in ChangeBitSet then TempBitSet:=TempBitSet+[rb12];
 if rb5 in ChangeBitSet then TempBitSet:=TempBitSet+[rb13];
 if rb6 in ChangeBitSet then TempBitSet:=TempBitSet+[rb14];
 if rb7 in ChangeBitSet then TempBitSet:=TempBitSet+[rb15];
 FOnChange(Self,TempBitSet);
end;

procedure TMBByteMixedRegister.OnLowChange(Sender: TRegByte; ChangeBitSet: TRegBits);
begin
 if not Assigned(FOnChange) then Exit;
 FOnChange(Self,ChangeBitSet);
end;


{ TMBDevice }

constructor TMBDevice.Create;
begin
 FDeviceID:=0;
 FDeviceType:=diESSO;
 FRegListDiscret:=TMBDiscretRegList.Create;
 FRegListCoils:=TMBCoilRegList.Create;
 FRegListInput:=TMBInputRegList.Create;
 FRegListHolding:=TMBHoldingRegList.Create;
end;

destructor TMBDevice.Destroy;
begin
 FRegListDiscret.Free;
 FRegListCoils.Free;
 FRegListInput.Free;
 FRegListHolding.Free;
 inherited;
end;

function TMBDevice.GetDeviceName: String;
begin
 Result:=SUMODeviceName[FDeviceType];
end;

{ TMBBitRegister }

constructor TMBBitRegister.Create;
begin
  inherited;
  FValue:=False;
  FRegType:=rtBit;
end;

procedure TMBBitRegister.SetValue(const Value: Boolean);
begin
  if FReadOnly then raise Exception.Create(ErrReadOnly);
  if FValue= Value then Exit;
  FValue := Value;
  if Assigned(FOnChange) then FOnChange(Self)
end;


end.
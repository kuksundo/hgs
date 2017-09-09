unit MBRegistersCalsses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBResourceString, MBDefine, MBAddressActions, MBBitsClasses, MBByteClasses;

type
  TMBWordRegister  = class;
  TMBBitRegister   = class;

  TMBWordRegsArray = array of TMBWordRegister;
  TMBBitRegsArray  = array of TMBBitRegister;

  TMBWordRegsRangeArray = array of TMBWordRegsArray;
  TMBBitRegsRangeArray = array of TMBWordRegsArray;
  

  TBefoRegWordChange = procedure //  процедурный тип определяющий формат процедуры обработчика события происходящего перед изменением значения регистра
                               (Sender : TMBWordRegister; // изменяемый регистр
                                NewValue : Word;          // новое значение
                                var isChange : Boolean    // разрешить или запретить изменение значения
                                ) of object;
  TBefoRegBitChange = procedure // процедурный тип определяющий формат процедуры обработчика события происходящего перед изменением значения регистра
                               (Sender : TMBBitRegister;  // изменяемый регистр
                                NewValue : Boolean;       // новое значение
                                var isChange : Boolean    // разрешить или запретить изменение значения
                                ) of object;
  TOnRegWordChange = procedure // процедурный тип определяющий формат обработчика события изменения данных в регистре
                              (Sender       : TMBWordRegister;  // измененного регистра
                               ChangeBitSet : TRegBits = []     // список идентификаторов измененных бит
                               )of object;
  TOnRegBitChange = procedure(Sender : TMBBitRegister) of object;

  TOnRegsWordChange = procedure // процедурный тип определяющий формат обработчика события изменения данных в наборе регистров
                              (Sender       : TObject;          // объект в котором изменены регистры
                               ChangedRegs  : TMBWordRegsArray  // список измененных регистров
                               )of object;
  TOnRegsBitChange = procedure(Sender      : TObject;
                               ChangedRegs : TMBBitRegsArray
                              ) of object;

  { TMBRegister }

  TMBRegister = class(TObject) // базовый класс для регистров не содержит полей данных, содержит только поля для обработки адреса
   private
    FMBRegType  : TRegMBTypes;       // тип диапазона регистров
    FNumber     : Word;              // номер регистра в диапазоне. первое значение - 1
    FStrAddress : String;            // строковое представление адреса
    FDescr      : String;
    function  GetAddress: DWORD;
    procedure SetAddress(const aValue: DWord);
    procedure SetRegNumber(const aValue: Word);
    procedure SetMBRegType(const aValue: TRegMBTypes);
   protected
    FReadOnly : Boolean;           // флаг регистр только на чтение
    function  CheckType(const aValue: TRegMBTypes): boolean; virtual;
    procedure SetDescr(const AValue : String); virtual;
   public
    constructor Create; virtual;
    function GetStrAddress : String; virtual;
    property MBRegType     : TRegMBTypes read FMBRegType write SetMBRegType;
    property Address       : DWORD read GetAddress write SetAddress;
    property RegNumber     : Word read FNumber write SetRegNumber;
    property RegReadOnly   : Boolean read FReadOnly write FReadOnly;
    property Description   : String read FDescr write SetDescr;
  end;

  TMBRegisterArray = array[0..65535] of TMBRegister;

  { TMBBitRegister }

  TMBBitRegister = class(TMBRegister)// класс описывающий битовый регистр
   protected
    FRegType       : TRegTypes;         // тип регистра
    FOnChange      : TOnRegBitChange;   // обработчик события изменения значения регистра
    FBefoChange    : TBefoRegBitChange; // обработчик события возбуждаемого перед изменением значения
    FValue         : Boolean;           // значение регистра
    FPreviousValue : Boolean;           // предыдущее значение
    FIsChanged     : Boolean;           // флаг изменения регистра
    FLastUpdateTime: TDateTime;         // время последнего обновления переменной
    function  GetValue: Boolean; virtual;
    procedure SetValue(const aValue: Boolean); virtual;
    procedure SetDescr(const AValue : String); override;
    function  CheckType(const aValue: TRegMBTypes): boolean; override;
   public
    constructor Create; override;
    procedure Assigin(Source: TMBBitRegister); virtual;
    procedure SetDefValue(aValue:Boolean);
    {
     Метод (ServerSideSetValue) позволяющий присвоить значение без проверки на допустимость записи в
     данный регистр (для регистров предназначенных только на чтение). Все
     остальные проверки и возбуждение событий производятся в штатном режиме.
    }
    procedure ServerSideSetValue(aValue : Boolean); virtual;

    property RegType       : TRegTypes read FRegType;
    property Value         : Boolean read GetValue write SetValue;
    property IsChanged     : Boolean read FIsChanged write FIsChanged;
    property PreviousValue : Boolean  read FPreviousValue;
    property LastUpdateTime: TDateTime read FLastUpdateTime;
    property OnChange      : TOnRegBitChange read FOnChange write FOnChange;
    property BefoChange    : TBefoRegBitChange read FBefoChange write FBefoChange;
  end;

  { TMBWordRegister }

  TMBWordRegister = class(TMBRegister)// класс описывающий word регистр Modbus
   protected
    FValue         : Word;               // значение, содержащееся в регистре
    FPreviousValue : Word;               // предыдущее значение
    FRegType       : TRegTypes;          // тип регистра word или смесь байтов
    FIsChanged     : Boolean;            // флаг изменения регистра
    FLastUpdateTime: TDateTime;          // время последнего обновления переменной
    FOnChange      : TOnRegWordChange;   // обработчик события изменения регистра
    FBefoChange    : TBefoRegWordChange; // обработчик события возбуждаемого перед изменением значения
    function  GetValue: Word; virtual;
    procedure SetValue(const aValue: Word); virtual;
    procedure SetDescr(const AValue : String); override;
    function  GetWordChange(aValue:Word): TRegBits; virtual;
    function  CheckType(const aValue: TRegMBTypes): boolean; override;
   public
    constructor Create; override;
    procedure Assigin(Source : TMBWordRegister); virtual;
    procedure SetDefValue(aValue : Word); virtual;
    {
     Метод (ServerSideSetValue) позволяющий присвоить значение без проверки на допустимость записи в
     данный регистр (для регистров предназначенных только на чтение). Все
     остальные проверки и возбуждение событий производятся в штатном режиме.
    }
    procedure ServerSideSetValue(aValue : Word); virtual;

    property RegType       : TRegTypes read FRegType;
    property Value         : Word read GetValue write SetValue;
    property IsChanged     : Boolean read FIsChanged write FIsChanged;
    property PreviousValue : Word read FPreviousValue;
    property LastUpdateTime: TDateTime read FLastUpdateTime;
    property OnChange      : TOnRegWordChange read FOnChange write FOnChange;
    property BefoChange    : TBefoRegWordChange read FBefoChange write FBefoChange;
  end;

  TMBWordBitRegister = class(TMBWordRegister)  // класс реализующий два типа регистра аналоговый (16 бит) и битовый (16 бит)
   private
    FRegBits: TBitString;  // битовое представление регистра
    function  GetRegBits(Index: integer): Boolean;
    procedure SetRegBits(Index: integer; const AValue: Boolean);
   protected
    procedure SetValue(const AValue: Word); override;
    procedure SetBits(const AValue : Word);
   public
    constructor Create; override;
    destructor  Destroy; override;
    procedure SetDefValue(AValue : Word); override;
    {
     Метод (ServerSideSetValue) позволяющий присвоить значение без проверки на допустимость записи в
     данный регистр (для регистров предназначенных только на чтение). Все
     остальные проверки и возбуждение событий производятся в штатном режиме.
    }
    procedure ServerSideSetValue(AValue : Word); override;
    property Value;
    property RegBits[Index: integer]: Boolean read GetRegBits write SetRegBits;
  end;

  TMBByteMixedRegister = class(TMBWordRegister)  // класс реализует разбиение регистра на байты
   private
    FHighByte,           // старший байт регистра
    FLowByte: TRegByte;  // младший байт регистра
    function  GetHighByteValue: Byte;
    function  GetLowByteValue: Byte;
    function  GetHighByteBits(Index: integer): Boolean;
    function  GetLowByteBits(Index: integer): Boolean;
    procedure SetHighByteValue(const AValue: Byte);
    procedure SetLowByteValue(const AValue: Byte);
    procedure SetHighByteBits(Index: integer; const AValue: Boolean);
    procedure SetLowByteBits(Index: integer; const AValue: Boolean);
    procedure OnHighChange(Sender: TRegByte; ChangeBitSet: TRegBits = []);
    procedure OnLowChange(Sender: TRegByte; ChangeBitSet: TRegBits = []);
   protected
    function  SetByteInWord(AValue: Byte; High: boolean): Boolean; virtual;
    procedure SetValue(const AValue: Word); override;
   public
    constructor Create; override;
    destructor  Destroy; override;
    procedure SetDefValue(AValue : Word); override;
    {
     Метод (ServerSideSetValue) позволяющий присвоить значение без проверки на допустимость записи в
     данный регистр (для регистров предназначенных только на чтение). Все
     остальные проверки и возбуждение событий производятся в штатном режиме.
    }
    procedure ServerSideSetValue(AValue : Word); override;
//    property Value;
    property LowByteValue: Byte read GetLowByteValue write SetLowByteValue;
    property HighByteValue: Byte read GetHighByteValue write SetHighByteValue;
    property LowByteBits[Index: integer]: Boolean read GetLowByteBits write SetLowByteBits;
    property HighByteBits[Index: integer]: Boolean read GetHighByteBits write SetHighByteBits;
    property OnChange: TOnRegWordChange read FOnChange write FOnChange;
  end;

implementation

uses SysUtils;

{ TMBRegister }

constructor TMBRegister.Create;
begin
  FMBRegType  := rgHolding;
  FNumber     := 0;
  FStrAddress := '400001';
  FReadOnly   := False;
end;

function TMBRegister.GetStrAddress: String;
begin
  Result:= FStrAddress;
end;

function TMBRegister.GetAddress: DWORD;
begin
  Result:= StrToInt(FStrAddress);
end;

procedure TMBRegister.SetAddress(const aValue: DWord);
var NewType: TRegMBTypes;
begin
  NewType:= TMBAddressActions.GetAddressType(aValue);
  if not CheckType(NewType) then raise Exception.Create(ErrOutOfRange);
  
  FMBRegType:= TMBAddressActions.GetAddressType(aValue);
  FNumber:= TMBAddressActions.GetRegNumber(aValue);
  FStrAddress:= TMBAddressActions.GetStringAddress(aValue);
end;

procedure TMBRegister.SetDescr(const AValue : String);
begin
  FDescr := AValue;
end;

procedure TMBRegister.SetRegNumber(const aValue: Word);
begin
  if FNumber = aValue then Exit;
  FNumber := aValue;
  FStrAddress:= TMBAddressActions.MakeStringAddress(FMBRegType, FNumber);
end;

procedure TMBRegister.SetMBRegType(const aValue: TRegMBTypes);
begin
  if (FMBRegType = aValue) or not CheckType(aValue) then Exit;
  FMBRegType := aValue;
  FStrAddress:= TMBAddressActions.MakeStringAddress(FMBRegType, FNumber);
  case FMBRegType of
   rgDiscrete,rgInput : FReadOnly:=True;
   rgCoils,rgHolding  : FReadOnly:=False;
  end;
end;

function TMBRegister.CheckType(const aValue: TRegMBTypes): boolean;
begin
  Result:= true;
end;

{ TMBBitRegister }

constructor TMBBitRegister.Create;
begin
  inherited Create;
  FValue:= False;
  FPreviousValue:=False;
  FRegType:= rtBit;
  FLastUpdateTime := 0;
end;

function TMBBitRegister.CheckType(const aValue: TRegMBTypes): boolean;
begin
  Result:= (aValue = rgDiscrete) or (aValue = rgCoils);
end;

procedure TMBBitRegister.Assigin(Source: TMBBitRegister);
begin
  Address   := Source.Address;
  FValue    := Source.Value;
  FReadOnly := Source.RegReadOnly;
  FOnChange := Source.OnChange;
end;

procedure TMBBitRegister.SetValue(const aValue: Boolean);
begin
  if FReadOnly then raise Exception.Create(ErrReadOnly);
  ServerSideSetValue(aValue);
end;

procedure TMBBitRegister.SetDescr(const AValue : String);
begin
  if SameText(AValue,Description) then Exit;
  inherited SetDescr(AValue);
  FIsChanged := True;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMBBitRegister.SetDefValue(aValue: Boolean);
begin
  FValue := aValue;
end;

function TMBBitRegister.GetValue: Boolean;
begin
  Result     := FValue;
  FIsChanged := False;
end;

procedure TMBBitRegister.ServerSideSetValue(aValue: Boolean);
var ChangeAccept : Boolean;
begin
  if FValue = aValue then Exit;
  ChangeAccept:=True;
  if Assigned(FBefoChange) then FBefoChange(Self, aValue, ChangeAccept);
  if not ChangeAccept then Exit;
  FPreviousValue := FValue;
  FValue         := aValue;
  FLastUpdateTime:= Now;
  FIsChanged     := True;
  if Assigned(FOnChange) then FOnChange(Self);
end;

{ TMBWordRegister }

constructor TMBWordRegister.Create;
begin
 inherited Create;
 FValue          := 0;
 FPreviousValue  := 0;
 FRegType        := rtSimpleWord;
 FLastUpdateTime := 0;
end;

function TMBWordRegister.CheckType(const aValue: TRegMBTypes): boolean;
begin
  Result:= (aValue = rgInput) or (aValue = rgHolding);
end;

procedure TMBWordRegister.Assigin(Source: TMBWordRegister);
begin
  Address     := Source.Address;
  FValue      := Source.Value;
  FReadOnly   := Source.RegReadOnly;
  FOnChange   := Source.OnChange;
  FBefoChange := Source.BefoChange;
end;

procedure TMBWordRegister.SetValue(const aValue: Word);
begin
  if FReadOnly then raise Exception.Create(ErrReadOnly);
  ServerSideSetValue(aValue);
end;

procedure TMBWordRegister.SetDescr(const AValue : String);
var TempBits : TRegBits;
begin
  if SameText(AValue,Description) then Exit;
  inherited SetDescr(AValue);
  TempBits   := [];
  FIsChanged := True;
  if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

function TMBWordRegister.GetWordChange(aValue: Word): TRegBits;
begin
  Result:=[];
  if (FValue and $0001)<>(aValue and $0001) then
  begin
   Result:=Result+[rw0];
  end;
  if (FValue and $0002)<>(aValue and $0002) then
  begin
   Result:=Result+[rw1];
  end;
  if (FValue and $0004)<>(aValue and $0004) then
  begin
   Result:=Result+[rw2];
  end;
  if (FValue and $0008)<>(aValue and $0008) then
  begin
   Result:=Result+[rw3];
  end;
  if (FValue and $0010)<>(aValue and $0010) then
  begin
   Result:=Result+[rw4];
  end;
  if (FValue and $0020)<>(aValue and $0020) then
  begin
   Result:=Result+[rw5];
  end;
  if (FValue and $0040)<>(aValue and $0040) then
  begin
   Result:=Result+[rw6];
  end;
  if (FValue and $0080)<>(aValue and $0080) then
  begin
   Result:=Result+[rw7];
  end;
  if (FValue and $0100)<>(aValue and $0100) then
  begin
   Result:=Result+[rw8];
  end;
  if (FValue and $0200)<>(aValue and $0200) then
  begin
   Result:=Result+[rw9];
  end;
  if (FValue and $0400)<>(aValue and $0400) then
  begin
   Result:=Result+[rw10];
  end;
  if (FValue and $0800)<>(aValue and $0800) then
  begin
   Result:=Result+[rw11];
  end;
  if (FValue and $1000)<>(aValue and $1000) then
  begin
   Result:=Result+[rw12];
  end;
  if (FValue and $2000)<>(aValue and $2000) then
  begin
   Result:=Result+[rw13];
  end;
  if (FValue and $4000)<>(aValue and $4000) then
  begin
   Result:=Result+[rw14];
  end;
  if (FValue and $8000)<>(aValue and $8000) then
  begin
   Result:=Result+[rw15];
  end;
end;

procedure TMBWordRegister.SetDefValue(aValue: Word);
begin
  FValue := aValue;
end;

function TMBWordRegister.GetValue: Word;
begin
  Result     := FValue;
  FIsChanged := False;
end;

procedure TMBWordRegister.ServerSideSetValue(aValue: Word);
var ChangeAccept : Boolean;
    TempBits : TRegBits;
begin
  if FValue = aValue then Exit;
  ChangeAccept:=True;
  if Assigned(FBefoChange) then FBefoChange(Self, aValue, ChangeAccept);
  if not ChangeAccept then Exit;
  TempBits:=[];
  TempBits:= GetWordChange(aValue);
  FPreviousValue := FValue;
  FValue         := aValue;
  FLastUpdateTime:= Now;
  FIsChanged     := True;
  if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

{ TMBWordBitRegister }

constructor TMBWordBitRegister.Create;
begin
  inherited Create;
  FRegBits:=TBitString.Create;
  FRegBits.Size:=16;
  FRegType:=rtWord;
end;

destructor TMBWordBitRegister.Destroy;
begin
  FRegBits.Free;
  inherited;
end;

function TMBWordBitRegister.GetRegBits(Index: integer): Boolean;
begin
  Result:=FRegBits.Bits[Index];
end;

procedure TMBWordBitRegister.ServerSideSetValue(AValue: Word);
var ChangeAccept : Boolean;
    TempBits : TRegBits;
begin
 if FValue=Value then Exit;
 ChangeAccept:=True;
 if Assigned(FBefoChange) then FBefoChange(Self,Value,ChangeAccept);
 if not ChangeAccept then Exit;
 TempBits := [];
 TempBits := GetWordChange(Value);
 SetBits(Value);
 FPreviousValue:=FValue;
 FValue:=Value;
 FIsChanged:=True;
 if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

procedure TMBWordBitRegister.SetBits(const AValue: Word);
var TempBits : TRegBits;
begin
 TempBits:=[];
 TempBits:=GetWordChange(Value);
 if rw0  in TempBits then if ((Value and $0001)=$0001) then FRegBits.Bits[0]:=True else FRegBits.Bits[0]:= False;
 if rw1  in TempBits then if ((Value and $0002)=$0002) then FRegBits.Bits[1]:=True else FRegBits.Bits[1]:= False;
 if rw2  in TempBits then if ((Value and $0004)=$0004) then FRegBits.Bits[2]:=True else FRegBits.Bits[2]:= False;
 if rw3  in TempBits then if ((Value and $0008)=$0008) then FRegBits.Bits[3]:=True else FRegBits.Bits[3]:= False;
 if rw4  in TempBits then if ((Value and $0010)=$0010) then FRegBits.Bits[4]:=True else FRegBits.Bits[4]:= False;
 if rw5  in TempBits then if ((Value and $0020)=$0020) then FRegBits.Bits[5]:=True else FRegBits.Bits[5]:= False;
 if rw6  in TempBits then if ((Value and $0040)=$0040) then FRegBits.Bits[6]:=True else FRegBits.Bits[6]:= False;
 if rw7  in TempBits then if ((Value and $0080)=$0080) then FRegBits.Bits[7]:=True else FRegBits.Bits[7]:= False;
 if rw8  in TempBits then if ((Value and $0100)=$0100) then FRegBits.Bits[8]:=True else FRegBits.Bits[8]:= False;
 if rw9  in TempBits then if ((Value and $0200)=$0200) then FRegBits.Bits[9]:=True else FRegBits.Bits[9]:= False;
 if rw10 in TempBits then if ((Value and $0400)=$0400) then FRegBits.Bits[10]:=True else FRegBits.Bits[10]:= False;
 if rw11 in TempBits then if ((Value and $0800)=$0800) then FRegBits.Bits[11]:=True else FRegBits.Bits[11]:= False;
 if rw12 in TempBits then if ((Value and $1000)=$1000) then FRegBits.Bits[12]:=True else FRegBits.Bits[12]:= False;
 if rw13 in TempBits then if ((Value and $2000)=$2000) then FRegBits.Bits[13]:=True else FRegBits.Bits[13]:= False;
 if rw14 in TempBits then if ((Value and $4000)=$4000) then FRegBits.Bits[14]:=True else FRegBits.Bits[14]:= False;
 if rw15 in TempBits then if ((Value and $8000)=$8000) then FRegBits.Bits[15]:=True else FRegBits.Bits[15]:= False;
end;

procedure TMBWordBitRegister.SetDefValue(AValue: Word);
begin
  inherited SetDefValue(Value);
  SetBits(Value);
end;

procedure TMBWordBitRegister.SetRegBits(Index: integer; const AValue: Boolean);
var TempBits : TRegBits;
    TempValue: WORD;
    ChangeAccept : Boolean;
begin
 if FRegBits.Bits[Index]= AValue then Exit;
 if FReadOnly then raise Exception.Create(ErrReadOnly);
 TempBits:=[];
 TempValue:= FValue;
 case Index of
   0:  begin
         if AValue then TempValue:= TempValue or $0001
         else TempValue:= TempValue xor $0001;
         TempBits:=[rw0];
       end;
   1:  begin
         if AValue then TempValue:= TempValue or $0002
         else TempValue:= TempValue xor $0002;
         TempBits:=[rw1];
       end;
   2:  begin
         if AValue then TempValue:= TempValue or $0004
         else TempValue:= TempValue xor $0004;
         TempBits:=[rw2];
       end;
   3:  begin
         if AValue then TempValue:= TempValue or $0008
         else TempValue:= TempValue xor $0008;
         TempBits:=[rw3];
       end;
   4:  begin
         if AValue then TempValue:= TempValue or $0010
         else TempValue:= TempValue xor $0010;
         TempBits:=[rw4];
       end;
   5:  begin
         if AValue then TempValue:= TempValue or $0020
         else TempValue:= TempValue xor $0020;
         TempBits:=[rw5];
       end;
   6:  begin
         if AValue then TempValue:= TempValue or $0040
         else TempValue:= TempValue xor $0040;
         TempBits:=[rw6];
       end;
   7:  begin
         if AValue then TempValue:= TempValue or $0080
         else TempValue:= TempValue xor $0080;
         TempBits:=[rw7];
       end;
   8:  begin
         if AValue then TempValue:= TempValue or $0100
         else TempValue:= TempValue xor $0100;
         TempBits:=[rw8];
       end;
   9:  begin
         if AValue then TempValue:= TempValue or $0200
         else TempValue:= TempValue xor $0200;
         TempBits:=[rw9];
       end;
   10: begin
         if AValue then TempValue:= TempValue or $0400
         else TempValue:= TempValue xor $0400;
         TempBits:=[rw10];
       end;
   11: begin
         if AValue then TempValue:= TempValue or $0800
         else TempValue:= TempValue xor $0800;
         TempBits:=[rw11];
       end;
   12: begin
         if AValue then TempValue:= TempValue or $1000
         else TempValue:= TempValue xor $1000;
         TempBits:=[rw12];
       end;
   13: begin
         if AValue then TempValue:= TempValue or $2000
         else TempValue:= TempValue xor $2000;
         TempBits:=[rw13];
       end;
   14: begin
         if AValue then TempValue:= TempValue or $4000
         else TempValue:= TempValue xor $4000;
         TempBits:=[rw14];
       end;
   15: begin
         if AValue then TempValue:= TempValue or $8000
         else TempValue:= TempValue xor $8000;
         TempBits:=[rw15];
       end;
 end;
 if TempValue=FValue then Exit;
 ChangeAccept:=True;
 if Assigned(FBefoChange) then FBefoChange(Self, TempValue, ChangeAccept);
 FValue:= TempValue;
 FRegBits.Bits[Index]:= AValue;
 if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

procedure TMBWordBitRegister.SetValue(const AValue: Word);
begin
 if FReadOnly then raise Exception.Create(ErrReadOnly);
 ServerSideSetValue(Value);
end;

{ TMBByteMixedRegister }

constructor TMBByteMixedRegister.Create;
begin
  inherited Create;
  FLowByte:= TRegByte.Create;
  FLowByte.OnChange:= @OnLowChange;
  FHighByte:=TRegByte.Create;
  FHighByte.OnChange:= @OnHighChange;
  FRegType:= rtWordByte;
end;

destructor TMBByteMixedRegister.Destroy;
begin
  FLowByte.Free;
  FHighByte.Free;
  inherited;
end;

function TMBByteMixedRegister.GetHighByteBits(Index: integer): Boolean;
begin
  Result:=FHighByte.Bits[Index];
end;

function TMBByteMixedRegister.GetHighByteValue: Byte;
begin
  Result:=FHighByte.Value;
end;

function TMBByteMixedRegister.GetLowByteBits(Index: integer): Boolean;
begin
  Result:=FLowByte.Bits[Index];
end;

function TMBByteMixedRegister.GetLowByteValue: Byte;
begin
  Result:=FLowByte.Value;
end;

procedure TMBByteMixedRegister.SetHighByteBits(Index: integer; const AValue: Boolean);
begin
  if FHighByte.Bits[Index] = AValue then Exit;
  if SetByteInWord(FHighByte.Value, true) then FHighByte.Bits[Index]:= AValue;
end;

procedure TMBByteMixedRegister.SetLowByteBits(Index: integer; const AValue: Boolean);
begin
 if FLowByte.Bits[Index] = AValue then Exit;
 if SetByteInWord(FLowByte.Value, false) then FLowByte.Bits[Index]:= AValue;
end;

procedure TMBByteMixedRegister.SetHighByteValue(const AValue: Byte);
begin
  if FHighByte.Value = AValue then Exit;
  if SetByteInWord(AValue, true) then FHighByte.Value:= AValue;
end;

procedure TMBByteMixedRegister.SetLowByteValue(const AValue: Byte);
begin
 if FLowByte.Value = AValue then Exit;
 if SetByteInWord(AValue, false) then FLowByte.Value:=AValue;
end;

function TMBByteMixedRegister.SetByteInWord(AValue: Byte; High: boolean): Boolean;
var ChangeAccept : Boolean;
    NewValue: Word;
begin
  Result:= false;
  if FReadOnly then raise Exception.Create(ErrReadOnly);
  ChangeAccept:=true;
  if High then NewValue:= (FValue and $00FF) or (AValue shl 8)
  else NewValue:= (FValue and $FF00) or AValue;
  if Assigned(FBefoChange) then FBefoChange(Self, NewValue, ChangeAccept);
  if not ChangeAccept then Exit;
  FValue:= NewValue;
  Result:= true;
end;

procedure TMBByteMixedRegister.SetValue(const AValue: Word);
begin
  if FReadOnly then raise Exception.Create(ErrReadOnly);
  ServerSideSetValue(AValue);
end;

procedure TMBByteMixedRegister.OnHighChange(Sender: TRegByte; ChangeBitSet: TRegBits);
var TempBitSet : TRegBits;
begin
  if not Assigned(FOnChange) then Exit;
  TempBitSet:=[];
  if rw0 in ChangeBitSet then TempBitSet:=TempBitSet+[rw8];
  if rw1 in ChangeBitSet then TempBitSet:=TempBitSet+[rw9];
  if rw2 in ChangeBitSet then TempBitSet:=TempBitSet+[rw10];
  if rw3 in ChangeBitSet then TempBitSet:=TempBitSet+[rw11];
  if rw4 in ChangeBitSet then TempBitSet:=TempBitSet+[rw12];
  if rw5 in ChangeBitSet then TempBitSet:=TempBitSet+[rw13];
  if rw6 in ChangeBitSet then TempBitSet:=TempBitSet+[rw14];
  if rw7 in ChangeBitSet then TempBitSet:=TempBitSet+[rw15];
  FOnChange(Self, TempBitSet);
end;

procedure TMBByteMixedRegister.OnLowChange(Sender: TRegByte; ChangeBitSet: TRegBits = []);
begin
  if Assigned(FOnChange) then FOnChange(Self, ChangeBitSet);
end;

procedure TMBByteMixedRegister.SetDefValue(AValue: Word);
begin
  inherited SetDefValue(AValue);
  FLowByte.Value:= AValue and $00FF;
  FHighByte.Value:= AValue shr 8;
end;

procedure TMBByteMixedRegister.ServerSideSetValue(AValue: Word);
var ChangeAccept : Boolean;
    TempBits : TRegBits;
begin
  if FValue = AValue then Exit;
  ChangeAccept:= True;
  if Assigned(FBefoChange) then FBefoChange(Self, AValue, ChangeAccept);
  if not ChangeAccept then Exit;
  TempBits:=[];
  TempBits:= GetWordChange(AValue);
  FPreviousValue:=FValue;
  FValue:= AValue;
  FIsChanged := True;
  FLowByte.Value:= AValue and $00FF;
  FHighByte.Value:= AValue shr 8;
  if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

end.

unit MBRegListClasses;

{$mode objfpc}{$H+}

interface

uses Windows, IniFiles, Classes,
     MBDefine, MBRegistersCalsses;

type

 TMBRegList = class
   protected
    FHashedList  : THashedStringList;      // хэшированный список переменных, хэш строится по адресу регистра преобразованного в строку
    FRegDefType  : TRegTypes;              // тип объекта регистра по умолчанию
    FRegListType : TRegMBTypes;            // тип списка регистров
    FRegRanges   : TMBRegistersRangeArray; // список диапазонов регистров
    function  GetStringAddress(Address: DWORD): String; virtual;
    function  MakeStringAddress(RegNum: Word): String; virtual;
    function  IsRangeOnTheList(StartAddr: DWORD; Count: Word): Boolean; virtual;
    procedure CheckAddress(Address: DWORD); virtual; abstract;

    function  GetCount: Integer;
    function  GetRegRangeCount: Integer;
    function  GetRegRanges(index: Integer): TMBRegistersRange;
   public
    constructor Create; virtual;
    destructor  Destroy; override;
    procedure Clear; virtual;                                  // очищает список с уничтожением переменных
    procedure MakeList(StartAddr: DWORD; Count: Word); virtual; abstract; // создание списка по его стартовому адресу и количеству регистров
    function  Add(Address: DWORD): Integer; virtual; abstract; // добавляет переменную в список и возвращает ее индекс
    procedure Delete(Address: DWORD);                          // удаляет переменную по ее индексу
    function  IndexOf(Address: DWORD): Integer;                // выдает индекс переменной в списке по ее адресу
    function  GetRegList : TStrings;                           // выдает строковый список адресов регистров в списке
    property RegDefType    : TRegTypes read FRegDefType;
    property RegListType   : TRegMBTypes read FRegListType;
    property Count         : Integer read GetCount;
    property RegRangeCount : Integer read GetRegRangeCount;
    property RegRanges[index : Integer]: TMBRegistersRange read GetRegRanges;
  end;

  TMBBitRegList = class(TMBRegList)       // абстрактный класс для списка битовых регистров
   private
    function  GetRegisters(Address : DWORD): TMBBitRegister;
    procedure SetOnChange(const Value: TOnRegBitChange);
    procedure SetBefoChange(const Value: TBefoRegBitChange);
    function  GetIndexRegisters(Index: Integer): TMBBitRegister;
   protected
    FOnChange   : TOnRegBitChange;         // ссылка на процедуру обработчик события изменения значения регистра
    FBefoChange : TBefoRegBitChange;       // обработчик события возбуждаемого перед изменением значения регистра
   public
    constructor Create; override;
    function Add(Address : DWord):Integer; override;
    property Register[Index : Integer] : TMBBitRegister read GetIndexRegisters;
    property Registers[Address : DWORD] : TMBBitRegister read GetRegisters;
    property OnRegChange : TOnRegBitChange read FOnChange write SetOnChange;
    property BefoChange  : TBefoRegBitChange read FBefoChange write SetBefoChange;
  end;

  TMBDiscretRegList = class(TMBBitRegList)// класс реализующий список дискретных переменных
   protected
    procedure CheckAddress(Address : DWORD);override;
   public
    constructor Create; override;
    procedure MakeList(StartAddr : DWORD; Count : Word);override;
  end;

  TMBCoilRegList = class(TMBBitRegList)   // класс реализующий список битовых переменных доступных для записи (coils)
   protected
    procedure CheckAddress(Address : DWORD);override;
   public
    constructor Create; override;
    procedure MakeList(StartAddr : DWORD; Count : Word);override;
  end;

  TMBWordRegList = class(TMBRegList)      // абстрактный класс для списка 16-и битных регистров
   private
    function  GetRegisters(Address : DWORD): TMBWordRegister;
    procedure SetOnChange(const Value: TOnRegWordChange);
    procedure SetBefoChange(const Value: TBefoRegWordChange);
    function  GetIndexRegisters(Index: Integer): TMBWordRegister;
   protected
    FOnChange   : TOnRegWordChange;        // ссылка на процедуру обработчик события изменения значения регистра
    FBefoChange : TBefoRegWordChange;      // обработчик события возбуждаемого перед изменением значения регистра
    procedure SetDefRegType(const Value: TRegTypes); virtual;
   public
    constructor Create; override;
    function  Add(Address : DWord):Integer; override;
    procedure ChangeWordRegType(Address:DWORD; RegType:TRegTypes); virtual; // замена типа регистра
    property RegDefType  : TRegTypes read FRegDefType write SetDefRegType;
    property Register[Index : Integer] : TMBWordRegister read GetIndexRegisters;
    property Registers[Address : DWORD] : TMBWordRegister read GetRegisters;
    property OnRegChange : TOnRegWordChange read FOnChange write SetOnChange;
    property BefoChange  : TBefoRegWordChange read FBefoChange write SetBefoChange;
  end;

  TMBInputRegList = class(TMBWordRegList) // класс реализующий список Input регистров
   protected
    procedure CheckAddress(Address : DWORD);override;
   public
    constructor Create; override;
    procedure MakeList(StartAddr : DWORD; Count : Word);override;
  end;

  TMBHoldingRegList = class(TMBWordRegList) // класс реализующий список Holding регистров
  protected
    procedure CheckAddress(Address: DWORD); override;
  public
    constructor Create; override;
    procedure MakeList(StartAddr: DWORD; Count: Word); override;
  end;

{
 Класс реализующий фиксированный диапазон (кадр) списка WORD-регистров типа Holding.
 Формат диапазона: стартовый номер регистра - количество регистров
}
  TMBCustomFrameRegList = class
  private
    FList        : TList;       // список переменных
    FRegListType : TRegMBTypes; // тип списка регистров (поле фиксированное, может изменяться в наследниках)
    FRegDefValue : word;        // значение добавляемых регистров по умолчанию
    FStartAddress: word;        // стартовый адрес регистра в кадре
  protected
   { обработчики свойств класса }
    function  GetCount: integer;  virtual;
    procedure SetRegDefValue(const Value: word);  virtual;
    function  GetItem(Index: integer): TMBWordRegister;  virtual;
    function  GetRegister(Address: word): TMBWordRegister; virtual;

   { удаляет из списка набор регистров с указанного индекса до конца списка }
    procedure DeleteItems(Index: integer); virtual;

   { уничтожает регистр в списке по индексу }
    procedure ReleaseItem(Index: integer); virtual;

   { очищает список }
    procedure Clear; virtual;

   { возвращает указатель на новый регистр, инициализируемый Default-значениями }
    function  NewItem:TMBWordRegister ; virtual;

   { вставляет в список набор регистров, инициализируемых Default-значениями.
     возвращает новое количество элементов в списке.
     если After = false, тогда элементы добавляются в начало списка со смещением FStartAddress }
    function  AddItems(After: boolean; Quantity: integer): integer;

   { проверяет адрес на принадлежность текущему диапазону }
    function  CheckAddress(Address: word): boolean; virtual;

   { проверяет индекс на принадлежность существующему списку }
    function  CheckIndex(const Index: integer): boolean; virtual;

   { возвращает адрес регистра в строковом представлении }
    function  GetStringAddress(Address: word): String; virtual;

   { создает новый список по его стартовому адресу и количеству регистров.
     существующие регистры списка удаляются.
     вновь создаваемым регистрам списка присваиваются значения FRegDefType и FRegDefValue.
     возвращает FALSE, если диапазон адресов задан некорректный. }
    function  MakeNewList(StartAddr, Quantity: word): boolean; virtual;

   { вставляет новый набор регистров в список.
     вновь создаваемым регистрам списка присваиваются значения FRegDefType и FRegDefValue.
     если заданный диапазон перекрывает существующий, то существующие значения регистров не изменяются.
     возвращает количество добавленных регистров }
    function  Expand(StartAddr, Quantity: word): word; virtual;

   { возвращает индекс регистра в списке по адресу }
    function  IndexOf(Address: word): Integer; virtual;

   { возвращает индекс регистра в списке по адресу }
    function  AddressOf(Index: Integer): Word; virtual;

   { свойства класса }
    property  RegListType: TRegMBTypes read FRegListType; // тип списка регистров
    property  RegDefValue: word read FRegDefValue write SetRegDefValue; // значение добавляемых регистров по умолчанию
    property  StartAddress: word read FStartAddress; // стартовый адрес регистра в кадре
    property  Count: integer read GetCount;          // количество регистров в списке
    property  Items[Index: integer]: TMBWordRegister read GetItem;
    property  MBRegister[Address: word]: TMBWordRegister read GetRegister;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

{
  Класс-наследник TMBCustomFrameRegList, открывающий доступ к основным методам и свойствам
  и дополненный методом передачи значения типа WORD в регистр по его адресу
}
  TMBSimpleFrameRegList = class(TMBCustomFrameRegList)
  public
    procedure Clear; override;
    function  GetStringAddress(Address: word): String; override;
    function  GetRegister(Address: word): TMBWordRegister; override;
    procedure SetRegValue(Address, Value: word); virtual;
    function  MakeNewList(StartAddress: word; Count: word): boolean; override;
    function  Expand(StartAddr, Quantity: word): word; override;
    function  AddressOf(Index: Integer): word; override;
    property  RegListType;
    property  RegDefValue;
    property  StartAddress;
    property  Count;
    property  Items;
  end;

implementation

uses SysUtils,
     MBResourceString, MBAddressActions;

{ TMBRegList }

constructor TMBRegList.Create;
begin
  FHashedList:= THashedStringList.Create;
  FHashedList.Sorted:= true;
  FRegDefType:= rtSimpleWord;
  FRegListType:= rgNone;
end;

destructor TMBRegList.Destroy;
begin
  Clear;
  FHashedList.Free;
  SetLength(FRegRanges,0);
  inherited;
end;

procedure TMBRegList.Clear;
var i: integer;
begin
  for i:= 0 to FHashedList.Count-1  do
  begin
    if FHashedList.Objects[i]<>nil then FHashedList.Objects[i].Free;
  end;
  FHashedList.Clear;
  SetLength(FRegRanges,0);
end;

function TMBRegList.GetCount: Integer;
begin
  Result:= FHashedList.Count;
end;

function TMBRegList.IndexOf(Address: DWord): Integer;
begin
  Result:= FHashedList.IndexOf(TMBAddressActions.GetStringAddress(Address));
end;

function TMBRegList.GetRegList: TStrings;
begin
  Result:= TStringList.Create;
  Result.AddStrings(FHashedList);
end;

function TMBRegList.GetStringAddress(Address: DWORD): String;
begin
  Result:= TMBAddressActions.GetStringAddress(Address);
end;

function TMBRegList.MakeStringAddress(RegNum: Word): String;
begin
  Result:= TMBAddressActions.MakeStringAddress(FRegListType, RegNum);
end;

procedure TMBRegList.Delete(Address : DWORD);
var i : Integer;
begin
  i:= FHashedList.IndexOf(GetStringAddress(Address));
  if i=-1 then raise Exception.Create(ErrOutOfRange);
  if FHashedList.Objects[i]<>nil then FHashedList.Objects[i].Free;
  FHashedList.Delete(i);
end;

function TMBRegList.IsRangeOnTheList(StartAddr: DWORD; Count: Word): Boolean;
var i,TempCount : Integer;
begin
  Result:=False;
  TempCount:=Length(FRegRanges)-1;
  for i:=0 to TempCount do
   begin
    Result:=(FRegRanges[i].StartAddres = StartAddr) and (FRegRanges[i].Count = Count);
   end;
end;

function TMBRegList.GetRegRangeCount: Integer;
begin
  Result:=Length(FRegRanges);
end;

function TMBRegList.GetRegRanges(index: Integer): TMBRegistersRange;
begin
  Result:=FRegRanges[index];
end;

{ TMBBitRegList }

function TMBBitRegList.Add(Address: DWord): Integer;
var str : String;
    TempReg : TMBBitRegister;
begin
  CheckAddress(Address);
  str:=GetStringAddress(Address);
  Result:=FHashedList.IndexOf(str);
  if Result>-1 then Exit;
  TempReg := TMBBitRegister.Create;
  TempReg.Address   := Address;
  TempReg.MBRegType := TMBAddressActions.GetAddressType(Address);
  if (TempReg.MBRegType=rgDiscrete) then TempReg.RegReadOnly:=True else TempReg.RegReadOnly:=False;
  FHashedList.AddObject(str,TempReg);
end;

constructor TMBBitRegList.Create;
begin
  inherited;
  FRegDefType:=rtBit;
end;

function TMBBitRegList.GetIndexRegisters(Index: Integer): TMBBitRegister;
begin
 Result:=TMBBitRegister(FHashedList.Objects[Index]);
end;

function TMBBitRegList.GetRegisters(Address: DWORD): TMBBitRegister;
var i : integer;
begin
 i:=FHashedList.IndexOf(GetStringAddress(Address));
 if i=-1 then raise Exception.Create(ErrOutOfRange);
 Result:=TMBBitRegister(FHashedList.Objects[i]);
end;

procedure TMBBitRegList.SetBefoChange(const Value: TBefoRegBitChange);
var i : Integer;
begin
  FBefoChange := Value;
  for i := 0 to FHashedList.Count-1 do
   begin
    if FHashedList.Objects[i]<>nil then TMBBitRegister(FHashedList.Objects[i]).BefoChange:=Value;
   end;
end;

procedure TMBBitRegList.SetOnChange(const Value: TOnRegBitChange);
var i : Integer;
begin
  FOnChange := Value;
  for i := 0 to FHashedList.Count-1 do
   begin
    if FHashedList.Objects[i]<>nil then TMBBitRegister(FHashedList.Objects[i]).OnChange:=Value;
   end;
end;

{ TMBDiscretRegList }

procedure TMBDiscretRegList.CheckAddress(Address: DWORD);
begin
 TMBAddressActions.CheckDeskretAddress(Address);
end;

constructor TMBDiscretRegList.Create;
begin
  inherited;
  FRegListType:=rgDiscrete;
end;

procedure TMBDiscretRegList.MakeList(StartAddr: DWORD; Count: Word);
var i : Integer;
    StartNum, EndNum : Word;
    EndAddress : DWORD;
begin
  CheckAddress(StartAddr);
  StartNum:=TMBAddressActions.GetRegNumber(StartAddr);
  try
   EndNum:= StartNum+Count-1;
  except
   EndNum:= 65534;
  end;
  EndAddress:=TMBAddressActions.MakeAddress(rgDiscrete,EndNum);
  if not IsRangeOnTheList(StartAddr,Count) then
   begin
    SetLength(FRegRanges,length(FRegRanges)+1);
    FRegRanges[Length(FRegRanges)-1].StartAddres:=StartAddr;
    FRegRanges[Length(FRegRanges)-1].Count:=Count;
   end;
  for i := StartAddr to EndAddress do Add(i);
end;

{ TMBCoilRegList }

procedure TMBCoilRegList.CheckAddress(Address: DWORD);
begin
  TMBAddressActions.CheckCoilAddress(Address);
end;

constructor TMBCoilRegList.Create;
begin
  inherited;
  FRegListType:=rgCoils;
end;

procedure TMBCoilRegList.MakeList(StartAddr: DWORD; Count: Word);
var i : Integer;
    StartNum, EndNum : Word;
    EndAddress : DWORD;
begin
  CheckAddress(StartAddr);
  StartNum:=TMBAddressActions.GetRegNumber(StartAddr);
  try
   EndNum:= StartNum+Count-1;
  except
   EndNum:= 65534;
  end;
  EndAddress:=TMBAddressActions.MakeAddress(rgCoils,EndNum);
  if not IsRangeOnTheList(StartAddr,Count) then
   begin
    SetLength(FRegRanges,length(FRegRanges)+1);
    FRegRanges[Length(FRegRanges)-1].StartAddres:=StartAddr;
    FRegRanges[Length(FRegRanges)-1].Count:=Count;
   end;
  for i := StartAddr to EndAddress do Add(i);
end;

{ TMBWordRegList }

function TMBWordRegList.Add(Address: DWord): Integer;
var str : String;
    TempReg : TMBWordRegister;
begin
  CheckAddress(Address);
  str:=GetStringAddress(Address);
  Result:=FHashedList.IndexOf(str);
  if Result>-1 then Exit;
  case FRegDefType of
   rtSimpleWord : TempReg := TMBWordRegister.Create;
   rtWord       : TempReg := TMBWordBitRegister.Create;
   rtWordByte   : TempReg := TMBByteMixedRegister.Create;
  else
   TempReg := TMBWordRegister.Create;
  end;
  TempReg.Address:=Address;
  TempReg.MBRegType:=TMBAddressActions.GetAddressType(Address);
  if (TempReg.MBRegType=rgInput) then TempReg.RegReadOnly:=True else TempReg.RegReadOnly:=False;
  FHashedList.AddObject(str,TempReg);
end;

procedure TMBWordRegList.ChangeWordRegType(Address:DWORD; RegType:TRegTypes);
var i : Integer;
    TempReg,NewReg : TMBWordRegister;
begin
  NewReg:=nil;
  if RegType=rtBit then raise Exception.Create(ErrIncompatibleType);
  i:=FHashedList.IndexOf(GetStringAddress(Address));
  if i=-1 then raise Exception.Create(ErrOutOfRange);
  TempReg:=Registers[Address];
  if RegType = TempReg.RegType then Exit;
  case RegType of
   rtSimpleWord : NewReg:=TMBWordRegister.Create;
   rtWord       : NewReg:=TMBWordBitRegister.Create;
   rtWordByte   : NewReg:=TMBByteMixedRegister.Create;
  end;
  NewReg.Assigin(TempReg);
  TempReg.Free;
  FHashedList.Objects[i]:=NewReg;
end;

constructor TMBWordRegList.Create;
begin
  inherited;
  FRegDefType:=rtSimpleWord;
end;

function TMBWordRegList.GetIndexRegisters(Index: Integer): TMBWordRegister;
begin
 Result:=TMBWordRegister(FHashedList.Objects[Index]);
end;

function TMBWordRegList.GetRegisters(Address: DWORD): TMBWordRegister;
var i : integer;
begin
 i:=FHashedList.IndexOf(GetStringAddress(Address));
 if i=-1 then raise Exception.Create(ErrOutOfRange);
 Result:=TMBWordRegister(FHashedList.Objects[i]);
end;

procedure TMBWordRegList.SetBefoChange(const Value: TBefoRegWordChange);
var i : Integer;
begin
  FBefoChange := Value;
  for i := 0 to FHashedList.Count-1 do
   begin
    if FHashedList.Objects[i]<>nil then TMBWordRegister(FHashedList.Objects[i]).BefoChange:=Value;
   end;
end;

procedure TMBWordRegList.SetDefRegType(const Value: TRegTypes);
var i : Integer;
begin
  if FRegDefType=Value then Exit;
  for i := 0 to FHashedList.Count-1 do
   begin
    if FHashedList.Objects[i]<>nil then
     if TMBWordRegister(FHashedList.Objects[i]).RegType<>Value then
       ChangeWordRegType(TMBWordRegister(FHashedList.Objects[i]).Address,Value);
   end;
  FRegDefType := Value;
end;

procedure TMBWordRegList.SetOnChange(const Value: TOnRegWordChange);
var i : Integer;
begin
  FOnChange := Value;
  for i := 0 to FHashedList.Count-1 do
   begin
    if FHashedList.Objects[i]<>nil then TMBWordRegister(FHashedList.Objects[i]).OnChange:=Value;
   end;
end;

{ TMBInputRegList }

procedure TMBInputRegList.CheckAddress(Address: DWORD);
begin
  TMBAddressActions.CheckInputAddress(Address);
end;

constructor TMBInputRegList.Create;
begin
  inherited;
  FRegListType:=rgInput;
end;

procedure TMBInputRegList.MakeList(StartAddr: DWORD; Count: Word);
var i,ii : Integer;
    StartNum, EndNum : Word;
    EndAddress : DWORD;
begin
  CheckAddress(StartAddr);
  StartNum:=TMBAddressActions.GetRegNumber(StartAddr);
  try
   EndNum:= StartNum+Count-1;
  except
   EndNum:= 65534;
  end;
  EndAddress:=TMBAddressActions.MakeAddress(rgInput,EndNum);
  if not IsRangeOnTheList(StartAddr,Count) then
   begin
    SetLength(FRegRanges,length(FRegRanges)+1);
    FRegRanges[Length(FRegRanges)-1].StartAddres:=StartAddr;
    FRegRanges[Length(FRegRanges)-1].Count:=Count;
   end;
  for i := StartAddr to EndAddress do Add(i);
end;

{ TMBHoldingRegList }

procedure TMBHoldingRegList.CheckAddress(Address: DWord);
begin
  TMBAddressActions.CheckHoldingAddress(Address);
end;

constructor TMBHoldingRegList.Create;
begin
  inherited;
  FRegListType:= rgHolding;
end;

procedure TMBHoldingRegList.MakeList(StartAddr: DWORD; Count: Word);
var i,ii : Integer;
    StartNum, EndNum : Word;
    EndAddress : DWORD;
begin
  CheckAddress(StartAddr);
  StartNum:=TMBAddressActions.GetRegNumber(StartAddr);
  try
    EndNum:= StartNum + Count - 1;
  except
    EndNum:= $FFFE;
  end;
  EndAddress:= TMBAddressActions.MakeAddress(rgHolding, EndNum);
  if not IsRangeOnTheList(StartAddr,Count) then
   begin
    SetLength(FRegRanges,length(FRegRanges)+1);
    FRegRanges[Length(FRegRanges)-1].StartAddres:=StartAddr;
    FRegRanges[Length(FRegRanges)-1].Count:=Count;
   end;
  for i:= StartAddr to EndAddress do Add(i);
end;

{ TMBCustomFrameRegList }

constructor TMBCustomFrameRegList.Create;
begin
  FList        := TList.Create;
  FRegListType := rgHolding;
  FRegDefValue := 0;
  FStartAddress:= 0;
end;

destructor TMBCustomFrameRegList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TMBCustomFrameRegList.GetCount: Integer;
begin
  Result:= FList.Count;
end;

procedure TMBCustomFrameRegList.SetRegDefValue(const Value: word);
begin
  FRegDefValue:= Value;
end;

function TMBCustomFrameRegList.GetItem(Index: integer): TMBWordRegister;
begin
  if CheckIndex(Index) then Result:= FList.Items[Index]
  else Result:= nil;
end;

function TMBCustomFrameRegList.GetRegister(Address: word): TMBWordRegister;
begin
  Result:= Items[IndexOf(Address)];
end;

procedure TMBCustomFrameRegList.ReleaseItem(Index: integer);
var Obj: TObject;
begin
  if CheckIndex(Index) then Obj:= GetItem(Index);
  FreeAndNil(Obj);
end;

procedure TMBCustomFrameRegList.DeleteItems(Index: integer);
begin
  while FList.Count > Index do
  begin
    ReleaseItem(FList.Count-1);
    FList.Delete(FList.Count-1);
  end;
end;

function TMBCustomFrameRegList.NewItem: TMBWordRegister;
begin
  Result:= TMBWordRegister.Create;
  try
    Result.MBRegType:= FRegListType;
    Result.Value:= FRegDefValue;
  except
    Result.Free;
    Result:= nil;
    raise;
  end;
end;

function TMBCustomFrameRegList.AddItems(After: boolean; Quantity: integer): integer;
var i: integer;
    NewReg: TMBWordRegister;
    OldCount: integer;
begin
  Result:= 0;
  if After then
  begin
    if (FStartAddress + FList.Count + Quantity) > $FFFF then exit;
  end
  else
  begin
    if FStartAddress < Quantity then exit;
  end;

  OldCount:= FList.Count;
  for i:= 1 to Quantity do
  begin
    NewReg:= NewItem;
    if NewReg = nil then
    begin
      raise Exception.Create(ErrData);
      break;
    end;
    if After then FList.Add(NewReg)
    else
    begin
      FList.Insert(0, NewReg);
      dec(FStartAddress);
    end;
  end;
  Result:= FList.Count - OldCount;
end;

procedure TMBCustomFrameRegList.Clear;
begin
  DeleteItems(0);
end;

function TMBCustomFrameRegList.IndexOf(Address: word): Integer;
begin
  if Address >= FStartAddress then Result:= Address - FStartAddress
  else Result:= -1;
end;

function TMBCustomFrameRegList.CheckIndex(const Index: integer): boolean;
begin
  Result:= (Index >= 0) and (Index < FList.Count);
end;

function TMBCustomFrameRegList.CheckAddress(Address: word): boolean;
begin
  Result:= CheckIndex(IndexOf(Address));
end;

function TMBCustomFrameRegList.GetStringAddress(Address: word): String;
begin
  Result:= TMBAddressActions.MakeStringAddress(GetRegister(Address).MBRegType, Address);
end;

function TMBCustomFrameRegList.MakeNewList(StartAddr, Quantity: word): boolean;
begin
  Clear;
  FStartAddress:= StartAddr;
  Result:= AddItems(true, Quantity) = Quantity;
end;

function TMBCustomFrameRegList.Expand(StartAddr, Quantity: word): word;
begin
  Result:= 0;
  // новый список полностью перекрывает существующий
  if (StartAddr <= FStartAddress) and (Quantity >= (FStartAddress - StartAddr + FList.Count)) then
  begin
    // проверка выхода за допустимый диапазон адресов
    if (StartAddr + Quantity) > $FFFF then exit;
    // создается новый список взамен существующего
    if MakeNewList(StartAddr, Quantity) then Result:= Quantity;
  end
  else
  // новый список перекрывает существующий с начала
  if (StartAddr < FStartAddress) and (Quantity < (FStartAddress - StartAddr + FList.Count)) then
  begin
    // проверка выхода за допустимый диапазон адресов
    if (FStartAddress - StartAddr + FList.Count) > $FFFF then exit;
    Result:= AddItems(false, FStartAddress - StartAddr);
  end
  else
// новый список перекрывает существующий с конца
  if (StartAddr > FStartAddress) and (Quantity > (FStartAddress - StartAddr + FList.Count)) then
  begin
  // проверка выхода за допустимый диапазон адресов
    if (FStartAddress - StartAddr + FList.Count) > $FFFF then exit;
    Result:= AddItems(true, FList.Count - (StartAddr - FStartAddress));
  end;
// если новый список внутри существующего, то ничего не выполняется
end;

function TMBCustomFrameRegList.AddressOf(Index: Integer): Word;
begin
  if not CheckIndex(Index) then raise Exception.Create(ErrOutOfRange);
  Result:= FStartAddress + Index;
end;

{ TMBSimpleFrameRegList }

procedure TMBSimpleFrameRegList.Clear;
begin
  inherited Clear;
end;

function TMBSimpleFrameRegList.GetStringAddress(Address: word): String;
begin
  Result:= inherited GetStringAddress(Address);
end;

function TMBSimpleFrameRegList.GetRegister(Address: word): TMBWordRegister;
begin
  Result:= inherited GetRegister(Address);
end;

function TMBSimpleFrameRegList.MakeNewList(StartAddress, Count: word): boolean;
begin
  Result:= inherited MakeNewList(StartAddress, Count);
end;

function TMBSimpleFrameRegList.Expand(StartAddr, Quantity: word): word;
begin
  Result:= inherited Expand(StartAddr, Quantity);
end;

function TMBSimpleFrameRegList.AddressOf(Index: Integer): word;
begin
  Result:= inherited AddressOf(Index);
end;

procedure TMBSimpleFrameRegList.SetRegValue(Address, Value: word);
begin
  if MBRegister[Address] <> nil then MBRegister[Address].Value:= Value;
end;

end.

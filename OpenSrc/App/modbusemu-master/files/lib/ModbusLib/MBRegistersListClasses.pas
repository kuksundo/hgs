unit MBRegistersListClasses;

{$mode objfpc}{$H+}

interface

uses Windows, IniFiles, Classes,
     MBDefine, MBRegistersCalsses;

type
   { Абстрактный класс реализующий упорядоченный список регистров.
     Сортировка списка производится по номерам регистров.
     Список может быть не однородный т.е. может содержать несколько диапазонов
     регистров в рамках максимально возможного числа(65535).
   }
   TRegistersListBase = class // абстрактный класс списка регистров
   private
    FRegListType : TRegMBTypes;                   // Тип списка регистров
    procedure SetRegListType(const Value: TRegMBTypes);
   protected
    FHashedList  : THashedStringList;             // Хэшированный список переменных, хэш строится по адресу регистра преобразованного в строку
    FIsReadOnly  : Boolean;                       // Флаг возможности записи значений в регистры. Зависит от типа списка. По умолчанию True
    FRegRanges   : TMBRegistersRangeClassicArray; // список диапазонов регистров
    function  GetRegIndex(RegNumber : Word):Integer; virtual;  // получение индекса регистра в списке по его номеру
    function  GetRegCount: Integer;                            // получение количества регистров в списке
    procedure DeleteElement(Index:Integer); virtual;           // удаление регистра из списка по его индексу
    procedure DoSetListTipe(ListType: TRegMBTypes); virtual;   // Метод позволяет обработать ситуацию смены типа списка. Выполняется до установки поля TRegMBTypes.
    function  GetEndNumber(StartNumber,Count : Word): Word;

    function  IsRangeOnTheList(StartAddr: WORD; Count: Word): Boolean; virtual;
    function  GetRegRangeCount: Integer;
    function  GetRegRanges(index: Integer): TMBRegistersRangeClassic;
   public
    constructor Create; virtual;
    destructor  Destroy; override;

    procedure Clear;                                      // Очистка списка регистров
    function  AddRangeOfRegisters(StartNumber: Word; Count : Word): Boolean; virtual; abstract; // Добавление диапазона регистров в список
    function  AddRegister(Number: Word): Integer; virtual; abstract; // Добавить отдельный регистр. Возвращается его индекс в списке.
    function  RemoveRangeOfRegisters(StartNumber: Word; Count : Word): Boolean; virtual; // Удаление Count регистров начиная с StartNumber
    procedure RemoveRegister(RegNumber : Word);overload;  // Удаление регистра по его номеру
    procedure RemoveRegister(Index : Integer);overload;   // Удаление регистра по его индексу в списка

    property RegCount    : Integer read GetRegCount;      // Количество регистров в списке
    property RegListType : TRegMBTypes read FRegListType write SetRegListType; // Тип регистрового диапазине согласно Modbus. При установке свойства в значение rgNone список регистров очищается.
    property RegRangeCount : Integer read GetRegRangeCount;
    property RegRanges[index : Integer]: TMBRegistersRangeClassic read GetRegRanges;
   end;

   {  Список битовых регистров. Предназначен для реализации списков битовых переменных устройства }
   TRegistersListBit = class(TRegistersListBase)
   private
    FDefValue   : Boolean;
    FOnChange   : TOnRegBitChange;         // ссылка на процедуру обработчик события изменения значения регистра
    FBefoChange : TBefoRegBitChange;       // обработчик события возбуждаемого перед изменением значения регистра
    procedure SetOnChange(const Value: TOnRegBitChange);
    procedure SetBefoChange(const Value: TBefoRegBitChange);
   protected
    function  GetRegsVlue(RegNumber: Word): Boolean; virtual;
    procedure SetRegsVlue(RegNumber: Word; const Value: Boolean); virtual;
    function  GetRegisters(index: Integer): TMBBitRegister; virtual;
    function  GetRegisterUnderNumber(RegNumber: Word): TMBBitRegister; virtual;
   public
    constructor Create ; override;
    function  AddRangeOfRegisters(StartNumber: Word; Count : Word): Boolean; override;
    function  AddRegister(Number: Word): Integer; override;
    procedure SetRegsValues(StartNumber: Word; Values : array of Boolean; SetValueInAnyCase : Boolean = False);
    function  GetRegsValues(StartNumber: Word; var Count : Word): TBitRegsValues;

    property DefValue                   : Boolean read FDefValue write FDefValue default False;
    property RegsVlue[RegNumber : Word] : Boolean read GetRegsVlue write SetRegsVlue;
    property Registers[index : Integer] : TMBBitRegister read GetRegisters;
    property OnRegChange                : TOnRegBitChange read FOnChange write SetOnChange;
    property BefoChange                 : TBefoRegBitChange read FBefoChange write SetBefoChange;
   end;

   {  Список регистров типа Word. Предназначен для реализации списков переменных типа Word устройства }
   TRegistersListWord = class(TRegistersListBase)
   private
    FDefValue   : Word;
    FOnChange   : TOnRegWordChange;        // ссылка на процедуру обработчик события изменения значения регистра
    FBefoChange : TBefoRegWordChange;      // обработчик события возбуждаемого перед изменением значения регистра
    procedure SetOnChange(const Value: TOnRegWordChange);
    procedure SetBefoChange(const Value: TBefoRegWordChange);
   protected
    function  GetRegsVlue(RegNumber: Word): Word; virtual;
    procedure SetRegsVlue(RegNumber: Word; const Value: Word); virtual;
    function  GetRegisters(index: Integer): TMBWordBitRegister; virtual;
    function  GetRegisterUnderNumber(RegNumber: Word): TMBWordBitRegister; virtual;
   public
    constructor Create ; override;
    function  AddRangeOfRegisters(StartNumber: Word; Count : Word): Boolean; override;
    function  AddRegister(Number: Word): Integer; override;
    procedure SetRegsValues(StartNumber: Word; Values : array of Word; SetValueInAnyCase : Boolean = False);
    function  GetRegsValues(StartNumber: Word; var Count : Word): TWordRegsValues;

    property DefValue                   : Word read FDefValue write FDefValue default 0;
    property RegsVlue[RegNumber : Word] : Word read GetRegsVlue write SetRegsVlue;
    property Registers[index : Integer] : TMBWordBitRegister read GetRegisters;
    property OnRegChange                : TOnRegWordChange read FOnChange write SetOnChange;
    property BefoChange                 : TBefoRegWordChange read FBefoChange write SetBefoChange;
   end;

implementation

uses SysUtils, MBResourceString;

{ TRegistersListBase }

constructor TRegistersListBase.Create;
begin
  FHashedList        := THashedStringList.Create;
  FHashedList.Sorted := true;
  FRegListType       := rgNone;
  FIsReadOnly        := True;
end;

destructor TRegistersListBase.Destroy;
begin
  Clear;
  FreeAndNil(FHashedList);
  inherited;
end;

procedure TRegistersListBase.Clear;
var i, Count : Integer;
begin
  Count:=FHashedList.Count-1;
  for i := 0 to Count do DeleteElement(i);
  SetLength(FRegRanges,0);
end;

function TRegistersListBase.GetRegCount: Integer;
begin
  Result:=FHashedList.Count;
end;

function TRegistersListBase.RemoveRangeOfRegisters(StartNumber,Count: Word): Boolean;
var i,ii    : Integer;
    TempAdr : Word;
begin
  Result := False;
  try
   TempAdr:=StartNumber+(Count-1);
  except
   TempAdr:=MAXWORD;
  end;
  for i:=StartNumber to TempAdr do RemoveRegister(i);
  Result:=True;
end;

function TRegistersListBase.GetRegIndex(RegNumber: Word): Integer;
begin
  Result:=FHashedList.IndexOf(StringReplace(Format('%5d',[RegNumber]),' ','0',[rfReplaceAll, rfIgnoreCase]));
end;

procedure TRegistersListBase.DeleteElement(Index: Integer);
var TempElement : TObject;
begin
  TempElement:=TObject(FHashedList.Objects[Index]);
  FHashedList.Objects[Index]:=nil;
  if Assigned(TempElement) then FreeAndNil(TempElement);
  FHashedList.Delete(Index);
end;

procedure TRegistersListBase.RemoveRegister(RegNumber: Word);
var i : Integer;
begin
  i:=GetRegIndex(RegNumber);
  if i=-1 then Exit;
  DeleteElement(i);
end;

procedure TRegistersListBase.RemoveRegister(Index: Integer);
begin
  DeleteElement(Index);
end;

procedure TRegistersListBase.SetRegListType(const Value: TRegMBTypes);
begin
  if Value=FRegListType then Exit;
  case FRegListType of
   rgNone               : begin
                           FIsReadOnly := True;
                           Clear;
                          end;
   rgDiscrete,rgHolding : begin
                           FIsReadOnly := True;
                           DoSetListTipe(Value);
                          end;
   rgCoils,rgInput      : begin
                           FIsReadOnly := False;
                           DoSetListTipe(Value);
                          end;
  end;
  FRegListType := Value;
end;

procedure TRegistersListBase.DoSetListTipe(ListType: TRegMBTypes);
begin
  case RegListType of
   rgDiscrete,rgCoils : begin
                         case ListType of
                          rgNone,rgDiscrete : FIsReadOnly:=True;
                          rgCoils           : FIsReadOnly:=False;
                         else
                          raise Exception.Create(rsBitToWordTransformationError);
                         end;
                        end;
   rgInput,rgHolding :  begin
                         case ListType of
                          rgInput          : FIsReadOnly:=False;
                          rgNone,rgHolding : FIsReadOnly:=True;
                         else
                          raise Exception.Create(rsWordToBitTransformationError);
                         end;
                        end;
  end;
end;

function TRegistersListBase.GetEndNumber(StartNumber, Count: Word): Word;
begin
  try
   Result:=StartNumber+(Count-1);
  except
   Result:=MAXWORD;
  end;
end;

function TRegistersListBase.GetRegRangeCount: Integer;
begin
  Result:=Length(FRegRanges);
end;

function TRegistersListBase.GetRegRanges(index: Integer): TMBRegistersRangeClassic;
begin
  Result:=FRegRanges[index];
end;

function TRegistersListBase.IsRangeOnTheList(StartAddr, Count: Word): Boolean;
var i,TempCount : Integer;
begin
  Result:=False;
  TempCount:=Length(FRegRanges)-1;
  for i:=0 to TempCount do
   begin
    Result:=(FRegRanges[i].StartAddres = StartAddr) and (FRegRanges[i].Count = Count);
   end;
end;

{ TRegistersListBit }
constructor TRegistersListBit.Create;
begin
  inherited;
  FDefValue:=False;
end;

function TRegistersListBit.AddRangeOfRegisters(StartNumber, Count: Word): Boolean;
var EndNumber : Word;
    i  : Word;
begin
  Result:=False;
  if FRegListType=rgNone then raise Exception.Create(rsListTypeError);
  EndNumber:=GetEndNumber(StartNumber,Count);

  if not IsRangeOnTheList(StartNumber,Count) then
   begin
    SetLength(FRegRanges,length(FRegRanges)+1);
    FRegRanges[Length(FRegRanges)-1].StartAddres:=StartNumber;
    FRegRanges[Length(FRegRanges)-1].Count:=Count;
   end;

  for i:= StartNumber to EndNumber do AddRegister(i);
  Result:=True;
end;

function TRegistersListBit.GetRegsValues(StartNumber: Word; var Count: Word): TBitRegsValues;
var TempCount : Word;
    EndNumber : Word;
    i : Word;
    ii : Integer;
begin
  TempCount:=Count;
  EndNumber:=GetEndNumber(StartNumber,TempCount);
  for i:=StartNumber to EndNumber do
   begin
     ii:=GetRegIndex(i);
     if ii=-1 then raise Exception.Create(Format(rsRegNotExists,[i]));
     SetLength(Result,Length(Result)+1);
     Result[Length(Result)-1]:=Registers[ii].Value;
   end;
  Count:=Length(Result);
end;

function TRegistersListBit.GetRegsVlue(RegNumber: Word): Boolean;
var TempReg : TMBBitRegister;
begin
   Result:=False;
   TempReg:=GetRegisterUnderNumber(RegNumber);
   if not Assigned(TempReg) then raise Exception.Create(Format(rsRegNotExist1,[RegNumber]));
   Result:=TempReg.Value;
end;

procedure TRegistersListBit.SetRegsValues(StartNumber: Word; Values: array of Boolean; SetValueInAnyCase: Boolean);
var i,TmpIndex : Integer;
    EndNumber : Word;
    TempReg   : TMBBitRegister;
begin
  if (not SetValueInAnyCase) and FIsReadOnly then raise Exception.Create(rsRegIsReadOnly);
  if Length(Values)=0 then raise Exception.Create(rsDataArrayIsEmpty);
  EndNumber:=GetEndNumber(StartNumber,Length(Values));
  TmpIndex:=0;
  for i:=StartNumber to EndNumber do
   begin
    TempReg:=GetRegisterUnderNumber(i);
    if not Assigned(TempReg) then Continue;
    TempReg.Value:=Values[TmpIndex];
    Inc(TmpIndex);
   end;
end;

procedure TRegistersListBit.SetRegsVlue(RegNumber: Word; const Value: Boolean);
var i : Integer;
begin
  i:=GetRegIndex(RegNumber);
  if i=-1 then raise Exception.Create(Format(rsRegNotExist1,[RegNumber]));
  Registers[i].Value:=Value;
end;

function TRegistersListBit.AddRegister(Number: Word): Integer;
var TempReg : TMBBitRegister;
begin
  Result:=GetRegIndex(Number);
  if Result<>-1 then Exit;
  TempReg:=TMBBitRegister.Create;
  TempReg.RegNumber   := Number;
  TempReg.SetDefValue(FDefValue);
  TempReg.MBRegType   := FRegListType;
  TempReg.BefoChange  := FBefoChange;
  TempReg.OnChange    := FOnChange;
  Result:=FHashedList.AddObject(StringReplace(Format('%5d',[Number]),' ','0',[rfReplaceAll, rfIgnoreCase]),TempReg);
end;

function TRegistersListBit.GetRegisters(index: Integer): TMBBitRegister;
begin
  Result:=TMBBitRegister(FHashedList.Objects[index]);
end;

function TRegistersListBit.GetRegisterUnderNumber(RegNumber: Word): TMBBitRegister;
var i : Integer;
begin
  Result:=nil;
  i := GetRegIndex(RegNumber);
  if i=-1 then raise Exception.Create(Format(rsRegNotExist1,[RegNumber]));;
  Result:=TMBBitRegister(FHashedList.Objects[i]);
end;

procedure TRegistersListBit.SetBefoChange(const Value: TBefoRegBitChange);
var i : Integer;
begin
  FBefoChange := Value;
  for i := 0 to FHashedList.Count-1 do
   begin
    if FHashedList.Objects[i]<>nil then TMBBitRegister(FHashedList.Objects[i]).BefoChange:=Value;
   end;
end;

procedure TRegistersListBit.SetOnChange(const Value: TOnRegBitChange);
var i : Integer;
begin
  FOnChange := Value;
  for i := 0 to FHashedList.Count-1 do
   begin
    if FHashedList.Objects[i]<>nil then TMBBitRegister(FHashedList.Objects[i]).OnChange:=Value;
   end;
end;

{ TRegistersListWord }

constructor TRegistersListWord.Create;
begin
  inherited;
  FDefValue:=0;
end;

function TRegistersListWord.AddRangeOfRegisters(StartNumber, Count: Word): Boolean;
var EndNumber : Word;
    i  : Word;
begin
  Result:=False;
  if FRegListType=rgNone then raise Exception.Create(rsListTypeError);
  EndNumber:=GetEndNumber(StartNumber,Count);
  for i:= StartNumber to EndNumber do AddRegister(i);
  Result:=True;
end;

function TRegistersListWord.AddRegister(Number: Word): Integer;
var TempReg : TMBWordBitRegister;
begin
  Result:=GetRegIndex(Number);
  if Result<>-1 then Exit;
  TempReg:=TMBWordBitRegister.Create;
  TempReg.RegNumber   := Number;
  TempReg.SetDefValue(FDefValue);
  TempReg.MBRegType   := FRegListType;
  TempReg.BefoChange  := FBefoChange;
  TempReg.OnChange    := FOnChange;
  Result:=FHashedList.AddObject(StringReplace(Format('%5d',[Number]),' ','0',[rfReplaceAll, rfIgnoreCase]),TempReg);
end;

function TRegistersListWord.GetRegsValues(StartNumber: Word; var Count: Word): TWordRegsValues;
var TempCount : Word;
    EndNumber : Word;
    i : Word;
    ii : Integer;
begin
  TempCount:=Count;
  EndNumber:=GetEndNumber(StartNumber,TempCount);
  for i:=StartNumber to EndNumber do
   begin
     ii:=GetRegIndex(i);
     if ii=-1 then raise Exception.Create(Format(rsRegNotExists,[i]));
     SetLength(Result,Length(Result)+1);
     Result[Length(Result)-1]:=Registers[ii].Value;
   end;
  Count:=Length(Result);
end;

function TRegistersListWord.GetRegsVlue(RegNumber: Word): Word;
var TempReg : TMBWordBitRegister;
begin
   Result:=0;
   TempReg:=GetRegisterUnderNumber(RegNumber);
   if not Assigned(TempReg) then raise Exception.Create(Format(rsRegNotExist1,[RegNumber]));;
   Result:=TempReg.Value;
end;

procedure TRegistersListWord.SetRegsValues(StartNumber: Word; Values: array of Word; SetValueInAnyCase: Boolean);
var i,TmpIndex : Integer;
    EndNumber : Word;
    TempReg   : TMBWordBitRegister;
begin
  if (not SetValueInAnyCase) and FIsReadOnly then raise Exception.Create(rsRegIsReadOnly);
  if Length(Values)=0 then raise Exception.Create(rsDataArrayIsEmpty);
  EndNumber:=GetEndNumber(StartNumber,Length(Values));
  TmpIndex:=0;
  for i:=StartNumber to EndNumber do
   begin
    TempReg:=GetRegisterUnderNumber(i);
    if not Assigned(TempReg) then Continue;
    TempReg.Value:=Values[TmpIndex];
    Inc(TmpIndex);
   end;
end;

procedure TRegistersListWord.SetRegsVlue(RegNumber: Word; const Value: Word);
var i : Integer;
begin
  i:=GetRegIndex(RegNumber);
  if i=-1 then raise Exception.Create(Format(rsRegNotExist1,[RegNumber]));
  Registers[i].Value:=Value;
end;

function TRegistersListWord.GetRegisters(index: Integer): TMBWordBitRegister;
begin
  Result := TMBWordBitRegister(FHashedList.Objects[index]);
end;

function TRegistersListWord.GetRegisterUnderNumber(RegNumber: Word): TMBWordBitRegister;
var i : Integer;
begin
  Result:=nil;
  i := GetRegIndex(RegNumber);
  if i=-1 then raise Exception.Create(Format(rsRegNotExist1,[RegNumber]));;
  Result:=TMBWordBitRegister(FHashedList.Objects[i]);
end;

procedure TRegistersListWord.SetBefoChange( const Value: TBefoRegWordChange);
var i : Integer;
begin
  FBefoChange := Value;
  for i := 0 to FHashedList.Count-1 do
   begin
    if FHashedList.Objects[i]<>nil then TMBWordRegister(FHashedList.Objects[i]).BefoChange:=Value;
   end;
end;

procedure TRegistersListWord.SetOnChange(const Value: TOnRegWordChange);
var i : Integer;
begin
  FOnChange := Value;
  for i := 0 to FHashedList.Count-1 do
   begin
    if FHashedList.Objects[i]<>nil then TMBWordRegister(FHashedList.Objects[i]).OnChange:=Value;
   end;
end;

end.

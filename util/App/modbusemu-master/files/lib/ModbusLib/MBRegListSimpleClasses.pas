unit MBRegListSimpleClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBDefine, MBRegistersCalsses;

resourcestring
 rsRangeError      = 'Нижняя граница диапазона выходит за допустимое значение.';
 rsWordToBitError  = 'Предобразование рагистра типа Word в регистр типа бит не возможно.';
 rsReAddrNotAssign = 'Регистр с адресом %d не существует.';

type
  TMBRegSimpleList = class
  private
    FRegListType : TRegMBTypes;                                                 // Тип списка регистров
    FIsReadOnly  : Boolean;                                                     // Флаг возможности записи значений в регистры. Зависит от типа списка. По умолчанию True
    procedure SetRegListType(const Value: TRegMBTypes);
    procedure SetRegDefType(const Value: TRegTypes);
  protected
    FRegRanges   : TMBRegistersRangeClassicArray;                               // список диапазонов регистров
    FRegArray    : TMBRegisterArray;                                            // массив регистров
    FRegCount    : Word;                                                        // общее количество регистров в списке
    FRegDefType  : TRegTypes;                                                   // тип объекта регистра по умолчанию
    procedure AddReg(Address: Word); virtual; abstract;                         // добавляет переменную в список и возвращает ее индекс
    procedure Delete(Address: Word);                                            // удаляет переменную по ее индексу
    function  GetRegRangeCount: Integer;
    function  GetRegRanges(index: Integer): TMBRegistersRangeClassic;
    function  GetEndNumber(StartNumber,Count : Word): Word;
    function  IsRangeOnTheList(StartAddr: WORD; Count: Word; out Index : Integer): Boolean;
    procedure DeleteRangeFromArray(Index : Integer);
    procedure DoSetRegDefType(const Value: TRegTypes); virtual; abstract;
    function  OptimizeRange(Range : TMBRegistersRangeClassic; out Ranges : TMBRegistersRangeClassicArray): Boolean;
    procedure DefragmentationList(var RangeArray : TMBRegistersRangeClassicArray);
    procedure SortArray(p,q : Integer; Ranges : TMBRegistersRangeClassicArray);
  public
    constructor Create; virtual;
    destructor  Destroy; override;
    procedure Clear; virtual;                                                   // очищает список с уничтожением переменных
    function  PositionOnRangeOfSubrange(Range, Subrange : TMBRegistersRangeClassic; out LeftSide, RightSide : Integer) :TMBSubrangeStateOfRange; overload;
    function  PositionOnRangeOfSubrange(rStartAddr, rCount, subSatartAddr, subCount : Word; out LeftSide, RightSide : Integer): TMBSubrangeStateOfRange; overload;
    procedure AddRangeOfRegs(StartAddr: Word; Count: Word); overload;           // создание списка по его стартовому адресу и количеству регистров
    procedure AddRangeOfRegs(Range : TMBRegistersRangeClassic); overload;
    procedure DeleteRange(Range : TMBRegistersRangeClassic); overload;          // удаление диапазона адресов
    procedure DeleteRange(StartAddr: WORD; Count: Word); overload;

    property IsReadOnly    : Boolean read FIsReadOnly;
    property RegDefType    : TRegTypes read FRegDefType write SetRegDefType;
    property InfoCountReg  : Word read FRegCount;
    property RegListType   : TRegMBTypes read FRegListType write SetRegListType;// Тип регистрового диапазине согласно Modbus. При установке свойства в значение rgNone список регистров очищается.
    property RegRangeCount : Integer read GetRegRangeCount;
    property RegRanges[index : Integer]: TMBRegistersRangeClassic read GetRegRanges;
  end;

  TMBRegBitSimpleList = class(TMBRegSimpleList)
  private
   FOnChange   : TOnRegBitChange;
   FBefoChange : TBefoRegBitChange;
   function  GetRegisters(Address: Word): TMBBitRegister;
   function  GetValueRegs(Address: Word): Boolean;
   procedure SetBefoChange(const Value: TBefoRegBitChange);
   procedure SetOnChange(const Value: TOnRegBitChange);
  protected
   procedure AddReg(Address: Word); override;
   procedure DoSetRegDefType(const Value: TRegTypes); override;
  public
   constructor Create; override;

   property Registers[Address : Word] : TMBBitRegister read GetRegisters;
   property ValueRegs[Address : Word] : Boolean read GetValueRegs;
   property OnRegChange : TOnRegBitChange read FOnChange write SetOnChange;
   property BefoChange  : TBefoRegBitChange read FBefoChange write SetBefoChange;
  end;

  TMBRegWordSimpleList = class(TMBRegSimpleList)
  private
   FBefoChange : TBefoRegWordChange;
   FOnChange   : TOnRegWordChange;
   function  GetValueRegs(Address: Word): Word;
   procedure SetBefoChange(const Value: TBefoRegWordChange);
   procedure SetOnChange(const Value: TOnRegWordChange);
  protected
   procedure AddReg(Address: Word); override;
   procedure DoSetRegDefType(const Value: TRegTypes); override;
   function  GetRegisters(Address: Word): TMBWordRegister;
  public
   constructor Create; override;

   property Registers[Address : Word] : TMBWordRegister read GetRegisters;
   property ValueRegs[Address : Word] : Word read GetValueRegs;
   property OnRegChange : TOnRegWordChange read FOnChange write SetOnChange;
   property BefoChange  : TBefoRegWordChange read FBefoChange write SetBefoChange;
  end;

implementation

uses SysUtils,
     {Библиотека MiscFunctions}
     ExceptionsTypes;

{ TMBRegSimpleList }

constructor TMBRegSimpleList.Create;
begin
  FRegListType := rgNone;
  FIsReadOnly  := True;
  FRegCount    := 0;
end;

destructor TMBRegSimpleList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TMBRegSimpleList.Clear;
var i : Integer;
begin
  for i:=0 to MAXWORD do if FRegArray[i]<>nil then FreeAndNil(FRegArray[i]);
  SetLength(FRegRanges,0);
  FRegCount := 0;
end;

procedure TMBRegSimpleList.Delete(Address: Word);
begin
  if FRegArray[Address]= nil then Exit;
  FreeAndNil(FRegArray[Address]);
  Dec(FRegCount);
end;

function TMBRegSimpleList.GetEndNumber(StartNumber, Count: Word): Word;
begin
  try
   Result:=StartNumber+(Count-1);
  except
   raise Exception.Create(rsRangeError);
  end;
end;

function TMBRegSimpleList.GetRegRangeCount: Integer;
begin
  Result:=Length(FRegRanges);
end;

function TMBRegSimpleList.GetRegRanges(index: Integer): TMBRegistersRangeClassic;
begin
  Result:=FRegRanges[index];
end;

procedure TMBRegSimpleList.SetRegListType(const Value: TRegMBTypes);
var i : Integer;
begin
  if Value=FRegListType then Exit;
  FRegListType := Value;
  case FRegListType of
   rgNone               : begin
                           FIsReadOnly := True;
                           Clear;
                          end;
   rgDiscrete,rgInput  : begin
                           FIsReadOnly := True;
                         end;
   rgCoils,rgHolding   : begin
                           FIsReadOnly := False;
                         end;
  end;
  for i:=0 to MAXWORD do
   if FRegArray[i]<>nil then FRegArray[i].MBRegType:=FRegListType;
end;

function TMBRegSimpleList.IsRangeOnTheList(StartAddr, Count: Word; out Index : Integer): Boolean;
var i,TempCount : Integer;
begin
  Result:=False;
  Index:=-1;
  TempCount:=Length(FRegRanges)-1;
  if TempCount = -1 then Exit;
  for i:=0 to TempCount do
   begin
    Result:=(FRegRanges[i].StartAddres = StartAddr) and (FRegRanges[i].Count = Count);
    if Result then
     begin
      Index:=i;
      Break;
     end;
   end;
end;

procedure TMBRegSimpleList.DeleteRange(Range: TMBRegistersRangeClassic);
var i, Count, Index  : Integer;
begin
  if not IsRangeOnTheList(Range.StartAddres,Range.Count, Index) then Exit;
  Count:=Range.Count-1;
  for i:=Range.StartAddres to Count do Delete(i);
  DeleteRangeFromArray(Index);
end;

procedure TMBRegSimpleList.DeleteRange(StartAddr, Count: Word);
var TempRange : TMBRegistersRangeClassic;
begin
  TempRange.StartAddres := StartAddr;
  TempRange.Count       := Count;
  DeleteRange(TempRange);
end;

procedure TMBRegSimpleList.DeleteRangeFromArray(Index: Integer);
var TempHigh : Integer;
    i, Count : Integer;
begin
  TempHigh := High(FRegRanges);
  if Index > TempHigh then Exit;
  if Index < Low(FRegRanges) then Exit;
  if Index = TempHigh then
   begin
    SetLength(FRegRanges, Length(FRegRanges) - 1);
    Exit;
   end;
  Count:=TempHigh-1;
  for i:=Index to Count do FRegRanges[i]:=FRegRanges[i+1]; // сдвигаем все элемены в массиве
  SetLength(FRegRanges, Length(FRegRanges) - 1);
end;

procedure TMBRegSimpleList.SetRegDefType(const Value: TRegTypes);
begin
  DoSetRegDefType(Value);
end;

procedure TMBRegSimpleList.DefragmentationList(var RangeArray : TMBRegistersRangeClassicArray);
var i, Count, Distance: Integer;
    TempRange : PMBRegistersRangeClassic;
    TempRange1: TMBRegistersRangeClassic;
begin
  if RegRangeCount < 2 then Exit;

  TempRange := nil;

  Count:=Length(RangeArray)-1;
  for i:=1 to Count do
   begin
    TempRange1:=RangeArray[i];

    if RangeArray[i-1].Count<>0 then TempRange:=@RangeArray[i-1]
     else Continue;

    Distance:=TempRange1.StartAddres -(TempRange^.StartAddres+TempRange^.Count);

    if Distance > 1 then Continue;

    TempRange^.Count := (TempRange1.StartAddres+TempRange1.Count)-TempRange^.StartAddres;

    RangeArray[i].Count := 0;
   end;

  for i := Count downto 1 do
   if RangeArray[i].Count = 0 then DeleteRangeFromArray(i);
end;

function TMBRegSimpleList.OptimizeRange(Range : TMBRegistersRangeClassic; out Ranges : TMBRegistersRangeClassicArray): Boolean;
var i, Count, Index, LeftSide, RightSide : Integer;
    TempRangeArray : TMBRegistersRangeClassicArray;
    TempRangeState : TMBSubrangeStateOfRange;
begin
  Result:=False;
  SetLength(Ranges,0);
  SetLength(TempRangeArray,0);

  if RegRangeCount = 0 then
   begin
    Result := True;
    Exit;
   end;

  if IsRangeOnTheList(Range.StartAddres,Range.Count,Index) then Exit;

  Count:=RegRangeCount-1;
  for i:=0 to Count do // выбираем диапазоны с которыми пересекается диапазон
   begin
    TempRangeState := PositionOnRangeOfSubrange(RegRanges[i],Range,LeftSide,RightSide);
    case TempRangeState of
     ssrOutsideLeftEdge,
     ssrOutsideRightEdge,
     ssrLargerRange      : begin
                            SetLength(TempRangeArray,Length(TempRangeArray)+1);
                            TempRangeArray[Length(TempRangeArray)-1]:=RegRanges[i];
                           end;
    end;
   end;

  if Length(TempRangeArray)=0 then
   begin
    Result:=True;
    Exit;
   end;

  //собственно проведение оптимизации
  Count:=Length(TempRangeArray)-1;
  SortArray(0,Count,TempRangeArray);
  for i := 0 to Count do
   begin
    if i=0 then
     begin
       TempRangeState := PositionOnRangeOfSubrange(TempRangeArray[i],Range,LeftSide,RightSide);
       case TempRangeState of
        ssrOutsideLeftEdge  : begin
                               SetLength(Ranges,Length(Ranges)+1);
                               Ranges[Length(Ranges)-1].StartAddres := TempRangeArray[i].StartAddres+TempRangeArray[i].Count;
                               Ranges[Length(Ranges)-1].Count       := (Range.StartAddres+Range.Count)-Ranges[Length(Ranges)-1].StartAddres;
                              end;
        ssrOutsideRightEdge : begin
                               if Count > 0 then Continue;
                               SetLength(Ranges,Length(Ranges)+1);
                               Ranges[Length(Ranges)-1].StartAddres := Range.StartAddres;
                               Ranges[Length(Ranges)-1].Count       := TempRangeArray[i].StartAddres-Range.StartAddres;
                              end;
        ssrLargerRange      : begin
                               SetLength(Ranges,Length(Ranges)+1);
                               Ranges[Length(Ranges)-1].StartAddres := Range.StartAddres;
                               Ranges[Length(Ranges)-1].Count       := TempRangeArray[i].StartAddres-Range.StartAddres;

                               if Count > 0 then Continue;
                               SetLength(Ranges,Length(Ranges)+1);
                               Ranges[Length(Ranges)-1].StartAddres := TempRangeArray[i].StartAddres+TempRangeArray[i].Count;
                               Ranges[Length(Ranges)-1].Count       := (Range.StartAddres+Range.Count)-Ranges[Length(Ranges)-1].StartAddres;
                              end;
       end;
     end
    else
     if i = Count then
      begin
        SortArray(0,Length(TempRangeArray)-1,TempRangeArray);
        if (TempRangeArray[i].StartAddres + TempRangeArray[i].Count) < (Range.StartAddres + Range.Count) then
        begin
          SetLength(Ranges,Length(Ranges)+1);
          Ranges[Length(Ranges)-1].StartAddres := TempRangeArray[i].StartAddres + TempRangeArray[i].Count;
          Ranges[Length(Ranges)-1].Count       := (Range.StartAddres+Range.Count)- Ranges[Length(Ranges)-1].StartAddres;
        end;
      end
     else
      begin
       if (TempRangeArray[i].StartAddres-(TempRangeArray[i-1].StartAddres + TempRangeArray[i-1].Count))<=1 then Continue;
       SetLength(Ranges,Length(Ranges)+1);
       Ranges[Length(Ranges)-1].StartAddres := TempRangeArray[i-1].StartAddres + TempRangeArray[i-1].Count;
       Ranges[Length(Ranges)-1].Count       := Ranges[Length(Ranges)-1].StartAddres - TempRangeArray[i].StartAddres;
      end;
   end;

  SortArray(0,Length(Ranges)-1, Ranges);

  SetLength(TempRangeArray,0);
  Result:=True;
end;

procedure TMBRegSimpleList.AddRangeOfRegs(StartAddr, Count: Word);
var i,ii,TempCount, TempCount1 : Integer;
    TempRange  : TMBRegistersRangeClassic;
    TempRanges : TMBRegistersRangeClassicArray;
begin
  TempRange.StartAddres := StartAddr;
  TempRange.Count       := Count;

  if not OptimizeRange(TempRange,TempRanges) then Exit;

  TempCount:=Length(TempRanges)-1;

  if TempCount = -1 then
   begin
    SetLength(FRegRanges,Length(FRegRanges)+1);
    FRegRanges[Length(FRegRanges)-1].StartAddres := TempRange.StartAddres;
    FRegRanges[Length(FRegRanges)-1].Count       := TempRange.Count;
   end;

  for i:=0 to TempCount do
   begin
    SetLength(FRegRanges,Length(FRegRanges)+1);
    FRegRanges[Length(FRegRanges)-1].StartAddres := TempRanges[i].StartAddres;
    FRegRanges[Length(FRegRanges)-1].Count       := TempRanges[i].Count;
   end;

  SortArray(0,Length(FRegRanges)-1,FRegRanges);

  DefragmentationList(FRegRanges);

  TempCount:=Length(FRegRanges)-1;
  for i:=0 to TempCount do
   begin
    TempRange  := FRegRanges[i];
    TempCount1 := TempRange.StartAddres+TempRange.Count-1;
    for ii:=TempRange.StartAddres to TempCount1 do AddReg(ii);
   end;
end;

procedure TMBRegSimpleList.AddRangeOfRegs(Range: TMBRegistersRangeClassic);
begin
  AddRangeOfRegs(Range.StartAddres,Range.Count);
end;

function TMBRegSimpleList.PositionOnRangeOfSubrange(Range, Subrange: TMBRegistersRangeClassic; out LeftSide, RightSide : Integer): TMBSubrangeStateOfRange;
var RangeEndAddr, SubrangeEndAddr : Word;
begin
  RangeEndAddr    := GetEndNumber(Range.StartAddres,Range.Count);
  SubrangeEndAddr := GetEndNumber(Subrange.StartAddres,Subrange.Count);
  Result:=ssrNotIncluded;
  if (Subrange.StartAddres > Range.StartAddres) and (SubrangeEndAddr < RangeEndAddr) then
   begin
    Result:=ssrIsInRange;       // поддиапазон входит в диапазон
    LeftSide  := Subrange.StartAddres - Range.StartAddres;
    RightSide := SubrangeEndAddr - RangeEndAddr;
    Exit;
   end;
  if (Subrange.StartAddres = Range.StartAddres) and (SubrangeEndAddr = RangeEndAddr) then
   begin
    Result:=ssrRangesAreEqual;  // поддиапазон равен диапазону
    LeftSide  := 0;
    RightSide := 0;
    Exit;
   end;
  if (Subrange.StartAddres < Range.StartAddres) and (SubrangeEndAddr > RangeEndAddr) then
   begin
    Result:=ssrLargerRange;     // поддиапазон включает в себя диапазон
    LeftSide  := Subrange.StartAddres - Range.StartAddres;
    RightSide := SubrangeEndAddr - RangeEndAddr;
    Exit;
   end;
  if (Subrange.StartAddres > RangeEndAddr) or (SubrangeEndAddr < Range.StartAddres)  then
   begin
    Result:=ssrNotIncluded;     // поддиапазон не входит в диапазон
    if (Subrange.StartAddres > RangeEndAddr) then // поддиапазон справа от диапазона
     begin
      LeftSide  := Subrange.StartAddres - RangeEndAddr;
      RightSide := SubrangeEndAddr-RangeEndAddr;
     end;
    if (SubrangeEndAddr < Range.StartAddres) then // поддиапазон слева от диапазона
     begin
      LeftSide  := Subrange.StartAddres-Range.StartAddres;
      RightSide := SubrangeEndAddr - Range.StartAddres;
     end;
    Exit;
   end;
  if (Subrange.StartAddres < Range.StartAddres) and (SubrangeEndAddr <= RangeEndAddr) then
   begin
    Result:=ssrOutsideLeftEdge; // левая граница поддиапазона выходит за границы диапазона
    LeftSide  := Subrange.StartAddres - Range.StartAddres;
    RightSide := SubrangeEndAddr - RangeEndAddr;
    Exit;
   end;
  if (Subrange.StartAddres > Range.StartAddres) and (SubrangeEndAddr >= RangeEndAddr) then
   begin
    Result:=ssrOutsideLeftEdge; // правая граница поддиапазона выходит за границы диапазона
    LeftSide  := Subrange.StartAddres - Range.StartAddres;
    RightSide := SubrangeEndAddr - RangeEndAddr;
   end;
end;

function TMBRegSimpleList.PositionOnRangeOfSubrange(rStartAddr, rCount, subSatartAddr, subCount: Word; out LeftSide, RightSide : Integer): TMBSubrangeStateOfRange;
var TempRange, TempSubRange : TMBRegistersRangeClassic;
begin
  TempRange.StartAddres    := rStartAddr;
  TempRange.Count          := rCount;
  TempSubRange.StartAddres := subSatartAddr;
  TempSubRange.Count       := subCount;
  Result:=PositionOnRangeOfSubrange(TempRange,TempSubRange, LeftSide, RightSide);
end;

procedure TMBRegSimpleList.SortArray(p,q : Integer; Ranges : TMBRegistersRangeClassicArray);
var i,j : integer;
    r, T : TMBRegistersRangeClassic;
begin
 if p<q then {массив из одного элемента тривиально упорядочен}
  begin
   r:=Ranges[p];
   i:=p-1;
   j:=q+1;
   while i<j do
    begin
     repeat
      i:=i+1;
     until Ranges[i].StartAddres>=r.StartAddres;
     repeat
      j:=j-1;
     until Ranges[j].StartAddres<=r.StartAddres;
     if i<j then
      begin
       T:=Ranges[i];
       Ranges[i]:=Ranges[j];
       Ranges[j]:=T;
      end;
    end;
   SortArray(p,j, Ranges);
   SortArray(j+1,q, Ranges);
  end;
end;

{ TMBRegBitSimpleList }

constructor TMBRegBitSimpleList.Create;
begin
  inherited;
  FRegDefType := rtBit;
end;

procedure TMBRegBitSimpleList.AddReg(Address: Word);
var TempReg : TMBBitRegister;
begin
  if FRegArray[Address]<>nil then Exit;
  TempReg:=TMBBitRegister.Create;
  TempReg.RegNumber  := Address;
  TempReg.MBRegType  := FRegListType;
  TempReg.OnChange   := FOnChange;
  TempReg.BefoChange := FBefoChange;
  FRegArray[Address] := TempReg;
  Inc(FRegCount);
end;

function TMBRegBitSimpleList.GetRegisters(Address: Word): TMBBitRegister;
begin
  Result:=FRegArray[Address] as TMBBitRegister;
end;

function TMBRegBitSimpleList.GetValueRegs(Address: Word): Boolean;
begin
  if FRegArray[Address]<>nil then Result:=TMBBitRegister(FRegArray[Address]).Value
   else raise EMBIllegalDataAddress.Create;
end;

procedure TMBRegBitSimpleList.SetBefoChange(const Value: TBefoRegBitChange);
var i : Integer;
begin
  FBefoChange := Value;
  for i:=0 to MAXWORD do
   if FRegArray[i]<>nil then (FRegArray[i] as TMBBitRegister).BefoChange:=Value;
end;

procedure TMBRegBitSimpleList.SetOnChange(const Value: TOnRegBitChange);
var i : Integer;
begin
  FOnChange := Value;
  for i:=0 to MAXWORD do
   if FRegArray[i]<>nil then (FRegArray[i] as TMBBitRegister).OnChange:=Value;
end;

procedure TMBRegBitSimpleList.DoSetRegDefType(const Value: TRegTypes);
begin
  // Заглушка. Данный тип регистров не может менять форму.
end;

{ TMBRegWordSimpleList }

constructor TMBRegWordSimpleList.Create;
begin
  inherited;
  FRegDefType := rtSimpleWord;
end;

procedure TMBRegWordSimpleList.AddReg(Address: Word);
var TempReg : TMBWordRegister;
begin
  if FRegArray[Address]<>nil then Exit;
  TempReg:=nil;
  case FRegDefType of
   rtSimpleWord : TempReg:=TMBWordRegister.Create;
   rtWord       : TempReg:=TMBWordBitRegister.Create;
   rtWordByte   : TempReg:=TMBByteMixedRegister.Create;
  end;
  TempReg.RegNumber  := Address;
  TempReg.MBRegType  := FRegListType;
  TempReg.OnChange   := FOnChange;
  TempReg.BefoChange := FBefoChange;
  
  FRegArray[Address] := TempReg;
  Inc(FRegCount);
end;

procedure TMBRegWordSimpleList.DoSetRegDefType(const Value: TRegTypes);
var TempReg : TMBWordRegister;
    i : Integer;
begin
  if Value = FRegDefType then Exit;
  if Value = rtBit then raise Exception.Create(rsWordToBitError);
  for i := 0 to MAXWORD do
   begin
    if FRegArray[i]=nil then Continue;
    TempReg:=TMBWordRegister(FRegArray[i]);
    case Value of
     rtSimpleWord : begin
                     FRegArray[i]:=TMBWordRegister.Create;
                     TMBWordRegister(FRegArray[i]).Assigin(TempReg);
                    end;
     rtWord       : begin
                     FRegArray[i]:=TMBWordBitRegister.Create;
                     TMBWordBitRegister(FRegArray[i]).Assigin(TempReg);
                    end;
     rtWordByte   : begin
                     FRegArray[i]:=TMBByteMixedRegister.Create;
                     TMBByteMixedRegister(FRegArray[i]).Assigin(TempReg);
                    end;
    end;
   end;
  FRegDefType := Value;
end;

function TMBRegWordSimpleList.GetRegisters(Address: Word): TMBWordRegister;
begin
  Result := FRegArray[Address] as TMBWordRegister;
end;

function TMBRegWordSimpleList.GetValueRegs(Address: Word): Word;
begin
  if FRegArray[Address]<>nil then Result:=TMBWordRegister(FRegArray[Address]).Value
   else raise Exception.Create(Format(rsReAddrNotAssign,[Address]));
end;

procedure TMBRegWordSimpleList.SetBefoChange(const Value: TBefoRegWordChange);
var i : Integer;
begin
  FBefoChange := Value;
  for i:=0 to MAXWORD do
   if FRegArray[i]<>nil then (FRegArray[i] as TMBWordRegister).BefoChange:=Value;
end;

procedure TMBRegWordSimpleList.SetOnChange(const Value: TOnRegWordChange);
var i : Integer;
begin
  FOnChange := Value;
  for i:=0 to MAXWORD do
   if FRegArray[i]<>nil then (FRegArray[i] as TMBWordRegister).OnChange:=Value;
end;

end.

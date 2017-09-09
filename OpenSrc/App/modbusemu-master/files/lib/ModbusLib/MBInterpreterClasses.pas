unit MBInterpreterClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBDefine, MBRegistersCalsses, MBByteClasses, MBBitsClasses;

type
  TInterpreterData = TStrings;
  TInterpreterTypes = (itBit,itByteBit,itWordBit,itByteAnalog,itWordAnalog,itByteFlags,itWordFlags,itSPWordReg);

  TBitFlagsNames = array [0..1] of String;
  TByteFlagNames = array [0..255] of String;
  TWordFlagNames = array [0..65535] of String;

  TInterpriter = class                // абстрактный класс интерпретатора
   private
    function GetState: String;
    function GetTransition: String;
   protected
    FState      : String;    // описание нового состояния бита
    FTransition : String;    // описание состоявшегося перехода в новое состояние
    function IsInit : Boolean;virtual; abstract;
   public
    constructor Create; virtual;
    procedure Init(Data : TInterpreterData); virtual; abstract;
    procedure Interpret(const Value); virtual; abstract;
    property State      : String read GetState;
    property Transition : String read GetTransition;
  end;

  TBitInterpreter = class(TInterpriter)  // интерпретатор бита данных
   private
    FValue     : Boolean;        // поле содержащее текущее значение бита
    FFlagsName : TBitFlagsNames; // массив имен состояний бита
    FInit      : Boolean;        // флаг инициализации
   protected
    function IsInit : Boolean; override;
   public
    constructor Create; override;
    procedure Init(Data : TInterpreterData); override; // количество строк должно быть не менее 4-х
    procedure Interpret(const Value); override;
  end;

  TByteBitArray  = array [0..7] of TBitInterpreter;
  TWordBitArray  = array [0..15] of TBitInterpreter;
  TDwordBitArray = array [0..31] of TBitInterpreter;

  TByteBitInterpreter = class(TInterpriter)  // интерпретатор байта данных как набора бит
   private
    FValue      : TRegByte;        // объект отслеживающий изменение байта
    FByteChange : TRegBits;        // перечисление содержащее перечень измененных бит в байте
    FBitArray   : TByteBitArray;   // массив интерпредаторов бит
    procedure OnRegByteChange(Sender : TRegByte; ChangeBitSet : TRegBits = []);
    function  GetBits(i: Integer): TBitInterpreter;
   protected
    function IsInit : Boolean; override;
   public
    constructor Create; override;
    destructor  Destroy; override;
    procedure Init(Data : TInterpreterData); override; // количество строк должно быть N*4, где N количество бит. Не используемые строки должны быть пустыми
    procedure Interpret(const Value); override;
    property  Bits[i : Integer] : TBitInterpreter read GetBits;
    property  ByteChangeBits    : TRegBits read FByteChange;
  end;

  TWordBitInterpreter = class(TInterpriter)   // интерпретатор слова данных как набора бит
   private
    FValue      : TMBWordBitRegister; // объект отслеживающий изменение байта
    FByteChange : TRegBits;           // перечисление содержащее перечень измененных бит в байте
    FBitArray   : TWordBitArray;      // массив интерпредаторов бит
    procedure OnRegWordChange(Sender : TMBWordRegister; ChangeBitSet : TRegBits = []);
    function  GetBits(i: Integer): TBitInterpreter;
   protected
    function IsInit : Boolean; override;
   public
    constructor Create; override;
    destructor  Destroy; override;
    procedure Init(Data : TInterpreterData); override;
    procedure Interpret(const Value); override;
    property  Bits[i : Integer] : TBitInterpreter read GetBits;
    property  ByteChangeBits    : TRegBits read FByteChange;
  end;

  TByteAnalogInterpreter = class(TInterpriter)  // интерпретатор байта данных как аналогового значения
   private
    FValue       : Byte;                        // текущее значение
    FValueString : String;                      // строка сопровождающая значение
   protected
    function IsInit : Boolean; override;
   public
    procedure Init(Data : TInterpreterData); override;
    procedure Interpret(const Value); override;
  end;

  TWordAnalogInterpreter = class(TInterpriter)  // интерпретатор слова данных как аналогового значения
   private
    FValue       : Word;                        // текущее значение
    FValueString : String;                      // строка сопровождающая значение
   protected
    function IsInit : Boolean; override;
   public
    procedure Init(Data : TInterpreterData); override;
    procedure Interpret(const Value); override;
  end;

  TByteFlagsInterpreter = class(TInterpriter) // класс интерпретатора байта как значения флага
   private
    FValue     : Byte;                        // текущее значение флага
    FFlagNames : TByteFlagNames;              // массив строк с расшифровкой флага
    FIsInit    : Boolean;                     // признак инициализации массива описателей флагов
   protected
    function IsInit : Boolean; override;
   public
    constructor Create; override;
    procedure Init(Data : TInterpreterData); override; // набор имен флагов в формате <FlagID>=<Name>, где FlagID-числовое значение флага Name - описание флага
    procedure Interpret(const Value); override;
  end;

  TWordFlagsInterpreter = class(TInterpriter) // класс интерпретатора байта как значения флага
   private
    FValue     : Byte;                        // текущее значение флага
    FFlagNames : TWordFlagNames;              // массив строк с расшифровкой флага
    FIsInit    : Boolean;                     // признак инициализации массива описателей флагов
   protected
    function IsInit : Boolean; override;
   public
    constructor Create; override;
    procedure Init(Data : TInterpreterData); override; // набор имен флагов в формате <FlagID>=<Name>, где FlagID-числовое значение флага Name - описание флага
    procedure Interpret(const Value); override;
  end;

  TSPWordInterpreter = class(TInterpriter)
   private
    FValue       : TMBByteMixedRegister;
    FCSValue     : Byte;
    FIsInit      : Boolean;
    FMasterSlave : TBitInterpreter;
    FPreError    : TByteFlagsInterpreter;
    FErrors      : TByteFlagsInterpreter;
    FInfo        : TByteFlagsInterpreter;
    FCounter     : TWordAnalogInterpreter;
    FTemperature : TByteAnalogInterpreter;
   protected
    function IsInit  : Boolean; override;
    function CheckCS : Boolean ; virtual;
   public
    constructor Create; override;
    destructor  Destroy; override;
    procedure Init(Data : TInterpreterData); override; // набор имен флагов предотказных состояний в формате <FlagID>=<Name>, где FlagID-числовое значение флага Name - описание флага
    procedure Interpret(const Value ); override;
  end;

implementation

uses SysUtils,
     MBResourceString;

{ TInterpriter }

constructor TInterpriter.Create;
begin
 FState:='';
 FTransition:='';
end;

function TInterpriter.GetState: String;
begin
 Result:=FState;
end;

function TInterpriter.GetTransition: String;
begin
 Result:=FTransition;
end;

{ TBitInterpreter }

function TBitInterpreter.IsInit : Boolean;
begin
 Result:= FInit;
end;

constructor TBitInterpreter.Create;
begin
  inherited;
  FValue := False;
  FInit  := False;
end;

procedure TBitInterpreter.Init(Data: TInterpreterData);
var i : Integer;
begin
 for i := 0 to 1 do
  if Data.Count>0 then
   begin
    FFlagsName[i]:=Data.Strings[0];
    Data.Delete(0);
   end;
 FInit:=True;  
end;

procedure TBitInterpreter.Interpret(const Value );
var str,str1 : String;
begin
 if not IsInit then raise Exception.Create(ErrInterNotInit);
 if FFlagsName[integer(Boolean(Value))]='' then str:=Format(rsNoNameStrFlagValue,[rsNoNameFlag,BoolToStr(Boolean(Value),True)])else str:=FFlagsName[integer(Boolean(Value))];
 if FFlagsName[integer(FValue)]='' then str1:=Format(rsNoNameStrFlagValue,[rsNoNameFlag,BoolToStr(FValue,True)]) else str1:=FFlagsName[integer(FValue)];
 FState:=str;
 FTransition:=Format('%s -> %s',[str1,str]);
 FValue:=Boolean(Value);
end;

{ TByteBitInterpreter }

constructor TByteBitInterpreter.Create;
var i : Integer;
begin
  inherited;
  FValue:=TRegByte.Create;
  FValue.OnChange:=OnRegByteChange;
  for i := 0 to 7 do FBitArray[i]:=TBitInterpreter.Create;
end;

destructor TByteBitInterpreter.Destroy;
var i : Integer;
begin
  for i := 0 to 7 do FBitArray[i].Free;
  FValue.Free;
  inherited;
end;

function TByteBitInterpreter.GetBits(i: Integer): TBitInterpreter;
begin
 if (i<0) or (i>7) then raise Exception.Create(ErrOutOfRange);
 Result:=FBitArray[i];
end;

procedure TByteBitInterpreter.Init(Data: TInterpreterData);
var i : Integer;
begin
  for i := 0 to 7 do FBitArray[i].Init(Data);
end;

procedure TByteBitInterpreter.Interpret(const Value);
begin
  if FValue.Value=Byte(Value) then Exit;
  if not IsInit then raise Exception.Create(ErrInterNotInit);
  FValue.Value:=Byte(Value);
end;

function TByteBitInterpreter.IsInit: Boolean;
begin
 Result:=True;
end;

procedure TByteBitInterpreter.OnRegByteChange(Sender: TRegByte; ChangeBitSet: TRegBits);
var Value : Byte;
    TempBit : Boolean;
begin
  Value:=Sender.Value;
  TempBit:=(Value and 1)=1;
  if rw0 in ChangeBitSet then FBitArray[0].Interpret(TempBit);
  TempBit:=(Value and 2)=2;
  if rw1 in ChangeBitSet then FBitArray[1].Interpret(TempBit);
  TempBit:=(Value and 4)=4;
  if rw2 in ChangeBitSet then FBitArray[2].Interpret(TempBit);
  TempBit:=(Value and 8)=8;
  if rw3 in ChangeBitSet then FBitArray[3].Interpret(TempBit);
  TempBit:=(Value and 16)=16;
  if rw4 in ChangeBitSet then FBitArray[4].Interpret(TempBit);
  TempBit:=(Value and 32)=32;
  if rw5 in ChangeBitSet then FBitArray[5].Interpret(TempBit);
  TempBit:=(Value and 64)=64;
  if rw6 in ChangeBitSet then FBitArray[6].Interpret(TempBit);
  TempBit:=(Value and 128)=128;
  if rw7 in ChangeBitSet then FBitArray[7].Interpret(TempBit);
  FByteChange:=ChangeBitSet;
end;

{ TWordBitInterpreter }

constructor TWordBitInterpreter.Create;
var i : Integer;
begin
  inherited;
  FValue:=TMBWordBitRegister.Create;
  FValue.OnChange:=OnRegWordChange;
  for i := 0 to 15 do FBitArray[i]:=TBitInterpreter.Create;
end;

destructor TWordBitInterpreter.Destroy;
var i : Integer;
begin
  for i := 0 to 15 do FBitArray[i].Free;
  FValue.Free;
  inherited;
end;

function TWordBitInterpreter.GetBits(i: Integer): TBitInterpreter;
begin
  if (i<0) or (i>15) then raise Exception.Create(ErrOutOfRange);
  Result:=FBitArray[i];
end;

procedure TWordBitInterpreter.Init(Data: TInterpreterData);
var i : Integer;
begin
  for i := 0 to 15 do FBitArray[i].Init(Data);
end;

procedure TWordBitInterpreter.Interpret(const Value);
begin
  if Word(Value)=FValue.Value then Exit;
  if not IsInit then raise Exception.Create(ErrInterNotInit);
  FValue.Value:=Word(Value);
end;

function TWordBitInterpreter.IsInit: Boolean;
begin
  Result:=True;
end;

procedure TWordBitInterpreter.OnRegWordChange(Sender: TMBWordRegister; ChangeBitSet: TRegBits);
var TempBit : Boolean;
begin
  TempBit:=(FValue.Value and 1)=1;
  if rw0 in ChangeBitSet then FBitArray[0].Interpret(TempBit);
  TempBit:=(FValue.Value and 2)=2;
  if rw1 in ChangeBitSet then FBitArray[1].Interpret(TempBit);
  TempBit:=(FValue.Value and 4)=4;
  if rw2 in ChangeBitSet then FBitArray[2].Interpret(TempBit);
  TempBit:=(FValue.Value and 8)=8;
  if rw3 in ChangeBitSet then FBitArray[3].Interpret(TempBit);
  TempBit:=(FValue.Value and 16)=16;
  if rw4 in ChangeBitSet then FBitArray[4].Interpret(TempBit);
  TempBit:=(FValue.Value and 32)=32;
  if rw5 in ChangeBitSet then FBitArray[5].Interpret(TempBit);
  TempBit:=(FValue.Value and 64)=64;
  if rw6 in ChangeBitSet then FBitArray[6].Interpret(TempBit);
  TempBit:=(FValue.Value and 128)=128;
  if rw7 in ChangeBitSet then FBitArray[7].Interpret(TempBit);
  TempBit:=(FValue.Value and 256)=256;
  if rw8 in ChangeBitSet then FBitArray[8].Interpret(TempBit);
  TempBit:=(FValue.Value and 512)=512;
  if rw9 in ChangeBitSet then FBitArray[9].Interpret(TempBit);
  TempBit:=(FValue.Value and 1024)=1024;
  if rw10 in ChangeBitSet then FBitArray[10].Interpret(TempBit);
  TempBit:=(FValue.Value and 2048)=2048;
  if rw11 in ChangeBitSet then FBitArray[11].Interpret(TempBit);
  TempBit:=(FValue.Value and 4096)=4096;
  if rw12 in ChangeBitSet then FBitArray[12].Interpret(TempBit);
  TempBit:=(FValue.Value and 8192)=8192;
  if rw13 in ChangeBitSet then FBitArray[13].Interpret(TempBit);
  TempBit:=(FValue.Value and 16384)=16384;
  if rw14 in ChangeBitSet then FBitArray[14].Interpret(TempBit);
  TempBit:=(FValue.Value and 32768)=32768;
  if rw15 in ChangeBitSet then FBitArray[15].Interpret(TempBit);
  FByteChange:=ChangeBitSet;
end;

{ TWordAnalogInterpreter }

procedure TWordAnalogInterpreter.Init(Data: TInterpreterData);
begin
  FValueString:='';
  FValueString:=Data.Strings[0];
  Data.Delete(0);
end;

procedure TWordAnalogInterpreter.Interpret(const Value);
begin
 if Word(Value)=FValue then Exit;
 if not IsInit then raise Exception.Create(ErrInterNotInit);
 FState:=Format(rsDigitalValue,[Word(Value)]);
 FTransition:=Format(FValueString+'%d',[Word(Value)]);
 FValue:=Word(Value);
end;

function TWordAnalogInterpreter.IsInit: Boolean;
begin
 Result:= not (FValueString = '');
end;

{ TByteAnalogInterpreter }

procedure TByteAnalogInterpreter.Init(Data: TInterpreterData);
begin
  FValueString:='';
  FValueString:=Data.Strings[0];
  Data.Delete(0);
end;

procedure TByteAnalogInterpreter.Interpret(const Value);
begin
 if Byte(Value)=FValue then Exit;
 if not IsInit then raise Exception.Create(ErrInterNotInit);
 FState:=Format(rsDigitalValue,[Byte(Value)]);
 FTransition:=Format(FValueString+'%d',[Byte(Value)]);
 FValue:=Byte(Value);
end;

function TByteAnalogInterpreter.IsInit: Boolean;
begin
 Result:= not (FValueString = '');
end;

{ TByteFlagsInterpreter }

constructor TByteFlagsInterpreter.Create;
begin
  inherited;
  FIsInit := False;
end;

procedure TByteFlagsInterpreter.Init(Data: TInterpreterData);
var i : Integer;
begin
 if Data.Count=0 then raise Exception.Create(ErrInterNotValue);
 if Data.Count>256 then raise Exception.Create(ErrOutOfRange);
 for i := 0 to Data.Count-1 do
  begin
   if Data.Names[i]<>'' then FFlagNames[StrToInt(Data.Names[i])]:=Data.Values[Data.Names[i]];
  end;
 FIsInit:=True;
end;

procedure TByteFlagsInterpreter.Interpret(const Value);
var str, str1: String;
begin
  if FFlagNames[Byte(Value)]='' then str :=Format(rsNoNameFlagValue,[rsNoNameFlag,Byte(Value)]) else str:=FFlagNames[Byte(Value)];
  if FFlagNames[FValue]='' then str1:= Format(rsNoNameFlagValue,[rsNoNameFlag,FValue]) else str1:=FFlagNames[FValue];
  FState:=str;
  FTransition:=Format('%s -> %s',[str1,str]);
  FValue:=Byte(Value);
end;

function TByteFlagsInterpreter.IsInit: Boolean;
begin
 Result:=FIsInit;
end;

{ TWordFlagsInterpreter }

constructor TWordFlagsInterpreter.Create;
begin
  inherited;
  FIsInit:=False;
end;

procedure TWordFlagsInterpreter.Init(Data: TInterpreterData);
var i : Integer;
begin
 if Data.Count=0 then raise Exception.Create(ErrInterNotValue);
 if Data.Count>65536 then raise Exception.Create(ErrOutOfRange);
 for i := 0 to Data.Count-1 do
  begin
    FFlagNames[StrToInt(Data.Names[i])]:=Data.Values[Data.Names[i]];
  end;
 FIsInit:=True;
end;

procedure TWordFlagsInterpreter.Interpret(const Value);
begin
  FState:=FFlagNames[Word(Value)];
  FTransition:=Format('%s -> %s',[FFlagNames[FValue],FFlagNames[Word(Value)]])
end;

function TWordFlagsInterpreter.IsInit: Boolean;
begin
 Result:=FIsInit;
end;

{ TSPWordInterpreter }

function TSPWordInterpreter.CheckCS: Boolean;
begin
 Result:=True;
end;

constructor TSPWordInterpreter.Create;
var TempStrings : TStringList;
begin
  inherited;
  FValue       := TMBByteMixedRegister.Create;
  FCounter     := TWordAnalogInterpreter.Create;
  FPreError    := TByteFlagsInterpreter.Create;
  FErrors      := TByteFlagsInterpreter.Create;
  FInfo        := TByteFlagsInterpreter.Create;
  FMasterSlave := TBitInterpreter.Create;
  FTemperature := TByteAnalogInterpreter.Create;
  TempStrings  := TStringList.Create;
  try
   TempStrings.Text:=rsSPErrorString;
   FErrors.Init(TempStrings);
   TempStrings.Text:=rsSPMasterSlave;
   FMasterSlave.Init(TempStrings);
   TempStrings.Text:=rsSPInfoString;
   FInfo.Init(TempStrings);
   TempStrings.Text:=rsSPCounter;
   FCounter.Init(TempStrings);
   TempStrings.Text:=rsSPTemperature;
   FTemperature.Init(TempStrings);
  finally
   TempStrings.Free;
  end;
  FIsInit:=False;
end;

destructor TSPWordInterpreter.Destroy;
begin
  FValue.Free;
  FCounter.Free;
  FPreError.Free;
  FErrors.Free;
  FInfo.Free;
  FMasterSlave.Free;
  FTemperature.Free;
  inherited;
end;

procedure TSPWordInterpreter.Init(Data: TInterpreterData);
begin
 FPreError.Init(Data);
 FIsInit:=True;
end;

procedure TSPWordInterpreter.Interpret(const Value);
var TempBit : Boolean;
    TempWord : Word;
begin
  FValue.Value:=Word(Value);
  FCSValue:=(Word(Value) and 30720) shr 11; // получаем код хэменга (контрольную сумму)
  if not CheckCS then
   begin
    FState:=ErrCS;
    FTransition:='';
    Exit;
   end;
  TempBit:=FValue.HighByteBits[7];
  FMasterSlave.Interpret(TempBit);     // получаем флаг основной/ублирующий счетного пункта
  if not FValue.HighByteBits[2] then  // проверяем что передано - счетчики осей (0-False) или что то другое (1-True)
   begin                               // обрабатываем счетчики осей
    TempWord:=FValue.Value and 1023;
    FCounter.Interpret(TempWord);
    FState:=Format('%s. %s',[FMasterSlave.State,FCounter.State]);
    FTransition:=Format('%s. %s',[FMasterSlave.State,FCounter.Transition]);
    Exit;
   end;
  case (FValue.HighByteValue and 3) of
    0 : begin   // нет диагностики
         if (FValue.LowByteValue and 3)=3 then
          begin
           FState:=Format('%s. %s',[FMasterSlave.State,rsSPMZD]);
           FTransition:='';
          end
         else
          begin
           TempWord:=FValue.LowByteValue and 3;
           FErrors.Interpret(TempWord);
           FState:=Format('%s. %s',[FMasterSlave.State,FErrors.State]);
           FTransition:=Format('%s. %s',[FMasterSlave.State,FErrors.Transition]);
          end;
        end;
    1 : begin  // диагностика
         TempWord:=FValue.LowByteValue;
         FPreError.Interpret(TempWord);
         FState:=Format('%s. %s',[FMasterSlave.State,FPreError.State]);
         FTransition:=Format('%s. %s',[FMasterSlave.State,FPreError.Transition]);
        end;
    2 : begin  // температура
         TempWord:=FValue.LowByteValue;
         FTemperature.Interpret(TempWord);
         FState:=Format('%s. %s',[FMasterSlave.State,FTemperature.State]);
         FTransition:=Format('%s. %s',[FMasterSlave.State,FTemperature.Transition]);
        end;
    3 : begin // не понятное состояние
         FState:=Format('%s. %s',[FMasterSlave.State,rsSPNoneState]);
         FTransition:=Format('%s. %s',[FMasterSlave.State,rsSPNoneState]);
        end;
  end;

end;

function TSPWordInterpreter.IsInit: Boolean;
begin
 Result:=FIsInit;
end;

end.
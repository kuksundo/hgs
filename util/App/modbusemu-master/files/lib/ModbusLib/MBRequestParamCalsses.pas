unit MBRequestParamCalsses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBRequestTypes;

resourcestring
  errIndexError = 'Недопустимый индекс регистра типа Word. Максимальный индекс - 123.';

type
  TWordByte = packed record
   case Integer of
    0: (FirstByte  : Byte;
        SecondByte : Byte);
    1: (aWord : Word);
   end;

  TMBRTUDataArray = array of Byte;

  TMBRTUParams = class
  private
    FMBDevID       : Byte;
    FMBFunction    : Byte;
    FMBMEIType     : TMEIType;
    FMBObjectID    : TObjectID;
    FMBReadDevID   : TReadDeviceIDCode;
    FMBStartReg    : Word;
    FMBRegcount    : Word;
    FMBQuantityWr  : Word;
    FMBORMask      : Word;
    FSubFunction   : Word;
    FSub00F8       : Word;
    FSub01F8       : Boolean;
    FSub03F8       : Char;
   protected
    FDataByteCount : Byte;
    FDataBytes     : array [0..255] of Byte;
    FDataBits      : TBits;
    function  GetDataBytes(index: Byte): Byte; virtual;
    function  GetDataWords(index: Byte): Word; virtual;
    procedure SetDataBytes(index: Byte; const Value: Byte);  virtual;
    procedure SetDataWords(index: Byte; const Value: Word); virtual;
    procedure CheckWordIndex(index : Byte); virtual;
   public
    constructor Create; virtual;
    destructor  Destroy; override;
    procedure AddRegData(Data : array of Byte);
    function  GetDataArray : TMBRTUDataArray; virtual;
    procedure ClearData;
    property MBDevID       : Byte read FMBDevID write FMBDevID default 1;
    property MBFunction    : Byte read FMBFunction write FMBFunction default 1;
    property MBStartReg    : Word read FMBStartReg write FMBStartReg;     // может использоваться как Reference Address для 22 функции; как OutputAddress для 5,6 функции; как Read Starting Address для 23 функции; как FIFO Pointer Address для функции 24
    property MBRegcount    : Word read FMBRegcount write FMBRegcount;     // может использоваться как AND_Mask для 22 функции; как OutputValue для 5,6 функции; как Quantity to Read для 23 функции;
    property MBORMask      : Word read FMBORMask write FMBORMask;         // как Write starting address для 23 функции
    property MBQuantityWr  : Word read FMBQuantityWr write FMBQuantityWr; // как Quantity to write для 23 функции

    property SubFunction   : Word read FSubFunction write FSubFunction;   // для функции 8
    property Sub00F8       : Word read FSub00F8 write FSub00F8;           // для функции 8
    property Sub01F8       : Boolean read FSub01F8 write FSub01F8;        // для функции 8
    property Sub03F8       : Char read FSub03F8 write FSub03F8;           // для функции 8

    property MBMEIType     : TMEIType read FMBMEIType write FMBMEIType;       // 43/14/13
    property MBReadDevID   : TReadDeviceIDCode read FMBReadDevID write FMBReadDevID;   // 43/14
    property MBObjectID    : TObjectID read FMBObjectID write FMBObjectID;     // 43/14

    property DataByteCount : Byte read FDataByteCount;
    property DataBits      : TBits read FDataBits;                        // для записи битовых регистров
    property DataBytes[index : Byte] : Byte read GetDataBytes write SetDataBytes;  // массив данных для записи
    property DataWords[index : Byte] : Word read GetDataWords write SetDataWords;  // массив данных для записи
  end;

  TMBTCPParams = class(TMBRTUParams)
   private
    FTransactioID : Word;
    FProtocolID   : Word;
    FLength       : Word;
   public
    constructor Create; override;
    property TransactioID : Word read FTransactioID write FTransactioID;
    property ProtocolID   : Word read FProtocolID write FProtocolID default 0;
    property Length       : Word read FLength write FLength;
  end;


implementation

uses SysUtils, Math;

{ TMBRTUParams }

procedure TMBRTUParams.AddRegData(Data: array of Byte);
begin
  ClearData;
  // Заполнение массива
  FDataByteCount:=Length(Data);
  Move(Data[Low(Data)],FDataBytes[0],FDataByteCount);
end;

procedure TMBRTUParams.CheckWordIndex(index: Byte);
begin
  if index >=123 then raise EInvalidArgument.Create(errIndexError);
end;

procedure TMBRTUParams.ClearData;
begin
  FillChar(FDataBytes[0],256,$0);
  FDataByteCount:=0;
  FDataBits.Size:=0;
end;

constructor TMBRTUParams.Create;
begin
  inherited;
  FMBDevID      := 1;
  FMBFunction   := 1;
  FMBStartReg   := 0;
  FMBRegcount   := 0;
  FMBQuantityWr := 0;
  FMBORMask     := 0;
  FSubFunction  := 0;
  FSub00F8      := 0;
  FSub01F8      := False;
  FSub03F8      := Char(0);
  FDataBits     := TBits.Create;
  ClearData;
end;

destructor TMBRTUParams.Destroy;
begin
  FDataBits.Free;
  inherited;
end;

function TMBRTUParams.GetDataArray: TMBRTUDataArray;
begin
  SetLength(Result,FDataByteCount);
  Move(FDataBytes[0],Result[0],FDataByteCount);
end;

function TMBRTUParams.GetDataBytes(index: Byte): Byte;
begin
  Result := FDataBytes[index];
end;

function TMBRTUParams.GetDataWords(index: Byte): Word;
var i : Byte;
    TempWord : TWordByte;
begin
  CheckWordIndex(index);
  i := index*2;
  TempWord.FirstByte:=FDataBytes[i];
  TempWord.SecondByte:=FDataBytes[i+1];
  Result:=TempWord.aWord;
end;

procedure TMBRTUParams.SetDataBytes(index: Byte; const Value: Byte);
begin
  FDataBytes[index]:=Value;
end;

procedure TMBRTUParams.SetDataWords(index: Byte; const Value: Word);
var i : Byte;
    TempWord : TWordByte;
begin
  CheckWordIndex(index);
  i := index*2;
  TempWord.aWord:=Value;
  FDataBytes[i]:=TempWord.FirstByte;
  FDataBytes[i+1]:=TempWord.SecondByte
end;

{ TMBTCPParams }

constructor TMBTCPParams.Create;
begin
  inherited;
  FProtocolID   := 0;
  FTransactioID := 0;
  FLength       := 0;
end;

end.
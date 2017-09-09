unit MBBuilderRTUAnswerPacketClasses;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBDefine, MBInterfaces, MBBuilderPacketClasses,
     CRC16Func;

type

  TBuilderMBRTUAswerPacket = class(TBuilderMBRTUPacket, IBuilderRTUAnswerPacket)
  protected
   FSubFunction : Byte;
   function  GetFunctionNum: TMBFunctionsEnum;
   procedure SetFunctionNumber(const Value : TMBFunctionsEnum);
  public
   constructor Create(AOwner : TComponent); override;
   property FunctionNum : TMBFunctionsEnum read GetFunctionNum write SetFunctionNumber;
  end;

  TBuilderMBRTUErrorPacket = class(TBuilderMBRTUAswerPacket, IBuilderRTUErrorAnswer)
  private
   FErrorCode   : Byte;
  protected
   procedure SetErrorCode(const Value : Byte);
  public
   constructor Create(AOwner : TComponent); override;
   procedure Build; override;
   property ErrorCode   : Byte read FErrorCode write SetErrorCode;
  end;

  TBuilderMBRTUBitAswerPacket = class(TBuilderMBRTUAswerPacket, IBuilderRTUBitAnswerPacket)
  private
    FBitData : TBits;
  protected
    procedure SetBitData(const BitList : TBits);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Build; override;
    property BitData : TBits read FBitData write SetBitData;
  end;

  TBuilderMBRTUWordAswerPacket = class(TBuilderMBRTUAswerPacket, IBuilderRTUWordAnswerPacket)
  private
    FWordData : TWordRegsValues;
  protected
    procedure SetWordData(const WordList : TWordRegsValues);
  public
    destructor Destroy; override;
    procedure Build; override;
    property WordData : TWordRegsValues read FWordData write SetWordData;
  end;

implementation

uses sysutils,
     MBResourceString, MBResponseTypes, MBBuilderBase;

{ TBuilderMBRTUWordAswerPacket }

destructor TBuilderMBRTUWordAswerPacket.Destroy;
begin
  if Length(FWordData)>0 then SetLength(FWordData,0);
  inherited Destroy;
end;

procedure TBuilderMBRTUWordAswerPacket.SetWordData(const WordList : TWordRegsValues);
var TempLenght : Word;
    TempLenPack : Word;
begin
  SetLength(FWordData,0);
  TempLenght := Length(WordList);
  if TempLenght = 0 then Exit;

  SetLength(FWordData,TempLenght);

  Move(WordList[0],FWordData[0],TempLenght * 2);

  TempLenPack := SizeOf(TMBResponseHeader) + TempLenght*2 + 2;
  if FLenPacket <> TempLenPack then ClearPacket;
  FLenPacket := TempLenPack;
end;

procedure TBuilderMBRTUWordAswerPacket.Build;
var TempData    : PWordarray;
    i, Count    : Integer;
    TempPackCRC : PWord;
begin
 GetPacketMem;

 Count := Length(FWordData);

 PMBResponseHeader(FPacket)^.DeviceAddress := FDeviceAddress;
 PMBResponseHeader(FPacket)^.FunctionCode  := Byte(FunctionNum);
 PMBResponseHeader(FPacket)^.ByteCount     := Count*2;

 TempData := PWordarray(PtrUInt(FPacket)+3);

 for i := 0 to Count-1 do TempData^[i] := Swap(FWordData[i]);

 TempPackCRC := PWord(PtrUInt(FPacket)+(FLenPacket-2));
 TempPackCRC^ := GetCRC16(FPacket,FLenPacket-2);

 Notify(betBuild);
end;

{ TBuilderMBRTUBitAswerPacket }

constructor TBuilderMBRTUBitAswerPacket.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FBitData := TBits.Create;
end;

destructor TBuilderMBRTUBitAswerPacket.Destroy;
begin
  FreeAndNil(FBitData);
  inherited Destroy;
end;

procedure TBuilderMBRTUBitAswerPacket.SetBitData(const BitList : TBits);
var i,Count : Integer;
    TemDataByteCount : Byte;
    TempLenPack : Word;
begin
  FBitData.Size := 0;
  Count := BitList.Size-1;
  FBitData.Size := Count+1;
  for i:=0 to Count do FBitData.Bits[i] := BitList.Bits[i];
  // вычисляем количество байт необходимых для передачи значений полученных бит
  TemDataByteCount := FBitData.Size div 8;
  if (FBitData.Size mod 8)>0 then TemDataByteCount := TemDataByteCount+1;
  // определяем размер пакета

  TempLenPack := SizeOf(TMBResponseHeader) + TemDataByteCount + 2;
  if FLenPacket <> TempLenPack then ClearPacket;
  FLenPacket := TempLenPack;
end;

procedure TBuilderMBRTUBitAswerPacket.Build;
var TemDataByteCount : Byte;
    TempBuff         : PByteArray;
    TempPackCRC      : PWord;
    ByteIndex        : Integer;
    BitIndex         : Integer;
    i,Count          : Integer;
begin
  GetPacketMem;

  TemDataByteCount := FBitData.Size div 8;
  if (FBitData.Size mod 8)>0 then TemDataByteCount := TemDataByteCount+1;

  PMBResponseHeader(FPacket)^.DeviceAddress := FDeviceAddress;
  PMBResponseHeader(FPacket)^.FunctionCode  := Byte(FunctionNum);
  PMBResponseHeader(FPacket)^.ByteCount     := TemDataByteCount;

  Count:=FBitData.Size-1;
  TempBuff:=PByteArray(PtrUInt(@PMBResponseHeader(FPacket)^.ByteCount) + 1);
  for i := 0 to Count do
  begin
   ByteIndex:=i div 8;
   BitIndex:= i mod 8;
   case BitIndex of
     0 : if FBitData.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 1
          else
           if (TempBuff^[ByteIndex] and 1)=1 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 1;
     1 :if FBitData.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 2
          else
           if (TempBuff^[ByteIndex] and 2)=2 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 2;
     2 :if FBitData.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 4
          else
           if (TempBuff^[ByteIndex] and 4)=4 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 4;
     3 :if FBitData.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 8
          else
           if (TempBuff^[ByteIndex] and 8)=8 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 8;
     4 :if FBitData.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 16
          else
           if (TempBuff^[ByteIndex] and 16)=16 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 16;
     5 :if FBitData.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 32
          else
           if (TempBuff^[ByteIndex] and 32)=32 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 32;
     6 :if FBitData.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 64
          else
           if (TempBuff^[ByteIndex] and 64)=64 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 64;
     7 :if FBitData.Bits[i] then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] or 128
          else
           if (TempBuff^[ByteIndex] and 128)=128 then TempBuff^[ByteIndex]:= TempBuff^[ByteIndex] xor 128;
   end;
  end;

  TempPackCRC  := PWord(PtrUInt(FPacket)+(FLenPacket-2));
  TempPackCRC^ := GetCRC16(FPacket,FLenPacket-2);

  Notify(betBuild);
end;

{ TBuilderMBRTUErrorPacket }

constructor TBuilderMBRTUErrorPacket.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FErrorCode   := 0;
end;

procedure TBuilderMBRTUErrorPacket.SetErrorCode(const Value : Byte);
begin
  FErrorCode := Value;
end;

procedure TBuilderMBRTUErrorPacket.Build;
begin
  GetPacketMem;

  PMBErrorResponse(FPacket)^.Heder.DeviceAddress          := FDeviceAddress;
  PMBErrorResponse(FPacket)^.Heder.ErrorData.FunctionCode := Byte(FunctionNum) or $80;
  PMBErrorResponse(FPacket)^.Heder.ErrorData.ErrorCode    := FErrorCode;

  PMBErrorResponse(FPacket)^.CRC := GetCRC16(FPacket, sizeof(TMBErrorHeder));

  Notify(betBuild);
end;

{ TBuilderMBRTUAswerPacket }

constructor TBuilderMBRTUAswerPacket.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFunctionNum := 0;
  FSubFunction := 0;
end;

function TBuilderMBRTUAswerPacket.GetFunctionNum : TMBFunctionsEnum;
begin
  Result := fnNon;
  case FFunctionNum of
   0.. 24 : Result := TMBFunctionsEnum(FFunctionNum);
   43     : begin
              case FSubFunction of
               13 : Result := fn43_13;
               14 : Result := fn43_14;
              end;
            end;
  end
end;

procedure TBuilderMBRTUAswerPacket.SetFunctionNumber(const Value : TMBFunctionsEnum);
begin
  if Value = fnNon then raise Exception.Create(rsIllegalFunctionNumber);
  case Value of
   fn01..fn24 : FFunctionNum:=Byte(Value);
   fn43_13    : begin
                  FFunctionNum := 43;
                  FSubFunction := 13;
                end;
   fn43_14    : begin
                  FFunctionNum := 43;
                  FSubFunction := 14;
                end;
  end;
end;

end.


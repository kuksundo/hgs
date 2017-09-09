{ *********************************************************************** }
{                                                                         }
{ ValueUtils                                                              }
{                                                                         }
{ Copyright (c) 2008 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ValueUtils;

{$B-}
{$I Directives.inc}

interface

uses
  Windows, SysUtils, ValueTypes;

type
  TOperationType = (otAdd, otSubtract, otMultiply, otIntegerDivide, otFloatDivide);

procedure AssignByte(var Target: TValue; const Source: Byte);
procedure AssignShortint(var Target: TValue; const Source: Shortint);
procedure AssignWord(var Target: TValue; const Source: Word);
procedure AssignSmallint(var Target: TValue; const Source: Smallint);
procedure AssignLongword(var Target: TValue; const Source: Longword);
procedure AssignInteger(var Target: TValue; const Source: Integer);
procedure AssignPointer(var Target: TValue; const Source: Pointer);
procedure AssignInt64(var Target: TValue; const Source: Int64);
procedure AssignSingle(var Target: TValue; const Source: Single);
procedure AssignDouble(var Target: TValue; const Source: Double);

function AssignValue(var Target: TLiveValue; const Source: TValue): Boolean;

{$IFDEF DELPHI_2006}
function MakeValue(const Value: Byte): TValue; overload;
function MakeValue(const Value: Shortint): TValue; overload;
function MakeValue(const Value: Word): TValue; overload;
function MakeValue(const Value: Smallint): TValue; overload;
function MakeValue(const Value: Longword): TValue; overload;
function MakeValue(const Value: Integer): TValue; overload;
{$ENDIF}
function MakeValue(const Value: Int64): TValue; overload;
{$IFDEF DELPHI_2006}
function MakeValue(const Value: Single): TValue; overload;
{$ENDIF}
function MakeValue(const Value: Double): TValue; overload;
{$IFDEF DELPHI_2006}
function MakeValue(const Value: Extended): TValue; overload;
{$ENDIF}
function MakeValue(const Value: TLiveValue): TValue; overload;

function MakeLiveValue(var Value: Byte): TLiveValue; overload;
function MakeLiveValue(var Value: Shortint): TLiveValue; overload;
function MakeLiveValue(var Value: Word): TLiveValue; overload;
function MakeLiveValue(var Value: Smallint): TLiveValue; overload;
function MakeLiveValue(var Value: Longword): TLiveValue; overload;
function MakeLiveValue(var Value: Integer): TLiveValue; overload;
function MakeLiveValue(var Value: Int64): TLiveValue; overload;
function MakeLiveValue(var Value: Single): TLiveValue; overload;
function MakeLiveValue(var Value: Double): TLiveValue; overload;

function LessZero(const Value: TValue): Boolean;
function GetValueType(const Value: Int64): TValueType;
function TextToValue(const Text: string): TValue;
function TryTextToValue(const Source: string; var Target: TValue): Boolean;
function ValueToText(const Value: TValue): string;
function Convert(const Value: TValue; ValueType: TValueType): TValue;
function Operation(const AValue, BValue: TValue; OperationType: TOperationType): TValue;
function Negative(const Value: TValue): TValue;
function Positive(const Value: TValue): TValue;

implementation

uses
  ValueConsts;

procedure AssignByte(var Target: TValue; const Source: Byte);
begin
  Target.Unsigned8 := Source;
  Target.ValueType := vtByte;
end;

procedure AssignShortint(var Target: TValue; const Source: Shortint);
begin
  Target.Signed8 := Source;
  Target.ValueType := vtShortint;
end;

procedure AssignWord(var Target: TValue; const Source: Word);
begin
  Target.Unsigned16 := Source;
  Target.ValueType := vtWord;
end;

procedure AssignSmallint(var Target: TValue; const Source: Smallint);
begin
  Target.Signed16 := Source;
  Target.ValueType := vtSmallint;
end;

procedure AssignLongword(var Target: TValue; const Source: Longword);
begin
  Target.Unsigned32 := Source;
  Target.ValueType := vtLongword;
end;

procedure AssignInteger(var Target: TValue; const Source: Integer);
begin
  Target.Signed32 := Source;
  Target.ValueType := vtInteger;
end;

procedure AssignPointer(var Target: TValue; const Source: Pointer);
begin
  Target.Signed32 := Integer(Source);
  Target.ValueType := vtInteger;
end;

procedure AssignInt64(var Target: TValue; const Source: Int64);
begin
  Target.Signed64 := Source;
  Target.ValueType := vtInt64;
end;

procedure AssignSingle(var Target: TValue; const Source: Single);
begin
  Target.Float32 := Source;
  Target.ValueType := vtSingle;
end;

procedure AssignDouble(var Target: TValue; const Source: Double);
begin
  Target.Float64 := Source;
  Target.ValueType := vtDouble;
end;

function AssignValue(var Target: TLiveValue; const Source: TValue): Boolean;
begin
  Result := True;
  case Target.ValueType of
    vtByte: Target.Unsigned8^ := Convert(Source, vtByte).Unsigned8;
    vtShortint: Target.Signed8^ := Convert(Source, vtShortint).Signed8;
    vtWord: Target.Unsigned16^ := Convert(Source, vtWord).Unsigned16;
    vtSmallint: Target.Signed16^ := Convert(Source, vtSmallint).Signed16;
    vtLongword: Target.Unsigned32^ := Convert(Source, vtLongword).Unsigned32;
    vtInteger: Target.Signed32^ := Convert(Source, vtInteger).Signed32;
    vtInt64: Target.Signed64^ := Convert(Source, vtInt64).Signed64;
    vtSingle: Target.Float32^ := Convert(Source, vtSingle).Float32;
    vtDouble: Target.Float64^ := Convert(Source, vtDouble).Float64;
  else Result := False;
  end;
end;

{$IFDEF DELPHI_2006}

function MakeValue(const Value: Byte): TValue;
begin
  AssignByte(Result, Value);
end;

function MakeValue(const Value: Shortint): TValue;
begin
  AssignShortint(Result, Value);
end;

function MakeValue(const Value: Word): TValue;
begin
  AssignWord(Result, Value);
end;

function MakeValue(const Value: Smallint): TValue;
begin
  AssignSmallint(Result, Value);
end;

function MakeValue(const Value: Longword): TValue;
begin
  AssignLongword(Result, Value);
end;

function MakeValue(const Value: Integer): TValue;
begin
  AssignInteger(Result, Value);
end;

{$ENDIF}

function MakeValue(const Value: Int64): TValue;
begin
  AssignInt64(Result, Value);
end;

{$IFDEF DELPHI_2006}

function MakeValue(const Value: Single): TValue;
begin
  AssignSingle(Result, Value);
end;

{$ENDIF}

function MakeValue(const Value: Double): TValue;
begin
  AssignDouble(Result, Value);
end;

{$IFDEF DELPHI_2006}

function MakeValue(const Value: Extended): TValue;
begin
  AssignDouble(Result, Value);
end;

{$ENDIF}

function MakeValue(const Value: TLiveValue): TValue;
begin
  case Value.ValueType of
    vtByte: Result := MakeValue(Value.Unsigned8^);
    vtShortint: Result := MakeValue(Value.Signed8^);
    vtWord: Result := MakeValue(Value.Unsigned16^);
    vtSmallint: Result := MakeValue(Value.Signed16^);
    vtLongword: Result := MakeValue(Value.Unsigned32^);
    vtInteger: Result := MakeValue(Value.Signed32^);
    vtInt64: Result := MakeValue(Value.Signed64^);
    vtSingle: Result := MakeValue(Value.Float32^);
    vtDouble: Result := MakeValue(Value.Float64^);
  else FillChar(Result, SizeOf(TValue), 0);
  end;
end;

function MakeLiveValue(var Value: Byte): TLiveValue;
begin
  Result.Unsigned8 := @Value;
  Result.ValueType := vtByte;
end;

function MakeLiveValue(var Value: Shortint): TLiveValue;
begin
  Result.Signed8 := @Value;
  Result.ValueType := vtShortint;
end;

function MakeLiveValue(var Value: Word): TLiveValue;
begin
  Result.Unsigned16 := @Value;
  Result.ValueType := vtWord;
end;

function MakeLiveValue(var Value: Smallint): TLiveValue;
begin
  Result.Signed16 := @Value;
  Result.ValueType := vtSmallint;
end;

function MakeLiveValue(var Value: Longword): TLiveValue;
begin
  Result.Unsigned32 := @Value;
  Result.ValueType := vtLongword;
end;

function MakeLiveValue(var Value: Integer): TLiveValue;
begin
  Result.Signed32 := @Value;
  Result.ValueType := vtInteger;
end;

function MakeLiveValue(var Value: Int64): TLiveValue;
begin
  Result.Signed64 := @Value;
  Result.ValueType := vtInt64;
end;

function MakeLiveValue(var Value: Single): TLiveValue;
begin
  Result.Float32 := @Value;
  Result.ValueType := vtSingle;
end;

function MakeLiveValue(var Value: Double): TLiveValue;
begin
  Result.Float64 := @Value;
  Result.ValueType := vtDouble;
end;

function LessZero(const Value: TValue): Boolean;
begin
  Result := not (Value.ValueType in UnsignedTypes);
  if Result then
    case Value.ValueType of
      vtShortint: Result := Value.Signed8 < 0;
      vtSmallint: Result := Value.Signed16 < 0;
      vtInteger: Result := Value.Signed32 < 0;
      vtInt64: Result := Value.Signed64 < 0;
      vtSingle: Result := Value.Float32 < 0;
      vtDouble: Result := Value.Float64 < 0;
    end;
end;

function GetValueType(const Value: Int64): TValueType;
begin
  if Value > 0 then
    if Value > High(Longword) then Result := vtInt64
    else if Value > High(Word) then Result := vtLongword
    else if Value > High(Byte) then Result := vtWord
    else Result := vtByte
  else
    if Value < - High(Integer) - 1 then Result := vtInt64
    else if Value < - High(Smallint) - 1 then Result := vtInteger
    else if Value < - High(Shortint) - 1 then Result := vtSmallint
    else Result := vtShortint;
end;

function TextToValue(const Text: string): TValue;
begin
  if TryStrToInt64(Text, Result.Signed64) then
  begin
    Result.ValueType := GetValueType(Result.Signed64);
    case Result.ValueType of
      vtByte: AssignByte(Result, Result.Signed64);
      vtShortint: AssignShortint(Result, Result.Signed64);
      vtWord: AssignWord(Result, Result.Signed64);
      vtSmallint: AssignSmallint(Result, Result.Signed64);
      vtLongword: AssignLongword(Result, Result.Signed64);
      vtInteger: AssignInteger(Result, Result.Signed64);
    end;
  end
  else if TryStrToFloat(Text, Result.Float64) then Result.ValueType := vtDouble
  else Result.ValueType := vtUnknown;
end;

function TryTextToValue(const Source: string; var Target: TValue): Boolean;
var
  Value: TValue;
begin
  Value := TextToValue(Source);
  Result := Value.ValueType <> vtUnknown;
  if Result then Target := Value;
end;

function ValueToText(const Value: TValue): string;
begin
  case Value.ValueType of
    vtByte: Result := IntToStr(Value.Unsigned8);
    vtShortint: Result := IntToStr(Value.Signed8);
    vtWord: Result := IntToStr(Value.Unsigned16);
    vtSmallint: Result := IntToStr(Value.Signed16);
    vtLongword: Result := IntToStr(Value.Unsigned32);
    vtInteger: Result := IntToStr(Value.Signed32);
    vtInt64: Result := IntToStr(Value.Signed64);
    vtSingle: Result := FloatToStr(Value.Float32);
    vtDouble: Result := FloatToStr(Value.Float64);
  end;
end;

function Convert(const Value: TValue; ValueType: TValueType): TValue;
begin
  Result := EmptyValue;
  case Value.ValueType of
    vtByte:
      case ValueType of
        vtByte: Result.Unsigned8 := Value.Unsigned8;
        vtShortint: Result.Signed8 := Value.Unsigned8;
        vtWord: Result.Unsigned16 := Value.Unsigned8;
        vtSmallint: Result.Signed16 := Value.Unsigned8;
        vtLongword: Result.Unsigned32 := Value.Unsigned8;
        vtInteger: Result.Signed32 := Value.Unsigned8;
        vtInt64: Result.Signed64 := Value.Unsigned8;
        vtSingle: Result.Float32 := Value.Unsigned8;
        vtDouble: Result.Float64 := Value.Unsigned8;
      end;
    vtShortint:
      case ValueType of
        vtByte: Result.Unsigned8 := Value.Signed8;
        vtShortint: Result.Signed8 := Value.Signed8;
        vtWord: Result.Unsigned16 := Value.Signed8;
        vtSmallint: Result.Signed16 := Value.Signed8;
        vtLongword: Result.Unsigned32 := Value.Signed8;
        vtInteger: Result.Signed32 := Value.Signed8;
        vtInt64: Result.Signed64 := Value.Signed8;
        vtSingle: Result.Float32 := Value.Signed8;
        vtDouble: Result.Float64 := Value.Signed8;
      end;
    vtWord:
      case ValueType of
        vtByte: Result.Unsigned8 := Value.Unsigned16;
        vtShortint: Result.Signed8 := Value.Unsigned16;
        vtWord: Result.Unsigned16 := Value.Unsigned16;
        vtSmallint: Result.Signed16 := Value.Unsigned16;
        vtLongword: Result.Unsigned32 := Value.Unsigned16;
        vtInteger: Result.Signed32 := Value.Unsigned16;
        vtInt64: Result.Signed64 := Value.Unsigned16;
        vtSingle: Result.Float32 := Value.Unsigned16;
        vtDouble: Result.Float64 := Value.Unsigned16;
      end;
    vtSmallint:
      case ValueType of
        vtByte: Result.Unsigned8 := Value.Signed16;
        vtShortint: Result.Signed8 := Value.Signed16;
        vtWord: Result.Unsigned16 := Value.Signed16;
        vtSmallint: Result.Signed16 := Value.Signed16;
        vtLongword: Result.Unsigned32 := Value.Signed16;
        vtInteger: Result.Signed32 := Value.Signed16;
        vtInt64: Result.Signed64 := Value.Signed16;
        vtSingle: Result.Float32 := Value.Signed16;
        vtDouble: Result.Float64 := Value.Signed16;
      end;
    vtLongword:
      case ValueType of
        vtByte: Result.Unsigned8 := Value.Unsigned32;
        vtShortint: Result.Signed8 := Value.Unsigned32;
        vtWord: Result.Unsigned16 := Value.Unsigned32;
        vtSmallint: Result.Signed16 := Value.Unsigned32;
        vtLongword: Result.Unsigned32 := Value.Unsigned32;
        vtInteger: Result.Signed32 := Value.Unsigned32;
        vtInt64: Result.Signed64 := Value.Unsigned32;
        vtSingle: Result.Float32 := Value.Unsigned32;
        vtDouble: Result.Float64 := Value.Unsigned32;
      end;
    vtInteger:
      case ValueType of
        vtByte: Result.Unsigned8 := Value.Signed32;
        vtShortint: Result.Signed8 := Value.Signed32;
        vtWord: Result.Unsigned16 := Value.Signed32;
        vtSmallint: Result.Signed16 := Value.Signed32;
        vtLongword: Result.Unsigned32 := Value.Signed32;
        vtInteger: Result.Signed32 := Value.Signed32;
        vtInt64: Result.Signed64 := Value.Signed32;
        vtSingle: Result.Float32 := Value.Signed32;
        vtDouble: Result.Float64 := Value.Signed32;
      end;
    vtInt64:
      case ValueType of
        vtByte: Result.Unsigned8 := Value.Signed64;
        vtShortint: Result.Signed8 := Value.Signed64;
        vtWord: Result.Unsigned16 := Value.Signed64;
        vtSmallint: Result.Signed16 := Value.Signed64;
        vtLongword: Result.Unsigned32 := Value.Signed64;
        vtInteger: Result.Signed32 := Value.Signed64;
        vtInt64: Result.Signed64 := Value.Signed64;
        vtSingle: Result.Float32 := Value.Signed64;
        vtDouble: Result.Float64 := Value.Signed64;
      end;
    vtSingle:
      case ValueType of
        vtByte: Result.Unsigned8 := Round(Value.Float32);
        vtShortint: Result.Signed8 := Round(Value.Float32);
        vtWord: Result.Unsigned16 := Round(Value.Float32);
        vtSmallint: Result.Signed16 := Round(Value.Float32);
        vtLongword: Result.Unsigned32 := Round(Value.Float32);
        vtInteger: Result.Signed32 := Round(Value.Float32);
        vtInt64: Result.Signed64 := Round(Value.Float32);
        vtSingle: Result.Float32 := Value.Float32;
        vtDouble: Result.Float64 := Value.Float32;
      end;
    vtDouble:
      case ValueType of
        vtByte: Result.Unsigned8 := Round(Value.Float64);
        vtShortint: Result.Signed8 := Round(Value.Float64);
        vtWord: Result.Unsigned16 := Round(Value.Float64);
        vtSmallint: Result.Signed16 := Round(Value.Float64);
        vtLongword: Result.Unsigned32 := Round(Value.Float64);
        vtInteger: Result.Signed32 := Round(Value.Float64);
        vtInt64: Result.Signed64 := Round(Value.Float64);
        vtSingle: Result.Float32 := Value.Float64;
        vtDouble: Result.Float64 := Value.Float64;
      end;
  end;
  Result.ValueType := ValueType;
end;

function Operation(const AValue, BValue: TValue; OperationType: TOperationType): TValue;
begin
  Result := EmptyValue;
  case OperationType of
    otAdd:
      case AValue.ValueType of
        vtByte:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Unsigned8 + BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Unsigned8 + BValue.Signed8);
            vtWord: AssignInteger(Result, AValue.Unsigned8 + BValue.Unsigned16);
            vtSmallint: AssignInteger(Result, AValue.Unsigned8 + BValue.Signed16);
            vtLongword: AssignInt64(Result, Int64(AValue.Unsigned8) + Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, Int64(AValue.Unsigned8) + Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Unsigned8) + BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned8 + BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned8 + BValue.Float64);
          end;
        vtShortint:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Signed8 + BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Signed8 + BValue.Signed8);
            vtWord: AssignInteger(Result, AValue.Signed8 + BValue.Unsigned16);
            vtSmallint: AssignInteger(Result, AValue.Signed8 + BValue.Signed16);
            vtLongword: AssignInt64(Result, Int64(AValue.Signed8) + Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Signed8) + Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Signed8) + BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed8 + BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed8 + BValue.Float64);
          end;
        vtWord:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Unsigned16 + BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Unsigned16 + BValue.Signed8);
            vtWord: AssignInteger(Result, AValue.Unsigned16 + BValue.Unsigned16);
            vtSmallint: AssignInteger(Result, AValue.Unsigned16 + BValue.Signed16);
            vtLongword: AssignInt64(Result, Int64(AValue.Unsigned16) + Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, Int64(AValue.Unsigned16) + Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Unsigned16) + BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned16 + BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned16 + BValue.Float64);
          end;
        vtSmallint:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Signed16 + BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Signed16 + BValue.Signed8);
            vtWord: AssignInteger(Result, AValue.Signed16 + BValue.Unsigned16);
            vtSmallint: AssignInteger(Result, AValue.Signed16 + BValue.Signed16);
            vtLongword: AssignInt64(Result, Int64(AValue.Signed16) + Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Signed16) + Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Signed16) + BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed16 + BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed16 + BValue.Float64);
          end;
        vtLongword:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, Int64(AValue.Unsigned32) + Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, Int64(AValue.Unsigned32) + Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, Int64(AValue.Unsigned32) + Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Unsigned32) + Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Unsigned32) + Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, Int64(AValue.Unsigned32) + Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Unsigned32) + BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned32 + BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned32 + BValue.Float64);
          end;
        vtInteger:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, Int64(AValue.Signed32) + Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, Int64(AValue.Signed32) + Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, Int64(AValue.Signed32) + Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Signed32) + Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Signed32) + Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Signed32) + Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Signed32) + BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed32 + BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed32 + BValue.Float64);
          end;
        vtInt64:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, AValue.Signed64 + Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, AValue.Signed64 + Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, AValue.Signed64 + Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, AValue.Signed64 + Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, AValue.Signed64 + Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, AValue.Signed64 + Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, AValue.Signed64 + BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed64 + BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed64 + BValue.Float64);
          end;
        vtSingle:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Float32 + BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Float32 + BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Float32 + BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Float32 + BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Float32 + BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Float32 + BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Float32 + BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Float32 + BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Float32 + BValue.Float64);
          end;
        vtDouble:
          begin
            case BValue.ValueType of
              vtByte: Result.Float64 := AValue.Float64 + BValue.Unsigned8;
              vtShortint: Result.Float64 := AValue.Float64 + BValue.Signed8;
              vtWord: Result.Float64 := AValue.Float64 + BValue.Unsigned16;
              vtSmallint: Result.Float64 := AValue.Float64 + BValue.Signed16;
              vtLongword: Result.Float64 := AValue.Float64 + BValue.Unsigned32;
              vtInteger: Result.Float64 := AValue.Float64 + BValue.Signed32;
              vtInt64: Result.Float64 := AValue.Float64 + BValue.Signed64;
              vtSingle: Result.Float64 := AValue.Float64 + BValue.Float32;
              vtDouble: Result.Float64 := AValue.Float64 + BValue.Float64;
            end;
            Result.ValueType := vtDouble;
          end;
      end;
    otSubtract:
      case AValue.ValueType of
        vtByte:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Unsigned8 - BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Unsigned8 - BValue.Signed8);
            vtWord: AssignInteger(Result, AValue.Unsigned8 - BValue.Unsigned16);
            vtSmallint: AssignInteger(Result, AValue.Unsigned8 - BValue.Signed16);
            vtLongword: AssignInt64(Result, Int64(AValue.Unsigned8) - Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, Int64(AValue.Unsigned8) - Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Unsigned8) - BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned8 - BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned8 - BValue.Float64);
          end;
        vtShortint:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Signed8 - BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Signed8 - BValue.Signed8);
            vtWord: AssignInteger(Result, AValue.Signed8 - BValue.Unsigned16);
            vtSmallint: AssignInteger(Result, AValue.Signed8 - BValue.Signed16);
            vtLongword: AssignInt64(Result, Int64(AValue.Signed8) - Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Signed8) - Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Signed8) - BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed8 - BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed8 - BValue.Float64);
          end;
        vtWord:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Unsigned16 - BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Unsigned16 - BValue.Signed8);
            vtWord: AssignInteger(Result, AValue.Unsigned16 - BValue.Unsigned16);
            vtSmallint: AssignInteger(Result, AValue.Unsigned16 - BValue.Signed16);
            vtLongword: AssignInt64(Result, Int64(AValue.Unsigned16) - Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, Int64(AValue.Unsigned16) - Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Unsigned16) - BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned16 - BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned16 - BValue.Float64);
          end;
        vtSmallint:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Signed16 - BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Signed16 - BValue.Signed8);
            vtWord: AssignInteger(Result, AValue.Signed16 - BValue.Unsigned16);
            vtSmallint: AssignInteger(Result, AValue.Signed16 - BValue.Signed16);
            vtLongword: AssignInt64(Result, Int64(AValue.Signed16) - Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Signed16) - Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Signed16) - BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed16 - BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed16 - BValue.Float64);
          end;
        vtLongword:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, Int64(AValue.Unsigned32) - Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, Int64(AValue.Unsigned32) - Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, Int64(AValue.Unsigned32) - Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Unsigned32) - Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Unsigned32) - Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, Int64(AValue.Unsigned32) - Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Unsigned32) - BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned32 - BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned32 - BValue.Float64);
          end;
        vtInteger:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, Int64(AValue.Signed32) - Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, Int64(AValue.Signed32) - Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, Int64(AValue.Signed32) - Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Signed32) - Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Signed32) - Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Signed32) - Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Signed32) - BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed32 - BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed32 - BValue.Float64);
          end;
        vtInt64:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, AValue.Signed64 - Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, AValue.Signed64 - Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, AValue.Signed64 - Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, AValue.Signed64 - Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, AValue.Signed64 - Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, AValue.Signed64 - Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, AValue.Signed64 - BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed64 - BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed64 - BValue.Float64);
          end;
        vtSingle:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Float32 - BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Float32 - BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Float32 - BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Float32 - BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Float32 - BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Float32 - BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Float32 - BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Float32 - BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Float32 - BValue.Float64);
          end;
        vtDouble:
          begin
            case BValue.ValueType of
              vtByte: Result.Float64 := AValue.Float64 - BValue.Unsigned8;
              vtShortint: Result.Float64 := AValue.Float64 - BValue.Signed8;
              vtWord: Result.Float64 := AValue.Float64 - BValue.Unsigned16;
              vtSmallint: Result.Float64 := AValue.Float64 - BValue.Signed16;
              vtLongword: Result.Float64 := AValue.Float64 - BValue.Unsigned32;
              vtInteger: Result.Float64 := AValue.Float64 - BValue.Signed32;
              vtInt64: Result.Float64 := AValue.Float64 - BValue.Signed64;
              vtSingle: Result.Float64 := AValue.Float64 - BValue.Float32;
              vtDouble: Result.Float64 := AValue.Float64 - BValue.Float64;
            end;
            Result.ValueType := vtDouble;
          end;
      end;
    otMultiply:
      case AValue.ValueType of
        vtByte:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Unsigned8 * BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Unsigned8 * BValue.Signed8);
            vtWord: AssignInt64(Result, Int64(AValue.Unsigned8) * Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Unsigned8) * Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Unsigned8) * Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, Int64(AValue.Unsigned8) * Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Unsigned8) * BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned8 * BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned8 * BValue.Float64);
          end;
        vtShortint:
          case BValue.ValueType of
            vtByte: AssignInteger(Result, AValue.Signed8 * BValue.Unsigned8);
            vtShortint: AssignInteger(Result, AValue.Signed8 * BValue.Signed8);
            vtWord: AssignInt64(Result, Int64(AValue.Signed8) * Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Signed8) * Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Signed8) * Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Signed8) * Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Signed8) * BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed8 * BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed8 * BValue.Float64);
          end;
        vtWord:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, Int64(AValue.Unsigned16) * Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, Int64(AValue.Unsigned16) * Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, Int64(AValue.Unsigned16) * Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Unsigned16) * Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Unsigned16) * Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, Int64(AValue.Unsigned16) * Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Unsigned16) * BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned16 * BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned16 * BValue.Float64);
          end;
        vtSmallint:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, Int64(AValue.Signed16) * Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, Int64(AValue.Signed16) * Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, Int64(AValue.Signed16) * Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Signed16) * Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Signed16) * Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Signed16) * Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Signed16) * BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed16 * BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed16 * BValue.Float64);
          end;
        vtLongword:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, Int64(AValue.Unsigned32) * Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, Int64(AValue.Unsigned32) * Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, Int64(AValue.Unsigned32) * Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Unsigned32) * Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Unsigned32) * Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Unsigned32) * Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Unsigned32) * BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned32 * BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned32 * BValue.Float64);
          end;
        vtInteger:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, Int64(AValue.Signed32) * Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, Int64(AValue.Signed32) * Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, Int64(AValue.Signed32) * Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, Int64(AValue.Signed32) * Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, Int64(AValue.Signed32) * Int64(Int64(BValue.Unsigned32)));
            vtInteger: AssignInt64(Result, Int64(AValue.Signed32) * Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, Int64(AValue.Signed32) * BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed32 * BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed32 * BValue.Float64);
          end;
        vtInt64:
          case BValue.ValueType of
            vtByte: AssignInt64(Result, AValue.Signed64 * Int64(BValue.Unsigned8));
            vtShortint: AssignInt64(Result, AValue.Signed64 * Int64(BValue.Signed8));
            vtWord: AssignInt64(Result, AValue.Signed64 * Int64(BValue.Unsigned16));
            vtSmallint: AssignInt64(Result, AValue.Signed64 * Int64(BValue.Signed16));
            vtLongword: AssignInt64(Result, AValue.Signed64 * Int64(BValue.Unsigned32));
            vtInteger: AssignInt64(Result, AValue.Signed64 * Int64(BValue.Signed32));
            vtInt64: AssignInt64(Result, AValue.Signed64 * BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed64 * BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed64 * BValue.Float64);
          end;
        vtSingle:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Float32 * BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Float32 * BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Float32 * BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Float32 * BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Float32 * BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Float32 * BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Float32 * BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Float32 * BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Float32 * BValue.Float64);
          end;
        vtDouble:
          begin
            case BValue.ValueType of
              vtByte: Result.Float64 := AValue.Float64 * BValue.Unsigned8;
              vtShortint: Result.Float64 := AValue.Float64 * BValue.Signed8;
              vtWord: Result.Float64 := AValue.Float64 * BValue.Unsigned16;
              vtSmallint: Result.Float64 := AValue.Float64 * BValue.Signed16;
              vtLongword: Result.Float64 := AValue.Float64 * BValue.Unsigned32;
              vtInteger: Result.Float64 := AValue.Float64 * BValue.Signed32;
              vtInt64: Result.Float64 := AValue.Float64 * BValue.Signed64;
              vtSingle: Result.Float64 := AValue.Float64 * BValue.Float32;
              vtDouble: Result.Float64 := AValue.Float64 * BValue.Float64;
            end;
            Result.ValueType := vtDouble;
          end;
      end;
    otIntegerDivide:
      case AValue.ValueType of
        vtByte:
          begin
            case BValue.ValueType of
              vtByte: Result.Signed32 := AValue.Unsigned8 div BValue.Unsigned8;
              vtShortint: Result.Signed32 := AValue.Unsigned8 div BValue.Signed8;
              vtWord: Result.Signed32 := AValue.Unsigned8 div BValue.Unsigned16;
              vtSmallint: Result.Signed32:= AValue.Unsigned8 div BValue.Signed16;
              vtLongword: Result.Signed32 := AValue.Unsigned8 div BValue.Unsigned32;
              vtInteger: Result.Signed32 := AValue.Unsigned8 div BValue.Signed32;
              vtInt64: Result.Signed32 := AValue.Unsigned8 div BValue.Signed64;
              vtSingle: Result.Signed32 := AValue.Unsigned8 div Round(BValue.Float32);
              vtDouble: Result.Signed32 := AValue.Unsigned8 div Round(BValue.Float64);
            end;
            Result.ValueType := vtInteger;
          end;
        vtShortint:
          begin
            case BValue.ValueType of
              vtByte: Result.Signed32 := AValue.Signed8 div BValue.Unsigned8;
              vtShortint: Result.Signed32 := AValue.Signed8 div BValue.Signed8;
              vtWord: Result.Signed32 := AValue.Signed8 div BValue.Unsigned16;
              vtSmallint: Result.Signed32 := AValue.Signed8 div BValue.Signed16;
              vtLongword: Result.Signed32 := AValue.Signed8 div Int64(BValue.Unsigned32);
              vtInteger: Result.Signed32 := AValue.Signed8 div BValue.Signed32;
              vtInt64: Result.Signed32 := AValue.Signed8 div BValue.Signed64;
              vtSingle: Result.Signed32 := AValue.Signed8 div Round(BValue.Float32);
              vtDouble: Result.Signed32 := AValue.Signed8 div Round(BValue.Float64);
            end;
            Result.ValueType := vtInteger;
          end;
        vtWord:
          begin
            case BValue.ValueType of
              vtByte: Result.Signed32 := AValue.Unsigned16 div BValue.Unsigned8;
              vtShortint: Result.Signed32 := AValue.Unsigned16 div BValue.Signed8;
              vtWord: Result.Signed32 := AValue.Unsigned16 div BValue.Unsigned16;
              vtSmallint: Result.Signed32 := AValue.Unsigned16 div BValue.Signed16;
              vtLongword: Result.Signed32 := AValue.Unsigned16 div BValue.Unsigned32;
              vtInteger: Result.Signed32 := AValue.Unsigned16 div BValue.Signed32;
              vtInt64: Result.Signed32 := AValue.Unsigned16 div BValue.Signed64;
              vtSingle: Result.Signed32 := AValue.Unsigned16 div Round(BValue.Float32);
              vtDouble: Result.Signed32 := AValue.Unsigned16 div Round(BValue.Float64);
            end;
            Result.ValueType := vtInteger;
          end;
        vtSmallint:
          begin
            case BValue.ValueType of
              vtByte: Result.Signed32 := AValue.Signed16 div BValue.Unsigned8;
              vtShortint: Result.Signed32 := AValue.Signed16 div BValue.Signed8;
              vtWord: Result.Signed32 := AValue.Signed16 div BValue.Unsigned16;
              vtSmallint: Result.Signed32 := AValue.Signed16 div BValue.Signed16;
              vtLongword: Result.Signed32 := AValue.Signed16 div Int64(BValue.Unsigned32);
              vtInteger: Result.Signed32 := AValue.Signed16 div BValue.Signed32;
              vtInt64: Result.Signed32 := AValue.Signed16 div BValue.Signed64;
              vtSingle: Result.Signed32 := AValue.Signed16 div Round(BValue.Float32);
              vtDouble: Result.Signed32 := AValue.Signed16 div Round(BValue.Float64);
            end;
            Result.ValueType := vtInteger;
          end;
        vtLongword:
          begin
            case BValue.ValueType of
              vtByte: Result.Signed64 := AValue.Unsigned32 div BValue.Unsigned8;
              vtShortint: Result.Signed64 := Int64(AValue.Unsigned32) div BValue.Signed8;
              vtWord: Result.Signed64 := AValue.Unsigned32 div BValue.Unsigned16;
              vtSmallint: Result.Signed64:= Int64(AValue.Unsigned32) div BValue.Signed16;
              vtLongword: Result.Signed64 := AValue.Unsigned32 div BValue.Unsigned32;
              vtInteger: Result.Signed64 := Int64(AValue.Unsigned32) div BValue.Signed32;
              vtInt64: Result.Signed64 := AValue.Unsigned32 div BValue.Signed64;
              vtSingle: Result.Signed64 := AValue.Unsigned32 div Round(BValue.Float32);
              vtDouble: Result.Signed64 := AValue.Unsigned32 div Round(BValue.Float64);
            end;
            Result.ValueType := vtInt64;
          end;
        vtInteger:
          begin
            case BValue.ValueType of
              vtByte: Result.Signed64 := AValue.Signed32 div BValue.Unsigned8;
              vtShortint: Result.Signed64 := AValue.Signed32 div BValue.Signed8;
              vtWord: Result.Signed64 := AValue.Signed32 div BValue.Unsigned16;
              vtSmallint: Result.Signed64:= AValue.Signed32 div BValue.Signed16;
              vtLongword: Result.Signed64 := AValue.Signed32 div Int64(BValue.Unsigned32);
              vtInteger: Result.Signed64 := AValue.Signed32 div BValue.Signed32;
              vtInt64: Result.Signed64 := AValue.Signed32 div BValue.Signed64;
              vtSingle: Result.Signed64 := AValue.Signed32 div Round(BValue.Float32);
              vtDouble: Result.Signed64 := AValue.Signed32 div Round(BValue.Float64);
            end;
            Result.ValueType := vtInt64;
          end;
        vtInt64:
          begin
            case BValue.ValueType of
              vtByte: Result.Signed64 := AValue.Signed64 div BValue.Unsigned8;
              vtShortint: Result.Signed64 := AValue.Signed64 div BValue.Signed8;
              vtWord: Result.Signed64 := AValue.Signed64 div BValue.Unsigned16;
              vtSmallint: Result.Signed64:= AValue.Signed64 div BValue.Signed16;
              vtLongword: Result.Signed64 := AValue.Signed64 div BValue.Unsigned32;
              vtInteger: Result.Signed64 := AValue.Signed64 div BValue.Signed32;
              vtInt64: Result.Signed64 := AValue.Signed64 div BValue.Signed64;
              vtSingle: Result.Signed64 := AValue.Signed64 div Round(BValue.Float32);
              vtDouble: Result.Signed64 := AValue.Signed64 div Round(BValue.Float64);
            end;
            Result.ValueType := vtInt64;
          end;
        vtSingle:
          begin
            case BValue.ValueType of
              vtByte: Result.Signed64 := Round(AValue.Float32) div BValue.Unsigned8;
              vtShortint: Result.Signed64 := Round(AValue.Float32) div BValue.Signed8;
              vtWord: Result.Signed64 := Round(AValue.Float32) div BValue.Unsigned16;
              vtSmallint: Result.Signed64:= Round(AValue.Float32) div BValue.Signed16;
              vtLongword: Result.Signed64 := Round(AValue.Float32) div BValue.Unsigned32;
              vtInteger: Result.Signed64 := Round(AValue.Float32) div BValue.Signed32;
              vtInt64: Result.Signed64 := Round(AValue.Float32) div BValue.Signed64;
              vtSingle: Result.Signed64 := Round(AValue.Float32) div Round(BValue.Float32);
              vtDouble: Result.Signed64 := Round(AValue.Float32) div Round(BValue.Float64);
            end;
            Result.ValueType := vtInt64;
          end;
        vtDouble:
          begin
            case BValue.ValueType of
              vtByte: Result.Signed64 := Round(AValue.Float64) div BValue.Unsigned8;
              vtShortint: Result.Signed64 := Round(AValue.Float64) div BValue.Signed8;
              vtWord: Result.Signed64 := Round(AValue.Float64) div BValue.Unsigned16;
              vtSmallint: Result.Signed64:= Round(AValue.Float64) div BValue.Signed16;
              vtLongword: Result.Signed64 := Round(AValue.Float64) div BValue.Unsigned32;
              vtInteger: Result.Signed64 := Round(AValue.Float64) div BValue.Signed32;
              vtInt64: Result.Signed64 := Round(AValue.Float64) div BValue.Signed64;
              vtSingle: Result.Signed64 := Round(AValue.Float64) div Round(BValue.Float32);
              vtDouble: Result.Signed64 := Round(AValue.Float64) div Round(BValue.Float64);
            end;
            Result.ValueType := vtInt64;
          end;
      end;
    otFloatDivide:
      case AValue.ValueType of
        vtByte:
          begin
            case BValue.ValueType of
              vtByte: AssignSingle(Result, AValue.Unsigned8 / BValue.Unsigned8);
              vtShortint: AssignSingle(Result, AValue.Unsigned8 / BValue.Signed8);
              vtWord: AssignSingle(Result, AValue.Unsigned8 / BValue.Unsigned16);
              vtSmallint: AssignSingle(Result, AValue.Unsigned8 / BValue.Signed16);
              vtLongword: AssignSingle(Result, AValue.Unsigned8 / BValue.Unsigned32);
              vtInteger: AssignSingle(Result, AValue.Unsigned8 / BValue.Signed32);
              vtInt64: AssignSingle(Result, AValue.Unsigned8 / BValue.Signed64);
              vtSingle: AssignSingle(Result, AValue.Unsigned8 / BValue.Float32);
              vtDouble: AssignDouble(Result, AValue.Unsigned8 / BValue.Float64);
            end;
          end;
        vtShortint:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Signed8 / BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Signed8 / BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Signed8 / BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Signed8 / BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Signed8 / BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Signed8 / BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Signed8 / BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed8 / BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed8 / BValue.Float64);
          end;
        vtWord:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Unsigned16 / BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Unsigned16 / BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Unsigned16 / BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Unsigned16 / BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Unsigned16 / BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Unsigned16 / BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Unsigned16 / BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned16 / BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned16 / BValue.Float64);
          end;
        vtSmallint:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Signed16 / BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Signed16 / BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Signed16 / BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Signed16 / BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Signed16 / BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Signed16 / BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Signed16 / BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed16 / BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed16 / BValue.Float64);
          end;
        vtLongword:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Unsigned32 / BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Unsigned32 / BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Unsigned32 / BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Unsigned32 / BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Unsigned32 / BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Unsigned32 / BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Unsigned32 / BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Unsigned32 / BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Unsigned32 / BValue.Float64);
          end;
        vtInteger:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Signed32 / BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Signed32 / BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Signed32 / BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Signed32 / BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Signed32 / BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Signed32 / BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Signed32 / BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed32 / BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed32 / BValue.Float64);
          end;
        vtInt64:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Signed64 / BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Signed64 / BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Signed64 / BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Signed64 / BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Signed64 / BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Signed64 / BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Signed64 / BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Signed64 / BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Signed64 / BValue.Float64);
          end;
        vtSingle:
          case BValue.ValueType of
            vtByte: AssignSingle(Result, AValue.Float32 / BValue.Unsigned8);
            vtShortint: AssignSingle(Result, AValue.Float32 / BValue.Signed8);
            vtWord: AssignSingle(Result, AValue.Float32 / BValue.Unsigned16);
            vtSmallint: AssignSingle(Result, AValue.Float32 / BValue.Signed16);
            vtLongword: AssignSingle(Result, AValue.Float32 / BValue.Unsigned32);
            vtInteger: AssignSingle(Result, AValue.Float32 / BValue.Signed32);
            vtInt64: AssignSingle(Result, AValue.Float32 / BValue.Signed64);
            vtSingle: AssignSingle(Result, AValue.Float32 / BValue.Float32);
            vtDouble: AssignDouble(Result, AValue.Float32 / BValue.Float64);
          end;
        vtDouble:
          begin
            case BValue.ValueType of
              vtByte: Result.Float64 := AValue.Float64 / BValue.Unsigned8;
              vtShortint: Result.Float64 := AValue.Float64 / BValue.Signed8;
              vtWord: Result.Float64 := AValue.Float64 / BValue.Unsigned16;
              vtSmallint: Result.Float64:= AValue.Float64 / BValue.Signed16;
              vtLongword: Result.Float64 := AValue.Float64 / BValue.Unsigned32;
              vtInteger: Result.Float64 := AValue.Float64 / BValue.Signed32;
              vtInt64: Result.Float64 := AValue.Float64 / BValue.Signed64;
              vtSingle: Result.Float64 := AValue.Float64 / BValue.Float32;
              vtDouble: Result.Float64 := AValue.Float64 / BValue.Float64;
            end;
            Result.ValueType := vtDouble;
          end;
      end;
  end;
end;

function Negative(const Value: TValue): TValue;
begin
  case Value.ValueType of
    vtByte: AssignSmallint(Result, - Value.Unsigned8);
    vtShortint: AssignSmallint(Result, - Value.Signed8);
    vtWord: AssignInteger(Result, - Value.Unsigned16);
    vtSmallint: AssignInteger(Result, - Value.Signed16);
    vtLongword: AssignInt64(Result, - Int64(Value.Unsigned32));
    vtInteger: AssignInt64(Result, - Int64(Value.Signed32));
    vtInt64: AssignInt64(Result, - Value.Signed64);
    vtSingle: AssignDouble(Result, - Value.Float32);
    vtDouble: AssignDouble(Result, - Value.Float64);
  end;
end;

function Positive(const Value: TValue): TValue;
begin
  if Value.ValueType in UnsignedTypes then Result := Value
  else
    case Value.ValueType of
      vtShortint:
        if Value.Signed8 < 0 then AssignSmallint(Result, - Value.Signed8)
        else Result := Value;
      vtSmallint:
        if Value.Signed16 < 0 then AssignInteger(Result, - Value.Signed16)
        else Result := Value;
      vtInteger:
        if Value.Signed32 < 0 then AssignInt64(Result, - Int64(Value.Signed32))
        else Result := Value;
      vtInt64:
        if Value.Signed64 < 0 then AssignInt64(Result, - Value.Signed64)
        else Result := Value;
      vtSingle: AssignDouble(Result, Abs(Value.Float32));
      vtDouble: AssignDouble(Result, Abs(Value.Float64));
    end;
end;

end.

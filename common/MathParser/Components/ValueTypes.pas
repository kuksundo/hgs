{ *********************************************************************** }
{                                                                         }
{ ValueTypes                                                              }
{                                                                         }
{ Copyright (c) 2008 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ValueTypes;

{$B-}

interface

uses
  SysUtils;

type
  PValueType = ^TValueType;
  TValueType = (vtUnknown, vtByte, vtShortint, vtWord, vtSmallint, vtLongword,
    vtInteger, vtInt64, vtSingle, vtDouble);

  PValue = ^TValue;
  TValue = record
    ValueType: TValueType;
    case Byte of
      0: (ByteArray: array[0..7] of Byte);
      1: (Unsigned8: Byte);
      2: (Signed8: Shortint);
      3: (Unsigned16: Word);
      4: (Signed16: Smallint);
      5: (Unsigned32: Longword);
      6: (Signed32: Integer);
      7: (Signed64: Int64);
      8: (Float32: Single);
      9: (Float64: Double);
      10: (WordRec: WordRec);
      11: (LongRec: LongRec);
      12: (Int64Rec: Int64Rec);
  end;

  PValueArray = ^TValueArray;
  TValueArray = array of TValue;

  PLiveValue = ^TLiveValue;
  TLiveValue = record
    ValueType: TValueType;
    case Byte of
      1: (Unsigned8: PByte);
      2: (Signed8: PShortint);
      3: (Unsigned16: PWord);
      4: (Signed16: PSmallint);
      5: (Unsigned32: PLongword);
      6: (Signed32: PInteger);
      7: (Signed64: PInt64);
      8: (Float32: PSingle);
      9: (Float64: PDouble);
  end;

const
  FloatTypes = [vtSingle, vtDouble];
  IntegerTypes = [vtByte, vtShortint, vtWord, vtSmallint, vtLongword, vtInteger, vtInt64];
  SignedTypes = [vtShortint, vtSmallint, vtInteger, vtInt64, vtSingle, vtDouble];
  UnsignedTypes = [vtByte, vtWord, vtLongword];

function Add(var Target: TValueArray; const Value: TValue): Integer;
function Delete(var Target: TValueArray; const Index: Integer): Boolean;

function Next(ValueType: TValueType): TValueType;
function Assignable(Source, Target: TValueType): Boolean;

implementation

uses
  MemoryUtils;

function Add(var Target: TValueArray; const Value: TValue): Integer;
begin
  Result := Length(Target);
  SetLength(Target, Result + 1);
  MemoryUtils.Add(Target, @Value, Result * SizeOf(TValue), SizeOf(TValue));
end;

function Delete(var Target: TValueArray; const Index: Integer): Boolean;
var
  Size: Integer;
begin
  Size := Length(Target);
  Result := MemoryUtils.Delete(Target, Index * SizeOf(TValue), SizeOf(TValue),
    Size * SizeOf(TValue));
  if Result then SetLength(Target, Size - 1);
end;

function Next(ValueType: TValueType): TValueType;
begin
  case ValueType of
    vtByte: Result := vtWord;
    vtShortint: Result := vtSmallint;
    vtWord: Result := vtLongword;
    vtSmallint: Result := vtInteger;
    vtLongword, vtInteger: Result := vtInt64;
    vtSingle: Result := vtDouble;
  else Result := ValueType;
  end;
end;

function Assignable(Source, Target: TValueType): Boolean;
begin
  case Source of
    vtShortint, vtSmallint, vtInteger, vtInt64, vtSingle, vtDouble:
      Result := Target in [Source..High(TValueType)];
    vtByte, vtWord, vtLongword:
      Result := Target in [Source, Next(Source)..High(TValueType)];
  else Result := False;
  end;
end;

end.

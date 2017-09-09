{ *********************************************************************** }
{                                                                         }
{ NumberUtils                                                             }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit NumberUtils;

{$B-}
{$I Directives.inc}

interface

uses
  SysUtils, SysConst, Classes;

type
  TBitManager = class(TBits)
  public
    procedure Open(const Value: Int64); overload; virtual;
    procedure Open(const Value: Integer); overload; virtual;
    procedure Open(const Value: Byte); overload; virtual;
  end;

function GetHashCode(const Value: string): Longword;
function IntegerToBinary(const Value: Integer): string;
function BinaryToInteger(const Value: string): Integer;

function Equal(const AValue, BValue: Extended; AEpsilon: Extended = 0): Boolean;
function Greater(const AValue, BValue: Extended; AEpsilon: Extended = 0): Boolean;
function GreaterOrEqual(const AValue, BValue: Extended; AEpsilon: Extended = 0): Boolean;
function Less(const AValue, BValue: Extended; AEpsilon: Extended = 0): Boolean;
function LessOrEqual(const AValue, BValue: Extended; AEpsilon: Extended = 0): Boolean;
function Positive(const Value: Integer): Integer;

var
  BitManager: TBitManager;
  Epsilon: Extended = 0;

implementation

uses
  Math, NumberConsts{$IFNDEF UNICODE}, TextUtils{$ENDIF}, Types;

function GetHashCode(const Value: string): Longword;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(Value) do
    Result := ((Result shl 2) or (Result shr (SizeOf(Result) * 8 - 2))) xor Ord(Value[I]);
end;

function IntegerToBinary(const Value: Integer): string;
var
  I: Integer;
begin
  with BitManager do
  begin
    Open(Value);
    SetLength(Result, Size);
    for I := 0 to Size - 1 do
      if Bits[I] then Result[Size - I] := NumberChar[ntOne]
      else Result[Size - I] := NumberChar[ntZero];
  end;
end;

function BinaryToInteger(const Value: string): Integer;
var
  I: Integer;
begin
  with BitManager do
  begin
    Size := Length(Value);
    for I := 0 to Size - 1 do
    begin
      if not CharInSet(Value[Size - I], [NumberChar[ntZero], NumberChar[ntOne]]) then
        raise EConvertError.CreateResFmt(@SInvalidInteger, [Value]);
      Bits[I] := Value[Size - I] = NumberChar[ntOne]
    end;
    Result := OpenBit;
  end;
end;

function Equal(const AValue, BValue: Extended; AEpsilon: Extended): Boolean;
begin
  if AEpsilon = 0 then AEpsilon := Epsilon;  
  Result := SameValue(AValue, BValue, AEpsilon);
end;

function Greater(const AValue, BValue: Extended; AEpsilon: Extended): Boolean;
begin
  if AEpsilon = 0 then AEpsilon := Epsilon;  
  Result := CompareValue(AValue, BValue, AEpsilon) = GreaterThanValue;
end;

function GreaterOrEqual(const AValue, BValue: Extended; AEpsilon: Extended): Boolean;
begin
  if AEpsilon = 0 then AEpsilon := Epsilon;  
  Result := CompareValue(AValue, BValue, AEpsilon) <> LessThanValue;
end;

function Less(const AValue, BValue: Extended; AEpsilon: Extended): Boolean;
begin
  if AEpsilon = 0 then AEpsilon := Epsilon;  
  Result := CompareValue(AValue, BValue, AEpsilon) = LessThanValue;
end;

function LessOrEqual(const AValue, BValue: Extended; AEpsilon: Extended): Boolean;
begin
  if AEpsilon = 0 then AEpsilon := Epsilon;  
  Result := CompareValue(AValue, BValue, AEpsilon) <> GreaterThanValue;
end;

{ TBitManager }

procedure TBitManager.Open(const Value: Int64);
var
  I: Integer;
begin
  Size := SizeOf(Value);
  for I := 0 to Size - 1 do
    Bits[I] := (Value and Trunc(IntPower(Two, I))) = One;
end;

procedure TBitManager.Open(const Value: Integer);
var
  I: Integer;
begin
  Size := SizeOf(Value);
  for I := 0 to Size - 1 do
    Bits[I] := (Value and Trunc(IntPower(Two, I))) = One;
end;

procedure TBitManager.Open(const Value: Byte);
var
  I: Integer;
begin
  Size := SizeOf(Value);
  for I := 0 to Size - 1 do
    Bits[I] := (Value and Trunc(IntPower(Two, I))) = One;
end;

function Positive(const Value: Integer): Integer;
begin
  if Value < 0 then Result := - Value
  else Result := Value;
end;

initialization
  BitManager := TBitManager.Create;

finalization
  BitManager.Free;

end.

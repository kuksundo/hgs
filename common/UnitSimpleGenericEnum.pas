unit UnitSimpleGenericEnum;

interface
uses SysUtils,TypInfo;
type
  TEnumGeneric<T> = record
  type
    EEnum= class(Exception)
      constructor CreateFmt(const Test: String; const Args: array of Const);
    end;
  public
    Value:T;
    class var _TypeData: pTypeData;
    class function High: T; static;
    class function Low: T; static;
    class function GetTypeData: pTypeData; inline; static;{Inline working is a wish really}
    class function GetTypeInfo: PTypeInfo; inline; static;
    class operator Implicit(aValue: Integer): TEnumGeneric<T>;
    class operator Implicit(aValue: TEnumGeneric<T>): Integer;
    class operator Implicit(aValue: T): TEnumGeneric<T>;
    class operator Implicit(aValue: TEnumGeneric<T>): T;
    class operator Implicit(const aValue: String): TEnumGeneric<T>;
    class operator Implicit(aValue: TEnumGeneric<T>): String;
    class function GetEnumValue(const Name: String): Integer; inline; static;
    class function GetEnumName(Index: Integer): String; overload; inline; static;
    class function GetEnumName(Index: T): String; overload;inline; static;
    class function Ord(Value:T): Integer; inline; static;{Inline working is a wish really}
    class function Cast(Value:Integer): T; inline; static; {Inline working is a wish really}
    class function IsEnumeration: Boolean; inline; static;
    class function IsSet: Boolean; inline; static;
    class function InRange(Value: integer): Boolean; inline; static;
    class function EnsureRange(Value: integer): integer; inline; static;
    class function Count: integer; inline; static;
    function ToString: String;
    function StringTo(const AValue: String): Boolean;
  public
    // These function determine the default format of the strings
    // Currenlty they remove the lower case prefix and convert '_' to ' ' and vice verse
    class function EnumToStr(Value: T): String; static;
    class function StrToEnum(Name: String; out Value: T): Boolean; static;
  end;

implementation

uses Math;

{ TEnumGeneric<T> }

class operator TEnumGeneric<T>.Implicit(aValue: TEnumGeneric<T>): T;
begin
  Result := aValue.Value;
end;

class operator TEnumGeneric<T>.Implicit(aValue: T): TEnumGeneric<T>;
begin
  Result.Value := aValue;
end;

class operator TEnumGeneric<T>.Implicit(const aValue: String): TEnumGeneric<T>;
begin
  if not Result.StringTo(aValue) then
    raise EEnum.CreateFmt('"%s" is not a valid name',[aValue]);
end;

class function TEnumGeneric<T>.Cast(Value: Integer): T;
begin
  if (Value < GetTypeData.MinValue) then
    raise EEnum.CreateFmt('%d is below min value [%d]',[Value,GetTypeData.MinValue])
  else if (Value > GetTypeData.MaxValue) then
    raise EEnum.CreateFmt('%d is above max value [%d]',[Value,GetTypeData.MaxValue]);
  case Sizeof(T) of
    1: pByte(@Result)^ := Value;
    2: pWord(@Result)^ := Value;
    4: pCardinal(@Result)^ := Value;
  end;
end;

class function TEnumGeneric<T>.GetEnumName(Index: Integer): String;
begin
  Result := TypInfo.GetEnumName(TypeInfo(T),Index);
end;

class function TEnumGeneric<T>.GetEnumName(Index: T): String;
begin
  Result := GetEnumName(Ord(Index));
end;

class function TEnumGeneric<T>.GetEnumValue(const Name: String): Integer;
begin
  Result := TypInfo.GetEnumValue(TypeInfo(T),Name);
end;

class function TEnumGeneric<T>.GetTypeData: pTypeData;
begin
  if not Assigned(_TypeData) then
    _TypeData := TypInfo.GetTypeData(TypeInfo(T));
  Result := _TypeData;
end;

class function TEnumGeneric<T>.GetTypeInfo: PTypeInfo;
begin
  Result := System.TypeInfo(T);
end;

class function TEnumGeneric<T>.High: T;
begin
  Result := Cast(_TypeData.MaxValue);
end;

class operator TEnumGeneric<T>.Implicit(aValue: TEnumGeneric<T>): String;
begin
  Result := aValue.ToString;
end;

class function TEnumGeneric<T>.InRange(Value: integer): Boolean;
var
  ptd: PTypeData;
begin
  Assert(IsEnumeration);
  ptd := GetTypeData;
  Result := Math.InRange(Value, ptd.MinValue, ptd.MaxValue);
end;

class function TEnumGeneric<T>.IsEnumeration: Boolean;
begin
  Result := GetTypeInfo.Kind = tkEnumeration;
end;

class function TEnumGeneric<T>.IsSet: Boolean;
begin
  Result := GetTypeInfo.Kind = tkSet;
end;

class function TEnumGeneric<T>.Low: T;
begin
  Result := Cast(_TypeData.MinValue);
end;

class operator TEnumGeneric<T>.Implicit(aValue: Integer): TEnumGeneric<T>;
begin
  Result.Value := Cast(aValue);
end;

class operator TEnumGeneric<T>.Implicit(aValue: TEnumGeneric<T>): Integer;
begin
  Result := Ord(aValue.Value);
end;

class function TEnumGeneric<T>.Ord(Value: T): Integer;
begin
  case Sizeof(T) of
    1: Result := pByte(@Value)^;
    2: Result := pWord(@Value)^;
    4: Result := pCardinal(@Value)^;
  end;
end;

function TEnumGeneric<T>.StringTo(const AValue: String): Boolean;
begin
  Result := StrToEnum(AValue,Value);
end;

class function TEnumGeneric<T>.StrToEnum(Name: String; out Value: T): Boolean;
var
  Temp: String;
  Index: Integer;
begin
  Index := GetEnumValue(Name);
  if Index < 0 then begin
    Temp := GetEnumName(Ord(Low));
    Index := 0;
    while (Index < Length(Temp)) and (Temp[Index+1] in ['a'..'z']) do
      Inc(Index);
    SetLength(Temp,Index);
    Temp := Temp+Name;
    Index := 1;
    while (Index <= Length(Temp)) do begin
      if (Temp[Index] = ' ')  then
        Temp[Index] := '_';
      Inc(Index);
    end;
    Index := GetEnumValue(Temp);
  end;
  Result := Index >= 0;
  if Result then
    Value := Cast(Index);
end;

class function TEnumGeneric<T>.Count: integer;
var
  ptd: PTypeData;
begin
  Assert(IsEnumeration);
  ptd := GetTypeData;
  Result := ptd.MaxValue + 1;
end;

class function TEnumGeneric<T>.EnsureRange(Value: integer): integer;
var
  ptd: PTypeData;
begin
  Assert(IsEnumeration);
  ptd := GetTypeData;
  Result := Math.EnsureRange(Value, ptd.MinValue, ptd.MaxValue);
end;

class function TEnumGeneric<T>.EnumToStr(Value: T): String;
var Index: Integer;
begin
  Result := GetEnumName(Value);
  while (Length(Result) > 0) and (Result[1] in ['a'..'z']) do
    Delete(Result,1,1);
  for Index := 1 to Length(Result) do
    if Result[Index] = '_' then
      Result[Index] := ' ';
end;

function TEnumGeneric<T>.ToString: String;
begin
  Result := EnumToStr(Value);
end;

{ TEnumGeneric<T>.EEnum }

constructor TEnumGeneric<T>.EEnum.CreateFmt(const Test: String;
  const Args: array of Const);
var
  Info: pTypeInfo;
begin
  Info := TypeInfo(T);
  inherited CreateFmt('TEnum<%s>:%s',[Info.Name,Format(Test,Args)]);
end;

end.


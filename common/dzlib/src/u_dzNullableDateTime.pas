unit u_dzNullableDateTime;

interface

uses
  SysUtils,
  Variants,
  u_dzTranslator,
  u_dzNullableDate,
  u_dzNullableTime,
  u_dzNullableTimespan;

type
  TdzNullableDateTime = record
  private
    FIsValid: IInterface;
    FValue: TDateTime;
  public
    procedure Invalidate;
    function Value: TDateTime;
    function Date: TdzNullableDate;
    function Time: TdzNullableTime;
    function IsValid: Boolean; inline;
    function GetValue(out _Value: TDateTime): Boolean;
    procedure AssignVariant(_a: Variant);
    function ToVariant: Variant;
    function Dump: string;
    procedure AssignDate(_Value: TDateTime);
    procedure AssignTime(_Value: TDateTime);
    procedure AssignNow;
    class operator Negative(_a: TdzNullableDateTime): TdzNullableDateTime;
    class operator Positive(_a: TdzNullableDateTime): TdzNullableDateTime;
//    class operator Inc(_a: TdzNullableDateTime): TdzNullableDateTime;
//    class operator Dec(_a: TdzNullableDateTime): TdzNullableDateTime;
    class operator Implicit(_Value: TDateTime): TdzNullableDateTime;
    class operator Implicit(_a: TdzNullableDateTime): TDateTime;
    class operator Explicit(const _s: string): TdzNullableDateTime;
    class operator Explicit(_a: TdzNullableDateTime): string;
    class operator LessThan(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
    class operator LessThanOrEqual(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
    class operator GreaterThan(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
    class operator GreaterThanOrEqual(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
    class operator Equal(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
    class operator NotEqual(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
    class operator Subtract(_a: TdzNullableDateTime; _b: TdzNullableDateTime): TdzNullableTimespan;

    /// <summary> invalid values are considered smaller than any valid values
    /// and equal to each other </summary>
    class function Compare(_a, _b: TdzNullableDateTime): Integer; static;
    class function Invalid: TdzNullableDateTime; static;
    class function FromVariant(_a: Variant): TdzNullableDateTime; static;
    class function Now: TdzNullableDateTime; static;
  end;

implementation

uses
  DateUtils,
  Types,
  u_dzNullableTypesUtils,
  u_dzVariantUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

{ TdzNullableDateTime }

procedure TdzNullableDateTime.Invalidate;
begin
  FIsValid := nil;
end;

function TdzNullableDateTime.IsValid: Boolean;
begin
  Result := Assigned(FIsValid);
end;

procedure TdzNullableDateTime.AssignDate(_Value: TDateTime);
begin
  if IsValid then
    FValue := TimeOf(FValue)
  else
    FValue := 0;
  ReplaceDate(FValue, _Value);
  FIsValid := GetNullableTypesFlagInterface;
end;

procedure TdzNullableDateTime.AssignNow;
begin
  Self := TdzNullableDateTime.Now;
end;

procedure TdzNullableDateTime.AssignTime(_Value: TDateTime);
begin
  if IsValid then
    FValue := DateOf(FValue)
  else
    FValue := 0;
  ReplaceTime(FValue, _Value);
  FIsValid := GetNullableTypesFlagInterface;
end;

procedure TdzNullableDateTime.AssignVariant(_a: Variant);
begin
  if TryVar2DateTime(_a, FValue) then
    FIsValid := GetNullableTypesFlagInterface
  else
    FIsValid := nil;
end;

function TdzNullableDateTime.ToVariant: Variant;
begin
  if IsValid then
    Result := Value
  else
    Result := Variants.Null;
end;

class function TdzNullableDateTime.Compare(_a, _b: TdzNullableDateTime): Integer;
begin
  Result := DateUtils.CompareDateTime(_a, _b);
end;

function TdzNullableDateTime.Date: TdzNullableDate;
begin
  if IsValid then
    Result := Trunc(FValue)
  else
    Result.Invalidate;
end;

function TdzNullableDateTime.Time: TdzNullableTime;
begin
  if IsValid then
    Result := Frac(FValue)
  else
    Result.Invalidate;
end;

function TdzNullableDateTime.Dump: string;
begin
  if IsValid then
    Result := string(Self)
  else
    Result := '<invalid>';
end;

class operator TdzNullableDateTime.Explicit(_a: TdzNullableDateTime): string;
begin
  Result := DateTimeToStr(_a.Value);
end;

class operator TdzNullableDateTime.Explicit(const _s: string): TdzNullableDateTime;
var
  dt: TDateTime;
begin
  if TryStrToDateTime(_s, dt) then
    Result := dt;
end;

class function TdzNullableDateTime.FromVariant(_a: Variant): TdzNullableDateTime;
begin
  Result.AssignVariant(_a);
end;

function TdzNullableDateTime.GetValue(out _Value: TDateTime): Boolean;
begin
  Result := IsValid;
  if Result then
    _Value := FValue;
end;

class operator TdzNullableDateTime.LessThan(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
begin
  Result := (DateUtils.CompareDateTime(_a.Value, _b) = LessThanValue);
end;

class operator TdzNullableDateTime.LessThanOrEqual(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
begin
  Result := (DateUtils.CompareDateTime(_a.Value, _b) <> GreaterThanValue);
end;

class operator TdzNullableDateTime.Equal(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
begin
  Result := (DateUtils.CompareDateTime(_a.Value, _b) = EqualsValue);
end;

class operator TdzNullableDateTime.NotEqual(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
begin
  Result := (DateUtils.CompareDateTime(_a.Value, _b) <> EqualsValue);
end;

class function TdzNullableDateTime.Now: TdzNullableDateTime;
begin
  Result := SysUtils.Now;
end;

class operator TdzNullableDateTime.GreaterThan(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
begin
  Result := (DateUtils.CompareDateTime(_a.Value, _b) = GreaterThanValue);
end;

class operator TdzNullableDateTime.GreaterThanOrEqual(_a: TdzNullableDateTime; _b: TDateTime): Boolean;
begin
  Result := (DateUtils.CompareDateTime(_a.Value, _b) <> LessThanValue);
end;

class operator TdzNullableDateTime.Implicit(_a: TdzNullableDateTime): TDateTime;
begin
  Result := _a.Value;
end;

class operator TdzNullableDateTime.Implicit(_Value: TDateTime): TdzNullableDateTime;
begin
  Result.FValue := _Value;
  Result.FIsValid := GetNullableTypesFlagInterface;
end;

class function TdzNullableDateTime.Invalid: TdzNullableDateTime;
begin
  Result.Invalidate;
end;

class operator TdzNullableDateTime.Negative(_a: TdzNullableDateTime): TdzNullableDateTime;
begin
  Result := -_a.Value;
end;

class operator TdzNullableDateTime.Positive(_a: TdzNullableDateTime): TdzNullableDateTime;
begin
  Result := _a.Value;
end;

class operator TdzNullableDateTime.Subtract(_a: TdzNullableDateTime;
  _b: TdzNullableDateTime): TdzNullableTimespan;
begin
  Result.AssignDays(_a.Value - _b.Value);
end;

function TdzNullableDateTime.Value: TDateTime;
begin
  if not IsValid then
    raise EInvalidValue.Create(_('NullableDateTime is invalid'));
  Result := FValue;
end;

end.


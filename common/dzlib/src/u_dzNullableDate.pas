unit u_dzNullableDate;

interface

uses
  SysUtils,
  Variants,
  u_dzTranslator,
  u_dzTypes,
  u_dzDateUtils;

type
  TdzDayOfWeek = record
  public
    enum: TDayOfWeekEnum;
    function AsString: string;
  end;

type
  TdzDay = record
  private
    FDayOfWeek: TDayOfWeekEnum;
  public
    Number: TDayOfMonthNumbers;
    ///<summary> This cannot just be a field because of an apparent compiler bug </summary>
    function DayOfWeek: TdzDayOfWeek;
    procedure Init(_Number: TDayOfMonthNumbers; _DOW: TDayOfWeekEnum);
  end;

type
  TdzMonth = record
  public
    Number: TMonthNumbers;
    function AsString: string;
  end;

type
  TdzNullableDate = record
  private
    FIsValid: IInterface;
    FValue: TDateTime;
  public
    procedure Invalidate;
    function Value: TDateTime;
    function IsValid: Boolean;
    function GetValue(out _Value: TDateTime): Boolean;
    ///<summary>
    /// Assigns a variant represantation of a date
    /// @param v is the string to assign
    /// @param ErrorHandling determines if an invalid parameter raises an exception or
    ///                       just makes the dzNullableDate invalid.
    /// @returns true, if the string was a valid date, false otherwise
    /// if v is NULL, the dzNullableDate will be invalid afterwards </summary>
    function AssignVariant(_v: Variant; _ErrorHandling: TErrorHandlingEnum = ehRaiseException): Boolean;
    function ToVariant: Variant;
    ///<summary>
    /// Assigns a string represantation of a date in ISO 8601 format
    /// @param s is the string to assign
    /// @param InvalidStr is considered an invalid date
    /// @param ErrorHandling determines if an invalid parameter raises an exception or
    ///                       just makes the dzNullableDate invalid.
    /// @raises EConvertError if s <> InvalidStr but cannot be converted </summary>
    /// @returns true, if the string was a valid date, false otherwise
    /// if s is an empty string, the dzNullableDate will be invalid afterwards </summary>
    function AssignIso(const _s: string; const _InvalidStr: string = '';
      _ErrorHandling: TErrorHandlingEnum = ehRaiseException): Boolean;
    ///<summary>
    /// Assigns a date string in German (european?) format dd.mm.yyyy
    /// @param s is the string to assign
    /// @param InvalidStr is considered an invalid date
    /// @param ErrorHandling determines if an invalid parameter raises an exception or
    ///                       just makes the dzNullableDate invalid.
    /// @raises EConvertError if s <> InvalidStr but cannot be converted </summary>
    /// @returns true, if the string was a valid date, false otherwise
    /// if s is an empty string, the dzNullableDate will be invalid afterwards </summary>
    function AssignDDMMYYYY(const _s: string; const _InvalidStr: string = '';
      _ErrorHandling: TErrorHandlingEnum = ehRaiseException): Boolean;
    ///<summary>
    /// Tries to assign a date string. Date formats are tried in the following order:
    /// * format configured in Windows
    /// * German dd.mm.yyyy
    /// * ISO 8601 (yyyy-mm-dd)
    /// * United Kingdom: dd/mm/yyyy
    /// (I had to decide between the sane UK format or the brain dead US format, i chose the UK format.)
    /// @param s is the string to assign
    /// @param InvalidStr is considered an invalid date
    /// @param ErrorHandling determines if an invalid parameter raises an exception or
    ///                       just makes the dzNullableDate invalid.
    /// @raises EConvertError if s <> InvalidStr but cannot be converted </summary>
    /// @returns true, if the string was a valid date, false otherwise
    /// if s is an empty string, the dzNullableDate will be invalid afterwards </summary>
    function AssignStr(const _s: string; const _InvalidStr: string = '';
      _ErrorHandling: TErrorHandlingEnum = ehRaiseException): Boolean;
    ///<summary>
    /// Tries to assign a date string in the brain dead US format (mm/dd/(yy)yy)
    /// @param s is the string to assign
    /// @param InvalidStr is considered an invalid date
    /// @raises EConvertError if s <> InvalidStr but cannot be converted </summary>
//    procedure AssignBraindeadUS(const _s: string; const _InvalidStr: string = '');
    procedure Encode(_Year, _Month, _Day: Word);
    procedure Decode(out _Year, _Month, _Day: Word);
    procedure SetDay(_Value: Word);
    function IsDate(_Month, _Day: Word): Boolean;
    function Year: Word;
    function Month: TdzMonth;
    function Day: TdzDay;
    function Dump: string;
    function ForDisplay: string; overload;
    function ForDisplay(const _Default: string): string; overload;
    function ToDDmmYYYY: string; overload;
    function ToDDmmYYYY(const _Default: string): string; overload;
    function ToYYYYmmDD: string; overload;
    function ToYYYYmmDD(const _Default: string): string; overload;
    function IncDay(_by: Integer): TdzNullableDate;
    function IncMonth(_by: Integer): TdzNullableDate;
    function IncYear(_by: Integer): TdzNullableDate;
    function DecDay(_by: Integer): TdzNullableDate;
    function DecMonth(_by: Integer): TdzNullableDate;
    function DecYear(_by: Integer): TdzNullableDate;
    class operator Implicit(_Value: TDateTime): TdzNullableDate;
    class operator Implicit(_a: TdzNullableDate): TDateTime;
    class operator Explicit(const _s: string): TdzNullableDate;
    class operator Explicit(_a: TdzNullableDate): string;
    class function FromVariant(_v: Variant): TdzNullableDate; static;
    class operator NotEqual(_a, _b: TdzNullableDate): Boolean;
    class operator Equal(_a, _b: TdzNullableDate): Boolean;
    class operator GreaterThan(_a, _b: TdzNullableDate): Boolean;
    class operator GreaterThanOrEqual(_a, _b: TdzNullableDate): Boolean;
    class operator LessThan(_a, _b: TdzNullableDate): Boolean;
    class operator LessThanOrEqual(_a, _b: TdzNullableDate): Boolean;
    class operator Add(_Date: TdzNullableDate; _Days: Integer): TdzNullableDate;
    class operator Subtract(_Date: TdzNullableDate; _Days: Integer): TdzNullableDate;
    class function Today: TdzNullableDate; static;
  end;

implementation

uses
  SysConst,
  DateUtils,
  u_dzNullableTypesUtils,
  u_dzVariantUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

{ TdzDayOfWeek }

function TdzDayOfWeek.AsString: string;
begin
  Result := u_dzDateUtils.DayOfWeek2Str(enum);
end;

{ TdzDay }

function TdzDay.DayOfWeek: TdzDayOfWeek;
begin
  Result.enum := FDayOfWeek;
end;

procedure TdzDay.Init(_Number: TDayOfMonthNumbers; _DOW: TDayOfWeekEnum);
begin
  Number := _Number;
  FDayOfWeek := _DOW;
end;

{ TdzMonth }

function TdzMonth.AsString: string;
begin
  Result := u_dzDateUtils.Month2Str(Number);
end;

{ TdzNullableDate }

class operator TdzNullableDate.Explicit(const _s: string): TdzNullableDate;
begin
  Result.AssignStr(_s);
end;

class operator TdzNullableDate.Add(_Date: TdzNullableDate; _Days: Integer): TdzNullableDate;
begin
  Result := _Date.Value + _Days;
end;

function TdzNullableDate.AssignDDMMYYYY(const _s: string; const _InvalidStr: string = '';
  _ErrorHandling: TErrorHandlingEnum = ehRaiseException): Boolean;
begin
  Result := False;
  Invalidate;
  if _s <> _InvalidStr then begin
    Result := Tryddmmyyyy2Date(_s, FValue);
    if Result then
      FIsValid := GetNullableTypesFlagInterface
    else begin
      if (_ErrorHandling = ehRaiseException) then
        raise EConvertError.CreateResFmt(@SInvalidDate, [_s]);
    end;
  end;
end;

function TdzNullableDate.AssignIso(const _s: string; const _InvalidStr: string = '';
  _ErrorHandling: TErrorHandlingEnum = ehRaiseException): Boolean;
begin
  Result := False;
  Invalidate;
  if _s <> _InvalidStr then begin
    Result := TryIso2Date(_s, FValue);
    if Result then
      FIsValid := GetNullableTypesFlagInterface
    else begin
      if (_ErrorHandling = ehRaiseException) then
        raise EConvertError.CreateResFmt(@SInvalidDate, [_s]);
    end;
  end;
end;

function TdzNullableDate.AssignStr(const _s: string; const _InvalidStr: string = '';
  _ErrorHandling: TErrorHandlingEnum = ehRaiseException): Boolean;
begin
  Result := False;
  Invalidate;
  if _s <> _InvalidStr then begin
    Result := TryStr2Date(_s, FValue);
    if Result then
      FIsValid := GetNullableTypesFlagInterface
    else begin
      if (_ErrorHandling = ehRaiseException) then
        raise EConvertError.CreateResFmt(@SInvalidDate, [_s]);
    end;
  end;
end;

function TdzNullableDate.AssignVariant(_v: Variant;
  _ErrorHandling: TErrorHandlingEnum = ehRaiseException): Boolean;
begin
  Result := False;
  Invalidate;
  if VarIsNull(_v) or VarIsEmpty(_v) then
    Exit;
  Result := TryVar2DateTime(_v, FValue);
  if Result then
    FIsValid := GetNullableTypesFlagInterface
  else begin
    if (_ErrorHandling = ehRaiseException) then
      raise EConvertError.CreateResFmt(@SInvalidDate, [Var2Str(_v)]);
  end;
end;

function TdzNullableDate.Day: TdzDay;
var
  Year, Month, TheDay: Word;
begin
  Decode(Year, Month, TheDay);
  Result.Init(TheDay, u_dzDateUtils.GetDayOfTheWeek(Value));
end;

procedure TdzNullableDate.Decode(out _Year, _Month, _Day: Word);
begin
  DecodeDate(Value, _Year, _Month, _Day);
end;

function TdzNullableDate.DecDay(_by: Integer): TdzNullableDate;
begin
  FValue := DateUtils.IncDay(Value, -_by);
  Result := Self;
end;

function TdzNullableDate.DecMonth(_by: Integer): TdzNullableDate;
begin
  FValue := SysUtils.IncMonth(Value, -_by);
  Result := Self;
end;

function TdzNullableDate.DecYear(_by: Integer): TdzNullableDate;
begin
  FValue := DateUtils.IncYear(Value, -_by);
  Result := Self;
end;

function TdzNullableDate.Dump: string;
begin
  if IsValid then
    Result := DateTime2Iso(FValue)
  else
    Result := '<invalid>';
end;

procedure TdzNullableDate.Encode(_Year, _Month, _Day: Word);
begin
  if TryEncodeDate(_Year, _Month, _Day, FValue) then
    FIsValid := GetNullableTypesFlagInterface
  else
    FIsValid := nil;
end;

class operator TdzNullableDate.Explicit(_a: TdzNullableDate): string;
begin
  Result := _a.ToYYYYmmDD('');
end;

function TdzNullableDate.ForDisplay: string;
begin
  Result := DateTimeToStr(Value)
end;

function TdzNullableDate.ForDisplay(const _Default: string): string;
begin
  if IsValid then
    Result := DateTimeToStr(Value)
  else
    Result := _Default;
end;

class function TdzNullableDate.FromVariant(_v: Variant): TdzNullableDate;
begin
  Result.AssignVariant(_v);
end;

class operator TdzNullableDate.Implicit(_Value: TDateTime): TdzNullableDate;
begin
  Result.FValue := _Value;
  if _Value <> 0 then
    Result.FIsValid := GetNullableTypesFlagInterface
  else
    Result.FIsValid := nil;
end;

class operator TdzNullableDate.Implicit(_a: TdzNullableDate): TDateTime;
begin
  Result := _a.Value;
end;

function TdzNullableDate.GetValue(out _Value: TDateTime): Boolean;
begin
  Result := IsValid;
  if Result then
    _Value := FValue;
end;

class operator TdzNullableDate.GreaterThan(_a, _b: TdzNullableDate): Boolean;
begin
  Result := _a.Value > _b.Value;
end;

class operator TdzNullableDate.GreaterThanOrEqual(_a, _b: TdzNullableDate): Boolean;
begin
  Result := _a.Value >= _b.Value;
end;

function TdzNullableDate.IncDay(_by: Integer): TdzNullableDate;
begin
  FValue := DateUtils.IncDay(Value, _by);
  Result := Self;
end;

function TdzNullableDate.IncMonth(_by: Integer): TdzNullableDate;
begin
  FValue := SysUtils.IncMonth(Value, _by);
  Result := Self;
end;

function TdzNullableDate.IncYear(_by: Integer): TdzNullableDate;
begin
  FValue := DateUtils.IncYear(Value, _by);
  Result := Self;
end;

procedure TdzNullableDate.Invalidate;
begin
  FIsValid := nil;
end;

function TdzNullableDate.IsDate(_Month, _Day: Word): Boolean;
var
  Year: Word;
  Month: Word;
  Day: Word;
begin
  Decode(Year, Month, Day);
  Result := (Month = _Month) and (Day = _Day);
end;

function TdzNullableDate.IsValid: Boolean;
begin
  Result := FIsValid <> nil;
end;

class operator TdzNullableDate.LessThan(_a, _b: TdzNullableDate): Boolean;
begin
  Result := _a.Value < _b.Value;
end;

class operator TdzNullableDate.LessThanOrEqual(_a, _b: TdzNullableDate): Boolean;
begin
  Result := _a.Value <= _b.Value;
end;

function TdzNullableDate.Month: TdzMonth;
var
  Year, TheMonth, Day: Word;
begin
  Decode(Year, TheMonth, Day);
  Result.Number := TheMonth;
end;

class operator TdzNullableDate.NotEqual(_a, _b: TdzNullableDate): Boolean;
begin
  Result := _a.Value <> _b.Value;
end;

procedure TdzNullableDate.SetDay(_Value: Word);
var
  Year: Word;
  Month: Word;
  Day: Word;
begin
  Decode(Year, Month, Day);
  Encode(Year, Month, _Value);
end;

class operator TdzNullableDate.Subtract(_Date: TdzNullableDate; _Days: Integer): TdzNullableDate;
begin
  Result := _Date.Value - _Days;
end;

class operator TdzNullableDate.Equal(_a, _b: TdzNullableDate): Boolean;
begin
  Result := _a.Value = _b.Value;
end;

class function TdzNullableDate.Today: TdzNullableDate;
begin
  Result := SysUtils.Date;
end;

function TdzNullableDate.ToDDmmYYYY(const _Default: string): string;
begin
  if IsValid then
    Result := Date2ddmmyyyy(Value)
  else
    Result := _Default;
end;

function TdzNullableDate.ToDDmmYYYY: string;
begin
  Result := Date2ddmmyyyy(Value);
end;

function TdzNullableDate.ToVariant: Variant;
begin
  if IsValid then
    Result := FValue
  else
    Result := Variants.Null;
end;

function TdzNullableDate.ToYYYYmmDD(const _Default: string): string;
begin
  if IsValid then
    Result := DateTime2Iso(Value)
  else
    Result := '';
end;

function TdzNullableDate.ToYYYYmmDD: string;
begin
  Result := DateTime2Iso(Value);
end;

function TdzNullableDate.Value: TDateTime;
begin
  if not IsValid then
    raise EInvalidValue.Create(_('NullableDate value is invalid'));
  Result := FValue;
end;

function TdzNullableDate.Year: Word;
var
  Month, Day: Word;
begin
  Decode(Result, Month, Day);
end;

end.


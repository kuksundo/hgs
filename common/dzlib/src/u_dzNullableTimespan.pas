unit u_dzNullableTimespan;

interface

{$INCLUDE 'jedi.inc'}

uses
  SysUtils,
  u_dzTranslator,
  u_dzNullableExtended;

type
  TdzNullableTimespan = record
  private
    FIsValid: IInterface;
    ///<summary>
    /// Note: This used to be a double, encoded like in TDateTime but since that turned out
    ///       to have rather severe rounding errors I now use an Int64 for days and an
    ///       integer for Milliseconds. The actual timespan is always the sum of both.
    ///       They should always have the same sign. </summary>
    FFullDays: Int64;
    FMilliseconds: Integer;
  public
    procedure Invalidate;
    function IsValid: Boolean;
    function InDays: Double;
    function InFullDays: Int64;
    function InHours: Double;
    function InFullHours: Int64;
    function InMinutes: Double;
    function InFullMinutes: Int64;
    function InSeconds: Double;
    function InFullSeconds: Int64;
    function InMilliseconds: Double;
    function InFullMilliseconds: Int64;
    function GetDays(out _Days: Double): Boolean; overload;
    function GetDays(out _Days: Int64): Boolean; overload;
    function GetDays(out _Days: Integer): Boolean; overload;
    function GetHours(out _Hours: Double): Boolean; overload;
    function GetHours(out _Hours: Int64): Boolean; overload;
    function GetHours(out _Hours: Integer): Boolean; overload;
    function GetMinutes(out _Minutes: Double): Boolean; overload;
    function GetMinutes(out _Minutes: Int64): Boolean; overload;
    function GetMinutes(out _Minutes: Integer): Boolean; overload;
    function GetSeconds(out _Seconds: Double): Boolean; overload;
    function GetSeconds(out _Seconds: Int64): Boolean; overload;
    function GetSeconds(out _Seconds: Integer): Boolean; overload;
    function GetMilliSeconds(out _Milliseconds: Double): Boolean; overload;
    function GetMilliSeconds(out _Milliseconds: Int64): Boolean; overload;
    function GetMilliSeconds(out _Milliseconds: Integer): Boolean; overload;
    procedure GetDaysHoursMinutesSeconds(out _Days, _Hours, _Minutes, _Seconds: Int64);
    ///<summary> Generates a string of the form 'hh<separator>mm'
    ///          @param Separator is used to separate the hour and minute part,
    ///                           if Separator is #0, no separator is used.
    ///          @param NullValue is the value used if the TNullableTimespan value is not valid. </summary>
    function ToHHmm(_Separator: Char = #0; const _NullValue: string = ''): string;
    ///<summary> Converts the value to a string representation of InHours with the given
    ///          number of decimals. Returns an NullValue, if invalid.</summary>
    function ToHourStr(_Decimals: Integer = 1; const _NullValue: string = ''): string;
    function ForDisplay: string;
    ///<summary> Calculates the value from the given Days, Hours, Minutes, Seconds and
    ///          Milliseconds. All these values can be higher than the usual maximum value
    ///          eg. you could passs 26 hours and 100 seconds and still get a valid
    ///          result of 1 day, 2 hours, 1 Minute and 40 seconds.
    ///          Note: you cannot assign month's or years because they vary in length </summary>
    procedure Assign(_Days, _Hours, _Minutes, _Seconds, _Milliseconds: Word);
    ///<summary> Note that Days is not a TDateTime value representing a date but just a number
    ///          of days with possibly fractions. </summary>
    procedure AssignDays(_Days: Double);
    procedure AssignHours(_Hours: Extended); overload;
    procedure AssignHours(_Hours: TNullableExtended); overload;
    procedure AssignSeconds(_Seconds: Extended);
    procedure AssignZero;
    ///<summary>
    /// Interprets a string as an hour, supporting three formats:
    /// * hours with decimals
    /// * <hours>h<minutes>
    /// * <hours>:<minutes>
    /// The formats are tried in the above order.
    /// An empty string results in an invalid TdzNullableTimespan (self.IsValid = false).
    /// @raises EConvertError if the string cannot be converted. </summary>
    procedure AssignHoursStr(const _s: string);

    procedure Add(_Value: TdzNullableTimespan);
    procedure AddHours(_Hours: Extended);

    class operator GreaterThan(_a, _b: TdzNullableTimespan): Boolean;
    class operator LessThan(_a, _b: TdzNullableTimespan): Boolean;
    class operator GreaterThanOrEqual(_a, _b: TdzNullableTimespan): Boolean;
    class operator LessThanOrEqual(_a, _b: TdzNullableTimespan): Boolean;
    class operator Equal(_a, _b: TdzNullableTimespan): Boolean;
    class operator NotEqual(_a, _b: TdzNullableTimespan): Boolean;
    class operator Add(_a, _b: TdzNullableTimespan): TdzNullableTimespan;
    class operator Subtract(_a, _b: TdzNullableTimespan): TdzNullableTimespan;
    class operator Divide(_a: TdzNullableTimespan; _b: Integer): TdzNullableTimespan;
    class operator Divide(_a: TdzNullableTimespan; _b: Extended): TdzNullableTimespan;
    class operator Multiply(_a: TdzNullableTimespan; _b: Integer): TdzNullableTimespan;
    class operator Multiply(_a: TdzNullableTimespan; _b: Extended): TdzNullableTimespan;

    class function Zero: TdzNullableTimespan; static;
    class function FromDays(_Days: Double): TdzNullableTimespan; static;
    class function FromHours(_Hours: Extended): TdzNullableTimespan; overload; static;
    class function FromHours(_Hours: TNullableExtended): TdzNullableTimespan; overload; static;
    class function FromHoursStr(const _s: string): TdzNullableTimespan; overload; static;
    class function FromSeconds(_Seconds: Extended): TdzNullableTimespan; static;
    class function Combine(_Days, _Hours, _Minutes, _Seconds, _Milliseconds: Word): TdzNullableTimespan; static;
  end;

implementation

uses
  Math,
  DateUtils,
  u_dzConvertUtils,
  u_dzDateUtils,
  u_dzNullableTypesUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

{ TdzNullableTimespan }

procedure TdzNullableTimespan.AssignDays(_Days: Double);
begin
  FFullDays := Trunc(_Days);
  FMilliseconds := Round(Frac(_Days) / OneMillisecond);
  FIsValid := GetNullableTypesFlagInterface;
end;

procedure TdzNullableTimespan.AssignHours(_Hours: Extended);
begin
  AssignDays(_Hours * OneHour);
end;

procedure TdzNullableTimespan.AssignHours(_Hours: TNullableExtended);
begin
  if _Hours.IsValid then
    AssignHours(_Hours.Value)
  else
    Invalidate;
end;

procedure TdzNullableTimespan.AssignHoursStr(const _s: string);
var
  flt: Extended;
begin
  if _s = '' then begin
    Invalidate;
    Exit;
  end;

  if TryStr2Float(_s, flt, #0) then
    AssignHours(flt)
  else if TryHHmm2Hours(_s, flt, 'h') then
    AssignHours(flt)
  else if TryHHmm2Hours(_s, flt, ':') then
    AssignHours(flt)
  else
    raise EConvertError.CreateFmt(_('Could not convert "%s" to %s'), [_s, 'TdzNullableTimespan']);
end;

procedure TdzNullableTimespan.AssignSeconds(_Seconds: Extended);
begin
  AssignDays(_Seconds * OneSecond);
end;

procedure TdzNullableTimespan.AssignZero;
begin
  AssignDays(0);
end;

class function TdzNullableTimespan.Combine(_Days, _Hours, _Minutes, _Seconds,
  _Milliseconds: Word): TdzNullableTimespan;
begin
  Result.Assign(_Days, _Hours, _Minutes, _Seconds, _Milliseconds);
end;

class operator TdzNullableTimespan.Divide(_a: TdzNullableTimespan; _b: Extended): TdzNullableTimespan;
begin
  Result.AssignDays(_a.InDays / _b);
end;

class operator TdzNullableTimespan.Divide(_a: TdzNullableTimespan; _b: Integer): TdzNullableTimespan;
begin
  Result.AssignDays(_a.InDays / _b);
end;

class operator TdzNullableTimespan.Equal(_a, _b: TdzNullableTimespan): Boolean;
begin
  Result := SameValue(_a.InDays, _b.InDays);
end;

class function TdzNullableTimespan.FromDays(_Days: Double): TdzNullableTimespan;
begin
  Result.AssignDays(_Days);
end;

class function TdzNullableTimespan.FromHours(_Hours: TNullableExtended): TdzNullableTimespan;
begin
  Result.AssignHours(_Hours)
end;

class function TdzNullableTimespan.FromHoursStr(const _s: string): TdzNullableTimespan;
begin
  Result.AssignHoursStr(_s);
end;

class function TdzNullableTimespan.FromHours(_Hours: Extended): TdzNullableTimespan;
begin
  Result.AssignHours(_Hours);
end;

class function TdzNullableTimespan.FromSeconds(_Seconds: Extended): TdzNullableTimespan;
begin
  Result.AssignSeconds(_Seconds);
end;

class operator TdzNullableTimespan.Add(_a, _b: TdzNullableTimespan): TdzNullableTimespan;
begin
  Result.AssignDays(_a.InDays + _b.InDays);
end;

procedure TdzNullableTimespan.Add(_Value: TdzNullableTimespan);
begin
  AssignDays(InDays + _Value.InDays);
end;

procedure TdzNullableTimespan.AddHours(_Hours: Extended);
begin
  AssignHours(InHours + _Hours);
end;

procedure TdzNullableTimespan.Assign(_Days, _Hours, _Minutes, _Seconds, _Milliseconds: Word);
begin
  AssignDays(_Days
    + _Hours * OneHour
    + _Minutes * OneMinute
    + _Seconds * OneSecond
    + _Milliseconds * OneMillisecond);
end;

function TdzNullableTimespan.GetDays(out _Days: Double): Boolean;
begin
  Result := IsValid;
  if Result then begin
    _Days := FFullDays + FMilliseconds * OneMillisecond;
  end;
end;

function TdzNullableTimespan.GetDays(out _Days: Int64): Boolean;
begin
  Result := IsValid;
  if Result then
    _Days := InFullDays;
end;

function TdzNullableTimespan.GetDays(out _Days: Integer): Boolean;
begin
  Result := IsValid;
  if Result then
    _Days := InFullDays;
end;

function TdzNullableTimespan.GetHours(out _Hours: Double): Boolean;
begin
  Result := IsValid;
  if Result then
    _Hours := InHours;
end;

function TdzNullableTimespan.GetHours(out _Hours: Int64): Boolean;
begin
  Result := IsValid;
  if Result then
    _Hours := InFullHours;
end;

function TdzNullableTimespan.GetHours(out _Hours: Integer): Boolean;
begin
  Result := IsValid;
  if Result then
    _Hours := InFullHours;
end;

function TdzNullableTimespan.GetMinutes(out _Minutes: Double): Boolean;
begin
  Result := IsValid;
  if Result then
    _Minutes := InMinutes;
end;

function TdzNullableTimespan.GetMinutes(out _Minutes: Int64): Boolean;
begin
  Result := IsValid;
  if Result then
    _Minutes := InFullMinutes;
end;

function TdzNullableTimespan.GetMinutes(out _Minutes: Integer): Boolean;
begin
  Result := IsValid;
  if Result then
    _Minutes := InFullMinutes;
end;

function TdzNullableTimespan.GetSeconds(out _Seconds: Double): Boolean;
begin
  Result := IsValid;
  if Result then
    _Seconds := InSeconds;
end;

function TdzNullableTimespan.GetSeconds(out _Seconds: Int64): Boolean;
begin
  Result := IsValid;
  if Result then
    _Seconds := InFullSeconds;
end;

function TdzNullableTimespan.GetSeconds(out _Seconds: Integer): Boolean;
begin
  Result := IsValid;
  if Result then
    _Seconds := InFullSeconds;
end;

function TdzNullableTimespan.GetMilliSeconds(out _Milliseconds: Double): Boolean;
begin
  Result := IsValid;
  if Result then
    _Milliseconds := InMilliseconds;
end;

function TdzNullableTimespan.GetMilliSeconds(out _Milliseconds: Int64): Boolean;
begin
  Result := IsValid;
  if Result then
    _Milliseconds := InFullMilliseconds;
end;

function TdzNullableTimespan.GetMilliSeconds(out _Milliseconds: Integer): Boolean;
begin
  Result := IsValid;
  if Result then
    _Milliseconds := InFullMilliseconds;
end;

class operator TdzNullableTimespan.GreaterThan(_a, _b: TdzNullableTimespan): Boolean;
begin
  Result := (_a.InDays > _b.InDays);
end;

class operator TdzNullableTimespan.LessThan(_a, _b: TdzNullableTimespan): Boolean;
begin
  Result := (_a.InDays < _b.InDays);
end;

class operator TdzNullableTimespan.LessThanOrEqual(_a, _b: TdzNullableTimespan): Boolean;
begin
  Result := not (_a > _b);
end;

class operator TdzNullableTimespan.Multiply(_a: TdzNullableTimespan; _b: Integer): TdzNullableTimespan;
begin
  Result.AssignDays(_a.InDays * _b);
end;

class operator TdzNullableTimespan.Multiply(_a: TdzNullableTimespan; _b: Extended): TdzNullableTimespan;
begin
  Result.AssignDays(_a.InDays * _b);
end;

class operator TdzNullableTimespan.NotEqual(_a, _b: TdzNullableTimespan): Boolean;
begin
  Result := not (_a = _b);
end;

class operator TdzNullableTimespan.Subtract(_a, _b: TdzNullableTimespan): TdzNullableTimespan;
begin
  Result.AssignDays(_a.InDays - _b.InDays);
end;

function TdzNullableTimespan.ToHHmm(_Separator: Char; const _NullValue: string): string;
var
  Separator: string;
  IsNegative: Boolean;
  FullHours: Integer;
  FullMinutes: Integer;
begin
  if IsValid then begin
    if _Separator <> #0 then
      Separator := _Separator
    else
      Separator := '';

    FullHours := Self.InFullHours;
    FullMinutes := Self.InFullMinutes;
    IsNegative := (FullHours < 0) or (FullMinutes < 0);
    FullHours := Abs(FullHours);
    FullMinutes := Abs(FullMinutes);
    Result := Format('%.2d', [FullHours]) + Separator + Format('%.2d', [FullMinutes mod 60]);
    if IsNegative then
      Result := '-' + Result;
  end else
    Result := _NullValue;
end;

{$IFDEF RTL220_UP}

function DecimalSeparator: Char; inline;
begin
  Result := FormatSettings.DecimalSeparator;
end;
{$ENDIF}

function TdzNullableTimespan.ToHourStr(_Decimals: Integer = 1; const _NullValue: string = ''): string;
begin
  if IsValid then
    Result := Float2Str(InHours, _Decimals, DecimalSeparator)
  else
    Result := _NullValue;
end;

procedure TdzNullableTimespan.GetDaysHoursMinutesSeconds(out _Days, _Hours, _Minutes, _Seconds: Int64);
begin
  _Seconds := InFullSeconds;
  _Minutes := InFullMinutes;
  _Hours := InFullHours;
  _Days := InFullDays;
  _Seconds := _Seconds - _Minutes * 60;
  _Minutes := _Minutes - _Hours * 60;
  _Hours := _Hours - _Days * 24;
end;

function AppendToStr(const _s: string; const _ToAppend: string; const _Delimiter: string = ' '): string;
begin
  Result := _s;
  if Result <> '' then
    Result := Result + _Delimiter;
  Result := Result + _ToAppend;
end;

function TdzNullableTimespan.ForDisplay: string;
var
  d: Int64;
  h: Int64;
  m: Int64;
  s: Int64;
begin
  if IsValid then begin
    Result := '';
    GetDaysHoursMinutesSeconds(d, h, m, s);
    if d > 0 then
      Result := AppendToStr(Result, Format(_('%d days'), [d]));
    if h > 0 then
      Result := AppendToStr(Result, Format(_('%d hours'), [h]));
    if (d = 0) then
      Result := AppendToStr(Result, Format(_('%d minutes'), [m]));
    if (d = 0) and (h = 0) then
      Result := AppendToStr(Result, Format(_('%d seconds'), [s]));
  end else
    Result := _('invalid');
end;

class function TdzNullableTimespan.Zero: TdzNullableTimespan;
begin
  Result.AssignZero;
end;

class operator TdzNullableTimespan.GreaterThanOrEqual(_a, _b: TdzNullableTimespan): Boolean;
begin
  Result := not (_a < _b);
end;

procedure TdzNullableTimespan.Invalidate;
begin
  FIsValid := nil;
end;

function TdzNullableTimespan.IsValid: Boolean;
begin
  Result := Assigned(FIsValid);
end;

function TdzNullableTimespan.InDays: Double;
begin
  if not GetDays(Result) then
    raise EInvalidValue.Create(_('NullableTimespan value is invalid'));
end;

function TdzNullableTimespan.InFullDays: Int64;
begin
  Result := FFullDays;
end;

function TdzNullableTimespan.InHours: Double;
begin
  Result := InDays * HoursPerDay;
end;

function TdzNullableTimespan.InFullHours: Int64;
begin
  Result := Trunc(InHours);
end;

function TdzNullableTimespan.InMinutes: Double;
begin
  Result := InDays * MinsPerDay;
end;

function TdzNullableTimespan.InFullMinutes: Int64;
begin
  Result := Round(InMinutes);
end;

function TdzNullableTimespan.InSeconds: Double;
begin
  Result := InDays * SecsPerDay;
end;

function TdzNullableTimespan.InFullSeconds: Int64;
begin
  Result := Trunc(InSeconds);
end;

function TdzNullableTimespan.InMilliseconds: Double;
begin
  Result := InDays * MSecsPerDay;
end;

function TdzNullableTimespan.InFullMilliseconds: Int64;
begin
  Result := Trunc(InMilliseconds);
end;

end.

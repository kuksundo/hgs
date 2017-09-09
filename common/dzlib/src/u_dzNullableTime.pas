unit u_dzNullableTime;

interface

uses
  SysUtils,
  u_dzTranslator,
  u_dzStringUtils,
  u_dzNullableTimespan;

type
  TdzNullableTime = record
  private
    FIsValid: IInterface;
    FValue: TDateTime;
  public
    procedure Invalidate;
    function Value: TDateTime;
    function IsValid: Boolean;
    function GetValue(out _Value: TDateTime): Boolean;
    procedure Encode(_Hour, _Minutes, _Seconds, _MSeconds: Word);
    procedure Decode(out _Hour, _Minutes, _Seconds, _MSeconds: Word);
    procedure AssignVariant(_v: Variant);
    function TryAssignStr(const _s: string): Boolean;
    procedure AssignIso(const _s: string; const _InvalidStr: string = '');
    procedure AssignStr(const _s: string; const _InvalidStr: string = '');
    function ForDisplay(_IncludeSeconds: Boolean = True; _Include100th: Boolean = False): string;
    function Dump: string;
    function ToHHmmSS: string; overload;
    function ToHHmmSS(const _InvalidStr: string): string; overload;
    function ToHHmm: string;
    function Hour: Word;
    function Minutes: Word;
    function Seconds: Word;
    function InHours: Extended;
    function InMinutes: Extended;
    function InSeconds: Extended;
    procedure AddSeconds(_Seconds: Extended);
    procedure SubtractSeconds(_Seconds: Extended);
    class operator Implicit(_Value: TDateTime): TdzNullableTime;
    class operator Implicit(_a: TdzNullableTime): TDateTime;
    class operator Explicit(const _s: string): TdzNullableTime; // use AssignStr instead
    class operator Explicit(_a: TdzNullableTime): string; // use ToHHmmSS or ForDisplay instead
    class operator Subtract(_a, _b: TdzNullableTime): TdzNullableTimespan;
    class operator GreaterThan(_a, _b: TdzNullableTime): Boolean;
    class operator LessThan(_a, _b: TdzNullableTime): Boolean;
    class operator GreaterThanOrEqual(_a, _b: TdzNullableTime): Boolean;
    class operator LessThanOrEqual(_a, _b: TdzNullableTime): Boolean;
    class function FromVariant(_v: Variant): TdzNullableTime; static;
    class function Now: TdzNullableTime; static;
  end;

implementation

uses
  SysConst,
  DateUtils,
  u_dzDateUtils,
  u_dzConvertUtils,
  u_dzNullableTypesUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

{ TdzNullableTime }

class operator TdzNullableTime.Explicit(const _s: string): TdzNullableTime;
begin
  if TryIso2Time(_s, Result.FValue) or TryStrToTime(_s, Result.FValue) then
    Result.FIsValid := GetNullableTypesFlagInterface
  else
    Result.FIsValid := nil;
end;

procedure TdzNullableTime.AddSeconds(_Seconds: Extended);
begin
  FValue := Value + _Seconds / SecondsPerDay;
end;

function TdzNullableTime.Hour: Word;
var
  m: Word;
  s: Word;
  ms: Word;
begin
  DecodeTime(Value, Result, m, s, ms);
end;

function TdzNullableTime.Minutes: Word;
var
  h: Word;
  s: Word;
  ms: Word;
begin
  DecodeTime(Value, h, Result, s, ms);
end;

function TdzNullableTime.Seconds: Word;
var
  h: Word;
  m: Word;
  ms: Word;
begin
  DecodeTime(Value, h, m, Result, ms);
end;

procedure TdzNullableTime.SubtractSeconds(_Seconds: Extended);
begin
  AddSeconds(-_Seconds);
end;

function TdzNullableTime.ToHHmm: string;
begin
  Result := Time2Iso(Value, False);
end;

function TdzNullableTime.ToHHmmSS: string;
begin
  Result := Time2Iso(Value, True);
end;

function TdzNullableTime.ToHHmmSS(const _InvalidStr: string): string;
begin
  if IsValid then
    Result := Time2Iso(Value, True)
  else
    Result := _InvalidStr;
end;

procedure TdzNullableTime.AssignIso(const _s, _InvalidStr: string);
begin
  if _s = _InvalidStr then
    FIsValid := nil
  else if TryIso2Time(_s, FValue) then
    FIsValid := GetNullableTypesFlagInterface
  else
    raise EConvertError.CreateFmt(SInvalidTime, [_s]);
end;

function TdzNullableTime.TryAssignStr(const _s: string): Boolean;
begin
  Result := TryIso2Time(_s, FValue) or TryStrToTime(_s, FValue);
  if Result then
    FIsValid := GetNullableTypesFlagInterface
end;

procedure TdzNullableTime.AssignStr(const _s, _InvalidStr: string);
begin
  if _s = _InvalidStr then
    FIsValid := nil
  else if not TryAssignStr(_s) then
    raise EConvertError.CreateFmt(SInvalidTime, [_s]);
end;

procedure TdzNullableTime.AssignVariant(_v: Variant);
begin
  if TryIso2Time(_v, FValue) then
    FIsValid := GetNullableTypesFlagInterface
  else
    FIsValid := nil;
end;

function TdzNullableTime.Dump: string;
begin
  if IsValid then
    Result := Time2Iso(FValue)
  else
    Result := '<invalid>';
end;

function TdzNullableTime.ForDisplay(_IncludeSeconds: Boolean = True; _Include100th: Boolean = False): string;
var
  h, m, s, cs: Word;
begin
  if _Include100th then
    _IncludeSeconds := True;

  h := Trunc(Value * SecondsPerDay / SecondsPerHour); // allow for 24:00 -> not mod 24;
  m := Trunc(Value * SecondsPerDay / SecondsPerMinute) mod MinutesPerHour;
  s := Trunc(Value * SecondsPerDay) mod SecondsPerMinute;
  cs := Trunc(Value * SecondsPerDay * 100) mod 100;

  if not _IncludeSeconds then begin
    if s > 29 then begin
      Inc(m);
    end;
  end else if not _Include100th then begin
    if cs > 49 then
      Inc(s);
  end;
  if s > 59 then begin
    s := s - 60;
    Inc(m);
  end;
  if m > 59 then begin
    m := m - 60;
    Inc(h);
  end;

  Result := Format('%.2d:%.2d', [h, m]);
  if _IncludeSeconds then begin
    Result := Result + Format(':%.2d', [s]);
    if _Include100th then
      Result := Result + Format('%.2f', [cs / 100]);
  end;
end;

procedure TdzNullableTime.Decode(out _Hour, _Minutes, _Seconds, _MSeconds: Word);
begin
  DecodeTime(Value, _Hour, _Minutes, _Seconds, _MSeconds);
end;

procedure TdzNullableTime.Encode(_Hour, _Minutes, _Seconds, _MSeconds: Word);

  function TryEncodeTime(Hour, Min, Sec, MSec: Word; out Time: TDateTime): Boolean;
  // Copied from SysUtils.TryEncodeTime of Delphi 2007 with the following change:
  //   if (Hour < HoursPerDay) ....
  // changed to
  //   if (Hour <= HoursPerDay) ...
  // to allow for 24:00
  begin
    Result := False;
    if (Hour <= HoursPerDay) and (Min < MinsPerHour) and (Sec < SecsPerMin) and (MSec < MSecsPerSec) then begin
      Time := (Hour * (MinsPerHour * SecsPerMin * MSecsPerSec) +
        Min * (SecsPerMin * MSecsPerSec) +
        Sec * MSecsPerSec +
        MSec) / MSecsPerDay;
      Result := True;
    end;
  end;

begin
  if TryEncodeTime(_Hour, _Minutes, _Seconds, _MSeconds, FValue) then
    FIsValid := GetNullableTypesFlagInterface
  else
    FIsValid := nil;
end;

class operator TdzNullableTime.Explicit(_a: TdzNullableTime): string;
begin
  if _a.IsValid then
    Result := Time2Iso(_a.FValue)
  else
    Result := '';
end;

class function TdzNullableTime.FromVariant(_v: Variant): TdzNullableTime;
begin
  Result.AssignVariant(_v);
end;

class operator TdzNullableTime.Implicit(_Value: TDateTime): TdzNullableTime;
begin
  Result.FValue := Frac(_Value);
  Result.FIsValid := GetNullableTypesFlagInterface;
end;

class operator TdzNullableTime.Implicit(_a: TdzNullableTime): TDateTime;
begin
  Result := _a.Value;
end;

function TdzNullableTime.GetValue(out _Value: TDateTime): Boolean;
begin
  Result := IsValid;
  if Result then
    _Value := FValue;
end;

class operator TdzNullableTime.GreaterThan(_a, _b: TdzNullableTime): Boolean;
begin
  Result := (_a.Value > _b.Value);
end;

class operator TdzNullableTime.GreaterThanOrEqual(_a, _b: TdzNullableTime): Boolean;
begin
  Result := (_a.Value >= _b.Value);
end;

function TdzNullableTime.InHours: Extended;
begin
  Result := FValue * HoursPerDay;
end;

function TdzNullableTime.InMinutes: Extended;
begin
  Result := FValue * MinutesPerDay;
end;

function TdzNullableTime.InSeconds: Extended;
begin
  Result := FValue * SecondsPerDay;
end;

procedure TdzNullableTime.Invalidate;
begin
  FIsValid := nil;
end;

function TdzNullableTime.IsValid: Boolean;
begin
  Result := FIsValid <> nil;
end;

class operator TdzNullableTime.LessThan(_a, _b: TdzNullableTime): Boolean;
begin
  Result := (_a.Value < _b.Value);
end;

class operator TdzNullableTime.LessThanOrEqual(_a, _b: TdzNullableTime): Boolean;
begin
  Result := (_a.Value <= _b.Value);
end;

class operator TdzNullableTime.Subtract(_a, _b: TdzNullableTime): TdzNullableTimespan;
begin
  if _a.IsValid and _b.IsValid then
    Result.AssignDays(_a.Value - _b.Value)
  else
    Result.Invalidate;
end;

class function TdzNullableTime.Now: TdzNullableTime;
begin
  Result := SysUtils.Now;
end;

function TdzNullableTime.Value: TDateTime;
begin
  if not IsValid then
    raise EInvalidValue.Create(_('NullableTime value is invalid'));
  Result := FValue;
end;

end.

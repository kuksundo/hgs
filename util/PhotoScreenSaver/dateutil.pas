{*******************************************************}
{                                                       }
{         Delphi VCL Extensions (RX)                    }
{                                                       }
{         Copyright (c) 1995, 1996 AO ROSNO             }
{         Copyright (c) 1997 Master-Bank                }
{                                                       }
{*******************************************************}

unit DateUtil;

{$B-,V-,R-,Q-}
{$DEFINE RX_D3}

interface

function CurrentYear: Word;
function IsLeapYear(AYear: Integer): Boolean;
function DaysPerMonth(AYear, AMonth: Integer): Integer;
function FirstDayOfPrevMonth: TDateTime;
function LastDayOfPrevMonth: TDateTime;
function FirstDayOfNextMonth: TDateTime;
function ExtractDay(ADate: TDateTime): Word;
function ExtractMonth(ADate: TDateTime): Word;
function ExtractYear(ADate: TDateTime): Word;
function IncDate(ADate: TDateTime; Days, Months, Years: Integer): TDateTime;
function IncDay(ADate: TDateTime; Delta: Integer): TDateTime;
function IncMonth(ADate: TDateTime; Delta: Integer): TDateTime;
function IncYear(ADate: TDateTime; Delta: Integer): TDateTime;
function ValidDate(ADate: TDateTime): Boolean;
procedure DateDiff(Date1, Date2: TDateTime; var Days, Months, Years: Word);
function MonthsBetween2(Date1, Date2: TDateTime): Double;
function DaysInPeriod(Date1, Date2: TDateTime): Longint;
  { Count days between Date1 and Date2 + 1, so if Date1 = Date2 result = 1 }
function DaysBetween2(Date1, Date2: TDateTime): Longint;
  { The same as previous but if Date2 < Date1 result = 0 }
Function DateDiff2(Period: Word; Date2, Date1: TDatetime):Longint;

function IncTime(ATime: TDateTime; Hours, Minutes, Seconds, MSecs: Integer): TDateTime;
function IncHour(ATime: TDateTime; Delta: Integer): TDateTime;
function IncMinute(ATime: TDateTime; Delta: Integer): TDateTime;
function IncSecond(ATime: TDateTime; Delta: Integer): TDateTime;
function IncMSec(ATime: TDateTime; Delta: Integer): TDateTime;
function CutTime(ADate: TDateTime): TDateTime; { Set time to 00:00:00:00 }

type
  TDateOrder = (doMDY, doDMY, doYMD);
  TDayOfWeekName = (Sun, Mon, Tue, Wed, Thu, Fri, Sat);
  TDaysOfWeek = set of TDayOfWeekName;

{ String to date conversions }
function GetDateOrder(const DateFormat: string): TDateOrder;
function StrToDateDef(const S: string; Default: TDateTime): TDateTime;
function StrToDateFmt(const DateFormat, S: string): TDateTime;
function StrToDateFmtDef(const DateFormat, S: string; Default: TDateTime): TDateTime;
function DefDateFormat: string;
function DefDateMask(BlanksChar: Char): string;
function Find60Year(Year: integer): string;


const
  DefaultDateOrder = doDMY;

const
{$IFDEF WIN32}
  NullDate: TDateTime = {-693594} 0;
{$ELSE}
  NullDate: TDateTime = 0;
{$ENDIF}

var
  { affects DefDateFormat and DefDateMask }
  FourDigitYear: Boolean = True;

implementation

uses SysUtils, {$IFDEF WIN32} Windows, {$ENDIF} Consts;

function IsLeapYear(AYear: Integer): Boolean;
begin
  Result := (AYear mod 4 = 0) and ((AYear mod 100 <> 0) or (AYear mod 400 = 0));
end;

function DaysPerMonth(AYear, AMonth: Integer): Integer;
const
  DaysInMonth: array[1..12] of Integer =
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DaysInMonth[AMonth];
  if (AMonth = 2) and IsLeapYear(AYear) then Inc(Result); { leap-year Feb is special }
end;

function FirstDayOfNextMonth: TDateTime;
var
  Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  Day := 1;
  if Month < 12 then Inc(Month)
  else begin
    Inc(Year);
    Month := 1;
  end;
  Result := EncodeDate(Year, Month, Day);
end;

function FirstDayOfPrevMonth: TDateTime;
var
  Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  Day := 1;
  if Month > 1 then Dec(Month)
  else begin
    Dec(Year);
    Month := 12;
  end;
  Result := EncodeDate(Year, Month, Day);
end;

function LastDayOfPrevMonth: TDateTime;
var
  D: TDateTime;
  Year, Month, Day: Word;
begin
  D := FirstDayOfPrevMonth;
  DecodeDate(D, Year, Month, Day);
  Day := DaysPerMonth(Year, Month);
  Result := EncodeDate(Year, Month, Day);
end;

function ExtractDay(ADate: TDateTime): Word;
var
  M, Y: Word;
begin
  DecodeDate(ADate, Y, M, Result);
end;

function ExtractMonth(ADate: TDateTime): Word;
var
  D, Y: Word;
begin
  DecodeDate(ADate, Y, Result, D);
end;

function ExtractYear(ADate: TDateTime): Word;
var
  D, M: Word;
begin
  DecodeDate(ADate, Result, M, D);
end;

(*
function IncDate(ADate: TDateTime; Days, Months, Years: Integer): TDateTime;
var
  D, M, Y: Word;
  Day, Month, Year, DayCount, Day28Delta: Longint;
begin
  DecodeDate(ADate, Y, M, D);
  Year := Y; Month := M; Day := D;
  Day28Delta := Day - 28;
  if Day28Delta < 0 then Day28Delta := 0
  else Day := 28;
  Inc(Year, Years);
  Inc(Year, Months div 12);
  Inc(Month, Months mod 12);
  if Month < 1 then begin
    Inc(Month, 12);
    Dec(Year);
  end
  else if Month > 12 then begin
    Dec(Month, 12);
    Inc(Year);
  end;
  DayCount := Day + Day28Delta;
  while DayCount > DaysPerMonth(Year, Month) do begin
    Dec(DayCount, DaysPerMonth(Year, Month));
    Inc(Month);
    if Month > 12 then begin
      Dec(Month, 12);
      Inc(Year);
    end;
  end;
  Result := EncodeDate(Year, Month, DayCount) + Days;
end;

procedure DateDiff(Date1, Date2: TDateTime; var Days, Months, Years: Word);
var
  DtSwap: TDateTime;
  Day1, Day2, Month1, Month2, Year1, Year2: Word;
begin
  if Date1 > Date2 then begin
    DtSwap := Date1;
    Date1 := Date2;
    Date2 := DtSwap;
  end;
  DecodeDate(Date1, Year1, Month1, Day1);
  DecodeDate(Date2, Year2, Month2, Day2);
  if Day2 < Day1 then begin
    Dec(Month2);
    if Month2 = 0 then begin
      Month2 := 12;
      Dec(Year2);
    end;
    Inc(Day2, DaysPerMonth(Year2, Month2));
  end;
  Days := Day2 - Day1;
  if Month2 < Month1 then begin
    Inc(Month2, 12);
    Dec(Year2);
  end;
  Months := Month2 - Month1;
  Years := Year2 - Year1;
end;
*)

function IncDate(ADate: TDateTime; Days, Months, Years: Integer): TDateTime;
var
  D, M, Y: Word;
  Day, Month, Year: Longint;
begin
  DecodeDate(ADate, Y, M, D);
  Year := Y; Month := M; Day := D;
  Inc(Year, Years);
  Inc(Year, Months div 12);
  Inc(Month, Months mod 12);
  if Month < 1 then begin
    Inc(Month, 12);
    Dec(Year);
  end
  else if Month > 12 then begin
    Dec(Month, 12);
    Inc(Year);
  end;
  if Day > DaysPerMonth(Year, Month) then Day := DaysPerMonth(Year, Month);
  Result := EncodeDate(Year, Month, Day) + Days + Frac(ADate);
end;

procedure DateDiff(Date1, Date2: TDateTime; var Days, Months, Years: Word);
{ Changed by Anatoly A. Sanko (2:450/73) }
var
  DtSwap: TDateTime;
  Day1, Day2, Month1, Month2, Year1, Year2: Word;
begin
  if Date1 > Date2 then begin
    DtSwap := Date1;
    Date1 := Date2;
    Date2 := DtSwap;
  end;
  DecodeDate(Date1, Year1, Month1, Day1);
  DecodeDate(Date2, Year2, Month2, Day2);
  Years := Year2 - Year1;
  Months := 0;
  Days := 0;
  if Month2 < Month1 then begin
    Inc(Months, 12);
    Dec(Years);
  end;
  Inc(Months, Month2 - Month1);
  if Day2 < Day1 then begin
    Inc(Days, DaysPerMonth(Year1, Month1));
    if Months = 0 then begin
      Dec(Years);
      Months := 11;
    end
    else Dec(Months);
  end;
  Inc(Days, Day2 - Day1);
end;

function IncDay(ADate: TDateTime; Delta: Integer): TDateTime;
begin
  Result := ADate + Delta;
end;

function IncMonth(ADate: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncDate(ADate, 0, Delta, 0);
end;

function IncYear(ADate: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncDate(ADate, 0, 0, Delta);
end;

function MonthsBetween2(Date1, Date2: TDateTime): Double;
var
  D, M, Y, Ldays: Word;
  Year, Month, Day: Word;
begin
  DecodeDate(Date1, Year, Month, Day);
  
  DateDiff(Date1, Date2, D, M, Y);
  Result := 12 * Y + M;

  Ldays := DaysPerMonth(Year,Month);
  Result := Result + D/Ldays;

{  if (D > 1) and (D < 7) then Result := Result + 0.25
  else if (D >= 7) and (D < 15) then Result := Result + 0.5
  else if (D >= 15) and (D < 21) then Result := Result + 0.75
  else if (D >= 21) then Result := Result + 1;
}
end;

function IsValidDate(Y, M, D: Word): Boolean;
begin
  Result := (Y >= 1) and (Y <= 9999) and (M >= 1) and (M <= 12) and
    (D >= 1) and (D <= DaysPerMonth(Y, M));
end;

function ValidDate(ADate: TDateTime): Boolean;
var
  Year, Month, Day: Word;
begin
  try
    DecodeDate(ADate, Year, Month, Day);
    Result := IsValidDate(Year, Month, Day);
  except
    Result := False;
  end;
end;

function DaysInPeriod(Date1, Date2: TDateTime): Longint;
begin
  if ValidDate(Date1) and ValidDate(Date2) then
    Result := Abs(Trunc(Date2) - Trunc(Date1)) + 1
  else Result := 0;
end;

function DaysBetween2(Date1, Date2: TDateTime): Longint;
begin
  Result := Trunc(Date2) - Trunc(Date1) + 1;
  if Result < 0 then Result := 0;
end;

function IncTime(ATime: TDateTime; Hours, Minutes, Seconds,
  MSecs: Integer): TDateTime;
begin
  Result := ATime + (Hours div 24) + (((Hours mod 24) * 3600000 +
    Minutes * 60000 + Seconds * 1000 + MSecs) / MSecsPerDay);
end;

function IncHour(ATime: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncTime(ATime, Delta, 0, 0, 0);
end;

function IncMinute(ATime: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncTime(ATime, 0, Delta, 0, 0);
end;

function IncSecond(ATime: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncTime(ATime, 0, 0, Delta, 0);
end;

function IncMSec(ATime: TDateTime; Delta: Integer): TDateTime;
begin
  Result := IncTime(ATime, 0, 0, 0, Delta);
end;

function CutTime(ADate: TDateTime): TDateTime;
begin
  Result := Trunc(ADate);
end;

{ String to date conversions    }
{ Copied from SYSUTILS.PAS unit }

function CurrentYear: Word; {$IFNDEF WIN32} assembler; {$ENDIF}
{$IFDEF WIN32}
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wYear;
end;
{$ELSE}
asm
        MOV     AH,2AH
        INT     21H
        MOV     AX,CX
end;
{$ENDIF}

procedure ScanBlanks(const S: string; var Pos: Integer);
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and (S[I] = ' ') do Inc(I);
  Pos := I;
end;

function ScanNumber(const S: string; var Pos: Integer;
  var Number: Word): Boolean;
var
  I: Integer;
  N: Word;
begin
  Result := False;
  ScanBlanks(S, Pos);
  I := Pos;
  N := 0;
  while (I <= Length(S)) and (S[I] in ['0'..'9']) and (N < 1000) do begin
    N := N * 10 + (Ord(S[I]) - Ord('0'));
    Inc(I);
  end;
  if I > Pos then begin
    Pos := I;
    Number := N;
    Result := True;
  end;
end;

function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
begin
  Result := False;
  ScanBlanks(S, Pos);
  if (Pos <= Length(S)) and (S[Pos] = Ch) then begin
    Inc(Pos);
    Result := True;
  end;
end;

procedure ScanToNumber(const S: string; var Pos: Integer);
begin
  while (Pos <= Length(S)) and not (S[Pos] in ['0'..'9']) do begin
{$IFDEF RX_D3}
    if S[Pos] in LeadBytes then Inc(Pos);
{$ENDIF}
    Inc(Pos);
  end;
end;

function GetDateOrder(const DateFormat: string): TDateOrder;
var
  I: Integer;
begin
  Result := DefaultDateOrder;
  I := 1;
  while I <= Length(DateFormat) do begin
    case Chr(Ord(DateFormat[I]) and $DF) of
      'Y': Result := doYMD;
      'M': Result := doMDY;
      'D': Result := doDMY;
    else
      Inc(I);
      Continue;
    end;
    Exit;
  end;
  Result := DefaultDateOrder; { default }
end;

function ScanDate(const S, DateFormat: string; var Pos: Integer;
  var Date: TDateTime): Boolean;
var
  DateOrder: TDateOrder;
  N1, N2, N3, Y, M, D: Word;
begin
  Result := False;
  Y := 0; M := 0; D := 0;
  DateOrder := GetDateOrder(DateFormat);
{$IFDEF RX_D3}
  if ShortDateFormat[1] = 'g' then { skip over prefix text }
    ScanToNumber(S, Pos);
{$ENDIF RX_D3}
  if not (ScanNumber(S, Pos, N1) and ScanChar(S, Pos, DateSeparator) and
    ScanNumber(S, Pos, N2)) then Exit;
  if ScanChar(S, Pos, DateSeparator) then begin
    if not ScanNumber(S, Pos, N3) then Exit;
    case DateOrder of
      doMDY: begin Y := N3; M := N1; D := N2; end;
      doDMY: begin Y := N3; M := N2; D := N1; end;
      doYMD: begin Y := N1; M := N2; D := N3; end;
    end;
    if Y <= 99 then Inc(Y, CurrentYear div 100 * 100);
  end
  else begin
    Y := CurrentYear;
    if DateOrder = doDMY then begin
      D := N1; M := N2;
    end
    else begin
      M := N1; D := N2;
    end;
  end;
  ScanChar(S, Pos, DateSeparator);
  ScanBlanks(S, Pos);
{$IFDEF RX_D3}
  if SysLocale.FarEast and (System.Pos('ddd', ShortDateFormat) <> 0) then
  begin { ignore trailing text }
    if ShortTimeFormat[1] in ['0'..'9'] then  { stop at time digit }
      ScanToNumber(S, Pos)
    else  { stop at time prefix }
      repeat
        while (Pos <= Length(S)) and (S[Pos] <> ' ') do Inc(Pos);
        ScanBlanks(S, Pos);
      until (Pos > Length(S)) or
        (AnsiCompareText(TimeAMString, Copy(S, Pos, Length(TimeAMString))) = 0) or
        (AnsiCompareText(TimePMString, Copy(S, Pos, Length(TimePMString))) = 0);
  end;
{$ENDIF RX_D3}
  if IsValidDate(Y, M, D) then
    try
      Date := EncodeDate(Y, M, D);
      Result := True;
    except
      Result := False;
    end;
end;

function StrToDateFmt(const DateFormat, S: string): TDateTime;
var
  Pos: Integer;
begin
  Pos := 1;
  if not ScanDate(S, DateFormat, Pos, Result) or (Pos <= Length(S)) then
    raise EConvertError.CreateFmt('Invalid Date: "%s"', [S]);
end;

function StrToDateDef(const S: string; Default: TDateTime): TDateTime;
var
  Pos: Integer;
begin
  Pos := 1;
  if not ScanDate(S, ShortDateFormat, Pos, Result) or (Pos <= Length(S)) then
    Result := Trunc(Default);
end;

function StrToDateFmtDef(const DateFormat, S: string; Default: TDateTime): TDateTime;
var
  Pos: Integer;
begin
  Pos := 1;
  if not ScanDate(S, DateFormat, Pos, Result) or (Pos <= Length(S)) then
    Result := Trunc(Default);
end;

function DefDateFormat: string;
begin
  if FourDigitYear then begin
    case GetDateOrder(ShortDateFormat) of
      doMDY: Result := 'MM/DD/YYYY';
      doDMY: Result := 'DD/MM/YYYY';
      doYMD: Result := 'YYYY/MM/DD';
    end;
  end
  else begin
    case GetDateOrder(ShortDateFormat) of
      doMDY: Result := 'MM/DD/YY';
      doDMY: Result := 'DD/MM/YY';
      doYMD: Result := 'YY/MM/DD';
    end;
  end;
end;

function DefDateMask(BlanksChar: Char): string;
begin
  if FourDigitYear then begin
    case GetDateOrder(ShortDateFormat) of
      doMDY, doDMY: Result := '!99/99/9999;1;';
      doYMD: Result := '!9999/99/99;1;';
    end;
  end
  else begin
    case GetDateOrder(ShortDateFormat) of
      doMDY, doDMY: Result := '!99/99/99;1;';
      doYMD: Result := '!99/99/99;1;';
    end;
  end;
  if Result <> '' then Result := Result + BlanksChar;
end;

//육십갑자 찾는 함수
function Find60Year(Year: integer): string;
var
  i, j,cnt,tcnt : integer;
  tmp : integer;
   ArrayGanEsy : array [1..60] of string;
const
  cGan: array[1..10] of String = ('갑', '을', '병', '정', '무', '기',
                                  '경', '신', '임', '계');
  cEsy: array[1..12] of String = ('자', '축', '인', '묘', '진', '사',
                                  '오', '미', '신', '유', '술', '해');
  cYear = 1984;
  cGanEsy = 1;
begin
  cnt := 12;
  tcnt := 1;
  FillChar(ArrayGanEsy, Sizeof(ArrayGanEsy), #0);
  for i := 1 to 6 do
  begin
    for j := 1 to 10 do
    begin
      if cnt = 12 then cnt := 1
      else
        Inc(cnt);
      ArrayGanEsy[tcnt] := cGan[j] + cEsy[cnt];
      Inc(tcnt);
    end;
  end;

  tmp := (Year - cYear) mod 60;

  if tmp < 0 then
    tmp := 60 + tmp;
  Result := ArrayGanEsy[tmp+cGanEsy];
end;

//두 날짜의 차이를 여러가지 형태의 값을 반환함(Date1-Date2)
//Period = 1 : 초 단위까지 초로 반환함
//         2 : 분 단위까지 분으로 반환함
//         3 : 시간 단위까지 시간으로 반환함
//         4 : 일자
//         5 : 주
//         6 : 월
//         7 : 년
Function DateDiff2(Period: Word; Date2, Date1: TDatetime):Longint;
Var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;  //These are for Date 1
  Year1, Month1, Day1, Hour1, Min1, Sec1, MSec1: Word; //these are for Date 2
Begin
  //Decode Dates Before Starting
  //This is probably ineficient but it will save doing it for each
  //different Period.
  DecodeDate(Date1, Year, Month, Day);
  DecodeDate(Date2, Year1, Month1, Day1);
  DecodeTime(Date1, Hour, Min, Sec, MSec);
  DecodeTime(Date2, Hour1, Min1, Sec1, MSec1);

  //Default Return will be 0
  Result := 0;

  //Once Decoded Select Type of DateDiff To Return via Period Parameter
  Case Period of
    1:  //Seconds
      Begin
        //first work out days then * days by 86400 (mins in day)
        //Then minus the difference in hours * 3600
        //then minus the difference in minutes * 60
        //Then get the difference in seconds
        Result := (((((Trunc(Date1) - Trunc(Date2))* 86400) - ((Hour1 - Hour)* 3600))) - ((Min1 - Min) * 60)) - (Sec1 - Sec);
      end;
    2: //Minutes
      Begin
        //first work out days then * days by 1440 (mins in day)
        //Then minus the difference in hours * 60
        //then minus the difference in minutes
        Result := (((Trunc(Date1) - Trunc(Date2))* 1440) - ((Hour1 - Hour)* 60)) - (Min1 - Min);
      End;
    3: //hours
      Begin
        //First work out in days then * days by 24 to get hours
        //then clculate diff in Hours1 and Hours
        Result := ((Trunc(Date1) - Trunc(Date2))* 24) - (Hour1 - Hour);
      End;
    4: //Days
      Begin
        //Trunc the two dates and return the difference
        Result := Trunc(Date1) - Trunc(Date2);
      End;
    5: //Weeks
      Begin
        //Trunc the two dates and divide
        //result by seven for weeks
        Result := (Trunc(Date1) - Trunc(Date2)) div 7;
      end;
    6: //Months
      Begin
        //Take Diff in Years and * 12 then add diff in months
        Result := ((Year - Year1) * 12) + (Month - Month1);
      End;
    7: //Years
      Begin
        //Take Difference In Years and Return result
        Result := Year - Year1;
      End
    Else ;//Invalid Period *** Raise Exception ***
  End;//case
End;

initialization
  FourDigitYear := Pos('YYYY', AnsiUpperCase(ShortDateFormat)) > 0;
end.
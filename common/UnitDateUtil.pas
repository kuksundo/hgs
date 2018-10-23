unit UnitDateUtil;

interface

uses SysUtils, System.DateUtils;

//날짜를 입력 받아서 분기를 반환함
function QuarterOf(ADate: TDateTime): word;
//년도와 분기를 입력 받아서 분기의 첫번째 날짜를 반환함
function GetDateFromQuarter(AYear, AQuarter: word): TDateTime;
function DateTimeMinusInteger(d1:TDateTime;i:integer;mType:integer;Sign:Char):TDateTime;

implementation

function QuarterOf(ADate: TDateTime): word;
begin
  Result := MonthOf(ADate);

  if Result <= 3 then
    Result := 1
  else if (Result > 3) and (Result <= 6)  then
    Result := 2
  else if (Result > 6) and (Result <= 9)  then
    Result := 3
  else if (Result > 9) and (Result <= 12)  then
    Result := 4;
end;

function GetDateFromQuarter(AYear, AQuarter: word): TDateTime;
var
  Lm: word;
begin
  case AQuarter of
    1: Lm := 1;
    2: Lm := 4;
    3: Lm := 7;
    4: Lm := 10;
  end;

  Result := EncodeDate(AYear, Lm, 1);
end;

//날짜에서 정수를 빼거나 더해서 반환함
//mType = 1 : '시간'에서 정수를 빼거나 더함
//        2 : '분'에서 정수를 빼거나 더함
//        3 : '초에서 정수를 빼거나 더함
//        4 : '년'에서 정수를 빼거나 더함
//        5 : '월' 에서 정수를 빼거나 더함
// '일'자는 바로 정수를 빼거나 더함도 가능함
function DateTimeMinusInteger(d1:TDateTime;i:integer;mType:integer;Sign:Char)
                                                                    :TDateTime;
var hour,min,sec,msec:word;
    year,mon,dat: word;
    tmp: integer;
begin
  Decodetime(d1,hour,min,sec,msec);
  Decodedate(d1,year,mon,dat);

  case mType of
    1:begin//시간
        tmp := 24;
      end;
    2:begin//분
        tmp := 24*60;
      end;
    3:begin//초
        tmp := 24*60*60;
      end;
    4:begin//년
      end;
    5:begin//월
      end;
  end;

  if Sign = '+' then
    Result := d1 + (i/tmp)
  else
    Result := d1 - (i/tmp);
end;

end.

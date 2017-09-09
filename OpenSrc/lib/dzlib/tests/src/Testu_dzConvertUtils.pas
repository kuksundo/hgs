unit Testu_dzConvertUtils;

interface

uses
  Windows,
  Classes,
  SysUtils,
  TestFramework,
  u_dzConvertUtils,
  u_dzUnitTestUtils;

type
  TestDecimalConversion = class(TdzTestCase)
  protected
    FDecDigit2LongOutOfRangeValue: char;
    procedure DecDigit2LongOutOfRange;
  published
    procedure TestIsDecDigit;
    procedure TestisDec(const _s: string);
    procedure TestDecDigit2Long(_a: char);
    procedure TestDec2Long(const _s: string);
    procedure TestLong2Dec2(_l: ULong);
    procedure TestLong2Dec4(_l: ULong);
    procedure TestLong2DecN(_l: ULong; _n: ULong);
    procedure TestLong2Dec(_l: ULong);
    procedure TestSwap16;
    procedure TestSwap32;
  end;

implementation

{ TestDecimalConversion }

procedure TestDecimalConversion.TestDec2Long(const _s: string);
begin
end;

procedure TestDecimalConversion.DecDigit2LongOutOfRange;
begin
  CheckEquals(0, DecDigit2Long(FDecDigit2LongOutOfRangeValue));
end;

procedure TestDecimalConversion.TestDecDigit2Long(_a: char);
var
  c: char;
begin
  for c := chr(0) to chr(255) do begin
    if c in ['0'..'9'] then
      CheckEquals(Ord(c) - Ord('0'), DecDigit2Long(c))
    else begin
      FDecDigit2LongOutOfRangeValue := c;
      CheckException(DecDigit2LongOutOfRange, EDigitOutOfRange);
    end;
  end;
end;

procedure TestDecimalConversion.TestisDec(const _s: string);
begin
  CheckTrue(isDec('0'));
  CheckTrue(isDec('1'));
  CheckTrue(isDec('12'));
  CheckTrue(isDec('18945'));
  CheckTrue(isDec('0845'));
  CheckTrue(isDec('000000'));
  CheckTrue(isDec('90894514908'));
  CheckFalse(isDec('a'));
  CheckFalse(isDec('1a425'));
  CheckFalse(isDec('-2345'));
  CheckFalse(isDec('0000001a'));
end;

procedure TestDecimalConversion.TestIsDecDigit;
var
  c: char;
begin
  for c := chr(0) to chr(255) do
    if c in ['0'..'9'] then
      CheckTrue(isDecDigit(c))
    else
      CheckFalse(isDecDigit(c));
end;

procedure TestDecimalConversion.TestLong2Dec(_l: ULong);
begin

end;

procedure TestDecimalConversion.TestLong2Dec2(_l: ULong);
begin

end;

procedure TestDecimalConversion.TestLong2Dec4(_l: ULong);
begin

end;

procedure TestDecimalConversion.TestLong2DecN(_l, _n: ULong);
begin

end;

procedure TestDecimalConversion.TestSwap16;
var
  i: Integer;
begin
  for i := 0 to $FFFF do begin
    CheckEquals(i shr 8 + ((i and $FF) shl 8), Swap16(i));
  end;
end;

procedure TestDecimalConversion.TestSwap32;
var
  i: LongWord;
begin
  i := 0;
  // to prevent an integer overflow we can not use while i <= $FFFFFFFF do
  while true do begin
    CheckEquals(i shr 24 + ((i shr 16) and $FF) shl 8 + ((i shr 8 and $FF) shl 16) + ((i and $FF) shl 24), Swap32(i));
    if i <= $FFFFFFFF then
      Inc(i)
    else
      break;
  end;
end;

initialization
  RegisterTest(TestDecimalConversion.Suite);
end.


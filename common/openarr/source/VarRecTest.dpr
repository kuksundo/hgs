program VarRecTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  VarRecUtils in 'VarRecUtils.pas';

const
  Months: array[1..12] of Integer = (31, 28, 31, 30, 31, 30,
                                     31, 31, 30, 31, 30, 31);

procedure ListAllIntegers(AnArray: array of Integer);
var
  I: Integer;
begin
  for I := Low(AnArray) to High(AnArray) do
    WriteLn('Integer at ', I, ' is ', AnArray[I]);
end;

var
  ConstArray: TConstArray;

begin
  ConstArray := CreateConstArray([1, 'Hello', 7.9, IntToStr(1234)]);
  try
    Writeln(Format('%d --- %s --- %0.2f --- %s', ConstArray));
    Writeln(Format('%s -- %0.2f', Copy(ConstArray, 1, 2)));
  finally
    FinalizeConstArray(ConstArray);
  end;
  ListAllIntegers(Slice(Months, 6));
  Readln;
end.

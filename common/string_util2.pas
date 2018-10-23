unit string_util2;

interface

function DeleteSpaces(AValue: String): String;
function FloatToStrEx(Value: Extended): String;
function StrToFloatEx(AValue: String): Extended;

implementation

function DeleteSpaces(AValue: String): String;
begin
  Result := AnsiReplaceStr(AnsiReplaceStr(AValue, #160, ''), ' ', '');
end;

function FloatToStrEx(Value: Extended): String;
var
  i, p: Integer;
begin
  Result := Format('%1.2n', [Value]);
  p := Pos(DecimalSeparator, Result);

  if p > 0 then
  begin
    for i := Length(Result) downto p do
      if (Result[i] <> '0') and (Result[i] <> DecimalSeparator) then
        break;

      SetLength(Result, i);
  end;

//  if Result = '0' then
//    Result := '';
end;

function StrToFloatEx(AValue: String): Extended;
var
  s: String;
begin
  s := DeleteSpaces(AValue);

  if DecimalSeparator <> '.' then
    s := AnsiReplaceStr(s, '.', DecimalSeparator);

  Result := StrToFloatDef(s, 0);
end;

end.

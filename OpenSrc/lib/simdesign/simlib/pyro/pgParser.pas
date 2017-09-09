{ Project: Pyro
  Module: Pyro Core

  Description:
  Utility routines for parsing text.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2004 - 2011 SimDesign BV

  Creation Date:
  13Dec2004

  Modified:
  14apr2011: placed parsing funcs in TpgParser
  19may2011: string > Utf8String
  23jun2011: implemented writer

}
unit pgParser;

{$i simdesign.inc}

interface

uses
  SysUtils, NativeXml, sdDebug, Pyro;

type

  // lowlevel parser for SVG scene parsing. These could be just standalone functions but
  // this parser class allows DoDebugOut, so neater
  TpgParser = class(TsdDebugPersistent)
  public
    // Parse an integer from the string Value starting at NextPos, and adjust NextPos
    // to the position after the integer
    function pgParseInteger(const Value: Utf8String; var NextPos: integer): integer; overload;
    function pgParseInteger(const Value: Utf8String): integer; overload;
    // Parse a float from the string Value starting at Nextpos, and adjust NextPos
    // to the position after the integer
    function pgParseFloat(const Value: Utf8String; var NextPos: integer): double; overload;
    function pgParseFloat(const Value: Utf8String): double; overload;
    // parse length
    function pgParseLength(const Value: Utf8String; var Units: TpgLengthUnits; var FloatValue: double): boolean;
    // Parse a list of float values which can be separated by comma or space
    procedure pgParseFloatArray(const Value: Utf8String; var FloatValues: array of double; var Count: integer);
    // Parse a list of lengths which can be separated by comma or space
    procedure pgParseLengthArray(const Value: Utf8String; var Units: array of TpgLengthUnits;
      var FloatValues: array of double; var Count: integer);
  end;

  // lowlevel writer (same philosophy)
  TpgWriter = class(TsdDebugPersistent)
    // write hex notation
    function pgWriteHex(const IntValue: integer; Digits: integer): Utf8String;
    // write color RGB value as #rrggbb
    function pgWriteRGB(const CardinalValue: cardinal): Utf8String;
    // write integer
    function pgWriteInteger(const IntValue: integer): Utf8String;
    // write float
    function pgWriteFloat(const FloatValue: double): Utf8String;
    // write units
    function pgWriteUnits(const Units: TpgLengthUnits): Utf8String;
    // write length
    function pgWriteLength(const Units: TpgLengthUnits; const FloatValue: double): Utf8String;
  end;

// Break Source string on Match, return first part and store second part in
// Second, trim the result if TrimResult is true, if the match does not exist then
// only return a non-empty string if MustExist is False
function BreakString(const Source, Match: Utf8String; var Second: Utf8String; TrimResult, MustExist: boolean): Utf8String;

// Condition the string by replacing commas, CR and LF by spaces
function pgConditionListString(const Value: Utf8String): Utf8String;

// Skip commas and whitespace chars
procedure SkipCommaWS(const Value: Utf8String; var NextPos: integer);

resourcestring
  spsInvalidNumber         = 'Invalid number (%s)';
  spsInvalidUnitSpecifier  = 'Invalid unit specifier';

implementation

{ TpgParser }

function TpgParser.pgParseFloat(const Value: Utf8String): double;
var
  NextPos: integer;
begin
  NextPos := 1;
  Result := pgParseFloat(Value, NextPos);
end;

function TpgParser.pgParseFloat(const Value: Utf8String; var NextPos: integer): double;
var
  Sign: integer;
  NumStr: Utf8String;
begin
  Result := 0;

  // Sign
  if length(Value) < NextPos then
  begin
    DoDebugOut(Self, wsFail, spsInvalidNumber);
    exit;
  end;
  Sign := 1;
  if Value[NextPos] in ['-','+'] then
  begin
    if Value[NextPos] = '-' then Sign := -1;
    inc(NextPos);
  end;
  if length(Value) < NextPos then
  begin
    DoDebugOut(Self, wsFail, spsInvalidNumber);
    exit;
  end;

  // Base
  NumStr := '';
  while length(Value) >= NextPos do
  begin
    if not (Value[NextPos] in ['0'..'9']) then
      break;
    NumStr := NumStr + Value[NextPos];
    inc(NextPos);
  end;

  if (length(NumStr) = 0) and ((length(Value) < NextPos) or (Value[NextPos] <> '.')) then
  begin
    // cases like 'none'
    DoDebugOut(Self, wsWarn, Format(spsInvalidNumber, [Value]));
    Result := 0;
    exit;
  end;
  Result := StrToIntDef(NumStr, 0) * Sign;
  if length(Value) < NextPos then
    exit;
  if Value[NextPos] = '.' then
    inc(NextPos);
  if length(Value) < NextPos then
    exit;

  // Fraction
  NumStr := '';
  while length(Value) >= NextPos do
  begin
    if not (Value[NextPos] in ['0'..'9']) then
      break;
    NumStr := NumStr + Value[NextPos];
    inc(NextPos);
  end;
  if length(NumStr) > 0 then
    Result := Result + Sign * StrToInt(NumStr) / pgIntPower(10, length(NumStr));

  // Scientific
  if length(Value) < NextPos + 1 then
    exit;
  if not ((Value[NextPos] in ['e', 'E']) and (Value[NextPos + 1] in ['0'..'9', '+', '-'])) then
    exit;
  NextPos := NextPos + 1;
  Result := Result * pgIntPower(1, pgParseInteger(Value, NextPos));
end;

function TpgParser.pgParseInteger(const Value: Utf8String; var NextPos: integer): integer;
var
  Sign: integer;
  NumStr: Utf8String;
begin
  Result := 0;
  if length(Value) <= NextPos then
  begin
    DoDebugOut(Self, wsWarn, Format(spsInvalidNumber, [Value]));
    exit;
  end;

  Sign := 1;
  if Value[NextPos] in ['-','+'] then
  begin
    if Value[NextPos] = '-' then Sign := -1;
    inc(NextPos);
  end;
  if length(Value) < NextPos then
  begin
    DoDebugOut(Self, wsWarn, Format(spsInvalidNumber, [Value]));
    exit;
  end;

  // Base
  NumStr := '';
  while length(Value) >= NextPos do
  begin
    if not (Value[NextPos] in ['0'..'9']) then
      break;
    NumStr := NumStr + Value[NextPos];
    inc(NextPos);
  end;
  if length(NumStr) = 0 then
  begin
    DoDebugOut(Self, wsWarn, Format(spsInvalidNumber, [Value]));
    exit;
  end;
  Result := Sign * StrToInt(NumStr);
end;

function TpgParser.pgParseInteger(const Value: Utf8String): integer;
var
  NextPos: integer;
begin
  Result := pgParseInteger(Value, NextPos);
end;

function TpgParser.pgParseLength(const Value: Utf8String; var Units: TpgLengthUnits; var FloatValue: double): boolean;
var
  i: TpgLengthUnits;
  Pos: integer;
  UnitStr: Utf8String;
begin
  Result := True;
  Pos := 1;

  // float value
  FloatValue := pgParseFloat(Value, Pos);

  // units
  UnitStr := lowercase(trim(copy(Value, Pos, length(Value))));
  // 'px' forwards to ''
  if UnitStr = 'px' then
    UnitStr := '';

  for i := low(TpgLengthUnits) to high(TpgLengthUnits) do
  begin
    if cpgLengthUnitsInfo[i].Name = UnitStr then
    begin
      Units := cpgLengthUnitsInfo[i].Units;
      exit;
    end;
  end;

  // still here?
  DoDebugOut(Self, wsWarn, format('invalid length units %s', [UnitStr]));
  Result := False;
end;

procedure TpgParser.pgParseFloatArray(const Value: Utf8String; var FloatValues: array of double; var Count: integer);
var
  MaxCount, APos: integer;
  NumStr, Next: Utf8String;
begin
  Next := pgConditionListString(Value);
  MaxCount := Count;
  FillChar(FloatValues[0], MaxCount * SizeOf(double), 0);
  Count := 0;
  while Count < MaxCount do
  begin
    NumStr := BreakString(Next, ' ', Next, True, False);
    if length(NumStr) = 0 then
      break;
    APos := 1;
    FloatValues[Count] := pgParseFloat(NumStr, APos);
    inc(Count);
  end;
end;

procedure TpgParser.pgParseLengthArray(const Value: Utf8String; var Units: array of TpgLengthUnits;
  var FloatValues: array of double; var Count: integer);
var
  MaxCount: integer;
  NumStr, Next: Utf8String;
begin
  Next := pgConditionListString(Value);
  MaxCount := Count;
  Count := 0;
  while Count < MaxCount do
  begin
    NumStr := BreakString(Next, ' ', Next, True, False);
    if length(NumStr) = 0 then
      break;
    pgParseLength(NumStr, Units[Count], FloatValues[Count]);
    inc(Count);
  end;
end;

{ TpgWriter }

function TpgWriter.pgWriteFloat(const FloatValue: double): Utf8String;
begin
  Result := sdFloatToString(FloatValue, 6, False); // sign digits and allowscientif
end;

function TpgWriter.pgWriteHex(const IntValue: integer; Digits: integer): Utf8String;
begin
  Result := Utf8String(IntToHex(IntValue, Digits));
end;

function TpgWriter.pgWriteRGB(const CardinalValue: cardinal): Utf8String;
begin
  Result := '#' + Utf8String(IntToHex(cardinalValue and $FFFFFF, 6));
end;

function TpgWriter.pgWriteInteger(const IntValue: integer): Utf8String;
begin
//  Result := IntToUTF8Str(IntValue);todo
end;

function TpgWriter.pgWriteLength(const Units: TpgLengthUnits; const FloatValue: double): Utf8String;
begin
  Result := pgWriteFloat(FloatValue) + pgWriteUnits(Units);
end;

function TpgWriter.pgWriteUnits(const Units: TpgLengthUnits): Utf8String;
begin
  Result := cpgLengthUnitsInfo[Units].Name;
end;

{ functions }

function BreakString(const Source, Match: Utf8String; var Second: Utf8String; TrimResult, MustExist: boolean): Utf8String;
var
  APos: integer;
begin
  Result := '';
  APos := AnsiPos(Match, Source);
  if APos > 0 then
  begin
    Result := copy(Source, 1, APos - 1);
    Second := copy(Source, APos + 1, length(Source));
    if TrimResult then
    begin
      Result := trim(Result);
      Second := trim(Second);
    end;
  end else
  begin
    if MustExist then
    begin
      if TrimResult then
        Second := trim(Source)
      else
        Second := Source;
    end else
    begin
      if TrimResult then
        Result := trim(Source)
      else
        Result := Source;
      Second := '';
    end;
  end;
end;

function pgConditionListString(const Value: Utf8String): Utf8String;
begin
  //todo: not very efficient
  Result := StringReplace(Value, ',', ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #$A, ' ', [rfReplaceAll]);
  Result := trim(StringReplace(Result, #$D, ' ', [rfReplaceAll]));
end;

procedure SkipCommaWS(const Value: Utf8String; var NextPos: integer);
begin
  while (length(Value) >= NextPos) and (Value[NextPos] in [',', #9, #10, #13, #32]) do
    inc(NextPos);
end;

end.

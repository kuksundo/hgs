{ *********************************************************************** }
{                                                                         }
{ TextUtils                                                               }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit TextUtils;

{$B-}
{$I Directives.inc}

interface

uses
  Windows, SysUtils, {$IFNDEF DELPHI_7}Classes,{$ENDIF} Types, TextConsts;

type
  TFromType = (ftStart, ftEnd);

const
  DigitCount = 2;

{$IFNDEF DELPHI_7}
  CSTR_LESS_THAN = 1;
  CSTR_EQUAL = 2;
  CSTR_GREATER_THAN = 3;
{$ENDIF}

{$IFNDEF DELPHI_7}
function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
function GetValueFromIndex(Strings: TStrings; Index: Integer): string;
procedure SetValueFromIndex(Strings: TStrings; Index: Integer; const Value: string);
{$ENDIF}

{$IFNDEF UNICODE}
function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean; overload;
function CharInSet(C: WideChar; const CharSet: TSysCharSet): Boolean; overload;
{$ENDIF}

function TextCopy(const Target: PChar; const Size: Integer; const Source: string): Integer;
function CompareText(AText, BText: PChar; Size: Integer): Integer;
function SameText(AText, BText: PChar; Size: Integer): Boolean; overload;
function SameText(const AText, BText: string): Boolean; overload;
function Consists(const Text: string; CharSet: TSysCharSet): Boolean;
function Contains(const Text, SubText: string): Boolean;

function DeleteText(var Text: string; Count: Integer; FromType: TFromType = ftStart;
  Cut: Boolean = True): Boolean;
function CutText(const Text: string; CharSet: TSysCharSet; MaxCount: Integer = 0): string; overload;
function CutText(const Text: string; CharSet: TSysCharSet; FromType: TFromType;
  MaxCount: Integer = 0): string; overload;
function CutText(var Text: string; const SubText: string;
  Cut: Boolean = True): Boolean; overload;

function IndexOfSubText(const Text, Delimiter, SubText: string): Integer;
function Extract(const Text, Delimiter: string; Index: Integer): string;
function SubText(const Text, Delimiter: string; Index: Integer): string;
function SubTextCount(const Text, SubText: string): Integer;
function ReplaceSubText(const Text, SubText, NewSubText: string): string;

function Split(Text: string; const Delimiter: string; var StringArray: TStringDynArray;
  MaxCount: Integer = 0): Boolean;
function Write(const Text, Delimiter: string; var StringArray: TStringDynArray;
  MaxCount: Integer = 0): Boolean;
function DelimitedText(const Text, Delimiter, NewDelimiter: string;
  Index, Count: Integer): string; overload;
function DelimitedText(StringArray: TStringDynArray; const Delimiter: string;
  MaxCount: Integer = 0): string; overload;

function Duplicate(const Text: string; Index: Integer): Boolean;

function EmptyArray(StringArray: TStringDynArray): Boolean;
function ArrayValue(StringArray: TStringDynArray; Index: Integer;
  Cut: Boolean = True): string; overload;
function ArrayValue(StringArray: TStringDynArray; Index: Integer;
  Default: Integer; Cut: Boolean = True): Integer; overload;
function ArrayValue(StringArray: TStringDynArray; Index: Integer;
  Default: Single; Cut: Boolean = True): Single; overload;
function ArrayValue(StringArray: TStringDynArray; Index: Integer;
  Default: Double; Cut: Boolean = True): Double; overload;

function Encode(const Text: string; MultiLine: Boolean = False;
  CharSet: TSysCharSet = []): string;
function Decode(const Text: string; CharSet: TSysCharSet = []): string;

function CreateGuid(Guid: PGuid = nil): string;

implementation

uses
  MemoryUtils, {$IFNDEF DELPHI_7}NumberConsts, {$ENDIF}StrUtils, TextBuilder;

{$IFNDEF DELPHI_7}

function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;

function GetValueFromIndex(Strings: TStrings; Index: Integer): string;
begin
  if Index < 0 then Result := ''
  else Result := SubText(Strings[Index], Equal, BIndex);
end;

procedure SetValueFromIndex(Strings: TStrings; Index: Integer; const Value: string);
begin
  if Value <> '' then
  begin
    if Index < 0 then Index := Strings.Add('');
    Strings[Index] := Strings.Names[Index] + Equal + Value;
  end
  else if Index >= 0 then Strings.Delete(Index);
end;

{$ENDIF}

{$IFNDEF UNICODE}

function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;

function CharInSet(C: WideChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := (C < #$0100) and (AnsiChar(C) in CharSet);
end;

{$ENDIF}

function TextCopy(const Target: PChar; const Size: Integer; const Source: string): Integer;
begin
  Result := Length(Source);
  if Result > Size - 1 then Result := Size - 1;
  StrLCopy(Target, PChar(Source), Result);
end;

function CompareText(AText, BText: PChar; Size: Integer): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, AText, Size, BText, Size);
end;

function SameText(AText, BText: PChar; Size: Integer): Boolean;
begin
  Result := CompareText(AText, BText, Size) = CSTR_EQUAL;
end;

function SameText(const AText, BText: string): Boolean;
var
  I: Integer;
begin
  I := Length(AText);
  Result := (I = Length(BText)) and ((I = 0) or SameText(PChar(AText), PChar(BText), I));
end;

function Consists(const Text: string; CharSet: TSysCharSet): Boolean;
var
  I: Integer;
begin
  Result := Text <> '';
  if Result then
  begin
    for I := 1 to Length(Text) do
      if not CharInSet(Text[I], CharSet) then
      begin
        Result := False;
        Exit;
      end;
    Result := True;
  end;
end;

function Contains(const Text, SubText: string): Boolean;
begin
  Result := Pos(SubText, Text) > 0;
end;

function DeleteText(var Text: string; Count: Integer; FromType: TFromType;
  Cut: Boolean): Boolean;
begin
  Result := Count <= Length(Text);
  if Result then
    case FromType of
      ftEnd:
        if Cut then Text := TrimRight(Copy(Text, 1, Length(Text) - Count))
        else Text := Copy(Text, 1, Length(Text) - Count);
    else
      if Cut then Text := TrimLeft(Copy(Text, Count + 1, Length(Text) - Count))
      else Text := Copy(Text, Count + 1, Length(Text) - Count);
    end;
end;

function CutText(const Text: string; CharSet: TSysCharSet; MaxCount: Integer): string;
var
  I, J: Integer;
begin
  I := 1;
  J := Length(Text);
  while (I <= J) and CharInSet(Text[I], CharSet) and ((MaxCount = 0) or (MaxCount >= I)) do Inc(I);
  if I > J then Result := ''
  else begin
    if MaxCount > 0 then MaxCount := J - MaxCount + 1;
    while CharInSet(Text[J], CharSet) and ((MaxCount = 0) or (MaxCount <= J)) do Dec(J);
    Result := Copy(Text, I, J - I + 1);
  end;
end;

function CutText(const Text: string; CharSet: TSysCharSet; FromType: TFromType;
  MaxCount: Integer): string;
var
  I, J: Integer;
begin
  case FromType of
    ftEnd:
      begin
        I := Length(Text);
        if MaxCount > 0 then MaxCount := I - MaxCount + 1;
        while (I > 0) and CharInSet(Text[I], CharSet) and
          ((MaxCount = 0) or (MaxCount <= I)) do Dec(I);
        Result := Copy(Text, 1, I);
      end;
  else
    I := 1;
    J := Length(Text);
    while (I <= J) and CharInSet(Text[I], CharSet) and
      ((MaxCount = 0) or (MaxCount >= I)) do Inc(I);
    Result := Copy(Text, I, MaxInt);
  end;
end;

function CutText(var Text: string; const SubText: string; Cut: Boolean): Boolean;
var
  I: Integer;
begin
  I := Length(SubText);
  Result := (I <= Length(Text)) and SameText(PChar(Text), PChar(SubText), I);
  if Result then DeleteText(Text, I, ftStart, Cut);
end;

function IndexOfSubText(const Text, Delimiter, SubText: string): Integer;
var
  I: Integer;
begin
  if TextUtils.SameText(Text, SubText) then Result := 0
  else begin
    for I := 0 to SubTextCount(Text, Delimiter) do
      if TextUtils.SameText(TextUtils.SubText(Text, Delimiter, I), SubText) then
      begin
        Result := I;
        Exit;
      end;
    Result := -1;
  end;
end;

function Extract(const Text, Delimiter: string; Index: Integer): string;
begin
  Result := SubText(Text, Delimiter, Index);
  if (Index = 0) and (Result = '') and not AnsiStartsText(Delimiter, Text) then
    Result := Text;
end;

function SubText(const Text, Delimiter: string; Index: Integer): string;
var
  I, J, K, L: Integer;
begin
  J := 0;
  K := 0;
  L := Length(Delimiter);
  for I := 0 to Index do
  begin
    K := J;
    if I > 0 then
    begin
      if J = 0 then Break;
      J := PosEx(Delimiter, Text, J + L);
    end
    else J := Pos(Delimiter, Text);
  end;
  if (J > 0) or (K > 0) then
  begin
    if J = 0 then J := Length(Text) + 1;
    if K > 0 then Inc(K, L)
    else K := 1;
    Result := Copy(Text, K, J - K);
  end
  else Result := '';
end;

function SubTextCount(const Text, SubText: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  if SubText <> '' then
  begin
    I := Pos(SubText, Text);
    while I > 0 do
    begin
      Inc(Result);
      I := PosEx(SubText, Text, I + Length(SubText));
    end;
  end;
end;

function ReplaceSubText(const Text, SubText, NewSubText: string): string;
var
  Builder: TTextBuilder;
  StringArray: TStringDynArray;
  I: Integer;
begin
  Builder := TTextBuilder.Create;
  try
    Split(Text, SubText, StringArray);
    try
      for I := Low(StringArray) to High(StringArray) do
        if I > Low(StringArray) then Builder.Append(NewSubText + StringArray[I])
        else Builder.Append(StringArray[I]);
    finally
      StringArray := nil;
    end;
    Result := Builder.Text;
  finally
    Builder.Free;
  end;
end;

function Split(Text: string; const Delimiter: string; var StringArray: TStringDynArray;
  MaxCount: Integer = 0): Boolean;
var
  I, J: Integer;
begin
  Result := (MaxCount <= 0) or (Length(StringArray) < MaxCount);
  if Result then
  begin
    J := SubTextCount(Text, Delimiter);
    if J > 0 then
      for I := 0 to J do
      begin
        Add(StringArray, SubText(Text, Delimiter, I));
        if (MaxCount > 0) and (Length(StringArray) >= MaxCount) then Break;
      end
    else Add(StringArray, Text);
  end;
end;

function Write(const Text, Delimiter: string; var StringArray: TStringDynArray;
  MaxCount: Integer): Boolean;
begin
  Result := (Text <> '') and Split(Text, Delimiter, StringArray, MaxCount);
end;

function DelimitedText(const Text, Delimiter, NewDelimiter: string;
  Index, Count: Integer): string;
var
  Builder: TTextBuilder;
  StringArray: TStringDynArray;
  I: Integer;
begin
  Builder := TTextBuilder.Create;
  try
    Split(Text, Delimiter, StringArray);
    try
      if (Index >= 0) and (Index + Count <= Length(StringArray)) then
        for I := Index to Index + Count - 1 do
          if I > Index then Builder.Append(NewDelimiter + StringArray[I])
          else Builder.Append(StringArray[I]);
      Result := Builder.Text;
    finally
      StringArray := nil;
    end;
  finally
    Builder.Free;
  end;
end;

function DelimitedText(StringArray: TStringDynArray; const Delimiter: string;
  MaxCount: Integer = 0): string;
var
  Builder: TTextBuilder;
  I: Integer;
begin
  Builder := TTextBuilder.Create;
  try
    if MaxCount = 0 then MaxCount := Length(StringArray);
    for I := Low(StringArray) to MaxCount - 1 do
      if I > Low(StringArray) then Builder.Append(Delimiter + StringArray[I])
      else Builder.Append(StringArray[I]);
    Result := Builder.Text;
  finally
    Builder.Free;
  end;
end;

function Duplicate(const Text: string; Index: Integer): Boolean;
var
  I: Integer;
begin
  for I := 1 to Length(Text) do
    if (I <> Index) and (Text[I] = Text[Index]) then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

function EmptyArray(StringArray: TStringDynArray): Boolean;
var
  I: Integer;
begin
  for I := Low(StringArray) to High(StringArray) do
    if Trim(StringArray[I]) <> '' then
    begin
      Result := False;
      Exit;
    end;
  Result := True;
end;

function ArrayValue(StringArray: TStringDynArray; Index: Integer;
  Cut: Boolean): string;
begin
  if Index < Length(StringArray) then
    if Cut then Result := Trim(StringArray[Index])
    else Result := StringArray[Index]
  else Result := '';
end;

function ArrayValue(StringArray: TStringDynArray; Index: Integer;
  Default: Integer; Cut: Boolean = True): Integer;
begin
  Result := StrToIntDef(ArrayValue(StringArray, Index, Cut), Default);
end;

function ArrayValue(StringArray: TStringDynArray; Index: Integer;
  Default: Single; Cut: Boolean = True): Single;
begin
  Result := StrToFloatDef(ArrayValue(StringArray, Index, Cut), Default);
end;

function ArrayValue(StringArray: TStringDynArray; Index: Integer;
  Default: Double; Cut: Boolean = True): Double;
begin
  Result := StrToFloatDef(ArrayValue(StringArray, Index, Cut), Default);
end;

function Encode(const Text: string; MultiLine: Boolean; CharSet: TSysCharSet): string;
var
  Builder: TTextBuilder;
  I: Integer;
begin
  Builder := TTextBuilder.Create;
  try
    for I := 1 to Length(Text) do
      if MultiLine and CharInSet(Text[I], Breaks) or (CharSet <> []) and
        not CharInSet(Text[I], CharSet) then Builder.Append(Text[I])
      else Builder.Append(Percent + IntToHex(Ord(Text[I]), DigitCount));
    Result := Builder.Text;
  finally
    Builder.Free;
  end;
end;

function Decode(const Text: string; CharSet: TSysCharSet): string;
var
  Builder: TTextBuilder;
  I, J: Integer;
begin
  Result := ReplaceSubText(Text, Percent + Percent, Percent +
    IntToHex(Ord(Percent), DigitCount));
  Builder := TTextBuilder.Create;
  try
    I := 1;
    while I <= Length(Text) do
      if (Text[I] = Percent) and
        TryStrToInt(Dollar + Copy(Text, I + 1, DigitCount), J) and
        ((CharSet = []) or CharInSet(Chr(J), CharSet)) then
        begin
          Builder.Append(Chr(J));
          Inc(I, DigitCount + 1);
        end
        else begin
          Builder.Append(Text[I]);
          Inc(I);
        end;
    Result := Builder.Text;
  finally
    Builder.Free;
  end;
end;

function CreateGuid(Guid: PGuid): string;
var
  AGuid: TGuid;
begin
  if not Assigned(Guid) then Guid := @AGuid;
  if SysUtils.CreateGuid(Guid^) = S_OK then Result := GuidToString(Guid^)
  else Result := '';
end;

end.

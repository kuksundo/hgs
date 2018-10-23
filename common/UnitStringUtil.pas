unit UnitStringUtil;

interface

uses Windows, sysutils, classes, Forms, shellapi, Graphics, math, MMSystem,
    JclStringConversions, TlHelp32, StrUtils, Comobj;

const
  OneKB = 1024;
  OneMB = OneKB * OneKB;
  OneGB = OneKB * OneMB;
  OneTB = Int64(OneKB) * OneGB;

type
  TByteStringFormat = (bsfDefault, bsfBytes, bsfKB, bsfMB, bsfGB, bsfTB);

function strToken(var S: String; Seperator: Char): String;
function ExtractText(const Str: string; const Delim1, Delim2: string): string;
function strTokenCount(S: String; Seperator: Char): Integer;
function GetstrTokenNth(S: string; seperator: Char; Nth: integer): string;
function NextPos2(SearchStr, Str : String; Position : integer) : integer;
function PosRev(SubStr,s : string; IgnoreCase : boolean = false) : integer;
function ExtractRelativePathBaseApplication(AApplicationPath, AFileNameWithPath: string): string;
function InsertSymbols(s: string; c: Char; Position: Integer = 1): string;
function AddThousandSeparator(S: string; Chr: Char): string;
function IsValidGUID(const AGUID: string): boolean;
function StringToCharSet(const AStr: string): TSysCharSet;
function CharSetToString(const AChars: TSysCharSet): string;
function CharSetToInt(const AChars: TSysCharSet): integer;
function InsertSeperator(var AStr: string; ASep: String = '-'): string;
function DeleteSeperator(var AStr: string): string;

function NewGUID: string;
function FormatByteString(Bytes: UInt64; Format: TByteStringFormat = bsfDefault): string;

implementation

function strToken(var S: String; Seperator: Char): String;
var
  I               : Word;
begin
  I:=Pos(Seperator,S);
  if I<>0 then
  begin
    Result:=System.Copy(S,1,I-1);
    System.Delete(S,1,I);
  end else
  begin
    Result:=S;
    S:='';
  end;
end;

function ExtractText(const Str: string; const Delim1, Delim2: string): string;
var
  pos1, pos2: integer;
begin
  result := '';
  pos1 := Pos(Delim1, Str);
  if pos1 > 0 then begin
    pos2 := PosEx(Delim2, Str, pos1+1);
    if pos2 > 0 then
      result := Copy(Str, pos1 + 1, pos2 - pos1 - 1);
  end;
end;

function strTokenCount(S: String; Seperator: Char): Integer;
begin
  Result:=0;
  while S<>'' do begin
    StrToken(S,Seperator);
    Inc(Result);
  end;
end;

function GetstrTokenNth(S: string; seperator: Char; Nth: integer): string;
var
  i: integer;
begin
  Result:='';
  for i := 1 to Nth do
  begin
    Result := StrToken(S,Seperator);
  end;
end;

//Position: 이 위치 이후부터 맨 처음에 나오는 SearchStr의 위치를 반환함
//없으면 0을 반환함
function NextPos2(SearchStr, Str : String; Position : integer) : integer;
begin
  delete(Str, 1, Position-1);
  Result := pos(SearchStr, upperCase(Str));
  If Result = 0 then exit;
  If (Length(Str) > 0) and (Length(SearchStr) > 0) then
    Result := Result + Position - 1;
end;

function PosRev(SubStr,s : string; IgnoreCase : boolean = false) : integer;
var i : integer;

   function IsMatch : boolean;
   var j : integer;
   begin
     Result := false;
     for j := 2 to Length(SubStr) do if SubStr[j]<>s[i+(j-1)] then exit;
     Result := true;
   end;

var l : integer;
begin
  Result := 0;
  if IgnoreCase then
  begin
    s := UpperCase(s);
    SubStr := UpperCase(SubStr);
  end;
  l := Length(SubStr);
  if l=0 then exit;
  for i := Length(s) downto 1 do
  begin
    if s[i]=SubStr[1] then
    begin
      if l=1 then
      begin
        Result := i;
        exit;
      end else
      begin
        if IsMatch then
        begin
          Result := i;exit;
        end;
      end;
    end;
  end;
end;

function ExtractRelativePathBaseApplication(AApplicationPath, AFileNameWithPath: string): string;
begin
  AApplicationPath := IncludeTrailingBackslash(AApplicationPath);

  Result := IncludeTrailingBackslash(ExtractRelativePath(
                      ExtractFilePath(AApplicationPath),
                      ExtractFilePath(AFileNameWithPath))) +
                      ExtractFileName(AFileNameWithPath);

  if Result = '\' then
    Result := '.\'
  else
  if Pos('.\', Result) = 0 then
    Result := '.\' + Result;
end;

function InsertSymbols(s: string; c: Char; Position: Integer = 1): string;
begin
  Result := Copy(s, 1, Position) + c + Copy(s, Position + 1, Length(s) - Position);
end;

function NewGUID: string;
var
  Guid: TGUID;
begin
  CreateGUID(Guid);
  Result := GUIDToString(Guid);
end;

function AddThousandSeparator(S: string; Chr: Char): string;
var
  I: Integer;
begin
  Result := S;
  I := Length(S) - 2;
  while I > 1 do
  begin
    Insert(Chr, Result, I);
    I := I - 3;
  end;
end;

function IsValidGUID(const AGUID: string): boolean;
var
  Lres: HResult;
  lg: TGuid;
begin
  Result := True;
  try

  except
    on E: Exception do
      Result := False;
  end;

  if Result then
  begin
    try
      OleCheck(Lres);
    except
      on E: Exception do
        Result := False;
    end;
  end;
end;

function StringToCharSet(const AStr: string): TSysCharSet;
var
  CP: PAnsiChar;
  LStr: AnsiString;
begin
  Result := [];

  if AStr = '' then
    exit;

  LStr := AStr;
  CP := PAnsiChar(LStr);

  while CP^ <> #0 do
  begin
    Include(Result, CP^);
    Inc(CP);
  end;
end;

function CharSetToString(const AChars: TSysCharSet): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to 255 do
    if Chr(i) in AChars then
      Result := Result + Chr(i);
end;

function CharSetToInt(const AChars: TSysCharSet): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to 255 do
    if Chr(i) in AChars then
      Result := Result + i;
end;

function InsertSeperator(var AStr: string; ASep: String = '-'): string;
begin
  // Insert spaces in the release code string for easier reading
  System.Insert(ASep, AStr, 13);
  System.Insert(ASep, AStr, 09);
  System.Insert(ASep, AStr, 05);

  Result := AStr;
end;

function DeleteSeperator(var AStr: string): string;
begin
  // Remove spaces from the Release code
  while pos(' ', AStr) > 0 do
    System.Delete(AStr, pos(' ', AStr), 1);

  // Remove '-' from the Release code
  while pos('-', AStr) > 0 do
    System.Delete(AStr, pos('-', AStr), 1);

  Result := AStr;
end;

function FormatByteString(Bytes: UInt64; Format: TByteStringFormat = bsfDefault): string;
begin
  if Format = bsfDefault then begin
    if Bytes < OneKB then begin
      Format := bsfBytes;
    end
    else if Bytes < OneMB then begin
      Format := bsfKB;
    end
    else if Bytes < OneGB then begin
      Format := bsfMB;
    end
    else if Bytes < OneTB then begin
      Format := bsfGB;
    end
    else begin
      Format := bsfTB;
    end;
  end;

  case Format of
  bsfBytes:
    Result := SysUtils.Format('%d bytes', [Bytes]);
  bsfKB:
    Result := SysUtils.Format('%.1n KB', [Bytes / OneKB]);
  bsfMB:
    Result := SysUtils.Format('%.1n MB', [Bytes / OneMB]);
  bsfGB:
    Result := SysUtils.Format('%.1n GB', [Bytes / OneGB]);
  bsfTB:
    Result := SysUtils.Format('%.1n TB', [Bytes / OneTB]);
  end;
end;

end.

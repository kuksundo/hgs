unit String_Util;

interface

uses  Windows, SysUtils;

function slash(value:string):string;
Function IsNumeric(Str: String): Boolean;
function IsFloat(S: string): boolean;
//function GetToKen(const Value: TVarRec): String;
//procedure Parsing(const Values: array of const);
function LTrimZero(const str1: string): String;
function CountChar(Const str1: string; Token: Char): integer;
function PosRev(SubStr, s : string; IgnoreCase : boolean = false) : integer;
function LastPos(const SubStr: String; const S: String): Integer;
function MatchPattern(InpStr,Pattern :PChar) :Boolean;
function NextPos(SubStr: AnsiString; Str: AnsiString; LastPos: DWORD=0): DWORD;
function NextPos2(SearchStr, Str : String; Position : integer) : integer;
function Like(AString, Pattern: string): boolean;
function AnsiLength1(const s: string): integer;
function AnsiLength2(const s: string): integer;
function NextPosRel(SearchStr, Str : String; Position : integer) : integer;
function ReplaceStr(Str, SearchStr, ReplaceStr : String) : String;
function IsHanGeul(S: String): Boolean;
function IsHanGeul2(S: String; AIndex: integer): Boolean;
function IsStrMatch(s1,s2:String): Double;
function SetShortPath (aLabel: TLabel; asPath: string): string;
function GetHanType(const Src: string): THanType;
function HanDiv(const Han: PChar; Han3: PChar): Boolean;
function HanComPas(const Src: String): String;
function  StringFormat ( const value : string; const items : array of variant ) : string;
function PerformTemplateReplace(const Template: String;

implementation

function slash(value:string):string;
begin
  if (value[length(value)]<>'\') then
    result:=value+'\'
  else
    result:=value;
end;

//스트링이 숫자로 구성되어 있으면 True를 반환함
Function IsNumeric(Str:String):Boolean;
Var
   I:Integer;

Begin
  if Length(Str) <= 0 then
  begin
    Result := False;
    exit;
  end;

  I:=1;
  While (I<=Length(Str)) do
  Begin
    If Not (Str[i] in ['0'..'9']) Then
    Begin
      Result:=False;
      Exit;
    End;

    Inc(I);
  End;

  Result:=True;
End;

function IsFloat(S: string): boolean;
var
  f: extended;
begin
  Result := TextToFloat(PChar(S), f, fvExtended);
end;

//   Parsing(['I','Love','Delphi',3,True]);
{ function GetToKen(const Value: TVarRec): String;
 begin
  with Value do begin
    case VType of
      vtInteger:
        Result := IntToStr(VInteger);
      vtBoolean:
        if VBoolean then Result := 'True'
        else Result := 'False';
      vtChar:

        Result := VChar;
      vtExtended:
        Result := FloatToStr(VExtended^);
      vtString:
        Result := VString^;
      vtPChar:
        Result := VPChar;
      vtAnsiString:
        Result := string(VAnsiString);
      vtCurrency:
        Result := CurrToStr(VCurrency^);
      vtVariant:
        if not VarIsEmpty(VVariant^) then Result := VarToStr(VVariant^);
    else
      Result := '';

    end;
  end;
 end;

 procedure Parsing(const Values: array of const);
 var
  I: Integer;
 begin
  for I := 0 to High(Values) do begin
    ShowMessage(GetToken(Values[I]));
  end;
 end;
 }
//숫자 012를 12로 반환한다.
//왼쪽의 0을 제거한다.
function LTrimZero(const str1: string): String;
begin
  Result := str1;

  if StrToIntDef(str1, -1) <> -1 then  // 숫자인지 체크....
      Result := FormatFloat('####0', StrToInt(str1));
end;

//스트링내에 주어진 문자가 몇개인지 반환한다.
function CountChar(Const str1: string; Token: Char): integer;
var i,j,k: integer;
begin
  i := Length(str1);

  if (i <= 0) or (Token = '') then
  begin
    Result := 0;
    Exit;
  end;

  j := 0;
  k := 0;

  while i > j do
  begin
    if str1[j] = Token then
      inc(k);
    inc(j);
  end;//while

  Result := k;
end;

{-------------------------------------------------------------------------------
*PosRev - Same as standard Pos string function except that it scans backwards.
 Example: PosRev('O','HELLO WORLD') > 8 (last O)
-------------------------------------------------------------------------------}
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

{*****************************************************************} 
{* This function implements a subset of regular expression based *} 
{* search and is based on the translation of PattenMatch() API   *} 
{* of common.c in MSDN Samples\VC98\sdk\sdktools\tlist           *} 
{*****************************************************************} 
{* MetaChars are  :                                              *} 
{*            '*' : Zero or more chars.                          *} 
{*            '?' : Any one char.                                *} 
{*         [adgj] : Individual chars (inclusion).                *} 
{*        [^adgj] : Individual chars (exclusion).                *} 
{*          [a-d] : Range (inclusion).                           *} 
{*         [^a-d] : Range (exclusion).                           *} 
{*       [a-dg-j] : Multiple ranges (inclusion).                 *} 
{*      [^a-dg-j] : Multiple ranges (exclusion).                 *} 
{*  [ad-fhjnv-xz] : Mix of range & individual chars (inclusion). *} 
{* [^ad-fhjnv-xz] : Mix of range & individual chars (exclusion). *}
{*****************************************************************} 
function MatchPattern(InpStr,Pattern :PChar) :Boolean;
begin
  while(True) do
  begin
    case Pattern[0] of
      #0 :begin //End of pattern reached.
            Result := (InpStr[0] = #0); //TRUE if end of InpStr.
            Exit;
          end;

      '*':begin //Match zero or more occurances of any char.
            if(Pattern[1] = #0)then
            begin //Match any number of trailing chars.
              Result := True;
              Exit;
            end else Inc(Pattern);

            while(InpStr[0] <> #0)do
            begin //Try to match any substring of InpStr.
              if(MatchPattern(InpStr,Pattern))then
              begin
                Result := True;
                Exit;
              end;

              //Continue testing next char...
              Inc(InpStr);
            end;
          end;

      '?':begin //Match any one char.
            if(InpStr[0] = #0)then
            begin
              Result := False;
              Exit;
            end;

            //Continue testing next char...
            Inc(InpStr);
            Inc(Pattern);
          end;

      '[':begin //Match given set of chars.
            if(Pattern[1] in [#0,'[',']']) then
            begin //Invalid Set - So no match.
              Result := False;
              Exit;
            end;

            if(Pattern[1] = '^')then
            begin //Match for exclusion of given set...
              Inc(Pattern,2);
              Result := True;
              while(Pattern[0] <> ']')do
              begin
                if(Pattern[1] = '-')then
                begin //Match char exclusion range.
                  if(InpStr[0] >= Pattern[0])and(InpStr[0] <= Pattern[2])then
                  begin //Given char failed set exclusion range. 
                    Result := False; 
                    Break; 
                  end else Inc(Pattern,3);
                end else 
                begin //Match individual char exclusion. 
                  if(InpStr[0] = Pattern[0])then 
                  begin //Given char failed set element exclusion. 
                    Result := False; 
                    Break; 
                  end else Inc(Pattern); 
                end; 
              end; 
            end else 
            begin //Match for inclusion of given set... 
              Inc(Pattern); 
              Result := False; 
              while(Pattern[0] <> ']')do 
              begin 
                if(Pattern[1] = '-')then 
                begin //Match char inclusion range.
                  if(InpStr[0] >= Pattern[0])and(InpStr[0] <= Pattern[2])then 
                  begin //Given char matched set range inclusion. Continue testing... 
                    Result := True; 
                    Break;
                  end else Inc(Pattern,3); 
                end else 
                begin //Match individual char inclusion. 
                  if(InpStr[0] = Pattern[0])then 
                  begin //Given char matched set element inclusion. Continue testing... 
                    Result := True; 
                    Break; 
                  end else Inc(Pattern); 
                end; 
              end; 
            end; 

            if(Result)then 
            begin //Match was found. Continue further. 
              Inc(InpStr); 

              //Position Pattern to char after "]"
              while(Pattern[0] <> ']')and(Pattern[0] <> #0)do Inc(Pattern); 

              if(Pattern[0] = #0)then 
              begin //Invalid Pattern - missing "]"
                  Result := False; 
                  Exit; 
              end else Inc(Pattern); 
            end else Exit; 
          end; 

     else begin //Match given single char. 
            if(InpStr[0] <> Pattern[0])then 
            begin 
              Result := False; 
              Break; 
            end; 

            //Continue testing next char... 
            Inc(InpStr); 
            Inc(Pattern); 
          end;
    end; 
  end; 
end; 

function NextPos(SubStr: AnsiString; Str: AnsiString; LastPos: DWORD=0): DWORD;
type
  StrRec = packed record
    allocSiz: Longint;
    refCnt: Longint;
    length: Longint;
  end;

const
  skew = sizeof(StrRec);

asm
  // Search-String passed?
  TEST    EAX,EAX
  JE      @@noWork

  // Sub-String passed?
  TEST    EDX,EDX 
  JE      @@stringEmpty 

  // Save registers affected 
  PUSH    ECX 
  PUSH    EBX 
  PUSH    ESI 
  PUSH    EDI 

  // Load Sub-String pointer 
  MOV     ESI,EAX 
  // Load Search-String pointer 
  MOV     EDI,EDX 
  // Save Last Position in EBX 
  MOV     EBX,ECX 

  // Get Search-String Length 
  MOV     ECX,[EDI-skew].StrRec.length 
  // subtract Start Position 
  SUB     ECX,EBX 
  // Save Start Position of Search String to return 
  PUSH    EDI
  // Adjust Start Position of Search String
  ADD     EDI,EBX 

  // Get Sub-String Length 
  MOV     EDX,[ESI-skew].StrRec.length 
  // Adjust 
  DEC     EDX 
  // Failed if Sub-String Length was zero 
  JS      @@fail 
  // Pull first character of Sub-String for SCASB function 
  MOV     AL,[ESI] 
  // Point to second character for CMPSB function 
  INC     ESI 

  // Load character count to be scanned 
  SUB     ECX,EDX 
  // Failed if Sub-String was equal or longer than Search-String 
  JLE     @@fail 
@@loop: 
  // Scan for first matching character 
  REPNE   SCASB 
  // Failed, if none are matching
  JNE     @@fail 
  // Save counter 
  MOV     EBX,ECX 
  PUSH    ESI 
  PUSH    EDI 
  // load Sub-String length 
  MOV     ECX,EDX 
  // compare all bytes until one is not equal 
  REPE    CMPSB 
  // restore counter 
  POP     EDI 
  POP     ESI 
  // all byte were equal, search is completed 
  JE      @@found 
  // restore counter
  MOV     ECX,EBX 
  // continue search 
  JMP     @@loop 
@@fail: 
  // saved pointer is not needed 
  POP     EDX
  XOR     EAX,EAX
  JMP     @@exit 
@@stringEmpty: 
  // return zero - no match 
  XOR     EAX,EAX
  JMP     @@noWork 
@@found: 
  // restore pointer to start position of Search-String 
  POP     EDX 
  // load position of match 
  MOV     EAX,EDI 
  // difference between position and start in memory is 
  //   position of Sub 
  SUB     EAX,EDX
@@exit:
  // restore registers 
  POP     EDI 
  POP     ESI
  POP     EBX 
  POP     ECX 
@@noWork:
end;

// Search for the next occurence of a string from a certain Position
// N?hstes Vorkommen einer Zeichenkette ab einer frei definierbaren Stelle im String

function NextPos2(SearchStr, Str : String; Position : integer) : integer;
begin
  delete(Str, 1, Position-1);
  Result := pos(SearchStr, upperCase(Str));
  If Result = 0 then exit;
  If (Length(Str) > 0) and (Length(SearchStr) > 0) then
    Result := Result + Position + 1;
end;

//와일드 카드를 이용한 문자열 검색
function Like(AString, Pattern: string): boolean;
var i, n, n1, n2: integer;
    p1, p2: pchar;
label match, nomatch;
begin
  AString := UpperCase(AString);
  Pattern := UpperCase(Pattern);
  n1 := Length(AString);
  n2 := Length(Pattern);
  if n1 < n2 then n := n1 else n := n2;
  p1 := pchar(AString);
  p2 := pchar(Pattern);
  for i := 1 to n do
  begin
    if p2^ = '*' then goto match;
    if (p2^ <> '?') and (p2^ <> p1^) then goto nomatch;
    inc(p1); inc(p2);
  end;

  if n1 > n2 then
  begin
    nomatch:
    Result := False;
    exit;
  end
  else
  if n1 < n2 then
  begin
    for i := n1 + 1 to n2 do
    begin
      if not (p2^ in ['*','?']) then goto nomatch;
      inc(p2);
    end;
  end;

  match:
    Result := True;
end;

//DBCS 스트링 길이 반환
function AnsiLength1(const s: string): integer;
var i, n: integer;
begin
  Result := 0;
  n := Length(s);
  i := 1;
  while i <= n do
  begin
    inc(Result);

    if s[i] in LeadBytes then inc(i);

    inc(i);
  end;
end;

//DBCS 스트링 길이 반환
function AnsiLength2(const s: string): integer;
var p, q: pchar;
begin
  Result := 0;
  p := PChar(s);
  q := p + Length(s);

  while p < q do
  begin
    inc(Result);
    if p^ in LeadBytes then
      inc(p, 2)
    else
      inc(p);
  end;
end;

// Get the number of characters from a certain Position to the string to be searched
// Anzahl der Zeichen von einer definierbaren Position zur gesuchten Zeichenkette
function NextPosRel(SearchStr, Str : String; Position : integer) : integer;
begin
  delete(Str, 1, Position-1);
  Result := pos(SearchStr, UpperCase(Str)) - 1;
end;

// simple replacement for strings
function ReplaceStr(Str, SearchStr, ReplaceStr : String) : String;
begin
  While pos(SearchStr, Str) <> 0 do
  begin
    Insert(ReplaceStr, Str, pos(SearchStr, Str));
    Delete(Str, pos(SearchStr, Str), Length(SearchStr));
  end;
  Result := Str;
end;

//Unicode에서 한글이면 True
function IsHanGeul(S: String): Boolean;
const
  UniCodeHangeulBase1 = $1100;
  UniCodeHangeulLast1 = $11F9;
  UniCodeHangeulBase2 = $3130;
  UniCodeHangeulLast2 = $318E;
  UniCodeHangeulBase3 = $AC00;
  UniCodeHangeulLast3 = $D7A3;
begin
  if ((ord(s[1]) >= UniCodeHangeulBase1) and
    (ord(s[1]) <= UniCodeHangeulLast1)) or
    ((ord(s[1]) >= UniCodeHangeulBase2) and
    (ord(s[1]) <= UniCodeHangeulLast2)) or
    ((ord(s[1]) >= UniCodeHangeulBase3) and
    (ord(s[1]) <= UniCodeHangeulLast3)) then
    Result := True
  else
    Result := False;
end;

function IsHanGeul2(S: String; AIndex: integer): Boolean;
const
  UniCodeHangeulBase1 = $1100;
  UniCodeHangeulLast1 = $11F9;
  UniCodeHangeulBase2 = $3130;
  UniCodeHangeulLast2 = $318E;
  UniCodeHangeulBase3 = $AC00;
  UniCodeHangeulLast3 = $D7A3;
begin
  if ((ord(s[AIndex]) >= UniCodeHangeulBase1) and
    (ord(s[AIndex]) <= UniCodeHangeulLast1)) or
    ((ord(s[AIndex]) >= UniCodeHangeulBase2) and
    (ord(s[AIndex]) <= UniCodeHangeulLast2)) or
    ((ord(s[AIndex]) >= UniCodeHangeulBase3) and
    (ord(s[AIndex]) <= UniCodeHangeulLast3)) then
    Result := True
  else
    Result := False;
end;

//compare two Strings and measure the percentage they match
//  (ex)
//      match := IsStrMatch('SwissDelphiCenter', 'SwissDelphiCenter.ch');
//      ShowMessage(FloatToStr(match) + ' % match.');
//      resultat: 85%
function IsStrMatch(s1,s2:String): Double;
var
  i, iMin, iMax, iSameCount: Integer;
begin
  iMax := Max(Length(s1), Length(s2));
  iMin := Min(Length(s1), Length(s2));
  iSameCount := -1;
  for i := 0 to iMax do
  begin
    if i > iMin then
      break;
    if s1[i] = s2[i] then
      Inc(iSameCount)
    else
      break;
  end;
  if iSameCount > 0 then
    Result := (iSameCount / iMax) * 100
  else
    Result := 0.00;
end;

//경로 길이에 따라 요약경로 얻기
function SetShortPath (aLabel: TLabel; asPath: string): string;
var
   sBuf, sPath, sSPath: string;
   rsPath: array[0..255] of string;
   i, iPathCnt: integer;
begin
   result := asPath;
  try
   sBuf := asPath;
   if copy (sBuf, length (sBuf), 1) = '\' then
      sBuf := copy (sBuf, 1, length (sBuf) - 1);
   result := sBuf;

   aLabel.Hint := asPath;
   aLabel.ShowHint := True;

   if aLabel.Width > aLabel.Canvas.TextWidth (sBuf) then exit;

   sPath := sBuf;
   iPathCnt := 0;
   while pos ('\', sPath) > 0 do
   begin
      sBuf := ExtractFileName (sPath);
      rsPath[iPathCnt] := sBuf; 

      sPath := ExtractFilePath (sPath); 
      if copy (sPath, length (sPath), 1) = '\' then 
         sPath := copy (sPath, 1, length (sPath) - 1); 
      inc (iPathCnt); 
   end; 
   rsPath[iPathCnt] := sPath; 
   inc (iPathCnt); 

   sBuf := ''; 
   for i := iPathCnt - 1 downto 1 do 
   begin 
      if aLabel.Width < aLabel.Canvas.TextWidth (sBuf + '\' + rsPath[i] + '\...\' + rsPath[0]) then 
         break; 

      if sBuf <> '' then sBuf := sBuf + '\'; 
      sBuf := sBuf + rsPath[i]; 
   end; 

   result := sBuf + '\...\' + rsPath[0]; 

  finally 
   aLabel.Caption := result; 
  end; 
end; 

//한글인지 한자인지 구분함
function GetHanType(const Src: string): THanType;
type
  THanType = (htHangul, htHanja, htOther);
var
  Len, Hi, Lo: Integer;
begin
  Result := htOther;
  if Length(Src) < 2 then Exit;
  Len := Length(Src);
  Hi := Ord(Src[Len - 1]);
  Lo := Ord(Src[Len]);
  if ($A1 > Lo) or ($FE < Lo) then Exit;
  if ($B0 <= Hi)  and ($C8 >=  Hi) then
    Result := htHangul
  else if ($CA <= Hi) and ($FD >= Hi) then
    Result := htHanja;
end;

const
  ChoSungTbl:  PChar = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ';
  JungSungTbl: PChar = 'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ';
  JongSungTbl: PChar = '  ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ';
  UniCodeHangeulBase = $AC00;
  UniCodeHangeulLast = $D79F;
// function HanDiv: 한글을 자모로 분해
// Han: 변환할 글자, PChar 타입
// Han3: 분해된 자모, PChar 타입
// (Result): 함수 호출 성공(True), 실패(False)
// *주의: 변수 Han과 Han3이 가리키는 메모리 공간은 각각 2, 6바이트가
// 할당되어 있어야 한다. 그리고 Han과 Han3 모두 null-종료 문자열이 아니다.
function HanDiv(const Han: PChar; Han3: PChar): Boolean;
var
  UniCode: Word;
  ChoSung, JungSung, JongSung: Integer;
begin
  Result := False;

  MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, Han, 2, @UniCode, 1);

  if (UniCode < UniCodeHangeulBase) or
     (UniCode > UniCodeHangeulLast) then Exit;

  UniCode := UniCode - UniCodeHangeulBase;
  ChoSung := UniCode div (21 * 28);
  UniCode := UniCode mod (21 * 28);
  JungSung := UniCode div 28;
  UniCode := UniCode mod 28;
  JongSung := UniCode;

  StrLCopy(Han3, ChoSungTbl + ChoSung * 2, 2);
  StrLCopy(Han3 + 2, JungSungTbl + JungSung * 2, 2);
  StrLCopy(Han3 + 4, JongSungTbl + JongSung * 2, 2);

  Result := True;
end;

// function HanDivPas: 한글을 자모로 분해
// Src: 변환할 글자, 예: '갈'
// (Result): 분해된 자모, 예: 'ㄱㅏㄹ', 함수 호출 실패의 경우 ''을 반환한다.
function HanDivPas(const Src: String): String;
var
  Buff: array[0..6] of Char;
begin
  Result := '';
  if Length(Src) = 2 then begin
    if HanDiv(PChar(Src), Buff) then begin
      Buff[6] := #0;
      Result := String(Buff);
    end;
  end;
end;

// function HanCom: 한글 자모를 글자로 조합
// Han3: 변환할 자모, PChar 타입
// Han: 조합된 글자, PChar 타입
// (Result): 함수 호출 성공(True), 실패(False)
// *주의: 변수 Han과 Han3이 가리키는 메모리 공간은 각각 2, 6바이트가
// 할당되어 있어야 한다. 그리고 Han과 Han3 모두 null-종료 문자열이 아니다.
function HanCom(const Han3: PChar; Han: PChar): Boolean;
var
  UniCode: Word;
  ChoSung, JungSung, JongSung: Integer;
  ChoSungPos, JungSungPos, JongSungPos: Integer;
begin
  Result := False;

  ChoSungPos := Pos(Copy(String(Han3), 1, 2), ChoSungTbl);
  JungSungPos := Pos(Copy(String(Han3), 3, 2), JungSungTbl);
  JongSungPos := Pos(Copy(String(Han3), 5, 2), JongSungTbl);

  if (ChoSungPos and JungSungPos and JongSungPos) = 0 then Exit;

  ChoSung := (ChoSungPos - 1) div 2;
  JungSung := (JungSungPos - 1) div 2;
  JongSung := (JongSungPos - 1) div 2;

  UniCode := UniCodeHangeulBase +
    (ChoSung * 21 + JungSung) * 28 + JongSung;

  WideCharToMultiByte(CP_ACP, WC_COMPOSITECHECK,
    @UniCode, 1, Han, 2, nil, nil);

  Result := True;
end;

// function HanComPas: 한글 자모를 글자로 조합
// Src: 변환할 자모, 예: 'ㄱㅏㄹ'
// (Result): 조합된 글자, 예: '갈', 함수 호출 실패의 경우 ''을 반환한다.
function HanComPas(const Src: String): String;
var
  Buff: array[0..2] of Char;
begin
  Result := '';
  if Length(Src) = 6 then begin
    if HanCom(PChar(Src), Buff) then begin
      Buff[2] := #0;
      Result := String(Buff);
    end;
  end;
end;

//////////////////////////////////////////////////////////////////////////////////// 
// Procedure - StringFormat 
// Author    - RB 
// Date      - 18-Feb-2004 
// Remarc    - ASP.NET like string.format function 
// 
// Returns a string containing a string representation formatted with all the array 
// elements found in the source string. 
// 
// Better solution than the basic format function within delphi. 
// 
// eg. StringFormat('This is a {1}, numbers {0},{2}, boolean {3}',[1,'test',5.5,false]) 
// 
//////////////////////////////////////////////////////////////////////////////////// 
///StringFormat('This is a {1}, numbers {0},{2},{0}, boolean {3}',[1,'test',5.5,false])); 

function  StringFormat ( const value : string; const items : array of variant ) : string;
var Ts,Ts1 : String;
    i,j : integer;
begin
  Ts := Value;
  for i := low(items) to high(items) do
    begin
      Ts1 := items[i];
      j := pos(format('{%d}',[i]),Ts);
      while j > 0 do
        begin
          system.delete(ts,j,3);
          system.insert(ts1,ts,j);
          j := pos(format('{%d}',[i]),Ts);
        end;
    end;
  Result := Ts;
end;

function PerformTemplateReplace(const Template: String;
  DataSetRecord: TDataSet): String;
var 
  sl: TStringList; 
  str: String; 
  i: Integer; 
begin 

  //Delphi 7 note 
  //Make sure your uses clause includes Classes and StrUtils 
  //Delphi 8 note 
  //Make sure your uses clause includes Borland.Vcl.Classes 
  //and Borland.Vcl.StrUtils 
  sl := TStringList.Create; 

  try 
    sl.Text := Template; 
    //remove all comment lines 
    i := 0; 
    while i < sl.Count do 
    begin 
      if UpperCase(Copy(sl.Strings[i],1,3)) = 'REM' then
      begin 
        sl.Delete(i); 
        continue; 
      end; 
      //This line is executed if a comment is NOT removed 
      inc(i); 
    end; 
    str := sl.Text; 
  finally 
    sl.Free; 
  end; 

  //we now have the template in a string. 
  //Use StringReplace to replace parts of the template 
  //with data from our database 

  //begin by iterating through the AttendeesDataSource.DataSet Fields 
  //Replace {fieldname} tags in str with field contents 
  for i := 0 to Pred(DataSetRecord.Fields.Count) do 
    str := StringReplace(str, '{'+DataSetRecord.Fields[i].FieldName+'}', 
      DataSetRecord.Fields[i].AsString, [rfReplaceAll,rfIgnoreCase]);

  //Check for today's date tag {TODAY} 
  if Pos('{TODAY}', UpperCase(str)) > 0 then 
  begin 
    str := StringReplace(str, '{today}', 
      FormatDateTime('mmmm, dd, yyyy',Date),[rfReplaceAll, rfIgnoreCase]); 
  end; 

  //Check for current time tag {TIME} 
  if Pos('{TIME}', UpperCase(str)) > 0 then 
  begin 
    str := StringReplace(str, '{time}', 
      FormatDateTime('tt',Time),[rfReplaceAll, rfIgnoreCase]); 
  end; 

  //You can create any additional 
  //custom tags using this same technique 

  Result := str; 
end; 

//인수로 주어진 스트링의 Width 및 Height를 반환함
function GetTextSize(TextLines: TStrings; font: TFont): TSize;
var i : integer;
    s : string;
    S1 : TSize;
begin
  result.cx:=0;
  result.cy:=0;
  for i:=0 to TextLines.Count-1 do
  begin
    s:=FTextLines.Strings[i];
    Canvas.Font.Assign(Font);
    GetTextExtentPoint32(Canvas.Handle,PChar(@s[1]),length(s),s1);
    if result.cx<s1.cx then result.cx:=s1.cx;
    result.cy:=result.cy+s1.cy;
  end;

function LastPos(const SubStr: String; const S: String): Integer;
begin
   result := Pos(Reverse(SubStr), Reverse(S)) ;

   if (result <> 0) then
     result := ((Length(S) - Length(SubStr)) + 1) - result + 1;
end;

end.

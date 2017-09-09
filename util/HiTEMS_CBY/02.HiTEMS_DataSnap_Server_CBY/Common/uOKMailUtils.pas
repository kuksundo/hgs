////////////////////////////////////////////////////////////
//
//       uOKMailUtils.Pas : Function Group Of OKMail
//
//------------------------------------------------------------
//
//      Copyrigth (c) 2000 Gold Goodboy
//      http://www.fallenangel.pe.kr
//
////////////////////////////////////////////////////////////

unit uOKMailUtils;

interface

uses Classes;

const
  esNotConnected = 'Not connected.';
  esNotOrigin = '"From" field not specified.';
  esNotDestination = '"SendTo" field not specified.';

type
  TOnError = procedure(Sender: TObject; Error: integer; Msg: string) of object;
  TOnCodeStartEvent = procedure( Sender: TObject; FileName: string; BytesCount: longint) of object;
  TOnCodeProgressEvent = procedure( Sender: TObject; Percent: word) of object;

// 입력받은 스트링이 올바른 IP Address인가 검사한다.
function OKIsIP(const AIP : string): boolean;
//  Internat Date 를 얻는다.
function OKGetInternetDate( const ADate: TDateTime): string;
// 유일한 Mail ID를 만들어준다.
function OKMakeUniqueID( const ARef: string): string;
// Boundary 를 만들어 리턴한다.
function OKGenerateBoundary: string;
// 스트링에서 Address만 뽑는다.
function OKExtractAddress( const AAddress : string; WithDelimit : Boolean ) : string;
// 스트링에서 Name 만 뽑는다.
function OKExtractAlias( const AAddress : string; WithDelimit : Boolean ) : string;

function OKGetBoundaryOutOfLine( const s: string): string;
// GetTempPath 를 캡슐화한 함수.
function OKGetTempPath: string;
// 스트링을 받아서 공백문자를 모두 없앴다.
function OKAllTrim(src: string): string;
// 스트링을 받아서 Parse해서 스트링리스트로 넘긴다.
function OKMakeAddresses(ASrc : string): TStringList;

function OKConvertCharSet( const Line : string ) : string;

implementation

uses SysUtils, uOKMIME, Windows;

// 입력받은 스트링이 올바른 IP Address인가 검사한다.
function OKIsIP(const AIP : string): boolean;
var
  strBuf, strTemp : string;
  i, nTemp : integer;
begin
  strBuf := AIP;
  Result := False;
  for i := 1 to 3 do
  begin
    nTemp := Pos( '.', strBuf);
    if nTemp = 0 then exit;
    strTemp := Copy( strBuf, 1, nTemp - 1);
    strBuf := Copy( strBuf, nTemp + 1, Length( strBuf) - nTemp);
    nTemp := StrToIntDef( strTemp, -1);
    if (nTemp < 0) or (nTemp > 255) then exit;
  end;
  nTemp := StrToIntDef( strTemp, -1);
  if (nTemp < 0) or (nTemp > 255) then exit;
  Result := True;
end;

function OKGetBoundaryOutOfLine( const s: string): string;
var
  x, position: integer;
begin
  Result := '';
  position := pos( 'BOUNDARY', UpperCase( s));
  if position = 0 then exit;
  result := trim( copy( s, position + length('BOUNDARY'), 72));
  if length(result) = 0 then exit;
  delete( result, 1, 1); // remove the =
  result := trim( result);  // remove any leading spaces
  if length(result) = 0 then exit;
  if result[1] = '"' then
  begin
    delete( result, 1, 1);
    x := pos( '"', result);      //sometimes there are a ; in the end
    if x > 0 then delete( result, x, 72);
  end;
  x := pos( ';', result);
  if x > 0 then
  begin
    delete( result, x, 72);
  end;
  result := '--' + trim( result);
end;

// this function by Matjaz Bravc
function OKGetInternetDate(const ADate: TDateTime): string;
(* The date in RFC 822 conform string format *)

 function Int2Str(ANum: Integer; Len: Byte): string;
 begin
   Result := IntToStr(ANum);
   while Length(Result) < Len do
     Result := '0' + Result;
 end;    // of function Int2Str

 function GetTimeZoneBias: LongInt;
 (* The offset to UTC/GMT in minutes of the local time zone *)
 var tz_Info: TTimeZoneInformation;
 begin
   case GetTimeZoneInformation(tz_Info) of
     1: Result := tz_Info.StandardBias + tz_Info.Bias;
     2: Result := tz_Info.DaylightBias + tz_Info.Bias;
   else
     Result := tz_Info.DaylightBias + tz_Info.Bias;
   end;
 end;  // of function GetTimeZoneBias

 function GetTimeZone: string;
 var
   bias: LongInt;
 begin
   bias := GetTimeZoneBias;
   if bias = 0 then
     Result := 'GMT'
   else if bias < 0 then
     Result := '+' + Int2Str(Abs(bias) div 60,2) + Int2Str(Abs(bias) mod 60,2)
   else if bias > 0 then
     Result := '-' + Int2Str(bias div 60,2) + Int2Str(bias mod 60,2);
 end;

var
  y, m, w, d, h, mm, s, ms: word;
const
  WeekDays: array [1..7] of string = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
  Months: array [1..12] of string = ('Jan','Feb','Mar','Apr','May','Jun',
                                     'Jul','Aug','Sep','Oct','Nov','Dec');
begin
  DecodeDate(ADate, y, m, d);
  DecodeTime(ADate, h, mm, s, ms);
  w := DayOfWeek(ADate);

  Result := WeekDays[w] + ', ' +
            IntToStr(d) + ' ' +
            Months[m] + ' ' +
            IntToStr(y) + ' ' +
            Int2Str(h, 2) + ':' +
            Int2Str(mm, 2) + ':' +
            Int2Str(s, 2) + ' ' +
            GetTimeZone;
end;   // end of function OKGetInternetDate

function OKMakeUniqueID(const ARef: string) : string;
var
  strBuf: string;
  i : Integer;
begin
  Randomize;
  strBuf := '';
  for i := 1 to 16 do
    strBuf := Concat(strBuf, Chr(65 + Random(26)));
  Result := '<' + 'OK.' +  FormatDateTime( 'yyyy"."mm"."dd"."', Date) +
            strBuf + '@' + ARef + '>';
end;

function OKGenerateBoundary : string;
var
  strBuf: string;
  i : integer;
begin
  Randomize;
  strBuf := '';
  for i := 1 to 12 do
  begin
    strBuf := strBuf + Chr(65 + random(26));
  end;
  result := '--_OK_Bound_' + strBuf;
end;

function OKGetTempPath: string;
var
  szTempPath: array of char;
begin
  SetLength(szTempPath, MAX_PATH);  // SetLength 는 Initialized Buffer를 생성시킨다
  GetTempPath(MAX_PATH - 1, PChar(szTempPath));

  Result := pChar(szTempPath);
end;

// this function by Chris G?ther and Sergio Kessler
function OKConvertCharSet(const Line : string ) : string;
var
  strToDecode, RestBefore, RestAfter, strActual, decoded: string;
  iLast, iFirst, eFirst, i: integer;
  Encoding, c: char;
  b64Decode: TBase64DecodingStream;
  Dest: TMemoryStream;
begin
  strActual := Line;

  iFirst := Pos( '=?', strActual );
  while (iFirst > 0) do
  begin
    RestBefore := copy( strActual, 1, iFirst-1 );
    strToDecode := copy( strActual, iFirst+2, length( strActual) );
    eFirst := pos( '?', strToDecode);
    if eFirst > 0 then
    begin
      Encoding := UpperCase( strToDecode[eFirst+1])[1];
      delete( strToDecode, 1, eFirst + 2);  // remove until ?Q? or ?B? inclusive
      iLast := Pos( '?=', strToDecode );
      if iLast > 0 then
      begin
        RestAfter := copy( strToDecode, iLast+2, length( strToDecode) );
        delete( strToDecode, iLast, length( strToDecode));  // remove the ?= and the rest

        strActual := RestBefore + RestAfter;
        if Encoding = 'Q' then
        begin
           strActual := RestBefore +
                        OKQuotedPrintableDecode(PChar( strToDecode) ) +
                        RestAfter;
        end else
        if Encoding = 'B' then
        begin
          Dest := TMemoryStream.Create;

          b64Decode := TBase64DecodingStream.Create( Dest);
          b64Decode.Write( pointer(strToDecode)^, length( strToDecode));
          b64Decode.Free;

          decoded := '';
          Dest.Position := 0;
          for i:= 1 to Dest.Size do
          begin
            Dest.Read( c, 1);
            decoded := decoded + c;
          end;
          Dest.Free;
          strActual := RestBefore + decoded + RestAfter;
        end;

        iFirst := Pos( '=?', strActual );
      end
      else iFirst := 0;
    end
    else iFirst := 0;
  end;
  Result := strActual;
end;

function OKExtractAddress( const AAddress: string; WithDelimit: Boolean ): string;
var
  nStart, nEnd : integer;
begin
  Result := Trim(AAddress);

  nStart := Pos( '<', Result );
  nEnd := Pos( '>', Result );

  if ( nStart > 0 ) and ( nEnd > 0 ) then
    Result := Copy(Result, nStart + 1, nEnd - nStart - 1);

  if WithDelimit then
    Result := '<' + Result + '>';
end;

function OKExtractAlias( const AAddress: string; WithDelimit: Boolean ): string;
var
  nStart, nEnd: integer;
  strBuf : string;
begin
  strBuf := Trim(AAddress);

  nStart := Pos('<', strBuf);
  nEnd := Pos('>', strBuf);
  if (nStart > 0) and (nEnd > 0) then
    Delete(strBuf, nStart, nEnd - nStart + 1);

  Result := strBuf;

  nStart := Pos( '"', strBuf);

  if nStart > 0 then
    Delete(Result, nStart, 1);

  nEnd := Pos('"', Result);

  if nEnd > 0 then
    Result := Copy(Result, nStart, nEnd - nStart);

  if WithDelimit then
    Result := '"' + Result + '"';
end;

// 스트링을 받아서 공백문자를 모두 없앴다.
function OKAllTrim(src: string): string;
begin
  Result := src;
  StringReplace(Result, ' ', '', [rfReplaceAll]);
end;

// 스트링을 받아서 Parse해서 스트링리스트로 넘긴다.
function OKMakeAddresses(ASrc : string): TStringList;
var
  nPos : integer;
  strBuf, strTemp : string;
  i : integer;
begin
  Result := TStringList.Create;
  strBuf := Trim(ASrc);

  repeat
    nPos := Pos(',', strBuf);
    if nPos > 0 then
      strTemp := Copy(strBuf, 1, nPos  - 1)
    else
      strTemp := strBuf;

    Result.Add(OKExtractAddress(Trim(strTemp), False));

    Delete(strBuf, 1, nPos);
  until (nPos = 0);

  for i := 0 to Result.Count - 1 do
    if Result.Strings[i] = '' then
      Result.Delete(i)
end;

end.

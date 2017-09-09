unit Base64;

interface

function fnBase64Decode(str: string): string;
function fnBase64Encode(str: string): string;

implementation
uses SysUtils, Windows;

function fnRemoveWhitespace(str: string): string;
var
    strTxt : string;
begin
    strTxt  := str;
    strTxt  := StringReplace(strTxt, #13, '', [rfReplaceAll]);
    strTxt  := StringReplace(strTxt, #10, '', [rfReplaceAll]);
    strTxt  := StringReplace(strTxt,  #9, '', [rfReplaceAll]);
    strTxt  := StringReplace(strTxt, ' ', '', [rfReplaceAll]);
    Result  := strTxt;
end;

// returns a base64 value (A-Z,a-z,0-9,+,/) for a value 0-63
function fnBase64Digit(value: Integer): Byte;
var
    intRet  : integer;
begin
    if not ( (value >=0) and (value <= 63)) then
    begin
        result := 0;
        exit;
    end;

    Case value of
        // A-Z
        0..25   : intRet := ord('A') + value;
        // a-z
        26..51  : intRet := ord('a') + (value-26);
        // 0-9
        52..61  : intRet := ord('0') + (value-52);
        // +
        62      : intRet := ord('+');
        // /
        63      : intRet := ord('/');
    else
        // illegal input, return error code
        intRet := ord('?');
    end;

    Result := intRet;

end;

//return base64 char value for the only or leftmost byte
//   of the given string, 0-63 (or 255 for an error)
function fnBase64Value(value: char): Integer;
var
    n : integer;
begin

    case value of
        'A'..'Z'    : n := ord(value) - ord('A');
        'a'..'z'    : n := 26 + ord(value) - ord('a');
        '0'..'9'    : n := 52 + ord(value) - ord('0');
        '+'         : n := 62;
        '/'         : n := 63;
        '='         : n := 0;
    else
        n   := 255;   // return error code
    end;
    Result := n;

end;

function IsBase64(str: string; MSGBOX_SHOW: boolean=False): Boolean;
var
    i : integer;
    c : char;
begin
    if str = '' then
    begin
        Result := False;
        exit;
    end;

    str := fnRemoveWhitespace(str);
    for i := 1 to Length(str) do
    begin
        c := str[i];
        Case c of
            // if good, do nothing
            'A'..'Z', 'a'..'z', '0'..'9', '+', '/', #13, #10 : begin end;
            '=' : begin
                        if (i = (Length(str) - 1)) then
                        begin
                            if str[i+1] = '=' then
                            begin
                            end;
                        end else if (i = Length(str)) then
                        begin

                        end else
                        begin
                            if MSGBOX_SHOW then
                                MessageBox(0, 'Text Error: Equal Sign not at end of text.', 'TRIM END OF TEXT', MB_OK + MB_ICONWARNING);
                            Result := False;
                            exit;
                        end;
                    end;
        else
            if MSGBOX_SHOW then
                MessageBox(0, PChar('Non-base64 character <' + Copy(str, i, 1) + '> found in base64 text.'),
                    'ILLEGAL BASE64 BYTE', MB_OK + MB_ICONWARNING);
            Result := False;    //  fails base64 character content test
            Exit;
        end;
    end;
    Result := True;
end;

function fnDecode4(str: string): string;
var
    n : array[1..4] of integer;
    i : integer;
    nBits : Longint;
begin
    Result := '';
    if (Length(str) <> 4) or not (IsBase64(str)) then
        exit;

    for i := 1 to 4 do
    begin
        n[i] := fnBase64Value(str[i]);
        if n[i] = 255 then
            exit;
    end;

    // merge the values into 24 bits
    nBits := 0;
    nBits := nBits or n[4];
    nBits := nBits or (n[3] * 64);            // VB -> 64&  <- what??
    nBits := nBits or (n[2] * 64 * 64);
    nBits := nBits or (n[1] * 64 * 64 * 64);

    Result := chr( ((nBits div 256) div 256) )
            + chr( (nBits div 256) and 255 )
            + chr(nBits and 255);
end;


function fnEncode3(str: string): string;
var
    n : array[1..3] of byte;
    i : byte;
    nBits : Longint;
begin
    Result := '';
    if Length(str) <> 3 then exit;

    for i := 1 to 3 do
        n[i] := ord( str[i] );

    // merge the values into 24 bits
    nBits := 0;
    nBits := nBits or n[3];
    nBits := nBits or (n[2] * 256);
    nBits := nBits or (n[1] * 256 * 256);

    Result := chr( fnBase64Digit( ( (((nBits div 64) div 64) div 64) and 63) ) )
            + chr( fnBase64Digit( ( ((nBits div 64) div 64) and 63) ) )
            + chr( fnBase64Digit( ( (nBits div 64) and 63) ) )
            + chr( fnBase64Digit( (nBits and 63) ) );

end;


// return the original data in a string, from a given Base64 encoded text
function fnBase64Decode(str: string): string;
var
    strTxt      : string;
    intStrLen   : integer;
    strFour     : string;
    strThree    : string;
    strRet      : string;
begin
    // get working copy of base64 text
    strTxt      := fnRemoveWhitespace(str);
    intStrLen   := Length(strTxt);
    strRet      := '';
    if intStrLen > 0 then
    repeat
        // get the next group of four bytes
        strFour := Copy(strTxt, 1, 4);
        strTxt := Copy(strTxt, 5, intStrLen);
        // pad to four bytes if necessary
        while Length(strFour) < 4 do
            strFour := strFour + '=';
        // convert the group of four bytes
        strThree := fnDecode4(strFour);
        if Length(strThree) = 3 then
            strRet  := strRet + strThree
        else
        begin
            if MessageBox(0, PChar('Illegal Characters <' + strFour + '> found.'), 'Program Warning', MB_OKCANCEL + MB_IConWARNING) = ID_CANCEL then
                break;
            strRet  := strRet + '???';
        end;
    Until(strTxt = '');

    Result  := strRet;
end;

// returns a base64 coded string of the given text
function fnBase64Encode(str: string): string;
var
    strTxt      : string;
    strThree    : string;
    strFour     : string;
    intNulls    : integer;
    intLineLens : integer;
    strRet      : string;
begin
    // get working copy of input text
    strTxt      := str;
    strRet      := '';
    intLineLens := 0;
    if Length(strTxt) > 0 then
    repeat
        // get the next group of three bytes
        strThree    := Copy(strTxt, 1, 3);
        strTxt      := Copy(strTxt, 4, Length(strTxt));
        // get the number of base64 "=" needed
        intNulls    := Length(strThree) mod 3;
        if intNulls > 0 then intNulls := 3 - intNulls;
        // pad nulls to 3 bytes
        strThree    := strThree + Copy(#0+#0, 1, intNulls);
        // convert 3 text bytes to 4 base64 bytes
        strFour     := fnEncode3(strThree);
        // if overlaying with "="
        if intNulls > 0 then
        begin
            // overlay with "="
            strFour := Copy(strFour, 1, 4 - intNulls);
            // pad nulls to 4 bytes
            strFour := strFour + Copy('==', 1, intNulls);
        end;
        // save the four bytes
        strRet  := strRet + strFour;
        // increment length of current line
        intLineLens := intLineLens + 4;
        if intLineLens >= 64 then
        begin
            strRet := strRet + #13#10;
            intLineLens := 0;
        end;
    until (strTxt = '');
    Result := strRet;
end;



end.


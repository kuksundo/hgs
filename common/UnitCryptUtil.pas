unit UnitCryptUtil;

interface

uses System.SysUtils;

const DEFAULT_ENCRYPT_KEY = '{3E61902F-AAD1-41FF-8495-9B6C129E3368}';

{Ex: txt2.Text:= EncryptStr(txt1.Text, 223);
    lbl1.Caption:= DecryptStr(txt2.Text, 223);
}
function EncryptStr(const S :WideString; Key: Word): String;
function DecryptStr(const S: String; Key: Word): String;
// will crypt A..Z, a..z, 0..9 characters by rotating
//Any characters other than A..Z, a..z, 0..9 will stay unchanged
function Crypt_ROT13(const s: string): string;
function EncryptString_Syn(ATextToEncrypt: string; AKey: string = DEFAULT_ENCRYPT_KEY): string;
function DecryptString_Syn(AEncryptedString: string; AKey: string = DEFAULT_ENCRYPT_KEY): string;

implementation

uses SynCommons, SynCrypto;

const CKEY1 = 53761;
      CKEY2 = 32618;

function EncryptStr(const S :WideString; Key: Word): String;
var   i          :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
begin
  Result:= '';
  RStr:= UTF8Encode(S);
  for i := 0 to Length(RStr)-1 do begin
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (RStrB[i] + Key) * CKEY1 + CKEY2;
  end;
  for i := 0 to Length(RStr)-1 do begin
    Result:= Result + IntToHex(RStrB[i], 2);
  end;
end;

function DecryptStr(const S: String; Key: Word): String;
var   i, tmpKey  :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
      tmpStr     :string;
begin
  tmpStr:= UpperCase(S);
  SetLength(RStr, Length(tmpStr) div 2);
  i:= 1;
  try
    while (i < Length(tmpStr)) do begin
      RStrB[i div 2]:= StrToInt('$' + tmpStr[i] + tmpStr[i+1]);
      Inc(i, 2);
    end;
  except
    Result:= '';
    Exit;
  end;
  for i := 0 to Length(RStr)-1 do begin
    tmpKey:= RStrB[i];
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (tmpKey + Key) * CKEY1 + CKEY2;
  end;
  Result:= UTF8Decode(RStr);
end;

function Crypt_ROT13(const s: string): string;
var i: integer;
begin
  result := s;
  for i := 1 to length(s) do
    case ord(s[i]) of
    ord('A')..ord('M'),ord('a')..ord('m'): result[i] := chr(ord(s[i])+13);
    ord('N')..ord('Z'),ord('n')..ord('z'): result[i] := chr(ord(s[i])-13);
    ord('0')..ord('4'): result[i] := chr(ord(s[i])+5);
    ord('5')..ord('9'): result[i] := chr(ord(s[i])-5);
    end;
end;

function EncryptString_Syn(ATextToEncrypt: string; AKey: string = DEFAULT_ENCRYPT_KEY): string;
var
  key : TSHA256Digest;
  aes : TAESCFB;
  s:RawByteString;
begin
  SynCommons.HexToBin(Pointer(SHA256(AKey)), @key, 32);

  aes := TAESCFB.Create(key, 256);
  try
    s := StringToUTF8(ATextToEncrypt);
    s := BinToBase64(aes.EncryptPKCS7(s, True));
    Result := UTF8ToString(s);
  finally
    aes.Free;
  end;
end;

function DecryptString_Syn(AEncryptedString: string; AKey: string = DEFAULT_ENCRYPT_KEY): string;
var
  key : TSHA256Digest;
  aes : TAESCFB;
  s:RawByteString;
begin
  SynCommons.HexToBin(Pointer(SHA256(AKey)), @key, 32);

  aes := TAESCFB.Create(key, 256);
  try
    s := StringToUTF8(AEncryptedString);
    s := aes.DecryptPKCS7(Base64ToBin(s), True);
    Result := UTF8ToString(s);
  finally
    aes.Free;
  end;
end;

end.

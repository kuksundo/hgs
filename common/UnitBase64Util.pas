unit UnitBase64Util;

interface

uses System.Classes, Dialogs, System.Rtti,
  SynCommons, mORMot, DateUtils, System.SysUtils;

function MakeRawUTF8ToBin64(AUTF8: RawUTF8; AIsCompress: Boolean = True): RawUTF8;
function MakeRawByteStringToBin64(ARaw: RawByteString; AIsCompress: Boolean = True): RawUTF8;
function MakeBase64ToString(AStr: RawUTF8; AIsCompress: Boolean = True): string;
function MakeBase64ToUTF8(AStr: RawUTF8; AIsCompress: Boolean = True): RawUTF8;

implementation

function MakeRawUTF8ToBin64(AUTF8: RawUTF8; AIsCompress: Boolean = True): RawUTF8;
var
  LRaw: RawByteString;
begin
  LRaw := AUTF8;
  Result := MakeRawByteStringToBin64(LRaw, AIsCompress);
end;

function MakeRawByteStringToBin64(ARaw: RawByteString; AIsCompress: Boolean = True): RawUTF8;
var
  LUTF8 : RawUTF8;
  LRaw: RawByteString;
  LStr: string;
begin
  if AIsCompress then
    ARaw := SynLZCompress(ARaw);

  LUTF8 := BinToBase64(ARaw);
  Result := LUTF8;
end;

function MakeBase64ToString(AStr: RawUTF8; AIsCompress: Boolean = True): string;
var
  LRaw: RawByteString;
begin
  LRaw := Base64ToBin(AStr);

  if AIsCompress then
    LRaw := SynLZDecompress(LRaw);

  Result := Utf8ToString(LRaw);
end;

function MakeBase64ToUTF8(AStr: RawUTF8; AIsCompress: Boolean = True): RawUTF8;
var
//  LUTF8 : RawUTF8;
  LRaw: RawByteString;
begin
  LRaw := Base64ToBin(AStr);

  if AIsCompress then
    LRaw := SynLZDecompress(LRaw);

  Result := LRaw;
end;

end.

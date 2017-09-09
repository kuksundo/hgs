//==============================================================================
// Unit File Name  :  uBase64.pas
// Include Classes :
// Purpose         :  Base64 Conversion Class
// Description     :  Conversion File or Text to File or Text by Base64
// Date            :  2001/7/13
// Programmer      : Gold Goodboy
// Modification    :
//==============================================================================
unit uBase64;

interface

uses
  Classes, SysUtils;


// Stream 을 받아서 Base64 Text로 리턴한다.
procedure OKBase64Encode(AStream: TMemoryStream; AStrings: TStrings);

// Base64 Text 를 받아서 Stream 을 리턴한다.
procedure OKBase64Decode(AStream: TMemoryStream;AStrings: TStrings);

implementation

uses uOKMIME, uOKMailUtils, Forms;

procedure OKBase64Encode(AStream: TMemoryStream; AStrings: TStrings);
const
  BytesToRead = 1024;
var
  b: array[0..1024] of byte;
  BytesRead: integer;
  b64Encode: TBase64EncodingStream;
  TextCoded: TFileStream;
  strFileName: string;
begin
  strFileName := OKGetTempPath + 'fallen_b64e.$$$';

  TextCoded := TFileStream.Create(strFileName, fmCreate or fmOpenReadWrite or fmShareExclusive);

  b64Encode := TBase64EncodingStream.Create(TextCoded);

  // Attectched File B64 Encoding Loop
  repeat
    Application.ProcessMessages;

    BytesRead := AStream.Read(b, BytesToRead);
    b64Encode.Write(b, BytesRead);

  until (BytesRead < BytesToRead);

  b64Encode.Free; // first, to flush the remaining bytes
  TextCoded.Free;

  AStrings.LoadFromFile(strFileName);
  DeleteFile(strFileName);
end;

procedure OKBase64Decode(AStream: TMemoryStream; AStrings: TStrings);
var
  i: integer;
  Dest: TFileStream;
  line, strFileName: string;
  b64Decode: TBase64DecodingStream;
  nCount : integer;
begin
  strFileName := OKGetTempPath + 'sak_b64d.$$$';
  try
    Dest := TFileStream.Create(strFileName, fmCreate or fmOpenReadWrite or fmShareExclusive);
    b64Decode := TBase64DecodingStream.Create(Dest);

    nCount := AStrings.Count;
    for i := 0 to nCount - 1 do
    begin
      line := AStrings[i];
      b64Decode.Write(pointer(line)^, length(line));
      Application.ProcessMessages;
    end;

    b64Decode.Free;
    Dest.Free;
    AStream.LoadFromFile(strFileName);
  finally
    DeleteFile(strFileName);
  end;
end;

end.


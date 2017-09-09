////////////////////////////////////////////////////////////
//
//       uOKMIME.Pas : Function Group Of OKMail
//
//       Contains: TBase64EncodingStream,
//                 TBase64DecodingStream
//
//---------------------------------------------------------------
//
//      Copyrigth (c) 2000.12.9 Gold Goodboy
//      http://www.fallenangel.pe.kr
//
////////////////////////////////////////////////////////////


unit uOKMIME;

interface

uses Classes;

type

  TBase64EncodingStream = class(TStream)
  private
    Source: TMemoryStream;
    Buf: array[0..2] of Byte;
  protected
    OutputStream: TStream;
    TotalBytesProcessed: Longint;
    BytesWritten: Longint;
  public
    constructor Create(AOutputStream: TStream);
    destructor Destroy; override;

    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;

  TBase64DecodingStream = class(TStream)
  private
    Source: TMemoryStream;
    BuffToDecode: array[0..3] of byte;
    BytesReaded: longint;
    BytesWritten: Longint;
  protected
    OutputStream: TStream;
  public
    constructor Create(AOutputStream: TStream);
    destructor Destroy; override;

    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;


// this function by Chris Günther, bugfixed by Sergio ;-)
function OKQuotedPrintableDecode(const FCurrentData: PChar): string;

// ·¹Áö½ºÆ®¸®¿¡¼­ ÇÔ¼öÀÇ Å¸ÀÔÀ» ÀÐ¾î¿Â´Ù.
function OKGetMIMEType(const FileName: string): string;


implementation

uses SysUtils, Windows, Registry;

const

  EncodingTable: PChar =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  DecodingTable: array[Byte] of Byte =
    (99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, // 0-15
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, // 16-31
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63, // 32-47
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 64, 99, 99, // 48-63
    99, 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, // 64-79
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99, // 80-95
    99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, // 96-111
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99, // 112-127
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99);


// ------------------------------------------------------------------
//  TBase64EncodingStream
// ------------------------------------------------------------------

constructor TBase64EncodingStream.Create(AOutputStream: TStream);
begin
  inherited Create;
  OutputStream := AOutputStream;
  Source := TMemoryStream.Create;
end;

destructor TBase64EncodingStream.Destroy;
var
  WriteBuf: array[0..3] of Char;
begin
  if OutputStream <> nil then
  // Fill output to multiple of 3
    case (TotalBytesProcessed mod 3) of
      1: begin
          WriteBuf[0] := EncodingTable[Buf[0] shr 2];
          WriteBuf[1] := EncodingTable[(Buf[0] and 3) shl 4];
          WriteBuf[2] := '=';
          WriteBuf[3] := '=';
          OutputStream.Write(WriteBuf, 4);
        end;
      2: begin
          WriteBuf[0] := EncodingTable[Buf[0] shr 2];
          WriteBuf[1] := EncodingTable[(Buf[0] and 3) shl 4 or (Buf[1] shr 4)];
          WriteBuf[2] := EncodingTable[(Buf[1] and 15) shl 2];
          WriteBuf[3] := '=';
          OutputStream.Write(WriteBuf, 4);
        end;
    end;
  Source.Free;
  inherited Destroy;
end;

function TBase64EncodingStream.Read(var Buffer; Count: Longint): Longint;
begin
  raise EStreamError.Create('Invalid stream operation');
end;

function TBase64EncodingStream.Write(const Buffer; Count: Longint): Longint;
var
  ReadNow: integer;
  WriteBuf: array[0..3] of Char;
begin
  TotalBytesProcessed := TotalBytesProcessed + Count;

  Source.Write(Buffer, Count);
  Source.Position := 0;
  repeat
    ReadNow := Source.Read(buf, 3);
    if ReadNow < 3 then // Not enough data available
    begin
      Source.Clear;
      Source.Write(buf, ReadNow);
      break;
    end;

    // Encode the 3 bytes in Buf
    WriteBuf[0] := EncodingTable[Buf[0] shr 2];
    WriteBuf[1] := EncodingTable[(Buf[0] and 3) shl 4 or (Buf[1] shr 4)];
    WriteBuf[2] := EncodingTable[(Buf[1] and 15) shl 2 or (Buf[2] shr 6)];
    WriteBuf[3] := EncodingTable[Buf[2] and 63];
    try
      OutputStream.Write(WriteBuf, 4);
    except
      BytesWritten := 0;
      break;
    end;
    BytesWritten := BytesWritten + 4;
    if (BytesWritten mod 76) = 0 then
      OutputStream.Write(#13#10, 2);
  until (ReadNow < 3);
  result := BytesWritten;
end;

function TBase64EncodingStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  Result := BytesWritten;

  // This stream only supports the Seek modes needed for determining its size
  if not ((((Origin = soFromCurrent) or (Origin = soFromEnd)) and (Offset = 0))
    or ((Origin = soFromBeginning) and (Offset = Result))) then
    raise EStreamError.Create('Invalid stream operation');
end;


// ------------------------------------------------------------------
//  TBase64DecodingStream
// ------------------------------------------------------------------

constructor TBase64DecodingStream.Create(AOutputStream: TStream);
begin
  inherited Create;
  OutputStream := AOutputStream;
  Source := TMemoryStream.Create;
  BytesReaded := 0;
end;

destructor TBase64DecodingStream.Destroy;
begin
  Source.Free;
  inherited Destroy;
end;

function TBase64DecodingStream.Read(var Buffer; Count: Longint): Longint;
begin
  raise EStreamError.Create('Invalid stream operation');
end;

function TBase64DecodingStream.Write(const Buffer; Count: Longint): Longint;
var
  b1: array[0..2] of byte;
  n: integer;
  RealBytes: integer;
  c: byte;
begin
  BytesWritten := 0;
  Source.Write(Buffer, Count);
  Source.Position := 0;

  repeat
    repeat
      n := Source.Read(c, 1);
      if n = 0 then
      begin
        Source.Clear;
        Source.Write(BuffToDecode, BytesReaded);
        break;
      end;
      // we must discard crlf
      if (c <> 13) and (c <> 10) then
      begin
        BuffToDecode[BytesReaded] := c;
        BytesReaded := BytesReaded + 1;
      end;
    until (n = 0) or (BytesReaded = 4);

    if BytesReaded < 4 then break;
    BytesReaded := 0;

    BuffToDecode[0] := DecodingTable[BuffToDecode[0]];
    BuffToDecode[1] := DecodingTable[BuffToDecode[1]];
    BuffToDecode[2] := DecodingTable[BuffToDecode[2]];
    BuffToDecode[3] := DecodingTable[BuffToDecode[3]];

    RealBytes := 3;
    if BuffToDecode[0] = 64 then
    begin
      RealBytes := 0;
    end else
      if BuffToDecode[2] = 64 then
      begin
        BuffToDecode[2] := 0;
        BuffToDecode[3] := 0;
        RealBytes := 1;
      end else
        if BuffToDecode[3] = 64 then
        begin
          BuffToDecode[3] := 0;
          RealBytes := 2;
        end;

    b1[0] := BuffToDecode[0] * 4 + (BuffToDecode[1] div 16);
    b1[1] := (BuffToDecode[1] mod 16) * 16 + (BuffToDecode[2] div 4);
    b1[2] := (BuffToDecode[2] mod 4) * 64 + BuffToDecode[3];

    try
      OutputStream.Write(b1, RealBytes);
    except
      BytesWritten := 0;
      break;
    end;
    BytesWritten := BytesWritten + RealBytes; // I don't like inc()
  until (False);
  result := BytesWritten;
end;

function TBase64DecodingStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  // This stream only supports the Seek modes needed for determining its size
{  if (Origin = soFromCurrent) and (Offset = 0) then
    Result := CurPos
  else if (Origin = soFromEnd) and (Offset = 0) then
    Result := DataLen
  else if (Origin = soFromBeginning) and (Offset = CurPos) then
    Result := CurPos
  else}
  raise EStreamError.Create('Invalid stream operation');
end;

function OKQuotedPrintableDecode(const FCurrentData: PChar): string;
{ This works if charset="iso-8859-1" ! }
var
  SourceIndex: Integer;
  DecodedIndex: Integer;
  Ch: Char;
  CodeHex: string;
begin
  SourceIndex := 0;
  DecodedIndex := 0;
  if (FCurrentData <> '') and (FCurrentData^ <> #0) then
  begin
    while TRUE do
    begin
      Ch := FCurrentData[SourceIndex];
      if Ch = #0 then
        break;

      if Ch = '_' then
      begin
        FCurrentData[DecodedIndex] := ' ';
        Inc(SourceIndex);
        Inc(DecodedIndex);
      end else
      begin
        if Ch <> '=' then
        begin
          FCurrentData[DecodedIndex] := Ch;
          Inc(SourceIndex);
          Inc(DecodedIndex);
        end else
        begin
          Inc(SourceIndex);
          Ch := FCurrentData[SourceIndex];
          if (Ch = #13) or (Ch = #10) then
          begin
            Inc(SourceIndex);
            Inc(SourceIndex);
          end else
          begin
            CodeHex := '$' + Ch;
            Inc(SourceIndex);
            Ch := FCurrentData[SourceIndex];
            if Ch = #0 then break;
            CodeHex := CodeHex + Ch;
            FCurrentData[DecodedIndex] := Chr(StrToIntDef(CodeHex, 64));
            Inc(SourceIndex);
            Inc(DecodedIndex);
          end;
        end;
      end;
    end;
    FCurrentData[DecodedIndex] := #0;
  end;
  Result := FCurrentData;
end;

function OKGetMIMEType(const FileName: string): string;
var
  Key: string;
begin
  Result := '';
  with TRegistry.Create do
  try
    RootKey := HKEY_CLASSES_ROOT;
    Key := ExtractFileExt(FileName);
    if KeyExists(Key) then
    begin
      OpenKey(Key, false);
      Result := ReadString('Content Type');
      CloseKey;
    end;
  finally
    if Result = '' then
      Result := 'application/octet-stream';
    free;
  end;
end;



end.


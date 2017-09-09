{ unit dtpXmlBitmaps

  This unit implements a method to embed TBitmap objects into an XML
  stream. The data is compressed and then stored using a base64 technique.

  Copyright(c) 2003 - 2011 Nils Haeck (Simdesign), info at www.simdesign.nl
}
unit dtpXmlBitmaps;

{$i simdesign.inc}

interface

uses
  Classes, Graphics, dtpGraphics, NativeXmlOld, sdCompressors;

// Read / write a TBitmap from / to an XML node
procedure XmlReadBitmap(ANode: TXmlNodeOld; const AName: Utf8String; var ABitmap: TBitmap);
procedure XmlWriteBitmap(ANode: TXmlNodeOld; const AName: Utf8String; ABitmap: TBitmap);

// Read / write a TBitmap32 from / to an XML node
procedure XmlReadBitmap32(ANode: TXmlNodeOld; const AName: Utf8String; var ABitmap: TdtpBitmap);
procedure XmlWriteBitmap32(ANode: TXmlNodeOld; const AName: Utf8String; ABitmap: TdtpBitmap);

// Read / write a TMemoryStream from / to an XML node using RLE compression
procedure XmlReadRLEStream(ANode: TXmlNodeOld; const AName: Utf8String; AStream: TMemoryStream);
procedure XmlWriteRLEStream(ANode: TXmlNodeOld; const AName: Utf8String; AStream: TMemoryStream);

// Read / write a TMemoryStream from / to an XML node using HCK compression
procedure XmlReadHCKStream(ANode: TXmlNodeOld; const AName: Utf8String; AStream: TMemoryStream);
procedure XmlWriteHCKStream(ANode: TXmlNodeOld; const AName: Utf8String; AStream: TMemoryStream);

// Write buffer memory to an XML node using HCK compression
procedure XmlWriteHCKBuf(ANode: TXmlNodeOld; const AName: Utf8String; ASource: Pointer; ASourceSize: integer);

implementation

procedure XmlReadBitmap(ANode: TXmlNodeOld; const AName: Utf8String; var ABitmap: TBitmap);
var
  M: TMemoryStream;
begin
  if not assigned(ANode) or (Length(AName) = 0) then
    exit;
  // Create memory stream that we will load from
  M := TMemoryStream.Create;
  try
    // Get stream from XML
    XmlReadHCKStream(ANode, AName, M);
    if M.Size > 0 then
    begin
      UntwiddleBytePlanes(M.Memory, M.Memory, M.Size, 3);
      if not assigned(ABitmap) then
        ABitmap := TBitmap.Create;
      // Load our bitmap from it
      ABitmap.LoadFromStream(M);
    end;
  finally
    M.Free;
  end;
end;

procedure XmlWriteBitmap(ANode: TXmlNodeOld; const AName: Utf8String; ABitmap: TBitmap);
var
  M: TMemoryStream;
begin
  if not assigned(ABitmap) or not assigned(ANode) or (Length(AName) = 0) then
    exit;
  // Create a memory stream
  M := TMemoryStream.Create;
  try
    // Save ABitmap to the memory stream
    ABitmap.SaveToStream(M);
    // Twiddle
    TwiddleBytePlanes(M.Memory, M.Memory, M.Size, 3); // Assume pf24bit most of the time
    // Save stream
    XmlWriteHCKStream(ANode, AName, M);
  finally
    M.Free;
  end;
end;

procedure XmlReadBitmap32(ANode: TXmlNodeOld; const AName: Utf8String; var ABitmap: TdtpBitmap);
var
  M: TMemoryStream;
begin
  if not assigned(ANode) or (Length(AName) = 0) then
    exit;
  // Create memory stream that we will load from
  M := TMemoryStream.Create;
  try
    // Get stream from XML
    XmlReadHCKStream(ANode, AName, M);
    if M.Size > 0 then
    begin
      UntwiddleBytePlanes(M.Memory, M.Memory, M.Size, 4); // Always 32bit
      if not assigned(ABitmap) then
        ABitmap := TdtpBitmap.Create;
      // Load our bitmap from it
      ABitmap.LoadFromStream(M);
    end;
  finally
    M.Free;
  end;
end;

procedure XmlWriteBitmap32(ANode: TXmlNodeOld; const AName: Utf8String; ABitmap: TdtpBitmap);
var
  M: TMemoryStream;
begin
  if not assigned(ABitmap) or not assigned(ANode) or (Length(AName) = 0) then
    exit;
  // Create a memory stream
  M := TMemoryStream.Create;
  try
    // Save ABitmap to the memory stream
    ABitmap.SaveToStream(M);
    // Twiddle
    TwiddleBytePlanes(M.Memory, M.Memory, M.Size, 4); // Always 32bit
    // Save stream
    XmlWriteHCKStream(ANode, AName, M);
  finally
    M.Free;
  end;
end;

procedure XmlReadRLEStream(ANode: TXmlNodeOld; const AName: Utf8String; AStream: TMemoryStream);
var
  Buf: Pointer;
  ASourceSize, AComprSize: integer;
  ABufNode, AChild: TXmlNodeOld;
begin
  if not assigned(AStream) or not assigned(ANode) or (Length(AName) = 0) then
    exit;
  AChild := ANode.NodeByName(AName);
  if not assigned(AChild) then
    exit;

  with AChild do
  begin
    // Get size
    AComprSize := ReadInteger('CompressedSize');
    ASourceSize := ReadInteger('SourceSize');
    if (AComprSize = 0) or (ASourceSize = 0) then
      exit;

    // Create buffers
    GetMem(Buf, AComprSize);
    AStream.Size := ASourceSize;
    try
      ABufNode := NodeByName('Buffer');
      if not assigned(ABufNode) then
        exit;
      // Load buffer (in Base64)
      ABufNode.BufferRead(Buf^, AComprSize);
      // RLE-Decompress
      RLEDecompress(Buf, AComprSize, AStream.Memory, ASourceSize);
      // Make sure position is at beginning
      AStream.Position := 0;
    finally
      FreeMem(Buf);
    end;
  end;
end;

procedure XmlWriteRLEStream(ANode: TXmlNodeOld; const AName: Utf8String; AStream: TMemoryStream);
var
  Buf: Pointer;
  ASourceSize, AComprSize: integer;
begin
  if not assigned(AStream) or not assigned(ANode) or (Length(AName) = 0) then
    exit;
  // Create a memory stream
  ASourceSize := AStream.Size;
  if ASourceSize = 0 then
    exit;

  // Create buffer
  GetMem(Buf, SafeDestinationSize(ASourceSize));
  try
    // RLE-Compress into buffer
    RLECompress(AStream.Memory, ASourceSize, Buf, AComprSize);
    // Save buffer (in Base64)
    with ANode.NodeNew(AName) do
    begin
      WriteInteger('SourceSize', ASourceSize);
      WriteInteger('CompressedSize', AComprSize);
      NodeNew('Buffer').BufferWrite(Buf^, AComprSize);
    end;
  finally
    FreeMem(Buf);
  end;
end;

procedure XmlReadHCKStream(ANode: TXmlNodeOld; const AName: Utf8String; AStream: TMemoryStream);
var
  Buf, Tmp: Pointer;
  ASourceSize, AComprSize: integer;
  ABufNode, AChild: TXmlNodeOld;
begin
  if not assigned(AStream) or not assigned(ANode) or (Length(AName) = 0) then
    exit;
  AChild := ANode.NodeByName(AName);
  if not assigned(AChild) then
    exit;

  with AChild do
  begin
    // Get size
    AComprSize := ReadInteger('CompressedSize');
    ASourceSize := ReadInteger('SourceSize');
    if (AComprSize = 0) or (ASourceSize = 0) then
      exit;

    // Create buffers
    GetMem(Buf, SafeDestinationSize(ASourceSize));
    GetMem(Tmp, SafeDestinationSize(ASourceSize));
    AStream.Size := ASourceSize;
    try
      ABufNode := NodeByName('Buffer');
      if not assigned(ABufNode) then
        exit;
      // Load buffer (in Base64)
      ABufNode.BufferRead(Buf^, AComprSize);
      // Optimum chain of decompressors
      HaeckDecompress(Buf, Tmp, ASourceSize);
      RLEDecompress(Tmp, ASourceSize, Buf, ASourceSize);
      DiffHaeckDecompress(Buf, AStream.Memory, ASourceSize);
      // Make sure position is at beginning
      AStream.Position := 0;
    finally
      FreeMem(Buf);
      FreeMem(Tmp);
    end;
  end;
end;

procedure XmlWriteHCKStream(ANode: TXmlNodeOld; const AName: Utf8String; AStream: TMemoryStream);
var
  Buf, Tmp: Pointer;
  ASourceSize, AComprSize: integer;
begin
  if not assigned(AStream) or not assigned(ANode) or (Length(AName) = 0) then
    exit;
  // Create a memory stream
  ASourceSize := AStream.Size;
  if ASourceSize = 0 then
    exit;

  // Create buffer
  GetMem(Buf, SafeDestinationSize(ASourceSize));
  GetMem(Tmp, SafeDestinationSize(ASourceSize));
  try
    // Optimum chain of compressors
    DiffHaeckCompress(AStream.Memory, ASourceSize, Buf, AComprSize);
    RLECompress(Buf, AComprSize, Tmp, AComprSize);
    HaeckCompress(Tmp, AComprSize, Buf, AComprSize);
    // Save buffer (in Base64)
    with ANode.NodeNew(AName) do
    begin
      WriteInteger('SourceSize', ASourceSize);
      WriteInteger('CompressedSize', AComprSize);
      NodeNew('Buffer').BufferWrite(Buf^, AComprSize);
    end;
  finally
    FreeMem(Buf);
    FreeMem(Tmp);
  end;
end;

procedure XmlWriteHCKBuf(ANode: TXmlNodeOld; const AName: Utf8String; ASource: Pointer; ASourceSize: integer);
var
  Buf, Tmp: Pointer;
  AComprSize: integer;
begin
  if not assigned(ASource) or not assigned(ANode) or (Length(AName) = 0) or (ASourceSize = 0) then
    exit;

  // Create buffer
  GetMem(Tmp, SafeDestinationSize(ASourceSize));
  GetMem(Buf, SafeDestinationSize(SafeDestinationSize(ASourceSize)));
  try
    // Optimum chain of compressors
    DiffHaeckCompress(ASource, ASourceSize, Buf, AComprSize);
    RLECompress(Buf, AComprSize, Tmp, AComprSize);
    HaeckCompress(Tmp, AComprSize, Buf, AComprSize);
    // Save buffer (in Base64)
    with ANode.NodeNew(AName) do
    begin
      WriteInteger('SourceSize', ASourceSize);
      WriteInteger('CompressedSize', AComprSize);
      NodeNew('Buffer').BufferWrite(Buf^, AComprSize);
    end;
  finally
    FreeMem(Buf);
    FreeMem(Tmp);
  end;
end;

end.

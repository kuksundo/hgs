{
  unit dtpRasterHck

  .HCK is an experimental format (however welldefined) that is used
  to compress bitmap data without any loss. Created by Nils Haeck.

  Compression is usually pretty good, and *FAST*, although not as good as
  PNG, because it does not use a palette-based approach. The format is losless.

  The format is suitable for bitmap images having bitdepths of 1, 2, 4, 8, 12, 16
  and 32 bits per channel.
  It supports full Alpha-transparency, as well as grayscale data.

  Format description:

  The file consists of:
  <Header><Data><Auxiliary_Skipped>

  <Header> is a THckHeader structure
    Magic:     Must *ALWAYS* contain the sequence 'H', 'C', 'K', #0
    Width:     The width of the image in pixels
    Height:    The height of the image in pixels
    PageCount: The number of pages (different images, same size) in this file
    BitsA:     Number of bits used per pixel for Alpha (transparency) information
    BitsR:     Number of bits used per pixel for "Red" color information
    BitsG:     Number of bits used per pixel for "Green" color information
    BitsB:     Number of bits used per pixel for "Blue" color information
    BitsI:     Number of bits used per pixel for intensity (grayscale) information
    Compression: A number indicating which kind of compression to use
      0: No compression
      1: HckDefault compression
      2..255 are reserved for future use
    ColorModel: The kind of color model that is used in the color channels
      0: RGB model, so "Red" corresponds to red etc.
      1: HSV model. H corresponds to "Red", S corresponds to "Green", V corresponds to "Blue"
      2: HSL model. H corresponds to "Red", S corresponds to "Green", L corresponds to "Blue"
      3: YUV model. Y corresponds to "Red", U corresponds to "Green", V corresponds to "Blue"
    Reserved:  Must be 0.

  Note: no palette-based color model is foreseen. If you want to use a palette, then it
    must be stored outside or at the end of the image, and the "intensity" channel should
    be used as an index.

  <Data> depends on number of pages.
    If there is only one page, then data is:
    <Data_Page0>

    If there are multiple pages (0 .. N - 1) then data is
    <PageSize_Page0>   integer
    <Data_Page0>
    <PageSize_Page1>   integer
    <Data_Page1>
    ...
    <Data_PageN-1>   -> Note: the last page does not have a <PageSize>!

  <Page_DataXX>
  Page data is compressed. It must be decompressed by using any of the
    methods as held by Header.Compression
  None       (0): <Data> contains bits in planes A, R, G, B, I; see "uncompressed data"
  HckDefault (1): In this case, <Data> consists of
    <SourceSize>       integer
    <CompressedSize>   integer
    <CompressedBits>
    The compressed bits are compressed using a chain of:
      DiffHaeckCompress();
      RLECompress();
      HaeckCompress();
    Info can be found in "Compressors.pas". To decompress them, use the reverse order:
      HaeckDecompress()
      RLEDecompress()
      DiffHaeckDecompress()

  Uncompressed data:
  <Bits_A><Bits_R><Bits_G><Bits_B><Bits_I>

  <Bits_X>
  The bits are layed out from top-left to bottom-right, a total of Width * Height.
  Depending on Header.BitsX:
  Header.BitsX = 0  -> No bits available, skip. The value in the pixel should be set to maximum
  Header.BitsX = 1  -> Bilevel channel, each byte in the data consists of data for 8 pixels.
  Header.BitsX = 2  -> 4 level image, each byte in the data consists of data for 4 pixels.
  Header.BitsX = 4  -> 16 level image, each byte in the data consists of data for 2 pixels.
  Header.BitsX = 8  -> 256 level image, each byte in the data consists of data for 1 pixel.
  Header.BitsX = 12 -> 4096 level image, each 3 bytes in the data consists of data for 2 pixel.
  Header.BitsX = 16 -> 16bit(65536) level image, each 2 bytes in the data consists of data for 1 pixel.
  Header.BitsX = 32 -> 32bit single precision float image, each 4 bytes in the data consists of data for 1 pixel.

  Note: current implementation only supports 1 and 8 bits on Alpha, and only 8 bits on
    R,G,B or I channels, and generates a 32-bit ARGB bitmap

  <Auxiliary_Skipped>
    All additional data should be added at the end of the image, so that it does not
    break the most simple implementation. Additional data could be color management,
    meta data, color palettes etc.

  Copyright (c) 2003 - 2011 by Nils Haeck, Simdesign
}
unit dtpRasterHck;

{$i simdesign.inc}

interface

uses
  Types, Classes, SysUtils, dtpRasterFormats, dtpGraphics, Math, dtpStretch, Windows,
  sdCompressors, Graphics;

type

  // This is the header that is present at the start of the HCK file. Its length
  // is exactly 24 bytes, and it starts with 'HCK'#0 (readable in editor)
  THckHeader = packed record
    Magic: array[0..3] of char; // Should contain "HCK#0"
    Width: integer;             // Width of the image in pixels
    Height: integer;            // Height of the image in pixels
    PageCount: integer;         // Number of pages in the file
    BitsA: byte;                // Number of bits for Alpha channel
    BitsR: byte;                // Number of bits for Red channel (or first channel value)
    BitsG: byte;                // Number of bits for Green channel (or second channel value)
    BitsB: byte;                // Number of bits for Blue channel (or third channel value)
    BitsI: byte;                // Number of bits for Intensity (grayscale) channel
    Compression: byte;          // 0 = No compression, 1 = HckDefault, 2 .. $FF Reserved
    ColorModel: byte;           // 0 = RGB, 1 = HSV, 2 = HSL, 3 = YUV, 4..$FF Reserved
    Reserved: byte;             // Must be 0
  end;

  THckImage = class(TdtpRaster)
  private
    FHeader: THckHeader;
    procedure HckDefaultDecompress(S: TStream; M: TMemoryStream);
    procedure HckDefaultCompress(S: TStream; M: TMemoryStream);
  protected
    function DecompressBitmapData(AMethod: byte; S: TStream; M: TMemoryStream): integer; virtual;
    procedure MemStreamToDib(M: TMemoryStream; ADib: TdtpBitmap); virtual;
  public
    class function CanLoad(S: TStream): boolean; override;
    procedure LoadImageFromStream(S: TStream; ADib: TdtpBitmap;
      AMaxSize: TPoint; Page: integer); override;
    procedure SaveImageToStream(S: TStream; ADib: TdtpBitmap); override;
  end;

  // This class exists for compatibility with TGraphic. The HCK image format can
  // thus show up in OpenPictureDialogs etc
  THckGraphic = class(TBitmap)
  public
    procedure LoadFromStream(Stream: TStream); override;
  end;


implementation

{ THckImage }

class function THckImage.CanLoad(S: TStream): boolean;
var
  AHeader: THckHeader;
  Start: integer;
begin
  Result := False;
  if not assigned(S) then
    exit;
  Start := S.Position;
  S.Read(AHeader, SizeOf(AHeader));
  CanLoad := (AHeader.Magic = 'HCK');
  S.Position := Start;
end;

function THckImage.DecompressBitmapData(AMethod: byte; S: TStream;
  M: TMemoryStream): integer;
begin
  raise ERasterError.Create(sreNoSuitableCodec);
end;

procedure THckImage.HckDefaultCompress(S: TStream;
  M: TMemoryStream);
var
  Buf1, Buf2: pointer;
  ASourceSize, AComprSize: integer;
begin
  try
    // Create buffer
    ASourceSize := M.Size;
    GetMem(Buf1, SafeDestinationSize(ASourceSize));
    GetMem(Buf2, SafeDestinationSize(ASourceSize));
    try
      // Optimum chain of compressors
      DiffHaeckCompress(M.Memory, ASourceSize, Buf1, AComprSize);
      RLECompress(Buf1, AComprSize, Buf2, AComprSize);
      HaeckCompress(Buf2, AComprSize, Buf1, AComprSize);
      // Save buffer to stream
      S.Write(ASourceSize, SizeOf(ASourceSize));
      S.Write(AComprSize, SizeOf(AComprSize));
      S.Write(Buf1^, AComprSize);
    finally
      FreeMem(Buf1);
      FreeMem(Buf2);
    end;
  except
    raise ERasterError.Create(sreUnableToCompress);
  end;
end;

procedure THckImage.HckDefaultDecompress(S: TStream; M: TMemoryStream);
var
  Buf1, Buf2: pointer;
  ASourceSize: integer;
  AComprSize: integer;
begin
  try
    // Read sizes
    S.Read(ASourceSize, SizeOf(ASourceSize));
    S.Read(AComprSize, SizeOf(AComprSize));
    if ASourceSize <> M.Size then
      raise ERasterError.Create(sreFileCorrupt);

    // Create buffer
    GetMem(Buf1, SafeDestinationSize(ASourceSize));
    GetMem(Buf2, SafeDestinationSize(ASourceSize));
    try
      // Read buffer from stream
      S.Read(Buf1^, AComprSize);
      // Optimum chain of decompressors
      HaeckDecompress(Buf1, Buf2, ASourceSize);
      RLEDecompress(Buf2, ASourceSize, Buf1, ASourceSize);
      DiffHaeckDecompress(Buf1, M.Memory, ASourceSize);
    finally
      FreeMem(Buf1);
      FreeMem(Buf2);
    end;
  except
    raise ERasterError.Create(sreUnableToDecompress);
  end;
end;

procedure THckImage.LoadImageFromStream(S: TStream; ADIB: TdtpBitmap;
  AMaxSize: TPoint; Page: integer);
var
  ABitCount: integer;
  AByteCount: integer;
  ASize: integer;
  ANextPage: integer;
  M: TMemoryStream;
  AScale: single;
  TempDib: TdtpBitmap;
  AWidth, AHeight: integer;
begin
  if not assigned(S) then
    raise ERasterError.Create(sreStreamUnassigned);

  // Load header
  S.Read(FHeader, SizeOf(FHeader));
  Width  := FHeader.Width;
  Height := FHeader.Height;

  // Total bits
  ABitCount := 0;
  inc(ABitCount, FHeader.BitsA);
  inc(ABitCount, FHeader.BitsR);
  inc(ABitCount, FHeader.BitsG);
  inc(ABitCount, FHeader.BitsB);
  inc(ABitCount, FHeader.BitsI);
  ABytecount := (ABitCount + 7) div 8;

  // Uncompressed size of one page
  ASize := AByteCount * Width * Height;
  if ASize = 0 then
    exit;

  // If there's more than one page.. first position the stream in the right spot
  if FHeader.PageCount > 1 then
  begin
    repeat
      S.Read(ANextPage, SizeOf(ANextPage));
      if Page = 0 then break;
      dec(Page);
      // Jump over pages until we reach ours
      S.Seek(ANextPage, soFromCurrent);
    until False;
  end else
  begin
    if Page <> 0 then
      raise ERasterError.Create(sreIllegalPageNumber);
  end;

  // We are at the right page - Get the bitmap data into memory
  M := TMemoryStream.Create;
  try
    M.Size := ASize;
    // If compression is used, let the decompressor handle it
    case FHeader.Compression of
    0: M.CopyFrom(S, ASize);
    1: HckDefaultDecompress(S, M);
    else
      // Future extensions through override
      DecompressBitmapData(FHeader.Compression, S, M);
    end;

    // Empty memory stream means trouble
    if M.Size = 0 then exit;

    // Determine scale
    AScale := Min(AMaxSize.X / Width, AMaxSize.Y / Height);
    if (AScale > 0) and (AScale < 1.0) then
    begin
      TempDib := TdtpBitmap.Create;
      try
        TempDib.SetSize(Width, Height);
        AWidth  := round(Width  * AScale);
        AHeight := round(Height * AScale);

        // Memory bits to the DIB
        MemStreamToDib(M, TempDib);

        // Downscale the temp DIB into ADib
        ADib.SetSize(AWidth, AHeight);
        DownscaleTransfer(
          ADib,    Rect(0, 0, AWidth, AHeight),  // Downscaled size
          TempDib, Rect(0, 0,  Width,  Height)); // Original size

      finally
        TempDib.Free;
      end;
    end else
    begin

      // New Dib size
      ADib.SetSize(Width, Height);

      // We must now assign the memory bits to the DIB
      MemStreamToDib(M, ADib);

    end;
  finally
    M.Free;
  end;
end;

procedure THckImage.MemStreamToDib(M: TMemoryStream;
  ADib: TdtpBitmap);
// Here we must untwiddle the byte planes
var
  i, j: integer;
  P: PdtpColor;
  B: PByte;
  C: PByte;
  G: Byte;
  ASize: integer;
begin
  try
    // Prepare
    B := M.Memory;
    ASize := ADib.Width * ADib.Height;

    // Alpha channel
    P := @ADib.Bits[0];
    if FHeader.BitsA > 0 then
    begin
      case FHeader.BitsA of
      1: // Convert Alpha bilevel to 0..255
      begin
        for i := 0 to (ASize + 7) div 8 - 1 do
        begin
          for j := 0 to 7 do
          begin
              P^ := 0;
              if (B^ and $80) > 0 then
                P^ := $FF000000;
              B^ := B^ shl 1;
              inc(P);
            end;
            inc(B);
          end;
        end;
      8: // We have full 1:1 alpha info
        begin
          for i := 0 to ASize - 1 do
          begin
            P^ := B^ shl 24;
            inc(B);
            inc(P);
          end;
        end;
      else
        raise ERasterError.Create(sreUnsupportedBitdepth);
      end;
    end else
    begin
      // No alpha information.. fill Alpha channel with $FF
      for i := 0 to ADib.Width * ADib.Height - 1 do
      begin
        P^ := $FF000000;
        inc(P);
      end;
    end;

    // Red, Green, Blue
    if FHeader.BitsR > 0 then
    begin
      if FHeader.BitsR <> 8 then
        raise ERasterError.Create(sreUnsupportedBitdepth);

      // Set red
      C := @ADib.Bits[0]; inc(C, 2);
      for i := 0 to ASize - 1 do
      begin
        C^ := B^;
        inc(B);
        inc(C, 4);
      end;
    end;
    if FHeader.BitsG > 0 then
    begin
      if FHeader.BitsG <> 8 then
        raise ERasterError.Create(sreUnsupportedBitdepth);

      // Set green
      C := @ADib.Bits[0]; inc(C, 1);
      for i := 0 to ASize - 1 do
      begin
        C^ := B^;
        inc(B);
        inc(C, 4);
      end;
    end;
    if FHeader.BitsB > 0 then
    begin
      if FHeader.BitsB <> 8 then
        raise ERasterError.Create(sreUnsupportedBitdepth);

      // Set blue
      C := @ADib.Bits[0]; inc(C, 0);
      for i := 0 to ASize - 1 do
      begin
        C^ := B^;
        inc(B);
        inc(C, 4);
      end;
    end;

    // Intensity
    if FHeader.BitsI > 0 then
    begin
      C := @ADib.Bits[0];
      case FHeader.BitsI of
      1: // Just bilevel image
        begin
          for i := 0 to (ASize + 7) div 8 - 1 do
          begin
            for j := 0 to 7 do begin
              G := 0;
              if (B^ and $80) > 0 then
                G := $FF;
              B^ := B^ shl 1;
              inc(C); C^ := G;
              inc(C); C^ := G;
              inc(C); C^ := G;
              inc(C);
            end;
            inc(B);
          end;
        end;
      8: // 8bit grayscale values
        begin
          // Set grayscale
          for i := 0 to ASize - 1 do
          begin
            inc(C); C^ := B^;
            inc(C); C^ := B^;
            inc(C); C^ := B^;
            inc(C); inc(B);
          end;
        end;
      else
        raise ERasterError.Create(sreUnsupportedBitdepth);
      end;// case
    end;

  except
    raise ERasterError.Create(sreFileCorrupt);
  end;
end;

procedure THckImage.SaveImageToStream(S: TStream; ADIB: TdtpBitmap);
var
  i: integer;
  APlaneSize: integer;
  M: TMemoryStream;
  A, R, G, B, C: PByte;
begin
  if not assigned(S) then
    raise ERasterError.Create(sreStreamUnassigned);

  FillChar(FHeader, SizeOf(FHeader), 0);
  FHeader.Magic       := 'HCK'#0;
  FHeader.Width       := ADib.Width;
  FHeader.Height      := ADib.Height;
  FHeader.PageCount   := 1;
  FHeader.BitsA       := 8;
  FHeader.BitsR       := 8;
  FHeader.BitsG       := 8;
  FHeader.BitsB       := 8;
  FHeader.Compression := 1; // HckDefault compression

  // Write header
  S.Write(FHeader, SizeOf(FHeader));

  // Uncompressed size of one plane
  APlaneSize := ADib.Width * ADib.Height;
  if APlaneSize = 0 then
    exit;

  // Write (twiddle) the bitmap data to a memory stream
  M := TMemoryStream.Create;
  try
    M.Size := APlaneSize * 4;

    A := M.Memory;
    R := A; inc(R, APlaneSize);
    G := R; inc(G, APlaneSize);
    B := G; inc(B, APlaneSize);
    C := @ADib.Bits[0];
    for i := 0 to APlaneSize - 1 do
    begin
      B^ := C^; inc(C);
      G^ := C^; inc(C);
      R^ := C^; inc(C);
      A^ := C^; inc(C);
      inc(A);
      inc(R);
      inc(G);
      inc(B);
    end;
    case FHeader.Compression of
    1: HckDefaultCompress(S, M);
    end;

  finally
    M.Free;
  end;
end;

{ THckGraphic }

procedure THckGraphic.LoadFromStream(Stream: TStream);
var
  ADib: TdtpBitmap;
  AHck: THckImage;
begin
  ADib := TdtpBitmap.Create;
  AHck := THckImage.Create;
  try
    AHck.LoadImageFromStream(Stream, ADib, Point(0, 0), 0);
    Assign(ADib);
  finally
    ADib.Free;
    AHck.Free;
  end;
end;

initialization

  RegisterRasterClass(THckImage, 'HCK Image', '.hck;',
    [ofLoadStream, ofLoadFile, ofSaveStream, ofSaveFile, ofMultiPage, ofHasAlpha]);

  // Register the file format with the graphics unit, so an image shows up in
  // the OpenPicture and SavePicture dialog boxes
  TPicture.RegisterFileFormat('HCK', 'HCK Image', THCKGraphic);

finalization

  TPicture.UnregisterGraphicClass(THCKGraphic);  

end.

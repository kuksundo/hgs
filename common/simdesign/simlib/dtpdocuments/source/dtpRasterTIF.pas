{
  Unit dtpRasterTIF

  Adds TIFF support to the dtpRaster class. Note: please read the instructions
  in the TIFImage subfolder's README.TXT carefully.

  Project: DTP-Engine

  Creation Date: 22-02-2004 (NH)

  Modifications:

  Copyright (c) 2003-2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpRasterTIF;

{$i simdesign.inc}

interface

uses
  Forms, Windows, Graphics, Classes, dtpRasterFormats, LibTiff_API, dtpGraphics,
  Dialogs, SysUtils;

type

  TTifImage = class(TdtpRaster)
  private
  protected
  public
    procedure LoadImageFromFile(const AFileName: string; ADIB: TdtpBitmap;
      AMaxSize: TPoint; Page: integer); override;
    procedure LoadImageFromStream(S: TStream; ADIB: TdtpBitmap;
      AMaxSize: TPoint; Page: integer); override;
  end;

  // This class exists for compatibility with TGraphic. The TIFF image format can
  // thus show up in OpenPictureDialogs etc
  TTifGraphic = class(TBitmap)
  public
    procedure LoadFromFile(const Filename: string); override;
    procedure SaveToFile(const Filename: string); override;
  end;

implementation

{ Stream callback routines }

function TIFFReadProc(fd: thandle_t; buf: PData_t; size: tsize_t): tsize_t; cdecl;
// The fd is a pointer to the stream
begin
  Result := TStream(fd).Read(Buf^, Size);
end;

function TIFFWriteProc(fd: thandle_t; buf: PData_t; size: tsize_t): tsize_t; cdecl;
begin
  Result := TStream(fd).Write(Buf^, Size);
end;

function TIFFSeekProc(fd: thandle_t; off: toff_t; whence: Integer): toff_t; cdecl;
begin
  Result := TStream(fd).Seek(off, whence);
end;

function TIFFCloseProc(fd: thandle_t): Integer; cdecl;
begin
  // We do not close the stream, we do that ourself!
  Result := 0;
end;

function TIFFSizeProc(fd: thandle_t): toff_t; cdecl;
begin
  Result := TStream(fd).Size;
end;

function TIFFMapProc(fd: thandle_t; pbase: PData_t; psize: Poff_t): Integer; cdecl;
begin
  Result := 0;
end;

procedure TIFFUnmapProc(fd: thandle_t; base: PData_t; size: toff_t); cdecl;
begin
//
end;

{ TTifImage }

type
  TRgbaRec = packed record
    R, G, B, A: byte;
  end;
  TBgraRec = packed record
    B, G, R, A: byte;
  end;

procedure TiffErrorHandler(const aChar, bChar: pchar; aList: Tva_list); cdecl;
begin
  ShowMessage(aChar + ': ' + bChar);
end;

procedure TTifImage.LoadImageFromFile(const AFileName: string;
  ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer);
var
  i, j: integer;
  ATif: PTiff;
  AWidth, AHeight: TUInt32;
  AData: PDataArray;
  ASrc, ADst: PdtpColor;
begin
  if not IsTifInitialized then
    raise ERasterError.Create(sreLibraryNotLoaded);

  // Set error handler
  TiffSetErrorHandler(@TiffErrorHandler);

  // Open the TIFF file, returns a handle or nil if error, in that case the
  // error handler will show a message (hopefully)
  ATif := TiffOpen(PChar(AFileName), 'r');
  if not assigned(ATif) then exit;
  try

  // Get correct image
  if assigned(TIFFNumberOfDirectories) then
    PageCount := TIFFNumberOfDirectories(ATif);

  if Page >= PageCount then
    raise ERasterError.Create(sreIllegalPageNumber);

  // Set correct page num
  TIFFSetDirectory(ATif, Page);

  TIFFGetField(ATif, TIFFTAG_IMAGEWIDTH,  @AWidth);
  TIFFGetField(ATif, TIFFTAG_IMAGELENGTH, @AHeight);
  AData := _TIFFmalloc(AWidth * AHeight * SizeOf(TUInt32));
  try
    TIFFReadRGBAImage(ATif, AWidth, AHeight, AData, 0);
    // Enter data in our ADIB
    ADib.Width := AWidth;
    ADib.Height := AHeight;
    // data is upside down - fix that
    ASrc := @AData^[0];
    for i := AHeight - 1 downto 0 do begin
      ADst := @ADib.Bits[i * integer(AWidth)];
      for j := 0 to AWidth - 1 do begin
        // Colors R<>B are flipped too, fix here
        TRgbaRec(ADst^).R := TBgraRec(ASrc^).R;
        TRgbaRec(ADst^).G := TBgraRec(ASrc^).G;
        TRgbaRec(ADst^).B := TBgraRec(ASrc^).B;
        TRgbaRec(ADst^).A := TBgraRec(ASrc^).A;
        inc(ADst);
        inc(ASrc);
      end;
    end;
  finally
    // Free the data again
    _TiffFree(AData);
  end;
  finally
    TiffClose(ATif);
  end;
end;

procedure TTifImage.LoadImageFromStream(S: TStream; ADIB: TdtpBitmap;
  AMaxSize: TPoint; Page: integer);
var
  i, j: integer;
  ATif: PTiff;
  AWidth, AHeight: TUInt32;
  AData: PDataArray;
  ASrc, ADst: PdtpColor;
begin
  if not IsTifInitialized then
    raise ERasterError.Create(sreLibraryNotLoaded);

  // Set error handler
  TiffSetErrorHandler(@TiffErrorHandler);

  // Open the TIFF file, returns a handle or nil if error, in that case the
  // error handler will show a message (hopefully)
  if not assigned(TiffClientOpen) then exit;
  // We use the client open method so we can use our stream. The stream callback
  // routines provide the reading / seeking from the stream
  ATif := TiffClientOpen('', 'r', cardinal(S), @TiffReadProc, @TiffWriteProc,
    @TiffSeekProc, @TiffCloseProc, @TiffSizeProc, @TiffMapProc, @TiffUnmapProc);
  if not assigned(ATif) then exit;
  try

    // Get correct image
    if assigned(TIFFNumberOfDirectories) then
      PageCount := TIFFNumberOfDirectories(ATif);

    if Page >= PageCount then
      raise ERasterError.Create(sreIllegalPageNumber);

    // Set correct page num
    TIFFSetDirectory(ATif, Page);

    TIFFGetField(ATif, TIFFTAG_IMAGEWIDTH,  @AWidth);
    TIFFGetField(ATif, TIFFTAG_IMAGELENGTH, @AHeight);

    AData := _TIFFmalloc(AWidth * AHeight * SizeOf(TUInt32));
    try

      TIFFReadRGBAImage(ATif, AWidth, AHeight, AData, 0);
      // Enter data in our ADIB
      ADib.Width := AWidth;
      ADib.Height := AHeight;
      // data is upside down - fix that
      ASrc := @AData^[0];
      for i := AHeight - 1 downto 0 do begin
        ADst := @ADib.Bits[i * integer(AWidth)];
        for j := 0 to AWidth - 1 do begin
          // Colors R<>B are flipped too, fix here
          TRgbaRec(ADst^).R := TBgraRec(ASrc^).R;
          TRgbaRec(ADst^).G := TBgraRec(ASrc^).G;
          TRgbaRec(ADst^).B := TBgraRec(ASrc^).B;
          TRgbaRec(ADst^).A := TBgraRec(ASrc^).A;
          inc(ADst);
          inc(ASrc);
        end;
      end;
    finally
      // Free the data again
      _TiffFree(AData);
    end;
  finally
    TiffClose(ATif);
  end;
end;

{ TTifGraphic }

procedure TTifGraphic.LoadFromFile(const Filename: string);
var
  ADib: TdtpBitmap;
  ALoader: TdtpImageFiler;
begin
  ADib := TdtpBitmap.Create;
  ALoader := TdtpImageFiler.Create;
  try
    ALoader.Filename:= Filename;
    ALoader.LoadDIB(ADib);
    Assign(ADib);
  finally
    ADib.Free;
    ALoader.Free;
  end;
end;

procedure TTifGraphic.SaveToFile(const Filename: string);
var
  ADib: TdtpBitmap;
  ASaver: TdtpImageFiler;
begin
  ADib := TdtpBitmap.Create;
  ASaver := TdtpImageFiler.Create;
  try
    ADib.Assign(Self);
    ASaver.Filename:= Filename;
    ASaver.SaveDIB(ADib);
  finally
    ADib.Free;
    ASaver.Free;
  end;
end;

initialization

  LoadTIFLibrary(IncludeTrailingBackslash(ExtractFileDir(Application.ExeName)));

  RegisterRasterClass(TTifImage, 'TIFF Image', '.tiff;.tif;',
    [ofLoadFile, ofLoadStream, ofMultiPage, ofHasAlpha, ofNoListing]);

  // Register the file format with the graphics unit, so an image shows up in
  // the OpenPicture and SavePicture dialog boxes
  TPicture.RegisterFileFormat('TIF', 'Tiff Image', TTifGraphic);

finalization

  TPicture.UnregisterGraphicClass(TTifGraphic);

end.

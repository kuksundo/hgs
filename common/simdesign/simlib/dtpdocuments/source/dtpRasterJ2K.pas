{ unit dtpRasterJ2K

  Jpeg2000 image loader / saver for dtpDocuments library

  This code uses the Jasper DLL that can be obtained from:
  http://www.ece.uvic.ca/~mdadams/jasper/

  You may use Jasper.DLL in your projects as long as you abide to the license
  agreement stated in the Jasper package.

  The loading/saving code here is merely an interface to this DLL.

  Project: DTP-Engine

  Creation Date: 22-02-2004 (NH)

  Modifications:

  Copyright (c) 2003-2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
}
unit dtpRasterJ2K;

{$i simdesign.inc}

interface

uses
  SysUtils, Classes, Forms, Windows, Graphics, dtpRasterFormats, dtpGraphics;

type

  TJ2KImage = class(TdtpRaster)
  public
    procedure LoadImageFromFile(const AFileName: string; ADIB: TdtpBitmap;
      AMaxSize: TPoint; Page: integer); override;
    procedure SaveImageToFile(const AFileName: string; ADIB: TdtpBitmap); override;
  end;

  // This class exists for compatibility with TGraphic. The JP2 image format can
  // thus show up in OpenPictureDialogs etc
  TJ2KGraphic = class(TBitmap)
  public
    procedure LoadFromFile(const Filename: string); override;
    procedure SaveToFile(const Filename: string); override;
  end;

var

  FHasJp2Plugin: boolean = False;

// Read a JPeg2000 file using the JasPer DLL
procedure ReadJp2(const AFileName: string; var Error: string; Bitmap: TBitmap);

// Write a JPeg2000 file using the JasPer DLL
procedure WriteJp2(const AFileName: string; var Error: string; Bitmap: TBitmap);

resourcestring

  sj2kCannotOpenFile          = 'Unable to open file';
  sj2kErrorInBitmapData       = 'Error in bitmap data';
  sj2kInvalidPixelFormat      = 'Invalid pixel Format';
  sj2kMismatchColorPlanes     = 'The image contains %d color planes, only 3 were loaded';
  sj2kUnsupportedBitmapFormat = 'Unsupported bitmap Format';
  sj2kUnsupportedPixelFormat  = 'Unsupported pixel Format';

implementation

type

  RGBRec = packed record
    B, G, R: byte;
  end;
  PRGBRec = ^RGBRec;

  TPalette = packed array[0..255] of RGBRec;
  PPalette = ^TPalette;

  // TImageContainer is used to communicate image info in JPeg2000 DLL
  TImageContainer = record
    Width, Height: integer;
    BytesPerLine: integer;
    PixelFormat: integer; // $QP: P is number of planes, Q=0 BGR, Q=1 BGR seperated planes
    Map: PByteArray;
    Palette: PPalette;
    Options: PChar;
  end;
  PImageContainer = ^TImageContainer;

var
  // DLL module
  HJp2: HModule = 0;

  DllReadJP2: function (FileName, FileType: PChar; var Image: TImageContainer): integer; stdcall;
  DllSaveJP2: function (FileName, FileType: PChar; var Image: TImageContainer): integer; stdcall;
  DllFreeJP2: function (var Image: TImageContainer): Integer; stdcall;

procedure LoadJP2Library;
var
  AFolderName: string;
begin
  AFolderName := IncludeTrailingBackslash(ExtractFileDir(Application.ExeName));
  // JP2
  HJp2 := LoadLibrary(PChar(AFoldername + 'JasPerLib.dll'));
  if HJp2 <> 0 then begin
    @DllReadJP2 := GetProcAddress(HJp2, '?LibLoadImage@@YGHPAD0PAUTImageContainer@@@Z');
    @DllSaveJP2 := GetProcAddress(HJp2, '?LibSaveImage@@YGHPAD0PAUTImageContainer@@@Z');
    @DllFreeJP2 := GetProcAddress(HJp2, '?LibFreeImage@@YGHPAUTImageContainer@@@Z');
    if assigned(DllReadJP2) then
      FHasJP2Plugin := True;
  end;
end;

procedure UnloadJP2Library;
begin
  // JP2
  if HJp2 <> 0 then begin
    FreeLibrary(HJp2);
    HJp2 := 0;
  end;
end;

procedure ReadJp2(const AFilename: string; var Error: string; Bitmap: TBitmap);
// Read a JPeg2000 file using the JasPer DLL
var
  i, AResult, Planes, C, P: integer;
  AImage: TImageContainer;
  AFiletype: string;
  ScanSize, BitsSize: integer;
  Interleaved: boolean;
  AMap: PByteArray;
  SrcPix, DstPix: PByte;
  pal: PLogPalette;
  hpal: HPALETTE;
begin
  AImage.Options := PChar(#0);
  AFileType := copy(ExtractFileExt(AFilename), 2, 255);
  AResult := DllReadJp2(PChar(AFileName), PChar(AFileType), AImage);
  if AResult = 0 then begin
    try
      Planes := AImage.PixelFormat and $0F;
      if Planes > 3 then Planes := 3;
      Interleaved := (AImage.PixelFormat and $F0 = $10) and (Planes > 1);
      case Planes of
      1:    Bitmap.PixelFormat := pf8bit;
      2, 3: Bitmap.PixelFormat := pf24bit;
      else
        Error := sj2kUnsupportedBitmapFormat;
        exit;
      end;

      Bitmap.Width  := AImage.Width;
      Bitmap.Height := AImage.Height;
      ScanSize := Planes * AImage.Width;
      BitsSize := Planes * AImage.Width * AImage.Height;

      // if interleaved data then de-interleave first
      if Interleaved then begin
        GetMem(AMap, BitsSize);
        try
          Move(AImage.Map^, AMap^, BitsSize);
          SrcPix := pointer(AMap);
          for C := 0 to Planes - 1 do begin
            DstPix := @AImage.Map^[C];
            for P := 1 to AImage.Width * AImage.Height do begin
              DstPix^ := SrcPix^;
              Inc(SrcPix);
              Inc(DstPix, Planes);
            end;
          end;
        finally
          FreeMem(AMap);
        end;
      end;

      // Palette based images
      if Bitmap.PixelFormat = pf8bit then begin
        // Create correct palette
        GetMem(pal, sizeof(TLogPalette) + sizeof(TPaletteEntry) * 256);
        try
          pal.palVersion := $300;
          pal.palNumEntries := 256;
          if assigned(AImage.Palette) then begin
            // Palette from image
            for i := 0 to 255 do begin
              pal.palPalEntry[i].peRed   := AImage.Palette[i].R;
              pal.palPalEntry[i].peGreen := AImage.Palette[i].G;
              pal.palPalEntry[i].peBlue  := AImage.Palette[i].B;
            end;
          end else begin
            // Grayscale palette
            for i := 0 to 255 do begin
              pal.palPalEntry[i].peRed   := i;
              pal.palPalEntry[i].peGreen := i;
              pal.palPalEntry[i].peBlue  := i;
            end;
          end;
          hpal := CreatePalette(pal^);
          if hpal <> 0 then
            Bitmap.Palette := hpal;
        finally
          FreeMem(pal);
        end;
      end;

      // Image bits
      if (Planes = 1) or (Planes = 3) then begin
        // Copy the bits scanline by scanline
        for i := 0 to Bitmap.Height - 1 do
          {$R-}
          Move(AImage.Map^[i * ScanSize], Bitmap.Scanline[i]^, ScanSize);
      end else begin
        // We can do nothing with this
        Error := sj2kUnsupportedPixelFormat;
        Bitmap.Width  := 0;
        Bitmap.Height := 0;
        exit;
      end;

      if (AImage.PixelFormat and $0F) > 3 then
        Error := Format(sj2kMismatchColorPlanes, [AImage.PixelFormat and $0F]);

    finally
      DllFreeJp2(AImage);
    end;
  end else begin
    case AResult of
    2: Error := sj2kCannotOpenFile;
    3: Error := sj2kErrorInBitmapData;
    4: Error := sj2kInvalidPixelFormat;
    else
      Error := Format(sj2kErrorInBitmapData + ' (%d)', [AResult]);
    end;
  end;
end;

procedure WriteJp2(const AFilename: string; var Error: string; Bitmap: TBitmap);
// Write a JPeg2000 file using the JasPer DLL
var
  i, AResult, Planes: integer;
  AImage: TImageContainer;
  APalette: TPalette;
  AFiletype: string;
  ScanSize: integer;
  PPalEntry: PPaletteEntry;
begin
  AImage.Options := PChar(#0);
  AFileType := copy(ExtractFileExt(AFilename), 2, 255);

  // Planes
  case Bitmap.PixelFormat of
  pf8bit:  Planes := 1;
  pf24bit: Planes := 3;
  else
    Error := sj2kUnsupportedBitmapFormat;
    exit;
  end;

  // Image container
  FillChar(AImage, SizeOf(AImage), 0);
  AImage.Width  := Bitmap.Width;
  AImage.Height := Bitmap.Height;
  AImage.PixelFormat := Planes;
  ScanSize := Planes * AImage.Width;

  // Get memory for map
  GetMem(AImage.Map, Planes * AImage.Width * AImage.Height);

  // Copy the bits scanline by scanline
  for i := 0 to Bitmap.Height - 1 do
    Move(Bitmap.Scanline[i]^, AImage.Map^[i * ScanSize], ScanSize);

  // Palette based images
  if Bitmap.PixelFormat = pf8bit then begin
    AImage.Palette := @APalette;
    // Palette to image
    for i := 0 to 255 do begin
      GetPaletteEntries(Bitmap.Palette, i, 1, PPalEntry);
      if assigned(PPalEntry) then begin
        AImage.Palette[i].R := PPalEntry.peRed;
        AImage.Palette[i].G := PPalEntry.peGreen;
        AImage.Palette[i].B := PPalEntry.peBlue;
      end else begin
        // assume grayscale
        AImage.Palette[i].R := i;
        AImage.Palette[i].G := i;
        AImage.Palette[i].B := i;
      end;
    end;
  end;

  AResult := DllSaveJp2(PChar(AFileName), PChar(AFileType), AImage);

  if AResult <> 0 then
    Error := Format(sj2kErrorInBitmapData + '(%d)', [AResult]);
end;

{ TJ2KImage }

procedure TJ2KImage.LoadImageFromFile(const AFileName: string;
  ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer);
var
  ABitmap: TBitmap;
  Error: string;
begin
  if not assigned(DllReadJP2) then
    raise ERasterError.Create(sreLibraryNotLoaded);

  // Quick'n'dirty
  ABitmap := TBitmap.Create;
  try
    ReadJP2(AFileName, Error, ABitmap);
    ADib.Assign(ABitmap);
  finally
    ABitmap.Free;
  end;
end;

procedure TJ2KImage.SaveImageToFile(const AFileName: string;
  ADIB: TdtpBitmap);
var
  ABitmap: TBitmap;
  Error: string;
begin
  if not assigned(DllSaveJP2) then 
    raise ERasterError.Create(sreLibraryNotLoaded);

  // Quick'n'dirty
  ABitmap := TBitmap.Create;
  try
    ABitmap.Assign(ADib);
    // force
    ABitmap.PixelFormat := pf24bit;
    WriteJP2(AFileName, Error, ABitmap);
  finally
    ABitmap.Free;
  end;
end;

{ TJ2KGraphic }

procedure TJ2KGraphic.LoadFromFile(const Filename: string);
var
  Error: string;
begin
  if assigned(DllReadJp2) then
    ReadJp2(Filename, Error, Self);
end;

procedure TJ2KGraphic.SaveToFile(const Filename: string);
var
  Error: string;
begin
  if assigned(DllSaveJp2) then
    WriteJp2(Filename, Error, Self);
end;

initialization

  LoadJP2Library;

  RegisterRasterClass(TJ2KImage, 'JPeg2000 Image', '.jp2;',
    [ofLoadFile, ofSaveFile]);

  // Register the file format with the graphics unit, so an image shows up in
  // the OpenPicture and SavePicture dialog boxes
  TPicture.RegisterFileFormat('JP2', 'JPeg2000 Image', TJ2KGraphic);


finalization

  TPicture.UnregisterGraphicClass(TJ2KGraphic);
  UnloadJP2Library;

end.

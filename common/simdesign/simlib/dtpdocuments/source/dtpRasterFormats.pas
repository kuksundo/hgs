{
  Unit dtpRasterFormats

  TdtpImageLoader is a wrapper object to load raster images. Future raster
  formats can be added by descending form TRasterFormat. Examples in this unit
  include JPG, GIF and PNG.

  Project: DTP-Engine

  Creation Date: 23-08-2003 (NH)
  Version: See "changes.txt"

  Modifications:
  19-02-2004: Changed to exception model instead of result codes

  Copyright (c) 2002-2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpRasterFormats;

{$i simdesign.inc}

interface

uses
  Windows, SysUtils, Contnrs, Classes, dtpDefaults, dtpGraphics, Graphics;

type

  ERasterError = class(Exception);

  // Defines capabilities of the raster format reader/writer implementation
  TdtpRasterOption =
  ( ofLoadStream, // The format can be loaded from a stream
    ofLoadFile,   // The format can be loaded from a file
    ofSaveStream, // The format can be saved to a stream
    ofSaveFile,   // the format can be saved to a file
    ofHasThumb,   // The format may contain a separate thumbnail
    ofMultiPage,  // The format can contain multiple pages
    ofHasAlpha,   // The format has Alpha channel info (e.g. GIF, PNG)
    ofToMetafile, // The format can be rendered to a metafile
    ofFlexSize,   // The format can be sized flexibly
    ofLossy,      // The format uses lossy compression
    ofExif,       // The format may contain EXIF metadata
    ofIptc,       // The format may contain IPTC metadata
    ofComment,    // The format may contain a comment
    ofNoListing   // Do not list the format in Open/Save dialogs
  );
  // Set of TdtpRasterOption
  TdtpRasterOptions = set of TdtpRasterOption;

  // TdtpRaster is the base class for raster image reader/writer implementations.
  TdtpRaster = class
  private
    FOptions: TdtpRasterOptions;
    // Some image properties
    FWidth: integer;  // Image width
    FHeight: integer; // Image height
    FPageCount: integer;
    FStreamSize: integer;
  protected
    procedure  GraphicProgress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
  public
    constructor Create; virtual;
    class function CanLoad(S: TStream): boolean; virtual;
    procedure LoadImageFromFile(const AFileName: string; ADIB: TdtpBitmap;
      AMaxSize: TPoint; Page: integer); virtual;
    procedure LoadImageFromStream(S: TStream; ADIB: TdtpBitmap;
      AMaxSize: TPoint; Page: integer); virtual;
    procedure SaveImageToStream(S: TStream; ADIB: TdtpBitmap); virtual;
    procedure SaveImageToFile(const AFileName: string; ADIB: TdtpBitmap); virtual;
    property Height: integer read FHeight write FHeight;
    property Options: TdtpRasterOptions read FOptions write FOptions;
    // Streamsize is set after an image is loaded or saved to stream or file and
    // represents the original (compressed) file size.
    property StreamSize: integer read FStreamSize write FStreamSize;
    property Width: integer read FWidth write FWidth;
    property PageCount: integer read FPageCount write FPageCount;
  end;

  // Generic class of TdtpRaster descendants, used to register them
  TdtpRasterClass = class of TdtpRaster;

  // TdtpImageFiler is able to load and save raster images, for which it will use
  // one of the registered TdtpRaster reader/writer descendants. It can load and save
  // images from / to streams and files, can load images at lower resolutions, and can
  // load multipage images.
  TdtpImageFiler = class
  private
    FExtension: string;
    FFileName: string;
    FMaxSize: TPoint;
    FMeta: TMetafile;
    FPage: integer;
    FPageCount: integer;
    FRaster: TdtpRaster;
    FStream: TStream;
    FFileSize: integer;
    procedure SetExtension(const Value: string);
    procedure SetFileName(const Value: string);
  protected
    procedure DetermineFormat;
    function DetermineSaveFormatFromExtension(Extension: string): TdtpRasterClass;
    function UseStreamForLoading: boolean;
    function UseStreamForSaving: boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure LoadDib(ADib: TdtpBitmap);
    procedure SaveDib(ADib: TdtpBitmap);
    property Extension: string read FExtension write SetExtension;
    property FileName: string read FFileName write SetFileName;
    // Only valid after saving or loading
    property FileSize: integer read FFileSize;
    property MaxSize: TPoint read FMaxSize write FMaxSize;
    property Meta: TMetafile read FMeta write FMeta;
    property Page: integer read FPage write FPage;
    property PageCount: integer read FPageCount;
    property Raster: TdtpRaster read FRaster write FRaster;
    property Stream: TStream read FStream write FStream;
  end;

  // Reader and writer for the Windows BMP raster format
  TdtpBmpFormat = class(TdtpRaster)
  public
    procedure LoadImageFromStream(S: TStream; ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer); override;
    procedure SaveImageToStream(S: TStream; ADIB: TdtpBitmap); override;
  end;

const

  cDefaultMaxSize: TPoint = (X: 4000; Y: 4000);

resourcestring

  sreInputBitmapNotAssigned = 'Input bitmap not assigned';
  sreNotImplemented         = 'Method not implemented';
  sreIllegalPageNumber      = 'Requested non-existing page';
  sreStreamUnassigned       = 'Stream to read/write is unassigned';
  sreUnknownRasterFormat    = 'Unknown raster format';
  sreUnableToCompress       = 'Unable to compress';
  sreUnableToDecompress     = 'Unable to decompress';
  sreNoSuitableCodec        = 'No suitable codec found';
  sreUnsupportedBitdepth    = 'Unsupported bitdepth';
  sreFileCorrupt            = 'Image file is corrupted';
  sreLibraryNotLoaded       = 'Library for image format not loaded';
  sreUnkownRasterFormat     = 'Unknown raster format "%s"';
  sreCannotSaveFormat       = 'Cannot save format "%s"';
  sreBitmapEmpty            = 'Bitmap is empty';
  sreLoadStreamNotImpl      = 'Loading from stream is not implemented';

// Load an image from the file AFileName, and put result in ADIB
procedure LoadImageFromFile(const AFileName: string; ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer);

// Load an image from the file AFileName, and put result in ADIB
procedure LoadImageFromStream(S: TStream; const AExt: string; ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer);

// Save an image from ADIB to the file AFileName
procedure SaveImageToFile(const AFileName: string; ADIB: TdtpBitmap);

// Create a filter for a file open/save dialog
function RasterFormatOpenFilter: string;
function RasterFormatSaveFilter: string;

procedure RegisterRasterClass(AClass: TdtpRasterClass; const AFormatName, Extensions: string; RasterOptions: TdtpRasterOptions);

// Determine the fileformat from the extension of the filename. This is not always
// 100% correct since sometimes files are named incorrectly.
function RasterClassFromExt(const AFileName: string): TdtpRasterClass;

function GetRasterClassOptions(AClass: TdtpRasterClass): TdtpRasterOptions;

implementation

type
  TRasterClassHolder = class
  public
    FClass: TdtpRasterClass;
    FFormatName: string;
    FClassName: string;
    FExtensions: string;
    FOptions: TdtpRasterOptions;
  end;

var
  FRasterClassList: TObjectList = nil;

procedure RegisterRasterClass(AClass: TdtpRasterClass; const AFormatName,
  Extensions: string; RasterOptions: TdtpRasterOptions);
// Register currently unknown raster classes
var
  i: integer;
  AHolder: TRasterClassHolder;
  // local
  procedure SetClassMembers(Holder: TRasterClassHolder);
  begin
    with Holder do begin
      FClass      := AClass;
      FClassName  := AClass.ClassName;
      FFormatName := AFormatName;
      FExtensions := lowercase(Extensions);
      FOptions    := RasterOptions;
    end;
  end;
// main
begin
  if not assigned(FRasterClassList) then
    FRasterClassList := TObjectList.Create;
  // Unique?
  with FRasterClassList do
  begin
    for i := 0 to Count - 1 do
      if AClass = TRasterClassHolder(Items[i]).FClass then
      begin
        // Replace members
        SetClassMembers(TRasterClassHolder(Items[i]));
        exit;
      end;
    // Add new class
    AHolder := TRasterClassHolder.Create;
    SetClassMembers(AHolder);
    Add(AHolder);
  end;
end;

procedure LoadImageFromFile(const AFileName: string; ADib: TdtpBitmap; AMaxSize: TPoint; Page: integer);
// Load an image from the file AFileName, and put result in ADIB
var
  ALoader: TdtpImageFiler;
begin
  ALoader := TdtpImageFiler.Create;
  try
    if (AMaxSize.X * AMaxSize.Y) > 0 then
      ALoader.MaxSize := AMaxSize;
    ALoader.FileName := AFileName;
    ALoader.Page     := Page;
    ALoader.LoadDib(ADib);
  finally
    ALoader.Free;
  end;
end;

procedure LoadImageFromStream(S: TStream; const AExt: string; ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer);
// Load an image from the stream S, and put result in ADIB
var
  ALoader: TdtpImageFiler;
begin
  ALoader := TdtpImageFiler.Create;
  try
    if (AMaxSize.X * AMaxSize.Y) > 0 then
      ALoader.MaxSize := AMaxSize;
    ALoader.Extension := AExt;
    ALoader.Stream    := S;
    ALoader.Page      := Page;
    ALoader.LoadDib(ADIB);
  finally
    ALoader.Free;
  end;
end;

procedure SaveImageToFile(const AFileName: string; ADIB: TdtpBitmap);
// Save an image from ADIB to the file AFileName
var
  // We can use the loader also to save
  ASaver: TdtpImageFiler;
begin
  ASaver := TdtpImageFiler.Create;
  try
    ASaver.FileName := AFileName;
    ASaver.SaveDib(ADIB);
  finally
    ASaver.Free;
  end;
end;

function GetExtensionsString(Extensions: string): string;
var
  APos: integer;
begin
  Result := '';
  repeat
    APos := Pos(';', Extensions);
    if APos > 0 then
    begin
      if Length(Result) > 0 then Result := Result + ';';
      Result := Result + '*' + copy(Extensions, 1, APos - 1);
      Extensions := copy(Extensions, Apos + 1, length(Extensions));
    end else
      break;
  until False;
end;

function RasterFormatOpenFilter: string;
var
  i: integer;
  All, Ext: string;
begin
  Result := '';
  All    := '';
  if assigned(FRasterClassList) then
  with FRasterClassList do
    for i := 0 to Count - 1 do
      with TRasterClassHolder(Items[i]) do
        if ofLoadFile in FOptions then
        begin
          Ext := GetExtensionsString(FExtensions);
          if Length(Result) > 0 then Result := Result + '|';
          Result := Result + Format('%s (%s)|%s', [FFormatName, Ext, Ext]);
          if Length(All) > 0 then All := All + ';';
          All := All + Ext;
        end;
  Result := Format('Graphic formats|%s|%s|All Formats (*.*)|*.*', [All, Result]);
end;

function RasterFormatSaveFilter: string;
var
  i: integer;
  Ext: string;
begin
  Result := '';
  if assigned(FRasterClassList) then
  with FRasterClassList do
    for i := 0 to Count - 1 do
      with TRasterClassHolder(Items[i]) do
        if ofSaveFile in FOptions then
        begin
          Ext := GetExtensionsString(FExtensions);
          if Length(Result) > 0 then Result := Result + '|';
          Result := Result + Format('%s (%s)|%s', [FFormatName, Ext, Ext]);
        end;
end;

function RasterClassFromExt(const AFileName: string): TdtpRasterClass;
// Determine the fileformat from the extension of the filename. This is not always
// 100% correct since sometimes files are named incorrectly.
var
  i: integer;
  Ext: string;
  Holder: TRasterClassHolder;
begin
  Result := nil;
  // Determine format from extension
  if Length(AFilename) > 0 then
    Ext := LowerCase(ExtractFileExt(AFileName));
  if length(Ext) > 0 then
  begin
    Ext := Ext + ';';
    if assigned(FRasterClassList) then
      for i := 0 to FRasterClassList.Count - 1 do
      begin
        Holder := TRasterClassHolder(FRasterClassList.Items[i]);
        //with TRasterClassHolder(FRasterClassList.Items[i]) do
          if Pos(Ext, Holder.FExtensions) > 0 then
          begin
            Result := Holder.FClass;
            break;
          end;
      end;
  end;
end;

function GetRasterClassOptions(AClass: TdtpRasterClass): TdtpRasterOptions;
var
  i: integer;
begin
  Result := [];
  if assigned(FRasterClassList) then
  with FRasterClassList do
    for i := 0 to Count - 1 do
      with TRasterClassHolder(Items[i]) do
        if FClass = AClass then
        begin
          Result := FOptions;
          break;
        end;
end;

{ TdtpImageLoader }

constructor TdtpImageFiler.Create;
begin
  inherited Create;
  // Defaults
  FMaxSize := cDefaultMaxSize;
end;

destructor TdtpImageFiler.Destroy;
begin
  FreeAndNil(FRaster);
  inherited;
end;

procedure TdtpImageFiler.DetermineFormat;
var
  Ext: string;
  i: integer;
  AClass: TdtpRasterClass;
  AStream: TStream;
begin
  // We already have a raster format selected, so use that
  if assigned(Raster) then
    exit;
  AClass := nil;
  AStream := nil;

  // Determine format from extension
  if Length(Filename) > 0 then
    Extension := ExtractFileExt(FileName);
  if length(Extension) > 0 then
  begin
    Ext := LowerCase(Extension) + ';';
    if assigned(FRasterClassList) then
    with FRasterClassList do
      for i := 0 to Count - 1 do
        with TRasterClassHolder(Items[i]) do
          if Pos(Ext, FExtensions) > 0 then
          begin
            AClass := FClass;
            break;
          end;
    if assigned(AClass) then
    begin
      // Test the format found - does it implement CanLoad?
      FRaster := AClass.Create;
      if AClass.CanLoad(nil) then
        // Obviously not.. so just select it on good hopes
        exit;
      // Peek into the stream
      if UseStreamForLoading then
      begin
        AStream := FStream;
      end else
      begin
        if Length(FileName) > 0 then
          AStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
      end;
      try
        // Reset our stream
        AStream.Position := 0;
        // Check if we can load
        if AClass.CanLoad(AStream) then
          // Yes we can!
          exit
        else
          // No we can't.. we have to test all formats
          FreeAndNil(FRaster);
      finally
        if AStream <> FStream then
          FreeAndNil(AStream);
      end;
    end;
  end;

  // Determine format from stream directly
  if UseStreamForLoading then
  begin
    AStream := FStream;
  end else
  begin
    if Length(FileName) > 0 then
      AStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone)
    else
      exit;
  end;
  try
    if assigned(FRasterClassList) then
    with FRasterClassList do
      for i := 0 to Count - 1 do
        with TRasterClassHolder(Items[i]) do
          if FClass.CanLoad(AStream) then
          begin
            // Yes we can!
            Raster := AClass.Create;
            exit;
          end;
  finally
    if AStream <> FStream then
      FreeAndNil(AStream);
  end;
end;

function TdtpImageFiler.DetermineSaveFormatFromExtension(Extension: string): TdtpRasterClass;
var
  i: integer;
begin
  Result := nil;
  if length(Extension) > 0 then
  begin
    // FExtensions is always lowercase, so we must also make Extension lower-case
    Extension := lowercase(Extension + ';');
    if assigned(FRasterClassList) then
    with FRasterClassList do
      for i := 0 to Count - 1 do
        with TRasterClassHolder(Items[i]) do
          if Pos(Extension, FExtensions) > 0 then
            if ofSaveFile in FOptions then
            begin
              Result := FClass;
              break;
            end;
  end;
end;

procedure TdtpImageFiler.LoadDib(ADib: TdtpBitmap);
var
  AStart: integer;
  S: TStream;
begin
  if not assigned(ADib) then
    raise ERasterError.Create(sreInputBitmapNotAssigned);

  // Determine what raster format we have
  if not assigned(Raster) then
    DetermineFormat;
  if assigned(Raster) then
  begin
    if assigned(Stream) then
    begin
      AStart := Stream.Position;
      Raster.LoadImageFromStream(Stream, ADib, FMaxSize, FPage);
      FFileSize := Stream.Position - AStart;
    end else
    begin
      // Although we can perhaps use both, we will always use stream loading
      // if available
      if (ofLoadStream in Raster.Options) then
      begin
        S := TFileStream.Create(Filename, fmOpenRead or fmShareDenyNone);
        try
          Raster.LoadImageFromStream(S, ADib, FMaxSize, FPage);
          FFileSize := S.Size;
        finally
          S.Free;
        end;
      end else
      begin
        Raster.LoadImageFromFile(FileName, ADib, FMaxSize, FPage);
        FFileSize := Raster.StreamSize;
      end;
    end;
    FPageCount := Raster.PageCount;
  end else
    raise ERasterError.CreateFmt(sreUnkownRasterFormat, [Extension]);
end;

procedure TdtpImageFiler.SaveDib(ADib: TdtpBitmap);
var
  AClass: TdtpRasterClass;
  AStart: integer;
  F: file of byte;
  AExt: string;
begin
  if not assigned(ADib) then
    raise ERasterError.Create(sreInputBitmapNotAssigned);

  // Determine what raster format we have
  if not assigned(Raster) then
  begin
    AExt := ExtractFileExt(FileName);
    if length(AExt) = 0 then
      AExt := Extension;
    AClass := DetermineSaveFormatFromExtension(AExt);
    if assigned(AClass) then
      Raster := AClass.Create;
  end;
  if assigned(Raster) then
  begin
    if UseStreamForSaving then
    begin
      AStart := Stream.Position;
      Raster.SaveImageToStream(Stream, ADib);
      FFileSize := Stream.Size - AStart;
    end else
    begin
      Raster.SaveImageToFile(FileName, ADib);
      AssignFile(F, FileName);
      Reset(F);
      FFileSize := System.FileSize(F);
      CloseFile(F);
    end;
  end else
    raise ERasterError.CreateFmt(sreCannotSaveFormat, [AExt]);
end;

procedure TdtpImageFiler.SetExtension(const Value: string);
begin
  if FExtension <> Value then
  begin
    FExtension := Value;
    FreeAndNil(FRaster);
  end;
end;

procedure TdtpImageFiler.SetFileName(const Value: string);
begin
  if FFileName <> Value then
  begin
    FFileName := Value;
    FreeAndNil(FRaster);
  end;
end;

function TdtpImageFiler.UseStreamForLoading: boolean;
// Using streams is preferred but not always possible
begin
  Result := False;
  if not assigned(Raster) then
    exit;
  if assigned(Stream) and (ofLoadStream in Raster.Options) then
    Result := True;
end;

function TdtpImageFiler.UseStreamForSaving: boolean;
// Using streams is preferred but not always possible
begin
  Result := False;
  if not assigned(Raster) then
    exit;
  if assigned(Stream) and (ofSaveStream in Raster.Options) then
    Result := True;
end;

{ TdtpRaster }

class function TdtpRaster.CanLoad(S: TStream): boolean;
begin
  // Default returns True
  Result := True;
end;

constructor TdtpRaster.Create;
begin
  inherited Create;
  // Defaults
  FPageCount := 1;
  // Get our options
  Options := GetRasterClassOptions(TdtpRasterClass(ClassType))
end;

procedure TdtpRaster.GraphicProgress(Sender: TObject;
  Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean;
  const R: TRect; const Msg: string);
// We will make this progress event a bit simpler and return it to the user
begin
// to do
end;

procedure TdtpRaster.LoadImageFromFile(const AFileName: string; ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer);
// The default will create a filestream and load from stream (if options allow)
var
  S: TStream;
begin
  if ofLoadStream in Options then
  begin
    S := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
    try
      LoadImageFromStream(S, ADib, AMaxSize, Page);
      FStreamSize := S.Position;
    finally
      S.Free;
    end;
  end else
    raise ERasterError.Create(sreNotImplemented);
end;

procedure TdtpRaster.LoadImageFromStream(S: TStream; ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer);
begin
  // Being here means the descendant did not implement this method
  raise ERasterError.Create(sreLoadStreamNotImpl);
end;

procedure TdtpRaster.SaveImageToFile(const AFileName: string; ADIB: TdtpBitmap);
var
  S: TStream;
begin
  if ofSaveStream in Options then
  begin
    S := TFileStream.Create(AFileName, fmCreate);
    try
      SaveImageToStream(S, ADib);
      FStreamSize := S.Position;
    finally
      S.Free;
    end;
  end else
    raise ERasterError.Create(sreNotImplemented);
end;

procedure TdtpRaster.SaveImageToStream(S: TStream; ADIB: TdtpBitmap);
begin
  // Being here means the descendant did not implement this method
  raise ERasterError.Create(sreNotImplemented);
end;

{ TdtpBmpFormat }

procedure TdtpBmpFormat.LoadImageFromStream(S: TStream; ADIB: TdtpBitmap; AMaxSize: TPoint; Page: integer);
var
  i: integer;
  AlphaColor: TdtpColor;
begin
  if Page > 0 then
    raise ERasterError.Create(sreIllegalPageNumber);

  ADIB.LoadFromStream(S);
  with ADIB do
  begin
    FWidth := ADIB.Width;
    FHeight := ADIB.Height;
    // If the transparency option is set, we will use the left/bottom pixel
    // to determine the transparent color, and then set all instances of this
    // color in the DIB to fully transparent
    if (ofHasAlpha in Options) and (Width * Height > 0) then
    begin
      AlphaColor := Pixels[0, ADIB.Height - 1];
      for i := 0 to Width * Height - 1 do
        // This is the transparent color, so set to fully transparent
        if Bits[i] = AlphaColor then Bits[i] := $00000000;
    end;
  end;
end;

procedure TdtpBmpFormat.SaveImageToStream(S: TStream; ADIB: TdtpBitmap);
// Save the image in ADIB to the stream
begin
  // We can use built-in method of Graphics32
  ADIB.SaveToStream(S);
end;


initialization

  // Register basic classes

  // BMP images, the default is that they are not transparent, but this can be changed:
  // Registering with "ofHasAlpha" will use the left/bottom pixel of a bitmap
  // as the transparent color to set transparency.
  // It is possible to call this register method more than once, in order to switch
  // from non-transparent to transparent.
  RegisterRasterClass(TdtpBmpFormat, 'Windows Bitmap', '.bmp;.dib;',
    [ofLoadStream, ofLoadFile, ofSaveStream, ofSaveFile{, ofHasAlpha}]);

finalization

  FreeAndNil(FRasterClassList);

end.

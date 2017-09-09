{ unit sdJpegImage

  The platform-independent TsdJpegImage class
  
  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.

  Author: Nils Haeck M.Sc.
  Copyright (c) 2007 - 2011 SimDesign B.V.
  More information: www.simdesign.nl or n.haeck@simdesign.nl
}
unit sdJpegImage;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, NativeXml, sdDebug, Math,

  // nativejpg units
  sdJpegCoder, sdJpegMarkers, sdJpegBitstream, sdJpegTypes, sdJpegHuffman, sdJpegLossless,

  // general units
  sdMapIterator, sdColorTransforms, sdStreams;

const

  // Version number changes with updates. See "versions.txt" for a list of
  // updated features.
  cNativeJpgVersion = '1.33';


type

  TsdJpegSaveOptions = class;

  TsdJpegLoadOption = (
    loOnlyMetadata, // If set, only meta-data is read (exits when SOS is encountered)
    loTileMode      // If set, the loadfromstream only finds the start of each MCU tile
  );
  TsdJpegLoadOptions = set of TsdJpegLoadOption;

  // Ask the application to create a map (usually a TBitmap in Win) based on AIterator:
  // width, height and cellstride (bytecount per pixel). AIterator must also be
  // updated by the application: AIterator.Map and AIterator.ScanStride (bytecount per scanline).
  TsdCreateMapEvent = function(var AIterator: TsdMapIterator): TObject of object;

  // provide the jpeg strip by strip
  TsdJpegProvideStripEvent = procedure (Sender: TObject; ALeft, ATop: integer; ABitmapIter: TsdMapIterator) of object;

  // TsdJpegImage is a non-VCL component that can be used to load and save
  // Jpeg files. It is best to create just one instance of TsdJpegImage, and
  // use it over and over again to load Jpeg files, because this way memory
  // for the coefficients and bitmaps will be reused, instead of repeatedly
  // allocated/deallocated (which would happen if you each time create a new
  // TsdJpegImage instance).
  // Use the LoadFromFile or LoadFromStream method to load a Jpeg image, and use
  // the SaveToFile and SaveToStream method to save a Jpeg image. Use the Bitmap
  // property to assign the bitmap to another bitmap, or to work with the actual
  // image. The StoredColors and BitmapColors properties provide information and
  // control over which colour spaces and conversions are used. The Lossless property
  // gives access to a TsdLosslessOperation class with which you can perform
  // lossless operations on the Jpeg. The SaveOptions property gives access to
  // options used when saving the Jpeg.
  TsdJpegImage = class(TsdDebugComponent)
  private
    // FOnDebugOut: TsdDebugEvent; this is already defined in TDebugComponent
    FDataSize: int64;
    FOnUpdate: TsdUpdateEvent;
    FCoder: TsdJpegCoder;
    FMarkers: TsdJpegMarkerList;

    // Jpeg coding info
    FJpegInfo: TsdJpegInfo;

    // coder stream
    FCoderStream: TsdFastMemStream;
    FLoadOptions: TsdJpegLoadOptions;
    FLoadScale: TsdJpegScale;
    FMapIterator: TsdMapIterator;
    FMapWidth: integer;
    FMapHeight: integer;
    FPixelFormat: TsdPixelFormat;
    FICCProfile: TsdJpegICCProfile;
    FStoredCS: TsdJpegColorSpace;
    FBitmapCS: TsdJpegColorSpace;
    FDCTCodingMethod: TsdJpegDCTCodingMethod;
    FLossless: TsdLosslessOperation;
    FSaveOptions: TsdJpegSaveOptions;
    FOnCreateMap: TsdCreateMapEvent;
    FOnProvideStrip: TsdJpegProvideStripEvent;
    FOnExternalCMS: TsdJpegExternalCMSEvent;
    function GetExifInfo: TsdEXIFMarker;
    function GetIptcInfo: TsdIPTCMarker;
    function GetJfifInfo: TsdJFIFMarker;
    function GetAdobeAPP14Info: TsdAdobeApp14Marker;
    function GetICCProfile: TsdJpegICCProfile;
    procedure SetICCProfile(const Value: TsdJpegICCProfile);
    function GetLossless: TsdLosslessOperation;
    function GetComment: AnsiString;
    procedure SetComment(const Value: AnsiString);
    function GetHeight: integer;
    function GetImageHeight: integer;
    function GetImageWidth: integer;
    function GetWidth: integer;
    procedure GetBitmapTileSize(AScale: TsdJpegScale; var AWidth, AHeight: integer);
    procedure BeforeLosslessUpdate(Sender: TObject);
    procedure AfterLosslessUpdate(Sender: TObject);
    procedure AVI1MarkerCheck;
  protected
    procedure EntropyDecodeSkip(S: TStream);
    procedure InitializeDecode;
    // Load the next marker; returns the markertag read (or mkNone if not found)
    function LoadMarker(S: TStream): byte;
    // Get the required color transform from bitmap to samples, based on detected
    // color space in file and bitmap
    procedure GetColorTransformFromBitmap(var AClass: TsdColorTransformClass);
    // Get the required color transform from samples to bitmap, based on detected
    // color space in file and bitmap
    procedure GetColorTransformToBitmap(var AClass: TsdColorTransformClass;
      var AFormat: TsdPixelFormat);
    function HasSamples: boolean;
    function HasCoefficients: boolean;
    function VerifyBitmapColorSpaceForSave: TsdJpegColorSpace;
    procedure AddMinimalMarkersForColorSpaceDetection(AColors: TsdJpegColorSpace);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Clear the jpeg format: all data (coder and markers) and the bitmap
    procedure Clear;
    // Save info in the bitmap iterator to the Jpeg stream, aka compress the image.
    procedure Compress(AIterator: TsdMapIterator);
    // Get the size of the bitmap that must be created to hold the decoded
    // information
    procedure GetBitmapSize(AScale: TsdJpegScale; var AWidth, AHeight: integer);

    // After the image is loaded from stream, LoadJpeg actually decodes the
    // image. If DoCreateBitmap is true, it creates and renders the bitmap, thru
    // OnCreateMap
    procedure LoadJpeg(AScale: TsdJpegScale; DoCreateBitmap: boolean);

    // Load a Jpeg image from the file AFileName.
    procedure LoadFromFile(const AFileName: string);

    // Load a Jpeg image from the stream S. It is best to use a TMemoryStream
    // because the bitreader (which causes most reads to the stream) has
    // a specially optimized version to read from TMemoryStream streams. The
    // stream S will be read from from S.Position, and if everything goes well,
    // the stream will be positioned directly after the last (EOI) marker. An
    // exception will be raised if the stream is corrupt or truncated.
    procedure LoadFromStream(S: TStream);

    // In case of LoadOption [loTileMode] is included, after the LoadFromStream,
    // individual tile blocks can be loaded which will be put in the resulting
    // bitmap. The tile loaded will contain all the MCU blocks that fall within
    // the specified bounds ALeft/ATop/ARight/ABottom. Note that these are var
    // parameters, after calling this procedure they will be updated to the MCU
    // block borders. ALeft/ATop can subsequently be used to draw the resulting
    // TsdJpegFormat.Bitmap to a canvas.
    procedure LoadTileBlock(var ALeft, ATop, ARight, ABottom: integer);
    // Reload
    procedure Reload;
    // After SaveJpeg, the original CoderStream is replaced by the new encoded stream
    // by the coder.
    procedure SaveJpeg;
    // Save the Jpeg image to file AFileName
    procedure SaveToFile(const AFileName: string);
    // Save the Jpeg image to stream S. Set SaveOptions before saving. Use
    // SaveBitmap first in order to encode the new bitmap to be saved.
    procedure SaveToStream(S: TStream);
    // Encode a Jpeg image strip by strip. OnCreateMap with the partial
    // bitmap needs to be provided to fill one strip of the
    // jpeg file at a time (a strip consists of a row of MCU blocks, usually
    // 8 or 16 pixels high).
    // Only one pass over the data is required, but the resulting jpeg will
    // be saved with standard Huffman tables (as provided in the Jpeg specification)
    procedure SaveBitmapStripByStrip(AWidth, AHeight: integer);
    // call UpdateBitmap after calling LoadJpeg(Scale, False)
    function UpdateBitmap: TObject;
    // All metadata markers will be extracted from the file, and put in AList.
    // AList must be initialized (AList := TsdJpegMarkerList.Create)
    procedure ExtractMetadata(AList: TsdJpegMarkerList);
    // Inject the metadata in AList into the marker list of the file. All existing
    // metadata will be removed first; then the markers in AList will be added
    // below the SOI marker.
    procedure InjectMetadata(AList: TsdJpegMarkerList);
    // does the jpeg format have a bitmap already?
    function HasBitmap: boolean;
    // Returns true if the Jpeg has a valid ICC profile. Use property ICCProfile
    // to actually get it.
    function HasICCProfile: boolean;
    // Call this function to detect what colorspace is used in the file. This
    // can only be detected *after* the file is loaded. Set LoadOptions to
    // [loOnlyMetadata] to quickly do a test load to use this function.
    function DetectInternalColorSpace: TsdJpegColorSpace;
    // Reference to low-level information of file. JpegInfo.Width/Height provides
    // the size of the coded image.
    property JpegInfo: TsdJpegInfo read FJpegInfo;
    // Reference to the Jpeg coder. TsdJpegCoder is a generic coder, and specific
    // implementations are present for baseline DCT and progressive DCT.
    property Coder: TsdJpegCoder read FCoder;
    // size in bytes of raw data
    property DataSize: int64 read FDataSize;
    // Reference to the list of low-level markers present in the file (valid after
    // loading).
    property Markers: TsdJpegMarkerList read FMarkers;
    // Perform lossless operations on the jpeg coefficients
    property Lossless: TsdLosslessOperation read GetLossless;
  published
    // Pointer to JFIF info marker (if any)
    property JfifInfo: TsdJFIFMarker read GetJfifInfo;
    // Pointer to EXIF info marker (if any)
    property ExifInfo: TsdEXIFMarker read GetExifInfo;
    // Pointer to IPTC info marker (if any)
    property IptcInfo: TsdIPTCMarker read GetIptcInfo;
    // Pointer to Adobe APP14 info marker (if any)
    property AdobeAPP14Info: TsdAdobeApp14Marker read GetAdobeAPP14Info;
    // Read ICCProfile to get a TsdJpegICCProfile object back, in case ICC profile
    // data is available in the markers. The object has a Data pointer and a
    // DataLength property, and it can be used with e.g. LittleCMS. The profile
    // is valid until you load a new file or free the jpeg component.
    property ICCProfile: TsdJpegICCProfile read GetICCProfile write SetICCProfile;
    // Read and write a Jpeg comment (implemented through the COM marker).
    property Comment: AnsiString read GetComment write SetComment;
    // Read Bitmap to get a pointer to a TBitmap object back, that has the currently
    // loaded image. The TBitmap object is no longer valid when the jpeg format class is freed.
    // Assign to Bitmap in order to save the bitmap to a jpeg file. Note: when
    // assigning a new bitmap, the metadata is destroyed. In order to preserve
    // metadata, use a construct like this:
    // <code>
    // List := TsdJpegMarkerList.Create;
    // Jpg.ExtractMetadata(List);
    // Jpg.Bitmap := MyBitmap;
    // Jpg.InjectMetadata(List);
    // Jpg.SaveToFile('test.jpg');
    // List.Free;
    // </code>
    property ImageWidth: integer read GetImageWidth;
    property ImageHeight: integer read GetImageHeight;
    property Width: integer read GetWidth;
    property Height: integer read GetHeight;
    // Include loOnlyMetadata if you want to only load metadata and not decode
    // the image. Include loTileMode to load the image first, without decoding
    // it directly, so that LoadTileBlock can be used to load tiles of the image.
    property LoadOptions: TsdJpegLoadOptions read FLoadOptions write FLoadOptions;
    // Set LoadScale to anything other than jsFull to load a downscaled image, which
    // will be faster than the full image. jsDiv2 will download an image that is
    // half the size in X and Y, jsDiv4 will be quarter size, jsDiv8 will be 1/8
    // size.
    property LoadScale: TsdJpegScale read FLoadScale write FLoadScale;
    // The colorspace present in the file. If jcAutoDetect (default), the software will
    // try to detect which colorspace the JPEG file contains. This info is present
    // in some markers, or in the frame definition. If set to another value,
    // the software will use this as given, and assume that the data in the file
    // is using the given colorspace.
    property StoredCS: TsdJpegColorSpace read FStoredCS write FStoredCS;
    // The colorspace that will be generated when outputting to a bitmap. If set to
    // jcAutoDetect, the stored color space present in the file will be used to
    // directly output the data without color conversion. Default value for
    // BitmapCS is jcRGB.
    property BitmapCS: TsdJpegColorSpace read FBitmapCS write FBitmapCS;
    // Method used for forward and inverse DCT transform. dmAccurate will use an
    // accurate integer method (slow), dmFast will use fast but less accurate
    // integer method. When reading a Jpeg, this only impacts the visual quality.
    // When writing Jpeg, the resulting file quality will be impacted by the
    // method chosen.
    property DCTCodingMethod: TsdJpegDctCodingMethod read FDCTCodingMethod write FDCTCodingMethod;
    // Options that influence how Jpeg images are compressed and saved.
    property SaveOptions: TsdJpegSaveOptions read FSaveOptions;
    // Connect to this event to get low-level textual debug information
    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
    // Connect to this event before calling SaveToStreamStripByStrip. The implementation
    // of this event should fill the passed ABitmap parameter with the part of the
    // image at ALeft/ATop position.
    property OnProvideStrip: TsdJpegProvideStripEvent read FOnProvideStrip write FOnProvideStrip;
    // Connect to this event to use an external color management system (e.g. apply an
    // ICC profile to an image, with an external library, like LittleCMS). If this event is
    // implemented, no internal color transforms are applied.
    property OnExternalCMS: TsdJpegExternalCMSEvent read FOnExternalCMS write FOnExternalCMS;
    // connect to this event to get updates from the jpeg format
    property OnUpdate: TsdUpdateEvent read FOnUpdate write FOnUpdate;
    // event that creates the bitmap for the jpeg image
    property OnCreateMap: TsdCreateMapEvent read FOnCreateMap write FOnCreateMap;
  end;

  TsdJpegSaveOptions = class(TsdDebugPersistent)
  private
    FOwner: TsdJpegImage;
    FQuality: TsdJpegQuality;
    FOptimizeHuffmanTables: boolean;
    FCodingMethod: TsdJpegEncodingMethod;
    FUseSubSampling: boolean;
  protected
    procedure AddMarkers(AStored: TsdJpegColorSpace; AWidth, AHeight: integer);
    procedure SetupDefaultHuffmanTables; virtual;
    procedure SetupQuantTables; virtual;
    procedure SetTableMultiplication(ATable: TsdQuantizationTable; MultiplyPercent: integer;
      const ADefaultTable: TsdIntArray64);
  public
    constructor Create(AOwner: TsdJpegImage);
    property Quality: TsdJpegQuality read FQuality write FQuality;
    property OptimizeHuffmanTables: boolean read FOptimizeHuffmanTables write FOptimizeHuffmanTables;
    property CodingMethod: TsdJpegEncodingMethod read FCodingMethod write FCodingMethod;
    property UseSubSampling: boolean read FUseSubSampling write FUseSubSampling;
  end;

implementation

{ TsdJpegImage }

procedure TsdJpegImage.AddMinimalMarkersForColorSpaceDetection(AColors: TsdJpegColorSpace);
var
  M: TsdJpegMarker;
begin
  Markers.Insert(0, TsdSOIMarker.Create(FJpegInfo, mkSOI));
  // JFIF marker if these color spaces
  if AColors in [jcGray, jcYCbCr] then
    Markers.Insert(1, TsdJFIFMarker.Create(FJpegInfo, mkAPP0))
  else
    // Adobe APP14 marker if these color spaces
    if AColors in [jcRGB, jcCMYK, jcYCCK] then
    begin
      M := TsdAdobeAPP14Marker.Create(FJpegInfo, mkAPP14);
      case AColors of
      jcRGB, jcCMYK: TsdAdobeAPP14Marker(M).Transform := 0;
      jcYCCK: TsdAdobeAPP14Marker(M).Transform := 2;
      end;
      Markers.Insert(1, M);
    end;
end;

procedure TsdJpegImage.AVI1MarkerCheck;
// check if this jpeg is part of ab AVI file
var
  i: integer;
  DHTExists: boolean;
  AVI1Exists: boolean;
  DHTMarker: TsdDHTMarker;
  MS: TsdFastMemStream;
begin
  // Added by Dec start
  DHTExists := False;
  AVI1Exists := False;
  for i := 0 to FMarkers.Count - 1 do
  begin
    DHTExists := DHTExists or (FMarkers[i] is TsdDHTMarker);
    AVI1Exists := AVI1Exists or (FMarkers[i] is TsdAVI1Marker);
  end;
  if not DHTExists and AVI1Exists then
  begin
    DHTMarker := TsdDHTMarker.Create(FJpegInfo, mkDHT);
    FMarkers.Insert(FMarkers.Count - 1, DHTMarker);
    MS := TsdFastMemStream.Create;
    try
      MS.WriteBuffer(cMjpgDHTSeg, SizeOf(cMjpgDHTSeg));
      MS.Position := 0;
      DHTMarker.LoadFromStream(MS, MS.Size);
    finally
      MS.Free;
    end;
  end;
  // Added by Dec end
end;

procedure TsdJpegImage.Clear;
begin
  // Clear any lists/objects we have
  FMarkers.Clear;
  FJpegInfo.Clear;
  FCoderStream.Clear;

  // Free any coder we used
  if assigned(FCoder) then
    FreeAndNil(FCoder);

  if assigned(FLossless) then
    FLossless.Clear;

  // We free the color profile
  FreeAndNil(FICCProfile);
end;

constructor TsdJpegImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Owned objects
  FMarkers := TsdJpegMarkerList.Create(Self);
  FJpegInfo := TsdJpegInfo.Create;
  FCoderStream := TsdFastMemStream.Create;
  FSaveOptions := TsdJpegSaveOptions.Create(Self);
  FMapIterator := TsdMapIterator.Create;

  // Defaults
  FStoredCS := jcAutoDetect;
  FBitmapCS := jcRGB;
  FDctCodingMethod := dmAccurate;
end;

destructor TsdJpegImage.Destroy;
begin
  FreeAndNil(FSaveOptions);
  FreeAndNil(FCoder);
  FreeAndNil(FMapIterator);
  FreeAndNil(FICCProfile);
  FreeAndNil(FJpegInfo);
  FreeAndNil(FCoderStream);
  FreeAndNil(FMarkers);
  FreeAndNil(FLossless);
  inherited;
end;

function TsdJpegImage.DetectInternalColorSpace: TsdJpegColorSpace;
var
  JFIF: TsdJFIFMarker;
  Adobe: TsdAdobeApp14Marker;
  IDStr: AnsiString;
  // local
  function GetComponentIDString: AnsiString;
  var
    i: integer;
  begin
    SetLength(Result, FJpegInfo.FFrameCount);
    for i := 0 to FJpegInfo.FFrameCount - 1 do
      Result[i + 1] := AnsiChar(FJpegInfo.FFrames[i].FComponentID);
  end;
begin
  // Defaults: Based on component count
  Result := jcAutoDetect;
  case FJpegInfo.FFrameCount of
  1: Result := jcGray;
  2: Result := jcGrayA;
  3: Result := jcYCbCr;
  4: Result := jcYCCK;
  end;

  // Check JFIF marker
  JFIF := GetJFIFInfo;
  if assigned(JFIF) and JFIF.IsValid then
    // We have a JFIF marker: if component count is 1 or 3, above assumptions are correct
    if FJpegInfo.FFrameCount in [1, 3] then
      exit;

  // Check Adobe APP14 marker
  Adobe := GetAdobeAPP14Info;
  if assigned(Adobe) and Adobe.IsValid then
  begin
    // We have an Adobe APP14 marker
    case Adobe.Transform of
    0:
      begin
        case FJpegInfo.FFrameCount of
        3: Result := jcRGB;
        4: Result := jcCMYK;
        end;
      end;
    1: Result := jcYCbCr;
    2: Result := jcYCCK;
    end;
    exit;
  end;

  // Check for ITU G3FAX format
  if FMarkers.ByClass(TsdG3FAXMarker) <> nil then
  begin
    Result := jcITUCieLAB;
    exit;
  end;

  // No subsampling used?
  if (FJpegInfo.FHorzSamplingMax = 1) and (FJpegInfo.FVertSamplingMax = 1) then
  begin
    // No subsampling used -> Change YC method to RGB or CMYK
    case FJpegInfo.FFrameCount of
    3: Result := jcRGB;
    4: Result := jcCMYK;
    end;
  end;

  // Use component ID's
  IDStr := GetComponentIDString;
  case FJpegInfo.FFrameCount of
  3:
    begin
      // Possible ID strings
      if IDStr = #1#2#3 then
        Result := jcYCbCr;
      if IDStr = 'RGB' then
        Result := jcRGB;
      if IDStr = 'YCc' then
        Result := jcPhotoYCC;
    end;
  4:
    begin
      // Possible ID strings
      if IDStr = #1#2#3#4 then
      begin
        if HasICCProfile then
          // Note: in fact, in cases seen, this represents CMYK instead of RGBA,
          // so to decode: decode to RGBA as usual, then pretend these channels
          // are CMYK, and convert to final colour space.
          // Seen in: scanners (always with ICC profile present - which has CMYK profile)
          Result := jcYCbCrK
        else
          Result := jcYCbCrA;
      end;
      if IDStr = 'RGBA' then
        Result := jcRGBA;
      if IDStr = 'YCcA' then
        Result := jcPhotoYCCA;
    end;
  end;
end;

procedure TsdJpegImage.Compress(AIterator: TsdMapIterator);
// compress the Jpeg image, using the bitmap in AIterator
var
  TransformClass: TsdColorTransformClass;
  Transform: TsdColorTransform;
  StoredCS: TsdJpegColorSpace;
begin
  // check iterator
  if not assigned(AIterator) or (AIterator.Width * AIterator.Height = 0) then
  begin
    DoDebugOut(Self, wsFail, sBitmapIsEmptyCannotSave);
    exit;
  end;

  {if not HasCoefficients then}
  begin

    // BitCount to sdpixelformat
    FPixelFormat := sdBitCountToPixelFormat(AIterator.BitCount);

    // coding info and important private data width/height
    FJpegInfo.FWidth := AIterator.Width;
    FJpegInfo.FHeight := AIterator.Height;

    FLoadScale := jsFull;
    FMapWidth := FJpegInfo.FWidth;
    FMapHeight := FJpegInfo.FHeight;

    // If no coder yet, we create the baseline coder
    if not assigned(FCoder) then
      FCoder := TsdJpegBaselineCoder.Create(Self, FJpegInfo);

    // compressing the bitmap can only be done in full scale (8x8)
    if FCoder.Scale <> jsFull then
    begin
      DoDebugOut(Self, wsFail, sOperationOnlyFor8x8);
      exit;
    end;

    // Verify incoming bitmap format versus bitmap colorspace
    StoredCS := VerifyBitmapColorSpaceForSave;

    // We create minimal default markers to warrant color space detection
    // later on
    AddMinimalMarkersForColorSpaceDetection(StoredCS);

    // Ask save options to add DQT, SOFn and SOS marker
    FSaveOptions.AddMarkers(StoredCS, FMapWidth, FMapHeight);

    // Color transform
    GetColorTransformFromBitmap(TransformClass);
    if not assigned(TransformClass) then
    begin
      DoDebugOut(Self, wsWarn, sInvalidFormatForSelectedCS);
      exit;
    end;

    Transform := TransformClass.Create;
    if assigned(AIterator) then
    begin
      try
        // Initialize coder (this sets map sizes etc)
        FCoder.Initialize(jsFull);
        // Get samples from bitmap data
        // AV here in laz
        FCoder.SamplesFromImage(AIterator, Transform);
        // Now convert samples to coefficients. This also does the quantization
        FCoder.ForwardDCT;
      finally
        Transform.Free;
      end;
    end;

    // We also must add an EOI marker
    FMarkers.Add(TsdEOIMarker.Create(FJpegInfo, mkEOI));

    // coder now has coefficients
    FCoder.HasCoefficients := True;
  end;
end;

procedure TsdJpegImage.EntropyDecodeSkip(S: TStream);
// In case we want to skip the entropy-encoded stream, but inspect markers
var
  B, ReadBytes, Tag: byte;
  First, Last, P: PByte;
begin
  if (S is TMemoryStream) or (S is TsdFastMemStream) then
  begin
    // Fast skip based on memorystream
    First := TMemoryStream(S).Memory;
    Last := First;
    inc(Last, S.Size);
    P := First;
    inc(P, S.Position);
    while cardinal(P) < cardinal(Last) do
    begin
      // Scan stream for $FF + <marker>
      if P^ = $FF then
      begin
        inc(P);
        if P^ <> 0 then
        begin
          dec(P, 1);
          S.Position := cardinal(P) - cardinal(First);
          exit;
        end;
      end;
      inc(P);
    end;
  end else
  begin
    // Slow skip for general streams
    repeat
      ReadBytes := S.Read(B, 1);
      if B = $FF then
      begin
        S.Read(Tag, 1);
        if Tag <> 0 then
        begin
          S.Seek(-2, soFromCurrent);
          exit;
        end;
      end;
    until ReadBytes = 0;
  end;
end;

procedure TsdJpegImage.ExtractMetadata(AList: TsdJpegMarkerList);
var
  Idx: integer;
begin
  Idx := 0;
  while Idx < FMarkers.Count do
  begin
    if FMarkers[Idx].MarkerTag in [mkAPP0..mkAPP15, mkCOM] then
      AList.Add(FMarkers.Extract(FMarkers[Idx]))
    else
      inc(Idx);
  end;
end;

function TsdJpegImage.GetAdobeAPP14Info: TsdAdobeApp14Marker;
begin
  Result := TsdAdobeAPP14Marker(FMarkers.ByTag(mkApp14));
end;

procedure TsdJpegImage.GetBitmapSize(AScale: TsdJpegScale; var AWidth, AHeight: integer);
var
  W, H, Divisor: integer;
begin
  W := FJpegInfo.FWidth;
  H := FJpegInfo.FHeight;
  Divisor := sdGetDivisor(AScale);
  AWidth  := (W + Divisor - 1) div Divisor;
  AHeight := (H + Divisor - 1) div Divisor;
end;

procedure TsdJpegImage.GetBitmapTileSize(AScale: TsdJpegScale; var AWidth, AHeight: integer);
var
  W, H, Divisor: integer;
begin
  W := FJpegInfo.FTileWidth;
  H := FJpegInfo.FTileHeight;
  Divisor := sdGetDivisor(AScale);
  AWidth  := (W + Divisor - 1) div Divisor;
  AHeight := (H + Divisor - 1) div Divisor;
end;

procedure TsdJpegImage.GetColorTransformFromBitmap(var AClass: TsdColorTransformClass);
var
  InternalCS, Input: TsdJpegColorSpace;
begin
  // At this point we can use DetectInternalColorSpace to find the color space of
  // the file, since all parameters and markes have been set. We can also trust
  // the FBitmapColorspace to match with the bitmap.

  DoDebugOut(Self, wsInfo, 'Color conversion bitmap->samples:');
  if FStoredCS = jcAutoDetect then
  begin
    InternalCS := DetectInternalColorSpace;
    DoDebugOut(Self, wsInfo, Format(' Internal colorsp: %s (detected)', [cColorSpaceNames[InternalCS]]));
  end else
  begin
    InternalCS := FStoredCS;
    DoDebugOut(Self, wsInfo, Format(' Internal colorsp: %s (selected)', [cColorSpaceNames[InternalCS]]));
  end;

  Input := FBitmapCS;
  if Input = jcAutoDetect then
  begin
    case FPixelFormat of
    spf8bit:  Input := jcGray;
    spf24bit: Input := jcRGB;
    spf32bit: Input := jcRGBA;
    end;
  end;

  // Defaults
  AClass := nil;
  case FJpegInfo.FFrameCount of
  1: if FPixelFormat = spf8bit  then AClass := TsdNullTransform8bit;
  2: if FPixelFormat = spf16bit then AClass := TsdNullTransform16bit;
  3: if FPixelFormat = spf24bit then AClass := TsdNullTransform24bit;
  4: if FPixelFormat = spf32bit then AClass := TsdNullTransform32bit;
  else
    DoDebugOut(Self, wsWarn, 'FCodingInfo.FrameCount = 0');
  end;

  // Specific transforms
  case InternalCS of
  jcGray:
    case Input of
    jcRGB: AClass := TsdTransformBGRToGray;
    jcRGBA: AClass := TsdTransformRGBAToGray;
    end;
  jcRGB:
    case Input of
    jcRGB: AClass := TsdTransformInvertTriplet24bit;
    end;
  jcYCbCr, jcPhotoYCC:
    case Input of
    jcRGB: AClass := TsdTransformBGRToYCbCr;
    jcRGBA: AClass := TsdTransformBGRAToYCbCr;
    end;
  jcYCbCrA:
    case Input of
    jcRGBA: AClass := TsdTransformBGRAToYCbCrA;
    end;
  jcCMYK:
    case Input of
    jcRGB: AClass := TsdTransformRGBToCMYK;
    end;
  jcYCCK, jcPhotoYCCA:
    case Input of
    jcRGB: AClass := TsdTransformRGBToYCCK;
    jcCMYK: AClass := TsdTransformCMYKToYCCK;
    end;
  end;
end;

procedure TsdJpegImage.GetColorTransformToBitmap(
  var AClass: TsdColorTransformClass; var AFormat: TsdPixelFormat);
var
  Warning: boolean;
  InternalCS, OutputCS: TsdJpegColorSpace;
  // helper
  procedure SetClassAndFormat(C: TsdColorTransformClass; F: TsdPixelFormat);
  begin
    AClass := C;
    AFormat := F;
  end;
begin
  // default class and pixelformat
  case FJpegInfo.FFrameCount of
  1: SetClassAndFormat(TsdNullTransform8bit, spf8bit);
  2: SetClassAndFormat(TsdNullTransform16bit, spf16bit);
  3: SetClassAndFormat(TsdNullTransform24bit, spf24bit);
  4: SetClassAndFormat(TsdNullTransform32bit, spf32bit);
  else
    DoDebugOut(Self, wsWarn, 'FCodingInfo.FrameCount = 0');
    SetClassAndFormat(nil, spf24bit);
  end;

  // Determine stored colorspace
  DoDebugOut(Self, wsInfo, 'Color conversion samples->bitmap:');
  if FStoredCS = jcAutoDetect then
  begin
    InternalCS := DetectInternalColorSpace;
    DoDebugOut(Self, wsInfo, Format(' Internal colorsp: %s (detected)', [cColorSpaceNames[InternalCS]]));
  end else
  begin
    InternalCS := FStoredCS;
    DoDebugOut(Self, wsInfo, Format(' Internal colorsp: %s (selected)', [cColorSpaceNames[InternalCS]]));
  end;

  // Determine bitmap colorspace
  if FBitmapCS = jcAutoDetect then
  begin
    OutputCS := InternalCS;
    DoDebugOut(Self, wsInfo, Format(' Bitmap colorsp: %s (no change)', [cColorSpaceNames[OutputCS]]));
  end else
  begin
    OutputCS := FBitmapCS;
    DoDebugOut(Self, wsInfo, Format(' Bitmap colorsp: %s (selected)', [cColorSpaceNames[OutputCS]]));
  end;

  // External color management
  if assigned(FOnExternalCMS) then
  begin
    // We leave the handling of ICC transform to the external application
    DoDebugOut(Self, wsInfo, ' Color management handled by external application');
    exit;
  end;

  // Determine what conversion and pixelformat to use
  Warning := False;
  case InternalCS of
  jcGray:
    case OutputCS of
    jcRGB: SetClassAndFormat(TsdTransformGrayToBGR, spf24bit);
    jcGray:;
    else
      Warning := True;
    end;
  jcGrayA:
    case OutputCS of
    jcRGB:  SetClassAndFormat(TsdTransformGrayAToBGR, spf24bit);
    jcRGBA: SetClassAndFormat(TsdTransformGrayAToBGRA, spf32bit);
    jcGrayA:;
    else
      Warning := True;
    end;
  jcRGB:
    case OutputCS of
    jcRGBA: SetClassAndFormat(TsdTransformRGBToBGRA, spf32bit);
    jcRGB: SetClassAndFormat(TsdTransformInvertTriplet24bit, spf24bit);
    else
      Warning := True;
    end;
  jcRGBA:
    case OutputCS of
    jcRGb: SetClassAndFormat(TsdTransformRGBAToBGR, spf24bit);
    jcRGBA:;
    else
      Warning := True;
    end;
  jcYCbCr, jcPhotoYCc:
    case OutputCS of
    jcGray: SetClassAndFormat(TsdTransformYCbCrToGray, spf8bit);
    jcRGB:  SetClassAndFormat(TsdTransformYCbCrToBGR, spf24bit);
    jcRGBA: SetClassAndFormat(TsdTransformYCbCrToBGRA, spf32bit);
    else
      Warning := True;
    end;
  jcYCbCrA, jcPhotoYCcA:
    case OutputCS of
    jcRGB:  SetClassAndFormat(TsdTransformYCbCrAToBGR, spf24bit);
    jcRGBA: SetClassAndFormat(TsdTransformYCbCrAToBGRA, spf32bit);
    else
      Warning := True;
    end;
  jcYCbCrK:
    case OutputCS of
    jcRGB: SetClassAndFormat(TsdTransformYCbCrKToBGR, spf24bit);
    else
      Warning := True;
    end;
  jcCMYK:
    case OutputCS of
    jcRGB: SetClassAndFormat(TsdTransformCMYKToBGR_Adobe, spf24bit);
    else
      Warning := True;
    end;
  jcYCCK:
    case OutputCS of
    jcRGB: SetClassAndFormat(TsdTransformYCCKToBGR, spf24bit);
    else
      Warning := True;
    end;
  jcITUCieLAB:
    case OutputCS of
    jcRGB: SetClassAndFormat(TsdTransformITUCIELabToBGR, spf24bit);
    else
      Warning := True;
    end;
  else
    Warning := True;
  end;

  if (OutputCS <> InternalCS) and Warning then
    DoDebugOut(Self, wsWarn, ' Warning: no color transform could be found (stored colors are output)');
end;

function TsdJpegImage.GetComment: AnsiString;
var
  M: TsdCOMMarker;
begin
  M := TsdCOMMarker(FMarkers.ByTag(mkCOM));
  if not assigned(M) then
    Result := ''
  else
    Result := M.Comment;
end;

function TsdJpegImage.GetExifInfo: TsdEXIFMarker;
begin
  Result := TsdEXIFMarker(FMarkers.ByTag(mkApp1));
end;

function TsdJpegImage.GetHeight: integer;
var
  D: integer;
begin
  D := sdGetDivisor(FLoadScale);
  Result := (GetImageHeight + D - 1) div D;
end;

function TsdJpegImage.GetICCProfile: TsdJpegICCProfile;
// return the ICC profile from the ICCProfile markers
var
  M: TsdICCProfileMarker;
begin
  if assigned(FICCProfile) then
  begin
    Result := FICCProfile;
    exit;
  end;

  // Do we have an ICC profile?
  Result := nil;
  M := TsdICCProfileMarker(FMarkers.ByClass(TsdICCProfileMarker));
  if not assigned(M) or not M.IsValid then
    exit;

  FICCProfile := TsdJpegICCProfile.Create;
  FICCProfile.ReadFromMarkerList(FMarkers);
  Result := FICCProfile;
end;

function TsdJpegImage.GetImageHeight: integer;
begin
  if assigned(FJpegInfo) then
    Result := FJpegInfo.FHeight
  else
    Result := 0;
end;

function TsdJpegImage.GetImageWidth: integer;
begin
  if assigned(FJpegInfo) then
    Result := FJpegInfo.FWidth
  else
    Result := 0;
end;

function TsdJpegImage.GetIptcInfo: TsdIPTCMarker;
begin
  Result := TsdIPTCMarker(FMarkers.ByTag(mkApp13));
end;

function TsdJpegImage.GetJfifInfo: TsdJFIFMarker;
begin
  Result := TsdJFIFMarker(FMarkers.ByTag(mkApp0));
end;

function TsdJpegImage.GetLossless: TsdLosslessOperation;
begin
  if not assigned(FLossless) then
  begin
    FLossless := TsdLosslessOperation.Create(Self);
    FLossless.OnBeforeLossless := BeforeLosslessUpdate;
    FLossless.OnAfterLossless := AfterLosslessUpdate;
  end;
  Result := FLossless;
end;

function TsdJpegImage.GetWidth: integer;
var
  D: integer;
begin
  D := sdGetDivisor(FLoadScale);
  Result := (GetImageWidth + D - 1) div D;
end;

function TsdJpegImage.HasBitmap: boolean;
begin
  Result := assigned(FMapIterator.Map);
end;

function TsdJpegImage.HasCoefficients: boolean;
begin
  Result := False;
  if assigned(FCoder) then
    Result := FCoder.HasCoefficients;
end;

function TsdJpegImage.HasICCProfile: boolean;
// Determine if we have a valid ICC profile
var
  M: TsdICCProfileMarker;
begin
  // ICC profile already read?
  if assigned(FICCProfile) then
  begin
    Result := True;
    exit;
  end;
  // Do we have an ICC profile?
  M := TsdICCProfileMarker(FMarkers.ByClass(TsdICCProfileMarker));
  Result := assigned(M) and M.IsValid;
end;

function TsdJpegImage.HasSamples: boolean;
begin
  Result := False;
  if assigned(FCoder) then
    Result := FCoder.HasSamples;
end;

procedure TsdJpegImage.InitializeDecode;
begin
  // Create correct codec
  case FJpegInfo.FEncodingMethod of
  emBaselineDCT:
    begin
      if not assigned(FCoder) or (FCoder.ClassType <> TsdJpegBaselineCoder) then
      begin
        FreeAndNil(FCoder);
        FCoder := TsdJpegBaselineCoder.Create(Self, FJpegInfo);
      end;
    end;
  emExtendedDCT:
    begin
      if not assigned(FCoder) or (FCoder.ClassType <> TsdJpegExtendedCoder) then
      begin
        FreeAndNil(FCoder);
        FCoder := TsdJpegExtendedCoder.Create(Self, FJpegInfo);
      end;
    end;
  emProgressiveDCT:
    begin
      if not assigned(FCoder) or (FCoder.ClassType <> TsdJpegProgressiveCoder) then
      begin
        FreeAndNil(FCoder);
        FCoder := TsdJpegProgressiveCoder.Create(Self, FJpegInfo);
      end;
    end;
  else
    FreeAndNil(FCoder);
    exit;
  end;
  FCoder.Clear;
  FCoder.Method := FDCTCodingMethod;
  FCoder.TileMode := loTileMode in FLoadOptions;
  FCoder.Initialize(FLoadScale);
end;

procedure TsdJpegImage.InjectMetadata(AList: TsdJpegMarkerList);
begin
  FMarkers.RemoveMarkers([mkAPP0..mkAPP15, mkCOM]);
  while AList.Count > 0 do
    FMarkers.Insert(1, AList.Extract(AList[AList.Count - 1]));
end;

procedure TsdJpegImage.LoadJpeg(AScale: TsdJpegScale; DoCreateBitmap: boolean);
var
  i: integer;
  Iteration: cardinal;
  MarkerTag, ExtraTag: byte;
begin
  FLoadScale := AScale;

  DoDebugOut(Self, wsInfo, Format('LoadJpeg with LoadScale=%d', [integer(FLoadScale)]));

  // iterate thru the markers to initialize, decode and finalize the coder
  for i := 0 to FMarkers.Count - 1 do
  begin
    MarkerTag := FMarkers[i].MarkerTag;
    case MarkerTag of
    mkSOF0..mkSOF2:
      begin
        // Method is defined.. we can initialise the coder
        InitializeDecode;
      end;
    mkSOS:
      if assigned(FCoder) then
      begin
        DoDebugOut(Self, wsinfo, Format('decode with FCoderStream size=%d',
         [FCoderStream.Size]));

        Iteration := 0;
        FCoder.Decode(FCoderStream, Iteration);

        // in progressive jpegs there can be additional SOS markers
        while FCoderStream.Position < FCoderStream.Size do
        begin
          // optional additional SOS tag?
          ExtraTag := LoadMarker(FCoderStream);
          case ExtraTag of
          mkSOS:
            begin
              inc(Iteration);
              FCoder.Decode(FCoderStream, Iteration);
            end;
          mkDHT:
            begin
              // not the right place but we will be lenient
              DoDebugOut(Self, wsWarn, 'incorrect place for DHT marker (must be *before* first SOS)');
            end;
          else
            DoDebugOut(Self, wsinfo, Format('FCoderStream pos=%d size=%d',
              [FCoderStream.Position, FCoderStream.Size]));
            // signal that we are done
            FCoderStream.Position := FCoderStream.Size;
          end;
        end;

      end;
    mkEOI:
      begin
        FCoder.Finalize;
      end;
    end;
  end;

  // if DoCreateBitmap, we update the bitmap
  if DoCreateBitmap then
    {Res := }UpdateBitmap;
end;

function TsdJpegImage.UpdateBitmap: TObject;
var
  Transform: TsdColorTransform;
  TransformClass: TsdColorTransformClass;
begin
  // If we do not have coefficients we have not loaded anything yet, so exit
  if not HasCoefficients then
    exit;

  // Do we need to update the bitmap?
  if not HasSamples then
  begin
    GetColorTransformToBitmap(TransformClass, FPixelFormat);
    if TransformClass = nil then
    begin
      DoDebugOut(Self, wsWarn, sNoColorTransformation);
      exit;
    end;
    Transform := TransformClass.Create;
    try
      // Inverse-DCT the coefficients, this also does the unquantization
      FCoder.InverseDCT;

      // Find the bitmap size based on decoded info and required scale
      GetBitmapSize(FLoadScale, FMapWidth, FMapHeight);

      // Set bitmap size and pixelformat, and get the iterator to pass as argument
      FMapIterator.Width := FMapWidth;
      FMapIterator.Height := FMapHeight;
      FMapIterator.CellStride := sdPixelFormatToByteCount(FPixelFormat);

      // this should also update the FMapIterator from the application
      if assigned(FOnCreateMap) then
      begin
        // Res is usually a TBitmap  or TBitmap32 (Windows/Linux, etc), but it is
        // up to the application
        Result := FOnCreateMap(FMapIterator);
      end;

      // Ask the coder to put the samples in the bitmap
      FCoder.SamplesToImage(FMapIterator, Transform);

    finally
      Transform.Free;
    end;
    FCoder.HasSamples := True;

    // Defer color management to the application, if OnExternalCMS is implemented
    if assigned(FOnExternalCMS) then
    begin
      FOnExternalCMS(Self, Result);
    end;

  end;
end;

procedure TsdJpegImage.LoadFromFile(const AFileName: string);
var
  F: TFileStream;
  M: TsdFastMemStream;
begin
  F := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  // We use a temp mem copy for speed
  M := TsdFastMemStream.Create;
  try
    M.Size := F.Size;
    M.CopyFrom(F, M.Size);
    M.Position := 0;
    LoadFromStream(M);
  finally
    F.Free;
    M.Free;
  end;
end;

procedure TsdJpegImage.LoadFromStream(S: TStream);
// LoadFromStream does not yet create or load a bitmap, it only
// loads all the properties of the markers and coder so
// that LoadJpeg() can load the bitmap
var
  MarkerTag: byte;
  EOI1, EOI2: pbyte;
  EOIMarker: TsdEOIMarker;
begin
  // first clear our data
  Clear;

  // Update dependent data via OnUpdate
  if assigned(FOnUpdate) then
    FOnUpdate(Self);

  // size in bytes of the data stream S
  FDataSize := S.Size;

  try
    // load another marker of the markers in the jpeg
    repeat

      MarkerTag := LoadMarker(S);

    until (MarkerTag = mkSOS) or (MarkerTag = mkNone);

    if MarkerTag = mkSOS then
    begin
      // before we start with the scan (SOS), we must check if the
      // AVI1 tag exists, while there is no DHT. If no DHT,
      // it will be created and added just before the SOS.
      AVI1MarkerCheck;

      // the coder stream starts right after the mkSOS marker data
      // and ends till the end of the file
      FCoderStream.Clear;
      FCoderStream.CopyFrom(S, S.Size - S.Position);
      FCoderStream.Position := 0;

      if FCoderStream.Size >= 2 then
      begin
        // detect EOI
        EOI1 := FCoderStream.Memory;
        inc(EOI1, FCoderStream.Size - 2);
        EOI2 := EOI1;
        inc(EOI2);

        if (EOI1^ = $FF) and (EOI2^ = mkEOI) then
        begin
          // the EOI marker is found, we add it to the marker list so
          // we also write the EOI when saving
          // we must remove the two bytes of the FCoderStream, since the
          // EOI is not part of the coder stream
          FCoderStream.Size := FCoderStream.Size - 2;
          DoDebugOut(Self, wsInfo, '<EOI marker>');
          EOIMarker := TsdEOIMarker.Create(FJpegInfo, mkEOI);
          FMarkers.Add(EOIMarker);
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      DoDebugOut(Self, wsFail, Format('Exception during decode: %s', [E.Message]));
      // Added by Dec
      if E.Message <> sInputStreamChopped then
        raise;
    end;
  end;
end;

procedure TsdJpegImage.LoadTileBlock(var ALeft, ATop, ARight, ABottom: integer);
// LoadTileBlock certainly may have bugs! But it seems that tiled loading works
// for the baseline coder.
var
  Divisor, McuW, McuH: integer;
  XStart, YStart, XCount, YCount: integer;
  McuLeft, McuTop, McuRight, McuBottom: integer;
  i: integer;
  MarkerTag: byte;
  Transform: TsdColorTransform;
  TransformClass: TsdColorTransformClass;
begin
  DoDebugOut(Self, wsInfo, Format('Load tile block [%d %d %d %d]',
    [ALeft, ATop, ARight, ABottom]));

  if not assigned(FCoder) then
  begin
    // iterate thru the markers to initialize, decode and finalize the coder
    for i := 0 to FMarkers.Count - 1 do
    begin
      MarkerTag := FMarkers[i].MarkerTag;
      case MarkerTag of
      mkSOF0..mkSOF2:
        begin
          // Method is defined.. we can initialise the coder
          InitializeDecode;
        end;
      mkSOS:
        if FCoder is TsdJpegBaselineCoder then
          TsdJpegBaselineCoder(FCoder).Decode(FCoderStream, 0);
      end;
    end;
  end;

  // baseline check
  if FCoder.ClassType <> TsdJpegBaselineCoder then
  begin
    DoDebugOut(Self, wsWarn, 'tiled loading only possible with baseline jpeg');
    exit;
  end;

  // Determine MCU block area
  Divisor := sdGetDivisor(FLoadScale);
  McuW := FJpegInfo.FMCUWidth div Divisor;
  McuH := FJpegInfo.FMCUHeight div Divisor;

  McuLeft := Max(0, ALeft div McuW);
  McuRight := Min(FJpegInfo.FHorzMCUCount, (ARight + McuW - 1) div McuW);
  McuTop := Max(0, ATop div McuH);
  McuBottom := Min(FJpegInfo.FVertMcuCount, (ABottom + McuH - 1) div McuH);

  XCount := McuRight - McuLeft;
  YCount := McuBottom - McuTop;
  XStart := McuLeft;
  YStart := McuTop;
  ALeft := McuLeft * McuW;
  ATop := McuTop * McuH;
  ARight := McuRight * McuW;
  ABottom := McuBottom * McuH;

  // Anything to load?
  if (XCount <= 0) or (YCount <= 0) then
    exit;

  FJpegInfo.FTileWidth := McuW * XCount * Divisor;
  FJpegInfo.FTileHeight := McuH * YCount * Divisor;

  // decode the block
  FCoder.DecodeBlock(FCoderStream, XStart, YStart, XCount, YCount);

  // put it in the map
  GetColorTransformToBitmap(TransformClass, FPixelFormat);
  if TransformClass = nil then
  begin
    DoDebugOut(Self, wsWarn, sNoColorTransformation);
    exit;
  end;

  Transform := TransformClass.Create;
  try
    // Inverse-DCT the coefficients, this also does the unquantization
    FCoder.InverseDCT;

    // Find the bitmap tile size based on decoded info and required scale
    GetBitmapTileSize(FLoadScale, FJpegInfo.FTileWidth, FJpegInfo.FTileHeight);

    // Set tile bitmap size and pixelformat, and get the iterator to pass as argument
    FMapIterator.Width := FJpegInfo.FTileWidth;
    FMapIterator.Height := FJpegInfo.FTileHeight;
    FMapIterator.CellStride := sdPixelFormatToByteCount(FPixelFormat);

    // this should update the FMapIterator from the application
    if assigned(FOnCreateMap) then
      FOnCreateMap(FMapIterator);

    // Ask the coder to put the samples in the bitmap
    FCoder.SamplesToImage(FMapIterator, Transform);

  finally
    Transform.Free;
  end;
  FCoder.HasSamples := True;

end;

procedure TsdJpegImage.BeforeLosslessUpdate(Sender: TObject);
begin
  // the loadfromfile does not decode the jpeg, so use LoadJpeg
  // with option DoCreateMap = False, if not yet done
  if not HasCoefficients then
    LoadJpeg(jsFull, False);
end;

procedure TsdJpegImage.AfterLosslessUpdate(Sender: TObject);
begin
  // after a lossless operation, SaveJpeg must be called
  // so that the huffman tables are recreated.
  SaveJpeg;
  Reload;
  LoadJpeg(jsFull, False);

  // call OnUpdate for the application
  if assigned(FOnUpdate) then
    FOnUpdate(Sender);
end;

function TsdJpegImage.LoadMarker(S: TStream): byte;
var
  B, MarkerTag, BytesRead: byte;
  Marker: TsdJpegMarker;
  JpegMarkerClass: TsdJpegMarkerClass;
  Size: word;
  StreamPos: integer;
begin
  // default is no marker
  Result := mkNone;

  // Read markers from the stream, until a non $FF is encountered
  DoDebugOut(Self, wsInfo, Format('Current Pos: %.6d', [S.Position]));
  BytesRead := S.Read(B, 1);
  if BytesRead = 0 then
  begin
    DoDebugOut(Self, wsWarn, sMarkerExpected);
    exit;
  end;

  // Do we have a marker?
  if B = $FF then
  begin
    // Which marker?
    S.Read(MarkerTag, 1);
    while MarkerTag = $FF do
    begin
      MarkerTag := mkNone;
      DoDebugOut(Self, wsWarn, Format('Error: duplicate $FF encountered at %.6d', [S.Position - 1]));
      S.Read(MarkerTag, 1);
    end;

    case MarkerTag of
    mkAPP0..mkAPP15:
      begin
        JpegMarkerClass := FindJpegMarkerClassList(MarkerTag, S);
        if JpegMarkerClass = nil then
          JpegMarkerClass := TsdAPPnMarker;
        Marker := JpegMarkerClass.Create(FJpegInfo, MarkerTag);
      end;
    mkDHT:
      Marker := TsdDHTMarker.Create(FJpegInfo, MarkerTag);
    mkDQT:
      Marker := TsdDQTMarker.Create(FJpegInfo, MarkerTag);
    mkDRI:
      Marker := TsdDRIMarker.Create(FJpegInfo, MarkerTag);
    mkSOF0..mkSOF3, mkSOF5..mkSOF7, mkSOF9..mkSOF11, mkSOF13..mkSOF15:
      Marker := TsdSOFnMarker.Create(FJpegInfo, MarkerTag);
    mkSOS:
      Marker := TsdSOSMarker.Create(FJpegInfo, MarkerTag);
    mkSOI:
      Marker := TsdSOIMarker.Create(FJpegInfo, MarkerTag);
    mkEOI:
      Marker := TsdEOIMarker.Create(FJpegInfo, MarkerTag);
    mkRST0..mkRST7:
      Marker := TsdRSTMarker.Create(FJpegInfo, MarkerTag);
    mkCOM:
      Marker := TsdCOMMarker.Create(FJpegInfo, MarkerTag);
    mkDNL:
      Marker := TsdDNLMarker.Create(FJpegInfo, MarkerTag);
    else
      // General marker
      Marker := TsdJpegMarker.Create(FJpegInfo, MarkerTag);
    end;

    // Add marker to our list
    FMarkers.Add(Marker);
    Marker.Owner := Self;

    if MarkerTag in [mkAPP0..mkAPP15, mkDHT, mkDQT, mkDRI,
      mkSOF0, mkSOF1, mkSOF2, mkSOF3, mkSOF5, mkSOF6, mkSOF7, mkSOF9, mkSOF10, mkSOF11, mkSOF13, mkSOF14, mkSOF15,
      mkSOS, mkCOM, mkDNL] then
    begin
      // Read length of marker
      Size := TsdJpegMarker.GetWord(S) - 2;
    end else
      Size := 0;

    StreamPos := S.Position;

    // Load the marker payload
    Marker.LoadFromStream(S, Size);

    // The SOS marker indicates start of entropy coding (start of scan),
    // EOI indicates end of image. SOF0 and SOF2 indicate
    // baseline and progressive starts, we do not use Marker.LoadFromStream for these.
    if not (MarkerTag in [mkSOF0..mkSOF2, mkSOS, mkRST0..mkRST7, mkEOI]) then
    begin

      // Find correct stream position
      S.Position := StreamPos + Size;
    end;
    
  end else
  begin

    // B <> $FF is an error, we try to be flexible
    DoDebugOut(Self, wsWarn, Format('Error: marker expected at %.6d', [S.Position - 1]));
    repeat
      BytesRead := S.Read(B, 1);
    until (BytesRead = 0) or (B = $FF);
    if BytesRead = 0 then
      raise EInvalidImage.Create(sMarkerExpected);
    S.Seek(-1, soFromCurrent);
    DoDebugOut(Self, wsHint, Format('Resuming at %.6d', [S.Position]));
  end;
  Result := MarkerTag;
end;

procedure TsdJpegImage.Reload;
// reload is helpful when savetostream and directly loadfromstream is used 
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    SaveToStream(MS);
    MS.Position := 0;
    LoadFromStream(MS);
  finally
    MS.Free;
  end;
end;

procedure TsdJpegImage.SaveJpeg;
// write the markers and save the coder stream
const
  cFF: byte = $FF;
var
  i: integer;
  M: TsdJpegMarker;
  SeenDHT: boolean;
  DHT: TsdDHTMarker;
begin
  // no coefficients? then CompressJpeg should have been called
  if not HasCoefficients then
  begin
    DoDebugOut(Self, wsFail, sNoDCTCoefficentsAvailable);
    exit;
  end;

  // We can now repeatedly save up to the last SOS, then ask the codec to encode
  // the scan
  SeenDHT := False;
  i := 0;
  
  while i < FMarkers.Count do
  begin
    M := Markers[i];

    if M is TsdDHTMarker then
      SeenDHT := True;

    if (M is TsdSOSMarker) and not SeenDHT then
    begin
      // We are at Start of Scan but have not saved a Huffman table, so we must
      // create one and do that now. First we apply scan data by writing the SOS marker.
      M.WriteMarker;

      // Now create the optimized huffman tables for this scan, by doing a dry
      // run, indicated by nil
      DoDebugOut(Self, wsInfo, 'doing dry-run encoding for Huffman table');
      FCoder.Encode(nil, 0);

      // Ask the coder to create the DHT marker for us, as a
      // result of the dry-run information
      DHT := FCoder.CreateDHTMarker;
      DoDebugOut(Self, wsInfo, 'writing DHT marker');
      if assigned(DHT) then
      begin
        DHT.WriteMarker;
        // If a marker was created, then insert it and continue, so it will be saved
        DoDebugOut(Self, wsInfo, 'inserting new DHT marker');
        FMarkers.Insert(i - 1, DHT);
        SeenDHT := True;
        Continue;
      end;
    end;

    if not (M.MarkerTag in [mkSOI, mkEOI, mkRST0..mkRST7]) then
    begin
      DoDebugOut(Self, wsInfo, Format('Writing marker %s', [M.MarkerName]));
      // Writing a marker will also make the marker update itself in the CodingInfo
      // object, so when calling FCoder.Encode later, it will have the current data
      M.WriteMarker;
    end;

    // Encode and save data
    if M is TsdSOSMarker then
    begin
      FCoderStream.Size := 0;
      FCoder.Encode(FCoderStream, 0);
      // bring position back to 0 for future load/saves
      FCoderStream.Position := 0;
    end;

    // Next marker
    inc(i);
  end;

  // the client can now use SaveToStream to save this new jpeg to a stream
end;

procedure TsdJpegImage.SaveBitmapStripByStrip(AWidth, AHeight: integer);
const
  cFF: byte = $FF;
var
  BitmapIter: TsdMapIterator;
  TransformClass: TsdColorTransformClass;
  Transform: TsdColorTransform;
  Stored: TsdJpegColorSpace;
  i, y: integer;
  M: TsdJpegMarker;
  BaselineCoder: TsdJpegBaselineCoder;
begin
  if not assigned(FOnProvideStrip) then
  begin
    DoDebugOut(Self, wsFail, sOnProvideStripMustBeAssigned);
    exit;
  end;

  if not assigned(FOnCreateMap) then
  begin
    DoDebugOut(Self, wsFail, sOnCreateMapMustBeAssigned);
    exit;
  end;

  Transform := nil;
  BitmapIter := TsdMapIterator.CreateDebug(Self);
  try
    // Check if bitmap is created with correct pixelformat
    case FBitmapCS of
    jcGray:
      BitmapIter.BitCount := 8;
    jcGrayA:
      BitmapIter.BitCount := 16;
    jcRGB, jcYCbCr, jcPhotoYCC:
      BitmapIter.BitCount := 24;
    jcRGBA, jcYCbCrA, jcCMYK, jcYCCK, jcPhotoYCCA:
      BitmapIter.BitCount := 32;
    else
      BitmapIter.BitCount := 24;
    end;
    FPixelFormat := sdBitCountToPixelFormat(BitmapIter.BitCount);
    BitmapIter.CellStride := BitmapIter.BitCount div 8;

    // We create the baseline coder
    FreeAndNil(FCoder);
    FCoder := TsdJpegBaselineCoder.Create(Self, FJpegInfo);
    BaselineCoder := TsdJpegBaselineCoder(FCoder);

    // Verify incoming bitmap format versus bitmap colorspace
    Stored := VerifyBitmapColorSpaceForSave;

    // We create minimal default markers to warrant color space detection
    // later on
    AddMinimalMarkersForColorSpaceDetection(Stored);

    // Ask save options to add DQT, SOFn and SOS marker. We use pre-defined
    // Huffman tables because we only do one pass over the image
    FSaveOptions.OptimizeHuffmanTables := False;
    FSaveOptions.AddMarkers(Stored, AWidth, AHeight);

    // We also must add an EOI marker
    FMarkers.Add(TsdEOIMarker.Create(FJpegInfo, mkEOI));

    // Color transform
    GetColorTransformFromBitmap(TransformClass);
    if not assigned(TransformClass) then
    begin
      DoDebugOut(Self, wsFail, sInvalidFormatForSelectedCS);
      exit;
    end;
    Transform := TransformClass.Create;

    // Initialize coder (this sets map sizes etc)
    FCoder.TileMode := True; // avoid allocating full buffer
    FCoder.Initialize(jsFull); // will calculate MCU height

    // bitmap strip size
    BitmapIter.Width := AWidth;
    BitmapIter.Height := FJpegInfo.FMcuHeight;

    // Result is usually a TBitmap (Win32/Linux, etc), but it is up to the application
    FOnCreateMap(BitmapIter);

    // Get iterator
    //GetBitmapIterator(FBitmap, BmpIter);

    // Now we can save the image, and interactively ask application for strips
    // We can now repeatedly save up to the last SOS, then ask the codec to encode
    // the scan
    i := 0;
    while i < FMarkers.Count do
    begin

      M := Markers[i];
      DoDebugOut(Self, wsInfo, Format('Writing marker %s', [IntToHex(M.MarkerTag, 2)]));
      if not (M.MarkerTag in [mkSOI, mkEOI, mkRST0..mkRST7]) then
      begin
        // Writing a marker will also make the marker update itself in the Info
        // object, so when calling FCoder.Encode later, it will have the current data
        M.WriteMarker;
      end;

      if M is TsdSOSMarker then
      begin

        // Start encoder in strip-by-strip mode. This will calculate MCU height
        BaselineCoder.EncodeStripStart(FCoderStream);

        // Encode strips one by one
        for y := 0 to FJpegInfo.FVertMcuCount - 1 do
        begin
          // Call the OnProvideStrip event
          // first, reset the bitnapiter method (since it gets changed by FCoder.SamplesFromImage later)
          BitmapIter.Method := imReaderX;
          FOnProvideStrip(Self, 0, y * FJpegInfo.FMcuHeight, BitmapIter);
          // Get samples from bitmap data
          FCoder.SamplesFromImage(BitmapIter, Transform);
          // Now convert samples to coefficients. This also does the quantization
          FCoder.ForwardDCT;
          // And encode them to the stream
          BaselineCoder.EncodeStrip(FCoderStream);
        end;

        // finalise encoder
        BaselineCoder.EncodeStripClose;

      end;

      // Next marker
      inc(i);
    end;

  finally
    BitmapIter.Free;
    Transform.Free;
  end;
end;

procedure TsdJpegImage.SaveToFile(const AFileName: string);
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(FS);
  finally
    FS.Free;
  end;
end;

procedure TsdJpegImage.SaveToStream(S: TStream);
const
  cFF: byte = $FF;
var
  i: integer;
  Marker: TsdJpegMarker;
  MS: TMemoryStream;
  MarkerSize, SwappedSize: word;
begin
  // loop thru the markers
  for i := 0 to FMarkers.Count - 1 do
  begin
    Marker := Markers[i];

    // write the marker tag
    S.Write(cFF, 1);
    S.Write(Marker.MarkerTag, 1);
    DoDebugOut(Self, wsInfo, Format('Saving marker %s', [Marker.MarkerName]));
    if not (Marker.MarkerTag in [mkSOI, mkEOI, mkRST0..mkRST7]) then
    begin
      MS := TMemoryStream.Create;
      try
        // save the marker to a memory stream
        Marker.SaveToStream(MS);
        MarkerSize := MS.Size + 2;
        SwappedSize := Swap(MarkerSize);
        MS.Position := 0;
        // write the marker size
        S.Write(SwappedSize, 2);
        // write the marker
        S.CopyFrom(MS, MS.Size);
      finally
        MS.Free;
      end;
    end;

    // after the SOS save coding stream
    if Marker is TsdSOSMarker then
    begin
      DoDebugOut(Self, wsInfo, Format('Saving coder stream (%d bytes)', [FCoderStream.Size]));
      FCoderStream.Position := 0;
      S.CopyFrom(FCoderStream, FCoderStream.Size);
      // bring position back to 0 for future load/saves
      FCoderStream.Position := 0;
    end;

  end;
end;

procedure TsdJpegImage.SetComment(const Value: AnsiString);
var
  M: TsdCOMMarker;
begin
  M := TsdCOMMarker(FMarkers.ByTag(mkCOM));
  if not assigned(M) then
  begin
    // We do not yet have a marker
    if not FMarkers.HasMarker([mkSOI]) then
      raise EInvalidImage.Create(sCommentCannotBeSet);
    // Create the marker and insert after SOI or JFIF marker (whichever comes last)
    M := TsdCOMMarker.Create(FJpegInfo, mkCOM);
    FMarkers.InsertAfter([mkSOI, mkAPP0], M);
  end;
  M.Comment := Value;
end;

procedure TsdJpegImage.SetICCProfile(const Value: TsdJpegICCProfile);
begin
  FreeAndNil(FICCProfile);
  FMarkers.RemoveMarkers([mkApp2]);
  if assigned(Value) then
    Value.WriteToMarkerList(FMarkers);
end;

function TsdJpegImage.VerifyBitmapColorSpaceForSave: TsdJpegColorSpace;
var
  Error: boolean;
begin
  Error := False;
  Result := FStoredCS;

  // Verify bitmap colorspace, raise error if pixelformat differs
  case FBitmapCS of
  jcAutoDetect:
    begin
      // Ensure we have some valid pixelformat
      if not (FPixelFormat in [spf8bit, spf24bit, spf32bit]) then
        FPixelFormat := spf24bit;
      case FPixelFormat of
      spf8bit:  Result := jcGray;
      spf24bit: Result := jcYCbCr;
      spf32bit: Result := jcYCCK;
      end;
    end;
  jcGray:
    Error := FPixelFormat <> spf8bit;
  jcGrayA:
    Error := FPixelFormat <> spf16bit;
  jcRGB, jcYCbCr, jcPhotoYCC:
    Error := FPixelFormat <> spf24bit;
  jcRGBA, jcYCbCrA, jcCMYK, jcYCCK, jcPhotoYCCA:
    Error := FPixelFormat <> spf32bit;
  end;
  if Error then
    raise EInvalidImage.Create(sInvalidFormatForSelectedCS);

  // Select correct colorspace to store
  if Result = jcAutoDetect then
  begin
    case FBitmapCS of
    jcGray:
      Result := jcGray;
    jcGrayA:
      Result := jcGrayA;
    jcRGB, jcYCbCr:
      Result := jcYCbCr;
    jcRGBA, jcYCbCrA:
      Result := jcYCbCrA;
    else
      Result := FBitmapCS;
    end;
  end;
end;

{ TsdJpegSaveOptions }

procedure TsdJpegSaveOptions.AddMarkers(AStored: TsdJpegColorSpace;
  AWidth, AHeight: integer);
var
  i: integer;
  Info: TsdJpegInfo;
  Frame: TsdFrameComponent;
  SOF: TsdSOFnMarker;
  SOS: TsdSOSMarker;
begin
  // Set the correct FInfo fields
  Info := FOwner.FJpegInfo;
  Info.FWidth := AWidth;
  Info.FHeight := AHeight;
  Info.FSamplePrecision := 8;
  case AStored of
  jcGray:
    Info.FFrameCount := 1;
  jcGrayA:
    Info.FFrameCount := 2;
  jcRGB, jcYCbCr, jcPhotoYCC:
    Info.FFrameCount := 3;
  jcRGBA, jcYCbCrA, jcCMYK, jcYCCK, jcPhotoYCCA:
    Info.FFrameCount := 4;
  else
    raise EInvalidImage.Create(sUnsupportedColorSpace);
  end;

  // Subsampling used?
  case AStored of
  jcYCbCr, jcYCbCrA, jcYCCK, jcPhotoYCC, jcPhotoYCCA:
    FUseSubSampling := True
  else
    FUseSubSampling := False;
  end;

  // Set up frame sampling
  for i := 0 to Info.FFrameCount - 1 do
  begin
    Frame := Info.FFrames[i];
    if (i in [1, 2]) then
    begin
      // Subsampled frame
      Frame.FHorzSampling := 1;
      Frame.FVertSampling := 1;
      if FUseSubSampling then
        Frame.FQTable := 1
      else
        Frame.FQTable := 0;
    end else
    begin
      // Full frame
      if FUseSubSampling then
      begin
        Frame.FHorzSampling := 2;
        Frame.FVertSampling := 2;
      end else
      begin
        Frame.FHorzSampling := 1;
        Frame.FVertSampling := 1;
      end;
      Frame.FQTable := 0;
    end;
    Frame.FComponentID := i + 1;
  end;
  if FUseSubSampling then
  begin
    Info.FHorzSamplingMax := 2;
    Info.FVertSamplingMax := 2;
  end else
  begin
    Info.FHorzSamplingMax := 1;
    Info.FVertSamplingMax := 1;
  end;

  // Setup and add quant tables
  SetupQuantTables;

  // Create and add SOFn marker
  SOF := TsdSOFnMarker.Create(Info, mkSOF0);
  FOwner.Markers.Add(SOF);

  // Create and add default Huffman tables if required
  if not OptimizeHuffmanTables then
    SetupDefaultHuffmanTables;

  // Create and add SOS marker
  SOS := TsdSOSMarker.Create(Info, mkSOS);
  FOwner.Markers.Add(SOS);

  SetLength(SOS.FMarkerInfo, Info.FFrameCount);
  SOS.FScanCount := Info.FFrameCount;
  for i := 0 to Info.FFrameCount - 1 do
  begin
    SOS.FMarkerInfo[i].ComponentID := i + 1;
    SOS.FMarkerInfo[i].DCTable := Info.FFrames[i].FQTable;
    SOS.FMarkerInfo[i].ACTable := Info.FFrames[i].FQTable;
  end;

end;

constructor TsdJpegSaveOptions.Create(AOwner: TsdJpegImage);
begin
  inherited Create;
  FOwner := AOwner;
  FQuality := cDefaultJpgCompressionQuality;
  FOptimizeHuffmanTables := True;
  FCodingMethod := emBaselineDCT;
  FUseSubSampling := True;
end;

procedure TsdJpegSaveOptions.SetTableMultiplication(ATable: TsdQuantizationTable;
  MultiplyPercent: integer; const ADefaultTable: TsdIntArray64);
var
  i, Q: integer;
begin
  for i := 0 to 63 do
  begin
    Q := (ADefaultTable[cJpegInverseZigZag8x8[i]] * MultiplyPercent + 50) div 100;
    // ensure that quant factor is in valid range
    if Q <= 0 then
      Q := 1
    else
      if Q > 255 then
        Q := 255;
    // set table quant factor i
    ATable.FQuant[i] := Q;
  end;
end;

procedure TsdJpegSaveOptions.SetupDefaultHuffmanTables;
var
  M: TsdDHTMarker;
  procedure FillTable(var Info: TsdDHTMarkerInfo; Bits, Values: Pbyte; Tc, Th: byte);
  var
    i, Count: integer;
  begin
    Count := 0;
    Info.Tc := Tc;
    Info.Th := Th;
    for i := 0 to 15 do
    begin
      Info.BitLengths[i] := Bits^;
      inc(Count, Bits^);
      inc(Bits);
    end;
    SetLength(Info.BitValues, Count);
    for i := 0 to Count - 1 do
    begin
      Info.BitValues[i] := Values^;
      inc(Values);
    end;
  end;
begin
  M := TsdDHTMarker.Create(FOwner.FJpegInfo, mkDHT);
  if FUseSubsampling then
    SetLength(M.FMarkerInfo, 4)
  else
    SetLength(M.FMarkerInfo, 2);

  // Luminance tables (always used)
  FillTable(M.FMarkerInfo[0], @cHuffmanBitsDcLum[0], @cHuffmanValDcLum[0], 0, 0);
  FillTable(M.FMarkerInfo[1], @cHuffmanBitsAcLum[0], @cHuffmanValAcLum[0], 1, 0);

  if FUseSubsampling then
  begin
    // Chrominance tables (only when subsampling is used)
    FillTable(M.FMarkerInfo[2], @cHuffmanBitsDcChrom[0], @cHuffmanValDcChrom[0], 0, 1);
    FillTable(M.FMarkerInfo[3], @cHuffmanBitsAcChrom[0], @cHuffmanValAcChrom[0], 1, 1);
  end;
  FOwner.Markers.Add(M);
end;

procedure TsdJpegSaveOptions.SetupQuantTables;
var
  QMul: integer;
  T: TsdQuantizationTable;
  M: TsdDQTMarker;
begin
  if FQuality < 1 then
    FQuality := 1
  else
    if FQuality > 100 then
      FQuality := 100;

  // Calculation of quant multiplication factor
  if FQuality < 50 then
    QMul := 5000 div FQuality
  else
    QMul := 200 - FQuality * 2;

  // Create DQT marker
  M := TsdDQTMarker.Create(FOwner.FJpegInfo, mkDQT);
  if FUseSubSampling then
    SetLength(M.FTableIndices, 2)
  else
    SetLength(M.FTableIndices, 1);

  // Quant table 0
  T := FOwner.FJpegInfo.FQuantizationTables[0];
  SetTableMultiplication(T, QMul, cStdLuminanceQuantTbl);
  M.FTableIndices[0] := 0;

  // Quant table 1
  if FUseSubSampling then
  begin
    T := FOwner.FJpegInfo.FQuantizationTables[1];
    SetTableMultiplication(T, QMul, cStdChrominanceQuantTbl);
    M.FTableIndices[1] := 1;
  end;

  // Add DQT marker
  FOwner.Markers.Add(M);
end;

end.

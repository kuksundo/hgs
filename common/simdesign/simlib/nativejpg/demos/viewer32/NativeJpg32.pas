{ unit NativeJpg32.pas

  Author: Nils Haeck M.Sc.
  Copyright (c) 2011 SimDesign B.V.
  Creation Date: 15jun2011
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.

  Description:

  NativeJpg32 is a library specifically to load Jpg files in Graphics32.

  Info on Graphics32:
  http://graphics32.org/wiki/

  The actual Jpeg encoding/decoding functionality is in files sdJpeg*.pas, most
  notably sdJpegImage.pas.
}
unit NativeJpg32;

interface

{$i simdesign.inc}

{$define DEPRECATEDMODE} // for GR32

uses
  GR32, // we use Graphics32 in this demo
  Classes, SysUtils, Graphics,

  // nativejpg
  sdJpegImage, sdJpegTypes,

  // bitmap
  sdMapIterator, sdBitmapConversionWin, sdBitmapResize,

  // general
  sdStreams, sdDebug;

type

  // Use Performance to set the performance of the jpeg image when reading, that is,
  // for decompressing files. This property is not used for writing out files.
  // With jpBestSpeed, the DCT decompressing process uses a faster but less accurate method.
  // When loading half, quarter or 1/8 size, this performance setting is not used.
  TsdJpegPerformance = (
    jpBestQuality,
    jpBestSpeed
  );

  // TsdJpegGraphic32 is a Delphi class, which can be used
  // to load Jpeg files into TBitmap32. It relays the Jpeg functionality in the non-Windows
  // TsdJpegImage class to this TBitmap32 component.
  TsdJpegGraphic32 = class(TPersistent)
  private
    // the temporary TBitmap32 that can be either the full image or the
    // tilesized bitmap when UseTiledDrawing is activated.
    FBitmap32: TBitmap32;
    FImage: TsdJpegImage;
    FUseTiledDrawing: boolean;
    FOnDebugOut: TsdDebugEvent;
    function ImageCreateMap(var AIterator: TsdMapIterator): TObject;
    procedure ImageUpdate(Sender: TObject);
    procedure ImageDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
    function GetPerformance: TsdJpegPerformance;
    procedure SetPerformance(const Value: TsdJpegPerformance);
    function GetGrayScale: boolean;
    procedure SetGrayScale(const Value: boolean);
    function GetCompressionQuality: TsdJpegQuality;
    procedure SetCompressionQuality(const Value: TsdJpegQuality);
    procedure SetUseTiledDrawing(const Value: boolean);
    function GetScale: TsdJpegScale;
    procedure SetScale(const Value: TsdJpegScale);
  protected
    // Assign this TsdJpegGraphic to Dest. The only valid type for Dest is TBitmap32.
    // The internal jpeg image will be loaded from the data stream at the correct
    // scale, then assigned to the bitmap in Dest.
    procedure AssignTo(Dest: TPersistent); override;
    function GetEmpty: Boolean;
    function GetHeight: Integer;
    function GetWidth: Integer;
    function GetDataSize: int64;
    class function GetVersion: string;
  public
    constructor Create; virtual;//override;
    destructor Destroy; override;

    // Use Assign to assign a TBitmap32 or other TsdJpegGraphic to this graphic. If
    // Source is a TBitmap32, the TBitmap32 is compressed to the internal jpeg image.
    // If Source is another TsdJpegGraphic,
    // the data streams are copied and the internal Jpeg image is loaded from the
    // data. It is also possible to assign a TsdJpegGraphic to a TBitmap, like this:
    // <code>
    //   MyBitmap.Assign(MyJpegGraphic)
    // </code>
    // In that case, the protected AssignTo method is called.
    procedure Assign(Source: TPersistent); override;

    // Load a Jpeg graphic from the stream in Stream. Stream can be any stream
    // type, as long as the size of the stream is known in advance. The stream
    // should only contain *one* Jpeg graphic.
    procedure LoadFromStream(Stream: TStream); //override;
    procedure LoadFromFile(const AFileName: string);

    // In case of LoadOption [loTileMode] is included, after the LoadFromStream,
    // individual tile blocks can be loaded which will be put in the resulting
    // bitmap. The tile loaded will contain all the MCU blocks that fall within
    // the specified bounds ALeft/ATop/ARight/ABottom. Note that these are var
    // parameters, after calling this procedure they will be updated to the MCU
    // block borders. ALeft/ATop can subsequently be used to draw the resulting
    // TsdJpegFormat.Bitmap to a canvas.
    procedure LoadTileBlock(var ALeft, ATop, ARight, ABottom: integer);

    // Save a Jpeg graphic to the stream in Stream. Stream can be any stream
    // type, as long as the size of the stream is known in advance.
    procedure SaveToStream(Stream: TStream); //override;
    procedure SaveToFile(const AFileName: string);
    property Performance: TsdJpegPerformance read GetPerformance write SetPerformance;
    // Downsizing scale when loading. When downsizing, the Jpeg compressor
    // uses less memory and processing power to decode the DCT coefficients.
    // jsFull is the 100% scale. jsDiv2 is 50% scale, jsDiv4 is 25% scale and jsDiv8
    // is 12.5% scale (aka 1/8).
    property Scale: TsdJpegScale read GetScale write SetScale;
    property GrayScale: boolean read GetGrayScale write SetGrayScale;
    property CompressionQuality: TsdJpegQuality read GetCompressionQuality write SetCompressionQuality;
    // When UseTiledDrawing is activated, the Jpeg graphic gets drawn by separate
    // small tiled bitmaps when using TsdJpegGraphic.Draw. Only baseline jpeg images can
    // use tiled drawing, so activating this setting takes no effect in other
    // compression methods. The default tile size is 256x256 pixels.
    property UseTiledDrawing: boolean read FUseTiledDrawing write SetUseTiledDrawing;
    // Version returns the current version of the NativeJpeg library.
    property Version: string read GetVersion;
    // size in bytes of the data in the Jpeg
    property DataSize: int64 read GetDataSize;
    // Access to TsdJpegImage
    property Image: TsdJpegImage read FImage;
    // connect to OnDebugOut to get debug info from TsdJpegGraphic
    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
    property Width: integer read GetWidth;
    property Height: integer read GetHeight;
  end;

implementation

function SetBitmap32FromIterator(const AIterator: TsdMapIterator): TBitmap32;
begin
  Result := TBitmap32.Create;
  Result.Width := AIterator.Width;
  Result.Height := AIterator.Height;
end;

procedure GetBitmap32Iterator(ABitmap32: TBitmap32; AIterator: TsdMapIterator);
begin
  AIterator.Width := ABitmap32.Width;
  AIterator.Height := ABitmap32.Height;
  if ABitmap32.Width * ABitmap32.Height = 0 then
    exit;
  AIterator.Map := PByte(ABitmap32.ScanLine[0]);
  if AIterator.Height > 1 then
    AIterator.ScanStride := integer(ABitmap32.ScanLine[1]) - integer(ABitmap32.ScanLine[0])
  else
    AIterator.ScanStride := 0;

  AIterator.CellStride := 4;
  AIterator.BitCount := 32;
end;

{ TsdJpegGraphic32 }

procedure TsdJpegGraphic32.Assign(Source: TPersistent);
var
  MS: TsdFastMemStream;
  BitmapIter: TsdMapIterator;
begin
  // assign to another TsdJpegGraphic32
  if Source is TsdJpegGraphic32 then
  begin
    MS := TsdFastMemStream.Create;
    try
      TsdJpegGraphic32(Source).SaveToStream(MS);
      MS.Position := 0;
      FImage.LoadFromStream(MS);
    finally
      MS.Free;
    end;
    // Load the default OnCreateMap event for TsdJpegGraphic
    FImage.OnCreateMap := ImageCreateMap;
    exit;
  end;

  // assign to TBitmap32
  if Source is TBitmap32 then
  begin
    // lightweight map iterator
    BitmapIter := TsdMapIterator.Create;
    try
      GetBitmap32Iterator(TBitmap32(Source), BitmapIter);
      ImageDebug(Self, wsHint, Format('bitmap scanstride=%d', [BitmapIter.ScanStride]));

      // Clear the image first
      FImage.Clear;

      // You can change the quality of the compression (and thus the size of the Jpeg) by changing this:
      //FImage.SaveOptions.Quality := 95;

      // compress the image
      FImage.Compress(BitmapIter);

      // Save the Jpeg image based on the bitmap iterator
      FImage.SaveJpeg;
    finally
      BitmapIter.Free;
    end;
    // Reload the image
    FImage.Reload;
    //..and exit
    exit;
  end;

  // default method
  inherited;
end;

procedure TsdJpegGraphic32.AssignTo(Dest: TPersistent);
begin
  if Dest is TBitmap32 then
  begin
    // the LoadLJpeg method will create the FBitmap32 thru ImageCreateMap
    Image.LoadJpeg(Scale, True);
    TBitmap32(Dest).Assign(FBitmap32);
  end else
    inherited;
end;

constructor TsdJpegGraphic32.Create;
begin
  inherited;
  FImage := TsdJpegImage.Create(nil);
  FImage.OnUpdate := ImageUpdate;
  FImage.OnDebugOut := ImageDebug;
  FImage.OnCreateMap := ImageCreateMap;
  FImage.DCTCodingMethod := dmAccurate;
end;

destructor TsdJpegGraphic32.Destroy;
begin
  FreeAndNil(FImage);
  FreeAndNil(FBitmap32);
  inherited;
end;

function TsdJpegGraphic32.GetCompressionQuality: TsdJpegQuality;
begin
  Result := FImage.SaveOptions.Quality;
end;

function TsdJpegGraphic32.GetDataSize: int64;
begin
  Result := FImage.DataSize;
end;

function TsdJpegGraphic32.GetEmpty: Boolean;
begin
  Result := not FImage.HasBitmap;
end;

function TsdJpegGraphic32.GetGrayScale: boolean;
begin
  Result := FImage.BitmapCS = jcGray;
end;

function TsdJpegGraphic32.GetHeight: Integer;
begin
  Result := FImage.Height;
end;

function TsdJpegGraphic32.GetPerformance: TsdJpegPerformance;
begin
  if FImage.DCTCodingMethod = dmFast then
    Result := jpBestSpeed
  else
    Result := jpBestQuality;
end;

function TsdJpegGraphic32.GetScale: TsdJpegScale;
begin
  Result := FImage.LoadScale;
end;

class function TsdJpegGraphic32.GetVersion: string;
begin
  Result := cNativeJpgVersion;
end;

function TsdJpegGraphic32.GetWidth: Integer;
begin
  Result := FImage.Width;
end;

procedure TsdJpegGraphic32.ImageDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if assigned(FOnDebugOut) then
    FOnDebugOut(Sender, WarnStyle, AMessage);
end;

procedure TsdJpegGraphic32.ImageUpdate(Sender: TObject);
begin
  // this update comes from the TsdJpegImage subcomponent.
  // We must free the bitmap so TsdJpegImage can create a new one
  FreeAndNil(FBitmap32);
end;

function TsdJpegGraphic32.ImageCreateMap(var AIterator: TsdMapIterator): TObject;
begin
  ImageDebug(Self, wsInfo, Format('create TBitmap x=%d y=%d',
    [AIterator.Width, AIterator.Height]));

  // create a bitmap with iterator size and pixelformat
  if (not assigned(FBitmap32)) or (FBitmap32.Width <> AIterator.Width) or
    (FBitmap32.Height <> AIterator.Height) then
  begin
    // create a new bitmap with iterator size and pixelformat
    FreeAndNil(FBitmap32);
    FBitmap32 := SetBitmap32FromIterator(AIterator);
    FBitmap32.Clear($FFFFFFFF);
  end;

  // also update the iterator with bitmap properties
  GetBitmap32Iterator(FBitmap32, AIterator);

  ImageDebug(Self, wsInfo, Format('AIterator bitmap scanstride=%d', [AIterator.ScanStride]));

  Result := FBitmap32;
end;

procedure TsdJpegGraphic32.LoadFromFile(const AFileName: string);
begin
  FImage.LoadFromFile(AFileName);
end;

procedure TsdJpegGraphic32.LoadFromStream(Stream: TStream);
begin
  FImage.LoadFromStream(Stream);
end;

procedure TsdJpegGraphic32.LoadTileBlock(var ALeft, ATop, ARight, ABottom: integer);
begin
  // relay to FImage
  FImage.LoadTileBlock(ALeft, ATop, ARight, ABottom);
end;

procedure TsdJpegGraphic32.SaveToStream(Stream: TStream);
begin
  FImage.SaveToStream(Stream);
end;

procedure TsdJpegGraphic32.SaveToFile(const AFileName: string);
begin
  FImage.SaveToFile(AFileName);
end;

procedure TsdJpegGraphic32.SetCompressionQuality(const Value: TsdJpegQuality);
begin
  FImage.SaveOptions.Quality := Value;
end;

procedure TsdJpegGraphic32.SetGrayScale(const Value: boolean);
begin
  if Value then
    FImage.BitmapCS := jcGray
  else
    FImage.BitmapCS := jcRGB;
end;

procedure TsdJpegGraphic32.SetPerformance(const Value: TsdJpegPerformance);
begin
  case Value of
  jpBestSpeed: FImage.DCTCodingMethod := dmFast;
  jpBestQuality: FImage.DCTCodingMethod := dmAccurate;
  end;
end;

procedure TsdJpegGraphic32.SetScale(const Value: TsdJpegScale);
begin
  FImage.LoadScale := Value;
end;

procedure TsdJpegGraphic32.SetUseTiledDrawing(const Value: boolean);
begin
  FUseTiledDrawing := Value;
  if FUseTiledDrawing then
    FImage.LoadOptions := FImage.LoadOptions + [loTileMode]
  else
    FImage.LoadOptions := FImage.LoadOptions - [loTileMode]
end;

end.

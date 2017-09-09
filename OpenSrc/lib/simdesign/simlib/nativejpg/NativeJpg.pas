{ unit NativeJpg.pas

  Description:

  NativeJpg is a library that provides full functionality for Jpeg images (*.jpg,
  *.jpeg). It can be used as a replacement for Delphi's Jpeg unit. Just replace
  "Jpeg" in the uses clause by "NativeJpg", and add the source folder with
  NativeJpg's files to the search path of your project.

  This unit contains class TsdJpegGraphic, a TGraphic descendant, so it works
  like any TGraphic descendant, allowing to load jpeg files in TPicture / TImage,
  and providing preview capability in TOpenPictureDialog and TSavePictureDialog.

  The actual Jpeg encoding/decoding functionality is in files sdJpeg*.pas, most
  notably sdJpegImage.pas.

  simple example:

    Jpeg := TsdJpegGraphic.Create;
    try
      Jpeg.LoadFromFile('image1.jpg');
      Jpeg.LosslessRotate90;
      Jpeg.SaveToFile('image2.jpg');
    finally
      Jpeg.Free;
    end;

  Author: Nils Haeck M.Sc.
  Creation Date: 24Apr2007
  Copyright (c) 2007 SimDesign B.V.

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.

  More information: www.simdesign.nl or n.haeck@simdesign.nl
}
unit NativeJpg;

interface

{$i simdesign.inc}

{$ifdef MSWINDOWS}
  {$define USEWINDOWS}
{$endif MSWINDOWS}

uses
{$ifdef USEWINDOWS}
  Windows,
{$endif USEWINDOWS}
  Classes, SysUtils, Graphics, sdDebug,

  // nativejpg
  sdJpegImage, sdJpegTypes,

  // bitmap
  sdMapIterator, sdBitmapConversionWin, sdBitmapResize,

  // general
  sdStreams, NativeXml;

type

  // Use Performance to set the performance of the jpeg image when reading, that is,
  // for decompressing files. This property is not used for writing out files.
  // With jpBestSpeed, the DCT decompressing process uses a faster but less accurate method.
  // When loading half, quarter or 1/8 size, this performance setting is not used.
  TsdJpegPerformance = (
    jpBestQuality,
    jpBestSpeed
  );

  // TsdJpegGraphic is a Delphi TGraphic-compatible class, which can be used
  // to load Jpeg files. It relays the Jpeg functionality in the non-Windows
  // TsdJpegImage class to this TGraphic descendant.
  // It provides preview capability inside TOpenPictureDialog. It provides very
  // fast (and good quality) preview and this class registers itself as a
  // TGraphic compatible class just by including "NativeJpg" in your project.
  TsdJpegGraphic = class(TGraphic)
  private
    // the temporary Windows TBitmap that can be either the full image or the
    // tilesized bitmap when UseTiledDrawing is activated.
    FBitmap: TBitmap;
    FImage: TsdJpegImage;
    FUseTiledDrawing: boolean;
    FOnDebugOut: TsdDebugEvent;
    procedure DrawNormal(ACanvas: TCanvas; const Rect: TRect; AScale: TsdJpegScale; UseStretchDraw: boolean);
    procedure DrawTiled(ACanvas: TCanvas; const Rect: TRect; AScale: TsdJpegScale);
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
    // Assign this TsdJpegGraphic to Dest. The only valid type for Dest is TBitmap.
    // The internal jpeg image will be loaded from the data stream at the correct
    // scale, then assigned to the bitmap in Dest.
    procedure AssignTo(Dest: TPersistent); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
    procedure SetHeight(Value: Integer); override;
    procedure SetWidth(Value: Integer); override;
    procedure ReadData(Stream: TStream); override;
    procedure WriteData(Stream: TStream); override;
    function GetDataSize: int64;
    class function GetVersion: string;
  public
    constructor Create; override;
    destructor Destroy; override;

    // Use Assign to assign a TBitmap or other TsdJpegGraphic to this graphic. If
    // Source is a TBitmap, the TBitmap is compressed to the internal jpeg image.
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
    procedure LoadFromStream(Stream: TStream); override;

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
    procedure SaveToStream(Stream: TStream); override;
{$ifdef USEWINDOWS}
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;
{$endif USEWINDOWS}
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

    // lossless procedures

    // lossless rotation of the jpeg file over 90 degrees
    procedure LosslessRotate90;
    // lossless rotation of the jpeg file over 180 degrees
    procedure LosslessRotate180;
    // lossless rotation of the jpeg file over 270 degrees
    procedure LosslessRotate270;
  end;

implementation

{ TsdJpegGraphic }

procedure TsdJpegGraphic.Assign(Source: TPersistent);
var
  MS: TsdFastMemStream;
  BitmapIter: TsdMapIterator;
begin
  // assign to another TsdJpegGraphic
  if Source is TsdJpegGraphic then
  begin
    MS := TsdFastMemStream.Create;
    try
      TsdJpegGraphic(Source).SaveToStream(MS);
      MS.Position := 0;
      FImage.LoadFromStream(MS);
    finally
      MS.Free;
    end;
    // Load the default OnCreateMap event for TsdJpegGraphic
    FImage.OnCreateMap := ImageCreateMap;
    exit;
  end;

  // assign to TBitmap
  if Source is TBitmap then
  begin
    // lightweight map iterator
    BitmapIter := TsdMapIterator.Create;
    try
      GetBitmapIterator(TBitmap(Source), BitmapIter);
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

procedure TsdJpegGraphic.AssignTo(Dest: TPersistent);
var
  B: TBitmap;
begin
  if Dest is TBitmap then
  begin
    B := TBitmap(Dest);
    B.Width := Width;
    B.Height := Height;
    Draw(B.Canvas, Rect(0, 0, B.Width, B.Height));
  end else
    inherited;
end;

constructor TsdJpegGraphic.Create;
begin
  inherited;
  FImage := TsdJpegImage.Create(nil);
  FImage.OnUpdate := ImageUpdate;
  FImage.OnDebugOut := ImageDebug;
  FImage.OnCreateMap := ImageCreateMap;
  FImage.DCTCodingMethod := dmAccurate;
end;

destructor TsdJpegGraphic.Destroy;
begin
  FreeAndNil(FImage);
  FreeAndNil(FBitmap);
  inherited;
end;

procedure TsdJpegGraphic.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  WReq, HReq, W, H: integer;
  S: TsdJpegScale;
  UseStretchDraw: boolean;

  // Determine if size is acceptable
  function AcceptSize: boolean;
  begin
    FImage.GetBitmapSize(S, W, H);
    Result := (W >= WReq) and (H >= HReq);
  end;

// main
begin
  // Determine correct scale
  WReq := Rect.Right - Rect.Left;
  HReq := Rect.Bottom - Rect.Top;

  // Check with which scale to load
  S := jsDiv8;
  while not AcceptSize do
  begin
    if S = jsFull then
      break;
    dec(S); // index down, so fuller
  end;

  // width and height requirements
  UseStretchDraw := ((W = WReq) and (H = HReq)) or (W < WReq) or (H < HReq);

  if UseTiledDrawing and (W = WReq) and (H = HReq) then
    DrawTiled(ACanvas, Rect, S)
  else
    DrawNormal(ACanvas, Rect, S, UseStretchDraw);
end;

procedure TsdJpegGraphic.DrawNormal(ACanvas: TCanvas; const Rect: TRect; AScale: TsdJpegScale; UseStretchDraw: boolean);
var
  Dest: TBitmap;

begin
  // FImage.LoadJpeg exposes OnCreate event that eventually
  // provides FBitmap in ImageCreateMap
  FImage.LoadJpeg(AScale, True);

  // width and height requirements
  if UseStretchDraw then
  begin

    // Stretchdraw to canvas
    ACanvas.StretchDraw(Rect, FBitmap);
    ImageDebug(Self, wsInfo, 'stretchdraw');

  end else
  begin

    // Use a fast downsizing algo
    Dest := TBitmap.Create;
    try
      Dest.PixelFormat := pf24bit;
      Dest.Width := Rect.Right - Rect.Left;
      Dest.Height := Rect.Bottom - Rect.Top;
      DownscaleBitmapWin(FBitmap, Dest);

      // Draw to canvas (since it is the right size now)
      ACanvas.Draw(Rect.Left, Rect.Top, Dest);
      ImageDebug(Self, wsInfo, 'downsize draw');

    finally
      Dest.Free;
    end;
  end;
end;

procedure TsdJpegGraphic.DrawTiled(ACanvas: TCanvas; const Rect: TRect; AScale: TsdJpegScale);
var
  x, y, Left, Top, Right, Bottom, XCount, YCount: integer;
const
  // Tilesize to use (256x256 pixel blocks)
  cTileSize = 256;
begin
  //
  FImage.LoadScale := AScale;

  // Number of blocks in X and Y direction
  XCount := (Width + cTileSize - 1) div cTileSize;
  YCount := (Height + cTileSize - 1) div cTileSize;

  ImageDebug(Self, wsInfo, Format('DrawTiled %dX x %dY blocks', [XCount, YCount]));

  // Loop through these blocks left to right, top to bottom
  for y := 0 to YCount - 1 do
  begin
    for x := 0 to XCount - 1 do
    begin
      Left   := x * cTileSize;
      Top    := y * cTileSize;
      Right  := Left + cTileSize;
      Bottom := Top + cTileSize;

      // Load a tile block. Each of these blocks is put in the application's
      // FBitmap field by OnCreateMap, but the Jpeg's bitmap size will
      // thus remain very small and consume less memory.
      FImage.LoadTileBlock(Left, Top, Right, Bottom);

      // copy to image bitmap at correct location
      ACanvas.Draw(Left, Top, FBitmap);

    end;
  end;
end;

function TsdJpegGraphic.GetCompressionQuality: TsdJpegQuality;
begin
  Result := FImage.SaveOptions.Quality;
end;

function TsdJpegGraphic.GetDataSize: int64;
begin
  Result := FImage.DataSize;
end;

function TsdJpegGraphic.GetEmpty: Boolean;
begin
  Result := not FImage.HasBitmap;
end;

function TsdJpegGraphic.GetGrayScale: boolean;
begin
  Result := FImage.BitmapCS = jcGray;
end;

function TsdJpegGraphic.GetHeight: Integer;
begin
  Result := FImage.Height;
end;

function TsdJpegGraphic.GetPerformance: TsdJpegPerformance;
begin
  if FImage.DCTCodingMethod = dmFast then
    Result := jpBestSpeed
  else
    Result := jpBestQuality;
end;

function TsdJpegGraphic.GetScale: TsdJpegScale;
begin
  Result := FImage.LoadScale;
end;

class function TsdJpegGraphic.GetVersion: string;
begin
  Result := cNativeJpgVersion;
end;

function TsdJpegGraphic.GetWidth: Integer;
begin
  Result := FImage.Width;
end;

procedure TsdJpegGraphic.ImageDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if assigned(FOnDebugOut) then
    FOnDebugOut(Sender, WarnStyle, AMessage);
end;

procedure TsdJpegGraphic.ImageUpdate(Sender: TObject);
begin
  // this update comes from the TsdJpegImage subcomponent.
  // We must free the bitmap so TsdJpegImage can create a new one
  FreeAndNil(FBitmap);
end;

function TsdJpegGraphic.ImageCreateMap(var AIterator: TsdMapIterator): TObject;
begin
  ImageDebug(Self, wsInfo, Format('create TBitmap x=%d y=%d stride=%d',
    [AIterator.Width, AIterator.Height, AIterator.CellStride]));

  // create a bitmap with iterator size and pixelformat
  if (not assigned(FBitmap)) or (FBitmap.Width <> AIterator.Width) or
    (FBitmap.Height <> AIterator.Height) then
  begin
    // create a new bitmap with iterator size and pixelformat
    FreeAndNil(FBitmap);
    FBitmap := SetBitmapFromIterator(AIterator); // in sdBitmapConversionWin
  end;

  // also update the iterator with bitmap properties
  GetBitmapIterator(FBitmap, AIterator); // in sdBitmapConversionWin

  //ImageDebug(Self, wsInfo, Format('AIterator bitmap scanstride=%d', [AIterator.ScanStride]));

  Result := FBitmap;
end;

{$ifdef USEWINDOWS}
procedure TsdJpegGraphic.LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE);
begin
// not implemented
end;
{$endif USEWINDOWS}

procedure TsdJpegGraphic.LoadFromStream(Stream: TStream);
begin
  FImage.LoadFromStream(Stream);
end;

procedure TsdJpegGraphic.LoadTileBlock(var ALeft, ATop, ARight, ABottom: integer);
begin
  // relay to FImage
  FImage.LoadTileBlock(ALeft, ATop, ARight, ABottom);
end;

procedure TsdJpegGraphic.ReadData(Stream: TStream);
var
  Size: Longint;
  MS: TsdFastMemStream;
begin
  Stream.Read(Size, SizeOf(Size));
  if Size > 0 then
  begin
    MS := TsdFastMemStream.Create;
    try
      FImage.LoadOptions := [loOnlyMetadata];
      MS.CopyFrom(Stream, Size);
      MS.Position := 0;
      FImage.LoadFromStream(MS);
    finally
      MS.Free;
    end;
  end;
end;

{$ifdef USEWINDOWS}
procedure TsdJpegGraphic.SaveToClipboardFormat(var AFormat: Word; var AData: THandle; var APalette: HPALETTE);
begin
// not implemented
end;
{$endif USEWINDOWS}

procedure TsdJpegGraphic.SaveToStream(Stream: TStream);
begin
  FImage.SaveToStream(Stream);
end;

procedure TsdJpegGraphic.SetCompressionQuality(const Value: TsdJpegQuality);
begin
  FImage.SaveOptions.Quality := Value;
end;

procedure TsdJpegGraphic.SetGrayScale(const Value: boolean);
begin
  if Value then
    FImage.BitmapCS := jcGray
  else
    FImage.BitmapCS := jcRGB;
end;

procedure TsdJpegGraphic.SetHeight(Value: Integer);
begin
// not implemented
end;

procedure TsdJpegGraphic.SetPerformance(const Value: TsdJpegPerformance);
begin
  case Value of
  jpBestSpeed: FImage.DCTCodingMethod := dmFast;
  jpBestQuality: FImage.DCTCodingMethod := dmAccurate;
  end;
end;

procedure TsdJpegGraphic.SetScale(const Value: TsdJpegScale);
begin
  FImage.LoadScale := Value;
end;

procedure TsdJpegGraphic.SetUseTiledDrawing(const Value: boolean);
begin
  FUseTiledDrawing := Value;
  if FUseTiledDrawing then
    FImage.LoadOptions := FImage.LoadOptions + [loTileMode]
  else
    FImage.LoadOptions := FImage.LoadOptions - [loTileMode]
end;

procedure TsdJpegGraphic.SetWidth(Value: Integer);
begin
// not implemented
end;

procedure TsdJpegGraphic.WriteData(Stream: TStream);
var
  MS: TsdFastMemStream;
  Size: LongInt;
begin
  MS := TsdFastMemStream.Create;
  try
    FImage.SaveToStream(MS);
    Size := MS.Size;
    Stream.Write(Size, SizeOf(Size));
    if Size > 0 then
      Stream.Write(MS.Memory^, Size);
  finally
    MS.Free;
  end;
end;

procedure TsdJpegGraphic.LosslessRotate90;
begin
  FImage.Lossless.Rotate90;
end;

procedure TsdJpegGraphic.LosslessRotate180;
begin
  FImage.Lossless.Rotate180;
end;

procedure TsdJpegGraphic.LosslessRotate270;
begin
  FImage.Lossless.Rotate270;
end;

initialization

  TPicture.RegisterFileFormat('jpg', 'Jpeg file', TsdJpegGraphic);

finalization

  TPicture.UnregisterGraphicClass(TsdJpegGraphic);

end.

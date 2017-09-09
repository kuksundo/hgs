{
  Unit dtpRasterGIF

  Adds GIF support to the dtpRaster class. Note: please read the instructions
  in the GifImage subfolder's README.TXT carefully. There are patent issues
  related to the use of GIF, you might need to be required to get a license
  from Unisys before distributing this product with GIF support!

  Project: DTP-Engine

  Creation Date: 22-01-2004 (NH)
  Version: See "changes.txt"

  Modifications:

  Copyright (c) 2003-2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpRasterGIF;

{$i simdesign.inc}

interface

uses
  GifImage, // Anders Melander's TGifImage
  Windows, Classes, dtpGraphics, Graphics, dtpRasterFormats;

type

  // Reader and writer for the GIF raster format
  TdtpGifFormat = class(TdtpRaster)
  private
    FAlphaTreshold: byte;
    FBackColor: TColor;
  public
    constructor Create; override;
    procedure LoadImageFromStream(S: TStream; ADIB: TdtpBitmap;
      AMaxSize: TPoint; Page: integer); override;
    // Save the image in GIF format. Please note that there may be a quality loss,
    // because GIF can only have 256 colors, and can only have either full transparency
    // or full opaqueness (Alpha = 0 or Alpha = 255). See AlphaTreshold for more info.
    procedure SaveImageToStream(S: TStream; ADIB: TdtpBitmap); override;
    // GIF only supports 0 or 255 for transparency (Alpha) setting. All values lower
    // than AlphaTreshold are considered fully transparent, all values equal or
    // above AlphaTreshold are considered fully opaque.
    property AlphaTreshold: byte read FAlphaTreshold write FAlphaTreshold;
    // Color to use for transparent when showing up in non-transparent browser
    property BackColor: TColor read FBackColor write FBackColor;
  end;

implementation

type
  TGraphicAccess = class(TGraphic);

{ TdtpGifFormat }

constructor TdtpGifFormat.Create;
begin
  inherited;
  // Defaults
  FAlphaTreshold := $20;
  FBackColor     := clBlack;
end;

procedure TdtpGifFormat.LoadImageFromStream(S: TStream; ADIB: TdtpBitmap;
  AMaxSize: TPoint; Page: integer);
var
  i: integer;
  AGif: TGifImage;
  Canvas: TCanvas;
  P: PdtpColor;
begin
  // To do: check multipage support in GIF
  if Page > 0 then
    raise ERasterError.Create(sreIllegalPageNumber);

  AGif := TGifImage.Create;
  try
    AGif.LoadFromStream(S);

    // We now *draw* the gif to our bitmap.. this will clear alpha in places
    // where drawn.. so we can use it later
    ADib.SetSize(AGif.Width, AGif.Height);
    ADib.Clear(clBlack32);
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := ADib.Handle;
      TGraphicAccess(AGif).Draw(Canvas, Rect(0, 0, ADib.Width, ADib.Height));
    finally
      Canvas.Free;
    end;

    // Flip the alpha channel
    P := @ADib.Bits[0];
    for i := 0 to ADib.Width * ADib.Height - 1 do
    begin
      P^ := P^ XOR $FF000000;
      inc(P);
    end;

  finally
    AGif.Free;
  end;
end;

procedure TdtpGifFormat.SaveImageToStream(S: TStream; ADIB: TdtpBitmap);
// Convert a 32bits DIB into a GIF file. Note that GIF only supports 0 or 255 for
// transparency (Alpha) setting. All values lower than AlphaTreshold are considered
// fully transparent, all values equal or above AlphaTreshold are considered fully
// opaque.

// Thanks to Jens Weiermann for posting the base of this code in the graphics32 newsgroup

var
  i: integer;
  ABmp: TBitmap;
  AGif: TGifImage;
  ColorUsage: array[0..255] of integer;
  MinUsage: integer;
  TrnIndex: integer;
  P: PChar;
  P32: PdtpColor;
  HasTransparency: boolean;
  GCE: TGifGraphicControlExtension;
begin
  // Create a bitmap from the bitmap32 and assign that to the gif
  ABmp := TBitmap.Create;
  try
    ABmp.Handle := ADIB.BitmapHandle;

    AGif := TGifImage.Create;
    AGif.ColorReduction  := rmQuantize;
    AGif.DitherMode      := dmFloydSteinberg;

    AGif.Assign(ABmp);
  finally
    ABmp.Free;
  end;

  // Initialize the ColorUsage array
  for i := 0 to 255 do
    ColorUsage[i] := 0;

  // Count the used colors
  P := AGif.Images[0].Data;
  for i := 0 to AGif.Images[0].DataSize-1 do
  begin
    inc(ColorUsage[byte(P^)]) ;
    inc(P);
  end;

  // See if there's any unused color or (if not) use the least often used index
  MinUsage := -1;
  TrnIndex := -1;
  for i := 0 to 255 do
  begin
    if ColorUsage[i] = 0 then
    begin
      TrnIndex := i;
      break;
    end else if ColorUsage[i] < MinUsage then
    begin
      TrnIndex := i;
      MinUsage := ColorUsage[i];
    end;
  end;

  // IMPORTANT: Dispose the bitmap representation, won't work otherwise!
  AGif.Images[0].HasBitmap := false;

  // If there is an unused color, change the transparent pixels to that color
  HasTransparency := false;
  P := AGif.Images[0].Data;
  P32 := PdtpColor(ADib.PixelPtr[0, 0]);
  for i := 0 to AGif.Images[0].DataSize-1 do
  begin
    if P32^ shr 24 < AlphaTreshold then
    begin
      P^ := Char(TrnIndex);
      HasTransparency := true;
    end;
    inc(P);
    inc(P32);
  end;

  // Create a GraphicControlExtension and specify the transparency index
  if HasTransparency then
  begin
    GCE := TGifGraphicControlExtension.Create(AGif.images[0]);
    GCE.TransparentColorIndex := trnIndex;
    GCE.Transparent := true;
    AGif.Images[0].Extensions.Add(GCE);

    AGif.Images[0].ActiveColorMap[TrnIndex] := FBackColor;
  end;

  // Save to the stream
  AGif.SaveToStream(S);

end;

initialization

  RegisterRasterClass(TdtpGifFormat, 'Compuserve GIF', '.gif;',
    [ofLoadStream, ofLoadFile, ofSaveStream, ofSaveFile, ofMultiPage, ofHasAlpha, ofComment]);

end.

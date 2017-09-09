unit pgRasterGif;
{
  unit pgRasterGif provides class TpgRasterGif for loading GIF images.

  It uses TGifImage from Anders Melander

  Creation Date:
  04Jun2005

  Modifications:

  Author: Nils Haeck
  Copyright (c) 2006 by SimDesign B.V.

}

interface

uses
  Classes, Graphics, pgRaster, pgRasterBmp, pgBitmap, pgWinGDI, Pyro;

type

  TpgRasterGif = class(TpgRasterFormat)
  public
    procedure LoadFromStream(S: TStream; AMap: TpgColorMap); override;
    procedure SaveToStream(S: TStream; AMap: TpgColorMap); override;
  end;

implementation

uses
  GifImage;

type
  TGraphicAccess = class(TGraphic);

{ TpgRasterGif }

procedure TpgRasterGif.LoadFromStream(S: TStream; AMap: TpgColorMap);
var
  AGif: TGifImage;
  ABmp: TBitmap;
begin
  AGif := TGifImage.Create;
  ABmp := TBitmap.Create;
  ABmp.PixelFormat := pf32bit;
  try
    AGif.LoadFromStream(S);

    // We now *draw* the gif to our bitmap.. this will clear alpha in places
    // where drawn.. so we can use it later
    ABmp.Width := AGif.Width;
    ABmp.Height := AGif.Height;
    ClearGDIBitmap(ABmp, $FF000000);
    TGraphicAccess(AGif).Draw(ABmp.Canvas, Rect(0, 0, ABmp.Width, ABmp.Height));

    // Flip the alpha channel
    FlipGDIBitmapAlpha(ABmp);
    ConvertBmpToMap(ABmp, AMap);

  finally
    AGif.Free;
    ABmp.Free;
  end;
end;

procedure TpgRasterGif.SaveToStream(S: TStream; AMap: TpgColorMap);
// Convert a 32bits DIB into a GIF file. Note that GIF only supports 0 or 255 for
// transparency (Alpha) setting. All values lower than AlphaTreshold are considered
// fully transparent, all values equal or above AlphaTreshold are considered fully
// opaque.

// Thanks to Jens Weiermann for posting the base of this code in the graphics32 newsgroup

var
  i, x, y: integer;
  ABmp: TBitmap;
  AGif: TGifImage;
  ColorUsage: array[0..255] of integer;
  MinUsage: integer;
  TrnIndex: integer;
  P: Pbyte;
  P32: PpgColor32;
  HasTransparency: boolean;
  GCE: TGifGraphicControlExtension;
begin
  // Create a bitmap from the bitmap32 and assign that to the gif
  ABmp := TBitmap.Create;
  AGif := TGifImage.Create;
  try
    ConvertMapToBmp(AMap, ABmp);

    AGif.ColorReduction  := rmQuantize;
    AGif.DitherMode      := dmFloydSteinberg;

    AGif.Assign(ABmp);

    // AGif.Assign seems to change our bmp to pf24bit! We must again convert
    ConvertMapToBmp(AMap, ABmp);

    if AGif.Images[0].DataSize <> ABmp.Width * ABmp.Height then
      exit;

    // Initialize the ColorUsage array
    FillChar(ColorUsage, SizeOf(ColorUsage), 0);

    // Count the used colors
    P := Pbyte(AGif.Images[0].Data);
    for i := 0 to AGif.Images[0].DataSize-1 do begin
      inc(ColorUsage[P^]) ;
      inc(P);
    end;

    // See if there's any unused color or (if not) use the least often used index
    MinUsage := MaxInt;
    TrnIndex := 0;
    for i := 0 to 255 do begin
      if ColorUsage[i] = 0 then begin
        TrnIndex := i;
        break;
      end else if ColorUsage[i] < MinUsage then begin
        TrnIndex := i;
        MinUsage := ColorUsage[i];
      end;
    end;

    // IMPORTANT: Dispose the bitmap representation, won't work otherwise!
    AGif.Images[0].HasBitmap := false;

    // If there is an unused color, change the transparent pixels to that color
    HasTransparency := false;
    P := Pbyte(AGif.Images[0].Data);
    for y := 0 to ABmp.Height - 1 do begin
      P32 := ABmp.ScanLine[y];
      for x := 0 to ABmp.Width - 1 do begin
        if P32^ shr 24 < AlphaThreshold then begin
          P^ := TrnIndex;
          HasTransparency := true;
        end;
        inc(P);
        inc(P32);
      end;
    end;

    // Create a GraphicControlExtension and specify the transparency index
    if HasTransparency then begin
      GCE := TGifGraphicControlExtension.Create(AGif.images[0]);
      GCE.TransparentColorIndex := trnIndex;
      GCE.Transparent := true;
      AGif.Images[0].Extensions.Add(GCE);
      AGif.Images[0].ActiveColorMap[TrnIndex] := clGray;
    end;

    // Save to the stream
    AGif.SaveToStream(S);

  finally
    ABmp.Free;
    AGif.Free;
  end;
end;

initialization

  RegisterRasterFormat(TpgRasterGif, crfGIF, 'image/gif;');

end.

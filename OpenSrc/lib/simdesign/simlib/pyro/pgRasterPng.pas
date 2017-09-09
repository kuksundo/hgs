{
  Unit pgRasterPNG

  Adds PNG support to the pgRaster class. Note: please read the instructions
  in the PngImage subfolder's README.TXT carefully.

  Project: Pyro

  Creation Date: 22-01-2004 (NH)

  Modifications:
  10 Oct 2005: Fixed handling of alpha (avoids premultiplied alpha RGB values)
  29 Oct 2005: Added custom pixel formats

  Copyright (c) 2003-2005 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit pgRasterPng;

interface

uses
  SysUtils,
  GR32, GR32_Png, // PNG component of Christian W. Budde
  Graphics, Classes, pgRaster, pgRasterBmp, pgBitmap, pgColor, pgGraphics32, Pyro;

type

  // Reader and writer for the PNG raster format
  TpgRasterPng = class(TpgRasterFormat)
  public
    procedure LoadFromStream(S: TStream; AMap: TpgColorMap); override;
    procedure SaveToStream(S: TStream; AMap: TpgColorMap); override;
  end;

implementation

type
  TMapAccess = class(TpgColorMap);

{ TpgRasterPng }

procedure TpgRasterPng.LoadFromStream(S: TStream; AMap: TpgColorMap);
var
  Png: TPortableNetworkGraphic32;
  Bitmap32: TBitmap32;
begin
  Png := TPortableNetworkGraphic32.Create;
  try
    // Load the PNG from the stream
    Png.LoadFromStream(S);

    Bitmap32 := TBitmap32.Create;
    try
      // Use PNG's AssignTo to get a device independent bitmap
      Bitmap32.Assign(Png);
      ConvertBitmap32ToMap(Bitmap32, AMap);
    finally
      Bitmap32.Free;
    end;

  finally
    Png.Free;
  end;
end;

procedure TpgRasterPng.SaveToStream(S: TStream; AMap: TpgColorMap);
type
  PByte = ^byte;
var
  ABitmap32: TBitmap32;
  APng: TPortableNetworkGraphic32;
begin
  ABitmap32 := TBitmap32.Create;
  APng := TPortableNetworkGraphic32.Create;
  try
    // Create a 24bit/32bit intermediate bitmap
    ConvertMapToBitmap32(AMap, ABitmap32);

    // Assign it to the PNG image
    APng.Assign(ABitmap32);

    // Now save to stream with maximum compression
    APng.CompressionLevel := 9;
    APng.SaveToStream(S);

  finally
    ABitmap32.Free;
    APng.Free;
  end;
end;

initialization

  RegisterRasterFormat(TpgRasterPng, crfPng, 'image/png');

end.

{
  Unit dtpRasterPNG

  Adds PNG support to the dtpRaster class, using CWBudde's GR32_PNG.

  Project: DTP-Engine

  Creation Date: 22-01-2004 (NH)

  Modifications:
  01jun2011: updated to use CWBudde's GR32_PNG

  Copyright (c) 2003-2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpRasterPNG;

{$i simdesign.inc}

interface

uses
  SysUtils,
  GR32_Png, // PNG component of Christian W. Budde
  Windows, Classes, dtpGraphics, Graphics, dtpRasterFormats;

type

  // Reader and writer for the PNG raster format
  TdtpPngFormat = class(TdtpRaster)
  public
    procedure LoadImageFromStream(S: TStream; ADIB: TdtpBitmap;
      AMaxSize: TPoint; Page: integer); override;
    procedure SaveImageToStream(S: TStream; ADIB: TdtpBitmap); override;
  end;

resourcestring
  sPngUnsupportedPixelFormat = 'Unsupported pixel format in PNG';

implementation

{ TdtpPNGFormat }

procedure TdtpPngFormat.LoadImageFromStream(S: TStream; ADIB: TdtpBitmap;
  AMaxSize: TPoint; Page: integer);
var
  Png: TPortableNetworkGraphic32;
begin
  Png := TPortableNetworkGraphic32.Create;
  try
    Png.LoadFromStream(S);
    ADIB.Assign(Png);
  finally
    Png.Free;
  end;
end;

procedure TdtpPngFormat.SaveImageToStream(S: TStream; ADIB: TdtpBitmap);
var
  Png: TPortableNetworkGraphic32;
begin
  Png := TPortableNetworkGraphic32.Create;
  try
    Png.Assign(ADIB);
    Png.SaveToStream(S);
  finally
    Png.Free;
  end;
end;

initialization

  RegisterRasterClass(TdtpPngFormat, 'Portable Network Graphics', '.png;',
    [ofLoadStream, ofLoadFile, ofSaveStream, ofSaveFile, ofHasAlpha]);

// CWBudde's PNG is not compatible with the Graphics class and image preview
//  TPicture.RegisterFileFormat('png', 'Png file', TdtpPngFormat);

finalization

//  TPicture.UnregisterGraphicClass(TdtpPngFormat);

end.

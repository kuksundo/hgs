unit pgRasterJpg;
{
  unit pgRasterJpg provides class TpgRasterJpg for loading Jpeg images.

  Creation Date:
  02Jun2005

  Modifications:

  Author: Nils Haeck
  Copyright (c) 2005 by SimDesign B.V.

}

interface

uses
  Classes, Graphics, NativeJpg, pgRaster, pgWinGDI, pgBitmap;

type

  // TpgRasterJpg now uses the NativeJpg lib of Simdesign
  TpgRasterJpg = class(TpgRasterFormat)
  public
    procedure LoadFromStream(S: TStream; AMap: TpgColorMap); override;
    procedure SaveToStream(S: TStream; AMap: TpgColorMap); override;
  end;

implementation

{ TpgRasterJpg }

procedure TpgRasterJpg.LoadFromStream(S: TStream; AMap: TpgColorMap);
var
  Jpg: TsdJpegGraphic;
  Bmp: TBitmap;
begin
  Jpg := TsdJpegGraphic.Create;
  Bmp := TBitmap.Create;
  try
    Jpg.LoadFromStream(S);
    Bmp.Assign(Jpg);
    ConvertBmpToMap(Bmp, AMap);
  finally
    Bmp.Free;
    Jpg.Free;
  end;
end;

procedure TpgRasterJpg.SaveToStream(S: TStream; AMap: TpgColorMap);
var
  Jpg: TsdJpegGraphic;
  Bmp: TBitmap;
begin
  Jpg := TsdJpegGraphic.Create;
  Bmp := TBitmap.Create;
  try
    ConvertMapToBmp(AMap, Bmp);
    Jpg.CompressionQuality := SaveQuality;
    Jpg.Assign(Bmp);
    Jpg.SaveToStream(S);
    ConvertBmpToMap(Bmp, AMap);
  finally
    Bmp.Free;
    Jpg.Free;
  end;
end;

initialization

  RegisterRasterFormat(TpgRasterJpg, crfJPG, 'image/jpg;image/jpeg');

end.

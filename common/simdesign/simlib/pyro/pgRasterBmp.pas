unit pgRasterBmp;
{
  unit pgRasterBmp provides class TpgRasterBmp for loading Windows BMP images.

  Creation Date:
  02Jun2005

  Modifications:

  Author: Nils Haeck
  Copyright (c) 2005 by SimDesign B.V.

}

interface

{$i simdesign.inc}

uses
  Classes, SysUtils, Graphics,
  pgRaster, pgBitmap, Pyro, pgColor, pgWinGDI;

type

  TpgRasterBmp = class(TpgRasterFormat)
  public
    procedure LoadFromStream(S: TStream; AMap: TpgColorMap); override;
    procedure SaveToStream(S: TStream; AMap: TpgColorMap); override;
  end;

implementation

{ TpgRasterBmp }

procedure TpgRasterBmp.LoadFromStream(S: TStream; AMap: TpgColorMap);
var
  ABmp: TBitmap;
begin
  ABmp := TBitmap.Create;
  try
    ABmp.LoadFromStream(S);
    ConvertBmpToMap(ABmp, AMap);
  finally
    ABmp.Free;
  end;
end;

procedure TpgRasterBmp.SaveToStream(S: TStream; AMap: TpgColorMap);
var
  ABmp: TBitmap;
begin
  ABmp := TBitmap.Create;
  try
    ConvertMapToBmp(AMap, ABmp);
    ABmp.SaveToStream(S);
  finally
    ABmp.Free;
  end;
end;

initialization

  RegisterRasterFormat(TpgRasterBmp, crfBitmap, 'image/bmp');

end.

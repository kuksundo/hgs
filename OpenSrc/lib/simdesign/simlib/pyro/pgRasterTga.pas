{
  unit pgRasterTga provides class TpgRasterTga for loading Targa images.

  In order to do this, this unit uses GraphicEx (by Mike Lischke). Please note
  the license requirements for GraphicEx.

  Creation Date:
  04Jun2005

  Modifications:

  Author: Nils Haeck
  Copyright (c) 2005 by SimDesign B.V.

}
unit pgRasterTga;

interface

uses
  Classes, Graphics, pgRaster, pgRasterBmp, pgMap;

type

  TpgRasterTga = class(TpgRasterFormat)
  public
    procedure LoadFromStream(S: TStream; AMap: TpgColorMap); override;
  end;

implementation

uses
  GraphicEx, pgWinGDI;

{ TpgRasterTga }

procedure TpgRasterTga.LoadFromStream(S: TStream; AMap: TpgColorMap);
var
  ATga: TTargaGraphic;
begin
  ATga := TTargaGraphic.Create;
  try
    ATga.LoadFromStream(S);
    ConvertBmpToMap(ATga, AMap);
  finally
    ATga.Free;
  end;
end;

initialization

  RegisterRasterFormat(TpgRasterTga, crfTGA, 'image/tga;');

end.

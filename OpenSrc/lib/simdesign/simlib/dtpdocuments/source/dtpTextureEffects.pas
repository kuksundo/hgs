{ Unit dtpTextureEffects

  This unit implements the texture effect.

  Project: DTP-Engine

  Creation Date: 23-Sep-2004

  Modifications:

  Copyright (c) 2004 - 2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpTextureEffects;

{$i simdesign.inc}

interface

uses

  Classes, SysUtils, dtpShape, dtpEffectShape, dtpGradientEffects, dtpBitmapResource,
  dtpDefaults, dtpUtil, dtpGraphics, NativeXmlOld, Math;

type

  // TdtpTextureEffect is a TdtpReplacementEffect descendant that implements
  // replacement of a primary color with a texture bitmap. The bitmap can be
  // Tiled or stretched.
  TdtpTextureEffect = class(TdtpReplacementEffect)
  private
    FOffsetX: single;
    FOffsetY: single;
    FRenderDpm: single;
    FTexture: TdtpBitmapResource;
    FTiled: boolean;
    procedure SetOffsetX(const Value: single);
    procedure SetOffsetY(const Value: single);
    procedure SetRenderDpm(const Value: single);
    procedure TextureAfterLoadFromFile(Sender: TObject);
    procedure SetTiled(const Value: boolean);
  protected
    procedure PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    // RenderDpm specifies the number of dots per mm used by the texture when
    // the texture is drawn in Tiled mode. The higher this number, the smaller
    // the texture will appear.
    property RenderDpm: single read FRenderDpm write SetRenderDpm;
    // OffsetX defines the offset in X direction in mm when in Tiled mode. With
    // this setting, the appearance of the texture can be finetuned.
    property OffsetX: single read FOffsetX write SetOffsetX;
    // OffsetY defines the offset in Y direction in mm when in Tiled mode. With
    // this setting, the appearance of the texture can be finetuned.
    property OffsetY: single read FOffsetY write SetOffsetY;
    // When Tiled = True (default), the texture will tile, this means, repeat
    // endlessly. When Tiled is set to False, the texture will be stretched so that
    // it just fits the size of the shape.
    property Tiled: boolean read FTiled write SetTiled;
    // Texture specifies a bitmap resource (TdtpBitmapResource) which holds the
    // bitmap for the texture. You can load a texture with Texture.LoadFromFile,
    // or assign a bitmap directly with Texture.Bitmap := MyBitmap.
    property Texture: TdtpBitmapResource read FTexture;
  end;

implementation

{ TdtpTextureEffect }

constructor TdtpTextureEffect.Create;
begin
  inherited;
  // We create the resource, without an owner. The owner is set in SetParent
  FTexture := TdtpBitmapResource.Create;
  FTexture.OnAfterLoadFromFile := TextureAfterLoadFromFile;
  // Defaults
  FRenderDpm := cLowPrinterDpm;
  FTiled := True;
end;

destructor TdtpTextureEffect.Destroy;
begin
  FreeAndNil(FTexture);
  inherited;
end;

procedure TdtpTextureEffect.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FOffsetX := ANode.ReadFloat('OffsetX');
  FOffsetY := ANode.ReadFloat('OffsetY');
  FRenderDpm := ANode.ReadFloat('RenderDpm');
  FTiled := ANode.ReadBool('Tiled');
  FTexture.LoadFromXml(ANode.NodeByName('Texture'));
end;

procedure TdtpTextureEffect.PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext);
// Create texture bitmap and merge with cache
var
  TileBmp, SourceBmp: TdtpBitmap;
  TileWidth, TileHeight, TileX, TileY, x, y: integer;
  P, Q: PdtpColor;
  Color: TdtpColor;
  Alpha, Cover: integer;
begin
  SourceBmp := GetSourceDIB(DIB);
  // checks
  if not (assigned(SourceBmp) and assigned(Texture.Bitmap) and assigned(Parent)) then
    exit;

  // Tile size
  if Tiled then
  begin
    TileWidth  := round(Texture.Bitmap.Width  * Device.ActualDpm / FRenderDpm);
    TileHeight := round(Texture.Bitmap.Height * Device.ActualDpm / FRenderDpm);
    // Tile origin
    TileX := -round((Parent.CurbLeft + OffsetX) * Device.ActualDpm);
    TileY := -round((Parent.CurbTop  + OffsetY) * Device.ActualDpm);
  end else
  begin
    TileWidth  := round(Parent.DocWidth  * Device.ActualDpm);
    TileHeight := round(Parent.DocHeight * Device.ActualDpm);
    // Tile origin
    TileX := -round(Parent.CurbLeft * Device.ActualDpm);
    TileY := -round(Parent.CurbTop  * Device.ActualDpm);
  end;
  // Make sure factor to add is positive
  while TileX < 0 do
    inc(TileX, TileWidth);
  while TileY < 0 do
    inc(TileY, TileHeight);


  TileBmp := TdtpBitmap.Create;
  try
    // Construct tile
    TileBmp.Width  := TileWidth;
    TileBmp.Height := TileHeight;

    // Stretch our tile image to it
    SetStretchFilter(TileBmp, Device.Quality);
    StretchTransfer(
      TileBmp, TileBmp.BoundsRect, TileBmp.BoundsRect,
      Texture.Bitmap, Texture.Bitmap.BoundsRect,
      TileBmp.Resampler, dtpdmOpaque, nil);

    // Now we can selectively replace
    P := @SourceBmp.Bits[0];
    Q := @Dib.Bits[0];
    // Loop through source
    for y := 0 to SourceBmp.Height - 1 do
      for x := 0 to SourceBmp.Width - 1 do
      begin
        // We use any bits that have the color
        ReplacementAlphaAndCover(P^, Alpha, Cover);
        if (Alpha <> 0) and (Cover <> 0) then
        begin
          // Either the alpha (usually) or color channel works as limiter
          Color := TileBmp[(x + TileX) mod TileWidth, (y + TileY) mod TileHeight];

          // Set the texture color
          if Cover = $FF then
            Q^ := SetAlpha(Color, (Alpha * AlphaComponent(Color)) div 255)
          else
          begin
            Q^ := SetAlpha(Merge(Color, Q^, Cover),
             (Alpha * AlphaComponent(Color)) div 255)
          end;

        end;
        inc(P); inc(Q);
      end;
  finally
    TileBmp.Free;
  end;
end;

procedure TdtpTextureEffect.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteFloat('OffsetX', FOffsetX);
  ANode.WriteFloat('OffsetY', FOffsetY);
  ANode.WriteFloat('RenderDpm', FRenderDpm);
  ANode.WriteBool('Tiled', FTiled);
  FTexture.SaveToXml(ANode.NodeNew('Texture'));
end;

procedure TdtpTextureEffect.SetOffsetX(const Value: single);
begin
  if FOffsetX <> Value then begin
    FOffsetX := Value;
    Changed;
  end;
end;

procedure TdtpTextureEffect.SetOffsetY(const Value: single);
begin
  if FOffsetY <> Value then begin
    FOffsetY := Value;
    Changed;
  end;
end;

procedure TdtpTextureEffect.SetRenderDpm(const Value: single);
begin
  if FRenderDpm <> Value then begin
    FRenderDpm := Value;
    Changed;
  end;
end;

procedure TdtpTextureEffect.SetTiled(const Value: boolean);
begin
  if FTiled <> Value then begin
    FTiled := Value;
    Changed;
  end;
end;

procedure TdtpTextureEffect.TextureAfterLoadFromFile(Sender: TObject);
begin
  // This event method is called after the texture loaded from a stream
  Changed;
end;

initialization

  RegisterEffectClass(TdtpTextureEffect);

end.

{
  Unit dtpFrameEffects

  Implements the frame effect. A frame has a width, a spacing and a color.
  The interior can be filled with FillColor and can have a transparency.

  FrameRadius > 0 will create a frame with rounded corners

  Project: DTP-Engine

  Creation Date: 05-11-2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003-2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpFrameEffects;

{$i simdesign.inc}

interface

uses
  dtpShape, dtpEffectShape, Graphics, dtpGraphics, Math, dtpUtil, NativeXmlOld;

type

  // This "effect" draws a frame around any shape to which this effect is added. 
  TdtpFrameEffect = class(TdtpEffect)
  private
    FFillAlpha: Cardinal;  // If 0, shape remains transparent. if 255, shape is filled with FillColor
    FFillColor: TColor;    // Fill color (if FillAlpha>0, defaults to clWhite)
    FFrameWidth: single;   // Line width of frame border
    FFrameRadius: single;  // The radius of the frame for rounded rects (Radius=0 by default)
    FFrameSpacing: single; // Distance between frame border and shape
    FFrameColor: TColor;   // Frame border color
    procedure SetFillAlpha(const Value: Cardinal);
    procedure SetFillColor(const Value: TColor);
    procedure SetFrameColor(const Value: TColor);
    procedure SetFrameSpacing(const Value: single);
    procedure SetFrameWidth(const Value: single);
    procedure SetFrameRadius(const Value: single);
  protected
    procedure PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext); override;
    procedure ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single); override;
  public
    constructor Create; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property FillAlpha: Cardinal read FFillAlpha write SetFillAlpha;
    property FillColor: TColor read FFillColor write SetFillColor;
    property FrameColor: TColor read FFrameColor write SetFrameColor;
    property FrameSpacing: single read FFrameSpacing write SetFrameSpacing;
    property FrameWidth: single read FFrameWidth write SetFrameWidth;
    property FrameRadius: single read FFrameRadius write SetFrameRadius;
  end;

implementation

uses
  dtpPolygonShape;

{ TdtpFrameEffect }

constructor TdtpFrameEffect.Create;
begin
  inherited;
  //Defaults
  FFillAlpha    := 255;
  FFillColor    := clWhite;
  FFrameWidth   := 1;
  FFrameSpacing := 2;
  FFrameColor   := clBlack;
  FFrameRadius  := 0;
end;

procedure TdtpFrameEffect.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FFillAlpha    := ANode.ReadInteger('FillAlpha');
  FFillColor    := ANode.ReadColor('FillColor');
  FFrameWidth   := ANode.ReadFloat('FrameWidth');
  FFrameSpacing := ANode.ReadFloat('FrameSpacing');
  FFrameRadius  := ANode.ReadFloat('FrameRadius');
  FFrameColor   := ANode.ReadColor('FrameColor');
end;

procedure TdtpFrameEffect.PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext);
var
  FPoints: ArrayOfArrayOfFPoint;
  FRadius: single;
  FFixedFill, FFixedOutline: TdtpPolygon;
  AFrame: TdtpBitmap;
begin
  AFrame := TdtpBitmap.Create;
  try
    AFrame.SetSize(DIB.Width, DIB.Height);
    SetCombineMode(AFrame, dtpcmMerge);

    // Create a frame polygon
    SetLength(FPoints, 1);
    with Parent do
    begin
      FRadius := Min(Min(DocWidth, DocHeight) / 2, FrameRadius);
      if FRadius = 0 then
        PolyDrawRect(FPoints, -FrameSpacing, -FrameSpacing,
          DocWidth + 2 * FrameSpacing, DocHeight + 2 * FrameSpacing)
      else
        PolyDrawRoundedRect(FPoints, -FrameSpacing, -FrameSpacing,
          DocWidth + 2 * FrameSpacing, DocHeight + 2 * FrameSpacing,
          FRadius, FRadius, Transform.Matrix.A);

      // Convert to fixed
      try
        FloatToFixedPolygons(FPoints, Transform.Matrix, FFixedFill, FFixedOutline, FrameWidth > 0, True, FrameWidth);

        // Draw it
        if (FFillAlpha > 0) then
          FFixedFill.DrawFill(AFrame, SetAlpha(dtpColor(FFillColor), FillAlpha));

        if FrameWidth = 0 then
          FFixedFill.DrawEdge(AFrame, dtpColor(FFrameColor))
        else
          FFixedOutline.DrawFill(AFrame, dtpColor(FFrameColor));

      finally
        // free the created fill and possibly created outline polygons now
        // that they are drawn
        FFixedFill.Free;
        FFixedOutline.Free;
      end;
    end;

    // Merge layers
    MergeLayers(DIB, AFrame);

  finally
    AFrame.Free;
  end;
end;

procedure TdtpFrameEffect.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteInteger('FillAlpha', FFillAlpha);
  ANode.WriteColor('FillColor', FFillColor);
  ANode.WriteFloat('FrameWidth', FFrameWidth);
  ANode.WriteFloat('FrameSpacing', FFrameSpacing);
  ANode.WriteFloat('FrameRadius', FFrameRadius);
  ANode.WriteColor('FrameColor', FFrameColor);
end;

procedure TdtpFrameEffect.SetFillAlpha(const Value: Cardinal);
begin
  if FFillAlpha <> Value then
  begin
    FFillAlpha := Value;
    Changed;
  end;
end;

procedure TdtpFrameEffect.SetFillColor(const Value: TColor);
begin
  if FFillColor <> Value then
  begin
    FFillColor := Value;
    Changed;
  end;
end;

procedure TdtpFrameEffect.SetFrameColor(const Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Changed;
  end;
end;

procedure TdtpFrameEffect.SetFrameRadius(const Value: single);
begin
  if FFrameRadius <> Value then
  begin
    FFrameRadius := Value;
    Changed;
  end;
end;

procedure TdtpFrameEffect.SetFrameSpacing(const Value: single);
begin
  if FFrameSpacing <> Value then
  begin
    Invalidate;
    FFrameSpacing := Value;
    Changed;
  end;
end;

procedure TdtpFrameEffect.SetFrameWidth(const Value: single);
begin
  if FFrameWidth <> Value then
  begin
    Invalidate;
    FFrameWidth := Value;
    Changed;
  end;
end;

procedure TdtpFrameEffect.ValidateCurbSizes(var CurbLeft, CurbTop,
  CurbRight, CurbBottom: single);
var
  AMargin: single;
begin
  AMargin := Max(FrameWidth + FrameSpacing + 0.5, 0);
  CurbLeft   := Max(CurbLeft, AMargin);
  CurbRight  := Max(CurbRight, AMargin);
  CurbTop    := Max(CurbTop, AMargin);
  CurbBottom := Max(CurbBottom, AMargin);
end;

initialization

  RegisterEffectClass(TdtpFrameEffect);

end.

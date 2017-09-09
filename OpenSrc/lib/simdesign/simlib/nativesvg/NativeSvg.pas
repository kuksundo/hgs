{
  Description:
  TsdSvgImage is the SVG image (Scalable Vector Graphics) using the Pyro document object model.
  Pyro's scene definition and object model is already SVG oriented.

  TsdSvgGraphic is the Delphi TGraphic compatible component that can
  render the SVG content and write to a TBitmap.

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2012 SimDesign BV
}
unit NativeSvg;

interface

uses
  // Windows provides TRect and TBitmap
  //Windows,

  // delphi
  Classes, SysUtils, Graphics,

  // NativeXml component
  NativeXml,

  // NativeJpg component
  //NativeJpg,
  sdColorTransforms,

  // general, svg and pyro
  sdStreams, sdMapIterator, {sdBitmapConversionWin,} sdBitmapResize,
  pgScene, Pyro;

type

  TsdSvgImage = class; // fwd declaration

  // Implementation of TGraphic that renders SVG onto a bitmap
  TsdSvgGraphic = class(TGraphic)
  private
    FSvgImage: TsdSvgImage;
    FBitmap: TBitmap;
    FBackgroundColor: TColor;
    FOnDebugOut: TsdDebugEvent;
  protected
    function GetVersion: string;
    // Assign this TsdSvgGraphic to Dest. The only valid type for Dest is TBitmap.
    // The bitmap in TsdSvgGraphic will be copied and color-converted to the bitmap in Dest.
    procedure AssignTo(Dest: TPersistent); override;
    // Draw the SVG graphic to the canvas, this routine uses the Windows function
    // AlphaBlend to blend the graphic to the canvas background.
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
  public
    // Assign Source to us, if it is a TsdSvgGraphic
    procedure Assign(Source: TPersistent); override;
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;
    // Since SVG graphics are often (semi) transparent, the background color
    // can be set for when a non-transparent bitmap is created.
    property BackgroundColor: TColor read FBackgroundColor write FBackgroundColor;
    // Windows TBitmap
    property Bitmap: TBitmap read FBitmap;
    // Version returns the current version of the Pyro library.
    property Version: string read GetVersion;
    // Reference to the internal TsdSvgImage
    property SvgImage: TsdSvgImage read FSvgImage;
    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
  end;

  TsdSvgImage = class(TDebugComponent)
  private
    //FOnDebugOut: TsdDebugEvent;
    FScene: TpgScene;
    FHeight: integer;
    FWidth: integer;
    FDPI: double;
    procedure SetDPI(const Value: double);
  protected
    procedure GetSize;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RenderToBitmap(ABitmap: TBitmap);
    procedure LoadFromStream(S: TStream);
    procedure SaveToStream(S: TStream);
    property Width: integer read FWidth;
    property Height: integer read FHeight;
    property DPI: double read FDPI write SetDPI;
    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
  end;

implementation

uses
  pgScalableVectorGraphics,
  pgRenderUsingCore,
  pgCanvasUsingPyro;

{ TsdSvgGraphic }

procedure TsdSvgGraphic.Assign(Source: TPersistent);
var
  Svg: TsdSvgGraphic;
begin
  if Source is TsdSvgGraphic then
  begin
    Svg := TsdSvgGraphic(Source);
    FBitmap.Assign(Svg.FBitmap);
  end else
    inherited;
end;

procedure TsdSvgGraphic.AssignTo(Dest: TPersistent);
var
  y: integer;
  Dst: TBitmap;
  SIter, DIter: TsdMapIterator;
  S, D: PByte;
  CT: TsdTransformBGRAToBGR;
begin
  if Dest is TBitmap then
  begin
    Dst := TBitmap(Dest);
    Dst.PixelFormat := pf24bit;
    DIter := TsdMapIterator.Create;
    SIter := TsdMapIterator.Create;
    try
      GetBitmapIterator(FBitmap, SIter);
      Dst.Width := FBitmap.Width;
      Dst.Height := FBitmap.Height;
      GetBitmapIterator(Dst, DIter);

      // Color transform that blends with a background color
      CT := TsdTransformBGRAToBGR.Create;
      CT.BkColor := FBackgroundColor;
      for y := 0 to DIter.Height - 1 do
      begin
        S := SIter.At(0, y);
        D := DIter.At(0, y);
        CT.Transform(S, D, DIter.Width);
      end;
      CT.Free;

    finally
      SIter.Free;
      DIter.Free;
    end;
  end else
    inherited
end;

constructor TsdSvgGraphic.Create;
begin
  inherited;
  FSvgImage := TsdSvgImage.Create(nil);
  FSvgImage.OnDebugOut := DoDebugOut;
  FBitmap := TBitmap.Create;
  FBackgroundColor := clWhite;
end;

destructor TsdSvgGraphic.Destroy;
begin
  FreeAndNil(FBitmap);
  FreeAndNil(FSvgImage);
  inherited;
end;

procedure TsdSvgGraphic.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  WReq, HReq, W, H: integer;
  Dest: TBitmap;
  BF: TBlendFunction;
begin
  // Determine correct scale
  WReq := Rect.Right - Rect.Left;
  HReq := Rect.Bottom - Rect.Top;
  W := GetWidth;
  H := GetHeight;

  // Blend function
  BF.BlendOp := AC_SRC_OVER;
  BF.BlendFlags := 0;
  BF.SourceConstantAlpha := $FF;
  BF.AlphaFormat := AC_SRC_ALPHA;

  if ((W = WReq) and (H = HReq)) or
     (W < WReq) or
     (H < HReq) then
  begin

    // Alpha-blended stretchdraw to canvas
    AlphaBlend(
      ACanvas.Handle, Rect.Left, Rect.Top, WReq, HReq,
      FBitmap.Canvas.Handle, 0, 0, W, H, BF);

  end else
  begin

    // Use a fast downsizing algo
    Dest := TBitmap.Create;
    try
      Dest.PixelFormat := pf32Bit;
      Dest.Width := WReq;
      Dest.Height := HReq;
      DownscaleBitmapWin(FBitmap, Dest);

      // Alphablended draw to canvas (since it's the right size now)
      AlphaBlend(
        ACanvas.Handle, Rect.Left, Rect.Top, WReq, HReq,
        Dest.Canvas.Handle, 0, 0, WReq, HReq, BF);
    finally
      Dest.Free;
    end;

  end;
end;

function TsdSvgGraphic.GetHeight: Integer;
begin
  Result := FBitmap.Height;
end;

function TsdSvgGraphic.GetVersion: string;
begin
  Result := cPyroVersion;
end;

function TsdSvgGraphic.GetWidth: Integer;
begin
  Result := FBitmap.Width;
end;

procedure TsdSvgGraphic.LoadFromClipboardFormat(AFormat: Word;
  AData: THandle; APalette: HPALETTE);
begin
  inherited;
//not implemented
end;

procedure TsdSvgGraphic.LoadFromStream(Stream: TStream);
var
  M: TsdFastMemStream;
begin
  inherited;

  M := TsdFastMemStream.Create;
  try

    // Load the svg into the scene
    M.LoadFromStream(Stream);
    M.Position := 0;
    FSvgImage.LoadFromStream(M);

    // Now get the bitmap
    FSvgImage.RenderToBitmap(FBitmap);

  finally
    M.Free;
  end;
end;

procedure TsdSvgGraphic.SaveToClipboardFormat(var AFormat: Word;
  var AData: THandle; var APalette: HPALETTE);
begin
  inherited;
//not implemented
end;

procedure TsdSvgGraphic.SaveToStream(Stream: TStream);
var
  M: TsdFastMemStream;
begin
  inherited;

  M := TsdFastMemStream.Create;
  try

    // save the svg stream
    FSvgImage.SaveToStream(M);
    M.Position := 0;
    M.SaveToStream(Stream);

  finally
    M.Free;
  end;
end;

procedure TsdSvgGraphic.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if assigned(FOnDebugOut) then
    FOnDebugOut(Sender, WarnStyle, AMessage);
end;

{ TsdSvgImage }

constructor TsdSvgImage.Create(AOwner: TComponent);
begin
  inherited;
  FScene := TpgScene.Create(Self);
  FDPI := 120;
end;

destructor TsdSvgImage.Destroy;
begin
  FreeAndNil(FScene);
  inherited;
end;

procedure TsdSvgImage.GetSize;
var
  DI: TpgDeviceInfo;
begin
  DI.DPI.X := FDPI;
  DI.DPI.Y := FDPI;

  FWidth  := round(FScene.ViewPort.Width.ToDevice(DI) + 0.5);
  FHeight := round(FScene.ViewPort.Height.ToDevice(DI) + 0.5);
end;

procedure TsdSvgImage.LoadFromStream(S: TStream);
var
  Import: TpgSvgImport;
begin
  // Create SVG Import class
  Import := TpgSvgImport.Create(Self);
  try

    // Import the scene into FScene. After this, the scene should have
    // a complete representation of the SVG file
    //FScene.Clear;
    FScene.XmlFormat := xfReadable;
    Import.ImportScene(FScene, S);

    // Get the size of the scene
    GetSize;

  finally
    Import.Free;
  end;
end;

procedure TsdSvgImage.RenderToBitmap(ABitmap: TBitmap);
var
  R: TpgRect;
  BC: TpgPyroBitmapCanvas;
  CR: TpgCoreRenderer;
begin
  BC := TpgPyroBitmapCanvas.Create;
  CR := TpgCoreRenderer.Create;
  try

    // Device info - we must set this to assure the SVG renderer can
    // calculate lengths.
    BC.DeviceInfo.DPI.X := FDPI;
    BC.DeviceInfo.DPI.Y := FDPI;

    // Device rectangle in pixels of this size
    R := pgRect(0, 0, FWidth, FHeight);
    BC.DeviceRect := R;

    // fill with black-transparent
    BC.FillDeviceRect(R, $00000000);

    // Render the scene viewport to the canvas
    CR.Render(BC, FScene.ViewPort, nil);

    ABitmap.Assign(BC.Bitmap);

  finally
    CR.Free;
    BC.Free;
  end;
end;

procedure TsdSvgImage.SaveToStream(S: TStream);
begin
  FScene.SaveToStream(S);
end;

procedure TsdSvgImage.SetDPI(const Value: double);
begin
  FDPI := Value;
  GetSize;
end;

initialization

  TPicture.RegisterFileFormat('svg', 'Scalable Vector Graphics', TsdSvgGraphic);

finalization

  TPicture.UnregisterGraphicClass(TsdSvgGraphic);

end.
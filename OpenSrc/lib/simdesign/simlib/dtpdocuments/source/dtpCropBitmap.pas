{
  Unit dtpCropBitmap

  TdtpCropBitmap is a TdtpSnapBitmap descendant that can be used to work
  with large images in screen resolution, thus saving resources.

  Project: DTP-Engine

  Creation Date: 18-10-2004 (NH)
  Version: 1.0

  Modifications:
  19Aug2005: Changed Lowres handling
  07Oct2005: Added highres image rendering during printing
  07Jun2010: Created abstraction with dtpGraphics.pas

  Copyright (c) 2004 - 2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpCropBitmap;

{$i simdesign.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dtpBitmapShape, dtpResource, dtpBitmapResource, dtpGraphics, dtpDocument, extDlgs,
  dtpRasterFormats, ExtCtrls, StdCtrls, dtpDefaults, NativeXml, dtpMaskEffects,
  dtpShape;

type

  // TdtpCropBitmap is a special bitmap shape that can be used in documents with
  // huge number of bitmaps (images). It stores a full-resolution bitmap in the
  // archive directly (in native format) and just keeps a local low resolution
  // copy. When doubleclicking on an empty bitmap, it displays a cropbox where
  // the original bitmap can be cropped to fit the size of the template. The
  // cropbox cannot be downsized further than a certain limit on resolution.
  // TdtpCropBitmap also implements a method to display a quality indicator on
  // the image (only in screen device mode), see OnDrawQualityIndicator.
  TdtpCropBitmap = class(TdtpSnapBitmap)
  private
    FCropRect: TRect;
    FLowresDPM: single;
    FLowresImage: TdtpBitmapResource;
    FAdaptAspectToImage: boolean;
    procedure CreateLowresImage;
    procedure DoDrawQualityIndicator(Canvas: TCanvas; var Rect: TRect; Quality: integer; var Drawn: boolean);
    function GetQuality: integer;
    function GetDefaultCropRect: TRect;
    procedure LowresImageChanged(Sender: TObject);
    procedure SetCropRect(const Value: TRect);
    function GetFullImageStorage: TdtpResourceStorage;
    procedure SetFullImageStorage(const Value: TdtpResourceStorage);
    procedure SetLowresDpm(const Value: single);
  protected
    procedure DoAfterPaste; override;
    procedure PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext); override;
    procedure RenderScreenElements(Dib: TdtpBitmap; DibRect: TdtpRect); override;
    procedure ResourceAfterLoadFromFile(Sender: TObject); override;
    procedure SetDocSize(AWidth, AHeight: single); override;
    procedure ShowCropDialog;
    procedure SetDocument(const Value: TObject); override;
    function GetStorage: TdtpResourceStorage; override;
    procedure SetStorage(const Value: TdtpResourceStorage); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddArchiveResourceNames(Names: TStrings); override;
    procedure Edit; override;
    function IsEmpty: boolean;
    procedure LoadFromXml(ANode: TXmlNode); override;
    procedure SaveToXml(ANode: TXmlNode); override;
    // If AdaptAspectToImage is True, the shape will resize in such a way that it fits
    // around the image with same aspect ratio. If not, any mismatch will cause the
    // cropform to show up when a new image is loaded. Default value is False.
    property AdaptAspectToImage: boolean read FAdaptAspectToImage write FAdaptAspectToImage;
    // CropRect returns the cropping rectangle used on the original image.
    property CropRect: TRect read FCropRect write SetCropRect;
    // FullImageStorage is the method with which the full image is stored. By default,
    // this is rsExternal, so the original images are not put into the archive.
    // Change this to rsArchive to store original images with the document (for
    // portable solutions etc).
    property FullImageStorage: TdtpResourceStorage read GetFullImageStorage write SetFullImageStorage;
    // Set LowresDPM to the printer's minimum allowed resolution in dots per mm.
    // Default value is 150 / 25.4, which corresponds to 150 DPI. The default can
    // be changed in unit dtpDefaults, constant cDefaultLowresDpm.
    property LowresDPM: single read FLowresDpm write SetLowresDpm;
    // Direct access to the low-resolution image resource
    property LowresImage: TdtpBitmapResource read FLowresImage;
    // Quality returns the image quality in percents, which can be used to determine
    // how good the image will look on the printer. 100% is adequate, higher is better,
    // lower is not acceptable.
    property Quality: integer read GetQuality;
  end;

  // TfrmCropBitmap is the form that displays the original bitmap and a crop-rectangle
  // that can be moved by the user to select which area should be cropped.
  TfrmCropBitmap = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    lbWarning: TLabel;
  private
    FMinWidth: single;
    FMinHeight: single;
    FBand: TdtpRubberBandLayer;
    FSuppressWarning: boolean;
    FMask: TdtpMaskEffect;
    FBitmap: TdtpImgView;
    procedure CropBoxPaint(Sender: TObject; Buffer: TdtpBitmap);
    procedure CropBoxResizing(Sender: TObject; const OldLocation: TdtpRect;
      var NewLocation: TdtpRect; DragState: TdtpDragState; Shift: TShiftState);
    function GetCropbox: TRect;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure AssignBitmap(ABitmap: TdtpBitmap; CropRect: TRect);
    property CropBox: TRect read GetCropbox;
    property MinWidth: single read FMinWidth write FMinWidth;
    property MinHeight: single read FMinHeight write FMinHeight;
    property SuppressWarning: boolean read FSuppressWarning write FSuppressWarning;
    property Mask: TdtpMaskEffect read FMask write FMask;
  end;

procedure CreateCroppedBitmap(Src, Dst: TdtpBitmap; CropRect: TRect; Width, Height: integer);

implementation

uses
  Math;

type

  THackDocument = class(TdtpDocument);

{$R *.DFM}

procedure CreateCroppedBitmap(Src, Dst: TdtpBitmap; CropRect: TRect; Width, Height: integer);
var
  R: TRect;
begin
  Dst.SetSize(Width, Height);
  IntersectRect(R, CropRect, Src.BoundsRect);
  SetStretchFilter(Dst, dtpsfLinear);
  dtpGraphics.StretchTransfer(Dst, Dst.BoundsRect, Dst.BoundsRect, Src, R, Dst.Resampler, dtpdmOpaque, nil);
end;

{ TdtpCropBitmap }

procedure TdtpCropBitmap.AddArchiveResourceNames(Names: TStrings);
begin
  inherited;
  FLowresImage.AddArchiveResourceNames(Names);
end;

constructor TdtpCropBitmap.Create;
begin
  inherited;
  // Create a resource for our temporary bitmap.
  FLowresImage := TdtpBitmapResource.Create;
  // We also store the temp image to allow faster loading on next open. A random
  // name will be given to it automatically. Default is rsArchive, but it can
  // be changed to rsEmbedded when working with copy/paste between documents
  FLowresImage.Storage := cDefaultLowresImageStorage;//rsArchive;
  FLowresImage.FileName := '.hck'; // store as .hck (lossless)
  FLowresImage.OnObjectChanged := LowresImageChanged;
  // Set the storage method of original image to rsArchive
  Image.Clear;
  Image.Storage := TdtpResourceStorage(cDefaultFullImageStorage);
  // Defaults
  FLowresDPM := cDefaultLowresDPM;
end;

procedure TdtpCropBitmap.CreateLowresImage;
var
  Bitmap: TdtpBitmap;
  Name: string;
begin
  // checks
  if not assigned(FLowresImage) then
    exit;
  if not assigned(Image) then
    exit;

  FLowresImage.BeginAccess;
  Image.BeginAccess;
  try
    if not assigned(Image.Bitmap) and (length(Image.Filename) > 0) then
    begin
      Name := Image.FileName;
      // we lost the original image, ask the user to find it
      if assigned(Document) then
        TdtpDocument(Document).LocateFilename(Self, Name);
      if FileExists(Name) then
      begin
        Image.LoadFromFile(Name);
      end;
    end;

    if assigned(Image.Bitmap) then
    begin

      if not assigned(FLowresImage.Bitmap) then
      begin
        // Create a default temp image
        Bitmap := TdtpBitmap.Create;
        try
          FLowresImage.Bitmap := Bitmap;
        finally
          Bitmap.Free;
        end;
      end;

      CreateCroppedBitmap(Image.Bitmap, FLowresImage.Bitmap, FCropRect,
        round(DocWidth * FLowresDpm), round(DocHeight * FLowresDpm));
      Image.Drop;
    end;

    // make sure to get updated
    FLowresImage.BitmapChanged;

  finally
    FLowresImage.EndAccess;
    Image.EndAccess;
  end;
end;

destructor TdtpCropBitmap.Destroy;
begin
  FreeAndNil(FLowresImage);
  inherited;
end;

procedure TdtpCropBitmap.DoAfterPaste;
begin
  inherited;
  // Make sure to use a different temp image as the shape we were copied from
  FLowresImage.ArchiveName := '';
  CreateLowresImage;
end;

procedure TdtpCropBitmap.DoDrawQualityIndicator(Canvas: TCanvas; var Rect: TRect; Quality: integer; var Drawn: boolean);
begin
  if assigned(Document) then
    TdtpDocument(Document).DrawQualityIndicator(Self, Canvas, Rect, Quality, Drawn);
end;

procedure TdtpCropBitmap.Edit;
begin
  if assigned(OnDblClick) then
    inherited
  else
  begin
    // This is our editing
    ShowCropDialog;
    // And signal document
    if Document is TdtpDocument then
      TdtpDocument(Document).DoEditClose(True);
  end;
end;

function TdtpCropBitmap.GetDefaultCropRect: TRect;
var
  Scale: single;
  AWidth, AHeight: integer;
begin
  if not assigned(Image.Bitmap) then
    exit;
  Scale := min(Image.Bitmap.Width / DocWidth, Image.Bitmap.Height / DocHeight);
  AWidth  := round(DocWidth * Scale);
  AHeight := round(DocHeight * Scale);
  Result.Left   := (Image.Bitmap.Width  - AWidth ) div 2;
  Result.Top    := (Image.Bitmap.Height - AHeight) div 2;
  Result.Right  := Result.Left + AWidth;
  Result.Bottom := Result.Top + AHeight;
end;

function TdtpCropBitmap.GetFullImageStorage: TdtpResourceStorage;
begin
  Result := Image.Storage;
end;

function TdtpCropBitmap.GetQuality: integer;
begin
  if (DocWidth > 0) and (DocHeight > 0) then
    Result := round(
      Min((FCropRect.Right - FCropRect.Left) / (DocWidth * FLowresDPM),
        (FCropRect.Bottom - FCropRect.Top) / (DocHeight * FLowresDPM)) * 100)
  else
    Result := 0;
end;

function TdtpCropBitmap.GetStorage: TdtpResourceStorage;
begin
  Result := FLowresImage.Storage;
end;

function TdtpCropBitmap.IsEmpty: boolean;
begin
  Result := not assigned(FLowResImage.Bitmap);
  // we don't give up so fast..
  if Result then
  begin
    // Lowres image is empty, so try to recreate it
    CreateLowresImage;
    // Now check again
    Result := not assigned(FLowResImage.Bitmap);
  end;
end;

procedure TdtpCropBitmap.LoadFromXml(ANode: TXmlNode);
var
  Child: TXmlNode;
begin
  inherited;
  // Upgrade old-style documents gracefully
  Child := ANode.NodeByName('TempImage');
  if assigned(Child) then
    if Document is TdtpDocument then
      THackDocument(Document).ForceUpgradeFromPreviousVersion;

  Child := ANode.NodeByName('LowresImage');
  if assigned(Child) then
    FLowresImage.LoadFromXml(Child);
  FCropRect.Left   := ANode.ReadInteger('CropRectLeft');
  FCropRect.Top    := ANode.ReadInteger('CropRectTop');
  FCropRect.Right  := ANode.ReadInteger('CropRectRight');
  FCropRect.Bottom := ANode.ReadInteger('CropRectBottom');
  FLowresDPM := ANode.ReadFloat('LowresDPM', cDefaultLowresDPM);
  FAdaptAspectToImage := ANode.ReadBool('AdaptAspectToImage', False);
  PlaceHolderVisible := IsEmpty;
end;

procedure TdtpCropBitmap.LowresImageChanged(Sender: TObject);
begin
  Changed;
end;

procedure TdtpCropBitmap.PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext);
var
  Bmp: TdtpBitmap;
begin
  // Checks
  if IsEmpty then
    exit;

  // During high resolution printing we want to *try* to load the high-resolution
  // image. If it can't be loaded automatically (e.g. the resource is external, and
  // original file was deleted, moved or renamed), then we will use the
  // lowresolution image instead.
  if (Device.DeviceType = dtPrinter) and (Device.ActualDpm > LowResDPM) then
  begin
    // Try to get the HiRes image now, which is stored in the Image resource
    Image.BeginAccess;
    try
      // Next line will try to load the high-resolution image. If the bitmap
      // is not assigned, we will skip over the highres printing
      if assigned(Image.Bitmap) then
      begin
        // We have the high-resolution bitmap
        Bmp := TdtpBitmap.Create;
        try
          // Create the cropped bitmap
          CreateCroppedBitmap(Image.Bitmap, Bmp, FCropRect,
            round(DocWidth * Device.ActualDpm), round(DocHeight * Device.ActualDpm));

          // stretchtransfer it to the Dib
          SetStretchFilter(DIB, Device.Quality);
          dtpGraphics.StretchTransfer(DIB, CanvasRect, DIB.BoundsRect, Bmp, Bmp.BoundsRect,
            DIB.Resampler, dtpdmBlend, nil);

          // Now we  exit
          exit;

        finally
          Bmp.Free;
        end;
      end;
    finally
      Image.EndAccess;
    end;

  end;

  FLowresImage.BeginAccess;
  try

    // this indicates that we must recreate the temp bitmap
    Bmp := FLowresImage.Bitmap;
    if not assigned(Bmp) or Bmp.Empty then
      exit;

    // Arriving here means we have a valid temp image to draw

    // This is a G32 routine to stretch our image to the DIB on which we paint.
    // CanvasLeft..CanvasBottom are properties that define the bounds of the
    // shape (in canvas coordinates)
    SetStretchFilter(Dib, Device.Quality);
    dtpGraphics.StretchTransfer(DIB, CanvasRect, DIB.BoundsRect, Bmp, Bmp.BoundsRect,
      Dib.Resampler, dtpdmBlend, nil);

  finally
    FLowresImage.EndAccess;
  end;
end;

procedure TdtpCropBitmap.RenderScreenElements(Dib: TdtpBitmap;
  DibRect: TdtpRect);
var
  x, y: integer;
  R: TRect;
  Drawn: boolean;
begin
  if IsEmpty then
    exit;
  // Draw Quality indicator
  R.Left   := CanvasLeft;
  R.Top    := CanvasTop;
  R.Right  := R.Left + 32;
  R.Bottom := R.Top + 32;
  Drawn := False;
  DoDrawQualityIndicator(DIB.Canvas, R, Quality, Drawn);
  // flip alpha in rect
  if Drawn then
    for y := R.Top to R.Bottom do
      for x := R.Left to R.Right do
        DIB.PixelS[x, y] := DIB.PixelS[x, y] xor $FF000000;
end;

procedure TdtpCropBitmap.ResourceAfterLoadFromFile(Sender: TObject);
var
  BmpArea, DocArea, Scale: single;
  NewWidth, NewHeight: single;
begin
  // If not yet loaded, the document sizes are 0.. so initialize
  PlaceholderVisible := not assigned(Image.Bitmap);
  if not assigned(Image.Bitmap) then
    exit;

  FCropRect := Rect(0, 0, Image.Bitmap.Width, Image.Bitmap.Height);
  if AdaptAspectToImage then
  begin

    // Determine aspect
    BmpArea := Image.Bitmap.Width * Image.Bitmap.Height;
    if BmpArea = 0 then
      exit;
    DocArea := DocWidth * DocHeight;
    if DocArea = 0 then
      exit;

    // Determine scale factor
    Scale := sqrt(BmpArea / DocArea);

    // Resize and fix aspect
    NewWidth  := Image.Bitmap.Width  / Scale;
    NewHeight := Image.Bitmap.Height / Scale;
    SetDocBounds(DocLeft + (DocWidth - NewWidth) / 2, DocTop + (DocHeight - NewHeight) / 2, NewWidth, NewHeight);

  end else
  begin

    // Automatically crop
    FCropRect := GetDefaultCropRect;

  end;

  // Create the lowres image now
  CreateLowresImage;
  // And fix aspect now
  FixAspectRatio;
end;

procedure TdtpCropBitmap.SaveToXml(ANode: TXmlNode);
begin
  inherited;
  FLowresImage.SaveToXml(ANode.NodeNew('LowresImage'));
  ANode.WriteInteger('CropRectLeft', FCropRect.Left);
  ANode.WriteInteger('CropRectTop', FCropRect.Top);
  ANode.WriteInteger('CropRectRight', FCropRect.Right);
  ANode.WriteInteger('CropRectBottom', FCropRect.Bottom);
  ANode.WriteFloat('LowresDPM', FLowresDPM, cDefaultLowresDPM);
  ANode.WriteBool('AdaptAspectToImage', FAdaptAspectToImage);
end;

procedure TdtpCropBitmap.SetCropRect(const Value: TRect);
begin
  FCropRect := Value;
  CreateLowresImage;
end;

procedure TdtpCropBitmap.SetDocSize(AWidth, AHeight: single);
begin
  inherited;
  // Recreate the low-resolution image
  CreateLowresImage;
end;

procedure TdtpCropBitmap.SetDocument(const Value: TObject);
begin
  inherited;
  FLowresImage.Document := Value;
end;

procedure TdtpCropBitmap.SetFullImageStorage(const Value: TdtpResourceStorage);
begin
  Image.Storage := Value;
end;

procedure TdtpCropBitmap.SetLowresDpm(const Value: single);
begin
  if FLowresDpm <> Value then
  begin
    FLowresDpm := Value;
    CreateLowresImage;
  end;
end;

procedure TdtpCropBitmap.SetStorage(const Value: TdtpResourceStorage);
begin
  inherited;
  FLowresImage.Storage := Value;
end;

procedure TdtpCropBitmap.ShowCropDialog;
var
  ScaleImage, Scale: single;
//  Bmp: TBitmap32;
begin
  // First, open a file if not yet
  if not assigned(Image.Bitmap) then
    with TOpenPictureDialog.Create(Application) do
    begin
      try
        Title := 'Change to another file (choose)';
        Filter := RasterFormatOpenFilter;
{       test
        if Execute then begin
          Bmp := TBitmap32.Create;
          try
            Bmp.LoadFromFile(FileName);
            Image.Storage := rsArchive;
            Image.LoadFromBitmap(Bmp, '.jpg');
          finally
            Bmp.Free;
          end;
        end;}
        if Execute then
          // Load..
          Image.LoadFromFile(FileName);
      finally
        Free;
      end;
    end;
  if not assigned(Image.Bitmap) then
    exit;

  // Determine cropbox
  if (FCropRect.Right = 0) then
    // check if not yet set
    FCropRect := GetDefaultCropRect;

  if (FCropRect.Left > 0) or (FCropRect.Top > 0)
    or (FCropRect.Right < Image.Bitmap.Width) or (FCropRect.Bottom < Image.Bitmap.Height) then
  begin
    // Second, display crop form
    with TfrmCropBitmap.Create(Application) do
      try
        AssignBitmap(Image.Bitmap, FCropRect);
        Mask := TdtpMaskEffect(EffectByClass(TdtpMaskEffect));
        ScaleImage := Min(Image.Bitmap.Width / DocWidth, Image.Bitmap.Height / DocHeight);
        Scale := Min(FLowresDPM, ScaleImage);
        if ScaleImage <= Scale then
          SuppressWarning := True;
        // Set minimum width/height
        MinWidth  := DocWidth  * Scale;
        MinHeight := DocHeight * Scale;
        ShowModal;
        FCropRect := CropBox;
      finally
        Free;
      end;
  end;
  CreateLowresImage;
  Changed;
  Regenerate;
end;

{ TfrmCropBitmap }

procedure TfrmCropBitmap.AssignBitmap(ABitmap: TdtpBitmap; CropRect: TRect);
begin
  // Create background bitmap
  with FBitmap do
  begin
    Layers.Clear;
    Bitmap.Assign(ABitmap);
    SetDrawMode(Bitmap, dtpdmBlend);
    Scale := min(GetViewportRect.Right / Bitmap.Width, GetViewportRect.Bottom / Bitmap.Height);
  end;
  // Create crop layer
  FBand := TdtpRubberBandLayer.Create(FBitmap.Layers);
  FBand.Location := dtpRect(CropRect.Left, CropRect.Top, CropRect.Right, CropRect.Bottom);
  FBand.Scaled := True;
  FBand.MouseEvents := True;
  FBand.OnPaint := CropBoxPaint;
  // Resizing event of Graphics32 Layers(TRBResizingEvent), needs to work as well in Pyro
  SetResizingEvent(FBand, CropboxResizing);
end;

constructor TfrmCropBitmap.Create(AOwner: TComponent);
begin
  inherited;
  FBitmap := TdtpImgView.Create(Self);
  FBitmap.Parent := Self;
  FBitmap.Align := alClient;
end;

procedure TfrmCropBitmap.CropBoxPaint(Sender: TObject; Buffer: TdtpBitmap);
var
  XStart, XClose, YStart, YClose: integer;
  Map: TdtpByteMap;
  View: TRect;
  x, y: integer;
  P: PdtpColor;
// local
procedure BlendRect(Left, Top, Right, Bottom: integer);
var
  x, y: integer;
  P: PdtpColor;
begin
  for y := Top to Bottom - 1 do
  begin
    P := GetPixelPtr(Buffer, Left, y);
    for x := Left to Right - 1 do
    begin
      P^ := dtpBlendReg(P^ and $80FFFFFF, clWhite32);
      inc(P);
    end;
  end;
  EMMS;
end;
// main
begin
  // Blend everything except in the crop box
  with TdtpPositionedLayer(Sender).GetAdjustedLocation do
  begin
    YStart := Max(0, round(Top));
    YClose := Min(Buffer.Height, round(Bottom));
    XStart := Max(0, round(Left));
    XClose := Min(Buffer.Width, Round(Right));
    BlendRect(0, 0, Buffer.Width, YStart);
    BlendRect(0, YStart, XStart, YClose);
    BlendRect(XClose, YStart, Buffer.Width, YClose);
    BlendRect(0, YClose, Buffer.Width, Buffer.Height);
    if assigned(FMask) then
    begin
      // Make the mask effect paint itself to a mask
      Map := TdtpByteMap.Create;
      try
        // Create map and paint it
        Map.SetSize(XClose - XStart, YClose - YStart);
        Map.Clear($FF);
        View := Rect(0, 0, XClose - XStart, YClose - YStart);
        FMask.PaintMasks(Map, View);
        // Use it to mask the pixels
        for y := YStart to YClose - 1 do
        begin
          //P := Buffer.PixelPtr[XStart, y];
          P := GetPixelPtr(Buffer, XStart, y);
          for x := XStart to XClose - 1 do
          begin
            P^ := dtpBlendReg(P^ and $FFFFFF + (128 + 127 * Map[x - XStart, y - YStart] div 255) shl 24, clWhite32);
            inc(P);
          end;
        end;
        EMMS;
      finally
        Map.Free;
      end;
    end;
  end;
end;

procedure TfrmCropBitmap.CropBoxResizing(Sender: TObject;
  const OldLocation: TdtpRect; var NewLocation: TdtpRect;
  DragState: TdtpDragState; Shift: TShiftState);
var
  OldWidth, NewWidth, OldHeight, NewHeight, Scale, MaxWidth, MaxHeight: single;
begin
  OldWidth  := OldLocation.Right - OldLocation.Left;
  NewWidth  := NewLocation.Right - NewLocation.Left;
  OldHeight := OldLocation.Bottom - OldLocation.Top;
  NewHeight := NewLocation.Bottom - NewLocation.Top;
  MaxWidth  := FBitmap.Bitmap.Width;
  MaxHeight := FBitmap.Bitmap.Height;
  if (OldWidth <> NewWidth) or (OldHeight <> NewHeight) then
  begin
    if (OldWidth < NewWidth) or (OldHeight < NewHeight) then
      Scale := Max(NewWidth / OldWidth, NewHeight / OldHeight)
    else
      Scale := Min(NewWidth / OldWidth, NewHeight / OldHeight);
    // Resize with aspect
    lbWarning.Visible := not SuppressWarning and ((NewWidth < MinWidth) or (NewHeight < MinHeight));
    Scale := Min(Scale, MaxWidth / OldWidth);
    Scale := Min(Scale, MaxHeight / OldHeight);
    Scale := Max(Scale, MinWidth / OldWidth);
    Scale := Max(Scale, MinHeight / OldHeight);

    NewWidth := Scale * OldWidth;
    NewHeight := Scale * OldHeight;
  end;

  // Respect move limits
  NewLocation.Left := Max(0, NewLocation.Left);
  NewLocation.Top  := Max(0, NewLocation.Top);
  NewLocation.Left := Min(MaxWidth - NewWidth, NewLocation.Left);
  NewLocation.Top  := Min(MaxHeight - NewHeight, NewLocation.Top);
  NewLocation.Right  := NewLocation.Left + NewWidth;
  NewLocation.Bottom := NewLocation.Top  + NewHeight;
end;

function TfrmCropBitmap.GetCropbox: TRect;
begin
  Result.Left   := Max(0, round(FBand.Location.Left));
  Result.Top    := Max(0, round(FBand.Location.Top));
  Result.Right  := Min(FBitmap.Bitmap.Width, round(FBand.Location.Right));
  Result.Bottom := Min(FBitmap.Bitmap.Height, round(FBand.Location.Bottom));
end;

initialization

  RegisterShapeClass(TdtpCropBitmap);

end.

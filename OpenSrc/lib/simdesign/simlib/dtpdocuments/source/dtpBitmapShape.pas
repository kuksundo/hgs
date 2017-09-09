{
  Unit dtpBitmapShape

  TdtpBitmapShape is a TdtpEffectShape descendant that can be used to show
  bitmap (raster) images. Raster formats that are supported can be found
  in the unit dtpRasterFormats. Additional formats can be added.

  Project: DTP-Engine

  Creation Date: 22-08-2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpBitmapShape;

{$i simdesign.inc}

interface

uses

  Windows, Classes, SysUtils, dtpEffectShape, dtpResource, dtpBitmapResource,
  dtpGraphics, NativeXmlOld, dtpDefaults, sdWidestrings, dtpMemoShape,
  dtpPolygonShape, Graphics, dtpShape, dtpHandles, dtpTextShape;

type

  // TdtpBitmapShape shows a bitmapped image in its shape rectangle. The bitmapped image
  // can be of any of the bitmap image formats that are supported by the library. The
  // image is either stored in its original format in an embedded resource, or externally.
  TdtpBitmapShape = class(TdtpEffectShape)
  private
    FImage: TdtpBitmapResource; // The image is held in this resource
  protected
    procedure ResourceAfterLoadFromFile(Sender: TObject); virtual;
    procedure ResourceObjectChanged(Sender: TObject); virtual;
    procedure PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext); override;
    procedure SetDocument(const Value: TObject); override;
    function GetStorage: TdtpResourceStorage; override;
    procedure SetStorage(const Value: TdtpResourceStorage); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddArchiveResourceNames(Names: TStrings); override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    // Image is the bitmap resource that holds the actual bitmap. Use Image.LoadFromFile()
    // to load a new bitmap into the shape, or use Image.Bitmap := MyBitmap to assign
    // a new TBitmap32 bitmap to it.
    property Image: TdtpBitmapResource read FImage write FImage;
  end;

  TdtpSnapBitmap = class(TdtpBitmapShape)
  private
    function GetPlaceholderVisible: boolean;
    procedure SetPlaceholderVisible(const Value: boolean);
    function GetFrame: TdtpRectangleShape;
    {$ifndef usePolygonText}
    function GetMemo: TdtpMemoShape;
    {$else}
    function GetMemo: TdtpPolygonMemo;
    {$endif}
  protected
    procedure ResourceAfterLoadFromFile(Sender: TObject); override;
  public
    constructor Create; override;
    function GetHitTestInfoDblClickAt(APos: TPoint; var AShape: TdtpShape): THitTestInfo; override;
    property Frame: TdtpRectangleShape read GetFrame;
    {$ifndef usePolygonText}
    property Memo: TdtpMemoShape read GetMemo;
    {$else}
    property Memo: TdtpPolygonMemo read GetMemo;
    {$endif}
    property PlaceholderVisible: boolean read GetPlaceholderVisible write SetPlaceholderVisible;
  end;

implementation

uses
  dtpDocument;

{ TdtpBitmapShape }

procedure TdtpBitmapShape.AddArchiveResourceNames(Names: TStrings);
begin
  inherited;
  Image.AddArchiveResourceNames(Names);
end;

constructor TdtpBitmapShape.Create;
begin
  inherited;
  // Create a resource for our bitmap.
  FImage := TdtpBitmapResource.Create;
  // Make sure that shape size is set when object is loaded
  FImage.OnAfterLoadFromFile  := ResourceAfterLoadFromFile;
  FImage.OnObjectChanged := ResourceObjectChanged;
  // Defaults
  InsertCursor := crDtpCrossImage;
  // Caching turned on by default, because this helps speed up rendering for
  // large bitmaps (which are quite common nowadays)
  //MustCache := True;
end;

destructor TdtpBitmapShape.Destroy;
begin
  FreeAndNil(FImage);
  inherited;
end;

function TdtpBitmapShape.GetStorage: TdtpResourceStorage;
begin
  Result := FImage.Storage;
end;

procedure TdtpBitmapShape.LoadFromXml(ANode: TXmlNodeOld);
var
  Child: TXmlNodeOld;
begin
  inherited;
  // Load resource
  Child:= ANode.NodeByName('Image');
  if assigned(Child) then
    FImage.LoadFromXml(Child);
end;

procedure TdtpBitmapShape.PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext);
begin
  Image.BeginAccess;
  try
    if not assigned(Image.Bitmap) then
      exit;

    // This is a G32 routine to stretch our image to the DIB on which we paint.
    // CanvasLeft..CanvasBottom are properties that define the bounds of the
    // shape (in canvas coordinates)
    //Dib.StretchFilter := Device.Quality;
    SetStretchFilter(Dib, Device.Quality);
    StretchTransfer(
      DIB, Rect(CanvasLeft, CanvasTop, CanvasRight, CanvasBottom), DIB.BoundsRect,
      Image.Bitmap, Image.Bitmap.BoundsRect, Dib.Resampler, dtpdmBlend, nil);

  finally
    Image.EndAccess;
  end;
end;

procedure TdtpBitmapShape.ResourceAfterLoadFromFile(Sender: TObject);
begin
  Image.BeginAccess;
  try
    with FImage do begin
      if not assigned(Bitmap) then exit;
      // After loading a file, we set the shapes size
      DocWidth  := Bitmap.Width   / cLowPrinterDpm;
      DocHeight := Bitmap.Height  / cLowPrinterDpm;
      FixAspectRatio;
      Regenerate;
    end;
  finally
    Image.EndAccess;
  end;
end;

procedure TdtpBitmapShape.ResourceObjectChanged(Sender: TObject);
begin
  Refresh;
end;

procedure TdtpBitmapShape.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  FImage.SaveToXml(ANode.NodeNew('Image'));
end;

procedure TdtpBitmapShape.SetDocument(const Value: TObject);
begin
  inherited;
  // Set the image's document property as well
  Image.Document := Value;
end;

procedure TdtpBitmapShape.SetStorage(const Value: TdtpResourceStorage);
begin
  FImage.Storage := Value;
end;

{ TdtpSnapBitmap }

constructor TdtpSnapBitmap.Create;
var
  AFrame: TdtpRectangleShape;
  {$ifndef usePolygonText}
  AMemo: TdtpMemoShape;
  {$else}
  AMemo: TdtpPolygonMemo;
  {$endif}
begin
  inherited;
  // Create a frame and a memo that are for the placeholder function
  AFrame := TdtpRectangleShape.Create;
  AFrame.OutlineColor := cDefaultSnapFrameColor;
  AFrame.OutlineWidth := cDefaultSnapFrameWidth;
  AFrame.FillColor    := cDefaultSnapFillColor;
  AFrame.Anchors := [saLeftLock, saTopLock, saSizeXprop, saSizeYProp];
  AFrame.DocWidth  := cDefaultSnapBitmapWidth;
  AFrame.DocHeight := cDefaultSnapBitmapHeight;
  AFrame.AutoCreated := True;
  ShapeAdd(AFrame);

  {$ifndef usePolygonText}
  AMemo := TdtpMemoShape.Create;
  {$else}
  AMemo:= TdtpPolygonMemo.Create;
  {$endif}
  AMemo.FontHeightPts := 12;
  {$ifndef usePolygonText}
  AMemo.Lines.Text    := cDefaultSnapMemoText;
  {$else}
  AMemo.Text          := cDefaultSnapMemoText;
  {$endif}
  AMemo.Alignment     := taCenter;
  AMemo.AutoSize      := False;
  AMemo.VertAlign     := alMiddle;
  AMemo.AllowEdit     := False;
  AMemo.Anchors := [saLeftLock, saTopLock, saSizeXprop, saSizeYProp];
  AMemo.SetDocBounds(2, 2, AFrame.DocWidth - 4, AFrame.DocHeight - 4);
  AMemo.AutoCreated := True;
  ShapeAdd(AMemo);

  // This command will group the controls and fit our bounds just around
  FindFittingBounds;
end;

function TdtpSnapBitmap.GetFrame: TdtpRectangleShape;
begin
  Result := TdtpRectangleShape(Shapes[0]);
end;

function TdtpSnapBitmap.GetHitTestInfoDblClickAt(APos: TPoint;
  var AShape: TdtpShape): THitTestInfo;
begin
  Result := inherited GetHitTestInfoDblClickAt(APos, AShape);
  // Make sure not to report child shapes, report ourself
  if assigned(AShape) then AShape := Self;
end;

{$ifndef UsePolygonText}
function TdtpSnapBitmap.GetMemo: TdtpMemoShape;
begin
  Result := TdtpMemoShape(Shapes[1]);
end;

{$else}

function TdtpSnapBitmap.GetMemo: TdtpPolygonMemo;
begin
  Result := TdtpPolygonMemo(Shapes[1]);
end;

{$endif}

function TdtpSnapBitmap.GetPlaceholderVisible: boolean;
begin
  Result := Frame.Visible;
end;

procedure TdtpSnapBitmap.ResourceAfterLoadFromFile(Sender: TObject);
var
  BmpArea, DocArea, Scale: single;
  NewWidth, NewHeight: single;
begin
  // If not yet loaded, the document sizes are 0.. so initialize
  PlaceholderVisible := not assigned(Image.Bitmap);
  Image.BeginAccess;
  try
    if not assigned(Image.Bitmap) then exit;

    // Determine areas
    BmpArea := Image.Bitmap.Width * Image.Bitmap.Height;
    if BmpArea = 0 then exit;
    DocArea := DocWidth * DocHeight;
    if DocArea = 0 then exit;

    // Determine scale factor
    Scale := sqrt(BmpArea / DocArea);

    // Resize and fix aspect
    NewWidth  := Image.Bitmap.Width  / Scale;
    NewHeight := Image.Bitmap.Height / Scale;
    SetDocBounds(DocLeft + (DocWidth - NewWidth) / 2, DocTop + (DocHeight - NewHeight) / 2, NewWidth, NewHeight);
    FixAspectRatio;
    Regenerate;
  finally
    Image.EndAccess;
  end;
end;

procedure TdtpSnapBitmap.SetPlaceholderVisible(const Value: boolean);
begin
  if assigned(Frame) then Frame.Visible := Value;
  if assigned(Memo) then Memo.Visible := Value;
end;

initialization

  RegisterShapeClass(TdtpBitmapShape);
  RegisterShapeClass(TdtpSnapBitmap);

end.


{
  Unit dtpPage

  dtpPage is a dtpShape descendant that looks like a blank page,
  showing margins as stippled lines and showing grid like lineated
  paper.

  Override this object to create pages for other special formats, like CD (round
  disk with hole in the middle), etc

  Project: DTP-Engine

  Creation Date: 25-10-2002 (NH)
  Version: see "changes.txt"

  Modifications:
  01Aug2003: Added Printfast method

  Copyright (c) 2002-2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  Contributor: J.F.

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpPage;

{$i simdesign.inc}

interface

uses
  // Dialogs removed, Messages added (J.F. Feb 2011)
  Types, Windows, Controls, Classes, Graphics, Math, SysUtils, Messages,
  // simdesign nativexml
  NativeXmlOld,
  // dtpdocuments
  dtpShape, dtpGraphics, dtpGuides, dtpUtil, dtpXmlBitmaps, dtpDefaults, dtpBitmapResource;

type
                  //  added by J.F. July 2011
  // Selected Margin for drag / move margins with mouse
  TdtpSelectedMarginType = (
    smNone,
    smLeft,
    smTop,
    smRight,
    smBottom
  );

  TdtpPage = class(TdtpShape)
  private
    FBackgroundImage: TdtpBitmapResource;
    FBackgroundTiled: boolean;
    FGridColor: TColor;      // Color of the grid
    FGridSize: single;       // Grid size in mm
    FIsLoaded: boolean;      // Is the page already loaded from the archive?
    FMarginBottom: single;   // Bottom Margin in mm
    FMarginLeft: single;     // Left Margin in mm
    FMarginTop: single;      // Top Margin in mm
    FMarginRight: single;    // Right Margin in mm
    FPageColor: TColor;      // Default page color
    FIsThumbnailModified: boolean;// Thumbnail must be updated
    FThumbnail: TBitmap;     // Thumbnail image
    FIsDefaultPage: boolean;

    FShowBackgroundImage: boolean; // added by J.F. Feb 2011
    FPageGuides: TdtpPageGuides;  // added by J.F. Feb 2011

    function GetPageIndex: integer;
    function GetThumbnail: TBitmap;
    function GetViewStyle: TdtpViewStyleType;
    procedure SetGridColor(const Value: TColor);
    procedure SetGridSize(const Value: single);
    procedure SetMarginBottom(const Value: single);
    procedure SetMarginLeft(const Value: single);
    procedure SetMarginTop(const Value: single);
    procedure SetMarginRight(const Value: single);
    procedure SetThumbnail(const Value: TBitmap);
    procedure SetIsDefaultPage(const Value: boolean);
    function GetHelperMethod: TdtpHelperMethodType;
    function GetGridColor: TColor;
    function GetGridSize: single;
    function GetMarginBottom: single;
    function GetMarginLeft: single;
    function GetMarginRight: single;
    function GetMarginTop: single;
    function GetPageColor: TColor;
    function GetShowMargins: boolean;
    procedure SetPageColor(const Value: TColor);
    function GetIsDefaultPage: boolean;
    function GetPageHeight: single;
    function GetPageWidth: single;
    procedure SetPageHeight(const Value: single);
    procedure SetPageWidth(const Value: single);
    function GetBackgroundBitmap: TdtpBitmap;
    function GetBackgroundTiled: boolean;
    procedure SetBackgroundTiled(const Value: boolean);
    procedure BackgroundImageObjectChanged(Sender: TObject);
    procedure BackgroundImageAfterLoadFromFile(Sender: TObject);
  protected
    FSelectedGuide: TdtpGuide; // added by J.F. June 2011

    FSelectedMargin: TdtpSelectedMarginType;  // added by J.F. July 2011

    procedure AddArchiveResourceNames(Names: TStrings); override;
    function AddGuide():TdtpGuide;  // added by J.F. June 2011
    function GetName: string; override;
    procedure SetModified(const Value: boolean); override;
    procedure PaintDib(Dib: TdtpBitmap; const ADevice: TDeviceContext); override;
    procedure PaintForeground(DIB: TdtpBitmap; const ADevice: TDeviceContext); override;
    procedure PrintRectangle(PrinterCanvas: TCanvas; PRect, DRect, Orig: TRect; Rotation: integer;
      PrintMirrored, PrintFlipped: boolean; Device: TDeviceContext);

    procedure RenderShapeDirect(Dib: TdtpBitmap; DibRect: TdtpRect; const ADevice: TDeviceContext); override; // added by J.F. Feb 2011

    procedure SetDocHeight(const Value: single); override; // added by J.F. Apr 2011 Guides bug fix
    procedure SetDocWidth(const Value: single); override;  // added by J.F. Apr 2011

    procedure SetDocument(const Value: TObject); override;
    // Turn on/off backgroundImage
    procedure SetShowBackgroundImage(const Value: boolean); // added by J.F. Feb 2011

    procedure FinishGuideMove(APoint: TdtpPoint); // added by J.F. Feb 2011
    function GetGuideAtPoint(APoint: TdtpPoint): TdtpGuide;  // added by J.F. June 2011
    procedure MoveSelectedGuide(APoint: TdtpPoint);  // added by J.F. Feb 2011
    function StartGuideMove(APoint: TdtpPoint): boolean;  // added by J.F. Feb 2011
    function GetGuideCount: integer;  // added by J.F. June 2011

    function IsMarginSelected(APoint: TdtpPoint): boolean;  //  added by J.F. July 2011
    function StartMarginMove(APoint: TdtpPoint): boolean; // added by J.F. July 2011
    procedure MoveSelectedMargin(APoint: TdtpPoint); // added by J.F. July 2011
    function ValidMarginPosition(const MarginPosition: TdtpPoint): boolean;  //  added by J.F. June 2011

  public
    constructor Create; override;
    destructor Destroy; override;

    procedure DeleteAllGuides();  // added by J.F. Feb 2011
    procedure MoveGuide(Guide: TdtpGuide; NewPosition: single);  // added by J.F. June 2011
    procedure SetGuideColor(Value: TColor); // Added by J.F. Feb 2011

    procedure AdjustLeftTop(ALeft, ATop: single); virtual;
    function  AdjustToGrid(APoint: TdtpPoint): TdtpPoint; override;
    function AdjustToGuides(APoint: TdtpPoint): TdtpPoint; // added by J.F. Feb 2011
    function GetThumbnail24Bit(AWidth, AHeight: Integer): TBitmap;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure LoadPageAsNeeded; virtual;
    function MarginRect: TdtpRect;

    // Call "Print" to use the current resolution of the printer. This may be
    // very slow, for printers with 600, 1200 or even 2400 DPI, but will lead
    // to superb images.
    procedure Print(PrinterCanvas: TCanvas; ARect: TRect; Resolution: single; Rotation: integer;
      PrintMirrored, PrintFlipped: boolean); virtual;

    // Call "PrintScreen" to print with the exact same resolution as appearing on
    // the screen. You can use this method to print to the printer too, as WYSIWYG
    procedure PrintScreen(PrinterCanvas: TCanvas; Rect: TRect; PreserveAspect: boolean;
       AMaxRes: single = cLowPrinterDpm);

    // Call "PrintFast" to use the resolution as specified in Document.PrinterDpm.
    // This resolution is often lower than the printer resolution and will therefore
    // allow fast prints, but of less quality
    procedure PrintFast(PrinterCanvas: TCanvas; ARect: TRect; Rotation: integer;
      PrintMirrored, PrintFlipped: boolean); virtual;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    procedure SetDocBoundsAndAngle(ALeft, ATop, AWidth, AHeight, AAngle: single); override;
    procedure UpdateThumbnail; virtual;
    property BackgroundImage: TdtpBitmapResource read FBackgroundImage;
    property BackgroundTiled: boolean read GetBackgroundTiled write SetBackgroundTiled;
    property GridColor: TColor read GetGridColor write SetGridColor;
    property GridSize: single read GetGridSize write SetGridSize;
    property HelperMethod: TdtpHelperMethodType read GetHelperMethod;
    property IsDefaultPage: boolean read GetIsDefaultPage write SetIsDefaultPage;
    property IsLoaded: boolean read FIsLoaded write FIsLoaded;
    property IsThumbnailModified: boolean read FIsThumbnailModified write FIsThumbnailModified;
    property ShowMargins: boolean read GetShowMargins;
    property MarginBottom: single read GetMarginBottom write SetMarginBottom;
    property MarginLeft: single read GetMarginLeft write SetMarginLeft;
    property MarginRight: single read GetMarginRight write SetMarginRight;
    property MarginTop: single read GetMarginTop write SetMarginTop;
    property PageColor: TColor read GetPageColor write SetPageColor;
    property PageHeight: single read GetPageHeight write SetPageHeight;
    property PageIndex: integer read GetPageIndex;
    property PageWidth: single read GetPageWidth write SetPageWidth;
    property Thumbnail: TBitmap read GetThumbnail write SetThumbnail;
    property ViewStyle: TdtpViewStyleType read GetViewStyle;
    // added by J.F. Feb 2011
    property ShowBackgroundImage: boolean read FShowBackgroundImage write SetShowBackgroundImage;
    property SelectedGuide: TdtpGuide read FSelectedGuide;  // added by J.F. June 2011
    property GuideCount: integer read GetGuideCount;  // added by J.F. June 2011
  end;

type
  TPaperSizeInfoRec = record
    Name: string;
    Width: single;
    Height: single;
  end;

const

  cPaperSizeCount = 8;
  cDefaultPaperSizeIndex = 1; // A4
  cPaperSizes: array[0..cPaperSizeCount - 1] of TPaperSizeInfoRec =
  ( (Name: 'A3';        Width: 297.0; Height: 420.0),
    (Name: 'A4';        Width: 210.0; Height: 297.0),
    (Name: 'A5';        Width: 148.0; Height: 210.0),
    (Name: 'Letter';    Width: 215.9; Height: 279.4),
    (Name: 'Tabloid';   Width: 279.4; Height: 431.7),
    (Name: 'Legal';     Width: 215.9; Height: 355.6),
    (Name: 'Executive'; Width: 184.1; Height: 266.7),
    (Name: 'Custom';    Width: 210.0; Height: 297.0)
  );

// Find the index in above table with corresponding AWidth / AHeight, or "Custom"
function DefaultPageIndexFromSize(AWidth, AHeight: single): integer;

implementation

uses
  Dialogs, Forms,
  dtpDocument, dtpStretch, dtpPolygonText, dtpRsRuler; // changed by J.F. Feb 2011

type
  TdtpDocumentAccess = class(TdtpDocument);

function DefaultPageIndexFromSize(AWidth, AHeight: single): integer;
// Find the index in default page table with corresponding AWidth / AHeight, or "Custom"
var
  i: integer;
begin
  Result := cPaperSizeCount - 1;
  for i := 0 to cPaperSizeCount - 2 do
    if ((cPaperSizes[i].Width = AWidth) and (cPaperSizes[i].Height = AHeight)) or    // portrait
       ((cPaperSizes[i].Width = AHeight) and (cPaperSizes[i].Height = AWidth)) then  // landscape
    begin
      Result := i;
      exit;
    end;
end;

{ TdtpPage }

procedure TdtpPage.AddArchiveResourceNames(Names: TStrings);
begin
  inherited;
  BackgroundImage.AddArchiveResourceNames(Names);
end;

function TdtpPage.AddGuide(): TdtpGuide;  // added by J.F. June 2011
begin
  if Assigned(FPageGuides) then
  begin
    FSelectedGuide:= FPageGuides.AddGuide();
    Result:= FSelectedGuide;
  end
  else
    Result:= nil;
end;

procedure TdtpPage.AdjustLeftTop(ALeft, ATop: single);
// This procedure will avoid calling "Changed" when adjusting left/top position of the page
// This in turn avoids calling the UpdateThumbnail from the dtpDocument.
begin
  FDocLeft := ALeft;
  FDocTop  := ATop;
end;

function TdtpPage.AdjustToGrid(APoint: TdtpPoint): TdtpPoint;
// Adjust APoint to the nearest grid point. APoint must be in our own (page) coordinates
begin
  Result := APoint;
  // Adjust to our grid
  if GridSize > 0 then
  begin
    // Snap to the nearest grid point
    Result.X := round(APoint.X / GridSize) * GridSize;
    Result.Y := round(APoint.Y / GridSize) * GridSize;
  end;
end;

function TdtpPage.AdjustToGuides(APoint: TdtpPoint): TdtpPoint; // Changed by J.F. July 2011
// Adjust APoint to the nearest guide(s). APoint must be in our own (page) coordinates

begin
  Result:= FPageGuides.GuidesXYByPoint(APoint);  
end;

procedure TdtpPage.BackgroundImageAfterLoadFromFile(Sender: TObject);
begin
  // Individual image, so no longer default
  IsDefaultPage := False;
  Changed;
end;

procedure TdtpPage.BackgroundImageObjectChanged(Sender: TObject);
begin
  Refresh;
  Changed;
end;

constructor TdtpPage.Create;
begin
  inherited;
  // Create a resource for our background image. It will automatically be destroyed by
  // the shape destructor (so no need to free it in .Destroy here)
  FBackgroundImage := TdtpBitmapResource.Create;
  FBackgroundImage.OnObjectChanged := BackgroundImageObjectChanged;
  FBackgroundImage.OnAfterLoadFromFile := BackgroundImageAfterLoadFromFile;

  FShowBackgroundImage := True;  // added by J.F. Feb 2011

  FPageGuides:= TdtpPageGuides.Create(Self); // added by J.F. Feb 2011

  FSelectedGuide:= nil; // added by J.F. June 2011

  // Defaults
  FIsDefaultPage := True;
  FIsLoaded    := True;
  FPageColor   := cDefaultPageColor;
  FGridColor   := cDefaultGridColor;
  FGridSize    := cDefaultGridSize;

  // Default document size
  DocWidth  := cDefaultPageWidth;
  DocHeight := cDefaultPageHeight;

  // Margins
  FMarginLeft   := cDefaultMarginLeft;
  FMarginRight  := cDefaultMarginRight;
  FMarginTop    := cDefaultMarginTop;
  FMarginBottom := cDefaultMarginBottom;

  // Set curb sizes at the right and bottom a bit bigger to accomodate black borders
  SetCurbSizes(0, 0, cShadowSize, cShadowSize);
end;

destructor TdtpPage.Destroy;
begin
  FreeAndNil(FPageGuides); // added by J.F. Feb 2011
  FreeAndNil(FBackgroundImage);
  FreeAndNil(FThumbnail);
  inherited;
end;

procedure TdtpPage.RenderShapeDirect(Dib: TdtpBitmap; DibRect: TdtpRect; const ADevice: TDeviceContext);
// added by J.F. Feb 2011
begin
  inherited;
  if (assigned(Document)) and (TdtpDocument(Document).GuidesVisible)
       and (TdtpDocument(Document).GuidesToFront) then // changed by J.F. July 2011
    FPageGuides.PaintAllGuides(DIB.Canvas);
end;

function TdtpPage.GetBackgroundBitmap: TdtpBitmap;
begin
  if not IsDefaultPage or not (Document is TdtpDocument) then
    Result := FBackgroundImage.Bitmap
  else
    Result := TdtpDocument(Document).DefaultBackgroundImage.Bitmap;
end;

function TdtpPage.GetBackgroundTiled: boolean;
begin
  if not IsDefaultPage or not (Document is TdtpDocument) then
    Result := FBackgroundTiled
  else
    Result := TdtpDocument(Document).DefaultBackgroundTiled;
end;

function TdtpPage.GetGridColor: TColor;
begin
  if not IsDefaultPage or not (Document is TdtpDocument) then
    Result := FGridColor
  else
    Result := TdtpDocument(Document).DefaultGridColor;
end;

function TdtpPage.GetGridSize: single;
begin
  if not IsDefaultPage or not (Document is TdtpDocument) then
    Result := FGridSize
  else
    Result := TdtpDocument(Document).DefaultGridSize;
end;

function TdtpPage.GetHelperMethod: TdtpHelperMethodType;
begin
  Result := hmNone;
  if Document is TdtpDocument then
    Result := TdtpDocument(Document).HelperMethod;
end;

function TdtpPage.GetIsDefaultPage: boolean;
begin
  LoadPageAsNeeded;
  Result := FIsDefaultPage;
end;

function TdtpPage.GetMarginBottom: single;
begin
  if not IsDefaultPage or not (Document is TdtpDocument) then
    Result := FMarginBottom
  else
    Result := TdtpDocument(Document).DefaultMarginBottom;
end;

function TdtpPage.GetMarginLeft: single;
begin
  if not IsDefaultPage or not (Document is TdtpDocument) then
    Result := FMarginLeft
  else
    Result := TdtpDocument(Document).DefaultMarginLeft;
end;

function TdtpPage.GetMarginRight: single;
begin
  if not IsDefaultPage or not (Document is TdtpDocument) then
    Result := FMarginRight
  else
    Result := TdtpDocument(Document).DefaultMarginRight;
end;

function TdtpPage.GetMarginTop: single;
begin
  if not IsDefaultPage or not (Document is TdtpDocument) then
    Result := FMarginTop
  else
    Result := TdtpDocument(Document).DefaultMarginTop;
end;

function TdtpPage.GetName: string;
begin
  if Length(FName) = 0 then
    Result := Format('Page %d', [PageIndex + 1])
  else
    Result := FName;
end;

function TdtpPage.GetPageColor: TColor;
begin
  if not IsDefaultPage or not (Document is TdtpDocument) then
    Result := FPageColor
  else
    Result := TdtpDocument(Document).DefaultPageColor;
end;

function TdtpPage.GetPageHeight: single;
begin
  Result := DocHeight;
end;

function TdtpPage.GetPageIndex: integer;
begin
  Result := -1;
  if assigned(Document) then
    Result := TdtpDocument(Document).PageIndexOf(Self);
end;

function TdtpPage.GetPageWidth: single;
begin
  Result := DocWidth;
end;

function TdtpPage.GetShowMargins: boolean;
begin
  Result := False;
  if (Document is TdtpDocument) then
    Result := TdtpDocument(Document).ShowMargins;
end;

function TdtpPage.GetThumbnail: TBitmap;
var
  S: double;
  RectWidth, RectHeight: integer;
  R: TRect;
  Doc: TdtpDocument;
  C: TCanvas;
begin
  if IsThumbnailModified or not assigned(FThumbnail) then
  begin
    // Update thumbnail
    FreeAndNil(FThumbnail);
    if assigned(Document) then
    begin
      Doc := TdtpDocument(Document);
      // Load as needed
      LoadPageAsNeeded;
      // Create the bitmap
      FThumbnail := TBitmap.Create;

      FThumbnail.PixelFormat := pf24bit;
      FThumbnail.Width  := Doc.ThumbnailWidth;
      FThumbnail.Height := Doc.ThumbnailHeight;
      FThumbnail.Canvas.Brush.Color := Doc.Color;
      FThumbnail.Canvas.FillRect(FThumbnail.Canvas.ClipRect);

      // Print on the bitmap's canvas
      PrintScreen(FThumbnail.Canvas, Rect(1, 1, FThumbnail.Width - 1, FThumbnail.Height - 1), True);

      // Add a 1pixel black border
      C := FThumbnail.Canvas;
      C.Pen.Color := clBlack;
      C.Brush.Style := bsClear;

      // Determine the correct (aspected) rectangle
      S := Min(FThumbnail.Width / DocWidth, FThumbnail.Height / DocHeight);
      RectWidth    := round(S * DocWidth);
      RectHeight   := round(S * DocHeight);
      R.Left   := (FThumbnail.Width - RectWidth)   div 2;
      R.Right  := R.Left + RectWidth;
      R.Top    := (FThumbnail.Height - RectHeight) div 2;
      R.Bottom := R.Top  + RectHeight;
      C.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    end;
    FIsThumbnailModified := False;
  end;
  Result := FThumbnail;
end;

function TdtpPage.GetThumbnail24Bit(AWidth, AHeight: Integer): TBitmap;
var
  Bmp: Graphics.TBitmap;
begin
  try
    // Create the temp bitmap
    Bmp := TBitmap.Create;

    Bmp.PixelFormat := pf24bit;
    Bmp.Width  := AWidth;
    Bmp.Height := Round((DocHeight / DocWidth) * AWidth);
    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.FillRect(Bmp.Canvas.ClipRect);

    // Print on the bitmap's canvas
    Print(Bmp.Canvas, Rect(0, 0, Bmp.Width, Bmp.Height), 0, 0, False, False);

  except
    // Set the bitmap to nil so the calling function knows
    // there is nothing
    FreeAndNil(Bmp);
  end;

  Result := Bmp;
end;

function TdtpPage.GetViewStyle: TdtpViewStyleType;
begin
  Result := vsNormal;
  if assigned(Document) then
    Result := TdtpDocument(Document).ViewStyle;
end;

procedure TdtpPage.LoadFromXml(ANode: TXmlNodeOld);
var
  Node, Sub: TXmlNodeOld;
  BM: TdtpBitmap;
  Count, I: integer; // added by J.F. Feb 2011
  G: TdtpGuide;
begin
  // this also loads the shapes
  inherited;
  
  FIsDefaultPage := ANode.ReadBool('IsDefaultPage', True);
  if not IsDefaultPage then
  begin
    FMarginLeft   := ANode.ReadFloat('MarginLeft');
    FMarginTop    := ANode.ReadFloat('MarginTop');
    FMarginRight  := ANode.ReadFloat('MarginRight');
    FMarginBottom := ANode.ReadFloat('MarginBottom');
    FGridSize     := ANode.ReadFloat('GridSize');
    FGridColor    := ANode.ReadColor('GridColor', cDefaultGridColor);
    FPageColor    := ANode.ReadColor('PageColor', cDefaultPageColor);
    PageWidth     := ANode.ReadFloat('PageWidth');
    PageHeight    := ANode.ReadFloat('PageHeight');
    // Load resource
    Node := ANode.NodeByName('BackgroundImage');
    if assigned(Node) then
    begin
      // backwards compat
      if assigned(Node.NodeByName('SourceSize')) then
      begin
        // Old method
        BM := TdtpBitmap.Create;
        XmlReadBitmap32(ANode, 'BackgroundImage', BM);
        BackgroundImage.Bitmap := BM;
        BM.Free;
      end else
        // New method
        FBackgroundImage.LoadFromXml(Node);
    end;
    FBackgroundTiled := ANode.ReadBool('BackgroundTiled');
  end;
  Node := ANode.NodeByName('PageGuides'); // added by J.F. Feb 2011
  // Nils - is there a more efficient way of doing this ?
  // NH: I am afraid not, unless creating a subroutine
  if assigned(Node) then
  begin
    Count := Node.ReadInteger('Cnt');
    for i := 0 to Count - 1 do
    begin
      Sub := Node.NodeByName(IntToStr(i));
      G := FPageGuides.AddGuide; // changed by J.F. June 2011
      G.StartPoint.X := Sub.ReadFloat('SPX');
      G.StartPoint.Y := Sub.ReadFloat('SPY');
      G.EndPoint.X := Sub.ReadFloat('EPX');
      G.EndPoint.Y := Sub.ReadFloat('EPY');
    end;
  end;
  if assigned(Document) then
    FPageGuides.GuideColor := TdtpDocument(Document).GuideColor;
  // We must implicitly set FIsThumbModified to False after a load
  FIsThumbnailModified := False;
end;

procedure TdtpPage.LoadPageAsNeeded;
begin
  if not IsLoaded and assigned(Document) then
    // Load ourself
    TdtpDocumentAccess(Document).LoadPageFromXml(PageIndex);
end;

function TdtpPage.MarginRect: TdtpRect;
begin
  Result.Left   := MarginLeft;
  Result.Top    := MarginTop;
  Result.Right  := DocWidth - MarginRight;
  Result.Bottom := DocHeight - MarginBottom;
end;

procedure TdtpPage.DeleteAllGuides;
// added by J.F. Feb 2011
begin
  FPageGuides.DeleteAllGuides();
     // just in case
  FSelectedGuide:= nil; // Added by J.F. June 2011
  Invalidate; // added by J.F. June 2011
  Modified:= true;
end;

procedure TdtpPage.FinishGuideMove(APoint: TdtpPoint);
//  added by J.F. Feb 2011 - changed by J.F. June 2011

begin
  if Assigned(FSelectedGuide) then
  try
    if not FPageGuides.ValidGuidePosition(FSelectedGuide) then
    begin         // erase Guide
      FPageGuides.PaintGuide(TdtpDocumentAccess(Document).Canvas,FSelectedGuide);
      FPageGuides.DeleteGuide(FSelectedGuide);
    end
    else
      Modified := true;
  finally
    FSelectedGuide := nil;
    Invalidate;
  end;
  Windows.SetCursor(Screen.Cursors[crDefault]); // changed by J.F. June 2011
end;

procedure TdtpPage.MoveGuide(Guide: TdtpGuide; NewPosition: single);  // added by J.F. June 2011
var
  TempGuide: TdtpGuide;
begin
  if Assigned(Guide) then
  try
    TempGuide:= TdtpGuide.Create;
    TempGuide.StartPoint:= Guide.StartPoint;
    TempGuide.EndPoint:= Guide.EndPoint;
    FPageGuides.UpdateGuide(TempGuide, NewPosition);
    if FPageGuides.ValidGuidePosition(TempGuide) then
    begin
      FPageGuides.UpdateGuide(Guide, NewPosition);
      Invalidate;
    end;
  finally
    FreeAndNil(TempGuide);
  end;
end;

procedure TdtpPage.MoveSelectedGuide(APoint: TdtpPoint);
// added by J.F. Feb 2011 - changed by J.F. June 2011
var
  NewPosition: single; // added by J.F. June 2011
begin
  if Assigned(FSelectedGuide) then
  begin
    try
      // erase original guide position
      FPageGuides.PaintGuide(TdtpDocumentAccess(Document).Canvas,FSelectedGuide); //changed by J.F. June 2011

      if not FSelectedGuide.IsVertical then  // changed by J.F. June 2011
      begin
        // Horizontal
        if Windows.GetCursor = Screen.Cursors[crNoDrop] then  // added by J.F. June 2011
          Windows.SetCursor(Screen.Cursors[crDtpHorizGuide]);
        NewPosition := APoint.Y; // added by J.F. June 2011
      end
      else
      begin
        if Windows.GetCursor = Screen.Cursors[crNoDrop] then  // added by J.F. June 2011
          Windows.SetCursor(Screen.Cursors[crDtpVertGuide]);
        NewPosition:= APoint.X;  // added by J.F. June 2011
      end;
      // new position
      FPageGuides.UpdateGuide(FSelectedGuide, NewPosition);  // changed by J.F. June 2011

      // draw guide in new position
      FPageGuides.PaintGuide(TdtpDocumentAccess(Document).Canvas, FSelectedGuide); // changed by J.F. June 2011

    except
      Windows.SetCursor(Screen.Cursors[crDefault]);
      if Assigned(FSelectedGuide) then
        FPageGuides.DeleteGuide(FSelectedGuide);
      FSelectedGuide := nil;
      Invalidate;
    end;
  end;
end;

procedure TdtpPage.MoveSelectedMargin(APoint: TdtpPoint); // added by J.F. July 2011

begin
  if FSelectedMargin <> smNone then
  begin
    try
      if FSelectedMargin in [smTop, smBottom] then
      begin
        if Windows.GetCursor = Screen.Cursors[crNoDrop] then
          Windows.SetCursor(Screen.Cursors[crDtpHorizGuide]);
        if FSelectedMargin = smTop then
          MarginTop:= APoint.Y
        else
          MarginBottom:= DocHeight - APoint.Y;
      end
      else
      begin
        if Windows.GetCursor = Screen.Cursors[crNoDrop] then
          Windows.SetCursor(Screen.Cursors[crDtpVertGuide]);
        if FSelectedMargin = smLeft then
          MarginLeft:= APoint.X
        else
          MarginRight:= DocWidth - APoint.X;
      end;
    except
      Windows.SetCursor(Screen.Cursors[crDefault]);
      FSelectedMargin:= smNone;
      Invalidate;
    end;
  end;
end;

function TdtpPage.ValidMarginPosition(const MarginPosition: TdtpPoint): boolean;  //  added by J.F. June 2011
begin
  Result:= not ((MarginPosition.X < 0.0) or ( MarginPosition.X > DocWidth) or
                (MarginPosition.Y < 0.0) or ( MarginPosition.Y > DocHeight));
  if Result then
  case FSelectedMargin of
    smLeft: Result:= MarginPosition.X < DocWidth - FMarginRight - 2;
    smTop: Result:= MarginPosition.Y < DocHeight - FMarginBottom - 2;
    smRight: Result:= MarginPosition.X > FMarginLeft + 2;
    smBottom: Result:= MarginPosition.Y > FMarginTop + 2;
  end;
  
end;

procedure TdtpPage.SetGuideColor(Value: TColor);
// Added by J.F. Feb 2011
begin
  FPageGuides.GuideColor := Value;
end;

function TdtpPage.StartGuideMove(APoint: TdtpPoint): boolean;
// added by J.F. Feb 2011 - changed by J.F. June 2011

begin
  Result:= false; // added by J.F. June 2011
  try
    FSelectedGuide := FPageGuides.GuideByPoint(APoint);  // changed by J.F. June 2011
    if Assigned(FSelectedGuide) then // added by J.F. June 2011
    begin
      if FSelectedGuide .IsVertical then  // changed by J.F. June 2011
        Windows.SetCursor(Screen.Cursors[crDtpVertGuide])
      else
        Windows.SetCursor(Screen.Cursors[crDtpHorizGuide]);

      Result:= true;  //  added by J.F. June 2011
    end;
  except
    FSelectedGuide:= nil;
    Windows.SetCursor(Screen.Cursors[crDefault]);
  end;

end;

function TdtpPage.IsMarginSelected(APoint: TdtpPoint): boolean;  //  added by J.F. July 2011
var
  TestRight, TestBottom: single;
begin
  TestRight:= DocWidth - FMarginRight;
  TestBottom:= DocHeight - FMarginBottom;
  Result:= true;
  FSelectedMargin:= smNone;
  try
    if (FMarginLeft > APoint.X - cDefaultHitSensitivity) and (FMarginLeft < APoint.X + cDefaultHitSensitivity)
       and (APoint.Y > FMarginTop) and (APoint.Y < TestBottom) then
       FSelectedMargin:= smLeft
    else
    if (TestRight > APoint.X - cDefaultHitSensitivity) and (TestRight < APoint.X + cDefaultHitSensitivity)
       and (APoint.Y > FMarginTop) and (APoint.Y < TestBottom) then
       FSelectedMargin:= smRight
    else
    if (FMarginTop > APoint.Y - cDefaultHitSensitivity) and (FMarginTop < APoint.Y + cDefaultHitSensitivity)
       and (APoint.X > FMarginLeft) and (APoint.X < TestRight) then
       FSelectedMargin:= smTop
    else
    if (TestBottom > APoint.Y - cDefaultHitSensitivity) and (TestBottom < APoint.Y + cDefaultHitSensitivity)
       and (APoint.X > FMarginLeft) and (APoint.X < TestRight) then
       FSelectedMargin:= smBottom
    else
      Result:= false;
  except
    Result:= false;
    Windows.SetCursor(Screen.Cursors[crDefault]);
  end;
end;

function TdtpPage.StartMarginMove(APoint: TdtpPoint): boolean; // added by J.F. July 2011

begin
  Result:= IsMarginSelected(APoint);
  try
    if Result then
    begin
      if FSelectedMargin in [smTop, smBottom] then
        Windows.SetCursor(Screen.Cursors[crDtpHorizGuide])
      else
        Windows.SetCursor(Screen.Cursors[crDtpVertGuide]);
    end;
  except
    FSelectedMargin:= smNone;
    Windows.SetCursor(Screen.Cursors[crDefault]);
  end;
end;

function TdtpPage.GetGuideCount:integer;
begin
  Result:= FPageGuides.GuideCount;
end;

function TdtpPage.GetGuideAtPoint(APoint: TdtpPoint): TdtpGuide;  // added by J.F. June 2011
begin
  Result := FPageGuides.GuideByPoint(APoint);
end;

procedure TdtpPage.PaintDib(Dib: TdtpBitmap; const ADevice: TDeviceContext);
// Paint the page, including small black border, shadow, margins and grid.
// This overridden Paint procedure demonstrates that we can paint on DIB,
// in this case more convenient.
const
  Colors: array [0..1] of TdtpColor = ($FFFFFFFF, $FFB0B0B0);
var
  Doc: TdtpDocument;
  PageLT, PageRB, EdgeRB,
  MarginLT, MarginRB: TPoint;
  Pos1, Pos2: TPoint;
  ShadowSize: integer;
  i: integer;
  // For painting checker pattern
  Lft, Top, Rgt, Btm, j, Parity: Integer;
  Line1, Line2: TArrayOfdtpColor; // a buffer for a couple of scanlines
  RCount, CCount: integer;
  HorzDots, VertDots: array of integer;
  C: TdtpColor;
  ImgSize: TPoint;
  DestR, PageRect, ClipR, SrcR: TRect;
  BB: TdtpBitmap;
  RightOffset, LeftOffset: integer; // added by J.F. Feb 2011
begin
  inherited;

  RightOffset := 0;             // changed by J.F. Apr 2011
  LeftOffset := integer((TdtpDocument(Document).BorderStyle = bsSingle ) and (ViewStyle = vsNormal));
  if assigned(Document) then   // added by J.F. Feb 2011
    if (ViewStyle = vsPrintLayout) then     // part of ruler fix
    begin
      RightOffset := integer((TdtpDocument(Document).ShowPageShadow));
      LeftOffset := integer(not (TdtpDocument(Document).ShowPageShadow));
    end;

  // Get some important points in canvas coords
  PageLT   := ShapeToPoint(dtpPoint(0                     , 0                       ));
  PageRB   := ShapeToPoint(dtpPoint(DocWidth              , DocHeight               ));
  inc(PageLT.X, LeftOffset);  // added by J.F. Feb 2011
  inc(PageLT.Y, LeftOffset);  // added by J.F. Apr 2011
  inc(PageRB.X, RightOffset); // added by J.F. Feb 2011  // these are part of ruler fix
  inc(PageRB.Y, RightOffset); // added by J.F. Feb 2011
  PageRect := Rect(PageLT.X, PageLT.Y, PageRB.X, PageRB.Y);
  EdgeRB   := ShapeToPoint(dtpPoint(DocWidth + cShadowSize, DocHeight + cShadowSize ));
  inc(EdgeRB.X, RightOffset); // added by J.F. Feb 2011  // these are part of ruler fix
  inc(EdgeRB.Y, RightOffset); // added by J.F. Feb 2011
  MarginLT := ShapeToPoint(dtpPoint(MarginLeft            , MarginTop               ));
  MarginRB := ShapeToPoint(dtpPoint(DocWidth - MarginRight, DocHeight - MarginBottom));
  ShadowSize := EdgeRB.X - PageRB.X;

  // Draw the page
  if (ADevice.DeviceType = dtScreen) and (HelperMethod = hmPattern) then
  begin

    // Draw Checker Pattern like Photoshop
    Lft := Max(0, PageLT.X);
    // added by J.F. Feb 2011 fixes out of range exception when Rgt is less then 0
    Rgt := Max(0, Min(DIB.Width,  PageRB.X));
    Top := Max(0, PageLT.Y);
    Btm := Min(DIB.Height, PageRB.Y);
    SetLength(Line1, Rgt);
    SetLength(Line2, Rgt);
    for i := Lft to Rgt - 1 do
    begin
      Parity := (i-PageLT.X) shr 3 and $1;
      Line1[i] := Colors[Parity];
      Line2[i] := Colors[1 - Parity];
    end;
    for j := Top to Btm - 1 do
    begin
      Parity := (j - PageLT.Y) shr 3 and $1;
      if Boolean(Parity) then
        MoveLongword(Line1[Lft], DIB.PixelPtr[Lft, j]^, Rgt - Lft)
      else
        MoveLongword(Line2[Lft], DIB.PixelPtr[Lft, j]^, Rgt - Lft);
    end;
    Finalize(Line1); // added by J.F. Feb 2011  Free dynamic array
    Finalize(Line2); // added by J.F. Feb 2011
  end else
  begin

    BB := GetBackgroundBitmap;

    // Draw a sheet with page color, also on printer
    if ADevice.DeviceType <> dtTransparent then
      DIB.FillRectS(PageLT.X, PageLT.Y, PageRB.X, PageRB.Y, dtpColor(PageColor));
    if (assigned(BB)) and (FShowBackgroundImage) then  // changed by J.F. Feb 2011
    begin
      // Make sure to have adequate quality
      SetStretchFilter(BB, ADevice.Quality);
      SetDrawMode(BB, dtpdmBlend);
      // Draw a sheet with the background image
      if BackgroundTiled then
      begin
        // Draw a tiled background
        ImgSize := ShapeToPoint(dtpPoint(BB.Width / cLowPrinterDpm, BB.Height /  cLowPrinterDpm));
        ImgSize.X := ImgSize.X - PageLT.X;
        ImgSize.Y := ImgSize.Y - PageLT.Y;
        for i := 0 to ceil((PageRB.Y - PageLT.Y) / ImgSize.Y) do
          for j := 0 to ceil((PageRB.X - PageLT.X) / ImgSize.X) do
          begin
            // Destination rect
            DestR := Rect(
              PageLT.X +  j      * ImgSize.X, PageLT.Y +  i      * ImgSize.Y,
              PageLT.X + (j + 1) * ImgSize.X, PageLT.Y + (i + 1) * ImgSize.Y);
            // Clip with page rectangle, result in R
            IntersectRect(ClipR, DestR, PageRect);
            if IsRectEmpty(ClipR) then
              continue;
            // Determine source rectangle
            SrcR := Rect(0, 0,
              round((ClipR.Right - ClipR.Left) / (DestR.Right - DestR.Left) * BB.Width),
              round((ClipR.Bottom - ClipR.Top) / (DestR.Bottom - DestR.Top) * BB.Height));
            BB.DrawTo(DIB, ClipR, SrcR);
          end;
      end
      else
        // Draw a stretched background
        // changed by J.F. Feb 2011
        BB.DrawTo(DIB, Rect(PageLT.X - LeftOffset, PageLT.Y, PageRB.X - RightOffset, PageRB.Y - RightOffset));
    end;
  end;

  if assigned(Document) then
  begin
    Doc := TdtpDocument(Document);
    if assigned(Doc.OnPaintBackground) and assigned(DIB) then
    begin
      {Canv := TCanvas.Create;
      try
        Canv.Handle := DIB.Handle;
        InvertAlpha(DIB);
        TdtpDocumentAccess(Document).DoPaintBackground(Canv, ADevice, PageRect);
        InvertAlpha(DIB);
      finally
        Canv.Free;
      end;}
      // changed by J.F. Feb 2011 - Don't think temp canvas needed ?????
      // NH: can probably be removed but I am not sure, can remember there was a catch.. must be tested
      InvertAlpha(DIB);
      TdtpDocumentAccess(Document).DoPaintBackground(DIB.Canvas, ADevice, PageRect);
      InvertAlpha(DIB);
    end;
  end;

  if (ADevice.DeviceType = dtScreen) then
  begin
    // Grid
    if (HelperMethod = hmGrid) and (GridSize > 0) then
    begin
      // Vertical
      // Changed by J.F. Feb 2011 make sure we draw last line
      for i := 1 to trunc(DocWidth / GridSize) do
      begin
        Pos1 := ShapeToPoint(dtpPoint(i * GridSize, 0        ));
        Pos2 := ShapeToPoint(dtpPoint(i * GridSize, DocHeight));
        if Pos2.X < PageRect.Right then   // changed by J.F. Apr 2011
          Dib.VertLineS(Pos1.X, Pos1.Y + 1, Pos2.Y - 1, dtpColor(GridColor));
      end;
      // Horizontal
      // Changed by J.F. Feb 2011 make sure we draw last line
      for i := 1 to trunc(DocHeight / GridSize) do
      begin
        Pos1 := ShapeToPoint(dtpPoint(0,        i * GridSize));
        Pos2 := ShapeToPoint(dtpPoint(DocWidth, i * GridSize));
        if Pos2.Y < PageRect.Bottom then  // changed by J.F. Apr 2011
          Dib.HorzLineS(Pos1.X + 1, Pos1.Y, Pos2.X - 1, dtpColor(GridColor));
      end;
    end;

    // Dots
    if (HelperMethod = hmDots) and (GridSize > 0) then
    begin
      // Horizontal indices
      CCount := trunc(DocWidth / GridSize);
      SetLength(HorzDots, CCount);
      for i := 1 to CCount do
        HorzDots[i - 1] := ShapeToPoint(dtpPoint(i * GridSize, 0)).X;
      // Vertical indices
      RCount := trunc(DocHeight / GridSize);
      SetLength(VertDots, RCount);
      for i := 1 to RCount do
        VertDots[i - 1] := ShapeToPoint(dtpPoint(0, i * GridSize)).Y;
      // Draw dots
      C := dtpColor(GridColor);
      for i := 0 to RCount - 1 do
        for j := 0 to CCount - 1 do
          DIB.Pixels[HorzDots[j], VertDots[i]] := C;
    end;

    // Margins
    if ShowMargins then
    begin
      DIB.SetStipple([dtpColor(clWhite), dtpColor(clBlack)]);
      DIB.StippleStep := 0.5;
      DIB.FrameRectTSP(MarginLT.X, MarginLT.Y, MarginRB.X + 1, MarginRB.Y + 1);
    end;

    if not assigned(Parent) then
    begin
      // Black single pixel border plus shadows
      // changed by J.F. Feb 2011
      if (ViewStyle = vsPrintLayout) and (TdtpDocument(Document).ShowPageShadow) then
      begin
        // changed by J.F. Feb 2011
        DIB.FrameRectS(PageLT.X, PageLT.Y, PageRB.X, PageRB.Y, TdtpDocument(Document).PageShadowColor);
        // 1 mm border
        // for ex. clLightGray32
        DIB.FillRectS(PageLT.X + ShadowSize, PageRB.Y, EdgeRB.X, EdgeRB.Y, TdtpDocument(Document).PageShadowColor);
        DIB.FillRectS(PageRB.X, PageLT.Y + ShadowSize, EdgeRB.X, PageRB.Y, TdtpDocument(Document).PageShadowColor);
      end;
    end;

    // added by J.F. June 2011 - put here so if guide is equal to page border it will show
    if (assigned(Document)) and (TdtpDocument(Document).GuidesVisible) // changed by J.F. July 2011
       and (not TdtpDocument(Document).GuidesToFront) then
      FPageGuides.PaintAllGuides(DIB.Canvas);
  end;

end;

procedure TdtpPage.PaintForeground(DIB: TdtpBitmap; const ADevice: TDeviceContext);
var
  PageLT, PageRB: TPoint;
  PageRect: TRect;
  RightOffset, LeftOffset: integer; // added by J.F. Apr 2011
begin
  // Only do this paint stage if we have the event
  if assigned(Document) then
  begin
    if assigned(TdtpDocument(Document).OnPaintForeground) and assigned(DIB) then
    begin

      RightOffset := 0;
      LeftOffset := 0;
      if assigned(Document) then   // added by J.F. Apr 2011
        if (ViewStyle = vsPrintLayout) then     // part of ruler fix
        begin
          RightOffset := integer((TdtpDocument(Document).ShowPageShadow));
          LeftOffset := integer(not (TdtpDocument(Document).ShowPageShadow));
        end;

      // Rectangle
      PageLT   := ShapeToPoint(dtpPoint(0       , 0        ));
      PageRB   := ShapeToPoint(dtpPoint(DocWidth, DocHeight));

      inc(PageLT.X, LeftOffset);  // added by J.F. Apr 2011
      inc(PageRB.X, RightOffset); // added by J.F. Apr 2011  // these are part of ruler fix
      inc(PageRB.Y, RightOffset); // added by J.F. Apr 2011

      PageRect := Rect(PageLT.X, PageLT.Y, PageRB.X, PageRB.Y);
      // changed by J.F. Feb 2011 - Don't think Temp Canvas needed ?????
      // NH: lets just do without :)
      InvertAlpha(DIB);
      TdtpDocumentAccess(Document).DoPaintForeground(DIB.Canvas, ADevice, PageRect);
      InvertAlpha(DIB);
    end;
  end;
end;

procedure TdtpPage.Print(PrinterCanvas: TCanvas; ARect: TRect; Resolution: single; Rotation: integer; PrintMirrored, PrintFlipped: boolean);
// Print a page to the printers Canvas, positioning at Rect, use Mirrored for mirroring the print.

// When Resolution is 0, this routine uses the printer's maximum resolution. Otherwise, it uses
// the resolution provided (which should be given in Dots Per MM(!).

// Rotation indicates the paper position so that a textout of "F" generates:

//    0            1            2           3

//  X X X      X                  X      X X X X X
//  X          X   X              X          X   X
//  X X        X X X X X        X X              X
//  X                             X
//  X                         X X X

var
  Doc: TdtpDocumentAccess;
  PRectLeft, PRectTop, PRectWidth, PRectHeight: integer;
  PRect, DRect: TRect;
  R: single;
  DC: TDeviceContext;

  // Local procedure: subdivide the rectangle if it is too big, or print it
  procedure DivideOrPrint(A, B: single; APrintRect, ADocRect: TRect);
  // PrintRect is the printer rectangle, DocRect is our document rectangle
  var
    PrintWidth, PrintHeight: integer;
    DocWidth, DocHeight: integer;
    NewPrintRect, NewDocRect: TRect;
  begin
    PrintWidth  := APrintRect.Right - APrintRect.Left;
    PrintHeight := APrintRect.Bottom - APrintRect.Top;
    DocWidth  := ADocRect.Right - ADocRect.Left;
    DocHeight := ADocRect.Bottom - ADocRect.Top;
    if DocWidth * DocHeight > cBitmapPrintSizeLimit then
    begin
      // Too big, so recursively call DivideOrPrint
      if DocWidth > DocHeight then
      begin
        NewPrintRect := Rect(APrintRect.Left, APrintRect.Top, APrintRect.Left + PrintWidth div 2, APrintRect.Bottom);
        NewDocRect := Rect(ADocRect.Left, ADocRect.Top, ADocRect.Left + DocWidth div 2, ADocRect.Bottom);
        DivideOrPrint(A, (A + B)/2, NewPrintRect, NewDocRect);
        NewPrintRect := Rect(APrintRect.Left + PrintWidth div 2, APrintRect.Top, APrintRect.Right, APrintRect.Bottom);
        NewDocRect := Rect(ADocRect.Left + DocWidth div 2, ADocRect.Top, ADocRect.Right, ADocRect.Bottom);
        DivideOrPrint((A + B)/2, B, NewPrintRect, NewDocRect);
      end else
      begin
        NewPrintRect := Rect(APrintRect.Left, APrintRect.Top, APrintRect.Right, APrintRect.Top + PrintHeight div 2);
        NewDocRect := Rect(ADocRect.Left, ADocRect.Top, ADocRect.Right, ADocRect.Top + DocHeight div 2);
        DivideOrPrint(A, (A + B)/2, NewPrintRect, NewDocRect);
        NewPrintRect := Rect(APrintRect.Left, APrintRect.Top + PrintHeight div 2, APrintRect.Right, APrintRect.Bottom);
        NewDocRect := Rect(ADocRect.Left, ADocRect.Top + DocHeight div 2, ADocRect.Right, ADocRect.Bottom);
        DivideOrPrint((A + B)/2, B, NewPrintRect, NewDocRect);
      end;
    end else
    begin
      // Print
      PrintRectangle(PrinterCanvas, APrintRect, ADocRect, ARect, Rotation, PrintMirrored, PrintFlipped, DC);
      if Doc.ProgressTotal > 0 then
        Doc.DoProgress(ptPrint, Doc.ProgressCount, Doc.ProgressTotal, (Doc.ProgressCount - 1 + B) / Doc.ProgressTotal);
    end;
  end;
// main
begin
  LoadPageAsNeeded;
  if not assigned(Document) then
    exit;
  Doc := TdtpDocumentAccess(Document);
  Doc.BeginPrinting;

  try

    // Printing presets
    DocAngle := 0;

    // If landscape (1 or 3) then we must transpose the rectangle
    if (Rotation = 1) or (Rotation = 3) then
    begin
      PRectWidth   := ARect.Right  - ARect.Left;
      PRectHeight  := ARect.Bottom - ARect.Top;
      ARect.Right  := ARect.Left + PRectHeight;
      ARect.Bottom := ARect.Top  + PRectWidth;
    end;

    // Find resolution to use
    R := Min(
      (ARect.Right - ARect.Left) / DocWidth,
      (ARect.Bottom - ARect.Top) / DocHeight);
    if Resolution = 0 then
      Resolution := R;

    // Construct optimal rectangle - do not print too much

    // Printer Rectangle
    PRectWidth   := round(R * DocWidth);
    PRectLeft    := (ARect.Right - ARect.Left - PRectWidth) div 2;
    PRectHeight  := round(R * DocHeight);
    PRectTop     := (ARect.Bottom - ARect.Top - PRectHeight) div 2;
    PRect.Left   := ARect.Left + PRectLeft;
    PRect.Right  := PRect.Left + PRectWidth;
    PRect.Top    := ARect.Top  + PRectTop;
    PRect.Bottom := PRect.Top  + PRectHeight;

    // Document Rectangle
    DRect.Left   := 0;
    DRect.Right  := round(Resolution * DocWidth);
    DRect.Top    := 0;
    DRect.Bottom := round(Resolution * DocHeight);

    // Render at exactly the same dpm - so we can use "BitmapBlendTo". This looks
    // best on patterns etc. Also, the DrawTo method of Bitmap32 still has a slight
    // problem with Alpha = 255 and colors shining through in modes sfLinear2 and
    // sfSpline, so sfLinear is a good choice.
    DC.DeviceType := dtPrinter;
    DC.Background := SetAlpha(dtpColor(PageColor), 0);
    DC.ActualDpm := Resolution;
    DC.CacheDpm := Resolution;
    DC.Quality := Doc.Quality;
    DC.DropCacheAfterRender := False;
    DC.ForceResolution := False;

    // Divide and conquer algorithm to print in parts. We divide the biggest side
    // and see if it fits the size, if not we subdivide further recursively
    DivideOrPrint(0, 1, PRect, DRect);
    {$IFDEF TRIAL}{$I TRIALDTP2.INC}{$ENDIF} // Trial version protection

    // Drop the cache once done
    if Doc.Performance = dpMemoryOverSpeed then
      CacheDrop;

  finally
    Doc.EndPrinting;
  end;
end;

procedure TdtpPage.PrintFast(PrinterCanvas: TCanvas; ARect: TRect; Rotation: integer; PrintMirrored, PrintFlipped: boolean);
// PrintFast just calls "Print" with the lowest resolution
begin
  Print(PrinterCanvas, ARect, cLowPrinterDpm, Rotation, PrintMirrored, PrintFlipped);
end;

procedure TdtpPage.PrintRectangle(PrinterCanvas: TCanvas; PRect, DRect, Orig: TRect; Rotation: integer;
  PrintMirrored, PrintFlipped: boolean; Device: TDeviceContext);
// Prints a rectangle to the Canvas provided.
// PRect: printer rectangle
// DRect: destination rectangle
// Orig: original rectangle
// Rotation: 0, 1, 2, 3 indicating 0, 90, 180, 270 degrees
// PrintMirrored: mirror horizontally
// PrintFlipped: mirror vertically
var
  Lft, Rgt, Top, Btm, W, H,
  DRectWidth, DRectHeight,
  PRectWidth, PRectHeight: integer;
  B: TdtpBitmap;
  tmpBool: boolean;
  Inf: TBitmapInfo;
  FR: TdtpRect;
begin
  // Create a DIB
  B := TdtpBitmap.Create;
  try

    // Sizes
    DRectWidth  := DRect.Right - DRect.Left;
    DRectHeight := DRect.Bottom - DRect.Top;
    PRectWidth  := PRect.Right - PRect.Left;
    PRectHeight := PRect.Bottom - PRect.Top;

    // Set bitmap size
    B.SetSize(DRectWidth, DRectHeight);

    // Tell the shape to paint itself
    FR.Left := DRect.Left / Device.ActualDpm;
    FR.Top := DRect.Top / Device.ActualDpm;
    FR.Right := DRect.Right / Device.ActualDpm;
    FR.Bottom := DRect.Bottom / Device.ActualDpm;

    RenderShape(B, FR, Device, True);

    if TdtpDocument(Document).OptimizedPrinting then
      if IsBitmapSingleColor(B, dtpColor(PageColor)) then
        exit;

    // We now have a valid copy, create correct page orientation
    case Rotation of
    0:; // nothing to do
    1: DIBRotate90(B);
    2: DIBRotate180(B);
    3: DIBRotate270(B);
    end;

    // Mirroring and flipping of the print (on fabrics, etc)
    if PrintMirrored then
      DIBMirror(B);
    // Here we toggle because we print the bitmap upside down if to the printer canvas
    if not PrintFlipped then
      DIBFlip(B);

    // Flipping becomes mirroring etc for landscape
    if (Rotation = 1) or (Rotation = 3) then
    begin
      tmpBool := PrintMirrored;
      PrintMirrored := PrintFlipped;
      PrintFlipped := tmpBool;
    end;

    // Move from left to right or top to bottom when mirroring or flipping
    if PrintMirrored then
    begin
      // Adapt rectangle
      Rgt := Orig.Right + Orig.Left - PRect.Left;
      Lft := Orig.Right + Orig.Left - PRect.Right;
      PRect.Left  := Lft;
      PRect.Right := Rgt;
    end;
    if PrintFlipped  then
    begin
      // Adapt rectangle
      Btm := Orig.Bottom + Orig.Top - PRect.Top;
      Top := Orig.Bottom + Orig.Top - PRect.Bottom;
      PRect.Top    := Top;
      PRect.Bottom := Btm;
    end;

    // Determine the point where we are drawing
    Lft := 0;
    Top := 0;
    W  := 0;
    H := 0;
    case Rotation of
    0: // No rotation
      begin
        Lft := PRect.Left;
        Top := PRect.Top;
        W := PRectWidth;
        H := PRectHeight;
      end;
    1: // 90 rotated
      begin
        Lft := Orig.Left + PRect.Top - Orig.Top;
        Top := Orig.Top  + Orig.Right  - PRect.Left - PRectWidth;
        W := PRectHeight;
        H := PRectWidth;
      end;
    2: // 180 rotated
      begin
        Lft := Orig.Left + Orig.Right  - PRect.Left - PRectWidth;
        Top := Orig.Top  + Orig.Bottom - PRect.Top  - PRectHeight;
        W := PRectWidth;
        H := PRectHeight;
      end;
    3: // 270 rotated
      begin
        Lft := Orig.Left + Orig.Bottom - PRect.Top - PRectHeight;
        Top := Orig.Top  + PRect.Left - Orig.Left;
        W := PRectHeight;
        H := PRectWidth;
      end;
    end;

    // Use DIB (= printer) safe stretch function
    Inf := B.BitmapInfo;

    // Change bitmap info so we're Bottom-up (safer)
    with Inf.bmiHeader do
      biHeight := -biHeight;

    SetStretchBltMode(PrinterCanvas.Handle, HALFTONE);
    StretchDIBits(PrinterCanvas.Handle,
      Lft, Top, W, H, 0, 0, B.Width, B.Height,
      B.Bits, Inf, DIB_RGB_COLORS, SRCCOPY);

  finally
    B.Free;
  end;
end;

procedure TdtpPage.PrintScreen(PrinterCanvas: TCanvas; Rect: TRect; PreserveAspect: boolean; AMaxRes: single = cLowPrinterDpm);
// Make a screen copy onto ACanvas, fitting in Rect. This does usually not require
// setting RenderDpm therefore the cache can be preserved and this procedure
// is therefore much faster as Print().
// If PreserveAspect is True, the resulting image in ACanvas will have preserved
// aspect ratio (bars may appear in final image)
var
  Doc: TdtpDocumentAccess;
  PrintR: TRect;
  B, D: TdtpBitmap;
  Inf: TBitmapInfo;
  S: double;
  RectWidth, RectHeight: integer;
  DC: TDeviceContext;
begin
  LoadPageAsNeeded;
  if not assigned(Document) then
    exit;
  Doc := TdtpDocumentAccess(Document);
  Doc.BeginPrinting;

  // Store current settings
  try
    // Printing presets
    DC.DeviceType := dtPrinter;
    DC.Background := SetAlpha(dtpColor(PageColor), 0);
    DC.ActualDpm := Doc.ScreenDpm;
    DC.CacheDpm := Min(AMaxRes, Doc.ScreenDpm);
    DC.Quality := Doc.Quality;
    DC.DropCacheAfterRender := False;
    DC.ForceResolution := False;

    // Construct print rectangle
    PrintR.Left   := 0;
    PrintR.Top    := 0;
    PrintR.Right  := round(Doc.ScreenDpm * DocWidth);  // changes BHE
    PrintR.Bottom := round(Doc.ScreenDpm * DocHeight); // changes BHE

    RectWidth  := PrintR.Right;
    RectHeight := PrintR.Bottom;
    if PreserveAspect then
    begin

      // Adjust Rect, so we print with correct aspect ratio
      S := Min(
        (Rect.Right  - Rect.Left) / PrintR.Right,
        (Rect.Bottom - Rect.Top ) / PrintR.Bottom);
      RectWidth   := round(S * PrintR.Right);
      RectHeight  := round(S * PrintR.Bottom);
      Rect.Left   := Rect.Left + (Rect.Right  - Rect.Left - RectWidth)  div 2;
      Rect.Right  := Rect.Left + RectWidth;
      Rect.Top    := Rect.Top  + (Rect.Bottom - Rect.Top  - RectHeight) div 2;
      Rect.Bottom := Rect.Top  + RectHeight;
    end;

    // Create an intermediate DIB
    B := TdtpBitmap.Create;
    try

      // Set bitmap size
      B.SetSize(PrintR.Right, PrintR.Bottom);

      // Set device to dtPrinter
      if Document is TdtpDocument then
        TdtpDocument(Document).Device := dtPrinter;

      // Tell the shape to paint itself
      RenderShape(B, dtpRect(0, 0, DocWidth, DocHeight), DC, True);

      // For downsampling: use a good quality resample, otherwise just use
      // StretchDIBits directly
      if RectWidth * RectHeight < B.Width * B.Height then
      begin

        // Separate resampled bitmap ADest
        D := TdtpBitmap.Create;
        try
          // Create of correct size
          D.SetSize(RectWidth, RectHeight);

          // Call our own StretchTransferEx
          StretchTransferEx(
            D, Classes.Rect(0, 0, RectWidth, RectHeight),
            B, PrintR,
            dtpsfLinear,
            dtpdmOpaque,
            nil);

          // we print the bitmap upside down
          DIBFlip(D);

          // Use DIB (= printer) safe stretch function
          Inf := D.BitmapInfo;

          // Change bitmap info so we're Bottom-up (safer)
          with Inf.bmiHeader do
            biHeight := -biHeight;

          // Use StretchDIBits to stretch copy to the (printer) canvas
          StretchDIBits(PrinterCanvas.Handle,
            Rect.Left, Rect.Top, RectWidth, RectHeight,
            0, 0, RectWidth, RectHeight,
            D.Bits,
            Inf,
            DIB_RGB_COLORS,
            SRCCOPY);

        finally
          D.Free;
        end;

      end else
      begin

        // we print the bitmap upside down
        DIBFlip(B);

        // Use DIB (= printer) safe stretch function
        Inf := B.BitmapInfo;

        // Change bitmap info so we're Bottom-up (safer)
        Inf.bmiHeader.biHeight := -Inf.bmiHeader.biHeight;

        // Non-quality resize
        SetStretchBltMode(PrinterCanvas.Handle, HALFTONE);
        StretchDIBits(PrinterCanvas.Handle,
          Rect.Left, Rect.Top, RectWidth, RectHeight,
          0, 0, B.Width, B.Height,
          B.Bits,
          Inf,
          DIB_RGB_COLORS,
          SRCCOPY);

      end;
    finally
      B.Free;
    end;
    {$IFDEF TRIAL}{$I TRIALDTP2.INC}{$ENDIF} // Trial version protection

  finally
    Doc.EndPrinting;
  end;
end;

procedure TdtpPage.SaveToXml(ANode: TXmlNodeOld);
var
  Node, Sub: TXmlNodeOld;
  i: integer;
  Guide: TdtpGuide;
begin
  ANode.WriteBool('IsDefaultPage', FIsDefaultPage, True);
  if not IsDefaultPage then
  begin
    ANode.WriteFloat('MarginLeft', FMarginLeft);
    ANode.WriteFloat('MarginTop', FMarginTop);
    ANode.WriteFloat('MarginRight', FMarginRight);
    ANode.WriteFloat('MarginBottom', FMarginBottom);
    ANode.WriteFloat('GridSize', FGridSize);
    ANode.WriteColor('GridColor', FGridColor, cDefaultGridColor);
    ANode.WriteColor('PageColor', FPageColor, cDefaultPageColor);
    ANode.WriteFloat('PageWidth', PageWidth);
    ANode.WriteFloat('PageHeight', PageHeight);
    if assigned(FBackgroundImage.Bitmap) then
      FBackgroundImage.SaveToXml(ANode.NodeNew('BackgroundImage'));
    ANode.WriteBool('BackgroundTiled', FBackgroundTiled);
  end;
  // added by J.F. Feb 2011
  if FPageGuides.GuideCount > 0 then
  begin
    Node:= ANode.NodeNew('PageGuides');
    if Assigned(Node) then
    begin
      Node.WriteInteger('Cnt', FPageGuides.GuideCount);
      for i := 0 to FPageGuides.GuideCount - 1 do
      begin
        Guide := FPageGuides.GuideByIndex(i);
        Sub := Node.NodeNew(intToStr(i));
        Sub.WriteFloat('SPX', Guide.StartPoint.X);
        Sub.WriteFloat('SPY', Guide.StartPoint.Y);
        Sub.WriteFloat('EPX', Guide.EndPoint.X);
        Sub.WriteFloat('EPY', Guide.EndPoint.Y);
      end;
    end;
  end;
  inherited;
end;

procedure TdtpPage.SetBackgroundTiled(const Value: boolean);
begin
  if BackgroundTiled <> Value then
  begin
    IsDefaultPage := False;
    FBackgroundTiled := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPage.SetDocBoundsAndAngle(ALeft, ATop, AWidth, AHeight, AAngle: single);
// We override this one to signal our Document that we changed size
begin
  inherited;
  if Document is TdtpDocument then
    with TdtpDocumentAccess(Document) do
      if (CurrentPage = Self) and not IsPrinting then
        AdjustSizeToPage(Self);
end;

procedure TdtpPage.SetDocHeight(const Value: single); // added by J.F. Apr 2011 Guides bug fix
begin
  inherited;
  FPageGuides.UpdateAllGuides(); // changed by J.F. June 2011
end;

procedure TdtpPage.SetDocWidth(const Value: single);  // added by J.F. Apr 2011
begin
  inherited;
  FPageGuides.UpdateAllGuides(); // changed by J.F. June 2011
end;

procedure TdtpPage.SetDocument(const Value: TObject);
begin
  inherited;
  FBackgroundImage.Document := Document;
end;

procedure TdtpPage.SetShowBackgroundImage(const Value: boolean);
// added by J.F. Feb 2011
// turn backgroundImage on/off
begin
  if FShowBackgroundImage <> Value then
  begin
    FShowBackgroundImage := Value;
    TdtpDocumentAccess(FBackgroundImage.Document).Invalidate;
  end;
end;

procedure TdtpPage.SetGridColor(const Value: TColor);
begin
  if GridColor <> Value then
  begin
    IsDefaultPage := False;
    FGridColor := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPage.SetGridSize(const Value: single);
begin
  if GridSize <> Value then
  begin
    IsDefaultPage := False;
    FGridSize := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPage.SetIsDefaultPage(const Value: boolean);
begin
  if not (Document is TdtpDocument) then
    exit;
  if FIsDefaultPage <> Value then
  begin
    FIsDefaultPage := Value;
    with TdtpDocument(Document) do
      if FIsDefaultPage = False then
        with TdtpDocument(Document) do
        begin
          // Now that it is no longer a default page.. we must copy the props from the parent document
          FMarginLeft   := DefaultMarginLeft;
          FMarginTop    := DefaultMarginTop;
          FMarginRight  := DefaultMarginRight;
          FMarginBottom := DefaultMarginBottom;
          FGridColor    := DefaultGridColor;
          FGridSize     := DefaultGridSize;
          FPageColor    := DefaultPageColor;
          // added by J.F. Feb 2011 bug fix ??? might not be needed
          if BackgroundImage.IsEmpty and (not DefaultBackgroundImage.IsEmpty) then
            BackgroundImage.Assign(DefaultBackgroundImage);
          FBackgroundTiled := DefaultBackgroundTiled;
        end else
        begin
          PageWidth     := DefaultPageWidth;
          PageHeight    := DefaultPageHeight;
          Refresh;
          Changed;
        end;
  end;
end;

procedure TdtpPage.SetMarginBottom(const Value: single);
begin
  if MarginBottom <> Value then
  begin
    IsDefaultPage := False;
    FMarginBottom := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPage.SetMarginLeft(const Value: single);
begin
  if MarginLeft <> Value then
  begin
    IsDefaultPage := False;
    FMarginLeft := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPage.SetMarginRight(const Value: single);
begin
  if MarginRight <> Value then
  begin
    IsDefaultPage := False;
    FMarginRight := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPage.SetMarginTop(const Value: single);
begin
  if MarginTop <> Value then
  begin
    IsDefaultPage := False;
    FMarginTop := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPage.SetModified;
begin
  inherited;
  if Value then
    FIsThumbnailModified := True;
end;

procedure TdtpPage.SetPageColor(const Value: TColor);
begin
  if PageColor <> Value then
  begin
    IsDefaultPage := False;
    FPageColor := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPage.SetPageHeight(const Value: single);
begin
  DocHeight := Value;
end;

procedure TdtpPage.SetPageWidth(const Value: single);
begin
  DocWidth := Value;
end;

procedure TdtpPage.SetThumbnail(const Value: TBitmap);
begin
  FreeAndNil(FThumbnail);
  if assigned(Value) then
  begin
    // Create the bitmap
    FThumbnail := TBitmap.Create;
    FThumbnail.Assign(Value);
  end;
  FIsThumbnailModified := False;
end;

procedure TdtpPage.UpdateThumbnail;
begin
  // This actually updates the thumbnail
  GetThumbnail;
  // Call event
  if Document is TdtpDocument then
    TdtpDocumentAccess(Document).DoPageChanged(Self);
end;

initialization
  RegisterShapeClass(TdtpPage);

end.

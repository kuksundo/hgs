{
  Unit dtpDefaults

  dtpDefaults is the central location for any default constants.

  Users of the DtpDocuments library can change these defaults to their own
  wishes. Make sure to backup your defaults file before installing a new
  version!

  Project: DTP-Engine

  Creation Date: 22-09-2004 (NH)

  Copyright (c) 2002-2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpDefaults;

{$i simdesign.inc}

interface

uses
  Graphics, NativeXmlOld;

// Some enumerated types are declared here so they can be used as constants

type

  TdtpResourceStorage = (
    rsNone,      // The resource is not stored (it is just a temporary resource)
    rsExternal,  // The resource is stored in an external file (and thus read only)
    rsArchive,   // The resource is stored in the document archive
    rsEmbedded   // The resource is stored as embedded Base64 in XML
  );

const

  // Handles

  cDefaultHandleSize      = 3;       // Handle size in pixels
  cDefaultHandleColor     = clWhite; // Default color for the handles
  cDefaultHandleEdgeColor = clBlack; // Default color of handle edges

  cDefaultMinWidth  = 0.1;  // Smallest allowed width for shapes [mm]
  cDefaultMinHeight = 0.1;  // Smallest allowed height for shapes [mm]

  //  added by J.F. June 2011
  cDefaultShapeNudgeDistance = 0.5; // Distance to move selected shapes with Cursor Keys [mm]

  cMMToInch = 25.4; // Conversion factor from mm to inch
  cMMToCM   = 10;   // Conversion factor from mm to cm  //  added by J.F. June 2011

  // Set this constant to TRUE to drop caches inbetween print slices.
  // Note: this can lead to SEVERE performance degradation during print!
  cPrintingOptimisedForMemUsage: boolean = False;

  // "Dots Per Millimeter", in fact pixels per millimeter are calculated from
  // DPI by dividing by 25.4 (1 inch = 25.4 mm)

  cMonitorDpm        = 150 / cMMtoInch; // Dots per Millimeter, converted from 150 DPI
  cLowPrinterDpm     = 150 / cMMtoInch; // Low printer quality
  cNormalPrinterDpm  = 300 / cMMtoInch; // Normal printer quality
  cHighPrinterDpm    = 600 / cMMtoInch; // High printer quality

  cDegToRad     = pi / 180.0; // Convert Degrees to Radians
  cRadToDeg     = 180.0 / pi; // Convert Radians to Degrees

  cBorderSizePx = 10;         // Border size (gray area around page) in pixels

  cDragLimit    = 10;         // Square of number of pixels to move before dragging

  // Hit sensitivity: higher values make it easier to hit a shape when not exactly on it
  cDefaultHitSensitivity  = 1.0;

  // The amount of alpha before detecting a hit
  cSmartHitAlphaLimit     = 50;

  // Hotzone scrolling

  cHotzonePercentage      = 0.07; // Hotzone in percent of total width
  cHotZoneSensitivity     = 2.0;  // Scrolling speed when mouse in hotzone
  cHotZoneSpeedLimit      = 30.0; // If mouse speed higher (pixels per sec), no hotzoning
  cHotzoneStartupTime     = 700;  // Startup time in milliseconds (time before reaching full hotzone speed)

  // Max page count the user can set in the document.
  cMaxSetPageCount        = 25;

  // Default zooming step
  cDefaultZoomStep        = 1.1;

  // Maximum size of Undo cache in bytes
  cMaxUndoSize            = 10 * 1024 * 1024;

  // Hints

  cDefaultHintColor       = $E0FFFF;// Default hint color
  cDefaultHintHidePause   = 2500;
  cDefaultHintShortPause  = 50;
  cDefaultHintPause       = 500;

  // Grid

  // Default color used to draw the helper grid
  cDefaultGridColor       = $00FFFFC0;
  // Default size in mm used to draw the helper grid
  cDefaultGridSize        = 5;

  // Page update interval in msec. TdtpDocument will wait at least this amount of
  // time after a change before updating any modified page thumbnail.
  cDefaultPageUpdateInterval = 2000;

  // Page thumbnails

  // Default page thumbnail height in pixels
  cDefaultThumbnailHeight = 60;
  // Default page thumbnail width in pixels
  cDefaultThumbnailWidth  = 80;

  // Paper shadow size in mm
  cShadowSize = 1.0;

  // Some paper sizes
  c_A4_Width  = 210;
  c_A4_Height = 297;

  // Arbitrary limit of bitmap size to print at once. It is not completely
  // arbitrary: you should not increase this limit too much because your users
  // might have systems (e.g. Win98, WinME) that do not support very large
  // bitmaps, and they might experience bitmap allocation problems if this
  // limit is increased. If you are *sure* to only work with Win2000/XP and up,
  // then this limit can safely be increased to something like 2000 * 2000.
  cBitmapPrintSizeLimit = 1600 * 1200;

  // Page margins

  cDefaultMarginLeft   = 10;
  cDefaultMarginRight  = 10;
  cDefaultMarginTop    = 10;
  cDefaultMarginBottom = 10;

  // Page properties

  cDefaultPageColor    = clWhite;
  cDefaultPageHeight   = c_A4_Height;
  cDefaultPageWidth    = c_A4_Width;

  // Formatting of text boxes

  cDefaultMMFormat  = '%3.1f'; // Format for [mm]
  cDefaultDegFormat = '%3.1f'; // Format for [degrees]

  cTextMMFormat  = '%3.2f'; // Format for textheight in [mm]
  cTextPtsFormat = '%3.1f'; // Format for textheight in [pts]

  cPositionRelativeFormat = '%3.3f';

  cGHP1Decimal = '%4.1f';   //  added by J.F. June 2011
  cGHP2Decimals = '%4.2f';   //  Guide Hints format
  cGHP3Decimals = '%4.3f';

  // Minimum space in [mm] between line pieces in freehand
  cFreehandThreshold = 0.5;

  // Font adjustment
  cDefaultLineDist   = 1.0;

  // Caret
  cDefaultCaretBlinkInterval = 400; // blink speed in ms
  cDefaultCaretColor = clNavy;

  // Selection
  cDefaultTextSelectionColor = clGray;

  // Fonts
  cDefaultFontHeight = 12.0;
  cDefaultFontName   = 'Verdana';
  cDefaultFontColor  = clBlack;

  cDefaultUseUnicode: boolean = True;

  // Polygons
  cDefaultPolygonWidth        = 40;
  cDefaultPolygonHeight       = 30;
  cDefaultPolygonFillColor    = clBlue;
  cDefaultPolygonOutlineColor = clBlack;
  cDefaultPolygonOutlineWidth = 0.5;
  cDefaultStippleSize         = 2.0; // Polyline stippling default size

  // Lines
  cDefaultLineWidth   = 1.0;
  cDefaultArrowWidth  = 5.0;
  cDefaultArrowLength = 7.0;

  // Shadow
  cDefaultShadowDeltaX    = 2.0;
  cDefaultShadowDeltaY    = 1.0;
  cDefaultShadowBlur      = 1.5;
  cDefaultShadowColor     = clBlack;
  cDefaultShadowIntensity = 0.7;

  // Raster files
  cDefaultJpgCompressionQuality = 90;

  cDefaultSnapBitmapWidth  = 120;
  cDefaultSnapBitmapHeight = 80;

  // Maximum size in bytes allowed for all resources to occupy for their objects.
  // NB this is only an estimate of the size of all resources' objects. It depends
  // on the estimation in TdtpResource.GetObjectApproximateSize
  cDefaultMaximumResourceSize: int64 = 100 * 1024 * 1024;

  // Default Lowres DPM for TdtpCropBitmaps
  cDefaultLowresDPM: single = 150 / cMMtoInch;

  // Store full images externally
  cDefaultFullImageStorage   = rsExternal;

  // Store lowres images in the archive. Note that this can be changed here
  // to rsEmbedded, to store in the XML. This facilitates copying among documents,
  // however, it is slightly less efficient with document size and page loading
  // duration.
  cDefaultLowresImageStorage = rsArchive;

  // Paste offsets (when doing a paste on same page)
  cDefaultPasteOffsetX = 10.0;
  cDefaultPasteOffsetY = 10.0;

  // Placeholder
  cDefaultSnapMemoText   = 'Place image here';
  cDefaultSnapFrameColor = clBlack;
  cDefaultSnapFillColor  = clWhite;
  cDefaultSnapFrameWidth = 0.0;

  // Effects
  cDefaultSepiaEffectDepth = 35;

  // Palette size for gradients. Use higher number if you have large gradient fills
  // and want the intermediate colours to have smoother transitions
  cDefaultGradientPaletteSize = 256;


// default xml creation function
function CreateXmlForDtp(const AName: Utf8String): TNativeXmlOld;

implementation

// default xml creation function
function CreateXmlForDtp(const AName: Utf8String): TNativeXmlOld;
begin
  Result := TNativeXmlOld.CreateName(AName);

  // non-default xml properties used by DtpDocuments:

  // preserve whitespace so NativeXml should not trim any chardata
  Result.XmlFormat := xfoCompact;

  // skip un-normalisation for the BASE64 data by using EolStyle=esLinux, quite
  // a bit faster. Actually in NativeXml4.01 method sdUnNormaliseEol is improved
  // so no longer really needed, but just in case.
  //Result.EolStyle := esLF;

end;

end.

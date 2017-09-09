{ Unit dtpShape

  dtpShape is the basic shape component for this Desktop Publishing suite.

  dtpShape implements the basic behaviour for any shape that is displayed on
  the DTP surface. It allows caching for fast redrawal, moving, resizing,
  and rotating of the shape. It implements basic methods for painting, including
  the rubber bands and handles.

  Shape has its own coordinates. DocLeft / DocTop give its left/upper point relative
  to the parent shape.

  Project: DTP-Engine

  Creation Date: 25-10-2002 (NH)
  Version: See "changes.txt"

  Modifications:
  01Aug2003: Minor updates
  14Nov2004: Made Handles separate property
  19Aug2005: Changed painting to rendering methods

  21Feb2008 USc: TdtpShape.SetDocBoundsAndAngle and TdtpShape.AdjustRelative
                 modified to allow locks on both opposite edges

  Copyright (c) 2002-2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl
  Contributor: JohnF (JF)

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpShape;

{$i simdesign.inc}

interface

uses
  // delphi
  Windows, Classes, Controls, Contnrs, Graphics, SysUtils, Dialogs, Menus, Math,
  // dtpdocuments
  dtpStretch, dtpUtil, dtpGraphics, dtpDefaults, dtpCommand, dtpResource,
  dtpHandles, dtpTransform, dtpSampler, NativeXmlOld, sdStorage, sdDebug;

type

  TdtpShape = class;

  // This class defines the constraints of the shape's size
  TFloatSizeConstraint = class
  public
    MinHeight: single;
    MinWidth:  single;
    MaxHeight: single;
    MaxWidth:  single;
  end;

  // These anchor kinds describe how the shape will move and resize if the parent
  // moves or resizes. Default is [saLeftLock, saTopLock].
  // * saDefault:    The shape has default settings (Left/Top locked)
  // * saPosXProp:   The shape's position in X is changed proportionally with parent resize in X
  // * saPosYProp:   The shape's position in Y is changed proportionally with parent resize in Y
  // * saSizeXProp:  The shape's size in X is changed proportionally with parent resize in X
  // * saSizeYProp:  The shape's size in Y is changed proportionally with parent resize in Y
  // * saLeftLock:   The shape's position is fixed with respect to the left edge of the parent
  // * saTopLock:    The shape's position is fixed with respect to the top edge of the parent
  // * saRightLock:  The shape's position is fixed with respect to the right edge of the parent
  // * saBottomLock: The shape's position is fixed with respect to the bottom edge of the parent
  TShapeAnchorKind = (
    saDefault,   // The shape has default settings (Left/Top locked)
    saPosXProp,  // The shape's position in X is changed proportionally with parent resize in X
    saPosYProp,  // The shape's position in Y is changed proportionally with parent resize in Y
    saSizeXProp, // The shape's size in X is changed proportionally with parent resize in X
    saSizeYProp, // The shape's size in Y is changed proportionally with parent resize in Y
    saLeftLock,  // The shape's position is fixed with respect to the left edge of the parent
    saTopLock,   // The shape's position is fixed with respect to the top edge of the parent
    saRightLock, // The shape's position is fixed with respect to the right edge of the parent
    saBottomLock // The shape's position is fixed with respect to the bottom edge of the parent
  );

  // Set of TShapeAnchorKind
  TShapeAnchors = set of TShapeAnchorKind;

  // Generic class of TdtpShape descendants, used to register shape classes.
  TdtpShapeClass = class of TdtpShape;

  // Specifies the output device (screen or printer)
  TDeviceType = (
    dtScreen,       // Render to the screen
    dtPrinter,      // Render to the printer (and omit things like margins, grids, etc)
    dtTransparent   // Render to a transparent surface
  );

  // Parameters passed to rendering functions
  TDeviceContext = record
    DeviceType: TDeviceType;       // Kind of device (see TDeviceType)
    Background: TdtpColor;         // Background color to use for initialization of Dibs
    ActualDpm: single;             // actual resolution of current device surface in dots per mm
    CacheDpm: single;              // If caches need to be created, use this resolution (dots per mm)
    Quality: TdtpStretchFilter;    // Quality to use
    DropCacheAfterRender: boolean; // Drop any cache that was created after the rendering
    ForceResolution: boolean;      // Force to output at exact chosen resolution
  end;

  // Specifies the viestyle of the document, either "as printed" (with borders and shadow)
  // or normal (filling up until the edge of the control)
  TdtpViewStyleType = (
    vsPrintLayout, // Print Layout view -> Show borders around pages with shadow edge
    vsNormal       // No borders, just the paper.
  );

  // Specifies the helper method used in the document
  TdtpHelperMethodType = (
    hmNone,          // No helpers are drawn
    hmDots,          // The document paints small dots on each grid location
    hmGrid,          // The document paints grid lines
    hmPattern        // The document displays a checker pattern a la photoshop
  );

  // TdtpShape is the ancestor for all shapes, and provides all the basic methods and properties
  // that each shape within the document needs.
  TdtpShape = class(TPersistent)
  private
    FAllowEdit: boolean;      // If set (default), the user is allowed to edit this shape, usually after doubleclick
    FAllowDelete: boolean;    // Allow deletion by the user of this shape
    FAllowResize: boolean;    // If set, the user is allowed to resize this shape (default = true)
    FAllowMove: boolean;      // If set, the user is allowed to move this shape (default = true)
    FAllowRotate: boolean;    // Allow the user to rotate the shape (do we show the rotate handle by default)
    FAllowSelect: boolean;    // Set this flag to indicate that the shape is selectable
    FAnchors: TShapeAnchors;  // A set of anchors that determine how this shape moves rel. to parent (default is Left/Top)
    FAspectRatio: single;     // Aspect ratio of image, call FixAspectRatio to set it
    FAutoCreated: boolean;    // If true, this shape is auto-created in parent shape, do not create on load or clear
    FCacheDIB: TdtpBitmap;    // TdtpBitmap DIB holding the cached image (if caching is necessary)
    FCacheDpm: single;        // Cache's resolution in dots per mm if any
    FCurbLeft: single;        // Size of the left curb area [mm]
    FCurbTop: single;         // Size of the top curb area [mm]
    FCurbRight: single;       // Size of the right curb area [mm]
    FCurbBottom: single;      // Size of the bottom curb area [mm]
    FConstraints: TFloatSizeConstraint; // If <> 0, these values constrain the min / max size of the shape
    FDocAngle: single;        // Angle of rotation of this shape [deg]
    FDocAngleCos: single;     // Cosine of DocAngle
    FDocAngleSin: single;     // Sine of DocAngle
    FDocHeight: single;       // Height of shape [mm]
    FDocument: TObject;       // Document control that is displaying this shape
    FDocWidth: single;        // Width of shape [mm]
    FDragAngle: single;       // Angle of rotation while dragging
    FDragHandle: integer;     // Index of the dragged handle if any
    FDragHeight: single;      // Height of shape while dragging
    FDragLeft: single;        // X-coordinate of UL corner while dragging
    FDragTop: single;         // Y-coordinate of UL corner while dragging
    FDragTrans: TdtpTransform;// Dragging transformation (scaling, resizing, moving, rotating, shearing)
    FDragWidth: single;       // Width of shape  while dragging
    FFlipped: boolean;        // This shape is mirrored vertically by mirroring the cache
    FGrouped: boolean;        // If set, the child shapes will keep size/position relative to this shape.
    FHandles: TdtpHandlePainter; // Pointer to an handlepainter object used to paint handles during selection and dragging
    FHint: string;            // Small popup text that is displayed when hovering over (only if ShowHint is true)
    FInsertCursor: TCursor;   // cursor show on insert, added by EL
    FMasterAlpha: cardinal;   // Overall alpha blending factor 0 = transparent, 255 = opaque
    FMirrored: boolean;       // This shape is mirrored horizontally, by mirroring the cache
    FModified: boolean;       // This shape is modified since last
    FMustCache: boolean;      // Set this flag to indicate that a shape must always be cached
    FMustCallChanged: boolean;// If set, "Changed" must be called at EndUpdate
    FParent: TdtpShape;       // Parent control
    FParentShowHint: boolean; // If true (default), the ShowHint property of the document is used
    FPopupMenu: TPopupMenu;   // Pointer to a popup menu that will pop up if rightclicked
    FPreserveAspect: boolean; // If set, the shape can only be resized preserving the aspect ratio (default = false)
    FSelected: boolean;       // If set, the shape is selected
    FSessionRef: integer;     // Reference ID for this session
    FShapes: TObjectList;     // Child shapes
    FShowHint: boolean;       // If true, the shape's hint is displayed (only valid if ParentShowHint = False)
    FStoredCurbLeft: single;  // The initial (stored) curb size left
    FStoredCurbTop: single;   // The initial (stored) curb size top
    FStoredCurbRight: single; // The initial (stored) curb size right
    FStoredCurbBottom: single;// The initial (stored) curb size bottom
    FTag: integer;            // A value that can be defined by the user
    FTransform: TdtpTransform;// Last used transformation on which ShapeToPoint is based
    FUpdateCount: integer;    // Update count (for beginupdate/endupdate)
    FVisible: boolean;        // Set this flag to indicate that the shape is visible
    // events
    FOnChange: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnResize: TNotifyEvent;
    procedure AdjustRelative(Pos, Size, Left, Right: boolean; OldMW, NewMW,
      OldSL, OldSW: single; var NewSL, NewSW: single);
    procedure CurbCorners(var CLT, CLB, CRT, CRB: TdtpPoint);
    //function CircumscribeFourPoints(const C1, C2, C3, C4: TFloatPoint): TFloatRect;
    procedure Corners(var CLT, CLB, CRT, CRB: TdtpPoint);
    procedure CurbCornersInScreen(var CLT, CLB, CRT, CRB: TdtpPoint);
    function GetAllowSelect: boolean;
    function GetBottom: single;
    function GetCanvasBottom: integer;
    function GetCanvasHeight: integer;
    function GetCanvasLeft: integer;
    function GetCanvasRight: integer;
    function GetCanvasTop: integer;
    function GetCanvasWidth: integer;
    function GetDocBottom: single;
    function GetDocRect: TdtpRect;
    function GetDocRight: single;
    function GetHint: string;
    function GetIndex: integer;
    function GetLeft: single;
    function GetRight: single;
    function GetScreenDpm: single;
    function GetShapeCount: integer; virtual;
    function GetShapeList: TList;
    function GetShapes(Index: integer): TdtpShape; virtual;
    function GetShowHint: boolean;
    function GetTop: single;
    function GetUndoEnabled: boolean;
    procedure SetAnchors(const Value: TShapeAnchors);
    procedure SetAllowSelect(const Value: boolean);
    procedure SetBottom(const Value: single);
    procedure SetDocBottom(const Value: single);
    //procedure SetDocHeight(const Value: single); virtual; // moved to protected by J.F. Apr 2011
    procedure SetDocLeft(const Value: single); virtual;
    procedure SetDocRect(const Value: TdtpRect);
    procedure SetDocRight(const Value: single);
    procedure SetDocTop(const Value: single); virtual;
    //procedure SetDocWidth(const Value: single); virtual; moved to protected by J.F. Apr 2011
    procedure SetFlipped(const Value: boolean);
    procedure SetLeft(const Value: single);
    procedure SetMasterAlpha(const Value: cardinal); virtual;
    procedure SetMirrored(const Value: boolean);
    procedure SetMustCache(const Value: boolean);
    procedure SetRight(const Value: single);
    procedure SetShowHint(const Value: boolean);
    procedure SetTop(const Value: single);
    procedure SetVisible(const Value: boolean);
    function GetCurbedWidth: single;
    function GetCurbedHeight: single;
    function GetRedoEnabled: boolean;
    procedure SetGrouped(const Value: boolean);
    function GetIsPlaceHolderVisible: boolean;
    procedure SetIsPlaceHolderVisible(const Value: boolean);
    procedure SetTag(const Value: integer);
    function GetAsBinaryString: RawByteString;
    procedure SetAsBinaryString(const Value: RawByteString);
  protected
    FDocLeft: single;         // X Coordinate of of upper left corner [mm]
    FDocTop: single;          // Y Coordinate of of upper left corner [mm]
    FName: string;            // Name of this shape
    procedure AddArchiveResourceNames(Names: TStrings); virtual;
    procedure AddCmdToUndo(ACommand: TdtpCommandType; const AProp: string; AValue: TFontStyles); overload; virtual;
    procedure AddCmdToUndo(ACommand: TdtpCommandType; const AProp: string; AValue: double); overload; virtual;
    procedure AddCmdToUndo(ACommand: TdtpCommandType; const AProp: string; AValue: integer); overload; virtual;
    procedure AddCmdToUndo(ACommand: TdtpCommandType; const AProp, AValue: string); overload; virtual;
    procedure AddCmdToUndo(ACommand: TdtpCommandType; const AProp: string; AValue: boolean); overload; virtual;
    procedure AddCmdToUndo(ACommand: TdtpCommandType; AShape: TdtpShape); overload; virtual;
    function AdjustToGrid(APoint: TdtpPoint): TdtpPoint; virtual;
    function Archive: TsdStorage;
    procedure AssignEvents(AShape: TdtpShape); virtual;
    procedure BeginUndo;
    procedure BeginUpdate;
    // Free the cache and reset FCacheDpm to 0, to ensure cache is recreated on next render
    procedure CacheFree; virtual;
    // Check if the cache is valid
    function CacheIsValid: boolean;
    function CanResize(var NewWidth, NewHeight: single): boolean; virtual;
    function CanMove(var NewLeft, NewTop, NewWidth, NewHeight: single): boolean; virtual;
    // Convert a DIB drawed on by a canvas to a regular alpha DIB
    procedure CanvasToDIB(ABitmap: TdtpBitmap; ABkColor: TdtpColor = $00FFFFFF); virtual;
    procedure CalculateBounds(Delta: TdtpPoint; AltKey: boolean; HitInfo: THitTestInfo;
      var T: TdtpMatrix);
    // Override this method to create custom hittests
    procedure CalculateCustomHittestBounds(var MoveX, MoveY, ScaleX, ScaleY, Rotate: single;
      Delta: TdtpPoint; HitInfo: THittestInfo); virtual;
    procedure Changed; virtual;
    procedure CheckCurbs;
    procedure CreateHandleObject;
    // Create a set of handles as used by this shape for moving/resizing/rotating
    procedure CreateHandles; virtual;
    // Any actions you want to perform after a paste of an object (clone)
    procedure DoAfterPaste; virtual;
    // Any actions you want to perform after loading from XML
    procedure DoAfterLoad; virtual;
    // This procedure is called each 50 msec. Override it to do any animation
    procedure DoAnimate; virtual;
    procedure DoDblClick; virtual;
    // Stop editing
    procedure DoEditClose(Accept: boolean); virtual;

    // added by J.F. Feb 2011// needed for FontEmbedding fix
    // see addition in ShapeDelete
    procedure DoDelete; virtual;

    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String); virtual;
    function DocToShapeMove(AMove: TdtpPoint): TdtpPoint;
    // Convert a dragged shape point to screen coordinates
    function DragToScreen(DragPos: TdtpPoint): TdtpPoint;
    procedure EndUndo;
    procedure EndUpdate;
    // Find bounds around child shapes, and make this shape a group
    procedure FindFittingBounds; virtual;
    function GetEditPopupMenu: TPopupMenu; virtual;
    function GetHasEffects: boolean; virtual;
    // Get hittest info in cases where the shape is selected and showing handles.
    function GetHandleHitTestInfoAt(APos: TPoint): THitTestInfo; virtual;
    // Get the rectangle that must be invalidated (this is bounds + room for handles)
    function GetInvalidationRect: TRect; virtual;
    // If over a shapes bounding rect, use GeSmartHitInfo to find if we are hitting it or just "air"
    function GetSmartHitInfoAt(APos: TPoint): THitTestInfo; virtual;
    // Override this function if you want to determine by code if the shape should be cached or not
    function GetMustCache: boolean; virtual;
    function GetName: string; virtual;
    function GetPasteOffset: TdtpPoint; virtual;
    // Return the bounding union rectangle of all child shapes
    function  GetUnionRect: TdtpRect; virtual;
    function HasCache: boolean;
    function GetIsEditing: boolean; // changed by EL
    // Call MustRegenerate to ensure the cache is invalidated, as well as the caches
    // of the parents. The shape will be re-cached on next render cycle.
    procedure MustRegenerate;
    // The "Paint" method only has to take care of the basic shape. All child
    // shapes are painted over it automatically.
    //
    // The overrider can use this paint method with Canvas or override PaintDIB,
    // depending on what is convenient.
    // When using Canvas, the Canvas will in its turn draw on the 32-bit DIB.
    // This DIB is then cached so this drawing operation only takes place when
    // absolutely neccesary. Furthermore, the DIB will be rotated by the parent
    // as neccesary, depending on DocAngle. No special care to rotation is required
    // in this Paint method.
    //
    // Use P := ShapeToPoint(OrigPoint) to get the coordinates for the canvas or DIB.
    // Other possibilities are ShapeToPointX, or CanvasLeft, CanvasTop, CanvasRight,
    // CanvasBottom for the corner points of the shape
    //
    // In order to paint to a canvas, override the TdtpShape class method UseCanvasPainting
    // and set the result to True.
    procedure Paint(Canvas: TCanvas; const Device: TDeviceContext); virtual;
    // The PaintDib method must be overridden in descendants to paint the shape to
    // a 32bit bitmap. The Device parameter contains information that can be used
    // to determine how to paint.
    // Use P := ShapeToPoint(OrigPoint) to get the coordinates for the canvas or DIB.
    // Other possibilities are ShapeToPointX, or CanvasLeft, CanvasTop, CanvasRight,
    // CanvasBottom for the corner points of the shape
    // Whenever necessary, the DIB is cached so this drawing operation only takes
    // place when absolutely neccesary. Furthermore, the DIB will be rotated by
    // the parent as neccesary, depending on DocAngle. No special care to rotation
    // is required in this PaintDib method.
    procedure PaintDib(Dib: TdtpBitmap; const ADevice: TDeviceContext); virtual;
    procedure PaintEffects(DIB: TdtpBitmap; const ADevice: TDeviceContext); virtual;
    // Paint the dragborders on Canvas(that belongs to the document).
    procedure PaintDragBorder(Canvas: TCanvas); virtual;
    procedure PaintForeground(DIB: TdtpBitmap; const ADevice: TDeviceContext); virtual;
    procedure PaintInsertBorder(Canvas: TCanvas; Rect: TRect; Color: TColor); virtual;
    procedure PaintSelectionBorder(Canvas: TCanvas); virtual;
    // Override RenderScreenElements to render some things like markers, indicators etc
    // that should be displayed only in DeviceType = dtScreen mode.
    procedure RenderScreenElements(Dib: TdtpBitmap; DibRect: TdtpRect); virtual;
    // Recreate the cache, if neccesary, and draw the cache to the Dib. DibRect is given in parent coordinates,
    // unless UseDirectCoords is true, in that case DibRect is given in shape coords.
    procedure RenderShapeCached(Dib: TdtpBitmap; DibRect: TdtpRect;
      const ADevice: TDeviceContext; UseDirectCoords: boolean = False);
    // Render the shape directly to a 32bit Dib without using the cache. This method
    // is internally called by RenderShape (without caching), or RenderShapeCached (with
    // caching).

    // changed by J.F. Feb 2011
    // so TdtpPage can overide it to paint Guides if GuidesToFront = true
    procedure RenderShapeDirect(Dib: TdtpBitmap; DibRect: TdtpRect; const ADevice: TDeviceContext);virtual;
    
    // Render the shape to a 32bit bitmap, the Dibs extents are given in DibRect. The shape
    // must be *merged* to this Dib. DibRect is given in parent coordinates,
    // unless UseDirectCoords is true, in that case DibRect is given in shape coords.
    procedure RenderShape(Dib: TdtpBitmap; DibRect: TdtpRect; const ADevice: TDeviceContext;
      UseDirectCoords: boolean = False);
    procedure SetDocAngle(const Value: single); virtual;
    procedure SetDocHeight(const Value: single); virtual; // added by J.F. apr 2011
    procedure SetDocPosition(ALeft, ATop: single); virtual;
    procedure SetDocSize(AWidth, AHeight: single); virtual;
    procedure SetDocWidth(const Value: single); virtual; // added by J.F. Apr 2011 os TdtpPage can override
                                                         // to fix Guides bug - see TdtpPage
    procedure SetDocument(const Value: TObject); virtual;
    procedure SetModified(const Value: boolean); virtual;

    // added and changed here by J.F. Feb 2011 so dtpTextShape can override it
    procedure SetPreserveAspect(const Value: boolean);virtual;

    // SetSelected moved here by JF
    // So Shape (Text Shape for example) can override this to Post WM_DELETE_SHAPE message
    // to TdtpDocuments so we can delete an empty TextShape to clean up clutter
    procedure SetSelected(const Value: boolean);virtual;
    procedure SetName(const Value: string); virtual;
    procedure SetParent(const Value: TdtpShape); virtual;
    procedure SetPropertyByName(const AName, AValue: string); virtual;
    procedure SetTransformation(const ATrans: TdtpMatrix); virtual;
    function ShapeRegion: HRgn; virtual;
    procedure ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single); virtual;
    function GetStorage: TdtpResourceStorage; virtual;
    procedure SetStorage(const Value: TdtpResourceStorage); virtual;
    property CacheDpm: single read FCacheDpm;
    property DragHandle: integer read FDragHandle write FDragHandle;
    property RedoEnabled: boolean read GetRedoEnabled;
    property Handles: TdtpHandlePainter read FHandles;
    property IsPlaceHolderVisible: boolean read GetIsPlaceHolderVisible write SetIsPlaceHolderVisible;
  public
    // Create a new shape. This method is virtual so that any TdtpShape descendants can
    // be created virtually, only by having the correct class and calling this Create method.
    constructor Create; virtual;
    // Create the new shape and load it directly from the XML node provided.
    constructor CreateFromXml(ANode: TXmlNodeOld); virtual;
    // Destroys a previously allocated shape. Never call Destroy directly, call
    // the Free method instead.
    destructor Destroy; override;
    // When called the shape will accept the given bounds and set its position accordingly.
    // It will do a test first, using CanResize, before calling SetDocBounds.
    procedure AcceptDocBounds(ALeft, ATop, AWidth, AHeight: single); virtual;
    // When called, the shape will accept the drag bounds coordinates and replace
    // the DocLeft, DocTop, DocWidth, DocHeight, DocAngle with them.}
    procedure AcceptDragBorder; virtual;
    // Accept the new borders as given in Rect (document coordinates). R.Right < R.Left can
    // exist, so this should still be checked or used as an advantage.
    procedure AcceptInsertBorder(Rect: TdtpRect); virtual;
    // When called, the size of this shape is checked with minimum/maximum and aspect ratio,
    // and it is adjusted as neccesary
    procedure AdjustToConstraints; virtual;
    // Call Assign to assign the contents of Source to this object. If the object types
    // are identical, a perfect 1:1 copy will be obtained. In other cases all the common
    // properties will be copied.
    procedure Assign(Source: TPersistent); override;
    // Get the circumvening rectangle of the shape in screen coordinates, for update purposes
    function BoundsRect: TRect; virtual;
    // Get the bounding region of the shape in screen coordinates, for hit test purposes
    function BoundsRegion: HRgn; virtual;
    // Call this method to drop the current cache and free some memory. When there's
    // a new paint request, the cache will be regenerated.
    procedure CacheDrop; virtual;
    // Get a rectangle that represents the current canvas' drawing rect (0, 0, DocWidth, DocHeight)
    function CanvasRect: TRect;
    // Clear the shape's contents. If the shape contains subshapes, these will be
    // deleted. This is a virtual method. It only gets called whenever a shape needs
    // to be cleared before assigning the contents of another shape.
    procedure Clear; virtual;
    // Create a copy of the shape and return this new object's pointer. The caller
    // is responsible for destroying the resulting object later on.
    function CreateCopy: TdtpShape;
    // Create a placeholder subshape in position 0
    procedure CreatePlaceholder; virtual;
    // Returns the curbed rectangle of the shape 
    function CurbedRect: TdtpRect;
    // Call DisableUndo and EnableUndo before and after a section of code where
    // there should be no registration of undo commands. Make sure to match the
    // DisableUndo and EnableUndo calls, using a Try..Finally construct.
    procedure DisableUndo;
    // Move the shape to the new ALeft, ATop position, which is given in mm in page
    // coordinates.
    procedure DocMove(ALeft, ATop: single);
    // Resize the shape to new AWidth, AHeight size (in mm)
    procedure DocResize(AWidth, AHeight: single);
    // Rotate the shape to new ADocAngle, this is done around Center.
    procedure DocRotate(AAngle: single);
    // Convert Document coordinates [mm] to Shape coordinates [mm]
    function DocToShape(APoint: TdtpPoint): TdtpPoint;
    // Put the shape in Edit mode.
    procedure Edit; virtual;
    // Call DisableUndo and EnableUndo before and after a section of code where
    // there should be no registration of undo commands. Make sure to match the
    // DisableUndo and EnableUndo calls, using a Try..Finally construct.
    procedure EnableUndo;
    // Create a bitmap32 copy of the shape with size AWidth and AHeight. Set Curbsize
    // to a value bigger than 0 to add a border around the shape. Set DeviceType to
    // other than dtTransparent to get the inclusions for screen/printer devices.
    // Set StretchFilter other than dtpsfLinear to allow other stretch filters
    // (e.g. dtpsfLanczos)
    function ExportToBitmap(AWidth, AHeight: integer; Curbsize: integer = 0;
      DeviceType: TDeviceType = dtTransparent; StretchFilter: TdtpStretchFilter = dtpsfLinear): TdtpBitmap;
    // Call this method to fix the current Width/Heigth aspect ratio and keep it until
    // called again or PreserveAspect is set to false.
    procedure FixAspectRatio; virtual;
    // Get general hittest info of the shape itself
    function GetHitTestInfoAt(APos: TPoint): THitTestInfo; virtual;
    // Get hittest info for double-clicking. This also checks the child shapes.
    function GetHitTestInfoDblClickAt(APos: TPoint; var AShape: TdtpShape): THitTestInfo; virtual;
    // Grow the shape in each direction (so in total 2*DeltaX horizontal, 2*DeltaY vertical)
    procedure Grow(DeltaX, DeltaY: single); virtual;
    // Determine if the shape intersects with ARect (ARect is in screen coords)
    function IntersectWithRect(ARect: TRect): boolean;
    // Call invalidate in any case that you want a redraw of the area of the shape,
    // while the shape itself is unchanged, and cached parent needs update (move, alpha) .
    procedure Invalidate;
    // Call invalidatesimple in any case that you want a redraw of the area of the shape,
    // while the shape itself is unchanged.. mostly for overlayed handledrawing.
    procedure InvalidateSimple; virtual;
    // Override KeyDown in your own TdtpShape descendants to do custom keyboard processing.
    // KeyDown is called whenever a key on the keyboard is pushed down, and takes into
    // account the state of the shift keys (Shift, Alt, Ctrl).
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    // Override KeyPress in your own TdtpShape descendants to do custom keyboard processing.
    // KeyPress is called whenever a key on the keyboard is pressed. Key corresponds
    // to the ASCII character that was keyed in.
    procedure KeyPress(var Key: Char); virtual;
    // Override KeyUp in your own TdtpShape descendants to do custom keyboard processing.
    // KeyUp is called whenever a key on the keyboard is is released, and takes into
    // account the state of the shift keys (Shift, Alt, Ctrl).
    procedure KeyUp(var Key: Word; Shift: TShiftState); virtual;
    // LoadFromXml loads the contents of the shape from the XML node ANode. You must override
    // LoadFromXml in your own TdtpShape descendants to provide persistance and correct
    // behaviour when using copy/paste. Make sure to always call "Inherited" inside the
    // overridden method to ensure all basic properties are also loaded.
    procedure LoadFromXml(ANode: TXmlNodeOld); virtual;
    // Override MouseDblClick in your own Tdtpshape descendant to do custom mouse event handling.
    // MouseDblClick is called whenever the user double-clicks on the mouse. X and Y are the
    // position of the mouse within the parent document in pixels. Left or Right (boolean) indicates
    // which mouse button was pressed, and Shift and Ctrl indicate the state of the Shift and Ctrl
    // keys.
    procedure MouseDblClick(Left, Right, Shift, Ctrl: boolean; X, Y: integer); virtual;
    // Override MouseDown in your own Tdtpshape descendant to do custom mouse event handling.
    // MouseDown is called whenever the user clicks on the mouse button. X and Y are the
    // position of the mouse within the parent document in pixels. Left or Right (boolean) indicates
    // which mouse button was pressed, and Shift and Ctrl indicate the state of the Shift and Ctrl
    // keys.
    procedure MouseDown(Left, Right, Shift, Ctrl: boolean; X, Y: integer); virtual;
    // Override MouseMove in your own Tdtpshape descendant to do custom mouse event handling.
    // MouseMove is called whenever the user moves on the mouse. X and Y are the
    // position of the mouse within the parent document in pixels. Left or Right (boolean) indicates
    // which mouse button was pressed, and Shift and Ctrl indicate the state of the Shift and Ctrl
    // keys.
    procedure MouseMove(Left, Right, Shift, Ctrl: boolean; X, Y: integer); virtual;
    // Override MouseUp in your own Tdtpshape descendant to do custom mouse event handling.
    // MouseUp is called whenever the user releases on the mouse button. X and Y are the
    // position of the mouse within the parent document in pixels. Left or Right (boolean) indicates
    // which mouse button was pressed, and Shift and Ctrl indicate the state of the Shift and Ctrl
    // keys.
    procedure MouseUp(Left, Right, Shift, Ctrl: boolean; X, Y: integer); virtual;
    // Call this function in a property setter just before a call to AddCmdToUndo
    // in order to avoid adding repeated property changes. This is useful for
    // properties that are set through slider bars.
    procedure NextUndoNoRepeatedPropertyChange;
    // ParentRect is the rectangle in parent coordinates of the shape. If the shape is
    // rotated, this rectangle contains some triangles outside of the shape. If IncludeCurbs
    // is True (default), the area includes the room for the curbs.
    function ParentRect(IncludeCurbs: boolean = True): TdtpRect;
    // ParentToShape converts coordinates from the parent [mm] to shape coordinate system [mm].
    function ParentToShape(APoint: TdtpPoint): TdtpPoint;
    // Use PerformCommand to make the shape perform the command ACommand. This function
    // is used internally by the Undo/Redo mechanism, and normally you will not have to
    // use it. However, if you want to build in scripting or a custom undo mechanism, this
    // function can be used to perform commands. See also TdtpCommand.
    function PerformCommand(ACommand: TdtpCommand): boolean; virtual;
    // Call regenerate when the shape changed and its new look must be refreshed. All its
    // child shapes will also be regenerated.
    procedure Regenerate; virtual;
    // Call refresh to just regenerate the shape but not the child shapes.
    procedure Refresh;
    // SaveToXml saves the contents of the shape to the XML node ANode. You must override
    // SaveToXml in your own TdtpShape descendants to provide persistance and correct
    // behaviour when using copy/paste. Make sure to always call "Inherited" inside the
    // overridden method to ensure all basic properties are also saved.
    procedure SaveToXml(ANode: TXmlNodeOld); virtual;
    // Convert from screen coordinates [pixels] to cache coordinates [pixels]
    function ScreenToCache(APoint: TPoint): TdtpPoint;
    // Convert screen coordinatess [pixels] to shape coordinates [mm]
    function ScreenToShape(APoint: TPoint): TdtpPoint;
    // Convert a Screen movement (AMove.x, AMove.y) [pixels] into a movement inside the shape [mm]
    function ScreenToShapeMove(AMove: TPoint): TdtpPoint;
    // If all curbs are equal, use this function (outward is positive)
    procedure SetCurbSize(AThickness: single); overload; virtual;
    // Use SetCurbSizes to set the sizes of the curbs of the shape individually. All values
    // are normally positive outward.
    procedure SetCurbSizes(ALeft, ATop, ARight, ABottom: single); overload; virtual;
    // Call this method instaead of just setting properties DocLeft, DocTop, DocWidth, DocHeight
    // so that all of them are changed at once, requiring only one screen update.
    procedure SetDocBounds(ALeft, ATop, AWidth, AHeight: single); virtual;
    // Set Document bounds and DocAngle in one command.
    procedure SetDocBoundsAndAngle(ALeft, ATop, AWidth, AHeight, AAngle: single); virtual;
    // Set the document bounds, but use the "TRect" representation, aka substract 1 from ARight and ABottom
    procedure SetDocBoundsAsTRect(ALeft, ATop, ARight, ABottom: single);
    // Center the shape around CenterX, CenterY
    procedure SetDocCenter(CenterX, CenterY: single); virtual;
    // Use this method to set the drag transformation
    procedure SetDragTrans(ATrans: TdtpMatrix);
    // Use ShapeAdd to add a child shape to the shape.
    function ShapeAdd(AShape: TdtpShape): integer; virtual;
    // Call ShapeClear to remove all child shapes in the shape.
    procedure ShapeClear; virtual;
    // Call ShapeDelete to remove the child shape at Index from the child shape list.
    procedure ShapeDelete(Index: integer); virtual;
    // Call ShapeExchange to switch positions of child shapes i and j in the child
    // shape list.
    procedure ShapeExchange(i, j: integer); virtual;
    // Use ShapeExtract to extract a child shape from the child shape list of the shape.
    // The child shape will not be freed, a pointer to it will be returned
    function ShapeExtract(AShape: TdtpShape): TdtpShape; virtual;
    // Use ShapeIndexOf to find the index of a child shape in the child shape list.
    // If AShape was not found, index -1 is returned.
    function ShapeIndexOf(AShape: TdtpShape): integer; virtual;
    // Use ShapeInsert to add a child shape to the shape at position Index. Index = 0 is the
    // child shape that is in front of all other child shapes.
    procedure ShapeInsert(Index: Integer; AShape: TdtpShape); virtual;
    // Call ShapeRemove to remove AShape from the child shape list. The value returned
    // will be the index of AShape before it was removed, or -1 if AShape was not
    // found.
    function ShapeRemove(AShape: TdtpShape): integer; virtual;
    // Convert from shape coordinates [mm] to cache coordinates [pixels]
    function ShapeToCache(APoint: TdtpPoint): TdtpPoint;
    // Convert Shape coordinates [mm] to Document coordinates [mm]
    function ShapeToDoc(APoint: TdtpPoint): TdtpPoint;
    // Transform Shape coords to canvas (float) coordinates using the active transformation
    function ShapeToFloat(APoint: TdtpPoint): TdtpPoint;
    // Convert Shape coordinates[mm] to Parent shape coordinates [mm]
    function ShapeToParent(APoint: TdtpPoint): TdtpPoint;
    // Convert shape mm's to pixel size for current canvas
    function ShapeToPixel(Value: single): integer;
    // Transform Shape coords to canvas (integer) coordinates using the active transformation
    function ShapeToPoint(APoint: TdtpPoint): TPoint;
    // Transform Shape coords to canvas (integer) coordinates using the active transformation,
    // just in X. Warning: this command does not work correctly for rotated shapes.
    function ShapeToPointX(AX: single): integer;
    // Transform Shape coords to canvas (integer) coordinates using the active transformation,
    // just in Y. Warning: this command does not work correctly for rotated shapes.
    function ShapeToPointY(AY: single): integer;
    // Convert Shape coordinates [mm] to final viewer screen coordinates [pixels]
    function ShapeToScreen(APoint: TdtpPoint): TdtpPoint;
    // override this function to tell if a certain shape descendant needs to paint
    // directly onto a canvas with GDI commands
    class function UseCanvasPainting: boolean; virtual;
    // Set Left to control the position of the left-upper corner in X of the shape. Left
    // should be specified in [mm] relative to the document or parent shape.
    property Left:   single read GetLeft   write SetLeft;
    // Set Right to control the position of the right side of the shape in X. Right
    // should be specified in [mm] relative to the document or parent shape.
    property Right:  single read GetRight  write SetRight;
    // Set Top to control the position of the left-upper corner in Y of the shape. Top
    // should be specified in [mm] relative to the document or parent shape.
    property Top:    single read GetTop    write SetTop;
    // Set Bottom to control the position of the bottom side of the shape in Y. Bottom
    // should be specified in [mm] relative to the document or parent shape.
    property Bottom: single read GetBottom write SetBottom;
    // Set AllowDelete to False to prevent the user from deleting the shape with
    // DEL button or cut operation. The shape can still be deleted through code.
    property AllowDelete: boolean read FAllowDelete write FAllowDelete;
    // Set AllowEdit to False if the user should not be able to edit the shape (e.g.
    // a text shape) when double-clicking on it. Conform to AllowEdit if you want to provide
    // editing capability in your TdtpShape descendant.
    property AllowEdit:   boolean read FAllowEdit write FAllowEdit;
    // Set AllowResize to False if the user should not be able to resize the shape by
    // use of the mouse (dragging the edges or corners). AllowResize = False does not
    // prohibit changing size through code.
    property AllowResize: boolean read FAllowResize write FAllowResize;
    // Set AllowMove to False if the user should not be able to move the shape by
    // use of the mouse (dragging the body). AllowResize = False does not prohibit
    // changing position through code.
    property AllowMove: boolean read FAllowMove write FAllowMove;
    // Set AllowRotate to False if the user should not be able to rotate the shape by
    // use of the mouse (dragging the rotation handle). AllowRotate = False does not
    // prohibit rotating the shape through code.
    property AllowRotate: boolean read FAllowRotate write FAllowRotate;
    // Set AllowSelect to False if the user should not be able to select the shape by
    // use of the mouse (clicking on it). AllowSelect = False does not prohibit
    // selecting the shape through code.
    property AllowSelect: boolean read GetAllowSelect write SetAllowSelect;
    // The Anchors determine how the shape is resized when the parent shape is resized.
    // See TShapeAnchorKind for more information.
    property Anchors: TShapeAnchors read FAnchors write SetAnchors;
    // AspectRatio is defined as DocWidth/DocHeight, and is set when FixAspectRatio is
    // called. See also PreserveAspectRatio.
    property AspectRatio: single  read FAspectRatio;
    // If True, this shape is auto-created as part of a parent shape. Do not load or save it,
    // do not clear it. Normally, AutoCreated := False
    property AutoCreated: boolean read FAutoCreated write FAutoCreated;
    // CacheDIB points to a TBitmap32 that contains a cached image of the shape in
    // current rendering size. When CacheDIB is nil, the cached image was not yet
    // created or the shape is not a cached shape.
    property CacheDIB: TdtpBitmap read FCacheDIB write FCacheDIB;
    // Use CanvasBottom when painting in PaintDIB or Paint routines when you override
    // TdtpShape. CanvasBottom indicates the bottom edge of the shape in pixels.
    property CanvasBottom: integer read GetCanvasBottom;
    // Use CanvasHeight when painting in PaintDIB or Paint routines when you override
    // TdtpShape. CanvasHeight indicates the height of the shape in pixels.
    property CanvasHeight: integer read GetCanvasHeight;
    // Use CanvasLeft when painting in PaintDIB or Paint routines when you override
    // TdtpShape. CanvasLeft indicates the left edge of the shape in pixels.
    property CanvasLeft:   integer read GetCanvasLeft;
    // Use CanvasRight when painting in PaintDIB or Paint routines when you override
    // TdtpShape. CanvasRight indicates the right edge of the shape in pixels.
    property CanvasRight:  integer read GetCanvasRight;
    // Use CanvasTop when painting in PaintDIB or Paint routines when you override
    // TdtpShape. CanvasTop indicates the top edge of the shape in pixels.
    property CanvasTop:    integer read GetCanvasTop;
    // Use CanvasWidth when painting in PaintDIB or Paint routines when you override
    // TdtpShape. CanvasWidth indicates the width of the shape in pixels.
    property CanvasWidth:  integer read GetCanvasWidth;
    // Set Constraints to specify minimum and maximum shape size in [mm].
    property Constraints: TFloatSizeConstraint read FConstraints write FConstraints;
    // CurbLeft is the size in [mm] that the shape uses outside of its selection rectangle
    // at the left side. Use SetCurbSizes to specify the required size. Curbs are used
    // to allow for things like shadows to fall outside of the shape's rectangle.
    property CurbLeft: single read FStoredCurbLeft;
    // CurbTop is the size in [mm] that the shape uses outside of its selection rectangle
    // at the top side. Use SetCurbSizes to specify the required size. Curbs are used
    // to allow for things like shadows to fall outside of the shape's rectangle.
    property CurbTop: single read FStoredCurbTop;
    // CurbRight is the size in [mm] that the shape uses outside of its selection rectangle
    // at the right side. Use SetCurbSizes to specify the required size. Curbs are used
    // to allow for things like shadows to fall outside of the shape's rectangle.
    property CurbRight: single read FStoredCurbRight;
    // CurbBottom is the size in [mm] that the shape uses outside of its selection rectangle
    // at the bottom side. Use SetCurbSizes to specify the required size. Curbs are used
    // to allow for things like shadows to fall outside of the shape's rectangle.
    property CurbBottom: single read FStoredCurbBottom;
    // CurbedHeight (read-only) is the sum of the upper and lower curb size and the shape
    // height in [mm]. Use SetCurbSizes to specify the required curb sizes.
    property CurbedHeight: single read GetCurbedHeight;
    // CurbedWidth (read-only) is the sum of the left and right curb size and the shape
    // width in [mm]. Use SetCurbSizes to specify the required curb sizes.
    property CurbedWidth: single read GetCurbedWidth;
    // DocAngle specifies the rotation angle of the shape in degrees. A positive angle
    // indicates a counter-clockwise rotation.
    property DocAngle: single read FDocAngle  write SetDocAngle;
    // DocBottom specifies the position in Y of the bottom edge of the shape relative
    // to its parent or to the page. Note that with a DocAngle <> 0, DocBottom is given
    // *as if* the shape were unrotated.
    property DocBottom: single read GetDocBottom write SetDocBottom;
    // DocHeight specifies the height of the shape in [mm].
    property DocHeight: single read FDocHeight write SetDocHeight;
    // DocLeft specifies the position in X of the upper-left corner of the shape relative
    // to its parent or to the page.
    property DocLeft: single read FDocLeft write SetDocLeft;
    // DocTop specifies the position in Y of the upper-left corner of the shape relative
    // to its parent or to the page.
    property DocTop: single read FDocTop write SetDocTop;
    // DocRect returns the rectangle that the shape takes on the page or relative to
    // its parent. Note that with a DocAngle <> 0, DocRect is given *as if* the shape
    // were unrotated.
    property DocRect: TdtpRect read GetDocRect write SetDocRect;
    // DocRight specifies the position in X of the right edge of the shape relative
    // to its parent or to the page. Note that with a DocAngle <> 0, DocRight is given
    // *as if* the shape were unrotated.
    property DocRight: single read GetDocRight write SetDocRight;
    // DocWidth specifies the width of the shape in [mm].
    property DocWidth: single read FDocWidth  write SetDocWidth;
    // Document is a pointer back to the owner TdtpDocument object where the shape
    // belongs to.
    property Document: TObject read FDocument write SetDocument;
    // EditPopupMenu returns a pointer to a popup menu for the shape that must show up
    // when the user edits a shape. The default TdtpShape does not have
    // any; override the GetEditPopupMenu method in descendants to specify one.
    property EditPopupMenu: TPopupMenu read GetEditPopupMenu;
    // If Flipped is true, the shape will appear flipped (mirrored vertically). This
    // effect can be specified for any shape, but will cause the shape to be drawn
    // on the cache.
    property Flipped: boolean read FFlipped write SetFlipped;
    // If Grouped is true, a resize of the parent shape will cause the shape to abide
    // the Anchor specifications. A shape will automatically be grouped if it is
    // a child shape of a TdtpGroupShape.
    property Grouped: boolean read FGrouped write SetGrouped;
    // HasEffects returns True if there are any effects working on the shape's cache.
    // This can be when either Mirrored or Flipped is true, or there are any effects
    // added in the descendant TdtpEffectShape.
    property HasEffects: boolean read GetHasEffects;
    // Hint specifies a string that will pop up when the user hovers the mouse over
    // the shape. In order for this to happen, ShowHint must be True.
    property Hint: string read GetHint write FHint;
    // Index returns the index of this shape in the parent's or page's shape list.
    property Index: integer read GetIndex;
    // InsertCursor is the TCursor type used when the shape is about to be inserted
    // within a TdtpDocument.
    property InsertCursor: TCursor read FInsertCursor write FInsertCursor;
    // added by EL: access to protected GetIsEditing
    property IsEditing: boolean read GetIsEditing;
    // MasterAlpha defines the alpha-blending that is used to render the shape on
    // top of other shapes. MasterAlpha = 255 specifies a fully opaque (untransparent)
    // shape, which is default. MasterAlpha = 0 will make the shape invisible (fully
    // transparent). Any value inbetween will make the shape semi-transparent.
    // MasterAlpha works on the total shape, additional to partial transparency
    // (Alpha channel) defined for individual pixels.
    property MasterAlpha: cardinal read FMasterAlpha write SetMasterAlpha;
    // If Mirrored is true, the shape will appear mirrored horizontally. This
    // effect can be specified for any shape, but will cause the shape to be drawn
    // on the cache.
    property Mirrored: boolean read FMirrored write SetMirrored;
    // Set Modified to true if the shape has been modified. This can be used when
    // a property is changed, and will indicate to the document that the document
    // is changed.
    property Modified: boolean read FModified write SetModified;
    // MustCache
    property MustCache: boolean read GetMustCache write SetMustCache;
    // Specify a Name for the shape if you want to be able to use the shape in
    // a scripting environment. Usually, shapes do not have names.
    property Name: string read GetName write SetName;
    // Parent points to the parent shape or page that the shape is part of.
    property Parent: TdtpShape read FParent write SetParent;
    // If ParentShowHint is True (default) then hinting behaviour is copied from
    // the document that the shape is in.
    property ParentShowHint: boolean read FParentShowHint write FParentShowHint;
    // PasteOffset that is different from (0, 0) will provide an offset to the insertion
    // point of pasted shapes whenever they're pasted. Text shapes override GetPasteOffset
    // to assure lines are pasted vertically underneath each other.
    property PasteOffset: TdtpPoint read GetPasteOffset;
    // PopupMenu specifies a popup menu that must appear when the user right-clicks
    // onto the shape.
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    // When PreserveAspect is True, the shape will always keep its aspect ratio
    // whenever the shape is resized. In order to fix the aspect ratio of a shape,
    // call procedure FixAspectRatio or set PreserveAspect to True.
    property PreserveAspect: boolean read FPreserveAspect write SetPreserveAspect;
    // ScreenDpm (read-only) specifies the number of pixels per mm that are used for displaying
    // the shape on the screen. ScreenDpm is specified in the owning TdtpDocument document.
    property ScreenDpm: single read GetScreenDpm;
    // Selected returns True if the shape is selected within the document. Set Selected to
    // True to select the shape. It will then appear with drawn handles.
    property Selected: boolean read FSelected write SetSelected;
    // SessionRef is a unique reference number during the current session. It is not
    // unique across different sessions (e.g. loading the same document at a later time). It
    // is used internally to specify the shape in Undo transactions.
    property SessionRef: integer read FSessionRef write FSessionRef;
    // ShapeCount returns the number of shapes currently present in the child shape list. See
    // also Shapes.
    property ShapeCount: integer read GetShapeCount;
    // ShapeList returns a pointer to the Shapes TList object. It should be used with care,
    // it is better to use the Shapes array property.
    property ShapeList: TList read GetShapeList;
    // The Shapes array property is a list of pointers to the child shapes that are part
    // of the shape.
    property Shapes[Index: integer]: TdtpShape read GetShapes;
    // If ShowHint is True, hint strings will appear when the user hovers over
    // a shape. If ParentShowHint is true, the hinting behaviour of the document
    // that the shape belongs to is copied.
    property ShowHint: boolean read GetShowHint write SetShowHint;
    // Storage returns the way the shape is stored. It makes no sense for the
    // ancestor shape but can be used in descendants.
    property Storage: TdtpResourceStorage read GetStorage write SetStorage;
    // Tag is an integer property that can be used by the developer to create a relation
    // with a database or other internal structure. It can be freely assigned but is
    // not stored in the underlying XML so will not be copied after document load/save or
    // after copy/cut/paste.
    property Tag: integer read FTag write SetTag;
    // TransformMatrix is the matrix used for the transformation from shape to parent.
    property Transform: TdtpTransform read FTransform;
    // If UndoEnabled (read-only) is True, the Undo functionality in the owning
    // TdtpDocument document is turned on.
    property UndoEnabled: boolean read GetUndoEnabled;
    // Set Visible to False in order to make the shape (temporarily) invisible.
    property Visible: boolean read FVisible write SetVisible;
    // Use AsBinaryString to get a copy of the shape that can be used for e.g.
    // copy/paste and assignments. The string contains all properties, subshapes
    // and resources referenced by the shape. It is thus possible to use a construct
    // like Shape1.AsBinaryString := Shape2.AsBinaryString to make a copy. Make
    // sure to set Shape1's Document property prior to the call, or else the
    // resources are lost. The resulting string is NOT nullterminated (it will
    // contain zeroes) so do not use it in Windows calls or as PChar.
    property AsBinaryString: RawByteString read GetAsBinaryString write SetAsBinaryString;
    // Assign an event to OnChange in order to get notified on changes to this shape.
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    // Assign an event to OnResize in order to get notified on changes to the
    // size of this shape.
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    // Assign an event to OnDblClick in order to fire an event whenever the user
    // double-clicks on the shape.
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
  end;

const
  chtResize = [htLT..htTop, htPoint];

// Value converteres

function BoolFrom(const AValue: string): boolean;
function FloatFrom(const AValue: string): double;
function FontStylesFrom(const AValue: string): TFontStyles;

// Create Shape classes
function RetrieveShapeClass(const AClassName: Utf8String): TdtpShapeClass;

// Register shape classes
procedure RegisterShapeClass(AClass: TdtpShapeClass; AName: Utf8String); overload;
procedure RegisterShapeClass(AClass: TdtpShapeClass); overload;

// Create a congruent rectangle ADest2 so that ASrc1 -> ASrc2 is like
// ADest1 -> ADest2
function CongruentRect(ASrc1, ASrc2, ADest1: TRect): TRect;
function CongruentRectF(ASrc1, ASrc2: TRect; ADest1: TdtpRect): TdtpRect;

// UnionRect version for floating point rects
procedure UnionRectF(var Dst: TdtpRect; Src1, Src2: TdtpRect);

// Scale a point and make it into float point
function ScalePoint(Point: TPoint; Scale: single): TdtpPoint; overload;
function ScalePoint(Point: TdtpPoint; Scale: single): TdtpPoint; overload;

// Move a point by Dx, Dy
function OffsetPointF(Point: TdtpPoint; Dx, Dy: single): TdtpPoint;

// Scale a rectangle up or down, rel. to origin
function ScaleRectF(Src: TdtpRect; Scale: single): TdtpRect;

procedure SwapFloat(var A, B: Single);

// Return -1 if I<0, 0 if I=0 and +1 if I>0
function Sign(I: integer): integer; overload;
function Sign(S: single): integer; overload;

// Read a stream from a base stream
procedure ReadStreamFromStream(S, Base: TStream);
// Read a string from a base stream
function ReadStringFromStream(Base: TStream): UTF8String;
// Write a stream to a base stream
procedure WriteStreamToStream(S, Base: TStream);
// write a string to a base stream
procedure WriteStringToStream(const S: UTF8String; Base: TStream);

// Overloaded AsString

// boolean convert
function BoolAsString(AValue: boolean): string; overload;
function BoolAsString(AValue: string): boolean; overload;

resourcestring

  sseUnknowShapeClass = 'Unknown shape class: %s';
  sseEndUpdateMismatch = 'EndUpdate called more often than BeginUpdate';

implementation

uses
  dtpDocument, dtpPlaceHolder;

type

  TDocumentAccess = class(TdtpDocument);

  TShapeClassHolder = class
  public
    FClass: TdtpShapeClass;
    FClassName: string;
  end;

var
  FShapeClassList: TObjectList = nil;

function RetrieveShapeClass(const AClassName: Utf8String): TdtpShapeClass;
var
  i: integer;
begin
  Result := nil;
  if assigned(FShapeClassList) then
  begin
    for i := 0 to FShapeClassList.Count - 1 do
      if TShapeClassHolder(FShapeClassList.Items[i]).FClassName = AClassName then
      begin
        Result := TShapeClassHolder(FShapeClassList.Items[i]).FClass;
        exit;
       end;
  end;
end;

procedure RegisterShapeClass(AClass: TdtpShapeClass; AName: Utf8String);
// Register currently unknown shape classes
var
  i: integer;
  NewClass: TShapeClassHolder;
begin
  if not assigned(FShapeClassList) then
    FShapeClassList := TObjectList.Create;

  // Exists?
  for i := 0 to FShapeClassList.Count - 1 do
    if (AClass = TShapeClassHolder(FShapeClassList.Items[i]).FClass) and
       (AName = TShapeClassHolder(FShapeClassList.Items[i]).FClassName) then
      // yes!
      exit;

  // Add new class
  NewClass := TShapeClassHolder.Create;
  NewClass.FClass := AClass;
  NewClass.FClassName := AName;
  FShapeClassList.Add(NewClass);
end;

procedure RegisterShapeClass(AClass: TdtpShapeClass);
begin
  RegisterShapeClass(AClass, AClass.ClassName);
end;

// Read a stream from a base stream
procedure ReadStreamFromStream(S, Base: TStream);
var
  Count: integer;
begin
  Base.Read(Count, SizeOf(Count));
  S.Size := Count;
  if Count > 0 then
  begin
    S.Seek(0, soFromBeginning);
    S.CopyFrom(Base, Count);
    S.Seek(0, soFromBeginning);
  end;
end;

// Read a string from a base stream
function ReadStringFromStream(Base: TStream): Utf8String;
var
  Count: integer;
begin
  Base.Read(Count, SizeOf(Count));
  SetLength(Result, Count);
  if Count > 0 then
    Base.Read(Result[1], Count);
end;

// Write a stream to a base stream
procedure WriteStreamToStream(S, Base: TStream);
var
  Count: integer;
begin
  if assigned(S) then
    Count := S.Size
  else
    Count := 0;
  Base.Write(Count, SizeOf(Count));
  if Count > 0 then
  begin
    S.Seek(0, soFromBeginning);
    Base.CopyFrom(S, Count);
  end;
end;

// write a string to a base stream
procedure WriteStringToStream(const S: UTF8String; Base: TStream);
var
  Count: integer;
begin
  Count := length(S);
  Base.Write(Count, SizeOf(Count));
  if Count > 0 then
  begin
    Base.Write(S[1], Count);
  end;
end;

function BoolAsString(AValue: boolean): string; overload;
const
  cFalseTrue: array[boolean] of string = ('False', 'True');
begin
  Result := cFalseTrue[AValue];
end;

function BoolAsString(AValue: string): boolean; overload;
begin
  if AValue = 'True' then
    Result := True
  else
    Result := False;
end;

{ TdtpShape }

procedure TdtpShape.AcceptDocBounds(ALeft, ATop, AWidth, AHeight: single);
begin
  // Check the new width/height - AWidth and AHeight may get altered
  CanResize(AWidth, AHeight);

  CanMove(ALeft, ATop, AWidth, AHeight);
  // Set the (corrected) bounds
  SetDocBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TdtpShape.AcceptDragBorder;
begin
  // Accept the previously painted (and calculated) new bounds
  AcceptDocBounds(FDragLeft, FDragTop, FDragWidth, FDragHeight);
  DocRotate(FDragAngle);
end;

procedure TdtpShape.AcceptInsertBorder(Rect: TdtpRect);
var
  Left, Top, Width, Height: single;
begin
  Left := Min(Rect.Left, Rect.Right);
  Top := Min(Rect.Top, Rect.Bottom);
  Width := abs(Rect.Right - Rect.Left);
  Height := abs(Rect.Bottom - Rect.Top);
  AcceptDocBounds(Left, Top, Width, Height);
end;

procedure TdtpShape.AddArchiveResourceNames(Names: TStrings);
var
  i: integer;
begin
  for i := 0 to ShapeCount - 1 do
    Shapes[i].AddArchiveResourceNames(Names);
end;

procedure TdtpShape.AddCmdToUndo(ACommand: TdtpCommandType; const AProp, AValue: string);
var
  Cmd: TdtpCommand;
begin
  if UndoEnabled then
  begin
    // Create the undo command, with command type ACommand, the session ref number
    // which will help to find the shape back on undo, and the property and value
    Cmd := TdtpCommand.Create(ACommand, SessionRef, AProp, AValue);
    TdtpDocument(Document).UndoAdd(Cmd);
  end else
    if RedoEnabled then
    begin
      // Add this command to the redo list
      Cmd := TdtpCommand.Create(ACommand, SessionRef, AProp, AValue);
      TdtpDocument(Document).RedoAdd(Cmd);
    end;
end;

procedure TdtpShape.AddCmdToUndo(ACommand: TdtpCommandType; const AProp: string; AValue: TFontStyles);
var
  Styles: string;
begin
  Styles := '';
  if fsBold  in AValue then
    Styles := Styles + 'B';
  if fsItalic in AValue then
    Styles := Styles + 'I';
  if fsUnderline in AValue then
    Styles := Styles + 'U';
  if fsStrikeout in AValue then
    Styles := Styles + 'S';
  AddCmdToUndo(ACommand, AProp, Styles);
end;

procedure TdtpShape.AddCmdToUndo(ACommand: TdtpCommandType; const AProp: string; AValue: double);
begin
  AddCmdToUndo(ACommand, AProp, FloatToStr(AValue));
end;

procedure TdtpShape.AddCmdToUndo(ACommand: TdtpCommandType; const AProp: string; AValue: integer);
begin
  AddCmdToUndo(ACommand, AProp, IntToStr(AValue));
end;

procedure TdtpShape.AddCmdToUndo(ACommand: TdtpCommandType; AShape: TdtpShape);
var
  S: TStream;
  Cmd: TdtpCommand;
  i, Idx, Ref: integer;
  Names: TStringList;
begin
  if not assigned(AShape) then
    exit;
  if UndoEnabled or RedoEnabled then
  begin
    case ACommand of
    cmdShapeInsert:
      begin
        // Insert shape AShape into the document when undoing; so now we must save it
        // and create the Undo command
        S := TMemoryStream.Create;
        // Additional info to store - the shape index and shape sessionref
        Idx := AShape.Index;
        S.Write(Idx, SizeOf(integer));
        Ref := AShape.SessionRef;
        S.Write(Ref, SizeOf(integer));
        // Write shape info
        WriteStringToStream(EncodeBase64(AShape.AsBinaryString), S);
        // Remove the resources the shape was using
        if Archive <> nil then
        begin
          Names := TStringList.Create;
          try
            AddArchiveResourceNames(Names);
            for i := 0 to Names.Count - 1 do
            begin
              if Archive.StreamIsUnique(UTF8String(Names[i])) then
                Archive.StreamDelete(UTF8String(Names[i]));
            end;
          finally
            Names.Free;
          end;
        end;

        // Store ACommand (cmdShapeInsert), SessionRef, Prop='ClassName',
        // Value=our classname, S contains a copy of the shape
        Cmd := TdtpCommand.Create(ACommand, SessionRef, 'ClassName', AShape.ClassName, S);
        if UndoEnabled then
          TdtpDocument(Document).UndoAdd(Cmd)
        else
          TdtpDocument(Document).RedoAdd(Cmd);
      end;
    end;
  end;
end;

procedure TdtpShape.AddCmdToUndo(ACommand: TdtpCommandType; const AProp: string; AValue: boolean);
const
  cFalseTrue: array[boolean] of string = ('False', 'True');
begin
  AddCmdToUndo(ACommand, AProp, BoolAsString(AValue));
end;

procedure TdtpShape.AdjustRelative(Pos, Size, Left, Right: boolean; OldMW, NewMW,
  OldSL, OldSW: single; var NewSL, NewSW: single);
// This is an abstraction of the principle how to resize a shape based on the
// parent (group) shape resize, taking into account the flags.
// S = Shape, M = Master, L = left, W = width, C = center, R = right
var
  OldSC, OldSR, NewSC, Scale: single;
begin
  // OldMW on zero is special case
  if OldMW = 0 then
  begin
    if Pos or Left then
      NewSL := 0
    else
      NewSL := OldSL;
    if Size or Right then
      NewSW := NewMW
    else
      NewSW := OldSW;
    exit;
  end;

  // Some preparations
  Scale := NewMW / OldMW;
  OldSC := OldSL + 0.5 * OldSW;
  NewSW := OldSW; // as a starter
  if Pos then
  begin
    // Relative position
    NewSC := OldSC * Scale;
    if Size then
      NewSW := OldSW * Scale;
    NewSL := NewSC - 0.5 * NewSW;
  end else
  begin
    // Absolute position
    if Left and Right then
    begin
      //keep left and right distance to edges
      NewSL := OldSL;
      OldSR := OldMW - OldSL - OldSW;
      NewSW := NewMW - OldSR - NewSL;
    end else if Left then
    begin
      // Left is locked
      NewSL := OldSL;
      if Size then
        NewSW := NewSW * Scale;
    end else if Right then
     begin
      // Right is locked
      OldSR := OldMW - OldSL - OldSW;
      if Size then
        NewSW := NewSW * Scale;
      NewSL := NewMW - OldSR - NewSW;
    end else
    begin
      //don't know what to do -> keep current position and size
      NewSL := OldSL;
      NewSW := OldSW;
    end;
  end;
end;

procedure TdtpShape.AdjustToConstraints;
var
  W, H: single;
begin
  W := DocWidth;
  H := DocHeight;
  CanResize(W, H);
  SetDocBounds(DocLeft, DocTop, W, H);
end;

function TdtpShape.AdjustToGrid(APoint: TdtpPoint): TdtpPoint;
// Adjust APoint so that it falls on a grid point. This function is basically
// handled in the grid-containing object, namely TdtpPage
begin
  if assigned(Parent) then
    Result := ParentToShape(Parent.AdjustToGrid(ShapeToParent(APoint)))
  else
    Result := APoint;
end;

procedure TdtpShape.Assign(Source: TPersistent);
begin
  if Source is TdtpShape then
  begin
    Clear;
    // This is an easy way to copy all properties and resources
    AsBinaryString := TdtpShape(Source).AsBinaryString;
    // We must copy the events manually
    AssignEvents(TdtpShape(Source));
  end else
    inherited;
end;

procedure TdtpShape.AssignEvents(AShape: TdtpShape);
var
  i: integer;
begin
  if not assigned(AShape) then
    exit;
  // copy events of subnodes as well
  for i := 0 to ShapeCount - 1 do
    if assigned(AShape.Shapes[i]) and (AShape.Shapes[i].ClassType = Shapes[i].ClassType) then
      Shapes[i].AssignEvents(AShape.Shapes[i]);
  FOnChange  := AShape.FOnChange;
  FOnResize := AShape.FOnResize;
  FOnDblClick := AShape.FOnDblClick;
end;

procedure TdtpShape.BeginUndo;
begin
  if Document is TdtpDocument then
    TdtpDocument(Document).BeginUndo;
end;

procedure TdtpShape.BeginUpdate;
begin
  inc(FUpdateCount);
end;

function TdtpShape.BoundsRect: TRect;
// Return the bounds in int coordinates of the viewer control
var
  V1, V2, V3, V4: TdtpPoint;
begin
  // Find corners
  CurbCornersInScreen(V1, V2, V3, V4);

  // Construct circumscribing rectangle
  Result.Left := Round(Min(Min(V1.X, V2.X), Min(V3.X, V4.X)) - 0.5);
  Result.Right := Round(Max(Max(V1.X, V2.X), Max(V3.X, V4.X)) + 0.5);
  Result.Top := Round(Min(Min(V1.Y, V2.Y), Min(V3.Y, V4.Y)) - 0.5);
  Result.Bottom := Round(Max(Max(V1.Y, V2.Y), Max(V3.Y, V4.Y)) + 0.5);
end;

function TdtpShape.BoundsRegion: HRgn;
var
  Points: array[0..3] of TPoint;
  CLT, CLB, CRT, CRB: TdtpPoint;
begin
  CurbCornersInScreen(CLT, CLB, CRT, CRB);
  Points[0] := Point(CLT);
  Points[1] := Point(CLB);
  Points[2] := Point(CRB);
  Points[3] := Point(CRT);
  Result := CreatePolygonRgn(Points, 4, ALTERNATE);
end;

procedure TdtpShape.CacheDrop;
// Drop all data that was cached, for this shape and child shapes
var
  i: integer;
begin
  // Free the cache DIB
  CacheFree;
  // Also the children
  for i := 0 to ShapeCount - 1 do
    Shapes[i].CacheDrop;
end;

procedure TdtpShape.CacheFree;
begin
  // Free the cache DIB
  FreeAndNil(FCacheDIB);
  FCacheDpm := 0;
end;

procedure TdtpShape.CalculateBounds(Delta: TdtpPoint; AltKey: boolean; HitInfo: THitTestInfo;
  var T: TdtpMatrix);
// CalculateBounds will calculate the transformation that goes with the proposed Delta
// combined with HitInfo. Results are stored in T (Transformation) rel to Left/Top
// and FDragBounds
var
  i: integer;
  D: TdtpPoint;
  MoveX, MoveY,
  ScaleX, ScaleY,
  Ang, StepAng, Angle1, Angle2, Rotate: single;
  Trans: TdtpTransform;
  Doc: TdtpDocument;
// main
begin
  //
  MoveX := 0;
  MoveY := 0;
  ScaleX := 1;
  ScaleY := 1;
  Rotate := 0;
  // copy drag locations from original to initialize
  for i := 0 to Handles.HandleCount - 1 do
    Handles[i].Drag := Handles[i].Pos;

  // First of all: the delta of the mouse rel to shape..
  D := DocToShapeMove(Delta);

  // Setup moving / resizing
  case HitInfo of
  htShape:
    begin
      MoveX := D.X;
      MoveY := D.Y;
    end;
  htLT..htTop:
    begin
      // Determine scale factors
      case HitInfo of
      htLT, htLeft, htLB: ScaleX := (FDocWidth - D.X) / FDocWidth;
      htRT, htRight, htRB: ScaleX := (FDocWidth + D.X) / FDocWidth;
      end;
      case HitInfo of
      htLT, htTop, htRT: ScaleY := (FDocHeight - D.Y) / FDocHeight;
      htLB, htBottom, htRB: ScaleY := (FDocHeight + D.Y) / FDocHeight;
      end;

      // in cases where we hit the border, and we are in preserve aspect..
      if PreserveAspect then
        case HitInfo of
        htLeft, htRight: if PreserveAspect then ScaleY := ScaleX;
        htTop, htBottom: if PreserveAspect then ScaleX := ScaleY;
        end;

      // Determine dragwidth/height based on scale, a minimum of 1 mm.
      FDragWidth := Max(ScaleX * FDocWidth,  1.0);
      FDragHeight := Max(ScaleY * FDocHeight, 1.0);

      // Check with CanResize
      CanResize(FDragWidth, FDragHeight);

      // New scale
      ScaleX := FDragWidth  / FDocWidth;
      ScaleY := FDragHeight / FDocHeight;

      // Zero position
      if HitInfo in [htLT, htLeft, htLB] then
        MoveX := FDocWidth  - FDragWidth;
      if HitInfo in [htLT, htTop, htRT] then
        MoveY := FDocHeight - FDragHeight;
      case HitInfo of
      htLeft, htRight: MoveY := (FDocHeight - FDragHeight)/2;
      htTop, htBottom: MoveX := (FDocWidth  - FDragWidth )/2;
      end;


    end;
  htRotate:
    begin
      Angle1 := arctan2(
        Handles[DragHandle].Pos.Y - FDocHeight / 2,
        Handles[DragHandle].Pos.X - FDocWidth / 2);
      Angle2 := arctan2(
        Handles[DragHandle].Pos.Y + D.Y - FDocHeight / 2,
        Handles[DragHandle].Pos.X + D.X - FDocWidth / 2);
      Rotate := (Angle1 - Angle2) * cRadToDeg;
      if assigned(Document) then
      begin
        Doc := TdtpDocument(Document);
        if (Doc.StepAngle > 0) xor AltKey then
        begin
          StepAng := Doc.StepAngle;
          if StepAng = 0 then
            StepAng := 5;
          // The angle to adjust to with the nearest increment of StepAngle
          Ang := round((DocAngle + Rotate) / StepAng) * StepAng;
          // The amount of rotation required from our current DocAngle
          Rotate := Ang - DocAngle;
        end;
      end;
    end;
  htPoint:
    begin
      if DragHandle >= 0 then
        Handles[DragHandle].Drag := OffsetPointF(Handles[DragHandle].Pos, D.X, D.Y);
    end;
  else
    CalculateCustomHittestBounds(MoveX, MoveY, ScaleX, ScaleY, Rotate, D, HitInfo);
  end;

  // Calculate dragbounds
  FDragLeft := FDocLeft + FDocAngleCos * MoveX + FDocAngleSin * MoveY;
  FDragTop := FDocTop - FDocAngleSin * MoveX + FDocAngleCos * MoveY;

  FDragWidth := ScaleX * FDocWidth;
  FDragHeight := ScaleY * FDocHeight;
  FDragAngle := FDocAngle + Rotate;

  // Create transformation
  Trans := TdtpTransform.Create;
  try
    Trans.Scale(ScaleX, ScaleY);
    if Rotate <> 0 then
      Trans.Rotate(-Rotate, FDragWidth / 2, FDragHeight / 2);
    Trans.Translate(MoveX, MoveY);

    // Calculate drag handle positions
    if HitInfo in [htShape, htLT..htTop, htRotate] then
      for i := 0 to Handles.HandleCount - 1 do
        Handles[i].Drag := Trans.XFormP(Handles[i].Pos);

    // We use transposed form
    T := Trans.Matrix;
  finally
    Trans.Free;
  end;
end;

procedure TdtpShape.CalculateCustomHittestBounds(var MoveX, MoveY, ScaleX,
  ScaleY, Rotate: single; Delta: TdtpPoint; HitInfo: THittestInfo);
// Override this method if you want to handle the custom versions of HitInfo
begin
  // Default does nothing.
end;

function TdtpShape.CanMove(var NewLeft, NewTop, NewWidth, NewHeight: single): boolean;
// Check if the shape may be moved (check AllowMove)
begin
  Result := AllowMove;
  if not AllowMove then
  begin
    // If the user is resizing, the user can still move this shape (unless
    // AllowResize is false), this is checked in CanResize
    if (NewWidth <> DocWidth) or (NewHeight <> DocHeight) then
      exit;

    // Otherwise reset the currentleft and top
    NewLeft := DocLeft;
    NewTop := DocTop;
  end
end;

function TdtpShape.CanResize(var NewWidth, NewHeight: single): boolean;
// Check if the shape can be resized to the new values, and if so, return True.
// The values for NewWidth / NewHeight are in document coordinates.
begin
  Result := AllowResize;
  if not AllowResize then
  begin
    // Enforce old size
    NewWidth := DocWidth;
    NewHeight := DocHeight;
    exit;
  end;

  // Limiting
  if Constraints.MinWidth > 0 then
    NewWidth := Max(NewWidth, Constraints.MinWidth);
  if Constraints.MaxWidth > 0 then
    NewWidth := Min(NewWidth, Constraints.MaxWidth);
  if Constraints.MinHeight > 0 then
    NewHeight := Max(NewHeight, Constraints.MinHeight);
  if Constraints.MaxHeight > 0 then
    NewHeight := Min(NewHeight, Constraints.MaxHeight);

  // Default Limiting
  NewWidth := Max(NewWidth, cDefaultMinWidth);
  NewHeight := Max(NewHeight, cDefaultMinHeight);

  // Check Aspect Ratio
  if PreserveAspect then
  begin
    try
      if NewWidth / NewHeight > FAspectRatio then
        // Image too wide, adjust width
        NewWidth := NewHeight * FAspectRatio
      else
        // Image too long, adjust height
        NewHeight := NewWidth / FAspectRatio;

      // Check if the width / height are not too small (again)
      if NewWidth < Constraints.MinWidth then
      begin
        NewWidth := Constraints.MinWidth;
        NewHeight := NewWidth / FAspectRatio;
      end;
      if NewHeight < Constraints.MinHeight then
      begin
        NewHeight := Constraints.MinHeight;
        NewWidth := NewHeight * FAspectRatio;
      end;
    except
      // Division by zero.. false parameters given
    end;
  end;
end;

function TdtpShape.CanvasRect: TRect;
// Get a rectangle that represents the current canvas' drawing rect (0, 0, DocWidth, DocHeight)
var
  LT, RB: TPoint;
begin
  LT := ShapeToPoint(dtpPoint(0, 0));
  RB := ShapeToPoint(dtpPoint(DocWidth, DocHeight));
  Result := Rect(LT.X, LT.Y, RB.X, RB.Y);
end;

procedure TdtpShape.CanvasToDIB(ABitmap: TdtpBitmap; ABkColor: TdtpColor = $00FFFFFF);
// Since the canvas drawing method will leave 00 for the alpha channel,
// we can detect if we first set the DIB's alpha channel to a value > 0. Here,
// we will reconstruct a valid, alphablended, image from the resulting data
var
  i: integer;
  C: PdtpColor;
begin
  C := @ABitmap.Bits[0];
  for i := 0 to ABitmap.Width * ABitmap.Height - 1 do
  begin
    if (C^ and $FF000000) > 0 then
      // Here nothing was drawn (this is the usual when Paint() is not overridden
      C^ := ABkColor
    else
      // Here something was drawn, we add full Alpha
      C^ := C^ or $FF000000;
    inc(C);
  end;
end;

procedure TdtpShape.Changed;
begin
  if assigned(Document) and TdtpDocument(Document).IsLoading then
    exit;
  Modified := True;
  if FUpdateCount = 0 then
  begin
    // Our own onchange
    if Assigned(FOnChange) then
      FOnChange(Self);
    // And tell the document that we changed
    if assigned(Document) then
      TDocumentAccess(Document).DoShapeChanged(Self);
    FMustCallChanged := False;
  end else
    FMustCallChanged := True;
end;

procedure TdtpShape.CheckCurbs;
const
  cGrowFactor = 1.5;
var
  i: integer;
  L, T, R, B, Curb: single;
begin
  FCurbLeft  := FStoredCurbLeft;
  FCurbTop  := FStoredCurbTop;
  FCurbRight := FStoredCurbRight;
  FCurbBottom := FStoredCurbBottom;
  // Call this overridable method so descendants can validate these new curb sizes
  ValidateCurbSizes(FCurbLeft, FCurbTop, FCurbRight, FCurbBottom);
  // Check with child shapes
  if Grouped then
  begin
    // These are the temporary curbs for the subshapes
    L := 0; T := 0; R := 0; B := 0;
    for i := 0 to ShapeCount - 1 do
      Shapes[i].ValidateCurbSizes(L, T, R, B);
    // Take the biggest and use it for all directions, to make sure that even
    // in rotated shapes we are safe
    Curb := Max(Max(L, T), Max(R, B));
    FCurbLeft := Max(Curb, FCurbLeft);
    FCurbTop := Max(Curb, FCurbTop);
    FCurbRight := Max(Curb, FCurbRight);
    FCurbBottom := Max(Curb, FCurbBottom);
  end;
end;

procedure TdtpShape.Clear;
// Clear the shape so its empty and reset defaults
var
  i: integer;
begin
  BeginUpdate;
  try
    // Delete all child shapes, except auto-created ones
    for i := ShapeCount - 1 downto 0 do
    begin
      // Once we encounter an autocreate we break from the loop
      if Shapes[i].AutoCreated then
        break;
      ShapeDelete(i);
    end;
  finally
    EndUpdate;
  end;
end;

procedure TdtpShape.Corners(var CLT, CLB, CRT, CRB: TdtpPoint);
begin
  CLT := dtpPoint(0, 0);
  CLB := dtpPoint(0, DocHeight);
  CRT := dtpPoint(DocWidth, 0);
  CRB := dtpPoint(DocWidth, DocHeight);
end;

constructor TdtpShape.Create;
begin
  inherited Create;
  // Owned objects
  FConstraints := TFloatSizeConstraint.Create;
  FShapes := TObjectList.Create;
  FTransform := TdtpTransform.Create;
  FDragTrans := TdtpTransform.Create;
  // Some defaults
  FAllowDelete := True;
  FAllowEdit := True;
  FAllowResize := True;
  FAllowMove := True;
  FAllowRotate := True;
  FAllowSelect := True;
  FAnchors := [saDefault, saLeftLock, saTopLock];
  FAspectRatio := 0;
  FCurbLeft := 0;
  FCurbRight := 0;
  FCurbBottom := 0;
  FCurbTop := 0;
  FDocAngle := 0.0;
  FDocAngleCos := 1.0;
  FDocAngleSin := 0.0;
  FDocHeight := 0;
  FDocLeft := 0;
  FDocTop := 0;
  FDocWidth := 0;
  FFlipped := False;
  FMasterAlpha := $FF;
  FMirrored := False;
  // No caching per default, switch it on for complex shapes. Although MustCache = False
  // the shape will still cache in cases of Alpha <> $FF, DocAngle <> 0, etc.
  FMustCache := False;
  FPreserveAspect := False;
  FVisible := True;
  FInsertCursor := crCross; // added by EL
end;

function TdtpShape.CreateCopy: TdtpShape;
// Create a copy of ourself and return as result
var
  SC: TdtpShapeClass;
  Node: TXmlNodeOld;
  OldStorage: TdtpResourceStorage;
  Xml: TNativeXmlOld;
begin
  SC := TdtpShapeClass(ClassType);

  Xml := CreateXmlForDtp('shape');
  Node := Xml.Root;
  try
    OldStorage := GetStorage;
    try
      SetStorage(rsEmbedded);
      // Save ourself
      SaveToXml(Node);
{$ifdef useTestData}
      Xml.XmlFormat := xfReadable;
      Xml.SaveToFile('testdata.xml');
{$endif}
      // And load into the copy
      Result := SC.CreateFromXml(Node);
    finally
      SetStorage(OldStorage);
    end;
  finally
    Xml.Free;
  end;
end;

constructor TdtpShape.CreateFromXml(ANode: TXmlNodeOld);
begin
  Create;
  LoadFromXml(ANode);
end;

procedure TdtpShape.CreateHandleObject;
begin
  if not assigned(FHandles) then
  begin
    if assigned(Document) then
      TdtpDocument(Document).CreateHandlePainter(Self, FHandles);
    // If we don't have it now, create default
    if not assigned(FHandles) then
      FHandles := TdtpHandlePainter.Create;
    FHandles.Shape := Self;
  end;
end;

procedure TdtpShape.CreateHandles;
// Create the points for the handles
begin
  // First, create handle object
  CreateHandleObject;

  // This creates the default handles and draglines
  Handles.CreateBlockHandles;
end;

procedure TdtpShape.CreatePlaceholder;
var
  Holder: TdtpPlaceHolder;
begin
  Holder := TdtpPlaceHolder.Create;
  ShapeInsert(0, Holder);
  Holder.SetDocSize(40, 30);
  Holder.Anchors := [saLeftLock, saTopLock, saSizeXprop, saSizeYProp];
  Holder.AutoCreated := True;
  FindFittingBounds;
end;

procedure TdtpShape.CurbCorners(var CLT, CLB, CRT, CRB: TdtpPoint);
begin
  CLT := dtpPoint(-FCurbLeft, -FCurbTop);
  CLB := dtpPoint(-FCurbLeft,  FCurbBottom + DocHeight);
  CRT := dtpPoint( FCurbRight + DocWidth, -FCurbTop);
  CRB := dtpPoint( FCurbRight + DocWidth,  FCurbBottom + DocHeight);
end;

procedure TdtpShape.CurbCornersInScreen(var CLT, CLB, CRT, CRB: TdtpPoint);
begin
  CLT := ShapeToScreen(dtpPoint(-FCurbLeft, -FCurbTop));
  CLB := ShapeToScreen(dtpPoint(-FCurbLeft, FCurbBottom + DocHeight));
  CRT := ShapeToScreen(dtpPoint( FCurbRight + DocWidth, -FCurbTop));
  CRB := ShapeToScreen(dtpPoint( FCurbRight + DocWidth, FCurbBottom + DocHeight));
end;

function TdtpShape.CurbedRect: TdtpRect;
begin
  Result := dtpRect(-FCurbLeft, -FCurbTop, FCurbRight + DocWidth, FCurbBottom + DocHeight);
end;

destructor TdtpShape.Destroy;
begin
  FreeAndNil(FTransform);
  FreeAndNil(FDragTrans);
  FreeAndNil(FShapes);
  FreeAndNil(FConstraints);
  FreeAndNil(FHandles);
  FreeAndNil(FCacheDIB);
  inherited;
end;

procedure TdtpShape.DisableUndo;
begin
  if Document is TdtpDocument then
    TdtpDocument(Document).DisableUndo;
end;

procedure TdtpShape.DoAnimate;
// This procedure is called each 50 msec, and can be overridden to do any
// animation. It is more efficient to use this timer than to create an additional
// one.
begin
// Default does nothing
end;

procedure TdtpShape.DocMove(ALeft, ATop: single);
begin
  SetDocBounds(ALeft, ATop, FDocWidth, FDocHeight);
end;

procedure TdtpShape.DocResize(AWidth, AHeight: single);
begin
  SetDocBounds(FDocLeft, FDocTop, AWidth, AHeight);
end;

procedure TdtpShape.DocRotate(AAngle: single);
// Rotate the shape around its center
var
  COld, SOld, CNew, SNew, W, H: single;
  CtrOld, CtrNew: TdtpPoint;
begin
  if AAngle <> FDocAngle then
  begin
    // Sines/Cosines
    COld := Cos(FDocAngle * cDegToRad);
    SOld := Sin(FDocAngle * cDegToRad);
    CNew := Cos(AAngle * cDegToRad);
    SNew := Sin(AAngle * cDegToRad);
    W := FDocWidth  / 2;
    H := FDocHeight / 2;

    // Old and new centers rel to topleft
    CtrOld.X :=   W * COld + H * SOld;
    CtrOld.Y := - W * SOld + H * COld;
    CtrNew.X :=   W * CNew + H * SNew;
    CtrNew.Y := - W * SNew + H * CNew;

    // Move and rotate at the same time
    SetDocBoundsAndAngle(
      FDocLeft + CtrOld.X - CtrNew.X,
      FDocTop  + CtrOld.Y - CtrNew.Y,
      FDocWidth, FDocHeight, AAngle);
  end;
end;

function TdtpShape.DocToShape(APoint: TdtpPoint): TdtpPoint;
begin
  if assigned(Parent) then
    APoint := Parent.DocToShape(APoint);
  Result := ParentToShape(APoint);
end;

function TdtpShape.DocToShapeMove(AMove: TdtpPoint): TdtpPoint;
begin
  if assigned(Parent) then
    AMove := Parent.DocToShapeMove(AMove);
  Result.X := (FDocAngleCos * AMove.X - FDocAngleSin * AMove.Y);
  Result.Y := (FDocAngleSin * AMove.X + FDocAngleCos * AMove.Y);
end;

procedure TdtpShape.DoAfterLoad;
begin
// default does nothing
end;

procedure TdtpShape.DoAfterPaste;
begin
// Default does nothing
end;

procedure TdtpShape.DoDblClick;
begin
  if assigned(FOnDblClick) then
    FOnDblClick(Self);
end;

procedure TdtpShape.DoEditClose(Accept: boolean);
begin
// Default does nothing
end;

procedure TdtpShape.DoDelete;
// added by J.F. Feb 2011
// needed for FontEmbedding fix, see addition in ShapeDelete
begin
// Default does nothing
end;

procedure TdtpShape.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if assigned(Document) then
    TdtpDocument(Document).DoDebugOut(Sender, WarnStyle, AMessage);
end;

function TdtpShape.DragToScreen(DragPos: TdtpPoint): TdtpPoint;
begin
  Result := ShapeToScreen(FDragTrans.XFormP(DragPos));
end;

procedure TdtpShape.Edit;
// Default Edit does just call OnDblClick and then leaves Edit mode
begin
  // Default: fire the event
  DoDblClick;
  // And signal document
  if Document is TdtpDocument then
    TdtpDocument(Document).DoEditClose(False);
end;

procedure TdtpShape.EnableUndo;
begin
  if Document is TdtpDocument then
    TdtpDocument(Document).EnableUndo;
end;

procedure TdtpShape.EndUndo;
begin
  if Document is TdtpDocument then
    TdtpDocument(Document).EndUndo;
end;

procedure TdtpShape.EndUpdate;
begin
  dec(FUpdateCount);
  if (FUpdateCount = 0) and FMustCallChanged then
    Changed;
  if FUpdateCount < 0 then
    raise Exception.Create(sseEndUpdateMismatch);
end;

function TdtpShape.ExportToBitmap(AWidth, AHeight: integer;
  Curbsize: integer; DeviceType: TDeviceType; StretchFilter: TdtpStretchFilter): TdtpBitmap;
var
  R: TdtpRect;
  S, C: double;
  DC: TDeviceContext;
begin
  // check
  Result := nil;
  if (AWidth * AHeight <= 0) or (CurbSize < 0) then
    exit;

  Result := TdtpBitmap.Create;
  Result.Width := AWidth + 2 * Curbsize;
  Result.Height := AHeight + 2 * Curbsize;
  Result.Clear($00000000);

  // Determine scale
  S := min(AWidth / DocWidth, AHeight / DocHeight);
  C := CurbSize / S;

  // Initial size
  R.Left := - C;
  R.Top := - C;
  R.Right := DocWidth + C;
  R.Bottom := DocHeight + C;

  // Setup DC
  DC.DeviceType := DeviceType;
  DC.Background := $00000000;
  DC.ActualDpm := S;
  DC.CacheDpm := S;
  DC.Quality := StretchFilter;
  DC.DropCacheAfterRender := False;
  DC.ForceResolution := False;

  // Use RenderShape function
  RenderShape(Result, R, DC, True);
end;

procedure TdtpShape.FindFittingBounds;
var
  i: integer;
  TotalRect: TdtpRect;
  OldLeft: single;
  OldTop: single;
begin
  if ShapeCount = 0 then
    exit;

  OldLeft := DocLeft;
  OldTop := DocTop;

  TotalRect := GetUnionRect;

  // Now we will adjust the shapes' top left to match
  for i := 0 to ShapeCount - 1 do
    Shapes[i].DocMove(
      Shapes[i].DocLeft + OldLeft - TotalRect.Left,
      Shapes[i].DocTop  + OldTop  - TotalRect.Top);


  // We must switch "Grouped" off temporarily before setdocbounds, otherwise
  // the shapes are going to be resized by ratio
  Grouped := False;
  try

    // And set our new bounds
    AcceptDocBounds(
      Totalrect.Left,
      TotalRect.Top,
      TotalRect.Right - Totalrect.Left,
      TotalRect.Bottom - TotalRect.Top);

    // Should we preserve this aspect ratio? If any of the subshapes have, we will
    for i := 0 to ShapeCount - 1 do
      if Shapes[i].PreserveAspect then
      begin
        FixAspectRatio;
        break;
      end;

    for i := 0 to ShapeCount - 1 do
    begin
      // The shape is now part of a group, cannot be selected individually
      Shapes[i].Selected := False;
      Shapes[i].AllowSelect := False;
    end;

  finally
    Grouped := True;
  end;
end;

procedure TdtpShape.FixAspectRatio;
begin
  FPreserveAspect := True;
  try
    FAspectRatio := DocWidth / DocHeight;
  except
    FAspectRatio := 0;
  end;
end;

function TdtpShape.GetAllowSelect: boolean;
begin
  Result := FAllowSelect;
  // Add layer support later -> adjust based on Layer.AllowSelect and Layer.Visible
end;

function TdtpShape.GetBottom: single;
var
  R: TdtpRect;
begin
  R := ParentRect(False);
  Result := R.Bottom;
end;

function TdtpShape.GetCanvasBottom: integer;
begin
  Result := ShapeToPointY(DocHeight);
end;

function TdtpShape.GetCanvasHeight: integer;
begin
  Result := CanvasBottom - CanvasTop;
end;

function TdtpShape.GetCanvasLeft: integer;
begin
  Result := ShapeToPointX(0);
end;

function TdtpShape.GetCanvasRight: integer;
begin
  Result := ShapeToPointX(DocWidth);
end;

function TdtpShape.GetCanvasTop: integer;
begin
  Result := ShapeToPointY(0);
end;

function TdtpShape.GetCanvasWidth: integer;
begin
  Result := CanvasRight - CanvasLeft;
end;

function TdtpShape.GetCurbedHeight: single;
begin
  Result := FCurbTop + DocHeight + FCurbBottom;
end;

function TdtpShape.GetCurbedWidth: single;
begin
  Result := FCurbLeft + DocWidth + FCurbRight;
end;

function TdtpShape.GetDocBottom: single;
begin
  Result := DocTop + DocHeight;
end;

function TdtpShape.GetDocRect: TdtpRect;
begin
  Result.Left := DocLeft;
  Result.Right := DocRight;
  Result.Top := DocTop;
  Result.Bottom := DocBottom;
end;

function TdtpShape.GetDocRight: single;
begin
  Result := DocLeft + DocWidth;
end;

function TdtpShape.GetEditPopupMenu: TPopupMenu;
// Must override this method in descendants to return a pointer to a specific
// edit popup menu
begin
  Result := nil;
end;

function TdtpShape.GetHandleHitTestInfoAt(APos: TPoint): THitTestInfo;
var
  R: TRect;
  i: integer;
  DL: TdtpDragLine;
begin
  Result := htNone;

  // The handles are only drawn when we're selected
  if Selected then
  begin

    // First, quick test
    R := GetInvalidationRect;
    if not PtInRect(R, APos) then
      exit;

    // We're inside the box, do we hit a handle?
    DragHandle := -1;
    for i := 0 to Handles.HandleCount - 1 do
    begin
      R := Handles.GetHandleRect(i);
      if PtInRect(R, APos) then
      begin

        // We are on a handle
        Result := Handles[i].HitTest;
        if (Result in chtResize) and not AllowResize then
          Result := htNone;
        if Result <> htNone then
        begin
          DragHandle := i;
          break;
        end;

      end;
    end;

    // Do we hit a line?
    if Result = htNone then
      for i := 0 to Handles.DraglineCount - 1 do
      begin
        DL := Handles.Draglines[i];
        if NearLine(APos,
          Point(ShapeToScreen(Handles[DL.H1].Pos)),
          Point(ShapeToScreen(Handles[DL.H2].Pos))) < cDragLimit then
        begin
          // Yep
          Result := DL.HitTest;
          if (Result in chtResize) and not AllowResize then
            Result := htNone;
          if Result <> htNone then
            break;
        end;
      end;
  end;

  // Make sure to disallow rotate if that's required
  if (Result = htRotate) and not AllowRotate then
  begin
    Result := htNone;
    DragHandle := -1;
  end;
end;

function TdtpShape.GetHasEffects: boolean;
begin
  Result := Mirrored or Flipped;
end;

function TdtpShape.GetHint: string;
begin
  if Length(FHint) > 0 then
    Result := FHint
  else
    Result := Name;
end;

function TdtpShape.GetHitTestInfoAt(APos: TPoint): THitTestInfo;
var
  i: integer;
  P: TPoint;
  H: HRgn;
  DA: TDocumentAccess;
begin
  Result := htNone;

  // Check bounds
  H := BoundsRegion;
  if H <> 0 then
  begin
    if PtInRegion(H, APos.X, APos.Y) then
      Result := htShape;
    DeleteObject(H);
  end;
  if Result = htNone then
    exit;

  if HasCache then
  begin
    // Smart hit test info based on alpha channel
    Result := GetSmartHitInfoAt(APos);
  end else
  begin
    // Check shape
    Result := htNone;
    H := ShapeRegion;
    if H <> 0 then
      if assigned(Document) then
      begin
        DA := TDocumentAccess(Document);
        for i := 0 to DA.SmartHitPointCount - 1 do
        begin
          P := DA.SmartHitPoints[i];
          if PtInRegion(H, APos.X + P.X, APos.Y + P.Y) then
          begin
            Result := htShape;
            break;
           end;
        end;
        DeleteObject(H);
      end;
  end;
end;

function TdtpShape.GetHitTestInfoDblClickAt(APos: TPoint; var AShape: TdtpShape): THitTestInfo;
var
  i: integer;
  H: HRgn;
  ChildShape: TdtpShape;
begin
  Result := htNone;
  AShape := nil;

  // Check bounds
  H := BoundsRegion;
  if H <> 0 then
  begin
    if PtInRegion(H, APos.X, APos.Y) then
    begin
      Result := htShape;
      AShape:= Self;
    end;
    DeleteObject(H);
  end;
  if Result = htNone then
    exit;

  // Check child shapes.. in order of appearance (topmost first)
  for i := ShapeCount - 1 downto 0 do
  begin
    Result := Shapes[i].GetHitTestInfoDblClickAt(APos, ChildShape);
    if Result <> htNone then
    begin
      AShape := ChildShape;
      exit;
    end;
  end;

  // Smart hit test info based on alpha channel
  if (Result = htShape) and HasCache then
  begin
    Result := GetSmartHitInfoAt(APos);
    if Result = htNone then
      AShape := nil;
  end;
end;

function TdtpShape.GetIndex: integer;
begin
  Result := -1;
  if assigned(Parent) then
    Result := Parent.ShapeIndexOf(Self);
end;

function TdtpShape.GetInvalidationRect: TRect;
var
  i: integer;
begin
  CreateHandles;
  Result := BoundsRect;
  if AllowSelect then
  begin
    // Make sure to have valid handle locations
    for i := 0 to Handles.HandleCount - 1 do
      UnionRect(Result, Result, Handles.GetHandleRect(i));
  end;
end;

function TdtpShape.GetLeft: single;
var
  R: TdtpRect;
begin
  R := ParentRect(False);
  Result := R.Left;
end;

function TdtpShape.GetMustCache: boolean;
begin
  // Does the shape require a cache?
  Result := FMustCache or
    // Some other reasons why we must use a cache
    (DocAngle <> 0.0) or      // When rotated, always use the cache
    (MasterAlpha <> 255) or   // When alpha blending we need a 32bit cache
     HasEffects;              // When we must mirror or flip the shape, and for descendants
end;

function TdtpShape.GetName: string;
begin
  Result := FName;
end;

function TdtpShape.GetPasteOffset: TdtpPoint;
// Return an offset that will be added to Left/Top when pasting
begin
  Result.X := cDefaultPasteOffsetX;
  Result.Y := cDefaultPasteOffsetY;
end;

function TdtpShape.GetRedoEnabled: boolean;
begin
  Result := False;
  if assigned(Document) then
    Result := TDocumentAccess(Document).RedoEnabled;
end;

function TdtpShape.GetRight: single;
var
  R: TdtpRect;
begin
  R := ParentRect(False);
  Result := R.Right;
end;

function TdtpShape.GetScreenDpm: single;
begin
  Result := cMonitorDpm;
  if Document is TdtpDocument then
    Result := TdtpDocument(Document).ScreenDpm;
end;

function TdtpShape.GetShapeCount: integer;
begin
  Result := 0;
  if assigned(FShapes) then
    Result := FShapes.Count;
end;

function TdtpShape.GetShapeList: TList;
begin
  Result := FShapes;
end;

function TdtpShape.GetShapes(Index: integer): TdtpShape;
begin
  if (Index >= 0) and (Index < ShapeCount) then
    Result := TdtpShape(FShapes[Index])
  else
    Result := nil;
end;

function TdtpShape.GetShowHint: boolean;
begin
  if ParentShowHint and (Document is TdtpDocument) then
    Result := TdtpDocument(Document).ShowHint
  else
    Result := FShowHint;
end;

function TdtpShape.GetSmartHitInfoAt(APos: TPoint): THitTestInfo;
var
  i: integer;
  P, Q: TPoint;
  AlphaLimit: integer;
begin
  Result := htShape;
  P := Point(ScreenToCache(APos));
  AlphaLimit := (cSmartHitAlphaLimit * MasterAlpha) div 255;
  if assigned(CacheDIB) and PtInRect(FCacheDib.ClipRect, P) then
  begin

    if assigned(Document) then
    begin
      // The document controls the number and position of the smart hit test points
      for i := 0 to TDocumentAccess(Document).SmartHitPointCount - 1 do
      begin
        Q := TDocumentAccess(Document).SmartHitPoints[i];
        if AlphaComponent(CacheDIB.PixelS[P.X + Q.X, P.Y + Q.Y]) > AlphaLimit then
          exit;
      end;
    end;

    // OK, no shape found in vicinity, so we hit nothing
    Result := htNone;
  end;
end;

function TdtpShape.GetStorage: TdtpResourceStorage;
begin
  // Default
  Result := rsEmbedded;
end;

function TdtpShape.GetTop: single;
var
  R: TdtpRect;
begin
  R := ParentRect(False);
  Result := R.Top;
end;

function TdtpShape.GetUndoEnabled: boolean;
begin
  Result := False;
  if Document is TdtpDocument then
    Result := TdtpDocument(Document).UndoEnabled;
end;

function TdtpShape.GetUnionRect: TdtpRect;
var
  i: integer;
  R: TdtpRect;
begin
  Result := dtpRect(0, 0, 0, 0);
  if ShapeCount = 0 then
    exit;

  Result := Shapes[0].ParentRect(False);
  for i := 1 to ShapeCount - 1 do
  begin

     // Retrieve the bounding rectangle (ie the space that the node currently uses)
     R := Shapes[i].ParentRect(False);

     UnionRectF(Result, Result, R);
  end;
end;

procedure TdtpShape.Grow(DeltaX, DeltaY: single);
begin
  SetDocBounds(DocLeft - DeltaX, DocTop - DeltaY,
    DocWidth + 2 * DeltaX, DocHeight + 2 * DeltaY);
end;

function TdtpShape.HasCache: boolean;
begin
  Result := assigned(FCacheDib);
end;

function TdtpShape.IntersectWithRect(ARect: TRect): boolean;
// Determine if any part of ARect overlaps with the shapes region (all in screen coords)
var
  H: HRgn;
begin
  Result := False;
  H := BoundsRegion;
  if H <> 0 then
  begin
    Result := RectInRegion(H, ARect);
    DeleteObject(H);
  end;
end;

procedure TdtpShape.Invalidate;
// We must repaint the shape to the control
begin
  // This adds the update rect to the documents canvas
  if Document is TdtpDocument then
    TdtpDocument(Document).InvalidateShape(Self);
  // The parents cache must be cleared, because its cache (with us on it) may now be invalid
  if assigned(Parent) then
    Parent.MustRegenerate;
end;

procedure TdtpShape.InvalidateSimple;
begin
  // This adds the update rect to the documents canvas
  if Document is TdtpDocument then
    TdtpDocument(Document).InvalidateShape(Self);
end;

function TdtpShape.GetIsEditing: boolean;
begin
  Result := False;
  if Document is TdtpDocument then
    Result := (TdtpDocument(Document).State = vsEdit) and (TdtpDocument(Document).EditedShape = Self)
end;

procedure TdtpShape.KeyDown(var Key: Word; Shift: TShiftState);
// Handle a key down here
begin
// If you want to handle keyboard input in shapes, then override this method
end;

procedure TdtpShape.KeyPress(var Key: Char);
// Handle a key press here
begin
// If you want to handle keyboard input in shapes, then override this method
end;

procedure TdtpShape.KeyUp(var Key: Word; Shift: TShiftState);
// Handle a key up here
begin
// If you want to handle keyboard input in shapes, then override this method
end;

procedure TdtpShape.LoadFromXml(ANode: TXmlNodeOld);
var
  i: integer;
  SC: TdtpShapeClass;
  Shape: TdtpShape;
  List: TList;
  Child: TXmlNodeOld;
  ClassName: Utf8String;
begin
  // First of all, clear the shape so we can load all new properties with
  // correct defaults.
  Clear;

  // Check if node is assigned
  if not assigned(ANode) then
    raise Exception.Create('XmlNodeNotAssigned');

  // Load our persistent properties from ANode
  FAllowResize := ANode.ReadBool('AllowResize', True);
  FAllowRotate := ANode.ReadBool('AllowRotate', True);
  FAllowSelect := ANode.ReadBool('AllowSelect', True);
  FAllowDelete := ANode.ReadBool('AllowDelete', True);
  FAllowEdit := ANode.ReadBool('AllowEdit', True);
  FAllowMove := ANode.ReadBool('AllowMove', True);
  FAspectRatio := ANode.ReadFloat('AspectRatio');
  FStoredCurbLeft := ANode.ReadFloat('CurbLeft');
  FStoredCurbTop := ANode.ReadFloat('CurbTop');
  FStoredCurbRight := ANode.ReadFloat('CurbRight');
  FStoredCurbBottom := ANode.ReadFloat('CurbBottom');
  Child := ANode.NodeByName('Anchors');
  if assigned(Child) then
  begin
    FAnchors := [];
    if Child.ReadBool('default') then
      Include(FAnchors, saDefault);
    if Child.ReadBool('PosXProp') then
      Include(FAnchors, saPosXProp);
    if Child.ReadBool('PosYProp') then
      Include(FAnchors, saPosYProp);
    if Child.ReadBool('SizeXProp') then
      Include(FAnchors, saSizeXProp);
    if Child.ReadBool('SizeYProp') then
      Include(FAnchors, saSizeYProp);
    if Child.ReadBool('LeftLock') then
      Include(FAnchors, saLeftLock);
    if Child.ReadBool('TopLock') then
      Include(FAnchors, saTopLock);
    if Child.ReadBool('RightLock') then
      Include(FAnchors, saRightLock);
    if Child.ReadBool('BottomLock') then
      Include(FAnchors, saBottomLock);
  end;
  FConstraints.MinHeight := ANode.ReadFloat('ConstraintMinHeight');
  FConstraints.MinWidth := ANode.ReadFloat('ConstraintMinWidth');
  FConstraints.MaxHeight := ANode.ReadFloat('ConstraintMaxHeight');
  FConstraints.MaxWidth := ANode.ReadFloat('ConstraintMaxWidth');
  FDocAngle := ANode.ReadFloat('DocAngle');

  // Recalculate cos/sin
  FDocAngleCos := cos(DegToRad(FDocAngle));
  FDocAngleSin := sin(DegToRad(FDocAngle));
  FDocLeft := ANode.ReadFloat('DocLeft');
  FDocTop := ANode.ReadFloat('DocTop');
  FDocHeight := ANode.ReadFloat('DocHeight');
  FDocWidth := ANode.ReadFloat('DocWidth');
  FFlipped := ANode.ReadBool('Flipped');
  FMirrored := ANode.ReadBool('Mirrored');
  FName := ANode.ReadString('Name');
  FGrouped := ANode.ReadBool('Grouped');
  FPreserveAspect := ANode.ReadBool('PreserveAspect');
  FTag := ANode.ReadInteger('Tag');
  FVisible := ANode.ReadBool('Visible', True);
  FMasterAlpha := ANode.ReadInteger('MasterAlpha', $FF);

  // child shapes
  List := TList.Create;
  try
    ANode.NodesByName('Shape', List);
    for i := 0 to List.Count - 1 do
    begin
      Child := List[i];
      ClassName := Child.ReadString('ClassName');
      SC := RetrieveShapeClass(ClassName);
      if not assigned(SC) then
      begin
        DoDebugOut(Self, wsFail, Format(sseUnknowShapeClass, [ClassName]));
        continue;
      end;
      if i < ShapeCount then
        // These are the auto-created shapes
        Shape := Shapes[i]
      else
      begin
        // new shapes
        Shape := SC.Create;
        ShapeAdd(Shape);
      end;
      try
        Shape.LoadFromXML(Child);
        Shape.DoAfterLoad;
      except
        // When we have an exception, we will delete the shape
        on E:Exception do
        begin
          DoDebugOut(Self, wsFail, E.Message);
          ShapeDelete(ShapeCount - 1);
        end;
      end;
    end;
  finally
    List.Free;
  end;

  // Additional info
  if assigned(Document) then
    TDocumentAccess(Document).DoShapeLoadAdditionalInfo(Self, ANode);

  // Regenerating should be done by caller code, after all descendants finish their LoadFromXml
end;

procedure TdtpShape.MouseDblClick(Left, Right, Shift, Ctrl: boolean; X, Y: integer);
begin
// Default does nothing
end;

procedure TdtpShape.MouseDown(Left, Right, Shift, Ctrl: boolean; X, Y: integer);
begin
// Default does nothing
end;

procedure TdtpShape.MouseMove(Left, Right, Shift, Ctrl: boolean; X, Y: integer);
begin
// Default does nothing
end;

procedure TdtpShape.MouseUp(Left, Right, Shift, Ctrl: boolean; X, Y: integer);
begin
// Default does nothing
end;

procedure TdtpShape.NextUndoNoRepeatedPropertyChange;
begin
  if assigned(Document) then
    TDocumentAccess(Document).NextUndoNoRepeatedPropertyChange;
end;

procedure TdtpShape.Paint(Canvas: TCanvas; const Device: TDeviceContext);
// Override this method to paint on the canvas. In order for this method to be
// called in the first place, make sure to set UseCanvasPainting to True!
begin
  // Must be overridden in descendant methods.
end;

procedure TdtpShape.PaintDib(Dib: TdtpBitmap; const ADevice: TDeviceContext);
// Override this one to paint on the DIB.
begin
  // Must be overridden in descendant methods.
end;

procedure TdtpShape.PaintDragBorder(Canvas: TCanvas);
// Let the handle painter do this
begin
  if not (Document is TdtpDocument) then
    exit;
  Handles.PaintDragBorder(Canvas);
end;

procedure TdtpShape.PaintEffects(DIB: TdtpBitmap; const ADevice: TDeviceContext);
// Override this method to create other effects onto the final DIB. You must
// always call "inherited" as last statement
begin
  // Default does the mirrorring and flipping
  if Mirrored then
    DIBMirror(DIB);
  if Flipped then
    DIBFlip(DIB);
end;

procedure TdtpShape.PaintForeground(DIB: TdtpBitmap; const ADevice: TDeviceContext);
begin
// Default does nothing
end;

procedure TdtpShape.PaintInsertBorder(Canvas: TCanvas; Rect: TRect; Color: TColor);
// Paint an insert border - default paints a rectangle
begin
  // Draw rectangle
  Canvas.Pen.Color := Color;
  Canvas.Pen.Style := psDot;
  Canvas.Pen.Mode := pmXOR;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(Rect);
end;

procedure TdtpShape.PaintSelectionBorder(Canvas: TCanvas);
// Let the handle painter do this
begin
  if not (Document is TdtpDocument) then
    exit;
  CreateHandles;
  Handles.PaintSelectionBorder(Canvas);
end;

function TdtpShape.ParentRect(IncludeCurbs: boolean = True): TdtpRect;
var
  V1, V2, V3, V4: TdtpPoint;
begin
  // Find corners
  if IncludeCurbs then
    CurbCorners(V1, V2, V3, V4)
  else
    Corners(V1, V2, V3, V4);
  V1 := ShapeToParent(V1);
  V2 := ShapeToParent(V2);
  V3 := ShapeToParent(V3);
  V4 := ShapeToParent(V4);

  // Construct circumscribing rectangle
  Result.Left := Min(Min(V1.X, V2.X), Min(V3.X, V4.X));
  Result.Right := Max(Max(V1.X, V2.X), Max(V3.X, V4.X));
  Result.Top := Min(Min(V1.Y, V2.Y), Min(V3.Y, V4.Y));
  Result.Bottom := Max(Max(V1.Y, V2.Y), Max(V3.Y, V4.Y));
end;

function TdtpShape.ParentToShape(APoint: TdtpPoint): TdtpPoint;
begin
  APoint := OffsetPointF(APoint, -DocLeft, -DocTop);
  Result.X := FDocAngleCos * APoint.X - FDocAngleSin * APoint.Y;
  Result.Y := FDocAngleSin * APoint.X + FDocAngleCos * APoint.Y;
end;

function TdtpShape.PerformCommand(ACommand: TdtpCommand): boolean;
// Perform the command ACommand if it is destined for us, otherwise delegate
var
  i: integer;
  SC: TdtpShapeClass;
  Shape: TdtpShape;
  Idx, Ref: integer;
begin
  Result := False;
  if not assigned(ACommand) then
    exit;

  // Check for whom the command is destined
  if ACommand.Ref = SessionRef then
  begin

    // It is for us, so set Result to True to indicate the destination was found
    Result := True;

    // Perform commands
    case ACommand.Command of
    cmdSetProp: // Set a property
      SetPropertyByName(ACommand.Prop, ACommand.Value);
    cmdShapeDelete:
      ShapeDelete(StrToInt(ACommand.Value));
    cmdShapeInsert: // Insert a shape
      begin
        // Retrieve the class and create the shape
        SC := RetrieveShapeClass(ACommand.Value);
        Shape := SC.Create;
        // Load additional info
        ACommand.Stream.Read(Idx, SizeOf(integer));
        ACommand.Stream.Read(Ref, SizeOf(integer));
        // Insert the shape
        ShapeInsert(Idx, Shape);
        // and read its properties and resources and subshapes
        Shape.AsBinaryString := DecodeBase64(ReadStringFromStream(ACommand.Stream));
        // And restore its ref from the Prop variable
        Shape.SessionRef := Ref;
      end;
    end;

  end else
  begin
    // Check if the children are the destination
    for i := 0 to ShapeCount - 1 do
    begin
      Result := Shapes[i].PerformCommand(ACommand);
      if Result then
        exit;
    end;
  end;
end;

procedure TdtpShape.RenderScreenElements(Dib: TdtpBitmap; DibRect: TdtpRect);
begin
// Default does nothing
end;

procedure TdtpShape.RenderShapeCached(Dib: TdtpBitmap; DibRect: TdtpRect;
  const ADevice: TDeviceContext; UseDirectCoords: boolean = False);
// Recreate the cache, if neccesary, and draw the cache to the Dib. DibRect is given in parent coordinates,
// unless UseDirectCoords is true, in that case DibRect is given in shape coords.
var
  CacheR: TdtpRect;
  CacheValid: boolean;
  T: TdtpTransform;
  Sampler: TdtpMapSampler;
  W, H, CurbL, CurbT: integer;
  ChildDevice: TDeviceContext;

  // local: Determine cache Dib rectangle
  procedure ComputeCacheDibRect;
  begin
    // Determine size of cache dib rectangle
    //FCacheDpm := Device.RenderDpm;
    W := ceil((DocWidth + FCurbRight) * FCacheDpm);
    CurbL := ceil(FCurbLeft * FCacheDpm);
    CacheR.Left := -CurbL / FCacheDpm;
    CacheR.Right := W / FCacheDpm;
    H := ceil((DocHeight + FCurbBottom) * FCacheDpm);
    CurbT := ceil(FCurbTop * FCacheDpm);
    CacheR.Top := -CurbT / FCacheDpm;
    CacheR.Bottom := H / FCacheDpm;
  end;

  // local: Build the cache, and draw to it
  procedure BuildCache;
  begin
    // This may take a while for bigguns so signal user with hourglass
    if Document is TdtpDocument then
      TdtpDocument(Document).SetWindowsCursor(crAppStart);

    // Determine size of cache dib rectangle
    FCacheDpm := ADevice.CacheDpm;
    ComputeCacheDibRect;

    // Set cache
    if not assigned(FCacheDib) then
      FCacheDib := TdtpBitmap.Create;
    FCacheDib.Width := W + CurbL;
    FCacheDib.Height := H + CurbT;
    FCacheDib.Clear(ADevice.Background);
    FCacheDib.OuterColor := ADevice.Background;
    SetCombineMode(FCacheDib, dtpcmMerge);
    SetDrawMode(FCacheDib, dtpdmBlend);
    SetStretchFilter(FCacheDib, ADevice.Quality);
  end;
  
// main
begin
  // Determine validity of cache
  CacheValid := CacheIsValid;
  if (ADevice.CacheDpm > FCacheDpm) or
    ((ADevice.CacheDpm < FCacheDpm) and ADevice.ForceResolution) then
    CacheValid := False;

  // Not a valid cache?
  if not CacheValid then
  begin

    // Build the cache
    BuildCache;
    // Draw on the cache
    ChildDevice := ADevice;
    ChildDevice.ActualDpm := FCacheDpm;

    RenderShapeDirect(FCacheDib, CacheR, ChildDevice);
    // Paint effects
    PaintEffects(FCacheDib, ChildDevice);

    // Render screen elements
    if ADevice.DeviceType = dtScreen then
      RenderScreenElements(FCacheDib, CacheR);

  end;

  FCacheDib.MasterAlpha := MasterAlpha;

  // Draw our cache to the bitmap
  T := TdtpTransform.Create;
  try

    // Setup transform from cache to Dib
    ComputeCacheDibRect;
    T.Translate(-CurbL, -CurbT);
    T.Scale(1/FCacheDpm, 1/FCacheDpm);
    if not UseDirectCoords then
    begin
      T.Rotate(-DocAngle, 0, 0);
      T.Translate(DocLeft, DocTop);
    end;
    T.Translate(-DibRect.Left, -DibRect.Top);
    T.Scale(
      Dib.Width / (DibRect.Right - DibRect.Left),
      Dib.Height / (DibRect.Bottom - DibRect.Top));

    // Do the actual transformation
    Sampler := TdtpMapSampler.Create;
    try
      Sampler.Dest := Dib;
      Sampler.DestRect := DibRect;
      Sampler.Map := FCacheDib;
      Sampler.Transform := T;
      // Sample the map using inverted transform T
      Sampler.SampleRect(dtpRect(CacheDib.ClipRect));
    finally
      Sampler.Free;
    end;
  finally
    T.Free;
  end;

  // Check if we must drop the cache
  if ADevice.DropCacheAfterRender then
    CacheFree;
end;

procedure TdtpShape.RenderShapeDirect(Dib: TdtpBitmap; DibRect: TdtpRect; const ADevice: TDeviceContext);
// Render this shape to a Dib, might it be cache or direct bitmap. We will not use the cache, but
// redraw the shape. No check is done for visibility. The DibRect is in Shape coordinates
var
  i: integer;
  Canvas: TCanvas;
  // local
  function CreateTransform4p(Dtl, Stl, Dbr, Sbr: TdtpPoint): TdtpMatrix;
  var
    Sx, Sy: double;
    T: TdtpTransform;
  begin
    T := TdtpTransform.Create;
    try
      Sx := (Dbr.x - Dtl.x) / (Sbr.x - Stl.x);
      Sy := (Dbr.y - Dtl.y) / (Sbr.y - Stl.y);
      T.Translate(-Stl.x, -Stl.y);
      T.Scale(Sx, Sy);
      Result := T.Matrix;
    finally
      T.Free;
    end;
  end;
// main
begin
  // Make sure blending occurs right and preserves the alpha channel
  SetCombineMode(Dib, dtpcmMerge);
  SetDrawMode(Dib, dtpdmBlend);
  SetStretchFilter(Dib, ADevice.Quality);

  // Set a transformation so that we transform directly to the doc coordinates
  SetTransformation(
    CreateTransform4p(dtpPoint(0, 0), DibRect.TopLeft,
      dtpPoint(Dib.Width, Dib.Height), DibRect.BottomRight));
  PaintDIB(Dib, ADevice);

  // Painting on a GDI canvas
  if UseCanvasPainting then
  begin
    // we invert alpha before..
    InvertAlpha(Dib);
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := Dib.Handle;
      // Here we paint on the GDI canvas
      Paint(Canvas, ADevice);
    finally
      Canvas.Free;
    end;
    //..and after, to ensure that GDI drawing commands are visible
    InvertAlpha(Dib);
  end;

  // Render the children, render each visible child shape in Z-order
  for i := 0 to ShapeCount - 1 do
  begin
    // Skip if shape not visible
    if not Shapes[i].Visible then
      continue;

    // Render child shape
    Shapes[i].RenderShape(Dib, DibRect, ADevice);
  end;

  // Last paint stage
  PaintForeground(Dib, ADevice);
end;

procedure TdtpShape.RenderShape(Dib: TdtpBitmap; DibRect: TdtpRect;
  const ADevice: TDeviceContext; UseDirectCoords: boolean = False);
// Render the shape to a 32bit bitmap, the Dibs extents are given in DibRect, which
// is defined in Parent coordinates, unless UseDirectCoords is true. The shape must
// be *merged* to this Dib.
var
  SD, R: TdtpRect;
begin
  // Do we need to draw anything?
  // SD is the shape's outer rectangle in Parent or Direct coordinates
  if UseDirectCoords then
    SD := CurbedRect
  else
    SD := ParentRect(True);

  if UseDirectCoords then // added by J.F. Feb 2011 - see TdtpDocuments.UseDocumentBoard
    if not IntersectRect(R, DibRect, SD) then
      exit;

  if MustCache then
  begin

    RenderShapeCached(Dib, DibRect, ADevice, UseDirectCoords);

  end else
  begin

    // We can throw away any cache if it existed at this point
    CacheFree;

    // We can paint directly to this Dib
    if not UseDirectCoords then
    begin
      DibRect.TopLeft     := ParentToShape(DibRect.TopLeft);
      DibRect.BottomRight := ParentToShape(DibRect.BottomRight);
    end;
    RenderShapeDirect(Dib, DibRect, ADevice);

    // Render screen elements
    if ADevice.DeviceType = dtScreen then
      RenderScreenElements(Dib, DibRect);
  end;
end;

procedure TdtpShape.Refresh;
begin
  MustRegenerate;
  CheckCurbs;
  Invalidate;
end;

procedure TdtpShape.Regenerate;
// We must regenerate the shape to the cached DIB
var
  i: integer;
begin
  MustRegenerate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].Regenerate;
  CheckCurbs;
  Invalidate;
end;

procedure TdtpShape.SaveToXml(ANode: TXmlNodeOld);
var
  i: integer;
  Child: TXmlNodeOld;
begin
  if not assigned(ANode) then
    exit;
  // Save our class name first
  ANode.WriteString('ClassName', ClassName);

  // Save our persistent properties to ANode
  ANode.WriteBool('AllowResize', FAllowResize, True);
  ANode.WriteBool('AllowMove', FAllowMove, True);
  ANode.WriteBool('AllowRotate', FAllowRotate, True);
  ANode.WriteBool('AllowSelect', FAllowSelect, True);
  ANode.WriteBool('AllowDelete', FAllowDelete, True);
  ANode.WriteBool('AllowEdit', FAllowEdit, True);

  Child := ANode.NodeNew('Anchors');
  Child.WriteBool('default', saDefault in Anchors);
  Child.WriteBool('PosXProp', saPosXProp in Anchors);
  Child.WriteBool('PosYProp', saPosYProp in Anchors);
  Child.WriteBool('SizeXProp', saSizeXProp in Anchors);
  Child.WriteBool('SizeYProp', saSizeYProp in Anchors);
  Child.WriteBool('LeftLock', saLeftLock in Anchors);
  Child.WriteBool('TopLock', saTopLock in Anchors);
  Child.WriteBool('RightLock', saRightLock in Anchors);
  Child.WriteBool('BottomLock', saBottomLock in Anchors);

  ANode.WriteFloat('AspectRatio', FAspectRatio);
  ANode.WriteFloat('CurbLeft', FStoredCurbLeft);
  ANode.WriteFloat('CurbTop', FStoredCurbTop);
  ANode.WriteFloat('CurbRight', FStoredCurbRight);
  ANode.WriteFloat('CurbBottom', FStoredCurbBottom);
  ANode.WriteFloat('ConstraintMinHeight', FConstraints.MinHeight);
  ANode.WriteFloat('ConstraintMinWidth', FConstraints.MinWidth);
  ANode.WriteFloat('ConstraintMaxHeight', FConstraints.MaxHeight);
  ANode.WriteFloat('ConstraintMaxWidth', FConstraints.MaxWidth);
  ANode.WriteFloat('DocAngle', FDocAngle);
  ANode.WriteFloat('DocLeft', FDocLeft);
  ANode.WriteFloat('DocTop', FDocTop);
  ANode.WriteFloat('DocHeight', FDocHeight);
  ANode.WriteFloat('DocWidth', FDocWidth);
  ANode.WriteBool('Flipped', FFlipped);
  ANode.WriteBool('Grouped', FGrouped);
  ANode.WriteBool('Mirrored', FMirrored);
  ANode.WriteString('Name', FName);
  ANode.WriteBool('PreserveAspect', FPreserveAspect);
  ANode.WriteInteger('Tag', FTag);
  ANode.WriteBool('Visible', FVisible, True);
  ANode.WriteHex('MasterAlpha', FMasterAlpha, 2, $FF);

  // Child shapes
  for i := 0 to ShapeCount - 1 do
  begin
    Child := ANode.NodeNew('Shape');
    Child.AttributeAdd('Index', IntToStr(i + 1));
    Shapes[i].SaveToXml(Child);
  end;

  // Additional info
  if assigned(Document) then
    TDocumentAccess(Document).DoShapeSaveAdditionalInfo(Self, ANode);
end;

function TdtpShape.ScreenToCache(APoint: TPoint): TdtpPoint;
begin
  Result := ShapeToCache(ScreenToShape(APoint));
end;

function TdtpShape.ScreenToShape(APoint: TPoint): TdtpPoint;
begin
  if Document is TdtpDocument then
    Result := DocToShape(TdtpDocument(Document).ScreenToDoc(APoint));
end;

function TdtpShape.ScreenToShapeMove(AMove: TPoint): TdtpPoint;
var
  ScMove: TdtpPoint;
begin
  if assigned(Parent) then
  begin
    ScMove := Parent.ScreenToShapeMove(AMove)
  end else
  begin
    ScMove.X := AMove.X / ScreenDpm;
    ScMove.Y := AMove.Y / ScreenDpm;
  end;
  Result.X := (FDocAngleCos * ScMove.X - FDocAngleSin * ScMove.Y);
  Result.Y := (FDocAngleSin * ScMove.X + FDocAngleCos * ScMove.Y);
end;

procedure TdtpShape.SetAllowSelect(const Value: boolean);
begin
  if FAllowSelect <> Value then
  begin
    InvalidateSimple;
    FAllowSelect := Value;
    InvalidateSimple;
  end;
end;

procedure TdtpShape.SetAnchors(const Value: TShapeAnchors);
begin
  if FAnchors <> Value then
  begin
    FAnchors := Value;
    Changed;
  end;
end;

procedure TdtpShape.SetBottom(const Value: single);
begin
  DocMove(DocLeft, DocTop + Value - Bottom);
end;

procedure TdtpShape.SetCurbSize(AThickness: single);
begin
  SetCurbSizes(AThickness, AThickness, AThickness, AThickness);
end;

procedure TdtpShape.SetCurbSizes(ALeft, ATop, ARight, ABottom: single);
begin
  if (ALeft <> FStoredCurbLeft) or (ATop <> FStoredCurbTop) or
     (ARight <> FStoredCurbRight) or (ABottom <> FStoredCurbBottom) then
  begin
    FStoredCurbLeft := ALeft;
    FStoredCurbTop := ATop;
    FStoredCurbRight := ARight;
    FStoredCurbBottom := ABottom;
    CheckCurbs;
    // The cache changes, so signal this
    FCacheDpm := 0;
  end;
end;

procedure TdtpShape.SetDocAngle(const Value: single);
begin
  if FDocAngle <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'DocAngle', FDocAngle);
    Invalidate;
    FDocAngle := Value - (floor(Value / 360)) * 360;
    // Store these, they are used often to construct transforms
    FDocAngleCos := Cos(FDocAngle * cDegToRad);
    FDocAngleSin := Sin(FDocAngle * cDegToRad);
    // After rotating, the cache doesn't look the same on the parent, so free it
    if assigned(Parent) then
      Parent.MustRegenerate;
    Invalidate;
    Changed;
  end;
end;

procedure TdtpShape.SetDocBottom(const Value: single);
begin
  DocHeight := Value - DocTop;
end;

procedure TdtpShape.SetDocBounds(ALeft, ATop, AWidth, AHeight: single);
begin
  SetDocBoundsAndAngle(ALeft, ATop, AWidth, AHeight, FDocAngle);
end;

procedure TdtpShape.SetDocBoundsAndAngle(ALeft, ATop, AWidth, AHeight, AAngle: single);
// Change all doc bounds at the same time, to avoid intermediate flicker
var
  i: integer;
  SizeChanged: boolean;
  NewLeft, NewWidth, NewTop, NewHeight: single;
  ShapeAnchors: TShapeAnchors;
  OldDocAngle: single;
  Child: TdtpShape;
begin
  if (ALeft <> FDocLeft)
    or (ATop <> FDocTop)
    or (AWidth <> FDocWidth)
    or (AHeight <> FDocHeight)
    or (AAngle <> FDocAngle) then
  begin
    // Invalidate old window
    Invalidate;

    SizeChanged := (AWidth <> FDocWidth) or (AHeight <> FDocHeight);

    // Child Shapes will change size and position if we are resized and grouped is true.
    if Grouped and SizeChanged then
    begin
      try
        for i := 0 to ShapeCount - 1 do
        begin
          // set the new child's bounds in accordance with ours. Note: this may cause illegal
          // (too small) sizes in the child controls. If this is a problem, then override this
          // method with one that checks all childs using AcceptDocBounds
          Child := Shapes[i];

          // undo rotation to adjust bounds
          OldDocAngle := Child.DocAngle;
          Child.DocAngle := 0.0;

          if saDefault in Child.Anchors then
          begin
            // Default resizing for the shape - horizontal
            AdjustRelative(
              True, AllowResize, False, False,
              DocWidth, AWidth, Child.DocLeft, Child.DocWidth, NewLeft, NewWidth);
            // Default resizing for the shape - vertical
            AdjustRelative(
              True, AllowResize, False, False,
              DocHeight, AHeight, Child.DocTop, Child.DocHeight, NewTop, NewHeight);
          end else
          begin
            ShapeAnchors := Child.Anchors;
            // Specific resizing for the shape - horizontal
            AdjustRelative(
              saPosXprop in ShapeAnchors, saSizeXprop in ShapeAnchors, saLeftLock in ShapeAnchors, saRightLock in ShapeAnchors,
              DocWidth, AWidth, Child.DocLeft, Child.DocWidth, NewLeft, NewWidth);
            // Specific resizing for the shape - vertical
            AdjustRelative(
              saPosYprop in ShapeAnchors, saSizeYprop in ShapeAnchors, saTopLock in ShapeAnchors, saBottomLock in ShapeAnchors,
              DocHeight, AHeight, Child.DocTop, Child.DocHeight, NewTop, NewHeight);
          end;
          // And set these new shape bounds
          Child.SetDocBounds(NewLeft, NewTop, NewWidth, NewHeight);

          { If the shape is locked to both opposite edges, we need to set the
            center rather than top/left. }
          if ((Child.Anchors * [saLeftLock, saRightLock]) = [saLeftLock, saRightLock]) or
             ((Child.Anchors * [saTopLock, saBottomLock]) = [saTopLock, saBottomLock]) then
            Child.SetDocCenter(NewLeft+0.5*NewWidth, NewTop+0.5*NewHeight);

          // restore rotation
          Child.DocAngle := OldDocAngle;
        end;
      except
      end;
    end;

    // New values - set through these procedures so they can be overridden
    BeginUndo;
    try
      if (ALeft <> DocLeft) or (ATop <> DocTop) then
        SetDocPosition(ALeft, ATop);
      if SizeChanged then
        SetDocSize(AWidth, AHeight);
      if AAngle <> DocAngle then
        SetDocAngle(AAngle);

    finally
      EndUndo;
    end;

    // Invalidate new window
    Invalidate;
    Changed;

    // OnResize event
    if assigned(FOnResize) and SizeChanged then
      FOnResize(Self);
  end;
end;

procedure TdtpShape.SetDocBoundsAsTRect(ALeft, ATop, ARight, ABottom: single);
// Set the document bounds so they match the windows GDI Rectangle function, and
// this means, the right is defined as one past the real end of the doc, as well
// for the bottom.
begin
  SetDocBounds(ALeft, ATop, ARight - ALeft + 1, ABottom - ATop + 1);
end;

procedure TdtpShape.SetDocCenter(CenterX, CenterY: single);
var
  W, H: single;
begin
  W := Right - Left;
  H := Bottom - Top;
  Left := CenterX - (W / 2);
  Top := CenterY - (H / 2);
end;

procedure TdtpShape.SetDocHeight(const Value: single);
begin
  if FDocHeight <> Value then
    SetDocBounds(DocLeft, DocTop, DocWidth, Value);
end;

procedure TdtpShape.SetDocLeft(const Value: single);
begin
  if FDocLeft <> Value then
    SetDocBounds(Value, DocTop, DocWidth, DocHeight);
end;

procedure TdtpShape.SetDocPosition(ALeft, ATop: single);
begin
  BeginUndo;
  if ALeft <> FDocLeft then
    AddCmdToUndo(cmdSetProp, 'DocLeft', FDocLeft);
  if ATop <> FDocTop then
    AddCmdToUndo(cmdSetProp, 'DocTop',  FDocTop);
  EndUndo;
  // Default does just this
  FDocLeft := ALeft;
  FDocTop := ATop;
end;

procedure TdtpShape.SetDocRect(const Value: TdtpRect);
begin
  SetDocBounds(Value.Left, Value.Top,
    Value.Right - Value.Left, Value.Bottom - Value.Top);
end;

procedure TdtpShape.SetDocRight(const Value: single);
begin
  DocWidth := Value - DocLeft;
end;

procedure TdtpShape.SetDocSize(AWidth, AHeight: single);
begin
  BeginUndo;
  if AWidth <> FDocWidth then
    AddCmdToUndo(cmdSetProp, 'DocWidth',  FDocWidth);
  if AHeight <> FDocHeight then
    AddCmdToUndo(cmdSetProp, 'DocHeight', FDocHeight);
  EndUndo;
  // Default does just this
  if (FDocWidth <> AWidth) or (FDocHeight <> AHeight) then
  begin
    FDocWidth := AWidth;
    FDocHeight := AHeight;
    // placeholder
    // The cache changes if our document size changes
    MustRegenerate;
  end;
end;

procedure TdtpShape.SetDocTop(const Value: single);
begin
  if FDocTop <> Value then
    SetDocBounds(DocLeft, Value, DocWidth, DocHeight);
end;

procedure TdtpShape.SetDocument(const Value: TObject);
var
  i: integer;
begin
  if FDocument <> Value then
  begin
    FDocument := Value;
    if FDocument is TdtpDocument then
      SessionRef := TDocumentAccess(FDocument).GetNewSessionRef;
    Invalidate;
    // set the document of our child shapes too
    for i := 0 to ShapeCount - 1 do
      Shapes[i].Document := Value;
  end;
end;

procedure TdtpShape.SetDocWidth(const Value: single);
begin
  if FDocWidth <> Value then
    SetDocBounds(DocLeft, DocTop, Value, DocHeight);
end;

procedure TdtpShape.SetDragTrans(ATrans: TdtpMatrix);
begin
  FDragTrans.Matrix := ATrans;
end;

procedure TdtpShape.SetFlipped(const Value: boolean);
begin
  if Value <> FFlipped then
  begin
    FFlipped := Value;
    DocRotate(-DocAngle);
    Regenerate;
    Changed;
  end;
end;

procedure TdtpShape.SetGrouped(const Value: boolean);
begin
  if FGrouped <> Value then
  begin
    FGrouped := Value;
    Refresh;
  end;
end;

procedure TdtpShape.SetLeft(const Value: single);
begin
  DocMove(DocLeft + Value - Left, DocTop);
end;

procedure TdtpShape.SetMasterAlpha(const Value: cardinal);
begin
  if FMasterAlpha <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'MasterAlpha', FMasterAlpha);
    FMasterAlpha := Value;
    Invalidate;
    Changed;
  end;
end;

procedure TdtpShape.SetMirrored(const Value: boolean);
begin
  if Value <> FMirrored then
  begin
    FMirrored := Value;
    DocRotate(-DocAngle);
    Regenerate;
    Changed;
  end;
end;

procedure TdtpShape.SetModified(const Value: boolean);
var
  i: integer;
begin
  if FModified <> Value then
  begin
    FModified := Value;
    if Value = False then
      for i := 0 to ShapeCount - 1 do
        Shapes[i].Modified := False;
    if Value = True then
  end;
  if Value = True then
  begin
    // we have changed so our parent too
    if assigned(Parent) then
      Parent.Modified := True;
    // Document modfied as well, we place this here to make sure
    // the document remembers the last tick something was modified
    if assigned(Document) then
      TdtpDocument(Document).Modified := True;
  end;
end;

procedure TdtpShape.SetMustCache(const Value: boolean);
begin
  FMustCache := Value;
end;

procedure TdtpShape.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
    Changed;
  end;
end;

procedure TdtpShape.SetParent(const Value: TdtpShape);
begin
  if FParent <> Value then
  begin
    FParent := Value;
    Invalidate;
  end;
end;

procedure TdtpShape.SetPreserveAspect(const Value: boolean);
begin
  if Value <> FPreserveAspect then
  begin
    if Value then
      FixAspectRatio;
    FPreserveAspect := Value;
  end;
end;

procedure TdtpShape.SetPropertyByName(const AName, AValue: string);
// Here we will analyse AName and set the correct property if found
begin
  if AnsiCompareText(AName, 'DocLeft') = 0 then
    DocLeft := FloatFrom(AValue);
  if AnsiCompareText(AName, 'DocTop') = 0 then
    DocTop := FloatFrom(AValue);
  if AnsiCompareText(AName, 'DocWidth') = 0 then
    DocWidth := FloatFrom(AValue);
  if AnsiCompareText(AName, 'DocHeight') = 0 then
    DocHeight := FloatFrom(AValue);
  if AnsiCompareText(AName, 'DocAngle') = 0 then
    DocAngle := FloatFrom(AValue);
  if AnsiCompareText(AName, 'MasterAlpha') = 0 then
    MasterAlpha := StrToInt(AValue);
end;

procedure TdtpShape.SetRight(const Value: single);
begin
  DocMove(DocLeft + Value - Right, DocTop);
end;

procedure TdtpShape.SetSelected(const Value: boolean);
begin
  // If shape cannot be selected, no need to try
  if Value and not AllowSelect then
    exit;
  //..otherwise
  if FSelected <> Value then
  begin
    FSelected := Value;
    if Document is TdtpDocument then
      TDocumentAccess(Document).DoSelectionChanged;
    InvalidateSimple;
  end;
end;

procedure TdtpShape.SetShowHint(const Value: boolean);
begin
  if FShowHint <> Value then
  begin
    FShowHint := Value;
    ParentShowHint := False;
  end;
end;

procedure TdtpShape.SetStorage(const Value: TdtpResourceStorage);
begin
// default does nothing
end;

procedure TdtpShape.SetTop(const Value: single);
begin
  DocMove(DocLeft, DocTop + Value - Top);
end;

procedure TdtpShape.SetTransformation(const ATrans: TdtpMatrix);
// This method can be overridden in descendants to do special size calculations
begin
  FTransform.Matrix := ATrans;
end;

procedure TdtpShape.SetVisible(const Value: boolean);
begin
  if FVisible <> Value then
  begin
    if not Value then
      Selected := False;
    FVisible := Value;
    Invalidate;
    Changed;
  end;
end;

function TdtpShape.ShapeAdd(AShape: TdtpShape): integer;
begin
  Result := -1;
  if assigned(FShapes) and assigned(AShape) then
  begin
    AddCmdToUndo(cmdShapeDelete, '', FShapes.Count);
    Result := FShapes.Add(AShape);
    AShape.Document := Document;
    AShape.Parent := Self;
    Invalidate;
    Changed;
  end;
end;

procedure TdtpShape.ShapeClear;
begin
  while ShapeCount > 0 do
    ShapeDelete(0);
end;

procedure TdtpShape.ShapeDelete(Index: integer);
var
  i: integer;
  Shape: TdtpShape;
  Names: TStringList;
  A: TsdStorage;
begin
  if (Index >= 0) and (Index < ShapeCount) then
  begin
    Shape := Shapes[Index];
    AddCmdToUndo(cmdShapeInsert, Shape);
    Invalidate;
    // Remove resources used by the shape
    A := Shape.Archive;
    if assigned(A) then
    begin
      Names := TStringList.Create;
      try
        Shape.AddArchiveResourceNames(Names);
        for i := 0 to Names.Count - 1 do
        begin
          if A.StreamIsUnique(UTF8String(Names[i])) then
            A.StreamDelete(UTF8String(Names[i]));
        end;
      finally
        Names.Free;
      end;
    end;
    Shape.Selected := False;
    if assigned(Document) then
      TDocumentAccess(Document).DoShapeDestroy(Shape);
    // added by J.F. Feb 2011 part of fix for FontEmbedding - see PolygonText
    Shape.DoDelete;
    Shape.Parent := nil;
    Shape.Document := nil;
    FShapes.Delete(Index);
    Changed;
  end;
end;

procedure TdtpShape.ShapeExchange(i, j: integer);
// Swap shapes i and j
begin
  if assigned(Shapes[i]) and assigned(Shapes[j]) and (i <> j) then
  begin

    // Swap the pointers
    FShapes.Exchange(i, j);

    // This will redraw the shapes
    Shapes[i].Invalidate;
    Shapes[j].Invalidate;
    Changed;
  end;
end;

function TdtpShape.ShapeExtract(AShape: TdtpShape): TdtpShape;
begin
  Result := nil;
  if assigned(FShapes) and assigned(AShape) then
  begin
    // Extracted shape is no longer in document and has no parent, so set these to nil
    AddCmdToUndo(cmdShapeInsert, AShape);
    Invalidate;
    AShape.Selected := False;
    AShape.Parent := nil;
    AShape.Document := nil;
    Result := TdtpShape(FShapes.Extract(AShape));
    Changed;
  end;
end;

function TdtpShape.ShapeIndexOf(AShape: TdtpShape): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to ShapeCount - 1 do
    if Shapes[i] = AShape then
    begin
      Result := i;
      exit;
    end;
end;

procedure TdtpShape.ShapeInsert(Index: Integer; AShape: TdtpShape);
begin
  if assigned(FShapes) and assigned(AShape) then
  begin
    AddCmdToUndo(cmdShapeDelete, '', Index);
    FShapes.Insert(Index, AShape);
    AShape.Parent := Self;
    AShape.Document := Document;
    Invalidate;
    Changed;
  end;
end;

function TdtpShape.ShapeRegion: HRgn;
// Override shaperegion to get a more complex region than the outer rectangle to
// define the shape, for use when SmartHitTest should be left to false.
var
  Points: array[0..3] of TPoint;
  LT, LB, RT, RB: TdtpPoint;
begin
  LT := ShapeToScreen(dtpPoint(0, 0));
  LB := ShapeToScreen(dtpPoint(0, DocHeight));
  RT := ShapeToSCreen(dtpPoint(DocWidth, 0));
  RB := ShapeToScreen(dtpPoint(DocWidth, DocHeight));
  Points[0] := Point(LT);
  Points[1] := Point(LB);
  Points[2] := Point(RB);
  Points[3] := Point(RT);
  Result := CreatePolygonRgn(Points, 4, ALTERNATE);
end;

function TdtpShape.ShapeRemove(AShape: TdtpShape): integer;
begin
  Result := -1;
  if assigned(FShapes) and assigned(AShape) then
  begin
    Result := FShapes.IndexOf(AShape);
    ShapeDelete(Result);
  end;
end;

function TdtpShape.ShapeToCache(APoint: TdtpPoint): TdtpPoint;
begin
  Result := dtpPoint(-1, -1);
  if CacheIsValid then
  begin
    Result.X := APoint.X * FCacheDpm + ceil(FCurbLeft * FCacheDpm);
    Result.Y := APoint.Y * FCacheDpm + ceil(FCurbTop * FCacheDpm);
  end;
end;

function TdtpShape.ShapeToDoc(APoint: TdtpPoint): TdtpPoint;
begin
  // First to parent
  Result := ShapeToParent(APoint);
  // Then to doc
  if assigned(Parent) then
    Result := Parent.ShapeToDoc(Result);
end;

function TdtpShape.ShapeToFloat(APoint: TdtpPoint): TdtpPoint;
begin
  Result := FTransform.XFormP(APoint);
end;

function TdtpShape.ShapeToParent(APoint: TdtpPoint): TdtpPoint;
begin
  Result.X :=  FDocAngleCos * APoint.X + FDocAngleSin * APoint.Y;
  Result.Y := - FDocAngleSin * APoint.X + FDocAngleCos * APoint.Y;
  Result := OffsetPointF(Result, DocLeft, DocTop);
end;

function TdtpShape.ShapeToPixel(Value: single): integer;
begin
  // Assume that we have equal scaling, however, since this method is used mostly
  // for text height, we use the vertical one
  Result := round(FTransform.VerticalScale(Value));
end;

function TdtpShape.ShapeToPoint(APoint: TdtpPoint): TPoint;
begin
  Result := Point(ShapeToFloat(APoint));
end;

function TdtpShape.ShapeToPointX(AX: single): integer;
begin
  Result := round(FTransform.XFormX(AX));
end;

function TdtpShape.ShapeToPointY(AY: single): integer;
begin
  Result := round(FTransform.XFormY(AY));
end;

function TdtpShape.ShapeToScreen(APoint: TdtpPoint): TdtpPoint;
begin
  if Document is TdtpDocument then
    Result := TdtpDocument(Document).DocToScreen(ShapeToDoc(APoint));
end;

class function TdtpShape.UseCanvasPainting: boolean;
begin
  // Defaults to false
  Result := False;
end;

procedure TdtpShape.ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single);
// Check the new curb sizes and decide if they are OK or not
begin
  // Default just checks cases for Mirror and Flip. It should come last.
  if Mirrored then
  begin
    CurbLeft := Max(CurbLeft, CurbRight);
    CurbRight := CurbLeft;
  end;
  if Flipped then
  begin
    CurbTop := Max(CurbTop, CurbBottom);
    CurbBottom := CurbTop;
  end;
end;

{ Procedures }

function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;

function BoolFrom(const AValue: string): boolean;
var
  Val: AnsiChar;
begin
  Result := False;
  Val := AnsiChar(Upcase(AValue[1]));
  if Length(AValue) > 0 then
    Result := CharInSet(Val, ['Y', 'T']);
end;

function FloatFrom(const AValue: string): double;
begin
  Result := StrToFloat(AValue);
end;

function FontStylesFrom(const AValue: string): TFontStyles;
begin
  Result := [];
  if Pos('B', AValue) > 0 then Result := Result + [fsBold];
  if Pos('I', AValue) > 0 then Result := Result + [fsItalic];
  if Pos('U', AValue) > 0 then Result := Result + [fsUnderline];
  if Pos('S', AValue) > 0 then Result := Result + [fsStrikeout];
end;

function CongruentRect(ASrc1, ASrc2, ADest1: TRect): TRect;
// Create a congruent rectangle ADest2 so that ASrc1 -> ASrc2 is like
// ADest1 -> ADest2
var
  MulX: single;
  MulY: single;
begin
  try
    MulX := (ADest1.Right - ADest1.Left) / (ASrc1.Right - ASrc1.Left);
    MulY := (ADest1.Bottom - ADest1.Top) / (ASrc1.Bottom - ASrc1.Top);
    Result.Left := round((ASrc2.Left - ASrc1.Left) * MulX) + ADest1.Left;
    Result.Right := round((ASrc2.Right - ASrc1.Left) * MulX) + ADest1.Left;
    Result.Top := round((ASrc2.Top - ASrc1.Top) * MulY) + ADest1.Top;
    Result.Bottom := round((ASrc2.Bottom - ASrc1.Top) * MulY) + ADest1.Top;
  except
    // division by zero
    ADest1 := Rect(0, 0, 0, 0);
  end;
end;

function CongruentRectF(ASrc1, ASrc2: TRect; ADest1: TdtpRect): TdtpRect;
// Create a congruent rectangle ADest2 so that ASrc1 -> ASrc2 is like
// ADest1 -> ADest2
var
  MulX: single;
  MulY: single;
begin
  MulX := (ADest1.Right - ADest1.Left) / (ASrc1.Right - ASrc1.Left);
  MulY := (ADest1.Bottom - ADest1.Top) / (ASrc1.Bottom - ASrc1.Top);
  Result.Left := (ASrc2.Left - ASrc1.Left) * MulX + ADest1.Left;
  Result.Right := (ASrc2.Right - ASrc1.Left) * MulX + ADest1.Left;
  Result.Top := (ASrc2.Top - ASrc1.Top ) * MulY + ADest1.Top;
  Result.Bottom := (ASrc2.Bottom - ASrc1.Top ) * MulY + ADest1.Top;
end;

procedure SwapFloat(var A, B: Single);
var
  Temp: single;
begin
  Temp := A;
  A := B;
  B := Temp;
end;

procedure UnionRectF(var Dst: TdtpRect; Src1, Src2: TdtpRect);
begin
  Dst.Left := Min(Src1.Left, Src2.Left);
  Dst.Top := Min(Src1.Top, Src2.Top );
  Dst.Right := Max(Src1.Right, Src2.Right);
  Dst.Bottom := Max(Src1.Bottom, Src2.Bottom);
end;

function ScalePoint(Point: TPoint; Scale: single): TdtpPoint;
begin
  Result.X := Point.X * Scale;
  Result.Y := Point.Y * Scale;
end;

function ScalePoint(Point: TdtpPoint; Scale: single): TdtpPoint;
begin
  Result.X := Point.X * Scale;
  Result.Y := Point.Y * Scale;
end;

function OffsetPointF(Point: TdtpPoint; Dx, Dy: single): TdtpPoint;
begin
  Result.X := Point.X + Dx;
  Result.Y := Point.Y + Dy;
end;

function ScaleRectF(Src: TdtpRect; Scale: single): TdtpRect;
begin
  Result.Left := Src.Left * Scale;
  Result.Top := Src.Top * Scale;
  Result.Right := Src.Right * Scale;
  Result.Bottom := Src.Bottom * Scale;
end;

function Sign(I: integer): integer; overload;
begin
  if I < 0 then
    Result := -1
  else
    if I > 0 then
      Result := +1
    else
      Result := 0;
end;

function Sign(S: single): integer; overload;
begin
  if S < 0 then
    Result := -1
  else
    if S > 0 then
      Result := +1
    else
      Result := 0;
end;

function TdtpShape.CacheIsValid: boolean;
begin
  Result := assigned(FCacheDib) and (FCacheDpm > 0);
end;

procedure TdtpShape.MustRegenerate;
begin
  FCacheDpm := 0;
  if assigned(Parent) then
    Parent.MustRegenerate;
end;

function TdtpShape.GetIsPlaceHolderVisible: boolean;
begin
  Result := False;
  if (ShapeCount > 0) and (Shapes[0] is TdtpPlaceHolder) then
    Result := Shapes[0].Visible;
end;

procedure TdtpShape.SetIsPlaceHolderVisible(const Value: boolean);
begin
  if (ShapeCount > 0) and (Shapes[0] is TdtpPlaceHolder) then
    Shapes[0].Visible := Value;
end;

procedure TdtpShape.SetTag(const Value: integer);
begin
  if FTag <> Value then
  begin
    FTag := Value;
    Changed;
  end;
end;

function TdtpShape.GetAsBinaryString: RawByteString;
// Write out all the shape's properties, subshapes, and resources as one binary string
var
  Names: TStringList;
  M, R: TMemoryStream;
  i, Count: integer;
  Xml: TNativeXmlOld;
begin
  M := TMemoryStream.Create;
  R := TMemoryStream.Create;
  try
    // Add all used resources
    Names := TStringList.Create;
    try
      AddArchiveResourceNames(Names);
      // Store these resources
      Count := Names.Count;
      if Archive = nil then
        Count := 0;
      M.Write(Count, SizeOf(Count));
      for i := 0 to Count - 1 do
      begin
        WriteStringToStream(UTF8String(Names[i]), M);
        R.Clear;
        if Archive.StreamExists(UTF8String(Names[i])) then
          Archive.StreamRead(UTF8String(Names[i]), R);
        WriteStreamToStream(R, M);
      end;
    finally
      Names.Free;
    end;

    // Add properties and subshapes in form of XML
    R.Clear;
    Xml := CreateXmlForDtp('shape');
    try
      SaveToXml(Xml.Root);
      Xml.SaveToStream(R);
    finally
      Xml.Free;
    end;
    WriteStreamToStream(R, M);
    // to do: find a way to add events and object references

    // Add all to result
    SetLength(Result, M.Size);
    if M.Size > 0 then
    begin
      move(M.Memory^, Result[1], M.Size);
    end;
  finally
    R.Free;
    M.Free;
  end;

end;

procedure TdtpShape.SetAsBinaryString(const Value: RawByteString);
// Read in all the shape's properties, subshapes, and resources from one binary string
var
  Name: string;
  M, R: TMemoryStream;
  i, Count: integer;
  Xml: TNativeXmlOld;
begin
  M := TMemoryStream.Create;
  R := TMemoryStream.Create;
  try
    // Get M
    M.Size := length(Value);
    if M.Size = 0 then
      exit;

    move(Value[1], M.Memory^, M.Size);

    // Read all used resources
    M.Read(Count, SizeOf(Count));
    for i := 0 to Count - 1 do
    begin
      Name := string(ReadStringFromStream(M));
      ReadStreamFromStream(R, M);
      if (R.Size > 0) and (Archive <> nil) then
        // write to the archive
        Archive.StreamWrite(UTF8String(Name), R);
    end;

    // properties
    ReadStreamFromStream(R, M);
    Xml := CreateXmlForDtp('shape');
    try
      Xml.LoadFromStream(R);
      LoadFromXml(Xml.Root);
      // We loaded from XML so must call DoAfterLoad virtual procedure
      DoAfterLoad;
    finally
      Xml.Free;
    end;

  finally
    R.Free;
    M.Free;
  end;

end;

function TdtpShape.Archive: TsdStorage;
begin
  Result := nil;
  if assigned(Document) then
    Result := TdtpDocument(Document).Archive;
end;

initialization

  RegisterShapeClass(TdtpShape);

finalization

  FreeAndNil(FShapeClassList);

end.

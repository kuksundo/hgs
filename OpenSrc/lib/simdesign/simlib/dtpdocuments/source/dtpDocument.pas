{ Unit dtpDocument

  dtpDocument is the Desktop Publishing Document viewer. It is a descendant of
  TCustomControl, therefore you can drop it on a form or on a scrollbox, and it
  will instantly provide DTP functionality to the application.

  dtpDocument implements all mouse action coordination, as well as cached drawing
  of the different pages.

  Use the method PageAdd() to add a new page. You can first create this page
  using a construct like
  <code>

    APage := TdtpPage.Create;
    // Set some defaults
    APage. ...
    Document.PageAdd(APage);

  </code>
  You can also create a default page using Document.PageAdd(nil). By default,
  the document creates one page. Call "Clear" to empty the document completely.

  Project: DtpDocuments

  Creation Date: 25-10-2002 (NH)
  Version: See "versions.txt"

  Modifications:
  01Aug2003: Load/Save methods
  11Aug2003: Added auto-scrolling
  09Apr2004: Added inline documentation
  03jun2011: placed global resource thread in DtpDocument.pas

  Contributors:
  20Jan2004: Emmanuel Lion - insertion cursors
  24Feb2004: Allen Drennan - right mouseclick events
  20Jan2010: Greg Bishop - Delphi2010 compat for unicode "string"
  23Jun2010: JohnF - Scroll with mousewheel, auto-delete text shapes (JF)
  14apr2011: JF - preparation for guides, rsRuler fixes, allows more keycombin.

  Copyright (c) 2002-2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
}
unit dtpDocument;

{$i simdesign.inc}

interface

uses
  Windows, Messages, Forms, Classes, Controls, Contnrs, Graphics, SysUtils,
  Math, SyncObjs, ExtDlgs, ExtCtrls, Dialogs, Clipbrd, Printers, Menus,

  // simdesign
  NativeXmlOld, sdStorage, sdStreams, sdDebug,

  // dtpdocuments
  dtpGraphics, dtpShape, dtpPage, dtpCommand, dtpBitmapShape, dtpXmlBitmaps,
  dtpDefaults, dtpBitmapResource, dtpHandles, dtpRsRuler, dtpTransform,
  dtpTruetypeFonts, dtpGuides, dtpHint; // dtpGuides added by J.F. June 2011

{$R DtpCursors.res} // added by EL

const

  // Version string
  cDtpDocumentsVersion: string = '2.93';

  // this is the version that uses NativeXmlOld instead of NativeXml. NativeXml is probably faster
  // but it has exposed rather a few problems, and I do not want to debug NativeXml now..

const
  WM_DELETE_SHAPE = WM_USER + 56;     // changed by J.F. Feb 2011


type
           // number of decimal places of Numerical Hint value
  TdtpHintPrecision = (ghp1Decimal, ghp2Decimals, ghp3Decimals);//  added by J.F. June 2011

  // Progress type that is ongoing in OnProgress
  TdtpProgressType = (
    ptLoad,        // Load routine is firing OnProgress
    ptSave,        // Save routine is firing OnProgress
    ptPrint,       // Print routine is firing OnProgress
    ptWizard       // "Wizard is adding pages.."
  );

  // events
  TNotifyPageEvent = procedure(Sender: TObject; Page: TdtpPage) of object;
  TNotifyShapeEvent = procedure(Sender: TObject; Shape: TdtpShape) of object;
  TdtpLoadErrorEvent = procedure(Sender: TObject; Shape: TdtpShape; Error: string) of object;
  TdtpProgressEvent = procedure(Sender: TObject; AType: TdtpProgressType; ACount,
    ATotal: integer; APercent: single) of object;
  TdtpPaintEvent = procedure (Sender: TObject; Canvas: TCanvas; const Device: TDeviceContext; const PageRect: TRect) of object;
  TdtpFilingEvent = procedure (Sender: TObject; Node: TXmlNodeOld) of object;
  TdtpShapeFilingEvent = procedure (Sender: TObject; Shape: TdtpShape; Node: TXmlNodeOld) of object;
  TdtpHandlePainterEvent = procedure(Sender: TObject; Shape: TdtpShape; var HandlePainter: TdtpHandlePainter) of object;
  TdtpLocateFilenameEvent = procedure (Sender: TObject; var AName: string) of object;
  TdtpDrawQualityIndicatorEvent = procedure (Sender: TObject; Canvas: TCanvas;
    var Rect: TRect; Quality: integer; var Drawn: boolean) of object;
  TdtpMessageEvent = procedure (Sender: TObject; const AMessage: string) of object;
                              //  added by J.F. June 2011
  TdtpGuideRightClickEvent = procedure(Sender: Tobject; var Position: single) of object;
                              //  added by J.F. July 2011
  TdtpMarginRightClickEvent = procedure(Sender: TObject; var Position: single) of object;

  // Viewer mode in the TdtpDocument window
  TdtpViewerModeType = (
    vmBrowse,       // Hand cursor, drag document around, default when ReadOnly = True
    vmEdit,         // Arrow cursor, select shapes. default when ReadOnly = False
    vmTextSelect,   // Select text with drag rect Text cursor
    vmZoom,         // Zoom mode, zoomplus cursor
    vmSlideshow     // Slideshow mode
  );

  // Viewer state in the TdtpDocument window
  TdtpViewerStateType = (
    vsNone,
    vsDrag,         // User is dragging
    vsSelect,       // When user clicks, it selects a shape
    vsBeforeInsert, // Before user clicks/drags to insert
    vsInsert,       // When user click/drags, a shape is inserted at that location (FInsertShape)
    vsEdit          // All mouse/kb events go to the focused control
  );
          //  added by J.F. June 2011
  TdtpViewerFunctionType = (
    vfNone,
    vfPanning,
    vfMouseButtonZoom,
    vfMouseDragZoom,
    vfGuideMoving,
    vfMarginMoving,
    vfDirectPanning,
    vfDirectMouseButtonZoom,
    vfDirectMouseDragZoom,
    vfDirectMouseZoomInOut
  );


  // Multiple shape selection method, either use [CTRL] to select multiple shapes in a
  // drag rectangle, or start in an empty spot (msmSimple)
  TMultiSelectMethodType = (
    msmCtrl,        // User must press CTRL and drag a rectangle to select multiple items
    msmSimple       // User can just click/drag to select multiple items, but must do so in empty spot
  );

  // Insert modes for inserting new shapes in the document
  TdtpInsertModeType = (
    imBySingleClick, // User only clicks once and the shape gets inserted
    imByRectangle    // User drags a bounding box where shape gets inserted
  );

  // Print quality setting
  TPrintQualityType = (
    pqLow,           // Low print quality, defaults to 150 DPI
    pqMedium,        // Medium print quality, defaults to 300 DPI
    pqHigh,          // High print quality, defaults to 600 DPI
    pqDevice         // Use device's maximum DPI. WARNING this can cause long print times
  );

  // Document speed versus memory performance
  TdtpDocPerformanceType = (
    dpMemoryOverSpeed, // This default setting will always try to keep mem consumption optimal, sometimes causing speed penalties
    dpSpeedOverMemory  // This setting will allow memory consumption to grow to allow for higher speed (only use on systems with more than 512Mb)
  );

  // Hotzone scrolling method
  TdtpHZScrollingType = (
    hzsNoScroll,       // Do not perform hotzone scrolling
    hzsAlways,         // Always perform hotzone scrolling
    hzsWhenMouseDown   // Only perform hotzone scrolling when mouse is down (e.g. dragging...)
  );

  TdtpHandlePainterType = (
    hpStippleHandle,   // Old-style stippled handles
    hpW2K3Handle,      // New-style "word 2003" handles
    hpCustomHandle     // Custom handle painter, must override OnCreateHandlePainter
  );

  // TdtpDocument implements a complete DeskTop Publishing control, including all
  // mouse processing, key processing and rendering. TdtpDocument is derived from
  // a custom windowed control so it gets paint messages and has a canvas to draw on.
  // TdtpComponent is an overridden version of TdtpDocument that publishes most
  // properties and is present on the component palette.
  TdtpDocument = class(TdtpVirtualScrollbox)
  private
    FAllowKeyInput: boolean;     // The key events will be processed and passed to shapes
    FAltKeyDown: boolean;        // Used internally to signal that the [Alt] key is depressed
    FAnimateTimer: TTimer;       // A timer object that is used for a number of things, (animation, schedule automatic page thumbnail update)
    FAnimating: boolean;         // If true, the document is in a call to TimerAnimate
    FArchive: TsdStorage;        // Reference to an archive that stores our data
    FArchiveDirect: boolean;     // If TRUE, changes like page del/insert are directly done in the archive (default = FALSE)
    FAutoPageUpdate: boolean;    // Automatically update page thumbnails (timered)
    FAutoWidth: boolean;         // Automatically adjust width to 100% when resizing
    FAutoDeleteShape: boolean;   // Auto-Delete e.g. empty TextShapes (added by JF)
    FIsAdjusting: boolean;       // The control is adjusting the scrollbounds (avoid nested calls)
    FClipboardPage: TdtpPage;    // Pointer to page from where was cut/copied
    FCurrentPageIndex: integer;  // Current page index
    FDefaultBackgroundImage: TdtpBitmapResource; // Bitmap32 containing a default background image (or nil if none)
    FDefaultBackgroundTiled: boolean; // Do we tile the background image?
    FDefaultGridColor: TColor;   // Default grid color (usually light blue)
    FDefaultGridSize: single;    // Default grid size in mm
    FDefaultMarginBottom: single;// Default page margin bottom size in mm
    FDefaultMarginLeft: single;  // Default page margin left size in mm
    FDefaultMarginRight: single; // Default page margin right size in mm
    FDefaultMarginTop: single;   // Default page margin top size in mm
    FDefaultPageColor: TColor;   // Default page color (usually clWhite)
    FDefaultPageHeight: single;  // Default page height in mm
    FDefaultPageWidth: single;   // Default page width in mm
    FDevice: TDeviceType;        // Last used device for painting (dtScreen, dtPrinter, ..)
    FWasDoubleClicking: boolean; // Flag indicating if double-click was going on
    FDragBordersDrawn: boolean;  // If True, some dragborders are currently drawn
    FDragPosDoc: TdtpPoint;    // Drag position in document coords (corrected for "SnapToGrid" if applicable)
    FDragDeltaDoc: TdtpPoint;  // Drag Delta in document coords (corrected for "SnapToGrid" if applicable)
    FDraggedShape: TdtpShape;    // Currently dragged shape
    FEditedShape: TdtpShape;     // Currently edited shape
    FEditPopup: TPopupMenu;      // A pointer to the edit popup menu that will make sure some edit key commands are handled
    FFocusedShape: TdtpShape;    // The currently focused shape
    FFontEmbedding: boolean;     // Use Font Embedding
    FFontManager: TdtpFontManager;// Truetype font manager
    FHandleColor: TColor;        // Color of the handles
    FHandleEdgeColor: TColor;    // Color of the handle edges
    FHandlePainter: TdtpHandlePainterType; // Choose which kind of handles are painted
    FHelperMethod: TdtpHelperMethodType;// Helper method that is painted (none, dots, grid, pattern)
    FHintHidePause: integer;     // Pause for hint before disappearing if mouse still over control
    FHintPause: integer;         // Pause for hint when no previous hint is displayed

    FHintShape: TdtpShape;       // Current shape that is displaying a hint (or about to)
    FHintShortPause: integer;    // Pause for hint if another is already displayed

    FHitInfo: THitTestInfo;      // Hit info when starting drag
    FHitSensitivity: single;     // Hit sensivity (area for smart hittest)
    FHotzoneScrolling: TdtpHZScrollingType; // When mouse is in hotzone (edge) the control will scroll
    FHotzoneLastTick: dword;     // Last timer tick that hotzone was entered
    FHotzoneDuration: dword;     // Current duration of hotzone entrance
    FHotzoneActive: boolean;     // Is hotzoning active?
    FHotzoneTimer: TTimer;       // Timer that will be enabled when hotzoning
    FHotzoneOldPos: TPoint;      // Last position of mouse in hotzone
    FInsertMode: TdtpInsertModeType;// Use either a single click or drag for insert
    FInsertShape: TdtpShape;     // The shape to insert when in insert mode
    FInternalClipboard: string;  // If we do not use the Window's clipboard we use this one
    FIsLoading: boolean;         // True if document is calling LoadPageFromXml, used to prevent Changed event
    FIsRedoing: boolean;         // True during redo operation
    FState: TdtpViewerStateType; // Viewer working state (see TdtpViewerStateType)
    FMode: TdtpViewerModeType;   // Viewer mode (see TdtpViewerModeType)
    FModified: boolean;          // Current document is modified
    FModifiedTick: dword;        // Updated whenever Modified is called
    FMultiSelectMethod: TMultiSelectMethodType; // Use CTRL/drag or Simple click/drag
    FMustCallShapeChanged: boolean;// If set, we must call OnShapeChanged at EndUpdate
    FMustCallSelectionChanged: boolean;// If set, we must call OnSelectionChanged at EndUpdate
    FMustCallFocusShape: boolean;// If set, we must call OnFocusedShape at EndUpdate
    FNoRepeatedPropertyChange: boolean; // If set, in next UndoAdd call the propertychange won't be registered
    FOptimizedPrinting: boolean; // Skip empty blocks when printing
                            // Panning added June 2011 by J.F.

    FMousePanningOldPos: TPoint;      // Last position of mouse in Panning
    FPanWithMouseButton: boolean;    // Is Panning Allowed?
                           // Mouse Button Zooming added by J.F. June 2011

    FZoomWithMouseButton: boolean;    // Is Zooming Allowed

    FPaintEditBorder: boolean;   // If true (default), paint dotted border around Text shapes when editing (added by JF)
    FPages: TObjectList;         // Owned list of page shapes
    FPageUpdateInterval: integer;// The period to wait with thumbnail updates after modified was set
    FPerformance: TdtpDocPerformanceType; // Favour memory over speed (default) or speed over memory
    FPrevWidth: integer;         // Previous window width, used internally to track size changes
    FPrintNestCount: integer;    // Number of nested times that BeginPrint was called
    FPrintQuality: TPrintQualityType; // Choose pqLow, pqMedium, pqHigh or pqDevice, and it will set PrinterDpm accordingly
    FProgressCount: integer;     // Latest progress info is stored
    FProgressTotal: integer;     // Latest progress info is stored
    FQuality: TdtpStretchFilter;    // Set to sfLinear1 by default, choose sfNearest for fastest, sfSpline for highquality
    FReadOnly: boolean;          // If set, no shapes can be selected
    FRedoEnabled: boolean;       // If true (usually only temp), commands will be added to redo list instead of undo list.
    FRedos: TObjectList;         // List with redo-commands
    FRefCounter: integer;        // A unique session number for each shape added to this document
    FRulerLeft: TdtpRsRuler;
    FRulerTop: TdtpRsRuler;
    FRulerCorner: TdtpRsRulerCorner;
    FRulerUnits: TRulerUnit;
    FScreenDpm: single;          // Screen dots per mm, this is recalculated when changing zoom factor
    FShowMargins: boolean;       // If set, draw the stippled margins

    //If set shows page border and shadow for ViewStyle = vsPrintLayout
    FShowPageShadow: boolean;    // added by J.F. Feb 2011

    FSnapToGrid: boolean;        // When true, inserted points are set to the nearest grid point

    // When true, inserted points are set to the nearest guides
    FSnapToGuides: boolean;      // added by J.F. Feb 2011
    FSmartHitPoints: array of TPoint; // smart hittest points
    FStepAngle: single;          // When > 0, this value is used to step the angles just like snaptogrid
    FStoreThumbnails: boolean;   // Store the thumbnails in the archive file (default = true)
    FThumbnailHeight: integer;   // Thumbnail height used for page thumbnails
    FThumbnailWidth: integer;    // Thumbnail width used for page thumbnails
    FUndoDisableCount: integer;  // If > 0, the undo is temporarily disabled
    FUndoEnabled: boolean;       // If set (default), the document will keep undo information
    FUndoNestCount: integer;     // Number of nested times that BeginUndo was called
    FUndoNestAdditions: boolean; // During nesting there were additions
    FUndoPastSave: boolean;      // When true, the user can undo even past save points
    FUndos: TObjectList;         // List with undo-commands
    FUndoSize: integer;          // Current total bytes used by undo-commands
    FUpdateNestCount: integer;   // Number of nested times that BeginUpdate was called
    FUpgradeFromPreviousVersion: boolean; // Document is upgrading from previous version, page content
                                 // must be saved even if not modified
    FUseClipboard: boolean;      // Use Window's clipboard (True) or internal clipboard (False)
    FViewStyle: TdtpViewStyleType;// Print Layout view or Normal View?
    FWindowLeft: single;         // The X coord of left upper point of zoom window
    FWindowTop: single;          // The Y coord of left upper point of zoom window
    FWorkingCount: integer;      // Number of times that BeginWorking was called
    FZoomPercent: single;        // Percentage of width when using AutoZoom (Default = 100)
    FOnDocumentChanged: TNotifyEvent;
    FOnFocusShape: TNotifyShapeEvent;
    FOnShapeChanged: TNotifyShapeEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseUp: TMouseEvent;
    FScrollWithMouseWheel: boolean; // added by JF
    FOnPageChanged: TNotifyPageEvent;
    FOnProgress: TdtpProgressEvent;
    FOnSelectionChanged: TNotifyEvent;
    FOnAnimate: TNotifyEvent;
    FOnCreateHandlePainter: TdtpHandlePainterEvent;
    FOnLoadError: TdtpLoadErrorEvent;
    FOnPaintBackground: TdtpPaintEvent;
    FOnPaintForeground: TdtpPaintEvent;
    FOnShapeInsertClosed: TNotifyShapeEvent;
    FOnShapeDestroy: TNotifyShapeEvent;
    FOnShapeLoadAdditionalInfo: TdtpShapeFilingEvent;
    FOnShapeSaveAdditionalInfo: TdtpShapeFilingEvent;
    FOnLoadAdditionalInfo: TdtpFilingEvent;
    FOnSaveAdditionalInfo: TdtpFilingEvent;
    FOnShapeEditClosed: TNotifyShapeEvent;
    FOnUpdateScrollPosition: TNotifyEvent;
    FOnShapeListChanged: TNotifyEvent;
    FOnLocateFilename: TdtpLocateFilenameEvent;
    FOnDrawQualityIndicator: TdtpDrawQualityIndicatorEvent;
    FOnShapeEditStart: TNotifyShapeEvent; // added by JF
    FOnShapeInsertStart: TNotifyShapeEvent;  // added by JF

    // Allows shapes to be put and saved outside of Page, on document background
    FUseDocumentBoard: boolean; // added by J.F. Feb

    FOnGuideRightClick: TdtpGuideRightClickEvent;  // added by J.F. June 2011

    FOnMarginRightClick: TdtpMarginRightClickEvent;  //  added by J.F. July 2011

    // changed page shadow color for ex. clLightGray32
    FPageShadowColor: TdtpColor; // added by J.F. Feb 2011

    FDocumentCreatedWithVersion: Utf8String;  // added by J.F. Feb 2011
    FDocumentModifiedWithVersion: Utf8String; // added by J.F. Feb 2011

    FGuideColor: TColor; // added by J.F. Feb 2011
    FGuidesToFront: boolean; // added by J.F. Feb 2011
    FGuidesVisible: boolean; // added by J.F. Feb 2011
    FGuidesLocked: boolean;  // added by J.F. June 2011

    FShapeHint: TdtpHint;  //  added by J.F. July 2011
    FMarginHint: TdtpHint;  //  added by J.F. July 2011
    FGuideHint: TdtpHint;  //  added by J.F. July 2011

    FShowGuideHints: boolean;  // changed by J.F. July 2011
    FHintPrecision: TdtpHintPrecision;  //  added by J.F. June 2011
    FHintGuide: TdtpGuide;  // added by J.F. June 2011
    FSnapToGuidesOffset: TdtpPoint;  //  added by J.F. July 2011

    FShowMarginHints: boolean;  //  added by J.F. July 2011
    FHintMargin: TdtpSelectedMarginType;  //  added by J.F. July 2011

    FShowShapeHints: boolean;  //  added by J.F. July 2011

    FZoomStep: single; // added by J.F. June 2011
    FZoomWithMouseWheel: boolean; // added by J.F. June 2011
    FZoomWithRectangle: boolean;  //  added by J.F. June 2011

    FMouseWheelScrollSpeed: integer; // added by J.F. June 2011

    FMouseDragZoomFinalPos: TPoint; // added by J.F. June 2011
    FMouseDragZoomOrgPos: TPoint;  // added by J.F. June 2011

    FAutoFocus: boolean; //  added by J.F. June 2011

    FViewerFunction: TdtpViewerFunctionType; // added by J.F. June 2011

    FShapeNudgeEnabled: boolean;  //  added by J.F. June 2011
    FShapeNudgeDistance: single;  //  added by J.F. June 2011

    FSavedHotzoneScrolling: TdtpHZScrollingType;  // added by J.F. July 2011

    FMarginsLocked: boolean;  // added by J.F. July 2011

    procedure AcceptDragBorders;
    procedure AcceptInsertBorder;
    procedure AcceptSelectBorder;
    procedure BuildEditPopup;
    procedure BuildSmartHitPoints;
    procedure CMWantSpecialKey(var Message: TMessage); message CM_WANTSPECIALKEY;
    procedure CMMouseEnter(var Message: TMessage) ; message CM_MOUSEENTER; // added by J.F. June 2011
    procedure CMMouseLeave(var Message: TMessage) ; message CM_MOUSELEAVE; //  added by J.F. June 2011
    procedure DoEditMenuClick(Sender: TObject);
    procedure DoHotzoneScrolling;
    procedure DoMousePanning; // added by J.F. June 2011
    procedure DoShapeEditClosed(AShape: TdtpShape);
    procedure DoShapeInsertClosed(AShape: TdtpShape);
    procedure DoShapeListChanged;
    function GetCurrentPage: TdtpPage;
    function GetDragCursor(AShape: TdtpShape; AHitInfo: THitTestInfo): TCursor;
    function GetScreenRect(BaseDoc: TdtpPoint; SizeDoc: TdtpPoint): TRect;
    function GetFocusedShape: TdtpShape;
    function GetPages(Index: integer): TdtpPage;
    function GetPageCount: integer;
    function GetPageHeight: single;
    function GetPageWidth: single;
    function GetPrinterDpm: single;
    function GetScreenDPI: single;
    function GetSelection(Index: integer): TdtpShape;
    function GetSelectionCount: integer;
    function GetShapeCount: integer;
    function GetShapes(Index: integer): TdtpShape;
    function GetUndoCount: integer;
    function GetUndoEnabled: boolean;
    function GetUndos(Index: integer): TdtpCommand;
    function GetVertScrollBarVisible(): Boolean;
    function GetHorizScrollBarVisible(): Boolean;
    procedure PaintDragBorders(ADelta: TdtpPoint);
    procedure PaintInsertBorder(ADelta: TdtpPoint);
    procedure PaintSelectBorder(ADelta: TdtpPoint);
    procedure PaintMouseDragZoomBorder(NewFinalPos: TPoint); //  added by J.F. June 2011
    procedure PaintHandles(Canvas: TCanvas);
    procedure SaveHeader;
    procedure SetAutoPageUpdate(const Value: boolean);
    function SetClientRectCursor(ACursor: TCursor): boolean;  // added by J.F. June 2011
    procedure SetCurrentPage(const Value: TdtpPage);
    procedure SetCurrentPageIndex(const Value: integer);
    procedure SetDefaultGridColor(const Value: TColor);
    procedure SetDefaultGridSize(const Value: single);
    procedure SetDefaultMarginBottom(const Value: single);
    procedure SetDefaultMarginLeft(const Value: single);
    procedure SetDefaultMarginRight(const Value: single);
    procedure SetDefaultMarginTop(const Value: single);
    procedure SetDefaultPageColor(const Value: TColor);
    procedure SetDefaultPageHeight(const Value: single);
    procedure SetDefaultPageWidth(const Value: single);
    procedure SetFocusedShape(const Value: TdtpShape);
    procedure SetGuideColor(const Value: TColor); //  Added by J.F. Feb 2011
    procedure SetGuidesToFront(const Value: boolean); //  Added by J.F. Feb 2011
    procedure SetGuidesVisible(const Value: boolean); //  Added by J.F. Feb 2011
    procedure SetHelperMethod(const Value: TdtpHelperMethodType);
    procedure SetHotZoneScrolling(const Value: TdtpHZScrollingType);
    procedure SetModified(const Value: boolean);
    procedure SetPageCount(const Value: integer);
    procedure SetPageHeight(const Value: single);
    procedure SetPageWidth(const Value: single);

    procedure SetPageShadowColor(const Value: TdtpColor); // Added by J.F. Feb 2011

    procedure SetPaintEditBorder(const Value: boolean);
    procedure SetReadOnly(const Value: boolean);
    procedure SetScreenDpm(const Value: single);
    procedure SetScreenDPI(const Value: single);
    procedure SetShowMargins(const Value: boolean);

    procedure SetShowPageShadow(const Value: boolean); // added by J.F.  Feb 2011

    procedure SetState(const Value: TdtpViewerStateType);
    procedure SetUndoEnabled(const Value: boolean);
    procedure SetUseClipboard(const Value: boolean);

    procedure SetUseDocumentBoard(const Value: boolean);  // added by J.F.  Feb 2011

    procedure SetScrollWithMouseWheel(const Value: boolean); // added by J.F. Juen 2011
    procedure SetZoomWithMouseWheel(const Value: boolean); // added by J.F. June 2011

    procedure SetMouseWheelScrollSpeed(const Value: integer); // added by J.F. June 2011

    procedure SetViewStyle(const Value: TdtpViewStyleType);

    procedure SetViewerFunction(const Value: TdtpViewerFunctionType);  //  added by J.F. July 2011

    procedure SetWindowLeft(const Value: single);
    procedure SetWindowTop(const Value: single);
    procedure SetQuality(const Value: TdtpStretchFilter);
    procedure TimerAnimate(Sender: TObject);

    procedure TimerHotzoneScrolling(Sender: TObject);
    procedure TimerPageUpdate(Sender: TObject);
    procedure UpdateAllPageThumbnails;
    procedure UpdateDefaultPageThumbnails;
    procedure UpdateRulers;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClick(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMButtonDown(var Message: TWMRButtonDown); message WM_MBUTTONDOWN;
    procedure WMMButtonUp(var Message: TWMRButtonUp); message WM_MBUTTONUP;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMMouseWheel(var Message : TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMDeleteShape(var Msg: TMessage); message WM_DELETE_SHAPE;
    procedure SetThumbnailHeight(const Value: integer);
    procedure SetThumbnailWidth(const Value: integer);
    function GetIsPrinting: boolean;
    procedure SetDefaultBackgroundTiled(const Value: boolean);
    procedure SetHitSensitivity(const Value: single);
    function GetSmartHitPointCount: integer;
    function GetSmartHitPoints(Index: integer): TPoint;
    procedure SetZoomPercent(const Value: single);
    procedure SetZoomStep(const Value: single);
    procedure SetMode(const Value: TdtpViewerModeType);
    function GetRedoCount: integer;
    function GetRedos(Index: integer): TdtpCommand;
    procedure DefaultBackgroundImageObjectChanged(Sender: TObject);
    procedure SetRulerCorner(const Value: TdtpRsRulerCorner);
    procedure SetRulerLeft(const Value: TdtpRsRuler);
    procedure SetRulerTop(const Value: TdtpRsRuler);
    procedure SetRulerUnits(const Value: TRulerUnit);
    function GetVersion: string;
  protected

    procedure AdjustSizeToPage(Sender: TObject); virtual;
    function  AdjustToGrid(APoint: TdtpPoint; Adjust: boolean): TdtpPoint;
    function AdjustToGuides(APoint: TdtpPoint; Adjust: boolean; var Adjusted: boolean): TdtpPoint; //  changed by J.F. July 2011

    procedure DefaultLocateFilename(var AName: string);
    procedure DocumentChanged;
    procedure DoDragStart(ADelta: TdtpPoint);
    procedure DoEditStart(AShape: TdtpShape);
    procedure DoFocusShape(AShape: TdtpShape);
    procedure DoInsertClose(Accept: boolean);
    procedure DoInsertShape(AShape: TdtpShape; AInsertMode: TdtpInsertModeType);
    procedure DoPageChanged(APage: TdtpPage);
    procedure DoPaintBackground(Canvas: TCanvas; const Device: TDeviceContext; const PageRect: TRect);
    procedure DoPaintForeground(Canvas: TCanvas; const Device: TDeviceContext;  const PageRect: TRect);
    procedure DoSelectionChanged;
    procedure DoSelectClose(Accept: boolean);
    procedure DoShapeChanged(AShape: TdtpShape);
    procedure DoShapeDestroy(AShape: TdtpShape);
    procedure DoShapeLoadAdditionalInfo(Shape: TdtpShape; Node: TXmlNodeOld);
    procedure DoShapeNudge(const Key: word);  //  added by J.F. June 2011
    procedure DoShapeSaveAdditionalInfo(Shape: TdtpShape; Node: TXmlNodeOld);
    procedure DoZoomInByMouse; // added by J.F. June 2011
    procedure DoZoomOutByMouse; // added by J.F. June 2011
    function FormatHint(Value: single): string;  //  added by J.F. June 2011
    procedure ForceUpgradeFromPreviousVersion;
    function GetDraggedShapePosDoc(APoint: TdtpPoint): TdtpPoint;  //  added by J.F. July 2011
    procedure GetMouseState(Message: TWMMouse; var Left, Middle, Right, Shift, Ctrl, Alt: boolean; var X, Y: integer); virtual;
    function GetNewSessionRef: integer;
    function GetPopupMenu: TPopupMenu; override;
    function IsWorking: boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure LoadFromArchive; virtual;
    procedure LoadFromXml(ANode: TXmlNodeOld); virtual;
    procedure LoadPageFromXml(APageIndex: integer);
    procedure NextUndoNoRepeatedPropertyChange;
    procedure Paint; override;
    procedure PaintCurrentPage(Canvas: TCanvas); virtual;
    function RoundDecimal(Value: Extended; Precision: Integer): Extended; //  added by J.F. June 2011
    procedure RulerOnEvent(Sender: TObject; var AMessage: TMessage); // added by J.F. June 2011
    procedure SaveChanges; virtual;
    procedure SaveToXml(ANode: TXmlNodeOld); virtual;
    function SelectionFromText(const AText: string): integer; virtual;
    function SelectionToText: string; virtual;
    procedure SetDefaults; virtual;
    procedure SetParent(AParent: TWinControl); override;

    procedure UpdateScrollPosition; override;
    procedure ZoomByFactor(AFactor: single; ByMouse: boolean = false);
    procedure ZoomByRect(Rect: TRect);  //  added by J.F. June 2011
    procedure MouseZoomByFactor(AFactor: single);  //  added by J.F. June 2011
    procedure ZoomToWidth;
    property HitInfo: THitTestInfo read FHitInfo write FHitInfo;
    property ProgressCount: integer read FProgressCount;
    property ProgressTotal: integer read FProgressTotal;
    property RedoEnabled: boolean read FRedoEnabled write FRedoEnabled default False;
    property Redos[Index: integer]: TdtpCommand read GetRedos;
    property Undos[Index: integer]: TdtpCommand read GetUndos;
    property SmartHitPointCount: integer read GetSmartHitPointCount;
    property SmartHitPoints[Index: integer]: TPoint read GetSmartHitPoints;
  public
    // Call Create to create a new instance of a TdtpDocument. If you use the component
    // you do not have to call this function, you can just drop the component on the
    // form. After creation, the Parent property must be set to embed the TdtpDocument
    // component into a parent form or panel.
    constructor Create(AOwner: TComponent); override;
    // Destroy will free up all objects that were created inside the TdtpDocument. Never
    // call Destroy directly, always use Free instead. You do not have to call Free if you
    // did not create the document explicitly.
    destructor Destroy; override;
    // Call AcceptFileDrop with a file named AFileName and the mouse position in
    // screen coordinates in MousePos, to either add a bitmap to the current page
    // at the mouse location, or replace a bitmap in a TdtpBitmapShape if there
    // is such a shape in that location.
    procedure AcceptFileDrop(const AFileName: string; MousePos: TPoint);
    // Add shape AShape to the current selection. If it is already in the selection
    // it will be removed again.
    procedure AddToSelection(AShape: TdtpShape);
    // Align all left edges of shapes in the selection to the leftmost one.
    procedure AlignLeft;
    // Align all center positions of shapes in the selection to the center position
    // of them all
    procedure AlignCenter;
    // Align all right edges of shapes in the selection to the rightmost one.
    procedure AlignRight;
    // Align all top edges of shapes in the selection to the topmost one.
    procedure AlignTop;
    // Align all midpositions of shapes in the selection to the midpoint of them
    // all, vertically.
    procedure AlignMiddle;
    // Align all bottom edges of shapes in the selection to the bottommost one.
    procedure AlignBottom;
    // Align shapes to Vertical Center of Page
    // If only one shape selected it will Align to Vertical Center of page
    // If more than one shape the total of all shapes will Align Vertically
    // without crashing into the center
    procedure AlignVerticalPageCenter;  // added by J.F. Apr 2011
    // Align shapes to Horizontal Center of Page
    procedure AlignHorizontalPageCenter; // added by J.F. Apr 2011
    // Call BeginPrinting and EndPrinting before and after a section of source
    // code where you want to avoid screenpainting. Whenever the document is
    // in "printing" state, no attempt will be made to update the screen, not even
    // if "invalidate" is called. Use cautiously! Make sure to match the BeginPrinting
    // and EndPrinting calls, using a Try..Finally construct.
    procedure BeginPrinting;
    // Call BeginUndo and EndUndo before and after a section of source in which
    // all adaptions to the document should be treated as one undo command. Make
    // sure to match the BeginUndo and EndUndo calls, using a Try..Finally construct.
    procedure BeginUndo;
    // Call BeginUpdate and EndUpdate before and after a batch of operations on
    // the document in order to prevent calling OnShapeChanged, OnFocusShape and
    // OnSelectionChanged for each shape change. After the last matching EndUpdate
    // call, these events will only be fired once. Make sure to match BeginUpdate
    // and EndUpdate calls, using a Try..Finally construct.
    procedure BeginUpdate; virtual;
    // Call BeginWorking and EndWorking with a specific cursor shape to indicate
    // that the document component is working on something. Use this when doing
    // lengthy operations. After the last matching EndWorking call, the cursor
    // will be set back to the default TdtpDocument.Cursor.
    procedure BeginWorking(ACursor: TCursor = crDefault);
    // Call Clear to remove all pages, clean the undo list, remove any open archive
    // and DO NOT restore the defaults. The document does not have a default page.
    // If you also want to create a default page, call New instead.
    procedure ClearDoc; virtual; // added by EL
    // Call Clear to remove all pages, clean the undo list, remove any open archive
    // and restore the defaults. The document will be back in the same state as
    // after Create, except that it does not have a default page. If you also want
    // to create a default page, call New instead.
    procedure Clear; virtual;
    // Call ClearSelection to unselect all shapes in the current page.
    procedure ClearSelection;
    // Call Copy to copy the selected shapes to the clipboard. If InternalClipboard is
    // true, an internal clipboard in the document is used, otherwise the Windows
    // clipboard is used. The shape selection is added to the clipboard in CFTEXT
    // format, as XML. When AllowKeyInput is true, the keystroke Ctrl-C will cause
    // Copy to be called.
    procedure Copy; virtual;
    // This procedure is called by shapes whenever they require a handle painter.
    // Override OnCreateHandlePainter to provide non-default handle painters
    procedure CreateHandlePainter(Shape: TdtpShape; var AHandlePainter: TdtpHandlePainter); virtual;
    // Call Cut to cut the selected shapes to the clipboard. If InternalClipboard is
    // true, an internal clipboard in the document is used, otherwise the Windows
    // clipboard is used. The shape selection is added to the clipboard in CFTEXT
    // format, as XML. The shapes are then removed from the document. When
    // AllowKeyInput is true, the keystroke Ctrl-X will cause Cut to be called.
    procedure Cut; virtual;
       // Delete All Guides From Document
       // Developer should warn users
    procedure DeleteAllDocumentGuides; //  added by J.F. July 2011
    // Delete all selected shapes from the current page.
    procedure DeleteSelectedShapes;
    // Call DisableUndo and EnableUndo before and after a section of code where
    // there should be no registration of undo commands. Make sure to match the
    // DisableUndo and EnableUndo calls, using a Try..Finally construct.
    procedure DisableUndo;
        //  Convert from Doc Value to Ruler Unit Value - Used for User Interface
        // Presicion 3 decimals
    function DocToRuler(const Value:single): single; overload;  // added by J.F. June 2011
        //  Convert from Doc dtpPoint to Ruler Unit dtpPoint - Used for User Interface
        // Presicion 3 decimals
    function DocToRuler(const Value: TdtpPoint): TdtpPoint; overload; // added by J.F. June 2011
    // Convert the point coordinate APoint from document coordinates to screen
    // coordinates. The screen coordinates should be rounded to get the pixel
    // position.
    function DocToScreen(APoint: TdtpPoint): TdtpPoint;
    // Call DoDragClose to force the document to terminate its dragging operation.
    // Set Accept to False to cancel the document's internal drag operation, or
    // to True to accept the drag.
    procedure DoDragClose(Accept: boolean);
    // Call DoEditClose to terminate the editing state. With Accept = True, the
    // updates will be accepted by the shape, with Accept = False, the updates are
    // rejected and the original shape is restored.
    procedure DoEditClose(Accept: boolean);
    // DoProgress can be used to provide progress information during lengthy operations
    // through the default event OnProgress.
    procedure DoProgress(AType: TdtpProgressType; ACount, ATotal: integer; APercent: single);
    // Call this function to draw a quality indicator at the Rect position on the canvas
    // based on the Quality percentage. By default this procedure does nothing, it
    // will see if there's an event OnDrawQualityIndicator, and call it.
    procedure DrawQualityIndicator(Sender: TObject; Canvas: TCanvas; var Rect: TRect; Quality: integer; var Drawn: boolean);
    // Call DisableUndo and EnableUndo before and after a section of code where
    // there should be no registration of undo commands.
    procedure EnableUndo;
    // Call BeginPrinting and EndPrinting before and after a section of source
    // code where you want to avoid screenpainting.
    procedure EndPrinting;
    // Call BeginUndo and EndUndo before and after a section of source in which
    // all adaptions to the document should be treated as one undo command.
    procedure EndUndo;
    // Call BeginUpdate and EndUpdate before and after a batch of operations on
    // the document.
    procedure EndUpdate; virtual;
    // Call BeginWorking and EndWorking with a specific cursor shape to indicate
    // that the document component is working on something.
    procedure EndWorking;
    // Get the hittest info at the position APos. AHitInfo returns the kind of
    // hit detected, and AShape returns the shape under the cursor. APos is in
    // screen-coordinates
    procedure GetHitTestInfoAt(APos: TPoint; var AHitInfo: THitTestInfo; var AShape: TdtpShape);
    // Get the hittest info at position APos. This method differs slightly from
    // GetHitTestInfoAt in some situations. For instance, it returns shapes inside
    // groups instead of the group because doubleclicks can put these inner shapes in
    // edit mode.
    procedure GetHitTestInfoDblClickAt(APos: TPoint; var AHitInfo: THitTestInfo; var AShape: TdtpShape);
    // Group the selected shapes into one TdtpGroupShape. The resulting group is
    // treated as one shape until the shape is ungrouped again. Call Ungroup with
    // a selected TdtpGroupShape to ungroup it.
    procedure Group;
    // HasClipboardData will determine if either the internal clipboard or the
    // external Windows clipboard has suitable clipboard data available. Use it
    // e.g. to determine the "enabled" state of menu items.
    function HasClipboardData: boolean; virtual;
    // HasSelection returns True if one or more shapes on the current page are
    // selected.
    function HasSelection: boolean; virtual;
    // Call InsertShapeByClick with a created shape descendant AShape, to allow
    // the user to insert the shape at the preferred location with a mouse click.
    // If the user decides not to insert, e.g. [Esc]-key, the shape will be freed
    // by the document. When the shape is actually inserted, an OnShapeInsertClosed
    // event will fire.
    procedure InsertShapeByClick(AShape: TdtpShape);
    // Call InsertShapeByDrag with a created shape descendant AShape, to allow
    // the user to insert the shape in the preferred rectangle by creating a
    // dragged marquee with the mouse.
    // If the user decides not to insert, e.g. [Esc]-key, the shape will be freed
    // by the document. When the shape is actually inserted, an OnShapeInsertClosed
    // event will fire.
    procedure InsertShapeByDrag(AShape: TdtpShape);
    // Call InvalideShape to force a redraw of AShape within the page. Only the
    // rectangle of this shape will be redrawn, no other parts of the screen.
    procedure InvalidateShape(AShape: TdtpShape);
    // Invalidate (redraw) just a part of the shape AShape, the part that is within
    // ARect (ARect is in shape coordinates).
    procedure InvalidateShapeRect(AShape: TdtpShape; ARect: TdtpRect);
    // Load a document with name AFileName. This must be a valid *.hsf document.
    // Only the first page of the document will be actually loaded, the rest will
    // be loaded when the particular page is shown (see CurrentPage property).
    procedure LoadFromFile(const AFileName: string); virtual;
    // Load a document from the stream S. If ArchiveDirect is True, the stream must
    // remain opened so that the document can load additional pages at will and the
    // calling application can only free the stream after clearing or freeing
    // the document. With ArchiveDirect = False, the document will create its own
    // in-memory copy to work with.
    procedure LoadFromStream(S: TStream); virtual;
    // Locate the file with AName if it isn't any long in that position. Default
    // is to ask the user to find it, but the application can implement event
    // OnLocateFilename to override this behaviour.
    procedure LocateFilename(Sender: TObject; var AName: string);

    // Move the selected shape(s) back once in Z-order. To move a shape completely
    // to the background, call MoveToBackground instead.
    procedure MoveBack;
    // Move the selected shape(s) forward once in Z-order. To move a shape completely
    // to the foreground, call MoveToForeground instead.
    procedure MoveFront;
    // Move the selected shape(s) to the background. They will appear behind all
    // other shapes on the page.
    procedure MoveToBackground;
    // Move the selected shape(s) to the foreground. They will appear in front of all
    // other shapes on the page.
    procedure MoveToForeground;
    // Call New to start a new document. First the document will be completely
    // cleared and then a new default page will be added. If you do not want the
    // default page, then call Clear instead.
    procedure New;
    // Add the page APage as last in the list of pages. It must be created previously.
    // Call PageAdd with nil argument to add a default page:
    // <code>
    // MyDocument.PageAdd(nil); // create default page
    // </code>
    // The return value is the index of the added page.
    function PageAdd(APage: TdtpPage): integer;
    // Copy the page in OldIndex to the new index NewIndex. All elements on the page
    // (shapes, background, etc) are copied to the new page.
    procedure PageCopy(OldIndex, NewIndex: integer);
    // Delete the page at Index. To delete the current page, use
    // <code>
    // PageDelete(CurrentPageIndex);
    // </code>
    procedure PageDelete(Index: integer);
    // Extract the page ad Index from the document. After extraction, the document
    // will no longer own the page, so the application is responsible for freeing it.
    function PageExtract(Index: integer): TdtpPage;
    // Call PageIndexOf to find the index of the page APage in the pagelist. If APage
    // is not found, -1 is returned.
    function PageIndexOf(APage: TdtpShape): integer;
    // Move the page at OldIndex to the new position NewIndex.
    procedure PageMove(OldIndex, NewIndex: integer);
    // Insert a page at position Index. Use Index = 0 to insert a page before the
    // first page, use Index = PageCount to insert a page after the last page (In
    // that case you could also use PageAdd).
    procedure PageInsert(Index: integer; APage: TdtpPage);
    // Call Paste to paste the selected shapes from the clipboard. If InternalClipboard is
    // true, an internal clipboard in the document is used, otherwise the Windows
    // clipboard is used. The procedure expects the shape selection to be present in
    // clipboard CFTEXT format, as XML. When AllowKeyInput is true, the keystroke
    // Ctrl-V will cause Paste to be called.
    procedure Paste; virtual;
    // PerformCommand is used internally and by scripting applications to instruct
    // the document to perform the command in ACommand. Internally this is used
    // for Undo and Redo.
    function PerformCommand(ACommand: TdtpCommand): boolean; virtual;
    // Print the complete document to the currently selected printer.
    procedure Print; overload;
    // Print the page with index APage to the currently selected printer.
    procedure Print(APage: integer); overload;
    // Print the range of pages starting at AStart and with a total of ACount
    // to the currently selected printer.
    procedure Print(AStart, ACount: integer); overload;
    // Print a selection of pages to the currently selected printer. ASelection
    // can be a dynamic or standard array of integer, ACount must be the total
    // number of pages in the selection. The integers represent the page indices.
    procedure PrintSelection(const ASelection: array of integer; ACount: integer); overload; virtual;
    // Redo a previously undone command. See Also: Undo.
    procedure Redo;
    // RedoAdd is used internally to add a command to the redo list, whenever Undo
    // is used.
    procedure RedoAdd(ACmd: TdtpCommand);
     // Convert from Ruler Unit to Doc Value - Used for User Interface
     // 3 Decimal precision
    function RulerToDoc(const Value:single): single;overload;  // added by J.F. June 2011
    // Convert from Ruler Unit to Doc Value - Used for User Interface
     // 3 Decimal precision
    function RulerToDoc(const Value:TdtpPoint): TdtpPoint;overload;  // added by J.F. June 2011
    // SaveToFile will save the document to the file AFilename. If this same file was
    // already opened with LoadFromFile, just the changes will be saved.
    procedure SaveToFile(const AFilename: string); virtual;
    procedure SaveToStream(S: TStream); virtual;
    // Convert the point coordinate APoint from screen coordinates to document
    // coordinates. The document coordinates will get float precision.
    function ScreenToDoc(APoint: TPoint): TdtpPoint;
    // Call SetWindowsCursor to temporarily set the cursor of the document to ACursor.
    // The cursor will only be changed if there is no other ongoing operation already.
    // Always set the cursor back to its default with SetWindowsCursor(Cursor) after
    // the operation finished.
    procedure SetWindowsCursor(ACursor: TCursor);
    // Add a shape to the current page. The function returns the shapes index in the Shapes
    // list, or -1 if not successful. In order to let the user insert shapes, see
    // InsertShapeByClick and InsertShapeByDrag.
    function ShapeAdd(AShape: TdtpShape): integer;
    // Delete the shape with index AIndex from the current page.
    procedure ShapeDelete(AIndex: integer);
    // Exchange shapes i and j in the Shapes list.
    procedure ShapeExchange(i, j: integer);
    // Extract a shape from the list. The return value is a pointer to the extracted shape
    // or nil if AShape was not found.
    function ShapeExtract(AShape: TdtpShape): TdtpShape;
    // Insert a shape in the current page, at position Index programmatically. In order
    // to let the user insert shapes, see InsertShapeByClick and InsertShapeByDrag.
    procedure ShapeInsert(Index: Integer; AShape: TdtpShape);
    // Remove a shape permanently from the list and free it. Return value is the index
    // of the removed shape or -1 if AShape was not found.
    function ShapeRemove(AShape: TdtpShape): integer;
    // Call Undo to undo the last change. See also UndoCount, UndoPastSave,
    // UndoEnabled, Redo and constant cMaxUndoSize.
    procedure Undo;
    // Clear the list of Undo commands. Nothing can be undone after a call to this
    // method.
    procedure UndoClear; virtual;
    // UndoAdd is used internally to add changes to the undo list. It can be used by
    // scripting applications to add commands to the undo list programmatically.
    procedure UndoAdd(ACmd: TdtpCommand);
    // Call Ungroup with a selected TdtpGroupShape to ungroup it.
    procedure Ungroup;
    // Call ZoomIn to zoom into the document around the current center of the document's
    // window. Zoom step is 10% by default.
    procedure ZoomIn;
    // Call ZoomOut to zoom out from the document around the current center of the document's
    // window. Zoom step is 10% by default.
    procedure ZoomOut;
    // Zoom the document so that the complete page is just visible within the window.
    // This may look different according to the setting for ViewStyle.
    procedure ZoomPage;
    // Zoom the document so that the width of the page just fits the width of the
    // window. This may look different according to the setting for ViewStyle.
    procedure ZoomWidth;
    // Archive is a pointer to the currently opened "single storage" archive that
    // contains the document pages. Since resources are also stored in the archive,
    // and the resource maintenance thread may save them at any moment by creating
    // a new temporary archive, all access to the archive must be braced by calls
    // to glResourceLockEnter / glResourceLockLeave.
    property Archive: TsdStorage read FArchive write FArchive;
    // DefaultBackgroundImage returns a pointer to the currently defined default background image resource.
    // You can load an image as background image with DefaultBackgroundImage.LoadFromFile().
    property DefaultBackgroundImage: TdtpBitmapResource read FDefaultBackgroundImage;
    // CurrentPage is a pointer to the currently displayed page in the document. If
    // no page is displayed or present, CurrentPage will be nil.
    property CurrentPage: TdtpPage read GetCurrentPage write SetCurrentPage;
    // DraggedShape returns a pointer to the shape that is currently dragged by the user, or nil
    // if no shape is dragged.
    property DraggedShape: TdtpShape read FDraggedShape write FDraggedShape;
    // EditedShape returns a pointer to the shape that is currently edited by the user, or nil
    // if no shape is edited.
    property EditedShape: TdtpShape read FEditedShape write FEditedShape;
    // FocusedShape returns a pointer to the shape that is currently in focus (last selected)
    // by the user, or nil if no shape is focused.
    property FocusedShape: TdtpShape read GetFocusedShape write SetFocusedShape;
    // FontManager is responsible for managing TrueType fonts used by the document
    property FontManager: TdtpFontManager read FFontManager;
    // Pages is a list of pointers to individual pages in the document. Valid indices
    // range from 0 to PageCount - 1.
    property Pages[Index: integer]: TdtpPage read GetPages;

    // Set PageShadow and Border to say clLightGray32 for example, other than clBlack32
    property PageShadowColor: TdtpColor read FPageShadowColor write SetPageShadowColor; // added by J.F. Feb 2011

    // ScreenDpm returns the scale of the document as shown on the screen, in dots per mm.
    // If ScreenDpm = 2, this means that each mm of document is represented by 2 pixels
    // on the screen. The document is actually printed at a different (usually higher)
    // resolution.
    property ScreenDpm: single read FScreenDpm write SetScreenDpm;
    // Selection is a list of pointers to selected shapes on the current page. Valid indices range
    // from 0 to SelectionCount - 1.
    property Selection[Index: integer]: TdtpShape read GetSelection;
    // SelectionCount returns the number of selected shapes on the current page.
    property SelectionCount: integer read GetSelectionCount;
    // ShapeCount returns the number of shapes on the current page.
    property ShapeCount: integer read GetShapeCount;
    // Shapes is a list of pointers to shapes on the current page.
    property Shapes[Index: integer]: TdtpShape read GetShapes;
    // State represents the internal state of the document. This can be any of vsNone,
    // vsDrag, (user is dragging),  vsSelect, (when user clicks, it selects a shape),
    // vsBeforeInsert, (before user clicks/drags to insert), vsInsert (when user
    // click/drags, a shape is inserted at that location) or  vsEdit (all mouse and
    // keyboard events go to the focused control)
    property State: TdtpViewerStateType read FState write SetState;

    // J.F. Feb 2011 - I needed this as I move forward with version updates
    //  other developers may find this useful also
    property DocumentCreatedWithVersion: Utf8String read FDocumentCreatedWithVersion;  // added by J.F. Feb 2011
    property DocumentModifiedWithVersion: Utf8String read FDocumentModifiedWithVersion;  // added by J.F. Feb 2011

    property VertScrollBarVisible: boolean read GetVertScrollBarVisible;
    property HorizScrollBarVisible: boolean read GetHorizScrollBarVisible;

      // The following 4 ViewerFunctionTypes allow the developer
               // to enable these features via a Toolbar button for examples
               // ala Pagemaker
               // These functions override the following properties:
               // ZoomWithMouseButton, ZoomWithRectangle, PanWithMouse
               // so developer can disable them and use User Interface instead

     // vfDirectPanning = Enable Panning of Page
     // vfDirectMouseDragZoom = Enable DragZoom
      // vfDirectMouseButtonZoom =  Enable Button Zoom (with Magnifier Cursor)
     //  vfDirectMouseZoomInOut = Enable Zoom (with ZoomIn or ZoomOut Cursor)  Ala PageMaker
                                  //  Left Button Click = ZoomIn;  Ctrl + Left Button Click = ZoomOut

    property ViewerFunction: TdtpViewerFunctionType read FViewerFunction write SetViewerFunction; // added by J.F. July 2011

  published
    // If AllowKeyInput = True (default), the document processes keystrokes. Certain
    // keys are handled by default (cut, copy, paste key combinations).
    property AllowKeyInput: boolean read FAllowKeyInput write FAllowKeyInput default True;
    // If ArchiveDirect = False (default), changes to the pages are only saved after
    // a call to SaveToFile. With ArchiveDirect = True, changes are directly saved.
    // This mode is also faster, but it requires a temporary copy of the archive,
    // since changes to the file cannot be undone.
    property ArchiveDirect: boolean read FArchiveDirect write FArchiveDirect default False;
    // If True, the thumbnails of the pages will automatically update with any change
    // to a page or shape on a page. A grace period avoids excessive updating, see
    // PageUpdateInterval.
    property AutoPageUpdate: boolean read FAutoPageUpdate write SetAutoPageUpdate default False;
    // When AutoWidth = True (default), the document is always kept to screenwidth
    // when resizing it, whenever ZoomPercent = 100.
    property AutoWidth: boolean read FAutoWidth write FAutoWidth default True;
    // When AutoDeleteTextShape = True (default), e.g. empty TextShapes are auto delete
    // when the Length(Text) = 0 to get rid of clutter (Added by JF)
    property AutoDeleteShape: boolean read FAutoDeleteShape write FAutoDeleteShape default True;
     // When true (default), on mouse enter, document is set to focused
     //  Need to process Ctrl, Alt etc for some special functions
    property AutoFocus: boolean read FAutoFocus write FAutoFocus default true;  // added by J.F. June 2011
    // Color defines the background color behind the pages of the document.
    property Color;
    // CurrentPageIndex is the index of the currently displayed page in the document. If
    // no page is displayed or present, CurrentPageIndex will be -1. A pointer to
    // the current page can be obtained with Pages[CurrentPageIndex] or CurrentPage.
    property CurrentPageIndex: integer read FCurrentPageIndex write SetCurrentPageIndex;
    // If True, the DefaultBackgroundImage (if any) will be tiled (repeated) in order to create a
    // continuous texture for all default pages. If False (default), the background image
    // will be stretched to fill the page completely.
    property DefaultBackgroundTiled: boolean read FDefaultBackgroundTiled write SetDefaultBackgroundTiled default False;
    // DefaultGridColor is the default color of the grid. Set HelperMethod to hmGrid to show
    // a grid. Each page can override the DefaultGridColor in TdtpPage.GridColor.
    property DefaultGridColor: TColor read FDefaultGridColor write SetDefaultGridColor default cDefaultGridColor;
    // DefaultGridSize is the default size of the grid in [mm]. Set HelperMethod to hmGrid to show
    // a grid. Each page can override the DefaultGridSize in TdtpPage.GridSize.
    property DefaultGridSize: single read FDefaultGridSize write SetDefaultGridSize;
    // DefaultMarginBottom is the default size of the margin at the bottom of the page.
    // Set ShowMargins to True (default) to show the margins as stippled lines. Each
    // page can override the margin settings.
    property DefaultMarginBottom: single read FDefaultMarginBottom write SetDefaultMarginBottom;
    // DefaultMarginLeft is the default size of the margin at the left side of the page.
    // Set ShowMargins to True (default) to show the margins as stippled lines. Each
    // page can override the margin settings.
    property DefaultMarginLeft: single read FDefaultMarginLeft write SetDefaultMarginLeft;
    // DefaultMarginRight is the default size of the margin at the right side of the page.
    // Set ShowMargins to True (default) to show the margins as stippled lines. Each
    // page can override the margin settings.
    property DefaultMarginRight: single read FDefaultMarginRight write SetDefaultMarginRight;
    // DefaultMarginTop is the default size of the margin at the top of the page.
    // Set ShowMargins to True (default) to show the margins as stippled lines. Each
    // page can override the margin settings.
    property DefaultMarginTop: single read FDefaultMarginTop write SetDefaultMarginTop;
    // DefaultPageColor is the color of all default pages. Each page can override
    // this setting with TdtpPage.PageColor.
    property DefaultPageColor: TColor read FDefaultPageColor write SetDefaultPageColor default cDefaultPageColor;
    // DefaultPageHeight is the height in [mm] of all default pages. Each page can override
    // this setting with TdtpPage.PageHeight.
    property DefaultPageHeight: single read FDefaultPageHeight write SetDefaultPageHeight;
    // DefaultPageWidth is the width in [mm] of all default pages. Each page can override
    // this setting with TdtpPage.PageWidth.
    property DefaultPageWidth: single read FDefaultPageWidth write SetDefaultPageWidth;
    // Read Device to learn to which device the document currently renders. Internally,
    // the document sets Device to dtPrinter whenever sending output to a printer. This
    // will ensure that helpers and margins are not painted.
    property Device: TDeviceType read FDevice write FDevice;
    // PageCount returns the number of pages in the document. A default document only has
    // one page. You can add pages with PageAdd.
    property PageCount: integer read GetPageCount write SetPageCount;
    // PageHeight is the height in [mm] of the current page. Set PageHeight to override the
    // default page height of the current page. Set DefaultPageHeight to set the page height for
    // all default pages.
    property PageHeight: single read GetPageHeight write SetPageHeight;
    // PageWidth is the width in [mm] of the current page. Set PageWidth to override the
    // default page width of the current page. Set DefaultPageWidth to set the page width for
    // all default pages.
    property PageWidth: single read GetPageWidth write SetPageWidth;
    // When AutoPageUpdate is true, PageUpdateInterval defines how long it takes in [msec]
    // after any change by the user before the document will update the page thumbnail.
    property PageUpdateInterval: integer read FPageUpdateInterval write FPageUpdateInterval default cDefaultPageUpdateInterval;
    // Printer resolution in Dots Per Millimeter that will be used when printing (read-only).
    // Use PrintQuality to set the printer resolution.
    property PrinterDpm: single read GetPrinterDpm;
    // Set PrintQuality to any of the available quality settings:
    // * pqLow:     Low print quality, defaults to 150 DPI
    // * pqMedium:  Medium print quality, defaults to 300 DPI
    // * pqHigh:    High print quality, defaults to 600 DPI
    // * pqDevice:  Use device's maximum DPI. WARNING this can cause long print times
    property PrintQuality: TPrintQualityType read FPrintQuality write FPrintQuality default pqLow;
    // If True, the document uses FontEmbedding, it stores fonts used in the document
    // with the document so exotic fonts not existing on another computer can still
    // be shown. Default is False. Note that font embedding only works for text shapes
    // based on polygons (i.e. TdtpPolygonText and TdtpPolygonMemo and descendants).
    property FontEmbedding: boolean read FFontEmbedding write FFontEmbedding default false;
    // Set Helper Guides Color, default clRed
    property GuideColor: TColor read FGuideColor write SetGuideColor; // added by J.F. Feb 2011
    // If False (default), Helper Guides will be shown behind all Shapes, else in front of all Shapes
    property GuidesToFront: boolean read FGuidesToFront write SetGuidesToFront default false; // added by J.F. Feb 2011

    // If True (default) Show Horiz or Vert position of Guide under Mouse Pointer
    property ShowGuideHints: boolean read FShowGuideHints write FShowGuideHints default true; //  changed by J.F. July 2011
    // number of decimal places of Guide Hint Position value
    //property GuideHintsPrecision: TdtpGuideHintsPrecision read FGuideHintsPrecision write FGuideHintsPrecision default ghp2Decimals; // added by J.F. June 2011
    // If GuidesVisible is True (default), Helper Guides will be shown on the pages
    property GuidesVisible: boolean read FGuidesVisible write SetGuidesVisible default true; //  added by J.F. Feb 2011
    // If GuidesLocked (default false), user can not move guides
    property GuidesLocked: boolean read FGuidesLocked write FGuidesLocked default false; // added by J.F. June 2011
    // HandleEdgeColor defines the color used to paint the stippled marquee around the handles
    // when the shape is selected or dragged.
    property HandleEdgeColor: TColor read FHandleEdgeColor write FHandleEdgeColor default cDefaultHandleEdgeColor;
    // HandleColor defines the color of the square and round drag handles when the
    // shape is selected
    property HandleColor: TColor read FHandleColor write FHandleColor default cDefaultHandleColor;
    // Choose which handle painter to use. Default is hpW2K3Handle, the "word 2003"
    // style handles. You can set this property to hpStippleHandle to get the old-style
    // stippled handles, or to hpCustomHandle to provide your own handle painting. In
    // that case, OnCreateHandlePainter must be overridden.
    property HandlePainter: TdtpHandlePainterType read FHandlePainter write FHandlePainter default hpW2K3Handle;
    // Set HelperMethod to any of the available helpers in order to assist with
    // positioning or transparency tasks. Available methods:
    // * hmNone:    No helpers are drawn
    // * hmDots:    The document paints small dots on each grid location
    // * hmGrid:    The document paints grid lines
    // * hmPattern: The document displays a checker pattern just like photoshop
    property HelperMethod: TdtpHelperMethodType read FHelperMethod write SetHelperMethod default hmNone;
    // HintHidePause defines the time in msec that a hint is shown before it
    // is hidden again.
    property HintHidePause: integer read FHintHidePause write FHintHidePause default 2500;
    // HintPause defines the waiting period in msec before a hint is shown for the
    // first time.
    property HintPause: integer read FHintPause write FHintPause default 500;
    // HintShortPause defines the waiting period in msec between showing different
    // hints.
    property HintShortPause: integer read FHintShortPause write FHintShortPause default 50;
    // Set Hitsensitivity to a higher value than default 1.0 to make it easier to hit a shape with
    // the mouse when not exactly on it.
    property HitSensitivity: single read FHitSensitivity write SetHitSensitivity;
    // Hotzone scrolling allows the user to move the mouse near the edge of the window
    // so that the page will automatically scroll. Possible settings are:
    // * hzsNoScroll: Do not perform hotzone scrolling (default)
    // * hzsAlways: Always perform hotzone scrolling
    // * hzsWhenMouseDown: Only perform hotzone scrolling when mouse is down (e.g. when dragging)
    property HotzoneScrolling: TdtpHZScrollingType read FHotzoneScrolling write SetHotzoneScrolling default hzsNoScroll;
    // IsLoading is true when the document is loading a page (LoadPageFromXML), and
    // this flag is used to prevent calling of the "Changed" event in shapes upon loading.
    property IsLoading: boolean read FIsLoading;
    // IsPrinting will be true when the document is currently printing.
    property IsPrinting: boolean read GetIsPrinting;
    // If True (default) Show position of Margin under Mouse Pointer
    property ShowMarginHints: boolean read FShowMarginHints write FShowMarginHints default true;
    // If MarginssLocked (default false), user can not move Margins
    property MarginsLocked: boolean read FMarginsLocked write FMarginsLocked default false; // added by J.F. July 2011
    // Mode defines the current way in which the document behaves. Possible options are:
    // * vmBrowse: Hand cursor, drag document around, default when ReadOnly = True
    // * vmEdit: Arrow cursor, select shapes. default when ReadOnly = False
    // * vmTextSelect: Select text with drag rect Text cursor
    // * vmZoom: Zoom mode, zoomplus cursor
    // * vmSlideshow: Slideshow mode
    property Mode: TdtpViewerModeType read FMode write SetMode;
    // Modified will be True whenever the user or application has modified the document. This
    // can be anything from deleting a page to changing a shape property. Set Modified
    // to True in order to signal a change that is not detected by the document itself.
    property Modified: boolean read FModified write SetModified default false;
             // added by J.F. June 2011
             // How fast Horiz and Vert scroll with MouseWheel - default 10, must be >= 1
    property MouseWheelScrollSpeed: integer read FMouseWheelScrollSpeed write SetMouseWheelScrollSpeed default 10;
    // MultiSelectMethod determines the way in which the user can make multi-selections
    // using a marquee around a number of shapes.
    // * msmCtrl: User must press CTRL and drag a rectangle to select multiple items
    // * msmSimple: User can just click/drag to select multiple items, but must do so in empty spot (default).
    property MultiSelectMethod: TMultiSelectMethodType read FMultiSelectMethod write FMultiSelectMethod default msmSimple;
    // Set OptimizedPrinting to True to allow the print methods to skip large papercolor
    // areas. On some postprocessing print handlers this might cause incorrect centering
    // so the default is False.
    property OptimizedPrinting: boolean read FOptimizedPrinting write FOptimizedPrinting default False;
      //  added by J.F. June 2011
      // When true (default) holding down Ctrl and Alt allows panning
      // With Left mouse button down move mouse to Pan Page
      // Horiz and/or Vert scrollbars must be showing to work
    property PanWithMouseButton: boolean read FPanWithMouseButton write FPanWithMouseButton default true;
    // if true draw dotted rectangle around text area when editing (default True) - added by JF
    property PaintEditBorder: boolean read FPaintEditBorder write SetPaintEditBorder default True;
    // Performance determines the way in which the document uses memory. The default,
    // dpMemoryOverSpeed, will always try to keep mem consumption optimal, sometimes
    // causing speed penalties. Setting dpSpeedOverMemory will allow memory consumption
    // to grow to allow for higher speed (only use on systems with more than 512Mb and
    // not too many pages).
    property Performance: TdtpDocPerformanceType read FPerformance write FPerformance default dpMemoryOverSpeed;
    // Quality defines the way in which the document stretches bitmapped data. Using a high
    // quality is visually more appealing, but slower. Possible settings are:
    // sfNearest, sfDraft, sfLinear, sfCosine, sfSpline, sfLanczos, sfMitchell
    // * sfNearest: poor quality but very fast
    // * sfLinear: better quality, ideal for slower systems
    // * sfLinear2: even better, ideal for fast systems
    // * sfSpline: best possible quality but quite slow.
    property Quality: TdtpStretchFilter read FQuality write SetQuality default dtpsfLinear;
    // ReadOnly indicates wether the user can make changes to the document. Whenever
    // Mode is not equal to vmEdit, ReadOnly will also be set to True. Remember to set
    // ReadOnly back to False after changing mode back to vmEdit, otherwise the user
    // cannot make changes to the document. ReadOnly is only valid to direct editing,
    // the document can still be changed through code.
    property ReadOnly: boolean read FReadOnly write SetReadOnly default False;
    // RedoCount returns the number of Redo commands that are available in the document.
    // It can be used to determine the enabled state of the Redo menu command.
    property RedoCount: integer read GetRedoCount;
    // Assign a reference to a TrsRulercomponent that is above the document. The ruler
    // will be automatically updated.
    property RulerTop: TdtpRsRuler read FRulerTop write SetRulerTop;
    // Assign a reference to a TrsRulercomponent that is left of the document. The ruler
    // will be automatically updated.
    property RulerLeft: TdtpRsRuler read FRulerLeft write SetRulerLeft;
    // Assign a reference to a TrsRulerCorner displaying ruler units
    property RulerCorner: TdtpRsRulerCorner read FRulerCorner write SetRulerCorner;
    property RulerUnits: TRulerUnit read FRulerUnits write SetRulerUnits default ruMilli;
    // Screen resolution in the document, in Dots Per Inch.
    property ScreenDPI: single read GetScreenDPI write SetScreenDPI;
    // Scroll with the MouseWheel (changed by J.F. June 2011)
    property ScrollWithMouseWheel: boolean read FScrollWithMouseWheel write SetScrollWithMouseWheel default True;
            // Move Selected Shapes with Cursor Keys
    property ShapeNudgeEnabled: boolean read FShapeNudgeEnabled write FShapeNudgeEnabled default true; // added by J.F. June 2011
           // Distance to move selected shapes with Cursor Keys
    property ShapeNudgeDistance: single read FShapeNudgeDistance write FShapeNudgeDistance; //  added by J.F. June 2011
    // If ShowMargins is True (default), margins will be shown on the pages, as
    // stippled lines near the edges. See DefaultMarginLeft, DefaultMarginTop, DefaultMarginBottom
    // and DefaultMarginRight for margin size.
    property ShowMargins: boolean read FShowMargins write SetShowMargins default True;

    // ShowPageShadow
    property ShowPageShadow: boolean read FShowPageShadow write SetShowPageShadow default True; // added by J.F. Feb 2011

    // If True (default) Show Shape Hint under Mouse Pointer
    property ShowShapeHints: boolean read FShowShapeHints write FShowShapeHints default true; //  added by J.F. July 2011

    // If SnapToGrid is set (non-default), shapes will be placed on grid locations.
    property SnapToGrid: boolean read FSnapToGrid write FSnapToGrid default False;
    // If SnapToGuides is set (non-default), shapes will be placed on guide locations.
    property SnapToGuides: boolean read FSnapToGuides write FSnapToGuides default False;
    // Set StepAngle to a value > 0 to ensure that the user can only rotate the shape by increments of
    // StepAngle. Set StepAngle to 0 to allow completely free rotation. StepAngle does not influence
    // setting the DocAngle property of shapes through code.
    property StepAngle: single read FStepAngle write FStepAngle;
    // If True (default), a thumbnail of each page is stored as .BMP inside the document
    // archive file. This allows a thumbnail view of the pages for quick access.
    property StoreThumbnails: boolean read FStoreThumbnails write FStoreThumbnails default True;
    // ThumbnailHeight defines the height of the page thumbnails in pixels.
    property ThumbnailHeight: integer read FThumbnailHeight write SetThumbnailHeight default cDefaultThumbnailHeight;
    // ThumbnailWidth defines the width of the page thumbnails in pixels.
    property ThumbnailWidth:  integer read FThumbnailWidth  write SetThumbnailWidth default cDefaultThumbnailWidth;
    // UndoCount returns the number of Undo commands that are available in the document.
    // It can be used to determine the enabled state of the Undo menu command.
    property UndoCount: integer read GetUndoCount;
    // When UndoEnabled is True (default), any changes made to the document, pages or
    // shapes within pages are stored and can be undone one at a time with Undo.
    property UndoEnabled: boolean read GetUndoEnabled write SetUndoEnabled default True;
    // If False (default), the Undo list is cleared after each save of the document, and the
    // user will not be able to undo any commands that were done prior to saving.
    property UndoPastSave: boolean read FUndoPastSave write FUndoPastSave default False;
    // If UseClipboard is True (default), the Windows clipboard will be used for copy and paste
    // operations. It will be filled with format CF_TEXT, in the form of an XML file with
    // the data of the copied part of the document. If UseClipboard is False, an internal
    // clipboard will be used local to the document.
    property UseClipboard: boolean read FUseClipboard write SetUseClipboard default True;

    // Allow Shapes to be drawn outside of Page, as a scratch pad area  // added by J.F. Feb 2011
    property UseDocumentBoard: boolean read FUseDocumentBoard write SetUseDocumentBoard default False;

    // WindowLeft is the X coordinate of the upper-left corner of the visible window
    // in document coordinates.
    property WindowLeft: single read FWindowLeft write SetWindowLeft;
    // WindowTop is the Y coordinate of the upper-left corner of the visible window
    // in document coordinates.
    property WindowTop: single read FWindowTop write SetWindowTop;
    // Read-only string showing current version. See cVersion at the top of the
    // unit.
    property Version: string read GetVersion;
    // ViewStyle determines the visual appearance of the pages within the document:
    // * vsPrintLayout: Print Layout view, shows borders around pages with a shadow edge
    // * vsNormal: No borders, just the paper.
    property ViewStyle: TdtpViewStyleType read FViewStyle write SetViewStyle default vsPrintLayout;
     // allow to change DefaultZoomStep for ZoomIn and ZoomOut;
    property ZoomStep: single read FZoomStep write SetZoomStep; // added by J.F. June 2011
    // Set this value to zoom to a percentage of the page width. ZoomPercent = 100 is exactly the same
    // as "ZoomWidth"
    property ZoomPercent: single read FZoomPercent write SetZoomPercent;
           // Zoom With MouseButton (default true added by J.F. June 2011
           // Ctrl + Shift + Left Button click to ZoomIn at Mouse Pointer location
           // Ctrl + Shift + Right Button click to ZoomOut at Mouse Pointer location
    property ZoomWithMouseButton: boolean read FZoomWithMouseButton write FZoomWithMouseButton default true;
    // Zoom with the MouseWheel (default false) added by J.F. June 2011
    // Forward to ZoomIn - Backward to ZoomOut
    property ZoomWithMouseWheel: boolean read FZoomWithMouseWheel write SetZoomWithMouseWheel default False;
          // Zoom With Defined Rectangle (default true) added by J.F. June 2011
           // Ctrl + SpaceBar + Left Button down then drag to ZoomIn
    property ZoomWithRectangle: boolean read FZoomWithRectangle write FZoomWithRectangle default True;
    // Event OnAnimate is fired each 50 msec and can be used to animate any
    // document or shape property
    property OnAnimate: TNotifyEvent read FOnAnimate write FOnAnimate;
    // Event OnCreateHandlePainter is called whenever a shape requires handles and
    // HandlePainter = hpCustomHandle. It can be used by the application to
    // override the type of handles that are drawn by creating a specific type
    // of TdtpHandlePainter object in var HandlePainter.
    property OnCreateHandlePainter: TdtpHandlePainterEvent read FOnCreateHandlePainter write
      FOnCreateHandlePainter;
    // debug message event
    property OnDebugOut;
    // Event OnDocumentChanged is fired whenever stored document properties change.
    // This does not include any properties of pages/shapes etc (see OnShapeChanged, OnPageChanged)
    property OnDocumentChanged: TNotifyEvent read FOnDocumentChanged write FOnDocumentChanged;
    // OnDrawQualityIndicator is called whenever a quality indicator should be drawn on the
    // image. Use the parameter Quality (in percents) to determine how good the image
    // will look. 100% is adequate, higher is better, lower is not acceptable. Draw the
    // quality indicator on the canvas given in Canvas, e.g. in left upper corner, given
    // by Rect. You can change Rect to use any other position on the shape. Drawn should
    // be set to True if any drawing was performed
    property OnDrawQualityIndicator: TdtpDrawQualityIndicatorEvent read FOnDrawQualityIndicator
      write FOnDrawQualityIndicator;
    // Event OnFocusShape is fired when the shape that currently has the focus was
    // changed. If Shape = nil, no shape has the focus
    property OnFocusShape: TNotifyShapeEvent read FOnFocusShape write FOnFocusShape;
    //  added by J.F. July 2011
         //Event OnMarginRightClick sends the Margin position in current ruler units
         // to allow developer to let user move Margin
         // i.e. in a popup dialog
    property OnMarginRightClick: TdtpMarginRightClickEvent read FOnMarginRightClick write FOnMarginRightClick;
         //  added by J.F. June 2011
         //Event OnGuideRightClick sends the Guide position in current ruler units
         // to allow developer to let user move guide
         // i.e. in a popup dialog
    property OnGuideRightClick: TdtpGuideRightClickEvent read FOnGuideRightClick write FOnGuideRightClick;
    // Event OnLoadError is fired whenever an error occured during loading of the document.
    // Shape specifies which shape or page caused the load error, and string Error contains
    // a description.
    property OnLoadError: TdtpLoadErrorEvent read FOnLoadError write FOnLoadError;
    // Whenever graphical routines need to locate a local filename on the disk, and it
    // is not present, this event will be called to allow the application to find it.
    property OnLocateFilename: TdtpLocateFilenameEvent read FOnLocateFilename write FOnLocateFilename;
    // Event OnMouseDown is fired whenever one of the mouse buttons gets depressed.
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    // Event OnMouseUp is fired whenever one of the mouse buttons gets released.
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    // Event OnPageChanged is fired whenever the host app must update page-related
    // info in the GUI, like the page thumbnail, page counters, etc. The event can
    // get called with Page = nil, which indicates the page count should be updated
    property OnPageChanged: TNotifyPageEvent read FOnPageChanged write FOnPageChanged;
    // Implement this event to add custom background painting to the document. All content that is painted
    // by this implementation is visible behind the shapes of TdtpDocument itself. The content will appear
    // on both printer and screen.
    property OnPaintBackground: TdtpPaintEvent read FOnPaintBackground write FOnPaintBackground;
    // Implement this event to add custom foreground painting to the document. All content that is painted
    // by this implementation is visible in front of the shapes of TdtpDocument itself. The content will appear
    // on both printer and screen.
    property OnPaintForeground: TdtpPaintEvent read FOnPaintForeground write FOnPaintForeground;
    // Event OnProgress is fired during lengthy operations, like load, save, print
    property OnProgress: TdtpProgressEvent read FOnProgress write FOnProgress;
    // Event OnSelectionChanged is fired whenever the selection changes. Use it to adjust selection
    // count or other information depending on the extent of the selection
    property OnSelectionChanged: TNotifyEvent read FOnSelectionChanged write FOnSelectionChanged;
    // Event OnShapeChanged is fired whenever a shape's persistant properties change. When
    // the argument Shape = nil, there can be multiple updated shapes.
    property OnShapeChanged: TNotifyShapeEvent read FOnShapeChanged write FOnShapeChanged;
    // Event OnShapeDestroy is called whenever a shape (or page) within the document is about to
    // be destroyed. Use it to do any application-side data freeing based on the "Tag" property.
    // Never use this event to manually free the shape! (this is done by TdtpDocument)
    property OnShapeDestroy: TNotifyShapeEvent read FOnShapeDestroy write FOnShapeDestroy;
    // Event OnShapeEditClosed is called when an edit operation on a shape is finished. You can use it to
    // e.g. update the edit state in the GUI.
    property OnShapeEditClosed: TNotifyShapeEvent read FOnShapeEditClosed write FOnShapeEditClosed;
    // Event OnShapeInsertClosed gets fired whenever a shape is succesfully inserted with method
    // InsertShapeByClick, InsertShapeByDrag or ShapeInsert, or when an insert was cancelled. If
    // the shape insertion is cancelled, the Shape parameter is nil. Never free any object as a
    // response to this event; if neccesary the objects are freed by TdtpDocument internally.
    property OnShapeInsertClosed: TNotifyShapeEvent read FOnShapeInsertClosed write FOnShapeInsertClosed;
    // Implement this event to load any additional information from the shape's XML node. Use this method to load any related
    // information to the shape, e.g. through the Tag property
    property OnShapeLoadAdditionalInfo: TdtpShapeFilingEvent read FOnShapeLoadAdditionalInfo write FOnShapeLoadAdditionalInfo;
    // Implement this event to save any additional information to the shape's XML node. Use this method to store any related
    // information to the shape, e.g. through the Tag property
    property OnShapeSaveAdditionalInfo: TdtpShapeFilingEvent read FOnShapeSaveAdditionalInfo write FOnShapeSaveAdditionalInfo;
    // Event OnShapeListChanged gets fired whenever there's a change in the list of shapes of the current
    // page, so whenever a shape gets added, deleted or two shapes change places. Use it to update a shape list
    // in the application.
    property OnShapeListChanged: TNotifyEvent read FOnShapeListChanged write FOnShapeListChanged;
    // Load additional info in the document from the document's XML node
    property OnLoadAdditionalInfo: TdtpFilingEvent read FOnLoadAdditionalInfo write FOnLoadAdditionalInfo;
    // Store additional info in the document to the document's XML node
    property OnSaveAdditionalInfo: TdtpFilingEvent read FOnSaveAdditionalInfo write FOnSaveAdditionalInfo;
    // Event OnUpdateScrollPosition is fired whenever the user has scrolled the document.
    property OnUpdateScrollPosition: TNotifyEvent read FOnUpdateScrollPosition write FOnUpdateScrollPosition;
    // Event for GUI development (added by JF) 
    property OnShapeEditStart:TNotifyShapeEvent read FOnShapeEditStart write FOnShapeEditStart;
    // Event for GUI development (added by JF) 
    property OnShapeInsertStart:TNotifyShapeEvent read FOnShapeInsertStart write FOnShapeInsertStart;

    // Properties from TVirtScrollbox and TCustomControl

    property Align;
    property Anchors;
    property AutoScroll;
    property BorderStyle;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property Enabled;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;
    property OnMouseMove;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property OnUnDock;
    {$IFDEF D10UP}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF D10UP}

  end;

resourcestring

  sdeArchiveDoesNotExist    = 'Archive does not exist';
  sdeCannotInsertPageAtPos  = 'Cannot insert a page at that position';
  sdeEndPrintingMismatch    = 'EndPrinting called more often than BeginPrinting';
  sdeEndUndoMismatch        = 'EndUndo called more often than BeginUndo';
  sdeEndUpdateMismatch      = 'EndUpdate called more often than BeginUpdate';
  sdeInvalidPageCount       = 'Invalid page count';
  sdeUnableToExecuteUndo    = 'Unable to execute Undo';
  sdeThreadingError         = 'Threading error (working already)';
  sdeCannotFindFile         = 'Cannot find file "%s"';
  sdeUnableToCreateTempfile = 'Unable to create windows temp file';
  sdeNoIndexFoundInArchive  = 'No index found in archive';
  sWarnOrigFileNotFound     = 'The original file %s could not be located on disk. Do you want to try and find it yourself?';

const

  // Cursors

  crDtpRotate             = -30; // Rotate cursor index
  crDtpSizeCopy           = -31; // Sizecopy cursor index

  // these cursors are used during insertion of shapes - thanks to Emmanuel Lion

  crDtpCross              = -32;
  crDtpCrossLine          = -33;
  crDtpCrossArrow         = -34;
  crDtpCrossRectangle     = -35;
  crDtpCrossEllipse       = -36;
  crDtpCrossText          = -37;
  crDtpCrossImage         = -38;

  crDtpHorizGuide         = -39; //  added by J.F. Feb 2011
  crDtpVertGuide          = -40; //  added by J.F. Feb 2011

  crDtpHandGrabber        = -41; // added by J.F. June 2011
  crDtpHandHover          = -42; // added by J.F. June 2011

  crDtpCrossRndRectangle  = -43; // added by J.F. June 2011

  crDtpMagnifier          = -44; // added by J.F. June 2011

  crDtpDragZoom           = -45; // added by J.F. June 2011

  crDtpZoomIn             = -46; // added by J.F. June 2011
  crDtpZoomOut            = -47; // added by J.F. June 2011

  cPrintQualityCount = 4;
  cPrintQualityNames: array[0..cPrintQualityCount - 1] of string =
    ('Low print quality (150 DPI)',
     'Medium print quality (300 DPI)',
     'High print quality (600 DPI)',
     'Device print quality (best possible DPI)' );

var
  FResourceClassList: TObjectList = nil;
  FResourceThread: TThread = nil; //dtpResourceThread

implementation

uses
  dtpEffectShape, dtpTextShape, dtpFreehandShape, dtpResource, dtpRasterFormats,
  dtpW2K3Handles, dtpUtil, dtpPolygonText, dtpLineShape;  // changed by J.F. June 2011

type
  // Provided to give access to protected methods in TdtpShape
  TShapeAccess = class(TdtpShape);
  // Provided to give access to protected methods in TdtpPage
  TPageAccess = class(TdtpPage); // added by J.F. June 2011

const

  // Xml element names
  cIndexName = AnsiString('Index.xml');
  cPageTemplate  = 'Page%.4d.xml';
  cThumbTemplate = 'Thumb%.4d.bmp';
  cFontEmbedName = 'Fonts.dat';

{ TdtpDocument }

procedure TdtpDocument.AcceptDragBorders;
var
  i: integer;
begin
  for i := 0 to ShapeCount - 1 do
    if Shapes[i].Selected then
      Shapes[i].AcceptDragBorder;
end;

procedure TdtpDocument.AcceptFileDrop(const AFilename: string; MousePos: TPoint);
var
  HitInfo: THitTestInfo;
  Shape: TdtpShape;
  Bitmap: TdtpSnapBitmap;
  P: TPoint;
  LT: TdtpPoint;
begin
  // Point in FDocument coordinates
  P := ScreenToClient(MousePos);

  // Hit test
  GetHitTestInfoAt(P, HitInfo, Shape);

  if HitInfo = htShape then
  begin

    // We hit a shape, replace image
    if Shape is TdtpBitmapShape then
      TdtpBitmapShape(Shape).Image.LoadFromFile(AFileName);

  end else
  begin

    // We hit emptyness, so we create new shape
    LT := CurrentPage.ScreenToShape(P);
    Bitmap := TdtpSnapBitmap.Create;
    Bitmap.Image.LoadFromFile(AFileName);
    if not Bitmap.Image.IsEmpty then
    begin
      Bitmap.DocLeft := LT.X;
      Bitmap.DocTop  := LT.Y;
      ShapeAdd(Bitmap);
    end else
      Bitmap.Free;

  end;
end;

procedure TdtpDocument.AcceptInsertBorder;
var
  R: TdtpRect;
begin
  // Check
  if not assigned(FInsertShape) then
    exit;
  // We insert the shape at the insert rectangle
  if assigned(CurrentPage) then
  begin
    // Construct rectangle
    R.Left := FDragPosDoc.X - CurrentPage.DocLeft;
    R.Top  := FDragPosDoc.Y - CurrentPage.DocTop;
    if (FDragDeltaDoc.X <> 0) or (FDragDeltaDoc.Y <> 0) then
    begin
      R.Right  := R.Left + FDragDeltaDoc.X;
      R.Bottom := R.Top  + FDragDeltaDoc.Y;
    end else
    begin
      R.Right  := R.Left + FInsertShape.DocWidth;
      R.Bottom := R.Top  + FInsertShape.DocHeight;
    end;

    // and call its method
    FInsertShape.AcceptInsertBorder(R);

  end;
end;

procedure TdtpDocument.AcceptSelectBorder;
// Here we will check if any of the shapes fall within the selection
var
  i: integer;
  R: TRect;
begin
  R := GetScreenRect(FDragPosDoc, FDragDeltaDoc);
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].Selected := Shapes[i].IntersectWithRect(R);
  EndUpdate;
  // Focus on first selected shape
  FocusedShape := Selection[0];
end;

procedure TdtpDocument.AddToSelection(AShape: TdtpShape);
begin
  if assigned(AShape) then
  begin
    // Toggle selection
    AShape.Selected := not AShape.Selected;
    // Focus on it if selected
    if AShape.Selected then
      FocusedShape := AShape;
  end;
end;

procedure TdtpDocument.AdjustSizeToPage(Sender: TObject);
// Adjusts the size of the scrollbox so that it fits snugly around the page. This
// method is usually connected to the page's OnResize event.
var
  Page: TdtpPage;
  R: TdtpRect;
  W, H: single;
begin
  if FIsAdjusting then
    exit;
  FIsAdjusting := True;
  try
    // Set Width and Height so that the page falls just inside the control's client rect
    if assigned(CurrentPage) then
    begin
      Page := CurrentPage;

      case ViewStyle of
      vsPrintLayout:
        begin
          // Make sure page rectangle R starts at 0,0
          R := Page.ParentRect;
          OffsetRect(R, -Page.DocLeft, -Page.DocTop);

          W  := 2 * cBorderSizePx + (R.Right - R.Left) * ScreenDpm;
          H := 2 * cBorderSizePx + (R.Bottom - R.Top) * ScreenDpm;
          SetScrollBounds(0, 0, round(W), round(H));
          Page.AdjustLeftTop(cborderSizePx / ScreenDpm, cBordersizePx / ScreenDpm);
        end;
      vsNormal:
        begin
          W := (Page.Right - Page.Left) * ScreenDpm;
          H := (Page.Bottom - Page.Top) * ScreenDpm;
          SetScrollBounds(0, 0, round(W), round(H));

          Page.AdjustLeftTop(0, 0);
        end;
      end; // case
    end;
  finally
    FIsAdjusting := False;
  end;
end;

function TdtpDocument.GetDraggedShapePosDoc(APoint: TdtpPoint): TdtpPoint;  //  added by J.F. July 2011
var
  DraggedShapePosDoc: TdtpPoint;
begin
  DraggedShapePosDoc:= dtpPoint(0,0);
  case FHitInfo of

    htShape,htLT: DraggedShapePosDoc:= dtpPoint(FDraggedShape.Left,FDraggedShape.Top);
    htLeft: DraggedShapePosDoc:= dtpPoint(FDraggedShape.Left,FDraggedShape.Bottom / 2);
    htLB: DraggedShapePosDoc:= dtpPoint(FDraggedShape.Left,FDraggedShape.Bottom);
    htBottom: DraggedShapePosDoc:= dtpPoint(FDraggedShape.Right / 2,FDraggedShape.Bottom);
    htRB: DraggedShapePosDoc:= dtpPoint(FDraggedShape.Right,FDraggedShape.Bottom);
    htRight: DraggedShapePosDoc:= dtpPoint(FDraggedShape.Right,FDraggedShape.Bottom / 2);
    htRT: DraggedShapePosDoc:= dtpPoint(FDraggedShape.Right,FDraggedShape.Top);
    htTop: DraggedShapePosDoc:= dtpPoint(FDraggedShape.Right / 2,FDraggedShape.Top);
    htPoint: if APoint.X > (FDraggedShape.Right / 2) then
               DraggedShapePosDoc:= dtpPoint(FDraggedShape.Right,FDraggedShape.Bottom)
             else
               DraggedShapePosDoc:= dtpPoint(FDraggedShape.Left,FDraggedShape.Top);
  end;

  Result:= DraggedShapePosDoc;
end;

function TdtpDocument.AdjustToGrid(APoint: TdtpPoint; Adjust: boolean): TdtpPoint;
var
  DraggedShapeAdjustedToGrid: TdtpPoint; // added by J.F. May 2011 AdjustToGrid fix
  DraggedShapePosDoc: TdtpPoint;  // added by J.F. May 2011 AdjustToGrid fix
begin
  if assigned(CurrentPage) and Adjust then
  begin

    // Convert to page coords
    APoint := OffsetPointF(APoint, -CurrentPage.DocLeft, -CurrentPage.DocTop);

    if (FDragPosDoc.Y = -1000) and Assigned(FDraggedShape) then  // changed by J.F. July 2011
      DraggedShapePosDoc:= GetDraggedShapePosDoc(APoint); // added by J.F. July 2011


    // Snap to the grid
    APoint := CurrentPage.AdjustToGrid(APoint);
    if FDragPosDoc.Y = -1000 then  // added by J.F. May 2011
    begin
      DraggedShapeAdjustedToGrid:= CurrentPage.AdjustToGrid(DraggedShapePosDoc);
      APoint.X:= APoint.X - (DraggedShapeAdjustedToGrid.X - DraggedShapePosDoc.X);
      APoint.Y:= APoint.Y - (DraggedShapeAdjustedToGrid.Y - DraggedShapePosDoc.Y);
    end;
    // Convert back
    APoint := OffsetPointF(APoint, CurrentPage.DocLeft, CurrentPage.DocTop);
  end;
  Result := APoint; //  added by J.F. July 2011
end;

function TdtpDocument.AdjustToGuides(APoint: TdtpPoint; Adjust: boolean; var Adjusted: boolean): TdtpPoint;
// changed by J.F. July 2011
var
  DraggedShapeAdjustedToGuide: TdtpPoint;
  DraggedShapePosDoc: TdtpPoint;
  ShapeOffset: TdtpPoint;
begin
  if assigned(CurrentPage) and Adjust then
  begin
    Adjusted:= false;
    // Convert to page coords
    APoint := OffsetPointF(APoint, -CurrentPage.DocLeft, -CurrentPage.DocTop);

    if (FSnapToGuidesOffset.Y = -1000) and Assigned(FDraggedShape) then
    begin
      DraggedShapePosDoc:= GetDraggedShapePosDoc(APoint); // changed by J.F. July 2011

      FSnapToGuidesOffset.X:=  DraggedShapePosDoc.X - APoint.X;
      FSnapToGuidesOffset.Y:=  DraggedShapePosDoc.Y - APoint.Y;
    end;

    // Snap to guide
    ShapeOffset.X:= APoint.X + FSnapToGuidesOffset.X;
    ShapeOffset.Y:= APoint.Y + FSnapToGuidesOffset.Y;
    DraggedShapeAdjustedToGuide := CurrentPage.AdjustToGuides(ShapeOffset);
    if DraggedShapeAdjustedToGuide.X <> ShapeOffset.X then
    begin
      APoint.X:= APoint.X - (ShapeOffset.X - DraggedShapeAdjustedToGuide.X);
      Adjusted:= true;
    end;
    if DraggedShapeAdjustedToGuide.Y <> ShapeOffset.Y then
    begin
      APoint.Y:= APoint.Y - (ShapeOffset.Y - DraggedShapeAdjustedToGuide.Y);
      Adjusted:= true;
    end;
    // Convert back
    APoint := OffsetPointF(APoint, CurrentPage.DocLeft, CurrentPage.DocTop);
  end;
  Result := APoint; // added by J.F. July 2011
end;

procedure TdtpDocument.AlignBottom;
// Align all shapes along their bottom
var
  i: integer;
  Mx: single;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginUndo;
  Mx := 0;
  // Find bottom first
  for i := 0 to SelectionCount - 1 do
    Mx := Max(Mx, Selection[i].Bottom);
  // Align all shapes to it
  for i := 0 to SelectionCount - 1 do
    Selection[i].Bottom := Mx;
  EndUndo;
end;

procedure TdtpDocument.AlignCenter;
var
  i: integer;
  MaxLeft,
  MaxRight,
  Center: Single;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginUndo;

  MaxLeft  := PageWidth;
  MaxRight := 0;

  for i := 0 to SelectionCount - 1 do
  begin
    MaxLeft  := Min(Selection[i].Left,  MaxLeft);
    MaxRight := Max(Selection[i].Right, MaxRight);
  end;

  Center := (MaxLeft + MaxRight) / 2;

  for i := 0 to SelectionCount - 1 do
    Selection[i].Left := Center - (Selection[i].Right - Selection[i].Left) / 2;

  EndUndo;
end;

procedure TdtpDocument.AlignLeft;
// Align all shapes along their left
var
  i: integer;
  Mx: single;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginUndo;
  Mx := PageWidth;
  // Find left first
  for i := 0 to SelectionCount - 1 do
    Mx := Min(Mx, Selection[i].Left);
  // Align all shapes to it
  for i := 0 to SelectionCount - 1 do
    Selection[i].Left := Mx;
  EndUndo;
end;

procedure TdtpDocument.AlignMiddle;
var
  i: Integer;
  MaxTop,
  MaxBottom,
  Center: Single;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginUndo;

  MaxTop    := PageHeight;
  MaxBottom := 0;

  for i := 0 to SelectionCount - 1 do
  begin
    MaxTop    := Min(Selection[i].Top,    MaxTop);
    MaxBottom := Max(Selection[i].Bottom, MaxBottom);
  end;

  Center := (MaxTop + MaxBottom) / 2;

  for i := 0 to SelectionCount - 1 do
    Selection[i].Top := Center - (Selection[i].Bottom - Selection[i].Top) / 2;

  EndUndo;
end;

procedure TdtpDocument.AlignRight;
// Align all shapes along their right
var
  i: integer;
  Mx: single;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginUndo;
  Mx := 0;
  // Find right first
  for i := 0 to SelectionCount - 1 do
    Mx := Max(Mx, Selection[i].Right);
  // Align all shapes to it
  for i := 0 to SelectionCount - 1 do
    Selection[i].Right := Mx;
  EndUndo;
end;

procedure TdtpDocument.AlignTop;
// Align all shapes along their tops
var
  i: integer;
  Mx: single;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginUndo;
  Mx := PageHeight;
  // Find top first
  for i := 0 to SelectionCount - 1 do
    Mx := Min(Mx, Selection[i].Top);
  // Align all shapes to it
  for i := 0 to SelectionCount - 1 do
    Selection[i].Top := Mx;
  EndUndo;
end;

    // Align shapes to Vertical Center of Page
    // If only one shape selected it will Align to Vertical Center of page
    // If more than one shape the total of all shapes will Align Vertically
    // without crashing into the center
procedure TdtpDocument.AlignVerticalPageCenter;  // added by J.F. Apr 2011
var i: integer;
    Total: single;
    MaxTop: single;
    MaxBottom: single;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  try
    BeginUndo;
    BeginUpdate;    // Done this way so shapes don't crash together in center of page
                    // Single selected shape centers on vertical center
    MaxTop    := PageHeight;
    MaxBottom := 0;
    for i := 0 to SelectionCount - 1 do
    begin
      MaxTop:= Min(Selection[i].Top,MaxTop);
      MaxBottom:= Max(Selection[i].Bottom,MaxBottom);
    end;

    Total:= (PageHeight  - (MaxBottom - MaxTop)) / 2 - MaxTop;

    for i := 0 to SelectionCount - 1 do
      Selection[i].SetDocCenter(Selection[i].Right - ((Selection[i].Right - Selection[i].Left) / 2), Selection[i].Top + ((Selection[i].Bottom - Selection[i].Top) / 2) + Total);
    
  finally
    EndUpdate;
    EndUndo;
  end;
end;

    // Align shapes to Horizontal Center of Page
procedure TdtpDocument.AlignHorizontalPageCenter; // added by J.F. Apr 2011
var i: integer;

begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  try
    BeginUndo;
    BeginUpdate;
    for i := 0 to SelectionCount - 1 do
      Selection[i].SetDocCenter(PageWidth / 2, Selection[i].Bottom - ((Selection[i].Bottom - Selection[i].Top) / 2));
  finally
    EndUpdate;
    EndUndo;
  end;
end;

procedure TdtpDocument.BeginPrinting;
begin
  inc(FPrintNestCount);
end;

procedure TdtpDocument.BeginUndo;
// Call BeginUndo..EndUndo to brace a number of operations that must be undone
// in one click. Since usually this also means updates should not occur, the call
// to BeginUpdate is automatically included
begin
  inc(FUndoNestCount);
  BeginUpdate;
end;

procedure TdtpDocument.BeginUpdate;
// Call BeginUpdate and EndUpdate to brace a number of operations on the document
// and prevent calling OnShapeChanged, OnFocusShape and OnSelectionChanged.
begin
  inc(FUpdateNestCount);
end;

procedure TdtpDocument.BeginWorking(ACursor: TCursor = crDefault);
begin
  SetWindowsCursor(ACursor);
  inc(FWorkingCount);
end;

procedure TdtpDocument.BuildEditPopup;
// Here we build up an internal EditPopup that will catch a number of special
// shortcut keys before the application can (only in vmEdit mode)
var
  mnuEditCut: TMenuItem;
  mnuEditCopy: TMenuItem;
  mnuEditPaste: TMenuItem;
begin
  FEditPopup := TPopupMenu.Create(Self);
  mnuEditCut := TMenuItem.Create(Self);
  mnuEditCopy := TMenuItem.Create(Self);
  mnuEditPaste := TMenuItem.Create(Self);
  mnuEditCut.Caption := 'Cut';
  mnuEditCut.Tag:= 1; // added by J.F.
  mnuEditCut.ShortCut := 16472;
  mnuEditCut.OnClick := DoEditMenuClick;
  mnuEditCopy.Caption := 'Copy';
  mnuEditCopy.Tag:= 2; // added by J.F.
  mnuEditCopy.ShortCut := 16451;
  mnuEditCopy.OnClick := DoEditMenuClick;
  mnuEditPaste.Caption := 'Paste';
  mnuEditPaste.Tag:= 3; // added by J.F.
  mnuEditPaste.ShortCut := 16470;
  mnuEditPaste.OnClick := DoEditMenuClick;
  FEditPopup.Items.Add(mnuEditCut);
  FEditPopup.Items.Add(mnuEditCopy);
  FEditPopup.Items.Add(mnuEditPaste);
end;

procedure TdtpDocument.BuildSmartHitPoints;
var
  i, PointIndex: integer;
  // Radius in pixels of the area to test for smart hitting
  SmartHitRadius: integer;
// local
procedure AddPoint(X, Y: integer);
begin
  FSmartHitPoints[PointIndex].X := X;
  FSmartHitPoints[PointIndex].Y:= Y;
  inc(PointIndex);
end;
// main
begin
  SmartHitRadius := Max(2, round(4 * HitSensitivity)); // changed by EL
  SetLength(FSmartHitPoints, SmartHitRadius * 4 + 1 + 4);
  PointIndex := 0;
  // Point itself
  AddPoint(0, 0);
  // Horizontal and vertical
  for i := SmartHitRadius downto 1 do
  begin
    AddPoint( i,  0);
    AddPoint(-i,  0);
    AddPoint( 0,  i);
    AddPoint( 0, -i);
  end;

  // Diagonals, just one point
  i := round(SmartHitRadius * 0.71);
  AddPoint( i,  i);
  AddPoint(-i,  i);
  AddPoint( i, -i);
  AddPoint(-i, -i);
end;

procedure TdtpDocument.ClearDoc;
// added by EL
// clear Document without restoring default values
var
  i: integer;
begin

  // Clear pages
  for i := 0 to PageCount - 1 do
  begin
    Pages[i].ShapeClear;
    DoShapeDestroy(Pages[i]);
  end;
  FPages.Clear;
  FCurrentPageIndex := -1;
  // added by EL: after a clear, the paste position should be the original one
  FClipboardPage := nil;
  // Clear undo
  UndoClear;
  // Clear archive
  FArchive.Clear;
  // added by J.F. Feb 2011
  FFontManager.ClearFontList;
  // Clear background image
  FDefaultBackgroundImage.Clear;
  // added by J.F. Feb 2011
  FDocumentModifiedWithVersion := GetVersion;
end;

procedure TdtpDocument.Clear;
// changed by EL
begin

  // Clear pages, undo, archive ...
  ClearDoc;
  // Restore saved defaults
  FCurrentPageIndex  := -1;
  FHandleColor       := cDefaultHandleColor;
  FHandleEdgeColor   := cDefaultHandleEdgeColor;
  FHotzoneScrolling  := hzsNoScroll;
  FModified          := True;
  FQuality           := dtpsfLinear;
  FScreenDpm         := cMonitorDpm;
  FThumbnailHeight   := cDefaultThumbnailHeight;
  FThumbnailWidth    := cDefaultThumbnailWidth;
  FViewStyle         := vsPrintLayout;
  FStepAngle         := 0;
  FStoreThumbnails   := True;
  FShowMargins := True;  

  FDefaultMarginLeft   := cDefaultMarginLeft;
  FDefaultMarginRight  := cDefaultMarginRight;
  FDefaultMarginTop    := cDefaultMarginTop;
  FDefaultMarginBottom := cDefaultMarginBottom;
  FDefaultPageColor    := cDefaultPageColor;
  FDefaultPageHeight   := cDefaultPageHeight;
  FDefaultPageWidth    := cDefaultPageWidth;
  FDefaultGridColor    := cDefaultGridColor;
  FDefaultGridSize     := cDefaultGridSize;

  // added by J.F. Feb 2011
  FDocumentCreatedWithVersion := GetVersion;

  // Force redraw
  Invalidate;
end;

procedure TdtpDocument.ClearSelection;
var
  i: integer;
begin
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].Selected := False;
  EndUpdate;
end;

procedure TdtpDocument.CMMouseEnter(var Message: TMessage); // added by J.F. June 2011
begin    // helper to focus Keyboard input
  if FAutoFocus and not Focused then
    SetFocus;
end;

procedure TdtpDocument.CMMouseLeave(var Message: TMessage); //  added by J.F. June 2011
begin
  Screen.Cursor:= crDefault;
end;

procedure TdtpDocument.CMWantSpecialKey(var Message: TMessage);
begin
  Message.Result := 1;
end;

procedure TdtpDocument.Copy;
// Copy selection to the clipboard
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  if SelectionCount = 0 then
    exit;
  BeginUndo;
  try
    // Either to clipboard or internal
    if FUseClipboard then
      // Copy to windows clipboard
      ClipBoard.AsText := SelectionToText
    else
      // Copy to our own clipboard
      FInternalClipboard := SelectionToText;

     // Store the page from where it came
    FClipboardPage := CurrentPage;
  finally
    EndUndo;
  end;
end;

constructor TdtpDocument.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DragKind := dkDrag;
  FArchive := TsdStorage.Create(Self);
  FPages := TObjectList.Create;
  FUndos := TObjectList.Create;
  FRedos := TObjectList.Create;
  FDefaultBackgroundImage := TdtpBitmapResource.Create;
  FDefaultBackgroundImage.Document := Self;
  FDefaultBackgroundImage.OnObjectChanged := DefaultBackgroundImageObjectChanged;
  FAnimateTimer := TTimer.Create(Self);
  FAnimateTimer.Enabled := True;
  FAnimateTimer.OnTimer := TimerAnimate;
  FAnimateTimer.Interval := 50;
  FFontManager := TdtpFontManager.Create(Self);

  FShapeHint:= TdtpHint.Create(self);
  FMarginHint:= TdtpHint.Create(self);
  FGuideHint:= TdtpHint.Create(self);

  // Edit popup menu - will be freed on our inherited destroy
  BuildEditPopup;

  // Defaults
  SetDefaults;

  // Create default page
  DisableUndo;
  try
    PageAdd(nil);
  finally
    EnableUndo;
    Modified := False;
  end;
end;

procedure TdtpDocument.CreateHandlePainter(Shape: TdtpShape; var AHandlePainter: TdtpHandlePainter);
begin
  case FHandlePainter of
  hpStippleHandle: AHandlePainter := TdtpHandlePainter.Create;
  hpW2K3Handle:    AHandlePainter := TdtpW2K3HandlePainter.Create;
  hpCustomHandle:
    if assigned(FOnCreateHandlePainter) then
      FOnCreateHandlePainter(Self, Shape, AHandlePainter);
  end;
end;

procedure TdtpDocument.Cut;
// Cut selection to the clipboard
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginUndo;
  try
    // Copy values
    Copy;
    // And cut them out
    DeleteSelectedShapes;
    // added by EL: after cut, first paste will set back the shapes at same original position
    FClipboardPage := nil;
  finally
    EndUndo;
  end;
end;

procedure TdtpDocument.DefaultBackgroundImageObjectChanged(Sender: TObject);
begin
  DocumentChanged;
  // All default page's thumbnails might have changed
  UpdateDefaultPageThumbnails;
  Invalidate;
end;

procedure TdtpDocument.DefaultLocateFilename(var AName: string);
var
  OPD: TOpenPictureDialog;
begin
  // Ask user to locate file
  if MessageDlg(Format(sWarnOrigFileNotFound,
    [ExtractFileName(Name)]), mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    OPD := TOpenPictureDialog.Create(nil);
    try
      OPD.Filter := RasterFormatOpenFilter;
      OPD.Filename := AName;
      if OPD.Execute then
        AName := OPD.FileName;
    finally
      OPD.Free;
    end;
  end;
end;

procedure TdtpDocument.DeleteAllDocumentGuides; //  added by J.F. July 2011
var
  Index: integer;
begin
  for Index := 0 to PageCount - 1 do
    TdtpPage(FPages[Index]).DeleteAllGuides;
end;

procedure TdtpDocument.DeleteSelectedShapes;
var
  i: integer;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginUpdate;
  for i := ShapeCount - 1 downto 0 do
    if Shapes[i].Selected and Shapes[i].AllowDelete then
      ShapeDelete(i);
  EndUpdate;
end;

destructor TdtpDocument.Destroy;
begin
  FreeAndNil(FAnimateTimer);
  FreeAndNil(FShapeHint);
  FreeAndNil(FMarginHint);
  FreeAndNil(FGuideHint);

  FreeAndNil(FHotzoneTimer);
  // Free the undo stack
  FreeAndNil(FUndos);
  FreeAndNil(FRedos);
  // Free the page list
  FreeAndNil(FPages);
  // Free background image
  FreeAndNil(FDefaultBackgroundImage);
  // The archive is a component, and was created as our child thus we do
  // not have to free it, it will be done in inherited
  inherited;
end;

procedure TdtpDocument.DisableUndo;
begin
  inc(FUndoDisableCount);
end;

function TdtpDocument.DocToRuler(const Value:single):single; //  added by J.F. June 2011
begin
  case FRulerUnits of
      ruInch: Result:= Value / cMMToInch;

      ruCenti: Result:= Value / cMMToCM;

      ruPixel: Result:= Value * ScreenDPI / cMMToInch;

  else
      Result:= Value;
  end;
  Result:= RoundDecimal(Result,3);
end;

function TdtpDocument.DocToRuler(const Value: TdtpPoint): TdtpPoint; // added by J.F. June 2011
begin
  Result.X:= DocToRuler(Value.X);
  Result.Y:= DocToRuler(Value.Y);
end;

function TdtpDocument.DocToScreen(APoint: TdtpPoint): TdtpPoint;
// Convert document coordinates (mm) to screen coords (pixels)
begin
  Result.X := (APoint.X - WindowLeft) * ScreenDpm;
  Result.Y := (APoint.Y - WindowTop ) * ScreenDpm;
end;

procedure TdtpDocument.DocumentChanged;
// Call this procedure whenever document properties change
begin
  Modified := True;
  if assigned(FOnDocumentChanged) then
    FOnDocumentChanged(Self);
end;

procedure TdtpDocument.DoDragClose(Accept: boolean);
begin
  if State <> vsDrag then
    exit;
  FState := vsNone;
  // Paint last time to invert
  PaintDragBorders(FDragDeltaDoc);
  // Accept it
  if Accept then
    AcceptDragBorders;
  // Reset
  FHitInfo := htNone;
  FDraggedShape := nil;
end;

procedure TdtpDocument.DoDragStart(ADelta: TdtpPoint);
var
  i: integer;
begin
  // Multi-shape only for FHitInfo = htShape
  if FHitInfo <> htShape then
    FocusedShape := FDraggedShape; // Forces all other selected to be deselected

  // Make sure not to start drag if AllowMove is false
  if FHitInfo = htShape then
    for i := 0 to SelectionCount - 1 do
      if Selection[i].AllowMove = False then
      begin
        FHitInfo := htNone;
        exit;
      end;

  State := vsDrag;
  PaintDragBorders(ADelta);
end;

procedure TdtpDocument.DoEditClose(Accept: boolean);
begin
  if FState = vsEdit then
    FState := vsNone;
  if assigned(EditedShape) then
  begin
    DoShapeEditClosed(EditedShape);
    TShapeAccess(EditedShape).DoEditClose(Accept);
  end;
  FEditedShape := nil;
end;

procedure TdtpDocument.DoEditMenuClick(Sender: TObject);
// When we arrive here, the internal "EditPopup" caught a special key (cut/copy/paste)
// and we're going to handle it *before* shortcut items in the application can
var
  Key: char;
  //  added by J.F.
  Tag: integer;
begin
  if not assigned(EditedShape) or (State <> vsEdit) then
    exit;
  if Sender is TMenuItem then
  begin
    Tag := (Sender as TMenuItem).Tag;
    if Tag = 1 then //  added by J.F.
    begin
      Key := #$18;
      EditedShape.Keypress(Key);
    end;
    if Tag = 2 then   //  added by J.F.
    begin
      Key := #$03;
      EditedShape.Keypress(Key);
    end;
    if Tag = 3 then  //  added by J.F.
    begin
      Key := #$16;
      EditedShape.Keypress(Key);
    end;
  end;
end;

procedure TdtpDocument.DoEditStart(AShape: TdtpShape);
begin
  FEditedShape := AShape;
  if assigned(FEditedShape) then
  begin
    State := vsEdit; // added by JF
    FEditedShape.Edit;
    // changed by J.F. Feb 2011// bug fix for PolygonShapes
    // because TdtpShape.Edit nils FEditedShape
    if assigned(FEditedShape) and assigned(OnShapeEditStart) then
      OnShapeEditStart(Self, FEditedShape);
  end;
end;

procedure TdtpDocument.DoFocusShape(AShape: TdtpShape);
begin
  if FUpdateNestCount = 0 then
  begin
    if assigned(FOnFocusShape) then
      FOnFocusShape(Self, AShape);
    FMustCallFocusShape := False;
  end else
    FMustCallFocusShape := True;
end;

procedure TdtpDocument.DoMousePanning; // added by J.F. June 2011
// Scroll the parent if we are in Panning
var
  DeltaX, DeltaY: integer;
  MousePanPos: TPoint;
begin
  // Some exceptions when we do not Pan
  //if State in [vsInsert, vsEdit] then
    //exit;

  // Position
  MousePanPos := ScreenToClient(Mouse.CursorPos);
  // Test if we're inside scrolling rect
  if not PtInRect(ClientRect, MousePanPos) then
  begin
    SetWindowsCursor(crDefault);
    exit;
  end;
  if Windows.GetCursor <> Screen.Cursors[crDtpHandGrabber] then
    SetWindowsCursor(crDtpHandGrabber);

  DeltaX := MousePanPos.X - FMousePanningOldPos.X;
  DeltaY := MousePanPos.Y - FMousePanningOldPos.Y;
  FMousePanningOldPos := MousePanPos;

  ScrollBy(-DeltaX, -DeltaY);
  //UpdateRulers;
end;


procedure TdtpDocument.DoHotzoneScrolling;
// Scroll the parent if we are in hotzone
var
  i: integer;
  XSpeed, YSpeed: single;
  XSgn, YSgn: integer;
  DeltaT: integer;
  DeltaX, DeltaY: integer;
  Tick: dword;
  HotPos, Delta: TPoint;
  MouseSpeed: single;
begin
  // Some exceptions when we do not scroll
  if State in [vsInsert, vsEdit] then
    exit;

  // Timing
  Tick := GetTickCount;
  // Avoid div by zero and limit to 200 msec
  DeltaT := Max(1, Min(Tick - FHotzoneLastTick, 200));
  FHotzoneLastTick := Tick;

  // Position
  HotPos := ScreenToClient(Mouse.CursorPos);

  // Calculate mouse speed (pixels per msec)
  Delta.X := HotPos.X - FHotzoneOldPos.X;
  Delta.Y := HotPos.Y - FHotzoneOldPos.Y;
  MouseSpeed := sqrt(sqr(Delta.X) + sqr(Delta.Y)) / DeltaT * 1000;
  FHotzoneOldPos := HotPos;

  // No hotzoning yet -> check mouse speed. If too high, leave
  if (not FHotzoneActive) and (MouseSpeed > cHotZoneSpeedLimit) then
    exit;

  XSpeed := 0;
  YSpeed := 0;

  // Test if we're inside scrolling rect
  if not PtInRect(Parent.ClientRect, HotPos) then
  begin
    FHotzoneActive := False;
    exit;
  end;

  // Test if we're in the hotzone
  if HotPos.X < cHotzonePercentage * ClientWidth then
    // Left hotzone
    XSpeed := - 1.0 + HotPos.X / (cHotzonePercentage * ClientWidth);
  if (ClientWidth - HotPos.X) < cHotzonePercentage * ClientWidth then
    // Right hotzone
    XSpeed := + 1.0 - (ClientWidth - HotPos.X) / (cHotzonePercentage * Width);

  if HotPos.Y < cHotzonePercentage * ClientHeight then
    // Top hotzone
    YSpeed := -1.0 + HotPos.Y / (cHotzonePercentage * ClientHeight);
  if (ClientHeight - HotPos.Y) < cHotzonePercentage * ClientHeight then
    // Bottom hotzone
    YSpeed := +1.0 - (ClientHeight - HotPos.Y) / (cHotzonePercentage * ClientHeight);

  if (XSpeed <> 0) or (YSpeed <> 0) then
  begin
    XSgn := Math.Sign(XSpeed);
    YSgn := Math.Sign(YSpeed);

    // Acceleration factor
    XSpeed := sqr(XSpeed);
    YSpeed := sqr(YSpeed);

    // Delay factor
    if FHotzoneActive then
      FHotzoneDuration := FHotzoneDuration + dword(DeltaT)
    else
      FHotzoneDuration := 10;

    // Startup delay
    XSpeed := Min(XSpeed, FHotzoneDuration / cHotzoneStartupTime);
    YSpeed := Min(YSpeed, FHotzoneDuration / cHotzoneStartupTime);

    // Set back sign
    XSpeed := XSpeed * XSgn;
    YSpeed := YSpeed * YSgn;

    FHotzoneActive := False;

    // Determine displacement
    DeltaX := round(XSpeed * DeltaT * cHotZoneSensitivity);
    DeltaY := round(YSpeed * DeltaT * cHotZoneSensitivity);

    if FDragBordersDrawn then
    begin

      // Undraw, scroll, draw... So first undraw
      for i := 0 to ShapeCount - 1 do
        if Shapes[i].Selected then
          TShapeAccess(Shapes[i]).PaintDragBorder(Canvas);
      // Now scroll
      ScrollBy(DeltaX, DeltaY);

      // And make *sure* the window gets painted, otherwise this might happen after
      // we redraw the second time, and then it will hide the dragborder, giving
      // glitches
      Perform(WM_PAINT, 0, 0);

      // Now draw again
      for i := 0 to ShapeCount - 1 do
        if Shapes[i].Selected then
          TShapeAccess(Shapes[i]).PaintDragBorder(Canvas);

    end else
    begin

      // Scroll the window
      if HotzoneScrolling = hzsAlways then
        ScrollBy(DeltaX, DeltaY);

    end;


    FHotzoneActive := True;
  end else
  begin
    FHotzoneActive := False;
  end;

end;

procedure TdtpDocument.DoInsertClose(Accept: boolean);
begin
  // Paint the border a last time
  if FState = vsInsert then
    PaintInsertBorder(FDragDeltaDoc);
  FState := vsNone;

  // Do we accept the new shape?
  if Accept then
  begin
    if assigned(FInsertShape) then
    begin
      // Set the new shape's border to the dragged rectangle
      AcceptInsertBorder;
      // Add the shape
      ShapeAdd(FInsertShape);
      // Call the OnShapeInserted method
      DoShapeInsertClosed(FInsertShape);
      // Regenerate it
      FInsertShape.Regenerate;
      // Select the shape after insertion
      FInsertShape.Selected := True;
      if FInsertShape is TdtpFreehandShape then
        // And put it in edit mode (for text and memo)
        DoEditStart(FInsertShape);
    end;
    FInsertShape := nil;
  end else
  begin
    // Not accepted, so free the shape
    if assigned(FInsertShape) then
    begin
      DoShapeInsertClosed(nil);
      DoShapeDestroy(FInsertShape);
      FreeAndNil(FInsertShape);
    end;
  end;
  FDraggedShape := nil;
end;

procedure TdtpDocument.DoPageChanged(APage: TdtpPage);
begin
  if assigned(FOnPageChanged) then
    FOnPageChanged(Self, APage);
end;

procedure TdtpDocument.DoPaintBackground(Canvas: TCanvas; const Device: TDeviceContext; const PageRect: TRect);
begin
  if assigned(FOnPaintBackground) then
    FOnPaintBackground(Self, Canvas, Device, PageRect);
end;

procedure TdtpDocument.DoPaintForeground(Canvas: TCanvas; const Device: TDeviceContext; const PageRect: TRect);
begin
  if assigned(FOnPaintForeground) then
    FOnPaintForeground(Self, Canvas, Device, PageRect);
end;

procedure TdtpDocument.DoProgress(AType: TdtpProgressType; ACount, ATotal: integer; APercent: single);
begin
  FProgressCount := ACount;
  FProgressTotal := ATotal;
  if assigned(FOnProgress) then
    FOnProgress(Self, AType, ACount, ATotal, APercent);
end;

procedure TdtpDocument.DoSelectClose(Accept: boolean);
begin
  if FState = vsSelect then
    // Paint the border a last time
    PaintSelectBorder(FDragDeltaDoc);
  FState := vsNone;
  // Do we accept the selection, and furthermore, is there any rectangle?
  if Accept and (FDragDeltaDoc.X * FDragDeltaDoc.Y <> 0) then
    AcceptSelectBorder;
end;

procedure TdtpDocument.DoSelectionChanged;
begin
  if FUpdateNestCount = 0 then
  begin
    FMustCallSelectionChanged := False;
    if assigned(FOnSelectionChanged) then
      FOnSelectionChanged(Self);
  end else
    FMustCallSelectionChanged := True;
end;

procedure TdtpDocument.DoShapeChanged(AShape: TdtpShape);
begin
  // Set our own modified to true
  Modified := True;
  // Fire event
  if (FUpdateNestCount = 0)  then
  begin
    FMustCallShapeChanged := False;
    if assigned(FOnShapeChanged) then
      FOnShapeChanged(Self, AShape);
  end else
    FMustCallShapeChanged := True;
end;

procedure TdtpDocument.DoShapeDestroy(AShape: TdtpShape);
begin
  // Set our references to nil if they coincide
  if AShape = FocusedShape then
    FocusedShape := nil;
  if AShape = EditedShape then
    EditedShape := nil;
  if AShape = DraggedShape then
    DraggedShape := nil;
  // Call the event
  if assigned(FOnShapeDestroy) then
    FOnShapeDestroy(Self, AShape);
end;

procedure TdtpDocument.DoShapeEditClosed(AShape: TdtpShape);
begin
  if assigned(FOnShapeEditClosed) then
    FOnShapeEditClosed(Self, AShape);
end;

procedure TdtpDocument.DoShapeInsertClosed(AShape: TdtpShape);
begin
  if assigned(FOnShapeInsertClosed) then
    FOnShapeInsertClosed(Self, AShape);
end;

procedure TdtpDocument.DoShapeListChanged;
begin
  if assigned(FOnShapeListChanged) then
    FOnShapeListChanged(Self);
end;

procedure TdtpDocument.DoShapeLoadAdditionalInfo(Shape: TdtpShape; Node: TXmlNodeOld);
begin
  if assigned(FOnShapeLoadAdditionalInfo) then
    FOnShapeLoadAdditionalInfo(Self, Shape, Node);
end;

procedure TdtpDocument.DoShapeNudge(const Key: word);  //  added by J.F. June 2011
var
  i: integer;
begin
  if (SelectionCount > 0) and (EditedShape = nil) then
  try
    BeginUpdate();
    for i := 0 to SelectionCount - 1 do
    if Selection[i].AllowMove then
    case Key of
      VK_LEFT: Selection[i].DocLeft:= Selection[i].DocLeft - FShapeNudgeDistance;
      VK_RIGHT: Selection[i].DocLeft:= Selection[i].DocLeft + FShapeNudgeDistance;
      VK_UP:  Selection[i].DocTop:= Selection[i].Doctop - FShapeNudgeDistance;
      VK_DOWN: Selection[i].DocTop:= Selection[i].DocTop + FShapeNudgeDistance;
    end;
  finally
    EndUpdate();
  end;
end;

procedure TdtpDocument.DoShapeSaveAdditionalInfo(Shape: TdtpShape; Node: TXmlNodeOld);
begin
  if assigned(FOnShapeSaveAdditionalInfo) then
    FOnShapeSaveAdditionalInfo(Self, Shape, Node);
end;

procedure TdtpDocument.DoZoomInByMouse; // added by J.F. June 2011
begin
  FZoomPercent := FZoomPercent * ZoomStep;
  MouseZoomByFactor(ZoomStep);
end;

procedure TdtpDocument.DoZoomOutByMouse; // added by J.F. June 2011
begin
 FZoomPercent := FZoomPercent / ZoomStep;
 MouseZoomByFactor(1 / ZoomStep);
end;

procedure TdtpDocument.DrawQualityIndicator(Sender: TObject; Canvas: TCanvas;
  var Rect: TRect; Quality: integer; var Drawn: boolean);
begin
  if assigned(FOnDrawQualityIndicator) then
    FOnDrawQualityIndicator(Sender, Canvas, Rect, Quality, Drawn);
end;

procedure TdtpDocument.EnableUndo;
begin
  dec(FUndoDisableCount);
end;

procedure TdtpDocument.EndPrinting;
begin
  dec(FPrintNestCount);
  if FPrintNestCount < 0 then
    raise Exception.Create(sdeEndPrintingMismatch);
end;

procedure TdtpDocument.EndUndo;
begin
  dec(FUndoNestCount);
  if (FUndoNestCount = 0) and FUndoNestAdditions then
    FUndoNestAdditions := False;
  if FUndoNestCount < 0 then
    raise Exception.Create(sdeEndUndoMismatch);
  EndUpdate;
end;

procedure TdtpDocument.EndUpdate;
begin
  dec(FUpdateNestCount);
  if FUpdateNestCount = 0 then
  begin
    if FMustCallShapeChanged then
      DoShapeChanged(nil);
    if FMustCallSelectionChanged then
      DoSelectionChanged;
    if FMustCallFocusShape then
      DoFocusShape(FocusedShape);
  end;
  if FUpdateNestCount < 0 then
    raise Exception.Create(sdeEndUpdateMismatch);
end;

procedure TdtpDocument.EndWorking;
begin
  dec(FWorkingCount);
  if FWorkingCount = 0 then
    SetWindowsCursor(Cursor);
end;

function TdtpDocument.FormatHint(Value: single): string;  //  added by J.F. June 2011
var
  Precision: string;
begin
  case FHintPrecision of
      ghp1Decimal: Precision:= cGHP1Decimal;
      ghp2Decimals: Precision:= cGHP2Decimals;
      ghp3Decimals: Precision:= cGHP3Decimals;
  end;
  Result:=  Format(Precision, [DocToRuler(Value)]);
end;

procedure TdtpDocument.ForceUpgradeFromPreviousVersion;
begin
  FUpgradeFromPreviousVersion := True;
end;

function TdtpDocument.GetCurrentPage: TdtpPage;
begin
  Result := Pages[CurrentPageIndex];
end;

function TdtpDocument.GetDragCursor(AShape: TdtpShape; AHitInfo: THitTestInfo): TCursor;
var
  Roll: byte;
begin

  // Adjust cursor for rotation of shape
  if assigned(AShape) and (AHitInfo in [htLT..htTop]) then
  begin
    // We hit a handle, correct for rotation (otherwise the directions may look wrong)
    Roll := (round(AShape.DocAngle + 22.5) div 45) mod 8;
    while Roll > 0 do
    begin
      if AHitInfo = htTop then
        AHitInfo := htLT
      else
        AHitInfo := Succ(AHitInfo);
      dec(Roll);
    end;
  end;

  // and select the correct cursor
  case AHitInfo of
  htLT, htRB:      Result := crSizeNWSE;
  htRT, htLB:      Result := crSizeNESW;
  htLeft, htRight: Result := crSizeWE;
  htTop, htBottom: Result := crSizeNS;
  else
    Result := Cursor;
  end;

end;

function TdtpDocument.GetFocusedShape: TdtpShape;
var
  i: integer;
begin
  Result := nil;
  // Always check if our focused shape still exists
  if assigned(FFocusedShape) then
    for i := 0 to ShapeCount - 1 do
      if Shapes[i] = FFocusedShape then
      begin
        Result := FFocusedShape;
        exit;
      end;
end;

procedure TdtpDocument.GetHitTestInfoAt(APos: TPoint; var AHitInfo: THitTestInfo; var AShape: TdtpShape);
// Determine if a shape is hit at APos and if so, where.
var
  i: integer;
begin
  AShape := nil;
  AHitInfo := htNone;
  if ReadOnly then
    exit;
  for i := ShapeCount - 1 downto 0 do
    if Shapes[i].Selected then
    begin
      AHitInfo := TShapeAccess(Shapes[i]).GetHandleHitTestInfoAt(APos);
      if AHitInfo <> htNone then
      begin
        AShape := Shapes[i];
        exit;
      end;
    end;
  for i := ShapeCount - 1 downto 0 do
    if Shapes[i].AllowSelect then
    begin
      AHitInfo := TShapeAccess(Shapes[i]).GetHitTestInfoAt(APos);
      if AHitInfo <> htNone then
      begin
        AShape := Shapes[i];
        exit;
      end;
    end;
end;

procedure TdtpDocument.GetHitTestInfoDblClickAt(APos: TPoint; var AHitInfo: THitTestInfo;
  var AShape: TdtpShape);
// In case of doubleclick, determine if a shape is hit at APos and if so, where.
// In this case, shapes inside groups will be detected as well (so we can edit
// shapes inside groups by doubleclicking them)
var
  i: integer;
begin
  AShape := nil;
  AHitInfo := htNone;

  // NH: dblclick should be found anyway.. even in readonly mode, to pass on the
  // event to the shape. Same for TdtpShape.Allowedit.
  for i := ShapeCount - 1 downto 0 do
  begin
    AHitInfo := TShapeAccess(Shapes[i]).GetHitTestInfoDblClickAt(APos, AShape);
    if AHitInfo <> htNone then
      exit;
  end;
end;

function TdtpDocument.GetIsPrinting: boolean;
// Always call BeginPrint .. EndPrint around any print block
begin
  Result := FPrintNestCount > 0;
end;

procedure TdtpDocument.GetMouseState(Message: TWMMouse;
  var Left, Middle, Right, Shift, Ctrl, Alt: boolean; var X, Y: integer);
begin
  Shift  := (Message.Keys AND MK_SHIFT   <> 0);
  Ctrl   := (Message.Keys AND MK_CONTROL <> 0);
  Left   := (Message.Keys AND MK_LBUTTON <> 0);
  Middle := (Message.Keys AND MK_MBUTTON <> 0);
  Right  := (Message.Keys AND MK_RBUTTON <> 0);
  X := Message.XPos;
  Y := Message.YPos;
  // Alt key
  Alt := (GetKeyState(VK_MENU) and $8000) > 0;
end;

function TdtpDocument.GetNewSessionRef: integer;
begin
  inc(FRefCounter);
  Result := FRefCounter;
end;

function TdtpDocument.GetPageCount: integer;
begin
  Result := 0;
  if assigned(FPages) then
    Result := FPages.Count;
end;

function TdtpDocument.GetPageHeight: single;
begin
  Result := 0;
  if assigned(CurrentPage) then
    Result := CurrentPage.DocHeight;
end;

function TdtpDocument.GetPages(Index: integer): TdtpPage;
begin
  Result := nil;
  if (Index >= 0) and (Index < PageCount) then
    Result := TdtpPage(FPages[Index]);
end;

function TdtpDocument.GetPageWidth: single;
begin
  Result := 0;
  if assigned(CurrentPage) then
    Result := CurrentPage.DocWidth;
end;

function TdtpDocument.GetPopupMenu: TPopupMenu;
// We override this TControl method in order to provide "on the fly" menus for
// edit mode.. in order to get shortcut keys to be processed.
begin
  Result := nil;
  if State = vsEdit then
  begin
    if assigned(EditedShape) then
      Result := EditedShape.EditPopupMenu;
    if Result = nil then
      Result := FEditPopup;
    exit;
  end;
  if assigned(FocusedShape) then
     Result := FocusedShape.PopupMenu;
  if not assigned(Result) then
    Result := inherited GetPopupMenu;
end;

function TdtpDocument.GetPrinterDpm: single;
begin
  Result := 0; // This is the setting for "pqDevice"
  case PrintQuality of
  pqLow:    Result := cLowPrinterDpm;
  pqMedium: Result := cNormalPrinterDpm;
  pqHigh:   Result := cHighPrinterDpm;
  end;
end;

function TdtpDocument.GetRedoCount: integer;
begin
  Result := 0;
  if assigned(FRedos) then
    Result := FRedos.Count;
end;

function TdtpDocument.GetRedos(Index: integer): TdtpCommand;
begin
  Result := nil;
  if (Index >= 0) and (Index < RedoCount) then
    Result := TdtpCommand(FRedos[Index]);
end;

function TdtpDocument.GetScreenDPI: single;
begin
  Result := FScreenDpm * cMMToInch;
end;

function TdtpDocument.GetScreenRect(BaseDoc: TdtpPoint; SizeDoc: TdtpPoint): TRect;
begin
  Result.TopLeft     := Point(DocToScreen(BaseDoc));
  Result.BottomRight := Point(DocToScreen(dtpPoint(BaseDoc.X + SizeDoc.X, BaseDoc.Y + SizeDoc.Y)));
end;

function TdtpDocument.GetSelection(Index: integer): TdtpShape;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ShapeCount - 1 do
    if Shapes[i].Selected then
      if Index > 0 then
        dec(Index)
      else
      begin
        Result := Shapes[i];
        exit;
      end;
end;

function TdtpDocument.GetSelectionCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to ShapeCount - 1 do
    if Shapes[i].Selected then
      inc(Result);
end;

function TdtpDocument.GetShapeCount: integer;
begin
  Result := 0;
  if assigned(CurrentPage) then
    Result := CurrentPage.ShapeCount;
end;

function TdtpDocument.GetShapes(Index: integer): TdtpShape;
begin
  Result := nil;
  if assigned(CurrentPage) then
    Result := CurrentPage.Shapes[Index];
end;

function TdtpDocument.GetSmartHitPointCount: integer;
begin
  Result := length(FSmartHitPoints);
end;

function TdtpDocument.GetSmartHitPoints(Index: integer): TPoint;
begin
  Result.X := 0; Result.Y := 0;
  if (Index >= 0) and (Index < SmartHitPointCount) then
    Result := FSmartHitPoints[Index];
end;

function TdtpDocument.GetUndoCount: integer;
begin
  Result := 0;
  if assigned(FUndos) then
    Result := FUndos.Count;
end;

function TdtpDocument.GetUndoEnabled: boolean;
begin
  Result := FUndoEnabled and (FUndoDisableCount = 0);
end;

function TdtpDocument.GetUndos(Index: integer): TdtpCommand;
begin
  Result := nil;
  if (Index >= 0) and (Index < UndoCount) then
    Result := TdtpCommand(FUndos[Index]);
end;

function TdtpDocument.GetVertScrollBarVisible(): Boolean;
begin
  Result:= (GetWindowlong(Handle, GWL_STYLE) AND WS_VSCROLL) <> 0;
end;

function TdtpDocument.GetHorizScrollBarVisible(): Boolean;
begin
  Result:= (GetWindowlong(Handle, GWL_STYLE) AND WS_HSCROLL) <> 0;
end;

function TdtpDocument.GetVersion: string;
begin
  Result := cDtpDocumentsVersion;
end;

procedure TdtpDocument.Group;
var
  Group: TdtpGroupShape;
  Idx: integer;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  if SelectionCount = 0 then
    exit;

  BeginUndo;
  // Create and add a group shape, and let it group selected shapes
  Idx := Selection[0].Index;
  Group := TdtpGroupShape.Create;
  ShapeInsert(Idx, Group);
  Group.Group;
  EndUndo;

  // Focus on this new groupnode
  FocusedShape := Group;
end;

function TdtpDocument.HasClipboardData: boolean;
// Check if we have clipboard data.. must be fast because this function
// is often called from menu updaters
var
  Buf: array[0..7] of char;
begin
  if UseClipboard then
  begin
    Result := Clipboard.HasFormat(CF_TEXT);
    if Result then Clipboard.GetTextBuf(@Buf, 6);
    Result := Buf = '<?xml';
  end else
    Result := Length(FInternalClipboard) > 0;
end;

function TdtpDocument.HasSelection: boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to ShapeCount - 1 do
    if Shapes[i].Selected then
    begin
      Result := True;
      exit;
    end;
end;

procedure TdtpDocument.DoInsertShape(AShape: TdtpShape; AInsertMode: TdtpInsertModeType);
begin
  if IsWorking then raise
    Exception.Create(sdeThreadingError);

  // Terminate any edit
  if State = vsEdit then
    DoEditClose(True);

  // Cancel old insert, will also free and nil any allocated insertshape
  DoInsertClose(False);
  if not assigned(AShape) then
    exit;

  // Store for later
  FInsertShape := AShape;

  // Deselect any shapes
  ClearSelection;
  // Set the correct mode
  State := vsBeforeInsert;
  FInsertMode := AInsertMode;
  FHitInfo := htRB;
  if Assigned(OnShapeInsertStart) then // added by JF
    OnShapeInsertStart(self,AShape);
end;

procedure TdtpDocument.InsertShapeByClick(AShape: TdtpShape);
begin
  // added by J.F. Feb 2011 so we have Keyboard input if user hits Esc key
  if CanFocus and (not Focused) then
    SetFocus;
  DoInsertShape(AShape,imBySingleClick);
end;

procedure TdtpDocument.InsertShapeByDrag(AShape: TdtpShape);
begin
  // added by J.F. Feb 2011 so we have Keyboard input if user hits Esc key
  if CanFocus and (not Focused) then
    SetFocus;
  DoInsertShape(AShape,imByRectangle);
end;

procedure TdtpDocument.InvalidateShape(AShape: TdtpShape);
var
  R: TRect;
begin
  if assigned(AShape) then
  begin
    R := TShapeAccess(AShape).GetInvalidationRect;
    if assigned(Parent) then
      // Invalidate only if we have a valid parent
      InvalidateRect(Handle, @R, True);
  end;
end;

procedure TdtpDocument.InvalidateShapeRect(AShape: TdtpShape; ARect: TdtpRect);
// Invalidate just this part of the shape (ARect is given in shape coordinates)
var
  V1, V2, V3, V4: TdtpPoint;
  R: TRect;
begin
  if not assigned(AShape) then
    exit;

  // Find corners
  V1 := AShape.ShapeToScreen(dtpPoint(ARect.Left,  ARect.Top   ));
  V2 := AShape.ShapeToScreen(dtpPoint(ARect.Left,  ARect.Bottom));
  V3 := AShape.ShapeToScreen(dtpPoint(ARect.Right, ARect.Top   ));
  V4 := AShape.ShapeToScreen(dtpPoint(ARect.Right, ARect.Bottom));

  // Construct circumscribing rectangle
  R.Left   := Round(Min(Min(V1.X, V2.X), Min(V3.X, V4.X)) - 0.5);
  R.Right  := Round(Max(Max(V1.X, V2.X), Max(V3.X, V4.X)) + 0.5);
  R.Top    := Round(Min(Min(V1.Y, V2.Y), Min(V3.Y, V4.Y)) - 0.5);
  R.Bottom := Round(Max(Max(V1.Y, V2.Y), Max(V3.Y, V4.Y)) + 0.5);

  if assigned(Parent) then
    InvalidateRect(Handle, @R, True);
end;

function TdtpDocument.IsWorking: boolean;
begin
  Result := (FWorkingCount > 0);
end;

procedure TdtpDocument.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if AllowKeyInput then
  begin
    if ssCtrl in Shift then   //  added by J.F. June 2011
    if (ssAlt in Shift) and FPanWithMouseButton then
    begin
      if VertScrollBarVisible or HorizScrollBarVisible then
      if SetClientRectCursor(crDtpHandHover) then
        FViewerFunction:= vfPanning;
      exit;
    end
    else
    if (ssShift in Shift) and FZoomWithMouseButton  then  //  added by J.F. June 2011
    begin
      if SetClientRectCursor(crDtpMagnifier) then
        FViewerFunction:= vfMouseButtonZoom;
      exit;
    end
    else
    if (FZoomWithRectangle) and (Key = 32) then  //  added by J.F. June 2011
    begin
      if SetClientRectCursor(crDtpDragZoom) then
        FViewerFunction:= vfMouseDragZoom;
      exit;
    end
    else
    if FViewerFunction in [vfDirectMouseZoomInOut] then // added by J.F. June 2011
    begin
      SetClientRectCursor(crDtpZoomOut);
      exit;
    end;

    if (State = vsEdit) and assigned(EditedShape) then
    begin
      EditedShape.KeyDown(Key, Shift);
      exit;
    end;
    // Some keys that we process
    case Key of
      VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN:  if FShapeNudgeEnabled then DoShapeNudge(Key);  //  changed by J.F. June 2011

      VK_ESCAPE: // Escape key - cancel drag operations
        begin
          State := vsNone;
          DoInsertClose(False);
          // added by J.F. Feb 2011 - make sure cursor is set back to crDefault
          //SetWindowsCursor(crDefault);
          SetWindowsCursor(Cursor); //  changed by J.F. June 2011
        end;
      VK_DELETE: // Delete current selection
        DeleteSelectedShapes;
      VK_F2: // F2 means "Edit"
        if SelectionCount > 0  then
          DoEditStart(Selection[0]);
      VK_F5:
        if assigned(CurrentPage) then
          CurrentPage.Regenerate;
      {$IFDEF TRIAL}{$I TRIALDTP4.INC}{$ENDIF} // Trial version protection
    end;
  end else
    // added by J.F. Feb 2011 - make sure cursor is set back to crDefault
    if (State = vsBeforeInsert) and (Key = VK_ESCAPE) then
    begin
      State := vsNone;
      DoInsertClose(False);
      //SetWindowsCursor(crDefault);
      SetWindowsCursor(Cursor); //  changed by J.F. June 2011
    end;

  inherited;
end;

procedure TdtpDocument.KeyPress(var Key: Char);
begin
  if AllowKeyInput then
  begin
    if (State = vsEdit) and assigned(EditedShape) then
    begin
      EditedShape.KeyPress(Key);
      exit;
    end;
    // Some of the keys we process ourself
    case Key of
    #$03: // Ctrl-C (Copy)
      begin
        Copy;
        Key := #0;
        exit;
      end;
    #$16: // Ctrl-V (Paste)
      begin
        Paste;
        Key := #0;
        exit;
      end;
    #$18: // Ctrl-X (Cut)
      begin
        Cut;
        Key := #0;
        exit;
      end;
    end;//case
  end;
  inherited;
end;

procedure TdtpDocument.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if AllowKeyInput then
  begin
    if FViewerFunction in [vfDirectMouseZoomInOut] then // added by J.F. June 2011
    begin
      SetClientRectCursor(crDtpZoomIn);
    end
    else
    if (FViewerFunction in [vfPanning, vfMouseButtonZoom, vfMouseDragZoom]) and
       (ssCtrl in Shift) or (ssAlt in Shift) or (ssShift in Shift) or (Key = 32) then // added by J.F. June 2011
    begin
      if FViewerFunction = vfMouseDragZoom  then
        PaintMouseDragZoomBorder(FMouseDragZoomFinalPos);
      FViewerFunction:= vfNone;
      SetWindowsCursor(Cursor);
      Screen.Cursor:= crDefault;
    end
    else
    if (State = vsEdit) and assigned(EditedShape) then
    begin
      EditedShape.KeyUp(Key, Shift);
      exit;
    end;
  end;
  inherited;
end;

procedure TdtpDocument.LoadFromArchive;
var
  i, Count: integer;
  Xml: TNativeXmlOld;
  M: TsdFastMemStream;
  Page: TdtpPage;
  Thumbnail: TBitmap;
  StreamName: Utf8String;
begin
  glResourceLockEnter;
  try
    FIsLoading := True;
    Count := 0;
    // this is the central TNativeXml instance inside the archive
    Xml := TNativeXmlOld(CreateXmlForDtp(''));
    try

      M := TsdFastMemStream.Create;
      try

        // Load index
        Archive.StreamRead(cIndexName, M);
        if M.Size = 0 then
          raise Exception.Create(sdeNoIndexFoundInArchive);
        Xml.LoadFromStream(M);
        // And load our header info
        LoadFromXml(Xml.Root);
        // Get the number of pages by looking for them in the archive
        for i := 0 to Archive.StreamCount - 1 do
        begin
          StreamName := Archive.StreamNames[i];
          if system.copy(StreamName, 1, 4) = 'Page' then
            Count := Max(Count, StrToIntDef(system.copy(StreamName, 5, 4), 0));
        end;

        // Load fonts
        if FFontEmbedding and Archive.StreamExists(cFontEmbedName) then
        begin
          try
            Archive.StreamRead(cFontEmbedName, M);
            FFontManager.LoadFromStream(M);
          except
          // Silent exception
          end;
        end;

      finally
        M.Free;
      end;
    finally
      Xml.Free;
    end;

    // Defer the load of all pages
    for i := 0 to Count - 1 do
    begin
      DoProgress(ptLoad, i + 1, Count, i / Count);
      // Just add an empty page - it will be loaded just in time
      Page := TdtpPage.Create;
      Page.IsLoaded := False;
      // But we will try to get the thumbnail though
      if FStoreThumbnails then
      begin
        M := TsdFastMemStream.Create;
        try
          try
            Archive.StreamRead(UTF8String(Format(cThumbTemplate, [i + 1])), M);
          except
            M.Size := 0;
          end;
          if M.Size > 0 then
          begin
            Thumbnail := TBitmap.Create;
            try
              Thumbnail.LoadFromStream(M);
              Page.Thumbnail := Thumbnail;
            finally
              Thumbnail.Free;
            end;
          end;
        finally
          M.Free;
        end;
      end;
      PageAdd(Page);
    end;

    // Set current page to first and reset modified
    CurrentPageIndex := 0;
    Modified := False;
    DoProgress(ptLoad, Count, Count, 1);
  finally
    FIsLoading := False;
    glResourceLockLeave;
  end;
  invalidate;
end;

procedure TdtpDocument.LoadFromFile(const AFilename: string);
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginWorking(crHourglass);
  try
//    DoDebugOut(Self, wsInfo, 'LoadFromFile');
    glResourceLockEnter;
    try
      // Make sure we have this file
      if not FileExists(AFileName) then
        raise Exception.CreateFmt(sdeCannotFindFile, [AFileName]);
      Clear;

      if ArchiveDirect then
        // In case of ArchiveDirect we work directly on the file
        Archive.WorkOnFile(AFileName)
      else
        // Otherwise we load it from the file, the file will remain opened
        // by the archive, but only with read access.
        Archive.LoadFromFile(AFileName);

      // Finally, load the document from the archive
      LoadFromArchive;
    finally
      glResourceLockLeave;
    end;
  finally
    EndWorking;
  end;
end;

procedure TdtpDocument.LoadFromStream(S: TStream);
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginWorking(crHourglass);
  try
    glResourceLockEnter;
    try
      Clear;

      Archive.LoadCopyFromStream(S);

      // Finally, load the document from the archive
      LoadFromArchive;
    finally
      glResourceLockLeave;
    end;
  finally
    EndWorking;
  end;
end;

procedure TdtpDocument.LoadFromXml(ANode: TXmlNodeOld);
var
  ChildNode: TXmlNodeOld;
  BM: TdtpBitmap;
begin
  // Clear;
  if not assigned(ANode) then
    exit;

  // Load our persistent properties from ANode
  FHandleColor      := ANode.ReadInteger('HandleColor');
  FHandleEdgeColor  := ANode.ReadInteger('HandleEdgeColor');
  FHotZoneScrolling := TdtpHZScrollingType(ANode.ReadInteger('HotzoneScrolling'));
  FQuality          := TdtpStretchFilter(ANode.ReadInteger('StretchFilter'));
  FReadOnly         := ANode.ReadBool('ReadOnly');
  FScreenDpm        := ANode.ReadFloat('ScreenDpm', cMonitorDpm);

  FStoreThumbnails  := ANode.ReadBool('StoreThumbnails', True);
  FShowMargins      := ANode.ReadBool('ShowMargins');
  FSnapToGrid       := ANode.ReadBool('SnapToGrid');
  FStepAngle        := ANode.ReadFloat('StepAngle');
  FViewStyle        := TdtpViewStyleType(ANode.ReadInteger('ViewStyle'));

  FDefaultPageWidth    := ANode.ReadFloat('DefaultPageWidth',    cDefaultPageWidth);
  FDefaultPageHeight   := ANode.ReadFloat('DefaultPageHeight',   cDefaultPageHeight);
  FDefaultMarginLeft   := ANode.ReadFloat('DefaultMarginLeft',   cDefaultMarginLeft);
  FDefaultMarginTop    := ANode.ReadFloat('DefaultMarginTop',    cDefaultMarginTop);
  FDefaultMarginRight  := ANode.ReadFloat('DefaultMarginRight',  cDefaultMarginRight);
  FDefaultMarginBottom := ANode.ReadFloat('DefaultMarginBottom', cDefaultMarginBottom);
  FDefaultGridSize     := ANode.ReadFloat('DefaultGridSize',     cDefaultGridSize);
  FDefaultGridColor    := ANode.ReadColor('DefaultGridColor',    cDefaultGridColor);
  FDefaultPageColor    := ANode.ReadColor('DefaultPageColor',    cDefaultPageColor);

  FFontEmbedding := ANode.ReadBool('FontEmbedding');

  // backwards compat
  ChildNode := ANode.NodeByName('DefaultBgrImage');
  if assigned(ChildNode) then
  begin
    if assigned(ChildNode.NodeByName('SourceSize')) then
    begin
      // Old method
      BM := TdtpBitmap.Create;
      try
        XmlReadBitmap32(ANode, 'DefaultBgrImage', BM);
        DefaultBackgroundImage.Bitmap := BM;
      finally
        BM.Free;
      end;
    end else
    begin
      // New method
      FDefaultBackgroundImage.LoadFromXml(ChildNode);
    end;
  end;

  FDefaultBackgroundTiled := ANode.ReadBool('DefaultBgrTiled');
  FThumbnailWidth  := ANode.ReadInteger('ThumbnailWidth',    cDefaultThumbnailWidth);
  FThumbnailHeight := ANode.ReadInteger('ThumbnailHeight',   cDefaultThumbnailHeight);

  FDocumentCreatedWithVersion := ANode.ReadString('CreatedWithVersion', GetVersion);  // added by J.F. Feb 2011
  FDocumentModifiedWithVersion := ANode.ReadString('ModifiedWithVersion', GetVersion);  // added by J.F. Feb 2011

  FUseDocumentBoard := ANode.ReadBool('UseDocumentBoard', False);  // added by J.F. Feb 2011

  // Additional info from the user
  if assigned(FOnLoadAdditionalInfo) then
    FOnLoadAdditionalInfo(Self, ANode);

  // Redraw
  Invalidate;
end;

procedure TdtpDocument.LoadPageFromXml(APageIndex: integer);
var
  Page: TdtpPage;
  M: TsdFastMemStream;
  Xml: TNativeXmlOld;
begin
  glResourceLockEnter;
  FIsLoading := True;
  try
    if not assigned(Archive) then
      exit;
    Page := Pages[APageIndex];
    if not assigned(Page) then
      exit;

    Page.IsLoaded := True;
    M := TsdFastMemStream.Create;
    SetWindowsCursor(crAppStart);
    try
      Archive.StreamRead(UTF8String(Format(cPageTemplate, [APageIndex + 1])), M);
      if M.Size > 0 then
      begin
        Xml := CreateXmlForDtp('');
        try
          // Load XML from stream
          Xml.LoadFromStream(M);
{$ifdef useTestData}
          Xml.SaveToFile('testdata.xml');
{$endif}
          Page.LoadFromXml(Xml.Root);
        finally
          Xml.Free;
        end;
        Page.Regenerate;
      end;
    finally
      M.Free;
      SetWindowsCursor(Cursor);
    end;
  finally
    FIsLoading := False;
    glResourceLockLeave;
  end;
end;

procedure TdtpDocument.LocateFilename(Sender: TObject; var AName: string);
begin
  // we lost the original image, ask the user to find it
  if assigned(FOnLocateFilename) then
    FOnLocateFilename(Sender, AName)
  else
    DefaultLocateFilename(AName);
end;

procedure TdtpDocument.MoveBack;
var
  i: integer;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  for i := 1 to ShapeCount - 1 do
    if (not Shapes[i - 1].Selected) and Shapes[i].Selected then
      ShapeExchange(i - 1, i);
end;

procedure TdtpDocument.MoveFront;
var
  i: integer;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  for i := ShapeCount - 2 downto 0 do
    if (not Shapes[i + 1].Selected) and Shapes[i].Selected then
      ShapeExchange(i + 1, i);
end;

procedure TdtpDocument.MoveToBackground;
var
  i, BackPos: integer;
  Shape: TdtpShape;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BackPos := 0;
  for i := 0 to ShapeCount - 1 do
    if Shapes[i].Selected then
    begin
      Shape := ShapeExtract(Shapes[i]);
      ShapeInsert(BackPos, Shape);
      inc(BackPos);
    end;
end;

procedure TdtpDocument.MoveToForeground;
var
  i, FrontPos: integer;
  Shape: TdtpShape;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  FrontPos := ShapeCount - 1;
  for i := ShapeCount - 1 downto 0 do
    if Shapes[i].Selected then
    begin
      Shape := ShapeExtract(Shapes[i]);
      ShapeInsert(FrontPos, Shape);
      dec(FrontPos);
    end;
end;

procedure TdtpDocument.New;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  Clear;
  DisableUndo;
  try
    PageAdd(nil);
    ZoomWidth;
  finally
    EnableUndo;
  end;
  FModified := False;
  DoPageChanged(nil);
end;

procedure TdtpDocument.NextUndoNoRepeatedPropertyChange;
begin
  FNoRepeatedPropertyChange := True;
end;

function TdtpDocument.PageAdd(APage: TdtpPage): integer;
begin
  Result := -1;
  // Create a default page if APage = nil
  if not assigned(APage) then
  begin
    APage := TdtpPage.Create;
    APage.PageWidth  := DefaultPageWidth;
    APage.PageHeight := DefaultPageHeight;
  end;
  // Add the page
  if assigned(FPages) and assigned(APage) then
  begin
    Result := FPages.Add(APage);
    APage.Document := Self;
    if not assigned(CurrentPage) then
      // Make this the current page
      CurrentPage := APage;
    DoShapeChanged(APage);
    DoPageChanged(APage);
  end;
end;

procedure TdtpDocument.PageCopy(OldIndex, NewIndex: integer);
var
  Page: TdtpPage;
begin
  // Create copy of page
  Page := nil;
  if assigned(Pages[OldIndex]) then
    Page := TdtpPage(Pages[OldIndex].CreateCopy);
  if not assigned(Page) then
    exit;

  // Check new position
  if NewIndex < 0 then
    NewIndex := 0;
  if NewIndex >= OldIndex then
    inc(NewIndex);
  if NewIndex > PageCount then
    NewIndex := PageCount;

  // ..And insert it in the new position
  PageInsert(NewIndex, Page);
end;

procedure TdtpDocument.PageDelete(Index: integer);
// Delete a page
var
  i: integer;
  Page: TdtpPage;
begin
  Page := Pages[Index];
  if not assigned(Page) then
    exit;

  glResourceLockEnter;
  try
    // Delete page xml stream and rename remaining pages. The page template name
    // for i is i+1! (or: page 0, first, is Page0001.xml)
    Archive.StreamDelete(UTF8String(Format(cPageTemplate, [Index + 1])));
    Archive.StreamDelete(UTF8String(Format(cThumbTemplate, [Index + 1])));
    for i := Index to PageCount - 1 do
    begin
      Archive.StreamRename(UTF8String(Format(cPageTemplate, [i + 2])), UTF8String(Format(cPageTemplate, [i + 1])));
      Archive.StreamRename(UTF8String(Format(cThumbTemplate, [i + 2])), UTF8String(Format(cThumbTemplate, [i + 1])));
    end;
  finally
    glResourceLockLeave;
  end;

  // Clear the page and free the object
  Page.ShapeClear;
  DoShapeDestroy(Page);
  // Delete from page list
  FPages.Delete(Index);

  Modified := True;

  // Call the OnPageChanged for following pages in order to get new thumbnail
  // Make sure it is called even if PageIndex <= Index
  for i := Index to PageCount - 1 do
    DoPageChanged(Pages[i]);
  // New current page
  if (CurrentPageIndex > Index) or (CurrentPageIndex >= PageCount) then
    CurrentPageIndex := Max(0, CurrentPageIndex - 1);
  Invalidate;
end;

function TdtpDocument.PageExtract(Index: integer): TdtpPage;
// Extract a page
var
  i: integer;
begin
  Result := nil;
  if not assigned(Pages[Index]) then
    exit;

  glResourceLockEnter;
  try
    // Load the page
    Pages[Index].LoadPageAsNeeded;
    // Make sure to rename the remaining pages first and delete the one at index
    Archive.StreamDelete(UTF8String(Format(cPageTemplate, [Index + 1])));
    Archive.StreamDelete(UTF8String(Format(cThumbTemplate, [Index + 1])));
    for i := Index + 1 to PageCount - 1 do
    begin
      Archive.StreamRename(
        UTF8String(Format(cPageTemplate, [i + 1])),
        UTF8String(Format(cPageTemplate, [i    ])));
      Archive.StreamRename(
        UTF8String(Format(cThumbTemplate, [i + 1])),
        UTF8String(Format(cThumbTemplate, [i    ])));
    end;
  finally
    glResourceLockLeave;
  end;
  // Extract the page
  Result := TdtpPage(FPages.Extract(Pages[Index]));

  Modified := True;

  // Call the OnPageChanged for following pages in order to get new thumbnail
  DoPageChanged(Pages[Index]);//Make sure it is called even if PageIndex <= Index
  for i := Index + 1 to PageCount - 1 do
    DoPageChanged(Pages[i]);
  // New current page
  if (CurrentPageIndex > Index) or (CurrentPageIndex >= PageCount) then
    CurrentPageIndex := Max(0, CurrentPageIndex - 1);
  Invalidate;
end;

function TdtpDocument.PageIndexOf(APage: TdtpShape): integer;
begin
  Result := -1;
  if assigned(FPages) then
    Result := FPages.IndexOf(APage);
end;

procedure TdtpDocument.PageInsert(Index: integer; APage: TdtpPage);
var
  i: integer;
begin
  // Create a default page if APage = nil
  if not assigned(APage) then
    APage := TdtpPage.Create;
  if assigned(FPages) and assigned(APage) then
  begin
    if (Index < 0) or (Index > PageCount) then
      raise Exception.Create(sdeCannotInsertPageAtPos);
    glResourceLockEnter;
    try
      for i := PageCount - 1 downto Index do
      begin
        Archive.StreamRename(
          UTF8String(Format(cPageTemplate, [i + 1])),
          UTF8String(Format(cPageTemplate, [i + 2])));
        Archive.StreamRename(
          UTF8String(Format(cThumbTemplate, [i + 1])),
          UTF8String(Format(cThumbTemplate, [i + 2])));
      end;
    finally
      glResourceLockLeave;
    end;
    CurrentPageIndex := -1;
    FPages.Insert(Index, APage);
    APage.Document := Self;
    // Make this the current page
    CurrentPageIndex := Index;
    // Signal app that these pages' thumbnails changed
    for i := Index to PageCount - 1 do
      DoPageChanged(Pages[i]);
  end;
end;

procedure TdtpDocument.PageMove(OldIndex, NewIndex: integer);
var
  Page: TdtpPage;
begin
  if OldIndex = NewIndex then
    exit;

  // Now extract the page
  Page := PageExtract(OldIndex);
  if not assigned(Page) then
    exit;

  // Check new position
  if NewIndex < 0 then NewIndex := 0;
  if NewIndex > PageCount then NewIndex := PageCount;

  // ..And insert it in the new position
  PageInsert(NewIndex, Page);
end;

procedure TdtpDocument.Paint;
// This procedure is called by Windows whenever the control needs repainting.
// We can paint on the Canvas of this customcontrol (which is also an exposed
// property)
begin
  // When printing or loading, avoid screen paint.
  if (IsPrinting or IsLoading) then
    exit;

  // Paint the current page (it will call paintbackground at the right time)
  PaintCurrentPage(Canvas);
  // Paint the handles
  PaintHandles(Canvas);
end;

procedure TdtpDocument.PaintCurrentPage(Canvas: TCanvas);
var
  Dib: TdtpBitmap;
  DibRect: TdtpRect;
  DeviceContext: TDeviceContext;
begin
  if IsRectEmpty(Canvas.ClipRect) then
    exit;

  // Avoid painting when we do not have a page.
  if not assigned(CurrentPage) then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(Canvas.ClipRect);
    exit;
  end;

  // Setup device context
  FillChar(DeviceContext, SizeOf(DeviceContext), 0);
  DeviceContext.DeviceType := dtScreen;
  DeviceContext.ActualDpm := ScreenDpm;
  DeviceContext.CacheDpm := ScreenDpm;
  DeviceContext.Quality := Quality;
  DeviceContext.Background := SetAlpha(dtpColor(CurrentPage.PageColor), 0);

  // create bitmap
  Dib := TdtpBitmap.Create;
  try
    Dib.Width := Canvas.ClipRect.Right - Canvas.ClipRect.Left;
    Dib.Height := Canvas.ClipRect.Bottom - Canvas.ClipRect.Top;

    Dib.Clear(dtpColor(Color));

    DibRect.TopLeft     := ScreenToDoc(Canvas.ClipRect.TopLeft);
    DibRect.BottomRight := ScreenToDoc(Canvas.ClipRect.BottomRight);

    // render the current page to the bitmap
    TShapeAccess(CurrentPage).RenderShape(Dib, DibRect, DeviceContext);

    // Blit bitmap to the screen
    Dib.DrawTo(Canvas.Handle, Canvas.ClipRect.Left, Canvas.ClipRect.Top);
    
  finally
    Dib.Free;
  end;

  // At the end here, if we had an hourglass, lets undo that
  if Windows.GetCursor = Screen.Cursors[crAppStart] then
    SetWindowsCursor(Cursor);
end;

procedure TdtpDocument.PaintDragBorders(ADelta: TdtpPoint);
var
  i: integer;
  Trans: TdtpMatrix;
begin
  // When we're about to draw, evaluate if the [Alt] key is down (for StepAngle)
  if not FDragBordersDrawn then
    FAltKeyDown := (GetKeyState(VK_MENU) and $8000) > 0;

  // Toggle whether the borders are drawn or not
  FDragBordersDrawn := not FDragBordersDrawn;

  for i := 0 to ShapeCount - 1 do
    if Shapes[i].Selected then
    begin
      // Calculate Trans, the drag transformation
      TShapeAccess(Shapes[i]).CalculateBounds(ADelta, FAltKeyDown, FHitInfo, Trans);
      TShapeAccess(Shapes[i]).SetDragTrans(Trans);
      TShapeAccess(Shapes[i]).PaintDragBorder(Canvas);
    end;
end;

procedure TdtpDocument.PaintHandles(Canvas: TCanvas);
var
  i: integer;
begin
  if ReadOnly then
    exit;
  // Selected shapes
  for i := 0 to ShapeCount - 1 do
    if Shapes[i].Selected and Shapes[i].AllowSelect then
      TShapeAccess(Shapes[i]).PaintSelectionBorder(Canvas);
  // Edited shapes inside groups
  if (State = vsEdit) and assigned(EditedShape) and not EditedShape.Selected then
    TShapeAccess(EditedShape).PaintSelectionBorder(Canvas);
end;

procedure TdtpDocument.PaintInsertBorder(ADelta: TdtpPoint);
var
  R: TRect;
  Shape: TShapeAccess;
  Scale: single;
begin
  // Drag rectangle in screen coordinates
  R := GetScreenRect(FDragPosDoc, ADelta);

  // Check if we have an aspect ratio and adjust R accordingly
  if assigned(FInsertShape) then
  begin
    Shape := TShapeAccess(FInsertShape);
    if Shape.PreserveAspect then begin
      try
        Scale := Min(abs((R.Right - R.Left) / Shape.DocWidth), abs((R.Bottom - R.Top) / Shape.DocHeight));
        R.Right  := R.Left + dtpShape.sign(R.Right - R.Left) * round(Scale * Shape.DocWidth);
        R.Bottom := R.Top  + dtpShape.sign(R.Bottom - R.Top) * round(Scale * Shape.DocHeight);
      except
      end;
    end;
    // Let the shape paint the border so we can override
    Shape.PaintInsertBorder(Canvas, R, HandleColor XOR clBlack);
  end;
end;

procedure TdtpDocument.PaintSelectBorder(ADelta: TdtpPoint);
var
  R: TRect;
begin
  R := GetScreenRect(FDragPosDoc, ADelta);
  Canvas.Pen.Color := HandleColor XOR clBlack;
  Canvas.Pen.Style := psDot;
  Canvas.Pen.Mode  := pmXOR;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(R);
end;

procedure TdtpDocument.PaintMouseDragZoomBorder(NewFinalPos: TPoint); //  added by J.F. June 2011
var
  R:TRect;
begin
  R.TopLeft     := FMouseDragZoomOrgPos;
  R.BottomRight := Point(NewFinalPos.X, NewFinalPos.Y);
  Canvas.Pen.Color := HandleColor XOR clBlack;
  Canvas.Pen.Style := psDot;
  Canvas.Pen.Mode  := pmXOR;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(R);
end;

procedure TdtpDocument.Paste;
// Paste from the clipboard to the document
var
  i: integer;
  Count: integer;
  S: TdtpShape;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginUndo;
  try
    if UseClipboard then
      Count := SelectionFromText(Clipboard.AsText)
    else
      Count := SelectionFromText(FInternalClipboard);

    // Did we actually paste something?
    if Count > 0 then
    begin
      // Do the paste increment
      if FClipboardPage = CurrentPage then
        for i := 0 to SelectionCount - 1 do
        begin
          S := Selection[i];
          S.Left := S.Left + S.PasteOffset.X;
          S.Top  := S.Top  + S.PasteOffset.Y;
        end;

      // Set clipboard page to this page
      FClipboardPage := CurrentPage;

      // We're done pasting.. now copy them again, so a next paste will put
      // the shapes with a new offset
      Copy;
    end;
  finally
    EndUndo;
  end;
end;

function TdtpDocument.PerformCommand(ACommand: TdtpCommand): boolean;
// Perform a command on this document
var
  i: integer;
begin
  Result := False;
  if ACommand.Ref = 0 then
  begin
    // Any of the commands that we do ourself
  end else
  begin
    // Delegate to shapes
    for i := 0 to ShapeCount - 1 do
    begin
      Result := Shapes[i].PerformCommand(ACommand);
      if Result then
        exit;
    end;
    // Delegate to pages
    for i := 0 to PageCount - 1 do
    begin
      Result := Pages[i].PerformCommand(ACommand);
      if Result then
        exit;
    end;
    // Future extensions?
    // Arriving here means the command did not execute
    ShowMessage(sdeUnableToExecuteUndo);
  end;
end;

procedure TdtpDocument.Print;
// Print all pages in the document
begin
  Print(0, PageCount);
end;

procedure TdtpDocument.Print(AStart, ACount: integer);
// Print pages from AStart to AStart + ACount - 1
var
  i: integer;
  Sel: array of integer;
begin
  SetLength(Sel, ACount);
  for i := 0 to ACount - 1 do
    Sel[i] := AStart + i;
  PrintSelection(Sel, ACount);
end;

procedure TdtpDocument.Print(APage: integer);
// Print just one page
begin
  Print(APage, 1);
end;

procedure TdtpDocument.PrintSelection(const ASelection: array of integer; ACount: integer);
// Print all pages in ARange
var
  i: integer;
  Rotation: integer;
  Clip: TRect;
  ClipWidth, ClipHeight: integer;
  Page: TdtpPage;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  // Use selected printer
  {$IFDEF TRIAL}{$I TRIALDTP3.INC}{$ENDIF} // Trial version protection
  // Signal start of printing
  DoProgress(ptPrint, 0, ACount, 0);
  // Start the print document
  Printer.BeginDoc;

  // Loop through pages
  for i := 0 to ACount - 1 do
  begin
    DoProgress(ptPrint, i + 1, ACount, i / ACount);
    Page := Pages[ASelection[i]];
    if not assigned(Page) then
      continue;

    // Determine rotation
    Rotation := 0;
    // Get printer device rectangle
    Clip := Rect(0, 0,
      GetDeviceCaps(Printer.Canvas.Handle, PHYSICALWIDTH),
      GetDeviceCaps(Printer.Canvas.Handle, PHYSICALHEIGHT) );
    OffsetRect(Clip,
      - GetDeviceCaps(Printer.Canvas.Handle, PHYSICALOFFSETX),
      - GetDeviceCaps(Printer.Canvas.Handle, PHYSICALOFFSETY));

    ClipWidth  := Clip.Right - Clip.Left;
    ClipHeight := Clip.Bottom - Clip.Top;

    // Compare portrait scale and landscape scale, choose best fit
    if Min(ClipWidth / Page.DocWidth, ClipHeight / Page.DocHeight) <
       Min(ClipHeight / Page.DocWidth, ClipWidth / Page.DocHeight) then
      Rotation := 1;

    // Use the page's print method, print in PrinterDpm resolution
    Page.Print(Printer.Canvas, Clip, PrinterDpm, Rotation, False, False);

    // New page?
    if i < ACount - 1 then
    begin
      Printer.NewPage;
      // Signal that we're ready for next page
      DoProgress(ptPrint, i + 1, ACount, (i + 1) / ACount);
    end;
  end;
  // Finish the printer document
  Printer.EndDoc;
  // Signal that we're ready with printing
  DoProgress(ptPrint, ACount, ACount, 100);
end;

procedure TdtpDocument.Redo;
// Redo the most recently undone changes
var
  Cmd: TdtpCommand;
  LastOne: boolean;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  LastOne := False;
  if not UndoEnabled then
    exit;
  FIsRedoing := True;
  try
    BeginUndo;
    // Execute commands that are in redo's IncludePrev chain
    repeat
      if RedoCount = 0 then
        break;
      Cmd := TdtpCommand(FRedos.Extract(FRedos[RedoCount - 1]));
      if not assigned(Cmd) then
        exit;
      PerformCommand(Cmd);
      LastOne := not Cmd.IncludePrev;
      FreeAndNil(Cmd);
    until LastOne;
  finally
    EndUndo;
    FIsRedoing := False;
  end;
end;

procedure TdtpDocument.RedoAdd(ACmd: TdtpCommand);
begin
  if not RedoEnabled then
  begin
    FreeAndNil(ACmd);
    exit;
  end;
  if assigned(FRedos) and assigned(ACmd) then
  begin

    // Are we in update cycle
    if FUndoNestCount > 0 then
    begin
      if FUndoNestAdditions then
        // 2nd, 3rd, etc will include up till 1st
        ACmd.IncludePrev := True;
      FUndoNestAdditions := True;
    end;

    // Add to the list
    FRedos.Add(ACmd);
  end;
end;

function TdtpDocument.RoundDecimal(Value: Extended; Precision: Integer): Extended; // added by J.F. June 2011
// RoundD(123.456, 0) = 123.00
// RoundD(123.456, 2) = 123.46
// RoundD(123456, -3) = 123000
var
  n: Extended;
begin
  n := IntPower(10, Precision);
  Value := Value * n;
  Result := (Int(Value) + Int(Frac(Value) * 2)) / n;
end;

procedure TdtpDocument.RulerOnEvent(Sender: TObject;var AMessage: TMessage);
// added by J.F. June 2011
var
  APoint: TPoint;
  R: TdtpRsRuler;
  BorderOffset: integer;
  NewGuide: TdtpGuide;
  TestRect: TRect;
begin
  if (GuidesVisible) and (Sender is TdtpRsRuler) and Assigned(CurrentPage) then  // changed by J.F. July 2011
  begin
    R := TdtpRsRuler(Sender);
    try
      BorderOffset:= integer(BorderStyle = bsSingle) * 2;

      APoint:= Point(TWMMouse(AMessage).XPos - BorderOffset,TWMMouse(AMessage).YPos - BorderOffset);

      if R.Direction = rdTop then // horizontal guide
        dec(APoint.Y, R.Height)
      else
        dec(APoint.X, R.Width);
      case AMessage.Msg of
      WM_LBUTTONDOWN:
        begin
               // the following  line is needed in case a text shape is selected
               // without them the line drawing misfires ???? Need to look into this ???
          Invalidate;

          NewGuide:= TPageAccess(CurrentPage).AddGuide();
          if Assigned(NewGuide) then
          begin
            if R.Direction = rdTop then  // horizontal guide
            begin
              NewGuide.EndPoint.X:= CurrentPage.PageWidth;
              SetWindowsCursor(crDtpHorizGuide);
            end
            else
            begin
              NewGuide.EndPoint.Y:= CurrentPage.PageHeight;
              SetWindowsCursor(crDtpVertGuide);
            end;
            TPageAccess(CurrentPage).MoveSelectedGuide(CurrentPage.ScreenToShape(APoint));
            FHintGuide:= CurrentPage.SelectedGuide; //  added by J.F. June 2011
          end;
        end;
      WM_LBUTTONUP:
        begin
          FGuideHint.CancelHint;
          FHintGuide:= nil;
          TPageAccess(CurrentPage).FinishGuideMove(CurrentPage.ScreenToShape(APoint));
          FViewerFunction:= vfNone;
        end;
      WM_MOUSEMOVE:
        begin
          TestRect:= ClientRect;
          if BorderOffset <> 0 then
            InflateRect(TestRect,BorderOffset,BorderOffset);

          if not PtInRect( R.ClientRect, R.ScreenToClient(Mouse.CursorPos)) then
          if not PtInRect(TestRect, ScreenToClient(Mouse.CursorPos)) then
          begin
            FGuideHint.CancelHint;  //  added by J.F. July 2011
            SetWindowsCursor(crNoDrop);
            exit;
          end;

          TPageAccess(CurrentPage).MoveSelectedGuide(CurrentPage.ScreenToShape(APoint));

            // Set hint data
          //FHint.Hint:= FormatGuideHint(FHintGuide.Position);

          //FHint.HintPos:= APoint;
          FViewerFunction:= vfGuideMoving;
          //FHint.TimerHintDisplay(nil);
          if FHintGuide.IsVertical then
            FGuideHint.HintOffset:= hoVertical
          else
            FGuideHint.HintOffset:= hoHorizontal;
          FGuideHint.DisplayHint(APoint,FormatHint(FHintGuide.Position));

          if BorderOffset <> 0 then
            inc(BorderOffset);

          if assigned(FRulerTop) then
             FRulerTop.HairLinePos := APoint.X + BorderOffset;  // changed by J.F. june 2011
          if assigned(FRulerLeft) then
             FRulerLeft.HairlinePos := APoint.Y + BorderOffset; // changed by J.F. june 2011

          if Assigned(OnMouseMove) then
            OnMouseMove(Sender, KeysToShiftState(TWMMouse(AMessage).Keys), APoint.X, APoint.Y);

        end;
      end;
    except
      SetWindowsCursor(Cursor); // crDefault
    end;
  end;
end;

function TdtpDocument.RulerToDoc(const Value:single):single; //  added by J.F. June 2011
begin
  case FRulerUnits of
      ruInch: Result:= Value * cMMToInch;

      ruCenti: Result:= Value * cMMToCM;

      ruPixel: Result:= Value / ScreenDPI * cMMToInch;

  else
      Result:= Value;
  end;
  Result:= RoundDecimal(Result,3);
end;

function TdtpDocument.RulerToDoc(const Value:TdtpPoint): TdtpPoint;  // added by J.F. June 2011
begin
  Result.X:= RulerToDoc(Value.X);
  Result.Y:= RulerToDoc(Value.Y);
end;

procedure TdtpDocument.SaveChanges;
// Save all changed pages to the current archive, as well as our core data
var
  i: integer;
  M: TsdFastMemStream;
  Xml: TNativeXmlOld;
  Thumbnail: TBitmap;
  PageName: string;
begin
  glResourceLockEnter;
  try
    // Check if archive is there
    if not assigned(Archive) then
      raise Exception.Create(sdeArchiveDoesNotExist);
    // Save our own header info
    SaveHeader;
    // Save the pages
    for i := 0 to PageCount - 1 do
    begin
      PageName := Format(cPageTemplate, [i + 1]);
      // Only save pages if they're modified or non-existent in the archive
      if Pages[i].Modified or not Archive.StreamExists(UTF8String(PageName)) or
        FUpgradeFromPreviousVersion then
      begin

        // Store page
        Xml := CreateXmlForDtp('Page');
        try
          Xml.Root.AttributeAdd('Index', IntToStr(i + 1));
          Pages[i].SaveToXml(Xml.Root);
          M := TsdFastMemStream.Create;
          DoProgress(ptSave, i + 1, PageCount, (i + 0.2) / PageCount);
          try
            Xml.SaveToStream(M);

            // for test only
            // Xml.SaveToFile('page.xml');

            DoProgress(ptSave, i + 1, PageCount, (i + 0.6) / PageCount);
            Archive.StreamWrite(UTF8String(PageName), M);
            DoProgress(ptSave, i + 1, PageCount, (i + 0.7) / PageCount);
          finally
            M.Free;
          end;
        finally
          Xml.Free;
        end;

        // Store thumbnail
        if FStoreThumbnails then
        begin
          Thumbnail := Pages[i].Thumbnail;
          PageName := Format(cThumbTemplate, [i + 1]);
          if assigned(Thumbnail) then
          begin
            M := TsdFastMemStream.Create;
            try
              Thumbnail.SaveToStream(M);
              Archive.StreamWrite(UTF8String(PageName), M);
            finally
              M.Free;
            end;
          end else
          begin
            Archive.StreamDelete(UTF8String(PageName));
          end;
        end;
      end;
      // Since we might have created a thumbnail, resources were loaded, which
      // should be dropped at this point
      glCheckAndDropResources;
    end;


    // progress
    DoProgress(ptSave, PageCount, PageCount, 1);

    // Reset "Modified"
    Modified := False;

    // Remove "undo"
    if not UndoPastSave then
      UndoClear;

  finally
    glResourceLockLeave;
  end;
end;

procedure TdtpDocument.SaveHeader;
var
  Xml: TNativeXmlOld;
  M: TMemoryStream;
begin
  glResourceLockEnter;
  try
    if not assigned(Archive) then
      exit;

    // Save index
    Xml := CreateXmlForDtp('Document');
    try
      SaveToXml(Xml.Root);
      M := TMemoryStream.Create;
      try
        Xml.SaveToStream(M);
        Archive.StreamWrite(cIndexName, M);
      finally
        M.Free;
      end;
    finally
      Xml.Free;
    end;

    // Save Fonts
    if FFontEmbedding then
    begin
      M := TMemoryStream.Create;
      try
        FFontManager.SaveToStream(M);
        Archive.StreamWrite(cFontEmbedName, M);
      finally
        M.Free;
      end;
    end;

  finally
    glResourceLockLeave;
  end;
end;

procedure TdtpDocument.SaveToFile(const AFilename: string);
// Save the complete document to AFilename. If we already have the archive
// open then only the changed pages will be saved
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginWorking(crHourglass);
  try
    glResourceLockEnter;
    try
      SaveChanges;
      Archive.SaveToFile(AFileName);
    finally
      glResourceLockLeave;
    end;
  finally
    EndWorking;
  end;
end;

procedure TdtpDocument.SaveToStream(S: TStream);
// Save the complete document to the stream S. We will always save everything
// with this method
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  BeginWorking(crHourglass);
  try
    glResourceLockEnter;
    try
      SaveChanges;
      Archive.SaveToStream(S);
    finally
      glResourceLockLeave;
    end;
  finally
    EndWorking;
  end;
end;

procedure TdtpDocument.SaveToXml(ANode: TXmlNodeOld);
begin
  if not assigned(ANode) then
    exit;

  // Store our persistent properties in ANode
  ANode.WriteHex('HandleColor', FHandleColor, 8);
  ANode.WriteHex('HandleEdgeColor', FHandleEdgeColor, 8);
  ANode.WriteInteger('HotzoneScrolling', integer(FHotzoneScrolling));
  ANode.WriteInteger('StretchFilter', integer(FQuality));
  ANode.WriteBool('ReadOnly', FReadOnly);
  ANode.WriteFloat('ScreenDpm', FScreenDpm);
  ANode.WriteBool('StoreThumbnails', FStoreThumbnails, True); // changed by EL
  ANode.WriteBool('ShowMargins', FShowMargins);
  ANode.WriteBool('SnapToGrid', FSnapToGrid);
  ANode.WriteFloat('StepAngle', FStepAngle);

  ANode.WriteInteger('ViewStyle', integer(FViewStyle));

  ANode.WriteFloat('DefaultPageWidth', FDefaultPageWidth);
  ANode.WriteFloat('DefaultPageHeight', FDefaultPageHeight);
  ANode.WriteFloat('DefaultMarginLeft', FDefaultMarginLeft);
  ANode.WriteFloat('DefaultMarginTop', FDefaultMarginTop);
  ANode.WriteFloat('DefaultMarginRight', FDefaultMarginRight);
  ANode.WriteFloat('DefaultMarginBottom', FDefaultMarginBottom);
  ANode.WriteFloat('DefaultGridSize', FDefaultGridSize);
  ANode.WriteColor('DefaultGridColor', FDefaultGridColor);
  ANode.WriteColor('DefaultPageColor', FDefaultPageColor);
  if assigned(FDefaultBackgroundImage.Bitmap) then
    FDefaultBackgroundImage.SaveToXml(ANode.NodeNew('DefaultBgrImage'));
  ANode.WriteBool('DefaultBgrTiled', FDefaultBackgroundTiled);
  ANode.WriteInteger('ThumbnailWidth', FThumbnailWidth);
  ANode.WriteInteger('ThumbnailHeight', FThumbnailHeight);

  ANode.WriteBool('FontEmbedding', FFontEmbedding);

  ANode.WriteString('CreatedWithVersion', FDocumentCreatedWithVersion);  // added by J.F. Feb 2011
  ANode.WriteString('ModifiedWithVersion', FDocumentModifiedWithVersion);  // added by J.F. Feb 2011

  ANode.WriteBool('UseDocumentBoard', FUseDocumentBoard);  // added by J.F. Feb 2011

  // Additional info from the user
  if assigned(FOnSaveAdditionalInfo) then
    FOnSaveAdditionalInfo(Self, ANode);
end;

function TdtpDocument.ScreenToDoc(APoint: TPoint): TdtpPoint;
begin
  Result.X := FWindowLeft + (APoint.X / FScreenDpm);
  Result.Y := FWindowTop  + (APoint.Y / FScreenDpm);
end;

function TdtpDocument.SelectionFromText(const AText: string): integer;
var
  i: integer;
  Xml: TNativeXmlOld;
  Child: TXmlNodeOld;
  Shapes: TList;
  ShapeClass: TdtpShapeClass;
  Shape: TdtpShape;
begin
  Result := 0;
  Xml := CreateXmlForDtp('');
  try
    try
      Xml.ReadFromString(UTF8String(AText));
    except
      // An empty text file most probably - silently exit
      exit;
    end;
    // Check for valid root element and wheter we have a selection
    if (Xml.Root.Name <> 'Selection') or
       (Xml.Root.NodeCount = 0) then
      exit;

    // Now insert this selection into the document
    Shapes := TList.Create;
    try
      // Clear old selection
      ClearSelection;

      // Paste the shapes
      Xml.Root.NodesByName('shape', Shapes);
      for i := 0 to Shapes.Count - 1 do
      begin
        // Recreate each shape in the selection
        Child := Shapes[i];
        ShapeClass := RetrieveShapeClass(Child.ReadString('ClassName'));
        Shape := ShapeClass.Create;
        ShapeAdd(Shape);
        Shape.AsBinaryString := Child.BinaryString;
        // This is neccesary: some shapes must clear archive names to avoid
        // referencing the same file (see e.g. TdtpCropBitmap.DoAfterPaste)
        TShapeAccess(Shape).DoAfterPaste;
        Shape.Regenerate;
        // ..and select them
        Shape.Selected := True;
        inc(Result);
      end;
    finally
      Shapes.Free;
    end;
  finally
    Xml.Free;
  end;
end;

function TdtpDocument.SelectionToText: string;
var
  i: integer;
  Xml: TNativeXmlOld;
  Child: TXmlNodeOld;
begin
  Result := '';
  if SelectionCount = 0 then
    exit;
  // Create selection as XML
  Xml := CreateXmlForDtp('Selection');
  try
    Xml.XmlFormat := xfoReadable;
    // Save all selected shapes
    for i := 0 to SelectionCount - 1 do
    begin
      Child := Xml.Root.NodeNew('shape');
      Child.WriteString('ClassName', UTF8String(Selection[i].ClassName));
      Child.BinaryString := Selection[i].AsBinaryString;
    end;

    // Copy to the result string
    Result := string(Xml.WriteToString);

  finally
    Xml.Free;
  end;
end;

procedure TdtpDocument.SetAutoPageUpdate(const Value: boolean);
begin
  if FAutoPageUpdate <> Value then
    FAutoPageUpdate := Value;
end;

function TdtpDocument.SetClientRectCursor(ACursor: TCursor): boolean;  // added by J.F. June 2011
begin
  Result:= false;
  if (PtInRect(ClientRect, ScreenToClient(Mouse.CursorPos))) then
  begin
    if (Screen.Cursor <> ACursor) then
      Screen.Cursor:= ACursor;
    Result:= true;
  end;
end;

procedure TdtpDocument.SetCurrentPage(const Value: TdtpPage);
begin
  CurrentPageIndex := PageIndexOf(Value);
end;

procedure TdtpDocument.SetCurrentPageIndex(const Value: integer);
var
  Page: TdtpPage;
begin
  // Make sure the new page is loaded
  Page := Pages[Value];
  if assigned(Page) and not Page.IsLoaded then
    LoadPageFromXml(Value);
  // Call page change for this one - to make sure the accurate thumbnail is
  // shown if there were changes
  DoPageChanged(CurrentPage);
  if FCurrentPageIndex <> Value then
  try
    // added by J.F. Feb 2011 + fix NH
    if assigned(CurrentPage) then
    begin
      // If Performance = dpMemoryOverSpeed, the shape caches will be dropped
      // whenever a page changes and need to be rebuilt when the page is selected
      // again. This saves mem consumption but reduces inter-page responsiveness
      if Performance = dpMemoryOverSpeed then
        CurrentPage.CacheDrop;
      // And remove OnResize
      CurrentPage.OnResize := nil;
    end;
    FCurrentPageIndex := Value;
    if assigned(CurrentPage) then //  changed by J.F. July 2011
          // Assign OnResize
      CurrentPage.OnResize := AdjustSizeToPage;
    AdjustSizeToPage(Self);
    Invalidate;
    FocusedShape := nil;
    DoPageChanged(CurrentPage);
  finally   // added by J.F. Feb 2011

  end;
end;

procedure TdtpDocument.SetDefaultBackgroundTiled(const Value: boolean);
begin
  if FDefaultBackgroundTiled <> Value then
  begin
    FDefaultBackgroundTiled := Value;
    DocumentChanged;
    // All default page's thumbnails might have changed
    UpdateDefaultPageThumbnails;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaultGridColor(const Value: TColor);
begin
  if FDefaultGridColor <> Value then
  begin
    FDefaultGridColor := Value;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaultGridSize(const Value: single);
begin
  if FDefaultGridSize <> Value then
  begin
    FDefaultGridSize := Value;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaultMarginBottom(const Value: single);
begin
  if FDefaultMarginBottom <> Value then
  begin
    FDefaultMarginBottom := Value;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaultMarginLeft(const Value: single);
begin
  if FDefaultMarginLeft <> Value then
  begin
    FDefaultMarginLeft := Value;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaultMarginRight(const Value: single);
begin
  if FDefaultMarginRight <> Value then
  begin
    FDefaultMarginRight := Value;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaultMarginTop(const Value: single);
begin
  if FDefaultMarginTop <> Value then
  begin
    FDefaultMarginTop := Value;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaultPageColor(const Value: TColor);
begin
  if FDefaultPageColor <> Value then
  begin
    FDefaultPageColor := Value;
    UpdateDefaultPageThumbnails;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaultPageHeight(const Value: single);
var
  i: integer;
begin
  if FDefaultPageHeight <> Value then
  begin
    FDefaultPageHeight := Value;
    for i := 0 to PageCount - 1 do
      if Pages[i].IsDefaultPage then
        Pages[i].PageHeight := FDefaultPageHeight;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaultPageWidth(const Value: single);
var
  i: integer;
begin
  if FDefaultPageWidth <> Value then
  begin
    FDefaultPageWidth := Value;
    for i := 0 to PageCount - 1 do
      if Pages[i].IsDefaultPage then
        Pages[i].PageWidth := FDefaultPageWidth;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetDefaults;
// Set the default values for properties
begin
  FAllowKeyInput        := True;
  FArchiveDirect        := False;
  FAutoPageUpdate       := False;
  FAutoWidth            := True;
  FAutoDeleteShape      := True;
  FCurrentPageIndex     := -1;
  FHandleColor          := cDefaultHandleColor;
  FHandleEdgeColor      := cDefaultHandleEdgeColor;
  FHintHidePause        := cDefaultHintHidePause;
  FHintShortPause       := cDefaultHintShortPause;
  FHintPause            := cDefaultHintPause;
  FHitSensitivity       := cDefaultHitSensitivity;
  FHotzoneScrolling     := hzsNoScroll;
  FMode                 := vmEdit;
  FModified             := True;
  FMultiSelectMethod    := msmSimple;
  FPaintEditBorder      := True;
  FPageUpdateInterval   := cDefaultPageUpdateInterval;
  FPrintQuality         := pqLow;
  FQuality              := dtpsfLinear;
  FScrollWithMouseWheel := True;
  FScreenDpm            := cMonitorDpm;

  FShowPageShadow       := True; // added by J.F. Feb 2011
  FPageShadowColor      := clBlack32; // added by J.F. Feb 2011

  FThumbnailHeight      := cDefaultThumbnailHeight;
  FThumbnailWidth       := cDefaultThumbnailWidth;
  FUndoEnabled          := True;
  FUseClipboard         := True;

  FUseDocumentBoard     := False; // added by J.F. Feb 2011

  FZoomWithMouseWheel   := false;  // added by J.F. June 2011
  FZoomWithMouseButton  := true;  //  added by J.F. June 2011
  FZoomWithRectangle    := true;  //  added by J.F. June 2011
  FMouseWheelScrollSpeed := 10; // added by J.F. June 2011

  FViewStyle            := vsPrintLayout;
  FStepAngle            := 0;
  FStoreThumbnails      := True;
  FZoomPercent          := 100;
  FRulerUnits           := ruMilli;
  FHandlePainter        := hpW2K3Handle;

  // Margins
  FShowMargins          := True;
  FDefaultMarginLeft    := cDefaultMarginLeft;
  FDefaultMarginRight   := cDefaultMarginRight;
  FDefaultMarginTop     := cDefaultMarginTop;
  FDefaultMarginBottom  := cDefaultMarginBottom;
  FDefaultPageColor     := cDefaultPageColor;
  FDefaultPageHeight    := cDefaultPageHeight;
  FDefaultPageWidth     := cDefaultPageWidth;

  // Grid
  FDefaultGridColor     := cDefaultGridColor;
  FDefaultGridSize      := cDefaultGridSize;
  FHelperMethod         := hmNone;

  FDocumentCreatedWithVersion  := GetVersion; // added by J.F. Feb 2011
  FDocumentModifiedWithVersion := GetVersion; // added by J.F. Feb 2011

  FGuidesToFront        := False; // added by J.F. Feb 2011
  FGuidesVisible        := True; // added by J.F. Feb 2011
  FGuideColor           := clRed; // added by J.F. Feb 2011
  FGuidesLocked         := false; // added by J.F. June 2011
  FMarginsLocked        := false;  //  added by J.F. July 2011
  FSnapToGuides         := false; // added by J.F. June 2011
  FShowGuideHints    := True; // changed by J.F. July 2011
  FHintPrecision  := ghp2Decimals; // added by J.F. 2011

  FShowMarginHints   := True;  //  added by J.F. July 2011

  FShowShapeHints    := True;  //  added by J.F. July 2011

  FShowPageShadow       := True; // added by J.F. Feb 2011
  FPageShadowColor      := clBlack32; // added by J.F. Feb 2011

  FZoomStep             := cDefaultZoomStep; // added by J.F. June 2011

  FPanWithMouseButton  := true;  // added by J.F. June 2011

  FAutoFocus           := true;  //  added by J.F. June 2011

  FShapeNudgeEnabled   := true;  //  added by J.F. June 2011
  FShapeNudgeDistance  := cDefaultShapeNudgeDistance;  //  added by J.F. June 2011

  // Set defaults based on..
  BuildSmartHitPoints;
end;

procedure TdtpDocument.SetFocusedShape(const Value: TdtpShape);
// Sets the new focused shape to Value
begin
  if FFocusedShape <> Value then
  begin
    FFocusedShape := Value;
    // Call the event
    DoFocusShape(Value);
  end;
end;

procedure TdtpDocument.SetGuideColor(const Value: TColor);
//  Added by J.F. Feb 2011
var
  i: integer;
begin
  if Value <> FGuideColor then
  begin
    FGuideColor := Value;
    for i := 0 to PageCount - 1 do
       Pages[i].SetGuideColor(FGuideColor);
    Invalidate;
  end;
end;

procedure TdtpDocument.SetGuidesToFront(const Value: boolean);
//  Added by J.F. Feb 2011
begin
  if Value <> FGuidesToFront then
  begin
    FGuidesToFront := Value;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetGuidesVisible(const Value: boolean);
//  Added by J.F. Feb 2011
begin
  if Value <> FGuidesVisible then
  begin
    FGuidesVisible := Value;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetHelperMethod(const Value: TdtpHelperMethodType);
begin
  if FHelperMethod <> Value then
  begin
    FHelperMethod := Value;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetHitSensitivity(const Value: single);
begin
  if FHitSensitivity <> Value then
  begin
    FHitSensitivity := Value;
    BuildSmartHitPoints;
  end;
end;

procedure TdtpDocument.SetHotZoneScrolling(const Value: TdtpHZScrollingType);
begin
  if Value <> FHotZoneScrolling then
  begin
    if Value <> hzsNoScroll then
    begin
      if not assigned(FHotzoneTimer) then
      begin
        FHotzoneActive := False;
        FHotzoneTimer := TTimer.Create(nil);
        FHotzoneTimer.OnTimer := TimerHotzoneScrolling;
        FHotzoneTimer.Interval := 50;
        FHotzoneTimer.Enabled := True;
      end;
    end else
    begin
      if assigned(FHotzoneTimer) then
        FreeAndNil(FHotzoneTimer);
    end;
    FHotZoneScrolling := Value;
  end;
end;

procedure TdtpDocument.SetMode(const Value: TdtpViewerModeType);
begin
  if FMode <> Value then
  begin
    // Shapes no longer selected
    ClearSelection;
    // Cancel all ongoing drag/insert/edit
    State := vsNone;
    // Check illegal mode <> ReadOnly combination
    if (Value = vmEdit) and ReadOnly then
      exit;
    FMode := Value;
  end;
end;

procedure TdtpDocument.SetModified(const Value: boolean);
var
  i: integer;
begin
  // Store the moment that the last update was made
  FModifiedTick := GetTickCount;
  if FModified <> Value then
  begin
    FModified := Value;
    // Clear pages too
    if Value = False then
      for i := 0 to PageCount - 1 do
        Pages[i].Modified := False;
    // added by J.F. Feb 2011;
    FDocumentModifiedWithVersion := GetVersion;
  end;
end;

procedure TdtpDocument.SetPageCount(const Value: integer);
// Make sure that the page count matches the value
begin
  if (Value < 0) or (Value > cMaxSetPageCount) then
    raise Exception.Create(sdeInvalidPageCount);
  while PageCount < Value do
    PageAdd(nil);
  while PageCount > Value do
    PageDelete(PageCount - 1);
end;

procedure TdtpDocument.SetPageHeight(const Value: single);
begin
  if assigned(CurrentPage) then
    CurrentPage.DocHeight := Value;
end;

procedure TdtpDocument.SetPageWidth(const Value: single);
begin
  if assigned(CurrentPage) then
    CurrentPage.DocWidth := Value;
end;

procedure TdtpDocument.SetPageShadowColor(const Value: TdtpColor);
// Added by J.F. Feb 2011
begin
  if FPageShadowColor <> Value then
  begin
    FPageShadowColor:= Value;
    DocumentChanged;
    Invalidate;
    // added by J.F. Feb 2011
    UpdateRulers;
  end;
end;

procedure TdtpDocument.SetPaintEditBorder(const Value: boolean);
// added by JF
var i: integer;
begin
  if FPaintEditBorder <> Value then
  begin
    FPaintEditBorder := Value;
    for i := 0 to ShapeCount - 1 do
      if Shapes[i] is TdtpTextBaseShape then
        TdtpTextBaseShape(Shapes[i]).PaintEditBorder := Value;
  end;
end;

procedure TdtpDocument.SetParent(AParent: TWinControl);
begin
  inherited;
  DisableUndo;
  ZoomWidth;
  EnableUndo;
  // We call DoPageChanged here to inform the GUI that
  // there is a page present.
  if assigned(AParent) then
    DoPageChanged(CurrentPage);
end;

procedure TdtpDocument.SetQuality(const Value: TdtpStretchFilter);
begin
  if FQuality <> Value then
  begin
    FQuality := Value;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetReadOnly(const Value: boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    if Value = True then
    begin
      // Shapes no longer selected
      ClearSelection;
      // Switch off all drag/insert/edit mode
      State := vsNone;
      // Check modes, some are illegal
      if Mode = vmEdit then
        Mode := vmBrowse;
    end;
  end;
end;

{procedure TdtpDocument.SetRenderDpm(const Value: single);
begin
  if FRenderDpm <> Value then
  begin
    FRenderDpm := Value;
    if assigned(CurrentPage) then
    begin
      // Make sure the cache is gone and will be recreated
      CurrentPage.CacheDrop;
      CurrentPage.Regenerate;
    end;
  end;
end;}

procedure TdtpDocument.SetRulerCorner(const Value: TdtpRsRulerCorner);
begin
  if FRulerCorner <> Value then
  begin
    FRulerCorner := Value;
    UpdateRulers;
  end;
end;

procedure TdtpDocument.SetRulerLeft(const Value: TdtpRsRuler);
begin
  if FRulerLeft <> Value then
  begin
    FRulerLeft := Value;
    if Assigned(Value) and Assigned(CurrentPage) then  // changed by J.F. June 2011
      Value.OnRulerEvent := RulerOnEvent;           // make sure Default Page sets this
    UpdateRulers;
  end;
end;

procedure TdtpDocument.SetRulerTop(const Value: TdtpRsRuler);
begin
  if FRulerTop <> Value then
  begin
    FRulerTop := Value;
    if Assigned(Value) and Assigned(CurrentPage) then  // changeed by J.F. June 2011
      Value.OnRulerEvent := RulerOnEvent;           // make sure default Page sets this
    UpdateRulers;
  end;
end;

procedure TdtpDocument.SetRulerUnits(const Value: TRulerUnit);
begin
  if FRulerUnits <> Value then
  begin
    FRulerUnits := Value;
    if FRulerUnits = ruInch then  //  added by J.F. June 2011
      FHintPrecision:= ghp3Decimals
    else
      FHintPrecision:= ghp2Decimals;
    UpdateRulers;
  end;
end;

procedure TdtpDocument.SetScreenDPI(const Value: single);
begin
  ScreenDpm := Value / cMMToInch;
end;

procedure TdtpDocument.SetScreenDpm(const Value: single);
begin
  if FScreenDpm <> Value then
  begin
    FScreenDpm := Value;
    if not IsPrinting then
    begin
      if assigned(CurrentPage) then
      begin
        // Make sure the cache is gone and will be recreated
        CurrentPage.CacheDrop;
        CurrentPage.Regenerate;
      end;
      Invalidate;
    end;
  end;
end;

procedure TdtpDocument.SetShowMargins(const Value: boolean);
begin
  if FShowMargins <> Value then
  begin
    FShowMargins := Value;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetShowPageShadow(const Value: boolean);
// added by J.F. Feb 2011
begin
  if FShowPageShadow <> Value then
  begin
    FShowPageShadow := Value;
    DocumentChanged;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetState(const Value: TdtpViewerStateType);

begin
  if FState <> Value then
  begin
    // Mode change means cancel hints
    FShapeHint.CancelHint;
    FMarginHint.CancelHint;
    FGuideHint.CancelHint;

    // Cancel ongoing drag
    if FState = vsDrag then
      DoDragClose(False);
    // Cancel ongoing select
    if FState = vsSelect then
      DoSelectClose(False);
    // Cancel ongoing insert
    if FState = vsInsert then
      DoInsertClose(False);
    
    // New mode
    FState := Value;
  end;
end;

procedure TdtpDocument.SetThumbnailHeight(const Value: integer);
begin
  if FThumbnailHeight <> Value then
  begin
    FThumbnailHeight := Value;
    UpdateAllPageThumbnails;
  end;
end;

procedure TdtpDocument.SetThumbnailWidth(const Value: integer);
begin
  if FThumbnailWidth <> Value then
  begin
    FThumbnailWidth := Value;
    UpdateAllPageThumbnails;
  end;
end;

procedure TdtpDocument.SetUndoEnabled(const Value: boolean);
begin
  if FUndoEnabled <> Value then
  begin
    FUndoEnabled := Value;
    if not FUndoEnabled then
      UndoClear;
  end;
end;

procedure TdtpDocument.SetUseClipboard(const Value: boolean);
begin
  if FUseClipboard <> Value then
  begin
    FUseClipboard := Value;
    if FUseClipboard then
      FreeAndNil(FInternalClipboard);
  end;
end;

procedure TdtpDocument.SetUseDocumentBoard(const Value: boolean);
// added by J.F. Feb 2011
begin
  if FUseDocumentBoard <> Value then
  begin
    FUseDocumentBoard := Value;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetScrollWithMouseWheel(const Value: boolean); // added by J.F. Juen 2011
begin
  if FScrollWithMouseWheel <> Value then
  begin
    FScrollWithMouseWheel:= Value;
    FZoomWithMouseWheel:= false;
  end;
end;

procedure TdtpDocument.SetZoomWithMouseWheel(const Value: boolean); // added by J.F. June 2011
begin
  if FZoomWithMouseWheel <> Value then
  begin
    FZoomWithMouseWheel:= Value;
    FScrollWithMouseWheel:= false;
  end;
end;

procedure TdtpDocument.SetMouseWheelScrollSpeed(const Value: integer); // added by J.F. June 2011
begin
  if Value >= 1 then
    FMouseWheelScrollSpeed:= Value;
end;

procedure TdtpDocument.SetViewStyle(const Value: TdtpViewStyleType);
begin
  if FViewStyle <> Value then
  begin
    FViewStyle := Value;
    AdjustSizeToPage(Self);
    // added by J.F. Feb 2011
    UpdateRulers;
    Invalidate;
  end;
end;

procedure TdtpDocument.SetViewerFunction(const Value: TdtpViewerFunctionType);  //  added by J.F. July 2011
begin
  if (FViewerFunction <> Value) and (FViewerFunction in [vfNone, vfDirectPanning,vfDirectMouseButtonZoom,
                                                      vfDirectMouseDragZoom,vfDirectMouseZoomInOut]) then
  begin
    FViewerFunction:= Value;
    if Value = vfNone then
    begin
      SetWindowsCursor(Cursor);
      Screen.Cursor:= crDefault;
    end;
  end;
end;

procedure TdtpDocument.SetWindowLeft(const Value: single);
begin
//  DoDebugOut(Self, wsInfo, format('setwindowleft=%5.3f', [Value]));
  if FWindowLeft <> Value then
    FWindowLeft := Value;
end;

procedure TdtpDocument.SetWindowsCursor(ACursor: TCursor);
begin
  if (FWorkingCount = 0) or
     (Cursor = crDefault) or
     ((Cursor = crAppStart) and (ACursor = crHourglass)) then
  begin
    Windows.SetCursor(Screen.Cursors[ACursor]);

  end;
end;

procedure TdtpDocument.SetWindowTop(const Value: single);
begin
//  DoDebugOut(Self, wsInfo, format('setwindowtop=%5.3f', [Value]));
  if FWindowTop <> Value then
    FWindowTop := Value;
end;

procedure TdtpDocument.SetZoomPercent(const Value: single);
begin
  if not AutoWidth then
    exit;
  FZoomPercent := Value;
  ZoomToWidth;
  ZoomByFactor(FZoomPercent / 100);
end;

procedure TdtpDocument.SetZoomStep(const Value: single); // added by J.F. June 2011
begin
  if (Value >= cDefaultZoomStep) and (Value < 5.0) then
    FZoomStep:= Value;
end;

function TdtpDocument.ShapeAdd(AShape: TdtpShape): integer;
begin
  Result := -1;
  if assigned(CurrentPage) then
    Result := CurrentPage.ShapeAdd(AShape);
  DoShapeListChanged;
end;

procedure TdtpDocument.ShapeDelete(AIndex: integer);
begin
  if Shapes[AIndex] = FocusedShape then
    FocusedShape := nil;
  if Shapes[AIndex] = DraggedShape then
    DraggedShape := nil;
  if assigned(CurrentPage) then
    CurrentPage.ShapeDelete(AIndex);
  DoShapeListChanged;
end;

procedure TdtpDocument.ShapeExchange(i, j: integer);
begin
  if assigned(CurrentPage) then
    CurrentPage.ShapeExchange(i, j);
  DoShapeListChanged;
end;

function TdtpDocument.ShapeExtract(AShape: TdtpShape): TdtpShape;
begin
  Result := nil;
  if assigned(CurrentPage) then
    Result := CurrentPage.ShapeExtract(AShape);
  DoShapeListChanged;
end;

procedure TdtpDocument.ShapeInsert(Index: Integer; AShape: TdtpShape);
begin
  if assigned(CurrentPage) then
    CurrentPage.ShapeInsert(Index, AShape);
  DoShapeListChanged;
end;

function TdtpDocument.ShapeRemove(AShape: TdtpShape): integer;
begin
  Result := -1;
  if assigned(CurrentPage) then
    Result := CurrentPage.ShapeRemove(AShape);
  DoShapeListChanged;
end;

procedure TdtpDocument.TimerAnimate(Sender: TObject);
var
  i: integer;
begin
  if FAnimating then
    exit;
  FAnimating := True;
  try
    // Call the page update
    TimerPageUpdate(nil);
    // Call our own OnAnimate
    if assigned(FOnAnimate) then
      FOnAnimate(Self);
    // Call each shape's DoAnimate
    for i := 0 to ShapeCount - 1 do
      TShapeAccess(Shapes[i]).DoAnimate;
  finally
    FAnimating := False;
  end;
end;

procedure TdtpDocument.TimerHotzoneScrolling(Sender: TObject);
begin
  if FHotzoneActive then
    DoHotzoneScrolling;
end;

procedure TdtpDocument.TimerPageUpdate(Sender: TObject);
var
  i: integer;
begin
  if (not AutoPageUpdate) or (CurrentPageIndex < 0) or (CurrentPageIndex >= PageCount) then
    exit;

  if State <> vsNone then
    FModifiedTick := GetTickCount;

  // Determine if we must update
  if (abs(GetTickCount - FModifiedTick) < PageUpdateInterval) then
    exit;

  // Yes.. update
  for i := 0 to PageCount - 1 do
  if Pages[i].IsThumbnailModified then
  begin
    Pages[i].UpdateThumbnail;
    // Make sure to show changes after each thumb.. user feedback
    Application.ProcessMessages;
  end;
end;

procedure TdtpDocument.Undo;
var
  Cmd: TdtpCommand;
  LastOne: boolean;
begin
  if IsWorking then
    raise Exception.Create(sdeThreadingError);
  LastOne := False;
  if not UndoEnabled then
    exit;
  try
    DisableUndo;
    RedoEnabled := True;
    // We call this so that the redo commands are in the same batch as the undo commands
    BeginUndo;
    // Execute commands that are in IncludePrev chain
    repeat
      if UndoCount = 0 then
        break;
      Cmd := TdtpCommand(FUndos.Extract(FUndos[UndoCount - 1]));
      if not assigned(Cmd) then
        exit;
      PerformCommand(Cmd);
      LastOne := not Cmd.IncludePrev;
      FreeAndNil(Cmd);
    until LastOne;
  finally
    EndUndo;
    RedoEnabled := False;
    EnableUndo;
  end;
end;

procedure TdtpDocument.UndoAdd(ACmd: TdtpCommand);
var
  Prev: TdtpCommand;
begin
  if not UndoEnabled then
  begin
    FreeAndNil(ACmd);
    exit;
  end;
  if assigned(FUndos) and assigned(ACmd) then
  begin

    // Nested undo?
    if FUndoNestCount > 0 then
    begin
      if FUndoNestAdditions then
        // 2nd, 3rd, etc will include up till 1st
        ACmd.IncludePrev := True;
      FUndoNestAdditions := True;
    end;

    // check for previous
    if FRedos.Count > 0 then
    begin
      Prev := nil;
    end else
      Prev := Undos[UndoCount - 1];
    // is it a repeat?
    if assigned(Prev)
      and (ACmd.Command  = cmdSetProp)
      and (Prev.Command = ACmd.Command)
      and (Prev.Ref     = ACmd.Ref)
      and (Prev.Prop    = ACmd.Prop)
      and ((Prev.Value   = ACmd.Value) or FNoRepeatedPropertyChange) then
    begin
      // Yes it is a repeat - so do not store it, we have the previous value
      FreeAndNil(ACmd);
      exit;
    end;
    FNoRepeatedPropertyChange := False;

    // If we are redoing we shouldn't clear, otherwise we should
    if not FIsRedoing then
      FRedos.Clear;

    // Add to the list
    FUndos.Add(ACmd);
    inc(FUndoSize,  ACmd.Size);

    // Check length and remove first undo if too big
    while (FUndoSize > cMaxUndoSize) and (UndoCount > 0) do
    begin
      dec(FUndoSize, Undos[0].Size);
      FUndos.Delete(0);
    end;
  end;
end;

procedure TdtpDocument.UndoClear;
begin
  FUndos.Clear;
  FUndoSize := 0;
  FRedos.Clear;
end;

procedure TdtpDocument.Ungroup;
// Ungroup the selected groups
var
  i: integer;
  Group: TdtpGroupShape;
begin
  if IsWorking then raise
    Exception.Create(sdeThreadingError);
  BeginUndo;
  for i := ShapeCount - 1 downto 0 do
    if Shapes[i].Selected and (Shapes[i] is TdtpGroupShape) then
    begin
      Group := TdtpGroupShape(Shapes[i]);
      Group.Ungroup;
      ShapeDelete(i);
    end;
  EndUndo;
end;

procedure TdtpDocument.UpdateAllPageThumbnails;
var
  i: integer;
begin
 // make sure thumbnails are updated for all pages
 for i := 0 to PageCount - 1 do
   Pages[i].Modified := True;
end;

procedure TdtpDocument.UpdateDefaultPageThumbnails;
var
  i: integer;
begin
 // make sure thumbnails are updated for default pages
 for i := 0 to PageCount - 1 do
   if Pages[i].IsDefaultPage then
     Pages[i].IsThumbnailModified := True;
end;

procedure TdtpDocument.UpdateRulers;
var
  OffsetPoint: TdtpPoint;
  // added by J.F. Feb 2011
  BorderOffsetPoint: TPoint;
begin
  // changed by J.F. June 2011
  if not assigned(CurrentPage) then
    exit;

  // Do we have rulers?
  if not (assigned(FRulerTop) or assigned(FRulerLeft) or assigned(FRulerCorner)) then
    exit;

  // added by J.F. Feb 2011
  BorderOffsetPoint.X := 0;
  BorderOffsetPoint.Y := 0;
  // added by J.F. Feb 2011
  if BorderStyle = bsSingle then
  begin
    BorderOffsetPoint.X := -2; // 2 pixel border
    BorderOffsetPoint.Y := -2;
  end;

  // changed by J.F. Feb 2011
  OffsetPoint := CurrentPage.ScreenToShape(BorderOffsetPoint);

  if assigned(FRulerTop) then
  begin
    FRulerTop.Units := FRulerUnits;
    FRulerTop.Offset := FScreenDpm * OffsetPoint.X;
    FRulerTop.ScreenDpm := FScreenDpm;
  end;

  if assigned(FRulerLeft) then
  begin
    FRulerLeft.Units := FRulerUnits;
    FRulerLeft.Offset := FScreenDpm * OffsetPoint.Y;
    FRulerLeft.ScreenDpm := FScreenDpm;
  end;

  if assigned(FRulerCorner) then
  begin
    FRulerCorner.Units := FRulerUnits;
  end;
end;

procedure TdtpDocument.UpdateScrollPosition;
begin
  WindowLeft := ScrollLeft / ScreenDpm;
  WindowTop  := ScrollTop  / ScreenDpm;
  UpdateRulers;
  // added by J.F. Feb 2011 - need to check guide count
  if Assigned(CurrentPage) then
     CurrentPage.Invalidate;
  if assigned(FOnUpdateScrollPosition) then
    FOnUpdateScrollPosition(Self);
end;

procedure TdtpDocument.WMLButtonDblClick(var Message: TWMLButtonDblClk);
// The user double-clicked the left mouse button
var
  LButton, MButton, RButton, Shift, Ctrl, Alt: boolean;
  X, Y: integer;
begin

  inherited;
  // Set the focus to ourself
  SetFocus;

  // Get the mouse state
  GetMouseState(Message, LButton, MButton, RButton, Shift, Ctrl, Alt, X, Y);

  if FViewerFunction in [vfPanning, vfMouseButtonZoom, vfDirectPanning, vfDirectMouseButtonZoom] then // added by J.F. June 2011
    exit;

   // We use this code to ensure the buttonup after the dblclick gets ignored
  FWasDoubleClicking := True; //  added by J.F. June 2011

  if (State = vsEdit) and assigned(EditedShape) then
  begin
    EditedShape.MouseDblClick(LButton, RButton, Shift, Ctrl, X, Y);
    exit;
  end;

  // Try to determine the click position
  GetHitTestInfoDblClickAt(Point(X, Y), FHitInfo, FDraggedShape);

  //..if a shape was found..
  if assigned(FDraggedShape) then
  begin
    // In read-only mode we only do the doubleclick event, otherwise the edit
    if ReadOnly or (FDraggedShape.AllowEdit = False) then
    begin
      TShapeAccess(FDraggedShape).DoDblClick;
      FDraggedShape := nil;
    end else
    begin
      DoEditStart(FDraggedShape);
    end;
  end;
end;

procedure TdtpDocument.WMLButtonDown(var Message: TWMLButtonDown);
// The user clicked the left mouse button
var
  LButton, MButton, RButton, Shift, Ctrl, Alt: boolean;
  X, Y: integer;
  SState: TShiftState;
  Dummy: boolean; //  added by J.F. July 2011
begin
  inherited;
  // Set the focus to ourself
  SetFocus;

  // Get the mouse state
  GetMouseState(Message, LButton, MButton, RButton, Shift, Ctrl, Alt, X, Y);

  if FViewerFunction <> vfNone then //  added by J.F. July 2011
  begin            // changed by J.F. July 2011

    if FViewerFunction in [vfPanning, vfDirectPanning] then // added by J.F. June 2011
    begin
      FMousePanningOldPos:= point(X,Y); //  changed by J.F. June 2011
      SetWindowsCursor(crDtpHandGrabber);
    end
    else
    if FViewerFunction in [vfMouseDragZoom, vfDirectMouseDragZoom] then
    begin
      FMouseDragZoomOrgPos:= point(X,Y);
      FMouseDragZoomFinalPos:= point(X,Y);
      PaintMouseDragZoomBorder(Point(X,Y));
    end;
    exit;
  end;

   // Try to determine the click position
  GetHitTestInfoAt(Point(X, Y), FHitInfo, FDraggedShape);  // moved here by J.F. May 2011

  // added by J.F. Feb 2011 changed June 2011
  if (Mode = vmEdit) and (CurrentPage.GuideCount <> 0) and FGuidesVisible and not FGuidesLocked then
  if (not (FHitInfo in [htShape,htLT..htTop])) or (FGuidesToFront and (not Assigned(EditedShape) or (FDraggedShape <> EditedShape))) then
  if TPageAccess(CurrentPage).StartGuideMove(CurrentPage.ScreenToShape(Point(X,Y))) then
  begin

    FHintGuide:= TPageAccess(CurrentPage).FSelectedGuide; // added by J.F. June 2011

               // the following line  needed in case a text shape is selected
               // without them the line drawing misfires
    Invalidate;

    FSavedHotzoneScrolling:= HotZoneScrolling; // changed by J.F. July 2011
    HotZoneScrolling:= hzsNoScroll;
    FViewerFunction:= vfGuideMoving;
    exit;
  end;

  // added by J.F.  July 2011
  if (Mode = vmEdit) and FShowMargins and not FMarginsLocked then
  if (not (FHitInfo in [htShape,htLT..htTop])) or (not Assigned(EditedShape) or (FDraggedShape <> EditedShape)) then
  if TPageAccess(CurrentPage).StartMarginMove(CurrentPage.ScreenToShape(Point(X,Y))) then
  begin
    FViewerFunction:= vfMarginMoving;
    BeginUpdate;
    exit;
  end;

  // OnMouseDown - in this case fire the event
  if assigned(FOnMouseDown) then
  begin
    SState := [ssLeft];
    if Shift then
      SState := SState + [ssShift];
    if Ctrl  then
      SState := SState + [ssCtrl];
    FOnMouseDown(Self, mbLeft, SState, X, Y);
  end;

  if State = vsInsert then
    // Nothing to do; wait for second mouse up
    exit;

  // Set drag delta to zero as a start
  FDragDeltaDoc := dtpPoint(0, 0);

  FDragPosDoc.Y:= -1000; // added by J.F. May 2011 AdjustToGrid Trigger

  // Store the position in Document coordinates
  FDragPosDoc := AdjustToGrid(ScreenToDoc(Point(X, Y)), SnapToGrid xor Alt);

  // added by J.F. Feb 2011 
  FSnapToGuidesOffset.Y:= -1000; //  added by J.F. July 2011 AdjustToGuides trigger
  AdjustToGuides(FDragPosDoc, SnapToGuides xor Alt, Dummy); // added by J.F. July 2011

  if (State = vsEdit) and assigned(EditedShape) then
  begin       
    // fixes problem where user is in the beginning of a dblClick of another Text Shape
    // or selects another Text Shape and is already editing a Text Shape
    EditedShape.MouseDown(LButton, RButton, Shift, Ctrl, X, Y);
    if (FDraggedShape = EditedShape) then
      exit;
  end;

  if State = vsBeforeInsert then
  begin
    // changed by JF
    if FInsertMode = imBySingleClick then
      DoInsertClose(True)
    else
    begin   
      // FInsertMode = imByRectangle
      PaintInsertBorder(FDragDeltaDoc);
      State := vsInsert;
    end;
    exit;
  end;

  // Depending on document's mode we will handle mouse events differently
  case Mode of
  vmEdit:
    begin
      if Ctrl and (MultiSelectMethod = msmCtrl) then
      begin
        // Multipe selection mode
        State := vsSelect;
        FDragPosDoc := ScreenToDoc(Point(X, Y));
        PaintSelectBorder(FDragDeltaDoc);
        exit;
      end;

      // Try to determine the click position
      if assigned(FDraggedShape) then
      begin
        if Shift then
          AddToSelection(FDraggedShape)
        else
        begin
          // We hit a control or the new shape is not part of the selection
          if (FHitInfo <> htShape) or not FDraggedShape.Selected then
          begin
            BeginUpdate;
            // Focus on this new one and clear the previous selection
            ClearSelection;
            FocusedShape := FDraggedShape;
            FDraggedShape.Selected := True;
            EndUpdate;
          end;
        end;
      end;

      DragCursor := GetDragCursor(FDraggedShape, FHitInfo);

      case FHitInfo of
      htShape: SetWindowsCursor(Cursor);
      htLT..htTop: SetWindowsCursor(DragCursor);
      htRotate:
        begin
          FDragPosDoc := ScreenToDoc(Point(X, Y));
          SetWindowsCursor(crDtpRotate);
        end;
      htPoint:     SetWindowsCursor(crSizeAll);
      else
        // Hit nothing
        if (MultiSelectMethod = msmSimple) then
        begin

          // Start selection rectangle, since we did not hit anything
          State := vsSelect;
          FDragPosDoc := ScreenToDoc(Point(X, Y));
          PaintSelectBorder(FDragDeltaDoc);
  
        end else
        begin

          // a click in emptyness means clean the selection
          ClearSelection;
        end;
        FocusedShape := nil;
        SetWindowsCursor(Cursor);
      end;
    end;
  vmBrowse:;     //
  vmTextSelect:; //
  vmZoom:;       //
  end;//case
end;

procedure TdtpDocument.WMLButtonUp(var Message: TWMLButtonUp);
// The user released the left mouse button, so this represents a click or end
// of drag
var
  i: integer;
  LButton, MButton, RButton, Shift, Ctrl, Alt: boolean;
  X, Y: integer;
  Cpy: string;
  SS: TShiftState;
begin
  if FWasDoubleClicking then
  begin
    FWasDoubleClicking := False;
    DoDragClose(False);
    exit;
  end;

  inherited;

  GetMouseState(Message, LButton, MButton, RButton, Shift, Ctrl, Alt, X, Y);

  if FViewerFunction <> vfNone then //  added / changed by J.F. July 2011
  begin
    if FViewerFunction in [vfMouseButtonZoom, vfDirectMouseButtonZoom] then // added by J.F. June 2011
      DoZoomInByMouse
    else
    if FViewerFunction in [vfDirectMouseZoomInOut] then // added by J.F. June 2011
    begin
      if Ctrl then
        DoZoomOutByMouse
      else
        DoZoomInByMouse;
    end
    else
               // added by J.F. Feb 2011, fixed NH 30may2011
    if FViewerFunction = vfGuideMoving then // changed by J.F. June 2011
    begin
      TPageAccess(CurrentPage).FinishGuideMove(CurrentPage.ScreenToShape(Point(X,Y)));
      HotZoneScrolling:= FSavedHotzoneScrolling; // changed by J.F. July 2011
      FGuideHint.CancelHint;   //added by J.F. June 2011
      FHintGuide:= nil;  //added by J.F. June 2011
      FViewerFunction:= vfNone;
    end
    else
    if FViewerFunction in [vfMouseDragZoom, vfDirectMouseDragZoom] then //  added by J.F. June 2011
    begin
      PaintMouseDragZoomBorder(FMouseDragZoomFinalPos);
      ZoomByRect(Rect(FMouseDragZoomOrgPos.X,FMouseDragZoomOrgPos.Y,FMouseDragZoomFinalPos.X,FMouseDragZoomFinalPos.Y));
      FMouseDragZoomOrgPos:= point(0,0);
      FMouseDragZoomFinalPos:= point(0,0);
    end
    else
    if FViewerFunction = vfMarginMoving then // added by J.F. July 2011
    begin
      EndUpdate;
      FViewerFunction:= vfNone;
    end;
    exit;
  end; //  added by J.F. July 2011

  try

    if (State = vsEdit) and assigned(EditedShape) then
    begin
      // If we have a shape that is editing, send this message to it
      EditedShape.MouseUp(LButton, RButton, Shift, Ctrl, X, Y);
      exit;
    end;

    // Terminate drag operations
    if State = vsInsert then
    begin
      // Only close if we are at a different location
      if (FDragDeltaDoc.X <> 0) or (FDragDeltaDoc.Y <> 0) then
        DoInsertClose(True);
      exit;
    end;

    if State = vsSelect then
    begin
      ClearSelection;
      DoSelectClose(True);
      exit;
    end;

    if State = vsDrag then
    begin
      if (FHitInfo = htShape) and (GetKeyState(VK_CONTROL) < 0) then
      begin
        // Ctrl pressed, so copy
        DoDragClose(False);
        Cpy := SelectionToText;
        ClearSelection;
        SelectionFromText(Cpy);
        for i := 0 to SelectionCount - 1 do
        begin
          // Move each shape by the drag delta
          Selection[i].Left := Selection[i].Left + FDragDeltaDoc.X;
          Selection[i].Top  := Selection[i].Top  + FDragDeltaDoc.Y;
        end;
      end else
        // Move or resize
        DoDragClose(True);

      //Make sure the app knows about changes to our focused shape
      if assigned(FocusedShape) then
        DoShapeChanged(FocusedShape);

    end;

  finally
    // Make sure to always call OnMouseUp (suggestion Alan D.)
    if assigned(FOnMouseUp) then
    begin
      SS := [ssLeft];
      if Shift then
        SS := SS + [ssShift];
      if Ctrl  then
        SS := SS + [ssCtrl];
      FOnMouseUp(Self, mbLeft, SS, X, Y);
    end;
  end;
end;

procedure TdtpDocument.WMMButtonDown(var Message: TWMRButtonDown);
// React to middle mouse button down events
var
  LButton, MButton, RButton, Shift, Ctrl, Alt: boolean;
  X, Y: integer;
  SS: TShiftState;
begin
  inherited;
  GetMouseState(Message, LButton, MButton, RButton, Shift, Ctrl, Alt, X, Y);
  if Assigned(FOnMouseDown) then
  begin
    SS := [ssRight];
    if Shift then
      SS := SS + [ssShift];
    if Ctrl  then
      SS := SS + [ssCtrl];
    FOnMouseDown(Self, mbMiddle, SS, X, Y);
  end;
end;

procedure TdtpDocument.WMMButtonUp(var Message: TWMRButtonUp);
// React to middle mouse button up events
var
  LButton, MButton, RButton, Shift, Ctrl, Alt: boolean;
  X, Y: integer;
  SS: TShiftState;
begin
  inherited;
  GetMouseState(Message, LButton, MButton, RButton, Shift, Ctrl, Alt, X, Y);
  if assigned(FOnMouseUp) then
  begin
    SS := [ssRight];
    if Shift then SS := SS + [ssShift];
    if Ctrl  then SS := SS + [ssCtrl];
    FOnMouseUp(Self, mbMiddle, SS, X, Y);
  end;
end;

procedure TdtpDocument.WMMouseMove(var Message: TWMMouseMove);
// The user hovers the mouse over the window (with mouse down or not)
var
  LButton, MButton, RButton, Shift, Ctrl, Alt: boolean;
  PosDoc: TdtpPoint;
  Shape: TdtpShape;
  X, Y: integer;
  P: integer;
  OldDragDeltaDoc: TdtpPoint;
  OldMouseDragZoomFinalPos: TPoint;  // added by J.F. June 2011
  DeltaChanged: boolean;
  BorderOffset: integer; // added by J.F. June 2011
  Adjusted: boolean; //  added by J.F. July 2011

  NewMarginPosition: single;  //  added by J.F. July 2011

                  // local procedure
    function CheckForGuideHint: boolean;  //  changed by J.F. July 2011
    var
      Guide: TdtpGuide;  // added by J.F. June 2011
    begin
      Result:= false; // added by J.F. July 2011
      if FShowGuideHints and FGuidesVisible and ( CurrentPage.GuideCount <> 0 ) then  // added by J.F. June 2011
      begin
        Guide:= TPageAccess(CurrentPage).GetGuideAtPoint(CurrentPage.ScreenToShape(Point(X,Y)));
        if assigned(Guide) then
        begin
          Result:= true; // added by J.F. July 2011
          if (Guide <> FHintGuide) then
          begin
            // New or altered Hint Guide
            if assigned(FHintGuide) then
              P := HintShortPause
            else
              P := HintPause;
            FHintGuide:= Guide;
            FGuideHint.HintOffset:= hoNormal;
            FGuideHint.StartHint(Point(X, Y), FormatHint(Guide.Position), P);
          end
          else
          if FGuideHint.HintShowing then
            FGuideHint.DisplayHint(Point(X, Y), FormatHint(Guide.Position))
          else
            FGuideHint.HintPos:= Point(X,Y);
        end
        else
        begin
          FHintGuide:= nil;
          FGuideHint.CancelHint;
        end;
      end;
    end;

     // local procedure
    procedure CheckForMarginHint;  //  added by J.F. July 2011
    var
      MarginPosition: single;
    begin
      // NH: init
      MarginPosition := 0;

      if FShowMarginHints and ShowMargins then
      begin
        if TPageAccess(CurrentPage).IsMarginSelected(CurrentPage.ScreenToShape(Point(X,Y))) then
        begin
          case TPageAccess(CurrentPage).FSelectedMargin of
              smLeft: MarginPosition:= CurrentPage.MarginLeft;
              smTop: MarginPosition:= CurrentPage.MarginTop;
              smRight: MarginPosition:= CurrentPage.MarginRight;
              smBottom: MarginPosition:= CurrentPage.MarginBottom;
          end;
          if TPageAccess(CurrentPage).FSelectedMargin <> FHintMargin then
          begin
               // New or altered Hint Margin
            if FHintMargin = smNone then
            begin
              P := HintPause;
              FHintMargin:= TPageAccess(CurrentPage).FSelectedMargin;
            end
            else
              P := HintShortPause;
            FMarginHint.HintOffset:= hoNormal;
            FMarginHint.StartHint(Point(X,Y),FormatHint(MarginPosition), P);
          end
          else
          if FMarginHint.HintShowing then
            FMarginHint.DisplayHint(Point(X, Y), FormatHint(MarginPosition))
          else
            FMarginHint.HintPos:= Point(X,Y);  
        end
        else
        begin
          TPageAccess(CurrentPage).FSelectedMargin:= smNone;
          FHintMargin:= smNone;
          FMarginHint.CancelHint;
        end;
      end;
    end;

begin
  inherited;
  // NH: init
  NewMarginPosition := 0;

  // Get the mouse state
  GetMouseState(Message, LButton, MButton, RButton, Shift, Ctrl, Alt, X, Y); // moved here by J.F. June 2011

  BorderOffset:= integer(BorderStyle = bsSingle) * 3; // added by J.F. june 2011
  // Ruler hairline pos                               // compensate for Border
  if assigned(FRulerTop) then
    FRulerTop.HairLinePos := X + BorderOffset;  // changed by J.F. june 2011
  if assigned(FRulerLeft) then
    FRulerLeft.HairlinePos := Y + BorderOffset; // changed by J.F. june 2011

  if FViewerFunction <> vfNone then  //  added / changed by J.F. July 2011
  begin
    if FViewerFunction in [vfMouseButtonZoom, vfDirectMouseButtonZoom] then // added by J.F. June 2011
      SetClientRectCursor(crDtpMagnifier)
    else
    if FViewerFunction in [vfDirectMouseZoomInOut] then // added by J.F. June 2011
    begin
      if Ctrl then
        SetClientRectCursor(crDtpZoomOut)
      else
        SetClientRectCursor(crDtpZoomIn);
    end
    else
    if FViewerFunction in [vfPanning, vfDirectPanning] then
    begin
      if LButton and (Screen.Cursor <> crDefault) then   // added by J.F. June 2011
        DoMousePanning
      else
        SetClientRectCursor(crDtpHandHover);
    end
    else
    if (FViewerFunction in [vfMouseDragZoom, vfDirectMouseDragZoom]) then //  added by J.F. June 2011
    begin
      if not SetClientRectCursor(crDtpDragZoom) then
        Screen.Cursor:= crDefault
      else
      if LButton then
      begin
        // Old drag delta
        OldMouseDragZoomFinalPos := FMouseDragZoomFinalPos;

        FMouseDragZoomFinalPos := Point(X,Y);

        if (OldMouseDragZoomFinalPos.X <> FMouseDragZoomFinalPos.X) or (OldMouseDragZoomFinalPos.Y <> FMouseDragZoomFinalPos.Y) then
        begin
          PaintMouseDragZoomBorder(OldMouseDragZoomFinalPos);
          PaintMouseDragZoomBorder(FMouseDragZoomFinalPos);
        end;
      end;
    end
    else
    // added by J.F. Feb 2011, fixed NH 30may2011
    // moved here by J.F. July 2011
    if (FViewerFunction = vfGuideMoving) and LButton then
    begin
      if not PtInRect(ClientRect, ScreenToClient(Mouse.CursorPos)) then // changed by J.F. July 2011
      begin
        FGuideHint.CancelHint;
        SetWindowsCursor(crNoDrop);
      end
      else
      begin
        TPageAccess(CurrentPage).MoveSelectedGuide(CurrentPage.ScreenToShape(Point(X,Y)));
        if FShowGuideHints then
        begin
          if FHintGuide.IsVertical then
            FGuideHint.HintOffset:= hoVertical
          else
            FGuideHint.HintOffset:= hoHorizontal;
          FGuideHint.DisplayHint(Point(X,Y), FormatHint(CurrentPage.SelectedGuide.Position));
        end;
      end;
    end
    else
    if (FViewerFunction = vfMarginMoving) and LButton then //  changed by J.F. July 2011
    begin
      if (not PtInRect(ClientRect, ScreenToClient(Mouse.CursorPos))) or
         (not TPageAccess(CurrentPage).ValidMarginPosition(CurrentPage.ScreenToShape(Point(X,Y)))) then
      begin
        FMarginHint.CancelHint;
        SetWindowsCursor(crNoDrop);
      end
      else
      begin
        TPageAccess(CurrentPage).MoveSelectedMargin(CurrentPage.ScreenToShape(Point(X,Y)));

        if FShowMarginHints then
        begin
          case TPageAccess(CurrentPage).FSelectedMargin of
            smLeft: NewMarginPosition:= CurrentPage.MarginLeft;
            smTop: NewMarginPosition:= CurrentPage.MarginTop;
            smRight: NewMarginPosition:= CurrentPage.MarginRight;
            smBottom: NewMarginPosition:= CurrentPage.MarginBottom;
          end;

          if TPageAccess(CurrentPage).FSelectedMargin in [smLeft, smRight] then
            FMarginHint.HintOffset:= hoVertical
          else
            FMarginHint.HintOffset:= hoHorizontal;
          FMarginHint.DisplayHint(Point(X,Y), FormatHint(NewMarginPosition));
        end;
      end;
    end;
    exit;
  end;

  // Hot zone scrolling
  if (HotZoneScrolling <> hzsNoScroll) and not FHotzoneActive then
    DoHotzoneScrolling;

  if (State = vsEdit) and assigned(EditedShape) then
  begin
    EditedShape.MouseMove(LButton, RButton, Shift, Ctrl, X, Y);
      // in case Text Shape is being edited and user moves mouse over guide
    if not PtInRect(EditedShape.BoundsRect, ScreenToClient(Mouse.CursorPos)) then
      CheckForGuideHint; //  added by J.F. June 2011
    exit;
  end;

  if State = vsBeforeInsert then
  begin
    if not LButton then
      // The insert cursor: use the shapes preferred one
      SetWindowsCursor(FInsertShape.InsertCursor); // changed by EL
    exit;
  end;

  if LButton and (FHitInfo in [htShape..htTop, htPoint]) then
  begin
    // Snap to guides
    PosDoc:= AdjustToGuides(ScreenToDoc(Point(X, Y)), SnapToGuides xor Alt, Adjusted); // added by J.F. July 2011
    // Snap to grid.. only for certain drag types (move, resize, point move)
    if not Adjusted then //  added by J.F. July 2011
      PosDoc := AdjustToGrid(ScreenToDoc(Point(X, Y)), SnapToGrid xor Alt);

  end
  else
    PosDoc := ScreenToDoc(Point(X, Y));
  
  // Old drag delta
  OldDragDeltaDoc := FDragDeltaDoc;

  // Just already calculate this one
  FDragDeltaDoc.X := PosDoc.X - FDragPosDoc.X;
  FDragDeltaDoc.Y := PosDoc.Y - FDragPosDoc.Y;

  // Based on the SHIFT key we can allow only cartesian movement
  if Shift and (FHitInfo = htShape) then
  begin
    if abs(FDragDeltaDoc.X) > abs(FDragDeltaDoc.Y) then
    begin
      FDragDeltaDoc.Y := 0;
    end else
    begin
      FDragDeltaDoc.X := 0;
    end;
  end;

  // Determine if the delta changed
  DeltaChanged := (OldDragDeltaDoc.X <> FDragDeltaDoc.X) or (OldDragDeltaDoc.Y <> FDragDeltaDoc.Y);

  if State = vsInsert then
  begin
    if DeltaChanged then
    begin
      // Paint old insert frame again to negate
      PaintInsertBorder(OldDragDeltaDoc);
      // paint new insert frame
      PaintInsertBorder(FDragDeltaDoc);
      // added by EL
      SetWindowsCursor(FInsertShape.InsertCursor);
    end;
    exit;
  end;

  if LButton then
  begin

    if State = vsSelect then 
    begin
      // selection frame
      SetWindowsCursor(Cursor);
      if DeltaChanged then
      begin
        PaintSelectBorder(OldDragDeltaDoc);
        PaintSelectBorder(FDragDeltaDoc);
      end;
      exit;
    end;

    if State <> vsDrag then
      // Check for frame drag starting
      if sqr(FDragDeltaDoc.X * ScreenDpm) + sqr(FDragDeltaDoc.Y * ScreenDpm) > cDragLimit then
      begin

        // Start the drag
        DoDragStart(OldDragDeltaDoc);
        // Mouse shows the SizeAll when dragging the shape
        if FHitInfo = htShape then
          SetWindowsCursor(crSizeAll);
      end;

    if State = vsDrag then
    begin
      // Check if we're going outside of control
      if (FHitInfo = htShape) and
         ((X < 0) or (X > Width) or (Y < 0) or (Y > Height)) then
      begin
        // Switch from our own drag to the application's drag
        DoDragClose(False);
        BeginDrag(True, -1);
      end;

      // Check cursor
      if FHitInfo = htShape then
        if GetKeyState(VK_CONTROL) < 0 then
          SetWindowsCursor(crDtpSizeCopy)
        else
          SetWindowsCursor(crSizeAll);

      // Ongoing frame drag operation
      if DeltaChanged then
      begin
        if (FHitInfo = htShape) then  //  added by J.F. July 2011
          Perform(WM_PAINT, 0,0);  // if shape moving too fast, this prevnets drag border detrious
        PaintDragBorders(OldDragDeltaDoc);
        PaintDragBorders(FDragDeltaDoc);
      end;
    end;
    exit;
  end;

  // Being here means any drag that was going on is finished
  FDraggedShape := nil;
  
  if LButton or RButton or MButton then  // changed by J.F. June 2011
    exit;

  // Just mouseover with no mouse buttons down
  GetHitTestInfoAt(Point(X, Y), FHitInfo, Shape);

  case FHitInfo of
  htShape:     SetWindowsCursor(crHandPoint);
  htLT..htTop: SetWindowsCursor(GetDragCursor(Shape, FHitInfo));
  htRotate:    SetWindowsCursor(crDtpRotate);
  htPoint:     SetWindowsCursor(crSizeAll);
  else
    // Hit nothing
    SetWindowsCursor(Cursor);
  end;

  // Hinting
  if FShowShapeHints then //  added by J.F. July 2011
  begin
    if assigned(Shape) and (FHitInfo = htShape) then // changed by J.F. July 2011
    begin
      if Shape <> FHintShape then
      begin
        // New or altered Hint shape
        if assigned(FHintShape) then
          P := HintShortPause
        else
          P := HintPause;

        FHintShape:= Shape;
        FShapeHint.HintOffset:= hoNormal;
        FShapeHint.StartHint(Point(X,Y), Shape.Hint, P, Shape.ShowHint);
      end
      else
        FShapeHint.HintPos:= Point(X,Y);
      exit;
    end
    else
    begin
      FHintShape := nil;
      FShapeHint.CancelHint;
    end;
  end;

  if not CheckForGuideHint then  // changed by J.F. July 2011
    CheckForMarginHint;  //  added by J.F. July 2011
  
end;

procedure TdtpDocument.WMMouseWheel(var Message : TWMMouseWheel);
// added by JF
var 
  N, i, j, k: integer;
  LButton, MButton, RButton, Shift, Ctrl, Alt: boolean;
  X, Y: integer;
  State: TKeyboardState;
  ShiftDown: boolean;
begin
  inherited;
  if FZoomWithMouseWheel then // added by J.F. June 2011
  begin
    if Message.WheelDelta > 0 then
      DoZoomInByMouse()
    else
      DoZoomOutByMouse();
    exit;
  end;
  GetMouseState(TWMMouse(Message), LButton, MButton, RButton, Shift, Ctrl, Alt, X, Y);
  GetKeyboardState(State);
  ShiftDown := ((State[VK_SHIFT] and 128) <> 0);
  
  N := Mouse.WheelScrollLines;
  if Message.WheelDelta > 0 then
  begin
    k := -Mouse.WheelScrollLines;
    N := -1;
  end
  else
    k := 1;
  j := 0;
  for i := k to n do
  begin
    if ShiftDown then
      ScrollBy(i * FMouseWheelScrollSpeed, j)  // Horiz scroll  changed by J.F. June 2011
    else
      ScrollBy(j, i * FMouseWheelScrollSpeed); // Vert Scroll   changed by J.F. June 2011
  end;
end;

procedure TdtpDocument.WMRButtonDown(var Message: TWMRButtonDown);
// React to right mouse button down events
var
  LButton, MButton, RButton, Shift, Ctrl, Alt: boolean;
  X, Y: integer;
  SS: TShiftState;
begin
  inherited;

  GetMouseState(Message, LButton, MButton, RButton, Shift, Ctrl, Alt, X, Y);

  if Assigned(FOnMouseDown) then
  begin
    SS := [ssRight];
    if Shift then
      SS := SS + [ssShift];
    if Ctrl  then
      SS := SS + [ssCtrl];
    FOnMouseDown(Self, mbRight, SS, X, Y);
  end;
end;

procedure TdtpDocument.WMRButtonUp(var Message: TWMRButtonUp);
// React to right mouse button up events
var
  LButton, MButton, RButton, Shift, Ctrl, Alt: boolean;
  X, Y: integer;
  SS: TShiftState;
  Guide: TdtpGuide;  // added by J.F. June 2011
  NewPosition: single;  //  added by J.F. June 2011
  TestMarginPosition: TdtpPoint;  //  added by J.F. July 2011
begin

  GetMouseState(Message, LButton, MButton, RButton, Shift, Ctrl, Alt, X, Y);

  if (FViewerFunction in [vfMouseButtonZoom, vfDirectMouseButtonZoom]) then // changed by J.F. June 2011
  begin
    DoZoomOutByMouse;
    SetClientRectCursor(crDtpMagnifier);
    exit;
  end;

   //  added by J.F. June 2011
  if assigned(FOnGuideRightClick) and assigned(CurrentPage) and FGuidesVisible and not FGuidesLocked then
  begin
    Guide:= TPageAccess(CurrentPage).GetGuideAtPoint(CurrentPage.ScreenToShape(Point(X,Y)));
    if assigned(Guide) then
    begin
      NewPosition:= DocToRuler(Guide.Position);
      FOnGuideRightClick(self,NewPosition);
      NewPosition:= RulerToDoc(NewPosition);
      CurrentPage.MoveGuide(Guide,NewPosition);
      exit;
    end;
  end;

  //  added by J.F. July 2011
  if assigned(FOnMarginRightClick) and assigned(CurrentPage) and FShowMargins and not FMarginsLocked then
  begin
    TestMarginPosition:= CurrentPage.ScreenToShape(Point(X,Y));
    if TPageAccess(CurrentPage).IsMarginSelected(TestMarginPosition) then
    begin
      case TPageAccess(CurrentPage).FSelectedMargin of
        smLeft: NewPosition:= DocToRuler(CurrentPage.MarginLeft);
        smTop: NewPosition:= DocToRuler(CurrentPage.MarginTop);
        smRight: NewPosition:= DocToRuler(CurrentPage.MarginRight);
        smBottom: NewPosition:= DocToRuler(CurrentPage.MarginBottom);
      end;
      FOnMarginRightClick(self,NewPosition);
      NewPosition:= RulerToDoc(NewPosition);
      case TPageAccess(CurrentPage).FSelectedMargin of
        smLeft: if TPageAccess(CurrentPage).ValidMarginPosition(dtpPoint(NewPosition, TestMarginPosition.Y)) then
                  CurrentPage.MarginLeft:= NewPosition;
        smTop:  if TPageAccess(CurrentPage).ValidMarginPosition(dtpPoint(TestMarginPosition.X, NewPosition)) then
                  CurrentPage.MarginTop:= NewPosition;
        smRight:if TPageAccess(CurrentPage).ValidMarginPosition(dtpPoint(CurrentPage.DocWidth - NewPosition, TestMarginPosition.Y)) then
                  CurrentPage.MarginRight:= NewPosition;
       smBottom:if TPageAccess(CurrentPage).ValidMarginPosition(dtpPoint(TestMarginPosition.X, CurrentPage.DocHeight - NewPosition)) then
                  CurrentPage.MarginBottom:= NewPosition;
      end;
      TPageAccess(CurrentPage).FSelectedMargin:= smNone;
      exit;
    end;
  end;

  inherited;  //  added by J.F. June 2011

  if assigned(FOnMouseUp) then
  begin
    SS := [ssRight];
    if Shift then
      SS := SS + [ssShift];
    if Ctrl  then
      SS := SS + [ssCtrl];
    FOnMouseUp(Self, mbRight, SS, X, Y);
  end;
end;

procedure TdtpDocument.WMSize(var Message: TWMSize);
// Gets called whenever the app resizes this control. If AutoWidth and at 100%,
// we will make sure we stay like that.
begin
  if FPrevWidth <> Width then
  begin
    FPrevWidth := Width;
    if AutoWidth and (FZoomPercent = 100) then
      SetZoomPercent(FZoomPercent);
  end;
  inherited;
end;

procedure TdtpDocument.WMDeleteShape(var Msg: TMessage);
// added by JF: so Shape can tell Tdtpdocument to remove itself 
// e.g. Text Shape when empty Text to remove clutter
begin
  try
    if FAutoDeleteShape then
      ShapeRemove(TdtpShape(Msg.WParam));
  finally
  end;
end;

procedure TdtpDocument.ZoomByRect(Rect: TRect); //  added by J.F. June 2011
var
  AFactor: single;
  RectWidth, RectHeight: integer;
  Scale: single;
  RectTopLeft: TdtpPoint;
  Offset: single;
  VertScrollBarWidth, HorizScrollBarHeight: integer;
begin
  RectWidth:= Rect.Right - Rect.Left;
  RectHeight:= Rect.Bottom - Rect.Top;
  if (RectWidth = 0) or (RectHeight = 0) then
    exit;

  VertScrollBarWidth:= GetSystemMetrics(SM_CXVSCROLL);
  HorizScrollBarHeight:= GetSystemMetrics(SM_CYHSCROLL);

  if (RectWidth > ClientWidth) or ((RectWidth > RectHeight) and (RectWidth / 2 > RectHeight)) then
    Scale:= 1 + (1 - (ClientWidth - VertScrollBarWidth) / (RectWidth))
  else
    Scale:= 1 + (1 - (ClientHeight - HorizScrollBarHeight) / (RectHeight));

  AFactor:= (1 + (1 - (RectWidth * RectHeight) / (ScrollWidth * ScrollHeight + HorizScrollBarHeight * VertScrollBarWidth))) - Scale;

  RectTopLeft:= CurrentPage.ScreenToShape(Point(Rect.Left,Rect.Top));

  ScreenDpm := ScreenDpm * AFactor;

  SetScrollBounds(0, 0, round(ScrollWidth  * AFactor), round(ScrollHeight * AFactor));

  AdjustSizeToPage(nil);

  RectTopLeft:= CurrentPage.ShapeToScreen(RectTopLeft);
  Offset:= 1.5 * AFactor + integer(BorderStyle = bsNone); // make it pretty
  ScrollBy(round(RectTopLeft.X - Offset), round(RectTopLeft.Y - Offset));
  
  Invalidate;
  UpdateRulers();
end;

                       // changed by J.F. June 2011
procedure TdtpDocument.ZoomByFactor(AFactor: single; ByMouse: boolean = false);
// Zoom on the center of the screen, with AFactor multiplication
var
  NewLeft, NewTop, NewWidth, NewHeight: single;
  MousePt: TPoint;
begin
  // The new scale
  if ByMouse then  // added by J.F. June 2011
  begin
    MousePt:= ScreenToClient(Mouse.CursorPos);
    NewLeft   := (ScrollLeft + MousePt.X) * AFactor - MousePt.X;
    NewTop    := (ScrollTop  + MousePt.Y) * AFactor -  MousePt.Y;
  end
  else
  begin
    NewLeft   := (ScrollLeft + ClientWidth  * 0.5) * AFactor - ClientWidth  * 0.5;
    NewTop    := (ScrollTop  + ClientHeight * 0.5) * AFactor - ClientHeight * 0.5;
  end;
  NewWidth  := ScrollWidth  * AFactor;
  NewHeight := ScrollHeight * AFactor;
  ScreenDpm := ScreenDpm * AFactor;
  if (not ByMouse) and (ScrollLeft = 0) and (ScrollTop = 0) then  // changed by J.F. June 2011
  begin
    NewLeft := 0;   // Nils: Is this code needed at all ??????
    NewTop  := 0;   // It inteferes with ScrollByMouseWheel
  end;
  SetScrollBounds(round(NewLeft), round(NewTop), round(NewWidth), round(NewHeight));
  Invalidate;
  UpdateRulers(); // added by J.F. Feb 2011
end;

procedure TdtpDocument.MouseZoomByFactor(AFactor: single);  //  added by J.F. June 2011
begin
  ZoomByFactor(AFactor, true);
end;

procedure TdtpDocument.ZoomIn;
// Zoom in on the center of the screen, with cDefaultZoomStep multiplication
begin
  FZoomPercent := FZoomPercent * ZoomStep;  // changed by J.F. June 2011
  ZoomByFactor(ZoomStep);  // changed by J.F. June 2011
end;

procedure TdtpDocument.ZoomOut;
begin
  FZoomPercent := FZoomPercent / ZoomStep;  // changed by J.F. June 2011
  ZoomByFactor(1 / ZoomStep); // changed by J.F. June 2011
end;

procedure TdtpDocument.ZoomPage;
// Zoom the document so that its page remains within the client window of
// the control
var
  W, H: integer;
begin
  W := 0; // avoid warning
  if assigned(CurrentPage) then
  begin
    case ViewStyle of
    vsPrintLayout:
      begin
        RemoveScrollbars;
        // make sure right scrollbar doesn't show for ANY Page size
        // also looks a little prettier
        H := ClientHeight - 4 * cBorderSizePx; // changed by J.F. Apr 2011
        W := ClientWidth - 4 * cBorderSizePx; // changed by J.F. Apr 2011
        ScreenDpm := Min(H / CurrentPage.DocHeight, W / CurrentPage.DocWidth);
        // This will update scrollbars
        AdjustSizeToPage(nil);
      end;
    vsNormal:
      begin
        RemoveScrollbars;
        H := ClientHeight - 1;
        W := ClientWidth  - 1;
        ScreenDpm := Min(H / CurrentPage.DocHeight, W / CurrentPage.DocWidth);
        // This will update scrollbars
        AdjustSizeToPage(nil);
      end;
    end;

    if CurrentPage.DocWidth > 0 then
    begin
      FZoomPercent := (CurrentPage.DocWidth * ScreenDpm) / W * 100;
    end;
    UpdateRulers;
  end;
end;

procedure TdtpDocument.ZoomToWidth;
// Zoom the document so that its width fits within the client window of the parent,
// this procedure is only internally called
var
  W, CW: integer;
begin
  // changed by J.F. Feb 2011
  if assigned(CurrentPage) then
  begin
    case ViewStyle of
    vsPrintLayout:
      begin
        RemoveScrollbars;
        CW := ClientWidth;
        W := CW - 2 * cBorderSizePx - 2;
        // Set ScreenDpm
        ScreenDpm := W / CurrentPage.CurbedWidth;
        // This will update scrollbars
        AdjustSizeToPage(nil);
        if ClientWidth < CW then
        begin
          W := ClientWidth - 2 * cBorderSizePx - 2;
          // Set ScreenDpm, this will resize the page
          ScreenDpm := W / CurrentPage.CurbedWidth;
          // This will update scrollbars
          AdjustSizeToPage(nil);
        end;
      end;
    vsNormal:
      begin
        RemoveScrollbars;
        CW := ClientWidth;
        // Set ScreenDpm, this will resize the page
        ScreenDpm := (CW - 2) / CurrentPage.DocWidth;
        // This will update scrollbars
        AdjustSizeToPage(nil);
        if ClientWidth < CW then
        begin
          ScreenDpm := (ClientWidth - 2) / CurrentPage.DocWidth;
          // This will update scrollbars
          AdjustSizeToPage(nil);
        end;
      end;
    end;
    UpdateRulers;
  end;
end;

procedure TdtpDocument.ZoomWidth;
// Zoom the document so that its width fits within the client window of the parent,
// this procedure is called from the application in order to zoom so the document
// fills the width
begin
//  DoDebugOut(Self, wsInfo, 'ZoomWidth called');
  FZoomPercent := 100;
  ZoomToWidth;
end;

initialization

  // This needs to be loaded only once upon initialisation
  Screen.Cursors[crDtpRotate]         := LoadCursor(HInstance, 'ROTATION');
  Screen.Cursors[crDtpSizeCopy]       := LoadCursor(HInstance, 'SIZECOPY');
  // added by EL
  Screen.Cursors[crDtpCross]          := LoadCursor(HInstance, 'CRDTPCROSS');
  Screen.Cursors[crDtpCrossLine]      := LoadCursor(HInstance, 'CRDTPCROSSLINE');
  Screen.Cursors[crDtpCrossArrow]     := LoadCursor(HInstance, 'CRDTPCROSSARROW');
  Screen.Cursors[crDtpCrossRectangle] := LoadCursor(HInstance, 'CRDTPCROSSRECTANGLE');
  Screen.Cursors[crDtpCrossRndRectangle]  := LoadCursor(HInstance, 'CRDTPCROSSRNDRECTANGLE');   //  added by J.F. June 2011
  Screen.Cursors[crDtpCrossEllipse]   := LoadCursor(HInstance, 'CRDTPCROSSELLIPSE');
  Screen.Cursors[crDtpCrossText]      := LoadCursor(HInstance, 'CRDTPCROSSTEXT');
  Screen.Cursors[crDtpCrossImage]     := LoadCursor(HInstance, 'CRDTPCROSSIMAGE');

  Screen.Cursors[crDtpHorizGuide]     := LoadCursor(HInstance, 'CRDTPHORIZGUIDE');  //  added by J.F. Feb 2011
  Screen.Cursors[crDtpVertGuide]      := LoadCursor(HInstance, 'CRDTPVERTGUIDE');   //  added by J.F. Feb 2011

  Screen.Cursors[crDtpHandGrabber]    := LoadCursor(HInstance, 'CRDTPHANDGRABBER');   //  added by J.F. June 2011
  Screen.Cursors[crDtpHandHover]    := LoadCursor(HInstance, 'CRDTPHANDHOVER');   //  added by J.F. June 2011

  Screen.Cursors[crDtpMagnifier]    := LoadCursor(HInstance, 'CRDTPMAGNIFIER');   //  added by J.F. June 2011

  Screen.Cursors[crDtpDragZoom]    := LoadCursor(HInstance, 'CRDTPDRAGZOOM');   //  added by J.F. June 2011

  Screen.Cursors[crDtpZoomIn]    := LoadCursor(HInstance, 'CRDTPZOOMIN');   //  added by J.F. June 2011
  Screen.Cursors[crDtpZoomOut]    := LoadCursor(HInstance, 'CRDTPZOOMOUT');   //  added by J.F. June 2011

  // resource thread
  RegisterResourceClass(TdtpResource);
  FResourceThread := TdtpResourceThread.Create;

finalization

  // resource thread
  FResourceThread.Terminate;
  FResourceThread.WaitFor;
  FreeAndNil(FResourceThread);
  FreeAndNil(FResourceClassList);

end.

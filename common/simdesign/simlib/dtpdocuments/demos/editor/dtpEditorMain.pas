unit dtpEditorMain;
{
  unit dtpEditorMain

  This unit implements most of the demo editor program used to test the TdtpDocument
  component and TdtpShape descendants.

  Project: DTP-Engine

  Creation Date: 07-Aug-2003 (Nils Haeck)
  Version: 2.0

  Copyright (c) 2003 - 2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  IMPORTANT NOTE:
  Please read the README.TXT file in the same directory as this file for
  installation issues. It also provides details on how to add GIF and PNG
  support to the editor (only for source version).

  Note that DtpDocuments *must* be installed before you can open the demo.

  This source code may not be used or replicated without prior permission
  from the abovementioned author.

  contributors
  15apr2011: added TfrPolygonMemoShape (canuck)

}

{$i simdesign.inc}

{$define supportJpg} // we use SimDesign's NativeJpg by default
{$define supportPng} // by default CWBudde's GR32_PNG is included, but you can undefine it
{.$define supportGif} // include Anders Melander's GIFImage (old version)

// if defined, DtpEditor can add/remove the filetype association for *.dtp
{$define USEASSOC}

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ComCtrls, ToolWin, Menus, ImgList, ExtCtrls,  StdCtrls, ExtDlgs,
  Printers, ShellApi, Math,
{$ifdef USEASSOC}
  ShellUtils, // ShellUtils is in folder simlib\disk
{$endif USEASSOC}

  // simdesign units
  sdVirtualScrollbox, dtpRsRuler, ColorPickerButton, sdOptionRefs, NativeXml, sdDebug,

  // dtpdocuments units
  dtpPage, dtpDocument, dtpShape, dtpTextShape, fraBase, fraShape, fraTextBaseShape,
  {$ifndef usePolygonText} fraTextShape,{$endif} dtpExposedMetafile, dtpGraphics, fraEffectBase, fraExposedMetafile,
  dtpEffectShape, fraEffect, dtpColoreffects, dtpShadowEffects, dtpBitmapShape,
  dtpRasterFormats, dtpFreehandShape, frmAddPageWiz, fraBitmapShape, dtpPolygonShape,
  fraPolygonShape, dtpMemoShape, {$ifndef usePolygonMemo} fraMemoShape,{$endif} fraPolygonMemoShape, dtpLineShape,
  fraLineShape, dtpResource, fraRoundRectShape, dtpPolygonText, fraPolygonText,
  fraCurvedText, fraWavyText, dtpProjectiveText, dtpTextureEffects, dtpTestProcedures,
  frmHistogram, dtpHandles, dtpW2K3Handles, dtpCropBitmap, dtpWorkshop, fraGradientInlay,

  // Sources for the readers and writers of many of the formats here are not included
  // in DtpDocuments by default. These are 3rd party libraries.

  {$ifdef supportJpg}dtpRasterJPG,{$endif}  // Using Simdesigns NativeJpg implementation
  {$ifdef supportPng}dtpRasterPNG,{$endif}  // Portable Network Graphics (Christian W Budde)
  {$ifdef supportGif}dtpRasterGIF,{$endif}  // compuserve GIF
  {$ifdef supportTif}dtpRasterTIF,{$endif}  // TIFF (Tagged Image File Format)
  {$ifdef supportJ2k}dtpRasterJ2K,{$endif}  // Jpeg 2000 (lossless)

  dtpDefaults;


type

  // A quick way to publish some protected properties we need to set
  TControlAccess = class(TControl)
  published
    property DragCursor;
  end;

  // main form of the editor
  TfrmMain = class(TForm)
    sbMain: TStatusBar;
    mnuMain: TMainMenu;
    alMain: TActionList;
    ilMain: TImageList;
    File1: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    cbMain: TCoolBar;
    ToolBar1: TToolBar;
    acFileOpen: TAction;
    acFileNew: TAction;
    acFileSave: TAction;
    acFileSaveAs: TAction;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    pnlMain: TPanel;
    lvThumbs: TListView;
    spThumbs: TSplitter;
    pnlTop: TPanel;
    pnlLeft: TPanel;
    spLeft: TSplitter;
    acZoomWidth: TAction;
    acZoomPage: TAction;
    acZoomPlus: TAction;
    acZoomMinus: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    tbAdd: TToolButton;
    pmShapeAdd: TPopupMenu;
    acShapeAddText: TAction;
    acShapeAddBitmap: TAction;
    AddTextShape1: TMenuItem;
    AddPhotoShape1: TMenuItem;
    acStyleLayout: TAction;
    acStyleNormal: TAction;
    ZoomWidth1: TMenuItem;
    ZoomPage1: TMenuItem;
    ZoomIn1: TMenuItem;
    Zoomout1: TMenuItem;
    N1: TMenuItem;
    PrintLayout1: TMenuItem;
    AddTextShape2: TMenuItem;
    acHelpersNone: TAction;
    acHelpersGrid: TAction;
    acHelpersPattern: TAction;
    acMargin: TAction;
    N2: TMenuItem;
    NoHelpers1: TMenuItem;
    ShowGrid1: TMenuItem;
    ShowPattern1: TMenuItem;
    N3: TMenuItem;
    ShowMargin1: TMenuItem;
    ToolButton9: TToolButton;
    acDelete: TAction;
    ilThumbs: TImageList;
    acViewThumbs: TAction;
    acViewToolbar: TAction;
    acViewEditpane: TAction;
    N4: TMenuItem;
    acViewToolbar1: TMenuItem;
    acViewEditpane1: TMenuItem;
    acViewThumbs1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N5: TMenuItem;
    acExit: TAction;
    acExit1: TMenuItem;
    acPageAdd: TAction;
    acPageInsert: TAction;
    N6: TMenuItem;
    Addnewpageatend1: TMenuItem;
    InsertPage1: TMenuItem;
    acPageNext: TAction;
    acPagePrev: TAction;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    pcEdit: TPageControl;
    tsShape: TTabSheet;
    tsPage: TTabSheet;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    tsDocument: TTabSheet;
    pnlTitle: TPanel;
    lblTitle: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    tsEffect: TTabSheet;
    acUndo: TAction;
    Undo1: TMenuItem;
    N7: TMenuItem;
    acShapeAddMeta: TAction;
    AddMetafile1: TMenuItem;
    tsUser: TTabSheet;
    Panel2: TPanel;
    Label3: TLabel;
    Label2: TLabel;
    edRenderDPI: TEdit;
    Label4: TLabel;
    cbbResampleMethod: TComboBox;
    acMoveBack: TAction;
    acMoveFwd: TAction;
    acMoveToBg: TAction;
    acMoveToFg: TAction;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    acGroup: TAction;
    acUngroup: TAction;
    Shape1: TMenuItem;
    Addshape1: TMenuItem;
    AddPhotoShape2: TMenuItem;
    AddTextShape3: TMenuItem;
    AddMetafile2: TMenuItem;
    acRedo: TAction;
    acCut: TAction;
    acCopy: TAction;
    acPaste: TAction;
    Redo1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    N8: TMenuItem;
    MoveBack1: TMenuItem;
    MoveFwd1: TMenuItem;
    ToBkgnd1: TMenuItem;
    ToFgnd1: TMenuItem;
    N9: TMenuItem;
    Group1: TMenuItem;
    Ungroup1: TMenuItem;
    Align1: TMenuItem;
    Align2: TMenuItem;
    acAnchors: TAction;
    acHelpersDots: TAction;
    acHelpersDots1: TMenuItem;
    acPrint: TAction;
    Print1: TMenuItem;
    acAlignLft: TAction;
    acAlignCtr: TAction;
    acAlignRgt: TAction;
    acAlignTop: TAction;
    acAlignMid: TAction;
    acAlignBtm: TAction;
    AlignLeft1: TMenuItem;
    AlignCenter1: TMenuItem;
    AlignRight1: TMenuItem;
    AlignTop1: TMenuItem;
    AlignMiddle1: TMenuItem;
    AlignBottom1: TMenuItem;
    ToolButton20: TToolButton;
    pmAlignment: TPopupMenu;
    AlignLeft2: TMenuItem;
    AlignCenter2: TMenuItem;
    AlignRight2: TMenuItem;
    AlignTop2: TMenuItem;
    AlignMiddle2: TMenuItem;
    AlignBottom2: TMenuItem;
    acAlign: TAction;
    acSnapToGrid: TAction;
    acSnapToGrid1: TMenuItem;
    acAutoThumbUpdate: TAction;
    N10: TMenuItem;
    AutomaticThumbnailupdate1: TMenuItem;
    Label5: TLabel;
    cbbPrintQuality: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    cbbDefaultPageSize: TComboBox;
    chbDefaultLandscape: TCheckBox;
    edDefaultPageWidth: TEdit;
    Bevel1: TBevel;
    Label8: TLabel;
    edDefaultMarginLeft: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    edDefaultMarginTop: TEdit;
    Label11: TLabel;
    edDefaultMarginRight: TEdit;
    Label12: TLabel;
    edDefaultMarginBottom: TEdit;
    Bevel2: TBevel;
    Label13: TLabel;
    edDefaultGridSize: TEdit;
    cpbDefaultPageCol: TColorPickerButton;
    Label14: TLabel;
    cpbDefaultGridCol: TColorPickerButton;
    Label15: TLabel;
    Label16: TLabel;
    edDefaultPageHeight: TEdit;
    chbIsDefaultPage: TCheckBox;
    Label17: TLabel;
    Bevel3: TBevel;
    Label18: TLabel;
    edPageWidth: TEdit;
    edPageHeight: TEdit;
    Label19: TLabel;
    cpbPageColor: TColorPickerButton;
    chbLandscape: TCheckBox;
    cbbPageSize: TComboBox;
    Label20: TLabel;
    Bevel4: TBevel;
    Label21: TLabel;
    edMarginLeft: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    edMarginTop: TEdit;
    Label24: TLabel;
    edMarginRight: TEdit;
    Label25: TLabel;
    edMarginBottom: TEdit;
    Bevel5: TBevel;
    Label26: TLabel;
    edGridSize: TEdit;
    cpbGridColor: TColorPickerButton;
    Label27: TLabel;
    rgMultiSelectMethod: TRadioGroup;
    acHotzoneAlways: TAction;
    HotzoneScrolling1: TMenuItem;
    Page1: TMenuItem;
    Addnewpageatend2: TMenuItem;
    Insertpagehere1: TMenuItem;
    NextPage1: TMenuItem;
    PreviousPage1: TMenuItem;
    acPageEditName: TAction;
    N11: TMenuItem;
    EditPageName1: TMenuItem;
    Bevel6: TBevel;
    Label28: TLabel;
    Label29: TLabel;
    edThumbWidth: TEdit;
    Label30: TLabel;
    edThumbHeight: TEdit;
    acPrintPage: TAction;
    Printcurrentpage1: TMenuItem;
    acAbout: TAction;
    Help1: TMenuItem;
    About1: TMenuItem;
    rgPerformance: TRadioGroup;
    chbDefaultTiled: TCheckBox;
    chbDefaultBgrImage: TCheckBox;
    Bevel7: TBevel;
    chbBackgroundImage: TCheckBox;
    chbBackgroundTiled: TCheckBox;
    Bevel8: TBevel;
    acShapeAddPolyline: TAction;
    N12: TMenuItem;
    acShapeAddEllipse: TAction;
    acShapeAddRectangle: TAction;
    acShapeAddRoundRect: TAction;
    AddEllipse1: TMenuItem;
    AddRectangle1: TMenuItem;
    Addroundedrectangle1: TMenuItem;
    acShapeAddMemo: TAction;
    AddMemoShape1: TMenuItem;
    acShapeAddLine: TAction;
    acShapeAddLine1: TMenuItem;
    acHelpContents: TAction;
    Contents1: TMenuItem;
    N13: TMenuItem;
    AddMemoShape2: TMenuItem;
    AddLineShape1: TMenuItem;
    AddEllipse2: TMenuItem;
    AddRectangle2: TMenuItem;
    AddRoundedRectangle2: TMenuItem;
    acShapeDelete: TAction;
    acPageDelete: TAction;
    DeletePage1: TMenuItem;
    DeleteShapes1: TMenuItem;
    acPageExportAsImage: TAction;
    N14: TMenuItem;
    ExportasImage1: TMenuItem;
    acShapeAddFreehand: TAction;
    AddFreehand1: TMenuItem;
    AddFreehand2: TMenuItem;
    acHotzoneMouseDown: TAction;
    acHotzoneNever: TAction;
    N15: TMenuItem;
    Never1: TMenuItem;
    Whenmousedown1: TMenuItem;
    Always1: TMenuItem;
    acStepRotation: TAction;
    StepRotation1: TMenuItem;
    acShapeAddCurvedText: TAction;
    acShapeAddProjectiveText: TAction;
    AddSpecialTextshape1: TMenuItem;
    acShapeAddCurvedText1: TMenuItem;
    acShapeAddProjectiveText1: TMenuItem;
    mnuAddSpecialTextShape: TMenuItem;
    AddCurvedText1: TMenuItem;
    AddProjectiveText1: TMenuItem;
    acShapeAddWavyText: TAction;
    AddWavyText1: TMenuItem;
    AddWavyText2: TMenuItem;
    btnTest: TButton;
    btnAbort: TButton;
    acToolHistogram: TAction;
    Tools1: TMenuItem;
    Histogram1: TMenuItem;
    acToolAutoLevels: TAction;
    AutoLevels1: TMenuItem;
    pnlDocument: TPanel;
    pnlRulerTop: TPanel;
    rsrCorner: TdtpRsRulerCorner;
    rsrTop: TdtpRsRuler;
    pnlRulerLeft: TPanel;
    rsrLeft: TdtpRsRuler;
    acRulers: TAction;
    ShowRulers1: TMenuItem;
    acHandlesW2K3: TAction;
    Word2003Handles1: TMenuItem;
    pmZOrder: TPopupMenu;
    MoveBack2: TMenuItem;
    MoveFwd2: TMenuItem;
    ToBkgnd2: TMenuItem;
    ToFgnd2: TMenuItem;
    acShapeAddCropBitmap: TAction;
    AddCropBitmap1: TMenuItem;
    AddCropBitmap2: TMenuItem;
    mmMessages: TMemo;
    acShapeAddPolygonText: TAction;
    AddPolygonText1: TMenuItem;
    Document: TdtpDocument;
    tsDebug: TTabSheet;
    pnlDebug: TPanel;
    pnlClear: TPanel;
    mmDebug: TMemo;
    btnClear: TButton;
    N16: TMenuItem;
    Guides1: TMenuItem;
    ShowGuides1: TMenuItem;
    SnapToGuides1: TMenuItem;
    GuidestoFront1: TMenuItem;
    DeleteCurrentPageGuides1: TMenuItem;
    LockGuides1: TMenuItem;
    acSnapToGuides: TAction;
    acShowGuides: TAction;
    acGuidesToFront: TAction;
    acLockGuides: TAction;
    ToolButton2: TToolButton;
    ToolButton8: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    acPan: TAction;
    acZoom: TAction;
    acDragZoom: TAction;
    acZoomInOut: TAction;
    N17: TMenuItem;
    DocumentMisc1: TMenuItem;
    ZoomWithMouse1: TMenuItem;
    ZoomWithMouseWheel1: TMenuItem;
    ZoomWithRectangle1: TMenuItem;
    ShowPageShadow1: TMenuItem;
    GuideHintsEnabled1: TMenuItem;
    acShowGuideHints: TAction;
    acZoomWithMouseWheel: TAction;
    acZoomWithMouseButton: TAction;
    acZoomWithRectangle: TAction;
    acShowPageShadow: TAction;
    acPanWithMouseButton: TAction;
    PanWithMouseButton1: TMenuItem;
    chbShapeNudge: TCheckBox;
    Label31: TLabel;
    edShapeNudgeDistance: TEdit;
    Label32: TLabel;
    edMouseWheelScrollSpeed: TEdit;
    Label33: TLabel;
    edZoomStep: TEdit;
    cpbGuideColor: TColorPickerButton;
    Label34: TLabel;
    Grid1: TMenuItem;
    N18: TMenuItem;
    DeleteAllDocumentGuides1: TMenuItem;
    MarginsLocked1: TMenuItem;
    acLockMargins: TAction;
    acShowMarginHints: TAction;
    ShowMarginHints1: TMenuItem;
    ShowShapeHints1: TMenuItem;
    acShowShapeHints: TAction;
    mnuAddFiletypeAssoc: TMenuItem;
    mnuRemoveFiletypeAssoc: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure acZoomWidthExecute(Sender: TObject);
    procedure acZoomPageExecute(Sender: TObject);
    procedure acStyleLayoutExecute(Sender: TObject);
    procedure acStyleNormalExecute(Sender: TObject);
    procedure acMarginExecute(Sender: TObject);
    procedure acHelpersNoneExecute(Sender: TObject);
    procedure acHelpersGridExecute(Sender: TObject);
    procedure acHelpersPatternExecute(Sender: TObject);
    procedure acFileOpenExecute(Sender: TObject);
    procedure acFileNewExecute(Sender: TObject);
    procedure acFileSaveExecute(Sender: TObject);
    procedure acFileSaveAsExecute(Sender: TObject);
    procedure lvThumbsData(Sender: TObject; Item: TListItem);
    procedure acViewThumbsExecute(Sender: TObject);
    procedure acViewToolbarExecute(Sender: TObject);
    procedure acViewEditpaneExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure lvThumbsExit(Sender: TObject);
    procedure acPageAddExecute(Sender: TObject);
    procedure acPageInsertExecute(Sender: TObject);
    procedure acPagePrevExecute(Sender: TObject);
    procedure acPageNextExecute(Sender: TObject);
    procedure acShapeAddTextExecute(Sender: TObject);
    procedure acZoomPlusExecute(Sender: TObject);
    procedure acZoomMinusExecute(Sender: TObject);
    procedure acUndoExecute(Sender: TObject);
    procedure acShapeAddMetaExecute(Sender: TObject);
    procedure edRenderDPIExit(Sender: TObject);
    procedure cbbResampleMethodChange(Sender: TObject);
    procedure acMoveBackExecute(Sender: TObject);
    procedure acMoveFwdExecute(Sender: TObject);
    procedure acMoveToBgExecute(Sender: TObject);
    procedure acMoveToFgExecute(Sender: TObject);
    procedure acGroupExecute(Sender: TObject);
    procedure acUngroupExecute(Sender: TObject);
    procedure acHelpersDotsExecute(Sender: TObject);
    procedure acPrintExecute(Sender: TObject);
    procedure acAlignLftExecute(Sender: TObject);
    procedure acAlignCtrExecute(Sender: TObject);
    procedure acAlignRgtExecute(Sender: TObject);
    procedure acAlignTopExecute(Sender: TObject);
    procedure acAlignMidExecute(Sender: TObject);
    procedure acAlignBtmExecute(Sender: TObject);
    procedure acAlignExecute(Sender: TObject);
    procedure acCutExecute(Sender: TObject);
    procedure acCopyExecute(Sender: TObject);
    procedure acPasteExecute(Sender: TObject);
    procedure acSnapToGridExecute(Sender: TObject);
    procedure lvThumbsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure lvThumbsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure acAutoThumbUpdateExecute(Sender: TObject);
    procedure cbbPrintQualityChange(Sender: TObject);
    procedure chbDefaultLandscapeClick(Sender: TObject);
    procedure cpbDefaultPageColChange(Sender: TObject);
    procedure edDefaultPageWidthExit(Sender: TObject);
    procedure edDefaultPageHeightExit(Sender: TObject);
    procedure cbbDefaultPageSizeChange(Sender: TObject);
    procedure edDefaultMarginLeftExit(Sender: TObject);
    procedure edDefaultMarginRightExit(Sender: TObject);
    procedure edDefaultMarginTopExit(Sender: TObject);
    procedure edDefaultMarginBottomExit(Sender: TObject);
    procedure edDefaultGridSizeExit(Sender: TObject);
    procedure cpbDefaultGridColChange(Sender: TObject);
    procedure chbIsDefaultPageClick(Sender: TObject);
    procedure cbbPageSizeChange(Sender: TObject);
    procedure chbLandscapeClick(Sender: TObject);
    procedure edPageWidthExit(Sender: TObject);
    procedure edPageHeightExit(Sender: TObject);
    procedure cpbPageColorChange(Sender: TObject);
    procedure edMarginLeftExit(Sender: TObject);
    procedure edMarginTopExit(Sender: TObject);
    procedure edMarginRightExit(Sender: TObject);
    procedure edMarginBottomExit(Sender: TObject);
    procedure edGridSizeExit(Sender: TObject);
    procedure cpbGridColorChange(Sender: TObject);
    procedure rgMultiSelectMethodClick(Sender: TObject);
    procedure acHotzoneAlwaysExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lvThumbsEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure acPageEditNameExecute(Sender: TObject);
    procedure lvThumbsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edThumbHeightExit(Sender: TObject);
    procedure edThumbWidthExit(Sender: TObject);
    procedure lvThumbsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure acPrintPageExecute(Sender: TObject);
    procedure lvThumbsClick(Sender: TObject);
    procedure acShapeAddBitmapExecute(Sender: TObject);
    procedure tbAddClick(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure lvThumbsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure rgPerformanceClick(Sender: TObject);
    procedure chbDefaultBgrImageClick(Sender: TObject);
    procedure chbDefaultTiledClick(Sender: TObject);
    procedure chbBackgroundImageClick(Sender: TObject);
    procedure chbBackgroundTiledClick(Sender: TObject);
    procedure acShapeAddPolylineExecute(Sender: TObject);
    procedure acShapeAddEllipseExecute(Sender: TObject);
    procedure acShapeAddRectangleExecute(Sender: TObject);
    procedure acShapeAddRoundRectExecute(Sender: TObject);
    procedure acShapeAddMemoExecute(Sender: TObject);
    procedure acShapeAddLineExecute(Sender: TObject);
    procedure acHelpContentsExecute(Sender: TObject);
    procedure acShapeDeleteExecute(Sender: TObject);
    procedure acPageDeleteExecute(Sender: TObject);
    procedure acPageExportAsImageExecute(Sender: TObject);
    procedure acShapeAddFreehandExecute(Sender: TObject);
    procedure acHotzoneMouseDownExecute(Sender: TObject);
    procedure acHotzoneNeverExecute(Sender: TObject);
    procedure acStepRotationExecute(Sender: TObject);
    procedure acRedoExecute(Sender: TObject);
    procedure acShapeAddCurvedTextExecute(Sender: TObject);
    procedure acShapeAddProjectiveTextExecute(Sender: TObject);
    procedure acShapeAddWavyTextExecute(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure acToolHistogramExecute(Sender: TObject);
    procedure acToolAutoLevelsExecute(Sender: TObject);
    procedure acRulersExecute(Sender: TObject);
    procedure acHandlesW2K3Execute(Sender: TObject);
    procedure rsrCornerClick(Sender: TObject);
    procedure acShapeAddCropBitmapExecute(Sender: TObject);
    procedure acShapeAddPolygonTextExecute(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure MouseButtonPan(Sender: TObject);
    procedure MouseButtonZoom(Sender: TObject);
    procedure MouseButtonDragZoom(Sender: TObject);
    procedure MouseButtonZoomInOut(Sender: TObject);
    procedure acSnapToGuidesExecute(Sender: TObject);
    procedure acShowGuidesExecute(Sender: TObject);
    procedure acGuidestoFrontExecute(Sender: TObject);
    procedure acLockGuidesExecute(Sender: TObject);
    procedure DeleteCurrentPageGuidesClick(Sender: TObject);
    procedure acShowGuideHintsExecute(Sender: TObject);
    procedure chbShapeNudgeClicked(Sender: TObject);
    procedure acShowPageShadowExecute(Sender: TObject);
    procedure acZoomWithRectangleExecute(Sender: TObject);
    procedure acZoomWithMouseButtonExecute(Sender: TObject);
    procedure acZoomWithMouseWheellExecute(Sender: TObject);
    procedure acPanWithMouseButtonExecute(Sender: TObject);
    procedure edShapeNudgeDistanceExit(Sender: TObject);
    procedure edMouseWhellScrollSpeedWxit(Sender: TObject);
    procedure edZoomStepExit(Sender: TObject);
    procedure cpbGuideColorChange(Sender: TObject);
    procedure DeleteAllDocumentGuidesClick(Sender: TObject);
    procedure acLockMarginsExecute(Sender: TObject);
    procedure acShowMarginHintsExecute(Sender: TObject);
    procedure acShowShapeHintsExecute(Sender: TObject);
    procedure mnuAddFiletypeAssocClick(Sender: TObject);
    procedure mnuRemoveFiletypeAssocClick(Sender: TObject);
  private
    FAbortTest: boolean;
    FAlignAction: TAction;
    FDragClass: TClass;         // This is the class of the dragged object
    FDragObject: TObject;       // This is the dragged object
    FDragIndex: integer;        // This is the index of the dragged item (if any), or -1
    FDragPage: integer;         // The page index from where we drag
    FDragSource: TObject;       // This is the object from where we're dragging
    FEffectFrame: TfrBase;
    FExpDate: TDateTime;
    FFileName: string;
    FOptions: TOptionsManager;
    FShape: TdtpShape;
    FShapeFrame: TfrBase;
    FUpdating: boolean;
    // User options
    FPrintQuality: integer;
    FRenderDpi: single;
    FResampleMethod: integer;
    FAutoPageUpdate: boolean;
    FMultiSelectMethod: integer;
    FHotzoneScrolling: integer;
    FRenderAtScreenRes: boolean;
    FPerformance: integer;
    procedure AddFilesWizard(AList: TStrings);
    function AskSaveDocument: TModalResult;
    procedure BitmapDblClick(Sender: TObject);
    procedure DeleteSelectedPages;
    procedure DeleteSelectedShapes;
    function GetFrameClassForShape(AShape: TdtpShape): TfrBaseClass;
    function GetFrameClassForEffect(AShape: TdtpShape): TfrBaseClass;
    procedure LoadDocument(const AFileName: string);
    procedure LoadUserSettings;
    procedure SaveDocument(const AFileName: string);
    procedure SaveUserSettings;
    procedure SetStatusText(const AText: string);
    procedure UserSettingsFromDocument;
    procedure UserSettingsToDocument;
    procedure UpdateAll;
    procedure UpdateCaption;
    procedure UpdateMenu;
    procedure UpdateTabs;
    procedure wmDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
    property AbortTest: boolean read FAbortTest write FAbortTest;
  published
    procedure DtpDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
    procedure DocumentChanged(Sender: TObject);
    procedure DocumentDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DocumentDragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: Boolean);
    procedure DocumentFocusShape(Sender: TObject; Shape: TdtpShape);
    procedure DocumentMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DocumentPageChanged(Sender: TObject; Page: TdtpPage);
    procedure DocumentProgress(Sender: TObject; AType: TdtpProgressType; ACount, ATotal: integer;
      APercent: single);
    procedure DocumentSelectionChanged(Sender: TObject);
    procedure DocumentShapeChanged(Sender: TObject; Shape: TdtpShape);
    procedure DocumentShapeEditClosed(Sender: TObject; Shape: TdtpShape);
    procedure DocumentShapeInsertClosed(Sender: TObject; Shape: TdtpShape);
    procedure DocumentShapeLoadAdditionalInfo(Sender: TObject; Shape: TdtpShape; Node: TXmlNode);
    procedure DocumentStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure BitmapDrawQualityIndicator(Sender: TObject; Canvas: TCanvas; var Rect: TRect; Quality: integer; var Drawn: boolean);
  end;

var
  frmMain: TfrmMain;

const

  cApplicationName    = 'Desktop Publishing Demo';
  cApplicationVersion = 'v1.1';
  cUntitled           = 'Untitled';
  cDefaultText: Utf8String = 'Type text';
  cDefaultMemo: widestring =
    'This is a memo text. It is designed to do wordwrap.' + #13#10 + #13#10 +
    'Does it work correctly?';
  cStatusFreehand     = '[Enter] = Terminate, [Space] = Close + Terminate, [Esc] = Cancel';
  cDtpDocumentFilter  = 'Document files (*.dtp)|*.dtp|' +
                        'All files (*.*)|*.*';
  cMetafileFilter     = 'Metafiles (*.wmf, *.emf)|*.wmf;*.emf|'+
                        'All Files (*.*)|*.*';
  cUserOptionsRegKey  = '\Software\Simdesign\dtpTestApp';

  // Foreign texts, encoded as UTF-8. These texts can be pasted into the edit
  // boxes to enter them in the document, to test unicode and your fonts.

  // The Delphi7 editor is not unicode enabled, so that's why this approach is
  // taken in the demo. These are UTF8-encoded sample texts
  cDefaultTextHebrew: Utf8String  = 'סקירת הטכנולוגיה';
  cDefaultTextKorean: Utf8String  = ' 웹 브라우저로 인터넷의 무한한 가능성을 경험해 보십시오.';
  cDefaultTextRussian: Utf8String = 'Обзор технологии';

  // Demo expires on...
  cExpiryYear         = 2050;
  cExpiryMonth        = 1;
  cExpiryDay          = 1;

implementation

{$R *.DFM}

{$IFDEF SUPPORTXP}
{$R WINXP}
uses
  ThemeMgr;
{$ENDIF}

{$R DROPCURSORS.RES} // Load these additional cursors
const
  // Cursor constants
  crCopy       = 101;
  crMove       = 102;
  crLink       = 103;
  crCopyScroll = 104;
  crMoveScroll = 105;
  crLinkScroll = 106;

{ TfrmMain }

procedure TfrmMain.acAboutExecute(Sender: TObject);
begin
  ShowMessage(
    'This is a demo application for the DtpDocuments component suite.'#13#13 +
    Format('DtpDocuments version: %s', [Document.Version]) + #13#13 +
    'Author and Copyright: N. Haeck M.Sc. (Simdesign B.V.)'#13#13 +
    'For more information please visit: http://www.simdesign.nl'#13#13 +
    'This demo uses freeware components from:'#13+
    '- Roos Software (TRsRuler, TRsRulerCorner)'#13+
    '- Dipl. Ing. Mike Lischke - public@lischke-online.de (TColorPickerButton)'#13#13 +
    'This demo expires on: ' + FormatDateTime('DDDD DD MMM YYYY', FExpDate)
  );
end;

procedure TfrmMain.acAlignBtmExecute(Sender: TObject);
begin
  FAlignAction := TAction(Sender);
  Document.AlignBottom;
  UpdateMenu;
end;

procedure TfrmMain.acAlignCtrExecute(Sender: TObject);
begin
  FAlignAction := TAction(Sender);
  Document.AlignCenter;
  UpdateMenu;
end;

procedure TfrmMain.acAlignExecute(Sender: TObject);
begin
  if not assigned(FAlignAction) then
    FAlignAction := acAlignLft;
  FAlignAction.Execute;
end;

procedure TfrmMain.acAlignLftExecute(Sender: TObject);
begin
  FAlignAction := TAction(Sender);
  Document.AlignLeft;
  UpdateMenu;
end;

procedure TfrmMain.acAlignMidExecute(Sender: TObject);
begin
  FAlignAction := TAction(Sender);
  Document.AlignMiddle;
  UpdateMenu;
end;

procedure TfrmMain.acAlignRgtExecute(Sender: TObject);
begin
  FAlignAction := TAction(Sender);
  Document.AlignRight;
  UpdateMenu;
end;

procedure TfrmMain.acAlignTopExecute(Sender: TObject);
begin
  FAlignAction := TAction(Sender);
  Document.AlignTop;
  UpdateMenu;
end;

procedure TfrmMain.acAutoThumbUpdateExecute(Sender: TObject);
begin
  Document.AutoPageUpdate := not Document.AutoPageUpdate;
  UpdateMenu;
end;

procedure TfrmMain.acCopyExecute(Sender: TObject);
begin
  Document.Copy;
  UpdateMenu;
end;

procedure TfrmMain.acCutExecute(Sender: TObject);
begin
  Document.Cut;
  UpdateMenu;
end;

procedure TfrmMain.DeleteAllDocumentGuidesClick(Sender: TObject);
begin
  Document.DeleteAllDocumentGuides;
end;

procedure TfrmMain.DeleteCurrentPageGuidesClick(Sender: TObject);
begin
  Document.CurrentPage.DeleteAllGuides;
end;

procedure TfrmMain.acDeleteExecute(Sender: TObject);
begin
  // Find out what to delete, pages or shapes
  if lvThumbs.Focused then
    acPageDeleteExecute(Sender)
  else
    acShapeDeleteExecute(Sender)
end;

procedure TfrmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.acFileNewExecute(Sender: TObject);
begin
  if Document.Modified then
    case AskSaveDocument of
    mrYes: acFileSave.Execute;
    mrNo:;
    mrCancel: exit;
    end;
  Document.New;
  FFileName := '';
  UpdateAll;
end;

procedure TfrmMain.acFileOpenExecute(Sender: TObject);
begin
  if Document.Modified then
    case AskSaveDocument of
    mrYes: acFileSave.Execute;
    mrNo:;
    mrCancel: exit;
    end;
  with TOpenDialog.Create(nil) do
  begin
    try
      Filter := cDtpDocumentFilter;
      Title := 'Load Document';
      if Execute then
      begin
        LoadDocument(FileName);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain.acFileSaveAsExecute(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
  begin
    try
      Filter := cDtpDocumentFilter;
      Title := 'Save Document';
      Options := Options + [ofOverwritePrompt];
      if Execute then
      begin
        SaveDocument(FileName);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain.acFileSaveExecute(Sender: TObject);
begin
  if Length(FFileName) = 0 then
  begin
    acFileSaveAsExecute(Sender);
    exit;
  end;
  SaveDocument(FFileName);
end;

procedure TfrmMain.acGroupExecute(Sender: TObject);
begin
  Document.Group;
end;

procedure TfrmMain.acShowGuideHintsExecute(Sender: TObject);
begin
  Document.ShowGuideHints:= not Document.ShowGuideHints;
  UpdateMenu;
end;

procedure TfrmMain.acGuidestoFrontExecute(Sender: TObject);
begin
  Document.GuidesToFront:= not Document.GuidesToFront;
  UpdateMenu;
end;

procedure TfrmMain.acHelpContentsExecute(Sender: TObject);
begin
  // Open the help file
  ShellExecute(Handle, 'open', PChar(ChangeFileExt(Application.ExeName, '.chm')), nil, nil, SW_SHOWDEFAULT);
end;

procedure TfrmMain.acHelpersDotsExecute(Sender: TObject);
begin
  Document.HelperMethod := hmDots;
  UpdateMenu;
end;

procedure TfrmMain.acHelpersGridExecute(Sender: TObject);
begin
  Document.HelperMethod := hmGrid;
  UpdateMenu;
end;

procedure TfrmMain.acHelpersNoneExecute(Sender: TObject);
begin
  Document.HelperMethod := hmNone;
  UpdateMenu;
end;

procedure TfrmMain.acHelpersPatternExecute(Sender: TObject);
begin
  Document.HelperMethod := hmPattern;
  UpdateMenu;
end;

procedure TfrmMain.acHotzoneAlwaysExecute(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.HotzoneScrolling := hzsAlways;
  UpdateMenu;
end;

procedure TfrmMain.acHotzoneMouseDownExecute(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.HotzoneScrolling := hzsWhenMouseDown;
  UpdateMenu;
end;

procedure TfrmMain.acHotzoneNeverExecute(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.HotzoneScrolling := hzsNoScroll;
  UpdateMenu;
end;

procedure TfrmMain.acLockGuidesExecute(Sender: TObject);
begin
  Document.GuidesLocked:= not Document.GuidesLocked;
  UpdateMenu;
end;

procedure TfrmMain.acLockMarginsExecute(Sender: TObject);
begin
  Document.MarginsLocked := not Document.MarginsLocked;
  UpdateMenu;
end;

procedure TfrmMain.acMarginExecute(Sender: TObject);
begin
  Document.ShowMargins := not Document.ShowMargins;
  UpdateMenu;
end;

procedure TfrmMain.acRulersExecute(Sender: TObject);
begin
  acRulers.Checked := not acRulers.Checked;
  pnlRulerTop.Visible := acRulers.Checked;
  pnlRulerLeft.Visible := acRulers.Checked;
end;

procedure TfrmMain.acMoveBackExecute(Sender: TObject);
begin
  Document.MoveBack;
end;

procedure TfrmMain.acMoveFwdExecute(Sender: TObject);
begin
  Document.MoveFront;
end;

procedure TfrmMain.acMoveToBgExecute(Sender: TObject);
begin
  Document.MoveToBackground;
end;

procedure TfrmMain.acMoveToFgExecute(Sender: TObject);
begin
  Document.MoveToForeground;
end;

procedure TfrmMain.acPageAddExecute(Sender: TObject);
begin
  Document.PageAdd(nil); // Signals a default page
  UpdateMenu;
end;

procedure TfrmMain.acPageDeleteExecute(Sender: TObject);
begin
  DeleteSelectedPages;
end;

procedure TfrmMain.acPageEditNameExecute(Sender: TObject);
begin
  with lvThumbs do
    if assigned(ItemFocused) then
      ItemFocused.EditCaption;
end;

procedure TfrmMain.acPageExportAsImageExecute(Sender: TObject);
var
  AFiler: TdtpImageFiler;
  ADib: TdtpBitmap;
begin
{$ifdef usePicturePreview}
  with TSavePictureDialog.Create(Application) do
{$else}
  with TSaveDialog.Create(Application) do
{$endif}
    try
      Title := 'Save page as raster image';
      Filter := RasterFormatSaveFilter;
      DefaultExt := '.jpg';
      if Execute then
      begin
        Screen.Cursor := crHourglass;
        try
          // Export to a Bitmap32, without effects (pages usually don't have
          // effects)
          ADib := Document.CurrentPage.ExportToBitmap(
            round(Document.CurrentPage.DocWidth * 20),
            round(Document.CurrentPage.DocHeight * 20), 0, dtPrinter);
          try
            // Create a filer that will save it for us
            AFiler := TdtpImageFiler.Create;
            try
              AFiler.FileName := FileName;
              AFiler.SaveDIB(ADib);
            finally
              AFiler.Free;
            end;
          finally
            ADib.Free;
          end;
        finally
          Screen.Cursor := crDefault;
        end;
      end;
    finally
      free;
    end;
end;

procedure TfrmMain.acPageInsertExecute(Sender: TObject);
begin
  Document.PageInsert(Document.CurrentPageIndex, nil); // "nil" signals a default page
  UpdateMenu;
end;

procedure TfrmMain.acPageNextExecute(Sender: TObject);
var
  APageIndex: integer;
begin
  if Document.CurrentPageIndex < Document.PageCount - 1 then
  begin
    APageIndex := Document.CurrentPageIndex + 1;
    lvThumbs.Selected := nil;
    lvThumbs.Selected := lvThumbs.Items[APageIndex];
    Document.CurrentPageIndex := APageIndex;
    UpdateMenu;
  end;
end;

procedure TfrmMain.acPagePrevExecute(Sender: TObject);
var
  PageIdx: integer;
begin
  if Document.CurrentPageIndex > 0 then
  begin
    PageIdx := Document.CurrentPageIndex - 1;
    lvThumbs.Selected := nil;
    lvThumbs.Selected := lvThumbs.Items[PageIdx];
    Document.CurrentPageIndex := PageIdx;
    UpdateMenu;
  end;
end;

procedure TfrmMain.acPanWithMouseButtonExecute(Sender: TObject);
begin
  Document.PanWithMouseButton := not Document.PanWithMouseButton;
  UpdateMenu;
end;

procedure TfrmMain.acPasteExecute(Sender: TObject);
begin
  Document.Paste;
  UpdateMenu;
end;

procedure TfrmMain.acPrintExecute(Sender: TObject);
var
  i, PageIndex, AStart, ACount: integer;
  AFileName: string;
  ASelection: array of integer;
begin
  // Check if there is a printer
  if Printer.Printers.Count = 0 then
  begin
    ShowMessage('There is no printer installed. Please install a printer first.');
    exit;
  end;
  // Show the print dialog
  with TPrintDialog.Create(nil) do
  begin
    try
      // Options
      Options := [poPageNums];
      if lvThumbs.SelCount > 0 then
        Options := Options + [poSelection];
      // Pages
      MinPage  := 1;
      FromPage := 1;
      MaxPage  := Document.PageCount;
      ToPage   := Document.PageCount;
      if Execute then begin
        // Print title
        if Length(FFileName) = 0 then
          AFileName := cUntitled
        else
          AFileName := ExtractFileName(FFileName);
        Printer.Title := AFileName;
        // Range options
        if PrintRange = prAllPages then
        begin

          // just print all pages
          Document.Print;

        end else
          if PrintRange = prSelection then
          begin

            // Get the selected pages
            with lvThumbs do
            begin
              ACount := SelCount;
              SetLength(ASelection, ACount);
              PageIndex := 0;
              for i := 0 to Items.Count - 1 do
                if Items[i].Selected then
                begin
                  ASelection[PageIndex] := i;
                  inc(PageIndex);
                end;
            end;
            Document.PrintSelection(ASelection, ACount);

          end else
          begin

            // From..to range
            AStart := FromPage - 1;
            ACount := ToPage - FromPage + 1;
            Document.Print(AStart, ACount);

          end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain.acPrintPageExecute(Sender: TObject);
begin
  // Check if there is a printer
  if Printer.Printers.Count = 0 then
  begin
    ShowMessage('There is no printer installed. Please install a printer first.');
    exit;
  end;
  Document.Print(Document.CurrentPageIndex);
end;

procedure TfrmMain.acRedoExecute(Sender: TObject);
begin
  Document.Redo;
end;

procedure TfrmMain.acShapeAddBitmapExecute(Sender: TObject);
// Add a bitmap shape
var
  BS: TdtpBitmapShape;
begin
  BS := nil;
{$ifdef usePicturePreview}
  with TOpenPictureDialog.Create(application) do
{$else}
  with TOpenDialog.Create(application) do // easier to debug
{$endif}
    try
      Title := 'Open a raster image';
      Filter := RasterFormatOpenFilter;
      if Execute then
      begin
        BS := TdtpBitmapShape.Create;
        BS.Image.LoadFromFile(FileName);
      end;
    finally
      Free;
    end;
  if assigned(BS) then
    Document.InsertShapeByDrag(BS);
end;

procedure TfrmMain.acShapeAddCropBitmapExecute(Sender: TObject);
// Add a crop bitmap shape
var
  CB: TdtpCropBitmap;
begin
  CB := TdtpCropBitmap.Create;
  if assigned(CB) then
    Document.InsertShapeByDrag(CB);
end;

procedure TfrmMain.acShapeAddCurvedTextExecute(Sender: TObject);
var
  CT: TdtpCurvedText;
begin
  CT := TdtpCurvedText.Create;
  CT.Text := cDefaultText;
  CT.CurveAngle := 10;
  Document.InsertShapeByClick(CT);
end;

procedure TfrmMain.acShapeAddEllipseExecute(Sender: TObject);
var
  ES: TdtpEllipseShape;
begin
  ES := TdtpEllipseShape.Create;
  // test
  ES.PopupMenu := pmZOrder;
  SetPolygonShapeDefaults(ES);
  Document.InsertShapeByDrag(ES);
end;

procedure TfrmMain.acShapeAddFreehandExecute(Sender: TObject);
// Add a freehand shape
var
  FH: TdtpFreehandShape;
begin
  FH := TdtpFreehandShape.Create;
  SetPolygonShapeDefaults(FH);
  FH.UseFill := False;
  SetStatusText(cStatusFreehand);
  with Document do
  begin
    FH.Recording := True;
    InsertShapeByClick(FH);
  end;
end;

procedure TfrmMain.acShapeAddLineExecute(Sender: TObject);
var
  LS: TdtpLineShape;
begin
  LS := TdtpLineShape.Create;
  Document.InsertShapeByDrag(LS);
end;

procedure TfrmMain.acShapeAddMemoExecute(Sender: TObject);
// Add a polygon memo shape
var
  PM: TdtpPolygonMemo;
  //PM: TdtpMemoShape;
begin
  PM := TdtpPolygonMemo.Create;
  //PM := TdtpMemoShape.Create;
  PM.FontHeightPts := 12;
  //PM.Lines.Text := cDefaultMemo;
  PM.Text := cDefaultMemo;
  PM.ShowHint := True;
  PM.Hint := 'Doubleclick to edit';
  Document.InsertShapeByClick(PM);
end;

procedure TfrmMain.acShapeAddMetaExecute(Sender: TObject);
// Add a metafile shape
var
  MF: TdtpExposedMetafile;
begin
{$ifdef usePicturePreview}
  with TOpenPictureDialog.Create(nil) do
{$else}
  with TOpenDialog.Create(nil) do
{$endif}
  begin
    try
      Title := 'Open a metafile from disk';
      Filter := cMetafileFilter;
      if Execute then
      begin
        MF := TdtpExposedMetafile.Create;
        MF.Image.LoadFromFile(FileName);
        Document.InsertShapeByDrag(MF);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain.acShapeAddPolylineExecute(Sender: TObject);
// Add a polyline shape (testing)
var
  PS: TdtpPolygonShape;
begin
  PS := TdtpPolygonShape.Create;
  SetPolygonShapeDefaults(PS);
  Document.InsertShapeByClick(PS);
end;

procedure TfrmMain.acShapeAddProjectiveTextExecute(Sender: TObject);
// Add a projective text shape
var
  PT: TdtpProjectiveText;
begin
  PT := TdtpProjectiveText.Create;
  PT.Text := cDefaultText;
  Document.InsertShapeByClick(PT);
end;

procedure TfrmMain.acShapeAddRectangleExecute(Sender: TObject);
var
  RS: TdtpRectangleShape;
begin
  RS := TdtpRectangleShape.Create;
  SetPolygonShapeDefaults(RS);
  Document.InsertShapeByDrag(RS);
end;

procedure TfrmMain.acShapeAddRoundRectExecute(Sender: TObject);
var
  RR: TdtpRoundRectShape;
begin
  RR := TdtpRoundRectShape.Create;
  SetPolygonShapeDefaults(RR);
  Document.InsertShapeByDrag(RR);
end;

procedure TfrmMain.acShapeAddTextExecute(Sender: TObject);
// Add a text shape

{$ifndef usePolygonText}
var
  TS: TdtpTextShape;
{$endif}
begin
  {$ifndef usePolygonText}
  TS := TdtpTextShape.Create;

  // Use line below to test unicode support. The string contains UTF8 encoded
  // characters.
  //TS.Text := sdUtf8ToUnicode(cDefaultTextHebrew);
  //TS.Text := sdUtf8ToUnicode(cDefaultTextKorean);
  //TS.Text := sdUtf8ToUnicode(cDefaultTextRussian);
  TS.Text := cDefaultText;
  TS.ShowHint := True;
  TS.Hint := 'Doubleclick to edit';
  Document.InsertShapeByClick(TS);
  {$else}
  acShapeAddPolygonTextExecute(Sender);
  {$endif}
end;

procedure TfrmMain.acShapeAddPolygonTextExecute(Sender: TObject);
// Add a polygon text shape
var
  PT: TdtpPolygonText;
begin
  PT := TdtpPolygonText.Create;

  // Use line below to test unicode support. The string contains UTF8 encoded
  // characters.
  //  AText.Text := sdUtf8ToUnicode(cDefaultTextHebrew);
  PT.Text := cDefaultText;
  PT.ShowHint := True;
  PT.Hint := 'Doubleclick to edit';
  //  PT.AutoSize := False;
  //  PT.Alignment := taRightJustify;
  //  PT.CharacterSpacing := 0.1;
  Document.InsertShapeByClick(PT);
end;

procedure TfrmMain.acShapeAddWavyTextExecute(Sender: TObject);
// Add a wavy text
var
  WT: TdtpWavyText;
begin
  WT := TdtpWavyText.Create;
  WT.Text := cDefaultText;
  WT.WaveX.WaveLength := 20;
  WT.WaveX.Amplitude := 2;
  Document.InsertShapeByClick(WT);
end;

procedure TfrmMain.acShapeDeleteExecute(Sender: TObject);
begin
  DeleteSelectedShapes;
end;

procedure TfrmMain.chbShapeNudgeClicked(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.ShapeNudgeEnabled:= chbShapeNudge.Checked;
end;

procedure TfrmMain.acShowGuidesExecute(Sender: TObject);
begin
  Document.GuidesVisible:= not Document.GuidesVisible;
  UpdateMenu;
end;

procedure TfrmMain.acShowMarginHintsExecute(Sender: TObject);
begin
  Document.ShowMarginHints:= not Document.ShowMarginHints;
  UpdateMenu;
end;

procedure TfrmMain.acShowPageShadowExecute(Sender: TObject);
begin
  Document.ShowPageShadow:= not Document.ShowPageShadow;
end;

procedure TfrmMain.acShowShapeHintsExecute(Sender: TObject);
begin
  Document.ShowShapeHints:= not Document.ShowShapeHints;
  UpdateMenu;
end;

procedure TfrmMain.acSnapToGridExecute(Sender: TObject);
begin
  Document.SnapToGrid := not Document.SnapToGrid;
  UpdateMenu;
end;

procedure TfrmMain.acSnapToGuidesExecute(Sender: TObject);
begin
  Document.SnapToGuides:= not Document.SnapToGuides;
  UpdateMenu;
end;

procedure TfrmMain.acStepRotationExecute(Sender: TObject);
begin
  if Document.StepAngle = 0 then
    Document.StepAngle := 5
  else
    Document.StepAngle := 0;
  UpdateMenu;
end;

procedure TfrmMain.acStyleLayoutExecute(Sender: TObject);
begin
  Document.ViewStyle := vsPrintLayout;
  UpdateMenu;
end;

procedure TfrmMain.acStyleNormalExecute(Sender: TObject);
begin
  Document.ViewStyle := vsNormal;
  UpdateMenu;
end;

procedure TfrmMain.acUndoExecute(Sender: TObject);
begin
  Document.Undo;
end;

procedure TfrmMain.acUngroupExecute(Sender: TObject);
begin
  Document.Ungroup;
end;

procedure TfrmMain.acViewEditpaneExecute(Sender: TObject);
begin
  spLeft.Visible  := not spLeft.Visible;
  pnlLeft.Visible := not pnlLeft.Visible;
  UpdateMenu;
end;

procedure TfrmMain.acViewThumbsExecute(Sender: TObject);
begin
  lvThumbs.Visible := not lvThumbs.Visible;
  spThumbs.Visible := not spThumbs.Visible;
  UpdateMenu;
end;

procedure TfrmMain.acViewToolbarExecute(Sender: TObject);
begin
  cbMain.Visible := not cbMain.Visible;
  UpdateMenu;
end;

procedure TfrmMain.acZoomMinusExecute(Sender: TObject);
begin
  Document.ZoomOut;
end;

procedure TfrmMain.acZoomPageExecute(Sender: TObject);
begin
  Document.ZoomPage;
end;

procedure TfrmMain.acZoomPlusExecute(Sender: TObject);
begin
  Document.ZoomIn;
end;

procedure TfrmMain.acZoomWidthExecute(Sender: TObject);
begin
  Document.ZoomWidth;
end;

procedure TfrmMain.acZoomWithMouseButtonExecute(Sender: TObject);
begin
  Document.ZoomWithMouseButton:= not Document.ZoomWithMouseButton;
  UpdateMenu;
end;

procedure TfrmMain.acZoomWithMouseWheellExecute(Sender: TObject);
begin
  Document.ZoomWithMouseWheel:= not Document.ZoomWithMouseWheel;
  UpdateMenu;
end;

procedure TfrmMain.acZoomWithRectangleExecute(Sender: TObject);
begin
  Document.ZoomWithRectangle:= not Document.ZoomWithRectangle;
  UpdateMenu;
end;

procedure TfrmMain.AddFilesWizard(AList: TStrings);
var
  StartPage: integer;
  Margin: single;
begin
  with TfmAddPageWiz.Create(nil) do
    try
      FFiles := AList;
      UpdateStats;
      if ShowModal = mrOK then
      begin
        // First page on which to add images
        StartPage := Document.PageCount - 1;
        if chbStartNewPage.Checked then
          inc(StartPage);
        // Margin
        Margin := Min(100, Max(0, StrToFloat(edMargin.Text)));
        // Invoke the wizard
        DoAddFilesWizard(Document, AList, 1 shl rgPerPage.ItemIndex, StartPage,
          chbAutoCorrect.Checked, chbAddShadow.Checked, chbAddRandom.Checked,
          Margin / 2);
      end;
    finally
      Free;
    end;
end;

function TfrmMain.AskSaveDocument: TModalResult;
var
  DocName, Msg: string;
begin
  DocName := ExtractFileName(FFileName);
  if Length(DocName) > 0 then
    Msg := Format('Document "%s" has been changed. Do you wish to save changes?', [DocName])
  else
    Msg := 'The current document has been changed. Do you wish to save changes?';
  Result := MessageDlg(Msg, mtWarning, [mbYes,mbNo,mbCancel], 0);
end;

procedure TfrmMain.cbbDefaultPageSizeChange(Sender: TObject);
var
  PaperSize: TPaperSizeInfoRec;
begin
  if FUpdating then
    exit;
  // Avoid invalid or Custom index
  if (cbbDefaultPageSize.ItemIndex < 0) or (cbbDefaultPageSize.ItemIndex >= cPaperSizeCount - 1) then
    exit;
  // Get data
  PaperSize := cPaperSizes[cbbDefaultPageSize.ItemIndex];
  if chbDefaultLandscape.Checked then
  begin
    Document.DefaultPageWidth  := PaperSize.Height;
    Document.DefaultPageHeight := PaperSize.Width;
  end else
  begin
    Document.DefaultPageWidth  := PaperSize.Width;
    Document.DefaultPageHeight := PaperSize.Height;
  end;
  UpdateTabs;
end;

procedure TfrmMain.cbbPageSizeChange(Sender: TObject);
var
  PaperSize: TPaperSizeInfoRec;
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  // Avoid invalid or Custom index
  if (cbbPageSize.ItemIndex < 0) or (cbbPageSize.ItemIndex >= cPaperSizeCount - 1) then
    exit;
  // Get data
  PaperSize := cPaperSizes[cbbPageSize.ItemIndex];
  if chbLandscape.Checked then
  begin
    Document.CurrentPage.PageWidth  := PaperSize.Height;
    Document.CurrentPage.PageHeight := PaperSize.Width;
  end else
  begin
    Document.CurrentPage.PageWidth  := PaperSize.Width;
    Document.CurrentPage.PageHeight := PaperSize.Height;
  end;
  UpdateTabs;
end;

procedure TfrmMain.cbbPrintQualityChange(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.PrintQuality := TPrintQualityType(cbbPrintQuality.ItemIndex);
end;

procedure TfrmMain.cbbResampleMethodChange(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.Quality := TdtpStretchFilter(cbbResampleMethod.ItemIndex);
end;

procedure TfrmMain.chbBackgroundImageClick(Sender: TObject);
begin
  if FUpdating then
    exit;
  if chbBackgroundImage.Checked then
  begin
    // User must select a new background image
{$ifdef usePicturePreview}
    with TOpenPictureDialog.Create(nil) do
{$else}
    with TOpenDialog.Create(nil) do
{$endif}
      try
        Title  := 'Select background image';
        Filter := RasterFormatOpenFilter;
        if Execute then
        begin
          // This makes sure the current page is non-default (and it will copy
          // itself from the default values in the document as an instance)
          Document.CurrentPage.IsDefaultPage := False;
          // ..now load another background image
          Document.CurrentPage.BackgroundImage.LoadFromFile(FileName);
        end;
      finally
        Free;
      end;
  end else
    Document.CurrentPage.BackgroundImage.Clear;
end;

procedure TfrmMain.chbBackgroundTiledClick(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.CurrentPage.BackgroundTiled := chbBackgroundTiled.Checked;
end;

procedure TfrmMain.chbDefaultBgrImageClick(Sender: TObject);
begin
  if FUpdating then
    exit;
  if chbDefaultBgrImage.Checked then
  begin
    // User must select a new background image
{$ifdef usePicturePreview}
    with TOpenPictureDialog.Create(nil) do
{$else}
    with TOpenDialog.Create(nil) do
{$endif}
      try
        Title  := 'Select background image';
        Filter := RasterFormatOpenFilter;
        if Execute then
          Document.DefaultBackgroundImage.LoadFromFile(FileName);
      finally
        Free;
      end;
  end else
    Document.DefaultBackgroundImage.Clear;
end;

procedure TfrmMain.chbDefaultTiledClick(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultBackgroundTiled := chbDefaultTiled.Checked;
end;

procedure TfrmMain.chbDefaultLandscapeClick(Sender: TObject);
var
  Temp: single;
begin
  if FUpdating then
    exit;
  // Change Width and Height
  Temp                       := Document.DefaultPageWidth;
  Document.DefaultPageWidth  := Document.DefaultPageHeight;
  Document.DefaultPageHeight := Temp;
  UpdateTabs;
end;

procedure TfrmMain.chbIsDefaultPageClick(Sender: TObject);
// User changes IsDefault state of page
begin
  if FUpdating then
    exit;
  if assigned(Document.CurrentPage) then
    Document.CurrentPage.IsDefaultPage := not Document.CurrentPage.IsDefaultPage;
  UpdateAll;
end;

procedure TfrmMain.chbLandscapeClick(Sender: TObject);
var
  Temp: single;
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  // Change Width and Height
  Temp                            := Document.CurrentPage.PageWidth;
  Document.CurrentPage.PageWidth  := Document.CurrentPage.PageHeight;
  Document.CurrentPage.PageHeight := Temp;
  UpdateTabs;
end;

procedure TfrmMain.cpbDefaultGridColChange(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultGridColor := cpbDefaultGridCol.SelectionColor;
end;

procedure TfrmMain.cpbDefaultPageColChange(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultPageColor := cpbDefaultPageCol.SelectionColor;
end;

procedure TfrmMain.cpbGridColorChange(Sender: TObject);
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  Document.CurrentPage.GridColor := cpbGridColor.SelectionColor;
end;

procedure TfrmMain.cpbGuideColorChange(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.GuideColor := cpbGuideColor.SelectionColor;
end;

procedure TfrmMain.cpbPageColorChange(Sender: TObject);
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  Document.CurrentPage.PageColor := cpbPageColor.SelectionColor;
end;

procedure TfrmMain.DeleteSelectedPages;
var
  i: integer;
  L: TList;
  // local
  procedure DeleteList;
  var
    i: integer;
  begin
    for i := L.Count - 1 downto 0 do
      Document.PageDelete(TdtpPage(L[i]).PageIndex);
  end;
// main
begin
  // Get selection
  L := TList.Create;
  try
    // Find list of selected pages
    for i := 0 to lvThumbs.Items.Count - 1 do
      if lvThumbs.Items[i].Selected then
        L.Add(Document.Pages[i]);
    // Checks
    if L.Count = 0 then
      exit;
    if L.Count = 1 then
      if MessageDlg(Format(
          'Do you really want to delete %s?', [TdtpPage(L[0]).Name]),
          mtConfirmation, mbYesNoCancel, 0) = mrYes then
        // User wants to delete
        DeleteList;
    if L.Count > 1 then
      if MessageDlg(Format(
          'Do you really want to delete %d pages?', [L.Count]),
          mtConfirmation, mbYesNoCancel, 0) = mrYes then
        DeleteList;
  finally
    L.Free;
  end;
end;

procedure TfrmMain.DeleteSelectedShapes;
begin
  with Document do
  begin
    if SelectionCount > 1 then
      if MessageDlg(Format(
          'Do you really want to delete %d shapes?', [SelectionCount]),
          mtConfirmation, mbYesNoCancel, 0) <> mrYes then
        // User opted out
        exit;
    // Do the deletion
    DeleteSelectedShapes;
  end;
end;

procedure TfrmMain.DocumentChanged(Sender: TObject);
begin
  UpdateTabs;
  UpdateMenu;
end;

procedure TfrmMain.DocumentDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  IsCTRL: boolean;
  NewIndex: integer;
begin
  // Get keystate if [CTRL]
  IsCTRL := GetKeyState(VK_CONTROL) < 0;

  // Internal drag/drop?
  if FDragSource = Document then
    with Document do
    begin
      NewIndex := CurrentPageIndex;
      CurrentPageIndex := FDragPage;
      if IsCTRL then
        Document.Copy
      else
        Document.Cut;
      CurrentPageIndex := NewIndex;
      Document.Paste;
    end;

  // Reset
  FDragSource := nil;
  FDragClass  := nil;
  FDragObject := nil;
  FDragIndex  := -1;
  FDragPage   := -1;
end;

procedure TfrmMain.DocumentDragOver(Sender, Source: TObject; X, Y: integer; State: TDragState; var Accept: Boolean);
var
  IsCtrl: boolean;
begin
  // Find keyboard state so that we can choose appropriate mouse cursor
  IsCtrl := (GetKeyState(VK_CONTROL) < 0);

  Accept := (FDragClass = TdtpShape);
  // The rest is only for internal drag
  if not (FDragSource = Document) then
    exit;

  if IsCtrl then
    Document.DragCursor := crCopy
  else
    Document.DragCursor := crMove;
end;

procedure TfrmMain.DocumentFocusShape(Sender: TObject; Shape: TdtpShape);
begin
  if assigned(Shape) then
    pcEdit.ActivePage := tsShape
  else
    pcEdit.ActivePage := tsPage;
  UpdateTabs;
  UpdateMenu;
end;

procedure TfrmMain.DocumentMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  FP: TdtpPoint;
begin
  if assigned(Document.CurrentPage) then
  begin
    FP := Document.CurrentPage.ScreenToShape(Point(X, Y));
    sbMain.Panels[0].Text := Format('X=%6.1f, Y=%6.1f', [FP.X, FP.Y]);
  end else
    sbMain.Panels[0].Text := '';
end;

procedure TfrmMain.DocumentPageChanged(Sender: TObject; Page: TdtpPage);
// Something with a page changed, so we must update the page thumbs listview
var
  L, T: integer;
  B: TBitmap;
  S: string;
begin
  if assigned(Page) then
  begin
    // Set listview size correctly if it weren't. It will clear the list if changed
    ilThumbs.Width  := Document.ThumbnailWidth;
    ilThumbs.Height := Document.ThumbnailHeight;
    // Create new thumbnails in advance
    if Page.PageIndex >= ilThumbs.Count then
    begin
      // The page needs a thumbnail
      B := TBitmap.Create;
      try
        B.Width  := ilThumbs.Width;
        B.Height := ilThumbs.Height;
        // Draw empty thumbnail
        with B.Canvas do
        begin
          Pen.Color   := clBlack;
          Font.Color := clBlack;
          Font.Size  := 24;
          Font.Name  := 'Arial';
          S := '?';
          L := (B.Width  - TextWidth(S)) div 2;
          T := (B.Height - TextHeight(S)) div 2;
          TextOut(L, T, S);
        end;
        while Page.PageIndex >= ilThumbs.Count do
          ilThumbs.Add(B, nil);
      finally
        B.Free;
      end;
    end;
    // Update the page's thumbnail in ilThumbs
    if (Page.PageIndex >= 0) and (Page.PageIndex < ilThumbs.Count) then
      // Replace the thumbnail at PageIndex
      ilThumbs.Replace(Page.PageIndex, Page.Thumbnail, nil);
  end;
  // Number of pages
  if lvThumbs.Items.Count <> Document.PageCount then
    lvThumbs.Items.Count := Document.PageCount;
  lvThumbs.Invalidate;
end;

procedure TfrmMain.DocumentProgress(Sender: TObject; AType: TdtpProgressType; ACount, ATotal: integer; APercent: single);
// OnProgress messages
var
  Verb: string;
begin
  //
  case AType of
  ptLoad:   Verb := 'Loading';
  ptPrint:  Verb := 'Printing';
  ptSave:   Verb := 'Saving';
  ptWizard: Verb := 'Creating';
  end;

  case AType of
  ptLoad, ptPrint, ptSave, ptWizard:
    begin
      if APercent < 1 then
        SetStatusText(Format('%s page %d of %d (%d%%)...',
          [Verb, ACount, ATotal, round(APercent * 100)]))
      else
        SetStatusText(Format('%s complete', [Verb]))
    end;
  end;//case
end;

procedure TfrmMain.DocumentSelectionChanged(Sender: TObject);
begin
  UpdateTabs;
  UpdateMenu;
end;

procedure TfrmMain.DocumentShapeChanged(Sender: TObject; Shape: TdtpShape);
begin
  UpdateTabs;
  UpdateMenu;
end;

procedure TfrmMain.DocumentShapeEditClosed(Sender: TObject; Shape: TdtpShape);
begin
  SetStatusText('');
end;

procedure TfrmMain.DocumentShapeInsertClosed(Sender: TObject; Shape: TdtpShape);
begin
  if not assigned(Shape) then
    SetStatusText('Insert cancelled');
  Document.FocusedShape := Shape;
  UpdateAll;
end;

procedure TfrmMain.DocumentShapeLoadAdditionalInfo(Sender: TObject; Shape: TdtpShape; Node: TXmlNode);
begin
  // Here we catch TdtpSnapBitmap shapes, because whenever loaded or copied, they
  // must be given the method to open a file on their ondblclick
  if Shape.ClassType = TdtpSnapBitmap then
  begin
    Shape.OnDblClick := BitmapDblClick;
  end;
end;

procedure TfrmMain.DocumentStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  Document.DragCursor := crMove;
  FDragClass  := TdtpShape;
  FDragObject := Document.FocusedShape;
  FDragPage   := Document.CurrentPageIndex;
  if assigned(Document.FocusedShape) then
    FDragIndex  := Document.FocusedShape.Index
  else
    FDragIndex  := -1;
  FDragSource := Document;
end;

procedure TfrmMain.edDefaultGridSizeExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultGridSize := StrToFloat(edDefaultGridSize.Text);
end;

procedure TfrmMain.edDefaultMarginBottomExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultMarginBottom := StrToFloat(edDefaultMarginBottom.Text);
end;

procedure TfrmMain.edDefaultMarginLeftExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultMarginLeft := StrToFloat(edDefaultMarginLeft.Text);
end;

procedure TfrmMain.edDefaultMarginRightExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultMarginRight := StrToFloat(edDefaultMarginRight.Text);
end;

procedure TfrmMain.edDefaultMarginTopExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultMarginTop := StrToFloat(edDefaultMarginTop.Text);
end;

procedure TfrmMain.edDefaultPageHeightExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultPageHeight := StrToFloat(edDefaultPageHeight.Text);
end;

procedure TfrmMain.edDefaultPageWidthExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.DefaultPageWidth := StrToFloat(edDefaultPageWidth.Text);
end;

procedure TfrmMain.edGridSizeExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  Document.CurrentPage.GridSize := StrToFloat(edGridSize.Text);
end;

procedure TfrmMain.edMarginBottomExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  Document.CurrentPage.MarginBottom := StrToFloat(edMarginBottom.Text);
end;

procedure TfrmMain.edMarginLeftExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  Document.CurrentPage.MarginLeft := StrToFloat(edMarginLeft.Text);
end;

procedure TfrmMain.edMarginRightExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  Document.CurrentPage.MarginRight := StrToFloat(edMarginRight.Text);
end;

procedure TfrmMain.edMarginTopExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  Document.CurrentPage.MarginTop := StrToFloat(edMarginTop.Text);
end;

procedure TfrmMain.edPageHeightExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  Document.CurrentPage.PageHeight := StrToFloat(edPageHeight.Text);
end;

procedure TfrmMain.edPageWidthExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  if not assigned(Document.CurrentPage) then
    exit;
  Document.CurrentPage.PageWidth := StrToFloat(edPageWidth.Text);
end;

procedure TfrmMain.edRenderDpiExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.ScreenDPI := StrToFloat(edRenderDPI.Text);
end;

procedure TfrmMain.edThumbHeightExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.ThumbnailHeight := StrToInt(edThumbHeight.Text);
end;

procedure TfrmMain.edThumbWidthExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.ThumbnailWidth := StrToInt(edThumbWidth.Text);
end;

procedure TfrmMain.edZoomStepExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.ZoomStep := StrToFloat(edZoomStep.Text);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
// Ask the user to save (if there are changes)
begin
  if Document.Modified then
    case AskSaveDocument of
    mrYes: acFileSave.Execute;
    mrNo:;
    mrCancel: CanClose := False;
    end;// case
end;

procedure TfrmMain.FormCreate(Sender: TObject);
// FormCreate is called just after initialisation
var
  i: integer;
begin
  // Windows XP support
  {$IFDEF SUPPORTXP}
  TThemeManager.Create(Self);
  {$ENDIF}

  // Application title appearing in windows
  Application.Title := cApplicationName;

  // Check expiry
  FExpDate := EncodeDate(cExpiryYear, cExpiryMonth, cExpiryDay);
  if FExpDate < Date then
  begin
    ShowMessage(
      'Sorry, this demo has expired on ' + FormatDateTime('DD MMM YYYY', FExpDate) + '.'#13#13 +
      'Please get a new demo from: http://www.simdesign.nl'#13 +
      'or email to: n.haeck@simdesign.nl'
    );
    Halt(0);
  end;

  // Window size
  SetBounds(15, 15, Screen.Width - 30, Screen.Height - 30);

  // General settings
  FUpdating := True;
  try
    ilThumbs.Width  := cDefaultThumbnailWidth;
    ilThumbs.Height := cDefaultThumbnailHeight;
    lvThumbs.DoubleBuffered := True;

    cbbPrintQuality.Items.Clear;
    for i := 0 to cPrintQualityCount - 1 do
      cbbPrintQuality.Items.Add(cPrintQualityNames[i]);

    cbbDefaultPageSize.Items.Clear;
    for i := 0 to cPaperSizeCount - 1 do
      cbbDefaultPageSize.Items.Add(cPaperSizes[i].Name);
    cbbPageSize.Items.Assign(cbbDefaultPageSize.Items);

    pcEdit.ActivePage := tsDocument;

  finally
    FUpdating := False;
  end;

  Document.ShowMargins := False;

  // tests
  // OnKeyPress := DocumentKeyPress;
  // ReadOnly := True;
  // Cursor := crSizeNESW;
  // FDocument.ArchiveDirect := True;
  Document.FontEmbedding := True;
  Document.OptimizedPrinting := True;

  // Set Modified to false after applying all document settings
  Document.Modified := False;
  // start sending debug messages
  Document.OnDebugOut := DtpDebug;

  // Load user settings
  LoadUserSettings;

  // Read the command line for actions
  if length(ParamStr(1)) > 0 then
  begin
    if lowercase(ExtractFileExt(ParamStr(1))) = '.dtp' then
    begin
      // A collection file
      LoadDocument(ParamStr(1));
    end;
  end;

  // Accept dropped files (ShellAPI)
  DragAcceptFiles(handle, true);

  {filetype association}
{$ifdef USEASSOC}
  if IsRegFileType('dtp.file', '.dtp') then
  begin
    mnuAddFileTypeAssoc.Enabled := False;
    mnuRemoveFileTypeAssoc.Enabled := True;
  end else
  begin
    mnuAddFileTypeAssoc.Enabled := True;
    mnuRemoveFileTypeAssoc.Enabled := False;
  end;
{$else USEASSOC}
  mnuAddFileTypeAssoc.Visible := False;
  mnuRemoveFileTypeAssoc.Visible := False;
{$endif USEASSOC}

  UpdateAll;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // stop sendig debug messages
  Document.OnDebugOut := nil;
  SaveUserSettings;
end;

function TfrmMain.GetFrameClassForEffect(AShape: TdtpShape): TfrBaseClass;
begin
  Result := nil;
  // Basic class
  if AShape is TdtpShape then
    Result := TfrEffectBase;
  if AShape is TdtpEffectShape then
    Result := TfrEffect;
end;

function TfrmMain.GetFrameClassForShape(AShape: TdtpShape): TfrBaseClass;
// contributor: canuck, added TfrPolygonMemoShape
begin
  Result := nil;
  // Basic class
  if AShape is TdtpShape then
    Result := TfrShape;
  {$ifndef usePolygonText}
  if AShape is TdtpTextShape then
    Result := TfrTextShape;
  {$endif}
  {$ifndef usePolygonMemo}
  if AShape is TdtpMemoShape then
    Result := TfrMemoShape;
  {$endif}
  if AShape is TdtpPolygonText then
    Result := TfrPolygonText;
  if AShape is TdtpPolygonMemo then
    Result := TfrPolygonMemoShape;
  if AShape is TdtpCurvedText then
    Result := TfrCurvedText;
  if AShape is TdtpWavyText then
    Result := TfrWavyText;
  if AShape is TdtpExposedMetafile then
    Result := TfrExposedMetafile;
  if AShape is TdtpBitmapShape then
    Result := TfrBitmapShape;
  if AShape is TdtpPolygonShape then
    Result := TfrPolygonShape;
  if AShape is TdtpRoundRectShape then
    Result := TfrRoundRectShape;
  if AShape is TdtpLineShape then
    Result := TfrLineShape;
end;

procedure TfrmMain.LoadDocument(const AFileName: string);
// Load a new document
begin
  UserSettingsFromDocument;
  Document.LoadFromFile(AFileName);
  FFileName := AFileName;
  UserSettingsToDocument;
  UpdateAll;
end;

procedure TfrmMain.LoadUserSettings;
// Load the user settings from a the registry
begin
  // First create a TOptionsManager object to handle this for us
  FreeAndNil(FOptions);
  FOptions := TOptionsManager.Create(Self);

  // Set user option defaults
  FPrintQuality      := integer(pqLow);
  FRenderDpi         := 150;
  FResampleMethod    := integer(dtpsfLinear);
  FAutoPageUpdate    := False;
  FMultiSelectMethod := integer(msmSimple);
  FHotzoneScrolling  := integer(hzsNoScroll);
  FRenderAtScreenRes := False;
  FPerformance       := integer(dpMemoryOverSpeed);

  with FOptions do
  begin
    // Add all user options to it
    Add(FPrintQuality,      'Render',    'PrintQuality');
    Add(FRenderDpi,         'Render',    'RenderDPI');
    Add(FResampleMethod,    'Render',    'ResampleMethod');
    Add(FAutoPageUpdate,    'Render',    'AutoPageUpdate');
    Add(FMultiSelectMethod, 'Selection', 'MultiSelectMethod');
    Add(FHotzoneScrolling,  'View',      'HotzoneScrolling');
    Add(FRenderAtScreenRes, 'Render',    'RenderAtScreenRes');
    Add(FPerformance,       'Render',    'Performance');

    // Load options
    {$IFDEF USEREG}
    LoadFromReg(cUserOptionsRegKey);
    {$ELSE}
    LoadFromINI(ChangeFileExt(Application.ExeName, '.ini'));
    {$ENDIF}
  end;

  // Some sane limitations
  FRenderDpi := Max(70, Min(FRenderDpi, 600));

  // Set document options from user settings
  UserSettingsToDocument;
end;

procedure TfrmMain.lvThumbsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
// User clicked on page thumbs or used nav keys in it
var
  PageIndex: integer;
begin
  if not assigned(Item) then
    exit;
  if Change = ctState then
  begin
    if assigned(lvThumbs.ItemFocused) then
    begin
      PageIndex := lvThumbs.ItemFocused.Index;
      Document.CurrentPageIndex := PageIndex;
      if assigned(Document.Pages[PageIndex]) then
        with Document.Pages[PageIndex] do
          if IsThumbnailModified then
            UpdateThumbnail;
    end;
  end;
  UpdateTabs;
  UpdateMenu;
end;

procedure TfrmMain.lvThumbsClick(Sender: TObject);
begin
  // User clicks on a thumbnail - make sure to update (because the OnChange does
  // not happen automatically)
  lvThumbsChange(Sender, lvThumbs.ItemFocused, ctState);
end;

procedure TfrmMain.lvThumbsData(Sender: TObject; Item: TListItem);
var
  Page: TdtpPage;
begin
  if not assigned(Item) then
    exit;
  Page := Document.Pages[Item.Index];
  if not assigned(Page) then
    exit;
  // Name of the page
  Item.Caption := Page.Name;
  // Thumbnail
  Item.ImageIndex := Page.PageIndex;
end;

procedure TfrmMain.lvThumbsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  ADest: TListItem;
  ADestIndex: integer;
  IsCTRL: boolean;
//local
procedure MoveOrCopy(OldIndex, NewIndex: integer; IsCopy: boolean);
begin
  if IsCopy then
  begin
    Document.PageCopy(OldIndex, NewIndex);
  end else
  begin
    Document.PageMove(OldIndex, NewIndex);
  end;
end;
// main
begin
  // Find destination at position X,Y
  with lvThumbs do
  begin
    ADestIndex := -1;
    ADest := GetItemAt(X, Y);
    if not assigned(ADest) then
      ADest := GetNearestItem(Point(X, Y), sdAll);
    if assigned(ADest) then
      ADestIndex := ADest.Index;
  end;

  // Get keystate if [CTRL]
  IsCTRL := GetKeyState(VK_CONTROL) < 0;

  // Internal drag/drop?
  if FDragSource = lvThumbs then
  begin
    if (FDragIndex >= 0) and (FDragIndex < lvThumbs.Items.Count) then
    begin

      // Find item at position X,Y
      if assigned(ADest) then
        with lvThumbs do
        begin
          MoveOrCopy(FDragIndex, ADestIndex, IsCTRL);
          // focus on the new index
          Selected    := nil;
          Selected    := Items[ADestIndex];
          ItemFocused := Items[ADestIndex];
        end;
    end;
  end;

  // External, from document?
  if FDragSource = Document then
  begin
    Document.DoDragClose(False);
    if ADestIndex <> Document.CurrentPageIndex then
    begin
      if IsCtrl then
        Document.Copy
      else
        Document.Cut;
      Document.CurrentPageIndex := ADestIndex;
      Document.Paste;
    end;
  end;

  // Reset
  FDragSource := nil;
  FDragClass  := nil;
  FDragObject := nil;
  FDragIndex  := -1;
end;

procedure TfrmMain.lvThumbsDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  IsCtrl: boolean;
begin
  Accept := (FDragSource = lvThumbs) or (FDragClass = TdtpShape);
  // Find keyboard state so that we can choose appropriate mouse cursor
  IsCtrl := (GetKeyState(VK_CONTROL) < 0);
  if FDragSource is TControl then
    if IsCtrl then
      TControlAccess(FDragSource).DragCursor := crCopy
    else
      TControlAccess(FDragSource).DragCursor := crMove;
end;

procedure TfrmMain.lvThumbsEdited(Sender: TObject; Item: TListItem; var S: String);
// Change the page name after it has been edited in thumbnail view
var
  Page: TdtpPage;
begin
  if not assigned(Item) then
    exit;
  Page := Document.Pages[Item.Index];
  if assigned(Page) then
    Page.Name := S;
end;

procedure TfrmMain.lvThumbsExit(Sender: TObject);
begin
  // Make sure we set acDelete.enabled correctly when exiting page thumbs
  UpdateMenu;
end;

procedure TfrmMain.lvThumbsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
// Catch key input for thumbnail display here
begin
  case Key of
  VK_F2:     acPageEditName.Execute;
  VK_DELETE: DeleteSelectedPages;
  VK_INSERT: acPageInsert.Execute;
  end;//case
end;

procedure TfrmMain.lvThumbsStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  // Record dragindex
  FDragClass  := TListItem;
  FDragIndex  := lvThumbs.ItemFocused.Index;
  FDragObject := lvThumbs.ItemFocused;
  FDragSource := lvThumbs;
end;

procedure TfrmMain.MouseButtonDragZoom(Sender: TObject);
begin
  if Document.ViewerFunction = vfDirectMouseDragZoom then
    Document.ViewerFunction := vfNone
  else
  begin
    Document.ViewerFunction := vfDirectMouseDragZoom;
    ToolButton22.Down:= true;
  end;
end;

procedure TfrmMain.MouseButtonZoomInOut(Sender: TObject);
begin
  if Document.ViewerFunction = vfDirectMouseZoomInOut then
    Document.ViewerFunction := vfNone
  else
  begin
    Document.ViewerFunction:= vfDirectMouseZoomInOut;
    ToolButton23.Down:= true;
  end;
end;

procedure TfrmMain.MouseButtonPan(Sender: TObject);
begin
  if Document.ViewerFunction = vfDirectPanning then
    Document.ViewerFunction := vfNone
  else
  begin
    Document.ViewerFunction:= vfDirectPanning;
    ToolButton8.Down:= true;
  end;
end;

procedure TfrmMain.MouseButtonZoom(Sender: TObject);
begin
  if Document.ViewerFunction = vfDirectMouseButtonZoom then
    Document.ViewerFunction := vfNone
  else
  begin
    Document.ViewerFunction:= vfDirectMouseButtonZoom;
    ToolButton21.Down:= true;
  end;
end;

procedure TfrmMain.rgMultiSelectMethodClick(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.MultiSelectMethod := TMultiSelectMethodType(rgMultiSelectMethod.ItemIndex);
  UpdateTabs;
end;

procedure TfrmMain.rgPerformanceClick(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.Performance := TdtpDocPerformanceType(rgPerformance.ItemIndex);
  UpdateTabs;
end;

procedure TfrmMain.SaveDocument(const AFileName: string);
begin
  with Document do
  begin
    Screen.Cursor := crHourGlass;
    try
      SaveToFile(AFileName);
      FFileName := AFileName;
    finally
      Screen.Cursor := crDefault;
      UpdateAll;
    end;
  end;
end;

procedure TfrmMain.SaveUserSettings;
// Store the options to the registry
begin
  if not assigned(FOptions) then
    exit;

  // Retrieve options
  UserSettingsFromDocument;

  // Save 'em
  {$IFDEF USEREG}
  FOptions.SaveToReg(cUserOptionsRegKey);
  {$ELSE}
  FOptions.SaveToIni(ChangeFileExt(Application.ExeName, '.ini'));
  {$ENDIF}

  // And free options
  FreeAndNil(FOptions);
end;

procedure TfrmMain.SetStatusText(const AText: string);
begin
  sbMain.Panels[1].Text := AText;
  Application.ProcessMessages;
end;

procedure TfrmMain.tbAddClick(Sender: TObject);
begin
  tbAdd.CheckMenuDropdown;
end;

procedure TfrmMain.UpdateAll;
begin
  UpdateCaption;
  UpdateMenu;
  UpdateTabs;
end;

procedure TfrmMain.UpdateCaption;
// Update the title bar caption
var
  FN: string;
begin
  if Length(FFileName) = 0 then
    FN := cUntitled
  else
    FN := FFileName;
  frmMain.Caption := Format('%s %s [%s]', [cApplicationName, cApplicationVersion, FN]);
end;

procedure TfrmMain.UpdateMenu;
// Here we update all actions, their enabled and visible state. This procedure
// is called quite often (after each selection and focus change), so make sure
// to keep it fast.
var
  SelCount: integer;
begin
  with Document do
  begin
    // Store property SelectionCount in local var, to avoid calling GetSelectionCount many times
    SelCount := SelectionCount;
    acStyleLayout.Checked := ViewStyle = vsPrintLayout;
    acStyleNormal.Checked := ViewStyle = vsNormal;
    acPageNext.Enabled := CurrentPageIndex < PageCount - 1;
    acPagePrev.Enabled := CurrentPageIndex > 0;
    acPageEditName.Enabled := assigned(lvThumbs.Selected) and lvThumbs.Focused;
    acUndo.Enabled := UndoCount > 0;
    acRedo.Enabled := RedoCount > 0;
    acHelpersNone.Checked    := HelperMethod = hmNone;
    acHelpersDots.Checked    := HelperMethod = hmDots;
    acHelpersGrid.Checked    := HelperMethod = hmGrid;
    acHelpersPattern.Checked := HelperMethod = hmPattern;
    // Document modes
    acAutoThumbUpdate.Checked   := AutoPageUpdate;
    acHotzoneNever.Checked      := HotzoneScrolling = hzsNoScroll;
    acHotzoneMouseDown.Checked  := HotzoneScrolling = hzsWhenMouseDown;
    acHotzoneAlways.Checked     := HotzoneScrolling = hzsAlways;
    acSnapToGrid.Checked        := SnapToGrid;
    acStepRotation.Checked      := StepAngle > 0;
    if assigned(CurrentPage) then
      with CurrentPage do
        acMargin.Checked := ShowMargins;
    acGroup.Enabled    :=  SelCount > 1;
    acUngroup.Enabled  := (SelCount = 1) and (Selection[0] is TdtpGroupShape);
    acMoveBack.Enabled := (SelCount > 0) and (ShapeCount > SelCount);
    acMoveFwd.Enabled  := (SelCount > 0) and (ShapeCount > SelCount);
    acMoveToBg.Enabled := (SelCount > 0) and (ShapeCount > SelCount);
    acMoveToFg.Enabled := (SelCount > 0) and (ShapeCount > SelCount);
    acAlignLft.Enabled := (SelCount > 1);
    acAlignCtr.Enabled := (SelCount > 1);
    acAlignRgt.Enabled := (SelCount > 1);
    acAlignTop.Enabled := (SelCount > 1);
    acAlignMid.Enabled := (SelCount > 1);
    acAlignBtm.Enabled := (SelCount > 1);
    acAlign.Enabled    := (SelCount > 1);
    if assigned(FAlignAction) then
    begin
      acAlign.ImageIndex := FAlignAction.ImageIndex;
      acAlign.Hint       := FAlignAction.Hint;
    end;
    acCut.Enabled   := SelCount > 0;
    acCopy.Enabled  := SelCount > 0;
    // HasClipboardData actually peeks at the clipboard to see if there's
    // CF_TEXT, and if so, if the first few bytes contain XML.
    acPaste.Enabled := HasClipboardData;
    acDelete.Enabled :=
      (lvThumbs.Focused and (lvThumbs.SelCount > 0)) or // Delete page
      (SelCount > 0);                                  // Delete shape
    acFileSave.Enabled := Modified;

    acSnapToGuides.Checked := SnapToGuides;
    acShowGuides.Checked := GuidesVisible;
    acGuidesToFront.Checked := GuidesToFront;
    acLockGuides.Checked := GuidesLocked;
    acShowGuideHints.Checked := ShowGuideHints;

    acShowMarginHints.Checked := ShowMarginHints;

    acShowShapeHints.Checked := ShowShapeHints;

    acZoomWithMouseButton.Checked := ZoomWithMouseButton;
    acZoomWithMouseWheel.Checked := ZoomWithMouseWheel;
    acZoomWithRectangle.Checked := ZoomWithRectangle;
    acShowPageShadow.Checked := ShowPageShadow;

    acPanWithMouseButton.Checked := PanWithMouseButton;
    acLockMargins.Checked :=  MarginsLocked;

  end;
  acViewThumbs.Checked   := lvThumbs.Visible;
  acViewToolbar.Checked  := cbMain.Visible;
  acViewEditpane.Checked := pnlLeft.Visible;

end;

procedure TfrmMain.UpdateTabs;
// Here, the tabs on the left get interactively updated. The Shape and Effect
// tabs will change their contained frame based on the currently focused shape
var
  FrameBaseClass: TfrBaseClass;
  W, H: single;
  Page: TdtpPage;
  IsDefault: boolean;
begin
  // We set FUpdating to true to signal any event handlers that we're updating,
  // so they should not do anything (to avoid endless loops).
  FUpdating := True;
  try
    // Shape tab
    FShape := Document.FocusedShape;
    if assigned(FShape) and not FShape.Selected then
      FShape := nil;
    if assigned(FShape) then
    begin
      // Get the correct frame class
      FrameBaseClass := GetFrameClassForShape(FShape);
      if not assigned(FShapeFrame) or (FrameBaseClass <> FShapeFrame.ClassType) then
      begin
        // Remove old and insert new frame
        FreeAndNil(FShapeFrame);
        if assigned(FrameBaseClass) then
          FShapeFrame := FrameBaseClass.Create(Self);
      end;
      if assigned(FShapeFrame) then
      begin
        // Set the shape frame "Document" property, this will update it
        FShapeFrame.Document := Document;
        // Set parent
        FShapeFrame.Parent := tsShape;
      end;
    end else
      FreeAndNil(FShapeFrame);

    // Effect tab
    if assigned(FShape) then
    begin
      // Get the correct frame class
      FrameBaseClass := GetFrameClassForEffect(FShape);
      if not assigned(FEffectFrame) or (FrameBaseClass <> FEffectFrame.ClassType) then
      begin
        // Remove old and insert new frame
        FreeAndNil(FEffectFrame);
        if assigned(FrameBaseClass) then
          FEffectFrame := FrameBaseClass.Create(Self);
      end;
      if assigned(FEffectFrame) then
      begin
        // Fill it
        FEffectFrame.Document := Document;
        // Set parent
        FEffectFrame.Parent := tsEffect;
      end;
    end else
    begin
      FreeAndNil(FEffectFrame);
    end;

    // Page tab
    Page := Document.CurrentPage;
    if assigned(Page) then
    begin
      IsDefault := Page.IsDefaultPage;
      chbIsDefaultPage.Checked := IsDefault;
      // Enabled state of controls
      cbbPageSize.Enabled    := not IsDefault;
      chbLandscape.Enabled   := not IsDefault;
      edPageWidth.Enabled    := not IsDefault;
      edPageHeight.Enabled   := not IsDefault;
      cpbPageColor.Enabled   := not IsDefault;
      edMarginLeft.Enabled   := not IsDefault;
      edMarginRight.Enabled  := not IsDefault;
      edMarginTop.Enabled    := not IsDefault;
      edMarginBottom.Enabled := not IsDefault;
      edGridSize.Enabled     := not IsDefault;
      cpbGridColor.Enabled   := not IsDefault;
      // And their values
      W := Page.PageWidth;
      H := Page.PageHeight;
      cbbPageSize.ItemIndex := DefaultPageIndexFromSize(W, H);
      chbLandscape.Checked := W > H;
      edPageWidth.Text  := Format('%3.1f', [W]);
      edPageHeight.Text := Format('%3.1f', [H]);
      cpbPageColor.SelectionColor := Page.PageColor;

      edMarginLeft.Text   := Format('%3.1f', [Page.MarginLeft]);
      edMarginRight.Text  := Format('%3.1f', [Page.MarginRight]);
      edMarginTop.Text    := Format('%3.1f', [Page.MarginTop]);
      edMarginBottom.Text := Format('%3.1f', [Page.MarginBottom]);

      edGridSize.Text := Format('%3.1f', [Page.GridSize]);
      cpbGridColor.SelectionColor := Page.GridColor;

      chbBackgroundImage.Checked := assigned(Page.BackgroundImage.Bitmap);
      chbBackgroundTiled.Checked := Page.BackgroundTiled;
    end;

    // Document tab
    W := Document.DefaultPageWidth;
    H := Document.DefaultPageHeight;
    cbbDefaultPageSize.ItemIndex := DefaultPageIndexFromSize(W, H);
    chbDefaultLandscape.Checked := W > H;
    edDefaultPageWidth.Text  := Format('%3.1f', [W]);
    edDefaultPageHeight.Text := Format('%3.1f', [H]);
    cpbDefaultPageCol.SelectionColor := Document.DefaultPageColor;

    edDefaultMarginLeft.Text   := Format('%3.1f', [Document.DefaultMarginLeft]);
    edDefaultMarginRight.Text  := Format('%3.1f', [Document.DefaultMarginRight]);
    edDefaultMarginTop.Text    := Format('%3.1f', [Document.DefaultMarginTop]);
    edDefaultMarginBottom.Text := Format('%3.1f', [Document.DefaultMarginBottom]);

    edDefaultGridSize.Text := Format('%3.1f', [Document.DefaultGridSize]);
    cpbDefaultGridCol.SelectionColor := Document.DefaultGridColor;

    cpbGuideColor.SelectionColor := Document.GuideColor;

    edThumbWidth.Text  := IntToStr(Document.ThumbnailWidth);
    edThumbHeight.Text := IntToStr(Document.ThumbnailHeight);

    chbDefaultBgrImage.Checked := assigned(Document.DefaultBackgroundImage.Bitmap);
    chbDefaultTiled.Checked := Document.DefaultBackgroundTiled;

    chbShapeNudge.Checked := Document.ShapeNudgeEnabled;
    edShapeNudgeDistance.Text := Format('%3.2f', [Document.ShapeNudgeDistance]);

    edMouseWheelScrollSpeed.Text := intToStr(Document.MouseWheelScrollSpeed);

    edZoomStep.Text := Format('%1.1f', [Document.ZoomStep]);

    // User tab
    edRenderDPI.Text              := IntToStr(round(Document.ScreenDPI));
    cbbResampleMethod.ItemIndex   := integer(Document.Quality);
    cbbPrintQuality.ItemIndex     := integer(Document.PrintQuality);
    rgMultiSelectMethod.ItemIndex := integer(Document.MultiSelectMethod);
    rgPerformance.ItemIndex       := integer(Document.Performance);
  finally
    FUpdating := False;
  end;
end;

procedure TfrmMain.UserSettingsFromDocument;
begin
  // Retrieve options
  FPrintQuality      := integer(Document.PrintQuality);
  FRenderDPI         := Document.ScreenDPI;
  FResampleMethod    := integer(Document.Quality);
  FAutoPageUpdate    := Document.AutoPageUpdate;
  FMultiSelectMethod := integer(Document.MultiSelectMethod);
  FHotzoneScrolling  := integer(Document.HotzoneScrolling);
  FPerformance       := integer(Document.Performance);
end;

procedure TfrmMain.UserSettingsToDocument;
begin
  // Set document options from user settings
  Document.PrintQuality      := TPrintQualityType(FPrintQuality);
  //Document.ScreenDPI         := FRenderDPI;
  Document.Quality           := TdtpStretchFilter(FResampleMethod);
  Document.AutoPageUpdate    := FAutoPageUpdate;
  Document.MultiSelectMethod := TMultiSelectMethodType(FMultiSelectMethod);
  Document.HotzoneScrolling  := TdtpHZScrollingType(FHotzoneScrolling);
  Document.Performance       := TdtpDocPerformanceType(FPerformance);
end;

procedure TfrmMain.wmDropFiles(var Msg: TWMDropFiles);
// The user has dropped files on us
var
  i: integer;
  P: TPoint;
  SL: TStringList;
  Count: integer;
  FileName: array[0..254] of char;
  PT, S: TPoint;
  BS: TdtpBitmapShape;
  Dest: TListItem;
  // local
  procedure DropOnPage(AIndex: integer);
  begin
    with Document do
      if (AIndex >= 0) and (AIndex < PageCount) then
      begin
        CurrentPageIndex := AIndex;
        BS := TdtpBitmapShape.Create;
        BS.Image.LoadFromFile(SL[0]);
        if BS.Image.IsEmpty then
        begin
          BS.Free;
          exit;
        end;
        BS.Left := 20;
        BS.Top  := 20;
        ShapeAdd(BS);
      end;
  end;
// main
begin
  // Get the exact location where the files were dropped
  DragQueryPoint(msg.Drop, P);

  SL := TStringList.Create;
  try

    // Create list of files
    Count := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, 254);

    // Loop through files
    for i := 0 to Count - 1 do
    begin
      // Get filename
      DragQueryFile(Msg.Drop, i, FileName, 254);
      // Add to listbox
      SL.Add(FileName);
    end;
    DragFinish(Msg.Drop);

    // More than one file?
    if SL.Count > 1 then
    begin
      AddFilesWizard(SL);
      exit;
    end;

    // Point in FDocument coordinates
    S := ClientToScreen(P);
    PT := Document.ScreenToClient(S);
    with Document do
      if PtInRect(Rect(0, 0, Width, Height), PT) then
      begin

        // Add file to document
        AcceptFileDrop(SL[0], S);
        exit;
      end;

    // Point in lvThumbs coordinates
    PT := lvThumbs.ScreenToClient(ClientToScreen(P));
    with lvThumbs do
      if PtInRect(Rect(0, 0, Width, Height), PT) then
      begin
        Dest := GetItemAt(PT.X, PT.Y);
        if assigned(Dest) then
        begin
          DropOnPage(Dest.Index);
        end else
        begin
          // Add a new default page
          Document.PageAdd(nil);
          DropOnPage(Document.PageCount - 1);
        end;
        exit;
      end;

    // Future additions here

  finally
    SL.Free;
  end;
end;

procedure TfrmMain.edMouseWhellScrollSpeedWxit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.MouseWheelScrollSpeed := StrToInt(edMouseWheelScrollSpeed.Text);
end;

procedure TfrmMain.edShapeNudgeDistanceExit(Sender: TObject);
begin
  if FUpdating then
    exit;
  Document.ShapeNudgeDistance := StrToFloat(edShapeNudgeDistance.Text);
end;

type TDocAccess = class(TdtpDocument);

procedure TfrmMain.BitmapDblClick(Sender: TObject);
// User double-clicked on a TdtpBitmap shape
begin
{$ifdef usePicturePreview}
  with TOpenPictureDialog.Create(Application) do
{$else}
  with TOpenDialog.Create(Application) do
{$endif}
  begin
    try
      Title := 'Change to another file (choose)';
      Filter := RasterFormatOpenFilter;
      if Execute then
        if Sender is TdtpSnapBitmap then
          // Load.. and set to new dimensions
          TdtpSnapBitmap(Sender).Image.LoadFromFile(FileName);
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain.BitmapDrawQualityIndicator(Sender: TObject; Canvas: TCanvas;
  var Rect: TRect; Quality: integer; var Drawn: boolean);
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    Brush.Color := $FFEEFF;
    FillRect(Rect);
    case Quality of
    // Below 100 is bad quality, draw a red cross
    0..99:    ilMain.Draw(Canvas, Rect.Left + 8, Rect.Top + 8, 10);
    // 100..150 is discutable, draw yellow warning
    100..150: ilMain.Draw(Canvas, Rect.Left + 8, Rect.Top + 8, 41);
    else
      // otherwise its ok, draw green plus
      ilMain.Draw(Canvas, Rect.Left + 8, Rect.Top + 8, 7);
    end;
  end;
  Drawn := True;
end;

type
  TShapeAccess = class(TdtpShape);//to gain access to protected method

procedure TfrmMain.btnTestClick(Sender: TObject);
// This test button can be made visible on the User tab, and then some simple
// tests can be done
var
  S: TdtpShape;
  W, H: integer;
  Dib: TdtpBitmap;
  Device: TDeviceContext;
  Rect: TdtpRect;
begin
  S := Document.Selection[0];
  if not assigned(S) then
    exit;
  // 5 pixels per mm, works for rotated shapes too
  W := round((S.Right - S.Left) * 5);
  H := round((S.Bottom - S.Top) * 5);
  Dib := TdtpBitmap.Create;
  try
    // Set size of bitmap
    Dib.Width := W;
    Dib.Height := H;
    // Setup Device info
    Device.DeviceType := dtTransparent;
    Device.Background := $00000000;
    Device.ActualDpm := 5;
    Device.CacheDpm := 5;
    Device.Quality := dtpsfLinear;
    Device.DropCacheAfterRender := False;
    Device.ForceResolution := False;
    // Setup rectangle
    Rect := dtpRect(S.Left, S.Top, S.Right, S.Bottom);
    // Call protected method
    TShapeAccess(Document.CurrentPage).RenderShape(Dib, Rect, Device, True);
    // Save bitmap
    with TSaveDialog.Create(nil) do
      try
        Filter := 'Windows bitmap|*.bmp';
        if Execute then
          Dib.SaveToFile(FileName);
      finally
        Free;
      end;
  finally
    Dib.Free;
  end;
end;

procedure TfrmMain.btnAbortClick(Sender: TObject);
begin
  FAbortTest := True;
end;

procedure TfrmMain.acToolHistogramExecute(Sender: TObject);
var
  S: TdtpShape;
begin
  if assigned(Document.FocusedShape) then
  begin
    S := Document.FocusedShape;
    with TfmHistogram.Create(Application) do
      try
        SetDataFromShape(S);
        ShowModal;
      finally
        Free;
      end;
  end;
end;

procedure TfrmMain.acToolAutoLevelsExecute(Sender: TObject);
begin
  if Document.FocusedShape is TdtpEffectShape then
    AutoLevelShape(TdtpEffectShape(Document.FocusedShape));
end;

procedure TfrmMain.acHandlesW2K3Execute(Sender: TObject);
begin
  acHandlesW2K3.Checked := not acHandlesW2K3.Checked;
  if acHandlesW2K3.Checked then
    Document.HandlePainter := hpW2K3Handle
  else
    Document.HandlePainter := hpStippleHandle;
end;

procedure TfrmMain.rsrCornerClick(Sender: TObject);
begin
  case Document.RulerUnits of
  ruPixel: Document.RulerUnits := ruMilli;
  ruMilli: Document.RulerUnits := ruCenti;
  ruCenti: Document.RulerUnits := ruInch;
  ruInch:  Document.RulerUnits := ruPixel;
  end;//case
end;

procedure TfrmMain.DtpDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
var
  Name: string;
begin
  if Sender is TObject then
    Name := Sender.ClassName
  else
    Name := '?';
  mmDebug.Lines.Add(Format('%s: [%s] %s', [Name, cWarnStyleNames[WarnStyle], AMessage]));
end;

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  mmDebug.Lines.Clear;
end;

procedure TfrmMain.mnuAddFiletypeAssocClick(Sender: TObject);
{$ifdef USEASSOC}
var
  Res: boolean;
begin
  Res := RegFileType('dtp.file', '.dtp', 'DtpDocuments DTP file',
    Application.ExeName, '0', Format('"%s" "%%1"', [Application.ExeName]));
  // if the association was successful, res=True
  if Res then
  begin
    mnuAddFiletypeAssoc.Enabled := False;
    mnuRemoveFiletypeAssoc.Enabled := True;
  end;
end;
{$else USEASSOC}
begin
//
end;
{$endif USEASSOC}

procedure TfrmMain.mnuRemoveFiletypeAssocClick(Sender: TObject);
{$ifdef USEASSOC}
var
  Res: boolean;
begin
  Res := UnRegFileType('dtp.file', '.dtp');
  // if the un-association was successful, res=True
  if Res then
  begin
    mnuAddFiletypeAssoc.Enabled := True;
    mnuRemoveFiletypeAssoc.Enabled := False;
  end;
end;
{$else USEASSOC}
begin
//
end;
{$endif USEASSOC}

initialization

  //Load custom cursors...
  Screen.cursors[crCopy]       := loadcursor(hinstance, 'DTCOPY');
  Screen.cursors[crMove]       := loadcursor(hinstance, 'DTMOVE');
  Screen.cursors[crLink]       := loadcursor(hinstance, 'DTLINK');
  Screen.cursors[crCopyScroll] := loadcursor(hinstance, 'DTCOPYSC');
  Screen.cursors[crMoveScroll] := loadcursor(hinstance, 'DTMOVESC');
  Screen.cursors[crLinkScroll] := loadcursor(hinstance, 'DTLINKSC');

end.

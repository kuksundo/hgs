{
  Main form unit for ABC-View Manager

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiMain;

interface

uses
  // delphi
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ComCtrls, ImgList, ActnList, Grids, StdCtrls, StdActns,
  AppEvnts, ToolWin, OleCtrls, SHDocVw, SyncObjs, Contnrs,
  ShellAPI, Mask,

  // rxlib
  RxMemDS, rxSpeedBar, RxGrdCpt, RXSplit, RXGrids, RXShell, rxPlacemnt, RxNotify,
  rxAppEvent,

  // zipmaster
  ZipMstr,

  // virtual treeview
  VirtualTrees,

  // simdesign nativejpg
  NativeJpg, NativeXml,

  // simlib
  ShellUtils,

  // abcview
  ItemLists, guiActions, Columns, sdRoots, sdItems, guiItemView, sdApplicationOptions,
  Duplicates, guiBrowser, sdProcessThread, sdAbcTypes, sdAbcVars, sdAbcFunctions,
  //
  Filters, BrowseTrees, DropLists, Pictures, ehshelprouter;

type

  // ABC-View Manager main form
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    sbMain: TStatusBar;
    N1: TMenuItem;
    Open1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Save1: TMenuItem;
    View1: TMenuItem;
    Thumbnails1: TMenuItem;
    Largeicons1: TMenuItem;
    Smallicons1: TMenuItem;
    List1: TMenuItem;
    N5: TMenuItem;
    Details1: TMenuItem;
    AppIcons: TImageList;
    nbMain: TNotebook;
    nbLft: TNotebook;
    Window1: TMenuItem;
    SingleViews1: TMenuItem;
    DualViews1: TMenuItem;
    SaveAs1: TMenuItem;
    NewCatalog1: TMenuItem;
    Items1: TMenuItem;
    DeleteItems1: TMenuItem;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    N6: TMenuItem;
    About1: TMenuItem;
    VisitWebpage1: TMenuItem;
    RemoveItems1: TMenuItem;
    Splitter1: TSplitter;
    cbMain: TControlBar;
    tbMenu: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    tbCatalog: TToolBar;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    tbViews: TToolBar;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    tbSorting: TToolBar;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    tbWindows: TToolBar;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    pmToolbars: TPopupMenu;
    CatalogToolbar1: TMenuItem;
    WindowsToolbar1: TMenuItem;
    ActionsToolbar1: TMenuItem;
    ViewsToolbar1: TMenuItem;
    SortingToolbar1: TMenuItem;
    tbActions: TToolBar;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    DualViews2: TMenuItem;
    tbItems: TToolBar;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ItemsToolbar1: TMenuItem;
    Actions1: TMenuItem;
    SlideShow2: TMenuItem;
    N15: TMenuItem;
    Wizards1: TMenuItem;
    EmailaFriend1: TMenuItem;
    CreateaCD1: TMenuItem;
    BuildaWeb1: TMenuItem;
    ToolButton37: TToolButton;
    ToolButton38: TToolButton;
    tbWizards: TToolBar;
    ToolButton39: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ItemView1: TItemView;
    N16: TMenuItem;
    PageSetup1: TMenuItem;
    PrintPreview1: TMenuItem;
    Print1: TMenuItem;
    Panel1: TPanel;
    Browser1: TBrowser;
    ToolButton42: TToolButton;
    ToolButton44: TToolButton;
    ToolButton43: TToolButton;
    Export1: TMenuItem;
    RegisterNow1: TMenuItem;
    HelpRouter1: THelpRouter;
    ToolButton45: TToolButton;
    ToolButton46: TToolButton;
    WhatsThis2: TMenuItem;
    TellaFriend1: TMenuItem;
    tmMain: TTimer;
    RefreshAll1: TMenuItem;
    RefreshFolder1: TMenuItem;
    N7: TMenuItem;
    Options1: TMenuItem;
    N8: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    CopyImage1: TMenuItem;
    N9: TMenuItem;
    Lossless1: TMenuItem;
    N10: TMenuItem;
    SelectAll1: TMenuItem;
    InvertSelection1: TMenuItem;
    SelectSpecial1: TMenuItem;
    test: TMenuItem;
    Rename1: TMenuItem;
    RemoveEmbeddedInfo1: TMenuItem;
    RemoveTags1: TMenuItem;
    AddTags1: TMenuItem;
    test1: TMenuItem;
    SetAsBackground1: TMenuItem;
    RotateRight1: TMenuItem;
    Rotate180deg1: TMenuItem;
    FlipHorizontal1: TMenuItem;
    FlipVertical1: TMenuItem;
    DuplicatesinthisFolder1: TMenuItem;
    SmartSeries1: TMenuItem;
    N4: TMenuItem;
    ListProcesses1: TMenuItem;
    AddItems1: TMenuItem;
    Sorting1: TMenuItem;
    SortonName1: TMenuItem;
    SortonDate1: TMenuItem;
    SortonSize1: TMenuItem;
    SortonFolder1: TMenuItem;
    SwitchDirection1: TMenuItem;
    ToolButton47: TToolButton;
    ChangeFiledate1: TMenuItem;
    Rename2: TMenuItem;
    RotateusingEXIFflag1: TMenuItem;
    pnlBottom: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cbMainPaint(Sender: TObject);
    procedure Browser1vstBrowseExpanding(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var Allowed: Boolean);
  private
    FBgrImage: TPicture;
    FBrowser: TBrowser;
    FHasSelection: boolean;
    FSelectedItems: TList;
    FLockSelectUpdate: boolean;
    FLogo: TBitmap;
    FSelectedMustUpdate: boolean;
    FUserSelectionNode: PVirtualNode;
    FView: TItemView;
    FRoot: TsdRoot;
    procedure WMMove(var Message: TMessage); message WM_MOVE;
    procedure LoadSaveStatus(Sender: TObject; AMessage: string);
    procedure MaximizeInsteadNewInstance(var Message: TMessage); message 8500;
  protected
    procedure HideAllForms;
    procedure SetBgrImage(const AValue: TPicture);
    procedure SetItem(AItem: TsdItem);
    procedure SetView(AValue: TItemView);
    function GetRoot: TsdRoot;
    function GetMngr: TPictureMngr;
  public
    dlgPrint: TPrintDialog;
    dlgPrintSetup: TPrinterSetupDialog; // Create at runtime!
    FSlideShowThread: TProcess;
    procedure ActionProgress(Sender: TObject; AMsg: string; APercent: double);
    procedure DoSelectedStatus;
    procedure LoadTimer(Sender: TObject);
    procedure ScanTimer(Sender: TObject);
    procedure ScanTimer2(Sender: TObject);
    procedure OpenTimer(Sender: TObject);
    procedure FlushTimer(Sender: TObject);
    procedure TipTimer(Sender: TObject);
    procedure SetFormTitle;
    procedure StatusMessage(Sender: TObject; AMessage: string; APanel: integer);
    procedure MngrStatistics(Sender: TObject; AMessage: string);

    // Files Itemview handling

    // ItemviewFileFileColumns creates a TColumnlist that holds the
    // columns for a File Itemview.
    function ItemviewFileColumns: TColumnList;
    // ItemviewFileData responds to an Itemview's OnItemData event to
    // provide data for a TFile item in an ItemView
    procedure ItemviewFileData(Sender: TObject; AItem: TsdItem; AListItem: TListItem);
    // ItemviewFileInfotip responds to an Itemview's OnItemInfotip event to
    // provide data for a TFile item's infotip in an Itemview
    procedure ItemviewFileInfotip(Sender: TObject; AItem: TsdItem;
      var AInfotip: string);
    // Display the properties dialog
    procedure ItemviewFileProperties(Sender: TObject; AItem: TsdItem);
    // ItemviewFileOpenItem responds to an Itemview's OnOpenItem and either
    // shows the graphic fullscreen or starts the file with FileExecute
    procedure ItemviewFileOpenItem(Sender: TObject; AItem: TsdItem);
    // ItemviewFileStatus responds to an Itemview's OnUpdateStatus event to
    // generate status data for an TFile Itemview (#files, total bytes).
    procedure ItemviewFileStatus(Sender: TObject);
    // ItemviewFileUpdateItem responds to an Itemview's OnUpdateItem and
    // shows the graphic in a small popup stay-on-top window
    procedure ItemviewFileUpdateItem(Sender: TObject; AItem: TsdItem);
    // Folder
    function  ItemViewFolderColumns: TColumnList;
    procedure ItemviewFolderData(Sender: TObject; AItem: TsdItem; AListItem: TListItem);
    procedure ItemviewFolderInfotip(Sender: TObject; AItem: TsdItem;
      var AInfotip: string);
    procedure ItemviewFolderStatus(Sender: TObject);
    // ItemviewGetFocus is called by the itemview to get focus of the main
    // window.
    procedure ItemviewGetFocus(Sender: TObject);
    // ItemviewItemSelect is called by the itemview whenever an individual item
    // gets selected or deselected. When AItem = nil the complete selection should
    // be cleared.
    procedure ItemviewItemSelect(Sender: TObject; AItem: TsdItem; Selected: boolean);
    // ItemviewMessage responds to an Itemview's OnStatusMessage and shows
    // the message in the lower left corner
    procedure ItemviewMessage(Sender: TObject; AMessage: string);
    procedure ItemviewSelectionChanged(Sender: TObject; Quick: boolean);
    // Call ItemviewSetItemType to change the type you have currently
    // selected (e.g. from itFile to itFolder)
    procedure ItemviewSetItemType(Sender: TObject; AItemType: TItemType);

    function GetNewTempFile: string;
    procedure DeleteAllTempFiles;
    procedure SetBackground(AFile: string; AColor: TColor; AFont: TFont);

    procedure LoadCollection(AFilename: TFilename);
    procedure RootClearSelectedItems(Sender: TObject);
    procedure RootClearBatchedItems(Sender: TObject);
    //procedure RootStatusMessage(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
    procedure RootRemoveItems(Sender: TObject; AList: TList);
    procedure SaveCatalog(AFilename: TFilename);
    procedure SingleView;
    procedure DualView;
    property BgrImage: TPicture read FBgrImage write SetBgrImage;
    property Browser: TBrowser read FBrowser;
    property HasSelection: boolean read FHasSelection write FHasSelection;
    property Item: TsdItem write SetItem;
    property SelectedItems: TList read FSelectedItems;
    property SelectedMustUpdate: boolean read FSelectedMustUpdate;
    property UserSelectionNode: PVirtualNode read FUserSelectionNode write
      FUserSelectionNode;
    property View: TItemView read FView write SetView;
    //procedure ComponentDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
    property Root: TsdRoot read GetRoot;
    property Mngr: TPictureMngr read GetMngr;
  end;

var
  frmMain: TfrmMain;
  glDebugComponent: TDebugComponent;

  hfrmHandle: HWND;

  InvalidateRectCount: integer;

  // Global variables

  // Droplist is managed by root and contains a list of all items in the drop
  DropList: TDropList = nil;
  // DropSender contains a pointer to the initiator of the drop
  DropSender: TObject = nil;

//procedure DebugLog(const AMsg: Utf8String);

implementation

{$R *.DFM}

uses
  guiAddFolder,
  guiOptions, Filers, guiAbout, guiShow,
  guiFilterDialog, guiTempMessages, sdGraphicLoader,
  guiSplashScreen, SlideShows, guiPropertyDialog, sdScanFolders,
  guiTipOfDay, guiProcess;

{ TfrmMain }

function TfrmMain.GetRoot: TsdRoot;
begin
  // Root holds all items and is unfiltered (files, folders, groups, series)
  Result := FRoot;
end;

function TfrmMain.GetMngr: TPictureMngr;
begin
  Result := FRoot.Mngr;
end;

procedure TfrmMain.SetItem(AItem: TsdItem);
begin

  // Do we have a preview window?
  if dmActions.Preview.Checked then
  begin
    // Set the ShowMngr's ItemID to show the image
    if assigned(AItem) then
      ShowMngr.CurrentGuid := AItem.Guid
    else
      ShowMngr.CurrentGuid := cEmptyGuid;
  end;
end;

procedure TfrmMain.SetFormTitle;
begin
  Caption := '-View Manager';
    if FLoadFilename <> '' then
       Caption := Caption + ' [' + ExtractFileName(FLoadFilename) + ']';
end;


procedure TfrmMain.FormCreate(Sender: TObject);
var
  Loader: TsdGraphicLoader;
  // local
  procedure SetItemviewHandlers(AItemView: TItemview);
  begin
    AItemView.OnDelete := FRoot.DeleteItems;
    AItemView.OnRemove := FRoot.RemoveItems;
    AItemView.OnSetItemType := ItemViewSetItemType;
    ItemViewSetItemType(AItemView, itFile);
    AItemView.dftFiles.Register(AItemView);
    AItemView.ddmFiles.Register(AItemView);
    AItemView.dfsFiles.Images := FLargeIcons;
  end;
  // local
  procedure SetBrowserHandlers(ABrowser: TBrowser);
  begin
    ABrowser.OnStatusMessage := ItemviewMessage;
  end;

// main
begin

  // Create the processlist
  glProcessList := TProcessList.Create;

  // sdApplicationOptions.pas
  CreateOptions;

  // Application folder
  FAppFolder := IncludeTrailingPathDelimiter(ExtractFileDir(Paramstr(0)));
  FIniFile := FAppFolder + 'ABC-View.ini';

  // Help
  Application.Helpfile := FAppFolder + 'ABC-View.hlp';

  // Background bitmaps
  FMainBgrFile := FAppFolder + 'paper.jpg';
  FShowBgrFile := FAppFolder + 'paper.jpg';

  // Font
  if not assigned(FMainBgrFont) then
    FMainBgrFont := TFont.Create;

  FMainBgrFont.Assign(frmMain.Browser1.VstBrowse.Font);
  SaveOpt.Add(FMainBgrFont, '', 'MainBgrFont');

  // Temp files
  FTempFolder := FAppFolder + 'Temp\';
  DeleteAllTempFiles;

  FBgrImage := TPicture.Create;

  // Selection sets
  FSelectedItems := TList.Create;

  // Load options
  SaveOpt.LoadFromIni(FIniFile);
  AutoOpt.LoadFromIni(FIniFile);

  // Initialize Root
  FRoot := TsdRoot.Create;
  FRoot.Name := 'object list';

  // Events
  FRoot.OnStatusMessage := StatusMessage;
  FRoot.OnActionProgress := ActionProgress;

  FRoot.OnClearItems := RootClearSelectedItems;
  FRoot.OnRemoveItems := RootRemoveItems;

  FRoot.Mngr.OnStatistics := MngrStatistics;

  // Set the ItemViews
  SetItemViewHandlers(ItemView1);
  ItemView1.SelectBit := sbBit1;
  ItemView1.ItemList.Name := 'item viewer 1';

  // Set current view
  View := ItemView1;

  // Initialize browsers
  Browser1.Initialize;
  Browser1.BrowseTree := FRoot.FBTree1;
  SetBrowserHandlers(Browser1);

  // Connect ShowMngr
  ShowMngr := TShowMngr.Create;
  ShowMngr.Name := 'Show Manager';

  // Add as node to the root
  FRoot.ConnectNode(ShowMngr);

  // Reset icon size
  ItemView1.ResetIcons;

  SingleView;

  // Startup Slideshowthread
  FSlideShowThread := TSlideShowThread.Create(True, glProcessList);
  FSlideShowThread.Priority := tpLower;
  FSlideShowThread.Resume;
  FSlideShowThread.Name := 'Slideshow';
  FSlideShowThread.Status := psPausing;

  // Form's ABC-View overlay
  FLogo := TBitmap.Create;
  try
    Loader := TsdGraphicLoader.Create;
    try
      if Loader.LoadFromFile(FAppFolder + 'logo.bmp') = gsGraphicsOK then
      begin
        FLogo.Assign(Loader.Bitmap);
        FLogo.Transparent := True;
        FLogo.TransParentColor := FLogo.Canvas.Pixels[0,0];
        FLogo.TransparentMode := tmAuto;
      end else
        FreeandNil(FLogo);
    finally
      Loader.Free;
    end;
  except
    FreeAndNil(FLogo);
  end;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FSlideShowThread := nil;

  // Stop any process now,
  glProcessList.StopAllProcesses;

  // We call this to ensure that no jump-jump references will exist
  FRoot.DisconnectAll;
  FreeAndNil(ShowMngr);

  // Root is the culprit
  FreeAndNil(FRoot);
  FreeAndNil(glProcessList);

  // Positioned here because Root will free access when destroyed
  DeleteAllTempFiles;
  FreeAndNil(FFileTypeNames);
  FreeAndNil(FSelectedItems);

  // Logo
  FreeAndNil(FLogo);

  // Options
  DestroyOptions;

  // Background image
  FreeAndNil(FBgrImage);
end;

procedure TfrmMain.HideAllForms;
begin
  Hide;
  frmShow.Hide;
  dlgFilter.Hide;
  frmProcesses.Hide;
end;

procedure TfrmMain.SetBgrImage;
begin
  FBgrImage.Assign(AValue);
  Browser1.vstBrowse.BackGround := FBgrImage;
  ItemView1.Background.Assign(BgrImage);
end;

procedure TfrmMain.SetBackground(AFile: string; AColor: TColor; AFont: TFont);
var
  Picture: TPicture;
  Loader: TsdGraphicLoader;
begin

  // Background picture
  Picture := TPicture.Create;
  Loader := TsdGraphicLoader.Create;
  try
    if Loader.LoadFromFile(AFile) = gsGraphicsOK then
    begin
      Picture.Assign(Loader.Bitmap);
      BgrImage := Picture;
    end else
      SetBgrImage(nil);
  finally
    Loader.Free;
    Picture.Free;
  end;

  // Static color
  Browser1.vstBrowse.Color := AColor;
  ItemView1.ListView.Color := AColor;

  // Font
  if assigned(AFont) then
  begin
    Browser1.vstBrowse.Font.Assign(AFont);
    Browser1.vstBrowse.Colors.TreeLineColor := AFont.Color;

    ItemView1.Font.Color := AFont.Color;
    ItemView1.Font.Name := AFont.Name;
    ItemView1.Font.Size := AFont.Size;
  end;

  // Redraw
  ItemView1.Listview.Invalidate;
  Invalidate;
end;

procedure TfrmMain.SetView(AValue: TItemView);
begin
  if FView <> AValue then
  begin

    // deactivate old view
    if assigned(FView) then
      FView.IsActiveView := false;

    // Assign new view
    FView := AValue;

    // Update the selection
    FSelectedItems.Clear;
    if assigned(FView) then
    begin
      FView.IsActiveView := true;
      FView.AddSelectedItems(FSelectedItems);
    end;

    // Reflect new selection settings
    DoSelectedStatus;

    // Browser
    FBrowser := Browser1;

  end;
end;

procedure TfrmMain.LoadCollection(AFilename: TFilename);
var
  Filer: TFileIO;
begin

  Screen.Cursor:=crHourGlass;

  // Clear old catalog
  FRoot.ClearItems(Self);

  // FileIO object
  Filer := TFileIO.Create;
  try
    Filer.FileObject := FRoot;
    Filer.OnStatus := LoadSaveStatus;

    // Read the catalog from disk
    Filer.LoadFromFile(AFilename);

    // Thumbnails in separate file
    LoadSaveStatus(Self, 'Verifying thumbnails...');
    FRoot.ThumbStreamOpen(ChangeFileExt(AFileName, '.abt'));
    LoadSaveStatus(Self, 'Done.');

  finally
    Filer.Free;
  end;

  // Make sure to start the re-indexing
  FRoot.MustIndex := True;

  // No changes because we loaded
  FRoot.IsChanged := false;

  SetFormTitle;
  Screen.Cursor:=crDefault;
end;

procedure TfrmMain.RootClearSelectedItems(Sender: TObject);
begin
  if assigned(SelectedItems) then
    SelectedItems.Clear;
end;

procedure TfrmMain.RootClearBatchedItems(Sender: TObject);
begin
  Root.ClearBatchedItems;
end;

procedure TfrmMain.RootRemoveItems(Sender: TObject; AList: TList);
var
  i: integer;
begin
  // We must make sure that our list(s) do not contain any items in AList
  if assigned(SelectedItems) then
    for i := 0 to AList.Count - 1 do
      if SelectedItems.IndexOf(AList[i]) >= 0 then
        SelectedItems.Remove(AList[i]);
end;

procedure TfrmMain.SaveCatalog(AFilename: TFilename);
var
  Filer: TFileIO;
begin
  Screen.Cursor:=crHourGlass;

  // FileIO object
  Filer := TFileIO.Create;
  try
    Filer.FileObject := FRoot;
    Filer.OnStatus := LoadSaveStatus;

    if FStoreThumbs then
    begin
      // Thumbnails in separate file
      LoadSaveStatus(Self, 'Storing thumbnails...');

      // Save the thumbnails
      FRoot.ThumbStreamSave(ChangeFileExt(AFileName, '.abt'));
    end;

    // Save the catalog to disk
    Filer.SaveToFile(AFilename);

    if FStoreThumbs then
      // Open thumbnail file again to continue working
      FRoot.ThumbStreamOpen(ChangeFileExt(AFileName, '.abt'));

  finally
    Filer.Free;
  end;

  FRoot.IsChanged := false;

  Screen.Cursor:=crDefault;
end;

procedure TfrmMain.LoadSaveStatus(Sender: TObject; AMessage: string);
begin
  StatusMessage(Sender, AMessage, suPanel1);
end;

procedure TfrmMain.MaximizeInsteadNewInstance(var Message: TMessage);
begin
  // Win2k doesn't work properly
  // unless you minimize first.
  Application.Minimize;
  Application.Restore;
  Application.BringToFront;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Hide the forms
  HideAllForms;

  // Check if we can close
  if FRoot.IsChanged and cAllowDlgSaveBeforeClose then
  begin
    case MessageDlg('Do you want to save your work before closing this application?',
           mtWarning, mbYesNoCancel, 0) of
    mrYes:    dmActions.FileSaveExecute(Self); // Save
    mrCancel:
      begin
        Show;
        CanClose := False; // Don't exit!
      end;
    end;
  end;
end;

procedure TfrmMain.StatusMessage(Sender: TObject; AMessage: string; APanel: integer);
begin
  case APanel of
  suPanel0: // Update panel 0
    begin
      sbMain.Panels[0].Text := AMessage;
      sbMain.Panels[0].Width := Canvas.TextWidth(AMessage) + 6;
    end;
  suPanel1: // Update panel 1
    begin
      sbMain.Panels[1].Text := AMessage;
    end;
  suPanel2: // Update panel 2
    begin
      sbMain.Panels[2].Text := AMessage;
    end;
  end;// case

  // Refresh the GUI
  Application.ProcessMessages;
end;

procedure TfrmMain.MngrStatistics(Sender: TObject; AMessage: string);
begin
  sbMain.Panels[2].Text := AMessage;
end;

procedure TfrmMain.ActionProgress(Sender: TObject; AMsg: string; APercent: double);
begin
  sbMain.Panels[1].Text := Format('%s (%3.1f%%)', [AMsg, APercent]);
  Application.ProcessMessages;
end;

function TfrmMain.ItemViewFileColumns: TColumnList;
begin
  Result := TColumnList.Create;

  // create the basic list of columns
  Result.Add(True, 'Name'    , 150, smByName, taLeftJustify);
  Result.Add(True, 'Size'    ,  60, smBySize, taRightJustify);
  Result.Add(True, 'Type'    ,  50, smByType, taLeftJustify);
  Result.Add(True, 'Modified',  70, smByDate, taRightJustify);
  Result.Add(True, 'Folder'  , 240, smByFolder, taLeftJustify);
  Result.Add(True, 'Status'  ,  70, smByStatus, taLeftJustify);
  Result.Add(False, 'Series'  , 100, smBySeries, taLeftJustify);
  Result.Add(False, 'Rating'  ,  50, smByRating, taRightJustify);
  Result.Add(False, 'Groups'  ,  50, smByGroupCount, taLeftJustify);
  Result.Add(False, 'CRC32'   ,  50, smByCRC, taRightJustify);
  Result.Add(True, 'Dimensions', 100, smByDimensions, taLeftJustify);
  Result.Add(False, 'Compression', 50, smByCompression, taRightJustify);
  Result.Add(False, 'Original Name', 150, smByOrigName, taLeftJustify);
  Result.Add(True, 'Description', 200, smByDescription, taLeftJustify);
  Result.Add(False, 'Band', 70, smByBand, taLeftJustify);

  // load the user settings from the INI file
  Result.LoadSettingsFromINI(FIniFile, itFile);
end;

procedure TfrmMain.ItemviewFileData(Sender: TObject; AItem: TsdItem; AListItem: TListItem);
var
  F: TsdFile;
  SI: TStrings;
  IV: TItemView;
  Icon: integer;
  Size, Typ, Modif, Folder, Status, Series, Rating,
  Group, CRC, Dimensions, Compression: string;
begin
  if not assigned(AItem) or (AItem.ItemType <> itFile) then
  begin
    AListItem.Caption := '*Error*';
    exit;
  end;

  F := TsdFile(AItem);
  Status := '';

  // Filename
  AListItem.Caption := F.Name;

  // Icon and Type
  F.GetIconAndType(Icon, Typ);

  // Size, Modified
  Size := F.SizeAsString;
  Modif := F.ModifiedAsString;

  // Status
  Status := F.StatusString;

  // Folder
  Folder := F.FolderName;

  // Series
  Series := F.SeriesAsString;

  // Rating
  Rating := F.RatingAsString;

  // #Groups
  Group := F.GroupsAsString;

  // CRC
  CRC := F.CRCAsString;

  // Dimensions
  Dimensions := F.Dimensions;

  Compression := F.ComprRatioAsString;

  // Add subitems
  SI := AListItem.SubItems;
  IV := TItemView(Sender);
  if IV.ColumnList[1].Visible then
    SI.Add(Size);
  if IV.ColumnList[2].Visible then
    SI.Add(Typ);
  if IV.ColumnList[3].Visible then
    SI.Add(Modif);
  if IV.ColumnList[4].Visible then
    SI.Add(Folder);
  if IV.ColumnList[5].Visible then
    SI.Add(Status);
  if IV.ColumnList[6].Visible then
    SI.Add(Series);
  if IV.ColumnList[7].Visible then
    SI.Add(Rating);
  if IV.ColumnList[8].Visible then
    SI.Add(Group);
  if IV.ColumnList[9].Visible then
    SI.Add(CRC);
  if IV.ColumnList[10].Visible then
    SI.Add(Dimensions);
  if IV.ColumnList[11].Visible then
    SI.Add(Compression);
  if IV.ColumnList[12].Visible then
    SI.Add(F.OriginalName);
  if IV.ColumnList[13].Visible then
    SI.Add(F.Description);
  if IV.ColumnList[14].Visible then
  begin
    if F.Band >= 0 then
      SI.Add(Format('%.4d', [F.Band]))
    else
      SI.Add('');
  end;
end;

procedure TfrmMain.ItemviewFileInfotip(Sender: TObject; AItem: TsdItem; var AInfotip: string);
var
  F: TsdFile;
  D: string;
begin
  // Get the info from the item
  if assigned(AItem) and (AItem.ItemType = itFile) then
  begin
    F := TsdFile(AItem);
    D := F.Description;
    if length(D) > 0 then
      D := D + #13;
    AInfoTip := F.Name + #13 +
      'Size: '+ FormatFloat('#,###', F.Size) + ' bytes'#13 +
      'Modified: ' + DateTimeToStr(F.Modified) + #13 +
      D + F.FileName;
  end;
end;

procedure TfrmMain.ItemviewFileProperties(Sender: TObject; AItem: TsdItem);
begin
  if assigned(AItem) and (AItem.ItemType = itFile) then
  begin
    frmProps.FilePropsToDialog(TsdFile(AItem));
    frmProps.ShowModal;
  end;
end;

procedure TfrmMain.ItemviewFileOpenItem(Sender: TObject; AItem: TsdItem);
var
  Name: TFileName;
begin

  if assigned(AItem) and (AItem.ItemType = itFile) then
  begin

    Name := TsdFile(AItem).FileName;
    if IsGraphicsFile(Name) and not (isDecodeErr in AItem.States) then
    begin

      // Supported by the viewer
      frmShow.MaximizeExecute(Self)

    end else
    begin

      // Unsupported by the viewer
      FileExecute(Name,'','',esNormal);

    end;
  end;

end;

procedure TfrmMain.ItemviewFileStatus(Sender: TObject);
var
  i: integer;
  FTotalSize: int64;
  IV: TItemView;
begin

  if View = Sender then
  begin
    IV := TItemView(Sender);

    // Recalculate count
    FTotalSize:=0;
    for i := 0 to IV.ItemList.Count-1 do
      if IV.ItemList[i].ItemType = itFile then
        FTotalSize := FTotalSize + TsdFile(IV.ItemList[i]).Size;

    if FTotalSize < 1048576 then
      StatusMessage(Self, Format('%d Files (%d kB)',
        [IV.ItemList.Count, round(FTotalSize /1024)]), suPanel0)
    else
      StatusMessage(Self, Format('%d Files (%3.2f MB)',
        [IV.ItemList.Count, FTotalSize / 1048576]), suPanel0);
  end;
end;

procedure TfrmMain.ItemviewFileUpdateItem(Sender: TObject; AItem: TsdItem);
begin
  Item := AItem;
end;

function TfrmMain.ItemViewFolderColumns: TColumnList;
begin
  Result := TColumnList.Create;

  // create the basic list of columns
  Result.Add(True, 'Name', 120, smByShortName, taLeftJustify);
  Result.Add(True, 'Path', 180, smByName, taLeftJustify);
  Result.Add(True, 'Type',  80, smByType, taLeftJustify);
  Result.Add(True, 'Modified', 100, smByDate, taLeftJustify);
  Result.Add(True, 'Volumelabel', 70, smByVolumeLabel, taLeftJustify);
  Result.Add(True, 'Status',  70, smByStatus, taLeftJustify);
  Result.Add(True, '# Files', 50, smByNumItems, taRightJustify);
  Result.Add(True, 'Total Size', 60, smBySize, taRightJustify);
  Result.Add(True, 'Attributes', 60, smByAttributes, taLeftJustify);
  Result.Add(True, 'Filter', 100, smByFilter, taLeftJustify);
  Result.Add(True, 'Protection', 60, smByProtection, taLeftJustify);

  // load the user settings from the INI file
  Result.LoadSettingsFromINI(FIniFile, itFolder);
end;

procedure TfrmMain.ItemviewFolderData(Sender: TObject; AItem: TsdItem; AListItem: TListItem);
var
  FileCount: integer;
  SizeCount: double;
  Folder: TsdFolder;
  APath, AType, AModif, AVolume, AStatus, ANumFiles, ATotalSize,
  AUpdate, AAttr, AFilter, AProtection: string;
begin
  if not assigned(AItem) or (AItem.ItemType <> itFolder) then
  begin
    AListItem.Caption := '*Error*';
    exit;
  end;

  Folder := TsdFolder(AItem);

  with (Sender as TItemview), Folder do begin

    // Short representative name
    AListItem.Caption := Name;

    // Path, includes trailing backslash
    APath := Folder.FolderName;

    // But keep original type string
    AType := FFolderType;

    AModif := 'unknown';
    if isDeleted in States then
      AModif := 'Deleted'
    else
      if Modified <> 0 then
        AModif := DateTimeToStr(Modified)
      else
        AModif := '';

    // Volume label
    AVolume := FVolume;

    // Status
    AStatus := GetStatusString;

    if ColumnList[6].Visible or ColumnList[7].Visible then begin

      GetStatistics(FileCount, SizeCount);
      ANumFiles := Format('%d', [FileCount]);
      ATotalSize := Format('%1.0fKB', [SizeCount]);

    end else begin

      ANumFiles := 'Unknown';
      ATotalSize := 'Unknown';

    end;

    if FShellNotify then
      AUpdate := 'Yes'
    else
      AUpdate := 'No';

{$warnings off}
    // Attributes
    AAttr := '';
    if (FAttr and faReadOnly) > 0 then
      AAttr := AAttr + 'R';
    if (FAttr and faHidden) > 0 then
      AAttr := AAttr + 'H';
    if (FAttr and faSysFile) > 0 then
      AAttr := AAttr + 'S';
    if (FAttr and faArchive) > 0 then
      AAttr := AAttr + 'A';
{$warnings on}

    // Filter
    AFilter := '';
    if not Options.AddHidden then
      AFilter := 'Skip H';
    if not Options.AddSystem then begin
      if length(AFilter) > 0 then
        AFilter := AFilter + '&S'
      else
        AFilter := 'Skip System';
    end;
    if Options.GraphicsOnly then begin
      if length(AFilter) > 0 then
        AFilter := AFilter + ', ';
      AFilter := AFilter + 'Graphics Only';
    end;

    if Options.DeleteProtected then
      AProtection := 'Yes'
    else
      AProtection := 'No';

    // Add subitems
    with AListItem.SubItems do
    begin
      if ColumnList[1].Visible then
        Add(APath);
      if ColumnList[2].Visible then
        Add(AType);
      if ColumnList[3].Visible then
        Add(AModif);
      if ColumnList[4].Visible then
        Add(AVolume);
      if ColumnList[5].Visible then
        Add(AStatus);
      if ColumnList[6].Visible then
        Add(ANumFiles);
      if ColumnList[7].Visible then
        Add(ATotalSize);
      if ColumnList[8].Visible then
        Add(AAttr);
      if ColumnList[9].Visible then
        Add(AFilter);
      if ColumnList[10].Visible then
        Add(AProtection);
    end;
  end;
end;

procedure TfrmMain.ItemviewFolderInfotip(Sender: TObject; AItem: TsdItem;
      var AInfotip: string);
begin
  // Get the info from the item
  if assigned(AItem) and (AItem.ItemType = itFolder) then
    with TsdFolder(AItem) do
    begin
      AInfoTip := FolderName + #13 +
        'Modified: ' + DateTimeToStr(Modified);
    end;
end;

procedure TfrmMain.ItemviewFolderStatus(Sender: TObject);
begin
  if View = sender then
    with Sender as TItemView do
      StatusMessage(Self, Format('%d Folders', [ItemList.Count]), suPanel0);
end;

procedure TfrmMain.ItemviewGetFocus(Sender: TObject);
begin

  // Select the correct view
  if Sender is TItemView then
    View := TItemView(Sender);

end;

procedure TfrmMain.ItemviewMessage(Sender: TObject; AMessage: string);
begin
  StatusMessage(Sender, AMessage, suPanel1);
end;

procedure TfrmMain.ItemviewItemSelect(Sender: TObject; AItem: TsdItem; Selected: boolean);
begin
  if assigned(SelectedItems) then
  begin
    if assigned(AItem) then
    begin
      if Selected then
        SelectedItems.Add(AItem)
      else
        SelectedItems.Remove(AItem);
    end else
    begin
      SelectedItems.Clear;
    end;
    // We could do incremental updates here.. later
  end;
end;

// This part seems to be locking sometimes.. perhaps I have to put
// it in a thread!
procedure TfrmMain.ItemviewSelectionChanged(Sender: TObject; Quick: boolean);
begin
  // Locking mechanism
  if FLockSelectUpdate then
    exit;

  FLockSelectUpdate := True;
  try

    if Quick then
    begin

      FSelectedMustUpdate := True;

    end else
    begin

      // Reflect changes
      DoSelectedStatus;
      FSelectedMustUpdate := False;

    end;

  finally
    FLockSelectUpdate := False;
  end;
end;

procedure TfrmMain.ItemviewSetItemType(Sender: TObject; AItemType: TItemType);
begin
  with Sender as TItemView do
  begin
    // General handlers
    OnGetFocus := ItemviewGetFocus;
    OnItemSelect := ItemviewItemSelect;
    OnStatusMessage := ItemviewMessage;
    // Specific handlers
    case AItemType of
    itFile:
      begin
        OnItemData := ItemviewFileData;
        OnItemInfotip := ItemviewFileInfotip;
        OnItemProperties := ItemviewFileProperties;
        OnOpenItem := ItemviewFileOpenItem;
        OnUpdateStatus := ItemviewFileStatus;
        OnSelectionChanged := ItemviewSelectionChanged;
        OnShowItem := ItemviewFileUpdateItem;
        ColumnList := ItemviewFileColumns;
      end;
    itFolder:
      begin
        OnItemData := ItemviewFolderData;
        OnItemInfotip := ItemviewFolderInfotip;
        OnItemProperties := nil;
        // for now
        // to do: do something when double click on folder
        OnOpenItem := nil;
        OnUpdateStatus := ItemviewFolderStatus;
        OnSelectionChanged := ItemviewSelectionChanged;
        ColumnList := ItemviewFolderColumns;
      end;
    else
      OnItemData := nil;
      OnItemInfotip := nil;
      OnOpenItem := nil;
      OnUpdateStatus := nil;
      OnSelectionChanged := nil;
      OnShowItem := nil;
    end;
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if not Application.Terminated and assigned(frmShow) then
    frmShow.SnapToMain;
end;

procedure TfrmMain.DoSelectedStatus;
var
  i, NumFiles: integer;
  TotalSize: int64;
  FolderSize: double;
  Item: TsdItem;
  AMessage: string;
begin

  try
    with FSelectedItems do
    begin

      HasSelection := (Count > 0);

      // Show the status at the bottom of the page
      if Count = 0 then
      begin

        AMessage := 'No items selected';

      end else
      begin

        // Total size
        TotalSize := 0;
        for i := 0 to Count - 1 do
        begin
          Item := TsdItem(Items[i]);
          case Item.ItemType of
          itFile:
            begin
              Inc(TotalSize, TsdFile(Item).Size);
            end;
          itFolder:
            begin
              // Get statistical data
              TsdFolder(Item).GetStatistics(NumFiles, FolderSize);
              Inc(TotalSize, round(FolderSize * 1024));
            end;
          end;//case
        end;

        // Create message
        if Count = 1 then
          AMessage := Format('Selected %d Item (%d bytes)', [Count, TotalSize])
        else
        begin
          if TotalSize < 1048576 then
            AMessage := Format('Selected %d Items (%d kB)',
              [Count, round(TotalSize/1024)])
          else
            AMessage := Format('Selected %d Items (%3.1f MB)',
              [Count, TotalSize/1048576])
        end;

      end;

      // Show message
      StatusMessage(Self, AMessage, suPanel1);

    end;
  except

    // Any exceptions are handled here
//    ComponentDebug(Self, wsInfo, 'Exception in "DoSelectedStatus"');

  end;
end;

procedure TfrmMain.WMMove(var Message: TMessage);
begin
  if not Application.Terminated and assigned(frmShow) then
    frmShow.SnapToMain;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{  // Create this dialog, and leave it to the application to free
  with TdlgTempMessage.Create(Application) do begin
    lblMessage.Caption := 'Terminating all processes...';
    Show;
  end;}

  SaveControlsToIni(FIniFile);

  glProcessList.StopAllProcesses;
  FRoot.ClearItems(Self);
end;

procedure TfrmMain.SingleView;
begin
  FSingleMode := true;
  //NoteBook2.Hide;
  //Splitter2.Hide;
  //Browser2.BrowseTree.Source := nil;
end;

procedure TfrmMain.DeleteAllTempFiles;
var
  R: integer;
  F: TSearchRec;
begin
  R := FindFirst(FTempFolder + '*.tmp', faAnyFile, F);
  while R = 0 do
  begin
    DeleteFile(FTempFolder + F.Name);
    R := FindNext(F);
  end;
  FindClose(F);
end;

function TfrmMain.GetNewTempFile: string;
begin
  // Check if temp folder exists
  ForceDirectories(FTempFolder);
  Result := FTempFolder + Format('%.8d.tmp', [FTempFileNum]);
  inc(FTempFileNum);
end;

procedure TfrmMain.DualView;
begin
  // no longer available
{  // Put into Dual mode
  FSingleMode := false;
  NoteBook2.Show;
  Splitter2.Show;
  Browser2.BrowseTree.Source := FRoot; }
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if not assigned(frmProcesses) then
    Application.CreateForm(TfrmProcesses, frmProcesses);
  frmProcesses.Processes := glProcessList;

  // Everything is created.. so get some placement stuff
//  ComponentDebug(Self, wsInfo, 'InitControlsIni Start');
  InitControlsFromIni(FIniFile);
//  ComponentDebug(Self, wsInfo, 'InitControlsIni Close');

  // Background
  SetBackground(FMainBgrFile, FMainBgrColor, FMainBgrFont);
  frmShow.SetBackground(FShowBgrFile, FShowBgrColor);

  if not FSingleMode then
    DualView;

  // Set filetype associations
  // function is in simlib/disk/ShellUtils
  RegFileType('ABC.Collection', '.abc', 'ABC-View Collection', Application.ExeName,
    '0', Format('"%s" "%%1"', [Application.ExeName]));
  RegFileType('ABC.Thumbnails', '.abt', 'ABC-View Thumbnails', Application.ExeName,
    '1', '');
  RegDirAction('Browse with ABC-View', Format('"%s" "%%1"', [Application.ExeName]));

  // Read the command line for actions
  if length(ParamStr(1)) > 0 then
  begin
    if lowercase(ExtractFileExt(ParamStr(1))) = '.abc' then
    begin
      // A collection file
      FLoadFileName := ParamStr(1);
      // load the catalog in the LoadTimer function
      tmMain.OnTimer := LoadTimer;
    end else
    begin
      //Directory?
      if DirectoryExists(ParamStr(1)) then
      begin
        // Browse this directory in timer func
        tmMain.OnTimer := ScanTimer;
      end;
    end;
  end;

  if not assigned(tmMain.OnTimer) then
    tmMain.OnTimer := OpenTimer;

  tmMain.Enabled := True;

  // Browse Tree's PIDL
  if assigned(FRoot.FBTree1) then
    FRoot.FBTree1.CreatePIDL;
end;

procedure TfrmMain.LoadTimer(Sender: TObject);
begin
  tmMain.Enabled := False;
  tmMain.OnTimer := nil;
  LoadCollection(FLoadFileName);
  if assigned(FRoot.FBTree1) then
    FRoot.FBTree1.Items[1].Expanded := True;
end;

procedure TfrmMain.OpenTimer(Sender: TObject);
begin
  tmMain.Enabled := False;
  tmMain.OnTimer := nil;
  if assigned(FRoot.FBTree1) then
    FRoot.FBTree1.Items[1].Expanded := True;
  // Tip of day, only if no other timer use
  tmMain.OnTimer := TipTimer;
  tmMain.Interval := 3000;
  tmMain.Enabled := True;
end;

procedure TfrmMain.ScanTimer(Sender: TObject);
begin
  tmMain.Enabled := False;
  // Browse this directory
  RunScan(ParamStr(1), True, False, '', '',
    RootClearBatchedItems);
  if assigned(FRoot.FBTree1) then
    FRoot.FBTree1.Items[1].Expanded := True;
  // Make sure it is activated
  tmMain.OnTimer := ScanTimer2;
  tmMain.Enabled := True;
end;

procedure TfrmMain.ScanTimer2(Sender: TObject);
begin
  if IsScanBusy then
    exit;

  tmMain.Enabled := False;
  tmMain.OnTimer := nil;
  if assigned(Browser) and assigned(Browser.BrowseTree) then
    Browser.BrowseTree.PidlFolderActivate(ParamStr(1));
end;

procedure TfrmMain.FlushTimer(Sender: TObject);
begin
  if FRoot.IsFlushing or IsScanBusy then
    exit;

  tmMain.Enabled := False;
  tmMain.OnTimer := nil;
  FRoot.FlushBatchedItems;
end;

procedure TfrmMain.TipTimer(Sender: TObject);
begin
  tmMain.Enabled := False;

  // Show the tip of day
//  ShowTipOfDay;
end;

procedure TfrmMain.cbMainPaint(Sender: TObject);
begin
  inherited;

  // Paint the logo
  if assigned(FLogo) then
    with (Sender as TControlBar) do
      Canvas.Draw(Width - FLogo.Width, 0, FLogo);
end;

procedure TfrmMain.Browser1vstBrowseExpanding(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
//var
//  TreeOpt: TStringTreeOptions;
begin
//
//  TreeOpt := TVirtualStringTree(Sender).TreeOptions;
//  TreeOpt.PaintOptions := TreeOpt.PaintOptions + [toShowRoot];

end;

end.

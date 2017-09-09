{ Unit guiItemview

  This unit implements the TItemView frame, which displays a list of items,
  either as thumbnails or as a list or as small or large icons.

  //TFileview is a descendant of TItemView, which shows on a list of files.

  An application can override the basic TItemview type.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 1999 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiItemView;

interface

uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, ComCtrls, ToolWin, ExtCtrls, sdItems, RXShell,
  Menus, sdSorter, Columns, ItemLists, DropTarget, DropSource,
  ActiveX, Math, LossLess, Buttons, StdCtrls, RXSlider, ShellAPI,
  DropLists, sdAbcTypes, sdAbcVars, sdAbcFunctions;

const

  // Maximum number of icons stored with control.. this is a local
  // thumbnail/icon cache for just the page on the screen.. there
  // is no visible performance difference when lowering this value, so
  // it is now at a rather low value
  cMaxIconArea = 100000; // approx 100Kb * 4 per listview

type

  TListviewStyle = (
    lvsIcon,
    lvsSmallIcon,
    lvsList,
    lvsReport,
    lvsThumb
  );

  // Event types

  TBoolEvent = procedure(Sender: TObject; ABool: boolean) of object;

  TSelectItemEvent = procedure(Sender: TObject; AItem: TsdItem; Select: boolean) of object;

  TItemDataEvent = procedure(Sender: TObject; AItem: TsdItem; AListItem: TListItem) of object;

  TItemInfotipEvent = procedure(Sender: TObject; AItem: TsdItem; var AInfotip: string) of object;

  TListConfirmEvent = procedure(Sender: TObject; AList: TList; var Confirm: boolean) of object;

  // We need this special descendent of TCustomImageList to avoid
  // the listview from updating when the image list updates. We
  // have our own updating mechanism!
  TNoUpdateList = class(TCustomImageList)
  protected
    procedure Change; override;
  end;

  TItemView = class(TFrame)
    ListView: TListView;
    alItemView: TActionList;
    ilMenu: TImageList;
    SortRandom: TAction;
    SortName: TAction;
    SortDate: TAction;
    SortSize: TAction;
    SortOrder: TAction;
    ViewList: TAction;
    ViewSmall: TAction;
    ViewLarge: TAction;
    ViewThumb: TAction;
    ViewDetail: TAction;
    SortSeries: TAction;
    ItemDelete: TAction;
    ItemRemove: TAction;
    cbItems: TControlBar;
    tbSorting: TToolBar;
    tbViews: TToolBar;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    tbItems: TToolBar;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    pmToolbars: TPopupMenu;
    SortDate1: TMenuItem;
    SortDir1: TMenuItem;
    SortName1: TMenuItem;
    SortingToolbar: TAction;
    ViewsToolbar: TAction;
    ItemsToolbar: TAction;
    tbTypes: TToolBar;
    ToolButton1: TToolButton;
    ShowFiles: TAction;
    ShowFolders: TAction;
    ShowGroups: TAction;
    ShowSeries: TAction;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    TypesToolbar: TAction;
    TypesToolbar1: TMenuItem;
    ItemOpen: TAction;
    SelectAll: TAction;
    dftFiles: TDropFileTarget;
    dfsFiles: TDropFileSource;
    ddmFiles: TDropDummy;
    tmrShowItems: TTimer;
    pmItems: TPopupMenu;
    DeleteItems1: TMenuItem;
    RemoveItems1: TMenuItem;
    miShell: TMenuItem;
    N1: TMenuItem;
    Select1: TMenuItem;
    Lossless1: TMenuItem;
    RotateLeft: TAction;
    RotateRight: TAction;
    FlipHor: TAction;
    FlipVer: TAction;
    RotateLeft1: TMenuItem;
    RotateRight1: TMenuItem;
    FlipHorizontal1: TMenuItem;
    FlipVertical1: TMenuItem;
    N2: TMenuItem;
    SelectAll1: TMenuItem;
    Properties: TAction;
    SelectDuplicates: TAction;
    Duplicates1: TMenuItem;
    SelectDupeInFolder: TAction;
    DuplicatesinFolder1: TMenuItem;
    SortList1: TMenuItem;
    Unsorted1: TMenuItem;
    SortName2: TMenuItem;
    SortUnsorted: TAction;
    ByDate1: TMenuItem;
    BySize1: TMenuItem;
    BySeries1: TMenuItem;
    SortAscending: TAction;
    SortDescending: TAction;
    N3: TMenuItem;
    Ascending1: TMenuItem;
    Descending1: TMenuItem;
    N4: TMenuItem;
    Randomize1: TMenuItem;
    SortFolder: TAction;
    ByFolder1: TMenuItem;
    SortDupeGroup: TAction;
    ByDuplicateGroup1: TMenuItem;
    pnlEdit: TPanel;
    Panel2: TPanel;
    btnHideEdit: TSpeedButton;
    pcEdit: TPageControl;
    tsDescr: TTabSheet;
    tsRating: TTabSheet;
    ItemDescribe: TAction;
    ToolButton5: TToolButton;
    btnDescription: TBitBtn;
    cbbDescr: TComboBox;
    Label1: TLabel;
    lblLower: TLabel;
    lblHigher: TLabel;
    slQualRating: TRxSlider;
    lblQualRating: TLabel;
    btnQualOK: TBitBtn;
    Open1: TMenuItem;
    Properties2: TMenuItem;
    SendTo1: TMenuItem;
    SendToMySelection: TAction;
    SendToEmail: TAction;
    MySelection1: TMenuItem;
    SendToEmail1: TMenuItem;
    SelectInvert: TAction;
    SelectSmart: TAction;
    SmartSeries1: TMenuItem;
    Rotate180: TAction;
    Rotate180deg1: TMenuItem;
    Rename: TAction;
    RenameItems1: TMenuItem;
    ChangeFiledate: TAction;
    tsQSearch: TTabSheet;
    edQSearch: TEdit;
    Label2: TLabel;
    Image1: TImage;
    chbSearchFileName: TCheckBox;
    chbSearchDescription: TCheckBox;
    ToolButton7: TToolButton;
    QuickSearch: TAction;
    ItemRate: TAction;
    SearchShowAll: TAction;
    BitBtn1: TBitBtn;
    SortSimilar: TAction;
    BySimilarity1: TMenuItem;
    SortNameNum: TAction;
    ByNameNumeric1: TMenuItem;
    RotateOri: TAction;
    RotateusingEXIFori1: TMenuItem;
    procedure DrawBackGround(Sender: TCustomListView; const ARect: TRect; var DefaultDraw: Boolean); virtual;
    procedure ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange); virtual;
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn); virtual;
    procedure ListviewData(Sender: TObject; Item: TListItem); virtual;
    procedure ListviewDblClick(Sender: TObject); virtual;
    procedure ListViewEnter(Sender: TObject); virtual;
    procedure ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: String); virtual;
    procedure ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure SortRandomExecute(Sender: TObject);
    procedure SortNameExecute(Sender: TObject);
    procedure SortDateExecute(Sender: TObject);
    procedure SortSizeExecute(Sender: TObject);
    procedure ViewListExecute(Sender: TObject);
    procedure ViewSmallExecute(Sender: TObject);
    procedure ViewLargeExecute(Sender: TObject);
    procedure ViewDetailExecute(Sender: TObject);
    procedure ViewThumbExecute(Sender: TObject);
    procedure SortOrderExecute(Sender: TObject);
    procedure SortSeriesExecute(Sender: TObject);
    procedure ItemDeleteExecute(Sender: TObject);
    procedure ItemRemoveExecute(Sender: TObject);
    procedure SortingToolbarExecute(Sender: TObject);
    procedure ViewsToolbarExecute(Sender: TObject);
    procedure ItemsToolbarExecute(Sender: TObject);
    procedure ShowFilesExecute(Sender: TObject);
    procedure ShowFoldersExecute(Sender: TObject);
    procedure ShowGroupsExecute(Sender: TObject);
    procedure ShowSeriesExecute(Sender: TObject);
    procedure TypesToolbarExecute(Sender: TObject);
    procedure ItemOpenExecute(Sender: TObject);
    procedure SelectAllExecute(Sender: TObject);
    procedure dftFilesDrop(Sender: TObject; ShiftState: TShiftState; Point: TPoint; var Effect: Integer);
    procedure dftFilesGetDropEffect(Sender: TObject; ShiftState: TShiftState; Point: TPoint; var Effect: Integer);
    procedure dfsFilesFeedback(Sender: TObject; Effect: Integer; var UseDefaultCursors: Boolean);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure tmrShowItemsTimer(Sender: TObject);
    procedure RotateLeftExecute(Sender: TObject);
    procedure RotateRightExecute(Sender: TObject);
    procedure FlipHorExecute(Sender: TObject);
    procedure FlipVerExecute(Sender: TObject);
    procedure SelectDuplicatesExecute(Sender: TObject);
    procedure SelectDupeInFolderExecute(Sender: TObject);
    procedure SortUnsortedExecute(Sender: TObject);
    procedure SortDupeGroupExecute(Sender: TObject);
    procedure alItemViewUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure SortAscendingExecute(Sender: TObject);
    procedure SortDescendingExecute(Sender: TObject);
    procedure btnHideEditClick(Sender: TObject);
    procedure ItemDescribeExecute(Sender: TObject);
    procedure btnDescriptionClick(Sender: TObject);
    procedure lblLowerClick(Sender: TObject);
    procedure btnQualOKClick(Sender: TObject);
    procedure lblHigherClick(Sender: TObject);
    procedure slQualRatingChange(Sender: TObject);
    procedure pcEditChange(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewDataStateChange(Sender: TObject; StartIndex,
      EndIndex: Integer; OldState, NewState: TItemStates);
    procedure ListViewContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure PropertiesExecute(Sender: TObject);
    procedure SendToMySelectionExecute(Sender: TObject);
    procedure SendToEmailExecute(Sender: TObject);
    procedure SelectInvertExecute(Sender: TObject);
    procedure SortFolderExecute(Sender: TObject);
    procedure SelectSmartExecute(Sender: TObject);
    procedure Rotate180Execute(Sender: TObject);
    procedure ListViewEdited(Sender: TObject; Item: TListItem; var S: String);
    procedure ListViewEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure RenameExecute(Sender: TObject);
    procedure ChangeFiledateExecute(Sender: TObject);
    procedure edQSearchChange(Sender: TObject);
    procedure QuickSearchExecute(Sender: TObject);
    procedure ItemRateExecute(Sender: TObject);
    procedure SearchShowAllExecute(Sender: TObject);
    procedure SortSimilarExecute(Sender: TObject);
    procedure SortNameNumExecute(Sender: TObject);
    procedure RotateOriExecute(Sender: TObject);

  private
    FCurItem: integer; // index of current item
    FFirstTime: boolean;
    FItemIndex: integer;
    FTopItem, FRowCount: integer;
    FMinIndex, FMaxIndex: integer;
    FCachedItem: TListItem;
    procedure DoDelete(Sender: TObject); virtual;
    procedure DoGetFocus;
    procedure DoItemProperties(AItem: TsdItem);
    procedure DoItemSelect(AItem: TsdItem; Selected: boolean);
    procedure DoOpenItem(AItem: TsdItem);
    procedure DoRemove(Sender: TObject); virtual;
    procedure DoSelectionChanged(Quick: boolean);
    procedure DoStatusMessage(AMessage: string);
    procedure DoShowItem(AItem: TsdItem);
  protected
    FDragPoint: TPoint;
    FDropItem: TsdItem;
    FDropFolder: string;
    FIsActiveView: boolean;
    FIconCount: integer;
    FItemsValid: boolean;
    FItemFocused: TsdItem;
    FSelectBit: TSelectbit;
    FShowIcons: boolean;
    FSortMethod: TSortMethodType;
    FSortDirection: TSortDirectionType;
    FBackground: TPicture;
    FColumnList: TColumnList;
    FIconCnt: integer;
    FIndexList: array of integer;
    FItemviewType: TItemType;
    FItemList: TItemList;
    FTempFulder: string;
    FTimerIndex: integer;
    FViewStyle: TListviewStyle;

    // Event pointers
    FOnDelete: TListConfirmEvent;
    FOnGetFocus: TNotifyEvent;
    FOnItemData: TItemDataEvent;
    FOnItemInfoTip: TItemInfotipEvent;
    FOnItemProperties: TNotifyItemEvent;
    FOnItemSelect: TSelectItemEvent;
    FOnOpenItem: TNotifyItemEvent;
    FOnRemove: TListEvent;
    FOnSelectionChanged: TBoolEvent;
    FOnShowItem: TNotifyItemEvent;
    FOnStatusMessage: TStatusMessageEvent;
    FOnUpdateStatus: TNotifyEvent;
    FOnSetItemType: TNotifyItemTypeEvent;

    procedure AddToIcons(AIndex: integer; ABitmap: TBitmap);
    procedure CopySelection;
    function  CreateFilenameList: string;
    procedure DoUpdateSelected(UpdateFlags: TUpdateFlags);
    procedure DisableEditKeyShortCuts;
    procedure EnableEditKeyShortCuts;
    function  FirstItemWith(Phrase: string; SearchFileName, SearchDescription: boolean): integer;
    function  GetHasSelection: boolean; virtual;
    procedure GetIconForItem(AItemIndex: integer; AItem: TsdItem);
    function  GetCurItem: integer; virtual;
    function  GetCurItemID: TGUID; virtual;
    procedure GetThumbForItem(AItemIndex: integer; AItem: TsdItem);
    function  ItemVisible(Item: TListItem): boolean;
    procedure PopulateDropFileSource;
    procedure ResetViewstyle(AViewStyle: TListviewStyle);
    procedure SetBackground(const Value: TPicture);
    procedure SetDescriptionFromSelection;
    procedure SetColumnList(const AValue: TColumnList);
    procedure SetCurItem(AValue: integer); virtual;
    procedure SetCurItemID(const AValue: TGUID); virtual;
    procedure SetItemIndex(AValue: integer); virtual;
    procedure SetItemList(AValue: TItemList); virtual;
    procedure SetItemviewType(AValue: TItemType); virtual;
    procedure SetRatingFromSelection;
    procedure SortMessage(Sender: TObject; APercent: double); virtual;
    procedure UpdateView(Sender: TObject); virtual;
    procedure UpdateViewControls(Sender: TObject); virtual;
    procedure SetViewStyle(AValue: TListviewStyle);
  public
    Icons: TNoUpdateList;
    // Assign a TBitmap to Background to change the background appearance
    property Background: TPicture read FBackground write SetBackground;
    property ColumnList: TColumnList read FColumnList write SetColumnList;
    property DropItem: TsdItem read FDropItem write FDropItem;
    property DropFolder: string read FDropFolder write FDropFolder;
    property HasSelection: boolean read GetHasSelection;
    property IsActiveView: boolean read FIsActiveView write FIsActiveView;
    property IconCount: integer read FIconCount write FIconCount;
    property CurItem: integer read GetCurItem write SetCurItem;
    property CurItemID: TGUID read GetCurItemID write SetCurItemID;
    // Set ItemIndex to show the item at ItemIndex in the main app
    property ItemIndex: integer read FItemIndex write SetItemIndex;
    property ItemList: TItemList read FItemList write SetItemList;
    property ItemviewType: TItemType read FItemviewType write SetItemviewType;
    property SelectBit: TSelectBit read FSelectBit write FSelectBit;
    property ShowIcons: boolean read FShowIcons write FShowIcons;
    property SortDirection: TSortDirectionType read FSortDirection;
    property SortMethod: TSortMethodType read FSortMethod;
    property ViewStyle: TListviewstyle read FViewStyle write SetViewStyle;

    // events

    property OnDelete: TListConfirmEvent read FOnDelete write FOnDelete;
    property OnGetFocus: TNotifyEvent read FOnGetFocus write FOnGetFocus;
    property OnItemData: TItemDataEvent read FOnItemData write FOnItemData;
    property OnItemInfotip: TItemInfotipEvent read FOnItemInfotip write FOnItemInfotip;
    property OnItemProperties: TNotifyItemEvent read FOnItemProperties write FOnItemProperties;
    property OnItemSelect: TSelectItemEvent read FOnItemSelect write FOnItemSelect;
    property OnOpenItem: TNotifyItemEvent read FOnOpenItem write FOnOpenItem;
    property OnRemove: TListEvent read FOnRemove write FOnRemove;
    property OnSelectionChanged: TBoolEvent read FOnSelectionChanged write FOnSelectionChanged;
    property OnSetItemType: TNotifyItemTypeEvent read FOnSetItemType write FOnSetItemType;
    property OnShowItem: TNotifyItemEvent read FOnShowItem write FOnShowItem;
    property OnStatusMessage: TStatusMessageEvent read FOnStatusMessage write FOnStatusMessage;
    property OnUpdateStatus: TNotifyEvent read FOnUpdateStatus write FOnUpdateStatus;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AcceptDrop(var Effect: integer);
    procedure AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string);
    procedure AddSelectedItems(AList: TList); virtual;
    procedure BeginUpdate(Sender: TObject); virtual;
    procedure ClearItems(Sender: TObject); virtual;
    procedure CopyItems; virtual;
    procedure CutItems; virtual;
    procedure PasteItems; virtual;
    procedure EndUpdate(Sender: TObject); virtual;
    procedure FocusItem(AItem: TsdItem); virtual;
    procedure RemoveItems(Sender: TObject; AList: TList); virtual;
    procedure ResetIcons; virtual;
    procedure RangeUpdate(Sender: TObject; AMinIndex, AMaxIndex: integer);
    procedure ShellMenuClick(Sender: TObject);
    procedure SortByMethod(ASortMethod: TSortMethodType; ADirection: TSortDirectionType); virtual;
    procedure UpdateItem(Sender: TObject; AItem: TsdItem); virtual;
    procedure UpdateItemID(Sender: TObject; const AGuid: TGUID); virtual;

    // UpdateStatus is called whenever there's need to recalculate status
    // (or statistical) information about the list (e.g. a status bar showing
    // number of items).
    procedure UpdateStatus(Sender: TObject);
  end;

const

  cPastelBandingCols: array[0..6] of TColor =
   ($CC99FF, $99CCFF, $99FFFF, $CCFFCC, $FFFFCC, $FFCC99, $FF99CC);

  cGloomBandingCols: array[0..6] of TColor =
   ($336600, $663300, $330033, $660000, $000033, $006633, $003366);

implementation

uses

  Compares, sdRoots, sdProperties, Duplicates, Filters,
  guiMain, Expanders, guiDeleteFile, sdScanFolders, guiActions,
  ShFileOp, BrowseTrees, Links, guiRenameFiles, guiChangeFiledate, CopyFiles,
  guiSearchItems, PixRefs, guiShow, guiRotateExif, kbShellNotify;

{$R *.DFM}

// Use Dropcursors.res for the default ones
{$R Cursors.res}

const

  crCopy = 101;
  crMove = 102;
  crLink = 103;
  crCopyScroll = 104;
  crMoveScroll = 105;
  crLinkScroll = 106;


procedure TNoUpdateList.Change;
begin
  // Do NOTHING hehe! - this is to fool the Listview
end;

{ TItemView }

constructor TItemView.Create;
begin
  inherited Create(AOwner);

  FFirstTime := True;
  FCurItem := -1;

  Icons := TNoUpdateList.Create(Self);

  // Defaults
  FSortMethod := smNoSort;
  FSortDirection := sdAscending;
  ResetViewstyle(lvsReport);

  ItemList := TTypeFilter.Create;
  TTypeFilter(ItemList).AcceptedTypes := [itFile];
  TTypeFilter(ItemList).SortMethod := TSortMethod.Create;
  TTypeFilter(ItemList).SetCompareMethod(CompareItems, TTypeFilter(ItemList).SortMethod);
  TTypeFilter(ItemList).BatchInsert := cDefaultBatchInsert;
  SetItemviewType(itFile);

  FBackground := TPicture.Create;

  // Setup columns
  FColumnList := TColumnList.Create;
  FColumnList.Add(True, 'Items', 100, smNoSort, taLeftJustify);
  FColumnList.CopyToListView(Self, ListView);

  // Drag/Drop initialisation
  FDragPoint := point(-1,-1);

  //Load custom cursors...
  Screen.cursors[crCopy] := loadcursor(hinstance, 'COPY');
  Screen.cursors[crMove] := loadcursor(hinstance, 'MOVE');
  Screen.cursors[crLink] := loadcursor(hinstance, 'LINK');
  Screen.cursors[crCopyScroll] := loadcursor(hinstance, 'COPYSC');
  Screen.cursors[crMoveScroll] := loadcursor(hinstance, 'MOVESC');
  Screen.cursors[crLinkScroll] := loadcursor(hinstance, 'LINKSC');

end;

destructor TItemView.Destroy;
begin
  FreeAndNil(FItemList);
  FreeAndNil(FColumnList);
  FreeAndNil(FBackground);

  //UnRegister the DropTarget window...
  dftFiles.UnRegister;
  ddmFiles.UnRegister;

  inherited Destroy;
end;

procedure TItemView.DoGetFocus;
begin
  if assigned(FOnGetFocus) then
    FOnGetFocus(Self);
end;

procedure TItemView.DoItemSelect(AItem: TsdItem; Selected: boolean);
begin
  if assigned(FOnItemSelect) then
    FOnItemSelect(Self, AItem, Selected);
end;

procedure TItemView.DoItemProperties(AItem: TsdItem);
begin
  if assigned(FOnItemProperties) then
    FOnItemProperties(Self, AItem);
end;

procedure TItemView.DoStatusMessage(AMessage: string);
begin
  if assigned(FOnStatusMessage) then
    FOnStatusMessage(Self, AMessage);
end;

procedure TItemView.DoShowItem(AItem: TsdItem);
begin
  if assigned(FOnShowItem) then
    FOnShowItem(Self, AItem);
end;

procedure TItemView.DoOpenItem(AItem: TsdItem);
begin
  if assigned(FOnOpenItem) then
    FOnOpenItem(Self, AItem);
end;

procedure TItemView.DoSelectionChanged(Quick: boolean);
begin
  // This impacts the edit pane
  if (not Quick) and pnlEdit.Visible then
  begin

    // Description
    if pcEdit.ActivePage = tsDescr then
    begin
      SetDescriptionFromSelection;
    end;

    // Rating
    if pcEdit.ActivePage = tsRating then
    begin
      SetRatingFromSelection;
    end;

  end;

  // Signal main app
  if Assigned(FOnSelectionChanged) then
    FOnSelectionChanged(Self, Quick);
end;

procedure TItemView.DoDelete(Sender: TObject);
// Delete the selection
var
  List: TList;
  IndexFocused: integer;
  Confirm: boolean;
begin
  if assigned(FOnDelete) then
  begin

    // Create Delete list
    List := TList.Create;
    try
      AddSelectedItems(List);

      if List.Count > 0 then
      begin
        IndexFocused := ItemList.IndexOf(List[0]);

        // Call the delete event
        Confirm := False;
        FOnDelete(Self, List, Confirm);

        // Use the cached index
        if Confirm then
        begin
          Listview.ItemFocused := Listview.Items[IndexFocused];
          // Clear selection
          Listview.Selected := nil;
          // And just the item that is focused
          Listview.Selected := Listview.Items[IndexFocused];
        end;
      end;

    finally
      List.Free;
    end;
  end;
end;

procedure TItemView.DoRemove(Sender: TObject);
var
  List: TList;
  IndexFocused: integer;
begin
  if assigned(FOnRemove) then
  begin

    // Create remove list
    List := TList.Create;
    try
      AddSelectedItems(List);

      // Find the first index and store it as FocusIndex
      if List.Count > 0 then
      begin
        IndexFocused := ItemList.IndexOf(List[0]);

        // Expand the selection
        if assigned(FItemList) then
          ExpandSelectionMerge(List, FItemList.Parent, emRemoving);

        // Call the remove event
        FOnRemove(Self, List);

        // Use the cached index
        Listview.ItemFocused := Listview.Items[IndexFocused];
        // Clear selection
        Listview.Selected := nil;
        // And just the item that is focused
        Listview.Selected := Listview.Items[IndexFocused];

      end;

    finally
      List.Free;
    end;

  end;
end;

procedure TItemView.UpdateItem(Sender: TObject; AItem: TsdItem);
var
  Index: integer;
begin
  Index := -1;
  if assigned(AItem) then
  begin
    if (ItemList.Sortmethod.Method[0] in [smRandom, smNoSort]) or
       not ItemList.Find(AItem, Index) then
    begin
      // In some cases "Find" does not work
      Index := ItemList.IndexOf(AItem);
    end;

    if Index >= 0 then
    begin

      // Make sure to delete the cached thumbnail first
      FIndexList[Index mod IconCount] := -1;

      // And update it!
      ListView.UpdateItems(Index, Index);

    end;
  end;
end;

procedure TItemView.UpdateItemID(Sender: TObject; const AGuid: TGUID);
var
  Item: TsdItem;
begin

  Item := ItemList.Root.ItemByGuid(AGuid);
  UpdateItem(Sender, Item);

end;

procedure TItemView.UpdateStatus(Sender: TObject);
begin
  if assigned(FOnUpdateStatus) then
    FOnUpdateStatus(Self);
end;

procedure TItemView.UpdateViewControls;
var
  i: integer;
  C: TListColumn;
  Cap: string;
begin

  // Redecorate the listview columns
  if (ListView.ViewStyle = vsReport) then
    if assigned(ListView.Columns) and assigned(ColumnList) then
      for i := 0 to ListView.Columns.Count - 1 do 
      begin
        C := ListView.Columns[i];

        // Strip all '+' and '-' signs
        Cap := C.Caption;
        if (Cap[Length(Cap)] = '+') or (Cap[Length(Cap)] = '-') then

          // strip one char
          C.Caption := copy(Cap, 1, Length(Cap) - 1);

        // Check if we sort on this column
        if FSortMethod = ColumnList[Tag].SortMethod then

          // Add the '+' or '-' in the right spot
          if FSortDirection = sdAscending then
            C.Caption := C.Caption + '+'
          else
            C.Caption := C.Caption + '-';

        end;

end;

procedure TItemView.FocusItem(AItem: TsdItem);
var
  Index: integer;
begin

  // Only focus on an item if the listview is the active one
  if IsActiveView = true then
  begin

    // We cannot trust "find" in all circumstances (eg when sorted on dimensions
    // and the app has updated some dimension properties)
    if not ItemList.Find(AItem, Index) then
      Index := ItemList.IndexOf(AItem);

    if Index >= 0 then
    begin

      ListView.ItemFocused := Listview.Items[Index];
      ListView.Items[Index].MakeVisible(False);

    end;
  end;
  FItemFocused := nil;

end;

procedure TItemView.AcceptDrop(var Effect: integer);
// AcceptDrop handles the drop into a TItemView. It is called from
// methods PasteItems and dftFilesDrop (the drop method of the DropfilesTarget)
var
  AList: TStringList;
begin
  // The try..finally here will cause all exits to pass finally
  try
    if Effect = DROPEFFECT_NONE then exit; // nothing to do

    if assigned(DropItem) then
    begin

      // Let the dropitem handle it
      DropItem.AcceptDrop(Effect)

    end else
    begin

      // Files added to empty space must be indexed
      if DropFolder = '' then
        Effect := DROPEFFECT_LINK;

      AList := TStringList.Create;
      try
        DropList.GetExternal(AList);
        CopyMoveFiles(Self, AList, DropFolder, Effect);
      finally
        AList.Free;
      end;

    end;

  finally
    // Clear any drop info
    DropSender := nil;
    DropList.Clear;
  end;
end;

procedure TItemView.AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string);
// AllowDrop will feedback the effect type for current droplist
begin

  Effect := DROPEFFECT_NONE;
  AMessage := '';

  if assigned(DropItem) then
  begin

    DropItem.AllowDrop(Effect, Shift, AMessage);

  end else
  begin

    if length(DropFolder) > 0 then
    begin
      // A dropfolder can accept TFile, TFolder, TSeries, TExtFile
      if DropList.Contains(TsdFile) or DropList.Contains(TsdFolder) or
         DropList.Contains(TsdSeries) or DropList.Contains(TExtFile) then
      begin
        if ssCtrl in Shift then
        begin
          if (ssShift in Shift) and DropList.Contains(TExtFile) then
          begin
            Effect := DROPEFFECT_LINK;
            AMessage := 'Create reference to file(s)';
          end else
          begin
            Effect := DROPEFFECT_COPY;
            AMessage := 'Copy here';
          end;
        end else
        begin
          Effect := DROPEFFECT_MOVE;
          AMessage := 'Move here';
        end;
      end;
    end else
    begin
      // No dropfolder, so only accept references
      if DropList.Contains(TExtFile) then
      begin
        Effect := DROPEFFECT_LINK;
        AMessage := 'Create reference to file(s)';
      end;
    end;

  end;

end;

procedure TItemView.CopySelection;
var
  Item: TListItem;
begin

  ItemList.ClearSelection(SelectBit);

  if (ListView.SelCount > 0) then
  begin
    if ListView.SelCount > 100 then
      DoStatusMessage('Calculating selection...');
    Item := ListView.Selected;
    repeat
      if Item.Selected then
        ItemList[Item.Index].IsSelected[SelectBit] := true;
      Item := ListView.GetNextItem(Item, sdAll, [isSelected]);
    until Item = nil;
    if ListView.SelCount > 100 then
      DoStatusMessage('');
  end;
end;

function TItemView.CreateFilenameList: string;
var
  i: integer;
  List: TList;
begin
  Result := '';
  List := TList.Create;
  try
    // Get the selection
    AddSelectedItems(List);

    for i := 0 to List.Count - 1 do
    begin

      case TsdItem(List[i]).ItemType of
      itFile:
        begin
          // Add this file
          if length(Result) > 0 then
            Result := Result + #13;
          Result := Result + TsdFile(List[i]).FileName;
        end;
      end;//case
    end;

  finally
    List.Free;
  end;
end;

procedure TItemView.DisableEditKeyShortCuts;
begin
  // We need to disable the [del] hotkeys for delete
  frmMain.ItemView1.ItemDelete.ShortCut := scNone;
  //frmMain.ItemView2.ItemDelete.ShortCut := scNone;
  dmActions.ItemDelete.ShortCut := scNone;
  frmShow.ItemDelete.ShortCut := scNone;
end;

procedure TItemView.EnableEditKeyShortCuts;
begin
  ItemDelete.ShortCut := TextToShortcut('Del');
  dmActions.ItemDelete.ShortCut := TextToShortcut('Del');
  frmShow.ItemDelete.ShortCut := TextToShortcut('Del');
end;

procedure TItemView.DoUpdateSelected(UpdateFlags: TUpdateFlags);
var
  i: integer;
  List: TList;
begin
  List := TList.Create;
  try
    // Get the selection
    AddSelectedItems(List);
    for i := 0 to List.Count - 1 do
      TsdItem(List[i]).Update(UpdateFlags);
  finally
    List.Free;
  end;
end;

procedure TItemView.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
  i: integer;
  AItem: TsdItem;
  Selected: boolean;
begin
  // Do we see selection changes?
  if (Change = ctState) then
  begin
    if assigned(Item) then
    begin

      // Single toggle
      AItem := ItemList[Item.Index];
      Selected := Item.Selected;
      if AItem.IsSelected[SelectBit] <> Selected then
      begin
        AItem.IsSelected[SelectBit] := Selected;
        DoItemSelect(AItem, Selected);
        FMinIndex := Min(FMinIndex, Item.Index);
        FMaxIndex := Max(FMaxIndex, Item.Index + 1);
        // Let Main know
        DoSelectionChanged(True);
      end;

      // If the item becomes focused, then show it
      if Item.Focused then
      begin

        // Set ItemIndex to index of showing item, this will update the app
        ItemIndex := Item.Index;

        if Sender is TListView then
          DoGetFocus;
      end;

    end else
    begin

      // Reset the list
      DoItemSelect(nil, False);

      // Clear all bits between Min and Max
      for i := FMinIndex to FMaxIndex - 1 do
        if assigned(ItemList[i]) then
          ItemList[i].IsSelected[SelectBit] := False;
      // Set Min and Max to initial values
      FMinIndex := ItemList.Count;
      FMaxIndex := 0;

      // Let Main know
      DoSelectionChanged(False);
    end;

  end;
end;

function TItemView.FirstItemWith(Phrase: string; SearchFileName, SearchDescription: boolean): integer;
var
  i, APos: integer;
  Phrases: TStringList;
  // local
  function DoSearch(ALine: string): integer;
  // DoSearch will test if all phrases are present. Result will contain the position
  // of the first, or 0 if not all are found
  // Assumes Phrases assigned, and at least 1 element
  var
    i: integer;
  begin
    Result := Pos(Phrases[0], ALine);
    i := 1;
    while (Result > 0) and (i < Phrases.Count) do
    begin
      Result := Min(Result, Pos(Phrases[i], ALine));
      inc(i);
    end;
  end;
// main
begin
  Result := -1;
  Phrases := TStringList.Create;
  try
    SplitToWords(lowercase(Phrase), Phrases);
    if Phrases.Count = 0 then exit;
    for i := 0 to ItemList.Count - 1 do
    begin
      if SearchFileName then
      begin
        APos := DoSearch(lowercase(ItemList[i].Name));
        if APos > 0 then
        begin
          Result := i;
          if APos = 1 then
            exit;
        end;
      end;

      if SearchDescription then
        if DoSearch(lowercase(ItemList[i].Description)) > 0 then
        begin
          Result := i;
          exit;
        end;
    end;
  finally
    Phrases.Free;
  end;
end;

function TItemView.GetCurItem: integer;
begin
  // test!
  if FCurItem = -1 then
  begin
    if assigned(ListView.ItemFocused) then
      FCurItem := ListView.ItemFocused.Index;
  end;
  Result := FCurItem;
end;

function TItemView.GetCurItemID: TGUID;
var
  Item: TsdItem;
  Index: integer;
begin
  Result := cEmptyGuid;
  Index := GetCurItem;
  Item := ItemList[Index];
  if assigned(Item) then
    Result := Item.Guid;
end;

procedure TItemView.SetCurItem(AValue: integer);
begin
  if (AValue >= 0) and (AValue < ItemList.Count) then
  begin
    ListView.ItemFocused := ListView.Items[AValue];
    ListView.ItemFocused.MakeVisible(False);
    FCurItem := AValue;
  end;
end;

procedure TItemView.SetCurItemID(const AValue: TGuid);
var
  Index: integer;
begin
  Index := ItemList.IndexOf(ItemList.ItemByGuid(AValue));
  SetCurItem(Index);
end;

procedure TItemView.SetItemIndex(AValue: integer);
begin
  // Set this item
  FItemIndex := AValue;

  // Signal main app
  DoShowItem(ItemList[FItemIndex]);

  // Update bars etc
  DoSelectionChanged(False);
end;

procedure TItemView.SetItemList(AValue: TItemList);
begin
  if AValue <> FItemList then
  begin

    AValue.OnBeginUpdate := BeginUpdate;
    AValue.OnClearItems  := ClearItems;
    AValue.OnEndUpdate   := EndUpdate;
    AValue.OnUpdate      := UpdateStatus;
    AValue.OnRemoveItems := RemoveItems;
    AValue.OnRangeUpdate := RangeUpdate;

    if assigned(FItemList) then
    begin
      AValue.Parent := FItemList.Parent;
      FreeAndNil(FItemList);
    end;

    FItemList := AValue;
  end;
end;

procedure TItemView.SetItemviewType(AValue: TItemType);
begin
  //
  if FItemviewType <> AValue then
  begin

    FItemviewType := AValue;

    if assigned(FOnSetItemType) then
      FOnSetItemType(Self, itItem);

    TTypeFilter(ItemList).AcceptedTypes := [FItemviewType];

    if assigned(FOnSetItemType) then
      FOnSetItemType(Self, FItemviewType);

    UpdateViewControls(Self);

  end;
end;

procedure TItemView.SetBackground(const Value: TPicture);
begin
  FBackground.Assign(Value);
  Invalidate;
end;

procedure TItemView.SetColumnList(const AValue: TColumnList);
begin
  if AValue <> nil then
  begin
    FreeandNil(FColumnList);
    FColumnList := AValue;
    FColumnList.CopyToListView(Self, ListView);
  end;
  Invalidate;
end;

function  TItemView.GetHasSelection: boolean;
begin
  Result := ListView.SelCount > 0;
end;

// DoubleClick in Listview
procedure TItemView.ListviewDblClick(Sender: TObject);
begin
  ItemOpenExecute(Sender);
end;

procedure TItemView.AddToIcons(AIndex: integer; ABitmap: TBitmap);
var
  i, APos: integer;
begin
  if assigned(ABitmap) and assigned(Icons) and
    (ABitmap.Width = Icons.Width) and
    (ABitmap.Height = Icons.Height) then
  begin
    APos := AIndex mod IconCount;
    if Icons.Count > APos then
      Icons.Replace(APos, ABitmap, nil)
    else
    begin
      for i:= Icons.Count to APos do
        Icons.Add(ABitmap, nil);
    end;
    FIndexList[APos] := AIndex;
  end;
end;

procedure TItemView.GetIconForItem(AItemIndex: integer; AItem: TsdItem);
var
  AIcon: integer;
  AType: string;
  ABitmap, ACopy: TBitmap;
begin
  // Use the item's own mechanism!
  AIcon := -1;
  case AItem.ItemType of
  itFile:   TsdFile(AItem).GetIconAndType(AIcon, AType);
  itFolder: TsdFolder(AItem).GetIconAndType(AIcon, AType);
  end;//case

  if AIcon >= 0 then
  begin
    ABitmap := TBitmap.Create;
    try
      // Get the icon
      if assigned(Listview.SmallImages) then
        FSmallIcons.GetBitmap(AIcon, ABitmap)
      else
        if assigned(Listview.LargeImages) then
          FLargeIcons.GetBitmap(AIcon, ABitmap);
      // Add to our icons
      if (Icons.Width = ABitmap.Width) and (Icons.Height = ABitmap.Height) then
      begin
        AddToIcons(AItemIndex, ABitmap);
      end else
      begin
        // Create copy first
        ACopy := TBitmap.Create;
        try
          ACopy.Width := Icons.Width;
          ACopy.Height := Icons.Height;
          ACopy.Canvas.Draw(
            (Icons.Width - ABitmap.Width) div 2,
            (Icons.Height - ABitmap.Height) div 2,
            ABitmap);
          AddToIcons(AItemIndex, ACopy);
        finally
          ACopy.Free;
        end;
      end;
    finally
      ABitmap.Free;
    end;
  end;
end;

procedure TItemView.GetThumbForItem(AItemIndex: integer; AItem: TsdItem);
var
  ABitmap, ACopy: TBitmap;
  Scale: double;
  SizeX, SizeY, OffsX, OffsY: integer;
begin
  ABitmap := TBitmap.Create;
  try
    if AItem.GetGraphic(rtThumbnail, rpMedium, 0, 0, 0, UpdateItemID, nil, ABitmap) = grOK then
    begin

      // Add to our icons - Create copy first
      ACopy := TBitmap.Create;
      try
        ACopy.Width := Icons.Width;
        ACopy.Height := Icons.Height;
        ACopy.Canvas.Brush.Color := clGray;
        ACopy.Canvas.Brush.Style := bsSolid;
        ACopy.Canvas.FillRect(rect(0, 0, ACopy.Width, ACopy.Height));
        if HasContent(ABitmap) then
        begin
          Scale := Min(ACopy.Width / ABitmap.Width, ACopy.Height / ABitmap.Height);
          Scale := Min(Scale, 1);
          SizeX := round(ABitmap.Width * Scale);
          SizeY := round(ABitmap.Height * Scale);
          OffsX := (ACopy.Width - SizeX) div 2;
          OffsY := (ACopy.Height - SizeY) div 2;
          if Scale <> 1 then
            ACopy.Canvas.StretchDraw(rect(OffsX, OffsY, SizeX + OffsX, SizeY + OffsY), ABitmap)
          else
            ACopy.Canvas.Draw(OffsX, OffsY, ABitmap);
        end;
        ACopy.Canvas.Pen.Color := clBlack;
        ACopy.Canvas.Brush.Style := bsClear;
        ACopy.Canvas.Rectangle(rect(0, 0, ACopy.Width, ACopy.Height));
        AddToIcons(AItemIndex, ACopy);
      finally
        ACopy.Free;
      end;

    end else
    begin

      // Use the icon
      GetIconForItem(AItemIndex, AItem);

    end;
  finally
    ABitmap.Free;
  end;
end;

procedure TItemView.ListviewData(Sender: TObject; Item: TListItem);
var
  LItem: TsdItem;
begin
  Item.ImageIndex := Item.Index mod IconCount;

  LItem := ItemList[Item.Index];

  // Default data:
  Item.Caption := '<error>';

  if assigned(LItem) then
  begin
    // This routine is called *lots* so try to optimise data req's
    if ItemVisible(Item) then
    begin
      if ViewStyle = lvsReport then
      begin

        // Get all the data.. this is provided externally through OnItemData
        if assigned(FOnItemData) then
          FOnItemData(Self, LItem, Item);

      end else
      begin

        // Just the caption suffices
        Item.Caption := LItem.Name;

      end;
    end;
  end;
end;

procedure TItemView.ListViewEnter(Sender: TObject);
begin
  // Signal the mainf that we've become active
  DoGetFocus;

  // Make sure that the right buttons are selected
  UpdateViewControls(Self);

  // Make sure to show the right status
  UpdateStatus(Self);
end;

procedure TItemView.ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: String);
begin
  if FShowInfoTip then
  begin
    if assigned(FOnItemInfoTip) then
      FOnItemInfoTip(Self, ItemList[Item.Index], Infotip)
    else
      InfoTip := ItemList[Item.Index].Name;
  end else
    InfoTip := '';
end;

procedure TItemView.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // React to keyboard events
  case Key of
  VK_RETURN: ItemOpen.Execute;

  // Select All with CTRL-A
  $0041:
    if ssCtrl in Shift then
      SelectAll.Execute;

  // Copy with Ctrl-C
  $0043:
    if ssCtrl in Shift then
      CopyItems;

  // Cut with Ctrl-X
  $0058:
    if ssCtrl in Shift then
      CutItems;
  end;
end;

procedure TItemView.DrawBackGround(Sender: TCustomListView; const ARect: TRect; var DefaultDraw: Boolean);
var
  x, y: integer;
  AText: string;
  ActiveItem: TBrowseItem;
  MyRect, Tmp: TRect;
  C: TCanvas;
begin
  C := TCustomListview(Sender).Canvas;

  if (assigned(Background.Bitmap)) and
     (Background.Bitmap.Width>0)   and
     (Background.Bitmap.Height>0)  and
     (FWindowsVer <> wvWinXP) then // Unfortunately this custom drawing does not work on XP
  begin
    y := 0;
    while y < Height do
    begin
      x := 0;
      while x < Width do
      begin
        MyRect := Rect(x, y, x + FBackground.Width, y + Fbackground.Height);
        if IntersectRect(Tmp, MyRect, ARect) then
          C.Draw(x, y, FBackground.Bitmap);
        x := x + FBackground.Width;
      end;
      y := y + FBackground.Height;
    end;

  end;

  // Empty listview?
  if ItemList.Count = 0 then
  begin
    // Get the active item
    ActiveItem := nil;
    if assigned(frmMain.Browser) then
      // Use MenuItem instead of ActiveItem, the latter is only set *after*
      // activation
      ActiveItem:= frmMain.Browser.MenuItem;
    if assigned(ActiveItem) then
    begin
      AText := ActiveItem.GetEmptyWarning;
    end else
    begin
      // No browse item selected
      AText := 'Please add some items to your collection by browsing and checking folders.';
    end;

    // Output the text
    // Transparent drawing.
    SetBkMode(C.Handle, Transparent);
    // Write the text to the screen, adapt to view style
    if ViewStyle = lvsReport then
      C.TextOut(10, 14 + abs(Font.Height), AText)
    else
      C.TextOut(10, 10, AText);
  end;
end;

procedure TItemView.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);

const
  NearItems: array[0..7] of integer = (10, -10, 20, -20, 40, -40, 70, -70);
var
  i: integer;
  NearItem: TsdItem;
  AItemIndex, AImageIndex: integer;
  AItem: TsdItem;
  ABand: integer;
  AColor: TColor;
begin
  // workaround for the strange bug that causes the wrong font to be used
  // for the first item drawn
  if FFirstTime then
  begin
    InvalidateRect(0, nil, False);
    FFirstTime := False;
  end;

  if not assigned(Item) then
    exit;

  AItemIndex := Item.Index;
  AImageIndex := AItemIndex mod IconCount;

  // Color banding
  if FOverrideListviewBgr then
    AColor := FMainBgrColor
  else
    AColor := Color;
  if assigned(ItemList[Item.Index]) then
  begin
    ABand := ItemList[Item.Index].Band;
    if (ABand >= 0) then
    begin
      case FColorGrouping of
      cColorGroupingPastel: AColor := cPastelBandingCols[ABand mod 7];
      cColorGroupingGloom:  AColor := cGloomBandingCols[ABand mod 7];
      end;//case
    end;
  end;
  TCustomListview(Sender).Canvas.Brush.Color := AColor;

  // Already there?
  if FIndexList[AImageIndex] <> AItemIndex then
  begin

    // Check to see if we already have a thumbnail
    AItem := ItemList[AItemIndex];
    if assigned(AItem) then
    begin

      if ShowIcons then
      begin

        // Showing icons
        GetIconForItem(AItemIndex, AItem);

      end else
      begin

        // Showing thumbnails
        GetThumbForItem(AItemIndex, AItem);

      end;
    end;
  end;

  if not ShowIcons then
  begin

    // Predecoding of near items
    for i := 0 to 7 do
    begin
      // Pointer to the item
      NearItem := ItemList[Item.Index + NearItems[i]];

      if assigned(NearItem) and (NearItem.States * [isDeleted, isNoAccess, isDecodeErr] = []) then
        NearItem.Request(rtThumbnail, rpLow, 0, 0, 0, nil, UpdateItemID, nil);
    end;
  end;
end;

procedure TItemView.UpdateView(Sender: TObject);
begin
  // Test
  if ListView.Items.Count <> ItemList.Count then
  begin
    ListView.Items.Count := ItemList.Count;
    ListView.Invalidate;
  end;
end;

procedure TItemView.AddSelectedItems(AList: TList);
var
  Item: TListItem;
begin
  if not assigned(AList) then
    exit;

  if ListView.SelCount > 0 then
  begin
    Item := ListView.Selected;
    repeat
      if Item.Selected then
        AList.Add(ItemList[Item.Index]);
      Item := ListView.GetNextItem(Item, sdAll, [isSelected]);
    until Item = nil;
  end;
end;

procedure TItemView.BeginUpdate;
begin

  // Store focused item
  if assigned(ListView.ItemFocused) then
  begin

    // Store focused item
    FItemFocused := ItemList[ListView.ItemFocused.Index];

    // Clear focused item
    ListView.ItemFocused := nil;

  end else

    FItemFocused := nil;

  // Copy the selection info from listview to ItemList
  CopySelection;

  // Store top item and visible row count
  if ViewStyle in [lvsList, lvsReport] then
  begin
    FTopItem := ListView.TopItem.Index;
    FRowCount := Listview.VisibleRowCount;
  end else
  begin
    FTopItem := 0;
    FRowCount := ItemList.Count;
  end;

end;

procedure TItemView.EndUpdate;
var
  i: integer;
  ItemSelected: boolean;
begin

  // Reflect changes

  // Scan through the list and select each item that should be selected
  if ItemList.Count > 1000 then
  begin
    // To avoid waiting this construct is used (but will result in a
    // slight flicker)
    ListView.Selected := nil;
    for i := 0 to ItemList.Count - 1 do
      if ItemList[i].IsSelected[SelectBit] then
        ListView.Items[i].Selected := True;
  end else
  begin
    for i:=0 to ItemList.Count - 1 do
    begin
      ItemSelected := ListView.Items[i].Selected;
      if ItemSelected <> ItemList[i].IsSelected[SelectBit] then
        ListView.Items[i].Selected := ItemList[i].IsSelected[SelectBit];
    end;
  end;

  // Focus on the item
  FocusItem(FItemFocused);
end;


procedure TItemView.ListViewColumnClick(Sender: TObject; Column: TListColumn);
var
  ASortMethod: TSortMethodType;
  ASortDirection: TSortDirectionType;
begin

  ASortMethod := ColumnList.FindColumn(Column.Index).SortMethod;
  ASortDirection := sdAscending;

  // Did we already sort on this column? If so, change sort direction
  if (ItemList.SortMethod.Method[0] = ASortMethod) and
     (ItemList.SortMethod.Direction[0] = sdAscending) then
    ASortDirection := sdDescending;

  // Sort the listview
  SortByMethod(ASortMethod, ASortDirection);

end;

procedure TItemView.RemoveItems(Sender: TObject; AList: TList);
begin
  // Make sure that both lists are equal in length
  if ItemList.Count <> ListView.Items.Count then
    ListView.Items.Count := ItemList.Count;
end;

procedure TItemView.ResetIcons;
begin
  ResetViewstyle(Viewstyle);
end;

function TItemView.ItemVisible(Item: TListItem): boolean;
var
  ARect: TRect;
begin
  Result := False;
  if Item = FCachedItem then
    exit;

  FCachedItem := Item;
  if assigned(Item) then
  begin
    ARect := Item.DisplayRect(drBounds);
    Result := True;
    FCachedItem := nil;
    if (ARect.Left > Listview.Width) or
       (ARect.Right < 0) or
       (ARect.Top > Listview.Height) or
       (ARect.Bottom < 0) then
      Result := False;
  end;
end;

procedure TItemView.PopulateDropFileSource;
var
  i: integer;
begin
  dfsFiles.Files.clear;
  Droplist.Clear;

  // Selected items
  AddSelectedItems(DropList);

  // Only continue if we have items
  if DropList.Count = 0 then
    exit;

  // Drag Image
  if DropList.Count > 0 then
    dfsFiles.ImageIndex := TsdItem(DropList[0]).Icon
  else
    dfsFiles.ImageIndex := -1;

  // Fill DropFileSource
  for i := 0 to DropList.Count - 1 do
  begin
    // Add Files and Folders
    if (TObject(DropList[i]) is TsdFile) or
       (TObject(DropList[i]) is TsdFolder) then
      dfsFiles.Files.Add(TsdItem(DropList[i]).Filename);
  end;

  // What actions do we support
  dfsFiles.Dragtypes := Droplist.DragTypes;
end;

procedure TItemView.ResetViewstyle(AViewStyle: TListviewStyle);
var
  i: integer;
begin
  // Start w reset
  Listview.Items.Count := 0;
  Listview.SmallImages := nil;
  Listview.LargeImages := nil;
  Icons.Clear;

  // Set correct icon size and Listview style
  case AViewStyle of
  lvsIcon:
    begin
      Icons.Width  := FViewLargeW;
      Icons.Height := FViewLargeH;
      Listview.ViewStyle := vsIcon;
      Listview.LargeImages := Icons;
      ShowIcons := FViewLargeShowIcons;
    end;
  lvsSmallIcon:
    begin
      Icons.Width  := FViewSmallW;
      Icons.Height := FViewSmallH;
      Listview.ViewStyle := vsSmallIcon;
      Listview.SmallImages := Icons;
      ShowIcons := FViewSmallShowIcons;
    end;
  lvsList:
    begin
      Icons.Width  := FViewListW;
      Icons.Height := FViewListH;
      Listview.ViewStyle := vsList;
      Listview.SmallImages := Icons;
      ShowIcons := FViewListShowIcons;
    end;
  lvsReport:
    begin
      Icons.Width  := FViewDetailW;
      Icons.Height := FViewDetailH;
      Listview.ViewStyle := vsReport;
      Listview.SmallImages := Icons;
      ShowIcons := FViewDetailShowIcons;
    end;
  lvsThumb:
    begin
      Icons.Width  := FThumbWidth;
      Icons.Height := FThumbHeight;
      Listview.ViewStyle := vsIcon;
      Listview.LargeImages := Icons;
      ShowIcons := False;
    end;
  end;//case

  // Determine size of iconlist
  IconCount := Max(cMaxIconArea div (Icons.Width * Icons.Height), 1);
  SetLength(FIndexList, IconCount);
  for i := 0 to IconCount - 1 do
    FIndexList[i] := -1;

  // Set Icons
  Icons.AllocBy := IconCount;

  // Start again
  if assigned(FItemList) then
    Listview.Items.Count := FItemList.Count;
  Listview.Invalidate;
end;

procedure TItemView.SortByMethod(ASortMethod: TSortMethodType; ADirection: TSortDirectionType);
var
  i, ARandom: longint;
  ABand: smallint;
  InGroup, NextIdem: boolean;
  // local
  procedure DoArrangeItems;
  begin
    ItemList.ArrangeItems(@PixRefDifference, nil, @PixRefPointer)
  end;
//main
begin
  // Hourglass
  Screen.Cursor:=crHourGlass;
  try

    // Add the sortmethod to FSortMethod
    ItemList.SortMethod.AddMethod(ASortMethod, ADirection);

    if assigned(ItemList.SortMethod) then
    begin
      FSortMethod := ItemList.SortMethod.Method[0];
      FSortDirection := ItemList.SortMethod.Direction[0];
    end else
    begin
      FSortMethod := smNoSort;
      FSortDirection := sdAscending;
    end;

    case FSortMethod of
    smRandom:
    begin

      BeginUpdate(Self);

      // Randomize the list
      Randomize;
      ItemList.LockWrite;
      try

        for i := 0 to ItemList.Count - 1 do
        begin
          ARandom := Random(ItemList.Count);
          if (ItemList.DirectItems[ARandom] <> FItemFocused) and (ItemList.DirectItems[i] <> FItemFocused) then
            // swap
            ItemList.DirectItems.Exchange(i, ARandom);

          if (i mod 1000) = 0 then
            DoStatusMessage(Format('Randomizing %d items... %2.0f%% done',[ItemList.Count,
              (i / (ItemList.Count-1))*100]));
        end;

        ItemList.Sorted := False;
      finally
        ItemList.UnlockWrite;
      end;
      EndUpdate(Self);
      Listview.Invalidate;

      DoStatusMessage(
        Format('Randomizing %d items... 100%% done', [ItemList.Count]));

    end;
    smBySimilarity:

      // Depending on method, choose the appropriate one
      case FSimilaritySortMethod of
      cssmAutoMethod:
        if ItemList.Count > FSimAutoLimit then
          ItemList.SortItems
        else
          DoArrangeItems;
      // SortItems is the fast (but inaccurate one)
      cssmFastMethod: ItemList.SortItems;
      // DoArrangeItems will call ItemList.ArrangeItems.. slow but very accurate
      cssmSlowMethod: DoArrangeItems;
      end;

    smNoSort: ;
      // we do nothing
    else

      // Sort the list - BeginUpdate and EndUpdate are called through this
      // routine
      ItemList.SortItems;

    end;

    // Color banding
    if (FColorGrouping <> cColorGroupingNone) and ItemList.Sorted then
    begin

      FGroupingInUse := True;
      // The algorithm to find which ones are in same band
      ABand := 0;
      i := 0;
      InGroup := False;
      NextIdem := False;
      while i < ItemList.Count do
      begin
        if i < ItemList.Count - 1 then
          NextIdem := CompareItemsOneLevel(
            TsdItem(ItemList.DirectItems[i]),
            TsdItem(ItemList.DirectItems[i + 1]), ItemList.SortMethod) = 0;

        // Band number or none
        if (InGroup or NextIdem) then
          TsdItem(ItemList.DirectItems[i]).Band := ABand
        else
          TsdItem(ItemList.DirectItems[i]).Band := ciNoBand;

        // Determine next band
        if (not InGroup) and NextIdem then
          InGroup := True;
        if InGroup and (not NextIdem) then
        begin
          InGroup := False;
          inc(ABand);
        end;

        inc(i);
      end;

    end else
    begin

      // Remove any bands
      if FGroupingInUse then
        for i := 0 to ItemList.Count - 1 do
          TsdItem(ItemList.DirectItems[i]).Band := ciNoBand;
      FGroupingInUse := False;

    end;

    UpdateViewControls(Self);

  finally
    // Normal cursor
    Screen.Cursor:=crDefault;
  end;
end;

procedure TItemView.SortMessage(Sender: TObject; APercent: double);
begin
  DoStatusMessage(
    Format('Sorting %d items... %2.0f%% done',[ItemList.Count, APercent]));
end;

procedure TItemView.SetViewStyle(AValue: TListviewStyle);
var
  i: integer;
begin
  if AValue <> FViewStyle then
  begin

    // Store old position
    BeginUpdate(Self);
    try

      if FViewStyle = lvsReport then

        // Store the widths
        for i := 0 to ListView.Columns.Count-1 do
          FColumnList[Tag].Width := ListView.Columns[i].Width;

      FViewStyle := AValue;
      ResetViewstyle(FViewStyle);

      if FViewStyle = lvsReport then
        ColumnList.CopyToListView(Self, ListView);

    finally
      EndUpdate(Self);
    end;

  end;
end;

procedure TItemView.ClearItems(Sender: TObject);
begin
  UpdateView(Self);
  UpdateViewControls(Self);
end;

procedure TItemView.RangeUpdate(Sender: TObject; AMinIndex, AMaxIndex: integer);
var
  i: integer;
begin
  // Correct number of items
  if ItemList.Count <> ListView.Items.Count then
    ListView.Items.Count := ItemList.Count;

  // The range between AMinIndex adn AMaxIndex must be updated
  if ViewStyle in [lvsIcon, lvsSmallIcon, lvsThumb] then
  begin
    if (AMaxIndex - AMinIndex < 500) then
    begin
      for i := AMinIndex to AMaxIndex do
        FIndexList[i mod IconCount] := -1;
      ListView.UpdateItems(AMinIndex, AMaxIndex)
    end else
    begin
      for i := 0 to IconCount - 1 do
        FIndexList[i] := -1;
      ListView.Invalidate;
    end;

  end else
  begin
    for i := 0 to IconCount - 1 do
      FIndexList[i] := -1;
    if ItemList.Count = 0 then
    begin
      Listview.Invalidate;
    end else
    begin
      ListView.UpdateItems(
        Max(AMinIndex, FTopItem),
        Min(AMaxIndex, FTopItem + FRowCount));
    end;
  end;
end;

procedure TItemView.SortRandomExecute(Sender: TObject);
begin
  SortByMethod(smRandom, sdAscending);
end;

procedure TItemView.SortNameExecute(Sender: TObject);
begin
  SortByMethod(smByName, sdAscending);
end;

procedure TItemView.SortNameNumExecute(Sender: TObject);
begin
  SortByMethod(smByNameNum, sdAscending);
end;

procedure TItemView.SortDateExecute(Sender: TObject);
begin
  SortByMethod(smByDate, sdAscending);
end;

procedure TItemView.SortSizeExecute(Sender: TObject);
begin
  SortByMethod(smBySize, sdAscending);
end;

procedure TItemView.SortSeriesExecute(Sender: TObject);
begin
  SortByMethod(smBySeries, sdAscending);
end;

procedure TItemView.SortSimilarExecute(Sender: TObject);
begin
  SortByMethod(smBySimilarity, sdAscending);
end;

procedure TItemView.SortOrderExecute(Sender: TObject);
begin
  SortByMethod(FSortMethod, TSortDirectionType(1-ord(FSortDirection)));
end;

procedure TItemView.ViewListExecute(Sender: TObject);
begin
  ViewStyle := lvsList;
end;

procedure TItemView.ViewSmallExecute(Sender: TObject);
begin
  ViewStyle := lvsSmallIcon;
end;

procedure TItemView.ViewLargeExecute(Sender: TObject);
begin
  ViewStyle := lvsIcon;
end;

procedure TItemView.ViewThumbExecute(Sender: TObject);
begin
  ViewStyle := lvsThumb;
end;

procedure TItemView.ViewDetailExecute(Sender: TObject);
begin
  ViewStyle := lvsReport;
end;

procedure TItemView.ItemDeleteExecute(Sender: TObject);
begin
  // Make sure it's for us
  if frmMain.ActiveControl is TListView then
    DoDelete(Self);
end;

procedure TItemView.ItemRemoveExecute(Sender: TObject);
begin
  DoRemove(Self);
end;

procedure TItemView.SortingToolbarExecute(Sender: TObject);
begin
  SortingToolbar.Checked := not SortingToolbar.Checked;
  tbSorting.Visible := SortingToolbar.Checked;
end;

procedure TItemView.ViewsToolbarExecute(Sender: TObject);
begin
  ViewsToolbar.Checked := not ViewsToolbar.Checked;
  tbViews.Visible := ViewsToolbar.Checked;
end;

procedure TItemView.ItemsToolbarExecute(Sender: TObject);
begin
  ItemsToolbar.Checked := not ItemsToolbar.Checked;
  tbItems.Visible := ItemsToolbar.Checked;
end;

procedure TItemView.TypesToolbarExecute(Sender: TObject);
begin
  TypesToolbar.Checked := not TypesToolbar.Checked;
  tbTypes.Visible := TypesToolbar.Checked;
end;

procedure TItemView.ShowFilesExecute(Sender: TObject);
begin
  // Set the itemview to itFile type
  ItemviewType := itFile;
end;

procedure TItemView.ShowFoldersExecute(Sender: TObject);
begin
  // Set the itemview to itFolder type
  ItemviewType := itFolder;
end;

procedure TItemView.ShowGroupsExecute(Sender: TObject);
begin
  // Set the itemview to itFolder type
  ItemviewType := itGroup;
end;

procedure TItemView.ShowSeriesExecute(Sender: TObject);
begin
  // Set the itemview to itFolder type
  ItemviewType := itSeries;
end;

procedure TItemView.ItemOpenExecute(Sender: TObject);
begin
  // Keyboard [enter] was pressed or double click
  if ListView.Selected <> nil then

    DoOpenItem(ItemList[ListView.Selected.Index]);

end;

procedure TItemView.SelectAllExecute(Sender: TObject);
var
  i: integer;
  NewTick, OldTick: integer;
begin
  // Select all items
  OldTick := GetTickCount;
  for i := 0 to ItemList.Count - 1 do
  begin
    ListView.Items[i].Selected := true;
    NewTick := GetTickCount;
    if (NewTick - OldTick) > 100 then
    begin
      DoStatusMessage(Format('Selecting %d items...', [i]));
      OldTick := NewTick;
    end;
  end;
  DoSelectionChanged(False);
end;

procedure TItemView.SelectInvertExecute(Sender: TObject);
var
  i: integer;
  NewTick, OldTick: integer;
begin
  // Select all items
  OldTick := GetTickCount;
  for i := 0 to ItemList.Count - 1 do
  begin
    ListView.Items[i].Selected := not ListView.Items[i].Selected;
    NewTick := GetTickCount;
    if (NewTick - OldTick) > 100 then
    begin
      DoStatusMessage(Format('Inverting selection of %d items...', [i]));
      OldTick := NewTick;
    end;
  end;
  DoSelectionChanged(False);
end;

procedure TItemView.dftFilesDrop(Sender: TObject; ShiftState: TShiftState;
  Point: TPoint; var Effect: Integer);
begin
  // Do the monkey trick 'getdropeffect' again
  dftFilesGetDropEffect(Sender, Shiftstate, Point, Effect);

  // Add the external files if external drop
  if not assigned(DropSender) then
    DropList.AddExternal(dftFiles.Files, dftFiles.MappedNames);

  // And execute the drop
  AcceptDrop(Effect);
end;

procedure TItemView.dftFilesGetDropEffect(Sender: TObject;
  ShiftState: TShiftState; Point: TPoint; var Effect: Integer);
var
  DropListItem: TListItem;
  AMessage: string;
begin
  //We're only interested in ssShift & ssCtrl here so
  //mouse buttons states are screened out ...
  ShiftState := ([ssShift, ssCtrl] * ShiftState);

  // Determine dropitem
  DropItem := nil;
  DropFolder := '';
  AMessage := '';
  if not assigned(DropSender) then
    // Since this one comes from from external, mimick it
    DropList.ExtMimick := True;

  DropListItem := Listview.GetItemAt(Point.X, Point.Y);
  if assigned(DropListItem) then
  begin

    // The dropitem that is resp for this drop
    DropItem := ItemList[DropListItem.Index];

  end else
  begin

    // No item, so in emptyness.. try to find at least a folder
    if assigned(frmMain.Browser) then
      DropFolder := frmMain.Browser.GetCurrentFolder;

  end;

  AllowDrop(Effect, ShiftState, AMessage);

  DropList.ExtMimick := False;
  DoStatusMessage(AMessage);

end;

procedure TItemView.dfsFilesFeedback(Sender: TObject; Effect: Integer; var UseDefaultCursors: Boolean);
begin
  UseDefaultCursors := false; //We want to use our own.
  case DWORD(Effect) of
  DROPEFFECT_COPY:
    Windows.SetCursor(Screen.Cursors[crCopy]);
  DROPEFFECT_MOVE:
    Windows.SetCursor(Screen.Cursors[crMove]);
  DROPEFFECT_LINK:
    Windows.SetCursor(Screen.Cursors[crLink]);
  DROPEFFECT_SCROLL OR DROPEFFECT_COPY:
    Windows.SetCursor(Screen.Cursors[crCopyScroll]);
  DROPEFFECT_SCROLL OR DROPEFFECT_MOVE:
    Windows.SetCursor(Screen.Cursors[crMoveScroll]);
  DROPEFFECT_SCROLL OR DROPEFFECT_LINK:
    Windows.SetCursor(Screen.Cursors[crLinkScroll]);
  else
    UseDefaultCursors := true; //Use default NoDrop
  end;
end;

procedure TItemView.ListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //
  FDragPoint := Point(X,Y);

// Unsure what this does.. would it help?
//  ReleaseCapture;
//  SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);

end;

procedure TItemView.ListViewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Res: TDragResult;
begin

  // Test!!
  //ReleaseCapture;

  //Make sure mouse has moved at least 10 pixels before starting drag ...
  if (FDragPoint.X = -1) or
     ((Shift <> [ssLeft]) and (Shift <> [ssRight])) or
     ((abs(FDragPoint.X - X) <10) and (abs(FDragPoint.Y - Y) <10)) then
  begin
    if ((Shift <> [ssLeft]) and (Shift <> [ssRight])) then
      FDragPoint := point(-1,-1);
    exit;
  end;

  // Getting here means we are in a initiated drag operation
  PopulateDropFileSource;
  DropSender := Self;
  try

    // Do not continue if there are no files to drag
    if dfsFiles.Files.Count = 0 then
      exit;

    // Execute the drop and get result back
    Res := dfsFiles.execute;

    // Note:
    // The target is responsible from this point on for the copying/moving of the file
    // but the target feeds back to the source what (should have) happened via the
    // returned value of Execute.

    // Feedback what happened...
    case Res of
    drDropCopy: DoStatusMessage(Format('Copied %d files', [dfsFiles.Files.Count]));
    drDropMove: DoStatusMessage(Format('Moved %d files', [dfsFiles.Files.Count]));
    drDropLink: DoStatusMessage(Format('Linked %d files', [dfsFiles.Files.Count]));
    drCancel: DoStatusMessage('Drop was cancelled');
    drOutMemory: DoStatusMessage('Drop cancelled - out of memory');
    else
      DoStatusMessage('Drop cancelled - unknown reason');
    end;//case

  finally
    // Make SURE to clear this list again, so consec. drops don't mix up internal/external drops
    DropList.Clear;
    DropSender := nil;
  end;
end;

procedure TItemView.tmrShowItemsTimer(Sender: TObject);
begin
  // This timer is used to avoid the involuntary dragging in the
  // TListview whenever OnChange takes too long.
  // TO DO: This must be built as thread, the "DoShowItem" causes the system
  // to 'lock' at times

  // Switch ourselves off again
  tmrShowItems.Enabled := False;

  // Set ItemIndex to index of showing item, this will update the app
  ItemIndex := FTimerIndex;

end;

procedure TItemView.RotateLeftExecute(Sender: TObject);
var
  Total, Success: integer;
  FileNames: string;
  Lossless: TsdLossless;
begin

  // List of filenames separated by #13
  FileNames := CreateFileNameList;

  if length(FileNames) > 0 then
  begin

    DoStatusMessage(Format('Rotating %s ...', [FileNames]));

    // Perform the lossless action
    Lossless := TsdLossless.Create;
    try
      Lossless.DoLosslessAction(FileNames, laRotateLeft, FAppFolder, Total, Success);
    finally
      Lossless.Free;
    end;

    if Success > 0 then
      DoUpdateSelected([ufGraphic]);

    if Total > 1 then
    begin
      DoStatusMessage(
        Format('Rotated %d of %d items successfully', [Success, Total]));
    end;

    if Total = 1 then
      if Success = 1 then
        DoStatusMessage(Format('Rotated %s successfully', [FileNames]))
      else
        DoStatusMessage(Format('Unable to rotate %s', [FileNames]));

  end;
end;

procedure TItemView.RotateRightExecute(Sender: TObject);
var
  Total, Success: integer;
  FileNames: string;
  Lossless: TsdLossless;
begin

  // List of filenames
  FileNames := CreateFileNameList;

  if length(FileNames) > 0 then
  begin

    if pos(#13, FileNames) > 0 then
      DoStatusMessage('Rotating files ...')
    else
      DoStatusMessage(Format('Rotating %s ...', [FileNames]));

    // Perform the lossless action
    Lossless := TsdLossless.Create;
    try
      Lossless.DoLosslessAction(FileNames, laRotateRight, FAppFolder, Total, Success);
    finally
      Lossless.Free;
    end;

    if Success > 0 then
      DoUpdateSelected([ufGraphic]);

    if Total > 1 then
    begin
      DoStatusMessage(
        Format('Rotated %d of %d items successfully', [Success, Total]));
    end;

    if Total = 1 then
      if Success = 1 then
        DoStatusMessage(Format('Rotated %s successfully', [FileNames]))
      else
        DoStatusMessage(Format('Unable to rotate %s', [FileNames]));

  end;
end;

procedure TItemView.Rotate180Execute(Sender: TObject);
var
  Total, Success: integer;
  FileNames: string;
  Lossless: TsdLossless;
begin

  // List of filenames
  FileNames := CreateFileNameList;

  if length(FileNames) > 0 then
  begin

    if pos(#13, FileNames) > 0 then
      DoStatusMessage('Rotating files ...')
    else
      DoStatusMessage(Format('Rotating %s ...', [FileNames]));

    // Perform the lossless action
    Lossless := TsdLossless.Create;
    try
      Lossless.DoLosslessAction(FileNames, laRotate180, FAppFolder, Total, Success);
    finally
      Lossless.Free;
    end;

    if Success > 0 then
      DoUpdateSelected([ufGraphic]);

    if Total > 1 then
    begin
      DoStatusMessage(
        Format('Rotated %d of %d items successfully', [Success, Total]));
    end;

    if Total = 1 then
      if Success = 1 then
        DoStatusMessage(Format('Rotated %s successfully', [FileNames]))
      else
        DoStatusMessage(Format('Unable to rotate %s', [FileNames]));

  end;
end;

procedure TItemView.FlipHorExecute(Sender: TObject);
var
  Total, Success: integer;
  FileNames: string;
  Lossless: TsdLossless;
begin

  // List of filenames
  FileNames := CreateFileNameList;

  if length(FileNames) > 0 then
  begin

    DoStatusMessage(Format('Flipping %s ...', [FileNames]));

    // Perform the lossless action
    Lossless := TsdLossless.Create;
    try
      Lossless.DoLosslessAction(FileNames, laFlipHor, FAppFolder, Total, Success);
    finally
      Lossless.Free;
    end;

    if Success > 0 then
      DoUpdateSelected([ufGraphic]);

    if Total > 1 then
    begin
      DoStatusMessage(
        Format('Flipped %d of %d items successfully', [Success, Total]));
    end;

    if Total = 1 then
      if Success = 1 then
        DoStatusMessage(Format('Flipped %s successfully', [FileNames]))
      else
        DoStatusMessage(Format('Unable to flip %s', [FileNames]));

  end;
end;

procedure TItemView.FlipVerExecute(Sender: TObject);
var
  Total, Success: integer;
  FileNames: string;
  Lossless: TsdLossless;
begin

  // List of filenames
  FileNames := CreateFileNameList;

  if length(FileNames) > 0 then
  begin

    DoStatusMessage(Format('Flipping %s ...', [FileNames]));

    // Perform the lossless action
    Lossless := TsdLossless.Create;
    try
      Lossless.DoLosslessAction(FileNames, laFlipVer, FAppFolder, Total, Success);
    finally
      Lossless.Free;
    end;

    if Success > 0 then
      DoUpdateSelected([ufGraphic]);

    if Total > 1 then begin
      DoStatusMessage(
        Format('Flipped %d of %d items successfully', [Success, Total]));
    end;

    if Total = 1 then
      if Success = 1 then
        DoStatusMessage(Format('Flipped %s successfully', [FileNames]))
      else
        DoStatusMessage(Format('Unable to flip %s', [FileNames]));

  end;
end;

procedure TItemView.SelectDuplicatesExecute(Sender: TObject);
var
  i: integer;
  Item: TsdItem;
  DupeGroup: TsdProperty;
  DupeGroups: TList;
  IsSelected: boolean;
  // local
  function InList(AValue: integer): boolean;
  var
    i: integer;
  begin
    Result := False;
    for i := 0 to DupeGroups.Count - 1 do
      if integer(DupeGroups[i]) = AValue then begin
        Result := True;
        exit;
      end;
  end;
// main
begin
  // Select duplicate items
  DupeGroups := TList.Create;
  try
    for i := 0 to ItemList.Count-1 do
    begin
      Item := ItemList[i];
      IsSelected := False;
      DupeGroup := Item.GetProperty(prDupeGroup);
      if assigned(DupeGroup) then
      begin
        if InList(TprDupeGroup(DupeGroup).GroupID) then
        begin
          IsSelected := True;
        end else
        begin
          DupeGroups.Add(pointer(TprDupeGroup(DupeGroup).GroupID));
        end;
      end;
      ListView.Items[i].Selected := IsSelected;
    end;
    DoSelectionChanged(False);
  finally
    DupeGroups.Free;
  end;
end;

procedure TItemView.SelectDupeInFolderExecute(Sender: TObject);
var
  i: integer;
  Item: TsdItem;
  FolderGuid: TGUID;
  DupeGroup: TsdProperty;
  DupeGroups: TList;
  IsSelected: boolean;
  // local
  function InstanceCount(AValue: integer): integer;
  var
    i: integer;
  begin
    Result := 0;
    for i := 0 to DupeGroups.Count - 1 do
      if integer(DupeGroups[i]) = AValue then
        inc(Result);
  end;
// main
begin
  // Determine which folder
  if not assigned(ListView.ItemFocused) then
    exit;

  Item := ItemList[ListView.ItemFocused.Index];
  if Item.ItemType <> itFile then
    exit;

  FolderGuid := TsdFile(Item).FolderGuid;

  // Select duplicate items in one folder
  DupeGroups := TList.Create;
  try

    for i := 0 to ItemList.Count - 1 do
    begin
      Item := ItemList[i];
      IsSelected := False;
      DupeGroup := Item.GetProperty(prDupeGroup);
      // Duplicate, and in folder?
      if assigned(DupeGroup) and IsEqualGuid(TsdFile(Item).FolderGuid, FolderGuid) then
      begin

        DupeGroups.Add(pointer(TprDupeGroup(DupeGroup).GroupID));
        IsSelected := True;
        // Make sure not to add the 2nd one.. otherwise this could be
        // original AND duplicate
        if InstanceCount(TprDupeGroup(DupeGroup).GroupID) = 2 then
          IsSelected := False;
      end;
      ListView.Items[i].Selected := IsSelected;
    end;
    DoSelectionChanged(False);

  finally
    DupeGroups.Free;
  end;
end;

procedure TItemView.SelectSmartExecute(Sender: TObject);
var
  i, MaskCount: integer;
  Base, Item: TsdItem;
  FolderGuid: TGUID;
  Mask: string;
  OldCursor: TCursor;
  List: TList;
begin
  // Determine which folder
  if not assigned(ListView.ItemFocused) then
    exit;

  Base := ItemList[ListView.ItemFocused.Index];
  if not assigned(Base) or (Base.ItemType <> itFile) then
    exit;

  FolderGuid := TsdFile(Base).FolderGuid;

  // Create a mask
  MaskCount := FSmartSelectMaskCount;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  List := TList.Create;
  try
    repeat
      // Create a mask (eg. img2###.jpg from img2015.jpg)
      Mask := MaskFromNumberFormat(TsdFile(Base).Name, MaskCount);
      List.Clear;
      for i := 0 to ItemList.Count - 1 do
      begin
        Item := ItemList[i];
        if Item.ItemType = itFile then
          if not FSmartSelectFolderEqual or IsEqualGuid(TsdFile(Item).FolderGuid, FolderGuid) then
            if NumberFromMaskAndName(Mask, TsdFile(Item).Name) >= 0 then
              List.Add(pointer(i));
        if List.Count > FSmartSelectFileCount then
          break;
      end;
      if List.Count > FSmartSelectFileCount then
        dec(MaskCount);
    until (List.Count <= FSmartSelectFileCount) or (MaskCount < 1);

    // Create the selection
    for i := 0 to List.Count - 1 do
      ListView.Items[integer(List[i])].Selected := True;
    DoSelectionChanged(False);

  finally
    Screen.Cursor := OldCursor;
    List.Free;
  end;
end;

procedure TItemView.SortAscendingExecute(Sender: TObject);
begin
  if FSortDirection <> sdAscending then
    SortByMethod(FSortMethod, sdAscending);
end;

procedure TItemView.SortDescendingExecute(Sender: TObject);
begin
  if FSortDirection <> sdDescending then
    SortByMethod(FSortMethod, sdDescending);
end;

procedure TItemView.SortUnsortedExecute(Sender: TObject);
begin
  SortByMethod(smNosort, sdAscending);
end;

procedure TItemView.SortFolderExecute(Sender: TObject);
begin
  SortByMethod(smByFolder, sdAscending);
end;

procedure TItemView.SortDupeGroupExecute(Sender: TObject);
begin
  SortByMethod(smByDupeGroup, sdAscending);
end;

procedure TItemView.alItemViewUpdate(Action: TBasicAction; var Handled: Boolean);
var
  IsEnabled: boolean;
  HasList: boolean;
begin
  HasList := False;
  if assigned(FItemList) and (FItemList.Count > 0) then
    HasList := True;

  ViewLarge.Checked := ViewStyle = lvsIcon;
  ViewSmall.Checked := ViewStyle = lvsSmallIcon;
  ViewList.Checked := ViewStyle = lvsList;
  ViewDetail.Checked := ViewStyle = lvsReport;
  ViewThumb.Checked := ViewStyle = lvsThumb;

  ItemDelete.Visible := assigned(OnDelete);
  ItemRemove.Visible := assigned(OnRemove);
  ItemDelete.Enabled := HasSelection AND
    (ItemviewType in [itFile, itFolder, itSeries]);
  ItemRemove.Enabled := HasSelection;
  Properties.Enabled := HasSelection;
  btnDescription.Enabled := HasSelection;

  IsEnabled := HasSelection and (ItemviewType = itFile);
  LossLess1.Enabled := IsEnabled;
  RotateLeft.Enabled := IsEnabled;
  RotateRight.Enabled := IsEnabled;
  FlipHor.Enabled := IsEnabled;
  FlipVer.Enabled := IsEnabled;
  Handled := True;

  Select1.Enabled := HasList;
  SelectAll.Enabled := HasList;
  SelectDuplicates.Enabled := HasList;
  SelectDupeInFolder.Enabled := HasList and HasSelection;

  ShowFiles.Checked := (ItemviewType = itFile);
  ShowFolders.Checked := (ItemviewType = itFolder);
  ShowGroups.Checked := (ItemviewType = itGroup);
  ShowSeries.Checked := (ItemviewType = itSeries);

  SortUnsorted.Checked := (FSortMethod = smNoSort);
  SortRandom.Checked := (FSortMethod = smRandom);
  SortName.Checked := (FSortMethod = smByName);
  SortDate.Checked := (FSortMethod = smByDate);
  SortSize.Checked := (FSortMethod = smBySize);
  SortSeries.Checked := (FSortMethod = smBySeries);
  SortFolder.Checked := (FSortMethod = smByFolder);
  SortDupeGroup.Checked := (FSortMethod = smByDupeGroup);
  SortAscending.Checked := (FSortDirection = sdAscending);
  SortDescending.Checked := (FSortDirection = sdDescending);

  case FSortDirection of
  sdAscending:  SortOrder.ImageIndex := 5;
  sdDescending: SortOrder.ImageIndex := 6;
  end;

  // Make sure to restore the shortcuts - sometimes when edits are cancelled this
  // doesn't happen
  if (ItemDelete.ShortCut = scNone) and not Listview.IsEditing then
    EnableEditKeyShortCuts;
end;

procedure TItemView.btnHideEditClick(Sender: TObject);
begin
  pnlEdit.Hide;
end;

procedure TItemView.ItemDescribeExecute(Sender: TObject);
begin
  if pnlEdit.Visible and (pcEdit.ActivePage = tsDescr) then
  begin
    pnlEdit.Hide;
  end else
  begin
    pnlEdit.Show;
    pcEdit.ActivePage := tsDescr;
    // Make sure it shows correct data
    SetDescriptionFromSelection;
    cbbDescr.SetFocus;
  end;
end;

procedure TItemView.btnDescriptionClick(Sender: TObject);
var
  i: integer;
  List: TList;
  Descr: string;
begin
  // The description
  Descr := cbbDescr.Text;

  // Add this one to the combo box
  i := 0;
  while i < cbbDescr.Items.Count do
    if cbbDescr.Items[i] = Descr then
      cbbDescr.Items.Delete(i)
    else
      inc(i);
  cbbDescr.Items.Insert(0, Descr);

  // Maximum lines
  if cbbDescr.Items.Count > FItemHistoryCount then
    cbbDescr.Items.Delete(cbbDescr.Items.Count - 1);

  // We will apply the description to the selected items
  List := TList.Create;
  try
    AddSelectedItems(List);
    for i := 0 to List.Count - 1 do
      TsdItem(List[i]).Description := Descr;

    frmMain.Root.UpdateItems(Sender, List);
  finally
    List.Free;
  end;
end;

procedure TItemView.SetDescriptionFromSelection;
var
  Item: TListItem;
  Description: string;
  Various: boolean;
begin
  Description := '';
  Various := false;

  if Listview.SelCount > 0 then
  begin
    Item := Listview.Selected;
    repeat
      if Item.Selected then
      begin
        if length(Description) = 0 then
        begin
          Description := ItemList[Item.Index].Description
        end else
        begin
          if Description <> ItemList[Item.Index].Description then
            Various := True;
        end;
      end;
      Item := Listview.GetNextItem(Item, sdAll, [isSelected]);
    until (Item = nil) or Various;
  end;

  if Various then
    Description := '<various>';

  cbbDescr.Text := Description;
end;

procedure TItemView.SetRatingFromSelection;
var
  Item: TListItem;
  Rating, Count: word;
  Total: int64;
  Description: string;
begin
  Rating := cDefaultRating; // Default rating
  Total := 0;
  Count := 0;

  if Listview.SelCount > 0 then
  begin
    Item := Listview.Selected;
    repeat
      if Item.Selected then
      begin
        if ItemList[Item.Index].Rating <> cDefaultRating then
        begin
          Rating := ItemList[Item.Index].Rating;
          inc(Total, Rating);
          inc(Count);
        end;
      end;
      Item := Listview.GetNextItem(Item, sdAll, [isSelected]);
    until (Item = nil);
  end;

  if Count > 1 then
  begin
    Description := 'Various';
    slQualRating.Value := round(Total / Count);
  end else
  begin
    Description := Format('%3.1f', [Rating / 20.0]);
    slQualRating.Value := Rating;
  end;

  lblQualRating.Caption := Description;
end;

procedure TItemView.lblLowerClick(Sender: TObject);
begin
  slQualRating.Value := slQualRating.Value - 2;
end;

procedure TItemView.lblHigherClick(Sender: TObject);
begin
  slQualRating.Value := slQualRating.Value + 2;
end;

procedure TItemView.btnQualOKClick(Sender: TObject);
var
  i: integer;
  List: TList;
  Rating: word;
begin
  // We will apply the rating to the selected items
  Rating := slQualRating.Value;

  // Create list
  List := TList.Create;
  try
    AddSelectedItems(List);
    for i := 0 to List.Count - 1 do
      TsdItem(List[i]).Rating := Rating;

    Listview.Invalidate;
  finally
    List.Free;
  end;
end;

procedure TItemView.slQualRatingChange(Sender: TObject);
begin
  lblQualRating.Caption := Format('%3.1f',[slQualRating.Value / 20.0]);
end;

procedure TItemView.pcEditChange(Sender: TObject);
begin
  // A tab-change, we must make sure that the tab shows correct data

  // Description
  if pcEdit.ActivePage = tsDescr then
  begin
    SetDescriptionFromSelection;
  end;

  // Rating
  if pcEdit.ActivePage = tsRating then
  begin
    SetRatingFromSelection;
  end;

end;

procedure TItemView.ListViewDataStateChange(Sender: TObject; StartIndex,
  EndIndex: Integer; OldState, NewState: TItemStates);
var
  i: integer;
  AItem: TsdItem;
  NewTick, OldTick: integer;
begin
  // Select - it seems that Oldstate and Newstate are exchanged.. bug?
  if (isSelected in OldState) and not (isSelected in NewState) then
  begin
    FMinIndex := Min(FMinIndex, StartIndex);
    FMaxIndex := Max(FMaxIndex, EndIndex);
    OldTick := GetTickCount;
    for i := StartIndex to EndIndex - 1 do
    begin
      // Let the user know
      NewTick := GetTickCount;
      if (NewTick - OldTick) > 100 then
      begin
        DoStatusMessage(Format('Selecting %d items...', [i]));
        OldTick := NewTick;
      end;

      // Switch selection on if it werent
      AItem := ItemList[i];
      if assigned(AItem) and not AItem.IsSelected[SelectBit] then
      begin
        AItem.IsSelected[SelectBit] := True;
        DoItemSelect(AItem, True);
      end;
    end;

    // Let Main know
    DoSelectionChanged(False);
  end;
end;

procedure TItemView.ListViewContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  i: integer;
  Focused: TsdItem;
  Captions: TStrings;
  // local
  function CreateMenu(ACaption: string; ADefault: boolean; ATag: integer): TMenuItem;
  begin
    Result := TMenuItem.Create(Self);
    Result.Caption := ACaption;
    Result.Default := ADefault;
    Result.Tag := ATag;
    Result.OnClick := ShellMenuClick;
  end;
// main
begin
  // Focused item
  Focused := nil;
  if assigned(ListView.ItemFocused) then
    Focused := ItemList[ListView.ItemFocused.Index];

  // setup shell menu
  miShell.Clear;

  if assigned(Focused) and (Focused.ItemType = itFile) then
  begin
    // Start creation
    Captions := TStringList.Create;
    try
      GetAssocActions(TsdFile(Focused).Extension, Captions);
      for i := 0 to Captions.Count - 1 do
        miShell.Add(CreateMenu(Captions[i], (i = 0), i));

      miShell.Enabled := Captions.Count > 0;
    finally
      Captions.Free;
    end;
  end else
    miShell.Enabled := False;

  // Make sure the menu is displayed!
  Handled := False;
end;

procedure TItemView.ShellMenuClick(Sender: TObject);
var
  Focused: TsdItem;
  ACaption: string;
begin
  // Focused item
  Focused := nil;
  if assigned(ListView.ItemFocused) then
    Focused := ItemList[ListView.ItemFocused.Index];

  // Here we will process the shell menu click
  ACaption := StripHotkey(TMenuItem(Sender).Caption);
  if assigned(Focused) and (Focused.ItemType = itFile) then
    ShellExecute(frmMain.Handle, pchar(ACaption), pchar(TsdFile(Focused).FileName),
      nil, nil, SW_SHOWNORMAL);
end;

procedure TItemView.PropertiesExecute(Sender: TObject);
var
  Focused: TsdItem;
begin
  // Focused item
  Focused := nil;
  if assigned(ListView.ItemFocused) then
    Focused := ItemList[ListView.ItemFocused.Index];

  // This is one that we will pass to the main form
  DoItemProperties(Focused);
end;

procedure TItemView.CopyItems;
begin
  // Get a list of selected files in our dropfilesource
  PopulateDropFileSource;
  if dfsFiles.Files.Count > 0 then
  begin
    // Copy the files to the clipboard
    dfsFiles.CopyToClipboard;
    // Inform the user
    DoStatusMessage(Format('Copied %d file(s)', [dfsFiles.Files.Count]));
  end;
end;

procedure TItemView.CutItems;
begin
  // Get a list of selected files in our dropfilesource
  PopulateDropFileSource;
  if dfsFiles.Files.Count > 0 then
  begin
    // Copy the files to the clipboard
    dfsFiles.CutToClipboard;
    // Inform the user
    DoStatusMessage(Format('Cut %d file(s)', [dfsFiles.Files.Count]));
  end;
end;

procedure TItemView.PasteItems;
var
  Effect: integer;
begin
  Effect := dftFiles.PasteFromClipboard;
  DropList.AddExternal(dftFiles.Files, dftFiles.MappedNames);

  // Make sure to have only ONE valid effect
  if (Effect and DROPEFFECT_COPY) > 0 then
    Effect := DROPEFFECT_COPY;
  if (Effect and DROPEFFECT_MOVE) > 0 then
    Effect := DROPEFFECT_MOVE;
  if (Effect and DROPEFFECT_LINK) > 0 then
    Effect := DROPEFFECT_LINK;

  // Dropfolder
  DropFolder := '';
  if assigned(frmMain.Browser) then
    DropFolder := frmMain.Browser.GetCurrentFolder;

  AcceptDrop(Effect);
end;

procedure TItemView.SendToMySelectionExecute(Sender: TObject);
begin
  //
  dmActions.DoSendToMySelection;
end;

procedure TItemView.SendToEmailExecute(Sender: TObject);
begin
  // Execute the Email-a-Friend wizard
  dmActions.EmailFriendExecute(Self);
end;

procedure TItemView.ListViewEdited(Sender: TObject; Item: TListItem; var S: String);
var
  AItem: TsdItem;
begin
  // Restore previously turned off shortcut
  EnableEditKeyShortCuts;
  // Try to assign this name to the file
  AItem := ItemList[Item.Index];
  if assigned(AItem) then
    AItem.Rename(S);
end;

procedure TItemView.ListViewEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
begin
  DisableEditKeyShortCuts;
end;

procedure TItemView.RenameExecute(Sender: TObject);
var
  i: integer;
  Dialog: TfrmRenameFiles;
  FileList: TList;
begin
  // Somehow we get the event here first. so we'll try to dispatch to the
  // browser if neccesary
  if frmMain.ActiveControl is TListview then
  begin
    // Ours
    if Listview.SelCount = 1 then
    begin
      // Single file rename - do this in-line
      if assigned(Listview.ItemFocused) then
        Listview.ItemFocused.EditCaption;
    end else
    begin
      // Multiple file rename
      // Open the dialog
      Application.CreateForm(TfrmRenameFiles, Dialog);
      FileList := TList.Create;
      try
        // Copy filelist from selected
        for i := 0 to frmMain.SelectedItems.Count - 1 do
          FileList.Add(frmMain.SelectedItems[i]);
        // Set the dialog props
       Dialog.SetFilesFromSelection(FileList);
        if Dialog.ShowModal = mrOK then
          // Do the actual rename
          frmMain.Root.BatchRename(Dialog.FItems);
      finally
        Dialog.Free;
        FileList.Free;
      end;
    end;
  end else
  begin
    // This is destined for the browser
    if Listview.SelCount = 0 then
      frmMain.Browser.BrowseRenameExecute(Sender);
  end;
end;

procedure TItemView.ChangeFiledateExecute(Sender: TObject);
var
  i: integer;
  Dialog: TfrmChangeFileDate;
  FileList: TList;
begin
  // Open the "Change Filedate" dialog
  Application.CreateForm(TfrmChangeFileDate, Dialog);
  FileList := TList.Create;
  try
    // Copy filelist from selected
    for i := 0 to frmMain.SelectedItems.Count - 1 do
      FileList.Add(frmMain.SelectedItems[i]);
    // Set the dialog props
    Dialog.SetFilesFromSelection(FileList);
    if Dialog.ShowModal = mrOK then
      // Do the actual rename
      frmMain.Root.BatchTouchDate(Dialog.FItems);
  finally
    Dialog.Free;
    FileList.Free;
  end;
end;

procedure TItemView.RotateOriExecute(Sender: TObject);
var
  i: integer;
  Dialog: TfrmRotateExifOri;
  FileList: TList;
begin
  // Open the "Change Filedate" dialog
  Application.CreateForm(TfrmRotateExifOri, Dialog);
  FileList := TList.Create;
  try
    // Copy filelist from selected
    for i := 0 to frmMain.SelectedItems.Count - 1 do
      FileList.Add(frmMain.SelectedItems[i]);
    // Set the dialog props
    Dialog.SetFilesFromSelection(FileList);
    if Dialog.ShowModal = mrOK then
    begin
      // Do the actual rename
      Dialog.DoRotateExifOri;
    end;
  finally
    Dialog.Free;
    FileList.Free;
  end;

end;

procedure TItemView.edQSearchChange(Sender: TObject);
var
  AIndex: integer;
begin
  // Jump to the next item based on the text in the QuickSearch edit
  AIndex := FirstItemWith(edQSearch.Text, chbSearchFileName.Checked, chbSearchDescription.Checked);
  if AIndex >= 0 then
  begin

    edQSearch.Font.Color := clBlack;
    Listview.ItemFocused := Listview.Items[AIndex];
    Listview.Items[AIndex].Makevisible(False);
    Listview.Selected := nil;
    Listview.Selected := Listview.Items[AIndex];

  end else
    edQSearch.Font.Color := clRed;
end;

procedure TItemView.QuickSearchExecute(Sender: TObject);
begin
  if pnlEdit.Visible and (pcEdit.ActivePage = tsQSearch) then
  begin
    pnlEdit.Hide;
  end else
  begin
    // Open the panel and highlight quicksearch
    pnlEdit.Show;
    pcEdit.ActivePage := tsQSearch;
    edQSearch.SetFocus;
  end;
end;

procedure TItemView.ItemRateExecute(Sender: TObject);
begin
  if pnlEdit.Visible and (pcEdit.ActivePage = tsRating) then
  begin
    pnlEdit.Hide
  end else
  begin
    // Open the panel and highlight rating
    pnlEdit.Show;
    pcEdit.ActivePage := tsRating;
    SetRatingFromSelection;
    slQualRating.SetFocus;
  end;
end;

procedure TItemView.SearchShowAllExecute(Sender: TObject);
// Start a Search filter with the same properties
var
  Item: TSearchItem;
begin
  if assigned(frmMain.Browser) and assigned(frmMain.Browser.ActiveNode) then
  begin
    // Create item with equal search phrase
    Item := TSearchItem.Create;
    Item.FCond1 := 0;
    Item.FPhrase1 := AnsiLowerCase(edQSearch.Text);
    // Add to active node (us)
    frmMain.Browser.BrowseTree.AddItem(Item, frmMain.Browser.ActiveNode);
    // Make sure it starts filtering (since Search is threaded)
    Item.InitialiseFilter;
    // Make the active item
    Item.Activate;
  end;
end;


end.



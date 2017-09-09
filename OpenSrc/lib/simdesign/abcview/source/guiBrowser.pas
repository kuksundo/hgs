{ unit Browsers

  This unit implements the folder browsing window on the left

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit guiBrowser;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, ImgList, ComCtrls, ToolWin, ExtCtrls, ActnList, BrowseTrees,
  Menus, Duplicates, sdItems, sdAbcTypes, sdAbcVars, DropSource, DropTarget, ActiveX;

type

  TMyDropTarget = class(TDropFileTarget)
  public
    function GetInfo(const DataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HRESULT;
  end;

  TBrowser = class(TFrame)
    cbItems: TControlBar;
    ilMenu: TImageList;
    vstBrowse: TVirtualStringTree;
    alBrowser: TActionList;
    pmFilter: TPopupMenu;
    Filter1: TMenuItem;
    FilterSpecify: TAction;
    FilterSize: TAction;
    FilterType: TAction;
    Specify1: TMenuItem;
    FileSize1: TMenuItem;
    FilterExactDupes: TAction;
    FindDuplicates1: TMenuItem;
    FilterCloseDupes: TAction;
    FindDuplicates2: TMenuItem;
    UseSelection: TAction;
    UseSelection1: TMenuItem;
    FilterProperties: TAction;
    N1: TMenuItem;
    Properties1: TMenuItem;
    FilterImages: TAction;
    FilterAudio: TAction;
    FilterVideo: TAction;
    FilterRemove: TAction;
    N3: TMenuItem;
    Remove1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    FilterFind: TAction;
    Search1: TMenuItem;
    ToolButton2: TToolButton;
    FilterFolder: TAction;
    ToolButton1: TToolButton;
    FilterDate: TAction;
    ByFileDate1: TMenuItem;
    N4: TMenuItem;
    dfsBrowse: TDropFileSource;
    pmFolder: TPopupMenu;
    FolderNew: TAction;
    FolderDelete: TAction;
    BrowseRename: TAction;
    FolderRemoveItems: TAction;
    FolderScanItems: TAction;
    NewSubfolder1: TMenuItem;
    Delete1: TMenuItem;
    Rename1: TMenuItem;
    N2: TMenuItem;
    ScanItemscheck1: TMenuItem;
    RemoveItemsuncheck1: TMenuItem;
    FolderScanSub: TAction;
    N5: TMenuItem;
    Properties2: TMenuItem;
    ScanItemsandSubtree1: TMenuItem;
    N6: TMenuItem;
    AddFilter1: TMenuItem;
    UseSelection2: TMenuItem;
    Find1: TMenuItem;
    Images2: TMenuItem;
    Audio2: TMenuItem;
    Video2: TMenuItem;
    N7: TMenuItem;
    ByFileSize1: TMenuItem;
    ByFileDate2: TMenuItem;
    Specify2: TMenuItem;
    FolderRemoveSub: TAction;
    RemoveItemsandSubtree1: TMenuItem;
    Images3: TMenuItem;
    Audio3: TMenuItem;
    Video3: TMenuItem;
    N8: TMenuItem;
    ToolButton3: TToolButton;
    procedure vstBrowseGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var Text: WideString);
    procedure vstBrowseInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstBrowseInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstBrowseFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure FilterSizeExecute(Sender: TObject);
    procedure FilterTypeExecute(Sender: TObject);
    procedure FilterExactDupesExecute(Sender: TObject);
    procedure FilterCloseDupesExecute(Sender: TObject);
    procedure FilterSpecifyExecute(Sender: TObject);
    procedure UseSelectionExecute(Sender: TObject);
    procedure FilterPropertiesExecute(Sender: TObject);
    procedure FilterRemoveExecute(Sender: TObject);
    procedure FilterFindExecute(Sender: TObject);
    procedure alBrowserUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure vstBrowseEditing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstBrowseNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; Text: WideString);
    procedure FilterImagesExecute(Sender: TObject);
    procedure FilterAudioExecute(Sender: TObject);
    procedure FilterVideoExecute(Sender: TObject);
    procedure FilterDateExecute(Sender: TObject);
    procedure vstBrowseGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstBrowseGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure PluginExecute(Sender: TObject);
    procedure vstBrowseExpanded(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vstBrowseCollapsed(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vstBrowseChecking(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
    procedure update1Click(Sender: TObject);
    procedure vstBrowseStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure vstBrowseDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure vstBrowseDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure FolderScanItemsExecute(Sender: TObject);
    procedure FolderScanSubExecute(Sender: TObject);
    procedure FolderRemoveItemsExecute(Sender: TObject);
    procedure FolderRemoveSubExecute(Sender: TObject);
    procedure BrowseRenameExecute(Sender: TObject);
    procedure vstBrowseEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure FolderDeleteExecute(Sender: TObject);
    procedure vstBrowseEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure FolderNewExecute(Sender: TObject);
  private
    FBrowseTree: TBrowseTree;
    FMenuNode: PVirtualNode;
    FOnItemActivated: TNotifyEvent;
    procedure DoStatusMessage(AMessage: string);
    procedure DoClearItems(Sender: TObject);
  protected
    FdftBrowse: TMyDropTarget;
    FDragPoint: TPoint;
    FDropItem: TBrowseItem;
    FDropFolder: string;
    // Event methods
    FOnStatusMessage: TStatusMessageEvent;
    function GetActiveItem: TBrowseItem;
    function GetActiveNode: PVirtualNode;
    function GetMenuItem: TBrowseItem;
    function GetMenuNode: PVirtualNode;
    procedure PopulateDropFileSource;
    procedure SetMenuNode(AValue: PVirtualNode);
  public
    procedure AcceptDrop(var Effect: integer); virtual;
    function AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean; virtual;
    function GetCurrentFolder: string;
    function ItemByNode(ANode: PVirtualNode): TBrowseItem;
    procedure Initialize;
    property ActiveItem: TBrowseItem read GetActiveItem;
    property ActiveNode: PVirtualNode read GetActiveNode;
    property BrowseTree: TBrowseTree read FBrowseTree write FBrowseTree;
    property DropItem: TBrowseItem read FDropItem write FDropItem;
    property DropFolder: string read FDropFolder write FDropFolder;
    property MenuItem: TBrowseItem read GetMenuItem;
    property MenuNode: PVirtualNode read GetMenuNode write FMenuNode;
    // events
    property OnItemActivated: TNotifyEvent read FOnItemActivated write FOnItemActivated;
    property OnStatusMessage: TStatusMessageEvent read FOnStatusMessage write FOnStatusMessage;
  end;

implementation

uses
  guiActions, guiFilterDialog, Filters, guiMain, guiDuplicateItems,
  guiSearchItems, guiSelectionItems, guiStandardItems, guiPidlItems, sdScanFolders,
  UserActivities, ShFileOp, {$warnings off}FileCtrl, {$warnings on}CopyFiles, DropLists,
  guiCloseMatchItems, guiPlugins, guiPluginFuzzyItems;

{$R *.DFM}

const

  crCopy = 101;
  crMove = 102;
  crLink = 103;
  crCopyScroll = 104;
  crMoveScroll = 105;
  crLinkScroll = 106;

function TMyDropTarget.GetInfo(const DataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HRESULT;
begin
  // Get the data when the drop is occuring
  GetDataOnEnter := True;
  Result := DragEnter(DataObj, grfKeyState, pt, dwEffect);
  // Copy to DropList
  DropList.AddExternal(Files, MappedNames);
end;

procedure TBrowser.DoStatusMessage(AMessage: string);
begin
  if assigned(FOnStatusMessage) then
    FOnStatusMessage(Self, AMessage);
end;

procedure TBrowser.DoClearItems(Sender: TObject);
begin
  frmMain.Root.ClearBatchedItems;
end;

function TBrowser.ItemByNode(ANode: PVirtualNode): TBrowseItem;
begin
  Result := nil;
  if assigned(BrowseTree) then
    Result := BrowseTree.ItemWithNode(ANode);
end;

procedure TBrowser.AcceptDrop(var Effect: integer);

// AcceptDrop handles the drop into a TBrowser. It is called from
// methods PasteItems and dftBrowseDrop (the drop method of the DropfilesTarget)

var
  AList: TStringList;
begin
  // The try..finally here will cause all exits to pass finally
  try
    if Effect = DROPEFFECT_NONE then
      exit; // nothing to do

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

function TBrowser.AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean;

// Determine if TBrowser can allow the drop to happen and feedback Effect and Message

begin
  Effect := DROPEFFECT_NONE;
  Result := False;
  AMessage := '';

  if assigned(DropItem) then
  begin

    Result := DropItem.AllowDrop(Effect, Shift, AMessage);

  end else
  begin

    if length(DropFolder) > 0 then
    begin
      // A dropfolder can accept TFile, TFolder, TSeries, TExternalFile
      if DropList.Contains(TsdFile) or DropList.Contains(TsdFolder) or
         DropList.Contains(TsdSeries) or DropList.Contains(TExtFile) then
      begin
        Result := True;
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
        Result := True;
        Effect := DROPEFFECT_LINK;
        AMessage := 'Create reference to file(s)';
      end;
    end;

  end;
end;

function TBrowser.GetActiveItem: TBrowseItem;
begin
  Result := nil;
  if assigned(BrowseTree) then
    Result := BrowseTree.ActiveItem;
end;

function TBrowser.GetActiveNode: PVirtualNode;
begin
  Result := nil;
  if assigned(BrowseTree) then
    Result := BrowseTree.ActiveNode;
end;

function TBrowser.GetMenuItem: TBrowseItem;
begin
  Result := ItemByNode(MenuNode);
end;

function TBrowser.GetMenuNode: PVirtualNode;
begin
  Result := FMenuNode;
  if not assigned(Result) then
    Result := vstBrowse.GetFirst;
end;

procedure TBrowser.PopulateDropFileSource;
begin
  dfsBrowse.Files.clear;
  Droplist.Clear;

  // Selected items
  if assigned(ActiveItem) then
    DropList.Add(ActiveItem);

  // Only continue if we have items
  if DropList.Count = 0 then
    exit;

  vstBrowse.DragOperations := [];
  if dtMove in DropList.DragTypes then
    vstBrowse.DragOperations := vstBrowse.DragOperations + [doMove];
  if dtCopy in DropList.DragTypes then
    vstBrowse.DragOperations := vstBrowse.DragOperations + [doCopy];
  if dtLink in DropList.DragTypes then
    vstBrowse.DragOperations := vstBrowse.DragOperations + [doLink];
end;

procedure TBrowser.SetMenuNode(AValue: PVirtualNode);
begin
  FMenuNode := AValue;
end;

function TBrowser.GetCurrentFolder: string;
begin
  Result := '';
  if assigned(ActiveItem) and (ActiveItem is TPidlItem) and (TPidlItem(ActiveItem).CheckState = csCheckedNormal) then
    Result := TPidlItem(ActiveItem).FolderName;
end;

procedure TBrowser.Initialize;
begin
  vstBrowse.StateImages := FSmallIcons;

  // Create our own dropfile target - will be freed by our Free method
  FdftBrowse := TMyDropTarget.Create(Self);
  FdftBrowse.Register(vstBrowse);

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

procedure TBrowser.vstBrowseInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  AItem: TBrowseItem;
begin
  InitialStates := [];
  AItem := ItemByNode(Node);
  if assigned(AItem) then
  begin
    if (biHasChildren in AItem.Options) then
      InitialStates := [ivsHasChildren];

    // Check type and state
    Node.CheckType := AItem.CheckType;
    Node.CheckState := AItem.CheckState;

  end;
end;

procedure TBrowser.vstBrowseGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var Text: WideString);
var
  Count: integer;
begin
  Text := '*error*';
  if assigned(ItemByNode(Node)) then
  begin
    if TextType = ttNormal then
    begin
      Text := ItemByNode(Node).Caption;
    end else
    begin
      if (biNoStatistics in ItemByNode(Node).Options) then
      begin
        Text := '';
      end else
      begin
        Count := ItemByNode(Node).ItemCount;
        if Count > 0 then
          Text := Format('(%d items)', [Count])
        else
          Text := '(empty)';
      end;
    end;
  end;
end;

procedure TBrowser.vstBrowseInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var
  AItem: TBrowseItem;
begin
  ChildCount := 0;
  AItem := ItemByNode(Node);
  if assigned(AItem) then
    ChildCount := AItem.ChildCount;
end;

procedure TBrowser.vstBrowseFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
var
  OldCursor: TCursor;
begin
  if assigned(ItemByNode(NewNode)) then
  begin
    OldCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    MenuNode := NewNode;
    ItemByNode(NewNode).Activate;

    //Filter dialog?
    if dlgFilter.Visible then
      FilterPropertiesExecute(Sender);

    Screen.Cursor := OldCursor;
  end;
  Allowed := True;
end;

procedure TBrowser.alBrowserUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  // Check all the controls
  Handled := True;
end;

procedure TBrowser.vstBrowseEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := False;
  if assigned(ItemByNode(Node)) then
    Allowed := ItemByNode(Node).AllowRename;
  // Disable hotkey
  if assigned(frmMain.View) then
    frmMain.View.ItemDelete.ShortCut := scNone;
end;

procedure TBrowser.vstBrowseEdited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  // Restore previously turned off shortcut
  if assigned(frmMain.View) then
    frmMain.View.ItemDelete.ShortCut := TextToShortcut('Del');
end;

procedure TBrowser.vstBrowseNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; Text: WideString);
begin
  // The text that was edited is posed here, we must use it
  if assigned(ItemByNode(Node)) then
    ItemByNode(Node).DoRename(Text);
end;

// Filter creation

procedure TBrowser.FilterSizeExecute(Sender: TObject);
var
  Item: TStandardItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a size filter
  Item := TStandardItem.Create;
  Item.FFilterFileSize := True;

  // Add it to the browse tree
  BrowseTree.AddItem(Item, MenuNode);
  Item.Activate;

  // Display the Filter Dialog
  dlgFilter.Item := Item;
  dlgFilter.Show;
end;

procedure TBrowser.FilterImagesExecute(Sender: TObject);
var
  Item: TStandardItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a image filter
  Item := TStandardItem.Create;
  Item.FFilterFileType := True;
  Item.FFileTypeImages := True;

  // Add it to the browse tree
  BrowseTree.AddItem(Item, MenuNode);
  Item.InitialiseFilter;
  Item.Activate;

end;

procedure TBrowser.FilterAudioExecute(Sender: TObject);
var
  Item: TStandardItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a audio filter
  Item := TStandardItem.Create;
  Item.FFilterFileType := True;
  Item.FFileTypeAudio := True;

  // Add it to the browse tree
  BrowseTree.AddItem(Item, MenuNode);
  Item.InitialiseFilter;
  Item.Activate;

end;

procedure TBrowser.FilterVideoExecute(Sender: TObject);
var
  Item: TStandardItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a video filter
  Item := TStandardItem.Create;
  Item.FFilterFileType := True;
  Item.FFileTypeVideo := True;

  // Add it to the browse tree
  BrowseTree.AddItem(Item, MenuNode);
  Item.InitialiseFilter;
  Item.Activate;

end;

procedure TBrowser.FilterTypeExecute(Sender: TObject);
var
  Item: TStandardItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a type filter
  Item := TStandardItem.Create;
  Item.FFilterFileType := True;

  // Add it to the browse tree
  BrowseTree.AddItem(Item, MenuNode);
  Item.Activate;

  // Display the Filter Dialog
  dlgFilter.Item := Item;
  dlgFilter.Show;
end;

procedure TBrowser.FilterDateExecute(Sender: TObject);
var
  Item: TStandardItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a date filter
  Item := TStandardItem.Create;
  Item.FFilterFileDate := True;

  // Add it to the browse tree
  BrowseTree.AddItem(Item, MenuNode);
  Item.Activate;

  // Display the Filter Dialog
  dlgFilter.Item := Item;
  dlgFilter.Show;
end;

procedure TBrowser.FilterFindExecute(Sender: TObject);
var
  Item: TSearchItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a size filter
  Item := TSearchItem.Create;
  BrowseTree.AddItem(Item, MenuNode);
  Item.Activate;

  // Display the Filter Dialog
  dlgFilter.Item := Item;
  dlgFilter.Show;
end;

procedure TBrowser.FilterExactDupesExecute(Sender: TObject);
var
  Item: TDupeItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a duplicates filter
  Item := TDupeItem.Create;
  BrowseTree.AddItem(Item, MenuNode);
  if not FDupeFilterDisplayDialog then
    Item.InitialiseFilter;
  Item.Activate;

  // Display the Filter Dialog
  if FDupeFilterDisplayDialog then
  begin
    dlgFilter.Item := Item;
    dlgFilter.Show;
  end;

end;

procedure TBrowser.FilterCloseDupesExecute(Sender: TObject);
var
  Item: TCloseMatchItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a duplicates filter
  Item := TCloseMatchItem.Create;
  BrowseTree.AddItem(Item, MenuNode);
  if not FDupeFilterDisplayDialog then
    Item.InitialiseFilter;
  Item.Activate;

  // Display the Filter Dialog
  if FDupeFilterDisplayDialog then
  begin
    dlgFilter.Item := Item;
    dlgFilter.Show;
  end;

end;

procedure TBrowser.FilterSpecifyExecute(Sender: TObject);
var
  Item: TStandardItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a size filter
  Item := TStandardItem.Create;

  // Add it to the browse tree
  BrowseTree.AddItem(Item, MenuNode);
  Item.Activate;

  // Display the Filter Dialog
  dlgFilter.Item := Item;
  dlgFilter.Show;
end;

procedure TBrowser.UseSelectionExecute(Sender: TObject);
var
  Item: TSelectionItem;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Add a size filter
  Item := TSelectionItem.Create;

  // Add current selection
  if assigned(frmMain.SelectedItems) then
    Item.AddItems(Self, frmMain.SelectedItems);

  // Add it to the browse tree
  BrowseTree.AddItem(Item, MenuNode);
  Item.Activate;

  // Clear selection
  if assigned(frmMain.View) then
    frmMain.View.ListView.Selected := nil;

end;

// Other actions

procedure TBrowser.FilterPropertiesExecute(Sender: TObject);
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Display the Filter Dialog
  dlgFilter.Item := ItemByNode(MenuNode);
  dlgFilter.Visible := True;

end;

procedure TBrowser.FilterRemoveExecute(Sender: TObject);
var
  AItem: TBrowseItem;
begin
  AItem := ActiveItem;
  if assigned(AItem) then
  begin
    if AItem is TPidlItem then
    begin
      MessageDlg(
        'You cannot remove folders this way.'#13#13+
        'Please use the "Delete if Empty" command to delete empty folders.',
        mtInformation, [mbOK, mbHelp], 0);
      exit;
    end;
    if not (biAllowRemove in AItem.Options) then
    begin
      MessageDlg('You cannot remove this item', mtInformation,
        [mbOK, mbHelp], 0);
      exit;
    end;
    BrowseTree.Remove(AItem);
  end;
end;

procedure TBrowser.vstBrowseGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex := -1;
  case Kind of
  ikNormal, ikSelected:
    begin
      if assigned(ItemByNode(Node)) and (Column <= 0) then
       ImageIndex := ItemByNode(Node).ImageIndex;
    end;
  ikState:
    begin
      if assigned(ItemByNode(Node)) and (Column <= 0) then
      begin
       if Sender.Selected[Node] then
         ImageIndex := ItemByNode(Node).StateIndexOpen
       else
         ImageIndex := ItemByNode(Node).StateIndexClose;
      end;
    end;
  end;//case
end;

procedure TBrowser.vstBrowseGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  i: integer;
  Item: TBrowseItem;
  AFilter, AMenu: TMenuItem;
begin
  MenuNode := Node;
  Item := ItemByNode(Node);
  PopupMenu := nil;
  if assigned(Item) then
  begin
    if Item is TPidlItem then
    begin
      PopupMenu := pmFolder;
      AMenu := AddFilter1;
    end else
    begin
      PopupMenu := pmFilter;
      AMenu := Filter1;
    end;

    // Plugins
    if FPluginAddFilter then
    begin
      // Add a filter for each plugin, but first remove previous
      i := 0;
      while i < AMenu.Count do
        if AMenu.Items[i].Tag > 0 then
          AMenu.Delete(i)
        else
          inc(i);
      // Add
      for i := 0 to glPlugins.Count - 1 do
      begin
        if glPlugins[i].HasFilter and glPlugins[i].Allowed then
        begin
          AFilter := TMenuItem.Create(Self);
          AFilter.Caption := glPlugins[i].FilterName;
          AFilter.OnClick := PluginExecute;
          AFilter.Tag := i + 1;
          AMenu.Add(AFilter);
        end;
      end;
    end;

  end;

end;

procedure TBrowser.PluginExecute(Sender: TObject);
var
  Item: TBrowseItem;
  APlugin: TPlugin;
begin
  if not assigned(ItemByNode(MenuNode)) then
    exit;

  // Sender is the menu item
  if Sender is TMenuItem then
  begin
    APlugin := glPlugins[TMenuItem(Sender).Tag - 1];
    if assigned(APlugin) then
    begin

      // Add a plugin filter
      case APlugin.FilterType of
      cpcFilterFuzzy:
        begin
          Item := TPluginFuzzyItem.Create(APlugin);
        end;
      else
        exit;
      end;//case

      // Add it to the browse tree
      BrowseTree.AddItem(Item, MenuNode);
      Item.Activate;

      // Display the Filter Dialog
      dlgFilter.Item := Item;
      dlgFilter.Show;
    end;
  end;
end;

procedure TBrowser.vstBrowseExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  AItem: TBrowseItem;
begin
  AItem := ItemByNode(Node);
  if (AItem is TPidlItem) and assigned(AItem.Filter) then
    AItem.Filter.Execute;
end;

procedure TBrowser.vstBrowseCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  AItem: TBrowseItem;
begin
  AItem := ItemByNode(Node);
  if (AItem is TPidlItem) and assigned(AItem.Filter) then
    AItem.Filter.Execute;
end;

procedure TBrowser.vstBrowseChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
var
  AItem: TBrowseItem;
begin
  AItem := ItemByNode(Node);
  if (AItem is TPidlItem) then
  begin
    case NewState of
    csCheckedNormal: // User checks this folder, so add it to the scanner
      begin
        if (vsExpanded in Node.States) or TPidlItem(AItem).IsDrive then
          // Expanded, so run only this dir
          RunScan(TPidlItem(AItem).FolderName, False, False, '', '',
            frmMain.RootClearBatchedItems)
        else
        begin
          // Run a scan including new and existing subfolders
          RunScan(TPidlItem(AItem).FolderName, True, True, '', '',
            frmMain.RootClearBatchedItems);
        end;
        Allowed := True;
      end;
    csUncheckedNormal: // User unchecks this folder
      begin
        // The current collection of items is about to be removed
        Allowed := BrowseTree.RemoveItemsFromPidl(AItem, not (vsExpanded in Node.States));
      end;
    end;
  end;
end;

procedure TBrowser.update1Click(Sender: TObject);
var
  AItem: TBrowseItem;
begin
  // Test!
  AItem := frmMain.Browser.ActiveItem;
  if assigned(AItem) then
  begin
    if AItem is TPidlItem then
    begin
      TPidlItem(AItem).ClearSubNS;
      TPidlItem(AItem).UpdateSubNS;
    end;
  end;
end;

procedure TBrowser.vstBrowseStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  // Getting here means we are in a initiated drag operation
  PopulateDropFileSource;
  DropSender := Self;
end;

procedure TBrowser.vstBrowseEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  DropList.Clear;
  DropSender := nil;
end;

procedure TBrowser.vstBrowseDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  Accept: boolean;
  Temp: integer;
begin
  // Make sure to get the external file list
  FdftBrowse.GetInfo(DataObject, 0, pt, Temp);

  // Do the monkey trick 'DragOver' to get the effect
  vstBrowseDragOver(Sender, Source, Shift, dsDragMove, Pt, Mode, Effect, Accept);

  // And execute the drop
  AcceptDrop(Effect);
end;

procedure TBrowser.vstBrowseDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  DropListNode: PVirtualNode;
  AMessage: string;
  AllowEffect: integer;
begin

  //We're only interested in ssShift & ssCtrl here so
  //mouse buttons states are screened out ...
  Shift := ([ssShift, ssCtrl] * Shift);

  // Determine allowed effects
  Effect := DropList.DragEffect;
  AllowEffect := Effect;

  // Determine dropitem
  DropItem := nil;
  DropFolder := '';
  AMessage := '';
  if not assigned(DropSender) then
    // Since this one comes from from external, mimick it
    DropList.ExtMimick := True;

  DropListNode := vstBrowse.DropTargetNode;
  if assigned(DropListNode) then
  begin

    // The dropitem that is resp for this drop
    DropItem := ItemByNode(DropListNode);

  end else
  begin

    // No item, so in emptyness.. try to find at least a folder
    DropFolder := GetCurrentFolder;

  end;

  // Call allowdrop
  Accept := AllowDrop(AllowEffect, Shift, AMessage);

  // Check effects
  Effect := Effect and AllowEffect;
  if Effect = 0 then
    Accept := False;

  DropList.ExtMimick := False;
  DoStatusMessage(AMessage);

end;

procedure TBrowser.FolderScanItemsExecute(Sender: TObject);
begin
  if ActiveItem is TPidlItem then
    // Scan only this dir
    RunScan(TPidlItem(ActiveItem).FolderName, False, False, '', '',
      frmMain.RootClearBatchedItems)
end;

procedure TBrowser.FolderScanSubExecute(Sender: TObject);
begin
  if ActiveItem is TPidlItem then
    // Run a scan including new and existing subfolders
    RunScan(TPidlItem(ActiveItem).FolderName, True, True, '', '',
      frmMain.RootClearBatchedItems)
end;

procedure TBrowser.FolderRemoveItemsExecute(Sender: TObject);
begin
  if ActiveItem is TPidlItem then
    // Remove items from Pidl
    BrowseTree.RemoveItemsFromPidl(ActiveItem, False);
end;

procedure TBrowser.FolderRemoveSubExecute(Sender: TObject);
begin
  if ActiveItem is TPidlItem then
    // Remove items from Pidl including subs
    BrowseTree.RemoveItemsFromPidl(ActiveItem, True);
end;

procedure TBrowser.BrowseRenameExecute(Sender: TObject);
begin
  if assigned(ActiveItem) then
  begin
    if ActiveItem.AllowRename then
      vstBrowse.EditNode(ActiveNode, -1)
    else
      MessageDlg('You cannot rename this item.',
        mtInformation, [mbOK, mbHelp], 0);
  end;
end;

procedure TBrowser.FolderDeleteExecute(Sender: TObject);
begin
  BrowseTree.DeleteIfEmpty(ActiveItem);
end;

procedure TBrowser.FolderNewExecute(Sender: TObject);
begin
  BrowseTree.NewSubFolder(ActiveItem);
end;

end.

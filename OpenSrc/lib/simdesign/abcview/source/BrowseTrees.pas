{ Unit BrowseTrees

  This unit implements the browsetrees in the left pane

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit BrowseTrees;

interface

uses
  Windows, Classes, Contnrs, SysUtils, Dialogs, sdProperties, VirtualTrees,
  ItemLists, guiItemView, sdItems, Filters, guiFilterFrame, Graphics, ShlObj,
  DropSource, sdAbcVars, sdAbcFunctions;

type

  TBrowseItemID = (biNone, biStandard);

  TBrowseItemOption =
    ( biAllowRename,   // Allow the item to be renamed
      biAllowRemove,   // Allow the user to remove the item
      biInitialised,   // This flag is set when item finished initalisation
      biNoStatistics,  // Do not show the count behind the item
      biHasChildren,   // Initially a [+] sign is shown
      biPersistantFilter // Filter will not get disconnected
    );
  TBrowseItemOptions = set of TBrowseItemOption;

  TBrowseTree = class;

  TBrowseItem = class(TsdProperty)
  private
    FCaption: string;     // Caption of the treeitem
    FDialogCaption: string; // Caption shown in dialog
    FDialogIcon: integer; // Dialog Icon index into ilFilter imagelist
    FFilter: TItemMngr;   // Pointer to ItemMngr filter, nil if none. The filter
                          // is owned by TBrowseItem
    FFrameClass: TFilterFrameClass; // Class of the associated frame
    FHelpContext: integer; // The help context when user clicks help in dialog
    FImageIndex: integer; // Image index for normal and selected mode
    FParent: TBrowseItem; // The "parentfolder" item
    FStateIndexClose: integer; // Image index for state images (closed) - used in PIDL
    FStateIndexOpen: integer; // Image index for state images (open) - used in PIDL
    FNode: PVirtualNode;  // Pointer to virtual node in tree
    FTree: TBrowseTree;   // Pointer to tree
    FItemCount: integer;  // Number of items in the source of the filter
    FOptions: TBrowseItemOptions;
  protected
    FActivating: boolean; // Control is currently activating
    procedure CountUpdate(Sender: TObject);
    procedure CreateFilterParams; virtual;
    function GetChildCount: integer; virtual;
    function GetChilds(Index: integer): TBrowseItem;
    function GetDragImage: integer; virtual;
    function GetDragTypes: TDragTypes; virtual;
    function GetExpanded: boolean;
    function GetSource: TItemMngr;
    function GetVisible: boolean;
    function GetVST: TVirtualStringTree;
    procedure SetCaption(AValue: string);
    procedure SetExpanded(AValue: boolean);
    procedure SetFilter(AValue: TItemMngr);
    procedure SetItemCount(AValue: integer);
    procedure SetSource(AValue: TItemMngr);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AcceptDrop(var Effect: integer); virtual;
    function AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean; virtual;
    procedure Activate; virtual;
    function AllowRename: boolean; virtual;
    function CheckState: TCheckState; virtual;
    function CheckType: TCheckType; virtual;
    // Connect a node to our filter
    procedure ConnectNode(ANode: TItemMngr); virtual;
    // Disconnect a node from our filter
    procedure DisconnectNode(ANode: TItemMngr); virtual;
    procedure DoDrop(Sender: TObject; Effect: integer); virtual;
    procedure DoRename(ANewName: string); virtual;
    procedure DoStatusMessage(AMessage: string); virtual;
    function GetEmptyWarning: string; virtual;
    function GetIcon(Image: TIcon): boolean; virtual;
    procedure InitialiseFilter; virtual;
    function IsRoot: boolean;
    procedure MakeFocused; virtual;
    // Call update to reflect any changes made to the item in the VST
    procedure Update;
    property Activating: boolean read FActivating;
    property Caption: string read FCaption write SetCaption;
    property ChildCount: integer read GetChildCount;
    property Childs[index: integer]: TBrowseItem read GetChilds;
    property DialogCaption: string read FDialogCaption write FDialogCaption;
    property DialogIcon: integer read FDialogIcon write FDialogIcon;
    // DragImage is the drag image, given as index into browser's image list
    property DragImage: integer read GetDragImage;
    property DragTypes: TDragTypes read GetDragTypes;
    property Filter: TItemMngr read FFilter write SetFilter;
    // Frameclass defines what kind of frame comes with this specific item
    property FrameClass: TFilterFrameClass read FFrameClass write FFrameClass;
    property HelpContext: integer read FHelpContext write FHelpContext;
    property ImageIndex: integer read FImageIndex write FImageIndex;
    property StateIndexClose: integer read FStateIndexClose write FStateIndexClose;
    property StateIndexOpen: integer read FStateIndexOpen write FStateIndexOpen;
    property Expanded: boolean read GetExpanded write SetExpanded;
    property IsVisible: boolean read GetVisible;
    property ItemCount: integer read FItemCount write SetItemCount;
    property Node: PVirtualNode read FNode write FNode;
    property Options: TBrowseItemOptions read FOptions write FOptions;
    property Parent: TBrowseItem read FParent write FParent;
    property Source: TItemMngr read GetSource write SetSource;
    property Tree: TBrowseTree read FTree write FTree;
    property VST: TVirtualStringTree read GetVST;
  end;

  TVerifyFolderAction = (vfaClear, vfaInsert, vfaRemove, vfaUpdate);

  TBrowseMngr = class(TItemMngr)
  public
    Tree: TBrowseTree;
    // Overridden from TItemMnger
    procedure ClearItems(Sender: TObject); override;
    procedure InsertItems(Sender: TObject; AList: TList); override;
    procedure RemoveItems(Sender: TObject; AList: TList); override;
    procedure UpdateItems(Sender: TObject; AList: TList); override;
  end;

  TBrowseTree = class(TsdProperty)
  private
    FActiveNode: PVirtualNode;
    FAllItems: TBrowseItem; // Pointer to "all items"
    FDest: TItemMngr; // Destination
    FDrives: TBrowseItem; // Pointer to "My computer"
    FItems: TObjectList; // Contains TBrowseItem items
    FMngr: TBrowseMngr;
    FNewItem: TBrowseItem; // Temporary pointer to the newly added item
    FPidlIsUpdating: boolean; // Flag that indicates if there's a Pidl currently updating
    FSource: TItemMngr; // Source
    FVST: TVirtualStringTree;
  protected
    procedure ForcePidlFolder(APath: string);
    function GetActiveItem: TBrowseItem;
    function GetItemCount: integer;
    function GetItems(AIndex: integer): TBrowseItem;
    procedure SetSource(AValue: TItemMngr);
  public
    constructor Create(AVST: TVirtualStringTree; AItemView: TItemView);
    destructor Destroy; override;
    procedure AddItem(AItem: TBrowseItem; ParentNode: PVirtualNode);
    procedure CreatePIDL;
    procedure DeleteIfEmpty(AItem: TBrowseItem);
    function ItemWithNode(ANode: PVirtualNode): TBrowseItem;
    function ItemWithName(AName: string): TBrowseItem;
    procedure NewSubFolder(AItem: TBrowseItem);
    function PidlByFolderName(APath: string): TBrowseItem;
    procedure PidlDriveUpdate(Sender: TObject; APath: string);
    procedure PidlFolderActivate(APath: string);
    procedure PidlFolderAdd(Sender: TObject; APath: string);
    procedure PidlFolderDelete(Sender: TObject; APath: string);
    procedure PidlFolderRename(OldPath, NewPath: string);
    procedure PidlFolderUpdate(Sender: TObject; APath: string);
    function PidlMyComputer: TBrowseItem;
    procedure RemoveAllChildren(AItem: TBrowseItem);
    procedure Remove(AItem: TBrowseItem);
    function RemoveItemsFromPidl(AItem: TBrowseItem; InclSub: boolean): boolean;
    procedure VerifyFolderCheckmarks(AFolder: TsdFolder; Action: TVerifyFolderAction);
    property ActiveNode: PVirtualNode read FActiveNode write FActiveNode;
    property ActiveItem: TBrowseItem read GetActiveItem;
    property AllItems: TBrowseItem read FAllItems;
    property Dest: TItemMngr read FDest;
    property Drives: TBrowseItem read FDrives;
    property ItemCount: integer read GetItemCount;
    property Items[Index: integer]: TBrowseItem read GetItems;
    property Mngr: TBrowseMngr read FMngr;
    property Source: TItemMngr read FSource write SetSource;
    property VST: TVirtualStringTree read FVST write FVST;
  end;

// Call this function with a browseitem id to create a known item. This function
// is used in the catalog's LoadFromStream function to recreate saved properties.
// Always adapt this function for *stored* derived properties.
function CreateBrowseItem(BrowseItemID: TBrowseItemID): TBrowseItem;

implementation

uses
  guiMain, guiRootItems, guiFilterDialog, guiStandardItems, guiPidlItems, ShellUtilities,
  sdRoots, sdScanFolders, UserActivities;

function CreateBrowseItem(BrowseItemID: TBrowseItemID): TBrowseItem;
begin
  Result := nil;
  case BrowseItemID of
  biStandard: TStandardItem.Create;
  end;
end;

{ TBrowseItem }

procedure TBrowseItem.CountUpdate(Sender: TObject);
begin
  if assigned(FFilter) then
    ItemCount := FFilter.Count;
end;

procedure TBrowseItem.CreateFilterParams;
begin
  // Set filter options
  Options := Options + [biAllowRemove];
  // Caption for the tree list
  Caption := 'Frame Filter';
  // Construct a standard type filter
  Filter := TTypeFilter.Create;
  TTypeFilter(Filter).AcceptedTypes := [itFile];
  // Set frame class
  FrameClass := TFilterFrame;
end;

function TBrowseItem.GetChildCount: integer;
begin
  // Use the tree to find the number of childs
  Result := 0;
  if assigned(Node) then
    Result := Node^.ChildCount;
end;

function TBrowseItem.GetChilds(Index: integer): TBrowseItem;
var
  Count: integer;
  Child: PVirtualNode;
begin
  Result := nil;
  // Use the VST to find the child node at location Index
  Child := nil;
  if assigned(Node) then
    Child := Node^.FirstChild;
  Count := 0;
  while (Count < Index) and assigned(Child) do
  begin
    Child := Child.NextSibling;
    inc(Count);
  end;
  // And use the tree to find the corresponding BrowseItem
  if assigned(Tree) then
    Result := Tree.ItemWithNode(Child);
end;

function TBrowseItem.GetDragImage: integer;
begin
  // Defaults to image index
  Result := ImageIndex;
end;

function TBrowseItem.GetDragTypes: TDragTypes;
begin
  // No dragging per default
  Result := [dtCopy];
end;

function TBrowseItem.GetExpanded: boolean;
begin
 Result := False;
 if assigned(Node) then
   Result := (vsExpanded in Node.States);
end;

function TBrowseItem.GetSource: TItemMngr;
begin
  Result := nil;
  if not assigned(Tree) then
    exit;

  // Source is parent..
  if assigned(Parent) then
    Result := Parent.Filter
  else
    // .. or root object
    Result := Tree.Source;
end;

function TBrowseItem.GetVisible: boolean;
begin
  Result := False;
  if assigned(VST) and assigned(Node) then
    Result := VST.IsVisible[Node];
end;

function TBrowseItem.GetVST: TVirtualStringTree;
begin
  Result := nil;
  if assigned(Tree) then
    Result := Tree.VST;
end;

procedure TBrowseItem.SetCaption(AValue: string);
begin
  if FCaption <> AValue then
  begin
    FCaption := AValue;
    Update;
  end;
end;

procedure TBrowseItem.SetExpanded(AValue: boolean);
begin
  if assigned(VST) then
    VST.Expanded[Node] := AValue;
end;

procedure TBrowseItem.SetFilter(AValue: TItemMngr);
var
  i: integer;
begin
  if FFilter <> AValue then
  begin

    if assigned(FFilter) and assigned(AValue) then
    begin
      // Just to make sure
      AValue.Disconnect;
      // Copy the nodes
      for i:= 0 to FFilter.Nodes.Count do
        AValue.ConnectNode(FFilter.Nodes[i]);
    end;

    // Gracefully get rid of old filter
    if assigned(FFilter) then
    begin
      if assigned(Source) then
        Source.DisconnectNode(FFilter);
      FFilter.Disconnect;
      FreeAndNil(FFilter);
    end;

    FFilter := AValue;
    if assigned(FFilter) then
    begin
      // Update
      FFilter.OnUpdate := CountUpdate;
      FFilter.Name := Caption;
      // Connect the parent filter
      if assigned(Source) then
        Source.ConnectNode(FFilter);
    end;
    Update;
  end;
end;

procedure TBrowseItem.SetItemCount(AValue: integer);
begin
  if AValue <> FItemCount then
  begin
    FItemCount := AValue;
    Update;
  end;
end;

procedure TBrowseItem.SetSource(AValue: TItemMngr);
begin
  if assigned(AValue) then
    AValue.ConnectNode(Filter);
end;

constructor TBrowseItem.Create;
begin
  inherited;
  FOptions := [];
  FImageIndex := -1;
  FStateIndexClose := -1;
  FStateIndexOpen := -1;
  CreateFilterParams;
end;

destructor TBrowseItem.Destroy;
begin
  FreeAndNil(FFilter);
  inherited;
end;

procedure TBrowseItem.AcceptDrop(var Effect: integer);
begin
  // default does nothing
end;

function TBrowseItem.AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean;
begin
  // Default does not accept anything
  Result := False;
end;

procedure TBrowseItem.Activate;
var
  Item: TBrowseItem;
begin
  // Avoid recursive call
  if FActivating then
    exit;

  if assigned(Tree) and assigned(VST) and assigned(Node) then
  begin
    // Already active?
    if Tree.ActiveNode = Node then
      exit;

    // We can disconnect the old node from Dest
    Item := Tree.ItemWithNode(Tree.ActiveNode);
    if assigned(Item) then
      Item.DisconnectNode(Tree.Dest);

    // Disconnect the old item (only if Pidl and not persistant and not parent)
    if assigned(Item) and assigned(Item.Filter) and assigned(Tree.Source) and
      (Item is TPidlItem) and
      not (biPersistantFilter in Item.Options) and
      (Item <> Parent) then
    begin
      Tree.Source.DisconnectNode(Item.Filter);
    end;

    // We are about to connect to a Pidl with a standard filter?
    if assigned(Parent) and (Parent is TPidlItem) and
       not (Self is TPidlItem) then
    begin
      // Now that this Pidl filter serves as source, make sure not to
      // disconnect it once another pidl gets connected
      Parent.Options := Parent.Options + [biPersistantFilter];
      // If parent is Pidl and not expanded, and we are not Pidl,
      // then it should have ShowSubItems set
      if (TPidlItem(Parent).Expanded = False) then
      begin
        // Expand the item to warrant that subfolders are displayed
        TPidlItem(Parent).UpdateSubNS;
        // Show items in subfolders by default
        TPidlItem(Parent).ShowSubItems := True;
      end;
    end;

    // Direct root or cascaded?
    if (Self is TPidlItem) then
    begin
      // Direct to root connect (optimised performance)
      if assigned(Tree.Source) then
      begin
        Tree.Source.ConnectNode(Filter);
      end;
    end else
    begin
      // Connect our parent(s) to us
      if assigned(Parent) then
        Parent.ConnectNode(Filter);
    end;

    // Connect ourself to the destination
    ConnectNode(Tree.Dest);
    // Assign our node as ActiveNode
    Tree.ActiveNode := Node;

    FActivating := True;
    try
      // And grab the focus
      MakeFocused;
    finally
      FActivating := False;
    end;
  end;
end;

function TBrowseItem.AllowRename: boolean;
begin
  Result := biAllowRename in Options;
end;

function TBrowseItem.CheckState: TCheckState;
begin
  // Basic one returns unchecked
  Result := csUncheckedNormal;
end;

function TBrowseItem.CheckType: TCheckType;
begin
  // Basic one returns none
  Result := ctNone;
end;

procedure TBrowseItem.ConnectNode(ANode: TItemMngr);
begin
  if assigned(Filter) then
    Filter.ConnectNode(ANode);
end;

procedure TBrowseItem.DisconnectNode(ANode: TItemMngr);
begin
  if assigned(Filter) then
    Filter.DisconnectNode(ANode);
end;

procedure TBrowseItem.DoDrop(Sender: TObject; Effect: integer);
begin
  // Handle any drop - default does nothing
end;

procedure TBrowseItem.DoRename(ANewName: string);
begin
  // Standard renaming
  Caption := ANewName;
end;

procedure TBrowseItem.DoStatusMessage(AMessage: string);
begin
  // we go over the root object
  if assigned(frmMain.Root) then
    frmMain.Root.DoStatusMessage(Self, AMessage);
end;

function TBrowseItem.GetEmptyWarning: string;
begin
  // The default returns the root's warning
  Result := 'Please add some items to your collection by browsing and checking folders.';
end;

function TBrowseItem.GetIcon(Image: TIcon): boolean;
begin
  // Default just returns false to force dialog to use its own image list
  Result := False;
end;

procedure TBrowseItem.InitialiseFilter;
begin
  Options := Options + [biInitialised];
end;

function TBrowseItem.IsRoot: boolean;
begin
  IsRoot := not assigned(Parent);
end;

procedure TBrowseItem.MakeFocused;
begin
  if assigned(VST) and assigned(FNode) then
  begin
    if FNode <> VST.FocusedNode then
    begin
      VST.FocusedNode := FNode;
      VST.Selected[FNode] := True;
    end;
  end;
end;

procedure TBrowseItem.Update;
begin
  if assigned(Node) and assigned(VST) then
    VST.InvalidateNode(Node);
end;

{ TBrowseMngr }

procedure TBrowseMngr.ClearItems(Sender: TObject);
begin
  Tree.VerifyFolderCheckmarks(nil, vfaClear);
end;

procedure TBrowseMngr.InsertItems(Sender: TObject; AList: TList);
var
  i: integer;
begin
  if assigned(AList) and assigned(frmMain.Root) and (AList.Count > 0) then
  begin
    // Make sure that the right Pidl folders are checked (checkmark on)
    for i := 0 to AList.Count - 1 do
      if assigned(AList[i]) and (TsdItem(AList[i]).ItemType = itFolder) then
        Tree.VerifyFolderCheckmarks(AList[i], vfaInsert);
    // Reset all parent id's so that in later operations the correct parent
    // is found
    for i := 0 to frmMain.Root.FAllFolders.Count - 1 do
      TsdFolder(frmMain.Root.FAllFolders[i]).ParentGuid := cEmptyGuid;
  end;
end;

procedure TBrowseMngr.RemoveItems(Sender: TObject; AList: TList);
var
  i: integer;
begin
  for i := 0 to AList.Count - 1 do
    if assigned(AList[i]) and (TsdItem(AList[i]).ItemType = itFolder) then
      Tree.VerifyFolderCheckmarks(AList[i], vfaRemove);
end;

procedure TBrowseMngr.UpdateItems(Sender: TObject; AList: TList);
var
  i: integer;
begin
  for i := 0 to AList.Count - 1 do
    if assigned(AList[i]) and (TsdItem(AList[i]).ItemType = itFolder) then
      Tree.VerifyFolderCheckmarks(AList[i], vfaUpdate);
end;

{ TBrowseTree }

procedure TBrowseTree.ForcePidlFolder(APath: string);
// Call ForcePidlFolder to make sure that the whole Pidl tree until APath exists.
// If the tree towards APath cannot be created, the procedure is just exited, no
// error message or creation of folders.
var
  Parent, Temp: TPidlItem;
// local function
function FindParentPidl(APath: string): TPidlItem;
begin
  repeat
    Result := TPidlItem(PidlByFolderName(APath));
    APath := GetParentFolder(APath);
  until assigned(Result) or (length(APath) = 0);
end;
// main
begin
  // first, repeat down until we find an existing path
  Parent := FindParentPidl(APath);
  while (AnsiCompareText(IncludeTrailingPathDelimiter(Parent.FolderName),
                         IncludeTrailingPathDelimiter(APath)) <> 0) and
         assigned(Parent) do
  begin
    Parent.UpdateSubNS;
    Temp := Parent;
    Parent := FindParentPidl(APath);
    // We revert to the same again, so exit to avoid endless loop. This situation
    // can happen when a completely bogus path is entered
    if Temp = Parent then
      exit;
  end;
end;

function TBrowseTree.GetActiveItem: TBrowseItem;
begin
  Result := nil;
  if assigned(ActiveNode) then
    Result := ItemWithNode(ActiveNode);
end;

function TBrowseTree.GetItemCount: integer;
begin
  Result := 0;
  if assigned(FItems) then
    Result := FItems.Count;
end;

function TBrowseTree.GetItems(AIndex: integer): TBrowseItem;
begin
  Result := nil;
  if assigned(FItems) and (AIndex >= 0) and (AIndex < FItems.Count) then
    Result := TBrowseItem(FItems[AIndex]);

end;

procedure TBrowseTree.SetSource(AValue: TItemMngr);
var
  i: integer;
begin
  if AValue <> FSource then
  begin
    if assigned(FSource) then
    begin
      // Disconnect old from our root item(s)
      for i := 0 to ItemCount - 1 do
        if Items[i].Parent = nil then
          FSource.DisconnectNode(Items[i].Filter);
    end;
    FSource := AValue;
    // This will cause the source to propagate
    if assigned(FSource) then
    begin
      // Connect it to our root item(s)
      for i := 0 to ItemCount - 1 do
        if Items[i].Parent = nil then
          FSource.ConnectNode(Items[i].Filter);
    end;
  end;
end;

constructor TBrowseTree.Create(AVST: TVirtualStringTree; AItemView: TItemView);
var
  Item: TBrowseItem;
begin
  inherited Create;
  FMngr := TBrowseMngr.Create;
  FMngr.Tree := Self;
  FDest := AItemView.ItemList;
  FVST := AVST;

  // Our list of BrowseItems
  FItems := TObjectList.Create;

  // Add the "All Items" item to root
  Item := TRootItem.Create;
  AddItem(Item, nil);
  FAllItems := Item; // Pointer to this root item for later use

  // Activate this item
  FAllItems.Activate;
end;

destructor TBrowseTree.Destroy;
var
  i: integer;
begin
  for i := 0 to ItemCount - 1 do
    if assigned(Items[i].Filter) then
      Items[i].Filter.Disconnect;

  if assigned(FItems) then
    FreeAndNil(FItems);
  if assigned(FMngr) then
    FreeAndNil(FMngr);
  inherited;
end;

procedure TBrowseTree.AddItem(AItem: TBrowseItem; ParentNode: PVirtualNode);
begin
  // Add to our list
  if assigned(FItems) then
  begin
    AItem.Tree := Self;
    AItem.Parent := ItemWithNode(ParentNode);
    FItems.Add(AItem);
  end;
  // Notify the VST
  FNewItem := AItem; // this is to make sure ItemWithNode can find it
  AItem.Node := VST.AddChild(ParentNode);
  FNewItem := nil;
  VST.InvalidateNode(AItem.Node);
end;

procedure TBrowseTree.CreatePIDL;
var
  Item: TBrowseItem;
begin
  // Add the "My computer" (drives) item
  Item := TPidlItem.Create;
  TPidlItem(Item).NameSpace := CreateSpecialNamespace(CSIDL_DRIVES);
  AddItem(Item, nil);
  if assigned(Item.Filter) and assigned(Source) then
    Source.ConnectNode(Item.Filter);
  FDrives := Item;
end;

procedure TBrowseTree.DeleteIfEmpty(AItem: TBrowseItem);
begin
  // Delete a subfolder, only if empty
  if AItem is TPidlItem then
  begin
    // Turn off watchdog
    inc(FShellNotifyRef);
    try
      // Try to delete the folder
      if RemoveDir(TPidlItem(AItem).FolderName) then
      begin
        // Succeeded, so remove the TFolder as well (however in theory
        // it should already be empty, just in case)
        RemoveItemsFromPidl(AItem, True);
        // Remove the BrowseItem
        Remove(AItem);
      end else
      begin
        MessageDlg(
          'The folder could not be deleted.'#13#13+
          'Please make sure that the folder is completely empty and that'#13+
          'the folder is not read-only, before deleting it.',
          mtWarning, [mbOK, mbHelp], 0);
      end;
    finally
      dec(FShellNotifyRef);
    end;
  end;
end;

function TBrowseTree.ItemWithName(AName: string): TBrowseItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ItemCount - 1 do
    if AnsiCompareText(Items[i].Caption, AName) = 0 then
    begin
      Result := Items[i];
      exit;
    end;
end;

function TBrowseTree.ItemWithNode(ANode: PVirtualNode): TBrowseItem;
var
  i: integer;
begin
  Result := FNewItem;
  if assigned(ANode) then
    for i := 0 to ItemCount - 1 do
      if Items[i].Node = ANode then
      begin
        Result := Items[i];
        exit;
      end;
end;

procedure TBrowseTree.NewSubFolder(AItem: TBrowseItem);
var
  NewName: string;
  Count: integer;
begin
  // Delete a subfolder, only if empty
  if AItem is TPidlItem then
  begin
    // Turn off watchdog
    inc(FShellNotifyRef);
    try
      // Create an unique name
      NewName := TPidlItem(AItem).FolderName + 'New Folder';
      Count := 1;
      while DirectoryExists(NewName) do
      begin
        inc(Count);
        NewName := Format('%sNew Folder (%d)', [TPidlItem(AItem).FolderName, Count]);
      end;
      // Try to create the folder
      try
        MkDir(NewName);
        // Succeeded, so update the pidl
        PidlFolderUpdate(Self, TPidlItem(AItem).FolderName);
      except
        MessageDlg(
          'The folder could not be created.'#13#13+
          'Please make sure that the parent folder is not read only.',
          mtWarning, [mbOK, mbHelp], 0);
      end;
    finally
      dec(FShellNotifyRef);
    end;
  end;
end;

function TBrowseTree.PidlByFolderName(APath: string): TBrowseItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ItemCount - 1 do
  begin
    if Items[i] is TPidlItem then
      if AnsiCompareText(
        ExcludeTrailingPathDelimiter(TPidlItem(Items[i]).FolderName),
        ExcludeTrailingPathDelimiter(APath)) = 0 then
      begin
        // Match
        Result := Items[i];
        exit;
      end;
  end;
end;

procedure TBrowseTree.PidlDriveUpdate(Sender: TObject; APath: string);
var
  Pidl: TPidlItem;
begin
  Pidl := TPidlItem(PidlMyComputer);
  if assigned(Pidl) then
    Pidl.NameSpace.InvalidateRelativePidl(True, True, True);

  PidlFolderDelete(Sender, APath);
  PidlFolderAdd(Sender, APath);

end;

procedure TBrowseTree.PidlFolderActivate(APath: string);
// Activate the Pidl if found
var
  Pidl: TPidlItem;
begin
  Pidl := TPidlItem(PidlByFolderName(APath));
  if not assigned(Pidl) then
    ForcePidlFolder(APath);
  Pidl := TPidlItem(PidlByFolderName(APath));
  if assigned(Pidl) then
    Pidl.Activate;
end;

procedure TBrowseTree.PidlFolderAdd(Sender: TObject; APath: string);
// Add a Pidl folder on the right spot
var
  AParent: TPidlItem;
begin
  AParent := TPidlItem(PidlByFolderName(GetParentFolder(APath)));
  if AParent = nil then
    // APath could be a drive
    if length(Apath) = 3 then
      AParent := TPidlItem(PidlMyComputer);
  if assigned(AParent) then
  begin
    // Add a new child folder
    if AParent.ChildrenInitialized then
      AParent.AddSubPidl(APath);
  end;
end;

procedure TBrowseTree.PidlFolderDelete(Sender: TObject; APath: string);
// Delete the Pidl with APath
var
  Pidl: TBrowseItem;
begin
  Pidl := PidlByFolderName(APath);
  if assigned(Pidl) then
    Remove(Pidl);
end;

procedure TBrowseTree.PidlFolderRename(OldPath, NewPath: string);
// If found, rename the Pidl from Old to New
var
  Pidl: TPidlItem;
begin
  if GetParentFolder(OldPath) = GetParentFolder(NewPath) then
  begin
    // This is a rename
    Pidl := TPidlItem(PidlByFolderName(OldPath));
    if assigned(Pidl) then
      Pidl.RenamePidl(NewPath);
  end else
  begin
    // Not a Rename but a Move! Update both parents
    PidlFolderUpdate(Self, GetParentFolder(OldPath));
    PidlFolderUpdate(Self, GetParentFolder(NewPath));
  end;
end;

procedure TBrowseTree.PidlFolderUpdate(Sender: TObject; APath: string);
// Update the Pidl with APath
var
  Pidl: TPidlItem;
begin
  // In case of bombardement with updates: just exit and do nothing
  if FPidlIsUpdating then
    exit;
  FPidlIsUpdating := True;
  try
    Pidl := TPidlItem(PidlByFolderName(APath));
    if assigned(Pidl) then
    begin
      // Update the sub namespace
      Pidl.UpdateSubNS;
      // Make sure to re-filter
      Pidl.Filter.Execute;
    end;
  finally
    FPidlIsUpdating := False;
  end;
end;

function TBrowseTree.PidlMyComputer: TBrowseItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ItemCount - 1 do
    if (Items[i] is TPidlItem) and (TPidlItem(Items[i]).IsRoot) then
    begin
      Result := Items[i];
      exit;
    end;
end;

procedure TBrowseTree.RemoveAllChildren(AItem: TBrowseItem);
var
  i: integer;
  ANode: PVirtualNode;
begin
  if not assigned(AItem) then
    exit;

  ANode := AItem.Node;

  // Close dialog if it were open in a child
  if dlgFilter.Visible and assigned(dlgFilter.Item) then
    if VST.HasAsParent(dlgFilter.Item.Node, ANode) then
      dlgFilter.Close;

  // Shift ActiveNode
  if assigned(ActiveNode) then
    if VST.HasAsParent(ActiveNode, ANode) then
      AItem.Activate;

  // Find all items that have AItem as parent, and remove them
  i := 0;
  while i < ItemCount do
    if VST.HasAsParent(Items[i].Node, ANode) then
    begin
      if assigned(Items[i].Filter) then
        Items[i].Filter.DisconnectAll;
      FItems.Remove(Items[i])
    end else
      inc(i);

  // VST should delete the node (and subnodes)
  VST.DeleteChildren(ANode);
  VST.Invalidate;
end;

procedure TBrowseTree.Remove(AItem: TBrowseItem);
// Remove will remove the browseitem AItem from the tree, assign another (parent)
// item as active if neccesary and update
var
  i: integer;
  ANode: PVirtualNode;
begin
  if not assigned(AItem) then
    exit;

  ANode := AItem.Node;

  // Close dialog if it were open
  if dlgFilter.Visible then
    dlgFilter.Close;

  // Shift ActiveNode
  if assigned(AItem.Parent) then
  begin
    if ANode = ActiveNode then
      AItem.Parent.Activate;
    // Parent should disconnect us
    AItem.Parent.DisconnectNode(AItem.Filter);
  end;

  // Disconnect filter
  if assigned(AItem.Filter) then
    AItem.Filter.DisconnectAll;

  // Find all items that have AItem as parent, and remove them
  i := 0;
  while i < ItemCount do
    if VST.HasAsParent(Items[i].Node, ANode) then
      FItems.Remove(Items[i])
    else
      inc(i);

  // Free the item
  FItems.Remove(AItem);

  // VST should delete the node (and subnodes)
  VST.DeleteNode(ANode);
  VST.Invalidate;
end;

function TBrowseTree.RemoveItemsFromPidl(AItem: TBrowseItem; InclSub: boolean): boolean;
// Remove all the items in the collection that are part of this Pidl
// Return True if successful, False if not
var
  List: TList;
begin
  Result := False;
  if AItem is TPidlItem then
  begin
    if IsScanBusy then
    begin
      // No removal during scans
      MessageDlg(
        'Please wait for the scan to finish'#13 +
        'before removing items from the collection,'#13 +
        'or stop the scan in the "processes" dialog.',
        mtInformation, [mbOK, mbHelp], 0);
      exit;
    end;
    List := TList.Create;
    try
      // create a list, including children?
      TPidlItem(AItem).CreateItemList(List, InclSub);
      if RemoveDespiteWarn(List) then
      begin
        // We delete asynchronously (this means next statement returns directly)
        frmMain.Root.RemoveItemsAsync(Self, List);
        Result := True;
      end;
    finally
      List.Free;
    end;
  end;
end;

procedure TBrowseTree.VerifyFolderCheckmarks(AFolder: TsdFolder; Action: TVerifyFolderAction);
var
  i: integer;
  AItem: TBrowseItem;
  PI: TPidlItem;
begin
  for i := 0 to ItemCount - 1 do
  begin
    AItem := Items[i];
    if assigned(AItem) and (AItem is TPidlItem) then
    begin
      PI := TPidlItem(AItem);
      case Action of
      vfaClear:
        begin
          PI.Node.CheckState := csUncheckedNormal;
          PI.Update;
        end;
      vfaInsert, vfaRemove:
        if IncludeTrailingPathDelimiter(PI.FolderName) = AFolder.FolderName then
        begin
          if Action = vfaInsert then
          begin
            PI.Node.CheckState := csCheckedNormal;
            PI.FolderGuid := AFolder.Guid;
          end else
          begin
            PI.Node.CheckState := csUncheckedNormal;
            PI.FolderGuid := cEmptyGuid;
          end;
          PI.Update;
        end;
      vfaUpdate:
        begin
          if IsEqualGuid(PI.FolderGuid, AFolder.Guid) then
          begin
            // Folder rename
            PI.Update;
          end;
        end;
      end;//case
    end;
  end;
end;

end.

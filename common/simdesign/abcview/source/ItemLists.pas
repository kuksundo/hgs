{ Unit ItemLists

  Unit ItemLists implements a generic list of items with insertion/deletion and
  update functionality.

  Modifications:
  23May2004: TItemList.ExtractItemsFromList: added if assigned() check

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}

{$DEFINE USELOCKING}

unit ItemLists;

interface

uses
  Classes, SysUtils, SyncObjs, Contnrs, Math, Dialogs, sdItems, sdSorter, sdAbcTypes,
  sdSortedLists, sdStreamableData;

type

  PNotifyEvent = ^TNotifyEvent;

  // The TListEvent event type is used for List Events (OnUpdateList, etc)
  TListEvent = procedure(Sender: TObject; AList: TList) of object;

  TRangeUpdateEvent = procedure(Sender: TObject; AMinIndex, AMaxIndex: integer) of object;

  TProgressMsgEvent = procedure(Sender: TObject; AMsg: string; APercent: double) of object;

  TStatusMessageEvent = procedure(Sender: TObject; AMessage: string) of object;

  TActionType = (atInsert, atUpdate, atRemove, atClear, atSort, atFilter, atDelete,
                 atExpand);

  TDescriptorType = (dtFilter, dtDrive, dtFolder);

  TItemList = class;

  // Use TItemMngr as a base class for all classes that have to respond to OnInsert,
  // OnRemove, OnClear and OnUpdate events for items. The basic TItemMngr does
  // nothing, and methods InsertItems, RemoveItems, ClearItems and UpdateItems must
  // be overridden to provide functionality. Use TItemList as a base class if you
  // want the class to manage its own items.
  TItemMngr = class
  private
    // debugging
    {$IFDEF USELOCKING}
//    FLockCount: integer;
    {$ENDIF}

    FNestLevel: integer;
    FParent: TItemMngr;
    // Events
  protected
    FOnBeginUpdate: TNotifyEvent;
    FOnClearItems: TNotifyEvent;
    FOnEndUpdate: TNotifyEvent;
    FOnInsertItems: TListEvent;
    FOnRangeUpdate: TRangeUpdateEvent;
    FOnRemoveItems: TListEvent;
    FOnUpdateItems: TListEvent;
    FOnUpdate: TNotifyEvent;
    //procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
  protected
    // Use FLock to regulate access to FItems so it is threadsafe
    FLock: TMultiReadExclusiveWriteSynchronizer;
    // Min and Max index used in RangeUpdate
    FMinRange: integer;
    FMaxRange: integer;
    // FName holds the name of the filter
    FName: string;
    // FNodes is a list of pointers to child node lists
    FNodes: TList;
    procedure DoClearItems; virtual;
    procedure DoInsertItems(AList: TList); virtual;
    procedure DoRangeUpdate; virtual;
    procedure DoRemoveItems(AList: TList); virtual;
    procedure DoUpdate; virtual;
    procedure DoUpdateItems(AList: TList); virtual;
    function GetCount: integer; virtual;
    function GetIsRunning: boolean; virtual;
    function GetName: string; virtual;
    function GetNestLevel: integer; virtual;
    function GetNodes: TList; virtual;
    function GetParent: TItemMngr; virtual;
    function GetRoot: TItemList; virtual;
    procedure SetNestLevel(AValue: integer); virtual;
    procedure SetName(AValue: string); virtual;
    procedure SetNodes(AValue: TList); virtual;
    procedure SetOnUpdate(AValue: TNotifyEvent); virtual;
    procedure SetParent(AValue: TItemMngr); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    // Number of items in the list
    property Count: integer read GetCount;
    // IsRunning is True if the manager is doing the filtering process. This
    // property is provided for the descendants (filters), and returns False
    // by default in TItemMngr
    property IsRunning: boolean read GetIsRunning;
    // temporarily public, must be removed
    property NestLevel: integer read GetNestLevel write SetNestLevel;
    // Name specifies a name for the filter that can be used by the application for
    // display/caption purposes.
    property Name: string read GetName write SetName;
    // List of pointers to filters that are actively updated
    property Nodes: TList read GetNodes write SetNodes;
    // Set the Parent property to any other Itemlist to make the itemlist it's node.
    // Set Parent to nil to disconnect the Itemlist.
    property Parent: TItemMngr read GetParent write SetParent;
    // Root returns a pointer to the root object
    property Root: TItemList read GetRoot;

    // Events
    property OnRangeUpdate: TRangeUpdateEvent read FOnRangeUpdate write FOnRangeUpdate;
    property OnUpdate: TNotifyEvent read FOnUpdate write SetOnUpdate;
    // Use AddNode to add a child Itemlist in the chain
    procedure AddNode(ANode: TItemMngr); virtual;
    // AssignItems will first clear the list and then insert AList.
    procedure AssignItems(Sender: TObject; AList: TList); virtual;
    // ClearItems will clear all items in the itemlist
    procedure ClearItems(Sender: TObject); virtual;
    // CopyItems will put a copy of all of the ItemMngr's items into AList.
    // Creation and destruction of AList is responsibility of the caller.
    // ItemMngr itself does not hold a list, so override this method for
    // descendants.
    procedure CopyItems(Sender: TObject; AList: TList); virtual;
    procedure ConnectNode(ANode: TItemMngr); virtual;
    // Call Disconnect for all filters that are to be destroyed before
    // destroying any of them in the chain. Disconnect will disconnect them
    // from source & all nodes. You must also call DisconnectNode() from
    // the source before destroying the filter.
    // example: A - B - C : in order to remove B, proceed like this:
    //   A.DisconnectNode(B);
    //   B.Disconnect;
    //   B.Free;
    // If you want to connect A to C, then
    //   A.ConnectNode(C);
    procedure Disconnect; virtual;
    // Use DisconnectAll for the root object. It will recursively disconnect
    // any connected Mngr.
    procedure DisconnectAll;
    // Disconnects all nodes, but leaves source and updates in place
    procedure DisconnectAllNodes;
    procedure DisconnectNode(ANode: TItemMngr); virtual;
    procedure DoBeginUpdate; virtual;
    procedure DoEndUpdate; virtual;
    // Execute is called whenever it is neccesary to re-assign the items from
    // the parent. Do not call Execute directly, but use Update(nil) instead.
    procedure Execute; virtual;
    procedure InsertItems(Sender: TObject; AList: TList); virtual;
    // Use LockRead in conjunction with UnlockRead to obtain a manual read lock
    // on the ItemList. ALWAYS call UnlockRead after calling LockRead!
    // During a read lock no other process can write to the list.
    procedure LockRead; virtual;
    // Use LockWrite in conjunction with UnlockWrite to obtain a manual write lock
    // on the ItemList. ALWAYS call UnlockWrite after calling LockWrite! You can use
    // DirectItems to get direct access to the TList object.
    procedure LockWrite; virtual;
    // Remove will remove the Item from the Item List (if it is present)
    // and update all depending lists and controls.
    procedure Remove(Item: TsdItem); virtual;
    procedure RemoveItems(Sender: TObject; AList: TList); virtual;
    // Use RemoveNode to remove a child Itemlist from the chain
    procedure RemoveNode(ANode: TItemMngr); virtual;
    // Use SetNode instead of AddNode to make sure that the node added
    // is the exclusive output of this filter
    procedure SetNode(ANode: TItemMngr); virtual;
    // Always call UnlockRead after a call to LockRead
    procedure UnlockRead; virtual;
    // Always call UnlockWrite after a call to LockWrite.
    procedure UnlockWrite; virtual;
    procedure UpdateItems(Sender: TObject; AList: TList); virtual;

    procedure ReadComponents(S: TStream); virtual;
    procedure WriteComponents(S: TStream); virtual;

    procedure ReadFromStream(S: TStream); virtual;
    procedure WriteToStream(S: TStream); virtual;
  end;

  // TItemList implements a list that can hold TItem items and descendants. The list
  // implements a lot of useful general features:
  // - Load / Store data to / from stream
  // - Automatic sorting with flexible sorting algorithm
  // - Linked item lists and filters are updated accordingly
  // - Thread-safe due to protective locking
  // - Event driven updates
  // - Support for statistics functions
  TItemList = class(TItemMngr)
  private
    // Kind of action
    FActionType: TActionType;
    FBatchInsert: integer;
    FCompareInfo: pointer;
    FOwnsObjects: boolean;
    FSorted: boolean;
    FSortMethod: TSortMethod;

    FOnActionProgress: TProgressMsgEvent;
    FOnCompare: TListSortCustomCompare;
    FOnProgress: TSimpleProgressEvent;

  protected
    // FItems contains the item list
    FItems: TObjectList;
    procedure ActionProgress(ANum, ADen: integer); virtual;
    procedure DoActionProgress(AMsg: string; APercent: double); virtual;
    procedure DoProgress(var Tick: cardinal; Num, Den: integer); virtual;
    procedure DoUpdateItems(AList: TList); override;
    procedure EndProgress(ADen: integer); virtual;
    procedure ExtractAt(AIndex: integer);
    procedure ExtractItemsFromList(AList, NextList: TList; Tick: cardinal);
    function GetActionType: TActionType; virtual;
    procedure GetCompareMethod(var ACompare: TListSortCustomCompare;
      var AInfo: pointer); virtual;
    function GetCount: integer; override;
    function GetItems(Index: integer): TsdItem; virtual;
    function GetOwnsObjects: boolean; virtual;
    function GetSorted: boolean; virtual;
    function GetSortMethod: TSortMethod; virtual;
    procedure SetActionType(AValue: TActionType); virtual;
    procedure SetCompareInfo(AValue: pointer); virtual;
    procedure SetItems(Index: integer; Item: TsdItem); virtual;
    procedure SetOnCompare(AValue: TListSortCustomCompare);
    procedure SetOwnsObjects(AValue: boolean); virtual;
    procedure SetSorted(AValue: boolean); virtual;
    procedure SetSortMethod(AValue: TSortMethod); virtual;
    procedure SortProgress(Sender: TObject; APercent: double);
    function  StartProgress: cardinal; virtual;
  public
    // Creating a TItemList with AOwnsObjects = true will result in the list freeing
    // its objects when they are deleted or cleared. If AOwnsObjects = false the caller
    // needs to take care of object deallocation himself.
    constructor Create(AOwnsObjects: boolean);
    destructor Destroy; override;
    property ActionType: TActionType read GetActionType write SetActionType;
    // if BatchInsert > 0 then on each insert of more than BatchInsert items, the
    // insert will be done in a slightly different way. First, the items are all
    // added and then the list is re-sorted. For large numbers this has quite a
    // performance benefit over on-the-fly sorting. BatchInsert = 0 by default.
    // Set BatchInsert for large lists (e.g. BatchInsert = 10000).
    property BatchInsert: integer read FBatchInsert write FBatchInsert;
    // Set CompareInfo to a record or object containing info for the OnCompare's
    // TListCustomCompare function that will sort the list. The list will be
    // automatically resorted when a new value is assigned to CompareInfo. Use
    // SetCompareMethod to specify both method and info fields in one call.
    property CompareInfo: pointer read FCompareInfo write SetCompareInfo;
    // DirectItems gives direct access to the item list. Use with care! Always brace
    // calls to DirectItems with either LockRead/UnlockRead if you only want to read
    // from the list, or LockWrite/UnlockWrite if you want to write info to the list.
    property DirectItems: TObjectList read FItems write FItems;
    // Items returns the Item at the index, or nil if the index is out of range
    property Items[Index: integer]: TsdItem read GetItems write SetItems; default;
    // OwnsObjects indicates that the objects in the list are owned and thus also
    // freed by the control. It must be set during Create
    property OwnsObjects: boolean read GetOwnsObjects write SetOwnsObjects;
    // Read the Sorted property to check if the list is sorted, Set the Sorted
    // property to sort the list. It uses OnCompare and OnCompareInfo for the sort
    property Sorted: boolean read GetSorted write SetSorted;
    // SortMethod is a placeholder for a sort method object. The OnCompare method
    // is autmatically assigned to CompareItems and the CompareInfo to SortMethod.
    // SortMethod is not created by default, but will be freed when the TItemList
    // is freed.
    property SortMethod: TSortMethod read GetSortMethod write SetSortMethod;

    //
    property OnActionProgress: TProgressMsgEvent read FOnActionProgress write FOnActionProgress;
    // OnBeginUpdate event is triggered before any update to the list is made.
    property OnBeginUpdate: TNotifyEvent read FOnBeginUpdate write FOnBeginUpdate;
    // OnClearItems is called whenever items in the list are cleared.
    property OnClearItems: TNotifyEvent read FOnClearItems write FOnClearItems;
    // Set OnCompare to a TListCustomCompare function that will sort the list.
    // The list will be automatically resorted when a new function is assigned.
    // Use SetCompareMethod to specify both method and info fields in one call.
    property OnCompare: TListSortCustomCompare read FOnCompare write SetOnCompare;
    // OnEndUpdate event is triggered after the update to the list is made.
    property OnEndUpdate: TNotifyEvent read FOnEndUpdate write FOnEndUpdate;
    // OnInsertItems is called whenever items in the list are inserted.
    property OnInsertItems: TListEvent read FOnInsertItems write FOnInsertItems;
    // OnProgress is called to give event feedback during sorting and filtering procedures
    property OnProgress: TSimpleProgressEvent read FOnProgress write FOnProgress;
    // Use this event to update visible list controls that should reflect changes in the ItemList
    property OnRangeUpdate: TRangeUpdateEvent read FOnRangeUPdate write FOnRangeUpdate;
    // OnRemoveItems is called whenever items in the list are removed.
    property OnRemoveItems: TListEvent read FOnRemoveItems write FOnRemoveItems;
    // OnUpdateItems is called whenever items in the list are updated. If AList
    // equals nil then all items are updated
    property OnUpdateItems: TListEvent read FOnUpdateItems write FOnUpdateItems;

    // AddBefore will chain the object before AItemList, using these steps:
    // - It sets itselfs Parent to AItemlist's Parent
    // - It sets AItemLists's Parent to itself.
    procedure AddBefore(AItemList: TItemMngr);
    // ArrangeItems arranges the list according to compare method and info fields and
    // sets the Sorted property to true. It works differently from "SortItems",
    // slower (NxN) but works for non-causal methods
    procedure ArrangeItems(ItemDifference: TItemDifferenceFunction;
      Info: pointer; DataPointer: TDataPointerFunction); virtual;
    // ClearItems will remove all items from the list and update all depending
    // lists and controls.
    procedure ClearItems(Sender: TObject); override;
    //
    procedure ClearSelection(SelectBit: TSelectBit);
    // CopyItems will put a copy of all of ItemLists items into AList. Creation and
    // destruction of AList is responsibility of the caller.
    procedure CopyItems(Sender: TObject; AList: TList); override;
    // Find returns true if the exact Item is found, and returns the index of the
    // item where it is, or if false, where it should be placed with Insert depending
    // on sort order. It uses a binary search algorithm (very fast). Find will
    // always check if Item is the exact item in the list (pointer match) before
    // returning True.
    function Find(Item: TObject; var Index: integer): boolean; virtual;
    // HasItem returns true if the item is found in the list.
    function HasItem(Item: TsdItem): boolean; virtual;
    // IndexOf returns the item's index or -1 if the item is not found. It uses
    // the default IndexOf of the list.
    function IndexOf(Item: TsdItem): integer; virtual;
    // Call Insert to insert a single item in the list and update all depending lists and
    // controls. Insert will put it in sorted position, unless Sorted is false.
    // Insert does not insert duplicates.
    procedure Insert(Item: TObject); virtual;
    // InsertItems will insert AList of new items into the existing list and update
    // all depending lists and controls. The items will be put into sorted position
    // unless Sorted is false. InsertItems does not insert duplicate pointers.
    procedure InsertItems(Sender: TObject; AList: TList); override;
    // Use ItemByGuid to get a pointer to an item of which you know the Guid.
    function ItemByGuid(const AGuid: TGUID): TsdItem; virtual;
    // Match returns true if it finds a matching Item according to the criteria
    // in OnCompare and CompareInfo. The resulting Index is the location where the
    // matching item was found. It uses a binary search algorithm (very fast).
    // Unlike Find the items do not have to be identical. Match does not work on
    // unsorted lists.
    function Match(AObject: TObject; var Index: integer): boolean;
    // RemoveItems will remove the items in AList from the Item List (if they are
    // present) and update all depending lists and controls.
    procedure RemoveItems(Sender: TObject; AList: TList); override;
    // Use the SetCompareMethod procedure to specify both the method OnCompare and
    // the info fields CompareInfo in one call.
    procedure SetCompareMethod(ACompare: TListSortCustomCompare; AInfo: pointer);
    // SortItems sorts the list according to compare method and info fields and
    // sets the Sorted property to true.
    procedure SortItems; virtual;
    // UpdateItems will do an update of the items in AList to reflect changes
    // that were made to them, and update all depending lists and controls.
    // If UpdateItems is called with AList=nil then all items will be updated.
    procedure UpdateItems(Sender: TObject; AList: TList); override;

  end;

const

  cDefaultBatchInsert = 1000;

  // Share of each filter of the cake (in %)
  cFilterShare = 60;

// DefaultListCompare is the standard compare function for two items. If no compare
// function is specified (Oncompare = nil) then this one will be used.
// It compares the Item IDs of both items.
function DefaultListCompare(Item1, Item2: TObject; Info: pointer): integer;

// Set the state for all items in AList
procedure SetStateForList(AList: TList; const AStates: TsdItemStates; AValue: boolean);

implementation

uses
  Compares, guiMain,

  Windows; // GetTickCount

// Debugging!
{$IFDEF DEBUGLOCKS}
var
  DebugStream: TStream;
  DebugLock: TCriticalSection;
{$ENDIF}

function DefaultListCompare(Item1, Item2: TObject; Info: pointer): integer;
begin
  // Equal types, so compare IDs
  if CompareGuid(TsdItem(Item1).Guid, TsdItem(Item2).Guid) < 0 then
    Result := -1
  else
    if CompareGuid(TsdItem(Item1).Guid, TsdItem(Item2).Guid) > 0 then
      Result := 1
    else
      Result := 0;
end;

procedure SetStateForList(AList: TList; const AStates: TsdItemStates; AValue: boolean);
// Set the state for all items in AList
var
  i: integer;
begin
  if not assigned(AList) then
    exit;
  for i := 0 to AList.Count - 1 do
    if TObject(AList[i]) is TsdItem then
      TsdItem(AList[i]).SetStates(AStates, AValue);
end;

{ TItemMngr }

procedure TItemMngr.DoBeginUpdate;
begin
  if (NestLevel = 0) then
    if assigned(FOnBeginUpdate) then
      FOnBeginUpdate(Self);
  LockWrite;
  try
    inc(FNestLevel);
  finally
    UnlockWrite;
  end;
end;

procedure TItemMngr.DoClearItems;
var
  i: integer;
begin
  // Do the clear for the nodes as well
  LockRead;
  try
    if assigned(FNodes) then
      for i:= 0 to FNodes.Count - 1 do
        if assigned(FNodes[i]) then
          TItemMngr(FNodes[i]).ClearItems(Self);
  finally
    UnlockRead;
  end;

  // Update notify events
  if (NestLevel = 1) then
    DoUpdate;

  // Call the OnClearItems event if any
  if assigned(FOnClearItems) then
    FOnClearItems(Self);

end;

procedure TItemMngr.DoEndUpdate;
begin
  if (NestLevel = 1) then
  begin
    DoUpdate;
    DoRangeUpdate;
    if assigned(FOnEndUpdate) then
      FOnEndUpdate(Self);
  end;
  LockWrite;
  try
    dec(FNestLevel);
  finally
    UnlockWrite;
  end;
end;

procedure TItemMngr.DoInsertItems(AList: TList);
var
  i: integer;
begin
  if (AList = nil) or (AList.Count = 0) then
    exit;

  // Call the OnInsertItems event if any
  if assigned(FOnInsertItems) then
    FOnInsertItems(Self, AList);

  // Update notify events
  if NestLevel = 0 then
    DoUpdate;

  // Do the insert for the nodes as well
  LockRead;
  try
    if assigned(FNodes) then
      for i:= 0 to FNodes.Count - 1 do
        if assigned(FNodes[i]) then
          TItemMngr(FNodes[i]).InsertItems(Self, AList);
  finally
    UnlockRead;
  end;
end;

procedure TItemMngr.DoRangeUpdate;
begin
  if assigned(FOnRangeUpdate) and (((FMaxRange >=0) and (FMinRange <= FMaxRange)) or (Count = 0)) then
    // Do the update
    FOnRangeUpdate(Self, FMinRange, FMaxRange);
  // Reset to -1
  FMaxRange := -1;
end;

procedure TItemMngr.DoRemoveItems(AList: TList);
var
  i: integer;
begin
  if (AList = nil) or (AList.Count = 0) then
    exit;

  // Do the remove for the nodes as well
  LockRead;
  try
    if assigned(FNodes) then
      for i:= 0 to FNodes.Count - 1 do
        if assigned(FNodes[i]) then
          TItemMngr(FNodes[i]).RemoveItems(Self, AList);
  finally
    UnlockRead;
  end;

  // Update notify events
  if NestLevel = 0 then
    DoUpdate;

  // Call the OnRemoveItems event if any
  if assigned(FOnRemoveItems) then
    FOnRemoveItems(Self, AList);
end;

procedure TItemMngr.DoUpdate;
begin
  if assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TItemMngr.DoUpdateItems(AList: TList);
var i: integer;
begin
  // Call the OnUpdateItems event if any
  if assigned(FOnUpdateItems) then
    FOnUpdateItems(Self, AList);

  // Update notify events
  if NestLevel = 0 then
    DoUpdate;

  // Do the update for the nodes as well
  LockRead;
  try
    if assigned(FNodes) then
      for i:= 0 to FNodes.Count - 1 do
        if assigned(FNodes[i]) then
          TItemMngr(FNodes[i]).UpdateItems(Self, AList);
  finally
    UnlockRead;
  end;
end;

function TItemMngr.GetCount: integer;
begin
  // We have no way of knowing in a TItemMngr! But this
  // is provided for compatibility
  Result := -1;
end;

function TItemMngr.GetIsRunning: boolean;
begin
  Result := False;
end;

function TItemMngr.GetName: string;
begin
  LockRead;
  try
    Result := FName;
  finally
    UnLockRead;
  end;
end;

function TItemMngr.GetNestLevel: integer;
begin
  LockRead;
  try
    Result := FNestLevel;
  finally
    UnLockRead;
  end;
end;

function TItemMngr.GetNodes: TList;
begin
  LockRead;
  try
    Result := FNodes;
  finally
    UnLockRead;
  end;
end;

function TItemMngr.GetParent: TItemMngr;
begin
  LockRead;
  try
    Result := FParent;
  finally
    UnlockRead;
  end;
end;

function TItemMngr.GetRoot: TItemList;
var
  ARoot: TItemMngr;
begin
  Result := nil;
  ARoot := Self;
  while assigned(ARoot.Parent) do
    ARoot := ARoot.Parent;
  if ARoot is TItemList then
    Result := TItemList(ARoot);
end;

procedure TItemMngr.SetName(AValue: string);
begin
  LockWrite;
  try
    FName := AValue;
  finally
    UnlockWrite;
  end;
end;

procedure TItemMngr.SetNestLevel(AValue: integer);
begin
  LockWrite;
  try
    FNestLevel := AValue;
  finally
    UnLockWrite;
  end;
end;

procedure TItemMngr.SetNodes(AValue: TList);
begin
  LockWrite;
  try
    FNodes := AValue;
  finally
    UnLockWrite;
  end;
end;

procedure TItemMngr.SetOnUpdate(AValue: TNotifyEvent);
begin
  FOnUpdate := AValue;
end;

procedure TItemMngr.SetParent(AValue: TItemMngr);
begin
  if Parent <> AValue then
  begin
    LockWrite;
    try

      // Set the pointer
      FParent := AValue;

    finally
      UnlockWrite;
    end;
  end;
end;

constructor TItemMngr.Create;
begin
  inherited Create;
  // Create the lock
  FLock := TMultiReadExclusiveWriteSynchronizer.Create;
  // Create the node list
  FNodes := TList.Create;
end;

destructor TItemMngr.Destroy;
begin
  // reset parent pointer
  FParent := nil;
  // Free instances
  FOnUpdate := nil;
  FOnRangeUpdate := nil;
  // free nodes
  if assigned(FNodes) then
    FreeAndNil(FNodes);
  // free lock
  if assigned(FLock) then
    FreeAndNil(FLock);
  inherited;
end;

procedure TItemMngr.AddNode(ANode: TItemMngr);
begin
  // Add to our node list
  LockWrite;
  try
    if assigned(FNodes) and assigned(ANode) then
      if FNodes.IndexOf(ANode) < 0 then
         FNodes.Add(ANode);
  finally
    UnlockWrite;
  end;
end;

procedure TItemMngr.AssignItems(Sender: TObject; AList: TList);
begin
  ClearItems(Self);
  InsertItems(Self, AList);
end;

procedure TItemMngr.ClearItems(Sender: TObject);
begin
  DoBeginUpdate;
  DoClearItems;
  DoEndUpdate;
end;

procedure TItemMngr.ConnectNode(ANode: TItemMngr);
begin
  if assigned(ANode) then
  begin
    // Set us as node's parent
    ANode.Parent := Self;
    // Add to our node list
    LockRead;
    try;
      if FNodes.IndexOf(ANode) < 0 then
      begin
        AddNode(ANode);
        // Build the node's items
        ANode.Execute;
      end;
    finally
      UnlockRead;
    end;
  end;
end;

procedure TItemMngr.CopyItems(Sender: TObject; AList: TList);
begin
  // Item Mngr does not have its own list so we must copy from parent
  LockRead;
  try
    if assigned(FParent) then
      FParent.CopyItems(Sender, AList);
  finally
    UnlockRead;
  end;
end;

procedure TItemMngr.Disconnect;
begin

  // Clear parent
  Parent := nil;

  // Clear connections
  FOnUpdate := nil;
  FOnRangeUpdate := nil;
  FOnBeginUpdate := nil;
  FOnEndUpdate := nil;
  FOnClearItems := nil;
  FOnInsertItems := nil;
  FOnRemoveItems := nil;
  FOnUpdateItems := nil;

  // Disconnect our nodes
  LockWrite;
  try
    if assigned(FNodes) then
      while FNodes.Count > 0 do
        if assigned(FNodes[0]) then
          DisconnectNode(FNodes[0])
        else
          Nodes.Delete(0);
  finally
    UnlockWrite;
  end;
end;

procedure TItemMngr.DisconnectAll;
var
  i: integer;
begin
  // Disconnect all the nodes
  for i := 0 to Nodes.Count - 1 do
    if assigned(Nodes[i]) then
      TItemMngr(Nodes[i]).DisconnectAll;
  // Now disconnect ourselves
  Disconnect;
end;

procedure TItemMngr.DisconnectAllNodes;
var
  i: integer;
begin
  // Disconnect all the nodes
  for i := 0 to Nodes.Count - 1 do
    if assigned(Nodes[i]) then
      TItemMngr(Nodes[i]).DisconnectAll;
end;

procedure TItemMngr.DisconnectNode(ANode: TItemMngr);
begin
  if assigned(ANode) then
  begin
    // Remove from our node list
    RemoveNode(ANode);
    // Reset node's parent
    ANode.Parent := nil;
    // Clear the node's items
    ANode.Execute;
  end;
end;

procedure TItemMngr.Execute;
var
  List: TList;
begin
  DoBeginUpdate;

  // This default method just copies the Parent's list
  LockRead;
  try
    if assigned(Parent) then
    begin
      List := TList.Create;
      try
        Parent.CopyItems(Self, List);
        AssignItems(Self, List);
      finally
        List.Free;
      end;
    end else
      ClearItems(Self);
  finally
    UnlockRead;
  end;
  DoEndUpdate;
end;

procedure TItemMngr.InsertItems(Sender: TObject; AList: TList);
begin
  DoBeginUpdate;
  DoInsertItems(AList);
  DoEndUpdate;
end;

procedure TItemMngr.LockRead;
{$IFDEF DEBUGLOCKS}
var
  Line: string;
{$ENDIF}
begin
{$IFDEF DEBUGLOCKS}
  DebugLock.Enter;
  inc(FLockCount);
  Line := Format('%.8x %s: LockRead Count=%d', [integer(Self), FName, FLockCount]) + #13#10;
  DebugStream.Write(Line[1], Length(Line));
  DebugLock.Leave;
{$ENDIF}
{$IFDEF USELOCKING}
  FLock.BeginRead;
{$ENDIF}
end;

procedure TItemMngr.LockWrite;
{$IFDEF DEBUGLOCKS}
var
  Line: string;
{$ENDIF}
begin
{$IFDEF DEBUGLOCKS}
  DebugLock.Enter;
  inc(FLockCount);
  Line := Format('%.8x %s: LockWrite Count=%d', [integer(Self), FName, FLockCount]) + #13#10;
  DebugStream.Write(Line[1], Length(Line));
  DebugLock.Leave;
{$ENDIF}
{$IFDEF USELOCKING}
  FLock.BeginWrite;
{$ENDIF}
end;

procedure TItemMngr.ReadComponents(S: TStream);
begin
// default does nothing
end;

procedure TItemMngr.ReadFromStream(S: TStream);
var
  Len: longint;
  Stream: TStream;
begin
  StreamReadInteger(S, Len);
  Stream:=TMemoryStream.Create;
  try
    Stream.CopyFrom(S, Len);
    Stream.Seek(0, soFromBeginning);
    ReadComponents(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TItemMngr.Remove(Item: TsdItem);
var
  AList: TList;
begin
  // Create our update list
  AList := TList.Create;
  try

    // Add the remove item
    AList.Add(Item);

    // Call RemoveItems
    RemoveItems(Self, AList);

  finally
    AList.Free;
  end;
end;

procedure TItemMngr.RemoveItems(Sender: TObject; AList: TList);
begin
  DoBeginUpdate;
  DoRemoveItems(AList);
  DoEndUpdate;
end;

procedure TItemMngr.RemoveNode(ANode: TItemMngr);
begin
  LockWrite;
  try
    // Check if we have it
    if assigned(FNodes) and assigned(ANode) then
      // And remove the reference
      FNodes.Remove(ANode);
  finally
    UnlockWrite;
  end;
end;

procedure TItemMngr.SetNode(ANode: TItemMngr);
var
  i: integer;
begin
  i := 0;
  LockWrite;
  try
    if assigned(FNodes) and assigned(ANode) then
    begin
      // Remove all other nodes
      while i < FNodes.Count do
        if FNodes[i] <> ANode then
          RemoveNode(FNodes[i])
        else
          inc(i);
      // Add it if not already there
      if (FNodes.Count = 0) then
        FNodes.Add(ANode);
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TItemMngr.UnlockRead;
{$IFDEF DEBUGLOCKS}
var
  Line: string;
{$ENDIF}
begin
{$IFDEF DEBUGLOCKS}
  DebugLock.Enter;
  Line := Format('%.8x %s: UnLockRead Count=%d', [integer(Self), FName, FLockCount]) + #13#10;
  dec(FLockCount);
  DebugStream.Write(Line[1], Length(Line));
  DebugLock.Leave;
{$ENDIF}
{$IFDEF USELOCKING}
  FLock.EndRead;
{$ENDIF}
end;

procedure TItemMngr.UnLockWrite;
{$IFDEF DEBUGLOCKS}
var
  Line: string;
{$ENDIF}
begin
{$IFDEF DEBUGLOCKS}
  DebugLock.Enter;
  Line := Format('%.8x %s: UnLockWrite Count=%d', [integer(Self), FName, FLockCount]) + #13#10;
  dec(FLockCount);
  DebugStream.Write(Line[1], Length(Line));
  DebugLock.Leave;
{$ENDIF}
{$IFDEF USELOCKING}
  FLock.EndWrite;
{$ENDIF}
end;

procedure TItemMngr.UpdateItems(Sender: TObject; AList: TList);
begin
  DoBeginUpdate;
  DoUpdateItems(AList);
  DoEndUpdate;
end;

procedure TItemMngr.WriteComponents(S: TStream);
begin
// default does nothing
end;

procedure TItemMngr.WriteToStream(S: TStream);
var
  Len: integer;
  Stream: TStream;
begin
  Stream:=TMemoryStream.Create;
  try
    WriteComponents(Stream);
    Len:=Stream.Position;
    Stream.Seek(0,soFromBeginning);
    StreamWriteInteger(S,Len);
    S.CopyFrom(Stream,Len);
  finally
    Stream.Free;
  end;
end;

{*procedure TItemMngr.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle;
  const AMessage: Utf8String);
begin
//todo
end;*)

{ TItemList }

procedure TItemList.ActionProgress(ANum, ADen: integer);
var
  Count: integer;
  Percent: double;
  ActionFmt, ActionMsg: string;
begin
  // Action progress
  case ActionType of
    atInsert:
      begin
        ActionFmt := 'Inserting %d items';
        Count := ANum;
      end;
    atUpdate:
      begin
        ActionFmt := 'Updating %d items';
        Count := ANum;
      end;
    atRemove:
      begin
        ActionFmt := 'Removing %d items';
        Count := ANum;
      end;
    atClear:
      begin
        ActionFmt := 'Clearing %d items';
        Count := ADen;
      end;
    atSort:
      begin
        ActionFmt := 'Sorting %d items';
        Count := ADen;
      end;
    atFilter:
      begin
        ActionFmt := 'Filtering %d items';
        Count := ADen;
      end;
    atDelete:
      begin
        ActionFmt := 'Deleting %d items';
        Count := ANum;
      end;
    atExpand:
      begin
        ActionFmt := 'Expanding %d items';
        Count := ANum;
      end;
  else
    ActionFmt := 'Processing %d items ';
    Count := ADen;
  end;// case

  ActionMsg := Format(ActionFmt, [Count]);

  // Sort Method
  if assigned(SortMethod) and (SortMethod.Count > 0) and
     (FActionType in [atInsert, atUpdate, atSort]) and
     (length(SortMethod.Description[0]) > 0) then
    ActionMsg := Format('%s by %s',
      [ActionMsg, SortMethod.Description[0]]);

  // Filter Name
  if (length(Name) > 0) then
    ActionMsg := Format('%s in %s',[ActionMsg, Name]);

  if ADen > 0 then
    Percent := ANum / ADen * 100
  else
    Percent := 100;

  if assigned(Root) then
    Root.DoActionProgress(ActionMsg, Percent);
end;

procedure TItemList.DoActionProgress(AMsg: string; APercent: double);
begin
  if assigned(FOnActionProgress) then
    FOnActionProgress(Self, AMsg, APercent);
end;

procedure TItemList.DoProgress(var Tick: cardinal; Num, Den: integer);
var
  ANewTick, AInterval: cardinal;
begin
  ANewTick := GetTickCount;
  AInterval := ANewTick - Tick;

  if AInterval >= cProgressInterval then
  begin
    Tick := ANewTick;
    if assigned(FOnProgress) and (Den > 0) then
      FOnProgress(Self, Num/Den * 100);

    // Action progress
    ActionProgress(Num, Den);

  end;
end;

procedure TItemList.DoUpdateItems(AList: TList);
begin
  if Count = 0 then
    exit;
  inherited;
end;

procedure TItemList.EndProgress(ADen: integer);
begin
  if assigned(FOnProgress) then
    FOnProgress(Self, 100);
  // Action progress
  ActionProgress(ADen, ADen);
end;

procedure TItemList.ExtractAt(AIndex: integer);
begin
  // workaround for missing extract-at function
  LockWrite;
  try
    if FItems is TObjectList then
    begin
      with TObjectList(FItems) do
      begin
        OwnsObjects := False;
        Delete(AIndex);
        OwnsObjects := True;
      end;
    end else
      FItems.Delete(AIndex);
  finally
    UnlockWrite;
  end;
end;

procedure TItemList.ExtractItemsFromList(AList, NextList: TList; Tick: dword);

// This procedure will extract the items in Extract from Source using an efficient
// algorithm with packing. MinIndex and MaxIndex will be set as the interval where
// changes took place

var
  i, Index, Delta: integer;
  Sorted: TSortedList;
begin
  if not assigned(FItems) then
    exit;
  Sorted := TSortedList.Create(False);
  Sorted.Capacity := AList.Count;
  try
    // Disable Ownsobjects
    if FItems is TObjectList then
      TObjectList(FItems).OwnsObjects := False;

    // Copy (and sort)
    for i := 0 to AList.Count - 1 do
      Sorted.Add(AList[i]);

    // Check in a different dimension
    i := 0;
    while i < FItems.Count do
    begin
      DoProgress(Tick, i, Count);
      if assigned(FItems[i]) and Sorted.Find(FItems[i], Index) then
      begin
        NextList.Add(FItems[i]);
        FItems[i] := nil;
      end;
      inc(i);
    end;

    // Our own packing algorithm
    Index := 0;
    Delta := 0;
    while Index + Delta < FItems.Count do
    begin
      if assigned(FItems[Index + Delta]) then
      begin
        FItems[Index] := FItems[Index + Delta];
        inc(Index);
      end else
      begin
        inc(Delta);
        // Determine first updated position
        if Delta = 1 then
          FMinRange := Index;
      end;
    end;
    for i := Index to Count - 1 do
      FItems[i] := nil;
    FItems.Count := Index;

    // Enable Ownsobjects
    if FItems is TObjectList then
       TObjectList(FItems).OwnsObjects := True;

    // Last updated position
    if Delta > 0 then
      FMaxRange := FItems.Count - 1;

  finally
    Sorted.Free;
  end;
end;

function TItemList.GetActionType: TActionType;
begin
  LockRead;
  try
    Result := FActionType;
  finally
    UnlockRead;
  end;
end;

procedure TItemList.GetCompareMethod(var ACompare: TListSortCustomCompare; var AInfo: pointer);
begin
  LockRead;
  try
    if assigned(FOnCompare) then
    begin
      ACompare := FOnCompare;
      AInfo    := FCompareInfo;
    end else
    begin
      ACompare := DefaultListCompare;
      AInfo    := nil;
    end;
  finally
    UnlockRead;
  end;
end;

function TItemList.GetCount: integer;
begin
  Result := 0;
  LockRead;
  try
    if assigned(FItems) then
      Result := FItems.Count;
  finally
    UnLockRead;
  end;
end;

function TItemList.GetItems(Index: integer): TsdItem;
begin
  Result := nil;
  LockRead;
  try
    if assigned(FItems) and (Index >= 0) and (Index < FItems.Count) then
      Result := TsdItem(FItems[Index]);
  finally
    UnLockRead;
  end;
end;

function TItemList.GetOwnsObjects: boolean;
begin
  LockRead; try
    Result := FOwnsObjects;
  finally UnLockRead; end;
end;

function TItemList.GetSorted: boolean;
begin
  LockRead;
  try
    Result := FSorted;
  finally
    UnLockRead;
  end;
end;

function TItemList.GetSortMethod: TSortMethod;
begin
  LockRead;
  try
    Result := FSortMethod;
  finally
    UnLockRead;
  end;
end;

procedure TItemList.SetActionType(AValue: TActionType);
begin
  LockWrite;
  try
    FActionType := AValue;
  finally
    UnLockWrite;
  end;
end;

procedure TItemList.SetCompareInfo(AValue: pointer);
begin
  if FCompareInfo <> AValue then
  begin
    LockWrite;
    try
      FCompareInfo := AValue;
    finally
      UnLockWrite;
    end;
    SortItems;
  end;
end;

procedure TItemList.SetItems(Index: integer; Item: TsdItem);
begin
  LockWrite;
  try
    if assigned(FItems) and (FItems.Count > Index) then
      FItems[Index] := Item;
  finally
    UnLockWrite;
  end;
end;

procedure TItemList.SetOnCompare(AValue: TListSortCustomCompare);
begin
  if @FOnCompare <> @AValue then
  begin
    LockWrite;
    try
      FOnCompare := AValue;
      SortItems;
    finally
      UnLockWrite;
    end;
  end;
end;

procedure TItemList.SetOwnsObjects(AValue: boolean);
begin
  LockWrite;
  try
    FOwnsObjects := AValue;
  finally
    UnLockWrite;
  end;
end;

procedure TItemList.SetSorted(AValue: boolean);
begin
  if AValue <> Sorted then
  begin
    if AValue then
      // Sort the list
      SortItems;
    LockWrite;
    try
      FSorted := AValue;
    finally
      UnLockWrite;
    end;
  end;
end;

procedure TItemList.SetSortMethod(AValue: TSortMethod);
begin
  if AValue <> SortMethod then
  begin
    SetCompareMethod(CompareItems, AValue);
    LockWrite;
    try
      if assigned(FSortMethod) then
        FreeAndNil(FSortMethod);
      FSortMethod := AValue;
    finally
      UnLockWrite;
    end;
  end;
end;

procedure TItemList.SortProgress(Sender: TObject; APercent: double);
begin
  // Estimate ANum
  ActionProgress(round(APercent*Count/100), Count);
  if assigned(FOnProgress) then
    FOnProgress(Self, APercent);
end;

function TItemList.StartProgress: dword;
begin
  if assigned(FOnProgress) then
    FOnProgress(Self, 0);
  Result:= GetTickCount;
end;

constructor TItemList.Create(AOwnsObjects: boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;

  // Create the object list
  FItems := TObjectList.Create(FOwnsObjects);

  // Sorted by default
  FSorted := True;

  FBatchInsert := cDefaultBatchInsert;
end;

destructor TItemList.Destroy;
begin
  // Onxxx events
  FOnBeginUpdate := nil;
  FOnEndUpdate   := nil;
  FOnClearItems  := nil;
  FOnInsertItems := nil;
  FOnRemoveItems := nil;
  FOnUpdateItems := nil;
  FOnUpdate := nil;
  FOnRangeUpdate := nil;

  // Free instances
  LockWrite;
  try
    if assigned(FItems) then
      FreeAndNil(FItems);
    if assigned(FSortMethod) then
      FreeAndNil(FSortMethod);
  finally
    UnlockWrite;
  end;
  inherited;
end;

procedure TItemList.AddBefore(AItemList: TItemMngr);
begin
  if assigned(AItemList) then
  begin
    Parent := AItemList.Parent;
    AItemList.Parent := Self;
  end;
end;

procedure TItemList.ClearItems(Sender: TObject);
var
  TempList, OldItems: TObjectList;
begin
  DoBeginUpdate;
  // Get a lock
  LockWrite;
  try

    TempList := TObjectList.Create(False);
    try
      // "Hide" the items
      OldItems := FItems;
      FItems := TempList;

      // We must remove the lock here to ensure that our
      // nodes can work with the list
      UnLockWrite;
      try
        // Update the nodes
        DoClearItems;
      finally
        LockWrite;
      end;

      // Now clear the items
      FItems := OldItems;
      FItems.Clear;

    finally
      TempList.Free;
    end;

  finally
    UnlockWrite;
  end;
  DoEndUpdate;
end;

procedure TItemList.ClearSelection(SelectBit: TSelectBit);
var
  i: integer;
begin
  try
    LockRead;
    try
      if assigned(FItems) then
        for i:= 0 to FItems.Count - 1 do
          TsdItem(FItems[i]).IsSelected[SelectBit] := false;
    finally
      UnlockRead;
    end;
  except
    //DoDebugOut(Self, wsFail, 'Exception during "clear selection"');
  end;
end;

procedure TItemList.CopyItems(Sender: TObject; AList: TList);
var
  i: integer;
begin
  // Copy all items to AList
  LockRead;
  try
    if assigned(AList) and assigned(FItems) then
    begin
      AList.Capacity := FItems.Count;
      AList.Clear;
      if assigned(FItems) then
        for i := 0 to FItems.Count - 1 do
          AList.Add(FItems[i]);
    end;
  finally
    UnLockRead;
  end;
end;

function TItemList.Find(Item: TObject; var Index: integer): boolean;
var
  ACompare: TListSortCustomCompare;
  AInfo: pointer;
  TempIndex: integer;
  Sorter: TsdSorter;
begin
  Index  := 0;
  Result := false;
  if not assigned(Item) then
    exit;

  LockRead;
  try;
    if not assigned(FItems) then
      exit;
    if FSorted then
    begin

      // Set the compare method
      GetCompareMethod(ACompare, AInfo);

      // Try to find the item in the list by binary search
      Sorter := TsdSorter.Create;
      try
        Result := Sorter.ListCustomFind(FItems, TsdItem(Item), AInfo, Index, ACompare);
      finally
        Sorter.Free;
      end;

      // In case of duplicates
      if Result and not (FItems[Index] = Item) then
      begin

        // Check all duplicates for a match in pointers
        Result := false;

        // Check negative direction
        TempIndex := Index;
        repeat
          if FItems[TempIndex] = Item then
          begin
            Result := true;
            Index := TempIndex;
            exit;
          end;
          dec(TempIndex);
        until (TempIndex < 0) or (ACompare(FItems[TempIndex], Item, AInfo) <> 0);

        // Check positive direction
        TempIndex := Index;
        repeat
          if FItems[TempIndex] = Item then
          begin
            Result := true;
            Index := TempIndex;
            exit;
          end;
          inc(TempIndex);
        until (TempIndex >= FItems.Count) or (ACompare(FItems[TempIndex], Item, AInfo) <> 0);

      end;

    end else
    begin

      // Not a sorted list; use default TList.IndexOf
      Index := FItems.IndexOf(Item);
      Result := (Index >= 0);
      // Place new items at the end of the list
      if not Result then
        Index := FItems.Count;

    end;
  finally
    UnLockRead;
  end;
end;

function TItemList.HasItem(Item: TsdItem): boolean;
var
  Index: integer;
begin
  Result := Find(Item, Index);
end;

function TItemList.IndexOf(Item: TsdItem): integer;
begin
  Result := -1;
  LockRead;
  try
    if assigned(FItems) then
      Result := FItems.IndexOf(Item);
  finally
    UnlockRead;
  end;
end;

procedure TItemList.Insert(Item: TObject);
var
  AList: TList;
begin
  // Create our update list
  AList := TList.Create;
  try

    // Add the item
    AList.Add(Item);

    // Call InsertItems
    InsertItems(Self, AList);

  finally
    AList.Free;
  end;
end;

procedure TItemList.InsertItems(Sender: TObject; AList: TList);
var
  i, Index: integer;
  Tick: dword;
  NextList: TList;
begin
  if (AList = nil) or (AList.Count = 0) then
    exit;

  FActionType := atInsert;
  DoBeginUpdate;
  NextList := TList.Create;
  try
    NextList.Capacity := AList.Count;
    Tick := StartProgress;

    if (BatchInsert > 0) and (AList.Count > BatchInsert) then
    begin
      // Batch insert mode

      // Get a lock
      LockWrite;
      try
        if not assigned(FItems) then
          exit;
        // Add the items blindly at the end
        FItems.Capacity := FItems.Count + AList.Count;

        for i := 0 to AList.Count - 1 do
        begin
          DoProgress(Tick, i, AList.Count);
          // No dupe checking!
          FItems.Add(AList[i]);
          NextList.Add(AList[i]);
        end;

        FItems.Capacity := FItems.Count;

      finally
        UnLockWrite;
      end;

      // Now sort the list again
      SortItems;

    end else
    begin
      // Single insert mode

      // Get a lock
      LockWrite;
      try
        if not assigned(FItems) then
          exit;

        // Add the items in the correct position
        for i := 0 to AList.Count - 1 do
        begin
          DoProgress(Tick, i, AList.Count);
          if not Find(AList[i], Index) then
          begin
            // Determine first updated position
            if NextList.Count = 0 then
              FMinRange := Index
            else
              FMinRange := Min(Index, FMinRange);
            // Insert the item
            FItems.Insert(Index, AList[i]);
            // And add it to the next list
            NextList.Add(AList[i]);
          end;
        end;

        // Last updated position
        if NextList.Count > 0 then
          FMaxRange := FItems.Count - 1;

      finally
        UnlockWrite;
      end;
    end;

    // Now we can update the nodes
    DoInsertItems(NextList);

  finally
    EndProgress(AList.Count);
    NextList.Free;
    DoEndUpdate;
  end;
end;

function TItemList.ItemByGuid(const AGuid: TGUID): TsdItem;
var
  Index: integer;
  Temp: TsdItem;
begin
  Result := nil;
  LockRead;
  try
    if not assigned(FItems) then
      exit;
    if (@FOnCompare = @DefaultListCompare) or (@FOncompare = nil) then
    begin
      Temp := TsdItem.Create;
      try
        Temp.SetGuid(AGuid);
        Find(Temp, Index);
        if (Index >= 0) and (Index < FItems.Count) and
           (CompareGuid(TsdItem(FItems[Index]).Guid, AGuid) = 0) then
          Result := TsdItem(FItems[Index]);
      finally
        Temp.Free;
      end;
    end else
    begin
      Index := 0;
      while Index < FItems.Count do
      begin
        if IsEqualGuid(TsdItem(FItems[Index]).Guid, AGuid) then
        begin
          Result := TsdItem(FItems[Index]);
          break;
        end;
        inc(Index);
      end;
    end;
  finally
    UnlockRead;
  end;
end;

function TItemList.Match(AObject: TObject; var Index: integer): boolean;
var
  ACompare: TListSortCustomCompare;
  AInfo: pointer;
  Sorter: TsdSorter;
begin
  Index  := 0;
  Result := false;
  if not assigned(AObject) then
    exit;
  if Sorted then
  begin
    LockRead;
    try
      // Set the compare method
      GetCompareMethod(ACompare, AInfo);

      // Try to find the item in the list by binary search
      Sorter := TsdSorter.Create;
      try
        Result := Sorter.ListCustomFind(FItems, TsdItem(AObject), AInfo, Index, ACompare);
      finally
        Sorter.Free;
      end;

    finally
      UnLockRead;
    end;
  end;
end;

procedure TItemList.RemoveItems(Sender: TObject; AList: TList);
var
  Tick: dword;
  NextList: TList;
begin
  if (AList = nil) or (AList.Count = 0) then
    exit;
  ActionType := atRemove;
  DoBeginUpdate;

  // Create list for nodes
  // Free the extracted objects if we own them
  if OwnsObjects then
    NextList := TObjectList.Create
  else
    NextList := TList.Create;

  try
    NextList.Capacity := AList.Count;
    Tick := StartProgress;

    LockWrite;
    try
      ExtractItemsFromList(AList, NextList, Tick);
    finally
      UnLockWrite;
    end;

    if (BatchInsert > 0) and (AList.Count > BatchInsert) then
    begin

      // Batch remove mode - remove items from our list,
      // and clear + insert list to nodes
      DoClearItems;
      LockRead; try
        DoInsertItems(FItems);
      finally UnLockRead; end;

    end else
    begin

      // Update the nodes
      DoRemoveItems(NextList);

    end;

  finally
    EndProgress(AList.Count);
    NextList.Free;
  end;

  DoEndUpdate;
end;

procedure TItemList.SetCompareMethod(ACompare: TListSortCustomCompare; AInfo: pointer);
begin
  LockWrite;
  try
    if (@FOnCompare <> @ACompare) or (FCompareInfo <> AInfo) then
    begin
      FOncompare   := ACompare;
      FCompareInfo := AInfo;
      SortItems;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TItemList.ArrangeItems(ItemDifference: TItemDifferenceFunction;
  Info: pointer; DataPointer: TDataPointerFunction);
// ArrangeItems will arrange the itemlist by looking for differences between
// one item and the next, finding the minimum difference in the resulting list.
// ItemDifference is a TItemDifferenceFunction that will calculate the difference
// (positive integer) between Item1 and Item2. It takes Data1 and Data2 pointers
// optionally. These are generated by DataPointer (TDataPointerFunction)
var
  Sorter: TsdSorter;
begin
  // Make sure this is a sorted list
  FSorted := true;
  if Count = 0 then
    exit;

  ActionType := atSort;
  DoBeginUpdate;
  try

    // Sort the list
    FMinRange := 0;
    FMaxRange := Count - 1;

    // Call the custom arrange function
    Sorter := TsdSorter.Create;
    try
      Sorter.ListCustomArrange(FItems, @ItemDifference, Info, @DataPointer, SortProgress);
    finally
      Sorter.Free;
    end;

    // Complete list has changed, signal this
    if NestLevel = 1 then
      DoUpdateItems(nil);
  finally
    DoEndUpdate;
  end;
end;

procedure TItemList.SortItems;
var
  ACompare: TListSortCustomCompare;
  AInfo: pointer;
  Sorter: TsdSorter;
begin
  // Make sure this is a sorted list
  LockWrite;
  try
    FSorted := true;
  finally
    UnlockWrite;
  end;

  if Count = 0 then
    exit;

  ActionType := atSort;
  DoBeginUpdate;
  try

    // Set the compare method
    GetCompareMethod(ACompare, AInfo);

    // Test if we need to sort or not
    if (@ACompare = @CompareItems) and assigned(AInfo) and
       (TSortMethod(AInfo).Method[0] in [smNoSort, smRandom]) then
    begin
      // No sorting needed
      LockWrite;
      try
        FSorted := False;
      finally
        UnlockWrite;
      end;

    end else
    begin
      LockWrite;
      try

        // Sort the list
        FMinRange := 0;
        FMaxRange := Count - 1;
        Sorter := TsdSorter.Create;
        try
          Sorter.ListCustomSort(FItems, AInfo, ACompare, SortProgress);
        finally
          Sorter.Free;
        end;

      finally
        UnLockWrite;
      end;

      // Complete list has changed, signal this
      if NestLevel = 1 then
        DoUpdateItems(nil);
    end;
  finally
    DoEndUpdate;
  end;
end;

procedure TItemList.UpdateItems(Sender: TObject; AList: TList);
var
  i, OldIndex, NewIndex: integer;
  Tick: dword;
  NextList: TList;
begin
  if (AList = nil) or (AList.Count > BatchInsert) then
  begin

    // Update ALL items
    SortItems;

  end else
  begin

    // Update items in the list
    if (AList.Count = 0) then
      exit;
    ActionType := atUpdate;
    DoBeginUpdate;

    // Create list for nodes
    NextList := TList.Create;
    try
      NextList.Capacity := AList.Count;
      Tick := StartProgress;

      // Get a lock
      LockWrite;
      try
        if not assigned(FItems) then
          exit;

        // Locate the item
        for i := 0 to AList.Count - 1 do
        begin
          DoProgress(Tick, i, AList.Count);

          // Extract it and then re-insert it.
          OldIndex := FItems.IndexOf(AList[i]);
          if OldIndex >= 0 then
          begin
            ExtractAt(OldIndex);
            Find(AList[i], NewIndex);
            FItems.Insert(NewIndex, AList[i]);
            if NextList.Count = 0 then
            begin
              FMinRange := Min(OldIndex, NewIndex);
              FMaxRange := Max(OldIndex, NewIndex);
            end else
            begin
              FMinRange := Min(NewIndex, Min(OldIndex, FMinRange));
              FMaxRange := Max(NewIndex, Max(OldIndex, FMaxRange));
            end;
            NextList.Add(AList[i]);
          end;
        end;

      finally
        UnLockWrite;
      end;

      // Now we can update the nodes
      DoUpdateItems(NextList);

    finally
      EndProgress(AList.Count);
      NextList.Free;
    end;

    DoEndUpdate;
  end;
end;

// Debugging!
{$IFDEF DEBUGLOCKS}
initialization
  DebugStream := TFileStream.Create('c:\temp\debug.txt', fmCreate or fmShareDenyWrite);
  DebugLock := TCriticalSection.Create;

finalization
  FreeAndNil(DebugStream);
  FreeAndNil(DebugLock);
{$ENDIF}

end.

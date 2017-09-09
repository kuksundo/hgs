{ unit ThreadedFilters

  A special filter class that works in a threaded fashion

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit ThreadedFilters;

interface

uses
  Windows, SysUtils, Dialogs, Classes, Contnrs, SyncObjs, ItemLists, Filters,
  sdItems, sdProcessThread, sdSortedLists, Expanders, sdAbcTypes, sdAbcVars;

type

  TThreadedFilter = class;

  // TFilterThread is used in TThreadedFilter internally to run a threaded filtering
  // scheme.
  TFilterThread = class(TProcess)
  private
    FCount: integer;
    FFilter: TThreadedFilter;
    FSkipUpdates: boolean;
    FMessage: string;
    FReset: boolean;
    FTick: dword;
  protected
    procedure ClearFilteredItems;
    procedure DoProgress;
    procedure DoSyncStatusMessage;
    procedure EndProgress;
    procedure Run; override;
    procedure RunFilter;
    procedure FlushFilteredItems;
    procedure PostProcess;
    procedure StartProgress;
    procedure UnsyncPostProcess;
  public
    procedure DoStatusMessage(AMessage: string);
    // Set SkipUpdates = True to avoid intermediate updates after update interval
    property SkipUpdates: boolean read FSkipUpdates write FSkipUpdates;
  end;

  // TThreadedFilter ensures that whenever an item is added to/removed from the parent,
  // each item in the list is eventually re-evaluated by a call to AcceptItem.
  // This works with a thread so that control returns directly from calls to InsertItems
  // etc.
  TThreadedFilter = class(TFilter)
  private
    FThread: TFilterThread;
    FLock: TCriticalSection; // protects FInserts, FRemoves
    FOnPostProcess: TNotifyEvent;
    FOnUnsyncPostProcess: TNotifyEvent;
    FSkipUpdates: boolean;
  protected
    FInserts: TList;
    FRemoves: TList;
    function GetIsRunning: boolean; override;
    procedure Restart;
    procedure SetParent(AValue: TItemMngr); override;
  public
    // Create will construct an instance of a TThreadedFilter.
    // Each item in the parent list is eventually re-evaluated by a call to AcceptItem.
    constructor Create;
    destructor Destroy; override;
    // AddInsertItem is a threadsafe procedure to insert an item during
    // filter operation. It will be inserted when the thread is doing
    // a synchronized call to FlushFilteredItems.
    procedure AddInsertItem(AItem: TsdItem); virtual;
    // AddRemoveItem is a threadsafe procedure to remove an item during
    // filter operation. It will be removed when the thread is doing
    // a synchronized call to FlushFilteredItems.
    procedure AddRemoveItem(AItem: TsdItem); virtual;
    procedure ClearFilteredItems; virtual;
    procedure ClearItems(Sender: TObject); override;
    procedure Disconnect; override;
    procedure Execute; override;
    // FlushFilteredItems will flush all accumulated changes to the controls and
    // the depending filters. It is periodically called by the filter thread.
    procedure FlushFilteredItems; virtual;
    procedure InsertItems(Sender: TObject; AList: TList); override;
    procedure PostProcess; virtual;
    procedure RemoveItems(Sender: TObject; AList: TList); override;
    procedure StartThread;
    procedure StopThread;
    procedure UnsyncPostProcess; virtual;
    procedure UnsyncStatusMessage(AMessage: string);
    function UnsyncTerminated: boolean;
    procedure UpdateItems(Sender: TObject; AList: TList); override;
    property OnPostProcess: TNotifyEvent read FOnPostProcess write FOnPostProcess;
    property OnUnsyncPostProcess: TNotifyEvent read FOnUnsyncPostProcess write FOnUnsyncPostProcess;
    property SkipUpdates: boolean read FSkipUpdates write FSkipUpdates;
  end;

  // TChainFilter implements a scheme where multiple filters are cascaded
  // but the total looks just like one filter. Add filters with AddFilter,
  // and access their properties with Filters[Index]. FilterCount is the
  // number of filters in the total
  TChainFilter = class(TItemMngr)
  private
    FFilters: TObjectList;
  protected
    function GetCount: integer; override;
    function GetFilters(AIndex: integer): TItemMngr; virtual;
    function GetFilterCount: integer; virtual;
    function GetNodes: TList; override;
    function  GetParent: TItemMngr; override;
    function GetRoot: TItemList; override;
    procedure SetOnUpdate(AValue: TNOtifyEvent); override;
    procedure SetParent(AValue: TItemMngr); override;
    // AddFilter will add AFilter to the end of the filter list
    procedure AddFilter(AFilter: TItemMngr);
    // InsertFilter will add AFilter to the filter list on position
    // AIndex. Use AIndex = 0 for first position, AIndex = FilterCount
    // for last position.
    procedure InsertFilter(AIndex: integer; AFilter: TItemMngr);
    property FilterCount: integer read GetFilterCount;
  public
    constructor Create;
    destructor Destroy; override;
    // Use AddNode to add a child Itemlist in the chain
    procedure AddNode(ANode: TItemMngr); override;
    //
    procedure ClearItems(Sender: TObject); override;
    procedure ConnectNode(ANode: TItemMngr); override;
    // CopyItems will put a copy of all of the ItemMngr parent's items into AList.
    // Creation and destruction of AList is responsibility of the caller.
    procedure CopyItems(Sender: TObject; AList: TList); override;
    procedure Disconnect; override;
    procedure DisconnectNode(ANode: TItemMngr); override;
    // Execute is called whenever it is neccesary to re-assign the items from
    // the parent. Do not call Execute directly, but use Update(nil) instead.
    procedure Execute; override;
    procedure InsertItems(Sender: TObject; AList: TList); override;
    procedure LockRead; override;
    procedure LockWrite; override;
    procedure RemoveItems(Sender: TObject; AList: TList); override;
    // Use RemoveNode to remove a child Itemlist from the chain
    procedure RemoveNode(ANode: TItemMngr); override;
    // Use SetNode instead of AddNode to make sure that the node added
    // is the exclusive output of this filter
    procedure SetNode(ANode: TItemMngr); override;
    procedure UnlockRead; override;
    procedure UnlockWrite; override;
    procedure UpdateItems(Sender: TObject; AList: TList); override;
    property Filters[Index: integer]: TItemMngr read GetFilters;
  end;

implementation

uses
  guiMain, sdRoots;

{ TThreadedFilter }

procedure TThreadedFilter.Disconnect;
begin
  // Stop the thread now
  StopThread;
  // Clear the buffer
  ClearFilteredItems;
  // And disconnect all
  inherited;
end;

procedure TThreadedFilter.Execute;
begin
  if assigned(Parent) then begin
    if not assigned(FThread) then
      // Create & start the thread if not yet done so
      StartThread
    else
      // Restart the thread
      Restart;
  end;
end;

function TThreadedFilter.GetIsRunning: boolean;
begin
  Result := False;
  if assigned(FThread) then
    Result := FThread.Status = psRun;
end;

procedure TThreadedFilter.Restart;
begin
  if assigned(FThread) then begin
    FlushFilteredItems;
    FThread.FReset := True;
    FThread.Status := psRun;
  end;
end;

procedure TThreadedFilter.SetParent(AValue: TItemMngr);
begin
  if (AValue <> Parent) then begin
    StopThread;
    FlushFilteredItems;
    // This will cause the parent to be assigned in the proper way
    // and the thread to be restarted (due to 'Execute' in ancestor)
    inherited SetParent(AValue);
  end;
end;

procedure TThreadedFilter.StartThread;
begin
  // Stop it first, if it is running
  if assigned(FThread) then
    StopThread;

  // Create thread but leave it suspended for now
  FThread := TFilterThread.Create(True, glProcessList);
  // This must be documented - a TThreadedFilter cannot have a virtual parent
  FThread.FFilter := Self;
  // Reassign name
  FThread.Name := format('%s filter', [Name]);
  FThread.SkipUpdates := SkipUpdates;
  // Once set, run it
  FThread.Priority := tpNormal;
  FThread.Resume;
end;

procedure TThreadedFilter.StopThread;
begin
  if assigned(FThread) then
    FThread.Terminate;
  FThread := nil;
end;

constructor TThreadedFilter.Create;
begin
  inherited Create;
  // Inserting in a duplexfilter should be item by item.
  BatchInsert := 0;

  // Create insert/remove/update list buffers
  FInserts := TList.Create;
  FRemoves := TList.Create;
  FLock := TCriticalSection.Create;
end;

destructor TThreadedFilter.Destroy;
begin
  StopThread;

  FreeandNil(FRemoves);
  FreeandNil(FInserts);
  FreeAndNil(FLock);

  inherited;
end;

procedure TThreadedFilter.AddInsertItem(AItem: TsdItem);
begin
  FLock.Enter;
  if assigned(AItem) then FInserts.Add(AItem);
  FLock.Leave;
end;

procedure TThreadedFilter.AddRemoveItem(AItem: TsdItem);
begin
  FLock.Enter;
  if assigned(AItem) then FRemoves.Add(AItem);
  FLock.Leave;
end;

procedure TThreadedFilter.ClearFilteredItems;
begin
  FLock.Enter;
  FRemoves.Clear;
  FInserts.Clear;
  FLock.Leave;
end;

procedure TThreadedFilter.ClearItems(Sender: TObject);
begin
  ClearFilteredItems;
  inherited;
end;

procedure TThreadedFilter.FlushFilteredItems;
var
  TempExpand: boolean;
begin
  if not assigned(FLock) then
    exit;
  FLock.Enter;
  // We cannot expand until completely done
  TempExpand := FExpandedSelection;
  FExpandedSelection := False;
  if assigned(FInserts) and (FInserts.Count > 0) then begin
    UnfilteredInsertItems(Self, FInserts);
    FInserts.Clear;
  end;
  if assigned(FRemoves) and (FRemoves.Count > 0) then begin
    UnfilteredRemoveItems(Self, FRemoves);
    FRemoves.Clear;
  end;
  FExpandedSelection := TempExpand;
  FLock.Leave;
end;

procedure TThreadedFilter.InsertItems(Sender: TObject; AList: TList);
begin
  // Restart thread
  Restart;
end;

procedure TThreadedFilter.PostProcess;
begin
  // Here used to be "if ExpandedSelection then DoExpandSelection", however:

  // We cannot add expanded items to our own list - they will end up
  // on the remove list next run!
  // This can only be solved by adding a persistent expand list,
  // and checking when filtering if an item is a valid remove item or that
  // it comes from the expand list. (To do)

  // Until that time the motto is: "Threaded Filters cannot Expand!"

  // Call the post process event
  if assigned(FOnPostProcess) then
    FOnPostProcess(Self);
end;

procedure TThreadedFilter.UnsyncPostProcess;
// Assign a routine to OnUnsyncPostProcess for any postprocessing that needs
// to take place inside the thread. It must check "UnsyncTerminated" regularly,
// and any status messages must be dispatched using "UnsyncStatusMessage".
begin
  // Call the unsynchronised post process event
  if assigned(FOnUnsyncPostProcess) then
    FOnUnsyncPostProcess(Self);
end;

procedure TThreadedFilter.UnsyncStatusMessage(AMessage: string);
// This routine can be called from a thread, and will do a status
// message using the TFilterThread.
begin
  if assigned(FThread) then
  begin
    FThread.Task := AMessage;
    FThread.DoStatusMessage(AMessage);
  end;
end;

function TThreadedFilter.UnsyncTerminated: boolean;
begin
  Result := True;
  if assigned(FThread) then
    Result := FThread.Terminated or
      (FThread.Status in [psTerminated, psPaused, psPausing]);
end;

procedure TThreadedFilter.RemoveItems(Sender: TObject; AList: TList);
begin
  // Clear the current buffer to make sure no items slip through
  ClearFilteredItems;

  // Remove the items from our current filtered list if present
  UnfilteredRemoveItems(Sender, AList);

  // Restart the thread
  Restart;
end;

procedure TThreadedFilter.UpdateItems(Sender: TObject; AList: TList);
begin
  UnfilteredUpdateItems(Self, AList);
  Restart;
end;

{ TFilterThread }

procedure TFilterThread.ClearFilteredItems;
begin
  if assigned(FFilter) then
    FFilter.ClearFilteredItems;
end;

procedure TFilterThread.DoProgress;
begin
  if
    assigned(FFilter) and
    assigned(FFilter.Parent) then
  begin
    FFilter.DoProgress(FTick, FCount, FFilter.Parent.Count);
    if FFilter.Parent.Count > 0 then
      Task := format('filtering (%3.1f%%)', [FCount / FFilter.Parent.Count * 100]);
  end;
end;

procedure TFilterThread.DoSyncStatusMessage;
begin
  if assigned(FFilter) then
    TsdRoot(FFilter.Root).DoStatusMessage(Self, FMessage);
end;

procedure TFilterThread.EndProgress;
begin
  FVerboseStatus := False;
  if assigned(FFilter) and assigned(FFilter.Parent) then
    FFilter.EndProgress(FFilter.Parent.Count);
end;

procedure TFilterThread.FlushFilteredItems;
begin
  if assigned(FFilter) then
    FFilter.FlushFilteredItems;
end;

procedure TFilterThread.PostProcess;
begin
  if assigned(FFilter) then
    FFilter.PostProcess;
end;

procedure TFilterThread.UnsyncPostProcess;
begin
  if assigned(FFilter) then
    FFilter.UnsyncPostProcess;
end;

procedure TFilterThread.StartProgress;
begin
  FVerboseStatus := True;

  if assigned(FFilter) then
    FTick := FFilter.StartProgress
  else
    FTick := GetTickCount;
end;

// This routine actually runs through one filter pass
procedure TFilterThread.RunFilter;
var
  Index: integer;
  NewTick, FlushTick, Interval: dword;
  Item: TsdItem;
  AllDone: boolean;
begin
  FCount := 0;
  Index := 0;
  synchronize(StartProgress);
  FlushTick := GetTickCount;
  AllDone := False;
  repeat
    if Terminated then exit;

    // Respond to any resets
    if FReset then begin
      FCount := 0;
      FReset := False;
      synchronize(ClearFilteredItems);
    end;

    // Process each item at FCount
    if (FCount < FFilter.Parent.Count) and not Terminated then begin

      Item := TItemList(FFilter.Parent).Items[Index];
      if FFilter.DoAcceptItem(Item) then begin

        // Item accepted
        if FFilter.IndexOf(Item) < 0 then
          FFilter.AddInsertItem(Item);

      end else begin

        // Item not accepted
        if FFilter.IndexOf(Item) >= 0 then
          FFilter.AddRemoveItem(Item);

      end;

    end else begin
      AllDone := True;
    end;

    // increment to next item
    inc(FCount);
    if Index < FFilter.Parent.Count - 1 then
      inc(Index)
    else
      Index := 0;

    // Flush
    NewTick := GetTickCount;
    Interval := NewTick - FlushTick;
    if (Interval >= cFilterFlushInterval) and not SkipUpdates then begin
      synchronize(FlushFilteredItems);
      FlushTick := NewTick;
    end;

    // Progress
    FFilter.ActionType := atFilter;
    if (GetTickCount - cProgressInterval) >= FTick then begin
      synchronize(DoProgress);
    end;

    // Check pause mode - outside of locks
    if Status = psPausing then 
      Pause;

    // Allow other threads to do things
    sleep(0);

  until AllDone;

  // Unsynchronised postprocessing, occurs before final flushing
  UnsyncPostProcess;

  // The filter has finished it's work
  synchronize(FlushFilteredItems);
  FFilter.ActionType := atFilter;
  synchronize(EndProgress);
  synchronize(PostProcess);

end;

procedure TFilterThread.Run;
// This is the core engine for the threaded filters
begin
  repeat
    // Try - finally block to where we pause
    try
      // Try - except block to catch all exceptions in the thread
      try

        // Do we have valid starting point?
        if assigned(FFilter) and assigned(FFilter.Parent) then
          // Run the filter
          RunFilter;

      except
        // An exception in the thread! It is handled per default
        //DoDebugOut(Self, wsFail, 'Exception in filter thread!');
        synchronize(ClearFilteredItems);
        FReset := true;
      end;
    finally
      // Wait state
      if not Terminated then
        Pause;
    end;
  until Terminated;
end;

procedure TFilterThread.DoStatusMessage(AMessage: string);
begin
  FMessage := AMessage;
  Synchronize(DoSyncStatusMessage);
end;

{ TChainFilter }

function TChainFilter.GetCount: integer;
begin
  // Return count of the last filter
  Result := 0;
  if FilterCount > 0 then
    Result := Filters[FilterCount - 1].Count;
end;

function TChainFilter.GetFilters(AIndex: integer): TItemMngr;
begin
  Result := nil;
  if assigned(FFilters) and (AIndex >= 0) and (AIndex < FFilters.Count) then
    Result := TItemMngr(FFilters[AIndex]);
end;

function TChainFilter.GetFilterCount: integer;
begin
  Result := 0;
  if assigned(FFilters) then
    Result := FFilters.Count;
end;

function TChainFilter.GetNodes: TList;
begin
  // return nodes of last filter
  Result := nil;
  if FilterCount > 0 then
    Result := Filters[FilterCount - 1].Nodes;
end;

function TChainFilter.GetParent: TItemMngr;
begin
  // return parent of first filter
  Result := nil;
  if FilterCount > 0 then
    Result := Filters[0].Parent;
end;

function TChainFilter.GetRoot: TItemList;
begin
  // return root of first filter
  Result := nil;
  if FilterCount > 0 then
    Result := Filters[0].Root;
end;

procedure TChainFilter.SetOnUpdate(AValue: TNOtifyEvent);
begin
  if assigned(Filters[FilterCount - 1]) then
    Filters[FilterCount - 1].OnUpdate := AValue;
end;

procedure TChainFilter.SetParent(AValue: TItemMngr);
begin
  // Set parent of first filter
  if FilterCount > 0 then
    Filters[0].Parent := AValue;
end;

procedure TChainFilter.AddFilter(AFilter: TItemMngr);
begin
  // Add after last item
  InsertFilter(FilterCount, AFilter);
end;

procedure TChainFilter.InsertFilter(AIndex: integer; AFilter: TItemMngr);
var
  FirstFilter, LastFilter,
  TempParent, TempNode: TItemMngr;
begin
  // only valid locations
  if (AIndex < 0) or (AIndex > FilterCount) or (AFilter = nil) then
    exit;

  // Determine if we go before FirstFilter or after LastFilter
  FirstFilter := Filters[0];
  LastFilter := Filters[FilterCount - 1];
  if AIndex > 0 then FirstFilter := nil;
  if AIndex < FilterCount then LastFilter := nil;

  // Do the insert
  FFilters.Insert(AIndex, AFilter);

  // Reassign nodes & updates
  if assigned(LastFilter) then
  begin

    // move nodes
    while LastFilter.Nodes.Count > 0 do
    begin
      TempNode := LastFilter.Nodes[0];
      LastFilter.RemoveNode(TempNode);
      AFilter.AddNode(TempNode);
    end;

    // move updates
    AFilter.OnUpdate := LastFilter.OnUpdate;
    LastFilter.OnUpdate := nil;
    AFilter.OnRangeUpdate := LastFilter.OnRangeUpdate;
    LastFilter.OnRangeUpdate := nil;
  end;

  // Link to predecessor
  if assigned(Filters[AIndex - 1]) then
    Filters[AIndex - 1].ConnectNode(AFilter);

  // Link the successor
  if assigned(Filters[AIndex + 1]) then
    AFilter.ConnectNode(Filters[AIndex + 1]);

  // Reassign parent
  if assigned(FirstFilter) then begin
    TempParent := FirstFilter.Parent;
    if assigned(TempParent) then
      TempParent.DisconnectNode(FirstFilter);
    AFilter.Parent := TempParent;
    if assigned(TempParent) then
      TempParent.ConnectNode(AFilter);
  end;

end;

constructor TChainFilter.Create;
begin
  inherited;
  FFilters := TObjectList.Create;
end;

destructor TChainFilter.Destroy;
begin
  FFilters.Free;
  inherited;
end;

procedure TChainFilter.AddNode(ANode: TItemMngr);
begin
  // Add to last filter
  if FilterCount > 0 then
    Filters[FilterCount - 1].AddNode(ANode);
end;

procedure TChainFilter.ClearItems(Sender: TObject);
begin
  if FilterCount > 0 then
    Filters[0].ClearItems(Sender);
end;

procedure TChainFilter.ConnectNode(ANode: TItemMngr);
begin
  // connect to last filter
  if FilterCount > 0 then
    Filters[FilterCount - 1].ConnectNode(ANode);
end;

procedure TChainFilter.CopyItems(Sender: TObject; AList: TList);
begin
  // we must copy our output list
  if FilterCount > 0 then
    Filters[FilterCount - 1].CopyItems(Sender, AList);
end;

procedure TChainFilter.Disconnect;
var
  i: integer;
begin
  for i := 0 to FilterCount - 1 do
    Filters[i].Disconnect;
end;

procedure TChainFilter.DisconnectNode(ANode: TItemMngr);
begin
  // Disconnect the node from the last filter
  if FilterCount > 0 then
    Filters[FilterCount - 1].DisconnectNode(ANode);
end;

procedure TChainFilter.Execute;
begin
  if FilterCount > 0 then
    Filters[0].Execute;
end;

procedure TChainFilter.InsertItems(Sender: TObject; AList: TList);
begin
  if FilterCount > 0 then
    Filters[0].InsertItems(Sender, AList);
end;

procedure TChainFilter.LockRead;
begin
  // Lock first filter
  if FilterCount > 0 then
    Filters[0].LockRead;
end;

procedure TChainFilter.LockWrite; 
begin
  // Lock first filter
  if FilterCount > 0 then
    Filters[0].LockWrite;
end;

procedure TChainFilter.RemoveItems(Sender: TObject; AList: TList);
begin
  if FilterCount > 0 then
    Filters[0].RemoveItems(Sender, AList);
end;

procedure TChainFilter.RemoveNode(ANode: TItemMngr);
begin
  if FilterCount > 0 then
    Filters[FilterCount - 1].RemoveNode(ANode);
end;

procedure TChainFilter.SetNode(ANode: TItemMngr);
begin
  if FilterCount > 0 then
    Filters[FilterCount - 1].SetNode(ANode);
end;

procedure TChainFilter.UnlockRead;
begin
  // Unlock first filter
  if FilterCount > 0 then
    Filters[0].UnLockRead;
end;

procedure TChainFilter.UnlockWrite; 
begin
  // Unlock first filter
  if FilterCount > 0 then
    Filters[0].UnLockWrite;
end;

procedure TChainFilter.UpdateItems(Sender: TObject; AList: TList);
begin
  if FilterCount > 0 then
    Filters[0].UpdateItems(Sender, AList);
end;

end.

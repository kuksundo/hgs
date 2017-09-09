{ Unit Filters

  Filters are TItemList or TItemMngr descendants that can filter a source list

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Filters;

interface

uses

  Windows, SysUtils, Classes, SyncObjs, Dialogs, Math, sdItems, ItemLists, Contnrs,
  Expanders, sdSortedLists;

type

  TAcceptItemEvent = procedure (Sender: TObject; Item: TsdItem; var Accept: boolean) of object;

  // TVirtualFilter is a filter that does not own a list but filters items on
  // the fly. Override method AcceptItem or assign to OnAcceptItem to provide
  // filtering. The default AcceptItem calls OnAcceptItem, or if nil, just accepts
  // any item.
  TVirtualFilter = class(TItemMngr)
  private
    FOnAcceptItem: TAcceptItemEvent;
  protected
    function  DoAcceptItem(AItem: TsdItem): boolean;
  public
    // Assign your own procedure to OnAcceptItem with which the items in the list
    // are filtered. Set Accept to true if the item is accepted.
    property OnAcceptItem: TAcceptItemEvent read FOnAcceptItem write FOnAcceptItem;
    // AcceptItem is called by the filter whenever it needs to filter a new item.
    // An override of this method for descending filters should evaluate the item
    // and return True if the item is accepted or False if it is not. The default
    // AcceptItem will call OnAcceptItem.
    function AcceptItem(AItem: TsdItem): boolean; virtual;
    // CopyItems will call the parent to get a list and then filter the items so that
    // only items which belong in the filter are present.
    procedure CopyItems(Sender: TObject; AList: TList); override;
    procedure InsertItems(Sender: TObject; AList: TList); override;
    procedure RemoveItems(Sender: TObject; AList: TList); override;
    procedure UpdateItems(Sender: TObject; AList: TList); override;
  end;

  // TFilter implements basic filtering for TImageList lists.
  TFilter = class(TItemList)
  private
    FOnAcceptItem: TAcceptItemEvent;
  protected
    FExpandedSelection: boolean;
    function  DoAcceptItem(AItem: TsdItem): boolean;
    procedure DoExpandSelection; virtual;
    procedure SetExpandedSelection(AValue: boolean);
  public
    constructor Create;
    // If ExpandSelection is set to True, each operation will be followed by a
    // call to DoExpandSelection to add related items.
    property ExpandedSelection: boolean read FExpandedSelection write SetExpandedSelection;
    // Assign your own procedure to OnAcceptItem with which the items in the list
    // are filtered. Set Accept to true if the item is accepted.
    property OnAcceptItem: TAcceptItemEvent read FOnAcceptItem write FOnAcceptItem;
    // AcceptItem is called by the filter whenever it needs to filter a new item.
    // An override of this method for descending filters should evaluate the item
    // and return True if the item is accepted or False if it is not. The default
    // AcceptItem will call OnAcceptItem.
    function AcceptItem(AItem: TsdItem): boolean; virtual;
    procedure InsertItems(Sender: TObject; AList: TList); override;
    procedure RemoveItems(Sender: TObject; AList: TList); override;
    procedure UpdateItems(Sender: TObject; AList: TList); override;
    procedure UnfilteredInsertItems(Sender: TObject; AList: TList);
    procedure UnfilteredRemoveItems(Sender: TObject; AList: TList);
    procedure UnfilteredUpdateItems(Sender: TObject; AList: TList);
  end;

  TTypeFilter = class(TFilter)
  private
    FAcceptedTypes: TItemTypes;
  protected
    procedure SetAcceptedTypes(AValue: TItemTypes);
  public
    property AcceptedTypes: TItemTypes read FAcceptedTypes write SetAcceptedTypes;
    function AcceptItem(AItem: TsdItem): boolean; override;
  end;

const

  // CFilterFlushInterval is the interval in milli-seconds that lays between
  // individual updates of the filter thread's result.
  cFilterFlushInterval = 20000;

implementation

{uses

  GlobalVars;}

{ TVirtualFilter }

function TVirtualFilter.DoAcceptItem(AItem: TsdItem): boolean;
begin
  Result := false;
  if assigned(FOnAcceptItem) then
    FOnAcceptItem(Self, AItem, Result)
  else
    Result := AcceptItem(AItem);
end;

function TVirtualFilter.AcceptItem(AItem: TsdItem): boolean;
begin
  // Basic behaviour: accept only files
  Result := false;
  if assigned(AItem) then
    Result := (AItem.ItemType = itFile);
end;

procedure TVirtualFilter.CopyItems(Sender: TObject; AList: TList);
var
  i: integer;
begin
  // Item Mngr does not have its own list so we must copy from parent
  if assigned(Parent) then
  begin

    Parent.CopyItems(Sender, AList);

    if assigned(AList) then
    begin
      // Now we must filter the list
      i := 0;
      while i < AList.Count do
      begin
        if DoAcceptItem(AList[i]) then
          inc(i)
        else
          AList.Delete(i);
      end;
    end;
  end;
end;

procedure TVirtualFilter.InsertItems(Sender: TObject; AList: TList);
var
  i: integer;
  NextList: TList;
begin
  if (AList = nil) or (AList.Count=0) then
    exit;

  DoBeginUpdate;
  NextList := TList.Create;
  try
    NextList.Capacity := AList.Count;
    for i := 0 to AList.Count - 1 do
      if DoAcceptItem(AList[i]) then
        NextList.Add(AList[i]);
    if NextList.Count > 0 then
      DoInsertItems(NextList);
  finally
    NextList.Free;
  end;
  DoEndUpdate;
end;

procedure TVirtualFilter.RemoveItems(Sender: TObject; AList: TList);
var
  i: integer;
  NextList: TList;
begin
  if (AList = nil) or (AList.Count=0) then
    exit;

  DoBeginUpdate;
  NextList := TList.Create;
  try
    NextList.Capacity := AList.Count;
    for i := 0 to AList.Count - 1 do
      if not DoAcceptItem(AList[i]) then
        NextList.Add(AList[i]);
    if NextList.Count > 0 then
      DoRemoveItems(NextList);
  finally
    NextList.Free;
  end;
  DoEndUpdate;
end;

procedure TVirtualFilter.UpdateItems(Sender: TObject; AList: TList);
var
  i: integer;
  InsertList, RemoveList: TList;
begin
  if (AList = nil) then
  begin

    // Update ALL items - so in practice we have to re-assign all items
    Execute;

  end else
  begin

    // Update items in the list
    if (AList.Count=0) then
      exit;

    InsertList := TList.Create;
    RemoveList := TList.Create;
    try

      DoBeginUpdate;

      for i := 0 to AList.Count - 1 do
        if DoAcceptItem(AList[i]) then
          // Accepted
          InsertList.Add(AList[i])
        else
          // Rejected
          RemoveList.Add(AList[i]);

      DoEndUpdate;

      InsertItems(Self, InsertList);
      RemoveItems(Self, RemoveList);

    finally
      InsertList.Free;
      RemoveList.Free;
    end;
  end;
end;

{ TFilter }

function TFilter.DoAcceptItem(AItem: TsdItem): boolean;
begin
  Result := false;
  if assigned(FOnAcceptItem) then
    FOnAcceptItem(Self, AItem, Result)
  else
    Result := AcceptItem(AItem);
end;

procedure TFilter.DoExpandSelection;
var
  List: TList;
  Expand: TSortedList;
begin
  // Call the external expander
  List := TList.Create;
  Expand := TSortedList.Create(False);
  try
    // Create the list
    CopyItems(Self, List);
    // Expand it
    ExpandSelection(List, Expand, Root, emSelecting);
    // Add the new items
    UnfilteredInsertItems(Self, Expand);

  finally
    List.Free;
    Expand.Free;
  end;
end;

procedure TFilter.SetExpandedSelection(AValue: boolean);
begin
  if AValue <> FExpandedSelection then
  begin

    FExpandedSelection := AValue;
    if AValue then
    begin
      // Set it
      DoExpandSelection;
    end else
    begin
      // Clear it... we'll have to filter again
      Execute;
    end;
  end;
end;

constructor TFilter.Create;
begin
  // We do not want to own objects in a filter
  inherited Create(False);
end;

function TFilter.AcceptItem(AItem: TsdItem): boolean;
begin
  // Basic behaviour: accept only files
  Result := false;
  if assigned(AItem) then
    Result := (AItem.ItemType = itFile);
end;

procedure TFilter.InsertItems(Sender: TObject; AList: TList);
var
  i, Index: integer;
  Tick: dword;
  NextList: TList;
  Expand: TSortedList;
begin
  if (AList = nil) or (AList.Count=0) then
    exit;

  ActionType := atInsert;
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

        // Add the items blindly at the end
        FItems.Capacity := FItems.Count + AList.Count;

        for i := 0 to AList.Count - 1 do
        begin
          DoProgress(Tick, i, AList.Count);
          // Filter the item (this is the only change from TItemview to TFilter)
          if (DoAcceptItem(AList[i])) then
          begin
            // No dupe checking!
            FItems.Add(AList[i]);
            NextList.Add(AList[i]);
          end;
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

        // Add the items in the correct position
        for i := 0 to AList.Count - 1 do
        begin
          DoProgress(Tick, i, AList.Count);
          if not Find(AList[i], Index) then
            // Filter the item (this is the only change from TItemview to TFilter)
            if (DoAcceptItem(AList[i])) then
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

      finally
        UnLockWrite;
      end;

    end;

    // ExpandedSelection mode
    if ExpandedSelection then
    begin
      Expand := TSortedList.Create(False);
      try
        // Expand the selection
        ExpandSelection(NextList, Expand, Parent, emSelecting);
        // Add items to our list
        LockWrite;
        try
          for i := 0 to Expand.Count - 1 do
          begin
            if not Find(TsdItem(Expand[i]), Index) then
            begin
              FItems.Insert(Index, Expand[i]);

              // Determine first updated position
              FMinRange := Min(Index, FMinRange);

              NextList.Add(Expand[i]);
            end;
          end;
        finally
          UnLockWrite;
        end;
      finally
        Expand.Free;
      end;
    end;

    // Last updated position
    if NextList.Count > 0 then
      FMaxRange := FItems.Count - 1;

    // Now we can update the nodes
    DoInsertItems(NextList);

  finally
    EndProgress(AList.Count);
    NextList.Free;
    DoEndUpdate;
  end;

end;

procedure TFilter.RemoveItems(Sender: TObject; AList: TList);
var
  i, Index: integer;
  Tick: dword;
  NextList: TList;
  Expand: TSortedList;
begin
  if (AList = nil) or (AList.Count=0) then
    exit;

  ActionType := atRemove;
  DoBeginUpdate;

  NextList := TList.Create;
  try

    Tick := StartProgress;
    NextList.Capacity := AList.Count;

    LockWrite;
    try

      ExtractItemsFromList(AList, NextList, Tick);

    finally
      UnLockWrite;
    end;

    // ExpandedSelection mode
    if ExpandedSelection then
    begin
      Expand := TSortedList.Create(False);
      Expand.OwnsObjects := False;
      try
        // Expand the selection
        ExpandSelection(NextList, Expand, Parent, emRemoving);
        // Extract items from our list
        LockWrite;
        try
          ActionType := atExpand;
          for i := 0 to Expand.Count - 1 do
          begin
            DoProgress(Tick, i, Expand.Count);
            if Find(TsdItem(Expand[i]), Index) then
            begin
              ExtractAt(Index);
              FMinRange := Min(Index, FMinRange);
              NextList.Add(Expand[i]);
            end;
          end;
        finally
          UnLockWrite;
        end;
      finally
        Expand.Free;
      end;
    end;

    // Last updated position
    if NextList.Count > 0 then
      FMaxRange := FItems.Count - 1;

    // Update the nodes
    DoRemoveItems(NextList);

    EndProgress(AList.Count);

  finally
    NextList.Free;
    DoEndUpdate;
  end;

end;

procedure TFilter.UnfilteredInsertItems(Sender: TObject; AList: TList);
begin
  inherited InsertItems(Sender, AList);
end;

procedure TFilter.UnfilteredRemoveItems(Sender: TObject; AList: TList);
begin
  inherited RemoveItems(Sender, AList);
end;

procedure TFilter.UnfilteredUpdateItems(Sender: TObject; AList: TList);
begin
  inherited UpdateItems(Sender, AList);
end;

procedure TFilter.UpdateItems(Sender: TObject; AList: TList);
// This algorithm needs feedback!
var
  i, Index: integer;
  NextList, InsertList, RemoveList: TList;
  Tick: dword;
begin
  if (AList = nil) or (AList.Count > BatchInsert) then
  begin

    // Update ALL items - so in practice we have to re-assign all items
    Execute;

  end else
  begin

    // Update items in the list
    if (AList.Count = 0) then
      exit;

    InsertList := TList.Create;
    RemoveList := TList.Create;
    try

      DoBeginUpdate;

      // Create list for nodes
      NextList := TList.Create;
      try
        NextList.Capacity := AList.Count;
        Tick := StartProgress;

        // Get a lock
        LockWrite;
        try

          // Locate the item
          for i := 0 to AList.Count - 1 do
          begin
            DoProgress(Tick, i, AList.Count);

            // We cannot count on a sorted list during updates
            Index := IndexOf(AList[i]);
            if Index >= 0 then
            begin
              // First extract the item at index
              ExtractAt(Index);

              // Determine min and max range of updated items
              if FMaxRange = -1 then
              begin
                FMinRange := Index;
                FMaxRange := Index;
              end else
              begin
                FMinRange := Min(FMinRange, Index);
                FMaxRange := Max(FMaxRange, Index);
              end;

              // It was in the list
              if DoAcceptItem(AList[i]) then
              begin

                // It still is so re-insert
                Find(AList[i], Index);
                FItems.Insert(Index, AList[i]);
                NextList.Add(AList[i]);
                // min and max ranges
                FMinRange := Min(FMinRange, Index);
                FMaxRange := Max(FMaxRange, Index);

              end else
              begin

                // It is no longer, so remove
                RemoveList.Add(AList[i]);

                // we must update till the end!
                FMaxRange := Count - 1;

              end;

            end else
            begin
              // It was not in the list
              if DoAcceptItem(AList[i]) then
              begin

                // It is in the list now, so insert
                InsertList.Add(AList[i]);

              end;
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

      InsertItems(Self, InsertList);
      // Since all items are already removed with Extract, we just need
      // to remove from nodes
      DoRemoveItems(RemoveList);

    finally
      InsertList.Free;
      RemoveList.Free;
    end;
  end;
end;

{ TTypeFilter }

procedure TTypeFilter.SetAcceptedTypes(AValue: TItemTypes);
begin
  FAcceptedTypes := AValue;
  Execute;
end;

function TTypeFilter.AcceptItem(AItem: TsdItem): boolean;
begin
  Result := AItem.ItemType in AcceptedTypes;
end;

end.


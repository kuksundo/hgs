{ Unit CloseMatches

  This unit provides support for the analysis of closely matching images.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit CloseMatches;

interface

uses
  Windows, Classes, Graphics, SysUtils, Dialogs, Filters, ThreadedFilters, ItemLists,
  sdItems, sdProperties, sdSortedLists, sdAbcTypes, sdAbcFunctions;

type

  TItemDataEvent = procedure(Sender: TObject; Item: TsdItem; var Data: pointer) of object;
  TFuzzyCompareEvent = function(Item1, Item2: TsdItem; Data1, Data2: pointer; Limit: integer): integer of object;
  TFuzzyFilterEvent = function(Item1, Item2: TsdItem; var IsEqual: boolean): boolean of object;

  TCloseMatchFilter = class(TChainFilter)
  private
    FDiffLimit: integer;
    FOnCalculate: TAcceptItemEvent;
    FOnCompare: TFuzzyCompareEvent;
    FOnFuzzyFilter: TFuzzyFilterEvent;
    FOnItemData: TItemDataEvent;
    FOnPreAccept: TAcceptItemEvent;
    FOnPostProcess: TNotifyEvent;
    function DoFuzzyFilter(Item1, Item2: TsdItem; var IsEqual: boolean): boolean;
    procedure DoPostProcess(Sender: TObject);
    procedure DoItemData(Sender: TObject; Item: TsdItem; var Data: pointer);
  protected
    procedure CloseMatchAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
    procedure CloseMatchPixRef(Sender: TObject; AItem: TsdItem; var Accept: boolean);
    procedure SetDiffLimit(AValue: integer);
    procedure SetOnCompare(AValue: TFuzzyCompareEvent);
  public
    constructor Create;
    procedure SetFilterName(AValue: string);
    property DiffLimit: integer read FDiffLimit write SetDiffLimit;
    // provide to OnCalculate a routine that calculates the item (creates properties etc
    // and set Accept to True if you want this item to be included for final comparison
    property OnCalculate: TAcceptItemEvent read FOnCalculate write FOnCalculate;
    // Compare two items (Item1, Item2) using data pointers (Data1, Data2) and return
    // the difference (must be positive integer). Limit can be used to stop compares
    //  where the difference > Limit
    property OnCompare: TFuzzyCompareEvent read FOnCompare write SetOnCompare;
    // OnFuzzyFilter is the final step. If Item1 and Item2 are belonging to same fuzzy group,
    // then return True. It may be that the underlying autograph is equal, but still
    // not the same group. In that case return False and set IsEqual to True
    property OnFuzzyFilter: TFuzzyFilterEvent read FOnFuzzyFilter write FOnFuzzyFilter;
    // Provide a Data pointer for an Item, or leave nil. Providing a data pointer per item
    // in this stage helps speed up the process
    property OnItemData: TItemDataEvent read FOnItemData write FOnItemData;
    // Add a quick check to see if the item is existing and right type etc
    property OnPreAccept: TAcceptItemEvent read FOnPreAccept write FOnPreAccept;
    // Here can be added any routine popping up a "finished" dialog and doing postprocessing
    property OnPostProcess: TNotifyEvent read FOnPostProcess write FOnPostProcess;
  end;

  // This filter is used to first filter out all non-pixrefable items and then
  // to arrange them by similarity in CloseMatchArrange
  TCloseMatchArranger = class(TThreadedFilter)
  public
    FLimit: integer;
    FOnGetData: TItemDataEvent;
    FOnCompareData: TFuzzyCompareEvent;
    procedure CloseMatchArrange(Sender: TObject);
  end;

// Utility function to provide compare for regular sorting algorithm (crude method)
function CompareCloseMatch(Item1, Item2: TsdItem; Info: pointer): integer;

const

  // The allowed difference for each tolerance setting
  cPixRefDiffByTol: array[0..7] of integer =
    (500, 1000, 1500, 3000, 5000, 10000, 15000, 20000);

implementation

uses

  sdRoots, Duplicates, PixRefs;

{ TCloseMatchFilter }

constructor TCloseMatchFilter.Create;
var
  AFilter: TItemMngr;
  CMA: TCloseMatchArranger;
  F: TFilter;
begin
  inherited Create;

  // Step 1: Add a threaded filter that creates the pixref. Since pixref may not
  // exist for some items this can take a while, so threaded
  AFilter := TCloseMatchArranger.Create;
  CMA := TCloseMatchArranger(AFilter);
  CMA.Sorted := False;
  CMA.SkipUpdates := True;
  // Each compare will pixref the items if not yet done
  CMA.OnAcceptItem := CloseMatchPixRef;

  // Add a unsynced postprocessor that will find a similar buddy for each item
  CMA.OnUnsyncPostProcess := CMA.CloseMatchArrange;

  // The postprocessor that will display the completed message to the user
  OnPostProcess := DoPostProcess;
  CMA.FOnGetData := DoItemData;

  AddFilter(AFilter);

  // Step 2: Add a normal filter that will only select duplicates
  AFilter := TFilter.Create;
  F := TFilter(AFilter);
  F.Name := 'duplicates list';
  F.Sorted := False;
  F.OnAcceptItem := CloseMatchAcceptItem;
  AddFilter(AFilter);

end;

procedure TCloseMatchFilter.SetFilterName(AValue: string);
begin
  if assigned(Filters[0]) then
    Filters[0].Name := AValue;
  Name := AValue;
end;

function TCloseMatchFilter.DoFuzzyFilter(Item1, Item2: TsdItem; var IsEqual: boolean): boolean;
begin
  if assigned(FOnFuzzyFilter) then
    Result := FOnFuzzyFilter(Item1, Item2, IsEqual)
  else
    Result := False;
end;

procedure TCloseMatchFilter.DoItemData(Sender: TObject; Item: TsdItem; var Data: pointer);
begin
  if assigned(FOnItemData) then
    FOnItemData(Sender, Item, Data);
end;

procedure TCloseMatchFilter.DoPostProcess(Sender: TObject);
begin
  if assigned(FOnPostProcess) then
    FOnPostProcess(Sender);
end;

procedure TCloseMatchFilter.CloseMatchAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
var
  Index: integer;
  Item2: TsdItem;
  DupeGroup1,
  DupeGroup2: integer;
  SortMatch: TItemList;
  Offset: integer;
  Equal: boolean;
  // local function
  function GetDupeGroup(AItem: TsdItem): integer;
  var
    DupeGroup: TsdProperty;
  begin
    Result := 0;
    if not assigned(AItem) then
      exit;

    DupeGroup := AItem.GetProperty(prDupeGroup);
    if assigned(DupeGroup) then
      // We have a dupegroup property
      Result := TprDupeGroup(DupeGroup).GroupID;
  end;
  // local function
  procedure SetDupeGroup(AItem: TsdItem; AValue: integer);
  var
    DupeGroup: TsdProperty;
  begin
    if not assigned(AItem) then
      exit;

    if AValue > 0 then
    begin

      DupeGroup := AItem.GetProperty(prDupeGroup);
      if not assigned(DupeGroup) then
        // Create new property
        DupeGroup := AItem.AddProperty(TprDupeGroup.Create);
      TprDupeGroup(DupeGroup).GroupID := AValue;

    end else
    begin
      AItem.RemoveProperty(prDupeGroup);
    end;
  end;
  // local function
  procedure NewDupeGroup(AItem: TsdItem);
  var
    DupeGroup: TsdProperty;
  begin
    if not assigned(AItem) then
      exit;
    DupeGroup := AItem.AddProperty(TprDupeGroup.Create);
    TprDupeGroup(DupeGroup).GroupID := TprDupeGroup(DupeGroup).GetUniqueID;
  end;
// main
begin
  Accept := False;

  Item2 := nil;

  SortMatch := TItemList(Filters[0]);
  if not assigned(SortMatch) then
    exit;

  // Find place in list. We can't use Find because the list might not be
  // causal
  Index := Sortmatch.IndexOf(AItem);
  if Index > 0 then
  begin

    // Compare with neighbours
    // check downwards
    Offset := 1;
    Accept := False;
    Equal := True;
    while not Accept and Equal and (Index - Offset >= 0) do
    begin
      Item2 := SortMatch[Index - Offset];
      Accept := DoFuzzyFilter(AItem, Item2, Equal);
      inc(Offset);
    end;
    // check upwards
    Offset := 1;
    Equal := True;
    while not Accept and Equal and (Index + Offset < SortMatch.Count) do
    begin
      Item2 := SortMatch[Index + Offset];
      Accept := DoFuzzyFilter(AItem, Item2, Equal);
      inc(Offset);
    end;
  end;

  // Dupe Groups
  if Accept then
  begin
    // Identical items
    DupeGroup1 := GetDupeGroup(AItem);
    DupeGroup2 := GetDupeGroup(Item2);
    if (DupeGroup1 = 0) and (DupeGroup2 = 0) then
    begin

      // Set both to new duplicate group
      NewDupeGroup(AItem);
      SetDupeGroup(Item2, GetDupeGroup(AItem));

    end else
    begin

      // Copy group ID from one to other
      if (DupeGroup1 > 0) then
        SetDupeGroup(Item2, DupeGroup1)
      else
        if (DupeGroup2 > 0) then
          SetDupeGroup(AItem, DupeGroup2);

    end;
  end else
  begin
    // Non identical
    SetDupeGroup(AItem, 0);
  end;

end;

procedure TCloseMatchFilter.CloseMatchPixRef(Sender: TObject; AItem: TsdItem; var Accept: boolean);
// All we do here is calculate the pixel reference and accept if this item has
// a valid pixel reference
var
  PreAccept: boolean;
begin
  Accept := False;
  // Call the owner's accept
  PreAccept := True;
  if assigned(FOnPreAccept) then
    FOnPreAccept(Self, AItem, PreAccept);
  if not PreAccept then
    exit;

  // Calculate the item and see if it is fit for comparison
  if assigned(FOnCalculate) then
    FOnCalculate(Sender, AItem, Accept);
end;

procedure TCloseMatchFilter.SetDiffLimit(AValue: integer);
begin
  FDiffLimit := AValue;
  if assigned(Filters[0]) then
    TCloseMatchArranger(Filters[0]).FLimit := AValue;
end;

procedure TCloseMatchFilter.SetOnCompare(AValue: TFuzzyCompareEvent);
begin
  if assigned(Filters[0]) then
    TCloseMatchArranger(Filters[0]).FOnCompareData := AValue;
end;

{ TCloseMatchArranger }

procedure TCloseMatchArranger.CloseMatchArrange(Sender: TObject);
// Arrange the list by finding the closest match for each item in the unprocessed list
var
  i, j, MinDiff, Diff, Low: integer;
  Tick: dword;
  Data: TList;
  List: TList;
  AMessage: string;
  P: pointer;
begin
  Diff := 0; MinDiff := 0;
  // Pointer to our
  List := FInserts;
  if assigned(List) and (List.Count > 1) then
  begin
    Tick := GetTickCount;
    // Data pointers
    Data := TList.Create;
    try
      try
        // Create data pointers
        Data.Capacity := List.Count;
        for i := 0 to List.Count - 1 do
        begin
          P := nil;
          if assigned(FOnGetData) then
            FOnGetData(Sender, List[i], P);
          Data.Add(P);
        end;


        // The traditional sort algo, VERY slow but only solution here
        for i := 0 to List.Count - 3 do
        begin

          // Find the item with least difference
          Low := i + 1;
          if assigned(FOnCompareData) then
            MinDiff := FOnCompareData(List[i], List[i+1], Data[i], Data[i+1], FLimit)
          else
            break;
          for j := i + 2 to List.Count - 1 do
          begin
            if assigned(FOnCompareData) then
              Diff := FOnCompareData(List[i], List[j], Data[i], Data[j], MinDiff)
            else
              break;
            if Diff < MinDiff then
            begin
              Low := j;
              MinDiff := Diff;
            end;
            // Check for termination by the user
            if UnsyncTerminated then
              exit;

          end;
          sleep(2); // allow other threads to run

          // The next item is the one with least difference
          List.Exchange(i + 1, Low);
          Data.Exchange(i + 1, Low);

          // Do progress
          if GetTickCount > Tick + cProgressInterval then
          begin
            AMessage :=  format('Arranging items by similarity (%3.1f%%)', [(i + 1) / List.Count * 100]);
            UnSyncStatusMessage(AMessage);
            Tick := GetTickCount;
          end;
        end;

        // Remove any dupe items so that the smart compare that follows suit will
        // be able to assign new dupe groups
        for i := 0 to List.Count - 1 do
          TsdItem(List[i]).RemoveProperty(prDupeGroup);

          // Do another sweep to find all differences (this was used for display
          // in 'properties', testing only

//todo: why is this commented out?
(*          if i > 0 then
            Diff := PixRefDifference(List[i-1], List[i], Data[i-1], Data[i], {nil, }cMaxArrangeDiff)
          else
            Diff := 0;
          if assigned(Data[i]) then
            TprPixRef(Data[i]).FDiff := Diff;
        end; *)

        UnSyncStatusMessage('Arranging items by similarity (100%)');

      except
        // Silent exception
      end;
    finally
      Data.Free;
    end;
  end;
end;

// Functions

function CompareCloseMatch(Item1, Item2: TsdItem; Info: pointer): integer;
begin
  // Do we have the pixref properties
  if Item1.HasProperty(prPixRef) and Item2.HasProperty(prPixRef) then
  begin
    Result := ComparePixRef(Item1.GetProperty(prPixRef), Item2.GetProperty(prPixRef), 0);
  end else
  begin
    // Separate items: compare pointers
    Result := CompareInt(Integer(Item1), Integer(Item2));
  end;
  if Result = 0 then
    Result := CompareGuid(Item1.Guid, Item2.Guid);
end;

end.


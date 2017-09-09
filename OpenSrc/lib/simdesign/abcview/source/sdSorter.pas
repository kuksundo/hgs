{ unit Sorters

  Sorting functionality

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit sdSorter;

interface

uses

  Windows, SysUtils, Classes, Contnrs, sdItems, sdAbcTypes, NativeXml;

type

  TSortItem = class
  private
    FMethod: TSortMethodType;
    FDirection: TSortDirectionType;
  public
    property Method: TSortMethodType read FMethod write FMethod;
    property Direction: TSortDirectionType read FDirection write FDirection;
    constructor Create(AMethod: TSortMethodType; ADirection: TSortDirectionType);
  end;

  TSortMethod = class
  private
    FItems: TObjectList;
    function GetCount: integer;
    function GetDescription(Index: integer): string;
    function GetDirection(Index: integer): TSortDirectionType;
    function GetMethod(Index: integer): TSortMethodType;
  public
    property Count: integer read GetCount;
    property Description[Index: integer]: string read GetDescription;
    property Direction[Index: integer]: TSortDirectionType read GetDirection;
    property Method[Index: integer]: TSortMethodType read GetMethod;
    // Use AddMethod to add a sort method to the list. If the first method
    // is identical, it won't be duplicated but only ADir will be adjusted.
    constructor Create;
    destructor Destroy; override;
    procedure AddMethod(AMethod: TSortMethodType; ADirection: TSortDirectionType);
  end;

  TsdSorter = class(TDebugObject)
    // Locate a position in a sorted TList using binary method
    function ListCustomFind(List: TList; Item: TsdItem; Info: pointer; var Index: Integer; Compare: TListSortCustomCompare): Boolean;
    //
    procedure ListCustomArrange(List: TList; ItemDifference: TItemDifferenceFunction;
      Info: pointer; DataPointer: TDataPointerFunction; OnProgress: TSimpleProgressEvent);
    // Sort a TList using the quicksort algorithm
    // the OnProgress feedbackfunction can be used to get feedback to the user for large lists (percentage done)
    procedure ListCustomSort(List: TList; Info: pointer; Compare: TListSortCustomCompare; OnProgress: TSimpleProgressEvent);
  end;

implementation

constructor TSortItem.Create;
begin
  inherited Create;
  FMethod := AMethod;
  FDirection := ADirection;
end;

function TSortMethod.GetCount;
begin
  Result := FItems.Count;
end;

function TSortMethod.GetDescription(Index: integer): string;
begin
  Result := cSortMethodName[Method[Index]];
end;

function TSortMethod.GetDirection;
begin
  Result := sdAscending;
  if Index < FItems.Count then
    Result := TSortItem(FItems[Index]).Direction;
end;

function TSortMethod.GetMethod;
begin
  Result := smNoSort;
  if assigned(FItems) and (Index < FItems.Count) then
    Result := TSortItem(FItems[Index]).Method;
end;

constructor TSortMethod.Create;
begin
  inherited Create;
  FItems := TObjectList.Create;
end;

destructor TSortMethod.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TSortMethod.AddMethod;
var
  i: integer;
  Item: TSortItem;
begin

  // First delete all identical methods, the random ones, and the NoSort ones
  i := 0;
  while i < FItems.Count do
  begin
    Item := TSortItem(FItems[i]);
    if (Item.Method = AMethod) or (Item.Method = smRandom) or (Item.Method = smNoSort) then
      FItems.Delete(i)
    else
      inc(i);
  end;

  // Create new method and insert it
  FItems.Insert(0, TSortItem.Create(AMethod, ADirection));

end;

function TsdSorter.ListCustomFind(List: TList; Item: TsdItem; Info: pointer; var Index: Integer; Compare: TListSortCustomCompare): Boolean;
var
  AMin, AMax: integer;
begin
  // This function should have been implemented by borland!
  // Find position for insert - binary method
  Result:=false;
  try
    Index := 0;
    AMin := 0;
    AMax := List.Count;
    while AMin < AMax do
    begin
      Index := (AMin+AMax) div 2;
      case Compare(List[Index], Item, Info) of
      -1: AMin := Index + 1;
       0: begin
            Result := true;
            exit;
          end;
       1: AMax := Index;
      end;
    end;
    Index := AMin;
  except
    Result := false;
  end;
end;

procedure TsdSorter.ListCustomArrange(List: TList; ItemDifference: TItemDifferenceFunction;
  Info: pointer; DataPointer: TDataPointerFunction; OnProgress: TSimpleProgressEvent);
// Arrange a TList using proprietary arranging algorithm. This is a slower algorithm
// but will yield results in non-causal cases. The ListSortCustomCompare can result
// in values of 0 or positive integer to indicate the amount of difference
// between the items.
// the OnProgress feedbackfunction can be used to get feedback to the user for large lists (percentage done)
// main
var
  i, j, MinDiff, Diff, Low: integer;
  Tick: dword;
  Data: TList;
begin
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
          Data.Add(DataPointer(List[i]));

        // The traditional sort algo, VERY slow but only solution here
        for i := 0 to List.Count - 2 do
        begin

          // Find the item with least difference
          Low := i + 1;
          MinDiff := ItemDifference(List[i], List[i + 1], Data[i], Data[i+1], cMaxArrangeDiff);
          for j := i + 2 to List.Count - 1 do
          begin
            Diff := ItemDifference(List[i], List[j], Data[i], Data[j], {Info, }MinDiff);
            if Diff < MinDiff then
            begin
              Low := j;
              MinDiff := Diff;
            end;
          end;

          // The next item is the one with least difference
          List.Exchange(i + 1, Low);
          Data.Exchange(i + 1, Low);

          // Do progress
          if Assigned(OnProgress) and (GetTickCount > Tick + cProgressInterval) then
          begin
            OnProgress(nil, (i + 1) / List.Count * 100);
            Tick := GetTickCount;
          end;
        end;

        if Assigned(OnProgress) then
          OnProgress(nil, 100);
      except
        DoDebugOut(Self, wsFail, 'An exception occured during sorting.');
      end;
    finally
      Data.Free;
    end;
  end;
end;

procedure TsdSorter.ListCustomSort(List: TList; Info: pointer; Compare: TListSortCustomCompare; OnProgress: TSimpleProgressEvent);
// Sort a TList using the quicksort algorithm
// the OnProgress feedbackfunction can be used to get feedback to the user for large lists (percentage done)
var
  CompareCount, EstimCount: dword;
  Tick: dword;
//local
function PredictProgress: double;
begin
  if CompareCount < round(EstimCount * 0.9) then
    PredictProgress:= (CompareCount/EstimCount) * 100
  else
    PredictProgress:=(1 - 0.09 * EstimCount/CompareCount)*100;
end;
//local
procedure QuickSort(iLo, iHi: Integer);
var
  Lo, Hi, Mid: longint;
begin
  Lo := iLo;
  Hi := iHi;
  Mid:= (Lo + Hi) div 2;
  repeat
    while Compare(List[Lo], List[Mid], Info) < 0 do
    begin
      Inc(Lo);
      inc(CompareCount);
      if Assigned(OnProgress) and (GetTickCount > Tick + cProgressInterval) then
      begin
        OnProgress(nil, PredictProgress);
        Tick := GetTickCount;
      end;
    end;
    while Compare(List[Hi], List[Mid], Info) > 0 do
    begin
      Dec(Hi);
      inc(CompareCount);
      if Assigned(OnProgress) and (GetTickCount > Tick + cProgressInterval) then
      begin
        OnProgress(nil, PredictProgress);
        Tick := GetTickCount;
      end;
    end;
    if Lo <= Hi then
    begin
      // Swap pointers;
      List.Exchange(Lo, Hi);

      if Mid = Lo then
        Mid:=Hi
      else
        if Mid = Hi then
          Mid:=Lo;

      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;
  if Hi > iLo then
    QuickSort(iLo, Hi);
  if Lo < iHi then
    QuickSort(Lo, iHi);
end;
// main
begin
  if assigned(List) and (List.Count > 1) then
  begin
    Tick := GetTickCount;
    CompareCount := 0;
    EstimCount := round(List.Count * sqrt(List.Count) / 20);
    try
      QuickSort(0, List.Count-1);
      if Assigned(OnProgress) then
        OnProgress(nil, 100);
    except
      DoDebugOut(Self, wsFail, 'An exception occured during sorting.');
    end;
  end;
end;

end.

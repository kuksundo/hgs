{$IFNDEF __SORT_PROVIDER_TEMPLATE__}
/// This unit implements a sort provider template that can be used
/// to allow sorted access to any kind of container
unit t_dzSortProvider;

interface

uses
  SysUtils,
  Classes,
  u_dzQuicksort;

type
  /// declare the item type stored in the associated container
  _DZ_SORT_ITEM_ = pointer;

{$ENDIF __SORT_PROVIDER_TEMPLATE__}

{$IFNDEF __SORT_PROVIDER_TEMPLATE_SECOND_PASS__}

type
  /// function to access the Item at index Idx
  TSortProviderItemAccess = function(_Idx: integer): _DZ_SORT_ITEM_ of object;

type
  /// template for allowing sorted access to any kind of container
  _SORT_PROVIDER_ = class
  private
    /// this array stores the sort indices of the items
    FSortedIdx: array of integer;
    /// method used in GetItems to access the items
    FItemAccess: TSortProviderItemAccess;
    /// method used in Update to compare the items
    FItemCompare: TCompareItemsMeth;
    /// number of items stored in the associated container
    FItemCount: integer;
    /// getter function fot the Items property
    function GetItems(_Idx: integer): _DZ_SORT_ITEM_;
    /// swaps the items at Idx1 and Idx2 by swapping the indices in the FSortedIdx array
    procedure doSwapItems(_Idx1, _Idx2: integer);
    /// calls FItemCompare to compare the items at index Idx1 and Idx2
    function doCompareItems(_Idx1, _Idx2: integer): integer;
  public
    /// creates a new _SORT_PROVIDER_ instance
    /// @param ItemAccess is a method for accessing the items by index
    /// @param ItemCompare is a method for comparing two items
    /// @param ItemCount is the number of items stored in the associated container
    constructor Create(_ItemAccess: TSortProviderItemAccess; _ItemCompare: TCompareItemsMeth; _ItemCount: integer);
    /// updates the sort order, automatically called in the constructor
    /// you must call this every time if the sort order or number of items in the
    /// associated container has changed
    /// @param ItemCount is the new item count in the associated container
    procedure Update(_ItemCount: integer);
    /// returns the number of items as passed to the constructor or call to Update
    property Count: integer read FItemCount;
    /// allows sorted access to the items stored in the associated container
    property Items[_Idx: integer]: _DZ_SORT_ITEM_ read GetItems; default;
  end;
{$ENDIF __SORT_PROVIDER_TEMPLATE_SECOND_PASS__}

{$IFNDEF __SORT_PROVIDER_TEMPLATE__}
implementation
{$ENDIF __SORT_PROVIDER_TEMPLATE__}

{$IFDEF __SORT_PROVIDER_TEMPLATE_SECOND_PASS__}

{ _SORT_PROVIDER_ }

constructor _SORT_PROVIDER_.Create(_ItemAccess: TSortProviderItemAccess; _ItemCompare: TCompareItemsMeth; _ItemCount: integer);
begin
  inherited Create;
  FItemAccess := _ItemAccess;
  FItemCompare := _ItemCompare;

  Update(_ItemCount);
end;

function _SORT_PROVIDER_.GetItems(_Idx: integer): _DZ_SORT_ITEM_;
begin
  Result := FItemAccess(FSortedIdx[_Idx]);
end;

function _SORT_PROVIDER_.doCompareItems(_Idx1, _Idx2: integer): integer;
begin
  Result := FItemCompare(FSortedIdx[_Idx1], FSortedIdx[_Idx2]);
end;

procedure _SORT_PROVIDER_.doSwapItems(_Idx1, _Idx2: integer);
var
  p: integer;
begin
  p := FSortedIdx[_Idx1];
  FSortedIdx[_Idx1] := FSortedIdx[_Idx2];
  FSortedIdx[_Idx2] := p;
end;

procedure _SORT_PROVIDER_.Update(_ItemCount: integer);
var
  i: integer;
begin
  FItemCount := _ItemCount;

  SetLength(FSortedIdx, Count);
  for i := 0 to Count - 1 do
    begin
      FSortedIdx[i] := i;
    end;

  QuickSort(0, Count - 1, doCompareItems, doSwapItems);
end;

{$WARNINGS off}
{$IFNDEF __SORT_PROVIDER_TEMPLATE__}
end.
{$ENDIF __SORT_PROVIDER_TEMPLATE__}
{$ENDIF __SORT_PROVIDER_TEMPLATE_SECOND_PASS__}
{$DEFINE __SORT_PROVIDER_TEMPLATE_SECOND_PASS__}


unit u_MyItemListSorter;

// NOTE: This is work in progress, it does not yet compile!

interface

uses
  u_MyItemList;

procedure SortMyItemList(_List: TMyItemList);

implementation

uses
  u_dzQuickSort,
  u_MyItem;

{$define __DZ_LIST_SORTER_TEMPLATE__}
type
  _KEY_LIST_ = TMyItemList;

{$include 't_dzListSorterTemplate.tpl'}

procedure SortMyItemList(_List: TMyItemList);
begin
  _SORT_KEY_LIST_(_List);
end;

end.

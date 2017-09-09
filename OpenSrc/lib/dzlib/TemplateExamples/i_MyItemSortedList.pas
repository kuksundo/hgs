unit i_MyItemSortedList;

interface

uses
  Classes,
  u_MyItem;

{$DEFINE __DZ_SORTED_LIST_INTERFACE_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TInterfacedObject;
  _LIST_CONTAINER_ = TList;
  _ITEM_TYPE_ = TMyItem;
  _KEY_TYPE_ = integer;
{$INCLUDE 't_dzSortedListInterfaceTemplate.tpl'}

type
  IMySortedItemList = interface(_DZ_SORTED_LIST_INTERFACE_TEMPLATE_)
    ['{75759FED-F7FA-407F-92F0-F8C6A6A6109C}']
  end;

implementation

end.


unit u_MyItemSortedList;

interface

uses
  Classes,
  u_dzTranslator,                              
  u_dzQuicksort,
  u_MyItem,
  I_MyItemSortedList;

{$DEFINE __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TInterfacedObject;
  _ITEM_TYPE_ = TMyItem;
// _KEY_TYPE_ is declared as integer in the template

{$INCLUDE 't_dzIntegerSortedObjectListTemplate.tpl'}

type
  IMyItemSortedList = interface(_DZ_SORTED_LIST_INTERFACE_TEMPLATE_)
    ['{75759FED-F7FA-407F-92F0-F8C6A6A6109C}']
  end;

type
  TMyItemSortedList = class(_DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_, IMyItemSortedList)
  protected
    function KeyOf(const _Item: _ITEM_TYPE_): _KEY_TYPE_; override;
  end;

implementation

{ TMyItemSortedList }

{$INCLUDE 't_dzIntegerSortedObjectListTemplate.tpl'}

function TMyItemSortedList.KeyOf(const _Item: _ITEM_TYPE_): _KEY_TYPE_;
begin
  Result := _Item.Key;
end;

end.


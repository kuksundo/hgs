unit u_MyItemIntSortedList;

interface

uses
  Classes,
  u_dzTranslator,
  u_dzQuicksort,
  u_MyItem;

{$DEFINE __DZ_INTEGER_SORTED_LIST_TEMPLATE__}
type
  {: This is the ancestor class for the template }
  _LIST_ANCESTOR_ = TInterfacedObject;
  {: This is the container type to store the items }
  _LIST_CONTAINER_ = TInterfaceList;
  {: The native item type of the list container (Pointer for TList, IInterface for TInterfaceList}
  _LIST_CONTAINER_ITEM_TYPE_ = IInterface; 
  {: This is the object type to be stored in the list }
  _ITEM_TYPE_ = IMyItem;
  // Note: The _KEY_TYPE_ is already declared as Integer for an IntegerSortedList
{$INCLUDE 't_dzIntegerSortedListTemplate.tpl'}

type
  {: a list for storing IMyItem interfaces based on _DZ_INTEGER_SORTED_LIST_TEMPLATE_ }
  TMyItemIntSortedList = class(_DZ_INTEGER_SORTED_LIST_TEMPLATE_)
  protected
    {: The only method we must implement here is KeyOf, it returns the ID property of the
       Item. Everything else is already implemented for the template }
    function KeyOf(const _Item: IMyItem): integer; override;
  end;

implementation

{ TMyItemIntSortedList }

{$INCLUDE 't_dzIntegerSortedListTemplate.tpl'}

{ TMyItemIntSortedList }

function TMyItemIntSortedList.KeyOf(const _Item: IMyItem): integer;
begin
  Result := _Item.Key;
end;

end.

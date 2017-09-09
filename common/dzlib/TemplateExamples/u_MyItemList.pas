{: This example unit declares TMyItemList based on the _DZ_LIST_TEPLATE_ template
   storing TMyItem objects and implementing the IMyItemList interface }
unit u_MyItemList;

interface

uses
  Classes,
  u_MyItem,
  u_dzQuickSort,
  i_MyItemList;

{$DEFINE __DZ_OBJECT_LIST_TEMPLATE__}
type
  {: This is the ancestor class for the template }
  _LIST_ANCESTOR_ = TInterfacedObject;
  {: This is the object type to be stored in the list }
  _ITEM_TYPE_ = TMyItem;
{$INCLUDE 't_dzObjectListTemplate.tpl'}

type
  {: a list for storing TMyItem objects based on _DZ_LIST_TEMPLATE_ and implementing
     the IMyItemList interface.
     All code is already declared in the template. }
  TMyItemList = class(_DZ_OBJECT_LIST_TEMPLATE_, IMyItemList)
  end;

implementation

{$INCLUDE 't_dzObjectListTemplate.tpl'}

end.


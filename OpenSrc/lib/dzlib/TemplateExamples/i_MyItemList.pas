{: This example unit declares an interface to a list storing TMyItems based on the
   _DZ_LIST_INTERFACE_TEMPLATE_ }
unit i_MyItemList;

interface

uses
  u_MyItem;

{$DEFINE __DZ_LIST_INTERFACE_TEMPLATE__}
type
  {: Item type to be stored in the list }
  _ITEM_TYPE_ = TMyItem;
{$INCLUDE 't_dzListInterfaceTemplate.tpl'}

type
  {: This interface is implemented by TMyItemList declared in u_MyItemList }
  IMyItemList = interface(_DZ_LIST_INTERFACE_TEMPLATE_)
    ['{75759FED-F7FA-407F-92F0-F8C6A6A6109C}']
  end;

implementation

// It is not necesssary to include the template implementation because
// there is no implementation, but we include it anyway just for consistency
// in template usage.
{$INCLUDE 't_dzListInterfaceTemplate.tpl'}

end.


unit u_MyItemIntList;

interface

uses
  Classes,
  u_MyItem;

{$DEFINE __DZ_LIST_TEMPLATE__}
type
  {: This is the ancestor class for the template }
  _LIST_ANCESTOR_ = TInterfacedObject;
  {: This is the container type to store the items }
  _LIST_CONTAINER_ = TInterfaceList;
  {: The native item type of the list container (Pointer for TList, Interface for TInterfaceList}
  _LIST_CONTAINER_ITEM_TYPE_ = IInterface; 
  {: This is the object type to be stored in the list }
  _ITEM_TYPE_ = IMyItem;
{$INCLUDE 't_dzListTemplate.tpl'}

type
  {: a list for storing IMyItem interfaces based on _DZ_LIST_TEMPLATE_ and implementing
     the IMyItemList interface.
     All code is already in the template, so we only have declarations here. }
  TMyItemIntList = class(_DZ_LIST_TEMPLATE_)
  public
  end;

implementation

{ TMyItemIntList }

{$INCLUDE 't_dzListTemplate.tpl'}

end.

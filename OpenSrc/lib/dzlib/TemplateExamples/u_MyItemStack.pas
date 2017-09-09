unit u_MyItemStack;

interface

uses
  SysUtils,
  Classes,
  u_MyItem;

{$DEFINE __OBJECT_STACK_TEMPLATE__}
type
  _STACK_ITEM_ = TMyItem;
  _STACK_CONTAINER_TYPE_ = TList;
  _LIST_CONTAINER_ITEM_TYPE_ = pointer;
  _STACK_ANCESTOR_ = TObject;
const
  _STACK_MAX_DEPTH_ = 150;
{$INCLUDE 't_dzObjectStackTemplate.tpl'}

type
  TMyItemStack = class(_OBJECT_STACK_TEMPLATE_)
  end;

implementation

{$INCLUDE 't_dzObjectStackTemplate.tpl'}

end.


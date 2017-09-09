unit u_MyItemQueue;

interface

uses
  Classes,
  u_MyItem;

{$DEFINE __QUEUE_TEMPLATE__}
type
  _QUEUE_ITEM_ = TMyItem;
  _LIST_CONTAINER_ITEM_TYPE_ = pointer;
  _QUEUE_CONTAINER_TYPE_ = TList;
  _QUEUE_ANCESTOR_ = TObject;
{$INCLUDE 't_dzQueueTemplate.tpl'}

type
  TMyItemQueue = class(_QUEUE_TEMPLATE_)
  end;

implementation

{ TMyItemQueue }
{$INCLUDE 't_dzQueueTemplate.tpl'}

end.


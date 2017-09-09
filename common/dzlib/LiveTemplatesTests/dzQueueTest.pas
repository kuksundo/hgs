unit dzQueueTest;

interface

uses
  Classes;

type
  TMyObject = class

  end;

{$DEFINE __QUEUE_TEMPLATE__}
type
  _QUEUE_ANCESTOR_ = TObject;
  _QUEUE_CONTAINER_TYPE_ = TList;
  _LIST_CONTAINER_ITEM_TYPE_ = Pointer;
  _QUEUE_ITEM_ = TMyObject;
{$INCLUDE 't_dzQueueTemplate.tpl'}

type
  {: Queue for storing TMyObject items }
  TMyQueue = class(_QUEUE_TEMPLATE_)
  protected
    { TODO : Make sure the queue is empty when it is destroyed or
             write a destructor that frees any items left in the queue }
  end;

implementation

{$INCLUDE 't_dzQueueTemplate.tpl'}

end.

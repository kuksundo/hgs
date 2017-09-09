unit dzStackTest;

interface

uses
  SysUtils,
  Classes;

type
  TMyObject = class

  end;

{$DEFINE __STACK_TEMPLATE__}
type
  _STACK_CONTAINER_TYPE_ = TList; // or TInterfaceList
  _STACK_ANCESTOR_ = TObject; // or TInterfacedObject
  _LIST_CONTAINER_ITEM_TYPE_ = pointer; // or IInterface
  _STACK_ITEM_ = TMyObject;
{$INCLUDE 't_dzStackTemplate.tpl'}

type
  {: Stack to store TMyObject items }
  TMyStack = class(_STACK_TEMPLATE_)
    { TODO : Make sure the stack is empty on destruction or write a destructor
             that frees its content }
  end;

implementation

{$INCLUDE 't_dzStackTemplate.tpl'}

end.


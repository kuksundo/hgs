unit dzObjStackTest;

interface

uses
  SysUtils,
  Classes;

type
  TMyObject = class

  end;

{$DEFINE __OBJECT_STACK_TEMPLATE__}
type
  _STACK_CONTAINER_TYPE_ = TList; // or TInterfaceList
  _LIST_CONTAINER_ITEM_TYPE_ = pointer; // or IInterface
  _STACK_ANCESTOR_ = TObject; // or TInterfacedObject
  _STACK_ITEM_ = TMyObject;
{$INCLUDE 't_dzObjectStackTemplate.tpl'}

type
  {: Stack to store TMyObject items, Destructor automatcially calls the Item's Free method. }
  TMyStack = class(_OBJECT_STACK_TEMPLATE_)
  end;

implementation

{$INCLUDE 't_dzObjectStackTemplate.tpl'}

end.

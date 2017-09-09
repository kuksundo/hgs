unit dzObjListTest;

interface

uses
  Classes;

type
  TMyObject = class

  end;

{$DEFINE __DZ_OBJECT_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _ITEM_TYPE_ = TMyObject;
{$INCLUDE 't_dzObjectListTemplate.tpl'}

type
  {: List for storing TMyObject items }
  TMyList = class(_DZ_OBJECT_LIST_TEMPLATE_)

  end;

implementation

{$INCLUDE 't_dzObjectListTemplate.tpl'}

end.


unit dzIntSortedObjListTest;

interface

uses
  Classes,
  u_dzTranslator,
  u_dzQuicksort;

type
  TMyObject = class
    Key: integer;
  end;

{$DEFINE __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _ITEM_TYPE_ = TMyObject;
{$INCLUDE 't_dzIntegerSortedObjectListTemplate.tpl'}

type
  {: List for storing TMyObject items sorted by Integer }
  TMyList = class(_DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_)
  protected
    {: return the key of an item for comparison }
    function KeyOf(const _Item: TMyObject): Integer; override;
  end;

implementation

{$INCLUDE 't_dzIntegerSortedObjectListTemplate.tpl'}

function TMyList.KeyOf(const _Item: TMyObject): Integer;
begin
  { TODO : return the key of an item for comparison }
  Result := _Item.Key;
end;

end.


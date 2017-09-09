unit dzSortedListTest;

interface

uses
  Classes,
  u_dzTranslator,
  u_dzQuicksort;

type
  TMyObject = class
    Key: integer;
  end;

{$DEFINE __DZ_SORTED_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _LIST_CONTAINER_ = TList;
  _LIST_CONTAINER_ITEM_TYPE_ = pointer;
  _ITEM_TYPE_ = TMyObject;
  _KEY_TYPE_ = Integer;
{$INCLUDE 't_dzSortedListTemplate.tpl'}

type
  {: Sorted list for storing TMyObject items sorted by Integer }
  TMyList = class(_DZ_SORTED_LIST_TEMPLATE_)
  protected
    {: return the key of an item for comparison }
    function KeyOf(const _Item: TMyObject): Integer; override;
    {: compare the keys of two items, must return a value
       < 0 if Key1 < Key2, = 0 if Key1 = Key2 and > 0 if Key1 > Key2 }
    function Compare(const _Key1, _Key2: Integer): integer; override;
    {: Frees a TMyObject }
    procedure FreeItem(_Item: TMyObject); override;
  end;

implementation

{$INCLUDE 't_dzSortedListTemplate.tpl'}

function TMyList.KeyOf(const _Item: TMyObject): Integer;
begin
  Result := _Item.Key;
end;

function TMyList.Compare(const _Key1, _Key2: Integer): integer;
begin
  Result := _Key1 - _Key2;
end;

procedure TMyList.FreeItem(_Item: TMyObject);
begin
  _Item.Free;
end;

end.


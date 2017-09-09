unit dzListTest;

interface

uses
  Classes;

type
  TMyObject = class

  end;

{$DEFINE __DZ_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _LIST_CONTAINER_ = TList;
  _LIST_CONTAINER_ITEM_TYPE_ = pointer; 
  _ITEM_TYPE_ = TMyObject;
{$INCLUDE 't_dzListTemplate.tpl'}

type
  {: List for storing TMyObject items }
  TMyList = class(_DZ_LIST_TEMPLATE_)
  protected
    {: Frees a TMyObject }
    procedure FreeItem(_Item: TMyObject); override;
  end;

implementation

{$INCLUDE 't_dzListTemplate.tpl'}

procedure TMyList.FreeItem(_Item: TMyObject);
begin
  _Item.Free;
end;

end.

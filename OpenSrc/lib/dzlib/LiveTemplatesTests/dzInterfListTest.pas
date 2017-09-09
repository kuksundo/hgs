unit dzInterfListTest;

interface

uses
  Classes;

type
  IMyInterface = interface

  end;

{$DEFINE __DZ_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _LIST_CONTAINER_ = TInterfaceList;
  _LIST_CONTAINER_ITEM_TYPE_ = IInterface;
  _ITEM_TYPE_ = IMyInterface;
{$INCLUDE 't_dzListTemplate.tpl'}

type
  TMyInterfaceList = class(_DZ_LIST_TEMPLATE_)
  protected
    {: Frees a IMyInterface }
    procedure FreeItem(_Item: IMyInterface); override;
  end;

implementation

{$INCLUDE 't_dzListTemplate.tpl'}

procedure TMyInterfaceList.FreeItem(_Item: IMyInterface);
begin
  // Do nothing, Items are interfaces and therefore automatically
  // freed.
end;

end.

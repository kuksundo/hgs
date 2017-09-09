{: This unit declares an example class to be stored in TMyItemList and / or TMySortedItemList
   and a compare event type for TMysortedItemList }
unit u_MyItem;

interface

type
  IMyItem = interface ['{93F4E978-6F59-44BB-BF1C-6B53E4C80C75}']
    function GetKey: integer;

    property Key: integer read GetKey;
  end;

type
  {: This is the class stored in the TMyItemList and TMySortedItemList examples }
  TMyItem = class(TInterfacedObject, IMyItem)
  private
    {: just one field, an integer Key (TMySortedItemList sorts by it)}
    FKey: integer;
    function GetKey: integer;
  public
    {: standard constructor, supplies the Key }
    constructor Create(_Key: integer);
    {: property for read access to the field }
    property Key: integer read GetKey;
  end;

//type
//  {: This event type declaration is used in TMySortedItemList for sorting }
//  TOnCompareItems = function(_Item1, _Item2: TMyItem): integer of object;

implementation

{ TMyItem }

constructor TMyItem.Create(_Key: integer);
begin
  inherited Create;
  FKey := _Key;
end;

function TMyItem.GetKey: integer;
begin
  Result := FKey;
end;

end.


{$IFNDEF __DZ_LIST_INTERFACE_TEMPLATE__}
unit t_dzListInterfaceTemplate;

interface

/// These types must be declared by the class based on this template
type
  /// the object type to be stored in the list
  _ITEM_TYPE_ = TObject;
{$ENDIF __DZ_LIST_INTERFACE_TEMPLATE__}

{$IFNDEF __DZ_LIST_INTERFACE_TEMPLATE_SECOND_PASS__}

type
  /// This interface declares all public methods a _DZ_LIST_TEMPLATE_ implements
  _DZ_LIST_INTERFACE_TEMPLATE_ = interface
    /// Getter method for the Items property
    function _GetItems(_Idx: integer): _ITEM_TYPE_;
    /// Returns the number of items stored in the list
    function Count: integer;
    /// Deletes all items from the list without calling FreeItem, see also FreeAll
    procedure DeleteAll;
    /// Exchanges the two items at index Idx1 and Idx2
    procedure Exchange(_Idx1, _Idx2: integer);
    /// removes the item with index Idx from the list and returns it
    function Extract(_Idx: integer): _ITEM_TYPE_;
    /// Calls FreeItem for all items and removes them from the list
    procedure Clear;
    /// Add an item into the list and returns its index
    function Add(_Item: _ITEM_TYPE_): integer;
    /// allows accessing the items in the list by index
    property Items[_Idx: integer]: _ITEM_TYPE_ read _GetItems; default;
  end;

{$ENDIF __DZ_LIST_INTERFACE_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_LIST_INTERFACE_TEMPLATE__}
{$DEFINE __DZ_LIST_INTERFACE_TEMPLATE_SECOND_PASS__}
implementation
{$ENDIF __DZ_LIST_INTERFACE_TEMPLATE__}

{$DEFINE __DZ_LIST_INTERFACE_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_LIST_INTERFACE_TEMPLATE__}
{$WARNINGS OFF}
end.
{$ENDIF __DZ_LIST_INTERFACE_TEMPLATE__}


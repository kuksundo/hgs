{$IFNDEF __DZ_SORTED_LIST_INTERFACE_TEMPLATE__}
unit t_dzSortedListInterfaceTemplate;

interface

type
  _ITEM_TYPE_ = TObject;
{$ENDIF __DZ_SORTED_LIST_INTERFACE_TEMPLATE__}

{$IFNDEF __DZ_SORTED_LIST_INTERFACE_TEMPLATE_SECOND_PASS__}

type
  /// This interface declares all public methods of _DZ_SORTED_LIST_TEMPLATE_
  _DZ_SORTED_LIST_INTERFACE_TEMPLATE_ = interface
    /// getter function for Items property
    function _GetItems(_Idx: integer): _ITEM_TYPE_;
    /// returns the number of items stored in the list
    function Count: integer;
    /// deletes all items without freeing them, see also FreeAll
    procedure DeleteAll;
    /// exchanges the items at index Idx1 and Idx2
    procedure Exchange(_Idx1, _Idx2: integer);
    /// removes the item with index Idx from the list and returns it
    function Extract(_Idx: integer): _ITEM_TYPE_;
    /// frees all items and removes them from the list
    procedure FreeAll;
    /// inserts an item into the list
    function Insert(_Item: _ITEM_TYPE_): integer;
    /// searches for the item with the given Key
    /// @param Key is the sought item's key
    /// @param Idx is the index of the item, if found, only valid if the function returns true
    /// @returns true, if the item has been found, false otherwise }
    function Find(_Key: _KEY_TYPE_; out _Idx: integer): boolean; overload;
    function Search(_Key: _KEY_TYPE_; out _Idx: integer): boolean; overload; deprecated; // use Find instead
{$IFNDEF __DZ_SORTED_LIST_INTERFACE_TEMPLATE_ITEM_TYPE_IS_INTEGER__}
    /// searches for the item with the given key
    /// @param Key is the sought item's key
    /// @param Item is the item, if found, only valid if the function returns true
    /// @returns true, if the item has been found, false otherwise
    /// @note: if ITEM_TYPE = integer we can not create overloaded Search methods,
    ///        in this case declare the conditional define above in your unit. }
    function Find(_Key: _KEY_TYPE_; out _Item: _ITEM_TYPE_): boolean; overload;
    function Search(_Key: _KEY_TYPE_; out _Item: _ITEM_TYPE_): boolean; overload; deprecated;
{$ENDIF __DZ_SORTED_LIST_INTERFACE_TEMPLATE_ITEM_TYPE_IS_INTEGER__}
    /// this property allows accessing the items by index
    property Items[_Idx: integer]: _ITEM_TYPE_ read _GetItems;
  end;

{$ENDIF __DZ_SORTED_LIST_INTERFACE_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_SORTED_LIST_INTERFACE_TEMPLATE__}
{$DEFINE __DZ_SORTED_LIST_INTERFACE_TEMPLATE_SECOND_PASS__}
implementation
{$ENDIF __DZ_SORTED_LIST_INTERFACE_TEMPLATE__}

{$DEFINE __DZ_SORTED_LIST_INTERFACE_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_SORTED_LIST_INTERFACE_TEMPLATE__}
{$WARNINGS OFF}
end.
{$ENDIF __DZ_SORTED_LIST_INTERFACE_TEMPLATE__}


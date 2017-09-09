{$IFNDEF __DZ_INTEGER_SORTED_LIST_TEMPLATE__}
unit t_dzIntegerSortedListTemplate;

interface

/// any class built on this template must add these units to the uses clause
uses
  Classes,
  u_dzQuicksort;

/// these types must be declared for any class built on this template
type
   /// This is the list's ancestor class, can be a user defined class if you
   /// want to inherit additional behaviour or TInterfacedObject if you
   /// want the list to implement an interface
  _LIST_PARENT_ = TInterfacedObject;
  /// The type of items to be stored in the list, can be any type that can be
  /// typecasted to pointer
  _ITEM_TYPE_ = pointer;

{$ENDIF __DZ_INTEGER_SORTED_LIST_TEMPLATE__}

{$IFNDEF __DZ_SORTED_LIST_TEMPLATE_SECOND_PASS__}

{$DEFINE __DZ_SORTED_LIST_TEMPLATE__}
type
  _KEY_TYPE_ = integer;
{$INCLUDE 't_dzSortedListTemplate.tpl'}

type
  /// This extends _DZ_SORTED_LIST_TEMPLATE for storing items that are sorted by an
  /// integer number, any class built on this template must implement the KeyOf method
  /// to return an integer.
  _DZ_INTEGER_SORTED_LIST_TEMPLATE_ = class(_DZ_SORTED_LIST_TEMPLATE_)
  protected
    /// compares two keys, returns 0 if they are equal, >0 if Key1>Key2 and <0 if Key1<Key2
    function Compare(const _Key1, _Key2: integer): integer; override;
  end;

{$ENDIF __DZ_INTEGER_SORTED_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_INTEGER_SORTED_LIST_TEMPLATE__}
{$DEFINE __DZ_INTEGER_SORTED_LIST_TEMPLATE_SECOND_PASS__}
implementation
{$ENDIF __DZ_INTEGER_SORTED_LIST_TEMPLATE__}

{$IFDEF __DZ_INTEGER_SORTED_LIST_TEMPLATE_SECOND_PASS__}

{ _DZ_INTEGER_SORTED_LIST_TEMPLATE_ }

{$INCLUDE 't_dzSortedListTemplate.tpl'}

function _DZ_INTEGER_SORTED_LIST_TEMPLATE_.Compare(const _Key1, _Key2: integer): integer;
begin
  Result := _Key1 - _Key2;
end;

{$ENDIF __DZ_INTEGER_SORTED_LIST_TEMPLATE_SECOND_PASS__}

{$DEFINE __DZ_INTEGER_SORTED_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_INTEGER_SORTED_LIST_TEMPLATE__}
{$WARNINGS OFF}
end.
{$ENDIF __DZ_INTEGER_SORTED_LIST_TEMPLATE__}


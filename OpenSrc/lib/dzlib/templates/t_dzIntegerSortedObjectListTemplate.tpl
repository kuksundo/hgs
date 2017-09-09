{$IFNDEF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE__}
/// This unit declares a template for storing objects sorted by integers
/// Usage: See u_MyItemSortedList example
unit t_dzIntegerSortedObjectListTemplate;

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
  _LIST_ANCESTOR_ = TInterfacedObject;
  /// The type of items to be stored in the list, must be TObject or a descendant
  /// of TObject
  _ITEM_TYPE_ = TObject;

{$ENDIF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE__}

{$IFNDEF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$DEFINE __DZ_SORTED_OBJECT_LIST_TEMPLATE__}
type
  /// we sort by an integer key returned by the KeyOf method
  _KEY_TYPE_ = integer;
{$INCLUDE 't_dzSortedObjectListTemplate.tpl'}

type
  /// This extends _DZ_SORTED_OBJECT_LIST_TEMPLATE_ to store objects sorted by
  /// an integer number, any class built on this template must implement the KeyOf method
  /// so it returns an integer. }
  _DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_ = class(_DZ_SORTED_OBJECT_LIST_TEMPLATE_)
  protected
    /// compares two keys, returns 0 if they are equal, >0 if Key1>Key2 and <0 if Key1<Key2
    function Compare(const _Key1, _Key2: integer): integer; override;
  end;

{$ENDIF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE__}
{$DEFINE __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}
implementation
{$ENDIF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE__}

{$IFDEF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$INCLUDE 't_dzSortedObjectListTemplate.tpl'}

function _DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_.Compare(const _Key1, _Key2: integer): integer;
begin
  Result := _Key1 - _Key2;
end;

{$ENDIF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$DEFINE __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE__}
{$WARNINGS OFF}
end.
{$ENDIF __DZ_INTEGER_SORTED_OBJECT_LIST_TEMPLATE__}


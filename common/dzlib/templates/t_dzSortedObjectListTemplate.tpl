{$IFNDEF __DZ_SORTED_OBJECT_LIST_TEMPLATE__}
unit t_dzSortedObjectListTemplate;

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
  _LIST_PARENT_ = TObject;
  /// The type of items to be stored in the list, must be TObject or a descendant
  /// of TObject
  _ITEM_TYPE_ = TObject;

{$ENDIF __DZ_SORTED_OBJECT_LIST_TEMPLATE__}

{$IFNDEF __DZ_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$DEFINE __DZ_SORTED_LIST_TEMPLATE__}
type
  _LIST_CONTAINER_ = TList;
  _LIST_CONTAINER_ITEM_TYPE_ = pointer;

{$INCLUDE 't_dzSortedListTemplate.tpl'}

type
  /// Extends _DZ_SORTED_LIST_TEMPLATE_ to call the item's Free method in FreeItem
  /// thereby allowing to store any TObject descendant.
  _DZ_SORTED_OBJECT_LIST_TEMPLATE_ = class(_DZ_SORTED_LIST_TEMPLATE_)
  private
    FOwnsObjects: Boolean;
  protected
    /// calls the Item's Free method if OwnsObject is true (which it is by default)
    procedure FreeItem(_Item: _ITEM_TYPE_); override;
  public
    constructor Create; 
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

{$ENDIF __DZ_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_SORTED_OBJECT_LIST_TEMPLATE__}
{$DEFINE __DZ_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}
implementation
{$ENDIF __DZ_SORTED_OBJECT_LIST_TEMPLATE__}

{$IFDEF __DZ_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{ _DZ_SORTED_OBJECT_LIST_TEMPLATE_ }

{$INCLUDE 't_dzSortedListTemplate.tpl'}

constructor _DZ_SORTED_OBJECT_LIST_TEMPLATE_.Create;
begin
  inherited;
  FOwnsObjects := True;
end;

procedure _DZ_SORTED_OBJECT_LIST_TEMPLATE_.FreeItem(_Item: _ITEM_TYPE_);
begin
  if FOwnsObjects then
    _Item.Free;
end;

{$ENDIF __DZ_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$DEFINE __DZ_SORTED_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_SORTED_OBJECT_LIST_TEMPLATE__}
{$WARNINGS OFF}
end.
{$ENDIF __DZ_SORTED_OBJECT_LIST_TEMPLATE__}


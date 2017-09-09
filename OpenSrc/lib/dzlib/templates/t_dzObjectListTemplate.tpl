{$IFNDEF __DZ_OBJECT_LIST_TEMPLATE__}
unit t_dzObjectListTemplate;

interface

/// any class built on this template must add these units to the uses clause
uses
  Classes,
  u_dzQuicksort;

/// these types must be declared for any class built on this template
type
  /// the ancestor class for the template, can be TObject or TInterfacedObject
  /// or anything else you like
  _LIST_ANCESTOR_ = TInterfacedObject;
  {: The item type to be stored in the list }
  _ITEM_TYPE_ = TObject;

{$ENDIF __DZ_OBJECT_LIST_TEMPLATE__}

{$IFNDEF __DZ_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$DEFINE __DZ_LIST_TEMPLATE__}
type
  /// Container type used to actually store the items is TList
  _LIST_CONTAINER_ = TList;
  /// The native item type of the list container is pointer for TList
  _LIST_CONTAINER_ITEM_TYPE_ = pointer;

{$INCLUDE 't_dzListTemplate.tpl'}

type
  /// Extends _DZ_LIST_TEMPLATE_ to call Item.Free in FreeItem, so any
  /// items derived from TObject can be stored without having to free them
  /// explicitly.
  _DZ_OBJECT_LIST_TEMPLATE_ = class(_DZ_LIST_TEMPLATE_)
  private
    FOwnsObjects: Boolean;
  protected
    /// Calls _Item.Free if OwnsObject is true (default: true)
    procedure FreeItem(_Item: _ITEM_TYPE_); override;
  public
    constructor Create; 
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

{$ENDIF __DZ_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_OBJECT_LIST_TEMPLATE__}
{$DEFINE __DZ_OBJECT_LIST_TEMPLATE_SECOND_PASS__}
implementation
{$ENDIF __DZ_OBJECT_LIST_TEMPLATE__}

{$IFDEF __DZ_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{ _DZ_OBJECT_LIST_TEMPLATE_ }

{$INCLUDE 't_dzListTemplate.tpl'}

constructor _DZ_OBJECT_LIST_TEMPLATE_.Create;
begin
  inherited;
  FOwnsObjects := True;
end;

procedure _DZ_OBJECT_LIST_TEMPLATE_.FreeItem(_Item: _ITEM_TYPE_);
begin
  if FOwnsObjects then
    _Item.Free;
end;

{$ENDIF __DZ_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$DEFINE __DZ_OBJECT_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_OBJECT_LIST_TEMPLATE__}
{$WARNINGS OFF}
end.
{$ENDIF __DZ_OBJECT_LIST_TEMPLATE__}


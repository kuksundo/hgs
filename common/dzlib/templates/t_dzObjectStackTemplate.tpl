{$IFNDEF __OBJECT_STACK_TEMPLATE__}
unit t_dzObjectStackTemplate;

interface

uses
  Classes;

type
  _STACK_ITEM_ = TObject;
  _STACK_CONTAINER_TYPE_ = TList; // or TInterfaceList
  _STACK_ANCESTOR_ = TObject; // or TInterfacedObject

{$ENDIF __OBJECT_STACK_TEMPLATE__}

{$IFNDEF __OBJECT_STACK_TEMPLATE_SECOND_PASS__}

{$DEFINE __STACK_TEMPLATE__}
{$INCLUDE 't_dzStackTemplate.tpl'}

type
  /// extends _STACK_TEMPLATE_ to store objects on the stack.
  /// the destructor frees all items left on the stack by calling their Free method
  _OBJECT_STACK_TEMPLATE_ = class(_STACK_TEMPLATE_)
  protected
    procedure FreeItem(_Item: _STACK_ITEM_); override;
  public
  end;

{$ENDIF __OBJECT_STACK_TEMPLATE_SECOND_PASS__}

{$IFNDEF __OBJECT_STACK_TEMPLATE__}
implementation
{$DEFINE __OBJECT_STACK_TEMPLATE_SECOND_PASS__}
{$ENDIF __OBJECT_STACK_TEMPLATE__}

{$IFDEF __OBJECT_STACK_TEMPLATE_SECOND_PASS__}

{ _OBJECT_STACK_TEMPLATE_ }

{$INCLUDE 't_dzStackTemplate.tpl'}

procedure _OBJECT_STACK_TEMPLATE_.FreeItem(_Item: _STACK_ITEM_);
begin
  FreeAndNil(_Item);
end;

{$ENDIF __OBJECT_STACK_TEMPLATE_SECOND_PASS__}

{$IFNDEF __OBJECT_STACK_TEMPLATE__}
{$WARNINGS off}
end.
{$ELSE __OBJECT_STACK_TEMPLATE__}

{$DEFINE __OBJECT_STACK_TEMPLATE_SECOND_PASS__}

{$ENDIF __OBJECT_STACK_TEMPLATE__}


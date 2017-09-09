{$IFNDEF __STACK_TEMPLATE__}
unit t_dzStackTemplate;

interface

uses
  Classes;

type
  /// The item type to store on the stack
  _STACK_ITEM_ = integer;
  /// the container type to actually store the items (TList or TInterfaceList)
  _STACK_CONTAINER_TYPE_ = TList;
  /// the native item type of the used container (pointer for TList, IInterface for TInterfaceList)
  _LIST_CONTAINER_ITEM_TYPE_ = pointer;
  /// the ancstor type of the stack class, can be TObject or any descendant
  _STACK_ANCESTOR_ = TObject;

{$ENDIF __STACK_TEMPLATE__}

{$IFNDEF __STACK_TEMPLATE_SECOND_PASS__}

type
  /// implements a stack for storing _STACK_ITEM_ items
  _STACK_TEMPLATE_ = class(_STACK_ANCESTOR_)
  private
    FList: _STACK_CONTAINER_TYPE_;
  protected
    ///<summary> does nothing, override, if the items need to be freed </summary>
    procedure FreeItem(_Item: _STACK_ITEM_); virtual;
  public
    /// creates a new _STACK_TEMPLATE_ instance
    constructor Create;
    destructor Destroy; override;
    /// adds a new item to the top of the stack
    procedure Push(_Item: _STACK_ITEM_);
    /// removes the topmost item from the stack and returns it
    function Pop: _STACK_ITEM_; overload;
    /// remove the topmost item from the stack, if it exists
    /// @param Item is the topmost item, only valid if result = true
    /// @returns true, if the stack is not empty, false otherwise
    function Pop(out _Item: _STACK_ITEM_): boolean; overload;
    /// returns the topmost item from the stack without removing it
    function Peek: _STACK_ITEM_; overload;
    /// get the topmost item of the stack if it exists, without removing it
    /// @Item is the topmost item, only valid if result = true
    /// @returns true, if the stack is not empty, false otherwise
    function Peek(out _Item: _STACK_ITEM_): boolean; overload;
    /// returns true, if the stack is empty, false otherwise
    function IsEmpty: boolean;
    /// returns the depth of the stack
    function Depth: integer;
    ///<summary> Pops all items from the stack </summary>
    procedure Clear;
  end;

{$ENDIF __STACK_TEMPLATE_SECOND_PASS__}

{$IFNDEF __STACK_TEMPLATE__}
implementation
{$DEFINE __STACK_TEMPLATE_SECOND_PASS__}
{$ENDIF __STACK_TEMPLATE__}

{$IFDEF __STACK_TEMPLATE_SECOND_PASS__}

{ _STACK_TEMPLATE_ }

constructor _STACK_TEMPLATE_.Create;
begin
  inherited Create;
  FList := _STACK_CONTAINER_TYPE_.Create;
end;

destructor _STACK_TEMPLATE_.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited;
end;

function _STACK_TEMPLATE_.Depth: integer;
begin
  Result := FList.Count;
end;

procedure _STACK_TEMPLATE_.Push(_Item: _STACK_ITEM_);
begin
  FList.Add(_LIST_CONTAINER_ITEM_TYPE_(_Item));
end;

function _STACK_TEMPLATE_.Pop: _STACK_ITEM_;
begin
  Assert(FList.Count >= 0);

  Result := _STACK_ITEM_(FList[FList.Count - 1]);
  FList.Delete(FList.Count - 1);
end;

function _STACK_TEMPLATE_.Pop(out _Item: _STACK_ITEM_): boolean;
begin
  Result := not IsEmpty;
  if Result then begin
    _Item := _STACK_ITEM_(FList[FList.Count - 1]);
    FList.Delete(FList.Count - 1);
  end;
end;

function _STACK_TEMPLATE_.Peek: _STACK_ITEM_;
begin
  Assert(FList.Count >= 0);

  Result := _STACK_ITEM_(FList[FList.Count - 1]);
end;

function _STACK_TEMPLATE_.Peek(out _Item: _STACK_ITEM_): boolean;
begin
  Result := not IsEmpty;
  if Result then
    _Item := _STACK_ITEM_(FList[FList.Count - 1]);
end;

function _STACK_TEMPLATE_.IsEmpty: boolean;
begin
  Result := FList.Count = 0;
end;

procedure _STACK_TEMPLATE_.FreeItem(_Item: _STACK_ITEM_);
begin
  // nothing to do
end;

procedure _STACK_TEMPLATE_.Clear;
begin
  while not IsEmpty do
    FreeItem(Pop);
end;

{$ENDIF __STACK_TEMPLATE_SECOND_PASS__}

{$IFNDEF __STACK_TEMPLATE__}
{$WARNINGS off}
end.
{$ELSE __STACK_TEMPLATE__}

{$DEFINE __STACK_TEMPLATE_SECOND_PASS__}

{$ENDIF __STACK_TEMPLATE__}


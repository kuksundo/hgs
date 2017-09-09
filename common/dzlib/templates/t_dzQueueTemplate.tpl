{$IFNDEF __QUEUE_TEMPLATE__}
unit t_dzQueueTemplate;

interface

uses
  Classes,
  u_MyItem;

type
  /// The type of items to be stored in the queue
  _QUEUE_ITEM_ = integer;
  /// the container used to actually store the items, TList or TInterfaceList
  _QUEUE_CONTAINER_TYPE_ = TList;
  /// the item type stored in the container
  _LIST_CONTAINER_ITEM_TYPE_ = Pointer;
  /// the ancestor class for the queue, can be TObject or any descendant
  _QUEUE_ANCESTOR_ = TObject;

{$ENDIF __QUEUE_TEMPLATE__}

{$IFNDEF __QUEUE_TEMPLATE_SECOND_PASS__}

type
  /// Template for a queue for storing _QUEUE_ITEM_ items
  _QUEUE_TEMPLATE_ = class(_QUEUE_ANCESTOR_)
  private
    /// actually store the items
    FList: _QUEUE_CONTAINER_TYPE_;
  public
    /// Creates a new _QUEUE_TEMPLATE_ instance
    constructor Create;
    destructor Destroy; override;
    /// adds an item to the end of the queue
    procedure Enqueue(_Item: _QUEUE_ITEM_);
    /// removes the first item from the queue and returns it
    function Dequeue: _QUEUE_ITEM_; overload;
    /// removes the first item from the queue
    /// @param Item contains the dequeued item, only valid if result is true 
    /// @returns true, if an item was dequeued, false otherwise
    function Dequeue(out _Item: _QUEUE_ITEM_): boolean; overload;
    /// returns the first item in the queue without removing it
    function Peek: _QUEUE_ITEM_; overload;
    /// returns the first item in the queue without removing it
    /// @param Item is the first item, only valid if result is true
    /// @returns true, if the queue was not emtpy, false otherwise
    function Peek(out _Item: _QUEUE_ITEM_): boolean; overload;
    /// returns true, if the queue is emtpy, false otherwise
    function IsEmpty: boolean;
    /// returns the length of the queue
    function Count: integer;
  end;

{$ENDIF __QUEUE_TEMPLATE_SECOND_PASS__}

{$IFNDEF __QUEUE_TEMPLATE__}
implementation
{$DEFINE __QUEUE_TEMPLATE_SECOND_PASS__}
{$ENDIF __QUEUE_TEMPLATE__}

{$IFDEF __QUEUE_TEMPLATE_SECOND_PASS__}

{ _QUEUE_TEMPLATE_ }

constructor _QUEUE_TEMPLATE_.Create;
begin
  inherited Create;
  FList := _QUEUE_CONTAINER_TYPE_.Create;
end;

destructor _QUEUE_TEMPLATE_.Destroy;
begin
  FList.Free;
  inherited;
end;

function _QUEUE_TEMPLATE_.Count: integer;
begin
  Result := FList.Count;
end;

procedure _QUEUE_TEMPLATE_.Enqueue(_Item: _QUEUE_ITEM_);
begin
  FList.Insert(0, _LIST_CONTAINER_ITEM_TYPE_(_Item));
end;

function _QUEUE_TEMPLATE_.Dequeue: _QUEUE_ITEM_;
var
  Idx: integer;
begin
  Idx := FList.Count - 1;
  Assert(Idx >= 0);

  Result := _QUEUE_ITEM_(FList[Idx]);
  FList.Delete(Idx);
end;

function _QUEUE_TEMPLATE_.Dequeue(out _Item: _QUEUE_ITEM_): boolean;
var
  Idx: integer;
begin
  Idx := FList.Count - 1;
  Result := (Idx >= 0);
  if Result then begin
    _Item := _QUEUE_ITEM_(FList[Idx]);
    FList.Delete(Idx);
  end;
end;

function _QUEUE_TEMPLATE_.Peek: _QUEUE_ITEM_;
begin
  Assert(FList.Count >= 0);

  Result := _QUEUE_ITEM_(FList[FList.Count - 1]);
end;

function _QUEUE_TEMPLATE_.Peek(out _Item: _QUEUE_ITEM_): boolean;
begin
  Result := not IsEmpty;
  if Result then
    _Item := _QUEUE_ITEM_(FList[FList.Count - 1]);
end;

function _QUEUE_TEMPLATE_.IsEmpty: boolean;
begin
  Result := (FList.Count = 0);
end;

{$ENDIF __QUEUE_TEMPLATE_SECOND_PASS__}

{$IFNDEF __QUEUE_TEMPLATE__}
{$WARNINGS off}
end.
{$ELSE __QUEUE_TEMPLATE__}

{$DEFINE __QUEUE_TEMPLATE_SECOND_PASS__}

{$ENDIF __QUEUE_TEMPLATE__}


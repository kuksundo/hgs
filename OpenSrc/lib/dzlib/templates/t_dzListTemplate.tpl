{$IFNDEF __DZ_LIST_TEMPLATE__}
unit t_dzListTemplate;

interface

/// These units must be added to the uses clause of any class built on this template
uses
  Classes;

/// These types must be declared for each class built on this template
type
  /// the ancestor class for the template, can be TObject or TInterfacedObject
  /// or anything else you like
  _LIST_ANCESTOR_ = TInterfacedObject;
  /// Container type used to actually store the items: TList or TInterfacelist
  _LIST_CONTAINER_ = TList;
  /// The native item type of the list container (Pointer for TList, IInterface for TInterfaceList
  _LIST_CONTAINER_ITEM_TYPE_ = pointer;
  /// The item type to be stored in the list
  _ITEM_TYPE_ = TObject;

{$ENDIF __DZ_LIST_TEMPLATE__}

{$IFNDEF __DZ_LIST_TEMPLATE_SECOND_PASS__}

type
  _DZ_LIST_TEMPLATE_ = class(_LIST_ANCESTOR_)
  {(*}
  private
    type
      /// This enumerator allows for..in style loops
      TEnumerator = record
      private
        FIdx: integer;
        FList: _DZ_LIST_TEMPLATE_;
        function GetCurrent: _ITEM_TYPE_; inline;
      public
        constructor Create(_List: _DZ_LIST_TEMPLATE_);
        function MoveNext: boolean; inline;
        property Current: _ITEM_TYPE_ read GetCurrent;
      end;
  {*)}
  private
    /// This actually stores the items
    FItems: _LIST_CONTAINER_;
    /// Getter function for Items property
    function _GetItems(_Idx: integer): _ITEM_TYPE_;
  protected
    /// Frees an item (does nothing here, must be overwritten)
    procedure FreeItem(_Item: _ITEM_TYPE_); virtual;
  public
    /// Creates a list for storing items
    constructor Create;
    /// Calls FreeItem for alle items and frees the list
    destructor Destroy; override;
    /// inserts an item a the given position
    procedure AtInsert(_Idx: integer; _Item: _ITEM_TYPE_);
    /// Returns the number of items stored in the list
    function Count: integer;
    /// Deletes all items from the list without calling FreeItem, see also Clear
    procedure DeleteAll;
    /// Exchanges the two items at index Idx1 and Idx2
    procedure Exchange(_Idx1, _Idx2: integer);
    /// removes the item with index Idx from the list and returns it
    function Extract(_Idx: integer): _ITEM_TYPE_;
    /// calls Clear
    procedure FreeAll; deprecated; // use Clear instead
    /// Calls FreeItem for all items and removes them from the list
    procedure Clear;
    /// returns the index of the given item or -1 if it is not in the list
    function IndexOf(_Item: _ITEM_TYPE_): integer;
    /// inserts an item into the list and returns its index
    function Insert(_Item: _ITEM_TYPE_): integer; deprecated; // use Add instead
    /// adds an item into the list and returns its index
    function Add(_Item: _ITEM_TYPE_): integer; virtual;
    /// allows for..in style loops
    function GetEnumerator: TEnumerator;
    /// short for Items[0]
    function GetFirstItem: _ITEM_TYPE_;
    /// short for Items[Count-1];
    function GetLastItem: _ITEM_TYPE_;
    /// allows accessing the items in the list by index
    property Items[_Idx: integer]: _ITEM_TYPE_ read _GetItems; default;
  end;

{$ENDIF __DZ_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_LIST_TEMPLATE__}
{$DEFINE __DZ_LIST_TEMPLATE_SECOND_PASS__}
implementation
{$ENDIF __DZ_LIST_TEMPLATE__}

{$IFDEF __DZ_LIST_TEMPLATE_SECOND_PASS__}

{ _DZ_LIST_TEMPLATE_ }

function _DZ_LIST_TEMPLATE_.Count: integer;
begin
  Result := FItems.Count;
end;

constructor _DZ_LIST_TEMPLATE_.Create;
begin
  inherited Create;
  FItems := _LIST_CONTAINER_.Create;
end;

procedure _DZ_LIST_TEMPLATE_.DeleteAll;
begin
  FItems.Clear;
end;

destructor _DZ_LIST_TEMPLATE_.Destroy;
var
  i: integer;
  Item: _ITEM_TYPE_;
begin
  if Assigned(FItems) then begin
    for i := 0 to FItems.Count - 1 do begin
      Item := _ITEM_TYPE_(FItems[i]);
      FreeItem(Item);
    end;
  end;
  FItems.Free;
  inherited;
end;

procedure _DZ_LIST_TEMPLATE_.Exchange(_Idx1, _Idx2: integer);
begin
  FItems.Exchange(_Idx1, _Idx2);
end;

function _DZ_LIST_TEMPLATE_.Extract(_Idx: integer): _ITEM_TYPE_;
begin
  Result := _ITEM_TYPE_(FItems[_Idx]);
  Fitems.Delete(_Idx);
end;

procedure _DZ_LIST_TEMPLATE_.FreeAll;
begin
  Clear;
end;

procedure _DZ_LIST_TEMPLATE_.Clear;
var
  i: integer;
begin
  for i := 0 to FItems.Count - 1 do begin
    FreeItem(_ITEM_TYPE_(FItems[i]));
  end;
  FItems.Clear;
end;

procedure _DZ_LIST_TEMPLATE_.FreeItem(_Item: _ITEM_TYPE_);
begin
  // do nothing, override if the items must be freed
end;

function _DZ_LIST_TEMPLATE_._GetItems(_Idx: integer): _ITEM_TYPE_;
begin
  Result := _ITEM_TYPE_(FItems[_Idx]);
end;

function _DZ_LIST_TEMPLATE_.GetFirstItem: _ITEM_TYPE_;
begin
  Result := Items[0];
end;

function _DZ_LIST_TEMPLATE_.GetLastItem: _ITEM_TYPE_;
begin
  Result := Items[Count - 1];
end;

function _DZ_LIST_TEMPLATE_.Insert(_Item: _ITEM_TYPE_): integer;
begin
  Result := Add(_Item);
end;

function _DZ_LIST_TEMPLATE_.Add(_Item: _ITEM_TYPE_): integer;
begin
  Result := FItems.Add(_LIST_CONTAINER_ITEM_TYPE_(_Item));
end;

procedure _DZ_LIST_TEMPLATE_.AtInsert(_Idx: integer; _Item: _ITEM_TYPE_);
begin
  FItems.Insert(_Idx, _LIST_CONTAINER_ITEM_TYPE_(_Item));
end;

function _DZ_LIST_TEMPLATE_.IndexOf(_Item: _ITEM_TYPE_): integer;
begin
  Result := FItems.IndexOf(_LIST_CONTAINER_ITEM_TYPE_(_Item));
end;

function _DZ_LIST_TEMPLATE_.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

constructor _DZ_LIST_TEMPLATE_.TEnumerator.Create(_List: _DZ_LIST_TEMPLATE_);
begin
  FList := _List;
  FIdx := -1;
end;

function _DZ_LIST_TEMPLATE_.TEnumerator.GetCurrent: _ITEM_TYPE_;
begin
  Result := FList[FIdx];
end;

function _DZ_LIST_TEMPLATE_.TEnumerator.MoveNext: boolean;
begin
  Result := (FIdx < FList.Count - 1);
  if Result then
    Inc(FIdx);
end;

{$ENDIF __DZ_LIST_TEMPLATE_SECOND_PASS__}

{$DEFINE __DZ_LIST_TEMPLATE_SECOND_PASS__}

{$IFNDEF __DZ_LIST_TEMPLATE__}
{$WARNINGS OFF}
end.
{$ENDIF __DZ_LIST_TEMPLATE__}


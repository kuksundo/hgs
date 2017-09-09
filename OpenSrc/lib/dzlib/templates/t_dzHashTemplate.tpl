{$IFNDEF __HASH_TEMPLATE__}
unit t_dzHashTemplate;

interface

uses
  Classes,
  u_MyItem;

type
   /// This is the hash's ancestor class, can be a user defined class if you
   /// want to inherit additional behaviour or TInterfacedObject if you
   /// want the hash to implement an interface
  _HASH_ANCESTOR_ = TObject;
  /// The type of items to be stored in the hash, must be TObject or a descendant
  /// of TObject
  _HASH_ITEM_ = TMyItem;
const
  /// value to return if no item was found
  _HASH_EMPTY_ITEM_ = nil;

{$ENDIF __HASH_TEMPLATE__}

{$IFNDEF __HASH_TEMPLATE_SECOND_PASS__}

type
  /// stores items indexed by a string value
  _HASH_TEMPLATE_ = class(_HASH_ANCESTOR_)
  private
    /// stores the actual items
    FList: TStringList;
    /// setter method for the Values property
    procedure SetValues(const _Key: string; _Item: _HASH_ITEM_);
    /// getter method for the Values property
    function GetValues(const _Key: string): _HASH_ITEM_;
    /// getter method for the Keys property
    function GetKeys(_Idx: integer): string;
    /// getter method for the Items property
    function GetItems(_Idx: integer): _HASH_ITEM_;
  public
    /// creates a new _HASH_TEMPLATE_ instance
    constructor Create;
    destructor Destroy; override;
    /// checks whether the hash contains the given key
    function Contains(const _Key: string): boolean;
    /// removes the item with the given key from the hash and returns it
    /// if no item is found, returns _HASH_EMPTY_ITEM_ (= nil)
    function Extract(const _Key: string): _HASH_ITEM_;
    /// checks if an item is in the hash and returns its key if it exists
    function FindKeyOf(_Item: _HASH_ITEM_; out _Key: string): boolean;
    /// returns the keys of all items in the hash
    function GetAllKeys(_Keys: TStrings): integer;
    /// returns the number of items in the hash
    function Count: integer;
    /// returns the key of the Idx th item
    property Keys[_Idx: integer]: string read GetKeys;
    /// returns the Idxth item
    property Items[_Idx: integer]: _HASH_ITEM_ read GetItems;
    /// returns the item that belongs to the given key
    /// if no item is found, returns _HASH_EMPTY_ITEM_ (= nil)
    property Values[const _Key: string]: _HASH_ITEM_ read GetValues write SetValues; default;
  end;

{$ENDIF __HASH_TEMPLATE_SECOND_PASS__}

{$IFNDEF __HASH_TEMPLATE__}
implementation
{$DEFINE __HASH_TEMPLATE_SECOND_PASS__}
{$ENDIF __HASH_TEMPLATE__}

{$IFDEF __HASH_TEMPLATE_SECOND_PASS__}

{ _HASH_TEMPLATE_ }

constructor _HASH_TEMPLATE_.Create;
begin
  inherited Create;
  FList := TStringList.Create;
  Flist.Sorted := true;
  FList.Duplicates := dupError;
end;

destructor _HASH_TEMPLATE_.Destroy;
var
  i: integer;
begin
  if Assigned(FList) then begin
    for i := 0 to FList.Count - 1 do begin
      _HASH_ITEM_(FList.Objects[i]).Free;
    end;
  end;
  FList.Free;
  inherited;
end;

function _HASH_TEMPLATE_.Contains(const _Key: string): boolean;
var
  Idx: integer;
begin
  Result := FList.Find(_Key, Idx);
end;

function _HASH_TEMPLATE_.Count: integer;
begin
  Result := FList.Count;
end;

function _HASH_TEMPLATE_.Extract(const _Key: string): _HASH_ITEM_;
var
  Idx: integer;
begin
  if FList.Find(_Key, Idx) then begin
    Result := _HASH_ITEM_(FList.Objects[Idx]);
    FList.Delete(Idx);
  end else
    Result := _HASH_EMPTY_ITEM_;
end;

function _HASH_TEMPLATE_.FindKeyOf(_Item: _HASH_ITEM_;
  out _Key: string): boolean;
var
  i: integer;
begin
  for i := 0 to FList.Count - 1 do begin
    Result := FList.Objects[i] = _Item;
    if Result then begin
      _Key := FList[i];
      exit;
    end;
  end;
  Result := false;
end;

function _HASH_TEMPLATE_.GetAllKeys(_Keys: TStrings): integer;
begin
  if Assigned(_Keys) then
    _Keys.Assign(FList);
  Result := FList.Count;
end;

function _HASH_TEMPLATE_.GetItems(_Idx: integer): _HASH_ITEM_;
begin
  Result := _HASH_ITEM_(FList.Objects[_Idx]);
end;

function _HASH_TEMPLATE_.GetKeys(_Idx: integer): string;
begin
  Result := FList[_Idx];
end;

function _HASH_TEMPLATE_.GetValues(const _Key: string): _HASH_ITEM_;
var
  Idx: integer;
begin
  if FList.Find(_Key, Idx) then
    Result := _HASH_ITEM_(FList.Objects[Idx])
  else
    Result := _HASH_EMPTY_ITEM_;
end;

procedure _HASH_TEMPLATE_.SetValues(const _Key: string; _Item: _HASH_ITEM_);
var
  Idx: integer;
begin
  Assert(_Key <> '');
  if FList.Find(_Key, Idx) then begin
    if _Item = _HASH_EMPTY_ITEM_ then
      FList.Delete(Idx)
    else
      FList.Objects[Idx] := _Item;
  end else
    FList.AddObject(_Key, _Item);
end;

{$ENDIF __HASH_TEMPLATE_SECOND_PASS__}

{$IFNDEF __HASH_TEMPLATE__}
{$WARNINGS off}
end.
{$ELSE}
{$DEFINE __HASH_TEMPLATE_SECOND_PASS__}
{$ENDIF __HASH_TEMPLATE__}


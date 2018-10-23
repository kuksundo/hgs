unit Generics.Legacy;

{$WARN SYMBOL_DEPRECATED OFF} // we know that Added and Deleting are deprecated
{$HINTS OFF} // we know we have intentionally hidden some overridden methods

interface

uses Classes;

type
  TCollection<T: TCollectionItem> = class(TCollection)
  private
    procedure Added(var Item: TCollectionItem); overload; override;
    procedure Deleting(Item: TCollectionItem); overload; override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); overload; override;
    procedure SetItemName(Item: TCollectionItem); overload; override;
    procedure Update(Item: TCollectionItem); overload; override;
  protected
    procedure Added(var Item: T); reintroduce; overload; virtual; deprecated;
    procedure Deleting(Item: T); reintroduce; overload; virtual; deprecated;
    function GetItem(Index: Integer): T;
    procedure Notify(Item: T; Action: TCollectionNotification); reintroduce; overload; virtual;
    procedure SetItem(Index: Integer; Value: T);
    procedure SetItemName(Item: T); reintroduce; overload; virtual;
    procedure Update(Item: T); reintroduce; overload; virtual;
  public
    type
      TCollectionEnumerator = class(Classes.TCollectionEnumerator)
      public
        function GetCurrent: T; inline;
        property Current: T read GetCurrent;
      end;

    constructor Create;
    function Add: T;
    function FindItemID(ID: Integer): T;
    function Insert(Index: Integer): T;
    function GetEnumerator: TCollection<T>.TCollectionEnumerator;
    property Items[Index: Integer]: T read GetItem write SetItem;
  end;

  TOwnedCollection<T: TCollectionItem> = class(TCollection<T>)
  private
    FOwner: TPersistent;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
  end;

implementation

{ TCollection<T> }
constructor TCollection<T>.Create;
begin
  inherited Create(T);
end;

function TCollection<T>.Add: T;
begin
  Result := T(inherited Add);
end;

procedure TCollection<T>.Added(var Item: T);
begin
end;

procedure TCollection<T>.Added(var Item: TCollectionItem);
begin
  Added(T(Item));
end;

procedure TCollection<T>.Deleting(Item: T);
begin
end;

procedure TCollection<T>.Deleting(Item: TCollectionItem);
begin
  Deleting(T(Item));
end;

function TCollection<T>.FindItemID(ID: Integer): T;
begin
  Result := T(inherited FindItemID(ID));
end;

function TCollection<T>.GetEnumerator: TCollection<T>.TCollectionEnumerator;
begin
  Result := TCollection<T>.TCollectionEnumerator.Create(Self);
end;

function TCollection<T>.GetItem(Index: Integer): T;
begin
  Result := T(inherited GetItem(Index));
end;

function TCollection<T>.Insert(Index: Integer): T;
begin
  Result := T(inherited Insert(Index));
end;

procedure TCollection<T>.Notify(Item: T; Action: TCollectionNotification);
begin
  inherited Notify(Item, Action);
end;

procedure TCollection<T>.Notify(Item: TCollectionItem; Action: TCollectionNotification);
begin
  Notify(T(Item), Action);
end;

procedure TCollection<T>.SetItem(Index: Integer; Value: T);
begin
  inherited SetItem(Index, Value);
end;

procedure TCollection<T>.SetItemName(Item: T);
begin
  inherited SetItemName(Item);
end;

procedure TCollection<T>.SetItemName(Item: TCollectionItem);
begin
  SetItemName(T(Item));
end;

procedure TCollection<T>.Update(Item: T);
begin
  inherited Update(Item);
end;

procedure TCollection<T>.Update(Item: TCollectionItem);
begin
  Update(T(Item));
end;

{ TCollection<T>.TCollectionEnumerator }
function TCollection<T>.TCollectionEnumerator.GetCurrent: T;
begin
  Result := T(inherited GetCurrent);
end;

{ TOwnedCollection<T> }
constructor TOwnedCollection<T>.Create(AOwner: TPersistent);
begin
  FOwner := AOwner;
  inherited Create;
end;

function TOwnedCollection<T>.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

end.
